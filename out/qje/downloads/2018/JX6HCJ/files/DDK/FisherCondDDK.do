
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		`anything' `if' `in', cluster(`cluster') absorb(`absorb')
		}
	else {
		`anything' `if' `in', cluster(`cluster')
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************

use DatDDK1, clear

matrix F = J(33,4,.)
matrix B = J(82,2,.)

global i = 1
global j = 1

*Table 2
foreach var in stdR_totalscore stdR_r2_totalscore {
	mycmd (tracking) reg `var' tracking, cluster(schoolid)
	mycmd (tracking) reg `var' tracking girl percentile agetest etpteacher, cluster(schoolid)
	mycmd (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf girl percentile agetest etpteacher, cluster(schoolid)
	mycmd (tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking) reg `var' tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking bottomquarter secondquarter topquarter girl percentile agetest etpteacher, cluster(schoolid)
	}
foreach var in stdR_mathscore stdR_litscore stdR_r2_mathscore stdR_r2_litscore {
	mycmd (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf girl percentile agetest etpteacher, cluster(schoolid)
	mycmd (tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking) reg `var' tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking bottomquarter secondquarter topquarter girl percentile agetest etpteacher, cluster(schoolid)
	}

*Table 3
foreach cat in girl cont {
	mycmd (`cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf `cat'_tracking_tophalf anti`cat'_tracking_tophalf) reg stdR_totalscore `cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf  `cat'_tracking_tophalf anti`cat'_tracking_tophalf bottomhalf `cat'_bottomhalf percentile girl agetest etpteacher, cluster(schoolid)
	mycmd (`cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf `cat'_tracking_tophalf anti`cat'_tracking_tophalf) reg stdR_r2_totalscore `cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf  `cat'_tracking_tophalf anti`cat'_tracking_tophalf bottomhalf `cat'_bottomhalf percentile girl agetest etpteacher, cluster(schoolid)
	}

*************************

use DatDDK2, clear

*Table 4
foreach var in stdR_totalscore stdR_mathscore stdR_litscore {
	mycmd (rMEANstream_std_baselinemark etpteacher) areg `var' rMEANstream_std_baselinemark etpteacher std_mark girl agetest, absorb(schoolid) cluster(section)
	}

foreach spec in "std_mark>=-0.75&std_mark<=0.75" "std_mark<-0.275" "std_mark>0.75" {
	mycmd (rMEANstream_std_baselinemark etpteacher) areg stdR_totalscore rMEANstream_std_baselinemark etpteacher std_mark girl agetest if `spec', absorb(schoolid) cluster(section)
	}

*************************

use DatDDK3, clear

*Table 7
foreach var in diff1_score diff2_score diff3_score letterscore24  wordscore spellscore24  sentscore24 {
	mycmd (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf agetest girl , cluster(schoolid)
	}

*************************

use DatDDK1, clear

gen Strata = .
forvalues i = 1/140 {
	local j = Y1[`i']
	quietly replace Strata = `j' if schoolid == Y3[`i']
	}

global i = 0

*Table 2
foreach var in stdR_totalscore stdR_r2_totalscore {

	global i = $i + 1
		randcmdc ((tracking) reg `var' tracking, cluster(schoolid)), treatvars(tracking) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schoolid)
	global i = $i + 1
		randcmdc ((tracking) reg `var' tracking girl percentile agetest etpteacher, cluster(schoolid)), treatvars(tracking) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schoolid)

	forvalues j = 1/6 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}
	}


*the rest involve interactions or can't independently randomize

	forvalues j = 1/66 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}


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
save results\FisherCondDDK, replace

