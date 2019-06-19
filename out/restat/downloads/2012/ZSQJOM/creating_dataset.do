* ---------------------------------------------------------------------------------------------------- *;
* This program creates the main dataset used in Miriam Bruhn's paper                                   *;
* "License to Sell: The Effect of Business Registration Reform on Entrepreneurial Activity in Mexico"  *;
* The input ENE files can be downloaded from INEGI's website, as explained in the Readme.txt file      *;
* In addition to these ENE files, this program also uses the following input files (see Readme.txt)    *;
* sare.dta                                                                                             *;
* low_risk_cae.dta                                                                                     *;
* political_parties.dta                                                                                *;
* census_data.dta                                                                                      *;
* ---------------------------------------------------------------------------------------------------- *;

# delimit ;
clear;
set more off;
set mem 750m;

cd "C:\Users\mbruhn\Documents\License to Sell\Paper\RESTAT\Data";

* ------------------------------ *;
* Combining all quarters of data *;
* -------------------------------*;

use ene200, replace;

gen quarter=20002;

foreach var in 300 400 101 201 301 401 102 202 302 402 103 203 303 403 104 204 304 404{;

append using ene`var'.dta;

forvalues x=0/4{;
forvalues i=1/4{;
replace quarter=200`x'`i' if `var'==`i'0`x' & quarter==.;
};
};

};

keep quarter n_ent h_mud ent a_met con v_sel hog r_trh mun eda sex e_civ esc p1a1 p1a3 p1a4 p1b p1d p1e p3a p4 p5 p5b p7a_2;

rename eda edad;
keep if edad>=20 & edad<=65; *Keeping only individuals of working age;

foreach var in n_ent ent mun p1b p1d p1e p4 p5 p5b p7a_2{;
destring `var', replace;
};

* --------------------------------------------------------------- *;
* Generating unique id variable that links observations over time *;
* --------------------------------------------------------------- *;

egen quarterid=group(quarter);
gen unique=quarterid+4-n_ent; *This is needed since some IDs were re-used for other households in later years, 
it identifies the quarter when a household was first interviewed;
drop if h_mud=="09"; *These are households that moved away and have been replaced with a new household in the same buidling;
egen id=concat(ent a_met con v_sel hog h_mud unique r_trh),punct(_);
drop n_ent hog h_mud a_met con v_sel unique r_trh;

* ---------------------------------- *;
* Generating INEGI municipality code *;
* ---------------------------------- *;

drop if mun==0;
gen code=ent*1000+mun;
drop ent mun;

* ----------------------------------------------------- *;
* Merging with SARE data and generating treatment dummy *;
* ------------------------------------------------------*;

sort code;
merge code using sare;
drop if _merge==2;
drop _merge;

drop if sare_quarter==.; *Keeping only municipalities that adopted SARE before 2005;
drop if code==11011 | code==11037; *These are not in the survey in 2000/2001, meaning there is no pre-program comparison for them;

gen sare=1 if quarter>=sare_quarter;
replace sare=0 if sare==.;

* ------------------------------------- *;
* Merging with low_risk activities list *;
* ------------------------------------- *;

drop if p5b==9999; *Not specified;
rename p5b activi_a;
drop if p4==9900 | p4==9910 | p4==9920; *Not specified;
sort activi_a;
merge activi_a using low_risk_cae;
gen low_risk=1 if _merge==3;
replace low_risk=0 if low_risk==.;
drop _merge;
replace low_risk=1 if activi_a>=6001 & activi_a<=6016 & p4>=5260 & p4<=5269; *These are construction workers;
replace low_risk=1 if activi_a==6452 & p4~=5520; *These are car rentals, non-drivers;
drop p4 activi_a;

* ---------------------------- *;
* Generating outcome variables *;
* ---------------------------- *;

**In the labor force dummy;
drop if p1a1=="0"; *Did not answer the questions;
drop if p1d==9; *Value=Don't know;
drop if p1e>2;  *Value=Don't know;
gen lf=1 if p1a1=="1" | p1a4=="11" | p1a4=="12" | p1e==1;
replace lf=1 if p1b>=1 & p1b<=3; *This captures people who were on paid vacation or sick leave or stike last week;
replace lf=1 if p1b>=4 & p1d<=2; *This captures people who didn't work last week for other reasons, but will return to work within a month;
replace lf=1 if p1a3=="1" & p1d<=2; *This captures people who have a job lined up, but who haven't started it yet;
replace lf=0 if lf==.;
drop p1a1 p1a4 p1b;

gen lined_up=1 if p1a3=="1" & p1d<=2;
replace lined_up=0 if lined_up==.;
drop p1a3 p1d;

foreach var in ue empl worker worker_lr worker_hr own regist regist_lr{;
g `var'=0;
};

**Unemployed dummy;
replace ue=1 if lf==1 & p1e==1; *This captures people who do not have a job, but are looking for one;
drop p1e;

**Employed dummy;
replace empl=1 if lf==1 & ue==0 & lined_up==0;

**Own business dummy;
drop if p3a=="9"; *Value=Don't know;
replace own=1 if empl==1 & p3a=="1" | empl==1 & p3a=="2";
drop p3a;

**Wage-earner dummies;
replace worker=1 if empl==1 & own==0;
replace worker_lr=1 if worker==1 & low_risk==1;
replace worker_hr=1 if worker==1 & low_risk==0;

**Registered business owner dummies;
drop if p5>7; *Works in the US or Value=Don't know;
replace regist=1 if own==1 & p5>=1 & p5<=4;
replace regist_lr=1 if regist==1 & low_risk==1;
gen regist_hr=regist-regist_lr;
drop p5 low_risk;

**Income;
replace p7a_2=. if p7a_2==999999 | p7a_2==999998 | p7a_2==888888; *This denotes missing income;
rename p7a_2 income;
replace income=0 if empl==0;
gen lnincome=ln(income);

drop lf lined_up ue; *These variables were only used for defining the other variables for this paper;

* --------------------------------------- *;
* Generating individual control variables *;
* --------------------------------------- *;

**Female dummy;
gen female=1 if sex=="2";
replace female=0 if sex=="1";
drop sex;

**Married dummy;
drop if e_civ=="9"; *Value=Don't know;
gen married=1 if e_civ=="2" | e_civ=="3";
replace married=0 if married==.;
drop e_civ;

**Education dummies;
*For education, it's hard to construct a years of schooling variable since the coding doesn't list years of schooling for technical degrees (8% of the sample);
*For the education variables, I count technical education after primary (secondary, prepa) school as secondary (prepa, lic) education*;
*I'm dropping the few people with schooling levels 17,19,29,39,49,59,and 69, which must be either wrong, or undeclared;

gen nivel_es=substr(esc,1,2);
drop if nivel_es=="99" | nivel_es=="17" | nivel_es=="19" | nivel_es=="29" | nivel_es=="39" | nivel_es=="49" | nivel_es=="59" | nivel_es=="69";

gen primary=1 if nivel_es=="16";
forval x=1/2{;
replace primary=1 if nivel_es=="2`x'";
};
replace primary=1 if nivel_es=="1N";

gen secondary=1 if nivel_es=="23" | nivel_es=="1T";
forval x=1/2{;
replace secondary=1 if nivel_es=="3`x'";
};
replace secondary=1 if nivel_es=="2N";

gen highschool=1 if nivel_es=="33" | nivel_es=="3T" | nivel_es=="2T";
*The coding makes it impossible to distinguish between completed terminal (after prepa) and simulatneous (during prepa) technical studies - both are coded 3T*;
*However, most courses of study 3T seem to be simultaneuos at the prepa level (judging from the fact that there are relatively few 3N)*;
*Similarly, for 2T, most courses of study seem to be terminal (judging from the fact that there are relatively many 2N)*;
forval x=1/6{;
replace highschool=1 if nivel_es=="4`x'";
};
replace highschool=1 if nivel_es=="3N";

gen university=1 if nivel_es=="4T";
forval x=1/3{;
replace university=1 if nivel_es=="5`x'";
};
replace university=1 if nivel_es=="5T";
forval x=1/3{;
replace university=1 if nivel_es=="6`x'";
};
replace university=1 if nivel_es=="6T";

foreach var in primary secondary highschool university{;
replace `var'=0 if `var'==.;
};

drop nivel_es esc;

* ---------------------------------------------------------------------------- *;
* Merging with political party data and generating political control variables *;
* ---------------------------------------------------------------------------- *;

sort code quarter;
merge code quarter using political_parties;
drop if _m==2;
drop _m;

foreach var in pan aligned{;
gen `var'=0;
};

replace pan=1 if party_mun=="pan" | party_mun=="panprd" | party_mun=="panprdpt" | party_mun=="panpvem";
replace aligned=1 if party_gob=="pan" & pan==1 | party_gob=="panprdptprs" & pan==1 | party_gob=="panprdptpvem" & pan==1 | party_gob=="panpvem" & pan==1;
drop party*;

* ------------------------------------------------------------------ *;
* Merging with census data and generating economic control variables *;
* ------------------------------------------------------------------ *;

foreach var in census_data{;
sort code;
merge code using `var';
drop _m;
};

foreach var in act_fij form_cap uni_ec val_ag{;
gen `var'trend=ln(`var'99*1000/pop00)*quarterid;
};
drop pop00 *99;

compress;

save ene_all, replace;





