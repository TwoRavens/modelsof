


use DatKL, clear

*TABLE 3 

global i = 1

quietly probit amount treatment
	estimates store M$i
	global i = $i + 1

quietly probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
	estimates store M$i
	global i = $i + 1

quietly probit amount treatment if dormant==1
	estimates store M$i
	global i = $i + 1

quietly probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
	estimates store M$i
	global i = $i + 1

quietly probit amount treatment if dormant==0
	estimates store M$i
	global i = $i + 1

quietly probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3 M4 M5 M6, robust
test treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
matrix F = (r(p), r(drop), r(df), r(chi2), 3)


*TABLE 4

global i = 1

quietly reg amount treatment
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment if dormant==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment if dormant==0
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0
	estimates store M$i
	global i = $i + 1

quietly reg amountchange treatment
	estimates store M$i
	global i = $i + 1

quietly reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment if gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment if dormant==1 & gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1 & gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment if dormant==0 & gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0 & gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amountchange treatment if gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16, robust
test treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)


*Table 5 

global i = 1

matrix X = (0, 0.4, 0.45, 0.475, 0.5, 0.525, 0.55, 0.6, 1)
forvalues i = 1/8 {
	quietly reg gave treatment if perbush >=X[1,`i'] & perbush<X[1,`i'+1]
	estimates store M$i
	global i = $i + 1
	}
quietly probit gave treatment if redcty==1 & red0==1
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment if bluecty==1 & red0==1
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment if redcty==1 & blue0==1
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment if bluecty==1 & blue0==1
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment T_red0 T_nonlit red0 nonlit 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment T_red0 T_cases red0 cases 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment T_red0 T_nonlit T_cases red0 nonlit cases 
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15, robust
test treatment T_red0 T_nonlit T_cases
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)


*TABLE 6 

global i = 1

quietly probit gave treatment t_red0 t_year5 t_hpa red0 year5 hpa 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_pwhite red0 pwhite 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_pblack red0 pblack 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_page18_39 red0 page18_39 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_ave_hh_sz red0 ave_hh_sz 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_medinc_adj red0 medinc_adj 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_powner red0 powner 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_psch_atlstba red0 psch_atlstba 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban red0 pwhite pblack page18_39 ave_hh_sz medinc_adj powner psch_atlstba pop_propurban 
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3 M4 M5 M6 M7 M8 M9, robust
test treatment t_red0 t_year5 t_hpa t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)


generate Order = _n
generate double U = .
mata Y = st_data(.,("treatment","size","ask","ratio","ratio2","ratio3","size25","size50","size100","askd2","askd3"))

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
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

*TABLE 3 

global i = 1

quietly probit amount treatment
	estimates store M$i
	global i = $i + 1

quietly probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
	estimates store M$i
	global i = $i + 1

quietly probit amount treatment if dormant==1
	estimates store M$i
	global i = $i + 1

quietly probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
	estimates store M$i
	global i = $i + 1

quietly probit amount treatment if dormant==0
	estimates store M$i
	global i = $i + 1

quietly probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4 M5 M6, robust
if (_rc == 0) {
	capture test treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}
	

*TABLE 4

global i = 1

quietly reg amount treatment
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment if dormant==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment if dormant==0
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0
	estimates store M$i
	global i = $i + 1

quietly reg amountchange treatment
	estimates store M$i
	global i = $i + 1

quietly reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment if gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment if dormant==1 & gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1 & gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment if dormant==0 & gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0 & gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amountchange treatment if gave==1
	estimates store M$i
	global i = $i + 1

quietly reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16, robust
if (_rc == 0) {
	capture test treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}


*Table 5 

global i = 1

matrix X = (0, 0.4, 0.45, 0.475, 0.5, 0.525, 0.55, 0.6, 1)
forvalues i = 1/8 {
	quietly reg gave treatment if perbush >=X[1,`i'] & perbush<X[1,`i'+1]
	estimates store M$i
	global i = $i + 1
	}
quietly probit gave treatment if redcty==1 & red0==1
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment if bluecty==1 & red0==1
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment if redcty==1 & blue0==1
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment if bluecty==1 & blue0==1
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment T_red0 T_nonlit red0 nonlit 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment T_red0 T_cases red0 cases 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment T_red0 T_nonlit T_cases red0 nonlit cases 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15, robust
if (_rc == 0) {
	capture test treatment T_red0 T_nonlit T_cases
		if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
		}
	}


*TABLE 6 

global i = 1

quietly probit gave treatment t_red0 t_year5 t_hpa red0 year5 hpa 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_pwhite red0 pwhite 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_pblack red0 pblack 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_page18_39 red0 page18_39 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_ave_hh_sz red0 ave_hh_sz 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_medinc_adj red0 medinc_adj 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_powner red0 powner 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_psch_atlstba red0 psch_atlstba 
	estimates store M$i
	global i = $i + 1

quietly probit gave treatment t_red0 t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban red0 pwhite pblack page18_39 ave_hh_sz medinc_adj powner psch_atlstba pop_propurban 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4 M5 M6 M7 M8 M9, robust
if (_rc == 0) {
	capture test treatment t_red0 t_year5 t_hpa t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban
	if (_rc == 0) {
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
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
sort N
save results\FisherSuestKL, replace


