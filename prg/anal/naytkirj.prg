Procedure naytkirj
activate window anal
clear
do case
case lc_sex='F' or lc_sex='2'
  @ 0,1 say 'Female'
case lc_sex='M' or lc_sex='1'
  @ 0,1 say 'Male'
otherwise
  @ 0,1 say 'Unknown sex'
endcase
if lc_ika>2*365
  @ 0,15 say str(int(lc_ika/365.24))+ ' yrs'
else
  @ 0,15 say str(lc_ika,3)+ ' days'
endif

@1,1 say 'Duration of treatment :'+str(lc_dur,3)+' day(s)'
if lc_death 
  @ 1,40 say 'Death during this period'
endif
if lc_lama
  @ 1,40 say 'Left against medical advice'
endif
if lc_rem
  @ 1,40 say 'Remitted to other hospital'
endif
if not lc_death and not lc_lama and not lc_rem
  @ 1,40 say 'Discharged normally'
endif

do case
case lc_icu='N'
  @ 2,1 say 'Treated in NICU'
case lc_icu='B'
  @ 2,1 say 'Treated in ICU for burns'
otherwise 
  @ 2,1 say 'No ICU treatment'
endcase 

@ 3,1 say lc_oir1
@ 3,8 say lc_syy1
do dgnim with lc_oir1, lc_syy1, 3
@ 4,1 say lc_oir2
@ 4,8 say lc_syy2
do dgnim with lc_oir2, lc_syy2, 4
@ 5,1 say lc_oir3
@ 5,8 say lc_syy3
do dgnim with lc_oir3, lc_syy3, 5
@ 6,1 say lc_oir4
@ 6,8 say lc_syy4
do dgnim with lc_oir4, lc_syy4, 6
@ 7,1 say lc_oir5
@ 7,8 say lc_syy5
do dgnim with lc_oir5, lc_syy5, 7
@ 8,1 say lc_oir6
@ 8,8 say lc_syy6
do dgnim with lc_oir6, lc_syy6, 8
@ 9,1 say lc_oir7
@ 9,8 say lc_syy7
do dgnim with lc_oir7, lc_syy7, 9
@10,1 say lc_oir8
@10,8 say lc_syy8
do dgnim with lc_oir8, lc_syy8, 10
@11,1 say lc_oir9
@11,8 say lc_syy9
do dgnim with lc_oir9, lc_syy9, 11
@ 3,70 say lc_tp1
do tpnim with lc_tp1, 3
@ 4,70 say lc_tp2
do tpnim with lc_tp2, 4
@ 5,70 say lc_tp3
do tpnim with lc_tp3, 5
@ 6,70 say lc_tp4
do tpnim with lc_tp4, 6
@ 7,70 say lc_tp5
do tpnim with lc_tp5, 7
@ 8,70 say lc_tp6
do tpnim with lc_tp6, 8
@ 9,70 say lc_tp7
do tpnim with lc_tp7, 9
@10,70 say lc_tp8
do tpnim with lc_tp8, 10
@11,70 say lc_tp9
do tpnim with lc_tp9, 11
return

procedure dgnim
parameters dgn_oir, dgn_syy, dgn_rivi
if dgn_oir=space(6)
  @ dgn_rivi,15 say '-'
  return
endif
select icd_10
lc_corrdg=.t.
seek upper(dgn_oir)
if found()
  dgn_nimi=text
else
  dgn_nimi='???'
  lc_corrdg=.f.
endif
if ast='*'
  @ dgn_rivi,7 say '*'
  if dgn_syy=' '
    dgn_nimi=substr(dgn_nimi,1,30)+'; ???'
  else
   seek upper(dgn_oir+dgn_syy)
   if found()
     dgn_nimi=text
   else
     seek upper(dgn_syy)
     if found()
        dgn_nimi=substr(dgn_nimi,1,30)+'; '+text
     else
        dgn_nimi=substr(dgn_nimi,1,30)+'; ???'
     endif
   endif
  endif
endif
@ dgn_rivi,15 say substr(dgn_nimi,1,50)
select anal
return

procedure tpnim
parameters tpn_tp, tpn_rivi
if tpn_tp=space(5)
  @ tpn_rivi,80 say '-'
  return
endif
select csp
SET ORDER TO code
seek trim(tpn_tp)
if NOT found()
  SET ORDER TO ncsp
  SEEK tpn_tp
endif
if found()  
  tpn_nimi=text
ELSE
  tpn_nimi='???'
  lc_corrtp=.f.
endif
@ tpn_rivi, 80 say substr(tpn_nimi,1,50)
select anal
return
