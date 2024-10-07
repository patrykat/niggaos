KERNEL_SRC = src/kernel/main.c
KERNEL_OBJ = kernel.o
ISO_DIR = iso
GRUB_CFG_DIR = boot/grub
GRUB_CFG = $(GRUB_CFG_DIR)/grub.cfg
KERNEL_ELF = $(ISO_DIR)/boot/kernel.elf
LINKER_SCRIPT = src/linker.ld
ISO_FILE = niggaOS_v0.0.1.iso

CC = gcc
LD = ld
CFLAGS = -ffreestanding -m64 -g -nostdlib -nostartfiles -nodefaultlibs -mno-sse -mno-sse2 -mno-avx
LDFLAGS = -nostdlib -T $(LINKER_SCRIPT)
GRUB_MKRESCUE = grub-mkrescue

all: $(ISO_FILE)

$(KERNEL_OBJ): $(KERNEL_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

$(KERNEL_ELF): $(KERNEL_OBJ) $(LINKER_SCRIPT)
	mkdir -p $(ISO_DIR)/boot
	$(LD) $(LDFLAGS) -o $@ $(KERNEL_OBJ)

$(ISO_FILE): $(KERNEL_ELF) $(GRUB_CFG)
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(GRUB_CFG) $(ISO_DIR)/boot/grub/
	$(GRUB_MKRESCUE) -o $@ $(ISO_DIR)

run: $(ISO_FILE)
	qemu-system-x86_64 -cdrom niggaOS_v0.0.1.iso

clean:
	rm -f $(KERNEL_OBJ) $(KERNEL_ELF) $(ISO_FILE)
	rm -rf $(ISO_DIR)
