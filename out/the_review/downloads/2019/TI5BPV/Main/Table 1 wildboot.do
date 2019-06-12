
********************************************
***TABLE 1 (Wild cluster bootstrap p-values)
********************************************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using wildboot_table1, replace

********************************************
***PANEL A
********************************************

*COLUMN 1

use main_part1, clear

gen int1 = rep50*cumwar

#delimit ;
qui xtreg lrprice1 int1 obyear1-obyear5 i.year if audiencia=="Lima", fe;
# delimit cr

keep if audiencia=="Lima"

#delimit ;
xi: cgmwildboot lrprice1 int1 obyear1-obyear5 i.year i.provcode, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0);
# delimit cr


*COLUMN 2

use main_part1, clear

gen int1 = rep50*cumwar

#delimit ;
qui xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
# delimit cr

keep if audiencia=="Lima"


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0   0);
# delimit cr


*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar

#delimit ;
qui  xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
# delimit cr

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0   0   0   0   0   0);
# delimit cr


********************************************
***PANEL B
********************************************

*COLUMN 1


use main_part1, clear

gen int1 = rep50*war

#delimit ;
qui xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
# delimit cr

keep if audiencia=="Lima"


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 i.year i.provcode, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0);
# delimit cr


*COLUMN 2

use main_part1, clear

gen int1 = rep50*war

#delimit ;
qui xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
# delimit cr

keep if audiencia=="Lima"


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0   0);
# delimit cr


*COLUMN 3

use main_part1, clear

gen int1 = rep50*war


#delimit ;
qui xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
# delimit cr


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0   0   0   0   0   0);
# delimit cr

********************************************
***PANEL C
********************************************

*COLUMN 1

use main_part1, clear

gen int1 = lreparto2*cumwar

#delimit ;
qui xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
# delimit cr

keep if audiencia=="Lima"

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 i.year i.provcode, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0);
# delimit cr


*COLUMN 2

use main_part1, clear

gen int1 = lreparto2*cumwar

#delimit ;
qui xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
# delimit cr

keep if audiencia=="Lima"


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0   0);
# delimit cr


*COLUMN 3

use main_part1, clear

gen int1 = lreparto2*cumwar

#delimit ;
qui xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
# delimit cr


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0   0   0   0   0   0);
# delimit cr


log close
