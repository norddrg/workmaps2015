procedure tark
on KEY label ctrl+T
lc_n=0
lc_code=' '
lc_dcode=' '
lc_val=' '
kat_code=' '
kat_dcode=' '
kat_val=' '
lc_kat=.T.
SELECT dg
goto top
do WHILE NOT EOF()
	if 100*INT(lc_n/100)=lc_n
		WAIT WINDOW 'Second round ' +dg.code+' '+dg.d_code NOWAIT
	endif
	lc_n=lc_n+1
	if NOT lc_kat AND lc_code<>code
		do dgnaytto
		WAIT WINDOW 'No diagnosis category? - To continue press any key'
		on KEY label ctrl+T do tark
		return
	endif
	SELECT dg
	lc_pois=.F.
	if lc_code=dg.code AND lc_dcode=dg.d_code AND lc_val=dg.varval
		lc_pois=.T.
	endif
	if dg.VARTYPE='DGCAT'
		do CASE
		CASE kat_code=dg.code AND kat_dcode=dg.d_code
			do dgnaytto
			WAIT WINDOW NOWAIT 'Double DGCAT definition!'
			on KEY label ctrl+T do tark
			return
		CASE kat_code=dg.code AND kat_val=dg.varval
			lc_pois=.T.
		CASE dg.d_code=' '
			kat_code=dg.code
			kat_dcode=dg.d_code
			kat_val=dg.varval
			lc_kat=.T.
		ENDCASE
	endif
	SELECT icd_10
	SEEK upper(dg.code+dg.d_code)
	if NOT found() AND dg.d_code<>' '
		SEEK upper(dg.code)
		if found()
			SEEK upper(dg.d_code)
		endif
	endif
	if NOT found()
		lc_pois=.T.
	endif
	if lc_pois
		select dg
		REPLACE Valid WITH .F.
	ELSE
		lc_code=dg.code
		lc_dcode=dg.d_code
		lc_val=dg.varval
	endif
	if icd_10.d_code<>' ' AND NOT lc_pois
		ap_code=dg.code
		ap_dcode=dg.d_code
		ap_vartype=dg.VARTYPE
		ap_varval=dg.varval
		SEEK upper(ap_code)+SPACE(6)+ap_vartype+ap_varval
		if NOT found()
			SEEK upper(ap_dcode)+SPACE(6)+ ap_vartype+ ap_varval
		endif
		if found()
			SEEK upper(ap_code+ap_dcode)+ap_vartype+ap_varval
			REPLACE Valid WITH .F.
		ELSE
			SEEK upper (ap_code+ap_dcode) +ap_vartype+ap_varval
		endif
	endif
	SELECT dg
	lc_type=VARTYPE
	do CASE
	CASE VARTYPE='COMPL'
		SELECT kompkat
		SEEK SUBSTR(dg.varval,1,2)+SUBSTR(dg.varval,4,2)
*		+SUBSTR(dg.varval,3,1)
	CASE VARTYPE='DGCAT'
		SELECT dgkat
		if dg.varval=' '
			SEEK ''
		ELSE
			SEEK SUBSTR(dg.varval,1,2)+SUBSTR(dg.varval,4,2)
		endif
	CASE VARTYPE='DGPROP'
		SELECT dgomin
		SEEK SUBSTR(dg.varval,1,2)+SUBSTR(dg.varval,4,2)+SUBSTR(dg.varval,3,1)
	CASE VARTYPE='PDGPRO'
		SELECT pdgomin
		SEEK dg.varval
	CASE VARTYPE='PROCPR'
		SELECT tpomin
		SEEK dg.varval
	CASE VARTYPE='OR'
		if varval<>'1'
			do dgnaytto
			WAIT WINDOW 'Unnecessary OR-row! - To continue press any key'
			on KEY label ctrl+T do tark
			return
		endif
		SELECT dg
		SKIP
		LOOP
	OTHERWISE
		if NOT EOF()
			SELECT dg
			do dgnaytto
			WAIT WINDOW 'Unnecessary row? - To continue press any key'
			on KEY label ctrl+T do tark
			return
		endif
	ENDCASE
	if NOT found() AND NOT EOF()
		SELECT dg
		do dgnaytto
		WAIT WINDOW lc_type+'-value not found! - To continue press any key'
		on KEY label ctrl+T do tark
		return
	endif
	SELECT dg
	if NOT EOF()
		SKIP
	endif
ENDDO
on KEY label ctrl+T do COMPLTARK
do COMPLTARK
return
