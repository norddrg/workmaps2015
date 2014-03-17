procedure CEXDIFF
	parameter lc_oe
	WAIT WINDOW 'Exclusion lists to complication categories' NOWAIT
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
			SKIP
			LOOP
		endif
		if lc_oe='o' AND (p_kieli='Dan' OR p_kieli='Swe' OR p_kieli='Fin' OR p_kieli='Com' OR p_kieli='Nor')
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
		lc_old=.f.
		n_codes=0
		n_dcodes=0
		lc_icdo=' '
		lc_icde=' '
		select icd_10
		seek old.code+old.d_code
		if lc_oe='e'
			do while old.code=icd_10.code_w and old.d_code=icd_10.d_code_w
				if icd_10.d_code=' ' 
					n_codes=n_codes+1
					dimension lc_codes (n_codes,1)
					lc_codes (n_codes,1)=icd_10.code
					lc_icdo=icd_10.code
				endif
				select icd_10
				skip
			enddo
		else
			do while old.code=icd_10.code and old.d_code=icd_10.d_code
				if icd_10.d_code=' ' 
					n_codes=n_codes+1
					dimension lc_codes (n_codes,1)
					lc_codes (n_codes,1)=icd_10.code
					lc_icdo=icd_10.code
				endif
				select icd_10
				skip
			enddo
		endif
		if old.d_code<>' '
			seek old.code
			if lc_oe='e'
				do while old.code=icd_10.code_w and icd_10.d_code = ' '
					n_codes=n_codes+1
					dimension lc_codes (n_codes,1)
					lc_codes (n_codes,1)=icd_10.code
					lc_icdo=icd_10.code
					select icd_10
					skip
				enddo
				seek old.d_code
				do while old.d_code=icd_10.code_w and icd_10.d_code = ' '
					n_dcodes=n_dcodes+1
					dimension lc_dcodes (n_dcodes,1)
					lc_dcodes (n_dcodes,1)=icd_10.code
					lc_icde=icd_10.code
					select icd_10
					skip
				enddo
			else
				do while old.code=icd_10.code and icd_10.d_code = ' '
					n_codes=n_codes+1
					dimension lc_codes (n_codes,1)
					lc_codes (n_codes,1)=icd_10.code
					lc_icdo=icd_10.code
					select icd_10
					skip
				enddo
				seek old.d_code
				do while old.d_code=icd_10.code and icd_10.d_code = ' '
					n_dcodes=n_dcodes+1
					dimension lc_dcodes (n_dcodes,1)
					lc_dcodes (n_dcodes,1)=icd_10.code
					lc_icde=icd_10.code
					select icd_10
					skip
				enddo
			endif
		endif
		if n_codes=0 or (n_dcodes=0 and old.d_code<>' ')
			lc_old=.t.
			lc_icdtext='Code not valid'
			do oldwrite
			select old
			skip
			loop
		endif
		lc_old=.f.
		nn_codes=1
		nn_dcodes=1
		lc_found=.f.
		do while nn_codes<=n_codes
			select komplex
			SEEK substr(old.compl,1,2)+substr(old.compl,5,2)+lc_codes (nn_codes,1)+space(6)
			if found() 
				nn_codes=nn_codes+1
				loop
			endif
			if n_dcodes=0
				lc_icdo=lc_codes (nn_codes,1)
				lc_icde=' '
				select icd_10
				set order to code
				seek lc_icdo
				lc_icdtext=text
				if lc_oe='e'
					set order to code_w
				endif
				do oldwrite
				nn_codes=nn_codes+1
				loop
			endif
			nn_dcodes=1
			do while nn_dcodes<=n_dcodes
				select komplex
				SEEK substr(old.compl,1,2)+substr(old.compl,5,2)+lc_codes (nn_codes,1)+lc_dcodes (nn_dcodes,1)
				if found()
					nn_dcodes=nn_dcodes+1
					loop
				endif
				seek substr(old.compl,1,2)+substr(old.compl,5,2)+lc_dcodes (nn_dcodes,1)+space(6)
				if found()
					nn_dcodes=nn_dcodes+1
					loop
				endif
				lc_icdo=lc_codes (nn_codes,1)
				lc_icde=lc_dcodes (nn_dcodes,1)
				select icd_10
				set order to code
				seek lc_icdo+lc_icde
				if found()
					lc_icdtext=text
				else
					seek lc_icdo
					lc_icdtext=trim(text)
					seek lc_icde
					lc_icdtext=lc_icdtext+'; '+trim(text)
				endif
				if lc_oe='e'
					set order to code_w
				endif
				do oldwrite
				nn_dcodes=nn_dcodes+1
			enddo
			nn_codes=nn_codes+1
		enddo
		select old
		skip
	enddo
	select icd_10
	set order to code
	SELECT komplex
	goto Top
	lc_kompl=SPACE(5)
	do while not eof()
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
	USE
	SELECT old
	USE
	return
	
procedure oldwrite
SELECT kompkat
SEEK SUBSTR(komplex.compl,1,2)+SUBSTR(komplex.compl,5,2)
if found()
  cc_text=kompkat.english
else
	cc_text='---'
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
