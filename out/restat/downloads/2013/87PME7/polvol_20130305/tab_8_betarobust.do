#delimit;
clear; clear matrix;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond* iXfips;





global control "yes";

if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/statecohortswconditionsfips$control.dta",clear;
global table "tab_8_betarobust";
};
gen insample=1;

global iXfips "i.fips*i.C     i.fips*A       i.A*i.year" ;
la var betaadjcumsumrecsty betaadjcumsumrecsty;
la var betacurrrecentrecsty betacurrrecentrecsty;
if "$bootstrap"=="noBS"{;
quietly xi: reg varloginc betaadjcumsumrecsty betacurrrecentrecsty [aweight=Ninc] if insample==1, /* cl($cluster) */;
        outreg betaadjcumsumrecsty betacurrrecentrecsty  using  "$table",  nolabel ctitle("setup") bdec(4) se  rdec(3) replace
        addnote(year --- censusregion  ---- decade --- cohort);
};
**** begin define program to run regs deleting one of 9 conditions****;
program define maketabledeletenine;
forvalues r=1/9{;

quietly xi: reg varloginc betaadjcumsumrecsty betacurrrecentrecsty $iXfips [aweight=Ninc] if insample==1 & $robust!=`r', /* cl($cluster) */;
        outreg betaadjcumsumrecsty betacurrrecentrecsty using  "$table", nolabel ctitle("$robust"_`r') bdec(4) se  rdec(3) append;
di "$robust";
di `r';
};
end;
**** end define program to to run regs deleting one of 9 conditions****;


*delete one year;
gen robustyear=round( (year-1940)/10);


global robust "robustyear"; maketabledeletenine;

*delete census region;
global robust "censusregion"; maketabledeletenine;


macro drop cond;

****deleting a decade of economic data needs to be done in a different way;
********************************************************************************************************;
**** begin define program to run regs deleting one of 9 ten-year periods ****;
program define maketabledeletedecade;
quietly{;
use "$startdir/$outputdata/forrobustness", clear;
drop betarecsty;
replace recsty=0 if trueyear>=$startyear & trueyear<=$endyear;
replace leadrecsty=0 if trueyear-1>=$startyear & trueyear-1<=$endyear;
replace lagrecsty=0 if trueyear+1>=$startyear & trueyear+1<=$endyear;
sort fips C year;
by fips: gen betarecsty=gdpbetalag*lagrecsty+gdpbeta*recsty+gdpbetalead*leadrecsty;
by fips C year: egen betacurrrecentrecsty=total(betarecsty) if yearsago<=4;
by fips C year: egen betacumsumrecsty=total(betarecsty) if trueyear>inityear; 
collapse betacurrrecentrecsty betacumsumrecsty varloginc, by (fips A C year);
gen betaadjcumsumrecsty=betacumsumrecsty - betacurrrecentrecsty;

*******TESTING;
rename betacumsumrecsty mybetacumsumrecsty;
rename betacurrrecentrecsty mybetacurrrecentrecsty;
drop varloginc;

merge fips year C A using "$startdir/$outputdata/statecohortswconditionsfipsyes", sort uniqmaster keep(fips year C A varloginc 
                                                                                              Ninc betacumsumrecsty betacurrrecentrecsty);




*sum betacumsumrecsty mybetacumsumrecsty;
*bysort year: sum betacurrrecentrecsty mybetacurrrecentrecsty;
rename betacumsumrecsty truebetacumsumrecsty;
rename mybetacumsumrecsty betacumsumrecsty;
rename betacurrrecentrecsty truebetacurrrecentrecsty;
rename mybetacurrrecentrecsty betacurrrecentrecsty;
drop if fips==2 | fips==11 | fips==15;
la var betaadjcumsumrecsty betaadjcumsumrecsty;
la var betacurrrecentrecsty betacurrrecentrecsty;
};

xi: reg varloginc betaadjcumsumrecsty betacurrrecentrecsty $iXfips [aweight=Ninc], /* cl($cluster) */;
        outreg betaadjcumsumrecsty betacurrrecentrecsty using  "$table", nolabel  ctitle("$startyear") bdec(4) se  rdec(3) append;
end;
************************************************************************************************;
**** end define program to run regs deleting one of 9 ten-year periods ****;

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
use "$startdir/$outputdata/statecohortswconditionsfips$control.dta",clear;
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata/THISstatecohortswconditions$control.dta",clear;
};

gen insample=1;
drop if fips==2 | fips==11 | fips==15;
sort C year A;
la var betaadjcumsumrecsty betaadjcumsumrecsty;
la var betacurrrecentrecsty betacurrrecentrecsty;

quietly gen robustcohort=round(C/2) -1;

global robust "robustcohort"; maketabledeletenine;


