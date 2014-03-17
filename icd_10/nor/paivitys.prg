Procedure paivitys
select icd_10
set order to code
set filter to
replace all valid with .f.
select uusi
goto top
do while not eof()
  wait window nowait uusi.c1                                           
  select icd_10
  seek UPPER(trim(uusi.c1))
  if found() 
    if trim(uusi.c2)<>trim(text)
      wait window icd_10.code+' uusi teksti: '+substr(uusi.c2,1,100) NOWAIT 
      replace icd_10.text with TRIM(uusi.c2)
    endif
    replace valid with .t., headline with .f.
  else
    wait window 'Uusi koodi: '+uusi.c1+' '+substr(uusi.c2,1,100)
    append blank
    replace code with uusi.c1, change with ctod('2010/01/01'), text with TRIM(uusi.c2), prim with .t., headline with .f., valid with .t., who with .f.
  endif
  select uusi
  skip
enddo
return