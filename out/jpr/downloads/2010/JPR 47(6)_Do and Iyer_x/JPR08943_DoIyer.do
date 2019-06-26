set more off
capture log close
clear
cd c:\asha\nepal\data
log using c:/asha/Nepal/prog/JPR09943_DoIyer.log, replace

use JPR08943_DoIyer.dta, clear

keep distname regcode norm_nkilled_96_06 norm_nkilled_state_96_06 norm_nkilled_maoist_96_06 over100_2002 over100_2003 over100_2004 over100_2005 over100_2006 over150 elevation_max norm_forest pov_rate infant_mortality_rate  tot_lit_91 norm_area_road_90 caste_polar advantaged_caste lin_polar



/***LABELLING TO BE DONE****/
label var norm_nkilled_96_06 "Conflict deaths per 1000 population"
label var pov_rate "Poverty rate 1995-96"
label var norm_nkilled_maoist_96_06 "Deaths caused by Maoists per 1000 population"
label var norm_nkilled_state_96_06 "Deaths caused by state per 1000 population"
label var over100_2002  "More than 100 killed by 2002"
label var over100_2003  "More than 100 killed by 2003"
label var over100_2004  "More than 100 killed by 2004"
label var over100_2005  "More than 100 killed by 2005"
label var over100_2006  "More than 100 killed by 2006"
label var over150  "Dummy for more than 150 killed"
label var elevation_max "Maximum elevation ('000 meters)" 
label var norm_forest  "Proportion of forested area"
label var infant_mortality_rate   "Infant Mortality Rate "
label var tot_lit_91  "Literacy 1991 (%)"
label var norm_area_road_90  "Road length per sq km"
label var caste_polar  "Caste polarization"
label var advantaged_caste  "Proportion of advantaged castes"
label var lin_polar "Linguistic polarization"

save, replace


/********TABLE 1: SUMMARY STATISTICS***/
summ norm_nkilled_96_06 norm_nkilled_state_96_06 norm_nkilled_maoist_96_06 over100_2006 over150 elevation_max norm_forest pov_rate infant_mortality_rate  tot_lit_91 norm_area_road_90 caste_polar advantaged_caste lin_polar



/*******************************************************************************************/
/****TABLE 2 regressions for normalized total killed***/
/*******************************************************************************************/

local rhs_1 elevation_max norm_forest
local rhs_2 elevation_max norm_forest pov_rate
local rhs_3 elevation_max norm_forest  pov_rate advantaged_caste
local rhs_4 elevation_max norm_forest pov_rate caste_polar 
local rhs_5 elevation_max norm_forest tot_lit_91 advantaged_caste 
local rhs_6 elevation_max norm_forest norm_area_road_90 advantaged_caste 

**table 2, column 1
regress norm_nkilled_96_06 `rhs_1' if distname!="Rukum", robust

***table 2, columns 2, 3, 4, 7, 8
forvalues right=2/6{
	regress norm_nkilled_96_06 `rhs_`right'' if distname!="Rukum", robust
}

***table 2, columns 5, 6
/***deaths caused by state and maoist***/
regress norm_nkilled_state_96_06 `rhs_3' if distname!="Rukum", robust
regress norm_nkilled_maoist_96_06 `rhs_3' if distname!="Rukum", robust

****APPENDIX TABLE 1: ROBUSTNESS CHECKS

***column 1
regress norm_nkilled_96_06 elevation_max norm_forest pov_rate lin_polar if distname!="Rukum", robust
***column 2
regress norm_nkilled_96_06 elevation_max norm_forest infant_mortality_rate advantaged_caste if distname!="Rukum", robust
/***column 3: including Rukum***/
regress norm_nkilled_96_06 `rhs_3', robust
/***column 4: excluding Rolpa and Rukum***/
regress norm_nkilled_96_06 `rhs_3' if distname!="Rukum" & distname!="Rolpa", robust
/***column 5: excluding Rolpa and Rukum and Kalikot***/
regress norm_nkilled_96_06 `rhs_3' if distname!="Rukum" & distname!="Rolpa" & distname!="Kalikot", robust
***column 5: regional clustering 
regress norm_nkilled_96_06 `rhs_3' if distname!="Rukum", cluster(regcode)
/***column 6: region fixed effects****/
xi i.regcode
regress norm_nkilled_96_06 `rhs_3' _Iregcode_* if distname!="Rukum", robust
***column 9
probit over100_2006 `rhs_3' if distname!="Rukum", robust
***column 10
probit over150 `rhs_3' if distname!="Rukum", robust

/** column 8: adjusting for spatial correlation****/

sort distname
merge distname using distance_ktm_latlong.dta
tab _merge
drop _merge

drop if distname=="Rukum"
keep if pov_rate~=.

spatwmat, name(spwt1) xcoord(latitude_mean) ycoord(longitude_mean) band(0 1.5) eigenval(speigen1)
spatreg norm_nkilled_96_06 elevation_max norm_forest pov_rate advantaged_caste, weights(spwt1) eigenval(speigen1) model(error) robust

/****Table III: COX DURATION MODELS FOR OVER HUNDRED DUMMY****************/
use JPR08943_DoIyer.dta, clear

local rhs_1 elevation_max norm_forest
local rhs_2 elevation_max norm_forest pov_rate
local rhs_3 elevation_max norm_forest  pov_rate advantaged_caste
local rhs_4 elevation_max norm_forest pov_rate caste_polar 
local rhs_5 elevation_max norm_forest tot_lit_91 advantaged_caste 
local rhs_6 elevation_max norm_forest norm_area_road_90 advantaged_caste 

gen failtime=2002 if over100_2002==1
replace failtime=2003 if over100_2002==0&over100_2003==1
replace failtime=2004 if over100_2003==0& over100_2004==1
replace failtime=2005 if over100_2004==0& over100_2005==1
replace failtime=2006 if over100_2005==0& over100_2006==1

gen failtimeref=failtime
replace failtimeref=2007 if failtimeref==.

replace failtime=failtime-1999
label var failtime "Year of crossing 100 deaths - 1999"

/**setting the data in survival format***/
stset failtime

/***Cox models for onset of conflict on the same lines as Table 2 for conflict intensity***/

forvalues right=1/6{
	stcox `rhs_`right'' if distname!="Rukum", nohr 
	}



*****APPENDIX TABLE 2: ROBUSTNESS CHECKS

***column 1
regress failtimeref `rhs_3' if distname!="Rukum", robust
***column 2
ologit failtimeref `rhs_3' if distname!="Rukum", vce(robust)
***column 3
regress failtimeref `rhs_4' if distname!="Rukum", robust
***column 4
ologit failtimeref `rhs_4' if distname!="Rukum", vce(robust)
