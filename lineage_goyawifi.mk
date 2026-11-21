# SPDX-License-Identifier: Apache-2.0
#
# LineageOS 16.0 product definition for Samsung Galaxy Tab 3 Lite 7.0 (SM-T110 / goyawifi)

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, device/samsung/goyawifi/device.mk)
$(call inherit-product, vendor/lineage/config/common_full_tablet_wifionly.mk)

# Wi-Fi only tablet: exclude persistent/unused telephony services (~23 MiB RAM saved)
PRODUCT_PACKAGES += goyawifi_no_telephony

PRODUCT_NAME := lineage_goyawifi
PRODUCT_DEVICE := goyawifi
PRODUCT_BRAND := samsung
PRODUCT_MANUFACTURER := samsung
PRODUCT_MODEL := SM-T110

PRODUCT_CHARACTERISTICS := tablet

BUILD_FINGERPRINT := samsung/goyawifi/goyawifi:9/PQ3A.190801.002/1:userdebug/test-keys

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=goyawifi \
    TARGET_DEVICE=goyawifi \
    PRIVATE_BUILD_DESC="goyawifi-userdebug 9 PQ3A.190801.002 1 test-keys" \
    BUILD_FINGERPRINT=$(BUILD_FINGERPRINT)
