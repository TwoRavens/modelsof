* falsification test for biv ordered probit models of sexual initiation 
* synthetic friends sample - respondents are matched based on Xbs
* models that exclude some of the x's should find correlated errors but no peer effect ;

clear
capture log close
global datapath "C:/data/BF"
global output "C:/docs/BF/restat/logs"

*************** run models.do first ****************
* bivoprob_v1a
* bivoprob_v1b for gammas=0
/*
cd "../"
do ../models.do
*/

# delimit ; 
set more off; 

******************************sample and dependent var definition;
******************************define depvars;
***drop missing covariates;
drop if pdevo2==.; 
drop if pchurch1==.;
drop if parhs2==.;
drop if nopeduc1==.;
drop if nopeduc2==.;
drop if w1smoketry1==.;
drop if w1smoketry2==.;
drop if w1smokereg1==.;
drop if w1smokereg2==.;
drop if w1pottry1==.;
drop if w1pottry2==.;
drop if w1potreg1==.;
drop if w1potreg2==.;
drop if w1skipany1==.;
drop if w1skipany2==.;
drop if w1skipreg1==.;
drop if w1skipreg2==.;
drop if w1alctry1==.;
drop if w1alctry2==.;
drop if w1alcreg1==.;
drop if w1alcreg2==.;
* w1 sex indicators;
gen w1sex1_2 = inlist(w1sex2,1,2);
gen w1sex2_1 = w1sex1==2;
gen w1sex2_2 = w1sex2==2;
drop if w1sex1_1 == .;
drop if w1sex1_2 == .;
drop if w1sex2_1 == .;
drop if w1sex2_2 == .;
* parent educ; 
replace parcoll1=0 if nopeduc1==1;
replace parcoll2=0 if nopeduc2==1;
drop if parcoll1==.;
drop if parcoll2==.;
*-------------------------------------------------;
*check for pair dependence;
tab dep1 dep2, chi2;

save workingsample, replace;   /********  ORIGINAL ESTIMATION SAMPLE ********/

*-------------------------------------------------;

******************* CONSTRUCT FALSE FRIENDS SAMPLE;
use workingsample, clear;
keep matchid aid1 aid2 scid dep1 age1 male1 black1 orace1 gpa1 hhsmoke1 risk1 future1 time1 
	w1smoketry1 w1smoketry2 w1smokereg1 w1smokereg2 w1alctry1 w1alctry2 
	w1skipdays1 w1skipdays2 ;

gen bfaid1 = aid2;
gen bfaid2 = aid1;
reshape long aid bfaid dep age male black orace gpa hhsmoke risk future time twoparhh pdevo
	pchurch nonech nopch parhs parcoll nopeduc w1smoketry w1smokereg w1alctry w1skipdays
	, i(matchid) j(fnum);
* use x's that predict sex, except for pdevo and risk ;
oprobit dep age black gpa hhsmoke twoparhh /*
	*/ parhs nopeduc w1smoketry w1smokereg w1alctry w1skipdays ;
predict e, xb ;

* histogram e;
sort e;
gen newpairid = int((_n+1)/2);
replace fnum = ((_n/2)==int(_n/2))+1;

drop matchid e ;
reshape wide aid bfaid dep age male black orace gpa hhsmoke risk future time twoparhh pdevo /*
	*/ pchurch nonech nopch parhs parcoll nopeduc w1smoketry w1smokereg w1alctry w1skipdays /*
	*/ scid, i(newpair) j(fnum);

count if scid1==scid2;
count if bfaid1==aid2;
count if bfaid2==aid1;

tab dep1 dep2, chi2;
gen y00=(dep1==0)*(dep2==0);

save falsesample, replace;   /********  FALSE FRIENDS SAMPLE ********/
 
#delimit ;
*-------------------------------------------------;
*set constraints;
program setconstr;
constraint define 1 [eq1]risk1=[eq2]risk2;
constraint define 100 [rho]_con=0;
end;

*******************************************************************************************;
* use only pdevo and risk as controls so that ff's errors are correlated by construction ;
*******************************************************************************************;
foreach ds in workingsample falsesample { ;
use `ds'.dta, clear;

*******************************************************************************************;
*******************************************************************************************;
#delimit ;

ml model lf bivoprob_v1b (dep1= risk1 pdevo1, nocons )
ml init /rho = 0;
ml init eq1:risk1 = .11;
ml maximize;
#delimit ;
di 
"cut1:   " %6.3f [k1]_cons
_n "cut2:   " %6.3f [k1]_cons + exp([dk]_cons) 
_n "rho:    " %6.3f tanh([rho]_cons)
;  

estimates store col1;
predict xb1, eq(eq1);
local  thrho = tanh([rho]_cons);
local  ek1 = [k1]_cons;
local  ek2 = `ek1';
local  ek3 = `ek2'+exp([dk]_cons);
local  ek4 = `ek3';
gen p02 = binormal(`ek1'-xb1,-`ek4'+xb2,-`thrho');
gen p01 = binormal(`ek1'-xb1,-`ek2'+xb2,-`thrho')-p02;
gen p10 = binormal(-`ek2'+xb1,`ek1'-xb2,-`thrho')-p20;
gen p12 = binormal(`ek3'-xb1,-`ek4'+xb2,-`thrho')-p02;
gen p21 = binormal(-`ek4'+xb1,`ek3'-xb2,-`thrho')-p20;
gen p00all = binormal(`ek2'-xb1,`ek2'-xb2,`thrho');
gen p22all = binormal(-`ek3'+xb1,-`ek3'+xb2,`thrho');
gen pme1 = p00all 
		- binormal(`ek2'-xb1,`ek1'-xb2,`thrho')
		- binormal(`ek1'-xb1,`ek2'-xb2,`thrho')
		+ binormal(`ek1'-xb1,`ek1'-xb2,`thrho');
gen pme2 = p22all 
		- binormal(-`ek3'+xb1,-`ek4'+xb2,`thrho')
		- binormal(-`ek4'+xb1,-`ek3'+xb2,`thrho')
		+ binormal(-`ek4'+xb1,-`ek4'+xb2,`thrho');
gen p11all = binormal(`ek4'-xb1,`ek4'-xb2,`thrho')
		- p01 - p10 - p00all + pme1;
gen p00 = p00all - .5*pme1 ;
gen checksum=p00+p11+p22+p01+p10+p12+p21+p20+p02 ;
foreach x of varlist y00 y01 y02 y10 y11 y12 y20 y21 y22 { ;
foreach x of varlist p00 p01 p02 p10 p11 p12 p20 p21 p22 { ;
quietly sum p00 ;
scalar chit1=nobs*((my00-mp00)^2/mp00+(my01-mp01)^2/mp01+(my02-mp02)^2/mp02+ 
*******************************************************************************************;
*******************************************************************************************;

#delimit ;
ml model lf bivoprob_v1b (dep1= risk1 pdevo1, nocons )
ml init /rho = .2;
ml init eq1:risk1 = .11;
ml maximize;

"cut1:   " %6.3f [k1]_cons
_n "cut2:   " %6.3f exp([k1]_cons)+exp([dk]_cons) 
_n "rho:    " %6.3f tanh([rho]_cons)
;  

estimates store col2;

predict xb1, eq(eq1);
local  thrho = tanh([rho]_cons);
local  ek1 = [k1]_cons;
local  ek2 = `ek1';
local  ek3 = `ek2'+exp([dk]_cons);
local  ek4 = `ek3';
gen p02 = binormal(`ek1'-xb1,-`ek4'+xb2,-`thrho');
gen p01 = binormal(`ek1'-xb1,-`ek2'+xb2,-`thrho')-p02;
gen p10 = binormal(-`ek2'+xb1,`ek1'-xb2,-`thrho')-p20;
gen p12 = binormal(`ek3'-xb1,-`ek4'+xb2,-`thrho')-p02;
gen p21 = binormal(-`ek4'+xb1,`ek3'-xb2,-`thrho')-p20;
gen p00all = binormal(`ek2'-xb1,`ek2'-xb2,`thrho');
gen p22all = binormal(-`ek3'+xb1,-`ek3'+xb2,`thrho');
gen pme1 = p00all 
		- binormal(`ek2'-xb1,`ek1'-xb2,`thrho')
		- binormal(`ek1'-xb1,`ek2'-xb2,`thrho')
		+ binormal(`ek1'-xb1,`ek1'-xb2,`thrho');
gen pme2 = p22all 
		- binormal(-`ek3'+xb1,-`ek4'+xb2,`thrho')
		- binormal(-`ek4'+xb1,-`ek3'+xb2,`thrho')
		+ binormal(-`ek4'+xb1,-`ek4'+xb2,`thrho');
gen p11all = binormal(`ek4'-xb1,`ek4'-xb2,`thrho')
		- p01 - p10 - p00all + pme1;
gen p00 = p00all - .5*pme1 ;
gen checksum=p00+p11+p22+p01+p10+p12+p21+p20+p02 ;
sum ysame psame yoff1 poff1 yoff2 poff2 yoff poff;
foreach x of varlist y00 y01 y02 y10 y11 y12 y20 y21 y22 { ;
foreach x of varlist p00 p01 p02 p10 p11 p12 p20 p21 p22 { ;
quietly sum p00 ;
scalar chit2=nobs*((my00-mp00)^2/mp00+(my01-mp01)^2/mp01+(my02-mp02)^2/mp02+ 
*******************************************************************************************;
*******************************************************************************************;

#delimit; 
ml model lf bivoprob_v1a (dep1= risk1 pdevo1, nocons )
ml init /rho = 0;
ml init /g2 = -1.3; 
ml init /k1 = 1; 

ml init eq1:risk1 = .11;
ml maximize;

nlcom g1:exp([g1]_cons);
nlcom rho:tanh([rho]_cons);

di 
"cut1:   " %6.3f [k1]_cons+exp([g1]_cons) 
_n "cut2:   " %6.3f [k1]_cons+exp([g1]_cons)+exp([dk]_cons)+exp([g2]_cons)
_n "gamma1: " %6.3f exp([g1]_cons) 
_n "gamma2: " %6.3f exp([g2]_cons) 
_n "rho:    " %6.3f tanh([rho]_cons)
;
estimates store col3;

# delimit ;
local  thrho = tanh([rho]_cons);
local  ek1 = [k1]_cons;
local  ek2 = `ek1'+exp([g1]_cons);
local  ek3 = `ek2'+exp([dk]_cons);
local  ek4 = `ek3'+exp([g2]_cons);
gen p02 = binormal(`ek1'-xb1,-`ek4'+xb2,-`thrho');
gen p01 = binormal(`ek1'-xb1,-`ek2'+xb2,-`thrho')-p02;
gen p10 = binormal(-`ek2'+xb1,`ek1'-xb2,-`thrho')-p20;
gen p12 = binormal(`ek3'-xb1,-`ek4'+xb2,-`thrho')-p02;
gen p21 = binormal(-`ek4'+xb1,`ek3'-xb2,-`thrho')-p20;
gen p00all = binormal(`ek2'-xb1,`ek2'-xb2,`thrho');
gen p22all = binormal(-`ek3'+xb1,-`ek3'+xb2,`thrho');
gen pme1 = p00all 
		- binormal(`ek2'-xb1,`ek1'-xb2,`thrho')
		- binormal(`ek1'-xb1,`ek2'-xb2,`thrho')
		+ binormal(`ek1'-xb1,`ek1'-xb2,`thrho');
gen pme2 = p22all 
		- binormal(-`ek3'+xb1,-`ek4'+xb2,`thrho')
		- binormal(-`ek4'+xb1,-`ek3'+xb2,`thrho')
		+ binormal(-`ek4'+xb1,-`ek4'+xb2,`thrho');
gen p11all = binormal(`ek4'-xb1,`ek4'-xb2,`thrho')
		- p01 - p10 - p00all + pme1;
gen p00 = p00all - .5*pme1 ;
foreach x of varlist y00 y01 y02 y10 y11 y12 y20 y21 y22 { ;
foreach x of varlist p00 p01 p02 p10 p11 p12 p20 p21 p22 { ;
quietly sum p00 ;
scalar chit3=nobs*((my00-mp00)^2/mp00+(my01-mp01)^2/mp01+(my02-mp02)^2/mp02+ 
*******************************************************************************************;
*******************************************************************************************;

#delimit ;
ml model lf bivoprob_v1a (dep1= risk1 pdevo1, nocons )
ml init /rho = .08;
ml init /g2 = -1.6; 
ml init /k1 = 1; 

ml init eq1:risk1 = .11;
ml maximize;
nlcom g1:exp([g1]_cons);
nlcom rho:tanh([rho]_cons);

di 
"cut1:   " %6.3f [k1]_cons+exp([g1]_cons) 
_n "cut2:   " %6.3f [k1]_cons+exp([g1]_cons)+exp([dk]_cons)+exp([g2]_cons)
_n "gamma1: " %6.3f exp([g1]_cons) 
_n "gamma2: " %6.3f exp([g2]_cons) 
_n "rho:    " %6.3f tanh([rho]_cons)
;
estimates store col4;

predict xb1, eq(eq1);
local  thrho = tanh([rho]_cons);
local  ek1 = [k1]_cons;
local  ek2 = `ek1'+exp([g1]_cons);
local  ek3 = `ek2'+exp([dk]_cons);
local  ek4 = `ek3'+exp([g2]_cons);
gen p02 = binormal(`ek1'-xb1,-`ek4'+xb2,-`thrho');
gen p01 = binormal(`ek1'-xb1,-`ek2'+xb2,-`thrho')-p02;
gen p10 = binormal(-`ek2'+xb1,`ek1'-xb2,-`thrho')-p20;
gen p12 = binormal(`ek3'-xb1,-`ek4'+xb2,-`thrho')-p02;
gen p21 = binormal(-`ek4'+xb1,`ek3'-xb2,-`thrho')-p20;
gen p00all = binormal(`ek2'-xb1,`ek2'-xb2,`thrho');
gen p22all = binormal(-`ek3'+xb1,-`ek3'+xb2,`thrho');
gen pme1 = p00all 
		- binormal(`ek2'-xb1,`ek1'-xb2,`thrho')
		- binormal(`ek1'-xb1,`ek2'-xb2,`thrho')
		+ binormal(`ek1'-xb1,`ek1'-xb2,`thrho');
gen pme2 = p22all 
		- binormal(-`ek3'+xb1,-`ek4'+xb2,`thrho')
		- binormal(-`ek4'+xb1,-`ek3'+xb2,`thrho')
		+ binormal(-`ek4'+xb1,-`ek4'+xb2,`thrho');
gen p11all = binormal(`ek4'-xb1,`ek4'-xb2,`thrho')
		- p01 - p10 - p00all + pme1;
gen p00 = p00all - .5*pme1 ;
foreach x of varlist y00 y01 y02 y10 y11 y12 y20 y21 y22 { ;
foreach x of varlist p00 p01 p02 p10 p11 p12 p20 p21 p22 { ;
quietly sum p00 ;
*******************************************************************************************;
*******************************************************************************************;

* Goodness of Fit;
forval c=1(1)4 {;
di _n "GoF, col`c': " %6.2f chit`c';
};

* Covariates;
label var pdevo1 "Physical Dev Index";
label var risk1 "Attitude to Risk";
esttab col1 col2 col3 col4 , 
	keep(pdevo1 risk1) 
	scalars(N ll) b(%9.2f) se(%9.2f) 
	label varwidth(30) mti((1) (2) (3) (4)) nonum;

* Rho;
foreach c in col2 col4 {;
di _n "rho, `c': ";
estimates for `c', noh: nlcom tanh([rho]_cons);
};

* Gammas;
foreach c in col3 col4  {;
di _n "gamma 1, gamma 2, `c': ";
estimates for `c', noh: nlcom exp([g1]_cons) ;
estimates for `c', noh: nlcom exp([g2]_cons);
};


};

log close;

