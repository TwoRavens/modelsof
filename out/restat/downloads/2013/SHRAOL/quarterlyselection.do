/*Calculating the degree of selection quarterly and yearly*/
clear
capture log close
set matsize 1000
set memory 4g
set more off
log using quarterlyselection.log, replace

use edad year lhwage houseid FAC EST PER mujer binmigr using dataset, clear

svyset, clear
svyset houseid [pweight=FAC]

replace lhwage = . if edad < 16
replace lhwage = . if edad > 65

/*Quarterly wages*/
local quarters "200 300 400 101 201 301 401 102 202 302 402 103 203 303 403 104 204 304"
foreach quarter of local quarters {
	svy, subpop(if mujer == 0 & real(PER) == `quarter'): mean lhwage, over(binmigr)
	mat define B = e(b)
	mat define V = e(V)
	local meanlhwage`quarter'0 = B[1,1]
	local lblhwage`quarter'0 = `meanlhwage`quarter'0' - (1.96*sqrt(V[1,1]))
	local ublhwage`quarter'0 = `meanlhwage`quarter'0' + (1.96*sqrt(V[1,1]))
	local meanlhwage`quarter'1 = B[1,2]
	local lblhwage`quarter'1 = `meanlhwage`quarter'1' - (1.96*sqrt(V[2,2]))
	local ublhwage`quarter'1 = `meanlhwage`quarter'1' + (1.96*sqrt(V[2,2]))
	lincom [lhwage]1 - [lhwage]0
	local dslhwage`quarter' = r(estimate)
	local lblhwage`quarter' = r(estimate) - (1.96*r(se))
	local ublhwage`quarter' = r(estimate) + (1.96*r(se))
	matrix drop B V
}
foreach quarter of local quarters {
	mat resultslhwage`quarter' = (`meanlhwage`quarter'0', `lblhwage`quarter'0', `ublhwage`quarter'0', `meanlhwage`quarter'1', `lblhwage`quarter'1', `ublhwage`quarter'1', `dslhwage`quarter'', `lblhwage`quarter'', `ublhwage`quarter'')
}
mat resultslhwagequarters = resultslhwage200\resultslhwage300\resultslhwage400\resultslhwage101\resultslhwage201\resultslhwage301\resultslhwage401\resultslhwage102\resultslhwage202\resultslhwage302\resultslhwage402\resultslhwage103\resultslhwage203\resultslhwage303\resultslhwage403\resultslhwage104\resultslhwage204\resultslhwage304
mat list resultslhwagequarters
