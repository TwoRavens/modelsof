

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

use DatD1, clear

global a = 4
global b = 8

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"  

global i = 1
global j = 1
mycmd (sampleSD HIVtreat) reg fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, asis cluster(schoolid)
foreach X in unmarpreg marpreg {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
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
*Tested this code (unrandomized) and it reproduces the treatment vector in the data files
	quietly replace a = .
	forvalues i = 1/$N {
		quietly replace sampleSD = STREAT[`i'] if schoolid == SCHOOLID[`i']
		quietly replace a = HTREAT[`i'] if sch03v1 == SCHOOLID[`i']
		}
	forvalues i = 1/$N {
		quietly replace a = HTREAT[`i'] if sch04v1 == SCHOOLID[`i'] & a == .
		}
	quietly replace HIVtreat = a

global i = 1
global j = 1
mycmd1 (sampleSD HIVtreat) reg fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd1 (sampleSD HIVtreat) probit fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, asis cluster(schoolid)
foreach X in unmarpreg marpreg {
	mycmd1 (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
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
save ip\FisherD1, replace

************************************
************************************

use DatD2, clear

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil d04v1 d04v2 d05v1 d05v2" 

global a = 4
global b = 8

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
mycmd (sampleSDT HIVtreat) reg fertafter12 sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (sampleSDT HIVtreat) xtreg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) fe 
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
mycmd1 (sampleSDT HIVtreat) xtreg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) fe 
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
save ip\FisherD2, replace


**********************************************************************************

use DatD3, clear

global school_controls="sdkcpe girl8perboy8"

global a = 8
global b = 16

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
mycmd (sampleSD HIVtreat) reg agegap sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (SDtreat HIVtreat) reg agegap SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14 if agegap!=40, cluster(schoolid) 
mycmd (sampleSD HIVtreat) reg gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd (SDtreat HIVtreat) reg gapabove5 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)
mycmd (sampleSD HIVtreat) reg gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd (SDtreat HIVtreat) reg gapabove10 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)

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

*Tested this code (unrandomized) and it produces the treatment vector in the data files
	forvalues i = 1/$N {
		quietly replace sampleSD = STREAT[`i'] if schoolid == SCHOOLID[`i']
		quietly replace HIVtreat = HTREAT[`i'] if schoolid == SCHOOLID[`i']
		}
	quietly replace SDtreat = sampleSD*cohort

global i = 1
global j = 1
mycmd1 (sampleSD HIVtreat) reg agegap sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd1 (SDtreat HIVtreat) reg agegap SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14 if agegap!=40, cluster(schoolid) 
mycmd1 (sampleSD HIVtreat) reg gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd1 (sampleSD HIVtreat) probit gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd1 (SDtreat HIVtreat) reg gapabove5 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)
mycmd1 (sampleSD HIVtreat) reg gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd1 (sampleSD HIVtreat) probit gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd1 (SDtreat HIVtreat) reg gapabove10 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)

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
save ip\FisherD3, replace

**********************************************************************************

use DatD4, clear

global indiv_controls="unsampled age agemissing "
global school_controls="boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy "

global a = 26
global b = 52

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster) 
	}
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} boysonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==0, cluster(cluster) 
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

*Tested this code (unrandomized) and it produces the treatment vector in the data files (unsampled = 1, no prischoolid, all get treatment = 0)
	forvalues i = 1/$N {
		quietly replace sampleSD = STREAT[`i'] if prischoolid == SCHOOLID[`i']
		quietly replace HIVtreat = HTREAT[`i'] if prischoolid == SCHOOLID[`i']
		}

global i = 1
global j = 1
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd1 (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster) 
	}
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd1 (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} boysonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==0, cluster(cluster) 
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
save ip\FisherD4, replace

*********************************************************************************

use DatD5, clear

global a = 10
global b = 10

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
foreach X in repeat8 secschool training athome evdead05v2 { 
	mycmd (sampleSD) reg `X'  sampleSD if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (sampleSD) reg `X'  sampleSD if girl==0
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

*Tested this code (unrandomized) and it produces the treatment vector in the data files 
	forvalues i = 1/$N {
		quietly replace sampleSD = STREAT[`i'] if schoolid == SCHOOLID[`i']
		}
global i = 1
global j = 1
foreach X in repeat8 secschool training athome evdead05v2 { 
	mycmd1 (sampleSD) reg `X'  sampleSD if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd1 (sampleSD) reg `X'  sampleSD if girl==0
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
save ip\FisherD5, replace

*****************************************

use DatD6, clear

global a = 10
global b = 10

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==0
	}

*Because of rounding of HIVtreat by school (students were in different schools at different times) 
*will have to implement randomization by calling the file repeatedly

use DatDD6, clear
global N = 328
mata YY = st_data((1,$N),"HTREAT")

mata ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,3,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'
	use DatDD6, clear
	quietly replace U = uniform() in 1/$N
	sort TTstrata U
	mata st_store((1,$N),"HTREAT",YY)
*Tested this code (unrandomized) and it produces the treatment vector in the data files 
	quietly replace a = .
	forvalues i = 1/$N {
		quietly replace a = HTREAT[`i'] if sch03v1 == SCHOOLID[`i']
		}
	forvalues i = 1/$N {
		quietly replace a = HTREAT[`i'] if sch04v1 == SCHOOLID[`i'] & a == .
		}
	quietly replace HIVtreat = a

collapse HIVtreat repeat8 secschool training athome evdead05v2, by(schoolid girl) fast
quietly replace HIVtreat = (HIVtreat >= .5)

global i = 1
global j = 1
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd1 (HIVtreat) reg `X' HIVtreat if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd1 (HIVtreat) reg `X' HIVtreat if girl==0
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
save ip\FisherD6, replace

******************************************************************************

use DatD7, clear

global school_controls="sdkcpe girl8perboy8_2004"

global a = 3
global b = 6

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2-ZONE4 ZONE6-ZONE14 if class == 8 & selfinterview == 1, cluster(schoolid)
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE12 ZONE14 if class == 8 & selfinterview == 0, cluster(schoolid)

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

*Tested this code (unrandomized) and it produces the treatment vector in the data files
	forvalues i = 1/$N {
		quietly replace sampleSD_survey = STREAT[`i'] if schoolid == SCHOOLID[`i']
		quietly replace HIVtreat_survey = HTREAT[`i'] if schoolid == SCHOOLID[`i']
		}

global i = 1
global j = 1
mycmd1 (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd1 (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2-ZONE4 ZONE6-ZONE14 if class == 8 & selfinterview == 1, cluster(schoolid)
mycmd1 (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE12 ZONE14 if class == 8 & selfinterview == 0, cluster(schoolid)

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
save ip\FisherD7, replace


*************************************************


use DatD8, clear

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"

global a = 1
global b = 3

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
mycmd (SDonly HIVonly interac) reg fertafter12 SDonly HIVonly interac ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)

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
	quietly replace SDonly = sampleSD*(1-HIVtreat)
	quietly replace HIVonly = HIVtreat*(1-sampleSD)
	quietly replace interac=sampleSD*HIVtreat

global i = 1
global j = 1
mycmd1 (SDonly HIVonly interac) reg fertafter12 SDonly HIVonly interac ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)

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
save ip\FisherD8, replace

******************

use DatD9, clear

global school_controls="sdkcpe girl8perboy8"

global a = 2
global b = 6

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i =1
global j = 1
mycmd (SDonly HIVonly interac) reg agegap SDonly HIVonly interac age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (SDonly HIVonly interac)  reg gapabove5 SDonly HIVonly interac age  ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)

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
	
*Tested this code (unrandomized) and it produces the treatment vector in the data files
	forvalues i = 1/$N {
		quietly replace sampleSD = STREAT[`i'] if schoolid == SCHOOLID[`i']
		quietly replace HIVtreat = HTREAT[`i'] if schoolid == SCHOOLID[`i']
		}
	quietly replace SDonly = sampleSD*(1-HIVtreat)
	quietly replace HIVonly = HIVtreat*(1-sampleSD)
	quietly replace interac=sampleSD*HIVtreat

global i =1
global j = 1
mycmd1 (SDonly HIVonly interac) reg agegap SDonly HIVonly interac age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd1 (SDonly HIVonly interac)  reg gapabove5 SDonly HIVonly interac age  ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)

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
save ip\FisherD9, replace


************************

use DatD10, clear

global indiv_controls="unsampled age agemissing "
global school_controls="boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy "

global a = 2
global b = 6

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
mycmd (SDonly HIVonly interac) reg gapabove5_2 SDonly HIVonly interac ${indiv_controls} girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster)
mycmd (SDonly HIVonly interac) reg everplayedsex_2 SDonly HIVonly interac ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster)

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
	
*Tested this code (unrandomized) and it produces the treatment vector in the data files
*prischoolid doesn't cover all observations, remainder have different school codes than treatment and all have treatment vector = 0
	forvalues i = 1/$N {
		quietly replace sampleSD = STREAT[`i'] if prischoolid == SCHOOLID[`i']
		quietly replace HIVtreat = HTREAT[`i'] if prischoolid == SCHOOLID[`i']
		}
	quietly replace SDonly = sampleSD*(1-HIVtreat)
	quietly replace HIVonly = HIVtreat*(1-sampleSD)
	quietly replace interac=sampleSD*HIVtreat

global i = 1
global j = 1
mycmd1 (SDonly HIVonly interac) reg gapabove5_2 SDonly HIVonly interac ${indiv_controls} girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster)
mycmd1 (SDonly HIVonly interac) reg everplayedsex_2 SDonly HIVonly interac ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster)

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
save ip\FisherD10, replace


*******************************

use ip\FisherD1, clear
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
	use ip\FisherD`i', clear
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
	generate double `var'126 = `var'33
	generate double `var'127 = `var'34
	generate double `var'128 = `var'59
	generate double `var'129 = `var'60
	}
foreach var in F1 F2 F3 F4 {
	replace `var' = `var'[17] if _n == 71
	replace `var' = `var'[30] if _n == 72
	}
foreach var in B1 B2 {
	replace `var' = `var'[33] if _n == 126
	replace `var' = `var'[34] if _n == 127
	replace `var' = `var'[59] if _n == 128
	replace `var' = `var'[60] if _n == 129
	}
aorder
save results\FisherD, replace

forvalues i = 1/10 {
	capture erase a`i'.dta
	}




	





