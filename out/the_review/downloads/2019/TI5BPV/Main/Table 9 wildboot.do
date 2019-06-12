*********************************************
***TABLE 9 (Wild cluster bootstrap p-values)
*********************************************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"

log using wildboot_table9, replace

use main_panel, clear

*COLUMN 1

gen int1 = meanprice*ofsell
gen int2 = minpriceh*ofsell

#delimit ;
qui xtreg gov_reb int1 int2 ofsell obyear* i.year, fe;
# delimit cr


#delimit ;
xi: cgmwildboot gov_reb int1 int2 ofsell obyear* i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0);
# delimit cr

*COLUMN 2

gen int3 = meanprice*ofsell
gen int4 = firstpriceh*ofsell

#delimit ;
qui xtreg gov_reb int3 int4 ofsell obyear* i.year, fe;
# delimit cr


#delimit ;
xi: cgmwildboot gov_reb int3 int4 ofsell obyear* i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0);
# delimit cr


*COLUMN 3

gen int5 = soldpc*ofsell

#delimit ;
qui xtreg gov_reb int5 ofsell obyear* i.year, fe;
# delimit cr


#delimit ;
xi: cgmwildboot gov_reb int5 ofsell obyear* i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0);
# delimit cr

log close
