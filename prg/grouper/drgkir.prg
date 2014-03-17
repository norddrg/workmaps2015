procedure drgkir
select anal
set fullpath on
lc_anal=dbf()
lc_drg=drgdistr.loc_drg
if not lc_drg>'   '
  wait window 'Select a valid DRG from DRGDISTR-file' nowait
  return
endif
lc_name='..\..\..\NDMS_testdata\DRG_'+trim(lc_drg)+'.dbf'
select anal
if drgdistr.n_cas>0
  wait window nowait 'Producing file '+trim(lc_drg)+'.dbf, this may take a long time'
  select anal
  goto top
  set safety off
  COPY TO (lc_name) FOR Anal.drg=trim(lc_drg) type FOXPLUS
  set safety on
  wait window nowait 'Creation of file DRG_'+trim(lc_drg)+'.dbf complete'
else
  wait window nowait 'No cases in DRG '+trim(lc_drg)+', no file is created'
endif
do grpohje
return