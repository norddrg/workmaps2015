*!******************************************************************************
*!
*! Procedure LISNAYTTO
*!
*!  Calls
*!      AT
*!      BOF
*!      DELETED
*!      EOF
*!      FILTER
*!      LASTKEY
*!      ORDER
*!      SPACE
*!      SUBSTR
*!      TRIM
*!      VALUES
*!      date
*!      dg
*!      found
*!      say
*!
*!******************************************************************************
procedure lisnaytto
PARAMETERS omintype, ominfile
activate window omin
select dg
set filter to
if upper(lc_oir)<>upper(lc_dgo) or upper(lc_eti)<>upper(lc_dge)
	seek upper(lc_oir+lc_eti)+omintype
	do while upper(dg.code)=upper(lc_oir) and upper(dg.d_code)=upper(lc_eti) and dg.vartype=omintype and not eof()
		replace valid with .f.
		skip
	enddo
endif
SEEK upper(lc_dgo+lc_dge)+omintype
if omintype='OR'
	DEFINE WINDOW lisnay FROM 0, 2*min_x to 4*min_y, max_x FONT max_foty,  max_fosi  TITLE 'Operation room procedure'
	Activate WINDOW lisnay
	? 'Current status:'
	if found() and vartype='1'
		? 'OR-property'
	else
		? 'No OR-property'
	endif
	seek upper(lc_oir+lc_eti) +'OR'
	lc_found=.f.
	if found()
		lc_found=.t.
	endif
	? 'Should the diagnosis have OR-property [Y]/[N]'
	wait window 'Should the diagnosis have OR-property [Y]/[N]'
	release WINDOW lisnay
	if lastkey()=27
		return
	endif
	if lastkey()=121 or lastkey()=89
		if lc_found
			replace varval with '1', valid with .t.
		else
			insert into dg (code, d_code, valid, vartype, varval, chdate);
			values (lc_dgo, lc_dge, .t., 'OR', '1', date())
		endif
		? 'OR-property positive' at 1
	else
		if lc_found
			replace varval with '0', valid with .f.
		endif
		? 'No-OR property' at 1
	endif
	return
endif
lc_on=0
lc_ominstr=''
lc_omin (1,1)=space(5)
seek upper(lc_dgo+lc_dge)+omintype
do WHILE upper(code)=upper(lc_dgo) and upper(d_code) = upper(lc_dge) AND VARTYPE=omintype AND NOT EOF()
	if not valid
		skip
		loop
	endif
	lc_nn=0
	lc_sama=.f.
	do while lc_nn<lc_on
		lc_nn=lc_nn+1
		if dg.varval=lc_omin (lc_nn,1)
			lc_sama=.t.
			exit
		endif
	enddo
	if lc_sama
		skip
		loop
	endif
	lc_on=lc_on+1
	dimension lc_omin (lc_on,1)
	lc_omin (lc_on,1)=dg.varval
	lc_ominstr= lc_ominstr+dg.varval+' '
	SKIP
enddo
if lc_dge<>' '
	SEEK upper(lc_dgo)+SPACE(6)+omintype
	do WHILE upper(code)=upper(lc_dgo) and d_code=' ' AND VARTYPE=omintype AND NOT EOF()
		if not valid
			skip
			loop
		endif
		lc_nn=0
		lc_sama=.f.
		do while lc_nn<lc_on
			lc_nn=lc_nn+1
			if dg.varval=lc_omin (lc_nn,1)
				lc_sama=.t.
				exit
			endif
		enddo
		if lc_sama
			skip
			loop
		endif
		if lc_on>=1 and (omintype='DGCAT' or omintype = 'COMPL')
			exit
		endif
		lc_on=lc_on+1
		dimension lc_omin (lc_on,1)
		lc_omin (lc_on,1)=dg.varval
		lc_ominstr= lc_ominstr+dg.varval+' '
		SKIP
	enddo
	if omintype<>'DGCAT'
		SEEK upper(lc_dge)+SPACE(6)+omintype
		do WHILE upper(code)=upper(lc_dgo) and d_code=' ' AND VARTYPE=omintype AND NOT EOF()
			if not valid
				skip
				loop
			endif
			lc_nn=0
			lc_sama=.f.
			do while lc_nn<lc_on
				if dg.varval=lc_omin (lc_nn+1,1)
					lc_sama=.t.
					exit
				endif
				lc_nn=lc_nn+1
			enddo
			if lc_sama
				skip
				loop
			endif
			if lc_on>=1 and (omintype = 'COMPL')
				exit
			endif
			lc_on=lc_on+1
			dimension lc_omin (lc_on,1)
			lc_omin (lc_on,1)=dg.varval
			lc_ominstr= lc_ominstr+dg.varval+' '
			SKIP
		enddo
	endif
endif
? omintype + ': ' + lc_ominstr at 1
lc_nn=1
lc_loop=.t.
lc_ominstr=''
do while lc_loop
	if lc_nn>1 and (omintype='DGCAT' or omintype='COMPL')
		exit
	endif
	select (ominfile)
	if lc_nn<=lc_on
		SEEK SUBSTR(lc_omin (lc_nn,1),1,2)+SUBSTR(lc_omin (lc_nn,1),4,2)
		if not found()
			SEEK (lc_omin (lc_nn,1))
		endif
	else
		goto top
	endif
	DEFINE WINDOW lisnay FROM 0, 2*min_x to 4*min_y, max_x FONT max_foty,  max_fosi  TITLE (omintype)
	Activate WINDOW lisnay
	BROWSE IN WINDOW lisnay noedit
	release WINDOW lisnay
	if LASTKEY()=27
		return
	endif
	do CASE
	CASE omintype='DGCAT'
		lc_apu = dgcat
	CASE omintype='DGPROP'
		lc_apu = dgprop
	CASE omintype='PROCPR'
		lc_apu = procprop
	CASE omintype='COMPL'
		lc_apu = compl
		WAIT WINDOW 'MCC (G)/Inactive-CC (I)/ CC (C)or keep existing (any other key)'
		IF LASTKEY()=71 OR LASTKEY()=103
		  lc_varval=SUBSTR(compl,1,2)+'G'+SUBSTR(compl,4,2)
		ENDIF 
		IF LASTKEY()=73 OR LASTKEY()=105
		  lc_varval=SUBSTR(compl,1,2)+'I'+SUBSTR(compl,4,2)
		ENDIF 		
		IF LASTKEY()=67 OR LASTKEY()=99
		  lc_varval=SUBSTR(compl,1,2)+'C'+SUBSTR(compl,4,2)
		ENDIF 		
	CASE omintype='PDGPRO'
		lc_apu = pdgprop
	ENDCASE
	select dg
	lc_ominstr=lc_ominstr+lc_apu+' '
	if lc_nn<=lc_on
		seek lc_oir+lc_eti+omintype+space(8-len(trim(omintype)))+lc_omin(lc_nn,1)
		if found()
			replace valid with .f.
		endif
	endif
	if lc_apu=' '  
		if lc_nn<lc_on
			lc_nn=lc_nn+1
			loop
		else
			exit
		endif
	endif
	lc_f1=.f.
	lc_v1=.f.
	lc_v2=.f.
	lc_v3=.f.
	seek lc_oir+lc_eti+omintype+space(8-len(trim(omintype)))+lc_apu
	if found()
		lc_f1=.t.
		if valid
			lc_v1=.t.
		endif
	endif
	if lc_eti<>' '
		if not found() or not valid 
			seek lc_oir+space(6)+omintype+space(8-len(trim(omintype)))+lc_apu
			if found() and valid
				lc_v2=.t.
			endif
			if (not found() or not valid) and omintype<>'DGCAT'
				seek lc_eti+space(6)+omintype+space(8-len(trim(omintype)))+lc_apu
				if found() and valid
					lc_v3=.t.
				endif
			endif
		endif
	endif
	if not (lc_v1 or lc_v2 or lc_v3)
		if lc_f1
			seek lc_oir+lc_eti+omintype+space(8-len(trim(omintype)))+lc_apu
			replace valid with .t.
		else
			insert into dg (code, d_code, valid, vartype, varval, chdate);
			values (lc_oir, lc_eti, .t., omintype, lc_apu, date())
		endif
	endif
	lc_nn=lc_nn+1
enddo
?? omintype+': ' + lc_ominstr + space (15) at 1
return

