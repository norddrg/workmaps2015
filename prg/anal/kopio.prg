Procedure kopio
push key clear
select anal
do luokitus
do analnayt
select anal
lc_id=id
lc_recno=recno()
lc_ika=ika
lc_sex=sex
lc_death=death
lc_dur=dur
lc_rem=rem
lc_lama=lama
lc_icu=icu
lc_oir1=oir1
lc_oir2=oir2
lc_oir3=oir3
lc_oir4=oir4
lc_oir5=oir5
lc_oir6=oir6
lc_oir7=oir7
lc_oir8=oir8
lc_oir9=oir9
lc_syy1=syy1
lc_syy2=syy2
lc_syy3=syy3
lc_syy4=syy4
lc_syy5=syy5
lc_syy6=syy6
lc_syy7=syy7
lc_syy8=syy8
lc_syy9=syy9
lc_tp1=tp1
lc_tp2=tp2
lc_tp3=tp3
lc_tp4=tp4
lc_tp5=tp5
lc_tp6=tp6
lc_tp7=tp7
lc_tp8=tp8
lc_tp9=tp9
p_ldg=oir1
p_ltp=tp1
p_ldrg=drg
ko_oir1=oir1
ko_oir2=oir2
ko_oir3=oir3
ko_oir4=oir4
ko_syy1=syy1
ko_syy2=syy2
ko_syy3=syy3
ko_syy4=syy4
ko_tp1=tp1
ko_tp2=tp2
ko_tp3=tp3
ko_tp4=tp4
ko_drg=drg
ko_ika=ika
ko_dur=dur
lc_was=.f.
lc_order =order ()
set order to id
goto bottom
lc_newid= val(substr(id,5,10))+1

do kasittel

select anal
set order to oir1
seek lc_oir1+lc_tp1
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
lc_oir1=oir1 and lc_syy1=syy1 and lc_oir2=oir2 and lc_syy2=syy2 and lc_oir3=oir3 and lc_syy3=syy3 and lc_oir4=oir4 and;
lc_syy4=syy4 and lc_oir5=oir5 and lc_syy5=syy5 and lc_oir6=oir6 and lc_syy6=syy6 and lc_oir7=oir7 and;
lc_syy7=syy7 and lc_oir8=oir8 and lc_syy8=syy8 and lc_oir9=oir9 and lc_syy9=syy9 and;
lc_tp1=tp1 and lc_tp2=tp2 and lc_tp3=tp3 and lc_tp4=tp4 and lc_tp5=tp5 and lc_tp6=tp6 and;
lc_tp7=tp7 and lc_tp8=tp8 and lc_tp9=tp9
   wait window 'This case was already in the database'
   lc_was=.t.
else
  insert into anal (ika, sex, death, lama, rem, dur, icu, oir1, syy1, oir2, syy2, oir3, syy3,;
  oir4, syy4, oir5, syy5, oir6, syy6, oir7, syy7, oir8, syy8, oir9, syy9,;
  tp1, tp2, tp3, tp4, tp5, tp6, tp7, tp8, tp9) values (lc_ika, lc_sex,;
  lc_death, lc_death, lc_rem, lc_dur, lc_icu, lc_oir1, lc_syy1, lc_oir2, lc_syy2, lc_oir3, lc_syy3, lc_oir4,;
  lc_syy4, lc_oir5, lc_syy5, lc_oir6, lc_syy6, lc_oir7, lc_syy7, lc_oir8,;
  lc_syy8, lc_oir9, lc_syy9, lc_tp1, lc_tp2, lc_tp3, lc_tp4, lc_tp5, lc_tp6,;
  lc_tp7, lc_tp8, lc_tp9)
  replace comment with 'Copy of '+lc_id
  if at('ALLRULES',dbf())>0
    replace id with 'TEST'+str(lc_newid,6)
  endif
endif
do luokitus
do analnayt
wait window 'Return to the original line? (y)es/(N)o'
if (lastkey()=89 or lastkey()=121)
  select anal
  set order to oir1
  seek ko_oir1+ko_tp1
  do while not eof()
    if lc_recno=recno()
      exit
    endif
    skip
  enddo
endif
select anal
set order to (lc_order)
do analnayt
return