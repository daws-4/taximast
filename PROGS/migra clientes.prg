*Migraciòn de los datos AdmiPRo Ver 1.0 a 2.0
sele 1
USE d:\TAXIMAST\DATA\clientes1
sele 2
USE d:\taximast\data\clientes
sele 1
do while ! eof()
    sele 2
    if ! seek(alltrim(clientes1.teleclie),"clientes","teleclie")
     append blank
     wait "Reemplaza ahora  "+clientes1.teleclie+" "+alltrim(str(recno(1)))+"/"+alltrim(str(reccount(1))) window at 12,20 nowait 
     repla TELECLIE with ALLTRIM(clientes1.TELECLIE)
     repla NOMBCLIE with ALLTRIM(clientes1.nombclie)
     repla APELCLIE with ALLTRIM(clientes1.apelclie)
     repla CODICLIE with (clientes1.codiclie)
     repla DIRECLIE with ALLTRIM(clientes1.direclie)
     repla REFECLIE with ALLTRIM(clientes1.refeclie)
     repla STATCLIE with "1"
     repla ZONACLIE with ALLTRIM(clientes1.zonaclie)
     repla FEINCLIE with clientes1.feinclie
     repla OPERCLIE WITH clientes1.operclie
     endif
    sele 1 
    skip
enddo