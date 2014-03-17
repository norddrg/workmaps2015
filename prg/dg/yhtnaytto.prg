*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\YHTNAYTTO.PRG
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
*:   yhtnaytto
*!******************************************************************************
*!
*! Procedure YHTNAYTTO
*!
*!  Calls
*!      ALIAS
*!      EOF
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      found
*!      to
*!
*!******************************************************************************
procedure yhtnaytto
*set step on
DEFINE WINDOW yhtveto FROM min_y/2,max_x/6 to max_y-5,max_x-5 TITLE 'Summary of properties' FONT 'Courier New',8
Activate WINDOW yhtveto
lc_alias=ALIAS()
SELECT icd_10
icd_ord=ORDER()
icd_code=code
icd_dcode=d_code
lc_wicdo=' '
lc_wicde=' '
dimension om_lval (1,1)
dimension om_wval (1,1)
om_ln=0
om_wn=0

*locate ICD-codes
if lc_alias='ICD_10'
	lc_icdo=code
	lc_icde=d_code
	lc_wicdo=code_w
	lc_wicde=d_code_w
	SELECT dg
	SEEK upper(lc_icdo+lc_icde)
ELSE
	SELECT dg
	lc_icdo=code
	lc_icde=d_code
	select icd_10
	seek upper(lc_icdo+lc_icde)
	if found()
	  lc_wicdo=code_w
	  lc_wicde=d_code_w
	else
	  seek upper(lc_icdo)
	  if found()
	    lc_wicdo=code_w
	  endif
	  seek upper(lc_icde)
	  if found()
	    lc_wicde=code_w
	  endif
	endif
endif
if lc_icdo=' '
	return
endif
* Eof locate ICD-codes

* Locate ICD-texts
SELECT icd_10
SEEK upper(lc_icdo+lc_icde)
if NOT found()
	lc_text='Not '+TRIM(language.Name) +' code'
	SEEK upper(lc_icdo)
	if found()
		lc_text=TRIM(text)
	endif
	SEEK upper(lc_icde)
	if found()
		lc_text=lc_text+'; '+TRIM(text)
	ELSE
		lc_text='Not '+TRIM(language.Name) +' code'
	endif
ELSE
	lc_text=TRIM(text)
endif
seek upper(upper(lc_icdo))
if p_kieli<>'Com'
  SELECT icd_oth
  SEEK upper(lc_wicdo+lc_wicde)
  if NOT found()
  	lc_wtext='Not WHO ICD-10 code'
  	seek upper(lc_wicdo)
  	if found()
  		lc_wtext=trim(text)
  	endif
  	if lc_wicde<>' '
  		seek upper(lc_wicde)
  		if found()
  			lc_wtext=lc_wtext+'; '+trim(text)
  		else
  			lc_wtext=lc_wtext+'; not WHO ICD-10 code'
  		endif
  	endif
  ELSE
	lc_wtext=TRIM(text)
  endif
endif
if lc_icde=' ' and icd_10.ast='*'
	do case
	case apu_dcode='-'
		*
	case apu_dcode=' '
		do icdwrite
		?
		? lc_icdo+' is a manifestation code! Do you wish to select an etiological code to the pair?'
		? '[Y]es/[N]o?'
		wait window '[Y]es / [N]o?' 
		if lastkey()=121 or lastkey()=89
			lc_code=space(6)
			? 'Give the manifestation code!'
			@ 7,1 get lc_code picture '!!!!!!'
			? 'Confirm the selection of the code in the following table with [Ctrl][W]'
			? 'Cancel - [Esc] '
			read
			if not lastkey()=27
				select icd_10
				seek upper(lc_code)
				wait window nowait 'Select the code - accept with [Ctrl][W]'
				browse noedit
				if not lastkey()=27
					lc_icde = code
					lc_text=lc_text+'; '+TRIM(text)
					if p_kieli<>'Com'
						lc_wicde=code_w
						SELECT icd_oth
						seek upper(lc_wicde)
						if found()
							lc_wtext=lc_wtext+'; '+trim(text)
						endif
					endif
				endif
			endif
		endif
	otherwise
		lc_icde=apu_dcode
		select icd_10
		seek upper(lc_icde)
		lc_wicde=code_w
	endcase
endif
* Eof locate ICD-texts

do icdwrite
?
? 'Properties marked with * are not inuse'
?

* Collection and reporting of properties of diagnoses
do omintype with 'DGCAT', p_kieli
if om_ln>0 or om_wn>0
  ?? 'MDC:' AT 1
  do ominrivi with 'MDC'
  ?? 'DGCAT:' AT 1
  do ominrivi with 'DGCAT'
endif
do omintype with 'PDGPRO', p_kieli
if om_ln>0 or om_wn>0
  ?? 'PDGPROP:' at 1
  do ominrivi with 'PDGPRO'
endif

do omintype with 'DGPROP', p_kieli
if om_ln>0 or om_wn>0
  ?? 'DGPROP:' at 1
  do ominrivi with 'DGPROP'
endif

do omintype with 'PROCPR', p_kieli
if om_ln>0 or om_wn>0
  ?? 'PROCPR' at 1
  do ominrivi with 'PROCPR'
endif

do omintype with 'OR', p_kieli
if om_ln>0 or om_wn>0
  ?? 'OR' at 1
  do ominrivi with 'OR'
endif

do omintype with 'COMPL', p_kieli
if om_ln>0 or om_wn>0
  ?? 'COMPLCAT:' AT 1
  do ominrivi with 'COMPL'
endif

* Collection and report of complication exclusions
SELECT komplex
set ORDER to code
set FILTER to Valid
SEEK upper(lc_icdo+lc_icde)
if lc_icde<>' ' AND NOT found()
	SEEK upper(lc_icdo)+' '
	if NOT found()
		SEEK (lc_icde)+' '
	endif
endif
lc_locf=found()
if p_kieli<>'Com'
  SELECT komplex_oth
  set ORDER to code
  set FILTER to Valid
  SEEK upper(lc_wicdo+lc_wicde)
  if lc_wicde<>' ' AND NOT found()
	SEEK upper(lc_wicdo)+' '
	if NOT found()
		SEEK upper(lc_wicde)+' '
	endif
  endif
  lc_engf=found()
else
  lc_engf=.f.
endif
?
if NOT (lc_locf or lc_engf)
	? 'As main diagnosis complicated by any CC-category' AT 1
ELSE
	WAIT WINDOW 'Press any key to continue'
	CLEAR
	do icdwrite
	?
	? 'Properties marked with * are not inuse'
	?
	? "As main diagnosis not complicated by dg's in CC category:" AT 1
	?
	select komplex
	lc_n=0
	do comptype with p_kieli
	do ominrivi with 'COMPL'
endif
WAIT WINDOW 'To continue, push any key!'
*BROWSE WINDOW komplex NOEDIT NODELETE NOWAIT SAVE FIELDS compl, code, d_code, valid, chdate, danish, finish, norw, swedish, who
release WINDOW yhtveto
SELECT icd_10
set ORDER to code
SEEK upper(icd_code+icd_dcode)
if not found()
	seek upper(icd_code)
endif
set ORDER to (icd_ord)
SELECT dg
SEEK upper (lc_icdo+lc_icde)
if NOT found()
	SEEK upper(lc_icdo)
endif
return

Procedure ominrivi
parameter om_type
*writes selected type properties on screen
om_lnn=1
om_wnn=1
om_loop=.t.
om_omin=' '
if p_kieli='Com'
  om_wn=0
endif
om_rivi=1
do while om_loop
  if om_rivi>9
    wait window 'To continue, push any key'
    om_rivi=1
  endif
  om_eng=.t.
  om_loc=.t.
  if om_wnn>om_wn 
    om_eng=.f.
  endif
  if om_lnn>om_ln
    om_loc=.f.
  endif
  if not (om_eng or om_loc)
    exit
  endif
  if om_eng and om_loc
    if om_wval (om_wnn,1)< om_lval(om_lnn,1) 
      om_loc=.f.
    endif
    if om_lval (om_lnn,1)<om_wval(om_wnn,1)
      om_eng=.f.
    endif
  endif
  if om_eng
    if om_type='MDC'
      om_omin=substr(om_wval (om_wnn,1),1,2)
    else
      om_omin=om_wval (om_wnn,1)
    endif
    ?? om_omin at 14        
    om_wnn=om_wnn+1
  endif
  if om_loc
    if om_type='MDC'
      om_omin=substr(om_lval(om_lnn,1),1,2)
    else
      om_omin=om_lval(om_lnn,1)
    endif
    ?? om_omin at 20
    om_lnn=om_lnn+1
*   lc_n=lc_n+1
  endif
  do case
  case om_type='DGCAT' or om_type='MDC'
  	select dgkat
  case om_type='PROCPR'
    select tpomin
  case om_type='PDGPRO'
    select pdgomin
  case om_type='DGPROP'
    select dgomin
  case om_type='COMPL'
    select kompkat
  otherwise
    select dg
  endcase
  seek om_omin  
  if not found()
    seek SUBSTR(om_omin,1,2)+SUBSTR(om_omin,4,2)  
  endif
  if found()  
    if om_type='DGCAT' or om_type='MDC' 
      if not valid and om_omin<>' '
        ?? '*' at 13
      endif
    else
      if not inuse and om_omin<>' '
        ?? '*' at 13
      endif
    endif
    ?? trim(english) at 27
    ? trim(finish) at 27
    ?
  else
    if om_type='OR'
      ?? 'Operation room procedure' at 27
      ?  'Leikkaussalitoimenpide' at 27
      ?
    else
      ?? '*' at 13
      ?? 'Invalid property code' at 27
      ?
      ?
    endif
  endif
  if not om_eng and not om_loc
    om_lnn=om_lnn+1
    om_wnn=om_wnn+1
  endif
  om_rivi=om_rivi+1
enddo
return

procedure icdwrite
*Write ICD-codes and texts
CLEAR
? lc_icdo AT 1
if lc_icde<>' '
  ?? '*'+lc_icde AT 7
endif
?? lc_text AT 27
if p_kieli<>'Com'
  ?? p_kieli at 20
  select icd_oth
  ? lc_wicdo at 1
  if lc_wicde<>' '
    ?? '*'+ lc_wicde at 7
  endif
  ?? 'Com' at 14
  ?? lc_wtext at 27    
endif
* Eof write ICD-codes and texts
return
