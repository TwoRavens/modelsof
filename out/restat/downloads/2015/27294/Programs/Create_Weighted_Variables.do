#delimit;
clear;
set mem 1g;
set more off;

cd "../Data";

tempfile temp;

cap log close;
log using weighted_variables.log, replace;

*** cpi ****;

use cpi, clear;
collapse (mean) CPI, by(year);
sort year;
save `temp'cpi;

/**** bring the data on the Internet *****/

use arpcode msa using airpAllan;
replace msa = 0 if msa == -1;
expand 11;
bysort msa arpcode: gen year = 1996+_n;
sort year msa;
compress;
save `temp'th, replace;

use "CPS.dta", clear;
sort year msa;
merge year msa using `temp'th, nokeep;
tab _merge;
keep if _merge == 3;
keep msa year InterCPS arpcode;
sort year arpcode;
compress;
save `temp'thCPS, replace;

keep msa year InterCPS;
duplicates drop;
collapse (mean) InterCPS, by(year);
rename InterCPS InterCPSav;
sort year;
compress;
save `temp'thCPS1, replace;

/**** bring the data on demog *****/

use arpcode msa using airpAllan;
replace msa = 0 if msa == -1;
expand 11;
bysort msa arpcode: gen year = 1996+_n;
sort year msa;
compress;
save `temp'th, replace;

use demog, clear;
sort year msa;
merge year using `temp'cpi,nokeep;
drop _merge;

replace  income_per_capita =  income_per_capita * CPI;
sort year msa;

merge year msa using `temp'th, nokeep;
tab _merge;
keep if _merge == 3;
keep msa year employment income_per_capita population arpcode;
sort year arpcode;
compress;
save `temp'thDemog, replace;

keep msa year employment income_per_capita population;
duplicates drop;
collapse (mean) employment income_per_capita population, by(year);
rename employment empAv;
rename income_per_capita incAv;
rename population popAv;
sort year;
compress;
save `temp'thDemog1, replace;

        /**** merge data on the Internet  ****/;

use "weights_0.dta", clear;

        rename OrigApt arpcode;
        sort year arpcode;
        merge year arpcode using `temp'thCPS, nokeep;
        drop _merge arpcode msa; 

        sort year;
        merge year using `temp'thCPS1, nokeep;
        drop _merge;

        replace InterCPSav = InterCPS if InterCPS != .;
        drop InterCPS;

        collapse (mean) InterCPSav monopoly duopoly compete [pw=passengers], by(year quarter origin dest  opcarrier);
        rename InterCPSav InterCPSadj;

        rename monopoly monop_w;
        rename duopoly duop_w;
        rename compete comp_w;

        sort year quarter origin dest opcarrier;
        compress;
        save `temp'th, replace;

        /**** merge data on the demographics ****/;

use "weights_0.dta", clear;
drop monopoly duopoly compete;

compress;

        rename OrigApt arpcode;
        sort year arpcode;
        merge year arpcode using `temp'thDemog, nokeep;
        drop _merge arpcode msa;
        compress;

        sort year;
        merge year using `temp'thDemog1, nokeep;
        drop _merge;

        replace empAv = employment if employment != .;
        replace incAv = income_per_capita if income_per_capita != .;
        replace popAv = population if population != .;
        drop employment income_per_capita population;

        collapse (mean) empAv incAv popAv [pw=passengers], by(year quarter origin dest opcarrier);

        rename empAv empl_adj;
        rename incAv incpc_adj;
        rename popAv popul_adj;

        sort year quarter origin dest opcarrier;
        compress;
        save `temp'th1, replace;

merge year quarter origin dest opcarrier using `temp'th;
drop _m;
drop if origin == "" | dest == "";
sort year quarter origin dest opcarrier;

compress;
save "Weighted_Variables.dta", replace;

log close;
exit;
