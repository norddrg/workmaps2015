Procedure readwe
wait window nowait "Inserting weights to database"
ds_twosel=' '
select 0
define popup filesel prompt files like ..\..\..\NDMS_testdata\*.dbf
on selection popup filesel do selection with prompt()
wait window nowait 'Select the file!'
activate popup filesel at 5,10
release popup filesel
if lastkey()=27
  return
endif

on error do grpohje

select 0
ds_two =substr(ds_twosel,rat('\',ds_twosel)+1,len(ds_twosel))
ds_two=substr(ds_two,1,at('.',ds_two)-1)
use ('..\..\..\NDMS_testout\'+ds_two+'_out.dbf') alias drgdis2
set relation to loc_drg into drgdistr
replace all drgdistr.weight with drgdis2.weight, drgdistr.w2trim with drgdis2.weight
select drgdis2
use
on error
do grpohje
return



procedure selection
parameter lc_sel
ds_twosel=lc_sel
*ds_datasel =substr(ds_datasel,rat('\',ds_datasel)+1,len(ds_datasel))
deactivate popup filesel
return
