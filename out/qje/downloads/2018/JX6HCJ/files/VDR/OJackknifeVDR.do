
global b = 35

use DatVDR, clear

matrix B = J($b,2,.)

global j = 1

*Table3
matrix A3=[0,0,0] 
cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4) 
	matrix B[1,1] = (_b[t2_length], _se[t2_length]) \ (_b[t2_width], _se[t2_width]) \ (_b[t2_location], _se[t2_location]) \ (_b[t3_length], _se[t3_length]) \ (_b[t3_width], _se[t3_width]) \ (_b[t3_location], _se[t3_location]) \ (_b[t4_length], _se[t4_length]) \ (_b[t4_width], _se[t4_width]) \ (_b[t4_location], _se[t4_location]) \ (_b[treat2], _se[treat2]) \ (_b[treat3], _se[treat3]) \ (_b[treat4], _se[treat4]) \ (_b[sigma:treat2], _se[sigma:treat2]) \ (_b[sigma:treat3], _se[sigma:treat3]) \ (_b[sigma:treat4], _se[sigma:treat4]) 

matrix A3=[0,0,0,0] 
cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4 t2_consequential) 
	matrix B[16,1] = (_b[t2_length], _se[t2_length]) \ (_b[t2_width], _se[t2_width]) \ (_b[t2_location], _se[t2_location]) \ (_b[t3_length], _se[t3_length]) \ (_b[t3_width], _se[t3_width]) \ (_b[t3_location], _se[t3_location]) \ (_b[t4_length], _se[t4_length]) \ (_b[t4_width], _se[t4_width]) \ (_b[t4_location], _se[t4_location]) \ (_b[treat2], _se[treat2]) \ (_b[treat3], _se[treat3]) \ (_b[treat4], _se[treat4]) \ (_b[t2_length_c], _se[t2_length_c]) \ (_b[t2_width_c], _se[t2_width_c]) \ (_b[t2_location_c], _se[t2_location_c]) \ (_b[t2_consequential], _se[t2_consequential]) \ (_b[sigma:treat2], _se[sigma:treat2]) \ (_b[sigma:treat3], _se[sigma:treat3]) \ (_b[sigma:treat4], _se[sigma:treat4]) \ (_b[sigma:t2_consequential], _se[sigma:t2_consequential]) 

egen M = group(subjectID)
sum M
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,2,.)
	display "`c'"

preserve

drop if M == `c'

matrix A3=[0,0,0] 
capture cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4) 
	if (_rc == 0) {
		capture matrix BB[1,1] = (_b[t2_length], _se[t2_length]) \ (_b[t2_width], _se[t2_width]) \ (_b[t2_location], _se[t2_location]) \ (_b[t3_length], _se[t3_length]) \ (_b[t3_width], _se[t3_width]) \ (_b[t3_location], _se[t3_location]) \ (_b[t4_length], _se[t4_length]) \ (_b[t4_width], _se[t4_width]) \ (_b[t4_location], _se[t4_location]) \ (_b[treat2], _se[treat2]) \ (_b[treat3], _se[treat3]) \ (_b[treat4], _se[treat4]) \ (_b[sigma:treat2], _se[sigma:treat2]) \ (_b[sigma:treat3], _se[sigma:treat3]) \ (_b[sigma:treat4], _se[sigma:treat4]) 
		}

matrix A3=[0,0,0,0] 
capture cameronHet Vote Length Width Location t2_length t2_width t2_location t3_length t3_width t3_location t4_length t4_width t4_location treat2 treat3 treat4 t2_length_c t2_width_c t2_location_c t2_consequential Household_Size Income Graduate_Degree, cluster(subjectID) hetero(treat2 treat3 treat4 t2_consequential) 
	if (_rc == 0) {
		capture matrix BB[16,1] = (_b[t2_length], _se[t2_length]) \ (_b[t2_width], _se[t2_width]) \ (_b[t2_location], _se[t2_location]) \ (_b[t3_length], _se[t3_length]) \ (_b[t3_width], _se[t3_width]) \ (_b[t3_location], _se[t3_location]) \ (_b[t4_length], _se[t4_length]) \ (_b[t4_width], _se[t4_width]) \ (_b[t4_location], _se[t4_location]) \ (_b[treat2], _se[treat2]) \ (_b[treat3], _se[treat3]) \ (_b[treat4], _se[treat4]) \ (_b[t2_length_c], _se[t2_length_c]) \ (_b[t2_width_c], _se[t2_width_c]) \ (_b[t2_location_c], _se[t2_location_c]) \ (_b[t2_consequential], _se[t2_consequential]) \ (_b[sigma:treat2], _se[sigma:treat2]) \ (_b[sigma:treat3], _se[sigma:treat3]) \ (_b[sigma:treat4], _se[sigma:treat4]) \ (_b[sigma:t2_consequential], _se[sigma:t2_consequential]) 
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
svmat double B
drop B2
gen N = _n
save results\OJackknifeVDR, replace



