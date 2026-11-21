# SPDX-License-Identifier: GPL-3.0-or-later
#
# Custom boot.img / recovery.img packer for Samsung Galaxy Tab 3 Lite 7.0 (goyawifi).
# Packs zImage + DTB + FDT-tail initramfs + /chosen/bootargs for Samsung S-Boot.

GOYA_MKBOOTIMG := device/samsung/goyawifi/bootimg/goyawifi-mkbootimg.py
GOYA_KERNEL_DTB := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/arch/$(TARGET_KERNEL_ARCH)/boot/dts/$(TARGET_KERNEL_DTB)

define build-goyawifi-bootimg
	$(hide) python3 $(GOYA_MKBOOTIMG) \
		--kernel $(1) \
		--dtb $(GOYA_KERNEL_DTB) \
		--ramdisk $(2) \
		--cmdline "$(INTERNAL_KERNEL_CMDLINE)" \
		--base $(BOARD_KERNEL_BASE) \
		--kernel_offset $(BOARD_KERNEL_OFFSET) \
		--ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
		--second_offset $(BOARD_SECOND_OFFSET) \
		--tags_offset $(BOARD_TAGS_OFFSET) \
		--pagesize $(BOARD_KERNEL_PAGESIZE) \
		-o $(3)
endef

$(INSTALLED_BOOTIMAGE_TARGET): $(INTERNAL_BOOTIMAGE_FILES) $(GOYA_MKBOOTIMG) $(MKBOOTIMG)
	$(call pretty,"Target boot image: $@")
	$(call build-goyawifi-bootimg,$(INSTALLED_KERNEL_TARGET),$(INSTALLED_RAMDISK_TARGET),$@)
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)

.PHONY: bootimage-nodeps
bootimage-nodeps: $(GOYA_MKBOOTIMG)
	@echo "make $@: ignoring dependencies"
	$(call build-goyawifi-bootimg,$(INSTALLED_KERNEL_TARGET),$(INSTALLED_RAMDISK_TARGET),$(INSTALLED_BOOTIMAGE_TARGET))
	$(hide) $(call assert-max-image-size,$(INSTALLED_BOOTIMAGE_TARGET),$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)

$(INSTALLED_RECOVERYIMAGE_TARGET): $(recovery_ramdisk) $(recovery_kernel) $(RECOVERYIMAGE_EXTRA_DEPS) $(GOYA_MKBOOTIMG)
	@echo "----- Making recovery image ------"
	$(call build-goyawifi-bootimg,$(recovery_kernel),$(recovery_ramdisk),$@)
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
