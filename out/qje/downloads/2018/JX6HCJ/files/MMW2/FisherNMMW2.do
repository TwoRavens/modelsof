
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" == "") {
		quietly `anything' `if' `in', `robust'
		}
	else {
		quietly `anything' `if' `in', `robust' absorb(`absorb')
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
	syntax anything [if] [in] [, robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" == "") {
		quietly `anything' `if' `in', `robust'
		}
	else {
		quietly `anything' `if' `in', `robust' absorb(`absorb')
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


use DatMMW2, clear

matrix F = J(7,4,.)
matrix B = J(18,2,.)

global i = 1
global j = 1

*Table 2 
mycmd (treat1 treat2 treat3 treat4) reg tookup treat1 treat2 treat3 treat4, robust
mycmd (treat1 treat2 treat3 treat4) areg tookup treat1 treat2 treat3 treat4, robust absorb(strata)

*Table 3
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust

sort strata sheno
generate Order = _n
generate double U = .
mata Y = st_data(.,("treat1","treat2","treat3","treat4","treatgroup"))

mata ResF = J($reps,7,.); ResD = J($reps,7,.); ResDF = J($reps,7,.); ResB = J($reps,18,.); ResSE = J($reps,18,.)
forvalues c = 1/$reps {
	matrix FF = J(7,3,.)
	matrix BB = J(18,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort strata U 
	mata st_store(.,("treat1","treat2","treat3","treat4","treatgroup"),Y)

global i = 1
global j = 1

*Table 2 
mycmd1 (treat1 treat2 treat3 treat4) reg tookup treat1 treat2 treat3 treat4, robust
mycmd1 (treat1 treat2 treat3 treat4) areg tookup treat1 treat2 treat3 treat4, robust absorb(strata)

*Table 3
mycmd1 (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd1 (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd1 (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd1 (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd1 (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..7] = FF[.,1]'; ResD[`c',1..7] = FF[.,2]'; ResDF[`c',1..7] = FF[.,3]'
mata ResB[`c',1..18] = BB[.,1]'; ResSE[`c',1..18] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/7 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/18 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherMMW2, replace



