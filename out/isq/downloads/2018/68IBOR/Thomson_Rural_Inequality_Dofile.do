****************************************************
* Land Gini and conflict - F&L civil war indicator *
****************************************************
use Rural_Inequality_Conflict.dta, clear

logit onset warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac,nolog vce(cluster cown)
est store base
estat ic

logit onset landgini_ipolated warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac,nolog vce(cluster cown)
est store landgini1
*margins, at(landgini_ipolated=(0.18(0.05)0.98))
*marginsplot
***tabout country if e(sample) using Countries.tex, oneway style(tex) replace

logit onset landgini_ipolated landgini2 warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac,nolog vce(cluster cown)
est store landgini2
test landgini_ipolated landgini2

logit onset c.landgini_ipolated##c.landgini_ipolated warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac ,nolog vce(cluster cown)
estat ic
margins, at(landgini_ipolated=(0.18(0.05)0.98))
marginsplot, addplot(kdensity landgini_ipolated, yaxis(2) yline(0, lwidth(thin))) scheme(lean1) legend(pos(6)) ///
xlabel(0.18(0.2)0.98) title("Predicted Probability of Conflict Onset (F/L)")
graph save Land_Gini_Conflict, replace
*graph export Land_Gini_Conflict.png, width(800) height(800) replace

*margins, at(gdpenl=(0.5(5)66))
*marginsplot, addplot(kdensity gdpenl, yaxis(2) yline(0, lwidth(thin))) recastci(rarea) ciopts(color(gray) lwidth(thin) fintensity(15)) 
*graph export GDP_Conflict.png, width(1200) replace


estsimp logit onset landgini_ipolated landgini2 warl gdpenl lpopl lmtnest ncontig Oil instab polity2l ethfrac relfrac ,nolog vce(cluster cown)
setx mean
simqi, fd(prval(1)) changex(landgini_ipolated 0.68 0.98 landgini2 0.4264 0.9604) level(90)


logit onset ovgini_ipolated warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac, nolog vce(cluster cown)
est store inequality1
estat ic

logit onset ovgini_ipolated warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac, nolog vce(cluster cown)
margins, at(ovgini_ipolated=(0.21(0.05)0.98))
marginsplot, addplot(kdensity ovgini_ipolated, yaxis(2) yline(0, lwidth(thin))) scheme(lean1) legend(pos(6)) ///
xlabel(0.2(0.2)0.98) ylabel(-0.01(0.01)0.03) title("Predicted Probability of Conflict Onset (L/F)")
graph save Land_Inequality_Conflict, replace
*graph export Land_Inequality_Conflict.png, width(800) height(800) replace

*margins, at(gdpenl=(0.5(5)66))

logit onset ovgini_ipolated ovgini2 warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac, nolog vce(cluster cown)
est store inequality2

logit onset ovgini_ipolated landgini_ipolated landgini2 warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac, nolog  vce(cluster cown)
est store full

logit onset c.ovgini_ipolated##c.ovgini_ipolated warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac, nolog vce(cluster cown)
*margins, at(ovgini_ipolated=(0.21(0.05)0.98))

logit onset ovgini_ipolated c.landgini_ipolated##c.landgini_ipolated warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac, nolog  vce(cluster cown)
*margins, at(ovgini_ipolated=(0.21(0.05)0.98))
*margins, at(landgini_ipolated=(0.18(0.05)0.98))



* Generate table of summary statistics *
*logit onset landgini_ipolated landgini2 warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac, nolog  vce(cluster cown)
*sutex onset ovgini_ipolated landgini_ipolated landgini2 ruralpop_total warl gdpenl lpopl if e(sample), digits(2) minmax labels file(Summ_Stats.tex) replace

*corrtex onset colonset ovgini_ipolated landgini_ipolated ruralpop_total, file(Corr_Tab.tex) replace title("Correlation Table") digits(2) placement("centering") key("corrtab")

*logit onset landgini_ipolated landgini2 warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac, vce(cluster ccode)
*sutex ovgini_ipolated ovgini2 if e(sample), digits(2) minmax labels file(Summ_Stats.tex) append

*****************************************************************
* Graph of land ginis and whether country experienced civil war *
*****************************************************************
label var ovgini "Land Inequality"
label var landgini "Land Gini"
sort ccode year
by ccode: egen ovgini_mean = mean(ovgini) if e(sample)
label var ovgini_mean "Land Inequality (Mean)"
by ccode: egen landgini_mean = mean(landgini)  if e(sample)
label var landgini_mean "Land Gini (Mean)"
tab country year if e(sample) & onset==1
by ccode: egen onset_mean = mean(onset) if e(sample)

graph twoway (scatter ovgini_mean landgini_mean if e(sample) & onset_mean==0, ///
mlabel(wbcode) msize(vsmall) msymbol(i) mlabcolor(gs9) ylabel(0.3(0.2)1) xlabel(0.3(0.2)1) xtitle("Land Gini (Mean)") ytitle("Land Inequality (Mean)")) ///
(scatter ovgini_mean landgini_mean if e(sample) & onset_mean>0, ///
mlabel(wbcode) msize(vsmall) msymbol(i) mlabcolor(gs1) ylabel(0.3(0.2)1) xlabel(0.3(0.2)1) xtitle("Land Gini (Mean)") ytitle("Land Inequality (Mean)") ///
xlabel(0.3(0.2)1) ylabel(0.3(0.2)1)legend(off))

*graph export Scatter_Ineq_Gini.pdf, replace



*****************************************************************
* Now robustness tests using the Collier/Hoeffler conflict data *
*****************************************************************
use Rural_Inequality_Conflict.dta, clear
btscs colonset year ccode, g(peaceyears) nspline(3)
label var peaceyears "Peace Years"
label var _spline1 "Spline 1"
label var _spline2 "Spline 2"
label var _spline3 "Spline 3"

logit colonset landgini_ipolated landgini2 gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac peaceyears _spline1 _spline2 _spline3,nolog vce(cluster cown)
est store col1

label var colonset "Onset (C/H)"
label var colwars "Ongoing Wars (C/H)"
label var colwarl "Ongoing War (C/H)"
sutex colonset colwarl if e(sample), digits(2) minmax labels file(Summ_Stats.tex) append

estsimp logit colonset landgini_ipolated landgini2 gdpenl lpopl lmtnest ncontig Oil instab polity2l ethfrac relfrac peaceyears _spline1 _spline2 _spline3,nolog vce(cluster cown)
setx mean
simqi, fd(prval(1)) changex(landgini_ipolated 0.68 0.98 landgini2 0.4264 0.9604)


logit colonset ovgini_ipolated gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac peaceyears _spline1 _spline2 _spline3, nolog vce(cluster cown)
est store col2
margins, at(ovgini_ipolated=(0.21(0.05)0.98))
marginsplot, addplot(kdensity ovgini_ipolated, yaxis(2) yline(0, lwidth(thin))) scheme(lean1) legend(pos(6)) ///
xlabel(0.2(0.2)0.98) ylabel(-0.01(0.01)0.03) title("Predicted Probability of Conflict Onset (C/H)")
graph save Land_Inequality_Conflict_Collier, replace
*graph export Land_Inequality_Conflict_Collier.png, width(800) height(800) replace

logit colonset ovgini_ipolated landgini_ipolated landgini2 gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac peaceyears _spline1 _spline2 _spline3,nolog vce(cluster cown)
est store col3

logit colonset c.landgini_ipolated##c.landgini_ipolated gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac peaceyears _spline1 _spline2 _spline3,nolog vce(cluster cown)
estat ic
margins, at(landgini_ipolated=(0.18(0.05)0.98))
marginsplot, addplot(kdensity landgini_ipolated, yaxis(2) yline(0, lwidth(thin))) scheme(lean1) legend(pos(6)) ///
xlabel(0.18(0.2)0.98) ylabel(-0.01(0.01)0.03) title("Predicted Probability of Conflict Onset (C/H)")
graph save Land_Gini_Conflict_Collier, replace
*graph export Land_Gini_Conflict_Collier.png, width(800) height(800) replace




*Regression table number 1 *
esttab inequality1 col2 landgini2 col1 full col3, ///
type se b(2) nogaps star(* 0.10 ** 0.05 *** 0.01) replace label ///
keep(ovgini_ipolated landgini_ipolated landgini2 warl gdpenl lpopl1 peaceyears _spline1 _spline2 _spline3 _cons) ///
order(ovgini_ipolated landgini_ipolated landgini2 warl gdpenl lpopl1 peaceyears _spline1 _spline2 _spline3 _cons) ///
mti("Ineq (F/L)" "Ineq (C/H)" "Gini (F/L)" "Gini (C/H)" "Full (F/L)" "Full (C/H)") ///
addnotes("All models with robust standard errors clustered by country" ///
"All models include full Fearon and Laitin (2003) controls")

*Regression table number 1 *
esttab inequality1 col2 landgini2 col1 full col3 using Landgini_Civilwar_Regs.tex, ///
type se b(2) nogaps star(* 0.10 ** 0.05 *** 0.01) replace label ///
keep(ovgini_ipolated landgini_ipolated landgini2 warl gdpenl lpopl1 peaceyears _spline1 _spline2 _spline3 _cons) ///
order(ovgini_ipolated landgini_ipolated landgini2 warl gdpenl lpopl1 peaceyears _spline1 _spline2 _spline3 _cons) ///
mti("Ineq (F/L)" "Ineq (C/H)" "Gini (F/L)" "Gini (C/H)" "Full (F/L)" "Full (C/H)") ///
addnotes("All models with robust standard errors clustered by country" ///
"All models include full Fearon and Laitin (2003) controls")


grc1leg Land_Inequality_Conflict.gph Land_Inequality_Conflict_Collier.gph
*graph export Fig_2_Land_Ineq.pdf, replace

grc1leg Land_Gini_Conflict.gph Land_Gini_Conflict_Collier.gph
*graph export Fig_3_Land_Gini.pdf, replace

**********************************************
* Now robustness test by using btscs splines *
**********************************************
use Rural_Inequality_Conflict.dta, clear
drop if onset>1
btscs onset year ccode, g(peaceyears) nspline(3)

logit onset landgini_ipolated landgini2 ///
gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac ///
peaceyears _spline1 _spline2 _spline3, nolog vce(cluster cown)
est store splines1

logit onset c.landgini_ipolated##c.landgini_ipolated ///
gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac ///
peaceyears _spline1 _spline2 _spline3, nolog vce(cluster cown)
margins, at(landgini_ipolated=(0.18(0.05)0.98))
marginsplot

logit onset ovgini_ipolated ///
gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac ///
peaceyears _spline1 _spline2 _spline3, nolog vce(cluster cown)
est store splines2
margins, at(ovgini_ipolated=(0.21(0.05)0.98))
marginsplot, addplot(kdensity ovginil, yaxis(2))

logit onset ovgini_ipolated landgini_ipolated landgini2 ///
gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac ///
peaceyears _spline1 _spline2 _spline3, nolog vce(cluster cown)
est store splines3




*************************************************************
* Replicating Boix's Model w. urbanization interaction term *
*************************************************************
gen ovgini_ruralpop = ovgini_ipolated*ruralpop_total
label var ovgini_ruralpop "Land Ineq*Rural Pop"
gen landgini_ruralpop = landgini_ipolated*ruralpop_total
label var landgini_ruralpop "Land Gini*Rural Pop"

logit onset ovgini_ipolated ruralpop_total ovgini_ruralpop warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac ,nolog vce(cluster cown)
est store boix1

logit onset landgini_ipolated ruralpop_total landgini_ruralpop warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac ,nolog vce(cluster cown)
est store boix2
*** These results show that urbanization (or in this case, its inverse, rural population, adds nothing to the models.

logit sdonset ovgini_ipolated sdwarl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac, vce(cluster cown)
margins, at(ovgini_ipolated=(0.21(0.05)0.98))

logit sdonset c.landgini_ipolated##c.landgini_ipolated sdwarl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac, vce(cluster cown)
margins, at(landgini_ipolated=(0.18(0.05)0.98))

label var peaceyears "Peace Years"
label var _spline1 "Spline 1"
label var _spline2 "Spline 2"
label var _spline3 "Spline 3"


* Regression table number 2 *
esttab inequality2 landgini1 boix1 boix2 splines3 using Landgini_Civilwar_Robustness.tex, ///
type se b(2) nogaps star(* 0.10 ** 0.05 *** 0.01) replace label wide ///
keep(ovgini_ipolated ovgini2 landgini_ipolated landgini2 ruralpop_total ovgini_ruralpop landgini_ruralpop warl peaceyears _spline1 _spline2 _spline3 gdpenl lpopl1 _cons) ///
order(ovgini_ipolated ovgini2 landgini_ipolated landgini2 ruralpop_total ovgini_ruralpop landgini_ruralpop warl peaceyears _spline1 _spline2 _spline3 gdpenl lpopl1 _cons) ///
mti("Ineq (F/L)" "Gini (F/L)" "Boix (LI)" "Boix (LG)" "Full Model") ///
addnotes("All models with robust standard errors clustered by country" ///
"All models include full Fearon and Laitin (2003) controls")



*******************************************************
* Merge in PRIO data to look at incidence of conflict *
*******************************************************
use Rural_Inequality_Conflict.dta, clear
drop _merge
gen gwno = ccode
sort gwno year
drop if gwno==.
merge 1:1 gwno year using 124922_1onset2012.dta

* Incidence *
sort ccode year
btscs incidencev412 year ccode, g(peaceyears) nspline(3)
label var peaceyears "Peace Years"
label var _spline1 "Spline 1"
label var _spline2 "Spline 2"
label var _spline3 "Spline 3"
label var landgini2 "Land Gini Sq"
label var warl "War Lag (F/L)"
label var gdpenl "GDP/Cap Lag(F/L)"
label var lpopl "Log Pop (F/L)"

logit incidencev412 landgini_ipolated landgini2 gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac peaceyears _spline1 _spline2 _spline3, vce(cluster cown)
est store prioincidence1
logit incidencev412 c.landgini_ipolated##c.landgini_ipolated gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac peaceyears _spline1 _spline2 _spline3, vce(cluster cown)
margins, at(landgini_ipolated=(0.18(0.05)0.98))

logit incidencev412 ovgini_ipolated gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac  peaceyears _spline1 _spline2 _spline3, vce(cluster cown)
est store prioincidence2
margins, at(ovgini_ipolated=(0.21(0.05)0.98))




********************************************************
* Now look only at cases where there is no ongoing war *
********************************************************
drop if war==1 & onset==0
logit onset landgini_ipolated landgini2 warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac,nolog vce(cluster cown)
est store noongoing1
logit onset c.landgini_ipolated##c.landgini_ipolated warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac,nolog vce(cluster cown)
margins, at(landgini_ipolated=(0.18(0.05)0.98))

logit onset ovgini_ipolated warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac, nolog vce(cluster cown)
est store noongoing2
margins, at(ovgini_ipolated=(0.21(0.05)0.98))


esttab noongoing2 noongoing1 prioincidence2 prioincidence1 using Landgini_Civilwar_Robustness_2.tex, ///
type se b(2) nogaps star(* 0.10 ** 0.05 *** 0.01) replace label wide ///
keep(ovgini_ipolated landgini_ipolated landgini2 warl gdpenl lpopl1 peaceyears _spline1 _spline2 _spline3 _cons) ///
order(ovgini_ipolated landgini_ipolated landgini2 warl gdpenl lpopl1 peaceyears _spline1 _spline2 _spline3 _cons) ///
mti("Ineq excl Ongoing" "Gini excl Ongoing" "Incidence (PRIO)" "Incidence (PRIO)") ///
addnotes("All models with robust standard errors clustered by country" ///
"All models include full Fearon and Laitin (2003) controls")



****************************************
* Save out dataset for use with Amelia *
****************************************
cd "J:\Data\Civil_War"
use Rural_Inequality_Conflict.dta, clear
drop _merge
drop count_lg
by cown: egen count_lg = count(landgini)
summ count_lg
drop if count_lg<1
drop if onset==.
sort cown year
keep warl gdpenl lpopl lmtnest ncontig Oil instab polity2l ethfrac relfrac ///
ccode country cname year wars war warl onset rural_popdens ruralpop_total ///
ovgini_ipolated landgini_ipolated landginil ovginil ruralpop totalpop agarea
saveold Rural_Inequality_Conflict_MI.dta, replace

* Run Amelia, then:
import delimited Rural_Inequality_Conflict_MI-imp1.csv, varnames(1) clear
save Rural_Inequality_Conflict_MI-imp1.dta, replace
import delimited Rural_Inequality_Conflict_MI-imp2.csv, varnames(1) clear
save Rural_Inequality_Conflict_MI-imp2.dta, replace
import delimited Rural_Inequality_Conflict_MI-imp3.csv, varnames(1) clear
save Rural_Inequality_Conflict_MI-imp3.dta, replace
import delimited Rural_Inequality_Conflict_MI-imp4.csv, varnames(1) clear
save Rural_Inequality_Conflict_MI-imp4.dta, replace
import delimited Rural_Inequality_Conflict_MI-imp5.csv, varnames(1) clear
save Rural_Inequality_Conflict_MI-imp5.dta, replace

use Rural_Inequality_Conflict_MI-imp5, clear
estsimp logit onset ovgini_ipolated warl gdpenl lpopl lmtnest ncontig oil instab polity2l ethfrac relfrac, vce(cluster ccode) ///
mi(Rural_Inequality_Conflict_MI-imp1.dta Rural_Inequality_Conflict_MI-imp2.dta Rural_Inequality_Conflict_MI-imp3.dta Rural_Inequality_Conflict_MI-imp4.dta Rural_Inequality_Conflict_MI-imp5.dta)

setx mean

simqi, fd(prval(1)) changex(ovgini_ipolated min mean)
simqi, fd(prval(1)) changex(ovgini_ipolated min mean) level(90)

simqi, fd(prval(1)) changex(ovgini_ipolated mean max)
simqi, fd(prval(1)) changex(ovgini_ipolated mean max) level(90)

simqi, fd(prval(1)) changex(ovgini_ipolated min max)
simqi, fd(prval(1)) changex(ovgini_ipolated min max) level(90)




*******************************
* Include dummies for regions *
*******************************
logit onset c.landgini_ipolated##c.landgini_ipolated warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac western lamerica ssafrica asia,nolog vce(cluster cown)
margins, at(landgini_ipolated=(0.18(0.05)0.98))

logit onset ovgini_ipolated warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac western lamerica ssafrica asia,nolog vce(cluster cown)
margins, at(ovgini_ipolated=(0.21(0.05)0.98))



*********************************************************
* Using extrapolated data -- extrapolating only 2 years *
*********************************************************
logit onset c.iplandgini##c.iplandgini warl gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac ,nolog vce(cluster cown)
margins, at(iplandgini=(0.18(0.05)0.98))
marginsplot, addplot(kdensity iplandgini, yaxis(2) yline(0, lwidth(thin))) scheme(lean1) legend(pos(6)) ///
xlabel(0.18(0.2)0.98) title("Predicted Probability of Conflict Onset (F/L)")

logit colonset c.iplandgini##c.iplandgini gdpenl lpopl lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac peaceyears _spline1 _spline2 _spline3,nolog vce(cluster cown)
estat ic
margins, at(iplandgini=(0.18(0.05)0.98))
marginsplot, addplot(kdensity iplandgini, yaxis(2) yline(0, lwidth(thin))) scheme(lean1) legend(pos(6)) ///
xlabel(0.18(0.2)0.98) ylabel(-0.01(0.01)0.03) title("Predicted Probability of Conflict Onset (C/H)")

