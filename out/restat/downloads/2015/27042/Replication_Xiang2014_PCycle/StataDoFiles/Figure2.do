drop _all
set more 1
capture log close
#delimit;
   
cd "C:\Old C Drive\p-cycle\IndustryResults\NS2";

set logtype text; 
log using Table2_singlediff, replace; log off; 

use NS2;

sort msic87; egen x=sum(fobSng), by(msic87); egen y=sum(fobNng), by(msic87);
drop if x==0 & y==0; drop x y; drop if year<=77;

gen dn=fobSng/fobNng; gen do=fobSog/fobNog;
gen dnlog=log(dn+1); gen dolog=log(do+1);
***making sure that 0 values in dd still have 0 values in ddlog;
gen dnlog2=log(dn); gen dolog2=log(do);

gen t=year-77; gen t2=t*t; 
encode msic87, gen (ind); ***from 1 to 265; sort ind; 
gen tb=.; gen tse=.; gen t2b=.; gen t2se=.; gen tblog=.; gen tselog=.; gen t2blog=.; 
gen t2selog=.;gen vt=fobSng+fobSog+fobNng+fobNog; 
gen vtn=fobSng+fobNng; gen vto=fobSog+fobNog;
by msic87, sort: egen vtnbar=mean(vtn); 
by msic87, sort: egen vtobar=mean(vto); 
by msic87, sort: egen vtbar=mean(vt); 
egen time=group(t);

gen taoSng=(cifSng-fobSng)/fobSng; gen taoSog=(cifSog-fobSog)/fobSog;
gen taoNng=(cifNng-fobNng)/fobNng; gen taoNog=(cifNog-fobNog)/fobNog;

log on; count if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0; 
sum tao* if taoSng>=0 & taoSog>=0 & taoNng>=0 & taoNog>=0; 

gen dntao=taoSng/taoNng; gen dotao=taoSog/taoNog;
replace dntao=. if taoSng<0 | taoNng<0; replace dotao=. if taoSog<0 | taoNog<0; log off; 

gen dnlogtao=log(dntao+1); gen dnlogtao2=log(dntao);
gen dologtao=log(dotao+1); gen dologtao2=log(dotao);

save c10, replace;

log on; 


*****draw pictures for single difference of new goods; 
use c10; sort year; 
collapse (mean) dn dnlog dnlog2 [aweight=vtn], by(year);
label var dnlog2 "log(South New Prod. Exp./North New Prod. Exp.)";
replace year=year+1900; label var year "year";
twoway (scatter dnlog2 year), saving(Figure2_singlediff_ng, replace);
clear; 

*****draw pictures for single difference of old goods; 
use c10; sort year; 
collapse (mean) do dolog dolog2 [aweight=vtobar], by(year);
label var dolog2 "log(South Old Prod. Exp./North Old Prod. Exp.)";
replace year=year+1900; label var year "year";
twoway (scatter dolog2 year), saving(Figure2_singlediff_og, replace);
clear; 

 
erase c10.dta; 