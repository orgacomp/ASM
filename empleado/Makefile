CC=gcc
CFLAGS= -std=c11 -no-pie -Wall -Wextra -pedantic -O0 -g -Wno-unused-variable -Wno-unused-parameter -znoexecstack
NASM:=nasm
NASMFLAGS:=-Wall -f elf64 -g -Wall

TARGET:=main

all: $(TARGET)

empleado.o: empleado.asm 
	$(NASM) $(NASMFLAGS) $< -o $@

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): empleado.o main.o
	gcc $(CFLAGS) $^  -o $@  

clean:
	rm -f *.o
	rm -f $(TARGET)