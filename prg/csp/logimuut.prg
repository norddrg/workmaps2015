PROCEDURE logimuut
DEFINE WINDOW drgnames FROM luv_y,3 TO ryh_y, max_x TITLE 'DRGnimet' FONT max_foty,  max_fosi 
DEFINE WINDOW drglogic FROM ryh_y,3 TO max_y,max_x TITLE 'DRG:n loogiset säännöt' FONT max_foty,  max_fosi 

ACTIVATE WINDOW valikko
CLEAR
@ 0,0 SAY 'DRG-projekti - logiikka taulun käsittely'
@ 2,0 SAY '[F11] päivitä näyttö'
@ 3,0 SAY '[Alt][B] lisää rivi logiikkatauluun'
@ 4,0 SAY '[F9] vaihda järjestys jarj/drg/mdc'

@ 6,0 SAY 'Merkitse poistettavat hiirellä'

@ 8,0 SAY '[F7] palaa perusnäyttöön'


ON KEY LABEL f12
ON KEY LABEL alt+f12
ON KEY LABEL alt+x
ON KEY LABEL f10
ON KEY LABEL ctrl+f9
ON KEY LABEL alt+f9
ON KEY LABEL f8
ON KEY LABEL alt+f8
ON KEY LABEL ctrl+s
ON KEY LABEL ctrl+f1
ON KEY LABEL alt+f1
ON KEY LABEL ctrl+t
ON KEY LABEL ctrl+i
ON KEY LABEL alt+i
ON KEY LABEL ctrl+K
ON KEY LABEL alt+K
ON KEY LABEL alt+A
ON KEY LABEL alt+l

ON KEY LABEL f7 DO logipal
ON KEY LABEL f11 DO muutlogi
ON KEY LABEL f9 DO logijarj
ON KEY LABEL alt+B DO logiappe
ON KEY LABEL ctrl+B DO apuikk WITH .T.

select drglogic
set order to jarj

SELECT drgnames
BROWSE WINDOW drgnames NOWAIT SAVE FIELDS mdc, drg,nimike:75,name:75, note
SELECT drglogic
SET FILTER TO NOT DELETED()
BROWSE WINDOW drglogic NOWAIT SAVE FIELDS jarj, drg, drgnames.nimike:40,icd,mdc,or, tp1,tp2,tp3,dgkat1,dgkat2,ikaraja,kompl,;
   sex,dgomin1,dgomin2,stp1,stp2,exitus
RETURN
*: EOF: MUUTLOGI.PRG
