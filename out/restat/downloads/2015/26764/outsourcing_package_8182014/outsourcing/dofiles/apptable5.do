global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/"
global a "$masterpath/dofiles/"

#delimit;
clear;
set more off;
set matsize 800;

set mem 2500m;
global path ~;

capture log close;

/*================================================
 Program: appendixtable6.do
 Author:  Shannon Phillips
 Created: June 2009
 Purpose: List occupations most affected by import penetration in 1983 & 2002
	   to show that some individuals have had huge hits on their wages 
	   while many have been unaffected. 
=================================================*/

log using ${z}appendixtable6.log, replace;
use ${x}offshore_exposure;

************************;
* Mincer specification  ;
************************;
egen expergp=cut(exper), at(0(3)45 100);
xi i.educ*i.expergp i.year i.state;

reg lwage _Ieduc* _Iexper* _IeduXexp* female nonwhite _Iyear* _Istate* [w=ihwt];
predict yhat;
gen lwageres=lwage-yhat;

keep if year==1983|year==2002;
do ${a}occupationlabels.do;

bysort occ8090 year: egen emp=total(orgwgt/12);
bysort year: egen totalemp=total(orgwgt/12);

bysort occ8090 year: egen mfgemp=total(orgwgt/12) if man7090~=.;
replace mfgemp=0 if mfgemp==.;

gen empshare=emp/totalemp;
gen mfgempshare=mfgemp/emp;

collapse penmod_effective expmod_effective lowincemp_effective highincemp_effective lwageres emp totalemp empshare mfgemp mfgempshare, by(occ8090 year);
reshape wide penmod_effective expmod_effective lowincemp_effective highincemp_effective lwageres emp totalemp empshare mfgemp mfgempshare, i(occ8090) j(year);

gen lwageresdiff=lwageres2002-lwageres1983;
*************************************************************************;
* For 40 occupations with highest import share in 2002, list 1983 values ;
*************************************************************************;
drop if penmod_effective2002==.;
sort penmod_effective2002;
outsheet occ8090 penmod_effective1983 penmod_effective2002 empshare1983 empshare2002 mfgempshare1983 mfgempshare2002 using ${z}appendixtable6.out, replace;

gsort -penmod_effective2002;
list occ8090 penmod_effective1983 penmod_effective2002 lwageresdiff empshare1983 empshare2002 mfgempshare1983 mfgempshare2002 in 1/40;


*************************************************************************;
* For 40 occupations with highest export share in 2002, list 1983 values ;
*************************************************************************;
drop if expmod_effective2002==.;
sort expmod_effective2002;
outsheet occ8090 expmod_effective1983 expmod_effective2002 empshare1983 empshare2002 mfgempshare1983 mfgempshare2002 using ${z}appendixtable7.out, replace;

gsort -expmod_effective2002;
list occ8090 expmod_effective2002 expmod_effective1983 lwageresdiff empshare1983 empshare2002 mfgempshare1983 mfgempshare2002 in 1/40;

log close;


/*
!gunzip ${x}occupational_exposure_data.dta.gz;
use ${x}occupational_exposure_data;

keep if year==1983|year==2002;
keep penmod_effective year occ8090;

reshape wide penmod_effective, i(occ8090) j(year);

sort penmod_effective2002;
***********************************************************************************;
* For 40 occupations most affected by import penetration in 2002, list 1983 values ;
***********************************************************************************;
list occ8090 penmod_effective2002 penmod_effective1983 in -40/l;

log close;
exit;
*********************************;
*/
