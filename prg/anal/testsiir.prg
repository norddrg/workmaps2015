Procedure testsiir
t_alku=val(sys(2))
select 0
USE ..\drganal\anal_allrules.dbf alias anal
set order to
goto top
lc_n_anal=0
do while not eof()
  if 100*int((lc_n_anal-1)/100)=lc_n_anal-1 
     p_nayt=.t.
     wait window str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds' nowait
  endif
  do ..\luokitus
  lc_n_anal=lc_n_anal+1
  select anal
  skip
enddo
return