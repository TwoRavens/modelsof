/* StylizedFacts.do */


/* HEALTH MAPS */
include Code/Analysis/StylizedFacts/HealthMaps.do
include Code/Analysis/StylizedFacts/HealthVarGeographicCorrelations.do



/* First get income distribution statistics */
** Output 25th and 75th percentiles
foreach pctile in 25 75 {
	use $Externals/Calculations/Homescan/Prepped-Household-Panel.dta,clear
	sum HHAvIncome [aw=projection_factor],detail
	clear
	set obs 1
	gen var = round(r(p`pctile')*1000,1000)
	format var %12.0fc 
	tostring var, replace force u
	outfile var using "Output/NumbersForText/Incomep`pctile'.tex", replace noquote
}


/* GRAPHS: HEALTHFULNESS AND EXPENDITURES BY INCOME LEVEL */
global Fig = "Output/StylizedFacts/Figures"
*global MacroNutrientList="g_fiber_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal"
global NQuantiles = 15


/* Healthfulness across the income distribution */
** Interquartile ranges for text
foreach var in added_sugars $HealthVar { // HealthIndex_per1000Cal Produce g_sugar_per1000Cal
	use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
	reg `var' ib1.IncomeQuartile $SESCtls i.panel_year [pw=projection_factor], robust cluster(household_code)

	local `var'QDiff = _b[4.IncomeQuartile]
	clear
	set obs 1
	if "`var'" == "HealthIndex_per1000Cal"|"`var'"=="lHEI_per1000Cal"|"`var'"=="HEI_per1000Cal" {
		local format = 2
		local outputstring = "HealthVar"
	}
	else if "`var'" == "added_sugars" {
		local `var'QDiff = -1 * ``var'QDiff'
		local format = 1
		local outputstring = "sugar"
	}
	else {
		local format = 1
	}
	gen var = ``var'QDiff'
	format var %12.`format'fc 
	tostring var, replace force u
	outfile var using "Output/NumbersForText/`outputstring'QDiff.tex", replace noquote
	
	** Store this difference for benchmarking in reduced form analyses.
	if "`var'" == "$HealthVar" {
		global HealthVarQDiff = ``var'QDiff'
	}
}


** Health impacts predicted from correlational analysis
* X fewer grams of sugar / 1000 calories = X*4/1000 percent of calories, given 4 calories per gram sugar
* In Table 3, Yang et al. show that going from heavy sugar to light sugar (28.7% to 5.0%, a reduction of 23.7%) reduces fully adjusted hazard ratio from 2.75 to 1, or 175%. So we report -1 * ((X * 4/1000)/23.7%)*175% = tk percent reduction.
clear
set obs 1
display `added_sugarsQDiff'
gen var = round( (`added_sugarsQDiff'*4/1000)/0.237 *1.75 * 100,1)
format var %12.0fc 
tostring var, replace force u
outfile var using "Output/NumbersForText/SugarHealthImpact.tex", replace noquote

* Alternatives:
* Chen et al. (2009) imply that 3.1 fewer grams of sugar per 1000 calories is conditionally correlated with 0.29 pounds weight loss over 18 months. 
* Chen et al. find that a reduction of SSB intake of one serving per day was associated with weight loss of 0.65 kg at 18 months. One serving/day is 38 grams sugar, and assume 2500 calories per day. So 3.5 grams per 1000 calories is 3.5*(2500/1000)/38 = 0.2303 servings per day. Multiplying by 0.65 gives 0.149 kg, or 0.33 pounds.

** Make figures
use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
foreach outcome in added_sugars Whole Produce $HealthVar $HEINuts { // $MacroNutrientList HealthIndex
	include Code/Analysis/StylizedFacts/FigureTitles.do
	if strpos("$HEINuts","`outcome'")!=0 & "`outcome'"!="added_sugars" {
		*local quantiles = 15
		local ylabel = "ylabel(#2)"
	}
	else {
		*local quantiles = $NQuantiles
		local ylabel = ""
		
	}
	binscatter `outcome' HHAvIncome [aw=projection_factor], ///
		line(none) controls($SESCtls i.panel_year) ///
		graphregion(color(white)) nquantiles($NQuantiles) `ylabel' ///
		xtitle("Household income ($000s)") ytitle("`ytitle'") /// xlabel(0(25)125) xscale(range(0 125)) ///
		title("`title'")
		
	graph save $Fig/`outcome'_Income, replace
	
}

** Combine for main figure
graph combine $Fig/added_sugars_Income.gph ///
	 $Fig/Whole_Income.gph ///
	  $Fig/Produce_Income.gph ///
	   $Fig/${HealthVar}_Income.gph, ///
	   	graphregion(color(white)) ///
		xcommon rows(2) cols(2) 

graph export $Fig/Healthfulness_Income.pdf, as(pdf) replace

/*
** Combine for Appendix: Individual macronutrients
graph combine $Fig/g_fiber_per1000Cal_Income.gph ///
	  $Fig/g_fat_sat_per1000Cal_Income.gph ///
	   $Fig/g_sugar_per1000Cal_Income.gph ///
	   $Fig/g_sodium_per1000Cal_Income.gph ///
	   $Fig/g_cholest_per1000Cal_Income.gph, ///
	   	graphregion(color(white) lwidth(medium)) ///
		rows(2) cols(3) xcommon 
		
		graph export $Fig/MacroNutrients_Income.pdf, as(pdf) replace
*/
** Combine for Appendix: Individual HEI nutrients
graph combine $Fig/fruits_total_per1000Cal_Income.gph /// $Fig/lHEI_per1000Cal_Income.gph ///
		$Fig/fruits_whole_per1000Cal_Income.gph ///
		$Fig/veggies_per1000Cal_Income.gph ///
		$Fig/greens_beans_per1000Cal_Income.gph ///
		$Fig/whole_grains_per1000Cal_Income.gph /// 
		$Fig/dairy_per1000Cal_Income.gph ///
		$Fig/total_protein_per1000Cal_Income.gph ///
		$Fig/sea_plant_prot_per1000Cal_Income.gph ///
		$Fig/mon_unsat_fat_g_per1000Cal_Income.gph ///
		$Fig/poly_unsat_fat_g_per1000Cal_Income.gph ///
		$Fig/refined_grains_per1000Cal_Income.gph ///
		$Fig/sodium_mg_per1000Cal_Income.gph ///
		$Fig/added_sugars_per1000Cal_Income.gph ///
		$Fig/satfat_g_per1000Cal_Income.gph ///
		$Fig/solid_fats_kcal_per1000Cal_Income.gph, ///
	   	graphregion(color(white) lwidth(medium)) ///
		rows(4) cols(4) xcommon // altshrink
		
		graph export $Fig/MacroNutrients_Income.pdf, as(pdf) replace

*** Health Index only graph
	binscatter $HealthVar HHAvIncome [aw=projection_factor], ///
		line(none) controls($SESCtls i.panel_year) ///
		graphregion(color(white)) nquantiles($NQuantiles) ////
		xtitle("Household income ($000s)") ytitle("Healthfulness of grocery purchases (standard deviations)") // xlabel(0(25)125) xscale(range(0 125)) //
graph export $Fig/HealthVar_Income.pdf, as(pdf) replace


/*
** Test unconditional correlations in microdata
use $Externals/Calculations/Homescan/HHxYear.dta, clear
foreach YVar in $MacroNutrientList { 
	* Unconditional correlation
	reg `YVar' lnIncome [aw=projection_factor], cluster(household_code)
}
** Excluding the poorest households 
	* The very poorest households eat less cholesterol, sodium, and saturated fat.
	* Excluding them gives the unambiguous result that households (richer than $10,000 income) eat more healthfully if they are richer. 
reg g_sodium_per1000Cal lnIncome [aw=projection_factor], cluster(household_code), if Income>10000
reg g_cholest_per1000Cal lnIncome [aw=projection_factor], cluster(household_code), if Income>10000
reg g_fat_sat_per1000Cal lnIncome [aw=projection_factor], cluster(household_code), if Income>10000
*/


/* Magnet */
use $Externals/Calculations/Homescan/HHxYear_Magnet.dta, replace

** Make figures
foreach outcome in added_sugars Whole Produce $HealthVar { // $MacroNutrientList SSB Whole. SSB and whole get pretty noisy and not believable in this small sample, so we exclude.
	include Code/Analysis/StylizedFacts/FigureTitles.do

	binscatter `outcome' HHAvIncome [aw=projection_factor], ///
		line(none) controls($SESCtls i.panel_year) ///
		graphregion(color(white)) nquantiles(8) ///
		xtitle("Household income ($000s)") ytitle("`ytitle'") /// xlabel(0(25)125) xscale(range(0 125)) ///
		title("`title'")
		graph save $Fig/`outcome'_Income_Magnet, replace
}
** Combine for main figure
graph combine  $Fig/added_sugars_Income_Magnet.gph ///
	 $Fig/Whole_Income_Magnet.gph ///
	 $Fig/Produce_Income_Magnet.gph ///
	 $Fig/${HealthVar}_Income_Magnet.gph, ///
	   	graphregion(color(white) lwidth(medium)) ///
		rows(2) cols(2) xcommon 
graph export $Fig/Healthfulness_Income_Magnet.pdf, as(pdf) replace

		

/* TIME TRENDS IN HEALTHFULNESS */
use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1

gen YearGroup = ""
replace YearGroup = "2004-2007" if panel_year<=2007
replace YearGroup = "2008-2011" if panel_year>=2008&panel_year<=2011
replace YearGroup = "2012-2016" if panel_year>=2012&panel_year<=2016
encode YearGroup, gen(YearGroupNum)
/*
Exclude this figure
foreach outcome in $HealthVar { // Produce g_fiber_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal { // SSB Whole 
	** Levels by year
	include Code/Analysis/StylizedFacts/FigureTitles.do
	
	
	**
	if "`outcome'" != "HealthIndex" & "`outcome'" != "lHEI" {
		local legend = "off"
	}
	else {
		local legend = `"label(1 "2004-2007") label(2 "2008-2011") label(3 "2012-2016")"'
		local title = ""
	}
	
	binscatter `outcome' HHAvIncome [aw=projection_factor], ///
		line(connect) controls($SESCtls) ///
		graphregion(color(white)) nquantiles($NQuantiles) ///
		xtitle("Household income ($000s)") ytitle("`ytitle'") /// xlabel(0(25)125) xscale(range(0 125)) ///
		title("`title'") by(YearGroup) /// legend(`legend') ///
		colors(ltblue navy dknavy) // lc(ltblue navy dknavy)

		graph save $Fig/`outcome'_IncomexYear, replace
		if "`outcome'" == "$HealthVar" {	
			graph export $Fig/HealthVar_IncomexYear.pdf, as(pdf) replace		
		}
}

*/


foreach YearGroup in Early Late {
		if "`YearGroup'" == "Early" {
			use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1 & panel_year<=2007
		}
		if "`YearGroup'" == "Late" {
			use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1 & panel_year>=2012
		} 
		reg $HealthVar ib1.IncomeQuartile $SESCtls i.panel_year, robust cluster(household_code)
		local QDiff = _b[4.IncomeQuartile]
		clear
		set obs 1
		gen var = `QDiff'
		format var %12.2fc 
		tostring var, replace force u
		outfile var using "Output/NumbersForText/HealthVarQDiff_`YearGroup'.tex", replace noquote
}
	
	
	

***************************************************
include Code/Analysis/StylizedFacts/SupermarketExpenditureShares.do
	
***************************************************

/* Within-household income variation */
include Code/Analysis/StylizedFacts/WithinHouseholdIncomeRegs.do 	


****************************************************************


/* SUPPLY STYLIZED FACTS */
*include Code/Analysis/StylizedFacts/PriceStylizedFacts.do 
include Code/Analysis/StylizedFacts/SupplyStylizedFacts.do 
	



/* Purchases at unhealthful store types are tk units less healthful 
	use $Externals/Calculations/Homescan/Transactions/Transactions_2012.dta, clear
	
	** Merge UPC info
	merge m:1 upc upc_ver_uc using $Externals/Calculations/OtherNielsen/Prepped-UPCs.dta, keep(match master) nogen ///
		keepusing(rHealthIndex_per1000Cal department_code product_group_code product_module_code cals_per1) // Grams	
	gen cals_perRow=cals_per1*quantity // Get total for the row.
	drop cals_per1	
	
	** Drop magnet transactions because this is the entire panel and the magnet transactions will have the wrong weights.
		* Drop if missing a product_group_code; most of these are non-food or difficult to classify.
	drop if department_code==99 | (product_module_code>=445&product_module_code<=468) ///
		| product_group_code==. 
	drop department_code product_module_code		
	
	*** Get expenditures by channel type
	** Merge channel_type
	merge m:1 retailer_code using $Externals/Calculations/OtherNielsen/Retailers.dta, keepusing(C_Grocery C_Club C_Super) nogen keep(match master)

	gen C_GSC = C_Grocery + C_Club + C_Super
	gen expend_GSC = cond(C_GSC==1,expend,0)
	
	collapse (rawsum) expend (mean) rHealthIndex_per1000Cal [pw=cals_perRow],by(C_GSC) fast
	
browse
* HealthIndex = .1278578 for C_GSC==1 and -0.2495553 for C_GSC==0
display rHealthIndex[2]-rHealthIndex[1] // then need to normalize by the within-year standard deviation in HHxYear.dta.

*/


****************************************************************

/* NHTS ANALYSIS */
include Code/Analysis/StylizedFacts/NHTSAnalysis.do 


