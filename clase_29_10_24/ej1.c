#include "ej1.h"

uint8_t contar_pagos_aprobados(list_t *pList, char *usuario)
{
  listElem_t *actual = pList->first;
  int conteo = 0;
  while (actual != NULL)
  {
    if (strcmp((actual->data)->cobrador, usuario) == 0 && (actual->data)->aprobado == 1)
    {
      conteo++;
    }
    actual = actual->next;
  }

  return conteo;
}

uint8_t contar_pagos_rechazados(list_t *pList, char *usuario)
{
  listElem_t *actual = pList->first;
  int conteo = 0;
  while (actual != NULL)
  {
    if (strcmp((actual->data)->cobrador, usuario) == 0 && (actual->data)->aprobado == 0)
    {
      conteo++;
    }
    actual = actual->next;
  }

  return conteo;
}

pagoSplitted_t *split_pagos_usuario(list_t *pList, char *usuario)
{

  pagoSplitted_t *res = (pagoSplitted_t *)malloc(sizeof(pagoSplitted_t));
  uint8_t aprobados = contar_pagos_aprobados(pList, usuario);
  uint8_t rechazados = contar_pagos_rechazados(pList, usuario);
  listElem_t *actual = (pList->first);

  pago_t **arr_aprobados = (pago_t **)malloc(aprobados * sizeof(pago_t *));
  pago_t **arr_rechazados = (pago_t **)malloc(rechazados * sizeof(pago_t *));

  aprobados = 0;
  rechazados = 0;

  while (actual != NULL)
  {
    if (strcmp((actual->data)->cobrador, usuario) == 0)
    {
      if ((actual->data)->aprobado == 1)
      {
        arr_aprobados[aprobados] = actual->data;
        aprobados += 1;
      }
      else
      {
        arr_rechazados[rechazados++] = actual->data;
      }
    }
    actual = actual->next;
  }
  res->cant_aprobados = aprobados;
  res->cant_rechazados = rechazados;
  res->aprobados = arr_aprobados;
  res->rechazados = arr_rechazados;

  return res;
}

list_t *listNew()
{
  list_t *l = (list_t *)malloc(sizeof(list_t));
  l->first = NULL;
  l->last = NULL;
  return l;
}

void listAddLast(list_t *pList, pago_t *data)
{
  listElem_t *new_elem = (listElem_t *)malloc(sizeof(listElem_t));
  new_elem->data = data;
  new_elem->next = NULL;
  new_elem->prev = NULL;
  if (pList->first == NULL)
  {
    pList->first = new_elem;
    pList->last = new_elem;
  }
  else
  {
    pList->last->next = new_elem;
    new_elem->prev = pList->last;
    pList->last = new_elem;
  }
}

void listDelete(list_t *pList)
{
  listElem_t *actual = (pList->first);
  listElem_t *next;
  while (actual != NULL)
  {
    next = actual->next;
    free(actual);
    actual = next;
  }
  free(pList);
}
