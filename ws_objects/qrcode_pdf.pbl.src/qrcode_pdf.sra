$PBExportHeader$qrcode_pdf.sra
$PBExportComments$Generated Application Object
forward
global type qrcode_pdf from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
string gs_appdir
end variables

global type qrcode_pdf from application
string appname = "qrcode_pdf"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 22.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = "icono.ico"
string appruntimeversion = "22.1.0.2828"
boolean manualsession = false
boolean unsupportedapierror = false
boolean ultrafast = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
long webview2distribution = 0
boolean webview2checkx86 = false
boolean webview2checkx64 = false
string webview2url = "https://developer.microsoft.com/en-us/microsoft-edge/webview2/"
end type
global qrcode_pdf qrcode_pdf

type prototypes
FUNCTION	uLong	GetModuleFileName ( uLong lhModule, ref string sFileName, ulong nSize )  LIBRARY "Kernel32.dll" ALIAS FOR "GetModuleFileNameW"
end prototypes

on qrcode_pdf.create
appname="qrcode_pdf"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on qrcode_pdf.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;environment env
string ls_path
ulong lul_handle
Constant String ls_ExeFile="qrcode_pdf.exe"
Constant String ls_DeploymentPath="C:\proyecto pw2022\Blog\PowerBuilder\qrcode_pdf"

ls_Path = space(1024)
SetNull(lul_handle)
GetModuleFilename(lul_handle, ls_Path, len(ls_Path))

if right(UPPER(ls_path), 7)="220.EXE" or right(UPPER(ls_path), 7)="X64.EXE" then
	ls_path=ls_DeploymentPath+"\"+ls_ExeFile
end if

gs_appdir=left(ls_path, len(ls_path) - (len(ls_ExeFile) + 1))  

open(w_main)
end event

