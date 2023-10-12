#include <stdlib.h> 
#include <stdint.h>

typedef enum e_type {
	TypeNone = 0,
	TypeInt = 1,
	TypeString = 2,
	TypeCard = 3
} type_t;

typedef struct s_list {
	type_t   type;
	uint8_t  size;
	struct s_listElem* first;
	struct s_listElem* last;
} list_t;

typedef struct s_listElem {
	void* data;
	struct s_listElem* next;
	struct s_listElem* prev;
} listElem_t;

typedef struct s_card {
	char*     suit;
	int32_t* number;
	list_t* stacked;
} card_t;

card_t*  cardNew(char* suit, int32_t* number){
    card_t *mi_carta = (card_t*) malloc(sizeof(card_t));
    if (mi_carta == NULL){

    }
    mi_carta->suit = suit;
    (*mi_carta).suit = suit;
    //

    // error:
    card_t mi_carta_mal;
    mi_carta_mal.suit = suit;

    return &mi_carta_mal;

    funcClone_t* fclone =  getCloneFunction(TypeInt);
}


int main(){
    typedef uint8_t edad_t;
    struct s_list mi_lista;
    list_t mi_lista2;


    return 0;
}