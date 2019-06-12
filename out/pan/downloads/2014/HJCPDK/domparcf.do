/* graphs and statistics for dompar counterfactual */
/* be sure rowsort package, version pr0046 is installed */
/* be sure mixlogit package is installed */

#delimit;
set mem 500m;
set more off; 

log using domparcf.log, t replace;

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

/* MXL */

keep realg minwin mginvest anmax2 pro anti prevpm gdiv1 numpar dompar 
sq minor median mgodiv1 dompar2 minor2 mginvest2 minwin2 dompar3 minor3 mginvest3 minwin3 case gnum;

mixlogit realg anmax2 pro anti minwin mginvest prevpm gdiv1, 
rand(minor numpar dompar sq median mgodiv1) ln(2) nrep(200) group(case); 

matrix coeffs = e(b);
matrix covmat = e(V);

/* random draws of coefficients */

drawnorm b1-b19, means(coeffs) cov(covmat) double; 

/* loop for probabilities */

generate mixprobm1 = 0;
generate mixprobm2 = 0;

nois _dots 0, title() reps(1000);
forvalues j = 1/1000 {;

  mkmat b1-b19 if _n==`j', matrix(bdraw);
  mixlpred2 mixprob; 

  qui replace dompar = dompar2;
  qui replace minor = minor2;
  qui replace mginvest = mginvest2;
  qui replace minwin = minwin2;

  mixlpred2 mixprob2;

  qui replace dompar = dompar3;
  qui replace minor = minor3;
  qui replace mginvest = mginvest3;
  qui replace minwin = minwin3;

  qui replace mixprobm1 = mixprobm1 + mixprob;
  qui replace mixprobm2 = mixprobm2 + mixprob2;
  qui generate mixdiff`j' = mixprob2 - mixprob;

drop mixprob mixprob2;
  
nois _dots `j' 0;
  
};

replace mixprobm1 = mixprobm1/1000;
replace mixprobm2 = mixprobm2/1000;

egen mixdiff = rowmean(mixdiff1 - mixdiff1000);

keep gnum case mixprobm1 mixprobm2 mixdiff mixdiff1 - mixdiff1000;

rowsort mixdiff1 - mixdiff1000, generate(mixdsort1 - mixdsort1000);

generate sigchange = 0;
replace sigchange = 1 if mixdsort25>0 & mixdsort975>0;
replace sigchange = 1 if mixdsort25<0 & mixdsort975<0;

sort gnum;

save gnum mixdiff mixdsort25 mixdsort975 using domparMXL, replace;

keep gnum case mixprobm1 mixprobm2 mixdiff sigchange;

save Figure3a, replace;
