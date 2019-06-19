clear all

import excel using BLS_ur_state_age_2007_2013.xlsx, clear firstrow

destring Unemployment statefip, replace force /*note 14 missing values-- all 65+ observations*/
recode Unemployment (missing=0)

keep if group=="22" | group=="23" | group=="24" | group=="25"
collapse (sum) Employment Unemployment labor_force, by(year statefip)
gen unemprate_35plus= round((Unemployment/labor_force)*100,.1)
keep statefip year unemprate_35plus

save bls_ur_state_age35plus_2007_2013.dta, replace

import excel statefip=A state=B year=C s_totalpop=D s_laborforce=E s_employment=G s_unemployment=I s_unemprate=J ///
using BLS_annual_state_labor_force_1976_2013.xls, clear cellrange(A9:J2022)

label variable s_laborforce "State Total Labor Force"
label variable s_unemprate "State Unemployment Rate"

keep if length(statefip)==2
drop if statefip=="11"
destring statefip, force replace
labmask statefip, values(state)
 
destring year, force replace
keep if year>=2007
save $pathUPS/data2/merge/bls_state_laborforce_statistics_2007_2013.dta, replace

keep if year==2007 | year==2010 | year==2013
keep statefip year s_unemprate
rename s_unemprate UR
reshape wide UR, i(state) j(year)

gen diff07_10=UR2007-UR2010
gen diff10_13=UR2010-UR2013
label variable diff07_10 "Percentage Point Difference, 2007-2010"
label variable diff10_13 "Percentage Point Difference, 2010-2013"

twoway scatter diff07_10 diff10_13, ///
mlabel(st) ysize(3.5) xsize(6.5) ///
ytitle("Percentage Point Difference, 2010-2013", size(3)) ylab(-10(2)0,labsize(3)) ///
xtitle("Percentage Point Difference, 2007-2010", size(3)) xlab(0(1)4.5,labsize(3)) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) note("Source: Bureau of Labor Statistics Local Area Unemployment Statistics, 2007-2013" , size(2.5))
 


 
