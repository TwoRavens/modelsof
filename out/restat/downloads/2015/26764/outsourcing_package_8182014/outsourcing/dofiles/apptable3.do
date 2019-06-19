global a "$masterpath/datafiles/prices/copy/"
global b "$masterpath/dofiles/"
global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/appendix/"
 
# delimit ;

******************************************************************************************;
* Appendix Table A2: Robustness Checks of Estimates of Employment Determinants, 1983-2002 ;
******************************************************************************************;
capture log close;
clear;
clear mata;
set mem 2000m;
set matsize 10000;
set more off;
!gunzip ${x}merge_educ_man7090.dta;
use ${x}merge_educ_man7090.dta;
sort man7090_orig year;

/*
drop expmod79 penmod79 totemp totemp79;
merge man7090_orig year using ${y}investment_prices;
drop _merge;
sort man7090_orig year;
merge man7090_orig year using ${y}tfp_data;
drop _merge;
sort man7090_orig year;
merge man7090_orig year using ${y}import_data;
drop _merge;
sort man7090_orig year educ;
merge man7090_orig year educ using ${y}employment_data;
sort man7090_orig year educ;
*/
  
xi i.year i.educ i.man7090_orig;

gen lemp=ln(emp_cps);
replace lowincemp=1 if lowincemp==0;
gen llowincemp=log(lowincemp);
gen lhigh=log(highincemp);
gen lpiinv100=ln(piinv79*100);
gen lrpiship79=log(rpiship79); 

sort man7090_orig educ year;
by man7090_orig educ: gen p_llowincemp=llowincemp[_n-1];
by man7090_orig educ: gen p_lhigh=lhigh[_n-1]; 
by man7090_orig educ: gen p_lpiinv100=lpiinv100[_n-1]; 
by man7090_orig educ: gen p_tfp579=tfp579[_n-1]; 
by man7090_orig educ: gen p_expmod79=expmod79[_n-1]; 
by man7090_orig educ: gen p_penmod79=penmod79[_n-1];
by man7090_orig educ: gen p_lrpiship79=lrpiship79[_n-1];

keep if year>=1983;
 
log using ${z}appendixtableA2,text replace;
corr p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_lrpiship79; 

reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_lrpiship79  _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_lrpiship79 using ${z}appendixtableA2, nolabel ctitle(All) title(Appendix Table A2: Robustness Checks on Log US Manufacturing Sector Employment) replace;

reg lemp p_llowincemp p_lhigh p_lpiinv100 p_expmod79 p_penmod79 p_lrpiship79  _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_expmod79 p_penmod79 p_lrpiship79 using ${z}appendixtableA2, nolabel ctitle(All) append;

reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_lrpiship79  _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_lrpiship79 using ${z}appendixtableA2, nolabel ctitle(All) append;

reg lemp p_llowincemp p_lhigh p_lpiinv100 p_expmod79 p_lrpiship79  _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_expmod79 p_lrpiship79 using ${z}appendixtableA2, nolabel ctitle(All) append;

reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 using ${z}appendixtableA2, nolabel ctitle(All) append;

reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_penmod79 p_lrpiship79  _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_penmod79 p_lrpiship79 using ${z}appendixtableA2, nolabel ctitle(All) append;

reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_lrpiship79  _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_lrpiship79 using ${z}appendixtableA2, nolabel ctitle(All) append;

reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_lrpiship79  _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_lrpiship79 using ${z}appendixtableA2, nolabel ctitle(All) append;

!gunzip ${a}merge_educ_tot1dig_man7090.dta.gz;
use ${a}merge_educ_tot1dig_man7090.dta, clear;
gen lemp=ln(emp_cps);
replace lowincemp=1 if lowincemp==0;
gen llowincemp=log(lowincemp);
gen lhigh=log(highincemp);
gen lpiinv100=ln(piinv79*100);
gen lrpiship79=log(rpiship79); 
gen lexpfin=log(expfin);
gen limpfin=log(impfin);

sort man7090_orig educ year;
by man7090_orig educ: gen p_llowincemp=llowincemp[_n-1];
by man7090_orig educ: gen p_lhigh=lhigh[_n-1]; 
by man7090_orig educ: gen p_lpiinv100=lpiinv100[_n-1]; 
by man7090_orig educ: gen p_tfp579=tfp579[_n-1]; 
by man7090_orig educ: gen p_expmod79=expmod79[_n-1]; 
by man7090_orig educ: gen p_penmod79=penmod79[_n-1];
by man7090_orig educ: gen p_lrpiship79=lrpiship79[_n-1];
by man7090_orig educ: gen p_lexpfin=lexpfin[_n-1];
by man7090_orig educ: gen p_limpfin=limpfin[_n-1];

keep if year>=1983;

xi i.year i.educ i.man7090_orig;

reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_lrpiship79 p_lexpfin p_limpfin _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_lrpiship79 p_lexpfin p_limpfin using ${z}appendixtableA2, nolabel ctitle(1dig) append;

!gunzip ${a}merge_educ_tot2dig_man7090.dta.gz;
use ${a}merge_educ_tot2dig_man7090.dta, clear;
gen lemp=ln(emp_cps);
replace lowincemp=1 if lowincemp==0;
gen llowincemp=log(lowincemp);
gen lhigh=log(highincemp);
gen lpiinv100=ln(piinv79*100);
gen lrpiship79=log(rpiship79); 
gen lexpfin=log(expfin);
gen limpfin=log(impfin);

sort man7090_orig educ year;
by man7090_orig educ: gen p_llowincemp=llowincemp[_n-1];
by man7090_orig educ: gen p_lhigh=lhigh[_n-1]; 
by man7090_orig educ: gen p_lpiinv100=lpiinv100[_n-1]; 
by man7090_orig educ: gen p_tfp579=tfp579[_n-1]; 
by man7090_orig educ: gen p_expmod79=expmod79[_n-1]; 
by man7090_orig educ: gen p_penmod79=penmod79[_n-1];
by man7090_orig educ: gen p_lrpiship79=lrpiship79[_n-1];
by man7090_orig educ: gen p_lexpfin=lexpfin[_n-1];
by man7090_orig educ: gen p_limpfin=limpfin[_n-1];

keep if year>=1983;

xi i.year i.educ i.man7090_orig;

reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_lrpiship79 p_lexpfin p_limpfin _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_lrpiship79 p_lexpfin p_limpfin using ${z}appendixtableA2, nolabel ctitle(2dig) append;

!gunzip ${a}merge_educ_tot3dig_man7090.dta.gz;
use ${a}merge_educ_tot3dig_man7090.dta, clear;
gen lemp=ln(emp_cps);
replace lowincemp=1 if lowincemp==0;
gen llowincemp=log(lowincemp);
gen lhigh=log(highincemp);
gen lpiinv100=ln(piinv79*100);
gen lrpiship79=log(rpiship79); 
gen lexpfin=log(expfin);
gen limpfin=log(impfin);

sort man7090_orig educ year;
by man7090_orig educ: gen p_llowincemp=llowincemp[_n-1];
by man7090_orig educ: gen p_lhigh=lhigh[_n-1]; 
by man7090_orig educ: gen p_lpiinv100=lpiinv100[_n-1]; 
by man7090_orig educ: gen p_tfp579=tfp579[_n-1]; 
by man7090_orig educ: gen p_expmod79=expmod79[_n-1]; 
by man7090_orig educ: gen p_penmod79=penmod79[_n-1];
by man7090_orig educ: gen p_lrpiship79=lrpiship79[_n-1];
by man7090_orig educ: gen p_lexpfin=lexpfin[_n-1];
by man7090_orig educ: gen p_limpfin=limpfin[_n-1];

keep if year>=1983;

xi i.year i.educ i.man7090_orig;

reg lemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_lrpiship79 p_lexpfin p_limpfin _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
outreg2 p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_lrpiship79 p_lexpfin p_limpfin using ${z}appendixtableA2, nolabel ctitle(3dig) append;


***************************;
* Arellano-Bond Estimates *;
****************************************************************************;
* Need to use man7090_orig-year data set instead of man7090_orig-educ-year *;
* as need to set panel and time vars for xtset. Repeated time variables    *;
* w/in panel require man7090_orig-year data when 'xtset man7090_orig year' *;
****************************************************************************;
!gunzip ${x}trade_man7090.dta.gz;
use ${x}trade_man7090.dta, clear;
keep man7090 year rpiship79 tfp579;
sort man7090 year;
gen lrpiship79=log(rpiship79);
save ${x}temp_lrpiship.dta, replace;

!gunzip ${x}merge_man7090.dta;
use ${x}merge_man7090.dta, clear;
sort man7090 year;
merge man7090 year using ${x}temp_lrpiship.dta;
tab _merge;
drop if _merge==2;
drop _merge;
sort man7090_orig year;

xtset man7090_orig year;

xi i.year i.man7090_orig;

gen lemp=ln(emp_cps);
replace lowincemp=1 if lowincemp==0;
gen llowincemp=log(lowincemp);
gen lhigh=log(highincemp);
gen lpiinv100=ln(piinv79*100);

sort man7090_orig year;
by man7090_orig: gen p_llowincemp=llowincemp[_n-1];
by man7090_orig: gen p_lhigh=lhigh[_n-1]; 
by man7090_orig: gen p_lpiinv100=lpiinv100[_n-1]; 
by man7090_orig: gen p_tfp579=tfp579[_n-1]; 
by man7090_orig: gen p_expmod79=expmod79[_n-1]; 
by man7090_orig: gen p_penmod79=penmod79[_n-1];
by man7090_orig: gen p_lrpiship79=lrpiship79[_n-1];

bysort man7090_orig: gen time=_n;

keep if year>=1983;

*cannot use cluster(man7090_orig); 
xtabond lemp llowincemp lhigh p_lpiinv100 p_tfp579 p_lrpiship79 _Iyear* _Iman7090_o*, vce(robust) lag(1);
outreg2 L.lemp llowincemp lhigh p_lpiinv100 p_tfp579 p_lrpiship79 using ${z}appendixtableA2, nolabel ctitle(xtabond) append;

xtabond lemp llowincemp lhigh p_lpiinv100 p_tfp579 p_lrpiship79 time _Iyear* _Iman7090_o*, vce(robust) lag(1);
outreg2 L.lemp llowincemp lhigh p_lpiinv100 p_tfp579 p_lrpiship79 time using ${z}appendixtableA2, nolabel ctitle(xtabond-time) append;


!gzip ${a}merge_educ_tot1dig_man7090.dta;
!gzip ${a}merge_educ_tot2dig_man7090.dta;
!gzip ${a}merge_educ_tot3dig_man7090.dta;

log close;
exit;
