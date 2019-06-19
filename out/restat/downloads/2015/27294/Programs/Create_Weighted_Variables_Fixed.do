#delimit;
clear;
set mem 1g;
set more off;

*** this is the same as create_weighted_variables but weights are fixed ****;

cd "../Data";

tempfile temp;

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
save `temp'ash, replace;

use "CPS.dta", clear;
sort year msa;
merge year msa using `temp'ash, nokeep;
tab _merge;
keep if _merge == 3;
keep msa year InterCPS arpcode;
sort year arpcode;
compress;
save `temp'ashCPS, replace;

keep msa year InterCPS;
duplicates drop;
collapse (mean) InterCPS, by(year);
rename InterCPS InterCPSav;
sort year;
compress;
save `temp'ashCPS1, replace;

/**** bring the data on demog *****/

use arpcode msa using airpAllan;
replace msa = 0 if msa == -1;
expand 11;
bysort msa arpcode: gen year = 1996+_n;
sort year msa;
compress;
save `temp'ash, replace;

use demog, clear;
sort year msa;
merge year using `temp'cpi,nokeep;
drop _merge;

replace  income_per_capita =  income_per_capita * CPI;
sort year msa;

merge year msa using `temp'ash, nokeep;
tab _merge;
keep if _merge == 3;
keep msa year employment income_per_capita population arpcode;
sort year arpcode;
compress;
save `temp'ashDemog, replace;

keep msa year employment income_per_capita population;
duplicates drop;
collapse (mean) employment income_per_capita population, by(year);
rename employment empAv;
rename income_per_capita incAv;
rename population popAv;
sort year;
compress;
save `temp'ashDemog1, replace;

        /**** merge data on the Internet  ****/;

use "weights_0.dta", clear;

xcollapse (sum) pass_total = passengers, by(origin dest opcar OrigApt)
                 saving(ash, replace);
dmerge origin dest opcar OrigApt using ash;
drop _merge;

        rename OrigApt arpcode;
        sort year arpcode;
        merge year arpcode using `temp'ashCPS, nokeep;
        drop _merge arpcode msa; 

        sort year;
        merge year using `temp'ashCPS1, nokeep;
        drop _merge;

        replace InterCPSav = InterCPS if InterCPS != .;
        drop InterCPS;

        collapse (mean) InterCPSav HHIsegm monopoly duopoly compete [pw=pass_total], by(year quarter origin dest  opcarrier);
        rename InterCPSav InterCPSadj;

        rename monopoly monop_w;
        rename duopoly duop_w;
        rename compete comp_w;
        rename HHIsegm HHIsegm_w;

        sort year quarter origin dest opcarrier;
        compress;
        save `temp'ash, replace;

        /**** merge data on the demographics ****/;

use "weights_0.dta", clear;
drop monopoly duopoly compete HHIsegm;

xcollapse (sum) pass_total = passengers, by(origin dest opcar OrigApt)
                 saving(ash, replace);
dmerge origin dest opcar OrigApt using ash;
drop _merge;
compress;

        rename OrigApt arpcode;
        sort year arpcode;
        merge year arpcode using `temp'ashDemog, nokeep;
        drop _merge arpcode msa;
        compress;

        sort year;
        merge year using `temp'ashDemog1, nokeep;
        drop _merge;

        replace empAv = employment if employment != .;
        replace incAv = income_per_capita if income_per_capita != .;
        replace popAv = population if population != .;
        drop employment income_per_capita population;

        collapse (mean) empAv incAv popAv [pw=pass_total], by(year quarter origin dest opcarrier);

        rename empAv empl_adj;
        rename incAv incpc_adj;
        rename popAv popul_adj;

        sort year quarter origin dest opcarrier;
        compress;
        save `temp'ash1, replace;

merge year quarter origin dest opcarrier using `temp'ash;
drop _m;
drop if origin == "" | dest == "";
sort year quarter origin dest opcarrier;

compress;
save "Weighted_Variables_Fixed.dta", replace;

log close;
exit;
