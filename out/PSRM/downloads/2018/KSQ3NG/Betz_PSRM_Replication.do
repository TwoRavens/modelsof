********************************************************
* REPLICATION DATA FOR 
* BETZ (2018), THE ELECTORAL COSTS OF POLICY COMMITMENTS 
********************************************************

* Central bank reforms EMU (Figure 2)
use "EMU.dta", clear

stset year, id(iso3n) failure(reform) origin(year=1991)

graph drop _all
sts graph if year > 1991 & left == 1, name(left) cumhaz plotopts(lpattern(dash)) subtitle("Left government" , ring(1) box width(130) fcolor(none)) title("") xtitle("Year")
sts graph if year > 1991 & left == 0, name(right) cumhaz plotopts(lpattern(dash)) subtitle("Right government" , ring(1) box width(130) fcolor(none)) title("") xtitle("Year")
graph combine left right, title("Figure 2: Cumulative hazard rate") ycommon

graph save Graph "figure2.gph", replace


* Results for effects mentioned in main text (p. 18)
use "EMU.dta", clear

stset year, id(iso3n) failure(reform) origin(year=1991)

stcox left, robust 
streg left, robust distribution(exponential)


* Cross-country data central bank reforms (Figure 3)
use "Cross.dta", clear 
xtset iso3n year 

capture drop where rug
gen where = -.15
gen rug = "|"

qui logit increase i.right##c.avg_diff lngdp gdp_capita checks inf average ckaopen2010 eu year l.lnlvaw , robust cluster(iso3n) nolog
capture drop lower1 upper1 effect1 axis1 include1
gen include1 = e(sample)
qui su avg_diff if e(sample) == 1, de
gen axis1 = .
gen lower1 = .
gen upper1 = .
gen effect1 = .
local i = 0
qui while `i' < 14 {
local a = `i'/10 - .35
margins, dydx(right) at(avg_diff = `a')
matrix coef = r(b)
matrix var = r(V)
scalar b = coef[1,2]
scalar sde = var[2,2]
scalar sde = sqrt(sde)
replace axis1 = `a' if _n == `i' + 1
replace effect1 = b if _n == `i' + 1
replace lower1 = b - 1.96*sde if _n == `i' + 1
replace upper1 = b + 1.96*sde if _n == `i' + 1
local i = `i' + 1
}

capture graph drop inf
#delimit ;
twoway scatter where avg_diff if include1 == 1, ms(none) mlabel(rug) mlabpos(0)  yscale(alt axis(2))
  || rcap upper lower axis1, color(gs6) lpattern(dash) yaxis(2)  yscale(alt axis(1))
  || scatter effect axis1, color(gs6) msize(medlarge) msymbol(d) yscale(alt axis(1))
  yline(0, lstyle(foreground) axis(2)) 
  yaxis(2)  yscale(alt axis(1))
  xlabel(none)
  yscale(r(-.15(.1).4) axis(2))
  ylabel(-.1(.1).3, axis(2))
  ylabel(none, axis(1))
  yscale(r(0(25)75) axis(1))
  ytitle("", axis(1))
  xtitle("")
  legend(off)
  scheme(lean1) plotregion(style(none)) 
  xsize(4)
  ysize(4)
  subtitle("As a function of inflation aversion", ring(1) size(large) box width(130))
  name(inf)
 ;
#delimit cr
 
logit increase i.right##c.lnsd lngdp gdp_capita checks inf average ckaopen2010 eu year l.lnlvaw  , robust cluster(iso3n) nolog
capture drop lower1 upper1 effect1 axis1 include1
gen include1 = e(sample)
qui su lnsd if e(sample) == 1, de
gen axis1 = .
gen lower1 = .
gen upper1 = .
gen effect1 = .
local i = 0
qui while `i' < 17 {
local a = `i'/2 - 7.6
margins, dydx(right) at(lnsd = `a')
matrix coef = r(b)
matrix var = r(V)
scalar b = coef[1,2]
scalar sde = var[2,2]
scalar sde = sqrt(sde)
replace axis1 = `a' if _n == `i' + 1
replace effect1 = b if _n == `i' + 1
replace lower1 = b - 1.96*sde if _n == `i' + 1
replace upper1 = b + 1.96*sde if _n == `i' + 1
local i = `i' + 1
}

capture graph drop sd
#delimit ;
twoway scatter where lnsd if include1 == 1, ms(none) mlabel(rug) mlabpos(0)  yscale(alt axis(2))
  || rcap upper lower axis1, color(gs6) lpattern(dash) yaxis(2)  yscale(alt axis(1))
  || scatter effect axis1, color(gs6) msize(medlarge) msymbol(d) yscale(alt axis(1))
  yline(0, lstyle(foreground) axis(2)) 
  yaxis(2)  yscale(alt axis(1))
  xlabel(none)
  yscale(r(-.15(.1).4) axis(2))
  ylabel(-.1(.1).3, axis(2))
  ylabel(none, axis(1))
  yscale(r(0(25)50) axis(1))
  ytitle("", axis(1))
  xtitle("")
  subtitle("As a function of partisan differences", ring(1) size(large) box width(130))
  legend(off)
  scheme(lean1) plotregion(style(none)) 
  xsize(4)
  ysize(4)
  name(sd)
 ;
#delimit cr

graph combine sd inf, title("Figure 3: Marginal effect of right-wing government on central bank reform", ring(1)) xsize(8) ysize(4)  scheme(lean1)
graph save Graph "figure3.gph", replace



* Central bank reforms (Appendix Table 1)
use "EMU.dta", clear

stset year, id(iso3n) failure(reform) origin(year=1991)

stcox left, robust nohr
estimates store m1
stcox left inflow_gdp, robust nohr
estimates store m2
stcox left inflow_gdp balance_gdp , robust nohr
estimates store m3
stcox left inflow_gdp trade_gdp, robust nohr
estimates store m4
stcox left inflow_gdp ln_population, robust nohr
estimates store m5
stcox left inflow_gdp ln_gdp, robust nohr
estimates store m6
stcox left checks, robust nohr
estimates store m7

estout m1 m2 m3 m4 m5 m6 m7 using "table1.tex", replace cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .00001) stats(N, fmt(0) labels("Number Obs.")) nolz style(tex) varlabels(left "Left" inflow_gdp "Capital inflows" balance_gdp "Trade balance" trade_gdp "Trade openness" ln_population "log population" ln_gdp "log GDP" checks "Veto players" )


* Cross-country data central bank reforms (Appendix Table 2)
use "Cross.dta", clear 

logit increase i.right##c.lnsd lngdp gdp_capita checks inf average ckaopen2010 eu year l.lnlvaw  , robust cluster(iso3n) nolog
estimates store m1
logit increase i.right##c.lnsd housesys lngdp gdp_capita checks inf average ckaopen2010 eu year l.lnlvaw  , robust cluster(iso3n) nolog
estimates store m2
logit increase i.right##c.lnsd xrate lngdp gdp_capita checks inf average ckaopen2010 eu year l.lnlvaw  , robust cluster(iso3n) nolog
estimates store m3
logit increase i.right##c.lnsd lngdp gdp_capita checks inf average ckaopen2010 eu year l.lnlvaw i.iso3n , robust cluster(iso3n) nolog
estimates store m4

logit increase i.right##c.avg_diff lngdp gdp_capita checks inf average ckaopen2010 eu year l.lnlvaw  , robust cluster(iso3n) nolog
estimates store m5
logit increase i.right##c.avg_diff housesys lngdp gdp_capita checks inf average ckaopen2010 eu year l.lnlvaw  , robust cluster(iso3n) nolog
estimates store m6
logit increase i.right##c.avg_diff xrate lngdp gdp_capita checks inf average ckaopen2010 eu year l.lnlvaw  , robust cluster(iso3n) nolog
estimates store m7
logit increase i.right##c.avg_diff lngdp gdp_capita checks inf average ckaopen2010 eu year l.lnlvaw i.iso3n , robust cluster(iso3n) nolog
estimates store m8

estout m1 m2 m3 m4 m5 m6 m7 m8 using "table2.tex", replace extracols(5) order(1.right* lnsd avg_diff lngdp gdp_capita checks inf average ckaopen2010 eu L.lnlvaw year ) cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) stats(N N_clust, fmt(0) labels("Number Obs." "Number Countries")) nolz style(tex)  drop(*iso3n 0.*) varlabels(housesys "Plurality rule" xrate "Exchange rate regime" lngdp "GDP" gdp_capita "GDP per capita" _cons "Constant" checks "Veto players" 1.right#c.lnsd " \ \ x Partisan differences" 1.right#c.avg_diff " \ \ x Inflation aversion" 1.right "Right-wing government" lnsd "Partisan differences" avg_diff "Inflation aversion" year "Year trend" ckaopen2010 "Capital account openness" inf "Inflation" average "3-year average inflation" L.lnlvaw "Lagged CBI" eu "EU member" )


