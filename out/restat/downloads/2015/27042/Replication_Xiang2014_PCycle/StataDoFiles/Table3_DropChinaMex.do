capture log close
drop _all
clear all
set more 1
set memory 10g
#delimit;
   
cd "C:\Dropbox\Main\p-cycle\IndustryResults\NS2";

set logtype text; 
log using "C:\Dropbox\Main\p-cycle\Writing\ReStatRevision\VS\DropChinaMex", replace; 


*****************************************************************
***************Drop China and MEXICO******************************
*****************************************************************; 


*************step 1 Construction*************************;log off; 

use C:\Dropbox\Main\p-cycle\data\world-gdp;
keep if year >= 1972 & year <=1996;
sort cname wtdbcode; collapse (mean) rgdpch, by(cname wtdbcode); drop if rgdpch==.; sort rgdpch; 
log on; list; 
***this is before wtdb code is added; 

**pick 7,000 as the cut-off;
**this is the average per capital GDP between 1972 and 1996; 
keep if rgdpch>=7000; drop if cname=="United States"; 

***H3 drop mexico;
drop if wtdbcode==334840;

log off; 

duplicates drop wtdbcode, force;
sort wtdbcode; keep wtdbcode; save richcountries, replace; 

log on;
use C:\Dropbox\Main\p-cycle\construct-7ddata\Checked\TSUSA\indtsusa; 
***drop Mexico and China; 
drop if ccode==481560 | ccode==334840;
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
use C:\Dropbox\Main\p-cycle\construct-7ddata\Checked\HS\indhs; 

***drop Mexico and China; 
drop if ccode==481560 | ccode==334840;

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
save C:\Dropbox\Main\p-cycle\Writing\ReStatRevision\VS\NS2DropMexChi, replace; d; log off; 

erase ctsusa.dta; erase chs.dta; erase richcountries.dta; log on;

*************step 2. regression results********************; log off;

sort msic87; egen x=sum(fobSng), by(msic87); egen y=sum(fobNng), by(msic87);
drop if x==0 & y==0; drop x y; drop if year<=77;
gen dd=(fobSng/fobSog)/(fobNng/fobNog); 
gen ddlog=log(dd+1); ***making sure that 0 values in dd still have 0 values in ddlog;
gen ddlog2=log(dd);
gen t=year-77; gen t2=t*t; 
encode msic87, gen (ind); ***from 1 to 265; sort ind; 
gen tb=.; gen tse=.; gen t2b=.; gen t2se=.; gen tblog=.; gen tselog=.; gen t2blog=.; 
gen t2selog=.;gen vt=fobSng+fobSog+fobNng+fobNog; by msic87, sort: egen vtbar=mean(vt); egen time=group(t);

gen taoSng=(cifSng-fobSng)/fobSng; gen taoSog=(cifSog-fobSog)/fobSog;
gen taoNng=(cifNng-fobNng)/fobNng; gen taoNog=(cifNog-fobNog)/fobNog;

count if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0; 
sum tao* if taoSng>=0 & taoSog>=0 & taoNng>=0 & taoNog>=0; 
gen ddtao=(taoSng/taoSog)/(taoNng/taoNog);
replace ddtao=. if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0;
gen ddlogtao=log(ddtao+1); gen ddlogtao2=log(ddtao);

log on; 

areg ddlog2 t t2 ddlogtao2 [aweight=vtbar], absorb(ind) cluster(time); 
outreg2 t t2 ddlogtao2 using "C:\Dropbox\Main\p-cycle\Writing\ReStatRevision\Table3_Main", append ctitle(No Chn Mex);
*** length of product cycles (length) and its std. dev. (stdlength), computed;
*** using the delta method; log off; 
scalar length=-_b[t]/(2*_b[t2]); mat A=e(V); mat Var=A[1..2,1..2];
mat Dlength=(1/(2*_b[t2]), -_b[t]/(2*_b[t2]*_b[t2])); mat B=Dlength*Var*Dlength';
scalar stdlength=sqrt(B[1,1]); log on; mat C=(length, stdlength); matlist C; 

log close; 

