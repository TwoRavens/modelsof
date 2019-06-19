*****do-file to classify the sectors into differentiated versus homogenous products
******based on Rauch (1999)

*************************************************************************************************************
*Preparing data about Belgian trade to measure importance of the different SITC subsectors
**************************************************************************************************************
use tradeBE.dta
bysort commoditycode tradeflowcode: egen temp = sum(value)
replace value = temp
	//some codes report more than one value for import and/or export. Apparantly, this is because of 
	//quantities are expressed in different units. So take sum of value per commodity/tradeflow
bysort commoditycode tradeflowcode : gen n = _n
keep if n == 1
	
keep year commoditycode value tradeflowcode
reshape wide value , i(commoditycode) j(tradeflowcode)
ren value1 valueI
ren value2 valueX

gen test = length(commoditycode)
	//only keep 4 digit codes

label var valueI "Value of imports Belgium in $, year 2000, source UN Comtrade"
label var valueX "Value of exports Belgium in $, year 2000, source UN Comtrade"
	
keep if test == 4
drop test
gen sitc4 = commoditycode
sort sitc4

save uncomtradetomerge.dta

*****************************************************************************************************************

*****************************************************************************************************************
*Merging Rauch classification with ISIC codes
*****************************************************************************************************************

use sitc2isic.dta
	//conversion table of SITC rev2 (4 digit) to ISIC code
	//from Muendler (2009)

ren sitc2 sitc4
sort sitc4
merge 1:1 sitc4 using rauchclas.dta
	//rauchclas.dta contains the Rauch classification where SITC4 is the 
	// 4 digit code of SITC rev 2 classification

drop if _merge == 2
	//for some reason the rauch datafile contains much more codes compared to the 
	// file of Muendler. it appears that the Rauch file includes a lot of codes ending in a 
	//zero (so these are more 3 digit codes. Moreover the Rauch file contains non-existing codes
	// such as for example code 0713.... 
drop if _merge == 1
	//also drop codes for which no Rauch classification is available
	
drop _merge

*******************************************************************************************************************

**************************************************
*Merging in trade data
**************************************************

sort sitc4
merge 1:1 sitc4 using uncomtradetomerge.dta

keep if _merge == 3
drop _merge

***************************************************

	/* now we have a dataset at the SITC 4 digit level indicating whether the sitc4 code is 
	   a homogenous / differentiated / reference priced product. Moreover we have the value of 
	   Belgian imports and exports for this product in 2000. 
	  */
	   
***************************
*ISIC Rev2 3 digit level
***************************
	//first we can compute the intensities of the different types of products at the 
	//isic 3 digit level

*Computing intensity of homogenous/differentiated/reference priced products
*using the imports and exports of Belgium to measure the importance of the products

gen difcon = (con == "n")
gen diflib = (lib == "n")
gen homcon = (con == "w")
gen homlib = (lib == "w")
gen refcon = (con == "r")
gen reflib = (lib == "r")

	
***********************************************
*NACE REV1 IO table from Eurostat for Belgium
***********************************************

*Use the Belgian input-output table
*To do this we have to match the ISIC Rev2 3 digit level to NACE 2 digit level. 
*Note that we only have to do this for the tradable goods. We will do this manually

gen nace2 = 01 if isic2 == 111
replace nace2 = 01 if isic2 == 113
replace nace2 = 02 if isic2 == 121
replace nace2 = 02 if isic2 == 122
replace nace2 = 05 if isic2 == 130
replace nace2 = 10 if isic2 == 210
replace nace2 = 11 if isic2 == 220
replace nace2 = 13 if isic2 == 230
replace nace2 = 14 if isic2 == 290
replace nace2 = 15 if isic2 == 311
replace nace2 = 15 if isic2 == 312
replace nace2 = 15 if isic2 == 313
replace nace2 = 16 if isic2 == 314
replace nace2 = 17 if isic2 == 321
replace nace2 = 18 if isic2 == 322
replace nace2 = 19 if isic2 == 323
replace nace2 = 19 if isic2 == 324
replace nace2 = 20 if isic2 == 331
replace nace2 = 36 if isic2 == 332
replace nace2 = 21 if isic2 == 341
replace nace2 = 22 if isic2 == 342
replace nace2 = 24 if isic2 == 351
replace nace2 = 24 if isic2 == 352
replace nace2 = 23 if isic2 == 353
replace nace2 = 23 if isic2 == 354
replace nace2 = 25 if isic2 == 355
replace nace2 = 25 if isic2 == 356
replace nace2 = 26 if isic2 == 361
replace nace2 = 26 if isic2 == 362
replace nace2 = 26 if isic2 == 369
replace nace2 = 27 if isic2 == 371
replace nace2 = 27 if isic2 == 372
replace nace2 = 28 if isic2 == 381
replace nace2 = 29 if isic2 == 382
replace nace2 = 30 if isic2 == 383
replace nace2 = 34 if isic2 == 384
replace nace2 = 33 if isic2 == 385
replace nace2 = 36 if isic2 == 390
replace nace2 = 40 if isic2 == 410

 //correct for sectors 30-32 and 34-35 later on
 


bysort nace2: egen X_nace2 = sum(valueX)
bysort nace2: egen I_nace2 = sum(valueI)
gen XI_nace2 = X_nace2 + I_nace2
egen valueXI = rowtotal(valueX valueI)
gen double wXI = valueXI/XI_nace2
gen wdifcon = difcon*wXI
gen wdiflib = diflib*wXI
gen whomcon = homcon*wXI
gen whomlib = homlib*wXI
gen wrefcon = refcon*wXI
gen wreflib = reflib*wXI

	bysort nace2: egen wshdifcon = sum(wdifcon)
	bysort nace2: egen wshdiflib = sum(wdiflib)
	bysort nace2: egen wshhomcon = sum(whomcon)
	bysort nace2: egen wshhomlib = sum(whomlib)
	bysort nace2: egen wshrefcon = sum(wrefcon)
	bysort nace2: egen wshreflib = sum(wreflib)

	bysort nace2: gen nrproducts =  _N
	drop if nace2 == .
		//2820, 8830, 8960 and 9310 have no nace2 equivalence (labeled: unclassified by Muendler)
		
	collapse  wshdifcon wshdiflib wshhomcon wshhomlib wshrefcon wshreflib  wXI , by(nace2)

	expand 3 if nace2 == 30, generate(dupl)
	bysort dupl: gen n = _n
	replace nace2 = 31 if dupl == 1 & n == 1
	replace nace2 = 32 if dupl == 1 & n == 2
	drop n dupl
	expand 2 if nace2 == 34, generate(dupl)
	replace nace2 = 35 if dupl == 1 
		// giving sectors 30-31-32 and 34-35 the same share of intermediates (as they are one ISIC sector)
	save typesofgoodsshare_nace2.dta, replace


	**Merging in Input-Output data
		
	use use_Belgium2000.dta
			//Use Table for Belgium
	
	drop if nace2 == .
	merge 1:1 nace2 using typesofgoodsshare_nace2.dta

	foreach x in  difcon diflib {
		replace wsh`x' = 1 if _merge == 1
	}	
	//for sectors that have not a classification we assume they are differentiated 
	//products (these are mostly services)
	foreach x in refcon reflib homcon homlib {
		replace wsh`x' = 0 if _merge == 1
	}

	ren _merge merge

	drop if nace2 > 41
		//material inputs typically exclude services, so drop these to compute the share of
		//differentiated inputs

	foreach var of varlist _* {
		replace `var' = 0 if `var' == .
		egen input`var' = sum(`var')
		gen inshare`var' = `var'/input`var'
		//input share of each product for each different sector
		
		*differentiated products
		gen temp_winpshdifcon`var' = inshare`var'*wshdifcon
		egen winpshdifcon`var' = sum(temp_winpshdifcon`var')

		gen temp_winpshdiflib`var' = inshare`var'*wshdiflib
		egen winpshdiflib`var' = sum(temp_winpshdiflib`var')

		*reference priced
		gen temp_winpshrefcon`var' = inshare`var'*wshrefcon
		egen winpshrefcon`var' = sum(temp_winpshrefcon`var')

		gen temp_winpshreflib`var' = inshare`var'*wshreflib
		egen winpshreflib`var' = sum(temp_winpshreflib`var')

		*Homogeneous products
		gen temp_winpshhomcon`var' = inshare`var'*wshhomcon
		egen winpshhomcon`var' = sum(temp_winpshhomcon`var')
	
		gen temp_winpshhomlib`var' = inshare`var'*wshhomlib
		egen winpshhomlib`var' = sum(temp_winpshhomlib`var')
	
	
		}
	drop temp*

gen n = _n
keep if n == 1
drop nace merge label
drop _*

reshape long winpshdifcon_ winpshdiflib_ winpshrefcon_ winpshreflib_ winpshhomcon_ winpshhomlib_ inpshdifcon_ , i(n) j(nace2) string
destring nace2, replace

label define nace2label 1 "Agriculture" 2 "Logging" 5 "Fishing" 10 "Mining of Coal" 11 "Extraction Petr. and Gas" /* 
	*/ 12 "Mining of Uranium" 13 "Mining of Metal Ores" 14 "Other Mining and Quarrying" 15 "Manuf. Food Prod."  /*
	*/ 16 "Manuf. Tobacco" 17 "Manuf. Textile Products" 18 "Manuf. Apparel" 19 "Manuf. Leather" 20 "Manuf. Wood" /*
	*/ 21 "Manuf. Paper" 22 "Printing and Publishing" 23 "Manuf. Energy Prod." 24 "Manuf. Chemical Prod." /*
	*/ 25 "Manuf. Rubber & Plastic" 26 "Manuf. Other Non-Metallic" 27 "Manuf. Basic Metals" 28 "Manuf. Metal Prod." /*
	*/ 29 "Manuf Mach. & Equipm." 30 "Manuf. Office Mach." 31 "Manuf. Electr. Mach." 32 "Manuf. Radio, Telecom." /*
	*/ 33 "Manuf. Medical, Optical Instr." 34 "Manuf. Motor Vehicles" 35 "Manuf. Other Transport" /*
	*/ 36 "Manuf. Furniture, other Manuf." 37 "Recycling" 40 "Utilities" 41 "Water Distribution" 45 "Construction" /*
	*/ 50 "Sale and Repair Motor Vehciles" 51 "Wholesale" 52 "Retail" 55 "Hotels & Restaurants" /*
	*/ 60 "Land Transport" 61 "Water Transport" 62 "Air Transport" 63 "Supporting Transport Act."  /*
	*/ 64 "Post & Telecom" 65 "Financial Intermediation" 66 "Insurance and Pension" /*
	*/ 67 "Auxiliary Financial Activities" 70 "Real Estate" 71 "Renting Machinery"  72 "Computer Services" /*
	*/ 73 "Research and Development" 74 "Other Business Services"
label values nace2 nace2label
drop if nace2 > 74
drop if nace2 == 12 
drop if nace2 == 37


egen test = rowtotal(winpshdiflib_ winpshreflib_ winpshhomlib_ )
graph hbar winpshdiflib_  winpshreflib_ winpshhomlib_ if test > 0 /*
	*/ , stack over(nace2, sort(winpshdiflib_ ) label(labsize(vsmall))) /*
	*/ title("Share of total inputs") subtitle("Liberal estimate, Trade as Product Weights", size(small)) /*
	*/ caption("Based on Belgian Use Table; only agr. and manuf. products as inputs", size(vsmall)) /*
	*/ ysize(8)  legend(order(1 "Diff." 2 "Reference" 3 "Hom.") size(small)) scheme(s1mono) /*
	*/ yline(0.4, lwidth(thick) lcolor(red)) 
	
		//this is figure B.1. in the online appendix

erase typesofgoodsshare_nace2.dta
erase uncomtradetomerge.dta
