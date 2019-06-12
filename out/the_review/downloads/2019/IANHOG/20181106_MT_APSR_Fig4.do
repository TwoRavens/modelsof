

#delimit;
cap cd "C:\Users\ejm5\Dropbox\PartipationCompliance\AER-QJE-The Moon\Replication";
use "Data\20181106_RCT_Clean.dta", clear;


#delimit;
set more off;
drop if success !=1;
xi: reg subjective_mean  treatment1 treatment2 hanoi female i.r1_emp  i.r1_catsector, cluster(fe_provcatsector);
outreg2 using bounds2,  tdec(3) bdec(3) ci replace level(90);
replace subjective_mean=subjective_mean*100;
foreach num of numlist 0(1)100 { ;
set seed 1234;
generate rnorm=rnormal(`num', .38);
hist rnorm;
sum rnorm;
replace subjective_mean=rnorm if access==0;
replace subjective_mean=0 if subjective_mean<0;
xi: reg subjective_mean  treatment1 treatment2 hanoi female i.r1_emp  i.r1_catsector, cluster(fe_provcatsector);
generate coef_`num'=_b[treatment2];
generate se_`num'=_se[treatment2];
drop rnorm;
};


#delimit;
drop sector_plus;
collapse coef* se*;
generate compliance=_n;
reshape long coef_ se_, i(compliance);
#delimit;
drop compliance;
generate compliance=_j/100;
generate treatment2=coef_/100;
replace se=se_/100;
save bounds2.dta, replace;




/***************************************************************************************/
/*BOUNDS ANALYSIS*/

#delimit;
use bounds2.dta, clear;
generate low=treatment2-(1.96*se);
generate high=treatment2+(1.96*se);
generate low90=treatment2-(se*1.6);
generate high90=treatment2+(se*1.6);

#delimit;
twoway (rspike high low compliance, lcolor(gs12) lwidth(thin)) 
		(rspike high90 low90 compliance, lcolor(gs4) lwidth(medium))
		(scatter treatment2 compliance, msize(vsmall) msymbol(diamond) mcolor(black))
, xlab(0(.1)1, labsize(small)) 
xtitle("", size(medsmall) 
margin(medium)) ytitle("Average Treatment Effect of Participation", size(medsmall) 
margin(medium)) yline(0, lpattern(dash) lcolor(gs8) lwidth(medthick)) 
xline(.61, lpattern(shortdash) lcolor(gs8) lwidth(thick)) xline(.316 .904, lpattern(shortdash) lcolor(gs8) lwidth(medthin))
legend(rows(1) size(vsmall) label(1 "95% CI") label(2 90% CI) label(3 ATE) ring(0) position(6))
scheme(s1mono);
graph save Figure4_bounds.gph, replace;
graph export "Figures\Figure4_bounds.gph.pdf", as(pdf) replace;


/*Leee Bounds*/
#delimit;
use "Data\20181106_RCT_Clean.dta", clear;
set more off;
drop if success !=1;
leebounds subjective_mean treatment2 if treatment1==1, select(access) tight(female hanoi)  cieffect   level(90) vce(bootstrap, reps(100) nodots);












