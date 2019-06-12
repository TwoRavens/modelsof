
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust quantile(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`quantile'" == "") {
		`anything' `if' `in', cluster(`cluster') `robust'
		}
	else {
		bootstrap, reps(500) cluster(id) seed(1): `anything' `if' `in', quantile(`quantile')
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
	global k = wordcount("`testvars'")
	if ("`quantile'" == "") {
		capture `anything' `if' `in', cluster(`cluster') `robust'
		}
	else {
		capture bootstrap, reps(500) cluster(id) seed(1): `anything' `if' `in', quantile(`quantile')
		}
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
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

*1st calculate changed parts in this file

use DatALO1, clear

global basic1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
global basic2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
global all1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9
global all2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9

matrix F = J(24,4,.)
matrix B = J(54,2,.)

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

	
generate Order = _n
generate double U = .
mata Y = st_data(.,("ssp","sfp","sfsp","sfpany"))

mata ResF = J($reps,24,.); ResD = J($reps,24,.); ResDF = J($reps,24,.); ResB = J($reps,54,.); ResSE = J($reps,54,.)
forvalues c = 1/$reps {
	matrix FF = J(24,3,.)
	matrix BB = J(54,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort U
	mata st_store(.,("ssp","sfp","sfsp","sfpany"),Y)

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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..24] = FF[.,1]'; ResD[`c',1..24] = FF[.,2]'; ResDF[`c',1..24] = FF[.,3]'
mata ResB[`c',1..54] = BB[.,1]'; ResSE[`c',1..54] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/24 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/54 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherredALO1, replace

**************************************
*Everything the same except that in part II only report 1 coefficient in some 3 coefficient regressions.  Simply need to extract the 1 variable tests for those
*coefficients to make the "red" files, and then add in first part of part 1.

use $root\files\results\basecoef, clear
keep if paper == "ALO"
sort CoefNum
mata Select = st_data(.,"select")

use results\FisherALO, clear
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
		replace F4 = 1 if _n == `i'
		if (F3[`i'] == .) replace F1 = chi2tail(1,(B1[`a2']/B2[`a2'])^2) if _n == `i'
 		if (F3[`i'] ~= .) replace F1 = Ftail(1,F3[`i'],(B1[`a2']/B2[`a2'])^2) if _n == `i'
		}
		
	}
drop ResB* ResSE* B* Start Finish
svmat double B
rename B3 BIV1
rename B4 BIV2
mata list1 = ""; list2 = ""
forvalues i = 1/213 {
	quietly gen double ResB`i' = .
	quietly gen double ResSE`i' = .
	mata list1 = list1, "ResB`i'"; list2 = list2, "ResSE`i'" 
	}
aorder
mata list1 = list1[1,2..214]; list2 = list2[1,2..214]; st_store(.,list1,ResB); st_store(.,list2,ResSE)
drop ResF1-ResF24 ResDF1-ResDF24 ResD1-ResD24 ResB1-ResB54 ResSE1-ResSE54
merge 1:1 N using ip\FisherredALO1, nogenerate
preserve
	use ip\FisherredALO1, clear
	mkmat F* in 1/24, matrix(FF)
restore
mkmat F1-F4 in 25/87, matrix(F)
drop F1-F4
matrix F = FF \ F
svmat double F
aorder
drop Select
save results\FisherRedALO, replace







