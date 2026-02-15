*Migraciòn de los datos abonos de Taxis
sele 1
*use \taximast\data\m_inve EXCLUSIVE
use \taximast\data\ctaxcobr1 EXCLUSIVE
sele 2
use \taximast\data\dfact EXCLUSIVE
sele 1
do while ! eof()
    sele 2
    *if ! seek (alltrim("codart"),"mxctainv","codart")
    *,"M_INVE","CODIARTI").and. !empty(mxctainv.codart)
     append blank
     wait "Reemplaza ahora  "+alltrim(str(recno(1)))+"/"+alltrim(str(reccount(1))) window at 12,20 nowait 
     repla numefact with ctaxcobr1.numedocu
     repla numedocu with ctaxcobr1.numefact
     repla fechfact with ctaxcobr1.fechdocu
     repla codiunid with ctaxcobr1.codiunid
     repla fechfact with ctaxcobr1.fechdocu
     repla precunid with ctaxcobr1.abonfact
     repla prectotal with ctaxcobr1.abonfact
     repla opersist with ctaxcobr1.opersist
     repla tipoconc with ctaxcobr1.concepto
     repla descconc with ctaxcobr1.descdocu
     repla fechinic with ctaxcobr1.fechinic
     repla fechfini with ctaxcobr1.fechfina
     repla cantidad with 1
     sele 1 
    SKIP
enddo