* this do file generates the results in Table 4 from Siminski (2013) 'Employment Effects of Army Service and Veterans’ Compensation: Evidence from the Australian Vietnam-Era Conscription Lotteries' The Review of Economics and Statistics 95(1): 87–97

* note: the results in Column 1 are transferred from Table 3

************************************* Column (3) ***************************************************************

use second_stage_dis_pension, clear
* merge on predicted values from 1st stage
merge m:1 cohort ballot using predicted_1st_stage
drop _merge
* generate birth cohort dummies 
tabulate cohort, gen(c)

* overidentified IV 2sls (veteran is only endog regressor)
local years "90 93 96 99 02 06 09"
foreach year in `years'{
	quietly reg dpsr pvet c2-c16 [fw=fwt`year'], robust 
	est store dis`year'
}

************************************* Column (2) ***************************************************************
* the estimates underlying Column 2 are more complicated - because men who migrated after the age of 20 cannot be excluded from the tax-return 2nd stage database.
* As outlined in the manuscript, this necessitates adjustments to the 1st stage database - to include approximate counts of additional men who migrated to Australia after the ballots.
* The procedure is to identify the proportion of the population that migrated after the age of 20 by 2006 (using the Census) - within each birth cohort/ballot outcome combination
* For analysis of outcomes at 2006, the first stage database is adjusted proportionally - i.e. the number of men is increased accordingly in each ballot-outcome/birth cohort - and they are assumed to have not served in the Australian army in this era
* For analysis of outcomes at other years (1993, 1996, 1999, 2002, 2009) the number of 'recent migrants' was linearly interpolated (extrapolated for 2009). i.e. those migrants were assumed to arrive at a constant
* rate between the year of each ballot and 2009.

* Further, the first stage excludes men born on the 1st Jan, 1st July and 10th October of any year - as outlined in the manuscript.
use first_stage_w_DOB_exclusions, clear

* calculations of approx number of migrants to include in first stage database
* collapse into a count of men by ballot outcome and birth cohort
collapse (sum) fweight, by(cohort ballot)

* now include data (calculated from restricted access Census data) on proportion of men in each birth cohort/ballot outcome who were born in Aus or arrived before the age of 20 - at 2006
merge 1:1 cohort ballot using not_recent_migrant
keep if _merge == 3
drop _merge
*calculate number of additional migrants (up to 2006) to add into the data for each cohort and ballot outcome
g double migrants2006 = fweight/not_recent_migrant - fweight
* now interpolate for the other years
g ballotyear = floor(cohort)+20
local yrs "1993 1996 1999 2002 2009"
foreach year in `yrs'{
	g double migrants`year' = (`year' - ballotyear)/(2006 - ballotyear) * migrants2006
}
tempfile migrants
save `migrants'

use first_stage_w_DOB_exclusions
tab cohort, gen(c)
merge m:1 cohort ballot using `migrants'
drop _merge

* now add estimated numbers of migrants into the counts of men with no army service
local years "1993 1996 1999 2002 2006 2009"
foreach year in `years'{
	gen double fwt`year' = fweight
	replace fwt`year' = fweight + migrants`year' if armserv == 0
	* round all fwts to integers
	replace fwt`year' = round(fwt`year')
}
foreach year in 93 96 99{
	rename fwt19`year' fwt`year'
}
foreach year in 02 06 09{
	rename fwt20`year' fwt`year'
}
keep c* ballot armserv vietnam fwt*

save first_stage_w_migrants, replace

* create birth-cohort specific ballot-outcome IVs
forvalues bcohort = 1/16 {
g z`bcohort' = ballot*c`bcohort'
}

* now run all the relevant first stage regressions and keep the predicted values
local years "93 96 99 02 06 09"
foreach year in `years' {
	reg vietnam z1-z16 c2-c16 [fw=fwt`year'], robust 
	predict double vhat`year'
	reg armserv z1-z16 c2-c16 [fw=fwt`year'], robust 
	predict double rhat`year'
}

collapse (mean) vhat93 vhat96 vhat99 vhat02 vhat06 vhat09 rhat93 rhat96 rhat99 rhat02 rhat06 rhat09 c2-c16, by(cohort ballot)
save predicted_1st_stage_w_migrants, replace

* open second stage database
use second_stage_tax_returns.dta, clear
*merge on predicted values
merge m:1 cohort ballot using predicted_1st_stage_w_migrants
keep if _merge == 3
* drop last 5 cohorts
drop if cohort > 1950.15
foreach year in `years' {
	quietly reg employed vhat`year' c2-c11 [fw=wt`year'], robust
	est store emp`year'
}
esttab emp* using Table4.rtf, b(%8.3f) se(%8.3f) parentheses  scalar(N) mtitles compress replace keep(vhat93 vhat96 vhat99 vhat02 vhat06 vhat09)
esttab dis* using Table4.rtf, b(%8.3f) se(%8.3f) parentheses  scalar(N) mtitles compress append keep(pvet)
