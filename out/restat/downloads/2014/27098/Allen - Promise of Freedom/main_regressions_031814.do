*** This do-file creates the tables of the main results

clear all
cap log close
estimates clear
set more off
global date = "031814"

* doing the white robustness check
do robustness_check_031814.do /* doing it in a separate terminal */
clear

use "master_022613.dta"

cap log close
log using main_regressions_$date.log, replace


*** Creating distance measure [08/18/12: now you can either run to the north or run to Mexico]
	cap drop distance
	gen distance = min(dist_north,dist_texas)/100 if year==1850
	replace distance = min(dist_canada,dist_texas)/100 if year==1860
	lab var distance "Distance to Freedom (100 miles)"
	cap drop distance_sqrd
	gen distance_sqrd = distance^2
	lab var distance_sqrd "Distance to freedom squared"

*** Creating interaction variables

** Male versus Female plantation owners

	gen female_owner=(owner_sex==0)
	gen male_owner=(owner_sex==1)

	gen distance_x_femaleowner = distance*female_owner
	gen distance_x_maleowner = distance*male_owner

	lab var distance_x_femaleowner "Distance*female slaveholder"
	lab var female_owner "Female slaveholder"

	lab var distance_x_maleowner "Distance*male slaveholder"
	lab var male_owner "Male Slaveholder"

** Large plantation?
	gen distance_x_size = distance
	replace distance_x_size = 0 if number_slaves<=10
	lab var distance_x_size "Distance*Plantation has more than 10 slaves"
	
** Fraction male
	cap drop temp*
	gen temp_male = (age>=16 & sex==1)
	gen temp_adult = (age>=16)
	by year state_fips county_code serial: egen temp_male2 = sum(temp_male)
	by year state_fips county_code serial: egen temp_adult2 = sum(temp_adult)
	gen frac_male = temp_male2 / temp_adult2
	lab var frac_male "# of men >=16 / # of people >=16"
	
** Fraction of young mothers
	cap drop temp*
	gen temp_young = (age>=16 & age<30 & sex==2)
	gen temp_total = (age>=16 & age<45 & sex==2)
	bysort year state_fips county_code serial: egen temp_young2 = sum(temp_young)
	bysort year state_fips county_code serial: egen temp_total2 = sum(temp_total)
	cap drop number_moms
	gen number_moms = temp_total2
	gen frac_young_moms = temp_young2 / temp_total2
	drop temp*
	lab var frac_young_moms "Fraction of potential mothers under 30"
	gen distance_x_fracyoung = distance*frac_young_moms
	lab var distance_x_fracyoung "Distance*Fraction of potential mothers under 30"
	
** Children with white fathers

	** Fertility on Plantation of children with white fathers

		cap drop temp*

		gen temp_under5_mulatto=(age<5 & color==210) /* all kids less than 5 that are mulatto */
		by year state_fips county_code serial: egen kids_under5_mulatto=sum(temp_under5_mulatto) /* total number of kids<5 on plantation that are mulatto */

		gen temp_mom_mulatto=(age>=16 & age<45 & sex==2 & color==210) /* mom is mulatto */
		by year state_fips county_code serial: egen temp_plant_mulatto_mom=max(temp_mom_mulatto) /* so at least one mother on plantation is mulatto */

		gen only_black_moms = 1-temp_plant_mulatto_mom
		lab var only_black_moms "No mulatto women between 16-44 on plantation"
		
*** Dependent variables: [08/18/12: Now using kids / mom]
	gen fertility_rate = kids_under5 / number_moms
	lab var fertility_rate "# Children <5 / # women 16-44"
	
	gen fertility_rate_mulatto = kids_under5_mulatto / number_moms if only_black_moms==1
	lab var fertility_rate_mulatto "# Mulatto Children <5 / # women 16-44 (farms with mulatto women excluded)"

	cap drop temp*
	gen temp_5_10 = (age>=5&age<10)
	by year state_fips county_code serial: egen tempkid510 = sum(temp_5_10)
	gen temp_oldmom = (age>=21 & age<50 & sex==2)
	by year state_fips county_code serial: egen temp_oldmom2 = sum(temp_oldmom)
	
	gen fertility_rate_old = tempkid510 / temp_oldmom2
	drop temp*
	lab var fertility_rate_old "# Children 5-9 / # women 21-49"
	
	
*** Regressions

** Controls and Fixed Effects

cap drop temp*

xi i.state_fips*i.year /* so we have state-year fixed effects */

global controls_plant = " number_slaves small_holder1 small_holder2 small_holder3 small_holder4 small_holder10 rural female_owner male_owner frac_young_moms frac_male"
global controls_county = " cotton_val rice_val tobacco_val sugar_val total_crop total_crop_change railroad water_transport white_population slave_population migration_white migration_slave"
global yearFE = " yr1860 "
global stateFE = " _I* "

* clustering at the county-year level
egen statecounty_year = group(statecounty year)

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

* logging
cap log close
log using main_regressions_$date.log, replace
estimates clear

*** Figure #1: What is the relationship between fraction of fugitive slaves and distance?
	* reg frac_fugitive distance if statecounty_unique==1 & frac_fugitive>0
		* local b = string(_b[distance],"%9.3f")
		* local b_se = string(_se[distance],"%9.3f")
		* local c = string(_b[_cons],"%9.3f")
		* local c_se = string(_se[_cons],"%9.3f")
		* disp "y = `b'*distance + `c'"
	* twoway (lfitci frac_fugitive distance if statecounty_unique==1 & frac_fugitive>0) ///
		* (scatter frac_fugitive distance if statecounty_unique==1 & frac_fugitive>0), ytitle("Fraction of slaves that are fugitives") ///
		* text(0.075 6 "y = `b'x + `c'" "            (`b_se'**) (`c_se'***)") ///
		* legend(order(1 "95% CI" 2 "Linear fit")) ///
		* saving("fugitivesdistance_$date.gph", replace)
	* graph export fugitivesdistace_$date.png, replace

*** Table #1: What else is correlated with the change in distance to freedom (these are county level variables)?

	cap prog drop corr_treb
	prog define corr_treb, eclass
		cap matrix drop b
		cap matrix drop se
		syntax varlist
		foreach v of local varlist {
			xi: areggrp `v' distance $yearFE if statecounty_unique==1, a(statecounty)  robust weight(number_slaves) tol(0.01)
			cap matrix drop temp_b
			matrix temp_b = _b[distance]
			matrix temp_se = _se[distance]^2
			* local temp : var la `v'
			matrix coln temp_b = "`v'"
			matrix coln temp_se = "`v'"
			matrix b = (nullmat(b) , temp_b)
			matrix se = (nullmat(se) , temp_se)
			local N = e(N)
			ereturn clear
			}
		matrix V = diag(se)
		ereturn post b V
		ereturn scalar N = `N'
	end
	
	* converting units
	replace white_population = white_population / 1000
	replace slave_population = slave_population / 1000
	replace migration_white = migration_white / 1000
	replace migration_slave = migration_slave / 1000
	replace total_crop = total_crop / 100
	replace total_crop_change = total_crop_change / 100

	** unique state-county observation
	bysort year statecounty: gen statecounty_unique=(_n==1)
	lab var statecounty_unique "One observation per state-county per year"

	* creating a county level measure of the number of fugitives
	cap drop temp*
	gen tempfug = nfugitvs
	bysort year state_fips county_code serial: replace tempfug = 0 if _n>1 /* avoid double counting */
	
	bysort year state_fips county_code: egen county_fugitive = sum(tempfug)
	bysort year state_fips county_code: gen temp = _N
	gen frac_fugitive = county_fugitive / temp
	drop temp*
	
	* creating a measure of older slaves
	cap drop temp*
	gen temp = age>60
	bysort year state_fips county_code: gen temp2 = _N
	bysort year state_fips county_code: egen temp3 = sum(temp)
	cap drop old_slave
	gen old_slave = temp3 / temp2
	cap drop temp*
	
	
	* doing the estimation
	local corrlist = "total_crop total_crop_change white_population slave_population migration_white migration_slave child_ageheap total_ageheap county_fugitive old_slave "
	
	corr_treb `corrlist'
	estimates clear
	eststo a1
	
	* labelling the variables
	lab var total_crop "Total agricultural production"
	lab var total_crop_change "Change in agricultural production"
	lab var white_population "Adult white population"
	lab var slave_population "Adult slave population"
	lab var migration_white "Change in adult white population"
	lab var migration_slave "Change in adult slave population"
	lab var child_ageheap "Extent of child age-heaping"
	lab var total_ageheap "Extent of total age-heaping"
	lab var county_fugitive "Number of fugitive slaves"
	lab var frac_fugitive "Fraction of fugitive slaves"
	lab var old_slave "Fraction of slaves >60 years old"
	
	* making the table

	estout a1 using controls_corr_$date.tex, ///
		style(tex) type replace title("Correlation between distance to freedom and county characteristics") ///
		prehead(\begin{table}[htbp] \caption{  {@title}}  \centering\medskip  ///
		\begin{tabular}{l*{@M}l} \label{table:controls_corr}) ///
		posthead("\hline") prefoot("\hline") ///
		cells(b(star fmt(%8.3f)) se(par fmt(%8.3f))) ///
		stats(N, fmt(%6.0f) labels("Observations")) ///
		starlevels(* .1 ** .05 *** .01) collabels(none) ///
		drop(distance $stateFE $yearFE _cons, relax) ///
		numbers label mlabels(none) ///
		postfoot(\hline \end{tabular} \begin{minipage}{\textwidth} \emph{Notes:} Each row is a separate regression, where the dependent variable is indicated.  The reported coefficient is the coefficient on the distance to freedom.  Year and county fixed effects are included in all regressions.  Each observation is a county in a particular year. ///
			Robust standard errors are reported in parentheses.  Stars indicate statistical significance: * p<.10 ** p<.05 *** p<.01. ///
		\end{minipage} \end{table} ) substitute($ \$)

		
*** Table #2: Main results

	* getting the sample
		reggrp fertility_rate distance distance_sqrd $controls_plant $controls_county $dummy_county if plantation_unique==1, cluster(statecounty_year) weight(number_slaves) tol(0.01)
		keep if e(sample)

	* making spatially correlated standard errors
	
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
				
		** Main results

			* correlation
				reggrp fertility_rate distance distance_sqrd $controls_plant $controls_county $dummy_county temp_constant, weight(number_slaves) tol(0.01) noc
					local r2_treb = e(r2)
					qui sum fertility_rate if e(sample)
					local meandep_treb = r(mean)
					treb_dist
					sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
					estadd scalar meandep = `meandep_treb'
					estadd scalar r2 = `r2_treb'
					estimates store tab2_1
					estadd local controls "Yes"
					estadd local countyFE "No"
					estadd local yearFE "No"
					estadd local controlsXyear "No"
					estadd local stateyearFE "No"
				
			* county FE
				xi: reggrp fertility_rate distance distance_sqrd $controls_plant $controls_county $dummy_county i.statecounty temp_constant, weight(number_slaves) tol(0.01) noc
					local r2_treb = e(r2)
					qui sum fertility_rate if e(sample)
					local meandep_treb = r(mean)
					sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
					estadd scalar meandep = `meandep_treb'
					estadd scalar r2 = `r2_treb'
					estimates store tab2_2
					estadd local controls "Yes"
					estadd local countyFE "Yes"
					estadd local yearFE "No"
					estadd local controlsXyear "No"
					estadd local stateyearFE "No"
				
			* country FE and year FE
				xi: reggrp fertility_rate distance distance_sqrd  $controls_plant $controls_county $dummy_county $yearFE i.statecounty temp_constant, weight(number_slaves) tol(0.01) noc
					local r2_treb = e(r2)
					qui sum fertility_rate if e(sample)
					local meandep_treb = r(mean)
					sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
					estadd scalar meandep = `meandep_treb'
					estadd scalar r2 = `r2_treb'
					estimates store tab2_3
					estadd local controls "Yes"
					estadd local countyFE "Yes"
					estadd local yearFE "Yes"
					estadd local controlsXyear "No"
					estadd local stateyearFE "No"
				
			* country FE, year FE, and control interactions
				xi: reggrp fertility_rate distance distance_sqrd  $controls_plant $controls_county $dummy_county $yearFE $controls_inter i.statecounty temp_constant, weight(number_slaves) tol(0.01) noc
					local r2_treb = e(r2)
					qui sum fertility_rate if e(sample)
					local meandep_treb = r(mean)
					sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
					estadd scalar meandep = `meandep_treb'
					estadd scalar r2 = `r2_treb'
					estimates store tab2_4
					estadd local controls "Yes"
					estadd local countyFE "Yes"
					estadd local yearFE "Yes"
					estadd local controlsXyear "Yes"
					estadd local stateyearFE "No"
			
			* county FE, year FE, controlXyear, controls, stateXyearFE
				xi: reggrp fertility_rate distance distance_sqrd  $controls_plant $controls_county $dummy_county $yearFE $controls_inter $stateFE i.state_fips*i.year i.statecounty temp_constant , weight(number_slaves) tol(0.01) noc
					local r2_treb = e(r2)
					qui sum fertility_rate if e(sample)
					local meandep_treb = r(mean)
					sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
					estadd scalar meandep = `meandep_treb'
					estadd scalar r2 = `r2_treb'
					estimates store tab2_5
					estadd local controls "Yes"
					estadd local countyFE "Yes"
					estadd local yearFE "Yes"
					estadd local controlsXyear "Yes"
					estadd local stateyearFE "Yes"

		*** Table #3: Heterogeneous Effects

			* basic results
				xi: reggrp fertility_rate distance distance_sqrd $controls_plant $controls_county $controls_inter $dummy_county  $yearFE i.statecounty temp_constant , weight(number_slaves) tol(0.01) noc
				local r2_treb = e(r2)
				qui sum fertility_rate if e(sample)
				local meandep_treb = r(mean)
				sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
				estadd scalar meandep = `meandep_treb'
				estadd scalar r2 = `r2_treb'
				estimates store tab3_1
				estadd local controls "Yes"
				estadd local countyFE "Yes"
				estadd local yearFE "Yes"
				estadd local controlsXyear "Yes"
					
			* interacted with number of slaves
				xi: reggrp fertility_rate distance distance_sqrd  distance_x_size $controls_plant $controls_county $controls_inter $dummy_county  $yearFE  i.statecounty temp_constant , weight(number_slaves) tol(0.01) noc
				local r2_treb = e(r2)
				qui sum fertility_rate if e(sample)
				local meandep_treb = r(mean)
				sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
				estadd scalar meandep = `meandep_treb'
				estadd scalar r2 = `r2_treb'
				estimates store tab3_2
				estadd local controls "Yes"
				estadd local countyFE "Yes"
				estadd local yearFE "Yes"
				estadd local controlsXyear "Yes"
				
			* interacted with sex of the plantation owner
				xi: reggrp fertility_rate distance distance_sqrd distance_x_femaleowner distance_x_maleowner $controls_plant $controls_county $controls_inter $dummy_county  $yearFE  i.statecounty temp_constant , weight(number_slaves) tol(0.01) noc
				local r2_treb = e(r2)
				qui sum fertility_rate if e(sample)
				local meandep_treb = r(mean)
				sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
				estadd scalar meandep = `meandep_treb'
				estadd scalar r2 = `r2_treb'
				estimates store tab3_3
				estadd local controls "Yes"
				estadd local countyFE "Yes"
				estadd local yearFE "Yes"
				estadd local controlsXyear "Yes"
				
			* Different regions

				* breed states: (Delaware, the District of Columbia, Kentucky, Maryland, North Carolina, Virginia, West Virginia)
				gen breedstate = (state_fips==10 | state_fips==11 | state_fips==21 | state_fips==24 | state_fips==37 | state_fips==51 | state_fips==54)

				* go south states: texas and florida
				gen gosouthstate = (state_fips==48 | state_fips==12)

				* deep south states: Alabama, Georgia, Louisiana, Mississippi, South Carolina
				gen deepsouth = (state_fips==1 | state_fips==13 | state_fips==22 | state_fips==28 | state_fips==45 )

				* mid south states: Missouri, Arkansas, Tennessee
				gen midsouth = (state_fips==29 | state_fips==5 | state_fips==47 )

				gen distXbreed = distance*breedstate
				gen distXgosouth = distance*gosouthstate
				gen distXdeep = distance*deepsouth
				gen distXmid = distance*midsouth

				lab var distXbreed "Distance*Upper South"
				lab var distXgosouth "Distance*Peripheral South"
				lab var distXdeep "Distance*Deep South"
				lab var distXmid "Distance*Middle South"

				xi: reggrp fertility_rate distance_sqrd distXbreed distXmid distXdeep distXgosouth $controls_plant $controls_county $controls_inter $dummy_county  $yearFE  i.statecounty temp_constant , weight(number_slaves) tol(0.01) noc
				local r2_treb = e(r2)
				qui sum fertility_rate if e(sample)
				local meandep_treb = r(mean)
				sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
				estadd scalar meandep = `meandep_treb'
				estadd scalar r2 = `r2_treb'
				estimates store tab3_5
				estadd local controls "Yes"
				estadd local countyFE "Yes"
				estadd local yearFE "Yes"
				estadd local controlsXyear "Yes"


				
			* all together
				xi: reggrp fertility_rate distance_sqrd distance_x_size distance_x_femaleowner distance_x_maleowner distXbreed distXmid distXdeep distXgosouth $controls_plant $controls_county $controls_inter $dummy_county  $yearFE  i.statecounty temp_constant , weight(number_slaves) tol(0.01) noc
				local r2_treb = e(r2)
				qui sum fertility_rate if e(sample)
				local meandep_treb = r(mean)
				sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
				estadd scalar meandep = `meandep_treb'
				estadd scalar r2 = `r2_treb'
				estimates store tab3_6
				estadd local controls "Yes"
				estadd local countyFE "Yes"
				estadd local yearFE "Yes"
				estadd local controlsXyear "Yes"
				
		*** Table #4: Difficulty of Path [02/26/13: Updated to only include in the average counties between origin and freedom]

			* getting the Z-score
				cap prog drop ztreb
				prog define ztreb
					cap drop Z`1'
					qui areg `1' if plantation_unique==1 & fertility_rate<. [aweight=number_slaves], a(statecounty_year)
					predict Z`1', d
					qui sum Z`1' [aweight=number_slaves] if plantation_unique==1 & fertility_rate<.
					replace Z`1' = Z`1' / r(sd) /* normalized */
				end
				
			local k=0
			foreach var in rail water pres freeblack_frac slaves_frac {
				local k = `k'+1	
				
				cap drop diff_`var'
				cap drop distXdiff_`var' 
				cap drop distXZdiff_`var' 
				
				gen diff_`var' = difficulty_`var'
				ztreb diff_`var'	
				
				gen distXZdiff_`var' = distance*Zdiff_`var'
				xi: reggrp fertility_rate distance distance_sqrd distXZdiff_`var' Zdiff_`var' $controls_plant $controls_county $controls_inter $dummy_county  $yearFE  i.statecounty temp_constant ,  weight(number_slaves) tol(0.01) noc
				local r2_treb = e(r2)
				qui sum fertility_rate if e(sample)
				local meandep_treb = r(mean)
				treb_dist
				preserve
				keep if e(sample)
				sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
				estadd scalar meandep = `meandep_treb'
				estadd scalar r2 = `r2_treb'
				estimates store d`k'
				estadd local controls "Yes"
				estadd local countyFE "Yes"
				estadd local yearFE "Yes"
				estadd local controlsXyear "Yes"
				restore
				}
				
			* all together
				local k = `k'+1
				xi: reggrp fertility_rate distance distance_sqrd distXZdiff* Zdiff_* $controls_plant $controls_county $controls_inter $dummy_county  $yearFE  i.statecounty temp_constant , weight(number_slaves) tol(0.01) noc
				local r2_treb = e(r2)
				qui sum fertility_rate if e(sample)
				local meandep_treb = r(mean)
				treb_dist
				preserve
				keep if e(sample)
				sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
				estadd scalar meandep = `meandep_treb'
				estadd scalar r2 = `r2_treb'
				estimates store d`k'
				estadd local controls "Yes"
				estadd local countyFE "Yes"
				estadd local yearFE "Yes"
				estadd local controlsXyear "Yes"
				restore
			
			lab var Zdiff_rail "Access to railroads along route (z-score)"
			lab var Zdiff_water "Access to waterways along route (z-score)"
			lab var Zdiff_pres "Support of slavery along route (z-score)"
			lab var Zdiff_freeblack_frac "Free black fraction of population along route (z-score)"
			lab var Zdiff_slaves_frac "Slave fraction of population along route (z-score)"
			
			lab var distXZdiff_rail "Distance*Railroads"
			lab var distXZdiff_water "Distance*Waterways"
			lab var distXZdiff_pres "Distance*Support of slavery"
			lab var distXZdiff_freeblack_frac "Distance*Free black fraction"
			lab var distXZdiff_slaves_frac "Distance*Slave fraction"
			
			
	*** Table #6: With and without economic and demographic controls

		* With both
		xi: reggrp fertility_rate distance distance_sqrd $controls_plant $controls_county $controls_inter $dummy_county  $yearFE i.statecounty temp_constant , weight(number_slaves) tol(0.01) noc
			local r2_treb = e(r2)
			qui sum fertility_rate if e(sample)
			local meandep_treb = r(mean)
			treb_dist
			sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
			estadd scalar meandep = `meandep_treb'
			estadd scalar r2 = `r2_treb'
			estimates store f1
			estadd local controls "Yes"
			estadd local countyFE "Yes"
			estadd local yearFE "Yes"
			estadd local controlsXyear "Yes"
			
		* without economic controls
			global controls_county4 = "railroad water_transport white_population slave_population migration_white migration_slave "
			global dummy_county4 = "no_railroad no_water_tran* no_white_popu* no_slave_popu* no_migration_white no_migration_slave "
			global controls_inter4a = " yr1860Xfrac_young_moms yr1860Xfrac_male yr1860Xnumber_slaves yr1860Xsmall_holder1 yr1860Xsmall_holder2 yr1860Xsmall_holder3 yr1860Xsmall_holder4 "
			global controls_inter4b = "yr1860Xsmall_holder10 yr1860Xrural yr1860Xfemale_owner yr1860Xmale_owner "
			global controls_inter4c = "yr1860Xrailroad yr1860Xwater_transport yr1860Xwhite_population yr1860Xmigration_white yr1860Xmigration_slave "
			xi: reggrp fertility_rate distance distance_sqrd $controls_plant $controls_county4 $controls_inter4a $controls_inter4b $controls_inter4c $dummy_county4  $yearFE i.statecounty temp_constant , weight(number_slaves) tol(0.01) noc
				local r2_treb = e(r2)
				qui sum fertility_rate if e(sample)
				local meandep_treb = r(mean)
				sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
				estadd scalar meandep = `meandep_treb'
				estadd scalar r2 = `r2_treb'
				estimates store f2
				estadd local controls "Yes"
				estadd local countyFE "Yes"
				estadd local yearFE "Yes"
				estadd local controlsXyear "Yes"	

		* without demographic controls
			global controls_county2 = "cotton_val rice_val tobacco_val sugar_val total_crop total_crop_change railroad water_transport "
			global dummy_county2 = "no_cotton_val no_rice_val no_tobacco_val no_sugar_val no_total_crop* no_railroad no_water_tran* "
			global controls_inter2a = " yr1860Xfrac_young_moms yr1860Xfrac_male yr1860Xnumber_slaves yr1860Xsmall_holder1 yr1860Xsmall_holder2 yr1860Xsmall_holder3 yr1860Xsmall_holder4 "
			global controls_inter2b = "yr1860Xsmall_holder10 yr1860Xrural yr1860Xfemale_owner yr1860Xmale_owner yr1860Xcotton_val yr1860Xrice_val yr1860Xtobacco_val yr1860Xsugar_val yr1860Xtotal_crop "
			global controls_inter2c = "yr1860Xtotal_crop_change yr1860Xrailroad yr1860Xwater_transport "
			xi: reggrp fertility_rate distance distance_sqrd $controls_plant $controls_county2 $controls_inter2a $controls_inter2b $controls_inter2c $dummy_county2  $yearFE i.statecounty temp_constant , weight(number_slaves) tol(0.01) noc
				local r2_treb = e(r2)
				qui sum fertility_rate if e(sample)
				local meandep_treb = r(mean)
				sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
				estadd scalar meandep = `meandep_treb'
				estadd scalar r2 = `r2_treb'
				estimates store f3
				estadd local controls "Yes"
				estadd local countyFE "Yes"
				estadd local yearFE "Yes"
				estadd local controlsXyear "Yes"
					
					
		*** Table #5: Placebo Tests

			* Children 10-14
			
			preserve
			xi: reggrp fertility_rate_old distance distance_sqrd $controls_plant $controls_county $controls_inter $dummy_county  $yearFE  i.statecounty temp_constant , weight(number_slaves) tol(0.01) noc
			keep if e(sample)
			local r2_treb = e(r2)
			qui sum fertility_rate_old if e(sample)
			local meandep_treb = r(mean)
			treb_dist
			sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
			estadd scalar meandep = `meandep_treb'
			estadd scalar r2 = `r2_treb'
			estimates store e1
			estadd local controls "Yes"
				estadd local countyFE "Yes"
				estadd local yearFE "Yes"
				estadd local controlsXyear "Yes"
			restore
			
			* white children
			estimates use robustness_white_120513
			estimates store e2
			estadd local controls "Yes"
				estadd local countyFE "Yes"
				estadd local yearFE "Yes"
				estadd local controlsXyear "Yes"

			** Children with White Fathers
			preserve
			xi: reggrp fertility_rate_mulatto distance distance_sqrd $controls_plant $controls_county $controls_inter $dummy_county  $yearFE  i.statecounty temp_constant if only_black_moms==1   , weight(number_slaves) tol(0.01) noc
			keep if e(sample)
			local r2_treb = e(r2)
			qui sum fertility_rate_mulatto if e(sample)
			local meandep_treb = r(mean)
			treb_dist
			sphac, dmat("distance.mmat") dfrom(Mata) kernel(Barlett) fbandw(50) model(ols) noc
			estadd scalar meandep = `meandep_treb'
			estadd scalar r2 = `r2_treb'
			estimates store e3
			estadd local controls "Yes"
				estadd local countyFE "Yes"
				estadd local yearFE "Yes"
				estadd local controlsXyear "Yes"
			restore

	
*** Making results tables

* labeling data
lab var distance "Distance to freedom (100 miles)"
lab var frac_young_moms "Fraction of potential mothers under 30"
lab var frac_male "Fraction of adults that are male"
lab var small_holder1 "1 slave household"
lab var small_holder2 "2 slave household"
lab var small_holder3 "3 slave household"
lab var small_holder4 "4 slave household"
lab var small_holder10 "5-10 slave household"
lab var rural "Rural household"
lab var cotton_val "Value of cotton production in county (000s)"
lab var rice_val "Value of rice production in county (000s)"
lab var tobacco_val "Value of tobacco production in county (000s)"
lab var sugar_val "Value of sugar production in county (000s)"
lab var total_crop "Total value of agricultural production in county (000s)"
lab var railroad "Railroad in county"
lab var water_transport "Water transport in county"

* Main results, different specifications (Table 2)
	estout tab2_* using main_$date.tex, ///
		style(tex) replace type title("Effect of distance to freedom on slave fertility") ///
		prehead(\begin{table}[htbp] \caption{  {@title}}  \centering\medskip  ///
		\begin{tabular}{l*{@M}l} \label{table:main}) ///
		posthead("\hline") prefoot("\hline") ///
		varlabels(_cons "Constant") wrap ///
		cells(b(star fmt(%8.3f)) se(par fmt(%8.3f))) ///
		stats(controls countyFE yearFE controlsXyear stateyearFE N r2 meandep, fmt(%6.3f %6.3f  %6.3f  %6.3f  %6.3f %6.0f %6.3f) ///
			labels("Plantation and county controls" "County fixed effects" "Year fixed effects" "Controls*year" "State-year fixed effects" "Observations" "R-squared" "Mean Fertility")) ///
		starlevels(* .1 ** .05 *** .01) collabels(none) ///
		drop($yearFE $stateFE temp* $controls_inter $controls_inter_old _cons $dummy_county $controls_plant $controls_county, relax) ///
		mlabels(none) order(distance) ///
		numbers label ///
		postfoot(\hline \end{tabular} \begin{minipage}{\textwidth} \emph{Notes:} The dependent variable is the ratio of the number of children younger than five to the number of women age 16-44 on a plantation.  ///
		Each observation is a plantation with at least one women aged 16-44 in a particular year; plantations are weighted by the number of slaves using a GLS procedure that allows for an arbitrary correlation in fertility within a plantation. ///
			Plantation controls include the total number of slaves, indicator variables for whether there were 1, 2, 3, 4, or 5-10 slaves in the household, the fraction of potential mothers under the age of 30, the fraction of adults that are male, an indicator for whether the plantation was rural, and the sex of the slaveholder.  ///		
			County controls include whether the plantation was rural, the value of cotton, rice, tobacco, sugar, and total agricultural production, the change in total agricultural production over the past 10 years, the adult white and slave populations, the change in the white and slave populations over the past 10 years, and indicator variables for whether there was railroad or water transportation access in the county. ///
			Since county level data is missing for some counties, missing variables are set equal to zero and indicator variables for missing values are included to control for level differences. ///
			Controls*year indicates that interactions with all demographic and county control variables and the year 1860 are included to allow the control variables to have different effects in 1850 and 1860. ///
			Standard errors allowing for spatial correlation between plantations (using a Barlett kernel with a 100 mile bandwidth) are reported in parentheses.  Stars indicate statistical significance: * p<.10 ** p<.05 *** p<.01. ///
		\end{minipage} \end{table} ) substitute(_ \_ $ \$)
	
* Heterogeneous results (Table 3)
	estout tab3_* using hetero_$date.tex, ///
		style(tex) replace type title("Heterogeneous effects of distance to freedom on slave fertility") ///
		prehead(\begin{table}[htbp] \caption{  {@title}}  \centering\medskip  ///
		\begin{tabular}{l*{@M}l} \label{table:hetero}) ///
		posthead("\hline") prefoot("\hline") ///
		varlabels(_cons "Constant") wrap ///
		cells(b(star fmt(%8.3f)) se(par fmt(%8.3f))) ///
		starlevels(* .1 ** .05 *** .01) collabels(none) ///
		drop($yearFE $stateFE temp* $controls_inter $controls_inter_old _cons $dummy_county $controls_plant $controls_county, relax) ///
		stats(controls countyFE yearFE controlsXyear N r2 meandep, fmt(%6.3f  %6.3f  %6.3f  %6.3f  %6.0f %6.3f %6.3f) ///
			labels("Plantation and county controls" "County fixed effects" "Year fixed effects" "Controls*year" "Observations" "R-squared" "Mean Fertility")) ///
		mlabels(none) order(distance distance_sqrd) ///
		numbers label ///
		postfoot(\hline \end{tabular} \begin{minipage}{\textwidth} \emph{Notes:} The dependent variable is the ratio of the number of children younger than five to the number of women age 16-44 on a plantation.  ///
			Each observation is a plantation with at least one women aged 16-44 in a particular year; plantations are weighted by the number of slaves using a GLS procedure that allows for an arbitrary correlation in fertility within a plantation. ///
			Plantation controls include the total number of slaves, indicator variables for whether there were 1, 2, 3, 4, or 5-10 slaves in the household, the fraction of potential mothers under the age of 30, the fraction of adults that are male, an indicator for whether the plantation was rural, and the sex of the slaveholder.  ///		
			County controls include whether the plantation was rural, the value of cotton, rice, tobacco, sugar, and total agricultural production, the change in total agricultural production over the past 10 years, the adult white and slave populations, the change in the white and slave populations over the past 10 years, and indicator variables for whether there was railroad or water transportation access in the county. ///
			Since county level data is missing for some counties, missing variables are set equal to zero and indicator variables for missing values are included to control for level differences. ///
			Controls*year indicates that interactions with all demographic and county control variables and the year 1860 are included to allow the control variables to have different effects in 1850 and 1860. ///
			Standard errors allowing for spatial correlation between plantations (using a Barlett kernel with a 100 mile bandwidth) are reported in parentheses.  Stars indicate statistical significance: * p<.10 ** p<.05 *** p<.01. ///
		\end{minipage} \end{table} ) substitute(_ \_ $ \$)

* Difficulty of Running (Table 4)
	estout d* using difficulty_$date.tex, ///
		style(tex) replace type title("Difficulty of route") ///
		prehead(\begin{table}[htbp] \caption{  {@title}}  \centering\medskip  ///
		\begin{tabular}{p{2in}llllll} \label{table:difficulty}) ///
		posthead("\hline") prefoot("\hline") ///
		varlabels(_cons "Constant") wrap ///
		cells(b(star fmt(%8.3f)) se(par fmt(%8.3f))) ///
		starlevels(* .1 ** .05 *** .01) collabels(none) ///
		drop($yearFE $stateFE temp* $controls_inter $controls_inter_old _cons $dummy_county $controls_plant $controls_county, relax) ///
		stats(controls countyFE yearFE controlsXyear N r2 meandep, fmt(%6.3f  %6.3f  %6.3f  %6.3f  %6.0f %6.3f %6.3f) ///
			labels("Plantation and county controls" "County fixed effects" "Year fixed effects" "Controls*year" "Observations" "R-squared" "Mean Fertility")) ///
		mlabels(none) order(distance distance_sqrd distXZdiff* Zdiff_*) ///
		numbers label ///
		postfoot(\hline \end{tabular} \begin{minipage}{\textwidth} \emph{Notes:} The dependent variable is the ratio of the number of children younger than five to the number of women age 16-44 on a plantation.  ///
			Each observation is a plantation with at least one women aged 16-44 in a particular year; plantations are weighted by the number of slaves using a GLS procedure that allows for an arbitrary correlation in fertility within a plantation. ///
			For comparability across regressions, the difficulty variables are normalized to have a mean of zero and standard deviation of one.  ///
			Plantation controls include the total number of slaves, indicator variables for whether there were 1, 2, 3, 4, or 5-10 slaves in the household, the fraction of potential mothers under the age of 30, the fraction of adults that are male, an indicator for whether the plantation was rural, and the sex of the slaveholder.  ///		
			County controls include whether the plantation was rural, the value of cotton, rice, tobacco, sugar, and total agricultural production, the change in total agricultural production over the past 10 years, the adult white and slave populations, the change in the white and slave populations over the past 10 years, and indicator variables for whether there was railroad or water transportation access in the county. ///
			Since county level data is missing for some counties, missing variables are set equal to zero and indicator variables for missing values are included to control for level differences. ///
			Controls*year indicates that interactions with all demographic and county control variables and the year 1860 are included to allow the control variables to have different effects in 1850 and 1860. ///
			Standard errors allowing for spatial correlation between plantations (using a Barlett kernel with a 100 mile bandwidth) are reported in parentheses.  Stars indicate statistical significance: * p<.10 ** p<.05 *** p<.01. ///
		\end{minipage} \end{table} ) substitute(_ \_ $ \$)

* Placebo Tests (Table 5)
	estout e* using placebo_$date.tex, ///
		style(tex) replace type title("Placebo tests") ///
		prehead(\begin{table}[htbp] \caption{  {@title}}  \centering\medskip   ///
		\begin{tabular}{lp{1.2in}p{1.2in}p{1.2in}} \label{table:placebo}) ///
		posthead("\hline") prefoot("\hline") ///
		varlabels(_cons "Constant") wrap ///
		cells(b(star fmt(%8.3f)) se(par fmt(%8.3f))) ///
		starlevels(* .1 ** .05 *** .01) collabels(none) ///
		drop($yearFE $stateFE temp* $controls_inter $controls_inter_old _cons $dummy_county $controls_plant $controls_county frac_youngmom plant_size, relax) ///
		stats(controls countyFE yearFE controlsXyear N r2 meandep, fmt(%6.3f  %6.3f  %6.3f  %6.3f  %6.0f %6.3f) ///
			labels("Plantation and county controls" "County fixed effects" "Year fixed effects" "Controls*year" "Observations" "R-squared" "Mean Fertility")) ///
		mlabels("Slave children 10-14 / women 21-49" "White children <5 / women 16-44" "Mulatto children <5 / women 16-44") order(distance $controls_plant $controls_county) ///
		numbers label ///
		postfoot(\hline \end{tabular} \begin{minipage}{\textwidth} \emph{Notes:} The dependent variable is indicated above each column.  ///
			Each observation is a plantation with at least one women aged 16-44 in a particular year; plantations are weighted by the number of slaves using a GLS procedure that allows for an arbitrary correlation in fertility within a plantation. ///
			Plantation controls include the total number of slaves, indicator variables for whether there were 1, 2, 3, 4, or 5-10 slaves in the household, the fraction of potential mothers under the age of 30, the fraction of adults that are male, an indicator for whether the plantation was rural, and the sex of the slaveholder.  ///		
			County controls include whether the plantation was rural, the value of cotton, rice, tobacco, sugar, and total agricultural production, the change in total agricultural production over the past 10 years, the adult white and slave populations, the change in the white and slave populations over the past 10 years, and indicator variables for whether there was railroad or water transportation access in the county. ///
			Since county level data is missing for some counties, missing variables are set equal to zero and indicator variables for missing values are included to control for level differences. ///
			Controls*year indicates that interactions with all demographic and county control variables and the year 1860 are included to allow the control variables to have different effects in 1850 and 1860. ///
			Standard errors allowing for spatial correlation between plantations (using a Barlett kernel with a 100 mile bandwidth) are reported in parentheses.  Stars indicate statistical significance: * p<.10 ** p<.05 *** p<.01. ///
		\end{minipage} \end{table} ) substitute($ \$)
	
* Economic and demographic changes (Table 6)
	estout f* using migratpop_$date.tex, ///
		style(tex) type replace title("Economic and demographic changes and the distance to freedom") ///
		prehead(\begin{table}[htbp] \caption{  {@title}}  \centering\medskip   ///
		\begin{tabular}{lp{1in}p{1.5in}p{1.5in}} \label{table:migratpop}) ///
		posthead("\hline") prefoot("\hline") ///
		varlabels(_cons "Constant") wrap ///
		cells(b(star fmt(%8.3f)) se(par fmt(%8.3f))) ///
		starlevels(* .1 ** .05 *** .01) collabels(none) ///
		drop($yearFE $stateFE temp* $controls_inter $controls_inter_old _cons $dummy_county $controls_plant $controls_county, relax) ///
		stats(controls countyFE yearFE controlsXyear N r2 meandep, fmt(%6.3f  %6.3f  %6.3f  %6.3f  %6.0f %6.3f) ///
			labels("Plantation and county controls" "County fixed effects" "Year fixed effects" "Controls*year" "Observations" "R-squared" "Mean Fertility")) ///
		mlabels("All controls" "No economic controls" "No demographic controls") order(distance $controls_plant $controls_county) ///
		numbers label ///
		postfoot(\hline \end{tabular} \begin{minipage}{\textwidth} \emph{Notes:} The dependent variable is the ratio of the number of children younger than five to the number of women age 16-44 on a plantation.  ///
			Each observation is a plantation with at least one women aged 16-44 in a particular year; plantations are weighted by the number of slaves using a GLS procedure that allows for an arbitrary correlation in fertility within a plantation. ///
			Plantation controls include the total number of slaves, indicator variables for whether there were 1, 2, 3, 4, or 5-10 slaves in the household, the fraction of potential mothers under the age of 30, the fraction of adults that are male, an indicator for whether the plantation was rural, and the sex of the slaveholder.  ///		
			County controls include whether the plantation was rural, the value of cotton, rice, tobacco, sugar, and total agricultural production, the change in total agricultural production over the past 10 years, the adult white and slave populations, the change in the white and slave populations over the past 10 years, and indicator variables for whether there was railroad or water transportation access in the county. ///
			Since county level data is missing for some counties, missing variables are set equal to zero and indicator variables for missing values are included to control for level differences. ///
			In column 2, all controls are included except all vaules of agricultural output (and their interactions with year 1860); in column 3, all controls are included except the level and change in the white and slave population (and each variable's interaction with year 1860). ///
			Controls*Year indicates that interactions with all demographic and county control variables and the year 1860 are included to allow the control variables to have different effects in 1850 and 1860. ///
			Standard errors allowing for spatial correlation between plantations (using a Barlett kernel with a 100 mile bandwidth) are reported in parentheses.  Stars indicate statistical significance: * p<.10 ** p<.05 *** p<.01. ///
		\end{minipage} \end{table} ) substitute(_ \_ $ \$)

exit
log close

