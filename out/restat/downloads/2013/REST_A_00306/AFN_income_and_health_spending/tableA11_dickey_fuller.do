clear
set more off
set mem 200m

capture program drop add_param
program define add_param, eclass
 ereturn scalar `1' = `2'
end

est clear

**
* dickey-fuller tests
** 
clear
use ./dta/oilprice
gen logoil = log(oilprice)
tsset year

keep if year <= 2005

*replace oilprice = oilprice_real

regress D.oilprice L.oilprice
dfuller oilprice, regress
add_param Zt r(Zt)
add_param pval r(p)
est store df0

regress D.oilprice L.oilprice LD.oilprice
dfuller oilprice, regress lags(1)
add_param Zt r(Zt)
add_param pval r(p)
est store df1

regress D.oilprice L.oilprice LD.oilprice L2D.oilprice
dfuller oilprice, regress lags(2)
add_param Zt r(Zt)
add_param pval r(p)
est store df2

regress D.oilprice L.oilprice LD.oilprice L2D.oilprice L3D.oilprice
dfuller oilprice, regress lags(3)
add_param Zt r(Zt)
add_param pval r(p)
est store df3

regress D.oilprice L.oilprice year
dfuller oilprice, regress trend
add_param Zt r(Zt)
add_param pval r(p)
est store df0t

regress D.oilprice L.oilprice LD.oilprice year
dfuller oilprice, regress trend lags(1)
add_param Zt r(Zt)
add_param pval r(p)
est store df1t

regress D.oilprice L.oilprice LD.oilprice L2D.oilprice year
dfuller oilprice, regress trend lags(2)
add_param Zt r(Zt)
add_param pval r(p)
est store df2t

regress D.oilprice L.oilprice LD.oilprice L2D.oilprice L3D.oilprice year
dfuller oilprice, regress trend lags(3)
add_param Zt r(Zt)
add_param pval r(p)
est store df3t

ereturn list
estout * ///
 using tableA11_dickey_fuller.txt, ///
    stats(N Zt pval, fmt(%9.0f %9.4f %9.4f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_cons) title("`title_str'")



