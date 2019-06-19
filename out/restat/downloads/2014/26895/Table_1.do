#delimit ;
set more 1;
log using "/volumes/ddisk/math/soviet/Table_1.log", replace;


*SET 1: SOVIET PAPERS FROM AUTHOR-YEAR DATA;

use "/volumes/ddisk/math/ams/clean_ams_data_author_year.dta", clear;

generate good=.;
replace good=1 if year>=1970 & year<=1989;
egen n70=sum(good*papers), by(unique);
drop if n70==0;

merge unique using "/volumes/ddisk/math/ams/international/soviet_universe.dta";
drop _merge;

keep if soviet==1;

drop country;
rename modal_country country;

keep if year>=1982 & year<=2008;

replace good=.;
replace good=1 if year>=1985 & year<=1989;
egen n85=sum(good*papers), by(unique);
replace n85=(n85>0);

replace emigre=0 if emigre==.;

collapse (sum) papers citations_ams (mean) minyear emigre n85, by(unique post1992);

sort post1992;
by post1992: sum papers if emigre==0, detail;
by post1992: sum citations_ams if emigre==0, detail;
by post1992: sum papers if emigre==1, detail;
by post1992: sum citations_ams if emigre==1, detail;


log close;









