Procedure jarjesty
select ncsp_en
if order()='ICD9CM'
  select icd9cm_o
  SET ORDER TO Icd9_tp 
  set relation to
  select link
  set order to ncsp
  set relation to link.icd9cm_o into icd9cm_o 
  select ncsp_en
  set filter to not released
  set order to code
  set relation to code into drgtpt
  set skip to drgtpt
  if p_kieli<>'Com'
    set relation to ncsp into link additive
  else
    set relation to code into link additive
  endif
  wait window 'Järjestetty NCSP-koodin mukaan' nowait
  set order to simple
  p_order='N'
else
  select ncsp_en
  set relation to code into drgtpt
  set skip to drgtpt
  select link
  set order to icd9cm_o
  set relation to ncsp into ncsp_en
  select icd9cm_o
  SET ORDER TO Icd9_tp 
  set relation to icd9_tp into link
  wait window 'Järjestetty ICD-9-CSP-koodin mukaan' nowait
  p_order='I'
endif
do cspnaytto
return