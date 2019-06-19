	/********************************
1_data.do

VC Summer 2010, GD May-June 2011
GD December 2015
GD February 2016 --- ADDED F-TESTS for the IV
Builds the two working data sets
Generates the instruments for the estimation of supply curves for travel in the US and for each msa. 	
Estimates the supply curves in various ways
Computes the travel cost indices

*********************************/





**************  Start  ********************************************************;

*set up;
#delimit;
clear all;

set memory 3g;

set matsize 5000;
set more 1;
quietly capture log close;
cd;


global data_source  D:\S_congestion\data_processing\data_generated\ ;

global output D:\S_congestion\data_processing\dofiles\Revision\output ;



*********************************************************************************************;
************** Regression 4  MANUAL VERSION D  **********************************************;
*      IV distance in log in the same msa by trip purpose        ***********************************;
*********************************************************************************************;


* Manual IV with 2 estimations covering 3 regressions;

if 1==0{;



local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";
local controls2 = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker";
local controls3 = "income1 income2 educ1 start1 start2 start3 start4 r_age r_sex tdwknd";

foreach msanum in 50 100 /*240*/ {; 

use "$data_source\working_npts.dta";
keep if rank_msa <= `msanum';

rename inst_ownA inst_own;
gen inst_ownA = log(inst_own);

* First, compute supply curves for the United States, for each year;
foreach year in 95 01 09 {;

* create storage for the step 2 ceofficients;
gen CdUS_`year' = .;
gen gdUS_`year' = .;
forvalues i = 1(1)2 {;
gen b_income`i'US_`year'  =. ;
};
forvalues i = 1(1)4 {;
gen b_start`i'US_`year' =. ;
};
forvalues i = 1(1)2 {;
gen b_educ`i'US_`year' =. ;
};
gen b_r_ageUS_`year' =. ; 
gen b_r_sexUS_`year' =. ; 
gen b_tdwkndUS_`year' =. ;
gen b_workerUS_`year' =.  ;
gen b_blackUS_`year' =.  ;

ivreg2 l_p (l_trpmiles = inst_ownA) `controls' if year==`year', cl(msa) robust;

*store the coefficients of step 2;
forvalues i = 1(1)2 {;
replace b_income`i'US_`year'  = _b[income`i'] ;
};
forvalues i = 1(1)2 {;
replace b_educ`i'US_`year'  = _b[educ`i'] ;
};
replace b_r_ageUS_`year' = _b[r_age];
replace b_r_sexUS_`year' = _b[r_sex];
replace b_tdwkndUS_`year' = _b[tdwknd];
replace b_workerUS_`year' = _b[worker];
replace b_blackUS_`year' = _b[black];
forvalues i = 1(1)4 {;
replace b_start`i'US_`year'  = _b[start`i'] ;
};	
replace CdUS_`year' = _b[_cons];
replace gdUS_`year' = _b[l_trpmiles];

};



*Step1: first stage 1 of the regression;

*interacted terms;
forvalues id = 1(1)`msanum' {;
gen m_`id' = 0;

replace m_`id' = 1 if rank_msa == `id';
};

forvalues id = 1(1)`msanum' {;
gen inst_ownA_`id' = inst_ownA*m_`id';
};

compress;

save "$data_source\temp", replace;

foreach year in 95 01 09 {;

reg l_trpmiles m_1-m_`msanum' inst_ownA_1-inst_ownA_`msanum' `controls' if year == `year', noconstant cl(msa) robust;

* store the coefficients of step 1 as scalars;
forvalues i = 1(1)2 {;
scalar b1_income`i'  = _b[income`i'] ; 
};
forvalues i = 1(1)2 {;
scalar b1_educ`i'  = _b[educ`i'] ;
};
scalar b1_r_age = _b[r_age];
scalar b1_r_sex = _b[r_sex];
scalar b1_tdwknd = _b[tdwknd];
scalar b1_worker = _b[worker];
scalar b1_black = _b[black];
forvalues i = 1(1)4 {;
scalar b1_start`i' = _b[start`i'] ;
};	

* get the predicted values by city;		  
predict dist_hat;

forvalues id = 1(1)`msanum' {;
gen mdist_`id' = dist_hat*m_`id';
};

drop dist_hat;

* create storage for the step 2 ceofficients;
gen Cd_`year' = .;
gen gd_`year' = .;
gen Cd_sd_`year' = .;
gen gd_sd_`year' = .;

gen Ftest_`year'=.;


forvalues i = 1(1)2 {;
gen b_income`i'_`year'  =. ;
};
forvalues i = 1(1)4 {;
gen b_start`i'_`year' =. ;
};
forvalues i = 1(1)2 {;
gen b_educ`i'_`year' =. ;
};
gen b_r_age_`year' =. ; 
gen b_r_sex_`year' =. ; 
gen b_tdwknd_`year' =. ;
gen b_worker_`year' =.  ;
gen b_black_`year' =.  ;

keep `controls' l_p l_trpmiles trpmiles F* inst_ownA* msa b_* obs_number  Cd* gd* md* m_* rank_msa year w*; 

reg l_p m_1-m_`msanum' mdist_1-mdist_`msanum' `controls' if year == `year', noconstant cl(msa) robust;

*store the coefficients of step 2 both as variables and scalars;
forvalues i = 1(1)2 {;
replace b_income`i'_`year'  = _b[income`i'] ;
scalar b2_income`i'  = _b[income`i'] ; 
};
forvalues i = 1(1)2 {;
replace b_educ`i'_`year'  = _b[educ`i'] ;
scalar b2_educ`i'  = _b[educ`i'] ;
};
replace b_r_age_`year' = _b[r_age];
scalar b2_r_age = _b[r_age];
replace b_r_sex_`year' = _b[r_sex];
scalar b2_r_sex = _b[r_sex];
replace b_tdwknd_`year' = _b[tdwknd];
scalar b2_tdwknd = _b[tdwknd];
replace b_worker_`year' = _b[worker];
scalar b2_worker = _b[worker];
replace b_black_`year' = _b[black];
scalar b2_black = _b[black];
forvalues i = 1(1)4 {;
replace b_start`i'_`year'  = _b[start`i'] ;
scalar b2_start`i' = _b[start`i'];
};	

*create all the constraints;
local k = 1;

forvalues i = 1(1)2 {;
constraint `k' [l_trpmiles]income`i' = b1_income`i';
local k = `k'+1;
constraint `k' [l_p]income`i' = b2_income`i';
local k = `k'+1;
};

forvalues i = 1(1)2 {;
constraint `k' [l_trpmiles]educ`i' = b1_educ`i';
local k=`k'+1;
constraint `k' [l_p]educ`i' = b2_educ`i';
local k=`k'+1;
};

constraint `k' [l_trpmiles]r_age = b1_r_age;
local k=`k'+1;
constraint `k' [l_p]r_age = b2_r_age;
local k=`k'+1;

constraint `k' [l_trpmiles]r_sex = b1_r_sex;
local k=`k'+1;
constraint `k' [l_p]r_sex = b2_r_sex;
local k=`k'+1;


constraint `k' [l_trpmiles]tdwknd = b1_tdwknd;
local k=`k'+1;
constraint `k' [l_p]tdwknd = b2_tdwknd;
local k=`k'+1;

constraint `k' [l_trpmiles]worker = b1_worker;
local k=`k'+1;
constraint `k' [l_p]worker = b2_worker;
local k=`k'+1;

constraint `k' [l_trpmiles]black = b1_black;
local k=`k'+1;
constraint `k' [l_p]black = b2_black;
local k=`k'+1;

forvalues i = 1(1)4 {;
constraint `k' [l_trpmiles]start`i' = b1_start`i';
local k=`k'+1;
constraint `k' [l_p]start`i' = b2_start`i';
local k=`k'+1;
};

local K = `k'-1;

* ONLY 100 cities estimated here even on the larger sample of observations;

local num = min(100,`msanum');

forvalues id = 1(1)`num' {;

* special treatment when the black dummy is not identified in the city regression;
total black if (rank_msa==`id' & year==`year');
scalar threshold=_b[black];
local z = 1;
if (threshold<2 | (`id'==90 & `year'==95) | (`id'==92 & `year'==95)| (`id'==96 & `year'==95) | (`id'==101 & `year'==95) | (`id'==111 & `year'==95)
| (`id'==119 & `year'==95) | (`id'==132 & `year'==95) | (`id'==66& `year'==01) | (`id'==66& `year'==09)){;
local z = 0 ;
};

display "`id'---`year'---`z'";

if `z'==1{;
reg3 	(l_p l_trpmiles `controls', cl(msa)) (l_trpmiles inst_ownA `controls', cl(msa)) if (rank_msa==`id' & year==`year')
	 , 2sls cons(1-`K');

};

if `z'==0{;
reg3 	(l_p l_trpmiles `controls2', cl(msa)) (l_trpmiles inst_ownA `controls2', cl(msa)) if (rank_msa==`id' & year==`year') 
	 , 2sls cons(1-16 19-`K');
};


replace Cd_`year' = _b[_cons] if rank_msa==`id';
replace gd_`year' = _b[l_trpmiles] if rank_msa==`id';

replace Cd_sd_`year' = _se[_cons] if rank_msa==`id';
replace gd_sd_`year' = _se[l_trpmiles] if rank_msa==`id';


test inst_ownA;

replace Ftest_`year' = r(chi2) if rank_msa==`id';


};

drop mdist_*;

compress;


};


save "$data_source\npts_Cd_`msanum'4", replace;

};




};



if 1==0{;

************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 /*240*/ {;

use "$data_source\npts_Cd_`msanum'4";

keep if rank_msa <= `msanum';

drop  m_* inst* ;


******************** 1) US trips at MSA price*********************************;

gen S1_95 = .;
gen S1_01 = .;
gen S1_09 = .;

gen weight = wtperfin/1000;


local num = min(100,`msanum');
	
foreach year in 95 01 09 {;
forvalues id = 1(1)`num'{; 

	quietly mean Cd_`year' if rank_msa == `id';
	scalar Cmsa = _b[Cd_`year'];
	quietly mean gd_`year' if rank_msa == `id';
	scalar gmsa = _b[gd_`year'];
	gen t = weight*trpmiles*exp(Cmsa + b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker + b_black_`year'*black +
	 b_educ1_`year'*educ1 + b_educ2_`year'*educ2 +
	 b_income1_`year'*income1 + b_income2_`year'*income2 +
         b_start1_`year'*start1 + b_start2_`year'*start2 + b_start3_`year'*start3 + b_start4_`year'*start4 + 
	 gmsa*ln(trpmiles));
	quietly total t if year == `year';
	scalar St = _b[t];
	replace S1_`year' = St if rank_msa == `id';
	drop t;

};
};

********************** 2) US trips at US price*****************************;

gen S2_95 = .;
gen S2_01 = .;
gen S2_09 = .;


foreach year in 95 01 09 {;
	gen t = weight*trpmiles*exp(CdUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + 	          
	 b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + 
	 b_educ1US_`year'*educ1 + b_educ2US_`year'*educ2 +
	 b_income1US_`year'*income1 + b_income2US_`year'*income2 +
	 b_start1US_`year'*start1 + b_start2US_`year'*start2 + b_start3US_`year'*start3 + 	
 	 b_start4US_`year'*start4 + 
	 gdUS_`year'*ln(trpmiles));
	quietly total t if year == `year';
	replace S2_`year' = _b[t];
    drop t;

};

* Generate Laspeyres price indexes, and their logs;

foreach year in 95 01 09 {;

gen Ld_`year' = S1_`year'/S2_`year';

gen l_Ld_`year' = ln(Ld_`year');



};
collapse  (mean)  	Ld_95 Ld_01 Ld_09 l_Ld_95 l_Ld_01 l_Ld_09
					CdUS_95 CdUS_01 CdUS_09 gdUS_95 gdUS_01 gdUS_09 
					Cd_95 Cd_01 Cd_09 gd_95 gd_01 gd_09
					Cd_sd_95 Cd_sd_01 Cd_sd_09 gd_sd_95 gd_sd_01 gd_sd_09
                  rank_msa F*, by(msa);
				 
sort msa;
	
save "$output\npts_index_d_`msanum'4", replace;

};


};




*********************************************************************************************;
************** Regression 5  ****************************************************************;
*      IV distance in comparable msa by trip purpose  (based on regression 4C)    ***********;
*********************************************************************************************;


* Manual IV with 2 estimations covering 3 regressions;

if 1==0{;


foreach z in 2 {;
	if `z'==1{;
		local I "A";
		local v "a";		
			};
	if `z'==2{;
		local I "B";
		local v "a";		
			};
	if `z'==3{;
		local I "C";
		local v "c";		
			};
	if `z'==4{;
		local I "D";
		local v "d";		
			};




local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";
local controls2 = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker";


foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";

sort msa;

merge msa using "$data_source\IV`z'.dta";;

tab _merge;
keep if _merge == 3;
drop _merge;

keep if rank_msa <= `msanum';

gen purpinst = .;

foreach year in 95 01 09 {;
foreach i in 1 2 3 4 5 6 7 8 10 11 {;			
replace purpinst =  inst_neigh`I'_`i'_`year' if (year == `year' & whytrp90 == `i');
};
};

gen l_purpinst = ln(purpinst);

*interacted terms;
forvalues id = 1(1)`msanum' {;
gen m_`id' = 0;
replace m_`id' = 1 if rank_msa == `id';
};

*forvalues id = 1(1)`msanum' {;
*gen mdist_`id' = l_trpmiles*m_`id';
*};

forvalues id = 1(1)`msanum' {;
gen l_purpinst_`id' = l_purpinst*m_`id';
};

* First, compute supply curves for the United States, for each year;
foreach year in 95 01 09 {;

* create storage for the step 2 ceofficients;
gen CeUS_`year' = .;
gen geUS_`year' = .;
forvalues i = 1(1)2 {;
gen b_income`i'US_`year'  =. ;
};
forvalues i = 1(1)4 {;
gen b_start`i'US_`year' =. ;
};
forvalues i = 1(1)2 {;
gen b_educ`i'US_`year' =. ;
};
gen b_r_ageUS_`year' =. ; 
gen b_r_sexUS_`year' =. ; 
gen b_tdwkndUS_`year' =. ;
gen b_workerUS_`year' =.  ;
gen b_blackUS_`year' =.  ;

ivreg2 l_p (l_trpmiles = l_purpinst) `controls' if year==`year', cl(msa) robust;

*store the coefficients of step 2;
forvalues i = 1(1)2 {;
replace b_income`i'US_`year'  = _b[income`i'] ;
};
forvalues i = 1(1)2 {;
replace b_educ`i'US_`year'  = _b[educ`i'] ;
};
replace b_r_ageUS_`year' = _b[r_age];
replace b_r_sexUS_`year' = _b[r_sex];
replace b_tdwkndUS_`year' = _b[tdwknd];
replace b_workerUS_`year' = _b[worker];
replace b_blackUS_`year' = _b[black];
forvalues i = 1(1)4 {;
replace b_start`i'US_`year'  = _b[start`i'] ;
};	
replace CeUS_`year' = _b[_cons];
replace geUS_`year' = _b[l_trpmiles];

};



*Step1: first stage 1 of the regression;



foreach year in 95 01 09 {;

reg l_trpmiles m_1-m_`msanum' l_purpinst_1-l_purpinst_`msanum' `controls' if year == `year', noconstant cl(msa) robust;

* store the coefficients of step 1 as scalars;
forvalues i = 1(1)2 {;
scalar b1_income`i'  = _b[income`i'] ; 
};
forvalues i = 1(1)2 {;
scalar b1_educ`i'  = _b[educ`i'] ;
};
scalar b1_r_age = _b[r_age];
scalar b1_r_sex = _b[r_sex];
scalar b1_tdwknd = _b[tdwknd];
scalar b1_worker = _b[worker];
scalar b1_black = _b[black];
forvalues i = 1(1)4 {;
scalar b1_start`i' = _b[start`i'] ;
};	

* get the predicted values by city;		  
predict dist_hat;

forvalues id = 1(1)`msanum' {;
gen mdist_`id' = dist_hat*m_`id';
};

drop dist_hat;

* create storage for the step 2 ceofficients;
gen Ce_`year' = .;
gen ge_`year' = .;
gen Ce_sd_`year' = .;
gen ge_sd_`year' = .;

gen Ftest_`year'=.;

forvalues i = 1(1)2 {;
gen b_income`i'_`year'  =. ;
};
forvalues i = 1(1)4 {;
gen b_start`i'_`year' =. ;
};
forvalues i = 1(1)2 {;
gen b_educ`i'_`year' =. ;
};
gen b_r_age_`year' =. ; 
gen b_r_sex_`year' =. ; 
gen b_tdwknd_`year' =. ;
gen b_worker_`year' =.  ;
gen b_black_`year' =.  ;
 

reg l_p m_1-m_`msanum' mdist_1-mdist_`msanum' `controls' if year == `year', noconstant cl(msa) robust;

*store the coefficients of step 2 both as variables and scalars;
forvalues i = 1(1)2 {;
replace b_income`i'_`year'  = _b[income`i'] ;
scalar b2_income`i'  = _b[income`i'] ; 
};
forvalues i = 1(1)2 {;
replace b_educ`i'_`year'  = _b[educ`i'] ;
scalar b2_educ`i'  = _b[educ`i'] ;
};
replace b_r_age_`year' = _b[r_age];
scalar b2_r_age = _b[r_age];
replace b_r_sex_`year' = _b[r_sex];
scalar b2_r_sex = _b[r_sex];
replace b_tdwknd_`year' = _b[tdwknd];
scalar b2_tdwknd = _b[tdwknd];
replace b_worker_`year' = _b[worker];
scalar b2_worker = _b[worker];
replace b_black_`year' = _b[black];
scalar b2_black = _b[black];
forvalues i = 1(1)4 {;
replace b_start`i'_`year'  = _b[start`i'] ;
scalar b2_start`i' = _b[start`i'];
};	
drop mdist_*;

*create all the constraints;
local k = 1;

forvalues i = 1(1)2 {;
constraint `k' [l_trpmiles]income`i' = b1_income`i';
local k = `k'+1;
constraint `k' [l_p]income`i' = b2_income`i';
local k = `k'+1;
};

forvalues i = 1(1)2 {;
constraint `k' [l_trpmiles]educ`i' = b1_educ`i';
local k=`k'+1;
constraint `k' [l_p]educ`i' = b2_educ`i';
local k=`k'+1;
};

constraint `k' [l_trpmiles]r_age = b1_r_age;
local k=`k'+1;
constraint `k' [l_p]r_age = b2_r_age;
local k=`k'+1;

constraint `k' [l_trpmiles]r_sex = b1_r_sex;
local k=`k'+1;
constraint `k' [l_p]r_sex = b2_r_sex;
local k=`k'+1;


constraint `k' [l_trpmiles]tdwknd = b1_tdwknd;
local k=`k'+1;
constraint `k' [l_p]tdwknd = b2_tdwknd;
local k=`k'+1;

constraint `k' [l_trpmiles]worker = b1_worker;
local k=`k'+1;
constraint `k' [l_p]worker = b2_worker;
local k=`k'+1;

constraint `k' [l_trpmiles]black = b1_black;
local k=`k'+1;
constraint `k' [l_p]black = b2_black;
local k=`k'+1;

forvalues i = 1(1)4 {;
constraint `k' [l_trpmiles]start`i' = b1_start`i';
local k=`k'+1;
constraint `k' [l_p]start`i' = b2_start`i';
local k=`k'+1;
};

local K = `k'-1;

* ONLY 100 cities estimated here even on the larger sample of observations;

local num = min(100,`msanum');

forvalues id = 1(1)`num' {;

* special treatment when the black dummy is not identified in the city regression;
total black if (rank_msa==`id' & year==`year');
scalar threshold=_b[black];
local q = 1;
if (threshold<2 | (`id'==92 & `year'==95) | (`id'==96 & `year'==95)  | (`id'==66 & `year'==09)  ){;
local q = 0 ;
};

display "`id'---`year'---`q'";

if `q'==1{;
reg3 	(l_p l_trpmiles `controls', cl(msa)) (l_trpmiles l_purpinst `controls', cl(msa)) if (rank_msa==`id' & year==`year')
	 , 2sls cons(1-`K');
};

if `q'==0{;
reg3 	(l_p l_trpmiles `controls2', cl(msa)) (l_trpmiles l_purpinst `controls2', cl(msa)) if (rank_msa==`id' & year==`year') 
	 , 2sls cons(1-16 19-`K');
};


replace Ce_`year' = _b[_cons] if rank_msa==`id';
replace ge_`year' = _b[l_trpmiles] if rank_msa==`id';

replace Ce_sd_`year' = _se[_cons] if rank_msa==`id';
replace ge_sd_`year' = _se[l_trpmiles] if rank_msa==`id';


test l_purpinst;

replace Ftest_`year' = r(chi2) if rank_msa==`id';
};



compress;


};


keep `controls' F* l_p l_trpmiles trpmiles l_purpinst* msa b_* obs_number  Ce* ge* rank_msa year wtperfin;

save "$data_source\npts_Ce_`msanum'`z'", replace;

};




};

};



if 1==0{;


foreach z in 2 {;
	if `z'==1{;
		local I "A";
		local v "a";		
			};
	if `z'==2{;
		local I "B";
		local v "a";		
			};
	if `z'==3{;
		local I "C";
		local v "c";		
			};
	if `z'==4{;
		local I "D";
		local v "d";		
			};

************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 /*240*/ {;

use "$data_source\npts_Ce_`msanum'`z'";

keep if rank_msa <= `msanum';

*Sdrop  m_* inst* ;


******************** 1) US trips at MSA price*********************************;

gen S1_95 = .;
gen S1_01 = .;
gen S1_09 = .;

gen weight = wtperfin/1000;


local num = min(100,`msanum');
	
foreach year in 95 01 09 {;
forvalues id = 1(1)`num'{; 

	quietly mean Ce_`year' if rank_msa == `id';
	scalar Cmsa = _b[Ce_`year'];
	quietly mean ge_`year' if rank_msa == `id';
	scalar gmsa = _b[ge_`year'];
	gen t = weight*trpmiles*exp(Cmsa + b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker + b_black_`year'*black +
	 b_educ1_`year'*educ1 + b_educ2_`year'*educ2 +
	 b_income1_`year'*income1 + b_income2_`year'*income2 +
         b_start1_`year'*start1 + b_start2_`year'*start2 + b_start3_`year'*start3 + b_start4_`year'*start4 + 
	 gmsa*ln(trpmiles));
	quietly total t if year == `year';
	scalar St = _b[t];
	replace S1_`year' = St if rank_msa == `id';
	drop t;

};
};




********************** 2) US trips at US price*****************************;

gen S2_95 = .;
gen S2_01 = .;
gen S2_09 = .;


foreach year in 95 01 09 {;
	gen t = weight*trpmiles*exp(CeUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + 	          
	 b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + 
	 b_educ1US_`year'*educ1 + b_educ2US_`year'*educ2 +
	 b_income1US_`year'*income1 + b_income2US_`year'*income2 +
	 b_start1US_`year'*start1 + b_start2US_`year'*start2 + b_start3US_`year'*start3 + 	
 	 b_start4US_`year'*start4 + 
	 geUS_`year'*ln(trpmiles));
	quietly total t if year == `year';
	replace S2_`year' = _b[t];
    drop t;

};

		
************** 3) MSA trips at US prices **********************;

gen S3_95 = .;
gen S3_01 = .;
gen S3_09 = .;

foreach year in 95 01 09 {;
	
	gen t = weight*trpmiles*exp(CeUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black +
	 b_educ1US_`year'*educ1 + b_educ2US_`year'*educ2 +
	 b_income1US_`year'*income1 + b_income2US_`year'*income2 +
	 b_start1US_`year'*start1 + b_start2US_`year'*start2 + b_start3US_`year'*start3 + 	
         b_start4US_`year'*start4 +	 
	 geUS_`year'*ln(trpmiles));
	
forvalues id = 1(1)`msanum' {; 
	quietly total t if (year == `year' & rank_msa == `id');
	scalar St = _b[t];
	replace S3_`year' = St if rank_msa == `id';
};
	drop t;
};



************************ 4) MSA trips at msa price**********************;

gen S4_95 = .;
gen S4_01 = .;
gen S4_09 = .;


foreach year in 95 01 09 {;
	
	gen t = weight*trpmiles*exp(Ce_`year'+ b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker +  b_black_`year'*black + 
	 b_educ1_`year'*educ1 + b_educ2_`year'*educ2 +
	 b_income1_`year'*income1 + b_income2_`year'*income2 +
	 b_start1_`year'*start1 + b_start2_`year'*start2 + b_start3_`year'*start3 + b_start4_`year'*start4 + 
         ge_`year'*ln(trpmiles));
	
forvalues id = 1(1)`msanum' {; 
	quietly total t if (year ==`year' & rank_msa == `id');
	scalar St = _b[t];
	replace S4_`year' = St if rank_msa == `id';
};
drop t;
};


* Generate Laspeyres, Paasche, Fisher price indexes, and their logs;

foreach year in 95 01 09 {;

gen Le_`year' = S1_`year'/S2_`year';

gen l_Le_`year' = ln(Le_`year');


gen Pe_`year' = S4_`year'/S3_`year';
gen Fe_`year' = sqrt(Le_`year'*Pe_`year');

gen l_Pe_`year' = ln(Pe_`year');
gen l_Fe_`year' = ln(Fe_`year');

};

collapse  (mean)  	Le_95 Le_01 Le_09 l_Le_95 l_Le_01 l_Le_09 Pe_95 Pe_01 Pe_09 l_Pe_95 l_Pe_01 l_Pe_09 
					F*
					CeUS_95 CeUS_01 CeUS_09 geUS_95 geUS_01 geUS_09 
					Ce_95 Ce_01 Ce_09 ge_95 ge_01 ge_09
					Ce_sd_95 Ce_sd_01 Ce_sd_09 ge_sd_95 ge_sd_01 ge_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_e_`msanum'`z'", replace;

};


};


};



*********************************************************************************************;
************** Regression 6  ****************************************************************;
*      IV: trip purpose  (based on regression 4C)    ****************************************;
*********************************************************************************************;


* Manual IV with 2 estimations covering 3 regressions;

if 1==0{;

clear all;

set memory 5g;

set matsize 10000;

set maxvar 10000;

foreach z in /*1*/ 3 {;
	if `z'==1{;
		local I "A";
		local v "a";		
			};
	if `z'==2{;
		local I "B";
		local v "b";		
			};
	if `z'==3{;
		local I "C";
		local v "c";		
			};
	if `z'==4{;
		local I "D";
		local v "d";		
			};


local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";
local controls2 = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker";


foreach msanum in 50 100 /*240*/ {; 

use "$data_source\working_npts.dta";

drop if (whytrp90 == 7 | whytrp90 == 11 );

sort msa;

keep if rank_msa <= `msanum';

drop hh* month* depart*  y_95 y_01 y_09 r_sex_95 r_sex_01 r_sex_09;

compress;

if `z'==1{; *whytrp90==10 (other recreational) is used as reference;
local max = 7;
gen inst_1=0;
gen inst_2=0;
gen inst_3=0;
gen inst_4=0;
gen inst_5=0;
gen inst_6=0;
gen inst_7=0;


replace inst_1=1 if whytrp90==1;
replace inst_2=1 if whytrp90==2;
replace inst_3=1 if whytrp90==3;
replace inst_4=1 if whytrp90==4;
replace inst_5=1 if whytrp90==5;
replace inst_6=1 if whytrp90==6;
replace inst_7=1 if whytrp90==8;
};


if `z'==2{;
*whytrp90==8 and whytrp90==10 (visit friends and other recreational) is used as reference;
local max = 3;
gen inst_1=0;
gen inst_2=0;
gen inst_3=0;

replace inst_1=1 if (whytrp90==1 | whytrp90==2);
replace inst_2=1 if (whytrp90==3 | whytrp90==4);
replace inst_3=1 if (whytrp90==5 | whytrp90==6);

};

if `z'==3{;
local max = 2;
gen inst_1=0;
gen inst_2=0;
replace inst_1=1 if (whytrp90==1 | whytrp90==2);
replace inst_2=1 if (whytrp90==3 | whytrp90==4 | whytrp90==5 | whytrp90==6);
drop if (whytrp90 == 8 | whytrp90 == 10);
};


if `z'==4{;
local max = 2;
gen inst_1=0;
gen inst_2=0;
replace inst_1=1 if (whytrp90==1 | whytrp90==2);
replace inst_2=1 if (whytrp90==4 | whytrp90==5 | whytrp90==6 | whytrp90==8);
drop if (whytrp90 == 3 | whytrp90 == 10);
};

*interacted terms;
forvalues id = 1(1)`msanum' {;
gen m_`id' = 0;
replace m_`id' = 1 if rank_msa == `id';
};

compress;

if (`z'>1 | (`z'==1 & `msanum'<240)) {; 

forvalues id = 1(1)`msanum' {;
forvalues inst = 1(1)`max' {;
gen inst_`inst'_`id' = inst_`inst'*m_`id';
};
};
};

* specific procedure when z=1 with 240 cities given the large number of variables;
if (`z'==1 & `msanum'==240) {; 

forvalues id = 1(1)120 {;
forvalues inst = 1(1)`max' {;
gen inst_`inst'_`id' = inst_`inst'*m_`id';
};
};
compress;
forvalues id = 121(1)200 {;
forvalues inst = 1(1)`max' {;
gen inst_`inst'_`id' = inst_`inst'*m_`id';
};
};
compress;
forvalues id = 201(1)240 {;
forvalues inst = 1(1)`max' {;
gen inst_`inst'_`id' = inst_`inst'*m_`id';
};
};
compress;
};


* First, compute supply curves for the United States, for each year;
foreach year in 95 01 09 {;

* create storage for the step 2 ceofficients;
gen CfUS_`year' = .;
gen gfUS_`year' = .;
forvalues i = 1(1)2 {;
gen b_income`i'US_`year'  =. ;
};
forvalues i = 1(1)4 {;
gen b_start`i'US_`year' =. ;
};
forvalues i = 1(1)2 {;
gen b_educ`i'US_`year' =. ;
};
gen b_r_ageUS_`year' =. ; 
gen b_r_sexUS_`year' =. ; 
gen b_tdwkndUS_`year' =. ;
gen b_workerUS_`year' =.  ;
gen b_blackUS_`year' =.  ;

ivreg2 l_p (l_trpmiles = inst_1-inst_`max') `controls' if year==`year', cl(msa) robust;

*store the coefficients of step 2;
forvalues i = 1(1)2 {;
replace b_income`i'US_`year'  = _b[income`i'] ;
};
forvalues i = 1(1)2 {;
replace b_educ`i'US_`year'  = _b[educ`i'] ;
};
replace b_r_ageUS_`year' = _b[r_age];
replace b_r_sexUS_`year' = _b[r_sex];
replace b_tdwkndUS_`year' = _b[tdwknd];
replace b_workerUS_`year' = _b[worker];
replace b_blackUS_`year' = _b[black];
forvalues i = 1(1)4 {;
replace b_start`i'US_`year'  = _b[start`i'] ;
};	
replace CfUS_`year' = _b[_cons];
replace gfUS_`year' = _b[l_trpmiles];

compress;

};

*Step1: first stage 1 of the regression;

foreach year in 95 01 09 {;

reg l_trpmiles m_1-m_`msanum' inst_1_1-inst_`max'_`msanum' `controls' if year == `year', noconstant cl(msa) robust;

* store the coefficients of step 1 as scalars;
forvalues i = 1(1)2 {;
scalar b1_income`i'  = _b[income`i'] ; 
};
forvalues i = 1(1)2 {;
scalar b1_educ`i'  = _b[educ`i'] ;
};
scalar b1_r_age = _b[r_age];
scalar b1_r_sex = _b[r_sex];
scalar b1_tdwknd = _b[tdwknd];
scalar b1_worker = _b[worker];
scalar b1_black = _b[black];
forvalues i = 1(1)4 {;
scalar b1_start`i' = _b[start`i'] ;
};	

* get the predicted values by city;		  
predict dist_hat;

forvalues id = 1(1)`msanum' {;
gen mdist_`id' = dist_hat*m_`id';
};

drop dist_hat;

* create storage for the step 2 coefficients;
gen Cf_`year' = .;
gen gf_`year' = .;
gen Cf_sd_`year' = .;
gen gf_sd_`year' = .;

gen Ftest_`year'=.;

forvalues i = 1(1)2 {;
gen b_income`i'_`year'  =. ;
};
forvalues i = 1(1)4 {;
gen b_start`i'_`year' =. ;
};
forvalues i = 1(1)2 {;
gen b_educ`i'_`year' =. ;
};
gen b_r_age_`year' =. ; 
gen b_r_sex_`year' =. ; 
gen b_tdwknd_`year' =. ;
gen b_worker_`year' =.  ;
gen b_black_`year' =.  ;
 

reg l_p m_1-m_`msanum' mdist_1-mdist_`msanum' `controls' if year == `year', noconstant cl(msa) robust;

*store the coefficients of step 2 both as variables and scalars;
forvalues i = 1(1)2 {;
replace b_income`i'_`year'  = _b[income`i'] ;
scalar b2_income`i'  = _b[income`i'] ; 
};
forvalues i = 1(1)2 {;
replace b_educ`i'_`year'  = _b[educ`i'] ;
scalar b2_educ`i'  = _b[educ`i'] ;
};
replace b_r_age_`year' = _b[r_age];
scalar b2_r_age = _b[r_age];
replace b_r_sex_`year' = _b[r_sex];
scalar b2_r_sex = _b[r_sex];
replace b_tdwknd_`year' = _b[tdwknd];
scalar b2_tdwknd = _b[tdwknd];
replace b_worker_`year' = _b[worker];
scalar b2_worker = _b[worker];
replace b_black_`year' = _b[black];
scalar b2_black = _b[black];
forvalues i = 1(1)4 {;
replace b_start`i'_`year'  = _b[start`i'] ;
scalar b2_start`i' = _b[start`i'];
};	
drop mdist_*;

*create all the constraints;
local k = 1;

forvalues i = 1(1)2 {;
constraint `k' [l_trpmiles]income`i' = b1_income`i';
local k = `k'+1;
constraint `k' [l_p]income`i' = b2_income`i';
local k = `k'+1;
};
forvalues i = 1(1)2 {;
constraint `k' [l_trpmiles]educ`i' = b1_educ`i';
local k=`k'+1;
constraint `k' [l_p]educ`i' = b2_educ`i';
local k=`k'+1;
};
constraint `k' [l_trpmiles]r_age = b1_r_age;
local k=`k'+1;
constraint `k' [l_p]r_age = b2_r_age;
local k=`k'+1;
constraint `k' [l_trpmiles]r_sex = b1_r_sex;
local k=`k'+1;
constraint `k' [l_p]r_sex = b2_r_sex;
local k=`k'+1;
constraint `k' [l_trpmiles]tdwknd = b1_tdwknd;
local k=`k'+1;
constraint `k' [l_p]tdwknd = b2_tdwknd;
local k=`k'+1;
constraint `k' [l_trpmiles]worker = b1_worker;
local k=`k'+1;
constraint `k' [l_p]worker = b2_worker;
local k=`k'+1;
constraint `k' [l_trpmiles]black = b1_black;
local k=`k'+1;
constraint `k' [l_p]black = b2_black;
local k=`k'+1;
forvalues i = 1(1)4 {;
constraint `k' [l_trpmiles]start`i' = b1_start`i';
local k=`k'+1;
constraint `k' [l_p]start`i' = b2_start`i';
local k=`k'+1;
};

local K = `k'-1;

* ONLY 100 cities estimated here even on the larger sample of observations;

local num = min(100,`msanum');

forvalues id = 1(1)`num' {;

* special treatment when the black dummy is not identified in the city regression;
total black if (rank_msa==`id' & year==`year');
scalar threshold=_b[black];
local q = 1;
if (threshold<2 | (`id'==92 & `year'==95) | (`id'==96 & `year'==95) | (`id'==66 & `year'==09) ){;
local q = 0 ;
};

*if ((`id'==89 & `year'==09) ){;
*local q = 2 ;
*};


display "`id'---`year'---`q'";

if `q'==0{;
reg3 	(l_p l_trpmiles `controls2', cl(msa)) (l_trpmiles inst_1-inst_`max' `controls2', cl(msa)) if (rank_msa==`id' & year==`year') 
	 , 2sls cons(1-16 19-`K');
};

if `q'==1{;
reg3 	(l_p l_trpmiles `controls', cl(msa)) (l_trpmiles inst_1-inst_`max' `controls', cl(msa)) if (rank_msa==`id' & year==`year')
	 , 2sls cons(1-`K');
};



replace Cf_`year' = _b[_cons] if rank_msa==`id';
replace gf_`year' = _b[l_trpmiles] if rank_msa==`id';


replace Cf_sd_`year' = _se[_cons] if rank_msa==`id';
replace gf_sd_`year' = _se[l_trpmiles] if rank_msa==`id';





if `z'==1{;
test inst_1 inst_2 inst_3 inst_4 inst_5 inst_6 inst_7;

replace Ftest_`year' = r(chi2)/7 if rank_msa==`id';
};

if `z'==3{;
test inst_1 inst_2 ;

replace Ftest_`year' = r(chi2)/2 if rank_msa==`id';
};


};
compress;
};

keep `controls' F* l_p l_trpmiles trpmiles inst* msa b_* obs_number  Cf* gf* rank_msa year wtperfin;

save "$data_source\npts_Cf_`msanum'`z'", replace;

};

};

clear all;

set memory 2g;

set matsize 1000;
};

if 1==0{;


foreach z in 1 3 {;
	if `z'==1{;
		local I "A";
		local v "a";		
			};
	if `z'==2{;
		local I "B";
		local v "a";		
			};
	if `z'==3{;
		local I "C";
		local v "c";		
			};
	if `z'==4{;
		local I "D";
		local v "d";		
			};

************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 /*240*/ {;

use "$data_source\npts_Cf_`msanum'`z'";

keep if rank_msa <= `msanum';

******************** 1) US trips at MSA price*********************************;

gen S1_95 = .;
gen S1_01 = .;
gen S1_09 = .;

gen weight = wtperfin/1000;


local num = min(100,`msanum');
	
foreach year in 95 01 09 {;
forvalues id = 1(1)`num'{; 

	quietly mean Cf_`year' if rank_msa == `id';
	scalar Cmsa = _b[Cf_`year'];
	quietly mean gf_`year' if rank_msa == `id';
	scalar gmsa = _b[gf_`year'];
	gen t = weight*trpmiles*exp(Cmsa + b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker + b_black_`year'*black +
	 b_educ1_`year'*educ1 + b_educ2_`year'*educ2 +
	 b_income1_`year'*income1 + b_income2_`year'*income2 +
         b_start1_`year'*start1 + b_start2_`year'*start2 + b_start3_`year'*start3 + b_start4_`year'*start4 + 
	 gmsa*ln(trpmiles));
	quietly total t if year == `year';
	scalar St = _b[t];
	replace S1_`year' = St if rank_msa == `id';
	drop t;

};
};

********************** 2) US trips at US price*****************************;

gen S2_95 = .;
gen S2_01 = .;
gen S2_09 = .;


foreach year in 95 01 09 {;
	gen t = weight*trpmiles*exp(CfUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + 	          
	 b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + 
	 b_educ1US_`year'*educ1 + b_educ2US_`year'*educ2 +
	 b_income1US_`year'*income1 + b_income2US_`year'*income2 +
	 b_start1US_`year'*start1 + b_start2US_`year'*start2 + b_start3US_`year'*start3 + 	
 	 b_start4US_`year'*start4 + 
	 gfUS_`year'*ln(trpmiles));
	quietly total t if year == `year';
	replace S2_`year' = _b[t];
    drop t;

};

* Generate Laspeyres price indexes, and their logs;

foreach year in 95 01 09 {;

gen Lf_`year' = S1_`year'/S2_`year';

gen l_Lf_`year' = ln(Lf_`year');



};
collapse  (mean)  	Lf_95 Lf_01 Lf_09 l_Lf_95 l_Lf_01 l_Lf_09
					CfUS_95 CfUS_01 CfUS_09 gfUS_95 gfUS_01 gfUS_09 
					Cf_95 Cf_01 Cf_09 gf_95 gf_01 gf_09
					Cf_sd_95 Cf_sd_01 Cf_sd_09 gf_sd_95 gf_sd_01 gf_sd_09 F*
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_f_`msanum'`z'", replace;

};


};


};




*********************************************************************************************;
************** Regression 7  ****************************************************************;
*  fixed effects and IV distance in comparable msa by trip purpose     **********************;
*********************************************************************************************;

if 1==1{;


foreach z in 2 {;
	if `z'==1{;
		local I "A";
		local v "a";		
			};
	if `z'==2{;
		local I "B";
		local v "a";		
			};
	if `z'==3{;
		local I "C";
		local v "c";		
			};
	if `z'==4{;
		local I "D";
		local v "d";		
			};


foreach msanum in 50 100 {; 

use "$data_source\working_npts.dta";

sort msa;

merge msa using "$data_source\IV`z'.dta";;

tab _merge;
keep if _merge == 3;
drop _merge;

keep if rank_msa <= `msanum';

gen purpinst = .;

foreach year in 95 01 09 {;
foreach i in 1 2 3 4 5 6 7 8 10 11 {;			
replace purpinst =  inst_neigh`I'_`i'_`year' if (year == `year' & whytrp90 == `i');
};
};

gen l_purpinst = ln(purpinst);

*interacted terms;
forvalues id = 1(1)`msanum' {;
gen m_`id' = 0;
replace m_`id' = 1 if rank_msa == `id';
};

*forvalues id = 1(1)`msanum' {;
*gen mdist_`id' = l_trpmiles*m_`id';
*};

forvalues id = 1(1)`msanum' {;
gen l_purpinst_`id' = l_purpinst*m_`id';
};

compress;

* First, compute supply curves for the United States, for each year;
/*foreach year in 95 01 09 {;

* create storage for the step 2 ceofficients;
gen CgUS_`year' = .;
gen ggUS_`year' = .;

xtivreg l_p (l_trpmiles = l_purpinst) if year==`year', fe i(pid);;

*store the coefficients of step 2;
replace CgUS_`year' = _b[_cons];
replace ggUS_`year' = _b[l_trpmiles];
};*/


foreach year in 95 01 09 {;
*gen Cg_`year' = .;
*gen gg_`year' = .;
*gen Cg_sd_`year' = .;
*gen gg_sd_`year' = .;


gen Ftest_`year'=.;

forvalues id = 1(1)`msanum' {;
xtivreg2 l_p (l_trpmiles = l_purpinst) if (year == `year' & rank_msa==`id'), first fe i(pid);
*replace Cg_`year' = _b[_cons] if rank_msa == `id';
*replace gg_`year' = _b[l_trpmiles] if rank_msa == `id';
*replace Cg_sd_`year' = _se[_cons] if rank_msa == `id';
*replace gg_sd_`year' = _se[l_trpmiles] if rank_msa == `id';



*test l_purpinst;

replace Ftest_`year' = e(widstat) if rank_msa==`id';



};

save "$data_source\temp", replace;

};


keep `controls' F* l_p l_trpmiles trpmiles l_purpinst* msa obs_number  /*Cg* gg* */ rank_msa year wtperfin;

save "$data_source\npts_Cg_`msanum'`z'sup", replace;

};




};

};



if 1==0{;


foreach z in 2 {;
	if `z'==1{;
		local I "A";
		local v "a";		
			};
	if `z'==2{;
		local I "B";
		local v "a";		
			};
	if `z'==3{;
		local I "C";
		local v "c";		
			};
	if `z'==4{;
		local I "D";
		local v "d";		
			};

************** Step 2: Compute Price index from supply curve *****************************;


foreach msanum in 50 100 240 {;

use "$data_source\npts_Cg_`msanum'`z'";

keep if rank_msa <= `msanum';




******************** 1) US trips at MSA price*********************************;

gen S1_95 = .;
gen S1_01 = .;
gen S1_09 = .;

gen weight = wtperfin/1000;


local num = min(100,`msanum');
	
foreach year in 95 01 09 {;
forvalues id = 1(1)`num'{; 

	quietly mean Cg_`year' if rank_msa == `id';
	scalar Cmsa = _b[Cg_`year'];
	quietly mean gg_`year' if rank_msa == `id';
	scalar gmsa = _b[gg_`year'];
	gen t = weight*trpmiles*exp(Cmsa + gmsa*ln(trpmiles));
	quietly total t if year == `year';
	scalar St = _b[t];
	replace S1_`year' = St if rank_msa == `id';
	drop t;

};
};

********************** 2) US trips at US price*****************************;

gen S2_95 = .;
gen S2_01 = .;
gen S2_09 = .;


foreach year in 95 01 09 {;
	gen t = weight*trpmiles*exp(CgUS_`year' + ggUS_`year'*ln(trpmiles));
	quietly total t if year == `year';
	replace S2_`year' = _b[t];
    drop t;

};

* Generate Laspeyres price indexes, and their logs;

foreach year in 95 01 09 {;

gen Lg_`year' = S1_`year'/S2_`year';

gen l_Lg_`year' = ln(Lg_`year');



};
collapse  (mean)  	Lg_95 Lg_01 Lg_09 l_Lg_95 l_Lg_01 l_Lg_09
					CgUS_95 CgUS_01 CgUS_09 ggUS_95 ggUS_01 ggUS_09 
					Cg_95 Cg_01 Cg_09 gg_95 gg_01 gg_09
					Cg_sd_95 Cg_sd_01 Cg_sd_09 gg_sd_95 gg_sd_01 gg_sd_09 F*
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_g_`msanum'`z'", replace;

};


};


};








foreach z in 1 2 3 4 {;
	if `z'==1{;
		local I "A";
		local v "a";		
			};
	if `z'==2{;
		local I "B";
		local v "a";		
			};
	if `z'==3{;
		local I "C";
		local v "c";		
			};
	if `z'==4{;
		local I "D";
		local v "d";		
			};


************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 /*240*/ {;

use "$data_source\npts_Ch_`msanum'`z'";

keep if rank_msa <= `msanum';


******************** 1) US trips at MSA price*********************************;

gen S1_95 = .;
gen S1_01 = .;
gen S1_09 = .;

gen weight = wtperfin/1000;


local num = min(100,`msanum');
	
foreach year in 95 01 09 {;
forvalues id = 1(1)`num'{; 

	quietly mean Ch_`year' if rank_msa == `id';
	scalar Cmsa = _b[Ch_`year'];
	quietly mean gh_`year' if rank_msa == `id';
	scalar gmsa = _b[gh_`year'];
	gen t = weight*trpmiles*exp(Cmsa + gmsa*ln(trpmiles));
	quietly total t if year == `year';
	scalar St = _b[t];
	replace S1_`year' = St if rank_msa == `id';
	drop t;

};
};

********************** 2) US trips at US price*****************************;

gen S2_95 = .;
gen S2_01 = .;
gen S2_09 = .;


foreach year in 95 01 09 {;
	gen t = weight*trpmiles*exp(ChUS_`year' + ghUS_`year'*ln(trpmiles));
	quietly total t if year == `year';
	replace S2_`year' = _b[t];
    drop t;

};

* Generate Laspeyres price indexes, and their logs;

foreach year in 95 01 09 {;

gen Lh_`year' = S1_`year'/S2_`year';

gen l_Lh_`year' = ln(Lh_`year');



};
collapse  (mean)  	Lh_95 Lh_01 Lh_09 l_Lh_95 l_Lh_01 l_Lh_09
					ChUS_95 ChUS_01 ChUS_09 ghUS_95 ghUS_01 ghUS_09 
					Ch_95 Ch_01 Ch_09 gh_95 gh_01 gh_09
					Ch_sd_95 Ch_sd_01 Ch_sd_09 gh_sd_95 gh_sd_01 gh_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_h_`msanum'`z'", replace;

};


};



exit;


