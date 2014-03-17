procedure othverup
* muiden versioiden päivittäminen
select icd_oth
set order to code_w
seek upper(icd_10.code+icd_10.d_code)
om_ln=0
om_wn=0
do while upper(icd_oth.code_w)=upper(icd_10.code) and upper(icd_oth.d_code_w)=upper(icd_10.d_code)
  lc_wicdo=icd_oth.code
  lc_wicde=icd_oth.d_code
  lc_icdo=icd_10.code
  lc_icde=icd_10.d_code
  do omintype with 'DGCAT', p_kieli
  do ominrivi with 'DGCAT'
  do omintype with 'PDGPRO', p_kieli
  do ominrivi with 'PDGPRO'
  do omintype with 'DGPROP', p_kieli
  do ominrivi with 'DGPROP'
  do omintype with 'PROCPR', p_kieli
  do ominrivi with 'PROCPR'
  do omintype with 'OR', p_kieli
  do ominrivi with 'OR'
  do omintype with 'COMPL', p_kieli
  do ominrivi with 'COMPL'
  select icd_oth
  skip
enddo
return


Procedure ominrivi
parameter om_type
*offers to write selected type missing properties to file
om_lnn=1
om_wnn=1
om_loop=.t.
do while om_loop
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
    if om_wval (om_wnn,1)<= om_lval(om_lnn,1) 
      om_loc=.f.
    endif
    if om_lval (om_lnn,1) <= om_wval(om_wnn,1)
      om_eng=.f.
    endif
  endif
  if om_eng
    select dg_oth
    om_omin=om_wval (om_wnn,1)
    wait window trim(icd_oth.code)+' '+trim(icd_oth.text)+' - '+om_type+'-'+om_omin+;
    ' will be removed from '+language.lan+'-file. Y(es)/N(o)'
    if lastkey()=121 or lastkey()=89
      seek upper(icd_oth.code+icd_oth.d_code)+om_type+space(8-len(om_type))+om_omin
      if found()
        replace valid with .f.
      else
        set step on
      endif
    endif
    om_wnn=om_wnn+1
  endif
  if om_loc
    select dg_oth
    om_omin=om_lval(om_lnn,1)
    wait window trim(icd_oth.code)+' '+trim(icd_oth.text)+' - '+om_type+'-'+om_omin+;
    ' will be added to '+language.lan+'-file. Y(es)/N(o)'
    if lastkey()=121 or lastkey()=89
      seek upper(icd_oth.code+icd_oth.d_code)+om_type+space(8-len(om_type))+om_omin
      if not found()
		INSERT INTO dg_oth (code, d_code, who, Valid, code_w, d_code_w, VARTYPE, varval) ;
		VALUES (icd_oth.code, icd_oth.d_code, icd_10.who, .T., icd_10.code_w, icd_10.d_code_w,om_type, om_omin)
		select dg_oth
		REPLACE chdate WITH date()
      else
        set step on
      endif
    endif
    om_lnn=om_lnn+1
  endif
  if not om_eng and not om_loc
    om_lnn=om_lnn+1
    om_wnn=om_wnn+1
  endif
enddo
return

