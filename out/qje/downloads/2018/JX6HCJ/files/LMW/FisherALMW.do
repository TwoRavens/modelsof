
*randomizing at treatment level


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ll]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', `ll' cluster(`cluster')
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
	syntax anything [if] [in] [, cluster(string) ll]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', `ll' cluster(`cluster')
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
mycmd (sorting) reg percshared sorting , cluster(session)
mycmd (sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, cluster(session)
mycmd (sorting) tobit percshared sorting , ll cluster(session)
mycmd (sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll cluster(session)	
mycmd (sorting) probit percshared sorting , cluster(session)
mycmd (sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, cluster(session)

*Table 2
mycmd (sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, cluster(session)
mycmd (sorting) reg percshared sorting , cluster(session)

egen Strata = group(schoolBerkeley schoolUPF)
egen Session = group(session)
bys Session: gen N = _n
sort N Strata Session
global N = 16
mata Y = st_data((1,$N),"sorting")
generate Order = _n
generate double U = .

mata ResF = J($reps,8,.); ResD = J($reps,8,.); ResDF = J($reps,8,.); ResB = J($reps,11,.); ResSE = J($reps,11,.)
forvalues c = 1/$reps {
	matrix FF = J(8,3,.)
	matrix BB = J(11,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Strata U in 1/$N
	mata st_store((1,$N),"sorting",Y)
	sort Session N
	quietly replace sorting = sorting[_n-1] if Session == Session[_n-1] 
	quietly replace sortBarcelona = sorting*Barcelona

global i = 1
global j = 1

*Table 1
mycmd1 (sorting) reg percshared sorting , cluster(session)
mycmd1 (sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, cluster(session)
mycmd1 (sorting) tobit percshared sorting , ll cluster(session)
mycmd1 (sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll cluster(session)	
mycmd1 (sorting) probit percshared sorting , cluster(session)
mycmd1 (sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, cluster(session)

*Table 2
mycmd1 (sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, cluster(session)
mycmd1 (sorting) reg percshared sorting , cluster(session)

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
save results\FisherALMW, replace


