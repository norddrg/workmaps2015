procedure csp_upda
select csp
set relation to
set filter to
delete all
lc_string='c:\data\ncsp_'+language.lan+'.dbf'
on error do _ncsp
SELECT csp
append from (lc_string)
SELECT csp
pack
replace all released with .f.
if p_kieli='Com'
  select csp
  replace all ncsp with code
endif
select ncsp_cha
set filter to
delete all
lc_string='c:\data\com_luv.dbf'
append from (lc_string)
pack
select ncsp_gro
set filter to
delete all
lc_string='c:\data\com_ryh.dbf'
append from (lc_string)
pack
select ncsp_sub
set filter to
delete all
lc_string='c:\data\com_ala.dbf'
append from (lc_string)
pack
on error

*select 0
*use ('../../ncsp/ncsp_plus.dbf') 
*delete all
*pack
*append from c:\data\ncsp_plus.dbf
*set order to ncsp
*use

select csp
lc_csp=dbf()
USE
DO CASE 
CASE p_kieli='Fin' 
*  use c:\data\atc
*  set filter to usedate<date()+365 and (reldate>date()+365 or reldate=ctod(space(8))) AND LEN(TRIM(atc))>5
*  GOTO TOP 
*  do while not eof()
* 	INSERT INTO (lc_csp) (code, ncsp, text, released, tehty, usedate) VALUES (substr(atc.atc,3,5), substr(atc.atc,1,5), atc.atc+' - '+atc.finish, .f., .t.,date())
*	skip
*  enddo
  USE (lc_csp)
CASE p_kieli='Nor' 
  USE (lc_csp)
OTHERWISE 
  use('../../ncsp/atc.dbf') alias atc
  set filter to len(trim(c2))=5
  GOTO top
  do while not eof()
 	INSERT INTO (lc_csp) (code, ncsp, text, released, tehty, usedate) VALUES (atc.c2, atc.c2, atc.c6, .f., .t.,date())
	skip
  enddo  
ENDCASE 
select csp
delete all for code=' '
pack
do ncsp
return
