	/********************************
1_data.do

VC Summer 2010, GD May-June 2011
GD January 2016,


Builds on 1_step1.do
Generates extra results required at the revision for the first step

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
************** Regression 2f                              ****************--*****************;
*********************************************************************************************:
*******    OLS with controls censoring the top and bottom quartiles             ************;


if 1==0 {;


************** Step 1: Supply curve estimation using OLS with controls *******************; 

* Decide how many msas to keep;
foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";
 
keep if rank_msa <= `msanum';

local controls "hh_income_2 hh_income_3 hh_income_4 hh_income_5 hh_income_6 hh_income_7 
hh_income_8 hh_income_9 hh_income_10 hh_income_11 hh_income_12 hh_income_13 hh_income_14 
hh_income_15 hh_income_16 hh_income_17 hh_income_18 
hh_education_2 hh_education_3 hh_education_4 hh_education_5 r_age r_sex tdwknd 
depart_1 depart_2 depart_3 depart_4 depart_5 depart_6 depart_7 depart_8 depart_9 depart_10 depart_11 depart_12 depart_13 depart_14 depart_15 depart_16 depart_17 depart_18 depart_19 depart_20 depart_21 depart_22 depart_23
worker month_2 month_3 month_4 month_5 month_6 month_7 month_8 month_9 month_10 month_11 month_12
black hispanic";



*Centering the controls to make the constant comparables;
foreach variable of local controls {;
egen `variable'_a = mean(`variable');
gen `variable'_c = `variable' - `variable'_a;
drop `variable' `variable'_a;
rename `variable'_c `variable';

};


*generate interaction terms for the regressions;

*interacted terms;
forvalues id = 1(1)`msanum' {;
gen m_`id' = 0;
replace m_`id' = 1 if rank_msa == `id';
};

forvalues id = 1(1)`msanum' {;
gen mdist_`id' = l_trpmiles*m_`id';
};




* First, compute supply curves for the United States, for each year;
foreach year in 95 01 09 {;


* censor top and bottom quartile;

su l_trpmiles if year ==`year', d;
scalar per25=r(p25);
scalar per75=r(p75);

drop if (year ==`year' & l_trpmiles>per75);
drop if (year ==`year' & l_trpmiles<per25);


*some variables to receive coefficient values;
gen CbUS_`year' = .;
gen gbUS_`year' = .;

forvalues i = 2(1)18 {;
gen b_hh_income_`i'US_`year'  =. ;
};
forvalues i = 1(1)23 {;
gen b_depart_`i'US_`year'  =. ;
};

forvalues i = 2(1)5 {;
gen b_hh_education_`i'US_`year' =. ;
};
gen b_r_ageUS_`year' =. ; 
gen b_r_sexUS_`year' =. ; 
gen b_tdwkndUS_`year' =. ;
gen b_workerUS_`year' =.  ;
forvalues i = 2(1)12 {;
gen b_month_`i'US_`year'  =. ;
};
gen b_blackUS_`year' =.  ;
gen b_hispanicUS_`year' =.  ;

reg l_p l_trpmiles `controls' if year == `year', cl(msa) robust;
          replace CbUS_`year' = _b[_cons];
          replace gbUS_`year' = _b[l_trpmiles];
		  forvalues i = 2(1)18 {;
          replace b_hh_income_`i'US_`year'  = _b[hh_income_`i'] ;
          };
 		  forvalues i = 1(1)23 {;
          replace b_depart_`i'US_`year'  = _b[depart_`i'] ;
          };
		  forvalues i = 2(1)5 {;
          replace b_hh_education_`i'US_`year'  = _b[hh_education_`i'] ;
          };
		  replace b_r_ageUS_`year' = _b[r_age];
		  replace b_r_sexUS_`year' = _b[r_sex];
		  replace b_tdwkndUS_`year' = _b[tdwknd];
		  replace b_workerUS_`year' = _b[worker];
		  forvalues i = 2(1)12 {;
          replace b_month_`i'US_`year'  = _b[month_`i'] ;
          };
		  replace b_blackUS_`year' = _b[black];
		  replace b_hispanicUS_`year' = _b[hispanic];
};		  

*Now save values of msa-specific coefficient. I run only one regression per year (so coefficient
for controls is same for each msa, but slope and intercept of curve varies at msa-level);


foreach year in 95 01 09 {;


gen Cb_`year' = .;
gen gb_`year' = .;
gen Cb_sd_`year' = .;
gen gb_sd_`year' = .;

forvalues i = 2(1)18 {;
gen b_hh_income_`i'_`year'  =. ;
};
forvalues i = 2(1)5 {;
gen b_hh_education_`i'_`year' =. ;
};
forvalues i = 1(1)23 {;
gen b_depart_`i'_`year'  =. ;
};
gen b_r_age_`year' =. ; 
gen b_r_sex_`year' =. ; 
gen b_tdwknd_`year' =. ;
gen b_worker_`year' =.  ;
forvalues i = 2(1)12 {;
gen b_month_`i'_`year'  =. ;
};
gen b_black_`year' =.  ;
gen b_hispanic_`year' =.  ;

reg l_p m_1-m_`msanum' mdist_1-mdist_`msanum' `controls' if year == `year', noconstant cl(msa) robust;

*predict pl_p;

*gen error = l_p - pl_p;

		  forvalues i = 2(1)18 {;
          replace b_hh_income_`i'_`year'  = _b[hh_income_`i'] ;
          };
 		  forvalues i = 1(1)23 {;
          replace b_depart_`i'_`year'  = _b[depart_`i'] ;
          };
		  forvalues i = 2(1)5 {;
          replace b_hh_education_`i'_`year'  = _b[hh_education_`i'] ;
          };
		  replace b_r_age_`year' = _b[r_age];
		  replace b_r_sex_`year' = _b[r_sex];
		  replace b_tdwknd_`year' = _b[tdwknd];
		  replace b_worker_`year' = _b[worker];
		  forvalues i = 2(1)12 {;
          replace b_month_`i'_`year'  = _b[month_`i'] ;
          };		  
		  replace b_black_`year' = _b[black];
		  replace b_hispanic_`year' = _b[hispanic];
		  
forvalues id = 1(1)`msanum' {;
replace Cb_`year' = _b[m_`id'] if m_`id' == 1;
replace gb_`year' = _b[mdist_`id'] if m_`id' ==1;
replace Cb_sd_`year' = _se[m_`id'] if m_`id' == 1;
replace gb_sd_`year' = _se[mdist_`id'] if m_`id' ==1;



};
};

drop m_1-m_`msanum';
drop mdist_1-mdist_`msanum';

save "$data_source\npts_Cb_`msanum'6", replace;

};


************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 240 {;

use "$data_source\npts_Cb_`msanum'6";

keep if rank_msa <= `msanum';

drop  msa_name pid whytrp90 urb peak l_mph_trip l_trpmiles l_trvl_min y_95 y_01 y_09;

local controls = "hh_income_2-hh_income_18 hh_education_2-hh_education_5 r_age r_sex tdwknd depart_1-depart_23 worker month_2-month_12 black hispanic";

******************** 1) US trips at MSA price*********************************;

gen S1_95 = .;
gen S1_01 = .;
gen S1_09 = .;

gen weight = wtperfin/1000;
	
foreach year in 95 01 09 {;
forvalues id = 1(1)`msanum'{; 

	quietly mean Cb_`year' if rank_msa == `id';
	scalar Cmsa = _b[Cb_`year'];
	quietly mean gb_`year' if rank_msa == `id';
	scalar gmsa = _b[gb_`year'];
	gen t = weight*trpmiles*exp(Cmsa + b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker + b_black_`year'*black + b_hispanic_`year'*hispanic +
	 b_month_2_`year'*month_2 + b_month_3_`year'*month_3 +  b_month_4_`year'*month_4 +
	 b_month_5_`year'*month_5 + b_month_6_`year'*month_6 + b_month_7_`year'*month_7 + b_month_8_`year'*month_8 +
	 b_month_9_`year'*month_9 + b_month_10_`year'*month_10 + b_month_11_`year'*month_11 + b_month_12_`year'*month_12 +
	 b_hh_education_2_`year'*hh_education_2 + b_hh_education_3_`year'*hh_education_3 +
	 b_hh_education_4_`year'*hh_education_4 + b_hh_education_5_`year'*hh_education_5 +
	 b_hh_income_2_`year'*hh_income_2 + b_hh_income_3_`year'*hh_income_3 + b_hh_income_4_`year'*hh_income_4 +
	 b_hh_income_5_`year'*hh_income_5 + b_hh_income_6_`year'*hh_income_6 + b_hh_income_7_`year'*hh_income_7 +
	 b_hh_income_8_`year'*hh_income_8 + b_hh_income_9_`year'*hh_income_9 + b_hh_income_10_`year'*hh_income_10 +
	 b_hh_income_11_`year'*hh_income_11 + b_hh_income_12_`year'*hh_income_12 + b_hh_income_13_`year'*hh_income_13 +
	 b_hh_income_14_`year'*hh_income_14 + b_hh_income_15_`year'*hh_income_15 + b_hh_income_16_`year'*hh_income_16 +
	 b_hh_income_17_`year'*hh_income_17 + b_hh_income_18_`year'*hh_income_18 +
         b_depart_1_`year'*depart_1 + b_depart_2_`year'*depart_2 + b_depart_3_`year'*depart_3 + b_depart_4_`year'*depart_4 + 
	 b_depart_5_`year'*depart_5 + b_depart_6_`year'*depart_6 + b_depart_7_`year'*depart_7 + b_depart_8_`year'*depart_8 +
         b_depart_9_`year'*depart_9 + b_depart_10_`year'*depart_10 + b_depart_11_`year'*depart_11 + 
	 b_depart_12_`year'*depart_12 + b_depart_13_`year'*depart_13 + b_depart_14_`year'*depart_14 +  
	 b_depart_15_`year'*depart_15 + b_depart_16_`year'*depart_16 + b_depart_17_`year'*depart_17 +
	 b_depart_18_`year'*depart_18 + b_depart_19_`year'*depart_19 + b_depart_20_`year'*depart_20 +
	 b_depart_21_`year'*depart_21 + b_depart_22_`year'*depart_22 + b_depart_23_`year'*depart_23 +    
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
	gen t = weight*trpmiles*exp(CbUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + 	          b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + b_hispanicUS_`year'*hispanic +
	 b_month_2US_`year'*month_2 + b_month_3US_`year'*month_3 +  b_month_4US_`year'*month_4 +
	 b_month_5US_`year'*month_5 + b_month_6US_`year'*month_6 + b_month_7US_`year'*month_7 + b_month_8US_`year'*month_8 +
	 b_month_9US_`year'*month_9 + b_month_10US_`year'*month_10 + b_month_11US_`year'*month_11 + 	 	 b_month_12US_`year'*month_12 +
	 b_hh_education_2US_`year'*hh_education_2 + b_hh_education_3US_`year'*hh_education_3 +
	 b_hh_education_4US_`year'*hh_education_4 + b_hh_education_5US_`year'*hh_education_5 +
	 b_hh_income_2US_`year'*hh_income_2 + b_hh_income_3US_`year'*hh_income_3 + b_hh_income_4US_`year'*hh_income_4 +
	 b_hh_income_5US_`year'*hh_income_5 + b_hh_income_6US_`year'*hh_income_6 + b_hh_income_7US_`year'*hh_income_7 +
	 b_hh_income_8US_`year'*hh_income_8 + b_hh_income_9US_`year'*hh_income_9 + b_hh_income_10US_`year'*hh_income_10 +
	 b_hh_income_11US_`year'*hh_income_11 + b_hh_income_12US_`year'*hh_income_12 + b_hh_income_13US_`year'*hh_income_13 +
	 b_hh_income_14US_`year'*hh_income_14 + b_hh_income_15US_`year'*hh_income_15 + b_hh_income_16US_`year'*hh_income_16 +
	 b_hh_income_17US_`year'*hh_income_17 + b_hh_income_18US_`year'*hh_income_18 +
	 b_depart_1US_`year'*depart_1 + b_depart_2US_`year'*depart_2 + b_depart_3US_`year'*depart_3 + 	 	 	 b_depart_4US_`year'*depart_4 + b_depart_5US_`year'*depart_5 + b_depart_6US_`year'*depart_6 + 		 	 b_depart_7US_`year'*depart_7 + b_depart_8US_`year'*depart_8 + b_depart_9US_`year'*depart_9 + 			 	 b_depart_10US_`year'*depart_10 + b_depart_11US_`year'*depart_11 + 
	 b_depart_12US_`year'*depart_12 + b_depart_13US_`year'*depart_13 + b_depart_14US_`year'*depart_14 +  
	 b_depart_15US_`year'*depart_15 + b_depart_16US_`year'*depart_16 + b_depart_17US_`year'*depart_17 +
	 b_depart_18US_`year'*depart_18 + b_depart_19US_`year'*depart_19 + b_depart_20US_`year'*depart_20 +
	 b_depart_21US_`year'*depart_21 + b_depart_22US_`year'*depart_22 + b_depart_23US_`year'*depart_23 +
	gbUS_`year'*ln(trpmiles));
	quietly total t if year == `year';
	replace S2_`year' = _b[t];
    drop t;

};

		
************** 3) MSA trips at US prices **********************;

gen S3_95 = .;
gen S3_01 = .;
gen S3_09 = .;

foreach year in 95 01 09 {;
	
	gen t = weight*trpmiles*exp(CbUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + b_hispanicUS_`year'*hispanic +
	 b_month_2US_`year'*month_2 + b_month_3US_`year'*month_3 +  b_month_4US_`year'*month_4 +
	 b_month_5US_`year'*month_5 + b_month_6US_`year'*month_6 + b_month_7US_`year'*month_7 + b_month_8US_`year'*month_8 +
	 b_month_9US_`year'*month_9 + b_month_10US_`year'*month_10 + b_month_11US_`year'*month_11 + 	 	 b_month_12US_`year'*month_12 +
	 b_hh_education_2US_`year'*hh_education_2 + b_hh_education_3US_`year'*hh_education_3 +
	 b_hh_education_4US_`year'*hh_education_4 + b_hh_education_5US_`year'*hh_education_5 +
	 b_hh_income_2US_`year'*hh_income_2 + b_hh_income_3US_`year'*hh_income_3 + b_hh_income_4US_`year'*hh_income_4 +
	 b_hh_income_5US_`year'*hh_income_5 + b_hh_income_6US_`year'*hh_income_6 + b_hh_income_7US_`year'*hh_income_7 +
	 b_hh_income_8US_`year'*hh_income_8 + b_hh_income_9US_`year'*hh_income_9 + b_hh_income_10US_`year'*hh_income_10 +
	 b_hh_income_11US_`year'*hh_income_11 + b_hh_income_12US_`year'*hh_income_12 + b_hh_income_13US_`year'*hh_income_13 +
	 b_hh_income_14US_`year'*hh_income_14 + b_hh_income_15US_`year'*hh_income_15 + b_hh_income_16US_`year'*hh_income_16 +
	 b_hh_income_17US_`year'*hh_income_17 + b_hh_income_18US_`year'*hh_income_18 +
	 b_depart_1US_`year'*depart_1 + b_depart_2US_`year'*depart_2 + b_depart_3US_`year'*depart_3 + 	 	 	          b_depart_4US_`year'*depart_4 + b_depart_5US_`year'*depart_5 + b_depart_6US_`year'*depart_6 + 		 	          b_depart_7US_`year'*depart_7 + b_depart_8US_`year'*depart_8 + b_depart_9US_`year'*depart_9 + 			 	         b_depart_10US_`year'*depart_10 + b_depart_11US_`year'*depart_11 + 
	 b_depart_12US_`year'*depart_12 + b_depart_13US_`year'*depart_13 + b_depart_14US_`year'*depart_14 +  
	 b_depart_15US_`year'*depart_15 + b_depart_16US_`year'*depart_16 + b_depart_17US_`year'*depart_17 +
	 b_depart_18US_`year'*depart_18 + b_depart_19US_`year'*depart_19 + b_depart_20US_`year'*depart_20 +
	 b_depart_21US_`year'*depart_21 + b_depart_22US_`year'*depart_22 + b_depart_23US_`year'*depart_23 +	 
	gbUS_`year'*ln(trpmiles));
	
forvalues id = 1(1)`msanum' {; 
	quietly total t if (year == `year' & rank_msa == `id');
	scalar St = _b[t];
	replace S3_`year' = St if rank_msa == `id';
};
	drop t;
};


************************ MSA trips at msa price**********************;

gen S4_95 = .;
gen S4_01 = .;
gen S4_09 = .;


foreach year in 95 01 09 {;
	
	gen t = weight*trpmiles*exp(Cb_`year'+ b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker +  b_black_`year'*black + b_hispanic_`year'*hispanic +
	 b_month_2_`year'*month_2 + b_month_3_`year'*month_3 +  b_month_4_`year'*month_4 +
	 b_month_5_`year'*month_5 + b_month_6_`year'*month_6 + b_month_7_`year'*month_7 + b_month_8_`year'*month_8 +
	 b_month_9_`year'*month_9 + b_month_10_`year'*month_10 + b_month_11_`year'*month_11 + b_month_12_`year'*month_12 +
	 b_hh_education_2_`year'*hh_education_2 + b_hh_education_3_`year'*hh_education_3 +
	 b_hh_education_4_`year'*hh_education_4 + b_hh_education_5_`year'*hh_education_5 +
	 b_hh_income_2_`year'*hh_income_2 + b_hh_income_3_`year'*hh_income_3 + b_hh_income_4_`year'*hh_income_4 +
	 b_hh_income_5_`year'*hh_income_5 + b_hh_income_6_`year'*hh_income_6 + b_hh_income_7_`year'*hh_income_7 +
	 b_hh_income_8_`year'*hh_income_8 + b_hh_income_9_`year'*hh_income_9 + b_hh_income_10_`year'*hh_income_10 +
	 b_hh_income_11_`year'*hh_income_11 + b_hh_income_12_`year'*hh_income_12 + b_hh_income_13_`year'*hh_income_13 +
	 b_hh_income_14_`year'*hh_income_14 + b_hh_income_15_`year'*hh_income_15 + b_hh_income_16_`year'*hh_income_16 +
	 b_hh_income_17_`year'*hh_income_17 + b_hh_income_18_`year'*hh_income_18 +
	 b_depart_1_`year'*depart_1 + b_depart_2_`year'*depart_2 + b_depart_3_`year'*depart_3 + b_depart_4_`year'*depart_4 + 
	 b_depart_5_`year'*depart_5 + b_depart_6_`year'*depart_6 + b_depart_7_`year'*depart_7 + b_depart_8_`year'*depart_8 +
         b_depart_9_`year'*depart_9 + b_depart_10_`year'*depart_10 + b_depart_11_`year'*depart_11 + 
	 b_depart_12_`year'*depart_12 + b_depart_13_`year'*depart_13 + b_depart_14_`year'*depart_14 +  
	 b_depart_15_`year'*depart_15 + b_depart_16_`year'*depart_16 + b_depart_17_`year'*depart_17 +
	 b_depart_18_`year'*depart_18 + b_depart_19_`year'*depart_19 + b_depart_20_`year'*depart_20 +
	 b_depart_21_`year'*depart_21 + b_depart_22_`year'*depart_22 + b_depart_23_`year'*depart_23 + 
	gb_`year'*ln(trpmiles));
	
forvalues id = 1(1)`msanum' {; 
	total t if (year ==`year' & rank_msa == `id');
	quietly scalar St = _b[t];
	replace S4_`year' = St if rank_msa == `id';
};
drop t;
};


* Generate Laspeyres, Paasche and Fisher price indexes, and their logs;

foreach year in 95 01 09 {;

gen Lb_`year' = S1_`year'/S2_`year';
gen Pb_`year' = S4_`year'/S3_`year';
gen Fb_`year' = sqrt(Lb_`year'*Pb_`year');

gen l_Lb_`year' = ln(Lb_`year');
gen l_Pb_`year' = ln(Pb_`year');
gen l_Fb_`year' = ln(Fb_`year');


};
collapse  (mean)  Lb_95 Lb_01 Lb_09 l_Lb_95 l_Lb_01 l_Lb_09
                  CbUS_95 CbUS_01 CbUS_09 gbUS_95 gbUS_01 gbUS_09 
				  Cb_95 Cb_01 Cb_09 gb_95 gb_01 gb_09
				  Cb_sd_95 Cb_sd_01 Cb_sd_09 gb_sd_95 gb_sd_01 gb_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_b_`msanum'6", replace;

};


};



*********************************************************************************************;
************** Regression 2g                              ****************--*****************;
*********************************************************************************************:
*******    OLS with controls censoring non peak hours             ************;


if 1==0 {;


************** Step 1: Supply curve estimation using OLS with controls *******************; 

* Decide how many msas to keep;
foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";
 
keep if rank_msa <= `msanum';


* get rid of all non peak trips (slightly different from the peak variable);
drop if start1<7.00;
drop if (start1>9.30 & start1<15);
drop if start1>19;


local controls "hh_income_2 hh_income_3 hh_income_4 hh_income_5 hh_income_6 hh_income_7 
hh_income_8 hh_income_9 hh_income_10 hh_income_11 hh_income_12 hh_income_13 hh_income_14 
hh_income_15 hh_income_16 hh_income_17 hh_income_18 
hh_education_2 hh_education_3 hh_education_4 hh_education_5 r_age r_sex tdwknd 
depart_1 depart_2 depart_3 depart_4 depart_5 depart_6 depart_7 depart_8 depart_9 depart_10 depart_11 depart_12 depart_13 depart_14 depart_15 depart_16 depart_17 depart_18 depart_19 depart_20 depart_21 depart_22 depart_23
worker month_2 month_3 month_4 month_5 month_6 month_7 month_8 month_9 month_10 month_11 month_12
black hispanic";



*Centering the controls to make the constant comparables;
foreach variable of local controls {;
egen `variable'_a = mean(`variable');
gen `variable'_c = `variable' - `variable'_a;
drop `variable' `variable'_a;
rename `variable'_c `variable';

};


*generate interaction terms for the regressions;

*interacted terms;
forvalues id = 1(1)`msanum' {;
gen m_`id' = 0;
replace m_`id' = 1 if rank_msa == `id';
};

forvalues id = 1(1)`msanum' {;
gen mdist_`id' = l_trpmiles*m_`id';
};




* First, compute supply curves for the United States, for each year;
foreach year in 95 01 09 {;

*some variables to receive coefficient values;
gen CbUS_`year' = .;
gen gbUS_`year' = .;

forvalues i = 2(1)18 {;
gen b_hh_income_`i'US_`year'  =. ;
};
forvalues i = 1(1)23 {;
gen b_depart_`i'US_`year'  =. ;
};

forvalues i = 2(1)5 {;
gen b_hh_education_`i'US_`year' =. ;
};
gen b_r_ageUS_`year' =. ; 
gen b_r_sexUS_`year' =. ; 
gen b_tdwkndUS_`year' =. ;
gen b_workerUS_`year' =.  ;
forvalues i = 2(1)12 {;
gen b_month_`i'US_`year'  =. ;
};
gen b_blackUS_`year' =.  ;
gen b_hispanicUS_`year' =.  ;

reg l_p l_trpmiles `controls' if year == `year', cl(msa) robust;
          replace CbUS_`year' = _b[_cons];
          replace gbUS_`year' = _b[l_trpmiles];
		  forvalues i = 2(1)18 {;
          replace b_hh_income_`i'US_`year'  = _b[hh_income_`i'] ;
          };
 		  forvalues i = 1(1)23 {;
          replace b_depart_`i'US_`year'  = _b[depart_`i'] ;
          };
		  forvalues i = 2(1)5 {;
          replace b_hh_education_`i'US_`year'  = _b[hh_education_`i'] ;
          };
		  replace b_r_ageUS_`year' = _b[r_age];
		  replace b_r_sexUS_`year' = _b[r_sex];
		  replace b_tdwkndUS_`year' = _b[tdwknd];
		  replace b_workerUS_`year' = _b[worker];
		  forvalues i = 2(1)12 {;
          replace b_month_`i'US_`year'  = _b[month_`i'] ;
          };
		  replace b_blackUS_`year' = _b[black];
		  replace b_hispanicUS_`year' = _b[hispanic];
};		  

*Now save values of msa-specific coefficient. I run only one regression per year (so coefficient
for controls is same for each msa, but slope and intercept of curve varies at msa-level);


foreach year in 95 01 09 {;


gen Cb_`year' = .;
gen gb_`year' = .;
gen Cb_sd_`year' = .;
gen gb_sd_`year' = .;

forvalues i = 2(1)18 {;
gen b_hh_income_`i'_`year'  =. ;
};
forvalues i = 2(1)5 {;
gen b_hh_education_`i'_`year' =. ;
};
forvalues i = 1(1)23 {;
gen b_depart_`i'_`year'  =. ;
};
gen b_r_age_`year' =. ; 
gen b_r_sex_`year' =. ; 
gen b_tdwknd_`year' =. ;
gen b_worker_`year' =.  ;
forvalues i = 2(1)12 {;
gen b_month_`i'_`year'  =. ;
};
gen b_black_`year' =.  ;
gen b_hispanic_`year' =.  ;

reg l_p m_1-m_`msanum' mdist_1-mdist_`msanum' `controls' if year == `year', noconstant cl(msa) robust;

*predict pl_p;

*gen error = l_p - pl_p;

		  forvalues i = 2(1)18 {;
          replace b_hh_income_`i'_`year'  = _b[hh_income_`i'] ;
          };
 		  forvalues i = 1(1)23 {;
          replace b_depart_`i'_`year'  = _b[depart_`i'] ;
          };
		  forvalues i = 2(1)5 {;
          replace b_hh_education_`i'_`year'  = _b[hh_education_`i'] ;
          };
		  replace b_r_age_`year' = _b[r_age];
		  replace b_r_sex_`year' = _b[r_sex];
		  replace b_tdwknd_`year' = _b[tdwknd];
		  replace b_worker_`year' = _b[worker];
		  forvalues i = 2(1)12 {;
          replace b_month_`i'_`year'  = _b[month_`i'] ;
          };		  
		  replace b_black_`year' = _b[black];
		  replace b_hispanic_`year' = _b[hispanic];
		  
forvalues id = 1(1)`msanum' {;
replace Cb_`year' = _b[m_`id'] if m_`id' == 1;
replace gb_`year' = _b[mdist_`id'] if m_`id' ==1;
replace Cb_sd_`year' = _se[m_`id'] if m_`id' == 1;
replace gb_sd_`year' = _se[mdist_`id'] if m_`id' ==1;



};
};

drop m_1-m_`msanum';
drop mdist_1-mdist_`msanum';

save "$data_source\npts_Cb_`msanum'7", replace;

};


************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 240 {;

use "$data_source\npts_Cb_`msanum'7";

keep if rank_msa <= `msanum';

drop  msa_name pid whytrp90 urb peak l_mph_trip l_trpmiles l_trvl_min y_95 y_01 y_09;

local controls = "hh_income_2-hh_income_18 hh_education_2-hh_education_5 r_age r_sex tdwknd depart_1-depart_23 worker month_2-month_12 black hispanic";

******************** 1) US trips at MSA price*********************************;

gen S1_95 = .;
gen S1_01 = .;
gen S1_09 = .;

gen weight = wtperfin/1000;
	
foreach year in 95 01 09 {;
forvalues id = 1(1)`msanum'{; 

	quietly mean Cb_`year' if rank_msa == `id';
	scalar Cmsa = _b[Cb_`year'];
	quietly mean gb_`year' if rank_msa == `id';
	scalar gmsa = _b[gb_`year'];
	gen t = weight*trpmiles*exp(Cmsa + b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker + b_black_`year'*black + b_hispanic_`year'*hispanic +
	 b_month_2_`year'*month_2 + b_month_3_`year'*month_3 +  b_month_4_`year'*month_4 +
	 b_month_5_`year'*month_5 + b_month_6_`year'*month_6 + b_month_7_`year'*month_7 + b_month_8_`year'*month_8 +
	 b_month_9_`year'*month_9 + b_month_10_`year'*month_10 + b_month_11_`year'*month_11 + b_month_12_`year'*month_12 +
	 b_hh_education_2_`year'*hh_education_2 + b_hh_education_3_`year'*hh_education_3 +
	 b_hh_education_4_`year'*hh_education_4 + b_hh_education_5_`year'*hh_education_5 +
	 b_hh_income_2_`year'*hh_income_2 + b_hh_income_3_`year'*hh_income_3 + b_hh_income_4_`year'*hh_income_4 +
	 b_hh_income_5_`year'*hh_income_5 + b_hh_income_6_`year'*hh_income_6 + b_hh_income_7_`year'*hh_income_7 +
	 b_hh_income_8_`year'*hh_income_8 + b_hh_income_9_`year'*hh_income_9 + b_hh_income_10_`year'*hh_income_10 +
	 b_hh_income_11_`year'*hh_income_11 + b_hh_income_12_`year'*hh_income_12 + b_hh_income_13_`year'*hh_income_13 +
	 b_hh_income_14_`year'*hh_income_14 + b_hh_income_15_`year'*hh_income_15 + b_hh_income_16_`year'*hh_income_16 +
	 b_hh_income_17_`year'*hh_income_17 + b_hh_income_18_`year'*hh_income_18 +
         b_depart_1_`year'*depart_1 + b_depart_2_`year'*depart_2 + b_depart_3_`year'*depart_3 + b_depart_4_`year'*depart_4 + 
	 b_depart_5_`year'*depart_5 + b_depart_6_`year'*depart_6 + b_depart_7_`year'*depart_7 + b_depart_8_`year'*depart_8 +
         b_depart_9_`year'*depart_9 + b_depart_10_`year'*depart_10 + b_depart_11_`year'*depart_11 + 
	 b_depart_12_`year'*depart_12 + b_depart_13_`year'*depart_13 + b_depart_14_`year'*depart_14 +  
	 b_depart_15_`year'*depart_15 + b_depart_16_`year'*depart_16 + b_depart_17_`year'*depart_17 +
	 b_depart_18_`year'*depart_18 + b_depart_19_`year'*depart_19 + b_depart_20_`year'*depart_20 +
	 b_depart_21_`year'*depart_21 + b_depart_22_`year'*depart_22 + b_depart_23_`year'*depart_23 +    
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
	gen t = weight*trpmiles*exp(CbUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + 	          b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + b_hispanicUS_`year'*hispanic +
	 b_month_2US_`year'*month_2 + b_month_3US_`year'*month_3 +  b_month_4US_`year'*month_4 +
	 b_month_5US_`year'*month_5 + b_month_6US_`year'*month_6 + b_month_7US_`year'*month_7 + b_month_8US_`year'*month_8 +
	 b_month_9US_`year'*month_9 + b_month_10US_`year'*month_10 + b_month_11US_`year'*month_11 + 	 	 b_month_12US_`year'*month_12 +
	 b_hh_education_2US_`year'*hh_education_2 + b_hh_education_3US_`year'*hh_education_3 +
	 b_hh_education_4US_`year'*hh_education_4 + b_hh_education_5US_`year'*hh_education_5 +
	 b_hh_income_2US_`year'*hh_income_2 + b_hh_income_3US_`year'*hh_income_3 + b_hh_income_4US_`year'*hh_income_4 +
	 b_hh_income_5US_`year'*hh_income_5 + b_hh_income_6US_`year'*hh_income_6 + b_hh_income_7US_`year'*hh_income_7 +
	 b_hh_income_8US_`year'*hh_income_8 + b_hh_income_9US_`year'*hh_income_9 + b_hh_income_10US_`year'*hh_income_10 +
	 b_hh_income_11US_`year'*hh_income_11 + b_hh_income_12US_`year'*hh_income_12 + b_hh_income_13US_`year'*hh_income_13 +
	 b_hh_income_14US_`year'*hh_income_14 + b_hh_income_15US_`year'*hh_income_15 + b_hh_income_16US_`year'*hh_income_16 +
	 b_hh_income_17US_`year'*hh_income_17 + b_hh_income_18US_`year'*hh_income_18 +
	 b_depart_1US_`year'*depart_1 + b_depart_2US_`year'*depart_2 + b_depart_3US_`year'*depart_3 + 	 	 	 b_depart_4US_`year'*depart_4 + b_depart_5US_`year'*depart_5 + b_depart_6US_`year'*depart_6 + 		 	 b_depart_7US_`year'*depart_7 + b_depart_8US_`year'*depart_8 + b_depart_9US_`year'*depart_9 + 			 	 b_depart_10US_`year'*depart_10 + b_depart_11US_`year'*depart_11 + 
	 b_depart_12US_`year'*depart_12 + b_depart_13US_`year'*depart_13 + b_depart_14US_`year'*depart_14 +  
	 b_depart_15US_`year'*depart_15 + b_depart_16US_`year'*depart_16 + b_depart_17US_`year'*depart_17 +
	 b_depart_18US_`year'*depart_18 + b_depart_19US_`year'*depart_19 + b_depart_20US_`year'*depart_20 +
	 b_depart_21US_`year'*depart_21 + b_depart_22US_`year'*depart_22 + b_depart_23US_`year'*depart_23 +
	gbUS_`year'*ln(trpmiles));
	quietly total t if year == `year';
	replace S2_`year' = _b[t];
    drop t;

};

		
************** 3) MSA trips at US prices **********************;

gen S3_95 = .;
gen S3_01 = .;
gen S3_09 = .;

foreach year in 95 01 09 {;
	
	gen t = weight*trpmiles*exp(CbUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + b_hispanicUS_`year'*hispanic +
	 b_month_2US_`year'*month_2 + b_month_3US_`year'*month_3 +  b_month_4US_`year'*month_4 +
	 b_month_5US_`year'*month_5 + b_month_6US_`year'*month_6 + b_month_7US_`year'*month_7 + b_month_8US_`year'*month_8 +
	 b_month_9US_`year'*month_9 + b_month_10US_`year'*month_10 + b_month_11US_`year'*month_11 + 	 	 b_month_12US_`year'*month_12 +
	 b_hh_education_2US_`year'*hh_education_2 + b_hh_education_3US_`year'*hh_education_3 +
	 b_hh_education_4US_`year'*hh_education_4 + b_hh_education_5US_`year'*hh_education_5 +
	 b_hh_income_2US_`year'*hh_income_2 + b_hh_income_3US_`year'*hh_income_3 + b_hh_income_4US_`year'*hh_income_4 +
	 b_hh_income_5US_`year'*hh_income_5 + b_hh_income_6US_`year'*hh_income_6 + b_hh_income_7US_`year'*hh_income_7 +
	 b_hh_income_8US_`year'*hh_income_8 + b_hh_income_9US_`year'*hh_income_9 + b_hh_income_10US_`year'*hh_income_10 +
	 b_hh_income_11US_`year'*hh_income_11 + b_hh_income_12US_`year'*hh_income_12 + b_hh_income_13US_`year'*hh_income_13 +
	 b_hh_income_14US_`year'*hh_income_14 + b_hh_income_15US_`year'*hh_income_15 + b_hh_income_16US_`year'*hh_income_16 +
	 b_hh_income_17US_`year'*hh_income_17 + b_hh_income_18US_`year'*hh_income_18 +
	 b_depart_1US_`year'*depart_1 + b_depart_2US_`year'*depart_2 + b_depart_3US_`year'*depart_3 + 	 	 	          b_depart_4US_`year'*depart_4 + b_depart_5US_`year'*depart_5 + b_depart_6US_`year'*depart_6 + 		 	          b_depart_7US_`year'*depart_7 + b_depart_8US_`year'*depart_8 + b_depart_9US_`year'*depart_9 + 			 	         b_depart_10US_`year'*depart_10 + b_depart_11US_`year'*depart_11 + 
	 b_depart_12US_`year'*depart_12 + b_depart_13US_`year'*depart_13 + b_depart_14US_`year'*depart_14 +  
	 b_depart_15US_`year'*depart_15 + b_depart_16US_`year'*depart_16 + b_depart_17US_`year'*depart_17 +
	 b_depart_18US_`year'*depart_18 + b_depart_19US_`year'*depart_19 + b_depart_20US_`year'*depart_20 +
	 b_depart_21US_`year'*depart_21 + b_depart_22US_`year'*depart_22 + b_depart_23US_`year'*depart_23 +	 
	gbUS_`year'*ln(trpmiles));
	
forvalues id = 1(1)`msanum' {; 
	quietly total t if (year == `year' & rank_msa == `id');
	scalar St = _b[t];
	replace S3_`year' = St if rank_msa == `id';
};
	drop t;
};


************************ MSA trips at msa price**********************;

gen S4_95 = .;
gen S4_01 = .;
gen S4_09 = .;


foreach year in 95 01 09 {;
	
	gen t = weight*trpmiles*exp(Cb_`year'+ b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker +  b_black_`year'*black + b_hispanic_`year'*hispanic +
	 b_month_2_`year'*month_2 + b_month_3_`year'*month_3 +  b_month_4_`year'*month_4 +
	 b_month_5_`year'*month_5 + b_month_6_`year'*month_6 + b_month_7_`year'*month_7 + b_month_8_`year'*month_8 +
	 b_month_9_`year'*month_9 + b_month_10_`year'*month_10 + b_month_11_`year'*month_11 + b_month_12_`year'*month_12 +
	 b_hh_education_2_`year'*hh_education_2 + b_hh_education_3_`year'*hh_education_3 +
	 b_hh_education_4_`year'*hh_education_4 + b_hh_education_5_`year'*hh_education_5 +
	 b_hh_income_2_`year'*hh_income_2 + b_hh_income_3_`year'*hh_income_3 + b_hh_income_4_`year'*hh_income_4 +
	 b_hh_income_5_`year'*hh_income_5 + b_hh_income_6_`year'*hh_income_6 + b_hh_income_7_`year'*hh_income_7 +
	 b_hh_income_8_`year'*hh_income_8 + b_hh_income_9_`year'*hh_income_9 + b_hh_income_10_`year'*hh_income_10 +
	 b_hh_income_11_`year'*hh_income_11 + b_hh_income_12_`year'*hh_income_12 + b_hh_income_13_`year'*hh_income_13 +
	 b_hh_income_14_`year'*hh_income_14 + b_hh_income_15_`year'*hh_income_15 + b_hh_income_16_`year'*hh_income_16 +
	 b_hh_income_17_`year'*hh_income_17 + b_hh_income_18_`year'*hh_income_18 +
	 b_depart_1_`year'*depart_1 + b_depart_2_`year'*depart_2 + b_depart_3_`year'*depart_3 + b_depart_4_`year'*depart_4 + 
	 b_depart_5_`year'*depart_5 + b_depart_6_`year'*depart_6 + b_depart_7_`year'*depart_7 + b_depart_8_`year'*depart_8 +
         b_depart_9_`year'*depart_9 + b_depart_10_`year'*depart_10 + b_depart_11_`year'*depart_11 + 
	 b_depart_12_`year'*depart_12 + b_depart_13_`year'*depart_13 + b_depart_14_`year'*depart_14 +  
	 b_depart_15_`year'*depart_15 + b_depart_16_`year'*depart_16 + b_depart_17_`year'*depart_17 +
	 b_depart_18_`year'*depart_18 + b_depart_19_`year'*depart_19 + b_depart_20_`year'*depart_20 +
	 b_depart_21_`year'*depart_21 + b_depart_22_`year'*depart_22 + b_depart_23_`year'*depart_23 + 
	gb_`year'*ln(trpmiles));
	
forvalues id = 1(1)`msanum' {; 
	total t if (year ==`year' & rank_msa == `id');
	quietly scalar St = _b[t];
	replace S4_`year' = St if rank_msa == `id';
};
drop t;
};


* Generate Laspeyres, Paasche and Fisher price indexes, and their logs;

foreach year in 95 01 09 {;

gen Lb_`year' = S1_`year'/S2_`year';
gen Pb_`year' = S4_`year'/S3_`year';
gen Fb_`year' = sqrt(Lb_`year'*Pb_`year');

gen l_Lb_`year' = ln(Lb_`year');
gen l_Pb_`year' = ln(Pb_`year');
gen l_Fb_`year' = ln(Fb_`year');


};
collapse  (mean)  Lb_95 Lb_01 Lb_09 l_Lb_95 l_Lb_01 l_Lb_09
                  CbUS_95 CbUS_01 CbUS_09 gbUS_95 gbUS_01 gbUS_09 
				  Cb_95 Cb_01 Cb_09 gb_95 gb_01 gb_09
				  Cb_sd_95 Cb_sd_01 Cb_sd_09 gb_sd_95 gb_sd_01 gb_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_b_`msanum'7", replace;

};


};








*********************************************************************************************;
************** Regression 2h                              ****************--*****************;
*********************************************************************************************:
*******    OLS with controls keeping only commutes and work related trips             ************;


if 1==0 {;


************** Step 1: Supply curve estimation using OLS with controls *******************; 

* Decide how many msas to keep;
foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";
 
keep if rank_msa <= `msanum';


* keep only work trips and commutes;
drop if whytrp90>2;


local controls "hh_income_2 hh_income_3 hh_income_4 hh_income_5 hh_income_6 hh_income_7 
hh_income_8 hh_income_9 hh_income_10 hh_income_11 hh_income_12 hh_income_13 hh_income_14 
hh_income_15 hh_income_16 hh_income_17 hh_income_18 
hh_education_2 hh_education_3 hh_education_4 hh_education_5 r_age r_sex tdwknd 
depart_1 depart_2 depart_3 depart_4 depart_5 depart_6 depart_7 depart_8 depart_9 depart_10 depart_11 depart_12 depart_13 depart_14 depart_15 depart_16 depart_17 depart_18 depart_19 depart_20 depart_21 depart_22 depart_23
worker month_2 month_3 month_4 month_5 month_6 month_7 month_8 month_9 month_10 month_11 month_12
black hispanic";



*Centering the controls to make the constant comparables;
foreach variable of local controls {;
egen `variable'_a = mean(`variable');
gen `variable'_c = `variable' - `variable'_a;
drop `variable' `variable'_a;
rename `variable'_c `variable';

};


*generate interaction terms for the regressions;

*interacted terms;
forvalues id = 1(1)`msanum' {;
gen m_`id' = 0;
replace m_`id' = 1 if rank_msa == `id';
};

forvalues id = 1(1)`msanum' {;
gen mdist_`id' = l_trpmiles*m_`id';
};




* First, compute supply curves for the United States, for each year;
foreach year in 95 01 09 {;

*some variables to receive coefficient values;
gen CbUS_`year' = .;
gen gbUS_`year' = .;

forvalues i = 2(1)18 {;
gen b_hh_income_`i'US_`year'  =. ;
};
forvalues i = 1(1)23 {;
gen b_depart_`i'US_`year'  =. ;
};

forvalues i = 2(1)5 {;
gen b_hh_education_`i'US_`year' =. ;
};
gen b_r_ageUS_`year' =. ; 
gen b_r_sexUS_`year' =. ; 
gen b_tdwkndUS_`year' =. ;
gen b_workerUS_`year' =.  ;
forvalues i = 2(1)12 {;
gen b_month_`i'US_`year'  =. ;
};
gen b_blackUS_`year' =.  ;
gen b_hispanicUS_`year' =.  ;

reg l_p l_trpmiles `controls' if year == `year', cl(msa) robust;
          replace CbUS_`year' = _b[_cons];
          replace gbUS_`year' = _b[l_trpmiles];
		  forvalues i = 2(1)18 {;
          replace b_hh_income_`i'US_`year'  = _b[hh_income_`i'] ;
          };
 		  forvalues i = 1(1)23 {;
          replace b_depart_`i'US_`year'  = _b[depart_`i'] ;
          };
		  forvalues i = 2(1)5 {;
          replace b_hh_education_`i'US_`year'  = _b[hh_education_`i'] ;
          };
		  replace b_r_ageUS_`year' = _b[r_age];
		  replace b_r_sexUS_`year' = _b[r_sex];
		  replace b_tdwkndUS_`year' = _b[tdwknd];
		  replace b_workerUS_`year' = _b[worker];
		  forvalues i = 2(1)12 {;
          replace b_month_`i'US_`year'  = _b[month_`i'] ;
          };
		  replace b_blackUS_`year' = _b[black];
		  replace b_hispanicUS_`year' = _b[hispanic];
};		  

*Now save values of msa-specific coefficient. I run only one regression per year (so coefficient
for controls is same for each msa, but slope and intercept of curve varies at msa-level);


foreach year in 95 01 09 {;


gen Cb_`year' = .;
gen gb_`year' = .;
gen Cb_sd_`year' = .;
gen gb_sd_`year' = .;

forvalues i = 2(1)18 {;
gen b_hh_income_`i'_`year'  =. ;
};
forvalues i = 2(1)5 {;
gen b_hh_education_`i'_`year' =. ;
};
forvalues i = 1(1)23 {;
gen b_depart_`i'_`year'  =. ;
};
gen b_r_age_`year' =. ; 
gen b_r_sex_`year' =. ; 
gen b_tdwknd_`year' =. ;
gen b_worker_`year' =.  ;
forvalues i = 2(1)12 {;
gen b_month_`i'_`year'  =. ;
};
gen b_black_`year' =.  ;
gen b_hispanic_`year' =.  ;

reg l_p m_1-m_`msanum' mdist_1-mdist_`msanum' `controls' if year == `year', noconstant cl(msa) robust;

*predict pl_p;

*gen error = l_p - pl_p;

		  forvalues i = 2(1)18 {;
          replace b_hh_income_`i'_`year'  = _b[hh_income_`i'] ;
          };
 		  forvalues i = 1(1)23 {;
          replace b_depart_`i'_`year'  = _b[depart_`i'] ;
          };
		  forvalues i = 2(1)5 {;
          replace b_hh_education_`i'_`year'  = _b[hh_education_`i'] ;
          };
		  replace b_r_age_`year' = _b[r_age];
		  replace b_r_sex_`year' = _b[r_sex];
		  replace b_tdwknd_`year' = _b[tdwknd];
		  replace b_worker_`year' = _b[worker];
		  forvalues i = 2(1)12 {;
          replace b_month_`i'_`year'  = _b[month_`i'] ;
          };		  
		  replace b_black_`year' = _b[black];
		  replace b_hispanic_`year' = _b[hispanic];
		  
forvalues id = 1(1)`msanum' {;
replace Cb_`year' = _b[m_`id'] if m_`id' == 1;
replace gb_`year' = _b[mdist_`id'] if m_`id' ==1;
replace Cb_sd_`year' = _se[m_`id'] if m_`id' == 1;
replace gb_sd_`year' = _se[mdist_`id'] if m_`id' ==1;



};
};

drop m_1-m_`msanum';
drop mdist_1-mdist_`msanum';

save "$data_source\npts_Cb_`msanum'8", replace;

};


************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 240 {;

use "$data_source\npts_Cb_`msanum'8";

keep if rank_msa <= `msanum';

drop  msa_name pid whytrp90 urb peak l_mph_trip l_trpmiles l_trvl_min y_95 y_01 y_09;

local controls = "hh_income_2-hh_income_18 hh_education_2-hh_education_5 r_age r_sex tdwknd depart_1-depart_23 worker month_2-month_12 black hispanic";

******************** 1) US trips at MSA price*********************************;

gen S1_95 = .;
gen S1_01 = .;
gen S1_09 = .;

gen weight = wtperfin/1000;
	
foreach year in 95 01 09 {;
forvalues id = 1(1)`msanum'{; 

	quietly mean Cb_`year' if rank_msa == `id';
	scalar Cmsa = _b[Cb_`year'];
	quietly mean gb_`year' if rank_msa == `id';
	scalar gmsa = _b[gb_`year'];
	gen t = weight*trpmiles*exp(Cmsa + b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker + b_black_`year'*black + b_hispanic_`year'*hispanic +
	 b_month_2_`year'*month_2 + b_month_3_`year'*month_3 +  b_month_4_`year'*month_4 +
	 b_month_5_`year'*month_5 + b_month_6_`year'*month_6 + b_month_7_`year'*month_7 + b_month_8_`year'*month_8 +
	 b_month_9_`year'*month_9 + b_month_10_`year'*month_10 + b_month_11_`year'*month_11 + b_month_12_`year'*month_12 +
	 b_hh_education_2_`year'*hh_education_2 + b_hh_education_3_`year'*hh_education_3 +
	 b_hh_education_4_`year'*hh_education_4 + b_hh_education_5_`year'*hh_education_5 +
	 b_hh_income_2_`year'*hh_income_2 + b_hh_income_3_`year'*hh_income_3 + b_hh_income_4_`year'*hh_income_4 +
	 b_hh_income_5_`year'*hh_income_5 + b_hh_income_6_`year'*hh_income_6 + b_hh_income_7_`year'*hh_income_7 +
	 b_hh_income_8_`year'*hh_income_8 + b_hh_income_9_`year'*hh_income_9 + b_hh_income_10_`year'*hh_income_10 +
	 b_hh_income_11_`year'*hh_income_11 + b_hh_income_12_`year'*hh_income_12 + b_hh_income_13_`year'*hh_income_13 +
	 b_hh_income_14_`year'*hh_income_14 + b_hh_income_15_`year'*hh_income_15 + b_hh_income_16_`year'*hh_income_16 +
	 b_hh_income_17_`year'*hh_income_17 + b_hh_income_18_`year'*hh_income_18 +
         b_depart_1_`year'*depart_1 + b_depart_2_`year'*depart_2 + b_depart_3_`year'*depart_3 + b_depart_4_`year'*depart_4 + 
	 b_depart_5_`year'*depart_5 + b_depart_6_`year'*depart_6 + b_depart_7_`year'*depart_7 + b_depart_8_`year'*depart_8 +
         b_depart_9_`year'*depart_9 + b_depart_10_`year'*depart_10 + b_depart_11_`year'*depart_11 + 
	 b_depart_12_`year'*depart_12 + b_depart_13_`year'*depart_13 + b_depart_14_`year'*depart_14 +  
	 b_depart_15_`year'*depart_15 + b_depart_16_`year'*depart_16 + b_depart_17_`year'*depart_17 +
	 b_depart_18_`year'*depart_18 + b_depart_19_`year'*depart_19 + b_depart_20_`year'*depart_20 +
	 b_depart_21_`year'*depart_21 + b_depart_22_`year'*depart_22 + b_depart_23_`year'*depart_23 +    
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
	gen t = weight*trpmiles*exp(CbUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + 	          b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + b_hispanicUS_`year'*hispanic +
	 b_month_2US_`year'*month_2 + b_month_3US_`year'*month_3 +  b_month_4US_`year'*month_4 +
	 b_month_5US_`year'*month_5 + b_month_6US_`year'*month_6 + b_month_7US_`year'*month_7 + b_month_8US_`year'*month_8 +
	 b_month_9US_`year'*month_9 + b_month_10US_`year'*month_10 + b_month_11US_`year'*month_11 + 	 	 b_month_12US_`year'*month_12 +
	 b_hh_education_2US_`year'*hh_education_2 + b_hh_education_3US_`year'*hh_education_3 +
	 b_hh_education_4US_`year'*hh_education_4 + b_hh_education_5US_`year'*hh_education_5 +
	 b_hh_income_2US_`year'*hh_income_2 + b_hh_income_3US_`year'*hh_income_3 + b_hh_income_4US_`year'*hh_income_4 +
	 b_hh_income_5US_`year'*hh_income_5 + b_hh_income_6US_`year'*hh_income_6 + b_hh_income_7US_`year'*hh_income_7 +
	 b_hh_income_8US_`year'*hh_income_8 + b_hh_income_9US_`year'*hh_income_9 + b_hh_income_10US_`year'*hh_income_10 +
	 b_hh_income_11US_`year'*hh_income_11 + b_hh_income_12US_`year'*hh_income_12 + b_hh_income_13US_`year'*hh_income_13 +
	 b_hh_income_14US_`year'*hh_income_14 + b_hh_income_15US_`year'*hh_income_15 + b_hh_income_16US_`year'*hh_income_16 +
	 b_hh_income_17US_`year'*hh_income_17 + b_hh_income_18US_`year'*hh_income_18 +
	 b_depart_1US_`year'*depart_1 + b_depart_2US_`year'*depart_2 + b_depart_3US_`year'*depart_3 + 	 	 	 b_depart_4US_`year'*depart_4 + b_depart_5US_`year'*depart_5 + b_depart_6US_`year'*depart_6 + 		 	 b_depart_7US_`year'*depart_7 + b_depart_8US_`year'*depart_8 + b_depart_9US_`year'*depart_9 + 			 	 b_depart_10US_`year'*depart_10 + b_depart_11US_`year'*depart_11 + 
	 b_depart_12US_`year'*depart_12 + b_depart_13US_`year'*depart_13 + b_depart_14US_`year'*depart_14 +  
	 b_depart_15US_`year'*depart_15 + b_depart_16US_`year'*depart_16 + b_depart_17US_`year'*depart_17 +
	 b_depart_18US_`year'*depart_18 + b_depart_19US_`year'*depart_19 + b_depart_20US_`year'*depart_20 +
	 b_depart_21US_`year'*depart_21 + b_depart_22US_`year'*depart_22 + b_depart_23US_`year'*depart_23 +
	gbUS_`year'*ln(trpmiles));
	quietly total t if year == `year';
	replace S2_`year' = _b[t];
    drop t;

};

		
************** 3) MSA trips at US prices **********************;

gen S3_95 = .;
gen S3_01 = .;
gen S3_09 = .;

foreach year in 95 01 09 {;
	
	gen t = weight*trpmiles*exp(CbUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + b_hispanicUS_`year'*hispanic +
	 b_month_2US_`year'*month_2 + b_month_3US_`year'*month_3 +  b_month_4US_`year'*month_4 +
	 b_month_5US_`year'*month_5 + b_month_6US_`year'*month_6 + b_month_7US_`year'*month_7 + b_month_8US_`year'*month_8 +
	 b_month_9US_`year'*month_9 + b_month_10US_`year'*month_10 + b_month_11US_`year'*month_11 + 	 	 b_month_12US_`year'*month_12 +
	 b_hh_education_2US_`year'*hh_education_2 + b_hh_education_3US_`year'*hh_education_3 +
	 b_hh_education_4US_`year'*hh_education_4 + b_hh_education_5US_`year'*hh_education_5 +
	 b_hh_income_2US_`year'*hh_income_2 + b_hh_income_3US_`year'*hh_income_3 + b_hh_income_4US_`year'*hh_income_4 +
	 b_hh_income_5US_`year'*hh_income_5 + b_hh_income_6US_`year'*hh_income_6 + b_hh_income_7US_`year'*hh_income_7 +
	 b_hh_income_8US_`year'*hh_income_8 + b_hh_income_9US_`year'*hh_income_9 + b_hh_income_10US_`year'*hh_income_10 +
	 b_hh_income_11US_`year'*hh_income_11 + b_hh_income_12US_`year'*hh_income_12 + b_hh_income_13US_`year'*hh_income_13 +
	 b_hh_income_14US_`year'*hh_income_14 + b_hh_income_15US_`year'*hh_income_15 + b_hh_income_16US_`year'*hh_income_16 +
	 b_hh_income_17US_`year'*hh_income_17 + b_hh_income_18US_`year'*hh_income_18 +
	 b_depart_1US_`year'*depart_1 + b_depart_2US_`year'*depart_2 + b_depart_3US_`year'*depart_3 + 	 	 	          b_depart_4US_`year'*depart_4 + b_depart_5US_`year'*depart_5 + b_depart_6US_`year'*depart_6 + 		 	          b_depart_7US_`year'*depart_7 + b_depart_8US_`year'*depart_8 + b_depart_9US_`year'*depart_9 + 			 	         b_depart_10US_`year'*depart_10 + b_depart_11US_`year'*depart_11 + 
	 b_depart_12US_`year'*depart_12 + b_depart_13US_`year'*depart_13 + b_depart_14US_`year'*depart_14 +  
	 b_depart_15US_`year'*depart_15 + b_depart_16US_`year'*depart_16 + b_depart_17US_`year'*depart_17 +
	 b_depart_18US_`year'*depart_18 + b_depart_19US_`year'*depart_19 + b_depart_20US_`year'*depart_20 +
	 b_depart_21US_`year'*depart_21 + b_depart_22US_`year'*depart_22 + b_depart_23US_`year'*depart_23 +	 
	gbUS_`year'*ln(trpmiles));
	
forvalues id = 1(1)`msanum' {; 
	quietly total t if (year == `year' & rank_msa == `id');
	scalar St = _b[t];
	replace S3_`year' = St if rank_msa == `id';
};
	drop t;
};


************************ MSA trips at msa price**********************;

gen S4_95 = .;
gen S4_01 = .;
gen S4_09 = .;


foreach year in 95 01 09 {;
	
	gen t = weight*trpmiles*exp(Cb_`year'+ b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker +  b_black_`year'*black + b_hispanic_`year'*hispanic +
	 b_month_2_`year'*month_2 + b_month_3_`year'*month_3 +  b_month_4_`year'*month_4 +
	 b_month_5_`year'*month_5 + b_month_6_`year'*month_6 + b_month_7_`year'*month_7 + b_month_8_`year'*month_8 +
	 b_month_9_`year'*month_9 + b_month_10_`year'*month_10 + b_month_11_`year'*month_11 + b_month_12_`year'*month_12 +
	 b_hh_education_2_`year'*hh_education_2 + b_hh_education_3_`year'*hh_education_3 +
	 b_hh_education_4_`year'*hh_education_4 + b_hh_education_5_`year'*hh_education_5 +
	 b_hh_income_2_`year'*hh_income_2 + b_hh_income_3_`year'*hh_income_3 + b_hh_income_4_`year'*hh_income_4 +
	 b_hh_income_5_`year'*hh_income_5 + b_hh_income_6_`year'*hh_income_6 + b_hh_income_7_`year'*hh_income_7 +
	 b_hh_income_8_`year'*hh_income_8 + b_hh_income_9_`year'*hh_income_9 + b_hh_income_10_`year'*hh_income_10 +
	 b_hh_income_11_`year'*hh_income_11 + b_hh_income_12_`year'*hh_income_12 + b_hh_income_13_`year'*hh_income_13 +
	 b_hh_income_14_`year'*hh_income_14 + b_hh_income_15_`year'*hh_income_15 + b_hh_income_16_`year'*hh_income_16 +
	 b_hh_income_17_`year'*hh_income_17 + b_hh_income_18_`year'*hh_income_18 +
	 b_depart_1_`year'*depart_1 + b_depart_2_`year'*depart_2 + b_depart_3_`year'*depart_3 + b_depart_4_`year'*depart_4 + 
	 b_depart_5_`year'*depart_5 + b_depart_6_`year'*depart_6 + b_depart_7_`year'*depart_7 + b_depart_8_`year'*depart_8 +
         b_depart_9_`year'*depart_9 + b_depart_10_`year'*depart_10 + b_depart_11_`year'*depart_11 + 
	 b_depart_12_`year'*depart_12 + b_depart_13_`year'*depart_13 + b_depart_14_`year'*depart_14 +  
	 b_depart_15_`year'*depart_15 + b_depart_16_`year'*depart_16 + b_depart_17_`year'*depart_17 +
	 b_depart_18_`year'*depart_18 + b_depart_19_`year'*depart_19 + b_depart_20_`year'*depart_20 +
	 b_depart_21_`year'*depart_21 + b_depart_22_`year'*depart_22 + b_depart_23_`year'*depart_23 + 
	gb_`year'*ln(trpmiles));
	
forvalues id = 1(1)`msanum' {; 
	total t if (year ==`year' & rank_msa == `id');
	quietly scalar St = _b[t];
	replace S4_`year' = St if rank_msa == `id';
};
drop t;
};


* Generate Laspeyres, Paasche and Fisher price indexes, and their logs;

foreach year in 95 01 09 {;

gen Lb_`year' = S1_`year'/S2_`year';
gen Pb_`year' = S4_`year'/S3_`year';
gen Fb_`year' = sqrt(Lb_`year'*Pb_`year');

gen l_Lb_`year' = ln(Lb_`year');
gen l_Pb_`year' = ln(Pb_`year');
gen l_Fb_`year' = ln(Fb_`year');


};
collapse  (mean)  Lb_95 Lb_01 Lb_09 l_Lb_95 l_Lb_01 l_Lb_09
                  CbUS_95 CbUS_01 CbUS_09 gbUS_95 gbUS_01 gbUS_09 
				  Cb_95 Cb_01 Cb_09 gb_95 gb_01 gb_09
				  Cb_sd_95 Cb_sd_01 Cb_sd_09 gb_sd_95 gb_sd_01 gb_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_b_`msanum'8", replace;

};


};
































*********************************************************************************************;
************** Regression 5e  ****************************************************************;
*      IV distance in comparable msa by trip purpose with censoring top and bottom quartiles ***;
*********************************************************************************************;


* Manual IV ;

if 1==0{;

local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";
local controls2 = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker";


foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";

sort msa;

merge msa using "$data_source\IV2.dta";;

tab _merge;
keep if _merge == 3;
drop _merge;

keep if rank_msa <= `msanum';

gen purpinst = .;

foreach year in 95 01 09 {;
foreach i in 1 2 3 4 5 6 7 8 10 11 {;			
replace purpinst =  inst_neighB_`i'_`year' if (year == `year' & whytrp90 == `i');
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


* censor top and bottom quartile;

su l_trpmiles if year ==`year', d;
scalar per25=r(p25);
scalar per75=r(p75);

drop if (year ==`year' & l_trpmiles>per75);
drop if (year ==`year' & l_trpmiles<per25);


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

};



compress;


};


keep `controls' l_p l_trpmiles trpmiles l_purpinst* msa b_* obs_number  Ce* ge* rank_msa year wtperfin;

save "$data_source\npts_Ce_`msanum'5", replace;

};


};


if 1==0{;



************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 /*240*/ {;

use "$data_source\npts_Ce_`msanum'5";

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
					Fe_95 Fe_01 Fe_09 l_Fe_95 l_Fe_01 l_Fe_09
					CeUS_95 CeUS_01 CeUS_09 geUS_95 geUS_01 geUS_09 
					Ce_95 Ce_01 Ce_09 ge_95 ge_01 ge_09
					Ce_sd_95 Ce_sd_01 Ce_sd_09 ge_sd_95 ge_sd_01 ge_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_e_`msanum'5", replace;

};


};







*********************************************************************************************;
************** Regression 5f  ****************************************************************;
*      IV distance in comparable msa by trip purpose with censoring non peak hours        ***;
*********************************************************************************************;


* Manual IV ;

if 1==0{;

local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";
local controls2 = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker";


foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";

sort msa;

merge msa using "$data_source\IV2.dta";;

tab _merge;
keep if _merge == 3;
drop _merge;

keep if rank_msa <= `msanum';



* get rid of all non peak trips (slightly different from the peak variable);
drop if start1<7.00;
drop if (start1>9.30 & start1<15);
drop if start1>19;



gen purpinst = .;

foreach year in 95 01 09 {;
foreach i in 1 2 3 4 5 6 7 8 10 11 {;			
replace purpinst =  inst_neighB_`i'_`year' if (year == `year' & whytrp90 == `i');
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
if (threshold<2 | (`id'==92 & `year'==95) | (`id'==96 & `year'==95)  | (`id'==66 & `year'==09)  | (`id'== 75 & `year'==09)  ){;
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

};



compress;


};


keep `controls' l_p l_trpmiles trpmiles l_purpinst* msa b_* obs_number  Ce* ge* rank_msa year wtperfin;

save "$data_source\npts_Ce_`msanum'6", replace;

};


};


if 1==0{;



************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 240 {;

use "$data_source\npts_Ce_`msanum'6";

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
					Fe_95 Fe_01 Fe_09 l_Fe_95 l_Fe_01 l_Fe_09
					CeUS_95 CeUS_01 CeUS_09 geUS_95 geUS_01 geUS_09 
					Ce_95 Ce_01 Ce_09 ge_95 ge_01 ge_09
					Ce_sd_95 Ce_sd_01 Ce_sd_09 ge_sd_95 ge_sd_01 ge_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_e_`msanum'6", replace;

};


};




*********************************************************************************************;
************** Regression 5g  ****************************************************************;
*      IV distance in comparable msa by trip purpose keeping only commutes and work related trips        ***;
*********************************************************************************************;


* Manual IV ;

if 1==0{;

local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";
local controls2 = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker";


foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";

sort msa;

merge msa using "$data_source\IV2.dta";;

tab _merge;
keep if _merge == 3;
drop _merge;

keep if rank_msa <= `msanum';



* keep only work trips and commutes;
drop if whytrp90>2;



gen purpinst = .;

foreach year in 95 01 09 {;
foreach i in 1 2 3 4 5 6 7 8 10 11 {;			
replace purpinst =  inst_neighB_`i'_`year' if (year == `year' & whytrp90 == `i');
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

* ONLY 50 cities estimated here even on the larger sample of observations;

local num = min(50,`msanum');

forvalues id = 1(1)`num' {;

* special treatment when the black dummy is not identified in the city regression;
total black if (rank_msa==`id' & year==`year');
scalar threshold=_b[black];
local q = 1;
if (threshold<2 | (`id'==9 & `year'==95) | (`id'==15 & `year'==95) | (`id'==20 & `year'==95)| 
(`id'==25 & `year'==95) |(`id'==29 & `year'==95) |(`id'>32& `year'==95) | 
(`id'==6 & `year'==01)| (`id'==9 & `year'==01) | (`id'==11 & `year'==01)|
 (`id'==12 & `year'==01) | (`id'==14 & `year'==01) | (`id'==15 & `year'==01)| (`id'>17 & `year'==01) 
 | (`id'>19 & `year'==09)  ){;
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

};



compress;


};


keep `controls' l_p l_trpmiles trpmiles l_purpinst* msa b_* obs_number  Ce* ge* rank_msa year wtperfin;

save "$data_source\npts_Ce_`msanum'7", replace;

};


};


if 1==1{;



************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 /*100 240*/ {;

use "$data_source\npts_Ce_`msanum'7";

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
					Fe_95 Fe_01 Fe_09 l_Fe_95 l_Fe_01 l_Fe_09
					CeUS_95 CeUS_01 CeUS_09 geUS_95 geUS_01 geUS_09 
					Ce_95 Ce_01 Ce_09 ge_95 ge_01 ge_09
					Ce_sd_95 Ce_sd_01 Ce_sd_09 ge_sd_95 ge_sd_01 ge_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_e_`msanum'7", replace;

};


};











exit;


*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************
*******************************************************************************************;






