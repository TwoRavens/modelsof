clear all
set more off
set matsize 11000
set maxvar 25000


**Aaron Flaaen
**July 25, 2014
**Last Updated: August 5, 2017
**This File Conducts Analysis of the Inventory Behavior of Multinationals
**-------------------------------------------------------------------------

cd $dir

**------------------------------------------------------------------------
**Step 1: Prep Data
**--------------------------------------------------------------------------

use cmf_tvs_2007.dta, clear

collapse (sum) fib fie wib wie tvs mib mie cp, by(firmid)

save cmf_firm.dta, replace



*use analysisdata_manuf.dta, clear
!gunzip analysisdata_manufU.dta.gz
use analysisdata_manufU.dta, clear
keep if year==2009
keep firmid flag_us_mult flag_for_mult japan
duplicates drop

merge 1:1 firmid using cmf_firm.dta
keep if _m==3


**------------------------------------------------------------------------
**Step 2: Construct Measures
**--------------------------------------------------------------------------

**Construct 
gen matinvusage = mib / (cp/12)
gen fininvusage = fib / (tvs/12)


matrix INVSTATS = J(6,1,1)

sum matinvusage if japan==1 , detail
matrix INVSTATS[1,1] = r(mean)
sum matinvusage if japan==1 [aweight=tvs], detail
matrix INVSTATS[2,1] = r(mean)

sum matinvusage if flag_us_mult==1 , detail
matrix INVSTATS[3,1] = r(mean)

sum matinvusage if flag_us_mult==1 [aweight=tvs] , detail
matrix INVSTATS[4,1] = r(mean)

sum matinvusage if flag_for_mult==1 , detail
matrix INVSTATS[5,1] = r(mean)

sum matinvusage if flag_for_mult==1 [aweight=tvs] , detail
matrix INVSTATS[6,1] = r(mean)


drop _all

svmat INVSTATS

sum matinvusage if japan==1 [aweight=tvs], detail










