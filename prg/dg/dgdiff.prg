*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\DGDIFF.PRG
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
*:   DGDIFF
*!******************************************************************************
*!
*! Procedure DGDIFF
*!
*!  Calls
*!      AT
*!      EOF
*!      INT
*!      INTO
*!      LEN
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      VALUES
*!      apuold
*!      found
*!      point
*!      to
*!
*!******************************************************************************
procedure DGDIFF
	parameter lc_oe
	WAIT WINDOW 'Properties and categories of diagnoses - reading old definitions' NOWAIT
	lc_back=.F.
	SELECT pdgomin
	set ORDER to pdgprop
	SELECT 0
	if lc_oe='e'
		USE ..\..\..\transp\com\dg_1.DBF ALIAS old
		lc_siirm=lc_siirto
		select icd_10
		set order to code_w
	ELSE
		USE ('..\..\old\'+p_kieli+'\dg_1') ALIAS old
		lc_siirm='..\..\..\transp\'+p_kieli+'\muutos'
		SELECT icd_10
		set ORDER to code
	endif
	SELECT 0
	USE ..\dg_str
	COPY next 0 to apuold WITH cdx
	SELECT old
	goto Top
	old_code=' '
	old_dcode=' '
	old_vartype=' '
	old_varval=' '
	lc_icdtext=' '
	do WHILE NOT EOF()
		if old.VARTYPE='MDC' OR SUBSTR(old.varval,3,3)= 'X99'
			SKIP
			LOOP
		endif
		if upper(old.code)=upper(old_code) AND upper(old.d_code)=upper(old_dcode) AND old.VARTYPE=old_vartype AND old.varval=old_varval
			SKIP
			LOOP
		endif
		if lc_oe<>'e' AND not (p_kieli='Dan' OR p_kieli='Swe' OR p_kieli='Fin' OR p_kieli='Com' OR p_kieli='Nor' OR p_kieli='Est' OR p_kieli='Lat' OR p_kieli='Isl' OR p_kieli='Eng')
			INSERT INTO apuold (code, d_code, VARTYPE, varval);
				VALUES (point(old.code), point(old.d_code), old.VARTYPE, old.varval)
		else
			INSERT INTO apuold (code, d_code,  VARTYPE, varval);
				VALUES (old.code, old.d_code, old.VARTYPE, old.varval)
		endif
		SELECT old
		old_code=old.code
		old_dcode=old.d_code
		old_vartype=old.VARTYPE
		old_varval=old.varval
		SKIP
	ENDDO
	SELECT apuold
	USE
	SELECT old
	USE apuold ALIAS old
	SELECT dg_str
	COPY next 0 to (lc_siirm+'\dg') WITH cdx
	USE (lc_siirm+'\dg') ALIAS muutos
	SELECT icd_10
	set FILTER to Valid
	WAIT WINDOW 'Properties and categories of diagnoses - searching for deleted definitions' NOWAIT
	SELECT dg
	SET FILTER TO valid
	SELECT old
	goto Top
	lc_n=0
	do WHILE NOT EOF()
		lc_n=lc_n+1
		lc_val=old.varval
		if SUBSTR(lc_val,1,3)='98C'
			lc_val='00C00'
		endif
		if INT(lc_n/1000)*1000=lc_n
			WAIT WINDOW NOWAIT "Old code: "+old.code
		endif
		lc_old=.f.
		lc_icdo=' '
		lc_icde=' '
		select dg
		seek upper(old.code+old.d_code)+old.vartype+lc_val
		IF NOT FOUND() OR NOT dg.valid 
		   SELECT icd_10
		   seek upper(old.code+old.d_code)
		   IF NOT FOUND()
		      lc_icdtext='Code not valid'
		   ELSE 
		      lc_icdtext=icd_10.text
		   ENDIF 
		   do oldwrite
		   select old
		   skip
		   loop
		endif
		SELECT old
		SKIP
	ENDDO
	SELECT old
	set ORDER to code
	WAIT WINDOW 'Properties and categories of diagnoses - searching for new definitions' NOWAIT
	select icd_10
	set order to code
	SELECT dg
	SET FILTER TO valid
	goto Top
	lc_n = 0
	do WHILE NOT EOF()
		lc_n=lc_n+1
		if INT(lc_n/1000)*1000=lc_n
			WAIT WINDOW NOWAIT "New code: " + dg.code
		endif
		if varval='00M00'
			SKIP
			LOOP
		endif
		SELECT catomin
		SEEK dg.varval
		IF SUBSTR(dg.varval,3,1)='G'
		  SEEK SUBSTR(dg.varval,1,2)+'C'+SUBSTR(dg.varval,4,2)
		ENDIF 
		if NOT found() OR NOT inuse
			if NOT found()
				APPEND BLANK
				REPLACE catomin WITH dg.varval, inuse WITH .F.
			endif
			if dg.VARTYPE<>'DGCAT'
				SELECT dg
				if EOF()
					EXIT
				endif
				SKIP
				LOOP
			endif
		endif
		select icd_10
		seek upper(dg.code+dg.d_code)
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
	  		seek upper(dg.code)
	  		if found()
	  			if lc_oe='e'
		  			lc_wcode=icd_10.code_w
		  		else
		  			lc_wcode=icd_10.code
		  		endif
		  		lc_icdtext=trim(text)
	  			seek upper(dg.d_code)
	  			if lc_oe='e'
	  				lc_wdcode=icd_10.code_w
	  			else
	  				lc_wdcode=icd_10.code
	  			endif
	  			lc_icdtext=lc_icdtext+'; '+trim(text)
	  		endif
	  	endif
	  	if not found()
	  		select dg
	  		replace valid with .f.
	  		skip
	  		loop
	  	endif
		lc_found=.t.
		lc_val=dg.varval
		if lc_val='00C00'
			lc_val='98C'
		endif
		SELECT old
		lc_add=.F.
		if lc_oe='e'
			if lc_wcode=' '
				lc_add=.t.
				lc_found=.f.
			else
				seek upper(lc_wcode+lc_wdcode)+dg.vartype+lc_val
				if not found() 
					seek upper(lc_wcode)+space(6)+dg.vartype+lc_val
					if not found() and vartype<>'DGCAT'
						seek upper(lc_wdcode)+space(6)+dg.vartype+lc_val
					endif
					if not found()
	 					lc_found=.f.
	 				endif
				endif
			endif
		ELSE
			seek upper(lc_wcode+lc_wdcode)+dg.vartype+lc_val
			if not found()
				seek upper(lc_wcode)+space(6)+dg.vartype+lc_val
				if not found() and vartype<>'DGCAT'
					seek upper(lc_wdcode)+space(6)+dg.vartype+lc_val
				endif
				if not found()
					lc_found=.f.
				endif
			endif
			if not found()
				seek upper(lc_wcode+lc_wdcode)
				if not found()
					seek upper(lc_wcode)
					if found()
						seek upper(lc_wdcode)
					endif
				endif
				if not found()
					lc_add=.t.
				endif
			endif
		endif
		if NOT lc_found
			lc_text='   '
			do CASE
			CASE dg.VARTYPE='PDGPRO'
				SELECT pdgomin
				SEEK TRIM(lc_val)
				lc_text=english
			CASE dg.VARTYPE='DGCAT'
				SELECT dgkat
				SEEK SUBSTR(lc_val,1,2)+SUBSTR(lc_val,4,2)
				lc_text=english
			CASE dg.VARTYPE='DGPROP'
				SELECT dgomin
				SEEK SUBSTR(lc_val,1,2)+SUBSTR(lc_val,4,2)
				if NOT inuse
					SELECT dg
					SKIP
					LOOP
				endif
				lc_text=english
			CASE dg.VARTYPE='PROCPR'
				SELECT tpomin
				SEEK lc_val
				if NOT inuse
					SELECT dg
					SKIP
					LOOP
				endif
				lc_text=english
			CASE dg.VARTYPE='COMPL'
				SELECT kompkat
				SEEK SUBSTR(lc_val,1,2)+SUBSTR(lc_val,4,2)
				lc_text=english
				IF SUBSTR(lc_val,3,1)='G'
				   lc_text=TRIM(english)+' - Major complication'
				ENDIF 
			OTHERWISE
				lc_text='***'
			ENDCASE
			select dg
			if lc_add
				INSERT INTO (lc_siirm+'\dg') (new, code, d_code, icd_text, VARTYPE, varval, vartext, added, chdate);
					VALUES ('N', dg.code, dg.d_code, lc_icdtext, dg.VARTYPE, lc_val, lc_text, 'New code', dg.chdate)
			ELSE
				INSERT INTO (lc_siirm+'\dg') (new, code, d_code, icd_text, VARTYPE, varval, vartext, chdate);
					VALUES ('N', dg.code, dg.d_code, lc_icdtext, dg.VARTYPE, dg.varval, lc_text, dg.chdate)
			endif
		endif
		SELECT dg
		SKIP
	ENDDO

	WAIT WINDOW 'Properties and categories of diagnoses - creating excel report' NOWAIT
	SELECT muutos
	set ORDER to code
	goto top
	COPY next 15000 to (lc_siirm+'\dg1.xls') TYPE XL5
	copy next 15000 to (lc_siirm+'\dg2.xls') TYPE XL5
	COPY to (lc_siirm+'\dg.txt') DELIMITED WITH CHAR ';'
	LIST STRUCTURE TO (lc_siirm+'\dg_str.txt')
	USE
	SELECT old
	USE
	return

*!******************************************************************************
*!
*! Procedure POINT
*!
*!  Calls
*!      AT
*!      EOF
*!      INT
*!      INTO
*!      LEN
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      VALUES
*!      apuold
*!      found
*!      point
*!      to
*!
*!******************************************************************************
function point
	parameter fp_code
	re_code=fp_code
	if LEN(TRIM(fp_code))>3 AND (SUBSTR(fp_code,4,1)<='9' or substr(fp_code,4,1)>='a') AND AT('.',fp_code)=0 AND NOT (fp_code>='a')
		re_code=SUBSTR(fp_code,1,3)+'.'+SUBSTR(fp_code,4,2)
	endif
	return re_code
endfunc

procedure oldwrite
	lc_text='   '
	do CASE
	CASE old.VARTYPE='PDGPRO'
		SELECT pdgomin
		SEEK TRIM(lc_val)
		lc_text=english
	CASE old.VARTYPE='DGCAT'
		SELECT dgkat
		SEEK SUBSTR(lc_val,1,2)+SUBSTR(lc_val,4,2)
		lc_text=english
	CASE old.VARTYPE='DGPROP'
		SELECT dgomin
		SEEK SUBSTR(lc_val,1,2)+SUBSTR(lc_val,4,2)
		lc_text=english
	CASE old.VARTYPE='PROCPR'
		SELECT tpomin
		SEEK lc_val
		lc_text=english
	CASE old.VARTYPE='COMPL'
		SELECT kompkat
		SEEK SUBSTR(lc_val,1,2)+SUBSTR(lc_val,4,2)
		lc_text=english
	OTHERWISE
		lc_text='***'
	ENDCASE
	if lc_old
		if p_kieli='Dan' and lc_oe='e'
			INSERT INTO (lc_siirm+'\dg') (new, code, d_code, icd_text, VARTYPE, varval, vartext, added);
			VALUES ('D', 'D'+substr(old.code,1,3)+substr(old.code,5,2), old.d_code, lc_icdtext, old.VARTYPE, lc_val, lc_text, 'Old code')
		else
			INSERT INTO (lc_siirm+'\dg') (new, code, d_code, icd_text, VARTYPE, varval, vartext, added);
			VALUES ('D', old.code, old.d_code, lc_icdtext, old.VARTYPE, lc_val, lc_text, 'Old code')
		endif
	ELSE
		INSERT INTO (lc_siirm+'\dg') (new, code, d_code, icd_text, VARTYPE, varval, vartext);
		VALUES ('D', old.code, old.d_code, lc_icdtext, old.VARTYPE, lc_val, lc_text)
	endif
	return
