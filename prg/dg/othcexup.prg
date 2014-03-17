procedure othcexup
* muiden versioiden ekskluusioiden päivittäminen
select icd_oth
set order to code_w
seek icd_10.code+icd_10.d_code
om_ln=0
om_wn=0
do while icd_oth.code_w=icd_10.code and icd_oth.d_code_w=icd_10.d_code
  lc_wicdo=icd_oth.code
  lc_wicde=icd_oth.d_code
  lc_icdo=icd_10.code
  lc_icde=icd_10.d_code
  do comptype with language.lan
  if om_ln>0 or om_wn>0
    do ominrivi 
  endif
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
    select komplex_oth
    om_omin=om_wval (om_wnn,1)
    wait window trim(icd_oth.code)+' '+trim(icd_oth.text)+' - '+om_omin+;
    ' will be removed from '+language.lan+'complex-file. Y(es)/N(o)'
    if lastkey()=121 or lastkey()=89
      select komplex_oth
      seek icd_oth.code+icd_oth.d_code+SUBSTR(om_omin,1,2)+SUBSTR(om_omin,4,2)
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
    wait window trim(icd_oth.code)+' '+trim(icd_oth.text)+' - '+om_omin+;
    ' will be added to '+language.lan+'-complex-file. Y(es)/N(o)'
    if lastkey()=121 or lastkey()=89
      seek icd_oth.code+icd_oth.d_code+SUBSTR(om_omin,1,2)+SUBSTR(om_omin,4,2)
      if not found()
		INSERT INTO komplex_oth (code, d_code, Valid, compl) ;
		VALUES (icd_oth.code, icd_oth.d_code, .T., om_omin)
		select komplex_oth
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
