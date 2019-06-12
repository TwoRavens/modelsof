
# delimit;
set more 1;

**** GLOBALS *****;
global 	InputFile "C:\Users\glv2\Dropbox\Dropbox\HSV\taxation\QJE_Final\Data\Figure_1\PSID_sampleB_DedSelf.dta";
global 	OutputDir "C:\Users\glv2\Dropbox\Dropbox\HSV\taxation\QJE_Final\Data\Figure_1\";
*********************;

clear;
clear matrix;
set mem 400m;
use $InputFile;
save $OutputDir\PSID_sampleB_SS.dta, replace;

use $OutputDir\PSID_sampleB_SS.dta;
sort id68 hpersno year;

**MEMORANDUM POSTGOVINC VARIABLE;
*redpregovinc is before benefits and taxes;
*redpostgovinc is after benefits, federal and state taxes;
*redpostgovincfica is after benefits, federal, state and payroll taxes;

gen fica = redpostgovinc - redpostgovincfica;
gen reddispinc = .;
replace reddispinc = redpostgovincfica;

gen lhlabinc   = log(hlabinc);
gen lwlabinc   = log(wlabinc);
gen lpregovinc = log(redpregovinc);
gen ldispinc   = log(reddispinc);

**SAMPLE SELECTION;
keep if year>=2000;
keep if hage>=25 & hage<=60;

*AGE-EARNINGS PROFILE BY GENDER-EDUCATION GROUP;
gen hage2 = hage^2;
gen hage3 = hage^3;
gen hage4 = hage^4;

gen wage2 = wage^2;
gen wage3 = wage^3;
gen wage4 = wage^4;

gen hedu = .;
replace hedu = 1 if hyrsed <12;
replace hedu = 2 if hyrsed >=12  & hyrsed<16;
replace hedu = 3 if hyrsed >=16;

gen wedu = .;
replace wedu = 1 if wyrsed <12;
replace wedu = 2 if wyrsed >=12  & wyrsed<16;
replace wedu = 3 if wyrsed >=16;

**HOUSEHOLD;
gen redpregovinchat = .;
levelsof hedu, local(levels);
foreach e of local levels {;
	reg lpregovinc hage hage2 hage3 if hedu == `e';
	predict yhat;
	replace redpregovinchat = exp(yhat) if hedu == `e';
drop yhat;
};

**HEADS;
gen hlabinchat = .;
levelsof hedu, local(levels);
foreach e of local levels {;
	reg lhlabinc hage hage2 hage3 if hedu == `e';
	predict yhat;
	replace hlabinchat = exp(yhat) if hedu == `e';
drop yhat;
};

**SPOUSES;
gen wlabinchat = .;
levelsof wedu, local(levels);
foreach e of local levels {;
	reg lwlabinc wage wage2 wage3 if wedu == `e';
	predict yhat;
	replace wlabinchat = exp(yhat) if wedu == `e';
drop yhat;
};


**SS TAX CALCULATION;
gen maxoasdi = .;
replace maxoasdi = 76200 if year == 2000;
replace maxoasdi = 84900 if year == 2002;
replace maxoasdi = 87900 if year == 2004;
replace maxoasdi = 94200 if year == 2006;

**CORRECT FOR SELF-EMPLOYMENT INCOME;
gen shareoasdi   = 1 - (hlabbus+wlabbus)/(hlabinc+wlabinc);
gen sharefica    = shareoasdi;
sort hedu hage;

**SS BENEFITS CALCULATION;
merge m:1 hedu hage using $OutputDir\hdatamatlab.dta;
sort wedu wage;
rename _merge _merge2;
merge m:1 wedu wage using $OutputDir\wdatamatlab.dta;
sort id68 hpersno year;
rename _merge _merge3;
replace wy_aime    = 0 if _merge3 == 1;
replace wy_aimelag = 0 if _merge3 == 1;
replace wadjfactor = 0 if _merge3 == 1;
replace wy_aimejk  = 0 if _merge3 == 1;

**REPLACEMENT RATES AND BENDPOINTS FOR YEARS 2000-06;
gen rr1 = 0.90;
gen rr2 = 0.32;
gen rr3 = 0.15;

gen bend1 = .;
replace bend1 = 531 if year == 2000;
replace bend1 = 592 if year == 2002;
replace bend1 = 612 if year == 2004;
replace bend1 = 656 if year == 2006;
gen bend2 = .;
replace bend2 = 3202 if year == 2000;
replace bend2 = 3567 if year == 2002;
replace bend2 = 3689 if year == 2004;
replace bend2 = 3955 if year == 2006;

** CALCULATION OF BENEFITS;
*HEADS;
gen hy_aimeadj1     = min(hy_aimejk*(hlabinc/hlabinchat),maxoasdi/12);
gen hssben1         = rr1*min(hy_aimeadj1,bend1) + rr2*max(min(hy_aimeadj1-bend1,bend2),0) + rr3*max(hy_aimeadj1-bend2,0);
gen hy_aimelagadj1  = min(hy_aimejk*(hlabinc/hlabinchat) - hlabinc/(12*35),maxoasdi/12);
gen hssbenlag1      = rr1*min(hy_aimelagadj1,bend1) + rr2*max(min(hy_aimelagadj1-bend1,bend2),0) + rr3*max(hy_aimelagadj1-bend2,0);
gen hannpengain1    = (hssben1 - hssbenlag1)*12;

*SPOUSES;
gen wy_aimeadj1     = min(wy_aimejk*(wlabinc/wlabinchat),maxoasdi/12);
gen wssben1         = rr1*min(wy_aimeadj1,bend1) + rr2*max(min(wy_aimeadj1-bend1,bend2),0) + rr3*max(wy_aimeadj1-bend2,0);
gen wy_aimelagadj1  = min(wy_aimejk*(wlabinc/wlabinchat) - wlabinc/(12*35),maxoasdi/12);
gen wssbenlag1      = rr1*min(wy_aimelagadj1,bend1) + rr2*max(min(wy_aimelagadj1-bend1,bend2),0) + rr3*max(wy_aimelagadj1-bend2,0);
gen wannpengain1    = (wssben1 - wssbenlag1)*12;

*COMBINE;
gen hwdpvpengain1   = (hannpengain1*hadjfactor + wannpengain1*wadjfactor);


**TRIMMING AT THE BOTTOM; 
*At least 1 adult working at MW ($5.15ph) part-time (for 1000=4h*5d*52w hours);
keep if (hlabinc>5150 | wlabinc>5150);
drop if redpregovinc<=5150;

**POOLED NONLINEAR LEAST SQUARES;
replace lpregovinc = log(redpregovinc - tot_deduction + 0.5*fica);
replace ldispinc = log(reddispinc - tot_deduction + 0.5*fica + hwdpvpengain1);

gen ldispinchat=.;
reg ldispinc lpregovinc;
predict yhat;
replace ldispinchat = yhat;
drop yhat;

* Save constant and slope;
gen lambda = _b[_cons];
gen tau = 1 - _b[lpregovinc];

**CONSTRUCT 100 BINS FOR PLOT;
keep if lpregovinc<. & ldispinc<.; 
foreach var of varlist lpregovinc {;
	gen ptile2 =.;
	foreach i of numlist 1(1)99.999999999{;
		_pctile `var', p(`i');
		*replace ptile2 = `i'/2 if ptile2 ==. & `var'<=r(r1);
		replace ptile2 = `i' if ptile2 ==. & `var'<=r(r1);
	};
};
replace ptile2=100 if ptile2==.;

**PLOT BINS;
collapse (mean)   mean_lpregovinc=lpregovinc mean_ldispinc=ldispinc,  by(ptile) fast;
graph twoway scatter mean_ldispinc mean_lpregovinc, ylabel(minmax) xlabel(minmax) ;
