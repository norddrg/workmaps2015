procedure tpomsiir
	WAIT WINDOW NOWAIT 'Procedure  property codes'
	SELECT 0
	USE ..\tpom_st
	COPY to (lc_siirto+'\tpomin.dbf') TYPE foxplus
	USE (lc_siirto+'\tpomin.dbf') ALIAS apusiir
	append blank
	replace procprop with '#####', text with 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date())
	SELECT 0
	SELECT tpomin
	set ORDER to procprop
	set FILTER to Valid
	goto Top
	do WHILE NOT EOF()
		SELECT catomin
		SEEK tpomin.procprop
		if NOT found() OR NOT inuse
			if NOT found()
				APPEND BLANK
				REPLACE catomin WITH tpomin.procprop, inuse WITH .F.
			endif
			SELECT tpomin
			SKIP
			LOOP
		endif
		SELECT tpomin
		INSERT INTO (lc_siirto+'\tpomin.dbf') (procprop, text, extens, or_1) VALUES (tpomin.procprop, tpomin.english, tpomin.extens, tpomin.or_1)
		SELECT tpomin
		SKIP
	ENDDO
	SELECT apusiir
	COPY to (lc_siirto+'\tpomin.xl2') TYPE XLS
	COPY to (lc_siirto+'\tpomin.txt') DELIMITED WITH CHAR ';'
	SELECT apusiir
	USE
	return
