global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/newtables/"

# delimit ;

capture log close;
clear;
set mem 2000m;
set more off;

use ${x}wagetables.dta;

gen educge16=(educ==4 | educ==5) if educ~=.;
label variable educge16 "College or advanced degree";

gen educ13_15=(educ==3) if educ~=.;
label variable educ13_15 "Some College";

gen educle12=(educ==1 | educ==2) if educ~=.;
label variable educle12 "Less Than High School or High School Degree";

gen routine=(finger + sts)/(finger + sts + math + dcp + ehf);

keep if year>=1983;

xi I.educ I.man7090_orig I.state I.year;
save ${x}temp_dist.dta, replace;

********************************************************;
* Use two-year period (1983-1984) to get thicker cells *;
********************************************************;
use ${x}temp_dist.dta, clear;
reg lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_lrpiship79 routine age female union exper nonwhite _Ieduc* _Iman7090_o* _Iyear* _Istate* if year==1983 | year==1984 [weight=ihwt], robust cluster(man7090_orig);
predict lwagehat83_84;  
estimates store model2;
*****************************************;
* No Offshoring to Low Income Countries *;
*****************************************;
gen p_llowincemp2=p_llowincemp;
replace p_llowincemp=0;
estimates restore model2;
predict lwagehat_nolowoff;
drop p_llowincemp;
rename p_llowincemp2 p_llowincemp;
***********************************************;
* Half the Offshoring to Low Income Countries *;
***********************************************;
gen p_llowincemp2=p_llowincemp;
replace p_llowincemp=p_llowincemp*.5;
estimates restore model2;
predict lwagehat_halflowoff;
drop p_llowincemp;
rename p_llowincemp2 p_llowincemp;
******************************************;
* No Offshoring to High Income Countries *;
******************************************;
gen p_lhigh2=p_lhigh;
replace p_lhigh=0;
estimates restore model2;
predict lwagehat_nohighoff; 
drop p_lhigh;
rename p_lhigh2 p_lhigh;
collapse lwagehat83_84 lwagehat_nolowoff lwagehat_halflowoff lwagehat_nohighoff p_llowincemp p_lhigh (p10) lwage10_=lwagehat83_84 (p50) lwage50_=lwagehat83_84 (p90) lwage90_=lwagehat83_84 (p10) lwage10_nolowoff=lwagehat_nolowoff (p50) lwage50_nolowoff=lwagehat_nolowoff (p90) lwage90_nolowoff=lwagehat_nolowoff (p10) lwage10_halflowoff=lwagehat_halflowoff (p50) lwage50_halflowoff=lwagehat_halflowoff (p90) lwage90_halflowoff=lwagehat_halflowoff (p10) lwage10_nohighoff=lwagehat_nohighoff (p50) lwage50_nohighoff=lwagehat_nohighoff (p90) lwage90_nohighoff=lwagehat_nohighoff [weight=ihwt], by(year) fast;
************************************************;
* Create 90/50 Wage Ratio and 50/10 Wage Ratio *;
************************************************;
bysort year: gen lwage90_50=lwage90_-lwage50_;
bysort year: gen lwage50_10=lwage50_-lwage10_;
bysort year: gen lwage90_50_nolow=lwage90_nolowoff-lwage50_nolowoff;
bysort year: gen lwage50_10_nolow=lwage50_nolowoff-lwage10_nolowoff;
bysort year: gen lwage90_50_nohigh=lwage90_nohighoff-lwage50_nohighoff;
bysort year: gen lwage50_10_nohigh=lwage50_nohighoff-lwage10_nohighoff;
bysort year: gen lwage90_50_halflow=lwage90_halflowoff-lwage50_halflowoff;
bysort year: gen lwage50_10_halflow=lwage50_halflowoff-lwage10_halflowoff;
save ${x}wagedist_8384.dta, replace; 
*******************************************************************************************************************************;
* What would predicted log wage be in 2002 if there were no offshoring? half of current offshoring? current level offshoring? *;
*******************************************************************************************************************************;
twoway line (lwage90_50 lwage50_10) year; 
twoway line (lwage90_50_nolow lwage50_10_nolow) year; 
twoway line (lwage90_50_halflow lwage50_10_halflow) year; 
twoway line (lwage90_50_nohigh lwage50_10_nohigh) year; 
twoway line (lwage90_50 lwage90_50_nolow lwage90_50_halflow) year; 
twoway line (lwage10_ lwage50_ lwage90_) year;
twoway line (lwage90_ lwage90_nolowoff lwage90_halflowoff lwage90_nohighoff) year;
twoway line (lwage90_50 lwage90_50_nolow lwage90_50_halflow lwage90_50_nohigh) year;
twoway line (lwage50_10 lwage50_10_nolow lwage50_10_halflow lwage50_10_nohigh) year;


*****************;
* Use All Years *;
*****************;
use ${x}temp_dist.dta, clear;
reg lwage p_llowincemp p_lhigh p_lpiinv100 p_tfp579 p_expmod79 p_penmod79 p_lrpiship79 routine age female union exper nonwhite _Ieduc* _Iman7090_o* _Iyear* _Istate* [weight=ihwt], robust cluster(man7090_orig);
predict lwagehat;  
estimates store model1;
gen p_llowincemp2=p_llowincemp;
replace p_llowincemp=0;
estimates restore model1;
predict lwagehat_nolowoff;
drop p_llowincemp;
rename p_llowincemp2 p_llowincemp;
gen p_lhigh2=p_lhigh;
replace p_lhigh=0;
estimates restore model1;
predict lwagehat_nohighoff; 
drop p_lhigh;
rename p_lhigh2 p_lhigh;
collapse lwagehat lwagehat_nolowoff lwagehat_nohighoff p_llowincemp p_lhigh (p10) lwage10_=lwagehat (p50) lwage50_=lwagehat (p90) lwage90_=lwagehat (p10) lwage10_nolowoff=lwagehat_nolowoff (p50) lwage50_nolowoff=lwagehat_nolowoff (p90) lwage90_nolowoff=lwagehat_nolowoff (p10) lwage10_nohighoff=lwagehat_nohighoff (p50) lwage50_nohighoff=lwagehat_nohighoff (p90) lwage90_nohighoff=lwagehat_nohighoff [weight=ihwt], by(year) fast;
************************************************;
* Create 90/50 Wage Ratio and 50/10 Wage Ratio *;
************************************************;
bysort year: gen lwage90_50=lwage90_-lwage50_;
bysort year: gen lwage50_10=lwage50_-lwage10_;
bysort year: gen lwage90_50_nolow=lwage90_nolowoff-lwage50_nolowoff;
bysort year: gen lwage50_10_nolow=lwage50_nolowoff-lwage10_nolowoff;
bysort year: gen lwage90_50_nohigh=lwage90_nohighoff-lwage50_nohighoff;
bysort year: gen lwage50_10_nohigh=lwage50_nohighoff-lwage10_nohighoff;
save ${x}wagedist_all.dta, replace; 

*************************************************************************;
* See if can mirror Autor, Katz, Kearney p90/p50, p50/p10 distributions *;
*************************************************************************;
use ${x}temp_dist.dta, clear;
collapse lwage90 lwage50 lwage10 [weight=ihwt], by(year);
bysort year: gen lwage90_50=lwage90-lwage50;
bysort year: gen lwage50_10=lwage50-lwage10;
twoway line (lwage90_50 lwage50_10) year; 
twoway line (lwage90 lwage50 lwage10) year;
save ${x}wagedist_small.dta, replace; 

erase ${x}temp_dist.dta;
exit;
