*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\_DGDRG.PRG
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
*:   _DGDRG
*!******************************************************************************
*!
*! Procedure _DGDRG
*!
*!  Calls
*!      scols
*!      srows
*!
*!******************************************************************************
procedure _DGDRG
	set default to ..\dg
	PUSH KEY CLEAR
	CLOSE DATABASES
	CLEAR WINDOWS
	set date YMD
	set status on
	public max_y, max_x, max_foty, max_fosi, p_logluku, p_class, p_ord
	p_ord=' '
	p_class=.f.
	p_logluku=.f.
	max_y=srows()-3
	max_x=scols()-4
	max_foty='Small Font'
	max_fosi=6
	if max_x>100
		max_foty='Arial'
		max_fosi=8
	endif
	public min_y, min_x
	min_y=INT(max_y/6)
	if min_y<5
		min_y=5
	endif
	min_x=INT(max_x/3)
	DEFINE WINDOW valikko FROM 1,1 to max_y-2, 2*min_x-2 FONT  max_foty,  max_fosi
	Activate WINDOW valikko
	on error do pldg
	? p_ldg
	on error do plproc
	? p_lproc
	on error do pldrg
	? p_ldrg
	on error
	do ..\common\langsel
	do ..\common\logicsel
	set ORDER to ord
	do dgdrg
	return

*!******************************************************************************
*!
*! Procedure PLDRG
*!
*!  Calls
*!      scols
*!      srows
*!
*!******************************************************************************
procedure pldrg
	public p_ldrg
	p_ldrg='470'
	return

*!******************************************************************************
*!
*! Procedure PLDG
*!
*!  Calls
*!      scols
*!      srows
*!
*!******************************************************************************
procedure pldg
	public p_ldg
	p_ldg='A00.0'
	return

*!******************************************************************************
*!
*! Procedure PLPROC
*!
*!  Calls
*!      scols
*!      srows
*!
*!******************************************************************************
procedure plproc
	public p_lproc
	p_lproc='AAA00'
	return
