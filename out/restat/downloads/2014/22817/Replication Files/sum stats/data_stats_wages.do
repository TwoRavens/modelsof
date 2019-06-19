#delimit ;
clear ;
set memory 300m ;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\reg1" ; 


/*****2000*****/
#delimit;
clear;
log using "reg2output\log\stats_wage_2000.log", replace;
use census00_imm.dta;
keep if metpop_country>=100;
drop metpop_imm metpop_imm_wt metpop_total_wt metpop_total p_imm p_imm_wt metpop_country metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt;



set matsize 500;

generate wage_hr= (incwage/ wkswork1)/ uhrswork;
generate wage_wk=wage_hr*uhrswork;
generate ft=0 if uhrswork>0 & uhrswork<35;
replace ft=1 if uhrswork>=35 & uhrswork<1000000;

table  imm_new5;
table  bpl imm_new5, row col;

keep if imm_new5==1;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using census00_rank.dta;
drop if _merge==2;
drop _merge;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using census00_edu.dta;
drop if _merge==2;
drop _merge;


generate occpop1=0 if rank_oldimm_occ<100000;
replace occpop1=1 if rank_oldimm_occ==1;
generate occpop2=0 if rank_oldimm_occ<100000;
replace occpop2=1 if rank_oldimm_occ==1|rank_oldimm_occ==2;
generate occpop3=0 if rank_oldimm_occ<100000;
replace occpop3=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3;
generate occpop4=0 if rank_oldimm_occ<100000;
replace occpop4=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4;
generate occpop5=0 if rank_oldimm_occ<100000;
replace occpop5=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4|rank_oldimm_occ==5;

generate occpop1_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop1_wt=1 if rank_oldimm_occ_wt==1;
generate occpop2_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop2_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2;
generate occpop3_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop3_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3;
generate occpop4_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop4_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3|rank_oldimm_occ_wt==4;
generate occpop5_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop5_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3|rank_oldimm_occ_wt==4|rank_oldimm_occ_wt==5;

keep if occpop1 <10000;


generate occpop1_distc=occpop1*p_occ_old_countrymet;
generate occpop2_distc=occpop2*p_occ_old_countrymet;
generate occpop3_distc=occpop3*p_occ_old_countrymet;
generate occpop4_distc=occpop4*p_occ_old_countrymet;
generate occpop5_distc=occpop5*p_occ_old_countrymet;


xtile ptilewage1000_hr= wage_hr, nq(1000);
drop if ptilewage1000_hr==1000;
drop if ptilewage1000_hr==1;
xtile ptilewage1000_wk= wage_wk, nq(1000);
drop if ptilewage1000_wk==1000;
drop if ptilewage1000_wk==1;

generate lnwage_hr= ln(wage_hr);
generate lnwage_wk= ln(wage_wk);

table occpop1, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk);
table occpop2, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop3, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop4, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop5, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
summarize wage_hr;
summarize wage_wk;
summarize occpop1_distc occpop2_distc occpop3_distc occpop4_distc occpop5_distc p_occ_old_countrymet p_native_occ p_occ_met;




generate age2=age^2;
generate english=1 if  speakeng==2|speakeng==3|speakeng==4|speakeng==5;
replace english=0 if speakeng==1|speakeng==6;
generate edu=1 if educ99>=0 & educ99<=9;
replace edu=2 if educ99==10;
replace edu=3 if educ99==11;
replace edu=4 if educ99==12| educ99==13;
replace edu=5 if educ99==14;
replace edu=6 if educ99==15| educ99==16| educ99==17;

label define edu 1 "no diploma" 2 "High School" 3 "Some College" 4 "Associates Degree" 5 "College" 6 "Graduate Degree";
label values edu edu;



/***** No mex ****/

drop if bpl==200;

table  imm_new5;

table occpop1, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk) ;
table occpop2, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk ) ;
table occpop3, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk ) ;
table occpop4, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop5, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
summarize wage_hr if occ1990;
summarize wage_wk if occ1990;
summarize occpop1_distc occpop2_distc occpop3_distc occpop4_distc occpop5_distc p_occ_old_countrymet p_native_occ p_occ_met;



log close; 

/**********1990********/
#delimit;
clear;
log using "reg2output\log\stats_wage_1990.log", replace;
use census90_imm.dta;
keep if metpop_country>=100;
drop metpop_imm metpop_imm_wt metpop_total_wt metpop_total p_imm p_imm_wt metpop_country metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt;

set matsize 500;

generate wage_hr= (incwage/ wkswork1)/ uhrswork;
generate wage_wk=wage_hr*uhrswork;
generate ft=0 if uhrswork>0 & uhrswork<35;
replace ft=1 if uhrswork>=35 & uhrswork<1000000;

table  imm_new5;
table  bpl imm_new5, row col;

keep if imm_new5==1;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using census90_rank.dta;
drop if _merge==2;
drop _merge;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using census90_edu.dta;
drop if _merge==2;
drop _merge;


generate occpop1=0 if rank_oldimm_occ<100000;
replace occpop1=1 if rank_oldimm_occ==1;
generate occpop2=0 if rank_oldimm_occ<100000;
replace occpop2=1 if rank_oldimm_occ==1|rank_oldimm_occ==2;
generate occpop3=0 if rank_oldimm_occ<100000;
replace occpop3=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3;
generate occpop4=0 if rank_oldimm_occ<100000;
replace occpop4=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4;
generate occpop5=0 if rank_oldimm_occ<100000;
replace occpop5=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4|rank_oldimm_occ==5;

generate occpop1_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop1_wt=1 if rank_oldimm_occ_wt==1;
generate occpop2_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop2_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2;
generate occpop3_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop3_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3;
generate occpop4_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop4_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3|rank_oldimm_occ_wt==4;
generate occpop5_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop5_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3|rank_oldimm_occ_wt==4|rank_oldimm_occ_wt==5;


keep if occpop1 <10000;


generate occpop1_distc=occpop1*p_occ_old_countrymet;
generate occpop2_distc=occpop2*p_occ_old_countrymet;
generate occpop3_distc=occpop3*p_occ_old_countrymet;
generate occpop4_distc=occpop4*p_occ_old_countrymet;
generate occpop5_distc=occpop5*p_occ_old_countrymet;

xtile ptilewage1000_hr= wage_hr, nq(1000);
drop if ptilewage1000_hr==1000;
drop if ptilewage1000_hr==1;
xtile ptilewage1000_wk= wage_wk, nq(1000);
drop if ptilewage1000_wk==1000;
drop if ptilewage1000_wk==1;

generate lnwage_hr= ln(wage_hr);
generate lnwage_wk= ln(wage_wk);


table occpop1, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk);
table occpop2, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop3, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop4, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop5, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
summarize wage_hr;
summarize wage_wk;
summarize occpop1_distc occpop2_distc occpop3_distc occpop4_distc occpop5_distc p_occ_old_countrymet p_native_occ p_occ_met;



generate age2=age^2;
generate english=1 if  speakeng==2|speakeng==3|speakeng==4|speakeng==5;
replace english=0 if speakeng==1|speakeng==6;

generate edu=1 if educ99>=0 & educ99<=9;
replace edu=2 if educ99==10;
replace edu=3 if educ99==11;
replace edu=4 if educ99==12| educ99==13;
replace edu=5 if educ99==14;
replace edu=6 if educ99==15| educ99==16| educ99==17;

label define edu 1 "no diploma" 2 "High School" 3 "Some College" 4 "Associates Degree" 5 "College" 6 "Graduate Degree";
label values edu edu;



/*** No Mex ****/
drop if bpl==200;

table  imm_new5;

table occpop1, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk);
table occpop2, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop3, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop4, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop5, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
summarize wage_hr;
summarize wage_wk;
summarize occpop1_distc occpop2_distc occpop3_distc occpop4_distc occpop5_distc p_occ_old_countrymet p_native_occ p_occ_met;



log close;





/*********1980********/
#delimit;
clear;
log using "reg2output\log\stats_wage_1980.log", replace;
use census80_imm.dta;
keep if metpop_country>=100;
drop metpop_imm metpop_imm_wt metpop_total_wt metpop_total p_imm p_imm_wt metpop_country metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt;

set matsize 500;

generate wage_hr= (incwage/ wkswork1)/ uhrswork;
generate wage_wk=wage_hr*uhrswork;
generate ft=0 if uhrswork>0 & uhrswork<35;
replace ft=1 if uhrswork>=35 & uhrswork<1000000;

table  imm_new5;
table  bpl imm_new5, row col;

keep if imm_new5==1;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using census80_rank.dta;
drop if _merge==2;
drop _merge;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using census80_edu.dta;
drop if _merge==2;
drop _merge;


generate occpop1=0 if rank_oldimm_occ<100000;
replace occpop1=1 if rank_oldimm_occ==1;
generate occpop2=0 if rank_oldimm_occ<100000;
replace occpop2=1 if rank_oldimm_occ==1|rank_oldimm_occ==2;
generate occpop3=0 if rank_oldimm_occ<100000;
replace occpop3=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3;
generate occpop4=0 if rank_oldimm_occ<100000;
replace occpop4=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4;
generate occpop5=0 if rank_oldimm_occ<100000;
replace occpop5=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4|rank_oldimm_occ==5;

generate occpop1_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop1_wt=1 if rank_oldimm_occ_wt==1;
generate occpop2_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop2_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2;
generate occpop3_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop3_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3;
generate occpop4_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop4_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3|rank_oldimm_occ_wt==4;
generate occpop5_wt=0 if rank_oldimm_occ_wt<100000;
replace occpop5_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3|rank_oldimm_occ_wt==4|rank_oldimm_occ_wt==5;

keep if occpop1 <10000;


generate occpop1_distc=occpop1*p_occ_old_countrymet;
generate occpop2_distc=occpop2*p_occ_old_countrymet;
generate occpop3_distc=occpop3*p_occ_old_countrymet;
generate occpop4_distc=occpop4*p_occ_old_countrymet;
generate occpop5_distc=occpop5*p_occ_old_countrymet;

xtile ptilewage1000_hr= wage_hr, nq(1000);
drop if ptilewage1000_hr==1000;
drop if ptilewage1000_hr==1;
xtile ptilewage1000_wk= wage_wk, nq(1000);
drop if ptilewage1000_wk==1000;
drop if ptilewage1000_wk==1;

generate lnwage_hr= ln(wage_hr);
generate lnwage_wk= ln(wage_wk);



table occpop1, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk);
table occpop2, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop3, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop4, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop5, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
summarize wage_hr;
summarize wage_wk;
summarize occpop1_distc occpop2_distc occpop3_distc occpop4_distc occpop5_distc p_occ_old_countrymet p_native_occ p_occ_met;



generate age2=age^2;
generate english=1 if  speakeng==2|speakeng==3|speakeng==4|speakeng==5;
replace english=0 if speakeng==1|speakeng==6;

generate edu=1 if educrec>=0 & educrec<=6;
replace edu=2 if educrec==7;
replace edu=3 if educrec==8;
replace edu=5 if educrec==9;

label define edu 1 "no diploma" 2 "High School" 3 "Some College" 5 "College" ;
label values edu edu;


/**** No mex ***/

drop if bpl==200;

table  imm_new5;

table occpop1, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk);
table occpop2, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop3, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop4, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
table occpop5, contents( freq mean p_occ_old_countrymet mean wage_hr mean wage_wk );
summarize wage_hr;
summarize wage_wk;
summarize occpop1_distc occpop2_distc occpop3_distc occpop4_distc occpop5_distc p_occ_old_countrymet p_native_occ p_occ_met;





log close;

