/*
Chen, Pan, and Xu "Sources of Authoritarian Responsiveness: A Field Experiment in China"
Replication File -- Prepare for Plotting in R: Figures 1-5
*/

clear all
set more off
set mem 1g

****************************
* Figures 1-3. Balance
****************************

* regression tests
use forum, clear
recode forum_* (.=0)
foreach var of varlist attempted posted forum_* post_* {
	reg `var' tr1 tr2 tr3, r
}

* figure 
use forum, clear
global outcome = "attempted posted forum_response forum_recent_response forum_imme_viewable post_name post_tel post_email post_address post_idnum"
mat AA=J(10,8,.) //10 outcomes (rows), 4 estimates and 4 standard erros (columns)
local i=1
qui foreach var of varlist $outcome  {
	reg `var' tr1 tr2 tr3, r
	mat AA[`i',1] = _b[_cons]
	mat AA[`i',2] = _se[_cons]
	lincom _cons + tr1
	mat AA[`i',3] = r(estimate)
	mat AA[`i',4] = r(se)
	lincom _cons + tr2
	mat AA[`i',5] = r(estimate)
	mat AA[`i',6] = r(se)
	lincom _cons + tr3
	mat AA[`i',7] = r(estimate)
	mat AA[`i',8] = r(se)
	local i=`i'+1
}

* storage
matlist AA
svmat AA
keep AA*
keep if AA1~=.
forvalues i=1/4 {
  local j=`i'*2
  local m=(`i'-1)*2+1
  ren AA`m' est`i'
  ren AA`j' se`i'
  g lower`i' = est`i'-1.96*se`i'
  g upper`i' = est`i'+1.96*se`i'
}
keep est* lower* upper*
order est* lower* upper*
saveold fg_balance, replace


****************************
* Figures 4-5. Main Results
****************************

use forum, clear
mat AA=J(6,2,.)

* overall response
reg response tr1 tr2 tr3 if posted, r
mat AA[1,1] = _b[tr1]
mat AA[2,1] = _b[tr2]
mat AA[3,1] = _b[tr3]
mat AA[1,2] = _se[tr1]
mat AA[2,2] = _se[tr2]
mat AA[3,2] = _se[tr3]

* public response
reg response_public tr1 tr2 tr3 if posted, r
mat AA[4,1] = _b[tr1]
mat AA[5,1] = _b[tr2]
mat AA[6,1] = _b[tr3]
mat AA[4,2] = _se[tr1]
mat AA[5,2] = _se[tr2]
mat AA[6,2] = _se[tr3]

* storage
matlist AA
svmat AA
keep AA1 AA2
keep if AA1~=.
ren AA1 est
ren AA2 se
g lower = est-1.96*se
g upper = est+1.96*se
saveold fg_estimates, replace
