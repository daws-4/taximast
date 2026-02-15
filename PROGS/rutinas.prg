set date to brit
*THISFORM.Refresh
*AMPM2
Func AmPm2(tiempo)
hora=0
c="  "
Y="  "
resul=Space(8)
x=subs(tiempo,7,1)
if x ="A"
   hora=val(subs(tiempo,1,2))
   *Y="P"
else
*   Y="A"
   hora=val(subs(tiempo,1,2))+12
Endif 
if hora<10
   c="0"+Alltrim(str(hora))
else
   c=Alltrim(str(hora))
endif   
resul=c+Subs(tiempo,3,3) &&+" "+Y
return (resul)
* AMPM
Func AmPm(tiempo)
hora=0
c="  "
Y="  "
resul=Space(8)
x=val(subs(tiempo,1,2))
if x >= 12
   hora=x-12
   Y="P"
else
   Y="A"
   hora=x
Endif 
if hora<10
   c="0"+Alltrim(str(hora))
else
   c=Alltrim(str(hora))
endif   
resul=c+Subs(tiempo,3,3)+" "+Y
return (resul)

* funcion de chequeo de apartados
func CheckApart()
*use \taximast\data\mserv
SELECT apartados
set order to horaapar
&& tag statserv on taximast\data\mserv\mserv.cdx
if  seek("T","apartados","horaapar")
do while !eof()
     if fechapar<=date().and.ampm2(horaapar)<=subs(time(),1,5)
       IF STATAPAR="T"
         IF RLOCK()
          repl statapar with "Y"
          *DELETE
         * PACK
          *REINDEX
         ENDIF
         unlock
       endif
       *fecha=date("")
       tele=teleapar
       stata=statapar
       enco=encoapar
       fecha=fechapar
       zona=zonaapar
       direa=direapar
       direa2=direapa2
       refea=refeclie
       oper=opersist
       soli=soliapar
       sele mserv
       appen blank
       repl teleclie with tele
       repl statserv with "E"
       repl encoclie with enco
       repl hora1ser with ampm(time())
       repl horaapar with apartados.horaapar
       repl fechserv with date()
       repl fechapar with fecha
       repl zonaclie with zona
       repl direclie with direa
       repl direcli2 with direa2
       repl refeclie with refea
       repl operserv with oper
       repl soliserv with soli
*       repl s800serv with ThisForm.Check1.value 
	  * scatter memvar
       UNLOCK
       
       set bell on
       set bell to "\taximast\graphics\apartado.wav",1
       ?? chr(7)
       set bell to
       ?? CHR(7)
       ?? CHR(7)
       wait "Se Emitió un Apartado Temporal..." window AT 12,25 timeout 3
     endif
     sele apartados
     *set filter to 
     set order to horaapar
     IF RECNO()#RECCOUNT().AND. ! EOF()
        skip 1
     ELSE
        EXIT
     ENDIF
ENDDO
*PUBLIC M.CODIUSER
endif
*set filter to canaserv=m.canal .AND. STATSERV#"P"
*go top
*sele mserv
*set order to statserv
return        

* funcion de chequeo de apartados
func CheckApart2()
*use \taximast\data\mserv
sele apartados
*gather memvar
*set filter to 
set order to horaapar2
&& tag statserv on taximast\data\mserv\mserv.cdx
if  seek("F","apartados","horaapar2")
do while !eof()
   tele=teleapar
   stata=statapar
   enco=encoapar
   fecha=fechapar
   zona=zonaapar
   direa=direapar
   direa2=direapa2
   refea=refeclie
   oper=opersist
   soli=soliapar
     if fechapar<=date().and. ampm2(horaapar)<=subs(time(),1,5)
       IF STATAPAR="F"
         repl statapar with "F"
         repl fechapar with fechapar+7
       endif
       unlock
       sele mserv
       appen blank
       repl teleclie with tele
       repl statserv with "E"
       repl encoclie with enco
       repl hora1ser with ampm(time())
       repl horaapar with apartados.horaapar
       repl fechserv with date()
       repl fechapar with fecha
       repl zonaclie with zona
       repl direclie with direa
       repl direcli2 with direa2
       repl refeclie with refea
       repl operserv with oper
       repl soliserv with soli
*       repl s800serv with ThisForm.Check1.value 
	 *  scatter memvar
       unlock
       set bell on
       set bell to "\taximast\graphics\apartado.wav",1
       ?? chr(7)
       set bell to
       ?? CHR(7)
       ?? CHR(7)
       wait "Se Emitió un Apartado Fijo..." window AT 12,25 timeout 3
     endif
     sele apartados
     *set filter to 
     set order to horaapar2
     IF RECNO()#RECCOUNT().AND. ! EOF()
        skip 1
     ELSE
        EXIT
     ENDIF
ENDDO
*PUBLIC M.CODIUSER
endif
*set filter to canaserv=m.canal .AND. STATSERV#"P"
*go top
*sele mserv
*set order to statserv
return        

 
func creatmp()
a=time()
b=dtoc(date())
c=subs(a,1,2)+subs(a,4,2)
c=c+subs(b,1,2)
c=c+subs(a,7,1)+subs(a,8,1)
return c
*
