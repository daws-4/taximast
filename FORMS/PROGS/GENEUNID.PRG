use c:\taximast\data\munid excl
ini=1
fin=400
cad=space(3)
for i = ini to fin
    if i<=9
        cad="0"+str(i,1)
    else
        cad=alltrim(str(i,3))
    endif
    append blank
    repl codiunid with "B"+cad
    repl statunid with "1"
    unlock
next