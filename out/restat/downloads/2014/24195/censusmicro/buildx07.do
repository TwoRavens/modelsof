** This do-file is exactly the same as build00.do except uses the 2007 acs data

clear
set memory 600m 
set matsize 10500
set maxvar 32700
set more off

capture log close
log using buildx07.log,replace


/******* 1. Ready Crosswalk Between PUMAs and Counties ********
This crosswalk is downloaded from the IPUMS website.
     A       Summary Level Code
 780 State-SuperPUMA-PUMA
 781 State-SuperPUMA-PUMA-County (or part)
 782 State-SuperPUMA-PUMA-County-County Subdivision (or part) (20 states with functioning county subdivisions)
 783 State-SuperPUMA-PUMA-County-County Subdivision-Place/Remainder (or part)
 784 State-SuperPUMA-PUMA-County-County Subdivision-Place/Remainder-Census Tract
     B       FIPS State Code
     C       SuperPUMA Code
     D       PUMA Code
     E       FIPS County Code
     F       FIPS County Subdivision Code
     G       FIPS Place Code
     H       Central City Indicator:
               0 = Not in central city
               1 = In central city
     I       Census Tract Code
     J       Metropolitan Statistical Area/Consolidated Statistical Area Code
     K       Primary Metropolitan Statistical Area Code
     L       Census 2000 100% Population Count
     M       Area Name  **/
insheet using pumas_cnty_2000.csv
keep if a==781
rename b statefips
rename d puma
rename e cntyfips
rename l pop
rename j msa
**** Use PMSAs if applicable (note that number may not match up)
replace msa = k if k~=.
keep statefips puma cntyfips pop msa
sort statefips cntyfips 
** Change county codes to match price index data
do county-change-code.do
collapse (sum) pop (max) msa, by(statefips puma cntyfips)
** Drop Puerto Rico
drop if statefips==72
save temp07.dta, replace
gen year = 2007
append using temp07.dta
replace year = 2006 if year==.

*** After Katrina, 3 PUMAs in and Around New Orleans Were Merged
replace puma = 77777 if statefips==22 & (puma==1905|puma==1801|puma==1802)
collapse (sum) pop (max) msa, by(year statefips puma cntyfips)

append using temp07.dta
replace year = 2005 if year==.

keep statefips cntyfips puma pop year

*** Assign Alternate MSA Codes and populations for those not identified in census
run msa-code.do
rename msa altmsa
egen msapop = sum(pop), by(year altmsa)
egen maxmsa = max(altmsa), by(year statefips puma)
egen minmsa = min(altmsa), by(year statefips puma)
egen maxpop = max(msapop*(altmsa==maxmsa)), by(year statefips puma)
egen minpop = max(msapop*(altmsa==minmsa)), by(year statefips puma)
egen maxcpop = sum(pop*(altmsa==maxmsa)), by(year statefips puma)
egen mincpop = sum(pop*(altmsa==minmsa)), by(year statefips puma)
replace altmsa = maxmsa if maxcpop>mincpop
replace msapop = maxpop if maxcpop>mincpop
replace altmsa = minmsa if mincpop>maxcpop
replace msapop = minpop if mincpop>maxcpop

collapse (max) altmsa msapop, by(year statefips puma)
replace msapop = -9 if altmsa==-9
sort year statefips puma

save tempindex07.dta, replace


******** 3. Do basic setup of census micro data *******
** (year is for spatial price index merge)

#delimit ;
use metaread statefip metro puma ind1990 occ1990 qind qocc
incwage incbus00 wkswork1 uhrswork age sex race perwt educ99 
qincwage qincbus qwkswork quhrswor qage qsex qrace qeduc perwt serial pernum
using /home/nbaumsn/ipums/acs/acs2007.dta;
gen year = 2007;
save temp07.dta, replace;
use metaread statefip metro puma ind1990 occ1990 qind qocc
incwage incbus00 wkswork1 uhrswork age sex race perwt educ99 
qincwage qincbus qwkswork quhrswor qage qsex qrace qeduc perwt serial pernum
using /home/nbaumsn/ipums/acs/acs2006.dta;
gen year = 2006;
save temp06.dta, replace;
use metaread statefip metro puma ind1990 occ1990 qind qocc
incwage incbus00 wkswork1 uhrswork age sex race perwt educ99 
qincwage qincbus qwkswork quhrswor qage qsex qrace qeduc perwt serial pernum
using /home/nbaumsn/ipums/acs/acs2005.dta;
#delimit cr
gen year = 2005
append using temp06.dta
append using temp07.dta

gen hoursamp = 1

*** Drop imputed wage observations
replace hoursamp = 0 if qincwage~=0
replace hoursamp = 0 if qincbus~=0
replace hoursamp = 0 if qwkswork~=0
replace hoursamp = 0 if quhrswor~=0

*** Drop imputed age/sex/race/educ
drop if qage~=0
drop if qsex~=0
drop if qrace~=0
drop if qeduc~=0

*** Fix incwage for people with capital income
replace incbus00 = 0 if incbus00==999999
drop if incbus00 ~= 0 

*** Drop nonworkers
drop if incwage==0
drop if wkswork1==0
drop if uhrswork==0

rename statefip statefips

*** Merge on inflation data & msa info
sort year statefips puma
merge year statefips puma using tempindex07.dta
tab _merge
keep if _merge==3
drop _merge


******************* 4. Build Control Variables *******************

gen ft = 0
replace ft = 1 if uhrswork>=35
gen fy = 0 
replace fy = 1 if wkswork1<=52 & wkswork1>=40

** Create deflated weekly wage and salary income measures
gen incwg = incwage/(wkswork1*uhrswork)
gen lincwgb = log(incwg*166.6/207.342) if year==2007
replace lincwgb = log(incwg*166.6/201.6) if year==2006
replace lincwgb = log(incwg*166.6/195.3) if year==2005

*Create weekly wages
gen incwg_w = incwage/wkswork1
gen lincwgb_w = log(incwg_w*166.6/207.342) if year==2007
replace lincwgb_w = log(incwg_w*166.6/201.6) if year==2006
replace lincwgb_w = log(incwg_w*166.6/195.3) if year==2005

gen str stpuma = string(statefips)+string(puma)
replace stpuma = "0"+stpuma if statefips<10

*********** Do sample selections **************
** < 75 percent of min wage in 2006
drop if incwg<.75*5.15
keep if fy==1
gen edusamp = 1
gen wksamp = hoursamp
replace hoursamp = 0 if ft==0
replace edusamp = 0 if ft==0
keep if sex==1
keep if race==1
keep if age>=25 & age<=54
***********************************************

**** Adjust wages to have the same median in each year
egen sumwt = sum(perwt), by(year)
sort year lincwgb
by year: gen cdf = sum(perwt/sumwt)
by year: gen mdn = cdf>=0.5 & cdf[_n-1]<0.5
gen mdlinc = lincwgb if mdn==1
egen mlinc = max(mdlinc), by(year)
gen m06linc = mdlinc if year==2006
egen M06linc = max(m06linc)
replace lincwgb = lincwgb-mlinc+M06linc
drop mdn cdf mdlinc mlinc m06linc M06linc

sort year lincwgb_w
by year: gen cdf = sum(perwt/sumwt)
by year: gen mdn = cdf>=0.5 & cdf[_n-1]<0.5
gen mdlinc = lincwgb_w if mdn==1
egen mlinc = max(mdlinc), by(year)
gen m06linc = mdlinc if year==2006
egen M06linc = max(m06linc)
replace lincwgb_w = lincwgb_w-mlinc+M06linc
drop mlinc m06linc M06linc

***************** 5. Define Educations & Sizes *********************

*** 2007 MSA pops are the same as the 2000 pops
sort altmsa
merge altmsa using msa_sizes.dta
tab _merge
keep if _merge==3
drop _merge

gen size_b=size_a
gen size_c=size_b

gen Dedu = 0
replace Dedu = 1 if educ99>=1 & educ99<=9
replace Dedu = 2 if educ99==10
replace Dedu = 3 if educ99>=11 & educ99<=13
replace Dedu = 4 if educ99==14
replace Dedu = 5 if educ99>=15 & educ99<=17

#delimit ;
keep lincwgb lincwgb_w age size_a size_b size_c edusamp
Dedu perwt stpuma altmsa msapop metaread ind1990 year occ1990 qind qocc
incwage incwg_w wkswork1 uhrswork hoursamp serial pernum wksamp;
#delimit cr



/*INDCLASS=0 MEANS NOT APPLICABLE*/
gen indclass=0
/*AGRICULTURE, FORESTRY, AND FISHERIES & MINING*/
replace indclass=1 if ind1990>=010 & ind1990<=050
/*CONSTRUCTION*/
replace indclass=2 if ind1990>=060 & ind1990<=060
/*MANUFACTURING*/
replace indclass=3 if ind1990>=100 & ind1990<=392
/*TRANSPORTATION, COMMUNICATIONS, AND OTHER PUBLIC UTILITIES*/
replace indclass=4 if ind1990>=400 & ind1990<=472
/*WHOLESALE TRADE */
replace indclass=5 if ind1990>=500 & ind1990<=571
/*RETAIL TRADE*/
replace indclass=6 if ind1990>=580 & ind1990<=691
/*FINANCE, INSURANCE, AND REAL ESTATE  */
replace indclass=7 if ind1990>=700 & ind1990<=712
/* SERVICES  */
replace indclass=8 if ind1990>=721 & ind1990<=893
/*PUBLIC ADMINISTRATION  */
replace indclass=9 if ind1990>=900 & ind1990<=932
/*DROP ACTIVE DUTY MILITARY */
drop if ind1990>=940 & ind1990<=960

tab indclass

gen Dage = int((age+1)/2)

#delimit ;
label define indlbl 1 "agro, mining" 2 "construction" 3 "manufacturing" 
4 "tcpu" 5 "wholesale trade" 6 "retail trade" 7 "fire" 8 "services"
9 "public admin";
#delimit cr

label values indclass indlbl
compress
saveold census07.dta, replace

erase temp06.dta
erase temp07.dta
erase tempindex07.dta


log close
