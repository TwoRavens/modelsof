/* CollapseMovementData.do */
* This file imports the RMS movement tsv files, collapses to the store-UPC-year level, 
* drops "almost duplicates", and combines into a .dta file at the product group level.
* Created by Hunt


/* SETUP */
include Code/SetGlobals.do // For JPLinux

capture log close
log using Output/LogFiles/CollapseMovementData.log, replace


forvalues year = 2006/$MaxYear { 
	display "Starting year `year'."

	/* IMPORT HIERARCHY FILE */
	import excel "$Nielsen/RMS/reference_documentation/Product_Hierarchy_01.15.2018.xlsx", sheet("hierarchy 10-10-2016")  cellrange(A1:J1405) firstrow clear
	drop if Available == "X" // drop if only available in consumer panel
	drop if product_module_code==8621 // drop cellular phones. this is a duplicate and messes up the 1:1 merge below.
	
	/* Drop if not included in RMS for year `year' */
		* The format here can include things like "2007, 2012-2014"
		* The below code words as long as there is no more than one year range (e.g. 2007-2014) in a cell. This is OK for all food modules as of Product_Hierarchy_10.26.2016.xlsx
	** Drop any years explicitly listed
	drop if strpos(Scannerdatayearsnodata,"`year'")!=0 
	** Drop if between the bounds of a year range
	gen LB = real(substr(Scannerdatayearsnodata,strpos(Scannerdatayearsnodata,"-")-4,4)) if strpos(Scannerdatayearsnodata,"-")!=0
	gen UB = real(substr(Scannerdatayearsnodata,strpos(Scannerdatayearsnodata,"-")+1,4)) if strpos(Scannerdatayearsnodata,"-")!=0
	drop if LB!=. & UB!=. & `year' <= UB & `year' >= LB

	** Drop non-food modules
	drop if inlist(department_code,0,7,8,9)==1 /// 0 is diet aids/vitamins/other health-beauty, 8 is alcohol.
		| product_group_code==508 | /// 508 is pet food ... (department_code==0 & (inlist(product_group_code,6005,6018)==0&product_module_code!=210)) // | /// Keep diet aids and vitamins from department_code 0, but drop everything else.
		product_module_code==4480 | ///Drop fresh flowers
		product_group_code==2004 // Drop ice
			
	keep department_code product_module_code product_group_code
	tostring product_group_code, gen(group_string)
	replace group_string="0"+group_string if length(group_string)==3
	tostring product_module_code, gen(module_string)

	global NModules = _N

	save $Externals/Calculations/RMS/Product_Hierarchy`year'.dta, replace


	/* Set up department files */
	foreach d in 1 2 3 4 5 6 9999 {
		clear
		save $Externals/Calculations/RMS/MovementUPCStoreYear_`d'_`year'.dta, replace emptyok
	}




	/* COLLAPSE THE MOVEMENT FILE FOR EACH MODULE */
	forvalues n = 1/$NModules { 
		use Calculations/RMS/Product_Hierarchy`year'.dta, replace
		local module = module_string[`n']
		display "`module'"
		local group = group_string[`n']
		display "`group'"
		local d = department_code[`n']
		
		** 
		capture noisily insheet using $Nielsen/RMS/`year'/Movement_Files/`group'_`year'/`module'_`year'.tsv,clear
		if _rc != 601 { // _rc = 601 if the file isn't found
			replace price = price/prmult

			** Collapse to eliminate "almost duplicates"
				* Use the first one. According to the codebook, these are duplicates
			collapse (first) price units,by(week_end store_code_uc upc)
					
			** Collapse to store-UPC-year level
			collapse (mean) price (rawsum) units [pw=units], by(store_code_uc upc)
			format upc %12.0f
			compress
			
			append using $Externals/Calculations/RMS/MovementUPCStoreYear_`d'_`year'.dta
			saveold $Externals/Calculations/RMS/MovementUPCStoreYear_`d'_`year'.dta, replace
		}
		
	}


}

! chmod -R 777 /data/desert
