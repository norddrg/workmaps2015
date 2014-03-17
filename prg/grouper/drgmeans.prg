Procedure drgmeans

select drgdistr
set order to drg
replace all n_cas with 0, dur_mean with 0, n_case with 0, exp_mean with 0, sd with 0,; 
re2 with 0, weight with 0, n1trim with 0, m1trim with 0, sd1trim with 0, re2_1tri with 0,;
w1trim with 0, n2trim with 0, m2trim with 0, sd2trim with 0, re2_2tri with 0, w2trim with 0

p_grp=.t.

lc_exp=0
lc_dur=0
lc_ncas=0
lc_ncase=0
lc_loop=.t.

t_alku=val(sys(2))
lc_n_anal=0
select anal
*goto top
*count to lc_nn
*lc_casenn=str(lc_nn)
do grpohje
deactivate window anal
goto top
do while not eof()
  lc_n_anal=lc_n_anal+1
  if 10000*int((lc_n_anal-1)/10000)=lc_n_anal-1 
     wait window str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds, ';
     + str(lc_n_anal/(val(sys(2))-t_alku),5,0) +'/s, mean dur '+ str(lc_dur,5,1)+', mean exp '+str(lc_exp,10,2) nowait
  endif
  if len(trim(anal.drg))>0
    select drgdistr
    seek substr(anal.drg,1,4)
    lc_dur=((lc_ncas*lc_dur)+anal.dur)/(lc_ncas+1)
    lc_ncas=lc_ncas+1
    if not found()
      append blank
      replace drg with anal.drg, loc_drg with anal.drg
    endif
    replace dur_mean with ((n_cas*dur_mean)+anal.dur)/(n_cas+1)
    replace n_cas with n_cas+1
  endif
  if len(trim(anal.drg))>0 and anal.expences>0
    select drgdistr
    seek substr(anal.drg,1,4)
    lc_exp=((lc_ncase*lc_exp)+anal.expences)/(lc_ncase+1)
    lc_ncase=lc_ncase+1
    if not found()
      append blank
      replace drg with anal.drg, loc_drg with anal.drg
    endif
    replace exp_mean with ((n_case*exp_mean)+anal.expences)/(n_case+1)
    replace n_case with n_case+1
  endif
  
  select anal
  skip
enddo

set safety on
t_loppu=val(sys(2))
do grpohje

wait window nowait "DRG means calculated"

select drgdistr
goto top
replace exp_mean with lc_exp, n_case with lc_ncase, n_cas with lc_ncas, dur_mean with lc_dur 

activate window anal
browse in window anal save nowait
p_grp=.f.
do grpohje
RETURN
