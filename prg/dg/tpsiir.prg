procedure tpsiir
	WAIT WINDOW NOWAIT 'Procedures and their properties'
	SELECT 0

	SELECT drgtpt
	set ORDER to code
	set FILTER to Valid
	SELECT csp
	set FILTER to NOT released
	set ORDER to code
	set RELATION to code INTO drgtpt
	set SKIP to drgtpt
	SELECT 0
	USE ..\tpt_str
	COPY to ..\aputpt.DBF next 0
	COPY next 0 to (lc_siirto+'\proc0')type foxplus FIELDS code, csp_text, vartype, varval
	USE ..\aputpt
	select drglogic
	INSERT INTO ..\aputpt (code, csp_text,vartype, varval) VALUES ('#####', 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()), p_vers, dtoc(date()))
	select drglogic
	INSERT INTO (lc_siirto+'\proc0') (code, csp_text, vartype, varval) VALUES ('#####', 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),  p_vers, dtoc(date()))
	SELECT drgtpt
	goto Top
	lc_ncsp='    '
	lc_code=' '
	lc_chap=' '
	ed_code=' '
	ed_type=' '
	ed_val=' '
	lc_code_0=' '
	tpt_0_n=0
	SELECT csp
	set relation to
	goto Top
	lc_n=0
	omin_n=0
	lc_00S99=.f.
	do WHILE NOT EOF()
		lc_n=lc_n+1
		if 100*INT(lc_n/100)=lc_n
			WAIT WINDOW NOWAIT csp.code
		endif
		lc_code=code
		SELECT drgtpt
		lc_ncsp=csp.code
		lc_dg=.F.
		lc_proc=.F.
		lc_extens=.f.
		lc_outpr=.f.
		lc_code_0=csp.code
		lc_00S99=.f.
		do WHILE drgtpt.code=lc_ncsp and not eof()
			if '0'=TRIM(drgtpt.varval)
				SELECT drgtpt
				SKIP
				LOOP
			endif
			if NOT(drgtpt.VARTYPE='OR' OR drgtpt.VARTYPE='CC')
				SELECT catomin
				SEEK drgtpt.varval
				if drgtpt.varval='99O'
 			      lc_outpr=.t.
				endif
				if NOT found() OR NOT inuse
					if NOT found()
						APPEND BLANK
						REPLACE catomin WITH drgtpt.varval, inuse WITH .F.
					endif
					SELECT drgtpt
					if EOF()
						EXIT
					endif
					SKIP
					LOOP
				endif
			endif
			omin_n=omin_n+1
			if drgtpt.VARTYPE='DGPROP'
				SELECT dgomin
				SEEK (SUBSTR(drgtpt.varval,1,2)+SUBSTR(drgtpt.varval,4,2)+SUBSTR(drgtpt.varval,3,1))
			endif
			if drgtpt.VARTYPE='PROCPR'
				SELECT tpomin
				SEEK (drgtpt.varval)
				if tpomin.extens='1'
				  lc_extens=.t.
				ENDIF
				IF drgtpt.varval='00S99'
				  lc_00S99=.t.
				ENDIF 
			endif
			SELECT csp
			do CASE
			CASE p_kieli='Fin'
				lc_text = IIF(drgtpt.VARTYPE='DGPROP', dgomin.finish, IIF(drgtpt.VARTYPE='PROCPR',tpomin.finish,'***'))
			OTHERWISE
				lc_text = IIF(drgtpt.VARTYPE='DGPROP', dgomin.english, IIF(drgtpt.VARTYPE='PROCPR',tpomin.english,'***'))
			ENDCASE
 			INSERT INTO ..\aputpt (code, VARTYPE, varval,text, csp_text) VALUES (csp.code, drgtpt.VARTYPE, drgtpt.varval,lc_text, csp.text)
			lc_code_0=' '
			SELECT drgtpt
			if NOT EOF()
				SKIP
			endif
		ENDDO
		IF NOT lc_00S99
		  DO case 
		  CASE p_kieli='Fin'
			lc_text = 'Itsenäinen toimenpide'
		  OTHERWISE
			lc_text = 'Intervention code valid for single use'
		  ENDCASE
 		  INSERT INTO ..\aputpt (code, VARTYPE, varval,text, csp_text) VALUES (csp.code, 'DGPROP', '00X99',lc_text, csp.text)
		ENDIF 
	*	if lc_outpr
		  *INSERT INTO ..\aputpt (code, VARTYPE, varval,text, csp_text) VALUES (csp.code, 'DGPROP', '00X99',lc_text, csp.text)
	*	endif
		if lc_extens
			INSERT INTO ..\aputpt (code, VARTYPE, varval,text, csp_text) VALUES (csp.code, 'PROCPR', '99S90','Extensive OR-procedure', csp.text)
		endif
		lc_code_0=' '
		if omin_n=0
		    INSERT INTO (lc_siirto+'\proc0') (code, csp_text) VALUES (csp.code, csp.text)
		endif
		omin_n=0
		SELECT csp
		skip
	ENDDO
	SELECT proc0
	COPY to (lc_siirto+'\proc0_xls.dbf') TYPE foxplus fields code, csp_text
	COPY to (lc_siirto+'\proc0.txt') DELIMITED WITH CHARACTER ';' fields code, csp_text
	COPY next 0 to apu_proc0 FIELDS code, csp_text
	USE apu_proc0
    LIST STRUCTURE TO (lc_siirto+'\proc0_str.txt')
    USE
    ERASE apu_proc0.dbf
	
	SELECT aputpt
	COPY to (lc_siirto+'\proc1.dbf') TYPE foxplus FIELDS code, VARTYPE, varval
	goto Top
	COPY to (lc_siirto+'\proc1_xls.dbf') TYPE foxplus FIELDS code, csp_text, VARTYPE, varval, text 
	COPY to (lc_siirto+'\proc1.txt') DELIMITED WITH CHARACTER ';'  FIELDS code, VARTYPE, varval
	COPY next 0 to apu_proc1 FIELDS code, VARTYPE, varval
	USE apu_proc1
    LIST STRUCTURE TO (lc_siirto+'\proc1_str.txt')
	USE
	ERASE apu_proc1.dbf
	set PRINTER OFF
	set PRINTER to

	SELECT link
	USE
	SELECT csp
	set RELATION to
	if p_kieli='Com'
		COPY to (lc_siirto+'\csp')TYPE foxplus FIELDS code, ncsp, text
		COPY to (lc_siirto+'\csp.txt') DELIMITED WITH CHAR ';' FIELDS code, ncsp, text
		COPY to apu_csp.dbf FIELDS code, ncsp, text
		SELECT 0
		USE apu_csp
        LIST STRUCTURE TO (lc_siirto+'\csp_str.txt')
        USE
        ERASE apu_csp.dbf
	ELSE
		COPY to (lc_siirto+'\csp')TYPE foxplus FIELDS code, ncsp, text
		COPY to (lc_siirto+'\csp.txt') DELIMITED WITH CHAR ';' FIELDS code, ncsp, text
		COPY to apu_csp.dbf FIELDS code, ncsp, text
		SELECT 0
		USE apu_csp
        LIST STRUCTURE TO (lc_siirto+'\csp_str.txt')
        USE
        ERASE apu_csp.dbf
	endif
	return

*!******************************************************************************
*!
*! Procedure TP_0
*!
*!  Calls
*!      EOF
*!      IIF
*!      INT
*!      INTO
*!      NOT
*!      SUBSTR
*!      TRIM
*!      VALUES
*!      aputpt
*!      found
*!      to
*!
*!******************************************************************************
procedure tp_0
	tpt_0_n=tpt_0_n+1
	if tpt_0_n=7
		tpt_0_n=1
	endif
	if tpt_n=1
    INSERT INTO (lc_siirto+'\proc0') (code, text) VALUES (csp.code, csp.text)
	ELSE
		SELECT proc0
		do CASE
		CASE tpt_0_n=2
			REPLACE code_2 WITH csp.code
		CASE tpt_0_n=3
			REPLACE code_3 WITH csp.code
		CASE tpt_0_n=4
			REPLACE code_4 WITH csp.code
		CASE tpt_0_n=5
			REPLACE code_5 WITH csp.code
		CASE tpt_0_n=6
			REPLACE code_6 WITH csp.code
		ENDCASE
	endif
	lc_code_0=' '
	return
