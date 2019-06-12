* Dataproc_CBP.do
* Reads in County Business Patterns

capture log close
set more off
timer clear 1
timer on 1
clear
local work "PATH"
log using "`work'/Logs/Dataproc_CBP.log", replace
set matsize 11000

* List files
local files: dir "`work'/Data/CBP" files "*co.txt"
display `files'

* Reading annual files
* 4-digit SIC is best resolution 92-97, afterward have 6-digit NAICS
foreach f in `files' {
	display "Reading `f'"
	insheet using "`work'/Data/CBP/`f'", comma clear
	if inlist("`f'", "cbp92co.txt", "cbp93co.txt", "cbp94co.txt", "cbp95co.txt", "cbp96co.txt", "cbp97co.txt") {
		keep fipstate fipscty sic est
		replace sic = subinstr(sic, "/", "", .)
		replace sic = subinstr(sic, "\", "", .)
		replace sic = subinstr(sic, "-", "", .)
		replace sic = trim(sic)
		keep if strlen(sic)==4
		generate year = "19" + substr("`f'", -8, 2)
	}
	else {
		keep fipstate fipscty naics est
		replace naics = subinstr(naics, "/", "", .)
		replace naics = subinstr(naics, "\", "", .)
		replace naics = subinstr(naics, "-", "", .)
		replace naics = trim(naics)
		keep if strlen(naics)==6
		generate year = substr("`f'", -8, 2)
		replace year = "20" + year if !inlist(year, "98", "99")
		replace year = "19" + year if inlist(year, "98", "99")
	}
	save "`work'/Data/CBP/Processed/`f'.dta", replace
}

* Appending
clear
foreach f in `files' {
	display "Appending `f'.dta"
	append using "`work'/Data/CBP/Processed/`f'.dta"
}

* Variable handling on appended file
* Variable renames are for merge to TRI
destring year, replace
tab year
destring sic, replace
destring naics, replace
* n.b. number of obs falls in 1998 with switch from SIC to NAICS.

* Saving
compress
save "`work'/Data/CBP/Processed/CBP_all.dta", replace
preserve
keep if !missing(naics)
save "`work'/Data/CBP/Processed/CBP_naics.dta", replace
restore
keep if !missing(sic)
save "`work'/Data/CBP/Processed/CBP_sic.dta", replace






timer off 1
timer list 1
capture log close

