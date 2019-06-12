clear all

use "/Users/joshuazingher/Desktop/State Immigration Legislation/US Immigration laws - 10-16.dta"
set more off
drop if year==2012
/// table 2

tab total repcontrol

/// Base Models -- Table 3
probit total repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo, cluster(id) robust 
outreg2 using stateimm,  auto(2) replace
probit total repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2006-d2011, cluster(id) robust 
outreg2 using stateimm , drop(d2006-d2012) auto(2) append 
xtprobit total repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2006-d2011
outreg2 using stateimm , drop(d2006-d2012) auto(2) append 

///  Models for each of the 3 DV Categories -- Table 4
probit employment  repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2006-d2011, robust cluster(id)
outreg2 using categories , drop(d2006-d2012) auto(2) replace 
probit mandatory repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2006-d2010, robust cluster(id)
outreg2 using categories , drop(d2006-d2012) auto(2) append 
probit omni  Repmean Demmean LATINOCVAP termlimits professionalization RepGov  thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo if repcontrol==1, robust cluster(id) 
outreg2 using categories , drop(d2006-d2012) auto(2) append 


/// Models for Table 5 - Repbulican and Democratic Split Samples
/// Model 7 -- Republicans Only
probit total Repmean  Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2006-d2011 if repcontrol==1,  cluster(id) robust
outreg2 using splitsample, drop(d2006-d2012) auto(2) replace
/// Model 8 -- Non-Republicans only
probit total Repmean  Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2006-d2011 if repcontrol<1,  cluster(id) robust
outreg2 using splitsample,  drop(d2006-d2012) auto(2) append

/// Democratic Controlled Positive Bills
 probit total_pos demcontrol Repmean IDEOdemContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo, cluster(id) robust
outreg2 using positive, replace



clear

use "/Users/joshuazingher/Desktop/State Immigration Legislation/US Immigration laws - 10-16.dta"

/// Figure 2 predicted Probabilities 
probit total Repmean Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2006-d2011 if repcontrol==1, robust cluster(id)
prgen PCTsince2000, gen(pct2000prdREP) from(30) to(40) gap(.25) x(Repmean 1  Demmean -.64 LATINOCVAP 2 termlimits 0 RepGov 1 borderstate 0  PCTsince2000 0) ci
probit total Repmean Demmean LATINOCVAP termlimits professionalization RepGov thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2006-d2011 if repcontrol<1, robust cluster(id)
prgen PCTsince2000, gen(pct2000prdDEM) from(30) to(40) gap(.25) x(Repmean 1  Demmean -.64 LATINOCVAP 2 termlimits 0 RepGov 1 thesouth 0 PCTsince2000 0) ci
twoway connected pct2000prdREPp1 pct2000prdREPx, xlabel(30(2)40) xtitle(Percent Increase of Foreign Born Population Since 2000) ytitle(Predicted Probability of Passing Immigration Law) msymbol(none) title(The Effect of Change in the Foreign Born Population Since 2000) || connected pct2000prdDEMp1 pct2000prdDEMx, msymbol(none) lpattern(ldash) legend(cols(2)) graphregion(lcolor(black)) ///
|| connected pct2000prdDEMp1ub pct2000prdDEMx, lpattern(dash) msymbol(none) || connected pct2000prdDEMp1lb pct2000prdDEMx, lpattern(dash) msymbol(none) || connected pct2000prdREPp1ub pct2000prdDEMx, lpattern(dash) msymbol(none) || connected pct2000prdREPp1lb pct2000prdDEMx, lpattern(dash) msymbol(none)


clear 
set more off
use "/Users/joshuazingher/Desktop/State Immigration Legislation/US Immigration laws - 10-16.dta"

probit total Repmean Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2006-d2011 if repcontrol==1, robust cluster(id)
prgen LATINOCVAP, gen(LatprdREP) from(0) to(10) gap(.25) x(Repmean 1  Demmean -.64  termlimits 0 RepGov 1 borderstate 0  PCTsince2000 38.5 LATINO 0) ci
probit total Repmean Demmean LATINOCVAP termlimits professionalization RepGov thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2006-d2011 if repcontrol<1, robust cluster(id)
prgen LATINOCVAP, gen(LatprdDEM) from(0) to(10) gap(.25) x(Repmean 1  Demmean -.64 termlimits 0 RepGov 1 thesouth 0 PCTsince2000 38.5 LATINO 0) ci
twoway connected LatprdREPp1 LatprdREPx, xlabel(0(2)10) xtitle(Latino CVAP%) ytitle(Predicted Probability of Passing Immigration Law) msymbol(none) title(The Effect of Change in Latino CVAP) lcolor(red) || connected LatprdDEMp1 LatprdDEMx, msymbol(none) lcolor(blue) legend(cols(2)) graphregion(lcolor(black)) ///
|| connected LatprdDEMp1ub LatprdDEMx, lpattern(dash) msymbol(none) || connected LatprdDEMp1lb LatprdDEMx, lpattern(dash) msymbol(none) || connected LatprdREPp1ub LatprdDEMx, lpattern(dash) msymbol(none) || connected LatprdREPp1lb LatprdDEMx, lpattern(dash) msymbol(none)




/// Predicted Probabilities from Model 1 for table 5
probit total repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo, robust

prvalue, x(Repmean .25 Demmean -.68 repcontrol 1 IDEOrepContSM .25 LATINOCVAP .95 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)
prvalue, x(Repmean .25 Demmean -.68 repcontrol 1 IDEOrepContSM .25 LATINOCVAP 1.56 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)
prvalue, x(Repmean .25 Demmean -.68 repcontrol 1 IDEOrepContSM .25 LATINOCVAP 2.54 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)
prvalue, x(Repmean .25 Demmean -.68 repcontrol 1 IDEOrepContSM .25 LATINOCVAP 5.16 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)
prvalue, x(Repmean .25 Demmean -.68 repcontrol 1 IDEOrepContSM .25 LATINOCVAP 19.71 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)

prvalue, x(Repmean .75 Demmean -.68 repcontrol 1 IDEOrepContSM .75 LATINOCVAP .95 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)
prvalue, x(Repmean .75 Demmean -.68 repcontrol 1 IDEOrepContSM .75 LATINOCVAP 1.56 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)
prvalue, x(Repmean .75 Demmean -.68 repcontrol 1 IDEOrepContSM .75 LATINOCVAP 2.56 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)
prvalue, x(Repmean .75 Demmean -.68 repcontrol 1 IDEOrepContSM .75 LATINOCVAP 5.16 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)
prvalue, x(Repmean .75 Demmean -.68 repcontrol 1 IDEOrepContSM .75 LATINOCVAP 19.71 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)

prvalue, x(Repmean 1.25 Demmean -.68 repcontrol 1 IDEOrepContSM 1.25 LATINOCVAP .95 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)
prvalue, x(Repmean 1.25 Demmean -.68 repcontrol 1 IDEOrepContSM 1.25 LATINOCVAP 1.56 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)
prvalue, x(Repmean 1.25 Demmean -.68 repcontrol 1 IDEOrepContSM 1.25 LATINOCVAP 2.56 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)
prvalue, x(Repmean 1.25 Demmean -.68 repcontrol 1 IDEOrepContSM 1.25 LATINOCVAP 5.16 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)
prvalue, x(Repmean 1.25 Demmean -.68 repcontrol 1 IDEOrepContSM 1.25 LATINOCVAP 19.71 termlimits 0 RepGov 0 borderstate 0 thesouth 0 pctFB 8.06 PCTsince2000 34.42 unemployment 6.33)



/// First Differences Graphs Base Model SM -final

clear all
#delimit ;
set more off;

use "/Users/joshuazingher/Desktop/State Immigration Legislation/US Immigration laws - 10-16.dta";


probit total repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct, robust;

preserve;


drawnorm SN_b1-SN_b14, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using "/Users/joshuazingher/Desktop/State Immigration Legislation/mleinteraction.dta", replace;
noisily display "start";
	
local a=0;
while `a' <= 1.25 {; 
{;
scalar h_repcontrol=0;
scalar h_Demmean=-.66;
scalar h_LATINOCVAP=2.33;
scalar h_termlimits=0;
scalar h_professionalization=2;
scalar h_RepGov=1;
scalar h_borderstate=0;
scalar h_thesouth=0;
scalar h_pctFB=6.33;
scalar h_PCTsince2000=34.33;
scalar h_unemployment=6.33;
scalar h_Constant=1;

generate x_betahat0  = SN_b1*h_repcontrol + SN_b2*(`a') + SN_b3*h_repcontrol*(`a') +SN_b4*h_Demmean + SN_b5*h_LATINOCVAP + SN_b6*h_termlimits + SN_b7*h_professionalization + SN_b8*h_RepGov + SN_b9*h_borderstate + SN_b10*h_thesouth + SN_b11*h_pctFB + SN_b12*h_PCTsince2000 + SN_b13*h_unemployment + SN_b14*h_Constant;
generate x_betahat1  = SN_b1*(h_repcontrol +1)+SN_b2*(`a') + SN_b3*(h_repcontrol+1)*(`a') +SN_b4*h_Demmean + SN_b5*h_LATINOCVAP + SN_b6*h_termlimits + SN_b7*h_professionalization + SN_b8*h_RepGov + SN_b9*h_borderstate + SN_b10*h_thesouth + SN_b11*h_pctFB + SN_b12*h_PCTsince2000 + SN_b13*h_unemployment + SN_b14*h_Constant;
generate prob0 =normal(x_betahat0);
generate prob1=normal(x_betahat1);
generate diff=prob1-prob0;
    
    egen probhat0 =mean(prob0);
    egen probhat1=mean(prob1);
    egen diffhat=mean(diff);
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi;  

    _pctile prob0, p(2.5,97.5) ;
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);  
    
    _pctile prob1, p(2.5,97.5);
    scalar `lo1'= r(r1);
    scalar `hi1'= r(r2);  
    
    _pctile diff, p(2.5,97.5);
    scalar `diff_lo'= r(r1);
    scalar `diff_hi'= r(r2);  
   
    scalar `prob_hat0'=probhat0;
    scalar `prob_hat1'=probhat1;
    scalar `diff_hat'=diffhat;
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 
                (`diff_hat') (`diff_lo') (`diff_hi');
   
    };      
    
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat;
    
    local a=`a'+ .01;
    
    display "." _c;
    
} ;

display "";

postclose mypost;

restore;


merge using "/Users/joshuazingher/Desktop/State Immigration Legislation/mleinteraction.dta";


gen yline = 0;

gen MV = [_n-1]/100;

replace  MV=. if _n>125;

graph twoway hist Repmean if Repmean>=0, fraction color(gs14) yaxis(1) ylabel(-.1(.1).5) fcolor(white) lcolor(black) || ///
line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black) ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid) xlabel(0(.25)1.25) ylabel(0(.1).5) legend(cols(2)) ytitle(Magnitude of First Difference/Proportion of Observations) xtitle(Republican Ideology) title(First Differences From Model 2 Interaction Term) graphregion(lcolor(black)) || 
     
           

            
/// First Differences Graphs Base Model SM -final

clear all
#delimit ;
set more off;

use "/Users/joshuazingher/Desktop/State Immigration Legislation/US Immigration laws - 10-16.dta";


probit mand repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2007-d2011, robust cluster(id);

preserve;


drawnorm SN_b1-SN_b20, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using "/Users/joshuazingher/Desktop/State Immigration Legislation/mleinteraction.dta", replace;
noisily display "start";
	
local a=0;
while `a' <= 1.25 {; 
{;
scalar h_repcontrol=0;
scalar h_Demmean=-.66;
scalar h_LATINOCVAP=2.33;
scalar h_termlimits=0;
scalar h_professionalization=2;
scalar h_RepGov=1;
scalar h_borderstate=0;
scalar h_thesouth=0;
scalar h_pctFB=6.33;
scalar h_PCTsince2000=34.33;
scalar h_unemployment=6.33;
scalar h_Citizen_Ideo=52.54;
scalar h_d2007=0;
scalar h_d2008=0;
scalar h_d2009=0;
scalar h_d2010=0;
scalar h_d2011=0;
scalar h_Constant=1;


generate x_betahat0  = SN_b1*h_repcontrol + SN_b2*(`a') + SN_b3*h_repcontrol*(`a') +SN_b4*h_Demmean + SN_b5*h_LATINOCVAP + SN_b6*h_termlimits + SN_b7*h_professionalization + SN_b8*h_RepGov + SN_b9*h_borderstate + SN_b10*h_thesouth + SN_b11*h_pctFB + SN_b12*h_PCTsince2000 + SN_b13*h_unemployment + SN_b13*h_Citizen_Ideo + SN_b15*h_d2007 + SN_b16*h_d2008 + SN_b17*h_d2009 + SN_b18*h_d2010 + SN_b19*h_d2011 +  SN_b20*h_Constant;
generate x_betahat1  = SN_b1*(h_repcontrol +1)+SN_b2*(`a') + SN_b3*(h_repcontrol+1)*(`a') +SN_b4*h_Demmean + SN_b5*h_LATINOCVAP + SN_b6*h_termlimits + SN_b7*h_professionalization + SN_b8*h_RepGov + SN_b9*h_borderstate + SN_b10*h_thesouth + SN_b11*h_pctFB + SN_b12*h_PCTsince2000 + SN_b13*h_unemployment + SN_b13*h_Citizen_Ideo + SN_b15*h_d2007 + SN_b16*h_d2008 + SN_b17*h_d2009 + SN_b18*h_d2010 + SN_b19*h_d2011  + SN_b20*h_Constant;
generate prob0 =normal(x_betahat0);
generate prob1=normal(x_betahat1);
generate diff=prob1-prob0;
    
    egen probhat0 =mean(prob0);
    egen probhat1=mean(prob1);
    egen diffhat=mean(diff);
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi;  

    _pctile prob0, p(2.5,97.5) ;
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);  
    
    _pctile prob1, p(2.5,97.5);
    scalar `lo1'= r(r1);
    scalar `hi1'= r(r2);  
    
    _pctile diff, p(2.5,97.5);
    scalar `diff_lo'= r(r1);
    scalar `diff_hi'= r(r2);  
   
    scalar `prob_hat0'=probhat0;
    scalar `prob_hat1'=probhat1;
    scalar `diff_hat'=diffhat;
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 
                (`diff_hat') (`diff_lo') (`diff_hi');
   
    };      
    
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat;
    
    local a=`a'+ .01;
    
    display "." _c;
    
};

display "";

postclose mypost;

restore;


merge using "/Users/joshuazingher/Desktop/State Immigration Legislation/mleinteraction.dta";


gen yline = 0;

gen MV = [_n-1]/100;

replace  MV=. if _n>125;

graph twoway hist Repmean if Repmean>=0, fraction color(gs14) yaxis(1) ylabel(-.1(.1).5) fcolor(white) lcolor(black) || ///
line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black) ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid) xlabel(0(.25)1.25) ylabel(0(.02).2) legend(cols(2)) 
     

/// Setting up Data For Appendix
clear
use "/Users/joshuazingher/Desktop/State Immigration Legislation/US Immigration laws - 10-16.dta"
drop if year==2012

/// Appendix Tables

/// ZIP Appendix Table 1
zip total repcontrol Repmean Demmean  LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2006-d2011, inflate (repcontrol RepGov LATINOCVAP) robust cluster(id)
outreg2 using AppendixZip, drop(d2006-d2011) auto(2) replace 
/// Appendix Table 2 - Gubinatorial Power
probit total repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo Gov_Power d2006-d2011, cluster(id) robust 
outreg2 using AppendixGov, drop(d2006-d2011) auto(2) replace 
probit total repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo Gov_Power Rep_Gov_Power d2006-d2011, cluster(id) robust 
outreg2 using AppendixGov, drop(d2006-d2011) auto(2) append
gen Rep_Gov_Cont = RepGov*repcontrol
probit total repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo Rep_Gov_Cont d2006-d2011, cluster(id) robust 
outreg2 using AppendixGov, drop(d2006-d2011) auto(2) append
/// Initiative 
gen Int_Rep = Initiative*repcontrol

probit total repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo  Initiative d2006-d2011, cluster(id) robust 
outreg2 using AppendixGov, drop(d2006-d2011) auto(2) append
probit total repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo  Initiative Int_Rep d2006-d2011, cluster(id) robust 
outreg2 using AppendixGov, drop(d2006-d2011) auto(2) append

gen FL = 0
replace FL=1 if state=="FL"
gen TX = 0
replace TX=1 if state=="TX"
probit total Repmean  Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Citizen_Ideo d2006-d2011 FL TX if repcontrol==1,  robust
outreg2 using TXFL, drop(d2006-d2011) auto(2) replace
/// 1 Lag
probit total repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Ltotal, robust
outreg2 using stateimm, auto(2) append
/// 2 Lags
tsset id year
sort id year
probit total repcontrol Repmean IDEOrepContSM Demmean LATINOCVAP termlimits professionalization RepGov borderstate thesouth pctFB PCTsince2000 unemploymentpct Ltotal L.Ltotal, robust
outreg2 using stateimm, auto(2) append



/// Average Panel
sort id
by id: egen Ave_LCVAP = mean(LATINOCVAP)
by id: egen Ave_repc = mean(repcontrol)
by id: egen Ave_int = mean(IDEOrepContSM)
by id: egen Ave_RMean = mean(Repmean)
by id: egen Ave_DMean = mean(Demmean)
by id: egen Ave_RGov = mean(RepGov)
by id: egen Ave_unp = mean(unemploymentpct)
by id: egen Ave_PCTFB = mean(pctFB)
by id: egen Ttotal = total(total)
by id: egen Tomni = total(omnibus)
by id: egen Ave_total = mean(total)

poisson Ttotal Ave_repc Ave_RMean Ave_int  Ave_DMean Ave_LCVAP termlimits professionalization Ave_RGov borderstate thesouth Ave_PCTFB PCTsince2000 Ave_unp Citizen_Ideo  if year==2009, robust
outreg2 using memoSE, replace
regress Ave_total Ave_repc Ave_RMean Ave_int  Ave_DMean Ave_LCVAP termlimits professionalization Ave_RGov borderstate thesouth Ave_PCTFB PCTsince2000 Ave_unp Citizen_Ideo  if year==2009, robust
outreg2 using memoSE, append
