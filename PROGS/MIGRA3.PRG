*Migraciòn de los datos Clientes de Taxis de Datasoft 
sele 1
use \trabajo\stclien
sele 2
use \taximast\data\clientes
sele 1
do while ! eof()
    sele 2
    if ! seek(alltrim(stclien.telcl1),"clientes","teleclie").and. !empty(stclien.telcl1)
     append blank
     wait "Reemplaza ahora  "+stclien.telcl1+" "+alltrim(str(recno(1)))+"/"+alltrim(str(reccount(1))) window at 12,20 nowait 
     repla teleclie with alltrim(stclien.telcl1)
     repla codiclie with val(alltrim(stclien.codcli))
     repla nombclie with stclien.nomcli
     repla apelclie with "Telf-Trab: "+stclien.telcl2
     repla direclie with alltrim(stclien.dirhab)
     repla refeclie with stclien.diremp
     repla zonaclie with ALLTRIM(stclien.punto)
     repla feinclie with date()
     repla statclie with "1"
     repla operclie with "ADM"
    endif
    sele 1 
    skip
enddo