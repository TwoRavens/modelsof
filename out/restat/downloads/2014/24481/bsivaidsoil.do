/*THIS ESTIMATES DEMAND FOR OILS USING HAUSMAN INSTRUMENTS.  
IN THIS VARIANT, EACH PRICE IS REGRESSED ON ALL OTHER REGIONS PRICES IN THE FIRST STAGE.  THERE COEFFICIENTS ON EACH REGION'S PRICE IS UNCONSTRAINED*/

set more off
#delimit;
cap log close;
clear all;
set matsize 1000;
cap set mem 1200m;
set seed 10161978;



*use postoilmaster;
local path "c:/data/restat_12_9/analysis_data";

local estimator "newey2";
local ivestimator "newey2";
local lags "lag(4)";
local opt "se 3aster bd(2) td(2)";
local nbrands=7;
local nregions=10; 
local list "CASTROL HAVOLINE MOBIL PENNZOIL PRIVATE QUAKER VALVOLINE";


do c:\data\restat_12_9\programs\csolve_do\csolve;
do c:\data\restat_12_9\programs\csolve_do\callf;
do c:\data\restat_12_9\programs\csolve_do\callf_setup;
do c:\data\restat_12_9\programs\csolve_do\sixaids;

use "`path'/oilmaster";


sort REGION BRAND year month day;
bysort REGION BRAND: gen T=_n;

sort T REGION BRAND;
/*separate id for each brand/region combo*/
bysort T: gen id=_n;
qui tab month, gen(M);
qui tab year, gen(year);

foreach y of local list{;
	forval x=1/6{;
		local reglist "`reglist' lprice_`x'_`y'";
		local ivreglist "`ivreglist' ivlprice_`x'_`y'";
	};
};

/*this creates 10 region dummies, one for each of the 7 share equations*/
forval  x=2/`nregions'{;
	forval y=1/`nbrands'{;
		gen fe`x'_`y'=reg`x'*bra`y';
	};
};

forval  x=2/`nregions'{;
	forval y=1/6{;
		local regionxbrand "`regionxbrand' fe`x'_`y'";
	};
};



forval x=2/12{;
	forval y=1/`nbrands'{;
		gen M`x'b`y'=M`x'*bra`y';
	};
};

forval x=1/6{;
	gen ivlaidp`x'=ivlaidp*bra`x';
};
forval x=1/6{;
	gen laidp`x'=laidp*bra`x';
};
forval x=1/7{;
	gen exp`x'=exp*bra`x';
	gen ivexp`x'=ivexp*bra`x';
};


forval x=2/12{;
	forval y=1/6{;
		local Mlist "`Mlist' M`x'b`y'";
	};
};

forval x=1/`nbrands'{;
	gen count`x'=T*bra`x';
};


/*unconstrained model*/
encode REGION, gen(reg);
tsset id T;
qui compress;
`estimator' share laidp1 laidp2 laidp3 laidp4 laidp5 laidp6 `reglist' `Mlist' `regionxbrand' bra1-bra6 count1-count6 if BRAND~="VALVOLINE", nocon `lags';



mat aidB=e(b);
mat aidVC=e(V);
forval x=1/6{;
	scalar b`x'=_coef[laidp`x'];
};
scalar b7=-b1-b2-b3-b4-b5-b6;
forval x=1/6{;
	foreach y of local list{;
		scalar g`x'p`y'=_coef[lprice_`x'_`y'];
	};
};
foreach y of local list{;
	scalar g7p`y'=-_coef[lprice_1_`y']-_coef[lprice_2_`y']-_coef[lprice_3_`y']-_coef[lprice_4_`y']-_coef[lprice_5_`y']-_coef[lprice_6_`y'];
};

forval x=1/7{;
	scalar g`x'p1=g`x'pCASTROL;
	scalar g`x'p2=g`x'pHAVOLINE;
	scalar g`x'p3=g`x'pMOBIL;
	scalar g`x'p4=g`x'pPENNZOIL;
	scalar g`x'p5=g`x'pPRIVATE;
	scalar g`x'p6=g`x'pQUAKER;
	scalar g`x'p7=g`x'pVALVOLINE;
};	

forval x=1/`nbrands'{;
	sum share if bra`x'==1;
	scalar s`x'=r(mean);
};	

ivregress 2sls share `Mlist' `regionxbrand' bra1-bra6 count1-count6 (laidp1 laidp2 laidp3 laidp4 laidp5 laidp6 `reglist'=ivlaidp1 ivlaidp2 ivlaidp3 ivlaidp4 ivlaidp5 ivlaidp6 `ivreglist') if BRAND~="VALVOLINE", nocon;

estat firststage;

`ivestimator' share `Mlist' `regionxbrand' bra1-bra6 count1-count6 (laidp1 laidp2 laidp3 laidp4 laidp5 laidp6 `reglist'=ivlaidp1 ivlaidp2 ivlaidp3 ivlaidp4 ivlaidp5 ivlaidp6 `ivreglist') if BRAND~="VALVOLINE", nocon `lags';
matrix ivaidB=e(b);
matrix ivaidVC=e(V);
forval x=1/6{;
	scalar ivb`x'=_coef[laidp`x'];
};
scalar ivb7=-ivb1-ivb2-ivb3-ivb4-ivb5-ivb6;

forval x=1/6{;
	foreach y of local list{;
		scalar ivg`x'p`y'=_coef[lprice_`x'_`y'];
	};
};

foreach y of local list{;
		scalar ivg7p`y'=-_coef[lprice_1_`y']-_coef[lprice_2_`y']-_coef[lprice_3_`y']-_coef[lprice_4_`y']-_coef[lprice_5_`y']-_coef[lprice_6_`y'];
};

forval x=1/7{;
	scalar ivg`x'p1=ivg`x'pCASTROL;
	scalar ivg`x'p2=ivg`x'pHAVOLINE;
	scalar ivg`x'p3=ivg`x'pMOBIL;
	scalar ivg`x'p4=ivg`x'pPENNZOIL;
	scalar ivg`x'p5=ivg`x'pPRIVATE;
	scalar ivg`x'p6=ivg`x'pQUAKER;
	scalar ivg`x'p7=ivg`x'pVALVOLINE;
};	

gen wvol=vol/POP;
forval x=1/7{;
	gen wexp`x'=exp`x'/POP;
};

foreach y of local list{;
	forval x=1/7{;
		local linplist "`linplist' price_`x'_`y'";
	};
};

foreach y of local list{;
	forval x=1/7{;
		local ivlinplist "`ivlinplist' ivprice_`x'_`y'";
	};
};

forval x=2/10{;
	forval y=1/7{;
		local lregionxbrand "`lregionxbrand' fe`x'_`y'";
	};
};

local lMlist "`Mlist' M2b7 M3b7 M4b7 M5b7 M6b7 M7b7 M8b7 M9b7 M10b7 M11b7 M12b7";

`estimator' wvol count1-count7 bra1-bra7 `lMlist' `lregionxbrand' wexp1-wexp7 `linplist', nocon `lags';
matrix linB=e(B);
matrix linVC=e(V);
forval x=1/7{;
		scalar p_`x'_1=_coef[price_`x'_CASTROL];
		scalar p_`x'_2=_coef[price_`x'_HAVOLINE];
		scalar p_`x'_3=_coef[price_`x'_MOBIL];
		scalar p_`x'_4=_coef[price_`x'_PENNZOIL];
		scalar p_`x'_5=_coef[price_`x'_PRIVATE];
		scalar p_`x'_6=_coef[price_`x'_QUAKER];
		scalar p_`x'_7=_coef[price_`x'_VALVOLINE];
};	

forval x=1/7{;
	forval y=1/7{;
		scalar linb`x'p`y'=p_`x'_`y';
	};
};

mat B=J(7,7,0);
forval x=1/7{;
	forval y=1/7{;
		mat B[`x',`y']=linb`x'p`y';
	};
};

mat theta=J(7,1,0);
forval x=1/7{;
		mat theta[`x',1]=_coef[wexp`x'];		
};
forval x=1/7{;
		sca theta`x'=_coef[wexp`x'];		
};


forval x=1/7{;
	sum price if bra`x'==1;
	scalar p`x'=r(mean);
};	

forval x=1/7{;
	sum wvol if bra`x'==1;
	scalar w`x'=r(mean);
};

`ivestimator' wvol count1-count7 bra1-bra7 `lMlist' `lregionxbrand' (wexp1-wexp7 `linplist'=ivwexp1-ivwexp7 `ivlinplist'), nocon `lags';
matrix ivlinB=e(b);
matrix ivlinVC=e(V);
forval x=1/7{;
		scalar ivp_`x'_1=_coef[price_`x'_CASTROL];
		scalar ivp_`x'_2=_coef[price_`x'_HAVOLINE];
		scalar ivp_`x'_3=_coef[price_`x'_MOBIL];
		scalar ivp_`x'_4=_coef[price_`x'_PENNZOIL];
		scalar ivp_`x'_5=_coef[price_`x'_PRIVATE];
		scalar ivp_`x'_6=_coef[price_`x'_QUAKER];
		scalar ivp_`x'_7=_coef[price_`x'_VALVOLINE];
};	

forval x=1/7{;
	forval y=1/7{;
		scalar ivlinb`x'p`y'=ivp_`x'_`y';
	};
};

mat ivB=J(7,7,0);
forval x=1/7{;
	forval y=1/7{;
		mat ivB[`x',`y']=ivlinb`x'p`y';
	};
};
mat ivtheta=J(7,1,0);
forval x=1/7{;
	mat ivtheta[`x',1]=_coef[wexp`x'];
};
forval x=1/7{;
	sca ivtheta`x'=_coef[wexp`x'];
};
save temp, replace;
/*CREATE DATASET FOR TOP LEVEL OF DEMAND*/
/*An observation is a time period/region.  Need the following variables: lqall M2-M12 reg2-reg10 count indexall ivindexall*/
drop POP-brand7 ivlaidp ivlexp ivexp  lprice_1_CASTROL-ivprice_7_VALVOLINE ivwexp-ivwexp7 id fe2_1-fe10_7 year1-wexp7;
duplicates drop;
gen i=0;
forval x=1/10{;
	replace i=`x' if reg`x'==1;
};
bysort i: gen count=_n;
tsset i count;
/*top for aids model*/
`ivestimator' laidp M2-M12 reg2-reg10 T (indexall=ivindexall), `lags';
scalar ivdelta_top=_coef[indexall];
mat ivaids_top=_coef[indexall];
matrix iv_b_top=e(b);
matrix iv_vc_top=e(V);
mata: iv_b_top=st_matrix("iv_b_top");
mata: iv_vc_top=st_matrix("iv_vc_top");

`estimator' laidp indexall M2-M12 reg2-reg10 T, `lags';
scalar delta_top=_coef[indexall];
mat aids_top=_coef[indexall];
matrix ols_b_top=e(b);
matrix ols_vc_top=e(V);
mata: ols_b_top=st_matrix("ols_b_top");
mata: ols_vc_top=st_matrix("ols_vc_top");
mata: mata matsave "c:/data/restat_12_9/analysis_data/oil_top_level" ols_b_top ols_vc_top iv_b_top iv_vc_top, replace;

/*for linear model*/
`ivestimator' wexp M2-M12 reg2-reg10 T (lin_indexall=ivlin_indexall), `lags';
mat ivlin_b_top=e(b);
mat ivlin_vc_top=e(V);

mat ivlin_top=_coef[lin_indexall];
sca ivldelta_top=_coef[lin_indexall];





`estimator' wexp lin_indexall M2-M12 reg2-reg10 T, `lags';
mat lin_top=_coef[lin_indexall];
sca ldelta_top=_coef[lin_indexall];

use temp, replace;
sort BRAND REGION t;
bysort BRAND REGION: egen tsaleall=total(exp);
bysort BRAND REGION: egen bsale=total(sale);
gen avgshare=bsale/tsaleall;


forval x=1/`nregions'{;
	forval y=1/`nbrands'{;
		qui sum avgshare if reg`x'==1 & brand`y'==1;
		scalar w`x'b`y'=r(mean);
	};
};

bysort BRAND: egen nat_tsale=total(exp);
bysort BRAND: egen nat_bsale=total(sale);
gen nat_avgshare=nat_bsale/nat_tsale;

forval x=1/`nbrands'{;
	sum nat_avgshare if bra`x'==1;
	scalar avgw`x'=r(mean);
};	


forval x=1/`nbrands'{;
	sum share if bra`x'==1;
	scalar s`x'=r(mean);
};
foreach x of local list{;
	sum share if BRAND=="`x'";
	scalar sh`x'=r(mean);
};


forval x=1/`nbrands'{;
	forval y=1/`nbrands'{;
		scalar e`x'`y'=(g`x'p`y'-b`x'*avgw`y')/s`x'+(1+b`x'/s`x')*(1+delta_top)*avgw`y';
	};
};
mat elas=J(`nbrands',`nbrands',0);
forval x=1/`nbrands'{;
	forval y=1/`nbrands'{;
		mat elas[`x',`y']=e`x'`y';
	};
};
mat elas=elas-I(7);



forval x=1/`nbrands'{;
	forval y=1/`nbrands'{;
		scalar ive`x'`y'=(ivg`x'p`y'-ivb`x'*avgw`y')/s`x'+(1+ivb`x'/s`x')*(1+ivdelta_top)*avgw`y';
	};
};
mat ivelas=J(`nbrands',`nbrands',0);
forval x=1/`nbrands'{;
	forval y=1/`nbrands'{;
		mat ivelas[`x',`y']=ive`x'`y';
	};
};
mat ivelas=ivelas-I(7);


forval x=1/7{;
	sum price if bra`x'==1;
	scalar p`x'=r(mean);
};

forval x=1/`nbrands'{;
	sum wvol if bra`x'==1;
	scalar w`x'=r(mean);
};

forval x=1/`nbrands'{;
	forval y=1/`nbrands'{;
		sca le`x'b`y'=(p`y'/w`x')*(p_`x'_`y'+theta`x'*ldelta_top*s`y');
	};
};



mat lelas=J(7,7,0);
forval x=1/7{;
	forval y=1/7{;
		mat lelas[`x',`y']=le`x'b`y';
	};
};


forval x=1/`nbrands'{;
	forval y=1/`nbrands'{;
		sca ivle`x'b`y'=(p`y'/w`x')*(ivp_`x'_`y'+ivtheta`x'*ivldelta_top*s`y');
	};
};


mat ivlelas=J(7,7,0);
forval x=1/7{;
	forval y=1/7{;
		mat ivlelas[`x',`y']=ivle`x'b`y';
	};
};

log using ivoutput2, replace;
mat li elas;
mat li ivelas;
mat li lelas;
mat li ivlelas;



local nregions=10;

/*creates average share vector for each region*/
forval x=1/`nregions'{;
    mat define sbar`x'=J(`nbrands',1,0);
    forval y=1/`nbrands'{;
        qui sum share if reg`x'==1 & bra`y'==1;
        matrix sbar`x'[`y',1]=_result(3);
	};
};

mat define w=J(`nregions',`nbrands',0);
forval x=1/`nregions'{;
	forval y=1/`nbrands'{;
		mat w[`x',`y']=w`x'b`y';
	};
};	

mat define wnat=J(`nbrands',1,0);
forval x=1/`nbrands'{;
	mat wnat[`x',1]=avgw`x';
};



mat define tsale=J(`nregions',1,0);
forval x=1/`nregions'{;
    qui sum exp if reg`x'==1;
    matrix tsale[`x',1]=_result(3);
};

gen LTSALE=log(exp);
mat define ltsale=J(`nregions',1,0);
forval x=1/`nregions'{;
    qui sum LTSALE if reg`x'==1;
    matrix ltsale[`x',1]=_result(3);
};

/*creates average prices for each region*/
forval x=1/`nregions'{;
    mat define pbar`x'=J(`nbrands',1,0);
    forval y=1/`nbrands'{;
        qui sum price if reg`x'==1 & bra`y'==1;
        matrix pbar`x'[`y',1]=_result(3);
       };
};

/*creates average log prices for each region*/
forval x=1/`nregions'{;
    mat define lpbar`x'=J(`nbrands',1,0);
    forval y=1/`nbrands'{;
        qui sum lprice if bra`y'==1 & reg`x'==1;
        matrix lpbar`x'[`y',1]=_result(3);
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

/*slope parameters for full solution*/
mat define g=J(`nbrands',`nbrands',0);
mat define ivg=J(`nbrands',`nbrands',0);
mat define b=J(`nbrands',1,0);
mat define ivb=J(`nbrands',1,0);


forval i=1/`nbrands'{;
    forval j=1/`nbrands'{;
        mat g[`i',`j']=g`i'p`j';
    };
};

forval i=1/`nbrands'{;
    forval j=1/`nbrands'{;
        mat ivg[`i',`j']=ivg`i'p`j';
    };
};


forval i=1/`nbrands'{;
	mat b[`i',1]=b`i';
};

forval i=1/`nbrands'{;
	mat ivb[`i',1]=ivb`i';
};

/**********************************************************/    
forval x=1/`nbrands'{;
    forval i=1/`nregions'{;
        mat aidomega`i'[`x',`x']=-1+((g`x'p`x'-w`i'b`x'*b`x')/sbar`i'[`x',1])+(1+b`x'/sbar`i'[`x',1])*(1+delta_top)*w`i'b`x';
    };
};

forval x=1/`nbrands'{;
    forval i=1/`nregions'{;
        mat ivaidomega`i'[`x',`x']=-1+((ivg`x'p`x'-w`i'b`x'*ivb`x')/sbar`i'[`x',1])+(1+ivb`x'/sbar`i'[`x',1])*(1+ivdelta_top)*w`i'b`x';
    };
};



/*computes pre-merger markups for each of the ten regions*/
forval i=1/`nregions'{;
    mat ds`i'=diag(sbar`i');
};
/*aidmu has p-mc, not lerner index*/
forval i=1/`nregions'{;
    mat aidmu`i'=J(`nbrands',1,0);
    mat aidmu`i'=-inv(ds`i')*inv(aidomega`i')*sbar`i';
    mat ivaidmu`i'=J(`nbrands',1,0);
    mat ivaidmu`i'=-inv(ds`i')*inv(ivaidomega`i')*sbar`i';
};



/*mark-up matrix has 10 columns, which correspond to regional markets, and 7 rows corresponding to brands.  
aidmu are p-mc's with aid system, lmu are p=mc's with linear system, llmu are lerner indices with log-linear system
this just puts them in matrix form as described above*/
mat aidmu=[aidmu1];
mat ivaidmu=[ivaidmu1];
mat pbar=[pbar1];
mat lpbar=[lpbar1];
mat sbar=[sbar1];
forval x=2/`nregions'{;
    mat aidmu=[aidmu,aidmu`x'];
    mat ivaidmu=[ivaidmu,ivaidmu`x'];
    mat pbar=[pbar,pbar`x'];
    mat sbar=[sbar,sbar`x'];
};

mat pbar=pbar';
mat lpbar=lpbar';
mat sbar=sbar';
mat aidmu=aidmu';
mat ivaidmu=ivaidmu';

/*get costs by solving mark-ups.  because element-by-element operations are a pain in stata, i do this in mata*/
/*input markup matrices, average prices and shares, and post-merger ownership matrices into stata*/
mata;
    w=st_matrix("w");
    b=st_matrix("b");
    g=st_matrix("g");
    aidmu=st_matrix("aidmu");
    ivb=st_matrix("ivb");
    ivg=st_matrix("ivg");
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
    mat taidomega`i'[6,4]=(g4p6-w`i'b4*b6)/sbar`i'[4,1]+(1+b4/sbar`i'[4,1])*(1+delta_top)*w`i'b4;
    mat taidomega`i'[4,6]=(g6p4-w`i'b6*b4)/sbar`i'[6,1]+(1+b6/sbar`i'[6,1])*(1+delta_top)*w`i'b6;
    mat ivtaidomega`i'[6,4]=(ivg4p6-w`i'b4*ivb6)/sbar`i'[4,1]+(1+ivb4/sbar`i'[4,1])*(1+ivdelta_top)*w`i'b4;
    mat ivtaidomega`i'[4,6]=(ivg6p4-w`i'b6*ivb4)/sbar`i'[6,1]+(1+ivb6/sbar`i'[4,1])*(1+ivdelta_top)*w`i'b6;
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
    mat paidmu`i'=-inv(ds`i')*inv(postaidomega`i')*sbar`i';
};

forval i=1/`nregions'{;
    mat ivpaidmu`i'=-inv(ds`i')*inv(ivpostaidomega`i')*sbar`i';
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
    tsale=st_matrix("tsale");
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
	postdirect=J(10,7,0);
	postdirect[.,1]=pbar[.,1]*(1+.0487);
	postdirect[.,2]=pbar[.,2]*(1-.1158);
	postdirect[.,3]=pbar[.,3]*(1+.0302);
	postdirect[.,4]=pbar[.,4]*(1+.0256);
	postdirect[.,5]=pbar[.,5]*(1-.0210);
	postdirect[.,6]=pbar[.,6]*(1+.0534);
	postdirect[.,7]=pbar[.,7]*(1+.0268);
end;    



/****************SOLVES UNDER LINEAR DEMAND*****************************/
#delimit cr
mata:
	mata matuse c:/data/restat_12_9/analysis_data/oilpost_prices, replace
    B=st_matrix("B")
    V=(st_matrix("vbar1"),st_matrix("vbar2"),st_matrix("vbar3"),st_matrix("vbar4"),st_matrix("vbar5"),st_matrix("vbar6"),st_matrix("vbar7"),st_matrix("vbar8"),st_matrix("vbar9"),st_matrix("vbar10"))
    theta=st_matrix("theta")
	top=st_matrix("lin_top")	
	a=J(7,10,0)
    c=J(7,10,0)
    pbar=pbar'
    for(i=1;i<=10;i++){
        a[.,i]=V[.,i]-B*pbar[.,i]       
    }		
	
    for(i=1;i<=10;i++){
        c[.,i]=luinv(diag(B)+diag(sbar[i,.]':*theta*top))*a[.,i]+(luinv(diag(B)+diag(sbar[i,.]':*theta*top))*B+I(7))*pbar[.,i]
    }
   
    cpost=J(10,7,0)
	lfullp=J(7,10,0)
    for(i=1;i<=10;i++){
		D=diag(B)+diag(sbar[i,.]':*theta*top)
		D[4,6]=B[6,4]+theta[6]*top*sbar[i,4]
		D[6,4]=B[4,6]+theta[4]*top*sbar[i,6]
        lfullp[.,i]=luinv(D+B)*(D*c[.,i]-a[.,i])
		cpost[i,.]=(luinv(D)*(a[.,i]+(D+B)*postdirect[i,.]'))'
    }
    flin=mm_median(((lfullp-pbar):/pbar)',1)
	mcchange=mm_median((cpost-c'):/c')
end



mata:
    ivB=st_matrix("ivB")
	ivtheta=st_matrix("ivtheta")
	ivtop=st_matrix("ivlin_top")
    iva=J(7,10,0)
    ivc=J(7,10,0)
    
   
   for(i=1;i<=10;i++){
        iva[.,i]=V[.,i]-ivB*pbar[.,i]       
    }
    ivD=diag(ivB)
    for(i=1;i<=10;i++){
        ivc[.,i]=luinv(diag(ivB)+diag(sbar[i,.]':*ivtheta*ivtop))*iva[.,i]+(luinv(diag(ivB)+diag(sbar[i,.]':*ivtheta*ivtop))*ivB+I(7))*pbar[.,i]
    }
    
	ivcpost=J(10,7,0)
    ivlfullp=J(7,10,0)
    for(i=1;i<=10;i++){
    	ivD=diag(ivB)+diag(sbar[i,.]':*ivtheta*ivtop)
		ivD[4,6]=ivB[6,4]+ivtheta[6]*ivtop*sbar[i,4]
		ivD[6,4]=ivB[4,6]+ivtheta[4]*ivtop*sbar[i,6]
		ivlfullp[.,i]=luinv(ivD+ivB)*(ivD*ivc[.,i]-iva[.,i])
		ivcpost[i,.]=(luinv(ivD)*(iva[.,i]+(ivD+ivB)*postdirect[i,.]'))'
    }
    ivflin=mm_median(((ivlfullp-pbar):/pbar)',1)
	ivmcchange=mm_median((ivcpost-ivc'):/ivc')
end

/*this solves for the exact equilibrium for each model*/
#delimit cr
local nbrands=7
local nregions=10
mata:
	e=st_matrix("aids_top")
    aidfullp=J(`nbrands',`nregions',0)
    for(i=1;i<=cols(pbar);i++){
        pinit=pbar[.,i]
        a=csolve(&aids(),pinit,1e-6,400,sbar[i,.]',pbar[.,i],aidcost[i,.]',g,b,w[i,.]',tsale[i],e)
        a=a[1..`nbrands',.]
        aidfullp[.,i]=a
    }
    aidfullp=aidfullp'
    ans=(aidfullp-pbar'):/pbar'
    mean(ans,1)
    faids=mm_median(ans)    	
end

mata:
	ive=st_matrix("ivaids_top")
    aidfullp=J(`nbrands',`nregions',0)
    for(i=1;i<=cols(pbar);i++){
        pinit=pbar[.,i]
        a=csolve(&aids(),pinit,1e-6,400,sbar[i,.]',pbar[.,i],ivaidcost[i,.]',ivg,ivb,w[i,.]',tsale[i],ive)
        a=a[1..`nbrands',.]
        aidfullp[.,i]=a
    }
    aidfullp=aidfullp'
    ivans=(aidfullp-pbar'):/pbar'
    mean(ivans,1)
    ivfaids=mm_median(ivans)    	
end

mata:
	flin
	ivflin
	faids
	ivfaids
end



log close
local nbrands=7
local nregions=10
do c:/data/restat_12_9/programs/table2/mcosts_oilaids
mata:
	caidfullp=J(`nbrands',`nregions',0)
	for(i=1;i<=cols(pbar);i++){
		init=aidcost[i,.]'
		ca=csolve(&cost_moilaids(),init,1e-6,400,sbar[i,.]',pbar[.,i],postdirect[i,.]',g,b,w[i,.]',tsale[i],e)
		ca=ca[1..`nbrands',.]
		caidfullp[.,i]=ca
	}
	caidfullp=caidfullp'
	mm_median((caidfullp[.,4]-aidcost[.,4]):/aidcost[.,4])
	mm_median((caidfullp[.,6]-aidcost[.,6]):/aidcost[.,6])
end

mata:
	ivcaidfullp=J(`nbrands',`nregions',0)
	for(i=1;i<=cols(pbar);i++){
		init=ivaidcost[i,.]'
		ca=csolve(&cost_moilaids(),init,1e-6,400,sbar[i,.]',pbar[.,i],postdirect[i,.]',ivg,ivb,w[i,.]',tsale[i],ive)
		ca=ca[1..`nbrands',.]
		ivcaidfullp[.,i]=ca
	}
	ivcaidfullp=ivcaidfullp'
	mm_median((ivcaidfullp[.,4]-ivaidcost[.,4]):/ivaidcost[.,4])
	mm_median((ivcaidfullp[.,6]-ivaidcost[.,6]):/ivaidcost[.,6])
end





#delimit;
save oilstart, replace; 
drop _all;



#delimit;
/***Now that we have our point estimates of costs and approximate simulated price changes, we draw from asymptotic approx of distributions
of estimators and recalculate for each draw.  will look at empirical distribution of these calculated costs and changes to do inference.****/
drop _all;
/*number of bootstrap iterations*/
local its=1000;
local aids "laidp1 laidp2 laidp3 laidp4 laidp5 laidp6 `reglist' `Mlist' `regionxbrand' bra1 bra2 bra3 bra4 bra5 bra6 count1 count2 count3 count4 count5 count6";
local ivaids "laidp1 laidp2 laidp3 laidp4 laidp5 laidp6 `reglist' `Mlist' `regionxbrand' bra1 bra2 bra3 bra4 bra5 bra6 count1 count2 count3 count4 count5 count6";
local lind "count1 count2 count3 count4 count5 count6 count7 bra1 bra2 bra3 bra4 bra5 bra6 bra7 `lMlist' `lregionxbrand' wexp1 wexp2 wexp3 wexp4 wexp5 wexp6 wexp7 `linplist'";
local ivlind "wexp1 wexp2 wexp3 wexp4 wexp5 wexp6 wexp7 `linplist' count1 count2 count3 count4 count5 count6 count7 bra1 bra2 bra3 bra4 bra5 bra6 bra7 `lMlist' `lregionxbrand'";
local topaids "indexall M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 reg2 reg3 reg4 reg5 reg6 reg7 reg8 reg9 reg10 T cons";

local ivtopaids "indexall M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 reg2 reg3 reg4 reg5 reg6 reg7 reg8 reg9 reg10 T cons";
local toplin "lin_indexall M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 reg2 reg3 reg4 reg5 reg6 reg7 reg8 reg9 reg10 T cons";
local ivtoplin "lin_indexall M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 reg2 reg3 reg4 reg5 reg6 reg7 reg8 reg9 reg10 T cons";

set seed 10161978;
drawnorm `ivaids', n(`its') mean(ivaidB) cov(ivaidVC);
drawnorm `ivtopaids', n(`its') mean(iv_b_top) cov(iv_vc_top);



foreach x of local list{;
    gen lprice_7_`x'=-lprice_1_`x'-lprice_2_`x'-lprice_3_`x'-lprice_4_`x'-lprice_5_`x'-lprice_6_`x';
};
gen laidp7=-laidp1-laidp2-laidp3-laidp4-laidp5-laidp6;
forval x=1/7{;
	rename lprice_`x'_CASTROL lp_`x'_1;
	rename lprice_`x'_HAVOLINE lp_`x'_2;
	rename lprice_`x'_MOBIL lp_`x'_3;
	rename lprice_`x'_PENNZOIL lp_`x'_4;
	rename lprice_`x'_PRIVATE lp_`x'_5;
	rename lprice_`x'_QUAKER lp_`x'_6;
	rename lprice_`x'_VALVOLINE lp_`x'_7;
};


mkmat _all;

use oilstart, replace;


/*bsbarx is a 7x`its' matrix with columns equal to the means of revenue shares taken over bootstrap subsamples
of region x.  bpbarx, bvbbarx defined similarly.*/

forval x=1/`nregions'{;
    mat bsbar`x'=J(`nbrands',`its',0);
    mat bpbar`x'=J(`nbrands',`its',0);
};

forval x=1/`nregions'{;
    forval w=1/`its'{;
        preserve;
            keep if reg`x'==1;
            bsample;
            forval y=1/`nbrands'{;
                qui sum share if bra`y'==1;
                matrix bsbar`x'[`y',`w']=_result(3);
                qui sum price if bra`y'==1;
                matrix bpbar`x'[`y',`w']=_result(3);
            };
        restore;
    };
};


mata;
    bsaidcost=J(`its',7,0);
    bsaidp=J(`its',7,0);
end;

#delimit;
local its=1000;
forval z=1/`its'{;
    /*makes pre-merger "ownership" matrices*/
    forval i=1/`nregions'{;
        mat define aidomega`i'=J(`nbrands',`nbrands',0);
    };
    forval x=1/`nbrands'{;
        forval i=1/`nregions'{;
           mat aidomega`i'[`x',`x']=-1+((lp_`x'_`x'[`z',1]-w`i'b`x'*laidp`x'[`z',1])/bsbar`i'[`x',`z'])+(1+laidp`x'[`z',1]/bsbar`i'[`x',`z'])*(1+indexall[`z',1])*w`i'b`x';
        };
    };
        
    /*computes pre-merger markups for each of the ten regions*/
    forval i=1/`nregions'{;
        mat ds`i'=diag(bsbar`i'[1..`nbrands',`z']);
    };
    /*aidmu has p-mc, not lerner index*/
    forval i=1/`nregions'{;
        mat aidmu`i'=J(`nbrands',1,0);
        mat aidmu`i'=-inv(ds`i')*inv(aidomega`i')*bsbar`i'[1..`nbrands',`z'];
    };

    /*mark-up matrix has 10 columns, which correspond to regional markets, and 7 rows corresponding to brands.
    aidmu are p-mc's with aid system, lmu are p=mc's with linear system, llmu are lerner indices with log-linear system
    this just puts them in matrix form as described above*/

    mat aidmu=[aidmu1];
    mat pbar=[bpbar1[1..`nbrands',`z']];
    mat sbar=[bsbar1[1..`nbrands',`z']];
    forval x=2/`nregions'{;
        mat aidmu=[aidmu,aidmu`x'];
        mat pbar=[pbar,bpbar`x'[1..`nbrands',`z']];
        mat sbar=[sbar,bsbar`x'[1..`nbrands',`z']];
    };
    mat pbar=pbar';
    mat sbar=sbar';
    mat aidmu=aidmu';
  
    /*get costs by solving mark-ups.  because element-by-element operations are a pain in stata, i do this in mata*/
    /*input markup matrices, average prices and shares, and post-merger ownership matrices into stata*/
    mata: g=st_matrix("g"); 
    mata: w=st_matrix("w");
    mata: b=st_matrix("b");
    mata: aidmu=st_matrix("aidmu");
    mata: pbar=st_matrix("pbar");
    mata: sbar=st_matrix("sbar");
    mata: aidcost=pbar:*(J(10,7,1)-aidmu);
    mata: st_matrix("aidcost", aidcost);




    /*defines post-merger ownership matrix of elasticities*/
    mat taidomega=J(`nbrands',`nbrands',0);

	
    forval i=1/`nregions'{;
        mat aidomega`i'[6,4]=(lp_4_6[`z',1]-w`i'b6*laidp4[`z',1])/bsbar`i'[4,`z']+(1+laidp4[`z',1]/bsbar`i'[4,`z'])*(1+indexall[`z',1])*w`i'b4;
        mat aidomega`i'[4,6]=(lp_6_4[`z',1]-w`i'b4*laidp6[`z',1])/bsbar`i'[6,`z']+(1+laidp6[`z',1]/bsbar`i'[6,`z'])*(1+indexall[`z',1])*w`i'b6;
    };

    forval i=1/`nregions'{;
        mat postaidomega`i'=aidomega`i'+taidomega`i';
    };

    /*solves for post-merger mark-ups*/
    forval i=1/`nregions'{;
        mat define paidmu`i'=J(`nbrands',1,0);
        mat paidmu`i'=-inv(ds`i')*inv(postaidomega`i')*bsbar`i'[1..`nbrands',`z'];
    };
    /*puts post-merger mark-ups into a matrix with rows corresponding to markets and columns to products*/
    mat paidmu=[paidmu1];
    forval x=2/`nregions'{;
        mat paidmu=[paidmu,paidmu`x'];
    };
    mat paidmu=paidmu';

    /*now go back to mata to solve for post-merger prices.  will then calculate percentage increases over
    pre-merger average prices for each region, and then take the average over regions for to yield percentage
    price increases for each product.  these average prices are the mxprice variables and the average costs are the
    mxcost variables*/

    mata: paidmu=st_matrix("paidmu");
    mata: invaidp=(J(10,7,1)-paidmu):/aidcost;
    mata: aidp=((J(10,7,1):/invaidp)-pbar):/pbar;
    mata: maidcost=mean(aidcost,1);
    mata: maidprice=mean(aidp,1);
    mata: bsaidcost[`z',.]=maidcost;
    mata: bsaidp[`z',.]=maidprice;
    mata: st_matrix("bsaidcost",bsaidcost);
    mata: st_matrix("bsaidp", bsaidp);
};





#delimit cr;
drop _all
set more off
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

    ppoint=J(1,10,NULL)
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
        
    bs1=st_matrix("bsbar1")
    bs2=st_matrix("bsbar2")
    bs3=st_matrix("bsbar3")
    bs4=st_matrix("bsbar4")
    bs5=st_matrix("bsbar5")
    bs6=st_matrix("bsbar6")
    bs7=st_matrix("bsbar7")
    bs8=st_matrix("bsbar8")
    bs9=st_matrix("bsbar9")
    bs10=st_matrix("bsbar10")

    spoint=J(1,10,NULL)
    spoint[1]=&bs1
    spoint[2]=&bs2
    spoint[3]=&bs3
    spoint[4]=&bs4
    spoint[5]=&bs5
    spoint[6]=&bs6
    spoint[7]=&bs7
    spoint[8]=&bs8
    spoint[9]=&bs9
    spoint[10]=&bs10
  
  
    laidp1=st_matrix("laidp1")
    laidp2=st_matrix("laidp2")
    laidp3=st_matrix("laidp3")
    laidp4=st_matrix("laidp4")
    laidp5=st_matrix("laidp5")
    laidp6=st_matrix("laidp6")
    laidp7=st_matrix("laidp7")


    lp_1_1=st_matrix("lp_1_1")
    lp_2_1=st_matrix("lp_2_1")
    lp_3_1=st_matrix("lp_3_1")
    lp_4_1=st_matrix("lp_4_1")
    lp_5_1=st_matrix("lp_5_1")
    lp_6_1=st_matrix("lp_6_1")
    lp_7_1=st_matrix("lp_7_1")

    lp_1_2=st_matrix("lp_1_2")
    lp_2_2=st_matrix("lp_2_2")
    lp_3_2=st_matrix("lp_3_2")
    lp_4_2=st_matrix("lp_4_2")
    lp_5_2=st_matrix("lp_5_2")
    lp_6_2=st_matrix("lp_6_2")
    lp_7_2=st_matrix("lp_7_2")


    lp_1_3=st_matrix("lp_1_3")
    lp_2_3=st_matrix("lp_2_3")
    lp_3_3=st_matrix("lp_3_3")
    lp_4_3=st_matrix("lp_4_3")
    lp_5_3=st_matrix("lp_5_3")
    lp_6_3=st_matrix("lp_6_3")
    lp_7_3=st_matrix("lp_7_3")


    lp_1_4=st_matrix("lp_1_4")
    lp_2_4=st_matrix("lp_2_4")
    lp_3_4=st_matrix("lp_3_4")
    lp_4_4=st_matrix("lp_4_4")
    lp_5_4=st_matrix("lp_5_4")
    lp_6_4=st_matrix("lp_6_4")
    lp_7_4=st_matrix("lp_7_4")

    lp_1_5=st_matrix("lp_1_5")
    lp_2_5=st_matrix("lp_2_5")
    lp_3_5=st_matrix("lp_3_5")
    lp_4_5=st_matrix("lp_4_5")
    lp_5_5=st_matrix("lp_5_5")
    lp_6_5=st_matrix("lp_6_5")
    lp_7_5=st_matrix("lp_7_5")

    lp_1_6=st_matrix("lp_1_6")
    lp_2_6=st_matrix("lp_2_6")
    lp_3_6=st_matrix("lp_3_6")
    lp_4_6=st_matrix("lp_4_6")
    lp_5_6=st_matrix("lp_5_6")
    lp_6_6=st_matrix("lp_6_6")
    lp_7_6=st_matrix("lp_7_6")

    lp_1_7=st_matrix("lp_1_7")
    lp_2_7=st_matrix("lp_2_7")
    lp_3_7=st_matrix("lp_3_7")
    lp_4_7=st_matrix("lp_4_7")
    lp_5_7=st_matrix("lp_5_7")
    lp_6_7=st_matrix("lp_6_7")
    lp_7_7=st_matrix("lp_7_7")
	
	wnat=st_matrix("wnat")
	indexall=st_matrix("indexall")
end

drop _all

mata
    e1j=J(1000,7,0)
    e2j=J(1000,7,0)
    e3j=J(1000,7,0)
    e4j=J(1000,7,0)
    e5j=J(1000,7,0)
    e6j=J(1000,7,0)
    e7j=J(1000,7,0)

for(z=1;z<=1000;z++){

e=indexall[z]
        /*makes price coefficient matrix for each draw*/
g=(lp_1_1[z,1],lp_2_1[z,1],lp_3_1[z,1],lp_4_1[z,1],lp_5_1[z,1],lp_6_1[z,1],lp_7_1[z,1]
  \lp_1_2[z,1],lp_2_2[z,1],lp_3_2[z,1],lp_4_2[z,1],lp_5_2[z,1],lp_6_2[z,1],lp_7_2[z,1]
  \lp_1_3[z,1],lp_2_3[z,1],lp_3_3[z,1],lp_4_3[z,1],lp_5_3[z,1],lp_6_3[z,1],lp_7_3[z,1]
  \lp_1_4[z,1],lp_2_4[z,1],lp_3_4[z,1],lp_4_4[z,1],lp_5_4[z,1],lp_6_4[z,1],lp_7_4[z,1]
  \lp_1_5[z,1],lp_2_5[z,1],lp_3_5[z,1],lp_4_5[z,1],lp_5_5[z,1],lp_6_5[z,1],lp_7_5[z,1]
  \lp_1_6[z,1],lp_2_6[z,1],lp_3_6[z,1],lp_4_6[z,1],lp_5_6[z,1],lp_6_6[z,1],lp_7_6[z,1]
  \lp_1_7[z,1],lp_2_7[z,1],lp_3_7[z,1],lp_4_7[z,1],lp_5_7[z,1],lp_6_7[z,1],lp_7_7[z,1])
g=g'                
/*makes expenditure coefficients*/
b=(laidp1[z]\laidp2[z]\laidp3[z]\laidp4[z]\laidp5[z]\laidp6[z]\laidp7[z])
	sx=J(7,10,0)
	for(j=1;j<=10;j++){           
		sx[.,j]=(*spoint[j])[.,z]
	}	            

	s=mean(sx',1)
	aidomega=J(7,7,0)
	for(n=1;n<=7;n++){
		for(m=1;m<=7;m++){
                	aidomega[n,m]=(g[n,m]-wnat[m]*b[n])*(1/s[n])+(1+b[n]/s[n])*(1+e)*wnat[m]
		}
      }
		
	for(n=1;n<=7;n++){
            aidomega[n,n]=-1+(g[n,n]-wnat[n]*b[n])*(1/s[n])+(1+b[n]/s[n])*(1+e)*wnat[n]
      }

		e1j[z,1]=aidomega[1,1]
		e1j[z,2]=aidomega[1,2]
		e1j[z,3]=aidomega[1,3]
		e1j[z,4]=aidomega[1,4]
		e1j[z,5]=aidomega[1,5]
		e1j[z,6]=aidomega[1,6]
		e1j[z,7]=aidomega[1,7]

		e2j[z,1]=aidomega[2,1]
		e2j[z,2]=aidomega[2,2]
		e2j[z,3]=aidomega[2,3]
		e2j[z,4]=aidomega[2,4]
		e2j[z,5]=aidomega[2,5]
		e2j[z,6]=aidomega[2,6]
		e2j[z,7]=aidomega[2,7]

		e3j[z,1]=aidomega[3,1]
		e3j[z,2]=aidomega[3,2]
		e3j[z,3]=aidomega[3,3]
		e3j[z,4]=aidomega[3,4]
		e3j[z,5]=aidomega[3,5]
		e3j[z,6]=aidomega[3,6]
		e3j[z,7]=aidomega[3,7]

		e4j[z,1]=aidomega[4,1]
		e4j[z,2]=aidomega[4,2]
		e4j[z,3]=aidomega[4,3]
		e4j[z,4]=aidomega[4,4]
		e4j[z,5]=aidomega[4,5]
		e4j[z,6]=aidomega[4,6]
		e4j[z,7]=aidomega[4,7]

		e5j[z,1]=aidomega[5,1]
		e5j[z,2]=aidomega[5,2]
		e5j[z,3]=aidomega[5,3]
		e5j[z,4]=aidomega[5,4]
		e5j[z,5]=aidomega[5,5]
		e5j[z,6]=aidomega[5,6]
		e5j[z,7]=aidomega[5,7]

		e6j[z,1]=aidomega[6,1]
		e6j[z,2]=aidomega[6,2]
		e6j[z,3]=aidomega[6,3]
		e6j[z,4]=aidomega[6,4]
		e6j[z,5]=aidomega[6,5]
		e6j[z,6]=aidomega[6,6]
		e6j[z,7]=aidomega[6,7]

		e7j[z,1]=aidomega[7,1]
		e7j[z,2]=aidomega[7,2]
		e7j[z,3]=aidomega[7,3]
		e7j[z,4]=aidomega[7,4]
		e7j[z,5]=aidomega[7,5]
		e7j[z,6]=aidomega[7,6]
		e7j[z,7]=aidomega[7,7]

}
mean(e1j)
mean(e2j)
mean(e3j)				      
mean(e4j)
mean(e5j)
mean(e6j)
mean(e7j)

oilolselas=J(7,7,0)

oilolselas[1,.]=sqrt(mean(e1j:*e1j)-mean(e1j):*mean(e1j))				      
oilolselas[2,.]=sqrt(mean(e2j:*e2j)-mean(e2j):*mean(e2j))				      
oilolselas[3,.]=sqrt(mean(e3j:*e3j)-mean(e3j):*mean(e3j))
oilolselas[4,.]=sqrt(mean(e4j:*e4j)-mean(e4j):*mean(e4j))
oilolselas[5,.]=sqrt(mean(e5j:*e5j)-mean(e5j):*mean(e5j))				      
oilolselas[6,.]=sqrt(mean(e6j:*e6j)-mean(e6j):*mean(e6j))
oilolselas[7,.]=sqrt(mean(e7j:*e7j)-mean(e7j):*mean(e7j))				      

end





cap log close

log using oilelasticities, replace
	/*table with caption "OIL, AIDS Model with IV" has 10 rows and 5 columns. The matrix below contains standard errors for 
	these elasticities.  "*/
	mata: oilolselas
log close



set more off
mata
	rseed(2)	
    bsfaid=J(1000,7,0)
	bsfaidfocs=J(1000,7,0)
    for(z=1;z<=1000;z++){
        /*makes price coefficient matrix for each draw*/
g=(lp_1_1[z,1],lp_2_1[z,1],lp_3_1[z,1],lp_4_1[z,1],lp_5_1[z,1],lp_6_1[z,1],lp_7_1[z,1]
  \lp_1_2[z,1],lp_2_2[z,1],lp_3_2[z,1],lp_4_2[z,1],lp_5_2[z,1],lp_6_2[z,1],lp_7_2[z,1]
  \lp_1_3[z,1],lp_2_3[z,1],lp_3_3[z,1],lp_4_3[z,1],lp_5_3[z,1],lp_6_3[z,1],lp_7_3[z,1]
  \lp_1_4[z,1],lp_2_4[z,1],lp_3_4[z,1],lp_4_4[z,1],lp_5_4[z,1],lp_6_4[z,1],lp_7_4[z,1]
  \lp_1_5[z,1],lp_2_5[z,1],lp_3_5[z,1],lp_4_5[z,1],lp_5_5[z,1],lp_6_5[z,1],lp_7_5[z,1]
  \lp_1_6[z,1],lp_2_6[z,1],lp_3_6[z,1],lp_4_6[z,1],lp_5_6[z,1],lp_6_6[z,1],lp_7_6[z,1]
  \lp_1_7[z,1],lp_2_7[z,1],lp_3_7[z,1],lp_4_7[z,1],lp_5_7[z,1],lp_6_7[z,1],lp_7_7[z,1])
g=g'		
		
		e=indexall[z,1]				
        /*makes expenditure coefficients*/
        b=(laidp1[z]\laidp2[z]\laidp3[z]\laidp4[z]\laidp5[z]\laidp6[z]\laidp7[z])
        temp=J(10,7,0)
		focs=J(10,7,0)
        for(j=1;j<=10;j++){
            p=(*ppoint[j])[.,z]
            pinit=(*ppoint[j])[.,z]
            s=(*spoint[j])[.,z]
            aidomega=J(7,7,0)
		for(n=1;n<=7;n++){
                aidomega[n,n]=-1+(g[n,n]-w[j,n]*b[n])*(1/((*spoint[j])[n,z]))+(1+b[n]/(*spoint[j])[n,z])*(1+e)*w[j,n]
            }
            ds=diag(s)
            mu=-luinv(ds)*luinv(aidomega)*s
            aidcost=p:*(J(7,1,1)-mu)
            pinit=(*ppoint[j])[.,z]
            a=csolve(&aids(),pinit,1e-6,400,s,p,aidcost,g,b,w[j,.]',tsale[j],e)
            a=a[1..7,.]
            a=(a-p):/p
            temp[j,.]=a'
			focs[j,.]=aids(postdirect[j,.]',s,p,aidcost,g,b,w[j,.]',tsale[j],e)'
        }
        bsfaid[z,.]=mm_median(temp,1)
		bsfaidfocs[z,.]=mm_median(focs,1)
    }       
	st_matrix("bsfaid",bsfaid)
	st_matrix("bsfaidfocs",bsfaidfocs)
end

svmat bsfaid




log using oiltable2col4, replace
centile bsfaid1, centile(2.5, 97.5)
centile bsfaid2, centile(2.5, 97.5)
centile bsfaid3, centile(2.5, 97.5)
centile bsfaid4, centile(2.5, 97.5)
centile bsfaid5, centile(2.5, 97.5)
centile bsfaid6, centile(2.5, 97.5)
centile bsfaid7, centile(2.5, 97.5)

log close



svmat bsfaidfocs
save c:/data/restat_12_9/bootstrap_results/ivoilaids, replace




