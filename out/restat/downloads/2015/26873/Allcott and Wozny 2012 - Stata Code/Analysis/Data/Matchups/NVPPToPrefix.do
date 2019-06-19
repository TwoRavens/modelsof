/*************************************************************************
* NVPPToPrefix.do
* Create file to match NVPP to Prefix file.
* Specifically, this gives one unique CarID for every row in the PolkRegistrations.dta dataset.
*************************************************************************/

insheet using Data/Matchups/NVPP_0703_0708_VINMatch.csv, comma names clear double
drop id reg*
rename vinkey MatchVin810
replace MatchVin810 = MatchVin810 + "*******"


** Clean names, as is done with PolkDataPrep.do
include Data/Quantities/CleanPolkNames.do

/* Drop rows that are complete duplicates */
duplicates drop MatchVin810 Make Model Trim ModelYear Cylinders Liters FuelType BodyStyle Drive Ind, force

** Examine other rows that have multiple VINs but otherwise duplicates, but do not drop. There are many of these.
drop if ModelYear>=2009 | ModelYear<1983
duplicates tag Make Model ModelYear Trim Cylinders Liters FuelType BodyStyle Drive, gen(dup)
tab dup
*assert dup==0
drop dup

/* Merge in the CarID using MatchVin8*10 */
sort MatchVin810
merge MatchVin810 using Data/Matchups/Prefix810, nokeep keep(CarID) uniqusing
tab _merge
tab Model if _merge==1
drop if _merge==1
drop _merge
sort Make Model ModelYear Trim Cylinders Liters FuelType BodyStyle Drive
save Data/Matchups/NVPPToPrefix, replace
