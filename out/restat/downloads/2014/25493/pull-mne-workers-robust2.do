clear
capture log close
cd "$root"

log using "JPP/brazspil/logs/%stata/%1setup/pull-mne-workers-robust2.log", replace

* Find Employment in Domestic Firms Hiring Former MNE Workers & Other Domestic Workers
use "JPP/brazspil/data/all-workers.dta"
sort identificad ano
merge identificad ano using "JPP/brazspil/data/hiremne.dta"
tab _merge
drop _merge
replace totalmne=0 if totalmne==.
replace totalhwmne=0 if totalhwmne==.
replace totallwmne=0 if totallwmne==.
replace totalexpmne=0 if totalexpmne==.
replace totalnemne=0 if totalnemne==.

foreach var in layoff quit _ten1 _ten2 lowwageind highwageind indprim higheduc highocc lowocc {
 replace `var'_totalmne=0 if `var'_totalmne==.
 replace `var'_totalhwmne=0 if `var'_totalhwmne==.
 replace `var'_totallwmne=0 if `var'_totallwmne==.
 replace `var'_totalexpmne=0 if `var'_totalexpmne==.
 replace `var'_totalnemne=0 if `var'_totalnemne==.
}
 
sort identificad ano
merge identificad ano using "JPP/brazspil/data/hiredom.dta"
tab _merge
drop _merge
replace totaldom=0 if totaldom==.
replace totalhwdom=0 if totalhwdom==.
replace totallwdom=0 if totallwdom==.
replace totalexpdom=0 if totalexpdom==.
replace totalnedom=0 if totalnedom==.

foreach var in layoff quit _ten1 _ten2 lowwageind highwageind indprim higheduc highocc lowocc {
 replace `var'_totaldom=0 if `var'_totaldom==.
 replace `var'_totalhwdom=0 if `var'_totalhwdom==.
 replace `var'_totallwdom=0 if `var'_totallwdom==.
 replace `var'_totalexpdom=0 if `var'_totalexpdom==.
 replace `var'_totalnedom=0 if `var'_totalnedom==.
}

* Keep only Incumbent Workers
sort wid
by wid: egen switcher=max(switchout)
drop if switcher==1
drop switcher

* Keep only Incumbent Domestic Workers
drop if fdi==1
drop fdi

sort identificad ano
by identificad ano: egen emp = count(wid)

sort identificad ano
compress
save "JPP/brazspil/data/wid/aggcnpj-workers-robust2.dta", replace

clear
log close