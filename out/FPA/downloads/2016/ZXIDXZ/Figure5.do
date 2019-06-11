**This code should be used with "marginals.dta"
**the numbers in marginals.dta are copied from the output obtained after running the R code "ModelsandMarginalEffects.txt"

label define country 1 "Saudi Arabia" 2 "Turkey" 3 "Iran"
label values country country
label define marginal 1 "Secular" 2 "Islam in Law"  3 "Religiosity" 4 "Sunni" 5 "Support Democracy" 6 "Education" 7 "Age" 8 "Female" 9 "Low Income" 10 "High Income" 11 "Egypt" 12 "Jordan" 13 "Lebanon"
label values marginal variable
keep if variable<5
twoway (scatter point variable, mcolor(black) msize(small) msymbol(circle)) (rcap min95 max95 variable), ytitle(Conditional Marginal Effects) ytitle(, size(small)) yline(0, lwidth(medium) lpattern(tight_dot)) xlabel(#4, labels labsize(small) angle(horizontal) format(%9.0g) labgap(small) valuelabel alternate) by(, title(Other Dependent Variables as Observed, size(small)) subtitle(, size(vsmall))) by(, legend(off)) scheme(s2mono) by(country, rows(1)) subtitle(, size(small))
