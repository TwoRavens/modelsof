 use department_code group using "$Externals/Calculations/Homescan/HHxGroup.dta" , clear
duplicates drop
 
merge 1:m group using "$Externals/Calculations/Model/data_for_matlab_iv.dta"

 keep department_code group fips_state_code fips_county_code lnLO_dm_noCounty_PricePerCal year
 
 duplicates drop
 egen county_id=group(fips*)
 reghdfe lnLO_dm_no i.year , a(county_id group)  resid(resid4)
 

 label define depts /// 
 1 "Dry grocery"  ///
 2 "Frozen" ///
 3 "Dairy" ///
 4 "Packaged deli" ///
 5 "Packaged meat" ///
 6 "Fresh produce"
 
 label values department_code depts
 
 gen iv_sd=.
 forvalues i=1/6 {
 sum resid4 if department_code==`i'
 replace iv_sd=`r(sd)' if department==`i'
 }
keep department_code iv_sd
duplicates drop
  gr bar iv_sd, over(department, sort(iv_sd) label(angle(45))) ytitle("Standard deviation of residualized instrument") ///
  graphregion(color(white))
  graph export "Output\ModelEstimates/iv_sd.png", replace
graph export "Output\ModelEstimates/iv_sd.pdf", replace
 
