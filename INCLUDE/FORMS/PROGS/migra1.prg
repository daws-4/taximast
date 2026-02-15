*Migraciòn de los datos AdmiPRo Ver 1.0 a 2.0
sele 1
use \TAXIMAST\DATA\atencion
sele 2
use \taximast\data\mserv
sele 1
do while ! eof()
    sele 2
    if ! seek(alltrim(ATENCION.TELEFONO),"MSERV","teleclie")
    *.and. !empty(stclien.telcl1)
    *if ! seek(subs(ATENCION,AA,1,3))
    *+subs(MSERV.teleclie,5,10)
    *,"atencion","aa")
    *.and. !empty(mserv.TELECLIE)
     append blank
     wait "Reemplaza ahora  "+MSERV.teleclie+" "+alltrim(str(recno(1)))+"/"+alltrim(str(reccount(1))) window at 12,20 nowait 
     repla STATELIM with ATENCION.STATUS1 
     repla STATSERV with "A"
     repla NUM2SERV with ALLTRIM(ATENCION.CONTROL1)
     repla DIRECLIE with ATENCION.DIRECCION
     repla REFECLIE with ALLTRIM(ATENCION.OBSERVA1+ATENCION.OBSERVA2+ATENCION.OBSERVA3)
     repla SOLISERV with ALLTRIM(ATENCION.CLIENTE)
     repla CHOFER   with ALLTRIM(ATENCION.CHOFER)
     repla DESTSERV with ALLTRIM(ATENCION.DESTINO)
     repla CONTSERV with ALLTRIM(ATENCION.NUMERO)
     repla ACUMSERV with ALLTRIM(ATENCION.TOTAL_SERV)
     repla CODIAREA with ALLTRIM(ATENCION.CODIGO)
     repla TELECLIE with ALLTRIM(ATENCION.TELEFONO)
     repla HORA1SER with ATENCION.HORA_LLAM
     repla HORA2SER with ATENCION.HORA_CARR
     repla UBICUNID with ALLTRIM(ATENCION.UBIC_CONT)
     repla DESCUBIC with ATENCION.UBICACION
     repla PRECSERV with ATENCION.PRECIO
     repla PRECPREP with ATENCION.precio_trj
     repla OPERSERV with ATENCION.TAQUILLA
     repla FECHSERV With ATENCION.FECHA1
     repla FECHANSE With ATENCION.FECHA_ANU
     repla OBSESERV with ATENCION.OBSERVA1
    endif
    sele 1 
    skip
enddo