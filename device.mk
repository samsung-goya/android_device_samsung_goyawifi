# SPDX-License-Identifier: GPL-3.0-or-later
#
# Device configuration for Samsung Galaxy Tab 3 Lite 7.0 Wi-Fi (SM-T110 / goyawifi)

# Screen & Density
PRODUCT_AAPT_CONFIG := normal large xlarge mdpi hdpi
PRODUCT_AAPT_PREF_CONFIG := mdpi
DEVICE_PACKAGE_OVERLAYS += device/samsung/goyawifi/overlay

# Wi-Fi only tablet (no RIL / telephony)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.radio.noril=true \
    ro.carrier=unknown

# System properties
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.adb.secure=0

PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.first_api_level=28 \
    ro.sf.lcd_density=160 \
    ro.sf.hwrotation=270 \
    ro.minui.default_rotation=ROTATION_LEFT \
    hal.camera.0=0,90 \
    ro.opengles.version=131072 \
    hwc.drm.device=/dev/dri/card1 \
    persist.sys.usb.config=adb \
    wifi.interface=wlan0 \
    ro.sys.sdcardfs=true \
    ro.config.zram=true

# Low-RAM, ART/dexopt, LMKD, and Dalvik heap optimizations (~962 MiB usable RAM + 96 MiB CMA)
$(call inherit-product, device/samsung/goyawifi/lowram.mk)

# Health HAL & Off-mode charger (uses standard 4.19 power_supply: battery + smb328-charger)
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-impl \
    android.hardware.health@2.0-service \
    charger_res_images

# ConfigStore & Gatekeeper/Keymaster (software fallback for Non-Treble)
PRODUCT_PACKAGES += \
    android.hardware.configstore@1.1-service \
    android.hardware.gatekeeper@1.0-service.software \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# USB ConfigFS
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service.basic

# Camera app
PRODUCT_PACKAGES += \
    Snap

# Rootdir & Init scripts
PRODUCT_PACKAGES += \
    fstab.pxa988 \
    init.pxa988.rc \
    init.pxa988.usb.rc \
    init.goyawifi.rc \
    init.recovery.pxa988.rc \
    ueventd.pxa988.rc \
    init.goyawifi.wifi_bt.sh

# Input keylayouts & touchscreen IDC
PRODUCT_COPY_FILES += \
    device/samsung/goyawifi/configs/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    device/samsung/goyawifi/configs/keylayout/88pm80x_on.kl:system/usr/keylayout/88pm80x_on.kl \
    device/samsung/goyawifi/configs/keylayout/Zinitix_Capacitive_TouchScreen.kl:system/usr/keylayout/Zinitix_Capacitive_TouchScreen.kl \
    device/samsung/goyawifi/configs/idc/Zinitix_Capacitive_TouchScreen.idc:system/usr/idc/Zinitix_Capacitive_TouchScreen.idc

# Hardware feature permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml

# Audio configuration
PRODUCT_COPY_FILES += \
    device/samsung/goyawifi/configs/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    device/samsung/goyawifi/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

# Media & CODA7542 VPU codecs configuration
PRODUCT_COPY_FILES += \
    device/samsung/goyawifi/configs/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    device/samsung/goyawifi/configs/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    device/samsung/goyawifi/configs/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
    device/samsung/goyawifi/configs/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml

# Wi-Fi configuration
PRODUCT_COPY_FILES += \
    external/wpa_supplicant_8/wpa_supplicant/wpa_supplicant_template.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    external/wpa_supplicant_8/wpa_supplicant/wpa_supplicant_template.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant.conf \
    device/samsung/goyawifi/configs/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
    device/samsung/goyawifi/configs/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf

# Include firmware-only vendor tree & common Marvell PXA HALs
$(call inherit-product, vendor/samsung/goyawifi/goyawifi-vendor.mk)
$(call inherit-product-if-exists, hardware/marvell/pxa-common/pxa-common.mk)
