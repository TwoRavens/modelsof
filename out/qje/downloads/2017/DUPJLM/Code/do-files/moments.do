set more off 

run hazard_by_group.do

use  oursample.dta,clear
drop if after==.
keep if age>=25 & age<50
keep if uibase>uibase70
for any qeduc linc2002 linc2003 occlastjob1dig  : cap drop X_mis
for any qeduc linc2002 linc2003 occlastjob1dig  : gen X_mis= X==.
for any qeduc linc2002 linc2003 occlastjob1dig  : recode X .=0

* Creating some useful dummy variable
tab beguispell_month, gen(beguispell_month)
tab beguispell_day, gen(beguispell_day)
tab qeduc, gen(qeduc)
tab occlastjob1dig, gen(occlastjob1dig)
gen county=int(loc/100)
tab county, gen(county)

su uibase
gen uibase100 =r(max) 

global X qeduc2 qeduc3 age age2 length_nobenef linc2002 linc2003 sex ///
		beguispell_day2-beguispell_day31 occlastjob1dig2-occlastjob1dig10 ///
		qeduc_mis linc2002_mis linc2003_mis occlastjob1dig_mis ///
		  county2-county19

**********************************
*reemployment hazards
**********************************

 local lower "70 60 49 49 30 78"
 local upper "100 78 60 70 49 100"

 
 local n : word count `lower'
 forvalues i = 1/`n' {
      local a : word `i' of `lower'
      local b : word `i' of `upper'
      preserve 
      keep if uibase  > uibase`a' & uibase< uibase`b'
      hazard_by_group d15durnoemp , byvar(after) weekly xline(97.5 277.5 367.5 457.5) scale(15) ///
               maxdur(36)  savefile(nocont)
 
	  hazard_by_group d15durnoemp, byvar(after) weekly xline(97.5 277.5 367.5 457.5) scale(15) /// 
	       maxdur(36)  controls($X) savefile(cont)
	  
	  
	keep if train==0 & reempbon1tier==0      
      hazard_by_group d15durnoemp, byvar(after) weekly xline(97.5 277.5 367.5 457.5) scale(15) /// 
	       maxdur(36)  controls($X) savefile(cont_res)
	
	
	*first saved file
	use ./nocont.dta ,clear
	rename __dby2_1 before_b
	rename __dby2_2 after_b
	rename _se___dby2_1 before_sd
	rename _se___dby2_2 after_sd
	rename wsum wsum_nocont
	*controlod saved file
	merge 1:1 dur using "./cont.dta"
	rename __dby2_1 before_full_b
	rename __dby2_2 after_full_b
	rename _se___dby2_1 before_full_sd
	rename _se___dby2_2 after_full_sd
	rename wsum wsum_cont
	cap drop _m
	merge 1:1 dur using "./cont_res.dta"
	rename __dby2_1 before_full_res_b
	rename __dby2_2 after_full_res_b
	rename _se___dby2_1 before_full_res_sd
	rename _se___dby2_2 after_full_res_sd
	rename wsum wsum_cont_res


	gen period=_n 
	label var before_b "job finding hazard before"
	label var after_b "job finding hazard after"
	label var before_full_b "conditional job finding hazard before"
	label var after_full_b "conditional job finding hazard after"
	label var before_full_res_b "conditional job finding hazard before -restricted sample"
	label var after_full_res_b "conditional job finding hazard after -restricted sample"


	label var period "number of 15 day period"
	 
	order period before_b before_sd after_b after_sd before_full_b before_full_sd after_full_b after_full_sd ///
		before_full_res_b before_full_res_sd after_full_res_b after_full_res_sd
	keep  period before_b before_sd after_b after_sd before_full_b before_full_sd after_full_b after_full_sd ///
		before_full_res_b before_full_res_sd after_full_res_b after_full_res_sd

	save " moments_uibase_`a'_`b'.dta", replace
	export excel using " moments_uibase_`a'_`b'.xls", firstrow(variables) replace

	restore

   }

   
**********************************
**********************************
*reemployment wage moments
**********************************
**********************************   
use  oursample.dta,clear
drop if after==.
keep if age>=25 & age<50
keep if uibase>uibase70

*we control for linear trend in reemployment wages
keep if after!=.
   su beguispell
gen begui2= beguispell-r(mean)
foreach i of numlist 1/36 {
	gen before`i' =d15d==`i' & after==0

}
foreach i of numlist 1/36 {
	gen after`i' =d15d==`i' & after==1

}
*log reemployment wages in USD
gen lreemp2=log(first_inc/200)
quietly  reg lreemp before1-before36 after1-after36 begui2 if d15d<37 , noc

for any bef_wage aft_wage aft_wage_se bef_wage_se pval horizon: cap drop X
for any bef_wage aft_wage aft_wage_se bef_wage_se pval: gen X=.
gen horizon=_n*15 if _n<37
quietly foreach i of numlist 1/36 {
	replace bef_wage=_b[before`i'] in `i'
	replace aft_wage=_b[after`i'] in `i'
	replace bef_wage_se=_se[before`i'] in `i'
	replace aft_wage_se=_se[after`i'] in `i'
	test before`i'= after`i'
	replace pval=r(p) in `i'
}

twoway (connected bef_wage aft_wage horizon, lp(solid dash) ms( s c ) ) ///
	(rcap aft_wage bef_wage horizon if  pval<0.05 & aft_wage>=bef_wage, lcolor(red) lwi(*1.9)) ///
	(rcap bef_wage aft_wage horizon if  pval<0.05 & aft_wage<=bef_wage, lcolor(green) lp(dashed) lwi(*1.9)) , ///
	xline(97.5 277.5 367.5,  lwidth(*.6) ) 	  ///
	ytitle("average log-reemployment wage") xtitle("number of days elapsed since UI claim") ///
	legend(label( 1 before) label(2 after) order(1 2) ) 	graphr(color(white))  scale(.8) ysize(7) xsize(10)
	graph export reempwage_by_durnoemp.ps, replace orientation(landscape) pagesize(letter) tmargin(.5) lmargin(.5) logo(off)
keep aft_w* bef_w*
keep if _n<37
gen durnoemp=_n*15
save reempwage_moments_with_trend.dta, replace





********************************************
********************************************
* alternative time windows for table A-6
********************************************
********************************************


foreach i of numlist 7 10 30 {
	preserve
	   keep if uibase>uibase70
	   keep if after!=.
	   keep if age>=25 & age<50

	   tempvar temp
	   gen `temp' =min(d`i'd, int(540/`i')+1)
	   expand `temp'	
	   bysort id: gen periods=_n
	   gen d`i'dd=d`i'd==periods & cens==0
	   cap gen before=1-after
	   quietly reg d`i'dd c.before#i.period c.after#i.period , noconst  vce(cluster id) 
	   mat def beta_cluster=e(b)'
	   mat def var_cluster=e(V)
	   svmat var_cluster
	   svmat beta_cluster
	   keep var_cluster* beta_cluster
	   keep if beta_cluster<.
		save prob_nocont_fullcov_`i'day.dta, replace
		export excel using "prob_nocont_fullcov_`i'day.xls", firstrow(variables) replace
	restore
}


********************************************
********************************************
* probability moments for table A-6
********************************************
********************************************
 
use  oursample.dta,clear
drop if after==.
keep if age>=25 & age<50
keep if uibase>uibase70
 
*expand d15durnoemp
expand 36


*create the dependent variable

bysort id: gen periods=_n
drop if periods>=37
gen d15d=d15durnoemp==periods & cens==0
  

reg d15d c.before#i.period c.after#i.period , noconst  vce(cluster id)
mat def beta_cluster=e(b)'
mat def var_cluster=e(V)
preserve 
	svmat var_cluster
	svmat beta_cluster
	keep var_cluster* beta_cluster
	label var beta_cluster "coeficients: before1-before36 after1-after36 "
	label var var_cluster1 "these are the covariance matrix of beta_cluster vector"
	keep if _n<73
	save ./transfer/prob_nocont_fullcov.dta, replace
	export excel using "./transfer/prob_nocont_fullcov.xls", firstrow(variables) replace
restore

 