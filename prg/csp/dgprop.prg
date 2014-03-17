Procedure dgprop
select drgtpt
set relation to
if p_kieli='Com'
  lc_code=ncsp_en.code_nc
else
  lc_code=ncsp_en.code
endif
if drgtpt.vartype='DGPROP'
  p_omin=drgtpt.varval
endif
select dgomin
wait window 'Check the diagnosisproperty! Continue = [Ctrl][W], Cancel = [Esc]' nowait
seek SUBSTR(p_omin,1,2)+SUBSTR(p_omin,4,2)+SUBSTR(p_omin,3,1)
browse window tpomin fields dgprop:R, english:R, finish:R save rest
if lastkey()=27
  select tpomin
  browse window tpomin fields procprop:R, english:R, finish:R nowait save
  return
endif
lc_omin=dgomin.dgprop
select drgtpt
seek (lc_code)
replace dgprop with lc_omin
select drgtpt
set relation to SUBSTR(dgprop,1,2)+SUBSTR(dgprop,4,2)+SUBSTR(dgprop,3,1) into dgomin
select ncsp_en
do cspnaytto
return
