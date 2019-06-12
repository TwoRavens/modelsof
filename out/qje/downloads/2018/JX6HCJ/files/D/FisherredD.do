

****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) fe asis]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `fe' `asis'
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
	syntax anything [if] [in] [, cluster(string) fe asis]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', cluster(`cluster') `fe' `asis'
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

*Coding of treatment - linkage to schoolid varies by file
*SD2005_rev2 - sampleSD = schoolid, HIVtreat = sch03v1, sch04v1 if unavailable, schoolid == sch04v1
*SDcontrolcohort_rev2 - sampleSD = schoolid, HIVtreat = sch03v1 (covers all observations), schoolid = sch03v1
*homesurvey_rev3, homesurvey_rev4 = both = schoolid
*HIKAP_survey.dta = both = prischoolid, missing prischoolid are all treatment == 0 

**************************************************************************************************

use ip\FisherD1, clear
save ip\FisherRedD1, replace

************************************
************************************

use DatD2, clear

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil d04v1 d04v2 d05v1 d05v2" 

global a = 4
global b = 7

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
mycmd (sampleSDT HIVtreat) reg fertafter12 sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (sampleSDT) xtreg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) fe 
foreach X in unmarpreg marpreg {
	mycmd (sampleSDT HIVtreat) reg `X' sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}

generate Order = _n
generate double U = .
global N = 328
sort TTstrata Order in 1/$N
mata Y = st_data((1,$N),("HTREAT","M","sumodd"))
sort M KCPE2001 Order
mata YY = st_data((1,$N),"STREAT")
generate a = .

mata ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,3,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	sort Order
	quietly replace U = uniform() in 1/$N
	sort TTstrata U in 1/$N
	mata st_store((1,$N),("HTREAT","M","sumodd"),Y)

	sort M KCPE2001 Order
	capture drop medianindicator
	by M: gen medianindicator = (_n <= sumodd)
	quietly replace U = uniform() in 1/$N
	sort M medianindicator U
	mata st_store((1,$N),"STREAT",YY)

*This part of the code comes from analysis of create_data_studycohort.do file, which created the datafile used herein
*HIVtreat based upon sch03v1, failing that sch04v1
*Tested this code (unrandomized) and it produces the treatment vector in the data files
	quietly replace a = .
	forvalues i = 1/$N {
		quietly replace sampleSD = STREAT[`i'] if schoolid == SCHOOLID[`i']
		quietly replace a = HTREAT[`i'] if sch03v1 == SCHOOLID[`i']
		}
	forvalues i = 1/$N {
		quietly replace a = HTREAT[`i'] if sch04v1 == SCHOOLID[`i'] & a == .
		}
	quietly replace HIVtreat = a
	quietly replace sampleSDT = sampleSD*cohort

global i = 1
global j = 1
mycmd1 (sampleSDT HIVtreat) reg fertafter12 sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd1 (sampleSDT) xtreg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) fe 
foreach X in unmarpreg marpreg {
	mycmd1 (sampleSDT HIVtreat) reg `X' sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherRedD2, replace


**********************************************************************************

forvalues i = 3/10 {
	use ip\FisherD`i', clear
	save ip\FisherRedD`i', replace
	}
	
*******************************

use ip\FisherRedD1, clear
quietly sum F1
global k = r(N)
quietly sum B1
global N = r(N)
mkmat F1-F4 in 1/$k, matrix(F)
mkmat B1-B2 in 1/$N, matrix(B)
drop F1-F4 B1-B2 
sort N
save a1, replace

forvalues i = 2/10 {
	use ip\FisherRedD`i', clear
	quietly sum F1
	global k1 = r(N)
	quietly sum B1
	global N1 = r(N)
	mkmat F1-F4 in 1/$k1, matrix(FF)
	mkmat B1-B2 in 1/$N1, matrix(BB)
	matrix F = F \ FF
	matrix B = B \ BB
	drop F1-F4 B1-B2 
	forvalues k = $k1(-1)1 {
		local j = `k' + $k
		rename ResF`k' ResF`j'
		rename ResDF`k' ResDF`j'
		rename ResD`k' ResD`j'
		}
	forvalues k = $N1(-1)1 {
		local j = `k' + $N
		rename ResB`k' ResB`j'
		rename ResSE`k' ResSE`j'
		}
	sort N
	global k = $k + $k1
	global N = $N + $N1
	save a`i', replace
	}

use a1
forvalues i = 2/10 {
	sort N
	merge N using a`i'
	tab _m
	drop _m
	}
sort N
svmat double F
svmat double B

foreach var in ResF ResD ResDF {
	generate double `var'71 = `var'17
	generate double `var'72 = `var'30
	}
foreach var in ResB ResSE {
	generate double `var'125 = `var'32
	generate double `var'126 = `var'33
	generate double `var'127 = `var'58
	generate double `var'128 = `var'59
	}
foreach var in F1 F2 F3 F4 {
	replace `var' = `var'[17] if _n == 71
	replace `var' = `var'[30] if _n == 72
	}
foreach var in B1 B2 {
	replace `var' = `var'[32] if _n == 125
	replace `var' = `var'[33] if _n == 126
	replace `var' = `var'[58] if _n == 127
	replace `var' = `var'[59] if _n == 128
	}
aorder
save results\FisherRedD, replace

forvalues i = 1/10 {
	capture erase a`i'.dta
	}





	





