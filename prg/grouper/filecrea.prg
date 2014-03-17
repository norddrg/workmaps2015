Procedure filecrea
select logicstru
set order to firstpos
set filter to field_len>0
replace all field_name with var for not fixed
COPY ..\apu.dbf FIELDS Logicstr.field_name,Logicstr.field_type,Logicstr.field_len,Logicstr.field_dec,Logicstr.field_null,Logicstr.field_nocp,Logicstr.field_defa,Logicstr.field_rule,Logicstr.field_err,Logicstr.table_rule,Logicstr.table_err,Logicstr.table_name,Logicstr.ins_trig,Logicstr.upd_trig,Logicstr.del_trig,Logicstr.table_cmt
create ..\..\test_ext\koe.dbf from ..\apu
append from ..\..\test_ext\koe
return


