

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, robust cluster(string) absorb(string) asis]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		matrix B = J(1,300,.)
		estimates clear
		global j = 0
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' [`weight' `exp'] if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' [`weight' `exp'] if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture reg yyy$i `newtestvars' [`weight' `exp'], noconstant
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	else {
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' 
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture `cmd' `dep' `newtestvars' `anything' `if' `in', `asis'
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

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
bysort schoolid pupilid: gen n = _n
sort schoolid pupilid n
save a1, replace

use DatD2, clear
generate Order = _n
bysort schoolid pupilid: gen n = _n
sort schoolid pupilid n
merge schoolid pupilid n using a1
tab _m n
drop _m

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
matrix B3 = B[1,1..$j]

sort schoolid
merge schoolid using Sample2
tab _m
drop _m
sort N
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop schoolid
	rename obs schoolid

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
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
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
save ip\OBootstrapSuestredD1, replace

*************************************

use results\SuestRedD, clear
mkmat F* in 1/7, matrix(F)

use ip\OBootstrapSuestredD1, clear
merge 1:1 N using ip\OBootstrapSuestD3, nogenerate
merge 1:1 N using ip\OBootstrapSuestD4, nogenerate
merge 1:1 N using ip\OBootstrapSuestD5, nogenerate
merge 1:1 N using ip\OBootstrapSuestD7, nogenerate
merge 1:1 N using ip\OBootstrapSuestD8, nogenerate
drop F*
svmat double F
aorder
save results\OBootstrapSuestredD, replace

foreach file in aaa bbb aa bb cc dd ee ff gg hh ii jj a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 {
	capture erase `file'.dta
	}

