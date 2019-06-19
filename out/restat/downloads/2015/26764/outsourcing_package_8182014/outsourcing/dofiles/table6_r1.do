*********************************************************************************
* Table 6: OLS Estimates of Employment Determinants in Manufacturing, 1983-2002 *
*********************************************************************************
global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/"
 
# delimit ;

capture log close;
clear;
set mem 2000m;
set more off;

use ${x}merge_educ_man7090.dta, clear;
sort man7090_orig year;

do man7090_orig_ind7090.do;
sort ind7090 year;
merge ind7090 year using ${x}compuse_ind7090.dta;
tab _merge;
keep if _merge==3;
drop _merge;
  
xi i.year i.educ i.man7090_orig;

gen lemp=ln(emp_cps);
replace lowincemp=1 if lowincemp==0;
gen llowincemp=log(lowincemp);
gen lhigh=log(highincemp);
gen lpiinv100=ln(piinv79*100);
gen lrpiship79=log(rpiship79); 
gen caplabor79=cap79/labor79/1000;

gen routine=(finger + sts)/(finger + sts + math + dcp + ehf);
gen routine1983=routine if year==1983;

sort man7090_orig educ year;
by man7090_orig educ: egen routine83=max(routine1983);
drop routine1983;
by man7090_orig educ: gen p_llowincemp=llowincemp[_n-1];
by man7090_orig educ: gen p_lhigh=lhigh[_n-1]; 
by man7090_orig educ: gen p_lpiinv100=lpiinv100[_n-1]; 
by man7090_orig educ: gen p_tfp579=tfp579[_n-1]; 
by man7090_orig educ: gen p_expmod79=expmod79[_n-1]; 
by man7090_orig educ: gen p_penmod79=penmod79[_n-1];
by man7090_orig educ: gen p_lrpiship79=lrpiship79[_n-1];
by man7090_orig educ: gen p_routine=routine[_n-1];
by man7090_orig educ: gen p_caplabor79=caplabor79[_n-1];

keep if year>=1983;


log using ${z}table6_r1,text replace;
reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_caplabor79 p_use _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_caplabor79 p_use using ${z}table6_r1, nolabel ctitle(All) title(Table 5: Log US Manufacturing Sector Employment, by Routine Tertile, With Comp Use) replace;
reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_caplabor79 p_use _Iyear* _Iman7090_o* if routine>.66, robust cluster(man7090_orig);

outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_caplabor79 p_use using ${z}table6_r1, nolabel ctitle(Most Routine) append;
reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_caplabor79 p_use _Iyear* _Iman7090_o* if routine>.33 & routine<=.66, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_caplabor79 p_use using ${z}table6_r1, nolabel ctitle(Intermediate Routine) append;
reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_caplabor79 p_use _Iyear* _Iman7090_o* if routine<=.33, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_caplabor79 p_use using ${z}table6_r1, nolabel ctitle(Least Routine) append;

reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79  p_use _Iyear* _Iman7090_o* if routine>.50, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79  p_use using ${z}table6_r1, nolabel ctitle(Most Routine) append;
reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79  p_use _Iyear* _Iman7090_o* if routine<=.50, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79  p_use using ${z}table6_r1, nolabel ctitle(Intermediate Routine) append;



log close;
!gzip ${x}merge_educ_man7090.dta;
!gzip ${x}compuse_ind7090.dta;

exit;
