*&---------------------------------------------------------------------*
*&  Include           Z_PRUEBA_CLS1
*&---------------------------------------------------------------------*
CLASS cls_alv DEFINITION.

  PUBLIC SECTION.
    METHODs: get_data,
             show_alv,
             set_fieldcat,
             handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
              IMPORTING
                e_row
                e_column
                es_row_no,
             handle_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
              IMPORTING
                e_row_id
                e_column_id
                es_row_no,
             handle_user_command2 FOR EVENT user_command OF cl_gui_alv_grid
              IMPORTING e_ucomm.


ENDCLASS.                    "cls_alv DEFINITION



*----------------------------------------------------------------------*
*       CLASS cls_alv IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS cls_alv IMPLEMENTATION.

  METHOD handle_double_click.
    DATA: wa_fact TYPE ty_factura,
         gr_alv_table  TYPE REF TO cl_salv_table.

    i_lines = e_row.

    READ TABLE it_facturas INTO wa_fact INDEX i_lines.
    IF sy-subrc EQ 0.
      SELECT * FROM vbfa INTO TABLE it_vbfa
        WHERE vbelv = wa_fact-factura
          AND vbtyp_n = 'J'.
      cl_salv_table=>factory( IMPORTING r_salv_table = gr_alv_table
                               CHANGING t_table      = it_vbfa ).
      gr_alv_table->display( ).
    ENDIF.

  ENDMETHOD.                    "handle_double_click

  METHOD handle_hotspot_click.
    FIELD-SYMBOLS <fs_facturas> TYPE ty_factura.
    DATA: lv_vbeln TYPE vbeln.

    READ TABLE it_facturas ASSIGNING <fs_facturas> INDEX e_row_id.
    IF sy-subrc EQ 0.
      CALL TRANSACTION 'VA02'.
    ENDIF.

  ENDMETHOD.                    "handle_hotspot_click

  METHOD handle_user_command2.
    DATA pw_selfield TYPE slis_selfield.

    i_lines = pw_selfield-tabindex.
  ENDMETHOD.                    "handle_user_command2


  METHOD: get_data.

    SELECT v~vbeln p~posnr p~matnr p~matwa p~kwmeng p~netwr
      INTO TABLE it_facturas
      FROM vbak AS v
      INNER JOIN vbap AS p ON v~vbeln = p~vbeln
      WHERE v~vbeln = p_vbak.

    LOOP AT it_facturas ASSIGNING <fs_factura>.
      <fs_factura>-total = <fs_factura>-cantidad * <fs_factura>-precio.
    ENDLOOP.

  ENDMETHOD.                    "get_data

  METHOD: set_fieldcat.
    DATA wa_fieldcat TYPE lvc_s_fcat.

    wa_fieldcat-fieldname = 'FACTURA'.
    wa_fieldcat-ref_table = 'VBAK'.
    wa_fieldcat-ref_field = 'VBELN'.
    wa_fieldcat-key       = 'X'.
    wa_fieldcat-hotspot = 'X'.
*    wa_fieldcat-seltext   = 'Factura'.
    APPEND wa_fieldcat TO it_fcat.
    CLEAR wa_fieldcat.

    wa_fieldcat-fieldname = 'POSICION'.
    wa_fieldcat-ref_table = 'VBAP'.
    wa_fieldcat-ref_field = 'POSNR'.
*    wa_fieldcat-seltext   = 'Posicion'.
    APPEND wa_fieldcat TO it_fcat.
    CLEAR wa_fieldcat.

    wa_fieldcat-fieldname = 'MATERIAL'.
    wa_fieldcat-ref_table = 'VBAP'.
    wa_fieldcat-ref_field = 'MATNR'.
*    wa_fieldcat-seltext   = 'Materiales'.
    APPEND wa_fieldcat TO it_fcat.
    CLEAR wa_fieldcat.

    wa_fieldcat-fieldname = 'DESCRIPCION'.
    wa_fieldcat-ref_table = 'VBAP'.
    wa_fieldcat-ref_field = 'MATWA'.
*    wa_fieldcat-seltext   = 'Descripcion'.
    APPEND wa_fieldcat TO it_fcat.
    CLEAR wa_fieldcat.

    wa_fieldcat-fieldname = 'CANTIDAD'.
    wa_fieldcat-ref_table = 'VBAP'.
    wa_fieldcat-ref_field = 'KWMENG'.
*    wa_fieldcat-seltext   = 'Cantidad'.
    APPEND wa_fieldcat TO it_fcat.
    CLEAR wa_fieldcat.

    wa_fieldcat-fieldname = 'PRECIO'.
    wa_fieldcat-ref_table = 'VBAP'.
    wa_fieldcat-ref_field = 'NETWR'.
*    wa_fieldcat-seltext   = 'Precio'.
    APPEND wa_fieldcat TO it_fcat.
    CLEAR wa_fieldcat.

    wa_fieldcat-fieldname = 'TOTAL'.
    wa_fieldcat-seltext   = 'Precio Total'.
    wa_fieldcat-do_sum    = 'X'.
    APPEND wa_fieldcat TO it_fcat.
    CLEAR wa_fieldcat.

  ENDMETHOD.                    "set_fieldcat

  METHOD show_alv.

    DATA: vl_layout TYPE lvc_s_layo.
    vl_layout-zebra = 'X'.

    IF vg_container IS NOT BOUND.
      CREATE OBJECT vg_container
        EXPORTING
          container_name = 'CC_ALV'.

      CREATE OBJECT obj_alv_grid
        EXPORTING
          i_parent = vg_container.

      CALL METHOD set_fieldcat.

      SET HANDLER handle_double_click  FOR obj_alv_grid.
      SET HANDLER handle_hotspot_click FOR obj_alv_grid.
      SET HANDLER handle_user_command2 FOR obj_alv_grid.


      CALL METHOD obj_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = vl_layout
        CHANGING
          it_fieldcatalog = it_fcat
          it_outtab       = it_facturas.
    ELSE.
      CALL METHOD obj_alv_grid->refresh_table_display.

    ENDIF.

  ENDMETHOD.                    "show_alv

ENDCLASS.                    "cls_alv IMPLEMENTATION