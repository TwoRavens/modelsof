#delimit;
clear; clear matrix;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond* iXfips;


cd "$startdir/$outputtables";


global control "yes";

if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/natcohortswconditions$control.dta",clear;
global table "tab_20_natrobust";
};
gen insample=1;

global iXnat "i.C     i.A   " ;
if "$bootstrap"=="noBS"{;
quietly xi: reg varloginc adjcumsumrecsty currrecentrecsty $iXnat [aweight=Ninc] if insample==1, /* cl($cluster) */;
        outreg adjcumsumrecsty currrecentrecsty  using  "$table",  nolabel ctitle("setup") bdec(4) se  rdec(3) replace
        addnote(year --- censusregion  ---- decade --- cohort);
};
**** begin define program to run regs deleting one of 9 conditions****;
program define maketabledeletenine;
forvalues r=1/9{;
quietly xi: reg varloginc adjcumsumrecsty currrecentrecsty $iXnat [aweight=Ninc] if insample==1 & $robust!=`r', /* cl($cluster) */;
        outreg adjcumsumrecsty currrecentrecsty using  "$table", nolabel ctitle("$robust"_`r') bdec(4) se  rdec(3) append;
di "$robust";
di `r';
};
end;
**** end define program to to run regs deleting one of 9 conditions****;


*delete one year;
gen robustyear=round( (year-1940)/10);


global robust "robustyear"; maketabledeletenine;





macro drop cond;

****deleting a decade of economic data needs to be done in a different way;
********************************************************************************************************;
**** begin define program to run regs deleting one of 9 ten-year periods ****;
program define maketabledeletedecade;
quietly{;
use "$startdir/$outputdata/forNATrobustness", clear;
replace recsty=0 if trueyear>=$startyear & trueyear<=$endyear;
sort C year;
by C year: egen currrecentrecsty=total(recsty) if yearsago<=4;
by C year: egen cumsumrecsty=total(recsty) if trueyear>inityear; 
collapse currrecentrecsty cumsumrecsty varloginc, by ( A C year);
gen adjcumsumrecsty=cumsumrecsty - currrecentrecsty;


*******TESTING;
rename cumsumrecsty mycumsumrecsty;
rename currrecentrecsty mycurrrecentrecsty;

merge year C A varloginc using "$startdir/$outputdata/natcohortswconditionsyes", sort uniqmaster keep( year C A varloginc 
                                                                                              Ninc cumsumrecsty currrecentrecsty);
};

gen insample=1;
if "$specialsample"=="yes"{;
replace insample=0 if year<1970;
replace insample=0 if year>2000;
};
sum cumsumrecsty mycumsumrecsty;
rename cumsumrecsty truecumsumrecsty;
rename mycumsumrecsty cumsumrecsty;
rename currrecentrecsty truecurrrecentrecsty;
rename mycurrrecentrecsty currrecentrecsty;

quietly xi: reg varloginc adjcumsumrecsty currrecentrecsty $iXnat [aweight=Ninc] if insample==1, /* cl($cluster) */;
        outreg adjcumsumrecsty currrecentrecsty using  "$table",  nolabel ctitle("$startyear") bdec(4) se  rdec(3) append;

end;
************************************************************************************************;
**** end define program to run regs deleting one of 9 ten-year periods ****;
**I DON'T REMEMBER WHAT THIS SPECIAL SAMPLE THING IS, BUT IT DOESN'T LOOK USEFUL;
/*global specialsample "yes";
*first line just shows what happens when you reduce to 1970 to 2000;
global startyear "2020" ; global endyear "1776"; maketabledeletedecade;
global startyear "1936" ; global endyear "1945"; maketabledeletedecade;
global startyear "1946" ; global endyear "1955"; maketabledeletedecade;
global startyear "1956" ; global endyear "1965"; maketabledeletedecade;
global startyear "1966" ; global endyear "1975"; maketabledeletedecade;
global startyear "1976" ; global endyear "1985"; maketabledeletedecade;
global startyear "1986" ; global endyear "1995"; maketabledeletedecade;
global startyear "1996" ; global endyear "2005"; maketabledeletedecade;
*/;

global specialsample "";
global startyear "1916" ; global endyear "1925"; maketabledeletedecade;
global startyear "1926" ; global endyear "1935"; maketabledeletedecade;
global startyear "1936" ; global endyear "1945"; maketabledeletedecade;
global startyear "1946" ; global endyear "1955"; maketabledeletedecade;
global startyear "1956" ; global endyear "1965"; maketabledeletedecade;
global startyear "1966" ; global endyear "1975"; maketabledeletedecade;
global startyear "1976" ; global endyear "1985"; maketabledeletedecade;
global startyear "1986" ; global endyear "1995"; maketabledeletedecade;
global startyear "1996" ; global endyear "2005"; maketabledeletedecade;













*delete two cohorts at a time;
if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/natcohortswconditions$control.dta",clear;
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata/THISnatcohortswconditions$control.dta",clear;
};

gen insample=1;
sort C year A;


quietly gen robustcohort=round(C/2) -1;
global robust "robustcohort"; maketabledeletenine;


