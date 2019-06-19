						*** GALLUP WORLD POLL DATASET CLEANER ***
/*	
	 George Ward

The Gallup World Pol has been running across the world since 2006.  For more details, please see the paper and readme file 
(as well as the Gallup website for even more detail).  

In this .do file I take the GWP file provided to us by the Gallup Organization in October 2014. 
																						*/



*******************
*** GALLUP DATA ***
*******************

cd "/Users/wardg/Documents/Raw Data/GALLUP WP/"
use "The_Gallup_102414.dta" , clear

gen dem_gender =  WP1219
gen dem_educ = wp3117
gen dem_marital = WP1223
gen dem_age = WP1220
egen meanage = mean(dem_age) /* 3 whole country-years do not have age information available, so we impute and include a flag in the regressions. Not doing so gives us very similar results. */
gen dem_ageimpflag = ( dem_age==.)
replace dem_age = meanage if dem_age==.
gen dem_age_sq = dem_age^2

foreach var of varlist dem_gender dem_educ dem_marital { 
recode `var' (missing=999)
}

gen lifesat = WP16
recode lifesat (98/99=.)

gen lifesat_5yago = wp17
recode lifesat_5yago (98/99=.)

gen lifesat_in5y = WP18
recode lifesat_in5y (98/99=.)
 
egen std_lifeladder = std(lifesat)

gen happy_yesterday = (WP6878==1) if  WP6878!=.
gen worry_yesterday = (WP69==1) if  WP69!=.
gen stress_yesterday = (WP71==1) if  WP71!=.
gen enjoyment_yesterday = (WP67==1) if  WP67!=.

gen economic_expectations = WP148
recode economic_expectations (1=3) (2=2) (3=1) (else=.)
gen econexpec_better = (WP148==1) if WP148!=.
gen econexpec_same = (WP148==2) if WP148!=.
gen econexpec_worse = (WP148==3) if WP148!=.

gen finsat_comfy = (WP2319==1) if WP2319!=. & WP2319<5
gen finsat_gettingby = (WP2319==2) if WP2319!=. & WP2319<5
gen finsat_difficult = (WP2319==3) if WP2319!=. & WP2319<5
gen finsat_verydifficult = (WP2319==4) if WP2319!=. & WP2319<5

***********

keep dem* lifesat lifesat_5yago lifesat_in5y std_lifeladder  countrynew wave ///
happy_yesterday worry_yesterday   stress_yesterday  enjoyment_yesterday YEAR_CALENDAR YEAR_WAVE ///
economic_expectations econexpec* finsat*
rename countrynew country
rename YEAR_CALENDAR year
gen waveround = round(wave)
rename wave wave1
gen wave = wave1*10
/* A small number of countries have been sampled in 2014 (more will follow), but since we do not have the full data and because
we do not have 2014 macroeconomic data available yet, we leave them out */
drop if year==2014 
 
************

gen country_gwp = country

cd "/Users/wardg/Dropbox (MIT)/Projects/Loss Aversion Project/ReStat Replication Files/Macroeconomic Data/"
merge m:1 country_gwp year using "restat_gdp.dta"
drop _merge

merge m:1 country_gwp year using "restat_unemployment_inflation.dta"
drop _merge

encode country_gwp, gen(co)
sort co year 
egen countryyear = group(co year)
xtset co

replace gdpgrowth_wb_neg = abs(gdpgrowth_wb_neg)

lab var lifesat "Current Ladder (0-10)"
lab var lifesat_in5y "Future Ladder (0-10)"
lab var happy_yesterday "Experienced Yesterday: Happiness"
lab var enjoyment_yesterday "Enjoyment"
lab var stress_yesterday "Stress"
lab var worry_yesterday "Worry"

mkspline wbhhconumptionpcgrowth_n 0 wbhhconumptionpcgrowth_p = wbhhconumptionpcgrowth
lab var wbhhconumptionpcgrowth "HH consumption growth"
lab var wbhhconumptionpcgrowth_n "Negative HH consumption growth"
lab var wbhhconumptionpcgrowth_p "Positive HH consumption growth"
lab var econexpec_better "Economic Expectations: Better (vs. same)"
lab var econexpec_worse "Economic Expectations: Worse (vs. same)"

cd "/Users/wardg/Dropbox (MIT)/Projects/Loss Aversion Project/ReStat Replication Files/Gallup World Poll/"
saveold "gwp_restat.dta", replace





******* Balanced Panel Indicators  ********
use "gwp_restat.dta", clear
drop if lifesat==.
bysort country year: egen numobs_peryear = count(lifesat)
collapse lifesat numobs_peryear gdpgrowth_wb gdpgrowth_wb_neg gdpgrowth_wb_pos gdppc05usdwb , by(country year)

gen neggr = 1 if gdpgrowth_wb<0
gen posgr = 1 if gdpgrowth_wb>0
encode country, gen(co)
xtset co year
eststo: xi: xtreg lifesat gdpgrowth_wb_neg gdpgrowth_wb_pos gdppc05usdwb i.year , r fe
keep if e(sample)==1

bysort co: egen mingr = min(gdpgrowth_wb)
bysort co: egen maxgr = max(gdpgrowth_wb)
bysort co: egen meanobs = mean(numobs_peryear)
bysort co: egen num_posyears = count(posgr)
bysort co: egen num_negyears = count(neggr)
bysort co: egen num_years = count(lifesat)

bysort year: egen neg = count(neggr)
bysort year: egen pos = count(posgr)
bysort year: egen tot = count(lifesat)

tabstat num_years numobs_peryear lifesat  gdpgrowth_wb mingr maxgr num_negyears num_posyears  , by(co) nototal 

bysort co: gen nc = _n
br co num_years num_negyears num_posyears if nc==1

foreach x in 05 06 07 08 09 10 11 12 13 {
gen in`x' = (lifesat!=. & year==20`x')
by co: egen nonmiss`x' = max(in`x')
drop in`x'
}
gen panel_balance07to13 = (nonmiss07==1 & nonmiss08==1 & nonmiss09==1 & nonmiss10==1 & nonmiss11==1 & nonmiss12==1 & nonmiss13==1)
gen panel_balance07to13_min1neg = (panel_balance07to13==1 & num_negyears>0)
keep country year panel* num_* 
saveold "gwp_panel.dta", replace

use "gwp_restat.dta", clear

merge m:1 country year using "gwp_panel.dta"
drop _merge
saveold "gwp_restat.dta", replace
erase "gwp_panel.dta"




*** Consistent demographic controls across the three datasets 
gen controls_age = dem_age
gen controls_age_sq = dem_age_sq
gen controls_male = (dem_gender==1)
gen controls_education_med = (dem_educ==2)
gen controls_education_high = (dem_educ==3)
gen controls_married = (dem_marital==2)

saveold "gwp_restat.dta", replace
