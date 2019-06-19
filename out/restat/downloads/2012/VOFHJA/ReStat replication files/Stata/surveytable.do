/* 
  Title: surveytable.do
  Produces: surveytable.log
  Author: Eric Zwick
  Re-created: 11-19-2008
  Description: This file was a mess. I think it was the product of hacking
    together Keith's, James's, and my own code. It's not appropriately 
    documented and it didn't work when I returned a year later to run it.
    I'm rewriting it to begin with James's survey spreadsheet, so that 
    posterity will know how we narrowed the sample and performed the analysis.
*/

capture log close
set more off
clear

/* MODIFY THIS LINE TO SET THE DIRECTORY */
local dir "~mainil/100_bill/100_Bill_on_the_Sidewalk/"

local datadir `dir'/raw_data/survey
local outdir `dir'/Stata/data

* Begin with James's unadulterated spreadsheet.
insheet using `datadir'/surveydata.csv
rename prsn_intn_id piid
rename treatmentcontrol treatment
* Keep only those older than 59.5.
keep if aboveorbelowage595 == "Above"
* Keep employees below threshold at time of selection (5/04/04).
keep if threshsel == "Below" | threshsel == "Not Contributing"
* Drop if threshold indicator at time of survey is missing.
drop if threshsur == "#N/A"
* Now we should have the magic, mystical, elusive 678 number.
keep piid treatment participated
g trcD = 0
replace trcD = 1 if treatment == "Treatment"
destring participated, replace
replace participated = 0 if participated == . 
g returnedSurvey = 0
replace returnedSurvey = 1 if participated == 1 & trcD == 1

merge piid using `datadir'/prsn_clnt_afltn.dta, uniqmaster keep(emplstat termdt) sort
keep if _merge == 3
* how many of the participants are still active?
by emplstat, sort: sum
keep if emplstat == "ACTIVE" | termdt > mdy(10,31,2004)
drop _merge //emplstat termdt
sort piid

merge piid using `datadir'/companyF-planelec.dta, uniqmaster keep(ataxrt btaxrt snapdate)
keep if _merge == 3
drop _merge

* generate contribution rate
g contrate = ataxrt + btaxrt
keep if snapdate == mdy(8,1,2004) | snapdate == mdy(11,1,2004)
g preRateH = 0
g postRateH = 0
replace preRateH = contrate if snapdate == mdy(8,1,2004)
replace postRateH = contrate if snapdate == mdy(11,1,2004)
sort piid
by piid: egen preRate = max(preRateH)
by piid: egen postRate = max(postRateH)
drop preRateH postRateH //snapdate
preserve
duplicates drop piid, force 
save `outdir'/ZwickInterm1.dta, replace

* Generate mean contribution rates to compare across treatments.
* Before experiment.
sum preRate if trcD == 0
local n0 = r(N)
local mean0 = r(mean)
local sd0 = r(sd)

sum preRate if trcD == 1
local n1 = r(N)
local mean1 = r(mean)
local sd1 = r(sd)
** run ttesti on these numbers to obtain t-statistic
ttesti `n0' `mean0' `sd0' `n1' `mean1' `sd1'

** After experiment.
sum postRate if trcD == 0
local n2 = r(N)
local mean2 = r(mean)
local sd2 = r(sd)

sum postRate if trcD == 1
local n3 = r(N)
local mean3 = r(mean)
local sd3 = r(sd)
ttesti `n2' `mean2' `sd2' `n3' `mean3' `sd3'

** Changes.
g rateDiff = postRate - preRate
sum rateDiff if trcD == 0
local n4 = r(N)
local mean4 = r(mean)
local sd4 = r(sd)

sum rateDiff if trcD == 1
local n5 = r(N)
local mean5 = r(mean)
local sd5 = r(sd)
ttesti `n4' `mean4' `sd4' `n5' `mean5' `sd5'

** Instrumental variables estimation
** Model: 1S: returned survey = a + b * Treatment + e
**        2s: rate change = a + b * returned survey + e
ivregress 2sls rateDiff (returnedSurvey = trcD)
restore


clear all
capture log close

*** end code