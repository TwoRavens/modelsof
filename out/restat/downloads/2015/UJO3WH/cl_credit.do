capture clear
capture clear matrix
capture log close

* CHANGE THIS TO YOUR FOLDER
*cd "D:\Home\tcross\Dropbox\complete 2014\cl - are the unemployed credit constrainted\stata\archive prep\"
*cd "PUMF"

* on mac;
cd "/Users/thomascrossley/Dropbox/complete 2014/cl - are the unemployed credit constrainted/stata/archive prep/"
cd "PUMF"


log using  cl_credit.log, replace
*********************************
* cl_credit.do
* Empirical Analsysis for: * Crossley, T.F., and H. Low, ìJob Loss, Credit Constraints and Consumption Growth.î Review of Economics and Statistics, 96(5):876-884 (December, 2014.) 
* Contact: tfcrossley@gmail.com or tcross@esex.ac.uk
* This program does the analysis for the figures and tables
* cl_data.do previously used to create cl2014.dta;
* this program does not call any other programs
**************************************
set more 1
#delimit;

***************************************;
**************************************************;
* Data and variable list;

use cl2014.dta, replace;
des,s;
sum; 


*************************************************;
* LHS Variables;

*Generate "would/could" variables;
* note that these variables are asked in interview1;
sum cldbrrw1;
* case deletion;
drop if cldbrrw1==.;
tab cldbrrw1 wldbrrw1, mis row;
gen constrnd1=0 if cldbrrw1~=.;
replace constrnd1=1 if (cldbrrw1==0 & wldbrrw1==1);
sum constrnd1;
gen cantbrrw1=1-cldbrrw1;

*Generate "SCF"  Variables,  
* note that these variables refer to the period from the job loss to the first interview;
rename scrdta1 applied;
* case deletion;
drop if applied==.;
tab cempl1 applied, row mis;
rename scrdtd1 declined;
rename scrdtf1 full_amt;
gen nfa=1-full_amt;
gen unsucc1=0 ;
replace unsucc1=1 if  declined==1|nfa==1;
rename scrdtr1 gotlater;
replace gotlater=0 if gotlater==3;
* high nonresponse so count nonresponse as no;
replace gotlater=0 if gotlater==.&unsucc1==1;
replace unsucc1=0 if gotlater==1;
gen unsucc1b=unsucc1;
replace unsucc1b=. if applied==0;
rename scrdtt1 discouraged;
gen discouraged2=discouraged;
replace discouraged2=0 if applied==1;
gen unsucc2 = unsucc1;
replace unsucc2=1 if discouraged2==1;

* Check item nonresponse;
count;
sum cldbrrw1 wldbrrw1 applied unsucc1 unsucc2 cempl1;

*exit;


**************************************************;
*TABLE 1: CREDIT MARKET ACCESS AND CREDIT CONSTRAINED

* employment status;
label variable cempl1 "employed";
label define cempl1 0 "not empl" 1 "empl." ;
label values cempl1 cempl1;


* would borrow/ could borrow;

table cempl1 , row 
              c(mean cantbrrw1 mean wldbrrw1 mean constrnd1 n SEQID) 
              format(%9.3f);

* SCF type questions;

sum applied declined nfa gotlater;

sum unsucc1 discouraged discouraged2 unsucc2;

*exit;

****************************************************************************;
* FIGURE 1: CREDIT STATUS BY AGE;

gen agecat=recode(age, 35,45,55);
gen temp1= cantb;
replace temp1=0 if constr==1;
gen temp2=unsucc2;
replace temp2=0 if unsucc1==1;

#delimit;
*graph bar (mean) unsucc1 (mean) temp2, stack over(agecat, relabel(1 "26-35" 2 "36-45" 3 "46-55")) blabel(total, format(%6.2f))
                                                                                      ylabel(0 .1 .2 .3 .4 .5) legend(off) scheme(s1mono) graphregion(fcolor(white) ifcolor(white))
                                                                                       saving(cc_age1, replace);
#delimit;
*graph bar (mean) constr (mean) temp1, stack over(cempl1, relabel( 1 "Not Empl." 2 "Empl.") ) over(agecat, relabel(1 "26-35" 2 "36-45" 3 "46-55")) 
                            ylabel(0 .1 .2 .3 .4 .5) legend(off) scheme(s1mono) graphregion(fcolor(white) ifcolor(white)) blabel(total, format(%6.2f))
                             saving(cc_age2, replace) ;


*gr combine cc_age1.gph cc_age2.gph, colfirst graphregion(fcolor(white) ifcolor(white)) saving(cc_age.gph,replace);
*gr export cc_age.wmf, replace;

drop temp1 temp2;



*************************************************;
* RHS VARIABLES FOR PROBITS (FOR TABLE 2);

replace age=(age-40)/10;
sum age;
gen age45=0;
replace age45=(age-0.5) if age>0.5&age~=.;

macro define base="male age age45 hgh unicol cspouse1 dch vismin1";
macro define extra="quit fire ill  ownhome1 mrtgage1 rsp_emp ranyass ranydeb ";

sum $base $extra ;

*************************************************;
* TABLE 2: CHARACTERISTICS OF CREDIT CONSTRAINED;

* COLUMN 1;
dprobit cantbrrw1 $base $extra  cempl1;

*COLUMN 2;
dprobit constrnd1 $base $extra  cempl1;

*COLUMN 3;
dprobit unsucc2 $base $extra;

*exit;
*******************************************************************************;
* TABLE3 COMPARING DIRECT MEASURES OF CREDIT CONSTRAINTS WITH ASSET HOLDINGS;

* at job loss;
sum r_assrat, de;
gen rzeldes=(r_assrat<2);
replace rzeldes=. if r_assrat==.;
replace rzeldes=1 if ranyass==0;
gen r_noass=1-ranyass;

*current;
replace amtasst1=0 if anyasst1==0;
gen assrat1=amtasst1/rhhinc;
gen zeldes=(assrat1<2);
replace zeldes=. if assrat1==.;
replace zeldes=1 if anyasst1==0;
gen noass=1-anyasst1;

* check item nonresponse;
sum r_noass rzeldes unsucc1 unsucc2 noass zeldes cantbrrw constr ;

* generate a variable that marks the sample for which all these variables are nonmissing;
quietly reg W2RESP r_noass rzeldes unsucc1 unsucc2 noass zeldes cantbrrw constr ;
gen sample=0;
replace sample=1 if e(sample)==1;
sum r_noass rzeldes unsucc1 unsucc2 noass zeldes cantbrrw constr if sample==1;

* note that rzeldes refers to at the job loss, and zeldes refers to at interview 1. similarly for ranyass and anyass;
* we compare the cant borrow and cnstr variables to interview 1 assets (because they refer to the current state);
* we compare the SCF type questions (unsucc1 unsucc2) to asset at job loss, as they refer to the interval between jobloss and interview 1;
* Kappa statistic. Note that Kappa =1 for perfect agreement, = 0 for agreement that would arise "by chance" and <0 for less than chance agreement;

* Row1;
kap noass cantbrrw if sample==1, tab ;
* Row2;
kap noass constr if sample==1,tab;
* Row3;
kap r_noass unsucc1 if sample==1,tab;
* Row 4;
kap r_noass unsucc2 if sample==1,tab; 
* Row 5;
kap zeldes cantbrrw if sample==1, tab ;
* Row 6;
kap zeldes constr if sample==1,tab;
* Row 7;
kap rzeldes unsucc1 if sample==1,tab;
* Row 8;
kap rzeldes unsucc2 if sample==1,tab; 



*exit;

*****************************************************************************;
* Consumption Growth/ Excess Sensitivity;

* consumption growth rate (int1 to int2);
gen dlnx =ln(cxtot2/cxtot1);

* adjusting consumption growth for elapsed time;
*c=c0e^rt --> lnc-lnc0=rt --> (lnc-lnc0)/t = r;
gen t=(welapsd2-welapsd1)/52;
sum t;
replace dlnx=dlnx/t;

* trim outliers in growth rates;
cumul dlnx, gen(fx);
replace dlnx=. if fx>=.99|fx<=.01; 
drop fx;

* lagged income level (int 1);
replace chhinc1=cpinc1 if (chhinc1==.&chhsize1==1);
replace chhinc2=cpinc2 if (chhinc2==.&chhsize2==1);
gen lny=ln(chhinc1);
gen dlny=ln(chhinc2/chhinc1);

*  change in household size;
gen dlhhsize=ln(chhsize2/chhsize1);

sum dlnx  lny dlhhsize constrnd1 cantb age;

gen unconst=1-constr;
gen canb=1-cantb;
gen age2=age^2;
* change in employment;
gen demp=cempl2-cempl1;

drop if lny==.;
drop if dlnx==.;
egen mlny=mean(lny);
replace lny=lny-mlny;

* TABLE 4: CONSUMPTION GROWTH

* COLUMN 1;
reg dlnx age  dlhhsize  cantb constrnd1 anyasst1, rob;

* COLUMN 2;
reg dlnx age  dlhhsize cantb constrnd1 anyasst1 demp  , rob;

* TABLE 5: CONSUMPTION GROWTH WITHIN GROUPS (and excess sensitivity tests);


* COLUMN 1;
reg dlnx age  dlhhsize lny, rob;
* COLUMN 2;
reg dlnx age  dlhhsize lny if constr==0, rob;
* COLUMN 3;
reg dlnx age  dlhhsize lny if cantb==0, rob;
* COLUMN 4;
reg dlnx age  dlhhsize demp lny, rob;
* COLUMN 5;
reg dlnx age  dlhhsize demp lny if constr==0, rob;
* COLUMN 6;
reg dlnx age  dlhhsize demp lny if cantb==0, rob;

*****************************************************************************;
*TABLE 6 - FINANCIAL HARDSHIP ON JOB LOSS;

gen brrw_cat=.;
replace brrw_cat=0 if applied==0&discouraged==0;
replace brrw_cat=1 if applied==1&unsucc1==0;
replace brrw_cat=2 if applied==1&unsucc1==1;
replace brrw_cat=3 if discouraged==1;
label define brrw_cat 0 "no demand" 1 "successful applicant" 2 "unsuccessful applicant" 3 "discouraged";
label values brrw_cat brrw_cat;
tab brrw_cat, gen(bcat);
rename bcat2 success;
rename bcat3 unsucc;
rename bcat4 dscrgd;


* COLUMN 3 (FULL CONTROLS) NOTE that only last three coefficients appear in table;
dprobit hrdshp1 $base $extra  success unsucc dscrgd;
gen complete=e(sample)==1;

* COLUMN 2 (NO CONTROLS BUT SAME SAMPLE);
dprobit hrdshp1 success unsucc dscrgd if complete==1;

* COLUMN 1 (RAW PROPORTION, SAME SAMPLE);
tab brrw_cat hrdshp1 if complete==1, row;


*****************************************************************************;
log close;
exit;

