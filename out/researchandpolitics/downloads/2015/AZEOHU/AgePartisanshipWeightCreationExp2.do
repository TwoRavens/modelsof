*/ Setup */

clear all
set linesize 120
macro drop _all
set more off
set scheme s2color

*/ Experiment #2 */

/*CREATE PARTISANSHIP DATA SET WITH ADJUSTED TOTALS SO THAT SAMPLE & POP
> PERCENTS MATCH */
local ssize=847
clear

* http://www.people-press.org/2015/04/07/a-deep-dive-into-party-affiliation/

/* Partisanship from Pew: Dem = 48, GOP = 39, Indep = 13 */
input partisanship_gp pop_pct
0 .48
1 .39
2 .13

end
gen partisanship_tot=`ssize'*pop_pct
list
table partisanship_gp , c(sum partisanship_tot) row
sort partisanship_tot
rename partisanship_gp partleaners
save partisanship_dat2, replace

* gen old_wt=1
* survwgt rake old_wt, by(partleaners) totvars(partisanship_tot) generate(new_wt)

clear

/*CREATE AGE DATA SET WITH ADJUSTED TOTALS SO THAT SAMPLE & POP
> PERCENTS MATCH */
local ssize=847
clear

* http://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?src=bkmk

/* Age from ACS: 18-19 = about 2.72, 20-29 = 14, 30-39 = 12.9, 40-49 = 13.3, 50-59 = 13.8, 60-69 = 10.4, above 69 = 9.5; adjusted for lack of under 18 */
input age_gp pop_pct
1 0.060428571
2 0.173428571
3 0.162428571
4 0.166428571
5 0.171428571
6 0.137428571
7 0.128428571


end
gen age_tot=`ssize'*pop_pct
list
table age_gp , c(sum age_tot) row
sort age_tot
rename age_gp age
save age_dat2, replace
clear
