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
log using cmf-pmsa-prep-67entry.log, replace;

clear; set mem 1g; set matsize 10000;

* William Kerr ;
* Growth Paper CMF File Prep;
* Last Modified: 23 July 2009;

*** Prepare historical entry patterns of mfg firms by city;
!gunzip coaggl-cmf2-pmsa-sic3.dta;
use if yr==1967 & pmsa!=9999 & pmsa!=. using coaggl-cmf2-pmsa-sic3.dta, clear;
!gzip coaggl-cmf2-pmsa-sic3.dta;
renpfix pmsa_sic3_; des; sum;
collapse (sum) bir_emp tot_emp, by(pmsa) fast;
gen rt67=bir_emp/tot_emp; format rt* %4.3f;
gsort -rt; list; drop bir_emp tot_emp;
sort pmsa; save CMF63_PMSA1-67, replace; 

*** End of Program;
cap n log close;
