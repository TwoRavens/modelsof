* ---------------------------------------------------------------------------------------------------- *;
* This program generates the statistics and regression results for Miriam Bruhn's paper                *;
* "License to Sell: The Effect of Business Registration Reform on Entrepreneurial Activity in Mexico"  *;
* It uses the data file ene_all.dta which is created by the program creating_dataset.dta               *;
* It also uses the data files prices.dta and prices_quarterly.dta                                      *;
* ---------------------------------------------------------------------------------------------------- *;

# delimit ;
cap log close;
clear;
set more off;
set mem 750m;
set matsize 800;

cd "C:\Users\mbruhn\Documents\License to Sell\Paper\RESTAT\Data";

use ene_all.dta, clear;

log using tables_and_figures,text replace;

* ------- *;
* Table 1 *;
* ------- *;

preserve;

keep if quarter>=20001 & quarter<=20014;
gen early=1 if sare_quarter<=20041;
replace early=0 if early==.;

**Columns 1 & 2;
sum worker* regist* lnincome if early==1;
sum worker* regist* lnincome if early==0;

**Column 3;
foreach var in worker worker_lr worker_hr regist regist_lr regist_hr lnincome{;
reg `var' early,r cluster(code);
};

**Column 4;
egen sare_quarterid=group(sare_quarter);
replace sare_quarterid=sare_quarterid+1 if sare_quarter>20022;
replace sare_quarterid=sare_quarterid+1 if sare_quarter>20024;
foreach var in worker worker_lr worker_hr regist regist_lr regist_hr lnincome{;
reg `var' sare_quarterid,r cluster(code);
};

**Column 5;
keep if quarterid==3 | quarterid==7;
collapse early sare_quarter worker* regist* lnincome, by(code quarterid);
foreach var in worker worker_lr worker_hr regist regist_lr regist_hr lnincome{;
by code: gen `var'7_3=`var'[_n+1]-`var';
};
drop if quarterid==7;
foreach var in worker worker_lr worker_hr regist regist_lr regist_hr lnincome{;
reg `var'7_3 early,r;
};

**Column 6;
egen sare_quarterid=group(sare_quarter);
replace sare_quarterid=sare_quarterid+1 if sare_quarter>20022;
replace sare_quarterid=sare_quarterid+1 if sare_quarter>20024;
foreach var in worker worker_lr worker_hr regist regist_lr regist_hr lnincome{;
reg `var'7_3 sare_quarterid,r;
};

* ------- *;
* Table 2 *;
* ------- *;

restore;

xi i.quarter;
foreach x in regist regist_lr regist_hr worker worker_lr worker_hr{;
areg `x' sare female married edad primary secondary highschool university *trend pan aligned _I*,a(code) cluster(code);
};

* ------- *;
* Table 3 *;
* ------- *;

gen sare_proc=sare*proc;
foreach x in regist_lr worker_lr{;
areg `x' sare sare_proc female married edad primary secondary highschool university pan aligned *trend _I*, r a(code) cluster(code);
};

* ------- *;
* Table 4 *;
* ------- *;

preserve;

gen nonregist=own-regist;
gen notempl=1-empl;
drop own empl;

sort id quarter;
by id: egen minquarter=min(quarter);
gen first_quarter=1 if quarter==minquarter;
drop minquarter;

foreach var in regist nonregist worker notempl{;
gen p`var'=`var' if first_quarter==1 & sare==0;
sort id p`var';
by id: replace p`var'=p`var'[_n-1] if p`var'==.;
};
drop if first_quarter==1;
drop if pregist==.;

foreach y in regist nonregist worker notempl{;
gen sarep`y'=sare*p`y';
};

gen group=1 if pregist==1;
replace group=2 if pnonregist==1;
replace group=3 if pworker==1;
replace group=4 if pnotempl==1;

xi i.quarter*i.group;
xi i.code*i.group, pre(_A);
drop _Agroup*;

foreach var in female married edad primary secondary highschool university pan aligned act_fijtrend form_captrend uni_ectrend val_agtrend{;
gen `var'_nonregist=`var'*pnonregist;
gen `var'_worker_lr=`var'*pworker;
gen `var'_notempl=`var'*pnotempl;
};

**Columns 1 - 3;
foreach x in regist_lr worker_lr worker_hr{;
reg `x' sarep* female* married* edad* primary* secondary* highschool* university* pan* aligned* *trend* _I* _A*, cluster(code);
};

** Columns 4 & 5;
sort code quarter;
merge code quarter using prices_quarterly;
drop if index_quarter==.;
drop _m;
g inc4=income^(1/4);
g rlnincome=ln(income/index_quarter*100);
g rinc4=(income/index_quarter*100)^(1/4);
reg rlnincome sarep* female* married* edad* primary* secondary* highschool* university* pan* aligned* *trend* _I* _A* if pnotempl==0, cluster(code);
reg rinc4 sarep* female* married* edad* primary* secondary* highschool* university* pan* aligned* *trend* _I* _A*, cluster(code);

* ------- *;
* Table 5 *;
* ------- *;

use prices, clear;

gen sare=1 if month>=sare_month;
replace sare=0 if sare==.;

foreach var in index index_lr index_hr{;
gen ln`var'=ln(`var');
};

xi i.month;
egen monthid=group(month);
foreach var in act_fij form_cap uni_ec val_ag{;
gen `var'trend=ln(`var'99*1000/pop00)*monthid;
};

foreach var in index index_lr index_hr{;
areg ln`var' sare pan aligned *trend _I*,a(code) cluster(code);
};

* ------------- *;
* Figures 1 & 2 *;
* ------------- *;

restore;

egen sare_quarterid=group(sare_quarter);
replace sare_quarterid=sare_quarterid+8;
replace sare_quarterid=sare_quarterid+1 if sare_quarter>20022;
replace sare_quarterid=sare_quarterid+1 if sare_quarter>20024;
gen refquarter=quarterid-sare_quarterid;

keep if refquarter>=-8 & refquarter<=6;

tab refquarter, gen(lag);

foreach x in regist_lr worker_lr{;
areg `x' lag2-lag15 female married edad primary secondary highschool university _I*, a(code) cluster(code);
};

log close;


