capture log close
drop _all
clear all
set more 1
set memory 10g
#delimit;
   
cd "C:\Main\p-cycle\Writing\ReStatRevision\ZhuStuff";

set logtype text; 
log using YearFu, replace; 


**********************************************************************
***************Correlate ng and "ng" id by yearfu*********************
**********************************************************************; 


*******************************************step 1 N v S countries*************************; 

use C:\Main\p-cycle\data\world-gdp;
keep if year >= 1972 & year <=1996;
sort cname wtdbcode; collapse (mean) rgdpch, by(cname wtdbcode); drop if rgdpch==.; sort rgdpch; 
log on; list; 
***this is before wtdb code is added; 

**pick 7,000 as the cut-off;
**this is the average per capital GDP between 1972 and 1996; 
keep if rgdpch>=7000; drop if cname=="United States"; 
duplicates drop wtdbcode, force;
sort wtdbcode; keep wtdbcode; save richcountries, replace; 

********step 2 tsusa data only. HS data not very useful. Cannot go beyond 1988************;
use C:\Main\p-cycle\construct-7ddata\Checked\TSUSA\indtsusa; 
****T1 dropping those labeled with "e" or "p" and not matched to new goods;
drop if matchng=="" & (labels=="e" | labels=="p" | labels=="dp" | labels=="ep" | labels=="pd");
****T1 dropping those labeled with "t";
drop if labels=="dt" | labels=="et" | labels=="pt" | labels=="t" | labels=="ts";
****T2 dropping non-manufacturing and non-sensical observations; 
drop if year<yearfu | year>yearlu; ***these obs. do not make sense;
***23131 out of 2102673 observations;
gen str1 a=substr(msic72_8d,1,1); tab a; ***only 2 and 3 are manufacturing;
keep if a=="2" | a=="3"; drop a;
drop msic72_8d sitc2 sitc3; replace msic87=substr(msic87,1,4); compress; 
rename fraction ng; gen og=1-ng; 


*****************Step 3 define "ng" by yearfu and correlation**********************************;
gen ngf=(year>=yearfu & yearfu > 72); gen ogf=1-ngf; 
pwcorr ngf ng, sig;
*****************correlation at the product level is weak but significant, 0.1420***********;


****merging in rich/poor countries; 
rename ccode wtdbcode; sort wtdbcode; merge wtdbcode using richcountries; 
tab _merge; ***all 1 and 3; gen N=(_merge==3); drop _merge; gen S=1-N; 

foreach x in fob cif {;
  foreach y in N S {;
    gen `x'`y'ng=`x'*`y'*ng; gen `x'`y'og=`x'*`y'*og;  
    gen `x'`y'ngf=`x'*`y'*ngf; gen `x'`y'ogf=`x'*`y'*ogf;
  };
}; 

sort year msic87; collapse (sum) fob* cif*, by(year msic87);
pwcorr *Nng*, sig; pwcorr *Sng*, sig; 
***************correlation at industry level of these values are stronger, 0.32 - 0.58********;
save YearFu, replace; 

log close; 
erase richcountries.dta; 

