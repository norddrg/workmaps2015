PROCEDURE drganal

set default to ..\anal
CD ..\anal
SET PATH TO ..\anal
set status off
release windows
Close databases
Clear macros
CLEAR
SET NEAR ON
SET TALK OFF
set date ymd
public max_y, max_x, max_foty, max_fosi, p_allrules
p_allrules=.f.
on error do pldg
? p_ldg
on error do plproc
? p_lproc
on error do pldrg
? p_ldrg
on error
public p_lproc, p_ldg, p_ldrg
public min_y, min_x
min_y=int(max_y/6)
if min_y<5
  min_y=5
endif
min_x=int(max_x/3)
public lc_dg1, lc_dg2, lc_dg3, lc_dg4, lc_dg5, lc_dg6, lc_dg7, lc_dg8, lc_dg9,;
lc_tpn1, lc_tpn2, lc_tpn3, lc_tpn4, lc_tpn5, lc_tpn6, lc_tpn7, lc_tpn8, lc_tpn9,;
gl_n, dg_tp
public p_nayt
public pb_comment
public p_logluku
p_logluku=.f.
pb_comment=''
p_nayt=.t.
public et_kood
et_kood=space(6)
lc_kieli2='---'
lc_logic2='---'
lc_vers2='---'
lc_dg1='-'
lc_dg2='-'
lc_dg3='-'
lc_dg4='-'
lc_dg5='-'
lc_dg6='-'
lc_dg7='-'
lc_dg8='-'
lc_dg9='-'
lc_tpn1='-'
lc_tpn2='-'
lc_tpn3='-'
lc_tpn4='-'
lc_tpn5='-'
lc_tpn6='-'
lc_tpn7='-'
lc_tpn8='-'
lc_tpn9='-'
gl_n=1
dg_tp=' '
PUBLIC ctrl_t
DEFINE WINDOW syotto FROM 0,3 TO min_y, max_x FONT  'COURIER NEW',  8
DEFINE WINDOW anal FROM min_y,1 TO max_y-3, max_x FONT  max_foty,  max_fosi
DEFINE WINDOW comm FROM max_y-3,0 TO max_y, max_x FONT  max_foty,  max_fosi Title 'Comments'

SELECT 0
use ..\..\tabl_def\language
set order to lan
PUBLIC perushak
perushak=substr(dbf(),1,at('\',dbf(),2))+'PRG\'

select 0
define popup filesel prompt files like ..\..\test\anal_*.dbf
on selection popup filesel do selection with prompt()
wait window nowait 'Choose the file!'
activate popup filesel at 5,10
release popup filesel
set filter to not deleted()

public p_kieli
p_kieli=' '
set order to oir1
goto top
seek '---'
if found() and drg_ext<>' '
  select language
  seek trim(anal.drg_ext)
  if found()
    p_kieli=trim(anal.drg_ext)
    p_kiehak=trim(language.hakem)
  endif
endif
seek '0'
select language
seek p_kieli
if not found() 
  define popup lansel prompt field name
  on selection popup lansel do language with prompt()
  wait window nowait 'Choose the language!'
  activate popup lansel at 5,10
  release popup lansel
  p_kiehak=trim(language.hakem)
  select anal
  seek '---'
  if not found()
    append blank
  endif
  replace oir1 with '---', tp1 with '---', drg_ext with p_kieli
endif
if p_kieli='Dan'
  if len(trim(p_ldg))<4  or at('.',p_ldg)>0
    p_ldg='D'+substr(p_ldg,1,3)+substr(p_ldg,5,2)
    p_lproc='K'+p_lproc
  endif
endif
if p_kieli='Com'
  p_allrules=.f.
endif

public p_logic
select anal
seek '---'
p_logic=trim(anal.comment)
lc_log='..\..\tabl_def\'+p_logic
select 0
on error do ..\common\logicsel
use (lc_log) alias drglogic
on error
SET ORDER TO ord
set fullpath off
p_logic=substr(dbf(), at(':',dbf())+1,100)
select anal
seek '---'
replace comment with p_logic

public p_class
select anal
set order to oir1
seek '---'
if drg_ext2<>' '
  if anal.drg_ext2='T'
    p_class=.t.
  else
    p_class=.f.
  endif
else
  da_loop=.t.
  do while da_loop
    p_class=.f.
    wait window 'Do you want to use [C]lassic version or [F]ull version'
    if lastkey()=99 or lastkey()=67
      p_class=.t.
      replace anal.drg_ext2 with 'T'
      exit
    endif
    if lastkey()=102 or lastkey()=70
      replace anal.drg_ext2 with 'F'
      exit
    endif
  enddo
endif

do analohje

SELECT 0
use ..\..\icd_9\icd10to9
set order to code

select 0
USE ..\..\icd_9\icd9cm_d.dbf EXCLUSIVE noupdate
set order to icd9_cm

SELECT 0
USE ..\..\tabl_def\link.dbf EXCLUSIVE
SET ORDER TO Icd9cm_o
set filter to ncsp<>' '

select 0
use ..\..\icd_9\icd9cm_o.dbf exclusive
set order  to icd9_tp

SELECT 0
USE ..\..\tabl_def\dgkat.dbf EXCLUSIVE
SET ORDER TO dgcat 

SELECT 0
USE ..\..\tabl_def\dgomin.dbf EXCLUSIVE
SET ORDER TO dgprop

SELECT 0
USE ..\..\tabl_def\tpomin.dbf EXCLUSIVE
SET ORDER TO procprop


SELECT 0
USE ..\..\tabl_def\mdc.dbf exclusive
SET ORDER TO mdc 

select 0
use ..\..\tabl_def\rtc
set order to code

select 0
use ..\..\tabl_def\pdgomin
set order to pdgprop

set fullpath on
select drglogic
SELECT 0
USE ('..\..\tabl_def\'+language.lan+'\drgnames')
SET ORDER TO drg

SELECT drglogic
SET RELATION TO drg INTO drgnames

DO analohje

SELECT 0
USE ('..\..\tabl_def\'+language.lan+'\komplex.dbf') EXCLUSIVE
SET ORDER TO compl 

SELECT 0
USE ..\..\tabl_def\kompkat.dbf EXCLUSIVE
SET ORDER TO compl 

select 0
use ('..\..\tabl_def\'+p_kieli+'\drgtpt')
set filter to valid
set order to code

SELECT 0
USE ('..\..\tabl_def\'+language.lan+'\drgdg.dbf') ALIAS dg EXCLUSIVE
SET ORDER TO code
select 0
use ('..\..\icd_10\'+p_kieli+'\icd_10') EXCLUSIVE 
set order to code
set relation to code+d_code into icd10to9
set filter to valid

select 0
use ('../../ncsp/'+p_kieli+'/csp.dbf') alias csp
SET ORDER TO code
select drgtpt
set filter to not deleted() and code<>' '

if p_allrules
  select 0
  use ('../../ncsp/ncsp_plus.dbf') 
  set filter to not released
  set order to ncsp
endif

select 0
use ..\apuomin
set order to omin

SELECT 0
USE ('..\..\tabl_def\'+p_kieli+'\catomin')
set ORDER to catomin

Do ..\common\inuselis

select kompkat
set relation to SUBSTR(compl,1,2)+SUBSTR(compl,4,2) into komplex
set skip to komplex

select anal 
set order to oir1
seek '---'
lc_class='F'
if p_class
  lc_class='T'
endif
if (drg_ext<>lc_kieli2 and lc_kieli2<>'---') or (lc_logic2<>trim(comment) and lc_logic2<>'---') or (lc_vers2<>lc_class and lc_vers2<>'---')
  set order to
  do groupdat
endif


select anal
set order to drg
et_kood=p_ldrg
do casesel with et_kood, 'F', 'N'
do luokitus
do analnayt
do analohje
RETURN
*: EOF: DGDRG.PRG

procedure selection
parameter lc_sel
use (lc_sel) alias anal
set filter to not deleted()
if at('_allrules',lc_sel)>0
  delete all for oir1='_miss' or id='_miss'
  pack
  set order to oir1
  seek '---'
  lc_kieli2=drg_ext
  lc_logic2=trim(comment)
  lc_vers2=trim(drg_ext2)
  replace drg_ext with ' ', comment with ' ', drg_ext2 with ' '
  p_allrules=.t.
endif
deactivate popup filesel
return

procedure language
parameter lc_lan
p_kieli=language.lan
deactivate popup lansel
return

procedure logisel
parameter selfile
USE (selfile) alias drglogic
deactivate popup logicsel
release popup logicsel
return
SELECT 0
define popup logicsel prompt files like ..\drg_n\drgl_*.dbf
on selection popup logicsel do logisel with prompt()
wait window 'Select the NordDRG version' nowait
activate popup logicsel at 5,10 
