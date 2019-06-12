
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) absorb(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "" & "`cluster'" ~= "") {
		`anything' `if' `in', cluster(`cluster') absorb(`absorb')
		}
	else if ("`absorb'" ~= "" & "`cluster'" == "") {
		`anything' `if' `in', `robust' absorb(`absorb')
		}
	else {
		`anything' `if' `in', cluster(`cluster')
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
	syntax anything [if] [in] [, cluster(string) absorb(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "" & "`cluster'" ~= "") {
		quietly `anything' `if' `in', cluster(`cluster') absorb(`absorb')
		}
	else if ("`absorb'" ~= "" & "`cluster'" == "") {
		quietly `anything' `if' `in', `robust' absorb(`absorb')
		}
	else {
		quietly `anything' `if' `in', cluster(`cluster')
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatAKL1, clear

matrix F = J(22,4,.)
matrix B = J(31,2,.)

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

global N = 114
generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y2")

mata ResF = J($reps,22,.); ResD = J($reps,22,.); ResDF = J($reps,22,.); ResB = J($reps,31,.); ResSE = J($reps,31,.)
forvalues c = 1/$reps {
	matrix FF = J(22,3,.)
	matrix BB = J(31,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace abc = Y2[`i'] if codevillage == Y3[`i']
		}
	quietly replace abcpost = abc*post
	quietly replace regionabc = region*abc
	quietly replace abcregionpost = regionabc*post
	quietly replace abcfemalepost = femalepost*abc
	quietly replace femaleabc = female*abc
	quietly replace abcyoungpost = youngpost*abc
	quietly replace youngabc = young*abc
	quietly replace abcpost6m = post6m*abc
	quietly replace highlevelabc = abc*highlevel 

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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..22] = FF[.,1]'; ResD[`c',1..22] = FF[.,2]'; ResDF[`c',1..22] = FF[.,3]'
mata ResB[`c',1..31] = BB[.,1]'; ResSE[`c',1..31] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/22 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/31 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherAKL1, replace


******************************************

use DatAKL2, clear

matrix F = J(3,4,.)
matrix B = J(3,2,.)

global i = 1
global j = 1

*Table 8 
mycmd (abc) areg hotline abc cohort2009, absorb(avcode) robust
mycmd (abc) areg hotline abc cohort2009 if highlevel==1, absorb(avcode) robust
mycmd (abc) areg hotline abc cohort2009 if lowlevel==1, absorb(avcode) robust

global N = 114
mata Y = st_data((1,$N),"Y2")
generate Order = _n
generate double U = .

mata ResF = J($reps,3,.); ResD = J($reps,3,.); ResDF = J($reps,3,.); ResB = J($reps,3,.); ResSE = J($reps,3,.)
forvalues c = 1/$reps {
	matrix FF = J(3,3,.)
	matrix BB = J(3,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace abc = Y2[`i'] if codevillage == Y3[`i']
		}
	*Reproducing systematic codeing error in this data file
	quietly replace abc = 0 if codevillage == 7120

global i = 1
global j = 1

*Table 8 
mycmd1 (abc) areg hotline abc cohort2009, absorb(avcode) robust
mycmd1 (abc) areg hotline abc cohort2009 if highlevel==1, absorb(avcode) robust
mycmd1 (abc) areg hotline abc cohort2009 if lowlevel==1, absorb(avcode) robust

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..3] = FF[.,1]'; ResD[`c',1..3] = FF[.,2]'; ResDF[`c',1..3] = FF[.,3]'
mata ResB[`c',1..3] = BB[.,1]'; ResSE[`c',1..3] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 23/25 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 32/34 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherAKL2, replace


*******************************

use DatAKL3, clear

matrix F = J(15,4,.)
matrix B = J(15,2,.)

global i = 1
global j = 1

*Table 9
foreach outcome in cellphoneowner usecellphone makecall receivecall writesms receivesms anybip madetransferSMS receivedtransferSMS communicate_migrant celltalkrelativeniger celltalktradeniger whycell_ceremony whycell_help whycell_priceinfo {
	mycmd (abc) areg `outcome' abc, absorb(avcode) robust cluster(codev)
	}

global N = 114
mata Y = st_data((1,$N),"Y2")
generate Order = _n
generate double U = .
destring codevillage, replace

mata ResF = J($reps,15,.); ResD = J($reps,15,.); ResDF = J($reps,15,.); ResB = J($reps,15,.); ResSE = J($reps,15,.)
forvalues c = 1/$reps {
	matrix FF = J(15,3,.)
	matrix BB = J(15,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace abc = Y2[`i'] if codevillage == Y3[`i']
		}

global i = 1
global j = 1

*Table 9
foreach outcome in cellphoneowner usecellphone makecall receivecall writesms receivesms anybip madetransferSMS receivedtransferSMS communicate_migrant celltalkrelativeniger celltalktradeniger whycell_ceremony whycell_help whycell_priceinfo {
	mycmd1 (abc) areg `outcome' abc, absorb(avcode) robust cluster(codev)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..15] = FF[.,1]'; ResD[`c',1..15] = FF[.,2]'; ResDF[`c',1..15] = FF[.,3]'
mata ResB[`c',1..15] = BB[.,1]'; ResSE[`c',1..15] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 26/40 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 35/49 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherAKL3, replace


*****************************************

use ip\FisherAKL3, clear
mkmat F1-F4 in 1/15, matrix(F3)
mkmat B1-B2 in 1/15, matrix(B3)
drop F* B* 
sort N
save a, replace

use ip\FisherAKL2, clear
mkmat F1-F4 in 1/3, matrix(F2)
mkmat B1-B2 in 1/3, matrix(B2)
drop F* B* 
sort N
save b, replace

use ip\FisherAKL1, clear
mkmat F1-F4 in 1/22, matrix(F1)
mkmat B1-B2 in 1/31, matrix(B1)
drop F* B* 
foreach i in b a {
	sort N
	merge N using `i'
	tab _m
	drop _m
	}
sort N
aorder

matrix F = F1 \  F2 \ F3
matrix B = B1 \ B2 \ B3
svmat double F
svmat double B
save results\FisherAKL, replace

erase a.dta
erase b.dta



