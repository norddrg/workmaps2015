Procedure luokitus
*Assignment of one case to a DRG

public lc_sec, lc_first
lc_sec=.f.
lc_first=.t.
on key label f5
on key label ctrl+f5
public apuarr, apu_n
release apuarr
public apuarr, apu_n
dimension apuarr(1,3)
store space(5) to apuarr(1,1) 
store space(5) to apuarr(1,2)
store space(5) to apuarr(1,3)
apu_n=1

if not p_logluku
  do ..\common\logluku
endif

*Correct dx-list
select anal
anal_or = '0'
anal_kompl = '0'
do while (oir1=' ' and oir2<>' ') or (oir2=' ' and oir3<>' ') or (oir3=' ' and oir4<>' ') or (oir4=' ' and oir5<>' ') or (oir5=' ' and oir6<>' ') or (oir6=' ' and oir7<>' ') or (oir7=' ' and oir8<>' ') or (oir8=' ' and oir9<>' ')
  if oir1=' ' 
    replace oir1 with oir2, oir2 with oir3, oir3 with oir4, oir4 with oir5, oir5 with oir6, oir6 with oir7, oir7 with oir8, oir8 with oir9, oir9 with ' '
    replace syy1 with syy2, syy2 with syy3, syy3 with syy4, syy4 with syy5, syy5 with syy6, syy6 with syy7, syy7 with syy8, syy8 with syy9, syy9 with ' '
    loop
  endif
  if oir2=' ' 
    replace oir2 with oir3, oir3 with oir4, oir4 with oir5, oir5 with oir6, oir6 with oir7, oir7 with oir8, oir8 with oir9, oir9 with ' '
    replace syy2 with syy3, syy3 with syy4, syy4 with syy5, syy5 with syy6, syy6 with syy7, syy7 with syy8, syy8 with syy9, syy9 with ' '
    loop
  endif
  if oir3=' ' 
    replace oir3 with oir4, oir4 with oir5, oir5 with oir6, oir6 with oir7, oir7 with oir8, oir8 with oir9, oir9 with ' '
    replace syy3 with syy4, syy4 with syy5, syy5 with syy6, syy6 with syy7, syy7 with syy8, syy8 with syy9, syy9 with ' '
    loop
  endif
  if oir4=' ' 
    replace oir4 with oir5, oir5 with oir6, oir6 with oir7, oir7 with oir8, oir8 with oir9, oir9 with ' '
    replace syy4 with syy5, syy5 with syy6, syy6 with syy7, syy7 with syy8, syy8 with syy9, syy9 with ' '
    loop
  endif
  if oir5=' ' 
    replace oir5 with oir6, oir6 with oir7, oir7 with oir8, oir8 with oir9, oir9 with ' '
    replace syy5 with syy6, syy6 with syy7, syy7 with syy8, syy8 with syy9, syy9 with ' '
    loop
  endif
  if oir6=' ' 
    replace oir6 with oir7, oir7 with oir8, oir8 with oir9, oir9 with ' '
    replace syy6 with syy7, syy7 with syy8, syy8 with syy9, syy9 with ' '
    loop
  endif
  if oir7=' ' 
    replace oir7 with oir8, oir8 with oir9, oir9 with ' '
    replace syy7 with syy8, syy8 with syy9, syy9 with ' '
    loop
  endif
  if oir8=' ' 
    replace oir8 with oir9, oir9 with ' '
    replace syy8 with syy9, syy9 with ' '
    loop
  endif
enddo
lc_tp_a=1
lc_tp_a2=1
lc_tpmax=31
lc_tyh=.f.

dimension tparr (50,1)
do while lc_tp_a<lc_tpmax
  on error do notpomin
  lc_tpomin=.t.
  do case
  case lc_tp_a=1
    if tp1<>' '
      tparr(lc_tp_a2,1)= tp1
      lc_tp_a2=lc_tp_a2+1
    endif
  case lc_tp_a=2
    if tp2<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp2
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=3
    if tp3<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp3
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=4
    if tp4<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp4
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=5
    if tp5<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp5
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=6
    if tp6<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp6
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=7
    if tp7<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp7
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=8
    if tp8<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp8
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=9
    if tp9<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp9
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=10
    if tp10<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp10
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=11
    if tp11<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp11
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=12
    if tp12<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp12
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=13
    if tp13<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp13
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=14
    if tp14<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp14
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=15
    if tp15<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp15
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=16
    if tp16<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp16
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=17
    if tp17<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp17
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=18
    if tp18<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp18
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=19
    if tp19<>' '
      tparr(lc_tp_a2,1)= tp19
      lc_tp_a2=lc_tp_a2+1
    endif
  case lc_tp_a=20
    if tp20<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp20
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=21
    if tp21<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp21
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=22
    if tp22<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp22
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=23
    if tp23<>' '
      tparr(lc_tp_a2,1)= tp23
      lc_tp_a2=lc_tp_a2+1
    endif
  case lc_tp_a=24
    if tp24<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp24
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=25
    if tp25<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp25
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=26
    if tp26<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp26
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=27
    if tp27<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp27
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=28
    if tp28<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp28
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=29
    if tp29<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp29
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_tp_a=30
    if tp30<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= tp30
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  endcase
  lc_tp_a=lc_tp_a+1
enddo

lc_rtg_a=1
do while lc_rtgomin and lc_rtg_a<21
  lc_tpomin=.t.
  do case
  case lc_rtg_a=1
    if rtg1<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg1
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=2
    if rtg2<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg2
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=3
    if rtg3<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg3
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=4
    if rtg4<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg4
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=5
    if rtg5<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg5
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=6
    if rtg6<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg6
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=7
    if rtg7<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg7
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=8
    if rtg8<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg8
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=9
    if rtg9<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg9
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=10
    if rtg10<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg10
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=11
    if rtg11<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg11
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=12
    if rtg12<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg12
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=13
    if rtg13<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg13
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=14
    if rtg14<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg14
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=15
    if rtg15<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg15
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=16
    if rtg16<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg16
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=17
    if rtg17<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg17
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=18
    if rtg18<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg18
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=19
    if rtg19<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg19
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  case lc_rtg_a=20
    if rtg20<>' '
      if lc_tpomin
        tparr(lc_tp_a2,1)= rtg20
        lc_tp_a2=lc_tp_a2+1
      endif
    endif
  endcase
lc_rtg_a=lc_rtg_a+1
enddo
on error
select dg
set filter to valid 
luok_oir=substr(anal.oir1,1,6)
luok_syy=substr(anal.syy1,1,6)

if p_allrules
  if luok_oir<>' '
    select icd_10
    set order to code
    seek upper(luok_oir)
    if not found()
      set order to code_w
      seek upper(luok_oir)
      if found()
        luok_oir=code
      endif
      set order to code
    endif
  endif
  if luok_syy<>' '
    seek upper(luok_syy)
    if not found()
      set order to code_w
      seek upper(luok_syy)
      if found()
        luok_syy=code
      endif
      set order to code
    endif
  endif
endif

select dg
set order to code
if luok_oir<>' '
  seek upper(luok_oir)
endif
if found() and luok_syy<>' '
  seek upper(luok_syy)
endif
if found() and luok_oir<>' ' 
  if not anal.icd
    select anal
    replace anal.icd with .t.
  endif
else
  if anal.icd
    select anal
    replace anal.icd with .f.
  endif
endif

select dg

seek upper(luok_oir+luok_syy)+'DGCAT'
if not found()
  seek upper(luok_oir)+space(6)+'DGCAT'
  if not found()
    seek upper(luok_oir)
  endif
endif
if not found()
  lc_dgkat=space(5)
  if anal.icd
    replace anal.icd with .f.
  endif
else
  lc_dgkat=dg.varval
endif
if substr(lc_dgkat,1,2)='98'
  if anal.sex='F' or anal.sex='2'
    lc_dgkat='13'+substr(lc_dgkat,3,3)
  else
    lc_dgkat='12'+substr(lc_dgkat,3,3)
  endif
endif
select anal
if anal.dgkat<>lc_dgkat
  replace anal.mdc with substr(lc_dgkat,1,2)
  replace anal.dgkat with lc_dgkat
endif

select dg
lc_loop=.t.
lc_vaihe=' '

do while lc_loop
  if lc_vaihe=' '
    seek upper(luok_oir)
    if found()
      lc_vaihe='A'
    else
      lc_vaihe='B'
    endif
  endif
  * A - searching for manifestation code in DG
  * B - looking for existance of etiological code in ANAL
  if lc_vaihe='B' 
    if luok_syy='  '
      exit
    endif
    seek upper(luok_syy)
    if found()
      lc_vaihe='C'
    else
      lc_vaihe='D'
    endif
  endif
  * C - searching for etiological code in DG
  * D - searching for code pair in DG
  if lc_vaihe='D'
    seek upper(luok_oir+luok_syy)
    if found()
      lc_vaihe='E'
    else
      exit
    endif
  endif
  * E - code pair found in DG
  if dg.vartype='PDGPRO' or dg.vartype='DGPROP' or dg.vartype='PROCPR'
    do arrlis with dg.vartype, dg.varval
  endif
  if dg.vartype='OR'
  	if dg.varval='2' and anal_or='0' 
  		anal_or = '2'
  	endif
    if dg.varval='1' 
      anal_or = '1'
    endif
  endif
  select dg
  if eof()
    exit
  endif
  skip
  dg_code=code
  dg_dcode=d_code
  do case
  case lc_vaihe='A'
    if upper(dg_code)<>upper(luok_oir) or dg_dcode<>' '
      if luok_syy<>' '
        lc_vaihe='B'
      else
        exit
      endif
    endif
  case lc_vaihe='C'
    if upper(dg_code)<>upper(luok_syy) or dg_dcode<>' '
      lc_vaihe='D'
    endif
  case lc_vaihe='E'
    if upper(dg_code)<>upper(luok_oir) or upper(dg_dcode)<>upper(luok_syy)
      exit
    endif
  endcase
enddo

*Collect dx properities
select anal
if oir2<>' '
  if not (oir2=oir1 and syy2=syy1)
    do omin with oir2, syy2
  endif
  select anal
  if oir3<>' '
    if not (oir3=oir1 and syy3=syy1)
      do omin with oir3, syy3
    endif
    select anal
    if oir4<>' '
      if not (oir4=oir1 and syy4=syy1)
        do omin with oir4, syy4
      endif
      select anal
      if oir5<>' '
        if not (oir5=oir1 and syy5=syy1)
          do omin with oir5, syy5
        endif
        select anal
        if oir6<>' '
          if not (oir6=oir1 and syy6=syy1)
            do omin with oir6, syy6
          endif
          select anal
          if oir7<>' '
            if not (oir7=oir1 and syy7=syy1)
              do omin with oir7, syy7
            endif
            select anal
            if oir8<>' '
              if not (oir8=oir1 and syy8=syy1)
                do omin with oir8, syy8
              endif
              select anal
              if oir9<>' '
                if not (oir9=oir1 and syy9=syy1)
                  do omin with oir9, syy9
                endif
              endif
            endif
          endif
        endif
      endif
    endif
  endif
endif
select anal
lc_tp_a=1
* defining properties of procedures
do while lc_tp_a<lc_tp_a2
  if lc_tp_a>1 
    lc_first=.f.
  endif
  do tpomin with tparr(lc_tp_a,1)
  lc_tp_a=lc_tp_a+1
enddo

lc_n=1
lc_tpom=''
lc_dgom=''
lc_pdgom=''
lc_komp=''
do while lc_n<apu_n
  if substr(apuarr(lc_n,1),3,1)='X'
    lc_dgom=lc_dgom+' '+apuarr(lc_n,1)
  endif
  if substr(apuarr(lc_n,1),3,1)='S' or substr(apuarr(lc_n,1),3,1)='E';
  or substr(apuarr(lc_n,1),3,1)='O' or substr(apuarr(lc_n,1),3,1)='F';
  or substr(apuarr(lc_n,1),3,1)='T' or substr(apuarr(lc_n,1),3,1)='V' OR substr(apuarr(lc_n,1),3,1)='D'
    lc_tpom=lc_tpom+' '+apuarr(lc_n,1)
  endif
  if substr(apuarr(lc_n,1),3,1)='P'
    if len(lc_pdgom)>0
      lc_pdgom=lc_pdgom+' '+apuarr(lc_n,1)
    else
      lc_pdgom=apuarr(lc_n,1)
    endif
  endif
  if substr(apuarr(lc_n,1),3,1)='C' or substr(apuarr(lc_n,1),3,1)='I'
    lc_komp=lc_komp+' '+trim(apuarr(lc_n,1))
  endif
  lc_n=lc_n+1
enddo

select anal
if trim(anal.tpomin)<>trim(lc_tpom) or trim(lc_tpom)<>trim(anal.tpomin)
  replace anal.tpomin with lc_tpom
endif  
if trim(anal.dgomin)<>trim(lc_dgom) or trim(lc_dgom)<>trim(anal.dgomin)
  replace anal.dgomin with lc_dgom
endif
if trim(anal.pdgomin)<>trim(lc_pdgom) or trim(lc_pdgom)<>trim(anal.pdgomin)
  replace anal.pdgomin with lc_pdgom
endif
if trim(anal.kompkat)<>trim(lc_komp) or trim(lc_komp)<>trim(anal.kompkat)
  replace anal.kompkat with lc_komp
endif

lc_n=1
if anal_kompl<'2'
 lc_cc='0'
 do while lc_n<apu_n
  if substr(apuarr(lc_n,1),3,1)='I' or substr(apuarr(lc_n,1),3,1)='C' OR substr(apuarr(lc_n,1),3,1)='F'
    * The case is potentially complicated
    lc_cc='1'
    if substr(apuarr(lc_n,1),3,1)='I'
      * If activating property does not exist the CC-property is inactivated
      lc_n2=1
      lc_cc='0'
      do while lc_n2<apu_n
        if apuarr(lc_n,2)=apuarr(lc_n2,1) or apuarr(lc_n,3)=apuarr(lc_n2,1)
          lc_cc='1'
          exit
        endif
        lc_n2=lc_n2+1
      enddo
    ENDIF
    IF substr(apuarr(lc_n,1),3,1)='F'
      lc_cc='2'
    ENDIF 
    * testing of exclusions for the COMPL-category at issue
    if lc_cc>'0'
      select komplex
      seek trim(substr(apuarr(lc_n,1),1,2)+substr(apuarr(lc_n,1),4,2)+upper(luok_oir+luok_syy))
      if trim(substr(apuarr(lc_n,1),1,2)+substr(apuarr(lc_n,1),4,2)+upper(luok_oir+luok_syy)) = SUBSTR(compl,1,2)+SUBSTR(compl,4,2)+upper(code+d_code)
        * Combination of manifestation code and etiological code is on exclusion list, CC-property not activated
        lc_n=lc_n+1
        loop
      endif
      seek substr(apuarr(lc_n,1),1,2)+substr(apuarr(lc_n,1),4,2)+upper(luok_oir)
      if found() and komplex.d_code=' '
        * Manifestation code is on exclusion list of the COMPL-category, CC-property is not activated
        lc_n=lc_n+1
        loop
      endif
      if luok_syy<>space(6)
        seek substr(apuarr(lc_n,1),1,2)+substr(apuarr(lc_n,1),4,2)+upper(luok_syy)
        if found()
          * Etiological code is on exclusion list of COMPL-category, CC-property is not activated
          lc_n=lc_n+1
          loop
        endif
      endif
      * True CC-case, information is stored to file
      select anal
      anal_kompl=lc_cc
      exit
    endif
  endif
  lc_n=lc_n+1
 enddo
endif
if anal.kompl <> anal_kompl
  replace anal.kompl with anal_kompl
endif

if anal.or<>anal_or
  replace anal.or with anal_or
endif

lcn_log=0
lcn_mdc=1
lcn_pdgprop=1
lcn_or=1

*DRG assigment

do while lcn_log<n_log
  lcn_log=lcn_log+1
  if icd_arr(lcn_log,1)='-'
    if anal.icd
      loop
    endif
  endif
  if icd_arr(lcn_log,1)='+'
    if not anal.icd
      loop
    endif
  endif
  if mdc_arr(lcn_log,1)<>' '
    if mdc_arr(lcn_log,1)<>anal.mdc
      if icd_arr(lcn_log,1)<>'-'
        lcn_pdgprop=1
        lcn_or=1
        lcn_mdc=lcn_mdc+1
        lcn_log=log_rivi(lcn_mdc, 10*lcn_pdgprop+lcn_or)-1
      endif
      loop
    endif
  endif
  if pdgprop_arr(lcn_log,1)<>' '
    lc_n=1
    do while lc_n<apu_n
      if apuarr(lc_n,1)>=pdgprop_arr(lcn_log,1)
        exit
      endif
      lc_n=lc_n+1
    enddo
    if not apuarr(lc_n,1)=pdgprop_arr (lcn_log,1)
      if icd_arr(lcn_log,1)<>'-'
        lcn_or=1
        lcn_pdgprop=lcn_pdgprop+1
        if lcn_pdgprop> max_pdgprop (lcn_mdc,1)
          lcn_pdgprop=1
          lcn_mdc=lcn_mdc+1
        endif
        lcn_log=log_rivi(lcn_mdc, 10*lcn_pdgprop+lcn_or)-1
      endif
      loop
    endif
  endif
  if or_arr(lcn_log,1)='S' and not anal_or='1'
    if icd_arr(lcn_log,1)<>'-'
      lcn_or=lcn_or+1
      if lcn_or > max_or(lcn_mdc,lcn_pdgprop)
        lcn_or=1
        lcn_pdgprop=lcn_pdgprop+1
        if lcn_pdgprop> max_pdgprop (lcn_mdc,1)
          lcn_pdgprop=1
          lcn_mdc=lcn_mdc+1
        endif
      endif
      lcn_log=log_rivi(lcn_mdc, 10*lcn_pdgprop+lcn_or)-1
    endif
    loop
  endif
  if or_arr(lcn_log,1)='P' and not(anal_or='1' or anal_or='2')
    if icd_arr(lcn_log,1)<>'-'
      lcn_or=lcn_or+1
      if lcn_or > max_or(lcn_mdc,lcn_pdgprop)
        lcn_or=1
        lcn_pdgprop=lcn_pdgprop+1
        if lcn_pdgprop> max_pdgprop (lcn_mdc,1)
          lcn_pdgprop=1
          lcn_mdc=lcn_mdc+1
        endif
      endif
      lcn_log=log_rivi(lcn_mdc, 10*lcn_pdgprop+lcn_or)-1
    endif
    loop
  endif
  if or_arr(lcn_log,1)='N' and anal_or='1'
    if icd_arr(lcn_log,1)<>'-'
      lcn_or=lcn_or+1
      if lcn_or > max_or(lcn_mdc,lcn_pdgprop)
        lcn_or=1
        lcn_pdgprop=lcn_pdgprop+1
        if lcn_pdgprop> max_pdgprop (lcn_mdc,1)
          lcn_pdgprop=1
          lcn_mdc=lcn_mdc+1
        endif
      endif
      lcn_log=log_rivi(lcn_mdc, 10*lcn_pdgprop+lcn_or)-1
    endif
    loop
  endif
  if or_arr(lcn_log,1)='Z' and anal_or<>'0'
    if icd_arr(lcn_log,1)<>'-'
      lcn_or=lcn_or+1
      if lcn_or > max_or(lcn_mdc,lcn_pdgprop)
        lcn_or=1
        lcn_pdgprop=lcn_pdgprop+1
        if lcn_pdgprop> max_pdgprop (lcn_mdc,1)
          lcn_pdgprop=1
          lcn_mdc=lcn_mdc+1
        endif
      endif
      lcn_log=log_rivi(lcn_mdc, 10*lcn_pdgprop+lcn_or)-1
    endif
    loop
  endif
  
  do case
  case procpro_arr(lcn_log,1)='+' 
    if not anal_or>'0'
      loop
    endif
  case len(trim(procpro_arr(lcn_log,1)))>1
    lc_n=1
    lc_loyd=.f.
    do while lc_n<apu_n
      if procpro_arr(lcn_log,1)='99O99' and apuarr(lc_n,1)='99O' 
        lc_loyd=.t.
        exit
      endif
      if procpro_arr(lcn_log,1)<= apuarr(lc_n,1)
         if(apuarr(lc_n,1)) = trim(procpro_arr(lcn_log,1))
           lc_loyd=.t.
         endif
         exit
      endif
      lc_n=lc_n+1
    enddo
    if not lc_loyd
      loop
    endif
  endcase
  if dgcat_arr(lcn_log,1) <> anal.dgkat and dgcat_arr(lcn_log,1)<>' ' and dgcat_arr(lcn_log,1)<>'-'
    loop
  endif
  if agelim_arr(lcn_log,1)='>'
    if anal.ika<=val(substr(agelim_arr(lcn_log,1),2,5))
      loop
    endif
  endif
  if agelim_arr(lcn_log,1)='<'
    if anal.ika>=val(substr(agelim_arr(lcn_log,1),2,5))
      loop
    endif
  endif
  if dur_arr(lcn_log,1)='>'
    if anal.dur<=val(substr(dur_arr(lcn_log,1),2,5))
      loop
    endif
  endif
  if dur_arr(lcn_log,1)='<'
    if anal.dur>=val(substr(dur_arr(lcn_log,1),2,5))
      loop
    endif
  endif
  if compl_arr(lcn_log,1)>'0' and not anal.kompl>'0'
    loop
  ENDIF
  IF compl_arr(lcn_log,1)>'1' and not anal.kompl>'1'
    loop
  ENDIF 
  if sex_arr(lcn_log,1)='M' and  not (anal.sex='M' or anal.sex='1')
    loop
  endif
  if sex_arr(lcn_log,1)='F' and not (anal.sex='F' or anal.sex='2')
    loop
  endif
  if sex_arr(lcn_log,1)='-' and anal.sex<>' '
     loop
  endif
  if dgprop1_arr(lcn_log,1)='- ' and anal.dgomin<>space(5)
    loop
  endif
  if dgprop1_arr(lcn_log,1)<>' ' and not (dgprop1_arr(lcn_log,1)='-' and len(trim(dgprop1_arr(lcn_log,1)))>1)
     lc_n=1
    lc_loy=.f.
    do while lc_n<apu_n
      if dgprop1_arr(lcn_log,1)<=apuarr(lc_n,1)
        if dgprop1_arr(lcn_log,1)=apuarr(lc_n,1)
          lc_loy=.t.
        endif
        exit
      endif
      lc_n=lc_n+1
    enddo
    if not lc_loy
      loop
    endif
  endif
  if dgprop1_arr(lcn_log,1)='-'
    lc_n=1
    lc_loy=.f.
    do while lc_n<apu_n
      if substr(dgprop1_arr(lcn_log,1),2,5)<=apuarr(lc_n,1)
        if substr(dgprop1_arr(lcn_log,1),2,5)=apuarr(lc_n,1)
          lc_loy=.t.
        endif
        exit
      endif
      lc_n=lc_n+1
    enddo
    if lc_loy
      loop
    endif
  endif
  if dgprop2_arr(lcn_log,1)<>' ' and not (dgprop2_arr(lcn_log,1)='-' and len(trim(dgprop2_arr(lcn_log,1)))>1)
    lc_n=1
    lc_loy=.f.
    do while lc_n<apu_n
      if dgprop2_arr(lcn_log,1)<=apuarr(lc_n,1)
        if dgprop2_arr(lcn_log,1)=apuarr(lc_n,1)
          lc_loy=.t.
        endif
        exit
      endif
      lc_n=lc_n+1
    enddo
    if not lc_loy
      loop
    endif
  endif
  if dgprop2_arr(lcn_log,1)='-'
    lc_n=1
    lc_loy=.f.
    do while lc_n<apu_n
      if substr(dgprop2_arr(lcn_log,1),2,5)<=apuarr(lc_n,1)
        if substr(dgprop2_arr(lcn_log,1),2,5)=apuarr(lc_n,1)
          lc_loy=.t.
        endif
        exit
      endif
      lc_n=lc_n+1
    enddo
    if lc_loy
      loop
    endif
  endif
  if dgprop3_arr(lcn_log,1)<>' ' and not (dgprop3_arr(lcn_log,1)='-' and len(trim(dgprop3_arr(lcn_log,1)))>1)
    lc_n=1
    lc_loy=.f.
    do while lc_n<apu_n
      if dgprop3_arr(lcn_log,1)<=apuarr(lc_n,1)
        if dgprop3_arr(lcn_log,1)=apuarr(lc_n,1)
          lc_loy=.t.
        endif
        exit
      endif
      lc_n=lc_n+1
    enddo
    if not lc_loy
      loop
    endif
  endif
  if dgprop3_arr(lcn_log,1)='-'
    lc_n=1
    lc_loy=.f.
    do while lc_n<apu_n
      if substr(dgprop3_arr(lcn_log,1),2,5)<=apuarr(lc_n,1)
        if substr(dgprop3_arr(lcn_log,1),2,5)=apuarr(lc_n,1)
          lc_loy=.t.
        endif
        exit
      endif
      lc_n=lc_n+1
    enddo
    if lc_loy
      loop
    endif
  endif
  if dgprop4_arr(lcn_log,1)<>' ' and not (dgprop4_arr(lcn_log,1)='-' and len(trim(dgprop4_arr(lcn_log,1)))>1)
    lc_n=1
    lc_loy=.f.
    do while lc_n<apu_n
      if dgprop4_arr(lcn_log,1) <= apuarr(lc_n,1)
        if dgprop4_arr(lcn_log,1) = apuarr(lc_n,1)
          lc_loy=.t.
        endif
        exit
      endif
      lc_n=lc_n+1
    enddo
    if not lc_loy
      loop
    endif
  endif
  if dgprop4_arr(lcn_log,1)='-'
    lc_n=1
    lc_loy=.f.
    do while lc_n<apu_n
      if substr(dgprop4_arr(lcn_log,1),2,5)<=apuarr(lc_n,1)
        if substr(dgprop4_arr(lcn_log,1),2,5)=apuarr(lc_n,1)
          lc_loy=.t.
        endif
        exit
      endif
      lc_n=lc_n+1
    enddo
    if lc_loy
      loop
    endif
  endif
  if secproc_arr(lcn_log,1)<>' '
    lc_secproc=secproc_arr(lcn_log,1)
    if secproc_arr(lcn_log,1)='-' 
      lc_secproc=substr(secproc_arr(lcn_log,1),2,5)
    endif
    select drgtpt
    lc_sec=.f.
    lc_secdef=.f.
    lc_tp_a=1
    do while lc_tp_a<lc_tp_a2
      do secproc with tparr(lc_tp_a,1)
      lc_tp_a=lc_tp_a+1
    enddo
 
    do secproc with anal.oir1
    if anal.syy1<>' '
      do secproc with anal.syy1
    endif
    if anal.oir2<>' '
      do secproc with anal.oir2
      if anal.syy2<>' '
        do secproc with anal.syy2
      endif
      if anal.oir3<>' '
        do secproc with anal.oir3
        if anal.syy3<>' '
          do secproc with anal.syy3
        endif
        if anal.oir4<>' '
          do secproc with anal.oir4
          if anal.syy4<>' '
            do secproc with anal.syy4
          endif
          if anal.oir5<>' '
            do secproc with anal.oir5
            if anal.syy5<>' '
              do secproc with anal.syy5
            endif
            if anal.oir6<>' '
              do secproc with anal.oir6
              if anal.syy6<>' '
                do secproc with anal.syy6
              endif
              if anal.oir7<>' '
                do secproc with anal.oir7
                if anal.syy7<>' '
                  do secproc with anal.syy7
                endif
                if anal.oir8<>' '
                  do secproc with anal.oir8
                  if anal.syy8<>' '
                    do secproc with anal.syy8
                  endif
                  if anal.oir9<>' '                
                    do secproc with anal.oir9
                    if anal.syy9<>' '
                      do secproc with anal.syy9
                    endif
                  endif
                endif
              endif
            endif
          endif
        endif
      endif
    endif
    if secproc_arr(lcn_log,1)='-'
      if secproc_arr(lcn_log,1)='- '
        if lc_sec 
          loop
        endif
      endif
      if lc_secdef
        loop
      endif
    else
      if secproc_arr(lcn_log,1)='+' and not lc_sec
        loop
      endif
      if not secproc_arr(lcn_log,1)='+ ' and not lc_secdef 
        loop
      endif
    endif
  endif
  if disch_arr(lcn_log,1)='N' and anal.death
    loop
  endif
  if disch_arr(lcn_log,1)='E' and not anal.death
    loop
  endif
  if disch_arr(lcn_log,1)='L' and not anal.lama
     loop
  endif
  if disch_arr(lcn_log,1)='R' and not anal.rem
     loop
  endif
  exit
enddo
  select anal
  if trim(anal.drg)<> locdrg_arr(lcn_log,1) or locdrg_arr(lcn_log,1) <> trim(anal.drg)
    replace anal.drg with locdrg_arr(lcn_log,1)
  endif
  if trim(anal.ord)<>trim(ord_arr(lcn_log,1)) or trim(ord_arr(lcn_log,1))<>trim(anal.ord)
    replace anal.ord with ord_arr(lcn_log,1)
  endif
select drglogic
set order to drg
seek (drg_arr (lcn_log,1))
set order to ord
release lc_sec, lc_first
on key label f5 do kaantark
on key label ctrl+f5 do proctark
return

procedure omin
parameters lc_oir, lc_syy
lc_oir=substr(lc_oir,1,6)
lc_syy=substr(lc_syy,1,6)
if p_allrules
  select icd_10
  seek upper(lc_oir)
  if not found()
    set order to code_w
    seek upper(lc_oir)
    if found()
      lc_oir=code
    endif
    set order to code
  endif
  if lc_syy<>' '
    seek upper(lc_syy)
    if not found()
      set order to code_w
      seek upper(lc_syy)
      if found()
        lc_syy=code
      endif
      set order to code
    endif
  endif
endif
if lc_oir=anal.oir1 and lc_syy=anal.syy1
  return
endif
lc_loop=.t.
lc_vaihe=' '
select dg
do while lc_loop
  if lc_vaihe=' '
    seek upper(lc_oir)
    if found()
      lc_vaihe='A'
    else
      lc_vaihe='B'
    endif
  endif
  * A - searching for manifestation code in DG
  * B - looking for existance of etiological code in ANAL
  if lc_vaihe='B' 
    if lc_syy='  '
      exit
    endif
    seek upper(lc_syy)
    if found()
      lc_vaihe='C'
    else
      lc_vaihe='D'
    endif
  endif
  * C - searching for etiological code in DG
  * D - searching for code pair in DG
  if lc_vaihe='D'
    seek Upper(lc_oir+lc_syy)
    if found()
      lc_vaihe='E'
    else
      exit
    endif
  endif
  * E - code pair found in DG
  if dg.vartype='DGPROP' or dg.vartype='PROCPR' or dg.vartype='COMPL'
    do arrlis with dg.vartype, dg.varval
  endif
  if dg.vartype='DGCAT' and not(substr (varval,1,2)='00' or substr (varval,1,2)='23' or substr (varval,1,2)='25' or substr (varval,1,2)='99')
    do arrlis with 'DGPROP', substr(varval,1,2)+'X99'
  endif 
  if dg.vartype='OR'
  	if dg.varval='2' and anal_or='0' 
  		anal_or = '2'
  	endif
    if dg.varval='1' 
      anal_or = '1'
    endif
  endif
  select dg
  if eof()
    exit
  endif
  skip
  dg_code=code
  dg_dcode=d_code
  do case
  case lc_vaihe='A'
    if upper(lc_oir)<>upper(dg_code) or dg_dcode<>' '
      lc_vaihe='B'
    endif
  case lc_vaihe='C'
    if upper(lc_syy) <> upper(dg_code) or dg_dcode<>' '
      lc_vaihe='D'
    endif
  case lc_vaihe='E'
    if upper(lc_oir) <> upper(dg_code) or upper(lc_syy) <> upper(dg_dcode)
      exit
    endif
  endcase
enddo
select anal
return

procedure tpomin
parameters lc_tp
if p_allrules
  lc_found=.f.
  select ncsp_plus
  set order to ord
  seek lc_tp
  if not found()
    do case
    case p_kieli='Dan'
      set order to code_den
    case p_kieli='Eng'
      set order to code_eng
    case p_kieli='Fin'
      set order to code_fin
    case p_kieli='Est'
      set order to code_est
    case p_kieli='Nor'
      set order to code_nor
    case p_kieli='Swe'
      set order to code_swe
    endcase
    seek lc_tp
  endif
  if found()
    lc_found=.t.
  endif
  lc_loop=.t.
  if lc_found
    do while lc_loop
      lc_tp2=' '
      do case
      case p_kieli='Dan'
        lc_tp2=code_den
      case p_kieli='Eng'
        lc_tp2=code_eng
      case p_kieli='Fin'
        lc_tp2=code_fin
      case p_kieli='Est'
        lc_tp2=code_est
      case p_kieli='Nor'
        lc_tp2=code_nor
      case p_kieli='Swe'
        lc_tp2=code_swe
      endcase
      if lc_tp2<>' '
        lc_tp=lc_tp2
        exit
      endif
      if eof()
        exit
      endif
      skip
      if ord<>lc_tp
        exit
      endif
    enddo
  endif
  set order to ncsp
endif
select ncsp_en
seek trim(lc_tp)
if not found()
  select anal
  return
endif
select drgtpt
set filter to valid 
set order to code
seek trim(lc_tp)
lc_code=code
lc_or=.f.
do while trim(lc_tp)=trim(lc_code) and not eof()
  if vartype='OR'  
  	if drgtpt.varval='2' and anal_or='0' 
  		anal_or = '2'
  	endif
    if drgtpt.varval='1'
      anal_or = '1'
	  lc_or=.t.
	endif
  endif
  if vartype='CC' and varval<>'0' 
    anal_kompl=varval
  endif
  if vartype='PROCPR' or vartype='DGPROP'
    do arrlis with drgtpt.vartype, drgtpt.varval
    if vartype='PROCPR'
      select tpomin
      seek drgtpt.varval
      if found() and extens='1'
        do arrlis with 'PROCPR','99S90'
      endif
    endif
  endif
  select drgtpt
  skip
  lc_code=code
enddo
select anal
return

procedure arrlis
parameter al_vartype, al_varval 
if al_varval=' '
  return
endif
lc_n=1
lc_ff=.f.
do while lc_n<apu_n
  if apuarr(lc_n,1)= al_varval 
    lc_ff=.t.
    exit
  endif
  if apuarr(lc_n,1)> al_varval
    exit
  endif
  lc_n=lc_n+1
enddo
if not lc_ff
  apu_n=apu_n+1
  dimension apuarr (apu_n,3)
  store space(5) to apuarr (apu_n,1) 
  store space(5) to apuarr (apu_n,2)
  store space(5) to apuarr (apu_n,3)  
  if lc_n<apu_n-1
    lc_n2=1
    do while apu_n-lc_n2>lc_n
      lc_n2=lc_n2+1
      lc_varval = apuarr (apu_n-lc_n2,1)
      lc_apuval2 = apuarr (apu_n-lc_n2,2)
      lc_apuval3 = apuarr (apu_n-lc_n2,3)
      store lc_varval to apuarr (apu_n-lc_n2+1,1) 
      store lc_apuval2 to apuarr (apu_n-lc_n2+1,2)
      store lc_apuval3 to apuarr (apu_n-lc_n2+1,3)
    enddo
  endif
  store al_varval to apuarr(lc_n,1)
  store space(5) to apuarr(lc_n,2)
  store space(5) to apuarr(lc_n,3)
  if al_vartype='COMPL'
    lc_varval2=al_varval
    select kompkat
    seek SUBSTR(lc_varval2,1,2)+SUBSTR(lc_varval2,4,2)+SUBSTR(lc_varval2,3,1)
    store kompkat.inclprop to apuarr(lc_n,2)
    IF NOT EOF()
     skip
     if compl=lc_varval2
      store kompkat.inclprop to apuarr(lc_n,3)
     endif
    endif
  endif
endif
return

procedure secproc
parameter ls_code
* This procedure is repeated for all codes - the code is given as parameter (ls_code) to the procedure
* This changes ncsp+ codes to national codes in the testdata (allows use of same testdata for all national versions)
if p_allrules
  select ncsp_plus
  set order to ord
  seek ls_code
  lc_found=.f.
  if not found()
    do case
    case p_kieli='Dan'
      set order to code_den
    case p_kieli='Eng'
      set order to code_eng
    case p_kieli='Fin'
      set order to code_fin
    case p_kieli='Est'
      set order to code_est
    case p_kieli='Nor'
      set order to code_nor
    case p_kieli='Swe'
      set order to code_swe
    endcase
    seek ls_code
  endif
  if found()
    lc_found=.t.
  endif
  lc_loop=.t.
  if lc_found
    do while lc_loop
      lc_tp2=' '
      do case
      case p_kieli='Dan'
        lc_tp2=code_den
      case p_kieli='Eng'
        lc_tp2=code_eng
      case p_kieli='Fin'
        lc_tp2=code_fin
      case p_kieli='Est'
        lc_tp2=code_est
      case p_kieli='Nor'
        lc_tp2=code_nor
      case p_kieli='Swe'
        lc_tp2=code_swe
      endcase
      if lc_tp2<>' '
        ls_code=lc_tp2
        exit
      endif
      if eof()
        exit
      endif
      skip
      if ord<>ls_code
        exit
      endif
    enddo
  endif
  set order to ncsp
endif

* Localization of the code in drgptp or dg file
select drgtpt
seek trim(ls_code)
if not found()
  select dg
  seek trim(upper(ls_code))
  if not found()
    return
  endif
  ls_code=code
endif
dtp_or=.f.
dtp_proc=.f.
dtp_secdef=.f.
*Loop that tests all properties of the code (in drgtpt or dg file)
do while trim(code)=trim(ls_code) and ls_code<>' ' and not eof()
  if vartype='OR' and varval='1'
   * If he procedure is an OR-procedure (OR=1) dtp_or activated
   dtp_or=.t.
  endif
  if vartype='PROCPR' and dtp_or
   *If the procedure is OR-procedure (dtp_or=.t.) and has a procedure property 
   *(vartype='PROCPR') dtp_proc is activated.
   dtp_proc=.t.
  endif
  if varval=trim(procpro_arr(lcn_log,1)) and procpro_arr(lcn_log,1)<>' '
    * If the procedure has procro1 procedure property dtp_proc and dtp_secdef are inactivated. 
    * No further search for this code is performed (exit)
    dtp_proc=.f.
    dtp_secdef=.f.
    exit
  endif
  if varval=trim(lc_secproc) and len(trim(lc_secproc))>0
    * if secproc1 defines a procedure property it is tested separately
    dtp_secdef=.t.
  endif
  skip
enddo
if dtp_proc
  * Activation of master process variable lc_sec indicating secondary procedure
  lc_sec=.t.
endif
if dtp_secdef
  * Activation of master process variable lc_secdef indicating presence of defined secproc1 
  lc_secdef=.t.
endif
return

procedure notpomin
parameters lc_tp
lc_tpmax=lc_tp_a
lc_tpomin=.f.
return
