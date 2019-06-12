
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		`anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
		}
	else {
		`anything' `if' `in', cluster(`cluster') `robust' 
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
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		capture `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
		}
	else {
		capture `anything' `if' `in', cluster(`cluster') `robust' 
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

global a = 22
global b = 31

use DatAKL1, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 3
foreach outcome in writezscore mathzscore {
	mycmd (abcpost) reg `outcome' abcpost abc post if (round==1|round==2|round==4), robust cluster(codev)
	mycmd (abcpost) reg `outcome' abcpost abc post cohort2009 female age dosso if (round==1|round==2|round==4), robust cluster(codev)
	mycmd (abcpost) areg `outcome' abcpost abc post cohort2009 female age if (round==1|round==2|round==4), absorb(avcode) robust cluster(codev)
	mycmd (abcpost) areg `outcome' abcpost post female age if (round==1|round==2|round==4), absorb(codev) robust cluster(codev)
	}
*Table 4 
foreach outcome in writezscore mathzscore {
	mycmd (abcpost abcregionpost) reg `outcome' abcpost abcregionpost abc regionabc region post regionpost cohort2009 female age if (round==1|round==2|round==4), robust cluster(codev)  
	mycmd (abcpost abcfemalepost) areg `outcome' abcpost abcfemalepost abc femaleabc female post femalepost cohort2009 age if (round==1|round==2|round==4), absorb(avcode) robust cluster(codev) 
	mycmd (abcpost abcyoungpost) areg `outcome' abcpost abcyoungpost abc youngabc young post youngpost cohort2009 female age if (round==1|round==2|round==4), absorb(avcode) robust cluster(codev)
	}
*Table 5
foreach outcome in writezsc mathzsc {
	mycmd (abcpost abcpost6m) areg `outcome' abcpost abcpost6m abc post post6m cohort2009 female age, absorb(avcode) robust cluster(codev)
	}
*Table 6
foreach outcome in teacherdaysy1 teacherdaysy1m34 percentattendy1 percentattendy1m34 percentattendy2 {
	mycmd (abc) areg `outcome' abc, absorb(avcode) robust cluster(codev)
	}
*Table 7
foreach outcome in percentattend34 {
	mycmd (abc highlevela) areg `outcome' abc highlevela highlevel cohort2009 female if time==2, absorb(avc) robust cluster(codev)
	}

sort avcode codevillage
merge avcode codevillage using Sample1
sort N
tab _m
drop _m
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
	drop codevillage
	rename obs codevillage

global i = 1
global j = 1
*Table 3
foreach outcome in writezscore mathzscore {
	mycmd1 (abcpost) reg `outcome' abcpost abc post if (round==1|round==2|round==4), robust cluster(codev)
	mycmd1 (abcpost) reg `outcome' abcpost abc post cohort2009 female age dosso if (round==1|round==2|round==4), robust cluster(codev)
	mycmd1 (abcpost) areg `outcome' abcpost abc post cohort2009 female age if (round==1|round==2|round==4), absorb(avcode) robust cluster(codev)
	mycmd1 (abcpost) areg `outcome' abcpost post female age if (round==1|round==2|round==4), absorb(codev) robust cluster(codev)
	}
*Table 4 
foreach outcome in writezscore mathzscore {
	mycmd1 (abcpost abcregionpost) reg `outcome' abcpost abcregionpost abc regionabc region post regionpost cohort2009 female age if (round==1|round==2|round==4), robust cluster(codev)  
	mycmd1 (abcpost abcfemalepost) areg `outcome' abcpost abcfemalepost abc femaleabc female post femalepost cohort2009 age if (round==1|round==2|round==4), absorb(avcode) robust cluster(codev) 
	mycmd1 (abcpost abcyoungpost) areg `outcome' abcpost abcyoungpost abc youngabc young post youngpost cohort2009 female age if (round==1|round==2|round==4), absorb(avcode) robust cluster(codev)
	}
*Table 5
foreach outcome in writezsc mathzsc {
	mycmd1 (abcpost abcpost6m) areg `outcome' abcpost abcpost6m abc post post6m cohort2009 female age, absorb(avcode) robust cluster(codev)
	}
*Table 6
foreach outcome in teacherdaysy1 teacherdaysy1m34 percentattendy1 percentattendy1m34 percentattendy2 {
	mycmd1 (abc) areg `outcome' abc, absorb(avcode) robust cluster(codev)
	}
*Table 7
foreach outcome in percentattend34 {
	mycmd1 (abc highlevela) areg `outcome' abc highlevela highlevel cohort2009 female if time==2, absorb(avc) robust cluster(codev)
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
save ip\OBootstrapAKL1, replace

*****************************
*****************************

global a = 3
global b = 3

use DatAKL2, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 8 
mycmd (abc) areg hotline abc cohort2009, absorb(avcode) robust
mycmd (abc) areg hotline abc cohort2009 if highlevel==1, absorb(avcode) robust
mycmd (abc) areg hotline abc cohort2009 if lowlevel==1, absorb(avcode) robust

sort avcode codevillage
merge avcode codevillage using Sample1
sort N
tab _m
drop _m
save bb, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb

global i = 1
global j = 1
*Table 8 
mycmd1 (abc) areg hotline abc cohort2009, absorb(avcode) robust
mycmd1 (abc) areg hotline abc cohort2009 if highlevel==1, absorb(avcode) robust
mycmd1 (abc) areg hotline abc cohort2009 if lowlevel==1, absorb(avcode) robust

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
save ip\OBootstrapAKL2, replace

*****************************
*****************************

global a = 15
global b = 15

use DatAKL3, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 9
foreach outcome in cellphoneowner usecellphone makecall receivecall writesms receivesms anybip madetransferSMS receivedtransferSMS communicate_migrant celltalkrelativeniger celltalktradeniger whycell_ceremony whycell_help whycell_priceinfo {
	mycmd (abc) areg `outcome' abc, absorb(avcode) robust cluster(codev)
	}

sort avcode codevillage
merge avcode codevillage using Sample1
sort N
tab _m
drop _m
save cc, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using cc
	drop codevillage
	rename obs codevillage


global i = 1
global j = 1
*Table 9
foreach outcome in cellphoneowner usecellphone makecall receivecall writesms receivesms anybip madetransferSMS receivedtransferSMS communicate_migrant celltalkrelativeniger celltalktradeniger whycell_ceremony whycell_help whycell_priceinfo {
	mycmd1 (abc) areg `outcome' abc, absorb(avcode) robust cluster(codev)
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
save ip\OBootstrapAKL3, replace

*****************************
*****************************


matrix count = (22,3,15) \ (31,3,15) 

global f = count[1,1]
global b = count[2,1]

use ip\OBootstrapAKL1, clear
mkmat F1-F4 in 1/$f, matrix(F)
mkmat B1-B2 in 1/$b, matrix(B)
drop F1-F4 B1-B2
sort N
save a1, replace

local t = 1
foreach c in 2 3 {
	local t = `c'
	global f1 = count[1,`t']
	global b1 = count[2,`t']

	use ip\OBootstrapAKL`c', clear
	mkmat F1-F4 in 1/$f1, matrix(FF)
	mkmat B1-B2 in 1/$b1, matrix(BB)
	drop F1-F4 B1-B2 
	matrix F = F \ FF
	matrix B = B \ BB
	forvalues i = $f1(-1)1 {
		local j = `i' + $f
		rename ResFF`i' ResFF`j'
		rename ResF`i' ResF`j'
		rename ResDF`i' ResDF`j'
		rename ResD`i' ResD`j'
		}
	forvalues i = $b1(-1)1 {
		local j = `i' + $b
		rename ResB`i' ResB`j'
		rename ResSE`i' ResSE`j'
		}
	global f = $f + $f1
	global b = $b + $b1
	sort N
	save a`c', replace
	}

use a1, clear
foreach c in 2 3 {
	sort N
	merge N using a`c'
	tab _m
	drop _m
	}
aorder
sort N
foreach j in F B {
	svmat double `j'
	}
save results\OBootstrapAKL, replace

foreach file in aaa aa bb cc a1 a2 a3 {
	capture erase `file'.dta
	}






