/*
Chen, Pan, and Xu "Sources of Authoritarian Responsiveness: A Field Experiment in China"
Replication File -- Supporting Information -- Tables A2-A8
*/

clear all
set more off
set mem 1g

*******************
* Table A2. Speed
*******************

* time is measured in work days
use forum, clear
g response1week = response_time<=5
g response2week = response_time<=10
g response3week = response_time<=15
g response4week = response_time<=20

* unconditional
reg response1week tr1 tr2 tr3, r
reg response2week tr1 tr2 tr3, r
reg response3week tr1 tr2 tr3, r
reg response4week tr1 tr2 tr3, r


*************************
* Table A3. Urban/Rural
*************************

use forum, clear
keep if posted==1
g info = response_content==3

* urban
reg response tr1 tr2 tr3 if urban>=50, r
reg response_public tr1 tr2 tr3 if urban>=50, r
reg info tr1 tr2 tr3 if urban>=50, r

* rural
reg response tr1 tr2 tr3 if urban<50, r
reg response_public tr1 tr2 tr3 if urban<50, r
reg info tr1 tr2 tr3 if urban<50, r


*************************
* Table A4. Minority
*************************


use forum, clear
keep if posted==1 
g info = response_content==3

* miniorty<10%
reg response tr1 tr2 tr3 if minor<10, r
reg response_public tr1 tr2 tr3 if minor<10, r
reg info tr1 tr2 tr3 if minor<10, r

* miniorty>=10%
reg response tr1 tr2 tr3 if minor>=10, r
reg response_public tr1 tr2 tr3 if minor>=10, r
reg info tr1 tr2 tr3 if minor>=10, r


****************************
* Table A5. Economic Growth
****************************

use forum, clear
keep if posted==1
g info = response_content==3
keep if avggrowth!=.
sum avggrowth, d
local med = `r(p50)'

* high growth
reg response tr1 tr2 tr3 if avggrowth>`med', r
reg response_public tr1 tr2 tr3 if avggrowth>`med', r
reg info tr1 tr2 tr3 if avggrowth>`med', r

* low groth
reg response tr1 tr2 tr3 if avggrowth<=`med', r
reg response_public tr1 tr2 tr3 if avggrowth<=`med', r
reg info tr1 tr2 tr3 if avggrowth<=`med', r


*************************
* Table A6. Active Sites
*************************

use forum, clear
keep if posted==1
g info = response_content==3

* active
reg response tr1 tr2 tr3 if forum_recent_response==1, r
reg response_public tr1 tr2 tr3 if forum_recent_response==1, r
reg info tr1 tr2 tr3 if forum_recent_response==1, r

* inactive
reg response tr1 tr2 tr3 if forum_recent_response==0, r
reg response_public tr1 tr2 tr3 if forum_recent_response==0, r
reg info tr1 tr2 tr3 if forum_recent_response==0, r

****************************************************
* Table A7. Correlations: socio-economic indicators
****************************************************

use forum, clear
global covar = "loggov_rev logpop loggdp migrant urban eduyr minor unemploy avggrowth "
qui foreach var of varlist $covar {
   sum `var'
   replace `var'=(`var'-r(mean))/r(sd)
}

reg response tr1 tr2 tr3 $covar, cl(prov)
reg posted tr1 tr2 tr3 $covar, cl(prov)
reg response tr1 tr2 tr3 $covar if posted, cl(prov)


****************************************************
* Table A8. Correlations: website characteristics
****************************************************

use forum, clear
keep if posted
g info = response_content==3
global covar = "forum_response forum_recent_response forum_imme_viewable post_name post_tel post_email post_address post_idnum "

reg response tr1 tr2 tr3 $covar, cl(prov)
reg response_public tr1 tr2 tr3 $covar, cl(prov)
reg info tr1 tr2 tr3 $covar, cl(prov)

