clear all
set matsize 11000

cd "~/Dropbox/Broockman-Skovron/Elite perceptions 2/Replication-materials/Analysis 2014"

local issues marriage religexempt gunsbgcheck gunsbanassault immpolicequestion immamnesty abortionlegal

***** PREP FILES*****
// Obama vote
insheet using "1_Analysis - CCES and MRP/2_Census Data and Pres Results and Poststrat File/Pres election results by SLD/SLD-pres-results-2012.csv", comma clear
tempfile obamavote
save `obamavote'

// Population size.
use "1_Analysis - CCES and MRP/2_Census Data and Pres Results and Poststrat File/2014acs5yr.dta", clear
gen modgeoid = substr(geoid2, 1, 2) + substr(geoid, 4, 1) + substr(geoid2, 3, 3)
keep modgeoid totalpop
rename totalpop district_pop
destring district_pop, replace force
tempfile districtpop
save `districtpop'

// NCS.
insheet using "1_Analysis - CCES and MRP/4_NCS/2014-NCS-cleaned_shuffled.csv", clear
drop mrp* // Make sure we only use raw data.

foreach issue in `issues' {
	count if `issue'perc != "NA"
}

merge m:1 modgeoid using `districtpop', nogen keep(3)
merge m:1 modgeoid using `obamavote', nogen keep(1 3)

foreach issue in `issues' {
	destring `issue'perc, replace force
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
gen htew = generalelectionresult == "Won"
gen htei = inlist(current_office_officename, "State Assembly", "State House", "State Senate")
gen htec = inrange(obama2012twoparty, .45, .55)
gen hteb = . // both parties responded, filled in later

tempfile ncs
save `ncs'

// CCES.
insheet using "1_Analysis - CCES and MRP/1_CCES/cces14_raw_lower.csv", clear
tempfile cceslower
save `cceslower'

insheet using "1_Analysis - CCES and MRP/1_CCES/cces14_raw_upper.csv", clear
append using `cceslower'
drop v1
rename v101 cces_caseid

destring `issues', replace force
gen htev = voted

joinby modgeoid using `ncs'

gen individual_weight = weight * allocweight
quietly sum district_pop
gen district_weight = individual_weight / district_pop * r(mean)

rename individual_weight c_weight // "citizen" weight
rename district_weight e_weight // "elite" weight

**** ESTIMATION *****
local nboots 1000
local issues marriage religexempt gunsbgcheck gunsbanassault abortionlegal // immpolicequestion immamnesty 
foreach issue in `issues' {
	display "`issue'"
	destring `issue', replace force
	replace `issue' = 100 * `issue'
	
	gen ncsmincces`issue' = `issue'perc - `issue'
	replace hteb = has_`issue'_perc_DandR == 1

	foreach weight in e c {
		foreach party in B D R {
			local htes a
			if "`weight'" == "e" local htes p w b a v i c
			foreach hte in `htes' {
				display "`weight' `party' `hte'"
				preserve
				keep if hteparty`party' == 1 & hte`hte' == 1  & has_perc_`issue' == 1 
				drop if missing(`issue')
			
				// Elite perception.
				quietly reg `issue'perc [iweight = `weight'_weight], vce(bootstrap, cl(modgeoid) r(`nboots') force)
				estimates store et`weight'_`issue'_`party'`hte'
				
				// Public opinion.
				quietly reg `issue' [iweight = `weight'_weight], vce(bootstrap, cl(cces_caseid) r(`nboots') force)
				estimates store ct`weight'_`issue'_`party'`hte'
				
				// Difference.
				quietly reg ncsmincces`issue' [iweight = `weight'_weight], vce(bootstrap, cl(modgeoid) r(`nboots') force)
				estimates store mt`weight'_`issue'_`party'`hte'
				restore
			}
		}
	}
	
	estout * using "2_Analysis/Raw/`issue'_ests.csv", replace delimiter(",") cells(b se)
	estimates drop _all
}



// Process the tables
clear all
insheet using "1_Analysis - CCES and MRP/4_NCS/issue.names.titles.csv", comma clear names
replace issue = subinstr(issue, ".", "", .)
tempfile issuenames
save `issuenames'
clear

local issues marriage religexempt gunsbgcheck gunsbanassault immpolicequestion immamnesty abortionlegal abortionillegal
tempfile temp
foreach issue in `issues' {
	preserve
	insheet using "2_Analysis/Raw/`issue'_ests.csv", clear
	sxpose, clear
	drop if _n == 1
	save `temp', replace
	restore
	append using `temp'
}

rename _var1 labelfull
drop _var2
rename _var3 valueest
rename _var4 valuese

destring value*, replace

split labelfull, p("_") gen(label)

gen column = substr(label1, 1, 1)
gen level_of_analysis = substr(label1, 2, 2)
drop label1

rename label2 issue

gen party = substr(label3, 1, 1)
gen hte = substr(label3, 2, 1)
drop label3 labelfull

replace hte = "all" if hte == "a"
replace hte = "both parties responded" if hte == "b"
replace hte = "professionalized" if hte == "p"
replace hte = "winners" if hte == "w"
replace hte = "voters" if hte == "v"
replace hte = "incumbents" if hte == "i"
replace hte = "closedistrict" if hte == "c"

replace column = "misperc" if column == "m"
replace column = "elites" if column == "e"
replace column = "public" if column == "c"

replace level = "typical_e" if level == "te"
replace level = "typical_c" if level == "tc"

//replace party = "All" if party == "B"

outsheet using "2_Analysis/Raw/estimates_for_ggplot.csv", comma replace

gen t = abs(valueest / valuese)
tostring value*, replace format("%9.2f") force
replace valuese = "(" + valuese + ")"
replace valueest = valueest + "*" if t > 3.3 & column == "misperc"
replace valueest = valueest + "*" if t > 2.58 & column == "misperc"
replace valueest = valueest + "*" if t > 1.96 & column == "misperc"
drop t

gen i = _n
reshape long value, i(i) j(stat) string
drop i
reshape wide value, i(issue level_of_analysis party hte stat) j(column) string
reshape wide value*, i(issue level_of_analysis hte stat) j(party) string
rename value* *
//drop *All

merge m:1 issue using `issuenames', nogen

sort level_of_analysis hte yesisliberal issue stat
outsheet issueshort elitesB publicB mispercB elitesD publicD mispercD elitesR publicR mispercR ///
	level_of_analysis hte using "2_Analysis/Raw/estimates_for_table.csv", comma replace

	
	
	
	
