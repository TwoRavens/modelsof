* allow gammas to depend on individual characteristics

clear
capture log close
global datapath "C:/data/BF"
global output "C:/docs/BF/restat/logs"

*********** run models.do first* bivoprob_v6 allows for heterogeneous gammas/*
cd "../"
do ../models.do
*/

# delimit ; 
set more off; 

log using $output\table10-het.log, replace; 

use $datapath\friends.dta;
******************************sample and dependent var definition;******************************choose sample and delete obs with missing dep var;drop if nosex1smpl!=1;drop if sex1==.;drop if sex2==.;******************************define depvars;gen dep1=sex1;gen dep2=sex2;***drop missing covariates;drop if nogpa1==1;drop if nogpa2==1;drop if age1==.;drop if age2==.;drop if gpa1==.;drop if gpa2==.;drop if risk1==.;drop if risk2==.;drop if time1==.;drop if time2==.;drop if future1==.;drop if future2==.;drop if twoparhh1==.;drop if twoparhh2==.;drop if hhsmoke1==.;drop if hhsmoke2==.;drop if pdevo1==.; 
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

gen dep3 = dep1*dep2;
gen dep4 = dep1-dep2;

save workingsample, replace;
*******************************************************************************;
* HETEREGENEOUS ACROSS PAIR CHARACTERISTICS BUT SYMMETRIC BETWEEN FRIENDS;
*******************************************************************************;
# delimit;
gen xvar=.;

*define pair means; 
foreach x in age male black orace gpa pdevo risk future time 
     hhsmoke twoparhh pchurch nonech parhs parcoll { ;
	gen `x'a=(`x'1+`x'2)/2 ;
}   ;

*define pair differences; 
foreach x in age male black orace gpa pdevo risk future time 
     hhsmoke twoparhh pchurch nonech parhs parcoll { ;
	gen `x'd=abs(`x'1-`x'2) ;
}    ;

* predicted prob of remaining BFs in W2; 
tab matchlevel, gen(ml);
gen w2bfs = w2matchlevel==2;

probit w2bfs ml2 ml3 ml4 ml5 
	agea malea blacka oracea gpaa pdevoa riska futurea timea 
	hhsmokea twoparhha pchurcha nonecha parhsa parcolla 
	aged maled blackd oraced gpad pdevod riskd futured timed 
	hhsmoked twoparhhd pchurchd nonechd parhsd parcolld ;
predict prw2bf, pr;
rename agea avgage;
rename malea male;

*******************************************************************************;
*set constraints; 
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

constraint define 100 [eq1]xvar=[eq2]xvar; 

*******************************************************************************;
* BASELINE SPECIFICATIONS;
*******************************************************************************;
# delimit;

foreach var in avgage prw2bf { ;
di "-----------------------------------------------------------------";
di "Let xvar = `var'" ;
di "-------------------";
	
replace xvar = `var';
*set constraints;constraint define 1 [eq1]_cons=[eq2]_cons;
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

constraint define 100 [eq1]xvar=[eq2]xvar;

#delimit ;
ml model lf bivoprob_v6 
			(dep1=age1 male1 black1 orace1 pdevo1 risk1 future1 time1 xvar
                hhsmoke1 twoparhh1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1 , nocons )
               (dep2=age2 male2 black2 orace2 pdevo2 risk2 future2 time2 xvar
                hhsmoke2 twoparhh2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2 , nocons )
                 (dep3=xvar) (dep4=xvar) 
               /k1 /k2 , technique(bfgs) constraints(2-17 100) robust 
cluster(scid) ; 

#delimit ;
ml init eq1:xvar=0;
ml init eq2:xvar=0;
ml init eq3:xvar=0;
ml init eq4:xvar=0;

ml init eq3:_cons= -1.6;
ml init eq4:_cons= -1.3;

ml init /k1 = 1;
ml init /k2 = 1.5;

ml init eq1:age1 = 0.0645;
ml init eq1:male1 = 0.00116;
ml init eq1:black1 = 0.167109;
ml init eq1:orace1 = -0.157759;
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

ml init eq2:age2 = 0.0645;
ml init eq2:male2 = 0.00116;
ml init eq2:black2 = 0.167109;
ml init eq2:orace2 = -0.157759;
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

ml maximize;

estimates store X1_`var';

};

*--------------------------------------------------------------------------;
* GENDER;
*--------------------------------------------------------------------------;
#delimit ;

replace xvar = male;

ml model lf bivoprob_v6 
			(dep1=age1 male1 black1 orace1 pdevo1 risk1 future1 time1 
                hhsmoke1 twoparhh1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1 , nocons )
               (dep2=age2 male2 black2 orace2 pdevo2 risk2 future2 time2 
                hhsmoke2 twoparhh2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2 , nocons )
                 (dep3=xvar) (dep4=xvar) 
               /k1 /k2 , technique(bfgs) constraints(2-17) robust 
cluster(scid) ; 

ml init eq3:xvar=0;
ml init eq4:xvar=0;

ml init eq3:_cons= -1.6;
ml init eq4:_cons= -1.3;

ml init /k1 = 1;
ml init /k2 = 1.5;

ml init eq1:age1 = 0.0645;
ml init eq1:male1 = 0.00116;
ml init eq1:black1 = 0.167109;
ml init eq1:orace1 = -0.157759;
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

ml init eq2:age2 = 0.0645;
ml init eq2:male2 = 0.00116;
ml init eq2:black2 = 0.167109;
ml init eq2:orace2 = -0.157759;
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

ml maximize;

estimates store X1_male;

#delimit ;

*******************************************************************************;
* EXPANDED SET OF COVARIATES;
*******************************************************************************;
# delimit;

foreach var in avgage prw2bf { ;
di "-----------------------------------------------------------------";
di "Let xvar = `var'" ;
di "-------------------";
	
replace xvar = `var';

#delimit ;
ml model lf bivoprob_v6 
			(dep1=age1 male1 black1 orace1 gpa1 pdevo1 risk1 future1 time1 xvar
 			w1smoketry1 w1smokereg1 w1pottry1 w1potreg1 w1skipany1 w1skipreg1 w1alctry1 w1alcreg1
               hhsmoke1 twoparhh1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1 , nocons )
               (dep2=age2 male2 black2 orace2 gpa2 pdevo2 risk2 future2 time2 xvar
 			w1smoketry2 w1smokereg2 w1pottry2 w1potreg2 w1skipany2 w1skipreg2 w1alctry2 w1alcreg2
               hhsmoke2 twoparhh2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2 , nocons )
                 (dep3=xvar) (dep4=xvar) 
               /k1 /k2 , technique(bfgs) constraints(2-26 100) robust 
cluster(scid) ; 

#delimit ;
ml init eq1:xvar=0;
ml init eq2:xvar=0;
ml init eq3:xvar=0;
ml init eq4:xvar=0;

ml init eq3:_cons= -1.6;
ml init eq4:_cons= -1.3;

ml init /k1 = 1;
ml init /k2 = 1.5;

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

estimates store X2_`var';

};

*--------------------------------------------------------------------------;
* GENDER;
*--------------------------------------------------------------------------;
#delimit ;

replace xvar = male;

ml model lf bivoprob_v6 
			(dep1=age1 male1 black1 orace1 gpa1 pdevo1 risk1 future1 time1 
  			w1smoketry1 w1smokereg1 w1pottry1 w1potreg1 w1skipany1 w1skipreg1 w1alctry1 w1alcreg1
               hhsmoke1 twoparhh1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1 , nocons )
               (dep2=age2 male2 black2 orace2 gpa2 pdevo2 risk2 future2 time2 
  			w1smoketry2 w1smokereg2 w1pottry2 w1potreg2 w1skipany2 w1skipreg2 w1alctry2 w1alcreg2
               hhsmoke2 twoparhh2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2 , nocons )
                 (dep3=xvar) (dep4=xvar) 
               /k1 /k2 , technique(bfgs) constraints(2-27) robust 
cluster(scid) ; 

ml init eq3:xvar=0;
ml init eq4:xvar=0;

ml init eq3:_cons= -1.6;
ml init eq4:_cons= -1.3;

ml init /k1 = 1;
ml init /k2 = 1.5;

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

estimates store X2_male;


*******************************************************************************;

#delimit ;
*--------------------------------------------------------------------------;
esttab X1_male X2_male X1_avgage X2_avgage X1_prw2bf X2_prw2bf, 
mti(male male avgage avgage prw2bf prw2bf) se scalars(ll) sfmt(%9.2f);
*---------------------------------------;
#delimit ;
est for X1_male, noh: scalar A = [eq3]_cons;
est for X1_male, noh: scalar B = [eq3]_b[xvar];
est for X1_male, noh: scalar C = [eq4]_cons;
est for X1_male, noh: scalar D = [eq4]_b[xvar];

di "Females:"
_n "g1 = " %6.3f exp(A)
_n "g2 = " %6.3f exp(C)
_n _n "Males:"
_n "g1 = " %6.3f exp(A+B)
_n "g2 = " %6.3f exp(C+D);
*---------------------------------------;
#delimit ;
est for X2_male, noh: scalar A = [eq3]_cons;
est for X2_male, noh: scalar B = [eq3]_b[xvar];
est for X2_male, noh: scalar C = [eq4]_cons;
est for X2_male, noh: scalar D = [eq4]_b[xvar];

di "Females:"
_n "g1 = " %6.3f exp(A)
_n "g2 = " %6.3f exp(C)
_n _n "Males:"
_n "g1 = " %6.3f exp(A+B)
_n "g2 = " %6.3f exp(C+D);
*---------------------------------------;
#delimit ;
est for X1_avgage, noh: scalar A = [eq3]_cons;
est for X1_avgage, noh: scalar B = [eq3]_b[xvar];
est for X1_avgage, noh: scalar C = [eq4]_cons;
est for X1_avgage, noh: scalar D = [eq4]_b[xvar];

di "Younger (Age 14):"
_n "g1 = " %6.3f exp(A+B*14)
_n "g2 = " %6.3f exp(C+D*14)
_n _n "Older (Age 17):"
_n "g1 = " %6.3f exp(A+B*17)
_n "g2 = " %6.3f exp(C+D*17);
*---------------------------------------;
#delimit ;
est for X2_avgage, noh: scalar A = [eq3]_cons;
est for X2_avgage, noh: scalar B = [eq3]_b[xvar];
est for X2_avgage, noh: scalar C = [eq4]_cons;
est for X2_avgage, noh: scalar D = [eq4]_b[xvar];

di "Younger (Age 14):"
_n "g1 = " %6.3f exp(A+B*14)
_n "g2 = " %6.3f exp(C+D*14)
_n _n "Older (Age 17):"
_n "g1 = " %6.3f exp(A+B*17)
_n "g2 = " %6.3f exp(C+D*17);
*---------------------------------------;
#delimit ;
est for X1_prw2bf, noh: scalar A = [eq3]_cons;
est for X1_prw2bf, noh: scalar B = [eq3]_b[xvar];
est for X1_prw2bf, noh: scalar C = [eq4]_cons;
est for X1_prw2bf, noh: scalar D = [eq4]_b[xvar];

di "Low Prob. (p=.10):"
_n "g1 = " %6.3f exp(A+B*.10)
_n "g2 = " %6.3f exp(C+D*.10)
_n _n "High Prob. (p=.35):"
_n "g1 = " %6.3f exp(A+B*.35)
_n "g2 = " %6.3f exp(C+D*.35);
*---------------------------------------;
#delimit ;
est for X2_prw2bf, noh: scalar A = [eq3]_cons;
est for X2_prw2bf, noh: scalar B = [eq3]_b[xvar];
est for X2_prw2bf, noh: scalar C = [eq4]_cons;
est for X2_prw2bf, noh: scalar D = [eq4]_b[xvar];

di "Low Prob. (p=.10):"
_n "g1 = " %6.3f exp(A+B*.10)
_n "g2 = " %6.3f exp(C+D*.10)
_n _n "High Prob. (p=.35):"
_n "g1 = " %6.3f exp(A+B*.35)
_n "g2 = " %6.3f exp(C+D*.35);


 log close; 
 
 view $output\table10-het.log;
