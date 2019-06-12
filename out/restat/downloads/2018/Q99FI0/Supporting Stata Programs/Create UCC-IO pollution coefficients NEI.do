/* #delimit ; */
clear
/* Note: the directory is set in the "Environmental Engel Curves.do" file, which calls on this
	program, and does not need to be set here unless the program is running independently.
	To run this program separetly, be sure to set the directory here." */


/* Create UCC-IO pollution coefficients.do
--------------------------------------------
This program is part of the Environmental Engel Curves project.

The purpose of this file is to compile a complete list of UCC codes for all years 1997-2012.
Then this list will be exported to Excel and will be manually matched to IO codes.
Then the concordance will be re-imported, cleaned, and matched with IO-level pollution coefficients.

The IO-level pollution coefficients are also created in this file using the NEI and Census data,
an IO-NAICS concordance, and the BEA Total Requirements Matrix.
*/


/* A note about scale:
The Agricultural census lists "market value of agricultural product sold ($1,000)"
The Economic Census lists "Value of sales, shipments, receipts, revenue, or business done ($1,000)"
*/



/* Complie a complete list of every UCC code used between 1996-2013 */
foreach yyyy of numlist 1996/2012 {
*local yyyy = 1996

local yy = substr(string(`yyyy'),3,4)
 di `yy'
infix str ucc 1-6 str ucc_name 7-57 using "Raw Files from BLS\ucci`yy'.txt", clear
replace ucc_name = lower(ucc_name)
gen year = `yyyy'
save "Compiled Data Files\ucci`yy'.dta", replace
}


use "Compiled Data Files\ucci96.dta", clear
foreach yyyy of numlist 1997/2012 {
local yy = substr(string(`yyyy'),3,4)
append using "Compiled Data Files\ucci`yy'.dta"
}

gsort ucc -year
duplicates drop ucc, force
drop year

save "Compiled Data Files\all ucc codes.dta", replace
/*Now this list is exported to Excel Mannually and matched up to IO codes.*/

/* Import a file that contains all possible NAICS codes */
insheet using "Other Raw Files\Census All 2002 NAICS codes.csv", clear comma names
keep if length(naics)==6
gen naics5=substr(naics,1,5)
gen naics4=substr(naics,1,4)
gen naics3=substr(naics,1,3)
gen naics2=substr(naics,1,2)

rename naics original_naics
reshape long naics, i(original_naics) j(length)
rename original_naics naics6
drop length
sort naics

save "Compiled Data Files\2002 NAICS codes.dta", replace



/* Calculate pollution coefficients using the NEI Point emissions data (facility
summary).  There are two main challenges:
	1) Facilities are sometimes missing a NAICS code.  for this we will
		i) use SIC code to NAICS concordance if there is an SIC available
		ii) drop if no NAICS and no SIC are available
	2) NAICS codes are not always listed at the 6-digit level.  for this we will
	assign emissions to 6-digit NAICS based on relative output in the Ag/Econ Censuses.
*/

/* Import the Census of Agriculture */
insheet using "Other Raw Files\AgCensus02.csv", clear
rename total naics_name
tostring naics, replace
rename total_value_sold shipped
tempfile AgCensus02
save `AgCensus02'

/* Most industries in Ag Census have 5-digit or 6-digit codes, with the exception
of Hog and Pig Farming (1122) and Animal Aquaculture (1125).  I am going to create a 
full list Ag Census data based on 6-digit NAICS.  When the 6-digit industry is not
present, I will evenly split the 5-digit industry (or 4-digit, if applicable)*/

/* Try from the other direction: get codes from 2002 NAICS. Then merge in the
output data. */
use "Compiled Data Files\2002 NAICS codes.dta", clear
drop naics
keep if substr(naics6,1,1)=="1"
gen naics5=substr(naics6,1,5)
gen naics4 = substr(naics6,1,4)
duplicates drop

/* First, find the output for the 6-digit NAICS that show up in Ag. Census */
rename naics6 naics
merge 1:1 naics using `AgCensus02.dta', keep(matched master)
gen matched_digits = 6 if _merge==3
drop _merge
rename naics naics6

/* Now matcth the 5-digit NAICS codes that show up in Census, and divde the output
evenly across the 6-digit codes */
rename naics5 naics
merge m:1 naics using `AgCensus02',  update
drop if _merge==2
replace matched_digits = 5 if _merge==5&matched_digits==.
drop _merge
rename naics naics5
egen num5=count(naics5), by(naics5)
replace shipped = shipped/num5 if matched_digits == 5
drop num5


/* Now matcth the 4-digit NAICS codes that show up in Census, and divde the output
evenly across the 6-digit codes */
rename naics4 naics
merge m:1 naics using `AgCensus02',  update
drop if _merge==2
replace matched_digits = 4 if _merge==5&matched_digits==.
drop _merge
rename naics naics4
egen num4=count(naics4), by(naics4)
replace shipped = shipped/num4 if matched_digits == 4
drop num4

drop naics4 naics5 matched_digits

/* This code may not be applicable anymore.
/* The NEI files sometimes have 5-digit codes that add a trailing zero to become
6-digit codes.  I am going to duplicate the 5-digit codes in the census and make
them into 6-digit codes so that they can be merged if necessary into the NEI */
preserve
gen length=length(naics)
keep if length==5
replace naics=naics+"0"
drop length
tempfile ag_naics5
save `ag_naics5'
restore
append using `ag_naics5'
*/

rename naics6 naics
save "Compiled Data Files\AgCensus02.dta", replace


/* Import the 2002 Economic Census */
do "Supporting Stata Programs\Insheet and clean 2002 Economic Census.do"


/* prepare the Census SIC to NAICS crosswalk */
insheet using "Other Raw Files\Census Crosswalk 1987_SIC_to_2002_NAICS.csv", clear names
drop v5 v6
rename sictitleandnote sic_name
rename naicstitle naics_name
drop if sic=="Aux"
drop if sic==""
destring sic, replace
/*
destring naics, replace
*/
save "Compiled Data Files\SIC NAICS Crosswalk.dta", replace



/* Import and clean the 2002 NEI (point facilities summary)*/
insheet using "Other Raw Files\NEI 2002 Facility_Pollutant_091007 Query.csv", clear
keep naics_primary sic_primary co nox pm10fil pm10pri pmcon pmfil pmpri so2 voc
rename naics_primary naics
rename sic_primary sic
replace naics="" if naics=="31-33"



/* Consolidate certain NAICS codes that all go to the same IO code */
replace naics="23" if substr(naics,1,2)=="23"
replace naics="420000" if substr(naics,1,2)=="42"


/* NAICS 452110 appears in the NEI data, but is not actually a NAICS code.  I
will change it to NAICS 45211 */
replace naics="45211" if naics=="452110"

collapse (sum) co nox pm10fil pm10pri pmcon pmfil pmpri so2 voc, by(naics sic)



/* For records that don't have NAICS, use the SIC to assign a NAICS */
/* first, separate into file that has NAICS and one that only has SIC.  Observations
that don't have naics or sic will be dropped. Then merge in NAICS and append original
files back together */
preserve
keep if naics!=""
save "Compiled Data Files\nei_naics.dta", replace
restore

keep if naics==""
drop if sic==.


/*  Now merge in the NAICS based on the SIC_Naics concordance.  note: SIC should
still be unique because SIC are getting matched direclty to NAICS (but not necessarily
6-digit NAICS) so a broad SIC will get matched to a broad NAICS, rather then duplicated */
merge 1:m sic using "Compiled Data Files\SIC NAICS Crosswalk.dta", update
drop if _merge!=4
drop _merge

append using "Compiled Data Files\nei_naics.dta"

/* All construction NAICS (23) will be matched to construction IO anyways. Likewise,
Wholesale trade (42) will be matched to IO 420000 */
replace naics = "23" if substr(naics,1,2)=="23"
replace naics = "420000" if substr(naics,1,2)=="42"
drop sic
collapse (sum) co nox pm10fil pm10pri pmcon pmfil pmpri so2 voc, by(naics)
gen naics_length = length(naics)
gen naics6 = naics if naics_length==6

/* Drop the 90000 NAICS codes since those don't correspond to consumers and aren't
even included in the IO matrices */
drop if substr(naics,1,1)=="9"


/* Note: original naics codes are unique at this point.  Merging in the
longer NAICS codes will cause duplicates.  You cannot simply sum the pollution
beyond this point becuase you will be double-counting.
Ex: a 5-digit NAICS code with XXX pollution will become two 6-digit NAICS codes,
both of which will have XXX for pollution.  You need to divide XXX by $$/total$
in order to get pollution per 6-digit code.  (This is done below) */

/* Now the goal is to dis-aggregate the 4- and 5-digit industries and assign
the pollution to 6-digit NAICS, in proportion to NAICS output. */


merge 1:m naics using "Compiled Data Files\2002 NAICS codes.dta", update
drop if _merge==2
drop _merge
replace naics="23" if substr(naics,1,2)=="23"
replace naics6 = "23" if substr(naics6,1,2)=="23"
replace naics_name = "construction related" if naics=="23"

replace naics="420000" if substr(naics,1,2)=="42"
replace naics6="420000" if substr(naics6,1,2)=="42"
replace naics_name="wholesale" if naics=="420000"


duplicates drop
sort naics
/* There are two 5-digit NAICS codes that appear to be 6-digit codes with the 
trailing zero dropped (51331 and 51421).  For these, we will add the trailing zero */
/* There is also one code (51339) that doesn't have a corresponding 6-digit code,
but we will also add the trailing 0 */
replace naics6=naics+"0" if naics_length==5&naics6==""
rename naics original_naics
rename naics6 naics



/* Now merge in the Ag/Econ census to use as weights for disaggregation */
merge m:1 naics using "Compiled Data Files\2002 Economic Census.dta", keep(master matched)
drop _merge

merge m:1 naics using "Compiled Data Files\AgCensus02.dta", update
drop if _merge==2
drop _merge


sort original_naics


/* Now disaggregate the pollution by dividing into 6-digit NAICS based on output. */
egen total_shipped = total(shipped), by(original_naics)
foreach var of varlist co nox pm10fil pm10pri pmcon pmfil pmpri so2 voc {
replace `var' = `var'*shipped/total_shipped 
}

/* Save the naics shipped data temporarily */
preserve
keep naics shipped
duplicates drop
tempfile naics_output
save `naics_output'
restore


/* Now calculate total pollution for each 6-digit NAICS code */
collapse (sum) co nox pm10fil pm10pri pmcon pmfil pmpri so2 voc, by(naics)

/* Merge in value shipped for each 6-digit NAICS code */
merge 1:1 naics using `naics_output'
drop _merge

save "Compiled Data Files\NAICS pollution output.dta", replace


/* Calculate IO-level direct coefficients:
Find the total output and total emissions by IO code (rolling up from NAICS)
Divide the two */

/* Import and clean the NAICS-IO concordance */
insheet using "Other Raw Files\NAICS-IO.csv", names comma clear
tostring naics, replace
replace iocode="23" if naics=="23"
replace iodescription="construction related" if naics=="23"
replace naics="420000" if naics=="42"
duplicates drop

/* Merge the naics-naics concordance to get all 6-digit NAICS */
merge 1:m naics using "Compiled Data Files\2002 NAICS codes.dta"
drop if _merge==2
drop _merge
gen length=length(naics)
replace naics6 = naics if naics6==""&length==6
replace naics6="23" if substr(naics,1,2)=="23"
replace naics_name="construction related" if naics6=="23"
duplicates drop


/* Merge in emissions and value shipped based on 6-digit NAICS */
drop naics
rename naics6 naics
merge 1:1 naics using "Compiled Data Files\NAICS pollution output.dta"
drop if _merge==2 /*this drops industries 513 and 514, but they were all zero anyways */
drop _merge

/* Collapse via sum in order to have total value shipped and total pollution
per IO code */
collapse (sum) co nox pm10fil pm10pri pmcon pmfil pmpri so2 voc shipped, by(iocode iodescription)


/* Create the coefficients, emissions per million dollars */
foreach var of varlist co nox pm10fil pm10pri pmcon pmfil pmpri so2 voc {
replace `var' = `var'/(shipped/1000) /*shipped is measured in thousands*/
}

/* Rename coefficients to match convention */
rename co directCO
rename nox directNOx
rename pm10fil directPM10fil
rename pm10pri directPM10pri
rename pmcon directPMcon
rename pmfil directPMfil
rename pmpri directPMpri
rename so2 directSO2
rename voc directVOC

/* Some IO codes (based on subordinate NAICS codes) do not have any emission
	listed in NEI, or are not tracked by the censuses.  These coefficients will be set to zero */
foreach var of varlist directVO directNOx directPM10fil directPM10pri directPMcon directPMfil directPMpri directSO2 directVOC {
replace `var'=0 if iocode=="532230"
replace `var'=0 if iocode=="533000"
replace `var'=0 if iocode=="611100"|iocode=="611A00" /*no primary,secondary,post in census*/
replace `var'=0 if iocode=="711100" /*no permaning arts centers in ucc.  Coded for artists, performers */
replace `var'=0 if iocode=="713950" /*no bowling centers in UCC anyways*/
replace `var'=0 if iocode=="813100" /*no religious organizations in census*/
replace `var'=0 if iocode=="814000" /* private households n/a */
}


save "Compiled Data Files\IOdirectcoefficients.dta", replace



/* Now calculate total coefficients */
/*-------------------------------------*/
/* This code is copied from "Create UCC-IO pollution coefficients */
/* Now Bring in the BEA Total Requirements Matrix and calculate
	total coefficients */

/* From IO documentation:
File layout for IndbyIndTrDetail.txt, 
Industry-by-Industry Total Requirements
----------------------------------------
   Field            Description
----------------------------------------
    1            Industry I-O code

    2            Industry description

    3            Industry I-O code
 
    4            Industry description

    5            Total requirements coefficients.  These 
                 values show the production required both
                 directly and indirectly of the industry named
                 by the row code per dollar of production delivered to 
                 final users from the industry named by the column code.  
                 Coefficients are shown to seven decimal places.

    6            Year	
------------------------------------------------------------
      Note: Detail may not add to total due to rounding.

	Note: This means that you should (1) merge IOcoefficients with the row code, i.e. IOfrom,
		and then (2) multiply by the value, and (3) sum it up according to column code.
 */
infix 2 first str iofrom 1-6 str iofrom_desc 11-100  str ioto 101-106 str ioto_desc 111-200 value 202-210 year 216-219 using "BEA 2002 Total Requirements Files\IndbyIndTRDetail.txt", clear
rename iofrom iocode

/* There is one issue with construction NAICS 23.
	Since the IO only uses a 2-digit IOcode for construction, I am going to 
	replace all row codes with 23* for the merge.  Then collapse by summing so have the
	pollution total pollution associated with each construction IO, then average these
	construction IOs */ 

/* Step 1: merge in the direct coefficients, attached to row codes */	
replace iocode="23" if substr(iocode,1,2)=="23"
replace iocode="420000" if substr(iocode,1,2)=="42"

merge m:1 iocode using "Compiled Data Files\IOdirectcoefficients.dta"
/* Note:
The Sxxxxx codes are missing from the raw nei file, since it captures miscellaneous
	non-NAICS uses.
These (non-matched) codes can be dropped.
*/
drop if _merge!=3
drop _merge


/* Step 2: multiple those coefficients by the value in the IO matrix */
foreach i of varlist directCO directNOx directPM10fil directPM10pri directPMcon directPMfil directPMpri directSO2 directVOC {
 replace `i' = value*`i'
}

/* Step 3: collapse (sum) by IOcodes in the column code */
/* Now collapse to find total coeffs */
collapse (sum) direct*, by(ioto ioto_desc)
rename ioto iocode
rename ioto_desc iodescription

/* Rename total coefficients */
rename directCO totalCO
rename directSO2 totalSO2
rename directNOx totalNOx
rename directVOC totalVOC
rename directPM10fil totalPM10fil
rename directPM10pri totalPM10pri
rename directPMcon  totalPMcon
rename directPMfil totalPMfil
rename directPMpri totalPMpri



/* Clean the IO-level total coefficients to prepare for merging to UCC-IO concordance */
/* re-assign IOcode 23 and collapse to have one composite 23* group again */
replace iocode="23" if substr(iocode,1,2)=="23"
replace iodescription="Construction related" if iocode=="23"
collapse (mean) total* , by(iocode iodescription )


/* Use the average coefficient for:
food man (311xxx)
beverage man (3121xxx)
clothing (3152xx) */
/* But first, merge back in value shipped in order to weight the aggregation for these two groups*/
merge 1:1 iocode using "Compiled Data Files\IOdirectcoefficients.dta", keepusing(shipped)
drop _merge

replace iocode = "311000" if substr(iocode,1,3)=="311"
replace iocode= "312100" if  substr(iocode,1,4)=="3121"
replace iocode="315200" if substr(iocode,1,4)=="3152"
replace iocode="315100" if substr(iocode,1,4)=="3151"
replace iocode="336110" if substr(iocode,1,5)=="33611"
replace shipped=1 if shipped==.


collapse (mean) total* [pw=shipped], by(iocode)


save "Compiled Data Files\IOtotalcoefficients.dta", replace



/* Now import the (manually created) IO-UCC concordance and merge in the IO-level total
	pollution coefficients.*/
insheet using "Other Raw Files\UCC-IO concordance.csv", clear comma
replace iocode = "23" if substr(iocode,1,2)=="23"
/* NOTE: this concordance also includes an inidcator for whether the UCC code is
	core (c), food/bev (f), electricity (e), gasoline (g), and fuel oil and other fuels (o) */

/* import the IO-level coefficients */
merge m:1 iocode using "Compiled Data Files\IOtotalcoefficients.dta"
drop _merge
drop if ucc==.

/* replace all missing with zeros */
foreach var of varlist totalCO totalSO2 totalNOx totalVOC totalPM10fil totalPM10pri totalPMcon totalPMfil totalPMpri {
replace `var'=0 if `var'==.
}


tostring ucc, format(%06.0f) replace
save "Compiled Data Files\ucc-io concordance.dta", replace
