*Migraciòn de los datos Clientes de Taxis de Datasoft 
sele 1
*use \taximast\data\m_inve EXCLUSIVE
use \taximast\data\m_inve EXCLUSIVE
sele 2
use \taximast\data\mxctainv EXCLUSIVE
sele 1
do while ! eof()
    sele 2
    *if ! seek (alltrim("codart"),"mxctainv","codart")
    *,"M_INVE","CODIARTI").and. !empty(mxctainv.codart)
     append blank
     wait "Reemplaza ahora  "+mxctainv.codart+" "+alltrim(str(recno(1)))+"/"+alltrim(str(reccount(1))) window at 12,20 nowait 
     repla codart with m_inve.codart
     repla nomart with m_inve.nomart
     repla grupo with m_inve.grupo
     repla iva with m_inve.iva
     repla precio_a with m_inve.precio_a
     repla des_a with m_inve.des_a
     repla compuesto with "N"
     repla ult_prove with m_inve.ult_prove
     repla ult_costo with m_inve.ult_costo
     repla ordena with m_inve.ordena
     repla costo_act with m_inve.costo_act
     repla existe_act with m_inve.existe_act
     repla fecha_cos with m_inve.fecha_cos
     repla ult_prove with m_inve.ult_prove
     repla ult_costo with m_inve.ult_costo
     repla ordena with 0
     repla costo_act with m_inve.costo_act
     repla fecha_cos with m_inve.fecha_cos
     repla fecha_sal with m_inve.fecha_sal
     repla cotiza WITH  m_inve.cotiza
     repla pedido with 0
     repla recalc with m_inve.recalc
     repla acu_ent with m_inve.acu_ent
     repla acu_sal with m_inve.acu_sal
     repla acu_cos with m_inve.acu_cos
     repla acu_csa with m_inve.acu_csa
     repla acu_ven with m_inve.acu_ven
     repla acu_cve with m_inve.acu_cve
     repla fecha_crea with m_inve.fecha_crea
     repla fecha_mod with m_inve.fecha_mod
     repla hora_mod with m_inve.hora_mod
     repla resumen with m_inve.resumen
    sele 1 
    SKIP
enddo