/* PrepRMS.do */
* This file prepares the RMS data.
* There are two sources of RMS store data:
	* Kilts release
	* $Externals/Data/RMS/Stores.dta. This is from /home/data/Nielsen-Data/RMS/Stata_Files/Stores.dta. This is the EXACT SAME as the Kilts release except has 5-digit zips and also parent_org names. 



/* SETUP */
/* Collapse movement data */
include Code/DataPrep/CollapseMovementData.do 
* include Code/DataPrep/CollapseMovementDatabyZipYear.do 

/* Get national price and sales list */
include Code/DataPrep/RMS/GetNationalPriceandSalesList.do 


/* Collapse RMS to the store level */
include Code/DataPrep/RMS/GetRMS_by_store_code.do // Often run on JPLinux, as takes time to run.

/* Get prepped store-by-year data */
include Code/DataPrep/RMS/PrepStores.do


/* Finish RMS preparation */
use $Externals/Calculations/RMS/RMS_by_store_code.dta, replace
drop if store_code_uc == . 

merge m:1 store_code_uc year using $Externals/Calculations/RMS/Stores-Prepped.dta, nogen keep(match master) 
drop if channel_code=="L" // drop liquor stores.


** Get our coding of channel
merge m:1 retailer_code using $Externals/Calculations/OtherNielsen/Retailers.dta, nogen ///
	keepusing(C_Grocery C_ChainGroc C_NonChainGroc C_Super C_SuperClub C_OtherMass C_DrugConv C_Drug channel) keep(match master)
foreach var of varlist C_* {
	replace `var' = 0 if `var'==.
}



** About 20% of retailer_codes are missing from Retailers.dta. In these cases, get channel from the stores files.
	* Note that in a few cases, Stores-Prepped.dta conflicts with the channel types in HMS. In that case, use HMS. Thus create this C_Unknown variable and only change a C_ variable if originally C_Unknown==1
	* Note that in a few other cases, there are retailer_codes that I code as non-chain grocery that have a parent_code of a large chain.

gen C_Unknown = cond(C_Grocery==0 & C_SuperClub==0 & C_OtherMass==0 & C_DrugConv==0,1,0) // These are if there is no retailer code assignment from the retailers file.
	
replace C_DrugConv=1 if C_Unknown==1&(channel==1|channel==2) // 1 is convenience, 2 is drug
replace C_Drug=1 if C_Unknown==1&channel==2
replace C_SuperClub = 1 if C_Unknown==1&channel==5&(parent_code==6901|parent_code==6904)&NProduce>=300 // There are a few Targets and KMarts in the data with lots of produce. These appear to be be supercenters. The rest are not. KMart is 62. There is a discrete jump above 300 Produce UPCs to close to 1000, suggesting a distinct difference between the super and non-super.
replace C_Super = 1 if C_Unknown==1&channel==5&(parent_code==6901|parent_code==6904)&NProduce>=300 // There are a few Targets and KMarts in the data with lots of produce. These appear to be be supercenters. The rest are not.
replace C_OtherMass = 1 if C_Unknown==1&channel==5&(NProduce<300|parent_code==6918) // One Alco has more than 300 produce UPCs, but this is not a supercenter
replace C_Grocery = 1 if C_Unknown==1&channel==3
replace C_ChainGroc = 1 if C_Grocery==1&C_NonChainGroc==0&C_ChainGroc==0 // Some have missing retailer codes, but the parent names are all large parents

** All channels should be known now
gen C_Unknown1 = cond(C_Grocery==0 & C_SuperClub==0 & C_OtherMass==0 & C_DrugConv==0,1,0)
assert C_Unknown1==0 // Now all have known channel
drop C_Unknown C_Unknown1 


** Small vs. large grocery
gen byte C_LargeGroc = cond(C_Grocery==1&Revenue>=5000000&Revenue!=.,1,0)
gen byte C_SmallGroc = cond(C_Grocery==1&Revenue<5000000&Revenue!=.,1,0)
label var C_LargeGroc "1(Large grocery)"
label var C_SmallGroc "1(Small grocery)"

gen byte C_Conv = C_DrugConv-C_Drug
label var C_Conv "1(Convenience store)"


** Get zip code data
merge m:1 zip_code using $Externals/Calculations/Geographic/Z_Data.dta, nogen keep(match master) keepusing(ZipMedIncomeGroup Z_lnIncome)

gen lnNProduce = ln(NProduce+1)
gen lnNUPCs = ln(NUPCs)
gen lnRevenue = ln(Revenue)
label var lnRevenue "ln(Annual revenue)"

compress
saveold $Externals/Calculations/RMS/RMS-Prepped.dta, replace


