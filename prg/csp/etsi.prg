procedure etsi
parameter et_kood
if len(et_kood)<6
  et_kood=et_kood+space(5-len(et_kood))
endif
select ncsp_cha
set filter to
seek substr(et_kood,1,1)
select ncsp_gro
set filter to
seek substr(et_kood,1,2)
select ncsp_sub
set filter to
seek substr(et_kood,1,3)
select csp
lc_order=order()
set filter to 
set order to code
seek et_kood
set order to lc_order
return