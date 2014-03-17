procedure CCDIFF
	lc_print=lc_siirto+'\kompkat.txt'

	SELECT 0
	USE ..\..\..\transp\com\kompkat ALIAS old
	SELECT 0
	USE ..\cc_str
	COPY next 0 to (lc_siirto+'\kompkat') WITH cdx
	USE (lc_siirto+'\kompkat') ALIAS muutos

	SELECT kompkat
	WAIT WINDOW NOWAIT 'Complication categories'
	set ORDER to compl
	set FILTER to Valid
	set RELATION to SUBSTR(inclprop,1,2)+SUBSTR(inclprop,4,2)+SUBSTR(inclprop,3,1) INTO dgomin
	SELECT kompkat
	goto Top
	lc_n=0
	do WHILE NOT EOF()
		lc_n=lc_n+1
		if NOT inuse
			SKIP
			LOOP
		endif
		if 10*INT(lc_n/10)=lc_n
			WAIT WINDOW NOWAIT kompkat.compl
		endif
		SELECT kompkat
		SKIP
	ENDDO
	SELECT kompkat
	set RELATION to
	goto Top
	do WHILE NOT EOF()
		SELECT old
		do WHILE SUBSTR(old.compl,1,2)+SUBSTR(old.compl,4,2) + old.inclprop<;
				SUBSTR(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2)+kompkat.inclprop AND NOT EOF()
			SELECT dgomin
			SEEK SUBSTR(old.inclprop,1,2)+SUBSTR(old.inclprop,4,2)+SUBSTR(old.inclprop,3,1)
			INSERT INTO (lc_siirto+'\kompkat') (new, compl, comptext, inclprop, proptext);
				VALUES ('D', old.compl, kompkat.english, old.inclprop,dgomin.english )
			SELECT old
			SKIP
		ENDDO
		if NOT (SUBSTR(old.compl,1,2)+SUBSTR(old.compl,4,2)=;
				SUBSTR(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2) AND old.inclprop=kompkat.inclprop)
			if NOT (inclprop=' ')
				SELECT dgomin
				SEEK SUBSTR(kompkat.inclprop,1,2)+SUBSTR(kompkat.inclprop,4,2)+SUBSTR(kompkat.inclprop,3,1)
				do CASE
				CASE p_kieli='Fin'
					INSERT INTO (lc_siirto+'\kompkat') (new, compl, comptext, inclprop, proptext, chdate);
						VALUES ('N', kompkat.compl, kompkat.finish, kompkat.inclprop, dgomin.finish, kompkat.chdate)
				OTHERWISE
					INSERT INTO (lc_siirto+'\kompkat') (new, compl, comptext, inclprop, proptext, chdate);
						VALUES ('N', kompkat.compl, kompkat.english, kompkat.inclprop, dgomin.english, kompkat.chdate)
				ENDCASE
			endif
		ELSE
			SELECT old
			SKIP
		endif
		SELECT kompkat
		SKIP
	ENDDO
	SELECT muutos
	COPY to (lc_siirto+'\kompkat.xls') TYPE XL5
	USE
	SELECT old
	USE
	return
