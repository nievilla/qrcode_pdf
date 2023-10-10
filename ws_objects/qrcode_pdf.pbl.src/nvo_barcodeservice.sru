$PBExportHeader$nvo_barcodeservice.sru
forward
global type nvo_barcodeservice from nonvisualobject
end type
end forward

global type nvo_barcodeservice from nonvisualobject
end type
global nvo_barcodeservice nvo_barcodeservice

type variables
CONSTANT Integer AZTEC = 1
        //
        // Resumen:
        //     CODABAR 1D format.
CONSTANT Integer CODABAR = 2
        //
        // Resumen:
        //     Code 39 1D format.
CONSTANT Integer  CODE_39 =3
        //
        // Resumen:
        //     Code 93 1D format.
CONSTANT Integer CODE_93 =4
        //
        // Resumen:
        //     Code 128 1D format.
CONSTANT Integer CODE_128 =5
        //
        // Resumen:
        //     Data Matrix 2D barcode format.
CONSTANT Integer  DATA_MATRIX = 6
        //
        // Resumen:
        //     EAN-8 1D format.
CONSTANT Integer  EAN_8 = 7
        //
        // Resumen:
        //     EAN-13 1D format.
CONSTANT Integer EAN_13 = 8
        //
        // Resumen:
        //     ITF (Interleaved Two of Five) 1D format.
CONSTANT Integer ITF = 9
        //
        // Resumen:
        //     MaxiCode 2D barcode format.
CONSTANT Integer  MAXICODE =10
        //
        // Resumen:
        //     PDF417 format.
CONSTANT Integer  PDF_417 =11
        //
        // Resumen:
        //     QR Code 2D barcode format.
CONSTANT Integer  QR_CODE = 12
        //
        // Resumen:
        //     RSS 14
CONSTANT Integer RSS_14 = 13
        //
        // Resumen:
        //     RSS EXPANDED
CONSTANT Integer  RSS_EXPANDED =14
        //
        // Resumen:
        //     UPC-A 1D format.
CONSTANT Integer UPC_A =15
        //
        // Resumen:
        //     UPC-E 1D format.
CONSTANT Integer  UPC_E =16
        //
        // Resumen:
        //     UPC/EAN extension format. Not a stand-alone format.
CONSTANT Integer  UPC_EAN_EXTENSION =17
        //
        // Resumen:
        //     MSI
CONSTANT Integer  MSI = 18
        //
        // Resumen:
        //     Plessey
CONSTANT Integer  PLESSEY =19
        //
        // Resumen:
        //     Intelligent Mail barcode
CONSTANT Integer  IMB = 20
        //
        // Resumen:
        //     Pharmacode format.
CONSTANT Integer PHARMA_CODE = 21
        //
        // Resumen:
        //     UPC_A | UPC_E | EAN_13 | EAN_8 | CODABAR | CODE_39 | CODE_93 | CODE_128 | ITF
        //     | RSS_14 | RSS_EXPANDED without MSI (to many false-positives) and IMB (not enough
        //     tested, and it looks more like a 2D)  -->ONLY FOR DECODE
CONSTANT Integer   All_1D = 22
end variables

forward prototypes
public function string of_barcodereader (string as_ruta)
public function string of_qrgenerate (string as_data)
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

public function string of_qrgenerate (string as_data);String ls_path
String ls_qr, ls_qr_blanco
String ls_result
nvo_rsrbarcode ln_rsr

if not FileExists( gs_appdir+"\RSRbarcode.dll") then
	messagebox("Error",  "¡ Necesita el Archivo RSRbarcode.dll para generar los Codigo de Barras de los PDF !", stopsign!)
	Return ""
end if	

if not FileExists( gs_appdir+"\zxing.dll") then
	messagebox("Error",  "¡ Necesita el Archivo zxing.dll para generar los Codigo de Barras de los PDF !", stopsign!)
	Return ""
end if	

if isnull(as_data) OR as_data = "" then
	messagebox("Atención!", "¡ No hay Información para generar QR !", exclamation!)
	Return ""
end if

ls_path = GetCurrentDirectory()
CreateDirectory(ls_path + "\QR_IMAGEN")

ls_qr = ls_path + "\QR_IMAGEN\qr.png" // Fichero donde se genera el código de barras

FileDelete(ls_qr) //Si existe lo borro

ln_rsr = CREATE nvo_rsrbarcode

ln_rsr.of_qrgenerate(as_data, ls_qr)

//Checks the result
IF  ln_rsr.il_ErrorType < 0 THEN
  messagebox("Failed",  ln_rsr.is_ErrorText, stopsign!)
END IF
	

IF	NOT FileExists(ls_qr) THEN
	ls_qr =  ls_qr_blanco
END IF

DESTROY ln_rsr

RETURN ls_qr



end function

on nvo_barcodeservice.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_barcodeservice.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

