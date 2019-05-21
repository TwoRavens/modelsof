/* 
Elliott Ash, Massimo Morelli, and Richard Van Weelden
"Elections and Divisiveness: Theory and Evidence"
Replication Code

Code and details for construction of dataset from Congressional Record available upon request.
Contact Elliott Ash at etash@princeton.edu for details.
*/

* Load data.
use senate_data, clear

* Table 3
eststo clear
eststo: reg logslants i.repub#i.year cohort , cluster(state)
eststo: areg logslants i.repub#i.year cohort , absorb(stateyearfe) cluster(state)
eststo: areg logslants i.repub#i.year cohort , absorb(speakerfe) cluster(state)
eststo: areg logslants i.repub#i.year exper* cohort, absorb(speakerfe) cluster(state)

esttab, ar2 se drop(_cons *year* *exper*) star(* 0.10 ** 0.05 *** 0.01)

* Figure 1
areg logslanth, a(speakerfe)
predict resids, residuals
lgraph resids exper if exper <= 10, errortype(95)

use house_data, clear

* Table 4
eststo clear

eststo: reg logslanth i.year#i.repub logtrans , cluster(district)
eststo: reg logslanth i.year#i.repub presmargin* logtrans , cluster(district)
eststo: areg logslanth i.year#i.repub presmargin* logtrans , absorb(stateyearfe) cluster(district)
eststo: areg logslanth i.year#i.repub presmargin* logtrans , absorb(speakerfe) cluster(district)
eststo: areg logslanth i.year#i.repub i.stateyearfe i.exper#i.repub presmargin* logtrans , absorb(speakerfe) cluster(district)
eststo: areg logslanth i.year#i.repub presmargin* logtrans if year >= 1993 & year <= 1999 , absorb(speakerfe) cluster(district)

esttab using ~/research/projects/eash/congress/analysis/2016-05-JoP/trans.csv, replace ar2 se drop(_cons *year* *exper*) star(* 0.10 ** 0.05 *** 0.01)

esttab using ~/research/projects/eash/congress/analysis/2016-05-JoP/trans-p.csv, replace ar2 p drop(_cons *year* *exper*) star(* 0.10 ** 0.05 *** 0.01)

* Figure 2
cmogram logslanth trans , histopts(width(.2)) scatter lfit ci(90)

