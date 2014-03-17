*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\PAIV.PRG
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
*:   dgpaiv
*!******************************************************************************
*!
*! Procedure DGPAIV
*!
*!  Calls
*!      ALIAS
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      found
*!
*!******************************************************************************
procedure dgpaiv
	lc_alias=ALIAS()
	SELECT icd_10
	*SET FILTER TO PRIM
	set SKIP to
	if lc_alias='ICD_10'
		do icdpaiv
	endif
	if lc_alias='DGKAT'
		do dgkpaiv
	ELSE
		SELECT dgkat
		goto Top
	endif
	if lc_alias='KOMPKAT'
		do komppaiv
	endif
	if lc_alias='KOMPLEX'
		do kl_paiv
	endif
	if lc_alias='PDGOMIN'
		do pdg_paiv
	ELSE
		SELECT pdgomin
		goto Top
	endif
	if lc_alias='DGOMIN'
		do dgo_paiv
	ELSE
		SELECT dgomin
		goto Top
	endif
	if lc_alias='TPOMIN'
		do tpo_paiv
	ELSE
		SELECT tpomin
		goto Top
	endif
	if lc_alias='DG'
		do DRGPAIV
	endif
	SELECT icd_10
	lc_codes=code+d_code
	SELECT (lc_alias)
	do ..\dg\dgnaytto
	return

*!******************************************************************************
*!
*! Procedure ICDpaiv
*!
*!  Calls
*!      ALIAS
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      found
*!
*!******************************************************************************
procedure icdpaiv
	SELECT dg
	lc_order=ORDER()
	set ORDER to code
	if icd_10.d_code=SPACE(6)
		SEEK upper(icd_10.code)
	ELSE
		SEEK (icd_10.code+icd_10.d_code)
		if NOT found()
			SEEK upper(icd_10.d_code)
			if found()
				SEEK upper(icd_10.code)
			endif
		endif
	endif
	if found()
		SELECT icd_10
		if Valid
			REPLACE tehty WITH .T.
		ELSE
			REPLACE dg.Valid WITH .F.
		endif
	ELSE
		SKIP -1
	endif
	SELECT komplex
	set ORDER to compl
	SEEK SUBSTR(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2)
	return

*!******************************************************************************
*!
*! Procedure DRGpaiv
*!
*!  Calls
*!      ALIAS
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      found
*!
*!******************************************************************************
procedure DRGpaiv
	SELECT icd_10
	lc_order=ORDER()
	set ORDER to code
	SEEK upper(TRIM(dg.code+dg.d_code))
	SELECT icd_10
	set ORDER to lc_order
	return

*!******************************************************************************
*!
*! Procedure KOMPpaiv
*!
*!  Calls
*!      ALIAS
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      found
*!
*!******************************************************************************
procedure komppaiv
	SELECT komplex
	set ORDER to compl
	SEEK SUBSTR(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2)
	SELECT dg
	set ORDER to varval
	SEEK 'COMPL   '+SUBSTR(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2)+SUBSTR(kompkat.compl,3,1)
	SELECT dgomin
	SEEK kompkat.inclprop
	SELECT kompkat
	return

*!******************************************************************************
*!
*! Procedure KL_paiv
*!
*!  Calls
*!      ALIAS
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      found
*!
*!******************************************************************************
procedure kl_paiv
	SELECT icd_10
	lc_order=ORDER()
	set ORDER to code
	SEEK (komplex.code+ komplex.d_code)
	set ORDER to lc_order
	SELECT dg
	lc_order=ORDER()
	set ORDER to code
	SEEK upper(icd_10.code+icd_10.d_code)+'COMPL'+ kompkat.compl
	set ORDER to lc_order
	SELECT kompkat
	SEEK SUBSTR(komplex.compl,1,2)+SUBSTR(komplex.compl,4,2)
	return

*!******************************************************************************
*!
*! Procedure DGO_paiv
*!
*!  Calls
*!      ALIAS
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      found
*!
*!******************************************************************************
procedure dgo_paiv
	SELECT dg
	set ORDER to varval
	SEEK ('DGPROP  '+SUBSTR(dgomin.dgprop,1,2)+SUBSTR(dgomin.dgprop,4,2)+SUBSTR(dgomin.dgprop,3,1))
	if NOT found()
		WAIT WINDOW dgomin.dgprop+' ei ole käytössä!'
	endif
	return

*!******************************************************************************
*!
*! Procedure TPO_paiv
*!
*!  Calls
*!      ALIAS
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      found
*!
*!******************************************************************************
procedure tpo_paiv
	SELECT dg
	set ORDER to varval
	SEEK 'PROCPR  '+SUBSTR(tpomin.procprop,1,2)+SUBSTR(tpomin.procprop,4,2)+SUBSTR(tpomin.procprop,3,1)
	if NOT found()
		WAIT WINDOW tpomin.procprop+' ei ole käytössä!'
	endif
	return

*!******************************************************************************
*!
*! Procedure DGKpaiv
*!
*!  Calls
*!      ALIAS
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      found
*!
*!******************************************************************************
procedure dgkpaiv
	SELECT dg
	set ORDER to varval
	SEEK 'DGCAT   '+SUBSTR(dgkat.dgcat,1,2)+SUBSTR(dgkat.dgcat,4,2)
	if NOT found()
		WAIT WINDOW dgkat.dgcat+' ei ole käytössä!'
	endif
	return


*!******************************************************************************
*!
*! Procedure PDG_paiv
*!
*!  Calls
*!      ALIAS
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      found
*!
*!******************************************************************************
procedure pdg_paiv
	SELECT dg
	set ORDER to varval
	SEEK 'PDGPRO  '+SUBSTR(pdgomin.pdgprop,1,2)+SUBSTR(pdgomin.pdgprop,4,2)+SUBSTR(pdgomin.pdgprop,3,1)
	if NOT found()
		WAIT WINDOW pdgomin.pdgprop+' ei ole käytössä'
	endif
	return

