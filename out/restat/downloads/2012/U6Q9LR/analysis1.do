#delimit;

************************************************************;
****RESTAT RESUBMISSION TABLES******************************;
************************************************************;

clear;
set more off;
version 8.0;
cap log close;
log using analysis1.log, text replace;

set mem 2000000;
set matsize 800;

use /home/sblack/school_age/restat/ssa_data;
keep pid ability mental yr_test yob bmonth mpid eduy sex meduy ageyoung famsize
childnum schoolstart mnkids sesjondt;
*sample 5;

duplicates report pid;
duplicates drop pid, force;

*******Adjusted year of birth that goes from july to june;
gen alt_yob=yob if bmonth>=7;
replace alt_yob=yob-1 if bmonth<=6;

keep if bmonth~=. & alt_yob>=1963 & alt_yob<=1987;

******COHORT*******;
gen cohort=(yob-1961)+(bmonth)/12;
gen cohort2=cohort*cohort;
gen cohort3=(cohort*cohort2)/10;
gen cohort4=(cohort2*cohort2)/100;

*******Linear trend from july to june;
gen alt_mob=bmonth+6 if bmonth<=6;
replace alt_mob=bmonth-6 if bmonth>=7;

gen alt_mob_sq=alt_mob*alt_mob;

gen altm1=0;replace altm1=1 if alt_mob==1;
gen altm2=0;replace altm2=1 if alt_mob==2;
gen altm3=0;replace altm3=1 if alt_mob==3;
gen altm4=0;replace altm4=1 if alt_mob==4;
gen altm5=0;replace altm5=1 if alt_mob==5;
gen altm6=0;replace altm6=1 if alt_mob==6;
gen altm7=0;replace altm7=1 if alt_mob==7;
gen altm8=0;replace altm8=1 if alt_mob==8;
gen altm9=0;replace altm9=1 if alt_mob==9;
gen altm10=0;replace altm10=1 if alt_mob==10;
gen altm11=0;replace altm11=1 if alt_mob==11;
gen altm12=0;replace altm12=1 if alt_mob==12;

*Actual School Starting age;
gen ssa=(schoolstart-yob+.7)-((bmonth-1)/12);

*Expected School Starting age;
gen essa=7.7-((bmonth-1)/12);
drop if essa==.;
gen start_on_time=0;replace start_on_time=1 if essa==ssa;
gen start_early=0;replace start_early=1 if essa>ssa & ssa~=.;
gen start_late=0;replace start_late=1 if essa<ssa & ssa~=.;
replace start_on_time=. if ssa==.;
replace start_early=. if ssa==.;
replace start_late=. if ssa==.;

******************************************************;
***********TABLE 1************************************;
************COMPLIANCE RATES BY MONTH OF BIRTH********;
******************************************************;
sort bmonth;
by bmonth: su start_on_time start_early start_late;

************************************************************;
************END OF TABLE 1**********************************;
************************************************************;

***Imputing SSA for cases where it is missing;
replace ssa=essa if ssa==.;

*Some control variables;
replace childnum=10 if childnum>=10 & childnum~=.;
gen childn=childnum;replace childn=0 if childnum==.;
replace famsize=mnkids if famsize==. | (mnkids~=. & famsize<mnkids);
replace famsize=10 if famsize>=10 & famsize~=.;
gen famsiz=famsize;replace famsiz=0 if famsize==.;
gen medu=meduy;replace medu=0 if meduy==.;

***calculating age of mother when youngest child was born;
gen teen=0;replace teen=1 if ageyoung<20;
replace teen=. if ageyoung<13;

*Expected School Finishing age if stay 12 years;
gen esfa=essa+12;
gen child_before_finish=0;replace child_before_finish=1 if ageyoung<=esfa;
drop esfa;
replace child_before_finish=. if ageyoung<13;

*Mental Health;
gen mental_i=0;replace mental_i=1 if mental==9;replace mental_i=. if mental==.;

********USING ADO FILE THAT DOES 2-WAY CLUSTERING********************; 
gen mpid_b=mpid;
replace mpid_b=uniform() if mpid_b==.;
egen clust_both=group(mpid_b cohort);

***************************************************************;
*************FOR TABLE 2***************************************;
***************************************************************;
su ssa essa ability mental_i if sex==1;
su eduy if sex==1 & alt_yob<=1979; 
su ssa essa if sex==2;
su eduy if sex==2 & alt_yob<=1979; 
su teen child_before_finish if sex==2 & alt_yob<=1969;

***************************************************************;
*************END TABLE 2***************************************;
***************************************************************;

tempfile stuff;
save `stuff', replace;

**************************************************************;
*********IQ ESTIMATES*****************************************;
**************************************************************;
use `stuff';
keep if sex==1 & bmonth~=. & alt_yob>=1963 & alt_yob<=1987;
*keep ability sex bmonth yob pid yr_test cohort cohort2 cohort3 cohort4  
alt_mob alt_yob mpid sesjondt famsize mnkids childnum meduy eduy
ssa childn alt_mob_sq famsiz medu altm1-altm12 mental_i
mpid_b clust_both essa;

drop if yr_test<yob+16;
drop if yr_test>yob+21;

sort yob bmonth;
gen month_test=month(sesjondt);

su;

*****DETAILED AGE AT MEASUREMENT******;
replace month_test=1 if month_test==.;
gen age_iq=((yr_test-1961)+(month_test/12))- cohort;

drop if yr_test==.;
gen new_test=0;replace new_test=1 if yr_test>=1980;
su;
drop if new_test==0;*these cohorts should almost all have done the new test;

***********instrument for age_iq******************;
****year should have taken test****;
gen yr_s=yob+19 if yob<=1958;
replace yr_s=1977 if yob==1959 & bmonth<=2;
replace yr_s=1978 if yob==1959 & bmonth>2;
replace yr_s=1978 if yob==1960 & bmonth<=3;
replace yr_s=1979 if yob==1960 & bmonth>3;
replace yr_s=1979 if yob==1961 & bmonth<=3;
replace yr_s=1980 if yob==1961 & bmonth>3;
replace yr_s=1980 if yob==1962 & bmonth<=4;
replace yr_s=1981 if yob==1962 & bmonth>4;
replace yr_s=1981 if yob==1963 & bmonth<=5;
replace yr_s=1982 if yob==1963 & bmonth>5;
replace yr_s=1982 if yob==1964 & bmonth<=6;
replace yr_s=1983 if yob==1964 & bmonth>6;
replace yr_s=1983 if yob==1965 & bmonth<=7;
replace yr_s=1984 if yob==1965 & bmonth>7;
replace yr_s=1984 if yob==1966 & bmonth<=7;
replace yr_s=1985 if yob==1966 & bmonth>7;
replace yr_s=1985 if yob==1967 & bmonth<=5;
replace yr_s=1986 if yob==1967 & bmonth>5;
replace yr_s=1986 if yob==1968 & bmonth<=3;
replace yr_s=1987 if yob==1968 & bmonth>3;
replace yr_s=1987 if yob==1969 & bmonth<=3;
replace yr_s=1988 if yob==1969 & bmonth>3;
replace yr_s=1988 if yob==1970 & bmonth<=2;
replace yr_s=1989 if yob==1970 & bmonth>2;
replace yr_s=1989 if yob==1971 & bmonth<=1;
replace yr_s=1990 if yob==1971 & bmonth>1;
replace yr_s=1990 if yob==1972 & bmonth<=1;
replace yr_s=1991 if yob==1972 & bmonth>1;
replace yr_s=1991 if yob==1973 & bmonth<=2;
replace yr_s=1992 if yob==1973 & bmonth>2;
replace yr_s=1992 if yob==1974 & bmonth<=5;
replace yr_s=1993 if yob==1974 & bmonth>5;
replace yr_s=1993 if yob==1975 & bmonth<=8;
replace yr_s=1994 if yob==1975 & bmonth>8;
replace yr_s=1994 if yob==1976 & bmonth<=9;
replace yr_s=1995 if yob==1976 & bmonth>9;
replace yr_s=1995 if yob==1977 & bmonth<=10;
replace yr_s=1996 if yob==1977 & bmonth>10;
replace yr_s=1996 if yob==1978 & bmonth<=11;
replace yr_s=1997 if yob==1978 & bmonth>11;
replace yr_s=1997 if yob==1979;
replace yr_s=1998 if yob==1980;
replace yr_s=1999 if yob==1981;
replace yr_s=2000 if yob==1982;
replace yr_s=2001 if yob==1983 & bmonth<=4;
replace yr_s=2002 if yob==1983 & bmonth>4;
replace yr_s=2003 if yob==1984;
replace yr_s=2004 if yob==1985;
replace yr_s=2005 if yob==1986;
replace yr_s=2006 if yob==1987;
replace yr_s=2007 if yob==1988;

gen age_iq_inst=((yr_s-1961)+(6/12))- cohort;*assumes test is in month 6;

gen monthind=bmonth;replace monthind=1 if bmonth==1 | bmonth==12;
gen ontime=0;replace ontime=1 if yr_test==yr_s;

**************************************************;
**************TABLE 3*****************************;
**************************************************;
*First Stages;
xi:cgmreg ssa alt_mob i.alt_yob essa age_iq_inst if ability~=., cluster(cohort mpid_b);
xi:cgmreg age_iq alt_mob i.alt_yob essa age_iq_inst if ability~=., cluster(cohort mpid_b);
xi:cgmreg ssa i.alt_yob essa age_iq_inst if (bmonth==1 | bmonth==12) & ability~=., cluster(cohort mpid_b);
xi:cgmreg age_iq i.alt_yob essa age_iq_inst if (bmonth==1 | bmonth==12) & ability~=., cluster(cohort mpid_b);
xi:cgmreg ssa alt_mob i.alt_yob essa age_iq_inst if ability~=. & eduy~=. & eduy<11 & alt_yob<=1979, cluster(cohort mpid_b);
xi:cgmreg age_iq alt_mob i.alt_yob essa age_iq_inst if ability~=. & eduy~=. & eduy<11 & alt_yob<=1979, cluster(cohort mpid_b);
xi:cgmreg ssa alt_mob i.alt_yob essa age_iq_inst if ability~=. & eduy~=. & eduy>=12 & alt_yob<=1979, cluster(cohort mpid_b);
xi:cgmreg age_iq alt_mob i.alt_yob essa age_iq_inst if ability~=. & eduy~=. & eduy>=12 & alt_yob<=1979, cluster(cohort mpid_b);

*OLS;
xi:cgmreg ability ssa age_iq alt_mob 
  i.alt_yob, cluster(cohort mpid_b);

*Full Sample IV;
ivclust2 ability alt_mob i.alt_yob (ssa age_iq=essa age_iq_inst), cluster(cohort mpid_b clust_both);

*Discontinuity Sample;
ivclust2 ability (ssa age_iq =essa age_iq_inst) 
i.alt_yob if bmonth==1 | bmonth==12, cluster(cohort mpid_b clust_both);

*IQ by Education Level;
ivclust2 ability (ssa age_iq =essa age_iq_inst) 
  alt_mob i.alt_yob if eduy~=. & eduy<11 & alt_yob<=1979, cluster(cohort mpid_b clust_both);
ivclust2 ability (ssa age_iq =essa age_iq_inst) 
  alt_mob i.alt_yob if eduy~=. & eduy>=12 & alt_yob<=1979, cluster(cohort mpid_b clust_both);

tempfile stuffiq;
save `stuffiq', replace;

*********Family Fixed Effects******************;
drop if ability==.;
sort mpid;
egen numbro=count(ability), by(mpid);
tab numbro;
drop if numbro<2;
drop if mpid==.;
su;

iis mpid;

xi:xtivreg ability (ssa age_iq =essa age_iq_inst) 
  alt_mob i.alt_yob i.childn, fe;
xi:xtreg ssa alt_mob i.alt_yob essa age_iq_inst, fe;
xi:xtreg age_iq alt_mob i.alt_yob essa age_iq_inst, fe;

tempfile junk;
save `junk', replace;

************************************************************;
*************END OF TABLE 3*********************************;
************************************************************;

*************************************************************;
*********APPENDIX TABLE 1************************************;
**************************ROBUSTNESS CHECKS*******************;
**************************************************************;
use `stuffiq';
*linear trend where trend changes in january;
gen alt_mob_b=alt_mob-7;
gen alt_mob_d=(alt_mob>=7)*alt_mob_b;
ivclust2 ability (ssa age_iq=essa age_iq_inst) 
  alt_mob_b alt_mob_d i.alt_yob , cluster(cohort mpid_b clust_both);
*cohort specific trend;
ivclust2 ability (ssa age_iq=essa age_iq_inst) 
  alt_mob i.alt_yob i.alt_yob*alt_mob, cluster(cohort mpid_b clust_both);
*quadratic trend;
ivclust2 ability (ssa age_iq=essa age_iq_inst) 
  alt_mob i.alt_yob alt_mob_sq, cluster(cohort mpid_b clust_both);
*instrumenting ssa with month of birth dummies;
ivclust2 ability (ssa age_iq=altm2-altm12 age_iq_inst) 
  alt_mob i.alt_yob, cluster(cohort mpid_b clust_both);
*including quartic in cohort;
ivclust2 ability (ssa age_iq=essa age_iq_inst) 
  alt_mob i.alt_yob cohort cohort2 cohort3 cohort4, cluster(cohort mpid_b clust_both);
*including family controls;
ivclust2 ability (ssa age_iq=essa age_iq_inst) 
  alt_mob i.alt_yob i.medu i.famsiz i.childn, cluster(cohort mpid_b clust_both);
*including family controls in discontinuity sample;
ivclust2 ability (ssa age_iq=essa age_iq_inst) 
  i.alt_yob i.medu i.famsiz i.childn if bmonth==1 | bmonth==12, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***************************************************************;
***************END OF APPENDIX TABLE 1*************************;
***************************************************************;

***************************************************************;
***************TABLE 6*****************************************;
***************************************************************;
use `stuff';

*1 EDUY;
*men;
xi:cgmreg eduy ssa alt_mob 
  i.alt_yob if alt_yob<=1979 & sex==1, cluster(cohort mpid_b clust_both);
ivclust eduy alt_mob i.alt_yob (ssa =essa) 
if alt_yob<=1979 & sex==1, cluster(cohort mpid_b);
*women;
xi:cgmreg eduy ssa alt_mob 
  i.alt_yob if alt_yob<=1979 & sex==2, cluster(cohort mpid_b clust_both);
ivclust eduy alt_mob i.alt_yob (ssa =essa) 
if alt_yob<=1979 & sex==2, cluster(cohort mpid_b);

*TEEN;
xi:cgmreg teen ssa alt_mob 
  i.alt_yob if alt_yob<=1969 & sex==2, cluster(cohort mpid_b);
ivclust teen alt_mob i.alt_yob (ssa =essa) 
if alt_yob<=1969 & sex==2, cluster(cohort mpid_b clust_both);

xi:cgmreg child_before_finish ssa alt_mob 
  i.alt_yob if alt_yob<=1969 & sex==2, cluster(cohort mpid_b);
ivclust child_before_finish alt_mob i.alt_yob (ssa =essa) 
if alt_yob<=1969 & sex==2, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

use `stuffiq';
*MENTAL HEALTH;
xi:cgmreg mental_i ssa age_iq alt_mob 
  i.alt_yob if alt_yob<=1987 & sex==1
, cluster(cohort mpid_b);
ivclust2 mental_i alt_mob i.alt_yob (ssa age_iq =essa age_iq_inst) 
if alt_yob<=1979 & sex==1, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

*************************************************************************;
***********************TABLE 7*******************************************;
******************HETEROGENEOUS EFFECTS**********************************;
*************************************************************************;

use `stuffiq';

*PREDICTED VALUE OF IQ;
xi:reg ability i.famsiz i.medu i.childn if ability~=. & alt_yob<=1987 & sex==1;
predict prediq if ability~=. & alt_yob<=1987 & sex==1;
set seed 1;
gen x = invnorm(uniform());
replace prediq=prediq+(x/100000);*breaking ties;
su prediq x;
drop x;

xtile quartiq=prediq, nq(4);

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust2 ability alt_mob i.alt_yob (ssa age_iq=essa age_iq_inst) if qtile==0 & alt_yob<=1987 & sex==1, cluster(cohort mpid_b clust_both);
ivclust2 ability alt_mob i.alt_yob (ssa age_iq=essa age_iq_inst) if qtile==1 & alt_yob<=1987 & sex==1, cluster(cohort mpid_b clust_both);
ivclust2 ability alt_mob i.alt_yob (ssa age_iq=essa age_iq_inst) if qtile==2 & alt_yob<=1987 & sex==1, cluster(cohort mpid_b clust_both);


capture drop prediq;
capture drop x;
capture drop quartiq;
capture drop qtile;
capture drop qtile1;
capture drop qtile2;

*PREDICTED VALUE OF MENTAL HEALTH;
xi:reg mental_i i.famsiz i.medu i.childn if mental_i~=. & alt_yob<=1987 & sex==1;
predict prediq if mental_i~=. & alt_yob<=1987 & sex==1;
set seed 1;
gen x = invnorm(uniform());
replace prediq=prediq+(x/100000);*breaking ties;
su prediq x;
drop x;

xtile quartiq=prediq, nq(4);

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust2 mental_i alt_mob i.alt_yob (ssa age_iq=essa age_iq_inst) if qtile==0 & alt_yob<=1987 & sex==1, cluster(cohort mpid_b clust_both);
ivclust2 mental_i alt_mob i.alt_yob (ssa age_iq=essa age_iq_inst) if qtile==1 & alt_yob<=1987 & sex==1, cluster(cohort mpid_b clust_both);
ivclust2 mental_i alt_mob i.alt_yob (ssa age_iq=essa age_iq_inst) if qtile==2 & alt_yob<=1987 & sex==1, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

use `stuff';

*PREDICTED VALUE OF EDUY;
xi:reg eduy i.famsiz i.medu i.childn if eduy~=. & sex==1 & alt_yob<=1979;
predict prediq if eduy~=. & sex==1 & alt_yob<=1979;
set seed 1;
gen x = invnorm(uniform());
replace prediq=prediq+(x/100000);*breaking ties;
su prediq x;
drop x;

xtile quartiq=prediq, nq(4);

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust eduy alt_mob i.alt_yob (ssa =essa ) if alt_yob<=1979 & sex==1 & qtile==0, cluster(cohort mpid_b clust_both);
ivclust eduy alt_mob i.alt_yob (ssa =essa ) if alt_yob<=1979 & sex==1 & qtile==1, cluster(cohort mpid_b clust_both);
ivclust eduy alt_mob i.alt_yob (ssa =essa ) if alt_yob<=1979 & sex==1 & qtile==2, cluster(cohort mpid_b clust_both);



capture drop prediq;
capture drop x;
capture drop quartiq;
capture drop qtile;
capture drop qtile1;
capture drop qtile2;


*women;

*PREDICTED VALUE OF EDUY;
xi:reg eduy i.famsiz i.medu i.childn if eduy~=. & sex==2 & alt_yob<=1979;
predict prediq if eduy~=. & sex==2 & alt_yob<=1979;
set seed 1;
gen x = invnorm(uniform());
replace prediq=prediq+(x/100000);*breaking ties;
su prediq x;
drop x;

xtile quartiq=prediq, nq(4);

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust eduy alt_mob i.alt_yob (ssa =essa ) if alt_yob<=1979 & sex==2 & qtile==0, cluster(cohort mpid_b clust_both);
ivclust eduy alt_mob i.alt_yob (ssa =essa ) if alt_yob<=1979 & sex==2 & qtile==1, cluster(cohort mpid_b clust_both);
ivclust eduy alt_mob i.alt_yob (ssa =essa ) if alt_yob<=1979 & sex==2 & qtile==2, cluster(cohort mpid_b clust_both);


capture drop prediq;
capture drop x;
capture drop quartiq;
capture drop qtile;
capture drop qtile1;
capture drop qtile2;


*TEEN;

*PREDICTED VALUE OF TEEN;
xi:reg teen i.famsiz i.medu i.childn if teen~=. & sex==2 & alt_yob<=1969;
predict prediq if teen~=. & sex==2 & alt_yob<=1969;
set seed 1;
gen x = invnorm(uniform());
replace prediq=prediq+(x/100000);*breaking ties;
su prediq x;
drop x;

xtile quartiq=prediq, nq(4);

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust teen alt_mob i.alt_yob (ssa =essa ) if qtile==0 & sex==2 & alt_yob<=1969, cluster(cohort mpid_b clust_both);
ivclust teen alt_mob i.alt_yob (ssa =essa ) if qtile==1 & sex==2 & alt_yob<=1969, cluster(cohort mpid_b clust_both);
ivclust teen alt_mob i.alt_yob (ssa =essa ) if qtile==2 & sex==2 & alt_yob<=1969, cluster(cohort mpid_b clust_both);

capture drop prediq;
capture drop x;
capture drop quartiq;
capture drop qtile;
capture drop qtile1;
capture drop qtile2;

*CHILD BEFORE FINISH;

*PREDICTED VALUE OF CHILD BEFORE FINISH;
xi:reg child_before_finish i.famsiz i.medu i.childn if teen~=. & sex==2 & alt_yob<=1969;
predict prediq if teen~=. & sex==2 & alt_yob<=1969;
set seed 1;
gen x = invnorm(uniform());
replace prediq=prediq+(x/100000);*breaking ties;
su prediq x;
drop x;

xtile quartiq=prediq, nq(4);

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust child_before_finish alt_mob i.alt_yob (ssa =essa ) if qtile==0 & sex==2 & alt_yob<=1969, cluster(cohort mpid_b clust_both);
ivclust child_before_finish alt_mob i.alt_yob (ssa =essa ) if qtile==1 & sex==2 & alt_yob<=1969, cluster(cohort mpid_b clust_both);
ivclust child_before_finish alt_mob i.alt_yob (ssa =essa ) if qtile==2 & sex==2 & alt_yob<=1969, cluster(cohort mpid_b clust_both);

capture drop prediq;
capture drop x;
capture drop quartiq;
capture drop qtile;
capture drop qtile1;
capture drop qtile2;

***********************************************************************;
*****************END TABLE 7*******************************************;
***********************************************************************;
