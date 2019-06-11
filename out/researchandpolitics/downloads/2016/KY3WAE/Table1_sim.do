/*This STATA code replicates results for Table 1*/

#d ;
global sim "Change Directory Here" ;
cap mkdir "$sim\ECM\" ;
cap mkdir "$sim\ECM\BI\" ;
cap mkdir "$sim\ECM\MV\" ;

/*bivariate*/
#d ;
cd "$sim\ECM\BI\" ;
clear all ;
foreach b of numlist 1 2 { ;
foreach t of numlist 60 100 150 { ;
foreach v of numlist 1 2 3 { ;
clear ;
global nobs = `t' ;
global nmc = 10000 ;set seed 5000 ;set obs `t' ;
gen id = _n ;tsset id ;/* Set the values of the parameters*/
local obs_df =`t'-4 ;scalar ecmsig = -1*invttail(`obs_df',0.05) ;scalar ecmMCVm1 = -3.2145-3.21/`obs_df'-2/(`obs_df'^2) +17/(`obs_df'^3) ;scalar up = invttail(`obs_df',0.025) ;scalar lp = -1*invttail(`obs_df',0.025)  ;/* Set values for bounds (Table H.1 in Lebo and Grant)*/
if (`v'==1 & `b'==1) { ;scalar a = 1.5 ;scalar b = 1.5 ;scalar tau = 49 ;scalar k = 73.5 ;
gen dv1 = (99-1)*runiform()+1 ; 
} ;

if (`v'==2 & `b'==1) { ;scalar a = 0.5 ;scalar b = 0.5 ;scalar tau = 49 ;scalar k = 24.5 ;
gen dv1 = (99-1)*runiform()+1 ; 
} ;

if (`v'==3 & `b'==1) { ;scalar a = 0.3 ;scalar b = 0.3 ;scalar tau = 49 ;scalar k = 14.7 ;
gen dv1 = (99-1)*runiform()+1 ; 
} ;

if (`v'==1 & `b'==2) { ;scalar a = 1.5 ;scalar b = 1.5 ;scalar tau = 59 ;scalar k = 16.5 ;
gen dv1 = (59-50)*runiform()+50 ; 
} ;

if (`v'==2 & `b'==2) { ;scalar a = 0.5 ;scalar b = 0.5 ;scalar tau = 59 ;scalar k = 5.49998 ;
gen dv1 = (59-50)*runiform()+50 ; 
} ;

if (`v'==3 & `b'==2) { ;scalar a = 0.3 ;scalar b = 0.3 ;scalar tau = 59 ;scalar k = 3.29864 ;
gen dv1 = (59-50)*runiform()+50 ;
} ;
/* Generating starting values for DV*//*gen dv1 = (59-50)*runiform()+50*/gen iv1 = 0 ;/* generating errors*/gen e = . ;/*gen e2 = . ;gen e3 = . ;*/gen u = . ;gen v = . ;tempname sim ;postfile `sim' m1asigMCV m1asigMCV_df using MCMC_bounded_BI_v`v'_b`b'_t`t', replace ;quietly { ;forvalues i = 1/$nmc { ;replace e = rnormal(0,`v') ;replace u = rnormal() ;replace v = rnormal() ;replace dv1 = l.dv1 + exp(-k)*(exp((-a)*(l.dv1 - tau)) - (exp((b)*(l.dv1 - tau)))) + e in 2/$nobs ;replace iv1 = l.iv1 + u in 2/$nobs ;

/*dicky-fuller test*/
		/*Identify appropriate lags for the Dicky-Fuller test (y). */ 
		reg d.dv1 l.dv1 ; 
		predict resid_dv1, r ;
		wntestq resid_dv1 ;
		local i=r(p) ; 
		drop resid_dv1 ;
		local j = 0 ;
		while `i'<0.05 { ; /*The "while" command allows us to keep running the set of stata commands 
		                   enclosed in the braces until the p-value from the White noise Q test becomes 
		                   greater than 0.05. */
		local j =`j'+ 1 ; /*If the p-value is lower than 0.05, which is a sign of the presence of serial correlation, 
							`j' increases by one unit such that one more lag of ld.y is added in the equation below.*/
		reg d.dv1 l.dv1 l(1/`j')d.dv1 ; 
		predict resid_dv1, r ;
		wntestq resid_dv1 ;
		local i=r(p) ; 
		drop resid_dv1 ;
		} ;
		
		/*Augmented Dicky-Fuller test */
		dfuller dv1, lags(`j') ; /*dfuller: dfuller=Dickey-Fuller (DF) Test
					H0: I(1) or y is unit root.
					H1: (p-1)<0 or y is stationary.
					The appropriate lags `j' is imputed so as to address 
					the issues of serial correlation.
					If p-value is greater than 0.05, it indicates that y
					has a unit root.
					Note that rejecting the null hypothesis does not mean
					we can accept H0 (Woodridge 2009, 633)!
					dfuller by default regresses d.y on l.y. 
					How many lags to be included often depends on 
					the frequency of the data.*/
					
		scalar p_value_df_dv1=r(p) ; /*Save p-value to see if the 
										estimated coefficient on l.y is 
										statistically significant at the .05 level 
										given the Dicket-Fuller Distribution.*/
										reg d.dv1 l.dv1 d.iv1 l.iv1 ;scalar m1a1 = _b[l.dv1] ;scalar m1sea1 = _se[l.dv1] ;scalar m1ta1 = m1a1/m1sea1 ;
scalar m1asig = m1ta1<ecmsig ;scalar m1asigMCV = m1ta1<=ecmMCVm1 ;
scalar m1asigMCV_df = (m1ta1<=ecmMCVm1 & p_value_df_dv1>0.05) ;post `sim' (m1asigMCV) (m1asigMCV_df) ;} ;} ;postclose `sim' ;} ;
} ;
} ;/*multivariate*/
#d ;
cd "$sim\ECM\MV\" ;
foreach b of numlist 1 2 { ;
foreach t of numlist 60 100 150 { ;
foreach v of numlist 1 2 3 { ;
#d ;
clear ;
global nobs = `t' ;
global nmc = 10000 ;set seed 5000 ;set obs `t' ;
gen id = _n ;tsset id ;/* Set the values of the parameters*/
local obs_df =`t'-6 ;scalar ecmsig = -1*invttail(`obs_df',0.05) ;scalar ecmMCVm1 = -3.5057-3.27/`obs_df'+1.1/(`obs_df'^2)-34/(`obs_df'^3) ;scalar up = invttail(`obs_df',0.025) ;scalar lp = -1*invttail(`obs_df',0.025)  ;/* Set values for bounds (Table H.1 in Lebo and Grant)*/
#d ;
if (`v'==1 & `b'==1) { ;
#d ;scalar a = 1.5 ;scalar b = 1.5 ;scalar tau = 49 ;scalar k = 73.5 ;
gen dv1 = (99-1)*runiform()+1 ; 
} ;

#d ;
if (`v'==2 & `b'==1) { ;
#d ;scalar a = 0.5 ;scalar b = 0.5 ;scalar tau = 49 ;scalar k = 24.5 ;
gen dv1 = (99-1)*runiform()+1 ; 
} ;

#d ;
if (`v'==3 & `b'==1) { ;
#d ;scalar a = 0.3 ;scalar b = 0.3 ;scalar tau = 49 ;scalar k = 14.7 ;
gen dv1 = (99-1)*runiform()+1 ; 
} ;

#d ;
if (`v'==1 & `b'==2) { ;
#d ;scalar a = 1.5 ;scalar b = 1.5 ;scalar tau = 59 ;scalar k = 16.5 ;
gen dv1 = (59-50)*runiform()+50 ; 
} ;

#d ;
if (`v'==2 & `b'==2) { ;
#d ;scalar a = 0.5 ;scalar b = 0.5 ;scalar tau = 59 ;scalar k = 5.49998 ;
gen dv1 = (59-50)*runiform()+50 ; 
} ;

#d ;
if (`v'==3 & `b'==2) { ;
#d ;scalar a = 0.3 ;scalar b = 0.3 ;scalar tau = 59 ;scalar k = 3.29864 ;
gen dv1 = (59-50)*runiform()+50 ; 
} ;

/* Generating starting values for DV*//*gen dv1 = (59-50)*runiform()+50*/
#d ;gen iv1 = 0 ;gen iv2 = 0 ;/* generating errors*/
#d ;gen e = . ;/*gen e2 = . ;gen e3 = . ;*/
#d ;gen u = . ;gen v = . ;tempname sim ;postfile `sim' m1asigMCV m1asigMCV_df using MCMC_bounded_MV_v`v'_b`b'_t`t', replace ;quietly { ;forvalues i = 1/$nmc { ;
#d ;replace e = rnormal(0,`v') ;replace u = rnormal() ;replace v = rnormal() ;replace dv1 = l.dv1 + exp(-k)*(exp((-a)*(l.dv1 - tau)) - (exp((b)*(l.dv1 - tau)))) + e in 2/$nobs ;replace iv1 = l.iv1 + u in 2/$nobs ;replace iv2 = l.iv2 + v in 2/$nobs ;

/*dicky-fuller test*/
		/*Identify appropriate lags for the Dicky-Fuller test (y). */ 
		reg d.dv1 l.dv1 ; 
		predict resid_dv1, r ;
		wntestq resid_dv1 ;
		local i=r(p) ; 
		drop resid_dv1 ;
		local j = 0 ;
		while `i'<0.05 { ; /*The "while" command allows us to keep running the set of stata commands 
		                   enclosed in the braces until the p-value from the White noise Q test becomes 
		                   greater than 0.05. */
		local j =`j'+ 1 ; /*If the p-value is lower than 0.05, which is a sign of the presence of serial correlation, 
							`j' increases by one unit such that one more lag of ld.y is added in the equation below.*/
		reg d.dv1 l.dv1 l(1/`j')d.dv1 ; 
		predict resid_dv1, r ;
		wntestq resid_dv1 ;
		local i=r(p) ; 
		drop resid_dv1 ;
		} ;
		
		/*Augmented Dicky-Fuller test */
		dfuller dv1, lags(`j') ; /*dfuller: dfuller=Dickey-Fuller (DF) Test
					H0: I(1) or y is unit root.
					H1: (p-1)<0 or y is stationary.
					The appropriate lags `j' is imputed so as to address 
					the issues of serial correlation.
					If p-value is greater than 0.05, it indicates that y
					has a unit root.
					Note that rejecting the null hypothesis does not mean
					we can accept H0 (Woodridge 2009, 633)!
					dfuller by default regresses d.y on l.y. 
					How many lags to be included often depends on 
					the frequency of the data.*/
					
		scalar p_value_df_dv1=r(p) ; /*Save p-value to see if the 
										estimated coefficient on l.y is 
										statistically significant at the .05 level 
										given the Dicket-Fuller Distribution.*/
										reg d.dv1 l.dv1 d.iv1 l.iv1 d.iv2 l.iv2 ;scalar m1a1 = _b[l.dv1] ;scalar m1sea1 = _se[l.dv1] ;scalar m1ta1 = m1a1/m1sea1 ;scalar m1asigMCV = m1ta1<=ecmMCVm1 ;scalar m1asigMCV_df = (m1ta1<=ecmMCVm1 & p_value_df_dv1>0.05) ;post `sim' (m1asigMCV) (m1asigMCV_df) ;} ;} ;postclose `sim' ;} ;
} ;
} ;