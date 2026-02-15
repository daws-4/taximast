*Migraciòn de los datos AdmiPRo Ver 1.0 a 2.0
sele 1
use \TAXIMAST\DATA\mserv1
sele 2
use \taximast\data\mserv
sele 1
do while ! eof()
    sele 2
    *if ! seek(alltrim(mserv1.TELECLIE),"MSERV","teleclie")
     append blank
     wait "Reemplaza ahora  "+MSERV1.teleclie+" "+alltrim(str(recno(1)))+"/"+alltrim(str(reccount(1))) window at 12,20 nowait 
     repla STATSERV with MSERV1.STATSERV
     repla NUM2SERV with MSERV1.NUM2SERV
     repla DIRECLIE with MSERV1.DIRECLIE
     repla SOLISERV with MSERV1.SOLISERV
     repla DESTSERV with MSERV1.DESTSERV
     repla TELECLIE with MSERV1.TELECLIE
     repla HORA1SER with MSERV1.HORA1SER
     repla HORA2SER with MSERV1.HORA2SER
     repla OPERSERV with MSERV1.OPERSERV
     repla FECHSERV With MSERV1.FECHSERV
  * endif
    sele 1 
    skip
enddo