*&---------------------------------------------------------------------*
*&  Include           Z_PRUEBA_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS slis.

*======================= TABLAS =========================*
TABLES: VBAK, VBAP.

TYPES: BEGIN OF ty_factura,
         factura     TYPE vbak-vbeln, " Número de factura
         posicion    TYPE vbap-posnr, "Posicion
         material    TYPE vbap-matnr, " Material
         descripcion TYPE vbap-matwa,
         cantidad    TYPE vbap-kwmeng, " Cantidad
         precio      TYPE vbap-netwr, " Precio
         total       TYPE f,      " Precio total
       END OF ty_factura.

DATA: it_facturas TYPE TABLE OF ty_factura,
      it_fcat     TYPE STANDARD TABLE OF lvc_s_fcat,
      it_vbfa     TYPE TABLE OF vbfa,
      wa_vbfa     TYPE vbfa.

*==========================================================*

*============ TDECLARACION DE VARIABLES ============*
DATA: OK_CODE      TYPE sy-ucomm, "Dynpro
      vg_container TYPE REF TO cl_gui_custom_container,
      obj_alv_grid TYPE REF TO cl_gui_alv_grid.

DATA: i_lines type i.
DATA: abap TYPE bool,
      gv_layout TYPE slis_layout_alv.
abap = 'X'.


FIELD-SYMBOLS: <fs_factura> TYPE ty_factura.
*===================================================*



*============ DECLARACION DE CLASES ============*
CLASS cls_alv     DEFINITION DEFERRED.
DATA: obj_alv     TYPE REF TO cls_alv.
*===============================================*


*=======================================================================*
*============== PANTALLA DE SELECCIÓN ==================================*
SELECTION-SCREEN BEGIN OF BLOCK screen1 WITH FRAME TITLE text-000.
  PARAMETERS: p_vbak TYPE vbak-vbeln.
SELECTION-SCREEN END OF BLOCK screen1.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-004.
SELECTION-SCREEN COMMENT /1(79) text-005.
SELECTION-SCREEN END OF BLOCK b1.
*=======================================================================*