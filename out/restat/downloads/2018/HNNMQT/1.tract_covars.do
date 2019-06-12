cd "/Users/kevinrinz/Box Sync/Research/Milwaukee Vouchers/Published Tables"

***** Covariates

clear *
set more off

global data "Data"
global input "Data/Census Tract Covariates/For Stata"
global output "Data"

// Population, and by age/race
* Note: Hispanic includes all races, white + black + other = total

* 2000 census
foreach group in all white black hispanic {
	import delim using "$input/census2000_age_`group'.csv", clear
	capture rename *, lower

	rename vd01 pop_`group'
	gen pop_`group'_u5 = vd03 + vd27
	gen pop_`group'_5_9 = vd04 + vd28
	gen pop_`group'_10_14 = vd05 + vd29
	gen pop_`group'_15_17 = vd06 + vd30
	gen pop_`group'_18_19 = vd07 + vd31
	
	gen year = 2000
	
	keep id2 geography year pop_*
	tempfile age2000_`group'
	save `age2000_`group''
}

clear
use `age2000_all', clear
foreach group in white black hispanic {
	merge 1:1 id2 using `age2000_`group''
	drop _merge
}

tempfile age2000
save `age2000'

* 2010 census
foreach group in all white black hispanic {
	import delim using "$input/census2010_age_`group'.csv", clear
	capture rename *, lower
	
	capture replace d001 = regexr(d001, "\((.)+\)", "")
	capture destring d001, replace

	rename d001 pop_`group'
	gen pop_`group'_u5 = d003 + d027
	gen pop_`group'_5_9 = d004 + d028
	gen pop_`group'_10_14 = d005 + d029
	gen pop_`group'_15_17 = d006 + d030
	gen pop_`group'_18_19 = d007 + d031
	
	gen year = 2010
	
	keep id2 geography year pop_*
	tempfile age2010_`group'
	save `age2010_`group''
}

clear
use `age2010_all', clear
foreach group in white black hispanic {
	merge 1:1 id2 using `age2010_`group''
	drop _merge
}

tempfile age2010
save `age2010'

* ACS, 2009, 2011-13
foreach year in 2009 2011 2012 2013 {
	foreach group in all white black hispanic {
		import delim using "$input/acs`year'_age_`group'.csv", clear
		capture rename *, lower
		drop hd02_*
		rename hd01_* *
		
		if "`group'"=="all" {
			rename vd01 pop_`group'
			gen pop_`group'_u5 = vd03 + vd27
			gen pop_`group'_5_9 = vd04 + vd28
			gen pop_`group'_10_14 = vd05 + vd29
			gen pop_`group'_15_17 = vd06 + vd30
			gen pop_`group'_18_19 = vd07 + vd31
		}
		if "`group'"!="all" {
			rename vd01 pop_`group'
			gen pop_`group'_u5 = vd03 + vd18
			gen pop_`group'_5_9 = vd04 + vd19
			gen pop_`group'_10_14 = vd05 + vd20
			gen pop_`group'_15_17 = vd06 + vd21
			gen pop_`group'_18_19 = vd07 + vd22
		}
		
		gen year = `year'
		
		keep id2 geography year pop_*
		tempfile age`year'_`group'
		save `age`year'_`group''
	}
	
	clear
	use `age`year'_all', clear
	foreach group in white black hispanic {
		merge 1:1 id2 using `age`year'_`group''
		drop _merge
	}

	tempfile age`year'
	save `age`year''
}

clear
foreach year in 2000 2009 2010 2011 2012 2013 {
	append using `age`year'', force
}

gen pop_other = pop_all - (pop_white + pop_black)
gen pop_other_u5 = pop_all_u5 - (pop_white_u5 + pop_black_u5)
gen pop_other_5_9 = pop_all_5_9 - (pop_white_5_9 + pop_black_5_9)
gen pop_other_10_14 = pop_all_10_14 - (pop_white_10_14 + pop_black_10_14)
gen pop_other_15_17 = pop_all_15_17 - (pop_white_15_17 + pop_black_15_17)
gen pop_other_18_19 = pop_all_18_19 - (pop_white_18_19 + pop_black_18_19)

foreach group in white black other hispanic {
	foreach age in 5_9 10_14 15_17 18_19 {
		gen share_`group'_`age' = (pop_`group'_`age'/pop_all)*100
		replace share_`group'_`age' = 0 if pop_all==0
	}
}

order id2 geography year pop_all* pop_white* pop_black* pop_other* pop_hispanic* share*
sort id2 year
format id2 %11.0f

save "$output/wisconsin_tract_covars.dta", replace




// Labor force status, income, poverty
* 2000 Census
import delim using "$input/census2000_econchar.csv", clear
capture rename *, lower

keep id2 geography hc02_vc04 hc02_vc06 hc01_vc64 hc01_vc86 hc02_vc105 hc02_vc111
rename (hc02_vc04 hc02_vc06 hc01_vc64 hc01_vc86 hc02_vc105 hc02_vc111) (lfpr ur medhhinc medfaminc povrate_all povrate_child)
tostring medhhinc, replace
tostring medfaminc, replace
gen year = 2000

tempfile econ2000
save `econ2000'

* 2009-2013 ACS
forvalues year = 2009/2013 {
	import delim using "$input/acs`year'_econchar.csv", clear
	capture rename *, lower
	
	if `year'==2009 {
		capture drop *_moe_*
		capture rename *_est* **
		keep id2 geography hc02_vc04 hc02_vc06 hc01_vc69 hc01_vc93 hc01_vc120 hc01_vc121
		rename (hc02_vc04 hc02_vc06 hc01_vc69 hc01_vc93 hc01_vc120 hc01_vc121) (lfpr ur medhhinc medfaminc povrate_all povrate_child)
	}
	if inrange(`year',2010,2012) {
		keep id2 geography hc03_vc06 hc03_vc08 hc01_vc85 hc01_vc112 hc03_vc166 hc03_vc167
		rename (hc03_vc06 hc03_vc08 hc01_vc85 hc01_vc112 hc03_vc166 hc03_vc167) (lfpr ur medhhinc medfaminc povrate_all povrate_child)
	}
	if `year'==2013 {
		keep id2 geography hc03_vc05 hc03_vc07 hc01_vc85 hc01_vc114 hc03_vc171 hc03_vc172
		rename (hc03_vc05 hc03_vc07 hc01_vc85 hc01_vc114 hc03_vc171 hc03_vc172) (lfpr ur medhhinc medfaminc povrate_all povrate_child)
	}
	gen year = `year'
	
	tempfile econ`year'
	save `econ`year''
}

clear
foreach year in 2000 2009 2010 2011 2012 2013 {
	append using `econ`year'', force
}

order id2 geography year lfpr ur medhhinc medfaminc povrate_all povrate_child
sort id2 year
format id2 %11.0f
foreach var in lfpr ur medhhinc medfaminc povrate_all povrate_child {
	replace `var' = regexr(`var', "\((.)+\)", "")
	replace `var' = regexr(`var', ",", "")
	replace `var' = regexr(`var', "-", "")
	replace `var' = regexr(`var', "\+", "")
	destring `var', replace
}
tempfile econ
save `econ'

clear
use "$output/wisconsin_tract_covars.dta", clear
merge 1:1 id2 year using `econ'
drop _merge

save "$output/wisconsin_tract_covars.dta", replace




// Nativity, citizenship, language spoken at home, marital status, adult educational attainment
import delim using "$input/census2000_socialchar.csv", clear
capture rename *, lower

keep id2 geography hc02_vc10 hc02_vc11 hc02_vc12 hc02_vc13 hc02_vc14 hc02_vc15 hc02_vc16 hc02_vc17 hc02_vc18 hc02_vc21 hc02_vc22 hc02_vc23 hc02_vc24 hc02_vc26 hc02_vc55 hc02_vc60 hc02_vc62 hc02_vc74 hc02_vc75 hc02_vc77
rename (hc02_vc10 hc02_vc11 hc02_vc12 hc02_vc13 hc02_vc14 hc02_vc15 hc02_vc16 hc02_vc17 hc02_vc18 hc02_vc21 hc02_vc22 hc02_vc23 hc02_vc24 hc02_vc26 hc02_vc55 hc02_vc60 hc02_vc62 hc02_vc74 hc02_vc75 hc02_vc77) ///
	   (educ_lt9 educ_somehs educ_hs educ_socolnd educ_assoc educ_bach educ_grad educ_alhs educ_albach nevmarried married separated widowed divorced native foreign foreign_natcit lah_english lah_noteng lah_spanish)
gen year = 2000

tempfile social2000
save `social2000'

* 2010-2013 ACS
forvalues year = 2009/2013 {
	import delim using "$input/acs`year'_socialchar.csv", clear
	capture rename *, lower
	
	if `year'==2009 {
		capture drop *_moe_*
		capture rename *_est* **
		keep id2 geography hc02_vc67 hc02_vc68 hc02_vc69 hc02_vc70 hc02_vc71 hc02_vc72 hc02_vc73 hc02_vc74 hc02_vc75 hc01_vc27 hc01_vc28 hc01_vc29 hc01_vc30 hc01_vc31 hc01_vc32 hc01_vc33 hc01_vc34 hc01_vc35 hc01_vc36 hc01_vc37 hc01_vc38 hc02_vc99 hc02_vc104 hc02_vc107 hc02_vc127 hc02_vc128 hc02_vc130
		rename (hc02_vc67 hc02_vc68 hc02_vc69 hc02_vc70 hc02_vc71 hc02_vc72 hc02_vc73 hc02_vc74 hc02_vc75 hc01_vc27 hc01_vc28 hc01_vc29 hc01_vc30 hc01_vc31 hc01_vc32 hc01_vc33 hc01_vc34 hc01_vc35 hc01_vc36 hc01_vc37 hc01_vc38 hc02_vc99 hc02_vc104 hc02_vc107 hc02_vc127 hc02_vc128 hc02_vc130) ///
			   (educ_lt9 educ_somehs educ_hs educ_socolnd educ_assoc educ_bach educ_grad educ_alhs educ_albach pop15_m nevmarried_m married_m separated_m widowed_m divorced_m pop15_f nevmarried_f married_f separated_f widowed_f divorced_f native foreign foreign_natcit lah_english lah_noteng lah_spanish)
	}
	if inrange(`year',2010,2012) {
		keep id2 geography hc03_vc85 hc03_vc86 hc03_vc87 hc03_vc88 hc03_vc89 hc03_vc90 hc03_vc91 hc03_vc93 hc03_vc94 hc01_vc35 hc01_vc36 hc01_vc37 hc01_vc38 hc01_vc39 hc01_vc40 hc01_vc42 hc01_vc43 hc01_vc44 hc01_vc45 hc01_vc46 hc01_vc47 hc03_vc129 hc03_vc134 hc03_vc139 hc03_vc167 hc03_vc168 hc03_vc171
		rename (hc03_vc85 hc03_vc86 hc03_vc87 hc03_vc88 hc03_vc89 hc03_vc90 hc03_vc91 hc03_vc93 hc03_vc94 hc01_vc35  hc01_vc36 hc01_vc37 hc01_vc38 hc01_vc39 hc01_vc40 hc01_vc42 hc01_vc43 hc01_vc44 hc01_vc45 hc01_vc46 hc01_vc47 hc03_vc129 hc03_vc134 hc03_vc139 hc03_vc167 hc03_vc168 hc03_vc171) ///
			   (educ_lt9 educ_somehs educ_hs educ_socolnd educ_assoc educ_bach educ_grad educ_alhs educ_albach pop15_m nevmarried_m married_m separated_m widowed_m divorced_m pop15_f nevmarried_f married_f separated_f widowed_f divorced_f native foreign foreign_natcit lah_english lah_noteng lah_spanish)
	}
	if `year'==2013 {
		keep id2 geography hc03_vc86 hc03_vc87 hc03_vc88 hc03_vc89 hc03_vc90 hc03_vc91 hc03_vc92 hc03_vc95 hc03_vc96 hc01_vc36 hc01_vc37 hc01_vc38 hc01_vc39 hc01_vc40 hc01_vc41 hc01_vc43 hc01_vc44 hc01_vc45 hc01_vc46 hc01_vc47 hc01_vc48 hc03_vc131 hc03_vc136 hc03_vc141 hc03_vc171 hc03_vc172 hc03_vc174
		rename (hc03_vc86 hc03_vc87 hc03_vc88 hc03_vc89 hc03_vc90 hc03_vc91 hc03_vc92 hc03_vc95 hc03_vc96 hc01_vc36 hc01_vc37 hc01_vc38 hc01_vc39 hc01_vc40 hc01_vc41 hc01_vc43 hc01_vc44 hc01_vc45 hc01_vc46 hc01_vc47 hc01_vc48 hc03_vc131 hc03_vc136 hc03_vc141 hc03_vc171 hc03_vc172 hc03_vc174) ///
			   (educ_lt9 educ_somehs educ_hs educ_socolnd educ_assoc educ_bach educ_grad educ_alhs educ_albach pop15_m nevmarried_m married_m separated_m widowed_m divorced_m pop15_f nevmarried_f married_f separated_f widowed_f divorced_f native foreign foreign_natcit lah_english lah_noteng lah_spanish)
	}
	
	gen nevmarried = string(((nevmarried_m + nevmarried_f)/(pop15_m + pop15_f))*100)
	gen married = string(((married_m + married_f)/(pop15_m + pop15_f))*100)
	gen separated = string(((separated_m + separated_f)/(pop15_m + pop15_f))*100)
	gen widowed = string(((widowed_m + widowed_f)/(pop15_m + pop15_f))*100)
	gen divorced = string(((divorced_m + divorced_f)/(pop15_m + pop15_f))*100)
	drop *_m *_f
	
	gen year = `year'
	
	tempfile social`year'
	save `social`year''
}

clear
foreach year in 2000 2009 2010 2011 2012 2013 {
	append using `social`year'', force
}

sort id2 year
format id2 %11.0f
foreach var in educ_lt9 educ_somehs educ_hs educ_socolnd educ_assoc educ_bach educ_grad educ_alhs educ_albach nevmarried married separated widowed divorced native foreign foreign_natcit lah_english lah_noteng lah_spanish {
	replace `var' = regexr(`var', "\((.)+\)", "")
	replace `var' = regexr(`var', ",", "")
	replace `var' = regexr(`var', "-", "")
	replace `var' = regexr(`var', "\+", "")
	destring `var', replace
}

replace foreign_natcit = foreign*(foreign_natcit/100)
replace educ_albach = educ_bach + educ_grad
replace educ_alhs = educ_hs + educ_socolnd + educ_assoc + educ_albach

tempfile social
save `social'

clear
use "$output/wisconsin_tract_covars.dta", clear
merge 1:1 id2 year using `social'
drop _merge

save "$output/wisconsin_tract_covars.dta", replace




// More income stuff here?




// Tract locations
gen county = substr(string(id2,"%11.0f"),1,5)
destring county, replace
format county %05.0f
gen tract = substr(string(id2,"%11.0f"),6,6)
destring tract, replace
format tract %06.0f

foreach year in 2000 2009 2010 2011 2012 2013 {
	preserve
	keep if year==`year'
	
	if `year'<=2009 {
		merge 1:1 county tract using "$data/ustracts2000.dta"
		drop if _merge==2 & postal!="IN"
		drop _merge
	}
	if `year'>=2010 {
		merge 1:1 county tract using "$data/ustracts2010.dta"
		drop if _merge==2 & postal!="IN"
		drop _merge
	}
	
	tempfile yr`year'
	save `yr`year''
	restore
}

clear
foreach year in 2000 2009 2010 2011 2012 2013 {
	append using `yr`year''
}
sort id2 year

save "$output/wisconsin_tract_covars.dta", replace





***** FPL Shares

clear *
set more off

global data "Data"
global faminc_famtype "Data/Census Tract Covariates/For Stata"

// Input annual federal poverty threshold for a family of 4 in the contiguous 48 states
global povcut_2000 17050
global povcut_2009 22050
global povcut_2010 22050
global povcut_2011 22350
global povcut_2012 23050
global povcut_2013 23550

foreach year in 2000 2009 2010 2011 2012 2013 {
	global fpl175_`year' = round(${povcut_`year'}*1.75)
	global fpl185_`year' = round(${povcut_`year'}*1.85)
	global fpl200_`year' = round(${povcut_`year'}*2)
	global fpl220_`year' = round(${povcut_`year'}*2.2)
	global fpl300_`year' = round(${povcut_`year'}*3)
	global fpl400_`year' = round(${povcut_`year'}*4)
	global fpl500_`year' = round(${povcut_`year'}*5)
}

foreach var in faminc_famtype {
	foreach year in 2000 2009 2010 2011 2012 2013 {
		if `year'==2000 import delim using "${`var'}/census`year'_`var'.csv", clear
		if `year'!=2000 import delim using "${`var'}/acs`year'_`var'.csv", clear
		
		capture drop hd02_*
		capture rename hd01_* *
		
		if "`var'"=="faminc_famtype" {
			rename (vd01 vd02 vd03 vd04 vd05 vd06 vd07 vd08 vd09 vd10 vd11 vd12 vd13 vd14 vd15 vd16 vd17 vd18 vd19) ///
				   (fam fam_a count0a count1a count2a count3a count4a count5a count6a count7a count8a count9a count10a count11a count12a count13a count14a count15a count16a)
			rename (vd38 vd39 vd40 vd41 vd42 vd43 vd44 vd45 vd46 vd47 vd48 vd49 vd50 vd51 vd52 vd53 vd54 vd55) ///
				   (fam_b count0b count1b count2b count3b count4b count5b count6b count7b count8b count9b count10b count11b count12b count13b count14b count15b count16b)
			rename (vd73 vd74 vd75 vd76 vd77 vd78 vd79 vd80 vd81 vd82 vd83 vd84 vd85 vd86 vd87 vd88 vd89 vd90) ///
				   (fam_c count0c count1c count2c count3c count4c count5c count6c count7c count8c count9c count10c count11c count12c count13c count14c count15c count16c)
			forvalues n = 0/16 {
				gen count`n' = count`n'a + count`n'b + count`n'c
			}
			drop count*a count*b count*c
		}
		reshape long count, i(id2) j(incgrp)
		label define incgrp 0 "All" ///
							1 "Less than $10,000" ///
							2 "$10,000 to $14,999" ///
							3 "$15,000 to $19,999" ///
							4 "$20,000 to $24,999" ///
							5 "$25,000 to $29,999" ///
							6 "$30,000 to $34,999" ///
							7 "$35,000 to $39,999" ///
							8 "$40,000 to $44,999" ///
							9 "$45,000 to $49,999" ///
							10 "$50,000 to $59,999" ///
							11 "$60,000 to $74,999" ///
							12 "$75,000 to $99,999" ///
							13 "$100,000 to $124,999" ///
							14 "$125,000 to $149,999" ///
							15 "$150,000 to $199,999" ///
							16 "$200,000 or more"
		label values incgrp incgrp
		drop if incgrp==0

		format id2 %11.0f
		gen county = substr(string(id2,"%11.0f"),1,5)
		destring county, replace
		format county %05.0f
		gen tract = substr(string(id2,"%11.0f"),6,6)
		destring tract, replace
		format tract %06.0f
		
		bys id2: egen hhcount = total(count)
		bys id2: gen hhruncount = sum(count)

		recode incgrp (1 = 9999) (2 = 14999) (3 = 19999) (4 = 24999) (5 = 29999) (6 = 34999) (7 = 39999) (8 = 44999) (9 = 49999) (10 = 59999) (11 = 74999) (12 = 99999) (13 = 124999) (14 = 149999) (15 = 199999) (16 = .), gen(incgrp_ub)

		xtset id2 incgrp

		gen povwgt = incgrp_ub<=${povcut_`year'}
		replace povwgt = max(min((incgrp_ub - L.incgrp_ub),(${povcut_`year'} - L.incgrp_ub))/(incgrp_ub - L.incgrp_ub),0) if povwgt==0

		gen fpl175wgt = incgrp_ub<=${fpl175_`year'}
		replace fpl175wgt = max(min((incgrp_ub - L.incgrp_ub),(${fpl175_`year'} - L.incgrp_ub))/(incgrp_ub - L.incgrp_ub),0) if fpl175wgt==0
		
		gen fpl185wgt = incgrp_ub<=${fpl185_`year'}
		replace fpl185wgt = max(min((incgrp_ub - L.incgrp_ub),(${fpl185_`year'} - L.incgrp_ub))/(incgrp_ub - L.incgrp_ub),0) if fpl185wgt==0

		gen fpl200wgt = incgrp_ub<=${fpl200_`year'}
		replace fpl200wgt = max(min((incgrp_ub - L.incgrp_ub),(${fpl200_`year'} - L.incgrp_ub))/(incgrp_ub - L.incgrp_ub),0) if fpl200wgt==0
		
		gen fpl220wgt = incgrp_ub<=${fpl220_`year'}
		replace fpl220wgt = max(min((incgrp_ub - L.incgrp_ub),(${fpl220_`year'} - L.incgrp_ub))/(incgrp_ub - L.incgrp_ub),0) if fpl220wgt==0

		gen fpl300wgt = incgrp_ub<=${fpl300_`year'}
		replace fpl300wgt = max(min((incgrp_ub - L.incgrp_ub),(${fpl300_`year'} - L.incgrp_ub))/(incgrp_ub - L.incgrp_ub),0) if fpl300wgt==0
		
		gen fpl400wgt = incgrp_ub<=${fpl400_`year'}
		replace fpl400wgt = max(min((incgrp_ub - L.incgrp_ub),(${fpl400_`year'} - L.incgrp_ub))/(incgrp_ub - L.incgrp_ub),0) if fpl400wgt==0
		
		gen fpl500wgt = incgrp_ub<=${fpl500_`year'}
		replace fpl500wgt = max(min((incgrp_ub - L.incgrp_ub),(${fpl500_`year'} - L.incgrp_ub))/(incgrp_ub - L.incgrp_ub),0) if fpl500wgt==0

		bys id2: egen fplcount = total(count*povwgt)
		bys id2: egen fpl175count = total(count*fpl175wgt)
		bys id2: egen fpl185count = total(count*fpl185wgt)
		bys id2: egen fpl200count = total(count*fpl200wgt)
		bys id2: egen fpl220count = total(count*fpl220wgt)
		bys id2: egen fpl300count = total(count*fpl300wgt)
		bys id2: egen fpl400count = total(count*fpl400wgt)
		bys id2: egen fpl500count = total(count*fpl500wgt)

		foreach measure in fpl fpl175 fpl185 fpl200 fpl220 fpl300 fpl400 fpl500 {
			gen `measure'share = (`measure'count/hhcount)*100
		}

		keep if incgrp==1
		keep id2 geography county tract hhcount *share fpl*count
		gen year = `year'
		
		tempfile `var'_`year'
		save ``var'_`year''
	}
}

foreach var in faminc_famtype {
	clear
	foreach year in 2000 2009 2010 2011 2012 2013 {
		append using ``var'_`year''
	}
	order id2 geography year hhcount *share fpl*count
	sort id2 year
	rename hhcount famcount
	saveold "$data/wisconsin_tract_fpl_shares_`var'.dta", replace
}
