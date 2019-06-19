# delimit;
capture log close;
clear;
set mem 200m;
set matsize 800;

/*
*******************************************************;
31st October 2005
Randolph bruno
BEEPs' code to harmonise 1999 2002 2005 questionaires
NB: the file contains arouns 1200 obs for TURKEY. To exclude it use the
command "drop if country==5" at the end of the program
*******************************************************;
*/

cd "$dir";

log using logs/data.recoding.txt, text replace;

************************************************************************************
1999
************************************************************************************;

use data/cleaned1999.dta, clear;
        gen year=1999;
        ren Serial      serialno;

************************************************************************
PROCEDURES FOR THE CREATION OF THE FILE WITH ONLY MISSING AND WITHOUT 
DO NOT KNOW AND NOT APPLICABLE CODES (e.g. no -9997 in the variables see A. Muraviev note on Cleaning)
************************************************************************;

sort year serialno;

foreach var of varlist * {;
replace `var'=. if  `var'==-9995 | `var'==-9996 | `var'==-9997 | `var'==-9998 | `var'==-9999;
};

foreach var of varlist * {;
tabstat `var', by(year) stats(mean min max range sd n); 
}
;

******************************************************************************
******************************************************************************;

gen man_over=.;

        gen Q3panel=.;
        gen cardno=.;


ren Country     country;
        gen Q2_3yugo=.;

ren Town2       citytown;
        gen Q3region=.;
        gen Q3srl_no2002=.;
ren   Q6Yr      start;

gen legstqA=.;
replace legstqA=S2Pri if S2Pri!=.;
replace legstqA=7       if S2Sta==1;
replace legstqA=8       if S2Sta==2;
replace legstqA=9       if S2Sta==3;

gen legstqB=.;
replace         legstqB=1 if S2Pri!=.;
replace         legstqB=2 if S2Sta!=.;

drop S2Pri S2Sta;       

gen ind=.;

replace ind=9 if S3Man==1;
replace ind=1 if S3Man==2;
replace ind=3 if S3Man==3;
replace ind=2 if S3Man==4;
replace ind=10 if S3Man==5;

replace ind=5 if S3Ser==1;
replace ind=5 if S3Ser==2;
replace ind=4 if S3Ser==3;
replace ind=8 if S3Ser==4;
replace ind=8 if S3Ser==5;
replace ind=6 if S3Ser==6;
replace ind=8 if S3Ser==7;
replace ind=8 if S3Ser==8;

replace ind=8 if S3Oth==1;
replace ind=8 if S3Oth==2;

drop S3Man      S3Ser   S3Oth;

ren S4  Q2_3main_prdc;
gen full_empqA=S5Ful;

replace full_empqA=0 if S5Ful==1;
replace full_empqA=1 if S5Ful==2;
replace full_empqA=2 if S5Ful==3;
replace full_empqA=3 if S5Ful==4;
replace full_empqA=4 if S5Ful==5;
replace full_empqA=5 if S5Ful==6;
replace full_empqA=6 if S5Ful==7;

drop S5Ful;

gen full_empqB=full_empqA ;

replace full_empqB=1 if (full_empqA==0 | full_empqA==1 | full_empqA==2);
replace full_empqB=2 if (full_empqA==3 | full_empqA==4); 
replace full_empqB=3 if (full_empqA==5 | full_empqA==6);

ren S5Cas       Q1full_empqC;

ren S6  Q1ownedqA;
ren S7  ownedqB;
        gen Q2_3ownedqC=.;
ren S9  Q1ownedqD;
ren S10 ownedqE;
        gen Q2_3ownedqF=.;

ren S8  natl_forgnqA;
        gen natl_forgnqB=.;

ren S12 sell_out;

ren S13 exp_prc_sales;
        
        gen Q2_3plants=.;

ren S11 ops_abro;

ren S1  job_titleqA;
ren     Q1Chi   job_titleqB;
ren     Q1Own   job_titleqC;
ren     Q1Par   job_titleqD;
ren     Q1Dir   job_titleqE;
*ren    Q1gen job_titleqF;
ren     Q1Man   job_titleqG;
ren     Q1Fin   job_titleqH;
ren     Q1Oth   job_titleqI;
ren     Q1Dep   job_titleqJ;

        gen Q2_3sale_sctrqA=.;
        gen Q2_3sale_sctrqB=.;
        gen Q2_3sale_sctrqC=.;
        gen Q2_3sale_sctrqD=.;
        gen Q2_3sale_sctrqE=.;
        gen Q2_3sale_sctrqF=.;
        gen Q2_3sale_sctrqG=.;
        gen Q2_3sale_sctrqH=.;

gen     owner=Q4;
replace owner=4 if Q4==3;
replace owner=5 if Q4==4;
replace owner=6 if Q4==5;
replace owner=6 if Q4==6;
replace owner=8 if Q4==7;
replace owner=9 if Q4==8;
replace owner=10 if Q4==9;
replace owner=11 if Q4==13;
drop Q4;

gen     estb=Q7New     ;
        replace estb=2 if Q7New==1;
        replace estb=1 if Q7New==2;
drop    Q7New;

                
gen  Q2_3custqA=.;
gen  Q2_3custqB=.;
gen  Q2_3custqC=.;
gen  Q2_3custqD=.;
        
gen  Q3custqE1=.;
gen  Q3custqE2=.;
gen  Q3custqE3=.;

gen  Q2_3custqE=.;

gen     Q2_3priv=.;

        gen     Q2_3imp_cmpt=.;

gen     compt=Q60;
        replace compt=4 if Q60==1;
        replace compt=3 if Q60==2;
        replace compt=2 if Q60==3;
        replace compt=1 if Q60==4;
drop Q60;

ren     Q45     comps;
        gen Q2_3ex_comps_ntl=.;
        gen Q3compsR=.;
        gen Q3ex_comps_ntlR=.;
        gen Q3c_local=.;
        gen Q3comps_local=.;
        gen Q3comps_localR=.;
        gen Q3ex_comps_loc=.;
        gen Q3ex_comps_locR=. ;
        gen exnocomR=. ;

/* COMPETITION BASED ON THE NUMBER OF COMPETITORS*/

gen nocomp=comps;
gen nocompR=Q3compsR;

ren     Q61     Q1_2mkt_salesqA;
        gen     Q1_2mkt_salesqB=.;

ren     Q62     markupqA;
        
        gen Q2_3inputqA=.;
        gen Q2_3inputqB=.;
        gen Q2_3inputqC=.;
ren     Q13     custm_dly;
        gen Q2_3suppl_prc=.;
        gen Q2_3dys_inf_dfcqA=.;
        gen Q2_3dys_inf_dfcqB=.;
        gen Q2_3dys_inf_dfcqC=.;
        gen Q2_3int_clntsqA=.;
        gen Q2_3int_clntsqB=.;
        gen Q2_3int_clntsqC=.;
        gen Q2_3int_clntsqD=.;
        gen Q2_3int_clntsqE=.;
        gen Q2_3dys_dly_srvcqA=.;
        gen Q2_3dys_dly_srvcqB=.;

gen     court_sys_prcptqA=Q22Fai;
gen     court_sys_prcptqB=Q22Hon;
gen     court_sys_prcptqC=Q22Qui;
gen     court_sys_prcptqD=Q22Aff;
gen     court_sys_prcptqE=Q22Enf;
gen     Q1court_sys_prcptqF=Q22Con;

replace         court_sys_prcptqA=6 if Q22Fai==1;
replace         court_sys_prcptqA=5 if Q22Fai==2;
replace         court_sys_prcptqA=4 if Q22Fai==3;
replace         court_sys_prcptqA=3 if Q22Fai==4;
replace         court_sys_prcptqA=2 if Q22Fai==5;
replace         court_sys_prcptqA=1 if Q22Fai==6;
drop Q22Fai;

replace         court_sys_prcptqB=6 if Q22Hon==1;
replace         court_sys_prcptqB=5 if Q22Hon==2;
replace         court_sys_prcptqB=4 if Q22Hon==3;
replace         court_sys_prcptqB=3 if Q22Hon==4;
replace         court_sys_prcptqB=2 if Q22Hon==5;
replace         court_sys_prcptqB=1 if Q22Hon==6;
drop Q22Hon;

replace         court_sys_prcptqC=6 if Q22Qui==1;
replace         court_sys_prcptqC=5 if Q22Qui==2;
replace         court_sys_prcptqC=4 if Q22Qui==3;
replace         court_sys_prcptqC=3 if Q22Qui==4;
replace         court_sys_prcptqC=2 if Q22Qui==5;
replace         court_sys_prcptqC=1 if Q22Qui==6;
drop Q22Qui;

replace         court_sys_prcptqD=6 if Q22Aff==1;
replace         court_sys_prcptqD=5 if Q22Aff==2;
replace         court_sys_prcptqD=4 if Q22Aff==3;
replace         court_sys_prcptqD=3 if Q22Aff==4;
replace         court_sys_prcptqD=2 if Q22Aff==5;
replace         court_sys_prcptqD=1 if Q22Aff==6;
drop Q22Aff;

replace         court_sys_prcptqE=6 if Q22Enf==1;
replace         court_sys_prcptqE=5 if Q22Enf==2;
replace         court_sys_prcptqE=4 if Q22Enf==3;
replace         court_sys_prcptqE=3 if Q22Enf==4;
replace         court_sys_prcptqE=2 if Q22Enf==5;
replace         court_sys_prcptqE=1 if Q22Enf==6;
drop Q22Enf;

replace         Q1court_sys_prcptqF=6 if Q22Con==1;
replace         Q1court_sys_prcptqF=5 if Q22Con==2;
replace         Q1court_sys_prcptqF=4 if Q22Con==3;
replace         Q1court_sys_prcptqF=3 if Q22Con==4;
replace         Q1court_sys_prcptqF=2 if Q22Con==5;
replace         Q1court_sys_prcptqF=1 if Q22Con==6;
drop Q22Con;

gen     conf_lgl_systm=Q23a;
        replace conf_lgl_systm=6 if Q23a==1;
        replace conf_lgl_systm=5 if Q23a==2;
        replace conf_lgl_systm=4 if Q23a==3;
        replace conf_lgl_systm=3 if Q23a==4;
        replace conf_lgl_systm=2 if Q23a==5;
        replace conf_lgl_systm=1 if Q23a==6;
drop Q23a;

gen     Q1conf_lgl_systmR=Q23b  ;
        replace Q1conf_lgl_systmR=6 if Q23b==1;
        replace Q1conf_lgl_systmR=5 if Q23b==2;
        replace Q1conf_lgl_systmR=4 if Q23b==3;
        replace Q1conf_lgl_systmR=3 if Q23b==4;
        replace Q1conf_lgl_systmR=2 if Q23b==5;
        replace Q1conf_lgl_systmR=1 if Q23b==6;

drop Q23b;


        gen     Q2_3sale_prpaid=.;
        gen Q2_3sal_cred=.;
        gen Q2_3ovrdue_pymnt=.;
        gen Q2_3days_rslv_pymnt=.;
        gen Q2_3pay_scrtyqA=.;
        gen Q2_3pay_scrtyqB=.;
        gen Q2_3pay_prtctnqA=.;
        gen Q2_3pay_prtctnqB=.;
        gen Q2_3lossesqA=.;
        gen Q2_3lossesqB=.;

gen     info_laws=Q15;
        replace info_laws=6 if Q15==1;
        replace info_laws=5 if Q15==2;
        replace info_laws=4 if Q15==3;
        replace info_laws=3 if Q15==4;
        replace info_laws=2 if Q15==5;
        replace info_laws=1 if Q15==6;
drop Q15;


gen             intrp_laws=Q16a;
        replace intrp_laws=6 if Q16a==1;
        replace intrp_laws=5 if Q16a==2;
        replace intrp_laws=4 if Q16a==3;
        replace intrp_laws=3 if Q16a==4;
        replace intrp_laws=2 if Q16a==5;
        replace intrp_laws=1 if Q16a==6;
drop Q16a;


gen     Q1intrp_lawsR=Q16b;
        replace Q1intrp_lawsR=6 if Q16b==1;
        replace Q1intrp_lawsR=5 if Q16b==2;
        replace Q1intrp_lawsR=4 if Q16b==3;
        replace Q1intrp_lawsR=3 if Q16b==4;
        replace Q1intrp_lawsR=2 if Q16b==5;
        replace Q1intrp_lawsR=1 if Q16b==6;
drop Q16b;
ren     Q36     Q1_2prdc_law;

/*CAPTURING VARIABLES*/

ren     Q24     time_pub_off_cat;
        gen     Q2_3time_pub_off_prc=.;

gen     unoff_pay=Q31;
        replace unoff_pay=6 if Q31==1;
        replace unoff_pay=5 if Q31==2;
        replace unoff_pay=4 if Q31==3;
        replace unoff_pay=3 if Q31==4;
        replace unoff_pay=2 if Q31==5;
        replace unoff_pay=1 if Q31==6;
drop Q31;

ren     Q32     memb_lobby;
        gen Q2_3seek_infqA=.;
        gen Q2_3seek_infqB=.;


gen     add_pay=Q25     ;
        replace add_pay=6 if Q25==1;
        replace add_pay=5 if Q25==2;
        replace add_pay=4 if Q25==3;
        replace add_pay=3 if Q25==4;
        replace add_pay=2 if Q25==5;
        replace add_pay=1 if Q25==6;
drop Q25;
gen     know_add_pay=Q26a       ;
        replace know_add_pay=6 if Q26a==1;
        replace know_add_pay=5 if Q26a==2;
        replace know_add_pay=4 if Q26a==3;
        replace know_add_pay=3 if Q26a==4;
        replace know_add_pay=2 if Q26a==5;
        replace know_add_pay=1 if Q26a==6;
drop Q26a;

gen Q2_3pay_perc_sales_prc=.;

gen     pay_reasonqA=Q28Con;
gen     pay_reasonqB=Q28Lic;
gen     pay_reasonqG=Q28Tax;
gen     pay_reasonqC=Q28Gov;
gen     pay_reasonqH=Q28Cus;
gen     pay_reasonqI=Q28Cou;
gen     pay_reasonqJ=Q28Law;
gen     pay_reasonqK=Q28Oth;
        gen Q2_3pay_reasonqD=.;
        gen Q2_3pay_reasonqE=.;
        gen Q2_3pay_reasonqF=.;

replace pay_reasonqA=6 if Q28Con==1;
replace pay_reasonqA=5 if Q28Con==2;
replace pay_reasonqA=4 if Q28Con==3;
replace pay_reasonqA=3 if Q28Con==4;
replace pay_reasonqA=2 if Q28Con==5;
replace pay_reasonqA=1 if Q28Con==6;
replace pay_reasonqB=6 if Q28Lic==1;
replace pay_reasonqB=5 if Q28Lic==2;
replace pay_reasonqB=4 if Q28Lic==3;
replace pay_reasonqB=3 if Q28Lic==4;
replace pay_reasonqB=2 if Q28Lic==5;
replace pay_reasonqB=1 if Q28Lic==6;
replace pay_reasonqG=6 if Q28Tax==1;
replace pay_reasonqG=5 if Q28Tax==2;
replace pay_reasonqG=4 if Q28Tax==3;
replace pay_reasonqG=3 if Q28Tax==4;
replace pay_reasonqG=2 if Q28Tax==5;
replace pay_reasonqG=1 if Q28Tax==6;
replace pay_reasonqC=6 if Q28Gov==1;
replace pay_reasonqC=5 if Q28Gov==2;
replace pay_reasonqC=4 if Q28Gov==3;
replace pay_reasonqC=3 if Q28Gov==4;
replace pay_reasonqC=2 if Q28Gov==5;
replace pay_reasonqC=1 if Q28Gov==6;
replace pay_reasonqH=6 if Q28Cus==1;
replace pay_reasonqH=5 if Q28Cus==2;
replace pay_reasonqH=4 if Q28Cus==3;
replace pay_reasonqH=3 if Q28Cus==4;
replace pay_reasonqH=2 if Q28Cus==5;
replace pay_reasonqH=1 if Q28Cus==6;

replace pay_reasonqI=6 if Q28Cou==1;
replace pay_reasonqI=5 if Q28Cou==2;
replace pay_reasonqI=4 if Q28Cou==3;
replace pay_reasonqI=3 if Q28Cou==4;
replace pay_reasonqI=2 if Q28Cou==5;
replace pay_reasonqI=1 if Q28Cou==6;

replace pay_reasonqJ=6 if Q28Law==1;
replace pay_reasonqJ=5 if Q28Law==2;
replace pay_reasonqJ=4 if Q28Law==3;
replace pay_reasonqJ=3 if Q28Law==4;
replace pay_reasonqJ=2 if Q28Law==5;
replace pay_reasonqJ=1 if Q28Law==6;

replace pay_reasonqK=6 if Q28Oth==1;
replace pay_reasonqK=5 if Q28Oth==2;
replace pay_reasonqK=4 if Q28Oth==3;
replace pay_reasonqK=3 if Q28Oth==4;
replace pay_reasonqK=2 if Q28Oth==5;
replace pay_reasonqK=1 if Q28Oth==6;

        gen Q2_3source_fin_capqA=.;
        gen Q2_3source_fin_capqB=.;
        gen Q2_3source_fin_capqC=.;
        gen Q2_3source_fin_capqD=.;
        gen Q2_3source_fin_capqE=.;
        gen Q2_3source_fin_capqF=.;
        gen Q2_3source_fin_capqG=.;
        gen Q2_3source_fin_capqH=.;
        gen Q2_3source_fin_capqI=.;
        gen Q2_3source_fin_capqJ=.;
        gen Q2_3source_fin_capqK=.;
        gen Q2_3source_fin_capqL=.;
        gen Q2_3source_fin_capqM=.;
        gen Q2_3source_fin_capqN=.;


ren Q38bInt             source_fin_invqA;
ren Q38bEqu             source_fin_invqB;
ren Q38bLoc             source_fin_invqC;
ren Q38bFor             source_fin_invqD;
        gen             Q2_3source_fin_invqE=.;
ren Q38bFam             source_fin_invqF;
ren Q38bMon             source_fin_invqG;
ren Q38bSup             source_fin_invqH;
        gen             Q2_3source_fin_invqI=.;
        gen             Q2_3source_fin_invqJ=.;
ren Q38bLea             source_fin_invqK;
ren Q38bSta             source_fin_invqL;
ren Q38bOth1    source_fin_invqM;
ren Q38bOth2    source_fin_invqN;
ren Q38bInv             Q1source_fin_invqO;

drop Q38bOth3 Q38bOth4  Q38bOth5;

        gen Q2_3cltrl_loan=.;
        gen Q2_3val_cltrl=.;
        gen Q2_3loan_cost=.;
        gen Q2_3loan_drtn=.;
        gen Q2_3days_get_loan=.;
ren Q43 ias;
ren Q44 extrnl_adtr;
ren Q40a        Q1_2days_trans_domqA;
ren Q40b        Q1days_trans_domRqA;
ren Q40c        Q1_2days_trans_frgnqA;
ren Q40d        Q1days_trans_frgnRqA;

ren Q67a        sales_bartrqA;
        gen sales_bartrqB=.;
        gen sales_bartrqC=.;
        gen sales_bartrqD=.;
        gen sales_bartrqE=.;
        gen sales_bartrqF=.;
        gen Q2_3purchs_bartrqA=.;
        gen Q2_3purchs_bartrqB=.;
        gen Q2_3purchs_bartrqC=.;
        gen Q2_3purchs_bartrqD=.;
        gen Q2_3purchs_bartrqE=.;
        gen Q2_3purchs_bartrqF=.;

        gen Q2_3ovrd_pymt_ctgqA=.;
        gen Q2_3ovrd_pymt_ctgqB=.;
        gen Q2_3ovrd_pymt_ctgqC=.;
        gen Q2_3ovrd_pymt_ctgqD=.;

        gen     Q2_3ovrd_pymt_perqA=.;
        gen     Q2_3ovrd_pymt_perqB=.;
        gen     Q2_3ovrd_pymt_perqC=.;
        gen     Q2_3ovrd_pymt_perqD=.;

ren Q65a        subsdsqA;
        gen Q2_3subsdsqA1=.;
        gen Q2_3subsdsqA2=.;
        gen Q3subsdsqB=.;
        gen Q2_3subsdsqC=.;
ren Q65b        Q1subsdsR;

        gen Q2_3sub_perc_slsqA=.;
        gen Q2_3sub_perc_slsqB=.;
        gen Q2_3sub_perc_slsqC=.;
        gen Q2_3sub_perc_slsqD=.;

/*BUSINESS ENVIRONMENT*/

ren Q41Col      Q1constrqA1;
ren Q41Con      Q1constrqA2;
ren Q41Mon      Q1constrqA3;
ren Q41For      Q1constrqA4;
ren Q41Equ      Q1constrqA5;
ren Q41Exp      Q1constrqA6;
ren Q41Lea      Q1constrqA7;
ren Q41Cre      Q1constrqA8;
ren Q41Lon      Q1constrqA9;
        gen constrqA=.;
gen counter=0;
gen counter1=0;
gen counter2=0;
gen summ1=0;
foreach var of varlist  
Q1constrqA1
Q1constrqA2
Q1constrqA3
Q1constrqA4
Q1constrqA5
Q1constrqA6
Q1constrqA7
Q1constrqA8
Q1constrqA9 
{;
replace counter=counter+1 if `var'>0 & `var'~=.;
replace summ1=summ1+`var' if `var'>=0 & `var'~=.;
replace counter1=counter1+1;
replace counter2=counter2+1 if  `var'==.;
};
replace constrqA=summ1/counter ;
replace constrqA=. if counter1==counter2;
drop 
counter
counter1
counter2
summ1;

ren Q41Pap      Q1constrqB1;
ren Q41Int      Q1constrqB2;
ren Q41Cor      Q1constrqB3;
        gen constrqB=.;

gen counter=0;
gen counter1=0;
gen counter2=0;
gen summ1=0;
foreach var of varlist  
Q1constrqB1     
Q1constrqB2     
Q1constrqB3     
{;
replace counter=counter+1 if `var'>0 & `var'~=.;
replace summ1=summ1+`var' if `var'>=0 & `var'~=.;
replace counter1=counter1+1;
replace counter2=counter2+1 if  `var'==.;
};
replace constrqB=summ1/counter ;
replace constrqB=. if counter1==counter2;
drop 
counter
counter1
counter2
summ1;

        gen Q2_3constrqC1=.;
        gen Q2_3constrqC2=.;
        gen Q2_3constrqC3=.;
        gen Q2_3constrqC4=.;
        gen Q2_3constrqC5=.;
ren Q49Infr     constrqC;
ren Q17HiT      constrqD;
ren Q17Tax      constrqE;
ren Q17Cus      constrqF;
ren Q17Bus      Q1constrqG1;
ren Q17Env      Q1constrqG2;
ren Q17Fir      Q1constrqG3;
        gen constrqG=.;

gen counter=0;
gen counter1=0;
gen counter2=0;
gen summ1=0;
foreach var of varlist
Q1constrqG1     
Q1constrqG2     
Q1constrqG3     
{;
replace counter=counter+1 if `var'>0 & `var'~=.;
replace summ1=summ1+`var' if `var'>=0 & `var'~=.;
replace counter1=counter1+1;
replace counter2=counter2+1 if  `var'==.;
};
replace constrqG=summ1/counter ;
replace constrqG=. if counter1==counter2;
drop 
counter
counter1
counter2
summ1;

ren Q17Lab      constrqH;
        gen Q2_3constrqI=.;
ren Q49Pol      constrqJ;
ren Q49Infl     Q1constrqK1;
ren Q49Exc      Q1constrqK2;
        gen constrqK=.;

gen counter=0;
gen counter1=0;
gen counter2=0;
gen summ1=0;
foreach var of varlist
Q1constrqK1     
Q1constrqK2             
{;
replace counter=counter+1 if `var'>0 & `var'~=.;
replace summ1=summ1+`var' if `var'>=0 & `var'~=.;
replace counter1=counter1+1;
replace counter2=counter2+1 if  `var'==.;
};
replace constrqK=summ1/counter ;
replace constrqK=. if counter1==counter2;
drop 
counter
counter1
counter2
summ1;

ren Q49Jud      constrqL;
ren Q49Cor      constrqM;
ren Q49Str      constrqN;
ren Q49Org      constrqO;
ren Q49Ant      constrqP;
        gen Q2_3constrqQ=.;
ren Q49Oth      Q1_3constrqR;
        
ren Q17For      Q1constrqS;

gen constrqALL15=.;
gen counter=0;
gen counter1=0;
gen counter2=0;
gen summ1=0;
foreach var of varlist  

constrqA
constrqB
constrqC
constrqD
constrqE
constrqF
constrqG
constrqH
constrqJ
constrqK
constrqL
constrqM
constrqN
constrqO
constrqP

{;
replace counter=counter+1 if `var'>0 & `var'~=.;
replace summ1=summ1+`var' if `var'>=0 & `var'~=.;
replace counter1=counter1+1;
replace counter2=counter2+1 if  `var'==.;
};
replace constrqALL15=summ1/counter ;
replace constrqALL15=. if counter1==counter2;
drop 
counter
counter1
counter2
summ1;

/*MAIN VARIABLES CHANGE*/

ren QQ50Sal     perfqA;
ren QQ50Inv     perfqB;
ren QQ50Exp     perfqC;
ren QQ50Emp     Q1perfqD;
ren QQ50Deb     Q1perfqE;
        gen Q3perfqF=.;
ren QQ50SalP perfqG;

ren QQ50InvP    perfqH;
ren QQ50ExpP    perfqI;
ren QQ50EmpP    perfqJ;

ren QQ50DebP    Q1perfqK;
        gen Q3perfqL=.;
ren QE50Sal     Q1perfqM;
ren QE50Inv     Q1perfqN;
ren QE50Exp     Q1perfqO;
ren QE50Emp     Q1perfqP;
ren QE50Deb     Q1perfqQ;
ren QE50SalP    Q1perfqR;
ren QE50InvP    Q1perfqS;
ren QE50ExpP    Q1perfqT;
ren QE50EmpP    Q1perfqU;
ren QE50DebP    Q1perfqV;

replace perfqA=-1 if perfqA==2;
replace perfqA=0 if perfqA==3;
*replace perfqA=1 if perfqA==1;

replace perfqB=-1 if perfqB==2;
replace perfqB=0 if perfqB==3;
*replace perfqB=1 if perfqB==1;

replace perfqC=-1 if perfqC==2;
replace perfqC=0 if perfqC==3;
*replace perfqC=1 if perfqC==1;

replace Q1perfqD=-1 if Q1perfqD==2;
replace Q1perfqD=0 if Q1perfqD==3;
*replace Q1perfqD=1 if Q1perfqD==1;

replace Q1perfqE=-1 if Q1perfqE==2;
replace Q1perfqE=0 if Q1perfqE==3;
*replace Q1perfqE=1 if Q1perfqE==1;

replace Q1perfqM=-1 if Q1perfqM==2;
replace Q1perfqM=0 if Q1perfqM==3;
*replace Q1perfqM=1 if Q1perfqM==1;

replace Q1perfqN=-1 if Q1perfqN==2;
replace Q1perfqN=0 if Q1perfqN==3;
*replace Q1perfqN=1 if Q1perfqN==1;

replace Q1perfqO=-1 if Q1perfqO==2;
replace Q1perfqO=0 if Q1perfqO==3;
*replace Q1perfqO=1 if Q1perfqO==1;

replace Q1perfqP=-1 if Q1perfqP==2;
replace Q1perfqP=0 if Q1perfqP==3;
*replace Q1perfqP=1 if Q1perfqP==1;

replace Q1perfqQ=-1 if Q1perfqQ==2;
replace Q1perfqQ=0 if Q1perfqQ==3;
*replace Q1perfqQ=1 if Q1perfqQ==1;

replace perfqG=-perfqG  if perfqA==-1 & perfqG>0 & perfqG!=.;
replace perfqH=-perfqH  if perfqB==-1 & perfqH>0 & perfqH!=.;
replace perfqI=-perfqI  if perfqC==-1 & perfqI>0 & perfqI!=.;
replace perfqJ=-perfqJ  if Q1perfqD==-1  & perfqJ>0 & perfqJ!=.;
replace Q1perfqK=-Q1perfqK      if Q1perfqE==-1 & Q1perfqK>0    & Q1perfqK!=.;

replace Q1perfqR=-Q1perfqR      if Q1perfqM==-1 & Q1perfqR>0 & Q1perfqR!=.;
replace Q1perfqS=-Q1perfqS      if Q1perfqN==-1 & Q1perfqS>0 & Q1perfqS!=.;
replace Q1perfqT=-Q1perfqT      if Q1perfqO==-1 & Q1perfqT>0 & Q1perfqT!=.;
replace Q1perfqU=-Q1perfqU      if Q1perfqP==-1 & Q1perfqU>0 & Q1perfqU!=.;
replace Q1perfqV=-Q1perfqV      if Q1perfqQ==-1 & Q1perfqV>0 & Q1perfqV!=.;

*************SALES;

        gen Q2_3sales_per=.;
ren Q51a        sales_cat;

*************FIXED ASSETS;

        gen Q2_3fixed_assts_per=.;
ren Q51b        fixed_assts_cat;

*************DEBTS;

ren     Q51c    Q1debts_val;
        gen Q2debts_per=.;
        gen Q2debts_perR=.;

*************PROFITS;

        gen Q2gr_prfts=.;
        gen Q2gr_prftsR=.;
        gen Q2_3prfts_invst_cat=.;
        gen Q3no_prfts=.;       
        gen Q3prfts_invst_per=.;

**************FIRM INITIATIVE;

ren Q54Dev      initiativeqA;
ren Q54Upg      initiativeqB;
ren Q54Dis      initiativeqC;
ren Q54Joi      initiativeqD;
ren Q54Lic      initiativeqE;
ren Q54Out      initiativeqF;
        gen Q2_3initiativeqG=.;
ren Q54Qua      initiativeqH;
ren Q54Ope      Q1_2initiativeqI;
ren Q54Clo      Q1_2initiativeqJ;
        gen Q2initiativeqK=.;
ren Q54Red      Q1initiativeqL;
ren Q54Inc      Q1initiativeqM;
ren Q54Sup      initiativeqN;
ren Q54Cus      initiativeqO;
ren Q54Exp      initiativeqP;
ren Q54Ban      Q1initiativeqQ;
ren Q54Non      initiativeqR;


****************DEPARTMENT ORGANIZATION;

ren Q58 org;

******************NEW PRODUCTS DEVELOPMENT;

ren Q63Dom      new_prdctqA;
ren Q63For      new_prdctqB;
ren Q63Cus      new_prdctqC;
ren Q63Cre      Q1_2new_prdctqD;
ren Q63Sha      Q1_2new_prdctqE;
ren Q63Gov      Q1_2new_prdctqF;

*****************REDUCING COSTS;

ren Q64Dom      reduc_costqA;
ren Q64For      reduc_costqB;
ren Q64Cus      reduc_costqC;
ren Q64Cre      Q1_2reduc_costqD;
ren Q64Sha      Q1_2reduc_costqE;
ren Q64Gov      Q1_2reduc_costqF;
        
*****************CAPACITY UTILISATION;

gen Q2_3cap_utl=.;
        gen Q2_3cap_utlR=.;

********************EMPLOYMENT;

        gen Q2_3perm_full_emp=.;
        gen Q2_3perm_full_empR=.;
        gen Q2_3part_tm_emp=.;
        gen Q2_3part_tm_empR=.;
        gen Q2_3ft_wrk_catqA=.;
        gen Q2_3ft_wrk_catqB=.;
        gen Q2_3ft_wrk_catqC=.;
        gen Q2_3ft_wrk_catqD=.;
        gen Q2_3ft_wrk_catqE=.;
        gen Q3ft_wrk_catRqA=.;
        gen Q3ft_wrk_catRqB=.;
        gen Q3ft_wrk_catRqC=.;
        gen Q3ft_wrk_catRqD=.;
        gen Q3ft_wrk_catRqE=.;
        
************EDUCATION LABOR FORCE;

gen Q2edu_lbrqA1=.;
gen Q2edu_lbrqA2=.;
gen Q2_3edu_lbrqA=.;
gen Q2_3edu_lbrqB=.;
gen Q2_3edu_lbrqC=.;
gen Q2edu_lbrqD1=.;
gen Q2edu_lbrqD2=.;
gen Q2_3edu_lbrqD=.;

        gen Q3edu_lbrRqA=.;
        gen Q3edu_lbrRqB=.;
        gen Q3edu_lbrRqC=.;
        gen Q3edu_lbrRqD=.;

**************TIME LOST;

        gen Q2_3time_vacqA=.;
        gen Q2_3time_vacqB=.;
        gen Q2_3time_vacqC=.;
        gen Q2_3time_vacqD=.;
        gen Q2_3time_vacqE=.;

****************TRAINING;

        gen Q2trainingqA1=.;
        gen Q2trainingqA2=.;
        gen Q2_3trainingqA=.;
        gen Q2_3trainingqB=.;
        gen Q2_3trainingqC=.;
        gen Q2trainingqD=.;

        gen Q2per_trainedqA1=.;
        gen Q2per_trainedqA2=.;
        gen Q2_3per_trainedqA=.;
        gen Q2_3per_trainedqB=.;
        gen Q2_3per_trainedqC=.;
        gen Q2per_trainedqD=.;

************STRIKE, UNREST;

        gen Q2_3days_lostqA=.;
        gen Q2_3days_lostqB=.;


********** HYPOTHETICAL QUESTION ON WORK FORCE;


ren Q52a        Q1wkfc_levelqA;
ren Q52b        Q1wkfcq_levelqB;
        gen Q2_3chg_wkfc=.;


/* UNOFFICIAL PAYMENTS and CAPTURE*/;

gen pay_perc_sales=Q27;

gen perc_cntr_val=Q30;

gen pay_impctqA=Q68Par;
        replace pay_impctqA=0 if Q68Par==1;
        replace pay_impctqA=1 if Q68Par==2;
gen pay_impctqB=Q68Pre;
        replace pay_impctqB=0 if Q68Pre==1;
        replace pay_impctqB=1 if Q68Pre==2;
        gen     Q3pay_impctqBloc=.;
gen Q1_2pay_impctqC=Q68Cri;
        replace Q1_2pay_impctqC=0 if Q68Cri==1;
        replace Q1_2pay_impctqC=1 if Q68Cri==2;
gen Q1_2pay_impctqD=Q68Arb;
        replace Q1_2pay_impctqD=0 if Q68Arb==1;
        replace Q1_2pay_impctqD=1 if Q68Arb==2;
gen Q1_2pay_impctqE=Q68Cen;
        replace Q1_2pay_impctqE=0 if Q68Cen==1;
        replace Q1_2pay_impctqE=1 if Q68Cen==2;
gen Q1_2pay_impctqF=Q68Con;
        replace Q1_2pay_impctqF=0 if Q68Con==1;
        replace Q1_2pay_impctqF=0 if Q68Con==2;
gen Q1pay_impctqG=Q68Bri;
        replace Q1pay_impctqG=0 if Q68Bri==1;
        replace Q1pay_impctqG=1 if Q68Bri==2;
gen Q1pay_impctqH=Q68Pat;
        replace Q1pay_impctqH=0 if Q68Pat==1;
        replace Q1pay_impctqH=1 if Q68Pat==2;

/*VALUE ADDED
the Q3val_add variable is computed as sales-matrial inputs-total energy and fuel
the Q3val_add1 variable is computed as sales-estimating of opearating costs+total labor cost
the two variables do differ
amended 12/10/2006 mats is materials; matsp is materials as percentage of sales*/

gen Q3val_add=.;
gen Q3val_add1=.;
gen mats =.;
gen matsp=.;

/*SALES PER WORKER*/

gen Q2_3salesonemp=.;

/*REASON NOT IN THE PANEL*/

gen Q2reason05=.;

/*PERCENTAGE OF SALES REPORTED TO THE TAX AUTHORITIES*/

gen perc_sales_tax=Q48a;

/*PERMISSION TO INCLUDE IN THE DATABASE FOR FUTURE INTERVIEW*/

gen Q2_3permis=.;



****************************
Alex C. added variables
****************************;
gen     Q2_3exp_delays_av=.;
gen     Q2_3exp_delays_max=.;
        
gen     Q2_3custm_dly_max=.;
        
gen     Q3hrs_inf_dfcA=.;
gen     Q3hrs_inf_dfcB=.;
gen     Q3hrs_inf_dfcC=.;
        
gen     Q3loss_inf_dfcA=.;
gen     Q3loss_inf_dfcB=.;
gen     Q3loss_inf_dfcC=.;
        
gen     Q3shipm_lossA=.;
gen     Q3shipm_lossB=.;
        
gen     Q3overdue_cases=.;
gen     Q3no_court_act=.;
        
gen     Q2_3perc_court_act=.;
        
gen     Q3pay_scrty_value=.;
        
gen     Q3insp_tax=.;
gen     Q3insp_labr=.;
gen     Q3insp_fire=.;
gen     Q3insp_sanit=.;
gen     Q3insp_polic=.;
gen     Q3insp_envir=.;
gen     Q3insp_cust=.;
        
gen     Q3insp_tax_no=.;
gen     Q3insp_labr_no=.;
gen     Q3insp_fire_no=.;
gen     Q3insp_sanit_no=.;
gen     Q3insp_polic_no=.;
gen     Q3insp_envir_no=.;
gen     Q3insp_cust_no=.;
        
gen     Q3insp_tax_dur=.;
gen     Q3insp_labr_dur=.;
gen     Q3insp_fire_dur=.;
gen     Q3insp_sanit_dur=.;
gen     Q3insp_polic_dur=.;
gen     Q3insp_envir_dur=.;
gen     Q3insp_cust_dur=.;

save data/temp99, replace;
compress;

***********************************************************************************
2002
***********************************************************************************;

use data/cleaned2002.dta, clear;

gen year=2002;
ren serial      serialno;


************************************************************************
PROCEDURES FOR THE CREATION OF THE FILE WITH ONLY MISSING AND WITHOUT 
DO NOT KNOW AND NOT APPLICABLE CODES (e.g. no -9997 in the variables, see Alex Muravyev cleaning note)
************************************************************************;

sort year serialno;

foreach var of varlist * {;
replace `var'=. if  `var'==-9995 | `var'==-9996 | `var'==-9997 | `var'==-9998 | `var'==-9999;
};

foreach var of varlist * {;
tabstat `var', by(year) stats(mean min max range sd n); 
}
;

******************************************************************************
******************************************************************************;

gen man_over=.;

gen Q3panel=.;

ren card        cardno;
*ren country    country;
ren yugo        Q2_3yugo;
ren city        citytown;
        gen Q3region=.;
        gen Q3srl_no2002=.;
ren s1a start;

ren s2a legstqA;


ren s2b legstqB;


ren s3  ind;

ren s3a1        Q2_3main_prdc;
gen full_empqA=s4a1;

replace full_empqA=6 if s4a1==7;

drop s4a1;


ren s4a2        full_empqB ;
gen Q1full_empqC=.     ;

        gen Q1ownedqA=.;
ren s4c1        ownedqB;
ren s4c2        Q2_3ownedqC;
        gen Q1ownedqD=.;
ren s4c3        ownedqE;
ren s4c4        Q2_3ownedqF;

ren s7a natl_forgnqA;
ren s7b natl_forgnqB;

ren s10 sell_out;

ren s11 exp_prc_sales;

ren s13b        Q2_3plants;
ren s13c        ops_abro;

ren q1  job_titleqA;
        gen job_titleqB=.;
        gen job_titleqC=.;
        gen job_titleqD=.;
        gen job_titleqE=.;
        gen job_titleqF=.;
        gen job_titleqG=.;
        gen job_titleqH=.;
        gen job_titleqI=.;
        gen job_titleqJ=.;

ren q2a Q2_3sale_sctrqA;
ren q2b Q2_3sale_sctrqB;
ren q2c Q2_3sale_sctrqC;
ren q2d Q2_3sale_sctrqD;
ren q2e Q2_3sale_sctrqE;
ren q2f Q2_3sale_sctrqF;
ren q2g Q2_3sale_sctrqG;
ren q2h Q2_3sale_sctrqH;

gen owner=q4a_r1;
replace owner=4 if q4a_r1==3;
replace owner=5 if q4a_r1==4;
replace owner=6 if q4a_r1==5;
replace owner=6 if q4a_r1==6;
replace owner=8 if q4a_r1==7;
replace owner=9 if q4a_r1==8;
replace owner=10 if q4a_r1==9;
replace owner=11 if q4a_r1==10;
replace owner=11 if q4a_r1==11;
drop q4a_r1;


gen estb=q9aa;
        replace estb=7 if q9aa==. & legstqB==2;

ren     q15a    Q2_3custqA;
ren     q15b    Q2_3custqB;
ren     q15c    Q2_3custqC;
ren     q15d    Q2_3custqD;
        gen  Q3custqE1=.;
        gen  Q3custqE2=.;
        gen  Q3custqE3=.;
ren     q15e    Q2_3custqE;


ren     q9a     Q2_3priv        ;
        
ren q19 Q2_3imp_cmpt;

ren q21 compt;

ren q18a        comps;
ren q18b        Q2_3ex_comps_ntl;
        gen Q3compsR=.;
        gen Q3ex_comps_ntlR=. ;
        gen Q3c_local=.;
        gen Q3comps_local=.;
        gen Q3comps_localR=.;
        gen Q3ex_comps_loc=.;
        gen Q3ex_comps_locR=. ;
        gen exnocomR=. ;

/* COMPETITION BASED ON THE NUMBER OF COMPETITORS*/

gen nocomp=comps;
gen nocompR=Q3compsR;

ren q22b        Q1_2mkt_salesqA;
        gen Q1_2mkt_salesqB=.;
ren q23 markupqA;
        
ren q24a        Q2_3inputqA;
ren q24b        Q2_3inputqB;
ren q24c        Q2_3inputqC;
ren q25a        custm_dly;
ren q30a        Q2_3suppl_prc;
ren q33a        Q2_3dys_inf_dfcqA;
ren q33b        Q2_3dys_inf_dfcqB;
ren q33c        Q2_3dys_inf_dfcqC;
ren q38a        Q2_3int_clntsqA;
ren q38b        Q2_3int_clntsqB;
ren q38c        Q2_3int_clntsqC;
ren q38d        Q2_3int_clntsqD;
ren q38e        Q2_3int_clntsqE;
ren q40a        Q2_3dys_dly_srvcqA;
ren q40b        Q2_3dys_dly_srvcqB;

ren q41a        court_sys_prcptqA;
ren q41b        court_sys_prcptqB;
ren q41c        court_sys_prcptqC;
ren q41d        court_sys_prcptqD;
ren q41e        court_sys_prcptqE;
        gen Q1court_sys_prcptqF=.;

ren q42 conf_lgl_systm;
        gen Q1conf_lgl_systmR=.;

gen     Q2_3sale_prpaid=q43a;
ren q43b        Q2_3sal_cred;
ren q43b1       Q2_3ovrdue_pymnt;
ren q43c        Q2_3days_rslv_pymnt;
ren q44a1       Q2_3pay_scrtyqA;
ren q44b1       Q2_3pay_scrtyqB;
ren q44a2       Q2_3pay_prtctnqA;
ren q44b2       Q2_3pay_prtctnqB;
ren q45a        Q2_3lossesqA;
ren q45b        Q2_3lossesqB;
ren q46a        info_laws;
ren q46b        intrp_laws;
        gen Q1intrp_lawsR=.;
ren q49 Q1_2prdc_law;

/*CAPTURING VARIABLES*/

        gen time_pub_off_cat=q50;
replace time_pub_off_cat=1 if q50>=0 & q50<=1;
replace time_pub_off_cat=2 if q50>1 & q50<=5;
replace time_pub_off_cat=3 if q50>5 & q50<=10;
replace time_pub_off_cat=4 if q50>10 & q50<=25;
replace time_pub_off_cat=5 if q50>25 & q50<=50;
replace time_pub_off_cat=6 if q50>50 & q50!=.;
ren q50 Q2_3time_pub_off_prc;
ren q51 unoff_pay;
ren q51a        memb_lobby;
ren q54a        add_pay;
ren q54b        know_add_pay;
ren q56a        pay_reasonqA;
ren q56b        pay_reasonqB;
ren q56c        pay_reasonqC;
ren q56d        Q2_3pay_reasonqD;
ren q56e        Q2_3pay_reasonqE;
ren q56f        Q2_3pay_reasonqF;
ren q56g        pay_reasonqG;
ren q56h        pay_reasonqH;
ren q56i        pay_reasonqI;
ren q56j        pay_reasonqJ;
        gen pay_reasonqK=.;

gen counter=0;
gen counter1=0;
gen counter2=0;
gen summ1=0;
foreach var of varlist
Q2_3pay_reasonqD        
Q2_3pay_reasonqE        
Q2_3pay_reasonqF

{;
replace counter=counter+1 if `var'>0 & `var'~=.;
replace summ1=summ1+`var' if `var'>=0 & `var'~=.;
replace counter1=counter1+1;
replace counter2=counter2+1 if  `var'==.;
};
replace pay_reasonqK=summ1/counter ;
replace pay_reasonqK=. if counter1==counter2;
drop 
counter
counter1
counter2
summ1;

/*EFFECT OF CAPTURE*/

ren q59a        pay_impctqA;
ren q59b        pay_impctqB;
        gen     Q3pay_impctqBloc=.;
ren q59c        Q1_2pay_impctqC;
ren q59d        Q1_2pay_impctqD;
ren q59e        Q1_2pay_impctqE;
ren q59f        Q1_2pay_impctqF;
        gen     Q1pay_impctqG=.;
        gen     Q1pay_impctqH=.;

ren q64a1       Q2_3source_fin_capqA;
ren q64a2       Q2_3source_fin_capqB;
ren q64a3       Q2_3source_fin_capqC;
ren q64a4       Q2_3source_fin_capqD;
ren q64a5       Q2_3source_fin_capqE;
ren q64a6       Q2_3source_fin_capqF;
ren q64a7       Q2_3source_fin_capqG;
ren q64a8       Q2_3source_fin_capqH;
ren q64a9       Q2_3source_fin_capqI;
ren q64a10      Q2_3source_fin_capqJ;
ren q64a11      Q2_3source_fin_capqK;
ren q64a12      Q2_3source_fin_capqL;
ren q64a13      Q2_3source_fin_capqM;
ren q64a14      Q2_3source_fin_capqN;

ren q64b1               source_fin_invqA;
ren q64b2               source_fin_invqB;
ren q64b3               source_fin_invqC;
ren q64b5               source_fin_invqD;
ren q64b4               Q2_3source_fin_invqE;
ren q64b6               source_fin_invqF;
ren q64b7               source_fin_invqG;
ren q64b8               source_fin_invqH;
ren q64b9               Q2_3source_fin_invqI;
ren q64b10      Q2_3source_fin_invqJ;
ren q64b11      source_fin_invqK;
ren q64b12      source_fin_invqL;
ren q64b13      source_fin_invqM;
ren q64b14      source_fin_invqN;
        gen Q1source_fin_invqO=.;

ren q65a        Q2_3cltrl_loan;
ren q65c        Q2_3val_cltrl;
ren q65d        Q2_3loan_cost;
ren q65e        Q2_3loan_drtn;
ren q65f        Q2_3days_get_loan;
ren q73 ias;
ren q74 extrnl_adtr;
ren q75a2       Q1_2days_trans_domqA;
        
        gen Q1days_trans_domRqA=.;
        
ren q75a3       Q1_2days_trans_frgnqA;
        
        gen Q1days_trans_frgnRqA=.;
        
gen     sales_bartrqA=q76a;
gen     sales_bartrqB=q76b;
gen     sales_bartrqC=q76c;
gen     sales_bartrqD=q76d;
gen     sales_bartrqE=q76e;
        gen sales_bartrqF=.;
gen     Q2_3purchs_bartrqA=q77a;
gen     Q2_3purchs_bartrqB=q77b;
gen     Q2_3purchs_bartrqC=q77c;
gen     Q2_3purchs_bartrqD=q77d;
gen     Q2_3purchs_bartrqE=q77e;
        gen Q2_3purchs_bartrqF=.;
ren q78a1       Q2_3ovrd_pymt_ctgqA;
ren q78a2       Q2_3ovrd_pymt_ctgqB;
ren q78a3       Q2_3ovrd_pymt_ctgqC;
ren q78a4       Q2_3ovrd_pymt_ctgqD;

ren q78b1       Q2_3ovrd_pymt_perqA;
ren q78b2       Q2_3ovrd_pymt_perqB;
ren q78b3       Q2_3ovrd_pymt_perqC;
ren q78b4       Q2_3ovrd_pymt_perqD;

gen     Q2_3subsdsqA1=q79a1;
gen     Q2_3subsdsqA2=q79a2;
        gen Q3subsdsqB=.;
gen     Q2_3subsdsqC=q79a3;
        gen subsdsqA=.;
replace  subsdsqA=1 if (Q2_3subsdsqA1==1 | Q2_3subsdsqA2==1);
replace  subsdsqA=2 if (Q2_3subsdsqA1==2 & Q2_3subsdsqA2==2);
        gen Q1subsdsR=.;

gen     Q2_3sub_perc_slsqA=q79b1;
gen     Q2_3sub_perc_slsqB=q79b2;
gen     Q2_3sub_perc_slsqC=q79b3;
        gen Q2_3sub_perc_slsqD=.;

**************BUSINESS ENVIRONMENT;

        gen Q1constrqA1=.;
        gen Q1constrqA2=.;
        gen Q1constrqA3=.;
        gen Q1constrqA4=.;
        gen Q1constrqA5=.;
        gen Q1constrqA6=.;
        gen Q1constrqA7=.;
        gen Q1constrqA8=.;
        gen Q1constrqA9=.;
ren q80a        constrqA;
        gen Q1constrqB1=.;
        gen Q1constrqB2=.;
        gen Q1constrqB3=.;
ren q80b        constrqB;
ren q80c        Q2_3constrqC1;
ren q80d        Q2_3constrqC2;
ren q80e        Q2_3constrqC3;
ren q80f        Q2_3constrqC4;
ren q80u        Q2_3constrqC5;
        gen constrqC=.;

gen counter=0;
gen counter1=0;
gen counter2=0;
gen summ1=0;
foreach var of varlist
Q2_3constrqC1   
Q2_3constrqC2   
Q2_3constrqC3
Q2_3constrqC4   
Q2_3constrqC5
        
{;
replace counter=counter+1 if `var'>0 & `var'~=.;
replace summ1=summ1+`var' if `var'>=0 & `var'~=.;
replace counter1=counter1+1;
replace counter2=counter2+1 if  `var'==.;
};
replace constrqC=summ1/counter ;
replace constrqC=. if counter1==counter2;
drop 
counter
counter1
counter2
summ1;


ren q80g        constrqD;
ren q80h        constrqE;
        
        
ren q80i        constrqF;
        gen Q1constrqG1=.;
        gen Q1constrqG2=.;
        gen Q1constrqG3=.;
ren q80j        constrqG;
ren q80k        constrqH;
ren q80l        Q2_3constrqI;
ren q80m        constrqJ;
        gen Q1constrqK1=.;
        gen Q1constrqK2=.;
ren q80n        constrqK;
ren q80o        constrqL;
ren q80p        constrqM;
ren q80q        constrqN;
ren q80r        constrqO;
ren q80s        constrqP;
ren q80t        Q2_3constrqQ;

ren q80v        Q1_3constrqR;

gen Q1constrqS=.;

gen constrqALL15=.;
gen counter=0;
gen counter1=0;
gen counter2=0;
gen summ1=0;
foreach var of varlist  

constrqA
constrqB
constrqC
constrqD
constrqE
constrqF
constrqG
constrqH
constrqJ
constrqK
constrqL
constrqM
constrqN
constrqO
constrqP

{;
replace counter=counter+1 if `var'>0 & `var'~=.;
replace summ1=summ1+`var' if `var'>=0 & `var'~=.;
replace counter1=counter1+1;
replace counter2=counter2+1 if  `var'==.;
};
replace constrqALL15=summ1/counter ;
replace constrqALL15=. if counter1==counter2;
drop 
counter
counter1
counter2
summ1;

/*PERFORMANCE*/

ren q81a1       perfqA;
ren q81a3       perfqB;
ren q81a2       perfqC;
        gen Q1perfqD=.;
        gen Q1perfqE=.;
        gen Q3perfqF=.;
ren q81b1       perfqG;
ren q81b3       perfqH;
ren q81b2       perfqI;
        
        gen Q1perfqK=.;
        gen Q3perfqL=.;
        gen Q1perfqM=.;
        gen Q1perfqN=.;
        gen Q1perfqO=.;
        gen Q1perfqP=.;
        gen Q1perfqQ=.;
        gen Q1perfqR=.;
        gen Q1perfqS=.;
        gen Q1perfqT=.;
        gen Q1perfqU=.;
        gen Q1perfqV=.;

replace perfqA=-1 if perfqA==2;
replace perfqA=0 if perfqA==3;
*replace perfqA=1 if perfqA==1;

replace perfqB=-1 if perfqB==2;
replace perfqB=0 if perfqB==3;
*replace perfqB=1 if perfqB==1;

replace perfqC=-1 if perfqC==2;
replace perfqC=0 if perfqC==3;
*replace perfqC=1 if perfqC==1;

replace perfqG=-perfqG  if perfqA==-1 & perfqG>0 & perfqG!=.;
replace perfqH=-perfqH  if perfqB==-1 & perfqH>0 & perfqH!=.;
replace perfqI=-perfqI  if perfqC==-1 & perfqI>0 & perfqI!=.;

*******************SALES;
        
ren     q82a    Q2_3sales_per;
                gen sales_cat=Q2_3sales_per;
replace         sales_cat=1 if Q2_3sales_per>=0 & Q2_3sales_per<250;
replace         sales_cat=2 if Q2_3sales_per>=250 & Q2_3sales_per<500;
replace         sales_cat=3 if Q2_3sales_per>=500 & Q2_3sales_per<1000;
replace         sales_cat=4 if Q2_3sales_per>=1000 & Q2_3sales_per<2000;
replace         sales_cat=5 if Q2_3sales_per>=2000 & Q2_3sales_per<5000;
replace         sales_cat=6 if Q2_3sales_per>=5000 & Q2_3sales_per<10000;
replace         sales_cat=7 if Q2_3sales_per>=10000 & Q2_3sales_per<20000;
replace         sales_cat=8 if Q2_3sales_per>=20000 & Q2_3sales_per<50000;
replace         sales_cat=9 if Q2_3sales_per>=50000 & Q2_3sales_per<500000;
replace         sales_cat=11 if Q2_3sales_per>=500000 & Q2_3sales_per!=.;


********************FIXED ASSETS;

ren q82b        Q2_3fixed_assts_per;
        gen     fixed_assts_cat=Q2_3fixed_assts_per;

replace         fixed_assts_cat=1 if Q2_3fixed_assts_per>=0 & Q2_3fixed_assts_per<250;
replace         fixed_assts_cat=2 if Q2_3fixed_assts_per>=250 & Q2_3fixed_assts_per<500;
replace         fixed_assts_cat=3 if Q2_3fixed_assts_per>=500 & Q2_3fixed_assts_per<1000;
replace         fixed_assts_cat=4 if Q2_3fixed_assts_per>=1000 & Q2_3fixed_assts_per<2000;
replace         fixed_assts_cat=5 if Q2_3fixed_assts_per>=2000 & Q2_3fixed_assts_per<5000;
replace         fixed_assts_cat=6 if Q2_3fixed_assts_per>=5000 & Q2_3fixed_assts_per<10000;
replace         fixed_assts_cat=7 if Q2_3fixed_assts_per>=10000 & Q2_3fixed_assts_per<20000;
replace         fixed_assts_cat=8 if Q2_3fixed_assts_per>=20000 & Q2_3fixed_assts_per<50000;
replace         fixed_assts_cat=9 if Q2_3fixed_assts_per>=50000 & Q2_3fixed_assts_per<500000;
replace         fixed_assts_cat=11 if Q2_3fixed_assts_per>=500000 & Q2_3fixed_assts_per!=.;

********************DEBTS;

        gen     Q1debts_val=. ;
ren q84a1       Q2debts_per;
ren q84a2       Q2debts_perR;

********************PROFITS;

ren q84a1a      Q2gr_prfts;
ren q84a1b      Q2gr_prftsR;
ren q84b        Q2_3prfts_invst_cat;
        gen Q3no_prfts=.;
        gen Q3prfts_invst_per=.;


*************FIRM INITIATIVE;

ren q85a1       initiativeqA;
ren q85a2       initiativeqB;
ren q85a4       initiativeqC;
ren q85a7       initiativeqD;
ren q85a8       initiativeqE;
ren q85a9       initiativeqF;
ren q85a10      Q2_3initiativeqG;
ren q85a11      initiativeqH;
ren q85a5       Q1_2initiativeqI;
ren q85a6       Q1_2initiativeqJ;
ren q85a3       Q2initiativeqK;
        gen Q1initiativeqL=.;
        gen Q1initiativeqM=.;
ren q32a1 initiativeqN;
ren q32a2 initiativeqO;
ren q32a3 initiativeqP;
        gen Q1initiativeqQ=.;
        gen initiativeqR=.;

replace initiativeqA=0 if       initiativeqA==2;
replace initiativeqB=0 if       initiativeqB==2;
replace initiativeqC=0 if       initiativeqC==2;
replace initiativeqD=0 if       initiativeqD==2;
replace initiativeqE=0 if       initiativeqE==2;
replace initiativeqF=0 if       initiativeqF==2;
replace Q2_3initiativeqG=0 if   Q2_3initiativeqG==2;
replace initiativeqH=0 if       initiativeqH==2;
replace Q1_2initiativeqI=0 if   Q1_2initiativeqI==2;
replace Q1_2initiativeqJ=0 if   Q1_2initiativeqJ==2;
replace Q2initiativeqK=0 if     Q2initiativeqK==2;
replace initiativeqN=0 if       initiativeqN==2;
replace initiativeqO=0 if       initiativeqO==2;
replace initiativeqP=0 if       initiativeqP==2;

replace initiativeqR=1 if 

initiativeqA==0 &
initiativeqB==0 &
initiativeqC==0 &
initiativeqD==0 &
initiativeqE==0 &
initiativeqF==0 &
Q2_3initiativeqG==0 &
initiativeqH==0 &
Q1_2initiativeqI==0 &
Q1_2initiativeqJ==0 &
Q2initiativeqK==0 &
initiativeqN==0 &
initiativeqO==0 &
initiativeqP==0 ;

replace initiativeqR=0 if initiativeqR==.;

replace initiativeqR=. if

initiativeqA==. &
initiativeqB==. &
initiativeqC==. &
initiativeqD==. &
initiativeqE==. &
initiativeqF==. &
Q2_3initiativeqG==. &
initiativeqH==. &
Q1_2initiativeqI==. &
Q1_2initiativeqJ==. &
Q2initiativeqK==. &
initiativeqN==. &
initiativeqO==. &
initiativeqP==.;

******************DEPARTMENT ORGANISATION;

ren q87 org;

*********************NEW PRODUCTS;

ren q88a        new_prdctqA;
ren q88b        new_prdctqB;
ren q88c        new_prdctqC;
ren q88d        Q1_2new_prdctqD;
ren q88e        Q1_2new_prdctqE;
ren q88f        Q1_2new_prdctqF;

*********************REDUCING COSTS;

ren q89a        reduc_costqA;
ren q89b        reduc_costqB;
ren q89c        reduc_costqC;
ren q89d        Q1_2reduc_costqD;
ren q89e        Q1_2reduc_costqE;
ren q89f        Q1_2reduc_costqF;

*****************CAPACITY UTILISATION;

ren q90a        Q2_3cap_utl;
ren q90b        Q2_3cap_utlR;


***************EMPLOYMENT and WORKFORCE STRUCTURE;

ren q91a1       Q2_3perm_full_emp;
ren q91a2       Q2_3perm_full_empR;

ren q91b1       Q2_3part_tm_emp;
ren q91b2       Q2_3part_tm_empR;

ren q92a        Q2_3ft_wrk_catqA;
ren q92b        Q2_3ft_wrk_catqB;
ren q92c        Q2_3ft_wrk_catqC;
ren q92d        Q2_3ft_wrk_catqD;
ren q92e        Q2_3ft_wrk_catqE;
        gen Q3ft_wrk_catRqA=.;
        gen Q3ft_wrk_catRqB=.;
        gen Q3ft_wrk_catRqC=.;
        gen Q3ft_wrk_catRqD=.;
        gen Q3ft_wrk_catRqE=.;

*****************EDUCATION LABOR FORCE;


ren q94a        Q2edu_lbrqA1;
ren q94b        Q2edu_lbrqA2;
        gen Q2_3edu_lbrqA=.;
        replace  Q2_3edu_lbrqA=Q2edu_lbrqA1 if
        Q2edu_lbrqA1!=.;
        replace  Q2_3edu_lbrqA=Q2edu_lbrqA1+Q2edu_lbrqA2
        if Q2edu_lbrqA2!=.;

ren q94c        Q2_3edu_lbrqB;
ren q94d        Q2_3edu_lbrqC;
ren q94e        Q2edu_lbrqD1;
ren q94f        Q2edu_lbrqD2;
        gen   Q2_3edu_lbrqD=.;
        replace  Q2_3edu_lbrqD=Q2edu_lbrqD1 if
        Q2edu_lbrqD1!=.;
        replace  Q2_3edu_lbrqD=Q2edu_lbrqD1+Q2edu_lbrqD2
        if Q2edu_lbrqD2!=.;



************EDUCATION LABOR FORCE IN THE PAST

        gen Q3edu_lbrRqA=.;
        gen Q3edu_lbrRqB=.;
        gen Q3edu_lbrRqC=.;
        gen Q3edu_lbrRqD=.;

************TIME LOST IN FILLING VACANCIES;


ren q95a        Q2_3time_vacqA;
ren q95b        Q2_3time_vacqB;
ren q95c        Q2_3time_vacqC;
ren q95d        Q2_3time_vacqD;
ren q95e        Q2_3time_vacqE;

**************TRAINING;

ren q96a1       Q2trainingqA1;
ren q96a2       Q2trainingqA2;
        gen     Q2_3trainingqA=.;
        replace  Q2_3trainingqA=Q2trainingqA1 if
        (Q2trainingqA1!=. & Q2trainingqA1!=.);
        replace  Q2_3trainingqA=Q2trainingqA1+Q2trainingqA2
        if Q2trainingqA2!=. & Q2trainingqA2!=. ;

ren q96a3       Q2_3trainingqB;
ren q96a4       Q2_3trainingqC;
ren q96a5       Q2trainingqD;

ren q96b1       Q2per_trainedqA1;
ren q96b2       Q2per_trainedqA2;
        gen     Q2_3per_trainedqA=.;
        replace  Q2_3per_trainedqA=Q2per_trainedqA1 if
        Q2per_trainedqA1!=. & Q2per_trainedqA1!=.;
        replace  Q2_3per_trainedqA=Q2per_trainedqA1+Q2per_trainedqA2
        if Q2per_trainedqA2!=. & Q2per_trainedqA2!=. ;

ren q96b3       Q2_3per_trainedqB;
ren q96b4       Q2_3per_trainedqC;
ren q96b5       Q2per_trainedqD;


***********STRIKE, UNREST;

ren q97a        Q2_3days_lostqA;
ren q97b        Q2_3days_lostqB;

*******HYPOTHETICAL CHANGE WORKFORCE QUESTION;
        gen Q1wkfc_levelqA=.;
        gen Q1wkfc_levelqB=.;
ren q98 Q2_3chg_wkfc;
        

*******LAW AND REGULATIONS, UNOFFICIAL PAYMENTS;

* Q51 *;
gen Q2_3serv_ass1=q51b1;
gen Q2_3serv_ass2=q51b2;
gen Q2_3serv_ass3=q51b3;
gen Q2_3serv_ass4=q51b4;
gen Q2_3serv_ass5=q51b5;
gen Q2_3serv_ass6=q51b6;


* Q52 *;
gen Q2_3seek_infl=.;
replace Q2_3seek_infl=1 if q52==1;
replace Q2_3seek_infl=2 if q52==2;


/* old code of alex for Q59 
gen parl_pay=q59a;
gen Q2_3gov_offic=q59b;
gen Q1_2crim_crt=q59c;
gen Q1_2arb_crt=q59d;
gen Q1_2contrib=q59f;
gen Q2cbank_pay=q59e*/

* Q57 *;
gen perc_cntr_val=.;
replace perc_cntr_val=1 if q57==0;
replace perc_cntr_val=2 if q57>0 & q57<6;
replace perc_cntr_val=3 if q57>=6 & q57<11;
replace perc_cntr_val=4 if q57>=11 & q57<16;
replace perc_cntr_val=5 if q57>=16 & q57<20;
replace perc_cntr_val=6 if q57>=20 & q57~=.;

gen Q2_3perc_cntr_val_prc=q57;

* Q55 *;
gen pay_perc_sales=.;
replace pay_perc_sales=1 if q55==0;
replace pay_perc_sales=2 if q55>0 & q55<1;
replace pay_perc_sales=3 if q55>=1 & q55<2;
replace pay_perc_sales=4 if q55>=2 & q55<10;
replace pay_perc_sales=5 if q55>=10 & q55<13;
replace pay_perc_sales=6 if q55>=13 & q55<25;
replace pay_perc_sales=7 if q55>=25 & q55~=.;
gen Q2_3pay_perc_sales_prc=q55;

/*VALUE ADDED
the Q3val_add variable is computed as sales - material inputs - total energy and fuel
the Q3val_add1 variable is computed as sales - operating costs + total labor costs
the two variables do differ
amended 12/10/2006 mats is materials; matsp is materials as a percentage of sales */

gen Q3val_add=.;
gen Q3val_add1=.;
gen mats =.;
ren q83d matsp;

*SALES PER WORKER*;

gen Q2_3salesonemp=Q2_3sales_per/Q2_3perm_full_emp;

*REASON NOT IN THE PANEL*;

ren reason05 Q2reason05;

*PERCENTAGE OF SALES REPORTED TO THE TAX AUTHORITIES*;

gen perc_sales_tax=.;
replace perc_sales_tax=1 if q58==100;
replace perc_sales_tax=2 if q58>90 & q58<100;
replace perc_sales_tax=3 if q58>80 & q58<=90;
replace perc_sales_tax=4 if q58>70 & q58<=80;
replace perc_sales_tax=5 if q58>60 & q58<=70;
replace perc_sales_tax=6 if q58>50 & q58<=60;
replace perc_sales_tax=7 if q58>25 & q58<=50;
replace perc_sales_tax=8 if q58<=25;

*PERMISSION TO INCLUDE IN THE DATABASE FOR FUTURE INTERVIEW*;

ren permis Q2_3permis;


*******************************
Alex C. added variables
*******************************;

rename q14b1 Q2_3exp_delays_av;
rename q14b2 Q2_3exp_delays_max;

rename q25b Q2_3custm_dly_max;

rename q43d Q2_3perc_court_act;



        
gen     Q3hrs_inf_dfcA=.;
gen     Q3hrs_inf_dfcB=.;
gen     Q3hrs_inf_dfcC=.;
        
gen     Q3loss_inf_dfcA=.;
gen     Q3loss_inf_dfcB=.;
gen     Q3loss_inf_dfcC=.;
        
gen     Q3shipm_lossA=.;
gen     Q3shipm_lossB=.;
        
gen     Q3overdue_cases=.;
gen     Q3no_court_act=.;
        
        
gen     Q3pay_scrty_value=.;
        
gen     Q3insp_tax=.;
gen     Q3insp_labr=.;
gen     Q3insp_fire=.;
gen     Q3insp_sanit=.;
gen     Q3insp_polic=.;
gen     Q3insp_envir=.;
gen     Q3insp_cust=.;
        
gen     Q3insp_tax_no=.;
gen     Q3insp_labr_no=.;
gen     Q3insp_fire_no=.;
gen     Q3insp_sanit_no=.;
gen     Q3insp_polic_no=.;
gen     Q3insp_envir_no=.;
gen     Q3insp_cust_no=.;
        
gen     Q3insp_tax_dur=.;
gen     Q3insp_labr_dur=.;
gen     Q3insp_fire_dur=.;
gen     Q3insp_sanit_dur=.;
gen     Q3insp_polic_dur=.;
gen     Q3insp_envir_dur=.;
gen     Q3insp_cust_dur=.;

rename q79a1 Q2_3subsd_nat_gov;
rename q79a2 Q2_3subsd_reg_gov;
rename q79a3 Q2_3subsd_other;

rename q79b1 Q2_3subsd_nat_gov_ps;
rename q79b2 Q2_3subsd_reg_gov_ps;
rename q79b3 Q2_3subsd_other_ps;

rename q65b1 Q2collat_type;

rename q76a Q2_3sales_cash_bank;
rename q76b Q2_3sales_bills;
rename q76c Q2_3sales_offsets;
rename q76d Q2_3sales_bart;
rename q76e Q2_3sales_other;


rename q77a Q2_3purch_cash_bank;
rename q77b Q2_3purch_bills;
rename q77c Q2_3purch_offsets;
rename q77d Q2_3purch_bart;
rename q77e Q2_3purch_other;


gen Q3subsd_EU=.;
gen Q3subsd_EU_ps=. ;
gen Q3gaap=.;
gen Q3nat_acc_stand=.;
gen Q3why_no_loan=.;
gen Q3why_no_appl=.;
gen Q3loan_reject=.;
gen Q3check_sav_acc=.;
gen Q3collat_type=.;
gen Q3loan_curr=. ;



rename q43a Q2_3sal_prpd;
rename q43e1 Q2_3plantiff;
rename q43e2 Q2_3defendant;

gen Q3sal_pd_dlvr=.;
gen Q3ext_cons=.;
gen Q3wrkfrc_decl=.;
gen Q3wage_decl=.;


save data/temp02, replace;
compress;

**************************************************************************************
2005
**************************************************************************************;

use data/cleaned2005.dta, clear;

drop map;
gen year=2005;


************************************************************************
PROCEDURES FOR THE CREATION OF THE FILE WITH ONLY MISSING AND WITHOUT 
DO NOT KNOW AND NOT APPLICABLE CODES (e.g. no -9997 in the variables see alex muravyev note on claening procedure)
************************************************************************;

sort year serialno;

foreach var of varlist * {;
replace `var'=. if  `var'==-9995 | `var'==-9996 | `var'==-9997 | `var'==-9998 | `var'==-9999;
};

foreach var of varlist * {;
tabstat `var', by(year) stats(mean min max range sd n); 
}
;

******************************************************************************
******************************************************************************;

ren table6 man_over;

ren table5 Q3panel;

        gen cardno=.;
ren yugo        Q2_3yugo;
ren city        citytown;
ren regoblas    Q3region;
ren seno2002    Q3srl_no2002;

******************************************************************
ALEX BOSNIA RECOVERY procedure for the panel
******************************************************************;

replace Q3srl_no2002=708 if serialno==6004;
replace Q3srl_no2002=620 if serialno==6211;
replace Q3srl_no2002=645 if serialno==6228;
replace Q3srl_no2002=761 if serialno==6202;
replace Q3srl_no2002=748 if serialno==6011;
replace Q3srl_no2002=751 if serialno==6019;
replace Q3srl_no2002=622 if serialno==6260;
replace Q3srl_no2002=743 if serialno==6059;
replace Q3srl_no2002=745 if serialno==6013;
replace Q3srl_no2002=662 if serialno==6068;
replace Q3srl_no2002=753 if serialno==6018;
replace Q3srl_no2002=731 if serialno==6010;
replace Q3srl_no2002=774 if serialno==6031;
replace Q3srl_no2002=686 if serialno==6014;
replace Q3srl_no2002=681 if serialno==6039;
replace Q3srl_no2002=682 if serialno==6003;

ren s1a start;

ren s2a legstqA;
ren s2b legstqB;

ren s3  ind;
        
ren s3b Q2_3main_prdc;
gen full_empqA=s4a;

replace full_empqA=6 if s4a==7;
drop s4a;

ren s4b full_empqB;

gen     Q1full_empqC=.;

        gen Q1ownedqA=.;
ren s5b ownedqB;
ren s5a Q2_3ownedqC;
        gen Q1ownedqD=.;
ren s5c ownedqE;
ren s5d Q2_3ownedqF;

ren s6a natl_forgnqA;
ren s6b natl_forgnqB;

ren s7  sell_out;
ren s8  exp_prc_sales;

ren s10 Q2_3plants;
ren s11 ops_abro;

ren     q6      Q2_3priv;

ren q1  job_titleqA;
        gen job_titleqB=.;
        gen job_titleqC=.;
        gen job_titleqD=.;
        gen job_titleqE=.;
        gen job_titleqF=.;
        gen job_titleqG=.;
        gen job_titleqH=.;
        gen job_titleqI=.;
        gen job_titleqJ=.;

ren q2a Q2_3sale_sctrqA;
ren q2b Q2_3sale_sctrqB;
ren q2c Q2_3sale_sctrqC;
ren q2d Q2_3sale_sctrqD;
ren q2e Q2_3sale_sctrqE;
ren q2f Q2_3sale_sctrqF;
ren q2g Q2_3sale_sctrqG;
ren q2h Q2_3sale_sctrqH;

ren q4aa_r1     owner;
replace owner=11 if owner==3;
replace owner=6 if owner==7;
 
gen estb=q5a;
        replace estb=7 if q5a==. & legstqB==2;

ren     q9a     Q2_3custqA;
ren     q9c     Q2_3custqB;
ren     q9d     Q2_3custqC;
ren     q9e     Q2_3custqD;

ren     q9b     Q3custqE1;
ren q9f         Q3custqE2;
ren q9g         Q3custqE3;
        gen     Q2_3custqE=Q3custqE1+Q3custqE2+Q3custqE3 if Q3custqE1>=0 & Q3custqE2>=0 & Q3custqE3>=0
                & Q3custqE1!=. & Q3custqE2!=. & Q3custqE3!=.;
ren q10 Q2_3imp_cmpt;

ren q11  compt;
ren q12a comp_nat;
replace comp_nat = 0 if comp_nat == 2;

ren q12ba        comps;
ren q12ca        Q2_3ex_comps_ntl;
ren q12bb  Q3compsR;
ren q12cb  Q3ex_comps_ntlR;
ren q13a   Q3c_local;
ren q13ba  Q3comps_local;
ren q13bb  Q3comps_localR;
ren q13ca  Q3ex_comps_loc;
ren q13cb  Q3ex_comps_locR ;

/* COMPETITION BASED ON THE NUMBER OF COMPETITORS */

gen nocomp=.;

/* no competitors on both markets */
replace nocomp=1 if comps==1 & Q3comps_local==1;
replace nocomp=1 if comps==. & Q3comps_local==1;
replace nocomp=1 if comps==1 & Q3c_local==2;

/* many competitors */
replace nocomp=3 if (comps==3 | Q3comps_local==3);
gen exnocom=Q2_3ex_comps_ntl+Q3ex_comps_loc;
replace nocomp=3 if exnocom>3 & exnocom~=.;

/* 1-3 competitors */
replace nocomp=2 if (comps==1 & Q3comps_local==2);
replace nocomp=2 if (comps==2 & Q3comps_local==1);
replace nocomp=2 if comps==2 & Q3comps_local==2 & exnocom<4; 

/* 1-3 competitors if does not compete in one of the markets */
replace nocomp=2 if comps==2 & Q3c_local==2;
replace nocomp=2 if comps==. & Q3comps_local==2;

/* RETROSPECTIVE COMPETITION BASED ON THE NUMBER OF COMPETITORS */

gen nocompR=Q3compsR;

/* no competitors on both markets */
replace nocompR=1 if Q3compsR==1 & Q3comps_localR==1;
replace nocompR=1 if Q3compsR==. & Q3comps_localR==1;
replace nocompR=1 if Q3compsR==1 & Q3c_local==2;

/* many competitors */
replace nocompR=3 if (Q3compsR==3 | Q3comps_localR==3);
gen exnocomR=Q3ex_comps_ntlR+Q3ex_comps_locR;
replace nocompR=3 if year==2005 & exnocomR>3 & exnocomR~=.;

/* 1-3 competitors */
replace nocompR=2 if (Q3compsR==1 & Q3comps_localR==2);
replace nocompR=2 if (Q3compsR==2 & Q3comps_localR==1);
replace nocompR=2 if Q3compsR==2 & Q3comps_localR==2 & exnocom<4 ;

/* 1-3 competitors if does not compete in one of the markets */
replace nocompR=2 if Q3compsR==2 & Q3c_local==2;
replace nocompR=2 if Q3compsR==. & Q3comps_localR==2;

******************************************************************;

        gen Q1_2mkt_salesqA=.;
        gen Q1_2mkt_salesqB=.;
ren q14 markupqA;
        
ren q15a        Q2_3inputqA;
ren q15b        Q2_3inputqB;
ren q15c        Q2_3inputqC;
ren q16a        custm_dly;
ren q19 Q2_3suppl_prc;
ren q23a1       Q2_3dys_inf_dfcqA;
ren q23a2       Q2_3dys_inf_dfcqB;
ren q23a3       Q2_3dys_inf_dfcqC;
ren q24a        Q2_3int_clntsqA;
ren q24b        Q2_3int_clntsqB;
ren q24c        Q2_3int_clntsqC;
ren q24d        Q2_3int_clntsqD;
ren q24e        Q2_3int_clntsqE;
ren q25a        Q2_3dys_dly_srvcqA;
ren q25b        Q2_3dys_dly_srvcqB;

ren q27a        court_sys_prcptqA;
ren q27b        court_sys_prcptqB;
ren q27c        court_sys_prcptqC;
ren q27d        court_sys_prcptqD;
ren q27e        court_sys_prcptqE;
        gen Q1court_sys_prcptqF=.;

ren q28 conf_lgl_systm;
        gen Q1conf_lgl_systmR=.;

gen     Q2_3sale_prpaid=q29a;
ren q29c        Q2_3sal_cred;
ren q31a        Q2_3ovrdue_pymnt;
ren q31c        Q2_3days_rslv_pymnt;
ren q32a1       Q2_3pay_scrtyqA;
ren q32a2       Q2_3pay_scrtyqB;
ren q32b1       Q2_3pay_prtctnqA;
ren q32b2       Q2_3pay_prtctnqB;
ren q33a        Q2_3lossesqA;
ren q33b        Q2_3lossesqB;

ren q34a        info_laws;
ren q34b        intrp_laws;
        gen Q1intrp_lawsR=.;

        gen Q1_2prdc_law=.;

        gen time_pub_off_cat=q35a;
replace time_pub_off_cat=1 if q35a>=0 & q35a<=1;
replace time_pub_off_cat=2 if q35a>1 & q35a<=5;
replace time_pub_off_cat=3 if q35a>5 & q35a<=10;
replace time_pub_off_cat=4 if q35a>10 & q35a<=25;
replace time_pub_off_cat=5 if q35a>25 & q35a<=50;
replace time_pub_off_cat=6 if q35a>50 & q35a!=.;
ren q35a        Q2_3time_pub_off_prc;

/*CAPTURING VARIABLES*/

ren q35c        unoff_pay;
ren q36a        memb_lobby;
*ren q37        Q2_3seek_infqA;
*ren q38        Q2_3seek_infqB;
ren q39a        add_pay;
ren q39b        know_add_pay;

ren q41a        pay_reasonqA;
ren q41b        pay_reasonqB;
ren q41c        pay_reasonqC;
ren q41d        Q2_3pay_reasonqD;
ren q41e        Q2_3pay_reasonqE;
ren q41f        Q2_3pay_reasonqF;
ren q41g        pay_reasonqG;
ren q41h        pay_reasonqH;
ren q41i        pay_reasonqI;
ren q41j        pay_reasonqJ;
        gen pay_reasonqK=.;
gen counter=0;
gen counter1=0;
gen counter2=0;
gen summ1=0;
foreach var of varlist
Q2_3pay_reasonqD        
Q2_3pay_reasonqE        
Q2_3pay_reasonqF
{;
replace counter=counter+1 if `var'>0 & `var'~=.;
replace summ1=summ1+`var' if `var'>=0 & `var'~=.;
replace counter1=counter1+1;
replace counter2=counter2+1 if  `var'==.;
};
replace pay_reasonqK=summ1/counter ;
replace pay_reasonqK=. if counter1==counter2;
drop 
counter
counter1
counter2
summ1;

/*EFFECTS OF CAPTURE*/

ren q44a        pay_impctqA;
ren q44b        pay_impctqB;
ren q44c        Q3pay_impctqBloc;
        gen Q1_2pay_impctqC=.;
        gen Q1_2pay_impctqD=.;
        gen Q1_2pay_impctqE=.;
        gen Q1_2pay_impctqF=.;
        gen Q1pay_impctqG=.;
        gen Q1pay_impctqH=.;
ren q45a1       Q2_3source_fin_capqA;
ren q45a2       Q2_3source_fin_capqB;
ren q45a3       Q2_3source_fin_capqC;
ren q45a4       Q2_3source_fin_capqD;
ren q45a5       Q2_3source_fin_capqE;
ren q45a6       Q2_3source_fin_capqF;
ren q45a7       Q2_3source_fin_capqG;
ren q45a8       Q2_3source_fin_capqH;
ren q45a9       Q2_3source_fin_capqI;
ren q45a10      Q2_3source_fin_capqJ;
ren q45a11      Q2_3source_fin_capqK;
ren q45a12      Q2_3source_fin_capqL;
ren q45a13      Q2_3source_fin_capqM;
ren q45a14      Q2_3source_fin_capqN;
ren q45a15      source_fin_invqA;
ren q45a16      source_fin_invqB;
ren q45a17      source_fin_invqC;
ren q45a18      source_fin_invqD;
ren q45a19      Q2_3source_fin_invqE;
ren q45a20      source_fin_invqF;
ren q45a21      source_fin_invqG;
ren q45a22      source_fin_invqH;
ren q45a23      Q2_3source_fin_invqI;
ren q45a24      Q2_3source_fin_invqJ;
ren q45a25      source_fin_invqK;
ren q45a26      source_fin_invqL;
ren q45a27      source_fin_invqM;
ren q45a28      source_fin_invqN;
        gen Q1source_fin_invqO=.;
ren q46a        Q2_3cltrl_loan;
ren q46c        Q2_3val_cltrl;
ren q46d        Q2_3loan_cost;
ren q46e        Q2_3loan_drtn;
ren q46h        Q2_3days_get_loan;
ren q48a        ias;
ren q49 extrnl_adtr;
        gen Q1_2days_trans_domqA=.;
        
        gen Q1days_trans_domRqA=.;
        
        gen Q1_2days_trans_frgnqA=.;
        
        gen Q1days_trans_frgnRqA=.;
        gen     sales_bartrqA=q50a;
gen     sales_bartrqB=q50b;
gen     sales_bartrqC=q50c;
gen     sales_bartrqD=q50d;
gen     sales_bartrqE=q50e;
gen     sales_bartrqF=q50f;
gen     Q2_3purchs_bartrqA=q51a;
gen     Q2_3purchs_bartrqB=q51b;
gen     Q2_3purchs_bartrqC=q51c;
gen     Q2_3purchs_bartrqD=q51d;
gen     Q2_3purchs_bartrqE=q51e;
gen     Q2_3purchs_bartrqF=q51f;
ren q52a1       Q2_3ovrd_pymt_ctgqA;
ren q52a2       Q2_3ovrd_pymt_ctgqB;
ren q52a3       Q2_3ovrd_pymt_ctgqC;
ren q52a4       Q2_3ovrd_pymt_ctgqD;
ren q52b1       Q2_3ovrd_pymt_perqA;
ren q52b2       Q2_3ovrd_pymt_perqB;
ren q52b3       Q2_3ovrd_pymt_perqC;
ren q52b4       Q2_3ovrd_pymt_perqD;
gen     Q2_3subsdsqA1=q53a1;
gen     Q2_3subsdsqA2=q53a2;
gen     Q3subsdsqB=q53a3;
gen     Q2_3subsdsC=q53a4;
        gen subsdsqA=.;
replace  subsdsqA=1 if (Q2_3subsdsqA1==1 | Q2_3subsdsqA2==1);
replace  subsdsqA=2 if (Q2_3subsdsqA1==2 & Q2_3subsdsqA2==2);
        gen Q1subsdsR=.;
gen     Q2_3sub_perc_slsqA=q53b1;
gen     Q2_3sub_perc_slsqB=q53b2;
gen     Q2_3sub_perc_slsqC=q53b3;
gen     Q2_3sub_perc_slsqD=q53b4;

/*business environment*/

        gen     Q1constrqA1=.;
        gen     Q1constrqA2=.;
        gen     Q1constrqA3=.;
        gen     Q1constrqA4=.;
        gen     Q1constrqA5=.;
        gen     Q1constrqA6=.;
        gen     Q1constrqA7=.;
        gen     Q1constrqA8=.;
        gen     Q1constrqA9=.;
ren q54a        constrqA;
        gen     Q1constrqB1=.;
        gen     Q1constrqB2=.;
        gen     Q1constrqB3=.;
ren q54b        constrqB;
ren q54c        Q2_3constrqC1;
ren q54d        Q2_3constrqC2;
ren q54e        Q2_3constrqC3;
ren q54f        Q2_3constrqC4;
ren q54g        Q2_3constrqC5;
        gen     constrqC=.;

gen counter=0;
gen counter1=0;
gen counter2=0;
gen summ1=0;
foreach var of varlist
Q2_3constrqC1   
Q2_3constrqC2   
Q2_3constrqC3
Q2_3constrqC4   
Q2_3constrqC5
        
{;
replace counter=counter+1 if `var'>0 & `var'~=.;
replace summ1=summ1+`var' if `var'>=0 & `var'~=.;
replace counter1=counter1+1;
replace counter2=counter2+1 if  `var'==.;
};
replace constrqC=summ1/counter ;
replace constrqC=. if counter1==counter2;
drop 
counter
counter1
counter2
summ1;
ren q54h        constrqD;
ren q54i        constrqE;
        
ren q54j        constrqF;
        gen     Q1constrqG1=.;
        gen     Q1constrqG2=.;
        gen     Q1constrqG3=.;
ren q54k        constrqG;
ren q54l        constrqH;
ren q54m        Q2_3constrqI;
ren q54n        constrqJ;
        gen     Q1constrqK1=.;
        gen     Q1constrqK2=.;
ren q54o        constrqK;
ren q54p        constrqL;
ren q54q        constrqM;
ren q54r        constrqN;
ren q54s        constrqO;
ren q54t        constrqP;
ren q54u        Q2_3constrqQ;
ren q54v        Q3Q1_3constrqR1;
ren q54w        Q3Q1_3constrqR2;
        gen Q1_3constrqR=.;
gen counter=0;
gen counter1=0;
gen counter2=0;
gen summ1=0;
foreach var of varlist
Q3Q1_3constrqR1 
Q3Q1_3constrqR2 
{;
replace counter=counter+1 if `var'>0 & `var'~=.;
replace summ1=summ1+`var' if `var'>=0 & `var'~=.;
replace counter1=counter1+1;
replace counter2=counter2+1 if  `var'==.;
};
replace Q1_3constrqR=summ1/counter ;
replace Q1_3constrqR=. if counter1==counter2;
drop 
counter
counter1
counter2
summ1;
gen Q1constrqS=.;

gen constrqALL15=.;
gen counter=0;
gen counter1=0;
gen counter2=0;
gen summ1=0;
foreach var of varlist  

constrqA
constrqB
constrqC
constrqD
constrqE
constrqF
constrqG
constrqH
constrqJ
constrqK
constrqL
constrqM
constrqN
constrqO
constrqP

{;
replace counter=counter+1 if `var'>0 & `var'~=.;
replace summ1=summ1+`var' if `var'>=0 & `var'~=.;
replace counter1=counter1+1;
replace counter2=counter2+1 if  `var'==.;
};
replace constrqALL15=summ1/counter ;
replace constrqALL15=. if counter1==counter2;
drop 
counter
counter1
counter2
summ1;

***************MAIN VARIABLES CHANGES;

ren q55a1       perfqA;
ren q55a3       perfqB;
ren q55a2       perfqC;
        gen Q1perfqD=.;
        gen Q1perfqE=.;
ren q55a4       Q3perfqF;

ren q55b1       perfqG;
ren q55b3       perfqH;
ren q55b2       perfqI;

        gen Q1perfqK=.;
ren q55b4       Q3perfqL;

        gen Q1perfqM=.;
        gen Q1perfqN=.;
        gen Q1perfqO=.;
        gen Q1perfqP=.;
        gen Q1perfqQ=.;

        gen Q1perfqR=.;
        gen Q1perfqS=.;
        gen Q1perfqT=.;
        gen Q1perfqU=.;
        gen Q1perfqV=.;

replace perfqA=-1 if perfqA==2;
replace perfqA=0 if perfqA==3;
replace perfqB=-1 if perfqB==2;
replace perfqB=0 if perfqB==3;
replace perfqC=-1 if perfqC==2;
replace perfqC=0 if perfqC==3;
replace Q3perfqF=-1 if Q3perfqF==2;
replace Q3perfqF=0 if Q3perfqF==3;
*replace Q3perfqF=1 if Q3perfqF==1;
replace perfqG=-perfqG          if perfqA==-1   & perfqG>0 & perfqG!=.;
replace perfqH=-perfqH          if perfqB==-1   & perfqH>0 & perfqH!=.;
replace perfqI=-perfqI          if perfqC==-1   & perfqI>0 & perfqI!=.;
replace Q3perfqL=-Q3perfqL      if Q3perfqF==-1         & Q3perfqL>0 & Q3perfqL!=.;

******************SALES;

ren q57a        Q2_3sales_per;
        gen     sales_cat=Q2_3sales;
replace         sales_cat=1 if Q2_3sales_per>=0 & Q2_3sales_per<250;
replace         sales_cat=2 if Q2_3sales_per>=250 & Q2_3sales_per<500;
replace         sales_cat=3 if Q2_3sales_per>=500 & Q2_3sales_per<1000;
replace         sales_cat=4 if Q2_3sales_per>=1000 & Q2_3sales_per<2000;
replace         sales_cat=5 if Q2_3sales_per>=2000 & Q2_3sales_per<5000;
replace         sales_cat=6 if Q2_3sales_per>=5000 & Q2_3sales_per<10000;
replace         sales_cat=7 if Q2_3sales_per>=10000 & Q2_3sales_per<20000;
replace         sales_cat=8 if Q2_3sales_per>=20000 & Q2_3sales_per<50000;
replace         sales_cat=9 if Q2_3sales_per>=50000 & Q2_3sales_per<500000;
replace         sales_cat=11 if Q2_3sales_per>=500000 & Q2_3sales_per!=.;
ren q57b        Q2_3fixed_assts_per;
        gen     fixed_assts_cat=Q2_3fixed_assts_per;
replace         fixed_assts_cat=1 if Q2_3fixed_assts_per>=0 & Q2_3fixed_assts_per<250;
replace         fixed_assts_cat=2 if Q2_3fixed_assts_per>=250 & Q2_3fixed_assts_per<500;
replace         fixed_assts_cat=3 if Q2_3fixed_assts_per>=500 & Q2_3fixed_assts_per<1000;
replace         fixed_assts_cat=4 if Q2_3fixed_assts_per>=1000 & Q2_3fixed_assts_per<2000;
replace         fixed_assts_cat=5 if Q2_3fixed_assts_per>=2000 & Q2_3fixed_assts_per<5000;
replace         fixed_assts_cat=6 if Q2_3fixed_assts_per>=5000 & Q2_3fixed_assts_per<10000;
replace         fixed_assts_cat=7 if Q2_3fixed_assts_per>=10000 & Q2_3fixed_assts_per<20000;
replace         fixed_assts_cat=8 if Q2_3fixed_assts_per>=20000 & Q2_3fixed_assts_per<50000;
replace         fixed_assts_cat=9 if Q2_3fixed_assts_per>=50000 & Q2_3fixed_assts_per<500000;
replace         fixed_assts_cat=11 if Q2_3fixed_assts_per>=500000 & Q2_3fixed_assts_per!=.;

***********************COST SHARES (added 1/9/2009, HB);

gen cost2 = q57c;
gen cost_mat = q57d;
gen cost_pers = q57e;
gen cost_nrg = q57f;



***********************DEBTS;

        gen     Q1debts_val=.;
        gen Q2debts_per=.;
        gen Q2debts_perR=.;

*****************PROFITS;

        gen Q2gr_prfts=.;
        gen Q2gr_prftsR=.;
ren q59a        Q3prfts_invst_per;
ren q59b        Q3no_prfts      ;
        gen Q2_3prfts_invst_cat=Q3prfts_invst_per ;
replace Q2_3prfts_invst_cat=1 if Q3prfts_invst_per==0;
replace Q2_3prfts_invst_cat=2 if Q3prfts_invst_per>0 & Q3prfts_invst_per<=10;
replace Q2_3prfts_invst_cat=3 if Q3prfts_invst_per>10 & Q3prfts_invst_per<=25;
replace Q2_3prfts_invst_cat=4 if Q3prfts_invst_per>25 & Q3prfts_invst_per<=50;
replace Q2_3prfts_invst_cat=5 if Q3prfts_invst_per>50 & Q3prfts_invst_per<=75;
replace Q2_3prfts_invst_cat=6 if Q3prfts_invst_per>75 & Q2_3prfts_invst_cat!=.;
replace Q2_3prfts_invst_cat=1 if Q3no_prfts==1  &       Q2_3prfts_invst_cat==.;

********************FIRM INITIATIVE;

ren q60a1       initiativeqA;
ren q60a2       initiativeqB;
ren q60a3       initiativeqC;
ren q60a4       initiativeqD;
ren q60a5       initiativeqE;
ren q60a6       initiativeqF;
ren q60a7       Q2_3initiativeqG;
ren q60a8       initiativeqH;
        gen Q1_2initiativeqI=.;
        gen Q1_2initiativeqJ=.;
        gen Q2initiativeqK=.;
        gen Q1initiativeqL=.;
        gen Q1initiativeqM=.;
ren q20a1 initiativeqN ;
ren q20a2 initiativeqO ;
ren q20a3 initiativeqP ;
        gen Q1initiativeqQ=.;
        gen initiativeqR=.;

replace initiativeqA=0 if       initiativeqA==2;
replace initiativeqB=0 if       initiativeqB==2;
replace initiativeqC=0 if       initiativeqC==2;
replace initiativeqD=0 if       initiativeqD==2;
replace initiativeqE=0 if       initiativeqE==2;
replace initiativeqF=0 if       initiativeqF==2;
replace Q2_3initiativeqG=0 if   Q2_3initiativeqG==2;
replace initiativeqH=0 if       initiativeqH==2;
replace initiativeqN=0 if       initiativeqN==2;
replace initiativeqO=0 if       initiativeqO==2;
replace initiativeqP=0 if       initiativeqP==2;


replace initiativeqR=1 if 

initiativeqA==0 &
initiativeqB==0 &
initiativeqC==0 &
initiativeqD==0 &
initiativeqE==0 &
initiativeqF==0 &
Q2_3initiativeqG==0 &
initiativeqH==0 &
initiativeqN==0 &
initiativeqO==0 &
initiativeqP==0;
replace initiativeqR=0 if initiativeqR==.;

replace initiativeqR=. if

initiativeqA==. &
initiativeqB==. &
initiativeqC==. &
initiativeqD==. &
initiativeqE==. &
initiativeqF==. &
Q2_3initiativeqG==. &
initiativeqH==. &
initiativeqN==. &
initiativeqO==. &
initiativeqP==.;

*******************DEPARTMENT ORGANIZATION;
ren q62 org;

********************NEW PRODUCTS;
ren q63a        new_prdctqA;
ren q63b        new_prdctqB;
ren q63c        new_prdctqC;
        gen Q1_2new_prdctqD=.;
        gen Q1_2new_prdctqE=.;
        gen Q1_2new_prdctqF=.;

*******************REDUCING COSTS;

ren q64a        reduc_costqA;
ren q64b        reduc_costqB;
ren q64c        reduc_costqC;
        gen Q1_2reduc_costqD=.;
        gen Q1_2reduc_costqE=.;
        gen Q1_2reduc_costqF=.;

*******************CAPACITY UTILISATION;

ren q65a1       Q2_3cap_utl;
ren q65a2       Q2_3cap_utlR;

******************EMPLOYMENT;

ren q66a        Q2_3perm_full_emp;
ren q66b        Q2_3perm_full_empR;

ren q67a        Q2_3part_tm_emp;
ren q67b        Q2_3part_tm_empR;



ren q68a1       Q2_3ft_wrk_catqA;
ren q68a2       Q2_3ft_wrk_catqB;
ren q68a3       Q2_3ft_wrk_catqC;
ren q68a4       Q2_3ft_wrk_catqD;
ren q68a5       Q2_3ft_wrk_catqE;
ren q68b1       Q3ft_wrk_catRqA;
ren q68b2       Q3ft_wrk_catRqB;
ren q68b3       Q3ft_wrk_catRqC;
ren q68b4       Q3ft_wrk_catRqD;
ren q68b5       Q3ft_wrk_catRqE;

********************EDUCATION;

        gen     Q2edu_lbrqA1=.  ;
        gen     Q2edu_lbrqA2=.  ;
ren q69a1       Q2_3edu_lbrqA;
ren q69a2       Q2_3edu_lbrqB;
ren q69a3       Q2_3edu_lbrqC;
        gen Q2edu_lbrqD1=.;
        gen Q2edu_lbrqD2=.;
ren q69a4       Q2_3edu_lbrqD;
        

ren q69b1       Q3edu_lbrRqA;
ren q69b2       Q3edu_lbrRqB;
ren q69b3       Q3edu_lbrRqC;
ren q69b4       Q3edu_lbrRqD;

*************TIME LOST;


ren q70a        Q2_3time_vacqA;
ren q70b        Q2_3time_vacqB;
ren q70c        Q2_3time_vacqC;
ren q70d        Q2_3time_vacqD;
ren q70e        Q2_3time_vacqE;


****************TRAINING;


        gen Q2trainingqA1=.   ;
        gen Q2trainingqA2=.;
ren q71a3       Q2_3trainingqA;
ren q71a1       Q2_3trainingqB;
ren q71a2       Q2_3trainingqC; 
        gen Q2trainingqD=.;

        gen     Q2per_trainedqA1=.;
        gen     Q2per_trainedqA2=.;
ren q71b3       Q2_3per_trainedqA;
ren q71b1       Q2_3per_trainedqB;
ren q71b2       Q2_3per_trainedqC;
        gen Q2per_trainedqD=.;

********************STRIKE, UNREST;


ren q72a        Q2_3days_lostqA;
ren q72b        Q2_3days_lostqB;


*************CHANGING LABOR FORCE;

        gen Q1wkfc_levelqA=.;
        gen Q1wkfc_levelqB=.;
ren q73 Q2_3chg_wkfc;

**************LAW AND REGULATIONS, UNOFFICAIL PAYMENT;


* Q36b *;
gen Q2_3serv_ass1=q36b1;
gen Q2_3serv_ass2=q36b2;
gen Q2_3serv_ass3=q36b3;
gen Q2_3serv_ass4=q36b4;
gen Q2_3serv_ass5=q36b5;
gen Q2_3serv_ass6=q36b6;


* Q37 & Q38*;
gen Q2_3seek_infl=.;
replace Q2_3seek_infl=1 if q37==1 | q38==1;
replace Q2_3seek_infl=2 if q37==2 & q38==2;


* Q40 * ;
gen pay_perc_sales=.;
replace pay_perc_sales=1 if q40==0;
replace pay_perc_sales=2 if q40>0 & q40<1;
replace pay_perc_sales=3 if q40>=1 & q40<2;
replace pay_perc_sales=4 if q40>=2 & q40<10;
replace pay_perc_sales=5 if q40>=10 & q40<13;
replace pay_perc_sales=6 if q40>=13 & q40<25;
replace pay_perc_sales=7 if q40>=25 & q40~=.;

gen Q2_3pay_perc_sales_prc=q40;

* Q42 *;
gen perc_cntr_val=.;
replace perc_cntr_val=1 if q42==0;
replace perc_cntr_val=2 if q42>0 & q42<6;
replace perc_cntr_val=3 if q42>=6 & q42<11;
replace perc_cntr_val=4 if q42>=11 & q42<16;
replace perc_cntr_val=5 if q42>=16 & q42<20;
replace perc_cntr_val=6 if q42>=20 & q42~=.;

gen Q2_3perc_cntr_val_prc=q42;

/* old code of alex for variable 44
gen parl_pay=q44a;
gen Q2_3gov_offic=q44b;
gen Q3local_off=q44c*/

/*VALUE ADDED
the Q3val_add variable is computed as sales-matrial inputs-total energy and fuel
the Q3val_add1 variable is computed as sales-opearating costs+total labor costs
the two variables do differ
amended 12/10/2006 mats is materials; matsp is materials as a percentage of sales */


gen Q3val_add=Q2_3sales_per-q57d-q57f;
gen Q3val_add1=Q2_3sales_per-q57c+q57e;
ren q57d mats;
gen matsp =.;

*SALES PER WORKER*;
gen Q2_3salesonemp=Q2_3sales_per/Q2_3perm_full_emp;

*REASON NOT IN THE PANEL*;

gen Q2reason05=.;

*PERCENTAGE OF SALES REPORTED TO THE TAX AUTHORITIES*;

gen perc_sales_tax=.;
replace perc_sales_tax=1 if q43a==100;
replace perc_sales_tax=2 if q43a>90 & q43a<100;
replace perc_sales_tax=3 if q43a>80 & q43a<=90;
replace perc_sales_tax=4 if q43a>70 & q43a<=80;
replace perc_sales_tax=5 if q43a>60 & q43a<=70;
replace perc_sales_tax=6 if q43a>50 & q43a<=60;
replace perc_sales_tax=7 if q43a>25 & q43a<=50;
replace perc_sales_tax=8 if q43a<=25;

*PERMISSION TO INCLUDE IN THE DATABASE FOR FUTURE INTERVIEW*;

ren q75 Q2_3permis;


***************************************
alex C. added variables
***************************************;

rename q8a Q2_3exp_delays_av;
rename q8b Q2_3exp_delays_max;

rename q16b Q2_3custm_dly_max;

rename q23b1 Q3hrs_inf_dfcA;
rename q23b2 Q3hrs_inf_dfcB;
rename q23b3 Q3hrs_inf_dfcC;

rename q23c1 Q3loss_inf_dfcA;
rename q23c2 Q3loss_inf_dfcB;
rename q23c3 Q3loss_inf_dfcC;

rename q26a Q3shipm_lossA;
rename q26b Q3shipm_lossB;

gen Q2_3perc_court_act=q31d/q31b;

rename q31b Q3overdue_cases;
rename q31d Q3no_court_act;


rename q32a3 Q3pay_scrty_value;

rename q38ba1 Q3insp_tax;
rename q38ba2 Q3insp_labr;
rename q38ba3 Q3insp_fire;
rename q38ba4 Q3insp_sanit;
rename q38ba5 Q3insp_polic;
rename q38ba6 Q3insp_envir;
rename q38ba7 Q3insp_cust;

rename q38bb1 Q3insp_tax_no;
rename q38bb2 Q3insp_labr_no;
rename q38bb3 Q3insp_fire_no;
rename q38bb4 Q3insp_sanit_no;
rename q38bb5 Q3insp_polic_no;
rename q38bb6 Q3insp_envir_no;
rename q38bb7 Q3insp_cust_no;

rename q38bc1 Q3insp_tax_dur;
rename q38bc2 Q3insp_labr_dur;
rename q38bc3 Q3insp_fire_dur;
rename q38bc4 Q3insp_sanit_dur;
rename q38bc5 Q3insp_polic_dur;
rename q38bc6 Q3insp_envir_dur;
rename q38bc7 Q3insp_cust_dur;


rename q53a1 Q2_3subsd_nat_gov;
rename q53a2 Q2_3subsd_reg_gov;
gen Q2_3subsd_other=q53a3+q53a4;
rename q53a3 Q3subsd_EU;

rename q53b1 Q2_3subsd_nat_gov_ps;
rename q53b2 Q2_3subsd_reg_gov_ps;
gen Q2_3subsd_other_ps=q53b3+q53b4;
rename q53b3 Q3subsd_EU_ps;

rename q48b Q3gaap;
rename q48c Q3nat_acc_stand;

rename q47a Q3why_no_loan;
rename q47b1 Q3why_no_appl;
rename q47c1 Q3loan_reject;

rename q45b1 Q3check_acc;
rename q45b2 Q3sav_acc;

rename q46b1 Q3collat_type;
rename q46f Q3loan_curr;

gen Q2_3sales_cash_bank=q50a+q50b;
rename q50c Q2_3sales_bills;
rename q50d Q2_3sales_offsets;
rename q50e Q2_3sales_bart;
rename q50f Q2_3sales_other;


gen Q2_3purch_cash_bank=q51a+q51b;
rename q51c Q2_3purch_bills;
rename q51d Q2_3purch_offsets;
rename q51e Q2_3purch_bart;
rename q51f Q2_3purch_other;

rename q29a Q2_3sal_prpd;
rename q29b Q3sal_pd_dlvr;
rename q31ea Q2_3plantiff;
rename q31eb Q2_3defendant ;
rename q35b Q3ext_cons;
rename q43b Q3wrkfrc_decl;
rename q43c Q3wage_decl;

*****************************************************************
HB Added
****************************************************************;
ren q57c cost;
ren q57e wages;



save data/temp05, replace;
compress;

**************************************************************************
APPENDING PROCEDURE
**************************************************************************;

append using data/temp02;
compress;
append using data/temp99;
compress;
save data/tempdata, replace;
***************************************************************************
ADDITIONAL VARIABLES
***************************************************************************;

gen age=year-start if start!=.;
gen age2=age*age;

gen LQ2_3salesonemp=log(Q2_3salesonemp);

egen SDLQ2_3salesonemp02=sd(LQ2_3salesonemp) if year==2002, by(country);
egen MEANLQ2_3salesonemp02=mean(LQ2_3salesonemp) if year==2002, by(country);

egen SDLQ2_3salesonemp05=sd(LQ2_3salesonemp) if year==2005, by(country);
egen MEANLQ2_3salesonemp05=mean(LQ2_3salesonemp) if year==2005, by(country);

replace LQ2_3salesonemp=. if year==2002 & (LQ2_3salesonemp>MEANLQ2_3salesonemp02+2*SDLQ2_3salesonemp02
| LQ2_3salesonemp<MEANLQ2_3salesonemp02-2*SDLQ2_3salesonemp02);

replace LQ2_3salesonemp=. if year==2005 & (LQ2_3salesonemp>MEANLQ2_3salesonemp05+2*SDLQ2_3salesonemp05
| LQ2_3salesonemp<MEANLQ2_3salesonemp05-2*SDLQ2_3salesonemp05);

gen Q2_3salesonemp_new=exp(LQ2_3salesonemp);

gen LQ3val_add1=log(Q3val_add1);

egen SDLQ3val_add02=sd(LQ3val_add1) if year==2002, by(country);
egen MEANLQ3val_add02=mean(LQ3val_add1) if year==2002, by(country);

egen SDLQ3val_add05=sd(LQ3val_add1) if year==2005, by(country);
egen MEANLQ3val_add05=mean(LQ3val_add1) if year==2005, by(country);

replace LQ3val_add1=. if year==2002 & (LQ3val_add1>MEANLQ3val_add02+2*SDLQ3val_add02
| LQ3val_add1<MEANLQ3val_add02-2*SDLQ3val_add02);

replace LQ3val_add1=. if year==2005 & (LQ3val_add1>MEANLQ3val_add05+2*SDLQ3val_add05
| LQ3val_add1<MEANLQ3val_add05-2*SDLQ3val_add05);

gen Q3val_add_new=exp(LQ3val_add1);

gen prod4DIG=string(Q2_3main_prdc);

gen prod3DIG=substr(prod4DIG,1,3);
gen prod2DIG=substr(prod4DIG,1,2);
gen prod1DIG=substr(prod4DIG,1,1);

destring prod4DIG prod3DIG prod2DIG prod1DIG, replace;

replace initiativeqA=0 if initiativeqA==.;
replace initiativeqB=0 if initiativeqB==.;
replace initiativeqD=0 if initiativeqD==.;
replace initiativeqE=0 if initiativeqE==.;
replace initiativeqH=0 if initiativeqH==.;
replace initiativeqP=0 if initiativeqP==.;

gen init_index=initiativeqA+initiativeqB+initiativeqD+initiativeqE+initiativeqH+initiativeqP;
tab init_index, m;
tab init_index initiativeqR;

gen init_index_dual=init_index;
replace init_index_dual=1 if init_index!=0 &  init_index!=.;
tab init_index_dual, m;
tab init_index_dual initiativeqR;


gen id_merge=Q3srl_no2002;
replace id_merge=serialno if year==2002; 

foreach var of varlist constrqA constrqB 
constrqC constrqD constrqE constrqF 
constrqG constrqH constrqJ constrqK 
constrqL constrqM constrqN constrqO 
constrqP Q1_3constrqR pay_reasonqK
{;

replace `var'=round(`var');
};

***********************************************************************
PROCEDURE TO clean the addition variables
***********************************************************************;


/*1999*/

replace perfqI=. if perfqI<-100;


/*2002*//*2005*/

replace Q2_3perm_full_emp=1 if Q2_3perm_full_emp==0;
replace Q2_3perm_full_empR=1 if Q2_3perm_full_empR==0;

#delimit;
winsor Q2_3part_tm_emp if year==2002, gen(Q2_3part_tm_emp_winsor02) p(0.001) ;
winsor Q2_3part_tm_empR if year==2002, gen(Q2_3part_tm_emp_winsorR02) p(0.001) ;

winsor Q2_3part_tm_emp if year==2005, gen(Q2_3part_tm_emp_winsor05) p(0.001) ;
winsor Q2_3part_tm_empR if year==2005, gen(Q2_3part_tm_emp_winsorR05) p(0.001) ;

replace Q2_3part_tm_emp=Q2_3part_tm_emp_winsor02 if year==2002;
replace Q2_3part_tm_empR=Q2_3part_tm_emp_winsorR02 if year==2002;

replace Q2_3part_tm_emp=Q2_3part_tm_emp_winsor05 if year==2005;
replace Q2_3part_tm_empR=Q2_3part_tm_emp_winsorR05 if year==2005;

gen Q2_3TOT_emp=Q2_3perm_full_emp+0.5*Q2_3part_tm_emp; 
gen Q2_3TOT_empR=Q2_3perm_full_empR+0.5*Q2_3part_tm_empR;

replace Q2_3TOT_emp=Q2_3perm_full_emp if Q2_3TOT_emp==. & Q2_3perm_full_emp!=.;
replace Q2_3TOT_empR=Q2_3perm_full_empR if Q2_3TOT_empR==. & Q2_3perm_full_empR!=.;


replace perfqJ=(Q2_3TOT_emp/Q2_3TOT_empR-1)*100 if year!=1999;

winsor perfqJ if year==2002, gen(perfqJ_winsor02) p(0.001);
winsor perfqJ if year==2005, gen(perfqJ_winsor05) p(0.001);

gen perfqJ_winsor=.;
replace perfqJ_winsor=perfqJ if year==1999;
replace perfqJ_winsor=perfqJ_winsor02 if year==2002;
replace perfqJ_winsor=perfqJ_winsor05 if year==2005;


gen perfqW=((perfqG-perfqJ)/(perfqJ+100))*100 if perfqG!=. & perfqJ!=.;
replace perfqW=. if (perfqG==. | perfqJ==.);

winsor perfqW if year==2002, gen(perfqW_winsor02) p(0.001);
winsor perfqW if year==2005, gen(perfqW_winsor05) p(0.001);

gen perfqW_winsor=.;
replace perfqW_winsor=perfqW if year==1999;
replace perfqW_winsor=perfqW_winsor02 if year==2002;
replace perfqW_winsor=perfqW_winsor05 if year==2005;



******************************************************
LABELS AND LEGENDA
******************************************************;

/* This procedure harmonizes country codes across different waves of the survey */
/* The main variable is  "country ", the codes are those from BEEPS 2002 wave */
/* Variable  "country1 " is the same as  "country " except for that Yugoslavia is split into Serbia and Montenegro */
/* Serbia is coded 29 and Montenegro - 30, Yugoslavia is therefore missing */
/* In BEEPS 1999, two parts of Bosnia created under Dayton agreements are distinguished in the dataset */
/* The Federation and the Republica Srpska. Since this division never appears in the later waves */
/* The two entities are considered as Bosnia and Herzegovina */ 

gen country1=. ;
replace country1=country if year==2002;
replace country1=country if year==2005 & country>2;
replace country1=1 if year==2005 & country==2;
replace country1=2 if year==2005 & country==1;

replace country1=6 if year==1999 & country==25;
replace country1=2 if year==1999 & country==26;
replace country1=3 if year==1999 & country==21;
replace country1=4 if year==1999 & country==5;
replace country1=5 if year==1999 & country==22;
replace country1=6 if year==1999 & country==24;
replace country1=7 if year==1999 & country==18;
replace country1=8 if year==1999 & country==14;
replace country1=9 if year==1999 & country==19;
replace country1=10 if year==1999 & country==3;
replace country1=11 if year==1999 & country==9;
replace country1=12 if year==1999 & country==6;
replace country1=13 if year==1999 & country==17;
replace country1=14 if year==1999 & country==15;
replace country1=15 if year==1999 & country==4;
replace country1=16 if year==1999 & country==13;
replace country1=17 if year==1999 & country==23;
replace country1=18 if year==1999 & country==12;
replace country1=19 if year==1999 & country==7;
replace country1=20 if year==1999 & country==8;
replace country1=21 if year==1999 & country==1;
replace country1=22 if year==1999 & country==10;
replace country1=23 if year==1999 & country==2;
replace country1=24 if year==1999 & country==20;
replace country1=26 if year==1999 & country==16;
replace country1=28 if year==1999 & country==11;
replace country=country1;
drop country1;
label define codes 
1 Yugoslavia 
2 FYROM 
3 Albania 
4 Croatia 
5 Turkey 
6 Bosnia 
7 Slovenia 
8 Poland 
9 Ukraine 
10 Belarus 
11 Hungary 
12 Czech_Rep 
13 Slovakia 
14 Romania 
15 Bulgaria 
16 Moldova 
17 Latvia 
18 Lithuania 
19 Estonia 
20 Georgia 
21 Armenia 
22 Kazakhstan 
23 Azerbaijan 
24 Uzbekistan 
26 Russia 
27 Tajikistan 
28 Kyrgyzstan;

label values country codes;

gen country1=country if country>1;
replace country1=29 if country==1 & Q2_3yugo==1;
replace country1=30 if country==1 & Q2_3yugo==2;

label define codes2 
29 Serbia 
30 Montenegro 
2 FYROM 
3 Albania 
4 Croatia 
5 Turkey 
6 Bosnia 
7 Slovenia 
8 Poland 
9 Ukraine 
10 Belarus 
11 Hungary 
12 Czech_Rep 
13 Slovakia 
14 Romania 
15 Bulgaria 
16 Moldova 
17 Latvia 
18 Lithuania 
19 Estonia 
20 Georgia 
21 Armenia 
22 Kazakhstan 
23 Azerbaijan 
24 Uzbekistan 
26 Russia 
27 Tajikistan 
28 Kyrgyzstan;

label values country1 codes2;

 
/* Country groups */
/* Turkey is not included in any of the categories */

* 1 New member states (Czeck Rep., Estonia, ..., Slovenia) *
* 2 South Eastern Europe 1 (Bulgaria, Croatia, Romania) *
* 3 South Eastern Europe 2 (Albania, Bosnia, RYROM, Serbia and Montenegro) *
* 4 Western CIS (Russia, Ukraine, Belarus, Moldova) *
* 5 Caucasus (Armenia, Azerbaijan, Georgia)
* 6 Central Asia ;

gen reg=.;
replace reg=1 
if country==19 | country==18 | 
country==17 | country==13 | 
country==12 | country==11 | 
country==8 | country==7;

replace reg=2 if country==4 | country==14 | country==15;
replace reg=3 if country==3 | country==1 | country==2 | country==6;
replace reg=4 if country==26 | country==16 | country==9 | country==10;
replace reg=5 if country==21 | country==20 | country==23;
replace reg=6 if country==28 | country==27 | country==24 | country==22;

gen regmacro=1 if reg==1;
replace regmacro=2 if reg==2 | reg==3;
replace regmacro=3 if reg==4 | reg==5 | reg==6;

label define codes3 
1 New_EU_members 
2 New_accession_SEE1 
3 SEE2 
4 Western_CIS 
5 Caucasus 
6 Central_Asia;
label values reg codes3;

/*CITYTOWN*/

label variable citytown "CITY OR TOWN DIMENSION";

label define citytown
1 "CAPITAL"
2 "OVER 1 MIL."
3 "250 000-1 MIL."
4 "50 000-250 000"
5 "UNDER 50 000"
;


/*SALES and FIXED ASSETS IN CATEGORIES*/

label variable sales_cat "ESTIMATES OF NOMINAL SALES IN THE LAST YEAR intervals of USD";

label define sales_cat
1 "<250 000 $"
2 "250 000-499 000 $"
3 "500 000-999 000"
4 "1-1.99 MIL."
5 "2-4.99 MIL."
6 "5-9.99 MIL."
7 "10-19.99 MIL."
8 "20-49.99 MIL."
9 "50-499 MIL."
11 ">=500 MIL."
;

label values sales_cat sales_cat;

label variable fixed_assts_cat "ESTIMATES OF NOMINAL FIXED ASSETS IN THE LAST YEAR intervals of USD";
label values fixed_assts_cat sales_cat;

/*% PROFITS INVESTED*/

label variable Q2_3prfts_invst_cat "% PROFITS INVESTED IN THE LAST YEAR";

label define Q2_3prfts_invst_cat
1 "0%"
2 "1-10%"
3 "11-25%"
4 "26-50%"
5 "51-75%"
6 ">75%"
;

label values Q2_3prfts_invst_cat Q2_3prfts_invst_cat;

/*IMPORT COMPETITION*/

label variable Q2_3imp_cmpt "IMPORT COMPETITION";

label define Q2_3imp_cmpt
1 "NOT IMPORTANT"
2 "SLIGHTLY IMPORTANT"
3 "FAIRLY IMPORTANT"
4 "VERY IMPORTANT"
5 "EXTREMELY IMPORTANT"
6 "THESE PRODUCT CAN NOT BE IMPORTED"
;

label values Q2_3imp_cmpt Q2_3imp_cmpt;

label values citytown citytown;

/*LEGAL ORGANISATION OF THE FIRM*/

label variable legstqA "LEGAL ORGANISATION OF THE FIRM";

label define legst1
1 "SINGLE PROPRIETORSHIP"
2 "PARTNERSHIP"
3 "COOPERATIVE"
4 "CORPORATION, PRIVATELY HELD"
5 "CORPORATION, LISTED ON A STOCK EXCHANGE"
6 "OTHER PRIVATE SECTOR"
7 "STATE/MUNICIPAL/DISTRICT-OWNED ENTERPRISE"
8 "CORPORATIZED STATE-OWNED ENTERPRISE"
9 "OTHER STATE OWNED FIRM"
;

label values legstqA legst1;

label variable legstqB "LEGAL ORGANISATION OF THE FIRM 2";

label define legst2
1 "PRIVATE SECTOR FIRM"
2 "STATE SECTOR FIRM"
;

label values legstqB legst2;

/* label to ind (MAIN AREA OF ACTIVITY IN TERMS OF SALE)*/

label variable ind  "MAIN AREA OF ACTIVITY IN TERMS OF SALES ";


label define ind 
1 "MINING & QUARRYING "
2 "CONSTRUCTION "
3 "MANUFACTURING "
4 "TRANSPORT STORAGE & COMMUNICATION "
5 "WHOLESALE & RETAIL TRADE "
6 "REAL ESTATE RENTING & BUSINESS SERVICES "
7 "HOTEL & RESTAURANTS "
8 "OTHER SERVICES "
9 "FARMING FISHING & FORESTRY "
10 "POWER GENERATION "
;

label values ind ind;

/* Dropping companies with 0 employees */
replace full_empqA=. if full_empqA==0;

gen size=full_empqA;

replace size=1 if Q2_3perm_full_emp>=1 & Q2_3perm_full_emp<10;
replace size=2 if Q2_3perm_full_emp>=10 & Q2_3perm_full_emp<50;
replace size=3 if Q2_3perm_full_emp>=50 & Q2_3perm_full_emp<100;
replace size=4 if Q2_3perm_full_emp>=100 & Q2_3perm_full_emp<200;
replace size=5 if Q2_3perm_full_emp>=200 & Q2_3perm_full_emp<500;
replace size=6 if Q2_3perm_full_emp>=500 & Q2_3perm_full_emp<10000;

label define codes4 
1 1_9 
2 10_49 
3 50_99 
4 100_199 
5 200_499 
6 500_9999;
label values size codes4;
label values full_empqA codes4;

/* Variable for size only on three categories, small medium and large */

gen sizeb=full_empqB;

label variable sizeb "FIRM SIZE, SMALL ,MEDIUM, LARGE";
label variable full_empqB "FIRM SIZE, SMALL ,MEDIUM, LARGE";

label define sizeb
1 "SMALL 0-50"
2 "MEDIUM 50-200"
3 "LARGE over 200";

label values sizeb sizeb;
label values full_empqB sizeb;

/* label to owned (FINACIAL STAKES IN YOUR ORGANIZATION)*/

label variable Q1ownedqA  "99 Y vs N FOREIGN COMPANY ";
label variable ownedqB  "PERCENTAGE FOREIGN COMPANY STAKE ";
label variable Q2_3ownedqC  "02 05 PERCENTAGE PRIVATE DOMESTIC ";
label variable Q1ownedqD  "99 Y vs N STATE ORGANIZATION ";


label variable ownedqE  "PERCENTAGE GOVERNMENT STATE ";
label variable Q2_3ownedqF  "02 05 PERCENTAGE OTHERS ";


/* label to owner (LARGEST SHAREHOLDER(S))*/

label variable owner  "LARGEST SHAREHOLDER(S) ";


label define  owner
1 "INDIVIDUAL "
2 "FAMILY "

4 "DOMESTIC COMPANY "
5 "FOREIGN COMPANY "
6 "FINANCIAL INSTITUTION "

8 "MANAGERS OF THE FIRM "
9 "EMPLOYEES OF THE FIRM "
10 "GOVERNMENT OR GOV. AGENCY "
11 "OTHER "
;


label values owner owner;

/* label to estb (HOW FIRM ESTABLISHED)*/

label variable  estb "HOW FIRM ESTABLISHED";


label define  estb
1 "PRIVATISATION OF STATE-OWNED FIRM"
2 "ORIGINALLY PRIVATE, FROM TIME OF START UP"
3 "PRIVATE SUBSIDIARY OF FORMELY STATE-OWNED FIRM"
4 "JOINT VENTURE WITH FOREIGN PARTNER(S)"
5 "OTHER"

7 "STATE OWNED COMPANY"
;


label values estb estb;
/* label to compt (HYPOTHETICAL QUESTION ON comptAND ELASTICITY)*/

label variable compt  "HYPOTHETICAL QUESTION ON comptAND ELASTICITY ";

label define  compt
1 "CUSTOMER BUY SAME QUANTITIES "
2 "CUSTOMER BUY SLIGHTLY LOWER QUANTITIES "
3 "CUSTOMER BUY MUCH LOWER QUANTITIES "
4 "CUSTOMER BUY FROM COMPETITORS "
;

/* label to cust (WHAT % OF DOMESTIC SALES ARE TO)*/

label variable  Q2_3custqA "GOVERNMENT, GOV. AGENCIES (EXCLUDING STATE-OWNED ENTERPRISES) (05)";
label variable  Q2_3custqB "MULTINATIONAL LOCATED IN YOUR COUNTRY(NOT INCLUDING PARENT COMPANY";
label variable  Q2_3custqC "YOUR FIRM'S PARENT COMPANY OR AFFILIATED SUBSIDIARIES";
label variable  Q2_3custqD "LARGE PRIVATE DOMESTIC FIRMS (APPR. >250 WORKERS)";
        label variable  Q3custqE1 "STATE-OWNED OR CONTROLLED ENTERPRISES (05)";
        label variable          Q3custqE2 "SMALL FIRMS AND INDIVIDUALS (05)";
        label variable          Q3custqE3 "OTHER (EXLUDING STATE & SMALL) (05)";
label variable  Q2_3custqE      "OTHER (INLCUDING STATE, SMALL & INDIVIDUAL)";

label values compt compt;

/* label to comps (NUMBER compsETITORS IN NATIONAL MARKET)*/

label variable comps  "NUMBER COMPETITORS IN NATIONAL MARKET ";

label define  comps
1 "NONE "
2 "1-3 "
3 "4 OR MORE "
;

label values comps comps;


/* label to constr (PROBLEMATIC FACTORS FOR GROWTH OF BUSINESS)*/;


/* label to constr (PROBLEMATIC FACTORS FOR GROWTH OF BUSINESS)*/;

label define  constr
1 "NO OBSTACLE "
2 "MINOR OBSTACLE "
3 "MODERATE OBSTACLE "
4 "MAJOR OBSTACLE "
;

label   values  constrqA        constr;
label   values  constrqB        constr;
label   values  constrqC        constr;

label values Q2_3constrqC1  constr;
label values Q2_3constrqC2  constr;
label values Q2_3constrqC3  constr;
label values Q2_3constrqC4  constr;
label values Q2_3constrqC5  constr;

label   values  constrqD        constr;
label   values  constrqE        constr;
label   values  constrqF        constr;
label   values  constrqG        constr;
label   values  constrqH        constr;
label   values  Q2_3constrqI    constr;
label   values  constrqJ        constr;
label   values  constrqK        constr;
label   values  constrqL        constr;
label   values  constrqM        constr;
label   values  constrqN        constr;
label   values  constrqO        constr;
label   values  constrqP        constr;
label   values  Q2_3constrqQ    constr;
label   values  Q1_3constrqR    constr;
label   values  Q1constrqS      constr;



/* label to perf (SALES, EXPORTS & FIXED ASSETS CHANGE IN REAL TERMS)*/;

label variable perfqA   "SALES categories ";
label variable perfqB   "Fixed Assets categories";
label variable perfqC   "EXPORTS categories ";
label variable Q1perfqD "99 EMPLOYMENT categories ";
label variable Q1perfqE "99 DEBT categories ";
label variable Q3perfqF "05 MATERIAL INPUT categories ";
label variable perfqG   "SALES % CHANGE ";
label variable perfqH   "Fixed Assets % CHANGE";
label variable perfqI   "EXPORTS % CHANGE ";
label variable perfqJ   "EMPLOYMENT % CHANGE ";
label variable Q1perfqK "99 DEBT % CHANGE ";
label variable Q3perfqL "05 MATERIAL INPUT % CHANGE ";
label variable perfqW   "Sales per worker % CHANGE ";

/*Note: in 1999 question 50 refers to Investment instead of Fixed Assets,
see note by Randolph Bruno, 21st September*/


/* label to perf (SALES, EXPORTS & FIXED ASSETS CHANGE IN REAL TERMS)*/;

label define  perf
-1 "DECREASE "
0 "NO CHANGE "
1 "INCREASE "
;

label values perfqA perf;
label values perfqB perf;
label values perfqC perf;
label values Q1perfqD perf;
label values Q1perfqE perf;
label values Q3perfqF perf;

/* label to initiative  (INITIATIVES OVER THE LAST 3 YEARS)*/;

label   variable        initiativeqA "DEVELOP MAJOR NEW PRODUCT ";
label   variable        initiativeqB "UPGRADING AN EXISTING PRODUCT ";
label   variable        initiativeqC "DISCONTINUED AT LEAST 1 PRODUCT ";
label   variable        initiativeqD "JOINT VENTURE WITH FOREIGN PARTNER ";
label   variable        initiativeqE "NEW PRODUCT LICENSING AGREEMENT ";
label   variable        initiativeqF "OUTSORCED A MAJOR PRODUCTION ";
label   variable        Q2_3initiativeqG "BROUGHT IN-HOUSE A MAJOR PRODUCTION ";
label   variable        initiativeqH "QUALITY ACCREDITATION ";
label   variable        Q1_2initiativeqI "OPENING NEW PLANT ";
label   variable        Q1_2initiativeqJ "CLOSE EXISTING PLANT ";
label   variable        Q2initiativeqK "INTRODUCED A NEW TECHNOLOGY ";
label   variable        Q1initiativeqL "REDUCTION WORKFORCE GREATER THAN 10% ";
label   variable        Q1initiativeqM "INCREASE WORKFORCE GREATER THAN 10% ";
label   variable        initiativeqN "CHANGE MAIN SUPPLIER ";
label   variable        initiativeqO "CHANGE MAIN CUSTOMER ";
label   variable        initiativeqP "EXPORT TO NEW COUNTRY ";
label   variable        Q1initiativeqQ "CHANGE MAIN BANK ";
label   variable        initiativeqR "NONE OF THE PREVIOUS ";


/* label to initiative (INITIATIVES OVER THE LAST 3 YEARS)*/;

label define initiative
0 "NO "
1 "YES "
;

label   values  initiativeqA    initiative;
label   values  initiativeqB    initiative;
label   values  initiativeqC    initiative;
label   values  initiativeqD    initiative;
label   values  initiativeqE    initiative;
label   values  initiativeqF    initiative;
label   values  Q2_3initiativeqG        initiative;
label   values  initiativeqH    initiative;
label   values  Q1_2initiativeqI        initiative;
label   values  Q1_2initiativeqJ        initiative;
label   values  Q2initiativeqK  initiative;
label   values  Q1initiativeqL  initiative;
label   values  Q1initiativeqM  initiative;
label   values  initiativeqN    initiative;
label   values  initiativeqO    initiative;
label   values  initiativeqP    initiative;
label   values  Q1initiativeqQ  initiative;
label   values  initiativeqR    initiative;

/* label to  org (ORGANISATION OF DEPARTMENTS IN THE LAST 3 YEARS)*/;

label   variable        org "ORGANISTION OF THE DEPARTMENTS IN THE LAST 3 YEARS ";
label define  org
1 "SAME WAY "
2 "SOME REALLOCATION OF RESPONSABILITY & RESOURCES "
3 "MAJOR REALLOCATION OF RESPONSABILITY & RESOURCES "
4 "NEW ORGANISATIONAL STRUCTURE "
;

label values org org;

/* label to LAW, REGULATIONS AND UNOFFICIAL PAYMENT VARIABLES FOR 3 YEARS*/;

label   variable        pay_perc_sales  "UNOFFICAL PAYMENT AS % SALES";
label   variable        perc_cntr_val   "ADDITIONAL PAYMENT AS % CONTRACT VALUE";

        label define perc_cntr_val
        1 "0%"
        2 "UP TO 5%"
        3 "6-10%"
        4 "11-15%"
        5 "16-20%"
        6 ">20%"
        7 "DO NOT KNOW";

label values perc_cntr_val perc_cntr_val;

        label define pay_perc_sales
        1 "0%"
        2 "<1%"
        3 "1-1.99%"
        4 "2-9.99%"
        5 "10-12%"
        6 "13-25%"
        7 ">25%";

label values pay_perc_sales pay_perc_sales;
/* label to  pay_impct*/
label   variable pay_impctqA "IMPACT PRIV. PAYMENTS TO MEMBERS OF PARLAMENT";
label   variable pay_impctqB "IMPACT PRIV. PAYMENTS TO GOV. OFFICIALS FOR GOV. DECREES INFLUENCE";
label   variable Q3pay_impctqBloc "IMPACT PRIV. PAYMENTS TO LOC. OFFICIALS FOR LOC. DECREES INFLUENCE";
label   variable Q1_2pay_impctqC "IMPACT PRIV. PAYMENTS TO JUDGES IN CRIMINAL COURT";
label   variable Q1_2pay_impctqD "IMPACT PRIV. PAYMENTS TO JUDGES IN COMMERCIAL COURT";
label   variable Q1_2pay_impctqE "IMPACT PRIV. PAYMENTS TO CENTRAL BANK";
label   variable Q1_2pay_impctqF "IMPACT PRIV. PAYMENTS TO POLITICAL PARTIES OR ELECTION CAMPAIGNS";
label   variable Q1pay_impctqG "IMPACT PRIV. PAYMENTS TO PUB. OFF. TO AVOID TAXES";
label   variable Q1pay_impctqH "IMPACT PRIV. PAYMENTS TO PUB. OFF. TO HIRING FAVORS";

        label define  pay_impct
        0 "NO IMPACT"
        1 "MINOR IMPACT"
        2 "MODERATE IMPACT"
        3 "MAJOR IMPACT"
        4 "DECISIVE IMPACT";
label values pay_impctqA pay_impct;
label values pay_impctqB pay_impct;
label values Q3pay_impctqBloc pay_impct;
label values Q1_2pay_impctqC pay_impct;
label values Q1_2pay_impctqD pay_impct;
label values Q1_2pay_impctqE pay_impct;
label values Q1_2pay_impctqF pay_impct;
label values Q1pay_impctqG pay_impct;
label values Q1pay_impctqH pay_impct;

/* label to LAW, REGULATIONS AND UNOFFICIAL PAYMENT VARIABLES FOR 2002 2005 ONLY*/
label   variable        Q2_3serv_ass1 "VALUE OF LOBBYING GOVERNMENT";
label   variable        Q2_3serv_ass2 "VALUE OF RESOLUTION OF DISPUTES";
label   variable        Q2_3serv_ass3 "VALUE OF INFORMATION & CONTACTS ON DOMESTIC PRODUCT-INPUTS";
label   variable        Q2_3serv_ass4 "VALUE OF INFORMATION & CONTACTS ON FOREIGN PRODUCT-INPUTS";
label   variable        Q2_3serv_ass5 "VALUE OF ACCREDITING STANDARDS";
label   variable        Q2_3serv_ass6 "VALUE OF INFO ON GOV. REGULATIONS";

label   variable        Q2_3seek_infl "SEEK INFLUENCE THE CONTENT OF LAW?";

label values Q2_3seek_infl initiative;

/* label to  OPTIONS IN value of */

        label define  Q2_3serv_ass
        0 "NO VALUE"
        1 "MINOR VALUE"
        2 "MODERATE VALUE"
        3 "MAJOR VALUE"
        4 "CRITICAL VALUE";
label values Q2_3serv_ass1 Q2_3serv_ass;
label values Q2_3serv_ass2 Q2_3serv_ass;
label values Q2_3serv_ass3 Q2_3serv_ass;
label values Q2_3serv_ass4 Q2_3serv_ass;
label values Q2_3serv_ass5 Q2_3serv_ass;
label values Q2_3serv_ass6 Q2_3serv_ass;

/* label to LAW, REGULATIONS AND UNOFFICIAL PAYMENT VARIABLES FOR 1999 2002 ONLY*/


        label define CODE_1_2
        1 "YES"
        2 "NO";
label values Q2_3seek_infl      CODE_1_2;
label values ias                        CODE_1_2;
label values sell_out           CODE_1_2;
label values ops_abro           CODE_1_2;
label values extrnl_adtr        CODE_1_2;

/* label to PERMISSION FOR FUTURE INTERVIEW*/;
label   variable        Q2_3permis "PERMISSION FOR FUTURE INTERVIEW";
label values Q2_3permis         CODE_1_2;

/* label to % SALES REPORTED FOR TAXES*/;
label   variable perc_sales_tax "% SALES REPORTED FOR TAXES";

        label define perc_sales_tax
        1 "100%"
        2 "90-100%"
        3 "80-90%"
        4 "70-80%"
        5 "60-70%"
        6 "50-60%"
        7 "25-50"
        8 "<=25%";
label values perc_sales_tax perc_sales_tax;


/* label to REASON FOR REFUSAL TO PARTICIPATE IN THE PANEL*/;
label   variable        Q2reason05 "REASON FOR REFUSAL TO PARTICIPATE IN THE PANEL";

label define Q2reason05
1 "Refused"                
2 "Wrong contact details"          
3 "No longer exists"       
4 "Non eligible"   
5 "Contacted 5 times";

label values Q2reason05 Q2reason05;     

/* label to SKILL LEVELS IN THE WORKFORCE*/;

label   variable Q2_3ft_wrk_catqA "% MANAGERS (02 05)";
label   variable Q2_3ft_wrk_catqB "% PROFESSIONALS (02 05)";
label   variable Q2_3ft_wrk_catqC "% SKILLED WORKERS (02 05)";
label   variable Q2_3ft_wrk_catqD "% UNSKILLED WORKERS (02 05)";
label   variable Q2_3ft_wrk_catqE "% NON-PRODUCTION WORKERS (02 05)";


/* label to EDUCATION LEVELS IN THE WORKFORCE*/;

label   variable Q2_3edu_lbrqA "% UP TO PRIMARY SCHOOL (02 05)";
label   variable Q2_3edu_lbrqB "% VOCATIONAL QUALIFICATION (02 05)";
label   variable Q2_3edu_lbrqC "% SECONDARY SCHOOL QUALIFICATION (02 05)";
label   variable Q2_3edu_lbrqD "% SOME UNIVERSITY EDCUATION OR HIGHER (02 05)";

/* label to LABOUR RIGIDITY*/;

label   variable Q2_3chg_wkfc "% HYPTHETICAL CHANGE IN LABOUR FORCE IF NO CONSTRAINTS (02 05)";

/* label to NUMBER OF COMPETITORS*/;

label var nocomp "NUMBER OF COMPETITORS";
label define cmptt 
1 "NO COMPETITORS" 
2 "1-3 COMPETITORS" 
3 "MORE THAN 3 COMPETITORS";
label values nocomp cmptt;

label var nocompR "NUMBER OF COMPETITORS RETROSPECTIVE";
label values nocompR cmptt;

/*CAPTURING VARIABLES CODING*/

label variable memb_lobby "MEMBER OF ASSOCIATION OR LOBBY?";
label variable Q2_3serv_ass1 "LOBBYING GOVERNMENT";
label variable Q2_3serv_ass2 "RESOLUTION OF DISOUTES";
label variable Q2_3serv_ass3 "INFO & CONTACTS ON DOMESTIC PRODUCT-INPUTS";
label variable Q2_3serv_ass4 "INFO & CONTACTS ON INTERNATIONAL PRODUCT-INPUTS";
label variable Q2_3serv_ass5 "ACCREDITING STANDARDS OR QUALITY";
label variable Q2_3serv_ass6 "INFO ON GOV. REGULATIONS";

label values Q2_3serv_ass1 Q2_3serv_ass;
label values Q2_3serv_ass2 Q2_3serv_ass;
label values Q2_3serv_ass3 Q2_3serv_ass;
label values Q2_3serv_ass4 Q2_3serv_ass;
label values Q2_3serv_ass5 Q2_3serv_ass;
label values Q2_3serv_ass6 Q2_3serv_ass;


label variable time_pub_off_cat "% of SENIOR MANAGEMENT TIME SPENT WITH GOV. OFFICIALS";

label define time_pub_off_cat
1 "up to 1%"
2 "1-5%"
3 "6-10%"
4 "11-25%"
5 "26-50%"
6 "more than 50%";

label values time_pub_off_cat time_pub_off_cat;
label define memb_lobby
1 "YES"
2 "NO";
label values memb_lobby memb_lobby;

label variable pay_reasonqA "CONNECTED PUBLIC SERVICES";
label variable pay_reasonqB "BUSINESS LICENSING";
label variable pay_reasonqC "GOV. CONTRACTS";
label variable Q2_3pay_reasonqD "OCCUPATIONAL HEALTH AND SAFETY";
label variable Q2_3pay_reasonqE "FIRE AND BULDINGS INSPECTIONS";
label variable Q2_3pay_reasonqF "ENVIRONMENTAL INSPECTIONS";
label variable pay_reasonqG "TAXES AND TAX COLLECTION";
label variable pay_reasonqH "CUSTOM-IMPORTS";
label variable pay_reasonqI "DEAL WITH COURTS";
label variable pay_reasonqJ "NEW LEGISLATION RULES";
label variable pay_reasonqK "OTHER";

label define pay_reason
1 "NEVER"
2 "SELDOM"
3 "SOMETIMES"
4 "FREQUENTLY"
5 "USUALLY"
6 "ALWAYS";

label values pay_reasonqA pay_reason;
label values pay_reasonqB pay_reason;
label values pay_reasonqC pay_reason;
label values Q2_3pay_reasonqD pay_reason;
label values Q2_3pay_reasonqE pay_reason;
label values Q2_3pay_reasonqF pay_reason;
label values pay_reasonqG pay_reason;
label values pay_reasonqH pay_reason;
label values pay_reasonqI pay_reason;
label values pay_reasonqJ pay_reason;
label values pay_reasonqK pay_reason;

save data/temp_data, replace;
compress;

**********************************************************************************
SELECTING THE THE VARIABLES TO KEEP IN THE DATABASE
**********************************************************************************;
keep

man_over
id_merge
year
regmacro
age
age2
Q3val_add
Q3val_add1
Q3val_add_new
mats
matsp
cost
wages
mats
matsp

cost2
cost_mat
cost_pers
cost_nrg

LQ3val_add1
init_index
init_index_dual
Q2_3salesonemp
Q2_3salesonemp_new
LQ2_3salesonemp

Q3panel
Q2reason05
Q2_3permis

country
country1
reg

cardno          
serialno        

size    
sizeb
                
Q2_3yugo                
citytown                
Q3region                
Q3srl_no2002            
start           

legstqA
legstqB

ind

Q2_3main_prdc
prod4DIG
prod2DIG
prod1DIG
                
full_empqA
full_empqB
Q1full_empqC

Q1ownedqA
ownedqB
Q2_3ownedqC
Q1ownedqD
ownedqE
Q2_3ownedqF

natl_forgnqA
natl_forgnqB
sell_out                
exp_prc_sales

Q2_3plants              

ops_abro                

job_titleqA
job_titleqB
job_titleqC
job_titleqD
job_titleqE
job_titleqF
job_titleqG
job_titleqH
job_titleqI
job_titleqJ

Q2_3sale_sctrqA
Q2_3sale_sctrqB
Q2_3sale_sctrqC
Q2_3sale_sctrqD
Q2_3sale_sctrqE
Q2_3sale_sctrqF
Q2_3sale_sctrqG
Q2_3sale_sctrqH

owner

estb

Q2_3custqA
Q2_3custqB
Q2_3custqC
Q2_3custqD

Q3custqE1
Q3custqE2
Q3custqE3
Q2_3custqE

Q2_3priv                                

Q2_3imp_cmpt            

compt           
comps           
Q2_3ex_comps_ntl
Q3compsR
Q3ex_comps_ntlR
Q3c_local       
Q3comps_local
Q3comps_localR
Q3ex_comps_loc
Q3ex_comps_locR
nocomp
nocompR
exnocomR

Q1_2mkt_salesqA
Q1_2mkt_salesqB
markupqA

Q2_3inputqA
Q2_3inputqB
Q2_3inputqC
custm_dly               
Q2_3suppl_prc           
Q2_3dys_inf_dfcqA
Q2_3dys_inf_dfcqB
Q2_3dys_inf_dfcqC
Q2_3int_clntsqA
Q2_3int_clntsqB
Q2_3int_clntsqC
Q2_3int_clntsqD
Q2_3int_clntsqE
Q2_3dys_dly_srvcqA
Q2_3dys_dly_srvcqB

court_sys_prcptqA
court_sys_prcptqB
court_sys_prcptqC
court_sys_prcptqD
court_sys_prcptqE
Q1court_sys_prcptqF

conf_lgl_systm          
Q1conf_lgl_systmR               

Q2_3sale_prpaid         
Q2_3sal_cred            
Q2_3ovrdue_pymnt                
Q2_3days_rslv_pymnt             
Q2_3pay_scrtyqA
Q2_3pay_scrtyqB
Q2_3pay_prtctnqA
Q2_3pay_prtctnqB
Q2_3lossesqA
Q2_3lossesqB

info_laws               
intrp_laws              
Q1intrp_lawsR           

Q1_2prdc_law            

time_pub_off_cat                
Q2_3time_pub_off_prc

unoff_pay               

memb_lobby              


Q2_3seek_infqA
Q2_3seek_infqB
add_pay         
know_add_pay            
pay_perc_sales
Q2_3pay_perc_sales_prc          
pay_reasonqA
pay_reasonqB
pay_reasonqC
Q2_3pay_reasonqD
Q2_3pay_reasonqE
Q2_3pay_reasonqF
pay_reasonqG
pay_reasonqH
pay_reasonqI
pay_reasonqJ
pay_reasonqK
perc_cntr_val
Q2_3perc_cntr_val_prc           
perc_sales_tax          

pay_impctqA
pay_impctqB
Q3pay_impctqBloc
Q1_2pay_impctqC
Q1_2pay_impctqD
Q1_2pay_impctqE
Q1_2pay_impctqF
Q1pay_impctqG
Q1pay_impctqH

Q2_3source_fin_capqA
Q2_3source_fin_capqB
Q2_3source_fin_capqC
Q2_3source_fin_capqD
Q2_3source_fin_capqE
Q2_3source_fin_capqF
Q2_3source_fin_capqG
Q2_3source_fin_capqH
Q2_3source_fin_capqI
Q2_3source_fin_capqJ
Q2_3source_fin_capqK
Q2_3source_fin_capqL
Q2_3source_fin_capqM
Q2_3source_fin_capqN

source_fin_invqA
source_fin_invqB
source_fin_invqC
source_fin_invqD
Q2_3source_fin_invqE
source_fin_invqF
source_fin_invqG
source_fin_invqH
Q2_3source_fin_invqI
Q2_3source_fin_invqJ
source_fin_invqK
source_fin_invqL
source_fin_invqM
source_fin_invqN
Q1source_fin_invqO

Q2_3cltrl_loan          
Q2_3val_cltrl           
Q2_3loan_cost           
Q2_3loan_drtn           
Q2_3days_get_loan               
ias             
extrnl_adtr             
Q1_2days_trans_domqA

Q1days_trans_domRqA

Q1_2days_trans_frgnqA

Q1days_trans_frgnRqA

sales_bartrqA
sales_bartrqB
sales_bartrqC
sales_bartrqD
sales_bartrqE
sales_bartrqF
Q2_3purchs_bartrqA
Q2_3purchs_bartrqB
Q2_3purchs_bartrqC
Q2_3purchs_bartrqD
Q2_3purchs_bartrqE
Q2_3purchs_bartrqF
Q2_3ovrd_pymt_ctgqA
Q2_3ovrd_pymt_ctgqB
Q2_3ovrd_pymt_ctgqC
Q2_3ovrd_pymt_ctgqD
Q2_3ovrd_pymt_perqA
Q2_3ovrd_pymt_perqB
Q2_3ovrd_pymt_perqC
Q2_3ovrd_pymt_perqD

subsdsqA
Q2_3subsdsqA1
Q2_3subsdsqA2
Q3subsdsqB
Q2_3subsdsqC
Q1subsdsR               

Q2_3sub_perc_slsqA
Q2_3sub_perc_slsqB
Q2_3sub_perc_slsqC
Q2_3sub_perc_slsqD

Q1constrqA1
Q1constrqA2
Q1constrqA3
Q1constrqA4
Q1constrqA5
Q1constrqA6
Q1constrqA7
Q1constrqA8
Q1constrqA9
constrqA
Q1constrqB1
Q1constrqB2
Q1constrqB3
constrqB
Q2_3constrqC1
Q2_3constrqC2
Q2_3constrqC3
Q2_3constrqC4
Q2_3constrqC5
constrqC
constrqD
constrqE

constrqF
Q1constrqG1
Q1constrqG2
Q1constrqG3
constrqG
constrqH
Q2_3constrqI
constrqJ
Q1constrqK1
Q1constrqK2
constrqK
constrqL
constrqM
constrqN
constrqO
constrqP
Q2_3constrqQ
Q1_3constrqR
Q1constrqS

constrqALL15

perfqA
perfqB
perfqC
Q1perfqD
Q1perfqE
Q3perfqF
perfqG
perfqH
perfqI
perfqJ
perfqJ_winsor
Q1perfqK
Q3perfqL
Q1perfqM
Q1perfqN
Q1perfqO
Q1perfqP
Q1perfqQ
Q1perfqR
Q1perfqS
Q1perfqT
Q1perfqU
Q1perfqV
perfqW
perfqW_winsor

Q2_3sales_per
sales_cat

Q2_3fixed_assts_per
fixed_assts_cat
                
Q1debts_val             
Q2debts_per
Q2debts_perR

Q2gr_prfts
Q2gr_prftsR             
Q2_3prfts_invst_cat     
Q3no_prfts                      
Q3prfts_invst_per       

initiativeqA
initiativeqB
initiativeqC
initiativeqD
initiativeqE
initiativeqF
Q2_3initiativeqG
initiativeqH
Q1_2initiativeqI
Q1_2initiativeqJ
Q2initiativeqK
Q1initiativeqL
Q1initiativeqM
initiativeqN
initiativeqO
initiativeqP
Q1initiativeqQ
initiativeqR

org             

new_prdctqA
new_prdctqB
new_prdctqC
Q1_2new_prdctqD
Q1_2new_prdctqE
Q1_2new_prdctqF

reduc_costqA
reduc_costqB
reduc_costqC
Q1_2reduc_costqD
Q1_2reduc_costqE
Q1_2reduc_costqF

Q2_3cap_utl             
Q2_3cap_utlR            
Q2_3perm_full_emp               
Q2_3perm_full_empR              
Q2_3part_tm_emp         
Q2_3part_tm_empR
Q2_3TOT_emp
Q2_3TOT_empR            
Q2_3ft_wrk_catqA
Q2_3ft_wrk_catqB
Q2_3ft_wrk_catqC
Q2_3ft_wrk_catqD
Q2_3ft_wrk_catqE
Q3ft_wrk_catRqA
Q3ft_wrk_catRqB
Q3ft_wrk_catRqC
Q3ft_wrk_catRqD
Q3ft_wrk_catRqE

Q2edu_lbrqA1
Q2edu_lbrqA2
Q2_3edu_lbrqA
Q2_3edu_lbrqB
Q2_3edu_lbrqC
Q2edu_lbrqD1
Q2edu_lbrqD2
Q2_3edu_lbrqD

Q3edu_lbrRqA
Q3edu_lbrRqB
Q3edu_lbrRqC
Q3edu_lbrRqD

Q2_3time_vacqA
Q2_3time_vacqB
Q2_3time_vacqC
Q2_3time_vacqD
Q2_3time_vacqE

Q2trainingqA1
Q2trainingqA2
Q2_3trainingqA
Q2_3trainingqB
Q2_3trainingqC  
Q2trainingqD

Q2per_trainedqA1
Q2per_trainedqA2
Q2_3per_trainedqA
Q2_3per_trainedqB
Q2_3per_trainedqC
Q2per_trainedqD


Q2_3days_lostqA
Q2_3days_lostqB


Q1wkfc_levelqA
Q1wkfc_levelqB
Q2_3chg_wkfc

Q2_3serv_ass1
Q2_3serv_ass2
Q2_3serv_ass3
Q2_3serv_ass4
Q2_3serv_ass5
Q2_3serv_ass6

Q2_3seek_infl

Q2_3exp_delays_av
Q2_3exp_delays_max

Q2_3custm_dly_max

Q3hrs_inf_dfcA
Q3hrs_inf_dfcB
Q3hrs_inf_dfcC

Q3loss_inf_dfcA
Q3loss_inf_dfcB
Q3loss_inf_dfcC

Q3shipm_lossA
Q3shipm_lossB

Q3overdue_cases
Q3no_court_act

Q2_3perc_court_act

Q3pay_scrty_value

Q3insp_tax
Q3insp_labr
Q3insp_fire
Q3insp_sanit
Q3insp_polic
Q3insp_envir
Q3insp_cust

Q3insp_tax_no
Q3insp_labr_no
Q3insp_fire_no
Q3insp_sanit_no
Q3insp_polic_no
Q3insp_envir_no
Q3insp_cust_no

Q3insp_tax_dur
Q3insp_labr_dur
Q3insp_fire_dur
Q3insp_sanit_dur
Q3insp_polic_dur
Q3insp_envir_dur
Q3insp_cust_dur

perc_sales_tax

Q2_3subsd_nat_gov
Q2_3subsd_reg_gov
Q2_3subsd_other

Q2_3subsd_nat_gov_ps
Q2_3subsd_reg_gov_ps
Q2_3subsd_other_ps

Q2collat_type

Q2_3sales_cash_bank
Q2_3sales_bills
Q2_3sales_offsets
Q2_3sales_bart
Q2_3sales_other


Q2_3purch_cash_bank
Q2_3purch_bills
Q2_3purch_offsets
Q2_3purch_bart
Q2_3purch_other

Q3subsd_EU
Q3subsd_EU_ps
Q3gaap
Q3nat_acc_stand
Q3why_no_loan
Q3why_no_appl
Q3loan_reject
Q3check_acc
Q3sav_acc
Q3collat_type
Q2collat_type
Q3loan_curr
Q2_3sal_prpd
Q3sal_pd_dlvr
Q2_3plantiff
Q2_3defendant
Q3ext_cons
Q3wrkfrc_decl
Q3wage_decl;

save data/temp_data, replace;


/*procedure to keep the file containing only the variables 
for which there is no compatibility
problem among the 3 years*/;

use data/temp_data;
compress;

keep

man_over
id_merge
regmacro
year
Q2reason05
Q2_3permis

Q3val_add
Q3val_add1
mats
matsp
cost
wages
mats
matsp

cost2
cost_mat
cost_pers
cost_nrg

Q3val_add_new
LQ3val_add1
init_index
init_index_dual
Q2_3salesonemp
Q2_3salesonemp_new
LQ2_3salesonemp
LQ3
age 

age2

Q3panel
country
country1
reg

size
sizeb

cardno
serialno
Q2_3yugo
citytown
Q3region
Q3srl_no2002
start

legstqA
legstqB

ind

Q2_3main_prdc
prod4DIG
prod2DIG
prod1DIG

full_empqA
full_empqB
Q1full_empqC

Q1ownedqA
ownedqB
Q2_3ownedqC
Q1ownedqD
ownedqE
Q2_3ownedqF

sell_out
exp_prc_sales

Q2_3plants
ops_abro

Q2_3sale_sctrqA
Q2_3sale_sctrqB
Q2_3sale_sctrqC
Q2_3sale_sctrqD
Q2_3sale_sctrqE
Q2_3sale_sctrqF
Q2_3sale_sctrqG
Q2_3sale_sctrqH
owner
estb
Q2_3custqA
Q2_3custqB
Q2_3custqC
Q2_3custqD
Q3custqE1
Q3custqE2
Q3custqE3
Q2_3custqE

Q2_3priv
Q2_3imp_cmpt

compt           
comps           
Q2_3ex_comps_ntl
Q3compsR
Q3ex_comps_ntlR
Q3c_local       
Q3comps_local
Q3comps_localR
Q3ex_comps_loc
Q3ex_comps_locR
nocomp
nocompR
exnocomR

markupqA

Q2_3inputqA
Q2_3inputqB
Q2_3inputqC
custm_dly
Q2_3suppl_prc
Q2_3dys_inf_dfcqA
Q2_3dys_inf_dfcqB
Q2_3dys_inf_dfcqC
Q2_3int_clntsqA
Q2_3int_clntsqB
Q2_3int_clntsqC
Q2_3int_clntsqD
Q2_3int_clntsqE
Q2_3dys_dly_srvcqA
Q2_3dys_dly_srvcqB

court_sys_prcptqA
court_sys_prcptqB
court_sys_prcptqC
court_sys_prcptqD
court_sys_prcptqE
Q1court_sys_prcptqF

conf_lgl_systm
Q1conf_lgl_systmR

Q2_3sal_cred
Q2_3ovrdue_pymnt
Q2_3days_rslv_pymnt
Q2_3pay_scrtyqA
Q2_3pay_scrtyqB
Q2_3pay_prtctnqA
Q2_3pay_prtctnqB
Q2_3lossesqA
Q2_3lossesqB

Q2_3pay_perc_sales_prc
info_laws               
intrp_laws              
Q1intrp_lawsR

time_pub_off_cat
Q2_3time_pub_off_prc
unoff_pay
memb_lobby

pay_reasonqA
pay_reasonqB
pay_reasonqC
Q2_3pay_reasonqD
Q2_3pay_reasonqE
Q2_3pay_reasonqF
pay_reasonqG
pay_reasonqH
pay_reasonqI
pay_reasonqJ
pay_reasonqK

add_pay
know_add_pay
Q2_3source_fin_capqA
Q2_3source_fin_capqB
Q2_3source_fin_capqC
Q2_3source_fin_capqD
Q2_3source_fin_capqE
Q2_3source_fin_capqF
Q2_3source_fin_capqG
Q2_3source_fin_capqH
Q2_3source_fin_capqI
Q2_3source_fin_capqJ
Q2_3source_fin_capqK
Q2_3source_fin_capqL
Q2_3source_fin_capqM
Q2_3source_fin_capqN

source_fin_invqA
source_fin_invqB
source_fin_invqC
source_fin_invqD
Q2_3source_fin_invqE
source_fin_invqF
source_fin_invqG
source_fin_invqH
Q2_3source_fin_invqI
Q2_3source_fin_invqJ
source_fin_invqK
source_fin_invqL
source_fin_invqM
source_fin_invqN
Q1source_fin_invqO

Q2_3cltrl_loan          
Q2_3val_cltrl           
Q2_3loan_cost           
Q2_3loan_drtn           
Q2_3days_get_loan               

ias
extrnl_adtr
Q1_2days_trans_domqA
Q1days_trans_domRqA
Q1_2days_trans_frgnqA
Q1days_trans_frgnRqA
subsdsqA
Q2_3subsdsqA1
Q2_3subsdsqA2
Q3subsdsqB
Q2_3subsdsqC
Q1subsdsR
Q1constrqA1
Q1constrqA2
Q1constrqA3
Q1constrqA4
Q1constrqA5
Q1constrqA6
Q1constrqA7
Q1constrqA8
Q1constrqA9
constrqA
Q1constrqB1
Q1constrqB2
Q1constrqB3
constrqB
Q2_3constrqC1
Q2_3constrqC2
Q2_3constrqC3
Q2_3constrqC4
Q2_3constrqC5
constrqC
constrqD
constrqE

constrqF
Q1constrqG1
Q1constrqG2
Q1constrqG3
constrqG
constrqH
Q2_3constrqI
constrqJ
Q1constrqK1
Q1constrqK2
constrqK
constrqL
constrqM
constrqN
constrqO
constrqP
Q2_3constrqQ
Q1_3constrqR
Q1constrqS

constrqALL15

perfqA
perfqB
perfqC
Q1perfqD
Q1perfqE
Q3perfqF
perfqG
perfqH
perfqI
perfqJ
perfqJ_winsor
Q1perfqK
Q3perfqL
Q1perfqM
Q1perfqN
Q1perfqO
Q1perfqP
Q1perfqQ
Q1perfqR
Q1perfqS
Q1perfqT
Q1perfqU
Q1perfqV
perfqW
perfqW_winsor

Q2_3sales_per
sales_cat

Q2_3fixed_assts_per
fixed_assts_cat

Q1debts_val             
Q2debts_per
Q2debts_perR

Q2gr_prfts
Q2gr_prftsR

Q2_3prfts_invst_cat
Q3no_prfts      
Q3prfts_invst_per

initiativeqA
initiativeqB
initiativeqC
initiativeqD
initiativeqE
initiativeqF
Q2_3initiativeqG
initiativeqH
Q1_2initiativeqI
Q1_2initiativeqJ
Q2initiativeqK
Q1initiativeqL
Q1initiativeqM
initiativeqN
initiativeqO
initiativeqP
Q1initiativeqQ
initiativeqR

org

new_prdctqA     
new_prdctqB
new_prdctqC     
Q1_2new_prdctqD 
Q1_2new_prdctqE 
Q1_2new_prdctqF 

reduc_costqA
reduc_costqB
reduc_costqC
Q1_2reduc_costqD
Q1_2reduc_costqE
Q1_2reduc_costqF

Q2_3cap_utl
Q2_3cap_utlR
Q2_3perm_full_emp
Q2_3perm_full_empR
Q2_3part_tm_emp
Q2_3part_tm_empR
Q2_3TOT_emp
Q2_3TOT_empR
Q2_3ft_wrk_catqA
Q2_3ft_wrk_catqB
Q2_3ft_wrk_catqC
Q2_3ft_wrk_catqD
Q2_3ft_wrk_catqE
Q3ft_wrk_catRqA
Q3ft_wrk_catRqB
Q3ft_wrk_catRqC
Q3ft_wrk_catRqD
Q3ft_wrk_catRqE

Q2edu_lbrqA1
Q2edu_lbrqA2
Q2_3edu_lbrqA
Q2_3edu_lbrqB
Q2_3edu_lbrqC
Q2edu_lbrqD1
Q2edu_lbrqD2
Q2_3edu_lbrqD

Q3edu_lbrRqA
Q3edu_lbrRqB
Q3edu_lbrRqC
Q3edu_lbrRqD

Q2_3time_vacqA
Q2_3time_vacqB
Q2_3time_vacqC
Q2_3time_vacqD
Q2_3time_vacqE

Q2trainingqA1
Q2trainingqA2
Q2_3trainingqA
Q2_3trainingqB
Q2_3trainingqC  
Q2trainingqD

Q2per_trainedqA1
Q2per_trainedqA2
Q2_3per_trainedqA
Q2_3per_trainedqB
Q2_3per_trainedqC
Q2per_trainedqD

Q2_3days_lostqA
Q2_3days_lostqB

Q1wkfc_levelqA
Q1wkfc_levelqB
Q2_3chg_wkfc

pay_perc_sales
Q2_3pay_perc_sales_prc
perc_cntr_val
Q2_3perc_cntr_val_prc

Q2_3serv_ass1
Q2_3serv_ass2
Q2_3serv_ass3
Q2_3serv_ass4
Q2_3serv_ass5
Q2_3serv_ass6

Q2_3seek_infl
pay_impctqA
pay_impctqB
Q3pay_impctqBloc
Q1_2pay_impctqC
Q1_2pay_impctqD
Q1_2pay_impctqE
Q1_2pay_impctqF
Q1pay_impctqG
Q1pay_impctqH

perc_sales_tax
Q2_3ovrd_pymt_ctgqA
Q2_3ovrd_pymt_ctgqB
Q2_3ovrd_pymt_ctgqC
Q2_3ovrd_pymt_ctgqD
Q2_3ovrd_pymt_perqA
Q2_3ovrd_pymt_perqB
Q2_3ovrd_pymt_perqC
Q2_3ovrd_pymt_perqD

Q2_3exp_delays_av
Q2_3exp_delays_max

Q2_3custm_dly_max

Q3hrs_inf_dfcA
Q3hrs_inf_dfcB
Q3hrs_inf_dfcC

Q3loss_inf_dfcA
Q3loss_inf_dfcB
Q3loss_inf_dfcC

Q3shipm_lossA
Q3shipm_lossB

Q3overdue_cases
Q3no_court_act

Q2_3perc_court_act

Q3pay_scrty_value

Q3insp_tax
Q3insp_labr
Q3insp_fire
Q3insp_sanit
Q3insp_polic
Q3insp_envir
Q3insp_cust

Q3insp_tax_no
Q3insp_labr_no
Q3insp_fire_no
Q3insp_sanit_no
Q3insp_polic_no
Q3insp_envir_no
Q3insp_cust_no

Q3insp_tax_dur
Q3insp_labr_dur
Q3insp_fire_dur
Q3insp_sanit_dur
Q3insp_polic_dur
Q3insp_envir_dur
Q3insp_cust_dur

Q2_3subsd_nat_gov
Q2_3subsd_reg_gov
Q2_3subsd_other

Q2_3subsd_nat_gov_ps
Q2_3subsd_reg_gov_ps
Q2_3subsd_other_ps

Q2collat_type

Q2_3sales_cash_bank
Q2_3sales_bills
Q2_3sales_offsets
Q2_3sales_bart
Q2_3sales_other


Q2_3purch_cash_bank
Q2_3purch_bills
Q2_3purch_offsets
Q2_3purch_bart
Q2_3purch_other
Q3subsd_EU
Q3subsd_EU_ps
Q3gaap
Q3nat_acc_stand
Q3why_no_loan
Q3why_no_appl
Q3loan_reject
Q3check_acc
Q3sav_acc
Q3collat_type
Q2collat_type
Q3loan_curr
Q2_3sal_prpd
Q3sal_pd_dlvr
Q2_3plantiff
Q2_3defendant
Q3ext_cons
Q3wrkfrc_decl
Q3wage_decl;

/*STATISTICS*/
/*
foreach var of varlist * {;
tabstat `var', by(year) stats(mean min max range sd n); 
}
;
*/

compress;
save data/data_recoded, replace;



log close;
