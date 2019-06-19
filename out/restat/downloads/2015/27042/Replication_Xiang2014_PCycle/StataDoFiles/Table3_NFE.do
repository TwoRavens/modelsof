capture log close
drop _all
clear all
set memory 5g
set more 1
#delimit;
   
cd "C:\Main\p-cycle\IndustryResults\NS2";

set logtype text; 
log using "C:\Main\p-cycle\Writing\ReStatRevision\CountryFE\NFE", replace; 


*****************************************************************
***************Individual N. Countries and country FE************
*****************************************************************; 


*************step 1 Construction*************************;log off; 

use C:\Main\p-cycle\data\world-gdp;
keep if year >= 1972 & year <=1996;
sort cname wtdbcode; collapse (mean) rgdpch, by(cname wtdbcode); drop if rgdpch==.; sort rgdpch; 
log on; list; 
***this is before wtdb code is added; 

**pick 7,000 as the cut-off;
**this is the average per capital GDP between 1972 and 1996; 
keep if rgdpch>=7000; drop if cname=="United States"; 

log off; 

duplicates drop wtdbcode, force;
sort wtdbcode; keep wtdbcode; save richcountries, replace; 

log on;
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

log off; 

drop msic72_8d sitc2 sitc3; replace msic87=substr(msic87,1,4); compress; 
rename fraction ng; gen og=1-ng; 

****merging in rich/poor countries; 
rename ccode wtdbcode; sort wtdbcode; merge wtdbcode using richcountries; 
tab _merge; ***all 1 and 3; gen N=(_merge==3); drop _merge; gen S=1-N; sort year msic87; save c1, replace; 

*****aggregate across S. countries;
use c1; keep if S==1; 
gen fobSng=fob*S*ng; gen fobSog=fob*S*og; gen cifSng=cif*S*ng; gen cifSog=cif*S*og; sort year msic87;
collapse (sum) fobSng fobSog cifSng cifSog, by(year msic87); sort year msic87; save c10, replace; 

*****merge aggregate S. data with individual country N. data; 
use c1; drop if S==1; 
gen fobNng=fob*N*ng; gen fobNog=fob*N*og; gen cifNng=cif*N*ng; gen cifNog=cif*N*og; sort wtdbcode year msic87;
collapse (sum) fobNng fobNog cifNng cifNog, by(wtdbcode year msic87); sort year msic87; 
merge year msic87 using c10; tab _merge; ***1, 2 and 3, 0's; 
foreach x of varlist fobSog fobSng cifSog cifSng {;
  replace `x'=0 if _merge==1;
};
foreach x of varlist fobNog fobNng cifNog cifNng {;
  replace `x'=0 if _merge==2;
};
drop _merge;  save ctsusa, replace; 

log on; 
use C:\Main\p-cycle\construct-7ddata\Checked\HS\indhs; 

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
tab _merge; ***all 1 and 3; gen N=(_merge==3); drop _merge; gen S=1-N; sort year msic87; save c1, replace; 

*****aggregate across S. countries;
use c1; keep if S==1; 
gen fobSng=fob*S*ng; gen fobSog=fob*S*og; gen cifSng=cif*S*ng; gen cifSog=cif*S*og; sort year msic87;
collapse (sum) fobSng fobSog cifSng cifSog, by(year msic87); sort year msic87; save c10, replace; 

*****merge aggregate S. data with individual country N. data; 
use c1; drop if S==1; 
gen fobNng=fob*N*ng; gen fobNog=fob*N*og; gen cifNng=cif*N*ng; gen cifNog=cif*N*og; sort wtdbcode year msic87;
collapse (sum) fobNng fobNog cifNng cifNog, by(wtdbcode year msic87); sort year msic87; 
merge year msic87 using c10; tab _merge; ***1, 2 and 3, 0's; 
foreach x of varlist fobSog fobSng cifSog cifSng {;
  replace `x'=0 if _merge==1;
};
foreach x of varlist fobNog fobNng cifNog cifNng {;
  replace `x'=0 if _merge==2;
};
drop _merge;
save chs, replace; 

gen str4 x=string(msic87); drop msic87; rename x msic87; 
replace msic87="0"+msic87 if length(msic87)==3; 
append using ctsusa; 

log on; 
****T3 dropping those with fewer than 5 years of data and those ending in "ZZ"; 
drop if msic87=="";
sort msic87 wtdbcode; by msic87 wtdbcode: gen a=_N; tab a; drop if a<=5; drop a;
gen str2 a=substr(msic87,3,2); drop if a=="ZZ"; drop a; 
save C:\Main\p-cycle\Writing\ReStatRevision\CountryFE\NFE, replace; d; log off; 

erase ctsusa.dta; erase chs.dta; erase richcountries.dta;  log on;

*************step 2. regression results********************; log off; 

sort msic87; drop if year<=77;
*egen x=sum(fobSng), by(msic87); 
*egen y=sum(fobNng), by(msic87);
*drop if x==0 & y==0; 
*drop x y; log on; 
************many many zero trade flows, even at country-industry-year levels, especially for new goods;
count; count if fobNng==0; count if fobNog==0; count if fobSng==0; count if fobSog==0; 
gen dd=(fobSng/fobSog)/(fobNng/fobNog); gen ddlog=log(dd+1); ***preserving dd==0 obs; log off; 

gen t=year-77; gen t2=t*t; 
encode msic87, gen (ind); ***from 1 to 265; sort ind; 
gen tb=.; gen tse=.; gen t2b=.; gen t2se=.; gen tblog=.; gen tselog=.; gen t2blog=.; 
gen t2selog=.;gen vt=fobSng+fobSog+fobNng+fobNog; by msic87 wtdbcode, sort: egen vtbar=mean(vt); egen time=group(t);

log on; 
gen taoSng=(cifSng-fobSng)/fobSng; gen taoSog=(cifSog-fobSog)/fobSog;
gen taoNng=(cifNng-fobNng)/fobNng; gen taoNog=(cifNog-fobNog)/fobNog;

count if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0; 
sum tao* if taoSng>=0 & taoSog>=0 & taoNng>=0 & taoNog>=0; 
gen ddtao=(taoSng/taoSog)/(taoNng/taoNog);
replace ddtao=. if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0;
gen ddlogtao=log(ddtao+1); ***preserving ddtao==0 obs.;


****************2. country x industry FE***************************************************;
egen fixed=group(wtdbcode msic87); 
areg ddlog t t2 ddlogtao [aweight=vtbar], absorb(fixed) cluster(time); 
scalar length=-_b[t]/(2*_b[t2]); mat A=e(V); mat Var=A[1..2,1..2];
mat Dlength=(1/(2*_b[t2]), -_b[t]/(2*_b[t2]*_b[t2])); mat B=Dlength*Var*Dlength';
scalar stdlength=sqrt(B[1,1]); mat C=(length, stdlength); matlist C; 
****************2. country x industry FE***************************************************;

log close;  

erase c10.dta; 

