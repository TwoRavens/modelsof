/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Create affiliation datasets

INPUTS:
- See .ado files for inputs indirectly used

OUTPUTS:
- aff_ds_1.dta
- aff_ds_2.dta
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado

*** Create data **************************************************************************
local affsources_1 1/5
local affsources_2 6/11
local affvars_1 1/5
local affvars_2 6(0.1)7
local moments_1 mean 33
local moments_2 mean

foreach ver of numlist 1/2 {
	local affsources `affsources_`ver''
	local affvars `affvars_`ver''
	local moments `moments_`ver''
	gen_working_data
	tempfile affs
	preserve
	local start=1
	foreach affsource of numlist `affsources' {
		foreach affvar of numlist `affvars' {
			local str_affsource `=subinstr("`affsource'",".","_",.)'
			local str_affvar `=subinstr("`affvar'",".","_",.)'
			restore
			preserve
			gen_aff, affsource(`affsource') affvar(`affvar') moments(`moments')
			qui { 
				if `ver'==1 keep obs_id aff aff_33
				else keep obs_id aff
				rename aff aff_`str_affsource'_`str_affvar'_mn
				capture rename aff_33 aff_`str_affsource'_`str_affvar'_33
				if !`start' merge 1:1 obs_id using `affs', assert(match) nogen
				save `affs', replace
				local start=0
			}
		}
	}
	restore,not
	qui foreach var of varlist aff_* {
		sum `var'
		scalar mean_`var'=r(mean)
		scalar sd_`var'=r(sd)
		gen n`var'=(`var'-scalar(mean_`var'))/scalar(sd_`var')
	}
	save data/intermediate/aff_ds_`ver', replace
}
