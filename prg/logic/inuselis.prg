procedure inuselis
	WAIT WINDOW NOWAIT 'Building list of used properties'
	SELECT tpomin
	REPLACE ALL inuse WITH .F.
	SELECT dgomin
	REPLACE ALL inuse WITH .F.
	SELECT dg
	dg_ord=ORDER()
    set filter to valid 
	SELECT catomin
	delete ALL
	pack
	SELECT drglogic
	set FILTER to
	REPLACE ALL inuse WITH .F.
	set FILTER to Valid
	REPLACE ALL inuse WITH .T.
	if p_class
	  set filter to (substr(drg,4,1)='O' or substr(drg,4,1)='P')
	  replace all inuse with .f.
	  set filter to inuse
	endif
	set ORDER to ord
	goto Top
	do WHILE NOT EOF()
		WAIT WINDOW NOWAIT drglogic.ord
		lc_use=.T.
		select drgnames
		set order to drg
		seek drglogic.drg
		if found()
		  replace valid with .t.
		endif
		select drglogic
		if pdgprop<>' '
			SELECT dg
			set ORDER to varval
			SEEK 'PDGPRO  '+SUBSTR(drglogic.pdgprop,1,2)+SUBSTR(drglogic.pdgprop,4,2)+SUBSTR(drglogic.pdgprop,3,1)
			if NOT found()
				REPLACE drglogic.inuse WITH .F.
			endif
		endif
		SELECT drglogic
		if procpro1<>' '
			SELECT dg
			set ORDER to varval
			SEEK 'PROCPR  '+SUBSTR(drglogic.procpro1,1,2)+SUBSTR(drglogic.procpro1,4,2)+SUBSTR(drglogic.procpro1,3,1)
			if NOT found()
				SELECT drgtpt
				set ORDER to varval
				SEEK 'PROCPR  '+trim(drglogic.procpro1)
				if drglogic.procpro1='99O99'
				set step on
			  		seek 'PROCPR  '+'99O'
				endif
			endif
			if NOT found()
				REPLACE drglogic.inuse WITH .F.
			ELSE
				SELECT tpomin
				SEEK trim(drglogic.procpro1)
				if found()
					REPLACE inuse WITH .T.
				endif
				if drglogic.procpro1='99O99'
					replace inuse with .T. for procprop='99O'
				endif
			endif
		endif
		SELECT drglogic
		if dgcat1<>' '
			SELECT dg
			set ORDER to varval
			SEEK 'DGCAT   '+SUBSTR(drglogic.dgcat1,1,2)+SUBSTR(drglogic.dgcat1,4,2)+SUBSTR(drglogic.dgcat1,3,1)
			if NOT found()
				if drglogic.dgcat1='12' OR drglogic.dgcat1='13'
					SEEK 'DGCAT   '+'98'+SUBSTR(drglogic.dgcat1,4,2)+SUBSTR(drglogic.dgcat1,3,1)
				endif
				if NOT found()
					REPLACE drglogic.inuse WITH .F.
				endif
			endif
		endif
		SELECT drglogic
		if dgprop1<>' '
			lc_dgprop=dgprop1
			if dgprop1='-'
				lc_dgprop=SUBSTR(dgprop1,2,5)
			endif
			SELECT dg
			set ORDER to varval
			SEEK 'DGPROP  '+SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
			if NOT found()
				SELECT drgtpt
				SEEK 'DGPROP  '+TRIM(lc_dgprop)
			endif
			if NOT found()
				REPLACE drglogic.inuse WITH .F.
			ELSE
				SELECT dgomin
				SEEK SUBSTR(drglogic.dgprop1,1,2)+SUBSTR(drglogic.dgprop1,4,2)+SUBSTR(drglogic.dgprop1,3,1)
				if found()
					REPLACE inuse WITH .T.
				endif
			endif
		endif
		SELECT drglogic
		if dgprop2<>' '
			lc_dgprop=dgprop2
			if dgprop2='-'
				lc_dgprop=SUBSTR(dgprop2,2,5)
			endif
			SELECT dg
			set ORDER to varval
			SEEK 'DGPROP  '+SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
			if NOT found()
				SELECT drgtpt
				SEEK 'DGPROP  '+TRIM(lc_dgprop)
			endif
			if NOT found()
				REPLACE drglogic.inuse WITH .F.
			ELSE
				SELECT dgomin
				SEEK SUBSTR(drglogic.dgprop2,1,2)+SUBSTR(drglogic.dgprop2,4,2)+SUBSTR(drglogic.dgprop2,3,1)
				if found()
					REPLACE inuse WITH .T.
				endif
			endif
		endif
		SELECT drglogic
		if dgprop3<>' '
			lc_dgprop=dgprop3
			if dgprop3='-'
				lc_dgprop=SUBSTR(dgprop3,2,5)
			endif
			SELECT dg
			set ORDER to varval
			SEEK 'DGPROP  '+SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
			if NOT found()
				SELECT drgtpt
				SEEK 'DGPROP  '+TRIM(lc_dgprop)
			endif
			if NOT found()
				REPLACE drglogic.inuse WITH .F.
			ELSE
				SELECT dgomin
				SEEK SUBSTR(drglogic.dgprop3,1,2)+SUBSTR(drglogic.dgprop3,4,2)+SUBSTR(drglogic.dgprop3,3,1)
				if found()
					REPLACE inuse WITH .T.
				endif
			endif
		endif
		SELECT drglogic
		if dgprop4<>' '
			lc_dgprop=dgprop4
			if dgprop4='-'
				lc_dgprop=SUBSTR(dgprop4,2,5)
			endif
			SELECT dg
			set ORDER to varval
			SEEK 'DGPROP  '+SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
			if NOT found()
				SELECT drgtpt
				SEEK 'DGPROP  '+TRIM(lc_dgprop)
			endif
			if NOT found()
				REPLACE drglogic.inuse WITH .F.
			ELSE
				SELECT dgomin
				SEEK SUBSTR(drglogic.dgprop4,1,2)+SUBSTR(drglogic.dgprop4,4,2)+SUBSTR(drglogic.dgprop4,3,1)
				if found()
					REPLACE inuse WITH .T.
				endif
			endif
		endif
		SELECT drglogic
		if secproc1<>' ' AND secproc1<>'+' AND secproc1<>'- '
			if secproc1<>'-'
				lc_secproc=TRIM(secproc1)
			ELSE
				lc_secproc=SUBSTR(secproc1,2,5)
			endif
			SELECT dg
			set ORDER to varval
			SEEK 'PROCPR  '+SUBSTR(lc_secproc,1,2)+SUBSTR(lc_secproc,4,2)+SUBSTR(lc_secproc,3,1)
			if NOT found()
				SELECT drgtpt
				SEEK 'PROCPR  '+ lc_secproc
			endif
			if NOT found()
				if drglogic.secproc1<>'-'
					REPLACE drglogic.inuse WITH .F.
				endif
				lc_use=.F.
			ELSE
				SELECT tpomin
				SEEK lc_secproc
				if found()
					REPLACE inuse WITH .T.
				endif
			endif
		endif
		SELECT drglogic
		if inuse
			do accrow
		endif
		SELECT drglogic
		SKIP
	ENDDO
	goto Top

	SELECT dg
	set ORDER to varval
	SELECT komplex
	set FILTER to valid

	SELECT kompkat
	REPLACE ALL inuse WITH .T.
	goto Top
	do WHILE NOT EOF()
		SELECT dg
		SEEK 'COMPL   '+SUBSTR(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2)
		if NOT found()
			SELECT catomin
			SEEK TRIM(kompkat.compl)
			if NOT found()
				APPEND BLANK
				REPLACE catomin WITH kompkat.compl, inuse WITH .F.
			endif
			SELECT kompkat
			REPLACE kompkat.inuse WITH .F.
			SKIP
			LOOP
		endif
		SELECT catomin
		APPEND BLANK
		REPLACE catomin WITH kompkat.compl, inuse WITH .T.
		if kompkat.inclprop<>' '
			SELECT dg
			SEEK 'DGPROP  '+SUBSTR(kompkat.inclprop,1,2)+SUBSTR(kompkat.inclprop,4,2)
			if found()
				SELECT catomin
				SEEK TRIM(kompkat.inclprop)
				if NOT found() OR NOT inuse
					if NOT found()
						APPEND BLANK
						REPLACE catomin WITH kompkat.inclprop, inuse WITH .T.
					ELSE
						REPLACE inuse WITH .T.
					endif
				endif
			endif
		endif
		SELECT kompkat
		SKIP
	ENDDO
	SELECT komplex
	goto Top
	do WHILE NOT EOF()
		SELECT icd_10
		SEEK komplex.code+komplex.d_code
		if NOT found()
			SEEK komplex.code
			if found()
				SEEK komplex.d_code
			endif
		endif
		if found()
			REPLACE komplex.valid WITH .T.
		ELSE
			REPLACE komplex.valid WITH .F.
		endif
		SELECT komplex
		SKIP
	ENDDO
	REPLACE ALL inuse WITH .T.
	goto Top
	do WHILE NOT EOF()
		SELECT kompkat
		SEEK SUBSTR(komplex.compl,1,2)+SUBSTR(komplex.compl,4,2)
		if NOT found() OR NOT inuse
			SELECT komplex
			REPLACE komplex.inuse WITH .F.
		endif
		SELECT komplex
		SKIP
	ENDDO
	SELECT komplex
	set FILTER to Valid
	SELECT dg
	set FILTER to Valid
	set ORDER to (dg_ord)
	return

*!******************************************************************************
*!
*! Procedure ACCROW
*!
*!  Calls
*!      EOF
*!      ORDER
*!      SUBSTR
*!      TRIM
*!      found
*!      to
*!
*!******************************************************************************
procedure accrow
	do accrow2 WITH TRIM(drglogic.pdgprop)
	do accrow2 WITH TRIM(drglogic.procpro1)
	do accrow2 WITH TRIM(drglogic.dgcat1)
	do accrow2 WITH TRIM(drglogic.dgprop1)
	do accrow2 WITH TRIM(drglogic.dgprop2)
	do accrow2 WITH TRIM(drglogic.dgprop3)
	do accrow2 WITH TRIM(drglogic.dgprop4)
	if lc_use
		do accrow2 WITH TRIM(drglogic.secproc1)
	endif
	return

*!******************************************************************************
*!
*! Procedure ACCROW2
*!
*!  Calls
*!      EOF
*!      ORDER
*!      SUBSTR
*!      TRIM
*!      found
*!      to
*!
*!******************************************************************************
procedure accrow2
	parameter procvar
	if procvar='-' OR procvar='+'
		procvar=SUBSTR(procvar,2,5)
	endif
	if procvar=' '
		return
	endif
	SELECT catomin
	SEEK procvar
	if NOT found()
		APPEND BLANK
		REPLACE catomin WITH procvar, inuse WITH .T.
	endif
	return
