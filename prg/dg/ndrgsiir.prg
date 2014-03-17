procedure NDRGSIIR
public p_tarkier
p_tarkier=0
select drglogic
public p_vers
p_vers=substr(dbf(),rat('\',dbf())+1,rat('.',dbf())-rat('\',dbf())-1)
lc_addon=' '
nds_loop=.t.
do while nds_loop
  p_class=.f.
  wait window 'Do you want to produce definition files for [C]lassic version or [F]ull version'
  if lastkey()=99 or lastkey()=67
    p_class=.t.
    exit
  endif
  if lastkey()=102 or lastkey()=70
    exit
  endif
enddo
select 0
do while nds_loop
  define popup filesel prompt files like ..\..\..\NDMS_testdata\*.dbf
  on selection popup filesel do selection with prompt()
  wait window nowait "Select a file to be added to the test database! File must have correct DRG's [Esc]-do not select any file"
  activate popup filesel at 5,10
  release popup filesel
  if lastkey()=27
    lc_addon=' '
    exit
  endif
  if at ('_out',lc_addon)>0
    wait window 'You may not select an output file!'
    loop
  endif
  exit
enddo
SELECT icd_10
goto Top
SELECT dg
SEEK icd_10.code
do ..\dg\dgdrg
do ..\dg\tark
PUSH KEY CLEAR
WAIT WINDOW 'Avaus' NOWAIT
DEFINE WINDOW apu FROM 5,10 to 20,40
if p_kieli<>'Com'
	SELECT 0
	USE ('..\..\tabl_def\com\drgtpt.dbf') ALIAS drgt_en
	set ORDER to code
endif
SELECT 0
USE ('..\..\tabl_def\'+p_kieli+'\drgtpt.dbf')
SELECT 0
USE ('..\..\tabl_def\link.dbf')
set order to ncsp
SELECT 0
lc_cspfile='..\..\ncsp\'+p_kieli+'\csp.dbf'
USE (lc_cspfile)
lc_tperror=.F.
do ..\csp\prtark WITH 'S'
if p_tarkier=0
	select csp
	p_lproc= trim(code)
	do ..\csp\ncsp
	return
endif
if p_kieli<>'Com'
	SELECT drgt_en
	USE
endif
do ..\common\inuselis

set SAFETY OFF
SELECT drgtpt
delete all for varval='99S90'
pack
SELECT dg
use
USE ('..\..\tabl_def\'+language.lan+'\drgdg.DBF') ALIAS dg EXCLUSIVE
set order to code
SELECT icd_10
use
use ('..\..\icd_10\'+language.lan+'\icd_10.dbf')
SET ORDER TO code
if p_kieli<>'Com'
*	do NDRGDIFF
endif
lc_siirto='..\..\..\transp\'+p_kieli
do LOGSIIR
do DGDIFF WITH 'o'
do DGSIIR
do CCSIIR
do cexdiff with 'o'
do CEXSIIR
do tpdiff WITH 'o'
do tpsiir
do DGKASIIR
do DGOMSIIR
do pdgpsiir
do tpomsiir
do rtcsiir
do testsiir
SELECT drgtpt
USE
SELECT icd_10
set FILTER to Valid AND NOT headline AND prim
COPY to (lc_siirto+'\ICD') TYPE foxplus FIELDS code, d_code, code_w, d_code_w, ast, text
COPY to (lc_siirto+'\icd.txt') DELIMITED WITH CHAR ';' FIELDS code, d_code, code_w, d_code_w, ast, text
LIST STRUCTURE TO (lc_siirto+'\icd_str.txt')
SELECT catomin
COPY to (lc_siirto+'\catomin') TYPE XLS

set CONSOLE on
set SAFETY on
WAIT WINDOW NOWAIT 'Loppu'
POP KEY
do dgdrg
return

	function point
		parameter fp_code
		re_code=fp_code
		if LEN(TRIM(fp_code))>3 AND SUBSTR(fp_code,4,1)<='9'
			re_code=SUBSTR(fp_code,1,3)+'.'+SUBSTR(fp_code,4,2)
		endif
		return re_code
	endfunc

	function unpoint
		parameter fp_code
		re_code=fp_code
		if AT('.', fp_code)>0
			re_code=SUBSTR(fp_code,1,3)+SUBSTR(fp_code,5,2)
		endif
		return re_code
	endfunc

procedure selection
parameter lc_sel
lc_addon=lc_sel
deactivate popup filesel
return
