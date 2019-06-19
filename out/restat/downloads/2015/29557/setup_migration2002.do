clear
set more off
set mem 100m

use iiia_mg1, clear
recode mg30 (3=0)
recode mg31_1 (1 2 3=1) (4 5=0)
gen mg17p=(mg17p_2=="UNITED STATES") if mg17p_2!=""

egen mg_nmoves=max(secuencia), by(folio ls)
egen mg_age1st=min(mg13_2), by(folio ls)
egen mg_agelast=max(mg13_2), by(folio ls)

collapse (max) mg30 mg31_1 mg17p mg_nmoves mg_age1st mg_agelast, by(folio ls)
sort folio ls
save mg2002, replace

*****

use iiia_mt1, clear

gen mt05p=(mt05p_2=="UNITED STATES") if mt05p_2!=""
gen mt06p=(mt06p_2=="UNITED STATES") if mt06p_2!=""
recode mt19 (3=0)
recode mt20_1 (1 2 3=1) (4 5=0)

egen mt_nmoves=max(secuencia), by(folio ls)

collapse (max) mt19 mt20_1 mt05p mt06p mt_nmoves, by(folio ls)
sort folio ls
save mt2002, replace

