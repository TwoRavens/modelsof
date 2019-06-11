
*randomizing at author's clustering level


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, vce(string) hc3 ll robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', vce(`vce') `hc3' `ll' `robust'
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
	syntax anything [if] [in] [, vce(string) hc3 ll robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', vce(`vce') `hc3' `ll' `robust'
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

use DatLMW, clear

matrix F = J(8,4,.)
matrix B = J(11,2,.)

global i = 1
global j = 1

*Table 1
mycmd (sorting) reg percshared sorting , hc3
mycmd (sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, hc3
mycmd (sorting) tobit percshared sorting , ll vce(jackknife)
mycmd (sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll vce(jackknife)	
mycmd (sorting) probit percshared sorting , robust
mycmd (sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, robust

*Table 2
mycmd (sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, hc3
mycmd (sorting) reg percshared sorting , hc3

mata Y = st_data(.,"sorting")
generate Order = _n
generate double U = .

mata ResF = J($reps,8,.); ResD = J($reps,8,.); ResDF = J($reps,8,.); ResB = J($reps,11,.); ResSE = J($reps,11,.)
forvalues c = 1/$reps {
	matrix FF = J(8,3,.)
	matrix BB = J(11,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort U 
	mata st_store(.,"sorting",Y)
	quietly replace sortBarcelona = sorting*Barcelona

global i = 1
global j = 1

*Table 1
mycmd1 (sorting) reg percshared sorting , hc3
mycmd1 (sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, hc3
mycmd1 (sorting) tobit percshared sorting , ll vce(jackknife)
mycmd1 (sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll vce(jackknife)	
mycmd1 (sorting) probit percshared sorting , robust
mycmd1 (sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, robust

*Table 2
mycmd1 (sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, hc3
mycmd1 (sorting) reg percshared sorting , hc3

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..8] = FF[.,1]'; ResD[`c',1..8] = FF[.,2]'; ResDF[`c',1..8] = FF[.,3]'
mata ResB[`c',1..11] = BB[.,1]'; ResSE[`c',1..11] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/8 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/11 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\FisherLMW, replace


