/* TransactionDataPrep.do */
* Prepares collapsed Homescan transactions data for demand estimation, entry event study, and descriptive facts.

/* GET HOUSEHOLD-BY-GROUP-BY-t DATASET FOR DEMAND ESTIMATION */
include Code/DataPrep/Homescan/Prep_HHxGroup.do 



/* GET DATASETS FOR REDUCED FORM ESTIMATION */

/* Collapse to household-by-year data */
global Attributes_energy = "$HEINuts rlHEI_per1000Cal" // These are weighted by "energy" (calories from the HEI nutrition facts) in the collapse
global Attributes_cals = "g_fiber_per1000Cal g_prot_per1000Cal g_fat_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal ShareCoke SSB MilkFatPct rHealthIndex_per1000Cal Whole Fruit Veg Storability Convenience StoreTime*" // These are attributes that are weighted by nutrition facts calories in the collapse.
global Attributes = "$Attributes_cals $Attributes_energy"
global ChannelExpendShare = "Yes"
global HEI = "Yes" // This keeps track of what share of calories from HEI are imputed
global FileName = "HHxYear"
global CollapseBy = "household_code panel_year"
include Code/DataPrep/Homescan/CollapseTransactions.do

include Code/DataPrep/Homescan/Prep_HHxYear.do

gen expshare_GSC = expshare_Grocery+expshare_Super+expshare_Club

compress
saveold $Externals/Calculations/Homescan/HHxYear.dta, replace


/*
/* Collapse household-year data to averages by income group */
use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1 // We are taking averages across households and don't want them to be distorted by outliers.
merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
	keepusing(FirstYearInZip zip_code) keep(match master) nogen 
*gen WeightedCalories = Calories*projection_factor
xtile HHAvIncomeGroup = HHAvIncome [aw=projection_factor], nq(10)

** Merge in food desert definitions
*rename FirstYearInZip year
rename panel_year year
merge m:1 zip_code year using $Externals/Calculations/StoreEntryExit/ZipCodeBusinessPatterns.dta, keep(match master) keepusing(est_LargeGroc est_SuperClub) nogen // Only 155 hhxyear observations unmatched from master

gen est_Large = est_LargeGroc+est_SuperClub 
gen expend_GSC_FD = expend_Grocery+expend_Super+expend_Club if est_Large==0
gen expend_FD = expend if est_Large==0

collapse (rawsum) projection_factor (sum) expend_* expend (mean) HHAvIncome [pw=projection_factor],by(HHAvIncomeGroup) fast //  $Attributes
*collapse (rawsum) projection_factor (sum) expend_* expend (mean) $Attributes [pw=WeightedCalories],by(HHAvIncomeGroup) fast

** Expenditure shares
foreach var in Grocery ChainGroc Mass Club Super DrugConv Other { //  Entrant WalTar
	gen expshare_`var' = expend_`var' / expend
}
gen expshare_GSC_FD = expend_GSC_FD / expend_FD

gen expshare_SuperClub = expshare_Super+expshare_Club
gen expshare_GSC = expshare_Grocery+expshare_SuperClub


** Produce variable
* gen FreshProduce = FreshFruit+FreshVeg
*gen Produce = Fruit+Veg

saveold $Externals/Calculations/Homescan/HHAvIncome.dta, replace
*/

/* Collapse to household-by-year-by-store data */
global Attributes_energy = "rlHEI_per1000Cal $HEINuts"
global Attributes_cals = "g_fiber_per1000Cal g_fat_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal Fruit Veg rHealthIndex_per1000Cal"
global Attributes = "$Attributes_cals $Attributes_energy"
global ChannelExpendShare = "No"
global HEI = "Yes"
global FileName = "HHxYearxStore"
global CollapseBy = "household_code panel_year store_code_uc retailer_code"
include Code/DataPrep/Homescan/CollapseTransactions.do


/* Household-by-store-by-quarter expenditure shares 
global Attributes = "rHealthIndex_per1000Cal"
global ChannelExpendShare = "No"
global HEI = "No"
global FileName = "HHxQuarterxStore"
global CollapseBy = "household_code YQ store_code_uc"
include Code/DataPrep/Homescan/CollapseTransactions.do

* Construct expenditure share
bysort household_code YQ: egen TotalExpend = total(expend)
gen expshare = expend/TotalExpend
compress
saveold $Externals/Calculations/Homescan/HHxQuarterxStore.dta, replace
*/

/* Household-by-retailer-by-quarter expenditure shares */
global Attributes_energy = "rlHEI_per1000Cal"
global Attributes_cals = "rHealthIndex_per1000Cal"
global Attributes = "$Attributes_cals $Attributes_energy"
global ChannelExpendShare = "No"
global HEI = "No"
global FileName = "HHxQuarterxRetailer"
global CollapseBy = "household_code YQ retailer_code"
include Code/DataPrep/Homescan/CollapseTransactions.do
rename retailer_code retailer_code_uc // Needed for part of merge code in PrepEntryRegs.do
* Construct expenditure share
bysort household_code YQ: egen TotalExpend = total(expend)
gen expshare = expend/TotalExpend
compress
saveold $Externals/Calculations/Homescan/HHxQuarterxRetailer.dta, replace


/* Collapse to household-by-quarter data */
global Attributes_energy = "$HEINuts rlHEI_per1000Cal"
global Attributes_cals = "g_fiber_per1000Cal g_fat_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal Fruit Veg rHealthIndex_per1000Cal"
global Attributes = "$Attributes_cals $Attributes_energy"
global ChannelExpendShare = "Yes"
global HEI = "Yes"
global FileName = "HHxQuarter"
global CollapseBy = "household_code YQ"

include Code/DataPrep/Homescan/CollapseTransactions.do

/*
gen panel_year = year(dofq(YQ))
merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
	keepusing(projection_factor Income lnIncome TractMedIncome TractlnMedIncome) ///
	keep(match master) nogen 

saveold $Externals/Calculations/Homescan/HHxQuarter.dta, replace
*/



