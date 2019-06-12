
use DatVDR, clear

matrix F = J(2,4,.)
matrix B = J(35,2,.)

*Table3 

matrix A3=[0,0,0] 
cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4) 
	testparm t2* t3* t4* treat*
	mata V = st_matrix("e(V)"); L = _symeigenvalues(V); L = L[1,1], L[1,cols(L)], sum(ln(L),1), cols(L); st_matrix("L",L)
	matrix F[1,1] = r(p), 0, e(df_r), 15
	matrix B[1,1] = (_b[t2_length], _se[t2_length]) \ (_b[t2_width], _se[t2_width]) \ (_b[t2_location], _se[t2_location]) \ (_b[t3_length], _se[t3_length]) \ (_b[t3_width], _se[t3_width]) \ (_b[t3_location], _se[t3_location]) \ (_b[t4_length], _se[t4_length]) \ (_b[t4_width], _se[t4_width]) \ (_b[t4_location], _se[t4_location]) \ (_b[treat2], _se[treat2]) \ (_b[treat3], _se[treat3]) \ (_b[treat4], _se[treat4]) \ (_b[sigma:treat2], _se[sigma:treat2]) \ (_b[sigma:treat3], _se[sigma:treat3]) \ (_b[sigma:treat4], _se[sigma:treat4]) 

*Table 3 
matrix A3=[0,0,0,0] 
cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4 t2_consequential) 
	testparm t2* t3* t4* treat*
	mata V = st_matrix("e(V)"); L = _symeigenvalues(V); L = L[1,1], L[1,cols(L)], sum(ln(L),1), cols(L); st_matrix("L",L)
	matrix F[2,1] = r(p), 0, e(df_r), 20
	matrix B[16,1] = (_b[t2_length], _se[t2_length]) \ (_b[t2_width], _se[t2_width]) \ (_b[t2_location], _se[t2_location]) \ (_b[t3_length], _se[t3_length]) \ (_b[t3_width], _se[t3_width]) \ (_b[t3_location], _se[t3_location]) \ (_b[t4_length], _se[t4_length]) \ (_b[t4_width], _se[t4_width]) \ (_b[t4_location], _se[t4_location]) \ (_b[treat2], _se[treat2]) \ (_b[treat3], _se[treat3]) \ (_b[treat4], _se[treat4]) \ (_b[t2_length_c], _se[t2_length_c]) \ (_b[t2_width_c], _se[t2_width_c]) \ (_b[t2_location_c], _se[t2_location_c]) \ (_b[t2_consequential], _se[t2_consequential]) \ (_b[sigma:treat2], _se[sigma:treat2]) \ (_b[sigma:treat3], _se[sigma:treat3]) \ (_b[sigma:treat4], _se[sigma:treat4]) \ (_b[sigma:t2_consequential], _se[sigma:t2_consequential]) 

bys subjectID: gen N = _n
sort N subjectID
sum N if N == 1
global N = r(N)
mata Y = st_data((1,$N),("treat2","treat3","treat4"))
generate Order = _n
generate double U = .

mata ResF = J($reps,2,.); ResD = J($reps,2,.); ResDF = J($reps,2,.); ResB = J($reps,35,.); ResSE = J($reps,35,.)
forvalues c = 1/$reps {
	matrix FF = J(2,3,.)
	matrix BB = J(35,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("treat2","treat3","treat4"),Y)
	sort subjectID N
	foreach j in treat2 treat3 treat4 {
		quietly replace `j' = `j'[_n-1] if subjectID == subjectID[_n-1] 
		}
	forvalues j = 2/4 {
		quietly replace t`j'_length = treat`j'*Length
		quietly replace t`j'_width = treat`j'*Width
		quietly replace t`j'_location = treat`j'*Location
		}
	foreach j in length width location {
		quietly replace t2_`j'_c = t2_`j'*Consequential
		}
	quietly replace t2_consequential = treat2*Consequential

matrix A3=[0,0,0] 
capture cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4) 
if (_rc == 0) {
	capture testparm t2* t3* t4* treat*
	capture matrix FF[1,1] = r(p), r(drop)
	capture matrix BB[1,1] = (_b[t2_length], _se[t2_length]) \ (_b[t2_width], _se[t2_width]) \ (_b[t2_location], _se[t2_location]) \ (_b[t3_length], _se[t3_length]) \ (_b[t3_width], _se[t3_width]) \ (_b[t3_location], _se[t3_location]) \ (_b[t4_length], _se[t4_length]) \ (_b[t4_width], _se[t4_width]) \ (_b[t4_location], _se[t4_location]) \ (_b[treat2], _se[treat2]) \ (_b[treat3], _se[treat3]) \ (_b[treat4], _se[treat4]) \ (_b[sigma:treat2], _se[sigma:treat2]) \ (_b[sigma:treat3], _se[sigma:treat3]) \ (_b[sigma:treat4], _se[sigma:treat4]) 
	}

matrix A3=[0,0,0,0] 
capture cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4 t2_consequential) 
if (_rc == 0) {
	capture testparm t2* t3* t4* treat*
	capture matrix FF[2,1] = r(p), r(drop)
	capture matrix BB[16,1] = (_b[t2_length], _se[t2_length]) \ (_b[t2_width], _se[t2_width]) \ (_b[t2_location], _se[t2_location]) \ (_b[t3_length], _se[t3_length]) \ (_b[t3_width], _se[t3_width]) \ (_b[t3_location], _se[t3_location]) \ (_b[t4_length], _se[t4_length]) \ (_b[t4_width], _se[t4_width]) \ (_b[t4_location], _se[t4_location]) \ (_b[treat2], _se[treat2]) \ (_b[treat3], _se[treat3]) \ (_b[treat4], _se[treat4]) \ (_b[t2_length_c], _se[t2_length_c]) \ (_b[t2_width_c], _se[t2_width_c]) \ (_b[t2_location_c], _se[t2_location_c]) \ (_b[t2_consequential], _se[t2_consequential]) \ (_b[sigma:treat2], _se[sigma:treat2]) \ (_b[sigma:treat3], _se[sigma:treat3]) \ (_b[sigma:treat4], _se[sigma:treat4]) \ (_b[sigma:t2_consequential], _se[sigma:t2_consequential]) 
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..2] = FF[.,1]'; ResD[`c',1..2] = FF[.,2]'; ResDF[`c',1..2] = FF[.,3]'
mata ResB[`c',1..35] = BB[.,1]'; ResSE[`c',1..35] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/2 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/35 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\FisherVDR, replace







