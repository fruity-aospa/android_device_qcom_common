#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(call is-board-platform-in-list,$(6_1_FAMILY)),true)
  TARGET_ADRENO_DIR ?= u
else ifeq ($(call is-board-platform-in-list,$(5_15_FAMILY)),true)
  TARGET_ADRENO_DIR ?= t
else ifeq ($(call is-board-platform-in-list,$(5_10_FAMILY)),true)
  TARGET_ADRENO_DIR ?= s
else ifeq ($(call is-board-platform-in-list,$(4_14_FAMILY) $(4_19_FAMILY) $(5_4_FAMILY)),true)
  TARGET_ADRENO_DIR ?= r
else
  $(error "Adreno component is enabled, but there is not a directory available for your platform.")
endif

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml

# Properties
PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.egl=adreno \
    ro.hardware.vulkan=adreno \
    ro.opengles.version=196610

ifeq ($(TARGET_ADRENO_DIR),r)
PRODUCT_VENDOR_PROPERTIES += \
    graphics.gpu.profiler.support=true
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, device/qcom/common/vendor/adreno/$(TARGET_ADRENO_DIR)/qti-adreno.mk)
#
# Some device blob trees (e.g. Nothing asteroids) carry the full GPU driver
# set from the device's own extraction. Honor an opt-out so both sources
# don't end up defining the same modules.
ifneq ($(TARGET_ADRENO_SKIP_VENDOR_BLOBS),true)
$(call inherit-product-if-exists, vendor/qcom/common/vendor/adreno/$(TARGET_ADRENO_DIR)/adreno-vendor.mk)
endif
