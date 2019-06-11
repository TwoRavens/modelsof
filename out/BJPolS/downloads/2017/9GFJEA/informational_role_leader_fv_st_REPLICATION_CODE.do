************************************************************************************
* The Informational Role of Party Leader Changes on Voter Perceptions of Party Positions
* Pablo Fernandez-Vazquez and Zeynep Somer-Topcu
* British Journal of Political Science
* REPLICATION CODE
* Author: Pablo Fernandez-Vazquez
* STATA 13
* December 2016
************************************************************************************


use informational_role_leader_fv_st.dta, clear

******************************************************************************************************************************************
**** 												EMPIRICAL ANALYSES -- MAIN TEXT							    					   ***
******************************************************************************************************************************************


**** TABLE 2 
* column 1 : Baseline
reg meanlr mlogrile l.meanlr i.countrynum
* column 2: Leader Change Effects
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum
* column 3: Parties in government
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if gov==1
* column 3: Parties in opposition
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if gov==0




**** FIGURE 1

* To make the graph look nicer, I label the values of leaderch 
label define leaders 0 "no" 1 "yes"
label values leaderch leaders
label var mlogrile "party platform" 
* To apply this too to the lagged dependent variable, I attach variable label
label var lmeanlr "lagged perceptions" 

* First I estimate the model of interest only for parties in opposition
quietly reg meanlr c.mlogrile##i.leaderch c.lmeanlr##i.leaderch i.countrynum if gov==0

* The I run the appropriate margins command
margins, dydx(mlogrile lmeanlr) at(leaderch=(0 1))
marginsplot, xline(0, lpattern( dot ) lcolor ( gs0 ) ) recast(scatter) title(Marginal Effects) ytitle(Change in Party Leader) plot1opts(mcolor(gs7) mfcolor(none)) plot2opts(mcolor(gs0) ) ci1opts( lcolor(gs7) ) ci2opts( lcolor(gs0) ) legend(order(3 "party platform" 4 "lagged perceptions")) graphregion(fcolor(white)) horizontal

graph export marginal_mlogrileANDlmeanlr_BYleaderch.pdf , replace




**** FIGURE 2 -- Long Term Effects (using dynsim)

* The Stata package dynsim requires Clarify
	net from http://gking.harvard.edu/clarify
	net install clarify
* Installing dynsim  --- Williams and Whitten. 2011. Dynamic Simulations of Autoregressive Relationships. The Stata Journal
	net sj 11-4 st0242
	net install st0242.pkg

* In order to use dynsim, the model must have been estimated using estsimp regress

set seed 2015 /* This sets the seed so that simulation results are stable */

estsimp regress meanlr lmeanlr mlogrile lmeanlr_leaderch mlogrile_leaderch leaderch denmark germany netherlands norway spain sweden if gov==0  	/* interaction opposition only */

dynsim , ldv(lmeanlr) scen1(lmeanlr 0 mlogrile 6 denmark 0 germany 0 netherlands 1 norway 0 spain 0 sweden 0) n(4) sig(95) shock(leaderch) shock_num(0 0 0 0 0) saving(longtermeffs1) modify(lmeanlr mlogrile) inter(lmeanlr_leaderch mlogrile_leaderch)
dynsim , ldv(lmeanlr) scen1(lmeanlr 0 mlogrile 6 denmark 0 germany 0 netherlands 1 norway 0 spain 0 sweden 0) n(4) sig(95) shock(leaderch) shock_num(1 0 0 0 0) saving(longtermeffs2) modify(lmeanlr mlogrile) inter(lmeanlr_leaderch mlogrile_leaderch)


* Creating the graph
preserve

use longtermeffs1.dta, clear
generate newleader = 0 /* indicator that signals a scenario where the leader does not change */
append using longtermeffs2.dta
replace newleader = 1 if newleader ==.

twoway (rarea lower_1 upper_1 t if newleader == 0, sort fcolor(gs14) lwidth(none)) (rarea lower_1 upper_1 t if newleader == 1, sort fcolor(gs14) lwidth(none)) (line pv_1 t if newleader == 0, sort lcolor(gs0)) (line pv_1 t if newleader == 1, sort lcolor(gs7)), ytitle(predicted left-right placement) xtitle(number of elections) title(Long-term evolution of the left-right image) legend(order(3 "no leader change" 4 "leader change at election 1")) graphregion(fcolor(white))

graph export longterm_simulation_statamade.pdf, replace

restore





**** TABLE 3

gen dmlogrile2 = sqrt(d.mlogrile^2) /* absolute shift in manifesto positions over two consecutive elections. Lowe 2011 logit measure */
ttest dmlogrile2, by(leaderch) unequal


**** TABLE 4
ttest mlogrile_SE, by(leaderch) unequal


**********************  TABLES IN THE APPENDIX

**** TABLE 7 -- Descriptive statistics
sum meanlr serrorlr mlogrile mlogrile_SE mrileratio mrile leaderch gov lastgovt niche meguidniche nichewagner length_tenure_year

**** TABLE 9 -- Test for serial correlation  -- Breusch-Godfrey test
reg meanlr L.meanlr mlogrile l.meanlr
predict double resid, residuals
quietly regress resid L.resid mlogrile l.meanlr

local bgodfrey=1- chi2(1,e(r2)*(e(N)-1))
display `bgodfrey' /* resulting p value: 0.34 --> so we cannot reject the null of NO SERIAL CORRELATION */
display e(r2)*(e(N)-1) /* This is the Breusch-Godfrey statistic , equal to N*R2, where N is equal to the number of observations minus the number of lags (1 in my case). Reference: https://en.wikipedia.org/wiki/Breusch%E2%80%93Godfrey_test */

drop resid


**** TABLE 10

* Column 1: OLS errors
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if gov==0
matrix olsoppV = e(V)

* Column 2: Party - clustered errors
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if gov==0, cluster(partynumeric)
matrix partyoppV = e(V)

* Column 3: Year - clustered errors
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if gov==0, cluster(year)	
matrix yearoppV = e(V)

* Column 4: election - clustered errors
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if gov==0, cluster(countryxyear)
matrix countryxyearoppV = e(V)



**** TABLE 11

* Std errors main variables in OLS model
scalar olsopprile = sqrt( olsoppV[1,1] ) 
scalar olsopprilexchange = sqrt(olsoppV[3,3]) 
scalar olsopplag = sqrt(olsoppV[4,4]) 
scalar olsopplagxchange = sqrt(olsoppV[6,6]) 
scalar olsoppleadch = sqrt( olsoppV[7,7] ) 
scalar olsoppintercept = sqrt( olsoppV[15,15] ) 

* Std errors main variables in party clustered-error model
scalar partyopprile = sqrt(partyoppV[1,1]) 
scalar partyopprilexchange = sqrt(partyoppV[3,3]) 
scalar partyopplag = sqrt(partyoppV[4,4]) 
scalar partyopplagxchange = sqrt(partyoppV[6,6]) 
scalar partyoppleadch = sqrt( partyoppV[7,7] ) 
scalar partyoppintercept = sqrt( partyoppV[15,15] ) 

* Std errors main variables in year clustered-error model
scalar yearopprile = sqrt(yearoppV[1,1]) 
scalar yearopprilexchange = sqrt(yearoppV[3,3]) 
scalar yearopplag = sqrt(yearoppV[4,4]) 
scalar yearopplagxchange = sqrt(yearoppV[6,6]) 
scalar yearoppleadch = sqrt( yearoppV[7,7] ) 
scalar yearoppintercept = sqrt( yearoppV[15,15] ) 

* Std errors main variables in election clustered-error model
scalar countryxyearopprile = sqrt(countryxyearoppV[1,1]) 
scalar countryxyearopprilexchange = sqrt(countryxyearoppV[3,3]) 
scalar countryxyearopplag = sqrt(countryxyearoppV[4,4]) 
scalar countryxyearopplagxchange = sqrt(countryxyearoppV[6,6]) 
scalar countryxyearoppleadch = sqrt( countryxyearoppV[7,7] ) 
scalar countryxyearoppintercept = sqrt( countryxyearoppV[15,15] ) 


* Table 11, column 1: Comparison PARTY cluster-robust std errors AND ols errors
display ( partyopprile - olsopprile ) / olsopprile 
display ( partyoppleadch - olsoppleadch ) / olsoppleadch 
display ( partyopprilexchange - olsopprilexchange ) / olsopprilexchange 
display ( partyopplag - olsopplag ) / olsopplag 
display ( partyopplagxchange - olsopplagxchange ) / olsopplagxchange
display ( partyoppintercept - olsoppintercept ) / olsoppintercept

*Table 11, column 2: Comparison YEAR cluster-robust std errors AND ols errors
display ( yearopprile - olsopprile ) / olsopprile 
display ( yearoppleadch - olsoppleadch ) / olsoppleadch 
display ( yearopprilexchange - olsopprilexchange ) / olsopprilexchange 
display ( yearopplag - olsopplag ) / olsopplag 
display ( yearopplagxchange - olsopplagxchange ) / olsopplagxchange
display ( yearoppintercept - olsoppintercept ) / olsoppintercept

* Table 11, column 3: Comparison ELECTION cluster-robust std errors AND ols errors
display ( countryxyearopprile - olsopprile ) / olsopprile 
display ( countryxyearoppleadch - olsoppleadch ) / olsoppleadch 
display ( countryxyearopprilexchange - olsopprilexchange ) / olsopprilexchange 
display ( countryxyearopplag - olsopplag ) / olsopplag 
display ( countryxyearopplagxchange - olsopplagxchange ) / olsopplagxchange
display ( countryxyearoppintercept - olsoppintercept ) / olsoppintercept


**** TABLE 12
reg meanlr mrile c.mrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if gov==1	/* column 1 */	
reg meanlr mrile c.mrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if gov==0	/* column 2 */


**** TABLE 13
reg meanlr mrileratio c.mrileratio#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if gov==1 /* column 1 */
reg meanlr mrileratio c.mrileratio#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if gov==0 /* column 2 */


**** TABLE 14 --- Estimated using SIMEX package in R. See file simex_analysis_bjps_replication.R


**** TABLE 15 --- Alternative indicator of presence in government (more restrictive definition of incumbency status)
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if lastgovt==1 /* column 1 */
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if lastgovt==0 /* column 2 */


**** TABLE 16 --- Results excluding niche parties
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if niche==0 & gov==0	/* column 1 */
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if meguidniche==0 & gov==0	/* column 2 */
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum if nichewagner==0 & gov==0	/* column 3 */

**** TABLE 17 --- Timing of leader changes
reg meanlr mlogrile c.mlogrile#c.length_tenure_year l.meanlr c.l.meanlr#c.length_tenure_year length_tenure_year i.countrynum if gov==0 & leaderch==1


**** TABLE 18 --- Wild cluster standard errors
/* cgmreg ado is needed to estimate wild cluster errors */
adopath
* Use the PLus path, then create a folder called 'c'
cd "~/Library/Application Support/Stata/ado/plus/c"
copy http://gelbach.law.upenn.edu/~gelbach/ado/cgmreg.ado cgmreg.ado , replace

findit unique.ado /* unique ado is needed to estimate wild cluster errors */
net describe unique, from(http://fmwww.bc.edu/RePEc/bocode/u)
net install unique.pkg

findit cgmwildboot
net describe clustse, from(http://fmwww.bc.edu/RePEc/bocode/c)
net install clustse

* Column 1
set seed 1
cgmwildboot meanlr mlogrile mlogrile_leaderch lmeanlr lmeanlr_leaderch leaderch denmark germany netherlands norway spain sweden if gov==0, cluster(partynumeric) bootcluster(partynumeric) /* this command does not allow i. dummy operators */
* Column 2
set seed 2
cgmwildboot meanlr mlogrile mlogrile_leaderch lmeanlr lmeanlr_leaderch leaderch denmark germany netherlands norway spain sweden if gov==0, cluster(year) bootcluster(year) /* this command does not allow i. dummy operators */
* Column 3
set seed 3
cgmwildboot meanlr mlogrile mlogrile_leaderch lmeanlr lmeanlr_leaderch leaderch denmark germany netherlands norway spain sweden if gov==0, cluster(countryxyear) bootcluster(countryxyear) /* this command does not allow i. dummy operators */



**** TABLE 19 --- Pairs-clusters standard errors --- CLUSTERBS command. It also requires ESTOUT command

findit estout
net describe estout, from(http://fmwww.bc.edu/RePEc/bocode/e)
net install estout

findit clusterbs
net describe clusterbs, from(http://fmwww.bc.edu/RePEc/bocode/c)
net install clusterbs

preserve
keep if gov==0 /* The clusterbs command does not allow for IF conditions */
set seed 4
clusterbs regress meanlr mlogrile mlogrile_leaderch lmeanlr lmeanlr_leaderch leaderch denmark germany netherlands norway spain sweden, cluster(partynumeric) 	/* Column 1  */
set seed 5
clusterbs regress meanlr mlogrile mlogrile_leaderch lmeanlr lmeanlr_leaderch leaderch denmark germany netherlands norway spain sweden, cluster(year) 	/* Column 2  */
set seed 6
clusterbs regress meanlr mlogrile mlogrile_leaderch lmeanlr lmeanlr_leaderch leaderch denmark germany netherlands norway spain sweden, cluster(countryxyear) 	/* Column 3  */
restore



**** TABLE 20 --- Standardized regression coefficients

* We first standardize the variables in the model
foreach variable in meanlr mlogrile leaderch {
sum `variable'
local a = r(mean)
local b = r(sd)
gen  `variable'_STD=(`variable' -`a')/`b'
}

* Now we estimate the models
reg meanlr_STD mlogrile_STD l.meanlr_STD i.countrynum 	/* Baseline Model */
reg meanlr_STD mlogrile_STD c.mlogrile_STD#i.leaderch l.meanlr_STD c.l.meanlr_STD#i.leaderch leaderch i.countrynum  /* Leader Change Effects */
reg meanlr_STD mlogrile_STD c.mlogrile_STD#i.leaderch l.meanlr_STD c.l.meanlr_STD#i.leaderch leaderch i.countrynum if gov==1 	/* parties in government */	
reg meanlr_STD mlogrile_STD c.mlogrile_STD#i.leaderch l.meanlr_STD c.l.meanlr_STD#i.leaderch leaderch i.countrynum if gov==0 	/* parties in opposition */


**** TABLE 21

foreach pais in Britain Denmark Germany Netherlands Norway Spain Sweden{
quietly reg meanlr c.mlogrile##i.leaderch##i.gov c.l.meanlr##i.leaderch##i.gov i.countrynum if country!="`pais'"
margins, dydx(mlogrile) at(gov=(0 1) leaderch=(0 1))
tab country if country== "`pais'"
}


**** TABLE 22 --- Triple interaction model
reg meanlr c.mlogrile##i.leaderch##i.gov c.l.meanlr##i.leaderch##i.gov i.countrynum##i.gov 	/* triple interaction */

**** TABLE 23
margins, dydx(mlogrile) at(gov=(0 1) leaderch=(0 1))

**** TABLE 24
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum l.pervote i.parfam i.year length_tenure timing_ch if gov==1, /* column 1 */
reg meanlr mlogrile c.mlogrile#i.leaderch l.meanlr c.l.meanlr#i.leaderch leaderch i.countrynum l.pervote i.parfam i.year length_tenure timing_ch if gov==0, /* column 2 */



**************************************************************************************************************
**************************************************************************************************************
**************************************************************************************************************
**************************************************************************************************************
**************************************************************************************************************
**************************************************************************************************************
**************************************************************************************************************
**************************************************************************************************************

