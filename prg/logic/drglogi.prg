PROCEDURE drglogi

release windows
close databases
set default to ..\logic
select 0
use ..\..\tabl_def\language
set order to lan
*perushak=substr(dbf(),1,at('\',dbf(),2))+'PRG\'
*SET DEFAULT TO (perushak+'LOGIC')
seek (p_kieli)
public p_kiehak
p_kiehak='..\..\ncsp\'+p_kieli+'\'
SELECT 0
USE ('..\..\tabl_def\'+language.lan+'\komplex.dbf') EXCLUSIVE
SET ORDER TO compl 

set default to ..\logic
Clear macros
CLEAR
SET NEAR ON
SET STATUS ON
SET TALK OFF
on key label pgup
on key label pgdn

SELECT 0
lc_val='..\drg_n\'+p_logic
use ('../../tabl_def/'+p_logic) alias drglogic
SET ORDER TO ord

select 0
use ('../../ncsp/'+p_kieli+'/csp')
set filter to not released
set order to code

SELECT 0
USE ('..\..\tabl_def\'+language.lan+'\drgdg.dbf') ALIAS dg EXCLUSIVE
SET ORDER TO code

select 0
use ('..\..\icd_10\'+p_kieli+'\icd_10') EXCLUSIVE noupdate
set order to code

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
USE ..\..\tabl_def\kompkat.dbf EXCLUSIVE
SET ORDER TO compl

SELECT 0
USE ..\..\tabl_def\mdc.dbf shared
SET ORDER TO mdc 

select drglogic
SELECT 0
lc_names='..\drg_n\names_'+p_kieli
use ('..\..\tabl_def\'+p_kieli+'\drgnames') alias drgnames
if p_kieli='Eng' or p_kieli='Dan'
  delete all
  pack
  append from ..\..\tabl_def\com\drgnames.dbf
endif
SET ORDER TO drg
replace all valid with .f.
SELECT drglogic
set ORDER to ord
set FILTER to inuse
set RELATION to drg INTO drgnames
replace all drgnames.valid with .t.

select 0
if p_kieli<>'Com'
  use ('..\..\tabl_def\com\drgnames') alias nam_oth
else
  use ('..\..\tabl_def\eng\drgnames') alias nam_oth
endif
set order to drg

select 0
use ..\..\tabl_def\pdgomin
set order to pdgprop


select 0
use ('..\..\tabl_def\'+p_kieli+'\drgtpt')
set filter to valid
set order to code

select 0
USE ..\..\icd_9\icd9cm_o.dbf EXCLUSIVE
SET ORDER TO Icd9_tp 
do logohje
select 0 
use ..\..\tabl_def\rtc.dbf
set order to code


public p_class
dl_loop=.t.
do while dl_loop
  p_class=.f.
  wait window 'Do you want to edit [C]lassic version or [F]ull version'
  if lastkey()=99 or lastkey()=67
    p_class=.t.
    exit
  endif
  if lastkey()=102 or lastkey()=70
    exit
  endif
enddo

SELECT drglogic
SET RELATION TO drg INTO drgnames
set relation to drg into nam_oth additive
set relation to rtc into rtc additive

DEFINE WINDOW drgnames FROM max_y/5,3 TO max_y/5+5,max_x TITLE 'DRGname - '+p_kieli FONT max_foty,  max_fosi 
DEFINE WINDOW drglogic FROM max_y/3,3 TO max_y,max_x TITLE 'DRG logic rules' FONT max_foty,  max_fosi 
DEFINE WINDOW drgsis FROM 0,max_x/4 to max_y,max_x TITLE 'Content of DRG group' FONT max_foty,  max_fosi double

select 0
use ('..\..\tabl_def\'+p_kieli+'\catomin')
set order to catomin
select drglogic
do ..\common\inuselis

* create textformat copies for checkup
SET SAFETY OFF
ERASE ('../../text/'+p_kieli+'/*.txt')
SELECT drglogic
SET ORDER TO ord
COPY TO ('../../text/'+p_kieli+'/'+p_logic+'.txt') DELIMITED WITH CHAR ';' 
LIST STRUCTURE TO ('../../text/'+p_kieli+'/'+p_logic+'_str.txt')  
SELECT csp
set order to code
COPY TO ('../../text/'+p_kieli+'/csp') DELIMITED WITH CHAR ';' 
LIST STRUCTURE TO ('../../text/'+p_kieli+'/csp_str')
SELECT dg
SET ORDER TO code
COPY TO ('..\..\text\'+language.lan+'\drgdg.txt') DELIMITED WITH CHAR ';'
LIST STRUCTURE TO ('../../text/'+p_kieli+'/drgdg_str')
SELECT icd_10
set order to code
COPY TO ('..\..\text\'+p_kieli+'\icd_10.txt') DELIMITED WITH CHAR ';'
LIST STRUCTURE TO ('../../text/'+p_kieli+'/icd_10_str')
SELECT dgkat
SET ORDER TO dgcat 
COPY TO ('..\..\text\'+p_kieli+'\dgkat.txt') DELIMITED WITH CHAR ';'
LIST STRUCTURE TO ('../../text/'+p_kieli+'/dgkat_str')
SELECT dgomin
SET ORDER TO dgprop
COPY TO ('..\..\text\'+p_kieli+'\dgomin.txt') DELIMITED WITH CHAR ';'
LIST STRUCTURE TO ('../../text/'+p_kieli+'/dgomin_str')
SELECT tpomin
SET ORDER TO procprop
COPY TO ('..\..\text\'+p_kieli+'\tpomin.txt') DELIMITED WITH CHAR ';'
LIST STRUCTURE TO ('../../text/'+p_kieli+'/tpomin_str')
SELECT kompkat 
SET ORDER TO compl
COPY TO ('..\..\text\'+p_kieli+'\kompkat.txt') DELIMITED WITH CHAR ';'
LIST STRUCTURE TO ('../../text/'+p_kieli+'/kompkat_str')
SELECT MDC
SET ORDER TO mdc 
COPY TO ('..\..\text\'+p_kieli+'\mdc.txt') DELIMITED WITH CHAR ';'
LIST STRUCTURE TO ('../../text/'+p_kieli+'/mdc_str')
SELECT drgnames
SET ORDER TO drg
COPY TO ('..\..\text\'+p_kieli+'\drgnames.txt') DELIMITED WITH CHAR ';'
LIST STRUCTURE TO ('../../text/'+p_kieli+'/drgnames_str')
SELECT pdgomin
set order to pdgprop
COPY TO ('..\..\text\'+p_kieli+'\pdgomin.txt') DELIMITED WITH CHAR ';'
LIST STRUCTURE TO ('../../text/'+p_kieli+'/pdgomin_str')
SELECT drgtpt
set order to code
COPY TO ('..\..\text\'+p_kieli+'\drgtpt.txt') DELIMITED WITH CHAR ';'
LIST STRUCTURE TO ('../../text/'+p_kieli+'/drgtpt_str')
SELECT rtc
set order to code
COPY TO ('..\..\text\'+p_kieli+'\rtc.txt') DELIMITED WITH CHAR ';'
LIST STRUCTURE TO ('../../text/'+p_kieli+'/rtc_str')
SET SAFETY ON


select drglogic
set order to ord
seek p_ord
do logohje
select drglogic
do lognaytto
RETURN
