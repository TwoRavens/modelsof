****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [, hetero(string)]
	tempvar xb scores p P dersigma sigma sigma2 S
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	capture `cmd' `dep' `anything', hetero(`hetero')
	matrix b = e(b)
	matrix v = e(V)
	local anything = "`anything'" + " " + "const"
	local hetero = "`hetero'" + " " + "const"
	global kk = wordcount("`anything'") + wordcount("`hetero'")
	global k = wordcount("`testvars'")
	global k1 = wordcount("`hetero'")
	predict double `xb', xb
	predict double `scores', scores
	gen double `sigma' = 0 
	local i = 1
	foreach var in `hetero' {
		quietly replace `sigma' = `sigma' + b[1,$kk-$k1+`i']*`var'
		local i = `i' + 1
		}
	gen double `p' = normalden((cost-`xb')/`sigma')
	gen double `P' = normal((cost-`xb')/`sigma')
	gen double `sigma2' = `sigma'^2
	matrix grad = J($ncluster,$kk,.)
	local i = 1
	foreach var in `anything' {
		quietly egen double `S' = sum(`scores'*`var'), by($cluster)
		mkmat `S' if n == 1, matrix(a)
		matrix grad[1,`i'] = a 
		local i = `i' + 1
		capture drop `S'
		}
	gen double `dersigma' = Vote*`p'*(cost-`xb')/(`sigma2'*(1-`P')) - (1-Vote)*`p'*(cost-`xb')/(`sigma2'*`P')
	foreach var in `hetero' {
		quietly egen double `S' = sum(`dersigma'*`var'), by($cluster)
		mkmat `S' if n == 1, matrix(a)
		matrix grad[1,`i'] = a 
		local i = `i' + 1
		capture drop `S'
		}
	mata b = st_matrix("b"); v = st_matrix("v"); grad = st_matrix("grad"); select = J(1,$kk,0); select[1,1..$k] = J(1,$k,1); select[1,$kk-$k1+1..$kk-1] = J(1,$k1-1,1)
	if ($i == 1) {
		mata B = b; G = v*grad'; Select = select; dc = J(1,$ncluster,1)*grad; DC = dc*dc'
		}
	else {
		mata B = B, b; G = G \ (v*grad'); Select = Select, select; dc = J(1,$ncluster,1)*grad; DC = DC + dc*dc'
		}
global i = $i + 1
end


****************************************


*randomizing at authors cluster level

use DatVDR, clear

generate byte const = 1
global cluster = "subjectID"
global ncluster = 220
bysort subjectID: gen n = _n

*Table3 
global i = 1
matrix A3=[0,0,0] 
mycmd (t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4) cameronHet Vote t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 Length Width Location Household_Size Income Graduate_Degree, hetero(treat2 treat3 treat4) 

*Table 3 
matrix A3=[0,0,0,0] 
mycmd (t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential) cameronHet Vote t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential Length Width Location Household_Size Income Graduate_Degree, hetero(treat2 treat3 treat4 t2_consequential) 

if (_rc == 0) {
	mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
	mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 3 ; st_matrix("test",test); st_matrix("dc",DC)
	matrix F = test
	matrix DC = dc
	}


drop _all
svmat double F
svmat double DC
save results/SuestVDR, replace



