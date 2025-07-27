NASM = nasm
CC = clang
OBJCOPY = objcopy

CFLAGS = -m32 -ffreestanding -c
LDFLAGS = -T linker.ld

BOOT_SRC = boot.asm
KERNEL_SRC = kernel.c
KERNEL_OBJ = kernel.o
KERNEL_BIN = kernel.bin
BOOT_BIN = boot.bin

KILLOS_IMG = KillOS.img
ASM_IMAGES = terminal.img

all: $(KILLOS_IMG) $(ASM_IMAGES)

$(BOOT_BIN): $(BOOT_SRC)
	$(NASM) -f bin $< -o $@

$(KERNEL_OBJ): $(KERNEL_SRC)
	$(CC) $(CFLAGS) $< -o $@

$(KERNEL_BIN): $(KERNEL_OBJ) linker.ld
	clang -target i386-elf -ffreestanding -nostdlib -Wl,-T,linker.ld -o kernel.elf $(KERNEL_OBJ)
	objcopy -O binary kernel.elf $@

$(KILLOS_IMG): $(BOOT_BIN) $(KERNEL_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(KILLOS_IMG)

%.img: %.asm
	$(NASM) -f bin $< -o $@

run: $(KILLOS_IMG)
	qemu-system-i386 -nographic -fda $(KILLOS_IMG)

clean:
	rm -f *.bin *.o *.elf *.img $(KILLOS_IMG)

.PHONY: all run clean
