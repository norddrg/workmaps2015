PROCEDURE ncsp

set default to ..\csp
if p_kieli='W'
  p_kieli='Com'
endif
clear
PUSH KEY CLEAR
close databases
use ..\..\tabl_def\language
set order to lan
*perushak=substr(dbf(),1,at('\',dbf(),2))+'PRG\'
* SET DEFAULT TO (perushak+'CSP')
public p_kiehak, p_procpr, p_dgomin
seek trim(p_kieli)
lc_hakem=language.hakem
p_procpr=space(5)
p_dgomin=space(5)
p_kiehak='..\..\ncsp\'+p_kieli+'\'
public p_tarkier
p_tarkier=0
on key label pgup
on key label pgdn
if max_x<60 or max_y<23
   wait window 'Liian pieni ikkuna, aloita uudestaan!'
   return
endif
set date to ymd
SET TALK OFF
SET NEAR ON
public  luv_y, luv_x, ryh_y, ala_y, kieli, pub_koodi, p_haku, lc_alku, lc_loppu, p_omin, p_order
p_omin=space(5)
p_haku=space(6)
lc_alku='ZZZ99'
lc_loppu='ZZZ99'
kieli='s'
lc_loop=.t.
p_order='N'

select 0
use ('..\..\tabl_def\'+p_logic) alias drglogic
SET ORDER TO ord
set filter to not deleted()

SELECT 0
USE ..\..\ncsp\com\ncsp_cha.dbf EXCLUSIVE
set order to code

SELECT 0
use ..\..\ncsp\com\ncsp_gro.dbf
set filter to not deleted()
set order to code

SELECT 0
use ..\..\ncsp\com\ncsp_sub.dbf
set filter to not deleted()
set order to code

select 0
use ('../../tabl_def/'+p_kieli+'/drgtpt')
set filter to valid
set order to code

select 0
use ('../../ncsp/'+p_kieli+'/csp')
set filter to not released
set order to code

if p_kieli<>'Com'
  select 0
  use ..\..\ncsp\com\csp alias csp_en
  set filter to not released
  set order to code
  select 0
  use ('..\..\tabl_def\com\drgtpt') alias drgt_en
  set filter to valid
  set order to code
else
  select 0
  use ..\..\tabl_def\eng\drgtpt alias drgt_oth
  select 0
  use ..\..\ncsp\eng\csp alias csp_oth
endif

select 0
use ..\..\tabl_def\tpomin
set order to procprop
set filter to not deleted()

select drglogic
SELECT 0
lc_names='..\drg_n\names_'+p_kieli
use ('..\..\tabl_def\'+p_kieli+'/drgnames')alias drgnames
SET ORDER TO drg

select 0
use ..\..\tabl_def\dgomin
set order to dgprop

SELECT drglogic
SET RELATION TO drg INTO drgnames

select csp
set filter to not released
set order to code
*set relation to code into drgtpt
*set skip to drgtpt
if p_kieli<>'Com'
  set relation to ncsp into csp_en additive
endif


select csp

luv_y=int(max_y/5)
if luv_y<6 
  luv_y=6
endif
ryh_y=2*luv_y
ala_y=3*luv_y
luv_x=int(0.6*max_x)

DEFINE WINDOW valikko FROM 0,0 TO max_y-3,luv_x-3 FONT  max_foty,  max_fosi
DEFINE WINDOW luvut FROM 0,3 TO luv_y,luv_x FONT  max_foty,  max_fosi
DEFINE WINDOW ryhmat FROM luv_y,3 TO ryh_y,luv_x FONT  max_foty,  max_fosi
DEFINE WINDOW alaryh FROM ryh_y,3 TO ala_y,luv_x FONT  max_foty,  max_fosi
DEFINE WINDOW koodit FROM ala_y,3 TO max_y,2*luv_x/3 FONT  max_foty,  max_fosi
DEFINE WINDOW drgtpt FROM ala_y,2*luv_x/3 TO max_y,luv_x FONT  max_foty,  max_fosi
DEFINE WINDOW tpomin FROM 0,luv_x TO max_y/2, max_x  FONT  max_foty, max_fosi Title 'Procedure properties'
DEFINE WINDOW dgomin FROM max_y/2,luv_x TO max_y, max_x  FONT  max_foty, max_fosi Title 'Diagnosis properties'


do ..\csp\cspohje

select csp
if p_kieli='Com'
  seek trim(p_lproc)
else
  set order to ncsp
  seek trim (p_lproc)
  set order to code
endif

do ..\csp\cspnaytto
RETURN
*: EOF: ICDSUOM.PRG

