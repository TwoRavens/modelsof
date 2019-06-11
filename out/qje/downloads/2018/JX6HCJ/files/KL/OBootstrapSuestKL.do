
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ]
	if ($i == 0) {
		global M = ""
		global test = ""
		estimates clear
		capture drop xxx*
		matrix B = J(1,100,.)
		global j = 0
		}
	global i = $i + 1

	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	local newtestvars = ""
	foreach var in `testvars' {
		quietly gen xxx`var'$i = `var'
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in'
	if (_rc == 0) {
		estimates store M$i
		foreach var in `newtestvars' {
			global j = $j + 1
			matrix B[1,$j] = _b[`var']
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatKL, clear

*TABLE 3 
global i = 0
mycmd (treatment) probit amount treatment
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
mycmd (treatment) probit amount treatment if dormant==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
mycmd (treatment) probit amount treatment if dormant==0
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0

suest $M, robust
test $test
matrix F = r(p), r(drop), r(df), r(chi2), 3
matrix B3 = B[1,1..$j]

*TABLE 4
global i = 0
mycmd (treatment) reg amount treatment
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
mycmd (treatment) reg amount treatment if dormant==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
mycmd (treatment) reg amount treatment if dormant==0
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0
mycmd (treatment) reg amountchange treatment
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
mycmd (treatment) reg amount treatment if gave==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1
mycmd (treatment) reg amount treatment if dormant==1 & gave==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1 & gave==1
mycmd (treatment) reg amount treatment if dormant==0 & gave==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0 & gave==1
mycmd (treatment) reg amountchange treatment if gave==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1

suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)
matrix B4 = B[1,1..$j]

*Table 5 
global i = 0
matrix X = (0, 0.4, 0.45, 0.475, 0.5, 0.525, 0.55, 0.6, 1)
forvalues i = 1/8 {
	mycmd (treatment) reg gave treatment if perbush >=X[1,`i'] & perbush<X[1,`i'+1]
	}
mycmd (treatment) probit gave treatment if redcty==1 & red0==1
mycmd (treatment) probit gave treatment if bluecty==1 & red0==1
mycmd (treatment) probit gave treatment if redcty==1 & blue0==1
mycmd (treatment) probit gave treatment if bluecty==1 & blue0==1
mycmd (treatment T_red0 T_nonlit) probit gave treatment T_red0 T_nonlit red0 nonlit 
mycmd (treatment T_red0 T_cases) probit gave treatment T_red0 T_cases red0 cases 
mycmd (treatment T_red0 T_nonlit T_cases) probit gave treatment T_red0 T_nonlit T_cases red0 nonlit cases 

suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)
matrix B5 = B[1,1..$j]

*TABLE 6 
global i = 0
mycmd (treatment t_red0 t_year5 t_hpa) probit gave treatment t_red0 t_year5 t_hpa red0 year5 hpa 
mycmd (treatment t_red0 t_pwhite) probit gave treatment t_red0 t_pwhite red0 pwhite 
mycmd (treatment t_red0 t_pblack) probit gave treatment t_red0 t_pblack red0 pblack 
mycmd (treatment t_red0 t_page18_39) probit gave treatment t_red0 t_page18_39 red0 page18_39 
mycmd (treatment t_red0 t_ave_hh_sz) probit gave treatment t_red0 t_ave_hh_sz red0 ave_hh_sz 
mycmd (treatment t_red0 t_medinc_adj) probit gave treatment t_red0 t_medinc_adj red0 medinc_adj 
mycmd (treatment t_red0 t_powner) probit gave treatment t_red0 t_powner red0 powner 
mycmd (treatment t_red0 t_psch_atlstba) probit gave treatment t_red0 t_psch_atlstba red0 psch_atlstba 
mycmd (treatment t_red0 t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban) probit gave treatment t_red0 t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban red0 pwhite pblack page18_39 ave_hh_sz medinc_adj powner psch_atlstba pop_propurban 

suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)
matrix B6 = B[1,1..$j]

gen N = _n
sort N
save aa, replace

egen NN = max(N)
keep NN
save aaa, replace

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa

*TABLE 3 
global i = 0
mycmd (treatment) probit amount treatment
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
mycmd (treatment) probit amount treatment if dormant==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
mycmd (treatment) probit amount treatment if dormant==0
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}

*TABLE 4
global i = 0
mycmd (treatment) reg amount treatment
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
mycmd (treatment) reg amount treatment if dormant==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
mycmd (treatment) reg amount treatment if dormant==0
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0
mycmd (treatment) reg amountchange treatment
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
mycmd (treatment) reg amount treatment if gave==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1
mycmd (treatment) reg amount treatment if dormant==1 & gave==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1 & gave==1
mycmd (treatment) reg amount treatment if dormant==0 & gave==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0 & gave==1
mycmd (treatment) reg amountchange treatment if gave==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
		}
	}

*Table 5 
global i = 0
matrix X = (0, 0.4, 0.45, 0.475, 0.5, 0.525, 0.55, 0.6, 1)
forvalues i = 1/8 {
	mycmd (treatment) reg gave treatment if perbush >=X[1,`i'] & perbush<X[1,`i'+1]
	}
mycmd (treatment) probit gave treatment if redcty==1 & red0==1
mycmd (treatment) probit gave treatment if bluecty==1 & red0==1
mycmd (treatment) probit gave treatment if redcty==1 & blue0==1
mycmd (treatment) probit gave treatment if bluecty==1 & blue0==1
mycmd (treatment T_red0 T_nonlit) probit gave treatment T_red0 T_nonlit red0 nonlit 
mycmd (treatment T_red0 T_cases) probit gave treatment T_red0 T_cases red0 cases 
mycmd (treatment T_red0 T_nonlit T_cases) probit gave treatment T_red0 T_nonlit T_cases red0 nonlit cases 

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
		}
	}

*TABLE 6 
global i = 0
mycmd (treatment t_red0 t_year5 t_hpa) probit gave treatment t_red0 t_year5 t_hpa red0 year5 hpa 
mycmd (treatment t_red0 t_pwhite) probit gave treatment t_red0 t_pwhite red0 pwhite 
mycmd (treatment t_red0 t_pblack) probit gave treatment t_red0 t_pblack red0 pblack 
mycmd (treatment t_red0 t_page18_39) probit gave treatment t_red0 t_page18_39 red0 page18_39 
mycmd (treatment t_red0 t_ave_hh_sz) probit gave treatment t_red0 t_ave_hh_sz red0 ave_hh_sz 
mycmd (treatment t_red0 t_medinc_adj) probit gave treatment t_red0 t_medinc_adj red0 medinc_adj 
mycmd (treatment t_red0 t_powner) probit gave treatment t_red0 t_powner red0 powner 
mycmd (treatment t_red0 t_psch_atlstba) probit gave treatment t_red0 t_psch_atlstba red0 psch_atlstba 
mycmd (treatment t_red0 t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban) probit gave treatment t_red0 t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban red0 pwhite pblack page18_39 ave_hh_sz medinc_adj powner psch_atlstba pop_propurban 

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B6)*invsym(V)*(B[1,1..$j]-B6)'
		mata test = st_matrix("test"); ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', test[1,1], 6)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/20 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save results\OBootstrapSuestKL, replace

erase aa.dta
erase aaa.dta

