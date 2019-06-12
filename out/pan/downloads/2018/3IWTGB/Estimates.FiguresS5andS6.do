set more off

cd "/path/to/replication/directory/"

***********************************
*Estimates for Figure S.5, Panel B*
***********************************

use ddplacebo1, clear

xtreg gdper i.year trplacebo, fe cluster(muni) 
estimates store oldest
lincomest  trplacebo
parmest,label saving(tr1ete.dta,replace)  
estimates restore oldest


drop isl*  s1trend-s95trend
	
ta muni,gen(isl)
	forvalues num= 1/99 {

	gen s`num'trend=isl`num'*year
	}

xtreg gdper i.year trplacebo s2trend-s98trend, fe cluster(muni) 
estimates store oldest
lincomest  trplacebo
parmest,label saving(tr2ete.dta,replace)  
estimates restore oldest



forvalues x=1/2 {
use tr`x'ete, clear
gen id1=`x'
gen id2=1
save tr`x'ete, replace
}

use tr1ete.dta
append using tr2ete.dta


gen id3=3-id1
saveold tret.dta, replace version(12)





************************************
*Estimates for Figure S.5, Panel A**
************************************

use ddplacebo2, clear

	xtreg gdper i.year treat_post, fe vce(cl nuts3)
	estimates store oldest
	lincomest  treat_post
	parmest,label saving(tr1ete2.dta,replace)  
	estimates restore oldest

	xtreg gdper i.year treat_post trtrend nuts2trend-nuts15trend, fe vce(cl nuts3)
	estimates store oldest
	lincomest  treat_post
	parmest,label saving(tr2ete2.dta,replace)  
	estimates restore oldest

	

	forvalues x=1/2 {
	use tr`x'ete2, clear
	gen id1=`x'
	gen id2=1
	save tr`x'ete2, replace
	}

	use tr1ete2.dta
	append using tr2ete2.dta
	gen id3=3-id1
	saveold tret2.dta, replace version(12)


