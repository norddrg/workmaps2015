*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\SIIRTO.PRG
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
*:   siirto
*!******************************************************************************
*!
*! Procedure SIIRTO
*!
*!  Calls
*!      AT
*!      BOF
*!      DELETED
*!      EOF
*!      FILTER
*!      LASTKEY
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      VALUES
*!      date
*!      dg
*!      found
*!      say
*!
*!******************************************************************************
procedure siirto
parameter lc_oir, lc_eti
dimension om_lval (1,1)
dimension om_wval (1,1)
public apu_dcode
apu_dcode='-'
SELECT dg
dg_order=ORDER()
activate window omin
clear
@ 1,1 say 'Definition of all properties of the diagnosis for NordDRG'
SELECT icd_10
set FILTER to Valid
set SKIP to
seek upper(lc_oir)
if found() and (ast='*' or ast='&') and lc_eti=' '
	@ 1,1 say (code +' is a manifestation code!')
	@ 2,1 say ('Do you wish to define properties for it (or for a pair?)')
	@ 3,1 say '[Y]es / [N]o?' 
	wait window '[Y]es / [N]o?' 
	if lastkey()=110 or lastkey()=78
		lc_code=space(6)
		@ 5,1 say 'Give the manifestation code!'
		@ 7,1 get lc_code picture '!!!!!!'
		@ 9,1 say 'Confirm the selection of the code in the following table with [Ctrl][W]'
		@ 10,1 say 'Cancel - [Esc] '
		read
		if not lastkey()=27
			select icd_10
			seek upper (lc_code)
			wait window nowait 'Select the code - accept with [Ctrl][W]'
			browse noedit
			if not lastkey()=27
				lc_eti = code
				apu_dcode=code
			endif
		endif
	else apu_dcode='-'
	endif
endif
select icd_10
seek upper(lc_oir+lc_eti)
lc_icdtext=trim(text)
if not found()
	seek upper(lc_oir)
	if found()
		lc_icdtext=trim(text)
		seek upper(lc_eti)
		if found ()
			lc_icdtext=lc_icdtext+'; '+trim (text)
		endif
	endif
endif
if not found()
	lc_icdtext='Not a valid ICD-10 code'
endif
Activate WINDOW omin
clear
@ 1,1 say 'Definition of all properties of diagnoses for NordDRG'
@ 2,1 say ('Diagnosis: '+ lc_oir+' '+lc_eti+': '+lc_icdtext)
@ 3,1 say 'Accept [Ctrl][W], cancel [Esc]'
@ 4,1 say 'Model is taken from '+dg.code+' '+dg.d_code
SELECT dg
do yhtnaytto
lc_dgo=dg.code
lc_dge=dg.d_code
set ORDER to code
dimension lc_omin (1,1)
lc_on=0
lc_kier=1
do while lc_kier>0 and lc_kier<10
	do case
	case lc_kier=1
		do lisnaytto with 'DGCAT', 'DGKAT'
	case lc_kier=2
		do lisnaytto with 'PDGPRO', 'PDGOMIN'
	case lc_kier=3
		do lisnaytto with 'DGPROP', 'DGOMIN'
	case lc_kier=4
		do lisnaytto with 'PROCPR', 'TPOMIN'
	case lc_kier=5
		do lisnaytto with 'OR', 'OR'
	case lc_kier=6
		do lisnaytto with 'COMPL', 'KOMPKAT'
	endcase
	if lastkey()=27
		exit
	endif
	lc_kier=lc_kier+1
enddo
if LASTKEY()=27
	Deactivate WINDOW omin
	on KEY label ctrl+T do tehdyt
	return
endif
select  dg
SEEK upper(lc_oir+lc_eti)
set filter to valid
SELECT icd_10
REPLACE icd_10.tehty WITH .T.
if p_kieli='Com'
	do versel
endif
SELECT dg
set ORDER to code
set FILTER to Valid
SEEK upper(lc_oir+lc_eti)
SELECT icd_10
SEEK upper(lc_oir+lc_eti)
if not found()
	select dg
	seek upper(lc_oir+lc_eti)
	if not found()
		select icd_10
		seek upper(lc_oir)
	endif
endif
do exclmaa2
SELECT icd_10
SEEK upper (lc_oir+lc_eti)
if not found()
	select dg
	seek upper (lc_oir+lc_eti)
	if not found()
		select icd_10
		seek upper(lc_oir)
	endif
endif
release ALL LIKE lc_*
do dgnaytto
on KEY label ctrl+T do tehdyt
return
