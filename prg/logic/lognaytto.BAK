procedure lognaytto

deactivate window drgsis
release window apuikk
if alias()='DRGNAMES'
  select drglogic
  set order to drg
  seek drgnames.drg
endif
select drgnames
set order to drg
set filter to valid
select drglogic
select drglogic
set filter to (valid and inuse)
set relation to drg into drgnames
set relation to drg into nam_oth additive
set relation to rtc into rtc additive

SELECT drgnames
BROWSE WINDOW drgnames NOEDIT NODELETE NOWAIT SAVE FIELDS local_drg=drgnames.loc_drg, drgnames.mdc, local_drgname=drgnames.drgname:75, Other_name=nam_oth.drgname:75, drgnames.chdate:6
select drglogic
BROWSE WINDOW drglogic NOEDIT NOWAIT SAVE FIELDS ord, drg, text=(drgnames.drgname):40,icd,mdc,pdgprop, or, procpro1, dgcat1, agelim, compl,;
sex,dgprop1,dgprop2, dgprop3, dgprop4, secproc1, disch, icu, dur, rtc:2, rtc.eng:30, chdate:6, inuse:2
p_ldrg=drg
p_ord=ord
return