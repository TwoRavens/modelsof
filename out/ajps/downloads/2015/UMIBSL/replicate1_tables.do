/*
Chen, Pan, and Xu "Sources of Authoritarian Responsiveness: A Field Experiment in China"
Replication File -- Tables 1-4

*/

clear all
set more off
set mem 1g

****************************
* Table 1. Balance Check 
****************************

use forum, clear
global covar = "logpop logpop00 popgrow sexratio logpopden migrant nonagrhh urban eduyr illit minor unemploy wk_agr wk_ind wk_ser income logincome loggdp avggrowth logoutput_agr logoutput_ind logoutput_ser numlfirm loginvest logsaving loggov_rev loggov_exp"

* summary statistics
sum $covar
tabstat $covar, by(treat) nototal

* F tests
mat Ftest  = J(27,1,0)
local j = 1
qui foreach var of varlist $covar {
  reg `var' i.treat, r
  test 1.tr=2.tr=3.tr=0
  mat Ftest[`j',1]=r(p)
  local j = `j'+1
}
mat list Ftest

****************************
* Table 2. Main Results
****************************

use forum, clear

* demean control variables (Lin's method)
foreach var of varlist forum_* post_* logpop nonagrhh urban eduyr unemploy minor {
   egen mean_`var'=mean(`var')
   g dm_`var'=`var'-mean_`var'
}
global control_dem = "i.treat##(c.dm_logpop c.dm_nonagrhh c.dm_urban c.dm_eduyr c.dm_unemploy c.dm_minor)"
global control_web = "i.treat##(c.dm_forum_response c.dm_forum_recent_response c.dm_forum_imme_viewable c.dm_post_email c.dm_post_name c.dm_post_idnum c.dm_post_tel c.dm_post_address)"

* unconditional
reg response tr1 tr2 tr3, r
areg response tr1 tr2 tr3, a(city) r
areg response tr1 tr2 tr3 $control_dem, a(city) r

* conditional
reg response tr1 tr2 tr3 if posted, r
areg response tr1 tr2 tr3 if posted, a(city) r
areg response tr1 tr2 tr3 $control_dem $control_web if posted, a(city) r

* Clustering gives basically the same results
reg response tr1 tr2 tr3, cl(prov)
areg response tr1 tr2 tr3, a(city) cl(prov)
areg response tr1 tr2 tr3 $control_dem, a(city) cl(prov)
reg response tr1 tr2 tr3 if posted, cl(prov)
areg response tr1 tr2 tr3 if posted, a(city) cl(prov)
areg response tr1 tr2 tr3 $control_dem $control_web if posted, a(city) cl(prov)

reg response tr1 tr2 tr3, cl(city)
areg response tr1 tr2 tr3, a(city) cl(city)
areg response tr1 tr2 tr3 $control_dem, a(city) cl(city)
reg response tr1 tr2 tr3 if posted, cl(city)
areg response tr1 tr2 tr3 if posted, a(city) cl(city)
areg response tr1 tr2 tr3 $control_dem $control_web if posted, a(city) cl(city)

****************************
* Table 3. Public Response
****************************

use forum, clear

* demean control variables (Lin's method)
foreach var of varlist forum_* post_* logpop nonagrhh urban eduyr unemploy minor {
   egen mean_`var'=mean(`var')
   g dm_`var'=`var'-mean_`var'
}
global control_dem = "i.treat##(c.dm_logpop c.dm_nonagrhh c.dm_urban c.dm_eduyr c.dm_unemploy c.dm_minor)"
global control_web = "i.treat##(c.dm_forum_response c.dm_forum_recent_response c.dm_forum_imme_viewable c.dm_post_email c.dm_post_name c.dm_post_idnum c.dm_post_tel c.dm_post_address)"

* unconditional
reg response_public tr1 tr2 tr3, r
areg response_public tr1 tr2 tr3 $control_dem, a(city) r

* conditional
reg response_public tr1 tr2 tr3 if posted, r
areg response_public tr1 tr2 tr3 $control_dem $control_web if posted, a(city) r


* two sample test: collective action vs. tattling
use forum, clear
keep if inlist(treat,1,2)
ttest response, by(treat) welch 
ttest response_public, by(treat) welch 

* two sample test: collective action vs. loyalty
use forum, clear
keep if inlist(treat,1,3)
ttest response, by(treat) welch 
ttest response_public, by(treat) welch 


********************
* Table 4 Content
********************

* raw
use forum, clear
tab treat response_content, row


