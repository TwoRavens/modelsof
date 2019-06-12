***********************************************************
*Replication file that builds the datasets for Teele, Dawn Langan. (2018?) "How the West Was Won: Competition, Mobilization, and Women’s Enfranchisement in the United States." Journal of Politics. 
*1893-1920
**********************************************************

* The raw data are collected and described in Teele_US_raw.xlsx


*This do file builds 3 datasets: 
* US_master_JOP, a cross-sectional dataset "scode" as in state code is unique id. 
* US_master_panel, a state-year dataset "scode year" is unique id.
* US_master_session, a session-year dataset "scode yearmin" is unique id.

*For the file to run, create two folders in the directory with the replication files -- one called "clean" which stores the data files generated herein, and another called "output" 



/*install the following packages 
ssc install rowsort

*/ 

cd "./Teele_replication" /*set your working directory*/ 
set more off
version 14.1


**********************************************************
*Make US_master_JOP.dta
******************************************************************



************************
*States and ICPR codes 
************************

import excel "./Teele_US_raw.xlsx", sheet("icpr") firstrow case(lower) clear
drop icprstate alpha
la var statehood_year "Year of Statehood"
encode region1, g(region11)
drop region1
ren region11 region1
la var region1 "Census Region Code"
la var region2 "Census Region Code, detail" 


save "./clean/icpr.dta", replace

************************
*Franchise Dates 
************************

import excel "./Teele_US_raw.xlsx", sheet("franchise") firstrow case(lower) clear
merge scode using "./clean/icpr.dta", sort
drop _m
drop if icpr==. /*get rid of hawaii, alaska, DC */ 

*generate franchise variables 
g fr_19th=1920 if fr_presidential==. & fr_full==.
la var fr_19 "No franchise till 19th Amend"
la var fr_presidential "Year of Presidential Franchise" 
la var fr_full "Year of Full Franchise" 
la var fr_school "Year of School Franchise"
la var fr_municipal "Year of Municipal Franchise" 
la var fr_notes "Notes Franchise Dates" 
recode fr_full (.=1920) 

*first type of enfranchisement
g fr_first=.
replace fr_first=fr_full
replace fr_first=fr_presidential if fr_first==. | fr_presidential<fr_full
replace fr_first=1920 if fr_first==.
la var fr_first "First date national franchise" 

g fr_typeology=1 if fr_full!=.
replace fr_typeology=2 if fr_presidential!=.
replace fr_typeology=3 if fr_19th==1920
assert fr_typeo!=.
la var fr_typeo "Franchise Typeology"

capture la define fr_typeo 1 "Full Franchise" 2 "Presidential" 3 "Nineteenth"
la values fr_typeo fr_typeo

*A dummy for whether full suffrage was granted before 19th amendment
g fr_dummy=1 if fr_typeo==1
 recode fr_dummy (.=0)
 la var fr_dummy "=1 if State granted full suffrage before 19th"
 la define fr_dummy 0 "no suffrage" 1 "suffrage"
 la val fr_dummy fr_dummy f
 
 la var nineteenth "Date of Ratification Nineteenth Amendment" 
 la var electoral_votes "Number of Electoral Votes After Full Franchise Won" 

save "./US_master.dta", replace

************************
*Skocpol Data on Women's Rights
************************

import excel "./Teele_US_raw.xlsx", sheet("skocpol") firstrow case(lower) clear
sort scode
la var minwage "Year Minimum Wage Laws Adopted" 
la var pension "Year Mothers' Pension Adopted" 
keep scode minwage pension

merge scode using "./US_master", uniqusing sort
drop _m
save "./US_master.dta", replace


************************
*Initiative & Referendum Reform at the State Level
************************ 

import excel "./Teele_US_raw.xlsx", sheet("initiative") firstrow case(lower) clear

la var initiative_adopted "Year Initiative Reform Adopted"
la var initiative_legislature "Year Initiative Reform Passed Legislature"
g initiative_pre=1 if initiative_adopted
recode initiative_pre (.=0)
la var initiative_pre "Initiative Rights Adopted Before Suffrage"

merge scode using "./US_master", uniqusing sort
drop _m
save "./US_master.dta", replace


************************
*Women's Rights as Sole Trader, Earnings Laws, Property. 
************************

import excel "./Teele_US_raw.xlsx", sheet("kahn") firstrow case(lower) clear

la var dt_property "Women's Property Rights"
la var dt_earnings  "Women's Earnings Laws"
la var dt_sole "Women's Sole Trader Laws"
destring dt_prop dt_earnings dt_sole, replace


merge scode using "./US_master", sort _merge(_m2)
drop _m*
save "./US_master", replace

************************
*Adoption of Australian (secret) Ballot, Direct Primary & Party Registration
************************
import excel "./Teele_US_raw.xlsx", sheet("secretballot") firstrow case(lower) clear

la var dt_directprimary "Year Direct Primary Adopted"
la var dt_secretballot "Year Australian Ballot Adopted"
la var harvey_party "Year Party Registration Adopted"


merge scode using "./US_master", sort _merge(_m2)
drop _m*


order scode icpr state region* fr*

isid scode /*scode is a unique identifier for this cross-sectional dataset */ 

save "./US_master", replace



********************************************************************************
*Make US_master_panel
********************************************************************************

************************
*Panel Data on Suffrage Membership (1893-1920)
************************
import excel "./Teele_US_raw.xlsx", sheet("banaszak") firstrow case(lower) clear

*there are two inaccurate state codes that I was able to pinpoint with dates of statehood in Banaszak's original data. 
replace scode="MD" if scode=="MY" /*1788*/
replace scode="NE" if scode=="NB" /*1867*/
replace scode="KS" if scode=="KA" /*1861*/
replace scode="CT" if scode=="CN" /*1788*/
replace scode="KY" if scode=="KN" /*1861*/

*No records for 1918, so I'm averaging 1917 and 1919 
sort scode year
bys scode: replace nawsa_member=(nawsa_member[_n-1]+nawsa_member[_n+1])/2 if nawsa_member==.
bys scode: replace nawsa_membpc=(nawsa_membpc[_n-1]+nawsa_membpc[_n+1])/2 if nawsa_membpc==.

la var nawsa_member "NAWSA Membership, total"
la var nawsa_membpc "NAWSA Membership, per thousand"


save "./clean/NAWSA.dta", replace


************************
*Panel Data on Women's Christian Temperance Union (WCTU) membership (1884-1940)
************************

import excel "./Teele_US_raw.xlsx", sheet("wctu") firstrow case(lower) clear

destring year, replace
destring wctu_dues, replace
destring wctu_aux, replace
destring wctu_memb, replace

*Some states had more than one dues paying organization. I'm going to collapse by state year

collapse (sum) wctu_dues (sum) wctu_aux (sum) wctu_memb, by(scode year)
la var wctu_dues "Dues paid to WCTU" /*covers all state organizations -- use this in paper*/
la var wctu_memb "Total membership WCTU" /*Data available only until 1892*/
la var wctu_aux "WCTU Auxiliaries" /*Data available only until 1892*/

recode wctu* (0=.)
drop if scode=="WAS" 

isid scode year
save "./clean/WCTU", replace



************************
*Sechrist Data on Dry Counties in the US (1848-1920)
************************
 

import excel "./Teele_US_raw.xlsx", sheet("sechrist") firstrow clear

keep ICPSRSTATE icpr ICPSRCNTY PROH1848-PROH1920

foreach year of num 1848/1920 {

	gen county_dry_`year'=1 if !inlist(PROH`year',"NO INFORMATION THAT COUNTY WAS DRY", "")
	recode county_dry_`year' (.=0)
}

*collapse to get the average number of dry counties within a state and then reshape to long.
collapse (mean) county_dry* , by(icpr)
reshape long county_dry_, i(icpr) j(year)
ren county fraction_dry_counties
isid icpr year

save "./clean/sechrist_clean.dta" , replace

************************
*DV: Passed both houses of the state legislature (1854-1920)
************************
 import excel "./Teele_US_raw.xlsx", sheet("cornwall") firstrow clear
 keep scode year passed_both

 *need to collapse to one observation per state-year (data originally organized by bill). 
 collapse (max) passed_both, by(scode year)
 save "./clean/passedboth.dta", replace
  
 

************************
*State Population (1870-1920)
************************
import excel "./Teele_US_raw.xlsx", sheet("statepop") firstrow clear


egen pop_males=rowtotal(WM FM BM NM)
egen pop_female=rowtotal(WF FF BF NF)

gen MFratio=(pop_males/pop_female)*100
la var MFratio "Men per 100 Women" 

la var WM "native white males"
la var WF "native white females"
la var FM "foreign white males"
la var FF "foreign white females"
la var BM "black males"
la var BF "black females"
la var NM "nonwhite males"
la var NF "nonwhite females"


drop if year>1920

save "./clean/statepop.dta", replace

********************************************************************************
*Machine Data (1860-1920)
********************************************************************************
import excel "./Teele_US_raw.xlsx", sheet("machine") firstrow clear
gen machine_share=machine_n/cities_n
recode machine_share (.=0)
la var machine_share "Share Large Cities with Machine" 
 la var machine_n "# cities in state with machine by year"
 la var machine_pop "Approximate population living in machine city, city >25k c.1900" 
 la var cities_n "# Cities >25k people c.1900"
la var cities_totalpop "Approximate Total Population of Cities >25k p c.1900"
la var machine_percentcitypop "Approximate percent of large city dwellers in machine city"

la var machines_dual "=1 if state has city with dualing machines c.1900" 
*get rid of District of Columbia
drop if scode=="DC"

save "./clean/machine.dta", replace


****The other machine data is "machine_people.dta" this 

**Second dataset has the total population living in machine cities (precisely measured)
import excel "./Teele_US_raw.xlsx", sheet("mach_people") firstrow clear


save "./clean/machine_people.dta", replace


************************
*State Assembly Data (1848-1924). 
************************
import excel "./Teele_US_raw.xlsx", sheet("stateassembly") firstrow clear
*the data has the total seats (e.g. sen_d has dem seats) and percent of legislature (e.g. sen_pd). 
gen odd = mod(year,2)
tab odd
*70 percent of observations are in even years, probably the election year, so if Burnham lists the date as 1848, I assume that November 1848 was the election, and therefore 1849 and 1850 represent one session year. Hence the value of 1 needs to be added to all the years before the dataset is expanded into an annual dataset. 
replace year=year+1


recode gov- hou_p2oth (999.9=.)

*>generally, during the civil war, 1854-1857 the assemblies didn't meet.

*south carolina is missing all data in 1848-1867

**Variable Creation 

*going to find which party is the winner while also generating variable containing largest and second largest party vote shares. 
****For the second largest, install rowsort program from ssc. "ssc install rowsort" 
*ssc install rowsort

*I'm going to use the percent varibles to make other constructions easier. 

foreach var in hou sen {

rowsort `var'_d `var'_r `var'_1oth `var'_2oth, gen(`var'max `var'runnerup `var'third `var'last)  descend

gen `var'_winner=0 if `var'max==`var'_d 	/*Dem*/ 
replace `var'_winner=1 if `var'max==`var'_r /* Rep */ 
replace  `var'_winner=2 if (`var'max==`var'_d & `var'max==`var'_r) | (`var'max==`var'_1oth & `var'max==`var'_2oth) | (`var'max==`var'_d  & `var'max==`var'_1oth) | (`var'max==`var'_r & `var'max==`var'_1oth) | (`var'max==`var'_d  & `var'max==`var'_2oth) | (`var'max==`var'_r & `var'max==`var'_2oth) /*Tie*/
replace `var'_winner=3 if `var'max==`var'_1oth | `var'max==`var'_2oth /*Third Party */ 

replace `var'_winner=. if `var'max==. 
}


*gov winner
g gov_winner=1 if gov==200
replace gov_winner=0 if gov==100
replace gov_winner=3 if gov!=. & !inlist(gov_winner, 0,1)

la define winner 0 "Dem" 1 "Rep" 2 "Tie" 3 "Third" /*Note no instances of Prohibition party governor*/ 
la val hou_winner sen_winner gov_winner winner

la var gov_w "Governor: D, R, Third"
la var gov "Governor Party" 


*Majority Surplus over both houses if both houses . 
g comp_majsurplus=(((houmax/hou_total)+(senmax/sen_total))/2)-.5
la var comp_majsurplus "Majority Surplus, average both houses" 


*Ratio of Runner up to winner over both houses if both houses are held by the same party. 
g comp_runnertowinner=((hourunner/hou_total)+(senrunner/sen_total))/((houmax/hou_total)+(senmax/sen_total)) 
la var comp_runnertowinner  "Ratio runner-up to winner, average both houses" 
*note 1=50/50 split


*Republican Control of Both
gen comp_RepBoth=1 if hou_winner==1 & sen_winner==1
recode comp_RepBoth (.=0) 
replace comp_Rep=. if sen_winner==. | hou_winner==.
la var comp_RepBoth "=1 if Republicans largest both houses"

*Dem Control of Both
gen comp_DemBoth=1 if hou_winner==0 & sen_winner==0
recode comp_DemBoth (.=0) 
replace comp_Dem=. if sen_winner==. | hou_winner==.
la var comp_DemBoth "=1 if Democrats largest both houses"

*Third Control of Both
gen comp_ThirdBoth=1 if hou_winner==3 & sen_winner==3
recode comp_ThirdBoth (.=0) 
replace comp_Third=. if sen_winner==. | hou_winner==.
la var comp_ThirdBoth "=1 if Third Party largest both houses"


*Third Party control of either house
gen comp_thirdcontrol=1 if hou_winner==3 | sen_winner==3
recode comp_third (.=0)
replace comp_third=. if sen_winner==. | hou_winner==.
la var comp_thirdcontrol "=1 if Third Party largest either house" 

*Fraction third party across both houses
egen n_third=rowtotal(sen_1oth sen_2oth hou_1oth hou_2oth)
gen comp_thirdfrac=n_third/(sen_total+hou_total)
la var comp_thirdfrac "Frac. Third Party both houses"


*Same party controls i.e. is the "largest" in  both houses 

gen comp_samecontrol=1 if hou_winner== sen_winner 
recode comp_samecontrol (.=0)
replace comp_samecontrol=. if sen_winner==. | hou_winner==.
la var comp_samecontrol "=1 if Same Party Largest Both Houses"

*comp split old definition
gen comp_split=1-comp_samecontrol
la var comp_split "=1 if Different Largest Party"

*Is Majority Same Party 
gen hoularge=(houmax/hou_total)
gen senlarge=(senmax/sen_total)
g comp_ismajority=1 if hoularge>.5 & senlarge>.5 & comp_samecontrol==1
recode comp_ismajority (.=0)
la var comp_ismajority "=1 if Same Party >.5 Both Houses"


*Supermajority
g comp_supermajority=1 if hoularge>=.66 & senlarge>=.66 & comp_samecontrol==1 
recode comp_supermajority (.=0)
la var comp_supermajority "=1 if Supermajority Both Houses"

*Majority Only 
gen comp_majorityonly=1 if comp_ismajority==1 & comp_supermajority!=1  & comp_samecontrol==1 
recode comp_majorityonly (.=0)
replace comp_majorityonly=. if comp_supermajority==1 /*super majority observations should not be in the zero set */
la var comp_majorityonly "Standard Majority, same party" 

*Split legislature
g comp_majsplit=1 if hoularge>.5 & senlarge>.5 & comp_samecontrol==0
recode comp_majsplit (.=0) 
replace comp_majsplit=. if sen_winner==. | hou_winner==.

la var comp_majsplit "Split Majorities Across Branches" 

*Only Plurality 
g comp_onlyplurality_same=1 if hoularge<.5 & senlarge<.5 & comp_samecontrol==1
la var comp_onlyplurality_same "No Majority, Same Largest" 

g comp_onlyplurality_different=1 if hoularge<.5 & senlarge<.5 & comp_samecontrol!=1
la var comp_onlyplurality_d "No Majority, Different Largest"
 
recode comp_onlyplurality_same comp_onlyplurality_different (.=0)



*Party Longevity

* the loop below goes through a convoluted way to get the sum of the years of the same governement in power for each house
* it marks as a 0 all of the civil war years. 
*
foreach var in hou sen { 
sort scode year 
bys scode: gen `var'_same=1 if `var'_winner==`var'_winner[_n-1] & `var'_winner!=.
recode `var'_same (.=0)
g `var'_nyears=1  if `var'_same==0

bys scode: replace `var'_nyears=`var'_nyears[_n-1]+`var'_same if `var'_nyears==.
*bys scode: replace `var'_nyears=0 if `var'_nyears==1 & `var'_same==0 & `var'_same[_n+1]==0 /*this code was wrong */ 
*drop `var'_same
la var `var'_nyears "Number of years same party rule in `var' " 
}

g comp_nyears=(sen_nyears+hou_nyears)/2

g comp_nyears_sameparty=(sen_nyears+hou_nyears)/2 if comp_samecontrol==1

replace comp_nyears_same=0 if comp_nyears==. & hou_winner!=. & sen_winner!=. 

la var comp_nyears "Longevity of party both houses, same party in both"


*Generate a legislative-session variable
sort icpr year
bys icpr: g session=_n
la var session "Legislative Session Counter"

isid scode year /*verify that "scode year" is the unique id */ 

*expand it into an annual panel
sort icpr year 
bys icpr: g diff=year[_n+1]-year
expand diff
bys icpr year: g n=_n-1
replace year=year+n
brow

egen yearmin=min(year), by(icpr session)
egen yearmax=max(year), by(icpr session)

la var hou_winner "Party Controls House" 
 la var sen_winner "Party Controls Senate" 
keep icpr year* gov* comp* session hou_winner sen_winner
save "./clean/stateassembly.dta", replace



***********************************************************************
********************************************************************************
********************************************************************************

********************************************************************************
*To create a panel first expand the ICPSR dataset with the icpr code and scode and then merge others in. 
********************************************************************************
*Make a dataset beginning with the year of statehood. 
use  "./clean/icpr.dta", clear
expand 73
*generate a counter to make the panel
bys scode: g n=_n-1
g year=1848+n
drop n
drop if inlist(scode,"AK","HI")
save "US_master_panel", replace



********************************************************************************
*Now expand the US_master cross-section into a panel
********************************************************************************
*First make the cross-sectional US_master a panel to make merging smoother. 
use "./US_master", clear
 
g totalyears=(1920-statehood_year)+1
expand =totalyears
*generate a counter to make the panel
bys scode: g n=_n-1
g year=statehood_year+n
drop totalyears n
 
*make dummy variables (with prefix "d") =1 all years after a reform is adopted
 
 # delimit ;
 foreach var of varlist dt_secretballot dt_direct harvey_party_registration  initiative_adopted dt_property dt_earnings dt_sole pension  minwage fr_school fr_municipal fr_presidential fr_full  {;
 # delimit cr 
 
 g d_`var'=1 if year>=`var' & `var'!=. & `var'!=0
 local l`var' : variable label `var'  /*keep variable labels from the original variable */ 
 label var d_`var' " =1 if `l`var'' "
 recode d_`var' (.=0)
 }
 
 *generate a counter of the number of states with full suffrage
 sort year
 egen n_fullsuffrage=sum(d_fr_full), by(year)
 la var n_fullsuffrage "N. States Full Suffrage" 
 
 
g decade=.
forval x=1830(10)1920 { 
local i=`x'+10
replace decade=`x' if year>=`x' & year<`i'
}

 egen icpr2=max(icpr), by(scode)
 *make sure that the panel is complete
brow if icpr2==.
*HI, AK, and washington DC not here because not states. 
drop if icpr2==.
drop icpr
ren icpr2 icpr 
brow if icpr==.
drop if icpr==.  
assert scode!=""
isid icpr year

drop if year<1848 
drop if year>1920

merge 1:1 scode year using "US_master_panel", gen(_master)


 
************************
*Now add other datasets to the new panel
*Need to make sure that the state identifier remains with each merge
************************
 merge 1:1 icpr year using "./clean/stateassembly.dta", gen(_mstateassmbly)
 drop if year<1848 
 drop if year>1920
 
 merge 1:1 scode year using "./clean/passedboth.dta", gen(_mpassedboth)
 
 merge 1:1 scode year using "./clean/NAWSA.dta", gen(_mNAWSA)
 merge 1:1 scode year using "./clean/WCTU.dta",  gen(_mWCTU)
 *12 obs from WCTU dataset don't merge, those are AK and HI, not states in our time frame. 
 drop if inlist(scode,"AK","HI")
 merge 1:1 icpr year using "./clean/sechrist_clean", gen(_msechrist)
 merge 1:1 scode year using  "./clean/statepop.dta", gen(_mstatepop)
 merge 1:1 scode year using  "./clean/machine_people.dta", gen(_machine1)
merge 1:1 scode year using  "./clean/machine.dta", gen(_machine)
*61 obs in machines didn't merge, these are values for years beyond 1920. 
 drop if year<1848 
 drop if year>1920
 
recode cities_n cities_totalpop cities_totalpop machine_n machine_pop machines_dual_c1900 machine_percentcitypop(.=0)


order scode state icpr region* decade year* 
drop if scode=="DC" 
drop if year<statehood_year
 
*Coding checks
isid scode year

isid icpr year

assert decade!=.
assert region1!=.

*Doing a check to see if the competition data came in accurately. These should all be 0. 
count if comp_Rep==1 & comp_split==1
count if comp_Dem==1 & comp_split==1
count if comp_Third==1 & comp_split==1

*want machine_pop/total_pop
gen machine_people= (machine_exactpop/ (pop_males + pop_female))*100
replace machine_people=0 if machine_pop==0
la var machine_people "Pop. Under Machines (%)"
gen totalpop=pop_males+pop_female
 
save "US_master_panel", replace
 

***********************
*Collapse to session-year panel 
*********************
 use "US_master_panel", clear
 isid scode year
 
 *Note that some of the series will have data for years in which there is no political competition data. For example, the year of statehood entry there is generally not competition data. Or for staes in the South (SC KS, e.g.) there is not data in years affected by the civil war. 
 *I'm going to get rid of observations where there is no session/year min or max because there is no competition data for these states and I would not be able to collapse otherwise. 
 
 tab session, mi
 browse scode  statehood_year year*  if session==.
 drop if session==.
 
*keep variable name before collapse
foreach v of var * {
 	local l`v' : variable label `v'
        if `"`l`v''"' == "" {
 		local l`v' "`v'"
  	}
 }

*took out no longer have info on referendum passage or on # house bills or # senate bills. (sum) hou_bill sen_bill

# delimit ;

collapse (max) passed_both initiative_adopted  

(firstnm)   hou_winner sen_winner statehood* fr_full  yearmin yearmax  region1  initiative_legislature dt_* d_* comp_RepBoth comp_DemBoth comp_ThirdBoth gov* decade comp_ismajority comp_supermajority comp_samecontrol comp_onlyplurality_same comp_onlyplurality_different comp_majorityonly

(mean) nawsa_member nawsa_membpc comp_split comp_majsplit comp_majsurplus* comp_runnertowinner* comp_thirdcontrol comp_thirdfrac comp_nyears* n_fullsuffrage   MFratio* wctu_dues wctu_aux wctu_memb fraction_dry cities_n cities_totalpop machine_n machine_pop machines_dual_c1900 machine_percentcitypop machine_share machine_people totalpop

, by(scode session) ;
# delimit cr


*attach saved labels after collapse
foreach v of var * {
 	label var `v' "`l`v''"
  }
  



isid scode session

sort scode yearmin
order scode year*

la val hou_winner sen_winner gov_winner winner
 label define region1 1 "MW" 2 "NE" 3 "S" 4 "W" 
 label values region1 region1 
 
 
 sort scode yearmin
keep if yearmin>=1893 & yearmax<1921
drop if yearmin>fr_full
recode  passed_both (.=0)
encode scode, gen(scode1)
xtset scode1 yearmin 

la var comp_majsurplus "Majority Surplus"
la var comp_nyears "Longevity Ruling Party" 
label var comp_runnertowinner "Runner-up / Winner " 

la var comp_majorityonly "Standard Majority"
la var comp_supermajority "Super Majority" 
 
la var  machine_share "Large Cities with Machine, frac." 
la var machine_percentcitypop "Urban Population in Machine City, frac." 
la var comp_thirdfrac "Third Party Presence, frac." 

la var comp_RepBoth "Republican Control"
la var comp_DemBoth "Democratic Control" 
la var comp_ThirdBoth "Third Control" 
la var machine_people "Pop. Under Machines (%)"


save "US_master_session", replace


STOP STOP

