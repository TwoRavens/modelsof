


capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string) fe asis]
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust' `fe' `asis'
	testparm `testvars'
	global k = r(df)
	unab testvars: `testvars'
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen MM = group($cluster)
	if ("$cluster" == "") gen MM = _n
	quietly sum MM
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		quietly `anything' if MM ~= `i', cluster(`cluster') `robust' `fe' `asis'
		matrix BB = J($k,2,.)
		local c = 1
		foreach var in `testvars' {
			capture matrix BB[`c',1] = _b[`var'], _se[`var']
			local c = `c' + 1
			}
		matrix F = J(1,3,.)
		capture testparm `testvars'
		if (_rc == 0) matrix F = r(p), r(drop), e(df_r)
		mata BB = st_matrix("BB"); F = st_matrix("F"); ResB[`i',1..$k] = BB[1..$k,1]'; ResSE[`i',1..$k] = BB[1..$k,2]'; ResF[`i',1..3] = F
		}
	quietly drop _all
	quietly set obs $N
	global kk = $j + $k - 1
	forvalues i = $j/$kk {
		quietly generate double ResB`i' = .
		}
	forvalues i = $j/$kk {
		quietly generate double ResSE`i' = .
		}
	quietly generate double ResF$i = .
	quietly generate double ResD$i = .
	quietly generate double ResDF$i = .
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	quietly svmat double B
	quietly rename B2 SE$i
	capture rename B1 B$i
	save ip\JK$i, replace
restore
	global i = $i + 1
	global j = $j + $k
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

*Have to switch here because completely different scheme and coding
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



use ip\JK1, clear
forvalues i = 2/70 {
	merge using ip\JK`i'
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
save results\JackKnifeD, replace

use results\JackknifeD, clear
foreach var in ResF ResD ResDF {
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
save results\JackknifeD, replace

