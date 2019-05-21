*** Replication code for Alt, Lassen and Marshall, "Credible sources and sophisticated Voters: When does new information induce economic voting?"

*** 19th August, 2015

*** Important: the education and parish and municipal immigration variables are not available in this replication dataset because they were computed
*** using the Danish register data. To obtain this variables, replicators must gain permission (as described in the Online Appendix). To results in 
*** the main article require these variables. However, some results in the Online Appendix require these variables; where relevant, the code requiring
*** these variables asterisked out and where possible replaced with code that can reproduce all possible results. 



***************************************************** MAIN PAPER *****************************************************

*** Set the relevant working directory containing the main replication dataset

cd "C:\Users\jmarshall\Dropbox\Denmark project\Data and Analysis\"



*** Load the dataset used throughout the analysis; the creation of the dataset is described in the Online Appendix

use "Danish Panel Survey.dta", clear



*** Coding up key variables

g all = urate_now!=.
g sophist = urate_now>=5 & urate_now<=8 & urate_now!=.
g unsophist = urate_now<5 & urate_now!=. | urate_now>8 & urate_now!=.



*** Look at levels of trust/credibility (cited in the text)

tab confidence_dcb if treatment==1
tab confidence_gov if treatment==1
tab confidence_opp if treatment==1



*** Figure 1: Outcome distribution by treatment

twoway(kdensity urate_fut if treatment==1, bwidth(0.65)) (kdensity urate_fut if treatment==2, bwidth(0.65)) (kdensity urate_fut if treatment==3, bwidth(0.65)) (kdensity urate_fut if treatment==8, bwidth(0.65))
twoway(kdensity urate_fut if treatment==1, bwidth(0.65)) (kdensity urate_fut if treatment==4, bwidth(0.65)) (kdensity urate_fut if treatment==5, bwidth(0.65)) (kdensity urate_fut if treatment==6, bwidth(0.65)) (kdensity urate_fut if treatment==7, bwidth(0.65))
* ...draw graphs in R to reduce scale of responses



*** Test for difference in distribution of unemployment projections (cited in the text)

robvar urate_fut if treatment==2 | treatment==4, by(treatment)
robvar urate_fut if treatment==2 | treatment==6, by(treatment)
robvar urate_fut if treatment==4 | treatment==6, by(treatment)

robvar urate_fut if treatment==3 | treatment==5, by(treatment)
robvar urate_fut if treatment==3 | treatment==7, by(treatment)
robvar urate_fut if treatment==5 | treatment==7, by(treatment)



*** Test for difference between "assume" and true information treatment (cited in the text)

reg urate_fut i.treatment, ro
test 2.treatment==8.treatment
robvar urate_fut if treatment==2 | treatment==8, by(treatment)



*** Merge the DCB 7% treatments

replace treatment = 2 if treatment==8



*** Table 1: Effect of treatments on unemployment expectations

eststo clear
quietly foreach s of varlist all unsophist sophist {
  eststo, title("`s'") : reg urate_fut i.treatment if `s'==1, ro
  summ urate_fut if e(sample)==1
  estadd scalar Mean=`r(mean)'
  estadd scalar SD=`r(sd)'
  summ urate_now if e(sample)==1
  estadd scalar MeanPrior=`r(mean)'
  test 2.treatment==4.treatment
  estadd scalar Test_1=`r(p)'
  test 2.treatment==6.treatment
  estadd scalar Test_2=`r(p)'
  test 4.treatment==6.treatment
  estadd scalar Test_3=`r(p)'
  test 3.treatment==5.treatment
  estadd scalar Test_4=`r(p)'
  test 3.treatment==7.treatment
  estadd scalar Test_5=`r(p)'
  test 5.treatment==7.treatment
  estadd scalar Test_6=`r(p)'
}
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) keep(_cons 2.treatment 3.treatment 4.treatment 5.treatment 6.treatment 7.treatment) order(_cons) ///
  label stats(N r2 Test_1 Test_2 Test_3 Test_4 Test_5 Test_6 Mean SD MeanPrior, label("Observations" "$ R^2$" "DCB 7\% = Government 7\%" "DCB 7\% = Opposition 7\%" ///
  "Government 7\% = Opposition 7\%" "DCB 5\% = Government 5\%" "DCB 5\% = Opposition 5\%" "Government 5\% = Opposition 5\%" "Outcome mean" "Outcome std. dev." "Current unemployment estimate mean") ///
  fmt(0 2 2 2 2 2 2 2 2 2 2)) starlevels(* 0.1 ** 0.05 *** 0.01) varlabel(_cons "Control" 2.treatment "DCB 7\% treatment (combined)" 3.treatment "DCB 5\% treatment" 4.treatment "Government 7\% treatment" ///
  5.treatment "Government 5\% treatment" 6.treatment "Opposition 7\% treatment" 7.treatment "Opposition 5\% treatment")



*** Table 2: IV economic voting results

eststo clear
quietly foreach y of varlist gov socdem soclib socpeo right venstre { 
  eststo, title("`y'"): xi: ivreg2 `y' (urate_fut = i.treatment) urate_now, ro first
  summ `y' if e(sample)==1
  estadd scalar Mean=`r(mean)'
  summ urate_fut if e(sample)==1
  estadd scalar ExpectMean=`r(mean)'
  estadd scalar ExpectSD=`r(sd)'
  matrix A = e(first)
  estadd scalar F_stat = A[3,1]
}
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) stats(N F_stat r2 Mean ExpectMean ExpectSD, label("Observations" "First stage $ F$ statistic" "$ R^2$" "Outcome mean" "Unemployment expectations means" ///
  "Unemployment expectations std. dev.") fmt(0 2 2 2 2 2)) keep(urate_fut) label starlevels(* 0.1 ** 0.05 *** 0.01) varlabel(urate_fut "Unemployment expectations (\%)")



*** Table 3: Economic voting by subgroup

g nonswing = swing==0 if swing!=.
g nonswing2 = swing2==0 if swing2!=.
g nonlower_imm_ben = lower_imm_ben==0 if lower_imm_ben!=.

eststo clear
quietly foreach s of varlist unsophist sophist nonswing swing nonlower_imm_ben lower_imm_ben {
  eststo, title("`s'"): xi: ivreg2 gov (urate_fut = i.treatment) urate_now if `s'==1, ro first
  summ gov if e(sample)==1
  estadd scalar Mean=`r(mean)'
  summ urate_fut if e(sample)==1
  estadd scalar ExpectMean=`r(mean)'
  estadd scalar ExpectSD=`r(sd)'
  matrix A = e(first)
  estadd scalar F_stat = A[3,1]
}
noisily estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) stats(N F_stat r2 Mean ExpectMean ExpectSD, label("Observations" "First stage $ F$ statistic" "$ R^2$" "Outcome mean" "Unemployment expectations means" ///
  "Unemployment expectations std. dev.") fmt(0 2 2 2 2 2)) keep(urate_fut) label starlevels(* 0.1 ** 0.05 *** 0.01) varlabel(urate_fut "Unemployment expectations (\%)")



*** Table 4: Economic voting mechanisms

eststo clear
quietly foreach s of varlist all unsophist sophist { 
  eststo, title("`y'"): xi: ivreg2 confidence_gov (urate_fut = i.treatment) urate_now if `s'==1, ro first
  summ confidence_gov if e(sample)==1
  estadd scalar Mean=`r(mean)'
  estadd scalar StdDev=`r(sd)'
  summ urate_fut if e(sample)==1
  estadd scalar ExpectMean=`r(mean)'
  estadd scalar ExpectSD=`r(sd)'
  matrix A = e(first)
  estadd scalar F_stat = A[3,1]
}
quietly foreach y of varlist redist uinsure redgreen { 
  eststo, title("`y'"): xi: ivreg2 `y' (urate_fut = i.treatment) urate_now, ro first
  summ `y' if e(sample)==1
  estadd scalar Mean=`r(mean)'
  estadd scalar StdDev=`r(sd)'
  summ urate_fut if e(sample)==1
  estadd scalar ExpectMean=`r(mean)'
  estadd scalar ExpectSD=`r(sd)'
  matrix A = e(first)
  estadd scalar F_stat = A[3,1]
}
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) stats(N F_stat r2 Mean StdDev ExpectMean ExpectSD, label("Observations" "First stage $ F$ statistic" "$ R^2$" "Outcome mean" "Outcome standard deviation" "Unemployment expectations means" ///
  "Unemployment expectations std. dev.") fmt(0 2 2 2 2 2)) keep(urate_fut) label starlevels(* 0.1 ** 0.05 *** 0.01) varlabel(urate_fut "Unemployment expectations (\%)")


  









***************************************************** ONLINE APPENDIX *****************************************************

*** Set the relevant working directory

cd "C:\Users\jmarshall\Dropbox\Denmark project\Data and Analysis\"



*** Load the dataset used throughout the analysis; the creation of the dataset is described in the Online Appendix

use "Danish Panel Survey.dta", clear



*** Coding up key variables

g sophist = urate_now>=5 & urate_now<=8 & urate_now!=.
g unsophist = urate_now<5 & urate_now!=. | urate_now>8 & urate_now!=.

g over = urate_now>7 & urate_now!=.
g under = urate_now<5 & urate_now!=.
g between = urate_now>=5 & urate_now<=7 & urate_now!=.



*** Table A1: Summary statistics

*xi: summ urate_fut urate_now i.treatment sophist i.party confidence_gov redist uinsure swing swing2 news_always prospects_den_dummy urate_parish imm_parish imm_muni i.edu woman yob discuss lastgov lastleft lastright secondlastleft secondlastright extreme_redist_pos_2012 discuss logwage logincome_expected tenure jobrisk riskaverse lower_imm_ben
* Cannot be exactly replicated without the register education variable and local immigration and unemployment variables
xi: summ urate_fut urate_now i.treatment sophist i.party confidence_gov redist uinsure swing swing2 news_always prospects_den_dummy woman yob discuss lastgov lastleft lastright secondlastleft secondlastright extreme_redist_pos_2012 discuss logwage logincome_expected tenure jobrisk riskaverse lower_imm_ben



*** Table A2: Correlation between absolute deviation and standard measures of sophistication
* Cannot be replicated without the register education variable

g devi = abs(urate_now - 6.5)
*eststo clear
*quietly eststo: reg devi news logwage i.edu discuss, ro
*quietly eststo: reg devi news logwage i.edu discuss informed, ro
*quietly eststo: reg devi news logwage i.edu discuss informed math_test, ro
*estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) label stats(N Test, fmt(0 2)) starlevels(* 0.1 ** 0.05 *** 0.01)



*** Table A3: Correlation between our sophistication measure and standard measures of sophistication
* Cannot be replicated without the register education variable

*eststo clear
*quietly eststo: reg sophist news logwage i.edu discuss, ro
*quietly eststo: reg sophist news logwage i.edu discuss informed, ro
*quietly eststo: reg sophist news logwage i.edu discuss informed math_test, ro
*estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) label stats(N Test, fmt(0 2)) starlevels(* 0.1 ** 0.05 *** 0.01)



*** Tables A4 and A5: Current unemployment deviation is a sufficient statistic for standard measures of sophistication
* Cannot be replicated without the register education variable

*reg urate_fut i.treatment##c.news i.treatment##c.discuss i.treatment##c.logwage i.treatment##i.edu, ro
*reg urate_fut i.treatment##c.devi i.treatment##c.news i.treatment##c.discuss i.treatment##c.logwage i.treatment##i.edu, ro



*** Table A6: Sophistication is not correlated with partisanship

eststo clear
quietly eststo: reg devi lastleft, ro
quietly eststo: reg sophist lastleft, ro
quietly eststo: reg devi lastright, ro
quietly eststo: reg sophist lastright, ro
quietly eststo: reg devi secondlastleft, ro
quietly eststo: reg sophist secondlastleft, ro
quietly eststo: reg devi secondlastright, ro
quietly eststo: reg sophist secondlastright, ro
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) label stats(N Test, fmt(0 2)) starlevels(* 0.1 ** 0.05 *** 0.01)



*** Tables A7 and A8: Balance tests

eststo clear 
*quietly foreach y of varlist urate_now woman yob edu_basic edu_medium edu_long lastleft {
* Cannot be exactly replicated without the register education variable
quietly foreach y of varlist urate_now woman yob lastleft {
  eststo, title("`y'"): xi: reg `y' i.treatment, ro
  test _Itreatment_2 _Itreatment_3 _Itreatment_4 _Itreatment_5 _Itreatment_6 _Itreatment_7 _Itreatment_8
  estadd scalar Test=`r(p)'
}
estout, cells(b(star fmt(3)) se(par fmt(3))) label stats(N Test, fmt(0 2)) starlevels(* 0.1 ** 0.05 *** 0.01)
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) label stats(N Test, fmt(0 2)) starlevels(* 0.1 ** 0.05 *** 0.01)

eststo clear 
quietly foreach y of varlist lastright logwage logincome_expected homeowner prospects_den tenure jobrisk lastgov {
  eststo, title("`y'"): xi: reg `y' i.treatment, ro
  test _Itreatment_2 _Itreatment_3 _Itreatment_4 _Itreatment_5 _Itreatment_6 _Itreatment_7 _Itreatment_8
  estadd scalar Test=`r(p)'
}
estout, cells(b(star fmt(3)) se(par fmt(3))) label stats(N Test, fmt(0 2)) starlevels(* 0.1 ** 0.05 *** 0.01)
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) label stats(N Test, fmt(0 2)) starlevels(* 0.1 ** 0.05 *** 0.01)



*** Figures A2 and A3: Monotonicity checks

preserve
quietly foreach x of numlist 1/8 {
  cumul urate_fut if treatment==`x', g(c_treatment_`x')
}
stack c_treatment_1 urate_fut c_treatment_2 urate_fut c_treatment_3 urate_fut c_treatment_4 urate_fut c_treatment_5 urate_fut c_treatment_6 urate_fut c_treatment_7 urate_fut c_treatment_8 urate_fut, into(c urate_fut_new) wide clear
label var c_treatment_1 "Control"
label var c_treatment_2 "DCB 7% treatment"
label var c_treatment_3 "DCB 5% treatment"
label var c_treatment_4 "Government 7% treatment"
label var c_treatment_5 "Government 5% treatment"
label var c_treatment_6 "Opposition 7% treatment"
label var c_treatment_7 "Opposition 5% treatment"
label var c_treatment_8 "DCB 7% treatment (true)"
line c_treatment_1 c_treatment_2 c_treatment_3 c_treatment_8 urate_fut_new, sort xtitle("Unemployment expectations (%)") ytitle("Cumulative density") graphregion(fcolor(white) lcolor(white)) ylab(, nogrid)
line c_treatment_1 c_treatment_4 c_treatment_5 c_treatment_6 c_treatment_7 urate_fut_new, sort xtitle("Unemployment expectations (%)") ytitle("Cumulative density") graphregion(fcolor(white) lcolor(white)) ylab(, nogrid)
restore



*** Table A9: Exclusion restriction test

eststo clear
g info_important = news_import!=4 if news_import!=.
quietly eststo: reg info_important i.treatment, ro
g treated = treatment>1 & treatment!=.
quietly eststo: reg info_important treated, ro
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) label stats(N Test, fmt(0 2)) starlevels(* 0.1 ** 0.05 *** 0.01)



*** Table A10: Trust in sources

replace treatment = 2 if treatment==8

foreach i in dcb gov opp {
  g trust_`i' = confidence_`i'>3
}

eststo clear
eststo: reg trust_dcb i.treatment $controls if treatment<=3 | treatment==8, ro
eststo: reg trust_gov i.treatment $controls if treatment==1 | treatment==4 | treatment==5, ro
eststo: reg trust_opp i.treatment $controls if treatment==1 | treatment==6 | treatment==7, ro
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) label stats(N Test, fmt(0 2)) starlevels(* 0.1 ** 0.05 *** 0.01)



*** Table A11: Unemployment expectations by direction of expected updating

eststo clear
quietly foreach s of varlist over between under {
  eststo, title("`s'") : reg urate_fut i.treatment if `s'==1, ro
  summ urate_fut if e(sample)==1
  estadd scalar Mean=`r(mean)'
  estadd scalar SD=`r(sd)'
  summ urate_now if e(sample)==1
  estadd scalar MeanPrior=`r(mean)'
  test 2.treatment==4.treatment
  estadd scalar Test_1=`r(p)'
  test 2.treatment==6.treatment
  estadd scalar Test_2=`r(p)'
  test 4.treatment==6.treatment
  estadd scalar Test_3=`r(p)'
  test 3.treatment==5.treatment
  estadd scalar Test_4=`r(p)'
  test 3.treatment==7.treatment
  estadd scalar Test_5=`r(p)'
  test 5.treatment==7.treatment
  estadd scalar Test_6=`r(p)'
}
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) keep(_cons 2.treatment 3.treatment 4.treatment 5.treatment 6.treatment 7.treatment) order(_cons) ///
  label stats(N r2 Test_1 Test_2 Test_3 Test_4 Test_5 Test_6 Mean SD MeanPrior, label("Observations" "$ R^2$" "DCB 7\% = Government 7\%" "DCB 7\% = Opposition 7\%" ///
  "Government 7\% = Opposition 7\%" "DCB 5\% = Government 5\%" "DCB 5\% = Opposition 5\%" "Government 5\% = Opposition 5\%" "Outcome mean" "Outcome std. dev." "Current unemployment estimate mean") ///
  fmt(0 2 2 2 2 2 2 2 2 2 2)) starlevels(* 0.1 ** 0.05 *** 0.01) varlabel(_cons "Control" 2.treatment "DCB 7\% treatment (combined)" 3.treatment "DCB 5\% treatment" 4.treatment "Government 7\% treatment" ///
  5.treatment "Government 5\% treatment" 6.treatment "Opposition 7\% treatment" 7.treatment "Opposition 5\% treatment")



*** Table A12: Heterogeneous updating by partisanship

eststo clear
eststo: reg urate_fut i.treatment##lastleft, ro
eststo: reg urate_fut i.treatment##lastright, ro
eststo: reg urate_fut i.treatment##secondlastleft, ro
eststo: reg urate_fut i.treatment##secondlastright, ro
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) label stats(N Test, fmt(0 2)) starlevels(* 0.1 ** 0.05 *** 0.01)



*** Table A13: Partisanship and sophistication

eststo clear
eststo: reg urate_fut i.treatment##sophist##lastleft, ro
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) label stats(N Test, fmt(0 2)) starlevels(* 0.1 ** 0.05 *** 0.01)



*** Table A14: Other measures of sophistication - unemployment expectations
* Cannot be replicated without the register education variable

*g educated = edu>=2 if edu!=.
g news_every_day = news==6 if news!=.
g discuss_often = discuss>=3 if discuss!=.
summ logwage if urate_fut!=., detail
g rich = logwage>=`r(p50)' & urate_fut!=.
*xi: alpha news discuss edu logwage informed if urate_fut!=., std g(info_scale)
*summ info_scale if urate_fut!=., detail
*g high = info_scale>=`r(p50)' & urate_fut!=.
*g low = info_scale<`r(p50)' & urate_fut!=.

*eststo clear
*quietly foreach s of varlist low high {
*  eststo, title("`s'") : reg urate_fut i.treatment if `s'==1, ro
*  summ urate_fut if e(sample)==1
*  estadd scalar Mean=`r(mean)'
*  estadd scalar SD=`r(sd)'
*  summ urate_now if e(sample)==1
*  estadd scalar MeanPrior=`r(mean)'
*  test 2.treatment==4.treatment
*  estadd scalar Test_1=`r(p)'
*  test 2.treatment==6.treatment
*  estadd scalar Test_2=`r(p)'
*  test 4.treatment==6.treatment
*  estadd scalar Test_3=`r(p)'
*  test 3.treatment==5.treatment
*  estadd scalar Test_4=`r(p)'
*  test 3.treatment==7.treatment
*  estadd scalar Test_5=`r(p)'
*  test 5.treatment==7.treatment
*  estadd scalar Test_6=`r(p)'
*}
*estout, cells(b(star fmt(3)) se(par fmt(3))) keep(_cons 2.treatment 3.treatment 4.treatment 5.treatment 6.treatment 7.treatment) order(_cons) ///
*  label stats(N r2 Test_1 Test_2 Test_3 Test_4 Test_5 Test_6 Mean SD MeanPrior, label("Observations" "$ R^2$" "Test: DCB 7\% = Government 7\%" "Test: DCB 7\% = Opposition 7\%" ///
*  "Test: Government 7\% = Opposition 7\%" "Test: DCB 5\% = Government 5\%" "Test: DCB 5\% = Opposition 5\%" "Test: Government 5\% = Opposition 5\%" "Outcome mean" "Outcome std. dev." "Current unemployment estimate mean") ///
*  fmt(0 2 2 2 2 2 2 2 2 2 2)) starlevels(* 0.1 ** 0.05 *** 0.01)



*** Table A15: Characteristics of different types of voters

g nonswing = swing==0 if swing!=.
g nonswing2 = swing2==0 if swing2!=.

foreach x of varlist unsophist sophist swing nonswing swing2 nonswing2 {
  di "Voter type = `x'"
*  summ news logwage i.edu discuss math_test lastleft lastright if `x'==1
* Cannot be fully replicated without the register education variable
  summ news logwage discuss math_test lastleft lastright if `x'==1
}



*** Table A16: Unemployment expectations, controlling for current unemployment estimate

eststo clear
eststo: reg urate_fut i.treatment urate_now, ro
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) order(_cons) ///
  label stats(N r2, label("Observations" "$ R^2$") ///
  fmt(0 2 2)) starlevels(* 0.1 ** 0.05 *** 0.01) varlabel(_cons "Control" 2.treatment "DCB 7\% treatment (combined)" 3.treatment "DCB 5\% treatment" 4.treatment "Government 7\% treatment" ///
  5.treatment "Government 5\% treatment" 6.treatment "Opposition 7\% treatment" 7.treatment "Opposition 5\% treatment" urate_now "Current unemployment estimate")



*** Table A17: Reduced form estimates

eststo clear
quietly foreach y of varlist gov socdem soclib socpeo confidence_gov redgreen right venstre redist uinsure { 
  eststo, title("`y'"): reg `y' i.treatment urate_now, ro
}
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) order(_cons) ///
  label stats(N r2, label("Observations" "$ R^2$") ///
  fmt(0 2 2)) starlevels(* 0.1 ** 0.05 *** 0.01) varlabel(_cons "Control" 2.treatment "DCB 7\% treatment (combined)" 3.treatment "DCB 5\% treatment" 4.treatment "Government 7\% treatment" ///
  5.treatment "Government 5\% treatment" 6.treatment "Opposition 7\% treatment" 7.treatment "Opposition 5\% treatment" urate_now "Current unemployment estimate")

g treatment_7 = treatment==2 | treatment==4 | treatment==6
g treatment_5 = treatment==3 | treatment==5 | treatment==7
  
eststo clear
quietly foreach y of varlist gov socdem soclib socpeo confidence_gov redgreen right venstre redist uinsure { 
  eststo, title("`y'"): reg `y' treatment_7 treatment_5 urate_now, ro
}
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) order(_cons) ///
  label stats(N r2, label("Observations" "$ R^2$") ///
  fmt(0 2 2)) starlevels(* 0.1 ** 0.05 *** 0.01) varlabel(treatment_7 "All 7\% treatments" treatment_5 "All 5\% treatments" urate_now "Current unemployment estimate")



*** Table A18: IV estimates without controlling for current unemployment estimate

eststo clear
quietly foreach y of varlist gov socdem soclib socpeo right venstre { 
  eststo, title("`y'"): xi: ivreg2 `y' (urate_fut = i.treatment), ro first
  summ `y' if e(sample)==1
  estadd scalar Mean=`r(mean)'
  summ urate_fut if e(sample)==1
  estadd scalar ExpectMean=`r(mean)'
  estadd scalar ExpectSD=`r(sd)'
  matrix A = e(first)
  estadd scalar F_stat = A[3,1]
}
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) stats(N F_stat r2 Mean ExpectMean ExpectSD, label("Observations" "First stage $ F$ statistic" "$ R^2$" "Outcome mean" "Unemployment expectations means" ///
  "Unemployment expectations std. dev.") fmt(0 2 2 2 2 2)) keep(urate_fut) label starlevels(* 0.1 ** 0.05 *** 0.01) varlabel(urate_fut "Unemployment expectations (\%)")



*** Table A19: Differences in economic voting by group

g nonextreme = extreme==0 if extreme!=.
g not_every_day = news<=5

eststo clear
*quietly foreach s of varlist low high lastleft lastright swing nonswing nonextreme extreme {
* Cannot be replicated without the register education variable
quietly foreach s of varlist lastleft lastright swing nonswing nonextreme extreme {
  eststo, title("`s'"): xi: ivreg2 gov (urate_fut = i.treatment) urate_now if `s'==1, ro first
  summ gov if e(sample)==1
  estadd scalar Mean=`r(mean)'
  summ urate_fut if e(sample)==1
  estadd scalar ExpectMean=`r(mean)'
  estadd scalar ExpectSD=`r(sd)'
  matrix A = e(first)
  estadd scalar F_stat = A[3,1]
}
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) stats(N F_stat r2 Mean ExpectMean ExpectSD, label("Observations" "First stage $ F$ statistic" "$ R^2$" "Outcome mean" "Unemployment expectations means" ///
  "Unemployment expectations std. dev.") fmt(0 2 2 2 2 2)) keep(urate_fut) label starlevels(* 0.1 ** 0.05 *** 0.01) varlabel(urate_fut "Unemployment expectations (\%)")



*** Table A20: Interaction with immigrant shares

*eststo clear
*quietly foreach s of varlist imm_parish imm_muni {
* Cannot be replicated without the register immigration variables
*  eststo, title("`s'"): xi: ivreg2 gov (urate_fut = i.treatment) urate_now if `s'==1, ro first
*  summ gov if e(sample)==1
*  estadd scalar Mean=`r(mean)'
*  summ urate_fut if e(sample)==1
*  estadd scalar ExpectMean=`r(mean)'
*  estadd scalar ExpectSD=`r(sd)'
*  matrix A = e(first)
*  estadd scalar F_stat = A[3,1]
*}
*estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) stats(N F_stat r2 Mean ExpectMean ExpectSD, label("Observations" "First stage $ F$ statistic" "$ R^2$" "Outcome mean" "Unemployment expectations means" ///
*  "Unemployment expectations std. dev.") fmt(0 2 2 2 2 2)) keep(urate_fut) label starlevels(* 0.1 ** 0.05 *** 0.01) varlabel(urate_fut "Unemployment expectations (\%)")
