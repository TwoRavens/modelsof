

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	if ("`absorb'" == "") `anything' `if' `in', cluster(`cluster') `robust'
	if ("`absorb'" ~= "") `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
	testparm `testvars'
	global k = r(df)
	unab testvars: `testvars'
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		if ("`absorb'" == "") quietly `anything' if M ~= `i', cluster(`cluster') `robust'
		if ("`absorb'" ~= "") quietly `anything' if M ~= `i', cluster(`cluster') `robust' absorb(`absorb')
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

use DatDDK1, clear

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


*************************************
*************************************

global cluster = "section"

use DatDDK2, clear

*Table 4
foreach var in stdR_totalscore stdR_mathscore stdR_litscore {
	mycmd (rMEANstream_std_baselinemark etpteacher) areg `var' rMEANstream_std_baselinemark etpteacher std_mark girl agetest, absorb(schoolid) cluster(section)
	}

foreach spec in "std_mark>=-0.75&std_mark<=0.75" "std_mark<-0.275" "std_mark>0.75" {
	mycmd (rMEANstream_std_baselinemark etpteacher) areg stdR_totalscore rMEANstream_std_baselinemark etpteacher std_mark girl agetest if `spec', absorb(schoolid) cluster(section)
	}

*************************************
*************************************

global cluster = "schoolid"

use DatDDK3, clear

*Table 7
foreach var in diff1_score diff2_score diff3_score letterscore24  wordscore spellscore24  sentscore24 {
	mycmd (tracking bottomhalf_tracking) reg `var' tracking bottomhalf_tracking bottomhalf agetest girl , cluster(schoolid)
	}


use ip\JK1, clear
forvalues i = 2/33 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/33 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeDDK, replace


