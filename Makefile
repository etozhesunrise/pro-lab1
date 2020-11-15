all: mmx nommx

run: all
	./lab1-nommx | od --skip-bytes=42 --format=u8
	./lab1-mmx | od --skip-bytes=42 --format=u8

mmx:
	nasm -g -f elf64 -o lab1-mmx.o lab1-mmx.asm
	ld  lab1-mmx.o -o lab1-mmx

nommx:
	nasm -g -f elf64 -o lab1-nommx.o lab1-nommx.asm
	ld  lab1-nommx.o -o lab1-nommx