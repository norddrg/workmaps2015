Procedure ominval
parameter om_ver, om_new
om_n=0
if om_ver='w'
  do while om_n<om_wn
    om_n=om_n+1
    if om_new=om_wval(om_n,1)
      return
    endif
    if om_new<om_wval (om_n,1)
      om_old=om_wval (om_n,1)
      om_wval (om_n,1)=om_new
      om_new=om_old
    endif
  enddo
  om_wn=om_wn+1
  dimension om_wval (om_wn,1)
  om_wval (om_wn,1)=om_new
else
  do while om_n<om_ln
    om_n=om_n+1
    if om_new=om_lval(om_n,1)
      return
    endif
    if om_new<om_lval (om_n,1)
      om_old=om_lval (om_n,1)
      om_lval (om_n,1)=om_new
      om_new=om_old
    endif
  enddo
  om_ln=om_ln+1
  dimension om_lval (om_ln,1)
  om_lval (om_ln,1)=om_new
endif
return  
