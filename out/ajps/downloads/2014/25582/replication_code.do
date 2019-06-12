/* replication code for:
How Lasting is Voter Gratitude? An Analysis of the Short- and Long-term Electoral Returns to Beneficial Policy"
M. Bechtel and J. Hainmueller */
set more off
/* Table I */

* col 1 Placebo regression
use  "1994_1998.dta", replace
xi: xtreg spd_z_vs Flooded PostPeriod , cl( wkr) fe

* col 2 - 4 Short Term Effects
use  "1998_2002.dta", replace
* no covars
xi: xtreg spd_z_vs Flooded PostPeriod , cl( wkr) fe
* covars
xi: xtreg spd_z_vs Flooded PostPeriod xx*, cl( wkr) fe
* first diff mit lagged vote shares
xi: reg del_spd_z_vs Flooded Lagspd_z_vs dd*, r

* col 5 - 7 Long Term Effects
use  "1998_2005.dta", replace
* no covars
xi: xtreg spd_z_vs Flooded PostPeriod , cl( wkr) fe
* covars
xi: xtreg spd_z_vs Flooded PostPeriod xx*, cl( wkr) fe
* first diff mit lagged vote shares
xi: reg del_spd_z_vs Flooded Lagspd_z_vs dd*, r

* col 8 - 10 Very Long Term Effects
use  "1998_2009.dta", replace
* no covars
xi: xtreg spd_z_vs Flooded PostPeriod , cl( wkr) fe
* covars
xi: xtreg spd_z_vs Flooded PostPeriod xx*, cl( wkr) fe
* first diff mit lagged vote shares
xi: reg del_spd_z_vs Flooded Lagspd_z_vs dd*, r


/* Short Term Effects on PR Vote Shares of CDU and PDS*/
use  "1998_2002.dta", replace

* cdu
xi: xtreg cdu_z_vs Flooded PostPeriod xx* , cl( wkr) fe
* pds
xi: xtreg pds_z_vs Flooded PostPeriod xx* , cl( wkr) fe

/* Short Term Effects on SPD SMD (Single Majority District) Vote Shares */
* spd smd
xi: xtreg spd_e_vs Flooded PostPeriod xx* , cl( wkr) fe
