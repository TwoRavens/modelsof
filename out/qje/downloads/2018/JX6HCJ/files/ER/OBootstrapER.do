
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `robust'
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', cluster(`cluster') `robust'
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			matrix V = V[1..$k,1..$k]
			matrix b = b[1,1..$k]
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) capture matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) capture matrix FF[$i,4] = chi2tail($k,f[1,1])
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************

global a = 22
global b = 405

use DatER, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*TABLE 6
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dmaskin dfordon if dhighskill == 0, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dgym dred dsjuk if dhighskill == 1, cluster (id)

*TABLE 7 
mycmd (arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd (arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd (arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
mycmd (arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd (arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd (arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
mycmd (arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd (arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd (arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
mycmd (duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd (duration2 erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd (duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)

*TABLE 8
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==0, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==1, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==0, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==1, cluster (id)

*TABLE 9 
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)

gen Order = _n
sort id Order
gen N = 1
gen Dif = (id ~= id[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop id
	rename obs id

global i = 1
global j = 1

*TABLE 6
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dmaskin dfordon if dhighskill == 0, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dmano dgym dred dsjuk if dhighskill == 1, cluster (id)

*TABLE 7 
mycmd1 (arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd1 (arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd1 (arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshet erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
mycmd1 (arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd1 (arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd1 (arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetnu erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
mycmd1 (arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd1 (arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd1 (arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arbetsloshetforr erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)
mycmd1 (duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd1 (duration2 erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd1 (duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback duration2 erfar antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)

*TABLE 8
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg min doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==0, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if kvinna==1, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==0, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar antlarbetsg doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon if min==1, cluster (id)

*TABLE 9 
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk dbutik dftg drest dlokal dmaskin dbygg dfordon, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet dbutik dftg drest dlokal dbygg dfordon if dhighskill == 0, cluster (id)
mycmd1 (arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis) probit callback arblosnu_3 arblosnu_6 arblosnu_9 scarce parbetslos erfar2 erfar3_5 antlarbetsg min kvinna doverutb sommarjobb utlgymn komp varme cult fotboll basket lopning simning golf tennis dgbg dlandet ddata dsvso dgym dred dsjuk if dhighskill == 1, cluster (id)

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\OBootstrapER, replace

erase aa.dta
erase aaa.dta

*repeat regressions

use results\OBootstrapER, clear
foreach var in ResF ResDF ResD ResFF {
	forvalues i = 1/3 {
		local j = `i' + 22
		generate double `var'`j' = `var'`i'
		}
	}
foreach var in ResB ResSE {
	forvalues i = 1/62 {
		local j = `i' + 405
		generate double `var'`j' = `var'`i'
		}
	}
foreach var in F1 F2 F3 F4 {
	forvalues i = 1/3 {
		local j = `i' + 22
		quietly replace `var' = `var'[`i'] if _n == `j'
		}
	}
foreach var in B1 B2 {
	forvalues i = 1/62 {
		local j = `i' + 405
		quietly replace `var' = `var'[`i'] if _n == `j'
		}
	}
aorder
save results\OBootstrapER, replace

