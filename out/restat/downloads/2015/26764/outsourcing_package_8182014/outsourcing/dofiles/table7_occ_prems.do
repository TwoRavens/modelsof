
global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/"

#delimit;
clear;
set more off;
set matsize 800;

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


use ${x}offshore_exposure.dta, replace;  
collapse
p* e* l*
,
by(occ8090 year);
save ${x}temp1, replace;

use ${x}switchers.dta, clear; // Tomer changed to switchers.dta from match_correct_mf.dta
rename occ80901 occ8090;
sort occ8090 year;
merge occ8090 year using ${x}temp1;
tab _merge;
keep if _merge==3;
save ${x}temp2, replace;

use ${x}temp2, replace;
pctile offshore_exposure=p_lowincemp_effective_occ if year==2002 & manuf1==1,nq(2);
xtile offshore_cat=p_lowincemp_effective_occ if year==2002,cut(offshore_exposure);
bysort occ8090: egen globalcat=max(offshore_cat);

gen diffocc1990=occ1990_t1~=occ1990_t2;
gen diffocc1990dd=occ1990dd_t1~=occ1990dd_t2;
gen diffocc1990_1dig=occ1990_1dig_t1~=occ1990_1dig_t2;

replace ihwt1=round(ihwt1/10,0);

global controls "age1 female1 nonwhite1 union1 _Ieduc2* _Iyear2* _Istate2*";

global task_content "ehf finger dcp sts math";
global task_content " ";

gen tradable=globalcat==2;
save ${x}temp3, replace;

*** Start Regression  ***;

global controls "age1 female1 nonwhite1 union1 _Ieduc2* _Iyear2* _Istate2*";

* 2 digit occupation codes;
use ${x}temp3, clear;
xi i.occ1990_1dig_t1 i.educ2 i.year2 i.state2;

global occlist_short "2 3 4 5 6 8 10 12 13 14 15 16 17"; 
reg lwage _Iocc1990_1* $controls ,  cluster(occ8090);
foreach i of global occlist_short{;
gen prem_`i'=_b[_Iocc1990_1_`i'];
                            };

reg lwage _Iocc1990_1* $controls if diffocc1990_1dig==1,  cluster(occ8090);
foreach i of global occlist_short{;
gen prem_`i'_sw=_b[_Iocc1990_1_`i'];
                            };
collapse prem*,by(occ1990_1dig_t1);
save ${x}occ_prems_short, replace;

* 3 digit occupation codes;                                  
use ${x}temp3, clear;
bysort occ8090: keep if _n<100;
xi i.occ8090 i.educ2 i.year2 i.state2;

do $masterpath/dofiles/occupationlist.do;
reg lwage _Iocc8090* $controls ,  cluster(occ8090);
foreach i of global occupationlist{;
gen prem_`i'_long=_b[_Iocc8090_`i'];
                            };

reg lwage _Iocc8090* $controls if diffocc==1,  cluster(occ8090);
foreach i of global occupationlist{;
gen prem_`i'_sw_long=_b[_Iocc8090_`i'];
                            };
collapse prem*,by(occ8090);
save ${x}occ_prems_long, replace;

                                  
