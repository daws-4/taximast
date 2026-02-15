set proce to \taximast\progs\instala.prg
a=time()
b=dtoc(date())
c=subs(a,1,2)+subs(a,4,2)
c=c+subs(b,1,2)
c=c+subs(a,7,1)+subs(a,8,1)+".TxT"
! vol c:> &c
d=fopen(c,2)
if d#1
    e=fread(d,93)
    f=subs(e,84,9)
    *wait "Etiqueta "+ f +  " Archivo "+c window
else
    messageb("Error irrecuperable del Sistema no fue capaz de abrir el archivo")
endif
fclose(d)
ERASE &c
G=crypta(f)
SELE 1
use \TAXIMAST\DATA\SERIALES shared
loca for alltrim(serial)=g
*?G 
if ! found()
      messageb("Copia No Registrada... Llamar a:  Servicios Telemáticos de Venezuela, Telf. +58 412.244.32.81")
      quit
ENDIF
**
set escape off
PUBLIC lcMainClassLib
PUBLIC lcLastSetTalk,lcLastSetPath,lcLastSetClassLib,lcOnShutdow
*-- Save and configure environment.
lcLastSetTalk=SET("TALK")
SET TALK OFF
set excl off
set autosave on
SET PROC TO \TAXIMAST\PROGS\RUTINAS,\taximast\progs\repo0001.prg
**
SET DELETE ON
lcLastSetPath=SET("PATH")
CD "\taximast\"
PUBLIC M.CODIUSER
SET PATH TO ;DATA;INCLUDE;FORMS;GRAPHICS;HELP;LIBS;MENUS;PROGS;REPORTS
PUSH MENU _msysmenu
*PUBLIC lcLastSetClassLib
lcLastSetClassLib=SET("CLASSLIB")
lcMainClassLib="libs\taximast"
SET CLASSLIB TO (lcMainClassLib) ADDITIVE
lcOnShutdown="ShutDown()"
ON SHUTDOWN &lcOnShutdown
*  Errores comunes de Teclado
ON KEY LABEL PGUP Wait Window "Tecla no válida "+m.codiuser NOWAIT
ON KEY LABEL PGDN Wait Window "Tecla no válida "+m.codiuser NOWAIT
*set keycomp to dos




ON ERROR ErrorHandler(ERROR(),PROGRAM(),LINENO())
_shell="DO Cleanup IN progs\taximast"
*-- Instantiate application object.
RELEASE goApp
PUBLIC goApp
goApp=CREATEOBJECT("cApplication")

*-- Configure application object.
*_screen.windows.state=2
SET DATE TO BRITISH 
USE \TAXIMAST\DATA\EMPRESAS shared
SCATTER MEMVAR
USE 
use \TAXIMAST\DATA\muser shared
scatter memvar blank
use
goApp.SetCaption(ALLTRIM(M.NOMBEMPR)+"    - Servicios Telemáticos de Venezuela - T@xinet Ver. 5.0")
goApp.cStartupMenu="menus\taximast"
goApp.cStartupForm="forms\login"
_screen.windowstate=2
_screen.picture="graphics\fondo.jpg"
public  canal, ss
ss=.f.
canal=1

goApp.Show

*-- Release application.

RELEASE goApp

*-- Restore default menu.
POP MENU _msysmenu

*-- Restore environment.
ON ERROR
ON SHUTDOWN
IF NOT lcLastSetClassLib==SET("classlib")
	RELEASE CLASSLIB (lcMainClassLib)
ENDIF
IF EMPTY(lcLastSetPath)
	SET PATH TO
ELSE
	SET PATH TO &lcLastSetPath
ENDIF
IF lcLastSetTalk=="ON"
	SET TALK ON
ELSE
	SET TALK OFF
ENDIF
RETURN


FUNCTION ErrorHandler(nError,cMethod,nLine)
LOCAL lcErrorMsg,lcCodeLineMsg

WAIT CLEAR
lcErrorMsg=MESSAGE()+CHR(13)+CHR(13)
lcErrorMsg=lcErrorMsg+"Method:    "+cMethod
lcCodeLineMsg=MESSAGE(1)
IF BETWEEN(nLine,1,10000) AND NOT lcCodeLineMsg="..."
	lcErrorMsg=lcErrorMsg+CHR(13)+"Line:         "+ALLTRIM(STR(nLine))
	IF NOT EMPTY(lcCodeLineMsg)
		lcErrorMsg=lcErrorMsg+CHR(13)+CHR(13)+lcCodeLineMsg
	ENDIF
ENDIF
IF MESSAGEBOX(lcErrorMsg,17,_screen.Caption)#1
	ON ERROR
	RETURN .F.
ENDIF
ENDFUNC



FUNCTION ShutDown

IF TYPE("goApp")=="O" AND NOT ISNULL(goApp)
	RETURN goApp.OnShutDown()
ENDIF
Cleanup()
QUIT
ENDFUNC


FUNCTION Cleanup

IF CNTBAR("_msysmenu")=7
	RETURN
ENDIF
ON ERROR
ON SHUTDOWN
SET CLASSLIB TO
SET PATH TO
CLEAR ALL
CLOSE ALL
POP MENU _msysmenu
RETURN