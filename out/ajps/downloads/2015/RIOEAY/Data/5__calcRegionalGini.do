/* 
Step 5 of 6
Calculate gini with bootstrapped SEs */
/* cf. Karagiannis, E., & Kovacevic, M. (2000). 
A Method to Calculate the Jackknife Variance Estimator 
for the Gini Coefficient. 
Oxford Bulletin of Economics and Statistics, 62(1), 119–122. 
*/



* Read imputed data sets and average over imputations
forvalues i = 1/5{
    use "data_imp`i'.dta", clear
    keep region income_ppp2005 cntryn weight
    gen rownum = _n
    save _temp`i', replace
}
use _temp1,clear
append using _temp2 _temp3 _temp4 _temp5

collapse income_ppp2005 weight region cntryn, by(rownum)
bys region: gen RginiN = _N


* set up variables
gen Rgini = .
gen RginiSE = .

* Calc Gini by Region
levels region, local(levels)
foreach v of local levels{
  dis "------ `v' -------"
  qui: fastgini income_ppp2005 [w=weight] if region==`v', jk
  replace Rgini = `r(gini)' if region==`v'
  replace RginiSE = `r(se)' if region==`v'
}

collapse Rgini RginiSE RginiN, by(region)


save RegionalGini, replace

* Clean up temp files
rm "_temp1.dta"
rm "_temp2.dta"
rm "_temp3.dta"
rm "_temp4.dta"
rm "_temp5.dta"


