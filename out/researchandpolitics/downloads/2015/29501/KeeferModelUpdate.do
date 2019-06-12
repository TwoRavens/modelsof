///////////////
// Update Keefer (2007) with data from Laeven and Valencia (2012)
// Christopher Gandrud
// 17 March 2015
// Using Stata 12.1
///////////////

// Set up
// Change as needed.
cd "~/git_repositories/Keefer2007Replication/tables"
use "~/git_repositories/Keefer2007Replication/data/KeeferExtended_RandP.dta", clear

///// Linear Models ////////////////////////////////////////////////////////////
// Keefer Table 4, Model 2
regress Keefer2007_Fiscal ChecksResiduals33 DiEiec33 stabnsLag3, vce(cluster country)
	regsave using "A1.dta", detail(all) replace table(KeeferOriginal, order(regvars r2) format(%5.2f) paren(stderr) asterisk())

// Remove the Philippines
regress Keefer2007_Fiscal ChecksResiduals33 DiEiec33 stabnsLag3, vce(cluster country)

// Using Honohan original
regress Honohan2003_Fiscal ChecksResiduals33 DiEiec33 stabnsLag3, vce(cluster country)
	regsave using "C1.dta", detail(all) replace table(Honohan, order(regvars r2) format(%5.2f) paren(stderr) asterisk())

// Using updated LV data for crises before 2001 only when Keefer also has data
regress LV2012_Fiscal ChecksResiduals33 DiEiec33 stabnsLag3 if Keefer2007_Fiscal != ., vce(cluster country)
	regsave using "A3.dta", detail(all) replace table(LVPre2001Keef, order(regvars r2) format(%5.2f) paren(stderr) asterisk())

// Using updated LV data for crises before 2001
regress LV2012_Fiscal ChecksResiduals33 DiEiec33 stabnsLag3 if year < 2001, vce(cluster country)
	regsave using "A4.dta", detail(all) replace table(LVPre2001, order(regvars r2) format(%5.2f) paren(stderr) asterisk())

// Using full Laeven and Valencia 2012 data
regress LV2012_Fiscal ChecksResiduals33 DiEiec33 stabnsLag3, vce(cluster country)
	regsave using "A5.dta", detail(all) replace table(LVFull, order(regvars r2) format(%5.2f) paren(stderr) asterisk())

// Using Laeven and Valencia 2012 data, full sample, except for eurozone
regress LV2012_Fiscal ChecksResiduals33 DiEiec33 stabnsLag3 if eurozone == 0, vce(cluster country)
	regsave using "E1.dta", detail(all) replace table(LVFull_no_eurozone, order(regvars r2) format(%5.2f) paren(stderr) asterisk())

// Using Laeven and Valencia 2012 data, full sample, except for EU
regress LV2012_Fiscal ChecksResiduals33 DiEiec33 stabnsLag3 if eu == 0, vce(cluster country)
	regsave using "E2.dta", detail(all) replace table(LVFull_no_eu, order(regvars r2) format(%5.2f) paren(stderr) asterisk())

////// Beta and Zero Inflated Beta Models /////////////////////////////////////
// Convert to proportions
gen keefer_prop = Keefer2007_Fiscal / 100
gen lv_prop = (LV2012_Fiscal / 100)

// Keefer Table 4, Model 2 beta regression
betafit keefer_prop, mu(ChecksResiduals33 DiEiec33 stabnsLag3) vce(cluster country)
	regsave using "B1.dta", detail(all) replace table(KeeferBeta, order(regvars r2) format(%5.2f) paren(stderr) asterisk())

// Beta regresion Using Laeven and Valencia 2012 pre-2001 with adjusted DV
betafit lv_prop if year < 2001, mu(ChecksResiduals33 DiEiec33 stabnsLag3) vce(cluster country)
	regsave using "B2.dta", detail(all) replace table(LVpre2001, order(regvars r2) format(%5.2f) paren(stderr) asterisk())

// Beta regresion Using Laeven and Valencia 2012 full sample with adjusted DV
betafit lv_prop, mu(ChecksResiduals33 DiEiec33 stabnsLag3) vce(cluster country)
	regsave using "B3.dta", detail(all) replace table(LVFull, order(regvars r2) format(%5.2f) paren(stderr) asterisk())


////// Zero-inflated Beta Regression, results not included in output
// Zero-inflated Beta regression Using Laeven and Valencia 2012 for crises before 2001
zoib lv_prop ChecksResiduals33 DiEiec33 stabnsLag3 if year < 2001, zeroinflat(ChecksResiduals33 DiEiec33 stabnsLag3) vce(cluster country)

// Zero-inflated Beta regression Using Laeven and Valencia 2012 for all crises
zoib lv_prop ChecksResiduals33 DiEiec33 stabnsLag3 if year, zeroinflat(ChecksResiduals33 DiEiec33 stabnsLag3) vce(cluster country)
