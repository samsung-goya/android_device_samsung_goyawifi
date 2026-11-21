#!/vendor/bin/sh
# SPDX-License-Identifier: Apache-2.0
#
# Load Marvell SD8777 Wi-Fi (mwifiex_sdio) and Bluetooth (btmrvl_sdio) modules
# with MAC addresses provisioned from /efs.

WIFI_CACHE=/data/vendor/wifi/mac.info
BT_CACHE=/data/vendor/bluetooth/bt_addr
WPA_CONF=/data/vendor/wifi/wpa/wpa_supplicant.conf

# Remove any stale control sockets left by an unclean shutdown
rm -f /data/vendor/wifi/wpa/sockets/*

# Seed writable supplicant configuration on first boot, preserving saved networks.
if [ ! -f "$WPA_CONF" ]; then
    if /system/bin/cp /vendor/etc/wifi/wpa_supplicant.conf "$WPA_CONF"; then
        chown wifi:wifi "$WPA_CONF"
        chmod 0660 "$WPA_CONF"
        log -t goyawifi-wifi "Seeded initial supplicant configuration"
    else
        log -t goyawifi-wifi "Could not seed supplicant configuration"
    fi
fi

is_valid_mac() {
    [ -f "$1" ] && grep -Eq '^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$' "$1"
}

derive_mac() {
    local prefix="$1"
    local serial
    serial=$(getprop ro.serialno)
    [ -z "$serial" ] && serial="goyawifi"
    local hash
    hash=$(echo -n "${prefix}-${serial}" | md5sum | cut -c1-10)
    echo "02:${hash:0:2}:${hash:2:2}:${hash:4:2}:${hash:6:2}:${hash:8:2}"
}

if is_valid_mac /efs/wifi/.mac.info; then
    WIFI_MAC=$(tr -d ' \r\n' < /efs/wifi/.mac.info)
elif is_valid_mac "$WIFI_CACHE"; then
    WIFI_MAC=$(tr -d ' \r\n' < "$WIFI_CACHE")
else
    WIFI_MAC=$(derive_mac "wifi")
    echo "$WIFI_MAC" > "$WIFI_CACHE"
    chmod 0640 "$WIFI_CACHE"
    chown wifi:wifi "$WIFI_CACHE"
fi

if is_valid_mac /efs/bluetooth/bt_addr; then
    BT_MAC=$(tr -d ' \r\n' < /efs/bluetooth/bt_addr)
elif is_valid_mac "$BT_CACHE"; then
    BT_MAC=$(tr -d ' \r\n' < "$BT_CACHE")
else
    BT_MAC=$(derive_mac "bt")
    echo "$BT_MAC" > "$BT_CACHE"
    chmod 0640 "$BT_CACHE"
    chown bluetooth:bluetooth "$BT_CACHE"
fi

# Load Wi-Fi driver (downloads mrvl/sd8777_uapsta.bin + cal_data.conf)
insmod /vendor/lib/modules/mwifiex.ko cal_data_cfg=mrvl/cal_data.conf
insmod /vendor/lib/modules/mwifiex_sdio.ko

# rfkill0 is created by the mwifiex probe, so setting its ownership in the
# early init boot action is too soon. Grant the Wi-Fi HAL access now.
i=0
while [ ! -e /sys/class/rfkill/rfkill0/state ] && [ "$i" -lt 100 ]; do
    i=$((i + 1))
    sleep 0.1
done
if [ -e /sys/class/rfkill/rfkill0/state ]; then
    if chown wifi:wifi /sys/class/rfkill/rfkill0/state && \
            chmod 0660 /sys/class/rfkill/rfkill0/state; then
        log -t goyawifi-wifi "Granted Wi-Fi HAL access to rfkill state"
    else
        log -t goyawifi-wifi "Failed to grant Wi-Fi HAL access to rfkill state"
    fi
else
    log -t goyawifi-wifi "Timed out waiting for rfkill0 state"
fi

# Wait for mlan0, set EFS MAC, and rename to wlan0 for Android Wi-Fi framework.
# Use a shell counter rather than seq so this works with the minimal vendor PATH.
i=0
while [ "$i" -lt 100 ]; do
    if [ -d /sys/class/net/wlan0 ]; then
        log -t goyawifi-wifi "Wi-Fi interface is already wlan0"
        break
    fi
    if [ -d /sys/class/net/mlan0 ]; then
        if ! /system/bin/ip link set dev mlan0 down; then
            log -t goyawifi-wifi "Failed to bring mlan0 down"
            break
        fi
        if ! /system/bin/ip link set dev mlan0 address "$WIFI_MAC"; then
            log -t goyawifi-wifi "Failed to set Wi-Fi MAC on mlan0"
        fi
        if ! /system/bin/ip link set dev mlan0 name wlan0; then
            log -t goyawifi-wifi "Failed to rename mlan0 to wlan0"
            break
        fi
        if [ -d /sys/class/net/wlan0 ]; then
            log -t goyawifi-wifi "Renamed mlan0 to wlan0"
        else
            log -t goyawifi-wifi "Rename command returned success but wlan0 is absent"
        fi
        break
    fi
    i=$((i + 1))
    sleep 0.1
done
if [ ! -d /sys/class/net/wlan0 ]; then
    log -t goyawifi-wifi "Timed out waiting for wlan0; Android Wi-Fi will not start"
else
    # Create p2p0 virtual interface on phy0 for Wi-Fi Direct (ISupplicantP2pIface)
    if [ ! -d /sys/class/net/p2p0 ]; then
        if /system/bin/iw phy phy0 interface add p2p0 type __p2pcl; then
            first_byte=$((0x${WIFI_MAC:0:2} | 0x02))
            P2P_MAC=$(printf "%02x:%s" "$first_byte" "${WIFI_MAC:3}")
            if [ "$P2P_MAC" = "$WIFI_MAC" ]; then
                first_byte=$((first_byte ^ 0x04))
                P2P_MAC=$(printf "%02x:%s" "$first_byte" "${WIFI_MAC:3}")
            fi
            /system/bin/ip link set dev p2p0 down
            /system/bin/ip link set dev p2p0 address "$P2P_MAC"
            log -t goyawifi-wifi "Created p2p0 interface with MAC $P2P_MAC"
        else
            log -t goyawifi-wifi "Failed to create p2p0 interface"
        fi
    fi
fi

# Load Bluetooth driver (shares combo firmware loaded by mwifiex_sdio)
insmod /vendor/lib/modules/btmrvl.ko bdaddr="$BT_MAC"
insmod /vendor/lib/modules/btmrvl_sdio.ko
