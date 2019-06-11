/* CollapseMovementDatabyZipYear2011.do */
* Hunt 5-11-2015, Rebecca 7/1/16

/* SETUP */
clear all
set more off





*global Attributes = "g_fat_per1000Cal g_carb_per1000Cal g_fiber_per1000Cal g_prot_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal HealthIndex_per1000Cal"
global Attributes = "energy_per1 rlHEI_per1000Cal $HEINuts_per1 cals_per1"
** Get NModules 
*use Calculations/RMS/Product_Hierarchy.dta, replace
*global NModules = _N





foreach year in 2016 {
	/* Set up file */
	clear
	save "$Externals/Calculations/RMS/MovementStore_`year'.dta", replace emptyok
	foreach d in  2 3 4 5 6 1{ // 0 is health&beauty (includes diet aids and vitamins); 8 is alcohol (see ImportHomescan.do; these are excluded from all analysis. 7 is non-food grocery, and 9 is general merchandise. 9999 has prices but is "unclassified," and we have no UPC info for them (e.g. no calorie info), so leave out.
		display "This is department `d' for year `year'."
		/* Get UPC-by-store prices list */
			* Do these merges all at once because they are each used multiple times and the merges are time-consuming.
		use "$Externals/Calculations/RMS/MovementUPCStoreYear_`d'_`year'.dta", replace // , if _n<100000 // temporary limit on observations for de-bugging
		compress // Units is sometimes long, but can be int.
		/*if _N==0 {
			continue
		}
		*/
		
		/* Make National Expenditure weights for each UPC */
		egen total_units=total(units), by(upc)
		gen total_expend=total_units*price
		

		
		
		** Merge UPC version and our group code 
		merge m:1 upc using "$Externals/Calculations/RMS/rms_versions_`year'.dta", keep(match master) nogen keepusing(upc_ver_uc)
		merge m:1 upc upc_ver_uc using "$Externals/Calculations/OtherNielsen/Prepped-UPCs.dta", keep(match) nogen ///
			keepusing($Attributes Grams group NonFood )
		
	    foreach var of varlist  $Attributes {
		replace `var'=`var'*total_units
		}
     
			
		gen NUPCs = 1
			*gen price_per100g = price/Grams *100
			*replace Fruit=Fruit*Grams
			*replace Veg=Veg*Grams
			
			*TopCode StoreTime and weight by calories
			*replace StoreTime=365 if StoreTime>365 & StoreTime~=.
			*replace StoreTime=StoreTime*energy_per1

			** Merge store zips
			gen year = `year'	

		collapse (sum) NUPCs Grams $Attributes price total_units total_expend, by(store_code_uc group)
		
		append using "$Externals/Calculations/RMS/MovementStore_`year'.dta"
			save "$Externals/Calculations/RMS/MovementStore_`year'.dta", replace emptyok
		}
		}

    foreach var of varlist  sodium_mg_per1- solid_fats_kcal_per1 total_expend{
		replace `var'=`var'/energy_per1
		rename `var' `var'Cal
		}
     save "$Externals/Calculations/RMS/MovementStore_`year'.dta", replace emptyok
		
		

/*

forvalues year = 2006/2006 {
	/* Get UPC version file for each year */
	insheet using $neilsen_path/nielsen_extracts/RMS/`year'/Annual_Files/rms_versions_`year'.tsv, clear
	format upc %12.0f
	drop panel_year
	save Calculations/RMS/rms_versions_`year'.dta, replace

	/* Set up file */
	clear
	save Calculations/RMS/MovementStore_`year'.dta, replace emptyok


	/* COLLAPSE THE MOVEMENT FILE FOR EACH MODULE */
	forvalues n = 1/$NModules { 
		use Calculations/RMS/Product_Hierarchy.dta, replace
		
		local dept=department_code[`n']

		*Skip non-food departments
		if `dept'>0 & `dept'<7 {
		local module = module_string[`n']
		display "`module'"
		local group = group_string[`n']
		display "`group'"
		
		** 
		capture noisily insheet using $neilsen_path/nielsen_extracts/RMS/`year'/Movement_Files/`group'_`year'/`module'_`year'.tsv,clear
		if _rc != 601 { // _rc = 601 if the file isn't found

			replace price = price/prmult

			** Collapse to eliminate "almost duplicates"
			* Use the first one. According to the codebook, these are duplicates
			collapse (first) price units,by(week_end store_code_uc upc)
		
			** Collapse to UPC-by-store level
			collapse (mean) price, by(store_code_uc upc)
			
			** Merge UPC attributes
			merge m:1 upc using Calculations/RMS/rms_versions_`year'.dta, keep(match master) nogen keepusing(upc_ver_uc)
			merge m:1 upc upc_ver_uc using Calculations/OtherNielsen/Prepped-UPCs.dta, keep(match) nogen ///
				keepusing($Attributes Grams)

			gen NUPCs = 1
			*gen price_per100g = price/Grams *100
			replace Fruit=Fruit*Grams
			replace Veg=Veg*Grams
			
			*TopCode StoreTime and weight by calories
			replace StoreTime=365 if StoreTime>365 & StoreTime~=.
			replace StoreTime=StoreTime*cals_per1
			
			** Merge store zips
			gen year = `year'
			*merge m:1 store_code_uc year using /home/data/Nielsen-Data/RMS/Stata_Files/Stores.dta, nogen keepusing(store_zip) keep(match)
			*rename store_zip zip_code
			
			** Collapse to the zip level
				* This is now average attributes and sum of UPCs within the module, for each zip.
			collapse (sum) NUPCs Grams $Attributes price , by(store_code_uc) // Could do  [pw=Grams] , but the gram imputation is imperfect and it probably won't make much difference anyway.
			gen product_module_code = `module'
			
			** Merge with previous aggregated file
			append using Calculations/RMS/MovementStore_`year'.dta
			save Calculations/RMS/MovementStore_`year'.dta, replace emptyok
		}
		}
	}
}		

*/
