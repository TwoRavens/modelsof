* clean EUKLEMS data

u "..\temp\EUKLEMS_Mar11", clear
	
	replace country = "US" if country=="USA-NAICS"
		drop if country=="USA"
	
		// merge in Korean capital data
merge 1:1 country code year using "..\temp\EUKLEMS_Mar08_capital_KOR", update keepusing(CAPIT CAPNIT)
		drop _mer
	
		// merge in XR data
merge m:1 country year using "..\temp\PWT_xrates.dta"
		drop if _merge==2
	
		// normalise all nominal variables to US$
	foreach var in VA CAP LAB {
		gen `var'_local = `var'
		replace `var' = `var'/xr
	}
		
	gen CAPLAB = CAP/LAB
	
		// convert capital type shares to US$
	gen CAPITSHR = CAPIT
	
	foreach var in CAPIT CAPNIT {
		replace `var' = `var'*CAP
	}
	
		// normalise all real variables to baseyear levels
	local baseyr = 2005
	
	foreach var in VA LAB CAP CAPIT CAPNIT {
		do normalize `var'_QI country code year `baseyr'
		
		so country code year
		
		gen `var'_baseyr = `var' if year==`baseyr'
		by country code: egen `var'_baseyr_mean = mean(`var'_baseyr)
		replace `var'_QI = `var'_QI*`var'_baseyr_mean/100
		
		drop `var'_baseyr*
	}
	
		// generate US GDP deflator
	so country code year
	
	qui sum year if code=="TOT" & country=="US"
	
	by country code: replace VA_P = VA_P/VA_P[`baseyr'-r(min)+1]*100 	///
		if country=="US" & code=="TOT" & year!=`baseyr'
	by country code: replace VA_P = VA_P/VA_P[`baseyr'-r(min)+1]*100 	///
		if country=="US" & code=="TOT" & year==`baseyr'
	
	gen VA_P_US_ = VA_P if country=="US" & code=="TOT"
		
	so year country code
	by year: egen VA_P_US = mean(VA_P_US_)
		drop VA_P_US_
	
	la var VA_P_US "GDP deflator for US, `baseyr' = 100"
	
		// cross walk to robots industries
	do xwalk_ind_EUKLEMS_to_robots
	do rename_robots_industries
	
	
		// update variable labels
	do labels_EUKLEMS_var_cleaned `baseyr'
	
	la data "EUKLEMS Mar 2011; nominal values expressed in millions"
	
	local varlist "country code_euklems desc code_robots ind_robots year"
	local varlist "`varlist' VA VA_loc VA_QI VA_P_US EMP H_EMP LAB LAB_loc LAB_QI CAP CAP_loc CAP_QI"
	local varlist "`varlist' CAPLAB CAPIT* CAPIT_QI CAPNIT CAPNIT_QI TFPva_I"
	
	keep `varlist'
	order `varlist'	
			
sa "..\output\EUKLEMS.dta", replace
