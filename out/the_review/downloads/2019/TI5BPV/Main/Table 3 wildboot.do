
********************************************
***TABLE 3 (Wildcluster bootstrap p-values)
********************************************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using wildboot_table3, replace

********************************************
***PANEL A
********************************************

use main_part1, clear

*COLUMN 1

gen int1 = rep50*cumwar
gen int2 = ldistlima*cumwar

#delimit ;
qui xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
# delimit cr

keep if audiencia=="Lima"

#delimit ;
xi: cgmwildboot lrprice1 int* gov_reb obyear1-obyear5 i.year i.provcode, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0);
# delimit cr



*COLUMN 2

gen int3 = lz*cumwar

#delimit ;
qui xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
# delimit cr

#delimit ;
xi: cgmwildboot lrprice1 int* gov_reb obyear1-obyear5 i.year i.provcode, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0   0);
# delimit cr



*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar
gen int2 = ldistlima*cumwar
gen int3 = lz*cumwar
gen int4 = bishop*cumwar


#delimit ;
qui xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
# delimit cr

keep if audiencia=="Lima"

#delimit ;
xi: cgmwildboot lrprice1 int* gov_reb obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0   0   0);
# delimit cr


********************************************
***PANEL B
********************************************

use main_part1, clear

*COLUMN 1

gen int1 = rep50*cumwar 

#delimit ;
qui xtreg lrprice1 int* totalc obyear1-obyear5 i.year if audiencia=="Lima", fe;
# delimit cr

keep if audiencia=="Lima"

#delimit ;
xi: cgmwildboot lrprice1 int* totalc obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0);
# delimit cr


*COLUMN 2

use main_part1, clear

gen int1 = rep50*cumwar 

#delimit ;
qui xtreg lrprice1 int* totalc gov_reb obyear1-obyear5 i.year if audiencia=="Lima", fe;
# delimit cr

keep if audiencia=="Lima"


#delimit ;
xi: cgmwildboot lrprice1 int* totalc gov_reb obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0);
# delimit cr


*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar 

#delimit ;
qui xtreg lrprice1 int* totalc obyear1-obyear5 gov_reb i.year, fe;
# delimit cr

#delimit ;
xi: cgmwildboot lrprice1 int* totalc gov_reb obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0);
# delimit cr

log close
