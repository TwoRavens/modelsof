**************
**Prepare data
**************

use "./data/VAdataset.dta", clear
drop if ecode==icode
collapse (sum) vaexports exports, by(ecode icode year)
sort ecode icode
merge ecode icode using "./data/distance.dta"
keep if _merge==3
drop _merge
keep ecode icode year vaexports exports contig comlang_off colony dist
gen vax=vaexports/exports
gen logvax=ln(vax)
gen logvaexports=ln(vaexports)
gen logexports=ln(exports)
gen logdist=log(dist)
egen pair=group(ecode icode)

**Choose sample
gen sample=0
replace sample=1 if exports>1 & vax<10
keep if sample==1

save "./data/gravity_data", replace

************************
**Run Gravity Estimation
************************

collapse sample, by(year)
sort year
save "./data/temp", replace

set matsize 10000
**Panel regressions
foreach var in logvax logexports logvaexports {
	use "./data/gravity_data", clear
	xi i.ecode*i.year i.icode*i.year i.year*logdist, noomit
	qui: reg `var' _I*, vce(cluster pair)
	mat beta=e(b)
	mat stderr=e(V)
	local coeffend=colsof(beta)-1
	local coeffbegin=colsof(beta)-40
	mat distcoeff=beta[1,`coeffbegin'..`coeffend']
	mat varcov=stderr[`coeffbegin'..`coeffend',`coeffbegin'..`coeffend']
	mat diag=vecdiag(varcov)
	svmat distcoeff
	svmat diag
	keep distcoeff* diag*
	keep if _n==1
	gen temp=1
	reshape long distcoeff diag, i(temp)
	gen se=sqrt(diag)
	gen year=_j+1969
	keep year distcoeff se
	ren distcoeff distcoeff_`var'
	ren se se_`var'
	sort year
	merge year using "./data/temp"
	drop _merge
	sort year
	save "./data/temp", replace
	}
	
save "./data/distance_coefficients", replace

gen distcoeff_logvaexports_high=distcoeff_logvaexports+1.645*se_logvaexports 
gen distcoeff_logvaexports_low=distcoeff_logvaexports-1.645*se_logvaexports 
gen distcoeff_logexports_high=distcoeff_logexports+1.645*se_logexports 
gen distcoeff_logexports_low=distcoeff_logexports-1.645*se_logexports 
gen distcoeff_logvax_high=distcoeff_logvax+1.645*se_logvax
gen distcoeff_logvax_low=distcoeff_logvax-1.645*se_logvax 

******************************************
**Figure 4: Gravity Coefficients over time
******************************************
#d ;
graph twoway (line distcoeff_logvax_high distcoeff_logvax_low year, ylabel(0(0.05).25) lpattern(dash dash) lwidth(vvthin vvthin) color(navy navy)) 
			 (line distcoeff_logvax year, lcolor(navy) lwidth(medthick) leg(off) xtitle("")
	plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin()));
graph export "./figures_and_tables/distance_coefficient_vax.pdf", replace;

#d ;
graph twoway (line distcoeff_logexports_high distcoeff_logexports_low year, lpattern(dash dash) lwidth(vvthin vvthin) color(navy navy)) 
			 (line distcoeff_logvaexports_high distcoeff_logvaexports_low year, lpattern(dash dash) lwidth(vvthin vvthin) color(navy navy) ) 
			 (line distcoeff_logexports distcoeff_logvaexports year, lcolor(navy navy) lpattern(solid longdash) lwidth(medthick medthick) 
	legend(region(color(none)) order(6 5) label(6 "Value-Added Exports") label(5 "Gross Exports") size(medsmall) position(7) ring(0) col(1)) xtitle("")
	plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin()));
graph export "./figures_and_tables/distance_coefficient_trade.pdf", replace;

#d cr		
****************************************************
**Appendix T Gravity Regressions in Long Differences
****************************************************
use "./data/gravity_data", clear
keep if year==1975 | year==2005
egen yr=group(year)
tsset pair yr

gen logvaxdiff=log(vax)-log(L.vax)
gen logexportsdiff=log(exports)-log(L.exports)
gen logvaexportsdiff=log(vaexports)-log(L.vaexports)

keep if year==2005
drop if logvaxdiff==.

foreach var in logvaxdiff logvaexportsdiff logexportsdiff {
**Run estimates
est drop _all
qui: xi: reg `var' i.ecode i.icode logdist, robust
est store col1
qui: xi: reg `var' i.ecode i.icode logdist contig, robust
est store col2
qui: xi: reg `var' i.ecode i.icode logdist colony, robust
est store col3
qui: xi: reg `var' i.ecode i.icode logdist comlang_off, robust
est store col4
qui: xi: reg `var' i.ecode i.icode logdist contig colony comlang_off, robust
est store col5
#d ;
estout col1 col2 col3 col4 col5 using "./figures_and_tables/table_`var'_long_differences_regressions.txt",	
	keep(logdist contig colony comlang_off)
	stats(r2 N,fmt(%9.2f %9.0f) labels(R-squared)) 
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f %9.3f))) 
	varlabels(_cons Constant) varwidth(16) modelwidth(12) delimiter("") collabels(, none)
	starlevels(* 0.10 ** 0.05 *** 0.01) replace;
#d cr
}	

erase "./data/gravity_data.dta"
capture erase "./data/temp.dta"
capture erase "./data/distance_coefficients.dta"

cd ..

