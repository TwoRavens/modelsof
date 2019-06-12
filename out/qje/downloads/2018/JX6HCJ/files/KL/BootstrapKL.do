
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', `robust'
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			bsample if `touse' 
			capture `anything', `robust'
			if (_rc == 0) {
			capture mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); B = B[1,1..$k]; V = V[1..$k,1..$k]
			capture testparm `testvars'
			if (_rc == 0 & r(df) == $k) {
				mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1])
				if (e(df_r) == .) mata ResF[`i',1..3] = `r(p)', chi2tail($k,t[1,1]), $k - `r(df)'
				if (e(df_r) ~= .) mata ResF[`i',1...] = `r(p)', Ftail($k,`e(df_r)',t[1,1]/$k), $k - `r(df)', `e(df_r)'
				mata ResB[`i',1...] = B; ResSE[`i',1...] = sqrt(diagonal(V))'
				}
				}
		restore
		}
	preserve
		quietly drop _all
		quietly set obs $reps
		quietly generate double ResF$i = .
		quietly generate double ResFF$i = .
		quietly generate double ResD$i = .
		quietly generate double ResDF$i = .
		global kk = $j + $k - 1
		forvalues i = $j/$kk {
			quietly generate double ResB`i' = .
			}
		forvalues i = $j/$kk {
			quietly generate double ResSE`i' = .
			}
		mata X = ResF, ResB, ResSE; st_store(.,.,X)
		quietly svmat double B
		quietly rename B2 SE$i
		capture rename B1 B$i
		save ip\BS$i, replace
		global i = $i + 1
		global j = $j + $k
	restore
end


*******************

global cluster = ""

use DatKL, clear

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

use ip\BS1, clear
forvalues i = 2/46 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/46 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapKL, replace

