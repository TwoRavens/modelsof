*************************************************************************************************************************************
* Table 8: Wage Changes Among All Workers Observed 2 Periods by Industry- and Occupation-Specific Exposure to Offshoring, 1983-2002 *									
*************************************************************************************************************************************						
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

!gunzip ${x}switchers.dta.gz;
!gunzip ${a}compuse_occ8090.dta.gz;
!gunzip ${x}compuse_ind7090.dta.gz;
use ${x}switchers.dta, replace;
gen occ8090=occ80901;
drop year;
gen year=year1;
sort occ8090 year;
merge occ8090 year using ${a}compuse_occ8090.dta;
keep if _merge==3;
drop _merge;
rename use use_occ;
rename p_use p_use_occ;

gen ind7090=ind70901;
sort ind7090 year;
merge ind7090 year using ${x}compuse_ind7090.dta;
tab _merge;
keep if _merge==3;
drop _merge;
rename use use_ind;
rename p_use p_use_ind;

gen man7090=man70901;
sort man7090 year;
merge man7090 year using ${x}trade_man7090.dta;
tab _merge;
keep if _merge==1|_merge==3;
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

egen occ8090_fe=cut(occ80901), at(0(10)900);
egen yearcat=cut(year),at(1979(5)2010);
egen indyear=group(man7090_orig1 yearcat);
egen occyear=group(occ8090_fe year);

xi i.year1 i.man70901  i.ind70901 i.state1 i.occ8090_fe;

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

gen caplabor79=cap79/labor79/1000;
replace caplabor79=1 if man7090_orig1==.;
replace tfp579=1 if man7090_orig1==.;
replace lpiinv79=1 if man7090_orig1==.;

gsort man7090_orig1 educ1 year;

by man7090_orig1 educ1 : gen p_llowincemp=llowincemp[_n-1];
by man7090_orig1 educ1 : gen p_lhigh=lhigh[_n-1]; 
by man7090_orig1 educ1 : gen p_lpiinv79=lpiinv79[_n-1]; 
by man7090_orig1 educ1 : gen p_tfp579=tfp579[_n-1]; 
by man7090_orig1 educ1 : gen p_expmod79=expmod79[_n-1]; 
by man7090_orig1 educ1 : gen p_penmod79=penmod79[_n-1];
by man7090_orig1 educ1 : gen p_lrpiship79=lrpiship79[_n-1];
by man7090_orig1 educ1 : gen p_routine1=routine1[_n-1];
by man7090_orig1 educ1 : gen p_caplabor79=caplabor79[_n-1];



save ${x}temp.dta, replace;

use ${x}temp, clear;
keep if match4==1;

global routinecat1 "routine1>.5";
global routinecat2 "routine1<.5";

************************ Industry Wage Effects **************************
  
global mylist " p_llowincemp p_lhigh  p_penmod79 p_expmod79 age1 female1 nonwhite1 exper1 union1 p_lpiinv79 p_tfp579 p_caplabor79 p_use_ind"; 
reg leftmfg p_llowincemp p_lhigh  p_penmod79 p_expmod79 age1 female1 nonwhite1 exper1 union1 p_lpiinv79 p_tfp579 p_caplabor79 _Iyear* _Iman7090* _Istate* p_use_ind  if manuf1==1,cluster(indyear);
outreg2 $mylist using $masterpath/outfiles/apptable9.txt, replace;
reg leftmfg p_llowincemp p_lhigh  p_penmod79 p_expmod79 age1 female1 nonwhite1 exper1 union1 p_lpiinv79 p_tfp579 p_caplabor79 _Iyear* _Iman7090* _Istate* p_use_ind if $routinecat1 & manuf1==1,cluster(indyear);
outreg2 $mylist using $masterpath/outfiles/apptable9.txt, append;
reg leftmfg p_llowincemp p_lhigh  p_penmod79 p_expmod79 age1 female1 nonwhite1 exper1 union1 p_lpiinv79 p_tfp579 p_caplabor79 _Iyear* _Iman7090* _Istate* p_use_ind if $routinecat2 & manuf1==1,cluster(indyear);
outreg2 $mylist using $masterpath/outfiles/apptable9.txt, append;

***;
  
reg lwagediff p_llowincemp p_lhigh  p_penmod79 p_expmod79 age1 female1 nonwhite1 exper1 union1 p_lpiinv79 p_tfp579 p_caplabor79 _Iyear* _Iman7090* _Istate* p_use_ind  if manuf1==1,cluster(indyear);
outreg2 $mylist using $masterpath/outfiles/apptable9.txt, append;
reg lwagediff p_llowincemp p_lhigh  p_penmod79 p_expmod79 age1 female1 nonwhite1 exper1 union1 p_lpiinv79 p_tfp579 p_caplabor79 _Iyear* _Iman7090* _Istate* p_use_ind if $routinecat1 & manuf1==1,cluster(indyear);
outreg2 $mylist using $masterpath/outfiles/apptable9.txt, append;
reg lwagediff p_llowincemp p_lhigh  p_penmod79 p_expmod79 age1 female1 nonwhite1 exper1 union1 p_lpiinv79 p_tfp579 p_caplabor79 _Iyear* _Iman7090* _Istate* p_use_ind if $routinecat2 & manuf1==1,cluster(indyear);
outreg2 $mylist using $masterpath/outfiles/apptable9.txt, append;

************** Occupational Exposure Measures ****************************; 

global mylist "p_llowincemp_effective_occ p_lhigh_effective_occ p_penmod_effective_occ p_expmod_effective_occ age1 female1 nonwhite1 exper1 union1 p_use_occ";

reg lwagediff p_llowincemp_effective_occ p_lhigh_effective_occ p_penmod_effective_occ p_expmod_effective_occ age1 female1 nonwhite1 exper1 union1 _Iyear* _Iind7090*  _Iocc8090* _Istate* p_use_occ  if manuf1<=1 [w=orgwgt1],cluster(occyear);
outreg2 $mylist using $masterpath/outfiles/apptable9.txt, append;
reg lwagediff p_llowincemp_effective_occ p_lhigh_effective_occ p_penmod_effective_occ p_expmod_effective_occ age1 female1 nonwhite1 exper1 union1 _Iyear* _Iind7090*  _Iocc8090* _Istate* p_use_occ  if manuf1<=1 & $routinecat1 [w=orgwgt1],cluster(occyear);
outreg2 $mylist using $masterpath/outfiles/apptable9.txt, append;
reg lwagediff p_llowincemp_effective_occ p_lhigh_effective_occ p_penmod_effective_occ p_expmod_effective_occ age1 female1 nonwhite1 exper1 union1 _Iyear* _Iind7090*  _Iocc8090* _Istate* p_use_occ  if manuf1<=1 & $routinecat2 [w=orgwgt1],cluster(occyear);
outreg2 $mylist using $masterpath/outfiles/apptable9.txt, append;

!gzip ${x}switchers.dta;
!gzip ${a}compuse_occ8090.dta;
!gzip ${x}compuse_ind7090.dta;
