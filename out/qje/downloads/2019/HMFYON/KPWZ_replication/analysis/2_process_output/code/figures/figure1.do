* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Figure 1
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019

* This .do file plots actual vs. predicted KPSS value




*--------- FIGURE 1 ---------*

  * get the data
  import delimited using "$data/QJEtables1/fit.txt", clear delimiter(tab)

  drop in 2
  * clean the data
  foreach vv of varlist _all {
    replace `vv' = subinstr(`vv',"(","",.)
    replace `vv' = subinstr(`vv',")","",.)
    replace `vv' = subinstr(`vv',"*","",.)
    replace `vv' = subinstr(`vv',",","",.)
  }

  destring *, replace

  * get the regression numbers
  loc b = round(v6[43] , .01)
  loc s = round(v6[44] , .01)
  keep if regexm(v1,"^bindum")
  keep v4 v5
  rename v4 xi
  rename v5 xihat

  gen N = 0 in 1
  replace N = 120 in 2

  * graph
  twoway ///
    (scatter xi xihat) (lfit xi xihat) (line N N, lpattern(dash)), ///
    ytitle("True {&xi} values") yscale(r(0 120)) ylabel(0(20)120) ///
    xtitle("Fitted {&xi} values") xscale(r(0 120)) xlabel(0(20)120) ///
    text(50 80 "{&beta}: `b'" "se: `s'", box just(left) margin(l+4 t+1 b+1) width(15) fcolor(white)) ///
    legend(order(2 "Line of best fit" 3 "45 degree line    ") forces region(lcolor(white))) ///
    plotregion(fcolor(white) lcolor(white)) graphregion(color(white) lcolor(white)) bgcolor(white)
  graph export "$figures/figure1.pdf", replace

