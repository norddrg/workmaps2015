*:*****************************************************************************
*:
*: Procedure file: D:\DATA\DRG_N\TEHDYT.PRG
*:         System: NORD-DRG, dg-osuus
*:         Author: M.Virtanen
*:      Copyright (c) 2/8/95, MV Health Care Consulting Oy
*:  Last modified: 07/23/95 at 22:15:46
*:
*:  Procs & Fncts: TEHDYT
*:
*:      Documented 01:19:36                                FoxDoc version 3.00a
*:*****************************************************************************
*!*****************************************************************************
*!
*!      Procedure: TEHDYT
*!
*!      Called by: dgohje               (procedure in dgohje.PRG)
*!
*!          Calls: dgnaytto             (procedure in dgnaytto.PRG)
*!
*!*****************************************************************************
PROCEDURE tehdyt
set message to '---'
set near on
lc_n=0
SELECT dg
use
select ICD_10
use
use ('..\..\icd_10\'+language.lan+'\icd_10.dbf')
select 0
USE ('..\..\tabl_def\'+language.lan+'\drgdg.DBF') ALIAS dg EXCLUSIVE
set order to code
SELECT icd_10
set ORDER to code
SET FILTER TO valid AND NOT headline
set RELATION to code+d_code INTO icd10to9

goto top
select dg
set filter to varval='DGCAT'
dimension lc_var (1,2)
dg_order=order()
set filter to valid
set order to code
SELECT icd_10
th_loop=.t.
lc_nv=0
do while th_loop and not eof()
  select dg
  if 1000*int(lc_n/1000)=lc_n
     wait window nowait dg.code+' '+dg.d_code
  endif
  seek upper(icd_10.code+icd_10.d_code)+'DGCAT'
  if not found()
    seek upper(icd_10.code+icd_10.d_code)+'PDGPROP  25P01'
  endif
  if not found()
    if icd_10.d_code<>' '
      select dg
      seek upper(icd_10.code) + space(6)+'DGCAT'
      if not found()
        seek upper(icd_10.code)+space(6)+'PDGPROP  25P01'
      endif
      if not found()
        select icd_10
        replace icd_10.tehty with .f. 
      endif 
    else
      select icd_10
      replace tehty with .f.
    endif
  endif
  select dg
  if found() 
    select icd_10
    replace tehty with .t.
  ELSE
    SET FILTER TO code=icd_10.code
    SEEK icd_10.code
    IF FOUND()
*    SET STEP ON 
      replace ALL valid WITH .t.
      SET FILTER TO valid
      SELECT komplex
      SET FILTER TO code=icd_10.code
      replace ALL valid WITH .t.
      SET FILTER TO valid
      SELECT icd_10
      WAIT WINDOW 'Old definition reactivated for ' + icd_10.code +' - Check'
      exit
    ENDIF 
    SET FILTER TO valid
    select dg
    append blank
    replace code with icd_10.code, vartype with 'DGCAT', varval with '00M00', chdate with date(),valid with .t.
    wait window icd_10.code+' was not defined! Check!' 
    select icd_10
    USE
    use ('..\..\icd_10\'+language.lan+'\icd_10.dbf')
    set ORDER to code
    set FILTER to Valid AND prim AND NOT headline
    set RELATION to code+d_code INTO icd10to9
    SEEK UPPER(dg.code)
*    SET STEP ON 
    exit
  endif
  select icd_10
  if not tehty
    exit
  endif
  lc_n=lc_n+1
  skip
enddo
if eof()
  wait window 'End - check for unnecessary rows begins' nowait
  select dg
  seek 'A'
  do tark
  return
endif
do dgnaytto
RETURN
*: EOF: TEHDYT.PRG


procedure stopback
select icd_10
seek last_c+last_d
replace tehty with .f.
do dgpaiv
return

procedure ylpois
select dg
seek 'A'
lc_n=0
do while not eof()
  if 1000*int(lc_n/1000)=lc_n
     wait window nowait '2. kierros ' +dg.code+' '+dg.d_code
  endif
  lc_n=lc_n+1
  select icd_10
  do case
  case p_kieli='Swe'
    seek dg.code_s+dg.d_code_s
    if not found()
      select dg
      if code_f=' ' and code_n=' ' and code_d=' ' and code_e=' ' and not who
        lc_code=code_s
        replace code_s with ' '
        seek lc_code
      else
        replace valid with .f.
      endif
    endif
  case p_kieli='Nor'
    seek dg.code_n+dg.d_code_n
    if not found()
      select dg
      if code_f=' ' and code_n=' ' and code_d=' ' and code_e=' ' and not who
        lc_code=code_f
        replace code_f with ' '
        seek lc_code
      else
        replace valid with .f.
      endif
    endif
  case p_kieli='Dan'
    seek dg.code_d+dg.d_code_d
    if not found()
      select dg
      if code_f=' ' and code_n=' ' and code_s=' ' and code_e=' ' and not who
        lc_code=code_d
        replace code_d with ' '
        seek lc_code
      else
        replace valid with .f.
      endif
    endif
  case p_kieli='Est'
    seek dg.code_e+dg.d_code_e
    if not found()
     select dg
     if code_s=' ' and code_n=' ' and code_d=' ' and code_f=' ' and not who
        lc_code=code_e
        replace code_e with ' '
        seek lc_code
      else
        replace valid with .f.
      endif
    endif
  case p_kieli='Fin'
    seek dg.code_f+dg.d_code_f
    if not found()
     select dg
     if code_s=' ' and code_n=' ' and code_d=' ' and code_e=' ' and not who
        lc_code=code_f
        replace code_f with ' '
        seek lc_code
      else
        replace valid with .f.
      endif
    endif
  otherwise
    select dg
    do while not who and not eof()
      skip
    enddo
    select icd_10
    seek dg.code+dg.d_code
    if not found()
     select dg
     if code_s=' ' and code_n=' ' and code_d=' ' and code_f=' ' and code_e=' ' 
        replace who with .f.
      else
        replace valid with .f.
      endif
    endif
  endcase
  select dg
  skip
enddo
return