***************************************
* clsample.do
* Empirical Analsysis for: * Crossley, T.F., and H. Low, “Job Loss, Credit Constraints and Consumption Growth.” Review of Economics and Statistics, 96(5):876-884 (December, 2014.) 
* Contact: tfcrossley@gmail.com or tcross@esex.ac.uk
* this program is called by cl_credit.do
* this progam selects sample for analysis
* 

***************************************
#delimit;
**************************************;


count;

* drop continuing employed;
tab i1spell, mis;
drop if i1spell==5;
count;

* drop if quit to take another job;
drop if rqreas1==4;
count;

* age;
drop if age<26;
drop if age>55;
count;

* primary earner (head of household);
keep if prim==1;
count;


* focus on nuclear families;
drop if cparnts1==1;
drop if cothers1==1;
count;

*************************************************;
exit;

