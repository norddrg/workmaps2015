Procedure insweigh
wait window nowait "Inserting weights to database"
select anal
lc_n_anal=0
t_alku=val(sys(2))
goto top
do while not eof()
  lc_n_anal=lc_n_anal+1
  if 10000*int((lc_n_anal-1)/10000)=lc_n_anal-1 
     wait window 'Inserting weights to database: '+ str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds, ';
     + str(lc_n_anal/(val(sys(2))-t_alku),5,0) +'/s' nowait
  endif
  select drgdistr
  seek substr(anal.drg,1,4)
  replace anal.exp_tw with drgdistr.w2trim
  replace anal.exp_w with drgdistr.weight
  select anal
  skip
enddo
do grpohje
return
