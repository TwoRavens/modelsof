/* This is now figure 1 of the paper */

insheet using appendix_fig1_data.csv
list
drop if _n==1
rename v1 year
rename v2 US
rename v3 NLSY
rename v4 PSID
rename v5 SCF
drop if _n==1
destring *, replace
sum

twoway (line US year, xtitle("") graphregion(color(white)) bgcolor(white) scheme(s2mono) lcolor(black) lpattern(solid) legend(row(1)) subtitle("")) (connected NLSY year, lcolor(black) msymbol(O) mcolor(black) msize(small) ytitle("Filings per 1000 households")) (line PSID year, lcolor(black) lpattern(dash)) (line SCF year, lcolor(black) lpattern(dot))
graph export appendix_fig1_clean.pdf, replace

clear

/* appendix figure 1 */

insheet using appendix_fig2_data.csv
rename v1 time
rename v2 beta
rename v3 ci_minus
rename v4 ci_plus

drop if _n==1 | _n==2
destring *, replace
replace time = -2 if time== -1
replace time = -4 if time==-3
replace time = -6 if time==-5
replace time = -8 if time==-7
replace time = -10 if time==-9


lab def years -10 "-9+"
lab def years -8 "-8-7", add
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values time years

label variable time "Years before/after bankruptcy"

twoway (line ci_plus time, ytitle("Total debts relative to non-filers") graphregion(color(white)) bgcolor(white) scheme(s2mono) lcolor(black) lpattern(dash) legend(off) yscale(range(-20000 10000)) ylabel(-20000(5000)10000, angle(0)) xscale(range(-10 10)) xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, valuelabel) subtitle("")) (connected beta time, lcolor(black) msymbol(O) mcolor(black) msize(small)) (line ci_minus time, lcolor(black) lpattern(dash))
graph export appendix_fig2_clean.pdf, replace

/* appendix figure 2 */

insheet using appendix_fig3_data.csv, clear
rename v1 time
rename v2 beta
rename v3 ci_minus
rename v4 ci_plus

drop if _n==1 | _n==2
destring *, replace
replace time = -2 if time== -1
replace time = -4 if time==-3
replace time = -6 if time==-5
replace time = -8 if time==-7
replace time = -10 if time==-9


lab def years -10 "-9+"
lab def years -8 "-8-7", add
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values time years

label variable time "Years before/after bankruptcy"

twoway (line ci_plus time, ytitle("Other debts relative to non-filers") graphregion(color(white)) bgcolor(white) scheme(s2mono) lcolor(black) lpattern(dash) legend(off) yscale(range(-2000 6000)) ylabel(-2000(1000)6000, angle(0)) xscale(range(-10 10)) xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, valuelabel) subtitle("")) (connected beta time, lcolor(black) msymbol(O) mcolor(black) msize(small)) (line ci_minus time, lcolor(black) lpattern(dash))
graph export appendix_fig3_clean.pdf, replace


/* appendix figure 3 */

insheet using appendix_fig4_data.csv, clear
rename v1 time
rename v2 beta
rename v3 ci_minus
rename v4 ci_plus

drop if _n==1 | _n==2
destring *, replace
replace time = -2 if time== -1
replace time = -4 if time==-3
replace time = -6 if time==-5
replace time = -8 if time==-7
replace time = -10 if time==-9


lab def years -10 "-9+"
lab def years -8 "-8-7", add
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values time years

label variable time "Years before/after bankruptcy"

twoway (line ci_plus time, graphregion(color(white)) bgcolor(white) scheme(s2mono) lcolor(black) lpattern(dash) legend(off) yscale(range(-0.15 0.1)) ylabel(-0.15(0.05)0.1) xscale(range(-10 10)) xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, valuelabel) subtitle("")) (connected beta time, lcolor(black) msymbol(O) mcolor(black) msize(small)) (line ci_minus time, lcolor(black) lpattern(dash) ytitle("Homeownership rate relative to non-filers"))
graph export appendix_fig4_clean.pdf, replace
