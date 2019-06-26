
*% set working directory here

cd "/Users/Lauren/Dropbox/Haiti PKO project/14 Replication files/"
use "Data/HaitiPKOData.dta", clear
set more off

encode site, gen(site_fac)
egen enum_fac=cut(enum), at(2(1)12)


*%*%*%*%*%* 
*% crime report - security
*%*%*%*%*%*

reg coop_crime_report_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

set matsize 1000

capture matrix drop coeffs

local r = 0.2769*2.2

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_security_me set, delta(`d') rmax(`r') model(reg coop_crime_report_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(secc)


*%*%*%*%*%* 
*% crime report - abuse
*%*%*%*%*%*


reg coop_crime_report_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_abuse set, delta(`d') rmax(`r') model(reg coop_crime_report_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(badc)


*%*%*%*%*%* 
*% crime report - relief
*%*%*%*%*%*

reg coop_crime_report_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_food_me set, delta(`d') rmax(`r') model(reg coop_crime_report_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(relc)




*%*%*%*%*%* 
*% general info - security
*%*%*%*%*%*

reg coop_info_share_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

local r = 0.2073*2.2

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_security_me set, delta(`d') rmax(`r') model(reg coop_info_share_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(seci)


*%*%*%*%*%* 
*% general info - abuse
*%*%*%*%*%*


reg coop_info_share_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_abuse set, delta(`d') rmax(`r') model(reg coop_info_share_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(badi)


*%*%*%*%*%* 
*% general info - relief
*%*%*%*%*%*


reg coop_info_share_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_food_me set, delta(`d') rmax(`r') model(reg coop_info_share_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(reli)



*%*%*%*%*%* 
*% beliefs - efficacy - security
*%*%*%*%*%*

reg belief_efficacy_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

local r = 0.3713*2.2

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_security_me set, delta(`d') rmax(`r') model(reg belief_efficacy_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(sece)


*%*%*%*%*%* 
*% beliefs - efficacy - abuse
*%*%*%*%*%*


reg belief_efficacy_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_abuse set, delta(`d') rmax(`r') model(reg belief_efficacy_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(bade)


*%*%*%*%*%* 
*% beliefs - efficacy - relief
*%*%*%*%*%*


reg belief_efficacy_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_food_me set, delta(`d') rmax(`r') model(reg belief_efficacy_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(rele)


*%*%*%*%*%* 
*% beliefs - abuse - security
*%*%*%*%*%*

reg belief_abuse_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

local r = 0.3679*2.2

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_security_me set, delta(`d') rmax(`r') model(reg belief_abuse_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(seca)


*%*%*%*%*%* 
*% beliefs - abuse - abuse
*%*%*%*%*%*


reg belief_abuse_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_abuse set, delta(`d') rmax(`r') model(reg belief_abuse_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(bada)


*%*%*%*%*%* 
*% beliefs - abuse - relief
*%*%*%*%*%*


reg belief_abuse_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_food_me set, delta(`d') rmax(`r') model(reg belief_abuse_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(rela)


*%*%*%*%*%* 
*% beliefs - benevolence - security
*%*%*%*%*%*

reg belief_benevolence_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

local r = 0.3679*2.2

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_security_me set, delta(`d') rmax(`r') model(reg belief_benevolence_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(secb)


*%*%*%*%*%* 
*% beliefs - benevolence - abuse
*%*%*%*%*%*


reg belief_benevolence_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_abuse set, delta(`d') rmax(`r') model(reg belief_benevolence_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(badb)


*%*%*%*%*%* 
*% beliefs - benevolence - relief
*%*%*%*%*%*


reg belief_benevolence_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac

capture matrix drop coeffs

forvalues d = 0 (0.1) 2.1 {
	bootstrap b=r(output), reps(100): psacalc pko_food_me set, delta(`d') rmax(`r') model(reg belief_benevolence_me pko_security_me pko_abuse pko_food_me hnp_security total_food_dist education gender religion i.site_fac i.enum_fac)
	matrix b = e(b)
	local b = b[1,1]
	matrix se = e(se)
	local se = se[1,1]
	matrix coeffs = nullmat(coeffs)\(`d', `r', `b', `se')
}

matrix list coeffs

svmat coeffs, names(relb)


keep secc* badc* relc* seci* badi* reli* sece* bade* rele* seca* bada* rela* secb* badb* relb*


save "Data/sens_out.dta", replace





