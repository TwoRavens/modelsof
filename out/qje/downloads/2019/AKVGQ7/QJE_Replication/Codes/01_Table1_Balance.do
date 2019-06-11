**************************************************************
************************* TABLE 1 - SUMMARY STATISTICS *******
**************************************************************

capt prog drop my_ptest
program my_ptest, eclass
syntax varlist [if] [in], by(varname) clus_id(varname numeric) strat_id(varlist numeric) [ * ]

marksample touse
markout `touse' `by'
tempname mu_1 mu_2 mu_3 mu_4  se_1 se_2 se_3 se_4 d_p d_p2
capture drop TD*
tab `by', gen(TD)
foreach var of local varlist {
	reg `var' TD1 TD2 TD3 TD4 `if', nocons vce(cluster `clus_id')
	test (_b[TD1] == _b[TD2]== _b[TD3]= _b[TD4])
	mat `d_p'  = nullmat(`d_p'),r(p)
	matrix A=e(b)
	matrix B=e(V)
	mat `mu_1' = nullmat(`mu_1'), A[1,1]
	mat `mu_2' = nullmat(`mu_2'), A[1,2]
	mat `mu_3' = nullmat(`mu_3'), A[1,3]
	mat `mu_4' = nullmat(`mu_4'), A[1,4]
	mat `se_1' = nullmat(`se_1'), sqrt(B[1,1])
	mat `se_2' = nullmat(`se_2'), sqrt(B[2,2])
	mat `se_3' = nullmat(`se_3'), sqrt(B[3,3])
	mat `se_4' = nullmat(`se_4'), sqrt(B[4,4])
	reghdfe `var' TD1 TD2 TD3 TD4 `if',  vce(cluster `clus_id') abs( i.`strat_id')
	test (_b[TD1] == _b[TD2]== _b[TD3]= _b[TD4])
	mat `d_p2'  = nullmat(`d_p2'),r(p)
}
foreach mat in mu_1 mu_2 mu_3 mu_4  se_1 se_2 se_3 se_4  d_p d_p2 {
	mat coln ``mat'' = `varlist'
}
eret local cmd "my_ptest"
foreach mat in mu_1 mu_2 mu_3 mu_4  se_1 se_2 se_3 se_4  d_p d_p2 {
	eret mat `mat' = ``mat''
}
end

use "$basein/R_EL_schools_noPII.dta", clear
keep SchoolID treatment treatarm
merge 1:m SchoolID using "$basein/Teacher.dta"

keep SchoolID  tchsex t05 t06 t07 t08 t10 t16 t17 t19 t21 t22 t23 t24 t25 treatment treatarm SchoolID DistrictID FGS_T3 FGS_T7
rename DistrictID DistID
gen TeacherCertificate=(t16>=3) & !missing(t16)

label var t21 "Travel time from house to school"
label var tchsex "Male"
label var TeacherCertificate "Teaching Certificate"
recode tchsex (2=0)
replace t05=2013-t05
replace t07=2013-t07
label var t05 "Age (in 2013)"
label var t07 "Years of experience (in 2013)"


eststo clear
eststo: my_ptest  tchsex t05 t07 TeacherCertificate if FGS_T3==1, by(treatarm) clus_id(SchoolID) strat_id(DistID)
esttab using "$latexcodesfinals/summaryTeacherTotal.tex", label replace ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels(none)  ///
cells("mu_1(fmt(%9.2fc)) mu_2(fmt(%9.2fc)) mu_3(fmt(%9.2fc)) mu_4(fmt(%9.2fc)) d_p2(star pvalue(d_p2) fmt(%9.2fc))" "se_1(fmt(%9.2fc) par) se_2(fmt(%9.2fc) par) se_3(fmt(%9.2fc) par) se_4(fmt(%9.2fc) par)  .") ///
fragment nolines nogaps nomtitles

reg tchsex i.treatarm i.DistID if FGS_T3==1, nocons vce(cluster SchoolID)
sum tchsex if e(sample)==1
local tempm=string(r(N), "%9.0fc")
file open newfile using "$latexcodesfinals/N_balance_teachers.tex", write replace
file write newfile "`tempm'"
file close newfile
			
			
			
use "$basein/Student_School_House_Teacher_Char.dta", clear




local studentcontrol Lagmale LagAge LagZ_kiswahili LagZ_hisabati LagZ_kiingereza
label var LagseenUwezoTests "Seen Uwezo Test"
label var LagpreSchoolYN "Went to Preschool"
label var Lagmale "Male"
label var LagAge "Age"
label var LagZ_kiswahili "Normalized Kiswahili test score"
label var LagZ_hisabati "Normalized math test score"
label var LagZ_kiingereza "Normalized English test score"
replace attendance_T3=1-attendance_T3
replace attendance_T7=1-attendance_T7

label var attendance_T3 "Attrited in year 1"
label var attendance_T7 "Attrited in year 2"
drop if upid==""

eststo clear
eststo: my_ptest  `studentcontrol' attendance_T3 attendance_T7, by(treatarm) clus_id(SchoolID) strat_id(DistID)
esttab using "$latexcodesfinals/summaryStudentsTotal.tex", label replace ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels(none)  ///
cells("mu_1(fmt(%9.2fc)) mu_2(fmt(%9.2fc)) mu_3(fmt(%9.2fc)) mu_4(fmt(%9.2fc)) d_p2(star pvalue(d_p2) fmt(%9.2fc))" "se_1(fmt(%9.2fc) par) se_2(fmt(%9.2fc) par) se_3(fmt(%9.2fc) par) se_4(fmt(%9.2fc) par)  .") ///
fragment nolines nogaps nomtitles


reg Lagmale i.treatarm i.DistID, nocons vce(cluster SchoolID)
sum Lagmale if e(sample)==1
local tempm=string(r(N), "%9.0fc")
file open newfile using "$latexcodesfinals/N_balance_students.tex", write replace
file write newfile "`tempm'"
file close newfile

use "$basein/School.dta", replace
local schoolcontro2lb PTR_T1  SingleShift_T1  InfrastructureIndex_T1 s108_T1 StudentsTotal_T1
label var s1451_T1 "Kitchen"
label var s1452_T1 "Library"
label var s1453_T1 "Playground"
label var s1454_T1 "Staff room"
label var s1455_T1 "Outer wall"
label var s1456_T1 "Newspaper"
label var SingleShift_T1 "Single shift"
label var computersYN_T1 "Computers"
label var s120_T1  "Electricity"
label var s118_T1 "Classes outside"
label var PipedWater_T1 "Piped Water"
label var NoWater_T1 "No Water"
label var ToiletsStudents_T1 "Toilets/Students"
label var ClassRoomsStudents_T1 "Classrooms/Students"
replace TeacherStudents_T1=1/TeacherStudents_T1
label var TeacherStudents_T1 "Students/Teachers"
label var s188_T1 "Breakfast"
label var s175_T1 "Preschool"
label var s200_T1 "Track students"
label var s108_T1 "Urban"
label var SizeSchoolCommittee_T1 "Size School Committee"
label var KeepRecords_T1 "Spending records"
label var noticeboard_T1 "Noticeboard with spending information"
label var PropCommitteeFemale_T1 "Female/Committee"
label var PropCommitteeTeachers_T1 "Teacher/Committee"
label var PropCommitteeParents_T1 "Parents/Committee"
label var StudentsTotal_T1 "Enrolled students"

egen StdsAll=rowtotal(StudentsGr1_T1- StudentsGr7_T1), missing
egen StdsFocal=rowtotal(StudentsGr1_T1- StudentsGr3_T1), missing

label var InfrastructureIndex_T1 "Infrastructure index (PCA)"
label var PTR_T1 "Pupil-teacher ratio"


eststo clear
eststo: my_ptest  `schoolcontro2lb', by(treatarm) clus_id(SchoolID) strat_id(DistrictID)
esttab using "$latexcodesfinals/summarySchoolTotal.tex", label replace ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels(none)  ///
cells("mu_1(fmt(%9.2fc)) mu_2(fmt(%9.2fc)) mu_3(fmt(%9.2fc)) mu_4(fmt(%9.2fc)) d_p2(star pvalue(d_p2) fmt(%9.2fc))" "se_1(fmt(%9.2fc) par) se_2(fmt(%9.2fc) par) se_3(fmt(%9.2fc) par) se_4(fmt(%9.2fc) par)  .") ///
fragment nolines nogaps nomtitles

reg PTR_T1 i.treatarm i.DistrictID, nocons vce(cluster SchoolID)
sum PTR_T1 if e(sample)==1
local tempm=string(r(N), "%9.0fc")
file open newfile using "$latexcodesfinals/N_balance_school.tex", write replace
file write newfile "`tempm'"
file close newfile



clear 
use "$basein/Household_Baseline2013.dta", clear
keep HHID wrokyn asset_1 expn12 DistID upidst SchoolID IndexPoverty IndexKowledge IndexEngagement  treatment treatarm  HHSize upidst
merge m:1 upidst using "$basein/Household_Endline2013.dta", update keepus(HHID wrokyn HHSize DistID upidst SchoolID IndexPoverty treatment treatarm)
drop _merge
merge m:1 upidst using "$basein/Household_Baseline2014.dta", update keepus(HHID wrokyn HHSize expn13 DistID upidst SchoolID IndexPoverty IndexEngagement treatment treatarm)
drop _merge
merge m:1 upidst using "$basein/Household_Endline2014.dta", update keepus(HHID wrokyn HHSize DistID upidst SchoolID IndexPoverty  treatment treatarm)
drop _merge
gen LagExpenditure=expn13
replace LagExpenditure=expn12 if LagExpenditure==. & expn12!=.

label var IndexPoverty "Wealth index (PCA)"
label var IndexEngagement "Engagement index (PCA)"
label var HHSize "HH size"
replace LagExpenditure=LagExpenditure
label var LagExpenditure "Pre-treatment expenditure (TZS)"


eststo clear
my_ptest HHSize IndexPoverty LagExpenditure , by(treatarm) clus_id(SchoolID) strat_id(DistID)
esttab using "$latexcodesfinals/summaryHouseholds.tex", label replace  booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01) ///
collabels(none)  ///
cells("mu_1(fmt(%9.2fc)) mu_2(fmt(%9.2fc)) mu_3(fmt(%9.2fc)) mu_4(fmt(%9.2fc))  d_p2(star pvalue(d_p2))" "se_1(par) se_2(par) se_3(par) se_4(par) .") ///
fragment nolines nogaps nomtitles


reg HHSize i.treatarm i.DistID, nocons vce(cluster SchoolID)
sum HHSize if e(sample)==1
local tempm=string(r(N), "%9.0fc")
file open newfile using "$latexcodesfinals/N_balance_household.tex", write replace
file write newfile "`tempm'"
file close newfile
