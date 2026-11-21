# SPDX-License-Identifier: Apache-2.0
#
# BoardConfig for Samsung Galaxy Tab 3 Lite 7.0 Wi-Fi (SM-T110 / goyawifi)
# SoC: Marvell PXA986 (PXA988 family, dual Cortex-A9 r3p0)
# Kernel: Linux 4.19.325 LTS

# Architecture
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a9

# Platform
TARGET_BOARD_PLATFORM := pxa988
TARGET_BOOTLOADER_BOARD_NAME := PXA986
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true
TARGET_USES_64_BIT_BINDER := true

# Inline Kernel Build
TARGET_KERNEL_SOURCE := kernel/samsung/goyawifi
TARGET_KERNEL_CONFIG := goyawifi_android_defconfig
TARGET_KERNEL_ARCH := arm
BOARD_KERNEL_IMAGE_NAME := zImage
TARGET_KERNEL_DTB := pxa986-samsung-goyawifi.dtb

# Boot Image & Custom S-Boot FDT-Tail Packer
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_SECOND_OFFSET := 0x00f00000
BOARD_TAGS_OFFSET := 0x00000100
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_CMDLINE := console=ttyS0,115200n8 console=tty0 earlyprintk panic=5 printk.devkmsg=on firmware_class.path=/vendor/firmware androidboot.hardware=pxa988 androidboot.boot_devices=soc/d4200000.axi/d4281000.sdh androidboot.selinux=permissive
BOARD_CUSTOM_BOOTIMG := true
BOARD_CUSTOM_BOOTIMG_MK := device/samsung/goyawifi/bootimg/custom_bootimg.mk

# Partitions (Verified from SM-T110 eMMC GPT)
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USES_MKE2FS := true
TARGET_COPY_OUT_VENDOR := system/vendor
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1594884096
BOARD_CACHEIMAGE_PARTITION_SIZE := 360710144
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_PARTITION_SIZE := 5509218304
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_FLASH_BLOCK_SIZE := 131072
TARGET_RECOVERY_FSTAB := device/samsung/goyawifi/rootdir/etc/fstab.pxa988

# Graphics (Open-source Mesa3D etnaviv + gbm_gralloc + drm_hwcomposer in Phase 3)
TARGET_SCREEN_WIDTH := 600
TARGET_SCREEN_HEIGHT := 1024
SF_PRIMARY_DISPLAY_ORIENTATION := 270
TARGET_USES_HWC2 := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
USE_OPENGL_RENDERER := true

# Wi-Fi (Upstream mwifiex_sdio via cfg80211/nl80211)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_HOSTAPD_DRIVER := NL80211
WIFI_HIDL_FEATURE_DISABLE_AP_MAC_RANDOMIZATION := true

# Bluetooth (Upstream btmrvl_sdio via hci0)
BOARD_HAVE_BLUETOOTH := true

# Audio
BOARD_USES_ALSA_AUDIO := true
USE_XML_AUDIO_POLICY_CONF := 1

# VINTF (Non-Treble Legacy Mode)
DEVICE_MANIFEST_FILE := device/samsung/goyawifi/manifest.xml

# Dexpreopt: Pre-optimize boot image, system server, and system apps
WITH_DEXPREOPT := true
WITH_DEXPREOPT_BOOT_IMG_AND_SYSTEM_SERVER_ONLY := false

# Charger (LPM off-mode charging) & Recovery UI pixel format
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_DEFAULT_ROTATION := ROTATION_LEFT

# SELinux
BOARD_SEPOLICY_DIRS += device/samsung/goyawifi/sepolicy

# Common Marvell PXA platform rules
-include hardware/marvell/pxa-common/BoardConfigCommon.mk
