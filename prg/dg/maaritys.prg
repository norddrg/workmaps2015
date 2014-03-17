*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\MAARITYS.PRG
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
*:   MAARITYS
*!******************************************************************************
*!
*! Procedure MAARITYS
*!
*!  Calls
*!      ALIAS
*!
*!******************************************************************************
procedure MAARITYS
	if ALIAS()='ICD_10' OR 'DG'=ALIAS()
		do siirto WITH upper(code), upper(d_code)
	ELSE
		do yksomkir
	endif
	return
