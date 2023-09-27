$PBExportHeader$nvo_barcodeservice.sru
forward
global type nvo_barcodeservice from nonvisualobject
end type
end forward

global type nvo_barcodeservice from nonvisualobject
end type
global nvo_barcodeservice nvo_barcodeservice

forward prototypes
public function string of_barcodereader (string as_ruta)
end prototypes

public function string of_barcodereader (string as_ruta);integer li_posBarra, li_posPunto, li_largo
String ls_lectura, ls_file
nvo_rsrbarcode ln_rsr

li_posBarra=lastpos(as_ruta, "\") 
li_posPunto=pos(as_ruta, ".", li_posBarra)
li_largo=len(as_ruta)

ls_file = mid(as_ruta, li_posBarra +1 , len(as_ruta) - li_posBarra)

if ls_file = "" then
	messagebox("Error", "¡ Tiene que pasar la ruta completa del PDF !", stopsign!)
	Return ls_lectura
end if	
			
if right(lower(ls_file), 4) <> ".pdf" then
	messagebox("Error",  "¡ El Archivo "+ls_file+ " no es un PDF !", stopsign!)
	Return ls_lectura
end if	

if not FileExists( gs_appdir+"\RSRbarcode.dll") then
	messagebox("Error",  "¡ Necesita el Archivo RSRbarcode.dll para leer los Codigo de Barras de los PDF !", stopsign!)
	Return ls_lectura
end if	

if not FileExists( gs_appdir+"\PdfiumViewer.dll") then
	messagebox("Error",  "¡ Necesita el Archivo PdfiumViewer.dll para leer los Codigo de Barras de los PDF !", stopsign!)
	Return ls_lectura
end if	

if not FileExists( gs_appdir+"\pdfium.dll") then
	messagebox("Error",  "¡ Necesita el Archivo pdfium.dll para leer los Codigo de Barras de los PDF !", stopsign!)
	Return ls_lectura
end if	

if not FileExists( gs_appdir+"\zxing.dll") then
	messagebox("Error",  "¡ Necesita el Archivo zxing.dll para leer los Codigo de Barras de los PDF !", stopsign!)
	Return ls_lectura
end if	

if not FileExists( gs_appdir+"\System.Drawing.Common.dll") then
	messagebox("Error",  "¡ Necesita el Archivo System.Drawing.Common.dll para leer los Codigo de Barras de los PDF !", stopsign!)
	Return ls_lectura
end if	

ln_rsr = CREATE nvo_rsrbarcode

ls_lectura = ln_rsr.of_ReadBarCodePDF(as_ruta)

//Checks the result
IF  ln_rsr.il_ErrorType < 0 THEN
  messagebox("Failed",  ln_rsr.is_ErrorText, stopsign!)
  RETURN ""
END IF

IF isnull(ls_lectura) THEN ls_lectura=""

DESTROY ln_rsr
RETURN ls_lectura

end function

on nvo_barcodeservice.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_barcodeservice.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

