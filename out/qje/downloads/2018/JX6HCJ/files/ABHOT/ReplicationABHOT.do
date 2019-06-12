
*When data file does not contain all hhea, will have to use this

use mistargeting_CORRECTED.dta, clear
collapse (mean) COMMUNITY HYBRID kecagroup, by(hhea) fast
sort kecagroup hhea COMMUNITY HYBRID
save Sample1, replace

keep hhea
sort hhea
gen N = _n
save Sample2, replace

*******************************************

*Table 3 - compressed code - results all correct

use mistargeting_CORRECTED.dta, clear
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
	}
areg CONSUMPTION COMMUNITY HYBRID if RTS==1, absorb(kecagroup) cluster(hhea) 

capture drop _m
capture drop N
sort hhea
merge hhea using Sample2
drop _m
sort hhea
save DatABHOT1, replace

*******************************************

*Table 4 - compressed code - results all correct

use consumption.dta, clear
keep hhea hhid CONSUMPTION
merge hhid using rthead.dta, sort
drop _m
destring hhea, replace
drop if RTHEAD==1
bysort hhea: egen cons_rank=rank(CONSUMPTION), field
drop if cons_rank==8 | cons_rank==1
collapse (max) CONSUMPTION2=CONSUMPTION (min) CONSUMPTION7=CONSUMPTION, by(hhea)
gen inequality=log(CONSUMPTION2/CONSUMPTION7)
egen medinequal = median (inequality)
sort hhea
tempfile e3
save `e3', replace

use hh_cr01.dta, clear
bys hhid:gen HHRELATED =_N
label var HHRELATED "Number of households in RT you are related to"
keep hhid HHRELATED
bys hhid: keep if _n==1
gen connected=1
label var connected "Have a family connection with at least one other HH in RT"
rename hhid hhid_suseti
sort hhid_suseti
tempfile a
save `a'

use mistargeting_CORRECTED.dta, clear
capture drop _m
sort hhid_suseti
merge hhid_suseti using `a'
tab _m
replace HHRELATED=0 if _m==1
replace connected=0 if _m==1
drop _m
bys hhea: gen nhhvillage =_N 
gen share_related = HHRELATED/nhhvillage
egen general_connectedness = mean (share_related), by(hhea)
egen medianconnectedness = median(general_connectedness)
gen connectedness_dummy = (general_connectedness>= medianconnectedness)
gen COMMUNITY_connectedness_dummy = COMMUNITY * connectedness_dummy
gen HYBRID_connectedness_dummy = HYBRID * connectedness_dummy

gen urban_dummy = 2 - klas
gen COMMUNITY_URBAN = COMMUNITY*urban_dummy
gen HYBRID_URBAN = HYBRID*urban_dummy
sort hhea
merge hhea using `e3'
tab _m
drop _m
gen highINEQUALdummy = (inequality>=medinequal)
gen COMMUNITY_highINEQUALdummy=COMMUNITY*highINEQUALdummy
gen HYBRID_highINEQUALdummy=HYBRID*highINEQUALdummy

foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	areg `k' COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy, absorb(kecagroup) cluster(hhea)
	}
areg CONSUMPTION COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy if RTS==1, absorb(kecagroup) cluster(hhea) 

capture drop _m
capture drop N
sort hhea
merge hhea using Sample2
drop _m
sort hhea
save DatABHOT2, replace


**************************************


*Table 6 - Part I - All okay
*Simplified version of their code - remove extraneous analysis and rearrangements
*Run everything as an areg, no need to generate the dummies that they do - produces same results
*They forget to cluster some regressions

use satisfaction_community.dta, clear

foreach k in e_q6 e_q8 e_q14 e_q15num e_q17num {
	if ("`k'" == "e_q6" | "`k'" == "e_q8") {
		areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
		}
	local j = `j' + 2
	local i = `i' + 1
	}

sort kecagroup hhea COMMUNITY HYBRID
merge kecagroup hhea COMMUNITY HYBRID using Sample1
tab _m
drop _m

capture drop _m
capture drop N
sort hhea
merge hhea using Sample2
drop _m
sort hhea
save DatABHOT3a, replace


*************************************

*Table 6 - Part II - All okay

*Technically speaking, this really isn't a stacked regression (which would need kecagroup entered for each variable)
*But, this is how they actually run this particular regression

use satisfaction_community.dta, clear	
	expand 5
	bys hhid: egen subhousehold = seq()
	sort hhid
	gen indic_1 = 0
	replace indic_1 = 1 if subhousehold ==1
	gen outcome = e_q6 if indic_1 == 1
	gen indic_2 = 0
	replace indic_2 = 1 if subhousehold ==2
	replace outcome = e_q8 if indic_2 == 1
	gen indic_3 = 0
	replace indic_3 = 1 if subhousehold ==3
	replace outcome = e_q14 if indic_3 == 1
	gen indic_4 = 0
	replace indic_4 = 1 if subhousehold ==4
	replace outcome = e_q15num if indic_4 == 1
	gen indic_5 = 0
	replace indic_5 = 1 if subhousehold ==5
	replace outcome = e_q17num if indic_5 == 1
	foreach X of var indic_1 indic_2 indic_3 indic_4 indic_5 {
			gen `X'_COMMUNITY = `X'*COMMUNITY
			gen `X'_HYBRID = `X'*HYBRID	
	}
	  
	local COMMUNITY "indic_1_COMMUNITY indic_2_COMMUNITY indic_3_COMMUNITY indic_4_COMMUNITY indic_5_COMMUNITY"
	local HYBRID "indic_1_HYBRID indic_2_HYBRID indic_3_HYBRID indic_4_HYBRID indic_5_HYBRID"
	
	areg outcome indic_? `COMMUNITY' `HYBRID', absorb(kecagroup) cluster(hhea)
	testparm indic*_COMMUNITY
	testparm indic*_HYBRID

	areg outcome `COMMUNITY' `HYBRID' indic_2-indic_5, absorb(kecagroup) cluster(hhea)

*********************************************************

*Table 6 - Part III - All okay

*Table 6 - continued 
*Their code runs part of this as areg and part with dummies for each kecagroup (identical obviously)
*Clusters four of the regressions, but not the others - also, there is only one observation per cluster (= robust)
*Simplified code - reproduces their results - run everything as an areg

use satisfaction_rthead.dta, clear

foreach k in c_q3 c_q11a D_add D_subtract ncomplain ndontagree ncomplain_receivedbyRT a_q7 method_meeting {
	if "`k'" ~= "D_add" & "`k'" ~= "D_subtract" & "`k'" ~= "a_q7" & "`k'" ~= "method_meeting" {
		areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
		}
	}

capture drop _m
capture drop N
sort hhea
merge hhea using Sample2
drop _m
sort hhea
save DatABHOT3b, replace

*********************************************************************

*Table 6 - Part IV - Completely in error - couldn't find a way to match their results in table

*These two regressions (last column of bottom two panels) contain large error
*They create observations by sequence in hhid, but hhid is not unique, so end up dropping many observations
*Moreover, can't get anywhere near their results (bottom panel - top panel p value is zero).
*So, this can't actually be the code used to produce table in paper
*What follows is a shortened form, but is their public use code

	use satisfaction_rthead.dta, clear	
	expand 4
	bys hhid: egen subhousehold = seq()
	sort hhid
	gen indic_1 = 0
	replace indic_1 = 1 if subhousehold ==1
	gen outcome = c_q3 if indic_1 == 1
	gen indic_2 = 0
	replace indic_2 = 1 if subhousehold ==2
	replace outcome = c_q11a if indic_2 == 1
	gen indic_3 = 0
	replace indic_3 = 1 if subhousehold ==3
	replace outcome = D_add if indic_3 == 1
	gen indic_4 = 0
	replace indic_4 = 1 if subhousehold ==4
	replace outcome = D_subtract if indic_4 == 1
	foreach X of var indic_1 indic_2 indic_3 indic_4 {
			gen `X'_COMMUNITY = `X'*COMMUNITY
			gen `X'_HYBRID = `X'*HYBRID	
	}
	  
	local COMMUNITY "indic_1_COMMUNITY indic_2_COMMUNITY indic_3_COMMUNITY indic_4_COMMUNITY"
	local HYBRID "indic_1_HYBRID indic_2_HYBRID indic_3_HYBRID indic_4_HYBRID"
	
	areg outcome indic_? `COMMUNITY' `HYBRID', absorb(kecagroup) cluster(hhea)
	testparm indic*_COMMUNITY
	testparm indic*_HYBRID

	use satisfaction_rthead.dta, clear	
	expand 5
	bys hhid: egen subhousehold = seq()
	sort hhid
	gen indic_1 = 0
	replace indic_1 = 1 if subhousehold ==1
	gen outcome = ncomplain if indic_1 == 1
	gen indic_2 = 0
	replace indic_2 = 1 if subhousehold ==2
	replace outcome = ndontagree if indic_2 == 1
	gen indic_3 = 0
	replace indic_3 = 1 if subhousehold ==3
	replace outcome = ncomplain_received if indic_3 == 1
	gen indic_4 = 0
	replace indic_4 = 1 if subhousehold ==4
	replace outcome = a_q7 if indic_4 == 1
	gen indic_5 = 0
	replace indic_5 = 1 if subhousehold ==5
	replace outcome = method_meeting if indic_5 == 1
	foreach X of var indic_1 indic_2 indic_3 indic_4 indic_5 {
		gen `X'_COMMUNITY = `X'*COMMUNITY
		gen `X'_HYBRID = `X'*HYBRID	
	}
	  
	local COMMUNITY "indic_1_COMMUNITY indic_2_COMMUNITY indic_3_COMMUNITY indic_4_COMMUNITY indic_5_COMMUNITY"
	local HYBRID "indic_1_HYBRID indic_2_HYBRID indic_3_HYBRID indic_4_HYBRID indic_5_HYBRID"
	
	areg outcome indic_? `COMMUNITY' `HYBRID', absorb(kecagroup) cluster(hhea)
	testparm indic*_COMMUNITY
	testparm indic*_HYBRID

*Try doing this using hhea expansion, but still can't reproduce their results

	use satisfaction_rthead.dta, clear	
	expand 5
	bys hhea: egen subhousehold = seq()
	sort hhea
	gen indic_1 = 0
	replace indic_1 = 1 if subhousehold ==1
	gen outcome = ncomplain if indic_1 == 1
	gen indic_2 = 0
	replace indic_2 = 1 if subhousehold ==2
	replace outcome = ndontagree if indic_2 == 1
	gen indic_3 = 0
	replace indic_3 = 1 if subhousehold ==3
	replace outcome = ncomplain_received if indic_3 == 1
	gen indic_4 = 0
	replace indic_4 = 1 if subhousehold ==4
	replace outcome = a_q7 if indic_4 == 1
	gen indic_5 = 0
	replace indic_5 = 1 if subhousehold ==5
	replace outcome = method_meeting if indic_5 == 1
	foreach X of var indic_1 indic_2 indic_3 indic_4 indic_5 {
		gen `X'_COMMUNITY = `X'*COMMUNITY
		gen `X'_HYBRID = `X'*HYBRID	
	}
	  
	local COMMUNITY "indic_1_COMMUNITY indic_2_COMMUNITY indic_3_COMMUNITY indic_4_COMMUNITY indic_5_COMMUNITY"
	local HYBRID "indic_1_HYBRID indic_2_HYBRID indic_3_HYBRID indic_4_HYBRID indic_5_HYBRID"
	
	areg outcome indic_? `COMMUNITY' `HYBRID', absorb(kecagroup) cluster(hhea)
	testparm indic*_COMMUNITY
	testparm indic*_HYBRID

*So, skip this part since code error and can't find a way to reproduce reported results (bottom panel)

****************************

*Table 7 - Column 1 - All okay

use satisfaction_rthead.dta, clear
areg probattend COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
capture drop _m
capture drop N
sort hhea
merge hhea using Sample2
drop _m
sort hhea
save DatABHOT3, replace

***************************

*Table 7 - Remaining columns - errors in columns 3 and 4 on some coefficients
*This reproduces their code (they have a lot of prelimnary code, but I checked and it does nothing for these regressions
*i.e, (a) if run with all the preliminary code get exactly same coefficients; (b) examination of code shows it has nothing to do with these

use mistargeting_CORRECTED.dta, clear
areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
areg MISTARGETDUMMY COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
areg MISTARGETDUMMY COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
areg RTS COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
areg RTS COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)

capture drop _m
capture drop N
sort hhea
merge hhea using Sample2
drop _m
sort hhea
save DatABHOT4, replace

**************************************

*Table 8 - All okay - some inaccuracies in reported specification and actual specification

use mistargeting_CORRECTED.dta, clear
keep kecagroup hhid_exp MISTARGETDUMMY RTS hhea
rename hhid_exp hhid
sort hhid
save temp, replace
use analysis8.dta, clear
drop hhea
sort hhid
merge hhid using temp.dta
drop _merge
preserve
keep hhea kecagroup
keep if kecagroup!=.
sort hhea
collapse (max) kecagroup, by(hhea)
sort hhea
save temp2, replace
restore
drop kecagroup
sort hhea
merge hhea using temp2.dta
drop _merge
destring hhea, replace
sort hhea
merge hhea using temp_treatmentstatus.dta
tab _merge
gen random_rankHYB=random_rank*HYBRID
drop if hhea == .
save aq, replace

use aq, clear
collapse (mean) nhh kecagroup HYBRID (sd) sd = nhh, by(hhea) fast
sum
drop sd
expand nhh
bysort hhea: gen rank = _n/nhh
sort hhea rank
save abc, replace

use aq, clear
drop if random_rank == .
gen rank = random_rank
sort hhea rank
drop _m
merge hhea rank using abc
tab _m
drop _m

*double checking
egen m = group(hhea)
sum m
drop m

areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
areg RTS random_rankHYB random_rank, absorb(kecagroup) cluster(hhea)

*Note last column doesn't include HYBRID (should, but doesn't).  If include doesn't match reported table - error in their code
*Note coefficient becomes insignificant when HYBRID is added, as in reported, but not used, specification
areg RTS random_rank random_rankHYB HYBRID, absorb(kecagroup) cluster(hhea)
*Note second column does include HYBRID.  If don't doesn't match table
areg MISTARGETDUMMY random_rank random_rankHYB, absorb(kecagroup) cluster(hhea)

capture drop _m
capture drop N
sort hhea
merge hhea using Sample2
drop _m
sort hhea
save DatABHOT5, replace


************************************

*Table 9 - All okay

use rankcorrelation.dta, clear
foreach k in RANKCORRTREATCONSUMPTION_main RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	areg `k' COMMUNITY HYBRID, absorb(kecagroup)
	}
capture drop _m
capture drop N
sort hhea
merge hhea using Sample2
drop _m
sort hhea
save DatABHOT6, replace

***********************************************

*Table 10 - 1st part - All okay

use satisfaction_rthead.dta, clear
areg prob_total_HHattend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
areg probattend COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
areg swomen_attend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
capture drop _m
capture drop N
sort hhea
merge hhea using Sample2
drop _m
sort hhea
save DatABHOT7, replace

**************************************************************************

*Table 10 - 2nd part - All okay
use mistargeting_CORRECTED.dta, clear
areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)  cluster(hhea)
capture drop _m
capture drop N
sort hhea
merge hhea using Sample2
drop _m
sort hhea
save DatABHOT8, replace


*****************************************************

*Table 10 - 3rd part - All okay
use rankcorrelation.dta, clear
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)
	}
capture drop _m
capture drop N
sort hhea
merge hhea using Sample2
drop _m
sort hhea
save DatABHOT9, replace

***************************************************

capture erase abc.dta
capture erase aq.dta
capture erase temp.dta
capture erase temp2.dta



