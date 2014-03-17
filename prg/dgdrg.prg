*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\DGDRG.PRG
*:
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	Nordic Centre for Classification of Diseases
*:	
*:	Nordic Centre for Classification of Diseaes
*:	NordDRG Maintenance system
*:	
*:
*: Documented using Visual FoxPro Formatting wizard version  .05
*:******************************************************************************
*:   dgdrg
*!******************************************************************************
*!
*! Procedure DGDRG
*!
*!  Calls
*!      AT
*!      DBF
*!      INT
*!      RAT
*!      SUBSTR
*!
*!******************************************************************************
procedure dgdrg
	CLOSE DATABASES
	set default to ..\dg
	USE ..\..\tabl_def\language
	set ORDER to lan
	SEEK p_kieli
	SELECT 0
	lc_val='..\..\tabl_def\'+p_logic
	USE (lc_val) ALIAS drglogic
	CLEAR MACROS
	set near on
	set status on
	set TALK OFF
	set date 'YMD'
	on KEY label pgup
	on KEY label pgdn
	public min_y, min_x
	min_y=INT(max_y/6)
	if min_y<5
		min_y=5
	endif
	min_x=INT(max_x/3)
	public ctrl_t

public apu_dcode
public p_logluku
p_logluku=.f.
apu_dcode=space(6)

DEFINE WINDOW kymppi FROM 0,3 to 3*min_y, 2*min_x FONT  max_foty,  max_fosi TITLE 'ICD-10 - '+ p_kieli
DEFINE WINDOW dg FROM 3*min_y,3 to max_y, max_x/2 FONT  max_foty,  max_fosi TITLE 'Procedures and categories - '+ p_kieli
DEFINE WINDOW pdgprop FROM 0,2*min_x to min_y,max_x FONT  max_foty,  max_fosi TITLE 'PDGPROP'
DEFINE WINDOW dgkat FROM min_y,2*min_x to 2*min_y,max_x FONT  max_foty,  max_fosi TITLE 'DGCAT'
DEFINE WINDOW dgomin FROM 2*min_y,2*min_x to 3*min_y,max_x FONT  max_foty,  max_fosi TITLE 'DGPROP'
DEFINE WINDOW tpomin FROM 3*min_y,2*min_x to 4*min_y,max_x FONT  max_foty,  max_fosi TITLE 'PROCPROP'
DEFINE WINDOW kompkat FROM 4*min_y, 2*min_x to 5*min_y, max_x FONT  max_foty,  max_fosi TITLE 'COMPL'
DEFINE WINDOW komplex FROM 5*min_y,2*min_x to max_y, max_x FONT  max_foty,  max_fosi TITLE 'COMPL - exclusions'
DEFINE WINDOW omin FROM min_y, 0 to max_y-min_y, 2*min_x FONT  'Arial', 8 Style 'B' TITLE 'CHANGES'

do dgohje

SELECT 0
USE ..\..\icd_9\icd10to9
set ORDER to code
SELECT 0
use ('..\..\icd_10\'+language.lan+'\icd_10.dbf')
select 0
USE ('..\..\tabl_def\'+language.lan+'\drgdg.DBF') ALIAS dg EXCLUSIVE
set order to code
SELECT 0
USE ('..\..\tabl_def\'+language.lan+'\komplex.DBF') EXCLUSIVE
set ORDER to compl
if p_kieli<>'Com'
  SELECT 0
  use ..\..\icd_10\com\icd_10.dbf alias icd_oth
  set filter to valid
  set order to code
  select 0
  USE ..\..\tabl_def\com\drgdg.DBF EXCLUSIVE alias dg_oth
  set filter to valid
  set order to code
  SELECT 0
  USE ..\..\tabl_def\com\komplex.DBF EXCLUSIVE alias komplex_oth
  set filter to valid
  set ORDER to compl
else
  SELECT 0
  use ..\..\icd_10\eng\icd_10.dbf alias icd_oth
  set  filter to valid
  set order to code
  select 0
  USE ..\..\tabl_def\eng\drgdg.DBF EXCLUSIVE alias dg_oth
  set filter to valid
  set order to code
  SELECT 0
  USE ..\..\tabl_def\eng\komplex.DBF EXCLUSIVE alias komplex_oth
  set filter to valid
  set ORDER to compl
ENDIF
SELECT komplex 
SET FILTER TO SUBSTR(compl,3,1)<>'C'
replace ALL compl WITH SUBSTR(compl,1,2)+'C'+SUBSTR(compl,4,2)
SET FILTER TO valid
SELECT dg
SEEK p_ldg
SELECT icd_10
set ORDER to code
set FILTER to Valid AND prim AND NOT headline
set RELATION to code+d_code INTO icd10to9
SEEK p_ldg

SELECT 0
USE ..\..\tabl_def\dgkat.DBF EXCLUSIVE
set ORDER to dgcat

SELECT 0
USE ..\..\tabl_def\pdgomin.DBF EXCLUSIVE
set ORDER to pdgprop

SELECT 0
USE ..\..\tabl_def\dgomin.DBF EXCLUSIVE
set ORDER to dgprop

SELECT 0
USE ..\..\tabl_def\tpomin.DBF EXCLUSIVE
set ORDER to procprop

SELECT 0
USE ..\..\tabl_def\kompkat.DBF EXCLUSIVE
set ORDER to compl

SELECT 0
USE ..\..\tabl_def\mdc.DBF SHARED
set ORDER to mdc

SELECT 0
USE ('..\..\tabl_def\'+language.lan+'\drgnames')
set ORDER to drg

SELECT drglogic
set RELATION to drg INTO drgnames

SELECT 0
USE ('..\..\tabl_def\'+p_kieli+'\catomin')
set ORDER to catomin

do dgnaytto

return

procedure logisel
parameter selfile
USE (selfile) ALIAS drglogic
Deactivate POPUP logicsel
release POPUP logicsel
return
