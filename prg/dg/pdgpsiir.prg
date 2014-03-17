procedure pdgpsiir
	WAIT WINDOW NOWAIT 'Principal diagnosis property'
	SELECT 0
	USE ..\pdgpr_st
	COPY to (lc_siirto+'\pdgomin') TYPE foxplus
	USE (lc_siirto+'\pdgomin') ALIAS apusiir
	append blank
	replace pdgprop with '#####', text with 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date())
	SELECT pdgomin
	set ORDER to pdgprop
	GOTO top
	do WHILE NOT EOF()
		SELECT catomin
		SEEK pdgomin.pdgprop
		if NOT found() OR NOT inuse
			if NOT found()
				APPEND BLANK
				REPLACE catomin WITH pdgomin.pdgprop, inuse WITH .F.
			endif
			SELECT pdgomin
			SKIP
			LOOP
		endif
		SELECT pdgomin
		INSERT INTO (lc_siirto+'\pdgomin') (pdgprop, text) VALUES (pdgomin.pdgprop, pdgomin.english)
		SELECT pdgomin
		SKIP
	ENDDO
	SELECT apusiir
	COPY to (lc_siirto+'\pdgomin.xl2') TYPE XLS
	COPY to (lc_siirto+'\pdgomin.txt') DELIMITED WITH CHAR ';'
	SELECT apusiir
	USE
	return
