*************************
*************************
**********REPLICATION FILE: DATASET PREPARATION (For use in STATA)
**********Militarism and Dual-Conflict Capacity
**********Carla Martinez Machain and Matthew Wilson
**********October 2016
*************************
*************************

*****NOTE: The Binary Time-Series Cross Section (BTSCS) analysis utility is required; see https://www.prio.org/Data/Stata-Tools/

*************************
*****Set-up
*************************
clear
set more off

*************************
*****Dataset preparation
*************************
**keep select variables from QoG dataset
capture use "C:\Users\mwilson\Dropbox\Research\Manuscripts\Papers Ready for Review\Machain_Militarism and Dual-conflict Capacity\Data\QoG.dta", clear

keep ccodecow year ucdp_type2 ucdp_type3 gle_gdp gle_pop fe_etfra ht_region chga_hinst
	rename ccodecow ccode
	sort ccode year

**remove duplicates
	duplicates tag ccode year, gen(dup)
	drop if dup>0 & gle_pop==.
	drop dup
save "C:\Users\mwilson\Dropbox\Research\Manuscripts\Papers Ready for Review\Machain_Militarism and Dual-conflict Capacity\Data\QoG2.dta", replace

**merge Geddes, Wright, and Frantz regime types
capture use "C:\Users\mwilson\Dropbox\Research\Manuscripts\Papers Ready for Review\Machain_Militarism and Dual-conflict Capacity\Data\MasterDataset2.dta", clear

keep ccode year gwf_personal gwf_military gwf_casename
	sort ccode year
	capture drop _merge
	merge 1:1 ccode year using "C:\Users\mwilson\Dropbox\Research\Manuscripts\Papers Ready for Review\Machain_Militarism and Dual-conflict Capacity\Data\QoG2.dta"
	drop _merge
save "C:\Users\mwilson\Dropbox\Research\Manuscripts\Papers Ready for Review\Machain_Militarism and Dual-conflict Capacity\Data\II_Dataset.dta", replace
rm 	"C:\Users\mwilson\Dropbox\Research\Manuscripts\Papers Ready for Review\Machain_Militarism and Dual-conflict Capacity\Data\QoG2.dta"

**merge with Powell and Thyne (2011) dataset
	sort ccode year
	merge 1:1 ccode year using "C:\Users\mwilson\Dropbox\Research\Manuscripts\Papers Ready for Review\Machain_Militarism and Dual-conflict Capacity\Data\PT.dta"
	drop if _merge==2
	drop _merge
save "C:\Users\mwilson\Dropbox\Research\Manuscripts\Papers Ready for Review\Machain_Militarism and Dual-conflict Capacity\Data\II_Dataset.dta", replace

**time set the data
tsset ccode year

**generate a count of peace years since last conflict
	**internal
gen internal=ucdp_type3
	replace internal=1 if internal!=0 & internal!=.
btscs internal year ccode, gen(intpeace)
	**external
gen external=ucdp_type2
	replace external=1 if external!=0 & external!=.
btscs external year ccode, gen(extpeace)

**create logged values of GDP per capita and population
gen loggdp=log(gle_gdp)
gen logpop=log(gle_pop)

**create region dummies
tab ht_region, gen(region)

**create internal conflict x military interaction
gen interaction_dummy=gwf_military*internal
gen interaction_ord=gwf_military*ucdp_type3

**create external conflict x military interaction
gen interaction_dummy_ext=external*gwf_military

order ccode year gwf_casename gwf_military gwf_personal internal intpeace external extpeace ucdp_type2 ucdp_type3 interaction_dummy interaction_ord interaction_dummy_ext fe_etfra gle_gdp gle_pop loggdp logpop ht_region region1 region2 region3 region4 region5 region6 region7 region8 region9 region10
save "C:\Users\mwilson\Dropbox\Research\Manuscripts\Papers Ready for Review\Machain_Militarism and Dual-conflict Capacity\Data\II_Dataset.dta", replace
*************************
*************************
**********END OF DO FILE
