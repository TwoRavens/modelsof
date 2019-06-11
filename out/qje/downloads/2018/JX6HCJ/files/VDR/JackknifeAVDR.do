

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust hetero(string)]
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') hetero(`hetero')
	testparm `testvars'
	global k = r(df)
	matrix B = J($k,2,.)
	local i = 1
	foreach var in `testvars' {
		matrix B[`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}
	foreach var in `hetero' {
		matrix B[`i',1] = _b[sigma:`var'], _se[sigma:`var']
		local i = `i' + 1
		}
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		quietly `anything' if M ~= `i', cluster(`cluster') hetero(`hetero')
		matrix BB = J($k,2,.)
		local c = 1
		foreach var in `testvars' {
			matrix BB[`c',1] = _b[`var'], _se[`var']
			local c = `c' + 1
			}
		foreach var in `hetero' {
			matrix BB[`c',1] = _b[sigma:`var'], _se[sigma:`var']
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

global cluster = "Session"

global i = 1
global j = 1

use DatVDR, clear
egen Session = group(TreatmentID session), label


*Table3 

matrix A3=[0,0,0] 
mycmd (t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4) cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4) 

*Table 3 
matrix A3=[0,0,0,0] 
mycmd (t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential) cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4 t2_consequential) 


use ip\JK1, clear
forvalues i = 2/2 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/2 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeAVDR, replace


