
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, twostep select(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`twostep'" ~= "") global k = 2*$k
	if ("`twostep'" ~= "") {
		`anything' `if' `in', `twostep' select(`select')
		}
	else {
		`anything' `if' `in', 
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		if ("`twostep'" == "") {
			foreach var in `testvars' {
				matrix B[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		else {
			foreach var in `testvars' {
				matrix B[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, twostep select(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`twostep'" ~= "") global k = 2*$k
	if ("`twostep'" ~= "") {
		capture `anything' `if' `in', `twostep' select(`select')
		}
	else {
		capture `anything' `if' `in', 
		}
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), $k - r(df), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			if ("`twostep'" ~= "" ) {
				matrix S = J($k,rowsof(V),0)
				local i = 1
				foreach var in `testvars' {
					local q = rownumb(V,"`var'")
					matrix S[`i',`q'] = 1
					local i = `i' + 1
					local q = rownumb(V,"select:`var'")
					matrix S[`i',`q'] = 1
					local i = `i' + 1
					}
				matrix V = S*V*S'
				matrix b = b*S'
				}
			else {
				matrix V = V[1..$k,1..$k]
				matrix b = b[1,1..$k]
				}
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) matrix FF[$i,4] = chi2tail($k,f[1,1])
			local i = 0
			if ("`twostep'" == "") {
				foreach var in `testvars' {
					matrix BB[$j+`i',1] = _b[`var'], _se[`var']
					local i = `i' + 1
					}
				}
			else {
				foreach var in `testvars' {
					matrix BB[$j+`i',1] = _b[`var'], _se[`var']
					local i = `i' + 1
					matrix BB[$j+`i',1] = _b[select:`var'], _se[select:`var']
					local i = `i' + 1
					}
				}
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************

global a = 22
global b = 106

use DatBM, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Table 2
mycmd (OPtreat1 OPtreat2 OPtreat4 OPtreat5) reg ref OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd (OPtreat1 FTreat4) reg ref OPtreat1 FTreat4 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd (OPtestzOPtreat1 OPtestzOPtreat2 OPtestzOPtreat4 OPtestzOPtreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5) reg ref OPtestzOPtreat1 OPtestzOPtreat2 OPtestzOPtreat4 OPtestzOPtreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6

*Table 3
mycmd (OPtreat1 OPtreat2) probit ref OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd (OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2) probit ref OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd (OPtreat1 OPtreat2) heckman OP_coworkers_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2) heckman OP_coworkers_REFrep OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat1 OPtreat2) heckman OP_relative_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2) heckman OP_relative_REFrep OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2) heckman reftestz OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep

*Table 4
mycmd (OPtreat4 OPtreat5) probit ref OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5) probit ref OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd (OPtreat4 OPtreat5) heckman OP_coworkers_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5) heckman OP_coworkers_REFrep OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtreat5) heckman OP_relative_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5) heckman OP_relative_REFrep OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep

*Table 5
mycmd (OPtreat4 OPtreat5) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtreat5) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5) heckman reftestz OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtreat5) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd (OPtreat4 OPtreat5) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5) reg reftestz_e OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7

gen N = _n
sort N
save aa, replace

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

global i = 1
global j = 1

*Table 2
mycmd1 (OPtreat1 OPtreat2 OPtreat4 OPtreat5) reg ref OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd1 (OPtreat1 FTreat4) reg ref OPtreat1 FTreat4 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd1 (OPtestzOPtreat1 OPtestzOPtreat2 OPtestzOPtreat4 OPtestzOPtreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5) reg ref OPtestzOPtreat1 OPtestzOPtreat2 OPtestzOPtreat4 OPtestzOPtreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6

*Table 3
mycmd1 (OPtreat1 OPtreat2) probit ref OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd1 (OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2) probit ref OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd1 (OPtreat1 OPtreat2) heckman OP_coworkers_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd1 (OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2) heckman OP_coworkers_REFrep OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd1 (OPtreat1 OPtreat2) heckman OP_relative_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd1 (OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2) heckman OP_relative_REFrep OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd1 (OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2) heckman reftestz OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep

*Table 4
mycmd1 (OPtreat4 OPtreat5) probit ref OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd1 (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5) probit ref OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd1 (OPtreat4 OPtreat5) heckman OP_coworkers_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd1 (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5) heckman OP_coworkers_REFrep OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd1 (OPtreat4 OPtreat5) heckman OP_relative_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd1 (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5) heckman OP_relative_REFrep OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep

*Table 5
mycmd1 (OPtreat4 OPtreat5) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd1 (OPtreat4 OPtreat5) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd1 (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5) heckman reftestz OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd1 (OPtreat4 OPtreat5) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd1 (OPtreat4 OPtreat5) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd1 (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5) reg reftestz_e OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7

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
save results\OBootstrapRedBM, replace

capture erase aa.dta
capture erase aaa.dta


