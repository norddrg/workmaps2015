procedure logicsel
lse_loop=.t.
public p_logic
do while lse_loop
  SELECT 0
  define popup logicsel from 5,5 font  max_foty,  max_fosi prompt files like ..\..\tabl_def\drgl_*.dbf
  on selection popup logicsel do apusel with prompt()
  wait window nowait 'Select a logic system file! New copy of common logic system file - [Esc]'
  activate popup logicsel
  release popup logicsel
  if lastkey()<>27
    exit
  else
    lc_val=space(8)
    define window koodi from 5,5 to 30,70 font  max_foty,  max_fosi
    activate window koodi
    ke_koodi=space(7)
    @ 2,1 say 'Give the name for the new copy of logic system file! Cancel - [Esc]'
    @ 4,5 get lc_val picture 'drgl_XXXXXXXXX'
    read
    if lastkey()=27
      wait window 'You have to select a logic system file!'
      loop
    endif
    select 0
    use ..\..\tabl_def\drgl_com.dbf alias drglogic
    lc_val='..\..\tabl_def\'+lc_val
    copy to (lc_val) with cdx
    use (lc_val) alias drglogic
  endif  
enddo
set fullpath on
p_logic=substr(dbf(),rat('\',dbf())+1,30)
return

procedure apusel
parameter selfile
USE (selfile) alias drglogic
deactivate popup logicsel
release popup logicsel
return

define popup logicsel prompt files like ..\..\tabl_def\drgl_*.dbf
on selection popup logicsel do logisel with prompt()
wait window 'Select the NordDRG version' nowait
activate popup logicsel at 5,10 
SET ORDER TO ord

