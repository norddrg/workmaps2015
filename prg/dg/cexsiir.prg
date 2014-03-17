procedure CEXSIIR
	WAIT WINDOW 'Exclusion lists to complication categories - transport' NOWAIT
	SELECT icd_10
	set ORDER to code
	SELECT komplex
	set ORDER to compl
	set FILTER to Valid

	SELECT 0
	USE ..\cex_str
	COPY next 0 to ..\apu_cex FIELDS compl, comptext, code, d_code, icdtext WITH cdx
	INSERT INTO ..\apu_cex (compl, comptext, code, d_code) VALUES ('#####', 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()), p_vers, dtoc(date()))
    select apu_cex
    append from ..\apu0_cex
    
	SELECT komplex
	goto Top
	lc_kompl=SPACE(5)
	do WHILE NOT EOF()
		IF komplex.compl<>lc_kompl
		   WAIT WINDOW komplex.compl nowait
		endif
		SELECT catomin
		SEEK komplex.compl
		if NOT found() OR NOT inuse
		  SEEK (SUBSTR(komplex.compl,1,2)+'I'+ SUBSTR(komplex.compl,4,2))
		endif
		if NOT found() OR NOT inuse
			if NOT found()
				APPEND BLANK
				REPLACE catomin WITH komplex.compl, inuse WITH .F.
			endif
			SELECT komplex
			SKIP
			LOOP
		endif
		if komplex.code=' '
			SELECT komplex
			SKIP
			LOOP
		endif
		SELECT icd_10
		SEEK komplex.code+komplex.d_code
		if NOT found()
			seek komplex.code
			if found()
				seek komplex.d_code
			endif
			if not found()
	  			SELECT komplex
				SKIP
				LOOP
			endif
		endif
		if komplex.compl<>'00C00'
		    select kompkat
		    seek (SUBSTR(komplex.compl,1,2)+SUBSTR(komplex.compl,4,2))
			INSERT INTO ..\apu_cex(compl, comptext, code, d_code, icdtext);
			VALUES (komplex.compl, kompkat.english, komplex.code, komplex.d_code, icd_10.text)
		endif
		lc_kompl=komplex.compl
		SELECT komplex
		SKIP
	ENDDO

	set SAFETY OFF
	SELECT apu_cex
	set ORDER to compl
	COPY to (lc_siirto+'\komplex') TYPE foxplus fields compl, code, d_code
	COPY to (lc_siirto+'\komplex_xls.dbf') TYPE foxplus 
	COPY to (lc_siirto+'\komplex.txt') DELIMITED WITH CHAR ';' 
    LIST STRUCTURE TO (lc_siirto+'\komplex_str.txt')
	return
