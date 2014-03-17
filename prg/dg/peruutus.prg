*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\PERUUTUS.PRG
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
*:   peruutus
*!******************************************************************************
*!
*! Procedure PERUUTUS
*!
*!  Calls
*!      ALIAS
*!
*!******************************************************************************
procedure peruutus
dimension om_lval (1,1)
dimension om_wval (1,1)
	if ALIAS()<>'DG'
		WAIT WINDOW 'Select DG-window'
		return
	endif
	if vartype='DGCAT'
	  wait window 'Each diagnosis must have diagnosis category - you cannot delete a diagnosis category'
	endif
	lc_oir=code
	lc_eti=d_code
	REPLACE Valid WITH .F.
	select icd_10
	seek upper(lc_oir+lc_eti)
	if not found()
	  seek upper(lc_oir)
	endif
	if p_kieli='Com'
		do versel
	endif
	select icd_10
	do ..\dg\dgnaytto
	return
