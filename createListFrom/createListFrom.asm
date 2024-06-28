section .text
global createListFrom

extern createListFrom_c
extern arrayNew

%define ARRAY_TYPE 0
%define ARRAY_SIZE 4
%define ARRAY_CAPACITY 5
%define ARRAY_DATA 8

;list_t *createListFrom(array_t* array)

createListFrom:

    ret
