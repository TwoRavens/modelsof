* Set working directory
cd "..."

import excel "Simulation Results.xlsx", sheet("Sheet1") firstrow clear

g min95_linear_dummy = linear_iv_dummy_est - 1.96 * linear_iv_dummy_se
g max95_linear_dummy = linear_iv_dummy_est + 1.96 * linear_iv_dummy_se

g min95_linear_lapte = linear_iv_lapte_est - 1.96 * linear_iv_lapte_se
g max95_linear_lapte = linear_iv_lapte_est + 1.96 * linear_iv_lapte_se

g min95_discon_dummy = discon_iv_dummy_est - 1.96 * discon_iv_dummy_se
g max95_discon_dummy = discon_iv_dummy_est + 1.96 * discon_iv_dummy_se

g min95_discon_lapte = discon_iv_lapte_est - 1.96 * discon_iv_lapte_se
g max95_discon_lapte = discon_iv_lapte_est + 1.96 * discon_iv_lapte_se

g min95_discon_dummy_inc = discon_iv_dummy_inc_est - 1.96 * discon_iv_dummy_inc_se
g max95_discon_dummy_inc = discon_iv_dummy_inc_est + 1.96 * discon_iv_dummy_inc_se

twoway (scatter linear_iv_dummy_est poverp, mcolor(black)) ///
  (rcap min95_linear_dummy max95_linear_dummy poverp, vertical lcolor(black)), ///
  legend(off) graphregion(fcolor(white) lcolor(white)) xlab(0(1)5, valuelabel nogrid) ylab(, nogrid) yline(0.05, lcolor(black) lpattern(dash)) ///
  xtitle("{&Sigma}{sub:t{&ne}k}p{sub:t} / p{sub:k}", size(large)) ytitle("Coarsened estimate", size(medlarge))

twoway (scatter linear_iv_lapte_est poverp, mcolor(black)) ///
  (rcap min95_linear_lapte max95_linear_lapte poverp, vertical lcolor(black)), ///
  legend(off) graphregion(fcolor(white) lcolor(white)) xlab(0(1)5, valuelabel nogrid) ylab(, nogrid) yline(0.05, lcolor(black) lpattern(dash)) ///
  xtitle("{&Sigma}{sub:t{&ne}k}p{sub:t} / p{sub:k}", size(large)) ytitle("LAPTE estimate", size(medlarge))

twoway (scatter discon_iv_dummy_est poverp, mcolor(black)) ///
  (rcap min95_discon_dummy max95_discon_dummy poverp, vertical lcolor(black)), ///
  legend(off) graphregion(fcolor(white) lcolor(white)) xlab(0(1)5, valuelabel nogrid) ylab(, nogrid) yline(0.05, lcolor(black) lpattern(dash)) ///
  xtitle("{&Sigma}{sub:t{&ne}k}p{sub:t} / p{sub:k}", size(large)) ytitle("Coarsened estimate", size(medlarge))

twoway (scatter discon_iv_lapte_est poverp, mcolor(black)) ///
  (rcap min95_discon_lapte max95_discon_lapte poverp, vertical lcolor(black)), ///
  legend(off) graphregion(fcolor(white) lcolor(white)) xlab(0(1)5, valuelabel nogrid) ylab(, nogrid) yline(0.05, lcolor(black) lpattern(dash)) ///
  xtitle("{&Sigma}{sub:t{&ne}k}p{sub:t} / p{sub:k}", size(large)) ytitle("LAPTE estimate", size(medlarge))

twoway (scatter discon_iv_dummy_inc_est poverp2, mcolor(black)) ///
  (rcap min95_discon_dummy_inc max95_discon_dummy_inc poverp2, vertical lcolor(black)), ///
  legend(off) graphregion(fcolor(white) lcolor(white)) xlab(3(1)8, valuelabel nogrid) ylab(, nogrid) yline(0, lcolor(black) lpattern(dash)) ///
  xtitle("{&Sigma}{sub:t{&ne}k}p{sub:t} / p{sub:k}", size(large)) ytitle("Coarsened estimate", size(medlarge))
