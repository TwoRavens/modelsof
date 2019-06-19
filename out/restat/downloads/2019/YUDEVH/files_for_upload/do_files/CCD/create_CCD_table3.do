*CREATE TABLE 3 -inputs cleaned_combined_ccd.dta, census90.dta, vote_data1.dta

clear
set more off
set matsize 500


*CHANGE THE FOLLOWING DIRECTORIES TO BE YOUR DIRECTORIES;
global tabs	"";
global data "";

capture log using "{tabs}create_CCD_table3.log", replace

/// Merge District Level Data and Vote Data ///

use "${data}cleaned_combined_ccd", clear

* change county fips code
replace ccode=12086 if ccode==12025
replace ccode = 19187 if ccode==19184

* sample restriction
egen temp = count(ncesid) if great_recession==0 & KS_KY_MO_TX_MI_WY==0, by(ncesid)
drop if temp==1

* identify and drop duplicate districts. 
sort ncesid year
egen tag = tag(ncesid)
keep if tag==1 & great_recession==0 & KS_KY_MO_TX_MI_WY==0

* merge district level characteristics
sort ccode
merge m:1 ncesid using "${data}census90"
drop if _merge==2
drop _merge

sort ccode
merge m:1 ccode using "${data}vote_data1"
drop if _merge==2
drop _merge

gen nwhite_90 = 1-white_90

* 1984-1992 County-level Democratic Vote Shares 
gen w=1
replace tvote84=0.0001 if tvote84==.|tvote84==0
replace tvote88=0.0001 if tvote88==.|tvote88==0
replace tvote92=0.0001 if tvote92==.|tvote92==0

save temp_btest1, replace

/// Merge District Level Data and Vote Data ///

use "${data}cleaned_combined_ccd", clear

*CREATE STATE-YEAR VARIABLE
gen state_yr = fipst*year

nsplit ccode, digits(2, 3) gen(fipst1 ccode1)

*MAKE ONE CHANGE TO COUNTY CODE
replace ccode1 = 186 if ccode1==193 & ccode==29193

* Merge Distance to State Border
mmerge fipst ccode1 using "${data}distance_data_revised", t(n:1)
drop if _merge~=3

* Merge Border Counties;
mmerge ccode using "${data}border_counties", t(n:1)
drop if _merge==2


/*DROP COUNTIES THAT BORDER MI, MO, TX, KS, KY, WY - but keep the 5 borders that have no variation in upm3 because in one of the states
the one bordering county is assigned to a different border (for example, keep Franklin County, MA)*/
egen temp=sd(upm3), by(border_id)
drop if temp==0 & (strpos(border_name,"MO")~=0 | strpos(border_name,"TX")~=0 | strpos(border_name,"KS")~=0 | strpos(border_name,"KY")~=0 | strpos(border_name,"MI")~=0 | strpos(border_name,"WY")~=0)	

drop _merge
drop temp

* change county fips code
replace ccode=12086 if ccode==12025
replace ccode = 19187 if ccode==19184
rename border_id border

* sample restriction
egen temp = count(ncesid) if great_recession==0 & KS_KY_MO_TX_MI_WY==0, by(ncesid)
drop if temp==1

* identify and drop duplicate districts. 
sort ncesid year
egen tag = tag(ncesid)
keep if tag==1 & great_recession==0 & KS_KY_MO_TX_MI_WY==0

* merge district level characteristics
sort ccode
merge m:1 ncesid using "${data}census90"
drop if _merge==2
drop _merge

sort ccode
merge m:1 ccode using "${data}vote_data1"
drop if _merge==2
drop _merge

gen nwhite_90 = 1-white_90

* 1984-1992 County-level Democratic Vote Shares 
gen w=1
replace tvote84=0.0001 if tvote84==.|tvote84==0
replace tvote88=0.0001 if tvote88==.|tvote88==0
replace tvote92=0.0001 if tvote92==.|tvote92==0


save temp_btest2, replace

use temp_btest1, clear

/// 1. Entire sample (no border restrictions) ///

* local macro for covariates
local vote_years 84 88 92
local outcome tpop_90 pop_den1990 thh_90 medhhinc_90 nwhite_90 ///
ppov_90 unemp_90 pop65_90 lths_90 hs_90 scol_90 ///
coll_90 own_90 


* 1984-1992 County-level Democratic Vote Shares with Border Fixed Effect

	foreach z in `vote_years' {
	reghdfe pdem`z' upm3 [w=tvote`z'], absorb(w) cluster(fipst)
	}

* 1990 District Level Variables

	foreach y in `outcome' {
	reghdfe `y' upm3 if tag==1, ab(w) cluster(fipst)
	}

/// Distance<50 ///
	
use temp_btest2, clear
	
keep if distance<50

* 1984-1992 County-level Democratic Vote Shares with Border Fixed Effect

	foreach z in `vote_years' {
	reghdfe pdem`z' upm3 [w=tvote`z'], absorb(border) cluster(fipst border)
	}

* 1990 District Level Variables

	foreach y in `outcome' {
	reghdfe `y' upm3, ab(border) cluster(fipst border)
	}

/// Border Counties ///

use temp_btest2, clear
keep if bcounty==1

* local macro for covariates
local vote_years 84 88 92
local outcome tpop_90 pop_den1990 thh_90 medhhinc_90 nwhite_90 ///
ppov_90 unemp_90 pop65_90 lths_90 hs_90 scol_90 ///
coll_90 own_90  

* 1984-1992 County-level Democratic Vote Shares with Border Fixed Effect

	foreach z in `vote_years' {
	reghdfe pdem`z' upm3 [w=tvote`z'], absorb(border) cluster(fipst border)
	}

* 1990 District Level Variables

	foreach y in `outcome' {
	reghdfe `y' upm3, ab(border) cluster(fipst border)
	}

	
log close
