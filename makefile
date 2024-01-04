.PHONY: clean all upload

# -c: Instruct compiler to *just* compile.

all: output/final.elf

output/main.o: main.c
	mkdir -p output
	arm-none-eabi-gcc -c -mcpu=cortex-m4 -mthumb main.c -o output/main.o

output/stm32_startup.o: stm32_startup.c
	mkdir -p output
	arm-none-eabi-gcc -c -mcpu=cortex-m4 -mthumb stm32_startup.c -o output/stm32_startup.o

output/final.elf: output/main.o output/stm32_startup.o
	mkdir -p output

#	Note: -Map is a linker argument, so it has to be preceded with: -Wl, .
	arm-none-eabi-gcc -nostdlib -T stm32_ls.ld -Wl,-Map=output/final.map output/*.o -o output/final.elf


upload:
	openocd -f /usr/share/openocd/scripts/board/stm32f4discovery.cfg -c "program output/final.elf verify reset exit"

clean:
	rm -rf output
