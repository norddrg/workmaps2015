procedure tpomiven
select drgtpt
set filter to language = 'C'
set relation to code into ncsp_en
select icd10
set order to icd_10_1
select dg
set order to tpomin
set filter to
select drgtpt
set order to tpomin
select tpomin
set filter to not deleted() 
goto top
SET PRINTER OFF
set console off
lc_print= '\data\drglogic\PRPRO_1.txt'
SET PRINTER TO (lc_print)
SET PRINTER ON
?? '@PARAFILTR ON ='
?
? "@TABLE = TABLE 6. Procedures and diagnoses with Procedure properties"
?
select tpomin
goto top
lc_first=.t.
lc_20=.f.
lc_mdc=substr(tpomin.tpomin,1,2)
do while not eof()
  if tpomin=' '
     skip
     loop
  endif
  if lc_mdc='20' and not lc_20
    lc_print= '\data\drglogic\PRPRO_2.txt'
    SET PRINTER TO (lc_print)
    SET PRINTER ON
    ?? '@PARAFILTR ON ='
    ?
    ? "@TABLE = TABLE 6. Procedures and diagnoses with Procedure properties"
    ?
    lc_20=.t.
  endif
  if substr(tpomin.tpomin,1,2)<>lc_mdc and not lc_first
    ? '@PAGE = '
    ?
  else
    if not lc_first
      ? '@VALI ='
      ?
    endif
  endif
  lc_mdc=substr(tpomin.tpomin,1,2)
  lc_first=.f.
  wait nowait window tpomin.tpomin
  ? '@OTS_CODE = '+trim(tpomin.tpomin)
  ?
  ? '@OTS_NAME = '+trim(tpomin.name)
  ?
  select dg
  seek tpomin.tpomin
  lc_dg=space(10)
  do while tpomin=tpomin.tpomin and not eof()
    if lc_dg=icd_10_o+icd_10_e
      skip
      loop
    endif
    lc_dg=icd_10_o+icd_10_e
    ? '@CODE = '+trim(icd_10_o)
    if icd_10_e<>' '
      ?? '*'+trim(icd_10_e)
      ?
      if kompl='1'
        ? '@CC= '
        ?
      endif
      if or='1'
        ? '@OR= '
        ?
      endif
      ? '@NAME_A = '
    else
      ?
      if or='1'
        ? '@OR= '
        ?
      endif
      ? '@NAME = '
    endif
    SELECT icd10
    IF dg.icd_10_e=SPACE(6)
      SEEK dg.icd_10_o
    ELSE
      SEEK dg.icd_10_e+dg.icd_10_o
    ENDIF
    IF dg.icd_10_e=SPACE(6)
      SEEK trim(dg.icd_10_o)
    ELSE
      SEEK trim(dg.icd_10_e+dg.icd_10_o)
    ENDIF
    IF icd10.text<>' '
      ?? TRIM(icd10.text)
    ELSE
      SEEK trim(dg.icd_10_o)
      IF FOUND()
         ?? TRIM(icd10.text)+'; '
      ELSE
         SEEK (SUBSTR(dg.icd_10_o,1,3))
         ?? TRIM(icd10.text)+'; '
      ENDIF
      SEEK TRIM(dg.icd_10_e)
      IF FOUND()
         ?? TRIM(icd10.text)
      else
         ?? '---'
      ENDIF
    ENDIF
    ?
    select dg
    skip
  enddo
  select drgtpt
  seek tpomin.tpomin
  do while (tpomin=tpomin.tpomin and not eof())
    ? '@CODE = '+trim(drgtpt.code)
    ?
    if kompl='1'
      ? '@CC='
      ?
    endif
    if or='1'
      ? '@OR= '
      ?
    endif
    ? '@NAME = '+trim (ncsp_en.english)
    ?
    select drgtpt
    skip
  enddo
  select tpomin
  skip
enddo
select drgtpt
seek (space(5))
? '@PAGE ='
?
? '@OTS_CODE = -----'
?
? '@OTS_NAME = Procedures without procedure properties'
?
do while drgtpt.tpomin=' ' and not eof()
  ? '@CODE = '+trim(drgtpt.code)
  ?
  if or='1'
    ? '@OR= '
    ?
  endif
  ? '@NAME = '+trim (ncsp_en.english)
  ?
  select drgtpt
  skip
enddo
set filter to not deleted()
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
return
