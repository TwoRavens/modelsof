
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust asis fe]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust' `asis' `fe'
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			bsample if `touse', cluster($cluster) idcluster(`newcluster')
			if ("`fe'" ~= "") xtset `newcluster'
			if ("`cluster'" ~= "") {
				capture `anything', cluster(`newcluster') `robust' `asis' `fe'
				}
			else {
				capture `anything', `robust' `asis' `fe'
				}
			if (_rc == 0) {
			capture mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); B = B[1,1..$k]; V = V[1..$k,1..$k]
			capture testparm `testvars'
			if (_rc == 0 & r(df) == $k) {
				mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1])
				if (e(df_r) == .) mata ResF[`i',1..3] = `r(p)', chi2tail($k,t[1,1]), $k - `r(df)'
				if (e(df_r) ~= .) mata ResF[`i',1...] = `r(p)', Ftail($k,`e(df_r)',t[1,1]/$k), $k - `r(df)', `e(df_r)'
				mata ResB[`i',1...] = B; ResSE[`i',1...] = sqrt(diagonal(V))'
				}
				}
		restore
		}
	preserve
		quietly drop _all
		quietly set obs $reps
		quietly generate double ResF$i = .
		quietly generate double ResFF$i = .
		quietly generate double ResD$i = .
		quietly generate double ResDF$i = .
		global kk = $j + $k - 1
		forvalues i = $j/$kk {
			quietly generate double ResB`i' = .
			}
		forvalues i = $j/$kk {
			quietly generate double ResSE`i' = .
			}
		mata X = ResF, ResB, ResSE; st_store(.,.,X)
		quietly svmat double B
		quietly rename B2 SE$i
		capture rename B1 B$i
		save ip\BS$i, replace
		global i = $i + 1
		global j = $j + $k
	restore
end


*******************

global cluster = "schoolid"

global i = 1
global j = 1

use DatD1, clear

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"  

mycmd (sampleSD HIVtreat) reg fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, asis cluster(schoolid)
foreach X in unmarpreg marpreg {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}

*******************************
*******************************

use DatD2, clear

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil d04v1 d04v2 d05v1 d05v2" 

mycmd (sampleSDT HIVtreat) reg fertafter12 sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (sampleSDT HIVtreat) xtreg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) fe 
foreach X in unmarpreg marpreg {
	mycmd (sampleSDT HIVtreat) reg `X' sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}

*******************************
*******************************

use DatD3, clear

global school_controls="sdkcpe girl8perboy8"

mycmd (sampleSD HIVtreat) reg agegap sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (SDtreat HIVtreat) reg agegap SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14 if agegap!=40, cluster(schoolid) 
mycmd (sampleSD HIVtreat) reg gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd (SDtreat HIVtreat) reg gapabove5 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)
mycmd (sampleSD HIVtreat) reg gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD HIVtreat) probit gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis cluster(schoolid)
mycmd (SDtreat HIVtreat) reg gapabove10 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, cluster(schoolid)

*******************************
*******************************

global cluster = "cluster"

use DatD4, clear

global indiv_controls="unsampled age agemissing "
global school_controls="boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy "

foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster) 
	}
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	mycmd (sampleSD HIVtreat) reg `X' sampleSD HIVtreat ${indiv_controls} boysonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==0, cluster(cluster) 
	}

*******************************
*******************************

global cluster = "schoolid"

use DatD5, clear

foreach X in repeat8 secschool training athome evdead05v2 { 
	mycmd (sampleSD) reg `X'  sampleSD if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (sampleSD) reg `X'  sampleSD if girl==0
	}

*******************************
*******************************

use DatD6, clear

foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	mycmd (HIVtreat) reg `X' HIVtreat if girl==0
	}

*******************************
*******************************

use DatD7, clear

global school_controls="sdkcpe girl8perboy8_2004"

mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2-ZONE4 ZONE6-ZONE14 if class == 8 & selfinterview == 1, cluster(schoolid)
mycmd (sampleSD_survey HIVtreat_survey) reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE12 ZONE14 if class == 8 & selfinterview == 0, cluster(schoolid)

*******************************
*******************************

use DatD8, clear

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"

mycmd (SDonly HIVonly interac) reg fertafter12 SDonly HIVonly interac ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, cluster(schoolid)

*******************************
*******************************

use DatD9, clear

global school_controls="sdkcpe girl8perboy8"

mycmd (SDonly HIVonly interac) reg agegap SDonly HIVonly interac age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)
mycmd (SDonly HIVonly interac)  reg gapabove5 SDonly HIVonly interac age  ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, cluster(schoolid)


*******************************
*******************************

global cluster = "cluster"

use DatD10, clear

global indiv_controls="unsampled age agemissing "
global school_controls="boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy "

mycmd (SDonly HIVonly interac) reg gapabove5_2 SDonly HIVonly interac ${indiv_controls} girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster)
mycmd (SDonly HIVonly interac) reg everplayedsex_2 SDonly HIVonly interac ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, cluster(cluster)


use ip\BS1, clear
forvalues i = 2/70 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/70 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapD, replace

use results\BootstrapD, clear
foreach var in ResF ResD ResDF ResFF {
	generate double `var'71 = `var'17
	generate double `var'72 = `var'30
	}
foreach var in ResB ResSE {
	generate double `var'126 = `var'33
	generate double `var'127 = `var'34
	generate double `var'128 = `var'59
	generate double `var'129 = `var'60
	}
foreach var in B1 B2 {
	replace `var' = `var'[33] if _n == 126
	replace `var' = `var'[34] if _n == 127
	replace `var' = `var'[59] if _n == 128
	replace `var' = `var'[60] if _n == 129
	}
aorder
save results\BootstrapD, replace


