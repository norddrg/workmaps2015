PROCEDURE ohje
pop key all
DEFINE WINDOW valikko FROM 1,1 TO max_y, 2*min_x FONT  max_foty,  max_fosi
ACTIVATE WINDOW valikko
CLEAR
select anal
set fullpath off
@ 0,2 SAY 'NORD-DRG - test database generator - file in use: '+ dbf()
@ 1,2 SAY 'Language: '+p_kieli+'   logic version: '+p_logic
set fullpath on
@ 3,2 say '[F12] - add one row'
@ 4,2 say '[Ctrl][F12] - change the row, [Alt][F12] - copy current row'
@ 5,2 say '[F11] - look at the file'
@ 6,2 say '[Ctrl][F11] - set order of the file'
@ 7,2 say '[Ctrl][N] - next case, [Ctrl][P]- previous case'
@ 8,2 say '[Alt][N] - next difference between DRG and DRG_EXT'
@ 9,2 say '[Alt][P] - previous difference between DRG and DRG_EXT'

@11,2 say '[F10] - look at the DRG-logic'
@12,2 say '[F9] - look at the rules  for diagnoses'
@13,2 say '[F8] - look at the rules for procedures'

@15,2 say '[F7] - check the whole anal-file starting from current record'
@16,2 say '[Ctrl][F7] - copy current file for transfer'
@17,2 say '[F6] - start testgrouper for external files'
@18,2 say '[Alt][F] - search for a case'

@20,2 say '[F4] - switch to procedure application'
@21,2 say '[F3] - switch to diagnosis application'
@22,2 say '[F2] - switch to DRG-logic table application'
@23,2 say '[Alt][F1] - restart the programme'
@24,2 say '[Ctrl][F1] - return to FoxPro'

on key label f12 do lisays 
on key label alt+f12 do kopio
on key label ctrl+f12 do esikas
on key label F11 do analkats
on key label ctrl+f11 do analjarj
on key label f10 do logiikka
on key label f9 do dgsaanto
on key label ctrl+f9 do dgsaanto
on key label alt+f9 do dgsaanto
on key label shift+f9 do dgsaanto
on key label f8 do tpsaanto
on key label ctrl+f8 do tpsaanto
on key label f7 do tarkasta
on key label ctrl+f7 do analsiir
on key label f6 do ..\grouper\_testgr
on key label alt+f do analetsi
on key label alt+c replace anal.comment with pb_comment

on key label ctrl+p do edell
on key label ctrl+n do seur

on key label alt+f1 do _drganal
on key label ctrl+f1 do lopetus
on key label f5 do kaantark
on key label ctrl+f5 do proctark
on key label alt+n do seur_ero
on key label alt+p do ede_ero

on key label f4 do vaihto
on key label f3 do vaihto
on key label f2 do vaihto
RETURN
*: EOF: OHJE.PRG
