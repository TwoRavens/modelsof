#delimit ;
clear ;
set memory 300m ;
set matsize 800;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\reg4 NIS" ; 

/*log using "log\regression_rev.log", replace;*/

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
generate mean_occ_edu1=b78mean_occ_edu1;
generate mean_occ_edu2=b78mean_occ_edu2;
generate mean_occ_edu3=b78mean_occ_edu3;
generate mean_occ_edu4=b78mean_occ_edu4;
generate mean_occ_edu5=b78mean_occ_edu5;

egen country_state=group( ciscobinsmo b78state), label;
egen country_occ=group( ciscobinsmo b78oc90), label;
egen occ_state=group( b78oc90 b78state), label;
generate b75yr=b75 if b75>1000 & b75<3000;
egen country_yr=group(ciscobinsmo b78year), label;
egen country_yr_state=group(ciscobinsmo b78year b78state), label;


table occpop1, contents( freq mean p_occ_old_country1 );
table occpop2, contents( freq mean p_occ_old_country2 );
table occpop3, contents( freq mean p_occ_old_country3 );
table occpop4, contents( freq mean p_occ_old_country4 );
table occpop5, contents( freq mean p_occ_old_country5 );

summarize p_occ_old_countrystat;

/***OLS***/
xi:  regress occpop1  p_occ_old_country1   p_native_occ1 p_occ_stat1  age age2 i.gendr eng mean_occ_edu1  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output_rev\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2  p_occ_old_country2   p_native_occ2 p_occ_stat2  age age2 i.gendr eng mean_occ_edu2  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output_rev\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3  p_occ_old_country3   p_native_occ3 p_occ_stat3  age age2 i.gendr eng mean_occ_edu3  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output_rev\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4  p_occ_old_country4   p_native_occ4 p_occ_stat4  age age2 i.gendr eng mean_occ_edu4  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output_rev\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5  p_occ_old_country5   p_native_occ5 p_occ_stat5  age age2 i.gendr eng mean_occ_edu5  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output_rev\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;

/***with controls***/
xi:  regress occpop1  p_occ_old_country1   p_native_occ1 p_occ_stat1   age age2 i.gendr eng mean_occ_edu1  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_country1   p_native_occ1 p_occ_stat1   age age2  _Igendr_2 eng mean_occ_edu1  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2  p_occ_old_country2   p_native_occ2 p_occ_stat2   age age2 i.gendr eng mean_occ_edu2  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_country2   p_native_occ2 p_occ_stat2   age age2  _Igendr_2 eng mean_occ_edu2  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3  p_occ_old_country3   p_native_occ3 p_occ_stat3   age age2 i.gendr eng mean_occ_edu3  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_country3   p_native_occ3 p_occ_stat3   age age2  _Igendr_2 eng mean_occ_edu3  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4  p_occ_old_country4   p_native_occ4 p_occ_stat4   age age2 i.gendr eng mean_occ_edu4  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_country4   p_native_occ4 p_occ_stat4   age age2  _Igendr_2 eng mean_occ_edu4  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5  p_occ_old_country5   p_native_occ5 p_occ_stat5   age age2 i.gendr eng mean_occ_edu5  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_country5   p_native_occ5 p_occ_stat5   age age2  _Igendr_2 eng mean_occ_edu5  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;







/*******no mexico*******/

table  b78rank_occ if  b78rank_occ<=5  &  b78rank_occ>=1 &  ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );

table occpop1 if  ciscobinsmo!=135, contents( freq mean p_occ_old_country1 );
table occpop2 if  ciscobinsmo!=135, contents( freq mean p_occ_old_country2 );
table occpop3 if  ciscobinsmo!=135, contents( freq mean p_occ_old_country3 );
table occpop4 if  ciscobinsmo!=135, contents( freq mean p_occ_old_country4 );
table occpop5 if  ciscobinsmo!=135, contents( freq mean p_occ_old_country5 );

summarize p_occ_old_countrystat if ciscobinsmo!=135;

xi:  regress occpop1  p_occ_old_country1   p_native_occ1 p_occ_stat1  age age2 i.gendr eng mean_occ_edu1  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 , robust;
outreg using "output_rev\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2  p_occ_old_country2   p_native_occ2 p_occ_stat2  age age2 i.gendr eng mean_occ_edu2  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output_rev\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3  p_occ_old_country3   p_native_occ3 p_occ_stat3  age age2 i.gendr eng mean_occ_edu3  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output_rev\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4  p_occ_old_country4   p_native_occ4 p_occ_stat4  age age2 i.gendr eng mean_occ_edu4  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output_rev\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5  p_occ_old_country5   p_native_occ5 p_occ_stat5  age age2 i.gendr eng mean_occ_edu5  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output_rev\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/***with controls***/
xi:  regress occpop1  p_occ_old_country1   p_native_occ1 p_occ_stat1   age age2 i.gendr eng mean_occ_edu1  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_country1   p_native_occ1 p_occ_stat1   age age2  _Igendr_2 eng mean_occ_edu1  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2  p_occ_old_country2   p_native_occ2 p_occ_stat2   age age2 i.gendr eng mean_occ_edu2  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_country2   p_native_occ2 p_occ_stat2   age age2  _Igendr_2 eng mean_occ_edu2  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3  p_occ_old_country3   p_native_occ3 p_occ_stat3   age age2 i.gendr eng mean_occ_edu3  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_country3   p_native_occ3 p_occ_stat3   age age2  _Igendr_2 eng mean_occ_edu3  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4  p_occ_old_country4   p_native_occ4 p_occ_stat4   age age2 i.gendr eng mean_occ_edu4  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_country4   p_native_occ4 p_occ_stat4   age age2  _Igendr_2 eng mean_occ_edu4  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5  p_occ_old_country5   p_native_occ5 p_occ_stat5   age age2 i.gendr eng mean_occ_edu5  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_country5   p_native_occ5 p_occ_stat5   age age2  _Igendr_2 eng mean_occ_edu5  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;





/*** Regression 2:  change to popular occ conditional on changing occupations ***/


table  b78rank_occ if  b78rank_occ<=5  &  b78rank_occ>=1 & occ_change==1, contents( freq mean p_occ_old_countrystat );

table occpop1_chg, contents( freq mean p_occ_old_country1 );
table occpop2_chg, contents( freq mean p_occ_old_country2 );
table occpop3_chg, contents( freq mean p_occ_old_country3 );
table occpop4_chg, contents( freq mean p_occ_old_country4 );
table occpop5_chg, contents( freq mean p_occ_old_country5 );

summarize p_occ_old_countrystat if occ_change==1;

/***OLS***/
xi:  regress occpop1_chg  p_occ_old_country1   p_native_occ1 p_occ_stat1  age age2 i.gendr eng mean_occ_edu1  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output_rev_chng\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg  p_occ_old_country2   p_native_occ2 p_occ_stat2  age age2 i.gendr eng mean_occ_edu2  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output_rev_chng\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg  p_occ_old_country3   p_native_occ3 p_occ_stat3  age age2 i.gendr eng mean_occ_edu3  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output_rev_chng\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg  p_occ_old_country4   p_native_occ4 p_occ_stat4  age age2 i.gendr eng mean_occ_edu4  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output_rev_chng\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg  p_occ_old_country5   p_native_occ5 p_occ_stat5  age age2 i.gendr eng mean_occ_edu5  married empvisa yrs_us_schl yrs_schl expc_for expc_us  , robust;
outreg using "output_rev_chng\ols.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append; 


/***with controls***/
xi:  regress occpop1_chg  p_occ_old_country1   p_native_occ1 p_occ_stat1   age age2 i.gendr eng mean_occ_edu1  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_country1   p_native_occ1 p_occ_stat1   age age2  _Igendr_2 eng mean_occ_edu1  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev_chng\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg  p_occ_old_country2   p_native_occ2 p_occ_stat2   age age2 i.gendr eng mean_occ_edu2  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_country2   p_native_occ2 p_occ_stat2   age age2  _Igendr_2 eng mean_occ_edu2  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev_chng\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg  p_occ_old_country3   p_native_occ3 p_occ_stat3   age age2 i.gendr eng mean_occ_edu3  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_country3   p_native_occ3 p_occ_stat3   age age2  _Igendr_2 eng mean_occ_edu3  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev_chng\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg  p_occ_old_country4   p_native_occ4 p_occ_stat4   age age2 i.gendr eng mean_occ_edu4  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_country4   p_native_occ4 p_occ_stat4   age age2  _Igendr_2 eng mean_occ_edu4  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev_chng\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg  p_occ_old_country5   p_native_occ5 p_occ_stat5   age age2 i.gendr eng mean_occ_edu5  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr , robust;
outreg  p_occ_old_country5   p_native_occ5 p_occ_stat5   age age2  _Igendr_2 eng mean_occ_edu5  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev_chng\contr.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;



/*******no mexico*******/

table  b78rank_occ if  b78rank_occ<=5  &  b78rank_occ>=1 & occ_change==1 & ciscobinsmo!=135, contents( freq mean p_occ_old_countrystat );

table occpop1_chg if ciscobinsmo!=135, contents( freq mean p_occ_old_country1 );
table occpop2_chg if ciscobinsmo!=135, contents( freq mean p_occ_old_country2 );
table occpop3_chg if ciscobinsmo!=135, contents( freq mean p_occ_old_country3 );
table occpop4_chg if ciscobinsmo!=135, contents( freq mean p_occ_old_country4 );
table occpop5_chg if ciscobinsmo!=135, contents( freq mean p_occ_old_country5 );

summarize p_occ_old_countrystat if occ_change==1 & ciscobinsmo!=135;

xi:  regress occpop1_chg  p_occ_old_country1   p_native_occ1 p_occ_stat1  age age2 i.gendr eng mean_occ_edu1  married empvisa yrs_us_schl yrs_schl expc_for expc_us  if  ciscobinsmo!=135 , robust;
outreg using "output_rev_chng\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg  p_occ_old_country2   p_native_occ2 p_occ_stat2  age age2 i.gendr eng mean_occ_edu2  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output_rev_chng\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg  p_occ_old_country3   p_native_occ3 p_occ_stat3  age age2 i.gendr eng mean_occ_edu3  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output_rev_chng\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg  p_occ_old_country4   p_native_occ4 p_occ_stat4  age age2 i.gendr eng mean_occ_edu4  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output_rev_chng\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg  p_occ_old_country5   p_native_occ5 p_occ_stat5  age age2 i.gendr eng mean_occ_edu5  married empvisa yrs_us_schl yrs_schl expc_for expc_us if  ciscobinsmo!=135 , robust;
outreg using "output_rev_chng\ols_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/***with controls***/
xi:  regress occpop1_chg  p_occ_old_country1   p_native_occ1 p_occ_stat1   age age2 i.gendr eng mean_occ_edu1  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_country1   p_native_occ1 p_occ_stat1   age age2  _Igendr_2 eng mean_occ_edu1  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev_chng\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2_chg  p_occ_old_country2   p_native_occ2 p_occ_stat2   age age2 i.gendr eng mean_occ_edu2  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_country2   p_native_occ2 p_occ_stat2   age age2  _Igendr_2 eng mean_occ_edu2  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev_chng\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3_chg  p_occ_old_country3   p_native_occ3 p_occ_stat3   age age2 i.gendr eng mean_occ_edu3  married empvisa yrs_us_schl yrs_schl expc_for expc_us i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_country3   p_native_occ3 p_occ_stat3   age age2  _Igendr_2 eng mean_occ_edu3  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev_chng\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4_chg  p_occ_old_country4   p_native_occ4 p_occ_stat4   age age2 i.gendr eng mean_occ_edu4  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_country4   p_native_occ4 p_occ_stat4   age age2  _Igendr_2 eng mean_occ_edu4  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev_chng\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5_chg  p_occ_old_country5   p_native_occ5 p_occ_stat5   age age2 i.gendr eng mean_occ_edu5  married empvisa yrs_us_schl yrs_schl expc_for expc_us   i.ciscobinsmo i.b78state i.b75yr if  ciscobinsmo!=135 , robust;
outreg  p_occ_old_country5   p_native_occ5 p_occ_stat5   age age2  _Igendr_2 eng mean_occ_edu5  married empvisa yrs_us_schl yrs_schl expc_for expc_us  using "output_rev_chng\contr_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;



log close;
