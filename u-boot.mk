include common.mk

# for preloader packaging
ifneq "$(findstring ARM, $(shell grep -m 1 'model name.*: ARM' /proc/cpuinfo))" ""
BOOTLOADER_PACK=bootloader_pack.arm
else
BOOTLOADER_PACK=bootloader_pack
endif

all: build

clean:
		if test -d "$(UBOOT_SRC)" ; then $(MAKE) ARCH=arm CROSS_COMPILE=${CC} -C $(UBOOT_SRC) clean ; fi
			rm -f $(UBOOT_BIN)

distclean:
		rm -rf $(wildcard $(UBOOT_SRC))

$(UBOOT_BIN): $(UBOOT_SRC)
		mkdir -p $(UBOOT_OUT)
		$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=${CC} -C $(UBOOT_SRC) KBUILD_OUTPUT=$(UBOOT_OUT) $(UBOOT_DEFCONFIG)
		$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=${CC} -C $(UBOOT_SRC) KBUILD_OUTPUT=$(UBOOT_OUT) -j$(CPUS) all u-boot-dtb.img
		cd $(SCRIPT_DIR) && ./padbootloader $(UBOOT_OUT)/u-boot-dtb.img

$(UBOOT_SRC):
		git clone --depth=1 $(UBOOT_REPO) -b $(UBOOT_BRANCH) u-boot

preloader:
		cd $(TOOLS_DIR)/utils && ./$(BOOTLOADER_PACK) $(PRELOAD_DIR)/bootloader.bin $(PRELOAD_DIR)/bootloader.ini $(OEM_BOOT_DIR)/bootloader.bin

u-boot: preloader $(UBOOT_BIN)

build: u-boot

.PHONY: u-boot build
