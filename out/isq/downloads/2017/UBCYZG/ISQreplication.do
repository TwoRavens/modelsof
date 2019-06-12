**********************************************************
//////////////////////////////////////////////////////////
// Author: Matthew R. DiGiuseppe  
//
// Do File: ISQreplication 
//
// Date: 6/24/2014
//////////////////////////////////////////////////////////
**********************************************************

// This file replicates the tables and figure from 
// "Sovereign Credit and the Fate of Leaders: Reassessing the Democratic Advantage" 

cd "/Users/digiuseppe/Dropbox/Credit and Political Survival/Data/Dem_Ad_Data_Analysis/Replication"



//////////////////////////////////////////////////////////
**********************************************************
//////////////////////////////////////////////////////////
// TABLES 
//////////////////////////////////////////////////////////
**********************************************************
//////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////
// TABLE 2
//////////////////////////////////////////////////////////	
set more off 
use "ISQreplication.dta", clear 
stset endobs, id(leadid) failure(WFAIL==1) origin(time eindate) enter(time startobs) // scale(365.25) /*/ 
gen lnt=ln(_t)


gen demXsp = dem*sp_ch_l							
stcox   dem sp_ch_l demXsp SP_l growthL lnrgppc , nohr robust cl(leadid)
est sto MODEL1
stcox   dem sp_ch_l demXsp SP_l growthL lnrgppc $cntrls, nohr robust cl(leadid)
	
gen polsp = polity2*sp_ch_l
stcox  polity sp_ch_l polsp SP_l growthL lnrgppc , nohr robust cl(leadid)
est sto MODEL3

gen politylnt = polity*lnt 
stcox  polity2 sp_ch_l polsp SP_l growthL lnrgppc $cntrls politylnt, nohr robust cl(leadid)



//////////////////////////////////////////////////////////
// TABLE 3
//////////////////////////////////////////////////////////
set more off 
use "ISQreplication.dta", clear 
stset endobs, id(leadid) failure(WFAIL==1) origin(time eindate) enter(time startobs) // scale(365.25) /*/ 
		gen lnt=ln(_t)
sort leaderid _t
by leaderid: gen tyear=_n
	drop if leaderid==.			
xtset leaderid year
regress sp_ch SP_l dem growthL lnrgppc comp conflict_banks_wght lnt SPch_SUB_AVG SPch_SUB_AVG_l   , robust cl(leadid)		
	predict v, res 
	predict xb, xb
	gen dxb = dem*xb
probit WFAIL dem xb dxb  SP_l  growthL lnrgppc comp conflict_banks_wght lnt, robust cl(leadid) 





//////////////////////////////////////////////////////////
**********************************************************
//////////////////////////////////////////////////////////
// SUPPLEMENTARY APPENDIX  
//////////////////////////////////////////////////////////
**********************************************************
//////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////
// TABLE A1
//////////////////////////////////////////////////////////	
set more off 
use "ISQreplication.dta", clear 
stset endobs, id(leadid) failure(WFAIL==1) origin(time eindate) enter(time startobs) // scale(365.25) /*/ 
gen lnt=ln(_t)

	cap gen demXspreadch = spread_ch_l*dem 							
		
stcox  spread_l dem spread_ch_l demXspreadch growthL lnrgppc, nohr robust cl(leadid)
est sto ModelA1
	gen demlnt = dem*lnt 
	gen bankslnt = 	conflict_banks_wght*lnt
	
stcox  spread_l dem spread_ch_l demXspreadch growthL lnrgppc $cntrls bankslnt, nohr robust cl(leadid)	


cap gen polspread = polity2*spread_ch_l
stcox  spread_l polity2 spread_ch_l polspread  growthL lnrgppc, nohr robust cl(leadid)
est sto ModelA3
stcox  spread_l polity2 spread_ch_l polspread  growthL lnrgppc $cntrls, nohr robust cl(leadid)



//////////////////////////////////////////////////////////
// TABLE A2: Negative Change
//////////////////////////////////////////////////////////	
use "ISQreplication.dta", clear 
stset endobs, id(leadid) failure(WFAIL==1) origin(time eindate) enter(time startobs) // scale(365.25) /*/ 
gen lnt=ln(_t)

			
replace sp_ch_l	= 0 if sp_ch_l>0 & sp_ch_l!=.
cap gen demXsp = dem*sp_ch_l							

stcox   dem sp_ch_l demXsp SP_l growthL lnrgppc , nohr robust cl(leadid)
stcox   dem sp_ch_l demXsp SP_l growthL lnrgppc $cntrls, nohr robust cl(leadid)

gen polsp = polity2*sp_ch_l
stcox  polity sp_ch_l polsp SP_l growthL lnrgppc , nohr robust cl(leadid)
gen politylnt = polity*lnt 
stcox  polity2 sp_ch_l polsp SP_l growthL lnrgppc $cntrls politylnt, nohr robust cl(leadid)




//////////////////////////////////////////////////////////
// TABLE A3: Career Change
//////////////////////////////////////////////////////////	
use "ISQreplication.dta", clear 
stset endobs, id(leadid) failure(WFAIL==1) origin(time eindate) enter(time startobs) // scale(365.25) /*/ 
gen lnt=ln(_t)


	regress SP SP_l
	keep if e(sample)				
				
	sort leaderid year 
	by leaderid: gen obs= _n

	gen firstobs = SP if obs==1
	sort leaderid year 
	by leaderid: egen _1stobs = max(firstobs)
	gen career_ch = SP-_1stobs

	
gen demXsp = dem*career_ch	
stcox  SP_l dem career_ch demXsp growthL lnrgppc , nohr robust cl(leadid)
stcox  SP_l dem career_ch demXsp growthL lnrgppc $cntrls, nohr robust cl(leadid)
	
gen polXsp 	= polity2*career_ch
stcox  SP_l polity2 career_ch polXsp growthL lnrgppc , nohr robust cl(leadid)
stcox  SP_l polity2 career_ch polXsp growthL lnrgppc $cntrls, nohr robust cl(leadid)




//////////////////////////////////////////////////////////
// TABLE A4: Selection Model 
//////////////////////////////////////////////////////////	
use "ISQreplication.dta", clear 
stset endobs, id(leadid) failure(WFAIL==1) origin(time eindate) enter(time startobs) // scale(365.25) /*/ 
gen lnt=ln(_t)

gen _SP = 0 if sp_ch_l==.
replace _SP = 1 if sp_ch_l!=. 


cap gen demXsp = dem*sp_ch_l							
heckprob WFAIL dem  sp_ch_l demXsp SP_l  growthL lnrgppc lnt, ///
	sel(_SP= polity2 lnrgppc growthL USexp topenV3 defyears i.decade) cl(leadid) robust 

	
	
	
	
//////////////////////////////////////////////////////////
// TABLE A5: Potentially Confounding
//////////////////////////////////////////////////////////	
use "ISQreplication.dta", clear 
stset endobs, id(leadid) failure(WFAIL==1) origin(time eindate) enter(time startobs) // scale(365.25) /*/ 
gen lnt=ln(_t)


cap gen demXsp = dem*sp_ch_l							

set more off
global list oecd fuelexp_lag aidgni topen GDFdebtgdp_ext deficit inflationCP_l	
foreach var of global list{
stcox SP_l  dem sp_ch_l demXsp  growthL lnrgppc `var', nohr robust cl(leadid)	
est sto `var'
}
//











//////////////////////////////////////////////////////////
**********************************************************
//////////////////////////////////////////////////////////
// FIGURES  
//////////////////////////////////////////////////////////
**********************************************************
//////////////////////////////////////////////////////////	
	
	
//////////////////////////////////////////////////////////
// FIGURE 1
//////////////////////////////////////////////////////////	
use "ISQreplication.dta", clear 
est restore MODEL1
#delimit ;
preserve;
set seed 8673405;
drawnorm SN_b1-SN_b6, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost  hazlo hazhi  haz dem_s
            using simtemp, replace;
noisily display "start";
local a=0 ;
while `a' <= 1 { ;
{;
scalar h_SP_l	=11;
scalar h_dem	=`a';
scalar h_lnrgppc= 9.4;
scalar h_growthL=.02;

    generate xb0  			= SN_b1* `a'   
                            + SN_b2* 0 
                            + SN_b3* 0 *`a';
    generate xb3  			= SN_b1* `a'   
                            + SN_b2* -1 
                            + SN_b3* -1 *`a';

		gen e_xb0 = exp(xb0);
		gen e_xb3 = exp(xb3);

		gen 	dhaz = ((e_xb3-e_xb0)/e_xb0)*100;						
		egen	d_haz = mean(dhaz); 					
		gen 	DEM = `a';
		
		tempname  hazlo hazhi  haz dem_s;
		
		_pctile dhaz, p(2.5,97.5) ;
		scalar `hazlo' = r(r1);
		scalar `hazhi' = r(r2); 
		
		scalar `haz'=d_haz;
		scalar `dem_s' = DEM;
		
		post mypost (`hazlo') (`hazhi') (`haz') (`dem_s');					
							
    };      
    
    drop xb0 xb3 e_* dhaz d_haz DEM ; 
    local a=`a'+ 1;
	display "." _c;
    
} ;

display ""; postclose mypost; restore;	merge using simtemp;
drop _merge;

 label var dem_s "Democracy";
 label define Democracy 0 "Non-Democracy" 1 "Democracy";
 label values dem_s Democracy;

#delimit ;
cap gen yline=0;
twoway (rcap hazlo hazhi dem_s, sort)
(line yline dem_s, lcolor(black) lpattern(dash)), 
xlabel(minmax, valuelabel)  legend(off)
plotregion(margin(20 20 5 5)) title(1 Unit Downgrade in S&P Rating) ytitle(, size(zero)) 
scheme(s1manual) name(sp, replace) xtitle(, size(zero)) ;
#delimit cr

use "ISQreplication.dta", clear 
est restore MODEL3
#delimit ;
preserve;
set seed 8673405;
drawnorm SN_b1-SN_b6, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost  hazlo hazhi  haz dem_s
            using simtemp, replace;
noisily display "start";
local a=-10 ;
while `a' <= 10 { ;
{;
scalar h_polity	=`a';

    generate xb0  			= SN_b1* `a'   
                            + SN_b2* 0 
                            + SN_b3* 0 *`a';
    generate xb3  			= SN_b1* `a'   
                            + SN_b2* -1 
                            + SN_b3* -1 *`a';

		gen e_xb0 = exp(xb0);
		gen e_xb3 = exp(xb3);

		gen 	dhaz = ((e_xb3-e_xb0)/e_xb0)*100;						
		egen	d_haz = mean(dhaz); 					
		gen 	DEM = `a';
		
		tempname  hazlo hazhi  haz dem_s;
		
		_pctile dhaz, p(2.5,97.5) ;
		scalar `hazlo' = r(r1);
		scalar `hazhi' = r(r2); 
		
		scalar `haz'=d_haz;
		scalar `dem_s' = DEM;
		
		post mypost (`hazlo') (`hazhi') (`haz') (`dem_s');					
							
    };      
    
    drop xb0 xb3 e_* dhaz d_haz DEM ; 
    local a=`a'+ 1;
	display "." _c;
    
} ;

display ""; postclose mypost; restore;	merge using simtemp;
					
label var dem_s "Polity";
cap gen yline=0;
replace hazhi = . if hazhi>600;
replace haz = . if haz>600;

graph twoway 
	||	rline hazlo hazhi dem_s, lcolor(black) 
	|| 	line haz dem_s, lcolor(black) lpattern(dot)
	|| 	line yline dem_s, lpattern(dash)
	, title(1 Unit Downgrade in S&P Rating) legend(off) scheme(s1manual)
	name(sppolity, replace);
		#delimit cr

graph combine sp sppolity, title(% Change in Hazard) scheme(s1manual)	
		
		
		
//////////////////////////////////////////////////////////
// FIGURE 2
//////////////////////////////////////////////////////////		
use "ISQreplication.dta", clear 
est restore ModelA1

#delimit ;
preserve;
set seed 8673405;
drawnorm SN_b1-SN_b6, n(10000) means(e(b)) cov(e(V)) clear;


postutil clear;
postfile mypost  hazlo hazhi  haz dem_s
            using simtemp, replace;
noisily display "start";


local a=0 ;
while `a' <= 1 { ;

{;
scalar h_spread_l=3.5;
scalar h_dem	=`a';



    generate xb0  			= SN_b1*h_spread_l 
                            + SN_b2* `a'   
                            + SN_b3* 0 
                            + SN_b4* 0 *`a';

    generate xb3  			= SN_b1*h_spread_l 
                            + SN_b2* `a'   
                            + SN_b3* 11.9 
                            + SN_b4* 11.9 *`a';

		gen e_xb0 = exp(xb0);
		gen e_xb3 = exp(xb3);

		gen 	dhaz = ((e_xb3-e_xb0)/e_xb0)*100;						
		egen	d_haz = mean(dhaz); 					
		gen 	DEM = `a';
		
		tempname  hazlo hazhi  haz dem_s;
		
		_pctile dhaz, p(2.5,97.5) ;
		scalar `hazlo' = r(r1);
		scalar `hazhi' = r(r2); 
		
		scalar `haz'=d_haz;
		scalar `dem_s' = DEM;
		
		post mypost (`hazlo') (`hazhi') (`haz') (`dem_s');					
							
    };      
    
    drop xb0 xb3 e_* dhaz d_haz DEM ; 
    local a=`a'+ 1;
	display "." _c;
    
} ;

display ""; postclose mypost; restore;	merge using simtemp;
#delimit ;
 label var dem_s "Democracy";
 label define Democracy 0 "Non-Democracy" 1 "Democracy";
 label values dem_s Democracy;
#delimit ;
cap gen yline=0;
twoway (rcap hazlo hazhi dem_s, sort)
(line yline dem_s, lcolor(black) lpattern(dash)), 
xlabel(minmax, valuelabel)  legend(off)
plotregion(margin(20 20 5 5)) title(1 SD Increase in Bond Spread) ytitle(, size(zero)) 
scheme(s1manual) name(spread, replace) xtitle(, size(zero)) ;
	#delimit cr

use "ISQreplication.dta", clear 
est restore ModelA3	
#delimit ;
preserve;
set seed 8673405;
drawnorm SN_b1-SN_b6, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost  hazlo hazhi  haz dem_s
            using simtemp, replace;
noisily display "start";
local a=-10 ;
while `a' <= 10 { ;

{;
scalar h_spread_l=3.5;
scalar h_dem	=`a';

    generate xb0  		= SN_b1*h_spread_l 
                            + SN_b2* `a'   
                            + SN_b3* 0 
                            + SN_b4* 0 *`a';

    generate xb3  			= SN_b1*h_spread_l 
                            + SN_b2* `a'   
                            + SN_b3* 11.9 
                            + SN_b4* 11.9 *`a';

		gen e_xb0 = exp(xb0);
		gen e_xb3 = exp(xb3);

		gen 	dhaz = ((e_xb3-e_xb0)/e_xb0)*100;						
		egen	d_haz = mean(dhaz); 					
		gen 	DEM = `a';
		
		tempname  hazlo hazhi  haz dem_s;
		
		_pctile dhaz, p(2.5,97.5) ;
		scalar `hazlo' = r(r1);
		scalar `hazhi' = r(r2); 
		
		scalar `haz'=d_haz;
		scalar `dem_s' = DEM;
		
		post mypost (`hazlo') (`hazhi') (`haz') (`dem_s');					
							
    };      
    
    drop xb0 xb3 e_* dhaz d_haz DEM ; 
    local a=`a'+ 1;
	display "." _c;
    
} ;

display ""; postclose mypost; restore;	merge using simtemp;
#delimit ;
label var dem_s "Polity";
cap gen yline=0;
replace hazhi = . if hazhi>3000;
replace haz = . if haz>3000;
graph twoway 
	||	rline hazlo hazhi dem_s, lcolor(black) 
	|| 	line haz dem_s, lcolor(black) lpattern(dot)
	|| 	line yline dem_s, lpattern(dash)
	, title(1 SD Increase in Spread) legend(off) scheme(s1manual)
	name(spreadpolity, replace);
#delimit cr 
graph combine spread spreadpolity, title(% Change in Hazard) scheme(s1manual)		





//////////////////////////////////////////////////////////
// FIGURE A1
//////////////////////////////////////////////////////////	
cd "/Users/digiuseppe/Dropbox/Credit and Political Survival/Data/Dem_Ad_Data_Analysis/Replication"

set more off
forvalues i = 0/1{
use "ISQreplication.dta", clear 
stset endobs, id(leadid) failure(WFAIL==1) origin(time eindate) enter(time startobs) // scale(365.25) /*/ 
gen lnt=ln(_t)
gen demXsp = dem*sp_ch_l							
gen investgrade = ( sp1last>=10 & sp1last!=.)
gen spinvest = investgrade*sp_ch_l
gen deminvest  = dem*investgrade
gen demnvestsp = dem*sp_ch_l*investgrade


set more off
stcox   dem sp_ch_l demXsp investgrade demnvestsp  SP_l growthL lnrgppc , nohr robust cl(leadid)
cap drop _merge
mat list e(b)
mat list e(V)

#delimit ;
preserve;
set seed 8673405;
drawnorm SN_b1-SN_b8, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost  hazlo hazhi  haz dem_s
            using simtemp, replace;
noisily display "start";
local a=0 ;
while `a' <= 1 { ;
{;
scalar h_SP_l	=11;
scalar h_dem	=`a';
scalar h_lnrgppc= 9.4;
scalar h_growthL=.02;
scalar h_invest = `i';
    generate xb0  			= SN_b1* `a' 
                            + SN_b2* 0 
                            + SN_b3*  0 * `a'
                            + SN_b4* h_invest
                            + SN_b5* `a' * 0 * h_invest 	;
							
							
    generate xb3  			= SN_b1* `a' 
                            + SN_b2* -1 
                            + SN_b3*  -1 * `a'
                            + SN_b4* h_invest
                            + SN_b5* `a' * -1 * h_invest 	;
							
		gen e_xb0 = exp(xb0);
		gen e_xb3 = exp(xb3);
		gen 	dhaz = ((e_xb3-e_xb0)/e_xb0)*100;						
		egen	d_haz = mean(dhaz); 					
		gen 	DEM = `a';
		tempname  hazlo hazhi  haz dem_s;
		_pctile dhaz, p(2.5,97.5) ;
		scalar `hazlo' = r(r1);
		scalar `hazhi' = r(r2); 
		scalar `haz'=d_haz;
		scalar `dem_s' = DEM;
		post mypost (`hazlo') (`hazhi') (`haz') (`dem_s');												
    };       
    drop xb0 xb3 e_* dhaz d_haz DEM ; 
    local a=`a'+ 1;
	display "." _c; 
} ;
display ""; postclose mypost; restore;	merge using simtemp;
#delimit ;
cap gen yline=0;
tabstat haz hazlo hazhi, by(dem_s);						

 label var dem_s "Democracy";
 label define Democracy 0 "Non-Democracy" 1 "Democracy";
 label values dem_s Democracy;


twoway (rcap hazlo hazhi dem_s, sort)
(line yline dem_s, lcolor(black) lpattern(dash)), 
xlabel(minmax, valuelabel)  legend(off)
plotregion(margin(20 20 5 5)) title(Investment Grade) ytitle(, size(zero)) 
scheme(s1manual) name(sp`i', replace) xtitle(, size(zero)) ;
#delimit cr
}

graph combine sp0 sp1, scheme(s1manual) title(1 Unit Downgrade in S&P Rating)






//////////////////////////////////////////////////////////
// FIGURE A2
//////////////////////////////////////////////////////////	



	
set more off
global list oecd fuelexp_lag aidgni topen GDFdebtgdp_ext deficit inflationCP_l	
foreach var of global list{
use "ISQreplication.dta", clear 
stset endobs, id(leadid) failure(WFAIL==1) origin(time eindate) enter(time startobs) // scale(365.25) /*/ 
gen lnt=ln(_t)
gen demXsp = dem*sp_ch_l
	
label var oecd  "OECD"
label var fuelexp_lag  "Fuel Exp."
label var aidgni   "Aid/GNI"
label var deficit "Primary Balance"
label var inflationCP_l "Inflation"
label var topen 			"Trade Openness"
label var GDFdebtgdp_ext "Debt/GDP"		

	cap drop _merge
	
est restore `var' 

#delimit ;
preserve;
set seed 8673405;
drawnorm SN_b1-SN_b7, n(10000) means(e(b)) cov(e(V)) clear;


postutil clear;
postfile mypost  hazlo hazhi  haz dem_s
            using simtemp, replace;
noisily display "start";


local a=0 ;
while `a' <= 1 { ;

{;
scalar h_SP_l	=11;
scalar h_dem	=`a';
scalar h_lnrgppc= 9.4;
scalar h_growthL=.02;


    generate xb0  			= SN_b2* `a'   
                            + SN_b3* 0 
                            + SN_b4* 0 *`a';

    generate xb3  			= SN_b2* `a'   
                            + SN_b3* -1 
                            + SN_b4* -1 *`a';

		gen e_xb0 = exp(xb0);
		gen e_xb3 = exp(xb3);

		gen 	dhaz = ((e_xb3-e_xb0)/e_xb0)*100;						
		egen	d_haz = mean(dhaz); 					
		gen 	DEM = `a';
		
		tempname  hazlo hazhi  haz dem_s;
		
		_pctile dhaz, p(2.5,97.5) ;
		scalar `hazlo' = r(r1);
		scalar `hazhi' = r(r2); 
		
		scalar `haz'=d_haz;
		scalar `dem_s' = DEM;
		
		post mypost (`hazlo') (`hazhi') (`haz') (`dem_s');					
							
    };      
    
    drop xb0 xb3 e_* dhaz d_haz DEM ; 
    local a=`a'+ 1;
	display "." _c;
    
} ;

display ""; postclose mypost; restore;	merge using simtemp;

tabstat haz hazlo hazhi, by(dem_s);						

cap  label var dem_s "Dem";
cap label define Democracy 0 "Non-Dem" 1 "Dem";
cap  label values dem_s Democracy;

#delimit ;
cap gen yline=0;
twoway (rcap hazlo hazhi dem_s, sort)
(line yline dem_s, lcolor(black) lpattern(dash)), 
xlabel(minmax, valuelabel)  legend(off) 
plotregion(margin(20 20 5 5)) title(`: variable label `var'') ytitle(, size(zero)) 
scheme(s1manual) name(`var', replace) xtitle(, size(zero)) ;	
#delimit cr

drop  hazlo hazhi haz dem_s yline

}	

graph combine $list , scheme(s1manual) title(1 Unit Downgrade in S&P Rating) 



