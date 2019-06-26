capture log close
clearclear matrixlog using "CD_JPR_BankBallot.log", replace
# delimit ;*************************************************************************;*************************************************************************;* File to run models and calculate quantities of interest for the paper *;********************* "Bank and Ballot" *********************************;                                                               *************************************************************************;
* Paper authors: Conrad & DeMeritt               	                 *;            *************************************************************************;*************************************************************************;

clear;
clear matrix;
set mem 1000m;
set matsize 1000;*use "/Users/demeritt/Desktop/research/Conrad-DeMeritt/Opportunity and Willingness/first cut data/SubstHR.v5.dta", clear;
use "CD_JPR_BankBallot.dta", clear;
set seed 10312001;
set more off;
tsset ccode year;

* NOTE: CIRI physint and all component parts are flipped so that higher
* values indicate *decreasing* govt respect for rights, or increasing abuse.
* NOTE: oil_gas_rentPOP is Ross's oil measure
* ln_natres is the natural log of that measure +.001
* NOTE: gen dissent=assasinate+riots+guerrilla+coups (all from Banks);

gen ln_natres=ln(oil_gas_rentpop)+0.001;

* Generate necessary binary terms and lags;

* Labeling Variables;
label define physint 0 `"All Rights Fully Respected"', modify;
label define physint 8 `"All Rights Frequently Violated"', modify;
label define kill 0 `"No Extralegal Killing"', modify;
label define kill 1 `"Occasional Extralegal Killing"', modify;
label define kill 2 `"Frequent Extralegal Killing"', modify;
label define disap 0 `"No Disappearances"', modify;
label define disap 1 `"Occasional Disappearances"', modify;
label define disap 2 `"Frequent Disappearances"', modify;
label define polpris 0 `"No Political Imprisonment"', modify;
label define polpris 1 `"Occasional Political Imprisonment"', modify;
label define polpris 2 `"Frequent Political Imprisonment"', modify;
label define tort 0 `"No Torture"', modify;
label define tort 1 `"Occasional Torture"', modify;
label define tort 2 `"Frequent Torture"', modify;

* Rescale polity and create a democracy dummy for easier interpretation of interaction term;
gen polityrescale=.;
replace polityrescale=. if polity==.;
replace polityrescale=polity+10;
gen politydum=.;
replace politydum=1 if polity>=7;
replace politydum=0 if polity<7;
gen politydumsix=.;
replace politydumsix=1 if polity>=6;
replace politydumsix=0 if polity<6;

gen NotOil=.;
replace NotOil=0 if Oil==1;
replace NotOil=1 if Oil==0;

* Generate interaction terms;

* Democracy=polityrescale;
gen polity_x_rents=polityrescale*ln_natres;
gen polity_x_oil=polityrescale*Oil;
gen polity_x_dissent=polityrescale*dissent;
gen polity_x_rents_x_dissent=polityrescale*ln_natres*dissent;
gen polity_x_oil_x_dissent=polityrescale*Oil*dissent;
gen politysq=polityrescale*polityrescale;
gen politysq_x_rents=politysq*ln_natres;
gen politysq_x_oil=politysq*Oil;

* Democracy=politydum;
gen polityd_x_rents=politydum*ln_natres;
gen polityd_x_oil=politydum*Oil;
gen polityd_x_dissent=politydum*dissent;
gen polityd_x_rents_x_dissent=politydum*ln_natres*dissent;
gen polityd_x_oil_x_dissent=politydum*Oil*dissent;
gen politydsq=politydum*politydum;
gen politydsq_x_rents=politydsq*ln_natres;
gen politydsq_x_oil=politydsq*Oil;

*Democracy=politydumsix;
gen polityds_x_rents=politydumsix*ln_natres;
gen polityds_x_oil=politydumsix*Oil;
gen polityds_x_dissent=politydumsix*dissent;
gen polityds_x_rents_x_dissent=politydumsix*ln_natres*dissent;
gen polityds_x_oil_x_dissent=politydumsix*Oil*dissent;
gen politydssq= politydumsix*politydumsix;
gen politydssq_x_rents=politydssq*ln_natres;
gen politydssq_x_oil=politydssq*Oil;

* Democracy=democracy (Chiebub et al);
gen democ_x_rents=democracy*ln_natres;
gen democ_x_oil=democracy*Oil;
gen democ_x_dissent=democracy*dissent;
gen democ_x_rents_x_dissent=democracy*ln_natres*dissent;
gen democ_x_oil_x_dissent=democracy*Oil*dissent;
gen democsq=democracy*democracy;
gen democsq_x_rents=democsq*ln_natres;
gen democxq_x_oil=democsq*Oil;

gen dissent_x_rents=dissent*ln_natres;
gen dissent_x_notoil=dissent*NotOil;
gen dissent_x_polity=dissent*polityrescale;

****************;
* BEGIN MODELS *;
****************;
**********************;
* Main Paper Results *;
**********************;

**Table 1, Column 1**
* DV=PTS_s, UER=ln_natres;
ologit pts_s polityrescale ln_natres polity_x_rents rgdpch pop war dissent l.pts_s, cluster(ccode) robust nolog;
test polityrescale ln_natres polity_x_rents;


**Table 1, Column 2**
* DV=PTS_s, UER=Oil;
ologit pts_s polityrescale Oil polity_x_oil rgdpch pop war dissent l.pts_s, cluster(ccode) robust nolog;
test polityrescale Oil polity_x_oil;

*******************************************;
* Main Results, but with OLS 	           *;
*******************************************;

reg pts_s polityrescale ln_natres polity_x_rents rgdpch pop war dissent l.pts_s, cluster(ccode) robust;
test polityrescale ln_natres polity_x_rents;

reg pts_s polityrescale Oil polity_x_oil rgdpch pop war dissent l.pts_s, cluster(ccode) robust;
test polityrescale Oil polity_x_oil;

*********************************;
* Robustness checks for appendix ;
*********************************;

**********************************;
* Samples for Main Paper Results *;
**********************************;

* DV=PTS_s, UER=ln_natres;
quietly ologit pts_s polityrescale ln_natres polity_x_rents rgdpch pop war dissent l.pts_s, cluster(ccode) robust nolog;
sum year if e(sample)==1;
list country if e(sample)==1;

* DV=PTS_s, UER=Oil;
quietly ologit pts_s polityrescale Oil polity_x_oil rgdpch pop war dissent l.pts_s, cluster(ccode) robust nolog;
sum year if e(sample)==1;
list country if e(sample)==1;


***********************************************;
* Main Results, but with Physint for Appendix *;
***********************************************;

ologit physint polityrescale ln_natres polity_x_rents rgdpch pop war dissent l.physint, cluster(ccode) robust nolog;
test polityrescale ln_natres polity_x_rents;

ologit physint polityrescale Oil polity_x_oil rgdpch pop war dissent l.physint, cluster(ccode) robust nolog;
test polityrescale Oil polity_x_oil;

*******************************************************;
* Main Results, but with Physint and OLS for Appendix *;
*******************************************************;

reg physint polityrescale ln_natres polity_x_rents rgdpch pop war dissent l.physint, cluster(ccode) robust;
test polityrescale ln_natres polity_x_rents;

reg physint polityrescale Oil polity_x_oil rgdpch pop war dissent l.physint, cluster(ccode) robust;
test polityrescale Oil polity_x_oil;

********************************;
* Main Results, but with pts_a *;
********************************;

ologit pts_a polityrescale ln_natres polity_x_rents rgdpch pop war dissent l.pts_a, cluster(ccode) robust nolog;
test polityrescale ln_natres polity_x_rents;

ologit pts_a polityrescale Oil polity_x_oil rgdpch pop war dissent l.pts_a, cluster(ccode) robust nolog;
test polityrescale Oil polity_x_oil;

**************************************;
* Main Results, but with politydum   *;
* NOTE: polity cutpoint = 7 or above *;
**************************************;

ologit pts_s politydum ln_natres polityd_x_rents rgdpch pop war dissent l.pts_s, cluster(ccode) robust nolog;
test politydum ln_natres polityd_x_rents;

ologit pts_s politydum Oil polityd_x_oil rgdpch pop war dissent l.pts_s, cluster(ccode) robust nolog;
test politydum Oil polityd_x_oil;

*****************************************;
* Main Results, but with politydumsix   *;
* NOTE: polity cutpoint = 6 or above    *;
*****************************************;

ologit pts_s politydumsix ln_natres polityds_x_rents rgdpch pop war dissent l.pts_s, cluster(ccode) robust nolog;
test politydumsix ln_natres polityds_x_rents;

ologit pts_s politydumsix Oil polityds_x_oil rgdpch pop war dissent l.pts_s, cluster(ccode) robust nolog;
test politydumsix Oil polityds_x_oil;

*******************************************;
* Main Results, but with Chiebub et al DD *;
*******************************************;

ologit pts_s democracy ln_natres democ_x_rents rgdpch pop war dissent l.pts_s, cluster(ccode) robust nolog;
test democracy ln_natres democ_x_rents;

ologit pts_s democracy Oil democ_x_oil rgdpch pop war dissent l.pts_s, cluster(ccode) robust nolog;
test democracy Oil democ_x_oil;

*****************************************************;
* Main Results, but with democ^2 (MMM) as an IV (X) *;
*****************************************************;

***Table 1, Column 2**
** DV=PTS_s, UER=ln_natres;
ologit pts_s polityrescale politysq ln_natres polity_x_rents rgdpch pop war dissent l.pts_s, cluster(ccode) robust nolog;


***Table 1, Column 2**
** DV=PTS_s, UER=Oil;
ologit pts_s polityrescale politysq  Oil polity_x_oil rgdpch pop war dissent l.pts_s, cluster(ccode) robust nolog;


**************;
* END MODELS *;
**************;

*****************************;
* BEGIN SUBSTANTIVE EFFECTS *;
*****************************;
quietly{;
gen ccodel1=ccode[_n-1];
gen ptsl1=pts_s[_n-1];
replace ptsl1=. if ccode~=ccodel1;
gen ln_natres2=ln_natres+8;
};
****************;
* Hypothesis 1 *;
****************;

*UER=ln(fuel rents);
quietly estsimp ologit pts_s polityrescale ln_natres polity_x_rents rgdpch pop war dissent ptsl1, cluster(ccode) robust;
setx p50;

*gen Prval(Y=1 | polity @ min, max) over ln(fuel);
generate plo_aut=.;
generate p1_aut=.;
generate phi_aut=.;
generate plo_dem=.;
generate p1_dem=.;
generate phi_dem=.;

egen fuelaxis=seq(), from (-8) to (10);
setx polityrescale 0;
local a=-8;
while `a' <=10 {;
	setx ln_natres `a';
	simqi, prval(1) genpr(pi);
	_pctile pi, p(25,50,75);
	replace plo_aut = r(r1) if fuelaxis==`a';
	replace p1_aut = r(r2) if fuelaxis==`a';
	replace phi_aut = r(r3) if fuelaxis==`a';
	drop pi;
	local a=`a'+1;
	};

setx polityrescale 20;
local a=-8;
while `a' <=10 {;
	setx ln_natres `a';
	simqi, prval(1) genpr(pi);
	_pctile pi, p(25,50,75);
	replace plo_dem = r(r1) if fuelaxis==`a';
	replace p1_dem = r(r2) if fuelaxis==`a';
	replace phi_dem = r(r3) if fuelaxis==`a';
	drop pi;
	local a=`a'+1;
	};
		
sort fuelaxis;
graph twoway line p1_aut fuelaxis, clwidth(medthick) clcolor(black)
			|| line plo_aut fuelaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_aut fuelaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_dem fuelaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_dem fuelaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_dem fuelaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Autocracy") lab(4 "Democracy"))
				xtitle(ln(Fuel Rents), size(3.5))
				ytitle(Pr(PTS=1), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white));

graph export hyp1_fuel_pts1.pdf, replace;


*gen Prval(Y=2 | polity @ min, max) over ln(fuel);
drop plo_* p1_* phi_* fuelaxis;
generate plo_aut=.;
generate p1_aut=.;
generate phi_aut=.;
generate plo_dem=.;
generate p1_dem=.;
generate phi_dem=.;

egen fuelaxis=seq(), from (-8) to (10);
setx polityrescale 0;
local a=-8;
while `a' <=10 {;
	setx ln_natres `a';
	simqi, prval(2) genpr(pi);
	_pctile pi, p(25,50,75);
	replace plo_aut = r(r1) if fuelaxis==`a';
	replace p1_aut = r(r2) if fuelaxis==`a';
	replace phi_aut = r(r3) if fuelaxis==`a';
	drop pi;
	local a=`a'+.5;
	};

setx polityrescale 20;
local a=-8;
while `a' <=10 {;
	setx ln_natres `a';
	simqi, prval(2) genpr(pi);
	_pctile pi, p(25,50,75);
	replace plo_dem = r(r1) if fuelaxis==`a';
	replace p1_dem = r(r2) if fuelaxis==`a';
	replace phi_dem = r(r3) if fuelaxis==`a';
	drop pi;
	local a=`a'+.5;
	};
		
sort fuelaxis;
graph twoway line p1_aut fuelaxis, clwidth(medthick) clcolor(black)
			|| line plo_aut fuelaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_aut fuelaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_dem fuelaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_dem fuelaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_dem fuelaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Autocracy") lab(4 "Democracy"))
				xtitle(ln(Fuel Rents), size(3.5))
				ytitle(Pr(PTS=2), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white));

graph export hyp1_fuel_pts2.pdf, replace;

*gen Prval(Y=3 | polity @ min, max) over ln(fuel);
drop plo_* p1_* phi_* fuelaxis;
generate plo_aut=.;
generate p1_aut=.;
generate phi_aut=.;
generate plo_dem=.;
generate p1_dem=.;
generate phi_dem=.;

egen fuelaxis=seq(), from (-8) to (10);
setx polityrescale 0;
local a=-8;
while `a' <=10 {;
	setx ln_natres `a';
	simqi, prval(3) genpr(pi);
	_pctile pi, p(25,50,75);
	replace plo_aut = r(r1) if fuelaxis==`a';
	replace p1_aut = r(r2) if fuelaxis==`a';
	replace phi_aut = r(r3) if fuelaxis==`a';
	drop pi;
	local a=`a'+.5;
	};

setx polityrescale 20;
local a=-8;
while `a' <=10 {;
	setx ln_natres `a';
	simqi, prval(3) genpr(pi);
	_pctile pi, p(25,50,75);
	replace plo_dem = r(r1) if fuelaxis==`a';
	replace p1_dem = r(r2) if fuelaxis==`a';
	replace phi_dem = r(r3) if fuelaxis==`a';
	drop pi;
	local a=`a'+.5;
	};
		
sort fuelaxis;
graph twoway line p1_aut fuelaxis, clwidth(medthick) clcolor(black)
			|| line plo_aut fuelaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_aut fuelaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_dem fuelaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_dem fuelaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_dem fuelaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Autocracy") lab(4 "Democracy"))
				xtitle(ln(Fuel Rents), size(3.5))
				ytitle(Pr(PTS=3), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white))
				saving(hyp1_fuel_pts3, replace);

graph export hyp1_fuel_pts3.pdf, replace;

*gen Prval(Y=4 | polity @ min, max) over ln(fuel);
drop plo_* p1_* phi_* fuelaxis;
generate plo_aut=.;
generate p1_aut=.;
generate phi_aut=.;
generate plo_dem=.;
generate p1_dem=.;
generate phi_dem=.;

egen fuelaxis=seq(), from (-8) to (10);
setx polityrescale 0;
local a=-8;
while `a' <=10 {;
	setx ln_natres `a';
	simqi, prval(4) genpr(pi);
	_pctile pi, p(25,50,75);
	replace plo_aut = r(r1) if fuelaxis==`a';
	replace p1_aut = r(r2) if fuelaxis==`a';
	replace phi_aut = r(r3) if fuelaxis==`a';
	drop pi;
	local a=`a'+.5;
	};

setx polityrescale 20;
local a=-8;
while `a' <=10 {;
	setx ln_natres `a';
	simqi, prval(4) genpr(pi);
	_pctile pi, p(25,50,75);
	replace plo_dem = r(r1) if fuelaxis==`a';
	replace p1_dem = r(r2) if fuelaxis==`a';
	replace phi_dem = r(r3) if fuelaxis==`a';
	drop pi;
	local a=`a'+.5;
	};
		
sort fuelaxis;
graph twoway line p1_aut fuelaxis, clwidth(medthick) clcolor(black)
			|| line plo_aut fuelaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_aut fuelaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_dem fuelaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_dem fuelaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_dem fuelaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Autocracy") lab(4 "Democracy"))
				xtitle(ln(Fuel Rents), size(3.5))
				ytitle(Pr(PTS=4), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white))
				saving(hyp1_fuel_pts4, replace);

graph export hyp1_fuel_pts4.pdf, replace;

*gen Prval(Y=5 | polity @ min, max) over ln(fuel);
drop plo_* p1_* phi_* fuelaxis;
generate plo_aut=.;
generate p1_aut=.;
generate phi_aut=.;
generate plo_dem=.;
generate p1_dem=.;
generate phi_dem=.;

egen fuelaxis=seq(), from (-8) to (10);
setx polityrescale 0;
local a=-8;
while `a' <=10 {;
	setx ln_natres `a';
	simqi, prval(5) genpr(pi);
	_pctile pi, p(25,50,75);
	replace plo_aut = r(r1) if fuelaxis==`a';
	replace p1_aut = r(r2) if fuelaxis==`a';
	replace phi_aut = r(r3) if fuelaxis==`a';
	drop pi;
	local a=`a'+.5;
	};

setx polityrescale 20;
local a=-8;
while `a' <=10 {;
	setx ln_natres `a';
	simqi, prval(5) genpr(pi);
	_pctile pi, p(25,50,75);
	replace plo_dem = r(r1) if fuelaxis==`a';
	replace p1_dem = r(r2) if fuelaxis==`a';
	replace phi_dem = r(r3) if fuelaxis==`a';
	drop pi;
	local a=`a'+.5;
	};
		
sort fuelaxis;
graph twoway line p1_aut fuelaxis, clwidth(medthick) clcolor(black)
			|| line plo_aut fuelaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_aut fuelaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_dem fuelaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_dem fuelaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_dem fuelaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Autocracy") lab(4 "Democracy"))
				xtitle(ln(Fuel Rents), size(3.5))
				ytitle(Pr(PTS=5), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white));

graph export hyp1_fuel_pts5.pdf, replace;

graph combine hyp1_fuel_pts3.gph hyp1_fuel_pts4.gph, 
	cols(1)
	fxsize(75)
	commonscheme scheme(s2mono) 
	graphregion(fcolor(white));
	
graph export figure1.pdf, replace;

*UER=Oil;
drop b*;
quietly estsimp ologit pts_s polity Oil polity_x_oil rgdpch pop war dissent ptsl1, cluster(ccode) robust;
setx p50;

*Autocracies;
setx polity -10;

*gen Prval(Y=1 | polity @ min, max) over oil;
setx Oil min;
simqi, prval(1);
setx Oil max;
simqi, prval(1);

*gen Prval(Y=2 | polity @ min, max) over oil;
setx Oil min;
simqi, prval(2);
setx Oil max;
simqi, prval(2);

*gen Prval(Y=3 | polity @ min, max) over oil;
setx Oil min;
simqi, prval(3);
setx Oil max;
simqi, prval(3);

*gen Prval(Y=4 | polity @ min, max) over oil;
setx Oil min;
simqi, prval(4);
setx Oil max;
simqi, prval(4);

*gen Prval(Y=5 | polity @ min, max) over oil;
setx Oil min;
simqi, prval(5);
setx Oil max;
simqi, prval(5);

*Democracies;
setx polity 10;

*gen Prval(Y=1 | polity @ min, max) over oil;
setx Oil min;
simqi, prval(1);
setx Oil max;
simqi, prval(1);

*gen Prval(Y=2 | polity @ min, max) over oil;
setx Oil min;
simqi, prval(2);
setx Oil max;
simqi, prval(2);

*gen Prval(Y=3 | polity @ min, max) over oil;
setx Oil min;
simqi, prval(3);
setx Oil max;
simqi, prval(3);

*gen Prval(Y=4 | polity @ min, max) over oil;
setx Oil min;
simqi, prval(4);
setx Oil max;
simqi, prval(4);

*gen Prval(Y=5 | polity @ min, max) over oil;
setx Oil min;
simqi, prval(5);
setx Oil max;
simqi, prval(5);
	  
****************;
* Hypothesis 2 *;
****************;

*UER=ln(fuel rents);
drop b*;
quietly estsimp ologit pts_s polity ln_natres polity_x_rents rgdpch pop war dissent ptsl1, cluster(ccode) robust;
setx p50;

*gen Prval(Y=1 | ln(fuel) @ min, max) over polity;
drop plo_* p1_* phi_* fuelaxis;
generate plo_minfuel=.;
generate p1_minfuel=.;
generate phi_minfuel=.;
generate plo_maxfuel=.;
generate p1_maxfuel=.;
generate phi_maxfuel=.;

egen polityaxis=seq(), from (-10) to (10);
setx ln_natres min;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(1) genpr(pi);
	_pctile pi, p(25,50,75);
	replace plo_minfuel = r(r1) if polityaxis ==`a';
	replace p1_minfuel = r(r2) if polityaxis ==`a';
	replace phi_minfuel = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};

setx ln_natres max;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(1) genpr(pi);
	_pctile pi, p(25,50,75);
	replace plo_maxfuel = r(r1) if polityaxis ==`a';
	replace p1_maxfuel = r(r2) if polityaxis ==`a';
	replace phi_maxfuel = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};
		
sort polityaxis;
graph twoway line p1_minfuel polityaxis, clwidth(medthick) clcolor(black)
			|| line plo_minfuel polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_minfuel polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_maxfuel polityaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_maxfuel polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_maxfuel polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Minimum Fuel Rents") lab(4 "Maximum Fuel Rents"))
				xtitle(Democracy, size(3.5))
				ytitle(Pr(PTS=1), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white));

graph export hyp2_fuel_pts1.pdf, replace;

*gen Prval(Y=2 | ln(fuel) @ min, max) over polity;
drop plo_* p1_* phi_* polityaxis;
generate plo_minfuel=.;
generate p1_minfuel=.;
generate phi_minfuel=.;
generate plo_maxfuel=.;
generate p1_maxfuel=.;
generate phi_maxfuel=.;

egen polityaxis=seq(), from (-10) to (10);
setx ln_natres min;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(2) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_minfuel = r(r1) if polityaxis ==`a';
	replace p1_minfuel = r(r2) if polityaxis ==`a';
	replace phi_minfuel = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};

setx ln_natres max;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(2) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_maxfuel = r(r1) if polityaxis ==`a';
	replace p1_maxfuel = r(r2) if polityaxis ==`a';
	replace phi_maxfuel = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};
		
sort polityaxis;
graph twoway line p1_minfuel polityaxis, clwidth(medthick) clcolor(black)
			|| line plo_minfuel polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_minfuel polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_maxfuel polityaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_maxfuel polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_maxfuel polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Minimum Fuel Rents") lab(4 "Maximum Fuel Rents"))
				xtitle(Democracy, size(3.5))
				ytitle(Pr(PTS=2), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white));

graph export hyp2_fuel_pts2.pdf, replace;

*gen Prval(Y=3 | ln(fuel) @ min, max) over polity;
drop plo_* p1_* phi_* polityaxis;
generate plo_minfuel=.;
generate p1_minfuel=.;
generate phi_minfuel=.;
generate plo_maxfuel=.;
generate p1_maxfuel=.;
generate phi_maxfuel=.;

egen polityaxis=seq(), from (-10) to (10);
setx ln_natres min;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(3) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_minfuel = r(r1) if polityaxis ==`a';
	replace p1_minfuel = r(r2) if polityaxis ==`a';
	replace phi_minfuel = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};

setx ln_natres max;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(3) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_maxfuel = r(r1) if polityaxis ==`a';
	replace p1_maxfuel = r(r2) if polityaxis ==`a';
	replace phi_maxfuel = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};
		
sort polityaxis;
graph twoway line p1_minfuel polityaxis, clwidth(medthick) clcolor(black)
			|| line plo_minfuel polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_minfuel polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_maxfuel polityaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_maxfuel polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_maxfuel polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Min. Rents") lab(4 "Max. Rents"))
				xtitle(Democracy, size(3.5))
				ytitle(Pr(PTS=3), size(3.5))
				xsca(titlegap(4))
				ysca(titlegap(4))
				scheme(s2mono) graphregion(fcolor(white))
				saving(hyp2_fuel_pts3, replace);

graph export hyp2_fuel_pts3.pdf, replace;

*gen Prval(Y=4 | ln(fuel) @ min, max) over polity;
drop plo_* p1_* phi_* polityaxis;
generate plo_minfuel=.;
generate p1_minfuel=.;
generate phi_minfuel=.;
generate plo_maxfuel=.;
generate p1_maxfuel=.;
generate phi_maxfuel=.;

egen polityaxis=seq(), from (-10) to (10);
setx ln_natres min;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(4) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_minfuel = r(r1) if polityaxis ==`a';
	replace p1_minfuel = r(r2) if polityaxis ==`a';
	replace phi_minfuel = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};

setx ln_natres max;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(4) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_maxfuel = r(r1) if polityaxis ==`a';
	replace p1_maxfuel = r(r2) if polityaxis ==`a';
	replace phi_maxfuel = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};
		
sort polityaxis;
graph twoway line p1_minfuel polityaxis, clwidth(medthick) clcolor(black)
			|| line plo_minfuel polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_minfuel polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_maxfuel polityaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_maxfuel polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_maxfuel polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Min. Rents") lab(4 "Max. Rents"))
				xtitle(Democracy, size(3.5))
				ytitle(Pr(PTS=4), size(3.5))
				xsca(titlegap(4))
				ysca(titlegap(4))
				scheme(s2mono) graphregion(fcolor(white))
				saving(hyp2_fuel_pts4, replace);

graph export hyp2_fuel_pts4.pdf, replace;

*gen Prval(Y=5 | ln(fuel) @ min, max) over polity;
drop plo_* p1_* phi_* polityaxis;
generate plo_minfuel=.;
generate p1_minfuel=.;
generate phi_minfuel=.;
generate plo_maxfuel=.;
generate p1_maxfuel=.;
generate phi_maxfuel=.;

egen polityaxis=seq(), from (-10) to (10);
setx ln_natres min;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(5) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_minfuel = r(r1) if polityaxis ==`a';
	replace p1_minfuel = r(r2) if polityaxis ==`a';
	replace phi_minfuel = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};

setx ln_natres max;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(5) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_maxfuel = r(r1) if polityaxis ==`a';
	replace p1_maxfuel = r(r2) if polityaxis ==`a';
	replace phi_maxfuel = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};
		
sort polityaxis;
graph twoway line p1_minfuel polityaxis, clwidth(medthick) clcolor(black)
			|| line plo_minfuel polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_minfuel polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_maxfuel polityaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_maxfuel polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_maxfuel polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Minimum Fuel Rents") lab(4 "Maximum Fuel Rents"))
				xtitle(Democracy, size(3.5))
				ytitle(Pr(PTS=5), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white));

graph export hyp2_fuel_pts5.pdf, replace;

graph combine hyp2_fuel_pts3.gph hyp2_fuel_pts4.gph,
	cols(1)
	fxsize(75)
	commonscheme scheme(s2mono)
	graphregion(fcolor(white));
	
graph export figure3.pdf, replace;

*UER=Oil;
drop b*;
quietly estsimp ologit pts_s polity Oil polity_x_oil rgdpch pop war dissent ptsl1, cluster(ccode) robust;
setx p50;

*gen Prval(Y=1 | Oil @ min, max) over polity;
drop plo_* p1_* phi_* polityaxis;
generate plo_minoil=.;
generate p1_minoil=.;
generate phi_minoil=.;
generate plo_maxoil=.;
generate p1_maxoil=.;
generate phi_maxoil=.;

egen polityaxis=seq(), from (-10) to (10);
setx Oil min;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(1) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_minoil = r(r1) if polityaxis ==`a';
	replace p1_minoil = r(r2) if polityaxis ==`a';
	replace phi_minoil = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};

setx Oil max;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(1) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_maxoil = r(r1) if polityaxis ==`a';
	replace p1_maxoil = r(r2) if polityaxis ==`a';
	replace phi_maxoil = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};
		
sort polityaxis;
graph twoway line p1_minoil polityaxis, clwidth(medthick) clcolor(black)
			|| line plo_minoil polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_minoil polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_maxoil polityaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_maxoil polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_maxoil polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Not Oil Exporter") lab(4 "Oil Exporter"))
				xtitle(Democracy, size(3.5))
				ytitle(Pr(PTS=1), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white));

graph export hyp2_oil_pts1.pdf, replace;

*gen Prval(Y=2 | Oil @ min, max) over polity;
drop plo_* p1_* phi_* polityaxis;
generate plo_minoil=.;
generate p1_minoil=.;
generate phi_minoil=.;
generate plo_maxoil=.;
generate p1_maxoil=.;
generate phi_maxoil=.;

egen polityaxis=seq(), from (-10) to (10);
setx Oil min;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(2) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_minoil = r(r1) if polityaxis ==`a';
	replace p1_minoil = r(r2) if polityaxis ==`a';
	replace phi_minoil = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};

setx Oil max;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(2) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_maxoil = r(r1) if polityaxis ==`a';
	replace p1_maxoil = r(r2) if polityaxis ==`a';
	replace phi_maxoil = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};
		
sort polityaxis;
graph twoway line p1_minoil polityaxis, clwidth(medthick) clcolor(black)
			|| line plo_minoil polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_minoil polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_maxoil polityaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_maxoil polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_maxoil polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Not Oil Exporter") lab(4 "Oil Exporter"))
				xtitle(Democracy, size(3.5))
				ytitle(Pr(PTS=2), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white));

graph export hyp2_oil_pts2.pdf, replace;

*gen Prval(Y=3 | Oil @ min, max) over polity;
drop plo_* p1_* phi_* polityaxis;
generate plo_minoil=.;
generate p1_minoil=.;
generate phi_minoil=.;
generate plo_maxoil=.;
generate p1_maxoil=.;
generate phi_maxoil=.;

egen polityaxis=seq(), from (-10) to (10);
setx Oil min;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(3) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_minoil = r(r1) if polityaxis ==`a';
	replace p1_minoil = r(r2) if polityaxis ==`a';
	replace phi_minoil = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};

setx Oil max;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(3) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_maxoil = r(r1) if polityaxis ==`a';
	replace p1_maxoil = r(r2) if polityaxis ==`a';
	replace phi_maxoil = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+1;
	};
		
sort polityaxis;
graph twoway line p1_minoil polityaxis, clwidth(medthick) clcolor(black)
			|| line plo_minoil polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_minoil polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_maxoil polityaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_maxoil polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_maxoil polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Not Oil Exporter") lab(4 "Oil Exporter"))
				xtitle(Democracy, size(3.5))
				ytitle(Pr(PTS=3), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white))
				saving(hyp2_oil_pts3, replace);

graph export hyp2_oil_pts3.pdf, replace;

*gen Prval(Y=4 | Oil @ min, max) over polity;
drop plo_* p1_* phi_* polityaxis;
generate plo_minoil=.;
generate p1_minoil=.;
generate phi_minoil=.;
generate plo_maxoil=.;
generate p1_maxoil=.;
generate phi_maxoil=.;

egen polityaxis=seq(), from (-10) to (10);
setx Oil min;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(4) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_minoil = r(r1) if polityaxis ==`a';
	replace p1_minoil = r(r2) if polityaxis ==`a';
	replace phi_minoil = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+.5;
	};

setx Oil max;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(4) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_maxoil = r(r1) if polityaxis ==`a';
	replace p1_maxoil = r(r2) if polityaxis ==`a';
	replace phi_maxoil = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+.5;
	};
		
sort polityaxis;
graph twoway line p1_minoil polityaxis, clwidth(medthick) clcolor(black)
			|| line plo_minoil polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_minoil polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_maxoil polityaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_maxoil polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_maxoil polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Not Oil Exporter") lab(4 "Oil Exporter"))
				xtitle(Democracy, size(3.5))
				ytitle(Pr(PTS=4), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white))
				saving(hyp2_oil_pts4, replace);

graph export hyp2_oil_pts4.pdf, replace;

*gen Prval(Y=5 | Oil @ min, max) over polity;
drop plo_* p1_* phi_* polityaxis;
generate plo_minoil=.;
generate p1_minoil=.;
generate phi_minoil=.;
generate plo_maxoil=.;
generate p1_maxoil=.;
generate phi_maxoil=.;

egen polityaxis=seq(), from (-10) to (10);
setx Oil min;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(5) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_minoil = r(r1) if polityaxis ==`a';
	replace p1_minoil = r(r2) if polityaxis ==`a';
	replace phi_minoil = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+.5;
	};

setx Oil max;
local a=-10;
while `a' <=10 {;
	setx polity `a';
	simqi, prval(5) genpr(pi);
	_pctile pi, p(15,50,85);
	replace plo_maxoil = r(r1) if polityaxis ==`a';
	replace p1_maxoil = r(r2) if polityaxis ==`a';
	replace phi_maxoil = r(r3) if polityaxis ==`a';
	drop pi;
	local a=`a'+.5;
	};
		
sort polityaxis;
graph twoway line p1_minoil polityaxis, clwidth(medthick) clcolor(black)
			|| line plo_minoil polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line phi_minoil polityaxis, clpattern(solid) clwidth(thin) clcolor(gs5)
			|| line p1_maxoil polityaxis, clpattern(longdash) clwidth(medthick) clcolor(black)
			|| line plo_maxoil polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| line phi_maxoil polityaxis, clpattern(longdash) clwidth(thin) clcolor(gs5)
			|| ,
				xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, labsize(3))
				yscale(noline)
				xscale(noline)
				legend(order(1 4) lab(1 "Not Oil Exporter") lab(4 "Oil Exporter"))
				xtitle(Democracy, size(3.5))
				ytitle(Pr(PTS=5), size(3.5))
				xsca(titlegap(2))
				ysca(titlegap(2))
				scheme(s2mono) graphregion(fcolor(white));

graph export hyp2_oil_pts5.pdf, replace;

graph combine hyp2_oil_pts3.gph hyp2_oil_pts4.gph,
	cols(1)
	fxsize(75)
	commonscheme scheme(s2mono)
	graphregion(fcolor(white));

graph export figure4.pdf, replace;

***************************;
* END SUBSTANTIVE EFFECTS *;
***************************;

***;
* Marginal effects for online supplement;
***;

quietly{;
clear;
clear matrix;
set mem 1000m;
set matsize 1000;*use "/Users/demeritt/Desktop/research/Conrad-DeMeritt/Opportunity and Willingness/first cut data/SubstHR.v5.dta", clear;
use "SubstHR.v5.dta", clear;
set seed 10312001;
set more off;
tsset ccode year;

* NOTE: CIRI physint and all component parts are flipped so that higher
* values indicate *decreasing* govt respect for rights, or increasing abuse.
* NOTE: oil_gas_rentPOP is Ross's oil measure
* ln_natres is the natural log of that measure +.001
* NOTE: gen dissent=assasinate+riots+guerrilla+coups (all from Banks);

gen ln_natres=ln(oil_gas_rentpop)+0.001;

* Generate necessary binary terms and lags;

* Labeling Variables;
label define physint 0 `"All Rights Fully Respected"', modify;
label define physint 8 `"All Rights Frequently Violated"', modify;
label define kill 0 `"No Extralegal Killing"', modify;
label define kill 1 `"Occasional Extralegal Killing"', modify;
label define kill 2 `"Frequent Extralegal Killing"', modify;
label define disap 0 `"No Disappearances"', modify;
label define disap 1 `"Occasional Disappearances"', modify;
label define disap 2 `"Frequent Disappearances"', modify;
label define polpris 0 `"No Political Imprisonment"', modify;
label define polpris 1 `"Occasional Political Imprisonment"', modify;
label define polpris 2 `"Frequent Political Imprisonment"', modify;
label define tort 0 `"No Torture"', modify;
label define tort 1 `"Occasional Torture"', modify;
label define tort 2 `"Frequent Torture"', modify;

* Rescale polity and create a democracy dummy for easier interpretation of interaction term;
gen polityrescale=.;
replace polityrescale=. if polity==.;
replace polityrescale=polity+10;
gen politydum=.;
replace politydum=1 if polity>=7;
replace politydum=0 if polity<7;
gen politydumsix=.;
replace politydumsix=1 if polity>=6;
replace politydumsix=0 if polity<6;

gen NotOil=.;
replace NotOil=0 if Oil==1;
replace NotOil=1 if Oil==0;

* Generate interaction terms;

* Democracy=polityrescale;
gen polity_x_rents=polityrescale*ln_natres;
gen polity_x_oil=polityrescale*Oil;
gen polity_x_dissent=polityrescale*dissent;
gen polity_x_rents_x_dissent=polityrescale*ln_natres*dissent;
gen polity_x_oil_x_dissent=polityrescale*Oil*dissent;
gen politysq=polityrescale*polityrescale;
gen politysq_x_rents=politysq*ln_natres;
gen politysq_x_oil=politysq*Oil;

* Democracy=politydum;
gen polityd_x_rents=politydum*ln_natres;
gen polityd_x_oil=politydum*Oil;
gen polityd_x_dissent=politydum*dissent;
gen polityd_x_rents_x_dissent=politydum*ln_natres*dissent;
gen polityd_x_oil_x_dissent=politydum*Oil*dissent;
gen politydsq=politydum*politydum;
gen politydsq_x_rents=politydsq*ln_natres;
gen politydsq_x_oil=politydsq*Oil;

*Democracy=politydumsix;
gen polityds_x_rents=politydumsix*ln_natres;
gen polityds_x_oil=politydumsix*Oil;
gen polityds_x_dissent=politydumsix*dissent;
gen polityds_x_rents_x_dissent=politydumsix*ln_natres*dissent;
gen polityds_x_oil_x_dissent=politydumsix*Oil*dissent;
gen politydssq= politydumsix*politydumsix;
gen politydssq_x_rents=politydssq*ln_natres;
gen politydssq_x_oil=politydssq*Oil;

* Democracy=democracy (Chiebub et al);
gen democ_x_rents=democracy*ln_natres;
gen democ_x_oil=democracy*Oil;
gen democ_x_dissent=democracy*dissent;
gen democ_x_rents_x_dissent=democracy*ln_natres*dissent;
gen democ_x_oil_x_dissent=democracy*Oil*dissent;
gen democsq=democracy*democracy;
gen democsq_x_rents=democsq*ln_natres;
gen democxq_x_oil=democsq*Oil;

gen dissent_x_rents=dissent*ln_natres;
gen dissent_x_notoil=dissent*NotOil;
gen dissent_x_polity=dissent*polityrescale;

};
***;
* Marginal effects for online supplement;
***;


****************;
* Hypothesis 1 *;
****************;
sort ccode year;
* Model 1 (UER=fuel rents);
reg pts_s ln_natres polity polity_x_rents rgdpch pop war dissent l.pts_s, cluster(ccode) robust;
generate MV=((_n-101)/10);
replace MV=. if _n>201;

quietly{;
matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b2=b[1,2];
scalar b3=b[1,3];
scalar b4=b[1,4];
scalar b5=b[1,5];
scalar b6=b[1,6];
scalar b7=b[1,7];
scalar b8=b[1,8];
scalar b9=b[1,9];

scalar varb1=V[1,1];
scalar varb2=V[2,2];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];
scalar covb2b3=V[2,3];
};

scalar list b1 b2 b3 b4 b5 b6 b7 b8 b9 varb1 varb2 varb3 covb1b3 covb2b3;

gen conb=b1+b3*MV if _n<201;

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<201;

*gen a=1.96*conse;
gen a=1.645*conse;
gen upper=conb+a;
gen lower=conb-a;

graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   ,   
             xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, labsize(2.5)) 
             ylabel(-.025 0 .025 .05,   labsize(2.5))
             yscale(noline)
             xscale(noline)
             legend(col(2) order(1 2) label(1 "Marginal Effect of UER") 
                                      label(2 "95% Confidence Interval") 
                                      label(3 " "))
             title("UER = ln(fuel and natural gas rents)", size(4))
             subtitle(" " "" " ", size(3))
             xtitle( Democracy, size(3)  )
             xsca(titlegap(2))
             ysca(titlegap(2))
             ytitle("Marginal Effect of Unearned Revenue", size(3))
             scheme(s2mono) graphregion(fcolor(white));
             
graph export me_hyp1_fuel.pdf, replace;

*Hyp 1, Model 2 (UER=oil exports);
clear matrix;
drop MV conb conse a upper lower;
reg pts_s Oil polity polity_x_oil rgdpch pop war dissent l.pts_s, cluster(ccode) robust;

generate MV=((_n-101)/10);
replace MV=. if _n>201;

quietly{;
matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b2=b[1,2];
scalar b3=b[1,3];
scalar b4=b[1,4];
scalar b5=b[1,5];
scalar b6=b[1,6];
scalar b7=b[1,7];
scalar b8=b[1,8];
scalar b9=b[1,9];

scalar varb1=V[1,1];
scalar varb2=V[2,2];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];
scalar covb2b3=V[2,3];
};

scalar list b1 b2 b3 b4 b5 b6 b7 b8 b9 varb1 varb2 varb3 covb1b3 covb2b3;

gen conb=b1+b3*MV if _n<201;

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<201;

gen a=1.96*conse;
*gen a=1.645*conse;
gen upper=conb+a;
gen lower=conb-a;

graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   ,   
             xlabel(-10 -8 -6 -4 -2 0 2 4 6 8 10, labsize(2.5)) 
             ylabel(-.3 -.15 0 .15 .3,   labsize(2.5))
             yscale(noline)
             xscale(noline)
             legend(col(2) order(1 2) label(1 "Marginal Effect of UER") 
                                      label(2 "95% Confidence Interval") 
                                      label(3 " "))
             title("UER = Oil Exporter?", size(4))
             subtitle(" " "" " ", size(3))
             xtitle( Democracy, size(3)  )
             xsca(titlegap(2))
             ysca(titlegap(2))
             ytitle("Marginal Effect of Unearned Revenue", size(3))
             scheme(s2mono) graphregion(fcolor(white));
             
graph export me_hyp1_oil.pdf, replace;


****************;
* Hypothesis 2 *;
****************;

*Model 1 (UER=fuel rents);

clear matrix;
drop MV conb conse a upper lower;

reg pts_s polity ln_natres polity_x_rents rgdpch pop war dissent l.pts_s, cluster(ccode) robust;
generate MV=((_n-1)/10);
replace MV=. if _n>100;

quietly{;
matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b2=b[1,2];
scalar b3=b[1,3];
scalar b4=b[1,4];
scalar b5=b[1,5];
scalar b6=b[1,6];
scalar b7=b[1,7];
scalar b8=b[1,8];
scalar b9=b[1,9];

scalar varb1=V[1,1];
scalar varb2=V[2,2];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];
scalar covb2b3=V[2,3];
};

scalar list b1 b2 b3 b4 b5 b6 b7 b8 b9 varb1 varb2 varb3 covb1b3 covb2b3;

gen conb=b1+b3*MV if _n<110;

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<110;

gen a=1.96*conse;
*gen a=1.645*conse;
gen upper=conb+a;
gen lower=conb-a;

graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   ,   
             xlabel(0 2 4 6 8 10, labsize(2.5)) 
             ylabel(-.03 -.015 0 .015 .03,   labsize(2.5))
             yscale(noline)
             xscale(noline)
             legend(col(2) order(1 2) label(1 "Marginal Effect of Democracy") 
                                      label(2 "95% Confidence Interval") 
                                      label(3 " "))
             title("", size(4))
             subtitle(" " "" " ", size(3))
             xtitle(ln(Fuel Rents per Capita), size(3)  )
             xsca(titlegap(2))
             ysca(titlegap(2))
             ytitle("Marginal Effect of Democracy", size(3))
             scheme(s2mono) graphregion(fcolor(white));
             
graph export me_hyp2_fuel.pdf, replace;

*Model 2 (UER=oil exporter);

clear matrix;
drop MV conb conse a upper lower;

reg pts_s polity Oil polity_x_oil rgdpch pop war dissent l.pts_s, cluster(ccode) robust;
generate MV=((_n-1)/1);
replace MV=. if _n>2;

quietly{;
matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b2=b[1,2];
scalar b3=b[1,3];
scalar b4=b[1,4];
scalar b5=b[1,5];
scalar b6=b[1,6];
scalar b7=b[1,7];
scalar b8=b[1,8];
scalar b9=b[1,9];

scalar varb1=V[1,1];
scalar varb2=V[2,2];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];
scalar covb2b3=V[2,3];

};

*scalar h_Oil=0;


scalar list b1 b2 b3 b4 b5 b6 b7 b8 b9 varb1 varb2 varb3 covb1b3 covb2b3;


gen conb=b1+b3*MV if _n<3;

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<3;

gen a=1.96*conse;
*gen a=1.645*conse;
gen upper=conb+a;
gen lower=conb-a;

sum conb upper lower if MV==0;
sum conb upper lower if MV==1;

graph twoway scatter conb MV, mcolor(black)	
	||	rcap upper lower MV, lcolor(black) lwidth(medium) 
	||	,
             xlabel(0 1, labsize(2.5)) 
             ylabel(-.03 -.015 0 .015 .03,   labsize(2.5))
             yscale(noline)
             xscale(noline noextend)
             legend(col(2) order(1 2) label(1 "Marginal Effect of Democracy") 
                                      label(2 "95% Confidence Interval") 
                                      label(3 " "))
             title("", size(4))
             subtitle(" " "" " ", size(3))
             xtitle(Oil Exporter, size(3)  )
             xsca(titlegap(2))
             ysca(titlegap(2))
             ytitle("Marginal Effect of Democracy", size(3))
             scheme(s2mono) graphregion(fcolor(white))
             aspectratio(1);
    
graph export me_hyp2_oil.pdf, replace;
log close;
