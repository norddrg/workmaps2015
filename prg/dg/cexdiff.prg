procedure CEXDIFF
	parameter lc_oe
	WAIT WINDOW 'Exclusion lists to complication categories - changes' NOWAIT
	SELECT icd_10
	set ORDER to code
	SELECT komplex
	set ORDER to compl
	set FILTER to Valid 

	select 0
	USE ..\cex_str	
	COPY next 0 to apuold WITH cdx
	if lc_oe='e'
		use ..\..\..\transp\com\komplex alias old
		lc_siirm=lc_siirto
	else
		use ('..\..\old\'+p_kieli+'\komplex') alias old
		lc_siirm='..\..\..\transp\'+p_kieli+'\muutos'
	endif
	old_code=' '
	old_dcode=' '
	old_compl=' '
	do WHILE NOT EOF()
		if old.code=old_code AND old.d_code=old_dcode AND old.compl=old_compl
			old_code=old.code
			old_dcode=old.d_code
			old_compl=old.compl
			SKIP
			LOOP
		ENDIF
		IF old.compl='98'
			old_code=old.code
			old_dcode=old.d_code
			old_compl=old.compl
			SKIP
			LOOP
		ENDIF 
		if lc_oe='o' AND (p_kieli='Dan' OR p_kieli='Swe' OR p_kieli='Fin' OR p_kieli='Com' OR p_kieli='Nor' OR p_kieli='Est' OR p_kieli='Lat' OR p_kieli='Isl' OR p_kieli='Eng')
			INSERT INTO apuold (code, d_code,compl);
			VALUES (old.code, old.d_code, old.compl)
		else
			INSERT INTO apuold (code, d_code, compl);
			VALUES (point(old.code), point(old.d_code), old.compl)
		endif
		SELECT old
		old_code=old.code
		old_dcode=old.d_code
		old_compl=old.compl
		SKIP
	ENDDO
	select apuold
	use
	select old
	USE apuold alias old
	set order to compl
	
	SELECT 0
	USE ..\cex_str	
	COPY next 0 to (lc_siirm+'\komplex') WITH cdx
	USE (lc_siirm+'\komplex') ALIAS muutos
	set SAFETY OFF
	select icd_10
	if lc_oe='e'
		set order to code_w
	else
		set order to code
	endif
	select old
	goto top
	do while not eof()
		SELECT komplex
		SEEK SUBSTR(old.compl,1,2)+SUBSTR(old.compl,4,2)+old.code+old.d_code
		IF FOUND()
		  SELECT old
		  SKIP
		  LOOP 
		ENDIF 
		select icd_10
		seek old.code+old.d_code
		IF FOUND()
		  lc_icdtext=icd_10.text
		ELSE 
		  SEEK old.code
		  IF FOUND()
		    lc_icdtext=icd_10.text
		  ELSE
		    IF old.d_code=' '
		      lc_icdtext='Code not valid'
		    ELSE 
   		      lc_icdtext='Asterisk code not valid'
   		    ENDIF 
		  ENDIF
		  IF old.d_code<>' '
   		    SEEK old.d_code
		    IF FOUND()
		      lc_icdtext=TRIM(lc_icdtext)+'; '+icd_10.text
		    ELSE
		      IF lc_icdtext='Asterisk code not valid'
		        lc_icd_text='Codes(both) not valid'
		      ELSE  
   		        lc_icdtext=TRIM(lc_icdtext)+'; Dagger code not valid'
   		      ENDIF 
		    ENDIF
		  ENDIF  
		ENDIF 
		SELECT kompkat
		SEEK SUBSTR(komplex.compl,1,2)+SUBSTR(komplex.compl,4,2)
		if found()
		  cc_text=kompkat.english
		ELSE 
		  cc_text='--- (Complication category not valid)'
		ENDIF 
		INSERT INTO (lc_siirm+'\komplex') (new, code, d_code, icdtext, compl, comptext);
		VALUES ('D', old.code, old.d_code, lc_icdtext, old.compl,cc_text)
		select old
		skip
	enddo
	select icd_10
	set order to code
	SELECT komplex
	goto Top
	lc_kompl=SPACE(5)
	do while not eof()
		IF komplex.compl<>lc_kompl
		   WAIT WINDOW komplex.compl nowait
		endif
		SELECT catomin
		SEEK komplex.compl
		if NOT found() OR NOT inuse
			if NOT found()
				APPEND BLANK
				REPLACE catomin WITH dg.varval, inuse WITH .F.
			endif
			SELECT komplex
			if EOF()
				EXIT
			endif
			SKIP
			LOOP
		endif
		select icd_10
		seek komplex.code+komplex.d_code
	  	if found()
	  		if lc_oe='e'
		  		lc_wcode=icd_10.code_w
		  		lc_wdcode=icd_10.d_code_w
		  	else
		  		lc_wcode=icd_10.code
		  		lc_wdcode=icd_10.d_code
		  	endif
		  	lc_icdtext=trim(text)
	  	else
	  		seek komplex.code
	  		if found()
	  			if lc_oe='e'
		  			lc_wcode=icd_10.code_w
		  		else
		  			lc_wcode=icd_10.code
		  		endif
		  		lc_icdtext=trim(text)
	  			seek komplex.d_code
	  			if lc_oe='e'
	  				lc_wdcode=icd_10.code_w
	  			else
	  				lc_wdcode=icd_10.code
	  			endif
	  			lc_icdtext=lc_icdtext+'; '+trim(text)
	  		endif
	  	endif
	  	if not found()
	  		select komplex
	  		replace valid with .f.
	  		skip
	  		loop
	  	endif
		lc_found=.t.
		SELECT old
		lc_add=.F.
		if lc_wcode=' '
			lc_add=.t.
			lc_found=.f.
		else
			seek komplex.compl+lc_wcode+lc_wdcode
			if not found() 
				seek komplex.compl+lc_wcode+space(6)
				if not found()
					seek komplex.compl+lc_wdcode+space(6)
				endif
				if not found()
 					lc_found=.f.
 				endif
			endif
		endif
		if NOT lc_found
			SELECT kompkat
			SEEK SUBSTR(komplex.compl,1,2)+SUBSTR(komplex.compl,5,2)
			INSERT INTO (lc_siirm+'\komplex') (new, compl, code, icdtext, d_code, comptext, chdate);
			VALUES ('N', komplex.compl, komplex.code, icd_10.text, komplex.d_code, kompkat.english, komplex.chdate)
		endif
		lc_kompl=komplex.compl
		select komplex
		skip
	enddo
	SELECT icd_10
	set ORDER to code
	set FILTER to

	SELECT muutos
	goto top
	COPY to (lc_siirm+'\komplex1.xls') TYPE XL5 next 15000
	COPY to (lc_siirm+'\komplex2.xls') TYPE XL5 next 15000
	COPY to (lc_siirm+'\komplex.txt') DELIMITED WITH CHAR ';'
    LIST STRUCTURE TO (lc_siirm+'\komplex_str.txt')
	USE
	SELECT old
	USE
	return
	
procedure oldwrite
SELECT kompkat
SEEK SUBSTR(komplex.compl,1,2)+SUBSTR(komplex.compl,4,2)
if found()
  cc_text=kompkat.english
else
	cc_text='--- (Complication category not valid)'
endif
if lc_old
	if p_kieli='Dan' and lc_oe='e'
		INSERT INTO (lc_siirm+'\komplex') (new, code, d_code, icdtext, compl, comptext);
		VALUES ('D', 'D'+substr(old.code,1,3)+substr(old.code,5,2), old.d_code, lc_icdtext, old.compl,cc_text)
	else
		INSERT INTO (lc_siirm+'\komplex') (new, code, d_code, icdtext, compl, comptext);
		VALUES ('D', old.code, old.d_code, lc_icdtext, old.compl,cc_text)
	endif
else
	INSERT INTO (lc_siirm+'\komplex') (new, code, d_code, icdtext, compl, comptext);
	VALUES ('D', lc_icdo, lc_icde, lc_icdtext, old.compl,cc_text)
endif
return
