**************************************;
* roevars.do
* Empirical Analsysis for: * Crossley, T.F., and H. Low, “Job Loss, Credit Constraints and Consumption Growth.” Review of Economics and Statistics, 96(5):876-884 (December, 2014.) 
* Contact: tfcrossley@gmail.com or tcross@esex.ac.uk
* this program is called by cl_data.do
* this program creates some time-of-job-loss variables
* last revised 2014
**************************************
*set more 1
#delimit;

**********************************;
replace aamtrse1=. if aamtrse1==9995;
replace damtrse1=. if damtrse1==9995;
replace chhinc1=. if chhinc1==9995;
replace damtfll1=. if damtfll1==99995;
*****************************************************/;
*creating variable for hhinc at separation date;
g rhhinc=chhinc1;
replace rhhinc=chhinc1+iamtfll1 if iamtfll1~=.;
replace rhhinc=chhinc1-iamtrse1 if iamtrse1~=.;
sum chhinc1 rhhinc;
****************************************************/;
*creating variable for hhdebt at separation date;

g rhhdebt=amtdebt1;
replace rhhdebt=amtdebt1+damtfll1 if damtfll1~=.;
replace rhhdebt=amtdebt1-damtrse1 if damtrse1~=.;
sum amtdebt1 rhhdebt;
***************************************************/;
*creating variable for hhassets at separation date;

g rhhass=amtasst1;
replace rhhass=amtasst1+aamtfll1 if aamtfll1~=.;
replace rhhass=amtasst1-aamtrse1 if aamtrse1~=.;
sum rhhass amtasst1;
******************************************************/;
***********************************************************/;
*log close;

exit;
