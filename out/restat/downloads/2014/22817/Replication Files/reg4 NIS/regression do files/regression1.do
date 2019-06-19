#delimit ;
clear ;
set memory 300m ;
set matsize 800;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\reg4 NIS" ; 

log using "log\regression1.log", replace;

use "a_spouse_adult.dta";
sort pu_id;
save "a_spouse_adult.dta", replace;

use "data_nis_census"; 

sort pu_id;
merge pu_id using "a_spouse_adult.dta";
drop if _merge==2;
drop _merge;

generate spouse_hh=0 if a52==2|a52==3|a52==4|a52==5|a52==6;
replace spouse_hh=0 if a52==1 & a137_1mo<300;
replace spouse_hh=1 if a15_2==1|a15_2==2|a15_3==1|a15_3==2|a15_4==1|a15_4==2|a15_5==1|a15_5==2|a15_6==1|a15_6==2|a15_7==1|a15_7==2|a15_8==1|a15_8==2|a15_9==1|a15_9==2;
 

generate occ_change=1 if  b78oc90!= b54oc90;
replace occ_change=0 if  b78oc90 == b54oc90;
table occ_change;

generate occpop1=0 if  b78oc90<100000;
replace occpop1=1 if  b78rank_occ==1;
generate occpop2=0 if  b78oc90<100000;
replace occpop2=1 if  b78rank_occ==1| b78rank_occ==2;
generate occpop3=0 if  b78oc90<100000;
replace occpop3=1 if  b78rank_occ==1| b78rank_occ==2| b78rank_occ==3;
generate occpop4=0 if  b78oc90<100000;
replace occpop4=1 if  b78rank_occ==1| b78rank_occ==2| b78rank_occ==3| b78rank_occ==4;
generate occpop5=0 if  b78oc90<100000;
replace occpop5=1 if  b78rank_occ==1| b78rank_occ==2| b78rank_occ==3| b78rank_occ==4| b78rank_occ==5;

generate occpop1_wt=0 if  b78oc90<100000;
replace occpop1_wt=1 if  b78rank_occ_wt==1;
generate occpop2_wt=0 if  b78oc90<100000;
replace occpop2_wt=1 if  b78rank_occ_wt==1| b78rank_occ_wt==2;
generate occpop3_wt=0 if  b78oc90<100000;
replace occpop3_wt=1 if  b78rank_occ_wt==1| b78rank_occ_wt==2| b78rank_occ_wt==3;
generate occpop4_wt=0 if  b78oc90<100000;
replace occpop4_wt=1 if  b78rank_occ_wt==1| b78rank_occ_wt==2| b78rank_occ_wt==3| b78rank_occ_wt==4;
generate occpop5_wt=0 if  b78oc90<100000;
replace occpop5_wt=1 if  b78rank_occ_wt==1| b78rank_occ_wt==2| b78rank_occ_wt==3| b78rank_occ_wt==4| b78rank_occ_wt==5;


generate occpop1_chg=1 if occpop1==1 & occ_change==1;
replace occpop1_chg=0 if  occpop1==0 & occ_change==1;
generate occpop2_chg=1 if occpop2==1 & occ_change==1;
replace occpop2_chg=0 if  occpop2==0 & occ_change==1;
generate occpop3_chg=1 if occpop3==1 & occ_change==1;
replace occpop3_chg=0 if  occpop3==0 & occ_change==1;
generate occpop4_chg=1 if occpop4==1 & occ_change==1;
replace occpop4_chg=0 if  occpop4==0 & occ_change==1;
generate occpop5_chg=1 if occpop5==1 & occ_change==1;
replace occpop5_chg=0 if  occpop5==0 & occ_change==1;

generate occpop1_chg_wt=1 if occpop1_wt==1 & occ_change==1;
replace occpop1_chg_wt=0 if  occpop1_wt==0 & occ_change==1;
generate occpop2_chg_wt=1 if occpop2_wt==1 & occ_change==1;
replace occpop2_chg_wt=0 if  occpop2_wt==0 & occ_change==1;
generate occpop3_chg_wt=1 if occpop3_wt==1 & occ_change==1;
replace occpop3_chg_wt=0 if  occpop3_wt==0 & occ_change==1;
generate occpop4_chg_wt=1 if occpop4_wt==1 & occ_change==1;
replace occpop4_chg_wt=0 if  occpop4_wt==0 & occ_change==1;
generate occpop5_chg_wt=1 if occpop5_wt==1 & occ_change==1;
replace occpop5_chg_wt=0 if  occpop5_wt==0 & occ_change==1;

rename hhage_1 age;
generate age2=age^2;
generate state=b78state;
generate mean_occ_edu=b78mean_occ_edu;
generate mean_occ_edu_wt= b78mean_occ_edu_wt;

egen country_state=group( ciscobinsmo b78state), label;
egen country_occ=group( ciscobinsmo b78oc90), label;
egen occ_state=group( b78oc90 b78state), label;
generate b75yr=b75 if b75>1000 & b75<3000;
egen country_yr=group(ciscobinsmo b78year), label;
egen country_yr_state=group(ciscobinsmo b78year b78state), label;


table occpop1, contents( freq mean p_occ_old_countrystat );
table occpop2, contents( freq mean p_occ_old_countrystat );
table occpop3, contents( freq mean p_occ_old_countrystat );
table occpop4, contents( freq mean p_occ_old_countrystat );
table occpop5, contents( freq mean p_occ_old_countrystat );

summarize p_occ_old_countrystat;

/***OLS***/
xi:  regress occpop1  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;

/***with controls***/
xi:  regress occpop1  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;

/*** with controls plus ***/
xi:  regress occpop1  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;



/****weighted regressions****/

table  b78rank_occ_wt if  b78rank_occ_wt<=5  &  b78rank_occ_wt>=1, contents( freq mean p_occ_old_countrystat_wt );

table occpop1_wt, contents( freq mean p_occ_old_countrystat_wt );
table occpop2_wt, contents( freq mean p_occ_old_countrystat_wt );
table occpop3_wt, contents( freq mean p_occ_old_countrystat_wt );
table occpop4_wt, contents( freq mean p_occ_old_countrystat_wt );
table occpop5_wt, contents( freq mean p_occ_old_countrystat_wt );

summarize p_occ_old_countrystat_wt ;

/***OLS***/
xi:  regress occpop1_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us   [pweight = niswgtsamp1], robust;
outreg using "output\ols_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us   [pweight = niswgtsamp1], robust;
outreg using "output\ols_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us   [pweight = niswgtsamp1], robust;
outreg using "output\ols_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us   [pweight = niswgtsamp1], robust;
outreg using "output\ols_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us   [pweight = niswgtsamp1], robust;
outreg using "output\ols_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/***with controls***/
xi:  regress occpop1_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;

/*** with controls plus ***/
xi:  regress occpop1_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;




/*******no mexico*******/

table  b78rank_occ if  b78rank_occ<=5  &  b78rank_occ>=1 &  ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );

table occpop1 if  ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );
table occpop2 if  ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );
table occpop3 if  ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );
table occpop4 if  ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );
table occpop5 if  ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );

summarize p_occ_old_countrystat if ciscobinsmo!=135;

xi:  regress occpop1  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 , robust;
outreg using "output\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/***with controls***/
xi:  regress occpop1  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;

/*** with controls plus ***/
xi:  regress occpop1  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;



/****weighted regressions****/

table  b78rank_occ_wt if  b78rank_occ_wt<=5  &  b78rank_occ_wt>=1 & ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat_wt );

table occpop1_wt if  ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat_wt );
table occpop2_wt if  ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat_wt );
table occpop3_wt if  ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat_wt );
table occpop4_wt if  ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat_wt );
table occpop5_wt if  ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat_wt );

summarize p_occ_old_countrystat_wt if ciscobinsmo!=135;


/***OLS***/
xi:  regress occpop1_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg using "output\ols_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg using "output\ols_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg using "output\ols_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg using "output\ols_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg using "output\ols_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/***with controls***/
xi:  regress occpop1_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/*** with controls plus ***/
xi:  regress occpop1_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output\contr2_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;



/*** Regression 2:  change to popular occ conditional on changing occupations ***/


table  b78rank_occ if  b78rank_occ<=5  &  b78rank_occ>=1 & occ_change==1, contents( freq mean p_occ_old_countrystat );

table occpop1_chg, contents( freq mean p_occ_old_countrystat );
table occpop2_chg, contents( freq mean p_occ_old_countrystat );
table occpop3_chg, contents( freq mean p_occ_old_countrystat );
table occpop4_chg, contents( freq mean p_occ_old_countrystat );
table occpop5_chg, contents( freq mean p_occ_old_countrystat );

summarize p_occ_old_countrystat if occ_change==1;

/***OLS***/
xi:  regress occpop1_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output1\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output1\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output1\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output1\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output1\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/***with controls***/
xi:  regress occpop1_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;

/*** with controls plus ***/
xi:  regress occpop1_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state  i.country_state i.b78oc90 i.country_yr i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state  i.country_state i.b78oc90 i.country_yr i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state  i.country_state i.b78oc90 i.country_yr i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state  i.country_state i.b78oc90 i.country_yr i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state  i.country_state i.b78oc90 i.country_yr i.b75yr , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;



/****weighted regressions****/

table  b78rank_occ_wt if  b78rank_occ_wt<=5  &  b78rank_occ_wt>=1 & occ_change==1, contents( freq mean p_occ_old_countrystat_wt );

table occpop1_chg_wt, contents( freq mean p_occ_old_countrystat_wt );
table occpop2_chg_wt, contents( freq mean p_occ_old_countrystat_wt );
table occpop3_chg_wt, contents( freq mean p_occ_old_countrystat_wt );
table occpop4_chg_wt, contents( freq mean p_occ_old_countrystat_wt );
table occpop5_chg_wt, contents( freq mean p_occ_old_countrystat_wt );

summarize p_occ_old_countrystat_wt if occ_change==1;


/***OLS***/
xi:  regress occpop1_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us   [pweight = niswgtsamp1], robust;
outreg using "output1\ols_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us   [pweight = niswgtsamp1], robust;
outreg using "output1\ols_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us   [pweight = niswgtsamp1], robust;
outreg using "output1\ols_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us   [pweight = niswgtsamp1], robust;
outreg using "output1\ols_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us   [pweight = niswgtsamp1], robust;
outreg using "output1\ols_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/***with controls***/
xi:  regress occpop1_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state  i.b75yr [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;

/*** with controls plus ***/
xi:  regress occpop1_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr  [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/*******no mexico*******/

table  b78rank_occ if  b78rank_occ<=5  &  b78rank_occ>=1 & occ_change==1 & ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );

table occpop1_chg if ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );
table occpop2_chg if ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );
table occpop3_chg if ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );
table occpop4_chg if ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );
table occpop5_chg if ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );

summarize p_occ_old_countrystat if occ_change==1 & ciscobinsmo!=135;

xi:  regress occpop1_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 , robust;
outreg using "output1\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output1\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output1\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output1\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat  age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output1\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/***with controls***/
xi:  regress occpop1_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;

/*** with controls plus ***/
xi:  regress occpop1_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2 i.gendr eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_countrystat   p_occ_old_imm_stat p_occ_nat_stat   age age2  _Igendr_2 eng mean_occ_edu  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/****weighted regressions****/

table  b78rank_occ_wt if  b78rank_occ_wt<=5  &  b78rank_occ_wt>=1 & occ_change==1 & ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat_wt );

table occpop1_chg_wt if ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat_wt );
table occpop2_chg_wt if ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat_wt );
table occpop3_chg_wt if ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat_wt );
table occpop4_chg_wt if ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat_wt );
table occpop5_chg_wt if ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat_wt );

summarize p_occ_old_countrystat_wt if occ_change==1 & ciscobinsmo!=135;

/***OLS***/
xi:  regress occpop1_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg using "output1\ols_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg using "output1\ols_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg using "output1\ols_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg using "output1\ols_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt  age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg using "output1\ols_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/***with controls***/
xi:  regress occpop1_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;

/***with controls plus ***/
xi:  regress occpop1_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg_wt  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2 i.gendr eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b78oc90 i.country_state i.country_yr i.b75yr if  ciscobinsmo!=135 [pweight = niswgtsamp1], robust;
outreg  p_occ_old_countrystat_wt   p_occ_old_imm_stat_wt p_occ_nat_stat_wt   age age2  _Igendr_2 eng mean_occ_edu_wt  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output1\contr2_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;






log close;
