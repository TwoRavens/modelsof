*----------------------*
*	 Columns 1-2
*----------------------**


use petitionsdataset, clear

* Merge with immigrant arrivals by country and year
merge m:1 country issueyear using arrivals1899_1924
drop if _merge==2
drop _merge

* normalize by total arrivals in 5-10 years before petition was filed
gen pet_arr5_10=petitions/total5_10


gen postwar=(issueyear>=1917)
gen german=(country=="Germany")
gen postgerman=postwar*german


* regressions
estimates clear
xi: reg pet_arr5_10 i.country i.issueyear postgerman, cl(country)
eststo m1
xi: reg pet_arr5_10 i.country i.issueyear postgerman i.state, cl(country)
eststo m2
esttab m* using "TableD5Cols1-2.csv", star(* 0.1 ** 0.05 *** 0.01) replace cells(b(fmt(a3) star) se(par)) stats(N r2) keep(postgerman) 


*----------------------*
*	 Columns 3-4
*----------------------**

*-------------------------------------------------------------------------------
* Uncomment this part of the code to compute the weights used in the regression
/*
* Empirical distribution of years in the US

use petitionsdataset_byarrivalyr, clear
gen yrsUS=issueyear-arrivalyr
drop if yrsUS<0
collapse (count) petitions, by(yrsUS)
egen totalp=total(petitions)
gen weight=petitions/totalp
drop petitions totalp

* Weights used in the code below
*/
*-------------------------------------------------------------------------------

tempfile arrivals
use arrivals1899_1924, clear
xtset c issueyear
gen wtot5=L1.admissions*0.018+L2.admissions*0.01959+L3.admissions*0.02047+L4.admissions*0.02065+L5.admissions*0.03389 ///
			/(0.018+0.01959+0.02047+0.02065+0.03389)
gen wtot10=L1.admissions*0.018+L2.admissions*0.01959+L3.admissions*0.02047+L4.admissions*0.02065+L5.admissions*0.03389 ///
			+L6.admissions*0.04244+L7.admissions*0.04209+L8.admissions*0.04076+L9.admissions*0.04121+L10.admissions*0.0419 ///
			/(0.018+0.01959+0.02047+0.02065+0.03389+0.04244+0.04209+0.04076+0.04121+0.0419)
gen wtot5_10=L5.admissions*0.03389+L6.admissions*0.04244+L7.admissions*0.04209+L8.admissions*0.04076+L9.admissions*0.04121+L10.admissions*0.0419 ///
			/(0.03389+0.04244+0.04209+0.04076+0.04121+0.0419)
gen wtotL5=0.03389*admissions
save `arrivals', replace


use petitionsdataset, clear
merge m:1 country issueyear using `arrivals'
drop if _merge==2
drop _merge
gen w5_10=petitions/wtot5_10

gen postwar=(issueyear>=1917)
gen german=(country=="Germany")
gen postgerman=postwar*german


* regressions
estimates clear
xi: reg w5_10 i.country i.issueyear postgerman, cl(country)
eststo m3
xi: reg w5_10 i.country i.issueyear postgerman i.state, cl(country)
eststo m4
esttab m* using "TableD5Cols3-4.csv", star(* 0.1 ** 0.05 *** 0.01) replace cells(b(fmt(a3) star) se(par)) stats(N r2) keep(postgerman) 
