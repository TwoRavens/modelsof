/* WithinLocationAnalysis.do */
* This file measures the disparities that persist (as documented in Stylized Facts)
* 	after controlling for location or store fixed effects

/* SETUP */
clear  all
set more off
set matsize 10000
set maxvar 8000
set scheme s2color
set printcolor auto

capture net install grc1leg2.pkg
	
/* STATEMENTS IN TEXT */


********************************************************************************
********************************************************************************

/* GRAPHS: HEALTHFULNESS AND EXPENDITURES BY INCOME LEVEL */
global Fig = "Output/ReducedForm/Figures"
global NutrientList = "lHEI_per1000Cal" // HealthIndex_per1000Cal NutrientScore" // "" g_sugar_per1000Cal Whole Produce"
global SESList = "HHAvIncome" // Educ "
global Ctls_keep = subinstr("$Ctls","i.","",.)+" HHAvIncome "
global Ctls_Income = "$SESCtls i.panel_year" // i.AgeInt CalorieNeed" // i.household_size - replaced with CalorieNeed
global Ctls_Educ = ""
global Ctls_all=subinstr(subinstr(subinstr("${Ctls}","HHAvIncome","",.),"lnIncome","",.),"lnEduc","",.) // +" household_size"

global base_Income = 50000
global base_Educ = 12

capture program drop main
program define main

	global first=1
	global zip_code_lab="Zip Code"
	global gisjoin_lab="Tract"
	global store_code_uc_lab="Store"
	global retailer_code_lab="Chain"
	
	global Ctls_Income_lab="Household Size and Age Controls"
	global Ctls_Educ_lab="No Demographic Controls"
	global Ctls_all_lab="All Demographic Controls"
	
	global suf_lHEI_per1000Cal="lHEI"
	global suf_NutrientScore="Nutr"
	global suf_HealthIndex_per1000Cal="HI"
	
	global outlab_Educ="Educ"
	global outlab_HHAvIncome="Income"
	global title_Educ="Years of Education"
	global title_HHAvIncome="Household income ($000s)"
	global xaxis_Educ="xlabel(10(2)18) xscale(range(10 18)) "
	global xaxis_HHAvIncome="xlabel(0(25)125) xscale(range(0 125)) "
	
	global weight_xip_code=" [pw=projection_factor]" // " " // 
	global weight_gisjoin=" [pw=projection_factor]" // " " // 
	global weight_store_code_uc=" [pw=projection_factor]" // " [aw=shcal]" // 
	global weight_retailer_code=" [pw=projection_factor]" // " " // 
	
	foreach SESvar in ${SESList} {

		global SESvar="`SESvar'"

	** Within-zipcode/tract
*		sub_figuredata, xsfe(zip_code) minexpsh(50) 
*		sub_figuredata, xsfe(zip_code) 
		
	** Within-store
*			sub_figuredata, xsfe(store_code_uc)
*			sub_figuredata, xsfe(retailer_code) 
			sub_figuredata, xsfe(retailer_code) xsfe2(zip_code) minexpsh(50) 
*			sub_figuredata, xsfe(store_code_uc)  minexpsh(50) 

		global first=1

	}
	
end

********************************************************************************
********************************************************************************
capture program drop sub_figuredata
program define sub_figuredata
	syntax [anything], xsfe(string) [xsfe2(string) minexpsh(string) tractsubsample(string)]
	
	if 1==1 {

	** Purchase data
		if "`xsfe'"=="store_code_uc" | "`xsfe'"=="retailer_code" use "$Externals/Calculations/Homescan/HHxYearxStore.dta", clear
		else use "$Externals/Calculations/Homescan/HHxYear.dta", clear
			// created in DataPrep/Homescan/TransactionDataPrep.do 	
		
		** Merge in zips, income groups & projection_factor
			merge m:1 household_code panel_year using "$Externals/Calculations/Homescan/Prepped-Household-Panel.dta", ///
				keepusing(HHAvIncome IncomeQuartile zip_code projection_factor gisjoin HaveTract ${Ctls_keep}) keep(match master) nogen 
				// created in DataPrep/Homescan/HomescanHouseholdDataPrep.do 		
			if "`tractsubsample'"!="" keep if HaveTract==1

			gen Educ=exp(lnEduc)
			drop if Educ<10
		
	** If limiting to stores with high household-year calorie shares
		if "`minexpsh'"!="" {
			bys household_code panel_year: egen totalcal=total(Calories)
			gen shcal=Calories/totalcal
			drop if shcal==.
			gsort household_code panel_year -shcal
			bys household_code panel_year: gen first=(_n==1)
			sum shcal if first
			drop if shcal<`minexpsh'/100 
			local gphnote "note(Sample limited to stores where households buy at least half of their annual observed Calories.)"
			local suffix "_minexpsh50"
		}
				
	** Generate interacted fixed effect
		keep if `xsfe'!=.
		foreach xsfein in `xsfe' `xsfe2' {
				egen `xsfein'_x_yr=group(`xsfein' panel_year)
		}
		
	** SES dummies:
		drop if ${SESvar}==.
		egen tempgrp=group(${SESvar})
		if "${SESvar}"=="HHAvIncome" {
			xtile byte Income15ile = HHAvIncome [aw=projection_factor], nq(15)
			replace tempgrp=Income15ile
		}
		
	** Identification sample:
		capture drop idsample*
		*keep if IncomeQuartile==1 | IncomeQuartile==4
		gen IncomeQuartileLim = IncomeQuartile if IncomeQuartile==1 | IncomeQuartile==4
		foreach xsfein in `xsfe' `xsfe2' {
			bys `xsfein'_x_yr: egen idsample_`xsfein'=nvals(IncomeQuartile)
			tab idsample_`xsfein'
			bys `xsfein'_x_yr: egen idsamplelim_`xsfein'=nvals(IncomeQuartileLim)
			tab idsamplelim_`xsfein'
			tab idsample_`xsfein' idsamplelim_`xsfein'
			*bys `xsfein'_x_yr: egen idsample_`xsfein'=nvals(${SESvar})
			replace idsample_`xsfein'=min(idsample_`xsfein'-1,1)
		}
		quietly sum tempgrp
		local dropgrp=`r(min)'
		
	** Plot for each outcome...
	*local xsfe="zip_code"
		foreach outcome in $NutrientList { 
			local outlab_`outcome'=subinstr("`outcome'","_per1000Cal","",.)
			foreach ctrl in all {
				foreach idsample in idsample idsamplelim {
					foreach xsfein in  `xsfe' `xsfe2' {
						quietly reg `outcome' ib1.IncomeQuartile ${Ctls_`ctrl'} ///
							if `idsample'_`xsfein'  [pw=projection_factor], vce(cluster household_code) 
						local coef0=round(_b[4.IncomeQuartile]*100)/100
						local nobs0=e(N)

						quietly areg `outcome' ib1.IncomeQuartile ${Ctls_`ctrl'}  ///
							if `idsample'_`xsfein' [pw=projection_factor], absorb(`xsfein'_x_yr) vce(cluster household_code)  
						local coef=round(_b[4.IncomeQuartile]*100)/100
						local nobs=e(N)
						disp "*Q4 vs Q1 gap from = `coef0' to `coef' st dev with `xsfein' fixed effects"
					
					}
				}
			}
		}

}	
	
end

********************************************************************************
********************************************************************************
********************************************************************************

	main
