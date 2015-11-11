CPUS := $(shell getconf _NPROCESSORS_ONLN)

OUTPUT_DIR := $(PWD)
SCRIPT_DIR := $(OUTPUT_DIR)/scripts
TOOLS_DIR := $(OUTPUT_DIR)/tools
PRELOAD_DIR := $(OUTPUT_DIR)/preloader
OEM_BOOT_DIR := $(OUTPUT_DIR)/oem/boot-assets

# VNEDOR: toolchain from BSP ; DEB: toolchain from deb
TOOLCHAIN := DEB

ARCH := arm
KERNEL_DTS := actduino_bubble_gum_sdboot_linux
KERNEL_DEFCONFIG := actduino_bubble_gum_linux_defconfig
UBOOT_DEFCONFIG := actduino_bubble_gum_v10_defconfig

KERNEL_REPO := https://github.com/xapp-le/kernel.git
KERNEL_BRANCH := master
KERNEL_SRC := $(PWD)/kernel
KERNEL_UIMAGE := $(PWD)/uImage
KERNEL_MODULES := $(PWD)/kernel
KERNEL_OUT := $(PWD)/kernel-build
#KERNEL_DTB := $(KERNEL_SRC)/arch/arm/boot/dts/.dtb

UBOOT_REPO := https://github.com/xapp-le/u-boot.git
UBOOT_BRANCH := master
UBOOT_SRC := $(PWD)/u-boot
UBOOT_BIN := $(UBOOT_SRC)/u-boot.bin
UBOOT_OUT := $(PWD)/u-boot-build

ifeq ($(TOOLCHAIN),VENDOR)
CC :=
else
CC := arm-linux-gnueabihf-
endif
