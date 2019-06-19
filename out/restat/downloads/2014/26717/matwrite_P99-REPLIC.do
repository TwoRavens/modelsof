* Graphs
* ======
clear
clear matrix
set more off
set mem 700m

local MaxLEAD = 10
local MaxLEADplus1 = `MaxLEAD' + 1

do RMSPE_P99.do

forvalues t=1/`MaxLEAD' {

	preserve
	drop if  Placebo==0
	keep if  YearsFromLD==`t'
	save diffs_Placebos_Killed_P99_`t'.dta, replace
  matwrite using diffs_Placebos_P99_`t', replace
	restore
}





