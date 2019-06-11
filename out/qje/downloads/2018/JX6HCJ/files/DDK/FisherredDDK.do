
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, absorb(string) cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		`anything' [`weight' `exp'] `if' `in', absorb(`absorb') cluster(`cluster')
		}
	else {
		`anything' [`weight' `exp'] `if' `in', cluster(`cluster')
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
	syntax anything [aw pw] [if] [in] [, absorb(string) cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		quietly `anything' [`weight' `exp'] `if' `in', absorb(`absorb') cluster(`cluster')
		}
	else {
		quietly `anything' [`weight' `exp'] `if' `in', cluster(`cluster')
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

use DatDDK1, clear

matrix F = J(20,4,.)
matrix B = J(56,2,.)

global i = 1
global j = 1

*Table 2
foreach var in stdR_totalscore stdR_r2_totalscore {
	mycmd (tracking) reg `var' tracking, cluster(schoolid)
	mycmd (tracking) reg `var' tracking girl percentile agetest etpteacher, cluster(schoolid)
	mycmd (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf girl percentile agetest etpteacher, cluster(schoolid)
	mycmd (tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking) reg `var' tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking bottomquarter secondquarter topquarter girl percentile agetest etpteacher, cluster(schoolid)
	}
foreach var in stdR_mathscore stdR_litscore stdR_r2_mathscore stdR_r2_litscore {
	mycmd (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf girl percentile agetest etpteacher, cluster(schoolid)
	mycmd (tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking) reg `var' tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking bottomquarter secondquarter topquarter girl percentile agetest etpteacher, cluster(schoolid)
	}

*Table 3
foreach cat in girl cont {
	mycmd (`cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf `cat'_tracking_tophalf anti`cat'_tracking_tophalf) reg stdR_totalscore `cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf  `cat'_tracking_tophalf anti`cat'_tracking_tophalf bottomhalf `cat'_bottomhalf percentile girl agetest etpteacher, cluster(schoolid)
	mycmd (`cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf `cat'_tracking_tophalf anti`cat'_tracking_tophalf) reg stdR_r2_totalscore `cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf  `cat'_tracking_tophalf anti`cat'_tracking_tophalf bottomhalf `cat'_bottomhalf percentile girl agetest etpteacher, cluster(schoolid)
	}

global N = 140
mata Y = st_data((1,$N),"Y2")
generate Order = _n
generate double U = .

mata ResF = J($reps,20,.); ResD = J($reps,20,.); ResDF = J($reps,20,.); ResB = J($reps,56,.); ResSE = J($reps,56,.)
forvalues c = 1/$reps {
	matrix FF = J(20,3,.)
	matrix BB = J(56,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace tracking = Y2[`i'] if schoolid == Y3[`i']
		}
	foreach j in bottomquarter secondquarter topquarter bottomhalf tophalf {
		quietly replace `j'_tracking = `j'*tracking
		}
	foreach cat in girl cont {
		foreach half in bottomhalf tophalf {
			quietly replace `cat'_tracking_`half'=`cat'*`half'_tracking
			quietly replace anti`cat'_tracking_`half'=(1-`cat')*`half'_tracking
			}
		}

global i = 1
global j = 1

*Table 2
foreach var in stdR_totalscore stdR_r2_totalscore {
	mycmd1 (tracking) reg `var' tracking, cluster(schoolid)
	mycmd1 (tracking) reg `var' tracking girl percentile agetest etpteacher, cluster(schoolid)
	mycmd1 (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf girl percentile agetest etpteacher, cluster(schoolid)
	mycmd1 (tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking) reg `var' tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking bottomquarter secondquarter topquarter girl percentile agetest etpteacher, cluster(schoolid)
	}
foreach var in stdR_mathscore stdR_litscore stdR_r2_mathscore stdR_r2_litscore {
	mycmd1 (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf girl percentile agetest etpteacher, cluster(schoolid)
	mycmd1 (tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking) reg `var' tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking bottomquarter secondquarter topquarter girl percentile agetest etpteacher, cluster(schoolid)
	}

*Table 3
foreach cat in girl cont {
	mycmd1 (`cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf `cat'_tracking_tophalf anti`cat'_tracking_tophalf) reg stdR_totalscore `cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf  `cat'_tracking_tophalf anti`cat'_tracking_tophalf bottomhalf `cat'_bottomhalf percentile girl agetest etpteacher, cluster(schoolid)
	mycmd1 (`cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf `cat'_tracking_tophalf anti`cat'_tracking_tophalf) reg stdR_r2_totalscore `cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf  `cat'_tracking_tophalf anti`cat'_tracking_tophalf bottomhalf `cat'_bottomhalf percentile girl agetest etpteacher, cluster(schoolid)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..20] = FF[.,1]'; ResD[`c',1..20] = FF[.,2]'; ResDF[`c',1..20] = FF[.,3]'
mata ResB[`c',1..56] = BB[.,1]'; ResSE[`c',1..56] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/20 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/56 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherRedDDK1, replace


***********************

use DatDDK2, clear

quietly sum NN
global NN = r(max)

matrix F = J(6,4,.)
matrix B = J(6,2,.)

global i = 1
global j = 1

*Table 4
foreach var in stdR_totalscore stdR_mathscore stdR_litscore {
	mycmd (rMEANstream_std_baselinemark) areg `var' rMEANstream_std_baselinemark etpteacher std_mark girl agetest, absorb(schoolid) cluster(section)
	}

foreach spec in "std_mark>=-0.75&std_mark<=0.75" "std_mark<-0.275" "std_mark>0.75" {
	mycmd (rMEANstream_std_baselinemark) areg stdR_totalscore rMEANstream_std_baselinemark etpteacher std_mark girl agetest if `spec', absorb(schoolid) cluster(section)
	}

sort schoolid pupilid
egen STREAM = group(schoolid stream)
mata Y = st_data(.,("STREAM","etpteacher"))
generate Order = _n
generate double U = .

mata ResF = J($reps,6,.); ResD = J($reps,6,.); ResDF = J($reps,6,.); ResB = J($reps,6,.); ResSE = J($reps,6,.)
forvalues c = 1/$reps {
	matrix FF = J(6,3,.)
	matrix BB = J(6,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort schoolid U 
	mata st_store(.,("STREAM","etpteacher"),Y)
	forvalues i = 1/$NN {
		quietly egen ra=mean(C`i'),by(STREAM)
		quietly replace RR=ra if NN==`i'
		drop ra
		}
	quietly replace rMEANstream_std_baselinemark = RR if rMEANstream_std_baselinemark ~= .
	
global i = 1
global j = 1

*Table 4
foreach var in stdR_totalscore stdR_mathscore stdR_litscore {
	mycmd1 (rMEANstream_std_baselinemark) areg `var' rMEANstream_std_baselinemark etpteacher std_mark girl agetest, absorb(schoolid) cluster(section)
	}
foreach spec in "std_mark>=-0.75&std_mark<=0.75" "std_mark<-0.275" "std_mark>0.75" {
	mycmd1 (rMEANstream_std_baselinemark) areg stdR_totalscore rMEANstream_std_baselinemark etpteacher std_mark girl agetest if `spec', absorb(schoolid) cluster(section)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..6] = FF[.,1]'; ResD[`c',1..6] = FF[.,2]'; ResDF[`c',1..6] = FF[.,3]'
mata ResB[`c',1..6] = BB[.,1]'; ResSE[`c',1..6] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/6 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/6 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherRedDDK2, replace


***********************************

use DatDDK3, clear

matrix F = J(7,4,.)
matrix B = J(14,2,.)

global i = 1
global j = 1

*Table 7
foreach var in diff1_score diff2_score diff3_score letterscore24  wordscore spellscore24  sentscore24 {
	mycmd (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf agetest girl , cluster(schoolid)
	}

global N = 140
mata Y = st_data((1,$N),"Y2")
generate Order = _n
generate double U = .

mata ResF = J($reps,7,.); ResD = J($reps,7,.); ResDF = J($reps,7,.); ResB = J($reps,14,.); ResSE = J($reps,14,.)
forvalues c = 1/$reps {
	matrix FF = J(7,3,.)
	matrix BB = J(14,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace tracking = Y2[`i'] if schoolid == Y3[`i']
		}
	quietly replace bottomhalf_tracking = bottomhalf*tracking

global i = 1
global j = 1

*Table 7
foreach var in diff1_score diff2_score diff3_score letterscore24  wordscore spellscore24  sentscore24 {
	mycmd1 (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf agetest girl , cluster(schoolid)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..7] = FF[.,1]'; ResD[`c',1..7] = FF[.,2]'; ResDF[`c',1..7] = FF[.,3]'
mata ResB[`c',1..14] = BB[.,1]'; ResSE[`c',1..14] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/7 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/14 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherRedDDK3, replace


*************************************************

*Combining Files

use ip\FisherRedDDK3, clear
mkmat F1-F4 in 1/7, matrix(FFF)
mkmat B1 B2 in 1/14, matrix(BBB)
forvalues i = 7(-1)1 {
	local j = `i' + 26
	rename ResF`i' ResF`j'
	rename ResDF`i' ResDF`j'
	rename ResD`i' ResD`j'
	}
forvalues i = 14(-1)1 {
	local j = `i' + 62
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
drop F1-F4 B1 B2 
sort N
save aa, replace

use ip\FisherRedDDK2, clear
mkmat F1-F4 in 1/6, matrix(FF)
mkmat B1 B2 in 1/6, matrix(BB)
forvalues i = 6(-1)1 {
	local j = `i' + 20
	rename ResF`i' ResF`j'
	rename ResDF`i' ResDF`j'
	rename ResD`i' ResD`j'
	}
forvalues i = 6(-1)1 {
	local j = `i' + 56
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
drop F1-F4 B1 B2 
sort N
save bb, replace

use ip\FisherRedDDK1, clear
mkmat F1-F4 in 1/20, matrix(F)
mkmat B1 B2 in 1/56, matrix(B)
matrix F = F \ FF \ FFF
matrix B = B \ BB \ BBB
drop F1-F4 B1 B2 
foreach j in aa bb {
	sort N
	merge N using `j'
	tab _m
	drop _m
	sort N
	}
foreach j in F B {
	svmat double `j'
	}
aorder
save results\FisherRedDDK, replace

capture erase aa.dta
capture erase bb.dta

























