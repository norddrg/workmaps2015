PROCEDURE apu_code
SELECT icd_10
SET FILTER TO AT('.',code_w)>0
REPLACE ALL code_w WITH SUBSTR(code_w,1,3)+SUBSTR(code_w,5,2)
SET FILTER TO LEN(TRIM(code_w))=3
REPLACE ALL code_w WITH TRIM(code_w)+'00'
SET FILTER TO LEN(TRIM(code_w))=4
REPLACE ALL code_w WITH TRIM(code_w)+'0'
SET FILTER TO d_code_w<>' '
SET FILTER TO AT('.',code_w)>0
REPLACE ALL code_w WITH SUBSTR(code_w,1,3)+SUBSTR(code_w,5,2)
SET FILTER TO AT('.',D_code_w)>0
REPLACE ALL d_code_w WITH SUBSTR(D_code_w,1,3)+SUBSTR(d_code_w,5,2)
SET FILTER TO LEN(TRIM(code_w))=3
REPLACE ALL code_w WITH TRIM(code_w)+'00'
SET FILTER TO LEN(TRIM(code_w))=4
REPLACE ALL code_w WITH TRIM(code_w)+'0'
SET FILTER TO LEN(TRIM(d_code_w))=3
REPLACE ALL d_code_w WITH TRIM(d_code_w)+'00'
SET FILTER TO LEN(TRIM(d_code_w))=4
REPLACE ALL d_code_w WITH TRIM(d_code_w)+'0'
SET FILTER TO
