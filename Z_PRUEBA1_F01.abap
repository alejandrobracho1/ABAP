*&---------------------------------------------------------------------*
*&  Include           Z_PRUEBA1_F01
*&---------------------------------------------------------------------*
TYPE-POOLS: slis.

*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_data.

  SELECT v~vbeln p~posnr p~matnr p~matwa p~kwmeng p~netwr
  INTO TABLE it_facturas
  FROM vbak AS v
  INNER JOIN vbap AS p ON v~vbeln = p~vbeln.

  LOOP AT it_facturas ASSIGNING <fs_factura>.
    <fs_factura>-total = <fs_factura>-cantidad * <fs_factura>-precio.
  ENDLOOP.

ENDFORM.                    "get_data

*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BUILD_FIELDCAT .
  DATA wa_fieldcat TYPE lvc_s_fcat.

    wa_fieldcat-fieldname = 'vbeln'.
    wa_fieldcat-seltext = 'Factura'.
    APPEND wa_fieldcat TO it_fcat.

    wa_fieldcat-fieldname = 'posnr'.
    wa_fieldcat-seltext = 'Posicion'.
    APPEND wa_fieldcat TO it_fcat.

    wa_fieldcat-fieldname = 'matnr'.
    wa_fieldcat-seltext = 'Materiales'.
    APPEND wa_fieldcat TO it_fcat.

    wa_fieldcat-fieldname = 'matwa'.
    wa_fieldcat-seltext = 'Descripcion'.
    APPEND wa_fieldcat TO it_fcat.

    wa_fieldcat-fieldname = 'kwmeng'.
    wa_fieldcat-seltext = 'Cantidad'.
    APPEND wa_fieldcat TO it_fcat.

    wa_fieldcat-fieldname = 'netwr'.
    wa_fieldcat-seltext = 'Precio'.
    APPEND wa_fieldcat TO it_fcat.


ENDFORM.                    " BUILD_FIELDCAT

*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BUILD_LAYOUT .

  gv_layout-zebra = 'X'.

ENDFORM.                    " BUILD_LAYOUT