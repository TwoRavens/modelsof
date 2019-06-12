clear
*----------------------------------------------------------------------------------------
**Analysis**
*----------------------------------------------------------------------------------------
cd ""
use "ph_final", clear
sort country year


**Figure 1: Aggregate and District Level Kayser-Lindstadt Probabilities 
twoway (scatter lp_n lpr, msize(small) mcolor(gs3)), graphregion(color(white)) plotregion(lstyle(foreground)) ylabel(0(.1)1, angle(0)) xlabel(0(.1)1) ytitle(Aggregate Level KL) xtitle(District Level KL) text(.9 .7 "corr(AL, DL) = 0.28")
graph export "figure_1.eps", as(eps) preview(off) replace

gen smpl_kl=1 if lpr>0 & !missing(lpr)
replace smpl_kl=0 if lpr==0 | missing(lpr)
bys country: egen mn_smpl_kl=mean(smpl_kl)
replace lpr=0 if missing(lpr) & mn_smpl_kl>0
replace lpr2=0 if missing(lpr2) & mn_smpl_kl>0
gen nomisslpn=1 if !missing(lp_n)
replace nomisslpn=0 if missing(lp_n)
bys country: egen mn_lpn=mean(nomisslpn)
replace lp_n=0 if missing(lp_n) 
gen lp_nsq=lp_n^2
gen lp2_nsq=lp2_n^2
replace lp_nsq=0 if missing(lp_nsq) 
replace lp2_n=0 if missing(lp2_n) 
replace lp2_nsq=0 if missing(lp2_nsq)
label var lp_nsq "LL (a) squared"
label var lp2_nsq "LL (b) squared"


**Table 1 - Central Gov Balances FE***
*________________
sort cid year
*1 - polarization
quietly: xtreg cg_bal_gdp l.cg_bal_gdp ldef_polar polar gdp_grwth elec ln_infl unemp_ilo r_intrt, fe robust cluster(cid)
gen rwd=e(sample)
replace bbr=0 if rwd==1 & missing(bbr)
replace dr=0 if rwd==1 & missing(dr)

xtreg cg_bal_gdp l.cg_bal_gdp ldef_polar polar gdp_grwth elec ln_infl unemp_ilo r_intrt bbr dr, fe robust cluster(cid)
estimates store m1

*2- parties in government
quietly: xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth elec ln_infl unemp_ilo r_intrt, fe robust cluster(cid)

*w/fiscal rules
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth elec ln_infl unemp_ilo r_intrt dr bbr, fe robust cluster(cid)
estimates store m2

*3 - pig and exec ideology diff
quietly: xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth elec ln_infl unemp_ilo r_intrt dist_ex_opp, fe robust cluster(cid)
* right/left
quietly: xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth elec ln_infl unemp_ilo r_intrt dist_ex_opp right left, fe robust cluster(cid)
*w/rule
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth elec ln_infl unemp_ilo r_intrt dist_ex_opp right left bbr dr, fe robust cluster(cid)
estimates store m3

estout m1 m2 m3 using "table1.tex", cells(b(star fmt(%9.2f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons Constant) replace


**Table 2 - Central Gov Balances and Loss Likelihoods***
*_______________________________

*1 - KL data

*linear
sort cid year
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lpr r_intrt ln_infl unemp_ilo dist_ex_opp right left bbr dr if mn_smpl_kl>0, fe robust cluster(cid)
estimates store l1

*quadratic
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lpr lpr2 r_intrt ln_infl unemp_ilo dist_ex_opp right left bbr dr if mn_smpl_kl>0, fe robust cluster(cid)
estimates store q1

*2 - Aggregate KL (a)

*linear
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lp_n ln_infl r_intrt unemp_ilo dist_ex_opp right left bbr dr, fe robust cluster(cid)
estimates store l2

gen linear2=_b[lp_n]*lp_n

*quadratic
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lp_n lp_nsq ln_infl r_intrt unemp_ilo dist_ex_opp right left bbr dr, fe robust cluster(cid)
estimates store q2

gen quadra2=_b[lp_n]*lp_n+_b[lp_nsq]*lp_n^2

*Figure 2a (linear)
sort lp_n
twoway (line linear2 lp_n, lc(black)), graphregion(color(white)) plotregion(lstyle(foreground)) ylabel(0(.1)-1, angle(0) labsize(medlarge)) ytitle("Central Government Deficit (%GDP)", size(medlarge)) xlabel(0(.1)1, labsize(medlarge)) xtitle(" " "Loss Probability", size(medlarge))  note(" " "Estimates are calculated from column 3 of Table 2", size(medium))
graph export "figure_2a.eps", as(eps) preview(off) replace

*Figure 2b (quadra)
sort lp_n
twoway (line quadra2 lp_n, lc(black)), graphregion(color(white)) plotregion(lstyle(foreground)) ylabel(0(.1)-1, angle(0) labsize(medlarge)) ytitle("Central Government Deficit (%GDP)", size(medlarge)) xlabel(0(.1)1, labsize(medlarge)) xtitle(" " "Loss Probabilities", size(medlarge)) xline(.48, lp(dash) lc(gs11)) text(-.24 .39 "pplur*=0", size(medlarge)) note(" " "Estimates are calculated from column 4 of Table 2", size(medium)) yscale(alt)
graph export "figure_2b.eps", as(eps) preview(off) replace

*2. Aggregate KL (b)

*linear
sort cid year
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lp2_n ln_infl r_intrt unemp_ilo dist_ex_opp right left bbr dr, fe robust cluster(cid)
estimates store l3

*quadra
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lp2_n lp2_nsq ln_infl r_intrt unemp_ilo dist_ex_opp right left bbr dr, fe robust cluster(cid)
estimates store q3

estout l1 q1 l2 q2 l3 q3 using "table2.tex", cells(b(star fmt(%9.2f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons Constant) replace

**Table 3 - Interaction with fiscal rules
*___________________________________________
*1. Aggregate KL (a)

*interactions
gen lpn_bbr=lp_n*bbr
gen lpn_dr=lp_n*dr
sort cid year

* linear
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lp_n ln_infl r_intrt unemp_ilo dist_ex_opp right left bbr dr lpn_bbr lpn_dr, fe robust cluster(cid)
estimates store fr1

*quadratic
gen lpnsq_bbr=lp_nsq*bbr 
gen lpnsq_dr=lp_nsq*dr
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lp_n lp_nsq ln_infl r_intrt unemp_ilo dist_ex_opp right left bbr dr lpn_bbr lpn_dr lpnsq_bbr lpnsq_dr, fe robust cluster(cid)
estimates store fr2

*2. Aggregate KL (b)

*linear
gen lp2n_bbr=lp2_n*bbr
gen lp2n_dr=lp2_n*dr

xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lp2_n ln_infl r_intrt unemp_ilo dist_ex_opp right left bbr dr lp2n_bbr lp2n_dr, fe robust cluster(cid)
estimates store fr3

*quadra
gen lp2nsq_bbr=lp2_nsq*bbr 
gen lp2nsq_dr=lp2_nsq*dr

xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lp2_n lp2_nsq ln_infl r_intrt unemp_ilo dist_ex_opp right left bbr dr lp2n_bbr lp2n_dr lp2nsq_bbr lp2nsq_dr, fe robust cluster(cid)
estimates store fr4

estout fr1 fr2 fr3 fr4 using "table3.tex", cells(b(star fmt(%9.2f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons Constant) replace

***________________________________________________________________
***Appendix A
*1. Aggregate KL (a) with liited sample

*linear
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lp_n ln_infl r_intrt unemp_ilo dist_ex_opp right left bbr dr if mn_smpl_kl>0, fe robust cluster(cid)
estimates store apd1

*quadratic
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lp_n lp_nsq ln_infl r_intrt unemp_ilo dist_ex_opp right left bbr dr if mn_smpl_kl>0, fe robust cluster(cid)
estimates store apd2

*2. Aggregate KL (b) with limited sample

*linear
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lp2_n ln_infl r_intrt unemp_ilo dist_ex_opp right left bbr dr if mn_smpl_kl>0, fe robust cluster(cid)
estimates store apd3

*quadratic
xtreg cg_bal_gdp l.cg_bal_gdp ldef_pig pig gdp_grwth lp2_n lp2_nsq ln_infl r_intrt unemp_ilo dist_ex_opp right left bbr dr if mn_smpl_kl>0, fe robust cluster(cid)
estimates store apd4

estout apd1 apd2 apd3 apd4 using "appendix_a.tex", cells(b(star fmt(%9.2f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons Constant) replace

***Appendix B - Summary Statistics
sutex cg_bal_gdp pig gdp_grwth polar elec ln_infl r_intrt unemp_ilo dist_ex_opp right left lpr lp_n lp2_n dr bbr if rwd==1, par min dig(2) lab  file(appendix_b.tex) replace

*end*
