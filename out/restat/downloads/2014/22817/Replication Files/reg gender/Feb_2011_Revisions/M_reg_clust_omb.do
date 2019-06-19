#delimit ;
clear ;
set memory 300m ;

/* cd "E:\occdist\reg_gender" ; */
 cd "C:\Users\kp\Documents\thesis_topic occdist\reg_gender" ; 

/*****2000*****/
#delimit;
clear;
set more off;
log using "Feb_2011_Revisions\log\M_OLS_clust_omb_2000.log", replace; 
use M_census00_imm.dta;
keep if metpop_country>=100;
drop metpop_imm metpop_imm_wt metpop_total_wt p_imm p_imm_wt  metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt;

set matsize 500;

table  imm_new5;
table  bpl imm_new5, row col;

keep if imm_new5==1;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using M_census00_rank_edu.dta;
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

table rank_oldimm_occ if rank_oldimm_occ<=5  & rank_oldimm_occ>=1, contents( freq mean p_occ_old_countrymet );

table occpop1, contents( freq mean p_occ_old_countrymet );
table occpop2, contents( freq mean p_occ_old_countrymet );
table occpop3, contents( freq mean p_occ_old_countrymet );
table occpop4, contents( freq mean p_occ_old_countrymet );
table occpop5, contents( freq mean p_occ_old_countrymet );

summarize p_occ_old_countrymet;

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

tabulate edu, gen(edu);
tabulate marst, gen(marst);
generate male=0 if sex==2;
replace male=1 if sex==1;

 

/*       x variables:           */
/*       p_occ_old_countrymet (% of old immigrants of e in that occ by met)  */
/*       p_native_occ (% of all old immigrants in that occ by met) */
/*       p_occ_met (% all natives in that occ by met)*/

gen str4 metrostring=string(pwmetro, "%04.0f");
gen str4 occstring=string( occ1990, "%03.0f");
gen str4 bplstring=string(bpl, "%03.0f");
generate clust_omb= metrostring+ occstring+ bplstring;
destring ( clust_omb), replace;


/***OLS***/


/******cluster and without cntry_met*******/
xi:  regress occpop1 p_occ_old_country1 p_native_occ1 p_occ_met1  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu1  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met  age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu1  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2 p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu2  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu2  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3 p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu3  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country3 p_native_occ3 p_occ_met3  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu3  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4 p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu4  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu4  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5 p_occ_old_country5 p_native_occ5 p_occ_met5 cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu5  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu5  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;



/**********no mexicans**************/

drop if bpl==200;

table  imm_new5;

table rank_oldimm_occ if rank_oldimm_occ<=5  & rank_oldimm_occ>=1, contents( freq mean p_occ_old_countrymet );

table occpop1, contents( freq mean p_occ_old_countrymet );
table occpop2, contents( freq mean p_occ_old_countrymet );
table occpop3, contents( freq mean p_occ_old_countrymet );
table occpop4, contents( freq mean p_occ_old_countrymet );
table occpop5, contents( freq mean p_occ_old_countrymet );

summarize p_occ_old_countrymet;

/***OLS***/
/******cluster and without cntry_met*******/
xi:  regress occpop1 p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu1  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country1 p_native_occ1 p_occ_met1  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu1  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2 p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu2  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country2 p_native_occ2 p_occ_met2  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu2  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3 p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu3  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met  age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu3  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4 p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu4  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu4  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5 p_occ_old_country5 p_native_occ5 p_occ_met5 cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu5  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu5  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;



log close; 

/**********1990********/
#delimit;
clear;
set more off;
log using "Feb_2011_Revisions\log\M_OLS_clust_omb_1990.log", replace;
use M_census90_imm.dta;
keep if metpop_country>=100;
drop metpop_imm metpop_imm_wt metpop_total_wt p_imm p_imm_wt metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt;

set matsize 500;

table  imm_new5;
table  bpl imm_new5, row col;

keep if imm_new5==1;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using M_census90_rank_edu.dta;
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



table rank_oldimm_occ if rank_oldimm_occ<=5  & rank_oldimm_occ>=1, contents( freq mean p_occ_old_countrymet );

table occpop1, contents( freq mean p_occ_old_countrymet );
table occpop2, contents( freq mean p_occ_old_countrymet );
table occpop3, contents( freq mean p_occ_old_countrymet );
table occpop4, contents( freq mean p_occ_old_countrymet );
table occpop5, contents( freq mean p_occ_old_countrymet );

summarize p_occ_old_countrymet;

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

tabulate edu, gen(edu);
tabulate marst, gen(marst);
generate male=0 if sex==2;
replace male=1 if sex==1;

/*       x variables:           */
/*       p_occ_old_countrymet (% of old immigrants of e in that occ by met)  */
/*       p_native_occ (% of all old immigrants in that occ by met) */
/*       p_occ_met (% all natives in that occ by met)*/

gen str4 metrostring=string(pwmetro, "%04.0f");
gen str4 occstring=string( occ1990, "%03.0f");
gen str4 bplstring=string(bpl, "%03.0f");
generate clust_omb= metrostring+ occstring+ bplstring;
destring ( clust_omb), replace;


/***OLS***/
/******cluster and without country met *******/
xi:  regress occpop1 p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met  age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu1  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country1 p_native_occ1 p_occ_met1  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu1  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket append;
xi:  regress occpop2 p_occ_old_country2 p_native_occ2 p_occ_met2  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu2  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu2  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3 p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu3  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met  age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu3  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4 p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu4  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu4  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5 p_occ_old_country5 p_native_occ5 p_occ_met5 cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu5  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu5  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;



/**********no mexicans**************/

drop if bpl==200;

table  imm_new5;

table rank_oldimm_occ if rank_oldimm_occ<=5  & rank_oldimm_occ>=1, contents( freq mean p_occ_old_countrymet );

table occpop1, contents( freq mean p_occ_old_countrymet );
table occpop2, contents( freq mean p_occ_old_countrymet );
table occpop3, contents( freq mean p_occ_old_countrymet );
table occpop4, contents( freq mean p_occ_old_countrymet );
table occpop5, contents( freq mean p_occ_old_countrymet );

summarize p_occ_old_countrymet;


/***OLS***/
/******cluster and without country met *******/
xi:  regress occpop1 p_occ_old_country1 p_native_occ1 p_occ_met1  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu1  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met  age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu1  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket append;
xi:  regress occpop2 p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu2  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country2 p_native_occ2 p_occ_met2  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu2  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3 p_occ_old_country3 p_native_occ3 p_occ_met3  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu3  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met  age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu3  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4 p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met  age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu4  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met  age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu4  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5 p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu5  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country5 p_native_occ5 p_occ_met5 cntry_met  age age2 male english edu2 edu3 edu4 edu5 edu6 mean_occ_edu5  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;





log close;

/*********1980********/
#delimit;
clear;
set more off;
log using "Feb_2011_Revisions\log\M_OLS_clust_omb_1980.log", replace;
use M_census80_imm.dta;
keep if metpop_country>=100;
drop metpop_imm metpop_imm_wt metpop_total_wt p_imm p_imm_wt metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt;

set matsize 500;

table  imm_new5;
table  bpl imm_new5, row col;

keep if imm_new5==1;
sort occ1990 pwmetro bpl;
merge occ1990 pwmetro bpl using M_census80_rank_edu.dta;
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



table rank_oldimm_occ if rank_oldimm_occ<=5  & rank_oldimm_occ>=1, contents( freq mean p_occ_old_countrymet );

table occpop1, contents( freq mean p_occ_old_countrymet );
table occpop2, contents( freq mean p_occ_old_countrymet );
table occpop3, contents( freq mean p_occ_old_countrymet );
table occpop4, contents( freq mean p_occ_old_countrymet );
table occpop5, contents( freq mean p_occ_old_countrymet );

summarize p_occ_old_countrymet;

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

tabulate edu, gen(edu);
tabulate marst, gen(marst);
generate male=0 if sex==2;
replace male=1 if sex==1;

/*       x variables:           */
/*       p_occ_old_countrymet (% of old immigrants of e in that occ by met)  */
/*       p_native_occ (% of all old immigrants in that occ by met) */
/*       p_occ_met (% all natives in that occ by met)*/

gen str4 metrostring=string(pwmetro, "%04.0f");
gen str4 occstring=string( occ1990, "%03.0f");
gen str4 bplstring=string(bpl, "%03.0f");
generate clust_omb= metrostring+ occstring+ bplstring;
destring ( clust_omb), replace;


/***OLS***/
/******cluster and without country met*******/
xi:  regress occpop1 p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met  age age2 male english edu2 edu3 edu4  mean_occ_edu1  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met  age age2 male english edu2 edu3 edu4  mean_occ_edu1  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket append;
xi:  regress occpop2 p_occ_old_country2 p_native_occ2 p_occ_met2  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu2  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country2 p_native_occ2 p_occ_met2  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu2  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3 p_occ_old_country3 p_native_occ3 p_occ_met3  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu3  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met  age age2 male english edu2 edu3 edu4  mean_occ_edu3  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4 p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met  age age2 male english edu2 edu3 edu4  mean_occ_edu4  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu4  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5 p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu5  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu5  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_omb.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;




/**********no mexicans**************/

drop if bpl==200;

table  imm_new5;

table rank_oldimm_occ if rank_oldimm_occ<=5  & rank_oldimm_occ>=1, contents( freq mean p_occ_old_countrymet );

table occpop1, contents( freq mean p_occ_old_countrymet );
table occpop2, contents( freq mean p_occ_old_countrymet );
table occpop3, contents( freq mean p_occ_old_countrymet );
table occpop4, contents( freq mean p_occ_old_countrymet );
table occpop5, contents( freq mean p_occ_old_countrymet );

summarize p_occ_old_countrymet;

/***OLS***/
/******cluster and without country met*******/
xi:  regress occpop1 p_occ_old_country1 p_native_occ1 p_occ_met1  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu1  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country1 p_native_occ1 p_occ_met1  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu1  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket append;
xi:  regress occpop2 p_occ_old_country2 p_native_occ2 p_occ_met2  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu2  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country2 p_native_occ2 p_occ_met2  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu2  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3 p_occ_old_country3 p_native_occ3 p_occ_met3  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu3  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met  age age2 male english edu2 edu3 edu4  mean_occ_edu3  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4 p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met  age age2 male english edu2 edu3 edu4  mean_occ_edu4  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu4  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5 p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu5  marst2 marst3 marst4 marst5 marst6 i.bpl i.pwmetro i.region , cluster(clust_omb);
outreg p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met age age2 male english edu2 edu3 edu4  mean_occ_edu5  marst2 marst3 marst4 marst5 marst6 using "Feb_2011_Revisions\reg_output\M_output\clust_ombl_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;




log close;

