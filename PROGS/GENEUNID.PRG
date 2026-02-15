use L:\taximast\data\munid excl
ini=1
fin=150
cad=0
for i = ini to fin
    if i<=9
        cad=i
    else
        cad=i
    endif
    append blank
    repl codiunid with cad
    repl statunid with "1"
    unlock
next