# SPDX-License-Identifier: GPL-3.0-or-later
#
# Low-RAM & ART/dexopt optimizations for Samsung Galaxy Tab 3 Lite 7.0 Wi-Fi (goyawifi)
# Hardware profile: Dual-core Cortex-A9 (PXA986), ~962 MiB usable RAM (1 GiB LPDDR2
# minus carveouts, with 96 MiB shared CMA), 512 MiB zRAM, 1024x600 mdpi display.

# Enable Android Go low-RAM mode in framework, SystemUI, Launcher3, and WebView.
# Also enables per-app memcg tracking in lmkd (supported by our 4.19 kernel).
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.low_ram=true \
    ro.statsd.enable=false \
    ro.config.max_starting_bg=3

# LMKD tuning (balanced for ~962 MiB RAM + 512 MiB zRAM):
# Upgrade to critical pressure when thrashing (>40%), kill lowest-priority tasks first.
# Keep default ro.lmk.medium=800 (instead of 512 MiB Go's 700) so PREVIOUS_APP_ADJ (700)
# stays alive when switching between two apps.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lmk.critical_upgrade=true \
    ro.lmk.upgrade_pressure=40 \
    ro.lmk.downgrade_pressure=60 \
    ro.lmk.kill_heaviest_task=false

# Package Manager / ART dexopt policy:
# - Use speed-profile at install instead of LOS 14.1's "speed" (avoids slow AOT compiles
#   on dual-core Cortex-A9 and prevents cold-method RAM/storage bloat).
# - Keep shared APKs (e.g. GMS/WebView) on quicken to avoid AOT code expansion across processes.
# - Downgrade unused apps after 10 days to reclaim RAM and /data space.
PRODUCT_PROPERTY_OVERRIDES += \
    pm.dexopt.install=speed-profile \
    pm.dexopt.bg-dexopt=speed-profile \
    pm.dexopt.shared=quicken \
    pm.dexopt.downgrade_after_inactive_days=10

# Dalvik / ART heap & dex2oat tuning:
# - Cap largeHeap at 256m (down from 384m) and growthlimit at 96m (up from 80m).
# - Cap dex2oat-Xmx at 256m (down from 512m) so dex2oat doesn't starve RAM/CMA.
# - Limit dex2oat threads to 2 (matching dual-core A9) and use madvise-random.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heapgrowthlimit=96m \
    dalvik.vm.heapsize=256m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=8m \
    dalvik.vm.dex2oat-Xmx=256m \
    dalvik.vm.dex2oat-threads=2 \
    dalvik.vm.boot-dex2oat-threads=2 \
    dalvik.vm.madvise-random=true

# Build-time ART / dexpreopt optimizations (reduces /system & RAM footprint)
PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile
PRODUCT_ALWAYS_PREOPT_EXTRACTED_APK := true
PRODUCT_USE_PROFILE_FOR_BOOT_IMAGE := true
PRODUCT_DEX_PREOPT_BOOT_IMAGE_PROFILE_LOCATION := frameworks/base/config/boot-image-profile.txt
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
