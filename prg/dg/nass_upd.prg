Procedure NASS_upd
select icd_10
set order to code
select nass
goto  top
do while not eof()
 select icd_10
 seek upper(nass.code)
 if not found()
  append blank
  replace change with date(), valid with .t., code with nass.code, text with nass.text, who with .f. code_w WITH nass.code
 ENDIF
 replace ast with 'N', headline with .f., prim with .t.
 select nass
 skip
enddo
return


