*Migraciòn de los datos AdmiPRo Ver 1.0 a 2.0
sele 1
use \TAXIMAST\DATA\clientes1
sele 2
use \taximast\data\clientes
sele 1
do while ! eof()
    sele 2
    if ! seek(alltrim(clientes1.teleclie),"clientes","teleclie")
     append blank
     wait "Reemplaza ahora  "+clientes1.teleclie+" "+alltrim(str(recno(1)))+"/"+alltrim(str(reccount(1))) window at 12,20 nowait 
     repla TELECLIE with ALLTRIM(clientes1.TELECLIE)
     repla NOMBCLIE with ALLTRIM(clientes1.nombclie)
     repla APELCLIE with ALLTRIM(Clientes1.apelclie)
     repla CODICLIE with (Clientes1.codiclie)
     repla DIRECLIE with ALLTRIM(clientes1.direclie)
     repla REFECLIE with ALLTRIM(clientes1.refeclie)
     repla STATCLIE with "1"
     repla ZONACLIE with ALLTRIM(clientes1.zonaclie)
     repla FEINCLIE with Clientes1.feinclie
     repla OPERCLIE WITH clientes1.operclie
     endif
    sele 1 
    skip
enddo