
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust asis fe]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', `asis' `fe'
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust asis fe]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', `asis' `fe'
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************


global b = 8

use DatD1, clear

matrix B = J(129,1,.)

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"  

global j = 1
mycmd (sampleSD HIVtreat) reg fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, asis cluster(schoolid)
foreach X in unmarpreg marpreg {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}

merge m:1 schoolid using Sample2, nogenerate
egen MM = group(schoolid)
global reps = 328

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if MM == `c'

global j = 1
mycmd1 (sampleSD HIVtreat) reg fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd1 (sampleSD HIVtreat) probit fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, asis cluster(schoolid)
foreach X in unmarpreg marpreg {
	mycmd1 (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeD1, replace

*******************************
*******************************

global b = 8

use DatD2, clear

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil d04v1 d04v2 d05v1 d05v2" 

global j = 9
mycmd (sampleSDT HIVtreat) reg fertafter12 sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (sampleSDT HIVtreat) xtreg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) fe 
foreach X in unmarpreg marpreg {
	mycmd (sampleSDT HIVtreat) reg `X' sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}

merge m:1 schoolid using Sample2, nogenerate
egen MM = group(schoolid)
global reps = 328

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if MM == `c'

global j = 1
mycmd1 (sampleSDT HIVtreat) reg fertafter12 sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd1 (sampleSDT HIVtreat) xtreg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) fe 
foreach X in unmarpreg marpreg {
	mycmd1 (sampleSDT HIVtreat) reg `X' sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 9/16 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeD2, replace

*******************************
*******************************

global b = 16

use DatD3, clear

global school_controls="sdkcpe girl8perboy8"

global j = 17
mycmd (sampleSD HIVtreat) reg agegap sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (SDtreat HIVtreat) reg agegap SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14 if agegap!=40, cluster(schoolid) 
mycmd (sampleSD HIVtreat) reg gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd (SDtreat HIVtreat) reg gapabove5 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)
mycmd (sampleSD HIVtreat) reg gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd (SDtreat HIVtreat) reg gapabove10 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)

merge m:1 schoolid using Sample2, nogenerate
egen MM = group(schoolid)
global reps = 328

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if MM == `c'

global j = 1
mycmd1 (sampleSD HIVtreat) reg agegap sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd1 (SDtreat HIVtreat) reg agegap SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14 if agegap!=40, cluster(schoolid) 
mycmd1 (sampleSD HIVtreat) reg gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd1 (sampleSD HIVtreat) probit gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd1 (SDtreat HIVtreat) reg gapabove5 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)
mycmd1 (sampleSD HIVtreat) reg gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd1 (sampleSD HIVtreat) probit gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd1 (SDtreat HIVtreat) reg gapabove10 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 17/32 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeD3, replace

*******************************
*******************************

global b = 52

use DatD4, clear

global indiv_controls="unsampled age agemissing "
global school_controls="boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy "

global j = 33
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster) 
	}
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} boysonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==0, cluster(cluster) 
	}

*This part was done in surveys of secondary schools - so sample those secondary schools
*Only half of the observations have primary schoolids of original treatment sample, so can't draw the same primary school sample

drop if cluster == .
egen MM = group(cluster)
quietly sum MM
global reps = r(max)

preserve
	collapse (mean) MM, by(cluster) fast
	save aaa, replace
restore

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
preserve

drop if MM == `c'

global j = 1
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd1 (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster) 
	}
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd1 (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} boysonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==0, cluster(cluster) 
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 33/84 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeD4, replace

*******************************
*******************************

global b = 10

use DatD5, clear

global j = 85
foreach X in repeat8 secschool training athome evdead05v2 { 
	mycmd (sampleSD) reg `X'  sampleSD if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (sampleSD) reg `X'  sampleSD if girl==0
	}

merge m:1 schoolid using Sample2, nogenerate
egen MM = group(schoolid)
global reps = 328

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if MM == `c'

global j = 1
foreach X in repeat8 secschool training athome evdead05v2 { 
	mycmd1 (sampleSD) reg `X'  sampleSD if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd1 (sampleSD) reg `X'  sampleSD if girl==0
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 85/94 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeD5, replace

*******************************
*******************************

global b = 10

use DatD6, clear

global j = 95
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==0
	}

merge m:1 schoolid using Sample2, nogenerate
egen MM = group(schoolid)
global reps = 328

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if MM == `c'

global j = 1
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd1 (HIVtreat) reg `X' HIVtreat if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd1 (HIVtreat) reg `X' HIVtreat if girl==0
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 95/104 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeD6, replace

*******************************
*******************************

global b = 6

use DatD7, clear

global school_controls="sdkcpe girl8perboy8_2004"

global j = 105
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2-ZONE4 ZONE6-ZONE14 if class == 8 & selfinterview == 1, cluster(schoolid)
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE12 ZONE14 if class == 8 & selfinterview == 0, cluster(schoolid)

merge m:1 schoolid using Sample2, nogenerate
egen MM = group(schoolid)
global reps = 328

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if MM == `c'

global j = 1
mycmd1 (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd1 (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2-ZONE4 ZONE6-ZONE14 if class == 8 & selfinterview == 1, cluster(schoolid)
mycmd1 (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE12 ZONE14 if class == 8 & selfinterview == 0, cluster(schoolid)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 105/110 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeD7, replace

*******************************
*******************************

global b = 3

use DatD8, clear

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"

global j = 111
mycmd (SDonly HIVonly interac) reg fertafter12 SDonly HIVonly interac ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)

merge m:1 schoolid using Sample2, nogenerate
egen MM = group(schoolid)
global reps = 328

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if MM == `c'

global j = 1
mycmd1 (SDonly HIVonly interac) reg fertafter12 SDonly HIVonly interac ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 111/113 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeD8, replace

*******************************
*******************************

global b = 6

use DatD9, clear

global school_controls="sdkcpe girl8perboy8"

global j = 114
mycmd (SDonly HIVonly interac) reg agegap SDonly HIVonly interac age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (SDonly HIVonly interac)  reg gapabove5 SDonly HIVonly interac age  ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)

merge m:1 schoolid using Sample2, nogenerate
egen MM = group(schoolid)
global reps = 328

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if MM == `c'

global j = 1
mycmd1 (SDonly HIVonly interac) reg agegap SDonly HIVonly interac age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd1 (SDonly HIVonly interac)  reg gapabove5 SDonly HIVonly interac age  ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 114/119 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeD9, replace

*******************************
*******************************

global b = 6

use DatD10, clear

global indiv_controls="unsampled age agemissing "
global school_controls="boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy "

global j = 120
mycmd (SDonly HIVonly interac) reg gapabove5_2 SDonly HIVonly interac ${indiv_controls} girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster)
mycmd (SDonly HIVonly interac) reg everplayedsex_2 SDonly HIVonly interac ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster)

drop if cluster == .
merge m:1 cluster using aaa, nogenerate
quietly sum MM
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if MM == `c'

global j = 1
mycmd1 (SDonly HIVonly interac) reg gapabove5_2 SDonly HIVonly interac ${indiv_controls} girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster)
mycmd1 (SDonly HIVonly interac) reg everplayedsex_2 SDonly HIVonly interac ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 120/125 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeD10, replace

**********************
**********************

use ip\OJackknifeD1, clear
forvalues c = 2/10 {
	merge 1:1 N using ip\OJackknifeD`c', nogenerate
	}
aorder
svmat double B
save results\OJackknifeD, replace

*repeats, for table tests
use results\OJackknifeD, clear
foreach var in ResB {
	generate double `var'126 = `var'33
	generate double `var'127 = `var'34
	generate double `var'128 = `var'59
	generate double `var'129 = `var'60
	}
foreach var in B1 {
	replace `var' = `var'[33] if _n == 126
	replace `var' = `var'[34] if _n == 127
	replace `var' = `var'[59] if _n == 128
	replace `var' = `var'[60] if _n == 129
	}
aorder
save results\OJackknifeD, replace



