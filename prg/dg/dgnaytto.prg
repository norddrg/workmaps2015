procedure dgnaytto
	n_alias=ALIAS()
	do dgohje
if (n_alias= 'ICD_10' OR ('DG' = n_alias AND ORDER()<>'VARVAL') OR n_alias='KOMPLEX')
	do ..\dg\yhtnaytto
endif
apu_dcode=' '
SELECT pdgomin
set FILTER to Valid
edit WINDOW pdgprop NOWAIT Save noedit nodelete
SELECT dgkat
set FILTER to Valid
edit noedit nodelete WINDOW dgkat NOWAIT Save
SELECT dgomin
set FILTER to Valid
edit noedit nodelete WINDOW dgomin NOWAIT Save
SELECT tpomin
set FILTER to Valid
edit noedit nodelete WINDOW tpomin NOWAIT Save
SELECT kompkat
set FILTER to Valid
edit noedit nodelete WINDOW kompkat NOWAIT Save
SELECT komplex
set FILTER to Valid 
goto Top
if kompkat.compl<>' '
	set ORDER to code
	*substr(komplex.compl,1,2)+substr(komplex.compl,4,2)<>substr(kompkat.compl,1,2)+substr(kompkat.compl,4,2)
	*seek substr(kompkat.compl,1,2)+substr(kompkat.compl,4,2)
	SEEK icd_10.code+icd_10.d_code
endif
BROWSE WINDOW komplex noedit nodelete NOWAIT Save FIELDS compl, code, d_code, Valid, chdate
SELECT (n_alias)
if n_alias='ICD_10'
	do diagnaytto
	do icdnaytto
ELSE
	do icdnaytto
	do diagnaytto
endif
if n_alias='KOMPKAT' or n_alias='KOMPLEX'
	SELECT komplex
	if n_alias='KOMPKAT'
	  do while not eof() and substr(compl,1,2)+substr(compl,4,2)<>substr(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2)
	    skip
	  enddo
	  if substr(compl,1,2)+substr(compl,4,2)<>substr(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2)
		set order to compl
	    SEEK SUBSTR(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2)
	  endif
	endif
	set order to compl
	BROWSE WINDOW komplex noedit nodelete NOWAIT Save
endif

SELECT icd_10
p_ldg=code
if p_kieli='Dan'
	p_ldg=SUBSTR(p_ldg,2,5)
	if LEN(TRIM(p_ldg))>3
		p_ldg=SUBSTR(p_ldg,1,3)+'.'+SUBSTR(p_ldg,4,2)
	endif
endif
SELECT dg
return

	procedure diagnaytto
		SELECT dg
		set FILTER to Valid
		BROWSE WINDOW dg noedit nodelete FIELDS code:8:R, d_code:8:R, VARTYPE:8:R, varval:8:R, chdate:8 NOWAIT Save
		WAIT WINDOW dtoc(chdate) NOWAIT
		return

	procedure icdnaytto
		SELECT icd_10
		*set filter to valid
		BROWSE WINDOW kymppi nodelete noedit FIELDS tehty:2:R, code:R:8, ast:2, d_code:R:7, who:2:R, code_w:8, d_code_w:7,;
			text:R:30, icd10to9.icd9_cm:8:R, icd10to9.icd9_cm2:6:R NOWAIT Save
		return

