Procedure lisays
push key clear
select anal
lc_ika=0
lc_sex=' '
lc_death=.f.
lc_dur=0
lc_rem=.f.
lc_lama=.f.
lc_icu=' '
lc_oir1=Space (7)
lc_oir2=Space (7)
lc_oir3=Space (7)
lc_oir4=Space (7)
lc_oir5=Space (7)
lc_oir6=Space (7)
lc_oir7=Space (7)
lc_oir8=Space (7)
lc_oir9=Space (7)
lc_syy1=Space (7)
lc_syy2=Space (7)
lc_syy3=Space (7)
lc_syy4=Space (7)
lc_syy5=Space (7)
lc_syy6=Space (7)
lc_syy7=Space (7)
lc_syy8=Space (7)
lc_syy9=Space (7)
lc_tp1=Space (7)
lc_tp2=Space (7)
lc_tp3=Space (7)
lc_tp4=Space (7)
lc_tp5=Space (7)
lc_tp6=Space (7)
lc_tp7=Space (7)
lc_tp8=Space (7)
lc_tp9=Space (7)
do kasittel
if lastkey()=27
  return
endif
select anal
lc_order =order ()
set order to oir1
seek oir1+tp1
do while oir1=lc_oir1 and tp1=lc_tp1 and not eof()
  if ika=lc_ika and sex=lc_sex and lc_death=death and lc_lama=lama and lc_rem=rem and lc_dur=dur and;
  lc_syy1=syy1 and lc_oir2=oir2 and lc_syy2=syy2 and lc_oir3=oir3 and lc_syy3=syy3 and lc_oir4=oir4 and;
  lc_syy4=syy4 and lc_oir5=oir5 and lc_syy5=syy5 and lc_oir6=oir6 and lc_syy6=syy6 and lc_oir7=oir7 and;
  lc_syy7=syy7 and lc_oir8=oir8 and lc_syy8=syy8 and lc_oir9=oir9 and lc_syy9=syy9 and;
  lc_tp1=tp1 and lc_tp2=tp2 and lc_tp3=tp3 and lc_tp4=tp4 and lc_tp5=tp5 and lc_tp6=tp6 and;
  lc_tp7=tp7 and lc_tp8=tp8 and lc_tp9=tp9
    exit
  endif
  skip
enddo
if ika=lc_ika and sex=lc_sex and lc_death=death and lc_lama=lama and lc_rem=rem and lc_dur=dur and;
lc_syy1=syy1 and lc_oir2=oir2 and lc_syy2=syy2 and lc_oir3=oir3 and lc_syy3=syy3 and lc_oir4=oir4 and;
lc_syy4=syy4 and lc_oir5=oir5 and lc_syy5=syy5 and lc_oir6=oir6 and lc_syy6=syy6 and lc_oir7=oir7 and;
lc_syy7=syy7 and lc_oir8=oir8 and lc_syy8=syy8 and lc_oir9=oir9 and lc_syy9=syy9 and;
lc_tp1=tp1 and lc_tp2=tp2 and lc_tp3=tp3 and lc_tp4=tp4 and lc_tp5=tp5 and lc_tp6=tp6 and;
lc_tp7=tp7 and lc_tp8=tp8 and lc_tp9=tp9
   wait window 'This case was already in the database'
else
  insert into anal (ika, sex, death, lama, rem, dur, icu, oir1, syy1, oir2, syy2, oir3, syy3,;
  oir4, syy4, oir5, syy5, oir6, syy6, oir7, syy7, oir8, syy8, oir9, syy9,;
  tp1, tp2, tp3, tp4, tp5, tp6, tp7, tp8, tp9) values (lc_ika, lc_sex,;
  lc_death, lc_death, lc_rem, lc_dur, lc_icu, lc_oir1, lc_syy1, lc_oir2, lc_syy2, lc_oir3, lc_syy3, lc_oir4,;
  lc_syy4, lc_oir5, lc_syy5, lc_oir6, lc_syy6, lc_oir7, lc_syy7, lc_oir8,;
  lc_syy8, lc_oir9, lc_syy9, lc_tp1, lc_tp2, lc_tp3, lc_tp4, lc_tp5, lc_tp6,;
  lc_tp7, lc_tp8, lc_tp9)
  if at('ALLRULES',dbf())>0
    replace id with 'TEST'+str(recno(),6)
  endif
endif
do luokitus
do analnayt
return