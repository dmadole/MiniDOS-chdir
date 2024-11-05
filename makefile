
all: chdir.bin

lbr: chdir.lbr

clean:
	rm -f chdir.lst
	rm -f chdir.bin
	rm -f chdir.lbr

chdir.bin: chdir.asm include/bios.inc include/kernel.inc
	asm02 -L -b chdir.asm
	rm -f chdir.build

chdir.lbr: chdir.bin
	rm -f chdir.lbr
	lbradd chdir.lbr chdir.bin

