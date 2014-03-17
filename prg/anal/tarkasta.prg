procedure tarkasta
*push key clear
on key label alt+f1 do _drganal
set status off
set near on
select anal
set order to
goto top
t_alku=val(sys(2))
lc_n_anal=0
lc_n_del=0
do while not eof()
  lc_drg=drg
  lc_oir1=oir1
  lc_oir2=oir2
  lc_oir3=oir3
  lc_oir4=oir4
  lc_syy1=syy1
  lc_syy2=syy2
  lc_syy3=syy3
  lc_syy4=syy4
  lc_tp1=tp1
  lc_tp2=tp2
  lc_tp3=tp3
  lc_tp4=tp4
  lc_n_anal=lc_n_anal+1
  p_nayt=.f.
  if 100*int((lc_n_anal-1)/100)=lc_n_anal-1 
     p_nayt=.t.
     wait window str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds' nowait
  endif
  if oir1<>'---'
    do luokitus
    select anal
    if order()='DRG' and drg<>lc_drg
      seek lc_drg+lc_oir1
      skip -1
    endif
  endif
  skip
enddo
pop key
set status on
do analohje
do analjarj
return