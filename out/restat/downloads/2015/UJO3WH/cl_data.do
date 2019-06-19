capture clear
capture log close

* change this to your folder

*cd "D:\Home\tcross\Dropbox\complete 2014\cl - are the unemployed credit constrainted\stata\archive prep\"
*cd "PUMF"

* on mac;
cd "/Users/thomascrossley/Dropbox/complete 2014/cl - are the unemployed credit constrainted/stata/archive prep/"
cd "PUMF"

log using cl_data.log, replace
*********************************
* cl_data.do
* Empirical Analsysis for: * Crossley, T.F., and H. Low, ìJob Loss, Credit Constraints and Consumption Growth.î Review of Economics and Statistics, 96(5):876-884 (December, 2014.) 
* Contact: tfcrossley@gmail.com or tcross@esex.ac.uk
* this program cleans up data from survey and prepares file for analysis.
* last revised 2014
**************************************
* this program calls;

* skip95.do
* roevars.do
* dates95.do
* educ95.do
* cl_avariables;
* cl_sample.do

**************************************
set more 1
#delimit;

**********************************;

*****************************************************;
use coep95; * this is the raw survey data, CHANGE NAME AS NECESSARY;
*des,s;
keep if W2RESP==1; *keeps balanced panel, not necessary in PUMF;

*********************************************************
* Here are the variables we use. on the left is the names we assigned, o
* on the right are the question numbers
/*
SEQID           SEQID
rsrreas1        QA9
rqreas1         QA10
cempl1          QA16
i1spell1        QA36
chours1         QH10
cgrpay1         QH15
cgrunt1         QH16
chhsize1        QC1
cspouse1        QC2
cparnts1        QC4
cothers1        QC5
cundr181        QC6
cxtot1          QI5
cpinc1          QI11
chhinc1         QI12
rimp341         QI17
rimp121         QI18
rimp141         QI19
ownhome1        QJ1
mrtgage1        QJ3
anyasst1        QJ14
amtasst1        QJ15
asfall1         QJ18
aamtfll1        QJ19
asrise1         QJ20
aamtrse1        QJ21
amtdebt1        QJ27
dtfall1         QJ30
damtfll1        QJ31
dtrise1         QJ32
damtrse1        QJ33
scrdta1         QJ34
scrdtd1         QJ35
scrdtf1         QJ36
scrdtr1         QJ38
scrdtt1         QJ39
cldbrrw1        QJ40
wldbrrw1        QJ41
hrdshp1         QJ43
rsp_emp1        QL2
yrborn1         QM1
youredn1        QM3
vismin1         QM7
Sex1            survey
W2RESP2         W2RESP
curcur2         W2-QA1
cempa2          W2-QA4B
sempa2          W2-QA8B
cempb2          W2-QA14
chours2         W2-QH11
cgrpay2         W2-QH15
cgrunt2         W2-QH15A
chhsize2        W2-QC2
cxtot2          W2-QI1
chhinc2         W2-QI5
cpinc2          W2-QI5A

*/



********************************************;
*********** some preliminaries *************;
********************************************;

*quietly do subroutines\skip95;  * deals with survey skip pattern (where data is missing because not applicable);
*quietly do subroutines\roevars; * constructs variables at job loss date;
*quietly do subroutines\dates95; * calculates dates, and time from job loss to interviews (welapsed); 

* on mac;

quietly do subroutines/skip95;  
quietly do subroutines/roevars; 
quietly do subroutines/dates95;

replace rsp_emp1=0 if cspouse1==0; * a skip that seems to be missed;


*keep the variables we need from the survey;
keep
W2RESP SEQID i1spell rqreas1 rsrreas1 
cparnts1 cothers1 
cldbrrw1 wldbrrw1
scrdta1 scrdtd1 scrdtf1 scrdtr1 scrdtt1 
cempl1 Sex1 yrborn1 youredn1 cspouse1 chhsize1  cundr181 vismin1
ownhome1 mrtgage1 rsp_emp rhhinc rimp121 rimp141 rimp341
chhsize2 
welapsd2 welapsd1
hrdshp1 cxtot2 cxtot1 chhinc1 chhinc2 cpinc1 cpinc2
cempa2  cempb2 sempa2 curcur
cgrpay1 chours1 cgrunt1
cgrpay2 chours2 cgrunt2
asfall1 asrise1 aamtfll1 aamtrse1 anyasst1 amtasst1
dtfall1 dtrise1 damtfll1 damtrse1  amtdebt1 ;

des; 
*exit;
*******************************************;
*********** create some variables *************;
*******************************************;

*** 0. Separation reason ***;

tab rsrreas1, mis;
drop if rsrreas==.;

gen layoff=.;
replace layoff=0 if rsrreas1~=.;
replace layoff=1 if rsrreas1==6;

gen quit=.;
replace quit=0 if rsrreas1~=.;
replace quit=1 if rsrreas==3; ;
tab rqreas;

gen fire=.;
replace fire=0 if rsrreas1~=.;
replace fire=1 if rsrreas1==5;

gen ill=.;
replace ill=0 if rsrreas1~=.;
replace ill=1 if rsrreas1==7;

*** Some Demographics ***;

gen male =(Sex1==1);

gen age=1995-yrborn1;
sum age;

*quietly do subroutines\educ95; *generates education dummies;
quietly do subroutines/educ95; * mac ;


gen dch=(cundr181>0);
replace dch=. if cundr181==.;
replace dch=0 if chhsize1==1|(chhsize1==2&cspouse1==1);

*** Some Household Finances ***;
 
replace rimp121=0 if rimp341==1;
replace rimp141=0 if rimp341==1|rimp121==1;
sum rimp*;

gen prim_earn=(rimp341==1|rimp121==1);
replace prim_earn=. if rimp121==.;
tab prim_earn;

tab ownhome;
tab mrtgage1;
replace mrtgage1=0 if ownhome==0;

* do subroutines\cl_avariables; * derives some asset variables;
do subroutines/cl_avariables; * mac;

*** I1 wage and earnings ***;

* interview 1 monthly earnings;
gen     c_earn1= cgrpay1* chours1*4.3    if cgrunt1==1;
replace c_earn1= cgrpay1*22             if cgrunt1==2;
replace c_earn1= cgrpay1*4.3            if cgrunt1==3;
replace c_earn1= cgrpay1*2.15           if cgrunt1==4;
replace c_earn1= cgrpay1*2              if cgrunt1==5;
replace c_earn1= cgrpay1                if cgrunt1==6;
replace c_earn1= cgrpay1/12             if cgrunt1==7;
replace c_earn1=0 if i1spell<3                  ;
sum c_earn1,de;

* interview1 hourly wage;
gen     c_wage1= cgrpay1                if cgrunt1==1;
replace c_wage1= cgrpay1*5/chours1      if cgrunt1==2;
replace c_wage1= cgrpay1/chours1        if cgrunt1==3;
replace c_wage1= cgrpay1/(2*chours1)    if cgrunt1==4;
replace c_wage1= cgrpay1/(2.15*chours1) if cgrunt1==5;
replace c_wage1= cgrpay1/(4.3*chours1)  if cgrunt1==6;
replace c_wage1= cgrpay1/(52*chours1)   if cgrunt1==7;
replace c_wage1=. if i1spell<3                  ;
sum c_wage1,de;

*** I2 wage earnings and employment ***;

* need to create cempl2 - Problem in data;
replace cempa2=0 if cempa2==2;
gen cempl2=cempa2;
replace cempl2=1 if curcur==1;
replace cempl2=1 if cempb2==1;
replace cempl2=0 if cempb2==2;
replace sempa2=0 if sempa2==2;
replace cempl2=0 if cempl1==0&sempa2==0;

* interview2 monthly earnings;
gen     c_earn2= cgrpay2* chours2*4.3    if cgrunt2==1;
replace c_earn2= cgrpay2*22             if cgrunt2==2;
replace c_earn2= cgrpay2*4.3            if cgrunt2==3;
replace c_earn2= cgrpay2*2.15           if cgrunt2==4;
replace c_earn2= cgrpay2*2              if cgrunt2==5;
replace c_earn2= cgrpay2                if cgrunt2==6;
replace c_earn2= cgrpay2/12             if cgrunt2==7;

* interview2 hourly wage;
gen     c_wage2= cgrpay2                if cgrunt2==1;
replace c_wage2= cgrpay2*5/chours2      if cgrunt2==2;
replace c_wage2= cgrpay2/chours2        if cgrunt2==3;
replace c_wage2= cgrpay2/(2*chours2)    if cgrunt2==4;
replace c_wage2= cgrpay2/(2.15*chours2) if cgrunt2==5;
replace c_wage2= cgrpay2/(4.3*chours2)  if cgrunt2==6;
replace c_wage2= cgrpay2/(52*chours2)   if cgrunt2==7;

* note that earnings are not asked at I2 if still in I1 job!!;
 
replace c_wage2=c_wage1 if curcur2==1;
replace c_earn2=c_earn1 if curcur2==1;
replace chours2=chours1 if curcur2==1;
 


* next isnt entirely satisfactory but employment status is very hard to identify at I2;

replace cempl2=1 if cempl2==.&c_earn2~=.;
replace cempl2=1 if cempl2==.&c_wage2~=.;
replace c_earn2=0 if cempl2==0;
replace c_wage2=. if cempl2==0;


*********************************************;
**************keep variables*****************;
*********************************************;

keep 
i1spell rqreas1
cparnts1 cothers1 prim
cldbrrw1 wldbrrw1
scrdta1 scrdtd1 scrdtf1 scrdtr1 scrdtt1 
cempl1 male age hgh unicol cspouse1 dch vismin1
quit fire ill ownhome1 mrtgage1 rsp_emp rhhinc

chhsize2 chhsize1
welapsd2 welapsd1

hrdshp1 cxtot2 cxtot1 chhinc1 chhinc2 cpinc1 cpinc2

rhhinc cempl2

asfall1 asrise1 aamtfll1 aamtrse1 anyasst1 amtasst1
dtfall1 dtrise1 damtfll1 damtrse1  amtdebt1 


dhhass rhhass dhhdeb rhhdeb ranyass ranydeb                        
income r_assrat r_debrat r_net r_netrat r_ass1 r_deb1           

W2RESP2 SEQID;

***********************************************;
************** select sample ******************; 
***********************************************;

*do subroutines\cl_sample;

do subroutines/cl_sample; *mac;


**********************************************;
*********** Save Data ************************;
**********************************************;

save cl2014.dta, replace;

**********************************************;
**********************************************;
log close;
*exit;



