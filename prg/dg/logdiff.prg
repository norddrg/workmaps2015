*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\LOGDIFF.PRG
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
*:   LOGDIFF
*!******************************************************************************
*!
*! Procedure LOGDIFF
*!
*!  Calls
*!      EOF
*!      INTO
*!      VAL
*!      VALUES
*!      simtest
*!      to
*!
*!******************************************************************************
procedure LOGDIFF
	WAIT WINDOW 'DRG-logic' NOWAIT
	SELECT 0
	USE ..\log_str
	COPY next 0 to (lc_siirto+'\drglogic') WITH cdx
	USE (lc_siirto+'\drglogic') ALIAS muutos
	set ORDER to drg
	SELECT 0
	USE ..\..\..\transp\com\drglogic ALIAS old
	SELECT drglogic
	do WHILE NOT EOF()
		WAIT WINDOW NOWAIT '1. round: '+drglogic.ord
		if NOT inuse
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
			INSERT INTO (lc_siirto+'\drglogic');
				(new, ord, neword, drg, icd, mdc, pdgprop, OR, procpro1, dgcat1, agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, dur, rtc, Valid, chdate);
				VALUES ('N', drglogic.ord, drglogic.ord, drgnames.loc_drg, drglogic.icd, drglogic.mdc, drglogic.pdgprop, drglogic.OR, drglogic.procpro1, drglogic.dgcat1,;
				drglogic.agelim, drglogic.compl, drglogic.sex, drglogic.dgprop1, drglogic.dgprop2, drglogic.dgprop3, drglogic.dgprop4, drglogic.secproc1,;
				drglogic.disch, drglogic.dur, drglogic.rtc, drglogic.Valid, drglogic.chdate)
		ELSE
			if old.ord<>drglogic.ord
				INSERT INTO (lc_siirto+'\drglogic');
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
			INSERT INTO (lc_siirto+'\drglogic');
				(new, ord, oldord, drg, icd, mdc, pdgprop, OR, procpro1, dgcat1, agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch,  dur, rtc);
				VALUES ('D', old.ord, old.ord, old.drg, old.icd, old.mdc, old.pdgprop, old.OR, old.procpro1, old.dgcat1,;
				old.agelim, old.compl, old.sex, old.dgprop1, old.dgprop2, old.dgprop3, old.dgprop4, old.secproc1,;
				old.disch, old.dur, old.rtc)
		endif
		SELECT old
		SKIP
	ENDDO

	SELECT muutos
	COPY to (lc_siirto+'\drglogic.xls') TYPE XL5
	USE
	SELECT old
	USE
	return

*!******************************************************************************
*!
*! Procedure SIMTEST
*!
*!  Calls
*!      EOF
*!      INTO
*!      VAL
*!      VALUES
*!      simtest
*!      to
*!
*!******************************************************************************
function simtest
	if((drgnames.loc_drg=old.drg or ((drgnames.loc_drg='0'+ltrim(old.drg) or drgnames.loc_drg='00'+ltrim(old.drg))and len(trim(old.drg))>0 );
	or (('0'+ltrim(drgnames.loc_drg)=old.drg or '00'+ltrim(drgnames.loc_drg)=old.drg)) and len(trim(drgnames.loc_drg))>0 );
			AND drglogic.icd=old.icd ;
			AND drglogic.mdc=old.mdc;
			AND drglogic.pdgprop=old.pdgprop ;
			AND drglogic.OR=old.OR;
			AND drglogic.procpro1=old.procpro1 ;
			AND drglogic.dgcat1=old.dgcat1 ;
			AND drglogic.agelim=old.agelim;
			AND VAL(drglogic.compl)=VAL(old.compl) ;
			AND drglogic.sex=old.sex ;
			AND drglogic.dgprop1=old.dgprop1;
			AND drglogic.dgprop2=old.dgprop2 ;
			AND drglogic.dgprop3=old.dgprop3 ;
			AND drglogic.dgprop4=old.dgprop4 ;
			AND drglogic.secproc1=old.secproc1;
			AND drglogic.disch=old.disch ;
			AND drglogic.dur=old.dur)
		lc_same=.T.
	ELSE
		lc_same=.F.
	endif
	return lc_same
