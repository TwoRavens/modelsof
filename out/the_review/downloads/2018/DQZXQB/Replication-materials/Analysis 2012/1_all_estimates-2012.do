cd "~/Dropbox/Broockman-Skovron/Elite perceptions 2/Replication-materials/Analysis 2012"

use "2012_joinby.dta", clear

**** ESTIMATION *****
local nboots 1000
local issues marriage healthcare welfare
foreach issue in `issues' {
	display "`issue'"
	replace `issue' = 100 * `issue'
	
	gen ncsmincces`issue' = `issue'perc - `issue'
	replace hteb = has_`issue'_perc_DandR == 1

	foreach weight in c e {
		foreach party in B D R {
			local htes a
			if "`weight'" == "e" local htes p w b a i c
			foreach hte in `htes' {
				display "`issue' `weight' `party' `hte'"
				preserve
				keep if hteparty`party' == 1 & hte`hte' == 1 & has_perc_`issue' == 1
				drop if missing(`issue')
			
				// Elite perception.
				quietly reg `issue'perc [iweight = `weight'_weight], vce(bootstrap, cl(modgeoid) r(`nboots') force)
				estimates store et`weight'_`issue'_`party'`hte'
				
				// Public opinion.
				quietly reg `issue' [iweight = `weight'_weight], vce(bootstrap, cl(respondent) r(`nboots') force)
				estimates store ct`weight'_`issue'_`party'`hte'
				
				// Difference.
				quietly reg ncsmincces`issue' [iweight = `weight'_weight], vce(bootstrap, cl(modgeoid) r(`nboots') force)
				estimates store mt`weight'_`issue'_`party'`hte'
				restore
			}
		}
	}
	
	estout * using "`issue'_ests.csv", replace delimiter(",") cells(b se)
	estimates drop _all
}

insheet using "issue.names.titles.csv", comma clear names
tempfile issuenames
save `issuenames'
clear

local issues marriage healthcare welfare
tempfile temp
foreach issue in `issues' {
	preserve
	insheet using "`issue'_ests.csv", clear
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
replace hte = "incumbents" if hte == "i"
replace hte = "closedistrict" if hte == "c"

replace column = "misperc" if column == "m"
replace column = "elites" if column == "e"
replace column = "public" if column == "c"

replace level = "typical_e" if level == "te"
replace level = "typical_c" if level == "tc"

replace party = "All" if party == "B"

outsheet using "estimates_for_ggplot.csv", comma replace

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
rename *All *B

merge m:1 issue using `issuenames', nogen

sort level_of_analysis hte yesisliberal issue stat
outsheet issueshort elitesB publicB mispercB elitesD publicD mispercD elitesR publicR mispercR ///
	level_of_analysis hte using "estimates_for_table.csv", comma replace

	
	
	
