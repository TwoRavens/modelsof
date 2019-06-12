*Everything the same except that in part II only report 1 coefficient in some 3 coefficient regressions.  Simply need to extract the 1 variable tests for those
*coefficients to make the "red" files.


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust quantile(string)]
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	if ("`quantile'" ~= "") local cmd = "`cmd'" + ","
	global k = wordcount("`testvars'")
	if ("`quantile'" == "") {
		`cmd' `anything' `if' `in', cluster(`cluster') `robust' 
		}
	else {
		`cmd' `anything' `if' `in', quantile(`quantile')
		}
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
	syntax anything [if] [in] [, cluster(string) robust quantile(string)]
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	if ("`quantile'" ~= "") local cmd = "`cmd'" + ","
	global k = wordcount("`testvars'")
	if ("`quantile'" == "") {
		capture `cmd' `anything' `if' `in', cluster(`cluster') `robust' 
		}
	else {
		capture `cmd' `anything' `if' `in', quantile(`quantile')
		}
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

global a = 24
global b = 54

use DatALO1, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global basic1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
global basic2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
global all1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9
global all2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9

global i = 1
global j = 1

*Table 3
foreach X in signup {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="F", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="F", robust
	}
foreach X in used_ssp used_adv used_fsg {
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $basic1 if noshow == 0, robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $all1 if noshow == 0, robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $basic2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $all2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $basic2 if noshow == 0 & sex=="F", robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $all2 if noshow == 0 & sex=="F", robust
	}
	
gen N = id
sort N
save aa, replace

egen NN = max(N)
keep NN
gen obs = _n
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

*Table 3
foreach X in signup {
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic1 if noshow == 0, robust
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="M", robust
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="M", robust
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="F", robust
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="F", robust
	}
foreach X in used_ssp used_adv used_fsg {
	mycmd1 (ssp sfsp) reg `X' ssp sfsp sfp $basic1 if noshow == 0, robust
	mycmd1 (ssp sfsp) reg `X' ssp sfsp sfp $all1 if noshow == 0, robust
	mycmd1 (ssp sfsp) reg `X' ssp sfsp sfp $basic2 if noshow == 0 & sex=="M", robust
	mycmd1 (ssp sfsp) reg `X' ssp sfsp sfp $all2 if noshow == 0 & sex=="M", robust
	mycmd1 (ssp sfsp) reg `X' ssp sfsp sfp $basic2 if noshow == 0 & sex=="F", robust
	mycmd1 (ssp sfsp) reg `X' ssp sfsp sfp $all2 if noshow == 0 & sex=="F", robust
	}
	
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
save ip\OBootstrapredALO1, replace

***************************************

*Everything the same except that in part II only report 1 coefficient in some 3 coefficient regressions.  Simply need to extract the 1 variable tests for those
*coefficients to make the "red" files, and then add in first part of part 1.

use $root\files\results\basecoef, clear
keep if paper == "ALO"
sort CoefNum
mata Select = st_data(.,"select")

use results\OBootstrapALO, clear
aorder
generate Select = .
mata ResB = st_data(.,"ResB*"); ResSE = st_data(.,"ResSE*"); ResB = select(ResB,Select'); ResSE = select(ResSE,Select'); st_store((1,255),"Select",Select)
mkmat B* if Select == 1, matrix(B)
generate Start = 1 if _n == 1
replace Start = Start[_n-1] + F4[_n-1] if F4 ~= . & _n > 1
generate Finish = Start + F4 - 1
forvalues i = 1/87 {
	local a1 = Start[`i']
	local a2 = Finish[`i']
	sum Select in `a1'/`a2'
	if (r(sum) ~= `a2'-`a1' + 1) {
		replace ResF`i' = Ftail(1,ResDF`i',(ResB`a2'/ResSE`a2')^2) if ResDF`i' ~= .
		replace ResF`i' = chi2tail(1,(ResB`a2'/ResSE`a2')^2) if ResDF`i' == .
		replace ResFF`i' = Ftail(1,ResDF`i',((ResB`a2'-B1[`a2'])/ResSE`a2')^2) if ResDF`i' ~= .
		replace ResFF`i' = chi2tail(1,((ResB`a2'-B1[`a2'])/ResSE`a2')^2) if ResDF`i' == .
		replace F4 = 1 if _n == `i'
		if (F3[`i'] == .) replace F1 = chi2tail(1,(B1[`a2']/B2[`a2'])^2) if _n == `i'
 		if (F3[`i'] ~= .) replace F1 = Ftail(1,F3[`i'],(B1[`a2']/B2[`a2'])^2) if _n == `i'
		}
		
	}
drop ResB* ResSE* B* Start Finish
svmat double B
mata list1 = ""; list2 = ""
forvalues i = 1/213 {
	quietly gen double ResB`i' = .
	quietly gen double ResSE`i' = .
	mata list1 = list1, "ResB`i'"; list2 = list2, "ResSE`i'" 
	}
aorder
mata list1 = list1[1,2..214]; list2 = list2[1,2..214]; st_store(.,list1,ResB); st_store(.,list2,ResSE)
drop ResF1-ResF24 ResFF1-ResFF24 ResDF1-ResDF24 ResD1-ResD24 ResB1-ResB54 ResSE1-ResSE54
merge 1:1 N using ip\OBootstrapredALO1, nogenerate
preserve
	use ip\OBootstrapredALO1, clear
	mkmat F* in 1/24, matrix(FF)
restore
mkmat F1-F4 in 25/87, matrix(F)
drop F1-F4
matrix F = FF \ F
svmat double F
aorder
drop Select
save results\OBootstrapRedALO, replace

capture erase aaa.dta
capture erase aa.dta
capture erase bb.dta
capture erase cc.dta


