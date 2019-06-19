/*Summary statistics of the MMP Orrenius and Zavodny sample in MMP107*/
clear
capture log close
set matsize 800
set memory 900m
set more off
log using summarystatisticsozsample107.log, replace

use mmpozsample, clear

gen include = 1 if edad > 14 & edad < 65 & surveyyr>1993

/*Survey commands*/
svyset, clear
svyset [pweight=weight]

matrix define resultsmen = J(31,2,.)
matrix define resultswomen = J(31,2,.)
svy, subpop(if include == 1): mean mujer, over(mig)
matrix B = e(b)
matrix resultsmen[3,1] = 1 - B[1,1]
matrix resultsmen[3,2] = 1 - B[1,2]
matrix V = e(V)
matrix resultsmen[4,1] = sqrt(V[1,1])
matrix resultsmen[4,2] = sqrt(V[2,2])
matrix N = e(_N)
matrix resultsmen[1,1] = N[1,1]
matrix resultsmen[1,2] = N[1,2]
svy, subpop(if include == 1 & mujer == 0): mean edad, over(mig) 
matrix B = e(b)
matrix resultsmen[7,1] = B[1,1]
matrix resultsmen[7,2] = B[1,2]
matrix V = e(V)
matrix resultsmen[8,1] = sqrt(V[1,1])
matrix resultsmen[8,2] = sqrt(V[2,2])
_pctile edad [pw=weight] if mujer == 0 & mig == 0 & include == 1 
matrix resultsmen[9,1] = r(r1)
_pctile edad [pw=weight] if mujer == 0 & mig == 1 & include == 1 
matrix resultsmen[9,2] = r(r1)
svy, subpop(if include == 1 & mujer == 0): mean schoolyears, over(mig) 
matrix B = e(b)
matrix resultsmen[11,1] = B[1,1]
matrix resultsmen[11,2] = B[1,2]
matrix V = e(V)
matrix resultsmen[12,1] = sqrt(V[1,1])
matrix resultsmen[12,2] = sqrt(V[2,2])
_pctile schoolyears [pw=weight] if mujer == 0 & mig == 0 & include == 1 
matrix resultsmen[13,1] = r(r1)
_pctile schoolyears [pw=weight] if mujer == 0 & mig == 1 & include == 1 
matrix resultsmen[13,2] = r(r1)
svy, subpop(if include == 1 & mujer == 0): mean laborforce, over(mig) 
matrix B = e(b)
matrix resultsmen[18,1] = B[1,1]
matrix resultsmen[18,2] = B[1,2]
matrix V = e(V)
matrix resultsmen[19,1] = sqrt(V[1,1])
matrix resultsmen[19,2] = sqrt(V[2,2])
svy, subpop(if include == 1 & mujer == 0): mean agriculture, over(mig) 
matrix B = e(b)
matrix resultsmen[16,1] = B[1,1]
matrix resultsmen[16,2] = B[1,2]
matrix V = e(V)
matrix resultsmen[17,1] = sqrt(V[1,1])
matrix resultsmen[17,2] = sqrt(V[2,2])
svy, subpop(if include == 1 & mujer == 0): mean paro, over(mig) 
matrix B = e(b)
matrix resultsmen[22,1] = B[1,1]
matrix resultsmen[22,2] = B[1,2]
matrix V = e(V)
matrix resultsmen[23,1] = sqrt(V[1,1])
matrix resultsmen[23,2] = sqrt(V[2,2])
svy, subpop(if include == 1 & mujer == 0): mean rural, over(mig) 
matrix B = e(b)
matrix resultsmen[14,1] = B[1,1]
matrix resultsmen[14,2] = B[1,2]
matrix V = e(V)
matrix resultsmen[15,1] = sqrt(V[1,1])
matrix resultsmen[15,2] = sqrt(V[2,2])

/*Women*/
svy, subpop(if include == 1 & mujer == 1): mean edad, over(mig) 
matrix B = e(b)
matrix resultswomen[7,1] = B[1,1]
matrix resultswomen[7,2] = B[1,2]
matrix V = e(V)
matrix resultswomen[8,1] = sqrt(V[1,1])
matrix resultswomen[8,2] = sqrt(V[2,2])
_pctile edad [pw=weight] if mujer == 1 & mig == 0 & include == 1 
matrix resultswomen[9,1] = r(r1)
_pctile edad [pw=weight] if mujer == 1 & mig == 1 & include == 1 
matrix resultswomen[9,2] = r(r1)
svy, subpop(if include == 1 & mujer == 1): mean schoolyears, over(mig) 
matrix B = e(b)
matrix resultswomen[11,1] = B[1,1]
matrix resultswomen[11,2] = B[1,2]
matrix V = e(V)
matrix resultswomen[12,1] = sqrt(V[1,1])
matrix resultswomen[12,2] = sqrt(V[2,2])
_pctile schoolyears [pw=weight] if mujer == 1 & mig == 0 & include == 1 
matrix resultswomen[13,1] = r(r1)
_pctile schoolyears [pw=weight] if mujer == 1 & mig == 1 & include == 1 
matrix resultswomen[13,2] = r(r1)
svy, subpop(if include == 1 & mujer == 1): mean laborforce, over(mig) 
matrix B = e(b)
matrix resultswomen[18,1] = B[1,1]
matrix resultswomen[18,2] = B[1,2]
matrix V = e(V)
matrix resultswomen[19,1] = sqrt(V[1,1])
matrix resultswomen[19,2] = sqrt(V[2,2])
svy, subpop(if include == 1 & mujer == 1): mean agriculture, over(mig) 
matrix B = e(b)
matrix resultswomen[16,1] = B[1,1]
matrix resultswomen[16,2] = B[1,2]
matrix V = e(V)
matrix resultswomen[17,1] = sqrt(V[1,1])
matrix resultswomen[17,2] = sqrt(V[2,2])
svy, subpop(if include == 1 & mujer == 1): mean paro, over(mig) 
matrix B = e(b)
matrix resultswomen[22,1] = B[1,1]
matrix resultswomen[22,2] = B[1,2]
matrix V = e(V)
matrix resultswomen[23,1] = sqrt(V[1,1])
matrix resultswomen[23,2] = sqrt(V[2,2])
svy, subpop(if include == 1 & mujer == 1): mean rural, over(mig) 
matrix B = e(b)
matrix resultswomen[14,1] = B[1,1]
matrix resultswomen[14,2] = B[1,2]
matrix V = e(V)
matrix resultswomen[15,1] = sqrt(V[1,1])
matrix resultswomen[15,2] = sqrt(V[2,2])

matrix list resultsmen
matrix list resultswomen

svy, subpop(if include==1 & mujer==0): prop metrocat
svy, subpop(if include == 1 & mujer == 0): prop metrocat, over(mig)
svy, subpop(if include==1 & mujer==0): mean schoolyears, over(metrocat mig)

lincom [schoolyears]_subpop_2 - [schoolyears]_subpop_1
lincom [schoolyears]_subpop_4 - [schoolyears]_subpop_3
lincom [schoolyears]_subpop_6 - [schoolyears]_subpop_5
lincom [schoolyears]_subpop_8 - [schoolyears]_subpop_7
