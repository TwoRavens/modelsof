
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string) asis]
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
		estimates store M$i
		global test = "$test" + " " + "`newtestvars'"
		}
	else {
		capture `cmd' `dep' `testvars' `anything' `if' `in', `asis' iterate(100)
		if (_rc == 0) { 
			quietly generate Ssample$i = e(sample)
			local newtestvars = ""
			foreach var in `testvars' {
				quietly generate double xxx`var'$i = `var' if Ssample$i
				local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
				}
			capture `cmd' `dep' `newtestvars' `anything' `if' `in', `asis' iterate(100)
			if (_rc == 0) {
				estimates store M$i
				global test = "$test" + " " + "`newtestvars'"
				}
			}
		}
	global M = "$M" + " " + "M$i"

end

****************************************
****************************************

use DatD1, clear
foreach var in age agemissing double8 sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2 {
	rename `var' A`var'
	}
foreach var in fertafter12 sampleSD HIVtreat unmarpreg marpreg DISTRICT2 DIVISION2 DIVISION3 DIVISION4 DIVISION6 DIVISION8 total_2km {
	rename `var' A`var'
	}
keep A* schoolid pupilid 
bysort schoolid pupilid: gen N = _n
sort schoolid pupilid N
save a1, replace

use DatD2, clear
generate Order = _n
bysort schoolid pupilid: gen N = _n
sort schoolid pupilid N
merge schoolid pupilid N using a1
tab _m N

global Aindiv_controls="Aage Aagemissing Adouble8"
global Aschool_controls="Asdkcpe AmissingKCPE Aclsize Agirl8perboy8 AG_promorate Ateacherperpupil Atimegroup Ad05v1 Ad05v2"  
global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil d04v1 d04v2 d05v1 d05v2" 

global i = 0
*Table 3
mycmd (AsampleSD AHIVtreat) reg Afertafter12 AsampleSD AHIVtreat ${Aindiv_controls} ${Aschool_controls} ADISTRICT2 ADIVISION2-ADIVISION4 ADIVISION6 ADIVISION8 Atotal_2km, cluster(schoolid)
mycmd (AsampleSD AHIVtreat) probit Afertafter12 AsampleSD AHIVtreat ${Aindiv_controls} ${Aschool_controls} ADISTRICT2 ADIVISION2-ADIVISION4 ADIVISION6 ADIVISION8 Atotal_2km, asis cluster(schoolid)
foreach X in Aunmarpreg Amarpreg {
	mycmd (AsampleSD AHIVtreat) reg `X' AsampleSD AHIVtreat ${Aindiv_controls} ${Aschool_controls} ADISTRICT2 ADIVISION2-ADIVISION4 ADIVISION6 ADIVISION8 Atotal_2km, cluster(schoolid)
	}
mycmd (sampleSDT HIVtreat) reg fertafter12 sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (sampleSDT HIVtreat) areg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) absorb(schoolid)
foreach X in unmarpreg marpreg {
	mycmd (sampleSDT HIVtreat) reg `X' sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}

quietly suest $M, cluster(schoolid)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)

generate double U = .
global N = 328
sort TTstrata Order 
mata Y = st_data((1,$N),("HTREAT","M","sumodd"))
sort M KCPE2001 Order
mata YY = st_data((1,$N),"STREAT")
generate a = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	sort Order
	quietly replace U = uniform() in 1/$N
	sort TTstrata U in 1/$N
	mata st_store((1,$N),("HTREAT","M","sumodd"),Y)

	sort M KCPE2001 Order
	capture drop medianindicator
	by M: gen medianindicator = (_n <= sumodd)
	quietly replace U = uniform() in 1/$N
	sort M medianindicator U
	mata st_store((1,$N),"STREAT",YY)

*This part of the code comes from analysis of create_data_studycohort.do file, which created the datafile used herein
*HIVtreat based upon sch03v1, failing that sch04v1
*Tested this code (unrandomized) and it reproduces the treatment vector in the data files
	quietly replace a = .
	forvalues i = 1/$N {
		quietly replace sampleSD = STREAT[`i'] if schoolid == SCHOOLID[`i']
		quietly replace a = HTREAT[`i'] if sch03v1 == SCHOOLID[`i']
		}
	forvalues i = 1/$N {
		quietly replace a = HTREAT[`i'] if sch04v1 == SCHOOLID[`i'] & a == .
		}
	quietly replace HIVtreat = a
	quietly replace sampleSDT = sampleSD*cohort 

	quietly replace AsampleSD = sampleSD if AsampleSD ~= .
	quietly replace AHIVtreat = HIVtreat if AHIVtreat ~= .

global i = 0
*Table 3
mycmd (AsampleSD AHIVtreat) reg Afertafter12 AsampleSD AHIVtreat ${Aindiv_controls} ${Aschool_controls} ADISTRICT2 ADIVISION2-ADIVISION4 ADIVISION6 ADIVISION8 Atotal_2km, cluster(schoolid)
mycmd (AsampleSD AHIVtreat) probit Afertafter12 AsampleSD AHIVtreat ${Aindiv_controls} ${Aschool_controls} ADISTRICT2 ADIVISION2-ADIVISION4 ADIVISION6 ADIVISION8 Atotal_2km, asis cluster(schoolid)
foreach X in Aunmarpreg Amarpreg {
	mycmd (AsampleSD AHIVtreat) reg `X' AsampleSD AHIVtreat ${Aindiv_controls} ${Aschool_controls} ADISTRICT2 ADIVISION2-ADIVISION4 ADIVISION6 ADIVISION8 Atotal_2km, cluster(schoolid)
	}
mycmd (sampleSDT HIVtreat) reg fertafter12 sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (sampleSDT HIVtreat) areg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) absorb(schoolid)
foreach X in unmarpreg marpreg {
	mycmd (sampleSDT HIVtreat) reg `X' sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}

capture suest $M, cluster(schoolid)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/5 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestD1, replace

*********************************************************

use DatD3, clear

global school_controls="sdkcpe girl8perboy8"

global i = 0
*Table 4
mycmd (sampleSD HIVtreat) reg agegap sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (SDtreat HIVtreat) reg agegap SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14 if agegap!=40, cluster(schoolid) 
mycmd (sampleSD HIVtreat) reg gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd (SDtreat HIVtreat) reg gapabove5 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)
mycmd (sampleSD HIVtreat) reg gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd (SDtreat HIVtreat) reg gapabove10 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)

quietly suest $M, cluster(schoolid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

generate Order = _n
generate double U = .
global N = 328
sort TTstrata Order in 1/$N
mata Y = st_data((1,$N),("HTREAT","M","sumodd"))
sort M KCPE2001 Order
mata YY = st_data((1,$N),"STREAT")
generate a = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	sort Order
	quietly replace U = uniform() in 1/$N
	sort TTstrata U in 1/$N
	mata st_store((1,$N),("HTREAT","M","sumodd"),Y)

	sort M KCPE2001 Order
	capture drop medianindicator
	by M: gen medianindicator = (_n <= sumodd)
	quietly replace U = uniform() in 1/$N
	sort M medianindicator U
	mata st_store((1,$N),"STREAT",YY)

*Tested this code (unrandomized) and it produces the treatment vector in the data files
	forvalues i = 1/$N {
		quietly replace sampleSD = STREAT[`i'] if schoolid == SCHOOLID[`i']
		quietly replace HIVtreat = HTREAT[`i'] if schoolid == SCHOOLID[`i']
		}
	quietly replace SDtreat = sampleSD*cohort

global i = 0
*Table 4
mycmd (sampleSD HIVtreat) reg agegap sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (SDtreat HIVtreat) reg agegap SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14 if agegap!=40, cluster(schoolid) 
mycmd (sampleSD HIVtreat) reg gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd (SDtreat HIVtreat) reg gapabove5 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)
mycmd (sampleSD HIVtreat) reg gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd (SDtreat HIVtreat) reg gapabove10 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)

capture suest $M, cluster(schoolid)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

}

drop _all
set obs $reps
forvalues i = 6/10 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestD3, replace

**********************************************************************************


use DatD4, clear

global indiv_controls="unsampled age agemissing "
global school_controls="boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy "

*Table 6
global i = 0
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster) 
	}
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} boysonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==0, cluster(cluster) 
	}

quietly suest $M, cluster(cluster)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

*Table 104
global i = 0
foreach X in multiplepartner regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster) 
	}
foreach X in multiplepartner regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} boysonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==0, cluster(cluster) 
	}

quietly suest $M, cluster(cluster)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 104)

generate Order = _n
generate double U = .
global N = 328
sort TTstrata Order in 1/$N
mata Y = st_data((1,$N),("HTREAT","M","sumodd"))
sort M KCPE2001 Order
mata YY = st_data((1,$N),"STREAT")
generate a = .

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	sort Order
	quietly replace U = uniform() in 1/$N
	sort TTstrata U in 1/$N
	mata st_store((1,$N),("HTREAT","M","sumodd"),Y)

	sort M KCPE2001 Order
	capture drop medianindicator
	by M: gen medianindicator = (_n <= sumodd)
	quietly replace U = uniform() in 1/$N
	sort M medianindicator U
	mata st_store((1,$N),"STREAT",YY)

*Tested this code (unrandomized) and it produces the treatment vector in the data files (unsampled = 1, no prischoolid, all get treatment = 0)
	forvalues i = 1/$N {
		quietly replace sampleSD = STREAT[`i'] if prischoolid == SCHOOLID[`i']
		quietly replace HIVtreat = HTREAT[`i'] if prischoolid == SCHOOLID[`i']
		}

*Table 6
global i = 0
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster) 
	}
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} boysonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==0, cluster(cluster) 
	}

capture suest $M, cluster(cluster)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
		}
	}

*Table 104
global i = 0
foreach X in multiplepartner regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster) 
	}
foreach X in multiplepartner regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} boysonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==0, cluster(cluster) 
	}

capture suest $M, cluster(cluster)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 104)
		}
	}
}

drop _all
set obs $reps
forvalues i = 11/20 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestD4, replace

*********************************************************************************


use DatD5, clear
keep repeat8 secschool training athome evdead05v2 sampleSD girl schoolid SCHOOLID HTREAT STREAT KCPE2001 M sumodd TTstrata
generate Order = _n
foreach var in repeat8 secschool training athome evdead05v2 {
	rename `var' A`var'
	}
bysort schoolid girl: gen N = _n
sort schoolid girl N
save a1, replace

use DatDD6
keep HIVtreat repeat8 secschool training athome evdead05v2 schoolid girl sch03v1 sch04v1
foreach var in HIVtreat repeat8 secschool training athome evdead05v2 {
	egen a = mean(`var'), by(schoolid girl)
	replace `var' = a
	capture drop a
	}
quietly replace HIVtreat = (HIVtreat >= .5)
bysort schoolid girl: gen N = _n
merge 1:1 schoolid girl N using a1, nogenerate

*Table 101
global i = 0
foreach X in Arepeat8 Asecschool Atraining Aathome Aevdead05v2 { 
	mycmd (sampleSD) reg `X'  sampleSD if girl==1 & N == 1
	}
foreach X in Arepeat8 Asecschool Atraining Aathome Aevdead05v2 { 
	mycmd (sampleSD) reg `X'  sampleSD if girl==0 & N == 1
	}

foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==1 & N == 1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==0 & N == 1
	}

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 101)

generate double U = .
global N = 328
sort TTstrata Order 
mata Y = st_data((1,$N),("HTREAT","M","sumodd"))
sort M KCPE2001 Order
mata YY = st_data((1,$N),"STREAT")
generate a = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	sort Order
	quietly replace U = uniform() in 1/$N
	sort TTstrata U in 1/$N
	mata st_store((1,$N),("HTREAT","M","sumodd"),Y)

	sort M KCPE2001 Order
	capture drop medianindicator
	by M: gen medianindicator = (_n <= sumodd)
	quietly replace U = uniform() in 1/$N
	sort M medianindicator U
	mata st_store((1,$N),"STREAT",YY)

*Tested this code (unrandomized) and it produces the treatment vector in the data files 
	forvalues i = 1/$N {
		quietly replace sampleSD = STREAT[`i'] if schoolid == SCHOOLID[`i']
		}
	quietly replace a = .
	forvalues i = 1/$N {
		quietly replace a = HTREAT[`i'] if sch03v1 == SCHOOLID[`i']
		}
	forvalues i = 1/$N {
		quietly replace a = HTREAT[`i'] if sch04v1 == SCHOOLID[`i'] & a == .
		}
	egen b = mean(a), by(schoolid girl)
	quietly replace HIVtreat = b
	quietly replace HIVtreat = (HIVtreat >= .5)
	drop b

*Table 101
global i = 0
foreach X in Arepeat8 Asecschool Atraining Aathome Aevdead05v2 { 
	mycmd (sampleSD) reg `X'  sampleSD if girl==1 & N == 1
	}
foreach X in Arepeat8 Asecschool Atraining Aathome Aevdead05v2 { 
	mycmd (sampleSD) reg `X'  sampleSD if girl==0 & N == 1
	}

foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==1 & N == 1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==0 & N == 1
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 101)
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
save ip\FisherSuestD5, replace

******************************************************

use DatD7, clear

global school_controls="sdkcpe girl8perboy8_2004"

*Table 102
global i = 0
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2-ZONE4 ZONE6-ZONE14 if class == 8 & selfinterview == 1, cluster(schoolid)
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE12 ZONE14 if class == 8 & selfinterview == 0, cluster(schoolid)

quietly suest $M, cluster(schoolid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 102)

generate Order = _n
generate double U = .
global N = 328
sort TTstrata Order in 1/$N
mata Y = st_data((1,$N),("HTREAT","M","sumodd"))
sort M KCPE2001 Order
mata YY = st_data((1,$N),"STREAT")
generate a = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	sort Order
	quietly replace U = uniform() in 1/$N
	sort TTstrata U in 1/$N
	mata st_store((1,$N),("HTREAT","M","sumodd"),Y)

	sort M KCPE2001 Order
	capture drop medianindicator
	by M: gen medianindicator = (_n <= sumodd)
	quietly replace U = uniform() in 1/$N
	sort M medianindicator U
	mata st_store((1,$N),"STREAT",YY)

*Tested this code (unrandomized) and it produces the treatment vector in the data files
	forvalues i = 1/$N {
		quietly replace sampleSD_survey = STREAT[`i'] if schoolid == SCHOOLID[`i']
		quietly replace HIVtreat_survey = HTREAT[`i'] if schoolid == SCHOOLID[`i']
		}

*Table 102
global i = 0
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2-ZONE4 ZONE6-ZONE14 if class == 8 & selfinterview == 1, cluster(schoolid)
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE12 ZONE14 if class == 8 & selfinterview == 0, cluster(schoolid)

capture suest $M, cluster(schoolid)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 102)
		}
	}
}

drop _all
set obs $reps
forvalues i = 26/30 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestD7, replace

***************************************


*Table 103 (datd10 is clustered on secondary school, datd8, datd9 clustered on primary school) 

use DatD9, clear
foreach var in agegap gapabove5 age sdkcpe girl8perboy8 DISTRICT2 ZONE2 ZONE4 ZONE5 ZONE6 ZONE7 ZONE8 ZONE9 ZONE10 ZONE11 ZONE12 ZONE13 ZONE14 class {
	rename `var' AA`var'
	}
keep AA* schoolid pupilid SDonly HIVonly interac sampleSD HIVtreat
gen gsample = 1
save a2, replace

use DatD10, clear
rename cluster schoolid
gen gsample = 2
drop SCHOOLID-TTstrata
save a3, replace

use DatD8, clear
gen gsample = 3

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"

append using a2
append using a3
generate Order = _n

*Table A3
global i = 0
mycmd (SDonly HIVonly interac) reg fertafter12 SDonly HIVonly interac ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (SDonly HIVonly interac) reg AAagegap SDonly HIVonly interac AAage AAsdkcpe AAgirl8perboy8 AADISTRICT2 AAZONE* if AAclass == 8, cluster(schoolid)
mycmd (SDonly HIVonly interac)  reg AAgapabove5 SDonly HIVonly interac AAage AAsdkcpe AAgirl8perboy8 AADISTRICT2 AAZONE* if AAclass == 8, cluster(schoolid)
mycmd (SDonly HIVonly interac) reg gapabove5_2 SDonly HIVonly interac unsampled age agemissing girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(schoolid)
mycmd (SDonly HIVonly interac) reg everplayedsex_2 SDonly HIVonly interac unsampled age agemissing boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(schoolid)

quietly suest $M, cluster(schoolid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 103)

generate double U = .
global N = 328
sort TTstrata Order in 1/$N
mata Y = st_data((1,$N),("HTREAT","M","sumodd"))
sort M KCPE2001 Order
mata YY = st_data((1,$N),"STREAT")
generate a = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	sort Order
	quietly replace U = uniform() in 1/$N
	sort TTstrata U in 1/$N
	mata st_store((1,$N),("HTREAT","M","sumodd"),Y)

	sort M KCPE2001 Order
	capture drop medianindicator
	by M: gen medianindicator = (_n <= sumodd)
	quietly replace U = uniform() in 1/$N
	sort M medianindicator U
	mata st_store((1,$N),"STREAT",YY)

*This part of the code comes from analysis of create_data_studycohort.do file, which created the datafile used herein
*HIVtreat based upon sch03v1, failing that sch04v1
*Tested this code (unrandomized) and it produces the treatment vector in the data files
	quietly replace a = .
	forvalues i = 1/$N {
		quietly replace sampleSD = STREAT[`i'] if schoolid == SCHOOLID[`i'] & gsample == 3
		quietly replace a = HTREAT[`i'] if sch03v1 == SCHOOLID[`i'] & gsample == 3
		quietly replace sampleSD = STREAT[`i'] if schoolid == SCHOOLID[`i'] & gsample == 1 
		quietly replace HIVtreat = HTREAT[`i'] if schoolid == SCHOOLID[`i'] & gsample == 1
		quietly replace sampleSD = STREAT[`i'] if prischoolid == SCHOOLID[`i'] & gsample == 2
		quietly replace HIVtreat = HTREAT[`i'] if prischoolid == SCHOOLID[`i'] & gsample == 2
		}
	forvalues i = 1/$N {
		quietly replace a = HTREAT[`i'] if sch04v1 == SCHOOLID[`i'] & a == . & gsample == 3
		}
	quietly replace HIVtreat = a if gsample == 3
	quietly replace SDonly = sampleSD*(1-HIVtreat)
	quietly replace HIVonly = HIVtreat*(1-sampleSD)
	quietly replace interac = sampleSD*HIVtreat

*Table A3
global i = 0
mycmd (SDonly HIVonly interac) reg fertafter12 SDonly HIVonly interac ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (SDonly HIVonly interac) reg AAagegap SDonly HIVonly interac AAage AAsdkcpe AAgirl8perboy8 AADISTRICT2 AAZONE* if AAclass == 8, cluster(schoolid)
mycmd (SDonly HIVonly interac)  reg AAgapabove5 SDonly HIVonly interac AAage AAsdkcpe AAgirl8perboy8 AADISTRICT2 AAZONE* if AAclass == 8, cluster(schoolid)
mycmd (SDonly HIVonly interac) reg gapabove5_2 SDonly HIVonly interac unsampled age agemissing girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(schoolid)
mycmd (SDonly HIVonly interac) reg everplayedsex_2 SDonly HIVonly interac unsampled age agemissing boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(schoolid)

capture suest $M, cluster(schoolid)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 103)
		}
	}
}

drop _all
set obs $reps
forvalues i = 31/35 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestD8, replace


***************************************

use ip\FisherSuestD1, clear
merge 1:1 N using ip\FisherSuestD3, nogenerate
merge 1:1 N using ip\FisherSuestD4, nogenerate
merge 1:1 N using ip\FisherSuestD5, nogenerate
merge 1:1 N using ip\FisherSuestD7, nogenerate
merge 1:1 N using ip\FisherSuestD8, nogenerate
drop F*
svmat double F
aorder
save results\FisherSuestD, replace




