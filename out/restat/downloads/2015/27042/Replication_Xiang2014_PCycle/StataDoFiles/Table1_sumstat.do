
drop _all
set more 1
#delimit;
   
cd "C:\Old C Drive\p-cycle\IndustryResults\NS2";

set logtype text; 
log using Table1_sumstat, replace; log off; 

use NS2;

sort msic87; egen x=sum(fobSng), by(msic87); egen y=sum(fobNng), by(msic87);
drop if x==0 & y==0; drop x y; drop if year<=77;
gen dd=(fobSng/fobSog)/(fobNng/fobNog); 
gen ddlog=log(dd+1); ***making sure that 0 values in dd still have 0 values in ddlog;
gen ddlog2=log(dd); 
gen t=year-77; gen t2=t*t; 
encode msic87, gen (ind); ***from 1 to 265; sort ind; 
gen tb=.; gen tse=.; gen t2b=.; gen t2se=.; gen tblog=.; gen tselog=.; gen t2blog=.; 
gen t2selog=.;gen vt=fobSng+fobSog+fobNng+fobNog; egen time=group(t);
gen Snglog=log(fobSng); gen Soglog=log(fobSog); gen Nnglog=log(fobNng); gen Noglog=log(fobNog);


log on; 

sum Snglog Soglog Nnglog Noglog ddlog ddlog2;

log close;

clear; 