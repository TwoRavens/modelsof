* allow gammas to depend on reciprocity of friendship

clear
capture log close
global datapath "C:/data/BF"
global output "C:/docs/BF/restat/logs"

log using $output\table11-recip.log, replace

#delimit ;
capture program drop bivoprob_asym;
program define bivoprob_asym;
	args lnf xb1 xb2 k1 k2 g11 g12 g21 g22 rho;
	tempvar thrho p02 p20 p01 p10 p12 p21 p00all p22all p11all pme1 pme2 pup 
				ek1 ek2_1 ek2_2 ek3 ek4_1 ek4_2;
	quietly gen `thrho' = tanh(`rho');
	quietly gen `pup'=.5;
	quietly gen `ek1' = `k1';
	quietly gen `ek3' = `k2';
	quietly gen `ek2_1' = `ek1' + exp(`g11') ;
	quietly gen `ek2_2' = `ek1' + exp(`g12') ;
	quietly gen `ek4_1' = `ek3' + exp(`g21');
	quietly gen `ek4_2' = `ek3' + exp(`g22');
	quietly gen double `p02' = binormal(`ek1'-`xb1',-`ek4_2'+`xb2',-`thrho');
	quietly gen double `p20' = binormal(-`ek4_1'+`xb1',`ek1'-`xb2',-`thrho');
	quietly gen double `p01' = binormal(`ek1'-`xb1',-`ek2_2'+`xb2',-`thrho')-`p02';
	quietly gen double `p10' = binormal(-`ek2_1'+`xb1',`ek1'-`xb2',-`thrho')-`p20';
	quietly gen double `p12' = binormal(`ek3'-`xb1',-`ek4_2'+`xb2',-`thrho')-`p02';
	quietly gen double `p21' = binormal(-`ek4_1'+`xb1',`ek3'-`xb2',-`thrho')-`p20';
	quietly gen double `p00all' = binormal(`ek2_1'-`xb1',`ek2_2'-`xb2',`thrho');
	quietly gen double `p22all' = binormal(-`ek3'+`xb1',-`ek3'+`xb2',`thrho');
	quietly gen double `pme1' = `p00all' 
						- binormal(`ek2_1'-`xb1',`ek1'-`xb2',`thrho')
						- binormal(`ek1'-`xb1',`ek2_2'-`xb2',`thrho')
						+ binormal(`ek1'-`xb1',`ek1'-`xb2',`thrho');
	quietly gen double `pme2' = `p22all' 
						- binormal(-`ek3'+`xb1',-`ek4_2'+`xb2',`thrho')
						- binormal(-`ek4_1'+`xb1',-`ek3'+`xb2',`thrho')
						+ binormal(-`ek4_1'+`xb1',-`ek4_2'+`xb2',`thrho');
	quietly gen double `p11all' = binormal(`ek4_1'-`xb1',`ek4_2'-`xb2',`thrho')
						- `p01' - `p10' - `p00all' + `pme1';
	quietly replace `lnf' = ln(`p02') if ($ML_y1==0 & $ML_y2==2);
 	quietly replace `lnf' = ln(`p20') if ($ML_y1==2 & $ML_y2==0);
	quietly replace `lnf' = ln(`p01') if ($ML_y1==0 & $ML_y2==1); 	
	quietly replace `lnf' = ln(`p10') if ($ML_y1==1 & $ML_y2==0); 
	quietly replace `lnf' = ln(`p12') if ($ML_y1==1 & $ML_y2==2); 	
	quietly replace `lnf' = ln(`p21') if ($ML_y1==2 & $ML_y2==1); 
	quietly replace `lnf' = ln(`p00all'-`pup'*`pme1') if ($ML_y1==0 & $ML_y2==0);
	quietly replace `lnf' = ln(`p22all'-(1-`pup')*`pme2') if ($ML_y1==2 & $ML_y2==2);
	quietly replace `lnf' = ln(`p11all'-(1-`pup')*`pme1'-`pup'*`pme2') if ($ML_y1==1 & $ML_y2==1); 
end;


*-----------------------------------------------------------------------------------;
# delimit ; 
set more off; 

use $datapath\friends.dta, clear;
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
* parent educ; 
replace parcoll1=0 if nopeduc1==1;
replace parcoll2=0 if nopeduc2==1;
drop if parcoll1==.;
drop if parcoll2==.;
*-------------------------------------------------;
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

constraint define 100 [rho]_con=0;


*********************************************************************************************;
* Estimate model with NR pairs fixing rho = 0  (orig Table 9, columns 7 & 8)
*********************************************************************************************;
* Baseline Model;
*********************************************************************************************;
#delimit ;
ml model lf bivoprob_asym 
			(dep1=age1 male1 black1 orace1 pdevo1 risk1 future1 time1 
                hhsmoke1 twoparhh1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1 , nocons )
               (dep2=age2 male2 black2 orace2 pdevo2 risk2 future2 time2 
                hhsmoke2 twoparhh2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2 , nocons )
               /k1 /k2 /g11 /g12 /g21 /g22 /rho			
			if matchlevel>3
			, technique(bfgs) constraints(2-17 100) robust cluster(scid) ; 

ml init /k1 = 1;
ml init /k2 = 1.3;
ml init /g11 = -2;
ml init /g12 = -2;
ml init /g21 = -2;
ml init /g22 = -2;

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

*--------------------------------------------------------------;
* Gammas for each type;
*--------------------------------------------------------------;
#delimit ;
di "Reciprocators:"
_n "gamma 1 = " %6.2f exp([g11]_cons)
_n "gamma 2 = " %6.2f exp([g21]_cons)
_n _n "Non-Reciprocators:"
_n "gamma 1 = " %6.2f exp([g12]_cons)
_n "gamma 2 = " %6.2f exp([g22]_cons)
;

nlcom exp([g11]_cons);
nlcom exp([g21]_cons);
nlcom exp([g12]_cons);
nlcom exp([g22]_cons);

testnl exp([g11]_cons)=exp([g12]_cons);
testnl exp([g21]_cons)=exp([g22]_cons);

*********************************************************************************************;
* Now add gpa + wave 1 behavior covariates;
*********************************************************************************************;
#delimit ;
ml model lf bivoprob_asym 
			(dep1=age1 male1 black1 orace1 gpa1 pdevo1 risk1 future1 time1 
  			w1smoketry1 w1smokereg1 w1pottry1 w1potreg1 w1skipany1 w1skipreg1 w1alctry1 w1alcreg1
                hhsmoke1 twoparhh1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1 , nocons )
               (dep2=age2 male2 black2 orace2 gpa2 pdevo2 risk2 future2 time2 
   			w1smoketry2 w1smokereg2 w1pottry2 w1potreg2 w1skipany2 w1skipreg2 w1alctry2 w1alcreg2
                hhsmoke2 twoparhh2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2 , nocons )
               /k1 /k2 /g11 /g12 /g21 /g22 /rho			
			if matchlevel>3
			, technique(bfgs) constraints(2-18 100) robust cluster(scid) ; 

ml init /k1 = 1.3;
ml init /k2 = 1.6;
ml init /g11 = -2;
ml init /g12 = -3.6;
ml init /g21 = -1.7;
ml init /g22 = -20;

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

*--------------------------------------------------------------;
* Gammas for each type;
*--------------------------------------------------------------;
#delimit ;
di "Reciprocators:"
_n "gamma 1 = " %6.2f exp([g11]_cons)
_n "gamma 2 = " %6.2f exp([g21]_cons)
_n _n "Non-Reciprocators:"
_n "gamma 1 = " %6.2f exp([g12]_cons)
_n "gamma 2 = " %6.2f exp([g22]_cons)
;

nlcom exp([g11]_cons);
nlcom exp([g21]_cons);
nlcom exp([g12]_cons);
nlcom exp([g22]_cons);

testnl exp([g11]_cons)=exp([g12]_cons);
testnl exp([g21]_cons)=exp([g22]_cons);

*********************************************************************************************;
* NOW ESTIMATE MODELS ALLOWING FREE RHO;
* Reciprocated Pairs Only  - baseline, baseline + extra covariates ;
* Non-reciprocated Pairs Only - baseline, baseline + extra covariates ;
* Non-reciprocated Pairs Asymmetric gammas - baseline, baseline + extra covariates ;
*********************************************************************************************;

*********************************************************************************************;
* 1) Reciprocated Pairs Only - Baseline ;
*********************************************************************************************;
#delimit ;
ml model lf bivoprob_v1a (dep1=age1 male1 black1 orace1 hhsmoke1 risk1 future1 time1                twoparhh1 pdevo1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1, nocons )                 (dep2=age2 male2 black2 orace2 hhsmoke2 risk2  future2 time2               twoparhh2 pdevo2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2, nocons )  			/k1 /g1 /dk /g2 /rho 
			if matchlevel<4
			, technique(bfgs 20 nr 5) constraints(2-17) robust cluster(scid) ;
ml init /rho = .08;
ml init /g1 = -2; 
ml init /g2 = -1.6; 
ml init /k1 = 1; ml init /dk = -1;

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

nlcom tanh([rho]_cons);
nlcom exp([g1]_cons);
nlcom exp([g2]_cons);

******* conditional probs for average respondent in a recip pair, taking bf's choice as given *********;
predict xb1 if e(sample), eq(eq1);
predict xb2 if e(sample), eq(eq2);
local  ek1 = [k1]_cons;
local  ek2 = `ek1'+exp([g1]_cons);
local  ek3 = `ek2'+exp([dk]_cons);
local  ek4 = `ek3'+exp([g2]_cons);
sum xb1; scalar mxb1=r(mean);
sum xb2; scalar mxb2=r(mean);
local mxb=(mxb1+mxb2)/2;

* pr(y1=2|y2<2);
di 1-normal(`ek1'-`mxb');
* pr(y1=2|y2=2);
di 1-normal(`ek2'-`mxb');
* pr(y1=1|y2=0);
di 1-normal(`ek3'-`mxb');
* pr(y1=1|y2>=1);
di 1-normal(`ek4'-`mxb');


*********************************************************************************************;
* 2) Reciprocated Pairs Only - Expanded Covariates ;
*********************************************************************************************;
#delimit ;
ml model lf bivoprob_v1a 
			(dep1=age1 male1 black1 orace1 gpa1 pdevo1 risk1 future1 time1 
  			w1smoketry1 w1smokereg1 w1pottry1 w1potreg1 w1skipany1 w1skipreg1 w1alctry1 w1alcreg1
                hhsmoke1 twoparhh1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1 , nocons )
               (dep2=age2 male2 black2 orace2 gpa2 pdevo2 risk2 future2 time2 
   			w1smoketry2 w1smokereg2 w1pottry2 w1potreg2 w1skipany2 w1skipreg2 w1alctry2 w1alcreg2
                hhsmoke2 twoparhh2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2 , nocons )
  			/k1 /g1 /dk /g2 /rho 
			if matchlevel<4
			, technique(bfgs) constraints(2-26) robust cluster(scid) ;
ml init /rho = .08;
ml init /g1 = -2; 
ml init /g2 = -1.6; 
ml init /k1 = 1; ml init /dk = -1;

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

nlcom tanh([rho]_cons);
nlcom exp([g1]_cons);
nlcom exp([g2]_cons);

*********************************************************************************************;
* 3) Non-reciprocated Pairs Only - Baseline;
*********************************************************************************************;
#delimit ;
ml model lf bivoprob_v1a (dep1=age1 male1 black1 orace1 hhsmoke1 risk1 future1 time1                twoparhh1 pdevo1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1, nocons )                 (dep2=age2 male2 black2 orace2 hhsmoke2 risk2  future2 time2               twoparhh2 pdevo2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2, nocons )  			/k1 /g1 /dk /g2 /rho 
			if matchlevel>3
			, technique(bfgs) constraints(2-17) robust cluster(scid) ;
ml init /rho = .08;
ml init /g1 = -2; 
ml init /g2 = -1.6; 
ml init /k1 = 1; ml init /dk = -1;

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

nlcom tanh([rho]_cons);
nlcom exp([g1]_cons);
nlcom exp([g2]_cons);

******* conditional probs for average respondent in an NR pair, taking bf's choice as given *********;
drop xb1 xb2;
predict xb1 if e(sample), eq(eq1);
predict xb2 if e(sample), eq(eq2);
local  ek1 = [k1]_cons;
local  ek2 = `ek1'+exp([g1]_cons);
local  ek3 = `ek2'+exp([dk]_cons);
local  ek4 = `ek3'+exp([g2]_cons);
sum xb1; scalar mxb1=r(mean);
sum xb2; scalar mxb2=r(mean);
local mxb=(mxb1+mxb2)/2;

* pr(y1=2|y2<2);
di 1-normal(`ek1'-`mxb');
* pr(y1=2|y2=2);
di 1-normal(`ek2'-`mxb');
* pr(y1=1|y2=0);
di 1-normal(`ek3'-`mxb');
* pr(y1=1|y2>=1);
di 1-normal(`ek4'-`mxb');

*********************************************************************************************;
* 4) Non-reciprocated Pairs Only - Expanded Covariates;
*********************************************************************************************;
#delimit ;
ml model lf bivoprob_v1a 
			(dep1=age1 male1 black1 orace1 gpa1 pdevo1 risk1 future1 time1 
  			w1smoketry1 w1smokereg1 w1pottry1 w1potreg1 w1skipany1 w1skipreg1 w1alctry1 w1alcreg1
                hhsmoke1 twoparhh1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1 , nocons )
               (dep2=age2 male2 black2 orace2 gpa2 pdevo2 risk2 future2 time2 
   			w1smoketry2 w1smokereg2 w1pottry2 w1potreg2 w1skipany2 w1skipreg2 w1alctry2 w1alcreg2
                hhsmoke2 twoparhh2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2 , nocons )
  			/k1 /g1 /dk /g2 /rho 
			if matchlevel>3
			, technique(bfgs) constraints(2-26) robust cluster(scid) ;

ml init /rho = .08;
ml init /g1 = -2; 
ml init /g2 = -1.6; 
ml init /k1 = 1; ml init /dk = -1;

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

nlcom tanh([rho]_cons);
nlcom exp([g1]_cons);
nlcom exp([g2]_cons);

*********************************************************************************************;
* 5) Non-reciprocated pairs & asymmetric gammas - baseline covariates;
*********************************************************************************************;
#delimit ;
ml model lf bivoprob_asym 
			(dep1=age1 male1 black1 orace1 pdevo1 risk1 future1 time1 
                hhsmoke1 twoparhh1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1 , nocons )
               (dep2=age2 male2 black2 orace2 pdevo2 risk2 future2 time2 
                hhsmoke2 twoparhh2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2 , nocons )
               /k1 /k2 /g11 /g12 /g21 /g22 /rho
			if matchlevel>3
			, technique(bfgs) constraints(2-17) robust cluster(scid) ; 

ml init /k1 = 1;
ml init /k2 = 1.3;
ml init /g11 = -2;
ml init /g12 = -2;
ml init /g21 = -2;
ml init /g22 = -2;

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

*--------------------------------------------------------------;
* Gammas for each type;
*--------------------------------------------------------------;
#delimit ;
di "Nominators:"
_n "gamma 1 = " %6.2f exp([g11]_cons)
_n "gamma 2 = " %6.2f exp([g21]_cons)
_n _n "Non-Reciprocators:"
_n "gamma 1 = " %6.2f exp([g12]_cons)
_n "gamma 2 = " %6.2f exp([g22]_cons)
;

nlcom tanh([rho]_cons);
nlcom exp([g11]_cons);
nlcom exp([g21]_cons);
nlcom exp([g12]_cons);
nlcom exp([g22]_cons);

testnl exp([g11]_cons)=exp([g12]_cons);
testnl exp([g21]_cons)=exp([g22]_cons);

******* conditional probs for nominators in NR pair, taking bf's choice as given *********;
drop xb1 xb2;
predict xb1 if e(sample), eq(eq1);
local  ek1 = [k1]_cons;
local  ek2 = `ek1'+exp([g11]_cons);
local  ek3 = [k2]_cons;
local  ek4 = `ek3'+exp([g21]_cons);
sum xb1; scalar mxb1=r(mean);

* pr(y1=2|y2<2);
di 1-normal(`ek1'-mxb1);
* pr(y1=2|y2=2);
di 1-normal(`ek2'-mxb1);
* pr(y1=1|y2=0);
di 1-normal(`ek3'-mxb1);
* pr(y1=1|y2>=1);
di 1-normal(`ek4'-mxb1);

******* conditional probs for non-reciprocators in NR pair, taking bf's choice as given *********;
predict xb2 if e(sample), eq(eq2);
local  ek1 = [k1]_cons;
local  ek2 = `ek1'+exp([g12]_cons);
local  ek3 = [k2]_cons;
local  ek4 = `ek3'+exp([g22]_cons);
sum xb2; scalar mxb2=r(mean);

* pr(y1=2|y2<2);
di 1-normal(`ek1'-mxb2);
* pr(y1=2|y2=2);
di 1-normal(`ek2'-mxb2);
* pr(y1=1|y2=0);
di 1-normal(`ek3'-mxb2);
* pr(y1=1|y2>=1);
di 1-normal(`ek4'-mxb2);

*********************************************************************************************;
* 6) Non-reciprocated pairs & asymmetric gammas - expanded covariates;
*********************************************************************************************;
#delimit ;
ml model lf bivoprob_asym 
			(dep1=age1 male1 black1 orace1 gpa1 pdevo1 risk1 future1 time1 
  			w1smoketry1 w1smokereg1 w1pottry1 w1potreg1 w1skipany1 w1skipreg1 w1alctry1 w1alcreg1
                hhsmoke1 twoparhh1 pchurch1 nonech1 nopch1 parhs1 parcoll1 nopeduc1 , nocons )
               (dep2=age2 male2 black2 orace2 gpa2 pdevo2 risk2 future2 time2 
   			w1smoketry2 w1smokereg2 w1pottry2 w1potreg2 w1skipany2 w1skipreg2 w1alctry2 w1alcreg2
                hhsmoke2 twoparhh2 pchurch2 nonech2 nopch2 parhs2 parcoll2 nopeduc2 , nocons )
               /k1 /k2 /g11 /g12 /g21 /g22 /rho
			if matchlevel>3
			, technique(bfgs) constraints(2-26) robust cluster(scid) ; 

ml init /k1 = 1.3;
ml init /k2 = 1.6;
ml init /g11 = -2;
ml init /g12 = -3.6;
ml init /g21 = -1.7;
ml init /g22 = -20;

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

*--------------------------------------------------------------;
* Gammas for each type;
*--------------------------------------------------------------;
#delimit ;
di "Nominators:"
_n "gamma 1 = " %6.2f exp([g11]_cons)
_n "gamma 2 = " %6.2f exp([g21]_cons)
_n _n "Non-Reciprocators:"
_n "gamma 1 = " %6.2f exp([g12]_cons)
_n "gamma 2 = " %6.2f exp([g22]_cons)
;

nlcom tanh([rho]_cons);
nlcom exp([g11]_cons);
nlcom exp([g21]_cons);
nlcom exp([g12]_cons);
nlcom exp([g22]_cons);

testnl exp([g11]_cons)=exp([g12]_cons);
testnl exp([g21]_cons)=exp([g22]_cons);

log close;

view $datapath\table11-recip.log;
