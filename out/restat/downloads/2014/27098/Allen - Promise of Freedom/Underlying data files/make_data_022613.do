* This do-file creates the master data file

* update 08/18/12: distance to freedom incorporates the possibility of running to mexico, mothers are now age 16-44 instead of 20-44

clear
set more off
set mem 600m 
cap log close

global date = "022613" 

if c(username)=="treblaptop" {
	global dropbox = "C:\Users\Treb\Documents\My Dropbox"
}
else if c(username)=="dallen" {
	global dropbox = "C:\Users\dallen\Dropbox"
}

global dir = "$dropbox\Research\Fugitive Slave Law\Data"
cd "$dir"

use names_101309.dta

*** merging on county information
ren statefip state_fips
ren county county_code
sort state_fips county_code, stable

merge state_fips county_code using distance_difficulty_022313.dta

tab _merge /* so 99.9% of observations were correctly matched to county information, we just lose OK */
drop if _merge~=3 /* we only lose oklahoma */
drop _merge
sort state_fips county_code, stable

merge state_fips county_code using "./County Level Data/county_101110.dta", ///
	keep(pres* rail* water*   white_total_1840 black_total_1840 slave_total_1840 yr0to4_white_1840 yr5to9_white_1840 ///
	yr10to14_white_1840 yr15to19_white_1840 yr0to9_black_1840 yr10to23_black_1840 yr0to9_slave_1840 yr10o23_slave_1840 ///
	mom20to29_white_1840 mom30to39_white_1840 mom40to49_white_1840 mom50to59_white_1840 mom24to35_black_1840 ///
	mom36to54_black_1840 mom24to35_slave_1840 mom36to54_slave_1840) /* this gets us a little bit more information on voting, as well as water and rail transportation information and demographic information from 1840 */
tab _merge
drop if _merge~=3 /* again, only losing OK */
drop _merge

*** dropping some observations
drop if color==300 /* 2 american indians */
drop if qsex~=0 | qage~=0 | qholdsz~=0 /* flagged for quality */
drop if state_fips==34 /* New Jersey - 11 observations */

*** Creating explanatory variables

gen temp_yr=1850
replace temp_yr=1860 if year==86
drop year
ren temp_yr year

gen yr1860=(year==1860)

*** Control Variables 

** creating state-county variable
sort state_fips county_code, stable
egen statecounty=group(state_fips county_code)
egen plantation=group(year state_fips county_code serial)
lab var statecounty "State-County"
lab var plantation "Plantation"

** possible controls

* urban / rural
gen rural=(citypop==0)

* male
gen male=(sex==1)
lab var male "Male"

* plantation size
bysort year state_fips county_code serial: gen number_slaves = _N
lab var number_slaves "Number of slaves on plantation"

* small plantation dummy variables
gen small_holder1 = (number_slaves==1)
gen small_holder2 = (number_slaves==2)
gen small_holder3 = (number_slaves==3)
gen small_holder4 = (number_slaves==4)
gen small_holder10 = (number_slaves>4 & number_slaves<=10)

lab var small_holder1 "1 slave on plantation"
lab var small_holder2 "2 slaves on plantation"
lab var small_holder3 "3 slaves on plantation"
lab var small_holder4 "4 slaves on plantation"
lab var small_holder10 "5-10 slaves on plantation"

* mulatto
gen mulatto=(color==210)

* county crop production
foreach crop in cotton rice tobacco sugar {
	gen `crop'_val=.
	replace `crop'_val=`crop'_val_1850 if year==1850
	replace `crop'_val=`crop'_val_1860 if year==1860
	lab var `crop'_val "Value of `crop' production"
	}
	
gen total_crop = total_crop_1850 if year==1850
replace total_crop = total_crop_1860 if year==1860
lab var total_crop "Value of total crop production"

foreach crop in cotton rice tobacco sugar {
	replace `crop'_val = `crop'_val / 1000 if year==1860
	replace `crop'_val = `crop'_val / 100 if year==1850 /* they give it in different units in 1850 than in 1860! */	
	} 
	
	replace total_crop = total_crop / 1000 if year==1860
	replace total_crop = total_crop / 100 if year==1850 /* they give it in different units in 1850 than in 1860! */	

* changes in total crop production
gen total_crop_change = .
replace total_crop_change = total_crop_1860 / 1000 - total_crop_1850 / 100 if year==1860
replace total_crop_change = total_crop_1850 / 100 - total_crop_1840 / 1000 if year==1850
lab var total_crop_change "Change in value of total crop production over past 10 years"

* changes in adult population (to control for migration)

	* white migration
	gen migration_white = .
	replace migration_white = (white_total_1850-yr1to4_white_1850-yr5to9_white_1850) - (white_total_1840 -   yr0to4_white_1840 - yr5to9_white_1840) if year==1850
	replace migration_white = (white_total_1860-yr1to4_white_1860-yr5to9_white_1860)- (white_total_1850-yr1to4_white_1850-yr5to9_white_1850) if year==1860
	lab var migration_white "Change in non-child white population in county over past 10 years"
	
	* slave migration
	gen migration_slave = .
	replace migration_slave = (slave_total_1850 -   yr1to4_slave_1850 - yr5to9_slave_1850) - (slave_total_1840 - yr0to9_slave_1840) if year==1850
	replace migration_slave = (slave_total_1860 -   yr1to4_slave_1860 - yr5to9_slave_1860) - (slave_total_1850 -   yr1to4_slave_1850 - yr5to9_slave_1850) if year==1860
	lab var migration_white "Change in non-child slave population in county over past 10 years"
	
* Vote shares of democrats in most recent presidential election (1848 in 1850 and 1856 in 1860)
gen democrat = pres_1848_dem/100 if year==1850
replace democrat = pres_1856_dem/100 if year==1860
lab var democrat "Democratic vote share in previous presidential election"

* Railroad 
gen railroad = rail_1850 if year==1850
replace railroad = rail_1860 if year==1860
lab var railroad "Railroad in county"

* Water transport
gen water_transport = water_1850 if year==1850
replace water_transport = water_1860 if year==1860
lab var water_transport "Water transport in county"

* County adult population
gen white_population = white_total_1850 - under1_white_1850 -  yr5to9_white_1850 - yr10to14_white_1850 if year == 1850
replace white_population = white_total_1860 - under1_white_1860 -  yr5to9_white_1860 - yr10to14_white_1860 if year == 1860
lab var white_population "Adult White Population in County"

gen slave_population = slave_total_1850 - under1_slave_1850 -  yr5to9_slave_1850 - yr10to14_slave_1850 if year == 1850
replace slave_population = slave_total_1860 - under1_slave_1860 -  yr5to9_slave_1860 - yr10to14_slave_1860 if year == 1860
lab var slave_population "Adult Slave Population in County"

*** Distance variables
gen distance=.
replace distance=min(dist_north,dist_texas) if year==1850
replace distance=min(dist_canada,dist_texas) if year==1860
lab var distance "Distance to Freedom (miles)"

gen distance_sqrd = distance * distance
lab var distance_sqrd "Distance Squared"

gen distance_change=0
replace distance_change=(dist_canada-dist_north)/100 if year==1860
lab var distance_change "Change in miles to freedom from 10 years ago (100 miles)"

*** Difficulty variables

foreach var in rail water pres freeblack freeblack_frac slaves slaves_frac {
	gen difficulty_`var'=.
	replace difficulty_`var'=`var'_1850_difficulty if year==1850
	replace difficulty_`var'=`var'_1860_difficulty if year==1860
	}

*** Dependent variables

** Generating plantation level observations (average number of children per women, average age)
sort year state_fips county_code serial slavenum, stable
by year state_fips county_code serial slavenum: assert _n==1

by year state_fips county_code serial: gen plantation_unique=(_n==1)
lab var plantation_unique "One observation per plantation per year"

** Steckel (1982) using probate records, finds that the average age of first birth is 20 and the average age of last birth is 40.

* Because of age heaping, I'm going to keep it simple: number of children < 5 on plantation

cap drop temp*
gen temp_under5=(age<5) /* all kids less than 5 */
gen temp_mom=(age>=16 & age<45 & sex==2)
gen temp_dads = (age>=20 & age<45 & sex==1)
gen temp_young_mom=(age>=16 & age <30 & sex==2)
gen temp_old_mom=(age>=30 & age<45 & sex==2)
gen temp_men = (age>=15 & sex==1)
gen temp_women = (age>=15 & sex==2)
gen temp_olderkids = (age>=10 & age<15)


by year state_fips county_code serial: egen young_moms=sum(temp_young_mom)
lab var young_moms "Number of women 20-29 on plantation"

by year state_fips county_code serial: egen temp_plant_mom=sum(temp_mom)
by year state_fips county_code serial: egen temp_plant_under5=sum(temp_under5)
by year state_fips county_code serial: egen temp_plant_dad=sum(temp_dads)

by year state_fips county_code serial: egen adult_men=sum(temp_men)
by year state_fips county_code serial: egen adult_women=sum(temp_women)
by year state_fips county_code serial: egen kids_10to14=sum(temp_olderkids)

lab var adult_men "Number of men >14 on plantation"
lab var adult_women "Number of women >14 on plantation"

ren temp_plant_mom number_moms
lab var number_moms "Number of women 16-44 on plantation" /* this will be the plantation weighting */

by year state_fips county_code serial: egen old_moms=sum(temp_old_mom)
lab var old_moms "Number of women 30-44 on plantation"

lab var kids_10to14 "Children 10-14 years old"

ren temp_plant_under5 kids_under5
lab var kids_under5 "Number of children less than 5"

ren temp_plant_dad number_dads
lab var number_dads "Number of men 20-44 on plantation"

drop temp*

*** Fertility by year

forvalues a=1(1)15 {
	gen temp = (age==`a')
	by year state_fips county_code serial: egen kids_age`a'=sum(temp)
	lab var kids_age`a' "Number of children age `a' on plantation"
	drop temp*
	}
	
*** Age heaping by county (using the Myers' blended index)

	cap drop temp
	cap drop child_ageheap
	cap drop total_ageheap
	egen temp = group(year statecounty)
	gen child_ageheap = .
	gen total_ageheap = .
	qui sum temp
	local max = r(max)
	levelsof temp, local(levels)
	foreach l of local levels {
		return clear
		cap qui myers age if temp==`l', range(0 19) 
		qui replace child_ageheap = r(myers) if temp==`l'
		cap qui myers age if temp==`l', range(0 59)
		qui replace total_ageheap = r(myers) if temp==`l'
		disp `l'/`max'
		}

*** Saving the Data
lab dat "Ind. Slave 1850-1860 with distances & county info"
save master_$date.dta, replace
