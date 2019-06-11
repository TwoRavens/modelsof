
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', 
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

use DatKL, clear

matrix F = J(46,4,.)
matrix B = J(156,2,.)

global i = 1
global j = 1

*TABLE 3 
mycmd (treatment) probit amount treatment
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
mycmd (treatment) probit amount treatment if dormant==1
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
mycmd (treatment) probit amount treatment if dormant==0
mycmd (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0

*TABLE 4
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

*TABLE 5 
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

*TABLE 6 
mycmd (treatment t_red0 t_year5 t_hpa) probit gave treatment t_red0 t_year5 t_hpa red0 year5 hpa 
mycmd (treatment t_red0 t_pwhite) probit gave treatment t_red0 t_pwhite red0 pwhite 
mycmd (treatment t_red0 t_pblack) probit gave treatment t_red0 t_pblack red0 pblack 
mycmd (treatment t_red0 t_page18_39) probit gave treatment t_red0 t_page18_39 red0 page18_39 
mycmd (treatment t_red0 t_ave_hh_sz) probit gave treatment t_red0 t_ave_hh_sz red0 ave_hh_sz 
mycmd (treatment t_red0 t_medinc_adj) probit gave treatment t_red0 t_medinc_adj red0 medinc_adj 
mycmd (treatment t_red0 t_powner) probit gave treatment t_red0 t_powner red0 powner 
mycmd (treatment t_red0 t_psch_atlstba) probit gave treatment t_red0 t_psch_atlstba red0 psch_atlstba 
mycmd (treatment t_red0 t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban) probit gave treatment t_red0 t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban red0 pwhite pblack page18_39 ave_hh_sz medinc_adj powner psch_atlstba pop_propurban 

generate Order = _n

global i = 0

*TABLE 3 
global i = $i + 1
randcmdc ((treatment) probit amount treatment), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach var in treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 {
	global i = $i + 1
	local a = "treatment ratio2 ratio3 size25 size50 size100 askd2 askd3"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

global i = $i + 1
randcmdc ((treatment) probit amount treatment if dormant==1), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach var in treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 {
	global i = $i + 1
	local a = "treatment ratio2 ratio3 size25 size50 size100 askd2 askd3"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

global i = $i + 1
randcmdc ((treatment) probit amount treatment if dormant==0), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach var in treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 {
	global i = $i + 1
	local a = "treatment ratio2 ratio3 size25 size50 size100 askd2 askd3"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*TABLE 4
global i = $i + 1
randcmdc ((treatment) reg amount treatment), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach var in treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 {
	global i = $i + 1
	local a = "treatment ratio2 ratio3 size25 size50 size100 askd2 askd3"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

global i = $i + 1
randcmdc ((treatment) reg amount treatment if dormant==1), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach var in treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 {
	global i = $i + 1
	local a = "treatment ratio2 ratio3 size25 size50 size100 askd2 askd3"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

global i = $i + 1
randcmdc ((treatment) reg amount treatment if dormant==0), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach var in treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 {
	global i = $i + 1
	local a = "treatment ratio2 ratio3 size25 size50 size100 askd2 askd3"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

global i = $i + 1
randcmdc ((treatment) reg amountchange treatment), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach var in treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 {
	global i = $i + 1
	local a = "treatment ratio2 ratio3 size25 size50 size100 askd2 askd3"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

global i = $i + 1
randcmdc ((treatment) reg amount treatment if gave==1), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach var in treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 {
	global i = $i + 1
	local a = "treatment ratio2 ratio3 size25 size50 size100 askd2 askd3"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

global i = $i + 1
randcmdc ((treatment) reg amount treatment if dormant==1 & gave==1), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach var in treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 {
	global i = $i + 1
	local a = "treatment ratio2 ratio3 size25 size50 size100 askd2 askd3"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1 & gave==1), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

global i = $i + 1
randcmdc ((treatment) reg amount treatment if dormant==0 & gave==1), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach var in treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 {
	global i = $i + 1
	local a = "treatment ratio2 ratio3 size25 size50 size100 askd2 askd3"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0 & gave==1), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

global i = $i + 1
randcmdc ((treatment) reg amountchange treatment if gave==1), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach var in treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 {
	global i = $i + 1
	local a = "treatment ratio2 ratio3 size25 size50 size100 askd2 askd3"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*TABLE 5 
matrix X = (0, 0.4, 0.45, 0.475, 0.5, 0.525, 0.55, 0.6, 1)
forvalues i = 1/8 {
	global i = $i + 1
	randcmdc ((treatment) reg gave treatment if perbush >=X[1,`i'] & perbush<X[1,`i'+1]), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

global i = $i + 1
randcmdc ((treatment) probit gave treatment if redcty==1 & red0==1), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

global i = $i + 1
randcmdc ((treatment) probit gave treatment if bluecty==1 & red0==1), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

global i = $i + 1
randcmdc ((treatment) probit gave treatment if redcty==1 & blue0==1), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 

global i = $i + 1
randcmdc ((treatment) probit gave treatment if bluecty==1 & blue0==1), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample 


forvalues j = 1/45 {
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
save results\FisherCondKL, replace





