/*Summary statistics for the paper*/
clear
capture log close
set matsize 1000
set memory 2g
set more off
log using summarystatistics.log, replace

use laborforce agriculture manufacture wageearner paro rhwage ametdum rural schoolyears binmigr year mujer houseid FAC edad using dataset, clear
compress

gen include = 1 if edad > 15 & edad < 66

/*Survey commands*/
svyset, clear
svyset houseid [pweight=FAC]

forvalues y = 2000/2004 {
	matrix define resultsmen = J(29,2,0)
	svy, subpop(if year == `y' & include == 1): mean mujer, over(binmigr)
	matrix B = e(b)
	matrix resultsmen[1,1] = 1 - B[1,1]
	matrix resultsmen[1,2] = 1 - B[1,2]
	matrix V = e(V)
	matrix resultsmen[2,1] = sqrt(V[1,1])
	matrix resultsmen[2,2] = sqrt(V[2,2])
	matrix N = e(_N)
	matrix resultsmen[29,1] = N[1,1]
	matrix resultsmen[29,2] = N[1,2]
	svy, subpop(if year == `y' & include == 1 & mujer == 0): mean edad, over(binmigr)
	matrix B = e(b)
	matrix resultsmen[4,1] = B[1,1]
	matrix resultsmen[4,2] = B[1,2]
	matrix V = e(V)
	matrix resultsmen[5,1] = sqrt(V[1,1])
	matrix resultsmen[5,2] = sqrt(V[2,2])
	_pctile edad [pw=FAC] if mujer == 0 & year == `y' & binmigr == 0 & include == 1 
	matrix resultsmen[6,1] = r(r1)
	_pctile edad [pw=FAC] if mujer == 0 & year == `y' & binmigr == 1 & include == 1 
	matrix resultsmen[6,2] = r(r1)
	svy, subpop(if year == `y' & include == 1 & mujer == 0): mean schoolyears, over(binmigr)
	matrix B = e(b)
	matrix resultsmen[8,1] = B[1,1]
	matrix resultsmen[8,2] = B[1,2]
	matrix V = e(V)
	matrix resultsmen[9,1] = sqrt(V[1,1])
	matrix resultsmen[9,2] = sqrt(V[2,2])
	_pctile schoolyears [pw=FAC] if mujer == 0 & year == `y' & binmigr == 0 & include == 1 
	matrix resultsmen[10,1] = r(r1)
	_pctile schoolyears [pw=FAC] if mujer == 0 & year == `y' & binmigr == 1 & include == 1 
	matrix resultsmen[10,2] = r(r1)
	svy, subpop(if year == `y' & include == 1 & mujer == 0): mean laborforce, over(binmigr)
	matrix B = e(b)
	matrix resultsmen[11,1] = B[1,1]
	matrix resultsmen[11,2] = B[1,2]
	matrix V = e(V)
	matrix resultsmen[12,1] = sqrt(V[1,1])
	matrix resultsmen[12,2] = sqrt(V[2,2])
	svy, subpop(if year == `y' & include == 1 & mujer == 0): mean agriculture, over(binmigr)
	matrix B = e(b)
	matrix resultsmen[13,1] = B[1,1]
	matrix resultsmen[13,2] = B[1,2]
	matrix V = e(V)
	matrix resultsmen[14,1] = sqrt(V[1,1])
	matrix resultsmen[14,2] = sqrt(V[2,2])
	svy, subpop(if year == `y' & include == 1 & mujer == 0): mean manufacture, over(binmigr)
	matrix B = e(b)
	matrix resultsmen[15,1] = B[1,1]
	matrix resultsmen[15,2] = B[1,2]
	matrix V = e(V)
	matrix resultsmen[16,1] = sqrt(V[1,1])
	matrix resultsmen[16,2] = sqrt(V[2,2])
	svy, subpop(if year == `y' & include == 1 & mujer == 0): mean wageearner, over(binmigr)
	matrix B = e(b)
	matrix resultsmen[17,1] = B[1,1]
	matrix resultsmen[17,2] = B[1,2]
	matrix V = e(V)
	matrix resultsmen[18,1] = sqrt(V[1,1])
	matrix resultsmen[18,2] = sqrt(V[2,2])
	svy, subpop(if year == `y' & include == 1 & mujer == 0): mean paro, over(binmigr)
	matrix B = e(b)
	matrix resultsmen[19,1] = B[1,1]
	matrix resultsmen[19,2] = B[1,2]
	matrix V = e(V)
	matrix resultsmen[20,1] = sqrt(V[1,1])
	matrix resultsmen[20,2] = sqrt(V[2,2])
	svy, subpop(if year == `y' & include == 1 & mujer == 0): mean rhwage, over(binmigr)
	matrix B = e(b)
	matrix resultsmen[22,1] = B[1,1]
	matrix resultsmen[22,2] = B[1,2]
	matrix V = e(V)
	matrix resultsmen[23,1] = sqrt(V[1,1])
	matrix resultsmen[23,2] = sqrt(V[2,2])
	_pctile rhwage [pw=FAC] if mujer == 0 & year == `y' & binmigr == 0 & include == 1 
	matrix resultsmen[24,1] = r(r1)
	_pctile rhwage [pw=FAC] if mujer == 0 & year == `y' & binmigr == 1 & include == 1 
	matrix resultsmen[24,2] = r(r1)
	svy, subpop(if year == `y' & include == 1 & mujer == 0): mean ametdum, over(binmigr)
	matrix B = e(b)
	matrix resultsmen[25,1] = B[1,1]
	matrix resultsmen[25,2] = B[1,2]
	matrix V = e(V)
	matrix resultsmen[26,1] = sqrt(V[1,1])
	matrix resultsmen[26,2] = sqrt(V[2,2])
	svy, subpop(if year == `y' & include == 1 & mujer == 0): mean rural, over(binmigr)
	matrix B = e(b)
	matrix resultsmen[27,1] = B[1,1]
	matrix resultsmen[27,2] = B[1,2]
	matrix V = e(V)
	matrix resultsmen[28,1] = sqrt(V[1,1])
	matrix resultsmen[28,2] = sqrt(V[2,2])
	display "Year `y'"
	matrix list resultsmen
	matrix drop resultsmen
}
/*Women*/
forvalues y = 2000/2004 {
	matrix define resultswomen = J(25,2,0)
	svy, subpop(if year == `y' & include == 1 & mujer == 1): mean edad, over(binmigr)
	matrix B = e(b)
	matrix resultswomen[1,1] = B[1,1]
	matrix resultswomen[1,2] = B[1,2]
	matrix V = e(V)
	matrix resultswomen[2,1] = sqrt(V[1,1])
	matrix resultswomen[2,2] = sqrt(V[2,2])
	_pctile edad [pw=FAC] if mujer == 1 & year == `y' & binmigr == 0 & include == 1 
	matrix resultswomen[3,1] = r(r1)
	_pctile edad [pw=FAC] if mujer == 1 & year == `y' & binmigr == 1 & include == 1 
	matrix resultswomen[3,2] = r(r1)
	svy, subpop(if year == `y' & include == 1 & mujer == 1): mean schoolyears, over(binmigr)
	matrix B = e(b)
	matrix resultswomen[5,1] = B[1,1]
	matrix resultswomen[5,2] = B[1,2]
	matrix V = e(V)
	matrix resultswomen[6,1] = sqrt(V[1,1])
	matrix resultswomen[6,2] = sqrt(V[2,2])
	_pctile schoolyears [pw=FAC] if mujer == 1 & year == `y' & binmigr == 0 & include == 1 
	matrix resultswomen[7,1] = r(r1)
	_pctile schoolyears [pw=FAC] if mujer == 1 & year == `y' & binmigr == 1 & include == 1 
	matrix resultswomen[7,2] = r(r1)
	svy, subpop(if year == `y' & include == 1 & mujer == 1): mean laborforce, over(binmigr)
	matrix B = e(b)
	matrix resultswomen[8,1] = B[1,1]
	matrix resultswomen[8,2] = B[1,2]
	matrix V = e(V)
	matrix resultswomen[9,1] = sqrt(V[1,1])
	matrix resultswomen[9,2] = sqrt(V[2,2])
	svy, subpop(if year == `y' & include == 1 & mujer == 1): mean agriculture, over(binmigr)
	matrix B = e(b)
	matrix resultswomen[10,1] = B[1,1]
	matrix resultswomen[10,2] = B[1,2]
	matrix V = e(V)
	matrix resultswomen[11,1] = sqrt(V[1,1])
	matrix resultswomen[11,2] = sqrt(V[2,2])
	svy, subpop(if year == `y' & include == 1 & mujer == 1): mean manufacture, over(binmigr)
	matrix B = e(b)
	matrix resultswomen[12,1] = B[1,1]
	matrix resultswomen[12,2] = B[1,2]
	matrix V = e(V)
	matrix resultswomen[13,1] = sqrt(V[1,1])
	matrix resultswomen[13,2] = sqrt(V[2,2])
	svy, subpop(if year == `y' & include == 1 & mujer == 1): mean wageearner, over(binmigr)
	matrix B = e(b)
	matrix resultswomen[14,1] = B[1,1]
	matrix resultswomen[14,2] = B[1,2]
	matrix V = e(V)
	matrix resultswomen[15,1] = sqrt(V[1,1])
	matrix resultswomen[15,2] = sqrt(V[2,2])
	svy, subpop(if year == `y' & include == 1 & mujer == 1): mean paro, over(binmigr)
	matrix B = e(b)
	matrix resultswomen[16,1] = B[1,1]
	matrix resultswomen[16,2] = B[1,2]
	matrix V = e(V)
	matrix resultswomen[17,1] = sqrt(V[1,1])
	matrix resultswomen[17,2] = sqrt(V[2,2])
	svy, subpop(if year == `y' & include == 1 & mujer == 1): mean rhwage, over(binmigr)
	matrix B = e(b)
	matrix resultswomen[19,1] = B[1,1]
	matrix resultswomen[19,2] = B[1,2]
	matrix V = e(V)
	matrix resultswomen[20,1] = sqrt(V[1,1])
	matrix resultswomen[20,2] = sqrt(V[2,2])
	_pctile rhwage [pw=FAC] if mujer == 1 & year == `y' & binmigr == 0 & include == 1 
	matrix resultswomen[21,1] = r(r1)
	_pctile rhwage [pw=FAC] if mujer == 1 & year == `y' & binmigr == 1 & include == 1 
	matrix resultswomen[21,2] = r(r1)
	svy, subpop(if year == `y' & include == 1 & mujer == 1): mean ametdum, over(binmigr)
	matrix B = e(b)
	matrix resultswomen[22,1] = B[1,1]
	matrix resultswomen[22,2] = B[1,2]
	matrix V = e(V)
	matrix resultswomen[23,1] = sqrt(V[1,1])
	matrix resultswomen[23,2] = sqrt(V[2,2])
	svy, subpop(if year == `y' & include == 1 & mujer == 1): mean rural, over(binmigr)
	matrix B = e(b)
	matrix resultswomen[24,1] = B[1,1]
	matrix resultswomen[24,2] = B[1,2]
	matrix V = e(V)
	matrix resultswomen[25,1] = sqrt(V[1,1])
	matrix resultswomen[25,2] = sqrt(V[2,2])
	display "Year `y'"
	matrix list resultswomen
	matrix drop resultswomen
}
