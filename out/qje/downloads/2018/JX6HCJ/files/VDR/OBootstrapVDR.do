
global a = 2
global b = 35

use DatVDR, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Table3
matrix A3=[0,0,0] 
cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4) 
	testparm t2* t3* t4* treat*
	matrix F[1,1] = r(p), r(drop), e(df_r), 15
	matrix B[1,1] = (_b[t2_length], _se[t2_length]) \ (_b[t2_width], _se[t2_width]) \ (_b[t2_location], _se[t2_location]) \ (_b[t3_length], _se[t3_length]) \ (_b[t3_width], _se[t3_width]) \ (_b[t3_location], _se[t3_location]) \ (_b[t4_length], _se[t4_length]) \ (_b[t4_width], _se[t4_width]) \ (_b[t4_location], _se[t4_location]) \ (_b[treat2], _se[treat2]) \ (_b[treat3], _se[treat3]) \ (_b[treat4], _se[treat4]) \ (_b[sigma:treat2], _se[sigma:treat2]) \ (_b[sigma:treat3], _se[sigma:treat3]) \ (_b[sigma:treat4], _se[sigma:treat4]) 

matrix A3=[0,0,0,0] 
cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4 t2_consequential) 
	testparm t2* t3* t4* treat*
	matrix F[2,1] = r(p), r(drop), e(df_r), 20
	matrix B[16,1] = (_b[t2_length], _se[t2_length]) \ (_b[t2_width], _se[t2_width]) \ (_b[t2_location], _se[t2_location]) \ (_b[t3_length], _se[t3_length]) \ (_b[t3_width], _se[t3_width]) \ (_b[t3_location], _se[t3_location]) \ (_b[t4_length], _se[t4_length]) \ (_b[t4_width], _se[t4_width]) \ (_b[t4_location], _se[t4_location]) \ (_b[treat2], _se[treat2]) \ (_b[treat3], _se[treat3]) \ (_b[treat4], _se[treat4]) \ (_b[t2_length_c], _se[t2_length_c]) \ (_b[t2_width_c], _se[t2_width_c]) \ (_b[t2_location_c], _se[t2_location_c]) \ (_b[t2_consequential], _se[t2_consequential]) \ (_b[sigma:treat2], _se[sigma:treat2]) \ (_b[sigma:treat3], _se[sigma:treat3]) \ (_b[sigma:treat4], _se[sigma:treat4]) \ (_b[sigma:t2_consequential], _se[sigma:t2_consequential]) 

gen Order = _n
sort subjectID Order
gen N = 1
gen Dif = (subjectID ~= subjectID[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,2,.)
	matrix FF = J($a,4,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop subjectID
	rename obs subjectID

matrix A3=[0,0,0] 
capture cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4) 
	if (_rc == 0) {
		capture testparm t2* t3* t4* treat*
		capture matrix FF[1,1] = r(p), r(drop)
		capture matrix BB[1,1] = (_b[t2_length], _se[t2_length]) \ (_b[t2_width], _se[t2_width]) \ (_b[t2_location], _se[t2_location]) \ (_b[t3_length], _se[t3_length]) \ (_b[t3_width], _se[t3_width]) \ (_b[t3_location], _se[t3_location]) \ (_b[t4_length], _se[t4_length]) \ (_b[t4_width], _se[t4_width]) \ (_b[t4_location], _se[t4_location]) \ (_b[treat2], _se[treat2]) \ (_b[treat3], _se[treat3]) \ (_b[treat4], _se[treat4]) \ (_b[sigma:treat2], _se[sigma:treat2]) \ (_b[sigma:treat3], _se[sigma:treat3]) \ (_b[sigma:treat4], _se[sigma:treat4]) 
		capture matrix V = e(V)
		capture matrix t = e(b)
		capture matrix S = J(15,rowsof(V),0)
			local i = 1
			foreach var in t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 {
				capture local q = colnumb(t,"b:`var'")
				capture matrix S[`i',`q'] = 1
				local i = `i' + 1
				}
			foreach var in treat2 treat3 treat4 {
				capture local q = colnumb(t,"sigma:`var'")
				capture matrix S[`i',`q'] = 1
				local i = `i' + 1
				}
		capture matrix V = S*V*S'
		capture matrix FF[1,4] = (BB[1..15,1]-B[1..15,1])'*invsym(V)*(BB[1..15,1]-B[1..15,1])
		capture matrix FF[1,4] = chi2tail(15,FF[1,4])
		}

matrix A3=[0,0,0,0] 
capture cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4 t2_consequential) 
	if (_rc == 0) {
		capture testparm t2* t3* t4* treat*
		capture matrix FF[2,1] = r(p), r(drop)
		capture matrix BB[16,1] = (_b[t2_length], _se[t2_length]) \ (_b[t2_width], _se[t2_width]) \ (_b[t2_location], _se[t2_location]) \ (_b[t3_length], _se[t3_length]) \ (_b[t3_width], _se[t3_width]) \ (_b[t3_location], _se[t3_location]) \ (_b[t4_length], _se[t4_length]) \ (_b[t4_width], _se[t4_width]) \ (_b[t4_location], _se[t4_location]) \ (_b[treat2], _se[treat2]) \ (_b[treat3], _se[treat3]) \ (_b[treat4], _se[treat4]) \ (_b[t2_length_c], _se[t2_length_c]) \ (_b[t2_width_c], _se[t2_width_c]) \ (_b[t2_location_c], _se[t2_location_c]) \ (_b[t2_consequential], _se[t2_consequential]) \ (_b[sigma:treat2], _se[sigma:treat2]) \ (_b[sigma:treat3], _se[sigma:treat3]) \ (_b[sigma:treat4], _se[sigma:treat4]) \ (_b[sigma:t2_consequential], _se[sigma:t2_consequential]) 
		capture matrix V = e(V)
		capture matrix t = e(b)
		capture matrix S = J(20,rowsof(V),0)
			local i = 1
			foreach var in t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential {
				capture local q = colnumb(t,"b:`var'")
				capture matrix S[`i',`q'] = 1
				local i = `i' + 1
				}
			foreach var in treat2 treat3 treat4 t2_consequential {
				capture local q = colnumb(t,"sigma:`var'")
				capture matrix S[`i',`q'] = 1
				local i = `i' + 1
				}
		capture matrix V = S*V*S'
		capture matrix FF[2,4] = (BB[16..35,1]-B[16..35,1])'*invsym(V)*(BB[16..35,1]-B[16..35,1])
		capture matrix FF[2,4] = chi2tail(20,FF[2,4])
		}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\OBootstrapVDR, replace

erase aa.dta
erase aaa.dta


