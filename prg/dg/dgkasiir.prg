*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\DGKASIIR.PRG
*:
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	Nordic Centre for Classification of Diseases
*:	
*:	Nordic Centre for Classification of Diseaes
*:	NordDRG Maintenance system
*:	
*:
*: Documented using Visual FoxPro Formatting wizard version  .05
*:******************************************************************************
*:   DGKASIIR
*!******************************************************************************
*!
*! Procedure DGKASIIR
*!
*!  Calls
*!      EOF
*!      INTO
*!      LEN
*!      TRIM
*!      VALUES
*!      found
*!      to
*!
*!******************************************************************************
procedure DGKASIIR

	SELECT catomin
	set ORDER to catomin
	SELECT 0
	USE ..\dgkat_st
	COPY to (lc_siirto+'\dgkat.dbf')TYPE foxplus next 0
	COPY to (lc_siirto+'\mdc.dbf')TYPE foxplus next 0	
	USE (lc_siirto+'\dgkat.dbf') ALIAS apusiir
	append blank
	replace dgcat with '#####', text with 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date())
	select 0
	USE (lc_siirto+'\mdc.dbf') ALIAS mdcsiir
	append blank
	replace dgcat with '#####', text with 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date())
	SELECT dgkat
	WAIT WINDOW NOWAIT 'Diagnosis categories'
	set ORDER to dgcat
	set FILTER to Valid
	lc_apu=lc_siirto+'\dgkat'
	lc_mapu=lc_siirto+'\mdc'
	goto Top
	do WHILE NOT EOF()
		SELECT catomin
		SEEK dgkat.dgcat
		if NOT found() OR NOT inuse
			if NOT found()
				APPEND BLANK
				REPLACE catomin WITH dgkat.dgcat, inuse WITH .F.
			endif
			SELECT dgkat
			if LEN(TRIM(dgcat))>2
				SKIP
				LOOP
			endif
		endif
		SELECT dgkat
		INSERT INTO (lc_siirto+'\dgkat.dbf') (dgcat, text) VALUES (dgkat.dgcat, dgkat.english)
		if len(trim(dgkat.dgcat))=2
			do case
			case p_kieli='Fin'
		  		INSERT INTO (lc_siirto+'\mdc.dbf') (dgcat, text) VALUES (dgkat.dgcat, dgkat.finish)		
			case p_kieli='Swe'
			  	INSERT INTO (lc_siirto+'\mdc.dbf') (dgcat, text) VALUES (dgkat.dgcat, dgkat.swedish)
			CASE p_kieli='Ice'		
			  	INSERT INTO (lc_siirto+'\mdc.dbf') (dgcat, text) VALUES (dgkat.dgcat, dgkat.icelandic)
			otherwise
				INSERT INTO (lc_siirto+'\mdc.dbf') (dgcat, text) VALUES (dgkat.dgcat, dgkat.english)
			endcase
		endif
		SELECT dgkat
		SKIP
	ENDDO
	SELECT apusiir
	COPY to  (lc_siirto+'\dgkat.xl2') TYPE XLS
	COPY to  (lc_siirto+'\dgkat.txt') DELIMITED WITH CHAR ';'
	SELECT mdcsiir
	COPY to  (lc_siirto+'\mdc.xl2') TYPE XLS
	COPY to  (lc_siirto+'\mdc.txt') DELIMITED WITH CHAR ';'
	SELECT apusiir
	USE
	return
