procedure _ncsp

set default to ..\csp
on error
PUSH KEY CLEAR
CLOSE DATABASES
CLEAR WINDOWS
set fullpath on
set date YMD
public max_y, max_x, max_foty, max_fosi, p_class, p_ord
p_class=.f.
p_ord='00'
max_y=srows()-3
max_x=scols()-4
max_foty='Small Font'
max_fosi=6
if max_x>100
  max_foty='Arial'
  max_fosi=8
endif
public p_kieli
on error do pldg
? p_ldg
on error do plproc
? p_lproc
on error do pldrg
? p_ldrg
on error
use ..\..\tabl_def\language
set order to lan
define popup lansel prompt field name
on selection popup lansel do language with prompt()
wait window nowait 'Choose the language!'
activate popup lansel at 5,10
release popup lansel
do ..\common\logicsel
do ncsp
return

procedure language
parameter lc_lan
p_kieli=language.lan
deactivate popup lansel
return

Procedure pldrg
public p_ldrg
p_ldrg='470'
return

Procedure pldg
public p_ldg
p_ldg='A00.0'
return

Procedure plproc
public p_lproc
p_lproc='AAA00'
return