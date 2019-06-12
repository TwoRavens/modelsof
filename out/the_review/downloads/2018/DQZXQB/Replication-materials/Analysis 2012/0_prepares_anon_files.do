// This file will not run in the replication dataset.
// It makes 2012_joinby_scrambled.dta, which the rest of the files will run off of.

clear all
set matsize 11000

cd "~/Dropbox/Broockman-Skovron/Elite perceptions 2/2012 NCS"

***** PREP FILES*****
local issues marriage healthcare welfare
// Obama vote
insheet using "../2014 NCS/1_Analysis - CCES and MRP/2_Census Data and Pres Results and Poststrat File/Pres election results by SLD/SLD-pres-results-2012.csv", comma clear
tempfile obamavote
save `obamavote'

// NCS.
use "~/Dropbox/National Candidate Study/2012/RESULTS/NCS-all-responses-w-context-v1.dta", clear
merge m:1 modgeoid using `obamavote', nogen keep(1 3)

rename const_estim_same_sex_mar_ok marriageperc
rename const_estim_uhealthcare healthcareperc
rename const_estim_fed_welfare welfareperc

foreach issue in `issues' {
	count if !missing(`issue'perc)
}

drop party miniparty
gen party = "D" if democrat == 1
replace party = "R" if democrat == 0
drop if missing(democrat)
gen won_primary = primary_election_result == "Won"
foreach issue in `issues' {
	gen has_perc_`issue' = `issue'perc != .
	foreach party in D R {
		gen has_`party'_perc_`issue' = has_perc_`issue' == 1 & party == "`party'"
		bysort modgeoid: egen has_`party'_perc_`issue'_max = max(has_`party'_perc_`issue')
	}
	gen has_`issue'_perc_DandR = has_D_perc_`issue'_max == 1 & has_R_perc_`issue'_max == 1
	drop has_D_perc_`issue'_max has_R_perc_`issue'_max
}

gen htepartyD = party == "D"
gen htepartyR = party == "R"
gen htepartyB = 1
gen htea = 1
gen htep = state_squire_index > .2
gen htei = cntxtvar_already_elected
gen htew = won_general == 1
gen htec = inrange(obama2012twoparty, .45, .55)
gen hteb = .

drop if missing(district_pop)

keep *perc* hte* modgeoid district_pop
drop district*percent

tempfile ncs
save `ncs'

// Warshaw megapoll -- welfare. Stanford Warshaw/Tausanovitch CCES 2010 module.
use "DATA - PUBLIC OPINION/DATA - Abolish Welfare Programs/broockman_welfare.dta", clear
gen welfare = 1 if sta306_4 == 1
replace welfare = 0 if sta306_4 == 2
keep respondent welfare // v205
assert !missing(respondent)
drop if welfare == .
tempfile welfare
save `welfare'

// CCES 2008 - healthcare.
// Merge in welfare here to exploit that we've already mapped people to districts in the megapoll mrp ready file.
// Lower
use "DATA - PUBLIC OPINION/warshaw_megapoll_mrp_ready-lower_districts.dta", clear
keep if inlist(source, "CCES_2008", "CCES_2010")
merge m:1 respondent using `welfare', nogen keep(1 3) 
	tab source if !missing(welfare) // Welfare merges to 2010 CCES; that is where the Stanford module was
gen healthcare = universal_healthcare
keep healthcare welfare mrp_weight modgeoid respondent
drop if missing(healthcare) & missing(welfare)
assert !missing(respondent)
tempfile lower
save `lower'

// Upper
use "DATA - PUBLIC OPINION/warshaw_megapoll_mrp_ready-upper_districts.dta", clear
keep if inlist(source, "CCES_2008", "CCES_2010")
merge m:1 respondent using `welfare', nogen keep(1 3)
gen healthcare = universal_healthcare
keep healthcare welfare mrp_weight respondent modgeoid
drop if missing(healthcare) & missing(welfare)
assert !missing(respondent)
sum respondent
tempfile upper
save `upper'


// CCES 2012 -- marriage.
use "DATA - PUBLIC OPINION/cces12_raw_lower.dta", clear
append using "DATA - PUBLIC OPINION/cces12_raw_upper.dta"
gen marriage = 1 if favor_marriage == 1
replace marriage = 0 if favor_marriage == 2
gen mrp_weight = alloc_weight * cces_weight
rename id respondent
keep respondent marriage mrp_weight modgeoid
drop if mrp_weight == 0
sum respondent
append using `lower' `upper'

rename mrp_weight individual_weight

keep marriage healthcare welfare modgeoid individual_weight respondent

joinby modgeoid using `ncs'
assert !missing(respondent)

quietly sum district_pop
gen district_weight = individual_weight / district_pop * r(mean)

rename individual_weight c_weight // "citizen" weight
rename district_weight e_weight // "elite" weight

// Shuffle variables for replication data
rename has_healthcare_perc_DandR has_hc_perc_DandR
foreach var of varlist * {
	shufflevar `var', dropold
	rename `var'_shuffled `var'
}
rename has_hc_perc_DandR has_healthcare_perc_DandR

// modgeoid identifies respondents; drop these
encode modgeoid, gen(modgeoidblind)
drop modgeoid
rename modgeoidblind modgeoid
label drop modgeoidblind

// CCES respondent id identifies respondents
format respondent %20.10f
tostring respondent, replace
encode respondent, gen(respondentblind)
drop respondent
rename respondentblind respondent
label drop respondentblind

// District pop -- this could identify who responded, so add lots of noise
replace district_pop = district_pop + floor(10000000*runiform())

// Round the weights so respondents cannot be identified based on weights
replace c_weight = round(c_weight, .01)
replace e_weight = round(e_weight, .01)

compress

saveold "~/Dropbox/Broockman-Skovron/Elite perceptions 2/Replication-materials/Analysis 2012/2012_joinby_scrambled.dta", replace v(12)
