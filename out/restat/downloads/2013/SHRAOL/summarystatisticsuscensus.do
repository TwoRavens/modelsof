/*Summary statistics for the paper*/
clear
capture log close
set matsize 800
set memory 900m
set more off
log using summarystatisticsuscensus.log, replace

use labforce rhwage schoolyears yrimmig mujer perwt edad using uscensusdataset, clear
compress

gen include = 1 if edad > 15 & edad < 66 & yrimmig==999

/*Survey commands*/
svyset, clear
svyset [pweight=perwt]

matrix define resultsmen = J(28,1,0)
svymean mujer, subpop(if include == 1)
matrix B = e(b)
matrix resultsmen[1,1] = 1 - B[1,1]
matrix V = e(V)
matrix resultsmen[2,1] = sqrt(V[1,1])
matrix N = e(_N)
matrix resultsmen[28,1] = N[1,1]
svymean edad, subpop(if include == 1 & mujer == 0)
matrix B = e(b)
matrix resultsmen[4,1] = B[1,1]
matrix V = e(V)
matrix resultsmen[5,1] = sqrt(V[1,1])
_pctile edad [pw=perwt] if mujer == 0 & include == 1 
matrix resultsmen[6,1] = r(r1)
svymean schoolyears, subpop(if include == 1 & mujer == 0)
matrix B = e(b)
matrix resultsmen[8,1] = B[1,1]
matrix V = e(V)
matrix resultsmen[9,1] = sqrt(V[1,1])
_pctile schoolyears [pw=perwt] if mujer == 0 & include == 1 
matrix resultsmen[10,1] = r(r1)
svymean rhwage, subpop(if include == 1 & mujer == 0)
matrix B = e(b)
matrix resultsmen[22,1] = B[1,1]
matrix V = e(V)
matrix resultsmen[23,1] = sqrt(V[1,1])
_pctile rhwage [pw=perwt] if mujer == 0 & include == 1 
matrix resultsmen[24,1] = r(r1)
matrix list resultsmen

/*Women*/
matrix define resultswomen = J(25,1,0)
svymean edad, subpop(if include == 1 & mujer == 1)
matrix B = e(b)
matrix resultswomen[1,1] = B[1,1]
matrix V = e(V)
matrix resultswomen[2,1] = sqrt(V[1,1])
_pctile edad [pw=perwt] if mujer == 1 & include == 1 
matrix resultswomen[3,1] = r(r1)
svymean schoolyears, subpop(if include == 1 & mujer == 1)
matrix B = e(b)
matrix resultswomen[5,1] = B[1,1]
matrix V = e(V)
matrix resultswomen[6,1] = sqrt(V[1,1])
_pctile schoolyears [pw=perwt] if mujer == 1 & include == 1 
matrix resultswomen[7,1] = r(r1)
svymean rhwage, subpop(if include == 1 & mujer == 1)
matrix B = e(b)
matrix resultswomen[19,1] = B[1,1]
matrix V = e(V)
matrix resultswomen[20,1] = sqrt(V[1,1])
_pctile rhwage [pw=perwt] if mujer == 1 & include == 1 
matrix resultswomen[21,1] = r(r1)
matrix list resultswomen
