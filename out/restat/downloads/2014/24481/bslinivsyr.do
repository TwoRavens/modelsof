 /*	THIS ESTIMATES DEMAND FOR OILS USING HAUSMAN INSTRUMENTS.  IN THIS VARIANT, EACH PRICE IS REGRESSED ON ALL OTHER REGIONS PRICES IN THE FIRST STAGE.  THERE COEFFICIENTS ON EACH REGION'S PRICE IS UNCONSTRAINED*/
set more off
#delimit;
cap log close;
*log using check, replace;
clear all;
set matsize 1000;
*set mem 10000m;
set mem 1200m;
*local path "u:/user11/mw562_rs/my documents/restat/analysis_data";
local path "c:/data/restat_12_9/analysis_data";
local estimator "newey2";
local ivestimator "newey2";
local lags "lag(4)";


local opt "se 3aster bd(2) td(2)";
*sysdir set PERSONAL "u:/user11/mw562_rs/my documents/ado";
di "`path'";

do "c:/data/restat_12_9/programs/csolve_do/csolve";
do "c:/data/restat_12_9/programs/csolve_do/callf";
do "c:/data/restat_12_9/programs/csolve_do/callf_setup";
do "c:/data/restat_12_9/programs/csolve_do/syraids2";

set seed 10161978;
use "`path'/syrmaster";
sort REGION BRAND year month day;
bysort REGION BRAND: gen count=_n;


local nbrands1=5;
local nbrands2=4;
local nbrands=9;
local nregions=47;
local list1 "AUNT_JEMIMA HUNGRY_JACK LOG_CABIN MRS_BUTTERWORTH PRIVATE_LABEL";
local list2 "AUNT_JEMIMA_LIGHT JACK_LITE LOG_CABIN_LIGHT MRS_B_LITE";



sort BRAND REGION t;
by BRAND REGION: gen T=_n;

sort T REGION BRAND;
/*separate id for each brand/region combo*/
bysort T: gen id=_n;


/*make list of log price interacted with brand dummies for each segment. exclude interaction with pl because of adding up.  same for instruments*/
foreach y of local list1{;
	forval x=1/4{;
		local reglist1 "`reglist1' lpreg_`x'_`y'";
		local ivreglist1 "`ivreglist1' ivlpreg_`x'_`y'";
	};
};

foreach y of local list2{;
	forval x=1/3{;
		local reglist2 "`reglist2' lplight_`x'_`y'";
		local ivreglist2 "`ivreglist2' ivlplight_`x'_`y'";
	};
};


/*this creates 47 region dummies, one for each of the 5 share equations*/
forval x=2/47{;
	forval y=1/5{;
		gen fe1`x'_`y'=reg`x'*bra1`y';
	};
};
forval x=2/47{;
	forval y=1/4{;
		gen fe2`x'_`y'=reg`x'*bra2`y';
	};
};

forval x=2/47{;
	forval y=1/4{;
		local regionxbrand1 "`regionxbrand1' fe1`x'_`y'";
	};
};

forval x=2/47{;
	forval y=1/3{;
		local regionxbrand2 "`regionxbrand2' fe2`x'_`y'";
	};
};




qui tab month, gen(M);
qui tab year, gen(year);


forval x=1/8{;
	forval y=1/5{;		
		gen M1`x'b`y'=M`x'*bra1`y';
	};
};

forval x=1/8{;
	forval y=1/4{;		
		gen M2`x'b`y'=M`x'*bra2`y';
	};
};

forval x=1/4{;
	gen ivlaidpreg`x'=ivlaidpreg*bra1`x';
};

forval x=1/3{;
	gen ivlaidplight`x'=ivlaidplight*bra2`x';
};



/*this creates month dummies for each of 4 share equations*/
forval x=1/8{;
	forval y=1/4{;
		local Mlist1 "`Mlist1' M1`x'b`y'";
	};
};

forval x=1/8{;
	forval y=1/3{;
		local Mlist2 "`Mlist2' M2`x'b`y'";
	};
};


/*this creates time trends for each of 4 share equations*/
forval x=1/5{;
	gen count1`x'=count*bra1`x';
};

forval x=1/4{;
	gen count2`x'=count*bra2`x';
};



/*UNCONSTRAINED MODEL*/

encode REGION, gen(reg);
tsset id count;
qui compress;

/*HERE ARE THE AIDS OLS ESTIMATES FOR THE REGULAR SEGMENT*/
`estimator' share laidpreg1 laidpreg2 laidpreg3 laidpreg4 `reglist1' `Mlist1' `regionxbrand1' bra11-bra14 count11-count14 if BRAND~="PRIVATE LABEL" & nest==1, nocon `lags';
 

matrix aidB=e(b);
matrix aidVC=e(V);
forval x=1/4{;
	scalar b`x'=_coef[laidpreg`x'];
};

/*recover Private Label share equation parameters through adding up restrictions of AIDS model*/
scalar b5=-b1-b2-b3-b4;
#delimit;
forval x=1/4{;
	foreach y of local list1{;
		scalar g`x'p`y'=_coef[lpreg_`x'_`y'];
	};
};
foreach y of local list1{;
	scalar g5p`y'=-_coef[lpreg_1_`y']-_coef[lpreg_2_`y']-_coef[lpreg_3_`y']-_coef[lpreg_4_`y'];
};
forval x=1/5{;
	scalar g`x'p1=g`x'pAUNT_JEMIMA;
	scalar g`x'p2=g`x'pHUNGRY_JACK;
	scalar g`x'p3=g`x'pLOG_CABIN;
	scalar g`x'p4=g`x'pMRS_BUTTERWORTH;
	scalar g`x'p5=g`x'pPRIVATE_LABEL;
};

forval x=1/`nbrands1'{;
	sum share if bra1`x'==1;
	scalar s1`x'=r(mean);
};




/*HERE ARE THE IV AIDS ESTIMATES FOR THE REGULAR SEGMENT*/
`ivestimator' share `Mlist1' `regionxbrand1' bra11-bra14 count11-count14  (laidpreg1 laidpreg2 laidpreg3 laidpreg4 `reglist1'=ivlaidpreg1 ivlaidpreg2 ivlaidpreg3 ivlaidpreg4 `ivreglist1') if BRAND~="PRIVATE LABEL" & nest==1, nocon `lags';


matrix ivaidB=e(b);
matrix ivaidVC=e(V);
forval x=1/4{;
	scalar ivb`x'=_coef[laidpreg`x'];
};

/*recover Private Label share equation parameters through adding up restrictions of AIDS model*/
scalar ivb5=-ivb1-ivb2-ivb3-ivb4;
#delimit;
forval x=1/4{;
	foreach y of local list1{;
		scalar ivg`x'p`y'=_coef[lpreg_`x'_`y'];
	};
};
foreach y of local list1{;
	scalar ivg5p`y'=-_coef[lpreg_1_`y']-_coef[lpreg_2_`y']-_coef[lpreg_3_`y']-_coef[lpreg_4_`y'];
};

forval x=1/5{;
	scalar ivg`x'p1=ivg`x'pAUNT_JEMIMA;
	scalar ivg`x'p2=ivg`x'pHUNGRY_JACK;
	scalar ivg`x'p3=ivg`x'pLOG_CABIN;
	scalar ivg`x'p4=ivg`x'pMRS_BUTTERWORTH;
	scalar ivg`x'p5=ivg`x'pPRIVATE_LABEL;
};




/*HERE ARE THE OLS AIDS ESTIMATES FOR THE LIGHT SEGMENT*/
`estimator' share laidplight1 laidplight2 laidplight3 `reglist2' `Mlist2' `regionxbrand2' bra21-bra23 count21-count23 if BRAND~="MRS_B_LITE" & nest==2, nocon `lags';
matrix aidB2=e(b);
matrix aidVC2=e(V);
forval x=1/3{;
	scalar b2`x'=_coef[laidplight`x'];
};

/*recover Private Label share equation parameters through adding up restrictions of AIDS model*/
scalar b24=-b21-b22-b23;
#delimit;
forval x=1/3{;
	foreach y of local list2{;
		scalar g2`x'p`y'=_coef[lplight_`x'_`y'];
	};
};
foreach y of local list2{;
	scalar g24p`y'=-_coef[lplight_1_`y']-_coef[lplight_2_`y']-_coef[lplight_3_`y'];
};

forval x=1/4{;
	scalar g2`x'p1=g2`x'pAUNT_JEMIMA_LIGHT;
	scalar g2`x'p2=g2`x'pJACK_LITE;
	scalar g2`x'p3=g2`x'pLOG_CABIN_LIGHT;
	scalar g2`x'p4=g2`x'pMRS_B_LITE;
};

forval x=1/`nbrands2'{;
	sum share if bra2`x'==1;
	scalar s2`x'=r(mean);
};

/*HERE ARE THE AIDS IV ESTIMATES FOR THE LIGHT SEGMENT*/
`ivestimator' share `Mlist2' `regionxbrand2' bra21-bra23 count21-count23 (laidplight1 laidplight2 laidplight3 `reglist2'=ivlaidplight1 ivlaidplight2 ivlaidplight3`ivreglist2' ) /*reg1-reg47*/  if BRAND~="MRS_B_LITE" & nest==2, nocon `lags';

matrix ivaidB2=e(b);
matrix ivaidVC2=e(V);
forval x=1/3{;
	scalar ivb2`x'=_coef[laidplight`x'];
};

/*recover Private Label share equation parameters through adding up restrictions of AIDS model*/
scalar ivb24=-ivb21-ivb22-ivb23;
#delimit;
forval x=1/3{;
	foreach y of local list2{;
		scalar ivg2`x'p`y'=_coef[lplight_`x'_`y'];
	};
};
foreach y of local list2{;
	scalar ivg24p`y'=-_coef[lplight_1_`y']-_coef[lplight_2_`y']-_coef[lplight_3_`y'];
};

forval x=1/4{;
	scalar ivg2`x'p1=ivg2`x'pAUNT_JEMIMA_LIGHT;
	scalar ivg2`x'p2=ivg2`x'pJACK_LITE;
	scalar ivg2`x'p3=ivg2`x'pLOG_CABIN_LIGHT;
	scalar ivg2`x'p4=ivg2`x'pMRS_B_LITE;
};




gen wvol=vol/POP;
forval x=1/5{;
	gen wexpreg`x'=expreg`x'/POP;
};

foreach y of local list1{;
	forval x=1/5{;
		local linplistreg "`linplistreg' preg_`x'_`y'";
	};
};
foreach y of local list1{;
	forval x=1/5{;
		local ivlinplistreg "`ivlinplistreg' ivpreg_`x'_`y'";
	};
};

forval x=2/47{;
	forval y=1/5{;
		local lregionxbrand "`lregionxbrand' fe1`x'_`y'";
	};
};

local lMlist1 "`Mlist1' M11b5 M12b5 M13b5 M14b5 M15b5 M16b5 M17b5 M18b5";

/*OLS estimates of linear demand, regular segment*/
`estimator' wvol count11-count15 bra11-bra15 `lMlist1' `lregionxbrand' wexpreg1-wexpreg5 `linplistreg' if nest==1, nocon `lags';  

matrix linB=e(b);
matrix linVC=e(V);
#delimit;
/*p_i_j is coefficient on price j in equation i*/
forval x=1/5{;
	scalar p_`x'_1=_coef[preg_`x'_AUNT_JEMIMA];
	scalar p_`x'_2=_coef[preg_`x'_HUNGRY_JACK];
	scalar p_`x'_3=_coef[preg_`x'_LOG_CABIN];
	scalar p_`x'_4=_coef[preg_`x'_MRS_BUTTERWORTH];
	scalar p_`x'_5=_coef[preg_`x'_PRIVATE_LABEL];
};


forval x=1/5{;
    forval y=1/5{;
        scalar linb`x'p`y'=p_`x'_`y';
    };
};

mat B_reg=J(5,5,0);
forval x=1/5{;
    forval y=1/5{;
        mat B_reg[`x',`y']=linb`x'p`y';
    };
};

mat theta_reg=J(5,1,0);

forval x=1/5{;
	mat theta_reg[`x',1]=_coef[wexpreg`x'];
};	

forval x=1/5{;
	sum price if bra1`x'==1;
	scalar p1`x'=r(mean);
};

forval x=1/`nbrands1'{;
	sum wvol if bra1`x'==1;
	scalar w1`x'=r(mean);
};


`ivestimator' wvol count11-count15 bra11-bra15 `lMlist1' `lregionxbrand' (wexpreg1-wexpreg5 `linplistreg'=ivwexpreg1-ivwexpreg5 `ivlinplistreg') if nest==1, nocon `lags';  


matrix ivlinB=e(b);
matrix ivlinVC=e(V);
#delimit;
forval x=1/5{;
	scalar ivp_`x'_1=_coef[preg_`x'_AUNT_JEMIMA];
	scalar ivp_`x'_2=_coef[preg_`x'_HUNGRY_JACK];
	scalar ivp_`x'_3=_coef[preg_`x'_LOG_CABIN];
	scalar ivp_`x'_4=_coef[preg_`x'_MRS_BUTTERWORTH];
	scalar ivp_`x'_5=_coef[preg_`x'_PRIVATE_LABEL];
};


forval x=1/5{;
    forval y=1/5{;
        scalar ivlinb`x'p`y'=ivp_`x'_`y';
    };
};

mat ivB_reg=J(5,5,0);
forval x=1/5{;
    forval y=1/5{;
        mat ivB_reg[`x',`y']=ivlinb`x'p`y';
    };
};


mat ivtheta_reg=J(5,1,0);

forval x=1/5{;
	mat ivtheta_reg[`x',1]=_coef[wexpreg`x'];
};	

forval x=1/4{;
	gen wexplight`x'=explight`x'/POP;
};


foreach y of local list2{;
	forval x=1/4{;
		local linplistlight "`linplistlight' plight_`x'_`y'";
	};
};

foreach y of local list2{;
	forval x=1/4{;
		local ivlinplistlight "`ivlinplistlight' ivplight_`x'_`y'";
	};
};

forval x=2/47{;
	forval y=1/4{;
		local lregionxbrand2 "`lregionxbrand2' fe2`x'_`y'";
	};
};

local lMlist2 "`Mlist2' M21b4 M22b4 M23b4 M24b4 M25b4 M26b4 M27b4 M28b4";


`estimator' wvol count21-count24 bra21-bra24 `lMlist2' `lregionxbrand2' wexplight1-wexplight4 `linplistlight' if nest==2, nocon `lags';  

matrix linB2=e(b);
matrix linVC2=e(V);
#delimit;
forval x=1/4{;
	scalar p2_`x'_1=_coef[plight_`x'_AUNT_JEMIMA_LIGHT];
	scalar p2_`x'_2=_coef[plight_`x'_JACK_LITE];
	scalar p2_`x'_3=_coef[plight_`x'_LOG_CABIN_LIGHT];
	scalar p2_`x'_4=_coef[plight_`x'_MRS_B_LITE];
};


forval x=1/4{;
    forval y=1/4{;
        scalar linb2`x'p`y'=p2_`x'_`y';
    };
};

mat B_light=J(4,4,0);
forval x=1/4{;
    forval y=1/4{;
        mat B_light[`x',`y']=linb2`x'p`y';
    };
};

mat theta_light=J(4,1,0);

forval x=1/4{;
	mat theta_light[`x',1]=_coef[wexplight`x'];
};	


forval x=1/4{;
	sum price if bra2`x'==1;
	scalar p2`x'=r(mean);
};

forval x=1/`nbrands2'{;
	sum wvol if bra2`x'==1;
	scalar w2`x'=r(mean);
};


`ivestimator' wvol count21-count24 bra21-bra24 `lMlist2' `lregionxbrand2'  (wexplight1-wexplight4 `linplistlight'=ivwexplight1-ivwexplight4 `ivlinplistlight') if nest==2, nocon `lags';  


matrix ivlinB2=e(b);
matrix ivlinVC2=e(V);
#delimit;
forval x=1/4{;
	scalar ivp2_`x'_1=_coef[plight_`x'_AUNT_JEMIMA_LIGHT];
	scalar ivp2_`x'_2=_coef[plight_`x'_JACK_LITE];
	scalar ivp2_`x'_3=_coef[plight_`x'_LOG_CABIN_LIGHT];
	scalar ivp2_`x'_4=_coef[plight_`x'_MRS_B_LITE];
};


forval x=1/4{;
    forval y=1/4{;
        scalar ivlinb2`x'p`y'=ivp2_`x'_`y';
    };
};

mat ivB_light=J(4,4,0);
forval x=1/4{;
    forval y=1/4{;
        mat ivB_light[`x',`y']=ivlinb2`x'p`y';
    };
};

mat ivtheta_light=J(4,1,0);

forval x=1/4{;
	mat ivtheta_light[`x',1]=_coef[wexplight`x'];
};	



save temp, replace;


/*Create a dataset where an observation is a region/time/segment market.  Use this to estimate middle level.*/  
drop vol-APRICE merged-lprice lexpreg-ivprice bra11-reg47 ivlaidpreg-ivlaidplight laidpreg1-ivplight_4_MRS_B_LITE ivwexpreg-ivwexplight ivwexpreg1-ivwexplight4 BRAND livprice id ivlaidpreg1-ivlaidplight3 wvol wexpreg1-wexplight4 count11-count24 fe12_1-M28b4;
duplicates drop;


/*Middle segment expenditures*/
gen wexpmid=wexpreg+wexplight;


gen lnvolmid=0;
replace lnvolmid=laidpreg if nest==1;
replace lnvolmid=laidplight if nest==2;
 

tab nest, gen(nest);
gen lp1_1=nest1*indexreg;
gen lp1_2=nest1*indexlight;
gen lp2_1=nest2*indexreg; 
gen lp2_2=nest2*indexlight;

gen p1_1=nest1*lin_indexreg;
gen p1_2=nest1*lin_indexlight;
gen p2_1=nest2*lin_indexreg;
gen p2_2=nest2*lin_indexlight;



gen ivlp1_1=nest1*ivindexreg;
gen ivlp1_2=nest1*ivindexlight;
gen ivlp2_1=nest2*ivindexreg;
gen ivlp2_2=nest2*ivindexlight;

gen ivp1_1=nest1*ivlin_indexreg;
gen ivp1_2=nest1*ivlin_indexlight;
gen ivp2_1=nest2*ivlin_indexreg;
gen ivp2_2=nest2*ivlin_indexlight;

gen lexp1=lexp*nest1;
gen lexp2=lexp*nest2;

gen wexp1=wexp*nest1;
gen wexp2=wexp*nest2;

gen ivlexp1=ivlexp*nest1;
gen ivlexp2=ivlexp*nest2;
gen ivwexp1=ivwexp*nest1;
gen ivwexp2=ivwexp*nest2;


tab month, gen (M);
tab REGION, gen(reg);
forval x=2/47{;
	forval y=1/2{;
		gen fe`y'_`x'=nest`y'*reg`x';
	};
};




forval x=1/8{;
	forval y=1/2{;		
		gen midM`x'b`y'=M`x'*nest`y';
	};
};

#delimit;
forval x=2/47{;
	forval y=1/2{;
		local femid "`femid' fe`y'_`x'";
	};
};

/*this creates month dummies for each of 2 middle level equations*/

forval x=1/8{;
	forval y=1/2{;
		local Mlistmid "`Mlistmid' midM`x'b`y'";
	};
};
gen count1=count*nest1;
gen count2=count*nest2;

sort nest REGION t;
by nest REGION: gen T2=_n;

sort T2 REGION nest;
/*separate id for each brand/region combo*/
bysort T2: gen id=_n;
tsset id T2;

/*For Aids Model*/
`estimator' lnvolmid `femid' `Mlistmid' nest1 nest2 lexp1 lexp2 lp1_1 lp1_2 lp2_1 lp2_2 count1 count2, nocon `lags';
matrix aidMidB=e(b);
matrix aidMidVC=e(V);


sca delta_mid_reg_reg=_coef[lp1_1];
sca delta_mid_reg_light=_coef[lp1_2];
sca delta_mid_light_reg=_coef[lp2_1];
sca delta_mid_light_light=_coef[lp2_2];
sca beta_reg=_coef[lexp1];
sca beta_light=_coef[lexp2];

mat deltamid=[delta_mid_reg_reg, delta_mid_reg_light\delta_mid_light_reg, delta_mid_light_light];
mat betamid=[beta_reg\beta_light];


`ivestimator' lnvolmid `femid' `Mlistmid' nest1 nest2 count1 count2 (lexp1 lexp2 lp1_1 lp1_2 lp2_1 lp2_2=ivlexp1 ivlexp2 ivlp1_1 ivlp1_2 ivlp2_1 ivlp2_2), nocon `lags';
sca ivdelta_mid_reg_reg=_coef[lp1_1];
sca ivdelta_mid_reg_light=_coef[lp1_2];
sca ivdelta_mid_light_reg=_coef[lp2_1];
sca ivdelta_mid_light_light=_coef[lp2_2];
sca ivbeta_reg=_coef[lexp1];
sca ivbeta_light=_coef[lexp2];

mat ivdeltamid=[ivdelta_mid_reg_reg, ivdelta_mid_reg_light\ivdelta_mid_light_reg, ivdelta_mid_light_light];
mat ivbetamid=[ivbeta_reg\ivbeta_light];

/*For linear model*/
`estimator' wexpmid `femid' `Mlistmid' nest1 nest2 wexp1 wexp2 count1 count2 p1_1 p1_2 p2_1 p2_2, nocon `lags';
matrix linMidB=e(b);
matrix linMidVC=e(V);
sca ldelta_mid_reg_reg=_coef[p1_1];
sca ldelta_mid_reg_light=_coef[p1_2];
sca ldelta_mid_light_reg=_coef[p2_1];
sca ldelta_mid_light_light=_coef[p2_2];
sca lbeta_reg=_coef[wexp1];
sca lbeta_light=_coef[wexp2];

mat ldeltamid=[ldelta_mid_reg_reg, ldelta_mid_reg_light\ldelta_mid_light_reg, ldelta_mid_light_light];
mat lbetamid=[lbeta_reg\lbeta_light];


`ivestimator' wexpmid `femid' `Mlistmid' nest1 nest2 count1 count2 (wexp1 wexp2 p1_1 p1_2 p2_1 p2_2=ivwexp1 ivwexp2 ivp1_1 ivp1_2 ivp2_1 ivp2_2), nocon `lags';
matrix ivlinMidB=e(b);
matrix ivlinMidVC=e(V);
sca livdelta_mid_reg_reg=_coef[p1_1];
sca livdelta_mid_reg_light=_coef[p1_2];
sca livdelta_mid_light_reg=_coef[p2_1];
sca livdelta_mid_light_light=_coef[p2_2];
sca livbeta_reg=_coef[wexp1];
sca livbeta_light=_coef[wexp2];

mat livdeltamid=[livdelta_mid_reg_reg, livdelta_mid_reg_light\livdelta_mid_light_reg, livdelta_mid_light_light];
mat livbetamid=[livbeta_reg\livbeta_light];


drop nest lexp-laidplight lin_indexreg lin_indexlight ivlexp ivindexreg ivindexlight ivlin_indexreg ivlin_indexlight ivexp wexpreg-ivwexp2 fe1_2-midM8b2 count1 count2;

duplicates drop;
gen i=0;
forval x=1/47{;
	replace i=`x' if reg`x'==1;
};

sort i t;

bysort i: gen count=_n;
tsset i count;

/*For Aids Model*/
`ivestimator' lqall  M2-M9 reg2-reg47 count (indexall=ivindexall), `lags';
scalar ivdelta_top=_coef[indexall];
matrix iv_b_top=e(b);
matrix iv_vc_top=e(V);
mata: iv_b_top=st_matrix("iv_b_top");
mata: iv_vc_top=st_matrix("iv_vc_top");




`estimator' lqall indexall M2-M9 count reg2-reg47, `lags';
scalar delta_top=_coef[indexall];
matrix ols_b_top=e(b);
matrix ols_vc_top=e(V);
mata: ols_b_top=st_matrix("ols_b_top");
mata: ols_vc_top=st_matrix("ols_vc_top");
mata: mata matsave "c:/data/restat_12_9/analysis_data/top_level" ols_b_top ols_vc_top iv_b_top iv_vc_top, replace;


/*For linear model*/
`ivestimator' wexp  M2-M9 reg2-reg47 count (lin_indexall=ivlin_indexall), `lags';
mat ivlin_b_top=e(b);
mat ivlin_vc_top=e(V);

mat ivldelta_top=_coef[lin_indexall];
`estimator' wexp lin_indexall M2-M9 count reg2-reg47, `lags';
mat lin_b_top=e(b);
mat lin_vc_top=e(V);
mat ldelta_top=_coef[lin_indexall];



#delimit;
use temp, replace;
gen bra1=0;
replace bra1=1 if BRAND=="AUNT_JEMIMA";
gen bra2=0;
replace bra2=1 if BRAND=="HUNGRY_JACK";
gen bra3=0;
replace bra3=1 if BRAND=="LOG_CABIN";
gen bra4=0;
replace bra4=1 if BRAND=="MRS_BUTTERWORTH";
gen bra5=0;
replace bra5=1 if BRAND=="PRIVATE_LABEL";
gen bra6=0;
replace bra6=1 if BRAND=="AUNT_JEMIMA_LIGHT";
gen bra7=0;
replace bra7=1 if BRAND=="JACK_LITE";
gen bra8=0;
replace bra8=1 if BRAND=="LOG_CABIN_LIGHT";
gen bra9=0;
replace bra9=1 if BRAND=="MRS_B_LITE";




gen expmid=expreg+explight;


#delimit;
/*total sales by type*/
/*total syrup sales by type over time*/
sort BRAND REGION nest t;
bysort BRAND REGION nest: egen tsaletype=total(expmid);
/*total syrup sales over time*/
bysort BRAND REGION: egen tsaleall=total(exp);
/*total syrup sales by brand over time*/
bysort BRAND REGION: egen bsale=total(sale);
gen avgsharenest=bsale/tsaletype;
gen avgshare=bsale/tsaleall;


/*w`x'b`y'reg is the average revenue share of producy `y' in region `x' conditional on regular*/
forval x=1/`nregions'{;
    forval y=1/`nbrands1'{;	    
        qui sum avgsharenest if reg`x'==1 & bra1`y'==1;
        scalar w`x'b`y'reg=r(mean);
    };
};

/*w`x'b`y'light is the average revenue share of producy `y' in region `x' conditional on light*/
forval x=1/`nregions'{;
    forval y=1/`nbrands2'{;
        qui sum avgsharenest if reg`x'==1 & bra2`y'==1;
        scalar w`x'b`y'light=r(mean);
    };
};

/*w`x'b`y'all is the average revenue share of producy `y' in region `x'*/
forval x=1/`nregions'{;
    forval y=1/`nbrands'{;
        qui sum avgshare if reg`x'==1 & brand`y'==1;
        scalar w`x'b`y'all=r(mean);
    };
};

/*total sales by segment over all regions and time*/
bysort BRAND nest: egen national_tsale_type=total(expmid);

/*total sales over all regions and time*/
bysort BRAND: egen national_tsale_all=total(exp);


bysort BRAND: egen national_bsale=total(sale);
gen nat_avgshare_nest=national_bsale/national_tsale_type;
gen nat_avgshare_all=national_bsale/national_tsale_all;


forval x=1/`nbrands1'{;
	sum nat_avgshare_nest if bra1`x'==1;
	scalar avgw`x'reg=r(mean);
};

forval x=1/`nbrands2'{;
	sum nat_avgshare_nest if bra2`x'==1;
	scalar avgw`x'light=r(mean);
};

forval x=1/`nbrands1'{;
	sum nat_avgshare_all if bra1`x'==1;
	scalar avgw`x'reg_all=r(mean);
};

forval x=1/`nbrands2'{;
	sum nat_avgshare_all if bra2`x'==1;
	scalar avgw`x'light_all=r(mean);
};



/*HERE WE CONSTRUCT OVER-ALL ELASTICITIES EVALUATED AT AVERAGES TAKEN OVER REGIONS AND TIME*/


/*AIDS estimated by OLS*/
/*regular*/
/*within same nest elasticities*/
forval x=1/`nbrands1'{;
	forval y=1/`nbrands1'{;
		scalar ereg`x'`y'=(1+delta_mid_reg_reg)*avgw`y'reg+beta_reg*(1+delta_top)*avgw`y'reg_all+g`x'p`y'/s1`x'+(b`x'/s1`x')*(delta_mid_reg_reg*avgw`y'reg+
		avgw`y'reg_all*(1+delta_top)*beta_reg);
	};
};
forval x=1/`nbrands2'{;
	forval y=1/`nbrands2'{;
		scalar elight`x'`y'=(1+delta_mid_light_light)*avgw`y'light+beta_light*(1+delta_top)*avgw`y'light_all+g2`x'p`y'/s2`x'+(b2`x'/s2`x')*(delta_mid_light_light*avgw`y'light+
		avgw`y'light_all*(1+delta_top)*beta_light);
	};
};


forval x=1/`nbrands1'{;
	scalar ereg`x'`x'=-1+ereg`x'`x';
};
forval x=1/`nbrands2'{;
	scalar elight`x'`x'=-1+elight`x'`x';
};
mat regnestelas=J(5,5,0);
mat lightnestelas=J(4,4,0);


forval x=1/5{;
	forval y=1/5{;
	mat regnestelas[`x',`y']=ereg`x'`y';
	};
};

forval x=1/4{;
	forval y=1/4{;
	mat lightnestelas[`x',`y']=elight`x'`y';
	};
};

/*Cross nest elasticities*/
forval x=1/5{;
	forval y=1/4{;
		scalar ereg`x'light`y'=(1+b`x'/s1`x')*(beta_reg*(1+delta_top)*avgw`y'light_all+delta_mid_reg_light*avgw`y'light);
	};
};


mat reg_lightelas=J(5,4,0);

forval x=1/5{;
	forval y=1/4{;
	mat reg_lightelas[`x',`y']=ereg`x'light`y';
	};
};
	

forval x=1/4{;
	forval y=1/5{;
		scalar elight`x'reg`y'=(1+b2`x'/s2`x')*(beta_light*(1+delta_top)*avgw`y'reg_all+delta_mid_light_reg*avgw`y'reg);
	};
};
mat light_regelas=J(4,5,0);

forval x=1/4{;
	forval y=1/5{;
	mat light_regelas[`x',`y']=elight`x'reg`y';
	};
};



mat aidselasticities=J(9,9,0);
mat aidselasticities[1,1]=regnestelas;
mat aidselasticities[6,6]=lightnestelas;
mat aidselasticities[1,6]=reg_lightelas;
mat aidselasticities[6,1]=light_regelas;



forval x=1/`nbrands1'{;
	forval y=1/`nbrands1'{;
		scalar ivereg`x'`y'=(1+ivdelta_mid_reg_reg)*avgw`y'reg+ivbeta_reg*(1+ivdelta_top)*avgw`y'reg_all+ivg`x'p`y'/s1`x'+(ivb`x'/s1`x')*(ivdelta_mid_reg_reg*avgw`y'reg+
		avgw`y'reg_all*(1+ivdelta_top)*ivbeta_reg);
	};
};



forval x=1/`nbrands2'{;
	forval y=1/`nbrands2'{;
		scalar ivelight`x'`y'=(1+ivdelta_mid_light_light)*avgw`y'light+ivbeta_light*(1+ivdelta_top)*avgw`y'light_all+ivg2`x'p`y'/s2`x'+(ivb2`x'/s2`x')*(ivdelta_mid_light_light*avgw`y'light+
		avgw`y'light_all*(1+ivdelta_top)*ivbeta_light);
	};
};


forval x=1/`nbrands1'{;
	scalar ivereg`x'`x'=-1+ivereg`x'`x';
};
forval x=1/`nbrands2'{;
	scalar ivelight`x'`x'=-1+ivelight`x'`x';
};


mat ivregnestelas=J(5,5,0);
mat ivlightnestelas=J(4,4,0);


forval x=1/5{;
	forval y=1/5{;
	mat ivregnestelas[`x',`y']=ivereg`x'`y';
	};
};

forval x=1/4{;
	forval y=1/4{;
	mat ivlightnestelas[`x',`y']=ivelight`x'`y';
	};
};

/*Cross nest elasticities*/
forval x=1/5{;
	forval y=1/4{;
		scalar ivereg`x'light`y'=(1+ivb`x'/s1`x')*(ivbeta_reg*(1+ivdelta_top)*avgw`y'light_all+ivdelta_mid_reg_light*avgw`y'light);
	};
};
mat ivreg_lightelas=J(5,4,0);

forval x=1/5{;
	forval y=1/4{;
	mat ivreg_lightelas[`x',`y']=ivereg`x'light`y';
	};
};
	

forval x=1/4{;
	forval y=1/5{;
		scalar ivelight`x'reg`y'=(1+ivb2`x'/s2`x')*(ivbeta_light*(1+ivdelta_top)*avgw`y'reg_all+ivdelta_mid_light_reg*avgw`y'reg);
	};
};
mat ivlight_regelas=J(4,5,0);

forval x=1/4{;
	forval y=1/5{;
	mat ivlight_regelas[`x',`y']=ivelight`x'reg`y';
	};
};



mat ivaidselasticities=J(9,9,0);
mat ivaidselasticities[1,1]=ivregnestelas;
mat ivaidselasticities[6,6]=ivlightnestelas;
mat ivaidselasticities[1,6]=ivreg_lightelas;
mat ivaidselasticities[6,1]=ivlight_regelas;



/*Linear Elasticities*/
/*within nest elasticities*/

forval x=1/`nbrands1'{;
	forval y=1/`nbrands1'{;
		scalar linereg`x'`y'=(p1`y'/w1`x')*(linb`x'p`y'+theta_reg[`x',1]*(ldeltamid[1,1]*avgw`y'reg+avgw`y'reg_all*lbetamid[1,1]*ldelta_top[1,1]));
	};
};
mat lregelas=J(5,5,0);
forval x=1/`nbrands1'{;
	forval y=1/`nbrands1'{;
		mat lregelas[`x',`y']=linereg`x'`y';
	};
};
 
forval x=1/`nbrands2'{;
	forval y=1/`nbrands2'{;
		scalar linelight`x'`y'=(p2`y'/w2`x')*(linb2`x'p`y'+theta_light[`x',1]*(ldeltamid[2,2]*avgw`y'light+avgw`y'light_all*lbetamid[2,1]*ldelta_top[1,1]));
	};
};
mat llightelas=J(4,4,0);
forval x=1/`nbrands2'{;
	forval y=1/`nbrands2'{;
		mat llightelas[`x',`y']=linelight`x'`y';
	};
};
 
/*across nest elasticities*/
forval x=1/`nbrands1'{;
	forval y=1/`nbrands2'{;
		scalar linereg`x'light`y'=(p2`y'/w1`x')*(theta_reg[`x',1]*(ldeltamid[1,2]*avgw`y'light+lbetamid[1,1]*ldelta_top[1,1]*avgw`y'light_all ));
	};
};
mat lreg_lightelas=J(5,4,0);

forval x=1/`nbrands1'{;
	forval y=1/`nbrands2'{;
		mat lreg_lightelas[`x',`y']=linereg`x'light`y';
	};
};



forval x=1/`nbrands2'{;
	forval y=1/`nbrands1'{;
		scalar linelight`x'reg`y'=(p1`y'/w2`x')*(theta_light[`x',1]*(ldeltamid[2,1]*avgw`y'reg+lbetamid[2,1]*ldelta_top[1,1]*avgw`y'reg_all ));
	};
};

mat llight_regelas=J(4,5,0);

forval x=1/`nbrands2'{;
	forval y=1/`nbrands1'{;
		mat llight_regelas[`x',`y']=linelight`x'reg`y';
	};
};

mat linelasticities=J(9,9,0);
mat linelasticities[1,1]=lregelas;
mat linelasticities[6,6]=llightelas;
mat linelasticities[1,6]=lreg_lightelas;
mat linelasticities[6,1]=llight_regelas;


forval x=1/`nbrands1'{;
	forval y=1/`nbrands1'{;
		scalar ivlinereg`x'`y'=(p1`y'/w1`x')*(ivlinb`x'p`y'+ivtheta_reg[`x',1]*(livdeltamid[1,1]*avgw`y'reg+avgw`y'reg_all*livbetamid[1,1]*ivldelta_top[1,1]));
	};
};
mat ivlregelas=J(5,5,0);
forval x=1/`nbrands1'{;
	forval y=1/`nbrands1'{;
		mat ivlregelas[`x',`y']=ivlinereg`x'`y';
	};
};
 
forval x=1/`nbrands2'{;
	forval y=1/`nbrands2'{;
		scalar ivlinelight`x'`y'=(p2`y'/w2`x')*(ivlinb2`x'p`y'+ivtheta_light[`x',1]*(livdeltamid[2,2]*avgw`y'light+avgw`y'light_all*livbetamid[2,1]*ivldelta_top[1,1]));
	};
};
mat ivllightelas=J(4,4,0);
forval x=1/`nbrands2'{;
	forval y=1/`nbrands2'{;
		mat ivllightelas[`x',`y']=ivlinelight`x'`y';
	};
};
 
/*across nest elasticities*/
forval x=1/`nbrands1'{;
	forval y=1/`nbrands2'{;
		scalar ivlinereg`x'light`y'=(p2`y'/w1`x')*(ivtheta_reg[`x',1]*(livdeltamid[1,2]*avgw`y'light+livbetamid[1,1]*ivldelta_top[1,1]*avgw`y'light_all ));
	};
};
mat ivlreg_lightelas=J(5,4,0);

forval x=1/`nbrands1'{;
	forval y=1/`nbrands2'{;
		mat ivlreg_lightelas[`x',`y']=ivlinereg`x'light`y';
	};
};



forval x=1/`nbrands2'{;
	forval y=1/`nbrands1'{;
		scalar ivlinelight`x'reg`y'=(p1`y'/w2`x')*(ivtheta_light[`x',1]*(livdeltamid[2,1]*avgw`y'reg+livbetamid[2,1]*ivldelta_top[1,1]*avgw`y'reg_all ));
	};
};

mat ivllight_regelas=J(4,5,0);

forval x=1/`nbrands2'{;
	forval y=1/`nbrands1'{;
		mat ivllight_regelas[`x',`y']=ivlinelight`x'reg`y';
	};
};

mat ivlinelasticities=J(9,9,0);
mat ivlinelasticities[1,1]=ivlregelas;
mat ivlinelasticities[6,6]=ivllightelas;
mat ivlinelasticities[1,6]=ivlreg_lightelas;
mat ivlinelasticities[6,1]=ivllight_regelas;


/*s_i: creates average share vector for each region*/
#delimit;
local nregions=47;
local nbrands=9;
forval x=1/`nregions'{;
    mat define sbar`x'=J(`nbrands',1,0);
    forval y=1/`nbrands'{;
        qui sum share if reg`x'==1 & bra`y'==1;
        matrix sbar`x'[`y',1]=_result(3);
	};
};

mat define x_reg=J(47,1,0);
mat define x_light=J(47,1,0);

forval x=1/`nregions'{;
    qui sum expmid if reg`x'==1 & nest==1;
	matrix x_reg[`x',1]=_result(3);
	qui sum expmid if reg`x'==1 & nest==2;
	matrix x_light[`x',1]=_result(3);
};


mat X=[x_reg,x_light];

mat define w_nest=J(47,9,0);

forval x=1/`nregions'{;
	forval y=1/5{;
		mat w_nest[`x',`y']=w`x'b`y'reg;
	};
};
forval x=1/`nregions'{;
	forval y=1/4{;
		mat w_nest[`x',`y'+5]=w`x'b`y'light;
	};
};

mat define w=J(47,9,0);
forval x=1/`nregions'{;
	forval y=1/5{;
		mat w[`x',`y']=w`x'b`y'all;
	};
};
forval x=1/`nregions'{;
	forval y=1/4{;
		mat w[`x',`y'+5]=w`x'b`y'all;
	};
};

/*For use in bootstrapped elasticity evaluations*/
mat wnest=J(9,1,0);
forval x=1/5{;
	mat wnest[`x',1]=avgw`x'reg;
};
forval x=1/4{;
	mat wnest[5+`x',1]=avgw`x'light;
};	

mat wall=J(9,1,0);
forval x=1/5{;
	mat wall[`x',1]=avgw`x'reg_all;
};
forval x=1/4{;
	mat wall[5+`x',1]=avgw`x'light_all;
};	



/*creates average prices for each region*/
forval x=1/`nregions'{;
    mat define pbar`x'=J(`nbrands',1,0);
    forval y=1/`nbrands'{;
        qui sum price if reg`x'==1 & bra`y'==1;
        matrix pbar`x'[`y',1]=_result(3);
       };
};





/*creates average volume for each region*/
forval x=1/`nregions'{;
    mat define vbar`x'=J(`nbrands',1,0);
    forval y=1/`nbrands'{;
        qui sum wvol if bra`y'==1 & reg`x'==1;
        matrix vbar`x'[`y',1]=_result(3);
        };
    };


/*makes pre-merger "ownership" matrices*/
forval i=1/`nregions'{;
    mat define aidomega`i'=J(`nbrands',`nbrands',0);
};

forval i=1/`nregions'{;
    mat define ivaidomega`i'=J(`nbrands',`nbrands',0);
};
forval i=1/`nregions'{;
    mat define X`i'=J(`nbrands',`nbrands',0);
};

/*slope parameters for full solution*/


mat define g_reg=J(`nbrands1',`nbrands1',0);
/*[x,y] element of g_reg is the coefficient on log price of good y in equation x*/
forval x=1/5{;
	forval y=1/5{;
		mat g_reg[`x',`y']=g`x'p`y';
	};
};
mat define g_light=J(`nbrands2',`nbrands2',0);
forval x=1/4{;
	forval y=1/4{;
		mat g_light[`x',`y']=g2`x'p`y';
	};
};

mat define ivg_reg=J(`nbrands1',`nbrands1',0);
forval x=1/5{;
	forval y=1/5{;
		mat ivg_reg[`x',`y']=ivg`x'p`y';
	};
};
mat define ivg_light=J(`nbrands2',`nbrands2',0);
forval x=1/4{;
	forval y=1/4{;
		mat ivg_light[`x',`y']=ivg2`x'p`y';
	};
}; 

mat define b_reg=J(`nbrands1',1,0);
forval x=1/5{;
	mat b_reg[`x',1]=b`x';
};	

mat define b_light=J(`nbrands2',1,0);
forval x=1/4{;
	mat b_light[`x',1]=b2`x';
};	

mat define ivb_reg=J(`nbrands1',1,0);
forval x=1/5{;
	mat ivb_reg[`x',1]=ivb`x';
};	

mat define ivb_light=J(`nbrands2',1,0);
forval x=1/4{;
	mat ivb_light[`x',1]=ivb2`x';
};	
mat delta=[delta_mid_reg_reg, delta_mid_reg_light\ delta_mid_light_reg, delta_mid_light_light];
mat ivdelta=[ivdelta_mid_reg_reg, ivdelta_mid_reg_light\ ivdelta_mid_light_reg, ivdelta_mid_light_light];

mat beta=[beta_reg\beta_light];
mat ivbeta=[ivbeta_reg\ivbeta_light];

mat delta_top=[delta_top];
mat ivdelta_top=[ivdelta_top];
 
forval i=1/`nregions'{;
	forval x=1/`nbrands1'{;
			mat ivaidomega`i'[`x',`x']=(-1+(1+ivdelta_mid_reg_reg)*w_nest[`i',`x']
			+ivbeta_reg*(1+ivdelta_top)*w[`i',`x']
			+ivg`x'p`x'/sbar`i'[`x',1]
			+(ivb`x'/sbar`i'[`x',1])*(ivdelta_mid_reg_reg*w_nest[`i',`x']+w[`i',`x']*(1+ivdelta_top)*ivbeta_reg))*x_reg[`i',1]*sbar`i'[`x',1];
	};
};

forval i=1/`nregions'{;
	forval x=1/`nbrands2'{;
			mat ivaidomega`i'[5+`x',5+`x']=(-1+(1+ivdelta_mid_light_light)*w_nest[`i',5+`x']
			+ivbeta_light*(1+ivdelta_top)*w[`i',5+`x']
			+ivg2`x'p`x'/sbar`i'[5+`x',1]
			+(ivb2`x'/sbar`i'[5+`x',1])*(ivdelta_mid_light_light*w_nest[`i',5+`x']+w[`i',5+`x']*(1+ivdelta_top)*ivbeta_light))*x_light[`i',1]*sbar`i'[`x'+5,1];
	};
};
/*Need to fill out off diagonal of aidomega and ivaidomega matrices*/
forval i=1/`nregions'{;
	mat ivaidomega`i'[6,1]=((1+ivb1/sbar`i'[1,1])*(ivbeta_reg*(1+ivdelta_top)*w[`i',6]+ivdelta_mid_reg_light*w_nest[`i',6]))*x_reg[`i',1]*sbar`i'[1,1];
	};
forval i=1/`nregions'{;
	mat ivaidomega`i'[1,6]=((1+ivb21/sbar`i'[6,1])*(ivbeta_light*(1+ivdelta_top)*w[`i',1]+ivdelta_mid_light_reg*w_nest[`i',1]))*x_light[`i',1]*sbar`i'[6,1];
};
forval i=1/`nregions'{;
	mat ivaidomega`i'[7,2]=((1+ivb2/sbar`i'[2,1])*(ivbeta_reg*(1+ivdelta_top)*w[`i',7]+ivdelta_mid_reg_light*w_nest[`i',7]))*x_reg[`i',1]*sbar`i'[2,1];
};
forval i=1/`nregions'{;
	mat ivaidomega`i'[2,7]=((1+ivb22/sbar`i'[7,1])*(ivbeta_light*(1+ivdelta_top)*w[`i',2]+ivdelta_mid_light_reg*w_nest[`i',2]))*x_light[`i',1]*sbar`i'[7,1];
};
forval i=1/`nregions'{;
	mat ivaidomega`i'[8,3]=((1+ivb3/sbar`i'[3,1])*(ivbeta_reg*(1+ivdelta_top)*w[`i',8]+ivdelta_mid_reg_light*w_nest[`i',8]))*x_reg[`i',1]*sbar`i'[3,1];
};
forval i=1/`nregions'{;
	mat ivaidomega`i'[3,8]=((1+ivb23/sbar`i'[8,1])*(ivbeta_light*(1+ivdelta_top)*w[`i',3]+ivdelta_mid_light_reg*w_nest[`i',3]))*x_light[`i',1]*sbar`i'[8,1];
};
forval i=1/`nregions'{;
	mat ivaidomega`i'[9,4]=((1+ivb4/sbar`i'[4,1])*(ivbeta_reg*(1+ivdelta_top)*w[`i',9]+ivdelta_mid_reg_light*w_nest[`i',9]))*x_reg[`i',1]*sbar`i'[4,1];
};
forval i=1/`nregions'{;
	mat ivaidomega`i'[4,9]=((1+ivb24/sbar`i'[9,1])*(ivbeta_light*(1+ivdelta_top)*w[`i',4]+ivdelta_mid_light_reg*w_nest[`i',4]))*x_light[`i',1]*sbar`i'[9,1];
};




forval i=1/`nregions'{;
	forval x=1/`nbrands1'{;
			mat aidomega`i'[`x',`x']=(-1+(1+delta_mid_reg_reg)*w_nest[`i',`x']
			+beta_reg*(1+delta_top)*w[`i',`x']
			+g`x'p`x'/sbar`i'[`x',1]
			+(b`x'/sbar`i'[`x',1])*(delta_mid_reg_reg*w_nest[`i',`x']+w[`i',`x']*(1+delta_top)*beta_reg))*x_reg[`i',1]*sbar`i'[`x',1];
	};
};

forval i=1/`nregions'{;
	forval x=1/`nbrands2'{;
			mat aidomega`i'[5+`x',5+`x']=(-1+(1+delta_mid_light_light)*w_nest[`i',5+`x']
			+beta_light*(1+delta_top)*w[`i',5+`x']
			+g2`x'p`x'/sbar`i'[5+`x',1]
			+(b2`x'/sbar`i'[5+`x',1])*(delta_mid_light_light*w_nest[`i',5+`x']+w[`i',5+`x']*(1+delta_top)*beta_light))*x_light[`i',1]*sbar`i'[`x'+5,1];
	};
};


forval i=1/`nregions'{;
	mat aidomega`i'[6,1]=((1+b1/sbar`i'[1,1])*(beta_reg*(1+delta_top)*w[`i',6]+delta_mid_reg_light*w_nest[`i',6]))*x_reg[`i',1]*sbar`i'[1,1];
	};
forval i=1/`nregions'{;
	mat aidomega`i'[1,6]=((1+b21/sbar`i'[6,1])*(beta_light*(1+delta_top)*w[`i',1]+delta_mid_light_reg*w_nest[`i',1]))*x_light[`i',1]*sbar`i'[6,1];
};
forval i=1/`nregions'{;
	mat aidomega`i'[7,2]=((1+b2/sbar`i'[2,1])*(beta_reg*(1+delta_top)*w[`i',7]+delta_mid_reg_light*w_nest[`i',7]))*x_reg[`i',1]*sbar`i'[2,1];
};
forval i=1/`nregions'{;
	mat aidomega`i'[2,7]=((1+b22/sbar`i'[7,1])*(beta_light*(1+delta_top)*w[`i',2]+delta_mid_light_reg*w_nest[`i',2]))*x_light[`i',1]*sbar`i'[7,1];
};
forval i=1/`nregions'{;
	mat aidomega`i'[8,3]=((1+b3/sbar`i'[3,1])*(beta_reg*(1+delta_top)*w[`i',8]+delta_mid_reg_light*w_nest[`i',8]))*x_reg[`i',1]*sbar`i'[3,1];
};
forval i=1/`nregions'{;
	mat aidomega`i'[3,8]=((1+b23/sbar`i'[8,1])*(beta_light*(1+delta_top)*w[`i',3]+delta_mid_light_reg*w_nest[`i',3]))*x_light[`i',1]*sbar`i'[8,1];
};
forval i=1/`nregions'{;
	mat aidomega`i'[9,4]=((1+b4/sbar`i'[4,1])*(beta_reg*(1+delta_top)*w[`i',9]+delta_mid_reg_light*w_nest[`i',9]))*x_reg[`i',1]*sbar`i'[4,1];
};
forval i=1/`nregions'{;
	mat aidomega`i'[4,9]=((1+b24/sbar`i'[9,1])*(beta_light*(1+delta_top)*w[`i',4]+delta_mid_light_reg*w_nest[`i',4]))*x_light[`i',1]*sbar`i'[9,1];
};

forval i=1/`nregions'{;
    forval x=1/`nbrands1'{;
        mat X`i'[`x',`x']=x_reg[`i',1];
    };
};

forval i=1/`nregions'{;
    forval x=1/`nbrands2'{;
        mat X`i'[`x'+5,`x'+5]=x_light[`i',1];
    };
};




/*aidmu has p-mc, not lerner index*/
forval i=1/`nregions'{;
    mat aidmu`i'=J(`nbrands',1,0);
    mat aidmu`i'=-inv(aidomega`i')*X`i'*sbar`i';
    mat ivaidmu`i'=J(`nbrands',1,0);
    mat ivaidmu`i'=-inv(ivaidomega`i')*X`i'*sbar`i';
};



/*mark-up matrix has 10 columns, which correspond to regional markets, and 7 rows corresponding to brands.  
aidmu are p-mc's with aid system, lmu are p=mc's with linear system, llmu are lerner indices with log-linear system
this just puts them in matrix form as described above*/
mat aidmu=[aidmu1];
mat ivaidmu=[ivaidmu1];
mat pbar=[pbar1];
/*mat lpbar=[lpbar1];*/
mat sbar=[sbar1];
forval x=2/`nregions'{;
    mat aidmu=[aidmu,aidmu`x'];
    mat ivaidmu=[ivaidmu,ivaidmu`x'];
    mat pbar=[pbar,pbar`x'];
    mat sbar=[sbar,sbar`x'];
};

mat pbar=pbar';
/*mat lpbar=lpbar';*/
mat sbar=sbar';
mat aidmu=aidmu';
mat ivaidmu=ivaidmu';

/*get costs by solving mark-ups.  because element-by-element operations are a pain in stata, i do this in mata*/
/*input markup matrices, average prices and shares, and post-merger ownership matrices into stata*/
mata;
	pbar=st_matrix("pbar");
	postdirect=J(47,9,0);
	postdirect[.,1]=pbar[.,1]*(1+0.0003);  /*aj*/
	postdirect[.,2]=pbar[.,2]*(1+0.0160); /*hj*/
	postdirect[.,3]=pbar[.,3]*(1+0.0323);  /*lj*/
	postdirect[.,4]=pbar[.,4]*(1-0.0090);  /*mv*/
	postdirect[.,5]=pbar[.,5]*(1+0.0072);  /*pl*/
	postdirect[.,6]=pbar[.,6]*(1+0.0094);  /*ajl*/
	postdirect[.,7]=pbar[.,7]*(1+0.0172);  /*hjl*/
	postdirect[.,8]=pbar[.,8]*(1+0.0346);  /*lvl*/
	postdirect[.,9]=pbar[.,9]*(1+0.0037);  /*mbl*/

	b_reg=st_matrix("b_reg");
	b_light=st_matrix("b_light");
	ivb_reg=st_matrix("ivb_reg");
	ivb_light=st_matrix("ivb_light");
	
	g_reg=st_matrix("g_reg");
	g_light=st_matrix("g_light");
	ivg_reg=st_matrix("ivg_reg");
	ivg_light=st_matrix("ivg_light");
	w=st_matrix("w");
	w_nest=st_matrix("w_nest");
	X=st_matrix("X");
	delta=st_matrix("delta");
	ivdelta=st_matrix("ivdelta");
	
	beta=st_matrix("beta");
	ivbeta=st_matrix("ivbeta");
	
	delta_top=st_matrix("delta_top");
	ivdelta_top=st_matrix("ivdelta_top");
	
    aidmu=st_matrix("aidmu");
    ivaidmu=st_matrix("ivaidmu");

    pbar=st_matrix("pbar");
    sbar=st_matrix("sbar");
    aidcost=pbar:*(J(`nregions',`nbrands',1)-aidmu);
    ivaidcost=pbar:*(J(`nregions',`nbrands',1)-ivaidmu);
    st_matrix("aidcost", aidcost);
    st_matrix("ivaidcost", ivaidcost);
end;



/*defines post-merger ownership matrix of elasticities*/
forval i=1/`nregions'{;
    mat define taidomega`i'=J(`nbrands',`nbrands',0);
};
forval i=1/`nregions'{;
    mat define ivtaidomega`i'=J(`nbrands',`nbrands',0);
};




forval i=1/`nregions'{;
	mat ivtaidomega`i'[8,4]=((1+ivb4/sbar`i'[4,1])*(ivbeta_reg*(1+ivdelta_top)*w[`i',8]+ivdelta_mid_reg_light*w_nest[`i',8]))*x_reg[`i',1]*sbar`i'[4,1];
	};
forval i=1/`nregions'{;
	mat ivtaidomega`i'[4,8]=((1+ivb23/sbar`i'[8,1])*(ivbeta_light*(1+ivdelta_top)*w[`i',4]+ivdelta_mid_light_reg*w_nest[`i',4]))*x_light[`i',1]*sbar`i'[8,1];
};

forval i=1/`nregions'{;
	mat ivtaidomega`i'[9,3]=((1+ivb3/sbar`i'[3,1])*(ivbeta_reg*(1+ivdelta_top)*w[`i',9]+ivdelta_mid_reg_light*w_nest[`i',9]))*x_reg[`i',1]*sbar`i'[3,1];
};
forval i=1/`nregions'{;
	mat ivtaidomega`i'[3,9]=((1+ivb24/sbar`i'[9,1])*(ivbeta_light*(1+ivdelta_top)*w[`i',9]+ivdelta_mid_light_reg*w_nest[`i',3]))*x_light[`i',1]*sbar`i'[9,1];
};



forval i=1/`nregions'{;            
			mat ivtaidomega`i'[4,3]=((1+ivdelta_mid_reg_reg)*w_nest[`i',4]
			+ivbeta_reg*(1+ivdelta_top)*w[`i',4]
			+ivg3p4/sbar`i'[3,1]
			+(ivb3/sbar`i'[3,1])*(ivdelta_mid_reg_reg*w_nest[`i',4]+w[`i',4]*(1+ivdelta_top)*ivbeta_reg))*x_reg[`i',1]*sbar`i'[3,1];
	};
	

forval i=1/`nregions'{;
			mat ivtaidomega`i'[3,4]=((1+ivdelta_mid_reg_reg)*w_nest[`i',3]
			+ivbeta_reg*(1+ivdelta_top)*w[`i',3]
			+ivg4p3/sbar`i'[4,1]
			+(ivb4/sbar`i'[4,1])*(ivdelta_mid_reg_reg*w_nest[`i',3]+w[`i',3]*(1+ivdelta_top)*ivbeta_reg))*x_reg[`i',1]*sbar`i'[4,1];
};


forval i=1/`nregions'{;
			mat ivtaidomega`i'[9,8]=((1+ivdelta_mid_light_light)*w_nest[`i',9]
			+ivbeta_light*(1+ivdelta_top)*w[`i',9]
			+ivg23p4/sbar`i'[8,1]
			+(ivb23/sbar`i'[8,1])*(ivdelta_mid_light_light*w_nest[`i',9]+w[`i',9]*(1+ivdelta_top)*ivbeta_light))*x_light[`i',1]*sbar`i'[8,1];
};

forval i=1/`nregions'{;
	mat ivtaidomega`i'[8,9]=((1+ivdelta_mid_light_light)*w_nest[`i',8]
			+ivbeta_light*(1+ivdelta_top)*w[`i',8]
			+ivg24p3/sbar`i'[9,1]
			+(ivb24/sbar`i'[9,1])*(ivdelta_mid_light_light*w_nest[`i',8]+w[`i',8]*(1+ivdelta_top)*ivbeta_light))*x_light[`i',1]*sbar`i'[9,1];
};


forval i=1/`nregions'{;
	mat taidomega`i'[8,4]=((1+b4/sbar`i'[4,1])*(beta_reg*(1+delta_top)*w[`i',8]+delta_mid_reg_light*w_nest[`i',8]))*x_reg[`i',1]*sbar`i'[4,1];
	};


forval i=1/`nregions'{;
	mat taidomega`i'[4,8]=((1+b23/sbar`i'[8,1])*(beta_light*(1+delta_top)*w[`i',4]+delta_mid_light_reg*w_nest[`i',4]))*x_light[`i',1]*sbar`i'[8,1];
};

forval i=1/`nregions'{;
	mat taidomega`i'[9,3]=((1+b3/sbar`i'[3,1])*(beta_reg*(1+delta_top)*w[`i',9]+delta_mid_reg_light*w_nest[`i',9]))*x_reg[`i',1]*sbar`i'[3,1];
};


forval i=1/`nregions'{;
	mat taidomega`i'[3,9]=((1+b24/sbar`i'[9,1])*(beta_light*(1+delta_top)*w[`i',3]+delta_mid_light_reg*w_nest[`i',3]))*x_light[`i',1]*sbar`i'[9,1];
};



forval i=1/`nregions'{;            
			mat taidomega`i'[4,3]=((1+delta_mid_reg_reg)*w_nest[`i',4]
			+beta_reg*(1+delta_top)*w[`i',4]
			+g3p4/sbar`i'[3,1]
			+(b3/sbar`i'[3,1])*(delta_mid_reg_reg*w_nest[`i',4]+w[`i',4]*(1+delta_top)*beta_reg))*x_reg[`i',1]*sbar`i'[3,1];
	};

	
forval i=1/`nregions'{;
			mat taidomega`i'[3,4]=((1+delta_mid_reg_reg)*w_nest[`i',3]
			+beta_reg*(1+delta_top)*w[`i',3]
			+g4p3/sbar`i'[4,1]
			+(b4/sbar`i'[4,1])*(delta_mid_reg_reg*w_nest[`i',3]+w[`i',3]*(1+delta_top)*beta_reg))*x_reg[`i',1]*sbar`i'[4,1];
};



forval i=1/`nregions'{;
			mat taidomega`i'[9,8]=((1+delta_mid_light_light)*w_nest[`i',9]
			+beta_light*(1+delta_top)*w[`i',9]
			+g23p4/sbar`i'[8,1]
			+(b23/sbar`i'[8,1])*(delta_mid_light_light*w_nest[`i',9]+w[`i',9]*(1+delta_top)*beta_light))*x_light[`i',1]*sbar`i'[8,1];
};



forval i=1/`nregions'{;
	mat taidomega`i'[8,9]=((1+delta_mid_light_light)*w_nest[`i',8]
			+beta_light*(1+delta_top)*w[`i',8]
			+g24p3/sbar`i'[9,1]
			+(b24/sbar`i'[9,1])*(delta_mid_light_light*w_nest[`i',8]+w[`i',8]*(1+delta_top)*beta_light))*x_light[`i',1]*sbar`i'[9,1];
};





#delimit;
/*solves for post-merger mark-ups*/
forval i=1/`nregions'{;
    mat postaidomega`i'=aidomega`i'+taidomega`i';
};
forval i=1/`nregions'{;
    mat ivpostaidomega`i'=ivaidomega`i'+ivtaidomega`i';
};

forval i=1/`nregions'{;
    mat paidmu`i'=-inv(postaidomega`i')*X`i'*sbar`i';
};

forval i=1/`nregions'{;
    mat ivpaidmu`i'=-inv(ivpostaidomega`i')*X`i'*sbar`i';
};

/*puts post-merger mark-ups into a matrix with rows corresponding to markets and columns to products*/

mat paidmu=[paidmu1];
mat ivpaidmu=[ivpaidmu1];

forval x=2/`nregions'{;
    mat paidmu=[paidmu,paidmu`x'];
};

mat paidmu=paidmu';


forval x=2/`nregions'{;
    mat ivpaidmu=[ivpaidmu,ivpaidmu`x'];
};

mat ivpaidmu=ivpaidmu';


# delimit;



/*now go back to mata to solve for post-merger prices.  will then calculate percentage increases over 
pre-merger average prices for each region, and then take the average over regions for to yield percentage
price increases for each product.  these average prices are the mxprice variables and the average costs are the
mxcost variables*/

mata;
    /*tsale=st_matrix("tsale");*/
    paidmu=st_matrix("paidmu");
    ivpaidmu=st_matrix("ivpaidmu");
    invaidp=(J(`nregions',`nbrands',1)-paidmu):/aidcost;
    ivinvaidp=(J(`nregions',`nbrands',1)-ivpaidmu):/ivaidcost;
    aidp=((J(`nregions',`nbrands',1):/invaidp)-pbar):/pbar;
    ivaidp=((J(`nregions',`nbrands',1):/ivinvaidp)-pbar):/pbar;
    meanaidcost=mean(aidcost,1);
    ivmeanaidcost=mean(ivaidcost,1);
    meanaidprice=mean(aidp,1);
    ivmeanaidprice=mean(ivaidp,1);
    medianaidprice=mm_median(aidp);
    ivmedianaidprice=mm_median(ivaidp);
end;    



/****************SOLVES UNDER LINEAR DEMAND*****************************/


#delimit cr
mata:
    B_reg=st_matrix("B_reg")
	B_light=st_matrix("B_light")
    V=(st_matrix("vbar1"),st_matrix("vbar2"),st_matrix("vbar3"),st_matrix("vbar4"),st_matrix("vbar5"),st_matrix("vbar6"),st_matrix("vbar7"),st_matrix("vbar8"),st_matrix("vbar9"),st_matrix("vbar10"),
	st_matrix("vbar11"),st_matrix("vbar12"),st_matrix("vbar13"),st_matrix("vbar14"),st_matrix("vbar15"),st_matrix("vbar16"),st_matrix("vbar17"),st_matrix("vbar18"),st_matrix("vbar19"),st_matrix("vbar20"),
	st_matrix("vbar21"),st_matrix("vbar22"),st_matrix("vbar23"),st_matrix("vbar24"),st_matrix("vbar25"),st_matrix("vbar26"),st_matrix("vbar27"),st_matrix("vbar28"),st_matrix("vbar29"),st_matrix("vbar30"),
	st_matrix("vbar31"),st_matrix("vbar32"),st_matrix("vbar33"),st_matrix("vbar34"),st_matrix("vbar35"),st_matrix("vbar36"),st_matrix("vbar37"),st_matrix("vbar38"),st_matrix("vbar39"),st_matrix("vbar40"),
	st_matrix("vbar41"),st_matrix("vbar42"),st_matrix("vbar43"),st_matrix("vbar44"),st_matrix("vbar45"),st_matrix("vbar46"),st_matrix("vbar47"))
	theta_reg=st_matrix("theta_reg")
	theta_light=st_matrix("theta_light")
	ldelta_mid=st_matrix("ldeltamid")
	lbeta_mid=st_matrix("lbetamid")
	ldelta_top=st_matrix("ldelta_top")
	lbeta_reg=st_matrix("lbeta_reg")
			
	
	a=J(9,47,0) 
    c=J(9,47,0)
    pbar=pbar'
	/*create intercepts for regular and then light*/
    for(i=1;i<=47;i++){
        a[1..5,i]=V[1..5,i]-B_reg*pbar[1..5,i]       
    }
	for(i=1;i<=47;i++){
        a[6..9,i]=V[6..9,i]-B_light*pbar[6..9,i]       
    }
	
	
	/*mata matuse c:/data/restat/analysis_data/post_prices, replace*/
	B=J(9,9,0)
	B[1..5,1..5]=B_reg
	B[6..9,6..9]=B_light
	/*Create slope matrix here, accounting for middle and upper levels of demand*/
	
	linfocs=J(47,9,0)
	mc=J(47,9,0)
	lfullp=J(47,9,0)
	for(j=1;j<=47;j++){
		D_pre=J(9,9,0)
		D_post=J(9,9,0)
		temp=J(9,9,0)
		for(i=1;i<=5;i++){
			D_pre[i,i]=B_reg[i,i]+theta_reg[i,1]*(ldelta_mid[1,1]*w_nest[j,i]+w[j,i]*ldelta_top*lbeta_mid[1,1])
		}
		for(i=6;i<=9;i++){
			D_pre[i,i]=B_light[i-5,i-5]+theta_light[i-5,1]*(ldelta_mid[2,2]*w_nest[j,i]+w[j,i]*ldelta_top*lbeta_mid[2,1])
		}
		D_pre[1,6]=theta_light[1,1]*(ldelta_mid[2,1]*w_nest[j,1]+w[j,1]*ldelta_top*lbeta_mid[2,1])
		D_pre[6,1]=theta_reg[1,1]*(ldelta_mid[1,2]*w_nest[j,6]+w[j,6]*ldelta_top*lbeta_mid[1,1])
		D_pre[2,7]=theta_light[2,1]*(ldelta_mid[2,1]*w_nest[j,2]+w[j,2]*ldelta_top*lbeta_mid[2,1])
		D_pre[7,2]=theta_reg[2,1]*(ldelta_mid[1,2]*w_nest[j,7]+w[j,7]*ldelta_top*lbeta_mid[1,1])
		D_pre[3,8]=theta_light[3,1]*(ldelta_mid[2,1]*w_nest[j,3]+w[j,3]*ldelta_top*lbeta_mid[2,1])
		D_pre[8,3]=theta_reg[3,1]*(ldelta_mid[1,2]*w_nest[j,8]+w[j,8]*ldelta_top*lbeta_mid[1,1])
		D_pre[4,9]=theta_light[4,1]*(ldelta_mid[2,1]*w_nest[j,4]+w[j,4]*ldelta_top*lbeta_mid[2,1])
		D_pre[9,4]=theta_reg[4,1]*(ldelta_mid[1,2]*w_nest[j,9]+w[j,9]*ldelta_top*lbeta_mid[1,1])
		
		temp[3,4]=B_reg[4,3]+theta_reg[4,1]*(ldelta_mid[1,1]*w_nest[j,3]+w[j,3]*ldelta_top*lbeta_mid[1,1])
		temp[4,3]=B_reg[3,4]+theta_reg[3,1]*(ldelta_mid[1,1]*w_nest[j,4]+w[j,4]*ldelta_top*lbeta_mid[1,1])
		temp[8,9]=B_light[4,3]+theta_light[4,1]*(ldelta_mid[2,2]*w_nest[j,8]+w[j,8]*ldelta_top*lbeta_mid[2,1])
		temp[9,8]=B_light[3,4]+theta_light[3,1]*(ldelta_mid[2,2]*w_nest[j,9]+w[j,9]*ldelta_top*lbeta_mid[2,1])
		
		temp[3,9]=theta_light[3,1]*(ldelta_mid[2,1]*w_nest[j,3]+w[j,3]*ldelta_top*lbeta_mid[2,1])
		temp[9,3]=theta_reg[3,1]*(ldelta_mid[1,2]*w_nest[j,9]+w[j,9]*ldelta_top*lbeta_mid[1,1])
		temp[4,8]=theta_light[4,1]*(ldelta_mid[2,1]*w_nest[j,4]+w[j,4]*ldelta_top*lbeta_mid[2,1])
		temp[8,4]=theta_reg[4,1]*(ldelta_mid[1,2]*w_nest[j,8]+w[j,8]*ldelta_top*lbeta_mid[1,1])
		
		D_post=temp+D_pre
		
		mcind=luinv(D_pre)*(a[.,j]+B*pbar[.,j]+D_pre*pbar[.,j])
		mc[j,.]=mcind'
		pind=luinv(B+D_post)*(D_post*mc[j,.]'-a[.,j])
		lfullp[j,.]=pind'
		/*linfocs[j,.]=(a[.,j]-D_post*mc[j,.]'+(B+D_post)*postpbar[j,.]')'*/
	}	
	linans=mm_median((lfullp-pbar'):/pbar')
	linfoc=mm_median(linfocs)
end




mata:
    ivB_reg=st_matrix("ivB_reg")
	ivB_light=st_matrix("ivB_light")
    V=(st_matrix("vbar1"),st_matrix("vbar2"),st_matrix("vbar3"),st_matrix("vbar4"),st_matrix("vbar5"),st_matrix("vbar6"),st_matrix("vbar7"),st_matrix("vbar8"),st_matrix("vbar9"),st_matrix("vbar10"),
	st_matrix("vbar11"),st_matrix("vbar12"),st_matrix("vbar13"),st_matrix("vbar14"),st_matrix("vbar15"),st_matrix("vbar16"),st_matrix("vbar17"),st_matrix("vbar18"),st_matrix("vbar19"),st_matrix("vbar20"),
	st_matrix("vbar21"),st_matrix("vbar22"),st_matrix("vbar23"),st_matrix("vbar24"),st_matrix("vbar25"),st_matrix("vbar26"),st_matrix("vbar27"),st_matrix("vbar28"),st_matrix("vbar29"),st_matrix("vbar30"),
	st_matrix("vbar31"),st_matrix("vbar32"),st_matrix("vbar33"),st_matrix("vbar34"),st_matrix("vbar35"),st_matrix("vbar36"),st_matrix("vbar37"),st_matrix("vbar38"),st_matrix("vbar39"),st_matrix("vbar40"),
	st_matrix("vbar41"),st_matrix("vbar42"),st_matrix("vbar43"),st_matrix("vbar44"),st_matrix("vbar45"),st_matrix("vbar46"),st_matrix("vbar47"))
	ivtheta_reg=st_matrix("ivtheta_reg")
	ivtheta_light=st_matrix("ivtheta_light")
	ivldelta_mid=st_matrix("livdeltamid")
	ivlbeta_mid=st_matrix("livbetamid")
	ivldelta_top=st_matrix("ivldelta_top")
	ivlbeta_reg=st_matrix("livbeta_reg")
		
	
	a=J(9,47,0) 
    c=J(9,47,0)
    
	/*create intercepts for regular and then light*/
    for(i=1;i<=47;i++){
        a[1..5,i]=V[1..5,i]-ivB_reg*pbar[1..5,i]       
    }
	for(i=1;i<=47;i++){
        a[6..9,i]=V[6..9,i]-ivB_light*pbar[6..9,i]       
    }
	
	ivB=J(9,9,0)
	ivB[1..5,1..5]=ivB_reg
	ivB[6..9,6..9]=ivB_light
	/*Create slope matrix here, accounting for middle and upper levels of demand*/
	
	
	ivmc=J(47,9,0)
	ivlfullp=J(47,9,0)
	for(j=1;j<=47;j++){
		ivD_pre=J(9,9,0)
		ivD_post=J(9,9,0)
		temp=J(9,9,0)
		for(i=1;i<=5;i++){
			ivD_pre[i,i]=ivB_reg[i,i]+ivtheta_reg[i,1]*(ivldelta_mid[1,1]*w_nest[j,i]+w[j,i]*ivldelta_top*ivlbeta_mid[1,1])
		}
		for(i=6;i<=9;i++){
			ivD_pre[i,i]=ivB_light[i-5,i-5]+ivtheta_light[i-5,1]*(ivldelta_mid[2,2]*w_nest[j,i]+w[j,i]*ivldelta_top*ivlbeta_mid[2,1])
		}
		ivD_pre[1,6]=ivtheta_light[1,1]*(ivldelta_mid[2,1]*w_nest[j,1]+w[j,1]*ivldelta_top*ivlbeta_mid[2,1])
		ivD_pre[6,1]=ivtheta_reg[1,1]*(ivldelta_mid[1, 2]*w_nest[j,6]+w[j,6]*ivldelta_top*ivlbeta_mid[1,1])
		ivD_pre[2,7]=ivtheta_light[2,1]*(ivldelta_mid[2,1]*w_nest[j,2]+w[j,2]*ivldelta_top*ivlbeta_mid[2,1])
		ivD_pre[7,2]=ivtheta_reg[2,1]*(ivldelta_mid[1,2]*w_nest[j,7]+w[j,7]*ivldelta_top*ivlbeta_mid[1,1])
		ivD_pre[3,8]=ivtheta_light[3,1]*(ivldelta_mid[2,1]*w_nest[j,3]+w[j,3]*ivldelta_top*ivlbeta_mid[2,1])
		ivD_pre[8,3]=ivtheta_reg[3,1]*(ivldelta_mid[1,2]*w_nest[j,8]+w[j,8]*ivldelta_top*ivlbeta_mid[1,1])
		ivD_pre[4,9]=ivtheta_light[4,1]*(ivldelta_mid[2,1]*w_nest[j,4]+w[j,4]*ivldelta_top*ivlbeta_mid[2,1])
		ivD_pre[9,4]=ivtheta_reg[4,1]*(ivldelta_mid[1,2]*w_nest[j,9]+w[j,9]*ivldelta_top*ivlbeta_mid[1,1])
		
		temp[3,4]=ivB_reg[4,3]+ivtheta_reg[4,1]*(ivldelta_mid[1,1]*w_nest[j,3]+w[j,3]*ivldelta_top*ivlbeta_mid[1,1])
		temp[4,3]=ivB_reg[3,4]+ivtheta_reg[3,1]*(ivldelta_mid[1,1]*w_nest[j,4]+w[j,4]*ivldelta_top*ivlbeta_mid[1,1])
		temp[8,9]=ivB_light[4,3]+ivtheta_light[4,1]*(ivldelta_mid[2,2]*w_nest[j,8]+w[j,8]*ivldelta_top*ivlbeta_mid[2,1])
		temp[9,8]=ivB_light[3,4]+ivtheta_light[3,1]*(ivldelta_mid[2,2]*w_nest[j,9]+w[j,9]*ivldelta_top*ivlbeta_mid[2,1])
		
		temp[3,9]=ivtheta_light[3,1]*(ivldelta_mid[2,1]*w_nest[j,3]+w[j,3]*ivldelta_top*ivlbeta_mid[2,1])
		temp[9,3]=ivtheta_reg[3,1]*(ivldelta_mid[1,2]*w_nest[j,9]+w[j,9]*ivldelta_top*ivlbeta_mid[1,1])
		temp[4,8]=ivtheta_light[4,1]*(ivldelta_mid[2,1]*w_nest[j,4]+w[j,4]*ivldelta_top*ivlbeta_mid[2,1])
		temp[8,4]=ivtheta_reg[4,1]*(ivldelta_mid[1,2]*w_nest[j,8]+w[j,8]*ivldelta_top*ivlbeta_mid[1,1])
		
		ivD_post=temp+ivD_pre
		
		ivmcind=luinv(ivD_pre)*(a[.,j]+ivB*pbar[.,j]+ivD_pre*pbar[.,j])
		ivmc[j,.]=ivmcind'
		ivpind=luinv(ivB+ivD_post)*(ivD_post*ivmc[j,.]'-a[.,j])
		ivlfullp[j,.]=ivpind'
		ivlinans=mm_median((ivlfullp-pbar'):/pbar')
	}	
end

/*this solves for the exact equilibrium for each model*/
#delimit cr
local nbrands=9
local nregions=47
mata:
	pbar=pbar'
	aidfullp=J(`nregions',`nbrands',0)
	check=J(`nregions',1,0)
    for(i=1;i<=`nregions';i++){
		a=csolve(&msyraids(),pbar[i,.]',1e-6,400,sbar[i,.]',pbar[i,.]',aidcost[i,.]',g_reg,g_light,b_reg,b_light,w[i,.]',w_nest[i,.]',X[i,.]',delta,beta,delta_top)		
        aidfullp[i,.]=a[1..`nbrands',.]'
        check[i,1]=((a[10,1]+(a[1..rows(a)-1,.]==J(rows(a)-1,1,.)))==0)
    }
    ans=(aidfullp-pbar):/pbar
    faids=mm_median(select(ans,check))    	
end


mata:
	ivaidfullp=J(`nregions',`nbrands',0)
	ivcheck=J(`nregions',1,0)
    for(i=1;i<=`nregions';i++){
		a=csolve(&msyraids(),pbar[i,.]',1e-6,400,sbar[i,.]',pbar[i,.]',ivaidcost[i,.]',ivg_reg,ivg_light,ivb_reg,ivb_light,w[i,.]',w_nest[i,.]',X[i,.]',ivdelta,ivbeta,ivdelta_top)		
        ivaidfullp[i,.]=a[1..`nbrands',.]'
		ivcheck[i,1]=((a[10,1]+(a[1..rows(a)-1,.]==J(rows(a)-1,1,.)))==0)    
    }
	
    ivans=(ivaidfullp-pbar):/pbar
    ivfaids=mm_median(select(ivans,ivcheck))    	
end

mata:
	linans
	ivlinans
	faids
	ivfaids
end:	



#delimit;
save syrstart, replace; 
drop _all;

#delimit;
/***Now that we have our point estimates of costs and approximate simulated price changes, we draw from asymptotic approx of distributions
of estimators and recalculate for each draw.  will look at empirical distribution of these calculated costs and changes to do inference.****/
drop _all;
/*number of bootstrap iterations*/
local its=1000;

local lin_reg "wexpreg1 wexpreg2 wexpreg3 wexpreg4 wexpreg5 `linplistreg' count11 count12 count13 count14 count15 bra11 bra12 bra13 bra14 bra15 `lMlist1' `lregionxbrand'";
local lin_light "wexplight21 wexplight22 wexplight23 wexplight24 `linplistlight' count21 count22 count23 count24 bra21 bra22 bra23 bra24 `lMlist2' `lregionxbrand2'";
local lin_mid "wexp1 wexp2 p1_1 p1_2 p2_1 p2_2 `femid' `Mlistmid' nest1 nest2 count1 count2";
local lin_top "lin_indexall M2 M3 M4 M5 M6 M7 M8 M9 count reg2 reg3 reg4 reg5 reg6 reg7 reg8 reg9 reg10 reg11 reg12 reg13 reg14 reg15 reg16 reg17 reg18 reg19 reg20 reg21 reg22 reg23 reg24 reg25 reg26 reg27 reg28 reg29 reg30 reg31 reg32 reg33 reg34 reg35 reg36 reg37 reg38 reg39 reg40 reg41 reg42 reg43 reg44 reg45 reg46 reg47 cons";

 

drawnorm `lin_reg', n(`its') mean(ivlinB) cov(ivlinVC);
drawnorm `lin_light', n(`its') mean(ivlinB2) cov(ivlinVC2); 
drawnorm `lin_mid', n(`its') mean(ivlinMidB) cov(ivlinMidVC);
drawnorm `lin_top', n(`its') mean(ivlin_b_top) cov(ivlin_vc_top);


#delimit;

forval x=1/5{;
	rename preg_`x'_AUNT_JEMIMA preg_`x'_1;
	rename preg_`x'_HUNGRY_JACK preg_`x'_2;
	rename preg_`x'_LOG_CABIN preg_`x'_3;
	rename preg_`x'_MRS_BUTTERWORTH preg_`x'_4;
	rename preg_`x'_PRIVATE_LABEL preg_`x'_5;
};


forval x=1/4{;
	rename plight_`x'_AUNT_JEMIMA_LIGHT plight_`x'_1;
	rename plight_`x'_JACK_LITE plight_`x'_2;
	rename plight_`x'_LOG_CABIN_LIGHT plight_`x'_3;
	rename plight_`x'_MRS_B_LITE plight_`x'_4;
};

drop count11-fe147_5 count21-fe247_4 fe1_2-nest2 M2-cons count1 count2;

#delimit;
local its=1000;
local nregions=47;
mkmat _all;

use syrstart, replace;
keep if merged==0;


/*bsbarx is a 7x`its' matrix with columns equal to the means of revenue shares taken over bootstrap subsamples
of region x.  bpbarx, bvbbarx defined similarly.*/

forval x=1/`nregions'{;
    mat bpbar`x'=J(9,`its',0);
	mat bvbar`x'=J(9,`its',0);
};

forval x=1/`nregions'{;
    forval w=1/`its'{;
        preserve;
            keep if reg`x'==1;
            bsample;
			
			forval y=1/`nbrands'{;
                qui sum wvol if bra`y'==1;
                matrix bvbar`x'[`y',`w']=_result(3);
                qui sum price if bra`y'==1;
                matrix bpbar`x'[`y',`w']=_result(3);
            };
        restore;
    };
};

#delimit;
local its=1000;
local nbrands=9;
local nregions=47;
local nbrands1=5;
local nbrands2=4;
#delimit cr
mata:
    bslincost=J(`its',9,0)
    bslinp=J(`its',9,0)
	bslinfocs=J(`its',9,0)
end

local its=1000

mata:
    bp1=st_matrix("bpbar1")
    bp2=st_matrix("bpbar2")
    bp3=st_matrix("bpbar3")
    bp4=st_matrix("bpbar4")
    bp5=st_matrix("bpbar5")
    bp6=st_matrix("bpbar6")
    bp7=st_matrix("bpbar7")
    bp8=st_matrix("bpbar8")
    bp9=st_matrix("bpbar9")
    bp10=st_matrix("bpbar10")
    bp11=st_matrix("bpbar11")
    bp12=st_matrix("bpbar12")
    bp13=st_matrix("bpbar13")
    bp14=st_matrix("bpbar14")
    bp15=st_matrix("bpbar15")
    bp16=st_matrix("bpbar16")
    bp17=st_matrix("bpbar17")
    bp18=st_matrix("bpbar18")
    bp19=st_matrix("bpbar19")
    bp20=st_matrix("bpbar20")
    bp21=st_matrix("bpbar21")
    bp22=st_matrix("bpbar22")
    bp23=st_matrix("bpbar23")
    bp24=st_matrix("bpbar24")
    bp25=st_matrix("bpbar25")
    bp26=st_matrix("bpbar26")
    bp27=st_matrix("bpbar27")
    bp28=st_matrix("bpbar28")
    bp29=st_matrix("bpbar29")
    bp30=st_matrix("bpbar30")
    bp31=st_matrix("bpbar31")
    bp32=st_matrix("bpbar32")
    bp33=st_matrix("bpbar33")
    bp34=st_matrix("bpbar34")
    bp35=st_matrix("bpbar35")
    bp36=st_matrix("bpbar36")
    bp37=st_matrix("bpbar37")
    bp38=st_matrix("bpbar38")
    bp39=st_matrix("bpbar39")
    bp40=st_matrix("bpbar40")
    bp41=st_matrix("bpbar41")
    bp42=st_matrix("bpbar42")
    bp43=st_matrix("bpbar43")
    bp44=st_matrix("bpbar44")
    bp45=st_matrix("bpbar45")
    bp46=st_matrix("bpbar46")
    bp47=st_matrix("bpbar47")

    ppoint=J(1,47,NULL)
    ppoint[1]=&bp1
    ppoint[2]=&bp2
    ppoint[3]=&bp3
    ppoint[4]=&bp4
    ppoint[5]=&bp5
    ppoint[6]=&bp6
    ppoint[7]=&bp7
    ppoint[8]=&bp8
    ppoint[9]=&bp9
    ppoint[10]=&bp10
    ppoint[11]=&bp11
    ppoint[12]=&bp12
    ppoint[13]=&bp13
    ppoint[14]=&bp14
    ppoint[15]=&bp15
    ppoint[16]=&bp16
    ppoint[17]=&bp17
    ppoint[18]=&bp18
    ppoint[19]=&bp19
    ppoint[20]=&bp20
    ppoint[21]=&bp21
    ppoint[22]=&bp22
    ppoint[23]=&bp23
    ppoint[24]=&bp24
    ppoint[25]=&bp25
    ppoint[26]=&bp26
    ppoint[27]=&bp27
    ppoint[28]=&bp28
    ppoint[29]=&bp29
    ppoint[30]=&bp30
    ppoint[31]=&bp31
    ppoint[32]=&bp32
    ppoint[33]=&bp33
    ppoint[34]=&bp34
    ppoint[35]=&bp35
    ppoint[36]=&bp36
    ppoint[37]=&bp37
    ppoint[38]=&bp38
    ppoint[39]=&bp39
    ppoint[40]=&bp40
    ppoint[41]=&bp41
    ppoint[42]=&bp42
    ppoint[43]=&bp43
    ppoint[44]=&bp44
    ppoint[45]=&bp45
    ppoint[46]=&bp46
    ppoint[47]=&bp47
    

        
    
    bv1=st_matrix("bvbar1")
    bv2=st_matrix("bvbar2")
    bv3=st_matrix("bvbar3")
    bv4=st_matrix("bvbar4")
    bv5=st_matrix("bvbar5")
    bv6=st_matrix("bvbar6")
    bv7=st_matrix("bvbar7")
    bv8=st_matrix("bvbar8")
    bv9=st_matrix("bvbar9")
    bv10=st_matrix("bvbar10")
    bv11=st_matrix("bvbar11")
    bv12=st_matrix("bvbar12")
    bv13=st_matrix("bvbar13")
    bv14=st_matrix("bvbar14")
    bv15=st_matrix("bvbar15")
    bv16=st_matrix("bvbar16")
    bv17=st_matrix("bvbar17")
    bv18=st_matrix("bvbar18")
    bv19=st_matrix("bvbar19")
    bv20=st_matrix("bvbar20")
    bv21=st_matrix("bvbar21")
    bv22=st_matrix("bvbar22")
    bv23=st_matrix("bvbar23")
    bv24=st_matrix("bvbar24")
    bv25=st_matrix("bvbar25")
    bv26=st_matrix("bvbar26")
    bv27=st_matrix("bvbar27")
    bv28=st_matrix("bvbar28")
    bv29=st_matrix("bvbar29")
    bv30=st_matrix("bvbar30")
    bv31=st_matrix("bvbar31")
    bv32=st_matrix("bvbar32")
    bv33=st_matrix("bvbar33")
    bv34=st_matrix("bvbar34")
    bv35=st_matrix("bvbar35")
    bv36=st_matrix("bvbar36")
    bv37=st_matrix("bvbar37")
    bv38=st_matrix("bvbar38")
    bv39=st_matrix("bvbar39")
    bv40=st_matrix("bvbar40")
	bv41=st_matrix("bvbar41")
    bv42=st_matrix("bvbar42")
    bv43=st_matrix("bvbar43")
    bv44=st_matrix("bvbar44")
    bv45=st_matrix("bvbar45")
    bv46=st_matrix("bvbar46")
    bv47=st_matrix("bvbar47")
	
	
    vpoint=J(1,47,NULL)
    vpoint[1]=&bv1
    vpoint[2]=&bv2
    vpoint[3]=&bv3
    vpoint[4]=&bv4
    vpoint[5]=&bv5
    vpoint[6]=&bv6
    vpoint[7]=&bv7
    vpoint[8]=&bv8
    vpoint[9]=&bv9
    vpoint[10]=&bv10
    vpoint[11]=&bv11
    vpoint[12]=&bv12
    vpoint[13]=&bv13
    vpoint[14]=&bv14
    vpoint[15]=&bv15
    vpoint[16]=&bv16
    vpoint[17]=&bv17
    vpoint[18]=&bv18
    vpoint[19]=&bv19
    vpoint[20]=&bv20
    vpoint[21]=&bv21
    vpoint[22]=&bv22
    vpoint[23]=&bv23
    vpoint[24]=&bv24
    vpoint[25]=&bv25
    vpoint[26]=&bv26
    vpoint[27]=&bv27
    vpoint[28]=&bv28
    vpoint[29]=&bv29
    vpoint[30]=&bv30
    vpoint[31]=&bv31
    vpoint[32]=&bv32
    vpoint[33]=&bv33
    vpoint[34]=&bv34
    vpoint[35]=&bv35
    vpoint[36]=&bv36
    vpoint[37]=&bv37
    vpoint[38]=&bv38
    vpoint[39]=&bv39
    vpoint[40]=&bv40
    vpoint[41]=&bv41
    vpoint[42]=&bv42
    vpoint[43]=&bv43
    vpoint[44]=&bv44
    vpoint[45]=&bv45
    vpoint[46]=&bv46
    vpoint[47]=&bv47

	

    wexpreg1=st_matrix("wexpreg1")
    wexpreg2=st_matrix("wexpreg2")
    wexpreg3=st_matrix("wexpreg3")
    wexpreg4=st_matrix("wexpreg4")
    wexpreg5=st_matrix("wexpreg5")
	wexplight21=st_matrix("wexplight21")
    wexplight22=st_matrix("wexplight22")
    wexplight23=st_matrix("wexplight23")
    wexplight24=st_matrix("wexplight24")

    preg_1_1=st_matrix("preg_1_1")
    preg_2_1=st_matrix("preg_2_1")
    preg_3_1=st_matrix("preg_3_1")
    preg_4_1=st_matrix("preg_4_1")
    preg_5_1=st_matrix("preg_5_1")
	
	preg_1_2=st_matrix("preg_1_2")
    preg_2_2=st_matrix("preg_2_2")
    preg_3_2=st_matrix("preg_3_2")
    preg_4_2=st_matrix("preg_4_2")
    preg_5_2=st_matrix("preg_5_2")
	
	preg_1_3=st_matrix("preg_1_3")
    preg_2_3=st_matrix("preg_2_3")
    preg_3_3=st_matrix("preg_3_3")
    preg_4_3=st_matrix("preg_4_3")
    preg_5_3=st_matrix("preg_5_3")
	
	preg_1_4=st_matrix("preg_1_4")
    preg_2_4=st_matrix("preg_2_4")
    preg_3_4=st_matrix("preg_3_4")
    preg_4_4=st_matrix("preg_4_4")
    preg_5_4=st_matrix("preg_5_4")
	
	preg_1_5=st_matrix("preg_1_5")
    preg_2_5=st_matrix("preg_2_5")
    preg_3_5=st_matrix("preg_3_5")
    preg_4_5=st_matrix("preg_4_5")
    preg_5_5=st_matrix("preg_5_5")
	
	plight_1_1=st_matrix("plight_1_1")
    plight_2_1=st_matrix("plight_2_1")
    plight_3_1=st_matrix("plight_3_1")
    plight_4_1=st_matrix("plight_4_1")
	
	plight_1_2=st_matrix("plight_1_2")
    plight_2_2=st_matrix("plight_2_2")
    plight_3_2=st_matrix("plight_3_2")
    plight_4_2=st_matrix("plight_4_2")

	plight_1_3=st_matrix("plight_1_3")
    plight_2_3=st_matrix("plight_2_3")
    plight_3_3=st_matrix("plight_3_3")
    plight_4_3=st_matrix("plight_4_3")

	plight_1_4=st_matrix("plight_1_4")
    plight_2_4=st_matrix("plight_2_4")
    plight_3_4=st_matrix("plight_3_4")
    plight_4_4=st_matrix("plight_4_4")
	
	p1_1=st_matrix("p1_1")
	p1_2=st_matrix("p1_2")
	p2_1=st_matrix("p2_1")
	p2_2=st_matrix("p2_2")
	
	wexp1=st_matrix("wexp1")
	wexp2=st_matrix("wexp2")
	lin_indexall=st_matrix("lin_indexall")
	w=st_matrix("w")	
	w_nest=st_matrix("w_nest")	
	
	wnest=st_matrix("wnest")	
	w_all=st_matrix("wall")	
end

drop _all

mata:
    e1j=J(1000,9,0)
    e2j=J(1000,9,0)
    e3j=J(1000,9,0)
    e4j=J(1000,9,0)
    e5j=J(1000,9,0)
    e6j=J(1000,9,0)
    e7j=J(1000,9,0)
    e8j=J(1000,9,0)
    e9j=J(1000,9,0)
	
for(z=1;z<=1000;z++){
	B_reg=(preg_1_1[z,1],preg_1_2[z,1],preg_1_3[z,1],preg_1_4[z,1],preg_1_5[z,1]
	\preg_2_1[z,1],preg_2_2[z,1],preg_2_3[z,1],preg_2_4[z,1],preg_2_5[z,1]  
	\preg_3_1[z,1],preg_3_3[z,1],preg_3_3[z,1],preg_3_4[z,1],preg_3_5[z,1]  
	\preg_4_1[z,1],preg_4_4[z,1],preg_4_3[z,1],preg_4_4[z,1],preg_4_5[z,1]  
	\preg_5_1[z,1],preg_5_5[z,1],preg_5_3[z,1],preg_5_4[z,1],preg_5_5[z,1])

	B_light=(plight_1_1[z,1],plight_1_2[z,1],plight_1_3[z,1],plight_1_4[z,1]
	\plight_2_1[z,1],plight_2_2[z,1],plight_2_3[z,1],plight_2_4[z,1]  
	\plight_3_1[z,1],plight_3_3[z,1],plight_3_3[z,1],plight_3_4[z,1]  
	\plight_4_1[z,1],plight_4_4[z,1],plight_4_3[z,1],plight_4_4[z,1])
	
	theta_reg=(wexpreg1[z,1]\wexpreg2[z,1]\wexpreg3[z,1]\wexpreg4[z,1]\wexpreg5[z,1])
	theta_light=(wexplight21[z,1]\wexplight22[z,1]\wexplight23[z,1]\wexplight24[z,1])
	ldelta_mid=(p1_1[z,1], p1_2[z,1]\p2_1[z,1], p2_2[z,1])
	lbeta_mid=(wexp1[z,1]\wexp2[z,1])
	ldelta_top=lin_indexall[z,1]
	
	
	
	V=J(9,47,0)
	for(j=1;j<=47;j++){           
		V[.,j]=(*vpoint[j])[.,z]
	}	         
	
    pbar=J(9,47,0)
	for(j=1;j<=47;j++){           
		pbar[.,j]=(*ppoint[j])[.,z]
	}	         
	s=mean(V',1)
	w1=s[1..5]'
	w2=s[6..9]'
	p=mean(pbar',1)
	p1=p[1..5]'
	p2=p[6..9]'
	wnest1=wnest[1..5]
	wnest2=wnest[6..9]
	w_all1=w_all[1..5]
	w_all2=w_all[6..9]
	
	
	ereg=J(5,5,0)
	elight=J(4,4,0)
	ereg_light=J(5,4,0)
	elight_reg=J(4,5,0)
	
	/*need to get avgw`y'reg avgw`y'reg_all*/
	
	for(m=1;m<=5;m++){
		for(n=1;n<=5;n++){
			ereg[m,n]=(p1[n]/w1[m])*(B_reg[m,n]+theta_reg[m]*(ldelta_mid[1,1]*wnest1[n]+w_all1[n]*lbeta_mid[1,1]*ldelta_top[1,1]));
		}
	}
	
	for(m=1;m<=4;m++){
		for(n=1;n<=4;n++){
			elight[m,n]=(p2[n]/w2[m])*(B_light[m,n]+theta_light[m]*(ldelta_mid[2,2]*wnest2[n]+w_all2[n]*lbeta_mid[2,1]*ldelta_top[1,1]));
		}
	}

 
/*across nest elasticities*/
	for(m=1;m<=5;m++){
		for(n=1;n<=4;n++){
			ereg_light[m,n]=(p2[n]/w1[m])*(theta_reg[m]*(ldelta_mid[1,2]*wnest2[n]+lbeta_mid[1,1]*ldelta_top[1,1]*w_all2[n]));
		}
	}

	for(m=1;m<=4;m++){
		for(n=1;n<=5;n++){
			elight_reg[m,n]=(p1[n]/w2[m])*(theta_light[m]*(ldelta_mid[2,1]*wnest1[n]+lbeta_mid[2,1]*ldelta_top[1,1]*w_all1[n] ));
		}
	}

		e1j[z,1]=ereg[1,1]
		e1j[z,2]=ereg[1,2]
		e1j[z,3]=ereg[1,3]
		e1j[z,4]=ereg[1,4]
		e1j[z,5]=ereg[1,5]
		e1j[z,6]=ereg_light[1,1]
		e1j[z,7]=ereg_light[1,2]
		e1j[z,8]=ereg_light[1,3]
		e1j[z,9]=ereg_light[1,4]
		
		e2j[z,1]=ereg[2,1]
		e2j[z,2]=ereg[2,2]
		e2j[z,3]=ereg[2,3]
		e2j[z,4]=ereg[2,4]
		e2j[z,5]=ereg[2,5]
		e2j[z,6]=ereg_light[2,1]
		e2j[z,7]=ereg_light[2,2]
		e2j[z,8]=ereg_light[2,3]
		e2j[z,9]=ereg_light[2,4]
		
		e3j[z,1]=ereg[3,1]
		e3j[z,2]=ereg[3,2]
		e3j[z,3]=ereg[3,3]
		e3j[z,4]=ereg[3,4]
		e3j[z,5]=ereg[3,5]
		e3j[z,6]=ereg_light[3,1]
		e3j[z,7]=ereg_light[3,2]
		e3j[z,8]=ereg_light[3,3]
		e3j[z,9]=ereg_light[3,4]
		
		e4j[z,1]=ereg[4,1]
		e4j[z,2]=ereg[4,2]
		e4j[z,3]=ereg[4,3]
		e4j[z,4]=ereg[4,4]
		e4j[z,5]=ereg[4,5]
		e4j[z,6]=ereg_light[4,1]
		e4j[z,7]=ereg_light[4,2]
		e4j[z,8]=ereg_light[4,3]
		e4j[z,9]=ereg_light[4,4]
		
		e5j[z,1]=ereg[5,1]
		e5j[z,2]=ereg[5,2]
		e5j[z,3]=ereg[5,3]
		e5j[z,4]=ereg[5,4]
		e5j[z,5]=ereg[5,5]
		e5j[z,6]=ereg_light[5,1]
		e5j[z,7]=ereg_light[5,2]
		e5j[z,8]=ereg_light[5,3]
		e5j[z,9]=ereg_light[5,4]
		
		e6j[z,1]=elight_reg[1,1]
		e6j[z,2]=elight_reg[1,2]
		e6j[z,3]=elight_reg[1,3]
		e6j[z,4]=elight_reg[1,4]
		e6j[z,5]=elight_reg[1,5]
		e6j[z,6]=elight[1,1]
		e6j[z,7]=elight[1,2]
		e6j[z,8]=elight[1,3]
		e6j[z,9]=elight[1,4]
		
		e7j[z,1]=elight_reg[2,1]
		e7j[z,2]=elight_reg[2,2]
		e7j[z,3]=elight_reg[2,3]
		e7j[z,4]=elight_reg[2,4]
		e7j[z,5]=elight_reg[2,5]
		e7j[z,6]=elight[2,1]
		e7j[z,7]=elight[2,2]
		e7j[z,8]=elight[2,3]
		e7j[z,9]=elight[2,4]
		
		e8j[z,1]=elight_reg[3,1]
		e8j[z,2]=elight_reg[3,2]
		e8j[z,3]=elight_reg[3,3]
		e8j[z,4]=elight_reg[3,4]
		e8j[z,5]=elight_reg[3,5]
		e8j[z,6]=elight[3,1]
		e8j[z,7]=elight[3,2]
		e8j[z,8]=elight[3,3]
		e8j[z,9]=elight[3,4]
		
		e9j[z,1]=elight_reg[4,1]
		e9j[z,2]=elight_reg[4,2]
		e9j[z,3]=elight_reg[4,3]
		e9j[z,4]=elight_reg[4,4]
		e9j[z,5]=elight_reg[4,5]
		e9j[z,6]=elight[4,1]
		e9j[z,7]=elight[4,2]
		e9j[z,8]=elight[4,3]
		e9j[z,9]=elight[4,4]
		
		
}
mean(e1j)
mean(e2j)
mean(e3j)				      
mean(e4j)
mean(e5j)
mean(e6j)
mean(e7j)				      
mean(e8j)
mean(e9j)

aidsolselas=J(9,9,0)

aidsolselas[1,.]=sqrt(mean(e1j:*e1j)-mean(e1j):*mean(e1j))				      
aidsolselas[2,.]=sqrt(mean(e2j:*e2j)-mean(e2j):*mean(e2j))				      
aidsolselas[3,.]=sqrt(mean(e3j:*e3j)-mean(e3j):*mean(e3j))
aidsolselas[4,.]=sqrt(mean(e4j:*e4j)-mean(e4j):*mean(e4j))
aidsolselas[5,.]=sqrt(mean(e5j:*e5j)-mean(e5j):*mean(e5j))				      
aidsolselas[6,.]=sqrt(mean(e6j:*e6j)-mean(e6j):*mean(e6j))				      
aidsolselas[7,.]=sqrt(mean(e7j:*e7j)-mean(e7j):*mean(e7j))				      
aidsolselas[8,.]=sqrt(mean(e8j:*e8j)-mean(e8j):*mean(e8j))				      
aidsolselas[9,.]=sqrt(mean(e9j:*e9j)-mean(e9j):*mean(e9j))				      				      

end



mata:
 for(z=1;z<=1000;z++){
        /*makes price coefficient matrix for each draw*/
	B_reg=(preg_1_1[z,1],preg_1_2[z,1],preg_1_3[z,1],preg_1_4[z,1],preg_1_5[z,1]
	\preg_2_1[z,1],preg_2_2[z,1],preg_2_3[z,1],preg_2_4[z,1],preg_2_5[z,1]  
	\preg_3_1[z,1],preg_3_3[z,1],preg_3_3[z,1],preg_3_4[z,1],preg_3_5[z,1]  
	\preg_4_1[z,1],preg_4_4[z,1],preg_4_3[z,1],preg_4_4[z,1],preg_4_5[z,1]  
	\preg_5_1[z,1],preg_5_5[z,1],preg_5_3[z,1],preg_5_4[z,1],preg_5_5[z,1])

	B_light=(plight_1_1[z,1],plight_1_2[z,1],plight_1_3[z,1],plight_1_4[z,1]
	\plight_2_1[z,1],plight_2_2[z,1],plight_2_3[z,1],plight_2_4[z,1]  
	\plight_3_1[z,1],plight_3_3[z,1],plight_3_3[z,1],plight_3_4[z,1]  
	\plight_4_1[z,1],plight_4_4[z,1],plight_4_3[z,1],plight_4_4[z,1])

	V=J(9,47,0)
	for(j=1;j<=47;j++){           
		V[.,j]=(*vpoint[j])[.,z]
	}	         
	
	theta_reg=(wexpreg1[z,1]\wexpreg2[z,1]\wexpreg3[z,1]\wexpreg4[z,1]\wexpreg5[z,1])
	theta_light=(wexplight21[z,1]\wexplight22[z,1]\wexplight23[z,1]\wexplight24[z,1])
	ldelta_mid=(p1_1[z,1], p1_2[z,1]\p2_1[z,1], p2_2[z,1])
	lbeta_mid=(wexp1[z,1]\wexp2[z,1])
	ldelta_top=lin_indexall[z,1]
	
		
	
	
    pbar=J(9,47,0)
	for(j=1;j<=47;j++){           
		pbar[.,j]=(*ppoint[j])[.,z]
	}	         
	
	
	/*create intercepts for regular and then light*/
    a=J(9,47,0) 
	for(i=1;i<=47;i++){
        a[1..5,i]=V[1..5,i]-B_reg*pbar[1..5,i]       
    }
	for(i=1;i<=47;i++){
        a[6..9,i]=V[6..9,i]-B_light*pbar[6..9,i]       
    }
   B=J(9,9,0)
	B[1..5,1..5]=B_reg
	B[6..9,6..9]=B_light
	/*Create slope matrix here, accounting for middle and upper levels of demand*/
	
	
	mc=J(47,9,0)
	lfullp=J(47,9,0)
	focs=J(47,9,0)
	for(j=1;j<=47;j++){
		D_pre=J(9,9,0)
		D_post=J(9,9,0)
		temp=J(9,9,0)
		for(i=1;i<=5;i++){
			D_pre[i,i]=B_reg[i,i]+theta_reg[i,1]*(ldelta_mid[1,1]*w_nest[j,i]+w[j,i]*ldelta_top*lbeta_mid[1,1])
		}
		for(i=6;i<=9;i++){
			D_pre[i,i]=B_light[i-5,i-5]+theta_light[i-5,1]*(ldelta_mid[2,2]*w_nest[j,i]+w[j,i]*ldelta_top*lbeta_mid[2,1])
		}
		D_pre[1,6]=theta_light[1,1]*(ldelta_mid[2,1]*w_nest[j,1]+w[j,1]*ldelta_top*lbeta_mid[2,1])
		D_pre[6,1]=theta_reg[1,1]*(ldelta_mid[1,2]*w_nest[j,6]+w[j,6]*ldelta_top*lbeta_mid[1,1])
		D_pre[2,7]=theta_light[2,1]*(ldelta_mid[2,1]*w_nest[j,2]+w[j,2]*ldelta_top*lbeta_mid[2,1])
		D_pre[7,2]=theta_reg[2,1]*(ldelta_mid[1,2]*w_nest[j,7]+w[j,7]*ldelta_top*lbeta_mid[1,1])
		D_pre[3,8]=theta_light[3,1]*(ldelta_mid[2,1]*w_nest[j,3]+w[j,3]*ldelta_top*lbeta_mid[2,1])
		D_pre[8,3]=theta_reg[3,1]*(ldelta_mid[1,2]*w_nest[j,8]+w[j,8]*ldelta_top*lbeta_mid[1,1])
		D_pre[4,9]=theta_light[4,1]*(ldelta_mid[2,1]*w_nest[j,4]+w[j,4]*ldelta_top*lbeta_mid[2,1])
		D_pre[9,4]=theta_reg[4,1]*(ldelta_mid[1,2]*w_nest[j,9]+w[j,9]*ldelta_top*lbeta_mid[1,1])
		
		temp[3,4]=B_reg[4,3]+theta_reg[4,1]*(ldelta_mid[1,1]*w_nest[j,3]+w[j,3]*ldelta_top*lbeta_mid[1,1])
		temp[4,3]=B_reg[3,4]+theta_reg[3,1]*(ldelta_mid[1,1]*w_nest[j,4]+w[j,4]*ldelta_top*lbeta_mid[1,1])
		temp[8,9]=B_light[4,3]+theta_light[4,1]*(ldelta_mid[2,2]*w_nest[j,8]+w[j,8]*ldelta_top*lbeta_mid[2,1])
		temp[9,8]=B_light[3,4]+theta_light[3,1]*(ldelta_mid[2,2]*w_nest[j,9]+w[j,9]*ldelta_top*lbeta_mid[2,1])
		
		temp[3,9]=theta_light[3,1]*(ldelta_mid[2,1]*w_nest[j,3]+w[j,3]*ldelta_top*lbeta_mid[2,1])
		temp[9,3]=theta_reg[3,1]*(ldelta_mid[1,2]*w_nest[j,9]+w[j,9]*ldelta_top*lbeta_mid[1,1])
		temp[4,8]=theta_light[4,1]*(ldelta_mid[2,1]*w_nest[j,4]+w[j,4]*ldelta_top*lbeta_mid[2,1])
		temp[8,4]=theta_reg[4,1]*(ldelta_mid[1,2]*w_nest[j,8]+w[j,8]*ldelta_top*lbeta_mid[1,1])
		
		D_post=temp+D_pre
				
		mcind=luinv(D_pre)*(a[.,j]+B*pbar[.,j]+D_pre*pbar[.,j])
		mc[j,.]=mcind'
		pind=luinv(B+D_post)*(D_post*mc[j,.]'-a[.,j])
		lfullp[j,.]=pind'
		linfocs[j,.]=(a[.,j]-D_post*mc[j,.]'+(B+D_post)*postdirect[j,.]')'
	}	
linans=mm_median((lfullp-pbar'):/pbar')	
linfoc=mm_median(linfocs)
bslinp[z,.]=linans	
bslinfocs[z,.]=linfoc   
}   
st_matrix("bslinfocs",bslinfocs)
st_matrix("bslinp",bslinp)
end

svmat bslinp
log using syrtable2col6, replace
centile bslinp1, centile(2.5, 97.5)
centile bslinp2, centile(2.5, 97.5)
centile bslinp3, centile(2.5, 97.5)
centile bslinp4, centile(2.5, 97.5)
centile bslinp5, centile(2.5, 97.5)
centile bslinp6, centile(2.5, 97.5)
centile bslinp7, centile(2.5, 97.5)
centile bslinp8, centile(2.5, 97.5)
centile bslinp9, centile(2.5, 97.5)

svmat bslinfocs
centile bslinfocs1, centile(2.5, 97.5)
centile bslinfocs2, centile(2.5, 97.5)
centile bslinfocs3, centile(2.5, 97.5)
centile bslinfocs4, centile(2.5, 97.5)
centile bslinfocs5, centile(2.5, 97.5)
centile bslinfocs6, centile(2.5, 97.5)
centile bslinfocs7, centile(2.5, 97.5)
centile bslinfocs8, centile(2.5, 97.5)
centile bslinfocs9, centile(2.5, 97.5)


log close


save c:\data\restat_12_9\bootstrap_results\ivlin, replace
