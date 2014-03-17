PROCEDURE logic
SELECT drglogic
USE
DO ..\common\logicsel
select drgdistr
goto top
replace mdc with substr(p_logic, at('_',p_logic)+1, at('.', p_logic)-at('_',p_logic)-1)
DO grpohje
return