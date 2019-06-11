use ../Data/Individual.dta

* Censor age at 83, which is the 99th percentile
replace age=83 if age>83


**** This do-file requires that the individual-level data be merged with the variable "oecd" from the country-level dataset

forvalues i=0/1{
preserve
keep if oecd==`i'
foreach i in patience risktaking posrecip negrecip altruism trust{
qui areg `i' age age_sqr gender math, absorb(ison)
predict res_`i', resid
gen `i'_age = _b[age] * age + _b[age_sqr] * age_sqr + res_`i' 
}


label var patience_age "Patience"
label var risktaking_age "Risk taking"
label var posrecip_age "Positive reciprocity"
label var negrecip_age "Negative reciprocity"
label var altruism_age "Altruism"
label var trust_age "Trust"


twoway (qfit patience_age age, lpattern(dash) lwidth(medthick)) (qfit risktaking_age age, lpattern(longdash_dot) lwidth(medthick)) (qfit posrecip_age age, lpattern(shortdash) lwidth(medthick)) (qfit negrecip_age age, lwidth(medthick)) (qfit altruism_age age, clcolor(magenta) lpattern(shortdash_dot) lwidth(medthick)) (qfit trust_age age, clcolor(red) lpattern(shortdash_dot) lwidth(medthick)), ytitle("Preference") title("OECD countries") legend(order(1 2 3 4 5 6) rows(2) label(1 "Patience") label(2 "Risk taking") label(3 "Pos. reciprocity") label(4 "Neg. reciprocity") label(5 "Altruism") label(6 "Trust"))  graphregion(fcolor(white) lcolor(white))

restore
}
