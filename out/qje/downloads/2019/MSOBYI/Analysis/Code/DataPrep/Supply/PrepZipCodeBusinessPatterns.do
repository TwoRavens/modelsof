/* PrepZipCodeBusinessPatterns.do */
* Source: https://www2.census.gov/econ2014/CBP_CSV/, and analogous for earlier years. 
	* 2015 data from https://www.census.gov/data/datasets/2015/econ/cbp/2015-cbp.html
* Notes on NAICS codes:
	* Walmart is 452112 https://ycharts.com/companies/WMT
	* Target is 452990 https://ycharts.com/companies/TGT
	* Warehouse clubs and supercenters are supposed to be 452910. According to the NAICS definitions below, 452910 is the only one that sells perishable groceries. 452112 and 452990 may sell food, but not perishables.
	
	** NAICS definitions:
	* http://www.naics.com/naics-code-description/?code=452112
	* http://www.naics.com/naics-code-description/?code=452910
	* http://www.naics.com/naics-code-description/?code=452990

clear
save $Externals/Calculations/StoreEntryExit/ZipCodeBusinessPatterns.dta, replace emptyok
foreach year in 03 04 05 06 07 08 09 10 11 12 13 14 15 16 { 
	local pwd = c(pwd)
	cd $Externals/Data/ZipCodeBusinessPatterns/
	unzipfile zbp`year'detail
	cd "`pwd'"
	** Import and reshape to zip-code wide form
	import delimited $Externals/Data/ZipCodeBusinessPatterns/zbp`year'detail.txt, varnames(1) clear
	rename zip zip_code
	
	replace naics = "0" if naics=="------"
	
	** Keep only food retail establishments
	keep if inlist(naics,"0","445110","445120","445310","446110")==1|inlist(naics,"447110","452111","452112","452910","452990")==1|substr(naics,1,4)=="4452"
	
	replace naics = "_" + naics
	replace naics = subinstr(naics,"/","",.)
	reshape wide est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,i(zip_code) j(naics) string
	
	gen int year = real("20"+"`year'")
	append using $Externals/Calculations/StoreEntryExit/ZipCodeBusinessPatterns.dta
	saveold $Externals/Calculations/StoreEntryExit/ZipCodeBusinessPatterns.dta, replace 	
	erase $Externals/Data/ZipCodeBusinessPatterns/zbp`year'detail.txt
}



rename est_445210 est_Meat
rename est_445220 est_Seafood
rename est_445230 est_FruitVeg
egen est_Spec = rowtotal(est_Meat est_Seafood est_FruitVeg)
egen est_OtherSpec = rowtotal(est_445291 est_445292 est_445299)

rename est_445110 est_Grocery
rename est_452910 est_SuperClub // Warehouse clubs and supercenters.
egen est_VSmallGroc = rowtotal(n1_4_445110 n5_9_445110)
egen est_SmallGroc = rowtotal(n1_4_445110 n5_9_445110 n10_19_445110 n20_49_445110) // Anything 1-50 employees
gen est_MediumGroc = n20_49_445110 // Anything 20-49 employees
egen est_LargeGroc = rowtotal(n50_99_445110 n100_249_445110 n250_499_445110 n500_999_445110 n1000_445110) // Anything over 50 employees
egen est_DrugConv = rowtotal(est_445120 est_446110 est_447110) // Conv, drug/pharmacy, and gas with convenience
egen est_Conv = rowtotal(est_445120 est_447110) // Conv and gas with convenience
rename est_446110 est_Drug
egen est_OtherMass = rowtotal(est_452112 est_452990) // "Discount department stores" and "all other general merchandise stores." Consistent with definition in GetChannelTypes.do

foreach var of varlist est_* {
	replace `var' = 0 if `var'==.
}

compress
saveold $Externals/Calculations/StoreEntryExit/ZipCodeBusinessPatterns.dta, replace 	
