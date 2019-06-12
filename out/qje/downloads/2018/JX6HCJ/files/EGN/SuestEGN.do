
****************************************
****************************************

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

drop _all
svmat double F
save results/SuestEGN, replace



