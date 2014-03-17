*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\TPDIFF.PRG
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
*:   tpdiff
*!******************************************************************************
*!
*! Procedure TPDIFF
*!
*!  Calls
*!      EOF
*!      IIF
*!      INT
*!      INTO
*!      OR
*!      SUBSTR
*!      VALUES
*!      apuold
*!      found
*!      to
*!
*!******************************************************************************
procedure tpdiff
	parameter lc_oe
	WAIT WINDOW NOWAIT 'Procedures and their properties - reading old definitions'

	SELECT 0
	if lc_oe='e'
		USE ..\..\..\transp\com\proc1 ALIAS old
		lc_siirm=lc_siirto
		select csp
		set order to ncsp
	ELSE
		USE ('..\..\old\'+p_kieli+'\proc1') ALIAS old
		lc_siirm='..\..\..\transp\'+p_kieli+'\muutos'
		select csp
		set order to code
	endif
	set FILTER to NOT released
	set RELATION to
	SELECT 0
	USE ..\tpt_mstr
	COPY next 0 to apuold WITH cdx
	USE
	SELECT old
	goto Top
	old_code=' '
	old_dcode=' '
	old_vartype=' '
	old_varval=' '
	do WHILE NOT EOF()
		if p_kieli='Dan' AND lc_oe='e'
			old_code='K'+old_code
		endif
		if old.code=old_code AND old.VARTYPE=old_vartype AND old.varval=old_varval
			SKIP
			LOOP
		endif
		INSERT INTO apuold (code, VARTYPE, varval);
			VALUES (old.code, old.VARTYPE, old.varval)
		SELECT old
		old_code=old.code
		old_vartype=old.VARTYPE
		old_varval=old.varval
		SKIP
	ENDDO
	SELECT apuold
	USE
	SELECT old
	USE apuold ALIAS old
	set ORDER to code
	SELECT 0
	USE ..\tpt_mstr
	COPY next 0 to (lc_siirm+'\proc') WITH cdx
	USE (lc_siirm+'\proc') ALIAS muutos

	SELECT drgtpt
	set ORDER to code
	set FILTER to Valid
	goto Top
	lc_ncsp='    '
	lc_code=code
	lc_chap=' '
	ed_code=' '
	ed_type=' '
	ed_val=' '
	lc_extens=.f.

	SELECT old
	goto Top
	lc_n=0
	do WHILE NOT EOF()
		lc_n=lc_n+1
		if 100*INT(lc_n/100)=lc_n
			WAIT WINDOW 'Old code: '+old.code NOWAIT
		endif
		IF old.vartype='DGPROP' AND old.varval='00X99'
		  SKIP 
		  LOOP 
		ENDIF 
		ol_code=.f.
		select csp
		seek old.code
		if not found()
			lc_code=old.code
			ol_code=.t.
			ol_text='Code not valid'
			do oldwrite
			select old
			skip
			loop
		endif
		lc_code=csp.code
		ol_text=csp.text
		if lc_oe='e'
			do while csp.ncsp=old.code and old_code<>' ' and not eof()
				select drgtpt
				DO CASE  
				CASE old.varval='99S90'
					seek csp.code+'PROCPR'
					do while drgtpt.code=old.code and drgtpt.vartype='PROCPR' and not eof()
						select tpomin
						seek drgtpt.varval
						if found() and extens='1'
						  lc_extens=.t.
						endif
						select drgtpt
						skip
					enddo
					if not lc_extens
					  do oldwrite
					  lc_extens=.f.
					endif
				CASE old.varval='00X99'
					SEEK csp.code+'PROCPR  00S99'
					IF NOT FOUND()
					  DO oldwrite
					ENDIF 
				OTHERWISE 
	  				SEEK csp.code+old.VARTYPE+old.varval
					if not found()
						do oldwrite
					endif
				ENDCASE 
				select csp
				skip
			enddo
		else
			do while csp.code=old.code and old_code<>' ' and not eof()
				select drgtpt
				do case
				case old.varval='99S90'
					seek old.code+'PROCPR '
					do while drgtpt.code=old.code and drgtpt.vartype='PROCPR' and not eof()
						select tpomin
						seek drgtpt.varval
						if found() and extens='1'
						  lc_extens=.t.
						endif
						select drgtpt
						skip
					enddo
					if not lc_extens
					  do oldwrite
					  lc_extens=.f.
					endif
				case old.varval='99O99'
					seek old.code+'PROCPR  '+'99O'
					if found()
						select drgtpt
						skip
					else
						do oldwrite
						lc_extens=.f.
					endif
					if not lc_extens
					  do oldwrite
					  lc_extens=.f.
					endif
				CASE old.varval='00X99'
	  				SEEK csp.code+old.VARTYPE+old.varval
					if not found()
						do oldwrite
					endif
				OTHERWISE 
					SEEK csp.code+old.VARTYPE+old.varval
					if not found()
						do oldwrite
					endif
				ENDCASE 
				select csp
				skip
			enddo
		endif
		SELECT old
		SKIP
	ENDDO
	select csp
	set order to code
	SELECT drgtpt
	set FILTER to Valid
	goto Top
	lc_n=0
	lc_code=drgtpt.code
	lc_00S99=.f.
	do WHILE NOT EOF()
		lc_n=lc_n+1
		if 100*INT(lc_n/100)=lc_n
			WAIT WINDOW 'New code: '+drgtpt.code NOWAIT
		endif
		if drgtpt.VARTYPE='PROCPR' AND varval='  '
			delete
			replace valid with .f.
			SKIP
			LOOP
		ENDIF
		IF drgtpt.varval='00S99'
		  lc_00S99=.t.
		ENDIF 
		if (drgtpt.VARTYPE='OR' OR drgtpt.VARTYPE='CC') AND drgtpt.varval='0'
			SKIP
			LOOP
		endif
		if varval='99S00'
			SKIP
			LOOP
		endif
		SELECT csp
		SEEK drgtpt.code
		if NOT found()
			SELECT drgtpt
			REPLACE Valid WITH .F.
			SKIP
			LOOP
		endif
		lc_found=.t.
		lc_add=.f.
		select old
		if lc_oe='e'
			if csp.ncsp=' '
				lc_add=.t.
				lc_found=.f.
			else
				SEEK csp.ncsp+drgtpt.VARTYPE+drgtpt.varval
				if not found()
					if drgtpt.varval='99O'
						seek csp.ncsp+drgtpt.VARTYPE+'99O99'
					endif
					if not found()
	  					lc_found=.f.
	  				endif
				endif
			endif
		else
			SEEK drgtpt.code+drgtpt.VARTYPE+drgtpt.varval
			if not found()
				if drgtpt.varval='99O'
					seek csp.ncsp+drgtpt.VARTYPE+'99O99'
				endif
				if not found()
	  				lc_found=.f.
	  			endif
				SEEK drgtpt.code
				if not found()
					lc_add=.t.
				endif
			endif
		endif
		if NOT lc_found 
          IF drgtpt.vartype<>'OR' AND drgtpt.vartype<>'CC'
		    select catomin
		    seek drgtpt.varval
		    lc_inuse=.t.
		    if not found() or not inuse
		      lc_inuse=.f.
		    endif
			if not lc_inuse
				SELECT drgtpt
				SKIP
				LOOP
			ENDIF
	      ENDIF 
			SELECT dgomin
			SEEK IIF(drgtpt.VARTYPE='DGPROP',SUBSTR(drgtpt.varval,1,2)+SUBSTR(drgtpt.varval,4,2)+SUBSTR(drgtpt.varval,3,1),' ')
			SELECT tpomin
			SEEK IIF(drgtpt.VARTYPE='PROCPR', drgtpt.varval,' ')
			do CASE
			CASE p_kieli='Fin'
				lc_text = IIF(drgtpt.VARTYPE='DGPROP', dgomin.finish, IIF(drgtpt.VARTYPE='COMPL',kompkat.finish,IIF(drgtpt.VARTYPE='PROCPR', tpomin.finish,'***')))
			OTHERWISE
				lc_text = IIF(drgtpt.VARTYPE='DGPROP', dgomin.english, IIF(drgtpt.VARTYPE='COMPL',kompkat.english,IIF(drgtpt.VARTYPE='PROCPR', tpomin.english,'***')))
			ENDCASE
			if lc_add
				INSERT INTO (lc_siirm+'\proc') (new, code, ncsptext, VARTYPE, varval, vartext, added, chdate);
					VALUES ('N', csp.code, csp.text, drgtpt.VARTYPE, drgtpt.varval, lc_text, 'New code', drgtpt.chdate)
			ELSE
				INSERT INTO (lc_siirm+'\proc') (new, code, ncsptext, VARTYPE, varval, vartext,chdate);
					VALUES ('N', csp.code, csp.text, drgtpt.VARTYPE, drgtpt.varval, lc_text, drgtpt.chdate)
			endif
		endif
		SELECT drgtpt
		SKIP
        IF drgtpt.code<>lc_code OR EOF()
*          IF NOT lc_00S99
*			INSERT INTO (lc_siirm+'\proc') (new, code, ncsptext, VARTYPE, varval, vartext,chdate);
*			VALUES ('N', csp.code, csp.text, 'DGPROP', '00X99', 'Intervention code valid for single use', DATE())
*          ENDIF 
	      lc_code=drgtpt.code
	      lc_00S99=.f.
	    endif
		LOOP
	ENDDO

	SELECT muutos
	goto Top
	COPY to (lc_siirm+'\proc1.xls') TYPE XL5 next 15000
	COPY to (lc_siirm+'\proc2.xls') TYPE XL5 next 15000	
	COPY to (lc_siirm+'\proc.txt') DELIMITED WITH CHAR ';'	
	USE
	SELECT old
	USE
	return

procedure oldwrite
	SELECT dgomin
	if old.varval='99S90'
	  return
	endif
	SEEK IIF(old.VARTYPE='DGPROP',SUBSTR(old.varval,1,2)+SUBSTR(old.varval,4,2)+SUBSTR(old.varval,3,1),' ')
	SELECT tpomin
	SEEK IIF(old.VARTYPE='PROCPR',old.varval,' ')
	do CASE
	CASE p_kieli='Fin'
		lc_text = IIF(old.VARTYPE='DGPROP', dgomin.finish, IIF(old.VARTYPE='COMPL',kompkat.finish,IIF(old.VARTYPE='PROCPR', tpomin.finish,'***')))
	OTHERWISE
		lc_text = IIF(old.VARTYPE='DGPROP', dgomin.english, IIF(old.VARTYPE='COMPL',kompkat.english,IIF(old.VARTYPE='PROCPR', tpomin.english,'***')))
	ENDCASE
	if ol_code
		INSERT INTO (lc_siirm+'\proc') (new, code, ncsptext, VARTYPE, varval, vartext, added);
		VALUES ('D', old.code, ol_text, old.VARTYPE, old.varval, lc_text,'Old code')
	ELSE
		INSERT INTO (lc_siirm+'\proc') (new, code, ncsptext, VARTYPE, varval, vartext);
		VALUES ('D', csp.code, ol_text, old.VARTYPE, old.varval, lc_text)
	endif
	return
