********************************************************************************************************************
* Table 3: OLS Estimates of Wage Determinants Overall, By Occupational Exposure of a Group to Trade and Offshoring *									
********************************************************************************************************************
global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/"
global a "$masterpath/price_data/"

#delimit;
clear;
set more off;
set matsize 5000;

set mem 5g;
global path ~;

capture log close;

/*================================================
 Program: table3.do
 Author:  Avi Ebenstein and Shannon Phillips
 Created: March 2009
 Purpose: Log Wage Regressions with Industry and Two-Digit Occupation Fixed Effects and No Price of Shipments
	   Use offshore_exposure.dta and include all workers
	   Assess effective exposure to outsourcing/trade by occupation
	   (1) years 83-91, (2) years 92-2002, (3) years 83-96
	   (4) years 97-2002, (5) female only, (6) union only
	   (7) 40 plus only,  (8) 50 plus only
=================================================*/

use ${x}merge_micro_man7090.dta, clear;
collapse tfp579 piinv79 rpiship79 cap79 labor79, by(ind7090 year);
tempfile addtradevars;
save `addtradevars', replace;

use ${x}offshore_exposure.dta, clear;
sort ind7090 year;
merge ind7090 year using ${a}price_data_all;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;
collapse price_index, by(occ8090 year);
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
keep if _merge==3;
drop _merge;
sort ind7090 year;
merge ind7090 year using `addtradevars';
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

egen higheduc=mean(educ==3 | educ==4 | educ==5) if educ~=., by(occ8090 year);
label variable higheduc "% workers w/some coll, coll or adv in occ x year";
sort occ8090 year;

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

***********************;
* Run the regressions  ;
***********************;
xi I.ind7090 I.occ8090_fe I.year I.educ I.state;

**************************************************************;
* No Lagged log of real price of shipments using 1979 weights ;	
**************************************************************;
* With lagged trade/offshoring variables at the occ8090 level ;
**************************************************************;

egen occyear=group(occ8090_fe year);
******************;
* Add Computer Use ;
*******************;
log using ${z}table3_r1,text replace;
*****************************************************************************************;
* Industry and two-digit occupation fixed effects, std. errs. clustered at ind7090 level ;
*****************************************************************************************;

*******************;
* (1) years 83-91  ;
*******************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if year>=1983 & year<=1991 [weight=ihwt], robust cluster(occyear);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use using ${z}table3_r1, nolabel ctitle(83-91) title(Table 3: Impact of Effective Exposure to Outsourcing on Log Wage Using Ind & 2-Occ FE, Including Location, Comp Use) replace;

*********************;
* (2) years 92-2002	;
*********************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if year>=1992 & year<=2002 [weight=ihwt], robust cluster(occyear);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use using ${z}table3_r1, nolabel ctitle(92-02) append;

* The w/vsh are not shown;
*************************;
* (3) years 83-91 w/vsh  ;
*************************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_vsh_effective_occ p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if year>=1983 & year<=1991 [weight=ihwt], robust cluster(occyear);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_vsh_effective_occ p_use using ${z}table3_r1, nolabel ctitle(vsh.83-91) append;

***************************;
* (4) years 92-2002	w/vsh ;
***************************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_vsh_effective_occ p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if year>=1992 & year<=2002 [weight=ihwt], robust cluster(occyear);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_vsh_effective_occ p_use using ${z}table3_r1, nolabel ctitle(vsh.92-02) append;

*******************;
* (5) years 83-96  ;
*******************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if year>=1983 & year<=1996 [weight=ihwt], robust cluster(occyear);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use using ${z}table3_r1, nolabel ctitle(83-96) append;

*********************;
* (6) years 97-2002  ;
*********************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if year>=1997 & year<=2002 [weight=ihwt], robust cluster(occyear);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use using ${z}table3_r1, nolabel ctitle(97-02) append;

*********************;
* (7) female only    ;
*********************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if female==1 [weight=ihwt], robust cluster(occyear);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use using ${z}table3_r1, nolabel ctitle(Female) append;

*********************;
* (8) union only     ;
*********************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if union==1 [weight=ihwt], robust cluster(occyear);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use using ${z}table3_r1, nolabel ctitle(Union) append;

*********************;
* (9) Low Educ       ;
*********************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if educ==1 | educ==2 [weight=ihwt], robust cluster(occyear);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use using ${z}table3_r1, nolabel ctitle(LowEduc) append;

*********************;
* (10) High Educ     ;
*********************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if educ==3 | educ==4 | educ==5 [weight=ihwt], robust cluster(occyear);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use using ${z}table3_r1, nolabel ctitle(HighEduc) append;

**********************;
* (11) 40 plus only   ;
**********************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if age>=40 [weight=ihwt], robust cluster(occyear);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use using ${z}table3_r1, nolabel ctitle(Over40) append;

**********************;
* (12) 50 plus only	 ;
**********************;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if age>=50 [weight=ihwt], robust cluster(occyear);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_lpiinv100 p_tfp579 p_expmod_effective_occ p_penmod_effective_occ p_caplabor79 p_use using ${z}table3_r1, nolabel ctitle(Over50) append;

log close;

exit;
*********************************;
