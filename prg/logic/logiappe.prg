PROCEDURE logiappe
DEFINE WINDOW apuikk FROM max_y/5+6,1 TO max_y, max_x FONT  max_foty,  max_fosi Title alias()+ ': [CTRL][B] - change current record, [Ctrl][W] - return to basic window'
ACTIVATE WINDOW apuikk
SELECT drglogic
set order to ord
lc_jarj=ord
lc_drg=drg
lc_mdc=mdc
lc_icd=icd
lc_or=or
lc_procpro1=procpro1
lc_dgcat1=dgcat1
lc_agelim=agelim
lc_compl=compl
lc_sex=sex
lc_pdgprop=pdgprop
lc_dgprop1 =dgprop1
lc_dgprop2 =dgprop2
lc_dgprop3 =dgprop3
lc_dgprop4 =dgprop4
lc_secproc1= secproc1
lc_death=death
lc_disch=disch
lc_icu=icu
lc_dur=dur
lc_rtc=rtc
APPEND BLANK
REPLACE ord WITH lc_jarj, drg WITH lc_drg, icd with lc_icd, mdc with lc_mdc, or with lc_or, procpro1 with lc_procpro1,;
dgcat1 with lc_dgcat1, agelim with lc_agelim, compl with lc_compl, sex with lc_sex, dgprop1 with lc_dgprop1,;
dgprop2 with lc_dgprop2, dgprop3 with lc_dgprop3, dgprop4 with lc_dgprop4, icu with lc_icu,;
rtc with lc_rtc, secproc1 with lc_secproc1, pdgprop with lc_pdgprop, disch with lc_disch, dur with lc_dur, rtc with lc_rtc
replace inuse with .t.
replace chdate with date(), valid with .t.
lc_recno=recno()
set filter to recno()=lc_recno
edit
set filter to
release window apuikk
seek lc_jarj
DO naytto
RETURN
*: EOF: LOGIAPPE.PRG
