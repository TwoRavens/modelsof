


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

********************************************************
********************************************************

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
matrix B3 = B[1,1..$j]

drop _m
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
mycmd (sampleSDT HIVtreat) areg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) absorb(schoolid)
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
save ip\OBootstrapSuestD1, replace


*******************************
*******************************

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
matrix B4 = B[1,1..$j]

sort schoolid
merge schoolid using Sample2
tab _m
drop _m
sort N
save cc, replace

mata ResF = J($reps,5,.) 
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using cc
	drop schoolid
	rename obs schoolid

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
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
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
save ip\OBootstrapSuestD3, replace


****************************************
****************************************

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
matrix B6 = B[1,1..$j]

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
matrix B104 = B[1,1..$j]

*This part was done in surveys of secondary schools - so sample those secondary schools
*Only half of the observations have primary schoolids of original treatment sample, so can't draw the same primary school sample

sum if cluster == .
drop if cluster == .
generate Order = _n
sort cluster Order
capture drop N
generate N = 1
generate Dif = (cluster ~= cluster[_n-1])
replace N = N[_n-1] + Dif if _n > 1
sort N
save dd, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save bbb, replace

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use bbb, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using dd
	drop cluster
	rename obs cluster

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
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B6)*invsym(V)*(B[1,1..$j]-B6)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 6)
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
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B104)*invsym(V)*(B[1,1..$j]-B104)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 104)
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
save ip\OBootstrapSuestD4, replace

*******************************
*******************************

use DatD5, clear
keep repeat8 secschool training athome evdead05v2 sampleSD girl schoolid
foreach var in repeat8 secschool training athome evdead05v2 {
	rename `var' A`var'
	}
sort schoolid girl
save a1, replace

use DatD6
sort schoolid girl
merge 1:1 schoolid girl using a1

*Table 101
global i = 0
foreach X in Arepeat8 Asecschool Atraining Aathome Aevdead05v2 { 
	mycmd (sampleSD) reg `X'  sampleSD if girl==1
	}
foreach X in Arepeat8 Asecschool Atraining Aathome Aevdead05v2 { 
	mycmd (sampleSD) reg `X'  sampleSD if girl==0
	}

foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==0
	}

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 101)
matrix B101 = B[1,1..$j]

drop _m
sort schoolid
merge schoolid using Sample2
tab _m
drop _m
sort N
save ee, replace

mata ResF = J($reps,5,.) 
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using ee
	drop schoolid
	rename obs schoolid

*Table 101
global i = 0
foreach X in Arepeat8 Asecschool Atraining Aathome Aevdead05v2 { 
	mycmd (sampleSD) reg `X'  sampleSD if girl==1
	}
foreach X in Arepeat8 Asecschool Atraining Aathome Aevdead05v2 { 
	mycmd (sampleSD) reg `X'  sampleSD if girl==0
	}

foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==0
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B101)*invsym(V)*(B[1,1..$j]-B101)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 101)
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
save ip\OBootstrapSuestD5, replace

*******************************
*******************************

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
matrix B102 = B[1,1..$j]

sort schoolid
merge schoolid using Sample2
tab _m
drop _m
sort N
save gg, replace

mata ResF = J($reps,5,.) 
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using gg
	drop schoolid
	rename obs schoolid

*Table 102
global i = 0
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2-ZONE4 ZONE6-ZONE14 if class == 8 & selfinterview == 1, cluster(schoolid)
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE12 ZONE14 if class == 8 & selfinterview == 0, cluster(schoolid)

capture suest $M, cluster(schoolid)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B102)*invsym(V)*(B[1,1..$j]-B102)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 102)
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
save ip\OBootstrapSuestD7, replace

*******************************
*******************************


*Table 103 (datd10 is clustered on secondary school, datd8, datd9 clustered on primary school) 

use DatD9, clear
foreach var in agegap gapabove5 age sdkcpe girl8perboy8 DISTRICT2 ZONE2 ZONE4 ZONE5 ZONE6 ZONE7 ZONE8 ZONE9 ZONE10 ZONE11 ZONE12 ZONE13 ZONE14 class {
	rename `var' AA`var'
	}
keep AA* schoolid pupilid SDonly HIVonly interac sampleSD HIVtreat
gen gsample = 1
save a2, replace

use DatD4, clear
keep cluster
drop if cluster == .
sort cluster
drop if cluster == cluster[_n-1]
merge 1:m cluster using DatD10, nogenerate
gen gsample = 2
drop SCHOOLID-TTstrata
rename cluster schoolid
save a3, replace

use DatD8, clear
gen gsample = 3

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"

append using a2
append using a3
merge m:1 schoolid using Sample2

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
matrix B103 = B[1,1..$j]

drop N
egen N = group(schoolid)
sort N
save hh, replace

drop _all
set obs 410
gen NN = 328 if _n <= 328
replace NN = 82 if _n > 328
gen obs = _n
save ccc, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use ccc, clear
	quietly generate N = ceil(uniform()*NN)
	quietly replace N = N + 328 if NN == 82
	joinby N using hh
	drop schoolid
	rename obs schoolid

*Table A3
global i = 0
mycmd (SDonly HIVonly interac) reg fertafter12 SDonly HIVonly interac ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (SDonly HIVonly interac) reg AAagegap SDonly HIVonly interac AAage AAsdkcpe AAgirl8perboy8 AADISTRICT2 AAZONE* if AAclass == 8, cluster(schoolid)
mycmd (SDonly HIVonly interac)  reg AAgapabove5 SDonly HIVonly interac AAage AAsdkcpe AAgirl8perboy8 AADISTRICT2 AAZONE* if AAclass == 8, cluster(schoolid)
mycmd (SDonly HIVonly interac) reg gapabove5_2 SDonly HIVonly interac unsampled age agemissing girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(schoolid)
mycmd (SDonly HIVonly interac) reg everplayedsex_2 SDonly HIVonly interac unsampled age agemissing boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(schoolid)

capture suest $M, cluster(schoolid)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B103)*invsym(V)*(B[1,1..$j]-B103)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 103)
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
save ip\OBootstrapSuestD8, replace

*******************************
*******************************

use ip\OBootstrapSuestD1, clear
foreach i in 3 4 5 7 8 {
	merge 1:1 N using ip\OBootstrapSuestD`i', nogenerate
	}
drop F*
aorder
svmat double F
save results\OBootstrapSuestD, replace

foreach file in aaa bbb aa bb cc dd ee ff gg hh ii jj a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 {
	capture erase `file'.dta
	}

