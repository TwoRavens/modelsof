#delimit ;
clear ;
set memory 300m ;
set matsize 800;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\reg4 NIS" ; 


use "data_nis_census"; 

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

scatter occpop1 p_occ_old_countrystat if p_occ_old_countrystat<.5, xlabel(0 (.05) .5);

scatter occpop2 p_occ_old_countrystat if p_occ_old_countrystat<.5, xlabel(0 (.05) .5);

scatter occpop3 p_occ_old_countrystat if p_occ_old_countrystat<.5, xlabel(0 (.05) .5);

scatter occpop4 p_occ_old_countrystat if p_occ_old_countrystat<.5, xlabel(0 (.05) .5);

scatter occpop5 p_occ_old_countrystat if p_occ_old_countrystat<.5, xlabel(0 (.05) .5);

