PROCEDURE testgr
set default to ..\grouper
pop key all
t_alku0=val(sys(2))
t_alku=val(sys(2))
t_loppu=val(sys(2))
public p_allrules
p_allrules=.f.
p_class=.f.
release windows
Close databases
Clear macros
CLEAR
SET NEAR ON
SET STATUS ON
SET TALK OFF
set safety off
set date ymd
public min_y, min_x
min_y=int(max_y/6)
if min_y<5
  min_y=5
endif
min_x=int(max_x/3)
PUBLIC ctrl_t
public p_ika
p_ika='D'
public p_logic
p_logic=space(8)
PUBLIC p_grp
p_grp=.f.
public p_logluku
p_logluku=.f.
DEFINE WINDOW syotto FROM 0,3 TO min_y, max_x FONT  'COURIER NEW',  8
DEFINE WINDOW anal FROM min_y,1 TO max_y-3, max_x FONT  max_foty,  max_fosi

SELECT 0
use ..\..\tabl_def\language
set order to lan

lc_casenn='??'
public p_kieli
p_kieli='---'
public p_logic
p_logic='---'
public ds_datasel
ds_datasel=space (10)
public ds_datase2
ds_datase2=space (10)
PUBLIC ds_parts
ds_parts=.f.
do datasel

select 0
on error do lan_ver
ds_data =substr(ds_datasel,rat('\',ds_datasel)+1,len(ds_datasel))
if at('_', ds_data)>0
  ds_data=SUBSTR(ds_data,1,AT('_',ds_data)-1)
  ds_parts=.t.
endif
use ('..\..\..\..\NDMS_testout\'+ds_data+'_out.dbf') alias drgdistr
on error
if p_kieli='---'
  p_kieli=trim(drg)
endif
if p_logic='---'
  p_logic=trim(mdc)
endif

select 0
use ('..\..\icd_10\'+p_kieli+'\icd_10') EXCLUSIVE 
set order to code

SELECT 0
USE ('..\..\tabl_def\'+p_kieli+'\komplex.dbf') EXCLUSIVE
SET ORDER TO compl 

SELECT 0
USE ..\..\tabl_def\kompkat.dbf EXCLUSIVE
SET ORDER TO compl 

select 0
use ('..\..\tabl_def\'+p_kieli+'\drgtpt')
set filter to valid
set order to code

SELECT 0
USE ..\..\tabl_def\dgomin.dbf EXCLUSIVE
SET ORDER TO dgprop

select 0
use ('..\..\tabl_def\tpomin')
set filter to valid
set order to procprop

SELECT 0
USE ('..\..\tabl_def\'+p_kieli+'\drgdg.dbf') ALIAS dg EXCLUSIVE
SET ORDER TO code

select 0
use ('../../ncsp/'+p_kieli+'/csp.dbf') alias ncsp_en
SET ORDER TO code
select drgtpt
set filter to not deleted() and code<>' '

select 0
USE ('..\..\tabl_def\'+p_kieli+'\drgnames.dbf') ALIAS drgnames EXCLUSIVE
set order to drg
set filter to valid

select 0
use ('..\..\tabl_def\'+p_kieli+'\catomin')
set order to catomin

select 0
on error do repstart
select drgdistr
*ds_data =substr(ds_datasel,rat('\',ds_datasel)+1,len(ds_datasel))
*use ('..\..\..\NDMS_testout\'+ds_data+'_out.dbf') alias drgdistr
on error
select drgdistr
set order to drg
goto bottom
if nam_sho='Total'
  p_kieli=TRIM(drg)
  if mdc<>' '
    p_logic='DRGL_'+trim(mdc)+'.DBF'
    SELECT 0
    USE ('..\..\tabl_def\'+p_logic) ALIAS DRGLOGIC
  else
    do ..\common\logicsel
    select drgdistr
    replace mdc with substr (p_logic, at('_',p_logic)+1, at('.',p_logic)-at('_',p_logic)-1)
  endif
else
  do ..\common\langsel
  select drgdistr
  replace loc_drg with p_kieli
  do ..\common\logicsel
  select drgdistr
  replace mdc with substr (p_logic, at('_',p_logic)+1, at('.',p_logic)-at('_',p_logic)-1)
endif

*public p_class
dl_loop=.t.
do while dl_loop
  p_class=.f.
  wait window 'Do you want to use [C]lassic or [F]ull version'
  if lastkey()=99 or lastkey()=67
    p_class=.t.
    exit
  endif
  if lastkey()=102 or lastkey()=70
    exit
  endif
enddo
do ..\common\inuselis

select kompkat
set relation to SUBSTR(compl,1,2)+SUBSTR(compl,4,2) into komplex
set skip to komplex

select drgdistr
do grpohje

return

procedure repstart
select 0
use ..\w_stru.dbf
copy to ('..\..\..\..\NDMS_testout\'+ds_data+'_out.dbf') with cdx
use ('..\..\..\..\NDMS_testout\'+ds_data+'_out.dbf') alias drgdistr
set order to drg
append blank
if p_kieli='---'
  do ..\common\langsel
endif
if p_logic='---'
  do ..\common\logicsel
endif
select drgdistr
replace drg with p_kieli, nam_sho with 'Total', valid with .t., mdc with substr (p_logic, at('_',p_logic)+1, at('.',p_logic)-at('_',p_logic)-1), loc_drg with p_kieli
select 0
if p_kieli<>'Com'
  use ('..\..\tabl_def\com\drgnames.dbf') alias secnames
else
  use ('..\..\tabl_def\den\drgnames.dbf') alias secnames
endif
set order to drg
select drgdistr
append from ('..\..\tabl_def\com\drgnames.dbf') fields drg, loc_drg, mdc, nam_sho
if p_kieli<>'Com'
  set filter to drg<'A'
  set relation to drg into drgnames
  replace all loc_drg with drgnames.loc_drg
endif
select drglogic
set order to drg
select drgdistr
set relation to drg into drglogic
replace all sur with drglogic.OR
replace all proc with substr(drglogic.procpro1,3,1)
replace all short with drglogic.dur
replace ALL compl WITH drglogic.compl
set filter to
do grpohje
select drglogic
use
return

procedure lan_ver
do ..\common\langsel
do ..\common\logicsel
return