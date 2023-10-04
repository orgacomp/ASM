NASM:=nasm
NASMFLAGS:=-Wall -f elf64 -g -Wall

TARGET:=vector

SRCS:= vector.asm

OBJS=$(SRCS:.asm=.o)

all: $(TARGET)

%.o: %.asm 
	$(NASM) $(NASMFLAGS) $< -o $@

$(TARGET): $(OBJS)
	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -o $@ $^ 

clean:
	rm -f *.o
	rm -f $(TARGET)