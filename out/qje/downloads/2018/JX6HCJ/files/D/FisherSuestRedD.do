

************************************
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
mycmd (sampleSDT) areg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) absorb(schoolid)
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
mycmd (sampleSDT) areg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) absorb(schoolid)
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
save ip\FisherSuestD1red, replace

***************************************

use results\SuestredD, clear
mkmat F* in 1/7, matrix(F)

use ip\FisherSuestD1red, clear
merge 1:1 N using ip\FisherSuestD3, nogenerate
merge 1:1 N using ip\FisherSuestD4, nogenerate
merge 1:1 N using ip\FisherSuestD5, nogenerate
merge 1:1 N using ip\FisherSuestD7, nogenerate
merge 1:1 N using ip\FisherSuestD8, nogenerate
drop F*
svmat double F
aorder
save results\FisherSuestredD, replace




