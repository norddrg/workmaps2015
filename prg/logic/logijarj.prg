*:*****************************************************************************
*:
*: Procedure file: D:\DATA\DRG_N\LOGIJARJ.PRG
*:         System: NORD-DRG, dg-osuus
*:         Author: M.Virtanen
*:      Copyright (c) 2/8/95, MV Health Care Consulting Oy
*:  Last modified: 08/01/95 at  8:06:22
*:
*:  Procs & Fncts: LOGIJARJ
*:
*:      Documented 01:19:37                                FoxDoc version 3.00a
*:*****************************************************************************
*!*****************************************************************************
*!
*!      Procedure: LOGIJARJ
*!
*!      Called by: MUUTLOGI           (procedure in MUUTLOGI.PRG)
*!
*!          Calls: MUUTLOGI           (procedure in MUUTLOGI.PRG)
*!
*!*****************************************************************************
PROCEDURE logijarj
SELECT drglogic
lc_order=ORDER()
DO CASE
CASE lc_order='DRG'
   SET ORDER TO mdc
   WAIT WINDOW 'Ordered by: '+ORDER() NOWAIT
CASE lc_order='MDC'
   SET ORDER TO ord
   WAIT WINDOW 'Ordered by: LOGIC' NOWAIT
CASE lc_order='ORD'
   SET ORDER TO drg
   WAIT WINDOW 'Ordered by: '+ORDER() NOWAIT
OTHERWISE
   SET ORDER TO ord
ENDCASE
SELECT drgnames
BROWSE WINDOW drgnames NOEDIT NODELETE NOWAIT SAVE FIELDS local_drg=drgnames.loc_drg, drgnames.mdc, local_drgname=drgnames.drgname:75, Other_name=nam_oth.drgname:75, drgnames.chdate:6
SELECT drglogic
SELECT drglogic
SET FILTER TO NOT DELETED()
do lognaytto
RETURN
*: EOF: LOGIJARJ.PRG
