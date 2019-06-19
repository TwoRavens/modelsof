#delimit ;
clear ;
set memory 200m ;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\reg4 NIS" ; 

/********* 2000 ************/

use census00_5pc_occstate.dta;
keep if statpop_country>=100;
drop if ciscobinsmo==1;

generate count=1;
by state ciscobinsmo, sort:  egen rank_oldimm_occ=rank(p_occ_old_countrystat), field ;
by state ciscobinsmo rank_oldimm_occ, sort: egen num_obs_rank=count(count);
by state ciscobinsmo, sort:  egen rank_oldimm_occ_wt=rank(p_occ_old_countrystat_wt), field ;
by state ciscobinsmo rank_oldimm_occ_wt, sort: egen num_obs_rank_wt=count(count);
by state ciscobinsmo, sort: egen rank_obs=count(count);

by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1;
by  state ciscobinsmo, sort: egen p_occ_old_country1=median(share1);
drop share1;
by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1|rank_oldimm_occ==2;
by  state ciscobinsmo, sort: egen p_occ_old_country2=median(share1);
drop share1;
by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3;
by  state ciscobinsmo, sort: egen p_occ_old_country3=median(share1);
drop share1;
by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4;
by  state ciscobinsmo, sort: egen p_occ_old_country4=median(share1);
drop share1;
by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4|rank_oldimm_occ==5;
by  state ciscobinsmo, sort: egen p_occ_old_country5=median(share1);
drop share1;

/* p_native_occ=metoccpop_nat/metoccpop_total */
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==1;
by  state ciscobinsmo, sort: egen natpop1=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==2;
by  state ciscobinsmo, sort: egen natpop2=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==3;
by  state ciscobinsmo, sort: egen natpop3=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==4;
by  state ciscobinsmo, sort: egen natpop4=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==5;
by  state ciscobinsmo, sort: egen natpop5=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==1;
by  state ciscobinsmo, sort: egen statoccpop1=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==2;
by  state ciscobinsmo, sort: egen statoccpop2=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==3;
by  state ciscobinsmo, sort: egen statoccpop3=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==4;
by  state ciscobinsmo, sort: egen statoccpop4=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==5;
by  state ciscobinsmo, sort: egen statoccpop5=median(p);
drop p;
egen num1=rowtotal(natpop1);
egen num2=rowtotal(natpop1 natpop2);
egen num3=rowtotal(natpop1 natpop2 natpop3);
egen num4=rowtotal(natpop1 natpop2 natpop3 natpop4);
egen num5=rowtotal(natpop1 natpop2 natpop3 natpop4 natpop5);
egen den1=rowtotal(statoccpop1 );
egen den2=rowtotal(statoccpop1 statoccpop2);
egen den3=rowtotal(statoccpop1 statoccpop2 statoccpop3 );
egen den4=rowtotal(statoccpop1 statoccpop2 statoccpop3 statoccpop4);
egen den5=rowtotal(statoccpop1 statoccpop2 statoccpop3 statoccpop4 statoccpop5);

generate p_native_occ1=num1/den1;
generate p_native_occ2=num2/den2;
generate p_native_occ3=num3/den3;
generate p_native_occ4=num4/den4;
generate p_native_occ5=num5/den5;

drop num1 num2 num3 num4 num5 den1 den2 den3 den4 den5;

/* p_occ_met=(statoccpop_total-new5)/(statpop_total-imm_new5_met) */
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==1;
by  state ciscobinsmo, sort: egen occpop1=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==2;
by  state ciscobinsmo, sort: egen occpop2=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==3;
by  state ciscobinsmo, sort: egen occpop3=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==4;
by  state ciscobinsmo, sort: egen occpop4=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==5;
by  state ciscobinsmo, sort: egen occpop5=median(p);
drop p;
egen num1=rowtotal(occpop1);
egen num2=rowtotal(occpop1 occpop2);
egen num3=rowtotal(occpop1 occpop2 occpop3);
egen num4=rowtotal(occpop1 occpop2 occpop3 occpop4);
egen num5=rowtotal(occpop1 occpop2 occpop3 occpop4 occpop5);
generate p_occ_stat1=num1/statpop_total;
generate p_occ_stat2=num2/statpop_total;
generate p_occ_stat3=num3/statpop_total;
generate p_occ_stat4=num4/statpop_total;
generate p_occ_stat5=num5/statpop_total;

keep  ciscobinsmo occ1990 state rank_obs rank_oldimm_occ rank_oldimm_occ_wt  p_occ_old_country1 p_occ_old_country2 p_occ_old_country3 p_occ_old_country4 p_occ_old_country5 p_native_occ1 p_native_occ2 p_native_occ3 p_native_occ4 p_native_occ5 p_occ_stat1 p_occ_stat2 p_occ_stat3 p_occ_stat4 p_occ_stat5;
rename rank_oldimm_occ rank_occ;
rename rank_oldimm_occ_wt rank_occ_wt;
generate year = 2000;
sort occ1990 state ciscobinsmo ;
save census00_rank.dta, replace;

merge occ1990 state using census00_edu;
drop if _merge==2;
drop _merge;
generate mean_occ_edu_count=mean_occ_edu*occ_edu_count;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu1=num/den;
drop share1 num d den;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1|rank_occ==2;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1|rank_occ==2;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu2=num/den;
drop share1 num d den;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu3=num/den;
drop share1 num d den;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3|rank_occ==4;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3|rank_occ==4;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu4=num/den;
drop share1 num d den;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3|rank_occ==4|rank_occ==5;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3|rank_occ==4|rank_occ==5;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu5=num/den;
drop share1 num d den;
sort ciscobinsmo occ1990 state;
save census00_rank_edu.dta, replace;



/********* 1990 ************/
#delimit;
use census90_5pc_occstate.dta;
keep if statpop_country>=100;
drop if ciscobinsmo==1;

generate count=1;
by state ciscobinsmo, sort:  egen rank_oldimm_occ=rank(p_occ_old_countrystat), field ;
by state ciscobinsmo rank_oldimm_occ, sort: egen num_obs_rank=count(count);
by state ciscobinsmo, sort:  egen rank_oldimm_occ_wt=rank(p_occ_old_countrystat_wt), field ;
by state ciscobinsmo rank_oldimm_occ_wt, sort: egen num_obs_rank_wt=count(count);
by state ciscobinsmo, sort: egen rank_obs=count(count);

by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1;
by  state ciscobinsmo, sort: egen p_occ_old_country1=median(share1);
drop share1;
by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1|rank_oldimm_occ==2;
by  state ciscobinsmo, sort: egen p_occ_old_country2=median(share1);
drop share1;
by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3;
by  state ciscobinsmo, sort: egen p_occ_old_country3=median(share1);
drop share1;
by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4;
by  state ciscobinsmo, sort: egen p_occ_old_country4=median(share1);
drop share1;
by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4|rank_oldimm_occ==5;
by  state ciscobinsmo, sort: egen p_occ_old_country5=median(share1);
drop share1;

/* p_native_occ=metoccpop_nat/metoccpop_total */
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==1;
by  state ciscobinsmo, sort: egen natpop1=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==2;
by  state ciscobinsmo, sort: egen natpop2=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==3;
by  state ciscobinsmo, sort: egen natpop3=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==4;
by  state ciscobinsmo, sort: egen natpop4=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==5;
by  state ciscobinsmo, sort: egen natpop5=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==1;
by  state ciscobinsmo, sort: egen statoccpop1=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==2;
by  state ciscobinsmo, sort: egen statoccpop2=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==3;
by  state ciscobinsmo, sort: egen statoccpop3=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==4;
by  state ciscobinsmo, sort: egen statoccpop4=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==5;
by  state ciscobinsmo, sort: egen statoccpop5=median(p);
drop p;
egen num1=rowtotal(natpop1);
egen num2=rowtotal(natpop1 natpop2);
egen num3=rowtotal(natpop1 natpop2 natpop3);
egen num4=rowtotal(natpop1 natpop2 natpop3 natpop4);
egen num5=rowtotal(natpop1 natpop2 natpop3 natpop4 natpop5);
egen den1=rowtotal(statoccpop1 );
egen den2=rowtotal(statoccpop1 statoccpop2);
egen den3=rowtotal(statoccpop1 statoccpop2 statoccpop3 );
egen den4=rowtotal(statoccpop1 statoccpop2 statoccpop3 statoccpop4);
egen den5=rowtotal(statoccpop1 statoccpop2 statoccpop3 statoccpop4 statoccpop5);

generate p_native_occ1=num1/den1;
generate p_native_occ2=num2/den2;
generate p_native_occ3=num3/den3;
generate p_native_occ4=num4/den4;
generate p_native_occ5=num5/den5;

drop num1 num2 num3 num4 num5 den1 den2 den3 den4 den5;

/* p_occ_met=(statoccpop_total-new5)/(statpop_total-imm_new5_met) */
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==1;
by  state ciscobinsmo, sort: egen occpop1=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==2;
by  state ciscobinsmo, sort: egen occpop2=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==3;
by  state ciscobinsmo, sort: egen occpop3=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==4;
by  state ciscobinsmo, sort: egen occpop4=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==5;
by  state ciscobinsmo, sort: egen occpop5=median(p);
drop p;
egen num1=rowtotal(occpop1);
egen num2=rowtotal(occpop1 occpop2);
egen num3=rowtotal(occpop1 occpop2 occpop3);
egen num4=rowtotal(occpop1 occpop2 occpop3 occpop4);
egen num5=rowtotal(occpop1 occpop2 occpop3 occpop4 occpop5);
generate p_occ_stat1=num1/statpop_total;
generate p_occ_stat2=num2/statpop_total;
generate p_occ_stat3=num3/statpop_total;
generate p_occ_stat4=num4/statpop_total;
generate p_occ_stat5=num5/statpop_total;

keep  ciscobinsmo occ1990 state rank_obs rank_oldimm_occ rank_oldimm_occ_wt  p_occ_old_country1 p_occ_old_country2 p_occ_old_country3 p_occ_old_country4 p_occ_old_country5 p_native_occ1 p_native_occ2 p_native_occ3 p_native_occ4 p_native_occ5 p_occ_stat1 p_occ_stat2 p_occ_stat3 p_occ_stat4 p_occ_stat5;
rename rank_oldimm_occ rank_occ;
rename rank_oldimm_occ_wt rank_occ_wt;
generate year = 1990;
sort occ1990 state ciscobinsmo ;
save census90_rank.dta, replace;

merge occ1990 state using census90_edu;
drop if _merge==2;
drop _merge;
generate mean_occ_edu_count=mean_occ_edu*occ_edu_count;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu1=num/den;
drop share1 num d den;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1|rank_occ==2;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1|rank_occ==2;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu2=num/den;
drop share1 num d den;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu3=num/den;
drop share1 num d den;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3|rank_occ==4;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3|rank_occ==4;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu4=num/den;
drop share1 num d den;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3|rank_occ==4|rank_occ==5;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3|rank_occ==4|rank_occ==5;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu5=num/den;
drop share1 num d den;
sort ciscobinsmo occ1990 state;
save census90_rank_edu.dta, replace;



/********* 1980 ************/
#delimit;
clear;
use census80_5pc_occstate.dta;
keep if statpop_country>=100;
drop if ciscobinsmo==1;

generate count=1;
by state ciscobinsmo, sort:  egen rank_oldimm_occ=rank(p_occ_old_countrystat), field ;
by state ciscobinsmo rank_oldimm_occ, sort: egen num_obs_rank=count(count);
by state ciscobinsmo, sort:  egen rank_oldimm_occ_wt=rank(p_occ_old_countrystat_wt), field ;
by state ciscobinsmo rank_oldimm_occ_wt, sort: egen num_obs_rank_wt=count(count);
by state ciscobinsmo, sort: egen rank_obs=count(count);


by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1;
by  state ciscobinsmo, sort: egen p_occ_old_country1=median(share1);
drop share1;
by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1|rank_oldimm_occ==2;
by  state ciscobinsmo, sort: egen p_occ_old_country2=median(share1);
drop share1;
by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3;
by  state ciscobinsmo, sort: egen p_occ_old_country3=median(share1);
drop share1;
by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4;
by  state ciscobinsmo, sort: egen p_occ_old_country4=median(share1);
drop share1;
by  state ciscobinsmo, sort: egen share1=sum(p_occ_old_countrystat) if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4|rank_oldimm_occ==5;
by  state ciscobinsmo, sort: egen p_occ_old_country5=median(share1);
drop share1;

/* p_native_occ=metoccpop_nat/metoccpop_total */
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==1;
by  state ciscobinsmo, sort: egen natpop1=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==2;
by  state ciscobinsmo, sort: egen natpop2=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==3;
by  state ciscobinsmo, sort: egen natpop3=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==4;
by  state ciscobinsmo, sort: egen natpop4=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_nat if rank_oldimm_occ==5;
by  state ciscobinsmo, sort: egen natpop5=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==1;
by  state ciscobinsmo, sort: egen statoccpop1=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==2;
by  state ciscobinsmo, sort: egen statoccpop2=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==3;
by  state ciscobinsmo, sort: egen statoccpop3=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==4;
by  state ciscobinsmo, sort: egen statoccpop4=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==5;
by  state ciscobinsmo, sort: egen statoccpop5=median(p);
drop p;
egen num1=rowtotal(natpop1);
egen num2=rowtotal(natpop1 natpop2);
egen num3=rowtotal(natpop1 natpop2 natpop3);
egen num4=rowtotal(natpop1 natpop2 natpop3 natpop4);
egen num5=rowtotal(natpop1 natpop2 natpop3 natpop4 natpop5);
egen den1=rowtotal(statoccpop1 );
egen den2=rowtotal(statoccpop1 statoccpop2);
egen den3=rowtotal(statoccpop1 statoccpop2 statoccpop3 );
egen den4=rowtotal(statoccpop1 statoccpop2 statoccpop3 statoccpop4);
egen den5=rowtotal(statoccpop1 statoccpop2 statoccpop3 statoccpop4 statoccpop5);

generate p_native_occ1=num1/den1;
generate p_native_occ2=num2/den2;
generate p_native_occ3=num3/den3;
generate p_native_occ4=num4/den4;
generate p_native_occ5=num5/den5;

drop num1 num2 num3 num4 num5 den1 den2 den3 den4 den5;

/* p_occ_met=(statoccpop_total-new5)/(statpop_total-imm_new5_met) */
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==1;
by  state ciscobinsmo, sort: egen occpop1=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==2;
by  state ciscobinsmo, sort: egen occpop2=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==3;
by  state ciscobinsmo, sort: egen occpop3=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==4;
by  state ciscobinsmo, sort: egen occpop4=median(p);
drop p;
by  state ciscobinsmo, sort: gen p=statoccpop_total if rank_oldimm_occ==5;
by  state ciscobinsmo, sort: egen occpop5=median(p);
drop p;
egen num1=rowtotal(occpop1);
egen num2=rowtotal(occpop1 occpop2);
egen num3=rowtotal(occpop1 occpop2 occpop3);
egen num4=rowtotal(occpop1 occpop2 occpop3 occpop4);
egen num5=rowtotal(occpop1 occpop2 occpop3 occpop4 occpop5);
generate p_occ_stat1=num1/statpop_total;
generate p_occ_stat2=num2/statpop_total;
generate p_occ_stat3=num3/statpop_total;
generate p_occ_stat4=num4/statpop_total;
generate p_occ_stat5=num5/statpop_total;

keep  ciscobinsmo occ1990 state rank_obs rank_oldimm_occ rank_oldimm_occ_wt  p_occ_old_country1 p_occ_old_country2 p_occ_old_country3 p_occ_old_country4 p_occ_old_country5 p_native_occ1 p_native_occ2 p_native_occ3 p_native_occ4 p_native_occ5 p_occ_stat1 p_occ_stat2 p_occ_stat3 p_occ_stat4 p_occ_stat5;

rename rank_oldimm_occ rank_occ;
rename rank_oldimm_occ_wt rank_occ_wt;
generate year = 1980;
sort occ1990 state ciscobinsmo ;
save census80_rank.dta, replace;

merge occ1990 state using census80_edu;
drop if _merge==2;
drop _merge;
generate mean_occ_edu_count=mean_occ_edu*occ_edu_count;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu1=num/den;
drop share1 num d den;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1|rank_occ==2;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1|rank_occ==2;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu2=num/den;
drop share1 num d den;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu3=num/den;
drop share1 num d den;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3|rank_occ==4;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3|rank_occ==4;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu4=num/den;
drop share1 num d den;
by  state ciscobinsmo, sort: egen share1=sum(mean_occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3|rank_occ==4|rank_occ==5;
by  state ciscobinsmo, sort: egen num=median(share1);
by state ciscobinsmo, sort:  egen d=sum(occ_edu_count) if rank_occ==1|rank_occ==2|rank_occ==3|rank_occ==4|rank_occ==5;
by  state ciscobinsmo, sort: egen den=median(d);
generate mean_occ_edu5=num/den;
drop share1 num d den;
sort ciscobinsmo occ1990 state;
save census80_rank_edu.dta, replace;

append using census90_rank_edu.dta;
append using census00_rank_edu.dta;
sort ciscobinsmo occ1990 state year;
save census_rank_edu.dta, replace;

clear;
use census90_rank.dta;
append using census90_rank.dta;
append using census00_rank.dta;
sort ciscobinsmo occ1990 state year;
save census_rank.dta, replace;


