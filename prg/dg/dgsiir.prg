procedure DGSIIR
  WAIT WINDOW 'Properties and categories of diagnoses' NOWAIT
  SELECT 0
  USE ..\cex_str
  COPY next 0 to ..\apu0_cex FIELDS compl, comptext, code, d_code, icdtext WITH cdx
  use
  SELECT pdgomin
  set ORDER to pdgprop
  SELECT icd_10
  set ORDER to code
  SELECT dg
  set ORDER to code
  SELECT 0
  USE ..\apudg
  COPY to ..\apudg0 next 0 WITH cdx
  COPY to ..\apudg1 next 0 WITH cdx
  USE
  SELECT 0
  USE ..\apudg0
  INSERT INTO ..\apudg0 (code, icd_text, VARTYPE, varval );
  VALUES ('#####', 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()), p_vers, dtoc(date()))
  SELECT 0
  USE ..\apudg1
  INSERT INTO ..\apudg1 (code, icd_text, VARTYPE, varval );
  VALUES ('#####', 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()), p_vers, dtoc(date()))
  SELECT icd_10
  set FILTER to  Valid
  set ORDER to code
  SELECT dg
  set FILTER to Valid
 * set RELATION to IIF(VARTYPE='DGCAT' OR VARTYPE='MDC', SUBSTR(varval,1,2)+SUBSTR(varval,4,2),' ') INTO dgkat
 * set RELATION to IIF(VARTYPE='DGPROP',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+SUBSTR(varval,3,1),' ') INTO dgomin ADDITIVE
 * set RELATION to IIF(VARTYPE='PDGPRO',TRIM(varval),' ') INTO pdgomin ADDITIVE
 * set RELATION to IIF(VARTYPE='PROCPR',varval,' ') INTO tpomin ADDITIVE
 * set RELATION to IIF(VARTYPE='COMPL',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+' ',' ') INTO kompkat ADDITIVE
  lc_ylaraja=SPACE(5)
  SELECT 0
  USE ..\dg0_str
  COPY next 0 to ..\dg0_apu
  USE  ..\dg0_apu
  dg_1_n=0
  dg_0_n=0
  lc_ccn=0
  SELECT dg
  set ORDER to code
  set FILTER to Valid
  SEEK 'A'
  lc_1=SUBSTR(dg.code,1,1)
  do WHILE NOT EOF()
    lc_5=dg.code
    if NOT (Valid)
      SKIP
      LOOP
      endif
    SELECT catomin
    SEEK dg.varval
    IF dg.vartype='COMPL' AND NOT FOUND()
       SEEK (SUBSTR(dg.varval,1,2)+'C'+SUBSTR(dg.varval,4,2))
    endif
    if (NOT found() OR NOT inuse) AND NOT (dg.VARTYPE='OR' AND dg.varval='1')
      if NOT found()
        APPEND BLANK
        REPLACE catomin WITH dg.varval, inuse WITH .F.
      endif
      if dg.VARTYPE<>'DGCAT'
        SELECT dg
        if EOF()
          EXIT
        endif
        SKIP
        LOOP
      endif
    endif
    SELECT dg
    DO case
    CASE dg.vartype='DGCAT' OR vartype='MDC'
       SELECT dgkat
       SEEK SUBSTR(dg.varval,1,2)+SUBSTR(dg.varval,4,2)
       lc_text=dgkat.english
    CASE dg.vartype='DGPROP'
       SELECT dgomin
       SEEK SUBSTR(dg.varval,1,2)+SUBSTR(dg.varval,4,2)+SUBSTR(dg.varval,3,1)
       lc_text=dgomin.english
    CASE dg.vartype='PDGPRO'
       SELECT pdgomin
       SEEK TRIM(dg.varval)
       lc_text=pdgomin.english
    CASE dg.vartype='PROCPR'
       SELECT tpomin
       SEEK dg.varval
       lc_text=tpomin.english
    CASE dg.vartype='COMPL'
       SELECT kompkat
       SEEK SUBSTR(dg.varval,1,2)+SUBSTR(dg.varval,4,2)
       lc_text=kompkat.english
     OTHERWISE 
       lc_text='***'
     ENDCASE 
    IF lc_text= '   '
      SET STEP ON 
    endif
    IF dg.vartype='COMPL' AND SUBSTR(dg.varval,3,1)='G' 
      lc_text = TRIM(lc_text)+' - Major complication'
    endif
    SELECT icd_10
    SEEK upper(dg.code+dg.d_code)
    SELECT dg
    if code<>lc_1
      WAIT WINDOW "Siirto: " +code NOWAIT
      lc_1=SUBSTR(dg.code,1,1)
    endif
    if ('00'=TRIM(varval))
      SKIP
      LOOP
    endif
    if ( varval='00M00')
      INSERT INTO ..\apudg0 (code, d_code, VARTYPE, varval, text, icd_text);
      VALUES (dg.code, dg.d_code, dg.VARTYPE, dg.varval, lc_text, icd_10.text)
      select dg
      if at('.',code)>0
        select apudg0
        replace code WITH SUBSTR(dg.code,1,3)+substr(dg.code,5,2)
      endif
      select dg
      if at ('.', d_code)>0
        select apudg0
        replace d_code with substr(dg.d_code,1,3)+substr(dg.d_code,5,2)
      endif
    ELSE
      dg_1_n=dg_1_n+1
      lc_val=varval
      if varval='00C00' OR varval='00G00'
        lc_ccn=lc_ccn+1
        lc_val=STR(lc_ccn,2)
        if lc_val=' '
          lc_val='0'+SUBSTR(lc_val,2,1)
        endif
        lc_val='98'+SUBSTR(varval,3,1)+lc_val
        INSERT INTO ..\apu0_cex (compl, comptext, code, d_code, icdtext) VALUES (lc_val, 'Technical exclusion for 00C00/00G00 diagnosis', dg.code, dg.d_code, icd_10.text)
      endif
      if AT('.',code)>0
        INSERT INTO ..\apudg1 (code, d_code, VARTYPE, varval,text, icd_text);
        VALUES (SUBSTR(dg.code,1,3)+ SUBSTR(dg.code,5,2), dg.d_code, dg.VARTYPE, lc_val, lc_text, icd_10.text)
        if AT('.',d_code)>0
          REPLACE apudg1.d_code WITH SUBSTR(dg.d_code,1,3)+SUBSTR(dg.d_code,5,2)
        endif
        *       do dgkirj with '1'
        SELECT dg
        if VARTYPE='DGCAT'
          INSERT INTO ..\apudg1 (code, d_code, VARTYPE, varval, text, icd_text);
            VALUES (SUBSTR(dg.code,1,3)+ SUBSTR(dg.code,5,2), dg.d_code, 'MDC', SUBSTR(dg.varval,1,2), lc_text, icd_10.text)
          if AT('.',d_code)>0
            REPLACE apudg1.d_code WITH SUBSTR(dg.d_code,1,3)+SUBSTR(dg.d_code,5,2)
          endif
          if not (substr(dg.varval,1,2)='00' or substr(dg.varval,1,2)='23' or substr(dg.varval,1,2)='25' or substr(dg.varval,1,2)='99' )
            INSERT INTO ..\apudg1 (code, d_code, VARTYPE, varval, text, icd_text);
              VALUES (SUBSTR(dg.code,1,3)+ SUBSTR(dg.code,5,2), dg.d_code, 'DGPROP', SUBSTR(dg.varval,1,2)+'X99', lc_text, icd_10.text)
            if AT('.',d_code)>0
              REPLACE apudg1.d_code WITH SUBSTR(dg.d_code,1,3)+SUBSTR(dg.d_code,5,2)
            endif
          endif
        endif
      ELSE
        INSERT INTO ..\apudg1 (code, d_code, VARTYPE, varval,text, icd_text);
          VALUES (dg.code, dg.d_code, dg.VARTYPE, lc_val, lc_text, icd_10.text)
        if AT('.',d_code)>0
          REPLACE apudg1.d_code WITH SUBSTR(dg.d_code,1,3)+SUBSTR(dg.d_code,5,2)
        endif
        *       do dgkirj with '1'
        SELECT dg
        if VARTYPE='DGCAT'
          INSERT INTO ..\apudg1 (code, d_code, VARTYPE, varval, text, icd_text);
            VALUES (dg.code, dg.d_code, 'MDC', SUBSTR(dg.varval,1,2), lc_text, icd_10.text)
          if AT('.',d_code)>0
            REPLACE apudg1.d_code WITH SUBSTR(dg.d_code,1,3)+SUBSTR(dg.d_code,5,2)
          endif
          if not (substr(dg.varval,1,2)='00' or substr(dg.varval,1,2)='23' or substr(dg.varval,1,2)='25' or substr(dg.varval,1,2)='99' )
            INSERT INTO ..\apudg1 (code, d_code, VARTYPE, varval, text, icd_text);
              VALUES (dg.code, dg.d_code, 'DGPROP', SUBSTR(dg.varval,1,2)+'X99', lc_text, icd_10.text)
            if AT('.',d_code)>0
              REPLACE apudg1.d_code WITH SUBSTR(dg.d_code,1,3)+SUBSTR(dg.d_code,5,2)
            endif
          endif
        endif
      endif
    endif
    SELECT dg
    SKIP
  ENDDO
  SELECT apudg0
  COPY to (lc_siirto+'\dg_0.dbf')TYPE foxplus FIELDS code, d_code, VARTYPE, varval
  COPY to (lc_siirto+'\dg0_xls.dbf') TYPE foxplus fields code, d_code, icd_text
  ERASE (lc_siirto+'\dg_0.txt')
  COPY to (lc_siirto+'\dg_0.txt') DELIMITED WITH CHARACTER ';' fields code, d_code, icd_text
  USE
  SELECT apudg1
  COPY to (lc_siirto+'\dg_1.dbf')TYPE foxplus FIELDS code, d_code, VARTYPE, varval
  goto Top
  COPY to (lc_siirto+'\dg1_xls.dbf') TYPE foxplus NEXT 60000
  COPY to (lc_siirto+'\dg2_xls.dbf') TYPE foxplus NEXT 60000
  ERASE (lc_siirto+'\dg_1.txt')
  COPY to (lc_siirto+'\dg_1.txt')DELIMITED WITH CHAR ';' FIELDS code, d_code, VARTYPE, varval
  COPY next 0 to apu_dg_1.dbf FIELDS code, d_code, VARTYPE, varval
  USE apu_dg_1
  LIST STRUCTURE TO (lc_siirto+'\dg_1_str.txt')
  USE
  ERASE apu_dg_1.dbf
  ON error
  return

procedure dgkirj
  parameter tyh
  if tyh='0'
    SELECT apudg0
  ELSE
    SELECT apudg1
  endif
  lc_vartype=VARTYPE
  lc_varval=varval
  lc_code=code
  lc_dcode=d_code
  SELECT icd_10
  SEEK upper(lc_code+lc_dcode)
  SELECT dg
  lc_pdg=.F.
  lc_dgpr=.F.
  lc_proc=.F.
  return

*!******************************************************************************
*!
*! Procedure POINT
*!
*!  Calls
*!      AT
*!      EOF
*!      IIF
*!      LEN
*!      NOT
*!      SPACE
*!      STR
*!      SUBSTR
*!      TRIM
*!      VALUES
*!      apu_cex
*!      apudg0
*!      apudg1
*!      dg0_apu
*!      found
*!      to
*!
*!******************************************************************************
function point
  parameter fp_code
  re_code=fp_code
  if LEN(TRIM(fp_code))>3 AND SUBSTR(fp_code,4,1)<='9' AND AT('.',fp_code)=0
    re_code=SUBSTR(fp_code,1,3)+'.'+SUBSTR(fp_code,4,2)
  endif
  return re_code
endfunc

