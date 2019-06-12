
use "$data/podes_pkhrollout.dta", clear

	
keep if year==2005

egen early_adopter=rowtotal(treat2007 treat2008 treat2009 treat2010 treat2011)
	
	label var nsuicidespc "Suicide rate"
	label var n_educbaseline "Education institutions per capita"
	label var n_healthfacilitiesbaseline "Health institutions per capita "
	label var asphaltroadbaseline "\% villages with asphalted road"
	label var lightingbaseline "\% villages with lighting"
	label var perc_elebaseline "\% villages with electricity"
	label var ruralbaseline "\% rural villages"
	label var nvillages_2005 "Number of villages"
	label var pop_size "Population size" 
	label var n_familiesbaseline "Number of families"
	label var perc_farmers2005 "Percentage of farmers"
	label var N "\midrule N"

  
loc covars "nsuicidespc suicide pcn_educ pcn_healthfacilities asphaltroadbaseline lightingbaseline ruralbaseline nvillages_2005 pop_size n_familiesbaseline  perc_farmers2005 "

/* Initialize empty table */		
preserve

clear all
loc columns = 6

set obs 10
gen x = 1
gen y = 1

forval i = 1/`columns' {
	eststo col`i': reg x y
} 
restore

loc count = 3

loc statnames ""
loc varlabels ""

/* Custom fill cells */



	loc statnames "`statnames' `{\bf Panel A: Population data}'"	
	loc statnames "`statnames' thisstat1"
	loc statnames "`statnames' thisstat2"
	
foreach yvar of varlist  `covars' {

	qui sum `yvar' [aw=pop_sizebaseline], d

	cap: estadd loc thisstat`count' = string(`r(mean)', "%9.2f"): col1
	cap: estadd loc thisstat`count' = string(`r(sd)', "%9.2f"): col2
	cap: estadd loc thisstat`count' = string(`r(p50)', "%9.2f"): col3
	cap: estadd loc thisstat`count' = string(`r(min)', "%9.2f"): col4
	cap: estadd loc thisstat`count' = string(`r(max)', "%9.2f"): col5
	cap: estadd loc thisstat`count' = `r(N)': col6

	/* Row Labels */
	
	loc thisvarlabel: variable label `yvar'
	local varlabels "`varlabels' "`thisvarlabel'" "
	loc statnames "`statnames' thisstat`count'"
	
	loc count = `count' + 1
	}
loc statnames "`statnames' thisstat`count'"
	loc count = `count' + 1
	loc statnames "`statnames' `{\bf Panel B: Early adopters (2007 - 2011}'"

	loc count = `count' + 1
	loc statnames "`statnames' thisstat`count'"
	loc count = `count' + 1
	loc statnames "`statnames' thisstat`count'"
	loc count = `count' + 1
	

	preserve
	foreach yvar of varlist  `covars' {
	 
	keep if early_adopter==1
	qui sum `yvar' [aw=pop_sizebaseline], d

	cap: estadd loc thisstat`count' = string(`r(mean)', "%9.2f"): col1
	cap: estadd loc thisstat`count' = string(`r(sd)', "%9.2f"): col2
	cap: estadd loc thisstat`count' = string(`r(p50)', "%9.2f"): col3
	cap: estadd loc thisstat`count' = string(`r(min)', "%9.2f"): col4
	cap: estadd loc thisstat`count' = string(`r(max)', "%9.2f"): col5
	cap: estadd loc thisstat`count' = `r(N)': col6

	/* Row Labels */
	
	loc thisvarlabel: variable label `yvar'
	loc statnames "`statnames' thisstat`count'"
	loc count = `count' + 1
	
	}	
	restore
	
	loc statnames "`statnames' thisstat`count'"
	loc count = `count' + 1
	loc statnames "`statnames' `{\bf Panel C: RCT sample}'"

	loc count = `count' + 1
	loc statnames "`statnames' thisstat`count'"
	loc count = `count' + 1
	loc statnames "`statnames' thisstat`count'"
	loc count = `count' + 1
	

	preserve
	foreach yvar of varlist  `covars' {
	 
	keep if rctsample==1
	qui sum `yvar' [aw=pop_sizebaseline], d

	cap: estadd loc thisstat`count' = string(`r(mean)', "%9.2f"): col1
	cap: estadd loc thisstat`count' = string(`r(sd)', "%9.2f"): col2
	cap: estadd loc thisstat`count' = string(`r(p50)', "%9.2f"): col3
	cap: estadd loc thisstat`count' = string(`r(min)', "%9.2f"): col4
	cap: estadd loc thisstat`count' = string(`r(max)', "%9.2f"): col5
	cap: estadd loc thisstat`count' = `r(N)': col6

	/* Row Labels */
	
	loc thisvarlabel: variable label `yvar'
	loc statnames "`statnames' thisstat`count'"
	loc count = `count' + 1
	
	}

	restore
	
* Manually weight without 

sum nvillages_2005 , d
local count = 10
	cap: estadd loc thisstat`count' = string(`r(mean)', "%9.2f"), replace: col1
	cap: estadd loc thisstat`count' = string(`r(sd)', "%9.2f"), replace: col2
	cap: estadd loc thisstat`count' = string(`r(p50)', "%9.2f"), replace: col3
	cap: estadd loc thisstat`count' = string(`r(min)', "%9.2f"), replace: col4
	cap: estadd loc thisstat`count' = string(`r(max)', "%9.2f"), replace: col5
	cap: estadd loc thisstat`count' = `r(N)', replace: col6
	
		
sum nvillages_2005 if early_adopter	==1, d
local count = 25
	cap: estadd loc thisstat`count' = string(`r(mean)', "%9.2f"), replace: col1
	cap: estadd loc thisstat`count' = string(`r(sd)', "%9.2f"), replace: col2
	cap: estadd loc thisstat`count' = string(`r(p50)', "%9.2f"), replace: col3
	cap: estadd loc thisstat`count' = string(`r(min)', "%9.2f"), replace: col4
	cap: estadd loc thisstat`count' = string(`r(max)', "%9.2f"), replace: col5
	cap: estadd loc thisstat`count' = `r(N)', replace: col6	
	
sum nvillages_2005 if rctsample==1, d
local count = 40
	cap: estadd loc thisstat`count' = string(`r(mean)', "%9.2f"), replace: col1
	cap: estadd loc thisstat`count' = string(`r(sd)', "%9.2f"), replace: col2
	cap: estadd loc thisstat`count' = string(`r(p50)', "%9.2f"), replace: col3
	cap: estadd loc thisstat`count' = string(`r(min)', "%9.2f"), replace: col4
	cap: estadd loc thisstat`count' = string(`r(max)', "%9.2f"), replace: col5
	cap: estadd loc thisstat`count' = `r(N)', replace: col6	
	
sum pop_size , d
local count = 11
	cap: estadd loc thisstat`count' = string(`r(mean)', "%9.2f"), replace: col1
	cap: estadd loc thisstat`count' = string(`r(sd)', "%9.2f"), replace: col2
	cap: estadd loc thisstat`count' = string(`r(p50)', "%9.2f"), replace: col3
	cap: estadd loc thisstat`count' = string(`r(min)', "%9.2f"), replace: col4
	cap: estadd loc thisstat`count' = string(`r(max)', "%9.2f"), replace: col5
	cap: estadd loc thisstat`count' = `r(N)', replace: col6
	

	
sum pop_size if early_adopter	==1, d
local count = 26
	cap: estadd loc thisstat`count' = string(`r(mean)', "%9.2f"), replace: col1
	cap: estadd loc thisstat`count' = string(`r(sd)', "%9.2f"), replace: col2
	cap: estadd loc thisstat`count' = string(`r(p50)', "%9.2f"), replace: col3
	cap: estadd loc thisstat`count' = string(`r(min)', "%9.2f"), replace: col4
	cap: estadd loc thisstat`count' = string(`r(max)', "%9.2f"), replace: col5
	cap: estadd loc thisstat`count' = `r(N)', replace: col6	
	
sum pop_size if rctsample==1, d
local count = 42
	cap: estadd loc thisstat`count' = string(`r(mean)', "%9.2f"), replace: col1
	cap: estadd loc thisstat`count' = string(`r(sd)', "%9.2f"), replace: col2
	cap: estadd loc thisstat`count' = string(`r(p50)', "%9.2f"), replace: col3
	cap: estadd loc thisstat`count' = string(`r(min)', "%9.2f"), replace: col4
	cap: estadd loc thisstat`count' = string(`r(max)', "%9.2f"), replace: col5
	cap: estadd loc thisstat`count' = `r(N)', replace: col6	
	
	
	sum n_familiesbaseline , d
local count = 12
	cap: estadd loc thisstat`count' = string(`r(mean)', "%9.2f"), replace: col1
	cap: estadd loc thisstat`count' = string(`r(sd)', "%9.2f"), replace: col2
	cap: estadd loc thisstat`count' = string(`r(p50)', "%9.2f"), replace: col3
	cap: estadd loc thisstat`count' = string(`r(min)', "%9.2f"), replace: col4
	cap: estadd loc thisstat`count' = string(`r(max)', "%9.2f"), replace: col5
	cap: estadd loc thisstat`count' = `r(N)', replace: col6
	
sum n_familiesbaseline if early_adopter==1, d
local count = 27
	cap: estadd loc thisstat`count' = string(`r(mean)', "%9.2f"), replace: col1
	cap: estadd loc thisstat`count' = string(`r(sd)', "%9.2f"), replace: col2
	cap: estadd loc thisstat`count' = string(`r(p50)', "%9.2f"), replace: col3
	cap: estadd loc thisstat`count' = string(`r(min)', "%9.2f"), replace: col4
	cap: estadd loc thisstat`count' = string(`r(max)', "%9.2f"), replace: col5
	cap: estadd loc thisstat`count' = `r(N)', replace: col6	
	
	
	
sum n_familiesbaseline if rctsample==1, d
local count = 42
	cap: estadd loc thisstat`count' = string(`r(mean)', "%9.2f"), replace: col1
	cap: estadd loc thisstat`count' = string(`r(sd)', "%9.2f"), replace: col2
	cap: estadd loc thisstat`count' = string(`r(p50)', "%9.2f"), replace: col3
	cap: estadd loc thisstat`count' = string(`r(min)', "%9.2f"), replace: col4
	cap: estadd loc thisstat`count' = string(`r(max)', "%9.2f"), replace: col5
	cap: estadd loc thisstat`count' = `r(N)', replace: col6	
	


	
	
/* Footnotes */
local varlabels ""{\bf Panel A: Population data}" "\cline{1-1} " "Suicide rate" "Any suicide"  "Educ. institutions per 100,000 pop." "Health institutions per 100,000 pop." "\% villages with asphalted road" "\% villages with lighting" "\% rural villages" "Number of villages" "Population size"  "Number of families" "Percentage farmers" "\midrule " "{\bf Panel B: Early adopters (2007-2011)}" "\cline{1-1} "   "Suicide rate" "Any suicide" "Educ. institutions per 100,000 pop." "Health institutions per 100,000 pop." "\% villages with asphalted road" "\% villages with lighting"  "\% rural villages" "Number of villages" "Population size"  "Number of families" "Percentage farmers" "\midrule" "{\bf Panel C: RCT data}" "\cline{1-1} "   "Suicide rate" "Any suicide" "Educ. institutions per 100,000 pop." "Health institutions per 100,000 pop." "\% villages with asphalted road" "\% villages with lighting"  "\% rural villages" "Number of villages" "Population size"  "Number of families" "Percentage farmers""
	

	di "`statnames'"


loc prehead "\begin{tabular}{l*{`columns'}{c}} \toprule"

loc postfoot "\bottomrule \end{tabular}"

esttab col* using "$tables/Table1_summarystats.tex", booktabs cells(none) nonum nogap replace ///
mtitle("Mean" "SD" "Median" "Min." "Max." "Obs.") stats(`statnames', labels(`varlabels')) ///
 prehead("`prehead'") postfoot("`postfoot'") compress wrap 
eststo clear

