drop _all
set memory 400m
set more 1
#delimit;
   
cd c:\p-cycle\IndustryResults;

set logtype text; log using c:\p-cycle\IndustryResults\NS2\construction, replace;
log off;

use c:\p-cycle\data\world-gdp;
keep if year >= 1972 & year <=1996;
sort cname wtdbcode; collapse (mean) rgdpch, by(cname wtdbcode); drop if rgdpch==.; sort rgdpch; 
log on; list; 
***this is before wtdb code is added; 

**pick 7,000 as the cut-off: 32 countries in all, 32/138 = 23.2%;
**this is the average per capital GDP between 1972 and 1996; 
keep if rgdpch>=7000; drop if cname=="United States"; log off; 

duplicates drop wtdbcode, force;
sort wtdbcode; keep wtdbcode; save richcountries, replace; 

log on;
use c:\p-cycle\construct-7ddata\Checked\TSUSA\indtsusa; 

****T1 dropping those labeled with "e" or "p" and not matched to new goods;
drop if matchng=="" & (labels=="e" | labels=="p" | labels=="dp" | labels=="ep" | labels=="pd");
****T1 dropping those labeled with "t";
drop if labels=="dt" | labels=="et" | labels=="pt" | labels=="t" | labels=="ts";

****T2 dropping non-manufacturing and non-sensical observations; 
drop if year<yearfu | year>yearlu; ***these obs. do not make sense;
***23131 out of 2102673 observations;
gen str1 a=substr(msic72_8d,1,1); tab a; ***only 2 and 3 are manufacturing;
keep if a=="2" | a=="3"; drop a;
log off; 

drop msic72_8d sitc2 sitc3; replace msic87=substr(msic87,1,4); compress; 
rename fraction ng; gen og=1-ng; 

****merging in rich/poor countries; 
rename ccode wtdbcode; sort wtdbcode; merge wtdbcode using richcountries; 
tab _merge; ***all 1 and 3; gen N=(_merge==3); drop _merge; gen S=1-N; 
gen fobNng=fob*N*ng; gen fobNog=fob*N*og; gen fobSng=fob*S*ng; gen fobSog=fob*S*og; 
gen cifNng=cif*N*ng; gen cifNog=cif*N*og; gen cifSng=cif*S*ng; gen cifSog=cif*S*og; 
sort year msic87;
collapse (sum) fobNng fobNog fobSng fobSog cifNng cifNog cifSng cifSog, by(year msic87);
save ctsusa, replace; 

log on; 
use c:\p-cycle\construct-7ddata\Checked\HS\indhs; 

****T1 dropping those labeled with "e" or "p" and not matched to new goods;
drop if matchng=="" & (labels=="e" | labels=="p" | labels=="spm" |
	labels=="dp" | labels=="es" | labels=="pd" | labels=="ps" | labels=="sp" );
****T1 dropping those labeled with "t";
drop if labels=="st" | labels=="t" | labels=="td";

****T2 dropping non-manufacturing and non-sensible observations; 
drop if year<yearfu | year>yearlu; ***these obs. do not make sense;
***43328 out of 3110994 observations;
keep if msic87>=2000 & msic87<=3999; ***only these are mfg.;
log off; 

drop sitc2 sitc3; compress; rename fraction ng; gen og=1-ng; 

****merging in rich/poor countries; 
rename ccode wtdbcode; sort wtdbcode; merge wtdbcode using richcountries; 
tab _merge; ***all 1 and 3; gen N=(_merge==3); drop _merge; gen S=1-N; 
gen fobNng=fob*N*ng; gen fobNog=fob*N*og; gen fobSng=fob*S*ng; gen fobSog=fob*S*og; 
gen cifNng=cif*N*ng; gen cifNog=cif*N*og; gen cifSng=cif*S*ng; gen cifSog=cif*S*og; 
sort year msic87;
collapse (sum) fobNng fobNog fobSng fobSog cifNng cifNog cifSng cifSog, by(year msic87);
save chs, replace; 

gen str4 x=string(msic87); drop msic87; rename x msic87; 
replace msic87="0"+msic87 if length(msic87)==3; 
append using ctsusa; 

log on; 
****T3 dropping those with fewer than 5 years of data and those ending in "ZZ"; 
drop if msic87=="";
sort msic87; by msic87: gen a=_N; tab a; drop if a<=5; drop a;
gen str2 a=substr(msic87,3,2); drop if a=="ZZ"; drop a; 
save c:\p-cycle\IndustryResults\NS2\NS2, replace; d; log close; 

erase ctsusa.dta; erase chs.dta; erase richcountries.dta; 

