


capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust select(string) twostep]
	gettoken testvars anything: anything, match(match)
	if ("`twostep'" == "") `anything' `if' `in', `robust' 
	if ("`twostep'" ~= "") `anything' `if' `in', select(`select') `twostep' `robust' 
	testparm `testvars'
	global k = r(df)
	unab testvars: `testvars'
	matrix B = J($k,2,.)
	local i = 1
	foreach var in `testvars' {
		matrix B[`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		if ("`select'" ~= "") {
			matrix B[`i',1] = _b[select:`var'], _se[select:`var']
			local i = `i' + 1
			}
		}
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		if ("`twostep'" == "") quietly `anything' if M ~= `i', `robust' 
		if ("`twostep'" ~= "") quietly `anything' if M ~= `i', select(`select') `twostep' `robust'
		matrix BB = J($k,2,.)
		local c = 1
		foreach var in `testvars' {
			matrix BB[`c',1] = _b[`var'], _se[`var']
			local c = `c' + 1
			if ("`select'" ~= "") {
				matrix BB[`c',1] = _b[select:`var'], _se[select:`var']
				local c = `c' + 1
				}
			}
		matrix F = J(1,3,.)
		capture testparm `testvars'
		if (_rc == 0) matrix F = r(p), r(drop), e(df_r)
		mata BB = st_matrix("BB"); F = st_matrix("F"); ResB[`i',1..$k] = BB[1..$k,1]'; ResSE[`i',1..$k] = BB[1..$k,2]'; ResF[`i',1..3] = F
		}
	quietly drop _all
	quietly set obs $N
	global kk = $j + $k - 1
	forvalues i = $j/$kk {
		quietly generate double ResB`i' = .
		}
	forvalues i = $j/$kk {
		quietly generate double ResSE`i' = .
		}
	quietly generate double ResF$i = .
	quietly generate double ResD$i = .
	quietly generate double ResDF$i = .
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	quietly svmat double B
	quietly rename B2 SE$i
	capture rename B1 B$i
	save ip\JK$i, replace
restore
	global i = $i + 1
	global j = $j + $k
end



*******************

global cluster = ""

use DatBM, clear

global i = 1
global j = 1

*Table 2
mycmd (OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA) reg ref OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd (OPtreat1 FTreat4 OPpuzzletypeA) reg ref OPtreat1 FTreat4 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd (OPtestzOPtreat1 OPtestzOPtreat2 OPtestzOPtreat4 OPtestzOPtreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA) reg ref OPtestzOPtreat1 OPtestzOPtreat2 OPtestzOPtreat4 OPtestzOPtreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6

*Table 3
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) probit ref OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd (OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA) probit ref OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_relative_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_relative_REFrep OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA) heckman reftestz OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep

*Table 4
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) probit ref OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA) probit ref OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_relative_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_relative_REFrep OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep

*Table 5
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd (OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7

use ip\JK1, clear
forvalues i = 2/22 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/22 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeBM, replace


