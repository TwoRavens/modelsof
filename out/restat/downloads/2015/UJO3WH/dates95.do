*************************************/
* dates95.do
* Empirical Analsysis for: * Crossley, T.F., and H. Low, “Job Loss, Credit Constraints and Consumption Growth.” Review of Economics and Statistics, 96(5):876-884 (December, 2014.) 
* Contact: tfcrossley@gmail.com or tcross@esex.ac.uk
* this program converts interview, roe and job start dates to hrdc format;
* this program is called by cl_data.do.
* last revised 2014
* note verson statement (uses some very old code)
* *************************************/ ;
version 5.0
#delimit;
* set more 1;
*************************************/ ;

* interview 1 week;
gen hidate1=date(i_date1,"mdy")/7-312;
label variable hidate1 "interview 1";
sum hidate1, de;

* interview 2 week;
gen hidate2=date(i_date2, "mdy")/7-312;
label variable hidate2 "interview 2";
sum hidate2,de;

* roe week;
gen hrdate1=date(ROEDATE,"mdy")/7-312;
label variable hrdate1 "roe date";
sum hrdate1, de;

gen welapsd1 = hidate1-hrdate1;
replace welapsd1=. if welapsd1<=0;
sum welapsd1,de;

gen welapsd2=hidate2-hrdate1;
replace welapsd2=. if welapsd2<=0;
sum welapsd2,de;

***************************************************************;
exit;


