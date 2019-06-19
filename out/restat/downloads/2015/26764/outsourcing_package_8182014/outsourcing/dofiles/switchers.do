global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/newtables/"
global a "$masterpath/computer/"
  
# delimit ;
clear;
set matsize 800;
capture log close;
set more off;
set mem 2000m;

use ${x}switchers.dta, replace;
gen occ8090=occ80901;
drop year;
gen year=year1;
sort occ8090 year;
merge occ8090 year using ${a}compuse_occ8090.dta;
keep if _merge==3;
drop _merge;

keep if year>=1983;
****************************************************************************************;
* Create interaction terms between leaving a sector and offshoring/import competition: *; 
* it is the coefficient on the interaction we care about, not the level effect 	   *; 
****************************************************************************************;
gen leftmfgXllowincempdiff=leftmfg*llowincempdiff; 
gen leftmfgXlhighdiff=leftmfg*lhighdiff; 
gen leftmfgXpenmod79diff=leftmfg*penmod79diff; 

gen leftmfgXDllowincemp=leftmfg*Dllowincemp_effective; 
gen leftmfgXDlhigh=leftmfg*Dlhigh_effective; 
gen leftmfgXDpenmod=leftmfg*Dpenmod_effective; 

egen medroutine=median(routine1);
gen Iroutine=(routine1>=medroutine) if routine1~=.;
gen leftmfgXIroutine=leftmfg*Iroutine;

xi i.year1 i.man7090_orig1 i.state1;

gen educge16=(educ1==4 | educ1==5) if educ1~=.;
label variable educge16 "College or Advanced Degree in Period 1";

gen educ13_15=(educ1==3) if educ1~=.;
label variable educ13_15 "Some College in Period 1";

gen educle12=(educ1==1 | educ1==2) if educ1~=.;
label variable educle12 "Less Than High School or High School Degree in Period 1";

********************************************************************************;
* NOTE: lrpiship79 is lagged log of real price of shipments using 1979 weights *;	
* lrpiship79t_1 is log of real price of shipments using 1979 weights.          *;
********************************************************************************;

by man7090_orig educ: gen p_llowincemp=llowincemp[_n-1];
by man7090_orig educ: gen p_lhigh=lhigh[_n-1]; 
by man7090_orig educ: gen p_lpiinv100=lpiinv100[_n-1]; 
by man7090_orig educ: gen p_tfp579=tfp579[_n-1]; 
by man7090_orig educ: gen p_expmod79=expmod79[_n-1]; 
by man7090_orig educ: gen p_penmod79=penmod79[_n-1];
by man7090_orig educ: gen p_lrpiship79=lrpiship79[_n-1];
by man7090_orig educ: gen p_routine=routine[_n-1];

save ${x}temp.dta, replace;
	
***************************************************;
* Stratified by Most, Intermediate, Least Routine *;
***************************************************;
/*
log using ${z}switchers,text replace;
*All Education;
reg lwagediff leftmfg llowincempdiff leftmfgXllowincempdiff lhighdiff leftmfgXlhighdiff lpiinv79diff tfp579diff expmod79diff penmod79diff leftmfgXpenmod79diff lrpiship79 age1 female1 nonwhite1 educ1 exper1 union1 _Iyear1_* _Iman7090_* _Istate*;
outreg2 leftmfg llowincempdiff leftmfgXllowincempdiff lhighdiff leftmfgXlhighdiff lpiinv79diff tfp579diff expmod79diff penmod79diff leftmfgXpenmod79diff lrpiship79 using ${z}switchers, nolabel ctitle(All) title(Table 6: Matched CPS Wage Regressions, by Routine) replace;

*Most Routine (routine>.66);
reg lwagediff leftmfg llowincempdiff leftmfgXllowincempdiff lhighdiff leftmfgXlhighdiff lpiinv79diff tfp579diff expmod79diff penmod79diff leftmfgXpenmod79diff lrpiship79 age1 female1 nonwhite1 educ1 exper1 union1 _Iyear1_* _Iman7090_* _Istate* if routine1>.66;
outreg2 leftmfg llowincempdiff leftmfgXllowincempdiff lhighdiff leftmfgXlhighdiff lpiinv79diff tfp579diff expmod79diff penmod79diff leftmfgXpenmod79diff lrpiship79 using ${z}switchers, nolabel ctitle(Most Routine) append;

*Intermediate Routine (routine>.33 & routine<.66);
reg lwagediff leftmfg llowincempdiff leftmfgXllowincempdiff lhighdiff leftmfgXlhighdiff lpiinv79diff tfp579diff expmod79diff penmod79diff leftmfgXpenmod79diff lrpiship79 age1 female1 nonwhite1 educ1 exper1 union1 _Iyear1_* _Iman7090_* _Istate* if routine1>.33 & routine1<=.66;
outreg2 leftmfg llowincempdiff leftmfgXllowincempdiff lhighdiff leftmfgXlhighdiff lpiinv79diff tfp579diff expmod79diff penmod79diff leftmfgXpenmod79diff lrpiship79 using ${z}switchers, nolabel ctitle(Intermediate Routine) append;

*Least Routine (routine<.33);
reg lwagediff leftmfg llowincempdiff leftmfgXllowincempdiff lhighdiff leftmfgXlhighdiff lpiinv79diff tfp579diff expmod79diff penmod79diff leftmfgXpenmod79diff lrpiship79 age1 female1 nonwhite1 educ1 exper1 union1 _Iyear1_* _Iman7090_* _Istate* if routine1<=.33;
outreg2 leftmfg llowincempdiff leftmfgXllowincempdiff lhighdiff leftmfgXlhighdiff lpiinv79diff tfp579diff expmod79diff penmod79diff leftmfgXpenmod79diff lrpiship79 using ${z}switchers, nolabel ctitle(Least Routine) append;
log close;

*********************************************************;
* Stratified by Most, Intermediate, Least Routine 	*;
* Using Offshore Exposure Measures	          	   	*;
*********************************************************;
log using ${z}switchers_effective,text replace;
*All Education;
reg lwagediff leftmfg Dllowincemp_effective leftmfgXDllowincemp Dlhigh_effective leftmfgXDlhigh Dpenmod_effective leftmfgXDpenmod p_use age1 female1 nonwhite1 educ1 exper1 union1 _Iyear1_* _Iocc8090* _Istate*;
outreg2 leftmfg Dllowincemp_effective leftmfgXDllowincemp Dlhigh_effective leftmfgXDlhigh Dpenmod_effective leftmfgXDpenmod p_use using ${z}switchers_effective, nolabel ctitle(All) title(Table 6: Matched CPS Wage Regressions, by Rountine) replace;

*Most Routine (routine>.66);
reg lwagediff leftmfg Dllowincemp_effective leftmfgXDllowincemp Dlhigh_effective leftmfgXDlhigh Dpenmod_effective leftmfgXDpenmod p_use age1 female1 nonwhite1 educ1 exper1 union1 _Iyear1_* _Iocc8090* _Istate* if routine1>.66;
outreg2 leftmfg Dllowincemp_effective leftmfgXDllowincemp Dlhigh_effective leftmfgXDlhigh Dpenmod_effective leftmfgXDpenmod p_use using ${z}switchers_effective, nolabel ctitle(Most Routine) append;

*Intermediate Routine (routine>.33 & routine<.66);
reg lwagediff leftmfg Dllowincemp_effective leftmfgXDllowincemp Dlhigh_effective leftmfgXDlhigh Dpenmod_effective leftmfgXDpenmod p_use age1 female1 nonwhite1 educ1 exper1 union1 _Iyear1_* _Iocc8090* _Istate* if routine1>.33 & routine1<=.66;
outreg2 leftmfg Dllowincemp_effective leftmfgXDllowincemp Dlhigh_effective leftmfgXDlhigh Dpenmod_effective leftmfgXDpenmod p_use using ${z}switchers_effective, nolabel ctitle(Intermediate Routine) append;

*Least Routine (routine<.33);
reg lwagediff leftmfg Dllowincemp_effective leftmfgXDllowincemp Dlhigh_effective leftmfgXDlhigh Dpenmod_effective leftmfgXDpenmod p_use age1 female1 nonwhite1 educ1 exper1 union1 _Iyear1_* _Iocc8090* _Istate* if routine1<=.33;
outreg2 leftmfg Dllowincemp_effective leftmfgXDllowincemp Dlhigh_effective leftmfgXDlhigh Dpenmod_effective leftmfgXDpenmod p_use using ${z}switchers_effective, nolabel ctitle(Least Routine) append;
log close;

*/
use ${x}temp.dta, replace;
/*
reg leftmfg Dllowincemp* Dlhigh* Dexpmod* Dpenmod* age1 female1 nonwhite1 exper1 union1 _Iyear1* _Iman7090*  if manuf1==1 [w=orgwgt1];
outreg2 Dllowincemp* Dlhigh* Dexpmod* Dpenmod* using ${x}switchers.out, replace;
reg leftmfg Dllowincemp* Dlhigh* Dexpmod* Dpenmod* age1 female1 nonwhite1 exper1 union1 _Iyear1* _Iman7090*  if manuf1==1 & routine1>.66 [w=orgwgt1];
outreg2 Dllowincemp* Dlhigh* Dexpmod* Dpenmod* using ${x}switchers.out, append;
reg leftmfg Dllowincemp* Dlhigh* Dexpmod* Dpenmod* age1 female1 nonwhite1 exper1 union1 _Iyear1* _Iman7090*  if manuf1==1 & routine1>=.33 & routine1<=.66 [w=orgwgt1];
outreg2 Dllowincemp* Dlhigh* Dexpmod* Dpenmod* using ${x}switchers.out, append;
reg leftmfg Dllowincemp* Dlhigh* Dexpmod* Dpenmod* age1 female1 nonwhite1 exper1 union1 _Iyear1* _Iman7090*  if manuf1==1 & routine1<.33 [w=orgwgt1];
outreg2 Dllowincemp* Dlhigh* Dexpmod* Dpenmod* using ${x}switchers.out, append;
exit;
*/
keep if year>=1995;
global controls "lpiinv79 tfp579 lrpiship79";
reg leftmfglemp p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_lrpiship79 p_use _Iyear* _Ieduc* _Iman7090_o*, robust cluster(man7090_orig);
cjk;
reg leftmfg p_llowincemp* p_lhigh* p_expmod* p_penmod* age1 female1 nonwhite1 exper1 union1 _Iyear1* _Iman7090*  $controls if manuf1==1 [w=orgwgt1];
outreg2 p_llowincemp* p_lhigh* p_expmod* p_penmod* using ${x}switchers.out, replace;
reg leftmfg p_llowincemp* p_lhigh* p_expmod* p_penmod* age1 female1 nonwhite1 exper1 union1 _Iyear1* _Iman7090*  $controls if manuf1==1 & routine1>.66 [w=orgwgt1];
outreg2 p_llowincemp* p_lhigh* p_expmod* p_penmod* using ${x}switchers.out, append;
reg leftmfg p_llowincemp* p_lhigh* p_expmod* p_penmod* age1 female1 nonwhite1 exper1 union1 _Iyear1* _Iman7090*  $controls if manuf1==1 & routine1>=.33 & routine1<=.66 [w=orgwgt1];
outreg2 p_llowincemp* p_lhigh* p_expmod* p_penmod* using ${x}switchers.out, append;
reg leftmfg p_llowincemp* p_lhigh* p_expmod* p_penmod* age1 female1 nonwhite1 exper1 union1 _Iyear1* _Iman7090*  $controls if manuf1==1 & routine1<.33 [w=orgwgt1];
outreg2 p_llowincemp* p_lhigh* p_expmod* p_penmod* using ${x}switchers.out, append;

type ${x}switchers.out;



cjk;
reg lwagediff  Dllowincemp_effective leftmfgXDllowincemp Dlhigh_effective leftmfgXDlhigh Dpenmod_effective leftmfgXDpenmod p_use age1 female1 nonwhite1 educ1 exper1 union1 _Iyear1_* _Iocc8090* _Istate*;
outreg2 leftmfg Dllowincemp_effective leftmfgXDllowincemp Dlhigh_effective leftmfgXDlhigh Dpenmod_effective leftmfgXDpenmod p_use using ${z}switchers_effective, nolabel ctitle(All) title(Table 6: Matched CPS Wage Regressions, by Rountine) replace;


exit;
