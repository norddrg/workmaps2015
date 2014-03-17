Procedure dgprokir
lc_d=' '
lc_dd=' '
lc_f=' '
lc_fd=' '
lc_s=' '
lc_sd=' '
lc_n=' '
lc_nd=' '
select dg
SEEK icd_10.code
if found()
  lc_d=code_d
  lc_f=code_f
  lc_s=code_s
  lc_n=code_n
endif
if icd_10.d_code<>' '
  seek icd_10.d_code
  if found()
    lc_fd=code_f
    lc_sd=code_s
    lc_nd=code_n
  endif
  if lc_dd=' '
    lc_d=' '
  endif
  if lc_fd=' '
    lc_f=' '
  endif
  if lc_sd=' '
    lc_s=' '
  endif
  if lc_nd=' '
    lc_n=' '
  endif
endif
lc_found=.f.
if icd_10.code<>' '
  seek icd_10.code+space(6)+'DGKAT   '+dgomin.dgprop
  if not found() or not valid
    seek icd_10.d_code+space(6)+'DGKAT   '+dgomin.dgprop
  endif
  if found() and valid				 
    lc_found=.t.
  endif
endif
if not lc_found
  seek icd_10.code+icd_10.d_code+'DGKAT   '+dgomin.dgprop
  if not found() and valid
    INSERT INTO dg (code, d_code, who, valid, code_w, d_code_w, vartype, varval) ;
    VALUES (icd_10.code, icd_10.d_code, icd_10.who, .t., icd_10.code_w, icd_10.d_code_w,'PDGPRO', dgomin.dgprop)
    replace code_f with lc_f, d_code_f with lc_fd
    replace code_d with lc_d, d_code_d with lc_dd
    replace code_s with lc_s, d_code_s with lc_sd
    replace code_n with lc_n, d_code_n with lc_nd
    replace chdate with date()
  endif
endif
return
