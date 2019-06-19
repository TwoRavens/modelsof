

clear
set memory 5000m
set matsize 10500
set maxvar 32700
set more off

capture log close
log using buildx90.log, replace text


/******* 1. Ready Crosswalk Between PUMAs and Counties ********
This crosswalk is downloaded from the IPUMS website.        **/
     
insheet using puma5_cnty_1990.csv
rename state statefips
rename countyfipscode cntyfips
rename areapopulation pop
rename msapmsa msa
** Change county codes to match price index data
do county-change-code.do
collapse (sum) pop (max) msa, by(statefips puma cntyfips)
** Drop Puerto Rico
drop if statefips==72
egen maxmsa = max(msa), by(statefips puma)
egen minmsa = min(msa), by(statefips puma)
gen borderpuma = (maxmsa~=minmsa)
drop maxmsa minmsa
sort statefips cntyfips

keep statefips cntyfips puma pop

*** Assign Alternate MSA Codes and populations for those not identified in census
run msa-code.do
rename msa altmsa
egen msapop = sum(pop), by(altmsa)
egen maxmsa = max(altmsa), by(statefips puma)
egen minmsa = min(altmsa), by(statefips puma)
egen maxpop = max(msapop*(altmsa==maxmsa)), by(statefips puma)
egen minpop = max(msapop*(altmsa==minmsa)), by(statefips puma)
egen maxcpop = sum(pop*(altmsa==maxmsa)), by(statefips puma)
egen mincpop = sum(pop*(altmsa==minmsa)), by(statefips puma)
replace altmsa = maxmsa if maxcpop>mincpop
replace msapop = maxpop if maxcpop>mincpop
replace altmsa = minmsa if mincpop>maxcpop
replace msapop = minpop if mincpop>maxcpop

collapse (max) altmsa msapop, by(statefips puma)
sort statefips puma 
save tempindex90.dta, replace


******** 3. Do basic setup of census micro data *******

#delimit ;
use metaread statefip city puma
incwage incbus incfarm wkswork1 uhrswork age sex race perwt educ99 
qincwage qincbus qincfarm qwkswork quhrswor qage qsex qrace qeduc perwt pernum serial
using /home/nbaumsn/ipums/samp5/cenall905.dta;
#delimit cr

gen hoursamp = 1

replace incbus = 0 if incbus==999999
replace incfarm = 0 if incfarm==999999

*** Drop nonworkers
drop if incwage==0
drop if wkswork1==0
drop if uhrswork==0

rename statefip statefips

*** Merge on inflation data & msa info 
sort statefips puma
merge statefips puma using tempindex90.dta
tab _merge
drop if _merge==2 
drop _merge


******************* 4. Build Control Variables *******************

gen ft = 0
replace ft = 1 if uhrswork>=35
gen fy = 0 
replace fy = 1 if wkswork1<=52 & wkswork1>=40

gen race = int(raced/100)

** Create deflated hourly wage and salary income measures
gen incwg = incwage/(wkswork1*uhrswork)
gen lincwgb = log(incwg*166.6/124)

*Create weekly wages
gen incwg_w = incwage/wkswork1
gen lincwgb_w = log(incwg_w*166.6/124)

gen str stpuma = string(statefips)+string(puma)
replace stpuma = "0"+stpuma if statefips<10 


***************** 5. Define Educations & Sizes *********************

*** Merge on 2000 size bins for size_a
sort altmsa
merge altmsa using msa_sizes.dta
tab _merge
keep if _merge==3
drop _merge

*** size_c is based on fixed cutoffs based on 2000 deciles
gen size_c = 0 if altmsa==-9
replace size_c = 1 if size_c==. & msapop > 0 & msapop <= D10
replace size_c = 2 if size_c==. & msapop > D10 & msapop <= D20
replace size_c = 3 if size_c==. & msapop > D20 & msapop <= D30
replace size_c = 4 if size_c==. & msapop > D30 & msapop <= D40
replace size_c = 5 if size_c==. & msapop > D40 & msapop <= D50
replace size_c = 6 if size_c==. & msapop > D50 & msapop <= D60
replace size_c = 7 if size_c==. & msapop > D60 & msapop <= D70
replace size_c = 8 if size_c==. & msapop > D70 & msapop <= D80
replace size_c = 9 if size_c==. & msapop > D80 & msapop <= D90
replace size_c = 10 if size_c==. & msapop > D90
drop D*0


*** size_b is based on contemporaneous population deciles
replace msapop = 0 if altmsa==-9
sort msapop
egen totwt = sum(perwt) if msapop>0
gen pctile = sum(perwt/totwt) if msapop>0
gen d10 = (round(pctile-.1,.01)==0)*msapop
egen D10 = max(d10)
gen d20 = (round(pctile-.2,.01)==0)*msapop
egen D20 = max(d20)
gen d30 = (round(pctile-.3,.01)==0)*msapop
egen D30 = max(d30)
gen d40 = (round(pctile-.4,.01)==0)*msapop
egen D40 = max(d40)
gen d50 = (round(pctile-.5,.01)==0)*msapop
egen D50 = max(d50)
gen d60 = (round(pctile-.6,.01)==0)*msapop
egen D60 = max(d60)
gen d70 = (round(pctile-.7,.01)==0)*msapop
egen D70 = max(d70)
gen d80 = (round(pctile-.8,.01)==0)*msapop
egen D80 = max(d80)
gen d90 = (round(pctile-.9,.01)==0)*msapop
egen D90 = max(d90)
global p10 = D10[1]
global p20 = D20[1]
global p30 = D30[1]
global p40 = D40[1]
global p50 = D50[1]
global p60 = D60[1]
global p70 = D70[1]
global p80 = D80[1]
global p90 = D90[1]
drop d*0 D*0
gen size_b = 0 if altmsa==-9
replace size_b = 1 if msapop<=$p10 & size_b==.
replace size_b = 2 if msapop>$p10 & msapop<=$p20 & size_b==.
replace size_b = 3 if msapop>$p20 & msapop<=$p30 & size_b==.
replace size_b = 4 if msapop>$p30 & msapop<=$p40 & size_b==.
replace size_b = 5 if msapop>$p40 & msapop<=$p50 & size_b==.
replace size_b = 6 if msapop>$p50 & msapop<=$p60 & size_b==.
replace size_b = 7 if msapop>$p60 & msapop<=$p70 & size_b==.
replace size_b = 8 if msapop>$p70 & msapop<=$p80 & size_b==.
replace size_b = 9 if msapop>$p80 & msapop<=$p90 & size_b==.
replace size_b = 10 if msapop>$p90 & size_b==.

gen Dedu = 0
replace Dedu = 1 if educ99>=1 & educ99<=9
replace Dedu = 2 if educ99==10
replace Dedu = 3 if educ99>=11 & educ99<=13
replace Dedu = 4 if educ99==14
replace Dedu = 5 if educ99>=15 & educ99<=17

#delimit ;
keep age lincwgb lincwgb_w size_a size_b size_c
Dedu perwt stpuma altmsa msapop metaread ft fy sex raced 
incwage incwg_w wkswork1 uhrswork hoursamp pernum serial;
#delimit cr

sort serial pernum
merge 1:1 serial pernum using /home/nbaumsn/ipums/samp5/ind90.dta, keepusing(ind1990 qind occ1990 qocc)
tab _merge
keep if _merge==3
drop _merge

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

gen Dage = int((age+1)/2)

compress
saveold census90, replace


erase tempindex90.dta

log close

