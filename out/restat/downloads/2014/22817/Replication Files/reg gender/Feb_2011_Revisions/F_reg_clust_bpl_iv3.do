#delimit ;
clear ;
set memory 300m ;

/*cd "E:\occdist\reg_gender" ; */
 cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\reg_gender" ;  


/*****2000*****/
#delimit;
clear;
set more off;
log using "reg_output\F_log\regression_iv3_2000.log", replace; 
use F_census00_imm.dta;
keep if metpop_country>=100;
drop metpop_imm metpop_imm_wt metpop_total_wt p_imm p_imm_wt metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt;

set matsize 500;

keep if imm_new5==1;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using F_census00_rank_edu.dta;
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

generate cntry_met = metpop_country / metpop_total ;

/*       x variables:           */
/*       p_occ_old_countrymet (% of old immigrants of e in that occ by met)  */
/*       p_native_occ (% of all old immigrants in that occ by met) */
/*       p_occ_met (% all natives in that occ by met)*/

sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using F_census90_occdist.dta;
drop if _merge==2;
drop _merge;

tabulate edu, gen(edu);
tabulate marst, gen(marst);
generate male=0 if sex==2;
replace male=1 if sex==1;

/***IV***/


/* with controls */
xi:  ivreg occpop1    age age2  english  edu2 edu3 edu4 edu5 edu6 mean_occ_edu1 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met =  p_occ_countrymet1_90 p_native_occ1_90 p_occ_met1_90 cntry_met_90)  , first  cluster(bpl);
outreg p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met age age2  english  edu2 edu3 edu4 edu5 edu6 mean_occ_edu1 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  ivreg occpop2   age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu2 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country2 p_native_occ2 p_occ_met2  cntry_met =  p_occ_countrymet2_90 p_native_occ2_90 p_occ_met2_90 cntry_met_90)  , first  cluster(bpl);
outreg p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu2 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  ivreg occpop3    age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu3 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country3 p_native_occ3 p_occ_met3  cntry_met =  p_occ_countrymet3_90 p_native_occ3_90 p_occ_met3_90 cntry_met_90)  , first  cluster(bpl);
outreg p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu3 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  ivreg occpop4     age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu4 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met =  p_occ_countrymet4_90 p_native_occ4_90 p_occ_met4_90 cntry_met_90)  , first  cluster(bpl);
outreg p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met  age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu4 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  ivreg occpop5   age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu5 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met =  p_occ_countrymet5_90 p_native_occ5_90 p_occ_met5_90 cntry_met_90)  , first  cluster(bpl);
outreg p_occ_old_country5 p_native_occ5 p_occ_met5 cntry_met  age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu5 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;




/*******no mexicans **********/
drop if bpl==200;

/* with controls */
xi:  ivreg occpop1    age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu1 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met  =  p_occ_countrymet1_90 p_native_occ1_90 p_occ_met1_90 cntry_met_90)  , first  cluster(bpl);
outreg p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met age age2  english  edu2 edu3 edu4 edu5 edu6 mean_occ_edu1 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  ivreg occpop2    age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu2 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  =  p_occ_countrymet2_90 p_native_occ2_90 p_occ_met2_90 cntry_met_90)  , first  cluster(bpl);
outreg p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu2 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  ivreg occpop3   age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu3 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country3 p_native_occ3 p_occ_met3  cntry_met =  p_occ_countrymet3_90 p_native_occ3_90 p_occ_met3_90 cntry_met_90)  , first  cluster(bpl);
outreg p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu3 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  ivreg occpop4   age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu4 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met =  p_occ_countrymet4_90 p_native_occ4_90 p_occ_met4_90 cntry_met_90)  , first  cluster(bpl);
outreg p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu4 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  ivreg occpop5    age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu5 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met =  p_occ_countrymet5_90 p_native_occ5_90 p_occ_met5_90 cntry_met_90)  , first  cluster(bpl);
outreg p_occ_old_country5 p_native_occ5 p_occ_met5 cntry_met  age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu5 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


log close; 


/**********1990********/
#delimit;
clear;
set more off;
log using "reg_output\F_log\regression_iv3_1990.log", replace; 
use F_census90_imm.dta;
keep if metpop_country>=100;
drop metpop_imm metpop_imm_wt metpop_total_wt p_imm p_imm_wt metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt;

set matsize 500;

keep if imm_new5==1;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using F_census90_rank_edu.dta;
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

generate cntry_met = metpop_country / metpop_total ;

/*       x variables:           */
/*       p_occ_old_countrymet (% of old immigrants of e in that occ by met)  */
/*       p_native_occ (% of all old immigrants in that occ by met) */
/*       p_occ_met (% all natives in that occ by met)*/

sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using F_census80_occdist.dta;
drop if _merge==2;
drop _merge;

tabulate edu, gen(edu);
tabulate marst, gen(marst);
generate male=0 if sex==2;
replace male=1 if sex==1;

/***IV***/

/* with controls */
xi:  ivreg occpop1    age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu1 marst2 marst3 marst4 marst5 marst6  i.bpl i.pwmetro i.region (p_occ_old_country1 p_native_occ1 p_occ_met1  cntry_met =  p_occ_countrymet1_80 p_native_occ1_80 p_occ_met1_80 cntry_met_80)  , first  cluster(bpl);
outreg p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met age age2  english  edu2 edu3 edu4 edu5 edu6 mean_occ_edu1 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket append;
xi:  ivreg occpop2    age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu2 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country2 p_native_occ2 p_occ_met2  cntry_met =  p_occ_countrymet2_80 p_native_occ2_80 p_occ_met2_80 cntry_met_80)  , first  cluster(bpl);
outreg p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu2 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  ivreg occpop3    age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu3 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country3 p_native_occ3 p_occ_met3  cntry_met =  p_occ_countrymet3_80 p_native_occ3_80 p_occ_met3_80 cntry_met_80)  , first  cluster(bpl);
outreg p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met  age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu3 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  ivreg occpop4    age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu4 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met =  p_occ_countrymet4_80 p_native_occ4_80 p_occ_met4_80 cntry_met_80)  , first  cluster(bpl);
outreg p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met  age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu4 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  ivreg occpop5    age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu5 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met =  p_occ_countrymet5_80 p_native_occ5_80 p_occ_met5_80 cntry_met_80)  , first  cluster(bpl);
outreg p_occ_old_country5 p_native_occ5 p_occ_met5 cntry_met  age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu5 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;



/************no mexicans**********/
drop if bpl==200;


/* with controls */

xi:  ivreg occpop1    age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu1 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country1 p_native_occ1 p_occ_met1  cntry_met =  p_occ_countrymet1_80 p_native_occ1_80 p_occ_met1_80 cntry_met_80)  , first  cluster(bpl);
outreg p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met age age2  english  edu2 edu3 edu4 edu5 edu6 mean_occ_edu1 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket append;
xi:  ivreg occpop2    age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu2 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country2 p_native_occ2 p_occ_met2  cntry_met =  p_occ_countrymet2_80 p_native_occ2_80 p_occ_met2_80 cntry_met_80)  , first  cluster(bpl);
outreg p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu2 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  ivreg occpop3    age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu3 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country3 p_native_occ3 p_occ_met3  cntry_met =  p_occ_countrymet3_80 p_native_occ3_80 p_occ_met3_80 cntry_met_80)  , first  cluster(bpl);
outreg p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu3 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  ivreg occpop4     age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu4 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met =  p_occ_countrymet4_80 p_native_occ4_80 p_occ_met4_80 cntry_met_80)  , first  cluster(bpl);
outreg p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu4 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  ivreg occpop5     age age2  english edu2 edu3 edu4 edu5 edu6  mean_occ_edu5 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met =  p_occ_countrymet5_80 p_native_occ5_80 p_occ_met5_80 cntry_met_80)  , first  cluster(bpl);
outreg p_occ_old_country5 p_native_occ5 p_occ_met5 cntry_met  age age2  english  edu2 edu3 edu4 edu5 edu6  mean_occ_edu5 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


log close;

/*********1980********/
#delimit;
clear;
set more off;
log using "reg_output\F_log\regression_iv3_1980.log", replace; 
use F_census80_imm.dta;
keep if metpop_country>=100;
drop metpop_imm metpop_imm_wt metpop_total_wt p_imm p_imm_wt metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt;

set matsize 500;

keep if imm_new5==1;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using F_census80_rank_edu.dta;
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




generate age2=age^2;
generate english=1 if  speakeng==2|speakeng==3|speakeng==4|speakeng==5;
replace english=0 if speakeng==1|speakeng==6;
generate edu=1 if educrec>=0 & educrec<=6;
replace edu=2 if educrec==7;
replace edu=3 if educrec==8;
replace edu=5 if educrec==9;

label define edu 1 "no diploma" 2 "High School" 3 "Some College" 5 "College" ;
label values edu edu;

generate cntry_met = metpop_country / metpop_total ;

/*       x variables:           */
/*       p_occ_old_countrymet (% of old immigrants of e in that occ by met)  */
/*       p_native_occ (% of all old immigrants in that occ by met) */
/*       p_occ_met (% all natives in that occ by met)*/

sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using F_census70_occdist.dta;
drop if _merge==2;
drop _merge;

tabulate edu, gen(edu);
tabulate marst, gen(marst);
generate male=0 if sex==2;
replace male=1 if sex==1;

/***IV***/

/* with controls */
xi:  ivreg occpop1   age age2  english edu2 edu3 edu4  mean_occ_edu1 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country1 p_native_occ1 p_occ_met1  cntry_met =  p_occ_countrymet1_70 p_native_occ1_70 p_occ_met1_70 cntry_met_70)  , first  cluster(bpl);
outreg p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met age age2  english  edu2 edu3 edu4 mean_occ_edu1 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket append;
xi:  ivreg occpop2   age age2  english edu2 edu3 edu4  mean_occ_edu2 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country2 p_native_occ2 p_occ_met2  cntry_met =  p_occ_countrymet2_70 p_native_occ2_70 p_occ_met2_70 cntry_met_70)  , first  cluster(bpl);
outreg p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2  english  edu2 edu3 edu4  mean_occ_edu2 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  ivreg occpop3  age age2  english edu2 edu3 edu4  mean_occ_edu3 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country3 p_native_occ3 p_occ_met3  cntry_met =  p_occ_countrymet3_70 p_native_occ3_70 p_occ_met3_70 cntry_met_70)  , first  cluster(bpl);
outreg p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met age age2  english  edu2 edu3 edu4  mean_occ_edu3 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  ivreg occpop4   age age2  english edu2 edu3 edu4  mean_occ_edu4 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met =  p_occ_countrymet4_70 p_native_occ4_70 p_occ_met4_70 cntry_met_70)  , first  cluster(bpl);
outreg p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met age age2  english  edu2 edu3 edu4  mean_occ_edu4 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  ivreg occpop5   age age2  english edu2 edu3 edu4  mean_occ_edu5 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met =  p_occ_countrymet5_70 p_native_occ5_70 p_occ_met5_70 cntry_met_70)  , first  cluster(bpl);
outreg p_occ_old_country5 p_native_occ5 p_occ_met5 cntry_met  age age2  english  edu2 edu3 edu4 mean_occ_edu5 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/*********** no mexicans *************/

drop if bpl==200;


/* with controls */
xi:  ivreg occpop1  age age2  english edu2 edu3 edu4  mean_occ_edu1 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country1 p_native_occ1 p_occ_met1  cntry_met =  p_occ_countrymet1_70 p_native_occ1_70 p_occ_met1_70 cntry_met_70)  , first  cluster(bpl);
outreg p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met age age2  english  edu2 edu3 edu4 mean_occ_edu1 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket append;
xi:  ivreg occpop2   age age2  english edu2 edu3 edu4  mean_occ_edu2 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country2 p_native_occ2 p_occ_met2  cntry_met =  p_occ_countrymet2_70 p_native_occ2_70 p_occ_met2_70 cntry_met_70)  , first  cluster(bpl);
outreg p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2  english  edu2 edu3 edu4 mean_occ_edu2 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  ivreg occpop3  age age2  english edu2 edu3 edu4  mean_occ_edu3 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country3 p_native_occ3 p_occ_met3  cntry_met =  p_occ_countrymet3_70 p_native_occ3_70 p_occ_met3_70 cntry_met_70)  , first  cluster(bpl);
outreg p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met age age2  english  edu2 edu3 edu4  mean_occ_edu3 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  ivreg occpop4  age age2  english edu2 edu3 edu4  mean_occ_edu4 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met =  p_occ_countrymet4_70 p_native_occ4_70 p_occ_met4_70 cntry_met_70)  , first  cluster(bpl);
outreg p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met age age2  english  edu2 edu3 edu4  mean_occ_edu4 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  ivreg occpop5   age age2  english edu2 edu3 edu4  mean_occ_edu5 marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region (p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met =  p_occ_countrymet5_70 p_native_occ5_70 p_occ_met5_70 cntry_met_70)  , first  cluster(bpl);
outreg p_occ_old_country5 p_native_occ5 p_occ_met5 cntry_met  age age2  english  edu2 edu3 edu4  mean_occ_edu5 marst2 marst3 marst4 marst5 marst6 using "reg_output\F_output_iv3\iv3_nomex_clust_bpl.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;

log close;

