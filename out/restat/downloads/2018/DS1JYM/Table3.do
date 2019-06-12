   
   
   /* If you have any questions on this do file do not hesitate to contact us */


clear all
clear matrix

set more off
set mem 700m
set maxvar 5500
capture sysdir set PLUS "C:\Documents and Settings\pcamp\My Documents\Dropbox\stata 11\ado\plus"
capture sysdir set PLUS "C:\Users\pam\Dropbox\stata 11\ado\plus"
capture sysdir set PLUS "c:\ado\plus\"



capture cd "C:\Users\Michel\Dropbox\campa-serafinelli\data"
capture cd "C:\Users\pcampa\Dropbox\campa-serafinelli\data"
capture cd "C:\Users\PAMELA\Dropbox\campa-serafinelli\data"
capture cd "C:\Users\Michel\Dropbox\campa-serafinelli\data"

capture log c
capture cd "C:\Users\pam\Dropbox\campa-serafinelli\data"
capture cd "C:\Users\Michel\Dropbox\campa-serafinelli\data"
capture cd "C:\Users\Michel\Dropbox\campa-serafinelli\data"
use gss_communism, clear
keep if coh1940_4==1|coh1990_4==1
label var inter_ex "CEEC x Post-1945"
log using Table_3, replace

********************************************************************************************************************************

* col 1

reg fefam_rec communism_ex after inter_ex gen1 gen2 gen3 gen4 male  reg_dum* , cluster(ctywave)


* col 2


reg fefam_rec communism_ex after inter_ex gen1 gen2 gen3 gen4 male  age age2 edu_l_p   married income satfin employed childs maeduc paeduc cath prot jew ort other_r polviews  reg_dum* ,  cluster(ctywave)


keep if after==0 | coh1967==1

* col 3
reg fefam_rec communism_ex after inter_ex gen1 gen2 gen3 gen4 male  reg_dum* , cluster(ctywave)



* col 4
reg fefam_rec communism_ex after inter_ex gen1 gen2 gen3 gen4 male age age2 edu_l_p   married income satfin employed childs maeduc paeduc cath prot jew ort other_r polviews   reg_dum* ,  cluster(ctywave)

log c
