NASM:=nasm
NASMFLAGS:=-Wall -f elf32 -g -Wall

SRCS:= helloWorld.asm

TARGET:=helloWorld

OBJS=$(SRCS:.asm=.o)

all: $(TARGET)

%.o: %.asm 
	$(NASM) $(NASMFLAGS) $< -o $@

$(TARGET): $(OBJS)
	ld -m elf_i386 -o $@ $^

clean:
	rm -f *.o
	rm -f sumador