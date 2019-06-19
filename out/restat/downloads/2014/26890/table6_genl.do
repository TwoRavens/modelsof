* generalized bivariate ordered probit - four possible state dependence parameters;
* REStat table 6;
* fix rho at 0 ;

clear
cap log close
cap program drop setconstr
global datapath "C:/data/BF"
global output "C:/docs/BF/restat/logs"

*************** run models.do first ****************
* bivoprob_v7
/*
cd "../"
do ../models.do
*/

# delimit ; 
set more off; 

log using $output\table6-genl.log, replace; 

use $datapath\friends.dta;
******************************sample and dependent var definition;
******************************choose sample and delete obs with missing dep var;
drop if nosex1smpl!=1;
drop if sex1==.;
drop if sex2==.;
******************************define depvars;
gen dep1=sex1;
gen dep2=sex2;
***drop missing covariates;
drop if nogpa1==1;
drop if nogpa2==1;
drop if age1==.;
drop if age2==.;
drop if gpa1==.;
drop if gpa2==.;
drop if risk1==.;
drop if risk2==.;
drop if time1==.;
drop if time2==.;
drop if future1==.;
drop if future2==.;
drop if twoparhh1==.;
drop if twoparhh2==.;
drop if hhsmoke1==.;
drop if hhsmoke2==.;
drop if pdevo1==.; 
drop if pdevo2==.; 
drop if pchurch1==.;
drop if pchurch2==.;
drop if nopch1==.;
drop if nopch2==.;
drop if parhs1==.;
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
gen w1sex1_1 = inlist(w1sex1,1,2);
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

gen y00=(dep1==0)*(dep2==0);
gen y01=(dep1==0)*(dep2==1);
gen y02=(dep1==0)*(dep2==2);
gen y10=(dep1==1)*(dep2==0);
gen y11=(dep1==1)*(dep2==1);
gen y12=(dep1==1)*(dep2==2);
gen y20=(dep1==2)*(dep2==0);
gen y21=(dep1==2)*(dep2==1);
gen y22=(dep1==2)*(dep2==2);

save workingsample, replace;

*-------------------------------------------------;
*set constraints;
program setconstr;
constraint define 1 [eq1]_cons=[eq2]_cons;
constraint define 2 [eq1]age1=[eq2]age2;
constraint define 3 [eq1]male1 =[eq2]male2;
constraint define 4 [eq1]black1 =[eq2]black2;
constraint define 5 [eq1]orace1 =[eq2]orace2;
constraint define 6 [eq1]risk1=[eq2]risk2;
constraint define 7 [eq1]future1=[eq2]future2;
constraint define 8 [eq1]time1=[eq2]time2;
constraint define 9 [eq1]twoparhh1=[eq2]twoparhh2;
constraint define 10 [eq1]hhsmoke1=[eq2]hhsmoke2;
constraint define 11 [eq1]pdevo1=[eq2]pdevo2;
constraint define 12 [eq1]pchurch1=[eq2]pchurch2;
constraint define 13 [eq1]nonech1=[eq2]nonech2;
constraint define 14 [eq1]nopch1=[eq2]nopch2;
constraint define 15 [eq1]parhs1=[eq2]parhs2;
constraint define 16 [eq1]parcoll1=[eq2]parcoll2;
constraint define 17 [eq1]nopeduc1=[eq2]nopeduc2;
constraint define 18 [eq1]gpa1 =[eq2]gpa2 ;
constraint define 19 [eq1]w1smoketry1=[eq2]w1smoketry2; 
constraint define 20 [eq1]w1smokereg1=[eq2]w1smokereg2; 
constraint define 21 [eq1]w1pottry1=[eq2]w1pottry2; 
constraint define 22 [eq1]w1potreg1=[eq2]w1potreg2; 
constraint define 23 [eq1]w1skipany1=[eq2]w1skipany2; 
constraint define 24 [eq1]w1skipreg1=[eq2]w1skipreg2; 
constraint define 25 [eq1]w1alctry1=[eq2]w1alctry2; 
constraint define 26 [eq1]w1alcreg1=[eq2]w1alcreg2;
constraint define 100 [rho]_con=0;
* original model;
constraint define 300 [dg1]_cons=[dg2]_cons;
constraint define 301 [g11]_cons=[g21]_cons;end;

*-------------------------------------------------;

*******************************************************************************************;************  1: basline controls ************  ;
*******************************************************************************************;
#delimit; 
use workingsample, clear;
setconstr;
ml model lf bivoprob_v7 (dep1=age1 male1 black1 orace1 hhsmoke1 risk1 future1 time1                twoparhh1 pdevo1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1, nocons )                 (dep2=age2 male2 black2 orace2 hhsmoke2 risk2  future2 time2               twoparhh2 pdevo2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2, nocons )  	/k1 /dk /g11 /dg1 /g21 /dg2 /rho, technique(bfgs 20 nr 5) constraints(2-17 100) robust cluster(scid) ;
	ml init /rho = 0;

ml init /k1 = .9;  
ml init /dk = -2.8;

ml init /g11 = -1.5; 
ml init /dg1 = -20;
ml init /g21 = -2.3; 
ml init /dg2 = -1.6; 

ml init eq1:age1 = .06;ml init eq1:male1 = .01;ml init eq1:black1 = .21;ml init eq1:orace1 = -.17;ml init eq1:hhsmoke1 = .22;ml init eq1:risk1 = .11;ml init eq1:future1 = -.04;ml init eq1:time1 = 0.098;ml init eq1:twoparhh1 = -.18;ml init eq1:pdevo1 = 0.24; ml init eq1:pchurch1 = -0.06; ml init eq1:nonech1 = -0.18; ml init eq1:nopch1 = -0.09;
ml init eq1:parhs1 = -.25;
ml init eq1:parcoll1 = -.08;
ml init eq1:nopeduc1 = -.52;
ml init eq2:age2 = .06;ml init eq2:male2 = .01;ml init eq2:black2 = .21;ml init eq2:orace2 = -.17;ml init eq2:hhsmoke2 = .22;ml init eq2:risk2 = .11;ml init eq2:future2= -.04;ml init eq2:time2 = 0.098;ml init eq2:twoparhh2 = -.18;ml init eq2:pdevo2 = 0.24; ml init eq2:pchurch2 = -0.06; ml init eq2:nonech2 = -0.18; ml init eq2:nopch2 = -0.09;
ml init eq2:parhs2 = -.25;
ml init eq2:parcoll2 = -.08;
ml init eq2:nopeduc2 = -.52;

ml maximize;

estimates store col1;

predict xb1, eq(eq1);predict xb2, eq(eq2);summ xb1 xb2;corr xb1 xb2;
local  thrho = tanh([rho]_cons);

local  ek1 = [k1]_cons;
local  ek2 = `ek1'+exp([dg1]_cons);
local  ek3 = `ek2'+exp([g11]_cons);
local  ek4 = `ek3'+exp([dk]_cons);local  ek5 = `ek4'+exp([dg2]_cons);local  ek6 = `ek5'+exp([g21]_cons);
gen p02 = binormal(`ek1'-xb1,-`ek6'+xb2,-`thrho');gen p20 = binormal(-`ek6'+xb1,`ek1'-xb2,-`thrho');
gen pa =  binormal(`ek1'-xb1,-`ek5'+xb2,-`thrho') - p02; 
gen pf =  binormal(-`ek5'+xb1,`ek1'-xb2,-`thrho') - p20; 
gen pb =  binormal(`ek2'-xb1,`ek5'-xb2,`thrho') - binormal(`ek2'-xb1,`ek3'-xb2,`thrho'); 
gen pe =  binormal(`ek5'-xb1,`ek2'-xb2,`thrho') - binormal(`ek3'-xb1,`ek2'-xb2,`thrho'); 
gen pc =  binormal(`ek2'-xb1,-`ek6'+xb2,-`thrho') - p02;
gen ph =  binormal(-`ek6'+xb1,`ek2'-xb2,-`thrho') - p20;
gen pd = binormal(`ek4'-xb1,-`ek5'+xb2,-`thrho') - binormal(`ek2'-xb1,-`ek5'+xb2,-`thrho');
gen pg = binormal(-`ek5'+xb1,`ek4'-xb2,-`thrho') - binormal(-`ek5'+xb1,`ek2'-xb2,-`thrho');
gen p00all = binormal(`ek3'-xb1,`ek3'-xb2,`thrho');
gen p22all = binormal(-`ek4'+xb1,-`ek4'+xb2,`thrho');
gen pme1 = binormal(`ek3'-xb1,`ek3'-xb2,`thrho')- binormal(`ek3'-xb1,`ek2'-xb2,`thrho')   
- binormal(`ek2'-xb1,`ek3'-xb2,`thrho')+ binormal(`ek2'-xb1,`ek2'-xb2,`thrho'); 
gen pme2 = binormal(-`ek4'+xb1,-`ek4'+xb2,`thrho')  - binormal(-`ek4'+xb1,-`ek5'+xb2,`thrho')   
- binormal(-`ek5'+xb1,-`ek4'+xb2,`thrho')  + binormal(-`ek5'+xb1,-`ek5'+xb2,`thrho');
gen pme3 = binormal(`ek2'-xb1,-`ek5'+xb2,-`thrho')- pa - pc - p02;
gen pme4 = binormal(-`ek5'+xb1,`ek2'-xb2,-`thrho')- pf - ph - p20;
gen p11all = binormal(`ek5'-xb1,`ek5'-xb2,`thrho') - p00all - pb - pe + pme1;	
gen p00 = p00all - .5*pme1 ;gen p11 = p11all - .5*pme1 - .5*pme2 ;gen p22 = p22all - .5*pme2 ;
gen p01 = pa + pb + .5*pme3;
gen p10 = pe + pf + .5*pme4;
gen p12 = pc + pd + .5*pme3;gen p21 = pg + ph + .5*pme4;gen checksum=p00+p11+p22+p01+p10+p12+p21+p20+p02 ;gen pmeall=pme1+pme2+pme3+pme4;
sum checksum pme1 pme2 pme3 pme4 pmeall;
sum p02 - p21;
gen yoff1=y01+y21+y10+y21;gen poff1=p01+p21+p10+p21;gen yoff2=y02+y20;gen poff2=p02+p20;gen yoff=yoff1+yoff2;gen poff=poff1+poff2;gen ysame=y00+y11+y22;gen psame=p00+p11+p22;sum ysame psame yoff1 poff1 yoff2 poff2 yoff poff;sum y00 p00 y01 p01 y02 p02 y10 p10 y11 p11 y12 p12 y20 p20 y21 p21 y22 p22;
foreach x of varlist y00 y01 y02 y10 y11 y12 y20 y21 y22 { ; quietly sum `x' ; scalar m`x'=r(mean)  ; di m`x'  ; } ;
foreach x of varlist p00 p01 p02 p10 p11 p12 p20 p21 p22 { ; quietly sum `x'  ; scalar m`x'=r(mean) ; di m`x'  ; } ;
quietly sum p00 ;scalar nobs=r(N);di nobs ;scalar chit=nobs*((my00-mp00)^2/mp00+(my01-mp01)^2/mp01+(my02-mp02)^2/mp02+            (my10-mp10)^2/mp10+(my11-mp11)^2/mp11+(my12-mp12)^2/mp12+            (my20-mp20)^2/mp20+(my21-mp21)^2/mp21+(my22-mp22)^2/mp22 ) ;

di chit;
#delimit ;
di "rho: " %6.3f tanh([rho]_cons)
_n "g11: " %6.3f exp([g11]_cons)
_n "g12: " %6.3f exp([g11]_cons)+exp([dg1]_cons)
_n "g21: " %6.3f exp([g21]_cons)
_n "g22: " %6.3f exp([dg2]_cons)
;

nlcom exp([g11]_cons);
* nlcom  exp([g11]_cons)+exp([dg1]_cons);
nlcom  exp([g21]_cons);
nlcom  exp([dg2]_cons);



*******************************************************************************************;************  2: expanded controls ************  ;
*******************************************************************************************;#delimit; 
use workingsample, clear;
setconstr;
#delimit; 
ml model lf bivoprob_v7 (dep1=age1 male1 black1 orace1 gpa1 hhsmoke1 risk1 future1 time1  		w1smoketry1 w1smokereg1 w1pottry1 w1potreg1 w1skipany1 w1skipreg1 w1alctry1 w1alcreg1              twoparhh1 pdevo1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1, nocons )                 
			  (dep2=age2 male2 black2 orace2 gpa2 hhsmoke2 risk2  future2 time2  		
			  w1smoketry2 w1smokereg2 w1pottry2 w1potreg2 w1skipany2 w1skipreg2 w1alctry2 w1alcreg2             twoparhh2 pdevo2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2, nocons )  	/k1 /dk /g11 /dg1 /g21 /dg2 /rho, technique(bfgs) constraints(2-26 100) robust cluster(scid) ;
ml init /rho = 0;

ml init /k1 = .84;  
ml init /dk = -2;

ml init /g11 = -1.75; 
ml init /dg1 = -12.7;
 
ml init /g21 = -2.9; 
ml init /dg2 = -1.66; 

ml init eq1:age1 = 0.0645;
ml init eq1:male1 = 0.00116;
ml init eq1:black1 = 0.167109;
ml init eq1:orace1 = -0.157759;
ml init eq1:gpa1 = -0.181999;
ml init eq1:hhsmoke1 = .239806;
ml init eq1:risk1 = 0.10747;
ml init eq1:future1 = -0.05722;
ml init eq1:time1 = 0.099416;
ml init eq1:twoparhh1 = -0.20235;
ml init eq1:pdevo1 = 0.22795;
ml init eq1:pchurch1 = -0.045828;
ml init eq1:nonech1 = -0.143584;
ml init eq1:nopch1 = -0.05805;
ml init eq1:parhs1 = -0.23;
ml init eq1:parcoll1 = -0.1;
ml init eq1:nopeduc1 = -0.45;
ml init eq1:w1smoketry1 = .2085914;
ml init eq1:w1smokereg1 = .3243286;
ml init eq1:w1pottry1 =.1222595;
ml init eq1:w1potreg1 = .101503;
ml init eq1:w1skipany1 = .3670975;
ml init eq1:w1skipreg1 = -.0640282;
ml init eq1:w1alctry1 = .4730827;
ml init eq1:w1alcreg1 = .1685257;
ml init eq2:age2 = 0.0645;
ml init eq2:male2 = 0.00116;
ml init eq2:black2 = 0.167109;
ml init eq2:orace2 = -0.157759;
ml init eq2:gpa2 = -0.181999;
ml init eq2:hhsmoke2 = .239806;
ml init eq2:risk2 = 0.10747;
ml init eq2:future2 = -0.05722;
ml init eq2:time2 = 0.099416;
ml init eq2:twoparhh2 = -0.20235;
ml init eq2:pdevo2 = 0.22795;
ml init eq2:pchurch2 = -0.045828;
ml init eq2:nonech2 = -0.143584;
ml init eq2:nopch2 = -0.05805;
ml init eq2:parhs2 = -0.23;
ml init eq2:parcoll2 = -0.1;
ml init eq2:nopeduc2 = -0.45;
ml init eq2:w1smoketry2 = .2085914;
ml init eq2:w1smokereg2 = .3243286;
ml init eq2:w1pottry2 =.1222595;
ml init eq2:w1potreg2 = .101503;
ml init eq2:w1skipany2 = .3670975;
ml init eq2:w1skipreg2 = -.0640282;
ml init eq2:w1alctry2 = .4730827;
ml init eq2:w1alcreg2 = .1685257;

ml maximize;

estimates store col1;

predict xb1, eq(eq1);predict xb2, eq(eq2);summ xb1 xb2;corr xb1 xb2;
local  thrho = tanh([rho]_cons);
local  ek1 = [k1]_cons;
local  ek2 = `ek1'+exp([dg1]_cons);
local  ek3 = `ek2'+exp([g11]_cons);
local  ek4 = `ek3'+exp([dk]_cons);local  ek5 = `ek4'+exp([dg2]_cons);local  ek6 = `ek5'+exp([g21]_cons);
gen p02 = binormal(`ek1'-xb1,-`ek6'+xb2,-`thrho');gen p20 = binormal(-`ek6'+xb1,`ek1'-xb2,-`thrho');
gen pa =  binormal(`ek1'-xb1,-`ek5'+xb2,-`thrho') - p02; 
gen pf =  binormal(-`ek5'+xb1,`ek1'-xb2,-`thrho') - p20; 
gen pb =  binormal(`ek2'-xb1,`ek5'-xb2,`thrho') - binormal(`ek2'-xb1,`ek3'-xb2,`thrho'); 
gen pe =  binormal(`ek5'-xb1,`ek2'-xb2,`thrho') - binormal(`ek3'-xb1,`ek2'-xb2,`thrho'); 
gen pc =  binormal(`ek2'-xb1,-`ek6'+xb2,-`thrho') - p02;
gen ph =  binormal(-`ek6'+xb1,`ek2'-xb2,-`thrho') - p20;
gen pd = binormal(`ek4'-xb1,-`ek5'+xb2,-`thrho') - binormal(`ek2'-xb1,-`ek5'+xb2,-`thrho');
gen pg = binormal(-`ek5'+xb1,`ek4'-xb2,-`thrho') - binormal(-`ek5'+xb1,`ek2'-xb2,-`thrho');
gen p00all = binormal(`ek3'-xb1,`ek3'-xb2,`thrho');
gen p22all = binormal(-`ek4'+xb1,-`ek4'+xb2,`thrho');
gen pme1 = binormal(`ek3'-xb1,`ek3'-xb2,`thrho')- binormal(`ek3'-xb1,`ek2'-xb2,`thrho')   
- binormal(`ek2'-xb1,`ek3'-xb2,`thrho')+ binormal(`ek2'-xb1,`ek2'-xb2,`thrho'); 
gen pme2 = binormal(-`ek4'+xb1,-`ek4'+xb2,`thrho')  - binormal(-`ek4'+xb1,-`ek5'+xb2,`thrho')   
- binormal(-`ek5'+xb1,-`ek4'+xb2,`thrho')  + binormal(-`ek5'+xb1,-`ek5'+xb2,`thrho');
gen pme3 = binormal(`ek2'-xb1,-`ek5'+xb2,-`thrho')- pa - pc - p02;
gen pme4 = binormal(-`ek5'+xb1,`ek2'-xb2,-`thrho')- pf - ph - p20;
gen p11all = binormal(`ek5'-xb1,`ek5'-xb2,`thrho') - p00all - pb - pe + pme1;	
gen p00 = p00all - .5*pme1 ;gen p11 = p11all - .5*pme1 - .5*pme2 ;gen p22 = p22all - .5*pme2 ;
gen p01 = pa + pb + .5*pme3;
gen p10 = pe + pf + .5*pme4;
gen p12 = pc + pd + .5*pme3;gen p21 = pg + ph + .5*pme4;
gen checksum=p00+p11+p22+p01+p10+p12+p21+p20+p02 ;gen pmeall=pme1+pme2+pme3+pme4;sum checksum pme1 pme2 pme3 pme4 pmeall;

sum p02 - p21;gen yoff1=y01+y21+y10+y21;gen poff1=p01+p21+p10+p21;gen yoff2=y02+y20;gen poff2=p02+p20;gen yoff=yoff1+yoff2;gen poff=poff1+poff2;gen ysame=y00+y11+y22;gen psame=p00+p11+p22;
sum ysame psame yoff1 poff1 yoff2 poff2 yoff poff;sum y00 p00 y01 p01 y02 p02 y10 p10 y11 p11 y12 p12 y20 p20 y21 p21 y22 p22;
foreach x of varlist y00 y01 y02 y10 y11 y12 y20 y21 y22 { ;
 quietly sum `x' ;
 scalar m`x'=r(mean)  ;
 di m`x'  ;
 } ;

foreach x of varlist p00 p01 p02 p10 p11 p12 p20 p21 p22 { ;
 quietly sum `x'  ;
 scalar m`x'=r(mean) ;
 di m`x'  ;
 } ;

 quietly sum p00 ;
scalar nobs=r(N);
di nobs ;
scalar chit=nobs*((my00-mp00)^2/mp00+(my01-mp01)^2/mp01+(my02-mp02)^2/mp02+            (my10-mp10)^2/mp10+(my11-mp11)^2/mp11+(my12-mp12)^2/mp12+            (my20-mp20)^2/mp20+(my21-mp21)^2/mp21+(my22-mp22)^2/mp22 ) ;
di chit;
#delimit ;
di "rho: " %6.3f tanh([rho]_cons)
_n "g11: " %6.3f exp([g11]_cons)
_n "g12: " %6.3f exp([g11]_cons)+exp([dg1]_cons)
_n "g21: " %6.3f exp([g21]_cons)
_n "g22: " %6.3f exp([dg2]_cons)
;

nlcom exp([g11]_cons);
nlcom  exp([g11]_cons)+exp([dg1]_cons);
nlcom  exp([g21]_cons);
nlcom  exp([dg2]_cons);


log close;


view $output\table6-genl.log;

