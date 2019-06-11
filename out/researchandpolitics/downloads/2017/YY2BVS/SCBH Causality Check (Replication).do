*Title: SCBH Causality Check
*Author: Jack Reilly
*Date: 4.28.17
*Purpose: Examine contextual influence across social connectedness
*Requires: 1992 CNES Data File, "SCBH Data Management.do", "spost13" package, "sol" graphics scheme
*Output: Results, graphics
*Stata 13.1 SE on macOS 10.12

cd "~/your/working/directory"
use "connectedness_working.dta", clear

corr outdegree vote
corr outdegree pid

collapse (mean) outdegree (sd) vote pid, by(cnty)

scatter outdegree vote
corr outdegree vote
reg outdegree vote

twoway (scatter outdegree vote), ytitle(Average Social Connectedness in County) xtitle(Vote Heterogeneity in County (SD)) title(Social Connectedness by Vote Heterogeneity) subtitle(County Level Measurement) 
graph export "county_homogeneityXconnectedness.pdf", replace

scatter outdegree pid
corr outdegree pid
reg outdegree pid

twoway (scatter outdegree pid), ytitle(Average Social Connectedness) xtitle(PID Heterogeneity in County (SD)) title(Social Connectedness by PID Heterogeneity) subtitle(County Level Measurement) note(Individual Level Correlation = 0.055)
graph export "county_outdegreeXpidSD.pdf", replace

*Individual Network Homogeneity

use "connectedness_working.dta", clear

bys cnty: egen countyhomogvote=sd(vote)
bys cnty: egen countyhomogpid=sd(pid)

reg outdegree countyhomogvote pid3 black hispanic female income educ
reg outdegree countyhomogpid pid3 black hispanic female income educ

reg outdegree c.countyhomogpid##c.pid3 educ income minority hispanic female
margins, dydx(countyhomogpid) at(pid3=(-1(1)1)) predict(xb)
marginsplot
graph export "homog_pid_interx.pdf", replace

reg outdegree c.countyhomogvote##c.pid3 educ income minority hispanic female
margins, dydx(countyhomogvote) at(pid3=(-1(1)1)) predict(xb)
marginsplot
graph export "homog_vote_interx.pdf", replace

save "connectedness_causality_working.dta", replace
