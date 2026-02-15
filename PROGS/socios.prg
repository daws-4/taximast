use c:\taximast\data\socios excl
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
    repl clavsoci with cad
    *repl statunid with "1"
    unlock
next