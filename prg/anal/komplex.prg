Procedure komplex
on key label pgup
on key label pgdn
select dg
lc_code=icd_10.code
lc_dcode=icd_10.d_code
do while vartype<>'COMPL' and not bof()
  if icd_10.code<>lc_code or icd_10.d_code <> lc_dcode 
     wait window 'The diagnosis does not belong to any complication category'
     return
  endif
  skip -1
enddo
if bof()
  wait window 'The diagnosis does not belong to any complication category'
  return
endif
set relation to IIF(vartype='DGCAT' or vartype='MDC', SUBSTR(varval,1,2)+SUBSTR(varval,4,2),' ') into dgkat
set relation to IIF(vartype='DGPROP',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+SUBSTR(varval,3,1),' ') into dgomin additive
set relation to IIF(vartype='PDGPRO',trim(varval),' ') into pdgomin additive
set relation to IIF(vartype='PROCPR',varval,' ') into tpomin additive
select kompkat
seek SUBSTR(dg.varval,1,2)+SUBSTR(dg.varval,4,2)
set relation to
select komplex
set relation to trim(code+d_code) into icd_10
DEFINE WINDOW komplex FROM 3,20 TO max_y, max_x FONT  max_foty,  max_fosi title 'Excluded diagnosis for complication category '+kompkat.compl+' '+trim(kompkat.english)
activate window komplex
set safety off
select icd_10
COPY TO ..\anal\apu.dbf NEXT 0 FIELDS Icd_10.code,Icd_10.d_code,Icd_10.text
select 0
use ..\anal\apu.dbf
select komplex 
seek SUBSTR(dg.varval,1,2)+SUBSTR(dg.varval,4,2)
do while substr(komplex.compl,1,2)+substr(komplex.compl,4,2)=substr(dg.varval,1,2)+substr(dg.varval,4,2)
  insert into ..\anal\apu.dbf (code, d_code, text) values(komplex.code, komplex.d_code, icd_10.text)
  select komplex
  skip
enddo
select apu
goto top
do while code<>anal.oir1 and d_code<>anal.syy1 and not eof()
  skip
enddo
if code=anal.oir1 and d_code=anal.syy1
  wait window 'Main diagnosis excluded from this complication group'
else
  goto top
endif
browse fields code, d_code, text 
use
release window komplex
select komplex
set relation to 

select kompkat
set relation to SUBSTR(compl,1,2)+SUBSTR(compl,4,2) into komplex
set skip to komplex

select dg
set relation to IIF(vartype='DGCAT' or vartype='MDC', SUBSTR(varval,1,2)+SUBSTR(varval,4,2),' ') into dgkat
set relation to IIF(vartype='DGPROP',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+SUBSTR(varval,3,1),' ') into dgomin additive
set relation to IIF(vartype='PDGPRO',trim(varval),' ') into pdgomin additive
set relation to IIF(vartype='PROCPR',varval,' ') into tpomin additive
set relation to IIF(vartype='COMPL',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+SUBSTR(varval,3,1),' ') into kompkat additive
set relation to trim(code+d_code) into icd_10 additive
return