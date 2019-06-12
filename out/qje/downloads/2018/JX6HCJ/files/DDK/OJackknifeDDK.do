
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" == "") capture `anything' `if' `in', 
	if ("`absorb'" ~= "") capture `anything' `if' `in', absorb(`absorb')
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
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" == "") capture `anything' `if' `in', 
	if ("`absorb'" ~= "") capture `anything' `if' `in', absorb(`absorb')
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

global b = 56

use DatDDK1, clear

matrix B = J(82,1,.)

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

egen M = group(schoolid)
sum M
global reps = r(max)

mata ResB= J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if M == `c'

global j = 1

*Table 2
foreach var in stdR_totalscore stdR_r2_totalscore {
	mycmd1 (tracking) reg `var' tracking, cluster(schoolid)
	mycmd1 (tracking) reg `var' tracking girl percentile agetest etpteacher, cluster(schoolid)
	mycmd1 (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf girl percentile agetest etpteacher, cluster(schoolid)
	mycmd1 (tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking) reg `var' tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking bottomquarter secondquarter topquarter girl percentile agetest etpteacher, cluster(schoolid)
	}
foreach var in stdR_mathscore stdR_litscore stdR_r2_mathscore stdR_r2_litscore {
	mycmd1 (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf girl percentile agetest etpteacher, cluster(schoolid)
	mycmd1 (tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking) reg `var' tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking bottomquarter secondquarter topquarter girl percentile agetest etpteacher, cluster(schoolid)
	}

*Table 3
foreach cat in girl cont {
	mycmd1 (`cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf `cat'_tracking_tophalf anti`cat'_tracking_tophalf) reg stdR_totalscore `cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf  `cat'_tracking_tophalf anti`cat'_tracking_tophalf bottomhalf `cat'_bottomhalf percentile girl agetest etpteacher, cluster(schoolid)
	mycmd1 (`cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf `cat'_tracking_tophalf anti`cat'_tracking_tophalf) reg stdR_r2_totalscore `cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf  `cat'_tracking_tophalf anti`cat'_tracking_tophalf bottomhalf `cat'_bottomhalf percentile girl agetest etpteacher, cluster(schoolid)
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
save ip\OJackknifeDDK1, replace

*************************************
*************************************

global b = 12

use DatDDK2, clear

global j = 57

*Table 4
foreach var in stdR_totalscore stdR_mathscore stdR_litscore {
	mycmd (rMEANstream_std_baselinemark etpteacher) areg `var' rMEANstream_std_baselinemark etpteacher std_mark girl agetest, absorb(schoolid) cluster(section)
	}

foreach spec in "std_mark>=-0.75&std_mark<=0.75" "std_mark<-0.275" "std_mark>0.75" {
	mycmd (rMEANstream_std_baselinemark etpteacher) areg stdR_totalscore rMEANstream_std_baselinemark etpteacher std_mark girl agetest if `spec', absorb(schoolid) cluster(section)
	}

egen M = group(section)
sum M
global reps = r(max)

mata ResB= J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if M == `c'

global j = 1

*Table 4
foreach var in stdR_totalscore stdR_mathscore stdR_litscore {
	mycmd1 (rMEANstream_std_baselinemark etpteacher) areg `var' rMEANstream_std_baselinemark etpteacher std_mark girl agetest, absorb(schoolid) cluster(section)
	}

foreach spec in "std_mark>=-0.75&std_mark<=0.75" "std_mark<-0.275" "std_mark>0.75" {
	mycmd1 (rMEANstream_std_baselinemark etpteacher) areg stdR_totalscore rMEANstream_std_baselinemark etpteacher std_mark girl agetest if `spec', absorb(schoolid) cluster(section)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 57/68 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeDDK2, replace

*************************************
*************************************

global b = 14

use DatDDK3, clear

global j = 69

*Table 7
foreach var in diff1_score diff2_score diff3_score letterscore24  wordscore spellscore24  sentscore24 {
	mycmd (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf agetest girl , cluster(schoolid)
	}

egen M = group(schoolid)
sum M
global reps = r(max)

mata ResB= J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if M == `c'

global j = 1

*Table 7
foreach var in diff1_score diff2_score diff3_score letterscore24  wordscore spellscore24  sentscore24 {
	mycmd1 (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf agetest girl , cluster(schoolid)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 69/82 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeDDK3, replace

*************************************
*************************************

use ip\OJackknifeDDK1, clear
merge 1:1 N using ip\OJackknifeDDK2, nogenerate
merge 1:1 N using ip\OJackknifeDDK3, nogenerate
aorder
svmat double B
save results\OJackknifeDDK, replace

