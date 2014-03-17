procedure _drganal

CLEAR ALL
*on key label enter do a__2
*do \foxproc\scrsize
set default to ..\anal
CD ..\anal
set status off
SET FULLPATH ON
public max_y, max_x, max_foty, max_fosi, p_class,p_ord
p_class=.f.
p_ord='00'
max_y=srows()-3
max_x=scols()-4
max_foty='Small Font'
max_fosi=6
if max_x>100
  max_foty='Arial'
  max_fosi=8
endif
on error do pldg
? p_ldg
on error do plproc
? p_lproc
on error do pldrg
? p_ldrg
on error
public p_lproc, p_ldg, p_ldrg
do selanbt
if lastkey()=66 or lastkey()=98
  do ..\grouper\_testgr
  return
endif
do drganal
return
