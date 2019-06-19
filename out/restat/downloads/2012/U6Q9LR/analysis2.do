#delimit;

************************************************************;
*********RESULTS FOR LABOR MARKET VARIABLES*****************;
************************************************************;

clear;
set more off;
version 8.0;
cap log close;
log using analysis2, text replace;

set mem 2500000;
set matsize 800;

use /home/sblack/school_age/restat/ssa_data;
keep eduy sex bmonth yob pid 
pearn86 pearn87 pearn88 pearn89 pearn90 pearn91 pearn92 pearn93 pearn94
pearn95 pearn96 pearn97 pearn98 pearn99 pearn100 pearn101 pearn102 
pearn103 pearn104 pearn105 
hrs86 hrs87 hrs88 hrs89 hrs90 hrs91 hrs92 hrs93 hrs94 hrs95 hrs96 hrs97 hrs98
hrs99 hrs100 hrs101 hrs102 hrs103 hrs104 hrs105 mpid yob schoolstart
 mndutbet* childnum famsize meduy mnkids
;
*sample 1;

drop if sex==. | pid==.;

duplicates report pid;
duplicates drop pid, force;

******COHORT*******;
gen cohort=(yob-1949)+(bmonth)/12;
gen cohort2=cohort*cohort;
gen cohort3=cohort*cohort2;
gen cohort4=cohort2*cohort2;

*******Linear trend from july to june;
gen alt_yob=yob if bmonth>=7;
replace alt_yob=yob-1 if bmonth<=6;
gen alt_mob=bmonth+6 if bmonth<=6;
replace alt_mob=bmonth-6 if bmonth>=7;

*Actual School Starting age;
gen ssa=(schoolstart-yob+.7)-((bmonth-1)/12);
*Expected School Starting age;
gen essa=7.7-((bmonth-1)/12);
replace ssa=essa if ssa==.;

drop if essa==.;

replace childnum=10 if childnum>=10 & childnum~=.;
gen childn=childnum;replace childn=0 if childnum==.;
replace famsize=mnkids if famsize==. | (mnkids~=. & famsize<mnkids);
replace famsize=10 if famsize>=10 & famsize~=.;
gen famsiz=famsize;replace famsiz=0 if famsize==.;
gen medu=meduy;replace medu=0 if meduy==.;

********USING ADO FILE THAT DOES 2-WAY CLUSTERING********************; 
gen mpid_b=mpid;
replace mpid_b=uniform() if mpid_b==.;
egen clust_both=group(mpid_b cohort);

tempfile stuff;
save `stuff', replace;

************************************************************;
*************TABLE 4****************************************;
************************************************************;

*****MEN****;

*************WHETHER WORK FULL TIME****************************;
use `stuff' if sex==1;

keep if bmonth~=. & alt_yob<=1970 & alt_yob>=1963;

keep eduy sex bmonth yob pid cohort cohort2 cohort3 cohort4
hrs86 hrs87 hrs88 hrs89 hrs90 hrs91 hrs92 hrs93 hrs94 hrs95 hrs96 hrs97 hrs98
hrs99 hrs100 hrs101 hrs102 hrs103 hrs104 hrs105 alt_mob mpid alt_yob ssa essa
mpid_b clust_both
 mndutbet*
;

sort pid;
reshape long hrs mndutbet, i(pid) j(year);
keep bmonth yob pid cohort hrs year
alt_mob mpid alt_yob ssa essa mpid_b clust_both mndutbet;
gen age_earn=(year+1900+(7/12))-(yob+(bmonth/12));*age in middle of year earnings
recorded;
keep if age_earn>23 & age_earn<=35;

gen monthind=bmonth;replace monthind=1 if bmonth==1 | bmonth==12;

gen fullt=0;replace fullt=1 if hrs==3;
replace fullt=. if year==106;



replace mndutbet=0 if mndutbet==.;
gen isoc=(mndutbet>0);replace isoc=. if year>=86 & year<=91;
sort year;

drop mndutbet;

*****FOR TABLE 2****************;
su fullt isoc;
********************************;

tempfile stuff1;
save `stuff1', replace;

use `stuff1' if age_earn>23 & age_earn<=24;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

use `stuff1' if age_earn>24 & age_earn<=25;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>25 & age_earn<=26;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>26 & age_earn<=27;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>27 & age_earn<=28;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>28 & age_earn<=29;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>29 & age_earn<=30;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>30 & age_earn<=31;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>31 & age_earn<=32;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>32 & age_earn<=33;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>33 & age_earn<=34;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>34 & age_earn<=35;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

xi:cgmreg isoc ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust isoc alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

*********************LOG EARN*****************************;
use `stuff' if sex==1;
keep if bmonth~=. & alt_yob<=1970 & alt_yob>=1963;

keep eduy sex bmonth yob pid cohort cohort2 cohort3 cohort4
pearn86 pearn87 pearn88 pearn89 pearn90 pearn91 pearn92 pearn93 pearn94
pearn95 pearn96 pearn97 pearn98 pearn99 pearn100 pearn101 pearn102 
pearn103 pearn104 pearn105 
hrs86 hrs87 hrs88 hrs89 hrs90 hrs91 hrs92 hrs93 hrs94 hrs95 hrs96 hrs97 hrs98
hrs99 hrs100 hrs101 hrs102 hrs103 hrs104 hrs105 alt_mob mpid alt_yob ssa essa
mpid_b clust_both
;

sort pid;
reshape long pearn hrs, i(pid) j(year);
keep eduy sex bmonth yob pid cohort cohort2 cohort3 cohort4 pearn hrs year
alt_mob mpid alt_yob ssa essa mpid_b clust_both;
gen age_earn=(year+1900+(7/12))-(yob+(bmonth/12));*age in middle of year earnings
recorded;

gen lnpearn=log(pearn) if pearn>=1;
gen fullt=0;replace fullt=1 if hrs==3;

keep if age_earn>23 & age_earn<=35;


gen monthind=bmonth;replace monthind=1 if bmonth==1 | bmonth==12;

su;

gen missing_earn=0;replace missing_earn=1 if lnpearn==.;

keep if pearn>=1 & pearn~=.;

************FOR TABLE 2*************************;
su pid lnpearn if age_earn>23 & age_earn<=24;
su pid lnpearn if age_earn>34 & age_earn<=35;
************************************************;

iis mpid;

tempfile stuff1;
save `stuff1', replace;

***********23-24***********;
use `stuff1';
keep if age_earn>23 & age_earn<=24 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********24-25***********;
use `stuff1';
keep if age_earn>24 & age_earn<=25 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***********25-26***********;
use `stuff1';
keep if age_earn>25 & age_earn<=26 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********26-27***********;
use `stuff1';
keep if age_earn>26 & age_earn<=27 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********27-28***********;
use `stuff1';
keep if age_earn>27 & age_earn<=28 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********28-29***********;
use `stuff1';
keep if age_earn>28 & age_earn<=29 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********29-30***********;
use `stuff1';
keep if age_earn>29 & age_earn<=30 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********30-31***********;
use `stuff1';
keep if age_earn>30 & age_earn<=31 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********31-32***********;
use `stuff1';
keep if age_earn>31 & age_earn<=32 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********32-33***********;
use `stuff1';
keep if age_earn>32 & age_earn<=33 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***********33-34***********;
use `stuff1';
keep if age_earn>33 & age_earn<=34 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***********34-35***********;
use `stuff1';
keep if age_earn>34 & age_earn<=35 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


*********************LOG EARN FOR FULL-TIME WORKERS****************;
use `stuff' if sex==1;
keep if bmonth~=. & alt_yob<=1970 & alt_yob>=1963;

keep eduy sex bmonth yob pid cohort cohort2 cohort3 cohort4
pearn86 pearn87 pearn88 pearn89 pearn90 pearn91 pearn92 pearn93 pearn94
pearn95 pearn96 pearn97 pearn98 pearn99 pearn100 pearn101 pearn102 
pearn103 pearn104 pearn105 
hrs86 hrs87 hrs88 hrs89 hrs90 hrs91 hrs92 hrs93 hrs94 hrs95 hrs96 hrs97 hrs98
hrs99 hrs100 hrs101 hrs102 hrs103 hrs104 hrs105 alt_mob mpid alt_yob ssa essa
mpid_b clust_both
;

sort pid;
reshape long pearn hrs, i(pid) j(year);
keep eduy sex bmonth yob pid cohort cohort2 cohort3 cohort4 pearn hrs year
alt_mob mpid alt_yob ssa essa mpid_b clust_both;
gen age_earn=(year+1900+(7/12))-(yob+(bmonth/12));*age in middle of year earnings
recorded;

gen lnpearn=log(pearn) if pearn>=1;
gen fullt=0;replace fullt=1 if hrs==3;
keep if fullt==1;

keep if age_earn>23 & age_earn<=35;

su pid lnpearn if age_earn>23 & age_earn<=24;
su pid lnpearn if age_earn>34 & age_earn<=35;

gen monthind=bmonth;replace monthind=1 if bmonth==1 | bmonth==12;

su;

gen missing_earn=0;replace missing_earn=1 if lnpearn==.;

keep if pearn>=1 & pearn~=.;


iis mpid;

tempfile stuff1;
save `stuff1', replace;

***********23-24***********;
use `stuff1';
keep if age_earn>23 & age_earn<=24 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********24-25***********;
use `stuff1';
keep if age_earn>24 & age_earn<=25 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***********25-26***********;
use `stuff1';
keep if age_earn>25 & age_earn<=26 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********26-27***********;
use `stuff1';
keep if age_earn>26 & age_earn<=27 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********27-28***********;
use `stuff1';
keep if age_earn>27 & age_earn<=28 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********28-29***********;
use `stuff1';
keep if age_earn>28 & age_earn<=29 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********29-30***********;
use `stuff1';
keep if age_earn>29 & age_earn<=30 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********30-31***********;
use `stuff1';
keep if age_earn>30 & age_earn<=31 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********31-32***********;
use `stuff1';
keep if age_earn>31 & age_earn<=32 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********32-33***********;
use `stuff1';
keep if age_earn>32 & age_earn<=33 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***********33-34***********;
use `stuff1';
keep if age_earn>33 & age_earn<=34 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***********34-35***********;
use `stuff1';
keep if age_earn>34 & age_earn<=35 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


*************************************************************;
*************END OF TABLE 4**********************************;
*************************************************************;

************************************************************;
*************TABLE 5****************************************;
************************************************************;

*****WOMEN****;

*************WHETHER WORK FULL TIME****************************;
use `stuff' if sex==2;

keep if bmonth~=. & alt_yob<=1970 & alt_yob>=1963;

keep eduy sex bmonth yob pid cohort cohort2 cohort3 cohort4
hrs86 hrs87 hrs88 hrs89 hrs90 hrs91 hrs92 hrs93 hrs94 hrs95 hrs96 hrs97 hrs98
hrs99 hrs100 hrs101 hrs102 hrs103 hrs104 hrs105 alt_mob mpid alt_yob ssa essa
mpid_b clust_both
 mndutbet*
;

sort pid;
reshape long hrs mndutbet, i(pid) j(year);
keep bmonth yob pid cohort hrs year
alt_mob mpid alt_yob ssa essa mpid_b clust_both mndutbet;
gen age_earn=(year+1900+(7/12))-(yob+(bmonth/12));*age in middle of year earnings
recorded;
keep if age_earn>23 & age_earn<=35;

gen monthind=bmonth;replace monthind=1 if bmonth==1 | bmonth==12;

gen fullt=0;replace fullt=1 if hrs==3;
replace fullt=. if year==106;



replace mndutbet=0 if mndutbet==.;
gen isoc=(mndutbet>0);replace isoc=. if year>=86 & year<=91;
sort year;

drop mndutbet;

*****FOR TABLE 2****************;
su fullt isoc;
********************************;

tempfile stuff1;
save `stuff1', replace;

use `stuff1' if age_earn>23 & age_earn<=24;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

use `stuff1' if age_earn>24 & age_earn<=25;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>25 & age_earn<=26;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>26 & age_earn<=27;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>27 & age_earn<=28;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>28 & age_earn<=29;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>29 & age_earn<=30;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>30 & age_earn<=31;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>31 & age_earn<=32;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>32 & age_earn<=33;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>33 & age_earn<=34;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

use `stuff1' if age_earn>34 & age_earn<=35;
su;
xi:cgmreg fullt ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust fullt alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

xi:cgmreg isoc ssa alt_mob i.year
, cluster(cohort mpid_b);
ivclust isoc alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

save `junk', replace;

*********************LOG EARN*****************************;
use `stuff' if sex==2;
keep if bmonth~=. & alt_yob<=1970 & alt_yob>=1963;

keep eduy sex bmonth yob pid cohort cohort2 cohort3 cohort4
pearn86 pearn87 pearn88 pearn89 pearn90 pearn91 pearn92 pearn93 pearn94
pearn95 pearn96 pearn97 pearn98 pearn99 pearn100 pearn101 pearn102 
pearn103 pearn104 pearn105 
hrs86 hrs87 hrs88 hrs89 hrs90 hrs91 hrs92 hrs93 hrs94 hrs95 hrs96 hrs97 hrs98
hrs99 hrs100 hrs101 hrs102 hrs103 hrs104 hrs105 alt_mob mpid alt_yob ssa essa
mpid_b clust_both
;

sort pid;
reshape long pearn hrs, i(pid) j(year);
keep eduy sex bmonth yob pid cohort cohort2 cohort3 cohort4 pearn hrs year
alt_mob mpid alt_yob ssa essa mpid_b clust_both;
gen age_earn=(year+1900+(7/12))-(yob+(bmonth/12));*age in middle of year earnings
recorded;

gen lnpearn=log(pearn) if pearn>=1;
gen fullt=0;replace fullt=1 if hrs==3;

keep if age_earn>23 & age_earn<=35;


gen monthind=bmonth;replace monthind=1 if bmonth==1 | bmonth==12;

su;

gen missing_earn=0;replace missing_earn=1 if lnpearn==.;

keep if pearn>=1 & pearn~=.;

************FOR TABLE 2*************************;
su pid lnpearn if age_earn>23 & age_earn<=24;
su pid lnpearn if age_earn>34 & age_earn<=35;
************************************************;

iis mpid;

tempfile stuff1;
save `stuff1', replace;

***********23-24***********;
use `stuff1';
keep if age_earn>23 & age_earn<=24 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********24-25***********;
use `stuff1';
keep if age_earn>24 & age_earn<=25 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***********25-26***********;
use `stuff1';
keep if age_earn>25 & age_earn<=26 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********26-27***********;
use `stuff1';
keep if age_earn>26 & age_earn<=27 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********27-28***********;
use `stuff1';
keep if age_earn>27 & age_earn<=28 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********28-29***********;
use `stuff1';
keep if age_earn>28 & age_earn<=29 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********29-30***********;
use `stuff1';
keep if age_earn>29 & age_earn<=30 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********30-31***********;
use `stuff1';
keep if age_earn>30 & age_earn<=31 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********31-32***********;
use `stuff1';
keep if age_earn>31 & age_earn<=32 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********32-33***********;
use `stuff1';
keep if age_earn>32 & age_earn<=33 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***********33-34***********;
use `stuff1';
keep if age_earn>33 & age_earn<=34 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***********34-35***********;
use `stuff1';
keep if age_earn>34 & age_earn<=35 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


*********************LOG EARN FOR FULL-TIME WORKERS****************;
use `stuff' if sex==2;
keep if bmonth~=. & alt_yob<=1970 & alt_yob>=1963;

keep eduy sex bmonth yob pid cohort cohort2 cohort3 cohort4
pearn86 pearn87 pearn88 pearn89 pearn90 pearn91 pearn92 pearn93 pearn94
pearn95 pearn96 pearn97 pearn98 pearn99 pearn100 pearn101 pearn102 
pearn103 pearn104 pearn105 
hrs86 hrs87 hrs88 hrs89 hrs90 hrs91 hrs92 hrs93 hrs94 hrs95 hrs96 hrs97 hrs98
hrs99 hrs100 hrs101 hrs102 hrs103 hrs104 hrs105 alt_mob mpid alt_yob ssa essa
mpid_b clust_both
;

sort pid;
reshape long pearn hrs, i(pid) j(year);
keep eduy sex bmonth yob pid cohort cohort2 cohort3 cohort4 pearn hrs year
alt_mob mpid alt_yob ssa essa mpid_b clust_both;
gen age_earn=(year+1900+(7/12))-(yob+(bmonth/12));*age in middle of year earnings
recorded;

gen lnpearn=log(pearn) if pearn>=1;
gen fullt=0;replace fullt=1 if hrs==3;
keep if fullt==1;

keep if age_earn>23 & age_earn<=35;

su pid lnpearn if age_earn>23 & age_earn<=24;
su pid lnpearn if age_earn>34 & age_earn<=35;

gen monthind=bmonth;replace monthind=1 if bmonth==1 | bmonth==12;

su;

gen missing_earn=0;replace missing_earn=1 if lnpearn==.;

keep if pearn>=1 & pearn~=.;


iis mpid;

tempfile stuff1;
save `stuff1', replace;

***********23-24***********;
use `stuff1';
keep if age_earn>23 & age_earn<=24 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********24-25***********;
use `stuff1';
keep if age_earn>24 & age_earn<=25 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***********25-26***********;
use `stuff1';
keep if age_earn>25 & age_earn<=26 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********26-27***********;
use `stuff1';
keep if age_earn>26 & age_earn<=27 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********27-28***********;
use `stuff1';
keep if age_earn>27 & age_earn<=28 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********28-29***********;
use `stuff1';
keep if age_earn>28 & age_earn<=29 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********29-30***********;
use `stuff1';
keep if age_earn>29 & age_earn<=30 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********30-31***********;
use `stuff1';
keep if age_earn>30 & age_earn<=31 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********31-32***********;
use `stuff1';
keep if age_earn>31 & age_earn<=32 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


***********32-33***********;
use `stuff1';
keep if age_earn>32 & age_earn<=33 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***********33-34***********;
use `stuff1';
keep if age_earn>33 & age_earn<=34 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;

***********34-35***********;
use `stuff1';
keep if age_earn>34 & age_earn<=35 & lnpearn~=.;
su;

xi:cgmreg lnpearn ssa alt_mob i.year
, cluster(cohort mpid_b);
outreg ssa using earn1, nolabel se 10pct replace;

ivclust lnpearn alt_mob i.year (ssa=essa)
, cluster(cohort mpid_b clust_both);

tempfile junk;
save `junk', replace;


*************************************************************;
*************END OF TABLE 5**********************************;
*************************************************************;

****************FOR TABLE 7**********************************************;
******************HETEROGENEOUS EFFECTS**********************************;
*************************************************************************;

*****MEN****;

use `stuff' if sex==1;

keep if bmonth~=. & alt_yob<=1970 & alt_yob>=1963;

keep eduy sex bmonth yob pid cohort cohort2 cohort3 cohort4
hrs86 hrs87 hrs88 hrs89 hrs90 hrs91 hrs92 hrs93 hrs94 hrs95 hrs96 hrs97 hrs98
hrs99 hrs100 hrs101 hrs102 hrs103 hrs104 hrs105 alt_mob mpid alt_yob ssa essa
mpid_b clust_both
 mndutbet* famsiz childn medu
pearn86 pearn87 pearn88 pearn89 pearn90 pearn91 pearn92 pearn93 pearn94
pearn95 pearn96 pearn97 pearn98 pearn99 pearn100 pearn101 pearn102 
pearn103 pearn104 pearn105 
;

sort pid;
reshape long hrs mndutbet pearn, i(pid) j(year);
keep bmonth yob pid cohort hrs pearn year
alt_mob mpid alt_yob ssa essa mpid_b clust_both mndutbet famsiz childn medu;
gen age_earn=(year+1900+(7/12))-(yob+(bmonth/12));*age in middle of year earnings
recorded;
keep if (age_earn>23 & age_earn<=24) | (age_earn>34 & age_earn<=35);

gen monthind=bmonth;replace monthind=1 if bmonth==1 | bmonth==12;

gen lnpearn=log(pearn) if pearn>=1;
gen fullt=0;replace fullt=1 if hrs==3;
replace fullt=. if year==106;

replace mndutbet=0 if mndutbet==.;
gen isoc=(mndutbet>0);replace isoc=. if year>=86 & year<=91;
sort year;

drop mndutbet;

tempfile stuff1;
save `stuff1', replace;

*****************AGE 24************************;
use `stuff1'; 
su;

xi:reg fullt i.famsiz i.medu i.childn if fullt~=.
& age_earn>34 & age_earn<=35;
predict prisoc if fullt~=.;
set seed 1;
gen x = invnorm(uniform());
replace prisoc=prisoc+(x/100000);*breaking ties;
su prisoc x;
drop x;

xtile quartiq=prisoc, nq(4);
su;

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust fullt alt_mob i.alt_yob (ssa =essa ) if qtile==0 
& age_earn>23 & age_earn<=24, cluster(cohort mpid_b clust_both);
ivclust fullt alt_mob i.alt_yob (ssa =essa ) if qtile==1
& age_earn>23 & age_earn<=24, cluster(cohort mpid_b clust_both);
ivclust fullt alt_mob i.alt_yob (ssa =essa ) if qtile==2
& age_earn>23 & age_earn<=24, cluster(cohort mpid_b clust_both);

drop qtile quartiq prisoc;

drop if lnpearn==.;

xi:reg lnpearn i.famsiz i.medu i.childn if lnpearn~=.
& age_earn>34 & age_earn<=35;
predict prisoc if lnpearn~=.;
set seed 1;
gen x = invnorm(uniform());
replace prisoc=prisoc+(x/100000);*breaking ties;
su prisoc x;
drop x;

xtile quartiq=prisoc, nq(4);
su;

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust lnpearn alt_mob i.alt_yob (ssa =essa ) if qtile==0 
& age_earn>23 & age_earn<=24, cluster(cohort mpid_b clust_both);
ivclust lnpearn alt_mob i.alt_yob (ssa =essa ) if qtile==1
& age_earn>23 & age_earn<=24, cluster(cohort mpid_b clust_both);
ivclust lnpearn alt_mob i.alt_yob (ssa =essa ) if qtile==2
& age_earn>23 & age_earn<=24, cluster(cohort mpid_b clust_both);

drop qtile quartiq prisoc;

tempfile junk;
save `junk', replace;

************AGE 35******************************;
use `stuff1' if age_earn>34 & age_earn<=35;
su;

xi:reg isoc i.famsiz i.medu i.childn if isoc~=.;
predict prisoc if isoc~=.;
set seed 1;
gen x = invnorm(uniform());
replace prisoc=prisoc+(x/100000);*breaking ties;
su prisoc x;
drop x;

xtile quartiq=prisoc, nq(4);
su;

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust isoc alt_mob i.alt_yob (ssa =essa ) if qtile==0, cluster(cohort mpid_b clust_both);
ivclust isoc alt_mob i.alt_yob (ssa =essa ) if qtile==1, cluster(cohort mpid_b clust_both);
ivclust isoc alt_mob i.alt_yob (ssa =essa ) if qtile==2, cluster(cohort mpid_b clust_both);

drop qtile quartiq prisoc;

xi:reg fullt i.famsiz i.medu i.childn if fullt~=.;
predict prisoc if fullt~=.;
set seed 1;
gen x = invnorm(uniform());
replace prisoc=prisoc+(x/100000);*breaking ties;
su prisoc x;
drop x;

xtile quartiq=prisoc, nq(4);
su;

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust fullt alt_mob i.alt_yob (ssa =essa ) if qtile==0, cluster(cohort mpid_b clust_both);
ivclust fullt alt_mob i.alt_yob (ssa =essa ) if qtile==1, cluster(cohort mpid_b clust_both);
ivclust fullt alt_mob i.alt_yob (ssa =essa ) if qtile==2, cluster(cohort mpid_b clust_both);

drop qtile quartiq prisoc;

drop if lnpearn==.;

xi:reg lnpearn i.famsiz i.medu i.childn if lnpearn~=.;
predict prisoc if lnpearn~=.;
set seed 1;
gen x = invnorm(uniform());
replace prisoc=prisoc+(x/100000);*breaking ties;
su prisoc x;
drop x;

xtile quartiq=prisoc, nq(4);
su;

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust lnpearn alt_mob i.alt_yob (ssa =essa ) if qtile==0, cluster(cohort mpid_b clust_both);
ivclust lnpearn alt_mob i.alt_yob (ssa =essa ) if qtile==1, cluster(cohort mpid_b clust_both);
ivclust lnpearn alt_mob i.alt_yob (ssa =essa ) if qtile==2, cluster(cohort mpid_b clust_both);

drop qtile quartiq prisoc;

save `junk', replace;

*****WOMEN****;

use `stuff' if sex==2;

keep if bmonth~=. & alt_yob<=1970 & alt_yob>=1963;

keep eduy sex bmonth yob pid cohort cohort2 cohort3 cohort4
hrs86 hrs87 hrs88 hrs89 hrs90 hrs91 hrs92 hrs93 hrs94 hrs95 hrs96 hrs97 hrs98
hrs99 hrs100 hrs101 hrs102 hrs103 hrs104 hrs105 alt_mob mpid alt_yob ssa essa
mpid_b clust_both
 mndutbet* famsiz childn medu
pearn86 pearn87 pearn88 pearn89 pearn90 pearn91 pearn92 pearn93 pearn94
pearn95 pearn96 pearn97 pearn98 pearn99 pearn100 pearn101 pearn102 
pearn103 pearn104 pearn105 
;

sort pid;
reshape long hrs mndutbet pearn, i(pid) j(year);
keep bmonth yob pid cohort hrs pearn year
alt_mob mpid alt_yob ssa essa mpid_b clust_both mndutbet famsiz childn medu;
gen age_earn=(year+1900+(7/12))-(yob+(bmonth/12));*age in middle of year earnings
recorded;
keep if (age_earn>23 & age_earn<=24) | (age_earn>34 & age_earn<=35);

gen monthind=bmonth;replace monthind=1 if bmonth==1 | bmonth==12;

gen lnpearn=log(pearn) if pearn>=1;
gen fullt=0;replace fullt=1 if hrs==3;
replace fullt=. if year==106;

replace mndutbet=0 if mndutbet==.;
gen isoc=(mndutbet>0);replace isoc=. if year>=86 & year<=91;
sort year;

drop mndutbet;

tempfile stuff1;
save `stuff1', replace;

*****************AGE 24************************;
use `stuff1'; 
su;

xi:reg fullt i.famsiz i.medu i.childn if fullt~=.
& age_earn>34 & age_earn<=35;
predict prisoc if fullt~=.;
set seed 1;
gen x = invnorm(uniform());
replace prisoc=prisoc+(x/100000);*breaking ties;
su prisoc x;
drop x;

xtile quartiq=prisoc, nq(4);
su;

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust fullt alt_mob i.alt_yob (ssa =essa ) if qtile==0 
& age_earn>23 & age_earn<=24, cluster(cohort mpid_b clust_both);
ivclust fullt alt_mob i.alt_yob (ssa =essa ) if qtile==1
& age_earn>23 & age_earn<=24, cluster(cohort mpid_b clust_both);
ivclust fullt alt_mob i.alt_yob (ssa =essa ) if qtile==2
& age_earn>23 & age_earn<=24, cluster(cohort mpid_b clust_both);

drop qtile quartiq prisoc;

drop if lnpearn==.;

xi:reg lnpearn i.famsiz i.medu i.childn if lnpearn~=.
& age_earn>34 & age_earn<=35;
predict prisoc if lnpearn~=.;
set seed 1;
gen x = invnorm(uniform());
replace prisoc=prisoc+(x/100000);*breaking ties;
su prisoc x;
drop x;

xtile quartiq=prisoc, nq(4);
su;

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust lnpearn alt_mob i.alt_yob (ssa =essa ) if qtile==0 
& age_earn>23 & age_earn<=24, cluster(cohort mpid_b clust_both);
ivclust lnpearn alt_mob i.alt_yob (ssa =essa ) if qtile==1
& age_earn>23 & age_earn<=24, cluster(cohort mpid_b clust_both);
ivclust lnpearn alt_mob i.alt_yob (ssa =essa ) if qtile==2
& age_earn>23 & age_earn<=24, cluster(cohort mpid_b clust_both);

drop qtile quartiq prisoc;

tempfile junk;
save `junk', replace;

************AGE 35******************************;
use `stuff1' if age_earn>34 & age_earn<=35;
su;

xi:reg isoc i.famsiz i.medu i.childn if isoc~=.;
predict prisoc if isoc~=.;
set seed 1;
gen x = invnorm(uniform());
replace prisoc=prisoc+(x/100000);*breaking ties;
su prisoc x;
drop x;

xtile quartiq=prisoc, nq(4);
su;

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust isoc alt_mob i.alt_yob (ssa =essa ) if qtile==0, cluster(cohort mpid_b clust_both);
ivclust isoc alt_mob i.alt_yob (ssa =essa ) if qtile==1, cluster(cohort mpid_b clust_both);
ivclust isoc alt_mob i.alt_yob (ssa =essa ) if qtile==2, cluster(cohort mpid_b clust_both);

drop qtile quartiq prisoc;

xi:reg fullt i.famsiz i.medu i.childn if fullt~=.;
predict prisoc if fullt~=.;
set seed 1;
gen x = invnorm(uniform());
replace prisoc=prisoc+(x/100000);*breaking ties;
su prisoc x;
drop x;

xtile quartiq=prisoc, nq(4);
su;

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust fullt alt_mob i.alt_yob (ssa =essa ) if qtile==0, cluster(cohort mpid_b clust_both);
ivclust fullt alt_mob i.alt_yob (ssa =essa ) if qtile==1, cluster(cohort mpid_b clust_both);
ivclust fullt alt_mob i.alt_yob (ssa =essa ) if qtile==2, cluster(cohort mpid_b clust_both);

drop qtile quartiq prisoc;

drop if lnpearn==.;

xi:reg lnpearn i.famsiz i.medu i.childn if lnpearn~=.;
predict prisoc if lnpearn~=.;
set seed 1;
gen x = invnorm(uniform());
replace prisoc=prisoc+(x/100000);*breaking ties;
su prisoc x;
drop x;

xtile quartiq=prisoc, nq(4);
su;

gen qtile=0;
replace qtile=. if quartiq==.;
replace qtile=1 if quartiq==2|quartiq==3;
replace qtile=2 if quartiq==4;

tab qtile;
ivclust lnpearn alt_mob i.alt_yob (ssa =essa ) if qtile==0, cluster(cohort mpid_b clust_both);
ivclust lnpearn alt_mob i.alt_yob (ssa =essa ) if qtile==1, cluster(cohort mpid_b clust_both);
ivclust lnpearn alt_mob i.alt_yob (ssa =essa ) if qtile==2, cluster(cohort mpid_b clust_both);

drop qtile quartiq prisoc;

save `junk', replace;

**************************************************************************;
***********************END TABLE 7****************************************;
**************************************************************************;
