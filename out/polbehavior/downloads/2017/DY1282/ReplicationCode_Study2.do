* Cecilia Mo
* March 13, 2017
* Replication File for Political Behavior
* Study 2
* Relevant Input Data Files: c2_nlss_public.dta, trafficking_nepal.dta, district_char.dta, Z01A.dta, Z07A.dta, conflict.dta
* Cleaned Final Data File: Study2_FINAL.dta


*******************************************************************************************************************
**** DATA CREATION
*******************************************************************************************************************

/***** Census Data *****/
* Source: NLSS 2003-2004
* Install egen_inequal package

use c2_nlss_public.dta, clear

sort district
by district: egen npcexp_75 = pctile(npcexp), p(75)
by district: egen npcexp_25 = pctile(npcexp), p(25)
gen npcexp_2575 = npcexp_25 / npcexp_75
gen npcexp_7525 = npcexp_75 / npcexp_25

by district: egen npcfexp_75 = pctile(npcfexp), p(75)
by district: egen npcfexp_25 = pctile(npcfexp), p(25)
gen npcfexp_2575 = npcfexp_25 / npcfexp_75
gen npcfexp_7525 = npcfexp_75 / npcfexp_25

egen gini = gini(npcexp), by(district) weights(weight)
egen gini2 = gini(npcfexp), by(district) weights(weight)

by district: egen consumptionmean = mean(npcexp)
by district: egen foodconsumptionmean = mean(npcfexp)

save Study2.dta, replace

coll2 (mean) meannpcexp = npcexp meannpcfexp = npcfexp (median) medcons=npcexp medfcons=npcfexp (p25) npc25=npcexp npcf25=npcfexp (p75) npc75=npcexp npcf75=npcfexp [weight=weight], by(district)
sort district
save income_collapsed.dta, replace

use Study2.dta, clear
merge m:1 district using income_collapsed.dta
save Study2_merged.dta, replace

coll2 (count) poorcount = poor (sum) poorsum = poor [weight=weight], by(district)
gen poorshare = poorsum/poorcount
sort district
save poor_collapsed.dta, replace

use Study2_merged.dta, clear
drop _merge
merge m:1 district using poor_collapsed.dta
save Study2_merged2.dta, replace


/***** Merging in Trafficking Hot Spot Date *****/
*Source: Women's Cell of Nepal's Police: 2003-2007

sort district
drop _merge
merge m:1 district using trafficking_nepal.dta
save Study2_merged3.dta, replace


/**** Merging in District Characteristics ****/
* Source: Scraped from the following book based on the NLSS 2003-2004 data: 
* "District profile of Nepal, 2007/2008: A socio-economic development data base of Nepal"

sort districtname
drop _merge
merge m:1 districtname using district_char.dta
drop if _merge != 3
label var population "Population in 2001"
save Study2_merged4.dta, replace


/**** Merging in Literacy Data ****/
* Source: NLSS 2003-2004

use Z01A.dta, clear
sort WWWHH WWW HH IDC
merge 1:1 WWWHH WWW HH IDC using Z07A.dta

g literate = .
replace literate = 0 if V01A_05 >= 6 & V07A_02 == 2 & V07A_03 == .
replace literate = 0 if V01A_05 >= 6 & V07A_02 == 1 & V07A_03 == 2
replace literate = 1 if V01A_05 >= 6 & V07A_02 == 1 & V07A_03 == 1

sort WWWHH WWW HH IDC
by WWWHH: egen adult_count = count(V01A_05) if V01A_05 >= 6
by WWWHH: egen adult_count2 = max(adult_count)

by WWWHH: egen literate_count = count(literate) if literate == 1
by WWWHH: egen illiterate_count = count(literate) if literate == 0
by WWWHH: egen illiterate_count2 = max(illiterate)
by WWWHH: egen literate_count2 = max(literate_count) 

g literacy_share = literate_count2 / adult_count2
replace literacy_share = 0 if literacy_share == . & illiterate_count2 != .
keep WWWHH WWW HH adult_count2 literate_count2 literacy_share
drop if WWWHH == WWWHH[_n-1]
sort WWWHH
save literate.dta, replace

use Study2_merged4.dta, clear
sort WWWHH
drop _merge
merge 1:1 WWWHH using literate.dta
save Study2_merged5.dta, replace

sort district
coll2 (mean) literacymean = literacy_share [weight=weight], by(district)
save literate_mean.dta, replace

use Study2_merged5.dta, clear
drop _merge
merge m:1 district using literate_mean.dta
save Study2_merged6.dta, replace


/***** Merging in Data on Conflict Affectedness *****/
* Civil Conflict Between 1996 and 2006
* Source: http://www.satp.org/satporgtp/countries/nepal/database/conflictmap.htm

sort district
drop _merge
merge m:1 districtname using conflict.dta
label define conflict 1 "Less Affected" 2 "Moderately Affected" 3 "Highly Affected"
label val conflict conflict
save Study2_merged7.dta, replace


/***** Recode Variables to be Between 0 and 1 *****/
g trafficking2 = trafficking/6
g mu_gini_raw = meannpcexp*gini
g mu_gini = (mu_gini_raw- 974.2546)/27225.565
g mu_gini2 = mu_gini*mu_gini
g gini_2 = (gini-.1386965) / .4300975
g meannpcexp2 = (meannpcexp - 7024.364)/ 51418.186
g poorshare2 = (poorshare) / .8333333 
g literacymean2 = (literacymean - .1869733)/.5890116
g conflict2 = (conflict-1)/2
g telephone_lines2 = telephone_lines/180000
g road_km2 = road_km/1507
g population2 = (population-9587)/1072258

drop _merge
sort district
drop if district == district[_n-1]
save Study2_FINAL.dta, replace


*******************************************************************************************************************
**** REPLICATION CODE FOR STUDY 2 RESULTS
*******************************************************************************************************************

*** TABLE 3
set more off
reg trafficking2 mu_gini mu_gini2 meannpcexp2 poorshare2, robust
outreg2 using nlss_inequality_ols.tex, bdec(2) sdec(2) rdec(2) adjr2 replace
xi: reg trafficking2 mu_gini mu_gini2 meannpcexp2 poorshare2 literacymean2 conflict2 telephone_lines2 road_km2 population2 i.belt, robust
outreg2 using nlss_inequality_ols.tex, bdec(2) sdec(2) rdec(2) adjr2 append


*** TABLE B.5
tab belt, gen(belt_v2)
su trafficking gini mu_gini meannpcexp poorshare literacymean conflict telephone_lines road_km population belt_v21 belt_v22 belt_v23 if trafficking != .


*** APPENDIX TABLE B.6
set more off
ologit trafficking2 mu_gini mu_gini2 meannpcexp2 poorshare2, robust
outreg2 using nlss_inequality_ologit.tex, bdec(2) sdec(2) rdec(2) replace
ologit trafficking2 mu_gini mu_gini2 meannpcexp2 poorshare2 literacymean2 conflict2 telephone_lines2 road_km2 population2 i.belt, robust
outreg2 using nlss_inequality_ologit.tex, bdec(2) sdec(2) rdec(2) append


*** FIGURE 5 
pwcorr trafficking2 mu_gini if mu_gini<0.5, sig
* 3 relative deprivation outliers omitted for the figure
twoway (scatter trafficking2 mu_gini if mu_gini<0.5, msize(small) legend(size(small) label (1 "Reported Trafficking Incidents Level") label (2 "LOWESS")) scheme(s2mono) graphregion(fcolor(white)) msize(small) ytitle("Reported Trafficking Incidence Level") xtitle("Relative Deprivation (Gini)", margin(medsmall) size(small))) (lowess trafficking2 mu_gini if mu_gini<0.5)
graph export mugini.tif, replace


*** FIGURE 6
rename _Ibelt_2 hill
rename _Ibelt_3 terai
rename meannpcexp2 Income
rename poorshare2 Poverty
rename conflict2 Conflict
rename telephone_lines2 Telephone
rename road_km2 Road
rename population2 Population
rename hill Hill
rename terai Terai
rename literacymean2 Literacy
rename mu_gini2 Relative_Deprivation_Squared

set more off
gsa trafficking2 gini_2 Income Poverty Literacy Conflict Telephone Road Population Hill Terai, tstat(1.645) nplots(10) lowess maxc1(2) maxc2(2)
