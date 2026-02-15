repe=.t.
sele 1
use c:\taximast\data\clientes
sele 2
use c:\taximast\data\tempp
sele 1
set order to 
do while ! eof()
   clave=teleclie
   scatter memvar
   sele 2
   if ! seek(clave,"tempp","teleclie")
        append blank
        gather memvar
        unlock
   endif
   sele 1
   skip 1
enddo   