*Migraciòn de los datos AdmiPRo Ver 1.0 a 2.0
sele 1
use \TAXIMAST\DATA\camacho
sele 2
use \taximast\data\clientes
sele 1
do while ! eof()
    sele 2
    if ! seek(alltrim(camacho.TELEFONO),"clientes","teleclie")
    *.and. !empty(stclien.telcl1)
    *if ! seek(subs(ATENCION,AA,1,3))
    *+subs(MSERV.teleclie,5,10)
    *,"atencion","aa")
    *.and. !empty(mserv.TELECLIE)
     append blank
     wait "Reemplaza ahora  "+clientes.teleclie+" "+alltrim(str(recno(1)))+"/"+alltrim(str(reccount(1))) window at 12,20 nowait 
    * repla CODICLIE with LTRIM(STR(CAMACHO.CODIGO)) 
     repla TELECLIE with ALLTRIM(CAMACHO.TELEFONO)
     repla NOMBCLIE with ALLTRIM(CAMACHO.NOMBRES)
     repla APELCLIE with ALLTRIM(CAMACHO.APELLIDOS)
     repla CEDUCLIE with ALLTRIM(CAMACHO.CEDULA)
     repla DIRECLIE with ALLTRIM(CAMACHO.DIRECC1+CAMACHO.DIRECC2+CAMACHO.DIRECC3)
     repla REFECLIE with ALLTRIM(CAMACHO.REFEREN1+CAMACHO.REFEREN2)
     repla STATCLIE with "1"
     repla ZONACLIE with ALLTRIM(CAMACHO.PUNTO)
     repla FEINCLIE with CAMACHO.FECHA_INC
     repla OPERCLIE WITH "ADM"
     endif
    sele 1 
    skip
enddo