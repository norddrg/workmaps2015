*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\NDRGDIFF.PRG
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
*:   NDRGDIFF
*!******************************************************************************
*!
*! Procedure NDRGDIFF
*!
*!  Calls
*!      LEN
*!      SUBSTR
*!      TRIM
*!
*!******************************************************************************
procedure NDRGDIFF
	if p_kieli='Com'
		return
	endif
	lc_siirto='..\..\..\transp\'+p_kieli+'\dif\'
	do LOGDIFF
	do DGDIFF WITH 'e'
	do tpdiff WITH 'e'
	do CCDIFF
	do CEXDIFF with 'e'
	*do dgkadiff
	*do dgomdiff
	*do pdgpdiff
	*do tpomdiff
	*do rtcdiff

	return

*!******************************************************************************
*!
*! Procedure POINT
*!
*!  Calls
*!      LEN
*!      SUBSTR
*!      TRIM
*!
*!******************************************************************************
function point
	parameter fp_code
	re_code=fp_code
	if LEN(TRIM(fp_code))>3 AND SUBSTR(fp_code,4,1)<='9'
		re_code=SUBSTR(fp_code,1,3)+'.'+SUBSTR(fp_code,4,2)
	endif
	return re_code
endfunc
