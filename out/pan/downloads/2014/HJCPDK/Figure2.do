/* Figure 2 */
/* be sure mixlogit package is installed */

#delimit;
set mem 30m;
set more off; 

log using Figure2.log, t replace; 

use formation_new.dta;

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

mixlogit realg anmax2 pro anti minwin mginvest prevpm gdiv1, 
rand(minor numpar dompar sq median mgodiv1) ln(2) nrep(200) group(case); 

mixlpred mixprob;

replace dompar = dompar2;
replace minor = minor2;
replace minwin = minwin2;
replace mginvest = mginvest2;

mixlpred mixprob2;

replace dompar = dompar3;
replace minor = minor3;
replace minwin = minwin3;
replace mginvest = mginvest3;

replace dompar = 0 if realg==1;

mixlpred mixprob3;

replace dompar = dompar3;

generate mixdiff2 = mixprob2 - mixprob;
generate mixdiff3 = mixprob3 - mixprob;

/* both counterfactuals, mixed logit */

twoway kdensity mixdiff2 if realg==1 & dompar==1, bwidth(0.02) xtitle("Change in Probability") ytitle("Density") 
ylabel(0 3 6) xlabel(-0.6 -0.4 -0.2 0 0.2 0.4) ||  
kdensity mixdiff3 if realg==1 & dompar==1, bwidth(0.02);
