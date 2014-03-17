Procedure exp_msd

select drgdistr
set order to drg
replace all n_cas with 0, dur_mean with 0, n_case with 0, exp_mean with 0, sd with 0,; 
re2 with 0, weight with 0, n1trim with 0, m1trim with 0, sd1trim with 0,;
w1trim with 0, n2trim with 0, m2trim with 0, sd2trim with 0, w2trim with 0

p_grp=.t.

lc_exp=0
lc_dur=0
lc_ncas=0
lc_ncase=0
lc_loop=.t.
lc_re2=0

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
     wait window 'Calculation of untrimmed means: '+ str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds, ';
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
    if anal.expences>0
      lc_exp=((lc_ncase*lc_exp)+anal.expences)/(lc_ncase+1)
      lc_re2=((lc_ncase*lc_re2)+(anal.expences)**2)/(lc_ncase+1)
      lc_ncase=lc_ncase+1
      replace exp_mean with ((n_case*exp_mean)+anal.expences)/(n_case+1)
      replace re2 with ((n_case*re2)+(anal.expences)**2)/(n_case+1)
      replace n_case with n_case+1
      replace anal.trimmed with .f.
    else 
      replace anal.trimmed with .t.
    endif
  endif
  
  select anal
  skip
enddo

set safety on
t_loppu=val(sys(2))
do grpohje

select drgdistr
goto top
replace exp_mean with lc_exp, n_case with lc_ncase, n_cas with lc_ncas, dur_mean with lc_dur, re2 with lc_re2 
lc_tcas=n_case
lc_tmean=exp_mean
replace dur_total with n_cas*dur_mean
replace exp_total with n_case*exp_mean
if n_case>0
  replace weight with exp_mean/lc_tmean 
else 
  replace exp_mean with -9.999
  replace weight with -9.999
endif
do while not eof()
  skip
  replace dur_total with n_cas*dur_mean
  replace exp_total with n_case*exp_mean
  if lc_tcas>0
    if n_case>0
      replace weight with exp_mean/lc_tmean 
    else 
      replace exp_mean with -9.999
      replace weight with -9.999
    endif
    if n_case>2
      if (re2-(exp_mean**2))<-0.1
        a=sqrt(re2-(exp_mean**2))
      endif
      replace sd with sqrt(abs(re2-(exp_mean**2))) 
      replace var with sd/exp_mean 
      replace varw with n_case*var 
    else
      replace sd with -9.999
      replace varw with -9.999
      replace var with -9.999
    endif
    replace re2 with 0
  endif
enddo
if lc_tcas=0
	wait window nowait 'All expences are zero, expence based weights cannot be calculated'
	select drgdistr
	activate window anal
	browse in window anal save nowait
	do grpohje
	return
endif
goto top
replace varw with -9.9999

wait window nowait 'Phase 2: First trimming'
select anal
lc_tcas=0
lc_tmean=0
lc_re2=0
lc_n_anal=0
t_alku=val(sys(2))
goto top
do while not eof()
  lc_n_anal=lc_n_anal+1
  if 10000*int((lc_n_anal-1)/10000)=lc_n_anal-1 
     wait window 'First trimming: '+str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds, ';
     + str(lc_n_anal/(val(sys(2))-t_alku),5,0) +'/s, total mean '+ str(lc_tmean,6,1) nowait
  endif
  if anal.trimmed
    select anal
    skip
    loop
  endif
  select drgdistr
  seek substr(anal.drg,1,4)
  if anal.expences>exp_mean+3*sd or anal.expences<exp_mean-3*sd
    replace anal.trimmed with .t.
  else
    replace anal.trimmed with .f.
    lc_tmean=((lc_tcas*lc_tmean)+anal.expences)/(lc_tcas+1)
    lc_re2=((lc_tcas*lc_re2)+anal.expences**2)/(lc_tcas+1)
    lc_tcas=lc_tcas+1
    replace m1trim with ((n1trim*m1trim)+anal.expences)/(n1trim+1)
    replace re2 with ((n1trim*re2)+(anal.expences)**2)/(n1trim+1)
    replace n1trim with n1trim+1
  endif
  select anal
  skip
enddo
select drgdistr
goto top
replace m1trim with lc_tmean
replace n1trim with lc_tcas
replace re2 with lc_re2
do while not eof()
  skip
  if n1trim>0
    replace w1trim with m1trim/lc_tmean
  else
    replace w1trim with -9.999
    replace m1trim with -9.999
  endif
  if n1trim>2
    if (re2-(m1trim**2))<-0.1
      a=sqrt(re2-(m1trim**2))
    endif
    replace sd1trim with sqrt(abs(re2-(m1trim**2))) 
    replace var1 with sd1trim/m1trim 
    replace varw1 with n1trim*var1 
  else
    replace sd1trim with -9.999
    replace var1 with -9.999
    replace varw1 with -9.999
  endif
  replace re2 with 0
enddo
goto top
replace varw1 with -9.999

wait window nowait 'Phase 3: Second trimming'
select anal
lc_tcas=0
lc_tmean=0
lc_n_anal=0
lc_re2=0
t_alku=val(sys(2))
goto top
do while not eof()
  lc_n_anal=lc_n_anal+1
  if 10000*int((lc_n_anal-1)/10000)=lc_n_anal-1 
     wait window 'Second trimming: '+str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds, ';
     + str(lc_n_anal/(val(sys(2))-t_alku),5,0) +'/s, total mean '+ str(lc_tmean,6,1) nowait
  endif
  if anal.trimmed
    select anal
    skip
    loop
  endif
  select drgdistr
  seek substr(anal.drg,1,4)
  if anal.expences>m1trim+1.96*sd1trim or anal.expences<m1trim-1.96*sd1trim 
    replace anal.trimmed with .t.
  else
    lc_tmean=((lc_tcas*lc_tmean)+anal.expences)/(lc_tcas+1)
    lc_re2=((lc_tcas*lc_re2)+(anal.expences**2))/(lc_tcas+1)
    lc_tcas=lc_tcas+1
    replace m2trim with ((n2trim*m2trim)+anal.expences)/(n2trim+1)
    replace re2 with ((n2trim*re2)+(anal.expences)**2)/(n2trim+1)
    replace n2trim with n2trim+1
  endif
  select anal
  skip
enddo
select drgdistr
goto top
replace m2trim with lc_tmean
replace n2trim with lc_tcas
replace re2 with lc_re2
do while not eof()
  skip
  if n2trim>0
    replace w2trim with m2trim/lc_tmean
  else
    replace w2trim with -9.999
    replace m2trim with -9.999
  endif
  if n2trim>2
    if (re2-(m2trim**2))<-0.1
      a=sqrt(re2-(m2trim**2))
    endif
    replace sd2trim with sqrt(abs(re2-(m2trim**2))) 
    replace var2 with sd2trim/m2trim 
    replace varw2 with n2trim*var2
  else
    replace sd2trim with -9.999
    replace var2 with -9.999
    replace varw2 with -9.999
  endif
  replace re2 with 0
enddo
goto top
replace varw2 with -9.999

wait window nowait "Phase 4: If weights are to be inserted to database push F10"
p_grp=.f.
do grpohje
return