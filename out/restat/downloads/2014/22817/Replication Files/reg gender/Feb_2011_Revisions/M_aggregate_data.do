#delimit ;
clear ;
set memory 300m ;

cd "C:\Users\kp\Documents\thesis_topic occdist\reg_gender" ; 


/*****2000*****/
#delimit;
clear;
use M_census00_imm.dta;
keep if metpop_country>=100;
drop metpop_imm metpop_imm_wt metpop_total_wt p_imm p_imm_wt metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt;
generate cntry_met = metpop_country / metpop_total ;

set matsize 500;

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
#delimit;
generate edu1=0;
replace edu1=1 if edu==1;
generate edu2=0;
replace edu2=1 if edu==2;
generate edu3=0;
replace edu3=1 if edu==3;
generate edu4=0;
replace edu4=1 if edu==4;
generate edu5=0;
replace edu5=1 if edu==5;
generate edu6=0;
replace edu6=1 if edu==6;

generate marst1=0;
replace marst1=1 if marst==1;
generate marst2=0;
replace marst2=1 if marst==2;
generate marst3=0;
replace marst3=1 if marst==3;
generate marst4=0;
replace marst4=1 if marst==4;
generate marst5=0;
replace marst5=1 if marst==5;
generate marst6=0;
replace marst6=1 if marst==6;

collapse (sum) pop (mean) occpop1 occpop2 occpop3 occpop4 occpop5 cntry_met p_occ_old_country1 p_occ_old_country2 p_occ_old_country3 p_occ_old_country4 p_occ_old_country5 p_native_occ1 p_native_occ2 p_native_occ3 p_native_occ4 p_native_occ5 p_occ_met1 p_occ_met2 p_occ_met3 p_occ_met4 p_occ_met5 age sex english age2 mean_occ_edu1 mean_occ_edu2 mean_occ_edu3 mean_occ_edu4 mean_occ_edu5 edu1 edu2 edu3 edu4 edu5 edu6 marst1 marst2 marst3 marst4 marst5 marst6, by (pwmetro bpl) ;

rename pop pop_00;
rename 	occpop1	 	occpop1_00	;
rename 	occpop2	 	occpop2_00	;
rename 	occpop3	 	occpop3_00	;
rename 	occpop4	 	occpop4_00	;
rename 	occpop5	 	occpop5_00	;
rename cntry_met cntry_met_00;
rename 	p_occ_old_country1	 	p_occ_old_country1_00	;
rename 	p_occ_old_country2	 	p_occ_old_country2_00	;
rename 	p_occ_old_country3	 	p_occ_old_country3_00	;
rename 	p_occ_old_country4	 	p_occ_old_country4_00	;
rename 	p_occ_old_country5	 	p_occ_old_country5_00	;
rename 	p_native_occ1	 	p_native_occ1_00	;
rename 	p_native_occ2	 	p_native_occ2_00	;
rename 	p_native_occ3	 	p_native_occ3_00	;
rename 	p_native_occ4	 	p_native_occ4_00	;
rename 	p_native_occ5	 	p_native_occ5_00	;
rename 	p_occ_met1	 	p_occ_met1_00	;
rename 	p_occ_met2	 	p_occ_met2_00	;
rename 	p_occ_met3	 	p_occ_met3_00	;
rename 	p_occ_met4	 	p_occ_met4_00	;
rename 	p_occ_met5	 	p_occ_met5_00	;
rename 	age	 	age_00	;
rename 	sex	 	sex_00	;
rename 	english	 	english_00	;
rename 	age2	 	age2_00	;
rename 	mean_occ_edu1	 	mean_occ_edu1_00	;
rename 	mean_occ_edu2	 	mean_occ_edu2_00	;
rename 	mean_occ_edu3	 	mean_occ_edu3_00	;
rename 	mean_occ_edu4	 	mean_occ_edu4_00	;
rename 	mean_occ_edu5	 	mean_occ_edu5_00	;
rename 	edu1	 	edu1_00	;
rename 	edu2	 	edu2_00	;
rename 	edu3	 	edu3_00	;
rename 	edu4	 	edu4_00	;
rename 	edu5	 	edu5_00	;
rename 	edu6	 	edu6_00	;
rename 	marst1	 	marst1_00	;
rename 	marst2	 	marst2_00	;
rename 	marst3	 	marst3_00	;
rename 	marst4	 	marst4_00	;
rename 	marst5	 	marst5_00	;
rename 	marst6	 	marst6_00	;

sort pwmetro bpl;
save M_agg_data00.dta, replace;


/**********1990********/
#delimit;
clear;
use M_census90_imm.dta;
keep if metpop_country>=100;
drop metpop_imm metpop_imm_wt metpop_total_wt p_imm p_imm_wt metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt;
generate cntry_met = metpop_country / metpop_total ;

set matsize 500;

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

generate edu1=0;
replace edu1=1 if edu==1;
generate edu2=0;
replace edu2=1 if edu==2;
generate edu3=0;
replace edu3=1 if edu==3;
generate edu4=0;
replace edu4=1 if edu==4;
generate edu5=0;
replace edu5=1 if edu==5;
generate edu6=0;
replace edu6=1 if edu==6;

generate marst1=0;
replace marst1=1 if marst==1;
generate marst2=0;
replace marst2=1 if marst==2;
generate marst3=0;
replace marst3=1 if marst==3;
generate marst4=0;
replace marst4=1 if marst==4;
generate marst5=0;
replace marst5=1 if marst==5;
generate marst6=0;
replace marst6=1 if marst==6;

collapse (sum) pop (mean) occpop1 occpop2 occpop3 occpop4 occpop5 cntry_met p_occ_old_country1 p_occ_old_country2 p_occ_old_country3 p_occ_old_country4 p_occ_old_country5 p_native_occ1 p_native_occ2 p_native_occ3 p_native_occ4 p_native_occ5 p_occ_met1 p_occ_met2 p_occ_met3 p_occ_met4 p_occ_met5 age sex english age2 mean_occ_edu1 mean_occ_edu2 mean_occ_edu3 mean_occ_edu4 mean_occ_edu5 edu1 edu2 edu3 edu4 edu5 edu6 marst1 marst2 marst3 marst4 marst5 marst6, by (pwmetro bpl) ;
rename pop pop_90;
rename 	occpop1	 	occpop1_90	;
rename 	occpop2	 	occpop2_90	;
rename 	occpop3	 	occpop3_90	;
rename 	occpop4	 	occpop4_90	;
rename 	occpop5	 	occpop5_90	;
rename cntry_met cntry_met_90;
rename 	p_occ_old_country1	 	p_occ_old_country1_90	;
rename 	p_occ_old_country2	 	p_occ_old_country2_90	;
rename 	p_occ_old_country3	 	p_occ_old_country3_90	;
rename 	p_occ_old_country4	 	p_occ_old_country4_90	;
rename 	p_occ_old_country5	 	p_occ_old_country5_90	;
rename 	p_native_occ1	 	p_native_occ1_90	;
rename 	p_native_occ2	 	p_native_occ2_90	;
rename 	p_native_occ3	 	p_native_occ3_90	;
rename 	p_native_occ4	 	p_native_occ4_90	;
rename 	p_native_occ5	 	p_native_occ5_90	;
rename 	p_occ_met1	 	p_occ_met1_90	;
rename 	p_occ_met2	 	p_occ_met2_90	;
rename 	p_occ_met3	 	p_occ_met3_90	;
rename 	p_occ_met4	 	p_occ_met4_90	;
rename 	p_occ_met5	 	p_occ_met5_90	;
rename 	age	 	age_90	;
rename 	sex	 	sex_90	;
rename 	english	 	english_90	;
rename 	age2	 	age2_90	;
rename 	mean_occ_edu1	 	mean_occ_edu1_90	;
rename 	mean_occ_edu2	 	mean_occ_edu2_90	;
rename 	mean_occ_edu3	 	mean_occ_edu3_90	;
rename 	mean_occ_edu4	 	mean_occ_edu4_90	;
rename 	mean_occ_edu5	 	mean_occ_edu5_90	;
rename 	edu1	 	edu1_90	;
rename 	edu2	 	edu2_90	;
rename 	edu3	 	edu3_90	;
rename 	edu4	 	edu4_90	;
rename 	edu5	 	edu5_90	;
rename 	edu6	 	edu6_90	;
rename 	marst1	 	marst1_90	;
rename 	marst2	 	marst2_90	;
rename 	marst3	 	marst3_90	;
rename 	marst4	 	marst4_90	;
rename 	marst5	 	marst5_90	;
rename 	marst6	 	marst6_90	;

sort pwmetro bpl;
save M_agg_data90.dta, replace;

/**********merge 2000 and 1990 and run regressions***********/
#delimit;
clear;
log using "reg_agg_data\M_output\M_regression.log", replace; 
use M_agg_data00.dta;
merge pwmetro bpl using M_agg_data90.dta;
drop _merge;

generate 	occpop1	=	occpop1_00	-	occpop1_90	;
generate 	occpop2	=	occpop2_00	-	occpop2_90	;
generate 	occpop3	=	occpop3_00	-	occpop3_90	;
generate 	occpop4	=	occpop4_00	-	occpop4_90	;
generate 	occpop5	=	occpop5_00	-	occpop5_90	;
generate 	cntry_met	=	cntry_met_00	-	cntry_met_90	;
generate 	p_occ_old_country1	=	p_occ_old_country1_00	-	p_occ_old_country1_90	;
generate 	p_occ_old_country2	=	p_occ_old_country2_00	-	p_occ_old_country2_90	;
generate 	p_occ_old_country3	=	p_occ_old_country3_00	-	p_occ_old_country3_90	;
generate 	p_occ_old_country4	=	p_occ_old_country4_00	-	p_occ_old_country4_90	;
generate 	p_occ_old_country5	=	p_occ_old_country5_00	-	p_occ_old_country5_90	;
generate 	p_native_occ1	=	p_native_occ1_00	-	p_native_occ1_90	;
generate 	p_native_occ2	=	p_native_occ2_00	-	p_native_occ2_90	;
generate 	p_native_occ3	=	p_native_occ3_00	-	p_native_occ3_90	;
generate 	p_native_occ4	=	p_native_occ4_00	-	p_native_occ4_90	;
generate 	p_native_occ5	=	p_native_occ5_00	-	p_native_occ5_90	;
generate 	p_occ_met1	=	p_occ_met1_00	-	p_occ_met1_90	;
generate 	p_occ_met2	=	p_occ_met2_00	-	p_occ_met2_90	;
generate 	p_occ_met3	=	p_occ_met3_00	-	p_occ_met3_90	;
generate 	p_occ_met4	=	p_occ_met4_00	-	p_occ_met4_90	;
generate 	p_occ_met5	=	p_occ_met5_00	-	p_occ_met5_90	;
generate 	age	=	age_00	-	age_90	;
generate 	sex	=	sex_00	-	sex_90	;
generate 	english	=	english_00	-	english_90	;
generate 	age2	=	age2_00	-	age2_90	;
generate 	mean_occ_edu1	=	mean_occ_edu1_00	-	mean_occ_edu1_90	;
generate 	mean_occ_edu2	=	mean_occ_edu2_00	-	mean_occ_edu2_90	;
generate 	mean_occ_edu3	=	mean_occ_edu3_00	-	mean_occ_edu3_90	;
generate 	mean_occ_edu4	=	mean_occ_edu4_00	-	mean_occ_edu4_90	;
generate 	mean_occ_edu5	=	mean_occ_edu5_00	-	mean_occ_edu5_90	;
generate 	edu1	=	edu1_00	-	edu1_90	;
generate 	edu2	=	edu2_00	-	edu2_90	;
generate 	edu3	=	edu3_00	-	edu3_90	;
generate 	edu4	=	edu4_00	-	edu4_90	;
generate 	edu5	=	edu5_00	-	edu5_90	;
generate 	edu6	=	edu6_00	-	edu6_90	;
generate 	marst1	=	marst1_00	-	marst1_90	;
generate 	marst2	=	marst2_00	-	marst2_90	;
generate 	marst3	=	marst3_00	-	marst3_90	;
generate 	marst4	=	marst4_00	-	marst4_90	;
generate 	marst5	=	marst5_00	-	marst5_90	;
generate 	marst6	=	marst6_00	-	marst6_90	;

/***OLS***/

xi:  regress occpop1 p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met  age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu1 marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl);
outreg using "reg_agg_data\M_output\clust.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2 p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu2  marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl);
outreg using "reg_agg_data\M_output\clust.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3 p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met  age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu3  marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl);
outreg using "reg_agg_data\M_output\clust.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4 p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu4  marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl);
outreg using "reg_agg_data\M_output\clust.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5 p_occ_old_country5 p_native_occ5 p_occ_met5 cntry_met  age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu5  marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl);
outreg using "reg_agg_data\M_output\clust.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;


/**********no mexicans**************/

drop if bpl==200;

xi:  regress occpop1 p_occ_old_country1 p_native_occ1 p_occ_met1  cntry_met age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu1  marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl);
outreg using "reg_agg_data\M_output\clust_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2 p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu2  marst1 marst2 marst3 marst4 marst5 marst6 , cluster(bpl);
outreg using "reg_agg_data\M_output\clust_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3 p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met  age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu3  marst1 marst2 marst3 marst4 marst5 marst6 , cluster(bpl);
outreg using "reg_agg_data\M_output\clust_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4 p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu4  marst1 marst2 marst3 marst4 marst5 marst6 , cluster(bpl);
outreg using "reg_agg_data\M_output\clust_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5 p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu5  marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl);
outreg using "reg_agg_data\M_output\clust_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;

log close;


/*********difference out the average ************/

#delimit;
clear;
use M_agg_data00.dta;
merge pwmetro bpl using M_agg_data90.dta;
keep if _merge==3;
drop _merge;

generate 	occpop1				=	(	occpop1_00	+	occpop1_90	)	/2		;
generate 	occpop2				=	(	occpop2_00	+	occpop2_90	)	/2		;
generate 	occpop3				=	(	occpop3_00	+	occpop3_90	)	/2		;
generate 	occpop4				=	(	occpop4_00	+	occpop4_90	)	/2		;
generate 	occpop5				=	(	occpop5_00	+	occpop5_90	)	/2		;
generate 	cntry_met				=	(	cntry_met_00	+	cntry_met_90	)	/2		;
generate 	p_occ_old_country1				=	(	p_occ_old_country1_00	+	p_occ_old_country1_90	)	/2		;
generate 	p_occ_old_country2				=	(	p_occ_old_country2_00	+	p_occ_old_country2_90	)	/2		;
generate 	p_occ_old_country3				=	(	p_occ_old_country3_00	+	p_occ_old_country3_90	)	/2		;
generate 	p_occ_old_country4				=	(	p_occ_old_country4_00	+	p_occ_old_country4_90	)	/2		;
generate 	p_occ_old_country5				=	(	p_occ_old_country5_00	+	p_occ_old_country5_90	)	/2		;
generate 	p_native_occ1				=	(	p_native_occ1_00	+	p_native_occ1_90	)	/2		;
generate 	p_native_occ2				=	(	p_native_occ2_00	+	p_native_occ2_90	)	/2		;
generate 	p_native_occ3				=	(	p_native_occ3_00	+	p_native_occ3_90	)	/2		;
generate 	p_native_occ4				=	(	p_native_occ4_00	+	p_native_occ4_90	)	/2		;
generate 	p_native_occ5				=	(	p_native_occ5_00	+	p_native_occ5_90	)	/2		;
generate 	p_occ_met1				=	(	p_occ_met1_00	+	p_occ_met1_90	)	/2		;
generate 	p_occ_met2				=	(	p_occ_met2_00	+	p_occ_met2_90	)	/2		;
generate 	p_occ_met3				=	(	p_occ_met3_00	+	p_occ_met3_90	)	/2		;
generate 	p_occ_met4				=	(	p_occ_met4_00	+	p_occ_met4_90	)	/2		;
generate 	p_occ_met5				=	(	p_occ_met5_00	+	p_occ_met5_90	)	/2		;
generate 	age				=	(	age_00	+	age_90	)	/2		;
generate 	sex				=	(	sex_00	+	sex_90	)	/2		;
generate 	english				=	(	english_00	+	english_90	)	/2		;
generate 	age2				=	(	age2_00	+	age2_90	)	/2		;
generate 	mean_occ_edu1				=	(	mean_occ_edu1_00	+	mean_occ_edu1_90	)	/2		;
generate 	mean_occ_edu2				=	(	mean_occ_edu2_00	+	mean_occ_edu2_90	)	/2		;
generate 	mean_occ_edu3				=	(	mean_occ_edu3_00	+	mean_occ_edu3_90	)	/2		;
generate 	mean_occ_edu4				=	(	mean_occ_edu4_00	+	mean_occ_edu4_90	)	/2		;
generate 	mean_occ_edu5				=	(	mean_occ_edu5_00	+	mean_occ_edu5_90	)	/2		;
generate 	edu1				=	(	edu1_00	+	edu1_90	)	/2		;
generate 	edu2				=	(	edu2_00	+	edu2_90	)	/2		;
generate 	edu3				=	(	edu3_00	+	edu3_90	)	/2		;
generate 	edu4				=	(	edu4_00	+	edu4_90	)	/2		;
generate 	edu5				=	(	edu5_00	+	edu5_90	)	/2		;
generate 	edu6				=	(	edu6_00	+	edu6_90	)	/2		;
generate 	marst1				=	(	marst1_00	+	marst1_90	)	/2		;
generate 	marst2				=	(	marst2_00	+	marst2_90	)	/2		;
generate 	marst3				=	(	marst3_00	+	marst3_90	)	/2		;
generate 	marst4				=	(	marst4_00	+	marst4_90	)	/2		;
generate 	marst5				=	(	marst5_00	+	marst5_90	)	/2		;
generate 	marst6				=	(	marst6_00	+	marst6_90	)	/2		;

replace	occpop1_00	 = 	occpop1_00	-	occpop1	;
replace	occpop2_00	 = 	occpop2_00	-	occpop2	;
replace	occpop3_00	 = 	occpop3_00	-	occpop3	;
replace	occpop4_00	 = 	occpop4_00	-	occpop4	;
replace	occpop5_00	 = 	occpop5_00	-	occpop5	;
replace	cntry_met_00	 = 	cntry_met_00	-	cntry_met	;
replace	p_occ_old_country1_00	 = 	p_occ_old_country1_00	-	p_occ_old_country1	;
replace	p_occ_old_country2_00	 = 	p_occ_old_country2_00	-	p_occ_old_country2	;
replace	p_occ_old_country3_00	 = 	p_occ_old_country3_00	-	p_occ_old_country3	;
replace	p_occ_old_country4_00	 = 	p_occ_old_country4_00	-	p_occ_old_country4	;
replace	p_occ_old_country5_00	 = 	p_occ_old_country5_00	-	p_occ_old_country5	;
replace	p_native_occ1_00	 = 	p_native_occ1_00	-	p_native_occ1	;
replace	p_native_occ2_00	 = 	p_native_occ2_00	-	p_native_occ2	;
replace	p_native_occ3_00	 = 	p_native_occ3_00	-	p_native_occ3	;
replace	p_native_occ4_00	 = 	p_native_occ4_00	-	p_native_occ4	;
replace	p_native_occ5_00	 = 	p_native_occ5_00	-	p_native_occ5	;
replace	p_occ_met1_00	 = 	p_occ_met1_00	-	p_occ_met1	;
replace	p_occ_met2_00	 = 	p_occ_met2_00	-	p_occ_met2	;
replace	p_occ_met3_00	 = 	p_occ_met3_00	-	p_occ_met3	;
replace	p_occ_met4_00	 = 	p_occ_met4_00	-	p_occ_met4	;
replace	p_occ_met5_00	 = 	p_occ_met5_00	-	p_occ_met5	;
replace	age_00	 = 	age_00	-	age	;
replace	sex_00	 = 	sex_00	-	sex	;
replace	english_00	 = 	english_00	-	english	;
replace	age2_00	 = 	age2_00	-	age2	;
replace	mean_occ_edu1_00	 = 	mean_occ_edu1_00	-	mean_occ_edu1	;
replace	mean_occ_edu2_00	 = 	mean_occ_edu2_00	-	mean_occ_edu2	;
replace	mean_occ_edu3_00	 = 	mean_occ_edu3_00	-	mean_occ_edu3	;
replace	mean_occ_edu4_00	 = 	mean_occ_edu4_00	-	mean_occ_edu4	;
replace	mean_occ_edu5_00	 = 	mean_occ_edu5_00	-	mean_occ_edu5	;
replace	edu1_00	 = 	edu1_00	-	edu1	;
replace	edu2_00	 = 	edu2_00	-	edu2	;
replace	edu3_00	 = 	edu3_00	-	edu3	;
replace	edu4_00	 = 	edu4_00	-	edu4	;
replace	edu5_00	 = 	edu5_00	-	edu5	;
replace	edu6_00	 = 	edu6_00	-	edu6	;
replace	marst1_00	 = 	marst1_00	-	marst1	;
replace	marst2_00	 = 	marst2_00	-	marst2	;
replace	marst3_00	 = 	marst3_00	-	marst3	;
replace	marst4_00	 = 	marst4_00	-	marst4	;
replace	marst5_00	 = 	marst5_00	-	marst5	;
replace	marst6_00	 = 	marst6_00	-	marst6	;

replace	occpop1_90	 = 	occpop1_90	-	occpop1	;
replace	occpop2_90	 = 	occpop2_90	-	occpop2	;
replace	occpop3_90	 = 	occpop3_90	-	occpop3	;
replace	occpop4_90	 = 	occpop4_90	-	occpop4	;
replace	occpop5_90	 = 	occpop5_90	-	occpop5	;
replace	cntry_met_90	 = 	cntry_met_90	-	cntry_met	;
replace	p_occ_old_country1_90	 = 	p_occ_old_country1_90	-	p_occ_old_country1	;
replace	p_occ_old_country2_90	 = 	p_occ_old_country2_90	-	p_occ_old_country2	;
replace	p_occ_old_country3_90	 = 	p_occ_old_country3_90	-	p_occ_old_country3	;
replace	p_occ_old_country4_90	 = 	p_occ_old_country4_90	-	p_occ_old_country4	;
replace	p_occ_old_country5_90	 = 	p_occ_old_country5_90	-	p_occ_old_country5	;
replace	p_native_occ1_90	 = 	p_native_occ1_90	-	p_native_occ1	;
replace	p_native_occ2_90	 = 	p_native_occ2_90	-	p_native_occ2	;
replace	p_native_occ3_90	 = 	p_native_occ3_90	-	p_native_occ3	;
replace	p_native_occ4_90	 = 	p_native_occ4_90	-	p_native_occ4	;
replace	p_native_occ5_90	 = 	p_native_occ5_90	-	p_native_occ5	;
replace	p_occ_met1_90	 = 	p_occ_met1_90	-	p_occ_met1	;
replace	p_occ_met2_90	 = 	p_occ_met2_90	-	p_occ_met2	;
replace	p_occ_met3_90	 = 	p_occ_met3_90	-	p_occ_met3	;
replace	p_occ_met4_90	 = 	p_occ_met4_90	-	p_occ_met4	;
replace	p_occ_met5_90	 = 	p_occ_met5_90	-	p_occ_met5	;
replace	age_90	 = 	age_90	-	age	;
replace	sex_90	 = 	sex_90	-	sex	;
replace	english_90	 = 	english_90	-	english	;
replace	age2_90	 = 	age2_90	-	age2	;
replace	mean_occ_edu1_90	 = 	mean_occ_edu1_90	-	mean_occ_edu1	;
replace	mean_occ_edu2_90	 = 	mean_occ_edu2_90	-	mean_occ_edu2	;
replace	mean_occ_edu3_90	 = 	mean_occ_edu3_90	-	mean_occ_edu3	;
replace	mean_occ_edu4_90	 = 	mean_occ_edu4_90	-	mean_occ_edu4	;
replace	mean_occ_edu5_90	 = 	mean_occ_edu5_90	-	mean_occ_edu5	;
replace	edu1_90	 = 	edu1_90	-	edu1	;
replace	edu2_90	 = 	edu2_90	-	edu2	;
replace	edu3_90	 = 	edu3_90	-	edu3	;
replace	edu4_90	 = 	edu4_90	-	edu4	;
replace	edu5_90	 = 	edu5_90	-	edu5	;
replace	edu6_90	 = 	edu6_90	-	edu6	;
replace	marst1_90	 = 	marst1_90	-	marst1	;
replace	marst2_90	 = 	marst2_90	-	marst2	;
replace	marst3_90	 = 	marst3_90	-	marst3	;
replace	marst4_90	 = 	marst4_90	-	marst4	;
replace	marst5_90	 = 	marst5_90	-	marst5	;
replace	marst6_90	 = 	marst6_90	-	marst6	;

drop occpop1
occpop2
occpop3
occpop4
occpop5
cntry_met
p_occ_old_country1
p_occ_old_country2
p_occ_old_country3
p_occ_old_country4
p_occ_old_country5
p_native_occ1
p_native_occ2
p_native_occ3
p_native_occ4
p_native_occ5
p_occ_met1
p_occ_met2
p_occ_met3
p_occ_met4
p_occ_met5
age
sex
english
age2
mean_occ_edu1
mean_occ_edu2
mean_occ_edu3
mean_occ_edu4
mean_occ_edu5
edu1
edu2
edu3
edu4
edu5
edu6
marst1
marst2
marst3
marst4
marst5
marst6;
rename	pop_00		pop_2000	;
rename	occpop1_00		occpop1_2000	;
rename	occpop2_00		occpop2_2000	;
rename	occpop3_00		occpop3_2000	;
rename	occpop4_00		occpop4_2000	;
rename	occpop5_00		occpop5_2000	;
rename cntry_met_00 cntry_met_2000;
rename	p_occ_old_country1_00		p_occ_old_country1_2000	;
rename	p_occ_old_country2_00		p_occ_old_country2_2000	;
rename	p_occ_old_country3_00		p_occ_old_country3_2000	;
rename	p_occ_old_country4_00		p_occ_old_country4_2000	;
rename	p_occ_old_country5_00		p_occ_old_country5_2000	;
rename	p_native_occ1_00		p_native_occ1_2000	;
rename	p_native_occ2_00		p_native_occ2_2000	;
rename	p_native_occ3_00		p_native_occ3_2000	;
rename	p_native_occ4_00		p_native_occ4_2000	;
rename	p_native_occ5_00		p_native_occ5_2000	;
rename	p_occ_met1_00		p_occ_met1_2000	;
rename	p_occ_met2_00		p_occ_met2_2000	;
rename	p_occ_met3_00		p_occ_met3_2000	;
rename	p_occ_met4_00		p_occ_met4_2000	;
rename	p_occ_met5_00		p_occ_met5_2000	;
rename	age_00		age_2000	;
rename	sex_00		sex_2000	;
rename	english_00		english_2000	;
rename	age2_00		age2_2000	;
rename	mean_occ_edu1_00		mean_occ_edu1_2000	;
rename	mean_occ_edu2_00		mean_occ_edu2_2000	;
rename	mean_occ_edu3_00		mean_occ_edu3_2000	;
rename	mean_occ_edu4_00		mean_occ_edu4_2000	;
rename	mean_occ_edu5_00		mean_occ_edu5_2000	;
rename	edu1_00		edu1_2000	;
rename	edu2_00		edu2_2000	;
rename	edu3_00		edu3_2000	;
rename	edu4_00		edu4_2000	;
rename	edu5_00		edu5_2000	;
rename	edu6_00		edu6_2000	;
rename	marst1_00		marst1_2000	;
rename	marst2_00		marst2_2000	;
rename	marst3_00		marst3_2000	;
rename	marst4_00		marst4_2000	;
rename	marst5_00		marst5_2000	;
rename	marst6_00		marst6_2000	;
rename	pop_90		pop_1990	;
rename	occpop1_90		occpop1_1990	;
rename	occpop2_90		occpop2_1990	;
rename	occpop3_90		occpop3_1990	;
rename	occpop4_90		occpop4_1990	;
rename	occpop5_90		occpop5_1990	;
rename	cntry_met_90		cntry_met_1990	;
rename	p_occ_old_country1_90		p_occ_old_country1_1990	;
rename	p_occ_old_country2_90		p_occ_old_country2_1990	;
rename	p_occ_old_country3_90		p_occ_old_country3_1990	;
rename	p_occ_old_country4_90		p_occ_old_country4_1990	;
rename	p_occ_old_country5_90		p_occ_old_country5_1990	;
rename	p_native_occ1_90		p_native_occ1_1990	;
rename	p_native_occ2_90		p_native_occ2_1990	;
rename	p_native_occ3_90		p_native_occ3_1990	;
rename	p_native_occ4_90		p_native_occ4_1990	;
rename	p_native_occ5_90		p_native_occ5_1990	;
rename	p_occ_met1_90		p_occ_met1_1990	;
rename	p_occ_met2_90		p_occ_met2_1990	;
rename	p_occ_met3_90		p_occ_met3_1990	;
rename	p_occ_met4_90		p_occ_met4_1990	;
rename	p_occ_met5_90		p_occ_met5_1990	;
rename	age_90		age_1990	;
rename	sex_90		sex_1990	;
rename	english_90		english_1990	;
rename	age2_90		age2_1990	;
rename	mean_occ_edu1_90		mean_occ_edu1_1990	;
rename	mean_occ_edu2_90		mean_occ_edu2_1990	;
rename	mean_occ_edu3_90		mean_occ_edu3_1990	;
rename	mean_occ_edu4_90		mean_occ_edu4_1990	;
rename	mean_occ_edu5_90		mean_occ_edu5_1990	;
rename	edu1_90		edu1_1990	;
rename	edu2_90		edu2_1990	;
rename	edu3_90		edu3_1990	;
rename	edu4_90		edu4_1990	;
rename	edu5_90		edu5_1990	;
rename	edu6_90		edu6_1990	;
rename	marst1_90		marst1_1990	;
rename	marst2_90		marst2_1990	;
rename	marst3_90		marst3_1990	;
rename	marst4_90		marst4_1990	;
rename	marst5_90		marst5_1990	;
rename	marst6_90		marst6_1990	;

generate id=_n;

reshape long pop_ occpop1_ occpop2_ occpop3_ occpop4_ occpop5_ cntry_met_ p_occ_old_country1_ p_occ_old_country2_ p_occ_old_country3_ p_occ_old_country4_ p_occ_old_country5_ p_native_occ1_ p_native_occ2_ p_native_occ3_ p_native_occ4_ p_native_occ5_ p_occ_met1_ p_occ_met2_ p_occ_met3_ p_occ_met4_ p_occ_met5_ age_ sex_ english_ age2_ mean_occ_edu1_ mean_occ_edu2_ mean_occ_edu3_ mean_occ_edu4_ mean_occ_edu5_ edu1_ edu2_ edu3_ edu4_ edu5_ edu6_ marst1_ marst2_ marst3_ marst4_ marst5_ marst6_, i(id) j(year);
rename	pop_		pop	;
rename	occpop1_		occpop1	;
rename	occpop2_		occpop2	;
rename	occpop3_		occpop3	;
rename	occpop4_		occpop4	;
rename	occpop5_		occpop5	;
rename cntry_met_ cntry_met;
rename	p_occ_old_country1_		p_occ_old_country1	;
rename	p_occ_old_country2_		p_occ_old_country2	;
rename	p_occ_old_country3_		p_occ_old_country3	;
rename	p_occ_old_country4_		p_occ_old_country4	;
rename	p_occ_old_country5_		p_occ_old_country5	;
rename	p_native_occ1_		p_native_occ1	;
rename	p_native_occ2_		p_native_occ2	;
rename	p_native_occ3_		p_native_occ3	;
rename	p_native_occ4_		p_native_occ4	;
rename	p_native_occ5_		p_native_occ5	;
rename	p_occ_met1_		p_occ_met1	;
rename	p_occ_met2_		p_occ_met2	;
rename	p_occ_met3_		p_occ_met3	;
rename	p_occ_met4_		p_occ_met4	;
rename	p_occ_met5_		p_occ_met5	;
rename	age_		age	;
rename	sex_		sex	;
rename	english_		english	;
rename	age2_		age2	;
rename	mean_occ_edu1_		mean_occ_edu1	;
rename	mean_occ_edu2_		mean_occ_edu2	;
rename	mean_occ_edu3_		mean_occ_edu3	;
rename	mean_occ_edu4_		mean_occ_edu4	;
rename	mean_occ_edu5_		mean_occ_edu5	;
rename	edu1_		edu1	;
rename	edu2_		edu2	;
rename	edu3_		edu3	;
rename	edu4_		edu4	;
rename	edu5_		edu5	;
rename	edu6_		edu6	;
rename	marst1_		marst1	;
rename	marst2_		marst2	;
rename	marst3_		marst3	;
rename	marst4_		marst4	;
rename	marst5_		marst5	;
rename	marst6_		marst6	;


log using "reg_agg_data\M_output\M_regression_avg.log", replace;
/***OLS***/
xi:  regress occpop1 p_occ_old_country1 p_native_occ1 p_occ_met1 cntry_met  age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu1 marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl) noconstant;
outreg using "reg_agg_data\M_output\avg_clust.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2 p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu2  marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl) noconstant;
outreg using "reg_agg_data\M_output\avg_clust.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3 p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met  age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu3  marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl) noconstant;
outreg using "reg_agg_data\M_output\avg_clust.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4 p_occ_old_country4 p_native_occ4 p_occ_met4 cntry_met  age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu4  marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl) noconstant;
outreg using "reg_agg_data\M_output\avg_clust.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5 p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu5  marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl) noconstant;
outreg using "reg_agg_data\M_output\avg_clust.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;
/**********no mexicans**************/
drop if bpl==200;
xi:  regress occpop1 p_occ_old_country1 p_native_occ1 p_occ_met1  cntry_met age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu1  marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl) noconstant;
outreg using "reg_agg_data\M_output\avg_clust_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
xi:  regress occpop2 p_occ_old_country2 p_native_occ2 p_occ_met2 cntry_met  age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu2  marst1 marst2 marst3 marst4 marst5 marst6 , cluster(bpl) noconstant;
outreg using "reg_agg_data\M_output\avg_clust_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket append;
xi:  regress occpop3 p_occ_old_country3 p_native_occ3 p_occ_met3 cntry_met age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu3  marst1 marst2 marst3 marst4 marst5 marst6 , cluster(bpl) noconstant;
outreg using "reg_agg_data\M_output\avg_clust_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket append;
xi:  regress occpop4 p_occ_old_country4 p_native_occ4 p_occ_met4  cntry_met age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu4  marst1 marst2 marst3 marst4 marst5 marst6 , cluster(bpl) noconstant;
outreg using "reg_agg_data\M_output\avg_clust_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket append;
xi:  regress occpop5 p_occ_old_country5 p_native_occ5 p_occ_met5  cntry_met age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6 mean_occ_edu5  marst1 marst2 marst3 marst4 marst5 marst6  , cluster(bpl) noconstant;
outreg using "reg_agg_data\M_output\avg_clust_nomex.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket append;

log close;


/******weighted regression******/
/*********difference out the average ************/

#delimit;
clear;
use M_agg_data00.dta;
merge pwmetro bpl using M_agg_data90.dta;
keep if _merge==3;
drop _merge;

generate 	occpop1				=	(	occpop1_00	+	occpop1_90	)	/2		;
generate 	occpop2				=	(	occpop2_00	+	occpop2_90	)	/2		;
generate 	occpop3				=	(	occpop3_00	+	occpop3_90	)	/2		;
generate 	occpop4				=	(	occpop4_00	+	occpop4_90	)	/2		;
generate 	occpop5				=	(	occpop5_00	+	occpop5_90	)	/2		;
generate 	cntry_met				=	(	cntry_met_00	+	cntry_met_90	)	/2		;
generate 	p_occ_old_country1				=	(	p_occ_old_country1_00	+	p_occ_old_country1_90	)	/2		;
generate 	p_occ_old_country2				=	(	p_occ_old_country2_00	+	p_occ_old_country2_90	)	/2		;
generate 	p_occ_old_country3				=	(	p_occ_old_country3_00	+	p_occ_old_country3_90	)	/2		;
generate 	p_occ_old_country4				=	(	p_occ_old_country4_00	+	p_occ_old_country4_90	)	/2		;
generate 	p_occ_old_country5				=	(	p_occ_old_country5_00	+	p_occ_old_country5_90	)	/2		;
generate 	p_native_occ1				=	(	p_native_occ1_00	+	p_native_occ1_90	)	/2		;
generate 	p_native_occ2				=	(	p_native_occ2_00	+	p_native_occ2_90	)	/2		;
generate 	p_native_occ3				=	(	p_native_occ3_00	+	p_native_occ3_90	)	/2		;
generate 	p_native_occ4				=	(	p_native_occ4_00	+	p_native_occ4_90	)	/2		;
generate 	p_native_occ5				=	(	p_native_occ5_00	+	p_native_occ5_90	)	/2		;
generate 	p_occ_met1				=	(	p_occ_met1_00	+	p_occ_met1_90	)	/2		;
generate 	p_occ_met2				=	(	p_occ_met2_00	+	p_occ_met2_90	)	/2		;
generate 	p_occ_met3				=	(	p_occ_met3_00	+	p_occ_met3_90	)	/2		;
generate 	p_occ_met4				=	(	p_occ_met4_00	+	p_occ_met4_90	)	/2		;
generate 	p_occ_met5				=	(	p_occ_met5_00	+	p_occ_met5_90	)	/2		;
generate 	age				=	(	age_00	+	age_90	)	/2		;
generate 	sex				=	(	sex_00	+	sex_90	)	/2		;
generate 	english				=	(	english_00	+	english_90	)	/2		;
generate 	age2				=	(	age2_00	+	age2_90	)	/2		;
generate 	mean_occ_edu1				=	(	mean_occ_edu1_00	+	mean_occ_edu1_90	)	/2		;
generate 	mean_occ_edu2				=	(	mean_occ_edu2_00	+	mean_occ_edu2_90	)	/2		;
generate 	mean_occ_edu3				=	(	mean_occ_edu3_00	+	mean_occ_edu3_90	)	/2		;
generate 	mean_occ_edu4				=	(	mean_occ_edu4_00	+	mean_occ_edu4_90	)	/2		;
generate 	mean_occ_edu5				=	(	mean_occ_edu5_00	+	mean_occ_edu5_90	)	/2		;
generate 	edu1				=	(	edu1_00	+	edu1_90	)	/2		;
generate 	edu2				=	(	edu2_00	+	edu2_90	)	/2		;
generate 	edu3				=	(	edu3_00	+	edu3_90	)	/2		;
generate 	edu4				=	(	edu4_00	+	edu4_90	)	/2		;
generate 	edu5				=	(	edu5_00	+	edu5_90	)	/2		;
generate 	edu6				=	(	edu6_00	+	edu6_90	)	/2		;
generate 	marst1				=	(	marst1_00	+	marst1_90	)	/2		;
generate 	marst2				=	(	marst2_00	+	marst2_90	)	/2		;
generate 	marst3				=	(	marst3_00	+	marst3_90	)	/2		;
generate 	marst4				=	(	marst4_00	+	marst4_90	)	/2		;
generate 	marst5				=	(	marst5_00	+	marst5_90	)	/2		;
generate 	marst6				=	(	marst6_00	+	marst6_90	)	/2		;

replace	occpop1_00	 = 	occpop1_00	-	occpop1	;
replace	occpop2_00	 = 	occpop2_00	-	occpop2	;
replace	occpop3_00	 = 	occpop3_00	-	occpop3	;
replace	occpop4_00	 = 	occpop4_00	-	occpop4	;
replace	occpop5_00	 = 	occpop5_00	-	occpop5	;
replace	cntry_met_00	 = 	cntry_met_00	-	cntry_met	;
replace	p_occ_old_country1_00	 = 	p_occ_old_country1_00	-	p_occ_old_country1	;
replace	p_occ_old_country2_00	 = 	p_occ_old_country2_00	-	p_occ_old_country2	;
replace	p_occ_old_country3_00	 = 	p_occ_old_country3_00	-	p_occ_old_country3	;
replace	p_occ_old_country4_00	 = 	p_occ_old_country4_00	-	p_occ_old_country4	;
replace	p_occ_old_country5_00	 = 	p_occ_old_country5_00	-	p_occ_old_country5	;
replace	p_native_occ1_00	 = 	p_native_occ1_00	-	p_native_occ1	;
replace	p_native_occ2_00	 = 	p_native_occ2_00	-	p_native_occ2	;
replace	p_native_occ3_00	 = 	p_native_occ3_00	-	p_native_occ3	;
replace	p_native_occ4_00	 = 	p_native_occ4_00	-	p_native_occ4	;
replace	p_native_occ5_00	 = 	p_native_occ5_00	-	p_native_occ5	;
replace	p_occ_met1_00	 = 	p_occ_met1_00	-	p_occ_met1	;
replace	p_occ_met2_00	 = 	p_occ_met2_00	-	p_occ_met2	;
replace	p_occ_met3_00	 = 	p_occ_met3_00	-	p_occ_met3	;
replace	p_occ_met4_00	 = 	p_occ_met4_00	-	p_occ_met4	;
replace	p_occ_met5_00	 = 	p_occ_met5_00	-	p_occ_met5	;
replace	age_00	 = 	age_00	-	age	;
replace	sex_00	 = 	sex_00	-	sex	;
replace	english_00	 = 	english_00	-	english	;
replace	age2_00	 = 	age2_00	-	age2	;
replace	mean_occ_edu1_00	 = 	mean_occ_edu1_00	-	mean_occ_edu1	;
replace	mean_occ_edu2_00	 = 	mean_occ_edu2_00	-	mean_occ_edu2	;
replace	mean_occ_edu3_00	 = 	mean_occ_edu3_00	-	mean_occ_edu3	;
replace	mean_occ_edu4_00	 = 	mean_occ_edu4_00	-	mean_occ_edu4	;
replace	mean_occ_edu5_00	 = 	mean_occ_edu5_00	-	mean_occ_edu5	;
replace	edu1_00	 = 	edu1_00	-	edu1	;
replace	edu2_00	 = 	edu2_00	-	edu2	;
replace	edu3_00	 = 	edu3_00	-	edu3	;
replace	edu4_00	 = 	edu4_00	-	edu4	;
replace	edu5_00	 = 	edu5_00	-	edu5	;
replace	edu6_00	 = 	edu6_00	-	edu6	;
replace	marst1_00	 = 	marst1_00	-	marst1	;
replace	marst2_00	 = 	marst2_00	-	marst2	;
replace	marst3_00	 = 	marst3_00	-	marst3	;
replace	marst4_00	 = 	marst4_00	-	marst4	;
replace	marst5_00	 = 	marst5_00	-	marst5	;
replace	marst6_00	 = 	marst6_00	-	marst6	;

replace	occpop1_90	 = 	occpop1_90	-	occpop1	;
replace	occpop2_90	 = 	occpop2_90	-	occpop2	;
replace	occpop3_90	 = 	occpop3_90	-	occpop3	;
replace	occpop4_90	 = 	occpop4_90	-	occpop4	;
replace	occpop5_90	 = 	occpop5_90	-	occpop5	;
replace	cntry_met_90	 = 	cntry_met_90	-	cntry_met	;
replace	p_occ_old_country1_90	 = 	p_occ_old_country1_90	-	p_occ_old_country1	;
replace	p_occ_old_country2_90	 = 	p_occ_old_country2_90	-	p_occ_old_country2	;
replace	p_occ_old_country3_90	 = 	p_occ_old_country3_90	-	p_occ_old_country3	;
replace	p_occ_old_country4_90	 = 	p_occ_old_country4_90	-	p_occ_old_country4	;
replace	p_occ_old_country5_90	 = 	p_occ_old_country5_90	-	p_occ_old_country5	;
replace	p_native_occ1_90	 = 	p_native_occ1_90	-	p_native_occ1	;
replace	p_native_occ2_90	 = 	p_native_occ2_90	-	p_native_occ2	;
replace	p_native_occ3_90	 = 	p_native_occ3_90	-	p_native_occ3	;
replace	p_native_occ4_90	 = 	p_native_occ4_90	-	p_native_occ4	;
replace	p_native_occ5_90	 = 	p_native_occ5_90	-	p_native_occ5	;
replace	p_occ_met1_90	 = 	p_occ_met1_90	-	p_occ_met1	;
replace	p_occ_met2_90	 = 	p_occ_met2_90	-	p_occ_met2	;
replace	p_occ_met3_90	 = 	p_occ_met3_90	-	p_occ_met3	;
replace	p_occ_met4_90	 = 	p_occ_met4_90	-	p_occ_met4	;
replace	p_occ_met5_90	 = 	p_occ_met5_90	-	p_occ_met5	;
replace	age_90	 = 	age_90	-	age	;
replace	sex_90	 = 	sex_90	-	sex	;
replace	english_90	 = 	english_90	-	english	;
replace	age2_90	 = 	age2_90	-	age2	;
replace	mean_occ_edu1_90	 = 	mean_occ_edu1_90	-	mean_occ_edu1	;
replace	mean_occ_edu2_90	 = 	mean_occ_edu2_90	-	mean_occ_edu2	;
replace	mean_occ_edu3_90	 = 	mean_occ_edu3_90	-	mean_occ_edu3	;
replace	mean_occ_edu4_90	 = 	mean_occ_edu4_90	-	mean_occ_edu4	;
replace	mean_occ_edu5_90	 = 	mean_occ_edu5_90	-	mean_occ_edu5	;
replace	edu1_90	 = 	edu1_90	-	edu1	;
replace	edu2_90	 = 	edu2_90	-	edu2	;
replace	edu3_90	 = 	edu3_90	-	edu3	;
replace	edu4_90	 = 	edu4_90	-	edu4	;
replace	edu5_90	 = 	edu5_90	-	edu5	;
replace	edu6_90	 = 	edu6_90	-	edu6	;
replace	marst1_90	 = 	marst1_90	-	marst1	;
replace	marst2_90	 = 	marst2_90	-	marst2	;
replace	marst3_90	 = 	marst3_90	-	marst3	;
replace	marst4_90	 = 	marst4_90	-	marst4	;
replace	marst5_90	 = 	marst5_90	-	marst5	;
replace	marst6_90	 = 	marst6_90	-	marst6	;

drop occpop1
occpop2
occpop3
occpop4
occpop5
cntry_met
p_occ_old_country1
p_occ_old_country2
p_occ_old_country3
p_occ_old_country4
p_occ_old_country5
p_native_occ1
p_native_occ2
p_native_occ3
p_native_occ4
p_native_occ5
p_occ_met1
p_occ_met2
p_occ_met3
p_occ_met4
p_occ_met5
age
sex
english
age2
mean_occ_edu1
mean_occ_edu2
mean_occ_edu3
mean_occ_edu4
mean_occ_edu5
edu1
edu2
edu3
edu4
edu5
edu6
marst1
marst2
marst3
marst4
marst5
marst6;
rename	pop_00		pop_2000	;
rename	occpop1_00		occpop1_2000	;
rename	occpop2_00		occpop2_2000	;
rename	occpop3_00		occpop3_2000	;
rename	occpop4_00		occpop4_2000	;
rename	occpop5_00		occpop5_2000	;
rename cntry_met_00 cntry_met_2000;
rename	p_occ_old_country1_00		p_occ_old_country1_2000	;
rename	p_occ_old_country2_00		p_occ_old_country2_2000	;
rename	p_occ_old_country3_00		p_occ_old_country3_2000	;
rename	p_occ_old_country4_00		p_occ_old_country4_2000	;
rename	p_occ_old_country5_00		p_occ_old_country5_2000	;
rename	p_native_occ1_00		p_native_occ1_2000	;
rename	p_native_occ2_00		p_native_occ2_2000	;
rename	p_native_occ3_00		p_native_occ3_2000	;
rename	p_native_occ4_00		p_native_occ4_2000	;
rename	p_native_occ5_00		p_native_occ5_2000	;
rename	p_occ_met1_00		p_occ_met1_2000	;
rename	p_occ_met2_00		p_occ_met2_2000	;
rename	p_occ_met3_00		p_occ_met3_2000	;
rename	p_occ_met4_00		p_occ_met4_2000	;
rename	p_occ_met5_00		p_occ_met5_2000	;
rename	age_00		age_2000	;
rename	sex_00		sex_2000	;
rename	english_00		english_2000	;
rename	age2_00		age2_2000	;
rename	mean_occ_edu1_00		mean_occ_edu1_2000	;
rename	mean_occ_edu2_00		mean_occ_edu2_2000	;
rename	mean_occ_edu3_00		mean_occ_edu3_2000	;
rename	mean_occ_edu4_00		mean_occ_edu4_2000	;
rename	mean_occ_edu5_00		mean_occ_edu5_2000	;
rename	edu1_00		edu1_2000	;
rename	edu2_00		edu2_2000	;
rename	edu3_00		edu3_2000	;
rename	edu4_00		edu4_2000	;
rename	edu5_00		edu5_2000	;
rename	edu6_00		edu6_2000	;
rename	marst1_00		marst1_2000	;
rename	marst2_00		marst2_2000	;
rename	marst3_00		marst3_2000	;
rename	marst4_00		marst4_2000	;
rename	marst5_00		marst5_2000	;
rename	marst6_00		marst6_2000	;
rename	pop_90		pop_1990	;
rename	occpop1_90		occpop1_1990	;
rename	occpop2_90		occpop2_1990	;
rename	occpop3_90		occpop3_1990	;
rename	occpop4_90		occpop4_1990	;
rename	occpop5_90		occpop5_1990	;
rename	cntry_met_90		cntry_met_1990	;
rename	p_occ_old_country1_90		p_occ_old_country1_1990	;
rename	p_occ_old_country2_90		p_occ_old_country2_1990	;
rename	p_occ_old_country3_90		p_occ_old_country3_1990	;
rename	p_occ_old_country4_90		p_occ_old_country4_1990	;
rename	p_occ_old_country5_90		p_occ_old_country5_1990	;
rename	p_native_occ1_90		p_native_occ1_1990	;
rename	p_native_occ2_90		p_native_occ2_1990	;
rename	p_native_occ3_90		p_native_occ3_1990	;
rename	p_native_occ4_90		p_native_occ4_1990	;
rename	p_native_occ5_90		p_native_occ5_1990	;
rename	p_occ_met1_90		p_occ_met1_1990	;
rename	p_occ_met2_90		p_occ_met2_1990	;
rename	p_occ_met3_90		p_occ_met3_1990	;
rename	p_occ_met4_90		p_occ_met4_1990	;
rename	p_occ_met5_90		p_occ_met5_1990	;
rename	age_90		age_1990	;
rename	sex_90		sex_1990	;
rename	english_90		english_1990	;
rename	age2_90		age2_1990	;
rename	mean_occ_edu1_90		mean_occ_edu1_1990	;
rename	mean_occ_edu2_90		mean_occ_edu2_1990	;
rename	mean_occ_edu3_90		mean_occ_edu3_1990	;
rename	mean_occ_edu4_90		mean_occ_edu4_1990	;
rename	mean_occ_edu5_90		mean_occ_edu5_1990	;
rename	edu1_90		edu1_1990	;
rename	edu2_90		edu2_1990	;
rename	edu3_90		edu3_1990	;
rename	edu4_90		edu4_1990	;
rename	edu5_90		edu5_1990	;
rename	edu6_90		edu6_1990	;
rename	marst1_90		marst1_1990	;
rename	marst2_90		marst2_1990	;
rename	marst3_90		marst3_1990	;
rename	marst4_90		marst4_1990	;
rename	marst5_90		marst5_1990	;
rename	marst6_90		marst6_1990	;

generate id=_n;

reshape long pop_ occpop1_ occpop2_ occpop3_ occpop4_ occpop5_ cntry_met_ p_occ_old_country1_ p_occ_old_country2_ p_occ_old_country3_ p_occ_old_country4_ p_occ_old_country5_ p_native_occ1_ p_native_occ2_ p_native_occ3_ p_native_occ4_ p_native_occ5_ p_occ_met1_ p_occ_met2_ p_occ_met3_ p_occ_met4_ p_occ_met5_ age_ sex_ english_ age2_ mean_occ_edu1_ mean_occ_edu2_ mean_occ_edu3_ mean_occ_edu4_ mean_occ_edu5_ edu1_ edu2_ edu3_ edu4_ edu5_ edu6_ marst1_ marst2_ marst3_ marst4_ marst5_ marst6_, i(id) j(year);
rename	pop_		pop	;
rename	occpop1_		occpop1	;
rename	occpop2_		occpop2	;
rename	occpop3_		occpop3	;
rename	occpop4_		occpop4	;
rename	occpop5_		occpop5	;
rename cntry_met_ cntry_met;
rename	p_occ_old_country1_		p_occ_old_country1	;
rename	p_occ_old_country2_		p_occ_old_country2	;
rename	p_occ_old_country3_		p_occ_old_country3	;
rename	p_occ_old_country4_		p_occ_old_country4	;
rename	p_occ_old_country5_		p_occ_old_country5	;
rename	p_native_occ1_		p_native_occ1	;
rename	p_native_occ2_		p_native_occ2	;
rename	p_native_occ3_		p_native_occ3	;
rename	p_native_occ4_		p_native_occ4	;
rename	p_native_occ5_		p_native_occ5	;
rename	p_occ_met1_		p_occ_met1	;
rename	p_occ_met2_		p_occ_met2	;
rename	p_occ_met3_		p_occ_met3	;
rename	p_occ_met4_		p_occ_met4	;
rename	p_occ_met5_		p_occ_met5	;
rename	age_		age	;
rename	sex_		sex	;
rename	english_		english	;
rename	age2_		age2	;
rename	mean_occ_edu1_		mean_occ_edu1	;
rename	mean_occ_edu2_		mean_occ_edu2	;
rename	mean_occ_edu3_		mean_occ_edu3	;
rename	mean_occ_edu4_		mean_occ_edu4	;
rename	mean_occ_edu5_		mean_occ_edu5	;
rename	edu1_		edu1	;
rename	edu2_		edu2	;
rename	edu3_		edu3	;
rename	edu4_		edu4	;
rename	edu5_		edu5	;
rename	edu6_		edu6	;
rename	marst1_		marst1	;
rename	marst2_		marst2	;
rename	marst3_		marst3	;
rename	marst4_		marst4	;
rename	marst5_		marst5	;
rename	marst6_		marst6	;


log using "reg_agg_data\M_output\M_regression_avg_wt.log", replace;

generate 	occpop1_wt	=	occpop1	/(pop^.5)	;
generate 	occpop2_wt	=	occpop2	/(pop^.5)	;
generate 	occpop3_wt	=	occpop3	/(pop^.5)	;
generate 	occpop4_wt	=	occpop4	/(pop^.5)	;
generate 	occpop5_wt	=	occpop5	/(pop^.5)	;
generate 	cntry_met_wt	=	cntry_met	/(pop^.5)	;
generate 	p_occ_old_country1_wt	=	p_occ_old_country1	/(pop^.5)	;
generate 	p_occ_old_country2_wt	=	p_occ_old_country2	/(pop^.5)	;
generate 	p_occ_old_country3_wt	=	p_occ_old_country3	/(pop^.5)	;
generate 	p_occ_old_country4_wt	=	p_occ_old_country4	/(pop^.5)	;
generate 	p_occ_old_country5_wt	=	p_occ_old_country5	/(pop^.5)	;
generate 	p_native_occ1_wt	=	p_native_occ1	/(pop^.5)	;
generate 	p_native_occ2_wt	=	p_native_occ2	/(pop^.5)	;
generate 	p_native_occ3_wt	=	p_native_occ3	/(pop^.5)	;
generate 	p_native_occ4_wt	=	p_native_occ4	/(pop^.5)	;
generate 	p_native_occ5_wt	=	p_native_occ5	/(pop^.5)	;
generate 	p_occ_met1_wt	=	p_occ_met1	/(pop^.5)	;
generate 	p_occ_met2_wt	=	p_occ_met2	/(pop^.5)	;
generate 	p_occ_met3_wt	=	p_occ_met3	/(pop^.5)	;
generate 	p_occ_met4_wt	=	p_occ_met4	/(pop^.5)	;
generate 	p_occ_met5_wt	=	p_occ_met5	/(pop^.5)	;
generate 	age_wt	=	age	/(pop^.5)	;
generate 	age2_wt	=	age2	/(pop^.5)	;
generate 	sex_wt	=	sex	/(pop^.5)	;
generate 	english_wt	=	english	/(pop^.5)	;
generate 	edu1_wt	=	edu1	/(pop^.5)	;
generate 	edu2_wt	=	edu2	/(pop^.5)	;
generate 	edu3_wt	=	edu3	/(pop^.5)	;
generate 	edu4_wt	=	edu4	/(pop^.5)	;
generate 	edu5_wt	=	edu5	/(pop^.5)	;
generate 	edu6_wt	=	edu6	/(pop^.5)	;
generate 	mean_occ_edu1_wt	=	mean_occ_edu1	/(pop^.5)	;
generate 	mean_occ_edu2_wt	=	mean_occ_edu2	/(pop^.5)	;
generate 	mean_occ_edu3_wt	=	mean_occ_edu3	/(pop^.5)	;
generate 	mean_occ_edu4_wt	=	mean_occ_edu4	/(pop^.5)	;
generate 	mean_occ_edu5_wt	=	mean_occ_edu5	/(pop^.5)	;
generate 	marst1_wt	=	marst1	/(pop^.5)	;
generate 	marst2_wt	=	marst2	/(pop^.5)	;
generate 	marst3_wt	=	marst3	/(pop^.5)	;
generate 	marst4_wt	=	marst4	/(pop^.5)	;
generate 	marst5_wt	=	marst5	/(pop^.5)	;
generate 	marst6_wt	=	marst6	/(pop^.5)	;

regress occpop1_wt p_occ_old_country1_wt p_native_occ1_wt p_occ_met1_wt cntry_met_wt  age_wt age2_wt sex_wt english_wt edu1_wt edu2_wt edu3_wt edu4_wt edu5_wt edu6_wt mean_occ_edu1_wt marst1_wt marst2_wt marst3_wt marst4_wt marst5_wt marst6_wt, cluster(bpl) noconstant ;
outreg using "reg_agg_data\M_output\avg_clust1_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
regress occpop2_wt p_occ_old_country2_wt p_native_occ2_wt p_occ_met2_wt cntry_met_wt  age_wt age2_wt sex_wt english_wt edu1_wt edu2_wt edu3_wt edu4_wt edu5_wt edu6_wt mean_occ_edu2_wt marst2_wt marst2_wt marst3_wt marst4_wt marst5_wt marst6_wt, cluster(bpl) noconstant ;
outreg using "reg_agg_data\M_output\avg_clust2_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket replace;
regress occpop3_wt p_occ_old_country3_wt p_native_occ3_wt p_occ_met3_wt  cntry_met_wt age_wt age2_wt sex_wt english_wt edu1_wt edu2_wt edu3_wt edu4_wt edu5_wt edu6_wt mean_occ_edu3_wt marst3_wt marst2_wt marst3_wt marst4_wt marst5_wt marst6_wt, cluster(bpl) noconstant ;
outreg using "reg_agg_data\M_output\avg_clust3_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket replace;
regress occpop4_wt p_occ_old_country4_wt p_native_occ4_wt p_occ_met4_wt cntry_met_wt  age_wt age2_wt sex_wt english_wt edu1_wt edu2_wt edu3_wt edu4_wt edu5_wt edu6_wt mean_occ_edu4_wt marst4_wt marst2_wt marst3_wt marst4_wt marst5_wt marst6_wt, cluster(bpl) noconstant ;
outreg using "reg_agg_data\M_output\avg_clust4_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket replace;
regress occpop5_wt p_occ_old_country5_wt p_native_occ5_wt p_occ_met5_wt cntry_met_wt  age_wt age2_wt sex_wt english_wt edu1_wt edu2_wt edu3_wt edu4_wt edu5_wt edu6_wt mean_occ_edu5_wt marst5_wt marst2_wt marst3_wt marst4_wt marst5_wt marst6_wt, cluster(bpl) noconstant ;
outreg using "reg_agg_data\M_output\avg_clust5_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket replace;


/**********no mexicans**************/

drop if bpl==200;

regress occpop1_wt p_occ_old_country1_wt p_native_occ1_wt p_occ_met1_wt cntry_met_wt  age_wt age2_wt sex_wt english_wt edu1_wt edu2_wt edu3_wt edu4_wt edu5_wt edu6_wt mean_occ_edu1_wt marst1_wt marst2_wt marst3_wt marst4_wt marst5_wt marst6_wt, cluster(bpl) noconstant ;
outreg using "reg_agg_data\M_output\avg_clust1_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop1) bracket replace;
regress occpop2_wt p_occ_old_country2_wt p_native_occ2_wt p_occ_met2_wt cntry_met_wt  age_wt age2_wt sex_wt english_wt edu1_wt edu2_wt edu3_wt edu4_wt edu5_wt edu6_wt mean_occ_edu2_wt marst2_wt marst2_wt marst3_wt marst4_wt marst5_wt marst6_wt, cluster(bpl) noconstant ;
outreg using "reg_agg_data\M_output\avg_clust2_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop2) bracket replace;
regress occpop3_wt p_occ_old_country3_wt p_native_occ3_wt p_occ_met3_wt cntry_met_wt  age_wt age2_wt sex_wt english_wt edu1_wt edu2_wt edu3_wt edu4_wt edu5_wt edu6_wt mean_occ_edu3_wt marst3_wt marst2_wt marst3_wt marst4_wt marst5_wt marst6_wt, cluster(bpl) noconstant ;
outreg using "reg_agg_data\M_output\avg_clust3_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop3) bracket replace;
regress occpop4_wt p_occ_old_country4_wt p_native_occ4_wt p_occ_met4_wt cntry_met_wt  age_wt age2_wt sex_wt english_wt edu1_wt edu2_wt edu3_wt edu4_wt edu5_wt edu6_wt mean_occ_edu4_wt marst4_wt marst2_wt marst3_wt marst4_wt marst5_wt marst6_wt, cluster(bpl) noconstant ;
outreg using "reg_agg_data\M_output\avg_clust4_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop4) bracket replace;
regress occpop5_wt p_occ_old_country5_wt p_native_occ5_wt p_occ_met5_wt cntry_met_wt  age_wt age2_wt sex_wt english_wt edu1_wt edu2_wt edu3_wt edu4_wt edu5_wt edu6_wt mean_occ_edu5_wt marst5_wt marst2_wt marst3_wt marst4_wt marst5_wt marst6_wt, cluster(bpl) noconstant ;
outreg using "reg_agg_data\M_output\avg_clust5_nomex_wt.xls",   bdec(3) rdec(3) sigsymb(*,**,+) 10pct coefastr ctitle(occpop5) bracket replace;

log close;


