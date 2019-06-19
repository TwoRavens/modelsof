
clear *
set more off

* Please insert here the path of the folder where you put the do-file and the ready-to-use-data.dta
cap: cd "C:\Users\rtruglia\Dropbox\Economist\Papers\Conformity and geographic polarization\FINAL Submission ReStat\Data Files"

* Start by running the code below, which DEFINES the CONTROLS VARIABLES
program define define_controls
display "Defining controls"
global ind_controls male white black hispanic L_amount L_zip3_share_ind_own
global zip3_controls zip3_population zip3_share_under25yo zip3_share_college zip3_share_white zip3_share_black zip3_share_hispanic zip3_ethnic_fract zip3_irs_meaninc zip3_share_unemployed 
global county_controls county_density county_share_college county_share_white county_share_black county_share_hispanic county_mean_income county_share_unemployed county_share_school
global adj_zip3_controls 
foreach var in $zip3_controls {
global adj_zip3_controls $adj_zip3_controls adj_`var'
}
global fake_zip3_controls
global true_zip3_controls
foreach var of varlist $zip3_controls {
global fake_zip3_controls $fake_zip3_controls f_`var'
global true_zip3_controls $true_zip3_controls t_`var'
}
global fake_adj_zip3_controls
global true_adj_zip3_controls
foreach var of varlist $adj_zip3_controls {
global fake_adj_zip3_controls $fake_adj_zip3_controls f_`var'
global true_adj_zip3_controls $true_adj_zip3_controls t_`var'
}
global fake_county_controls
global true_county_controls
foreach var of varlist $county_controls {
global fake_county_controls $fake_county_controls f_`var'
global true_county_controls $true_county_controls t_`var'
}
end


** Generate Figure 1.a and Figure 1.b
use ready-to-use-data, clear
define_controls
global q=6
foreach var in f_zip3_share_ind_own t_zip3_share_ind_own zip3_share_ind_own t_adj_zip3_share_ind_own {
xtile x_`var'=`var' if `var'>0, nq($q)
replace x_`var'=0 if `var'==0
forvalues i=1(1)$q {
gen x`i'_`var'=x_`var'==`i'
}
}
global indepvars 
foreach var in f_zip3_share_ind_own t_zip3_share_ind_own t_adj_zip3_share_ind_own {
forvalues i=2(1)$q {
global indepvars $indepvars x`i'_`var'
}
}
pantob amount_poisson $indepvars after $ind_controls $true_zip3_controls $fake_zip3_controls dummies if cycle==2 & N_dummies>1, details
foreach type in f_zip3_share_ind_own t_zip3_share_ind_own t_adj_zip3_share_ind_own  {
gen p_`type'=0
gen q_`type'=.
forvalues k=1(1)$q {
cap: replace p_`type'=_b[x`k'_`type'] if _n==`k'
*sum `type' if cycle==2 & N_dummies>1 & x_`type'==`k'
sum `type' if cycle==2 & N_dummies>1 & x_`type'==`k'
replace q_`type'=`r(mean)' if _n==`k'
}
}
twoway scatter p_t_zip3_share_ind_own q_t_zip3_share_ind_own , msymbol(O) mcolor(red) || lfit p_t_zip3_share_ind_own q_t_zip3_share_ind_own , sort lcolor(red) || scatter p_f_zip3_share_ind_own q_f_zip3_share_ind_own, msymbol(s) mcolor(blue) yscale(range(-100 250)) ylabel(-100(50)300) xscale(range(0.425 0.925)) xlabel(0.5(0.1)0.9, format(%9.1f)) title("") xtitle("Share Democrat in ZIP-3 of Destination", margin(2 2 2 2)) || lfit p_f_zip3_share_ind_own q_f_zip3_share_ind_own, sort lcolor(blue) lp(dash) scheme(s1mono) ytitle("Amount Contributed in 2012 ($)", margin(2 2 2 2)) legend(order(1 "Moved Before 2012-Cycle" 3 "Moved After 2012-Cycle") cols(1) position(11) ring(0) region(lp(blank)))
graph export "figure_1_a.eps", replace
twoway scatter p_t_zip3_share_ind_own q_t_zip3_share_ind_own , msymbol(O) mcolor(red) || lfit p_t_zip3_share_ind_own q_t_zip3_share_ind_own , sort lcolor(red) || scatter p_t_adj_zip3_share_ind_own q_t_adj_zip3_share_ind_own, msymbol(D) mcolor(green) yscale(range(-100 250)) ylabel(-100(50)300) xscale(range(0.375 0.925)) xlabel(0.4(0.1)0.9, format(%9.1f)) title("") xtitle("Share Democrat in Same/Adjacent ZIP-3 of Destination", margin(2 2 2 2)) || lfit p_t_adj_zip3_share_ind_own q_t_adj_zip3_share_ind_own, sort lcolor(green) lp(dash) scheme(s1mono) ytitle("Amount Contributed in 2012 ($)", margin(2 2 2 2)) legend(order(1 "Share Democrat in Same ZIP-3" 3 "Share Democrat in Adjacent ZIP-3") cols(1) position(11) ring(0) region(lp(blank)))
graph export "figure_1_b.eps", replace

** Generate Figure 2
cap: ssc install coefplot
use ready-to-use-data, clear
define_controls
gen distance_move=.
replace distance_move=48-timemoved if timemoved>=49 & timemoved<=71
replace distance_move=25-timemoved if timemoved>=1 & timemoved<=24
gen semester=.
replace semester=4 if timemoved>=1 & timemoved<=6
replace semester=3 if timemoved>=7 & timemoved<=12
replace semester=2 if timemoved>=13 & timemoved<=18
replace semester=1 if timemoved>=19 & timemoved<=24
replace semester=-1 if timemoved>=49 & timemoved<=54
replace semester=-2 if timemoved>=55 & timemoved<=60
replace semester=-3 if timemoved>=61 & timemoved<=66
replace semester=-4 if timemoved>=67 & timemoved<=72
forvalues x=1(1)4 {
gen sem_p_`x'=t_zip3_share_ind_own*(semester==`x')
gen sem_m_`x'=f_zip3_share_ind_own*(semester==-`x')
}
qui: tab semester, gen(d_semester)
xtpoisson amount_poisson sem_p_* sem_m_* after d_semester* $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) robust
estimates store event_study
coefplot event_study, vertical keep(sem_m_4 sem_m_3 sem_m_2 sem_m_1 sem_p_1 sem_p_2 sem_p_3 sem_p_4) order(sem_m_4 sem_m_3 sem_m_2 sem_m_1 sem_p_1 sem_p_2 sem_p_3 sem_p_4) omitted baselevels level(90) ciopts(lpattern(dash) lcolor(blue) recast(rcap)) mcolor(blue) msymbol(O) graphregion(color(white)) plotregion(color(white)) ylabel(-1(.5)2, labsize(medlarge)) yline(0, lcolor(black) lwidth(medthick)) offset(0) coeflabels(sem_m_4 = "-24/-19" sem_m_3 = "-13/-18" sem_m_2 = "-7/-12" sem_m_1 = "-1/-6" sem_p_1 = "+1/+6" sem_p_2 = "+7/+12" sem_p_3 = "+13/+18" sem_p_4 = "+19/+24") legend(order(2 1) lab(2 "Point Estimate") lab(1 "90% CI") pos(11) ring(0) col(1) region(color(none))) xline(4.5, lcolor(green) lwidth(medthick) lpattern(solid)) xtitle("Months Between Election Cycle and Date of Move", size(medium) height(7)) ytitle("Effect of Share Democrat", size(medium) height(5))  recast(connected) lcolor(blue) scheme(s1mono)
graph export "figure_2.eps", replace


** Generate Table 1 and Table 2
set more off
use ready-to-use-data, clear
foreach var of varlist zip3_irs_meaninc zip3_share_college {
gen L_`var'=L.`var'
}
global vars1 female white black hispanic L_zip3_irs_meaninc L_zip3_share_college L_zip3_share_ind_own zip3_share_ind_own 
global vars2 L_some L_amount some aux_amount
define_controls
qui: xtreg some f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) cluster(dummies)
gen in_reg=e(sample)
keep if in_reg==1
gen aux_amount=amount if amount>0 & amount!=.
gen L_some=100
gen female=(1-male)*100
foreach var in white black hispanic L_zip3_share_ind_own zip3_share_ind_own L_zip3_share_college {
replace `var'=`var'*100
}
label var female "Percent Female"
label var white "Percent White"
label var black "Percent African-American"
label var hispanic "Percent Hispanic"
label var L_some "Percent Contributed >\\$200"
label var L_amount "Mean Amount (\\$), if >\\$200"
label var some "Percent Contributed >\\$200"
label var aux_amount "Mean Amount (\\$), if >\\$200"
label var L_zip3_share_ind_own "Percent Democrat (Origin)" 
label var zip3_share_ind_own "Percent Democrat (Destination)"
label var L_zip3_irs_meaninc "Mean Income (\\$10,000s)"
label var L_zip3_share_college "Percent College"
gen groups=after+1
expand 2, generate(new_sample) 
replace groups=0 if new_sample==1
local auxiliar=_N+1
set obs `auxiliar'
replace groups=3 if _n==_N
foreach var of varlist $vars1 $vars2 {
ttest `var' if new_sample==0, by(after)
replace `var'=`r(p)' if groups==3
}
label define groups 0 "All" 1 "Moved Before 2012-Cycle" 2 "Moved After 2012-Cycle" 3 "P-value of Diff."
label values groups groups
eststo clear
estpost tabstat $vars1, by(groups) statistics(mean semean) columns(statistics) nototal
esttab using "table_1.tex", booktabs main(mean %9.2f) aux(semean %9.2f) eqlabels(`e(labels)') nostar unstack noobs nonote nomtitle nonumber label replace gap compress refcat(female "\emph{Individual Characteristics}" L_zip3_irs_meaninc "\midrule \emph{ZIP-3 Characteristics}", nolabel)
eststo clear
estpost tabstat $vars2, by(groups) statistics(mean semean) columns(statistics) nototal
esttab using "table_2.tex", booktabs main(mean %9.2f) aux(semean %9.2f) eqlabels(`e(labels)') nostar unstack noobs nonote nomtitle nonumber label replace gap compress refcat(L_some "\midrule \emph{2008-Cycle}" some "\midrule \emph{2012-Cycle}", nolabel)


** Generate Table 3
set more off
use ready-to-use-data, clear
define_controls
gen non_white=1-white
gen int_true_time=t_zip3_share_ind_own*(24-timemoved)
gen int_true_same_state=t_zip3_share_ind_own*same_state
gen int_true_female=(1-male)*t_zip3_share_ind_own
gen int_true_black=black*t_zip3_share_ind_own
gen int_true_hispanic=hispanic*t_zip3_share_ind_own
gen int_true_non_white=non_white*t_zip3_share_ind_own
gen int_t_zip3_share_ind_own=t_zip3_share_ind_own*late
* Auxiliar regression
qui: xtreg some f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) cluster(dummies)
display "N=`e(N)'; Groups=`e(N_g)'"
eststo clear 
* Baseline
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) robust
test f_zip3_share_ind_own==t_zip3_share_ind_own 
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
* Include adjacent
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own t_adj_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) robust
test f_zip3_share_ind_own==t_zip3_share_ind_own 
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
test t_zip3_share_ind_own==t_adj_zip3_share_ind_own 
local p_difference=`r(p)'
estadd scalar p_difference2=`p_difference'
* Interaction with Later
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own int_true_time timemoved after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) robust
* Interaction with Same State
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own int_true_same_state same_state after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) robust
* Interaction with female
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own int_true_female male after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) robust
* Interaction with race
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own int_true_non_white non_white after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) robust
lab var amount_poisson "DELETE THIS LINE"
label var f_zip3_share_ind_own "\hspace{0.25cm} Moved After 2012-Cycle\$^{(i)}\$"
label var t_zip3_share_ind_own "\hspace{0.25cm} Moved Before 2012-Cycle\$^{(ii)}\$"
label var t_adj_zip3_share_ind_own "\hspace{0.25cm} Moved Before 2012-Cycle\$^{(iii)}\$"
label var int_true_time "\hspace{0.75cm} Int. with Exposure Time"
label var int_true_same_state "\hspace{0.75cm} Int. with Same-State Dummy"
label var int_true_female "\hspace{0.75cm} Int. with Female"
label var int_true_non_white "\hspace{0.75cm} Int. with Non-White"
esttab using "table_3.tex", nomtitle se nonotes label replace booktabs gap compress keep(f_zip3_share_ind_own t_zip3_share_ind_own int_true_time int_true_same_state int_true_female int_true_non_white t_adj_zip3_share_ind_own) order(f_zip3_share_ind_own t_zip3_share_ind_own int_true_time int_true_same_state int_true_female int_true_non_white t_adj_zip3_share_ind_own) stats(p_difference1 p_difference2, fmt(%9.3f %9.3f) labels("P-value (i)=(ii)" "P-value (ii)=(iii)")) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) mgroups("Amount Cont. (\\$)", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) refcat(f_zip3_share_ind_own "Share Democrat in Same ZIP-3" t_adj_zip3_share_ind_own "Share Democrat in Adjacent ZIP-3s", nolabel)


** Generate Table 4
set more off
use ready-to-use-data, clear
define_controls
eststo clear 
* Auxiliar regression
qui: xtreg some f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) cluster(dummies)
display "N=`e(N)'; Groups=`e(N_g)'"
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) robust
test f_zip3_share_ind_own==t_zip3_share_ind_own 
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
estadd local modelo "Poisson"
set seed 321
eststo: pantob amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls dummies if cycle==2, details bootstrap
test f_zip3_share_ind_own==t_zip3_share_ind_own 
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
estadd local modelo "Tobit"
set seed 321
eststo: xtlogit some f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) vce(boot)
test f_zip3_share_ind_own==t_zip3_share_ind_own 
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
estadd local modelo "Logit"
set seed 123
eststo: xtlogit amount_over_325 f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) vce(boot)
test f_zip3_share_ind_own==t_zip3_share_ind_own 
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
estadd local modelo "Logit"
set seed 123
eststo: xtlogit amount_over_500 f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) vce(boot)
test f_zip3_share_ind_own==t_zip3_share_ind_own 
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
estadd local modelo "Logit"
set seed 123
eststo: xtlogit amount_over_1000 f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) vce(boot)
*eststo: nlcom (f_zip3_share_ind_own:exp(_b[f_zip3_share_ind_own])-1) (t_zip3_share_ind_own:exp(_b[t_zip3_share_ind_own])-1), post
test f_zip3_share_ind_own==t_zip3_share_ind_own 
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
estadd local modelo "Logit"
lab var amount_poisson "DELETE THIS LINE"
label var f_zip3_share_ind_own "\hspace{0.25cm} Moved After 2012-Cycle\$^{(i)}\$"
label var t_zip3_share_ind_own "\hspace{0.25cm} Moved Before 2012-Cycle\$^{(ii)}\$"
esttab using "table_4.tex", nomtitle se nonotes label replace booktabs gap compress keep(f_zip3_share_ind_own t_zip3_share_ind_own) order(f_zip3_share_ind_own t_zip3_share_ind_own) stats(p_difference1 modelo, fmt(%9.3f %3s) labels("P-value (i)=(ii)" "\midrule Model")) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) mgroups("\footnotesize{Amount (\\$)}" "\footnotesize{P(A>\\$200)}" "\footnotesize{P(A>\\$325)}" "\footnotesize{P(A>\\$500)}" "\footnotesize{P(A>\\$1,000)}", pattern(1 0 1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) refcat(f_zip3_share_ind_own "Share Democrat in ZIP-3", nolabel)


** Generate Table 5
set more off
use ready-to-use-data, clear
define_controls
eststo clear 
* Auxiliar regression
qui: xtreg some f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) cluster(dummies)
local Ngroups=`e(N_g)'
local obs=`e(N)'
* Baseline
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) robust
test f_zip3_share_ind_own==t_zip3_share_ind_own
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
estadd scalar Ngroups=`Ngroups'
estadd scalar obs=`obs'
estadd local group_amount "\\$100-Int."
estadd local group_origin "10\\%-Int."
qui: xtreg some f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies_alt_1>1, fe i(dummies_alt_1) cluster(dummies_alt_1)
local Ngroups=`e(N_g)'
local obs=`e(N)'
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies_alt_1>1, fe i(dummies_alt_1) robust
test f_zip3_share_ind_own==t_zip3_share_ind_own
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
estadd scalar Ngroups=`Ngroups'
estadd scalar obs=`obs'
estadd local group_amount "\\$100-Int."
estadd local group_origin "Same-ZIP-3"
qui: xtreg some f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies_alt_2>1, fe i(dummies_alt_2) cluster(dummies_alt_2)
local Ngroups=`e(N_g)'
local obs=`e(N)'
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies_alt_2>1, fe i(dummies_alt_2) robust
test f_zip3_share_ind_own==t_zip3_share_ind_own
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
estadd scalar Ngroups=`Ngroups'
estadd scalar obs=`obs'
estadd local group_amount "\\$100-Int."
estadd local group_origin "Same-ZIP-5"
qui: xtreg some f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies_alt_3>1, fe i(dummies_alt_3) cluster(dummies_alt_3)
local Ngroups=`e(N_g)'
local obs=`e(N)'
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies_alt_3>1, fe i(dummies_alt_3) robust
test f_zip3_share_ind_own==t_zip3_share_ind_own
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
estadd scalar Ngroups=`Ngroups'
estadd scalar obs=`obs'
estadd local group_amount "\\$10-Int."
estadd local group_origin "10\\%-Int."
qui: xtreg some f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2, robust
local obs=`e(N)'
qui: eststo: poisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2, cluster(dummies)
test f_zip3_share_ind_own==t_zip3_share_ind_own
local p_difference=`r(p)'
estadd scalar p_difference1=`p_difference'
estadd scalar obs=`obs'
estadd local group_amount "None"
estadd local group_origin "None"
lab var amount_poisson "DELETE THIS LINE"
label var f_zip3_share_ind_own "\hspace{0.25cm} Moved After 2012-Cycle\$^{(i)}\$"
label var t_zip3_share_ind_own "\hspace{0.25cm} Moved Before 2012-Cycle\$^{(ii)}\$"
esttab using "table_5.tex", nomtitle se nonotes label replace booktabs gap compress keep(f_zip3_share_ind_own t_zip3_share_ind_own) order(f_zip3_share_ind_own t_zip3_share_ind_own) stats(p_difference1 group group_amount group_origin obs Ngroups, fmt(%9.3f %9.0fc %9.0fc) labels("P-value (i)=(ii)" "\midrule Group Dummies Def.:" "Amount-Pairing" "Origin-Pairing" "\midrule Observations" "No. of Groups")) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) mgroups("Amount Cont. (\\$)", pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) refcat(f_zip3_share_ind_own "Share Democrat in ZIP-3", nolabel)


** Generate Table 6
set more off
use ready-to-use-data, clear
define_controls
eststo clear 
* Auxiliar regression
qui: xtreg some f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) cluster(dummies)
local Ngroups=`e(N_g)'
local obs=`e(N)'
* Baseline
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) robust
test f_zip3_share_ind_own==t_zip3_share_ind_own
local p_difference=`r(p)'
estadd scalar p_difference=`p_difference'
estadd local economic "Yes"
estadd local demographic "Yes"
estadd local racial "Yes"
estadd local redistribution "No"
estadd local family "No"
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls t_zip3_irs_meaninc t_zip3_share_college t_zip3_share_unemployed f_zip3_irs_meaninc f_zip3_share_college f_zip3_share_unemployed t_zip3_population t_zip3_share_under25yo f_zip3_population f_zip3_share_under25yo if cycle==2 & N_dummies>1, fe i(dummies) robust
test f_zip3_share_ind_own==t_zip3_share_ind_own
local p_difference=`r(p)'
estadd scalar p_difference=`p_difference'
estadd local economic "Yes"
estadd local demographic "Yes"
estadd local racial "No"
estadd local redistribution "No"
estadd local family "No"
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls t_zip3_irs_meaninc t_zip3_share_college t_zip3_share_unemployed f_zip3_irs_meaninc f_zip3_share_college f_zip3_share_unemployed  if cycle==2 & N_dummies>1, fe i(dummies) robust
test f_zip3_share_ind_own==t_zip3_share_ind_own
local p_difference=`r(p)'
estadd scalar p_difference=`p_difference'
estadd local economic "Yes"
estadd local demographic "No"
estadd local racial "No"
estadd local redistribution "No"
estadd local family "No"
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls t_zip3_irs_average_tax t_zip3_irs_share_eitc f_zip3_irs_average_tax f_zip3_irs_share_eitc if cycle==2 & N_dummies>1, fe i(dummies) robust
test f_zip3_share_ind_own==t_zip3_share_ind_own
local p_difference=`r(p)'
estadd scalar p_difference=`p_difference'
estadd local economic "Yes"
estadd local demographic "Yes"
estadd local racial "Yes"
estadd local redistribution "Yes"
estadd local family "No"
qui: eststo: xtpoisson amount_poisson f_zip3_share_ind_own t_zip3_share_ind_own after $ind_controls $true_zip3_controls $fake_zip3_controls t_zip3_irs_average_tax t_zip3_irs_share_eitc f_zip3_irs_average_tax f_zip3_irs_share_eitc t_zip3_share_school t_zip3_share_married f_zip3_share_school f_zip3_share_married if cycle==2 & N_dummies>1, fe i(dummies) robust
test f_zip3_share_ind_own==t_zip3_share_ind_own
local p_difference=`r(p)'
estadd scalar p_difference=`p_difference'
estadd local economic "Yes"
estadd local demographic "Yes"
estadd local racial "Yes"
estadd local redistribution "Yes"
estadd local family "Yes"
lab var amount_poisson "DELETE THIS LINE"
label var f_zip3_share_ind_own "\hspace{0.25cm} Moved After 2012-Cycle\$^{(i)}\$"
label var t_zip3_share_ind_own "\hspace{0.25cm} Moved Before 2012-Cycle\$^{(ii)}\$"
esttab using "table_6.tex", nomtitle se nonotes label replace booktabs gap compress keep(f_zip3_share_ind_own t_zip3_share_ind_own) order(f_zip3_share_ind_own t_zip3_share_ind_own) stats(p_difference controls_title economic demographic racial redistribution family, fmt(%9.3f %3s %3s %3s %3s %3s %3s) labels("P-value (i)=(ii)" "\midrule ZIP-3 Controls:" "Economic" "Demographic" "Racial" "Redistribution" "Family")) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) mgroups("Amount Cont. (\\$)", pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) refcat(f_zip3_share_ind_own "Share Democrat in ZIP-3", nolabel)


** Estimate of gamma used for counterfactual analysis (gamma_hat=0.11)
set more off
use ready-to-use-data, clear
define_controls
eststo clear 
xtpoisson amount_poisson f_lnzip3_ratio t_lnzip3_ratio $ind_controls $true_zip3_controls $fake_zip3_controls if cycle==2 & N_dummies>1, fe i(dummies) robust
