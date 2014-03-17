*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\EXCLMAAR.PRG
*:
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	Nordic Centre for Classification of Diseases
*:	
*:	Nordic Centre for Classification of Diseaes
*:	NordDRG Maintenance system
*:	
*:
*: Documented using Visual FoxPro Formatting wizard version  .05
*:******************************************************************************
*:   exclmaar
*!******************************************************************************
*!
*! Procedure EXCLMAAR
*!
*!  Calls
*!      ALIAS
*!      LASTKEY
*!      NOT
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      date
*!      found
*!
*!******************************************************************************
procedure exclmaa2
dimension om_lval (1,1)
dimension om_wval (1,1)
on KEY label ctrl+j
DEFINE WINDOW sumexcl FROM 2,max_x/10 to max_y-15,max_x-5 TITLE 'Summary of CC exclusions' FONT 'Courier New',8
Activate WINDOW sumexcl
lc_alias=ALIAS()
SELECT kompkat
lc_cc=compl
SELECT dg
SEEK lc_oir+lc_eti
SELECT icd_10
SEEK lc_oir+lc_eti
if NOT found()
	lc_text='Not '+TRIM(language.Name) +' code'
	SEEK lc_oir
	if found()
		lc_text=TRIM(text)
	endif
	SEEK lc_eti
	if found()
		lc_text=lc_text+'; '+TRIM(text)
	ELSE
		lc_text='Not '+TRIM(language.Name) +' code'
	endif
ELSE
	lc_text=TRIM(text)
endif
lc_loop=.T.
do WHILE lc_loop
	CLEAR
	? lc_oir AT 1
	if lc_eti<>' '
		?? '* '+lc_eti AT 7
	endif
	?? lc_text AT 15
	?
	SELECT dg
	set ORDER to code
	SEEK lc_oir+lc_eti+'COMPL'
	if found()
		? 'Belongs to complication category:'
		? varval AT 10
		SELECT kompkat
		SEEK SUBSTR(dg.varval,1,2)+SUBSTR(dg.varval,4,2)
		?? TRIM(english) AT 17
	endif
	SELECT komplex
	set ORDER to code
	set FILTER to
	SEEK lc_oir+lc_eti
	if lc_eti<>' ' AND NOT found()
		SEEK lc_oir+' '
		if NOT found()
			SEEK lc_eti+' '
		endif
	endif
	?
	if NOT found()
		? 'As main diagnosis complicated by any CC-category' AT 1
	ELSE
		if lc_cc=' '
			lc_cc=komplex.compl
		endif
		? "As main diagnosis not complicated by dg's in CC category:" AT 1
	endif
	lc_n=0
	do WHILE code=lc_oir AND d_code=lc_eti
		lc_n=lc_n+1
		? compl AT 10
		SELECT kompkat
		SEEK SUBSTR(komplex.compl,1,2)+SUBSTR(komplex.compl,4,2)
		?? TRIM(english) AT 17
		SELECT catomin
		SEEK komplex.compl
		if NOT found()
			SEEK (SUBSTR(komplex.compl,1,2)+'C'+ SUBSTR(komplex.compl,4,2))
		endif
		if NOT inuse OR NOT found()
			?? '*' AT 9
		endif
		if NOT komplex.Valid
			?? '#' AT 9
		endif
		if lc_n=15
			lc_n=0
			WAIT WINDOW 'To continue, push any key'
		endif
		SELECT komplex
		SKIP
	ENDDO
	if lc_eti<>' '
		SEEK lc_oir
		lc_n=0
		do WHILE code=lc_oir AND d_code=' '
			if lc_n=0
				? lc_oir AT 1
			ELSE
				?
			endif
			lc_n=lc_n+1
			?? compl AT 10
			SELECT kompkat
			SEEK SUBSTR(komplex.compl,1,2)+SUBSTR(komplex.compl,4,2)
			?? TRIM(english) AT 17
			if lc_n=15
				lc_n=0
				WAIT WINDOW 'To continue, push any key'
			endif
			SELECT komplex
			SKIP
		ENDDO
		SEEK lc_eti
		lc_n=1
		do WHILE code=lc_eti AND d_code=' '
			if lc_n=0
				? lc_eti AT 1
			ELSE
				?
			endif
			?? compl AT 10
			SELECT kompkat
			SEEK SUBSTR(komplex.compl,1,2)+SUBSTR(komplex.compl,4,2)
			?? english AT 17
			if lc_n=15
				lc_n=0
				WAIT WINDOW 'To continue, push any key'
			endif
			lc_n=lc_n+1
			SELECT komplex
			SKIP
		ENDDO
	endif
	SELECT komplex
	SEEK lc_oir+lc_eti+ SUBSTR(lc_cc,1,2)+SUBSTR(lc_cc,4,2)
	if lc_eti<>' ' AND NOT found()
		SEEK lc_oir + SPACE(6)+ SUBSTR(lc_cc,1,2)+SUBSTR(lc_cc,4,2)
		if NOT found()
			SEEK lc_eti + SPACE(6) + SUBSTR(lc_cc,1,2)+SUBSTR(lc_cc,4,2)
		endif
	endif
	?
	? 'Select CC-category [Ctrl][W], remove CC-category [Esc], finish [Ctrl][K]'
	on KEY label ctrl+K do exclclos
	SELECT kompkat
	SEEK SUBSTR(lc_cc,1,2)+SUBSTR(lc_cc,4,2)
	BROWSE WINDOW dg noedit nodelete FIELDS compl, inclprop, english, finish
	if LASTKEY()=11
		USE ..\..\tabl_def\kompkat.DBF EXCLUSIVE
		set ORDER to compl
		SELECT komplex
		SKIP -1
		on KEY label ctrl+K do exclmaar
		EXIT
	endif
	lc_cc=kompkat.compl
	SELECT komplex
	if LASTKEY()=27
		SEEK lc_oir+lc_eti+SUBSTR(lc_cc,1,2)+SUBSTR(lc_cc,4,2)
		if found()
			REPLACE Valid WITH .F.
		endif
		lc_cc='     '
	ELSE
		if lc_cc=' '
			wait window 'Select a CC-category' nowait
		else
			set FILTER to
			SEEK lc_oir+lc_eti+SUBSTR(lc_cc,1,2)+SUBSTR(lc_cc,4,2)
			if NOT found()
				SEEK SUBSTR(lc_cc,1,2)+SUBSTR(lc_cc,4,2)+lc_oir
				if NOT found()
					SEEK SUBSTR(lc_cc,1,2)+SUBSTR(lc_cc,4,2)+lc_eti
				endif
			endif
			if found()
				REPLACE Valid WITH .T.
			ELSE
				APPEND BLANK
				REPLACE compl WITH lc_cc, code WITH lc_oir, d_code WITH lc_eti, Valid WITH .T., chdate WITH date()
			endif
		endif
	endif
	SELECT komplex
	SKIP
ENDDO
release WINDOW sumexcl
if p_kieli='Com'
  do versel  
endif
SELECT komplex
SEEK lc_oir+lc_eti
if not found()
	seek lc_oir
endif
select dg
SEEK lc_oir+lc_eti
on KEY label ctrl+j do COMPLTARK
return

procedure versel
select language
goto top
do while not eof()
  if language.lan<>'Com'
    select icd_oth
    use ('..\..\icd_10\'+trim(language.lan)+'\icd_10') alias icd_oth
    set order to code_w
    set filter to valid
    select dg_oth
    use ('..\..\tabl_def\'+trim(language.lan)+'\drgdg') alias dg_oth
    set filter to valid
    set order to code
    select komplex_oth
    use ('..\..\tabl_def\'+trim(language.lan)+'\komplex') alias komplex_oth
    set filter to valid
    set order to code
    do othcexup
  endif
  select language
  skip
enddo
return

procedure exclclos
Deactivate WINDOW dg
SELECT kompkat
USE
return
