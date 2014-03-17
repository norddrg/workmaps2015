*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\KOODHAK.PRG
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
*:   KOODHAK
*!******************************************************************************
*!
*! Procedure KOODHAK
*!
*!  Calls
*!      LASTKEY
*!      LEN
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!
*!******************************************************************************
procedure KOODHAK
	SELECT icd_10
	lc_kood=SPACE(6)
DEFINE WINDOW kh_apu FROM 5,5 to 14,50 FONT 'Arial' 8
Activate WINDOW kh_apu
@ 1,1 say 'Order: '+ORDER()
@ 2,1 say 'Give a code for searching!'
@ 3,1 get lc_kood Picture '!!!!!!'
READ
if LASTKEY()=27
	release WINDOW kh_apu
	return
endif
*if LEN(TRIM(lc_kood))>3
*	if SUBSTR(lc_kood,4,1)>'.' AND SUBSTR(lc_kood,4,1)<='9' AND p_kieli<>'Dan'
*		lc_kood=SUBSTR(lc_kood,1,3)+'.'+SUBSTR(lc_kood,4,2)
*	endif
*endif
lc_kood=TRIM(lc_kood)
release WINDOW kh_apu
SEEK (lc_kood)
BROWSE last NOWAIT Save WINDOW kymppi
return
