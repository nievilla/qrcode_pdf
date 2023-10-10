$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type pb_open from picturebutton within w_main
end type
type pb_writer from picturebutton within w_main
end type
type pb_reader from picturebutton within w_main
end type
type p_2 from picture within w_main
end type
type st_info from statictext within w_main
end type
type st_myversion from statictext within w_main
end type
type st_platform from statictext within w_main
end type
type r_2 from rectangle within w_main
end type
type dw_1 from datawindow within w_main
end type
type listboxdirectory from listbox within w_main
end type
end forward

global type w_main from window
integer width = 4174
integer height = 1976
boolean titlebar = true
string title = "QRCode PDF Demo"
boolean controlmenu = true
boolean minbox = true
string icon = "AppIcon!"
boolean center = true
pb_open pb_open
pb_writer pb_writer
pb_reader pb_reader
p_2 p_2
st_info st_info
st_myversion st_myversion
st_platform st_platform
r_2 r_2
dw_1 dw_1
listboxdirectory listboxdirectory
end type
global w_main w_main

type prototypes

end prototypes

type variables

end variables

forward prototypes
public subroutine wf_version (statictext ast_version, statictext ast_patform)
public function integer wf_tokenized_string_to_array (string as_target, string as_token, ref string as_return_values[])
end prototypes

public subroutine wf_version (statictext ast_version, statictext ast_patform);String ls_version, ls_platform
environment env
integer rtn

rtn = GetEnvironment(env)

IF rtn <> 1 THEN 
	ls_version = string(year(today()))
	ls_platform="32"
ELSE
	ls_version = "20"+ string(env.pbmajorrevision)+ "." + string(env.pbbuildnumber)
	ls_platform=string(env.ProcessBitness)
END IF

ls_platform += " Bits"

ast_version.text=ls_version
ast_patform.text=ls_platform

end subroutine

public function integer wf_tokenized_string_to_array (string as_target, string as_token, ref string as_return_values[]);long ll_pos
 
ll_pos = pos(as_target, as_token)
 do while ll_pos > 0
	as_return_values[UpperBound(as_return_values) + 1] = left(as_target, ll_pos - 1)
	as_target = right(as_target, len(as_target) + 1 - (ll_pos + len(as_token)))
	ll_pos = pos(as_target, as_token)
loop
if len(as_target) > 0 then as_return_values[UpperBound(as_return_values) + 1] = as_target
 
 return UpperBound(as_return_values)
 
 
end function

on w_main.create
this.pb_open=create pb_open
this.pb_writer=create pb_writer
this.pb_reader=create pb_reader
this.p_2=create p_2
this.st_info=create st_info
this.st_myversion=create st_myversion
this.st_platform=create st_platform
this.r_2=create r_2
this.dw_1=create dw_1
this.listboxdirectory=create listboxdirectory
this.Control[]={this.pb_open,&
this.pb_writer,&
this.pb_reader,&
this.p_2,&
this.st_info,&
this.st_myversion,&
this.st_platform,&
this.r_2,&
this.dw_1,&
this.listboxdirectory}
end on

on w_main.destroy
destroy(this.pb_open)
destroy(this.pb_writer)
destroy(this.pb_reader)
destroy(this.p_2)
destroy(this.st_info)
destroy(this.st_myversion)
destroy(this.st_platform)
destroy(this.r_2)
destroy(this.dw_1)
destroy(this.listboxdirectory)
end on

event open;wf_version(st_myversion, st_platform)









end event

type pb_open from picturebutton within w_main
integer x = 3406
integer y = 1664
integer width = 151
integer height = 116
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "Hyperlink!"
boolean originalsize = true
string picturename = "C:\proyecto pw2022\Blog\PowerBuilder\qrcode_pdf\open.png"
alignment htextalign = left!
string powertiptext = "Open All PDF to Writter"
end type

event clicked;Long ll_Row, ll_RowCount
String ls_delivery_note, ls_year, ls_series, ls_company, ls_path, ls_filename

ll_RowCount = dw_1.RowCount() 

FOR ll_Row = 1 TO  ll_RowCount	
	
	ls_company=dw_1.object.company[ll_Row]
	ls_year = dw_1.object.year[ll_Row]
	ls_series=dw_1.object.series[ll_Row]
	ls_delivery_note=dw_1.object.delivery_note[ll_Row]
	
	ls_filename = ls_company+"-"+ls_year+"-"+ls_series+"-"+ls_delivery_note+".pdf"

	ls_path = gs_appdir + "\pdfwriter\"+ls_filename
	
	dw_1.object.path[ll_Row] = ls_path
	
NEXT
end event

type pb_writer from picturebutton within w_main
integer x = 3557
integer y = 1520
integer width = 274
integer height = 268
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hyperlink!"
string picturename = "qr_pdfwriter.jpg"
alignment htextalign = left!
string powertiptext = "Insert QR"
end type

event clicked;String ls_path, ls_delivery_note, ls_year, ls_series, ls_company, ls_data, ls_qrImage
Long ll_Row, ll_RowCount
nvo_barcodeservice ln_bcserv
nvo_fileservice ln_file
PDFpage lpdf_page
PDFImage lpdf_image 
PDFdocument lpdf_doc

SetPointer(HourGlass!)

ll_RowCount = dw_1.RowCount() 

//Control de Consulta
IF ll_RowCount=0 THEN
	messagebox("Atención","¡ Debe realizar primero una consulta !", exclamation!)
	RETURN
END IF

dw_1.setredraw(FALSE)

ln_bcserv = CREATE nvo_barcodeservice
ln_file = CREATE nvo_FileService

FOR ll_Row = 1 TO  ll_RowCount	
	
	ls_path = dw_1.object.path[ll_Row]
	
	IF ls_path = "" THEN CONTINUE
	
	lpdf_page = create PDFpage
	lpdf_image = create PDFImage
	lpdf_doc = create PDFdocument

	ls_company=dw_1.object.company[ll_Row]
	ls_year = dw_1.object.year[ll_Row]
	ls_series=dw_1.object.series[ll_Row]
	ls_delivery_note=dw_1.object.delivery_note[ll_Row]
	
	ls_data = ls_company+"-"+ls_year+"-"+ls_series+"-"+ls_delivery_note

	ls_qrImage = ln_bcserv.of_qrgenerate(ls_data)
	
	//Importamos el PDF Completo al Documento
	lpdf_doc.importpdf(ls_path)
	
	//Elimino la primera página
	lpdf_doc.removepage(1)

	//Importamos la Pagina1 al Objeto PdfPage
	lpdf_page.importcontent(ls_path, 1, 0, 0, lpdf_page.getwidth(), lpdf_page.getheight())
	
	//Creamos la Imagen en el Objeto PdfImage
	lpdf_image.filename = ls_qrImage
	lpdf_image.x=330
	lpdf_image.y=10
	lpdf_image.height=100
	lpdf_image.width=100
	lpdf_image.FitMethod = PDFImageFitmethod_Meet!
	
	//Añadimos la Imagen Creada al Objeto PdfPage
	lpdf_page.addcontent( lpdf_image)
	
	//Importamos la Pagina con la Imagen al Objeto PDFDocument en la primera poicion
	lpdf_doc.InsertPage(lpdf_page, 1)
	
	//Guardo el PDF con un nuevo nombre.
	ls_path = ln_file.of_getdirectoryname(ls_path)+"\"+string(ll_row)+".pdf"
	
	lpdf_doc.save(ls_path)
	
	destroy lpdf_page
	destroy lpdf_image
	destroy lpdf_doc
NEXT

destroy ln_bcserv
destroy ln_file
dw_1.setredraw(TRUE)
SetPointer(Arrow!)







end event

type pb_reader from picturebutton within w_main
integer x = 3835
integer y = 1516
integer width = 274
integer height = 268
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hyperlink!"
string picturename = "qr_pdfreader.jpg"
alignment htextalign = left!
string powertiptext = "Read Qr"
end type

event clicked;String ls_path, ls_delivery_note, ls_year, ls_series, ls_company, ls_data, ls_search_expr, ls_current
Long ll_num, ll_Row, ll_RowCount, ll_Items,  ll_TotalItems 
String ls_array[], ls_resetArray[] 
Integer li_items

SetPointer(HourGlass!)
nvo_barcodeservice ln_bcserv

ll_RowCount = dw_1.RowCount() 

//Control de Consulta
IF ll_RowCount=0 THEN
	messagebox("Atención","¡ Debe realizar primero una consulta !", exclamation!)
	RETURN
END IF

//Cargo los Albaranes del Directorio
ls_current=GetCurrentDirectory ( )
ls_path=gs_appdir + "\pdf\"

 // Carga de fichero en listbox
listboxdirectory.Reset()
listboxdirectory.DirList(ls_path +"*.pdf", 0 )

ChangeDirectory ( ls_current )
 
ll_TotalItems = listboxdirectory.TotalItems()

IF ll_totalitems = 0 THEN RETURN

dw_1.setredraw(FALSE)

ln_bcserv = CREATE nvo_barcodeservice

FOR ll_Items = 1 TO  ll_TotalItems	
	//Leer codigo de barras
	ls_data=ln_bcserv.of_barcodereader(ls_path + listboxdirectory.Text(ll_Items))
	
	IF ls_data = ""  THEN CONTINUE 
	
	//Los codigos en los albaranes los escribo: 1-2023-1-17629 (company=1, year=2023, series=1, delivery_note=17629)
	li_items = wf_tokenized_string_to_array(ls_data, "-",  REF ls_array[])
	
	IF li_items <> 4 THEN CONTINUE

	ls_company=ls_array[1]
	ls_year=ls_array[2]
	ls_series=ls_array[3]
	ls_delivery_note=ls_array[4] 
	
	//Resetemaos Array
	ls_array[] = ls_resetArray[] 
					
	ls_search_expr = "series='"+ls_series+"' and delivery_note='"+ls_delivery_note+"' and year='"+ls_year+"'"
	
	ll_Row = dw_1.Find(ls_search_expr, 1,  ll_RowCount)
   
	IF ll_Row < 1 THEN CONTINUE
         
	dw_1.object.path[ll_Row]=ls_path + listboxdirectory.Text(ll_Items)

NEXT


destroy ln_bcserv

dw_1.setredraw(TRUE)
SetPointer(Arrow!)


end event

type p_2 from picture within w_main
integer x = 5
integer y = 4
integer width = 1253
integer height = 248
boolean originalsize = true
string picturename = "logo.jpg"
boolean focusrectangle = false
end type

type st_info from statictext within w_main
integer x = 2857
integer y = 1820
integer width = 1289
integer height = 52
integer textsize = -7
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
string text = "Copyright © Ramón San Félix Ramón  rsrsystem.soft@gmail.com"
boolean focusrectangle = false
end type

type st_myversion from statictext within w_main
integer x = 3607
integer y = 52
integer width = 489
integer height = 84
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Versión"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_platform from statictext within w_main
integer x = 3607
integer y = 140
integer width = 489
integer height = 84
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Bits"
alignment alignment = right!
boolean focusrectangle = false
end type

type r_2 from rectangle within w_main
long linecolor = 33554432
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 33521664
integer width = 5115
integer height = 260
end type

type dw_1 from datawindow within w_main
integer x = 27
integer y = 316
integer width = 4110
integer height = 1188
integer taborder = 10
string title = "none"
string dataobject = "dw_delivery_note"
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;integer li_rtn
string ls_file
string ls_path
string  ls_current

if dwo.name= "p_open" then
	ls_current=GetCurrentDirectory ( )
	ls_path=	gs_appdir
	li_rtn = GetFileOpenName("Archivo a cargar", ls_path, ls_file, "pdf", "Acrobat Reader (*.pdf), *.Pdf", ls_path)
	
	if li_rtn <> 1 then ls_path = ""
	
	this.object.path[row]=ls_path
	
	ChangeDirectory ( ls_current )
end if	
end event

type listboxdirectory from listbox within w_main
boolean visible = false
integer x = 393
integer y = 1068
integer width = 503
integer height = 412
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

