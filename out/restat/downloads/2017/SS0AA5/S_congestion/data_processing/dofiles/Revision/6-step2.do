	/********************************
master2.do

VC Summer 2010, GD November 2011, February 2016

Runs regressions on speed indices

*********************************/





**************  Start  ********************************************************;

*set up;
#delimit;
clear all;

set memory 3g;

set matsize 5000;
set more 1;
quietly capture log close;
cd "D:\S_congestion\data_processing\dofiles\Revision\";

global data_source  D:\S_congestion\data_processing\data_generated\ ;
global data_source2  D:\S_congestion\data_processing\dofiles\Revision\data\ ;
global data_source3  D:\S_congestion\data_processing\dofiles\Revision\output\ ;



*********************************************************************************************;
**************                        SECTION 5        **************************************;
*********************************************************************************************;


* PREPARATION OF THE DATA (TO BE RUN ONCE);

if 1==1{;

use "$data_source2\tti_09_10.dta";

sort msa;

save, replace;

use "$data_source3\temp_index.dta";

*drop _merge;

sort msa;

merge msa using "$data_source2\tti_09_10.dta";

gen tti_mean = (TTI2009 + TTI2010)/2;

*save "$data_source3\temp_index.dta", replace;

foreach num in 50 100 {;
foreach year in 95 01 09 {;
foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

gen l_`type'=log(`type');

};
};
};

drop L* F* P* _merge;

sort msa;

save "$data_source3\index.dta", replace;

use "$data_source2\Duranton_Turner_AER_2010.dta";

keep pop* msa  l_transit84-l_pop00  S_somecollege_80- S_wholet03 g_exp00_80 g_exp00_90 g_exp90_80  l_hwy1947 l_rail1898 l_pix1835;

sort msa;

save "$data_source3\temp.dta", replace;


use "$data_source3\index.dta";

merge msa using "$data_source3\temp.dta";

keep if _merge == 3;

drop _merge;

sort msa;

save "$data_source3\index.dta", replace;

use "$data_source2\cbdmain2.dta";

keep msa  c90_pop_tot-inv_84rail pc_aquifer_msa pc_incorp_msa  seg1970_dissim- seg1980_s_black land_ha;

sort msa;

save "$data_source3\temp.dta", replace;


use "$data_source2\congestion_gis_stata12";

*rename NHPN_MR_2005_ringd1A MR_2005_ringd1A;
*rename NHPN_MR_2005_ringd2A MR_2005_ringd2A;
*rename NHPN_MR_2005_ringd3A MR_2005_ringd3A;
*rename NHPN_MR_2005_ringd4A MR_2005_ringd4A;
*rename NHPN_IH_2005_ringd1A IH_2005_ringd1A;
*rename NHPN_IH_2005_ringd2A IH_2005_ringd2A;
*rename NHPN_IH_2005_ringd3A IH_2005_ringd3A;
*rename NHPN_IH_2005_ringd4A IH_2005_ringd4A;

sort msa;

*save ".\data\congestion_GIS.dta", replace;
save "$data_source2\congestion_gis_stata12", replace;

use "$data_source3\index.dta";

merge msa using "$data_source3\temp.dta";

keep if _merge == 3;

drop _merge;

gen l_land_ha = log(land_ha);

gen l_mean_income = log(mean_income);

sort msa;

*merge msa using ".\data\congestion_GIS.dta";
merge msa using "$data_source2\congestion_gis_stata12";

drop _merge;

* GIS data contains one more observation;

save data\index.dta, replace;

};


 
local instruct "tex tdec(2) rdec(2) auto(2) symbol($^a$,$^b$,$^c$) se ";

local instruct2 "tex tdec(2) rdec(2) auto(2) symbol($^a$,$^b$,$^c$) se addstat(Overid,e(jp),First stage F, e(widstat))"; 



*********************** TABLE 5 ***************************;

if 1==1{;

clear all;

use "$data_source3\index.dta";

local reg "tab5";

log using tables/reg`reg', text replace;

local year "09";

local num "100";

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

reg l_`type' l_lane_`year' l_vtime_trip_uw_`year', robust;
predict TFP`reg'_`type', residuals;
test  l_lane_`year' + l_vtime_trip_uw_`year'=0;

if `i'==1{;
outreg2 using tables/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using tables/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};



foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

pwcorr l_`type' TFP`reg'_`type';

spearman l_`type' TFP`reg'_`type';

};

pwcorr TFP`reg'_L_`year'_`num'B TFP`reg'_La_`year'_`num'A TFP`reg'_Lb_`year'_`num'A TFP`reg'_Lb_`year'_`num'B TFP`reg'_Lc_`year'_`num'A TFP`reg'_Ld_`year'_`num'D TFP`reg'_Le_`year'_`num'B TFP`reg'_Lf_`year'_`num'A TFP`reg'_Lf_`year'_`num'C TFP`reg'_Lg_`year'_`num'B ;


spearman TFP`reg'_L_`year'_`num'B TFP`reg'_La_`year'_`num'A TFP`reg'_Lb_`year'_`num'A TFP`reg'_Lb_`year'_`num'B TFP`reg'_Lc_`year'_`num'A TFP`reg'_Ld_`year'_`num'D TFP`reg'_Le_`year'_`num'B TFP`reg'_Lf_`year'_`num'A TFP`reg'_Lf_`year'_`num'C TFP`reg'_Lg_`year'_`num'B ;

log close;

};

********************** TABLE 5B ***************************;

if 1==1{;

clear all;

use "$data_source3\index.dta";

local reg "tab5b";

log using tables/reg`reg', text replace;

local year "09";

local num "100";

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

reg l_`type' l_lane_`year', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using tables/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using tables/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};



foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

pwcorr l_`type' TFP`reg'_`type';

spearman l_`type' TFP`reg'_`type';

};

pwcorr TFP`reg'_L_`year'_`num'B TFP`reg'_La_`year'_`num'A TFP`reg'_Lb_`year'_`num'A TFP`reg'_Lb_`year'_`num'B TFP`reg'_Lc_`year'_`num'A TFP`reg'_Ld_`year'_`num'D TFP`reg'_Le_`year'_`num'B TFP`reg'_Lf_`year'_`num'A TFP`reg'_Lf_`year'_`num'C TFP`reg'_Lg_`year'_`num'B ;


spearman TFP`reg'_L_`year'_`num'B TFP`reg'_La_`year'_`num'A TFP`reg'_Lb_`year'_`num'A TFP`reg'_Lb_`year'_`num'B TFP`reg'_Lc_`year'_`num'A TFP`reg'_Ld_`year'_`num'D TFP`reg'_Le_`year'_`num'B TFP`reg'_Lf_`year'_`num'A TFP`reg'_Lf_`year'_`num'C TFP`reg'_Lg_`year'_`num'B ;

log close;

};

*********************** TABLE 6 ***************************;

if 1==1{;

clear all;

use "$data_source3\index.dta";

local reg "tab6";

log using tables/reg`reg', text replace;

gen l_TTI2010 = - log(TTI2010);
gen l_TTI2009 = - log(TTI2009);

reg l_Le_09_50B l_lane_09 l_vtime_trip_uw_09, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(50 \textsc{msa}s, 2009)  `instruct'  replace;

reg l_Le_01_100B l_lane_01 l_vtime_trip_uw_01, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(100 \textsc{msa}s, 2002)  `instruct'  append;

reg l_Le_95_100B l_lane_95 l_vtime_trip_uw_95, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(100 \textsc{msa}s, 1996)  `instruct'  append;

reg l_TTI2009 l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(\textsc{tti}, 2008)  `instruct'  append;

reg l_TTI2010 l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(\textsc{tti}, 2009)  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_pop_09, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(100 \textsc{msa}s, 2009)  `instruct'  append;

reg l_Le_09_100B  l_ln_km_IH_09 l_vtime_trip_uw_09, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(100 \textsc{msa}s, 2009)  `instruct'  append;

reg l_Le_09_100B  l_ln_km_IH_09 l_ln_km_MRU_09 l_vtime_trip_uw_09, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(100 \textsc{msa}s, 2009)  `instruct'  append;

log close;

};


*********************** TABLE 7 ***************************;



if 1==1{;

clear all;

use "$data_source3\index.dta";

local reg "tab7";

log using tables/reg`reg', text replace;

gen D_l_pop09_80 = l_pop_09 - l_pop80;

gen D_l_pop09_50 = l_pop_09 - l_pop50;

ivreg2 l_Le_09_100B l_lane_09 (l_vtime_trip_uw_09=l_pop_09) , robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(\textsc{tsls})  `instruct2'  replace;

ivreg2 l_Le_09_100B l_lane_09 (l_vtime_trip_uw_09=l_pop_09) D_l_pop09_80, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(\textsc{tsls})  `instruct2'  append;

ivreg2 l_Le_09_100B l_lane_09 (l_vtime_trip_uw_09=l_pop_09)  g_exp00_80, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(\textsc{tsls})  `instruct2'  append;

ivreg2 l_Le_09_100B (l_ln_km_IH_09 =l_hwy1947 l_rail1898)  l_vtime_trip_uw_09, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(\textsc{tsls})  `instruct2'  append;

ivreg2 l_Le_09_100B (l_ln_km_IH_09 =l_hwy1947 l_rail1898)  l_vtime_trip_uw_09 l_ln_km_MRU_09, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(\textsc{tsls})  `instruct2'  append;

ivreg2 l_Le_09_100B (l_ln_km_IH_09 =l_hwy1947 l_rail1898) l_vtime_trip_uw_09 l_pop50 l_pop20 g_exp00_80 l_ln_km_MRU_09, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(\textsc{tsls})  `instruct2'  append;

ivreg2 l_Le_09_100B (l_ln_km_IH_09 l_vtime_trip_uw_09 = l_hwy1947 l_rail1898 l_pop_09), robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(\textsc{tsls})  `instruct2'  append;

ivreg2 l_Le_09_100B (l_ln_km_IH_09 l_vtime_trip_uw_09 = l_hwy1947 l_rail1898 l_pop_09) l_ln_km_MRU_09, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(\textsc{tsls})  `instruct2'  append;

ivreg2 l_Le_09_100B (l_ln_km_IH_09 l_vtime_trip_uw_09 = l_hwy1947 l_rail1898 l_pop_09) l_ln_km_MRU_09 l_pop50 l_pop20 g_exp00_80, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(\textsc{tsls})  `instruct2'  append;


log close;

};













*********************** PMSA ***************************;

*********************** BASIC OLS (Regressions on lane (MRU + IH) and vehicle time) ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "1";

log using data/reg`reg', text replace;



foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

reg l_`type' l_lane_`year' l_vtime_trip_uw_`year', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};
};
};

gen l_tti_mean = log(tti_mean);
gen l_tti = log(tti);
gen l_TTI2009 = log(TTI2009);
gen l_TTI2010 = log(TTI2010);


reg tti l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(tti)  `instruct'  replace;

reg tti_mean l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(tti_mean)  `instruct' append;

reg TTI2009 l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(TTI2009)  `instruct' append;

reg TTI2010 l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(TTI2010)  `instruct' append;

reg l_tti l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(l_tti)  `instruct'  append;

reg l_tti_mean l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(l_tti_mean)  `instruct' append;

reg l_TTI2009 l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(l_TTI2009)  `instruct' append;

reg l_TTI2010 l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(l_TTI2010)  `instruct' append;



reg tti l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(tti)  `instruct'  replace;

reg tti_mean l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(tti_mean)  `instruct' append;

reg TTI2009 l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(TTI2009)  `instruct' append;

reg TTI2010 l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(TTI2010)  `instruct' append;

reg l_tti l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(l_tti)  `instruct'  append;

reg l_tti_mean l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(l_tti_mean)  `instruct' append;

reg l_TTI2009 l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(l_TTI2009)  `instruct' append;

reg l_TTI2010 l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(l_TTI2010)  `instruct' append;




foreach num in 50 100 {;
foreach year in 95 01 09 {;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

pwcorr l_`type' TFP`reg'_`type';

spearman l_`type' TFP`reg'_`type';

};

pwcorr TFP`reg'_L_`year'_`num'B TFP`reg'_La_`year'_`num'A TFP`reg'_Lb_`year'_`num'A TFP`reg'_Lb_`year'_`num'B TFP`reg'_Lc_`year'_`num'A TFP`reg'_Ld_`year'_`num'D TFP`reg'_Le_`year'_`num'B TFP`reg'_Lf_`year'_`num'A TFP`reg'_Lf_`year'_`num'C TFP`reg'_Lg_`year'_`num'B ;


spearman TFP`reg'_L_`year'_`num'B TFP`reg'_La_`year'_`num'A TFP`reg'_Lb_`year'_`num'A TFP`reg'_Lb_`year'_`num'B TFP`reg'_Lc_`year'_`num'A TFP`reg'_Ld_`year'_`num'D TFP`reg'_Le_`year'_`num'B TFP`reg'_Lf_`year'_`num'A TFP`reg'_Lf_`year'_`num'C TFP`reg'_Lg_`year'_`num'B ;


};
};

log close;

};














*********************** BASIC OLS (Regressions on lane (MRU + IH) and vehicle time) ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "1";

log using data/reg`reg', text replace;



foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

reg l_`type' l_lane_`year' l_vtime_trip_uw_`year', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};
};
};

gen l_tti_mean = log(tti_mean);
gen l_tti = log(tti);
gen l_TTI2009 = log(TTI2009);
gen l_TTI2010 = log(TTI2010);


reg tti l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(tti)  `instruct'  replace;

reg tti_mean l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(tti_mean)  `instruct' append;

reg TTI2009 l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(TTI2009)  `instruct' append;

reg TTI2010 l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(TTI2010)  `instruct' append;

reg l_tti l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(l_tti)  `instruct'  append;

reg l_tti_mean l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(l_tti_mean)  `instruct' append;

reg l_TTI2009 l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(l_TTI2009)  `instruct' append;

reg l_TTI2010 l_lane_09 l_vtime_trip_uw_09 if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(l_TTI2010)  `instruct' append;



reg tti l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(tti)  `instruct'  replace;

reg tti_mean l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(tti_mean)  `instruct' append;

reg TTI2009 l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(TTI2009)  `instruct' append;

reg TTI2010 l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(TTI2010)  `instruct' append;

reg l_tti l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(l_tti)  `instruct'  append;

reg l_tti_mean l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(l_tti_mean)  `instruct' append;

reg l_TTI2009 l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(l_TTI2009)  `instruct' append;

reg l_TTI2010 l_lane_09 l_vtime_trip_uw_09 if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(l_TTI2010)  `instruct' append;




foreach num in 50 100 {;
foreach year in 95 01 09 {;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

pwcorr l_`type' TFP`reg'_`type';

spearman l_`type' TFP`reg'_`type';

};

pwcorr TFP`reg'_L_`year'_`num'B TFP`reg'_La_`year'_`num'A TFP`reg'_Lb_`year'_`num'A TFP`reg'_Lb_`year'_`num'B TFP`reg'_Lc_`year'_`num'A TFP`reg'_Ld_`year'_`num'D TFP`reg'_Le_`year'_`num'B TFP`reg'_Lf_`year'_`num'A TFP`reg'_Lf_`year'_`num'C TFP`reg'_Lg_`year'_`num'B ;


spearman TFP`reg'_L_`year'_`num'B TFP`reg'_La_`year'_`num'A TFP`reg'_Lb_`year'_`num'A TFP`reg'_Lb_`year'_`num'B TFP`reg'_Lc_`year'_`num'A TFP`reg'_Ld_`year'_`num'D TFP`reg'_Le_`year'_`num'B TFP`reg'_Lf_`year'_`num'A TFP`reg'_Lf_`year'_`num'C TFP`reg'_Lg_`year'_`num'B ;


};
};

log close;

};






*********************** OLS WITH POPULATION INSTEAD OF VEHICLE TIME ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "2";

log using data/reg`reg', text replace;



foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

reg l_`type' l_lane_`year' l_pop_`year', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};
};
};


log close;

};




*********************** OLS WITH ONLY HIGHWAYS ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "3";

log using data/reg`reg', text replace;



foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

reg l_`type' l_ln_km_IH_`year' l_vtime_trip_uw_`year', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};
};
};


log close;

};





*********************** OLS WITH ONLY HIGHWAYS AND MRU SEPARATELY***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "4";

log using data/reg`reg', text replace;



foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

reg l_`type' l_ln_km_IH_`year' l_ln_km_MRU_`year' l_vtime_trip_uw_`year', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};
};
};


log close;

};



*********************** OLS WITH LANES ALONE ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "5";

log using data/reg`reg', text replace;



foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

reg l_`type' l_lane_`year', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};
};
};


log close;

};


*********************** OLS WITH GEOGRAPHY ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "6";

log using data/reg`reg', text replace;

local geography "elevat_range_msa cooling_dd heating_dd ruggedness_msa sprawl_1992";

foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

reg l_`type' l_lane_`year' l_vtime_trip_uw_`year' `geography', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};
};
};

gen l_tti_mean = log(tti_mean);
gen l_tti = log(tti);
gen l_TTI2009 = log(TTI2009);
gen l_TTI2010 = log(TTI2010);


reg tti l_lane_09 l_vtime_trip_uw_09 `geography' if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(tti)  `instruct'  replace;

reg tti_mean l_lane_09 l_vtime_trip_uw_09 `geography' if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(tti_mean)  `instruct' append;

reg TTI2009 l_lane_09 l_vtime_trip_uw_09 `geography' if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(TTI2009)  `instruct' append;

reg TTI2010 l_lane_09 l_vtime_trip_uw_09 `geography' if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(TTI2010)  `instruct' append;

reg l_tti l_lane_09 l_vtime_trip_uw_09 `geography' if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(l_tti)  `instruct'  append;

reg l_tti_mean l_lane_09 l_vtime_trip_uw_09 `geography' if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(l_tti_mean)  `instruct' append;

reg l_TTI2009 l_lane_09 l_vtime_trip_uw_09 `geography' if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(l_TTI2009)  `instruct' append;

reg l_TTI2010 l_lane_09 l_vtime_trip_uw_09 `geography' if rank<51, robust;
outreg2 using data/TFP`reg'_tti50.xls, ctitle(l_TTI2010)  `instruct' append;



reg tti l_lane_09 l_vtime_trip_uw_09 `geography' if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(tti)  `instruct'  replace;

reg tti_mean l_lane_09 l_vtime_trip_uw_09 `geography' if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(tti_mean)  `instruct' append;

reg TTI2009 l_lane_09 l_vtime_trip_uw_09 `geography' if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(TTI2009)  `instruct' append;

reg TTI2010 l_lane_09 l_vtime_trip_uw_09 `geography' if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(TTI2010)  `instruct' append;

reg l_tti l_lane_09 l_vtime_trip_uw_09 `geography' if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(l_tti)  `instruct'  append;

reg l_tti_mean l_lane_09 l_vtime_trip_uw_09 `geography' if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(l_tti_mean)  `instruct' append;

reg l_TTI2009 l_lane_09 l_vtime_trip_uw_09 `geography' if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(l_TTI2009)  `instruct' append;

reg l_TTI2010 l_lane_09 l_vtime_trip_uw_09 `geography' if rank<101, robust;
outreg2 using data/TFP`reg'_tti100.xls, ctitle(l_TTI2010)  `instruct' append;


log close;

};



*********************** OLS WITH GEOGRAPHY AND MORE CONTROLS ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "7";

log using data/reg`reg', text replace;

local geography "elevat_range_msa cooling_dd heating_dd ruggedness_msa sprawl_1992";

local controls "s_some_college l_mean_income poor_00 div1 div2 div3 div4 div5 div6 div7 div8 Smanuf97 l_land_ha  seg1980_dissim pc_aquifer_msa pc_incorp_msa";


foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

reg l_`type' l_lane_`year' l_vtime_trip_uw_`year' `geography' `controls', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};
};
};


log close;

};

*********************** OLS WITH AADT ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "8";

log using data/reg`reg', text replace;


foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

reg l_`type' l_lane_`year' l_vtime_trip_uw_`year' l_aadt_`year', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};
};
};




foreach num in 50 100 {;
foreach year in 95 01 09 {;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

pwcorr l_`type' TFP`reg'_`type';

spearman l_`type' TFP`reg'_`type';

};

pwcorr TFP`reg'_L_`year'_`num'B TFP`reg'_La_`year'_`num'A TFP`reg'_Lb_`year'_`num'A TFP`reg'_Lb_`year'_`num'B TFP`reg'_Lc_`year'_`num'A TFP`reg'_Ld_`year'_`num'D TFP`reg'_Le_`year'_`num'B TFP`reg'_Lf_`year'_`num'A TFP`reg'_Lf_`year'_`num'C TFP`reg'_Lg_`year'_`num'B ;


spearman TFP`reg'_L_`year'_`num'B TFP`reg'_La_`year'_`num'A TFP`reg'_Lb_`year'_`num'A TFP`reg'_Lb_`year'_`num'B TFP`reg'_Lc_`year'_`num'A TFP`reg'_Ld_`year'_`num'D TFP`reg'_Le_`year'_`num'B TFP`reg'_Lf_`year'_`num'A TFP`reg'_Lf_`year'_`num'C TFP`reg'_Lg_`year'_`num'B ;


};
};

log close;

};





*********************** OLS WITH AADT AND OTHER CONTROLS ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "9";

log using data/reg`reg', text replace;

local geography "elevat_range_msa cooling_dd heating_dd ruggedness_msa sprawl_1992";

local controls "s_some_college l_mean_income poor_00 div1 div2 div3 div4 div5 div6 div7 div8 Smanuf97 l_land_ha  seg1980_dissim pc_aquifer_msa pc_incorp_msa";


foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

reg l_`type' l_lane_`year' l_vtime_trip_uw_`year' l_aadt_`year' `geography' `controls', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};
};
};

log close;

};



*********************** FIRST ATTEMPT URBAN FORM VARIABLE ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "10";

log using data/reg`reg', text replace;

local geography "elevat_range_msa cooling_dd heating_dd ruggedness_msa sprawl_1992";

local controls "s_some_college l_mean_income poor_00 div1 div2 div3 div4 div5 div6 div7 div8 Smanuf97 l_land_ha  seg1980_dissim pc_aquifer_msa pc_incorp_msa";


foreach num in 50 100 {;
foreach year in 95 01 09 {;




local i=1;

foreach type in  conc_emp10 conc_emp50 conc_pop10 conc_pop50 density_emp94 density_pop100 mismatch1_pp mismatch5_pp mismatch20_pp cbd_v_p1 msa_v_p1 cbd_s_p1 cbd_v_p5 msa_v_p5 cbd_s_p5 cbd_v_p20 msa_v_p20 cbd_s_p20 cbd_v_d1 msa_v_d1 cbd_s_d1 cbd_v_d5 msa_v_d5 cbd_s_d5 cbd_v_d20 msa_v_d20 cbd_s_d20 cbd_v_e1 msa_v_e1 cbd_s_e1 cbd_v_e5 msa_v_e5 cbd_s_e5 cbd_v_e20 msa_v_e20 cbd_s_e20 {;


reg l_Le_`year'_`num'B l_lane_`year' l_vtime_trip_uw_`year' `type' , robust;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'A.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'A.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};

reg l_Lb_`year'_`num'B l_lane_`year' l_vtime_trip_uw_`year' `type' , robust;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'B.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'B.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};



reg l_L_`year'_`num'B l_lane_`year' l_vtime_trip_uw_`year' `type' , robust;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'C.xls, ctitle(OLS`reg' `type')  `instruct'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'C.xls, ctitle(OLS`reg' `type')  `instruct'  append;
};


local i=`i'+1;

};
};
};

log close;

};






*********************** IV LANE ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "11";

log using data/reg`reg', text replace;



foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

ivreg2 l_`type' (l_lane_`year'=l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_`year', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct2'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct2'  append;
};


local i=`i'+1;

};
};
};



log close;

};





*********************** IV LANE IH ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "12";

log using data/reg`reg', text replace;



foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

ivreg2 l_`type' (l_ln_km_IH_`year'=l_hwy1947 l_rail1898) l_vtime_trip_uw_`year', robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct2'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct2'  append;
};


local i=`i'+1;

};
};
};



log close;

};













*********************** IV POP ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "13";

log using data/reg`reg', text replace;



foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

ivreg2 l_`type' l_lane_`year' (l_vtime_trip_uw_`year'=l_pop_`year') , robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct2'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct2'  append;
};


local i=`i'+1;

};
};
};

log close;

};


*********************** IV ALL ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "14";

log using data/reg`reg', text replace;



foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=1;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

ivreg2 l_`type' (l_vtime_trip_uw_`year' l_ln_km_IH_`year'= l_hwy1947 l_rail1898 l_pop_`year') , robust;
predict TFP`reg'_`type', residuals;

if `i'==1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct2'  replace;
};


if `i'>1{;
outreg2 using data/TFP_`reg'_`year'_`num'.xls, ctitle(OLS`reg' `type')  `instruct2'  append;
};


local i=`i'+1;

};
};
};


log close;

};































*********************** Levinsohn Petrin and other panel approaches  ***************************;

if 1==1{;

clear all;
use ".\data\index.dta";

log using data/reg_dyn, text replace;

keep if rank<101;


* Preparation of the data for the transformation into the long format;

gen 

lane_83 =  ln_km_IH_83 +  ln_km_MRU_83;

gen l_lane_83 = log(lane_83);

gen invest_09 = l_lane_09 - l_lane_01;
gen invest_01 = l_lane_01 - l_lane_95;
gen invest_95 = l_lane_95 - l_lane_83;

gen Dpop_09 = l_pop_09 - l_pop_01;
gen Dpop_01 = l_pop_01 - l_pop_01;
gen Dpop_95 = l_pop_95 - log(pop80);

foreach num in 50 100 {;
foreach year in 95 01 09 {;

local i=0;

foreach type in L_`year'_`num'B La_`year'_`num'A Lb_`year'_`num'A Lb_`year'_`num'B Lc_`year'_`num'A Ld_`year'_`num'D Le_`year'_`num'B Lf_`year'_`num'A Lf_`year'_`num'C Lg_`year'_`num'B {;

*rename l_`type' = l_L`i'`num'_`year';

gen l_L`i'`num'_`year' = l_`type';


local i=`i'+1;

};
};
};

foreach num in 50 100 {;

gen D_l_L0`num'_09 = l_L_09_`num'B - l_L_01_`num'B; 
gen D_l_L1`num'_09 = l_La_09_`num'A - l_La_01_`num'A;
gen D_l_L2`num'_09 = l_Lb_09_`num'A - l_Lb_01_`num'A ;
gen D_l_L3`num'_09 = l_Lb_09_`num'B - l_Lb_01_`num'B ;
gen D_l_L4`num'_09 = l_Lc_09_`num'A - l_Lc_01_`num'A;
gen D_l_L5`num'_09 = l_Ld_09_`num'D - l_Ld_01_`num'D;
gen D_l_L6`num'_09 = l_Le_09_`num'B - l_Le_01_`num'B;
gen D_l_L7`num'_09 = l_Lf_09_`num'A - l_Lf_01_`num'A;
gen D_l_L8`num'_09 = l_Lf_09_`num'C - l_Lf_01_`num'C;
gen D_l_L9`num'_09 = l_Lg_09_`num'B - l_Lg_01_`num'B;
gen D_l_L0`num'_01 = l_L_01_`num'B - l_L_95_`num'B; 
gen D_l_L1`num'_01 = l_La_01_`num'A - l_La_95_`num'A;
gen D_l_L2`num'_01 = l_Lb_01_`num'A - l_Lb_95_`num'A ;
gen D_l_L3`num'_01 = l_Lb_01_`num'B - l_Lb_95_`num'B ;
gen D_l_L4`num'_01 = l_Lc_01_`num'A - l_Lc_95_`num'A;
gen D_l_L5`num'_01 = l_Ld_01_`num'D - l_Ld_95_`num'D;
gen D_l_L6`num'_01 = l_Le_01_`num'B - l_Le_95_`num'B;
gen D_l_L7`num'_01 = l_Lf_01_`num'A - l_Lf_95_`num'A;
gen D_l_L8`num'_01 = l_Lf_01_`num'C - l_Lf_95_`num'C;
gen D_l_L9`num'_01 = l_Lg_01_`num'B - l_Lg_95_`num'B;

};


gen pid=rank;

drop pop;

reshape long  l_L050 l_L150 l_L250 l_L350 l_L450 l_L550 l_L650 l_L750 l_L850 l_L950 
 l_L0100 l_L1100 l_L2100 l_L3100 l_L4100 l_L5100 l_L6100 l_L7100 l_L8100 l_L9100 
 D_l_L050 D_l_L150 D_l_L250 D_l_L350 D_l_L450 D_l_L550 D_l_L650 D_l_L750 D_l_L850 D_l_L950  
 D_l_L0100 D_l_L1100 D_l_L2100 D_l_L3100 D_l_L4100 D_l_L5100 D_l_L6100 D_l_L7100 D_l_L8100 D_l_L9100
lane l_lane invest l_vtime_trip_uw pop A, i(pid) j(year _95 _01 _09);

gen  vtime = exp(l_vtime_trip_uw); 

rename year year2;

gen year=.;

replace year = 1 if year2 =="_95";

replace year = 2 if year2 =="_01";

replace year = 3 if year2 =="_09";

xtset msa year;

rename l_lane loglane;

rename l_vtime_trip_uw logvtime;



local reg "LP";

foreach num in 50 100 {;
foreach i in 0 1 2 3 4 5 6 7 8 9 {;

levpet l_L`i'`num', free(logvtime) proxy(invest) capital(loglane);

if `i'==0{;
outreg2 using data/TFP_`reg'_`num'.xls, ctitle(`reg' `i') `instruct' replace;
};

if `i'>0{;
outreg2 using data/TFP_`reg'_`num'.xls, ctitle(`reg' `i')  `instruct'  append;
};
};
};




local reg "FE1";

foreach num in 50 100 {;
foreach i in 0 1 2 3 4 5 6 7 8 9 {;

xtreg l_L`i'`num' logvtime loglane, fe i(msa) robust;

if `i'==0{;
outreg2 using data/TFP_`reg'_`num'.xls, ctitle(`reg' `i') `instruct' replace;
};

if `i'>0{;
outreg2 using data/TFP_`reg'_`num'.xls, ctitle(`reg' `i')  `instruct'  append;
};
};
};


local reg "FE2";

gen year_95 = 0;
replace year_95 = 1 if year == 1;
gen year_01 = 0;
replace year_01 = 1 if year == 2;

foreach num in 50 100 {;
foreach i in 0 1 2 3 4 5 6 7 8 9 {;

xtreg l_L`i'`num' logvtime loglane year_95 year_01, fe i(msa) robust;

if `i'==0{;
outreg2 using data/TFP_`reg'_`num'.xls, ctitle(`reg' `i') `instruct' replace;
};

if `i'>0{;
outreg2 using data/TFP_`reg'_`num'.xls, ctitle(`reg' `i')  `instruct'  append;
};
};
};

local reg "FD1";

foreach num in 50 100 {;
foreach i in 0 1 2 3 4 5 6 7 8 9 {;

reg D_l_L`i'`num' logvtime loglane year_01, robust cl(msa);

if `i'==0{;
outreg2 using data/TFP_`reg'_`num'.xls, ctitle(`reg' `i') `instruct' replace;
};

if `i'>0{;
outreg2 using data/TFP_`reg'_`num'.xls, ctitle(`reg' `i')  `instruct'  append;
};
};
};

local reg "FD2";

foreach num in 50 100 {;
foreach i in 0 1 2 3 4 5 6 7 8 9 {;

reg D_l_L`i'`num' logvtime loglane if year==3, robust cl(msa);

if `i'==0{;
outreg2 using data/TFP_`reg'_`num'.xls, ctitle(`reg' `i') `instruct' replace;
};

if `i'>0{;
outreg2 using data/TFP_`reg'_`num'.xls, ctitle(`reg' `i')  `instruct'  append;
};
};
};

local reg "SD1";

foreach num in 50 100 {;
foreach i in 0 1 2 3 4 5 6 7 8 9 {;

xtreg D_l_L`i'`num' logvtime loglane year_01, fe i(msa);

if `i'==0{;
outreg2 using data/TFP_`reg'_`num'.xls, ctitle(`reg' `i') `instruct' replace;
};

if `i'>0{;
outreg2 using data/TFP_`reg'_`num'.xls, ctitle(`reg' `i')  `instruct'  append;
};

};
};

log close;
};







*********************** TABLE 8 ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "tab8";

log using data/reg`reg', text replace;


gen D_l_pop09_80 = l_pop_09 - l_pop80;

gen D_l_pop09_50 = l_pop_09 - l_pop50;


reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 cbd_s_e20, beta robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  replace;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 cbd_s_p20 , beta robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 mismatch20_pp , beta robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 g_exp00_80 , beta robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 l_pop20 , beta robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 /*Smanuf97*/ S_manuf83 , beta robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 cooling_dd , beta robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 heating_dd, beta robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;



log close;

};


*********************** TABLE 9 ***************************;

if 1==1{;

clear all;

use ".\data\index.dta";

local reg "tab9";

log using tables/reg`reg', text replace;



gen MR_2005_ring = MR_2005_ringd2A + MR_2005_ringd3A +MR_2005_ringd4A; 
gen IH_2005_ring = IH_2005_ringd2A + IH_2005_ringd3A +IH_2005_ringd4A;
gen hwy_1947_ring = hwy_1947_ringd2A + hwy_1947_ringd3A + hwy_1947_ringd4A;
gen rail_1898_ring = rail_1898_ringd2A + rail_1898_ringd3A + rail_1898_ringd4A;


gen l_IH_2005_rays= log(1+IH_2005_rays);
gen l_MR_2005_rays= log(1+MR_2005_rays);
gen l_IH_2005_ring =log(1+IH_2005_ring);
gen l_MR_2005_ring =log(1+MR_2005_ring);
gen l_hwy_1947_ring =log(1+hwy_1947_ring);
gen l_rail_1898_ring =log(1+rail_1898_ring);
gen l_hwy_1947_rays =log(1+hwy_1947_rays);
gen l_rail_1898_rays =log(1+rail_1898_rays);

gen ring_rays =IH_2005_ring * IH_2005_rays;

gen ring_per_lnkm = IH_2005_ring / lane_09*1000;

gen ray_per_lnkm = IH_2005_rays / lane_09*1000;


gen ring = IH_2005_ring;
gen rays = IH_2005_rays;


reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 ring, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(IH 2005)  `instruct'  replace;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 rays, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(IH 2005)  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 ring rays, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(IH 2005)  `instruct'  append;

replace ring = MR_2005_ring;
replace rays = MR_2005_rays;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 ring rays, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(MR 2005)  `instruct'  append;

replace ring = ring_per_lnkm;
replace rays = ray_per_lnkm;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 ring rays, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(IH 2005 per km)  `instruct'  append;

replace ring = l_IH_2005_ring;
replace rays = l_IH_2005_rays;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 ring rays, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(IH 2005 in log)  `instruct'  append;

*replace ring = hwy_1947_ring;
*replace rays = hwy_1947_rays;

*reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 ring rays, robust;
*outreg2 using data/TFP_`reg'.xls, ctitle(hwy 1947)  `instruct'  append;

*replace ring = rail_1898_ring;
*replace rays = rail_1898_rays;

*replace ring = l_IH_2005_ring;
*replace rays = l_IH_2005_rays;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 ring rays cbd_s_p20, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(cbd_s_p20)  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 ring rays S_manuf83, robust;
outreg2 using tables/TFP_`reg'.xls, ctitle(S_manuf83)  `instruct'  append;



/*


local reg "tab9a";


reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  replace;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 l_IH_2005_rays, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 l_MR_2005_rays , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 l_IH_2005_ring , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 l_MR_2005_ring , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;


reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 l_IH_2005_rays l_IH_2005_ring, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 l_MR_2005_rays l_MR_2005_ring, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;


ivreg2 l_Le_09_100B (l_ln_km_IH_09=l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;

ivreg2 l_Le_09_100B (l_ln_km_IH_09=l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09 l_IH_2005_rays l_IH_2005_ring, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;


ivreg2 l_Le_09_100B (l_ln_km_IH_09 l_IH_2005_rays l_IH_2005_ring = l_rail_1898_rays l_hwy_1947_rays l_rail_1898_ring l_hwy_1947_ring l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09 , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;


ivreg2 l_Le_09_100B l_lane_09 ( l_IH_2005_rays l_IH_2005_ring = l_rail_1898_rays l_hwy_1947_rays l_rail_1898_ring l_hwy_1947_ring ) l_vtime_trip_uw_09 , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;


ivreg2 l_Le_09_100B (l_ln_km_IH_09=l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09 l_IH_2005_ring, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;


ivreg2 l_Le_09_100B (l_ln_km_IH_09 l_IH_2005_ring = l_rail_1898_ring l_hwy_1947_ring l_rail_1898_ring l_hwy_1947_ring l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09 , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;


ivreg2 l_Le_09_100B l_lane_09 ( l_IH_2005_ring  = l_rail_1898_ring l_hwy_1947_ring ) l_vtime_trip_uw_09 , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;



ivreg2 l_Le_09_100B (l_ln_km_IH_09=l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09 l_IH_2005_rays , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;


ivreg2 l_Le_09_100B (l_ln_km_IH_09 l_IH_2005_rays  = l_rail_1898_rays l_hwy_1947_rays  l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09 , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;


ivreg2 l_Le_09_100B l_lane_09 ( l_IH_2005_rays  = l_rail_1898_rays l_hwy_1947_rays) l_vtime_trip_uw_09 , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;

local reg "tab9b";

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  replace;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 IH_2005_rays, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 MR_2005_rays , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 IH_2005_ring , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 MR_2005_ring , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;


reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 IH_2005_rays IH_2005_ring, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 MR_2005_rays MR_2005_ring, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;


ivreg2 l_Le_09_100B (l_ln_km_IH_09=l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;

ivreg2 l_Le_09_100B (l_ln_km_IH_09=l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09 IH_2005_rays IH_2005_ring, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;

ivreg2 l_Le_09_100B (l_ln_km_IH_09 IH_2005_rays IH_2005_ring = rail_1898_rays hwy_1947_rays rail_1898_ring hwy_1947_ring l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09 , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;

ivreg2 l_Le_09_100B l_lane_09 (IH_2005_rays IH_2005_ring = rail_1898_rays hwy_1947_rays rail_1898_ring hwy_1947_ring ) l_vtime_trip_uw_09 , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;

ivreg2 l_Le_09_100B (l_ln_km_IH_09=l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09 IH_2005_ring, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;

ivreg2 l_Le_09_100B (l_ln_km_IH_09 IH_2005_ring = rail_1898_ring hwy_1947_ring rail_1898_ring l_hwy_1947_ring l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09 , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;


ivreg2 l_Le_09_100B l_lane_09 (IH_2005_ring = rail_1898_ring hwy_1947_ring ) l_vtime_trip_uw_09 , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;



ivreg2 l_Le_09_100B (l_ln_km_IH_09=l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09 IH_2005_rays , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;


ivreg2 l_Le_09_100B (l_ln_km_IH_09 IH_2005_rays  = rail_1898_rays hwy_1947_rays  l_hwy1947 l_rail1898 l_pix1835) l_vtime_trip_uw_09 , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;


ivreg2 l_Le_09_100B l_lane_09 (IH_2005_rays  = rail_1898_rays hwy_1947_rays) l_vtime_trip_uw_09 , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct2'  append;


local reg "tab9c";



reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  replace;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 hwy_1947_rays, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 hwy_1947_ring , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 hwy_1947_ring hwy_1947_rays , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;



reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 rail_1898_rays, robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 rail_1898_ring , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;

reg l_Le_09_100B l_lane_09 l_vtime_trip_uw_09 rail_1898_ring rail_1898_rays , robust;
outreg2 using data/TFP_`reg'.xls, ctitle()  `instruct'  append;





*/


log close;

};



*********************************************************************************************;
**************     Production function in one step     **************************************;
*********************************************************************************************;

if 1==1{;

clear all;

use "$data_source\working_npts.dta";
 
keep if rank_msa <= 100;

sort msa;

save data\temp.dta, replace;


use ".\data\Duranton_Turner_AER_2010.dta";

keep pop* msa  l_transit84- l_pop00  S_somecollege_80- S_wholet03 g_exp00_80 g_exp00_90 g_exp90_80  l_hwy1947 l_rail1898 l_pix1835;

sort msa;

save data\temp2.dta, replace;


use ".\data\temp.dta";

merge msa using ".\data\temp2.dta";

keep if _merge == 3;

drop _merge;

sort msa;

save data\temp.dta, replace;

merge msa using "$data_source\npts_msa.dta";

keep if _merge == 3;

drop _merge;

sort msa;

save data\temp.dta, replace;


local controls = "hh_income_2-hh_income_18 hh_education_2-hh_education_5 r_age r_sex tdwknd depart_1-depart_23 worker month_2-month_12 black hispanic";



reg l_p l_trpmiles l_lane_09 l_pop00 `controls' if year == 09, cl(msa) robust;






};



exit;












