

****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, select(string) twostep]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`select'" ~= "") {
		`anything' `if' `in', select(`select') `twostep'
		global k = 2*$k
		}
	else {
		`anything' `if' `in'
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			if ("`select'" ~= "") {
				matrix B[$j+`i',1] = _b[select:`var'], _se[select:`var']
				local i = `i' + 1
				}
			}		
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatBM, clear

foreach var in OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA {
	gen b`var' = `var'
	}

matrix F = J(24,4,.)
matrix B = J(144,2,.)

global i = 1
global j = 1

*Table 2
mycmd (OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA) reg ref OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd (OPtreat1 FTreat4 OPpuzzletypeA) reg ref OPtreat1 FTreat4 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd (OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA) reg ref OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6

*Table 3
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) probit ref OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd (OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPpuzzletypeA) probit ref OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_relative_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPpuzzletypeA) heckman OP_relative_REFrep OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPpuzzletypeA) heckman reftestz OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtestzOPtreat1 OPtreat2 OPtestzOPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep

*Table 4
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) probit ref OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd (OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA) probit ref OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_relative_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA) heckman OP_relative_REFrep OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep

*Table 5
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA) heckman reftestz OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd (OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA) reg reftestz_e OPtreat4 OPtestzOPtreat4 OPtreat5 OPtestzOPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7

generate Order = _n
generate double U = .

global i = 0

*Table 2

foreach var in OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA {
	global i = $i + 1
	capture drop Strata
	quietly replace b`var' = 0
	egen Strata = group(bOPtreat1 bOPtreat2 bOPtreat4 bOPtreat5 bOPpuzzletypeA)
	quietly replace b`var' = `var'
	randcmdc ((`var') reg ref OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/12 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

*Table 3

foreach var in OPtreat1 OPtreat2 OPpuzzletypeA {
	global i = $i + 1
	capture drop Strata
	quietly replace b`var' = 0
	egen Strata = group(bOPtreat1 bOPtreat2 bOPpuzzletypeA)
	quietly replace b`var' = `var'
	randcmdc ((`var') probit ref OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 ), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/47 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

*Table 4

foreach var in OPtreat4 OPtreat5 OPpuzzletypeA {
	global i = $i + 1
	capture drop Strata
	quietly replace b`var' = 0
	egen Strata = group(bOPtreat4 bOPtreat5 bOPpuzzletypeA)
	quietly replace b`var' = `var'
	randcmdc ((`var') probit ref OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/37 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

*Table 5

forvalues j = 1/22 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in OPtreat4 OPtreat5 OPpuzzletypeA {
	global i = $i + 1
	capture drop Strata
	quietly replace b`var' = 0
	egen Strata = group(bOPtreat4 bOPtreat5 bOPpuzzletypeA)
	quietly replace b`var' = `var'
	randcmdc ((`var') reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in OPtreat4 OPtreat5 OPpuzzletypeA {
	global i = $i + 1
	capture drop Strata
	quietly replace b`var' = 0
	egen Strata = group(bOPtreat4 bOPtreat5 bOPpuzzletypeA)
	quietly replace b`var' = `var'
	randcmdc ((`var') reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/5 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}


matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondBM, replace
