# SPDX-License-Identifier: Apache-2.0
LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),goyawifi)
include $(call all-makefiles-under,$(LOCAL_PATH))
include hardware/marvell/pxa-common/Android.mk

include $(CLEAR_VARS)
LOCAL_MODULE := goyawifi_no_telephony
LOCAL_MODULE_TAGS := optional
LOCAL_OVERRIDES_PACKAGES := TeleService WAPPushManager
include $(BUILD_PHONY_PACKAGE)
endif
