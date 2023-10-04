NASM:=nasm
NASMFLAGS:=-Wall -f elf64 -g -Wall
CC:=gcc
CFLAGS:=-std=c11 -m64 -no-pie -Wall -Wextra -pedantic -O0 -g -z noexecstack

SRCS:= funcs_asm.asm funcs_c.c main.c

TARGET:=sumador
OBJS := $(addsuffix .o,$(basename $(SRCS)))

all: $(TARGET)

%.o: %.asm 
	$(NASM) $(NASMFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJS)
	gcc $(CFLAGS) -o $@ $^

clean:
	rm -f *.o
	rm -f sumador