Procedure datasel
activate window syotto
lc_dbtype =space(10)
@ 0,1 say 'Database selection:'
@ 1,1 say 'Type of database: (dbf/delimited/standard data format)'
@ 2,1 get lc_dbtype picture '@M dbf,delimited,SDF'
read
if lc_dbtype='delimited'
  lc_delim=space(14)
  lc_textlim=space (14)
  @ 3,1 say 'Delimited with: (half point/comma/tab)'
  @ 4,1 get lc_delim picture '@M half point, comma, tab'
  @ 5,1 say 'Text delimited with : (none/apostrophs)'
  @ 6,1 get lc_textlim picture '@M none, apostrophs'
  read
endif

if lc_dbtype='dbf'
  define popup filesel prompt files like ..\..\..\..\NDMS_testdata\*.dbf
else
  define popup filesel prompt files like ..\..\..\..\NDMS_testdata\*.txt
endif
on selection popup filesel do selection with prompt()
wait window nowait 'Select the file!'
activate popup filesel at 5,10
release popup filesel
if lastkey()=27
  return
endif

select 0
if lc_dbtype='dbf'
  use ..\logicstr
  copy to ..\apu with cdx
  use ..\apu
  set order to firstpos
  select 0
  use (ds_datasel)
  ds_datasel=substr(ds_datasel,1,rat('.',ds_datasel)-1)
  copy structure extended to ..\apustr
  use ..\apustr
  goto top
  lc_strchk=0
  lc_strchk2=0
  wait window nowait 'Checking structure'
  do while not eof()
    select apu
    locate all for field_name = apustr.field_name
    if field_name= apustr.field_name
      replace absent with .f., outset with .f., minset with .f.
    endif
    select apustr
    skip
  enddo
  select apu
  lc_discstat=.t.
  locate all for field_name = 'DISCSTAT'
  if absent
    lc_discstat=.f.
  endif

  lc_death=.t.
  locate all for field_name = 'DEATH'
  if absent
    lc_death=.f.
    if lc_discstat
      replace absent with .f., minset with .f.
    endif
  endif
  
  lc_lama=.t.
  locate all for field_name = 'LAMA'
  if absent
    lc_lama=.f.
    if lc_discstat
      replace absent with .f., minset with .f.
    endif
  endif
  
  lc_rem=.t.
  locate all for field_name = 'REM'
  if absent
    lc_lama = .f.
    if lc_discstat
      replace absent with .f., minset with .f.
    endif
  endif

  lc_ikalas=.t.
  locate all for field_name = 'IKA '
  if absent
    lc_ikalas=.f.
    locate all for field_name = 'IKAVUO'
    if absent
      locate all for field_name = 'IKA '
      replace absent with .f., minset with .f.
    endif
  endif
  count for minset to lc_strchk 
  if lc_strchk > 0
    goto top
    lc_puutstr=' '
    do while not eof()
      lc_puutstr=lc_puutstr+trim(field_name)+' - '      
      skip
    enddo
    wait window 'Missing field(s)-'+lc_puutstr
  endif
  count for outset to lc_strchk
  if lc_strchk = 0 and lc_discstat and lc_ikalas
    ds_datase2 = ds_datasel
    use (ds_datase2) alias anal  
    wait window nowait 'Structure OK'
  else
    ds_datase2=ds_datasel+'2'
    select apu
    delete all for not outset
    pack
    append from ..\apustr
    use
    create (ds_datase2) from ..\apu 
    wait window nowait 'Moving records to new '+ds_datase2
    use (ds_datase2) alias anal
    append from (ds_datasel)
    if lc_discstat
      if lc_death
        replace all death with .f.
        replace all death with .t. for discstat='4'
      endif
      if lc_lama 
         replace all lama with .f.
         replace all lama with .t. for discstat='3'
       endif
      if lc_rem
         replace all rem with .f.
         replace all rem with .t. for discstat='2'
      endif
    endif
    if lc_ikalas
      replace all ikav with 365*ikavuo
    endif
  endif
else
  ds_datase2=substr(ds_datasel,1,rat('.',ds_datasel)-1)
  ds_strfound=.t.
  use ..\logicstr
  copy next 0 to ..\apu with cdx
  use ..\apu 
  on error do cont_proc
  append from (ds_datase2+'_str.dbf')
  on error
  pack 
  if not ds_strfound
    append from ..\logicstr
  endif
  set order to firstpos
  @ 1,1 clear
  if lc_dbtype='delimited'
    @ 1,1 say 'Indicate the order position of the key-variables by firstpos and their length by field_len'
    @ 2,1 say 'Other variables will automatically have name STRxx and length 10'
    goto top
    lc_nfpos=0
    do while not eof()
      lc_nfpos=lc_nfpos+1
      if var<>' '
        replace firstpos with lc_nfpos
      else
        replace firstpos with 999
      endif
      skip
    enddo
  else
    @ 1,1 say 'Indicate the starting point and length of each variable firstpos, field_len'
    @ 2,1 say 'Fields may not overlap each other! Characters between the fields will be stored as STRxx variables'
  endif
  @ 3,1 say 'The variable name (field VAR) may be modified for cases where it starts with HELP to add variables to the resulting database'
  @ 4,1 say 'Other (standard) variable names cannot be changed'
  @ 5,1 say 'Accept with [Ctrl][W]'
  set filter to var<>' '
  activate window anal
  lc_loop=.t.
  do while lc_loop
    set filter to var<>' '
    replace all absent with .f.
    goto top
    set message to 'Obligatory variables are: IKA, SEX, DEATH, LAMA, REM, DUR, OIR1, TP1, DUR_W, EXPENCES, EXP_W, TRIMMED and EXP_TW'
    set filter to not outset
    browse fields var, expl:80:R, firstpos, field_len, field_dec in window anal
    set message to
    replace all field_name with var for field_name='APU'
    replace all for (field_len=0 or firstpos=0) absent with .t.
    replace all minset with .f. for (not absent)
	replace all analset with .t. for (not absent)
    lc_discstat=.f.
    locate all for field_name = 'DEATH'
    if absent
      lc_discstat=.t.
      replace minset with .f.
    endif
    locate all for field_name = 'LAMA'
    if absent
      lc_discstat=.t.
      replace minset with .f.
    endif
    locate all for field_name = 'REM'
    if absent
      lc_discstat=.t.
      replace minset with .f.
    endif
    if lc_discstat
      locate all for field_name = 'DISCSTAT'
      if absent
        replace minset with .t.
      endif
    endif
    lc_ika=.t.
    locate all for field_name = 'IKA '
    if absent
      lc_ika=.f.
      replace minset with .f.
      locate all for field_name = 'IKAVUO'
      if absent
        replace minset with .t.
      endif
    endif
    count for minset to lc_strchk 
    if lc_strchk > 0
      wait window 'A key information field is missing, check database description! [press any key to continue]' nowait
      set message to 'Obligatory variables are: IKA, SEX, DUR, OIR1 and TP1 and DEATH, LAMA and REM or DISCSTAT'
      loop
    endif
    set filter to field_len>0 and firstpos>0
    set order to firstpos
    copy next 0 to ..\apu2 with cdx
    select 0
    use ..\apu2
    set order to firstpos
    select apu
    goto top
    lc_pos=1
    lc_napu=0
    lc_loop=.f.
    do while not eof()
      if lc_dbtype='SDF'
        do case
        case lc_pos<apu.firstpos
          lc_len=apu.firstpos-lc_pos
          lc_napu=lc_napu+1
          select apu2
          append blank 
          replace field_name with 'STR_'+rtrim(ltrim(str(lc_napu)))
          replace field_type with 'C'
          replace field_len with lc_len, field_dec with 0, field_null with .f., field_nocp with .f., firstpos with lc_pos
          lc_pos = firstpos+field_len
        case lc_pos>apu.firstpos
          wait window nowait 'Overlapping fields, correct the structure'
          lc_loop=.t.
          select apu2
          use
          select apu
          exit
        otherwise
          select apu2
          append blank
          replace field_name with apu.field_name, field_type with apu.field_type,;
          field_len with apu.field_len, field_dec with apu.field_dec, field_null with apu.field_null;
          field_nocp with apu.field_nocp, firstpos with apu.firstpos
        endcase
      else
        do case
        case lc_pos>apu.firstpos and apu.firstpos <>999
          wait window nowait 'Error in order positions, correct the structure'
          lc_loop=.t.
          select apu2
          use
          select apu
          exit
        case lc_pos<apu.firstpos and apu.firstpos<999
          lc_napu=lc_napu+1
          select apu2
          append blank 
          replace field_name with 'STR_'+rtrim(ltrim(str(lc_napu)))
          replace field_type with 'C'
          replace field_len with 10, field_dec with 0, field_null with .f., field_nocp with .f., firstpos with lc_pos
          lc_pos = lc_pos+1
          loop
        otherwise
          select apu2
          append blank
          replace field_name with apu.field_name, field_type with apu.field_type,;
          field_len with apu.field_len, field_dec with apu.field_dec, field_null with apu.field_null;
          field_nocp with apu.field_nocp, firstpos with apu.firstpos
          lc_pos=lc_pos+1
        endcase
      endif
      select apu
      skip
    enddo    
  enddo
  if not ds_strfound
    create (ds_datase2+'_str.dbf') from ..\str_str
    use (ds_datase2+'_str.dbf')    
  else
    use (ds_datase2+'_str.dbf')
    delete all
  endif
  append from ..\apu
  use ..\apu
  set order to firstpos
  set filter to analset
  copy to ..\apu3
  use
  select apu2
  use
  create ..\apu4 from ..\apu2
  use ..\apu4
  if lc_dbtype='delimited'
    do case
    case lc_delim='half point'
      if lc_textlim='none'
        append from (ds_datasel) type delimited with ";"
      else
        append from (ds_datasel) type delimited with '"' with char ';'    
      endif
    case lc_delim='comma'
      if lc_textlim='none'
        append from (ds_datasel) type delimited with ","
      else
        append from (ds_datasel) type delimited with '"' with char ,
      endif
    case lc_delim='tab'
      if lc_textlim='none'
        append from (ds_datasel) type delimited with TAB
      else
        append from (ds_datasel) type delimited with '"' with char TAB      
      endif
    endcase
  else
    append from (ds_datasel) type SDF
  endif
  use ..\apu3
  replace all field_len with apu_len for apu_len>field_len
  replace all field_dec with apu_dec for apu_dec>field_dec
  use
  create (ds_datase2) from ..\apu3
  use (ds_datase2) alias anal
  append from ..\apu4
  if lc_discstat
    replace all death with .f., lama with .f., rem with .f.
    replace all death with .t. for discstat='4'
    replace all lama with .t. for discstat='3'
    replace all rem with .t. for discstat='2'
  endif
  if not lc_ika
    replace all ika with 365*ikavuo
  endif
endif
deactivate window syotto
return

procedure selection
parameter lc_sel
ds_datasel=lc_sel
*ds_datasel =substr(ds_datasel,rat('\',ds_datasel)+1,len(ds_datasel))
deactivate popup filesel
return

procedure cont_proc
  ds_strfound=.f.
return