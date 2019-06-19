*****************************************************************************************************************
* Table 2: OLS Estimates of Wage Determinants using Occupational versus Industry Offshoring Exposure, 1983-2002 *
* Offshoring Measured by Industry-Specific Exposure, Manufacturing Only						*	
*****************************************************************************************************************
global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/"
global c "$masterpath/dofiles/"
global folder_price_data "$masterpath/price_data/" //Tomer

# delimit ;

capture log close;
clear;
set mem 2000m;
set more off;

*******************;
* Add Computer Use ;
*******************;

use ${x}merge_educ_man7090.dta, clear;
do ${c}man7090_orig_ind7090.do;
sort ind7090 year;
merge ind7090 year using ${folder_price_data}price_data_all;
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

*logs or levels?;
gen caplabor79=cap79/labor79/1000;

sort man7090_orig educ year;
by man7090_orig educ: gen p_llowincemp=llowincemp[_n-1];
by man7090_orig educ: gen p_lhigh=lhigh[_n-1]; 
by man7090_orig educ: gen p_lpiinv100=lpiinv100[_n-1]; 
by man7090_orig educ: gen p_tfp579=tfp579[_n-1]; 
by man7090_orig educ: gen p_expmod79=expmod79[_n-1]; 
by man7090_orig educ: gen p_penmod79=penmod79[_n-1];
by man7090_orig educ: gen p_lrpiship79=lrpiship79[_n-1];
by man7090_orig educ: gen p_caplabor79=caplabor79[_n-1];
by man7090_orig educ: gen p_lprice_index=lprice_index[_n-1];

sort man7090_orig year;
tempfile merge_educ_man7090_temp;
save `merge_educ_man7090_temp', replace;

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

gen educge16=(educ==4 | educ==5) if educ~=.;
label variable educge16 "College or advanced degree";

gen educ13_15=(educ==3) if educ~=.;
label variable educ13_15 "Some College";

gen educle12=(educ==1 | educ==2) if educ~=.;
label variable educle12 "Less Than High School or High School Degree";

gen routine=(finger + sts)/(finger + sts + math + dcp + ehf);

keep if year>=1984;

xi I.year I.educ I.man7090_orig I.state;

*********************************;
* Stratified by Routine Tertile *;
*********************************;

egen yearcat=cut(year),at(1984(5)2010);
tab yearcat;
egen indyear=group(man7090_orig yearcat);

log using ${z}table2_ind,text replace;
*All;
reg lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 /* p_lrpiship */ p_caplabor79  p_use age female union exper nonwhite _Iyear* _Ieduc* _Iman7090_o* _Istate* [weight=ihwt], robust cluster(indyear);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 /* p_lrpiship */ p_caplabor79  p_use using ${z}table2_ind_r1, nolabel ctitle(All) title(Table 2: Wage Effects of Offshoring, Industry-Specific Exposure, State FE, by Routine Tertile, 1983-2002, Comp Use) replace;

*Most Routine (routine>.66);
reg lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 /* p_lrpiship */ p_caplabor79  p_use age female union exper nonwhite _Iyear* _Ieduc* _Iman7090_o* _Istate* if routine>.66 [weight=ihwt], robust cluster(indyear);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 /* p_lrpiship */ p_caplabor79  p_use using ${z}table2_ind_r1, nolabel ctitle(Most Routine) append;

*Intermediate Routine (routine>.33 & routine<=.66); 
reg lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 /* p_lrpiship */ p_caplabor79  p_use age female union exper nonwhite _Iyear* _Ieduc* _Iman7090_o* _Istate* if routine>.33 & routine<=.66 [weight=ihwt], robust cluster(indyear);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 /* p_lrpiship */ p_caplabor79  p_use using ${z}table2_ind_r1, nolabel ctitle(Intermediate Routine) append;

*Least Routine (routine<=.33);
reg lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 /* p_lrpiship */ p_caplabor79  p_use age female union exper nonwhite _Iyear* _Ieduc* _Iman7090_o* _Istate* if routine<=.33 [weight=ihwt], robust cluster(indyear);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 /* p_lrpiship */ p_caplabor79  p_use using ${z}table2_ind_r1, nolabel ctitle(Least Routine) append;
log close;

exit;
