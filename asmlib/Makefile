CC = fasm
LIBS = fmt.asm str.asm sys.asm mth.asm
LIBS_OBJ = fmt.o str.o sys.o mth.o
.PHONY: default compile build run
default: build run
compile: $(LIBS)
	$(CC) fmt.asm && $(CC) str.asm && $(CC) sys.asm && $(CC) mth.asm

build: main.asm $(LIBS_OBJ)
	$(CC) main.asm
	ld main.o $(LIBS_OBJ) -o main

once: main.asm
	$(CC) main.asm
	ld main.o -o main

dump: main
	objdump -S -M intel -d main > obj.dump
	cat obj.dump

hex: main
	hexeditor main

run: main
	./main	