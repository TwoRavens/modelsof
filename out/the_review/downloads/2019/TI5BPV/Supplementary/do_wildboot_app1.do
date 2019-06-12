*****************************************************
***APPENDIX PART 1 (Wild cluster bootstrap p-values)
*****************************************************

capture log close
clear 
cd  "C:\Users\jenny\Dropbox\Replication Office-selling\Supplementary"

log using wildboot_app1, replace

***************************************************************************
*****Table A.3  Office Prices and Quartile Measures 
*****of Repartimiento in War versus Peace
***************************************************************************

use main_part1, clear

drop if lreparto2==. 
drop rep50

sum lreparto2, det
gen rep25 = 0 
replace rep25 = 1 if lreparto2<r(p25) 
tab rep25

sum lreparto2, det
gen rep50 = 0 
replace rep50 = 1 if lreparto2>=r(p25) & lreparto2<r(p50)
tab rep50 

sum lreparto2, det
gen rep75 = 0 
replace rep75 = 1 if lreparto2>=r(p50) & lreparto2<r(p75)
tab rep75

sum lreparto2, det
gen rep100 = 0 
replace rep100 = 1 if lreparto2>=r(p75)
tab rep100

gen int1 = rep50*cumwar
gen int2 = rep75*cumwar
gen int3 = rep100*cumwar

keep if audiencia=="Lima"

*COLUMN 1

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr

*COLUMN 2
#delimit ;
xi: cgmwildboot lrprice1 int* gov_reb obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0   0);
# delimit cr


*COLUMN 3

use main_part1, clear

drop if lreparto2==. 
drop rep50

sum lreparto2, det
gen rep25 = 0 
replace rep25 = 1 if lreparto2<r(p25) 
tab rep25

sum lreparto2, det
gen rep50 = 0 
replace rep50 = 1 if lreparto2>=r(p25) & lreparto2<r(p50)
tab rep50 

sum lreparto2, det
gen rep75 = 0 
replace rep75 = 1 if lreparto2>=r(p50) & lreparto2<r(p75)
tab rep75

sum lreparto2, det
gen rep100 = 0 
replace rep100 = 1 if lreparto2>=r(p75)
tab rep100

gen int1 = rep50*cumwar
gen int2 = rep75*cumwar
gen int3 = rep100*cumwar


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0   0   0   0);
# delimit cr


***************************************************************************
*****Table A.4 Office Prices and Repartimiento in 
*****War versus Peace: Only Succession Wars
***************************************************************************

*PANEL A

use main_part1, clear

gen int1 = rep50*twowars

keep if audiencia=="Lima"

*COLUMN 1

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0);
# delimit cr


*COLUMN 2

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0   0);
# delimit cr


*COLUMN 3

use main_part1, clear

gen int1 = rep50*twowars



#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0);
# delimit cr


*PANEL B

use main_part1, clear

gen war2 = 0
replace war2 = 1 if twowars>0

gen int1 = rep50*war2

*COLUMN 1

keep if audiencia=="Lima"

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0);
# delimit cr


*COLUMN 2

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0   0);
# delimit cr


*COLUMN 3

use main_part1, clear

gen war2 = 0
replace war2 = 1 if twowars>0

gen int1 = rep50*war2


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0);
# delimit cr



***************************************************************************
*****Table A.5 -- Including flexible time trends
***************************************************************************


*COLUMN 1

use main_part1, clear

gen int1 = rep50*cumwar

qui xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe

keep if e(sample)

tab provcode, gen(pdum)

xtset

*44 provinces

forvalues x=1(1) 44 {
gen trend`x'=0
replace trend`x'=pdum`x'*time
}

forvalues x=1(1) 44 {
gen trendsq`x'=0
replace trendsq`x'=pdum`x'*time*time
}


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 trend1-trend43 trendsq1-trendsq43 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr


*COLUMN 2

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 trend1-trend43 trendsq1-trendsq43 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0   0);
# delimit cr


*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar
qui xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe
keep if e(sample)

tab provcode, gen(pdum)

xtset

*48 provinces in model

forvalues x=1(1) 48 {
gen trend`x'=0
replace trend`x'=pdum`x'*time
}

forvalues x=1(1) 48 {
gen trendsq`x'=0
replace trendsq`x'=pdum`x'*time*time
}

	
#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 trend1-trend47 trendsq1-trendsq47 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr



***************************************************************************
*****Table A.8: Pre and Post Office-Selling (1752)
***************************************************************************

*PANEL A

use main_part1, clear

*COLUMN 1

#delimit ;
qui xtreg noble appointed obyear1-obyear5 gov_reb i.year, fe;
# delimit cr

#delimit ;
xi: cgmwildboot noble appointed obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr


*COLUMN 2


#delimit ;
qui xtreg orden appointed obyear1-obyear5 gov_reb i.year, fe;
# delimit cr

#delimit ;
xi: cgmwildboot orden appointed obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr


*COLUMN 3

#delimit ;
qui xtreg military appointed obyear1-obyear5 gov_reb i.year, fe;
# delimit cr


#delimit ;
xi: cgmwildboot military appointed obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr




*PANEL B

use data_tableA8, clear

gen ofsell = 0
replace ofsell = 1 if year<=1752

gen int1 = rep50*ofsell

#delimit ;
xi: cgmwildboot noble int* obyear1-obyear5 gov_reb  i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0);
# delimit cr


#delimit ;
xi: cgmwildboot orden int* obyear1-obyear5 gov_reb  i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0);
# delimit cr


#delimit ;
xi: cgmwildboot military int* obyear1-obyear5 gov_reb  i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0);
# delimit cr


************************************************************************************
********TABLE A.9: INCLUDE WAGES (COMPENSATION DIFFERENTIALS) **********************
************************************************************************************

use main_part1, clear

gen fivewage = wage*5
gen lfivewage = log(fivewage)

gen int1 = rep50*cumwar
gen int2 = lfivewage*cumwar

*COLUMN 1

keep if audiencia=="Lima"

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0);
# delimit cr


*COLUMN 2

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0   0);
# delimit cr


*COLUMN 3

use main_part1, clear

gen fivewage = wage*5
gen lfivewage = log(fivewage)

gen int1 = rep50*cumwar
gen int2 = lfivewage*cumwar


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr


***************************************************************************
*****Table A.10: Including forced labor, mining and indigenous population
***************************************************************************

use main_part1, clear

gen int1 = rep50*cumwar
gen int2 = mita*cumwar
gen int3 = mine*cumwar
gen int4 = lpop54*cumwar

keep if audiencia=="Lima"

*COLUMN 1

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
		0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
		0	0	0	0	0	0	0	0   0);
# delimit cr


*COLUMN 2

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
		0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
		0	0	0	0	0	0	0	0   0   0);
# delimit cr

*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar
gen int2 = mita*cumwar
gen int3 = mine*cumwar
gen int4 = lpop54*cumwar


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0   0   0);
# delimit cr


***************************************************************************
*****Table A.11: Including suitability and market presence
***************************************************************************

use main_part1, clear

gen int1 = econactivity2*cumwar


*PANEL A

keep if audiencia=="Lima"

*COLUMN 1

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr


*COLUMN 2
#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0   0);
# delimit cr


*COLUMN 3 

use main_part1, clear

gen int1 = econactivity2*cumwar


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0);
# delimit cr



*PANEL B

use main_part1, clear

gen int1 = suitindex*cumwar

*COLUMN 1

keep if audiencia=="Lima"

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0);
# delimit cr


*COLUMN 2

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0   0);
# delimit cr


*COLUMN 3

use main_part1, clear

gen int1 = suitindex*cumwar


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0);
# delimit cr


*PANEL C

use main_part1, clear

gen int1 = rep50*cumwar
gen int2 = econactivity2*cumwar
gen int3 = suitindex*cumwar

*COLUMN 1

keep if audiencia=="Lima"

#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr


*COLUMN 2

#delimit ;
xi: cgmwildboot lrprice1 int* gov_reb obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0   0);
# delimit cr


*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar
gen int2 = econactivity2*cumwar
gen int3 = suitindex*cumwar


#delimit ;
xi: cgmwildboot lrprice1 int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
	0	0	0	0   0);
# delimit cr



	
***************************************************************************
*****Table A.12 Controlling for Tax Revenue (at the caja level) 
***************************************************************************

use main_part1, clear

*PANEL A

gen int1 = rep50*cumwar 

keep if audiencia=="Lima"

*COLUMN 1

#delimit ;
xi: cgmwildboot lrprice1 int* alcabala obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr

*COLUMN 2

#delimit ;
xi: cgmwildboot lrprice1 int* alcabala gov_reb obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0   0);
# delimit cr

*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar 



#delimit ;
xi: cgmwildboot lrprice1 int* alcabala gov_reb obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr


*PANEL B


use main_part1, clear

gen int1 = rep50*cumwar 

*COLUMN 1

keep if audiencia=="Lima"

#delimit ;
xi: cgmwildboot lrprice1 int* tributonew obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr

*COLUMN 2

#delimit ;
xi: cgmwildboot lrprice1 int* tributonew gov_reb obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0   0);
# delimit cr

*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar 


#delimit ;
xi: cgmwildboot lrprice1 int* tributonew gov_reb obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0);
# delimit cr


*PANEL C

use main_part1, clear

gen int1 = rep50*cumwar 

*COLUMN 1

keep if audiencia=="Lima"

#delimit ;
xi: cgmwildboot lrprice1 int* mining obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr

*COLUMN 2

#delimit ;
xi: cgmwildboot lrprice1 int* mining gov_reb obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0   0);
# delimit cr


*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar 



#delimit ;
xi: cgmwildboot lrprice1 int* mining gov_reb obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0   0   0   0   0   0);
# delimit cr


*PANEL D

use main_part1, clear

gen int1 = rep50*cumwar 

*COLUMN 1

keep if audiencia=="Lima"

#delimit ;
xi: cgmwildboot lrprice1 int* totalc mining alcabala tributonew obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	);
# delimit cr

*COLUMN 2

#delimit ;
xi: cgmwildboot lrprice1 int* gov_reb totalc mining alcabala tributonew obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0);
# delimit cr

*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar 



#delimit ;
xi: cgmwildboot lrprice1 int* totalc mining alcabala tributonew gov_reb obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0);
# delimit cr


***************************************************************************
*****Table A.13 Appoint versus Sell
***************************************************************************

use main_part1, clear

gen int1 = rep50*cumwar

keep if audiencia=="Lima"

*COLUMN 1

#delimit ;
xi: cgmwildboot appoint int* obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0);
# delimit cr


*COLUMN 2

#delimit ;
xi: cgmwildboot appoint int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0   0);
# delimit cr

*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar




#delimit ;
xi: cgmwildboot appoint int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0   0  0 0 0 0);
# delimit cr


*PANEL B

use main_part1, clear

gen int1 = rep50*war

*COLUMN 1

keep if audiencia=="Lima"

*Model 1
#delimit ;
xi: cgmwildboot appoint int* obyear1-obyear5 i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0);
# delimit cr


*COLUMN 2

#delimit ;
xi: cgmwildboot appoint int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0   0);
# delimit cr

*COLUMN 3

use main_part1, clear

gen int1 = rep50*war




#delimit ;
xi: cgmwildboot appoint int* obyear1-obyear5 gov_reb i.year i.provcode, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	0	0	0	0	0	0	0	0	0	0   0  0 0 0 0);
# delimit cr

log close




















