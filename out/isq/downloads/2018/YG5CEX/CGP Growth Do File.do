#delimit ;

clear all;
set more off;   
set mem 400m;
set linesize 80;
clear all;
macro drop _all;

cd  "C:\Users\Owner\Desktop\CGP Replication Packet\";

use "Data Files\small_Garrett.dta", clear;
sort ccode year;
save "small_Garrett.dta", replace;

use "Data Files\CGP1.dta", clear;
sort ccode year;
merge ccode year using "small_Garrett.dta", nokeep keep(gdp unem infl llp);
drop _merge;

duplicates drop ccode year, force;

drop WB_growth;
rename gdp WB_growth;

*** Model 5***;
levels ccode, local(states);

local c 1;
foreach s in `states' {;
di `c';
di `s';
list longname if ccode==`s' & year==1990;
gen c`c' = 0;
replace c`c' = 1 if ccode==`s';
local c = `c' + 1;
};

gen grow_tenure = WB_growth*tenure;

sum WB_growth;
local mean = r(mean);
local sd=1;

bysort longname: sum WB_growth; 

local c 1;
while `c' <=(19) {;
di `c';
sum c`c';
local `c'mean = r(mean);
local c = `c' + 1;
};

sum unem;
local mean_llp = r(mean);



stcox WB_growth grow_tenure if year>1971, nolog efron nohr;