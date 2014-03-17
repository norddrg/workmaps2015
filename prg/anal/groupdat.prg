Procedure groupdat
wait window "Grouping testdata" nowait
set status off
select anal
goto top
lc_n_anal=1
t_alku=val(sys(2))
do while not eof()
  if 100*int((lc_n_anal)/100)=lc_n_anal 
     wait window str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds' nowait
  endif
  do ..\anal\luokitus
  lc_n_anal=lc_n_anal+1
  select anal
  skip
enddo
set status on
wait window str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds' nowait
return
