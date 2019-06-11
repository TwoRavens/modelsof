/* PrepBirthMoverRegs.do */
* This prepares the birth mover regressions

global AreaTypeList = "Ct CZ St"



foreach dataset in HHxYear { // HHxYear_Magnet
	use household_code panel_year ShareCoke Produce Calories expend HealthIndex_per1000Cal ///
	g_prot_per1000Cal g_fiber_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal ///
	InSample using Calculations/Homescan/`dataset'.dta, replace, if InSample==1	
	drop InSample

	
	** Merge household data, including lat and lon
		if "`dataset'" == "HHxYear" {
			local pf = "projection_factor"
		}
		else if "`dataset'" == "HHxYear_Magnet" {
			local pf = "projection_factor_magnet"
		}
	merge m:1 household_code panel_year using Calculations/Homescan/Prepped-Household-Panel.dta, ///
		nogen keep(match master) keepusing(`pf' zip_code state_countyFIPS cz fips_state_code region_code $Ctls_Merge ///
		pviews_age state_born_fips BirthMoverHH_* YearsCurrentSt mod_age_move age_move)	
	
	*keep if BirthMoverSample==1
	*drop BirthMoverSample

		
	** Merge health characteristics of birth state
	local Vars = "PrD_HealthIndex_per1000Cal PrD_ShareCoke PrD_Produce" 
	local Vars = "`Vars' PrD_g_prot_per1000Cal PrD_g_fiber_per1000Cal PrD_g_fat_sat_per1000Cal PrD_g_sugar_per1000Cal PrD_g_sodium_per1000Cal PrD_g_cholest_per1000Cal"
	rename fips_state_code tempstate
	rename state_born_fips fips_state_code
	merge m:1 fips_state_code using Calculations/Geographic/St_DemandInfo.dta, ///
		nogen keep(match master) keepusing(`Vars')
	foreach var in `Vars' {
		rename `var' StB_`var'
	}
	rename fips_state_code state_born_fips
	rename tempstate fips_state_code 
	
	** Merge health characteristics of current location
	foreach areatype in $AreaTypeList {
		include Code/DataPrep/DefineGeonames.do
		merge m:1 `geoname' using Calculations/Geographic/`areatype'_DemandInfo.dta, nogen keep(match master) ///
			keepusing(`Vars')	
		foreach var in `Vars' {
			rename `var' `areatype'N_`var' 
		}
	}

	/* Get beta */
	foreach var in HealthIndex_per1000Cal Produce ShareCoke g_prot_per1000Cal g_fiber_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal {
		foreach areatype in $AreaTypeList {
		
			/* Bronnenberg et al. (2012) beta
			gen b`areatype'_`var' = (`var' - StB_PrD_`var') / (`areatype'N_PrD_`var' - StB_PrD_`var')
			* Weight for WLS
			gen w`areatype'_`var' = (`areatype'N_PrD_`var' - StB_PrD_`var')^2
			*/
			* Change from old to new
			*gen M`areatype'_`var' = (`areatype'N_PrD_`var' - StB_PrD_`var')
			gen N`areatype'_`var' = (StB_PrD_`var' - `areatype'N_PrD_`var')
				
				* Replace with zero if missing.
				*replace M`areatype'_`var' = 0 if M`areatype'_`var'==.
				replace N`areatype'_`var' = 0 if N`areatype'_`var'==.
				replace StB_PrD_`var' = 0 if StB_PrD_`var'==.
		}
		* Outcome 
		*gen Y`var' = (`var' - StB_PrD_`var')
		
			* Replace with zero if missing.
			*replace Y`var'  = 0 if Y`var' ==. & `var'!=.
	}
	
	
	
	/* Get buckets for age and years since move */
	foreach var in YearsCurrentSt mod_age_move {
		gen `var'_b = floor(`var'/10)*10
		*gen `var'_b = `var'
		replace `var'_b = 40 if `var'_b > 40 & `var'_b!=. // Not a lot of sample after 40 years, for either variable.
		replace `var'_b = 999 if `var'==.|BirthMoverHH_All==0|BirthMoverHH_All==. // Make 999 for non-movers or people who haven't moved yet.
	}

	
	
	** Time/Region controls
	*egen RegionYear = group(region_code panel_year)
	*xtset household_code panel_year
	compress
	save Calculations/Homescan/`dataset'_BirthMovers.dta, replace
}

