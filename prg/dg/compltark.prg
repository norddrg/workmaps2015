*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\COMPLTARK.PRG
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
*:   COMPLTARK
*!******************************************************************************
*!
*! Procedure COMPLTARK
*!
*!  Calls
*!      DELETED
*!      EOF
*!      INT
*!      NOT
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      date
*!      found
*!
*!******************************************************************************
procedure COMPLTARK
	on KEY label ctrl+j
	on KEY label ctrl+T
	set message to 'Checking CC-category exclusions' NOWAIT
	do copydel
	SELECT icd_10
	set ORDER to code
	goto top
	SELECT komplex
	set ORDER to code
	set filter to valid
	SELECT dg
	SEEK icd_10.code+icd_10.d_code
	ct_n=1
	do WHILE NOT EOF()
		if SUBSTR(varval,1,2)='00' AND SUBSTR(varval,4,2)='00'
			SKIP
			LOOP
		endif
		if VARTYPE<>'COMPL'
			SKIP
			LOOP
		endif
		clt_code=dg.code
		clt_dcode=dg.d_code
		clt_cc=dg.varval
		ct_n=ct_n+1
		if 100*INT(ct_n/100)=ct_n
			WAIT WINDOW NOWAIT 'CC round: '+dg.code
		endif
		SELECT komplex
		clt_found=.f.
		SEEK (clt_code+clt_dcode+SUBSTR(clt_cc,1,2)+SUBSTR(clt_cc,4,2))
		if found()
			clt_found=.t.
		else 
			SEEK (clt_code+SPACE(6)+SUBSTR(clt_cc,1,2)+SUBSTR(clt_cc,4,2))
			if found()
				clt_found=.t.
			endif
		endif
		if NOT clt_found and clt_dcode<>' '
			SEEK (clt_dcode+SPACE(6)+SUBSTR(clt_cc,1,2)+SUBSTR(clt_cc,4,2))
			if found()
			  clt_found=.t.
			endif
		endif
		if not clt_found
		   select dg
		   seek clt_code+space(6)+'DGCAT'
		   if varval='00M00'
		     clt_found=.t.
		   endif
		endif
		select komplex
		if NOT clt_found
			*set step on
			INSERT INTO komplex (compl, code, d_code, Valid, chdate) ;
			VALUES (clt_cc, clt_code, clt_dcode,.t., date())
			if substr(clt_cc,3,1)='I'
				replace compl with substr(clt_cc,1,2)+'C'+substr(clt_cc,4,2)
			endif
			SELECT kompkat
			SEEK SUBSTR(komplex.compl,1,2)+SUBSTR(komplex.compl,4,2)
			SELECT icd_10
			SEEK clt_code+clt_dcode
			if NOT found()
				SELECT dg
			endif
			WAIT WINDOW NOWAIT 'The program has added to the exclusisons of '+TRIM(TRIM(clt_code)+' '+clt_dcode)+ ' its own CC-category'
			do exclmaar
			on KEY label ctrl+j do COMPLTARK
			on KEY label ctrl+T do COMPLTARK
		endif
		SELECT dg
		SKIP
	ENDDO
	select komplex
	goto top
	ct_n=1
	do while not eof()
	  ct_n=ct_n+1
	  if 100*INT(ct_n/100)=ct_n
	    WAIT WINDOW NOWAIT 'Subcode CC round: '+komplex.code
	  endif
	  if len(trim(code))=6 and d_code=' '
	    clt_code=code
	    clt_dcode=space(6)
        clt_compl=compl
        SELECT icd_10
        SEEK SUBSTR(clt_code,1,5)
        icdw_par=code_w
        SEEK clt_code
        icdw=code_w
        icddw=d_code_w
        SELECT komplex
        IF icdw=icdw_par OR icddw=icdw
 	     seek substr(clt_code,1,5)
	     do while substr(clt_code,1,5)=trim(code) and not eof()
	      lc_compl=compl
	      seek clt_code+space(6)+SUBSTR(lc_compl,1,2)+SUBSTR(lc_compl,4,2)
	      if not found ()
			APPEND BLANK
			REPLACE compl WITH lc_compl, code WITH clt_code, d_code WITH clt_dcode, Valid WITH .T., chdate WITH date()
			WAIT WINDOW NOWAIT 'The program has added to the exclusisons of '+TRIM(TRIM(clt_code)+' '+clt_dcode)+ ' the CC-category of the parent code'
			select icd_10
			seek komplex.code
			do exclmaar
	       endif
	       select komplex
	       seek substr(clt_code,1,5)+' '+space(6)+SUBSTR(lc_compl,1,2)+SUBSTR(lc_compl,4,2)
	       skip
	       do while d_code<>' ' and not eof()
	         skip
	       enddo
	     enddo
         seek clt_code+space(6)+SUBSTR(clt_compl,1,2)+SUBSTR(clt_compl,4,2)
        endif
	  endif
	  select komplex
	  skip
	enddo
	on KEY label ctrl+j do COMPLTARK
	on KEY label ctrl+T do tehdyt
	WAIT WINDOW NOWAIT 'Ready'
	return

*!******************************************************************************
*!
*! Procedure COPYDEL
*!
*!  Calls
*!      DELETED
*!      EOF
*!      INT
*!      NOT
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      date
*!      found
*!
*!******************************************************************************
procedure copydel
*removal of redundant informatin in komplex-file
	SELECT komplex
	set ORDER to code
	set near on
	goto Top
	clt_code=' '
	clt_dcode=' '
	ct_n=1
	do WHILE NOT EOF()
		ct_n=ct_n+1
		if 100*INT(ct_n/100)=ct_n
			WAIT WINDOW NOWAIT 'Round for redundant complex information removal: '+dg.code
		endif
		clt_code=code
		clt_dcode=d_code
		clt_cc=compl
		if d_code<>' '
			SEEK clt_code+SUBSTR(clt_cc,1,2)+SUBSTR(clt_cc,4,2)
			if NOT found()
				SEEK clt_dcode+SUBSTR(clt_cc,1,2)+SUBSTR(clt_cc,4,2)
			endif
			if found()
				REPLACE Valid WITH .F.
				REPLACE code WITH ' ', d_code WITH ' '
			endif
			SELECT komplex
			SEEK clt_code+clt_dcode+SUBSTR(clt_cc,1,2)+SUBSTR(clt_cc,4,2)
		endif
		SELECT komplex
		if NOT EOF()
			SKIP
			if code=clt_code AND d_code=clt_dcode AND compl=clt_cc
				REPLACE Valid WITH .F.
			endif
		else 
			exit
		endif
	ENDDO
	on key label ctrl+t do tehdyt
	return
