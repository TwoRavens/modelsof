
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string) asis]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

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
		`cmd' `dep' `testvars' `anything' `if' `in', `asis'
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xxx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', `asis'
		}
	estimates store M$i
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

global j = $j + $k
end

****************************************
****************************************

matrix B = J(129,2,.)
global j = 1

*********************************************************************************************

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
bysort schoolid pupilid: gen N = _n
sort schoolid pupilid N
merge schoolid pupilid N using a1
tab _m

global Aindiv_controls="Aage Aagemissing Adouble8"
global Aschool_controls="Asdkcpe AmissingKCPE Aclsize Agirl8perboy8 AG_promorate Ateacherperpupil Atimegroup Ad05v1 Ad05v2"  

global i = 0

*Table 3

mycmd (AsampleSD AHIVtreat) reg Afertafter12 AsampleSD AHIVtreat ${Aindiv_controls} ${Aschool_controls} ADISTRICT2 ADIVISION2-ADIVISION4 ADIVISION6 ADIVISION8 Atotal_2km, cluster(schoolid)
mycmd (AsampleSD AHIVtreat) probit Afertafter12 AsampleSD AHIVtreat ${Aindiv_controls} ${Aschool_controls} ADISTRICT2 ADIVISION2-ADIVISION4 ADIVISION6 ADIVISION8 Atotal_2km, asis cluster(schoolid)
foreach X in Aunmarpreg Amarpreg {
	mycmd (AsampleSD AHIVtreat) reg `X' AsampleSD AHIVtreat ${Aindiv_controls} ${Aschool_controls} ADISTRICT2 ADIVISION2-ADIVISION4 ADIVISION6 ADIVISION8 Atotal_2km, cluster(schoolid)
	}

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil d04v1 d04v2 d05v1 d05v2" 

mycmd (sampleSDT HIVtreat) reg fertafter12 sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (sampleSDT HIVtreat) areg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) absorb(schoolid)
foreach X in unmarpreg marpreg {
	mycmd (sampleSDT HIVtreat) reg `X' sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}


quietly suest $M, cluster(schoolid)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)


**********************************************************************************

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

*********************************************************************************

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

******************************************************************************

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

*************************************************

*Table 103 (datd10 is clustered on secondary school, datd8, datd9 clustered on primary school) 

use DatD9, clear
foreach var in agegap gapabove5 SDonly HIVonly interac age sdkcpe girl8perboy8 DISTRICT2 ZONE2 ZONE4 ZONE5 ZONE6 ZONE7 ZONE8 ZONE9 ZONE10 ZONE11 ZONE12 ZONE13 ZONE14 class {
	rename `var' AA`var'
	}
keep AA* schoolid pupilid
bysort schoolid pupilid: gen nobs = _n
save a2, replace

use DatD10, clear
rename cluster schoolid
save a3, replace

use DatD8, clear

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"

bysort schoolid pupilid: gen nobs = _n
merge 1:1 schoolid pupilid nobs using a2, nogenerate
append using a3

global i = 0
mycmd (SDonly HIVonly interac) reg fertafter12 SDonly HIVonly interac ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (AASDonly AAHIVonly AAinterac) reg AAagegap AASDonly AAHIVonly AAinterac AAage AAsdkcpe AAgirl8perboy8 AADISTRICT2 AAZONE* if AAclass == 8, cluster(schoolid)
mycmd (AASDonly AAHIVonly AAinterac)  reg AAgapabove5 AASDonly AAHIVonly AAinterac AAage AAsdkcpe AAgirl8perboy8 AADISTRICT2 AAZONE* if AAclass == 8, cluster(schoolid)
mycmd (SDonly HIVonly interac) reg gapabove5_2 SDonly HIVonly interac unsampled age agemissing girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(schoolid)
mycmd (SDonly HIVonly interac) reg everplayedsex_2 SDonly HIVonly interac unsampled age agemissing boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(schoolid)

quietly suest $M, cluster(schoolid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 103)

***********************************************

drop _all
svmat double F
svmat double B
save results/SuestD, replace






