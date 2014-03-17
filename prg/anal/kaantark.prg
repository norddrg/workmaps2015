procedure kaantark
push key clear
lc_nk=1
lc_so=0
lc_tyh=0
lc_kier=.t.
do while lc_kier
  select anal
  lc_so=lc_so+1
  do case
  case lc_nk=1 and lc_so=1
    lc_dg=oir1
  case lc_nk=1 and lc_so=2
    lc_dg=syy1
  case lc_nk=2 and lc_so=1
    lc_dg=oir2
  case lc_nk=2 and lc_so=2
    lc_dg=syy2
  case lc_nk=3 and lc_so=1
    lc_dg=oir3
  case lc_nk=3 and lc_so=2
    lc_dg=syy3
  case lc_nk=4 and lc_so=1
    lc_dg=oir4
  case lc_nk=4 and lc_so=2
    lc_dg=syy4
  case lc_nk=5 and lc_so=1
    lc_dg=oir5
  case lc_nk=5 and lc_so=2
    lc_dg=syy5
  case lc_nk=6 and lc_so=1
    lc_dg=oir6
  case lc_nk=6 and lc_so=2
    lc_dg=syy6
  case lc_nk=7 and lc_so=1
    lc_dg=oir7
  case lc_nk=7 and lc_so=2
    lc_dg=syy7
  case lc_nk=8 and lc_so=1
    lc_dg=oir8
  case lc_nk=8 and lc_so=2
    lc_dg=syy8
  case lc_nk=9 and lc_so=1
    lc_dg=oir9
  case lc_nk=9 and lc_so=2
    lc_dg=syy9
  endcase
  if lc_dg<>' '
    lc_tyh=0
    select icd10to9
    set relation to icd9_cm into icd9cm_d
    select icd_10
    seek lc_dg
    browse fields code, d_code, who, icd10to9.icd9_cm, icd9cm_d.nimi_cm, icd10to9.icd9_cm2
    select icd10to9
    set relation to
    select icd_10
    if lastkey()=27
      exit
    endif
  endif
  if lc_dg=' '
    lc_tyh=lc_tyh+1
  endif
  if lc_so=2
    lc_nk=lc_nk+1
    lc_so=0
  endif
  if lc_tyh=2 
    lc_nk=1
    lc_so=0
  endif
enddo
select anal
do luokitus
pop key
return