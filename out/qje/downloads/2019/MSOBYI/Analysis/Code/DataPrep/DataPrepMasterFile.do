/* DataPrepMasterFile.do */
* Does all data prep

/* SETUP */


/* IMPORT KILTS CENTER NIELSEN DATASETS */
include Code/DataPrep/Homescan/ImportHomescan.do 



/* NON-NIELSEN DATASETS */
/* Geographic identifiers */
use $Externals/Data/StateCodes.dta, clear
merge m:1 state_abv using $Externals/Data/Census/CensusDivisionsandRegions.dta, nogen keep(match master) keepusing(division)
** Generate divisions
forvalues d=1/9 {
	gen byte Div_`d' = cond(division==`d',1,0)
}
label var Div_1 "1(New England)"
label var Div_2 "1(Middle Atlantic)"
label var Div_3 "1(East North Central)"
label var Div_4 "1(West North Central)"
label var Div_5 "1(South Atlantic)"
label var Div_6 "1(East South Central)"
label var Div_7 "1(West South Central)"
label var Div_8 "1(Mountain)"
label var Div_9 "1(Pacific)"

compress
save $Externals/Calculations/Geographic/StateCodes.dta, replace

/* Geographic data (e.g. income, education) */
include Code/DataPrep/Geographic/PrepCountyData.do 
include Code/DataPrep/Geographic/PrepCZData.do 
include Code/DataPrep/Geographic/PrepZipCodeData.do
include Code/DataPrep/Geographic/PrepTractData.do


/* CPI and NHTS */
include Code/DataPrep/PrepCPI.do

/* Prep nutrition facts and perishability */
*** Perishability
include Code/DataPrep/NutritionFacts/GetPerishability.do

*** Convenience scores
include Code/DataPrep/NutritionFacts/GetConvenienceScores.do

*** Gladson nutrition facts
include Code/DataPrep/NutritionFacts/PrepGladsonNutritionFacts.do

*** Magnet nutrition facts
include Code/DataPrep/NutritionFacts/PrepUSDANutritionFacts.do

*** Calorie needs 
include Code/DataPrep/NutritionFacts/ImportCalorieNeeds.do 

*** Nutrition facts for HEI
include Code/DataPrep/NutritionFacts/PrepNutritionFactsForHEI.do 


/* UPC-level dataset */
include Code/DataPrep/OtherNielsen/UPCDataPrep.do 


*****************************************************************************
*****************************************************************************


/* HOMESCAN */
** PanelViews survey (from Allcott, Lockwood, and Taubinsky)
	* Original PanelViews data are only on Hunt's computer, so may need to comment this out
	* Prep before HomescanHouseholdDataPrep.do.
include Code/DataPrep/Homescan/PanelViewsDataPrep.do

** Households
include Code/DataPrep/Homescan/PrepHouseholdCensusTracts.do
include Code/DataPrep/Homescan/HomescanHouseholdDataPrep.do

** Magnet
include Code/DataPrep/Homescan/DataPrep_Magnet.do

** Transactions
include Code/DataPrep/Homescan/TransactionDataPrep.do 

** Magnet transactions
include Code/DataPrep/Homescan/TransactionDataPrep_Magnet.do

*****************************************************************************
*****************************************************************************

/* RMS */
include Code/DataPrep/RMS/PrepRMS.do


** Put health measures in all datasets
	* Both Homescan and RMS
include Code/DataPrep/OtherNielsen/InsertHealthMeasures.do 


/* Prep relative prices by zip income category */
	* This must come after PrepRMS, because it uses RMS-Prepped.dta.
*include Code/DataPrep/RMS/PrepZipIncomeCatRelativePrice.do // This is for the price stylized fact figure.

/* Instruments */
include Code/DataProp/RMS/MakeInstruments.do


/* SUPPLY DATA */
include Code/DataPrep/Supply/PrepSupply.do


/* AVERAGE DEMAND */
include Code/DataPrep/RMS/PrepAreaAverageDemand.do 

/* Prep RMS data for decomp*/
include Code/DataPrep/RMS/CollapseMovementStore.do
include Code/DataPrep/RMS/CreateCounterFactualSupply.do



/* ADDITIONAL DATA PREP FOR MODEL FREE ANALYSES */
include Code/DataPrep/PrepEntryRegs.do
include Code/DataPrep/PrepMoverTripShares.do 
include Code/DataPrep/PrepInSampleMoverRegs.do


/* NHTS */
* Needs to come after ZBP data are created in PrepSupply.do
include Code/DataPrep/NHTSDataPrep.do

/* Chetty et al. Jama data */
include Code/DataPrep/PrepChettyJAMA.do 

