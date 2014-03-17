procedure inuselis
WAIT WINDOW NOWAIT 'Building list of used properties'
SELECT tpomin
REPLACE ALL inuse WITH .F.
SELECT dgomin
REPLACE ALL inuse WITH .F.
SELECT dg
dg_ord=ORDER()
set filter to valid 
SELECT catomin
delete ALL
pack

SELECT tpomin
replace ALL or_1 WITH .t.
SELECT drgtpt
SET ORDER TO CODE   && CODE+VARTYPE+VARVAL
GOTO TOP 
inu_code=SPACE(7)
DO WHILE NOT EOF()
  inu_or_1=.t.
  IF drgtpt.vartype='OR' AND drgtpt.varval<>'1'
    inu_OR_1=.f. 
    * not all OR=1
    inu_code=drgtpt.code
  ENDIF
  DO WHILE NOT EOF()
    IF (not inu_OR_1) AND drgtpt.vartype='PROCPR' 
      SELECT tpomin
      SEEK TRIM(drgtpt.varval)
	  if found()
		REPLACE OR_1 WITH .f.
		IF tpomin.extens='1'
		* not all extens interventions are OR=1!
		  SEEK '99S90'
		  replace or_1 WITH .f.
		  WAIT WINDOW inu_code + ' - is extens intervetions but OR is not 1' nowait
		ENDIF 
      ENDIF 
    ENDIF 
    SELECT drgtpt
    SKIP
    IF TRIM(drgtpt.code)<>TRIM(inu_code)
       SKIP -1
       exit
    ENDIF 
  ENDDO
  SELECT drgtpt
  IF NOT EOF()
    SKIP 
  ENDIF 
ENDDO 

SELECT drglogic
set FILTER to
REPLACE ALL inuse WITH .F.
set FILTER to Valid
REPLACE ALL inuse WITH .T.
if p_class
  set filter to (dur='<2' OR dur='<3') and disch<>'E'
  replace all inuse with .f.
  set filter to inuse
endif
set ORDER to ord
goto Top
do WHILE NOT EOF()
  WAIT WINDOW NOWAIT drglogic.ord
  lc_use=.T.
  inu_ane=.f.
  select drglogic
  if pdgprop<>' '
    SELECT dg
    set ORDER to varval
    SEEK 'PDGPRO  '+SUBSTR(drglogic.pdgprop,1,2)+SUBSTR(drglogic.pdgprop,4,2)+SUBSTR(drglogic.pdgprop,3,1)
    if NOT found()
      REPLACE drglogic.inuse WITH .F.
    endif
  endif

  SELECT drglogic
  if procpro1<>' '
    SELECT dg
    set ORDER to varval
    SEEK 'PROCPR  '+SUBSTR(drglogic.procpro1,1,2)+SUBSTR(drglogic.procpro1,4,2)+SUBSTR(drglogic.procpro1,3,1)
    if NOT found()
      SELECT drgtpt
      set ORDER to varval
      SEEK 'PROCPR  '+trim(drglogic.procpro1)
      if drglogic.procpro1='99S9'
        seek 'PROCPR  '+'99S'
      endif
    endif
    if NOT found()
      REPLACE drglogic.inuse WITH .F.
    ELSE
      SELECT tpomin
      SEEK trim(drglogic.procpro1)
      if found()
        REPLACE inuse WITH .T.
      endif
      if drglogic.procpro1='99S90'
        replace inuse with .T. for procprop='99S'
      endif
    endif
  endif

  SELECT drglogic
  IF (dgprop1='00X10' OR dgprop2='00X10' OR dgprop3='00X10' OR dgprop4='00X10') AND procpro1<>' ' 
    SELECT tpomin
    SEEK drglogic.procpro1
    IF FOUND() AND NOT tpomin.or_1=.f.
      replace drglogic.inuse WITH .f.
    endif
  ENDIF 

  SELECT drglogic
  if dgcat1<>' '
    SELECT dg
    set ORDER to varval
    SEEK 'DGCAT   '+SUBSTR(drglogic.dgcat1,1,2)+SUBSTR(drglogic.dgcat1,4,2)+SUBSTR(drglogic.dgcat1,3,1)
    if NOT found()
      if drglogic.dgcat1='12' OR drglogic.dgcat1='13'
        SEEK 'DGCAT   '+'98'+SUBSTR(drglogic.dgcat1,4,2)+SUBSTR(drglogic.dgcat1,3,1)
      endif
      if NOT found()
        REPLACE drglogic.inuse WITH .F.
      endif
    endif
  endif
  SELECT drglogic
  if dgprop1<>' '
    lc_dgprop=dgprop1
    if dgprop1='-'
      lc_dgprop=SUBSTR(dgprop1,2,5)
    endif
    SELECT dg
    set ORDER to varval
    SEEK 'DGPROP  '+SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
    if NOT found()
      SELECT drgtpt
      set ORDER to varval
      SEEK 'DGPROP  '+TRIM(lc_dgprop)
    endif
    if NOT found() and substr(lc_dgprop,3,3)<>'X99'
      REPLACE drglogic.inuse WITH .F.
    ELSE
      SELECT dgomin
      SEEK SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
      if found() or substr(lc_dgprop,3,3)='X99'
        REPLACE inuse WITH .T.
      endif
    endif
  endif
  SELECT drglogic
  if dgprop2<>' '
    lc_dgprop=dgprop2
    if dgprop2='-'
      lc_dgprop=SUBSTR(dgprop2,2,5)
    endif
    SELECT dg
    set ORDER to varval
    SEEK 'DGPROP  '+SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
    if NOT found()
      SELECT drgtpt
      SEEK 'DGPROP  '+TRIM(lc_dgprop)
    endif
    if NOT found()
      REPLACE drglogic.inuse WITH .F.
    ELSE
      SELECT dgomin
      SEEK SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
      if found()
        REPLACE inuse WITH .T.
      endif
    endif
  endif
  SELECT drglogic
  if dgprop3<>' '
    lc_dgprop=dgprop3
    if dgprop3='-'
      lc_dgprop=SUBSTR(dgprop3,2,5)
    endif
    SELECT dg
    set ORDER to varval
    SEEK 'DGPROP  '+SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
    if NOT found()
      SELECT drgtpt
      SEEK 'DGPROP  '+TRIM(lc_dgprop)
    endif
    if NOT found()
      REPLACE drglogic.inuse WITH .F.
    ELSE
      SELECT dgomin
      SEEK SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
      if found()
        REPLACE inuse WITH .T.
      endif
    endif
  endif
  SELECT drglogic
  if dgprop4<>' '
    lc_dgprop=dgprop4
    if dgprop4='-'
      lc_dgprop=SUBSTR(dgprop4,2,5)
    endif
    SELECT dg
    set ORDER to varval
    SEEK 'DGPROP  '+SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
    if NOT found()
      SELECT drgtpt
      SEEK 'DGPROP  '+TRIM(lc_dgprop)
    endif
    if NOT found()
      REPLACE drglogic.inuse WITH .F.
    ELSE
      SELECT dgomin
      SEEK SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
      if found()
        REPLACE inuse WITH .T.
      endif
    endif
  endif
  SELECT drglogic
  if secproc1<>' ' AND secproc1<>'+' AND secproc1<>'- '
    if secproc1<>'-'
    lc_secproc=TRIM(secproc1)
    ELSE
      lc_secproc=SUBSTR(secproc1,2,5)
    endif
    SELECT dg
    set ORDER to varval
    SEEK 'PROCPR  '+SUBSTR(lc_secproc,1,2)+SUBSTR(lc_secproc,4,2)+SUBSTR(lc_secproc,3,1)
    if NOT found()
      SELECT drgtpt
      SEEK 'PROCPR  '+ lc_secproc
    endif
    if NOT found()
      select drglogic
      if drglogic.secproc1<>'-'
        REPLACE drglogic.inuse WITH .F.
      endif
      lc_use=.F.
    ELSE
      SELECT tpomin
      SEEK lc_secproc
      if found()
        REPLACE inuse WITH .T.
      endif
    endif
  endif
  SELECT drglogic
  if inuse
    do accrow
  endif
  if inuse
    select drgnames
    set order to drg
    seek drglogic.drg
    if found()
      replace valid with .t.
    endif
  endif
  SELECT drglogic
  SKIP
ENDDO
goto Top

SELECT dg
set ORDER to varval
SELECT komplex
set FILTER to valid

SELECT kompkat
REPLACE ALL inuse WITH .T.
goto Top
do WHILE NOT EOF()
  SELECT dg
  SEEK 'COMPL   '+SUBSTR(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2)
  if NOT found()
    SELECT catomin
    SEEK TRIM(kompkat.compl)
    if NOT found()
      APPEND BLANK
      REPLACE catomin WITH kompkat.compl, inuse WITH .F.
    endif
    SELECT kompkat
    REPLACE kompkat.inuse WITH .F.
    SKIP
    LOOP
  endif
  SELECT catomin
  APPEND BLANK
  REPLACE catomin WITH kompkat.compl, inuse WITH .T.
  if kompkat.inclprop<>'   '
    SELECT dg
    set filter to
    SEEK 'DGPROP  '+SUBSTR(kompkat.inclprop,1,2)+SUBSTR(kompkat.inclprop,4,2)
    if not found()
      select drgtpt
      set order to varval
      SEEK 'DGPROP  '+kompkat.inclprop
    endif
    if found()
      SELECT catomin
      SEEK TRIM(kompkat.inclprop)
      if NOT found() OR NOT inuse
        if NOT found()
          APPEND BLANK
          REPLACE catomin WITH kompkat.inclprop, inuse WITH .T.
        ELSE
          REPLACE inuse WITH .T.
        endif
      endif
      select dgomin
      SEEK SUBSTR(kompkat.inclprop,1,2)+SUBSTR(kompkat.inclprop,4,2)+SUBSTR(kompkat.inclprop,3,1)
      if found()
        replace inuse with .t.
      endif
    else
      select catomin
      SEEK TRIM(kompkat.compl)
      replace inuse with .f.
      select kompkat
      replace kompkat.inuse with .f.
    endif
  endif
  SELECT kompkat
  SKIP
ENDDO
SELECT komplex
goto Top
inl_n=0
do WHILE NOT EOF()
  inl_n=inl_n+1
  if 100*(int(inl_n/100))=inl_n
    wait window nowait 'CC excl. '+str(inl_n)
  endif
  SELECT icd_10
  SEEK komplex.code+komplex.d_code
  if NOT found()
    SEEK komplex.code
    if found()
      SEEK komplex.d_code
    endif
  endif
  if found()
    REPLACE komplex.valid WITH .T.
  ELSE
    REPLACE komplex.valid WITH .F.
  endif
  SELECT komplex
  SKIP
ENDDO
REPLACE ALL inuse WITH .T.
goto Top
inl_n=0
do WHILE NOT EOF()
  inl_n=inl_n+1
  if 100*(int(inl_n/100))=inl_n 
    wait window nowait 'CC excl. '+str(inl_n)
  endif
  SELECT kompkat
  SEEK SUBSTR(komplex.compl,1,2)+SUBSTR(komplex.compl,4,2)
  if NOT found() OR NOT inuse
    SELECT komplex
    REPLACE komplex.inuse WITH .F.
  endif
  SELECT komplex
  SKIP
ENDDO
SELECT komplex
set FILTER to Valid
SELECT dg
set FILTER to Valid
set ORDER to (dg_ord)

RETURN 

*!******************************************************************************
*!
*! Procedure ACCROW
*!
*!  Calls
*!      EOF
*!      ORDER
*!      SUBSTR
*!      TRIM
*!      found
*!      to
*!
*!******************************************************************************
procedure accrow
do accrow2 WITH TRIM(drglogic.pdgprop)
do accrow2 WITH TRIM(drglogic.procpro1)
do accrow2 WITH TRIM(drglogic.dgcat1)
do accrow2 WITH TRIM(drglogic.dgprop1)
do accrow2 WITH TRIM(drglogic.dgprop2)
do accrow2 WITH TRIM(drglogic.dgprop3)
do accrow2 WITH TRIM(drglogic.dgprop4)
if lc_use
  do accrow2 WITH TRIM(drglogic.secproc1)
endif
return

*!******************************************************************************
*!
*! Procedure ACCROW2
*!
*!  Calls
*!      EOF
*!      ORDER
*!      SUBSTR
*!      TRIM
*!      found
*!      to
*!
*!******************************************************************************
procedure accrow2
	parameter procvar
	if procvar='-' OR procvar='+'
		procvar=SUBSTR(procvar,2,5)
	endif
	if procvar=' '
		return
	endif
	SELECT catomin
	SEEK procvar
	if NOT found()
		APPEND BLANK
		REPLACE catomin WITH procvar, inuse WITH .T.
	endif
	return
