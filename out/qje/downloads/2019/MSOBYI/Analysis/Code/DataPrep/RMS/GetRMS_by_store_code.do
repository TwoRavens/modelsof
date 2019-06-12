/* GetRMS_by_store_code.do */
* Gets RMS movement data and collapses to store level

include Code/SetGlobals.do // For JPLinux

/* COLLAPSE RMS TO THE STORE LEVEL */
* Attributes must include DemandAttributes.
* _energy refers to attributes that are collapsed weighting by energy_per1; _cals are collapsed weighting by cals_per1
* Note that ImputedHEINuts are used to measure the share of cals that have HEI info imputed; we want to weight these by Gladson cals, not the (imputed) energy measure
global DemandAttributes_cals = "rHealthIndex_per1000Cal ShareCoke ImputedHEINuts" // $HealthIndexNuts $HEINuts g_fiber_per1000Cal g_prot_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal"
global Attributes_cals = "rHealthIndex_per1000Cal Whole ShareCoke FreshFruit FreshVeg $HealthIndexNuts ImputedHEINuts" // SSB HealthIndex_per1 g_fat_per1000Cal g_carb_per1000Cal g_fiber_per1000Cal g_prot_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal 

global DemandAttributes_energy = "rlHEI_per1000Cal"
global Attributes_energy = "rlHEI_per1000Cal $HEINuts"

clear
save $Externals/Calculations/RMS/RMS_by_store_code_Temp.dta, replace emptyok

forvalues year = 2006/$MaxYear {
	foreach d in 1 2 3 4 5 6 9999 {
		capture noisily use $Externals/Calculations/RMS/MovementUPCStoreYear_`d'_`year'.dta, replace
		if _N==0 | _rc == 601 {
			continue
		}
		** Deflate
		gen int year = `year'
		merge m:1 year using $Externals/Calculations/CPI/CPI_Annual.dta, keep(match master) nogen keepusing(CPI)
		replace price = price/CPI
		drop CPI
		
		
		gen Revenue = price*units
		
		** Merge UPC attributes
		merge m:1 upc using $Externals/Calculations/RMS/rms_versions_`year'.dta, keep(match master) nogen keepusing(upc_ver_uc)
		merge m:1 upc upc_ver_uc using $Externals/Calculations/OtherNielsen/Prepped-UPCs.dta, keep(match master) nogen ///
			keepusing($Attributes_cals $Attributes_energy cals_per1 energy_per1 NonFood) // LowFatMilk NonFatMilk
		
		drop if NonFood==1
		drop NonFood
		
		if _N==0 {
			continue
		}
		sum cals_per1
		if r(N)==0|r(mean)==0 {
			continue
		}
		
		gen NUPCs = 1
		gen NProduce = Fruit+Veg
		gen NFreshProduce = FreshFruit+FreshVeg
		/*
		gen byte SellsBread = cond(Whole!=.,1,0)
		gen byte SellsMilk = cond(MilkFatPct!=.,1,0)
		
		foreach var in Whole FreshFruit Fruit FreshVeg Veg { // LowFatMilk NonFatMilk 
			gen byte Sells`var' = `var'
		}
		*/
		
		/*
		** Calculate price per calorie
		gen Price_H = price if HealthIndex_per1>0 & HealthIndex_per1!=. // Healthful
		gen Price_UH = price if HealthIndex_per1<0 & HealthIndex_per1!=. // Unhealthful
		gen Price_Pr = price if Fruit==1|Veg==1 // Produce
		gen Price_HNPr = price if Fruit==0&Veg==0 & HealthIndex_per1>0 & HealthIndex_per1!=. // Healthful Non-Produce (note that all produce has positive HealthIndex)
		
		* Calorie counts
		gen Calories_H = cals_per1 if HealthIndex_per1>0 & HealthIndex_per1!=. // Healthful
		gen Calories_UH = cals_per1 if HealthIndex_per1<0 & HealthIndex_per1!=. // Unhealthful
		gen Calories_Pr = cals_per1 if Fruit==1|Veg==1 // Produce
		gen Calories_HNPr = cals_per1 if Fruit==0&Veg==0 & HealthIndex_per1>0 & HealthIndex_per1!=. // Healthful Non-Produce (note that all produce has positive HealthIndex)
		*/
		
		** Calculate demand attributes for purchase-weighted averages
		gen calsSold = cals_per1*units // Calories sold of that UPC
		foreach var in $DemandAttributes_cals {
			gen `var'Xcals = `var'*calsSold
		}
		gen energySold = energy_per1*units
		foreach var in $DemandAttributes_energy {
			gen `var'Xenergy = `var'*energySold
		}
		gen CaloriesSoldCokePepsi = calsSold if ShareCoke!=.
		
		** Collapse
			* Weight by cals, then merge with the collapse weighted by energy
		preserve
			collapse /* (max) Sells* */ (rawsum) calsSold CaloriesSoldCokePepsi /* Calories_* Price_* */ *Xcals cals = cals_per1 ///
				energySold *Xenergy energy = energy_per1 ///
				Revenue NUPCs NProduce NFreshProduce ///
				(mean) $Attributes_cals [pw=cals_per1], by(store_code_uc) fast
			save $Externals/Calculations/RMS/Temp.dta, replace
		restore

		collapse (mean) $Attributes_energy [pw=energy_per1], by(store_code_uc) fast
		merge 1:1 store_code_uc using $Externals/Calculations/RMS/Temp.dta, nogen
		erase $Externals/Calculations/RMS/Temp.dta
		
		gen int year = `year'
		append using $Externals/Calculations/RMS/RMS_by_store_code_Temp.dta
		saveold $Externals/Calculations/RMS/RMS_by_store_code_Temp.dta, replace
	}
}




** Collapse across the departments
	* Collapse weighted by cals, then merge with collapse weighted by energy
use $Externals/Calculations/RMS/RMS_by_store_code_Temp.dta, replace
collapse /* (max) Sells* */ (rawsum) *Xcals calsSold CaloriesSoldCokePepsi /* Calories_* Price_* */ cals Revenue NUPCs NProduce NFreshProduce ///
	energySold energy *Xenergy ///
	(mean) $Attributes_cals [pw=cals], by(store_code_uc year)
save $Externals/Calculations/RMS/Temp.dta, replace

use $Externals/Calculations/RMS/RMS_by_store_code_Temp.dta, replace
collapse (mean) $Attributes_energy [pw=energy], by(store_code_uc year)
merge 1:1 store_code_uc year using $Externals/Calculations/RMS/Temp.dta, nogen
erase $Externals/Calculations/RMS/Temp.dta


** Get demand attributes weighted by calories sold
foreach var in $DemandAttributes_cals {
	gen D_`var' = `var'Xcals/calsSold
}
replace D_ShareCoke = ShareCokeXcals/CaloriesSoldCokePepsi
foreach var in $DemandAttributes_energy {
	gen D_`var' = `var'Xenergy/energySold
}
drop *Xcals *Xenergy
rename calsSold CaloriesSold

/* Additional data prep */
compress
saveold $Externals/Calculations/RMS/RMS_by_store_code.dta, replace
