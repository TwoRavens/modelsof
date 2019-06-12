
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	if ($i == 0) {
		global M = ""
		global test = ""
		estimates clear
		capture drop xxx*
		matrix B = J(1,100,.)
		global j = 0
		}
	global i = $i + 1

	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	local newtestvars = ""
	foreach var in `testvars' {
		quietly gen xxx`var'$i = `var'
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in'
	if (_rc == 0) {
		estimates store M$i
		foreach var in `newtestvars' {
			global j = $j + 1
			matrix B[1,$j] = _b[`var']
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatALO1, clear

global basic1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
global basic2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
global all1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9
global all2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9

*Table 3
global i = 0
foreach X in signup {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="F", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="F", robust
	}
foreach X in used_ssp used_adv used_fsg {
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $basic1 if noshow == 0, robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $all1 if noshow == 0, robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $basic2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $all2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $basic2 if noshow == 0 & sex=="F", robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $all2 if noshow == 0 & sex=="F", robust
	}
	
suest $M, robust
test $test
matrix F = r(p), r(drop), r(df), r(chi2), 3
matrix B3 = B[1,1..$j]

*Table 5 
global i = 0
foreach X in grade_20059_fall GPA_year1 {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd (ssp sfpany) reg `X' ssp sfpany $all1 if noshow == 0, robust
	}

foreach X in grade_20059_fall GPA_year1 {
	foreach group in 2 3 {
		mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group', robust
		mycmd (ssp sfpany) reg `X' ssp sfpany $all2 if noshow == 0 & group`group', robust
		}	
	}

local anything = "$test"
global test = ""
matrix B5 = J(1,$j-6,.)
local k = 1
forvalues i = 1/$j {
	gettoken a anything: anything
	if ("`a'" ~= "xxxssp3" & "`a'" ~= "xxxsfpany4" & "`a'" ~= "xxxssp9" & "`a'" ~= "xxxsfpany10" & "`a'" ~= "xxxssp11" & "`a'" ~= "xxxsfpany12") {
		global test = "$test" + " " + "`a'"
		matrix B5[1,`k'] = B[1,`i']
		local k = `k' + 1
		}
	}
global j = $j - 6

suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

*Table 6 
global i = 0
foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0 & C, robust
	}	

foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	foreach group in 2 3 {
		mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group' & C, robust
		}	
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0 & C, robust
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	foreach group in 2 3 {
		mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group' & C, robust
		}	
	}

suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)
matrix B6 = B[1,1..$j]

gen N = id
sort N
save aa, replace

egen NN = max(N)
keep NN
gen obs = _n
save aaa, replace

mata ResF = J($reps,15,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop id
	rename obs id

*Table 3
global i = 0
foreach X in signup {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="F", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="F", robust
	}
foreach X in used_ssp used_adv used_fsg {
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $basic1 if noshow == 0, robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $all1 if noshow == 0, robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $basic2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $all2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $basic2 if noshow == 0 & sex=="F", robust
	mycmd (ssp sfsp) reg `X' ssp sfsp sfp $all2 if noshow == 0 & sex=="F", robust
	}
	
capture suest $M, cluster(id)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}

*Table 5 
global i = 0
foreach X in grade_20059_fall GPA_year1 {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd (ssp sfpany) reg `X' ssp sfpany $all1 if noshow == 0, robust
	}

foreach X in grade_20059_fall GPA_year1 {
	foreach group in 2 3 {
		mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group', robust
		mycmd (ssp sfpany) reg `X' ssp sfpany $all2 if noshow == 0 & group`group', robust
		}	
	}

capture suest $M, robust
if (_rc == 0) {
	local anything = "$test"
	global test = ""
	matrix bb = J(1,$j-6,.)
	local k = 1
	forvalues i = 1/$j {
	gettoken a anything: anything
	if ("`a'" ~= "xxxssp3" & "`a'" ~= "xxxsfpany4" & "`a'" ~= "xxxssp9" & "`a'" ~= "xxxsfpany10" & "`a'" ~= "xxxssp11" & "`a'" ~= "xxxsfpany12") {
		global test = "$test" + " " + "`a'"
		matrix bb[1,`k'] = B[1,`i']
		local k = `k' + 1
		}
	}
	global j = $j - 6
	matrix B = bb[1,1..$j]
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
		}
	}

*Table 6 
global i = 0
foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0 & C, robust
	}	

foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	foreach group in 2 3 {
		mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group' & C, robust
		}	
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0 & C, robust
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	foreach group in 2 3 {
		mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group' & C, robust
		}	
	}

capture suest $M, cluster(id)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B6)*invsym(V)*(B[1,1..$j]-B6)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 6)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/15 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestredALO1, replace

***********************************
***********************************

use DatALO2, clear

global all1 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9 YEAR2

*Table 7 
global i = 0
foreach group in 2 3 {
	mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp $all1  if S == 1 & group`group', cluster(id)
	}
mycmd (sfsp) reg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, cluster(id)
mycmd (sfsp) reg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, cluster(id)

quietly suest $M, cluster(id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)	
matrix B7 = B[1,1..$j]

gen N = id
sort N
save bb, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb
	drop id
	rename obs id

*Table 7 
global i = 0
foreach group in 2 3 {
	mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp $all1  if S == 1 & group`group', cluster(id)
	}
mycmd (sfsp) reg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, cluster(id)
mycmd (sfsp) reg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, cluster(id)

capture suest $M, cluster(id)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B7)*invsym(V)*(B[1,1..$j]-B7)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 7)
		}
	}
}

drop _all
set obs $reps
forvalues i = 16/20 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestredALO2, replace

*****************************************
*****************************************

use DatALO3, clear

global all3 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9 YEAR2

*Table 8
global i = 0
foreach X in prob_year credits_earned GPA_year {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all3 if S == 1, robust cluster(id)
	}	

quietly suest $M, cluster(id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 8)
matrix B8 = B[1,1..$j]

*****************************************
*****************************************

use ip\OBootstrapSuestredALO1, clear
merge 1:1 N using ip\OBootstrapSuestredALO2, nogenerate
merge 1:1 N using ip\OBootstrapSuestALO3, nogenerate
drop F*
svmat double F
aorder
save results\OBootstrapSuestredALO, replace

capture erase aa.dta
capture erase bb.dta
capture erase cc.dta
capture erase aaa.dta

