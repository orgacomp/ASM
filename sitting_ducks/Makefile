NASM:=nasm
NASMFLAGS:=-Wall -f elf64 -g -Wall -w-reloc-rel-dword 
CC:=gcc
CFLAGS:=-std=c11 -m64 -no-pie -Wall -Wextra -pedantic -O0 -ggdb -MMD -MP -z noexecstack

SRCS:= sitting_ducks_asm.asm sitting_ducks_c.c main.c 

TARGET:= sitting_ducks
OBJS := $(addsuffix .o,$(basename $(SRCS)))

.PHONY: clean all

all: $(TARGET)

%.o: %.asm 
	$(NASM) $(NASMFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJS)
	gcc $(CFLAGS) -o $@ $^

clean:
	rm -f *.o $(TARGET) *.d

-include $(OBJS:.o=.d)    
    
