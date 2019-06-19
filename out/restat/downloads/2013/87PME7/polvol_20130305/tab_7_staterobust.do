#delimit;
clear; clear matrix;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond* iXfips;




global control "yes";
******WITHIN: (ORIGINAL VERSION)
******global iXfips "i.fips*i.C     i.fips*A       i.A*i.year" ;
if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/statecohortswconditionsfips$control.dta",clear;
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata/THISstatecohortswconditions$control.dta",clear;
};

gen insample=0;
replace insample=1 if  year>=1955;
drop if fips==2 | fips==11 | fips==15;
sort C year A;

cd "$startdir/$outputtables";

if "$bootstrap"=="noBS"{;
global table "tab_7_staterobust";
};

if "$bootstrap"=="BS"{;
global table "bootstrap_tab_7_staterobust";
};



global iXfips "i.fips*i.C     i.fips*A       i.A*i.year" ;
if "$bootstrap"=="noBS"{;
quietly xi: reg varloginc adjcumsumneggrowth currrecentneggrowth [aweight=Ninc] if insample==1, /* cl($cluster) */;
        outreg adjcumsumneggrowth currrecentneggrowth  using  "$table", /* nolabel */ ctitle("setup") bdec(4) se  rdec(3) replace
        addnote(year --- censusregion  ---- decade --- cohort);
};

**** begin define program to run regs deleting one of 8 conditions****;
program define maketabledeleteeight;
forvalues r=1/8{;
quietly xi: reg varloginc adjcumsumneggrowth currrecentneggrowth $iXfips [aweight=Ninc] if insample==1 & $robust!=`r', /* cl($cluster) */;
        outreg adjcumsumneggrowth currrecentneggrowth using  "$table", /* nolabel */ ctitle("$robust"_`r') bdec(4) se  rdec(3) append;
di "$robust";
di `r';
};
end;
**** end define program to to run regs deleting one of 8 conditions****;


*delete one year (only 6 since 1950 doesn't count);
gen robustyear=round( (year-1950)/10);
global robust "robustyear"; maketabledeleteeight;

*delete census region;
*condense to eight censusregions;
replace censusregion=5 if censusregion==6;
replace censusregion=6 if censusregion==7;
replace censusregion=7 if censusregion==8;
replace censusregion=8 if censusregion==9;
tab censusregion;
global robust "censusregion"; maketabledeleteeight;


macro drop cond;
****deleting a decade of economic data needs to be done in a different way;
********************************************************************************************************;


**** begin define program to run regs deleting one of 9 five-year periods on which we have state GDP data****;
program define maketabledeletefiveyears;
quietly{;
use "$startdir/$outputdata/alleconconds", clear;

drop if fips==2 | fips==11 | fips==15;
tab neggrowth if year>=$startyear & year<=$endyear;
replace neggrowth=0 if year>=$startyear & year<=$endyear;
keep neggrowth year fips;
sort fips;
by fips: gen cumsumneggrowth=sum(neggrowth) if neggrowth!=.;
sort fips year;
by fips: gen currrecentneggrowth=cumsumneggrowth-cumsumneggrowth[_n-5];
quietly save "$startdir/$outputdata/THISstatereturnscumsum.dta", replace;
rename year curryear;
sort fips curryear;
quietly save "$startdir/$outputdata/THISstatereturnscurrcumsum.dta", replace;

use "$startdir/$outputdata/THISstatereturnscumsum.dta", clear;
rename year inityear;
sort fips inityear;
drop currrecentneggrowth;
quietly save "$startdir/$outputdata/THISstatereturnsinitcumsum.dta", replace;

*********load the cohort data******;
use year fips A C using "$startdir/$outputdata/statecohorts_fweight$control", clear;
quietly gen insample=0;
replace insample=1 if  year>=1955;
sort fips;
merge fips using "$startdir/$outputdata/fipscodestemp", sort uniqusing;
drop _merge;
****call the year we see the cohort the current year;
quietly gen curryear=year;
sort fips curryear;
merge fips curryear using "$startdir/$outputdata/THISstatereturnscurrcumsum.dta", sort uniqusing;
keep if year!=.;
drop if _merge!=3;
drop _merge;
rename cumsumneggrowth currcumsumneggrowth;

quietly gen inityear=year-A*5;
sort fips inityear;
merge fips inityear using "$startdir/$outputdata/THISstatereturnsinitcumsum.dta", sort uniqusing;
quietly keep if year!=.;
quietly drop if _merge!=3;
drop _merge;

rename cumsumneggrowth initcumsumneggrowth;
quietly gen cumsumneggrowth=currcumsumneggrowth-initcumsumneggrowth;
drop if fips==2 | fips==11 | fips==15;
*******TESTING;
rename cumsumneggrowth mycumsumneggrowth;
rename currrecentneggrowth mycurrrecentneggrowth;
if "$bootstrap"=="noBS"{;
merge fips year C A using "$startdir/$outputdata/statecohortswconditionsfips$control", sort;
};

if "$bootstrap"=="BS"{;
merge fips year C A using "$startdir/$outputdata/THISstatecohortswconditionsyes", sort;
};

sum cumsumneggrowth mycumsumneggrowth if insample==1;
bysort year: sum currrecentneggrowth mycurrrecentneggrowth if insample==1;
rename cumsumneggrowth truecumsumneggrowth;
rename mycumsumneggrowth cumsumneggrowth;
rename currrecentneggrowth truecurrrecentneggrowth;
rename mycurrrecentneggrowth currrecentneggrowth;
drop adjcumsumneggrowth;
gen adjcumsumneggrowth=cumsumneggrowth-currrecentneggrowth;
quietly xi: reg varloginc adjcumsumneggrowth currrecentneggrowth $iXfips [aweight=Ninc] if insample==1, /* cl($cluster) */;
        outreg adjcumsumneggrowth currrecentneggrowth using  "$table", /* nolabel */ ctitle("$startyear") bdec(4) se  rdec(3) append;
};
end;
************************************************************************************************;
**** begin define program to run regs deleting one of 8 five-year periods on which we have state GDP data****;

global startyear "1964" ; global endyear "1970"; maketabledeletefiveyears;
global startyear "1971" ; global endyear "1975"; maketabledeletefiveyears;
global startyear "1976" ; global endyear "1980"; maketabledeletefiveyears;
global startyear "1981" ; global endyear "1985"; maketabledeletefiveyears;
global startyear "1986" ; global endyear "1990"; maketabledeletefiveyears;
global startyear "1991" ; global endyear "1995"; maketabledeletefiveyears;
global startyear "1996" ; global endyear "2000"; maketabledeletefiveyears;
global startyear "2001" ; global endyear "2005"; maketabledeletefiveyears;



*delete two cohorts at a time;

if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/statecohortswconditionsfips$control.dta",clear;
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata/THISstatecohortswconditionsfips$control.dta",clear;
};

quietly gen insample=0;
replace insample=1 if  year>=1955;
drop if fips==2 | fips==11 | fips==15;


quietly gen robustcohort=round(C/2) -2;
global robust "robustcohort"; maketabledeleteeight;


erase "$startdir/$outputdata/THISstatereturnscurrcumsum.dta";
erase "$startdir/$outputdata/THISstatereturnscumsum.dta";
erase "$startdir/$outputdata/THISstatereturnsinitcumsum.dta";

