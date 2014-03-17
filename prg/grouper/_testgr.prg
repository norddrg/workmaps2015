procedure _testgr
CLEAR ALL
*on key label enter do a__2
*do \foxproc\scrsize
set default to ..\grouper
set status on
public max_y, max_x, max_foty, max_fosi
max_y=srows()-3
max_x=scols()-4
max_foty='Small Font'
max_fosi=6
if max_x>100
  max_foty='Arial'
  max_fosi=8
endif
public t_alku, t_alku0, t_loppu
t_alku=0
t_alkuo=0
t_loppu=0
do testgr
return

