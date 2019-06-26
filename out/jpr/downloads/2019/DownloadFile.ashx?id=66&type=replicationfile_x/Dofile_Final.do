****************************************************************
*                                                              *  
* Blame the victims?                                           *
*                                                              *
* Refugees, state capacity, and non-state actor violence       *
*                                                              *
* Tobias Böhmelt, Vincenzo Bove, and Kristian Skrede Gleditsch *   
*                                                              *
* This Version: July 5, 2018                                   *
*                                                              *
****************************************************************

cd "C:\Users\tbohmelt\Dropbox\Refugees and Non-State Actor Conflict\Data"

* cd "/Users/tobiasbohmelt/Dropbox/Refugees and Non-State Actor Conflict/Data/"

use "Main Data.dta", clear

**************************
* Descriptive Statistics *
**************************

sum onset_final ncsyrs ncsyrs2 ncsyrs3 c.l.ln_refugees##c.l.i_wgi l.ln_population l.xpolity l.xpolity_sq l.ep_i

preserve 

gen v1=l.ln_refugees
gen v2=l.i_wgi
gen v3=v1*v2
gen v4=l.ln_population
gen v5=l.xpolity
gen v6=l.xpolity_sq
gen v7=l.ep_i

collin v1 v2 v4-v7

pwcorr onset_final l.ln_refugees, sig
pwcorr onset_final l.i_wgi, sig

xtile quart1 = l.ln_refugees, nq(4)
xtile quart2 = l.i_wgi, nq(2)
tab onset_final quart1 if quart2==1
tab onset_final quart1 if quart2==2

restore

***************
* Main Models *
***************

preserve

gen v2=l.i_wgi
generate where = -0.015
generate pipe = "|"

tab nominal
gen all=0
replace all=1 if nominal>0 & nominal!=.
replace all=. if nominal==.
btscs all year ccode, g(peaceyrs)
gen peaceyrs2=peaceyrs*peaceyrs
gen peaceyrs3=peaceyrs2*peaceyrs

mlogit nominal c.l.ln_refugees##c.l.i_wgi l.ln_population l.xpolity l.xpolity_sq l.ep_i peaceyrs peaceyrs2 peaceyrs3, cluster(ccode) level(95)
sum l.i_wgi if e(sample)
drop if v2<-1.9 & v2!=.
drop if v2>2.25 & v2!=.
margins, pr(out(1)) dydx(l.ln_refugees) at (l.i_wgi=(-1.9(0.25)2.25))
marginsplot, yline(0) level(95) name(graph1, replace) addplot (scatter where v2 if e(sample), xlabel(-2(0.5)2.5) ms(none) blcolor(gray) mlabel(pipe) mlabpos(0)) legend(off) scheme(lean1) aspectratio(1)

margins, pr(out(2)) dydx(l.ln_refugees) at (l.i_wgi=(-1.9(0.25)2.25))
marginsplot, yline(0) level(95) name(graph2, replace) addplot (scatter where v2 if e(sample), xlabel(-2(0.5)2.5) ms(none) blcolor(gray) mlabel(pipe) mlabpos(0)) legend(off) scheme(lean1) aspectratio(1)

graph combine graph1 graph2, ycommon

restore

preserve 

gen v1=l.ln_refugees
gen v2=l.i_wgi
gen v3=v1*v2
gen v4=l.ln_population
gen v5=l.xpolity
gen v6=l.xpolity_sq
gen v7=l.ep_i

eststo clear

eststo: logit onset_final ncsyrs ncsyrs2 ncsyrs3 v2, cluster(ccode) level(95)
epcp
estimates store logit0
fitstat
lroc, nograph

eststo: logit onset_final ncsyrs ncsyrs2 ncsyrs3 v1 v2 v3, cluster(ccode) level(95)
epcp
estimates store logit1
fitstat
lroc, nograph

eststo: logit onset_final ncsyrs ncsyrs2 ncsyrs3 v2 v4 v5 v6 v7, cluster(ccode) level(95)
epcp
estimates store logit2
fitstat
lroc, nograph

eststo: logit onset_final ncsyrs ncsyrs2 ncsyrs3 v1 v2 v3 v4 v5 v6 v7, cluster(ccode) level(95)
epcp
estimates store logit3
fitstat
lroc, nograph

esttab logit0 logit1 logit2 logit3, aic se star(* 0.05 ** 0.01) b(%10.3f) label
esttab using "Table1.tex",   /*
 */ se title(Non-State Violence: Refugee Inflow and State Capacity)  nonumbers /*
 */ mtitles("Model 1" "Model 2" "Model 3" "Model 4") label nodep nogaps star(* 0.05 ** 0.01) b(%9.3f) /*
 */ nonotes addnotes("$* p < 0.05, ** p < 0.01$" "Standard errors clustered on country in parentheses") replace 

restore

*******************************
* Separation Plot & PR-Scores *
*******************************

preserve 
gen v2=l.i_wgi
logit onset_final ncsyrs ncsyrs2 ncsyrs3 v2, cluster(ccode) level(95)
predict phat0 if e(sample)
keep onset_final phat0
drop if phat0==.
export delimited using "test0.csv", replace
restore

preserve 
gen v1=l.ln_refugees
gen v2=l.i_wgi
gen v3=v1*v2
logit onset_final ncsyrs ncsyrs2 ncsyrs3 v1 v2 v3, cluster(ccode) level(95)
predict phat1 if e(sample)
keep onset_final phat1 
drop if phat1==.
export delimited using "test1.csv", replace
restore

preserve 
gen v2=l.i_wgi
gen v4=l.ln_population
gen v5=l.xpolity
gen v6=l.xpolity_sq
gen v7=l.ep_i
logit onset_final ncsyrs ncsyrs2 ncsyrs3 v2 v4 v5 v6 v7, cluster(ccode) level(95)
predict phat2 if e(sample)
keep onset_final phat2 
drop if phat2==.
export delimited using "test2.csv", replace
restore

preserve 
gen v1=l.ln_refugees
gen v2=l.i_wgi
gen v3=v1*v2
gen v4=l.ln_population
gen v5=l.xpolity
gen v6=l.xpolity_sq
gen v7=l.ep_i
logit onset_final ncsyrs ncsyrs2 ncsyrs3 v1 v2 v3 v4 v5 v6 v7, cluster(ccode) level(95)
predict phat3 if e(sample)
keep onset_final phat3 
drop if phat3==.
export delimited using "test3.csv", replace
restore

* Switch to R *

library(separationplot)
df0 <- read.csv("/Users/tobiasbohmelt/Dropbox/Refugees and Non-State Actor Conflict/Data/test0.csv") 
df1 <- read.csv("/Users/tobiasbohmelt/Dropbox/Refugees and Non-State Actor Conflict/Data/test1.csv")  
df2 <- read.csv("/Users/tobiasbohmelt/Dropbox/Refugees and Non-State Actor Conflict/Data/test2.csv")   
df3 <- read.csv("/Users/tobiasbohmelt/Dropbox/Refugees and Non-State Actor Conflict/Data/test3.csv")  
separationplot(pred=df3$phat3, actual=df3$onset_final, type="rect", show.expected=TRUE)

library(PRROC)
fg0 <- df0$phat0[df0$onset_final == 1]
bg0 <- df0$phat0[df0$onset_final == 0]
roc0 <- roc.curve(scores.class0 = fg0, scores.class1 = bg0, curve = T)
plot(roc0)
pr0 <- pr.curve(scores.class0 = fg0, scores.class1 = bg0, curve = T)
plot(pr0)

fg1 <- df1$phat1[df1$onset_final == 1]
bg1 <- df1$phat1[df1$onset_final == 0]
roc1 <- roc.curve(scores.class0 = fg1, scores.class1 = bg1, curve = T)
plot(roc1)
pr1 <- pr.curve(scores.class0 = fg1, scores.class1 = bg1, curve = T)
plot(pr1)

fg2 <- df2$phat2[df2$onset_final == 1]
bg2 <- df2$phat2[df2$onset_final == 0]
roc2 <- roc.curve(scores.class0 = fg2, scores.class1 = bg2, curve = T)
plot(roc2)
pr2 <- pr.curve(scores.class0 = fg2, scores.class1 = bg2, curve = T)
plot(pr2)

fg3 <- df3$phat3[df3$onset_final == 1]
bg3 <- df3$phat3[df3$onset_final == 0]
roc3 <- roc.curve(scores.class0 = fg3, scores.class1 = bg3, curve = T)
plot(roc3)
pr3 <- pr.curve(scores.class0 = fg3, scores.class1 = bg3, curve = T)
plot(pr3)

**********************
* Interaction Graphs *
**********************

preserve 
gen v2=l.i_wgi
logit onset_final ncsyrs ncsyrs2 ncsyrs3 c.l.ln_refugees##c.l.i_wgi, cluster(ccode) level(95)
sum l.i_wgi if e(sample)
margins, dydx(l.ln_refugees) at (l.i_wgi=(-2.25(0.25)2.25)) 
drop if v2<-2.25 | v2>2.25 & v2!=.
generate where = -0.02
generate pipe = "|"
marginsplot, yline(0) level(95) name(graph1, replace) addplot (scatter where v2, xlabel(-2(0.5)2) ms(none) blcolor(gray) mlabel(pipe) mlabpos(0)) legend(off) scheme(lean1) aspectratio(1)
restore

preserve 
gen v2=l.i_wgi
logit onset_final ncsyrs ncsyrs2 ncsyrs3 c.l.ln_refugees##c.l.i_wgi l.ln_population l.xpolity l.xpolity_sq l.ep_i, cluster(ccode) level(95)
sum l.i_wgi if e(sample)
margins, dydx(l.ln_refugees) at (l.i_wgi=(-2.25(0.25)2.25)) 
drop if v2<-2.25 | v2>2.25 & v2!=.
generate where = -0.02
generate pipe = "|"
marginsplot, yline(0) level(95) name(graph2, replace) addplot (scatter where v2, xlabel(-2(0.5)2) ms(none) blcolor(gray) mlabel(pipe) mlabpos(0)) legend(off) scheme(lean1) aspectratio(1)
restore

graph combine graph1 graph2, ycommon

********************************
* Substantive Effects Controls *
********************************

preserve

gen v1=l.ln_refugees
gen v2=l.i_wgi
gen v3=v1*v2
gen v4=l.ln_population
gen v5=l.xpolity
gen v6=l.xpolity_sq
gen v7=l.ep_i

estsimp logit onset_final ncsyrs ncsyrs2 ncsyrs3 v1 v2 v3 v4 v5 v6 v7, cluster(ccode)
setx mean
simqi, fd(prval(1)) changex(v4 min max) level(95)
simqi, fd(prval(1)) changex(v5 min max) level(95)
simqi, fd(prval(1)) changex(v6 min max) level(95)
simqi, fd(prval(1)) changex(v7 min max) level(95)
drop b*

restore

***************************************
* Inverted U-Shaped Impact of XPolity *
***************************************

preserve

gen v1=l.ln_refugees
gen v2=l.i_wgi
gen v3=v1*v2
gen v4=l.ln_population
gen v5=l.xpolity
gen v6=l.xpolity_sq
gen v7=l.ep_i

logit onset_final ncsyrs ncsyrs2 ncsyrs3 v1 v2 v3 v4 c.v5##c.v5 v7, cluster(ccode)
qui margins, at (v5=(-6(1)7)) atmeans
marginsplot, level(95) recast(line) recastci(rline) name(graph3, replace) addplot (histogram v5, xlabel(-6(1)7) yaxis(2) blcolor(gray) bfcolor(none)) legend(off) scheme(lean1) aspectratio(1)

restore

******************************************************************************
* 4-Fold Cross-Validation: Refugees (ln) and Interaction with State Capacity *
******************************************************************************

forvalues h=1/10 {
preserve

gen v1=l.ln_refugees
gen v2=l.i_wgi
gen v3=v1*v2
gen v4=l.ln_population
gen v5=l.xpolity
gen v6=l.xpolity_sq
gen v7=l.ep_i

quietly logit onset_final ncsyrs ncsyrs2 ncsyrs3 v1 v2 v3 v4 v5 v6 v7, cluster(ccode) level(95)
predict fitted, pr
roctab onset_final fitted
xtile group=uniform(), nq(4)
generate cv_fitted=.
forvalues i=1/4 {
quietly logit onset_final ncsyrs ncsyrs2 ncsyrs3 v1 v2 v3 v4 v5 v6 v7 if group~=`i', cluster(ccode) level(95)
quietly predict cv_fittedi, pr
quietly replace cv_fitted=cv_fittedi if group==`i'
quietly drop cv_fittedi
}
roctab onset_final cv_fitted
capture drop fitted group cv_fitted
restore
}

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

forvalues h=1/10 {
preserve

gen v1=l.ln_refugees
gen v2=l.i_wgi
gen v3=v1*v2
gen v4=l.ln_population
gen v5=l.xpolity
gen v6=l.xpolity_sq
gen v7=l.ep_i

quietly logit onset_final ncsyrs ncsyrs2 ncsyrs3 v2 v4 v5 v6 v7, cluster(ccode) level(95)
predict fitted, pr
roctab onset_final fitted
xtile group=uniform(), nq(4)
generate cv_fitted=.
forvalues i=1/4 {
quietly logit onset_final ncsyrs ncsyrs2 ncsyrs3 v2 v4 v5 v6 v7 if group~=`i', cluster(ccode) level(95)
quietly predict cv_fittedi, pr
quietly replace cv_fitted=cv_fittedi if group==`i'
quietly drop cv_fittedi
}
roctab onset_final cv_fitted
capture drop fitted group cv_fitted
restore
}

******************
* Duration Graph *
******************

preserve

gen v1=l.ln_refugees
gen v2=l.i_wgi
gen v3=v1*v2
gen v4=l.ln_population
gen v5=l.xpolity
gen v6=l.xpolity_sq
gen v7=l.ep_i

estsimp logit onset_final ncsyrs ncsyrs2 ncsyrs3 v1 v2 v3 v4 v5 v6 v7, cluster(ccode) level(95)
setx mean

gen plo=.
label variable plo "95% Confidence Interval"	
gen phi=.
label variable phi "95% Confidence Interval"	
gen av=.
label variable av "Expected Risk of Non-State Violence"
generate time = _n in 1/26
local a = 0
while `a' <= 26 {
   setx ncsyrs `a' ncsyrs2 (`a'^2) ncsyrs3 (`a'^3)
   simqi, prval(1) genpr(pi)		
   _pctile pi, p(2.5,97.5)			
   replace plo = r(r1) if time==`a'	
   replace phi = r(r2) if time==`a'	
   sum pi
   local c = r(mean)
   replace av = `c' if time==`a'		
   drop pi
   local a = `a' + 1
}
sort time
twoway (line plo time) (line phi time) (line av time), scheme(lean1)

restore

***************************************
* Robustness Check I - GDP per capita *
***************************************

preserve 

gen v1=l.ln_refugees
gen v2=l.i_wgi
gen v3=v1*v2
gen v4=l.ln_gdppc
gen v5=l.ln_population
gen v6=l.xpolity
gen v7=l.xpolity_sq
gen v8=l.ep_i

eststo clear

logit onset_final ncsyrs ncsyrs2 ncsyrs3 v1 v2 v3 v4 v5 v6 v7 v8, cluster(ccode) level(95)
epcp
estimates store logit1
fitstat
lroc, nograph

generate where = -0.02
generate pipe = "|"
logit onset_final ncsyrs ncsyrs2 ncsyrs3 c.l.ln_refugees##c.l.i_wgi l.ln_gdppc l.ln_population l.xpolity l.xpolity_sq l.ep_i, cluster(ccode) level(95)
sum l.i_wgi if e(sample)
margins, dydx(l.ln_refugees) at (l.i_wgi=(-2(0.25)2.25)) 
marginsplot, yline(0) level(95) name(graph2, replace) addplot (scatter where v2 if e(sample), xlabel(-2(0.5)2.25) ms(none) blcolor(gray) mlabel(pipe) mlabpos(0)) legend(off) scheme(lean1) aspectratio(1)

restore

*************************************
* Robustness Check II - Spatial Lag *
*************************************

preserve

gen v2=l.i_wgi
generate where = -0.02
generate pipe = "|"

logit onset_final l.wy_onset_final ncsyrs ncsyrs2 ncsyrs3 c.l.ln_refugees##c.l.i_wgi l.ln_population l.xpolity l.xpolity_sq l.ep_i, cluster(ccode) level(95)
sum l.i_wgi if e(sample)
margins, dydx(l.ln_refugees) at (l.i_wgi=(-2.25(0.25)2.25)) 
marginsplot, yline(0) level(95) name(graph2, replace) addplot (scatter where v2 if e(sample), xlabel(-2.25(0.5)2.25) ms(none) blcolor(gray) mlabel(pipe) mlabpos(0)) legend(off) scheme(lean1) aspectratio(1)

restore

**********************************************
* Robustness Check III - Changes of Refugees *
**********************************************

preserve

gen v2=l.i_wgi
generate where = -0.02
generate pipe = "|"
generate refugee_change=ln(refugees_i/l.refugees_i)

logit onset_final ncsyrs ncsyrs2 ncsyrs3 c.l.refugee_change##c.l.i_wgi l.ln_population l.xpolity l.xpolity_sq l.ep_i, cluster(ccode) level(95)
sum l.i_wgi if e(sample)
drop if v2<-1.25 | v2>2.25 & v2!=.
margins, dydx(l.refugee_change) at (l.i_wgi=(-1.25(0.25)2.25)) 
marginsplot, yline(0) level(95) name(graph2, replace) addplot (scatter where v2 if e(sample), xlabel(-1.25(0.5)2.25) ms(none) blcolor(gray) mlabel(pipe) mlabpos(0)) legend(off) scheme(lean1) aspectratio(1)

restore

**************************************
* Robustness Check IV - Simultaneity *
**************************************

reg3 (onset_final ncsyrs ncsyrs2 ncsyrs3 c.l.ln_refugees##c.l.i_wgi l.ln_population l.xpolity l.xpolity_sq) (ln_refugees l.ln_refugees l.onset_final l.i_wgi l.ln_population l.xpolity l.ep_i) 

reg3 (onset_final ncsyrs ncsyrs2 ncsyrs3 c.l.ln_refugees##c.l.i_wgi l.ln_population l.xpolity l.xpolity_sq) (i_wgi l.i_wgi l.onset_final l.ln_refugees l.ln_population l.xpolity l.ep_i) 

reg3 (onset_final ncsyrs ncsyrs2 ncsyrs3 c.l.ln_refugees##c.l.i_wgi l.onset_dummy l.ln_population l.xpolity l.xpolity_sq l.ep_i) (onset_dummy internalyrs internalyrs2 internalyrs3 c.l.ln_refugees##c.l.i_wgi l.onset_final l.ln_population l.xpolity l.xpolity_sq l.ep_i) 

**************************************
* Robustness Check V - Refugee Camps *
**************************************

preserve

gen v2=l.i_wgi
generate where = -0.01
generate pipe = "|"

logit onset_final l.camps_new ncsyrs ncsyrs2 ncsyrs3 c.l.ln_refugees##c.l.i_wgi l.ln_population l.xpolity l.xpolity_sq l.ep_i, cluster(ccode) level(95)
sum l.i_wgi if e(sample)
drop if v2<-1.75 | v2>1.75 & v2!=.
margins, dydx(l.ln_refugees) at (l.i_wgi=(-1.75(0.25)1.75)) 
marginsplot, yline(0) level(95) name(graph2, replace) addplot (scatter where v2 if e(sample), xlabel(-1.75(0.5)1.75) ms(none) blcolor(gray) mlabel(pipe) mlabpos(0)) legend(off) scheme(lean1) aspectratio(1)

restore

**********************************************************
* Robustness Check VI - Disaggregation of State Capacity *
**********************************************************

logit onset_final ncsyrs ncsyrs2 ncsyrs3 c.l.ln_refugees##c.l.wgi l.ln_population l.xpolity l.xpolity_sq l.ep_i, cluster(ccode) level(95)

logit onset_final ncsyrs ncsyrs2 ncsyrs3 c.l.ln_refugees##c.l.bur_qua l.ln_population l.xpolity l.xpolity_sq l.ep_i, cluster(ccode) level(95)

**********************************************
* Robustness Check VII - Random Events Logit *
**********************************************

preserve 

gen v1=l.ln_refugees
gen v2=l.i_wgi
gen v3=v1*v2
gen v4=l.ln_population
gen v5=l.xpolity
gen v6=l.xpolity_sq
gen v7=l.ep_i

relogit onset_final ncsyrs ncsyrs2 ncsyrs3 v1-v7, cluster(ccode) level(95)

restore

***********************************************
* Robustness Check VIII - Foreign Aid Control *
***********************************************

preserve

gen v2=l.i_wgi
generate where = -0.01
generate pipe = "|"

logit onset_final l.dt_oda_odat_pc_zs ncsyrs ncsyrs2 ncsyrs3 c.l.ln_refugees##c.l.i_wgi l.ln_population l.xpolity l.xpolity_sq l.ep_i, cluster(ccode) level(95)
sum l.i_wgi if e(sample)
drop if v2<-1.25 | v2>1.75 & v2!=.
margins, dydx(l.ln_refugees) at (l.i_wgi=(-1.25(0.25)1.75)) 
marginsplot, yline(0) level(95) name(graph2, replace) addplot (scatter where v2 if e(sample), xlabel(-1.25(0.5)1.75) ms(none) blcolor(gray) mlabel(pipe) mlabpos(0)) legend(off) scheme(lean1) aspectratio(1)

restore
