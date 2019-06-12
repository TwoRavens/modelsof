
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust quantile(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`quantile'" == "") {
		`anything' `if' `in', cluster(`cluster') `robust'
		}
	else {
		bootstrap, reps(500) cluster(id) seed(1): `anything' `if' `in', quantile(`quantile')
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$ii,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$jj+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global ii = $ii + 1
global jj = $jj + $k
end

****************************************
****************************************

use DatALO1, clear

global basic1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
global basic2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
global all1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9
global all2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9

matrix F = J(87,4,.)
matrix B = J(255,2,.)

global ii = 1
global jj = 1

*Table 3
foreach X in signup used_ssp used_adv used_fsg {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="F", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="F", robust
	}
	
*Table 5 
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

*Table 6 
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
	
generate Order = _n

egen m = group(ssp sfp sfsp)

global i = 0

*Table 3
foreach X in signup used_ssp used_adv used_fsg {
	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') reg `X' ssp sfp sfsp $basic1 if noshow == 0, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}

	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') reg `X' ssp sfp sfsp $all1 if noshow == 0, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}

	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="M", robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}

	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="M", robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}

	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="F", robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}

	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="F", robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	}
	
*Table 5 
foreach X in grade_20059_fall GPA_year1 {
	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') reg `X' ssp sfp sfsp $all1 if noshow == 0, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	foreach var in ssp sfpany {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') reg `X' ssp sfpany $all1 if noshow == 0, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	}

foreach X in grade_20059_fall GPA_year1 {
	foreach group in 2 3 {
		foreach var in ssp sfp sfsp {
			global i = $i + 1
			capture drop Strata
			gen Strata = (m == 1 | `var' == 1)
			randcmdc ((`var') reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group', robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
			}
		foreach var in ssp sfpany {
			global i = $i + 1
			capture drop Strata
			gen Strata = (m == 1 | `var' == 1)
			randcmdc ((`var') reg `X' ssp sfpany $all2 if noshow == 0 & group`group', robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
			}
		}
	}


*Table 6 
foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') reg `X' ssp sfp sfsp $all1 if noshow == 0 & C, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	}

foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	foreach group in 2 3 {
		foreach var in ssp sfp sfsp {
			global i = $i + 1
			capture drop Strata
			gen Strata = (m == 1 | `var' == 1)
			randcmdc ((`var') reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group' & C, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
			}
		}	
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') reg `X' ssp sfp sfsp $all1 if noshow == 0 & C, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	foreach group in 2 3 {
		foreach var in ssp sfp sfsp {
			global i = $i + 1
			capture drop Strata
			gen Strata = (m == 1 | `var' == 1)
			randcmdc ((`var') reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group' & C, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
			}
		}	
	}


**************************************

use DatALO2, clear

global all1 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9 YEAR2

egen m = group(ssp sfp sfsp)

*Table 7 
foreach group in 2 3 {
	mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp $all1  if S == 1 & group`group', cluster(id)
	foreach quantile in .1 .25 .5 .75 .9 {
		mycmd (ssp sfp sfsp) qreg GPA_year ssp sfp sfsp $all1 if S == 1 & group`group', quantile(`quantile')
		}	
	}
mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, cluster(id)
mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, cluster(id)
foreach quantile in .1 .25 .5 .75 .9 {
	mycmd (ssp sfp sfsp) qreg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, quantile(`quantile')
	mycmd (ssp sfp sfsp) qreg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, quantile(`quantile')
	}	

sort year id
generate Order = _n

*Table 7 
foreach group in 2 3 {
	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') reg GPA_year ssp sfp sfsp $all1  if S == 1 & group`group', cluster(id)), treatvars(`var') strata(Strata) groupvar(id) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	foreach quantile in .1 .25 .5 .75 .9 {
		foreach var in ssp sfp sfsp {
			global i = $i + 1
			capture drop Strata
			gen Strata = (m == 1 | `var' == 1)
			randcmdc ((`var') bootstrap, reps(500) cluster(id) seed(1): qreg GPA_year ssp sfp sfsp $all1 if S == 1 & group`group', quantile(`quantile')), treatvars(`var') strata(Strata) groupvar(id) seed(1) saving(ip\a$i, replace) reps($reps) sample 
			}
		}	
	}
foreach var in ssp sfp sfsp {
	global i = $i + 1
	capture drop Strata
	gen Strata = (m == 1 | `var' == 1)
	randcmdc ((`var') reg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, cluster(id)), treatvars(`var') strata(Strata) groupvar(id) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}
foreach var in ssp sfp sfsp {
	global i = $i + 1
	capture drop Strata
	gen Strata = (m == 1 | `var' == 1)
	randcmdc ((`var') reg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, cluster(id)), treatvars(`var') strata(Strata) groupvar(id) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach quantile in .1 .25 .5 .75 .9 {
	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') bootstrap, reps(500) cluster(id) seed(1): qreg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, quantile(`quantile')), treatvars(`var') strata(Strata) groupvar(id) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') bootstrap, reps(500) cluster(id) seed(1): qreg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, quantile(`quantile')), treatvars(`var') strata(Strata) groupvar(id) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	}	



***********************

use DatALO3, clear

global all3 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9 YEAR2

egen m = group(ssp sfp sfsp)

*Table 8 
foreach X in prob_year credits_earned GPA_year {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all3 if S == 1, robust cluster(id)
	}	


sort year id
generate Order = _n

foreach X in prob_year credits_earned GPA_year {
	foreach var in ssp sfp sfsp {
		global i = $i + 1
		capture drop Strata
		gen Strata = (m == 1 | `var' == 1)
		randcmdc ((`var') reg `X' ssp sfp sfsp $all3 if S == 1, robust cluster(id)), treatvars(`var') strata(Strata) groupvar(id) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	}

***********************

matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondALO, replace








