procedure drgkir2
parameter lc_mdc
select anal
set fullpath on
lc_anal=dbf()
lc_name='..\..\..\NDMS_testdata\MDC_'+trim(lc_mdc)+'.dbf'
select anal
wait window nowait 'Producing file '+trim(lc_mdc)+'.dbf, this may take a long time'
select drgnames
set filter to lc_mdc=mdc
count to lc_ndrg
dimension drgs (lc_ndrg,1)
goto top
lc_nn=0
do while not eof()
  lc_nn=lc_nn+1
  store loc_drg to drgs(lc_nn,1)
  skip
enddo
select anal
COPY next 0 TO apusiirto 
select 0
use apusiirto
select anal
goto top
set safety off
do while not eof()
  if 1000*int(recno()/1000)=recno()
    wait window nowait str(recno())
  endif
  lc_nn=0
  do while lc_nn<lc_ndrg
    lc_nn=lc_nn+1
    if substr(drg,1,4)=substr(drgs(lc_nn,1),1,4)
      delete
      exit
    endif
  enddo
  select anal
  skip
enddo
wait window nowait 'Transfer and recall'
set safety on
select apusiirto
append from (lc_anal) for deleted()
recall all
copy to (lc_name)
use
select anal
recall all
wait window nowait 'Creation of file MDC_'+trim(lc_mdc)+'.dbf complete'
do grpohje
return