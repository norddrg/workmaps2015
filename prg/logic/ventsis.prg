Procedure ventsis
select drglogic
set order to drg
GOTO TOP
lc_print= 'drg_logi.txt'
set console off
SET PRINTER TO (lc_print)
SET PRINTER ON
?? '@PARAFILTR ON ='
?
lc_drg=-1
lc_maar=0
select dgkat
set filter to not deleted()
select drglogic
set relation to
select drgnames
set order to mdc
lc_mdc='   '
? "@TABLE = TABLE 1. Definition of DRG's"
?
lc_first=.t.
do while not eof()
  select drglogic
  seek drgnames.drg
  wait nowait window drgnames.mdc
  if lc_mdc<>drgnames.mdc
    if not lc_first
      ? '@PAGE = '
      ?
    endif
    lc_first=.f.
    lc_first_drg=.t.
    * MDC 
    select dgkat
    set order to dgkat
    seek drgnames.mdc
    ? '@MDC_CODE = ' + drgnames.mdc
    ?
    ? '@MDC_NAME ='+ trim(dgkat.name)
    ?
    lc_mdc=drgnames.mdc 
  endif
  select drgnames
  do while drgnames.drg=drg and not eof()
    do tietue
    ?
    select drglogic
    skip
  enddo
  select drgnames
  skip
enddo
set order to drg
select drglogic
SET RELATION TO drg INTO drgnames
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
return
do mdcven
do prproven
do dgkatven
do dgomiven
do tpomiven
do kompven
return


procedure tietue
if lc_drg<>drglogic.drg

  if not lc_first_drg
     ? '@NEXT_DRG = '
     ?
  endif
  lc_first_drg=.f.
  * DRGn nimi näytölle
  select drgnames
  ? '@DRG_CODE = '+ str(drglogic.drg,3,0)
  ?
  ? '@DRG_NAME = '+ moreless(drgnames.name)
  ?
  lc_maar = 1
  lc_drg=drglogic.drg
else
  lc_maar= lc_maar+1
endif

? '@HEADLINE = Definition'
if lc_maar>1
  ?? ' - '+ str(lc_maar,2,0)+':'
else
  ?? ':'
endif
?
select dgkat
if drglogic.mdc<>' '
   ? '@SUBHEAD = Necessary MDC (can be different from above):'
   ?
   ? '@CODE = '+drglogic.mdc
   ?
   seek drglogic.mdc
   ? '@NAME_S = '+ trim(dgkat.name)
endif

* PDGOMIN näytölle
if drglogic.pdgomin<>' '
  ?
  ? '@SUBHEAD = Principal diagnosis property:'
  select pdgomin
  seek drglogic.pdgomin
  ?
  ? '@CODE = ' + drglogic.pdgomin
  ?
  ? '@NAME_S = ' + trim(pdgomin.name)
endif

*OR näytölle
do case
case drglogic.or='+' 
  ?
  ? '@SUBHEAD = Operation room procedure:'
  ?
  ? '@CODE = Y'
  ?
  ? '@NAME_S = Operation room procedure necessary' 
case drglogic.or='-'
  ?
  ? '@SUBHEAD = Operation room procedure:'
  ?
  ? '@CODE = N'
  ?
  ? '@NAME_S = No operation room procedure allowed' 
endcase

* TP:t näytölle
if drglogic.tp1<>' '
   ?
   ? '@SUBHEAD = Procedure properties:'
   select tpomin
   set order to tpomin
   seek drglogic.tp1
   ?
   ? '@CODE = ' + tpomin.tpomin
   ?
   ? '@NAME_S = ' + trim(tpomin.name)
endif

if drglogic.tp2<>' '
   select tpomin
   set order to tpomin
   seek drglogic.tp2
   ?
   ? '@SUBHEAD = or'
   ?
   ? '@CODE = ' + tpomin.tpomin
   ?
   ? '@NAME_S = ' + trim(tpomin.name)
endif

if drglogic.tp3<>' '
   select tpomin
   set order to tpomin
   seek drglogic.tp3
   ?
   ? '@SUBHEAD = or'
   ?
   ? '@CODE = ' + tpomin.tpomin
   ?
   ? '@NAME_S = ' + trim(tpomin.name)
endif

* DGKAT näytölle
select dgkat
if drglogic.dgkat1<>' '
  ?
  ? '@SUBHEAD = Diagnosis category:'
  seek SUBSTR(drglogic.dgkat1,1,2)+SUBSTR(drglogic.dgkat1,4,2)
  ?
  ? '@CODE = ' + dgkat.dgkat
  ?
  ? '@NAME_S = ' + trim(dgkat.name)
endif

if drglogic.dgkat2<>' '
  seek SUBSTR(drglogic.dgkat2,1,2)+SUBSTR(drglogic.dgkat2,4,2)
  ?
  ? '@SUBHEAD = or'
  ? 
  ? '@CODE = ' + dgkat.dgkat
  ?
  ? '@NAME_S = ' + trim(dgkat.name)
endif

* ikaraja näytölle
if drglogic.ikaraja<>' '
  ?
  ? '@SUBHEAD = Age of the patient' 
  ?
  ? '@CODE = '+ drglogic.ikaraja 
  if drglogic.ikaraja='-'
     ?
     ? '@NAME_S = '+ substr(drglogic.ikaraja,2,2)+ ' yrs or less' 
  else
     ?
     ? '@NAME_S = At least '+ drglogic.ikaraja + ' yr(s)'
  endif
endif

do case
case drglogic.kompl='1'
  ?
  ? '@SUBHEAD = CC (Complication or Comorbidity):'
  ?
  ? '@CODE = Y'
  ?
  ? '@NAME_S = CC present' 
case drglogic.kompl='0'
  ?
  ? '@SUBHEAD = CC (Complication or Comorbidity):'
  ?
  ? '@CODE = N'
  ?
  ? '@NAME_S = No CC allowed'
endcase


do case
case drglogic.sex ='F'
  ?
  ? '@SUBHEAD = Gender of the patient:'
  ? 
  ? '@CODE = '+ drglogic.sex
  ?
  ? '@NAME_S = Female' 
case drglogic.sex = 'M'
  ?
  ? '@SUBHEAD = Gender of the patient:'
  ? 
  ? '@CODE = '+ drglogic.sex
  ?
  ? '@NAME_S = Male'
endcase

* DGOMIN näytölle
if drglogic.dgomin1<>' '
  ?
  ? '@SUBHEAD = Diagnosis properties (all rules have to be fullfilled!):'
  select dgomin
  set order to dgomin
  if drglogic.dgomin1='-'
    seek SUBSTR(drglogic.dgomin1,2,2)+SUBSTR(drglogic.dgomin1,5,2)+SUBSTR(drglogic.dgomin1,4,1)
  else
    seek SUBSTR(drglogic.dgomin1,1,2)+SUBSTR(drglogic.dgomin1,4,2)+SUBSTR(drglogic.dgomin1,3,1)
  endif
  if drglogic.dgomin1='-'
    ?
    ? '@SUBHEAD = NOT'
  endif
  ?
  ? '@CODE = '+ dgomin.dgomin
  ?
  ? '@NAME_S = '+ trim(dgomin.name)
endif

if drglogic.dgomin2<>' '
  if drglogic.dgomin2='-'
    seek SUBSTR(drglogic.dgomin2,2,2)+SUBSTR(drglogic.dgomin2,5,2)+SUBSTR(drglogic.dgomin2,4,1)
  else
    seek SUBSTR(drglogic.dgomin2,1,2)+SUBSTR(drglogic.dgomin2,4,2)+SUBSTR(drglogic.dgomin2,3,1)
  endif
  if drglogic.dgomin2='-'
    ?
    ? '@SUBHEAD = and NOT'
  else
    ?
    ? '@SUBHEAD = and'
  endif
  ?
  ? '@CODE = ' + dgomin.dgomin
  ?
  ? '@NAME_S = '+ trim(dgomin.name)
endif

if drglogic.dgomin3<>' '
  if drglogic.dgomin3='-'
    seek SUBSTR(drglogic.dgomin3,2,2)+SUBSTR(drglogic.dgomin3,5,2)+SUBSTR(drglogic.dgomin3,4,1)
  else
    seek SUBSTR(drglogic.dgomin3,1,2)+SUBSTR(drglogic.dgomin3,4,2)+SUBSTR(drglogic.dgomin3,3,1)
  endif
  if drglogic.dgomin3='-'
    ?
    ? '@SUBHEAD = and NOT'
  else
    ?
    ? '@SUBHEAD = and'
  endif
  ? 
  ? '@CODE = '+ dgomin.dgomin
  ?
  ? '@NAME_S = '+ trim(dgomin.name)
endif

if drglogic.dgomin4<>' '
  if drglogic.dgomin4='-'
    seek SUBSTR(drglogic.dgomin4,2,2)+SUBSTR(drglogic.dgomin4,5,2)+SUBSTR(drglogic.dgomin4,4,1)
  else
    seek SUBSTR(drglogic.dgomin4,1,2)+SUBSTR(drglogic.dgomin4,4,2)+SUBSTR(drglogic.dgomin4,3,1)
  endif
  if drglogic.dgomin4='-'
    ?
    ? '@SUBHEAD = and NOT'
  else
    ?
    ? '@SUBHEAD = and'
  endif
  ?
  ? '@CODE = '+ dgomin.dgomin
  ?
  ? '@NAME_S = '+ trim(dgomin.name)
endif

if drglogic.stp1<>' '
  ?
  ? '@SUBHEAD = Secondary procedure property'
  if len(trim(drglogic.stp1))>1
    select tpomin
    if drglogic.stp1 = '-'
      seek substr(drglogic.stp1,2,5)
    else
      seek trim(drglogic.stp1)
    endif
  endif
  if drglogic.stp1='-' and len(trim(drglogic.stp1))>1
     ?
     ? '@SUBHEAD = If more than one OR procedure, following proc.prob. is NOT allowed'
  else
     if len(trim(drglogic.stp1))>1
       ? 
       ? '@SUBHEAD = In addition to previously mentioned operation'
     endif
  endif
  do case
  case drglogic.stp1='- '
     ? 
     ? '@CODE = '+ drglogic.stp1
     ?
     ? '@NAME_S = No other OR procedures allowed'
  case drglogic.stp1='+'
     ? 
     ? '@CODE = '+ drglogic.stp1
     ?
     ? '@NAME_S = At least 2 OR procedures necessary'
  otherwise
     ? 
     ? '@CODE = '+ drglogic.stp1
     ?
     ? '@NAME_S = '+ tpomin.name
  endcase
endif

do case
case drglogic.exitus='E'
   ?
   ? '@SUBHEAD = Discharge situation:'
   ? 
   ? '@CODE = '+ drglogic.exitus
   ?
   ? '@NAME_S = Death'
case drglogic.exitus = 'R'
   ?
   ? '@SUBHEAD = Discharge situation:'
   ? 
   ? '@CODE = '+ drglogic.exitus
   ?
   ? '@NAME_S = Remitted to other hospital'
case drglogic.exitus = 'L'
   ?
   ? '@SUBHEAD = Discharge situation:'
   ? 
   ? '@CODE = '+ drglogic.exitus
   ?
   ? '@NAME_S = Left againsta medical advice'
endcase
return

procedure mdcven
select drgtpt
set relation to code into ncsp_en
select icd10
set order to icd_10_1
select dg
set order to dgkat
set filter to
select dgkat
set filter to not deleted() and len(trim(dgkat))=2
goto top
SET PRINTER OFF
set console off
lc_print= 'MDCGRPS.txt'
SET PRINTER TO (lc_print)
SET PRINTER ON
?? '@PARAFILTR ON ='
?
? "@TABLE = TABLE 2. Diagnoses in the MDC's"
?
lc_first=.t.
do while not eof()
  if not lc_first
    ? '@PAGE ='
    ?
  endif
  lc_first=.f.
  wait nowait window dgkat.dgkat
  ? '@MDC_CODE = '+trim(dgkat.dgkat)
  ?
  ? '@MDC_NAME = '+trim(dgkat.name)
  ?
  if trim(dgkat.dgkat)='00'
    ? '@CODE = '
    ?
    ? "@NAME = PreMDC DRG's - all dg's acceptable"
    ?
    select dgkat
    skip
    loop
  endif
  select dg
  seek trim(dgkat.dgkat)
  lc_dg=space(10)
  do while dg.dgkat=trim(dgkat.dgkat) and not eof()
    if lc_dg=icd_10_o+icd_10_e
      skip
      loop
    endif
    lc_dg=icd_10_o+icd_10_e
    ? '@CODE = '+trim(icd_10_o)
    if icd_10_e<>' '
      ?? '*'+trim(icd_10_e)
      ?
      ? '@NAME_A = '
    else
      ?
      ? '@NAME = '
    endif
    SELECT icd10
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
  select dgkat
  skip
enddo
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
return

procedure prproven
select icd10
set order to icd_10_1
select dg
set order to pdgomin
set filter to not deleted()
select pdgomin
set filter to not deleted()
goto top
SET PRINTER OFF
set console off
lc_print= 'PRDGPROP.txt'
SET PRINTER TO (lc_print)
SET PRINTER ON
?? '@PARAFILTR ON ='
?
? "@TABLE = TABLE 3. Diagnoses with Principal diagnosis properties"
?
lc_first=.t.
do while not eof()
  if not lc_first
    ? '@PAGE ='
    ?
  endif
  lc_first=.f.
  wait nowait window pdgomin.pdgomin
  ? '@MDC_CODE = '+trim(pdgomin.pdgomin)
  ?
  ? '@MDC_NAME = '+trim(pdgomin.name)
  ?
  select dg
  seek trim(pdgomin.pdgomin)
  lc_dg=space(10)
  do while dg.pdgomin=trim(pdgomin.pdgomin) and not eof()
    if lc_dg=icd_10_o+icd_10_e
      skip
      loop
    endif
    lc_dg=icd_10_o+icd_10_e
    ? '@CODE = '+trim(icd_10_o)
    if icd_10_e<>' '
      ?? '*'+trim(icd_10_e)
      ?
      ? '@NAME_A = '
    else
      ?
      ? '@NAME = '
    endif
    SELECT icd10
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
  select pdgomin
  skip
enddo
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
return

procedure dgkatven
select drgtpt
set relation to code into ncsp_en
select icd10
set order to icd_10_1
select dg
set order to dgkat
set filter to
select dgkat
set filter to not deleted() and len(trim(dgkat))>2
goto top
SET PRINTER OFF
set console off
lc_print= 'DGKATS.txt'
SET PRINTER TO (lc_print)
SET PRINTER ON
?? '@PARAFILTR ON ='
?
? "@TABLE = TABLE 4. Diagnoses in the Diagnoses categories"
?
lc_first=.t.
lc_mdc=substr(dgkat.dgkat,1,2)
do while not eof()
  if dgkat=' '
    select dgkat
    skip
    loop
  endif
  if substr(dgkat.dgkat,1,2)<>lc_mdc and not lc_first
    ? '@PAGE = '
    ?
  else
    if not lc_first
      ? '@VALI ='
      ?
    endif
  endif
  lc_mdc=substr(dgkat.dgkat,1,2)
  lc_first=.f.
  wait nowait window dgkat.dgkat
  ? '@OTS_CODE = '+trim(dgkat.dgkat)
  ?
  ? '@OTS_NAME = '+trim(dgkat.name)
  ?
  select dg
  seek SUBSTR(dgkat.dgkat,1,2)+SUBSTR(dgkat.dgkat,4,2)
  lc_dg=space(10)
  do while dg.dgkat=trim(dgkat.dgkat) and not eof()
    if lc_dg=icd_10_o+icd_10_e
      skip
      loop
    endif
    lc_dg=icd_10_o+icd_10_e
    ? '@CODE = '+trim(icd_10_o)
    if icd_10_e<>' '
      ?? '*'+trim(icd_10_e)
      ?
      ? '@NAME_A = '
    else
      ?
      ? '@NAME = '
    endif
    SELECT icd10
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
  select dgkat
  skip
enddo
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
return

procedure dgomiven
select drgtpt
set filter to language = 'C'
set relation to code into ncsp_en
select icd10
set order to icd_10_1
select dg
set order to dgomin
set filter to
select drgtpt
set order to dgomin
select dgomin
set filter to not deleted() 
goto top
SET PRINTER OFF
set console off
lc_print= 'DGOMINS.txt'
SET PRINTER TO (lc_print)
SET PRINTER ON
?? '@PARAFILTR ON ='
?
? "@TABLE = TABLE 5. Diagnoses and procedures with Diagnosis properties"
?
lc_first=.t.
select dgomin
goto top
lc_mdc=substr(dgomin.dgomin,1,2)
do while not eof()
  if dgomin=' '
     skip
     loop
  endif
  if substr(dgomin.dgomin,1,2)<>lc_mdc and not lc_first
    ? '@PAGE = '
    ?
  else
    if not lc_first
      ? '@VALI ='
      ?
    endif
  endif
  lc_mdc=substr(dgomin.dgomin,1,2)
  lc_first=.f.
  wait nowait window dgomin.dgomin
  ? '@OTS_CODE = '+trim(dgomin.dgomin)
  ?
  ? '@OTS_NAME = '+trim(dgomin.name)
  ?
  select dg
  seek dgomin.dgomin
  lc_dg=space(10)
  do while dgomin=dgomin.dgomin and not eof()
    if lc_dg=icd_10_o+icd_10_e
      skip
      loop
    endif
    lc_dg=icd_10_o+icd_10_e
    ? '@CODE = '+trim(icd_10_o)
    if icd_10_e<>' '
      ?? '*'+trim(icd_10_e)
      ?
      ? '@NAME_A = '
    else
      ?
      ? '@NAME = '
    endif
    SELECT icd10
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
  seek dgomin.dgomin
  do while (dgomin=dgomin.dgomin and not eof())
    ? '@CODE = '+trim(drgtpt.code)
    ?
    ? '@NAME = '+trim (ncsp_en.english)
    ?
    select drgtpt
    skip
  enddo
  select dgomin
  skip
enddo
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
return

procedure kompven
lc_print='kompkat.txt'
SET PRINTER TO (lc_print)
set console off
SET PRINTER ON
?? '@PARAFILTR ON ='
?
SELECT kompkat
SET ORDER TO kompl
SET FILTER TO NOT DELETED()
SET RELATION TO SUBSTR(inclomin,1,2)+SUBSTR(inclomin,4,2)+SUBSTR(inclomin,3,1) INTO dgomin
? '@TABLE = TABLE 7. Complication categories'
?
wait nowait window 'Complication categories'
GOTO TOP
DO WHILE NOT EOF()
   ? '@VALI = '
   ?
   ? '@OTS_CODE = '
   ?? kompl
   ?
   ? '@OTS_NAME = '
   ?? TRIM(kompkat.name)
   ?
   IF inclomin<>' '
      ? '@D_OTS = INCL PROP'
      ?
      ? '@CODE = '
      ?? kompkat.inclomin
      ?
      ? '@NAME = '
      ?? TRIM(dgomin.name)
      ?
   ENDIF
   SKIP
ENDDO
SET PRINTER OFF
SET PRINTER TO

lc_print='komplex.txt'
SET PRINTER TO (lc_print)
SET PRINTER ON
?? '@PARAFILTR ON ='
?
SELECT komplex
SET ORDER TO kompl
SET FILTER TO NOT DELETED()
SET RELATION TO  SUBSTR(kompl,1,2)+SUBSTR(kompl,4,2) INTO kompkat
? '@TABLE = TABLE 8. Exclusion lists to complication categories'
?
GOTO TOP
lc_kompl=SPACE(5)
DO WHILE NOT EOF()
   IF kompl<>lc_kompl
      if substr(kompl,1,2)<>substr(lc_kompl,1,2)
        ? '@PAGE = '
      else
        ? '@VALI = '
      endif
      ?
      wait nowait window kompl
      ? '@OTS_CODE = '
      ?? kompl
      ?
      ? '@OTS_NAME = '
      ?? TRIM(kompkat.name)
      ?
   ENDIF
    ? '@CODE = '+trim(icd_10_o)
    if icd_10_e<>' '
      ?? '*'+trim(icd_10_e)
      ?
      ? '@NAME_A = '
    else
      ?
      ? '@NAME = '
    endif
   SELECT icd10
   IF komplex.icd_10_e=SPACE(6)
      SEEK trim(komplex.icd_10_o)
   ELSE
      SEEK komplex.icd_10_e+komplex.icd_10_o
   ENDIF
   IF icd10.text<>' '
      ?? TRIM(icd10.text)
   ELSE
      SEEK komplex.icd_10_o
      IF FOUND()
         ?? TRIM(icd10.text)+'; '
      ELSE
         SEEK (SUBSTR(komplex.icd_10_o,1,3))
         ?? TRIM(icd10.text)+'; '
      ENDIF
      SEEK TRIM(komplex.icd_10_e)
      IF FOUND()
         ?? TRIM(icd10.text)
      else
         ?? '---'
      ENDIF
   ENDIF
   ?
   SELECT komplex
   lc_kompl=kompl
   SKIP
ENDDO
SET PRINTER OFF
SET PRINTER TO
return

function moreless
parameter lc_text
lc_text=trim(lc_text)
if at('<', lc_text)>0
  lc_text=substr(lc_text,1,at('<', lc_text))+'<'+ substr(lc_text,at('<', lc_text)+1,len(lc_text))
endif
if at('>', lc_text)>0
  lc_text=substr(lc_text,1,at('>', lc_text))+'>'+ substr(lc_text,at('>', lc_text)+1,len(lc_text))
endif
return lc_text
