global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/"

#delimit;
clear;
set more off;
set matsize 1800;

set mem 10000m;
global path ~;
capture log close;

/*================================================
 Program: offshore_exposure.do
 Author:  Avi Ebenstein and Shannon Phillips
 Created: March 2009
 Purpose: Assess impact of outsourcing by occupation among all workers
	   Does not include price of shipments (rpiship79)
	   so can assess economy-wide effects on all workers (N=3,481,637)
=================================================*/

**********************************************************************;
* Prepare the BEA offshore employment data to be organized by ind7090 ;
**********************************************************************;


use $masterpath/07202014/emp_man7090.dta;
drop if man7090>=71;
gen man7090_orig=man7090;
do $masterpath/dofiles/man7090_orig_ind7090.do;
bysort year ind7090:keep if _n==1;
drop if year==2003;
sort year ind7090;
save $masterpath/datafiles/temp_emp_ind7090, replace;

************************************************************;
* Prepare the import/export data to be organized by ind7090 ;
************************************************************;

!gunzip $path/research/outsourcing/trade/import_data.dta.gz;
use $path/research/outsourcing/trade/import_data;

do $masterpath/dofiles/man7090_orig_ind7090.do;
bysort year ind7090: keep if _n==1;

sort year ind7090;
merge year ind7090 using $masterpath/datafiles/temp_emp_ind7090;
tab _merge;
drop _merge;
sort year ind7090;
save $masterpath/datafiles/temp_import_ind7090, replace;

***************************************************************************************;
* Prepare the share of imports from low wage countries data to be organized by ind7090 ;
***************************************************************************************;

!gunzip $masterpath/datafiles/trade_man7090.dta.gz;
use $masterpath/datafiles/trade_man7090;
gen man7090_orig=man7090;
do $masterpath/dofiles/man7090_orig_ind7090.do;
drop if year<1982;
sort year ind7090;
merge year ind7090 using $masterpath/datafiles/temp_import_ind7090;
tab _merge;
drop _merge;
sort year ind7090;
save $masterpath/datafiles/temp_trade_ind7090, replace;

*******************************************************************************************;
* Prepare the price of imports and exports to be organized by ind7090 at the 3-digit level ;
*******************************************************************************************;

use $masterpath/datafiles/premium_prices3dig_man7090;
gen man7090_orig=man7090;
do $masterpath/dofiles/man7090_orig_ind7090.do;
drop if year<1982;
sort year ind7090;
merge year ind7090 using $masterpath/datafiles/temp_trade_ind7090;
tab _merge;
drop _merge;
rename expfin expfin3;
rename impfin impfin3;
sort year ind7090;
save $masterpath/datafiles/temp_price3_ind7090, replace;


*******************************************************************************************;
* Prepare the price of imports and exports to be organized by ind7090 at the 2-digit level ;
*******************************************************************************************;

use $masterpath/datafiles/premium_prices2dig_man7090;
gen man7090_orig=man7090;
do $masterpath/dofiles/man7090_orig_ind7090.do;
drop if year<1982;
sort year ind7090;
merge year ind7090 using $masterpath/datafiles/temp_price3_ind7090;
tab _merge;
drop _merge;
rename expfin expfin2;
rename impfin impfin2;
sort year ind7090;
save $masterpath/datafiles/temp_price2_ind7090, replace;


*******************************************************************************************;
* Prepare the price of imports and exports to be organized by ind7090 at the 1-digit level ;
*******************************************************************************************;

use $masterpath/datafiles/premium_prices1dig_man7090;
gen man7090_orig=man7090;
do $masterpath/dofiles/man7090_orig_ind7090.do;
drop if year<1982;
sort year ind7090;
merge year ind7090 using $masterpath/datafiles/temp_price2_ind7090;
tab _merge;
drop _merge;
rename expfin expfin1;
rename impfin impfin1;
sort year ind7090;

**********;

replace lowincemp=1 if lowincemp==0;

gen llowincemp=log(lowincemp);
gen lhigh=log(highincemp);


keep year ind7090 penmod79 expmod79 vsh79 llowincemp lhigh lowincemp highincemp expfin3 impfin3 expfin2 impfin2 expfin1 impfin1 cap79 labor79 piinv79 tfp579 rpiship79; 
rename penmod79 penmod79_;
rename expmod79 expmod79_;
rename llowincemp llowincemp_;
rename lhigh lhigh_;
rename lowincemp lowincemp_;
rename highincemp highincemp_;
rename vsh79 vsh79_;
rename cap79 cap79_;
rename labor79 labor79_;
rename piinv79 piinv79_;
rename tfp579 tfp579_;
rename rpiship79 rpiship79_;

rename expfin3 expfin3_; 
rename impfin3 impfin3_;
rename expfin2 expfin2_; 
rename impfin2 impfin2_;
rename expfin1 expfin1_; 
rename impfin1 impfin1_;

drop if ind7090==.;
*****************************************************************************;
* Create vector of trade/offshore variables by year for all industries (wide);
*****************************************************************************;

reshape wide penmod79_ expmod79_ vsh79_ llowincemp_ lhigh_ lowincemp_ highincemp_ cap79_ labor79_ piinv79_ tfp579_ rpiship79_ expfin1_ impfin1_ expfin2_ impfin2_ expfin3_ impfin3_,i(year) j(ind7090);
for var penmod* expmod* vsh* llowincemp* lhigh* lowincemp* highincemp* expfin1* impfin1* expfin2* impfin2* expfin3* impfin3*: replace X=0 if X==.;
save $masterpath/trade/trade_offshore_data_wide, replace;

************************************************************;
* Create vector of employment weights by occupation         ;
************************************************************;

!gunzip $masterpath/datafiles/merge_micro_ind7090.dta.gz;
use $masterpath/datafiles/merge_micro_ind7090, clear;

keep if year==1983;
collapse (sum) ihwt, by(ind7090 occ8090);
bysort occ8090: egen totalocc83=sum(ihwt);

rename ihwt emp_;
drop if ind7090==.;
reshape wide emp_, i(occ8090) j(ind7090);

************************************************************;
* Share of occupation's employment in each ind7090 industry ;
************************************************************;

for var emp*: replace X=0 if X==.;

do $masterpath/dofiles/industrylist.do;
foreach j of global industrylist{;
                                 capture noisily gen emp_share_`j'=emp_`j'/totalocc83;
                               };

save $masterpath/datafiles/employment_weights, replace;

expand 20;
bysort occ8090: gen year=1982+[_n];

*************************************************************************************************************;
* Take the weighted sum of emp_share * trade/offshore variables to assign "effective exposure" by occupation ;
*************************************************************************************************************;

keep year occ8090 emp_share_*;

sort year;
!gunzip $masterpath/trade/trade_offshore_data_wide.dta.gz;
merge year using $masterpath/trade/trade_offshore_data_wide;

**********************************************************************************************;
* Focus on industries in ind7090 which are in manufacturing (and have non-zero trade/offshore);
**********************************************************************************************;

do $masterpath/dofiles/industrylist_short.do;

**********;
* Trade   ;
**********;

global tradelist "penmod expmod vsh ";
foreach k of global tradelist{;
gen `k'_effective_tot=0;
foreach j of global industrylist_short{;
                                 gen `k'_weighted_`j'=emp_share_`j'*`k'79_`j';
                                 replace `k'_effective_tot=`k'_effective_tot+`k'_weighted_`j' if `k'_weighted_`j'~=.;
                               };
egen `k'_effective=rsum(`k'_weighted_*);
};

***********;
* Offshore ;
***********;

global bealist "llowincemp lhigh lowincemp highincemp expfin1 impfin1 expfin2 impfin2 expfin3 impfin3";
foreach k of global bealist{;
gen `k'_effective_tot=0;
foreach j of global industrylist_short{;
                                 gen `k'_weighted_`j'=emp_share_`j'*`k'_`j';
                                 replace `k'_effective_tot=`k'_effective_tot+`k'_weighted_`j' if `k'_weighted_`j'~=.;
                               };
egen `k'_effective=rsum(`k'_weighted_*);
};

global techlist "cap79 labor79 tfp579 piinv79 rpiship79";
foreach k of global techlist{;
gen `k'_effective_tot=0;
foreach j of global industrylist_short{;
                                 gen `k'_weighted_`j'=emp_share_`j'*`k'_`j';
                                 replace `k'_effective_tot=`k'_effective_tot+`k'_weighted_`j' if `k'_weighted_`j'~=.;
                               };
egen `k'_effective=rsum(`k'_weighted_*);
};


**************************************************************************************************;
* Save matrix of year X occupation level of effective exposure to each measure of trade/offshore ;
**************************************************************************************************;

keep year occ8090 penmod_effective expmod_effective llowincemp_effective lhigh_effective lowincemp_effective highincemp_effective vsh_effective expfin1_effective impfin1_effective expfin2_effective impfin2_effective expfin3_effective impfin3_effective
cap79_effective labor79_effective tfp579_effective piinv79_effective rpiship79_effective;

label var penmod_effective "Effective penmod using occupation/industry weights";
label var expmod_effective "Effective expmod using occupation/industry weights";
label var vsh_effective "Effective share of imports from low wage countries using occupation/industry weights";

label var llowincemp_effective "Effective log of offshore employment in low income countries using occupation/industry weights";
label var lhigh_effective "Effective log of offshore employment in high income countries using occupation/industry weights";
label var lowincemp_effective "Effective offshore employment in low income countries using occupation/industry weights";
label var highincemp_effective "Effective offshore employment in high income countries using occupation/industry weights";


label var cap79_effective "Effective capital using occupation/industry weights";
label var labor79_effective "Effective labor using occupation/industry weights";
label var tfp579_effective "Effective tfp using occupation/industry weights";
label var piinv79_effective "Effective piinv using occupation/industry weights";
label var rpiship79_effective "Effective rpiship using occupation/industry weights";

label var expfin1_effective "Effective price of exports at the 1-digit level using occupation/industry weights";
label var impfin1_effective "Effective price of imports at the 1-digit level using occupation/industry weights";
label var expfin2_effective "Effective price of exports at the 2-digit level using occupation/industry weights";
label var impfin2_effective "Effective price of imports at the 2-digit level using occupation/industry weights";
label var expfin3_effective "Effective price of exports at the 3-digit level using occupation/industry weights";
label var impfin3_effective "Effective price of imports at the 3-digit level using occupation/industry weights";

sort occ8090 year;
by occ8090: gen p_llowincemp_effective_occ=llowincemp_effective[_n-1];
by occ8090: gen p_lhigh_effective_occ=lhigh_effective[_n-1]; 
by occ8090: gen p_lowincemp_effective_occ=lowincemp_effective[_n-1];
by occ8090: gen p_highincemp_effective_occ=highincemp_effective[_n-1]; 
by occ8090: gen p_expmod_effective_occ=expmod_effective[_n-1]; 
by occ8090: gen p_penmod_effective_occ=penmod_effective[_n-1];
by occ8090: gen p_vsh_effective_occ=vsh_effective[_n-1];

by occ8090: gen p_cap79_effective_occ=cap79_effective[_n-1];
by occ8090: gen p_labor79_effective_occ=labor79_effective[_n-1];
by occ8090: gen p_tfp579_effective_occ=tfp579_effective[_n-1];
by occ8090: gen p_piinv79_effective_occ=piinv79_effective[_n-1];
by occ8090: gen p_rpiship79_effective_occ=rpiship79_effective[_n-1];

by occ8090: gen p_expfin1_effective_occ=expfin1_effective[_n-1];
by occ8090: gen p_impfin1_effective_occ=impfin1_effective[_n-1];
by occ8090: gen p_expfin2_effective_occ=expfin2_effective[_n-1];
by occ8090: gen p_impfin2_effective_occ=impfin2_effective[_n-1];
by occ8090: gen p_expfin3_effective_occ=expfin3_effective[_n-1];
by occ8090: gen p_impfin3_effective_occ=impfin3_effective[_n-1];

sort occ8090 year;
by occ8090: gen f1_llowincemp_effective_occ=llowincemp_effective[_n+1];
by occ8090: gen f1_lhigh_effective_occ=lhigh_effective[_n+1];
by occ8090: gen f1_lowincemp_effective_occ=lowincemp_effective[_n+1];
by occ8090: gen f1_highincemp_effective_occ=highincemp_effective[_n+1];
by occ8090: gen f1_expmod_effective_occ=expmod_effective[_n+1];
by occ8090: gen f1_penmod_effective_occ=penmod_effective[_n+1];
by occ8090: gen f1_vsh_effective_occ=vsh_effective[_n+1];

by occ8090: gen f3_llowincemp_effective_occ=llowincemp_effective[_n+3];
by occ8090: gen f3_lhigh_effective_occ=lhigh_effective[_n+3];
by occ8090: gen f3_lowincemp_effective_occ=lowincemp_effective[_n+3];
by occ8090: gen f3_highincemp_effective_occ=highincemp_effective[_n+3];
by occ8090: gen f3_expmod_effective_occ=expmod_effective[_n+3];
by occ8090: gen f3_penmod_effective_occ=penmod_effective[_n+3];
by occ8090: gen f3_vsh_effective_occ=vsh_effective[_n+3];

by occ8090: gen f5_llowincemp_effective_occ=llowincemp_effective[_n+5];
by occ8090: gen f5_lhigh_effective_occ=lhigh_effective[_n+5];
by occ8090: gen f5_lowincemp_effective_occ=lowincemp_effective[_n+5];
by occ8090: gen f5_highincemp_effective_occ=highincemp_effective[_n+5];
by occ8090: gen f5_expmod_effective_occ=expmod_effective[_n+5];
by occ8090: gen f5_penmod_effective_occ=penmod_effective[_n+5];
by occ8090: gen f5_vsh_effective_occ=vsh_effective[_n+5];

by occ8090: gen f10_llowincemp_effective_occ=llowincemp_effective[_n+10];
by occ8090: gen f10_lhigh_effective_occ=lhigh_effective[_n+10];
by occ8090: gen f10_lowincemp_effective_occ=lowincemp_effective[_n+10];
by occ8090: gen f10_highincemp_effective_occ=highincemp_effective[_n+10];
by occ8090: gen f10_expmod_effective_occ=expmod_effective[_n+10];
by occ8090: gen f10_penmod_effective_occ=penmod_effective[_n+10];
by occ8090: gen f10_vsh_effective_occ=vsh_effective[_n+10];

label var p_penmod_effective_occ "Lagged effective penmod using occupation/industry weights, by occupation";
label var p_expmod_effective_occ "Lagged effective expmod using occupation/industry weights, by occupation";
label var p_llowincemp_effective_occ "Lagged log of effective offshore employment in low income countries using occupation/industry weights, by occupation";
label var p_lhigh_effective_occ "Lagged log of effective offshore employment in high income countries using occupation/industry weights, by occupation";
label var p_lowincemp_effective_occ "Lagged effective offshore employment in low income countries using occupation/industry weights, by occupation";
label var p_highincemp_effective_occ "Lagged effective offshore employment in high income countries using occupation/industry weights, by occupation";
label var p_vsh_effective_occ "Lagged effective share of imports from low wage countries using occupation/industry weights, by occupation";

label var p_cap79_effective_occ "Lagged effective capital using occupation/industry weights, by occupation";
label var p_labor79_effective_occ "Lagged effective labor using occupation/industry weights, by occupation";
label var p_tfp579_effective_occ "Lagged effective tfp5 using occupation/industry weights, by occupation";
label var p_piinv79_effective_occ "Lagged effective price of investment goods using occupation/industry weights, by occupation";
label var p_rpiship79_effective_occ "Lagged effective real price of shipments using occupation/industry weights, by occupation";

label var p_expfin1_effective "Lagged effective price of exports at the 1-digit level using occupation/industry weights, by occupation";
label var p_impfin1_effective "Lagged effective price of imports at the 1-digit level using occupation/industry weights, by occupation";
label var p_expfin2_effective "Lagged effective price of exports at the 2-digit level using occupation/industry weights, by occupation";
label var p_impfin2_effective "Lagged effective price of imports at the 2-digit level using occupation/industry weights, by occupation";
label var p_expfin3_effective "Lagged effective price of exports at the 3-digit level using occupation/industry weights, by occupation";
label var p_impfin3_effective "Lagged effective price of imports at the 3-digit level using occupation/industry weights, by occupation";

sort year occ8090;
save $masterpath/datafiles/occupational_exposure_data, replace;

***********************************************************************;
* Use the workers and assign them these new measures of trade/offshore ;
***********************************************************************;

use $masterpath/datafiles/merge_micro_ind7090, clear;
drop if occ8090==.;
sort year occ8090;
merge year occ8090 using $masterpath/datafiles/occupational_exposure_data;
tab _merge;
keep if  _merge==3;

********************************************;
* Create two-digit occupation fixed effects ;
********************************************;
gen occ8090_fe=0 if occ8090>=0 & occ8090<=9;
replace occ8090_fe=1 if occ8090>=10 & occ8090<=19;
replace occ8090_fe=2 if occ8090>=20 & occ8090<=29;
replace occ8090_fe=3 if occ8090>=30 & occ8090<=39;
replace occ8090_fe=4 if occ8090>=40 & occ8090<=49;
replace occ8090_fe=5 if occ8090>=50 & occ8090<=59;
replace occ8090_fe=6 if occ8090>=60 & occ8090<=69;
replace occ8090_fe=7 if occ8090>=70 & occ8090<=79;
replace occ8090_fe=8 if occ8090>=80 & occ8090<=89;
replace occ8090_fe=9 if occ8090>=90 & occ8090<=99;
replace occ8090_fe=10 if occ8090>=100 & occ8090<=109;
replace occ8090_fe=11 if occ8090>=110 & occ8090<=119;
replace occ8090_fe=12 if occ8090>=120 & occ8090<=129;
replace occ8090_fe=13 if occ8090>=130 & occ8090<=139;
replace occ8090_fe=14 if occ8090>=140 & occ8090<=149;
replace occ8090_fe=15 if occ8090>=150 & occ8090<=159;
replace occ8090_fe=16 if occ8090>=160 & occ8090<=169;
replace occ8090_fe=17 if occ8090>=170 & occ8090<=179;
replace occ8090_fe=18 if occ8090>=180 & occ8090<=189;
replace occ8090_fe=19 if occ8090>=190 & occ8090<=199;
replace occ8090_fe=20 if occ8090>=200 & occ8090<=209;
replace occ8090_fe=21 if occ8090>=210 & occ8090<=219;
replace occ8090_fe=22 if occ8090>=220 & occ8090<=229;
replace occ8090_fe=23 if occ8090>=230 & occ8090<=239;
replace occ8090_fe=24 if occ8090>=240 & occ8090<=249;
replace occ8090_fe=25 if occ8090>=250 & occ8090<=259;
replace occ8090_fe=26 if occ8090>=260 & occ8090<=269;
replace occ8090_fe=27 if occ8090>=270 & occ8090<=279;
replace occ8090_fe=28 if occ8090>=280 & occ8090<=289;
replace occ8090_fe=29 if occ8090>=290 & occ8090<=299;
replace occ8090_fe=30 if occ8090>=300 & occ8090<=309;
replace occ8090_fe=31 if occ8090>=310 & occ8090<=319;
replace occ8090_fe=32 if occ8090>=320 & occ8090<=329;
replace occ8090_fe=33 if occ8090>=330 & occ8090<=339;
replace occ8090_fe=34 if occ8090>=340 & occ8090<=349;
replace occ8090_fe=35 if occ8090>=350 & occ8090<=359;
replace occ8090_fe=36 if occ8090>=360 & occ8090<=369;
replace occ8090_fe=37 if occ8090>=370 & occ8090<=379;
replace occ8090_fe=38 if occ8090>=380 & occ8090<=389;
replace occ8090_fe=39 if occ8090>=390 & occ8090<=399;
replace occ8090_fe=40 if occ8090>=400 & occ8090<=409;
replace occ8090_fe=41 if occ8090>=410 & occ8090<=419;
replace occ8090_fe=42 if occ8090>=420 & occ8090<=429;
replace occ8090_fe=43 if occ8090>=430 & occ8090<=439;
replace occ8090_fe=44 if occ8090>=440 & occ8090<=449;
replace occ8090_fe=45 if occ8090>=450 & occ8090<=459;
replace occ8090_fe=46 if occ8090>=460 & occ8090<=469;
replace occ8090_fe=47 if occ8090>=470 & occ8090<=479;
replace occ8090_fe=48 if occ8090>=480 & occ8090<=489;
replace occ8090_fe=49 if occ8090>=490 & occ8090<=499;
replace occ8090_fe=50 if occ8090>=500 & occ8090<=509;
replace occ8090_fe=51 if occ8090>=510 & occ8090<=519;
replace occ8090_fe=52 if occ8090>=520 & occ8090<=529;
replace occ8090_fe=53 if occ8090>=530 & occ8090<=539;
replace occ8090_fe=54 if occ8090>=540 & occ8090<=549;
replace occ8090_fe=55 if occ8090>=550 & occ8090<=559;
replace occ8090_fe=56 if occ8090>=560 & occ8090<=569;
replace occ8090_fe=57 if occ8090>=570 & occ8090<=579;
replace occ8090_fe=58 if occ8090>=580 & occ8090<=589;
replace occ8090_fe=59 if occ8090>=590 & occ8090<=599;
replace occ8090_fe=60 if occ8090>=600 & occ8090<=609;
replace occ8090_fe=61 if occ8090>=610 & occ8090<=619;
replace occ8090_fe=62 if occ8090>=620 & occ8090<=629;
replace occ8090_fe=63 if occ8090>=630 & occ8090<=639;
replace occ8090_fe=64 if occ8090>=640 & occ8090<=649;
replace occ8090_fe=65 if occ8090>=650 & occ8090<=659;
replace occ8090_fe=66 if occ8090>=660 & occ8090<=669;
replace occ8090_fe=67 if occ8090>=670 & occ8090<=679;
replace occ8090_fe=68 if occ8090>=680 & occ8090<=689;
replace occ8090_fe=69 if occ8090>=690 & occ8090<=699;
replace occ8090_fe=70 if occ8090>=700 & occ8090<=709;
replace occ8090_fe=71 if occ8090>=710 & occ8090<=719;
replace occ8090_fe=72 if occ8090>=720 & occ8090<=729;
replace occ8090_fe=73 if occ8090>=730 & occ8090<=739;
replace occ8090_fe=74 if occ8090>=740 & occ8090<=749;
replace occ8090_fe=75 if occ8090>=750 & occ8090<=759;
replace occ8090_fe=76 if occ8090>=760 & occ8090<=769;
replace occ8090_fe=77 if occ8090>=770 & occ8090<=779;
replace occ8090_fe=78 if occ8090>=780 & occ8090<=789;
replace occ8090_fe=79 if occ8090>=790 & occ8090<=799;
replace occ8090_fe=80 if occ8090>=800 & occ8090<=809;
replace occ8090_fe=81 if occ8090>=810 & occ8090<=819;
replace occ8090_fe=82 if occ8090>=820 & occ8090<=829;
replace occ8090_fe=83 if occ8090>=830 & occ8090<=839;
replace occ8090_fe=84 if occ8090>=840 & occ8090<=849;
replace occ8090_fe=85 if occ8090>=850 & occ8090<=859;
replace occ8090_fe=86 if occ8090>=860 & occ8090<=869;
replace occ8090_fe=87 if occ8090>=870 & occ8090<=879;
replace occ8090_fe=88 if occ8090>=880 & occ8090<=889;

gen routine=(finger + sts)/(finger + sts + math + dcp + ehf);

keep lwage llowincemp_effective lhigh_effective lowincemp_effective highincemp_effective expmod_effective penmod_effective vsh_effective expfin1_effective impfin1_effective expfin2_effective impfin2_effective expfin3_effective impfin3_effective p_llowincemp_effective_occ p_lhigh_effective_occ p_lowincemp_effective_occ p_highincemp_effective_occ p_expmod_effective_occ p_penmod_effective_occ p_vsh_effective_occ p_expfin1_effective_occ p_impfin1_effective_occ p_expfin2_effective_occ p_impfin2_effective_occ p_expfin3_effective_occ p_impfin3_effective_occ
p_tfp579_effective_occ p_piinv79_effective_occ p_cap79_effective_occ p_labor79_effective_occ p_rpiship79_effective_occ
age female union exper nonwhite year educ routine ihwt man7090_orig man7090 ind7090 occ8090 occ8090_fe state orgwgt lowincemp highincemp expmod79 penmod79 vsh79 piinv79 expfin1 impfin1 expfin2 impfin2 expfin3 impfin3 manuf servs agric yrsed vet
occ80 occ90 finger sts math dcp ehf
f1* f3* f5* f10*
;
keep if year>=1982 & year<=2002;
save ${x}offshore_exposure.dta, replace;

*Manufacturing Employment, by Occupation and Year;
use ${x}offshore_exposure, clear;
keep if man7090~=.;
bysort occ8090 year: egen emp=sum(orgwgt/12);
collapse emp lwage llowincemp_effective lhigh_effective lowincemp_effective highincemp_effective expmod_effective penmod_effective vsh_effective p_llowincemp_effective_occ p_lhigh_effective_occ p_lowincemp_effective_occ p_highincemp_effective_occ p_expmod_effective_occ p_penmod_effective_occ p_vsh_effective_occ p_expfin1_effective_occ p_impfin1_effective_occ p_expfin2_effective_occ p_impfin2_effective_occ p_expfin3_effective_occ p_impfin3_effective_occ age female union exper nonwhite educ routine ihwt man7090_orig man7090 ind7090 state orgwgt lowincemp highincemp expmod79 penmod79 vsh79 piinv79 expfin1 impfin1 expfin2 impfin2 expfin3 impfin3 manuf servs agric yrsed vet, by(occ8090 year) fast;
xtset occ8090 year;
gen lemp=log(emp);
local i=5;
while `i'<=15 {;
gen Dlemp`i'=lemp-L`i'.lemp;  
gen Dllowincemp_effective`i'=llowincemp_effective-L`i'.llowincemp_effective;  
gen Dlhigh_effective`i'=lhigh_effective-L`i'.lhigh_effective;  
gen Dexpmod_effective`i'=expmod_effective-L`i'.expmod_effective; 
gen Dpenmod_effective`i'=penmod_effective-L`i'.penmod_effective; 
gen Dvsh_effective`i'=vsh_effective-L`i'.vsh_effective;
gen Dexpfin1_effective`i'=expfin1_effective-L`i'.expfin1_effective; 
gen Dimpfin1_effective`i'=impfin1_effective-L`i'.impfin1_effective; 
gen p_routine`i'=L`i'.routine;
local i=`i'+5;
};
save ${x}offshore_exposure_mfg_emp.dta, replace;

*Manufacturing Employment, by 2-digit Occupation and Year;
use ${x}offshore_exposure, clear;
keep if man7090~=.;
bysort occ8090 year: egen emp=sum(orgwgt/12);
collapse emp lwage llowincemp_effective lhigh_effective lowincemp_effective highincemp_effective expmod_effective penmod_effective vsh_effective p_llowincemp_effective_occ p_lhigh_effective_occ p_lowincemp_effective_occ p_highincemp_effective_occ p_expmod_effective_occ p_penmod_effective_occ p_vsh_effective_occ p_expfin1_effective_occ p_impfin1_effective_occ p_expfin2_effective_occ p_impfin2_effective_occ p_expfin3_effective_occ p_impfin3_effective_occ age female union exper nonwhite educ routine ihwt man7090_orig man7090 ind7090 state orgwgt lowincemp highincemp expmod79 penmod79 vsh79 piinv79 expfin1 impfin1 expfin2 impfin2 expfin3 impfin3 manuf servs agric yrsed vet, by(occ8090_fe year) fast;
xtset occ8090_fe year;
gen lemp=log(emp);
local i=5;
while `i'<=15 {;
gen Dlemp`i'=lemp-L`i'.lemp;  
gen Dllowincemp_effective`i'=llowincemp_effective-L`i'.llowincemp_effective;  
gen Dlhigh_effective`i'=lhigh_effective-L`i'.lhigh_effective;  
gen Dexpmod_effective`i'=expmod_effective-L`i'.expmod_effective; 
gen Dpenmod_effective`i'=penmod_effective-L`i'.penmod_effective; 
gen Dvsh_effective`i'=vsh_effective-L`i'.vsh_effective;
gen Dexpfin1_effective`i'=expfin1_effective-L`i'.expfin1_effective; 
gen Dimpfin1_effective`i'=impfin1_effective-L`i'.impfin1_effective; 
gen p_routine`i'=L`i'.routine;
local i=`i'+5;
};
save ${x}offshore_exposure_mfg_emp_fe.dta, replace;

*All Employment, by Occupation and Year;
use ${x}offshore_exposure, clear;
bysort occ8090 year: egen emp=sum(orgwgt/12);
collapse emp lwage llowincemp_effective lhigh_effective lowincemp_effective highincemp_effective expmod_effective penmod_effective vsh_effective p_llowincemp_effective_occ p_lhigh_effective_occ p_lowincemp_effective_occ p_highincemp_effective_occ p_expmod_effective_occ p_penmod_effective_occ p_vsh_effective_occ p_expfin1_effective_occ p_impfin1_effective_occ p_expfin2_effective_occ p_impfin2_effective_occ p_expfin3_effective_occ p_impfin3_effective_occ age female union exper nonwhite educ routine ihwt man7090_orig man7090 ind7090 state orgwgt lowincemp highincemp expmod79 penmod79 vsh79 piinv79 expfin1 impfin1 expfin2 impfin2 expfin3 impfin3 manuf servs agric yrsed vet, by(occ8090 year) fast;
xtset occ8090 year;
gen lemp=log(emp);
local i=5;
while `i'<=15 {;
gen Dlemp`i'=lemp-L`i'.lemp;  
gen Dllowincemp_effective`i'=llowincemp_effective-L`i'.llowincemp_effective;  
gen Dlhigh_effective`i'=lhigh_effective-L`i'.lhigh_effective;  
gen Dexpmod_effective`i'=expmod_effective-L`i'.expmod_effective; 
gen Dpenmod_effective`i'=penmod_effective-L`i'.penmod_effective; 
gen Dvsh_effective`i'=vsh_effective-L`i'.vsh_effective;
gen Dexpfin1_effective`i'=expfin1_effective-L`i'.expfin1_effective; 
gen Dimpfin1_effective`i'=impfin1_effective-L`i'.impfin1_effective; 
local i=`i'+5;
};
save ${x}offshore_exposure_emp.dta, replace;

*All Employment, by 2-digit Occupation and Year;
use ${x}offshore_exposure, clear;
bysort occ8090 year: egen emp=sum(orgwgt/12);
bysort occ8090_fe year: egen emp_fe=sum(orgwgt/12);
collapse emp emp_fe lwage llowincemp_effective lhigh_effective lowincemp_effective highincemp_effective expmod_effective penmod_effective vsh_effective p_llowincemp_effective_occ p_lhigh_effective_occ p_lowincemp_effective_occ p_highincemp_effective_occ p_expmod_effective_occ p_penmod_effective_occ p_vsh_effective_occ p_expfin1_effective_occ p_impfin1_effective_occ p_expfin2_effective_occ p_impfin2_effective_occ p_expfin3_effective_occ p_impfin3_effective_occ age female union exper nonwhite educ routine ihwt man7090_orig man7090 ind7090 state orgwgt lowincemp highincemp expmod79 penmod79 vsh79 piinv79 expfin1 impfin1 expfin2 impfin2 expfin3 impfin3 manuf servs agric yrsed vet, by(occ8090_fe year) fast;
xtset occ8090_fe year;
gen lemp=log(emp);
local i=5;
while `i'<=15 {;
gen Dlemp`i'=lemp-L`i'.lemp;  
gen Dllowincemp_effective`i'=llowincemp_effective-L`i'.llowincemp_effective;  
gen Dlhigh_effective`i'=lhigh_effective-L`i'.lhigh_effective;  
gen Dexpmod_effective`i'=expmod_effective-L`i'.expmod_effective; 
gen Dpenmod_effective`i'=penmod_effective-L`i'.penmod_effective; 
gen Dvsh_effective`i'=vsh_effective-L`i'.vsh_effective;
gen Dexpfin1_effective`i'=expfin1_effective-L`i'.expfin1_effective; 
gen Dimpfin1_effective`i'=impfin1_effective-L`i'.impfin1_effective; 
local i=`i'+5;
};
save ${x}offshore_exposure_emp_fe.dta, replace;

erase ${x}temp_emp_ind7090.dta;
erase ${x}temp_import_ind7090.dta;
erase ${x}temp_trade_ind7090.dta;
*erase ${x}temp_price1_ind7090.dta;
*erase ${x}temp_price2_ind7090.dta;
*erase ${x}temp_price3_ind7090.dta;
erase ${x}offshore_exposure_mfg_emp.dta;
erase ${x}offshore_exposure_mfg_emp_fe.dta;
erase ${x}offshore_exposure_emp.dta;
erase ${x}offshore_exposure_emp_fe.dta;
erase $masterpath/trade/trade_offshore_data_wide.dta;
erase ${x}employment_weights.dta;

exit;
*********************************;

