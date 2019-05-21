clear 
import delimited "01_data/cleaned_data/did_fullyear.csv"

gen post_appalplayz = post * appalplayz

label var post_appalplayz "Shale*Post-boom"
label var appalplayz "Shale"
label var post "Post-boom"
label var rep2004 "Rep. in 2004"

keep if appalrdplayincludebw1 == 1

eststo clear /* Note that you need to install the estout package via ssc install estout, replace */
eststo: logit pro_env appalplayz post post_appalplayz [pw=observed_propensity], cluster(distid)

esttab using "02_tables/table_A13_logit_results.tex", replace f ///
	booktabs b(3) se(3) eqlabels(none) alignment(C C) collabels(none) mtitles ("")  ///
	keep(appalplayz post post_appalplayz) order(appalplayz post post_appalplayz) nonum nodepvars cells("b(fmt(3)star)" "se(fmt(3)par)") label star(* 0.10 ** 0.05 *** 0.01) pr2
