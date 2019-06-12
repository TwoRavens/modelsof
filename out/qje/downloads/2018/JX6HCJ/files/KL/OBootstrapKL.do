
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [,  ]
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			matrix V = V[1..$k,1..$k]
			matrix b = b[1,1..$k]
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) capture matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) capture matrix FF[$i,4] = chi2tail($k,f[1,1])
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

global a = 46
global b = 156

use DatKL, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

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

*Table 5 
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

gen N = _n
sort N
save aa, replace

egen NN = max(N)
keep NN
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

*TABLE 3 
mycmd1 (treatment) probit amount treatment
mycmd1 (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
mycmd1 (treatment) probit amount treatment if dormant==1
mycmd1 (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
mycmd1 (treatment) probit amount treatment if dormant==0
mycmd1 (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0

*TABLE 4
mycmd1 (treatment) reg amount treatment
mycmd1 (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
mycmd1 (treatment) reg amount treatment if dormant==1
mycmd1 (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
mycmd1 (treatment) reg amount treatment if dormant==0
mycmd1 (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0
mycmd1 (treatment) reg amountchange treatment
mycmd1 (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
mycmd1 (treatment) reg amount treatment if gave==1
mycmd1 (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1
mycmd1 (treatment) reg amount treatment if dormant==1 & gave==1
mycmd1 (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1 & gave==1
mycmd1 (treatment) reg amount treatment if dormant==0 & gave==1
mycmd1 (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0 & gave==1
mycmd1 (treatment) reg amountchange treatment if gave==1
mycmd1 (treatment ratio2 ratio3 size25 size50 size100 askd2 askd3) reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1

*Table 5 
matrix X = (0, 0.4, 0.45, 0.475, 0.5, 0.525, 0.55, 0.6, 1)
forvalues i = 1/8 {
	mycmd1 (treatment) reg gave treatment if perbush >=X[1,`i'] & perbush<X[1,`i'+1]
	}
mycmd1 (treatment) probit gave treatment if redcty==1 & red0==1
mycmd1 (treatment) probit gave treatment if bluecty==1 & red0==1
mycmd1 (treatment) probit gave treatment if redcty==1 & blue0==1
mycmd1 (treatment) probit gave treatment if bluecty==1 & blue0==1
mycmd1 (treatment T_red0 T_nonlit) probit gave treatment T_red0 T_nonlit red0 nonlit 
mycmd1 (treatment T_red0 T_cases) probit gave treatment T_red0 T_cases red0 cases 
mycmd1 (treatment T_red0 T_nonlit T_cases) probit gave treatment T_red0 T_nonlit T_cases red0 nonlit cases 

*TABLE 6 
mycmd1 (treatment t_red0 t_year5 t_hpa) probit gave treatment t_red0 t_year5 t_hpa red0 year5 hpa 
mycmd1 (treatment t_red0 t_pwhite) probit gave treatment t_red0 t_pwhite red0 pwhite 
mycmd1 (treatment t_red0 t_pblack) probit gave treatment t_red0 t_pblack red0 pblack 
mycmd1 (treatment t_red0 t_page18_39) probit gave treatment t_red0 t_page18_39 red0 page18_39 
mycmd1 (treatment t_red0 t_ave_hh_sz) probit gave treatment t_red0 t_ave_hh_sz red0 ave_hh_sz 
mycmd1 (treatment t_red0 t_medinc_adj) probit gave treatment t_red0 t_medinc_adj red0 medinc_adj 
mycmd1 (treatment t_red0 t_powner) probit gave treatment t_red0 t_powner red0 powner 
mycmd1 (treatment t_red0 t_psch_atlstba) probit gave treatment t_red0 t_psch_atlstba red0 psch_atlstba 
mycmd1 (treatment t_red0 t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban) probit gave treatment t_red0 t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban red0 pwhite pblack page18_39 ave_hh_sz medinc_adj powner psch_atlstba pop_propurban 

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
save results\OBootstrapKL, replace

erase aa.dta
erase aaa.dta

