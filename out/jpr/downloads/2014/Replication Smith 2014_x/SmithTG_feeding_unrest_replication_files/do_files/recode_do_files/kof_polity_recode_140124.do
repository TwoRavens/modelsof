*** PREP KOF GLOBALIZATION & POLITY DATA *****
*** prepares data for use by MASTER ANALYSIS
*** Todd G. Smith
*** updated 27 March 2012


clear
insheet using "data/raw_data/globalization_2012_long.csv", comma
rename economicglobalization econ_glob
rename socialglobalization soc_glob
rename politicalglobalization pol_glob
rename overallglobalizationindex glob_index
rename code wb_code
lab var econ_glob "KOF economic globalization"
lab var soc_glob "KOF social globalization"
lab var pol_glob "KOF political globalization"
drop actualflows restrictions personalcontact informationflows culturalproximity
save "data/kof_recode.dta", replace

**** PREP POLITY IV DATA *****

clear
insheet using "data/raw_data/p4v2012.csv", comma
rename ccode cow_code
drop cyear scode country
foreach var of varlist democ autoc polity2 {
	replace `var' = 0 if `var' == -66
	replace `var' = 0 if `var' == -77
	replace `var' = 0 if `var' == -88
	}
drop if cow_code == 530 & year == 1993
replace cow_code = 530 if cow_code == 531
drop if year < 1960
*ipolate democ year, g(dem_ip) by(cow_code)
*ipolate autoc year, g(aut_ip) by(cow_code)
*replace democ = dem_ip
*replace autoc = aut_ip
*gen pol2_ip = dem_ip - aut_ip
gen pol2_sq = polity2 * polity2
gen democracy = polity2 > 5
gen autocracy = polity2 < -5

lab var democ "Polity IV democracy"
lab var autoc "Polity IV autocracy"
lab var polity "Combined Polity Score"
lab var polity2 "Revised Combined Polity Score (p4)"
lab var durable "Regime Durability (p4)"
lab var pol2_sq "Revised Combined Polity Score squared"
lab var democracy "Revised Combined Polity Score >5"
lab var autocracy "Revised Combined Polity Score <-5"

save "data/polity_recode.dta", replace
