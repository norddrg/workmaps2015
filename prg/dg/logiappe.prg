*:*****************************************************************************
*:
*: Procedure file: D:\DATA\DRG_N\LOGIAPPE.PRG
*:         System: NORD-DRG, dg-osuus
*:         Author: M.Virtanen
*:      Copyright (c) 2/8/95, MV Health Care Consulting Oy
*:  Last modified: 08/01/95 at  8:11:06
*:
*:  Procs & Fncts: LOGIAPPE
*:
*:      Documented 01:19:38                                FoxDoc version 3.00a
*:*****************************************************************************
*!*****************************************************************************
*!
*!      Procedure: LOGIAPPE
*!
*!      Called by: MUUTLOGI           (procedure in MUUTLOGI.PRG)
*!
*!          Calls: MUUTLOGI           (procedure in MUUTLOGI.PRG)
*!
*!*****************************************************************************
PROCEDURE logiappe
SELECT drglogic
set order to ord
lc_jarj=ord
lc_drg=drg
APPEND BLANK
REPLACE ord WITH lc_jarj, drg WITH lc_drg
seek lc_jarj
SELECT drgnames
BROWSE WINDOW drgnames NOWAIT SAVE FIELDS mdc, drg,finish:75,english:75
SELECT drglogic
SET FILTER TO NOT DELETED()
BROWSE WINDOW drglogic NOWAIT SAVE FIELDS ord, drg, drgnames.english:40,icd,mdc,pdgprop, or,procpro1,procpro2,procpro3,dgcat1,dgcat2,agelim,compl,;
   sex,dgprop1,dgprop2, dgprop3, dgprop4, secproc1, other
RETURN
*: EOF: LOGIAPPE.PRG
