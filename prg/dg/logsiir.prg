procedure LOGSIIR
	WAIT WINDOW 'DRG-logic' NOWAIT
	SELECT 0
	USE ..\log_str
	COPY next 0 to (lc_siirto+'\muutos\drglogic') WITH cdx
	USE (lc_siirto+'\muutos\drglogic') ALIAS muutos
	set ORDER to drg
	SELECT 0
	USE ('..\..\old\'+p_kieli+'\drglogic') ALIAS old
	SELECT drglogic
	goto top
	set FILTER to Valid
	IF p_class
	  SET FILTER TO valid AND NOT (dur='<0' OR dur='<1' OR dur='<2')
	endif
	do WHILE NOT EOF()
		WAIT WINDOW NOWAIT '1. round: '+drglogic.ord
		if NOT inuse OR NOT Valid
			SKIP
			LOOP
		endif
		SELECT old
		goto Top
		do WHILE NOT EOF()
			if simtest()
				EXIT
			endif
			SELECT old
			SKIP
		ENDDO
		if NOT simtest()
*		SET STEP ON
			INSERT INTO (lc_siirto+'\muutos\drglogic');
				(new, ord, neword, drg, icd, mdc, pdgprop, OR, procpro1, dgcat1, agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, dur, rtc, Valid, chdate);
				VALUES ('N', drglogic.ord, drglogic.ord, drgnames.loc_drg, drglogic.icd, drglogic.mdc, drglogic.pdgprop, drglogic.OR, drglogic.procpro1, drglogic.dgcat1,;
				drglogic.agelim, drglogic.compl, drglogic.sex, drglogic.dgprop1, drglogic.dgprop2, drglogic.dgprop3, drglogic.dgprop4, drglogic.secproc1,;
				drglogic.disch, drglogic.dur, drglogic.rtc, drglogic.Valid, drglogic.chdate)
		ELSE
			if old.ord<>drglogic.ord
				INSERT INTO (lc_siirto+'\muutos\drglogic');
					(new, ord, neword, oldord, drg, icd, mdc, pdgprop, OR, procpro1, dgcat1, agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, dur, rtc);
					VALUES ('O', drglogic.ord, drglogic.ord, old.ord, old.drg, old.icd, old.mdc, old.pdgprop, old.OR, old.procpro1, old.dgcat1,;
					old.agelim, old.compl, old.sex, old.dgprop1, old.dgprop2, old.dgprop3, old.dgprop4, old.secproc1,;
					old.disch, old.dur, old.rtc)
			endif
		endif
		SELECT drglogic
		SKIP
	ENDDO
	SELECT old
	goto Top
	do WHILE NOT EOF()
		SELECT drglogic
		goto Top
		WAIT WINDOW NOWAIT 'oldies: '+old.ord
		do WHILE NOT EOF()
			if NOT inuse
				SKIP
				LOOP
			endif
			if simtest()
				EXIT
			endif
			SELECT drglogic
			SKIP
		ENDDO
		SELECT drglogic
		if NOT simtest()
			INSERT INTO (lc_siirto+'\muutos\drglogic');
				(new, ord, oldord, drg, icd, mdc, pdgprop, OR, procpro1, dgcat1, agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, dur, rtc);
				VALUES ('D', old.ord, old.ord, old.drg, old.icd, old.mdc, old.pdgprop, old.OR, old.procpro1, old.dgcat1,;
				old.agelim, old.compl, old.sex, old.dgprop1, old.dgprop2, old.dgprop3, old.dgprop4, old.secproc1,;
				old.disch, old.dur, old.rtc)
		endif
		SELECT old
		SKIP
	ENDDO

	SELECT 0
	USE ..\..\tabl_def\rtc.DBF
	set ORDER to code
	select drgnames
	replace all valid with .f.
	SELECT drglogic
	set ORDER to ord
	set FILTER to inuse
	IF p_class
	  SET FILTER TO inuse AND NOT (dur='<0' OR dur='<1' OR dur='<2') 
	ENDIF
	set RELATION to drg INTO drgnames
	set RELATION to rtc INTO rtc ADDITIVE
	replace all drgnames.valid with .t.
	COPY to apu next 0 FIELDS ord, drg, drgnames.loc_drg, drgnames.drgname, rtc, icd, mdc, pdgprop, OR, procpro1, procpro2, procpro3, dgcat1, dgcat2,;
	agelim, compl, sex,  dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, dur
    INSERT INTO apu (ord, drgname, dgprop1, dgprop2, dgprop3, dgprop4, drg, procpro1);
    VALUES ('#####', 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()),; 
    substr(p_vers,1,5),substr(p_vers,6,5), substr(p_vers,11,5), substr(p_vers,16,5), p_kieli, dtoc(date()))
    select drglogic
    goto top
    do while not eof()
	  insert into apu (ord, drg, loc_drg, drgname, rtc, icd, mdc, pdgprop,;
	  OR, procpro1, procpro2, procpro3, dgcat1, dgcat2,;
	  agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4,;
	  secproc1, disch, dur);
	  values(drglogic.ord, drgnames.loc_drg, drglogic.drg, drgnames.drgname, drglogic.rtc, drglogic.icd, drglogic.mdc, drglogic.pdgprop,;
	  drglogic.OR, drglogic.procpro1, drglogic.procpro2, drglogic.procpro3, drglogic.dgcat1, drglogic.dgcat2,;
	  drglogic.agelim, drglogic.compl, drglogic.sex, drglogic.dgprop1, drglogic.dgprop2, drglogic.dgprop3, drglogic.dgprop4,;
	  drglogic.secproc1, drglogic.disch, drglogic.dur)
      select drglogic
      skip
    enddo
	select apu
	nmis=0
	count to nmis all for drg='   '
	if nmis>1
	  locate all for drg='   '
	  skip
	  locate next 3000 for drg='   '
	  wait window 'DRG '+loc_drg+' loc_drg is missing - check DRG-names!'
	  do _dgdrg
	  quit
	endif
	select apu
	replace all procpro1 with '99O99' for procpro1='99O  '
	COPY to (lc_siirto+'\drglogic.dbf')TYPE foxplus FIELDS ord, drg, rtc, icd, mdc, pdgprop, OR, procpro1, dgcat1,;
	agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, dur, loc_drg	
	COPY to (lc_siirto+'\drglogic.xl2') TYPE XLS FIELDS ord, drg, drgname, rtc, icd, mdc, pdgprop, OR, procpro1, dgcat1,;
	agelim, compl, sex,  dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, dur, loc_drg
    ERASE (lc_siirto+'\drglogic.txt')
	COPY to (lc_siirto+'\drglogic.txt') DELIMITED WITH CHARACTER ';' FIELDS ord, drg, drgname, rtc, icd, mdc, pdgprop, OR, procpro1, dgcat1,;
	agelim, compl, sex,  dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, dur, loc_drg
	COPY next 0 to apu_logic FIELDS ord, drg, drgname, rtc, icd, mdc, pdgprop, OR, procpro1, dgcat1,;
	agelim, compl, sex,  dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, dur, loc_drg
	USE apu_logic
	LIST STRUCTURE TO (lc_siirto+'\drglogic_str.txt')
	ERASE apu_logic
	use
	SELECT muutos
	COPY to (lc_siirto+'\muutos\drglogic.xls') TYPE XL5
    ERASE (lc_siirto+'\muutos\drglogic.txt')
    COPY TO (lc_siirto+'\muutos\drglogic.txt') DELIMITED WITH CHAR ';'
	LIST STRUCTURE TO (lc_siirto+'\muutos\drglogic_str.txt')
	USE
	SELECT old
	USE
*SET STEP ON 
	select drgnames
	copy to apu1 for valid
	copy to apu next 0
	use apu
	append blank
	replace loc_drg with '####', drgname with 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date())
	select 0
	use apu1
	goto top
	do while not eof()
	  insert into apu (drg, mdc, drgname, nam_sho,loc_drg);
	  values(apu1.loc_drg, apu1.mdc, apu1.drgname, apu1.nam_sho, apu1.drg)
      select apu1
      skip
	enddo
	select apu1
	use
	select apu
	COPY to (lc_siirto+'\drgnames.dbf') TYPE foxplus fields drg, mdc, drgname, nam_sho, loc_drg
	COPY to (lc_siirto+'\drgnames.xl2') TYPE XLS FIELDS drg, mdc, drgname, nam_sho, loc_drg
	COPY to (lc_siirto+'\drgnames.txt') DELIMITED WITH CHAR ';' FIELDS drg, mdc, drgname, nam_sho, loc_drg
	COPY to apu_names.dbf FIELDS drg, mdc, drgname, nam_sho, loc_drg
	USE apu_names
	LIST STRUCTURE TO (lc_siirto+'\drgnames_str.txt')
	USE ('..\..\tabl_def\'+language.lan+'\drgnames')
    set ORDER to drg
    SELECT drglogic
    set RELATION to drg INTO drgnames

	return

*!******************************************************************************
*!
*! Procedure SIMTEST
*!
*!  Calls
*!      EOF
*!      INTO
*!      SUBSTR
*!      VAL
*!      VALUES
*!      simtest
*!      to
*!
*!******************************************************************************
function simtest
	if((drgnames.loc_drg=old.drg or ((drgnames.loc_drg='0'+ltrim(old.drg) or drgnames.loc_drg='00'+ltrim(old.drg))and len(trim(old.drg))>0 );
	or (('0'+ltrim(drgnames.loc_drg)=old.drg or '00'+ltrim(drgnames.loc_drg)=old.drg)) and len(trim(drgnames.loc_drg))>0 );
			AND trim(drglogic.icd)=trim(old.icd) AND trim(old.icd)=trim(drglogic.icd);
			AND trim(drglogic.mdc)=trim(old.mdc) AND trim(old.mdc)=trim(drglogic.mdc);
			AND trim(drglogic.pdgprop)=trim(old.pdgprop) AND trim(old.pdgprop)=trim(drglogic.pdgprop) ;
			AND trim(drglogic.OR)=trim(old.OR) AND trim(old.OR)=trim(drglogic.OR);
			AND trim(drglogic.procpro1)=trim(old.procpro1) AND trim(old.procpro1)=trim(drglogic.procpro1);
			AND trim(drglogic.dgcat1)=trim(old.dgcat1) AND trim(old.dgcat1)=trim(drglogic.dgcat1) ;
			AND trim(drglogic.agelim)=trim(old.agelim) AND trim(old.agelim)=trim(drglogic.agelim);
			AND VAL(drglogic.compl)=VAL(old.compl) AND VAL(old.compl)=VAL(drglogic.compl);
			AND trim(drglogic.sex)=trim(old.sex) AND trim(old.sex)=trim(drglogic.sex);
			AND trim(drglogic.dgprop1)=trim(old.dgprop1) AND trim(old.dgprop1)=trim(drglogic.dgprop1);
			AND trim(drglogic.dgprop2)=trim(old.dgprop2) AND trim(old.dgprop2)=trim(drglogic.dgprop2);
			AND trim(drglogic.dgprop3)=trim(old.dgprop3) AND trim(old.dgprop3)=trim(drglogic.dgprop3);
			AND trim(drglogic.dgprop4)=trim(old.dgprop4) AND trim(old.dgprop4)=trim(drglogic.dgprop4);
			AND trim(drglogic.secproc1)=trim(old.secproc1) AND trim(old.secproc1)=trim(drglogic.secproc1);
			AND trim(drglogic.disch)=trim(old.disch) AND trim(old.disch)=trim(drglogic.disch);
			AND trim(drglogic.dur)=trim(old.dur)) AND trim(drglogic.dur)=trim(old.dur)
		lc_same=.T.
	ELSE
		lc_same=.F.
	endif
	return lc_same
