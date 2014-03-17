procedure icd9lis
clear all
on key label f12 do c:\data\icd_9\lisays
USE c:\data\icd_9\icd9cm_d.dbf
SET ORDER TO TAG Icd9_cm OF c:\data\icd_9\icd9cm_d.cdx
browse save nowait
return

