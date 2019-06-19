*******************************************************************
* cl1_avariables.do
* Empirical Analsysis for: * Crossley, T.F., and H. Low, “Job Loss, Credit Constraints and Consumption Growth.” Review of Economics and Statistics, 96(5):876-884 (December, 2014.) 
* Contact: tfcrossley@gmail.com or tcross@esex.ac.uk
* called by cl_data.do
* creates asset variables
* last revised 2014
**************************************
#delimit;

************************************************************************;
* Generate Assets and Debts at Job Loss;

capture drop rhhass;
capture drop rhhdeb;

gen dhhass=0 if asfall1==0&asrise1==0;
replace dhhass =-aamtfll1 if asfall1==1;
replace dhhass=aamtrse1 if asrise1==1;
gen rhhass=amtasst1-dhhass;
replace rhhass=0 if anyasst1==0&dhhass==0;
replace rhhass=. if rhhass<0;

gen dhhdeb=0 if dtfall1==0&dtrise1==0;
replace dhhdeb =-damtfll1 if dtfall1==1;
replace dhhdeb=damtrse1 if dtrise1==1;
gen rhhdeb=amtdebt1-dhhdeb;
replace rhhdeb=. if rhhdeb<0;


capture drop r_dass r_ddeb;

gen ranyass=(rhhas>0) if rhhas~=.;
gen ranydeb=(rhhdeb>0) if rhhdeb~=.;

sum rhhass rhhdeb ranyass ranydeb;

tab ranyass ranydeb, cell;

***********************************************************************;
* Income;


sum rhhinc;
replace rhhinc=. if rhhinc<0;


**********************************************************;
* asset ratios;

gen income=rhhinc;

gen r_assrat= rhhass/income;
sum r_assrat, de;
replace r_assrat=. if r_assrat<0;

gen r_debrat=rhhdeb/income;
sum r_debrat, de;
replace r_debrat=. if r_debrat<0;

gen r_net=rhhass-rhhdeb;
gen r_netrat=r_net/income;
sum r_netrat, de;

gen r_ass1=(r_assrat>1) if r_assrat~=.;
gen r_deb1=(r_debrat>1) if r_debrat~=.;
sum r_ass1 r_deb1 r_assrat r_debrat;
tab r_ass1 r_deb1, cell;

******************************************************;
* keep if complete information;
count;
*keep if r_netrat~=.;
count;
sum r_assrat r_netrat r_ass1 r_deb1 ranyass ranydeb;

******************************************************;

exit;

