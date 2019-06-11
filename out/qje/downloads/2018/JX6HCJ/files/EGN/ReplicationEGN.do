
*Need Excel file provided by Nikos Nikiforakis with session indicators.  Then transform into stata file indicated below.

use "Erkal_etal_data AER 2011.dta", clear

*Table 3
probit send  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law  t2 age commerce arts science year_of_study time_in_australia if treatment<3, cluster ( subject)
reg send_ij myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law t2 age commerce arts science year_of_study time_in_australia if treatment<3&send_ij>0, cluster ( subject)
*Remaining in table are side-by-side

*Table 6
probit send  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male t4 age commerce law arts science year_of_study time_in_australia if treatment>2, cluster ( subject)
reg send_ij  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male t4 age commerce law arts science year_of_study time_in_australia if treatment>2&send_ij>0, cluster ( subject)
*Remaining in table are side-by-side

*Table 7
bysort subject: gen n = _n
reg wordspermin t2 t3 t4 male age commerce law arts science year_of_study time_in_australia if n == 1

*Table 8 (these coefficients not reported) - so don't analyze this equation
tobit send_ij stage1earning male t2 t3 t4 age commerce law arts science year_of_study time_in_australia, ll(0) vce(cluster subject)
*Remaining in table are side-by-side

save DatEGN, replace



