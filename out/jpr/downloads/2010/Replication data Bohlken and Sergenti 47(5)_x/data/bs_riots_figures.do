#delimit ;
clear;
set memory 64m;
set more off;
cap log close;

use C:\\bs_riots.dta, clear;


* ******************************************************************    *;
*   FIGURE 1;
* ******************************************************************    *;

preserve;
collapse  CNTVIOL GROWTH, by (YEAR) ;

graph twoway  bar CNTVIOL YEAR, yaxis(1) color(gs9)
 || line GROWTH YEAR, lw(thick) yaxis(2) 
 || ,xlabel(1983(2)1995)  legend(label(1 "Riots") label(2 "Growth") position(2) ring(0) rows(2))
  ylabel(,axis(2) angle(horizontal)) ylabel(,axis(1) angle(horizontal)) 
  ytitle("Number of Reported Riots", axis(1)) ytitle("Growth Rate (in percent)", axis(2)) 
  xtitle("Year") title("Average for All States 1982 - 1995");
graph save C:\f1_india.gph, replace;
translate @Graph C:\f1_india.wmf, replace;

restore;


preserve;
keep if STATE_NB == 6;

graph twoway  bar CNTVIOL YEAR, yaxis(1) color(gs9)
 || line GROWTH YEAR, lw(thick) yaxis(2) 
 || ,xlabel(1983(2)1995)  legend(label(1 "Riots") label(2 "Growth") position(2) ring(0) rows(2))
  ylabel(,axis(2) angle(horizontal)) ylabel(,axis(1) angle(horizontal)) 
  ytitle("Number of Reported Riots", axis(1)) ytitle("Growth Rate (in percent)", axis(2)) 
  xtitle("Year") title("Gujarat 1982 - 1995");
graph save C:\f1_guj.gph, replace;
translate @Graph C:\f1_guj.wmf, replace;

restore;



* ******************************************************************    *;
*   FIGURE 2;
* ******************************************************************    *;
* ******************************************************************    *;
*   SET SCALARS AT THEIR MEDIAN VALUES;
* ******************************************************************    *;

/* median values */

scalar h_growth = 2.3758;
scalar h_growth1 = 2.4566;
scalar h_nvotes = 3.89084;
scalar h_coalgov = 0;
scalar h_urbgini = 33.2973;
scalar h_cntviol1 = 1;
scalar h_cntv_adj = 6;
scalar h_lpop = 10.7403;
scalar h_mus = 8.91;
scalar h_mussq = 79.3881;
scalar h_lit = 55.8;
scalar h_gdpper = 1498;


* ******************************************************************    *;
*   RUN REGRESSION / PRODUCE SIMULATED BETAS;
* ******************************************************************    *;

global nb_invar = "NVOTES COALGOV URBGINI CNTVIOL1 CNTV_ADJ LPOP MUS MUSSQ LIT GDPPER";

nbreg CNTVIOL GROWTH GROWTH1 $nb_invar, cluster(STATE_NB) nolog;

preserve;
drawnorm S_b1-S_b14, n(1000) means(e(b)) cov(e(V)) clear;
save simulated_betas, replace;
restore;
merge using simulated_betas;
tab _merge;
drop _merge;

gen index = _n -1 if _n < 41;
gen g_growth = -11 + _n* 1;
replace g_growth = . if _n > 41;



* ******************************************************************    *;
*   FIGURE 2A: LEVELS PLOT;
* ******************************************************************    *;

gen level = .;
gen level_u = .;
gen level_l = .;

scalar j = 0;
while j < 41
{;
gen raw =  exp( (S_b13) + (S_b1*(-10 + (j))) + (S_b2*h_growth1) + (S_b3*h_nvotes) + (S_b4*h_coalgov) + 
(S_b5*h_urbgini) + (S_b6*h_cntviol1) + (S_b7*h_cntv_adj) + (S_b8*h_lpop) + (S_b9*h_mus) + (S_b10*h_mussq) +
(S_b11*h_lit) + (S_b12*h_gdpper) );

sum raw;
replace level = r(mean) if index == j;
centile raw, centile(2.5 97.5);
replace level_u = r(c_2) if index == j;
replace level_l = r(c_1) if index == j;

drop raw;
scalar j = j + 1;
};


graph twoway
line level_u g_growth if g_growth > -6 & g_growth < 16, clp(dash) clw(thin) clc(black) ||
line level_l g_growth if g_growth > -6 & g_growth < 16, clp(dash) clw(thin) clc(black) ||
line level g_growth if g_growth > -6 & g_growth < 16, clp(solid) clw(thin) clc(black) ||

, legend(off) yline(0) ylabel(0(1)5) ylabel(,axis(1) angle(horizontal)) 
  ytitle("Expected Number of Riots", axis(1)) 
  xtitle("Growth Rate (in percent)") xlabel(-5(5)15) title("Expected Number of Riots");
graph save C:\f2_level.gph, replace;
translate @Graph C:\f2_level.wmf, replace;


* ******************************************************************    *;
*   FIGURE 2B: MARGINAL EFFECTS PLOT;
* ******************************************************************    *;

gen me = .;
gen me_u = .;
gen me_l = .;

scalar j = 0;
while j < 41
{;
gen raw =  S_b1*exp( (S_b13) + (S_b1*(-10 + (j))) + (S_b2*h_growth1) + (S_b3*h_nvotes) + (S_b4*h_coalgov) + 
(S_b5*h_urbgini) + (S_b6*h_cntviol1) + (S_b7*h_cntv_adj) + (S_b8*h_lpop) + (S_b9*h_mus) + (S_b10*h_mussq) +
(S_b11*h_lit) + (S_b12*h_gdpper) );

sum raw;
replace me = r(mean) if index == j;
centile raw, centile(2.5 97.5);
replace me_u = r(c_2) if index == j;
replace me_l = r(c_1) if index == j;

drop raw;
scalar j = j + 1;
};

graph twoway
line me_u g_growth if g_growth > -5 & g_growth < 15, clp(dash) clw(thin) clc(black) ||
line me_l g_growth if g_growth > -5 & g_growth < 15, clp(dash) clw(thin) clc(black) ||
line me g_growth if g_growth > -5 & g_growth < 15, clp(solid) clw(thin) clc(black) ||

, legend(off) yline(0)
  ytitle("Marginal Effect", axis(1)) 
  xtitle("Growth Rate (in percent)") xlabel(-5(5)15) title("Marginal Effects");
graph save C:\f2_me.gph, replace;
translate @Graph C:\f2_me.wmf, replace;


exit;
