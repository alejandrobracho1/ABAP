*&---------------------------------------------------------------------*
*& Report  Z_PRUEBA1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  Z_PRUEBA1.

INCLUDE: Z_PRUEBA_TOP,
         Z_PRUEBA1_PBO,
         Z_PRUEBA1_PAI,
         Z_PRUEBA1_F01,
         Z_PRUEBA_CLS1.


START-OF-SELECTION.

CREATE OBJECT obj_alv.

CALL METHOD obj_alv->get_data.
CALL METHOD obj_alv->show_alv.

CALL SCREEN 0001.