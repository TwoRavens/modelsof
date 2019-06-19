local counter=0
foreach year in 00 06 07 08 09 10 11 12 13 {

foreach month of numlist 1/12 {
local counter=`counter'+1

if `month'>=1 & `month'<=9 {
use bas`year'0`month'.dta, clear
}

else { 
use bas`year'`month'.dta, clear
}

keep if age>16 & inlist(mlr,1,2,3,4)
keep month year stfips age vetevr afnow grdatn mlr occmaj ///
wgt wgtbls wgtl 


	if `counter'==1 {
		tempfile a
		save `a', replace
	}

	else {
		append using `a' 
		save `a', replace
	}

}
}


gen wgtbls2=wgtbls/(12*10000)
gen wgt2=wgtbls/(12*10000)

gen age_lvl="gt35" if age>=35
replace age_lvl="lt35" if age<35

gen educ_lvl=""
replace educ_lvl="baplus" if grdatn>=43
replace educ_lvl="ltba" if grdatn>=31 & grdatn<43

gen occsoc_broadgroup=.
replace occsoc_broadgroup=2 if occmaj==1
replace occsoc_broadgroup=3 if occmaj==2
replace occsoc_broadgroup=4 if occmaj==3
replace occsoc_broadgroup=5 if occmaj==4 | occmaj==5
replace occsoc_broadgroup=6 if occmaj==6 | occmaj==7 | occmaj==8
replace occsoc_broadgroup=7 if occmaj==9 | occmaj==10

gen empstat="emp" if mlr==1 | mlr==2
replace empstat="unemp" if mlr==3 | mlr==4
keep if empstat!=""

save CPS_unicon_data_00_06_13.dta, replace

********************************************************************************

drop if stfips==11

preserve
keep if year==2000
collapse (sum) count=wgt2, by(stfips educ_lvl)
reshape wide count, i(stfips) j(educ_lvl) string
gen bdshare2000=(countbaplus/(countbaplus+countltba))*100
keep stfips bdshare2000
tempfile b
save `b', replace
restore

preserve
keep if year==2000
collapse (sum) count=wgt2, by(stfips age_lvl)
reshape wide count, i(stfips) j(age_lvl) string
gen avgage2000=(countgt35/(countgt35+countlt35))*100
keep stfips avgage2000
merge 1:1 stfips using `b', nogen
save `b', replace
restore

drop if year==2000

preserve
collapse (sum) count=wgtbls2, by(stfips year educ_lvl empstat)
keep if educ_lvl=="baplus"
reshape wide count, i(stfips year) j(empstat) string
gen counttotal=countemp+countunemp
gen unemprate_bd=(countunemp/counttotal)*100
keep year stfips unemprate_bd
tempfile c
save `c', replace
restore

preserve
collapse (sum) count=wgtbls2, by(stfips year age_lvl empstat)
keep if age_lvl=="gt35"
reshape wide count, i(stfips year) j(empstat) string
gen counttotal=countemp+countunemp
gen unemprate_35plus=(countunemp/counttotal)*100
keep year stfips unemprate_35plus
tempfile d
save `d', replace
restore

save cps_unicon_allcovars.dta, replace

keep if empstat=="unemp"
drop if occmaj==11
collapse (sum) count=wgtbls2, by(stfips year occsoc_broadgroup)
drop if occsoc_broadgroup==.
rename count unemp_occsoc_broadgroup


merge m:1 stfips using `b', nogen
merge m:1 stfips year using `c', nogen
merge m:1 stfips year using `d', nogen

rename stfips statefip


save cps_bdur.dta, replace
