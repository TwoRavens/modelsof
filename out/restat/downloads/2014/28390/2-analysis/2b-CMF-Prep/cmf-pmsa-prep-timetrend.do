#delimit;

gl coaggl
gl lbd10
gl census
gl cmf
gl data
gl programs

cap n log close; 
set more off;
chdir $coaggl/growth/cmf/;
log using cmf-pmsa-prep-timetrend.log, replace;

clear; set mem 1g; set matsize 10000;

* William Kerr ;
* Growth Paper CMF File Prep; 

*** Prepare historical entry patterns of mfg firms by city;
!gunzip ./data/coaggl-cmf2-pmsa-sic3.dta;
use if pmsa!=9999 & pmsa!=. using ./data/coaggl-cmf2-pmsa-sic3.dta, clear;
keep if yr==1963 | yr==1982;
renpfix pmsa_sic3_; des; sum;
for any tot_ct tot_emp: gen X63=X if yr==1963;
for any tot_ct tot_emp: gen X82=X if yr==1982;
collapse (sum) tot_ct63 tot_emp63 tot_ct82 tot_emp82 , by(pmsa) fast;
gen ctgr=tot_ct82/tot_ct63; gen empgr=tot_emp82/tot_emp63;
keep pmsa ctgr empgr; sort pmsa; save ./data/CMF6382, replace; 

*** End of Program;
cap n log close;
