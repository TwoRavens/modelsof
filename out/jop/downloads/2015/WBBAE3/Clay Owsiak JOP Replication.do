*Manuscript - Table 1 (UPDATED for RR2)
use "Clay Owsiak JOP Data_May2015.dta", clear
tsset cdyad year
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust

*Manuscript - Figure 1
use "Clay Owsiak JOP Data_May2015.dta", clear
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
*Use dataset containing mean/median/modal figures
use "GeneralGraphData.dta"
tsset cdyad nosettleyr
predict pred, xb
predict sterr, stdp
gen ci=sterr*1.96
sum pred ci
gen predlo=pred-ci
gen predhi=pred+ci
gen pred2=1/(1+exp(-(pred)))
gen predlo2=1/(1+exp(-(predlo)))
gen predhi2=1/(1+exp(-(predhi)))
replace lag_row_wsettlem1=0
replace noothersetyr=nosettleyr
replace nothersetyr2=nosetyr2
replace noothersetyr3=nosetyr3
tsset cdyad nosettleyr
predict pred0, xb
predict sterr0, stdp
gen ci0=sterr0*1.96
sum pred0 ci0
gen predlo0=pred0-ci0
gen predhi0=pred0+ci0
gen pred20=1/(1+exp(-(pred0)))
gen predlo20=1/(1+exp(-(predlo0)))
gen predhi20=1/(1+exp(-(predhi0)))
graph twoway (rarea predlo2 predhi2 nosettleyr)(rarea predlo20 predhi20 nosettleyr)(line pred2 pred20 nosettleyr)
save "manuscript_figure_data.dta"
*Final graph made in R.  See "R_Graphs.R" file.


**Appendix - Part B.1 Robustness Models, Logistic Regression Predicting Border Settlement, 1816-2001
use "Clay Owsiak JOP Data_May2015.dta"
**Major Power Status
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 major_one major_both nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
**Interaction Between Parity & Spatial Lag
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 lncincratXlag_row_wsettle nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
**Total Number of Borders
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 bordercount nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
**Total Number of Unsettled Borders
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 unsettledborders nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
**Total Trade (From COW Trade 3.0)
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 totaltrade nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
**Banks Instability 
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 banksdomesticdyad nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
**PRIO  Conflict 
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww2 PRIOinter PRIOcivil nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
**Dyad @ War (based on MID data from EUGene)
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 wardyad_eugenemid nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
**Dyad MID Hostility Level (same source)
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 midhostility_eugenemid nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust


**Appendix - Part B.2 Number of Rel. Settlements, Logistic Regressions Predicting Border Settlement, 1816-2001
use "Clay Owsiak JOP Data_May2015.dta"
tsset cdyad year
logit settlem lag_norow_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem L.anytp sumneg jtdem6 lncincratio atopally crt07riv postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem lag_norow_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp sumneg jtdem6 lncincratio atopally crt07riv postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem lag_norow_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust


**Appendix - Part B.3: Conditional Logistic Regression Predicting Border Settlement, 1816-2001
use "Clay Owsiak JOP Data_May2015.dta"
tsset cdyad year
clogit settlem lag_row_wsettlem1 lag_noothersetyr lag_nothersetyr2  lag_noothersetyr3 if lag_settlem==0, robust group(nosettleyr)
clogit settlem lag_anytp sumneg jtdem6 lncincratio atopally crt07riv postww1 postww2 if lag_settlem==0, robust group(nosettleyr)
clogit settlem lag_row_wsettlem1 lag_noothersetyr lag_nothersetyr2  lag_noothersetyr3 lag_anytp sumneg jtdem6 lncincratio atopally crt07riv postww1 postww2 if lag_settlem==0, robust group(nosettleyr)
clogit settlem lag_anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 if lag_settlem==0, robust group(nosettleyr)
clogit settlem lag_row_wsettlem1 lag_noothersetyr lag_nothersetyr2  lag_noothersetyr3 lag_anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 if lag_settlem==0, robust group(nosettleyr)


**Appendix - Part B.4: Number of Previous Agreements, Logistic Regression Predicting Border Settlement, 1816-2001
use "Clay Owsiak JOP Data_May2015.dta"
tsset cdyad year
logit settlem settlements_1year  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem settlements_1year settle_next5yr   L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem settlements_1year settle_next5yr settle_second5  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem settlements_1year settle_next5yr settle_second5 settle_third5  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust


**Appendix - Part B.5: Claim Characteristics, Logistic Regression Predicting Border Settlement, 1816-2001
use "Clay Owsiak JOP Data_May2015.dta"
tsset cdyad year
logit settlem lag_row_wsettlem1 lag_avgsalsett0 maxicowsal0 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem c.lag_row_wsettlem1##c.maxicowsal0 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem c.lag_row_wsettlem1##c.lag_avgsalsett0 maxicowsal0 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem c.lag_row_wsettlem1 maxlegalclaim L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem c.lag_row_wsettlem1##c.maxlegalclaim L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem c.lag_row_wsettlem1##c.maxicowsal0 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem c.lag_row_wsettlem1 c.maxicowsal0##L.anytp L.noothersetyr L.nothersetyr2 L.noothersetyr3 sumneg cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem c.lag_row_wsettlem1 c.maxicowsal0##c.sumneg L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem c.lag_row_wsettlem1 c.maxicowsal0##c.lncincratio L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg cow_civilwarcombine jtdem6  atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
*Figure 1
logit settlem c.lag_row_wsettlem1##c.lag_avgsalsett0 maxicowsal0 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
margins, dydx(lag_row_wsettlem1) at(lag_avgsalsett0=(0 (1) 12)) 
marginsplot, recast(line) recastci(rarea)
*Figure 2
logit settlem c.lag_row_wsettlem1##c.maxicowsal0 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
margins, dydx(lag_row_wsettlem1) at(maxicowsal0=(0 (1) 12))
marginsplot, recast(line) recastci(rarea)
*Figure 3
*Relevant Borders Settled
logit settlem c.lag_row_wsettlem1##c.maxicowsal0 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
margins, dydx(lag_row_wsettlem1) at(maxicowsal0=(0 (1) 12))
marginsplot, recast(line) recastci(rarea)
graph save Graph "DiffusionSalience.gph"
*Third Party
logit settlem c.lag_row_wsettlem1 c.maxicowsal0##L.anytp L.noothersetyr L.nothersetyr2 L.noothersetyr3 sumneg cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
margins, dydx(L.anytp) at(maxicowsal0=(0 (1) 12))
marginsplot, recast(line) recastci(rarea)
graph save Graph "ThirdPartySalience.gph"
*Sum of Negotiations
logit settlem c.lag_row_wsettlem1 c.maxicowsal0##c.sumneg L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
margins, dydx(sumneg)  at(maxicowsal0=(0 (1) 12))
marginsplot, recast(line) recastci(rarea)
graph save Graph "BilatSalience.gph"
*Cinc Ratio
logit settlem c.lag_row_wsettlem1 c.maxicowsal0##c.lncincratio L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg cow_civilwarcombine jtdem6  atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
margins, dydx(lncincratio) at(maxicowsal0=(0 (1) 12))
marginsplot, recast(line) recastci(rarea)
graph save Graph "CincSalience.gph"
graph combine  "DiffusionSalience.gph" "ThirdPartySalience.gph" "BilatSalience.gph"  "CincSalience.gph"
*Figure 4
logit settlem c.lag_row_wsettlem1##c.maxlegalclaim L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
margins, dydx(lag_row_wsettlem1) over(maxlegalclaim)
marginsplot, plotopts(connect(none)) level(90)
*Figure 5
hist lag_row_wsettlem1 if e(sample) & maxlegalclaim==0 & settlem==0, freq bin(20)
graph save Graph "HistogramClaim0.gph", replace
hist lag_row_wsettlem1 if e(sample) & maxlegalclaim==1 & settlem==0, freq bin(20)
graph save Graph "HistogramClaim1.gph", replace
hist lag_row_wsettlem1 if e(sample) & maxlegalclaim==2 & settlem==0, freq bin(20)
graph save Graph "HistogramClaim2.gph", replace
graph combine "HistogramClaim0.gph" "HistogramClaim1.gph" "HistogramClaim2.pgh"


**Appendix - Part B.6: Colonial Networks, Logistic Regression Predicting Border Settlement, 1816-2001
use "Clay Owsiak JOP Data_May2015.dta"
tsset cdyad year
logit settlem c.lag_row_wsettlem1 sharedcol L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit settlem c.lag_row_wsettlem1##sharedcol L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust


**Appendix - Part B.7: Probit with Sample Selection Predicting Settlement Attempt & Border Settlement, 1816-2001
use "Clay Owsiak JOP Data_May2015.dta"
tsset cdyad year
heckprobit settlem c.lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.sumtp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, select(attempt2=c.lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 sharedcol) vce(robust)


**Appendix - Part B.8: Model Fit & Out-of-Sample Predictive Power
use "Clay Owsiak JOP Data_May2015.dta"
*Likelihood Ratio Test for Model 2 (Does the addition of our diffusion variables significantly improve model fit?)
logit settlem L.anytp sumneg jtdem6 lncincratio atopally crt07riv postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0,robust
scalar m1 = e(ll)
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
scalar m2 = e(ll)
di "chi2(4) = " 2*(m2-m1)
di "Prob > chi2 = "chi2tail(4, 2*(m2-m1))
*Yes it does

*Likelihood Ratio Test for Model 3 (Does the addition of our diffusion variables significantly improve model fit?)
logit settlem L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
scalar m1 = e(ll)
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
scalar m2 = e(ll)
di "chi2(4) = " 2*(m2-m1)
di "Prob > chi2 = "chi2tail(4, 2*(m2-m1))
*Yes it does

*Additional Likelihood Ratio Test for Table 1, Model 4 (Does the addition of our diffusion variables significantly improve model fit?)
logit settlem L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
scalar m1 = e(ll)
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
scalar m2 = e(ll)
di "chi2(4) = " 2*(m2-m1)
di "Prob > chi2 = "chi2tail(4, 2*(m2-m1))
*Yes it does

*Brier Scores - Model 2
foreach x of numlist 2070 41042 70090 80090 90091 90092 91092 91093 94095 95100 100101 100130 100135 100140 101110 101140 110115 130135 135140 135145 135155 140145 140150 140160 145150 145155 145160 150160 155160 160165 200205 210211 210255 220245 220255 220267 220325 225267 225300 225325 245300 255290 255300 255315 255390 260265 269300 290315 290365 290368 300325 305310 305315 305325 305345 310315 310345 310360 315365 316317 325345 339345 339350 345360 350355 350640 352640 355640 360365 365369 365375 365380 365630 365640 365700 365710 432435 432436 432439 437450 437452 438450 452461 471475 483620 501530 501625 520530 530625 540565 541553 551565 560565 560570 565571 600615 615616 625651 630645 630700 645670 645690 651666 652666 660666 663666 663670 670678 670679 670680 670690 670696 670698 678680 680698 696698 700710 700770 702710 710712 710750 710760 710770 710775 731732 750760 750770 750771 800811 811816 811817 816817 820830 820835{
logit settlem L.anytp sumneg jtdem6 lncincratio atopally crt07riv postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0 & cdyad!=`x',robust
predict prob_`x'
}
gen prob_model2=prob_2070 if cdyad==2070
drop prob_2070
foreach x of numlist 41042 70090 80090 90091 90092 91092 91093 94095 95100 100101 100130 100135 100140 101110 101140 110115 130135 135140 135145 135155 140145 140150 140160 145150 145155 145160 150160 155160 160165 200205 210211 210255 220245 220255 220267 220325 225267 225300 225325 245300 255290 255300 255315 255390 260265 269300 290315 290365 290368 300325 305310 305315 305325 305345 310315 310345 310360 315365 316317 325345 339345 339350 345360 350355 350640 352640 355640 360365 365369 365375 365380 365630 365640 365700 365710 432435 432436 432439 437450 437452 438450 452461 471475 483620 501530 501625 520530 530625 540565 541553 551565 560565 560570 565571 600615 615616 625651 630645 630700 645670 645690 651666 652666 660666 663666 663670 670678 670679 670680 670690 670696 670698 678680 680698 696698 700710 700770 702710 710712 710750 710760 710770 710775 731732 750760 750770 750771 800811 811816 811817 816817 820830 820835{
replace prob_model2=prob_`x' if cdyad==`x'
drop prob_`x'
}
foreach x of numlist 2070 41042 70090 80090 90091 90092 91092 91093 94095 95100 100101 100130 100135 100140 101110 101140 110115 130135 135140 135145 135155 140145 140150 140160 145150 145155 145160 150160 155160 160165 200205 210211 210255 220245 220255 220267 220325 225267 225300 225325 245300 255290 255300 255315 255390 260265 269300 290315 290365 290368 300325 305310 305315 305325 305345 310315 310345 310360 315365 316317 325345 339345 339350 345360 350355 350640 352640 355640 360365 365369 365375 365380 365630 365640 365700 365710 432435 432436 432439 437450 437452 438450 452461 471475 483620 501530 501625 520530 530625 540565 541553 551565 560565 560570 565571 600615 615616 625651 630645 630700 645670 645690 651666 652666 660666 663666 663670 670678 670679 670680 670690 670696 670698 678680 680698 696698 700710 700770 702710 710712 710750 710760 710770 710775 731732 750760 750770 750771 800811 811816 811817 816817 820830 820835{
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0 & cdyad!=`x', robust
predict prob_`x'
}
gen prob_model3=prob_2070 if cdyad==2070
drop prob_2070
foreach x of numlist 41042 70090 80090 90091 90092 91092 91093 94095 95100 100101 100130 100135 100140 101110 101140 110115 130135 135140 135145 135155 140145 140150 140160 145150 145155 145160 150160 155160 160165 200205 210211 210255 220245 220255 220267 220325 225267 225300 225325 245300 255290 255300 255315 255390 260265 269300 290315 290365 290368 300325 305310 305315 305325 305345 310315 310345 310360 315365 316317 325345 339345 339350 345360 350355 350640 352640 355640 360365 365369 365375 365380 365630 365640 365700 365710 432435 432436 432439 437450 437452 438450 452461 471475 483620 501530 501625 520530 530625 540565 541553 551565 560565 560570 565571 600615 615616 625651 630645 630700 645670 645690 651666 652666 660666 663666 663670 670678 670679 670680 670690 670696 670698 678680 680698 696698 700710 700770 702710 710712 710750 710760 710770 710775 731732 750760 750770 750771 800811 811816 811817 816817 820830 820835{
replace prob_model3=prob_`x' if cdyad==`x'
drop prob_`x'
}
logit settlem L.anytp sumneg jtdem6 lncincratio atopally crt07riv postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0,robust
brier settlem prob_model2 if e(sample)
brier settlem prob_model3 if e(sample)
*Model 3 produces a lower Brier score than Model 2, which is what we would hope for.
sum prob_model2 if settlem==0 & e(sample)
sum prob_model3 if settlem==0 & e(sample)
*Do about equally well predicting 0s (model 2 avg=0.0302, model 3 avg=0.0300)
sum prob_model2 if settlem==1 & e(sample)
sum prob_model3 if settlem==1 & e(sample)
*Model 3 really outperforms model 2 at predicting 1s, which is clearly what we are more interested in (model 2 avg=0.1056, model 3 avg=0.1308)

*Brier Scores-Model 3
foreach x of numlist 41042 70090 80090 90091 90092 91092 91093 94095 95100 100101 100130 100135 100140 101110 101140 110115 130135 135140 135145 135155 140145 140150 140160 145150 145155 145160 150160 155160 160165 200205 220255 255290 255315 255390 260265 269300 290315 290365 290368 300325 305310 305315 305325 305345 310315 310345 310360 315365 316317 325345 339345 339350 345360 350355 350640 352640 355640 360365 365369 365375 365630 365640 365700 365710 432435 432436 432439 437450 437452 438450 452461 471475 483620 501530 501625 520530 530625 540565 541553 551565 560565 560570 565571 600615 615616 625651 630645 630700 645670 645690 651666 652666 660666 663666 663670 670678 670679 670680 670690 670696 670698 678680 680698 696698 700710 700770 702710 710712 710750 710760 710770 710775 731732 750760 750770 750771 800811 811816 811817 816817 820830 820835{
logit settlem L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0 & cdyad!=`x',robust
predict prob_`x'
}
gen prob_model4=prob_41042 if cdyad==41042
drop prob_41042
foreach x of numlist 70090 80090 90091 90092 91092 91093 94095 95100 100101 100130 100135 100140 101110 101140 110115 130135 135140 135145 135155 140145 140150 140160 145150 145155 145160 150160 155160 160165 200205 220255 255290 255315 255390 260265 269300 290315 290365 290368 300325 305310 305315 305325 305345 310315 310345 310360 315365 316317 325345 339345 339350 345360 350355 350640 352640 355640 360365 365369 365375 365630 365640 365700 365710 432435 432436 432439 437450 437452 438450 452461 471475 483620 501530 501625 520530 530625 540565 541553 551565 560565 560570 565571 600615 615616 625651 630645 630700 645670 645690 651666 652666 660666 663666 663670 670678 670679 670680 670690 670696 670698 678680 680698 696698 700710 700770 702710 710712 710750 710760 710770 710775 731732 750760 750770 750771 800811 811816 811817 816817 820830 820835{
replace prob_model4=prob_`x' if cdyad==`x'
drop prob_`x'
}
foreach x of numlist 41042 70090 80090 90091 90092 91092 91093 94095 95100 100101 100130 100135 100140 101110 101140 110115 130135 135140 135145 135155 140145 140150 140160 145150 145155 145160 150160 155160 160165 200205 220255 255290 255315 255390 260265 269300 290315 290365 290368 300325 305310 305315 305325 305345 310315 310345 310360 315365 316317 325345 339345 339350 345360 350355 350640 352640 355640 360365 365369 365375 365630 365640 365700 365710 432435 432436 432439 437450 437452 438450 452461 471475 483620 501530 501625 520530 530625 540565 541553 551565 560565 560570 565571 600615 615616 625651 630645 630700 645670 645690 651666 652666 660666 663666 663670 670678 670679 670680 670690 670696 670698 678680 680698 696698 700710 700770 702710 710712 710750 710760 710770 710775 731732 750760 750770 750771 800811 811816 811817 816817 820830 820835{
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if  L.settlem==0 & cdyad!=`x', robust
predict prob_`x'
}
gen prob_model5=prob_41042 if cdyad==41042
drop prob_41042
foreach x of numlist 70090 80090 90091 90092 91092 91093 94095 95100 100101 100130 100135 100140 101110 101140 110115 130135 135140 135145 135155 140145 140150 140160 145150 145155 145160 150160 155160 160165 200205 220255 255290 255315 255390 260265 269300 290315 290365 290368 300325 305310 305315 305325 305345 310315 310345 310360 315365 316317 325345 339345 339350 345360 350355 350640 352640 355640 360365 365369 365375 365630 365640 365700 365710 432435 432436 432439 437450 437452 438450 452461 471475 483620 501530 501625 520530 530625 540565 541553 551565 560565 560570 565571 600615 615616 625651 630645 630700 645670 645690 651666 652666 660666 663666 663670 670678 670679 670680 670690 670696 670698 678680 680698 696698 700710 700770 702710 710712 710750 710760 710770 710775 731732 750760 750770 750771 800811 811816 811817 816817 820830 820835{
replace prob_model5=prob_`x' if cdyad==`x'
drop prob_`x'
}
logit settlem L.anytp sumneg jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
brier settlem prob_model4 if e(sample)
brier settlem prob_model5 if e(sample)
*Model 5 produces a lower Brier score than Model 4, which is what we would hope for.
sum prob_model4 if settlem==0 & e(sample)
sum prob_model5 if settlem==0 & e(sample)
*Do about equally well predicting 0s (model 4 avg=0.0329, model 3 avg=0.0332)
sum prob_model4 if settlem==1 & e(sample)
sum prob_model5 if settlem==1 & e(sample)
*Model 5 really outperforms model 4 at predicting 1s, which is clearly what we are more interested in (model 4 avg=0.1146, model 5 avg=0.1438)

*Brier Scores - MOdel 4
foreach x of numlist 41042 70090 80090 90091 90092 91092 91093 94095 95100 100101 100130 100135 100140 101110 101140 110115 130135 135140 135145 135155 140145 140150 140160 145150 145155 145160 150160 155160 160165 200205 220255 255290 255315 255390 260265 269300 290315 290365 290368 300325 305310 305315 305325 305345 310315 310345 310360 315365 316317 325345 339345 339350 345360 350355 350640 352640 355640 360365 365369 365375 365630 365640 365700 365710 432435 432436 432439 437450 437452 438450 452461 471475 483620 501530 501625 520530 530625 540565 541553 551565 560565 560570 565571 600615 615616 625651 630645 630700 645670 645690 651666 652666 660666 663666 663670 670678 670679 670680 670690 670696 670698 678680 680698 696698 700710 700770 702710 710712 710750 710760 710770 710775 731732 750760 750770 750771 800811 811816 811817 816817 820830 820835{
logit settlem L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
predict prob_`x'
}
gen prob_model_new1=prob_41042 if cdyad==41042
drop prob_41042
foreach x of numlist 70090 80090 90091 90092 91092 91093 94095 95100 100101 100130 100135 100140 101110 101140 110115 130135 135140 135145 135155 140145 140150 140160 145150 145155 145160 150160 155160 160165 200205 220255 255290 255315 255390 260265 269300 290315 290365 290368 300325 305310 305315 305325 305345 310315 310345 310360 315365 316317 325345 339345 339350 345360 350355 350640 352640 355640 360365 365369 365375 365630 365640 365700 365710 432435 432436 432439 437450 437452 438450 452461 471475 483620 501530 501625 520530 530625 540565 541553 551565 560565 560570 565571 600615 615616 625651 630645 630700 645670 645690 651666 652666 660666 663666 663670 670678 670679 670680 670690 670696 670698 678680 680698 696698 700710 700770 702710 710712 710750 710760 710770 710775 731732 750760 750770 750771 800811 811816 811817 816817 820830 820835{
replace prob_model_new1=prob_`x' if cdyad==`x'
drop prob_`x'
}
foreach x of numlist 41042 70090 80090 90091 90092 91092 91093 94095 95100 100101 100130 100135 100140 101110 101140 110115 130135 135140 135145 135155 140145 140150 140160 145150 145155 145160 150160 155160 160165 200205 220255 255290 255315 255390 260265 269300 290315 290365 290368 300325 305310 305315 305325 305345 310315 310345 310360 315365 316317 325345 339345 339350 345360 350355 350640 352640 355640 360365 365369 365375 365630 365640 365700 365710 432435 432436 432439 437450 437452 438450 452461 471475 483620 501530 501625 520530 530625 540565 541553 551565 560565 560570 565571 600615 615616 625651 630645 630700 645670 645690 651666 652666 660666 663666 663670 670678 670679 670680 670690 670696 670698 678680 680698 696698 700710 700770 702710 710712 710750 710760 710770 710775 731732 750760 750770 750771 800811 811816 811817 816817 820830 820835{
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
predict prob_`x'
}
gen prob_model_new2=prob_41042 if cdyad==41042
drop prob_41042
foreach x of numlist 70090 80090 90091 90092 91092 91093 94095 95100 100101 100130 100135 100140 101110 101140 110115 130135 135140 135145 135155 140145 140150 140160 145150 145155 145160 150160 155160 160165 200205 220255 255290 255315 255390 260265 269300 290315 290365 290368 300325 305310 305315 305325 305345 310315 310345 310360 315365 316317 325345 339345 339350 345360 350355 350640 352640 355640 360365 365369 365375 365630 365640 365700 365710 432435 432436 432439 437450 437452 438450 452461 471475 483620 501530 501625 520530 530625 540565 541553 551565 560565 560570 565571 600615 615616 625651 630645 630700 645670 645690 651666 652666 660666 663666 663670 670678 670679 670680 670690 670696 670698 678680 680698 696698 700710 700770 702710 710712 710750 710760 710770 710775 731732 750760 750770 750771 800811 811816 811817 816817 820830 820835{
replace prob_model_new2=prob_`x' if cdyad==`x'
drop prob_`x'
}
logit settlem L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
brier settlem prob_model_new1 if e(sample)
brier settlem prob_model_new2 if e(sample)
*Spatial model produces a lower Brier score than non-spatial, which is what we would hope for.
sum prob_model_new1 if settlem==0 & e(sample)
sum prob_model_new2 if settlem==0 & e(sample)
*Do about equally well predicting 0s (non-spatial avg=0.0272, spatial avg=0.0259)
sum prob_model_new1 if settlem==1 & e(sample)
sum prob_model_new2 if settlem==1 & e(sample)
*Spatial model really outperforms non-spatial at predicting 1s, which is clearly what we are more interested in (non-spatial avg=0.1885, spatial avg=0.2276)


**Appendix B.9 - Concessions & Settlement
use "Clay Owsiak JOP Data_May2015.dta"
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 i.max_majorconrev2 L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0 & year>1919, robust
logit max_majorconrev lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
logit max_majorconrev c.lag_row_wsettlem1##c.lag_lnnoother  L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
*Figure 1
logit max_majorconrev c.lag_row_wsettlem1##c.lag_lnnoother  L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
margins, dydx(lag_row_wsettlem) at(lag_lnnoother=(0(0.25)4))
marginsplot, recast(line) recastci(rarea)
*Copied margins to an excel file and antilogged time to give it an easier to interpret x-axis.  Brought those data into stata...
import excel "ConcessionsLogTime.xlsx", sheet("Sheet1") firstrow clear
graph twoway (rarea low up time)(line dydx time)


**Appendix B.10 - Fixed & Random Effects
use "Clay Owsiak JOP Data_May2015.dta"
xtlogit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 if L.settlem==0, fe
xtlogit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, re
*Figure 1
xtlogit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, re
use "GeneralGraphData.dta"
tsset cdyad nosettleyr
predict pred, xb
predict sterr, stdp
gen ci=sterr*1.96
sum pred ci
gen predlo=pred-ci
gen predhi=pred+ci
gen pred2=1/(1+exp(-(pred)))
gen predlo2=1/(1+exp(-(predlo)))
gen predhi2=1/(1+exp(-(predhi)))
replace lag_row_wsettlem1=0
replace noothersetyr=nosettleyr
replace nothersetyr2=nosetyr2
replace noothersetyr3=nosetyr3
tsset cdyad nosettleyr
predict pred0, xb
predict sterr0, stdp
gen ci0=sterr0*1.96
sum pred0 ci0
gen predlo0=pred0-ci0
gen predhi0=pred0+ci0
gen pred20=1/(1+exp(-(pred0)))
gen predlo20=1/(1+exp(-(predlo0)))
gen predhi20=1/(1+exp(-(predhi0)))
graph twoway (rarea predlo2 predhi2 nosettleyr)(rarea predlo20 predhi20 nosettleyr)(line pred2 pred20 nosettleyr)
save "randomeffectsgraph.dta"
*Final graph made in R.  See "R_Graphs.R" file.


*Appendix B.11 - Alternative Time Specifications
use "Clay Owsiak JOP Data_May2015.dta"
*First, make splines
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
mkspline spline_revset=noothersetyr if e(sample), cubic knots(15 30 45 60)
mkspline spline_noset=nosettleyr if e(sample), cubic knots(25 50 75 100)
*Table Regressions
logit settlem c.lag_row_wsettlem1##c.lag_lnnoother  L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 lnnosettle if L.settlem==0, robust
logit settlem lag_row_wsettlem1 L.spline_revset* L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 spline_noset* if L.settlem==0, robust
*Also added results from GAM in R - See  below & "GAM R code.R"
*Figure 1 - Log time interaction
logit settlem c.lag_row_wsettlem1##c.lag_lnnoother  L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 lnnosettle if L.settlem==0, robust
use "GeneralGraphData.dta"
tsset cdyad nosettleyr
predict pred, xb
predict sterr, stdp
gen ci=sterr*1.96
sum pred ci
gen predlo=pred-ci
gen predhi=pred+ci
gen pred2=1/(1+exp(-(pred)))
gen predlo2=1/(1+exp(-(predlo)))
gen predhi2=1/(1+exp(-(predhi)))
replace lag_row_wsettlem1=0
replace ln_noother=lnnosettle
replace lag_lnnoother=L.ln_noother
replace lag_rowXlaglog=lag_row_wsettlem1*lag_lnnoother
tsset cdyad nosettleyr
predict pred0, xb
predict sterr0, stdp
gen ci0=sterr0*1.96
sum pred0 ci0
gen predlo0=pred0-ci0
gen predhi0=pred0+ci0
gen pred20=1/(1+exp(-(pred0)))
gen predlo20=1/(1+exp(-(predlo0)))
gen predhi20=1/(1+exp(-(predhi0)))
graph twoway (rarea predlo2 predhi2 nosettleyr)(rarea predlo20 predhi20 nosettleyr)(line pred2 pred20 nosettleyr)
save "loggraphdata.dta"
*Final graph made in R.  See "R_Graphs.R" file.
*Automatic Smoother in GAM - R
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3 L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
keep if e(sample)
save "GAMdata.dta"
use "GeneralGraphData.dta"
save "GAMPredict1.dta", replace
replace lag_row_wsettlem1=0
replace noothersetyr=nosettleyr
replace lag_noothersetyr=L.noothersetyr
save "GAMPredict2.dta", replace
*See how these were used in the "GAM R code.R" file-After R, brought these files back into Stata, as shown below
import delimited "GAMpredictions0.csv", varnames(1) colrange(2) 
destring fit sefit, force replace
gen predprob=1/(1+exp(-fit))
gen ci=sefit*1.96
gen loci=fit-ci
gen hici=fit+ci
gen lo=1/(1+exp(-loci))
gen hi=1/(1+exp(-hici))
save "GAMpredictions0.dta"
clear
import delimited "GAMpredictions1.csv", varnames(1) colrange(2)
destring fit sefit, force replace
gen predprob1=1/(1+exp(-fit))
gen ci=sefit*1.96
gen loci=fit-ci
gen hici=fit+ci
gen lo1=1/(1+exp(-loci))
gen hi1=1/(1+exp(-hici))
save "GAMpredictions1.dta"
use "GAMPredict1.dta", replace
merge 1:1 _n using "GAMpredictions0.dta"
drop _merge
merge 1:1 _n using "GAMpredictions1.dta"
save "GAMpredictionsALL.dta"
graph twoway (rarea lo hi nosettleyr)(rarea lo1 hi1 nosettleyr)(line predprob nosettleyr)(line predprob1 nosettleyr)
*Final graph made in R.  See "R_Graphs.R" file.


*Appendix B.12 - China-Pakistan graphs
*Figure 1 - actual data versus actual data except for no change in settements
use "Clay Owsiak JOP Data_May2015.dta"
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0 & cdyad!=710770, robust
keep if cdyad==710770
save "ChinaPakActualData.dta"
tsset cdyad nosettleyr
predict pred, xb
predict sterr, stdp
gen ci=sterr*1.96
sum pred ci
gen predlo=pred-ci
gen predhi=pred+ci
gen pred2=1/(1+exp(-(pred)))
gen predlo2=1/(1+exp(-(predlo)))
gen predhi2=1/(1+exp(-(predhi)))
replace lag_row_wsettlem1=.1428571
replace noothersetyr=nosettleyr
replace nothersetyr2=nosetyr2
replace noothersetyr3=nosetyr3
tsset cdyad nosettleyr
predict pred0, xb
predict sterr0, stdp
gen ci0=sterr0*1.96
sum pred0 ci0
gen predlo0=pred0-ci0
gen predhi0=pred0+ci0
gen pred20=1/(1+exp(-(pred0)))
gen predlo20=1/(1+exp(-(predlo0)))
gen predhi20=1/(1+exp(-(predhi0)))
graph twoway (rarea predlo2 predhi2 nosettleyr)(rarea predlo20 predhi20 nosettleyr)(line pred2 pred20 nosettleyr)
save "ChinaPakActualData.dta", replace
*Final graph made in R.  See "R_Graphs.R" file.
*Figure 2 - Everything constant at means & modes (number of border states @ max; no missing settlements due to missing data) except settlement variables
use "Clay Owsiak JOP Data_May2015.dta"
logit settlem lag_row_wsettlem1 L.noothersetyr L.nothersetyr2 L.noothersetyr3  L.anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 lncincratio atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 nosettleyr nosetyr2 nosetyr3 if L.settlem==0, robust
keep if cdyad==710770
sum anytp sumneg maxicowsal0 cow_civilwarcombine jtdem6 atopally crt07riv dyad_ldrduration totalrivals_nondyad postww1 postww2 if e(sample), detail
replace sumneg=0
replace maxicowsal0=.8235294
replace cow_civilwarcombine=0
replace dyad_ldrduration=1.411765
replace totalrivals_nondyad=3.117647
replace postww2=0
save "ChinaPakSmooth1.dta", replace
gen country_count= norow_wsettlem1/ row_wsettlem1
sum country_count
egen constant_count=max(country_count)
replace norow_wsettlem1 = 6 in 14
replace norow_wsettlem1 = 9 in 33
replace norow_wsettlem1 = 9 in 40
replace norow_wsettlem1 = 9 in 41
replace row_wsettlem1=norow_wsettlem1/constant_count
tsset cdyad nosettleyr
replace lag_row_wsettlem1=L.row_wsettlem1
predict pred, xb
predict sterr, stdp
gen ci=sterr*1.96
sum pred ci
gen predlo=pred-ci
gen predhi=pred+ci
gen pred2=1/(1+exp(-(pred)))
gen predlo2=1/(1+exp(-(predlo)))
gen predhi2=1/(1+exp(-(predhi)))
replace lag_row_wsettlem1=.05882353
replace noothersetyr=nosettleyr
replace nothersetyr2=nosetyr2
replace noothersetyr3=nosetyr3
tsset cdyad nosettleyr
predict pred0, xb
predict sterr0, stdp
gen ci0=sterr0*1.96
sum pred0 ci0
gen predlo0=pred0-ci0
gen predhi0=pred0+ci0
gen pred20=1/(1+exp(-(pred0)))
gen predlo20=1/(1+exp(-(predlo0)))
gen predhi20=1/(1+exp(-(predhi0)))
graph twoway (rarea predlo2 predhi2 year)(rarea predlo20 predhi20 year)(line pred2 pred20 year)
save "ChinaPakSmooth2.dta", replace
*Final graph made in R.  See "R_Graphs.R" file.
