*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\YKSOMKIR.PRG
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
*:   yksomkir
*!******************************************************************************
*!
*! Procedure YKSOMKIR
*!
*!  Calls
*!      ALIAS
*!      SPACE
*!      SUBSTR
*!      VALUES
*!      date
*!      dg
*!      found
*!
*!******************************************************************************
procedure yksomkir
dimension om_lval (1,1)
dimension om_wval (1,1)
	ly_alias=ALIAS()
	do CASE
	CASE ly_alias='PDGOMIN'
		lc_vartype='PDGPRO  '
		lc_varval=pdgomin.pdgprop
	CASE ly_alias='DGKAT'
		lc_vartype='DGCAT   '
		lc_varval=dgkat.dgcat
	CASE ly_alias='DGOMIN'
		lc_vartype='DGPROP  '
		lc_varval=dgomin.dgprop
	CASE ly_alias='TPOMIN'
		lc_vartype='PROCPR  '
		lc_varval=tpomin.procprop
	CASE ly_alias='KOMPKAT'
		lc_vartype='COMPL   '
		lc_varval=kompkat.compl
		WAIT WINDOW 'MCC (G)/Inactive-CC (I) or CC (any other key)'
		IF LASTKEY()=71 OR LASTKEY()=103
		  lc_varval=SUBSTR(compl,1,2)+'G'+SUBSTR(compl,4,2)
		ENDIF 
		IF LASTKEY()=73 OR LASTKEY()=105
		  lc_varval=SUBSTR(compl,1,2)+'I'+SUBSTR(compl,4,2)
		ENDIF 		
	OTHERWISE
		RETURN 
	ENDCASE
	if lc_vartype='DGCAT' and substr(lc_varval,3,1)=' '
	  wait window 'MDC can only be defined as part of a diagnosis category!'
	  return
	endif
	lc_found=.F.
	select dg
	SEEK upper(icd_10.code)+SPACE(6)+lc_vartype+lc_varval
	if found()  
		lc_found=.T.
	ELSE
		if icd_10.d_code<>' '
			SEEK upper(icd_10.d_code)+SPACE(6)+lc_vartype+lc_varval
			if found() and lc_vartype<>'DGCAT'
				lc_found=.T.
			ELSE
				SEEK upper(icd_10.code+icd_10.d_code)+lc_vartype+lc_varval
				if found() 
					lc_found=.T.
				endif
			endif
		endif
	endif
	if lc_found and not valid
	  replace valid with .t.
	endif
	if NOT lc_found
	  if lc_vartype='DGCAT' or lc_vartype='COMPL'
	    SEEK upper(icd_10.code)+SPACE(6)+lc_vartype
	    if found() and valid
	      lc_found=.t.
	    else
	      if icd_10.d_code<>' '
 	        SEEK upper(icd_10.d_code)+SPACE(6)+lc_vartype
	        if found() and valid
	          lc_found=.t.
	        else
	          SEEK upper(icd_10.code+icd_10.d_code)+lc_vartype
	          if found() and valid
	            lc_found=.t.
	          endif
	        endif
	      endif
	    endif
	  endif
	  if lc_found
	    replace varval with lc_varval, chdate with date()
	  endif
	ENDIF
	if NOT lc_found
		INSERT INTO dg (code, d_code, who, Valid, code_w, d_code_w, VARTYPE, varval) ;
			VALUES (icd_10.code, icd_10.d_code, icd_10.who, .T., icd_10.code_w, icd_10.d_code_w,lc_vartype, lc_varval)
		Select dg
		REPLACE chdate WITH date()
	endif
    if p_kieli='Com'
	   do versel
    endif
	select icd_10
	do dgnaytto
	return