#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "ej1.h"

int main (void){
	
  list_t* list=listNew();
  
  pago_t p1;
  p1.monto=1;
  p1.cobrador="susan";
  p1.pagador="bob";
  p1.aprobado=0;

  pago_t p2;
  p2.monto=10;
  p2.cobrador="susan";
  p2.pagador="bob";
  p2.aprobado=1;

  pago_t p3;
  p3.monto=10;
  p3.cobrador="susan";
  p3.pagador="bob";
  p3.aprobado=1;

  pago_t p4;
  p4.monto=5;
  p4.cobrador="susan";
  p4.pagador="nicolas";
  p4.aprobado=1;

  pago_t p5;
  p5.monto=50;
  p5.cobrador="bob";
  p5.pagador="paul";
  p5.aprobado=0;


  pago_t p6;
  p6.monto=50;
  p6.cobrador="bob";
  p6.pagador="paul";
  p6.aprobado=1;


  pago_t p7;
  p7.monto=5;
  p7.cobrador="bob";
  p7.pagador="josh";
  p7.aprobado=1;

  pago_t p8;
  p8.monto=25;
  p8.cobrador="nicolas";
  p8.pagador="susan";
  p8.aprobado=1;

  pago_t p9;
  p9.monto=25;
  p9.cobrador="nicolas";
  p9.pagador="susan";
  p9.aprobado=0;

  pago_t p10;
  p10.monto=25;
  p10.cobrador="paul";
  p10.pagador="bob";
  p10.aprobado=0;


  listAddLast(list,&p1);
  listAddLast(list,&p2);
  listAddLast(list,&p3);
  listAddLast(list,&p4);
  listAddLast(list,&p5);
  listAddLast(list,&p6);
  listAddLast(list,&p7);
  listAddLast(list,&p8);
  listAddLast(list,&p9);
  listAddLast(list,&p10);
  
  // Acá pueden probar su código


	return 0;    
}


