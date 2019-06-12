********************************************
***TABLE 4 (Wild cluster bootstrap p-values)
********************************************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"

log using wildboot_table4, replace

use main_part1, clear

*Conditioning on sold offices

keep if appoint==0

gen int1 = rep50*cumwar


*COLUMN 1

#delimit ;
qui xtreg noble int* obyear1-obyear5 gov_reb i.year, fe;
# delimit cr

#delimit ;
xi: cgmwildboot noble int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr


*COLUMN 2


#delimit ;
qui xtreg orden int* obyear1-obyear5 gov_reb i.year, fe;
# delimit cr

#delimit ;
xi: cgmwildboot orden int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr


*COLUMN 3

#delimit ;
qui xtreg military int* obyear1-obyear5 gov_reb i.year, fe;
# delimit cr


#delimit ;
xi: cgmwildboot military int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr

log close

