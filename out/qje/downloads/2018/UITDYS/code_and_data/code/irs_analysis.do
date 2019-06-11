**********************************************************************************************
**********************************************************************************************
**********************************************************************************************
**********************************************************************************************
*
* IRS analysis code for "Who Becomes an Inventor in America? The Importance of Exposure in Innovation"
* Authors: Alex Bell, Raj Chetty, Xavier Jaravel, Neviana Petkova, & John van Reenen
* Questions on this code may be directed to Alex Bell.
* 
* The order of the code is as follows:
*	- Dataset Building
* 	- Tables (Followed by Appendix Figures)
*	- Figures (Followed by Appendix Figures)
*
* Note: The code for Online Tables (which have been released publicly) is in a separate folder.
* This code only creates data that is not released in dataset format.
* 
* Most of the calculations of "miscellaneous statisitics" have been omitted from this code in the
* interest of clarity in replicating figures and tables.
*
* The primary purpose of this code is analysis. 
* The SAS code used to link patent data with tax data is not provided, but pseudocode for this
* procedure can be found in the PDF of the Online Appendix. 
*
**********************************************************************************************  
**********************************************************************************************
**********************************************************************************************
**********************************************************************************************

set more off

cap log close
global prog draft2016
global v v1
local date=subinstr(string(date(c(current_date),"DMY"),"%td_CCYY_NN_DD")," ","_",.)
global patpath /home/stataharvard/patents
global section2sample (cohort<=1984 & coinvent==0) 

cd ${patpath}/draft2016
 
cap mkdir output_${v}
cap mkdir data   
cap mkdir logs  
cap mkdir output_${v}/scalar_out



***********************************************
***********************************************
* Dataset Building
* 	1) Core kids file
*	2) NYC file
* 	3) Event study
***********************************************  
***********************************************

***********
* Cleaning Up Raw SAS Data
***********
cap log close
log using logs/${prog}_${v}_cleaningsasdata.txt, text replace

***
* Create primary categories from individual-level data
***
use raw/pat_idb_v6_110.dta, clear

*Confirm that appyear is not missing and assumes logical values, then determine the earliest for each TIN.
assert inrange(appyear,1850,2015)
bys tin: egen firstappyear = min(appyear)
bys tin: egen firstpatyear = min(patyear)
bys tin: egen app2001orlater = max(appyear>=2001)

*Confirm that no observation is missing both patent id and application id.
assert ![missing(pat_inv_id) & missing(app_inv_id)]
*Confirm that no observation has both patent id and application id.
assert missing(pat_inv_id) | missing(app_inv_id)

*If a TIN is ever associated with a patent id and/or an applicant id, label it as a grantee and/or applicant.
bys tin: egen grantee = max(!missing(pat_inv_id))
label var grantee "indicator that TIN received one or more patents"
bys tin: egen applicant = max(!missing(app_inv_id))
label var applicant "indicator that TIN applied for one or more patents"

*Prepare series variable for merging by encoding it to match with curr_class15.dta
rename series series_str
label define seriesl 0 "" 1 "D" 2 "RE" 3 "PP" 4 "H"
encode series_str, gen(series) label(seriesl) noextend
*Note that Stata interprets the empty string in label define as removing a label, so the desired 0 is not assigned by encode.
*Assign this below, only giving a series of 0 to patents, not to applications.
replace series=0 if series==. & !missing(patno)

*Preseve the original class in a separate variable to add in later for applications and any patents not in the using data.
rename class orig_class
*For patents, we will replace class with the more complete data merged in and regenerate scat and cat thereafter.
drop scat cat

*Merge in updated data, discarding unmerged data from the using file.
merge m:1 series patno using ${patpath}/idb/v5/curr_class15.dta, keep(master match)
count if _merge==1 & !missing(pat_inv_id)
*There are 4017 patents in the master data that are not found in the using data.
*Looking up a half-dozen of these online, Alex thinks they may have been withdrawn, not be current, etc.

*Add back in the original class for applications and any patents not in the using data.
replace class3=orig_class if _merge==1
drop orig_class _merge

*To keep terminology standard, the 9-digit "class" is referred to as "class_long" and the 3-digit "class3" is referred to as "class".
rename class class_long
rename class3 class

*Merge in category and subcategory based on class.
merge m:1 class using ${patpath}/idb/classlookup.dta, keepusing(scat cat) keep(match master) nogen
tab class if missing(scat), mi
*Apart from 4 obs with class 999, the merge succeeded.
compress

**Determine the areas in which a person most frequently patents.
*Generate counts of each TIN's cats, scats, and classes. Make this zero for any missing categories, as we do not want to choose these.
*At each level of classification, determine the most frequent value for each TIN.
*There will be ties among the most frequent categories, so we use unique random numbers at each level to break these ties.
set seed 1991 
// Feb 10 2017 I put the set seed in after i ran this code so it won't have been set in this data
foreach level in cat scat class class_long {
bys tin `level': gen num_in_`level'=_N
replace num_in_`level'=0 if missing(`level')
gen rand_`level'=runiform()
gsort tin -num_in_`level' -rand_`level'
by tin: gen `level'_prim=`level'[1]
}
bys tin: egen lifetime_patents = total(~missing(pat_inv_id))
bys tin: egen lifetime_apps = total(~missing(app_inv_id))
bys tin: egen lifetime_apps_granted = total(~missing(app_inv_id) & granted==1)
merge m:1 patno using ${patpath}/idb/raw/fcit, keep(match master) keepusing(fcit)
replace fcit = 0 if missing(fcit)
bys tin: egen lifetime_cites = total(fcit)

save data/${prog}_${v}_inv_precollapse, replace

*Reduce to TIN-level variables of interest, drop complete duplicates, and verify that each TIN appears only once.
keep tin unmasked_tin cat_prim scat_prim class_prim class_long_prim grantee applicant firstappyear firstpatyear app2001orlater lifetime_patents lifetime_apps lifetime_cites lifetime_apps_granted
duplicates drop
by tin: assert _N==1

save data/${prog}_${v}_inv, replace

log close




***********
* Dataset 1: Patent Rates vs Parent Income Dataset Building
***********

cap log close
log using logs/${prog}_${v}_dataset1building.txt, text replace



* Merge child patent data to Movers commuting zone base data on the child's TIN.
* Start with basically just a print of the IGE basefile
use ${patpath}/draft_june/patmv_v4_10.dta, clear
rename kid_tin tin

* Note that we expect only a small share of records from either file to match since most children in Movers are not inventors, and most inventors are not children in Movers.
merge 1:1 tin using data/${prog}_${v}_inv, keepusing(cat_prim scat_prim class_prim grantee applicant firstappyear firstpatyear app2001orlater) keep(match master) nogen
rename tin kid_tin
*TJB: Fill in missing values of newly-merged fields, allowing us to create an inclusive "inventor" indicator.

replace grantee=0 if grantee==.
replace applicant=0 if applicant==.
//gen inventor=applicant|grantee
// june 19 recoding inventor as having a patent or application applied for between 2001 and 2005
gen ageatapp=firstappyear-cohort
gen ageatpat=firstpatyear-cohort
gen inventor = app2001orlater==1 & ageatapp>=23  & ageatapp!=.
// therefore, we also need to drop 1990 cohort b/c turn 23 in 2012 so can never patent
keep if cohort<=1989

foreach var of varlist applicant grantee {
replace `var'=0 if ~inventor
}
replace cat_prim=. if ~inventor
replace scat_prim=. if ~inventor
replace class_prim="" if ~inventor
replace firstappyear = . if ~inventor
replace ageatapp = . if ~inventor


*TJB: Check the number of inventors without a primary class is small. We've greatly reduced this (to 4). 
count if missing(class_prim) & inventor==1
assert r(N)<100

foreach var of varlist cat_prim scat_prim class_prim firstappyear {
    rename `var' `var'_kid
}


*TJB: Merge child patent data to Movers commuting zone base data on the dad's TIN, indicating which dads are inventors.

rename par_dad_tin tin
merge m:1 tin using data/${prog}_${v}_inv, keepusing(cat_prim scat_prim class_prim firstappyear) keep(match master)
rename tin par_dad_tin 
gen byte dad_inv=(_m==3)
drop _m
foreach var of varlist cat_prim scat_prim class_prim firstappyear {
    rename `var' `var'_dad
}

*TJB: Merge child patent data to Movers commuting zone base data on the mom's TIN, indicating which moms are inventors.

rename par_mom_tin tin
merge m:1 tin using data/${prog}_${v}_inv, keepusing(cat_prim scat_prim class_prim firstappyear) keep(match master)
rename tin par_mom_tin
gen byte mom_inv=(_m==3)
drop _m
foreach var of varlist cat_prim scat_prim class_prim firstappyear {
    rename `var' `var'_mom
}
*TJB: Merge in NAICS codes and payer TINs for parents of each child.
merge 1:1 kid_tin using ${patpath}/naics/pat_dm2_v2_100, keepusing(par_dad_payer_tin par_dad_naics par_mom_payer_tin par_mom_naics)
*note it's not a perfect merge b/c this data is from fulldata 

tab _m
drop if _m==2
drop _m

* generate parent state variable
gen par_st = par_mom_state_1999
replace par_st = par_dad_state_1999 if missing(par_st)

gen byte inventor30 = inventor * (ageatapp<=30) if cohort+30<=2012 // only defined for 80-82

save data/kids_10_${v}, replace

**
* now find if they were ever on same patent or application
**
use data/kids_10_${v}, clear
keep if mom_inv | dad_inv
keep if inventor
keep kid_tin par_mom_tin par_dad_tin
ren kid_tin tin 
merge 1:m tin using raw/pat_idb_v6_110.dta, keep(match master) keepusing(patno series serial_number) nogen
ren tin kid_tin

*Find the coauthors of the kid's patents by joining, keeping kid patents without any coauthors, as well.

preserve
drop if missing(patno)
joinby patno using raw/pat_idb_v6_110.dta, unmatched(master)
gen copatent = par_mom_tin == tin | par_dad_tin == tin
tempfile patents
save `patents'
restore

*Find the coauthors of the kid's applications by joining, keeping kid patents without any coauthors, as well.
drop if missing(serial_number)
joinby serial_number using raw/pat_idb_v6_110.dta, unmatched(master)
gen coapp=(par_mom_tin==tin)|par_dad_tin==tin
append using `patents'

*Set copatent (coapp) indicators to zero for those who do not patent (apply), then collapse to individual level.
replace copatent=0 if missing(copatent)
replace coapp=0 if missing(coapp)
collapse (max) coapp copat, by(kid_tin) fast
tab coapp copatent, m
gen coinvent=(coapp==1|copatent==1)

keep kid_tin coinvent
tempfile kid_10_coinvwpar
save `kid_10_coinvwpar'


*Merge on the copatent/coapp indicators to main data.
use data/kids_10_${v}, clear
merge 1:1 kid_tin using `kid_10_coinvwpar', keep(match master) nogen
replace coinvent=0 if missing(coinvent)
save data/kids_10_${v}, replace


* AB patch july 6: merge on college at age 20 [in case 18-23 is picking up grad school]
use data/kids_10_${v}, clear
merge 1:1 kid_tin using ${patpath}/draft_june/patmv_v4_10_collprint.dta, nogen keep(match master) keepusing(coll_tin_20)
save data/kids_10_${v}, replace

* merge on citations

use raw/pat_idb_v6_110.dta, clear
merge m:1 patno using ${patpath}/idb/raw/fcit, keep(match master) keepusing(fcit)
replace fcit = 0 if missing(fcit)
bys patno: gen fcit_adj = fcit/_N
collapse (sum) fcit (sum) fcit_adj, by(tin )
ren tin kid_tin
save data/cites_by_tin, replace
use data/kids_10_${v}, clear
merge 1:1 kid_tin using data/cites_by_tin, nogen keep(match master)
foreach var of varlist fcit fcit_adj {
replace `var' = 0 if missing(`var') | inventor==0
}



save data/kids_10_${v}, replace

log close

* Number of collaborators in dataset -- Adding separate file July 6 2018
use raw/pat_idb_v6_110.dta, clear
gen patnos = series+string(patno)
sort patnos serial_number
gen double flag = (patnos!=patnos[_n-1]) | (serial_number!=serial_number[_n-1]) 
gen doc_id = sum(flag)
keep doc_id tin
format doc_id tin %18.0g
outsheet using data/collaborators_input.csv, comma replace nonames

// python script takes about 30 hours to run..
shell python collaborators.py
insheet using data/collaborators_output.csv, comma clear
ren inventor tin
codebook tin 
save data/collaborators, replace



***********
* Dataset 2: Build core NYC dataset
***********

cap log close
log using logs/${prog}_${v}_dataset2building.txt, text replace

use ${patpath}/draft_june/pat_misalloc_v1_50, clear
keep if cohort<=1985 & cohort>=1979

foreach var in inventor par_vin above_median par_rank fcit fcit_adj cittop10 cittop5 {
cap drop `var'
}

* Sept 20, 2016 merging citations in to NYC file because many people were missing
ren tinx kid_tin
merge 1:1 kid_tin using data/cites_by_tin, nogen keep(match master)

ren kid_tin tin
merge 1:m tin using data/${prog}_${v}_inv.dta, keepusing(cat_prim grantee applicant firstappyear app2001orlater) keep(match master) nogen
replace grantee=0 if grantee==.
replace applicant=0 if applicant==.
gen ageatfirstapp = firstappyear - cohort

gen inventor = app2001orlater & ageatfirstapp>=23  & (grantee|applicant)

foreach var of varlist firstappyear cat_prim ageatfirstapp {
replace `var'=. if ~inventor
}
* merge on IGE-style family income
ren tin kid_tin
merge 1:1 kid_tin using ${patpath}/nyc/pat_misalloc_v1_150.dta, keepusing(par_fam_inc) keep(match master) nogen
// drop nyc income variables and replace with ige income vars
bys cohort: egen par_rank = rank(par_fam_inc)
bys cohort: egen max = max(par_rank)
replace par_rank = par_rank/max
drop max

gen ethn=.
label define ethnl 1 "Native American" 2 "Asian" 3 "Hispanic" 4 "Black" 5 "White" 
* missing is unreported
forval i=1/4{
replace ethn=`i' if ETHNethnici_`i'_orig==1
}
replace ethn=5 if ETHNethnici_1_orig==0&ETHNethnici_2_orig==0&ETHNethnici_3_orig==0&ETHNethnici_4_orig==0
label values ethn ethnl

replace inventor = 0  if cohort +ageatfirstapp >2012


save data/nyc_10_${v}, replace

log close

***********
* Dataset 3: Event Study
***********
* start with patent-inventor dataset and generate flags for who is applying in what year
use raw/pat_idb_v6_110.dta, clear 
merge m:1 patno using ../idb/raw/fcit, keep(match master) keepusing(fcit)
replace fcit = 0 if missing(fcit)
bys patno: gen fcit_adj = fcit/_N
* it's going to be useful to have the sum of just a patent variable to prevent double-counting of applications
gen patents = ~missing(pat_inv_id)
replace granted = 1 if ~missing(pat_inv_id)
gen applied_in_year = 1
collapse (sum) applied_in_year (sum) granted (sum) fcit (sum) fcit_adj (sum) patents, by(tin appyear) fast
* merge on income for each year
ren appyear tax_yr
merge 1:1 tin tax_yr using raw/pat_idb_v6_db_processed, keep(match using) nogen
replace applied_in_year = 0 if missing(applied_in_year)
ren granted applied_in_year_granted
replace applied_in_year_granted = 0 if missing(applied_in_year_granted)

compress
merge m:1 tin using raw/pat_idb_v6_db_indv nogen
ren ssa_yob yob

save data/event_10_${v}, replace

* several preparations Raj put in for his event dataset

use data/event_10_${v}, clear
*Set W-2 inc to missing prior to 1999
replace w2_inc = . if tax_yr<1999
replace w2_inc_spouse = . if tax_yr<1999

*Note that f1040_inc is zero for non-filers prior to 1999

*Generate total income excluding spouse earnings
g non_spouse_f1040 = f1040_inc-w2_inc_spouse
g nw_inc = non_spouse-w2_inc

*Redefine applied and patented vars to be binary
replace applied_in_year = 1 if applied_in_year_granted >=1&applied_in_year_granted<.
replace applied_in_year_granted = 1 if applied_in_year_granted>=1&applied_in_year_granted<.

g age = tax_yr-yob
keep if yob<=1984
replace age = . if age>100
bys tin: egen mean_non_spouse= mean(non_spouse) if age>=40&age<=50&yob>=1959&yob<=1962
g mean_non_spouse_trim = max(min(mean_non_spouse,1e7),0) if mean_non_spouse~=.
xtile q_mean_non_spouse = mean_non_spouse if tax_yr==2005, nq(100)
xtile q_mean_non_spouse_top = mean_non_spouse if tax_yr==2005 & q_mean_non_spouse==100, nq(100)

foreach var of varlist w2_inc nw_inc {
xtile q_`var' = `var' if ~missing(q_mean_non_spouse), nq(100)
xtile q_`var'_top = `var' if ~missing(q_mean_non_spouse) & q_`var'==100, nq(100)
}

* For event studies, flag a random year in which a patent was applied for
set seed 2016
g rand = uniform()
bys tin applied_in_year (rand): g index = _n
cap drop temp
g temp=tax_yr if applied_in_year ==1 & index==1
by tin: egen rpat_yr = min(temp)

drop temp index
g eyr = tax_yr-rpat_yr
g rpat_age = rpat_yr-yob

* note: about 6% of inventors don't have a rpat_yr. This is possible because they have grants in 1996-2012 that were applied for before the sample window starts. It's okay.

* 11/21/2017 adding zipcode IRTF and IRMF as separate fields
merge 1:1 tin tax_yr using raw/pat_idb_v6_db_bothzipprints
keep if _m==3
drop _m
save data/event_20_${v}, replace




***********************************************
***********************************************
* Analysis Code: Tables
***********************************************  
***********************************************

***********************
* Table 1 SUMMARY STATS
***********************
***
* full sample
***
use data/${prog}_${v}_inv, clear
merge 1:1 tin using  data/collaborators, keep(match master)
tab _m
drop _m
merge 1:m tin using data/event_20_${v}, keepusing(gnd_ind w2_inc f1040_inc non_spouse_f1040 rpat_age tax_yr) keep(match master)
gen in_db = _m==3
keep if tax_yr==2012 | ~in_db

gen female = gnd_ind == "F" if in_db

gen w2_inc_trim = w2_inc if in_db
replace w2_inc_trim = 0 if w2_inc_trim < 0 & in_db
replace w2_inc_trim = 1e6 if w2_inc_trim > 1e6 & ~missing(w2_inc_trim ) & in_db 
gen non_spouse_f1040_trim = non_spouse_f1040 if in_db
replace non_spouse_f1040_trim = 0 if non_spouse_f1040_trim < 0 & in_db
replace non_spouse_f1040_trim = 1e7 if non_spouse_f1040_trim > 1e7 & ~missing(non_spouse_f1040_trim ) & in_db
gen f1040_inc_trim = f1040_inc if in_db
replace f1040_inc_trim = 0 if f1040_inc_trim < 0 & in_db
replace f1040_inc_trim = 1e7 if f1040_inc_trim > 1e7 & ~missing(f1040_inc_trim ) & in_db


replace rpat_age =. if rpat_age>200

local outcomes lifetime_patents lifetime_apps lifetime_cites w2_inc_trim f1040_inc_trim non_spouse_f1040_trim rpat_age female collaborators
local clist
foreach o of local outcomes {
	local clist `clist' (mean) mean_`o'=`o' (p50) p50_`o'=`o' (sd) sd_`o'=`o'
}
collapse `clist' (count) n=tin, fast

saveold output_${v}/summstats_fullsample, replace version(12)

***
* kids sample
***
use data/kids_10_${v} if inrange(cohort, 1980,1984), clear
ren kid_tin tin
merge 1:1 tin using data/${prog}_${v}_inv, keepusing( lifetime_patents lifetime_apps lifetime_cites ) keep(match master) nogen
merge 1:1 tin using  data/collaborators, keep(match master)
tab _m
drop _m
merge 1:m tin using data/event_20_${v}, keepusing(gnd_ind w2_inc f1040_inc non_spouse_f1040 rpat_age tax_yr) keep(match master)
gen in_db = _m==3
keep if tax_yr==2012 | ~in_db
gen coll20 = ~missing(coll_tin_20)
gen female = kid_gnd == "F"
gen w2_inc_trim = w2_inc if in_db
replace w2_inc_trim = 0 if w2_inc_trim < 0 & in_db
replace w2_inc_trim = 1e6 if w2_inc_trim > 1e6 & ~missing(w2_inc_trim ) & in_db 
gen non_spouse_f1040_trim = non_spouse_f1040 if in_db
replace non_spouse_f1040_trim = 0 if non_spouse_f1040_trim < 0 & in_db
replace non_spouse_f1040_trim = 1e7 if non_spouse_f1040_trim > 1e7 & ~missing(non_spouse_f1040_trim ) & in_db
gen f1040_inc_trim = f1040_inc if in_db
replace f1040_inc_trim = 0 if f1040_inc_trim < 0 & in_db
replace f1040_inc_trim = 1e7 if f1040_inc_trim > 1e7 & ~missing(f1040_inc_trim ) & in_db
foreach var of varlist lifetime_patents lifetime_apps lifetime_cites w2_inc_trim f1040_inc_trim non_spouse_f1040_trim rpat_age collaborators {
	replace `var'=. if inventor==0 
}
keep lifetime_patents lifetime_apps lifetime_cites w2_inc_trim f1040_inc_trim non_spouse_f1040_trim rpat_age female coll20 par_fam_inc inventor tin collaborators
local outcomes lifetime_patents lifetime_apps lifetime_cites w2_inc_trim f1040_inc_trim non_spouse_f1040_trim rpat_age female coll20 par_fam_inc collaborators
local clist
foreach o of local outcomes {
	local clist `clist' (mean) mean_`o'=`o' (p50) p50_`o'=`o' (sd) sd_`o'=`o'
}
collapse `clist' (count) n=tin, by(inventor) fast

saveold output_${v}/summstats_intergen, replace version(12) 


***
* nyc sample
***
use data/nyc_10_${v}, clear
ren kid_tin tin
merge 1:1 tin using data/${prog}_${v}_inv, keepusing( lifetime_patents lifetime_apps lifetime_cites ) keep(match master) nogen
merge 1:1 tin using  data/collaborators, keep(match master)
tab _m
drop _m
merge 1:m tin using data/event_20_${v}, keepusing(w2_inc f1040_inc non_spouse_f1040 rpat_age tax_yr) keep(match master)
gen in_db = _m==3
keep if tax_yr==2012 | ~in_db
gen w2_inc_trim = w2_inc if in_db
replace w2_inc_trim = 0 if w2_inc_trim < 0 & in_db
replace w2_inc_trim = 1e6 if w2_inc_trim > 1e6 & ~missing(w2_inc_trim ) & in_db 
gen non_spouse_f1040_trim = non_spouse_f1040 if in_db
replace non_spouse_f1040_trim = 0 if non_spouse_f1040_trim < 0 & in_db
replace non_spouse_f1040_trim = 1e7 if non_spouse_f1040_trim > 1e7 & ~missing(non_spouse_f1040_trim ) & in_db
gen f1040_inc_trim = f1040_inc if in_db
replace f1040_inc_trim = 0 if f1040_inc_trim < 0 & in_db
replace f1040_inc_trim = 1e7 if f1040_inc_trim > 1e7 & ~missing(f1040_inc_trim ) & in_db
gen asian = ethn=="Asian":ethnl
gen hispanic = ethn=="Hispanic":ethnl
gen black = ethn=="Black":ethnl
gen white = ethn=="White":ethnl
foreach var of varlist lifetime_patents lifetime_apps lifetime_cites w2_inc_trim f1040_inc_trim non_spouse_f1040_trim rpat_age collaborators {
	replace `var'=. if inventor==0 
}
local outcomes lifetime_patents lifetime_apps lifetime_cites w2_inc_trim f1040_inc_trim non_spouse_f1040_trim rpat_age female  par_fam_inc  math3 math8 verb3 verb8 white black asian hispanic collaborators
local clist
foreach o of local outcomes {
	ocal clist `clist' (mean) mean_`o'=`o' (p50) p50_`o'=`o' (sd) sd_`o'=`o'
}
collapse `clist' (count) n=tin, by(inventor) fast
saveold output_${v}/summstats_nyc, replace version(12) 


***********************
* Table 2: DFL (producing data needed to do this on outside)
* (This code written by Charlotte)
***********************
use data/nyc_10_${v}, clear
 
gen inv_1k = inventor*1000 
cap mkdir output_${v}/bygrade
 
gen asian = ethn=="Asian":ethnl
gen hispanic = ethn=="Hispanic":ethnl
gen black = ethn=="Black":ethnl
gen white = ethn=="White":ethnl

* white =1 if white and 0 if black and . otherwise
gen male = 1-female
gen p80 = par_rank> .8 if par_rank ~=.
gen pq =  1 if par_rank <=.2 
replace pq =  2 if par_rank <=.4 & par_rank >.2
replace pq =  3 if par_rank <=.6 & par_rank >.4
replace pq =  4 if par_rank <=.8 & par_rank >.6
replace pq =  5 if par_rank  <=1 & par_rank >.8
 
gen white_vs_black = white==1 if (white==1 | black==1)
gen white_vs_minority = white==1 if (white==1 | black==1 | hispanic==1)
gen asian_vs_not = asian==1 

foreach var of varlist male p80 ethn white_vs_black white_vs_minority asian_vs_not pq {
	forval i=3/8 {
		preserve
			* Drop Native Americans (ethn==1) only for the ethnicity cut 
			if "`var'" == "ethn" {
				drop if ethn==. | ethn==1
			}
			
			* Equivalent to binscatter (but also produces counts)
			* Rerank test scores after dropping obs with missing `var'
			keep if ~missing(math`i', `var')
			cap drop math_vin_new`i'
			fastxtile math_vin_new`i' = math`i', nquantiles(20)
			
			collapse (mean) inv_1k math`i' (count) n=kid_tin, by(math_vin_new`i' `var')
			qui sum n
			assert r(min)>=10
			cap decode ethn, gen(ethnicity)
			cap drop ethn
			
			local add_string ""
			if "`var'" == "ethn" {
				local add_string "string"
			}			
			qui reshape wide inv_1k math`i' n, i(math_vin) j(`var') `add_string'
			saveold  output_${v}/bygrade/`var'`i', replace version(12)
		restore
	}
}



***********************
* Table 3,4: Child patent rate vs rate in father's industry or parents' CZ
* (This code written by Trevor)
***********************
set more off

cap log close
local date=subinstr(string(date(c(current_date),"DMY"),"%td_CCYY_NN_DD")," ","_",.)
global patpath /home/stataharvard/patents
global section2sample (cohort<=1984 & coinvent==0) 

cd ${patpath}/draft2016
 
cap mkdir output_${v}
cap mkdir data   
cap mkdir logs  
cap program drop pe
program define pe
`0'
end
*Filename: /home/stataharvard/patents/naics_distance/script/cz_naics_distance_v1.do
*Source: naics_distance_v1.do (2015.07.02 version by TJB)
*Author: Trevor J. Bakker
*Created: 2015.07.06
*Description: Produces CZ and NAICS-distance-related figures for Part 2: Childhood Environment section of patents paper.
log using output_${v}/naics_distance_log, text replace
cap mkdir naics_distance_intermed
local patpath $patpath
local naics_denominator `patpath'/naics/cdw_naics_10m.dta

foreach environ in cz naics {
    *Step 0: Calculate total cz and naics sizes
    *This is done with a 0.152462% sample sample from CDW with 12 years of NAICS, which I appropriately collapse and scale in naics.do.
    *This is done in Movers code over a 10-year sample in movers/historical_patenting/historical_patenting_v2.do

    *Step 1: Construct kids' patent rates by class by parent naics (cz), restricting to cohorts no greater than 1984.
    *Data is one line per kid. Note that class is missing for kids who do not invent.
    local cz_var par_cz_1996
    local naics_var par_dad_naics
    *CAUTION: par_cz_1996 is missing in 2.5% of cases.
    pe use data/kids_10_${v} if cohort<=1984 & !missing(``environ'_var'), clear
    *Drop if either parent is an inventor
    pe keep if dad_inv==0 & mom_inv==0
    pe rename ``environ'_var' `environ'
    pe rename class_prim_kid class
    *Form the numerator through collapsing data to the naics(cz)-class level.
    pe gen ind=1
    pe collapse (sum) kids_inv_in_class`environ'=ind, by(`environ' class) fast
    pe count
    *Gather up any missing classes.
    pe merge m:1 class using /home/stataharvard/patents/idb/classlookup, keepusing(class) keep(match master using) nogen
    *MINOR RESTRICTION: We have a single class for which there is no corresponding category or subcategory in the lookup table.
    pe drop if class=="987"
    *Strongly balance in terms of naics (cz) and class.
    pe replace class="mi" if class==""
    pe reshape wide kids_inv_in_class`environ', i(`environ') j(class) string
    pe reshape long
    pe replace class="" if class=="mi"
    *Without naics (cz), we cannot get naics_size (patentspercap), and all the usual right-hand-side variables will be missing.
    pe drop if `environ'==.
    *Now that we have all naics(cz)-class combinations, fill in with 0 kids for those that are newly-created.
    pe replace kids_inv_in_class`environ'=0 if kids_inv_in_class`environ'==.
    *Form the denominator of the left-hand side.
    pe bys `environ': egen `environ'_size_kids=total(kids_inv_in_class`environ')
    *Calculate the number of kids inventing in a given naics(cz)-class as a share of all kids (including non-inventors) in the naics (cz).
    pe gen pct_kids_inv_in_class`environ'=kids_inv_in_class`environ'/`environ'_size_kids
    * Having defined the naics (cz) size including all kids, now we restrict only to inventor kids.
    pe drop if missing(class)
    *Step 2: Merge industry naics(cz)-class file onto the kid naics(cz)-class level file.
    *This file is one line per naics(cz)-class, i.e., every combination of patent class we observe from inventors in the naics (cz).
    local cz_pop `patpath'/movers/historical_patenting/historical_output/czcatscatclass.dta
    local naics_pop `patpath'/naics/naics_collapsible.dta
    pe merge 1:1 `environ' class using ``environ'_pop'
    *Relevant only for NAICS, not CZ: Investigate limited number of unmerged observeations from industry patent-intensity data (_merge==2).
    pe bys `environ': egen flag_`environ'=mean(_merge==2)
    tab flag_`environ', mi
    *It turns out that these unmatched observations correspond to particular naics that are not in the kids data. We do not need these.
    pe drop if flag_`environ'==1
    *Note that _merge==1 is common and expected because the master file is strongly balanced in terms of the naics(cz)-class.
    *Merge on scat and cat values, which are missing for observations not in the naics (cz) data.
    pe rename scat scat2
    pe rename cat cat2
    pe merge m:1 class using /home/stataharvard/patents/idb/classlookup, keepusing(class scat cat) keep(match master) nogen
    pe assert scat2==scat if scat2!=.
    pe assert cat2==cat if scat2!=.
    pe drop scat2 cat2
    
    *Many of these combinations will not exist in industry data, in which case we make class-level variables 0.
    *For variables aggregated at the `environ' level, we take the maximum value.
    local cz_max workingage_pop1990
    local naics_max inv_per_year_naics
    foreach var of varlist ``environ'_max'  {
        pe bys `environ': egen double `var'2=max(`var')
        pe assert `var'==`var'2 if !missing(`var')
        pe drop `var'
        pe rename `var'2 `var' 
    }
    *For variables aggregated at intermediate levels, we take the maximum level with code specific to the bysorts needed.
    if "`environ'"=="naics" {
        *scat-level
        pe bys naics cat scat: egen double inv_per_year_scatnaics2=max(inv_per_year_scatnaics)
        pe assert inv_per_year_scatnaics==inv_per_year_scatnaics2 if !missing(inv_per_year_scatnaics)
        pe drop inv_per_year_scatnaics
        pe rename inv_per_year_scatnaics2 inv_per_year_scatnaics 
        *cat-level
        pe bys naics cat: egen double inv_per_year_catnaics2=max(inv_per_year_catnaics)
        pe assert inv_per_year_catnaics==inv_per_year_catnaics2 if !missing(inv_per_year_catnaics)
        pe drop inv_per_year_catnaics
        pe rename inv_per_year_catnaics2 inv_per_year_catnaics 
    }
    *CAUTION: Remember that CZ-level data uses patents, whereas NAICS-level data uses inventors (but could use patents if desired).
    local cz_zero patents workingage_pop1990
    local naics_zero inv_per_year_classnaics pat_per_year_classnaics inv_per_year_scatnaics inv_per_year_catnaics inv_per_year_naics
    foreach var of varlist ``environ'_zero'  {
        pe assert !missing(`var') if _merge!=1
        pe replace `var'=0 if `var'==.
    }
    *Optional: Keep an indicator for not merging to industry data. After restricting on naics_size, at least some of these will drop out.
    *gen no_industry=(_merge==1)
    pe keep `environ' class scat cat kids_inv_in_class`environ' `environ'_size_kids pct_kids_inv_in_class`environ' ``environ'_zero' 
    
    *Step 3: Generate and standardize variables.
    if "`environ'"=="naics" {
        *Merge NAICS size onto the data.
        pe merge m:1 `environ' using `naics_denominator'
        *Note that _merge==2 identifies naics that are not in the kids file, so we drop them.  
        pe drop if _merge==2
        *Some of the kid-industry merged data has NAICS codes that are not matched.
        *Our CDW sample is not exhaustive, but it is highly likely that these are very small NAICS.
        *We can at least check that these NAICS have few inventors in both the kid and industry data.
        pe sum inv_per_year_classnaics kids_inv_in_classnaics if _merge==1
        pe sum inv_per_year_classnaics kids_inv_in_classnaics if _merge==3
        *Without naics_size, we cannot form the right-hand side variables, so merge==1 must be dropped.
        pe drop if _merge==1
        pe assert !missing(naics_size)
        pe drop _merge
        * Restrict to naics of 50,000 or above for the entire analysis.
        pe drop if naics_size<50000
        *Set the units of the dependent variable.
        local unit inv
        local denom naics_size
    }
    if "`environ'"=="cz" {
        *The patents variable is a count within each class-cz over ten years. Annualize this. 
        pe gen pat_per_year_classcz=patents/10
        pe bys cz cat scat: egen pat_per_year_scatcz=total(pat_per_year_classcz)
        pe bys cz cat: egen pat_per_year_catcz=total(pat_per_year_classcz)
        pe bys cz: egen pat_per_year_cz=total(pat_per_year_classcz)
        //Restrict to CZs of 50,000 or above for the entire analysis. (Loses 4-5% of population; Raj confirms an analogous cut was made in Moverssays this would just be noise because it won't be precisely estimated.)
        //		 update : AB commenting this CZ population restriction out on may 30 2017
		//pe drop if workingage_pop1990<50000
		*Set the units of the dependent variable.
        local unit pat
        local denom workingage_pop1990
    }
    *Calculate the number of inventors (patents) per year in the same naics(cz)-class as a share of average annual employment in dad's NAICS (CZ population). 
    pe gen pct_`unit'_in_class`environ'=`unit'_per_year_class`environ'/`denom'
    *Calculate the number of inventors (patents) per year not in the same naics(cz)-class but still in the same naics(cz)-subcategory as a share of average annual employment in dad's NAICS (CZ population).
    pe gen pct_`unit'_in_scat`environ'_oclass=(`unit'_per_year_scat`environ'-`unit'_per_year_class`environ')/`denom'
    *Calculate the number of inventors (patents) per year not in the same naics(cz)-subcategory but still in the same naics(cz)-category as a share of average annual employment in dad's NAICS (CZ population).
    pe gen pct_`unit'_in_cat`environ'_oscat=(`unit'_per_year_cat`environ'-`unit'_per_year_scat`environ')/`denom'
    *Calculate the number of inventors (patents) per year not in the same naics(cz)-category but still in the same naics(cz) as a share of average annual employment in dad's NAICS (CZ population).
    pe gen pct_`unit'_in_`environ'_ocat=(`unit'_per_year_`environ'-`unit'_per_year_cat`environ')/`denom'    
    pe compress
    pe save naics_distance_intermed/kid_`environ'_balanced_${v}.dta, replace
    *Prepare small dataset for later merge to related_class for establishing weight in nearby classes.
    preserve
    pe keep `environ' class `unit'_per_year_class`environ'
    pe rename class related_class
    pe rename `unit'_per_year_class`environ' related_`unit'_per_year_class`environ'
    tempfile related
    pe save `related'
    restore

    *Step 4: Merge kids' file to distance file
    *Data will be one line per naics(cz)-class-related class (strongly balanced)
    pe joinby class using `patpath'/class_distance/class_distance_inside_v2, unmatched(both)
    pe tab _merge
    pe tab class if _merge==1
    *Before we strongly balanced this, nearly all observations from master (naics) were matched; the only unmatched were from non-existant category 001 
    * or from categories 147 and 449, which lack cross-patenting and thus cannot have distance calculated.
    pe drop if _merge==1
    *There should be no _merge==2 after strongly balancing.
    pe assert _merge!=2, rc0
    *Even if there were _merge==2, since we do not have kids_10 data (and thus `environ', kids_inv_in_class`environ', `environ'_size, etc.) to merge
    * with specific classes in the distance file, _merge==2 observations would not have RHS variables.
    pe drop if _merge==2
    pe drop _merge num_inclass-class_size
    pe assert !missing(`environ',class,related_class,kids_inv_in_class`environ',`environ'_size_kids,`denom')
    
    *Create analogues for subcategory and category so that we can look at patenting at related levels.
    *Note that distance_rank begins at 0 and counts upward, so the 11th observation has distance_rank of 10, etc.
    pe merge m:1 `environ' related_class using `related', nogen keep(match master)
    pe sort `environ' class distance_rank
    pe by `environ' class: gen run_sum=sum(related_`unit'_per_year_class`environ')
    forvalues i=1(10)91 {
        local ip9=`i'+9
        local ip10=`i'+10
        pe by `environ' class: gen pct_in_`i'_to_`ip9'=(run_sum[`ip10']-run_sum[`i'])/`denom'
    }
    pe drop run_sum
    pe compress
    * To reduce use of finite memory resources, implement the distance restriction before running regressions.
    pe keep if distance_rank==0
    pe saveold naics_distance_intermed/distance_kid_`environ'_balanced_${v}.dta, replace
    *shell zip naics_distance/intermed/distance_kid_`environ'_balanced_${v}.zip `environ'_distance/intermed/distance_kid_`environ'_balanced_${v}.dta &

	************ Intermediate File Saved Here ***********
	
    *Step 5: Regression Analysis
    use naics_distance_intermed/distance_kid_`environ'_balanced_${v}.dta if distance_rank==0, clear
    if "`environ'"=="naics" {
        local unit inv
        local denom naics_size
    }
    if "`environ'"=="cz" {
        local unit pat
        local denom workingage_pop1990
    }
    pe eststo clear
    local cond ""
    *local cond " & pct_`unit'_in_class`environ'<.00166667"
    pe matrix C=J(11,2,.)
    pe eststo f7_4: areg pct_kids_inv_in_class`environ' pct_`unit'_in_class`environ' [w=`environ'_size_kids] `cond', a(class) cluster(`environ')
	pe sum pct_kids_inv_in_class`environ' pct_`unit'_in_class`environ' [w=`environ'_size_kids] if 1 `cond'
    pe matrix C[1,1]=_b[pct_`unit'_in_class`environ']
    pe matrix C[1,2]=_se[pct_`unit'_in_class`environ']
    eststo f7_5: areg pct_kids_inv_in_class`environ' pct_`unit'_in_class`environ' pct_`unit'_in_scat`environ'_oclass pct_`unit'_in_cat`environ'_oscat pct_`unit'_in_`environ'_ocat [w=`environ'_size_kids] if 1 `cond', a(class) cluster(`environ')
    pe sum pct_kids_inv_in_class`environ' pct_`unit'_in_class`environ' pct_`unit'_in_scat`environ'_oclass pct_`unit'_in_cat`environ'_oscat pct_`unit'_in_`environ'_ocat [w=`environ'_size_kids] if 1 `cond'
	forvalues i=1/10 {
        local j=(`i'-1)*10+1
        local k=`i'*10
        local l=`i'+1
        pe eststo f8_1_`i': areg pct_kids_inv_in_class`environ' pct_in_`j'_to_`k' [w=`environ'_size_kids] if 1 `cond', a(class) cluster(`environ')
        pe matrix C[`l',1]=_b[pct_in_`j'_to_`k']
        pe matrix C[`l',2]=_se[pct_in_`j'_to_`k']
    }
    pe matrix list C
    pe sum pct_kids_inv_in_class`environ' pct_`unit'_in_class`environ' pct_`unit'_in_scat`environ'_oclass pct_`unit'_in_cat`environ'_oscat pct_`unit'_in_`environ'_ocat pct_in_* [w=`environ'_size_kids] if 1 `cond'

    pe eststo f8_1_0: areg pct_kids_inv_in_class`environ' pct_`unit'_in_class`environ' pct_in_* [w=`environ'_size_kids] if 1 `cond', a(class) cluster(`environ')
    *Prepare for collapses
    pe drop related_class-distance_rank pct_in_* _est_* related_`unit'_per_year_class`environ'
    pe duplicates report
    pe assert r(unique_value)==r(N)

    *Collapse to subcategory-naics(cz) level, passing on subcat-naics(cz)-invariant variables through the by statement and summing relevant class-naics(cz) variables.
    local scat`environ'_vars "`environ' `denom' `environ'_size_kids scat cat `unit'_per_year_scat`environ' `unit'_per_year_cat`environ' `unit'_per_year_`environ'"
    foreach a in `scat`environ'_vars' {
        pe assert !missing(`a')
    }
    pe sort `scat`environ'_vars'
    pe collapse (sum) kids_inv_in_scat`environ'=kids_inv_in_class`environ', by(`scat`environ'_vars')
    *Calculate the number of kids who invent in a given subcategory as a share of all kids (including non-inventors).
    pe gen pct_kids_inv_in_scat`environ'=kids_inv_in_scat`environ'/`environ'_size_kids
    *Calculate the number of inventors per year in the same naics(cz)-scat as a share of average annual employment in dad's NAICS. 
    pe gen pct_`unit'_in_scat`environ'=`unit'_per_year_scat`environ'/`denom'
    pe eststo f7_3: areg pct_kids_inv_in_scat`environ' pct_`unit'_in_scat`environ' [w=`environ'_size_kids] if 1 `cond', a(scat) cluster(`environ')
    pe sum pct_kids_inv_in_scat`environ' pct_`unit'_in_scat`environ' [w=`environ'_size_kids] if 1 `cond'

    *Collapse to category-naics(cz) level, passing on cat-naics(cz)-invariant variables through the by statement and summing relevant scat-naics(cz) variables.
    local cat`environ'_vars "`environ' `denom' `environ'_size_kids cat `unit'_per_year_cat`environ' `unit'_per_year_`environ'"
    foreach a in `cat`environ'_vars' {
        pe assert !missing(`a')
    }
    pe sort `cat`environ'_vars'
    pe collapse (sum) kids_inv_in_cat`environ'=kids_inv_in_scat`environ', by(`cat`environ'_vars')
    *Calculate the number of kids who invent in a given category as a share of all kids (including non-inventors).
    pe gen pct_kids_inv_in_cat`environ'=kids_inv_in_cat`environ'/`environ'_size_kids
    *Calculate the number of inventors per year in the same naics(cz)-cat as a share of average annual employment in dad's NAICS. 
    pe gen pct_`unit'_in_cat`environ'=`unit'_per_year_cat`environ'/`denom'
    pe eststo f7_2: areg pct_kids_inv_in_cat`environ' pct_`unit'_in_cat`environ' [w=`environ'_size_kids] if 1 `cond', a(cat) cluster(`environ')
    pe sum pct_kids_inv_in_cat`environ' pct_`unit'_in_cat`environ' [w=`environ'_size_kids] if 1 `cond'

    *Collapse to naics (cz) level, passing on naics(cz)-invariant variables through the by statement and summing relevant cat-naics(cz) variables.
    local `environ'_vars "`environ' `denom' `environ'_size_kids `unit'_per_year_`environ'"
    foreach a in ``environ'_vars' {
        pe assert !missing(`a')
    }
    pe sort ``environ'_vars'
    pe collapse (sum) kids_inv_in_`environ'=kids_inv_in_cat`environ', by(``environ'_vars')
    *Calculate the number of kids who invent in a given category as a share of all kids (including non-inventors).
    pe gen pct_kids_inv_in_`environ'=kids_inv_in_`environ'/`environ'_size_kids
    *Calculate the number of inventors per year in the same naics (cz) as a share of average annual employment in dad's NAICS. 
    pe gen pct_`unit'_in_`environ'=`unit'_per_year_`environ'/`denom'
    pe eststo f7_1: reg pct_kids_inv_in_`environ' pct_`unit'_in_`environ' [w=`environ'_size_kids] if 1 `cond', cluster(`environ')
    pe sum pct_kids_inv_in_`environ' pct_`unit'_in_`environ' [w=`environ'_size_kids] if 1 `cond'

    *Transform to log on both scales for Figure 6.
    pe gen ln_pct_kids_inv_in_`environ'=ln(pct_kids_inv_in_`environ')
    pe gen ln_pct_`unit'_in_`environ'=ln(pct_`unit'_in_`environ')
    pe count if !missing(ln_pct_kids_inv_in_`environ') `cond'
    pe count if !missing(ln_pct_`unit'_in_`environ') `cond'

    * Kid Patent Rate in Father's Industry vs. Overall Patent Rate in Father's Industry 
    pe binscatter ln_pct_kids_inv ln_pct_`unit'_in if 1 `cond' [w=`environ'_size_kids], xlabel(-11(2)-5) savegraph(output_${v}/`environ'_distance_f6.1_${v}.gph) savedata(output_${v}/`environ'_distance_f6.1_${v}) replace
    *Note that the binscatter above has only 19 obs because one of the observations has over 5% (1/20th) of the weight.
    pe scatter ln_pct_kids_inv ln_pct_`unit'_in if 1 `cond' [w=`environ'_size_kids], xlabel(-11(2)-5)
    pe graph save output_${v}/`environ'_distance_f6.1.1_${v}.gph, replace
    
    * Table of regressions.
    local cz_note "Absorbing class; clustering by CZ; and excluding children who had a first application before age 23 or whose parent (either) is an inventor."
    local naics_note "Restricting to naics_size over 50000; absorbing class; clustering by NAICS; and excluding children who had a first application before age 23 or whose parent (either) is an inventor."
    pe esttab f7_1 f7_2 f7_3 f7_4 f7_5 using output_${v}/`environ'_distance_f7_regression_${v}.csv, replace se mtitles varwidth(25) modelwidth(15) title("") addnotes("``environ'_note'")
    pe esttab f8_1_1 f8_1_2 f8_1_3 f8_1_4 f8_1_5 f8_1_6 f8_1_7 f8_1_8 f8_1_9 f8_1_10 using output_${v}/`environ'_distance_f7_regression_${v}.csv, append se mtitles varwidth(25) modelwidth(15) title("") addnotes("``environ'_note'")
    pe esttab f8_1_0 using output_${v}/`environ'_distance_f7_regression_${v}.csv, append se mtitles varwidth(25) modelwidth(15) title("") addnotes("``environ'_note'")
    pe clear
    pe svmat C
    pe outsheet using output_${v}/tables3and4_`environ'_distance_f8_matrix_${v}.csv, replace comma
}
log close



use ../movers/historical_patenting/historical_output/cz, clear
save output_${v}/scalar_out/czpatentingintensity, replace

***
** the "one-off" regressions for table 4
***
cap log close
log using output_${v}/exposure_oneoff, text replace
est clear
use data/kids_10_${v} if inrange(cohort, 1980, 1984), clear
drop if coinvent==1 | mom_inv==1 | dad_inv==1
ren par_cz_1996 cz
// October 26 2017 changing this to use ONLY movers
keep if cz!=kid_cz_2012 
drop if missing(cz, kid_cz_2012)
collapse (mean) inventor (count) cellsize=kid_tin, by(cz kid_cz_2012) fast
merge m:1 cz using ../movers/historical_patenting/historical_output/cz, keep(match master using)
eststo col2: areg inventor patentspercap [w=cellsize], cluster(cz) absorb(kid_cz_2012)
** Means for regression above:
//sum inventor patentspercap
sum inventor patentspercap [w=cellsize]


** Replicate column 3 , which is at category level

* similar to above but at cz-cat level, again absorbing kid's current cz
use data/kids_10_${v}, clear
drop if coinvent==1 | mom_inv==1 | dad_inv==1
keep if inrange(cohort, 1980, 1984)
ren par_cz_1996 cz
// October 26 2017 changing this to use ONLY movers
keep if cz!=kid_cz_2012 
ren cat_prim_kid cat
drop if missing(cz, kid_cz_2012)
collapse (count) cellsize=kid_tin, by(cz cat kid_cz_2012) fast
* this is one of those weird cases where reshape is going to help me balance and fill
* the 0's for naics-cz pairs that had no inventors (want to see that they had 0 in cat 1,2,.. etc)
replace cat = 0 if missing(cat)
reshape wide cellsize, i(cz kid_cz_2012 ) j(cat)
reshape long
replace cellsize = 0 if missing(cellsize)
replace cat = . if cat==0

merge m:1 cz cat using ../movers/historical_patenting/historical_output/czcat, keep(match master)
bys cz kid_cz_2012: egen czkidcz_size = total(cellsize)
drop if missing(cat) 
gen frac = cellsize/czkidcz_size

egen double kidcz_cat = group(kid_cz_2012 cat )
eststo col4: areg frac patentspercap [w=czkidcz_size] , cluster(cz) a(kidcz_cat)
** Means for regression above:
sum frac patentspercap [w=czkidcz_size]


* also at cz-cat level, this time absorbing father's naics
use data/kids_10_${v}, clear
drop if coinvent==1 | mom_inv==1 | dad_inv==1
keep if inrange(cohort, 1980, 1984)
ren par_cz_1996 cz
ren cat_prim_kid cat
drop if missing(cz, par_dad_naics)
collapse (count) cellsize=kid_tin, by(cz cat par_dad_naics) fast
* this is one of those weird cases where reshape is going to help me balance and fill
* the 0's for naics-cz pairs that had no inventors (want to see that they had 0 in cat 1,2,.. etc)
replace cat = 0 if missing(cat)
reshape wide cellsize, i(cz par_dad_naics ) j(cat)
reshape long
replace cellsize = 0 if missing(cellsize)
replace cat = . if cat==0

merge m:1 cz cat using ../movers/historical_patenting/historical_output/czcat, keep(match master)
bys cz par_dad_naics: egen cznaics_size = total(cellsize)
drop if missing(cat) 
gen frac = cellsize/cznaics_size


areg  frac patentspercap [w=cznaics_size] , cluster(cz) a(cat)

egen double naics_cat = group(par_dad_naics cat )
eststo col5: areg frac patentspercap [w=cznaics_size] , cluster(cz) a(naics_cat)
** Means for regression above:
sum frac patentspercap [w=cznaics_size]

esttab using output_${v}/table4_robustness.csv, replace se mtitles varwidth(25) modelwidth(15) title("") 

log close

// End Tables 3 and 4 code



***********************
* Table 5: Gender Exposure 
***********************

cap mkdir explore
cap mkdir explore/genderexposure

****
* Main gender-dependent spec's
****
use data/event_20_${v}, clear
keep if yob<=1970 
ren zipcode zip
merge m:1 zip using data/zip_cz_crosswalk.dta, keepusing(cz1)
// number of patent grants or applications we ever see by gender and cz
collapse (sum) applied_in_year, by(gnd_ind cz1) 
ren cz1 cz
drop if gnd_ind == "U" | missing(cz) | missing(gnd_ind)
ren applied_in_year patents
reshape wide patents , i(cz) j(gnd_ind ) string
replace patentsF = 0 if missing(patentsF)
replace patentsM = 0 if missing(patentsM)
// convert patents to "yearly" version 
replace patentsF = patentsF/17
replace patentsM = patentsM/17
save explore/genderexposure/adults_bycz_UNMASKED, replace

use data/kids_10_${v}.dta, clear
keep if inrange(cohort, 1980, 1984) 
keep if dad_inv==0 & mom_inv==0
collapse (mean) inventor (count) kid_tin, by(par_cz_1996 kid_gnd )
drop if kid_gnd=="U" | missing(kid_gnd) | missing(par_cz_1996 )
ren par_cz_1996 cz
merge m:1 cz using explore/genderexposure/adults_bycz_UNMASKED


merge m:1 cz using ../movers/historical_patenting/historical_output/cz , keep(match master) nogen keepusing(patents workingage_pop1990)       
drop _m
foreach var of varlist patents* {
replace `var' = 0 if missing(`var')
gen `var'percap=`var'/workingage_pop1990
}
saveold explore/genderexposure/adultsandkids_bycz_UNMASKED, replace

ren kid_tin num_kids
keep kid_gnd cz inventor *percap num_kids workingage_pop1990
saveold explore/genderexposure/adultsandkids_bycz_mskd, replace


** robustness check on the above -- collapsing also by tech cat
use data/event_20_${v}, clear
keep if yob<=1970
ren zipcode zip
merge m:1 zip using data/zip_cz_crosswalk.dta, keepusing(cz1)
drop _m
merge m:1 tin using data/${prog}_${v}_inv, keepusing(cat_prim)
keep if _m ==3
collapse (sum) applied_in_year, by(gnd_ind cz1 cat_prim) 
ren cz1 cz
drop if gnd_ind == "U" | missing(cz) | missing(gnd_ind)
ren applied_in_year patents
reshape wide patents , i(cz cat) j(gnd_ind ) string
replace patentsF = 0 if missing(patentsF)
replace patentsM = 0 if missing(patentsM)
merge m:1 cz using ../movers/historical_patenting/historical_output/cz , keep(match master) nogen keepusing( workingage_pop1990)       
save explore/genderexposure/adults_byczcat_UNMASKED, replace
foreach var of varlist patentsF patentsM {
replace `var' = . if `var'<10
}
save explore/genderexposure/adults_byczcat_mskd, replace

use data/kids_10_${v}.dta, clear
keep if inrange(cohort, 1980, 1984) 
keep if dad_inv==0 & mom_inv==0
collapse (mean) inventor (count) kid_tin, by(par_cz_1996 kid_gnd cat_prim_kid)
drop if kid_gnd=="U" | missing(kid_gnd) | missing(par_cz_1996 )
ren par_cz_1996 cz
ren cat_prim_kid cat_prim
save explore/genderexposure/kids_byczcat_UNMASKED, replace

* build spine with all cz x gender x cat combinations
use data/kids_10_${v}.dta, clear
keep par_cz_1996 
duplicates drop
ren par_cz_1996 cz
expand 14
gen kid_gnd = "F" if mod(_n, 2)==0
replace kid_gnd = "M" if mod(_n, 2)==1
bys cz kid_gnd: gen cat_prim = _n
drop if missing(cz)
merge m:1 cz using ../movers/historical_patenting/historical_output/cz , keep(match master) nogen keepusing( workingage_pop1990)       

save explore/genderexposure/byczcat_spine, replace

use explore/genderexposure/byczcat_spine, clear
merge m:1 cz cat_prim using explore/genderexposure/adults_byczcat_UNMASKED, keep(match master) keepusing(patentsF patentsM) nogen
merge 1:1 cz cat_prim kid_gnd using explore/genderexposure/kids_byczcat_UNMASKED, nogen
bys cz kid_gnd: egen totkids_czgnd = total(kid_tin)
drop if missing(cat_prim)

foreach var of varlist patents* kid_tin {
replace `var' = 0 if missing(`var')
}
foreach var of varlist patents* {
gen `var'percap=`var'/workingage_pop1990
}
drop if missing(cz)
drop inventor
gen inventor = kid_tin/totkids_czgnd
drop if missing(cat_prim)
// convert patents to "yearly" version 
foreach var of varlist patentsF patentsM patentsFpercap  patentsMpercap {
replace `var'= `var'/17
}
saveold explore/genderexposure/adultsandkids_byczcat_UNMASKED, replace
drop patentsF patentsM kid_tin
sort cz kid_gnd cat_prim
saveold explore/genderexposure/adultsandkids_byczcat_mskd, replace




***********************
* Table 6: Movers 
***********************

cap log close
log using patents_movers_feb2018_v3.log, text replace


****
* X-Sectional Result in this sample
****
est clear
use data/kids_10_${v} if inrange(cohort, 1980, 1988), clear
drop if coinvent==1 | mom_inv==1 | dad_inv==1
ren par_cz_1996 cz
merge m:1 cz using ../movers/historical_patenting/historical_output/cz, nogen keepusing(patentspercap)
ren cz par_cz_1996
eststo: reg inventor patentspercap if inrange(cohort, 1980,1984), cluster(par_cz_1996)
eststo: reg inventor patentspercap, cluster(par_cz_1996)

****
* Movers
****
use data/kids_10_${v} if inrange(cohort, 1980, 1988), clear
drop if coinvent==1 | mom_inv==1 | dad_inv==1
gen ageatmove=year_move_cz-cohort
// keep only single movers
keep if total_moves_cz==1 


// prep movers file
ren par_cz_dest cz
merge m:1 cz using ../movers/historical_patenting/historical_output/cz, nogen keepusing(patentspercap)
ren patentspercap patentspercap_dest
ren cz par_cz_dest
ren par_cz_orig cz
merge m:1 cz using ../movers/historical_patenting/historical_output/cz, nogen keepusing(patentspercap)
ren patentspercap patentspercap_orig
ren cz par_cz_orig

tab ageatmove, m

gen diff = patentspercap_dest-patentspercap_orig

gen ageatmove_orig = ageatmove
replace ageatmove = 24 if ageatmove > 24 & ~missing(ageatmove)


// baseline spec
eststo: reg inventor diff c.diff#c.ageatmove i.ageatmove i.cohort, a(par_cz_orig)
// add in c.diff#i.cohort -- basically no change
eststo: reg inventor diff c.diff#c.ageatmove i.ageatmove i.cohort c.diff#i.cohort, a(par_cz_orig)
// e_rank_o instead of origin FE's is very similar
eststo: reg inventor diff c.diff#c.ageatmove i.ageatmove i.cohort patentspercap_orig , r 
// for raj, interact both the d_e_rank and e_rank_o w/ cohort -- really does nothing
eststo: reg inventor diff c.diff#c.ageatmove i.ageatmove i.cohort patentspercap_orig i.cohort#c.diff i.cohort#c.patentspercap_orig , r
// last thought: whole thing interacted w/ cohort?
forval c=1980/1988{
	qui reg inventor diff c.diff#c.ageatmove i.ageatmove if cohort==`c', a(par_cz_orig)
	local b = _b[c.diff#c.ageatmove]
	di "`c', `b'"
}
forval c=1980/1988{
	reg inventor diff c.diff#c.ageatmove i.ageatmove if cohort==`c', a(par_cz_orig)
}

// family FE.. miraculously the same coeff, though insig
eststo: reg inventor diff c.diff#c.ageatmove i.ageatmove i.cohort, a(fam_id)
eststo: areg inventor diff c.diff#c.ageatmove i.ageatmove i.cohort, a(fam_id) cluster(fam_id)

// baseline spec still there w/ clustering but t is a bit lower -- don't think we need to cluster
eststo: areg inventor diff c.diff#c.ageatmove i.ageatmove i.cohort, a(par_cz_orig) cluster(par_cz_orig)

esttab using output_${v}/movers_various.csv, replace se  

// graphical version of baseline spec
est clear
eststo: reg inventor diff c.diff#i.ageatmove i.ageatmove i.cohort, a(par_cz_orig)
eststo: reg inventor diff c.diff#i.ageatmove_orig i.ageatmove_orig i.cohort, a(par_cz_orig)
esttab using output_${v}/movers_hockeystick.csv, replace plain  not 
esttab using output_${v}/movers_hockeystick_se.csv, replace plain  not se


log close





***********************
* Appendix Table 1 Patent Rates vs Test Scores
***********************
cap log close
log using output_${v}/tablea1_inv_vs_testscores, text replace
use data/nyc_10_${v}, clear
drop if missing(par_rank)
gen inv_1k = inventor*1000
merge 1:1 kid_tin using data/kids_10_${v}, keep(match master) keepusing(kid_rank)
est clear
eststo base_math3: reg inv_1k math3, r
sum inv_1k if e(sample)
estadd local mean `r(mean)'
eststo base_verb3: reg inv_1k verb3, r 
sum inv_1k if e(sample)
estadd local mean `r(mean)'
eststo both: reg inv_1k verb3 math3, r 
sum inv_1k if e(sample)
estadd local mean `r(mean)'
eststo math3_a_verb3: reg inv_1k math3, r a(verb_vin3)
sum inv_1k if e(sample)
estadd local mean `r(mean)'
estadd local fe "English Ventile"
eststo verb3_a_math3: reg inv_1k verb3, r a(math_vin3)
sum inv_1k if e(sample)
estadd local mean `r(mean)'
estadd local fe "Math Ventile"

bys cohort: egen kid_rank_insample = rank(kid_rank) if ~missing(kid_rank)
bys cohort: egen max = max(kid_rank_insample )
replace kid_rank_insample  = kid_rank_insample / max
gen kidtop1pc = kid_rank_insample >.99 if ~missing(kid_rank_insample )

gen kidtop1pc_1k = kidtop1pc*1000

eststo inc_math3: reg kidtop1pc_1k math3, r
sum kidtop1pc_1k if e(sample)
estadd local mean `r(mean)'
eststo inc_verb3: reg kidtop1pc_1k verb3, r
sum kidtop1pc_1k if e(sample)
estadd local mean `r(mean)'
eststo inc_both: reg kidtop1pc_1k math3 verb3, r
sum kidtop1pc_1k if e(sample)
estadd local mean `r(mean)'

esttab using output_${v}/tablea1_inv_vs_testscores.csv, scalars(fe N r2 mean) replace se  
log close



***********************
* Appendix Table 2: Uses data from Table 2
***********************


***********************
* Appendix Table 3: No IRS data
***********************



***********************************************
***********************************************
* Analysis Code: Figures
***********************************************  
***********************************************


************
* Figure 1: Patent Rates vs Parent Income
* measure by age 30. also show grantee/applicant contributions separately for Fig 2B
************

use data/kids_10_${v}.dta if inrange(cohort, 1980, 1984), clear
cap gen byte inventor30 = inventor * (ageatapp<=30) if cohort+30<=2012
gen byte applicant30 = applicant * (ageatapp<=30) if cohort+30<=2012
gen byte grantee30 = grantee * (ageatapp<=30) if cohort+30<=2012
gen top1pc = kid_rank_n>.99 if inventor30!=.
gen top5pc = kid_rank_n>.95 if inventor30!=.
bys cohort inventor30: egen fcit_rank = rank(fcit) if inventor30==1
bys cohort inventor30: gen total = _N  if inventor30==1
replace fcit_rank = fcit_rank/total 
gen fcit_top5pc = fcit_rank>.95 & fcit_rank!=.
replace fcit_top5pc = . if inventor30==.
g par_bin = min(1+ floor(100*par_rank_n ), 100)
collapse (mean) inventor applicant grantee *30 top1pc top5pc fcit_top5pc (mean) par_fam_inc_mean = par_fam_inc (p50) par_fam_inc_p50 = par_fam_inc, by(par_bin) fast
saveold output_${v}/inventor_on_par_inc8084, replace


************
* Figure 2: Patent rates by race and ethnicity, NYC
************
*Reweighted to match whites on 3rd grade test scores
use data/nyc_10_${v}, clear
g inv_1k = inventor*1000
drop if ethn==. | ethn==1
decode ethn, gen(ethnicity)
keep if ~missing(par_rank) & ~missing(math3)
preserve
collapse (mean) inv_1k, by(ethnicity)
gen  weight = "none"
tempfile raw
save `raw'
restore
preserve
collapse (mean) inv_1k (count) n=stuid, by(ethnicity math_vin3)
reshape wide inv_1k n, i(math_vin3) j(ethnicity ) string
collapse (mean) inv_1k* [fw=nWhite]
gen  weight = "math3"
reshape long inv_1k, i(weight) j(ethnicity) string
tempfile math3
save `math3'
restore
xtile par_vin = par_rank, n(20)
collapse (mean) inv_1k (count) n=stuid, by(ethnicity par_vin)
reshape wide inv_1k n, i(par_vin) j(ethnicity ) string
collapse (mean) inv_1k* [fw=nWhite]
gen  weight = "par_vin"
reshape long inv_1k, i(weight) j(ethnicity) string
append using `math3'
append using `raw'
saveold output_${v}/race_reweighting, replace


************
* Figure 3: Percentage of Female Inventors by Birth Cohort
************
use raw/pat_idb_v6_db_indv, clear
gen female = gnd_ind =="F"
ren ssa_yob yob
collapse (mean) female (count) freq=tin, by(yob)
keep if freq>10
replace female = female*100
save output_${v}/female_by_cohort, replace


************
* Figure 4: Patent rates vs grade 3 math scores
************

use data/nyc_10_${v}, clear
gen inv_1k = inventor*1000
binscatter inv_1k math3, line(connect) savedata(output_${v}/nyc_inv_on_math3) savegraph(output_${v}/nyc_inv_on_math3)  replace yt(Inventors per Thousand) xt("3rd Grade Math Test Score (Standard Deviations Relative to Mean)")
drop if missing(par_rank)
gen p80 = par_rank>.8
binscatter inv_1k math3, line(connect) by(p80) savedata(output_${v}/nyc_inv_on_math3_bypar ) savegraph(output_${v}/nyc_inv_on_math3_bypar )  replace  yt(Inventors per Thousand) xt("3rd Grade Math Test Score (Standard Deviations Relative to Mean)")
binscatter inv_1k math3, n(10) line(connect) by(ethnicity) savedata(output_${v}/nyc_inv_on_math3_byrace) savegraph(output_${v}/nyc_inv_on_math3_byrace )  replace  yt(Inventors per Thousand) xt("3rd Grade Math Test Score (Standard Deviations Relative to Mean)")
// Panel C is sourced from the data for Table 2



************
* Figure 5:  Pct. of Gap in Patent Rates for Low vs. High-Inc. Students Explained
* by Test Scores in Grades 3-8
************
// This figure comes from the data for Table 2




************
* Figure 6: Patent rates and college attended
************
* Panel A is done with the public online table
* Panel B is binscatter versus parent income
use * if (cohort<=1984 & coinvent==0) using "/home/stataharvard/patents/draft2016/data/kids_10_v1_withcoll.dta", clear
bysort super_opeid_22: egen invperstud = mean(inventor)
bysort super_opeid_22: egen totalstud  = total(1)
keep if totalstud>2500
gsort - invperstud super_opeid_22
gen flag = super_opeid_22 != super_opeid_22[_n-1]
gen rank=sum(flag)
replace inventor = inventor*1000
keep if rank<=10
binscatter inventor par_rank_n if rank<=10, nq(20) savegraph(/home/stataharvard/patents/draft2016/output_v2/top10coll_inv_parinc) savedata(/home/stataharvard/patents/draft2016/output_v2/top10coll_inv_parinc) replace line(none) xt(Parent Rank) yt(Inventors per Thousand)




************
* Figure 7: Patent rates vs. class-level patent rates in childhood environment
************
// Panel A: Father
use data/kids_10_${v}, clear
keep if dad_inv==1 & coinvent==0
keep if $section2sample 
ren class_prim_dad class
ren class_prim_kid related_class
merge m:1 class related_class using ${patpath}/class_distance/class_distance_inside_v2, keep(match master) keepusing(share_inclass distance_rank) nogen

collapse (count) kids = kid_tin, by(distance_rank)
egen total_kids = total(kids)
gen density = kids/total_kids
drop kids total_kids
replace density = density*1000
* drop all the kids that weren't actually inventors that are already there in denom
drop if missing(distance_rank)

saveold output_${v}/distance_ownddad_class_8084, replace version(12)
// Panels B and C are produced in the code for Tables 3 & 4


************
* Figure 8: Patent rates by CZ where child grew up
************
// Uses Online Table


************
* Figure 9: Patent rates of children and adults in CZ
************
// Uses Online Table


************
* Figure 10: Percent of female inventors by origin
************
// Uses Online Table


************
* Figure 11: Income and Citations of Inventors by Characteristics at Birth
************
use data/nyc_10_${v}, clear
gen p80 = par_rank>.8 if ~missing(par_rank)
decode ethn, gen(ethnicity)
gen minority = inlist(ethnicity, "Black", "Hispanic") if ethnicity~="Native American"
keep if inventor==1
bys cohort: egen fcit_adj_rank = rank(fcit_adj)
bys cohort: gen n=_N
replace fcit_adj_rank = fcit_adj_rank/n
gen cittop5 = fcit_adj_rank>.95

ren kid_tin tin
merge 1:m tin using data/event_20_${v}, keep(match master) keepusing(tax_yr f1040_inc)
keep if tax_yr == 2012  

foreach var of varlist p80 minority female  {
preserve
global collapselist
foreach v of varlist math3 cittop5 f1040_inc {
global collapselist ${collapselist} (mean) `v'_mean=`v' (semean) `v'_semean=`v' (p50) `v'_p50=`v'
}
collapse ${collapselist} , by(`var')
drop if missing(`var')
tempfile `var'
save ``var''
restore
}
clear 
foreach var in  p80 minority female  {
append using ``var''
}
order p80 minority female
saveold output_${v}/hhjkpredictions, replace

* fcit_by_minority is from nyc sample -- use above file

* fcit_by_p80 is from kids_10
use data/kids_10_${v}, clear
keep if inventor==1 & inrange(cohort, 1980,1984)
gen p80 = par_rank>.8 if ~missing(par_rank)
bys cohort: egen fcit_adj_rank = rank(fcit_adj)
bys cohort: gen n=_N
replace fcit_adj_rank = fcit_adj_rank/n
gen cittop5 = fcit_adj_rank>.95
ren kid_tin tin
merge 1:m tin using data/event_20_${v}, keep(match master) keepusing(tax_yr f1040_inc)
keep if tax_yr == 2012  
collapse (mean) cittop5_mean=cittop5 (semean) cittop5_semean=cittop5 (mean) f1040_inc_mean=f1040_inc (semean) f1040_inc_semean=f1040_inc (p50) f1040_inc_p50=f1040_inc, by(p80)
saveold output_${v}/cittop5_by_p80, replace

* fcit_by_female is for the full sample 
use raw/pat_idb_v6_db_indv, clear
merge 1:m tin using raw/pat_idb_v6_110, nogen
merge m:1 patno using ${patpath}/idb/raw/fcit, nogen keepusing(fcit)
replace fcit = 0 if missing(fcit)
bys patno series: egen teamsize=total(1)
gen fcit_adj = fcit/teamsize
collapse (sum) fcit_adj, by(tin gnd_ind ssa_yob)
bys ssa_yob: egen fcit_adj_rank =  rank(fcit_adj)
bys ssa_yob: gen n = _N
replace fcit_adj_rank=fcit_adj_rank/n
gen cittop5pc=fcit_adj_rank>.95
gen female=gnd_ind=="F"
merge 1:m tin using data/event_20_${v}, keep(match master) keepusing(tax_yr f1040_inc)
keep if tax_yr == 2012  | _m==1
collapse (mean) cittop5_mean=cittop5 (semean) cittop5_semean=cittop5 (mean) f1040_inc_mean=f1040_inc (semean) f1040_inc_semean=f1040_inc (p50) f1040_inc_p50=f1040_inc , by(female)
saveold output_${v}/cittop5_by_female, replace





************************
************************
* Appendix Figures
************************
************************


************
* Appendix Figure 1: Sensitivity Analysis of Figure 1
************
* Panel A
* get all soi sample and their patents to see if they invented between age 23 and 40 in years 2001-2012
use ${patpath}/soi/mk_soix_v4a_print.dta, clear
bys cohort: cumul par_fam_inc [w=s006_matchyr], gen(par_rank_w), if par_fam_inc>0
ren kid_unmasked_tin unmasked_tin
preserve
use raw/pat_idb_v6_110, clear
keep if ~missing(unmasked_tin)
tempfile inventors_nomiss
save `inventors_nomiss'
restore
joinby unmasked_tin using `inventors_nomiss', unmatched(master)

bys unmasked_tin: egen badinventor = max(appyear-cohort < 23)
gen inventor = inrange(appyear, 2001,2012) & ~badinventor
gen inventor3040 = inrange(appyear-cohort, 30, 40) & inrange(appyear, 2001,2012) & ~badinventor

collapse (max) inventor inventor3040, by(unmasked_tin par_rank_w cohort dataset s006) fast

binscatter inventor3040 par_rank_w [w=s006] if cohort<=1972 , line(none) savedata(output_${v}/inventor3040_on_parinc) savegraph(output_${v}/inventor3040_on_parinc)  replace

* Panel B: see data for Figure 1

* Panel C
use data/nyc_10_${v}, clear
binscatter inventor par_rank, line(none) savedata(output_${v}/inventorvsparinc_nyc) savegraph(output_${v}/inventorvsparinc_nyc)  replace




************
* Appendix Figure 2: Probability of child ending up in top 1% and 5% in relation to parent income 
************

* See data for Figure 1


************
* Appendix Figure 3: Distribution of math test scores
************

* Panel A
use data/nyc_10_${v}, clear
gen p80 = par_rank>.8 if ~missing(par_rank)
keep if ~missing(par_rank) & ~missing(math3)
twoway kdensity math3 if p80== 0, bw(.12) legend(off) lwidth(medthick) range(-3 3) xlabel(-3 -2 -1 0 1 2 3) || kdensity math3 if p80 == 1, bw(.105) legend(off) xtitle("Grade 3 Math Scores (Standard Deviations Relative to Mean)") ytitle("Density") graphregion(fcolor(white)) lwidth(medthick) range(-3 3) xlabel(-3 -2 -1 0 1 2 3)    
graph save output_${v}/mathkd_byparinc, replace

* Panel B
use data/nyc_10_${v}, clear
gen p80 = par_rank>.8 if ~missing(par_rank)
keep if ~missing(math3)
twoway kdensity math3 if female== 0, bw(.105) legend(off) lwidth(medthick) range(-3 3) xlabel(-3 -2 -1 0 1 2 3) || kdensity math3 if female == 1, bw(.12) legend(off) xtitle("Grade 3 Math Scores (Standard Deviations Relative to Mean)") ytitle("Density") graphregion(fcolor(white)) lwidth(medthick) range(-3 3) xlabel(-3 -2 -1 0 1 2 3)    
graph save output_${v}/mathkd_bygender, replace


************
* Appendix Figure 4: Percentage of Female Inventors and Gender Stereotypes 
************
* Uses an Online Table


************
* Appendix Figure 5: Income of Inventors
************
* Panel A
use data/event_20_${v}, clear
keep if tax_yr==2005 & ~missing(q_mean_non_spouse)
replace mean_non_spouse = mean_non_spouse / 1000
sum mean_non_spouse, det
twoway kdensity mean_non_spouse if inrange(q_mean_non_spouse, 2, 99), xline(`r(p50)' `r(p95)' `r(p99)', lcolor(black) lpattern(dash)) yt(Density) xt("Individual Income ($1000)") graphregion(fcolor(white))
gr save output_${v}/fig14_mean_non_spouse_kd_2to99, replace

* Panel B
use data/event_20_${v}, clear
g temp = fcit if tax_yr==1996&applied_in_year==1
bys tin: egen fcit_1996 = mean(temp)
keep if tax_yr==2005
drop if missing(fcit_1996 ) | missing(mean_non_spouse)
codebook tin
replace mean_non_spouse = mean_non_spouse/1000
binscatter mean_non_spouse fcit_1996, savedata(output_${v}/mean_non_spouse_on_fcit_1996) savegraph(output_${v}/mean_non_spouse_on_fcit_1996) reportreg replace
* report this reg coeff as well
cap log close
log using output_${v}/figA16_mean_non_spouse_on_fcit_1996, replace
reg mean_non_spouse fcit_1996 if tax_yr==2005
log close
* show extra resolution in top bin
egen fcit_rank = rank(fcit_1996)
qui sum 
replace fcit_rank = fcit_rank/r(N)
xtile fcit_bin=fcit_1996, n(20) 
replace fcit_bin = 21 if fcit_rank>=.99
collapse (mean) fcit_rank mean_non_spouse fcit_1996, by(fcit_bin)
saveold output_${v}/mean_non_spouse_on_fcit_1996_21bins, replace version(12)







