
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

use DatALO1, clear

global basic1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
global basic2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
global all1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9
global all2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9

matrix F = J(60,4,.)
matrix B = J(174,2,.)

global i = 1
global j = 1

*Table 3
foreach X in signup used_ssp used_adv used_fsg {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="F", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="F", robust
	}
	
*Table 5 
foreach X in grade_20059_fall GPA_year1 {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd (ssp sfpany) reg `X' ssp sfpany $all1 if noshow == 0, robust
	}

foreach X in grade_20059_fall GPA_year1 {
	foreach group in 2 3 {
		mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group', robust
		mycmd (ssp sfpany) reg `X' ssp sfpany $all2 if noshow == 0 & group`group', robust
		}	
	}

*Table 6 
foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0 & C, robust
	}	

foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	foreach group in 2 3 {
		mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group' & C, robust
		}	
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0 & C, robust
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	foreach group in 2 3 {
		mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group' & C, robust
		}	
	}
	
generate Order = _n
generate double U = .
mata Y = st_data(.,("ssp","sfp","sfsp","sfpany"))

mata ResF = J($reps,60,.); ResD = J($reps,60,.); ResDF = J($reps,60,.); ResB = J($reps,174,.); ResSE = J($reps,174,.)
forvalues c = 1/$reps {
	matrix FF = J(60,3,.)
	matrix BB = J(174,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort U
	mata st_store(.,("ssp","sfp","sfsp","sfpany"),Y)

global i = 1
global j = 1

*Table 3
foreach X in signup used_ssp used_adv used_fsg {
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic1 if noshow == 0, robust
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="M", robust
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="M", robust
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="F", robust
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="F", robust
	}
	
*Table 5 
foreach X in grade_20059_fall GPA_year1 {
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd1 (ssp sfpany) reg `X' ssp sfpany $all1 if noshow == 0, robust
	}

foreach X in grade_20059_fall GPA_year1 {
	foreach group in 2 3 {
		mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group', robust
		mycmd1 (ssp sfpany) reg `X' ssp sfpany $all2 if noshow == 0 & group`group', robust
		}	
	}

*Table 6 
foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0 & C, robust
	}	

foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	foreach group in 2 3 {
		mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group' & C, robust
		}	
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0 & C, robust
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	foreach group in 2 3 {
		mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group' & C, robust
		}	
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..60] = FF[.,1]'; ResD[`c',1..60] = FF[.,2]'; ResDF[`c',1..60] = FF[.,3]'
mata ResB[`c',1..174] = BB[.,1]'; ResSE[`c',1..174] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/60 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/174 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherALO1, replace

**************************************

use DatALO2, clear

matrix F = J(24,4,.)
matrix B = J(72,2,.)

global all1 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9 YEAR2

global i = 1
global j = 1

*Table 7 
foreach group in 2 3 {
	mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp $all1  if S == 1 & group`group', cluster(id)
	foreach quantile in .1 .25 .5 .75 .9 {
		mycmd (ssp sfp sfsp) qreg GPA_year ssp sfp sfsp $all1 if S == 1 & group`group', quantile(`quantile')
		}	
	}
mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, cluster(id)
mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, cluster(id)
foreach quantile in .1 .25 .5 .75 .9 {
	mycmd (ssp sfp sfsp) qreg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, quantile(`quantile')
	mycmd (ssp sfp sfsp) qreg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, quantile(`quantile')
	}	

sort year id
generate Order = _n
generate double U = .
global N = 1656
mata Y = st_data((1,$N),("ssp","sfp","sfsp"))

mata ResF = J($reps,24,.); ResD = J($reps,24,.); ResDF = J($reps,24,.); ResB = J($reps,72,.); ResSE = J($reps,72,.)
forvalues c = 1/$reps {
	matrix FF = J(24,3,.)
	matrix BB = J(72,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort year U in 1/$N
	mata st_store((1,$N),("ssp","sfp","sfsp"),Y)
	sort id year
	foreach j in ssp sfp sfsp {
		quietly replace `j' = `j'[_n-1] if id == id[_n-1] & year == 2
		}

global i = 1
global j = 1
*Table 7 
foreach group in 2 3 {
	mycmd1 (ssp sfp sfsp) reg GPA_year ssp sfp sfsp $all1  if S == 1 & group`group', cluster(id)
	foreach quantile in .1 .25 .5 .75 .9 {
		mycmd1 (ssp sfp sfsp) qreg GPA_year ssp sfp sfsp $all1 if S == 1 & group`group', quantile(`quantile')
		}	
	}
mycmd1 (ssp sfp sfsp) reg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, cluster(id)
mycmd1 (ssp sfp sfsp) reg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, cluster(id)
foreach quantile in .1 .25 .5 .75 .9 {
	mycmd1 (ssp sfp sfsp) qreg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, quantile(`quantile')
	mycmd1 (ssp sfp sfsp) qreg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, quantile(`quantile')
	}	

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..24] = FF[.,1]'; ResD[`c',1..24] = FF[.,2]'; ResDF[`c',1..24] = FF[.,3]'
mata ResB[`c',1..72] = BB[.,1]'; ResSE[`c',1..72] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/24 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/72 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherALO2, replace

************************************************************

*Table 8 

use DatALO3, clear

global all3 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9 YEAR2

matrix F = J(3,4,.)
matrix B = J(9,2,.)

global i = 1
global j = 1
foreach X in prob_year credits_earned GPA_year {
	mycmd (ssp_p sfp_p sfsp_p) ivreg `X' (ssp_p sfp_p sfsp_p = ssp sfsp sfp) $all3 if S == 1, robust cluster(id)
	}	

matrix FIV = F
matrix BIV = B
	
matrix F = J(3,4,.)
matrix B = J(9,2,.)

global i = 1
global j = 1
foreach X in prob_year credits_earned GPA_year {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all3 if S == 1, robust cluster(id)
	}	

sort year id
generate Order = _n
generate double U = .
global N = 1656
mata Y = st_data((1,$N),("ssp","sfp","sfsp"))

mata ResF = J($reps,3,.); ResD = J($reps,3,.); ResDF = J($reps,3,.); ResB = J($reps,9,.); ResSE = J($reps,9,.)
forvalues c = 1/$reps {
	matrix FF = J(3,3,.)
	matrix BB = J(9,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort year U in 1/$N
	mata st_store((1,$N),("ssp","sfp","sfsp"),Y)
	sort id year
	foreach j in ssp sfp sfsp {
		quietly replace `j' = `j'[_n-1] if id == id[_n-1] & year == 2
		}

global i = 1
global j = 1
foreach X in prob_year credits_earned GPA_year {
	mycmd1 (ssp sfp sfsp) reg `X' ssp sfp sfsp $all3 if S == 1, robust cluster(id)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..3] = FF[.,1]'; ResD[`c',1..3] = FF[.,2]'; ResDF[`c',1..3] = FF[.,3]'
mata ResB[`c',1..9] = BB[.,1]'; ResSE[`c',1..9] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/3 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/9 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
svmat double FIV
svmat double BIV
gen N = _n
sort N
save ip\FisherALO3, replace

***********************


*Combining files

use ip\FisherALO2, clear
mkmat F1-F4 in 1/24, matrix(FF)
mkmat B1 B2 in 1/72, matrix(BB)
drop F1-F4 B1 B2 
forvalues i = 24(-1)1 {
	local j = `i' + 60
	rename ResF`i' ResF`j'
	rename ResD`i' ResD`j'
	rename ResDF`i' ResDF`j'
	}
forvalues i = 72(-1)1 {
	local j = `i' + 174
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
sort N
save aa, replace

use ip\FisherALO3, clear
mkmat F1-F4 in 1/3, matrix(FFF)
mkmat B1 B2 in 1/9, matrix(BBB)
mkmat FIV1-FIV4 in 1/3, matrix(FIV)
mkmat BIV1 BIV2 in 1/9, matrix(BIV)
drop F1-F4 B1 B2 FIV1-FIV4 BIV1 BIV2 
forvalues i = 3(-1)1 {
	local j = `i' + 84
	rename ResF`i' ResF`j'
	rename ResD`i' ResD`j'
	rename ResDF`i' ResDF`j'
	}
forvalues i = 9(-1)1 {
	local j = `i' + 246
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
sort N
save bb, replace

use ip\FisherALO1, clear
mkmat F1-F4 in 1/60, matrix(F)
mkmat B1 B2 in 1/174, matrix(B)
drop F1-F4 B1 B2 
matrix F = F \ FF \ FFF
matrix B = B \ BB \ BBB
matrix FIV = J(84,4,.) \ FIV
matrix BIV = J(246,2,.) \ BIV
foreach i in aa bb {
	sort N
	merge N using `i'
	tab _m
	drop _m
	sort N
	}
foreach i in F B FIV BIV {
	svmat double `i'
	}
aorder
save results\FisherALO, replace

erase aa.dta
erase bb.dta






