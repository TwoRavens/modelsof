
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xxx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' if Ssample$i, 
			quietly predict double xxx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xxx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
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
foreach X in signup used_ssp used_adv used_fsg {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="F", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="F", robust
	}

quietly suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)
	
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

global list = "$test"
foreach X in xxxssp3 xxxsfpany4 xxxssp9 xxxsfpany10 xxxssp11 xxxsfpany12 {
	global list = subinstr("$list","`X'","",1)
	}

quietly suest $M, robust
test $list
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

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

sort id	
generate Order = _n
generate double U = .
mata Y = st_data(.,("ssp","sfp","sfsp","sfpany"))

mata ResF = J($reps,15,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort U
	mata st_store(.,("ssp","sfp","sfsp","sfpany"),Y)

*Table 3
global i = 0
foreach X in signup used_ssp used_adv used_fsg {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="F", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="F", robust
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) { 
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
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
	capture test $list
	if (_rc == 0) { 
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
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

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) { 
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
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
sort N
save ip\FisherSuestALO1, replace

**************************************

use DatALO2, clear

global all1 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9 YEAR2

*Table 7 
global i = 0
foreach group in 2 3 {
	mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp $all1  if S == 1 & group`group', cluster(id)
	}
mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, cluster(id)
mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, cluster(id)

quietly suest $M, cluster(id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

sort year id
generate Order = _n
generate double U = .
global N = 1656
mata Y = st_data((1,$N),("ssp","sfp","sfsp"))

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	matrix FF = J(24,3,.)
	matrix BB = J(72,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort year U in 1/$N
	mata st_store((1,$N),("ssp","sfp","sfsp"),Y)
	sort id year
	foreach j in ssp sfp sfsp {
		quietly replace `j' = `j'[_n-1] if id == id[_n-1] & year == 2
		}

*Table 7 
global i = 0
foreach group in 2 3 {
	mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp $all1  if S == 1 & group`group', cluster(id)
	}
mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, cluster(id)
mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, cluster(id)

capture suest $M, cluster(id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) { 
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 7)
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
sort N
save ip\FisherSuestALO2, replace

************************************************************

*Table 8 

use DatALO3, clear

global all3 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9 YEAR2

global i = 0
foreach X in prob_year credits_earned GPA_year {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all3 if S == 1, robust cluster(id)
	}	

quietly suest $M, cluster(id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 8)

sort year id
generate Order = _n
generate double U = .
global N = 1656
mata Y = st_data((1,$N),("ssp","sfp","sfsp"))

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort year U in 1/$N
	mata st_store((1,$N),("ssp","sfp","sfsp"),Y)
	sort id year
	foreach j in ssp sfp sfsp {
		quietly replace `j' = `j'[_n-1] if id == id[_n-1] & year == 2
		}

global i = 0
foreach X in prob_year credits_earned GPA_year {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all3 if S == 1, robust cluster(id)
	}	

capture suest $M, cluster(id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) { 
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 8)
		}
	}
}

drop _all
set obs $reps
forvalues i = 21/25 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestALO3, replace

*********************************

use ip\FisherSuestALO1, clear
merge 1:1 N using ip\FisherSuestALO2, nogenerate
merge 1:1 N using ip\FisherSuestALO3, nogenerate
drop F*
svmat double F
aorder
save results\FisherSuestALO, replace





