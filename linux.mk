include common.mk

V := 0

all: build

clean:
		if test -d "$(KERNEL_SRC)" ; then $(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(KERNEL_SRC) mrproper ; fi
		rm -f $(KERNEL_UIMAGE)

distclean: clean
		rm -rf $(wildcard $(KERNEL_SRC))

$(KERNEL_SRC):
		git clone --depth=1 $(KERNEL_REPO) -b $(KERNEL_BRANCH) kernel

$(KERNEL_SRC)/.config: $(KERNEL_SRC)
		$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(KERNEL_SRC) $(KERNEL_DEFCONFIG)

$(KERNEL_UIMAGE): $(KERNEL_SRC)/.config
		echo "building kernel and make image"
		rm -f $(KERNEL_SRC)/arch/arm/boot/zImage
		rm -f $(KERNEL_UIMAGE)
		$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(KERNEL_SRC) -j$(CPUS) V=$(V)

kernel: $(KERNEL_UIMAGE)
		mkimage -A arm -O linux -T kernel -C none -a 80008000 -e 80008000 -n "Linux Kernel Image" -d  $(KERNEL_SRC)/arch/arm/boot/zImage uImage

modules: $(KERNEL_SRC)/.config
		$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(KERNEL_SRC) -j$(CPUS) modules

build: kernel

.PHONY: kernel modules build
