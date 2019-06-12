/* Figure 1 */

/* graphs and statistics for dompar counterfactual */
/* be sure rowsort package, version pr0046 is installed */

#delimit;
set mem 500m;
set more off; 

log using Figure1.log, t replace;

use formation_new;

generate gnum = _n;

generate govtstr = subinstr(govt,"govt","",.);

local i = 1;

while `i' < 15 {;

  generate p`i' = substr(govtstr,((`i'*2)-1),2); 
  destring p`i', replace;
  generate party`i' = 0;

  local i = `i' + 1;

};

sort case;

local k = 1;

while `k' < 15 {;

  replace party`k' = 1 if p1==`k' | p2==`k' | p3==`k' | p4==`k' | 
    p5==`k' | p6==`k' | p7==`k' | p8==`k' | p9==`k' | p10==`k' | 
    p11==`k' | p12==`k' | p13==`k' | p14==`k';

  local k = `k' + 1;

};

generate tempseats = seats;
replace tempseats = 0 if dompar==1 | numpar>1;
by case: egen tseats2 = max(tempseats);
replace tseats2 = 0 if tseats2 != seats;

generate dompar2 = 0;

local j = 1;

while `j' < 15 {;

  by case: egen seats`j' = sum(tseats2 * party`j');
  by case: replace dompar2 = party`j' if seats`j'>0;

  local j = `j' + 1;

};

sort case;
generate seatsold = seats if dompar == 1 & numpar == 1;
by case: egen seatsold2 = max(seatsold);
generate seatsnew = seats if dompar2 == 1 & numpar == 1;
by case: egen seatsnew2 = max(seatsnew);

generate seats2d = seats;
replace seats2d = seats2d - seatsold2 + seatsnew2 if dompar == 1;
replace seats2d = seats2d + seatsold2 - seatsnew2 if dompar2 == 1;

generate minor2 = 0;
replace minor2 = 1 if seats2d < 0.5;

generate mginvest2 = minor2*invest;

generate minwin2 = 1;
replace minwin2 = 0 if seats2d < 0.5;

generate seats3d = seats;
replace seats3d = 0 if numpar > 1;

local m = 1;

while `m' < 15 {;

  by case: egen seats`m'w = max(seats3d * party`m');
  replace minwin2 = 0 if (seats2d - seats`m'w)>0.5 & party`m'==1;

  local m = `m' + 1;

};



generate dompar3 = dompar;
generate minor3 = minor;
generate mginvest3 = mginvest;
generate minwin3 = minwin;

/* CL */

keep realg minwin mginvest anmax2 pro anti prevpm gdiv1 numpar dompar 
sq minor median mgodiv1 dompar2 minor2 mginvest2 minwin2 dompar3 minor3 mginvest3 minwin3 case gnum;

clogit realg anmax2 pro anti minwin mginvest prevpm gdiv1 minor numpar dompar sq median mgodiv1, group(case); 

matrix coeffs = e(b);
matrix covmat = e(V);

/* random draws of coefficients */

drawnorm b1-b13, means(coeffs) cov(covmat) double; 

/* loop for probabilities */

generate clprobm1 = 0;
generate clprobm2 = 0;


. sort case;

nois _dots 0, title() reps(1000);
forvalues j = 1/1000 {;

qui gen clpxb1 = (anmax2*b1[`j']) + (pro*b2[`j']) + (anti*b3[`j']) + (minwin*b4[`j']) + (mginvest*b5[`j']) + (prevpm*b6[`j']) + 
(gdiv1*b7[`j']) + (minor*b8[`j']) + (numpar*b9[`j']) + (dompar*b10[`j']) + (sq*b11[`j']) + (median*b12[`j']) + (mgodiv1*b13[`j']);

qui gen eclxb1 = exp(clpxb1);

by case: generate sseclxb1 = sum(eclxb1);

by case: egen seclxb1 = max(sseclxb1);

qui generate clprob1 = eclxb1 / seclxb1;

qui gen clpxb2 = (anmax2*b1[`j']) + (pro*b2[`j']) + (anti*b3[`j']) + (minwin2*b4[`j']) + (mginvest2*b5[`j']) + (prevpm*b6[`j']) + 
(gdiv1*b7[`j']) + (minor2*b8[`j']) + (numpar*b9[`j']) + (dompar2*b10[`j']) + (sq*b11[`j']) + (median*b12[`j']) + (mgodiv1*b13[`j']);

qui gen eclxb2 = exp(clpxb2);

by case: generate sseclxb2 = sum(eclxb2);

by case: egen seclxb2 = max(sseclxb2);

qui generate clprob2 = eclxb2 / seclxb2;

qui replace clprobm1 = clprobm1 + clprob1;

qui replace clprobm2 = clprobm2 + clprob2;

qui generate cldiff`j' = clprob2 - clprob1;

drop clpxb1 eclxb1 sseclxb1 seclxb1 clprob1 clpxb2 eclxb2 sseclxb2 seclxb2 clprob2;
  
nois _dots `j' 0;
  
};

replace clprobm1 = clprobm1/1000;
replace clprobm2 = clprobm2/1000;

egen cldiff = rowmean(cldiff1 - cldiff1000);

keep gnum case clprobm1 clprobm2 cldiff cldiff1 - cldiff1000;

rowsort cldiff1 - cldiff1000, generate(cldsort1 - cldsort1000);

keep gnum cldiff cldsort25 cldsort975;

sort gnum;

merge gnum using domparMXL;

gen clsd = (cldsort975-cldsort25)/(2*1.96);
gen mxlsd = (mixdsort975-mixdsort25)/(2*1.96);
gen diffsd = sqrt((clsd^2) + (mxlsd^2));

gen diffdiff = cldiff - mixdiff;

gen sigdiff=0;
replace sigdiff = 1 if abs(diffdiff/diffsd)>1.96;

ta sigdiff;

gen cldiffsig = .;
replace cldiffsig = cldiff if sigdiff == 1;
gen mixdiffsig = .;
replace mixdiffsig = mixdiff if sigdiff == 1;

gen cldiffis = .;
replace cldiffis = cldiff if sigdiff == 0;
gen mixdiffis = .;
replace mixdiffis = mixdiff if sigdiff == 0;

gen h = -0.75;
gen v = -0.75;
replace h = 0.75 if _n==1;
replace v = 0.75 if _n==1;

graph twoway (scatter mixdiffis cldiffis, msymbol(o) mcolor(gs8) xlabel(-0.75 -0.5 -0.25 0 0.25 0.5 0.75) ylabel(-0.75 -0.5 -0.25 0 0.25 0.5 0.75))
             (scatter mixdiffsig cldiffsig, msymbol(oh)  msize(medlarge) mcolor(black))
             (line h v, lcolor(black) lpattern(dash)),
             legend(off);

