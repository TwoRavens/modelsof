#delimit ;
set more 1;
clear;

*collect father and offspring years of schooling;

*find latest years of schooling for everyone;
use pnr hfpria using "D:\Data\WorkData\702092\stata-data\DATA_2012\udda1980", clear;
gen year=1980;
for Y in num 1981/2009: 
  append using "D:\Data\WorkData\702092\stata-data\DATA_2012\uddaY", keep(pnr hfpria)
\ replace year=Y if year==.;
destring hfpria, replace;
gen educ=int(hfpria/12);
recode educ 0/7=7 18/21=18;
sort pnr year;
keep if pnr!=pnr[_n+1];
keep pnr educ;
save educ, replace;

*use father-offspring links from fertility database;
use pnr pnrf using "D:\Data\WorkData\702092\stata-data\DATA_2012\ftdb2010";

*link own schooling;
joinby pnr using educ, unmatched(master);
tab _merge;
drop _merge;

*link father schooling;
rename educ educx;
rename pnr pnrx;
rename pnrf pnr;
joinby pnr using educ, unmatched(master);
tab _merge;
drop _merge;
rename educ educf;
rename pnr pnrf;
rename educx educ;
rename pnrx pnr;
label variable educ  "years of schooling";
label variable pnr   "personal identifier";
label variable educf "father years of schooling";
label variable pnrf  "father identifier";

compress;
save fatherandoffspringschooling, replace;

