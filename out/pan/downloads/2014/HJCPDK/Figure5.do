/* Figure 5 */
/* be sure mixlogit package is installed */

#delimit;
set mem 30m;
set more off; 

log using Figure5.log, t replace; 

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

matrix coeffs = e(b);
matrix covmat = e(V); 

keep if case==112;


/* rename party dummies */

rename party1 ppr;
rename party2 pvda;
rename party3 d66;
rename party4 vvd;
rename party5 cda;

/* ideology */

generate pprid = (-28.6*(0.02/seats))*ppr;
generate pvdaid = (-18.7*(0.293/seats))*pvda;
generate d66id = (-13.1*(0.113/seats))*d66;
generate vvdid = (7.6*(0.173/seats))*vvd;
generate cdaid = (-12.3*(0.32/seats))*cda;

drop if ppr==1;

generate ideology = pvdaid + d66id + vvdid + cdaid;

generate coalct = _n;
tabulate coalct, generate(c);

set obs 1000;

generate prob1=.;
generate prob2=.;
generate prob3=.;
generate prob4=.;
generate prob5=.;
generate prob6=.;
generate prob7=.;
generate prob8=.;
generate prob9=.;
generate prob10=.;
generate prob11=.;
generate prob12=.;
generate prob13=.;
generate prob14=.;
generate prob15=.;

generate prob1b=.;
generate prob2b=.;
generate prob3b=.;
generate prob4b=.;
generate prob5b=.;
generate prob6b=.;
generate prob7b=.;
generate prob8b=.;
generate prob9b=.;
generate prob10b=.;
generate prob11b=.;
generate prob12b=.;
generate prob13b=.;
generate prob14b=.;
generate prob15b=.;


drawnorm b1-b19, means(coeffs) cov(covmat) double; 

/* run separate loop for each case to get same draws for eta */

nois _dots 0, title(parametric bootstrap) reps(1000);
forvalues j = 1/1000 {;

  mkmat b1-b19 if _n==`j', matrix(bdraw);
  mixlpred2 pprobs2; 
 
  replace dompar = dompar2;
  replace minor = minor2;
  replace minwin = minwin2;

  mixlpred2 pprobs3;

  replace dompar = dompar3;
  replace minor = minor3;
  replace minwin = minwin3;
 
  qui generate p1t = pprobs2 * c1;
  qui generate p2t = pprobs2 * c2;
  qui generate p3t = pprobs2 * c3;
  qui generate p4t = pprobs2 * c4; 
  qui generate p5t = pprobs2 * c5;
  qui generate p6t = pprobs2 * c6;
  qui generate p7t = pprobs2 * c7;
  qui generate p8t = pprobs2 * c8;
  qui generate p9t = pprobs2 * c9;
  qui generate p10t = pprobs2 * c10; 
  qui generate p11t = pprobs2 * c11;
  qui generate p12t = pprobs2 * c12;
  qui generate p13t = pprobs2 * c13;
  qui generate p14t = pprobs2 * c14; 
  qui generate p15t = pprobs2 * c15;

  egen p1tt = sum(p1t);
  egen p2tt = sum(p2t);
  egen p3tt = sum(p3t);
  egen p4tt = sum(p4t); 
  egen p5tt = sum(p5t);
  egen p6tt = sum(p6t);
  egen p7tt = sum(p7t);
  egen p8tt = sum(p8t); 
  egen p9tt = sum(p9t);
  egen p10tt = sum(p10t);
  egen p11tt = sum(p11t);
  egen p12tt = sum(p12t);
  egen p13tt = sum(p13t);
  egen p14tt = sum(p14t); 
  egen p15tt = sum(p15t);

  qui replace prob1 = p1tt if _n==`j';
  qui replace prob2 = p2tt if _n==`j';
  qui replace prob3 = p3tt if _n==`j';
  qui replace prob4 = p4tt if _n==`j';
  qui replace prob5 = p5tt if _n==`j';
  qui replace prob6 = p6tt if _n==`j';
  qui replace prob7 = p7tt if _n==`j';
  qui replace prob8 = p8tt if _n==`j';
  qui replace prob9 = p9tt if _n==`j';
  qui replace prob10 = p10tt if _n==`j';
  qui replace prob11 = p11tt if _n==`j';
  qui replace prob12 = p12tt if _n==`j';
  qui replace prob13 = p13tt if _n==`j';
  qui replace prob14 = p14tt if _n==`j';
  qui replace prob15 = p15tt if _n==`j';

  qui generate p1t3 = pprobs3 * c1;
  qui generate p2t3 = pprobs3 * c2;
  qui generate p3t3 = pprobs3 * c3;
  qui generate p4t3 = pprobs3 * c4; 
  qui generate p5t3 = pprobs3 * c5;
  qui generate p6t3 = pprobs3 * c6;
  qui generate p7t3 = pprobs3 * c7;
  qui generate p8t3 = pprobs3 * c8;
  qui generate p9t3 = pprobs3 * c9;
  qui generate p10t3 = pprobs3 * c10; 
  qui generate p11t3 = pprobs3 * c11;
  qui generate p12t3 = pprobs3 * c12;
  qui generate p13t3 = pprobs3 * c13;
  qui generate p14t3 = pprobs3 * c14; 
  qui generate p15t3 = pprobs3 * c15;

  egen p1tt3 = sum(p1t3);
  egen p2tt3 = sum(p2t3);
  egen p3tt3 = sum(p3t3);
  egen p4tt3 = sum(p4t3); 
  egen p5tt3 = sum(p5t3);
  egen p6tt3 = sum(p6t3);
  egen p7tt3 = sum(p7t3);
  egen p8tt3 = sum(p8t3); 
  egen p9tt3 = sum(p9t3);
  egen p10tt3 = sum(p10t3);
  egen p11tt3 = sum(p11t3);
  egen p12tt3 = sum(p12t3);
  egen p13tt3 = sum(p13t3);
  egen p14tt3 = sum(p14t3); 
  egen p15tt3 = sum(p15t3);

  qui replace prob1b = p1tt3 if _n==`j';
  qui replace prob2b = p2tt3 if _n==`j';
  qui replace prob3b = p3tt3 if _n==`j';
  qui replace prob4b = p4tt3 if _n==`j';
  qui replace prob5b = p5tt3 if _n==`j';
  qui replace prob6b = p6tt3 if _n==`j';
  qui replace prob7b = p7tt3 if _n==`j';
  qui replace prob8b = p8tt3 if _n==`j';
  qui replace prob9b = p9tt3 if _n==`j';
  qui replace prob10b = p10tt3 if _n==`j';
  qui replace prob11b = p11tt3 if _n==`j';
  qui replace prob12b = p12tt3 if _n==`j';
  qui replace prob13b = p13tt3 if _n==`j';
  qui replace prob14b = p14tt3 if _n==`j';
  qui replace prob15b = p15tt3 if _n==`j';


drop p1t p2t p3t p4t p5t p6t p7t p8t p9t p10t
     p11t p12t p13t p14t p15t  
     p1tt p2tt p3tt p4tt p5tt p6tt p7tt p8tt p9tt p10tt
     p11tt p12tt p13tt p14tt p15tt  
     p1t3 p2t3 p3t3 p4t3 p5t3 p6t3 p7t3 p8t3 p9t3 p10t3
     p11t3 p12t3 p13t3 p14t3 p15t3  
     p1tt3 p2tt3 p3tt3 p4tt3 p5tt3 p6tt3 p7tt3 p8tt3 p9tt3 p10tt3
     p11tt3 p12tt3 p13tt3 p14tt3 p15tt3  
     pprobs2 pprobs3;
  
nois _dots `j' 0;
  
};

generate pdiff1 = prob1b-prob1;
generate pdiff2 = prob2b-prob2;
generate pdiff3 = prob3b-prob3;
generate pdiff4 = prob4b-prob4;
generate pdiff5 = prob5b-prob5;
generate pdiff6 = prob6b-prob6;
generate pdiff7 = prob7b-prob7;
generate pdiff8 = prob8b-prob8;
generate pdiff9 = prob9b-prob9;
generate pdiff10 = prob10b-prob10;
generate pdiff11 = prob11b-prob11;
generate pdiff12 = prob12b-prob12;
generate pdiff13 = prob13b-prob13;
generate pdiff14 = prob14b-prob14;
generate pdiff15 = prob15b-prob15;

generate mprobA = .;
generate mprobB = .;
generate mdiff = .;
generate lci = .;
generate hci = .;

local k = 1;

while `k' < 16 {;

  egen mprob`k'A = median(prob`k');
  egen mprob`k'B = median(prob`k'b);
  egen mdiff`k' = median(pdiff`k');
  egen lci`k' = pctile(pdiff`k'), p(2.5);
  egen hci`k' = pctile(pdiff`k'), p(97.5);

  qui replace mprobA = mprob`k'A if _n==`k';
  qui replace mprobB = mprob`k'B if _n==`k';
  qui replace mdiff = mdiff`k' if _n==`k';
  qui replace lci = lci`k' if _n==`k';
  qui replace hci = hci`k' if _n==`k';

  drop mprob`k'A mprob`k'B mdiff`k' lci`k' hci`k';

  local k = `k' + 1;
};

generate pvdaind = pvda * -0.01 if pvda==1;
generate d66ind = d66 * -0.025 if d66==1;
generate cdaind = cda * -0.04 if cda==1;
generate vvdind = vvd * -0.055 if vvd==1;


generate partylab = .;
replace partylab = -0.01 if _n==16;
replace partylab = -0.025 if _n==17;
replace partylab = -0.04 if _n==18;
replace partylab = -0.055 if _n==19;

generate partylab2 = "";
replace partylab2 = "PvdA" if _n==16;
replace partylab2 = "D66" if _n==17;
replace partylab2 = "CDA" if _n==18;
replace partylab2 = "VVD" if _n==19;

replace ideology = -22 if partylab !=.;

keep mprobA mprobB mdiff lci hci ideology pvdaind d66ind cdaind vvdind partylab partylab2;

save Figure5, replace;

clear;

use Figure5;

/* manually jitter overlapping points */

replace ideology = -15.5 if ideology>-15.45 & ideology<-15.4;
replace ideology = -15.37 if ideology>-15.37 & ideology<-15.38;
replace ideology = -15.24 if ideology>-15.37 & ideology<-15.35;
replace ideology = -13.4 if ideology>-13.26 & ideology<-13.25;
replace ideology = -13 if ideology>-13.11 & ideology<-13.09;
replace ideology = -10.8 if ideology>-10.8 & ideology<-10.7;
replace ideology = -10.6 if ideology>-10.7 & ideology<-10.6;
replace ideology = -10.4 if ideology>-10.4 & ideology<-10.3;
replace ideology = -10.2 if ideology>-10.3 & ideology<-10.2;

replace pvdaind = -0.26 if pvdaind!=.;
replace d66ind = -0.295 if d66ind!=.;
replace cdaind = -0.33 if cdaind!=.;
replace vvdind = -0.365 if vvdind!=.;

replace partylab = -0.26 if _n==16;
replace partylab = -0.295 if _n==17;
replace partylab = -0.33 if _n==18;
replace partylab = -0.365 if _n==19;

graph twoway (scatter mdiff ideology, msymbol(o) mcolor(black) xtitle("CMP Ideology") 
ytitle("                    Probability") yline(-0.25, lcolor(black))) 
(rspike lci hci ideology, lcolor(black)) 
(scatter pvdaind ideology, msymbol(S) mfcolor(gs12) mlcolor(black)) (scatter d66ind ideology, msymbol(S) mfcolor(gs12) mlcolor(black)) 
(scatter cdaind ideology, msymbol(S) mfcolor(gs12) mlcolor(black)) (scatter vvdind ideology, msymbol(S) mfcolor(gs12) mlcolor(black))
(scatter partylab ideology, msymbol(i) mlabel(partylab2) mlabcolor(black) ), 
ylabel(-0.2 -0.1 0 0.1) legend(off); 
