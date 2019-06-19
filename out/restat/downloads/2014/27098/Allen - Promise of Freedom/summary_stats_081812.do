clear
set mem 1000m
global date = "081812"
cap log close
set more off
estimates clear


use "master_022613.dta"
set seed 016342

log using summary_stats_$date.log, replace

* unique county identifier
sort year state_fips county_code, stable
bysort year state_fips county_code: gen county_unique=(_n==1)
lab var county_unique "Unique identifier for county in each year"

*** Summary Statistics

* Owner sex

gen owner_male=(owner_sex==1)
gen owner_female=(owner_sex==0)
gen owner_unknown=(owner_sex==.)

lab var owner_male "Slaveholder male"
lab var owner_female "Slaveholder female"
lab var owner_unknown "Slaveholder sex unknown"

* Fraction male
	cap drop temp*
	gen temp_male = (age>=16 & sex==1)
	gen temp_adult = (age>=16)
	bysort year state_fips county_code serial: egen temp_male2 = sum(temp_male)
	bysort year state_fips county_code serial: egen temp_adult2 = sum(temp_adult)
	gen frac_male = temp_male2 / temp_adult2
	lab var frac_male "Fraction of adults that are male"
	
* Fraction of young mothers
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
	
* Fertility rate
	gen fertility_rate = kids_under5 / number_moms
	lab var fertility_rate "Fertility rate: Children 0-4 / Women 16-44"
	

* rescaling values
foreach crop in cotton rice tobacco sugar {
	replace `crop'_val = `crop'_val / 100
	} 
	
	replace total_crop = total_crop / 100
	replace total_crop_change = total_crop_change / 100
	
replace white_population = white_population / 1000
replace slave_population = slave_population / 1000
replace migration_white = migration_white / 1000
replace migration_slave = migration_slave / 1000

** labeling variables
lab var distance "Distance to freedom (miles)"
lab var difficulty_rail "Average access to railroads along route"
lab var difficulty_water "Average access to waterways along route"
lab var difficulty_pres "Average support of slavery along route"
lab var difficulty_freeblack "Average number of free blacks along route (000s)"
lab var difficulty_freeblack_frac "Average free black fraction of population along route"
lab var difficulty_slaves "Average number of slaves along route (000s)"
lab var difficulty_slaves_frac "Average slave fraction of population along route"
lab var kids_under5 "Number of slave children 0-4"
lab var young_moms "Number of slave women 20-29"
lab var old_moms "Number of slave women 30-44"
lab var number_dads "Number of slave men 20-44"
lab var number_slaves "Total number of slaves"
lab var small_holder1 "1 slave household"
lab var small_holder2 "2 slave household"
lab var small_holder3 "3 slave household"
lab var small_holder4 "4 slave household"
lab var small_holder10 "5-10 slave household"
lab var rural "Rural household"
lab var owner_female "Female slaveholder"
lab var owner_male "Male slaveholder"
lab var owner_unknown "Slaveholder sex unknown"
lab var cotton_val "Value of cotton production (000s)"
lab var rice_val "Value of rice production (000s)"
lab var tobacco_val "Value of tobacco production (000s)"
lab var sugar_val "Value of sugar production (000s)"
lab var total_crop "Total value of agricultural production (000s)"
lab var total_crop_change "Change in total value of agricultural production over past 10 years (000s)"
lab var railroad "Railroad access"
lab var water_transport "Water transport access"
lab var yr1860 "Year 1860"
lab var white_population "Adult white population (000s)"
lab var slave_population "Adult slave population (000s)"
lab var migration_white "Change in adult white population over last 10 years (000s)"
lab var migration_slave "Change in adult slave population over last 10 years (000s)"

gen in_plant_sample=(plantation_unique==1 & distance<. & fertility_rate<.)
tab in_plant_sample /* good - 36,978 */
gen in_county_sample=(county_unique==1 & distance<.)
tab in_county_sample /* good - 1940 */

** Plantation level data
global sumstat_plant = "fertility_rate frac_young_moms frac_male owner_female owner_male owner_unknown number_slaves small_holder* rural"

* making our own summary stat table using tabstat
cap prog drop sumstat_treb
prog define sumstat_treb, eclass
	syntax varlist [if]
	tabstat `varlist' `if', save stats(mean sd n)
	matrix x = r(StatTotal)
	matrix mean = x["mean",1...]
	matrix sd = x["sd",1...]
	scalar N = x[3,1]
	ereturn matrix mean = mean
	ereturn matrix sd = sd
	ereturn scalar N = N
end
	
qui reg year year /* for some reason you need to run a regression first */
local k = 1
levelsof(year), local(levels)
foreach l of local levels {
	sumstat_treb $sumstat_plant if in_plant_sample==1 & year==`l'
	eststo a`k', title(`l')
	local k = `k'+1
	}
sumstat_treb $sumstat_plant if in_plant_sample==1
eststo a`k', title("Total")
	
estout a* using sumstat_plant_$date.tex, ///
	style(tex) type replace title("Summary Statistics for Plantation Data") ///
	prehead(\begin{table}[htbp] \caption{{@title}}  \centering\medskip ///
	\begin{tabular}{l*{@M}l} \label{table:sumstat_plant}) ///
	posthead("\hline") prefoot("\hline") ///
	wrap ///
	cells(mean(fmt(%8.3f)) sd(par fmt(%8.3f))) ///
	stats(N, fmt(%6.0f) labels("Observations")) ///
	collabels(none) ///
	numbers label ///
	postfoot(\hline \end{tabular} \begin{minipage}{\textwidth} \emph{Notes:} Standard deviations reported in parentheses. Sample includes all plantations with at least one women aged 16-44.  ///
 	\end{minipage} \end{table} ) substitute($ \$)
	
** County level data
global sumstat_county = "distance cotton_val rice_val tobacco_val sugar_val total_crop total_crop_change railroad water_transport white_population slave_population migration_white migration_slave"

local k = 1
levelsof(year), local(levels)
foreach l of local levels {
	sumstat_treb $sumstat_county if in_county_sample==1 & year==`l'
	eststo a`k', title(`l')
	local k = `k'+1
	}
sumstat_treb $sumstat_county if in_county_sample==1
eststo a`k', title("Total")
	
estout a* using sumstat_county_$date.tex, ///
	style(tex) replace type title("Summary Statistics for County Data") ///
	prehead(\begin{table}[htbp] \caption{{@title}}  \centering\medskip ///
	\begin{tabular}{l*{@M}l} \label{table:sumstat_county}) ///
	posthead("\hline") prefoot("\hline") ///
	wrap ///
	cells(mean(fmt(%8.3f)) sd(par fmt(%8.3f))) ///
	stats(N, fmt(%6.0f) labels("Observations")) ///
	collabels(none) ///
	numbers label ///
	postfoot(\hline \end{tabular} \begin{minipage}{\textwidth} \emph{Notes:} Standard deviations reported in parentheses.  ///
 	\end{minipage} \end{table} ) substitute($ \$)

log close



