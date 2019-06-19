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
log using $output\table7-false.log, replace;use $datapath\friends.dta;
******************************sample and dependent var definition;******************************choose sample and delete obs with missing dep var;drop if nosex1smpl!=1;drop if sex1==.;drop if sex2==.;
******************************define depvars;gen dep1=sex1;gen dep2=sex2;
***drop missing covariates;drop if nogpa1==1;drop if nogpa2==1;drop if age1==.;drop if age2==.;drop if gpa1==.;drop if gpa2==.;drop if risk1==.;drop if risk2==.;drop if time1==.;drop if time2==.;drop if future1==.;drop if future2==.;drop if twoparhh1==.;drop if twoparhh2==.;drop if hhsmoke1==.;drop if hhsmoke2==.;drop if pdevo1==.; 
drop if pdevo2==.; 
drop if pchurch1==.;drop if pchurch2==.;drop if nopch1==.;drop if nopch2==.;drop if parhs1==.;
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
* w1 sex indicators;gen w1sex1_1 = inlist(w1sex1,1,2);
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
*check for pair dependence;gen y00=(dep1==0)*(dep2==0);gen y01=(dep1==0)*(dep2==1);gen y02=(dep1==0)*(dep2==2);gen y10=(dep1==1)*(dep2==0);gen y11=(dep1==1)*(dep2==1);gen y12=(dep1==1)*(dep2==2);gen y20=(dep1==2)*(dep2==0);gen y21=(dep1==2)*(dep2==1);gen y22=(dep1==2)*(dep2==2);
tab dep1 dep2, chi2;

save workingsample, replace;   /********  ORIGINAL ESTIMATION SAMPLE ********/

*-------------------------------------------------;

******************* CONSTRUCT FALSE FRIENDS SAMPLE;
use workingsample, clear;
keep matchid aid1 aid2 scid dep1 age1 male1 black1 orace1 gpa1 hhsmoke1 risk1 future1 time1      twoparhh1 pdevo1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1      dep2 age2 male2 black2 orace2 gpa2 hhsmoke2 risk2  future2 time2       twoparhh2 pdevo2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2 
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
gen y00=(dep1==0)*(dep2==0);gen y01=(dep1==0)*(dep2==1);gen y02=(dep1==0)*(dep2==2);gen y10=(dep1==1)*(dep2==0);gen y11=(dep1==1)*(dep2==1);gen y12=(dep1==1)*(dep2==2);gen y20=(dep1==2)*(dep2==0);gen y21=(dep1==2)*(dep2==1);gen y22=(dep1==2)*(dep2==2);

save falsesample, replace;   /********  FALSE FRIENDS SAMPLE ********/
 
#delimit ;
*-------------------------------------------------;
*set constraints;
program setconstr;
constraint define 1 [eq1]risk1=[eq2]risk2;constraint define 2 [eq1]pdevo1=[eq2]pdevo2;
constraint define 100 [rho]_con=0;
end;

*******************************************************************************************;* run same 4 specifications, first w/ orig. estimation sample, then w/ false friends sample;
* use only pdevo and risk as controls so that ff's errors are correlated by construction ;
*******************************************************************************************;
foreach ds in workingsample falsesample { ;
use `ds'.dta, clear;

*******************************************************************************************;************  1: rho = 0 ,  gamma = 0    ;
*******************************************************************************************;
#delimit ;setconstr;

ml model lf bivoprob_v1b (dep1= risk1 pdevo1, nocons )                 (dep2=risk2 pdevo2 , nocons )  		/k1 /dk /rho , technique(bfgs) constraints(1 2 100) robust  ;
ml init /rho = 0;ml init /k1 = 1; ml init /dk = -1;
ml init eq1:risk1 = .11;ml init eq1:pdevo1 = 0.24; 
ml maximize;
#delimit ;
di 
"cut1:   " %6.3f [k1]_cons
_n "cut2:   " %6.3f [k1]_cons + exp([dk]_cons) 
_n "rho:    " %6.3f tanh([rho]_cons)
;  

estimates store col1;
predict xb1, eq(eq1);predict xb2, eq(eq2);summ xb1 xb2;corr xb1 xb2;
local  thrho = tanh([rho]_cons);
local  ek1 = [k1]_cons;
local  ek2 = `ek1';
local  ek3 = `ek2'+exp([dk]_cons);
local  ek4 = `ek3';
gen p02 = binormal(`ek1'-xb1,-`ek4'+xb2,-`thrho');gen p20 = binormal(-`ek4'+xb1,`ek1'-xb2,-`thrho');
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
gen p00 = p00all - .5*pme1 ;gen p11 = p11all - .5*pme1 - .5*pme2 ;gen p22 = p22all - .5*pme2 ;
gen checksum=p00+p11+p22+p01+p10+p12+p21+p20+p02 ;gen pmeall=pme1+pme2;sum checksum pme1 pme2 pmeall;gen yoff1=y01+y21+y10+y21;gen poff1=p01+p21+p10+p21;gen yoff2=y02+y20;gen poff2=p02+p20;gen yoff=yoff1+yoff2;gen poff=poff1+poff2;gen ysame=y00+y11+y22;gen psame=p00+p11+p22;sum ysame psame yoff1 poff1 yoff2 poff2 yoff poff;sum y00 p00 y01 p01 y02 p02 y10 p10 y11 p11 y12 p12 y20 p20 y21 p21 y22 p22;
foreach x of varlist y00 y01 y02 y10 y11 y12 y20 y21 y22 { ; quietly sum `x' ; scalar m`x'=r(mean)  ; di m`x'  ; } ;
foreach x of varlist p00 p01 p02 p10 p11 p12 p20 p21 p22 { ; quietly sum `x'  ; scalar m`x'=r(mean) ; di m`x'  ; } ;
quietly sum p00 ;scalar nobs=r(N);di nobs ;
scalar chit1=nobs*((my00-mp00)^2/mp00+(my01-mp01)^2/mp01+(my02-mp02)^2/mp02+            (my10-mp10)^2/mp10+(my11-mp11)^2/mp11+(my12-mp12)^2/mp12+            (my20-mp20)^2/mp20+(my21-mp21)^2/mp21+(my22-mp22)^2/mp22 ) ;di chit1;
*******************************************************************************************;************  2: rho free ,  gamma = 0   ************  ;
*******************************************************************************************;drop xb1 - psame;

#delimit ;
ml model lf bivoprob_v1b (dep1= risk1 pdevo1, nocons )                 (dep2=risk2 pdevo2 , nocons )  		/k1 /dk /rho , technique(bfgs) constraints(1 2) robust ;
ml init /rho = .2;ml init /k1 = 1; ml init /dk = -1;
ml init eq1:risk1 = .11;ml init eq1:pdevo1 = 0.24; 
ml maximize;
di 
"cut1:   " %6.3f [k1]_cons
_n "cut2:   " %6.3f exp([k1]_cons)+exp([dk]_cons) 
_n "rho:    " %6.3f tanh([rho]_cons)
;  

estimates store col2;

predict xb1, eq(eq1);predict xb2, eq(eq2);summ xb1 xb2;corr xb1 xb2;
local  thrho = tanh([rho]_cons);
local  ek1 = [k1]_cons;
local  ek2 = `ek1';
local  ek3 = `ek2'+exp([dk]_cons);
local  ek4 = `ek3';
gen p02 = binormal(`ek1'-xb1,-`ek4'+xb2,-`thrho');gen p20 = binormal(-`ek4'+xb1,`ek1'-xb2,-`thrho');
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
gen p00 = p00all - .5*pme1 ;gen p11 = p11all - .5*pme1 - .5*pme2 ;gen p22 = p22all - .5*pme2 ;
gen checksum=p00+p11+p22+p01+p10+p12+p21+p20+p02 ;gen pmeall=pme1+pme2;sum checksum pme1 pme2 pmeall;gen yoff1=y01+y21+y10+y21;gen poff1=p01+p21+p10+p21;gen yoff2=y02+y20;gen poff2=p02+p20;gen yoff=yoff1+yoff2;gen poff=poff1+poff2;gen ysame=y00+y11+y22;gen psame=p00+p11+p22;
sum ysame psame yoff1 poff1 yoff2 poff2 yoff poff;sum y00 p00 y01 p01 y02 p02 y10 p10 y11 p11 y12 p12 y20 p20 y21 p21 y22 p22;
foreach x of varlist y00 y01 y02 y10 y11 y12 y20 y21 y22 { ; quietly sum `x' ; scalar m`x'=r(mean)  ; di m`x'  ; } ;
foreach x of varlist p00 p01 p02 p10 p11 p12 p20 p21 p22 { ; quietly sum `x'  ; scalar m`x'=r(mean) ; di m`x'  ; } ;
quietly sum p00 ;scalar nobs=r(N);di nobs ;
scalar chit2=nobs*((my00-mp00)^2/mp00+(my01-mp01)^2/mp01+(my02-mp02)^2/mp02+            (my10-mp10)^2/mp10+(my11-mp11)^2/mp11+(my12-mp12)^2/mp12+            (my20-mp20)^2/mp20+(my21-mp21)^2/mp21+(my22-mp22)^2/mp22 ) ;di chit2;
*******************************************************************************************;************  3: rho = 0 ,  gamma free ************  ;
*******************************************************************************************;drop xb1 - psame;

#delimit; 
ml model lf bivoprob_v1a (dep1= risk1 pdevo1, nocons )                 (dep2=risk2 pdevo2 , nocons )  	/k1 /g1 /dk /g2 /rho , technique(bfgs) constraints(1 2 100) robust ;
ml init /rho = 0;ml init /g1 = -1.6; 
ml init /g2 = -1.3; 
ml init /k1 = 1; ml init /dk = -2.5;

ml init eq1:risk1 = .11;ml init eq1:pdevo1 = 0.24; 
ml maximize;

nlcom g1:exp([g1]_cons);nlcom g2:exp([g2]_cons);
nlcom rho:tanh([rho]_cons);

di 
"cut1:   " %6.3f [k1]_cons+exp([g1]_cons) 
_n "cut2:   " %6.3f [k1]_cons+exp([g1]_cons)+exp([dk]_cons)+exp([g2]_cons)
_n "gamma1: " %6.3f exp([g1]_cons) 
_n "gamma2: " %6.3f exp([g2]_cons) 
_n "rho:    " %6.3f tanh([rho]_cons)
;
estimates store col3;

# delimit ;predict xb1, eq(eq1);predict xb2, eq(eq2);summ xb1 xb2;corr xb1 xb2;
local  thrho = tanh([rho]_cons);
local  ek1 = [k1]_cons;
local  ek2 = `ek1'+exp([g1]_cons);
local  ek3 = `ek2'+exp([dk]_cons);
local  ek4 = `ek3'+exp([g2]_cons);
gen p02 = binormal(`ek1'-xb1,-`ek4'+xb2,-`thrho');gen p20 = binormal(-`ek4'+xb1,`ek1'-xb2,-`thrho');
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
gen p00 = p00all - .5*pme1 ;gen p11 = p11all - .5*pme1 - .5*pme2 ;gen p22 = p22all - .5*pme2 ;gen checksum=p00+p11+p22+p01+p10+p12+p21+p20+p02 ;gen pmeall=pme1+pme2;sum checksum pme1 pme2 pmeall;gen yoff1=y01+y21+y10+y21;gen poff1=p01+p21+p10+p21;gen yoff2=y02+y20;gen poff2=p02+p20;gen yoff=yoff1+yoff2;gen poff=poff1+poff2;gen ysame=y00+y11+y22;gen psame=p00+p11+p22;sum ysame psame yoff1 poff1 yoff2 poff2 yoff poff;sum y00 p00 y01 p01 y02 p02 y10 p10 y11 p11 y12 p12 y20 p20 y21 p21 y22 p22;
foreach x of varlist y00 y01 y02 y10 y11 y12 y20 y21 y22 { ; quietly sum `x' ; scalar m`x'=r(mean)  ; di m`x'  ; } ;
foreach x of varlist p00 p01 p02 p10 p11 p12 p20 p21 p22 { ; quietly sum `x'  ; scalar m`x'=r(mean) ; di m`x'  ; } ;
quietly sum p00 ;scalar nobs=r(N);di nobs ;
scalar chit3=nobs*((my00-mp00)^2/mp00+(my01-mp01)^2/mp01+(my02-mp02)^2/mp02+            (my10-mp10)^2/mp10+(my11-mp11)^2/mp11+(my12-mp12)^2/mp12+            (my20-mp20)^2/mp20+(my21-mp21)^2/mp21+(my22-mp22)^2/mp22 ) ;di chit3;
*******************************************************************************************;************  4: rho free ,  gamma free   ************  ;
*******************************************************************************************;drop xb1 - psame;

#delimit ;
ml model lf bivoprob_v1a (dep1= risk1 pdevo1, nocons )                 (dep2=risk2 pdevo2 , nocons )  	/k1 /g1 /dk /g2 /rho , technique(bfgs) constraints(1 2) robust ;
ml init /rho = .08;ml init /g1 = -2; 
ml init /g2 = -1.6; 
ml init /k1 = 1; ml init /dk = -1;

ml init eq1:risk1 = .11;ml init eq1:pdevo1 = 0.24; 
ml maximize;
nlcom g1:exp([g1]_cons);nlcom g2:exp([g2]_cons);
nlcom rho:tanh([rho]_cons);

di 
"cut1:   " %6.3f [k1]_cons+exp([g1]_cons) 
_n "cut2:   " %6.3f [k1]_cons+exp([g1]_cons)+exp([dk]_cons)+exp([g2]_cons)
_n "gamma1: " %6.3f exp([g1]_cons) 
_n "gamma2: " %6.3f exp([g2]_cons) 
_n "rho:    " %6.3f tanh([rho]_cons)
;
estimates store col4;

predict xb1, eq(eq1);predict xb2, eq(eq2);summ xb1 xb2;corr xb1 xb2;
local  thrho = tanh([rho]_cons);
local  ek1 = [k1]_cons;
local  ek2 = `ek1'+exp([g1]_cons);
local  ek3 = `ek2'+exp([dk]_cons);
local  ek4 = `ek3'+exp([g2]_cons);
gen p02 = binormal(`ek1'-xb1,-`ek4'+xb2,-`thrho');gen p20 = binormal(-`ek4'+xb1,`ek1'-xb2,-`thrho');
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
gen p00 = p00all - .5*pme1 ;gen p11 = p11all - .5*pme1 - .5*pme2 ;gen p22 = p22all - .5*pme2 ;gen checksum=p00+p11+p22+p01+p10+p12+p21+p20+p02 ;gen pmeall=pme1+pme2;sum checksum pme1 pme2 pmeall;gen yoff1=y01+y21+y10+y21;gen poff1=p01+p21+p10+p21;gen yoff2=y02+y20;gen poff2=p02+p20;gen yoff=yoff1+yoff2;gen poff=poff1+poff2;gen ysame=y00+y11+y22;gen psame=p00+p11+p22;sum ysame psame yoff1 poff1 yoff2 poff2 yoff poff;sum y00 p00 y01 p01 y02 p02 y10 p10 y11 p11 y12 p12 y20 p20 y21 p21 y22 p22;
foreach x of varlist y00 y01 y02 y10 y11 y12 y20 y21 y22 { ; quietly sum `x' ; scalar m`x'=r(mean)  ; di m`x'  ; } ;
foreach x of varlist p00 p01 p02 p10 p11 p12 p20 p21 p22 { ; quietly sum `x'  ; scalar m`x'=r(mean) ; di m`x'  ; } ;
quietly sum p00 ;scalar nobs=r(N);scalar chit4=nobs*((my00-mp00)^2/mp00+(my01-mp01)^2/mp01+(my02-mp02)^2/mp02+            (my10-mp10)^2/mp10+(my11-mp11)^2/mp11+(my12-mp12)^2/mp12+            (my20-mp20)^2/mp20+(my21-mp21)^2/mp21+(my22-mp22)^2/mp22 ) ;di chit4;
*******************************************************************************************;************  DISPLAY ESTIMATES  ************  ;
*******************************************************************************************;# delimit;

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
view $output\table7-false.log;

