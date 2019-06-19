**************************************************************************************************************
* Table A4: Robustness of OLS Estimates of Wage Determinants to using Import Prices instead of Quantities,   * 
* using Occupational versus Industry Offshoring Exposure, 1983-2002						    *
**************************************************************************************************************
global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/appendix/"
global c "$masterpath/dofiles/"
global d "$masterpath/lawrence/"
global e "$masterpath/datafiles/prices/"

#delimit;
clear;
clear mata;
set more off;
set matsize 800;

set mem 5000m;
global path ~;

capture log close;

**************************************************************************************************************; 
* Re-running table2_ind.do replacing p_penmod79 with importprice and p_expmod79 with p_expfin1_effective_occ *;
**************************************************************************************************************;
*******************;
* Add Computer Use ;
*******************;
use ${x}merge_educ_man7090.dta, clear;
do ${c}man7090_orig_ind7090.do;
sort ind7090 year;
merge ind7090 year using ${x}price_data_all;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

gen lemp=ln(emp_cps);
replace lowincemp=1 if lowincemp==0;
gen llowincemp=log(lowincemp);
gen lhigh=log(highincemp);
gen lpiinv100=ln(piinv79*100);
gen lrpiship79=log(rpiship79); 
gen lprice_index=log(price_index);

sort man7090_orig educ year;
by man7090_orig educ: gen p_llowincemp=llowincemp[_n-1];
by man7090_orig educ: gen p_lhigh=lhigh[_n-1]; 
by man7090_orig educ: gen p_lpiinv100=lpiinv100[_n-1]; 
by man7090_orig educ: gen p_tfp579=tfp579[_n-1]; 
by man7090_orig educ: gen p_expmod79=expmod79[_n-1]; 
by man7090_orig educ: gen p_penmod79=penmod79[_n-1];
by man7090_orig educ: gen p_lrpiship79=lrpiship79[_n-1];
by man7090_orig educ: gen p_lprice_index=lprice_index[_n-1];

sort man7090_orig year;
tempfile merge_educ_man7090_temp;
save `merge_educ_man7090_temp', replace;

!gunzip ${x}merge_micro_man7090.dta.gz;
!gunzip ${x}compuse_ind7090.dta.gz;
use ${x}merge_micro_man7090, clear;
drop expmod79 penmod79 totemp totemp79;
sort man7090_orig year;
merge man7090_orig year using `merge_educ_man7090_temp';
drop if _merge==2;
drop _merge;
sort ind7090 year;
merge ind7090 year using ${x}compuse_ind7090.dta;
tab _merge;
keep if _merge==3;
sort man7090_orig year;
drop _merge;

*************************;
* Merge on import prices ;
*************************;
merge man7090_orig year using ${d}importprices.dta;
tab _merge;
drop _merge;

*************************;
* Merge on export prices ;
*************************;
sort man7090 year;
merge man7090 year using ${e}man7090_sic1.dta;
tab _merge;
keep if _merge==3;
drop _merge;

gen p_importprice=importprice[_n-1];
gen p_expfin=expfin[_n-1];

gen educge16=(educ==4 | educ==5) if educ~=.;
label variable educge16 "College or advanced degree";

gen educ13_15=(educ==3) if educ~=.;
label variable educ13_15 "Some College";

gen educle12=(educ==1 | educ==2) if educ~=.;
label variable educle12 "Less Than High School or High School Degree";

gen routine=(finger + sts)/(finger + sts + math + dcp + ehf);

keep if year>=1983;

xi I.year I.educ I.man7090_orig I.state;

*********************************;
* Stratified by Routine Tertile *;
*********************************;
log using ${z}appendixtableA4,text replace;
*All;
reg lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expfin p_importprice p_lrpiship79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iman7090_o* _Istate* [weight=ihwt], robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expfin p_importprice p_lrpiship79 p_use using ${z}appendixtableA4, nolabel ctitle(All) title(Appendix Table A4: Robustness of Wage Effects of Offshoring to using import price instead of import penetration, export price instead of export shares, Industry-Specific Exposure, State FE, by Routine Tertile, 1997-2002, Comp Use) replace;

*Most Routine (routine>.66);
reg lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expfin p_importprice p_lrpiship79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iman7090_o* _Istate* if routine>.66 [weight=ihwt], robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expfin p_importprice p_lrpiship79 p_use using ${z}appendixtableA4, nolabel ctitle(Most Routine) append;

*Intermediate Routine (routine>.33 & routine<=.66); 
reg lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expfin p_importprice p_lrpiship79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iman7090_o* _Istate* if routine>.33 & routine<=.66 [weight=ihwt], robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expfin p_importprice p_lrpiship79 p_use using ${z}appendixtableA4, nolabel ctitle(Intermediate Routine) append;

*Least Routine (routine<=.33);
reg lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expfin p_importprice p_lrpiship79 p_use age female union exper nonwhite _Iyear* _Ieduc* _Iman7090_o* _Istate* if routine<=.33 [weight=ihwt], robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expfin p_importprice p_lrpiship79 p_use using ${z}appendixtableA4, nolabel ctitle(Least Routine) append;


**************************************************************************************************************************************; 
* Re-running table2_occ.do replacing p_penmod_effective_occ with importprice and p_expmod_effective_occ with p_expfin1_effective_occ *;
**************************************************************************************************************************************;
***********************************;
* Stratified by Routine Tertile	*;
* Computer Use Controls and Prices *;
***********************************;
use ${x}offshore_exposure.dta, clear;
sort ind7090 year;
merge ind7090 year using ${x}price_data_all;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;
collapse price_index, by(occ8090 year) fast;
gen lprice_index=log(price_index);
by occ8090: gen p_lprice_index=lprice_index[_n-1];
sort occ8090 year;
tempfile offshore_prices;
save `offshore_prices', replace;

*************************;
* Merge on import prices ;
*************************;
use ${d}importprices.dta;
do ${c}man7090_orig_ind7090.do;
sort ind7090 year;
tempfile importprices_ind7090;
save `importprices_ind7090', replace;

use ${x}offshore_exposure.dta, clear;
sort ind7090 year;
merge ind7090 year using `importprices_ind7090';
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;
collapse importprice, by(occ8090 year) fast;
gen limportprice=log(importprice);
by occ8090: gen p_importprice=importprice[_n-1];
by occ8090: gen p_limportprice=limportprice[_n-1];
sort occ8090 year;
tempfile offshore_importprices;
save `offshore_importprices', replace;

!gunzip ${x}compuse_occ8090.dta.gz;
use ${x}offshore_exposure.dta;
sort occ8090 year;
merge occ8090 year using `offshore_prices';
keep if _merge==3;
drop _merge;
sort occ8090 year;
merge occ8090 year using `offshore_importprices';
keep if _merge==3;
drop _merge;
sort occ8090 year;
merge occ8090 year using ${x}compuse_occ8090;
tab _merge;
drop _merge;

gen educge16=(educ==4 | educ==5) if educ~=.;
label variable educge16 "College or Advanced Degree";

gen educ13_15=(educ==3) if educ~=.;
label variable educ13_15 "Some College";

gen educle12=(educ==1 | educ==2) if educ~=.;
label variable educle12 "Less Than High School or High School Degree";

keep if year>=1984;

***********************;
* Run the regressions  ;
***********************;
xi I.ind7090 I.occ8090_fe I.year I.educ I.state;

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

*All;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expfin1_effective_occ p_importprice p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* [weight=ihwt], robust cluster(ind7090);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_expfin1_effective_occ p_importprice p_use using ${z}appendixtableA4, nolabel ctitle(All) append;

*Most Routine (routine>.66);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expfin1_effective_occ p_importprice p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if routine>.66 [weight=ihwt], robust cluster(ind7090);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_expfin1_effective_occ p_importprice p_use using ${z}appendixtableA4, nolabel ctitle(Most Routine) append;

*Moderate Routine (routine>.33 & routine<=.66); 
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expfin1_effective_occ p_importprice p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if routine>.33 & routine<=.66 [weight=ihwt], robust cluster(ind7090);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_expfin1_effective_occ p_importprice p_use using ${z}appendixtableA4, nolabel ctitle(Intermediate Routine) append;

*Least Routine (routine<=.33);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expfin1_effective_occ p_importprice p_use age female union exper nonwhite _Iyear* _Ieduc* _Iind7090* _Iocc8090* _Istate* if routine<=.33 [weight=ihwt], robust cluster(ind7090);
outreg2 p_llowincemp_effective_occ p_lhigh_effective_occ p_expfin1_effective_occ p_importprice p_use using ${z}appendixtableA4, nolabel ctitle(Least Routine) append;

!gzip ${x}merge_micro_man7090.dta;
!gzip ${x}compuse_ind7090.dta;
!gzip ${x}compuse_occ8090.dta;

log close;
