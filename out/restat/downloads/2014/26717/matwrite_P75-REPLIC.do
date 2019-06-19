* Graphs
* ======
clear
clear matrix
set more off
set mem 700m
set maxvar 32767

local MaxLEAD = 10
local MaxLEADplus1 = `MaxLEAD' + 1

do RMSPE_P75.do

forvalues t=1/`MaxLEAD' {

	preserve
	drop if  Placebo==0
	keep if  YearsFromLD==`t'
	save diffs_Placebos_Killed_P75_`t'.dta, replace
  matwrite using diffs_Placebos_P75_`t', replace
	restore
}


