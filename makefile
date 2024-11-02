
all: chdir.asm
	asm02 -L -b chdir.asm
	@rm chdir.build

clean:
	@rm -f chdir.bin chdir.lst

