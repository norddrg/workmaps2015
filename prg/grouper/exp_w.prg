Procedure exp_w
select drgdistr
replace all sd with 0, re2 with 0, weight with 0,; 
n1trim with 0, m1trim with 0, sd1trim with 0, re2_1tri with 0, w1trim with 0;
n2trim with 0, m2trim with 0, sd2trim with 0, re2_2tri with 0, w2trim with 0
goto top
lc_tcas=n_case
lc_tmean=exp_mean
if lc_tcas=0
	wait window nowait 'All expences are zero, expence based weights cannot be calculated'
	select drgdistr
	activate window anal
	browse in window anal save nowait
	do grpohje
	return
endif
replace all weight with exp_mean/lc_tmean for n_case>0

wait window nowait 'Phase 1: Calculation of untrimmed SDs'
select anal
goto top
lc_sd=0
lc_re2=0
lc_n_anal=0
t_alku=val(sys(2))
deactivate window anal
do while not eof()
  lc_n_anal=lc_n_anal+1
  if 10000*int((lc_n_anal-1)/10000)=lc_n_anal-1 
     wait window 'Phase 1: '+str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds, ';
     + str(lc_n_anal/(val(sys(2))-t_alku),5,0) +'/s, total SD '+ str(lc_sd,5,1) nowait
  endif
  if anal.expences>0
    replace anal.trimmed with .f.
    select drgdistr
    seek substr(anal.drg,1,4)
    replace anal.exp_w with drgdistr.weight
    if n_case>1
      replace re2 with (((n_case-1)*re2)+((anal.expences - exp_mean)**2))/(n_case-1)
    endif
    lc_re2=(((lc_tcas)*lc_re2)+((anal.expences - lc_tmean)**2))/(lc_tcas-1)
  else
    replace anal.trimmed with .t.
  endif
  select anal
  skip
enddo
select drgdistr
goto top
replace re2 with lc_re2
replace all sd with sqrt(re2)

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
     wait window 'Phase 2: '+str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds, ';
     + str(lc_n_anal/(val(sys(2))-t_alku),5,0) +'/s, total mean '+ str(lc_tmean,6,1) nowait
  endif
  if anal.trimmed
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
    lc_tcas=lc_tcas+1
    replace m1trim with ((n1trim*m1trim)+anal.expences)/(n1trim+1)
    replace n1trim with n1trim+1
  endif
  select anal
  skip
enddo
select drgdistr
goto top
replace m1trim with lc_tmean
replace n1trim with lc_tcas
replace all w1trim with m1trim/lc_tmean

wait window nowait "Phase 3: Calculating SD's after first trimming"
select anal
lc_sd=0
lc_re2=0
lc_n_anal=0
t_alku=val(sys(2))
goto top
do while not eof()
  lc_n_anal=lc_n_anal+1
  if 10000*int((lc_n_anal-1)/10000)=lc_n_anal-1 
     wait window 'Phase 3: '+str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds, ';
     + str(lc_n_anal/(val(sys(2))-t_alku),5,0) +'/s, total SD '+ str(lc_sd,5,1) nowait
  endif
  if not trimmed
    select drgdistr
    seek substr(anal.drg,1,4)
    if n1trim>1
      replace re2_1tri with (((n1trim-1)*re2_1tri)+((anal.expences - drgdistr.m1trim)**2))/(n1trim-1)
    endif
    lc_re2=(((lc_tcas-1)*lc_re2)+(anal.expences - lc_tmean)**2)/(lc_tcas-1)
  endif
  select anal
  skip
enddo
select drgdistr
goto top
replace re2_1tri with lc_re2
replace all sd1trim with sqrt(re2_1tri)

wait window nowait 'Phase 4: Second trimming'
select anal
lc_tcas=0
lc_tmean=0
lc_n_anal=0
t_alku=val(sys(2))
goto top
do while not eof()
  lc_n_anal=lc_n_anal+1
  if 10000*int((lc_n_anal-1)/10000)=lc_n_anal-1 
     wait window 'Phase 4: '+str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds, ';
     + str(lc_n_anal/(val(sys(2))-t_alku),5,0) +'/s, total mean '+ str(lc_tmean,6,1) nowait
  endif
  select drgdistr
  seek substr(anal.drg,1,4)
  if anal.expences>m1trim+1.96*sd1trim or anal.expences<m1trim-1.96*sd1trim 
    replace anal.trimmed with .t.
  else
    lc_tmean=((lc_tcas*lc_tmean)+anal.expences)/(lc_tcas+1)
    lc_tcas=lc_tcas+1
    replace m2trim with ((n2trim*m2trim)+anal.expences)/(n2trim+1)
    replace n2trim with n2trim+1
  endif
  select anal
  skip
enddo
select drgdistr
goto top
replace m2trim with lc_tmean
replace n2trim with lc_tcas
replace all w2trim with m2trim/lc_tmean

wait window nowait "Phase 5: Calculating SD's after second trimming"
select anal
lc_sd=0
lc_re2=0
lc_n_anal=0
t_alku=val(sys(2))
goto top
do while not eof()
  lc_n_anal=lc_n_anal+1
  if 10000*int((lc_n_anal-1)/10000)=lc_n_anal-1 
     wait window 'Phase 5: '+ str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds, ';
     + str(lc_n_anal/(val(sys(2))-t_alku),5,0) +'/s, total SD '+ str(lc_sd,5,1) nowait
  endif
  select drgdistr
  seek substr(anal.drg,1,4)
  replace anal.exp_tw with drgdistr.w2trim
  if not anal.trimmed
    if n2trim>1
      replace re2_2tri with (((n2trim-1)*re2_2tri)+((anal.expences - m2trim)**2))/(n2trim-1)
    endif
    lc_re2=(((lc_tcas-1)*lc_re2)+(anal.expences - lc_tmean)**2)/(lc_tcas-1)
  endif
  select anal
  skip
enddo
select drgdistr
goto top
replace re2_2tri with lc_re2
replace all sd2trim with sqrt(re2_2tri)

do grpohje
return