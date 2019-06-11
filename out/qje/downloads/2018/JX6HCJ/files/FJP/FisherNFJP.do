
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', `robust' cluster(`cluster')
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
	syntax anything [if] [in] [, robust cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', `robust' cluster(`cluster')
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

use DatFJP, clear

matrix F = J(4,4,.)
matrix B = J(12,2,.)

global i = 1
global j = 1
foreach var in taken_new tdeposits Dummy_Client_Income Talk_Fam {
	mycmd (tookup TookUp_muslim TookUp_Hindu_SC_Kat) ivreg `var' (tookup TookUp_muslim TookUp_Hindu_SC_Kat = Treated Treated_Hindu_SC_Kat Treated_muslim ) Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, cluster(t_group)
	}

matrix FIV = F
matrix BIV = B

matrix F = J(4,4,.)
matrix B = J(12,2,.)

global i = 1
global j = 1
foreach var in taken_new tdeposits Dummy_Client_Income Talk_Fam {
	mycmd (Treated Treated_Hindu_SC Treated_muslim) reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, cluster(t_group)
	}

egen Strata = group(sewa_center sampling_phase), label
generate Order = _n
sort Strata Order
generate double U = .
mata Y = st_data(.,"Treated")

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,12,.); ResSE = J($reps,12,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(12,2,.)
	display "`c'"
	set seed `c'
	sort Strata Order
	quietly replace U = uniform()
	sort Strata U 
	mata st_store(.,"Treated",Y)
	quietly replace Treated_Hindu_SC_Kat = Treated*Hindu_SC_Kat
	quietly replace Treated_muslim = Treated*muslim	

global i = 1
global j = 1
foreach var in taken_new tdeposits Dummy_Client_Income Talk_Fam {
	mycmd1 (Treated Treated_Hindu_SC Treated_muslim) reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, cluster(t_group)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..12] = BB[.,1]'; ResSE[`c',1..12] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/4 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/12 {
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
save results\FisherFJP, replace



