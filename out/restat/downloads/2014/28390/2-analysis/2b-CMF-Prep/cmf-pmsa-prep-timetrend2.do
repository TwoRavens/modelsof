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
log using cmf-pmsa-prep-timetrend2.log, replace;

clear; set mem 1g; set matsize 10000;

* William Kerr ;
* Growth Paper CMF File Prep; 

*** 6377;
!gunzip ./data/coaggl-cmf2-pmsa-sic3.dta;
use if pmsa!=9999 & pmsa!=. using ./data/coaggl-cmf2-pmsa-sic3.dta, clear;
keep if yr==1963 | yr==1977;
renpfix pmsa_sic3_; des; sum;
for any tot_ct tot_emp: gen X63=X if yr==1963;
for any tot_ct tot_emp: gen X77=X if yr==1977;
collapse (sum) tot_ct63 tot_emp63 tot_ct77 tot_emp77 , by(pmsa) fast;
gen ctgr=tot_ct77/tot_ct63; gen empgr=tot_emp77/tot_emp63;
keep pmsa ctgr empgr; sort pmsa; save ./data/CMF6377, replace; 

*** 6387;
use if pmsa!=9999 & pmsa!=. using ./data/coaggl-cmf2-pmsa-sic3.dta, clear;
keep if yr==1963 | yr==1987;
renpfix pmsa_sic3_; des; sum;
for any tot_ct tot_emp: gen X63=X if yr==1963;
for any tot_ct tot_emp: gen X87=X if yr==1987;
collapse (sum) tot_ct63 tot_emp63 tot_ct87 tot_emp87 , by(pmsa) fast;
gen ctgr=tot_ct87/tot_ct63; gen empgr=tot_emp87/tot_emp63;
keep pmsa ctgr empgr; sort pmsa; save ./data/CMF6387, replace; 

*** 6381;
use if yr==1981 using $lbd10/lbdc-bcd-2010, clear;
drop if (st==. | cou==.); gen fips=st*1000+cou; sort fips; 
merge fips using $coaggl/jue/lbd/data/urb742, keep(pmsa cityname);
tab _m; keep if _m==3; drop _m;
collapse (sum) tot_emp tot_ct, by(pmsa) fast;
for any tot_ct tot_emp: ren X X81; save temp1-cmf, replace;
use if yr==1963 & pmsa!=9999 & pmsa!=. using ./data/coaggl-cmf2-pmsa-sic3.dta, clear;
renpfix pmsa_sic3_; 
for any tot_ct tot_emp: gen X63=X if yr==1963;
collapse (sum) tot_ct63 tot_emp63, by(pmsa) fast;
sort pmsa; merge pmsa using temp1-cmf; tab _m; drop _m; erase temp1-cmf.dta;
gen ctgr=tot_ct81/tot_ct63; gen empgr=tot_emp81/tot_emp63;
keep pmsa ctgr empgr; sort pmsa; save ./data/CMF6381, replace; 

*** End of Program;
cap n log close;
