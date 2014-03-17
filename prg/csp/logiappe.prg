PROCEDURE logiappe
SELECT drglogic
lc_jarj=jarj
lc_drg=drg
APPEND BLANK
REPLACE jarj WITH lc_jarj, drg WITH lc_drg
DO muutlogi
RETURN
*: EOF: LOGIAPPE.PRG
