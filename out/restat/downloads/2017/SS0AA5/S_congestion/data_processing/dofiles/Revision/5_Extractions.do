/********************************
extractions.do

GD June 2011, updated January 2016...

Extracts results from the main output files

*********************************/





**************  Start  ********************************************************;

*set up;
#delimit;
clear all;

set memory 2g;

set matsize 5000;
set more 1;
quietly capture log close;
cd;

global data_source  D:\S_congestion\data_processing\dofiles\Revision\output\ ;
global data_generated  D:\S_congestion\data_processing\data_generated\ ;
global results D:\S_congestion\data_processing\dofiles\Revision\tables\ ;


*********************************************************************************************;
**************                        SECTION 4        **************************************;
*********************************************************************************************;


*********************************************************************************************;
************** Table 3: means for 9 regressions        **************************************;
*********************************************************************************************;

* Also produces a merged data file of the C's and gamma's for all the estimations reported in that table;

if 1==1 {;

log using "$data_source\3table3", text replace;

use "$data_source\npts_index_a_100.dta";

replace Ca_09 = Ca_09+ln(60)+(1+ga_09)*ln(0.621371192);
replace Ca_01 = Ca_01+ln(60)+(1+ga_01)*ln(0.621371192);
replace Ca_95 = Ca_95+ln(60)+(1+ga_95)*ln(0.621371192);

sum  Ca_09 if rank <101;
sum  Ca_sd_09 if rank <101;

sum  ga_09 if rank <101;
sum  ga_sd_09 if rank <101;

sum  Ca_09 if rank <51;
sum  Ca_sd_09 if rank <51;

sum  ga_09 if rank <51;
sum  ga_sd_09 if rank <51;

sum  Ca_01 if rank <51;
sum  Ca_sd_01 if rank <51;

sum  ga_01 if rank <51;
sum  ga_sd_01 if rank <51;

sum  Ca_95 if rank <51;
sum  Ca_sd_95 if rank <51;

sum  ga_95 if rank <51;
sum  ga_sd_95 if rank <51;

sort rank_msa;

save "$data_source\temp_traffic.dta", replace;

use "$data_source\npts_index_b_100.dta";

replace Cb_09 = Cb_09+ln(60)+(1+gb_09)*ln(0.621371192);
replace Cb_01 = Cb_01+ln(60)+(1+gb_01)*ln(0.621371192);
replace Cb_95 = Cb_95+ln(60)+(1+gb_95)*ln(0.621371192);

sum  Cb_09 if rank <101;
sum  Cb_sd_09 if rank <101;

sum  gb_09 if rank <101;
sum  gb_sd_09 if rank <101;

sum  Cb_09 if rank <51;
sum  Cb_sd_09 if rank <51;

sum  gb_09 if rank <51;
sum  gb_sd_09 if rank <51;

sum  Cb_01 if rank <51;
sum  Cb_sd_01 if rank <51;

sum  gb_01 if rank <51;
sum  gb_sd_01 if rank <51;

sum  Cb_95 if rank <51;
sum  Cb_sd_95 if rank <51;

sum  gb_95 if rank <51;
sum  gb_sd_95 if rank <51;

sort rank_msa;

merge rank_msa using "$data_source\temp_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp_traffic.dta", replace;






use "$data_source\npts_index_b_1002.dta";


replace Cb_09 = Cb_09+ln(60)+(1+gb_09)*ln(0.621371192);
replace Cb_01 = Cb_01+ln(60)+(1+gb_01)*ln(0.621371192);
replace Cb_95 = Cb_95+ln(60)+(1+gb_95)*ln(0.621371192);

sum  Cb_09 if rank <101;
sum  Cb_sd_09 if rank <101;

sum  gb_09 if rank <101;
sum  gb_sd_09 if rank <101;

sum  Cb_09 if rank <51;
sum  Cb_sd_09 if rank <51;

sum  gb_09 if rank <51;
sum  gb_sd_09 if rank <51;

sum  Cb_01 if rank <51;
sum  Cb_sd_01 if rank <51;

sum  gb_01 if rank <51;
sum  gb_sd_01 if rank <51;

sum  Cb_95 if rank <51;
sum  Cb_sd_95 if rank <51;

sum  gb_95 if rank <51;
sum  gb_sd_95 if rank <51;

rename Cb_09 Cb_09B;
rename Cb_01 Cb_01B;
rename Cb_95 Cb_95B;

rename gb_09 gb_09B;
rename gb_01 gb_01B;
rename gb_95 gb_95B;

sort rank_msa;

merge rank_msa using "$data_source\temp_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp_traffic.dta", replace;

use "$data_source\npts_index_c_100.dta";

replace Cc_09 = Cc_09+ln(60)+(1+gc_09)*ln(0.621371192);
replace Cc_01 = Cc_01+ln(60)+(1+gc_01)*ln(0.621371192);
replace Cc_95 = Cc_95+ln(60)+(1+gc_95)*ln(0.621371192);

sum  Cc_09 if rank <101;
sum  Cc_sd_09 if rank <101;

sum  gc_09 if rank <101;
sum  gc_sd_09 if rank <101;

sum  Cc_09 if rank <51;
sum  Cc_sd_09 if rank <51;

sum  gc_09 if rank <51;
sum  gc_sd_09 if rank <51;

sum  Cc_01 if rank <51;
sum  Cc_sd_01 if rank <51;

sum  gc_01 if rank <51;
sum  gc_sd_01 if rank <51;

sum  Cc_95 if rank <51;
sum  Cc_sd_95 if rank <51;

sum  gc_95 if rank <51;
sum  gc_sd_95 if rank <51;

sort rank_msa;

merge rank_msa using "$data_source\temp_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp_traffic.dta", replace;

use "$data_source\npts_index_d_1004.dta";

replace Cd_09 = Cd_09+ln(60)+(1+gd_09)*ln(0.621371192);
replace Cd_01 = Cd_01+ln(60)+(1+gd_01)*ln(0.621371192);
replace Cd_95 = Cd_95+ln(60)+(1+gd_95)*ln(0.621371192);

sum  Cd_09 if rank <101;
sum  Cd_sd_09 if rank <101;

sum  gd_09 if rank <101;
sum  gd_sd_09 if rank <101;

sum  Cd_09 if rank <51;
sum  Cd_sd_09 if rank <51;

sum  gd_09 if rank <51;
sum  gd_sd_09 if rank <51;

sum  Cd_01 if rank <51;
sum  Cd_sd_01 if rank <51;

sum  gd_01 if rank <51;
sum  gd_sd_01 if rank <51;

sum  Cd_95 if rank <51;
sum  Cd_sd_95 if rank <51;

sum  gd_95 if rank <51;
sum  gd_sd_95 if rank <51;

sort rank_msa;

merge rank_msa using "$data_source\temp_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp_traffic.dta", replace;

use "$data_source\npts_index_e_1002.dta";

replace Ce_09 = Ce_09+ln(60)+(1+ge_09)*ln(0.621371192);
replace Ce_01 = Ce_01+ln(60)+(1+ge_01)*ln(0.621371192);
replace Ce_95 = Ce_95+ln(60)+(1+ge_95)*ln(0.621371192);

sum  Ce_09 if rank <101;
sum  Ce_sd_09 if rank <101;

sum  ge_09 if rank <101;
sum  ge_sd_09 if rank <101;

sum  Ce_09 if rank <51;
sum  Ce_sd_09 if rank <51;

sum  ge_09 if rank <51;
sum  ge_sd_09 if rank <51;

sum  Ce_01 if rank <51;
sum  Ce_sd_01 if rank <51;

sum  ge_01 if rank <51;
sum  ge_sd_01 if rank <51;

sum  Ce_95 if rank <51;
sum  Ce_sd_95 if rank <51;

sum  ge_95 if rank <51;
sum  ge_sd_95 if rank <51;

sort rank_msa;

merge rank_msa using "$data_source\temp_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp_traffic.dta", replace;

use "$data_source\npts_index_f_1001.dta";

replace Cf_09 = Cf_09+ln(60)+(1+gf_09)*ln(0.621371192);
replace Cf_01 = Cf_01+ln(60)+(1+gf_01)*ln(0.621371192);
replace Cf_95 = Cf_95+ln(60)+(1+gf_95)*ln(0.621371192);

sum  Cf_09 if rank <101;
sum  Cf_sd_09 if rank <101;

sum  gf_09 if rank <101;
sum  gf_sd_09 if rank <101;

sum  Cf_09 if rank <51;
sum  Cf_sd_09 if rank <51;

sum  gf_09 if rank <51;
sum  gf_sd_09 if rank <51;

sum  Cf_01 if rank <51;
sum  Cf_sd_01 if rank <51;

sum  gf_01 if rank <51;
sum  gf_sd_01 if rank <51;

sum  Cf_95 if rank <51;
sum  Cf_sd_95 if rank <51;

sum  gf_95 if rank <51;
sum  gf_sd_95 if rank <51;

sort rank_msa;

merge rank_msa using "$data_source\temp_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp_traffic.dta", replace;

use "$data_source\npts_index_f_1003.dta";

replace Cf_09 = Cf_09+ln(60)+(1+gf_09)*ln(0.621371192);
replace Cf_01 = Cf_01+ln(60)+(1+gf_01)*ln(0.621371192);
replace Cf_95 = Cf_95+ln(60)+(1+gf_95)*ln(0.621371192);

sum  Cf_09 if rank <101;
sum  Cf_sd_09 if rank <101;

sum  gf_09 if rank <101;
sum  gf_sd_09 if rank <101;

sum  Cf_09 if rank <51;
sum  Cf_sd_09 if rank <51;

sum  gf_09 if rank <51;
sum  gf_sd_09 if rank <51;

sum  Cf_01 if rank <51;
sum  Cf_sd_01 if rank <51;

sum  gf_01 if rank <51;
sum  gf_sd_01 if rank <51;

sum  Cf_95 if rank <51;
sum  Cf_sd_95 if rank <51;
sum  gf_95 if rank <51;
sum  gf_sd_95 if rank <51;

rename Cf_09 Cf_09C;
rename Cf_01 Cf_01C;
rename Cf_95 Cf_95C;

rename gf_09 gf_09C;
rename gf_01 gf_01C;
rename gf_95 gf_95C;

sort rank_msa;

merge rank_msa using "$data_source\temp_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp_traffic.dta", replace;

use "$data_source\npts_index_g_1002.dta";

replace Cg_09 = Cg_09+ln(60)+(1+gg_09)*ln(0.621371192);
replace Cg_01 = Cg_01+ln(60)+(1+gg_01)*ln(0.621371192);
replace Cg_95 = Cg_95+ln(60)+(1+gg_95)*ln(0.621371192);

sum  Cg_09 if rank <101;
sum  Cg_sd_09 if rank <101;

sum  gg_09 if rank <101;
sum  gg_sd_09 if rank <101;

sum  Cg_09 if rank <51;
sum  Cg_sd_09 if rank <51;

sum  gg_09 if rank <51;
sum  gg_sd_09 if rank <51;

sum  Cg_01 if rank <51;
sum  Cg_sd_01 if rank <51;

sum  gg_01 if rank <51;
sum  gg_sd_01 if rank <51;

sum  Cg_95 if rank <51;
sum  Cg_sd_95 if rank <51;

sum  gg_95 if rank <51;
sum  gg_sd_95 if rank <51;

sort rank_msa;



merge rank_msa using "$data_source\temp_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp_traffic.dta", replace;




*use "$data_generated\working_msa.dta";

sort rank_msa;

save "$data_generated\temp_npts_msa.dta", replace;


use "$data_source\temp_traffic.dta";

sort rank_msa;


merge rank_msa using "$data_generated\temp_npts_msa.dta";

drop _merge;

save "$data_source\temp_traffic.dta", replace;

erase "$data_generated\temp_npts_msa.dta";


log close;

};







*********************************************************************************************;
************** Appendix Table: means for 8 further regressions              *****************;
*********************************************************************************************;


if 1==1 {;

log using "$data_source\4table4", text replace;

*OLS with controls censoring the top and bottom quartiles;
use "$data_source\npts_index_b_1006.dta";

replace Cb_09 = Cb_09+ln(60)+(1+gb_09)*ln(0.621371192);
replace Cb_01 = Cb_01+ln(60)+(1+gb_01)*ln(0.621371192);
replace Cb_95 = Cb_95+ln(60)+(1+gb_95)*ln(0.621371192);

sum  Cb_09 if rank <101;
sum  Cb_sd_09 if rank <101;

sum  gb_09 if rank <101;
sum  gb_sd_09 if rank <101;

sum  Cb_09 if rank <51;
sum  Cb_sd_09 if rank <51;

sum  gb_09 if rank <51;
sum  gb_sd_09 if rank <51;

sum  Cb_01 if rank <51;
sum  Cb_sd_01 if rank <51;

sum  gb_01 if rank <51;
sum  gb_sd_01 if rank <51;

sum  Cb_95 if rank <51;
sum  Cb_sd_95 if rank <51;

sum  gb_95 if rank <51;
sum  gb_sd_95 if rank <51;

rename Cb_09 Cb_09F;
rename Cb_01 Cb_01F;
rename Cb_95 Cb_95F;

rename gb_09 gb_09F;
rename gb_01 gb_01F;
rename gb_95 gb_95F;

sort rank_msa;

save "$data_source\temp2_traffic.dta", replace;


*IV with controls censoring the top and bottom quartiles;
use "$data_source\npts_index_e_1005.dta";


replace Ce_09 = Ce_09+ln(60)+(1+ge_09)*ln(0.621371192);
replace Ce_01 = Ce_01+ln(60)+(1+ge_01)*ln(0.621371192);
replace Ce_95 = Ce_95+ln(60)+(1+ge_95)*ln(0.621371192);

sum  Ce_09 if rank <101;
sum  Ce_sd_09 if rank <101;

sum  ge_09 if rank <101;
sum  ge_sd_09 if rank <101;

sum  Ce_09 if rank <51;
sum  Ce_sd_09 if rank <51;

sum  ge_09 if rank <51;
sum  ge_sd_09 if rank <51;

sum  Ce_01 if rank <51;
sum  Ce_sd_01 if rank <51;

sum  ge_01 if rank <51;
sum  ge_sd_01 if rank <51;

sum  Ce_95 if rank <51;
sum  Ce_sd_95 if rank <51;

sum  ge_95 if rank <51;
sum  ge_sd_95 if rank <51;

rename Ce_09 Ce_09E;
rename Ce_01 Ce_01E;
rename Ce_95 Ce_95E;

rename ge_09 ge_09E;
rename ge_01 ge_01E;
rename ge_95 ge_95E;

sort rank_msa;

merge rank_msa using "$data_source\temp2_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp2_traffic.dta", replace;

*OLS with controls censoring non peak hour;
use "$data_source\npts_index_b_1007.dta";


replace Cb_09 = Cb_09+ln(60)+(1+gb_09)*ln(0.621371192);
replace Cb_01 = Cb_01+ln(60)+(1+gb_01)*ln(0.621371192);
replace Cb_95 = Cb_95+ln(60)+(1+gb_95)*ln(0.621371192);

sum  Cb_09 if rank <101;
sum  Cb_sd_09 if rank <101;

sum  gb_09 if rank <101;
sum  gb_sd_09 if rank <101;

sum  Cb_09 if rank <51;
sum  Cb_sd_09 if rank <51;

sum  gb_09 if rank <51;
sum  gb_sd_09 if rank <51;

sum  Cb_01 if rank <51;
sum  Cb_sd_01 if rank <51;

sum  gb_01 if rank <51;
sum  gb_sd_01 if rank <51;

sum  Cb_95 if rank <51;
sum  Cb_sd_95 if rank <51;

sum  gb_95 if rank <51;
sum  gb_sd_95 if rank <51;

rename Cb_09 Cb_09G;
rename Cb_01 Cb_01G;
rename Cb_95 Cb_95G;

rename gb_09 gb_09G;
rename gb_01 gb_01G;
rename gb_95 gb_95G;

sort rank_msa;

merge rank_msa using "$data_source\temp2_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp2_traffic.dta", replace;


*IV with controls censoring non peak hour;
use "$data_source\npts_index_e_1006.dta";


replace Ce_09 = Ce_09+ln(60)+(1+ge_09)*ln(0.621371192);
replace Ce_01 = Ce_01+ln(60)+(1+ge_01)*ln(0.621371192);
replace Ce_95 = Ce_95+ln(60)+(1+ge_95)*ln(0.621371192);

sum  Ce_09 if rank <101;
sum  Ce_sd_09 if rank <101;

sum  ge_09 if rank <101;
sum  ge_sd_09 if rank <101;

sum  Ce_09 if rank <51;
sum  Ce_sd_09 if rank <51;

sum  ge_09 if rank <51;
sum  ge_sd_09 if rank <51;

sum  Ce_01 if rank <51;
sum  Ce_sd_01 if rank <51;

sum  ge_01 if rank <51;
sum  ge_sd_01 if rank <51;

sum  Ce_95 if rank <51;
sum  Ce_sd_95 if rank <51;

sum  ge_95 if rank <51;
sum  ge_sd_95 if rank <51;

rename Ce_09 Ce_09F;
rename Ce_01 Ce_01F;
rename Ce_95 Ce_95F;

rename ge_09 ge_09F;
rename ge_01 ge_01F;
rename ge_95 ge_95F;

sort rank_msa;

merge rank_msa using "$data_source\temp2_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp2_traffic.dta", replace;

*OLS with controls keeping only commutes and work related trips;
use "$data_source\npts_index_b_1008.dta";


replace Cb_09 = Cb_09+ln(60)+(1+gb_09)*ln(0.621371192);
replace Cb_01 = Cb_01+ln(60)+(1+gb_01)*ln(0.621371192);
replace Cb_95 = Cb_95+ln(60)+(1+gb_95)*ln(0.621371192);

sum  Cb_09 if rank <101;
sum  Cb_sd_09 if rank <101;

sum  gb_09 if rank <101;
sum  gb_sd_09 if rank <101;

sum  Cb_09 if rank <51;
sum  Cb_sd_09 if rank <51;

sum  gb_09 if rank <51;
sum  gb_sd_09 if rank <51;

sum  Cb_01 if rank <51;
sum  Cb_sd_01 if rank <51;

sum  gb_01 if rank <51;
sum  gb_sd_01 if rank <51;

sum  Cb_95 if rank <51;
sum  Cb_sd_95 if rank <51;

sum  gb_95 if rank <51;
sum  gb_sd_95 if rank <51;

rename Cb_09 Cb_09H;
rename Cb_01 Cb_01H;
rename Cb_95 Cb_95H;

rename gb_09 gb_09H;
rename gb_01 gb_01H;
rename gb_95 gb_95H;

sort rank_msa;

merge rank_msa using "$data_source\temp2_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp2_traffic.dta", replace;



*IV with controls keeping only commutes and work related trips;
use "$data_source\npts_index_e_507.dta";


replace Ce_09 = Ce_09+ln(60)+(1+ge_09)*ln(0.621371192);
replace Ce_01 = Ce_01+ln(60)+(1+ge_01)*ln(0.621371192);
replace Ce_95 = Ce_95+ln(60)+(1+ge_95)*ln(0.621371192);

sum  Ce_09 if rank <101;
sum  Ce_sd_09 if rank <101;

sum  ge_09 if rank <101;
sum  ge_sd_09 if rank <101;

sum  Ce_09 if rank <51;
sum  Ce_sd_09 if rank <51;

sum  ge_09 if rank <51;
sum  ge_sd_09 if rank <51;

sum  Ce_01 if rank <51;
sum  Ce_sd_01 if rank <51;

sum  ge_01 if rank <51;
sum  ge_sd_01 if rank <51;

sum  Ce_95 if rank <51;
sum  Ce_sd_95 if rank <51;

sum  ge_95 if rank <51;
sum  ge_sd_95 if rank <51;

rename Ce_09 Ce_09G;
rename Ce_01 Ce_01G;
rename Ce_95 Ce_95F;

rename ge_09 ge_09G;
rename ge_01 ge_01G;
rename ge_95 ge_95G;

sort rank_msa;

merge rank_msa using "$data_source\temp2_traffic.dta";

drop _merge;

sort rank_msa;

save "$data_source\temp2_traffic.dta", replace;

*use "$data_generated\working_msa.dta";

sort rank_msa;

save "$data_generated\temp2_npts_msa.dta", replace;


use "$data_source\temp2_traffic.dta";

sort rank_msa;


merge rank_msa using "$data_generated\temp2_npts_msa.dta";

drop _merge;

save "$data_source\temp2_traffic.dta", replace;

erase "$data_generated\temp2_npts_msa.dta";


*OLS pmsa with controls;
use "$data_source\npts_index_b_p1002.dta";


replace Cb_09 = Cb_09+ln(60)+(1+gb_09)*ln(0.621371192);
*replace Cb_01 = Cb_01+ln(60)+(1+gb_01)*ln(0.621371192);
*replace Cb_95 = Cb_95+ln(60)+(1+gb_95)*ln(0.621371192);

sum  Cb_09 if rank <101;
sum  Cb_sd_09 if rank <101;

sum  gb_09 if rank <101;
sum  gb_sd_09 if rank <101;

sum  Cb_09 if rank <51;
sum  Cb_sd_09 if rank <51;

sum  gb_09 if rank <51;
sum  gb_sd_09 if rank <51;

save "$data_source\temp3_traffic.dta", replace;

*IV pmsa with controls ;
use "$data_source\npts_index_e_p1002.dta";


replace Ce_09 = Ce_09+ln(60)+(1+ge_09)*ln(0.621371192);

sum  Ce_09 if rank <101;
sum  Ce_sd_09 if rank <101;

sum  ge_09 if rank <101;
sum  ge_sd_09 if rank <101;

sum  Ce_09 if rank <51;
sum  Ce_sd_09 if rank <51;

sum  ge_09 if rank <51;
sum  ge_sd_09 if rank <51;

log close;

};











*********************************************************************************************;
************** Extra results for sections 4.1          **************************************;
*********************************************************************************************;


* Part 1: Computation of R2 reported in section 4.1;

if 1==1{;


clear;

use "$data_generated\working_npts.dta";

local controls = "income1 income2 educ1 educ2 start1 start2 start3 start4 r_age r_sex tdwknd worker black";

local controls2 = "hh_income_2-hh_income_18 hh_education_2-hh_education_5 r_age r_sex tdwknd depart_1-depart_23 worker month_2-month_12 black hispanic";

rename rank_msa rank;

*interacted terms;
forvalues id = 1(1)100 {;
gen m_`id' = 0;
replace m_`id' = 1 if rank == `id';
};

forvalues id = 1(1)100 {;
gen mdist_`id' = l_trpmiles*m_`id';
};


reg l_p m_1-m_100 mdist_1-mdist_100 if (rank <101 & year == 09), cl(msa) robust;

reg l_p l_trpmiles m_1-m_100 mdist_1-mdist_100 `controls' if (rank <101 & year == 09), cl(msa) robust;

reg l_p l_trpmiles m_1-m_100 mdist_1-mdist_100 `controls2' if (rank <101 & year == 09), cl(msa) robust;


};



* Part 2: correlations between the Cs and gammas across estimations. Only a small number of them are reported. More is reported in section 4.2 with correlations across indices;

if 1==1{;
clear;
use "$data_source\temp_index.dta";
sort rank_msa;

save "$data_source\temp_index.dta", replace;

use "$data_source\temp_traffic.dta";
sort rank_msa;

merge rank_msa using "$data_source\temp_index.dta";


display "09, 100 cities";

reg Ca_09 l_pop_09 if rank <101;
reg ga_09 l_pop_09 if rank <101;

reg Cb_09 l_pop_09 if rank <101;
reg gb_09 l_pop_09 if rank <101;

reg Cb_09B l_pop_09 if rank <101;
reg gb_09B l_pop_09 if rank <101;

reg Cc_09 l_pop_09 if rank <101;
reg gc_09 l_pop_09 if rank <101;

reg Cd_09 l_pop_09 if rank <101;
reg gd_09 l_pop_09 if rank <101;

reg Ce_09 l_pop_09 if rank <101;
reg ge_09 l_pop_09 if rank <101;

reg Cf_09 l_pop_09 if rank <101;
reg gf_09 l_pop_09 if rank <101;

reg Cf_09C l_pop_09 if rank <101;
reg gf_09C l_pop_09 if rank <101;

reg Cg_09 l_pop_09 if rank <101;
reg gg_09 l_pop_09 if rank <101;

display "09, 50 cities";

reg Ca_09 l_pop_09 if rank <51;
reg ga_09 l_pop_09 if rank <51;

reg Cb_09 l_pop_09 if rank <51;
reg gb_09 l_pop_09 if rank <51;

reg Cb_09B l_pop_09 if rank <51;
reg gb_09B l_pop_09 if rank <51;

reg Cc_09 l_pop_09 if rank <51;
reg gc_09 l_pop_09 if rank <51;

reg Cd_09 l_pop_09 if rank <51;
reg gd_09 l_pop_09 if rank <51;

reg Ce_09 l_pop_09 if rank <51;
reg ge_09 l_pop_09 if rank <51;

reg Cf_09 l_pop_09 if rank <51;
reg gf_09 l_pop_09 if rank <51;

reg Cf_09C l_pop_09 if rank <51;
reg gf_09C l_pop_09 if rank <51;

reg Cg_09 l_pop_09 if rank <51;
reg gg_09 l_pop_09 if rank <51;

display "01, 50 cities";

reg Ca_01 l_pop_01 if rank <51;
reg ga_01 l_pop_01 if rank <51;

reg Cb_01 l_pop_01 if rank <51;
reg gb_01 l_pop_01 if rank <51;

reg Cb_01B l_pop_01 if rank <51;
reg gb_01B l_pop_01 if rank <51;

reg Cc_01 l_pop_01 if rank <51;
reg gc_01 l_pop_01 if rank <51;

reg Cd_01 l_pop_01 if rank <51;
reg gd_01 l_pop_01 if rank <51;

reg Ce_01 l_pop_01 if rank <51;
reg ge_01 l_pop_01 if rank <51;

reg Cf_01 l_pop_01 if rank <51;
reg gf_01 l_pop_01 if rank <51;

reg Cf_01C l_pop_01 if rank <51;
reg gf_01C l_pop_01 if rank <51;

reg Cg_01 l_pop_01 if rank <51;
reg gg_01 l_pop_01 if rank <51;

display "95, 50 cities";

reg Ca_95 l_pop_95 if rank <51;
reg ga_95 l_pop_95 if rank <51;

reg Cb_95 l_pop_95 if rank <51;
reg gb_95 l_pop_95 if rank <51;

reg Cb_95B l_pop_95 if rank <51;
reg gb_95B l_pop_95 if rank <51;

reg Cc_95 l_pop_95 if rank <51;
reg gc_95 l_pop_95 if rank <51;

reg Cd_95 l_pop_95 if rank <51;
reg gd_95 l_pop_95 if rank <51;

reg Ce_95 l_pop_95 if rank <51;
reg ge_95 l_pop_95 if rank <51;

reg Cf_95 l_pop_95 if rank <51;
reg gf_95 l_pop_95 if rank <51;

reg Cf_95C l_pop_95 if rank <51;
reg gf_95C l_pop_95 if rank <51;

reg Cg_95 l_pop_95 if rank <51;
reg gg_95 l_pop_95 if rank <51;

};







*********************************************************************************************;
**************         Table 4 of section 4.2          **************************************;
*********************************************************************************************;

if 1==1{;

clear;

use "$data_source\temp_index.dta";

*The file temp_index.dta is produced by comparisons.do which aggregates all the indices for all the estimations;

keep  msa_name msa Le_09_100B Le_09_50B Le_01_50B Le_95_50B Le_95_100B Le_01_100B rank_msa l_pop_*;

egen rank_s = rank(Le_09_50B);

gen rank_09_50 = 51 - rank_s;

drop rank_s;

egen rank_s = rank(Le_01_50B);

gen rank_01_50 = 51 - rank_s;

drop rank_s;

egen rank_s = rank(Le_95_50B);

gen rank_95_50 = 51 - rank_s;

drop rank_s;

order msa_name Le_09_50B rank_09_50 Le_01_50B rank_01_50 Le_95_50B rank_95_50 rank_msa;

sort rank_09_50;

spearman  rank_09_50 rank_01_50 rank_95_50;

gen Dl_pop09_95 = l_pop_09 - l_pop_95;

gen Dl_pop09_01 = l_pop_09 - l_pop_01;

gen DLe_09_95_50 = Le_09_50B - Le_95_50B;

gen DLe_09_01_50 = Le_09_50B - Le_01_50B;

gen DLe_09_95_100 = Le_09_100B - Le_95_100B;

gen DLe_09_01_100 = Le_09_100B - Le_01_100B;

gen Drank_09_95_50 = rank_09_50 - rank_95_50;

gen Drank_09_01_50 = rank_09_50 - rank_01_50;

egen rank_s = rank(l_pop_09);

gen rankp_09_50 = 51 - rank_s;

drop rank_s;

egen rank_s = rank(l_pop_01);

gen rankp_01_50 = 51 - rank_s;

drop rank_s;

egen rank_s = rank(l_pop_95);

gen rankp_95_50 = 51 - rank_s;

drop rank_s;

gen Drankp_09_95_50 = rankp_09_50 - rankp_95_50;

gen Drankp_09_01_50 = rankp_09_50 - rankp_01_50;

reg DLe_09_95_50 Dl_pop09_95 Le_95_50B;

reg DLe_09_01_50 Dl_pop09_01 Le_01_50B;

reg DLe_09_95_100 Dl_pop09_95 Le_95_100B;

reg DLe_09_01_100 Dl_pop09_01 Le_01_100B;

reg Drank_09_95_50 Drankp_09_95_50 rank_95_50;

reg Drank_09_01_50 Drankp_09_01_50 rank_01_50;


};






*********************************************************************************************;
************** Extra results for sections 4.2          **************************************;
*********************************************************************************************;

if 1==1{;

* Correlation between the indices;

*clear all;


log using "$results\extraction", text replace;

clear;


use "$data_source\temp_index.dta";

pwcorr Le_09_50B Pe_09_50B Fe_09_50B;
pwcorr Le_09_100B Pe_09_100B Fe_09_100B;


spearman Le_09_50B Pe_09_50B Fe_09_50B;
spearman Le_09_100B Pe_09_100B Fe_09_100B;


pwcorr Le_95_50B Pe_95_50B Fe_95_50B;
pwcorr Le_95_100B Pe_95_100B Fe_95_100B;


spearman Le_95_50B Pe_95_50B Fe_95_50B;
spearman Le_95_100B Pe_95_100B Fe_95_100B;

pwcorr Le_01_50B Pe_01_50B Fe_01_50B;
pwcorr Le_01_100B Pe_01_100B Fe_01_100B;


spearman Le_01_50B Pe_01_50B Fe_01_50B;
spearman Le_01_100B Pe_01_100B Fe_01_100B;





pwcorr L_09_50B La_09_50A Lb_09_50A Lb_09_50B Lc_09_50A Ld_09_50D Le_09_50B Lf_09_50A Lf_09_50C Lg_09_50B Lnp_09_100;

spearman L_09_50B La_09_50A Lb_09_50A Lb_09_50B Lc_09_50A Ld_09_50D Le_09_50B Lf_09_50A Lf_09_50C Lg_09_50B Lnp_09_100;

pwcorr L_09_100B La_09_100A Lb_09_100A Lb_09_100B Lc_09_100A Ld_09_100D Le_09_100B Lf_09_100A Lf_09_100C Lg_09_100B Lnp_09_100;

spearman L_09_100B La_09_100A Lb_09_100A Lb_09_100B Lc_09_100A Ld_09_100D Le_09_100B Lf_09_100A Lf_09_100C Lg_09_100B Lnp_09_100;

pwcorr L_01_50B La_01_50A Lb_01_50A Lb_01_50B Lc_01_50A Ld_01_50D Le_01_50B Lf_01_50A Lf_01_50C Lg_01_50B Lnp_01_100;

spearman L_01_50B La_01_50A Lb_01_50A Lb_01_50B Lc_01_50A Ld_01_50D Le_01_50B Lf_01_50A Lf_01_50C Lg_01_50B Lnp_01_100;

pwcorr L_01_100B La_01_100A Lb_01_100A Lb_01_100B Lc_01_100A Ld_01_100D Le_01_100B Lf_01_100A Lf_01_100C Lg_01_100B Lnp_01_100;

spearman L_01_100B La_01_100A Lb_01_100A Lb_01_100B Lc_01_100A Ld_01_100D Le_01_100B Lf_01_100A Lf_01_100C Lg_01_100B Lnp_01_100;

pwcorr L_95_50B La_95_50A Lb_95_50A Lb_95_50B Lc_95_50A Ld_95_50D Le_95_50B Lf_95_50A Lf_95_50C Lg_95_50B Lnp_95_100;

spearman L_95_50B La_95_50A Lb_95_50A Lb_95_50B Lc_95_50A Ld_95_50D Le_95_50B Lf_95_50A Lf_95_50C Lg_95_50B Lnp_95_100;

pwcorr L_95_100B La_95_100A Lb_95_100A Lb_95_100B Lc_95_100A Ld_95_100D Le_95_100B Lf_95_100A Lf_95_100C Lg_95_100B Lnp_95_100;

spearman L_95_100B La_95_100A Lb_95_100A Lb_95_100B Lc_95_100A Ld_95_100D Le_95_100B Lf_95_100A Lf_95_100C Lg_95_100B Lnp_95_100;












log close;
};











	 
	 

exit;
