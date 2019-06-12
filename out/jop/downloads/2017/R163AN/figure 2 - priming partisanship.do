clear
cd "~/Dropbox/Life cycle paper/JOP submission/Replication files/priming partisanship experiment/"
use "priming partisanship data.dta"

foreach j of numlist 0 1{
foreach i of numlist 0 1{
preserve
keep if married_wkids==1
g strength_y=.
g strength_se=.

collapse (mean) strength_y= strength (semean) strength_se= strength if priming_pol==`i' & ind==0 & rep==`j'
g pid=`j'
g treat=`i'
save "/Users/michelemargolis/Desktop/exp_temp_kids`j'`i'.dta", replace
restore
}
}


foreach j of numlist 0 1{
foreach i of numlist 0 1{
preserve
keep if married_wgrown==1
g strength_y=.
g strength_se=.

collapse (mean) strength_y= strength (semean) strength_se= strength if priming_pol==`i' & ind==0 & rep==`j'
g pid=`j'
g treat=`i'
save "/Users/michelemargolis/Desktop/exp_temp_grown`j'`i'.dta", replace
restore
}
}


**KIDS AT HOME**
clear
use "/Users/michelemargolis/Desktop/exp_temp_kids00.dta"
append using "/Users/michelemargolis/Desktop/exp_temp_kids01.dta"
append using "/Users/michelemargolis/Desktop/exp_temp_kids10.dta"
append using "/Users/michelemargolis/Desktop/exp_temp_kids11.dta"

gen ub_strength = strength_y + 1.96*strength_se
gen lb_strength = strength_y - 1.96*strength_se

recode treat (0=0.05) (1=0.95) 


twoway (scatter strength_y treat if pid==0, msymbol(circle)) (lfit strength_y treat if pid==0, lpattern(dash) lwidth(medthick)) (rcap ub_strength lb_strength treat if pid==0, lpattern(dash) lwidth(medthick)) ///
(scatter strength_y treat if pid==1, col(gs11) msymbol(square)) (lfit strength_y treat if pid==1, col(gs11) lpattern(solid) lwidth(medthick)) (rcap ub_strength lb_strength treat if pid==1, col(gs9) lpattern(solid) lwidth(medthick)), ///
ylabel(none) ylabel(0.6(0.1)0.9) ytitle("Strength of religious identification", size(medium))  xtitle("") title() legend(off) ylabel(,nogrid) xlabel(none) scheme(lean1) xscale(range(0,1)) yscale(range(0.6, 0.9)) ///
text(0.70 0.13 "Democrats", size(medium)) text(0.84 0.86 "Republicans", size(medium)) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
xlabel(0.05 "No prime" 0.95 "Prime", labsize(medium))



**GROWN KIDS**
clear
use "/Users/michelemargolis/Desktop/exp_temp_grown00.dta"
append using "/Users/michelemargolis/Desktop/exp_temp_grown01.dta"
append using "/Users/michelemargolis/Desktop/exp_temp_grown10.dta"
append using "/Users/michelemargolis/Desktop/exp_temp_grown11.dta"

gen ub_strength = strength_y + 1.96*strength_se
gen lb_strength = strength_y - 1.96*strength_se

recode treat (0=0.05) (1=0.95) 

twoway (scatter strength_y treat if pid==0, msymbol(circle)) (lfit strength_y treat if pid==0, lpattern(dash) lwidth(medthick)) (rcap ub_strength lb_strength treat if pid==0, lpattern(dash) lwidth(medthick)) ///
(scatter strength_y treat if pid==1, col(gs11) msymbol(square)) (lfit strength_y treat if pid==1, col(gs11) lpattern(solid) lwidth(medthick)) (rcap ub_strength lb_strength treat if pid==1, col(gs9) lpattern(solid) lwidth(medthick)), ///
ylabel(none) ylabel(0.6(0.1)0.9) ytitle("Strength of religious identification", size(medium))  xtitle("") title() legend(off) ylabel(,nogrid) xlabel(none) scheme(lean1) xscale(range(0,1)) yscale(range(0.6, 0.9)) ///
text(0.70 0.14 "Democrats", size(medium)) text(0.83 0.85 "Republicans", size(medium)) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
xlabel(0.05 "No prime" 0.95 "Prime", labsize(medium))

