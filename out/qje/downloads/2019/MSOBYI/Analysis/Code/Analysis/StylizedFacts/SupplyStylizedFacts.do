/* SupplyStylizedFacts.do */		
/* RMS DATA */


/* GRAPHS: STORE AVERAGE HEALTHFULNESS AND SIZE BY ZIP CODE MEDIAN INCOME */
global Fig = "Output/StylizedFacts/Figures"

use $Externals/Calculations/RMS/RMS-Prepped.dta, replace

** First get averages to report in text
gen Z_Income = exp(Z_lnIncome)
sum Revenue NUPCs if Z_Income<=25000
sum Revenue NUPCs if Z_Income>=70000
drop if ZipMedIncomeGroup==.

** Collapse to zip income group averages
gen Produce = Fruit + Veg
replace Revenue = Revenue/1000000

*drop if C_Discount==1&C_SuperClub==0 // Drop discount stores that are not Super/Club, to match the NAICS code 452112
collapse (mean) added_sugars Whole Produce lHEI, /// [fw=NUPCs] g_sugar_per1000Cal
	by(ZipMedIncomeGroup)


	
/* Case study graphs: sugar, whole grain, produce, and HEI */
foreach outcome in added_sugars Whole Produce $HealthVar { //SSB HealthIndex_per1000Cal Revenue NUPCs g_fiber_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal {
	include Code/Analysis/StylizedFacts/FigureTitles.do

	**
	twoway (scatter `outcome' ZipMedIncomeGroup), ///
		graphregion(color(white) lwidth(medium)) ///
		xtitle("Zip median income ($000s)") ytitle("`ytitle'") ///
		title("`title'")
	graph save $Fig/`outcome'_ZipIncome, replace
}



** Combine and output
graph combine $Fig/added_sugars_ZipIncome.gph ///
	 $Fig/Whole_ZipIncome.gph /// 	 $Fig/Revenue_ZipIncome.gph ///
	  $Fig/Produce_ZipIncome.gph ///
	  $Fig/${HealthVar}_ZipIncome.gph, /// $Fig/NUPCs_ZipIncome.gph, ///
	   	graphregion(color(white) lwidth(medium)) ///
		rows(2) cols(2) xcommon 
		
		graph export $Fig/Healthfulness_ZipIncome.pdf, as(pdf) replace

		/*
** Appendix graphs: Individual macronutrients 
graph combine $Fig/g_fiber_per1000Cal_ZipIncome.gph ///
	  $Fig/g_fat_sat_per1000Cal_ZipIncome.gph ///
	   $Fig/g_sugar_per1000Cal_ZipIncome.gph ///
	   $Fig/g_sodium_per1000Cal_ZipIncome.gph ///
	   $Fig/g_cholest_per1000Cal_ZipIncome.gph, ///
	   	graphregion(color(white) lwidth(medium)) ///
		rows(2) cols(3) xcommon 
		
		graph export $Fig/MacroNutrients_ZipIncome.pdf, as(pdf) replace

*/
		
		

/* REGRESSIONS: CONDITION AND FIT */
use $Externals/Calculations/RMS/RMS-Prepped.dta, replace

replace NProduce = NProduce/1000
foreach YVar in NProduce  { // $HealthVar
	reg `YVar' Z_lnIncome, cluster(zip_code)
		est store S1`YVar'
	reg `YVar' Z_lnIncome lnRevenue, cluster(zip_code)
	est store S2`YVar'
		* Note: there are a few club stores in 2013, so use C_SuperClub instead of just C_Super. Drug store is omitted category.
	reg `YVar' Z_lnIncome C_LargeGroc C_SmallGroc C_SuperClub C_Conv C_Drug, cluster(zip_code) // C_OtherMass
		est store S3`YVar'
}
		
		esttab S?NProduce /* S?$HealthVar */ using "Output/StylizedFacts/RMSHealthfulness.tex", replace /// S?NProduce
			b(%8.3f) se(%8.3f) /// 
				keep(Z_lnIncome lnRevenue C_*) order(Z_lnIncome lnRevenue C_*) ///
				nomtitles /// mgroups("\underline{Thousands of produce UPCs offered}" "\underline{Mean Health Index of UPCs offered}"}, pattern(1 0 0 1 0 0) span prefix(\multicolumn{@span}{c}{)suffix(})) /// 
				stats(N r2, l("Observations" "R$^2$") fmt(%12.0fc %8.2f)) ///  UB "95% confidence interval upper bound"  %8.3f
				star(* 0.10 ** 0.05 *** 0.01) label nonotes nogaps


			

/* Robustness checks */
* Only store channel types
reg NProduce C_LargeGroc C_SmallGroc C_Super C_Conv C_OtherMass, cluster(zip_code)
reg HealthIndex_per1000Cal C_LargeGroc C_SmallGroc C_Super C_Conv C_OtherMass, cluster(zip_code)

* check if controlling for NUPCs does more than lnRevenue (it doesn't).
reg HealthIndex_per1000Cal Z_lnIncome Div_? C_LargeGroc C_SmallGroc C_SuperClub C_DrugConv C_OtherMass lnRevenue lnNUPCs, cluster(zip_code)

* How much of this is within vs. between retailer codes? (Same coefficient within)
areg HealthIndex_per1000Cal Z_lnIncome Div_? lnRevenue, cluster(zip_code) absorb(retailer_code)

* Chain vs. Non-Chain grocery similar although slightly different. Non-Chain groceries are relatively worse than small groceries actually, in terms of HealthIndex and NProduce!
	* But RMS really doesn't have any non-chain grocers (there is only one or two non-chain grocery stores in this regression, and they are probably misclassified.
reg HealthIndex_per1000Cal Z_lnIncome Div_? C_Grocery C_NonChainGroc C_SuperClub C_DrugConv C_OtherMass, cluster(zip_code) nocons
reg HealthIndex_per1000Cal Z_lnIncome Div_? C_Grocery C_SmallGroc C_SuperClub C_DrugConv C_OtherMass, cluster(zip_code) nocons

reg NProduce Z_lnIncome Div_? C_Grocery C_NonChainGroc C_SuperClub C_DrugConv C_OtherMass, cluster(zip_code) nocons
reg NProduce Z_lnIncome Div_? C_Grocery C_SmallGroc C_SuperClub C_DrugConv C_OtherMass, cluster(zip_code) nocons

* Drug vs. Conv
	* drug is somewhat better on both dimensions, but drug/convenience are more similar to each other than to other channels
reg NProduce Z_lnIncome Div_? C_LargeGroc C_SmallGroc C_SuperClub C_DrugConv C_Drug C_OtherMass, cluster(zip_code) nocons
reg HealthIndex_per1000Cal Z_lnIncome Div_? C_LargeGroc C_SmallGroc C_SuperClub C_DrugConv C_Drug C_OtherMass, cluster(zip_code) nocons

* Supercenter vs. SuperClub combined
	* Note that we can't do this because we don't have any club stores in the RMS data.
*reg HealthIndex_per1000Cal lnZipMedIncome Div_? C_LargeGroc C_SmallGroc C_SuperClub C_Super C_DrugConv C_OtherMass lnRevenue, cluster(zip_code)
*reg NProduce lnZipMedIncome Div_? C_LargeGroc C_SmallGroc C_SuperClub C_Super C_DrugConv C_OtherMass lnRevenue, cluster(zip_code)





/* ZIP CODE BUSINESS PATTERNS DATA */
* Store counts by zip income
global ZBPChannels = "Supermarkets DrugConv" // "SmallGroc LargeGroc SuperClub Drug Conv Spec"
/* Population-normalized */
use year zip_code est_SmallGroc est_LargeGroc est_SuperClub est_Conv est_Drug est_Spec using $Externals/Calculations/StoreEntryExit/ZipCodeBusinessPatterns.dta, replace, if year>=2004&year<=$MaxYear
merge m:1 zip_code using $Externals/Calculations/Geographic/Z_Data.dta, keep(match using) keepusing(Z_Income Z_lnIncome ZipMedIncomeGroup ZipPop) // Note that there are zips in ZBP that are not ZCTAs. However, only 1/100 approx of stores are in these zips. We could get geocoding for these, but if they are PO boxes then they may be geocoded incorrectly anyway.
drop if Z_Income==.
gen est_Supermarkets = est_LargeGroc+est_SuperClub // Count of large grocery retailers
gen est_DrugConvSmall = est_Drug+est_Conv+est_SmallGroc

	/* Aside: what share of Americans live in food deserts? */
	sum ZipPop
	display r(sum)
	local sum=r(sum)
	sum ZipPop if est_LargeGroc==0&est_SuperClub==0
	display r(sum)
	display r(sum)/`sum'
	
	sum ZipPop if Z_Income<=25000
	display r(sum)
	local sum=r(sum)
	sum ZipPop if Z_Income<=25000&est_LargeGroc==0&est_SuperClub==0
	display r(sum)
	display r(sum)/`sum'
	

* Some zips from ZipCodeData.dta have no establishments (Hunt checked on google maps and these tend to be very rural zips).
foreach channel in $ZBPChannels {
	gen est_Pop_`channel' = cond(est_`channel'!=.,est_`channel'/ZipPop*1000,0)
}


collapse (mean) est_Pop* [pw=ZipPop],by(ZipMedIncomeGroup)

foreach channel in $ZBPChannels {
	** Set titles
	local title = "`channel'"
	if "`channel'" == "LargeGroc" {
		local title="Large Grocery"
	}
	if "`channel'" == "SmallGroc" {
		local title="Small Grocery"
	}
	if "`channel'" == "SuperClub" {
		local title="Supercenters/Clubs"
	}
	if "`channel'" == "Drug" {
		local title="Drug"
	}
	if "`channel'" == "DrugConv" {
		local title="Drug and convenience"
	}
	if "`channel'" == "Conv" {
		local title="Convenience"
	}
	if "`channel'" == "Spec" {
		local title="Meat/Fish/Produce"
	}
	if "`channel'" == "Supermarkets" {
		local title="Supercenter, club, and large grocery"
	}
	if "`channel'" == "DrugConvSmall" {
		local title="Drug/convenience/small grocery"
	}
	**
	twoway (scatter est_Pop_`channel' ZipMedIncomeGroup), ///
		graphregion(color(white) lwidth(medium)) ///
		xtitle("Zip median income ($000s)") ytitle("Zip code store count per 1,000 residents") /// ytitle("Zip stores per 1000 residents")
		title("`title'")
	graph save $Fig/`channel'_ZipIncome, replace
}

graph combine $Fig/Supermarkets_ZipIncome.gph ///
	$Fig/DrugConv_ZipIncome.gph, ///
	rows(1) cols(2) xcommon ///
	/* $Fig/LargeGroc_ZipIncome.gph ///
	 $Fig/SuperClub_ZipIncome.gph ///
	  $Fig/Spec_ZipIncome.gph /// 
	  $Fig/SmallGroc_ZipIncome.gph /// 
	  $Fig/Drug_ZipIncome.gph ///
	  	  $Fig/Conv_ZipIncome.gph, rows(2) cols(3) xcommon  */ /// 
		graphregion(color(white) lwidth(medium)) ///
		
		
		graph export $Fig/ChannelStores_ZipIncome.pdf, as(pdf) replace

/*
** Make simplified graph
graph combine   $Fig/LargeGroc_ZipIncome.gph ///
	  	  $Fig/Conv_ZipIncome.gph, ///
		graphregion(color(white) lwidth(medium)) ///
		rows(1) cols(2) xcommon 
		
graph export $Fig/GrocConvStores_ZipIncome.pdf, as(pdf) replace
*/


*** Individual graphs
foreach channel in Supermarkets DrugConv  {
	twoway (scatter est_Pop_`channel' ZipMedIncomeGroup), ///
		graphregion(color(white) lwidth(medium)) ///
		xtitle("Zip median income ($000s)") ytitle("Zip stores per 10k residents") //
	graph export $Fig/`channel'_ZipIncome.pdf, as(pdf) replace	
}
		



