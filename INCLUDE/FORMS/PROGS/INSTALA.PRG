
instala()

func instala()
do form \taximast\forms\instalar.scx
read events
*a=time()
*b=dtoc(date())
*c=subs(a,1,2)+subs(a,4,2)
*c=c+subs(b,1,2)
*c=c+subs(a,7,1)+subs(a,8,1)+".TxT"
*! vol > &c
*d=fopen(c,2)
*if d#1
*    e=fread(d,93)
*    f=subs(e,84,9)
*    wait "Etiqueta "+ f +  " Archivo "+c window
*else
*    messageb("Error irrecuperable del Sistema no fue capaz de abrir el archivo")
*endif
*fclose(d)
*! del &c>nul
*crypta(f)
*/
quit
return

func crypta(vol)
     vol1=vol
     a=180
     b=230
     vol=subs(vol1,len(vol1),1)
     for i=1 to len(vol1)
          val=subs(vol1,len(vol1)-i,1) &&(val<"1" .and. val>"9")
          if (val>="A" .and. val<="H")
             do case 
                case val="A" 
                     val="W"
                case val="B"
                     val="I"
                case val="C"
                     val="L"
                case val="D"
                     val="J"
                case val="E"
                     val="R"
                case val="F"
                     val="S"
                case val="G"
                     val="I"
                case val="H"
                     val="K"
             endcase
          endif
          *? val
          vol=vol+val
     next
     *wait vol window
     *messageb("Se generó esta clave "+vol+" de "+vol1)
*     nocrypta(vol)
return vol

func nocrypta(vol)
     vol=subs(vol1,len(vol1),1)
     for i=1 to len(vol1)
          val=subs(vol1,len(vol1)-i,1) &&(val<"1" .and. val>"9")
          if (val>="A" .and. val<="Z")
             do case 
                case val="W" 
                     val="A"
                case val="I"
                     val="B"
                case val="L"
                     val="C"
                case val="J"
                     val="D"
                case val="R"
                     val="E"
                case val="S"
                     val="F"
                case val="I"
                     val="G"
                case val="K"
                     val="H"
             endcase
          endif
          *? val
          vol=vol+val
     next
     *wait vol window
     messageb("Se generó esta clave "+vol+" de "+vol1)
     *nocrypta(vol)
return 