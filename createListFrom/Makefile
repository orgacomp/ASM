NASM:=nasm
NASMFLAGS:=-Wall -f elf64 -g -Wall
CC:=gcc
CFLAGS:=-std=c11 -m64 -no-pie -Wall -Wextra -pedantic -O0 -ggdb -MMD -MP -z noexecstack

SRCS:= createListFrom.asm main.c lib.c createListFrom_c.c

TARGET:= test_createListFrom
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
    
