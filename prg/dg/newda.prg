*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\NEWDA.PRG
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
*:   NEWDA
*!******************************************************************************
*!
*! Procedure NEWDA
*!
*!  Calls
*!      LASTKEY
*!
*!******************************************************************************
procedure NEWDA
	SELECT icd_10
	lc_loop=.T.
	do WHILE lc_loop
		WAIT WINDOW NOWAIT 'Select the asterisk code! Accept [Ctrl][W] Cancel [Esc]'
		BROWSE WINDOW kymppi nodelete FIELDS tehty:2:R, code:R:8, ast:2, d_code:R:7, who:2:R, code_w:8, d_code_w:7,;
			text:R:30, icd10to9.icd9_cm:8:R, icd10to9.icd9_cm2:6:R Save
		if LASTKEY()=27
			return
		endif
		if ast='*' AND d_code=' '
			nd_icdo=code
			EXIT
		endif
	ENDDO
	do WHILE lc_loop
		WAIT WINDOW NOWAIT 'Select the dagger code! Accept - [Ctrl][W], Cancel - [Esc]'
		BROWSE WINDOW kymppi nodelete FIELDS tehty:2:R, code:R:8, ast:2, d_code:R:7, who:2:R, code_w:8, d_code_w:7,;
			text:R:30, icd10to9.icd9_cm:8:R, icd10to9.icd9_cm2:6:R Save
		if LASTKEY()=27
			return
		endif
		if d_code=' '
			nd_icde=code
			EXIT
		endif
	ENDDO
	do siirto WITH nd_icdo, nd_icde
	return
