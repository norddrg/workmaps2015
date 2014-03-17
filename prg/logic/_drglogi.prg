procedure _drglogi

set default to ..\logic
if alias()='DRGLOGIC'
  p_ldrg=drg
endif
PUSH KEY CLEAR
CLOSE DATABASES
CLEAR WINDOWS
set date YMD
SET FULLPATH ON
*on key label enter do a__2
*do \foxproc\scrsize
public max_y, max_x, max_foty, max_fosi, p_class, p_allrules
p_allrules=.f.
max_y=srows()-3
max_x=scols()-4
max_foty='Small Font'
max_fosi=6
max_foty='Small Font'
max_fosi=6
if max_x>100
  max_foty='Arial'
  max_fosi=8
endif
p_class=.f.

on error do pord
? p_ord
on error do pldg
? p_ldg
on error do plproc
? p_lproc
on error do pldrg
? p_ldrg
on error

do ..\common\langsel

do ..\common\logicsel

do drglogi
return

procedure language
parameter lc_lan
p_kieli2=lc_lan
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

Procedure pord
public p_ord
p_ord='00'
return