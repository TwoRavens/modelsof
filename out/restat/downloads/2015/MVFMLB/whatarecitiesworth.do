/*** CODE FOR "WHAT ARE CITIES WORTH? LAND RENTS, LOCAL PRODUCTIVITY, AND THE TOTAL VALUE OF AMENITIES ***/
/** Uses data stcmsa2000_wacw_albouy.dta */

*set output error 
# delimit ;

version 13.1;

clear ;

/*** Directory ***/
cd d:\data\restat ;

set more off ;

/********** PARAMETERIZATION ***************/
/*** SHARES & ELASTICITIES ***/

/** KEY SHARES IN FULL MODEL **/

local sharey : di %06.4f = 0.36 ;
local thetal : di %06.4f = 0.025 ;     /** previously let s_y=0.22 **/
local thetan : di %06.4f = 0.825 ;     /** previous lit is what */
local phil : di %06.4f = 0.233333 ;   /** 0.2333 or 1 **/
local phin : di %06.4f = 0.616667 ;   /**  0.616667 or 0 **/


/** for reduced moded **/

local sharey_dum : di %6.4f = 0.077 ;
local phil_dum : di %6.4f = 1.0 ;
local phin_dum : di %6.4f = 0.0 ;

local sharet : di %6.4f = 0 ;
local sharex : di %6.4f = 1- `sharey' - `sharet' ;
local sharex_dum : di %6.4f = 1- `sharey_dum'  ;

/*** COST SHARES AND ELASTICITIES  **/

local thetak : di %6.4f = 1- `thetal' - `thetan';
local phik : di %06.4f = 1 - `phil' - `phin' ;

/** INCOME SHARES ***/

local sharew : di %06.4f = (`sharex'+`sharet')*`thetan' + `sharey'*`phin';
local sharer : di %6.4f = (`sharex'+`sharet')*`thetal' + `sharey'*`phil';
local sharei : di %6.4f = 1- `sharew' - `sharer' ;

local sharew_dum : di %06.4f = (`sharex_dum')*`thetan' + `sharey_dum'*`phin_dum';
local sharer_dum : di %6.4f = (`sharex_dum')*`thetal' + `sharey_dum'*`phil_dum';



/** SHARE OF FACTORS IN TRADABLE PRODUCTION ***/

local lambdal : di %6.4f = (`sharex'+`sharet')*`thetal'/`sharer' ;
local lambdan : di %6.4f = (`sharex'+`sharet')*`thetan'/`sharew' ;
local lambdak : di %6.4f = (`sharex'+`sharet')*`thetak'/`sharei' ;

/**** TAX PARAMETERS ***/

		local fedinc : di %06.4f = 0.251 ;      /** TAXSIM FEDERAL INCOME TAX RATE **/
		local hi : di %6.4f = 0.029 ;	    /** HI RATE, BOTH SIDES **/
		local oasdi : di %6.4f = 0.124 ;	    /** OASDI RATE, BOTH SIDES **/
		local payrolladj : di %6.4f = 1 ;      /** FRACTION OF WAGE INCOME TAXED ON MARGIN **/
		local oasdiadj : di %6.4f = 0.5*0.85 ;	    /** SHARE NOT RECEIVED IN FUTURE BENEFITS **/
		local mortded : di %6.4f = 0.216 ;     /** TAXSIM REDUCTION IN LIABILITY FROM MORTGAGE **/
		local itemshare : di %6.4f = 0.67 ;    /** SHARE OF ITEMIZERS **/
		local houseshare : di %6.4f = 0.59 ;   /** HOUSING SHARE OF HOME GOODS **/

local payroll : di %6.4f =  `payrolladj'*(`hi'+`oasdi'*`oasdiadj')  ;
local mtr : di %6.4f = `fedinc' + `payroll' ;
local ded : di %6.4f = (`mortded'*`itemshare'*`houseshare')/`mtr' ;

local mtr_aded : di %6.4f = `mtr'*(1-`sharey'*`ded') ;

local salesred : di %6.4f = 0.1 ;   /** PERCENT OF NON-HOUSING EXPENDITURES MISSED BY SALES TAX **/
local foodshare : di %6.4f = 0.08 ; /** REDUCTION FROM FOOD (GROCERY) EXPENDITURES **/
local salesded : di %6.4f = 0.075 ; /** PERCENT MISSED BECAUSE OF OWNER-OCCUPIED HOUSING **/ 

/************ INTRODUCE DATA ***********************************************/

use stcmsa2000_wacw_albouy , replace ;

duplicates drop  cmsa , force ;

/** Use population weighted WRLURI index **/

replace wrluri = wrluri_popw ;

keep cmsa pop cmsapop cmsaname shortname state_main wrluri-latitude ;
save amenities_cmsa2000, replace ;

*set output error ;

use restat_stcmsa2000 , replace ;

/*** For State means ***/

g w_stm = . ;
g p_stm = . ;

/** Recommended weight here is population **/

g weight = pop ;
/************************ RECENTER DATA AROUND ZERO *****************************/


foreach V in w p  {  ;
	foreach S of num 1(1)56 { ;
		su `V' [aw=weight] if statefip==`S' ;
		replace `V'_stm = r(mean) if statefip==`S' ;
	} ;
} ;

for V in var  w_stm p_stm:
	su V [aw=weight] \
	replace V = V - r(mean) ;

g w_std = w - w_stm ;
g p_std = p - p_stm ;


/** ADJUST WAGES TO DEAL WITH POSSIBLE BIAS AND IN EMPLOYER HALF OF PAYROLL TAX **/
/** COST IS FACED BY FIRMS, WHILE W_OBS IS RECEVIED ***/

g w_obs = w ;
for W in var w w_std w_stm : replace W = (1+0.5*`payroll')*W ;
g w_cost = w ;

/*** RECENTER DATA ***/
*set output proc ;
qui for V in var w w_stm p p_stm  :
	su V [aw=weight] \
	replace V = V - r(mean) ;

	
/*************************************************************************************/
/** ESTIMATE LAND RENT FROM HOUSING COST AND WAGES WITH Ay = 0 ***********************/
/*************************************************************************************/

/*** FIRST ORDER APPRODXMATION ***/

g r = (p - `phin'*w)/`phil' ; 
g r_cost = r ;
g r_dum = (p - `phin'*w_obs)/`phil' ; 


/******************************************/
/***                                    ***/
/***         TAXATION SECTION           ***/
/***                                    ***/
/******************************************/


/*** CALCULATE STATE TAX PARAMETERS ***/

g saleseff = (1-`salesred')*(1-foodexem*`foodshare')* salestax ;
g stmtr = stwagetax + saleseff ;

g stded = (`itemshare'*`houseshare'*(-stmortded) + `houseshare'*salestax)/stmtr ; 
replace stded=0 if stded==. ;

su stmtr [aw=weight];
local avgstmtr = r(mean) ;
su stded [aw=weight] ;
local avgstded = r(mean) ;

local avgmtr = `mtr' + `avgstmtr' - `mtr'*`avgstmtr' ;
local avgded = (`ded'*`mtr' + (1-`mtr')*`avgstded'*`avgstmtr')/(`avgmtr')  ;

*noi macro list ;

g mtr = `mtr' ;
g ded = `ded' ;

noi su weight ;

/*** CHANGE STATE MARGINAL TAX RATE TO ACCOUNT FOR EFFECTIVE DEDUCITON OF FEDERAL TAXES FROM STATE TAXES **/

replace stmtr = stmtr*(1 - mtr*(1-`sharey'*ded) ) ;

/*
/** option turn off taxes **/
replace mtr = 0.361 ;
replace ded=0 ;
replace stded = 0 ;
replace stmtr = 0 ;
*/
/***************************** TRADE PRODUCTIVITY AND QOL ESTIMATES *************************/


/*********** PRIMARY MODEL FOR Ax ASSUMES Ay=0 *********/

g ax = (`thetan' - `thetal'*`phin'/`phil')*w + (`thetal'/`phil')*p ;
g ax_true = ax ;
g ax_obs = (`thetan' - `thetal'*`phin'/`phil')*w_obs + (`thetal'/`phil')*p ;  /*** NO PAYROLL TAX ***/
g ax_dum = 	`thetan'*w_obs + `thetal'*p ;                                     /*** IF P = R ***/

/**** ALTERNATIVE MODEL ASSUMES Ax =0 and Ay VARIES ****/

g r_alt = -(`thetan'/`thetal')*w ;
g r_alt_true = r_alt ;
g r_alt_obs = -(`thetan'/`thetal')*w_obs ;

g ay = (`phin' - `phil'*`thetan'/`thetal' )*w - p ;
g ay_true = ay ;
g ay_obs = (`phin' - `phil'*`thetan'/`thetal' )*w_obs - p ;


/************************* QUALITY OF LIFE *************************************/

g q_stm = (1 - ded*mtr)*`sharey'*p_stm - (1-mtr)*`sharew'*w_stm ;
g q = (1 - ded*mtr)*`sharey'*p - stded*stmtr*`sharey'*p_std -  (1-mtr)*`sharew'*w + stmtr*`sharew'*w_std ;
g q_std = q - q_stm ;
g q_true = q ;

g q_notax = `sharey'*p - `sharew'*w_obs  ;
g q_dum  = `sharey_dum'*p - `sharew_dum'*w_obs  ;

/**************************** DIFFERENTIAL TAXES *******************************/
/** fed : federal tax 	**/
/** st : state tax 	**/
/** stm : federal tax for state mean **/
/** option: turn off deductions **/


g dtax_fed = mtr*(`sharew'*w - ded*`sharey'*p ) ;
g dtax_st  = stmtr*(`sharew'*w_std - stded*`sharey'*p_std )  ;     
g dtax_stm = mtr*(`sharew'*w - ded*`sharey'*p_stm ) ;

g dtax = dtax_fed + dtax_st ;
g dtax_true = dtax ;

/*************8* THE TOTAL VALUE OF CITIES! *************/
g tv = `sharer'*r + dtax ;
g tv_true = tv ;

/********************* COMPONENTS DIFFERENTIAL TAXES ***************************/

/** WAGE EFFECT **/
g dtax_w_fed = mtr*(`sharew'*w) ;   
g dtax_w_st = stmtr*(`sharew'*w_std) ;   
g dtax_w = dtax_w_fed + dtax_w_st ;

/** TOTAL DEDUCTION EFFECT **/
g dtax_ded_fed = mtr*( - ded*`sharey'*p ) ;   
g dtax_ded_st = stmtr*( - stded*`sharey'*p_std ) ;   
g dtax_ded = dtax_ded_fed + dtax_ded_st ;

/*** DETERMINE THE ROUGHLY EQUIVALENT EXTRA FED TAX FROM STATE TAXES ***/

reg dtax_w dtax_w_fed [aw=weight], robust ;
scalar mtr_sca = _b[dtax_w_fed] ;
local mtr_sca = _b[dtax_w_fed] ;

g mtr2 =  mtr*(mtr_sca)  ;
local mtr2 = `mtr'*`mtr_sca'    ;

reg dtax_ded dtax_ded_fed [aw=weight], robust ;
scalar ded_sca = _b[dtax_ded_fed] ;
local ded_sca =  _b[dtax_ded_fed] ;

g ded2 = (ded*ded_sca)  ;
local ded2 = `ded'*`ded_sca' ;

noisily macro list ;

/************** INCIDENCE AND DWL CALCULATIONS FROM TOTAL DIFFERNTIAL TAXES *****************/

/*** replace "dtax" with another tax var here, e.g. nettax or dtax_fed ***/

g rhat = - dtax/(`sharer') ;
g what = dtax*(`thetal'/`thetan')/`sharer' ;
g phat = - dtax*(`phil'/`phin' - `thetal'/`thetan')*(`phin'/`sharer') ;


/********************************************************************************************/
/****************** EFFECT OF AMENITIES ON RENTS, WAGES, AND PRICES *************************/

/*** CORRELATIONS, NEEDED FOR DECOMPOSITON LATER **/

/** dummy matrix **/

replace w=w_obs ;
replace r=r_dum ;
replace dtax = dtax ;
replace tv = r_dum*`sharer' ;
replace q=q_notax ;
replace ax=ax_dum ;

noi corr p w r q ax dtax tv [aw=weight], cov ;
mat cov1 = r(C) ;

/** true matrix: uses federal taxes wages faced by firms (incl payroll tax) and inferred land rents **/

replace w=w_cost ;
replace r=r_cost ;
replace dtax = dtax_true ;
replace tv = tv_true ;
replace q=q_true ;
replace ax=ax_true ;

noi corr p w r q ax dtax tv [aw=weight], cov ;
mat cov2 = r(C) ;

replace w = w_cost ;

noi corr r w p q q_dum [aw=weight], cov ;
mat cov3 = r(C) ;

/** QOL VARIATION WITH PRICES AND WAGES **/

foreach V in q q_dum ax ax_dum r tv { ;

reg `V' p w  [aw=weight], robust nocons;
mat beta`V' = e(b) ;

replace w = w_obs ;

reg `V' p w  [aw=weight], robust nocons;
mat b_obs`V' = e(b) ;

replace w = w_cost ;


} ;

noi disp "Summary tax rate '" 1 + betaq[1,2]/`sharew' ;


/******** QUALITY OF LIFE DECOMPOSITION **************/

mat betaq_full = betaq, -betaq[1,2]/betaq[1,1] \ betaq_dum, -betaq_dum[1,2]/betaq_dum[1,1] ;
mat rownames betaq_full = q q_dum ;
mat colnames betaq_full = p w ratio;

local betaqp :  di %5.2f = betaq[1,1] ;
local betaqw :  di %05.2f = betaq[1,2] ;

local betaaxp :  di %5.2f = betaax[1,1] ;
local betaaxw :  di %5.2f = betaax[1,2] ;

local betaax_dump :  di %5.2f = betaax_dum[1,1] ;
local betaax_dumw :  di %5.2f = betaax_dum[1,2] ;

local betarp :  di %5.2f = betar[1,1] ;
local betarw :  di %05.2f = betar[1,2] ;

local betatvp :  di %05.2f = betatv[1,1] ;
local betatvw :  di %05.2f = betatv[1,2] ;



noi mat list betaq_full , format(%5.4f) ;

foreach V in q q_dum { ;

	mat `V'var = cov3["`V'","`V'"];

	mat `V'varp = (beta`V'[1,1])^2*cov3["p","p"] ;
	mat `V'varw = (beta`V'[1,2])^2*cov3["w","w"] ;
	mat `V'covwp = 2*(beta`V'[1,1])*(beta`V'[1,2])*cov3["p","w"] ;
	noi mat def `V'decomp = `V'var, `V'varp , `V'varw , `V'covwp ;
	mat colnames `V'decomp = `V'var pvar wvar pwcov ;
};

mat qdecomp_full = qdecomp \ q_dumdecomp ;
mat rownames qdecomp_full = q q_dum ;

noi mat list qdecomp_full , format(%5.4f) ;

/*** PARAMETERS OF AMENITY CAPITALIZATION ON PRICES, SOLVED VIA REGRESSION ***/


foreach V in r w p dtax tv { ;

/***** INCORRECT ***/

replace w=w_obs ;
replace r=r_dum ;
replace dtax = 0 ;
replace tv = r_dum*`sharer' ;
replace q=q_notax ;
replace ax=ax_obs ;

reg `V' q ax  [aw=weight], robust nocons;
mat b`V'1 = e(b) ;
mat rowname b`V'1 = "`V'" ;

/****** CORRECT *****/

replace w=w_cost ;
replace r=r_cost ;
replace dtax = dtax_true ;
replace tv = tv_true ;
replace q=q_true ;
replace ax=ax_true ;

reg `V' q ax [aw=weight], robust nocons;
mat b`V'2 = e(b) ;
mat rowname b`V'2 = "`V'" ;
};



/* TO GET CAPITALIZATION USING HOME-PRODUCTIVITY INSTEAD OF TRADE */

foreach V in r_alt w p dtax tv  { ;

replace w=w_obs ;
replace r_alt=r_alt_obs ;
replace dtax = 0 ;
replace tv = r_alt_obs*`sharer' ;
replace q=q_notax ;
replace ay=ay_obs ;

/*** EFFECTS ASSUMING **/

reg `V' q ay  [aw=weight], robust nocons;
mat b`V'1b = e(b) ;

replace w=w_cost ;
replace r_alt=r_alt_true ;
replace dtax = dtax_true ;
replace tv = tv_true ;
replace q=q_true ;
replace ay=ay_true ;


reg `V' q ay [aw=weight], robust nocons;
mat b`V'2b = e(b) ;


 } ;


/************* MATRICES OF COEFFICIENTS OF EFFECTS *************/

noi macro list ;

foreach N of num 1 2 { ;
	mat b`N'a =  br`N' \ bw`N' \ bp`N' \ bdtax`N' \ btv`N' ;
	mat b`N'b =  br_alt`N'b \ bw`N'b \ bp`N'b \ bdtax`N'b \ btv`N'b ;
	mat b`N' = b`N'a , b`N'b[1..5,2] ;

	mat rownames b`N' = r w p dtax val; 
	mat colnames b`N' = q ax ay ; 
	noi matlist b`N', format(%5.3f);

	mat c`N' = b`N'[1,....]*`sharer' \ b`N'[2,....]*`sharew' \ b`N'[3,....]*`sharey' \ b`N'[4,....] \ b`N'[5,....] ;
	mat d`N' = c`N'[....,1] ,  c`N'[....,2]*(1/(1-`sharey')), c`N'[....,3]*(1/`sharey') ;
	noi matlist d`N', format(%5.3f);
};


/*** COUNTERFACTUAL RENT IF THERE WERE NO TAX ***/

replace w = w_cost ;

/*** DECOMPOSITION OF PRICE VARIANCE ON QOL & TRADE-PRODUCTIVITY VARIANCE ************/
/*** DECOMPOSITION  1: NAIVE, NO TAXES IN PARAMETERS OR ESTIMATES ********************/
/*** DECOMPOSITION  2: ACTUAL, TAXES IN PARAMETERS AND ESTIMATES ***********/
/*** DECOMPOSITION  C: COUNTERFACTUAL, IF TAXES REMOVED, TAXES IN ESTIMATES, NOT PARAMETERS ***/


*set output proc ;
noi foreach V in r w p dtax tv  { ;
	foreach N in 1 2 { ;
	mat `V'var`N' = cov`N'["`V'","`V'"] ;

} ; };

*set output proc ;

mat def qrvar1 = (br1[1,1])^2*cov1[4,4]/(cov1[1,1]);



noi foreach V in r w p  dtax tv  { ;
	foreach N of num 1 2 { ;

	mat q`V'var`N' = b`V'`N'[1,1]*b`V'`N'[1,1]*cov`N'[4,4]*syminv(`V'var`N') ;
	mat a`V'var`N' = b`V'`N'[1,2]*b`V'`N'[1,2]*cov`N'[5,5]*syminv(`V'var`N') ; 
	mat cr`V'var`N' = 2*b`V'`N'[1,1]*b`V'`N'[1,2]*cov`N'[4,5]*syminv(`V'var`N') ;

	noi mat def `V'decomp`N' = `V'var`N' , q`V'var`N' , a`V'var`N', cr`V'var`N' ;
	mat colnames `V'decomp`N' = `V'var q`V'var a`V'var aq`V'cov ;
};
};


foreach V in r w p  dtax tv  { ;
	mat q`V'varc = (b`V'1[1,1])^2*cov2[4,4] ;
	mat a`V'varc = (b`V'1[1,2])^2*cov2[5,5] ;
	mat cr`V'varc = 2*(b`V'1[1,1])*(b`V'1[1,2])*cov2[4,5] ;

	mat `V'varc = q`V'varc + a`V'varc + cr`V'varc ;
	mat `V'sec = sqrt(`V'varc[1,1] ) ;

	mat q`V'varc = (b`V'1[1,1])^2*cov2[4,4]/`V'varc[1,1] ;
	mat a`V'varc = (b`V'1[1,2])^2*cov2[5,5]/`V'varc[1,1] ;
	mat cr`V'varc = 2*(b`V'1[1,1])*(b`V'1[1,2])*cov2[4,5]/`V'varc[1,1] ;

	noi mat def `V'decompc = `V'varc , q`V'varc , a`V'varc, cr`V'varc ;
	mat colnames `V'decompc = `V'var q`V'var a`V'var aq`V'cov ;

};

foreach N in 1 2 c {;

	mat def decomp`N' = rdecomp`N' \ wdecomp`N' \ pdecomp`N' \ dtaxdecomp`N' \ tvdecomp`N' ;
	mat colnames decomp`N' = var qvar avar aqcov ;
	mat rownames decomp`N' = r w p  dtax val;
	noi mat list decomp`N', format(%5.4f);
};



/***************** W DUE TO QOL VS PRODUCTIVITY *******************/

g w_q1 = bw1[1,1]*q ; 
g w_dtax = bw1[1,1]*(-dtax) ;
g w_ax1 = w - w_q - w_dtax ;

g w_q2 = bw2[1,1]*q ; 
g w_ax2 = w - w_q2 ;

*noi su w_q1 w_q2 [aw=weight] ;

/*** absolute presents difficulty, what if of different signs! **/


replace w = w_obs  ;
replace ax = ax_true ;
replace r = r_cost ;

format w p r ax q dtax tv %5.2f ;
format pop cmsapop %11.0fc ;

save temp, replace ;

/**************** LISTS OF VARIABLES FOR USE & DISPLAY **************************************/


local list1  = "w p r ax q tv " ;
local list2 = "dtax ax_dum " ;

/* LIST ESTIMATES BY REGION & DIVISION */

foreach group of var  /* region */  division   statename     { ;

	use temp, replace ;
	collapse (sum) pop, by(`group') ;
	sort `group' ;
	save temp2, replace;
	use temp, replace ;

	collapse (mean) `list1' `list2'  (count) n = w [aw=weight], by(`group') ;
	sort `group';
	merge `group' using temp2 ;
		
	/** Toggle dc=0 if Region-Division **/
	*g dc = statefip==11 ; 
	g dc=0 ;

	gsort +dc -ax   ;
	g ax_rank = _n if dc==0 ;

	gsort +dc -q   ;
	g q_rank = _n if dc==0 ;

	gsort +dc -tv   ;
	g tv_rank = _n if dc==0 ;


	gsort -tv  ;

	noi list `group' pop p w r ax q dtax tv  , clean  noobs ;
	outsheet `group'  p w r ax ax_rank q q_rank dtax tv tv_rank  using `group'_ranking.txt , noquote replace ;
	
	} ;



/*****************************************************/
/*** NOW COLLAPSE DATA BY CMSA, FOR CITY ANALYSIS  ***/
/*** DATA NO LONGER AT CMSA-STATE LEVEL, CMSA ONLY ***/
/*****************************************************/


use temp, replace;
list statename pop `list1' if cmsa==5602 ;

collapse (mean) `list1' `list2'  (count) n = w [aw=weight], by(cmsa) ;

merge 1:1 cmsa using amenities_cmsa2000 ;

list pop `list1' if cmsa==5602 ;

drop pop ;
duplicates drop cmsa, force ;


/*** AMENITY REGRESSIONS ***/

g lpop = ln(cmsapop) ;
g linv_water = ln(inv_water) ;

/** Z-score WRLURI and give value of zero to missing observations **/
replace wrluri = 0 if wrluri ==. ;
su wrluri [aw=cmsapop] if cmsa<10000;
replace wrluri = (wrluri-r(mean) ) / r(sd) ;

g rshare = r*`sharer' ;

foreach V in p w ax q rshare dtax tv { ;
	qui reg  `V' lpop sch_cdeg wrluri hdd65 cdd65 sun_a linv_water slope_pct latitude [aw=cmsapop] if cmsa<10000, robust ;
	mat beta`V'1 = e(b);
	estimates store `V'1 ; 
	} ;


noi su lpop sch_cdeg wrluri hdd65 cdd65 sun_a linv_water slope_pct latitude [aw=cmsapop] if cmsa<10000 & e(sample) ;
noi estimates table p1 w1 ax1 q1 tv1 rshare1 dtax1 ,
	b(%5.3f) star(.1 .05 .01) stats(r2 N) stf(%4.2f) ;
noi estimates table p1 w1 ax1 q1 tv1 rshare1 dtax1 ,
	b(%5.3f) se(%5.3f) stats(r2 N) stf(%4.2f) ;

	*noi mat list betarcr1 , format(%5.3f); 


*set output error ;

rename cmsaname longname ;
replace longname = "non-metropolitan areas, " + shortname if longname==""; 

replace shortnam = "Cape Cod" if cmsa==740 ;
replace longname = "Barnstable-Yarmouth (Cape Cod), MA" if cmsa==740 ;

replace shortnam = "Monterey" if cmsa==7120 ;
replace longname = "Salinas (Monterey-Carmel), CA" if cmsa==7120 ;

replace shortnam = "Washington-Baltimore" if cmsa==8872 ;


g weight = cmsapop ;

g nonmsa = length(shortname)==2 ;
g name = shortname ;

g type = 1 if inrange(cmsapop,1,499999);
replace type = 2 if inrange(cmsapop,500000,1499999);
replace type = 3 if inrange(cmsapop,1500000,4999999);
replace type = 4 if inrange(cmsapop,5000000,100000000);
replace type = 0 if cmsa>10000  ;

la def typelab 
4 "MSA, Pop > 5 Million" 
3 "MSA, Pop 1.5-4.9 Million"
2 "MSA, Pop 0.5-1.4 Million"
1 "MSA, Pop < 0.5 Million"
0 "Non-MSA areas" ;
la val type typelab ;

g nonmetro = type==0 ;

/*** SAVE USEFUL DATA SET ***/

save wp_tax_cmsa2000 , replace ;

save temp, replace ;

/* RESULTS BY METRO SIZE */

collapse (sum) cmsapop, by(type) ;
sort type ;
save temp2, replace;
use temp, replace ;

collapse (mean) `list1' `list2' (count) n = w [aw=weight], by(type) ;
sort type;
merge type using temp2 ;
gsort -type;

noisily list type  cmsapop p w r ax q dtax tv , clean noobs ;


use temp, replace ;

/*** TABLE OF QOL OF TOP CITIES AND BIG CITIES **/

gsort +nonmetro -ax   ;
g ax_rank = _n if nonmetro==0 ;
noi list shortname if _n<=20 , clean noobs;

gsort +nonmetro -q   ;
g q_rank = _n if nonmetro==0 ;
noi list shortname if _n<=20 , clean noobs;

gsort +nonmetro -tv   ;
g tv_rank = _n if nonmetro==0 ;
noi list shortname if _n<=20 , clean noobs;


gsort -tv ;

/*** FULL LIST **/
gsort -tv ;
outsheet cmsa longname cmsapop state_main  p w r ax ax_rank q q_rank dtax tv tv_rank  using ranking.txt , noquote replace ;

noi list longname cmsapop p w r ax q dtax tv , clean noobs ;

*list shortname state_main cmsapop w p r ax q dtax tv if (cmsapop>2300000 & nonmetro==0) | (cmsapop>1000000 & nonmetro==0 & tv<-.01)  | inlist(tv_rank,1,2,3,4,5,276) , clean noobs;

/** SHORTER LIST **/

list shortname state_main cmsapop p w r ax q dtax tv if (cmsapop>3000000 & nonmetro==0) | (nonmetro==0 & (cmsapop-10800000*tv)>2250000)  | inlist(tv_rank,1,2,3,276) , clean noobs;

set output error ;

/* us std dev & abs dev */

use temp, replace ;

noi disp "FOR STANDARD DEVIATIONS" ;

noisily su `list1' dtax [aw=weight];

*noisily su dtax_w dtax_index  dtax what phat rhat nhat [aw=weight];

use temp, replace ;


set output error ;

*set output proc ;

/************************************/
/***                              ***/
/***      GRAPHING SECTION        ***/
/***                              ***/
/************************************/

/**** STUFF FOR GRAPHS ****/


/**** MARKERS ****/


for XX in any p w  r q ax ax_dum  tv:

g XX0 = XX if type==0\
g XX1 = XX if type==1\
g XX2 = XX if type==2\
g XX3 = XX if type==3\
g XX4 = XX if type==4\

la var XX1 "<0.5 Million"\
la var XX2 "0.5-1.5 Million"\
la var XX3 "1.5-5.0 Million"\
la var XX4 ">5.0 Million"\
la var XX0 "Non-Metro Areas";


local sharey = round(`sharey',.01);
local sharew = round(`sharew',.01);
local sharer = round(`sharer',.01);
local elastt = round(`elastt',.01);
local elastyp_c=round(`elastyp_c',.01);

/*** MSA NAMES ***/

g byte seename = inlist(cmsa,200,520,640,680,740,840,1040,1122,1602,1642,1840,1922,2040,2082,2162,2320,
	                                    2620,2670,2700,2710,2750,2880,2995,3040,3280,3320,3362,3605,3710,3810,
										3850,4120,4472,4880,4890,4890,4992,5120,5140,5330,5345,5360,
										5560,5602,5720,5790,5880,5960,6162,6200,6280,6442,6580,6720,6922,7040,7120,7240,7320,
										7362,7460,7480,7490,7510,7602,7760,8000,8080,8160,8280,8520,8872,
						                 9200,9360,999901,999902,999904,999908,999912,999915,999921,999928,999930,999932,999938,999940,
										 999941,999946,999949,999950) ;
replace seename =1 if (cmsapop>3000000 & nonmetro==0) | (nonmetro==0 & (cmsapop-10800000*tv)>2220000)  ;

for N in num 0 1 2 3 4:
	g nameN = "" \
	replace nameN = name if seename \
	g nameNx = nameN \
	replace nameNx = "" if nameN=="" \
	replace nameNx = "" if (mod(_n,2)== 0 & inrange(p,-.3,.3)) & N<4 ; 
	

/*** FOR MAKING SMOOTH LINES ***/

for V in any p w r q ax :
su V, d \
scalar minV = r(min)-.0001 \
scalar maxV = r(max)+.0001 ;

scalar list ;

*append using p_empty ;
sort p ;

**** HYPOTHETICAL INDIFFERENCE AND ISOCOST CURVES ;

/**  Mobility Condition USING REGRESSION COEFFS FOR TAXES **/

g v1 = -b_obsq[1,2]/b_obsq[1,1]*w  ;
local slopev1 : di %5.3f = b_obsq[1,2]/b_obsq[1,1] ;
la var v1 "Avg Mobility Cond: slope = `slopev1'" ;


/** ISOCOST **/

g c1 = -b_obsax[1,2]/b_obsax[1,1]*w  ;
local slopec1  : di %5.2f =  -b_obsax[1,2]/b_obsax[1,1];
la var c1 "Avg Zero-Profit Cond: slope = `slopec1'" ;


g c1_dum = -w*`thetan'/`thetal'  ;
local slopec1_dum : di %5.2f =  -`thetan'/`thetal' ;
la var c1_dum "Unadjusted Avg Zero-Profit Cond: slope = `slopec1_dum'" ;


*** EMPIRICAL  FIT ;

/** P ON W **/

reg p w [aw=weight] ;
predict vfit1 ;
estimates store pw0 ;
scalar fitb = _b[w]  ;
scalar seb = _se[w]  ;
local fitb  : di %05.2f =  fitb ;
local seb : di %05.2f = seb ;
la var vfit1 "Regression Line: slope= `fitb' (s.e. `seb') " ;


*** EMPIRICAL  FIT of R on P ;

reg r p [aw=weight], robust ;
predict rfit1 ;
est store r1 ;
scalar fitb = _b[p] ;
scalar sefitb = _se[p] ;
local fitb : di %05.2f = fitb ;
local sefitb : di %05.2f = sefitb ;

la var rfit1 "Linear Fit: slope = `fitb' (s.e. `sefitb') "	;



*** EMPIRICAL  FIT of AX on W ;

reg ax w [aw=weight], robust ;
predict axfit1 ;
est store ax1 ;
scalar fitb = _b[w] ;
scalar sefitb = _se[w] ;
local fitb : di %05.2f = fitb ;
local sefitb : di %05.2f = sefitb ;

la var axfit1 "Linear Fit: slope = `fitb' (s.e. `sefitb') "	;

*** EMPIRICAL  FIT of AX on UNADJUSTED AX  ;

reg ax ax_dum [aw=weight], robust ;
predict axfit2 ;	
est store ax2 ;
scalar fitb = _b[ax_dum] ;
scalar sefitb = _se[ax_dum] ;
local fitb : di %05.2f = fitb ;
local sefitb : di %05.2f = sefitb ;

la var axfit2 "Linear Fit: slope = `fitb' (s.e. `sefitb') "	;

/** RENT WITH CONSTANT WAGES **/

g rpline = p/`phil' ;
local sloper : di %5.2f = 1/`phil' ;
la var rpline "Inferred Rent with Avg Wage: slope = `sloper'" ;

/** PROCUCTIVITY WITH CONSTANT RENTS  OR PRICES **/

g axdiag = ax_dum ;
la var axdiag "Diagonal, slope = 1.0" ;


/** ISORENT CURVES **/

g ir = -b_obsr[1,2]/b_obsr[1,1]*w ;
local slopeir : di %5.2f = -b_obsr[1,2]/b_obsr[1,1];
la var ir "Avg Iso-Rent Curve: slope = `slopeir'" ;

/** ISOVALUE CURVES **/

g itv = -b_obstv[1,2]/b_obstv[1,1]*w ;
local slopeitv : di %05.2f =  -b_obstv[1,2]/b_obstv[1,1];
la var itv "Avg Iso-Value Curve: slope = `slopeitv'" ;

scalar slopeir1 = -br2[1,2]/ br2[1,1] ;
local slopeir1 : di %5.2f =  slopeir1 ;
g ir1 = ax * slopeir1 ;
la var ir1 "Iso-Land-Rent Curve: slope = `slopeir1'" ;

scalar slopeiw1 = - bw2[1,2]/ bw2[1,1] ;
local slopeiw1 : di %5.2f = slopeiw1;
g iw1 = ax * slopeiw1 ;
la var iw1 "Iso-Wage Curve: slope = `slopeiw1'" ;

scalar slopeip1 = - bp2[1,2]/ bp2[1,1] ;
local slopeip1 : di %05.2f =  slopeip1 ;
g ip1 = ax * slopeip1 ;
la var ip1 "Iso-Housing-Cost Curve: slope = `slopeip1'" ;

scalar slopeitv1 = - btv2[1,2]/ btv2[1,1] ;
local slopeitv1 : di %05.2f = slopeitv1 ;
g itv1 = ax * slopeitv1 ;
la var itv1 "Iso-Value Curve: slope = `slopeitv1'" ;


**** TRIM EXCESS IN GRAPH ;
keep if inrange(p,minp,maxp) ;

for V in var v1* c1* :
	replace V=. if ~(inrange(V,minp,.9)) ;

for V in var  rpline rfit1 :
	replace V=. if ~(inrange(V,minr,maxr)) ;

for V in var  ir1 iw1 ip1 itv1 :
	replace V=. if ~(inrange(V,minq,maxq)) ;

for V in var  axdiag axfit* :
	replace V=. if ~(inrange(V,minax,maxax)) ;


*keep if inrange(p,minp,maxp) ;

/********************************************************************************************/
/******************************* LET THE GRAPHS BEGIN!! *************************************/
/********************************************************************************************/

/*** GRAPH PRICES  VERSUS WAGES ***/

local aspect1 = (maxp-minp)/(maxw-minw)*`sharey'/(`sharex'+`sharet') ;

noi disp `aspect1' ;

*local aspect1 = 1.22 ;

replace c1=. if c1>.75 ;

/** Prices vs. Wages with Mobility condition, ZPC, and land-rent lines ***/

noisily twoway (scatter p4 p3 p2 p1 p0 w, 
	msymbol(Oh Oh oh o x)
	msize(medium small small tiny small)
	mlwidth(vthin vthin vthin medium vthin)
	mcolor(black black black black black)
	mlabel(name4 name3 name2 name1 name0)
	mlabcolor(black black black black black) 
	mlabsize(2 2 2 2 2)
	mlabpos(9 9 9 9 9)
/*	aspectratio(`aspect1' ) */
	ylabel(-.5 (.1) .8, grid labsize(2) format(%5.1f))
	xlabel(-.2 (.1) .2, grid labsize(2) format(%5.1f))
	l2title("Log Housing-Cost Differential", size(2))
	legend(order(- "METRO POP" 1 6 2 3 7 4 5 8  9  ) holes(10 11) bmargin(zero) region(lcolor(none) color(white))  cols(3) size(2)  span ) 
	xtitle("Log Wage Differential", size(2))
	ti("Figure 1: Housing Costs versus Wage Levels across Metro Areas, 2000", size(3)) 
	 xsize(7.5) ysize(10)  
	 /* xsize(9.5) ysize(7.5) */
	saving(pw22000.gph, replace)  name(pw2, replace) 
	yline(0, lpat(solid) lcolor(gs12) ) xline(0, lpat(dash) lcolor(gs12))
	graphregion(fcolor(white) icolor(white) color(white))
	note( "Data from 2000 Public Use Microdata Files for Individuals from the U.S. Census (Ruggles et al. 2004)."
		"Log wage (for full-time workers) and housing-cost (for home-owners and renters) differentials from dummy"
		"variables in regressions controlling for worker and housing charactersitics.  Metro areas use 1999"
		"Consolidated Metropolitan Statistcal Area definitions, which combine Primary MSAs; only first city,"
		"named.  Non-Metro areas of states grouped together. See Appendix Table A1 for full list and values."	, size(2) span )	
	)

	( line  ir c1 v1  itv  w, 
	lpat(dash_dot  shortdash longdash "_..." ) 
	lwidth(medium medium medium medium ) 
	lcolor(gs6 gs2 gs4 gs0 )
	 sort(w v1) c(l l l l )  )
	;


/** LAND RENTS VERSUS HOUSING COSTS **/

*set output proc;

local aspect2 = (maxr-minr)/(maxp-minp)*`sharer'/(`sharey') ;

g diag_p = p ;
la var diag_p "Diagonal" ;


sort p ;
noisily twoway (scatter r4 r3 r2 r1 r0 p, 
	msymbol(Oh Oh oh o x)
	msize(medium small small tiny small )
	mlwidth(vthin vthin vthin medium vthin)
	mcolor(black black black black black)
	mlabcolor(black black black black black) 
	mlabel(name4x name3x name2x name1x name0x)
	mlabsize(2 2 2 2 2)
	mlabpos(9 9 9 9 9) 	 
	ylabel(-2 (.5) 3, grid labsize(2) format(%5.1f))
	xlabel(-.5 (.5) .5, grid labsize(2) format(%5.1f))
	aspectratio(`aspect2', placement() )
	legend(order(6 7 8) bmargin(zero) region(lcolor(none) color(white))  rows(3) size(2)  span ) 
	xtitle("Observed Housing-Cost Differential (p)", size(2.5) )
	l2title("Inferred Land-Rent Differential (r)", size(2.5) )	
	ti("Figure 2: Housing Costs and Inferred Land Rents", size(3) span ) 
	graphregion(fcolor(white) icolor(white) color(white))
	xsize(6.5) ysize(4.5) 
	yline(0, lpat(solid) lwidth(thin) lcolor(gs10) ) xline(0, lwidth(thin) lpat(solid) lcolor(gs10))
	note("Approximating, land rent is inferred as `betarp' times log housing cost minus `betarw' times log wage."
		, size(2) ) 
	saving(rp.gph, replace) name(rp, replace) 
	)
	( line rpline diag_p p, 
	lpat( dash solid ) 
	lwidth( medium thin ) 
	lcolor(gs6 black )
	 sort(p) c(l )  )
	;
;

more ;

 /**** PRODUCTIVITY NEW VS NAIVE-REDUCED MODEL ***/
 
la var ax_dum "Diagonal" ;
noisily twoway (scatter ax4 ax3 ax2 ax1 ax0 ax_dum if inrange(ax_dum,0,.18), 
	msymbol(Oh Oh oh o x)
	msize(medium small small tiny small )
	mlwidth(vthin vthin vthin medium vthin)
	mcolor(black black black black black )
	mlabel(name name name name1 name0)
	mlabcolor(black black black black black)
	mlabsize(2 2 2 2 2)
	mlabpos(9 9 9 9 9) 
	aspectratio(1, placement() )
	xlabel(0 (.05) .1, grid labsize(2) format(%5.2f) )
	xmtick(0 (.01) .12,  tlw(vthin) )
	ymtick(0 (.01) .15, tlw(vthin)) 
	ylabel(0 (.05) .15, grid labsize(2) format(%5.2f))
	legend(order(6) bmargin(zero) region(lcolor(none) color(white))  rows(3) size(2)  span ) 
	l2title("Trade-Productivity (Ax) from Full Model", size(2.5) )
	xtitle("Productivity from Reduced Model", size(2.5) )
	ti("Figure 3: Trade-Productivity Estimates Compared", size(3) span )  
	xsize(6.5) ysize(4.5) 
	graphregion(fcolor(white) icolor(white) color(white))
	saving(ax_prod, replace) name(ax_prod, replace) 
note("Approximating, trade-productivity is estimated as `betaaxp' times log housing cost plus `betaaxw' times log wage."
"In the reduced model, it is estimated as `betaax_dump' times log housing cost plus `betaax_dumw' times log wage." 
		, size(2)  ) 
	)

	( line ax_dum ax_dum if inrange(ax_dum,0,.15), 
	lpat(solid dot dash ) 
	lwidth(thin medthick medium) 
	lcolor(black gs8 gs12  )
	 sort(ax_dum) c(l)  ) 
 ;

  

/** QUALITY OF LIFE AND PRODUCTIVITY  **/
/** second aspect ratio reflects after taxes **/

local aspect4 = (maxq-minq)/(maxax-minax)/(`sharex'+`sharet') ;
*local aspect4 = (maxq-minq)/(maxax-minax)* br2[1,1]/br2[1,2] ;

noi disp `aspect4' ;

*local aspect4 = 1.475 ;

sort q ;
noisily twoway (scatter q4 q3 q2 q1 q0 ax, 
	msymbol(Oh Oh oh o x)
	msize(medium small small tiny small)
	mlwidth(vthin vthin vthin medium vthin)
	mcolor(black black black black black)
	mlabcolor(black black black black black) 
	mlabel(name4 name3 name2 name1 name0)
	mlabsize(2 2 2 2 2)
	mlabpos(9 9 9 9 9) 	
	ylabel(-.1 -.05 0 .05 .1 .15 .20, grid labsize(2) format(%5.2f))
	xlabel(-.234375 -.15625 -.078125 0 .078125 .15625 .234375, grid labsize(2) format(%5.3f))
	aspectratio(`aspect4', placement() ) 
	legend(order(- "METRO POP" 1 6 2 3 7 4 5 8  - - 9  ) bmargin(zero) region(lcolor(none) color(white))  cols(3) size(2)  span ) 
	xtitle("Relative Trade-Productivity (Ax)", size(2) )
	l2title("Relative Quality of Life (Q)", size(2) )
	ti("Figure 4: Estimated Trade-Productivity and Quality of Life, 2000", size(3) span ) 
/*	t2("Metropolitan Statistical Areas (MSAs) and Non-Metro States", size(2.5)) 	*/
	graphregion(fcolor(white) icolor(white) color(white))

	xsize(7.5) ysize(6.5) 
	/* xsize(6.5) ysize(9) */
	note("Approximating, quality of life is estimated as `betaqp' times log housing cost minus `betaqw' times log wage."
		"Axes are scaled for productivity and quality-of-life differences to be of equal value."
		, size(2) span ) 
/*	note("Relative productivity and quality-of-life estimated."
		"Calibration: sy=`sharey', sT=`sharet', thetaL=`thetal', thetaN=`thetan', phiL=`phil'. phiN=`phin', elast_y,p=`elastyp_c', tax rate=`mtr', deduction=`ded' "
		, size(2) span ) */
	xline(0, lpat(shortdash) lcolor(gs2) ) yline(0, lpat(longdash) lcolor(gs4) ) 
	saving(qa2000.gph, replace) 
	name(qa, replace) 
	)
	( line  iw1 ip1 ir1 itv1 ax, 
	lpat( dash solid dash_dot  "_..." ) 
	lwidth(  medium medium medium medium) 
	lcolor( gs12 gs12 gs6 gs0 )
	 sort(ax) c(l l l l)  )
	;


/****** AMENITIES AND POPULATION SIZE ****/

g lpop_sq = lpop^2 ;

la var cmsapop "Population of Metropolitan Statistical Area";

/****** PRODUCTIVITY AND POPULATION *****/

reg ax lpop [aw=weight] if type>0, robust ;
estimates store axlpop ;
mat beta = e(b) ;
mat var = e(V) ;
scalar b = beta[1,1] ;
scalar seb = sqrt(var[1,1]) ;
local fitb : di %05.3f = beta[1,1] ;
local fitseb : di %05.3f = seb  ; 
predict popfitax if type>0 ;
local noteax = "Slope of Regression Line = `fitb' (`fitseb') " ;
la var popfitax "Log-Linear Fit: Slope =  = `fitb' (`fitseb')" ;

reg ax lpop lpop_sq [aw=weight] if type>0, robust ;
predict popfitax_2 if type>0 ;
la var popfitax_2 "Quadratic Fit " ;
estimates store axlpop2 ;

noisily twoway (scatter ax4 ax3 ax2 ax1 cmsapop , 
	msymbol(Oh Oh oh o x)
	msize(medium small small tiny )
	mlwidth(vthin vthin vthin medium)
	mcolor(black black black black)
	mlabel(name4 name3 name2 name1)
	mlabcolor(black black black black)
	mlabsize(2 2 2 2)
	mlabpos(9 9 9 9) 
	xscale(log) 	
	xlabel(125000 250000 500000 1000000 2000000 4000000 8000000 16000000, grid labsize(2) )
	xmtick(125000 (125000) 20000000,  tlw(vthin) )
	ymtick(-.25 (.01) .3, tlw(vthin)) 
	ylabel(-.2 (.1) .3, grid labsize(2) format(%5.1f))
	legend(order(5 6) rows(1) nobox bmargin(zero) region(lcolor(none) color(white))  size(2)  span) 	
	ti("Figure 5: Trade-Productivity and Population Size", size(3) ) 
	l2title("Relative Trade-Productivity (Ax)", size(2) )
	xtitle("Population of Metropolitan Statistical Area", size(2) )
	graphregion(fcolor(white) icolor(white) color(white))
	xsize(7.5) ysize(4.5) 
/*	note("`noteax'" , size(2) span) */
	saving(popax, replace)  
	name(popax, replace) 
)

	( line  popfitax popfitax_2 cmsapop, 
	lpat(dash shortdash) 
	lwidth(medium medium) 
	lcolor(gs2 gs4)
	 sort(cmsapop) c(l)  ) 
 ;

 

/****** TOTAL VALUE AND POPULATION *****/

reg tv lpop [aw=weight] if type>0, robust ;
estimates store tvlpop ;
mat beta = e(b) ;
mat var = e(V) ;
scalar b = beta[1,1] ;
scalar seb = sqrt(var[1,1]) ;
local fitb : di %05.3f = b ;
local fitseb :  di %05.3f = seb ; 
predict popfittv if type>0 ;
local notetv = "Slope of Regression Line = `fitb' (`fitseb') " ;
la var popfittv "Log-Linear Fit: Slope =  = `fitb' (`fitseb')" ;

reg tv lpop lpop_sq [aw=weight] if type>0, robust ;
predict popfittv_2 if type>0 ;
la var popfittv_2 "Quadratic Fit " ;
estimates store tvlpop2 ;

noisily twoway (scatter tv4 tv3 tv2 tv1 cmsapop , 
	msymbol(Oh Oh oh o x)
	msize(medium small small tiny )
	mlwidth(vthin vthin vthin medium)
	mcolor(black black black black)
	mlabel(name4 name3 name2 name1)
	mlabcolor(black black black black)
	mlabsize(2 2 2 2)
	mlabpos(9 9 9 9) 
	xscale(log) 	
	xlabel(125000 250000 500000 1000000 2000000 4000000 8000000 16000000, grid labsize(2) )
	xmtick(125000 (125000) 20000000,  tlw(vthin) )
	ymtick(-.25 (.01) .31, tlw(vthin)) 
	ylabel(-.2 (.1) .3, grid labsize(2) format(%5.1f))
	legend(order(5 6) rows(1) nobox bmargin(zero) region(lcolor(none) color(white) )  size(2)  span) 	
	ti("Figure 6: Total Value of Amenities and Population Size", size(3) ) 
	l2title("Total Amenity Value", size(2) )
	xtitle("Population of Metropolitan Statistical Area", size(2) )
	graphregion(fcolor(white) icolor(white) lcolor(white) ilcolor(white) color(white))
	xsize(7.5) ysize(4.5) 
/*	note("`notetv'" , size(2) span) */
	saving(poptv, replace)  
	name(poptv, replace) 
)

	( line  popfittv popfittv_2 cmsapop, 
	lpat(dash shortdash) 
	lwidth(medium medium) 
	lcolor(gs2 gs4)
	 sort(cmsapop) c(l)  ) 
 ;

 
