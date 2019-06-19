/*** Run metro area level regressions using census micro data.
Use Full Time Full Year Men Only

***/

clear
set mem 2500m
set more off

capture log close
log using buildx70.log,replace text

do cntypop70.do

insheet using cw_stfips_sticp.csv, names
rename stateicp statecode
collapse (max) statecode statefips, by(statename)
drop if statecode==. & statefips==.

replace statecode=82 if statename=="Hawaii"
replace statecode=81 if statename=="Alaska"
replace statecode=98 if statename=="Columbia"

sort statecode
saveold sticp_fips_cw.dta, replace

/******* 1. Ready Crosswalk Between County Groups and Counties ********
This crosswalk is downloaded from the IPUMS website. If country has a countygroup code,
the contemporary boundaries were identified and found completely within one of the 1970 county group
codes. If there is no county grp. code listed, then contemporary county boundaries cross 1970 county grp. 
boundaries. **********/


insheet using cg_cnty_1970.csv, comma names clear
drop if cntycode==. & statecode==.

tab cntycode statecode if cntygrp==.
/*There are six counties with missing county group. those with double star no longer existed in 1970,
because they merged or consolidated with other counties or independent cities. The one with three stars is not identified*/

list state cntyname cntycode statecode if cntygrp==.


drop if cntygrp==.

/*These are records with repeated cntycode-statecode-cntygrp triples.They all have cntycode=9999 and they are 
probably small rural counties which are somehow not assigned a county code.*/ 

list if cntycode[_n]==cntycode[_n-1] & statecode[_n]==statecode[_n-1] & cntygrp[_n]==cntygrp[_n-1]

drop if cntycode==9999

sort statecode
merge statecode using sticp_fips_cw

tab _merge

list if _merge==1
*Hardcode statefips for Hawaii

replace statefips=15 if statecode==82

*Hardcode statefips for Alaska

replace statefips=2 if statecode==81

*Hardcode statefips for D.C.

replace statefips=11 if statecode==98


/*District of Columbia has statecode 98, missing county code, but non-missing countygrp
 in county-countygrp crosswalk. In crosswalk
between stateicp code and statefips, it has a statename=District of Colum., stateicp code=99, statefips==11 and old countycode=10
I looked up countyfips for D.C, but could not find it, but it is probably 1. */

replace cntycode=10 if statefips==11

list if _merge==2
drop if _merge==2
drop _merge

replace statefips=72 if state=="Puerto Rico"
replace statefips=41 if state=="Oregon"
/*in population data Carson City, Nevada has cntycode 510*/
replace cntycode=510 if (cntycode==5 & state=="Nevada")
replace statefips=32 if state=="Nevada"



/*Drop Puerto Rico*/
drop if statefips==72

/*Ready countyfips codes using old county codes (cntycodes):

The coding scheme of the variable cntycode follows that of Inter-University Consortium for Political and Social Research (ICPSR).
 The first 3 digits are identical to the FIPS county codes used in other datasets; ICPSR adds a digit to
 accomodate change over time (generally, if a county merged with another or was renamed before 1970, it receives a fourth digit of "5"). 
. So I will trim the last digit. */


gen cntycodestr=string(cntycode)
list if substr(cntycodestr,length(cntycodestr),1)~="0"
/*All of these have last digit=5. When we remove the last digit, the statefips-cntyfips pair still uniquely identify each county*/

generate cntyfips = substr(cntycodestr, 1, length(cntycodestr) - 1)

list if cntyfips==""

/*The fips code for Carson City in Nevada is calculated as 510 in 1970 county population data when I cut off the last digit of the county
code. So I will use that because Carson City has a county code=5 in cntygrp-county crosswalk which is fishy*/


replace cntyfips="510" if (state=="Nevada" & cntyname=="Carson City")

sort statefips cntyfips
saveold temp70.dta, replace

use cntypop70, clear
/*here cntycode is the old census county code, but the variable statecode is equal statefips*/
rename statecode statefips
rename cntyname cntynmpop70

gen cntycodestr=string(cntycode)
list if substr(cntycodestr,length(cntycodestr),1)~="0"
/*no county with last countycode digit equaling 5*/

generate cntyfips = substr(cntycodestr, 1, length(cntycodestr) - 1)


sort statefips cntyfips
saveold cntypop70.dta, replace

use temp70, clear

merge statefips cntyfips using cntypop70.dta, keep(pop cntynmpop70 statename)

tab _merge

drop if _merge==2

list statefips cntygrp cntyfips cntycode cntyname pop if _merge==1
/*there are 14 counties with _merge==1. Some of them have different countyfips codes in master vs. using dataset, and some
of them do not exist in using dataset. I will identify those that are coded differently and enter population info manually*/

saveold temp70, replace

use cntypop70, clear
sort statefips cntynmpop70
list statefips cntynmpop70 cntyfips cntycode pop if cntynmpop70=="Cordova-McCarthy"
*Try to locate Milton and Campbell
list statefips cntynmpop70 cntyfips cntycode pop if statefips==13

list statefips cntynmpop70 cntyfips cntycode pop if cntynmpop70=="Calvert"
*Find St. Genevieve
list statefips cntynmpop70 cntyfips cntycode pop if statefips==29
*Find Ormsby
list statefips cntynmpop70 cntyfips cntycode pop if statefips==32
*Look for Armstrong and Washington
list statefips cntynmpop70 cntyfips cntycode pop if statefips==46
*Look for Norfolk,Princess Anne and Elizabeth City
list statefips cntynmpop70 cntyfips cntycode pop if statefips==51
*Look for Weston and Yellowstone National Park
list statefips cntynmpop70 cntyfips cntycode pop if statefips==56

use temp70, clear

/*Those are identified in population data although statefips-countyfips pair did not match*/

replace pop=1857 if (cntyname=="Cordova-McCarthy" & statefips==2)
replace pop=20682 if (cntyname=="Calvert" & statefips==24)
replace pop=307951 if (cntyname=="Norfolk" & statefips==51)
replace pop=12867 if (cntyname=="Ste. Genevieve" & statefips==29)

drop if pop==.

keep statefips cntyfips cntygrp pop

destring statefips cntyfips, replace
sort statefips cntygrp cntyfips


saveold temp70,replace

** Change county codes to match price index data

do county-change-code.do
collapse (sum) pop, by(statefips cntygrp cntyfips)

** Drop Puerto Rico
drop if statefips==72

keep statefips cntyfips cntygrp pop

*** Assign Alternate MSA Codes and populations for those not identified in census
run msa-code.do
rename msa altmsa
egen msapop = sum(pop), by(altmsa)

/* to counties within each state and countygroup assign the msas (if there are multiple msas associated with a countygroup
 classify them as minmsa and maxmsa) */

egen maxmsa = max(altmsa), by(statefips cntygrp)
egen minmsa = min(altmsa), by(statefips cntygrp)

/*assign msa populations to counties within each countygroup by using the msa that the county belongs to (if multiple msas minpop and maxpop are 
different). two different county fipss with same msa code might be in different county groups. they will have same msapop.
 similarly two counties within same countygrp may have different msapop although they have same maxmsa.*/

egen maxpop = max(msapop*(altmsa==maxmsa)), by(statefips cntygrp)
egen minpop = max(msapop*(altmsa==minmsa)), by(statefips cntygrp)

/*calculate sum of county populations within a countygroup for those counties that belong to maxmsa and minmsa respectively. unlike for
minpop and maxpop here we use the sum of populations of counties (or towns) in the same state countygrp (so we do not add the population of counties
 that belongs to another state despite being in the same countygrp)*/

egen maxcpop = sum(pop*(altmsa==maxmsa)), by(statefips cntygrp)
egen mincpop = sum(pop*(altmsa==minmsa)), by(statefips cntygrp)

/*we assign a county (town) the msa code of the msa with higher population*/

replace altmsa = maxmsa if maxcpop>mincpop
replace msapop = maxpop if maxcpop>mincpop
replace altmsa = minmsa if mincpop>maxcpop
replace msapop = minpop if mincpop>maxcpop

/*we assign each countygrp associated with each state an msa and msapopulation as well as the countygrp mean of the county specific price indices,
 using county population as analytic weights for price index averaging*/

collapse (max) altmsa msapop, by(cntygrp)
sort cntygrp

save tempindex70.dta, replace


******** 3. Do basic setup of census micro data *******
 

#delimit ;
use metaread statefip cntygp97 
incwage incbus incfarm wkswork2 hrswork2 age sex raced higraded educrec
qincwage qincbus qincfarm qwkswork qage qsex qrace qeduc datanum pernum serial
using ../../ipums/metro/cenallmetro70.dta;
#delimit cr

rename cntygp97 cntygrp

*** Drop imputed wage observations
drop if qincwage~=0
drop if qincbus~=0
drop if qincfarm~=0
drop if qwkswork~=0


*** Drop imputed demographics 
drop if qsex~=0
drop if qrace~=0
drop if qage~=0
drop if qeduc~=0

*** Drop Self Employed
replace incwage = 0 if incwage==999999
replace incbus = 0 if incbus==999999
replace incfarm = 0 if incfarm==999999
drop if incbus ~= 0
drop if incfarm ~= 0

*** Drop nonworkers
drop if incwage==0
drop if wkswork2==0

rename statefip statefips

*** Merge on inflation data 
sort cntygrp
merge cntygrp using tempindex70.dta
tab _merge
keep if _merge==3
drop _merge


******************* 4. Build Control Variables *******************

/*we do not know whether they worked full time last year. so I will only keep fy people*/
gen fy = 0
replace fy = 1 if wkswork2>=4

gen race = int(raced/100)


/***** 5. Create interactions and main effects of 
demographic variables and location dummies **********/
compress

gen weekdum=wkswork2



** Create deflated weekly wage and salary income measures ($1999)

keep if (weekdum==0 | weekdum>=4)

gen Dedu=0
replace Dedu=1 if (higraded>=10 & higraded<=142)
replace Dedu=2 if (higraded>=150 & higraded<=150)
replace Dedu=3 if (higraded>=151 & higraded<=182)
replace Dedu=4 if (higraded>=190 & higraded<=190)
replace Dedu=5 if (higraded>=191 & higraded<=230)


* use average weeks worked in 1980 for each interval in wkswork2 to impute weekly wages for 1970

sort weekdum age Dedu
merge weekdum age Dedu using wkwrkmean, keep(avgww80)
tab _merge
tab age Dedu if _merge==1
keep if _merge==3
drop _merge

gen incwg_w = incwage/avgww80
gen lincwgb_w = log(incwg_w*166.6/36.7)
gen str stpuma = string(statefips)+string(cntygrp)
replace stpuma = "0"+stpuma if statefips<10

*********** Do sample selections **************
** less than 75 percent of current minimum wage in 1969 (U.S. Dept. of Labor: www.dol.gov/esa/whd/flsa/ )
drop if incwg_w<.75*1.60*40
drop if fy==0
drop if sex==2
drop if race~=1
drop if age<25 | age>54
***********************************************

**************** 5. Add Size Data ********************
*** Merge on 2000 size bins for size_a
sort altmsa
merge altmsa using msa_sizes.dta
tab _merge
drop if _merge==2

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
drop _merge
drop D*0

*** size_b is based on contemporaneous population deciles
replace msapop = 0 if altmsa==-9
sort msapop
gen perwt = 1
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


#delimit ;
keep age lincwgb size_a size_b size_c
stpuma metaread altmsa msapop
incwage incwg_w wkswork2 datanum pernum serial avgww80 Dedu;
#delimit cr
sort datanum serial pernum
merge 1:1 datanum serial pernum using /home/nbaumsn/ipums/samp5/ind70.dta, keepusing(ind1990 qind occ1990 qocc)
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

compress

saveold census70, replace

log close



erase temp70.dta
erase tempindex70.dta

