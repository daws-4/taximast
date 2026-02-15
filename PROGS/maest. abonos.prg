*Migraciòn de los datos abonos de Taxis
sele 1
*use \taximast\data\m_inve EXCLUSIVE
use \taximast\data\ctaxcobr1 EXCLUSIVE
sele 2
use \taximast\data\mfact EXCLUSIVE
sele 1
do while ! eof()
    sele 2
    *if ! seek (alltrim("codart"),"mxctainv","codart")
    *,"M_INVE","CODIARTI").and. !empty(mxctainv.codart)
     append blank
     wait "Reemplaza ahora  "+alltrim(str(recno(1)))+"/"+alltrim(str(reccount(1))) window at 12,20 nowait 
     repla numefact with ctaxcobr1.numedocu
     repla fechfact with ctaxcobr1.fechdocu
     repla codiclie with ctaxcobr1.codiunid
     repla ceduclie with ctaxcobr1.codisoci
     repla fechpago with ctaxcobr1.fechdocu
     repla prectotal with ctaxcobr1.abonfact
     repla opersist with ctaxcobr1.opersist
     repla statfact with ctaxcobr1.statxcob
     repla formpago with "DP"
     repla DOCUPAGO with ctaxcobr1.numedepo
     repla nombbanc with ctaxcobr1.bancdepo
     sele 1 
    SKIP
enddo