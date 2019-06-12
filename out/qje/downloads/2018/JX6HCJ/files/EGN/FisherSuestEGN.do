

use DatEGN, clear

*Table 3

global i = 1

probit send  t2  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3, 
	estimates store M$i
	global i = $i + 1

reg send_ij t2 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3 & send_ij>0, 
	estimates store M$i
	global i = $i + 1

suest M1 M2, cluster(subject)
test t2 
matrix F = (r(p), r(drop), r(df), r(chi2), 3)


*Table 6

global i = 1

probit send t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2, 
	estimates store M$i
	global i = $i + 1

reg send_ij t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2 & send_ij>0, 
	estimates store M$i
	global i = $i + 1

suest M1 M2, cluster(subject)
test t4 
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

*Table 7

global i = 1

reg wordspermin t2 t3 t4 male age commerce law arts science year_of_study time_in_australia if n == 1
	estimates store M$i
	global i = $i + 1
suest M1, cluster(subject)
test t2 t3 t4 
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

bysort subject: gen NN = _n
sort NN subject
sum NN if NN == 1
global N = r(N)
mata Y = st_data((1,$N),("t2","t3","t4","treatment"))
generate Order = _n
generate double U = .

mata ResF = J($reps,15,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("t2","t3","t4","treatment"),Y)
	sort subject NN
	foreach j in t2 t3 t4 treatment {
		quietly replace `j' = `j'[_n-1] if NN > 1
		}

*Table 3

global i = 1

capture probit send  t2  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3, 
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture reg send_ij t2 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3 & send_ij>0, 
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture suest M1 M2, cluster(subject)
if (_rc == 0) {
	capture test t2
	if (_rc == 0) { 
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}

*Table 6

global i = 1

capture probit send t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2, 
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture reg send_ij t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2 & send_ij>0, 
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture suest M1 M2, cluster(subject)
if (_rc == 0) {
	capture test t4
	if (_rc == 0) { 
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
		}
	}

*Table 7

global i = 1

capture reg wordspermin t2 t3 t4 male age commerce law arts science year_of_study time_in_australia if n == 1
	if (_rc == 0) estimates store M$i
	global i = $i + 1
capture suest M1, cluster(subject)
if (_rc == 0) {
	capture test t2 t3 t4 
	if (_rc == 0) { 
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 7)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/15 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save results\FisherSuestEGN, replace







