**STATA/SE 15.1**
use "SavunGinesteFinal.dta"


***** TABLE I: Cross-tabs *****
tab transnationalterrorismbin prevalencefinal, chi row nofreq


***** TABLE II: Competing Explanations *****
ologit  prevalencefinal  transnationalterrorism, cluster(ccode)
ologit  prevalencefinal  transnationalterrorism   democracybin lngdppc icrg_bq_l lnrefpopexcluded percentrefpop, cluster(ccode)
ologit  prevalencefinal  transnationalterrorism   physint lngdppc icrg_bq_l lnrefpopexcluded percentrefpop, cluster(ccode)


***** FIGURE 2: Competing Explanations: Substantive Effects *****
* panel A 
set scheme s2mono 
margins, at(transnationalterrorism=(0(1)80)) atmeans predict(outcome(0)) 
marginsplot ///
	, graphregion(fcolor(white)) ///
	title(" ") ytitle("Probability of no violence") xtitle("Transnational terrorist incidents") ///
	saving("Figure2a.gph", replace) 

* panel B
margins, at(transnationalterrorism=(0(1)80)) atmeans predict(outcome(2)) 
marginsplot ///
	, graphregion(fcolor(white)) ///
	title(" ") ytitle("Probability of prevalent violence") xtitle("Transnational terrorist incidents") ///
	saving("Figure2b.gph", replace) 

graph combine "Figure2a.gph" "Figure2b.gph", ysize(8) xsize(20) 


***** TABLE III: Competing Explanations: Substantive Effects *****
estsimp ologit  prevalencefinal  transnationalterrorism   democracybin lngdppc icrg_bq_l lnrefpopexcluded percentrefpop, cluster(ccode)
setx transnationalterrorism mean democracybin max lngdppc mean icrg_bq_l mean lnrefpopexcluded mean percentrefpop mean
simqi, fd(pr) changex(transnationalterrorism min max)
simqi, fd(pr) changex(democracybin min max)
simqi, fd(pr) changex(lngdppc min max)
simqi, fd(pr) changex(lnrefpopexcluded min max)
simqi, fd(pr) changex(icrg_bq_l min max)
simqi, fd(pr) changex(percentrefpop min max)


***** TABLE IV: Model 1 *****
gen prevalencefinaldummy2 = 0
recode prevalencefinaldummy2 0 =1 if prevalencefinal>1 

gen interaction = transnationalterrorism*democracy
logit  prevalencefinaldummy2  transnationalterrorism democracy interaction lngdppc icrg_bq_l lnrefpopexcluded percentrefpop, cluster(ccode)


***** Figure III *****
logit  prevalencefinaldummy2  transnationalterrorism democracy interaction lngdppc icrg_bq_l lnrefpopexcluded percentrefpop, cluster(ccode)

sum democracy,d
scalar dem_mean = r(mean)
scalar dem_sd = r(sd)
scalar dem_p10 = r(p10)
scalar dem_p18 = r(p10) + (r(p25)-r(p10))/2
scalar dem_p25 = r(p25)
scalar dem_p38 = r(p25) + (r(p50)-r(p25))/2
scalar dem_p50 = r(p50)
scalar dem_p63 = r(p50) + (r(p75)-r(p50))/2
scalar dem_p75 = r(p75)
scalar dem_p83 = r(p75) + (r(p90)-r(p75))/2
scalar dem_p90 = r(p90)

nlcom _b[transnationalterrorism] + _b[interaction]*dem_p10
mat b = r(b)
gen dem_p10_eff = b[1,1]
mat V = r(V)
gen dem_p10_se = sqrt(V[1,1])
nlcom _b[transnationalterrorism] + _b[interaction]*dem_p18
mat b = r(b)
gen dem_p18_eff = b[1,1]
mat V = r(V)
gen dem_p18_se = sqrt(V[1,1])
nlcom _b[transnationalterrorism] + _b[interaction]*dem_p25
mat b = r(b)
gen dem_p25_eff = b[1,1]
mat V = r(V)
gen dem_p25_se  = sqrt(V[1,1])
nlcom _b[transnationalterrorism] + _b[interaction]*dem_p38
mat b = r(b)
gen dem_p38_eff = b[1,1]
mat V = r(V)
gen dem_p38_se  = sqrt(V[1,1])
nlcom _b[transnationalterrorism] + _b[interaction]*dem_mean
mat b = r(b)
gen dem_pmean_eff = b[1,1]
mat V = r(V)
gen dem_pmean_se  = sqrt(V[1,1])
nlcom _b[transnationalterrorism] + _b[interaction]*dem_p50
mat b = r(b)
gen dem_p50_eff = b[1,1]
mat V = r(V)
gen dem_p50_se  = sqrt(V[1,1])
nlcom _b[transnationalterrorism] + _b[interaction]*dem_p63
mat b = r(b)
gen dem_p63_eff = b[1,1]
mat V = r(V)
gen dem_p63_se  = sqrt(V[1,1])
nlcom _b[transnationalterrorism] + _b[interaction]*dem_p75
mat b = r(b)
gen dem_p75_eff = b[1,1]
mat V = r(V)
gen dem_p75_se  = sqrt(V[1,1])
nlcom _b[transnationalterrorism] + _b[interaction]*dem_p83
mat b = r(b)
gen dem_p83_eff = b[1,1]
mat V = r(V)
gen dem_p83_se  = sqrt(V[1,1])
nlcom _b[transnationalterrorism] + _b[interaction]*dem_p90
mat b = r(b)
gen dem_p90_eff = b[1,1]
mat V = r(V)
gen dem_p90_se  = sqrt(V[1,1])

nlcom _b[transnationalterrorism] + _b[interaction]*dem_mean
mat b = r(b)
local mean_ci_eff = b[1,1]

gen mean_ci_eff = b[1,1]

nlcom _b[interaction]*(dem_p10 - dem_mean)
mat b = r(b)
gen mean_p10_diff = b[1,1]
mat V = r(V)
gen mean_p10_se  = sqrt(V[1,1])
nlcom _b[interaction]*(dem_p18 - dem_mean)
mat b = r(b)
gen mean_p18_diff = b[1,1]
mat V = r(V)
gen mean_p18_se  = sqrt(V[1,1])
nlcom _b[interaction]*(dem_p25 - dem_mean)
mat b = r(b)
gen mean_p25_diff = b[1,1]
mat V = r(V)
gen mean_p25_se  = sqrt(V[1,1])
nlcom _b[interaction]*(dem_p38 - dem_mean)
mat b = r(b)
gen mean_p38_diff = b[1,1]
mat V = r(V)
gen mean_p38_se  = sqrt(V[1,1])
nlcom _b[interaction]*(dem_p50 - dem_mean)
mat b = r(b)
gen mean_p50_diff = b[1,1]
mat V = r(V)
gen mean_p50_se  = sqrt(V[1,1])
nlcom _b[interaction]*(dem_p63 - dem_mean)
mat b = r(b)
gen mean_p63_diff = b[1,1]
mat V = r(V)
gen mean_p63_se  = sqrt(V[1,1])
nlcom _b[interaction]*(dem_p75 - dem_mean)
mat b = r(b)
gen mean_p75_diff = b[1,1]
mat V = r(V)
gen mean_p75_se  = sqrt(V[1,1])
nlcom _b[interaction]*(dem_p83 - dem_mean)
mat b = r(b)
gen mean_p83_diff = b[1,1]
mat V = r(V)
gen mean_p83_se  = sqrt(V[1,1])
nlcom _b[interaction]*(dem_p90 - dem_mean)
mat b = r(b)
gen mean_p90_diff = b[1,1]
mat V = r(V)
gen mean_p90_se  = sqrt(V[1,1])


gen percentile_dem = dem_p10
replace percentile_dem = dem_p18 if _n > 1
replace percentile_dem  = dem_p25 if _n > 2
replace percentile_dem = dem_p38 if _n > 3
replace percentile_dem = dem_mean if _n > 4
replace percentile_dem  = dem_p50 if _n > 5
replace percentile_dem = dem_p63 if _n > 6
replace percentile_dem  = dem_p75 if _n > 7
replace percentile_dem = dem_p83 if _n > 8
replace percentile_dem  = dem_p90 if _n > 9
replace percentile_dem = . if _n > 10


gen upper = mean_ci_eff + mean_p10_diff + 1.96*mean_p10_se
gen diff = mean_ci_eff + mean_p10_diff
replace upper = mean_ci_eff + mean_p18_diff + 1.96*mean_p18_se if _n > 1
replace diff = mean_ci_eff + mean_p18_diff if _n > 1
replace upper = mean_ci_eff + mean_p25_diff + 1.96*mean_p25_se if _n > 2
replace diff = mean_ci_eff + mean_p25_diff if _n > 2
replace upper = mean_ci_eff + mean_p38_diff + 1.96*mean_p38_se if _n > 3
replace diff = mean_ci_eff + mean_p38_diff if _n > 3
replace upper = mean_ci_eff if _n > 4
replace diff = mean_ci_eff if _n > 4
replace upper = mean_ci_eff + mean_p50_diff + 1.96*mean_p50_se if _n > 5
replace diff = mean_ci_eff + mean_p50_diff if _n > 5
replace upper = mean_ci_eff + mean_p63_diff + 1.96*mean_p63_se if _n > 6
replace diff = mean_ci_eff + mean_p63_diff if _n > 6
replace upper = mean_ci_eff + mean_p75_diff + 1.96*mean_p75_se if _n > 7
replace diff = mean_ci_eff + mean_p75_diff if _n > 7
replace upper = mean_ci_eff + mean_p83_diff + 1.96*mean_p83_se if _n > 8
replace diff = mean_ci_eff + mean_p83_diff if _n > 8
replace upper = mean_ci_eff + mean_p90_diff + 1.96*mean_p90_se if _n > 9
replace diff = mean_ci_eff + mean_p90_diff if _n > 9
replace upper = . if _n > 10

gen lower = mean_ci_eff + mean_p10_diff - 1.96*mean_p10_se
replace lower = mean_ci_eff + mean_p18_diff - 1.96*mean_p18_se if _n > 1
replace lower = mean_ci_eff + mean_p25_diff - 1.96*mean_p25_se if _n > 2
replace lower = mean_ci_eff + mean_p38_diff - 1.96*mean_p38_se if _n > 3
replace lower = mean_ci_eff if _n > 4
replace lower = mean_ci_eff + mean_p50_diff - 1.96*mean_p50_se if _n > 5
replace lower = mean_ci_eff + mean_p63_diff - 1.96*mean_p63_se if _n > 6
replace lower = mean_ci_eff + mean_p75_diff - 1.96*mean_p75_se if _n > 7
replace lower = mean_ci_eff + mean_p83_diff - 1.96*mean_p83_se if _n > 8
replace lower = mean_ci_eff + mean_p90_diff - 1.96*mean_p90_se if _n > 9
replace lower = . if _n > 10

gen upper3 = dem_p10_eff + 1.96*dem_p10_se
gen eff = dem_p10_eff
replace upper3 = dem_p18_eff + 1.96*dem_p18_se if _n > 1
replace eff = dem_p18_eff if _n > 1
replace upper3 = dem_p25_eff + 1.96*dem_p25_se if _n > 2
replace eff = dem_p25_eff if _n > 2
replace upper3 = dem_p38_eff + 1.96*dem_p38_se if _n > 3
replace eff = dem_p38_eff if _n > 3
replace upper3 = dem_pmean_eff + 1.96*dem_pmean_se if _n > 4
replace eff = dem_pmean_eff if _n > 4
replace upper3 = dem_p50_eff + 1.96*dem_p50_se if _n > 5
replace eff = dem_p50_eff if _n > 5
replace upper3 = dem_p63_eff + 1.96*dem_p63_se if _n > 6
replace eff = dem_p63_eff if _n > 6
replace upper3 = dem_p75_eff + 1.96*dem_p75_se if _n > 7
replace eff = dem_p75_eff if _n > 7
replace upper3 = dem_p83_eff + 1.96*dem_p83_se if _n > 8
replace eff = dem_p83_eff if _n > 8
replace upper3 = dem_p90_eff + 1.96*dem_p90_se if _n > 9
replace eff = dem_p90_eff if _n > 9
replace upper3 = . if _n > 10

gen lower3 = dem_p10_eff - 1.96*dem_p10_se
replace lower3 = dem_p18_eff - 1.96*dem_p18_se if _n > 1
replace lower3 = dem_p25_eff - 1.96*dem_p25_se if _n > 2
replace lower3 = dem_p38_eff - 1.96*dem_p38_se if _n > 3
replace lower3 = dem_pmean_eff - 1.96*dem_pmean_se if _n > 4
replace lower3 = dem_p50_eff - 1.96*dem_p50_se if _n > 5
replace lower3 = dem_p63_eff - 1.96*dem_p63_se if _n > 6
replace lower3 = dem_p75_eff - 1.96*dem_p75_se if _n > 7
replace lower3 = dem_p83_eff - 1.96*dem_p83_se if _n > 8
replace lower3 = dem_p90_eff - 1.96*dem_p90_se if _n > 9
replace lower3 = . if _n > 10

sort percentile_dem

nlcom _b[transnationalterrorism] + _b[interaction]*dem_mean
mat b = r(b)

gen m_eff = b[1,1]
gen zero = 0

twoway (rarea upper3 lower3 percentile_dem, col(gs10)), ylab(,nogrid) graphregion(fcolor(white)) xscale(range(0 10)) l2title(Conditional marginal effect, color(gs10)) l1title(Difference in conditional marginal effects, color(gs6)) xtitle(Values of the moderating variable) legend(off) || (rarea upper lower percentile_dem, col(gs6))  || (line zero percentile_dem, col(gs0) lpattern(solid)) || (line m_eff percentile_dem, col(gs0) lpattern(dash))

* In the graph editor, change x-axis to range -8 to 11 and change the number of ticks to 4
* The dashed line represent the marginal effect of TT at the mean level of democracy in the sample 
 

***** Table IV Model 2 *****
gen interaction2 = transnationalterrorism*recruitattack
logit prevalencefinaldummy2  transnationalterrorism recruitattack interaction2 icrg_bq_l democracy lngdppc percentrefpop, cluster(ccode)


***** Figure IV *****
drop upper lower z 

logit prevalencefinaldummy2  transnationalterrorism recruitattack interaction2 icrg_bq_l democracy lngdppc percentrefpop, cluster(ccode)

nlcom (exp(_b[transnationalterrorism]))
matrix b0 = r(b)
matrix V0 = r(V)
scalar eb0 = b0[1,1] 
scalar es0 = sqrt(V0[1,1])

nlcom (exp(_b[transnationalterrorism] + _b[interaction]))
matrix b1 = r(b)
matrix V1 = r(V)
scalar eb1 = b1[1,1] 
scalar es1 = sqrt(V1[1,1])

nlcom (exp((_b[transnationalterrorism] + _b[interaction])) / (exp(_b[transnationalterrorism])))
matrix b2 = r(b)
matrix V2 = r(V)
scalar eb2 = b2[1,1] 
scalar es2 = sqrt(V2[1,1])

gen upper = eb2 + 1.96*es2
gen upper90 = eb2 + 1.645*es2
gen upper80 = eb2 + 1.28*es2
gen mean = eb2
gen lower = eb2 - 1.96*es2
gen lower90 = eb2 - 1.645*es2
gen lower80 = eb2 - 1.28*es2
gen z = .1
replace upper = eb0 + 1.96*es0 if _n > 1
replace upper90 = eb0 + 1.645*es0 if _n > 1
replace upper80 = eb0 + 1.28*es0 if _n > 1
replace mean = eb0 if _n > 1
replace lower = eb0 -1.96*es0 if _n > 1
replace lower90 = eb0 - 1.645*es0 if _n > 1
replace lower80 = eb0 - 1.28*es0 if _n > 1
replace z = .5 if _n > 1
replace upper = eb1 + 1.96*es1 if _n > 2
replace upper90 = eb1 + 1.645*es0 if _n > 2
replace upper80 = eb1 + 1.28*es0 if _n > 2
replace mean = eb1 if _n > 2
replace lower = eb1 - 1.96*es1 if _n > 2
replace lower90 = eb1 - 1.645*es0 if _n > 2
replace lower80 = eb1 - 1.28*es0 if _n > 2
replace z = .9 if _n > 2
replace upper = . if _n > 3
replace upper90 = . if _n > 3
replace upper80 = . if _n > 3
replace mean = . if _n > 3
replace lower = . if _n > 3
replace lower90 = . if _n > 3
replace lower80 = . if _n > 3
replace z = . if _n > 3

twoway rspike upper upper90 z, xsc(r(0 1)) lw(.5) yline(1, lc(gray)) ylab(,nogrid) graphregion(fcolor(white)) ytitle(Marginal effects of terrorism on the odds of violence) xtitle("") xlab(.1 "Violence odds ratio" .5 "No refugee involvement" .9 "Refugee involvement") yline(0, lc(gs0) ax(1)) pstyle(p1) lc(gs0) yaxis(1) legend(off) || rspike upper90 mean z, bc(gs0) lw(.5)  || rspike mean lower90 z, bc(gs0) lw(.5) || rcap mean mean z, lw(.5) blc(gs0) bfc(gs0) msize(*2) || rcap upper upper z, lw(.5) blc(gs0) bfc(gs0) msize(*5) || rspike lower90 lower z, lw(.5) pstyle(p1) lc(gs0) yaxis(1) || rcap lower lower z, lw(.5) blc(gs0) bfc(gs0) msize(*5)

clear
