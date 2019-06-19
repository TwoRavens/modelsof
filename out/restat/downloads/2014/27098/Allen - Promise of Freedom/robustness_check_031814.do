*** Individual Data (loading free data)
clear
set more off
set mem 1000m
set seed 01684321

global date = "120513"

use ".\Free Data\data_041709.dta"

ren statefip state_fips
ren county county_code
ren hhwt weight
sort state_fips county_code, stable

merge state_fips county_code using ".\Underlying data files\distance_difficulty_022313.dta"

tab _merge /* so 99.67% of observations were correctly matched to county information */
drop if _merge~=3 /* Arizona and South Dakota, 91 observations */
sort state_fips county_code, stable
drop _merge

merge state_fips county_code using ".\Underlying data files\county_101110.dta", ///
	keep(pres* rail* water*   white_total_1840 black_total_1840 slave_total_1840 yr0to4_white_1840 yr5to9_white_1840 ///
	yr10to14_white_1840 yr15to19_white_1840 yr0to9_black_1840 yr10to23_black_1840 yr0to9_slave_1840 yr10o23_slave_1840 ///
	mom20to29_white_1840 mom30to39_white_1840 mom40to49_white_1840 mom50to59_white_1840 mom24to35_black_1840 ///
	mom36to54_black_1840 mom24to35_slave_1840 mom36to54_slave_1840) /* this gets us a little bit more information on voting, as well as water and rail transportation information and demographic information from 1840 */
tab _merge
drop if _merge~=3 /* again, only losing OK */
drop _merge

keep if slave_state==1

*** Creating explanatory variables

gen yr1860=(year==1860)

*** Control Variables 

** creating state-county variable
sort state_fips county_code, stable
egen statecounty=group(state_fips county_code)
egen plantation=group(year state_fips county_code serial)
lab var statecounty "State-County"
lab var plantation "Plantation"

** plantation unique identifer
bysort plantation: gen plantation_unique=(_n==1)
lab var plantation_unique "Unique identifier for each plantation"

** possible controls

* urban / rural
gen rural=(citypop==0)

* male
gen male=(sex==1)
lab var male "Male"

* size of household
ren dwsize sizehold
replace sizehold=. if sizehold==9999 /* 99 observations */
gen plant_size=sizehold

* small plantation dummy variables
gen small_holder1 = (plant_size==1)
gen small_holder2 = (plant_size==2)
gen small_holder3 = (plant_size==3)
gen small_holder4 = (plant_size==4)
gen small_holder10 = (plant_size>4 & plant_size<=10)

lab var small_holder1 "1 person in household"
lab var small_holder2 "2 people in household"
lab var small_holder3 "3 people in household"
lab var small_holder4 "4 people in household"
lab var small_holder10 "5-10 people in household"

* fraction of young mothers and fraction male
	cap drop temp*
	gen temp_young = (age>=16 & age<30 & sex==2)
	gen temp_mom = (age>=16 & age<45 & sex==2)
	gen temp_male = (age>=16 & sex==1)
	gen temp_adult = (age>=16)
	foreach type in young mom male adult {
		bysort year state_fips county_code serial: egen temp_`type'2=sum(temp_`type')
	}
	
	gen frac_youngmom = temp_young2 / temp_mom2
	gen frac_male = temp_male2 / temp_adult2
	

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

* County adult population
gen white_population = white_total_1850 - under1_white_1850 -  yr5to9_white_1850 - yr10to14_white_1850 if year == 1850
replace white_population = white_total_1860 - under1_white_1860 -  yr5to9_white_1860 - yr10to14_white_1860 if year == 1860
lab var white_population "Adult White Population in County"

gen slave_population = slave_total_1850 - under1_slave_1850 -  yr5to9_slave_1850 - yr10to14_slave_1850 if year == 1850
replace slave_population = slave_total_1860 - under1_slave_1860 -  yr5to9_slave_1860 - yr10to14_slave_1860 if year == 1860
lab var slave_population "Adult Slave Population in County"

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

*** Distance variables
	gen distance=.
	replace distance=min(dist_north,dist_texas)/100 if year==1850
	replace distance=min(dist_canada,dist_texas)/100 if year==1860
	lab var distance "Distance to Freedom (100 miles)"
	cap drop distance_sqrd
	gen distance_sqrd = distance^2
	lab var distance_sqrd "Distance to freedom squared"


*** Dependent variables
	cap drop temp*
	sort year state_fips county_code serial, stable
	
** White / black households

	gen temp_black = (race==2)
	by year state_fips county_code serial: egen temp_sum_black = sum(temp_black) /* number of blacks in household */
	by year state_fips county_code serial: gen black_hh = (temp_sum_black == _N) /* all members of the household are black */
	by year state_fips county_code serial: gen white_hh = (temp_sum_black == 0) /* no members of the household are black */

	tab black_hh white_hh /* so more mixed households than all black households */


* kids under 5
	cap drop temp*
	gen temp_under5=(age<5) /* all kids less than 5 */
	gen temp_mom = (age>=16 & age<45 & sex==2) /* potential mothers */
	by year state_fips county_code serial: egen kids_under5=sum(temp_under5) /* total number of kids<5 in household */
	by year state_fips county_code serial: egen number_moms=sum(temp_mom) /* total number of potential mothers in household */
	gen fertility_rate = kids_under5 / number_moms
	lab var fertility_rate "# kids <5 / # women 16-44"

*** Regressions

** Controls and Fixed Effects

cap drop temp*

xi i.state_fips*i.year /* so we have state-year fixed effects */

global controls_plant = " frac_youngmom frac_male plant_size small_holder1 small_holder2 small_holder3 small_holder4 small_holder10 rural "
global controls_county = " cotton_val rice_val tobacco_val sugar_val total_crop total_crop_change railroad water_transport white_population slave_population migration_white migration_slave"
global yearFE = " yr1860 "
global stateFE = " _I* "

** Missing controls are dummied out
foreach control of var $controls_county {
	gen no_`control' = (`control'==.)
	replace `control' = 0 if no_`control'==1
	}
	
global dummy_county = " no_* "

* Interaction of year and control variables (so controls have different effects in both years)
foreach var of var $controls_plant $controls_county {
	gen yr1860X`var' = `var'*yr1860
	}

global controls_inter = " yr1860X* " 


* cluster at statecounty-year level
egen statecounty_year = group(statecounty year)

cd "$dir\Empirics"


	* whites
		areggrp fertility_rate distance distance_sqrd $controls_plant $controls_county $controls_inter $dummy_controls $yearFE if plantation_unique==1 & white_hh==1, a(statecounty) cluster(statecounty_year) weight(plant_size) tol(0.01)
		keep if e(sample)

		gen lat = lattitude + 0.001*uniform() /* this just needed to get rid of zero distances */
		gen lon = longitude + 0.001*uniform() /* this just needed to get rid of zero distances */

		* Need to create the distance matrix for every sample 
			cap prog drop treb_dist
			prog treb_dist
				shell erase "distance.mmat"
				preserve
				keep if e(sample)
				egen loc_id = group(lattitude longitude)
				bysort loc_id: keep if _n==1
				ren loc_id loc_id_dest
				ren lattitude lat_dest
				ren longitude lon_dest
				keep loc_id_dest lat_dest lon_dest
				tempfile temp_dest
				sort loc_id_dest
				save `temp_dest', replace
				ren loc_id_dest loc_id_orig
				ren lat_dest lat_orig
				ren lon_dest lon_orig
				cross using `temp_dest'
				vincenty lat_orig lon_orig lat_dest lon_dest, vin(distance)
				tempfile temp_dist
				keep loc_id_orig loc_id_dest distance
				sort loc_id_orig loc_id_dest
				save `temp_dist', replace
				restore
				
				preserve
				keep if e(sample)
				egen loc_id = group(lattitude longitude)
				keep loc_id
				gen id = _n
				ren loc_id loc_id_dest
				ren id id_dest
				tempfile temp_dest2
				save `temp_dest2', replace
				ren loc_id_dest loc_id_orig
				ren id_dest id_orig
				cross using `temp_dest2'
				sort loc_id_orig loc_id_dest
				merge m:1 loc_id_orig loc_id_dest using `temp_dist'
				tab _merge
				drop _merge
				keep id_orig id_dest distance
				sort id_orig id_dest
				replace distance = 0 if distance ==.
				replace distance = 1 if distance==0 & id_orig~=id_dest /* places in the same county */
				mata{
					M = st_data(.,.)
					distance =  makesymmetric(rowshape(M[.,3],sqrt(rows(M[.,3]))))
					fh = fopen("distance.mmat", "w")
					fputmatrix(fh, distance)
					fclose(fh)
				}
				restore
			end
			
			cap drop temp_constant 
			gen temp_constant = 1 /* this is the only way to get the sphac program to work (include my own constant) */

	xi: reggrp fertility_rate distance distance_sqrd $controls_plant $controls_county $dummy_county $yearFE $controls_inter i.statecounty temp_constant, weight(plant_size) tol(0.01) noc
		local r2_treb = e(r2)
		qui sum fertility_rate if e(sample)
		local meandep_treb = r(mean)
		treb_dist
		sphac, dmat("distance.mmat") dfrom(Mata) fbandw(100) model(ols) kernel(Barlett) noc
		estadd scalar meandep = `meandep_treb'
		estadd scalar r2 = `r2_treb'
		estimates save robustness_white_$date, replace
	

exit