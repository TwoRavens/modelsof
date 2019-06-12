
capture program drop mycmd
program define mycmd
	syntax anything [, cluster(string) hetero(string)]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	`anything' , cluster(`cluster') hetero(`hetero')
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
	gen `touse' = e(sample)
	mata BB = st_matrix("B");ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues c = 1/$reps {
		if (floor(`c'/50) == `c'/50) display "`c'", _continue
		preserve
			bsample if `touse', cluster($cluster) idcluster(`newcluster')
			capture `anything', cluster(`newcluster') hetero(`hetero')
			if (_rc == 0) {
				capture matrix V = e(V)
				capture matrix b = e(b)
				capture matrix S = J($k,rowsof(V),0)
				local i = 1
				foreach var in `testvars' {
					capture local q = colnumb(b,"b:`var'")
					capture matrix S[`i',`q'] = 1
					local i = `i' + 1
					}
				foreach var in `hetero'{
					capture local q = colnumb(b,"sigma:`var'")
					capture matrix S[`i',`q'] = 1
					local i = `i' + 1
					}
				capture matrix V = S*V*S'
				capture matrix b = b*S'
				capture mata B = st_matrix("b"); V = st_matrix("V")
				capture testparm `testvars'
				if (_rc == 0 & r(df) == $k) {
					mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1])
					if (e(df_r) == .) mata ResF[`c',1..3] = `r(p)', chi2tail($k,t[1,1]), $k - `r(df)'
					if (e(df_r) ~= .) mata ResF[`c',1...] = `r(p)', Ftail($k,`e(df_r)',t[1,1]/$k), $k - `r(df)', `e(df_r)'
					mata ResB[`c',1...] = B; ResSE[`c',1...] = sqrt(diagonal(V))'
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

global cluster = "subjectID"

global i = 1
global j = 1

use DatVDR, clear

*Table3 

matrix A3=[0,0,0] 
mycmd (t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4) cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4) 

*Table 3 
matrix A3=[0,0,0,0] 
mycmd (t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential) cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4 t2_consequential) 


use ip\BS1, clear
forvalues i = 2/2 {
	merge using ip\BS`i'
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
save results\BootstrapVDR, replace

