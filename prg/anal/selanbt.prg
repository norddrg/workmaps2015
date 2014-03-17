procedure selanbt
pop key all
DEFINE WINDOW valikko FROM 1,1 TO max_y, 2*max_x/3 FONT  max_foty,  max_fosi
ACTIVATE WINDOW valikko
CLEAR
lc_loop=.t.
@ 1,2 SAY 'NORD-DRG - test database generator and test batch grouper'
@ 3,2 SAY 'Test database generator tests the DRG assignment in single cases and creates a database for further testing'
@ 4,2 SAY 'Test database batch grouper greates a simple dBase file from testdata and performs grouping to the file'
@ 6,2 SAY "Select the working form by pushing 'B' for batch grouper or 'G' for testdatabase generator"
do while lc_loop
  wait window 'Select the working form'
  if lastkey()=66 or lastkey()=98 or lastkey()=73 or lastkey()=103
    exit
  endif
  @ 8,2 SAY "You have to select either 'B'  or 'G'!"
enddo
return