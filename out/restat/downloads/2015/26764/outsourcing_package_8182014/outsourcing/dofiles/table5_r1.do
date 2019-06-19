*****************************************************************************************************************
* Table 2: OLS Estimates of Wage Determinants using Occupational versus Industry Offshoring Exposure, 1983-2002 *
* Offshoring Measured by Occupation-Specific Exposure, All Sectors							*						
*****************************************************************************************************************
global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/"
global a "$masterpath/price_data/"

#delimit;
clear;
clear mata;
set more off;
set matsize 800;

set mem 5000m;
global path ~;

capture log close;

/*================================================
 Program: table2_occ_tfp.do
 Author:  Avi Ebenstein and Shannon Phillips
 Created: March 2009
 Purpose: On mfg & non-mfg sample
	   Wage Effects using Industry versus Occupational Exposure
	   Industry and Two-Digit Occupation Fixed Effects and No Price of Shipments, by Education
	   Use offshore_exposure.dta to include all workers
	   Assess effective exposure to outsourcing/trade by occupation
=================================================*/

use ${x}merge_micro_man7090.dta, clear;
collapse tfp579 piinv79 rpiship79 cap79 labor79, by(ind7090 year);
tempfile addtradevars;
save `addtradevars', replace;

***********************************;
* Stratified by Routine Tertile	*;
* Computer Use Controls and Prices *;
***********************************;
use ${x}offshore_exposure.dta, clear;
sort ind7090 year;
merge ind7090 year using ${a}price_data_all;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;
collapse price_index, by(occ8090 year) fast;
gen lprice_index=log(price_index);
by occ8090: gen p_lprice_index=lprice_index[_n-1];
sort occ8090 year;
tempfile offshore_prices;
save `offshore_prices', replace;

use ${x}offshore_exposure.dta;
sort occ8090 year;
merge occ8090 year using `offshore_prices';
keep if _merge==3;
drop _merge;
sort occ8090 year;
merge occ8090 year using ${x}compuse_occ8090;
tab _merge;
drop _merge;
sort ind7090 year;
merge ind7090 year using `addtradevars';
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

gen educge16=(educ==4 | educ==5) if educ~=.;
label variable educge16 "College or Advanced Degree";

gen educ13_15=(educ==3) if educ~=.;
label variable educ13_15 "Some College";

gen educle12=(educ==1 | educ==2) if educ~=.;
label variable educle12 "Less Than High School or High School Degree";

gen lpiinv100=ln(piinv79*100);
gen lrpiship79=log(rpiship79); 

gen caplabor79=cap79/labor79/1000;

* Set industry controls equal to 1 for non-manufacturing workers;
replace lpiinv100=1 if man7090==.;
replace lrpiship79=1 if man7090==.; 
replace tfp579=1 if man7090==.;
replace caplabor79=1 if man7090==.;

sort ind7090 year;
by ind7090: gen p_lpiinv100=lpiinv100[_n-1]; 
by ind7090: gen p_tfp579=tfp579[_n-1]; 
by ind7090: gen p_lrpiship79=lrpiship79[_n-1];
by ind7090: gen p_caplabor79=caplabor79[_n-1];

keep if year>=1984;

***********************;
* Run the regressions  ;
***********************;
xi I.ind7090 I.occ8090_fe I.year I.educ I.state;

save ${x}table2_temp, replace;

use ${x}table2_temp, replace;

global tradelist "llowincemp_effective lhigh_effective penmod_effective expmod_effective";
foreach i of global tradelist{;
                              gen `i'_202=`i' if year==2002;
                              bysort occ8090: egen `i'_2002=mean(`i'_202);
                              };
save ${x}table5_micro_temp, replace;
  
**************************************************************;
* No Lagged log of real price of shipments using 1979 weights ;	
**************************************************************;
* With lagged trade/offshoring variables at the occ8090 level ;
**************************************************************;

*****************************************************************************************;
* Industry and two-digit occupation fixed effects, std. errs. clustered at ind7090 level ;
*****************************************************************************************;
* Stratified by Routine Tertile *;
*********************************;

use ${x}table5_micro_temp, clear;

egen yearcat=cut(year),at(1979(5)2010);
tab yearcat;
egen occyear=group(occ8090_fe yearcat);
       
global sample1 "year>=1984 & year<=1989";
global sample2 "year>=1989 & year<=1991";
global sample3 "year>=1992 & year<=1996";
global sample4 "year>=1997 & year<=2002";

log using ${z}table5_r1,text replace;
*All;

reg lwage llowincemp_effective_2002 lhigh_effective_2002 p_lpiinv100 p_caplabor79 p_tfp579 expmod_effective_2002 penmod_effective_2002 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* [weight=ihwt] if $sample1, robust cluster(occyear);
outreg2 llowincemp_effective_2002 lhigh_effective_2002 p_lpiinv100 p_caplabor79 p_tfp579 expmod_effective_2002 penmod_effective_2002 p_use using ${z}table5_r1, nolabel ctitle(All) title(Table 2: Wage Effects of Offshoring Measured by Occupation-Specific Exposure, Using Ind & 2-Occ FE, State FE, by Routine Tertile, Comp Use) replace;

*All;
reg lwage llowincemp_effective_2002 lhigh_effective_2002 p_lpiinv100 p_caplabor79 p_tfp579 expmod_effective_2002 penmod_effective_2002 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* [weight=ihwt] if $sample2, robust cluster(occyear);
outreg2 llowincemp_effective_2002 lhigh_effective_2002 p_lpiinv100 p_caplabor79 p_tfp579 expmod_effective_2002 penmod_effective_2002 p_use using ${z}table5_r1, nolabel ctitle(All) title(Table 2: Wage Effects of Offshoring Measured by Occupation-Specific Exposure, Using Ind & 2-Occ FE, State FE, by Routine Tertile, Comp Use) append;

*All;
reg lwage llowincemp_effective_2002 lhigh_effective_2002 p_lpiinv100 p_caplabor79 p_tfp579 expmod_effective_2002 penmod_effective_2002 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* [weight=ihwt] if $sample3, robust cluster(occyear);
outreg2 llowincemp_effective_2002 lhigh_effective_2002 p_lpiinv100 p_caplabor79 p_tfp579 expmod_effective_2002 penmod_effective_2002 p_use using ${z}table5_r1, nolabel ctitle(All) title(Table 2: Wage Effects of Offshoring Measured by Occupation-Specific Exposure, Using Ind & 2-Occ FE, State FE, by Routine Tertile, Comp Use) append;

*All;
reg lwage llowincemp_effective_2002 lhigh_effective_2002 p_lpiinv100 p_caplabor79 p_tfp579 expmod_effective_2002 penmod_effective_2002 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* [weight=ihwt] if $sample4, robust cluster(occyear);

outreg2 llowincemp_effective_2002 lhigh_effective_2002 p_lpiinv100 p_caplabor79 p_tfp579 expmod_effective_2002 penmod_effective_2002 p_use using ${z}table5_r1, nolabel ctitle(All) title(Table 2: Wage Effects of Offshoring Measured by Occupation-Specific Exposure, Using Ind & 2-Occ FE, Stayte FE, by Routine Tertile, Comp Use) append;

exit;
*********************************;
