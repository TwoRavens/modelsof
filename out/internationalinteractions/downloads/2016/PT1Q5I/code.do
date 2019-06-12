****************************************************************************
*		Defense Spending and Economic Growth around the Globe:

*                                 The Direct and Indirect Link


*		Uk Heo and Min Ye

* 		Software: Stata 13

* note: a package needs to be installed for command "xtsur" 
* (available at http://fmwww.bc.edu/RePEc/bocode/x)
*****************************************************************************



use "data.dta", clear
set matsize 1000
global id statecode	
global t year
sort $id $t
xtset $id $t

*********************
*  unit roots test   *
*********************
*rmilx (ratio: military expenditure/GDP)
xtunitroot fisher rmilx, dfuller lags(1)
xtunitroot fisher rmilx, pp lags(1)
xtunitroot breitung rmilx, lags(1)
xtunitroot llc rmilx, lags(1)
xtunitroot ht rmilx
xtunitroot ips rmilx, lags(1)

*rnmilx (ratio: non-military expenditure/GDP) 
xtunitroot fisher rnmilx, dfuller lags(1)
xtunitroot fisher rnmilx, pp lags(1)
xtunitroot breitung rnmilx, lags(1)
xtunitroot llc rnmilx, lags(1)
xtunitroot ht rnmilx
xtunitroot ips rnmilx, lags(1)

*investment
xtunitroot fisher investment, dfuller lags(1)
xtunitroot fisher investment, pp lags(1)
xtunitroot breitung investment, lags(1)
xtunitroot llc investment, lags(1)
xtunitroot ht investment
xtunitroot ips investment, lags(1)

*gdp_con (GDP in 2005 constant USD)
xtunitroot fisher gdp_con, dfuller lags(1)
xtunitroot fisher gdp_con, pp lags(1)
xtunitroot breitung gdp_con, lags(1)
xtunitroot llc gdp_con, lags(1)
xtunitroot ht gdp_con
xtunitroot ips gdp_con, lags(1)

*ln_gdp (GDP in 2005 constant USD)
xtunitroot fisher ln_gdp, dfuller lags(1)
xtunitroot fisher ln_gdp, pp lags(1)
xtunitroot breitung ln_gdp, lags(1)
xtunitroot llc ln_gdp, lags(1)
xtunitroot ht ln_gdp
xtunitroot ips ln_gdp, lags(1)

*infg (inflation)
xtunitroot fisher infg, dfuller lags(1)
xtunitroot fisher infg, pp lags(1)
xtunitroot breitung infg, lags(1)
xtunitroot llc infg, lags(1)
xtunitroot ht infg
xtunitroot ips infg, lags(1)

*umei (unemployment)
xtunitroot fisher umei, dfuller lags(1)
xtunitroot fisher umei, pp lags(1)
xtunitroot breitung umei, lags(1)
xtunitroot llc umei, lags(1)
xtunitroot ht umei
xtunitroot ips umei, lags(1)

*rinvestment (ratio: investment/GDP)
xtunitroot fisher rinvestment, dfuller lags(1)
xtunitroot fisher rinvestment, pp lags(1)
xtunitroot breitung rinvestment, lags(1)
xtunitroot llc rinvestment, lags(1)
xtunitroot ht rinvestment
xtunitroot ips rinvestment, lags(1)

*capital stocks
xtunitroot fisher ck, dfuller lags(1)
xtunitroot fisher ck, pp lags(1)
xtunitroot breitung ck, lags(1)
xtunitroot llc ck, lags(1)
xtunitroot ht ck
xtunitroot ips ck, lags(1)

**********************
* Dependent Variables* 
**********************
* Equation 1 
global y11list ln_investment

* Equation 2 
global y21list umei

* Equation 3 
global y31list dln_gdp_con


************************ 
* independent variables*
************************ 
* Equation 1
global x112list dlln_gdp_con infg ln_rmilx lln_rmilx l2ln_rmilx ln_rnmilx lln_rnmilx l2ln_rnmilx 

* Equation 2
global x212list lumei ln_rmilx lln_rmilx l2ln_rmilx ln_rnmilx lln_rnmilx l2ln_rnmilx

* Equation 3
global x312list dlln_gdp_con ln_rinvestment dlnlabor ln_rmilx lln_rmilx l2ln_rmilx


************
* Table 1  * 
************

xtsur ($y11list $x112list) ($y21list $x212list) ($y31list $x312list)

****************************** 
* Auxilary test: Table A2    * 
****************************** 

** independent variables with dln_ck 
global x112list dlln_gdp_con infg ln_rmilx lln_rmilx l2ln_rmilx ln_rnmilx lln_rnmilx l2ln_rnmilx dln_ck
global x212list lumei ln_rmilx lln_rmilx l2ln_rmilx ln_rnmilx lln_rnmilx l2ln_rnmilx 
global x312list dlln_gdp_con ln_rinvestment dlnlabor ln_rmilx lln_rmilx l2ln_rmilx 
* SUR model
xtsur ($y11list $x112list) ($y21list $x212list) ($y31list $x312list)
