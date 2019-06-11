
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster')
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


use DatKN, clear

matrix F = J(4,4,.)
matrix B = J(4,2,.)

global i = 1
global j = 1

*Table 2
foreach Y in Prod_Comm Prod_Points {
	foreach specification in "" "touchtype experiencedatabase concentration" {
		mycmd (award) reg `Y' award `specification' if treatment !=2, cluster(session1)
		}
	}

global i = 0

*Table 2
foreach Y in Prod_Comm Prod_Points {
	foreach specification in "" "touchtype experiencedatabase concentration" {
		global i = $i + 1
			randcmdc ((award) reg `Y' award `specification' if treatment !=2, cluster(session1)), treatvars(award) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(session1)
		}
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
save results\FisherCondKN, replace

