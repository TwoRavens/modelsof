
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', 
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

generate Order = _n
generate double U = .
mata Y = st_data(.,("treatment","size","ask","ratio","ratio2","ratio3","size25","size50","size100","askd2","askd3"))

mata ResF = J($reps,46,.); ResD = J($reps,46,.); ResDF = J($reps,46,.); ResB = J($reps,156,.); ResSE = J($reps,156,.)
forvalues c = 1/$reps {
	matrix FF = J(46,3,.)
	matrix BB = J(156,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort U 
	mata st_store(.,("treatment","size","ask","ratio","ratio2","ratio3","size25","size50","size100","askd2","askd3"),Y)

	foreach j in nonlit cases red0 {
		quietly replace T_`j' = treatment * `j'
		}
	foreach j in year5 hpa pwhite pblack page18_39 ave_hh_sz psch_atlstba powner red0 medinc_adj {
		quietly replace t_`j' = treatment * `j'
		}
	quietly replace t_poppropurban = treatment*pop_propurban

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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..46] = FF[.,1]'; ResD[`c',1..46] = FF[.,2]'; ResDF[`c',1..46] = FF[.,3]'
mata ResB[`c',1..156] = BB[.,1]'; ResSE[`c',1..156] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/46 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/156 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherKL, replace


