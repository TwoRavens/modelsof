* bivariate ordered probit model for sex
* estimate table 3 - column 4 (baseline, free rho & gamma) 
* then calculate probabilities of each outcome at est parameters
* incl prob of being positively or negatively influenced by friend 
clear
capture log close
global datapath "C:/data/BF"
global output "C:/docs/BF/restat/logs"

*************** run models.do first ****************
/*
cd "../"
do ../models.do
*/
# delimit ;set more off;
log using $output\table4-freqs.log, replace;
use $datapath\friends.dta;
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
* parent educ; 
replace parcoll1=0 if nopeduc1==1;
replace parcoll2=0 if nopeduc2==1;
drop if parcoll1==.;
drop if parcoll2==.;

save workingsample, replace;

*-------------------------------------------------;
*set constraints;
constraint define 1 [eq1]_cons=[eq2]_cons;constraint define 2 [eq1]age1=[eq2]age2;constraint define 3 [eq1]male1 =[eq2]male2;constraint define 4 [eq1]black1 =[eq2]black2;constraint define 5 [eq1]orace1 =[eq2]orace2;constraint define 6 [eq1]risk1=[eq2]risk2;constraint define 7 [eq1]future1=[eq2]future2;constraint define 8 [eq1]time1=[eq2]time2;constraint define 9 [eq1]twoparhh1=[eq2]twoparhh2;constraint define 10 [eq1]hhsmoke1=[eq2]hhsmoke2;constraint define 11 [eq1]pdevo1=[eq2]pdevo2;constraint define 12 [eq1]pchurch1=[eq2]pchurch2;constraint define 13 [eq1]nonech1=[eq2]nonech2;constraint define 14 [eq1]nopch1=[eq2]nopch2;constraint define 15 [eq1]parhs1=[eq2]parhs2;
constraint define 16 [eq1]parcoll1=[eq2]parcoll2;
constraint define 17 [eq1]nopeduc1=[eq2]nopeduc2;

************  Table 3, col 4: rho free ,  gamma free , baseline x's    ;

#delimit;
ml model lf bivoprob_v1a (dep1=age1 male1 black1 orace1 hhsmoke1 risk1 future1 time1                twoparhh1 pdevo1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1, nocons )                 (dep2=age2 male2 black2 orace2 hhsmoke2 risk2  future2 time2               twoparhh2 pdevo2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2, nocons )  	/k1 /g1 /dk /g2 /rho , technique(bfgs) constraints(2-17) robust cluster(scid) ;
ml init /rho = .08;ml init /g1 = -2; 
ml init /g2 = -1.6; 
ml init /k1 = 1; ml init /dk = -1;
ml init eq1:age1 = .06;ml init eq1:male1 = .01;ml init eq1:black1 = .21;ml init eq1:orace1 = -.17;ml init eq1:hhsmoke1 = .22;ml init eq1:risk1 = .11;ml init eq1:future1 = -.04;ml init eq1:time1 = 0.098;ml init eq1:twoparhh1 = -.18;ml init eq1:pdevo1 = 0.24; ml init eq1:pchurch1 = -0.06; ml init eq1:nonech1 = -0.18; ml init eq1:nopch1 = -0.09;
ml init eq1:parhs1 = -.25;
ml init eq1:parcoll1 = -.08;
ml init eq1:nopeduc1 = -.52;

ml maximize;
#delimit; 
nlcom g1:exp([g1]_cons);nlcom g2:exp([g2]_cons);
nlcom rho:tanh([rho]_cons);

di 
"cut1:   " %6.3f [k1]_cons+exp([g1]_cons) 
_n "cut2:   " %6.3f [k1]_cons+exp([g1]_cons)+exp([dk]_cons)+exp([g2]_cons)_n "gamma1: " %6.3f exp([g1]_cons) 
_n "gamma2: " %6.3f exp([g2]_cons) 
_n "rho:    " %6.3f tanh([rho]_cons)
;

predict xb1 if e(sample), eq(eq1);
predict xb2 if e(sample), eq(eq2);
local  thrho = tanh([rho]_cons);local  ek1 = [k1]_cons;
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

gen p00 = p00all - .5*pme1 ;gen p11 = p11all - .5*pme1 - .5*pme2 ;gen p22 = p22all - .5*pme2 ;
gen checksum=p00+p11+p22+p01+p10+p12+p21+p20+p02 ;gen pmeall=pme1+pme2;sum checksum pme1 pme2 pmeall;
gen poff1=p01+p21+p10+p21;gen poff2=p02+p20;gen poff=poff1+poff2;gen psame=p00+p11+p22;
***** see table4-freq-notes.pdf for definitions of the following;

gen p_1 = binormal(`ek1'-xb1,`ek1'-xb2,`thrho');

gen p_2 = p00all - pme1 - p_1 ;

gen p_3 = .5*pme1 ;

gen p_8 = .5*pme1 ;

gen p_7 = .5*pme2 ;

gen p_9 = binormal(-`ek4'+xb1,-`ek4'+xb2,`thrho');

gen p_10 = p22all - pme2 - p_9 ;

gen p_11 = .5*pme2 ;

gen p_13a = binormal(`ek1'-xb1,-`ek3'+xb2,-`thrho') - p02 ; 

gen p_13b = binormal(-`ek3'+xb1,`ek1'-xb2,-`thrho') - p20 ;

gen p_13 = p_13a + p_13b ;

gen p_14a = binormal(`ek2'-xb1,-`ek4'+xb2,-`thrho') - p02 ; 

gen p_14b = binormal(-`ek4'+xb1,`ek2'-xb2,-`thrho') - p20 ;

gen p_14 = p_14a + p_14b ;

gen p_5 = binormal(`ek4'-xb1,`ek4'-xb2,`thrho')
		- binormal(`ek3'-xb1,`ek3'-xb2,`thrho')
		- pme2 - p_13 ;

gen p_6 = binormal(-`ek1'+xb1,-`ek1'+xb2,`thrho')
		- binormal(-`ek2'+xb1,-`ek2'+xb2,`thrho')
		- pme1 - p_14 ;

gen p_4 = binormal(`ek3'-xb1,`ek3'-xb2,`thrho')
		- binormal(`ek3'-xb1,`ek2'-xb2,`thrho')
		- binormal(`ek2'-xb1,`ek3'-xb2,`thrho')		
		+ p00all ;

gen p_5U6 = p11all - p_4 - pme1 - pme2 ;

gen p_5n6 = binormal(-`ek3'+xb1,`ek2'-xb2,-`thrho')
		+ binormal(`ek2'-xb1,-`ek3'+xb2,-`thrho')
		- p_13 - p_14 - p02 - p20 ;

gen p_5not6 = p_5 - p_5n6 ;
gen p_6not5 = p_6 - p_5n6 ;		

gen p_12a = p01 - p_13a ;
gen p_12b = p10 - p_13b ;
gen p_12c = p12 - p_14a ;
gen p_12d = p21 - p_14b ;
gen p_12e = p02 ;
gen p_12f = p20 ;
gen p_12 = p_12a + p_12b + p_12c + p_12d + p_12e + p_12f ;

gen checkp_sum = p_1 + p_2 + p_3 + p_4 + p_5U6 + p_7 + p_8 + p_9 + p_10 + p_11 + p_12 + p_13 + p_14 ;

gen checkp00 = p_1 + p_2 + p_3 ;
gen checkp11 = p_4 + p_5U6 + p_7 + p_8 ;
gen checkp22 = p_9 + p_10 + p_11 ;
gen checkpsame = p_1+p_2+p_3+p_4+p_5U6+p_7+p_8+p_9+p_10+p_11 ;
gen checkpoff = p_12+p_13+p_14 ;

tabstat p00 checkp00 p11 checkp11 p22 checkp22 psame checkpsame poff checkpoff, col(stat) f(%9.3f);
tabstat p_1 p_2 p_3 p_4 p_5 p_6 p_5not6 p_6not5 p_5U6 p_5n6 p_7 p_8 p_9 p_10 p_11 
		p_12 p_12a p_12b p_12c p_12d p_12e p_12f p_13 p_13a p_13b p_14 p_14a p_14b 
		checkp_sum, col(stat) f(%9.4f) ;

log close;

view $output\table4-freqs.log;
