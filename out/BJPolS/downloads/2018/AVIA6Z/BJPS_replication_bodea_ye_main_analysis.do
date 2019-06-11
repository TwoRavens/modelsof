
******************************************************************************************
*** Bilateral Investment Treaties (BITs):The Global Investment Regime and Human Rights ***
***      Cristina Bodea and Fangjin Ye, British Journal of Political Science           ***
***                              Replication file (Main Analysis)                      ***
******************************************************************************************


///open the stata data file "BJPS_replication_bodea_ye.dta"
xtset ccode year 
gen polity2_cum_ratify_adjust=polity2*cum_ratify_adjust
gen cum_ratify_icsid2_pol = cum_ratify_icsid2 * polity2
gen cum_ratify_icsid21= cum_ratify_icsid2 + cum_ratify_icsid1
gen cum_ratify_icsid21_pol = cum_ratify_icsid21 * polity2
gen cum_n_s_more_pol = cum_n_s_more * polity2
gen cum_n_s_pol = cum_n_s * polity2
gen conti_cum_ratify_icsid21 = conti_cum_ratify_icsid2+conti_cum_ratify_icsid1
gen icsid21_other_3yrs = icsid2_other_3yrs + icsid1_other_3yrs
gen polity2_neighbor_all = polity2 * SL_neighbor_ratify_all
gen polity2_move_total_3yr_newother = polity2 * move_total_3yr_newother
gen polity2_cum_ratify_forward_1990 = polity2 * cum_ratify_onforward_1990 

ren State_Dept PTS_StateDept
ren Amnesty PTS_Amnesty
sum PTS_Amnesty PTS_StateDept
gen pts_average = (PTS_Amnesty + PTS_StateDept)/2
replace pts_average = PTS_Amnesty if PTS_StateDept==.
replace pts_average = PTS_StateDept if PTS_Amnesty==.
sum pts_average 
gen pts_average_invert = 6 - pts_average
replace PTS_Amnesty = PTS_StateDept if PTS_Amnesty==.
gen pts_amnesty_invert = 6 - PTS_Amnesty
replace PTS_StateDept = PTS_Amnesty if PTS_StateDept==.
gen pts_statedept_invert = 6 - PTS_StateDept

gen polity2_conti_icsid2 = polity2 * conti_cum_ratify_icsid2
gen polity2_icsid2_world_other_3yr = polity2 * icsid2_other_3yrs
gen polity2_conti_n_s_more = polity2 * conti_cum_ratify_n_s_more
gen polity2_n_s_more_world_3yr = polity2 * n_s_more_other_3yrs

***************************************
****** main tables and figures ********
***************************************
///Table 2
xtpcse physint L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise corr(ar1)

xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)

xtivreg2 physint (L.cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtivreg2 physint (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother L.polity2_neighbor_all L.polity2_move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtpcse physint L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

///Figure 1
*Figure 1(a)
xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)

gen nr=_n-11
replace nr=. if nr>10
lab var nr "polity2"

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

* Create full range of marginal effects
gen conb1=b1+b3*nr

* Create full range of standard errors
gen conse1=sqrt(varb1+varb3*nr^2+2*covb1b3*nr)

* Generate confidence intervals at the 95% level
gen a1=1.96*conse1
gen top1=conb1+a1
gen bottom1=conb1-a1

* Plotting
graph twoway  (line conb1 nr if nr>-11 & nr<11, clwidth(medium) clcolor(blue) clcolor(black)) /*
*/  (line top1  nr if nr>-11 & nr<11, clpattern(dash) clwidth(thin) clcolor(black)) /*
*/  (line bottom1 nr if nr>-11 & nr<11, clpattern(dash) clwidth(thin) clcolor(black)), /*
*/  ytitle("Marginal effect of cumulative BITs", size(3.5)) /*
*/  xtitle("polity2 score", size(3.5)) /*
*/  title("Conditional effect of all cumulative BITs", size(5)) /*
*/  yscale(r(-.03 .01) noline) xscale(noline) ylabel(-.03 -.02 -.01 0 .01, labsize(3)) xlabel(-10 -5 0 5 10, labsize(3)) legend(col(1) order(1 2) label(1 "Marginal effect of cumulative BITs") label(2 "95% Confidence Interval") label(3 " ")) /*
*/  xsca(titlegap(2)) ysca(titlegap(2)) yline(0, lcolor(black)) yline(-.03 -.02 -.01 0 .01, lcolor(white))/*
*/  graphregion(fcolor(white)lcolor(white)icolor(white)ilcolor(white)ilstyle(none)color(white)) /*
*/  plotregion(fcolor(white)lcolor(white)icolor(white)ilcolor(white)ilstyle(none)color(white))

drop nr conb1 conse1 a1 top1 bottom1

*Figure 1(b)
xtivreg2 physint (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother L.polity2_neighbor_all L.polity2_move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

gen nr=_n-11
replace nr=. if nr>10
lab var nr "polity2"

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b2=V[1,2]
scalar covb2b3=V[2,3]

* Create full range of marginal effects
gen conb1=b1+b2*nr

* Create full range of standard errors
gen conse1=sqrt(varb1+varb2*nr^2+2*covb1b2*nr)

* Generate confidence intervals at the 95% level
gen a1=1.96*conse1
gen top1=conb1+a1
gen bottom1=conb1-a1

* Plotting
graph twoway  (line conb1 nr if nr>-11 & nr<11, clwidth(medium) clcolor(blue) clcolor(black)) /*
*/  (line top1  nr if nr>-11 & nr<11, clpattern(dash) clwidth(thin) clcolor(black)) /*
*/  (line bottom1 nr if nr>-11 & nr<11, clpattern(dash) clwidth(thin) clcolor(black)), /*
*/  ytitle("Marginal effect of cumulative BITs", size(3.5)) /*
*/  xtitle("polity2 score", size(3.5)) /*
*/  title("Conditional effect of all cumulative BITs - IV", size(5)) /*
*/  yscale(r(-.08 .02) noline) xscale(noline) ylabel(-.08 -.06 -.04 -0.02 0 .02, labsize(3)) xlabel(-10 -5 0 5 10, labsize(3)) legend(col(1) order(1 2) label(1 "Marginal effect of cumulative BITs") label(2 "95% Confidence Interval") label(3 " ")) /*
*/  xsca(titlegap(2)) ysca(titlegap(2)) yline(0, lcolor(black)) yline(-.08 -.06 -.04 -0.02 0 .02, lcolor(white))/*
*/  graphregion(fcolor(white)lcolor(white)icolor(white)ilcolor(white)ilstyle(none)color(white)) /*
*/  plotregion(fcolor(white)lcolor(white)icolor(white)ilcolor(white)ilstyle(none)color(white))

drop nr conb1 conse1 a1 top1 bottom1

*Figure 1(c)
xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

gen nr=_n-11
replace nr=. if nr>10
lab var nr "polity2"

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

* Create full range of marginal effects
gen conb1=b1+b3*nr

* Create full range of standard errors
gen conse1=sqrt(varb1+varb3*nr^2+2*covb1b3*nr)

* Generate confidence intervals at the 95% level
gen a1=1.96*conse1
gen top1=conb1+a1
gen bottom1=conb1-a1

* Plotting
graph twoway  (line conb1 nr if nr>-11 & nr<11, clwidth(medium) clcolor(blue) clcolor(black)) /*
*/  (line top1  nr if nr>-11 & nr<11, clpattern(dash) clwidth(thin) clcolor(black)) /*
*/  (line bottom1 nr if nr>-11 & nr<11, clpattern(dash) clwidth(thin) clcolor(black)), /*
*/  ytitle("Marginal effect of cumulative BITs", size(3.5)) /*
*/  xtitle("polity2 score", size(3.5)) /*
*/  title("Conditional effect of cumulative BITs with ICSID", size(5)) /*
*/  yscale(r(-.2 .05) noline) xscale(noline) ylabel(-.2 -.15 -.1 -.05 0 .05, labsize(3)) xlabel(-10 -5 0 5 10, labsize(3)) legend(col(1) order(1 2) label(1 "Marginal effect of cumulative BITs") label(2 "95% Confidence Interval") label(3 " ")) /*
*/  xsca(titlegap(2)) ysca(titlegap(2)) yline(0, lcolor(black)) yline(-.2 -.15 -.1 .05 0 .05, lcolor(white))/*
*/  graphregion(fcolor(white)lcolor(white)icolor(white)ilcolor(white)ilstyle(none)color(white)) /*
*/  plotregion(fcolor(white)lcolor(white)icolor(white)ilcolor(white)ilstyle(none)color(white))

drop nr conb1 conse1 a1 top1 bottom1

*Figure 1(d)
xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

gen nr=_n-11
replace nr=. if nr>10
lab var nr "polity2"

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

* Create full range of marginal effects
gen conb1=b1+b3*nr

* Create full range of standard errors
gen conse1=sqrt(varb1+varb3*nr^2+2*covb1b3*nr)

* Generate confidence intervals at the 95% level
gen a1=1.96*conse1
gen top1=conb1+a1
gen bottom1=conb1-a1

* Plotting
graph twoway  (line conb1 nr if nr>-11 & nr<11, clwidth(medium) clcolor(blue) clcolor(black)) /*
*/  (line top1  nr if nr>-11 & nr<11, clpattern(dash) clwidth(thin) clcolor(black)) /*
*/  (line bottom1 nr if nr>-11 & nr<11, clpattern(dash) clwidth(thin) clcolor(black)), /*
*/  ytitle("Marginal effect of cumulative BITs", size(3.5)) /*
*/  xtitle("polity2 score", size(3.5)) /*
*/  title("Conditional effect of cumulative adjusted North-South BITs ", size(5)) /*
*/  yscale(r(-.1 .02) noline) xscale(noline) ylabel(-.1 -.08 -.06 -.04 -.02 0 .02, labsize(3)) xlabel(-10 -5 0 5 10, labsize(3)) legend(col(1) order(1 2) label(1 "Marginal effect of cumulative BITs") label(2 "95% Confidence Interval") label(3 " ")) /*
*/  xsca(titlegap(2)) ysca(titlegap(2)) yline(0, lcolor(black)) yline(-.2 -.15 -.1 .05 0 .05, lcolor(white))/*
*/  graphregion(fcolor(white)lcolor(white)icolor(white)ilcolor(white)ilstyle(none)color(white)) /*
*/  plotregion(fcolor(white)lcolor(white)icolor(white)ilcolor(white)ilstyle(none)color(white))

drop nr conb1 conse1 a1 top1 bottom1

///Table 3
xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)

margins, at(L.cum_ratify_adjust=25 L.polity2=8 L.polity2_cum_ratify_adjust=200) ///
          at(L.cum_ratify_adjust=0 L.polity2=8 L.polity2_cum_ratify_adjust=0) post

test _b[1._at] = _b[2._at]
matrix betahat = e(b)matrix list betahatmatrix vcvhat = e(V)
matrix list vcvhat

*column difference = 4.6845859 - 4.9592735 = -.2746876
*95% confidence interval for column difference (manually calculated relying on information on variance and covariance)
*lower bound: 4.6845859 - 4.9592735 - 1.96*sqrt(.01147901+.00811804-2*.00403737) = -.48507797
*upper bound: 4.6845859 - 4.9592735 + 1.96*sqrt(.01147901+.00811804-2*.00403737) = -.06429723

xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)

margins, at(L.cum_ratify_adjust=25 L.polity2=-6 L.polity2_cum_ratify_adjust=-150) ///
          at(L.cum_ratify_adjust=0 L.polity2=-6 L.polity2_cum_ratify_adjust=0) post

test _b[1._at] = _b[2._at]
matrix betahat = e(b)matrix list betahatmatrix vcvhat = e(V)
matrix list vcvhat

*column difference = 3.3342318-3.9767952 = -.6425634
*95% confidence interval for column difference (manually calculated relying on information on variance and covariance)
*lower bound: 3.3342318-3.9767952 -1.96*sqrt(.01228265+.00917313-2*.00228367) = -.89727624
*upper bound: 3.3342318-3.9767952 -1.96*sqrt(.01228265+.00917313-2*.00228367) = -.38785056

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

margins, at(L.cum_ratify_icsid2=7 L.polity2=8 L.cum_ratify_icsid2_pol=56) ///
          at(L.cum_ratify_icsid2=0 L.polity2=8 L.cum_ratify_icsid2_pol=0) post

test _b[1._at] = _b[2._at]
matrix betahat = e(b)matrix list betahatmatrix vcvhat = e(V)
matrix list vcvhat

*column difference = 4.6227046 - 4.9524689 = -.3297643
*95% confidence interval for column difference (manually calculated relying on information on variance and covariance)
*lower bound: 4.6227046 - 4.9524689 -1.96*sqrt(.01310754+.00847078-2*.00353291) = -.56588126
*upper bound: 4.6227046 - 4.9524689 +1.96*sqrt(.01310754+.00847078-2*.00353291) = -.09364734

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

margins, at(L.cum_ratify_icsid2=7 L.polity2=-6 L.cum_ratify_icsid2_pol=-42) ///
          at(L.cum_ratify_icsid2=0 L.polity2=-6 L.cum_ratify_icsid2_pol=0) post

test _b[1._at] = _b[2._at]
matrix betahat = e(b)matrix list betahatmatrix vcvhat = e(V)
matrix list vcvhat

*column difference = 3.2775617 -  3.9384158 = -.6608541
*95% confidence interval for column difference (manually calculated relying on information on variance and covariance)
*lower bound: 3.2775617 -  3.9384158 -1.96*sqrt( .01933918+.008651-2*.00059977) = -.98166389
*upper bound: 3.2775617 -  3.9384158 +1.96*sqrt( .01933918+.008651-2*.00059977) = -.34004431

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

margins, at(L.cum_n_s_more=15 L.polity2=8 L.cum_n_s_more_pol=120) ///
          at(L.cum_n_s_more=0 L.polity2=8 L.cum_n_s_more_pol=0) post

test _b[1._at] = _b[2._at]
matrix betahat = e(b)matrix list betahatmatrix vcvhat = e(V)
matrix list vcvhat

*column difference = 4.638215 - 4.998563 = -.360348
*95% confidence interval for column difference (manually calculated relying on information on variance and covariance)
*lower bound: 4.638215 - 4.998563-1.96*sqrt(.01405324+.00919305-2*.00243569) = -.62603401
*upper bound: 4.638215 - 4.998563+1.96*sqrt(.01405324+.00919305-2*.00243569) = -.09466199

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

margins, at(L.cum_n_s_more=15 L.polity2=-6 L.cum_n_s_more_pol=-90) ///
          at(L.cum_n_s_more=0 L.polity2=-6 L.cum_n_s_more_pol=0) post

test _b[1._at] = _b[2._at]
matrix betahat = e(b)matrix list betahatmatrix vcvhat = e(V)
matrix list vcvhat

*column difference = 3.342476-3.9852075 = -.6427315
*95% confidence interval for column difference (manually calculated relying on information on variance and covariance)
*lower bound: 3.342476-3.9852075-1.96*sqrt(.01391194+.00963946-2*.00157863) = -.92263528
*upper bound: 3.342476-3.9852075+1.96*sqrt(.01391194+.00963946-2*.00157863) = -.36282772


