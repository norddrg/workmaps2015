procedure testsiir
WAIT WINDOW "Grouping and moving testdata 'allrules.dbf'" NOWAIT
public p_allrules
p_allrules=.f.
select icd_10
set filter to valid
SELECT csp
*USE
*USE ('..\..\ncsp\'+p_kieli+'\csp') ALIAS ncsp_en
set ORDER to code
SELECT 0
USE ..\..\test\anal_allrules.DBF ALIAS anal
delete all for oir1='_miss' or id='_miss'
pack
do tuplpois
goto Top
ts_n=0
do WHILE NOT EOF()
	ts_n=ts_n+1
	if ts_n=1000*(INT(ts_n/1000))
	  wait window nowait "Assigning DRG's to testdata, "+str(ts_n)+" cases done"
	ENDIF
*	IF ID='TEST 21357'
*	  SET STEP ON 
*	endif
	p_allrules=.t.
	do ..\anal\luokitus
	SELECT anal
	SKIP
ENDDO
SELECT anal
set ORDER to oir1
SEEK '---'
REPLACE drg_ext2 WITH p_kieli, comment WITH p_logic
set order to ord
goto Top
select drglogic
set order to ord
set filter to inuse
goto top
select anal
lc_ord=anal.ord
ts_n=0
do while not eof()
  if ts_n=1000*(INT(ts_n/1000))
    wait window nowait "Searching rules missing in testdata, "+str(ts_n)+" cases done"
  endif
  if drglogic.ord<anal.ord 
    if lc_ord<>drglogic.ord and drglogic.ord<>lc_ord
      insert into ..\..\test\anal_allrules.DBF(ord, drg, id) values (drglogic.ord, drglogic.drg, '_miss')
    endif
    select drglogic
    if not eof()
      skip
    else
      exit
    endif
    loop
  endif
  select anal
  lc_ord=anal.ord
  ts_n=ts_n+1
  skip
enddo
wait window nowait 'Comparison with previous testdata'
select anal
replace all drg_ext with ' ', ord_ext with ' ', drg_ext2 with ' ', ord_ext2 with ' '
set order to id
select 0
USE ('..\..\old\'+p_kieli+'\testrule') ALIAS old
goto top
do while not eof()
  select anal
  seek old.id
  if found()
    replace drg_ext with old.drg, ord_ext with old.ord
  endif
  select old
  skip
  if old.id<>'TEST'
    exit
  endif
enddo
if p_kieli<>'Com'
  select old
  USE ('..\..\..\transp\com\testrule') ALIAS old
  goto top
  do while not eof()
    select anal
    seek old.id
    if found()
      replace drg_ext2 with old.drg, ord_ext2 with old.ord
    endif
    select old
    skip
    if old.id<>'TEST'
      exit
    endif
  enddo
endif
* Cleanup	
select anal
COPY to ..\apu next 0
USE ..\apu
append blank
replace id with '#####',;
oir1 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),1,3),;
syy1 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),4,3),;
oir2 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),7,3),;
syy2 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),10,3),;
oir3 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),13,3),;
syy3 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),16,3),;
oir4 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),19,3),;
syy4 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),22,3),;
oir5 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),25,3),;
syy5 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),28,3),;
oir6 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),31,3),;
syy6 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),34,3),;
oir7 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),37,3),;
syy7 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),40,3),;
oir8 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),43,3),;
syy8 with substr('NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),47,3)
append from ('..\..\test\anal_allrules.DBF')
*USE
*USE ..\apu
*delete all FOR substr(ord,2,6)='00D000'
USE
USE ..\apu
pack
goto top
skip
ts_n3=0
do while not eof()
  ts_n=ts_n+1
  if ts_n=1000*(INT(ts_n/1000))
    wait window nowait "Correcting codes in testdata, "+str(ts_n)+" cases done"
  endif
  if p_allrules and oir1<>' '
    select icd_10
    set order to code
    seek UPPER(apu.oir1)
    if not found()
      set order to code_w
      seek UPPER(apu.oir1)
      if found() 
        replace apu.oir1 with icd_10.code
      endif
    endif
  endif
  select apu
  if AT('.',oir1)>0
    REPLACE oir1 WITH SUBSTR(oir1,1,3)+SUBSTR(oir1,5,2)
  endif
  if p_allrules and syy1<>' '
    select icd_10
    set order to code
    seek UPPER(apu.syy1)
    if not found()
      set order to code_w
      seek UPPER(apu.syy1)
      if found()
        replace apu.syy1 with icd_10.code
      endif
    endif
  endif
  select apu
  if syy1<>' ' and AT('.',syy1)>0
    REPLACE syy1 WITH SUBSTR(syy1,1,3)+SUBSTR(syy1,5,2)
  endif
  if oir2<>' ' 
    if p_allrules 
      select icd_10
      set order to code
      seek UPPER(apu.oir2)
      if not found()
        set order to code_w
        seek UPPER(apu.oir2)
        if found()
          replace apu.oir2 with icd_10.code
        endif
      endif
    endif
    select apu
    if AT('.',oir2)>0
      REPLACE oir2 WITH SUBSTR(oir2,1,3)+SUBSTR(oir2,5,2)
    endif
    if p_allrules and syy2<>' '
      select icd_10
      set order to code
      seek UPPER(apu.syy2)
      if not found()
        set order to code_w
        seek UPPER(apu.syy2)
        if found()
          replace apu.syy2 with icd_10.code
        endif
      endif
    endif
    select apu
    if syy2<>' ' and AT('.',syy2)>0
      REPLACE syy2 WITH SUBSTR(syy2,1,3)+SUBSTR(syy2,5,2)
    endif
    if oir3<>' '
      if p_allrules 
        select icd_10
        set order to code
        seek UPPER(apu.oir3)
        if not found()
          set order to code_w
          seek UPPER(apu.oir3)
          if found()
            replace apu.oir3 with icd_10.code
          endif
        endif
      endif
      select apu
      if AT('.',oir3)>0
        REPLACE oir3 WITH SUBSTR(oir3,1,3)+SUBSTR(oir3,5,2)
      endif
      if p_allrules and syy3<>' '
        select icd_10
        set order to code
        seek UPPER(apu.syy3)
        if not found()
          set order to code_w
          seek apu.syy3
          if found()
            replace apu.syy3 with icd_10.code
          endif
        endif
      endif
      select apu
      if syy3<>' ' and AT('.',syy3)>0
        REPLACE syy3 WITH SUBSTR(syy3,1,3)+SUBSTR(syy3,5,2) 
      endif
      if oir4<>' '
        if p_allrules 
          select icd_10
          set order to code
          seek UPPER(apu.oir4)
          if not found()
            set order to code_w
            seek UPPER(apu.oir4)
            if found()
              replace apu.oir4 with icd_10.code
            endif
          endif
        endif
        select apu
        if AT('.',oir4)>0
          REPLACE oir4 WITH SUBSTR(oir4,1,3)+SUBSTR(oir4,5,2)
        endif
        if p_allrules and syy4<>' '
          select icd_10
          set order to code
          seek UPPER(apu.syy4)
          if not found()
            set order to code_w
            seek UPPER(apu.syy4)
            if found()
              replace apu.syy4 with icd_10.code
            endif
          endif
        endif
        select apu
        if syy4<>' ' and AT('.',syy4)>0
          REPLACE syy4 WITH SUBSTR(syy4,1,3)+SUBSTR(syy4,5,2)
        endif
        if oir5<>' '
          if p_allrules 
            select icd_10
            set order to code
            seek UPPER(apu.oir5)
            if not found()
              set order to code_w
              seek UPPER(apu.oir5)
              if found()
                replace apu.oir5 with icd_10.code
              endif
            endif
          endif
          select apu
          if AT('.',oir5)>0
            REPLACE oir5 WITH SUBSTR(oir5,1,3)+SUBSTR(oir5,5,2)
          endif
          if p_allrules and syy5<>' '
            select icd_10
            set order to code
            seek UPPER(apu.syy5)
            if not found()
              set order to code_w
              seek UPPER(apu.syy5)
              if found()
                replace apu.syy5 with icd_10.code
              endif
            endif
          endif
          select apu
          if syy5<>' ' and AT('.',syy5)>0
            REPLACE syy5 WITH SUBSTR(syy5,1,3)+SUBSTR(syy5,5,2)
          endif
          if oir6<>' '
            if p_allrules 
              select icd_10
              set order to code
              seek UPPER(apu.oir6)
              if not found()
                set order to code_w
                seek UPPER(apu.oir6)
                if found()
                  replace apu.oir6 with icd_10.code
                endif
              endif
            endif
            select apu
            if AT('.',oir6)>0
              REPLACE oir6 WITH SUBSTR(oir6,1,3)+SUBSTR(oir6,5,2)
            endif
            if p_allrules and syy6<>' '
              select icd_10
              set order to code
              seek UPPER(apu.syy6)
              if not found()
                set order to code_w
                seek UPPER(apu.syy6)
                if found()
                  replace apu.syy6 with icd_10.code
                endif
              endif
            endif
            select apu
            if syy6<>' ' and AT('.',syy6)>0
              REPLACE syy6 WITH SUBSTR(syy6,1,3)+SUBSTR(syy6,5,2)
            endif
            if oir7<>' ' 
              if p_allrules 
                select icd_10
                set order to code
                seek UPPER(apu.oir7)
                if not found()
                  set order to code_w
                  seek UPPER(apu.oir7)
                  if found()
                    replace apu.oir7 with icd_10.code
                  endif
                endif
              endif
              select apu
              if AT('.',oir7)>0
                REPLACE oir7 WITH SUBSTR(oir7,1,3)+SUBSTR(oir7,5,2)
              endif
              if p_allrules and syy7<>' '
                select icd_10
                set order to code
                seek UPPER(apu.syy7)
                if not found()
                  set order to code_w
                  seek UPPER(apu.syy7)
                  if found()
                    replace apu.syy7 with icd_10.code
                  endif
                endif
              endif
              select apu
              if syy7<>' ' and AT('.',syy7)>0
                REPLACE syy7 WITH SUBSTR(syy7,1,3)+SUBSTR(syy7,5,2)
              endif
              if oir8<>' '
                if p_allrules 
                  select icd_10
                  set order to code
                  seek UPPER(apu.oir8)
                  if not found()
                    set order to code_w
                    seek UPPER(apu.oir8)
                    if found()
                      replace apu.oir8 with icd_10.code
                      endif
                  endif
                endif
                select apu
                if AT('.',oir8)>0
                  REPLACE oir8 WITH SUBSTR(oir8,1,3)+SUBSTR(oir8,5,2)
                endif
                if p_allrules and syy8<>' '
                  select icd_10
                  set order to code
                  seek UPPER(apu.syy8)
                  if not found()
                    set order to code_w
                    seek UPPER(apu.syy8)
                    if found()
                      replace apu.syy8 with icd_10.code
                    endif
                  endif
                endif
                select apu
                if syy8<>' ' and AT('.',syy8)>0
                  REPLACE syy8 WITH SUBSTR(syy8,1,3)+SUBSTR(syy8,5,2)
                endif
                if oir9<>' '
                  if p_allrules 
                    select icd_10
                    set order to code
                    seek UPPER(apu.oir9)
                    if not found()
                      set order to code_w
                      seek UPPER(apu.oir9)
                      if found()
                        replace apu.oir9 with icd_10.code
                        endif
                    endif
                  endif
                  select apu
                  if AT('.',oir9)>0
                    REPLACE oir9 WITH SUBSTR(oir9,1,3)+SUBSTR(oir9,5,2)
                  endif
                  if p_allrules and syy9<>' '
                    select icd_10
                    set order to code
                    seek UPPER(apu.syy9)
                    if not found()
                      set order to code_w
                      seek UPPER(apu.syy9)
                      if found()
                        replace apu.syy9 with icd_10.code
                      endif
                    endif
                  endif
                  select apu
                  if syy9<>' ' and AT('.',syy9)>0
                    REPLACE syy9 WITH SUBSTR(syy9,1,3)+SUBSTR(syy9,5,2)
                  endif
                endif
              endif
            endif
          endif
        endif
      endif
    endif
  endif
  select icd_10
  set order to code
  select apu
  if lama
    replace disch with 'L'
  endif
  if rem 
    replace disch with 'R'
  endif
  if death
    replace disch with 'E'
  endif
  if p_allrules
  	if apu.tp1<>' '
   	  lc_tp=apu.tp1
  	  do tp_mapp with lc_tp
  	  replace apu.tp1 with lc_tp
  	  if apu.tp2<>' '
   	    lc_tp=apu.tp2
  	    do tp_mapp with lc_tp
  	    replace apu.tp2 with lc_tp
  	    if apu.tp3<>' '
  	      lc_tp=apu.tp3
  	      do tp_mapp with lc_tp
  	      replace apu.tp3 with lc_tp
  	      if apu.tp4<>' '
  	        lc_tp=apu.tp4
  	        do tp_mapp with lc_tp
  	        replace apu.tp4 with lc_tp
  	        if apu.tp5<>' '
  	          lc_tp=apu.tp5
  	          do tp_mapp with lc_tp
  	          replace apu.tp5 with lc_tp
  	          if apu.tp6<>' '
  	            lc_tp=apu.tp6
  	            do tp_mapp with lc_tp
  	            replace apu.tp6 with lc_tp
  	            if apu.tp7<>' '
  	              lc_tp=apu.tp7
  	              do tp_mapp with lc_tp
  	              replace apu.tp7 with lc_tp
  	              if apu.tp8<>' '
  	                lc_tp=apu.tp8
  	                do tp_mapp with lc_tp
  	                replace apu.tp8 with lc_tp
  	                if apu.tp9<>' '
  	                  lc_tp=apu.tp9
  	                  do tp_mapp with lc_tp
  	                  replace apu.tp9 with lc_tp
  	                endif
  	              endif
  	            endif
  	          endif
  	        endif
  	      endif
  	    endif
  	  endif
  	endif
  endif
  select apu
  skip
enddo
Wait window nowait 'Creating report files'
select apu
goto Top
COPY to (lc_siirto+'\testrule_xls.dbf'); 
TYPE foxplus FIELDS id, drg, ord, ika, sex, death, lama, rem, disch, dur, oir1, syy1, oir2,; 
syy2, oir3, syy3, oir4, syy4, oir5, syy5, oir6, syy6, oir7, syy7, oir8, syy8, oir9, syy9, tp1,; 
tp2, tp3, tp4, tp5, tp6, tp7, tp8, tp9, drg_ext, ord_ext
set filter to drg<>drg_ext
COPY to (lc_siirto+'\muutos\testrule.xl2');
TYPE XLS FIELDS id, drg, drg_ext, ord, ord_ext, ika, sex, death, lama, rem, disch, dur,;
oir1, syy1, oir2, syy2, oir3, syy3, oir4, syy4, oir5, syy5, oir6, syy6, oir7, syy7, oir8, syy8, oir9, syy9,; 
tp1, tp2, tp3, tp4, tp5, tp6, tp7, tp8, tp9
COPY to (lc_siirto+'\muutos\testrule.dbf');
TYPE foxplus FIELDS id, drg, drg_ext, ord, ord_ext, ika, sex, death, lama, rem, disch, dur,;
oir1, syy1, oir2, syy2, oir3, syy3, oir4, syy4, oir5, syy5, oir6, syy6, oir7, syy7, oir8, syy8, oir9, syy9,;
tp1, tp2, tp3, tp4, tp5, tp6, tp7, tp8, tp9
if p_kieli<>'Com'
  COPY to (lc_siirto+'\dif\testrule.xl2');
  TYPE XLS FIELDS id, drg, drg_ext2, ord, ord_ext2, ika, sex, death, lama, rem, disch, dur,;
  oir1, syy1, oir2, syy2, oir3, syy3, oir4, syy4, oir5, syy5, oir6, syy6, oir7, syy7, oir8, syy8, oir9, syy9,; 
  tp1, tp2, tp3, tp4, tp5, tp6, tp7, tp8, tp9
  COPY to (lc_siirto+'\dif\testrule.dbf');
  TYPE foxplus FIELDS id, drg, drg_ext2, ord, ord_ext2, ika, sex, death, lama, rem, disch, dur,;
  oir1, syy1, oir2, syy2, oir3, syy3, oir4, syy4, oir5, syy5, oir6, syy6, oir7, syy7, oir8, syy8, oir9, syy9,;
  tp1, tp2, tp3, tp4, tp5, tp6, tp7, tp8, tp9
endif
set filter to

select apu
if lc_addon<>' '
  p_allrules=.f.
  select apu
  wait window nowait 'Adding external testdata for dbf-file'
  COPY to ..\apu2 next 0
  select 0
  use ..\apu2 alias anal
  append from (lc_addon)
  goto top
  ts_n=0
  do WHILE NOT EOF()
	ts_n=ts_n+1
	if ts_n=1000*(INT(ts_n/1000))
	  wait window nowait "Assigning DRG's to external testdata, "+str(ts_n)+" cases done"
	endif
	do ..\anal\luokitus
    select anal
    if lama
      replace disch with 'L'
    endif
    if rem 
      replace disch with 'R'
    endif
    if death
      replace disch with 'E'
    endif
    if AT('.',oir1)>0
      REPLACE oir1 WITH SUBSTR(oir1,1,3)+SUBSTR(oir1,5,2)
    endif
    if syy1<>' ' and AT('.',syy1)>0
      REPLACE syy1 WITH SUBSTR(syy1,1,3)+SUBSTR(syy1,5,2)
    endif
    if oir2<>' ' 
      if AT('.',oir2)>0
        REPLACE oir2 WITH SUBSTR(oir2,1,3)+SUBSTR(oir2,5,2)
      endif
      if syy2<>' ' and AT('.',syy2)>0
        REPLACE syy2 WITH SUBSTR(syy2,1,3)+SUBSTR(syy2,5,2)
      endif
      if oir3<>' '
        if AT('.',oir3)>0
          REPLACE oir3 WITH SUBSTR(oir3,1,3)+SUBSTR(oir3,5,2)
        endif
        if syy3<>' ' and AT('.',syy3)>0
          REPLACE syy3 WITH SUBSTR(syy3,1,3)+SUBSTR(syy3,5,2) 
        endif
        if oir4<>' '
          if AT('.',oir4)>0
            REPLACE oir4 WITH SUBSTR(oir4,1,3)+SUBSTR(oir4,5,2)
          endif
          if syy4<>' ' and AT('.',syy4)>0
            REPLACE syy4 WITH SUBSTR(syy4,1,3)+SUBSTR(syy4,5,2)
          endif
          if oir5<>' '
            if AT('.',oir5)>0
              REPLACE oir5 WITH SUBSTR(oir5,1,3)+SUBSTR(oir5,5,2)
            endif
            if syy5<>' ' and AT('.',syy5)>0
              REPLACE syy5 WITH SUBSTR(syy5,1,3)+SUBSTR(syy5,5,2)
            endif
            if oir6<>' '
              if AT('.',oir6)>0
                REPLACE oir6 WITH SUBSTR(oir6,1,3)+SUBSTR(oir6,5,2)
              endif
              if syy6<>' ' and AT('.',syy6)>0
                REPLACE syy6 WITH SUBSTR(syy6,1,3)+SUBSTR(syy6,5,2)
              endif
              if oir7<>' ' 
                if AT('.',oir7)>0
                  REPLACE oir7 WITH SUBSTR(oir7,1,3)+SUBSTR(oir7,5,2)
                endif
                if syy7<>' ' and AT('.',syy7)>0
                  REPLACE syy7 WITH SUBSTR(syy7,1,3)+SUBSTR(syy7,5,2)
                endif
                if oir8<>' '
                  if AT('.',oir8)>0
                    REPLACE oir8 WITH SUBSTR(oir8,1,3)+SUBSTR(oir8,5,2)
                  endif
                  if syy8<>' ' and AT('.',syy8)>0
                    REPLACE syy8 WITH SUBSTR(syy8,1,3)+SUBSTR(syy8,5,2)
                  endif
                  if oir9<>' '
                    if AT('.',oir9)>0
                      REPLACE oir9 WITH SUBSTR(oir9,1,3)+SUBSTR(oir9,5,2)
                    endif
                    if syy9<>' ' and AT('.',syy9)>0
                      REPLACE syy9 WITH SUBSTR(syy9,1,3)+SUBSTR(syy9,5,2)
                    endif
                  endif
                endif
              endif
            endif
          endif
        endif
      endif
    endif
    skip
  enddo
  use
  select apu
  wait window nowait 'Appending external testadata'
  append from ..\apu2
  wait window nowait 'Copying compined testdata to testrule.dbf'
endif

select apu
COPY to (lc_siirto+'\testrule.dbf')TYPE foxplus ;
FIELDS id, drg, ord, ika, sex, death, lama, rem, disch, dur, oir1, syy1, oir2, syy2,;
oir3, syy3, oir4, syy4, oir5, syy5, oir6, syy6, oir7, syy7, oir8, syy8, oir9, syy9, tp1, tp2, tp3,; 
tp4, tp5, tp6, tp7, tp8, tp9
COPY to (lc_siirto+'\testrule.txt')DELIMITED WITH CHAR ';' ;
FIELDS id, drg, ord, ika, sex, death, lama, rem, disch, dur, oir1, syy1, oir2, syy2,;
oir3, syy3, oir4, syy4, oir5, syy5, oir6, syy6, oir7, syy7, oir8, syy8, oir9, syy9, tp1, tp2, tp3,; 
tp4, tp5, tp6, tp7, tp8, tp9

SELECT apu
USE
*SELECT ncsp_en
*USE
return

Procedure tp_mapp
parameter tpm_tp
*SET STEP ON 
if tpm_tp<>' ' 
  tmp_loop=.t.
  select csp
  set order to ncsp
  apu_tp=' '
  seek tpm_tp
  if not found()
    SET ORDER TO code
    seek tpm_tp
  endif
  if found()
    apu_tp=csp.code
  endif
endif
if apu_tp<>' '
  tpm_tp=apu_tp
endif
return tpm_tp