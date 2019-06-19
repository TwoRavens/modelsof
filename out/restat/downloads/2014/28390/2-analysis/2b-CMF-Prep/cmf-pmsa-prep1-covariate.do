#delimit;

gl coaggl
gl lbd10
gl census
gl cmf
gl data
gl programs

cap n log close; 
set more off;
chdir $coaggl/growth/cmf;
log using cmf-pmsa-prep1-covariate.log, replace;

clear; clear matrix; set mem 1g; set matsize 10000;

* William Kerr;
* Growth Paper CMF File Prep;
* Last Modified: 2 July 2010;

*** FHFA data;
use fhfa, clear;
des; sum; keep if index!=.; replace bill=substr(bill,1,20);
collapse (mean) index, by(pmsa bill year) fast;
format index %4.1f; tab year, s(index);
gen yr2=1995 if (year>=1994 & year<=1996);
replace yr2=2005 if (year>=2004 & year<=2006);
drop if yr2==.;
collapse (mean) index, by(pmsa bill yr2) fast;
reshape wide index, i(bill pmsa) j(yr2);
gen indexgr=index2005/index1995; 
format index1995 index2005 %4.1f; format indexgr %4.3f; sum;
sort pmsa;
list if pmsa==pmsa[_n-1] | pmsa==pmsa[_n+1];
drop if pmsa==6980 & bill=="Springfield, OH";
drop if pmsa==pmsa[_n-1];
sort pmsa;
save temp1, replace; list; 
gsort -indexgr; list in 1/30; 
gsort indexgr; list in 1/30; 

*** Saiz data;
use saiz_new, clear;
des; sum; ren msa pmsa; sort pmsa;
save saiz_new_merge, replace;

*** Use MSA data;
use lbd_pmsa_fips_center, clear; des; keep pmsa cityname;
sort pmsa; merge pmsa using ../../jue/climate/pmsa90, keep(s_ed_bach90 s_ed_hs90);
tab _m; tab cityname if _m==1, s(pmsa); tab pmsa if _m==2; drop if _m==2; drop _m;
sort pmsa; merge pmsa using general_msa;
tab _m; tab cityname if _m==1, s(pmsa); tab msaname if _m==2, s(pmsa); drop if _m==2; drop _m msaname;
sort pmsa; merge pmsa using ../../jue/climate/climate-price;
tab _m; tab cityname if _m==1, s(pmsa); tab pmsa if _m==2; drop if _m==2; drop _m;
sort pmsa; merge pmsa using temp1; erase temp1.dta;
tab _m; tab cityname if _m==1, s(pmsa); tab bill if _m==2, s(pmsa); drop if _m==2; drop _m bill;
sort pmsa; merge pmsa using saiz_new_merge, keep(NAME unaval); erase saiz_new_merge.dta;
tab _m; tab cityname if _m==1, s(pmsa); tab NAME if _m==2, s(pmsa); drop if _m==2; drop _m NAME;
des; sum;

sort pmsa;
list if pmsa==pmsa[_n-1] | pmsa==pmsa[_n+1];
drop if pmsa==pmsa[_n-1];
list cityname if pmsa==6980;

sort pmsa;
save pmsa-covariates, replace;

*** End of Program;
cap n log close;

***********************************************************;
***********************************************************;
*** SAVED MATERIALS                                      **;
***********************************************************;
***********************************************************;
