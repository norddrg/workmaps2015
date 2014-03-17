Procedure koodets
define window koodi from 5,5 to 15,80 FONT  max_foty,  max_fosi
activate window koodi
@ 2,1 say 'Give the NCSP-code you want to find'
@ 3,5 get p_haku
read
release window koodi
p_haku=Upper(p_haku)

SELECT csp
use ('../../ncsp/'+p_kieli+'/csp')
set filter to not released
set order to code

do ..\csp\etsi with p_haku
select csp
do ..\csp\cspnaytto
return