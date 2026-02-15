SET CENTURY TO 19 ROLLOVER 60
fini=CTOD("01/01/00")
ffin=CTOD("31/12/00")
UNII="100"
UNIF="199"
imprime=.t.
set proc to \taximast\progs\rutinas.prg
repogene(UNII,UNIF,FINI,FFIN,imprime)

func repogene(UNII,UNIF,fini,ffin,imprime)
no800=0
si800=0
acuno800=0
acusi800=0
acullama=0
SELE 3
USE EMPResas SHARED
set cons off
*set alter on
*set alter to PRUEBA.TXT
a=creatmp()
a="\taximast\"+a+".txt"
if ! imprime
   set print to file &a
*&a
else
   set print to
endif
set devi to print
set print on 
pag=1
encabe(pag,FINI,FFIN,imprime)
sele 1
use munid shared
sele 2
use mserv shared
set order to 4
sele 1
do while ! eof()
   sele 2
   if seek(munid.codiunid).AND.(MUNID.CODIUNID>=UNII.AND.MUNID.CODIUNID<=UNIF)
   no800=0
   si800=0
   llama=0
   *acuno800=acusi800=0
   do while munid.codiunid=mserv.num2serv
    IF MSERV.FECHSERV>=FINI .AND. MSERV.FECHSERV<=FFIN
     if s800serv=0
       no800=no800+1
     else
       si800=si800+1
     endif
     llama=llama+1
    ENDIF
    skip 1
   enddo
   @prow()+1,0 say MUNID.CODIUNID
   @prow(),25 say no800 pict "99999"
   @prow(),50 say si800 pict "99999"
   @prow(),70 say llama pict "999999"
   acuno800=acuno800+no800
   acusi800=acusi800+si800
   acullama=acullama+llama
   if prow()+1>=50
     @prow()+1,0 say REPLICA("=",80)
     @prow()+1,0 say "Totales ...      "
     @prow(),25 say  str(acuno800)
     @prow(),50 say str(acusi800)
     @prow(),70 say str(ACUllama)
     PAG=PAG+1
     @prow()+1,0 say REPLICA("=",80)
     ejecT
     encabe(PAG,FINI,FFIN,imprime)
   endif
   endif
   sele 1
   skip 1
enddo
     @prow()+1,0 say REPLICA("=",80)
     @prow()+1,0 say "Totales ...      "
     @prow(),25 say  str(acuno800)
     @prow(),50 say str(acusi800)
     @prow(),70 say str(ACUllama)
     @prow()+1,0 say REPLICA("=",80)
     *ejecT
set cons on
set devi to scree
set print to
if ! imprime
   MODI FILE &a NOEDIT
   erase &a 
endif
return

func encabe(i,FINI,FFIN,imprime)
SET DATE TO BRIT
SET CENT ON
if ! imprime
  *set printer font 'Courier New',12 style ´N´
endif
@prow(),0 say empresas.nombempr 
*font 'courier',20 style 'BI'
@prow(),70 say date()
@prow()+1,0 SAY "General de Servicios por Control desde "+DTOC(FINI)+" Hasta "+DTOC(FFIN)
@prow(),75 say "Pág "+alltrim(str(i))
@prow()+1,0 say replicate ("=",80)
* 0         1         2         3         4         5         6         7         8   
* 012345678901234567890123456789012345678901234567890123456789012345678901234567890
@prow()+1,0 say "Control #                     Servicios Normales     Servicios x 800      Total"
@prow()+1,0 say  replicate ("=",80)
return