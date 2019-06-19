	/********************************
1_data.do

VC Summer 2010, GD May-June 2011
GD December 2015

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
************** Regression 0        **********************************************************;
*     Computation of average speeds    ******************************************************;
*********************************************************************************************;

if 1==0{;



foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";
 
keep if rank_msa <= `msanum';

gen trip_time = exp(l_trvl_min);

egen total_time = total(trip_time), by(msa year);
egen total_dist = total(trpmiles), by(msa year);

egen total_timeUS = total(trip_time), by(year);
egen total_distUS = total(trpmiles), by(year);

gen L =  (total_dist/total_time)/(total_distUS/total_timeUS);

gen L_95A=.;
gen L_01A=.;
gen L_09A=.;

replace L_95A = 1/L if year==95;
replace L_01A = 1/L if year==01;
replace L_09A = 1/L if year==09;

gen trip_time_w = trip_time*wtperfin;
gen trpmiles_w = trpmiles*wtperfin;

egen total_time_w = total(trip_time_w), by(msa year);
egen total_dist_w = total(trpmiles_w), by(msa year);

egen total_timeUS_w = total(trip_time_w), by(year);
egen total_distUS_w = total(trpmiles_w), by(year);

gen L2 =  (total_dist_w/total_time_w)/(total_distUS_w/total_timeUS_w);

gen L_95B=.;
gen L_01B=.;
gen L_09B=.;

replace L_95B = 1/L2 if year==95;
replace L_01B = 1/L2 if year==01;
replace L_09B = 1/L2 if year==09;


collapse (mean) rank_msa L_95A L_01A L_09A  L_95B L_01B L_09B, by(msa) ;

save "$output\npts_index_`msanum'", replace;

};



};


*********************************************************************************************;
************** Set up instruments 1**********************************************************;
*IV1 --- Create an instrument for trip distance equal to average distance traveled for*******;
*trips of the same purpose in a group of msa with comparable population and location*********;
*********************************************************************************************;

* To be done only once;

if 1==0 {;


use "$data_source\npts_msa";

drop pop60;

merge m:m msa using $data_source\msa_temp.dta;
drop _merge;

save "$data_source\working_msa.dta", replace;

*** Create a variable containing divisions (instead of dummies) (9 census division in the US)*****;
gen div = .;
forvalues i = 1(1)9 {;
replace div = `i' if div`i' == 1;
};


* generate a variable division_id, equal to the division of the msa "id" ;

forvalues id = 1(1)240 {;
  
	mean div if rank_msa == `id';
	scalar divnum = _b[div];
	gen division_`id' = divnum;
	
	mean rank_msa if rank_msa == `id';
	scalar popnum = _b[rank_msa];
	gen rank_msa_`id' = popnum;
	
};	

* generate an empty variable to hold the instruments;     
foreach year in 95 01 09 {;
forvalues i = 1(1)8 {;
gen inst_neighA_`i'_`year' = .;
};
forvalues i = 10(1)11 {;
gen inst_neighA_`i'_`year' = .;
};
};

/*generate a variable measuring how far (in terms of population and location) different msas are from each other;*/
foreach year in 95 01 09 {;
  forvalues id = 1(1)240 {;
gen pop_dis = .;
gen same_div = 1;
        forvalues k = 1(1)240 {;
replace pop_dis = abs(rank_msa_`id' - rank_msa_`k') if rank_msa == `k';
replace same_div = 0 if (division_`id' == division_`k' & rank_msa == `k');

};
gen score = pop_dis + 5*same_div;
sort score;
gen obs = _n;

*generate the instrument means we are average trips from the 4 msas with closest population and location) for rank_msa below 100 and 10 for rank_msas above;
local peer = 5 +min(max(`id'-100,0),1)*6;

foreach j in 1 2 3 4 5 6 8 10 {;
mean purpmsa_`j'_`year' if (obs > 1 & obs <= `peer');
scalar inst_`j'_`year' = _b[purpmsa_`j'_`year'];
replace inst_neighA_`j'_`year' = inst_`j'_`year' if rank_msa == `id';
};

/* need to use bigger groups for the purpose with very little trips (about 1% of sample for purpose 7 (vacation;
*and 11 (other, refused etc), especially because few observations in 1995;*/

local peer = 50 +min(max(`id'-99,0),1)*50; 
foreach j in 7 11 {;
mean purpmsa_`j'_`year' if (obs <= `peer' & rank_msa ~= `id');
scalar inst_`j'_`year' = _b[purpmsa_`j'_`year'];
replace inst_neighA_`j'_`year' = inst_`j'_`year' if rank_msa == `id';
};
drop  pop_dis same_div score obs;
}; 
};

sort msa;
keep msa inst_neighA_1_95-inst_neighA_11_09;

save "$data_source\iv1.dta", replace;

};




*********************************************************************************************;
************** Set up instruments 2**********************************************************;
*IV2 --- Create an instrument for trip distance equal to average distance traveled for*******;
*trips of the same purpose in a group of msa with comparable population *********************;
*********************************************************************************************;

* To be done only once;

if 1==0 {;


use "$data_source\working_msa.dta";


forvalues id = 1(1)240 {;
	
	mean rank_msa if rank_msa == `id';
	scalar popnum = _b[rank_msa];
	gen rank_msa_`id' = popnum;
	
};	

* generate an empty variable to hold the instruments;     
foreach year in 95 01 09 {;
forvalues i = 1(1)8 {;
gen inst_neighB_`i'_`year' = .;
};
forvalues i = 10(1)11 {;
gen inst_neighB_`i'_`year' = .;
};
};

/*generate a variable measuring how far (in terms of population) different msas are from each other;*/
foreach year in 95 01 09 {;
  forvalues id = 1(1)240 {;
gen pop_dis = .;
        forvalues k = 1(1)240 {;
replace pop_dis = abs(rank_msa_`id' - rank_msa_`k') if rank_msa == `k';
};
gen score = pop_dis;
sort score;
gen obs = _n;

display rank_msa;

*generate the instrument means we are average trips from the 4 msas with closest population and location) for rank_msa below 100 and 12 for rank_msas above;
local peer = 5 +min(max(`id'-100,0),1)*8;

foreach j in 1 2 3 4 5 8 10 {;
quietly mean purpmsa_`j'_`year' if (obs > 1 & obs <= `peer');
scalar inst_`j'_`year' = _b[purpmsa_`j'_`year'];
replace inst_neighB_`j'_`year' = inst_`j'_`year' if rank_msa == `id';
};



/* need to use bigger groups for the purpose with very little trips (about 1% of sample 
for purpose 7 (vacation;
*6 (medical dental) and 11 (other, refused etc), especially because few observations in 1995;*/

if `year'==95{;
local peer = 50 +min(max(`id'-99,0),1)*50; 
};


if `year'==01 | `year'==09 {;
local peer = 10 +min(max(`id'-99,0),1)*8; 
};

foreach j in 6 7 11 {;
quietly mean purpmsa_`j'_`year' if (obs <= `peer' & rank_msa ~= `id');
scalar inst_`j'_`year' = _b[purpmsa_`j'_`year'];
replace inst_neighB_`j'_`year' = inst_`j'_`year' if rank_msa == `id';
};
drop  pop_dis score obs;
}; 
};

sort msa;
keep msa inst_neighB_1_95-inst_neighB_11_09;

save "$data_source\iv2.dta", replace;


};

*********************************************************************************************;
************** Regression 1  +  Set up instruments 3        *********************************;
*********************************************************************************************:
*******    OLS with no controls     +    instrument for trip distance ***********************;
******          equal to average distance traveled for trips of the same purpose      *******;
******             among msa with comparable OLS results without controls        ************;
*********************************************************************************************;

* To be done only once --- several steps are involved;
* Step 1: run ols;
* Step 2: compute speed index;
* Setp 3: select matching cities and compute the instruments;

if 1==0 {;


************** Step 1: Supply curve estimation using OLS with no controls *******************; 

* Decide how many msas to keep;
foreach msanum in 50 100 240 {; 

*use ".\data\npts.dta";
use "$data_source\working_npts.dta";
 
keep if rank_msa <= `msanum';

* Supply curves for the United States, for each year;
foreach year in 95 01 09 {;
gen CaUS_`year' = .;
gen gaUS_`year' = .;

reg l_p l_trpmiles if year == `year', robust;
replace CaUS_`year' = _b[_cons];
replace gaUS_`year' = _b[l_trpmiles];
};

* Supply curves for each MSA, for each year;
foreach year in 95 01 09 {;
gen Ca_`year' = .;
gen ga_`year' = .;

gen Ca_sd_`year' = .;
gen ga_sd_`year' = .;


forvalues id = 1(1)`msanum' {;

display "`year' ----- `id'";

reg l_p l_trpmiles if (rank_msa == `id' & year == `year'), robust;
          replace Ca_`year' = _b[_cons] if rank_msa == `id';
          replace ga_`year' = _b[l_trpmiles] if rank_msa == `id';
		  replace Ca_sd_`year' = _se[_cons] if rank_msa == `id';
          replace ga_sd_`year' = _se[l_trpmiles] if rank_msa == `id';
};
};

save "$data_source\npts_Ca_`msanum'", replace;

};

************** Step 2: Compute Price index from supply curve *****************************;


* Decide how many msas to keep (must match how many are kept in "supply_mmdd.do", 
  the program that creates the data);
  
foreach msanum in 50 100 240 {;

use "$data_source\npts_Ca_`msanum'", replace;

keep if rank_msa <= `msanum';

drop  msa_name pid whytrp90 urb peak l_mph_trip l_trpmiles l_trvl_min y_95 y_01 y_09;

******************** 1) US trips at MSA price*********************************;

* I use "mean" to generate a scalar equal to parameters of the
  supply curve in an msa (not very elegant thing to do) that I can the
  use to compute the speed of all trips in the US. Note that the data consist of 
  individuals, and all the trip they are taken in one day. So if I was to divide,
  the sum I obtain by the number of individuals (which is unecessary) I'd obtain,
  an average time cost.(Using weights would be a good idea, to make sure sample is 
  representative of US population);
  
* Time is estimated as distance multiplied by the invert of speed, as
  estimated from the supply curve parameters i.e. t= q*(C+ controls+ glog(q))=q*(1/s);  

* I weight each trip using npts weights (person weights, just trip weights divided by 365).
  Here I divide the weights by 1000 so that Stata doesn't have to deal with huge sums;
  
  gen weight = wtperfin/1000;
  
gen S1_95 = .;
gen S1_01 = .;
gen S1_09 = .;
	
foreach year in 95 01 09 {;
forvalues id = 1(1)`msanum'{; 

	quietly mean Ca_`year' if rank_msa == `id';
	scalar Cmsa = _b[Ca_`year'];
	quietly mean ga_`year' if rank_msa == `id';
	scalar gmsa = _b[ga_`year'];
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
gen ttest = trpmiles/mph_trip;
gen S2test_95 = .;
gen S2test_01 = .;
gen S2test_09 = .;

foreach year in 95 01 09 {;
	gen t = weight*trpmiles*exp(CaUS_`year'+ gaUS_`year'*ln(trpmiles));
	quietly total t if year == `year';
	replace S2_`year' = _b[t];

	quietly total ttest if year == `year';
	replace S2test_`year' = _b[ttest];
	drop t;
};

		
************** 3) MSA trips at US prices **********************;

gen S3_95 = .;
gen S3_01 = .;
gen S3_09 = .;

foreach year in 95 01 09 {;
	
	gen t = weight*trpmiles*exp(CaUS_`year'+ gaUS_`year'*ln(trpmiles));
	
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
 
gen S4test_95 = .;
gen S4test_01 = .;
gen S4test_09 = .;


foreach year in 95 01 09 {;
	
	gen t = weight*trpmiles*exp(Ca_`year'+ ga_`year'*ln(trpmiles));
	
forvalues id = 1(1)`msanum' {; 
	quietly total t if (year ==`year' & rank_msa == `id');
	scalar St = _b[t];
	replace S4_`year' = St if rank_msa == `id';
};
drop t;
};


* Generate Laspeyres, Paasche and Fisher price indexes, and their logs;

foreach year in 95 01 09 {;
gen La_`year' = S1_`year'/S2_`year';
gen Pa_`year' = S4_`year'/S3_`year';
gen Fa_`year' = sqrt(La_`year'*Pa_`year');
gen Patest_`year' = S4test_`year'/S3_`year';
gen l_La_`year' = ln(La_`year');
gen l_Pa_`year' = ln(Pa_`year');
gen l_Fa_`year' = ln(Fa_`year');
gen l_Patest_`year' = ln(Patest_`year');
};

* Paasche and Fisher indices are no longer kept -- only for the next set of regressions;
collapse  (mean)  La_95 La_01 La_09 l_La_95 l_La_01 l_La_09
                  CaUS_95 CaUS_01 CaUS_09 gaUS_95 gaUS_01 gaUS_09 
				  Ca_95 Ca_01 Ca_09 ga_95 ga_01 ga_09
				  Ca_sd_95 Ca_sd_01 Ca_sd_09 ga_sd_95 ga_sd_01 ga_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_a_`msanum'", replace;

};


************** Step 3: Match cities and compute instruments *****************************;

use "$output\npts_index_a_240";

keep La_95 La_01 La_09 msa rank_msa;

sort msa;

merge msa using "$data_source\npts_msa";

drop _merge;
     
* first generate a variable for each instruments;
foreach year in 95 01 09 {;
forvalues i = 1(1)8 {;
gen inst_neighC_`i'_`year' = .;
};
forvalues i = 10(1)11 {;
gen inst_neighC_`i'_`year' = .;
};
};

*generate a variable measuring how far (in terms of of OLS with no controls index a) different msas are from each other;
foreach year in 95 01 09 {;

	forvalues id = 1(1)240 {;
	gen indexdiff = .;
	mean La_`year' if rank_msa == `id';
	scalar Lamsa = _b[La_`year'];
	replace indexdiff = abs(La_`year' - Lamsa);
	sort indexdiff;
	gen obs = _n;
*generate the instrument means we are average trips from the 5 msas with closest OLS with controls index for rank_msa below 50,
10 between 50 and 100 and 20 for rank_msa above;

local peer = 6 +min(max(`id'-50,0),1)*5+min(max(`id'-100,0),1)*10;

foreach j in 1 2 3 4 5 6 8 10 {;
mean purpmsa_`j'_`year' if (obs > 1 & obs <= `peer');
scalar inst_`j'_`year' = _b[purpmsa_`j'_`year'];
replace inst_neighC_`j'_`year' = inst_`j'_`year' if rank_msa == `id';
};

/* need to use bigger groups for the purpose with very little trips (about 1% of sample for purpose 7 (vacation;
*and 11 (other, refused etc), especially because few observations in 1995;*/


local peer = 41 +min(max(`id'-50,0),1)*20+min(max(`id'-100,0),1)*30;
*local peer = 50 +min(max(`id'-99,0),1)*50; 
foreach j in 7 11 {;
quietly mean purpmsa_`j'_`year' if (obs <= `peer' & rank_msa ~= `id');
scalar inst_`j'_`year' = _b[purpmsa_`j'_`year'];
replace inst_neighC_`j'_`year' = inst_`j'_`year' if rank_msa == `id';
};

	drop obs indexdiff;
};
};

sort msa;
keep msa inst_neighC_1_95-inst_neighC_11_09;

save "$data_source\iv3.dta", replace;


};



*********************************************************************************************;
************** Regression 2  +  Set up instruments 4        *********************************;
*********************************************************************************************:
*******    OLS with controls     +    instrument for trip distance    ***********************;
******          equal to average distance traveled for trips of the same purpose      *******;
******             among msa with comparable OLS results without controls        ************;
*********************************************************************************************;

* To be done only once --- several steps are involved;
* Step 1: run ols;
* Step 2: compute speed index;
* Setp 3: select matching cities and compute the instruments;

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

save "$data_source\npts_Cb_`msanum'", replace;

};


************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 240 {;

use "$data_source\npts_Cb_`msanum'";

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
	
save "$output\npts_index_b_`msanum'", replace;

};


************** Step 3: Match cities and compute instruments *****************************;

use "$output\npts_index_b_240", replace;

keep Lb_95 Lb_01 Lb_09 msa rank_msa;

sort msa;

merge msa using "$data_source\npts_msa";

drop _merge;
     
* first generate a variable for each instruments;
foreach year in 95 01 09 {;
forvalues i = 1(1)8 {;
gen inst_neighD_`i'_`year' = .;
};
forvalues i = 10(1)11 {;
gen inst_neighD_`i'_`year' = .;
};
};

*generate a variable measuring how far (in terms of of OLS with controls index b) different msas are from each other;
foreach year in 95 01 09 {;

	forvalues id = 1(1)240 {;
	gen indexdiff = .;
	mean Lb_`year' if rank_msa == `id';
	scalar Lamsa = _b[Lb_`year'];
	replace indexdiff = abs(Lb_`year' - Lamsa);
	sort indexdiff;
	gen obs = _n;

*generate the instrument means we are average trips from the 5 msas with closest OLS with controls index for rank_msa below 50,
10 between 50 and 100 and 20 for rank_msa above;

local peer = 6 +min(max(`id'-50,0),1)*5+min(max(`id'-100,0),1)*10;


foreach j in 1 2 3 4 5 6 8 10 {;
mean purpmsa_`j'_`year' if (obs > 1 & obs <= `peer');
scalar inst_`j'_`year' = _b[purpmsa_`j'_`year'];
replace inst_neighD_`j'_`year' = inst_`j'_`year' if rank_msa == `id';
};

/* need to use bigger groups for the purpose with very little trips (about 1% of sample for purpose 7 (vacation;
*and 11 (other, refused etc), especially because few observations in 1995;*/

local peer = 41 +min(max(`id'-50,0),1)*20+min(max(`id'-100,0),1)*30;
foreach j in 7 11 {;
quietly mean purpmsa_`j'_`year' if (obs <= `peer' & rank_msa ~= `id');
scalar inst_`j'_`year' = _b[purpmsa_`j'_`year'];
replace inst_neighD_`j'_`year' = inst_`j'_`year' if rank_msa == `id';
};

	drop obs indexdiff;
};
};

sort msa;
keep msa inst_neighD_1_95-inst_neighD_11_09;

save "$data_source\iv4.dta", replace;


};





*********************************************************************************************;
************** Regression 2b        *********************************************************;
*      OLS with a more compact set of controls      *****************************************;
*********************************************************************************************;


if 1==0 {;


************** Step 1: Supply curve estimation using OLS with controls *******************; 

* Decide how many msas to keep;
foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";
 
keep if rank_msa <= `msanum';

local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";


*Centering the controls to make the constant comparables;
foreach variable of local controls {;
egen `variable'_a = mean(`variable');
gen `variable'_c = `variable' - `variable'_a;
drop `variable' `variable'_a;
rename `variable'_c `variable';

};


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
gen CbUS_`year'2 = .;
gen gbUS_`year'2 = .;
gen CbUS_sd_`year'2 = .;
gen gbUS_sd_`year'2 = .;

forvalues i = 1(1)2 {;
gen b_hh_income_`i'US_`year'  =. ;
};
forvalues i = 1(1)4 {;
gen b_depart_`i'US_`year'  =. ;
};
forvalues i = 1(1)2 {;
gen b_hh_education_`i'US_`year' =. ;
};
gen b_r_ageUS_`year' =. ; 
gen b_r_sexUS_`year' =. ; 
gen b_tdwkndUS_`year' =. ;
gen b_workerUS_`year' =.  ;
gen b_blackUS_`year' =.  ;


reg l_p l_trpmiles `controls' if year == `year', cl(msa) robust;
          
replace CbUS_`year' = _b[_cons];
replace gbUS_`year' = _b[l_trpmiles];
forvalues i = 1(1)2 {;
          replace b_hh_income_`i'US_`year'  = _b[income`i'] ;
};
forvalues i = 1(1)4 {;
          replace b_depart_`i'US_`year'  = _b[start`i'] ;
};
forvalues i = 1(1)2 {;
          replace b_hh_education_`i'US_`year'  = _b[educ`i'] ;
};
replace b_r_ageUS_`year' = _b[r_age];
replace b_r_sexUS_`year' = _b[r_sex];
replace b_tdwkndUS_`year' = _b[tdwknd];
replace b_workerUS_`year' = _b[worker];
replace b_blackUS_`year' = _b[black];
};		  

*Now save values of msa-specific coefficient. I run only one regression per year (so coefficient
for controls is same for each msa, but slope and intercept of curve varies at msa-level);

foreach year in 95 01 09 {;


gen Cb_`year' = .;
gen gb_`year' = .;

gen Cb_sd_`year' = .;
gen gb_sd_`year' = .;

forvalues i = 1(1)2 {;
gen b_hh_income_`i'_`year'  =. ;
};
forvalues i = 1(1)2 {;
gen b_hh_education_`i'_`year' =. ;
};
forvalues i = 1(1)4 {;
gen b_depart_`i'_`year'  =. ;
};
gen b_r_age_`year' =. ; 
gen b_r_sex_`year' =. ; 
gen b_tdwknd_`year' =. ;
gen b_worker_`year' =.  ;

gen b_black_`year' =.  ;


reg l_p m_1-m_`msanum' mdist_1-mdist_`msanum' `controls' if year == `year', noconstant cl(msa) robust;

forvalues i = 1(1)2 {;
          replace b_hh_income_`i'_`year'  = _b[income`i'] ;
};
forvalues i = 1(1)4 {;
          replace b_depart_`i'_`year'  = _b[start`i'] ;
};
forvalues i = 1(1)2 {;
          replace b_hh_education_`i'_`year'  = _b[educ`i'] ;
};
replace b_r_age_`year' = _b[r_age];
replace b_r_sex_`year' = _b[r_sex];
replace b_tdwknd_`year' = _b[tdwknd];
replace b_worker_`year' = _b[worker];
replace b_black_`year' = _b[black];		  

		  
forvalues id = 1(1)`msanum' {;
replace Cb_`year' = _b[m_`id'] if m_`id' == 1;
replace gb_`year' = _b[mdist_`id'] if m_`id' ==1;
replace Cb_sd_`year' = _se[m_`id'] if m_`id' == 1;
replace gb_sd_`year' = _se[mdist_`id'] if m_`id' ==1;};
};

drop m_1-m_`msanum';
drop mdist_1-mdist_`msanum';

save "$data_source\npts_Cb_`msanum'2", replace;

};


************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 240 {;

use "$data_source\npts_Cb_`msanum'2";

keep if rank_msa <= `msanum';

drop  msa_name pid whytrp90 urb peak l_mph_trip l_trpmiles l_trvl_min y_95 y_01 y_09;


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
	 b_worker_`year'*worker + b_black_`year'*black +
	 b_hh_education_1_`year'*educ1 + b_hh_education_2_`year'*educ2 +
	 b_hh_income_1_`year'*income1 + b_hh_income_2_`year'*income2 +
         b_depart_1_`year'*start1 + b_depart_2_`year'*start2 + b_depart_3_`year'*start3 + b_depart_4_`year'*start4 + 
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
	gen t = weight*trpmiles*exp(CbUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + 	          
	 b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + 
	 b_hh_education_1US_`year'*educ1 + b_hh_education_2US_`year'*educ2 +
	 b_hh_income_1US_`year'*income1 + b_hh_income_2US_`year'*income2 +
	 b_depart_1US_`year'*start1 + b_depart_2US_`year'*start2 + b_depart_3US_`year'*start3 + 	
 	 b_depart_4US_`year'*start4 + 
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
	 b_workerUS_`year'*worker + b_blackUS_`year'*black +
	 b_hh_education_1US_`year'*educ1 + b_hh_education_2US_`year'*educ2 +
	 b_hh_income_1US_`year'*income1 + b_hh_income_2US_`year'*income2 +
	 b_depart_1US_`year'*start1 + b_depart_2US_`year'*start2 + b_depart_3US_`year'*start3 + 	
         b_depart_4US_`year'*start4 +	 
	 gbUS_`year'*ln(trpmiles));
	
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
	
	gen t = weight*trpmiles*exp(Cb_`year'+ b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker +  b_black_`year'*black + 
	 b_hh_education_1_`year'*educ1 + b_hh_education_2_`year'*educ2 +
	 b_hh_income_1_`year'*income1 + b_hh_income_2_`year'*income2 +
	 b_depart_1_`year'*start1 + b_depart_2_`year'*start2 + b_depart_3_`year'*start3 + b_depart_4_`year'*start4 + 
         gb_`year'*ln(trpmiles));
	
forvalues id = 1(1)`msanum' {; 
	quietly total t if (year ==`year' & rank_msa == `id');
	scalar St = _b[t];
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
		  Pb_95 Pb_01 Pb_09 l_Pb_95 l_Pb_01 l_Pb_09
		  Fb_95 Fb_01 Fb_09 l_Fb_95 l_Fb_01 l_Fb_09
          CbUS_95 CbUS_01 CbUS_09 gbUS_95 gbUS_01 gbUS_09 
		  Cb_95 Cb_01 Cb_09 gb_95 gb_01 gb_09
		  Cb_sd_95 Cb_sd_01 Cb_sd_09 gb_sd_95 gb_sd_01 gb_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_b_`msanum'2", replace;

};


};



*********************************************************************************************;
************** Regression 2c        *********************************************************;
*      OLS in levels instead of logs with a compact set of controls      ********************;
*********************************************************************************************;


if 1==0 {;


************** Step 1: Supply curve estimation using OLS with controls *******************; 

* Decide how many msas to keep;
foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";
 
keep if rank_msa <= `msanum';

local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";

*Centering the controls to make the constant comparables;
foreach variable of local controls {;
egen `variable'_a = mean(`variable');
gen `variable'_c = `variable' - `variable'_a;
drop `variable' `variable'_a;
rename `variable'_c `variable';

};



gen p=exp(l_p);

*interacted terms;
forvalues id = 1(1)`msanum' {;
gen m_`id' = 0;
replace m_`id' = 1 if rank_msa == `id';
};

forvalues id = 1(1)`msanum' {;
gen mdist_`id' = trpmiles*m_`id';
};

* First, compute supply curves for the United States, for each year;
foreach year in 95 01 09 {;

*some variables to receive coefficient values;
gen CbUS_`year'2 = .;
gen gbUS_`year'2 = .;
gen CbUS_`year' = .;
gen gbUS_`year' = .;
forvalues i = 1(1)2 {;
gen b_hh_income_`i'US_`year'  =. ;
};
forvalues i = 1(1)4 {;
gen b_depart_`i'US_`year'  =. ;
};
forvalues i = 1(1)2 {;
gen b_hh_education_`i'US_`year' =. ;
};
gen b_r_ageUS_`year' =. ; 
gen b_r_sexUS_`year' =. ; 
gen b_tdwkndUS_`year' =. ;
gen b_workerUS_`year' =.  ;
gen b_blackUS_`year' =.  ;


reg p trpmiles `controls' if year == `year', cl(msa) robust;
          
replace CbUS_`year' = _b[_cons];
replace gbUS_`year' = _b[trpmiles];

forvalues i = 1(1)2 {;
          replace b_hh_income_`i'US_`year'  = _b[income`i'] ;
};
forvalues i = 1(1)4 {;
          replace b_depart_`i'US_`year'  = _b[start`i'] ;
};
forvalues i = 1(1)2 {;
          replace b_hh_education_`i'US_`year'  = _b[educ`i'] ;
};
replace b_r_ageUS_`year' = _b[r_age];
replace b_r_sexUS_`year' = _b[r_sex];
replace b_tdwkndUS_`year' = _b[tdwknd];
replace b_workerUS_`year' = _b[worker];
replace b_blackUS_`year' = _b[black];
};		  

*Now save values of msa-specific coefficient. I run only one regression per year (so coefficient
for controls is same for each msa, but slope and intercept of curve varies at msa-level);

foreach year in 95 01 09 {;

gen Cb_`year' = .;
gen gb_`year' = .;

gen Cb_sd_`year' = .;
gen gb_sd_`year' = .;

*replace CbUS_`year' = _b[_cons];
*replace gbUS_`year' = _b[trpmiles];


forvalues i = 1(1)2 {;
gen b_hh_income_`i'_`year'  =. ;
};
forvalues i = 1(1)2 {;
gen b_hh_education_`i'_`year' =. ;
};
forvalues i = 1(1)4 {;
gen b_depart_`i'_`year'  =. ;
};
gen b_r_age_`year' =. ; 
gen b_r_sex_`year' =. ; 
gen b_tdwknd_`year' =. ;
gen b_worker_`year' =.  ;

gen b_black_`year' =.  ;


reg p m_1-m_`msanum' mdist_1-mdist_`msanum' `controls' if year == `year', noconstant cl(msa) robust;

forvalues i = 1(1)2 {;
          replace b_hh_income_`i'_`year'  = _b[income`i'] ;
};
forvalues i = 1(1)4 {;
          replace b_depart_`i'_`year'  = _b[start`i'] ;
};
forvalues i = 1(1)2 {;
          replace b_hh_education_`i'_`year'  = _b[educ`i'] ;
};
replace b_r_age_`year' = _b[r_age];
replace b_r_sex_`year' = _b[r_sex];
replace b_tdwknd_`year' = _b[tdwknd];
replace b_worker_`year' = _b[worker];
replace b_black_`year' = _b[black];		  

		  
forvalues id = 1(1)`msanum' {;
replace Cb_`year' = _b[m_`id'] if m_`id' == 1;
replace gb_`year' = _b[mdist_`id'] if m_`id' ==1;
replace Cb_sd_`year' = _se[m_`id'] if m_`id' == 1;
replace gb_sd_`year' = _se[mdist_`id'] if m_`id' ==1;
};
};

drop m_1-m_`msanum';
drop mdist_1-mdist_`msanum';

save "$data_source\npts_Cb_`msanum'3", replace;

};


************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 240 {;

use "$data_source\npts_Cb_`msanum'3";

keep if rank_msa <= `msanum';

drop  msa_name pid whytrp90 urb peak l_mph_trip l_trpmiles l_trvl_min y_95 y_01 y_09;


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
	gen t = weight*trpmiles*(Cmsa + b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker + b_black_`year'*black +
	 b_hh_education_1_`year'*educ1 + b_hh_education_2_`year'*educ2 +
	 b_hh_income_1_`year'*income1 + b_hh_income_2_`year'*income2 +
         b_depart_1_`year'*start1 + b_depart_2_`year'*start2 + b_depart_3_`year'*start3 + b_depart_4_`year'*start4 + 
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
	gen t = weight*trpmiles*(CbUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + 	          
	 b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + 
	 b_hh_education_1US_`year'*educ1 + b_hh_education_2US_`year'*educ2 +
	 b_hh_income_1US_`year'*income1 + b_hh_income_2US_`year'*income2 +
	 b_depart_1US_`year'*start1 + b_depart_2US_`year'*start2 + b_depart_3US_`year'*start3 + 	
 	 b_depart_4US_`year'*start4 + 
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
	
	gen t = weight*trpmiles*(CbUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black +
	 b_hh_education_1US_`year'*educ1 + b_hh_education_2US_`year'*educ2 +
	 b_hh_income_1US_`year'*income1 + b_hh_income_2US_`year'*income2 +
	 b_depart_1US_`year'*start1 + b_depart_2US_`year'*start2 + b_depart_3US_`year'*start3 + 	
         b_depart_4US_`year'*start4 +	 
	 gbUS_`year'*ln(trpmiles));
	
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
	
	gen t = weight*trpmiles*(Cb_`year'+ b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker +  b_black_`year'*black + 
	 b_hh_education_1_`year'*educ1 + b_hh_education_2_`year'*educ2 +
	 b_hh_income_1_`year'*income1 + b_hh_income_2_`year'*income2 +
	 b_depart_1_`year'*start1 + b_depart_2_`year'*start2 + b_depart_3_`year'*start3 + b_depart_4_`year'*start4 + 
         gb_`year'*ln(trpmiles));
	
forvalues id = 1(1)`msanum' {; 
	quietly total t if (year ==`year' & rank_msa == `id');
	scalar St = _b[t];
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
		  Pb_95 Pb_01 Pb_09 l_Pb_95 l_Pb_01 l_Pb_09
		  Fb_95 Fb_01 Fb_09 l_Fb_95 l_Fb_01 l_Fb_09
          CbUS_95 CbUS_01 CbUS_09 gbUS_95 gbUS_01 gbUS_09 
		  Cb_95 Cb_01 Cb_09 gb_95 gb_01 gb_09
		  Cb_sd_95 Cb_sd_01 Cb_sd_09 gb_sd_95 gb_sd_01 gb_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_b_`msanum'3", replace;

};


};





*********************************************************************************************;
************** Regression 2d        *********************************************************;
*      OLS with controls for distance, its square and a more compact set of controls   ******;
*********************************************************************************************;


if 1==0 {;


************** Step 1: Supply curve estimation using OLS with controls *******************; 

* Decide how many msas to keep;
foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";

gen l_trpmiles2 = l_trpmiles*l_trpmiles;
 
keep if rank_msa <= `msanum';

local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";


*Centering the controls to make the constant comparables;
foreach variable of local controls {;
egen `variable'_a = mean(`variable');
gen `variable'_c = `variable' - `variable'_a;
drop `variable' `variable'_a;
rename `variable'_c `variable';

};

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

forvalues i = 1(1)2 {;
gen b_hh_income_`i'US_`year'  =. ;
};
forvalues i = 1(1)4 {;
gen b_depart_`i'US_`year'  =. ;
};
forvalues i = 1(1)2 {;
gen b_hh_education_`i'US_`year' =. ;
};
gen b_r_ageUS_`year' =. ; 
gen b_r_sexUS_`year' =. ; 
gen b_tdwkndUS_`year' =. ;
gen b_workerUS_`year' =.  ;
gen b_blackUS_`year' =.  ;
gen b_l_trpmilesUS_`year' =.  ;



reg l_p l_trpmiles l_trpmiles2 `controls' if year == `year', cl(msa) robust;
          
replace CbUS_`year' = _b[_cons];
replace gbUS_`year' = _b[l_trpmiles];
forvalues i = 1(1)2 {;
          replace b_hh_income_`i'US_`year'  = _b[income`i'] ;
};
forvalues i = 1(1)4 {;
          replace b_depart_`i'US_`year'  = _b[start`i'] ;
};
forvalues i = 1(1)2 {;
          replace b_hh_education_`i'US_`year'  = _b[educ`i'] ;
};
replace b_r_ageUS_`year' = _b[r_age];
replace b_r_sexUS_`year' = _b[r_sex];
replace b_tdwkndUS_`year' = _b[tdwknd];
replace b_workerUS_`year' = _b[worker];
replace b_blackUS_`year' = _b[black];
replace b_l_trpmilesUS_`year' = _b[l_trpmiles2];
};		  

*Now save values of msa-specific coefficient. I run only one regression per year (so coefficient
for controls is same for each msa, but slope and intercept of curve varies at msa-level);

foreach year in 95 01 09 {;


gen Cb_`year' = .;
gen gb_`year' = .;
gen Cb_sd_`year' = .;
gen gb_sd_`year' = .;

forvalues i = 1(1)2 {;
gen b_hh_income_`i'_`year'  =. ;
};
forvalues i = 1(1)2 {;
gen b_hh_education_`i'_`year' =. ;
};
forvalues i = 1(1)4 {;
gen b_depart_`i'_`year'  =. ;
};
gen b_r_age_`year' =. ; 
gen b_r_sex_`year' =. ; 
gen b_tdwknd_`year' =. ;
gen b_worker_`year' =.  ;

gen b_black_`year' =.  ;
gen b_l_trpmiles_`year' =.  ;


reg l_p m_1-m_`msanum' mdist_1-mdist_`msanum' l_trpmiles2 `controls' if year == `year', noconstant cl(msa) robust;

forvalues i = 1(1)2 {;
          replace b_hh_income_`i'_`year'  = _b[income`i'] ;
};
forvalues i = 1(1)4 {;
          replace b_depart_`i'_`year'  = _b[start`i'] ;
};
forvalues i = 1(1)2 {;
          replace b_hh_education_`i'_`year'  = _b[educ`i'] ;
};
replace b_r_age_`year' = _b[r_age];
replace b_r_sex_`year' = _b[r_sex];
replace b_tdwknd_`year' = _b[tdwknd];
replace b_worker_`year' = _b[worker];
replace b_black_`year' = _b[black];		  
replace b_l_trpmiles_`year' = _b[l_trpmiles2];
		  
forvalues id = 1(1)`msanum' {;
replace Cb_`year' = _b[m_`id'] if m_`id' == 1;
replace gb_`year' = _b[mdist_`id'] if m_`id' ==1;
replace Cb_sd_`year' = _se[m_`id'] if m_`id' == 1;
replace gb_sd_`year' = _se[mdist_`id'] if m_`id' ==1;
};
};

drop m_1-m_`msanum';
drop mdist_1-mdist_`msanum';

save "$data_source\npts_Cb_`msanum'4", replace;

};


************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 240 {;

use "$data_source\npts_Cb_`msanum'4";

keep if rank_msa <= `msanum';

drop  msa_name pid whytrp90 urb peak l_mph_trip l_trpmiles l_trvl_min y_95 y_01 y_09;


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
	gen t = weight*trpmiles*exp(Cmsa  + b_l_trpmiles_`year'*l_trpmiles2 + b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker + b_black_`year'*black +
	 b_hh_education_1_`year'*educ1 + b_hh_education_2_`year'*educ2 +
	 b_hh_income_1_`year'*income1 + b_hh_income_2_`year'*income2 +
         b_depart_1_`year'*start1 + b_depart_2_`year'*start2 + b_depart_3_`year'*start3 + b_depart_4_`year'*start4 + 
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
	gen t = weight*trpmiles*exp(CbUS_`year'+ b_l_trpmilesUS_`year'*l_trpmiles2+b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + 	          
	 b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + 
	 b_hh_education_1US_`year'*educ1 + b_hh_education_2US_`year'*educ2 +
	 b_hh_income_1US_`year'*income1 + b_hh_income_2US_`year'*income2 +
	 b_depart_1US_`year'*start1 + b_depart_2US_`year'*start2 + b_depart_3US_`year'*start3 + 	
 	 b_depart_4US_`year'*start4 + 
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
	
	gen t = weight*trpmiles*exp(CbUS_`year'+ b_l_trpmilesUS_`year'*l_trpmiles2+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black +
	 b_hh_education_1US_`year'*educ1 + b_hh_education_2US_`year'*educ2 +
	 b_hh_income_1US_`year'*income1 + b_hh_income_2US_`year'*income2 +
	 b_depart_1US_`year'*start1 + b_depart_2US_`year'*start2 + b_depart_3US_`year'*start3 + 	
         b_depart_4US_`year'*start4 +	 
	 gbUS_`year'*ln(trpmiles));
	
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
	
	gen t = weight*trpmiles*exp(Cb_`year'+ b_l_trpmiles_`year'*l_trpmiles2 + b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker +  b_black_`year'*black + 
	 b_hh_education_1_`year'*educ1 + b_hh_education_2_`year'*educ2 +
	 b_hh_income_1_`year'*income1 + b_hh_income_2_`year'*income2 +
	 b_depart_1_`year'*start1 + b_depart_2_`year'*start2 + b_depart_3_`year'*start3 + b_depart_4_`year'*start4 + 
         gb_`year'*ln(trpmiles));
	
forvalues id = 1(1)`msanum' {; 
	quietly total t if (year ==`year' & rank_msa == `id');
	scalar St = _b[t];
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
		  Pb_95 Pb_01 Pb_09 l_Pb_95 l_Pb_01 l_Pb_09
		  Fb_95 Fb_01 Fb_09 l_Fb_95 l_Fb_01 l_Fb_09
          CbUS_95 CbUS_01 CbUS_09 gbUS_95 gbUS_01 gbUS_09 
		  Cb_95 Cb_01 Cb_09 gb_95 gb_01 gb_09
		  Cb_sd_95 Cb_sd_01 Cb_sd_09 gb_sd_95 gb_sd_01 gb_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_b_`msanum'4", replace;

};


};



*********************************************************************************************;
************** Regression 2e        *********************************************************;
*      OLS with controls for distance, its square by city and a more compact set of controls   ******;
*********************************************************************************************;


if 1==0 {;

clear all;

set mem 5g;



************** Step 1: Supply curve estimation using OLS with controls *******************; 

* Decide how many msas to keep;
foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";

gen l_trpmiles2 = l_trpmiles*l_trpmiles;

 
keep if rank_msa <= `msanum';

local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";



*Centering the controls to make the constant comparables;
foreach variable of local controls {;
egen `variable'_a = mean(`variable');
gen `variable'_c = `variable' - `variable'_a;
drop `variable' `variable'_a;
rename `variable'_c `variable';

};


*interacted terms;
forvalues id = 1(1)`msanum' {;
gen m_`id' = 0;
replace m_`id' = 1 if rank_msa == `id';
};

forvalues id = 1(1)`msanum' {;
gen mdist_`id' = l_trpmiles*m_`id';
};

forvalues id = 1(1)`msanum' {;
gen mdist2_`id' = l_trpmiles2*m_`id';
};


* First, compute supply curves for the United States, for each year;
foreach year in 95 01 09 {;

*some variables to receive coefficient values;
gen CbUS_`year' = .;
gen gbUS_`year' = .;
gen gb2US_`year' = .;

forvalues i = 1(1)2 {;
gen b_hh_income_`i'US_`year'  =. ;
};
forvalues i = 1(1)4 {;
gen b_depart_`i'US_`year'  =. ;
};
forvalues i = 1(1)2 {;
gen b_hh_education_`i'US_`year' =. ;
};
gen b_r_ageUS_`year' =. ; 
gen b_r_sexUS_`year' =. ; 
gen b_tdwkndUS_`year' =. ;
gen b_workerUS_`year' =.  ;
gen b_blackUS_`year' =.  ;
gen b_l_trpmilesUS_`year' =.  ;



reg l_p l_trpmiles l_trpmiles2 `controls' if year == `year', cl(msa) robust;
          
replace CbUS_`year' = _b[_cons];
replace gbUS_`year' = _b[l_trpmiles];
replace gb2US_`year' = _b[l_trpmiles2];
forvalues i = 1(1)2 {;
          replace b_hh_income_`i'US_`year'  = _b[income`i'] ;
};
forvalues i = 1(1)4 {;
          replace b_depart_`i'US_`year'  = _b[start`i'] ;
};
forvalues i = 1(1)2 {;
          replace b_hh_education_`i'US_`year'  = _b[educ`i'] ;
};
replace b_r_ageUS_`year' = _b[r_age];
replace b_r_sexUS_`year' = _b[r_sex];
replace b_tdwkndUS_`year' = _b[tdwknd];
replace b_workerUS_`year' = _b[worker];
replace b_blackUS_`year' = _b[black];
replace b_l_trpmilesUS_`year' = _b[l_trpmiles2];
};		  

*Now save values of msa-specific coefficient. I run only one regression per year (so coefficient
for controls is same for each msa, but slope and intercept of curve varies at msa-level);

foreach year in 95 01 09 {;


gen Cb_`year' = .;
gen gb_`year' = .;

gen Cb_sd_`year' = .;
gen gb_sd_`year' = .;

gen gb2_`year' = .;
gen gb2_sd_`year' = .;

forvalues i = 1(1)2 {;
gen b_hh_income_`i'_`year'  =. ;
};
forvalues i = 1(1)2 {;
gen b_hh_education_`i'_`year' =. ;
};
forvalues i = 1(1)4 {;
gen b_depart_`i'_`year'  =. ;
};
gen b_r_age_`year' =. ; 
gen b_r_sex_`year' =. ; 
gen b_tdwknd_`year' =. ;
gen b_worker_`year' =.  ;

gen b_black_`year' =.  ;
gen b_l_trpmiles_`year' =.  ;


reg l_p m_1-m_`msanum' mdist_1-mdist_`msanum' mdist2_1-mdist2_`msanum' `controls' if year == `year', noconstant cl(msa) robust;

forvalues i = 1(1)2 {;
          replace b_hh_income_`i'_`year'  = _b[income`i'] ;
};
forvalues i = 1(1)4 {;
          replace b_depart_`i'_`year'  = _b[start`i'] ;
};
forvalues i = 1(1)2 {;
          replace b_hh_education_`i'_`year'  = _b[educ`i'] ;
};
replace b_r_age_`year' = _b[r_age];
replace b_r_sex_`year' = _b[r_sex];
replace b_tdwknd_`year' = _b[tdwknd];
replace b_worker_`year' = _b[worker];
replace b_black_`year' = _b[black];		  
		  
forvalues id = 1(1)`msanum' {;
replace Cb_`year' = _b[m_`id'] if m_`id' == 1;
replace gb_`year' = _b[mdist_`id'] if m_`id' ==1;
replace gb2_`year' = _b[mdist2_`id'] if m_`id' ==1;
replace Cb_sd_`year' = _se[m_`id'] if m_`id' == 1;
replace gb_sd_`year' = _se[mdist_`id'] if m_`id' ==1;
replace gb2_sd_`year' = _se[mdist2_`id'] if m_`id' ==1;
};
};

drop m_1-m_`msanum';
drop mdist_1-mdist_`msanum';
drop mdist2_1-mdist2_`msanum';

save "$data_source\npts_Cb_`msanum'5", replace;

};


************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 240 {;

use "$data_source\npts_Cb_`msanum'5";

keep if rank_msa <= `msanum';

drop  msa_name pid whytrp90 urb peak l_mph_trip l_trpmiles l_trvl_min y_95 y_01 y_09;


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
	quietly mean gb2_`year' if rank_msa == `id';
	scalar gmsa2 = _b[gb2_`year'];
	gen t = weight*trpmiles*exp(Cmsa  + b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker + b_black_`year'*black +
	 b_hh_education_1_`year'*educ1 + b_hh_education_2_`year'*educ2 +
	 b_hh_income_1_`year'*income1 + b_hh_income_2_`year'*income2 +
         b_depart_1_`year'*start1 + b_depart_2_`year'*start2 + b_depart_3_`year'*start3 + b_depart_4_`year'*start4 + 
	 gmsa*ln(trpmiles) + gmsa2*l_trpmiles2);
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
	gen t = weight*trpmiles*exp(CbUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + 	          
	 b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black + 
	 b_hh_education_1US_`year'*educ1 + b_hh_education_2US_`year'*educ2 +
	 b_hh_income_1US_`year'*income1 + b_hh_income_2US_`year'*income2 +
	 b_depart_1US_`year'*start1 + b_depart_2US_`year'*start2 + b_depart_3US_`year'*start3 + 	
 	 b_depart_4US_`year'*start4 + 
	 gbUS_`year'*ln(trpmiles) + gb2US_`year'*l_trpmiles2);
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
	 b_workerUS_`year'*worker + b_blackUS_`year'*black +
	 b_hh_education_1US_`year'*educ1 + b_hh_education_2US_`year'*educ2 +
	 b_hh_income_1US_`year'*income1 + b_hh_income_2US_`year'*income2 +
	 b_depart_1US_`year'*start1 + b_depart_2US_`year'*start2 + b_depart_3US_`year'*start3 + 	
         b_depart_4US_`year'*start4 +	 
	 gbUS_`year'*ln(trpmiles) + gb2US_`year'*l_trpmiles2);
	
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
	
	gen t = weight*trpmiles*exp(Cb_`year'+ b_r_age_`year'*r_age + b_r_sex_`year'*r_sex + b_tdwknd_`year'*tdwknd +
	 b_worker_`year'*worker +  b_black_`year'*black + 
	 b_hh_education_1_`year'*educ1 + b_hh_education_2_`year'*educ2 +
	 b_hh_income_1_`year'*income1 + b_hh_income_2_`year'*income2 +
	 b_depart_1_`year'*start1 + b_depart_2_`year'*start2 + b_depart_3_`year'*start3 + b_depart_4_`year'*start4 + 
         gb_`year'*ln(trpmiles) + gb2_`year'*l_trpmiles2);
	
forvalues id = 1(1)`msanum' {; 
	quietly total t if (year ==`year' & rank_msa == `id');
	scalar St = _b[t];
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
		  Pb_95 Pb_01 Pb_09 l_Pb_95 l_Pb_01 l_Pb_09
		  Fb_95 Fb_01 Fb_09 l_Fb_95 l_Fb_01 l_Fb_09
          CbUS_95 CbUS_01 CbUS_09 gbUS_95 gbUS_01 gbUS_09 
		  Cb_95 Cb_01 Cb_09 gb_95 gb_01 gb_09
		  Cb_sd_95 Cb_sd_01 Cb_sd_09 gb_sd_95 gb_sd_01 gb_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_b_`msanum'5", replace;

};



clear all;

set mem 3g;

};


*********************************************************************************************;
************** Regression 3        **********************************************************;
*      OLS with fixed effects     ***********************************************************;
*********************************************************************************************;

* IN TWO PARTS, first the regression, second the index;


if 1==0{;


foreach msanum in 50 100 240 {; *Pb with small MSAs which are not identified, hence only 240;

use "$data_source\working_npts.dta";
 
keep if rank_msa <= `msanum';


* First, compute supply curves for the United States, for each year;
  
foreach year in 95 01 09 {;
gen CcUS_`year' = .;
gen gcUS_`year' = .;
xtreg l_p l_trpmiles if year == `year', cl(msa) robust fe i(pid);
scalar cons = _b[_cons];
*predict x, u;
replace gcUS_`year' = _b[l_trpmiles];
replace CcUS_`year' = cons;
*drop x;
};

* Second, compute supply curves for each MSA, for each year;

foreach year in 95 01 09 {;
gen Cc_`year' = .;
gen gc_`year' = .;
gen Cc_sd_`year' = .;
gen gc_sd_`year' = .;
forvalues id = 1(1)`msanum' {;
xtreg l_p l_trpmiles if (year == `year' & rank_msa==`id'), robust fe i(pid);
replace Cc_`year' = _b[_cons] if rank_msa == `id';
replace gc_`year' = _b[l_trpmiles] if rank_msa == `id';
replace Cc_sd_`year' = _se[_cons] if rank_msa == `id';
replace gc_sd_`year' = _se[l_trpmiles] if rank_msa == `id';
};
};


save "$data_source\npts_Cc_`msanum'", replace;

};



};


*PART 2;

if 1==0{;

foreach msanum in 50 100 240 {;

use "$data_source\npts_Cc_`msanum'";

keep  CcUS_95 CcUS_01 CcUS_09 gcUS_95 gcUS_01 gcUS_09 Cc_95 Cc_01 Cc_09 gc_95 gc_01 gc_09 
      year msa mph_trip trpmiles rank_msa wtperfin Cc_sd_95 Cc_sd_01 Cc_sd_09 gc_sd_95 gc_sd_01 gc_sd_09;

*1) US trips at MSA price;
* GD: this calculation differs from that of VC but gives the same result. It is slower though.;
  
gen weight = wtperfin/1000;


foreach year in 95 01 09 {;

gen S1_`year' = .; 

forvalues id = 1(1)`msanum'{;


gen year1 = 0;
replace year1 = 1 if (`year'==year);

gen Cmsa0= Cc_`year' if (`year'==year & `id'==rank_msa);
egen Cmsa = max(Cmsa0);

gen gmsa0= gc_`year' if (`year'==year & `id'==rank_msa);
egen gmsa = max(gmsa0);

gen trip_cost`year'_`id' = weight*trpmiles*exp(Cmsa+gmsa*ln(trpmiles))*year1;

egen total`year'_`id'=total(trip_cost`year'_`id');

replace S1_`year' = total`year'_`id' if (`year'==year & `id'==rank_msa);

drop Cmsa0 gmsa0 Cmsa gmsa trip_cost`year'_`id' total`year'_`id' year1;

};
};


*2) US trips at US price;

gen CcUS =.;
gen gcUS =.;

foreach year in 95 01 09 {;
replace CcUS = CcUS_`year' if `year'==year;
replace gcUS = gcUS_`year' if `year'==year;
};

gen totUS = weight*trpmiles*exp(CcUS+gcUS*ln(trpmiles));
egen StotUS = total(totUS), by(year);

foreach year in 95 01 09 {;
gen S2_`year' =  .;
replace S2_`year' = StotUS if `year'==year;
};

* Generate Lcspeyres price indices and logs;

foreach year in 95 01 09 {;
gen Lc_`year' = S1_`year'/S2_`year';
gen l_Lc_`year' = ln(Lc_`year');
};

sort rank_msa;

sort msa;

collapse  (mean) Lc_95 Lc_01 Lc_09 l_Lc_95 l_Lc_01 l_Lc_09 
				CcUS_95 CcUS_01 CcUS_09 gcUS_95 gcUS_01 gcUS_09 
				Cc_95 Cc_01 Cc_09 gc_95 gc_01 gc_09 
				Cc_sd_95 Cc_sd_01 Cc_sd_09 gc_sd_95 gc_sd_01 gc_sd_09
				rank_msa, by(msa);


save "$output\npts_index_c_`msanum'", replace;
};

};



*********************************************************************************************;
************** Regression 3b        *********************************************************;
*      OLS with fixed effects and time dummies     ******************************************;
*********************************************************************************************;

* IN TWO PARTS, first the regression, second the index;


if 1==0{;


foreach msanum in 50 100 240 {; *Pb with small MSAs which are not identified, hence only 240;

use "$data_source\working_npts.dta";
 
keep if rank_msa <= `msanum';


* First, compute supply curves for the United States, for each year;
  
foreach year in 95 01 09 {;
gen CcUS_`year' = .;
gen gcUS_`year' = .;
forvalues i = 1(1)23 {;
gen b_depart_`i'US_`year'  =. ;
};


xtreg l_p l_trpmiles depart_1-depart_23 if year == `year', fe i(pid);
scalar cons = _b[_cons];
predict x, u;
replace gcUS_`year' = _b[l_trpmiles];
replace CcUS_`year' = cons;
forvalues i = 1(1)23 {;
replace b_depart_`i'US_`year'  = _b[depart_`i'] ;
};
drop x;
};
	

* Second, compute supply curves for each MSA, for each year;


foreach year in 95 01 09 {;
gen Cc_`year' = .;
gen gc_`year' = .;
gen Cc_sd_`year' = .;
gen gc_sd_`year' = .;

gen l_p_`year'= l_p - ( b_depart_1US_`year'*depart_1 + b_depart_2US_`year'*depart_2 + b_depart_3US_`year'*depart_3 + b_depart_4US_`year'*depart_4 + b_depart_5US_`year'*depart_5 + b_depart_6US_`year'*depart_6 + 		 	 b_depart_7US_`year'*depart_7 + b_depart_8US_`year'*depart_8 + b_depart_9US_`year'*depart_9 + 	 b_depart_10US_`year'*depart_10 + b_depart_11US_`year'*depart_11 + 
b_depart_12US_`year'*depart_12 + b_depart_13US_`year'*depart_13 + b_depart_14US_`year'*depart_14 +  
b_depart_15US_`year'*depart_15 + b_depart_16US_`year'*depart_16 + b_depart_17US_`year'*depart_17 +
b_depart_18US_`year'*depart_18 + b_depart_19US_`year'*depart_19 + b_depart_20US_`year'*depart_20 +
b_depart_21US_`year'*depart_21 + b_depart_22US_`year'*depart_22 + b_depart_23US_`year'*depart_23 );

forvalues id = 1(1)`msanum' {;
xtreg l_p l_trpmiles if (year == `year' & rank_msa==`id'), fe i(pid);
replace Cc_`year' = _b[_cons] if rank_msa == `id';
replace gc_`year' = _b[l_trpmiles] if rank_msa == `id';
replace Cc_sd_`year' = _se[_cons] if rank_msa == `id';
replace gc_sd_`year' = _se[l_trpmiles] if rank_msa == `id';
};
};


save "$data_source\npts_Cc_`msanum'2", replace;

};



};


*PART 2;

if 1==0{;

foreach msanum in 50 100 240 {;

use "$data_source\npts_Cc_`msanum'2";

keep  CcUS_95 CcUS_01 CcUS_09 gcUS_95 gcUS_01 gcUS_09 Cc_95 Cc_01 Cc_09 gc_95 gc_01 gc_09 
      year msa mph_trip trpmiles rank_msa wtperfin Cc_sd_95 Cc_sd_01 Cc_sd_09 gc_sd_95 gc_sd_01 gc_sd_09;

*1) US trips at MSA price;
* GD: this calculation differs from that of VC but gives the same result. It is slower though.;
  
gen weight = wtperfin/1000;


foreach year in 95 01 09 {;

gen S1_`year' = .; 

forvalues id = 1(1)`msanum'{;


gen year1 = 0;
replace year1 = 1 if (`year'==year);

gen Cmsa0= Cc_`year' if (`year'==year & `id'==rank_msa);
egen Cmsa = max(Cmsa0);

gen gmsa0= gc_`year' if (`year'==year & `id'==rank_msa);
egen gmsa = max(gmsa0);

gen trip_cost`year'_`id' = weight*trpmiles*exp(Cmsa+gmsa*ln(trpmiles))*year1;

egen total`year'_`id'=total(trip_cost`year'_`id');

replace S1_`year' = total`year'_`id' if (`year'==year & `id'==rank_msa);

drop Cmsa0 gmsa0 Cmsa gmsa trip_cost`year'_`id' total`year'_`id' year1;

};
};


*2) US trips at US price;

gen CcUS =.;
gen gcUS =.;

foreach year in 95 01 09 {;
replace CcUS = CcUS_`year' if `year'==year;
replace gcUS = gcUS_`year' if `year'==year;
};

gen totUS = weight*trpmiles*exp(CcUS+gcUS*ln(trpmiles));
egen StotUS = total(totUS), by(year);

foreach year in 95 01 09 {;
gen S2_`year' =  .;
replace S2_`year' = StotUS if `year'==year;
};

* Generate Lcspeyres price indices and logs;

foreach year in 95 01 09 {;
gen Lc_`year' = S1_`year'/S2_`year';
gen l_Lc_`year' = ln(Lc_`year');
};

sort rank_msa;

sort msa;

collapse  (mean) Lc_95 Lc_01 Lc_09 l_Lc_95 l_Lc_01 l_Lc_09 
				CcUS_95 CcUS_01 CcUS_09 gcUS_95 gcUS_01 gcUS_09 
				Cc_95 Cc_01 Cc_09 gc_95 gc_01 gc_09 
				Cc_sd_95 Cc_sd_01 Cc_sd_09 gc_sd_95 gc_sd_01 gc_sd_09
				rank_msa, by(msa);


save "$output\npts_index_c_`msanum'2", replace;
};

};



*********************************************************************************************;
************** Regression 4  MANUAL VERSION a    ********************************************;
*      IV distance in the same msa by trip purpose        ***********************************;
*********************************************************************************************;


* Manual IV;
* IT's IN TWO PARTS (REGRESSION THEN INDEX) AND FOLLOWED BY THE SAME THING WITH A MORE COMPACT SET OF CONTROLS AND A DIFFERENT TECHINIQUE USING ALSO THE COMPACT SET OF CONTROLS;

if 1==0{;



local controls = "hh_income_2-hh_income_18 hh_education_2-hh_education_5 r_age r_sex tdwknd depart_1-depart_23 worker month_2-month_12 black hispanic";

foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";
keep if rank_msa <= `msanum';


* First, compute supply curves for the United States, for each year;
foreach year in 95 01 09 {;

reg l_trpmiles inst_ownA `controls' if year==`year', cl(msa) robust;

* get the predicted values;		  
predict distUS_hat;

* create storage for the step 2 ceofficients;
gen CdUS_`year' = .;
gen gdUS_`year' = .;
forvalues i = 2(1)18 {;
gen b_hh_income_`i'US_`year'  =. ;
};

forvalues i = 1(1)23 {;
gen b_depart_`i'US_`year' =. ;
};
forvalues i = 2(1)5 {;
gen b_hh_education_`i'US_`year'  = . ;
};
gen b_r_ageUS_`year' =. ; 
gen b_r_sexUS_`year' =. ; 
gen b_tdwkndUS_`year' =. ;
gen b_workerUS_`year' =.  ;
gen b_blackUS_`year' =.  ;
forvalues i = 2(1)12 {;
gen b_month_`i'US_`year'  =. ;
};
gen b_hispanicUS_`year' =.  ;

reg l_p distUS_hat `controls' if year==`year', cl(msa) robust;

*store the coefficients of step 2;
forvalues i = 2(1)18 {;
replace b_hh_income_`i'US_`year'  = _b[hh_income_`i'] ;
};
forvalues i = 2(1)5 {;
replace b_hh_education_`i'US_`year'  = _b[hh_education_`i'] ;
};
replace b_r_ageUS_`year' = _b[r_age];
replace b_r_sexUS_`year' = _b[r_sex];
replace b_tdwkndUS_`year' = _b[tdwknd];
replace b_workerUS_`year' = _b[worker];
replace b_blackUS_`year' = _b[black];
replace b_hispanicUS_`year' = _b[hispanic];
forvalues i = 1(1)23 {;
replace b_depart_`i'US_`year'  = _b[depart_`i'] ;
};	
forvalues i = 2(1)12 {;
replace b_month_`i'US_`year'  = _b[month_`i'] ;
};
replace CdUS_`year' = _b[_cons];
replace gdUS_`year' = _b[distUS_hat];

drop distUS_hat;
};

*Now: first stage 1 of the regression for all MSAs;

*interacted terms;
forvalues id = 1(1)`msanum' {;
gen m_`id' = 0;
replace m_`id' = 1 if rank_msa == `id';
};

forvalues id = 1(1)`msanum' {;
gen inst_ownA_`id' = inst_ownA*m_`id';
};


foreach year in 95 01 09 {;
reg l_trpmiles m_1-m_`msanum' inst_ownA_1-inst_ownA_`msanum' `controls' if year==`year', noconstant cl(msa) robust;

* store the coefficients of step 1 as scalars;
forvalues i = 2(1)18 {;
scalar b1_hh_income_`i'  = _b[hh_income_`i'] ; 
};
forvalues i = 2(1)5 {;
scalar b1_hh_education_`i'  = _b[hh_education_`i'] ;
};
scalar b1_r_age = _b[r_age];
scalar b1_r_sex = _b[r_sex];
scalar b1_tdwknd = _b[tdwknd];
scalar b1_worker = _b[worker];
scalar b1_black = _b[black];
scalar b1_hispanic = _b[hispanic];
forvalues i = 2(1)12 {;
scalar b1_month_`i'  = _b[month_`i'] ;
};		  
forvalues i = 1(1)23 {;
scalar b1_depart_`i' = _b[depart_`i'] ;
};	

* get the predicted values by city;		  
predict dist_hat;

forvalues id = 1(1)`msanum' {;
gen mdist_`id' = dist_hat*m_`id';
};


* create storage for the step 2 ceofficients;
gen Cd_`year' = .;
gen gd_`year' = .;
gen Cd_sd_`year' = .;
gen gd_sd_`year' = .;
forvalues i = 2(1)18 {;
gen b_hh_income_`i'_`year'  =. ;
};
forvalues i = 1(1)23 {;
gen b_depart_`i'_`year' =. ;
};
forvalues i = 2(1)5 {;
gen b_hh_education_`i'_`year' =. ;
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

*keep `controls' l_p l_trpmiles inst_ownA* msa b_* obs_number  Cd* gd* md* m_* rank_msa; 

*compress;

*save "$data_source\temp", replace;

reg l_p m_1-m_`msanum' mdist_1-mdist_`msanum' `controls' if year==`year', noconstant cl(msa) robust;

*store the coefficients of step 2 both as variables and scalars;
forvalues i = 2(1)18 {;
replace b_hh_income_`i'_`year'  = _b[hh_income_`i'] ;
scalar b2_hh_income_`i'  = _b[hh_income_`i'] ; 
};
forvalues i = 2(1)5 {;
replace b_hh_education_`i'_`year'  = _b[hh_education_`i'] ;
scalar b2_hh_education_`i'  = _b[hh_education_`i'] ;
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
replace b_hispanic_`year' = _b[hispanic];
scalar b2_hispanic = _b[hispanic];
forvalues i = 2(1)12 {;
replace b_month_`i'_`year'  = _b[month_`i'] ;
scalar b2_month_`i'  = _b[month_`i'] ;
};
forvalues i = 1(1)23 {;
replace b_depart_`i'_`year'  = _b[depart_`i'] ;
scalar b2_depart_`i' = _b[depart_`i'];
};	
forvalues id = 1(1)`msanum' {;
replace Cd_`year' = _b[m_`id'] if m_`id' == 1;
replace gd_`year' = _b[mdist_`id'] if m_`id' ==1;
replace Cd_sd_`year' = _se[m_`id'] if m_`id' == 1;
replace gd_sd_`year' = _se[mdist_`id'] if m_`id' ==1;
};

drop mdist_1-mdist_`msanum' dist_hat ;


};

compress;


drop m_* inst_own*;

save "$data_source\npts_Cd_`msanum'", replace;
		  
};


};


*PART 2;

************** Step 2: Compute Price index from supply curve *****************************;

if 1==0{;

foreach msanum in 50 100 240 {;

use "$data_source\npts_Cd_`msanum'";

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

	quietly mean Cd_`year' if rank_msa == `id';
	scalar Cmsa = _b[Cd_`year'];
	quietly mean gd_`year' if rank_msa == `id';
	scalar gmsa = _b[gd_`year'];
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
	gen t = weight*trpmiles*exp(CdUS_`year'+ b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + 	          b_tdwkndUS_`year'*tdwknd +
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
collapse  (mean)  Ld_95 Ld_01 Ld_09 l_Ld_95 l_Ld_01 l_Ld_09
                  CdUS_95 CdUS_01 CdUS_09 gdUS_95 gdUS_01 gdUS_09 
				  Cd_95 Cd_01 Cd_09 gd_95 gd_01 gd_09				  
				  Cd_sd_95 Cd_sd_01 Cd_sd_09 gd_sd_95 gd_sd_01 gd_sd_09
                 rank_msa, by(msa);
sort msa;
	
save "$output\npts_index_d_`msanum'", replace;

};



};
	 
	 


*********************************************************************************************;
************** Regression 4  MANUAL VERSION b     *******************************************;
*      IV: distance in the same msa by trip purpose       ***********************************;
*********************************************************************************************;


* Manual IV with a more compact set of controls;

if 1==0{;


************** Step 1: Supply curve estimation using manual TSLS with controls *******************;

local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";

foreach msanum in 50 100 240 {; 

use "$data_source\working_npts.dta";
keep if rank_msa <= `msanum';

*Step1: first stage 1 of the regression;

*interacted terms;
forvalues id = 1(1)`msanum' {;
gen m_`id' = 0;
replace m_`id' = 1 if rank_msa == `id';
};

forvalues id = 1(1)`msanum' {;
gen inst_ownA_`id' = inst_ownA*m_`id';
};


* First, compute supply curves for the United States, for each year;
foreach year in 95 01 09 {;

reg l_trpmiles inst_ownA `controls' if year==`year', cl(msa) robust;

* get the predicted values;		  
predict distUS_hat;

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

reg l_p distUS_hat `controls' if year==`year', cl(msa) robust;

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
replace gdUS_`year' = _b[distUS_hat];

drop distUS_hat;
};


* Second, compute supply curves for each city, for each year;


foreach year in 95 01 09 {;

reg l_trpmiles m_1-m_`msanum' inst_ownA_1-inst_ownA_`msanum' `controls' if year==`year', noconstant cl(msa) robust;

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

reg l_p m_1-m_`msanum' mdist_1-mdist_`msanum' `controls' if year==`year', noconstant cl(msa) robust;

*store the coefficients of step 2;
forvalues i = 1(1)2 {;
replace b_income`i'_`year'  = _b[income`i'] ;
};
forvalues i = 1(1)2 {;
replace b_educ`i'_`year'  = _b[educ`i'] ;
};
replace b_r_age_`year' = _b[r_age];
replace b_r_sex_`year' = _b[r_sex];
replace b_tdwknd_`year' = _b[tdwknd];
replace b_worker_`year' = _b[worker];
replace b_black_`year' = _b[black];
forvalues i = 1(1)4 {;
replace b_start`i'_`year'  = _b[start`i'] ;
};	
forvalues id = 1(1)`msanum' {;
replace Cd_`year' = _b[m_`id'] if m_`id' == 1;
replace gd_`year' = _b[mdist_`id'] if m_`id' ==1;
replace Cd_sd_`year' = _se[m_`id'] if m_`id' == 1;
replace gd_sd_`year' = _se[mdist_`id'] if m_`id' ==1;};

drop mdist_*;
};

compress;

sort obs_number;

drop  m_* inst_own*;

save "$data_source\npts_Cd_`msanum'2", replace;

};		  


};


************** Step 2: Compute Price index from supply curve *****************************;

if 1==0{;


foreach msanum in 50 100 240 {;

use "$data_source\npts_Cd_`msanum'2";

keep if rank_msa <= `msanum';

drop  msa_name pid whytrp90 urb peak l_mph_trip l_trpmiles l_trvl_min y_95 y_01 y_09;


******************** 1) US trips at MSA price*********************************;

gen S1_95 = .;
gen S1_01 = .;
gen S1_09 = .;

gen weight = wtperfin/1000;
	
foreach year in 95 01 09 {;
forvalues id = 1(1)`msanum'{; 

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
collapse  (mean)  Ld_95 Ld_01 Ld_09 l_Ld_95 l_Ld_01 l_Ld_09
					CdUS_95 CdUS_01 CdUS_09 gdUS_95 gdUS_01 gdUS_09 
					Cd_95 Cd_01 Cd_09 gd_95 gd_01 gd_09
					Cd_sd_95 Cd_sd_01 Cd_sd_09 gd_sd_95 gd_sd_01 gd_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_d_`msanum'2", replace;

};


};



*********************************************************************************************;
************** Regression 4  MANUAL VERSION c  **********************************************;
*      IV distance in the same msa by trip purpose        ***********************************;
*********************************************************************************************;


* Manual IV with 2 estimations covering 3 regressions;

if 1==0{;



local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";
local controls2 = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker";
local controls3 = "income1 income2 educ1 start1 start2 start3 start4 r_age r_sex tdwknd";

foreach msanum in 50 100 /*240*/ {; 

use "$data_source\working_npts.dta";
keep if rank_msa <= `msanum';

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

keep `controls' l_p l_trpmiles trpmiles inst_ownA* msa b_* obs_number  Cd* gd* md* m_* rank_msa year wtp*; 

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
if (threshold<2 | (`id'==90 & `year'==95) | (`id'==92 & `year'==95)| (`id'==96 & `year'==95) |(`id'==97 & `year'==95) | (`id'==101 & `year'==95) | (`id'==111 & `year'==95)
| (`id'==119 & `year'==95) | (`id'==132 & `year'==95) | (`id'==66 & `year'==09) ){;
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

};

drop mdist_*;

compress;


};


save "$data_source\npts_Cd_`msanum'3", replace;

};




};



if 1==0{;

************** Step 2: Compute Price index from supply curve *****************************;

foreach msanum in 50 100 /*240*/ {;

use "$data_source\npts_Cd_`msanum'3";

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
collapse  (mean)  Ld_95 Ld_01 Ld_09 l_Ld_95 l_Ld_01 l_Ld_09
					CdUS_95 CdUS_01 CdUS_09 gdUS_95 gdUS_01 gdUS_09 
					Cd_95 Cd_01 Cd_09 gd_95 gd_01 gd_09
					Cd_sd_95 Cd_sd_01 Cd_sd_09 gd_sd_95 gd_sd_01 gd_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_d_`msanum'3", replace;

};


};



*********************************************************************************************;
************** Regression 4  MANUAL VERSION D  **********************************************;
*      IV distance in log in the same msa by trip purpose        ***********************************;
*********************************************************************************************;


* Manual IV with 2 estimations covering 3 regressions;

if 1==0{;



local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";
local controls2 = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker";
local controls3 = "income1 income2 educ1 start1 start2 start3 start4 r_age r_sex tdwknd";

foreach msanum in /*50*/ 100 /*240*/ {; 

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

keep `controls' l_p l_trpmiles trpmiles inst_ownA* msa b_* obs_number  Cd* gd* md* m_* rank_msa year w*; 

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
                  rank_msa, by(msa);
				 
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

save "$data_source\npts_Ce_`msanum'`z'", replace;

};




};

};



if 1==0{;


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
					Fe_95 Fe_01 Fe_09 l_Fe_95 l_Fe_01 l_Fe_09
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

foreach z in 1 2 3 4 {;
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

};
compress;
};

keep `controls' l_p l_trpmiles trpmiles inst* msa b_* obs_number  Cf* gf* rank_msa year wtperfin;

save "$data_source\npts_Cf_`msanum'`z'", replace;

};

};

clear all;

set memory 2g;

set matsize 1000;
};

if 1==0{;


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
					Cf_sd_95 Cf_sd_01 Cf_sd_09 gf_sd_95 gf_sd_01 gf_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_f_`msanum'`z'", replace;

};


};


};




*********************************************************************************************;
************** Regression 6  ALTERNATIVE WITH NO CONSTRAINT      ****************************;
*      IV: trip purpose  (based on regression 4C)    ****************************************;
*********************************************************************************************;


* Manual IV with 2 estimations covering 3 regressions;

if 1==0{;

clear all;

set memory 5g;

set matsize 10000;

set maxvar 10000;

foreach z in 5 6 7 8 {;
	if `z'==5{;
		local I "E";
		local v "e";		
			};
	if `z'==6{;
		local I "F";
		local v "f";		
			};
	if `z'==7{;
		local I "G";
		local v "g";		
			};
	if `z'==8{;
		local I "H";
		local v "h";		
			};


local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";


foreach msanum in 50 100 /*240*/ {; 

use "$data_source\working_npts.dta";

drop if (whytrp90 == 7 | whytrp90 == 11 );

sort msa;

keep if rank_msa <= `msanum';

drop hh* month* depart*  y_95 y_01 y_09 r_sex_95 r_sex_01 r_sex_09;

compress;

if `z'==5{; *whytrp90==10 (other recreational) is used as reference;
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


if `z'==6{;
*whytrp90==8 and whytrp90==10 (visit friends and other recreational) is used as reference;
local max = 3;
gen inst_1=0;
gen inst_2=0;
gen inst_3=0;

replace inst_1=1 if (whytrp90==1 | whytrp90==2);
replace inst_2=1 if (whytrp90==3 | whytrp90==4);
replace inst_3=1 if (whytrp90==5 | whytrp90==6);

};

if `z'==7{;
local max = 2;
gen inst_1=0;
gen inst_2=0;
replace inst_1=1 if (whytrp90==1 | whytrp90==2);
replace inst_2=1 if (whytrp90==3 | whytrp90==4 | whytrp90==5 | whytrp90==6);
drop if (whytrp90 == 8 | whytrp90 == 10);
};


if `z'==8{;
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

if (`z'>5 | (`z'==5 & `msanum'<240)) {; 

forvalues id = 1(1)`msanum' {;
forvalues inst = 1(1)`max' {;
gen inst_`inst'_`id' = inst_`inst'*m_`id';
};
};
};

* specific procedure when z=1 with 240 cities given the large number of variables;
if (`z'==5 & `msanum'==240) {; 

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



foreach year in 95 01 09 {;

* create storage for the step 2 coefficients;
gen Cf_`year' = .;
gen gf_`year' = .;
gen Cf_sd_`year' = .;
gen gf_sd_`year' = .;

gen l_p2 = l_p - b_income1US_`year'*income1 - b_income2US_`year'*income2 - b_start1US_`year'*start1 - b_start2US_`year'*start2 - b_start3US_`year'*start3 - b_start4US_`year'*start4 - b_educ1US_`year'*educ1 - b_educ2US_`year'*educ2 - b_r_ageUS_`year'*r_age - b_r_sexUS_`year'*r_sex - b_tdwkndUS_`year'*tdwknd - b_workerUS_`year'*worker - b_blackUS_`year'*black;

forvalues id = 1(1)`msanum' {;


ivreg2 l_p2 (l_trpmiles = inst_1-inst_`max') if (rank_msa==`id' & year==`year'), robust;

replace Cf_`year' = _b[_cons] if rank_msa==`id';
replace gf_`year' = _b[l_trpmiles] if rank_msa==`id';

replace Cf_sd_`year' = _se[_cons] if rank_msa==`id';
replace gf_sd_`year' = _se[l_trpmiles] if rank_msa==`id';

};

drop l_p2;

compress;
};

keep `controls' l_p l_trpmiles trpmiles inst* msa b_* obs_number  Cf* gf* rank_msa year wtperfin;

save "$data_source\npts_Cf_`msanum'`z'", replace;

};



};

clear all;

set memory 2g;

set matsize 1000;
};



if 1==0{;


foreach z in 5 6 7 8 {;
	if `z'==5{;
		local I "E";
		local v "e";		
			};
	if `z'==6{;
		local I "F";
		local v "f";		
			};
	if `z'==7{;
		local I "G";
		local v "g";		
			};
	if `z'==8{;
		local I "H";
		local v "h";		
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
	gen t = weight*trpmiles*exp(Cmsa + b_r_ageUS_`year'*r_age + b_r_sexUS_`year'*r_sex + b_tdwkndUS_`year'*tdwknd +
	 b_workerUS_`year'*worker + b_blackUS_`year'*black +
	 b_educ1US_`year'*educ1 + b_educ2US_`year'*educ2 +
	 b_income1US_`year'*income1 + b_income2US_`year'*income2 +
         b_start1US_`year'*start1 + b_start2US_`year'*start2 + b_start3US_`year'*start3 + b_start4US_`year'*start4 + 
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
					Cf_sd_95 Cf_sd_01 Cf_sd_09 gf_sd_95 gf_sd_01 gf_sd_09
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

if 1==0{;


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

compress;

* First, compute supply curves for the United States, for each year;
foreach year in 95 01 09 {;

* create storage for the step 2 ceofficients;
gen CgUS_`year' = .;
gen ggUS_`year' = .;

xtivreg l_p (l_trpmiles = l_purpinst) if year==`year', fe i(pid);;

*store the coefficients of step 2;
replace CgUS_`year' = _b[_cons];
replace ggUS_`year' = _b[l_trpmiles];
};


foreach year in 95 01 09 {;
gen Cg_`year' = .;
gen gg_`year' = .;
gen Cg_sd_`year' = .;
gen gg_sd_`year' = .;
forvalues id = 1(1)`msanum' {;
xtivreg l_p (l_trpmiles = l_purpinst) if (year == `year' & rank_msa==`id'), fe i(pid);
replace Cg_`year' = _b[_cons] if rank_msa == `id';
replace gg_`year' = _b[l_trpmiles] if rank_msa == `id';
replace Cg_sd_`year' = _se[_cons] if rank_msa == `id';
replace gg_sd_`year' = _se[l_trpmiles] if rank_msa == `id';
};

save "$data_source\temp", replace;

};


keep `controls' l_p l_trpmiles trpmiles l_purpinst* msa obs_number  Cg* gg* rank_msa year wtperfin;

save "$data_source\npts_Cg_`msanum'`z'", replace;

};




};

};



if 1==0{;


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
					Cg_sd_95 Cg_sd_01 Cg_sd_09 gg_sd_95 gg_sd_01 gg_sd_09
                  rank_msa, by(msa);
				 
sort msa;
	
save "$output\npts_index_g_`msanum'`z'", replace;

};


};


};





*********************************************************************************************;
************** Regression 8  ****************************************************************;
*      fixed effect and IV trip purpose     *************************************************;
*********************************************************************************************;

if 1==0{;

clear all;

set memory 5g;

set matsize 10000;

set maxvar 10000;

foreach z in 1 2 3 4 {;
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

if `z'==2{;*whytrp90==8 and whytrp90==10 (visit friends and other recreational) is used as reference;
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
gen ChUS_`year' = .;
gen ghUS_`year' = .;

xtivreg l_p (l_trpmiles = inst_1-inst_`max') if year==`year', fe i(pid);;

*store the coefficients of step 2;
replace ChUS_`year' = _b[_cons];
replace ghUS_`year' = _b[l_trpmiles];
};


foreach year in 95 01 09 {;
gen Ch_`year' = .;
gen gh_`year' = .;
gen Ch_sd_`year' = .;
gen gh_sd_`year' = .;
forvalues id = 1(1)`msanum' {;
xtivreg l_p (l_trpmiles = inst_1-inst_`max') if (year == `year' & rank_msa==`id'), fe i(pid);
replace Ch_`year' = _b[_cons] if rank_msa == `id';
replace gh_`year' = _b[l_trpmiles] if rank_msa == `id';
replace Ch_sd_`year' = _se[_cons] if rank_msa == `id';
replace gh_sd_`year' = _se[l_trpmiles] if rank_msa == `id';
};

save "$data_source\temp", replace;

};


keep `controls' l_p l_trpmiles trpmiles msa obs_number  Ch* gh* rank_msa year wtperfin;

save "$data_source\npts_Ch_`msanum'`z'", replace;




compress;

};


};

clear all;

set memory 2g;

set matsize 1000;
};

if 1==0{;


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


};

exit;


