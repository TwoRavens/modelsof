
*************************************************************************************************
*************************************************************************************************
* THIS FILE RUNS THE CONLEY SPATIAL HAC STANDARDS ERRORS FOR ALL REGRESSIONS SHOWN IN
* THE PAPER "DRUG BATTLES AND SCHOOL ACHIEVEMENT: EVIDENCE FROM RIO DE JANEIRO´S FAVELAS" 
*************************************************************************************************
*************************************************************************************************

cd "write directory path here"
set matsize 1000
set more off


*********************************************************************************************************************************************************************************************************************************************
*********************************************************************************************************************************************************************************************************************************************
*PAPER
*********************************************************************************************************************************************************************************************************************************************
*********************************************************************************************************************************************************************************************************************************************


*********************************************************************************************************************************************************************************************************************************************
* CONLEY - TABLE 1 - MAIN RESULTS: EFFECTS ON STUDENT ACHIEVEMENT
*********************************************************************************************************************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped kitchen principal_office science_lab computer_lab school_lunch teacher_office boys_class nonwhite_class age_class work_class  repeated_class dropped_class"
keep if d250m==1 

*SAMPLE MATH & LANGUAGE 

xi: reg math_score d2 i.year i.id_school $controls 
gen esample=e(sample)

*MATH - COLUMN 1

	*de-meaning 
	preserve
	xi: reg math_score i.year  if esample==1
	predict residy, r

	xi: reg d2  i.year  if esample==1
	predict residx, r

	*Cluster
	reg residy residx, cluster(id_school)
	outreg2 using Conley/Tab1_math.xls, aster(se) dec(3)  nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, N, School FE, N, SE, Cluster, Sample, 250, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy residx, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/Tab1_math.xls, bracket aster(se) dec(3)   nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, N, School FE, N, SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore

*MATH - COLUMN 2

	*de-meaning 
	preserve
	xi: reg math_score i.year $controls if esample==1
	predict residy, r

	xi: reg d2 i.year $controls if esample==1
	predict residx, r

	*Cluster
	reg residy residx, cluster(id_school)
	outreg2 using Conley/Tab1_math.xls, aster(se) dec(3)  nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, Y, School FE, N, SE, Cluster, Sample, 250, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy residx, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/Tab1_math.xls, bracket aster(se) dec(3)   nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, Y, School FE, N, SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore

*MATH - COLUMN 3

* de-meaning 
	preserve
	xi: reg math_score i.year $controls i.id_school if esample==1
	predict residy, r

	xi: reg d2 i.year $controls i.id_school if esample==1
	predict residx, r

	*CLUSTER
	reg residy residx, cluster(id_school)
	outreg2 using Conley/Tab1_math.xls, aster(se) dec(3)  nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, Y, School FE, Y, SE, Cluster, Sample, 250, Cutoff, None, Lag, None)

	*CONLEY
	ols_spatial_HAC residy residx, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/Tab1_math.xls, bracket aster(se) dec(3)   nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, Y, School FE, Y, SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore

*LANGUAGE - COLUMN 1
	
	*de-meaning	
	preserve
	xi: reg language_score i.year  if esample==1
	predict residy_language, r

	xi: reg d2 i.year if esample==1
	predict residx, r

	*Cluster
	reg residy_language residx, cluster(id_school)
	outreg2 using Conley/Tab1_language.xls, aster(se) dec(3)  nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, N, School FE, N, SE, Cluster, Sample, 250, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_language residx, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/Tab1_language.xls, bracket aster(se) dec(3)   nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, N, School FE, N, SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore

*LANGUAGE - COLUMN 2

	*de-meaning
	preserve
	xi: reg language_score i.year $controls if esample==1
	predict residy_language, r

	xi: reg d2  i.year $controls if esample==1
	predict residx, r

	*Cluster
	reg residy_language residx, cluster(id_school)
	outreg2 using Conley/Tab1_language.xls, aster(se) dec(3)   nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, Y, School FE, N, SE, Cluster, Sample, 250, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_language residx, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/Tab1_language.xls, bracket aster(se) dec(3)   nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, Y, School FE, N, SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore

*LANGUAGE - COLUMN 3

	*de-meaning
	preserve
	xi: reg language_score i.year $controls i.id_school if esample==1
	predict residy_language, r

	xi: reg d2 i.year $controls i.id_school if esample==1
	predict residx, r

	*Cluster
	reg residy_language residx, cluster(id_school)
	outreg2 using Conley/Tab1_language.xls, aster(se) dec(3)    nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, Y, School FE, Y, SE, Cluster, Sample, 250, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_language residx, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/Tab1_language.xls, bracket aster(se) dec(3)   nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, Y, School FE, Y, SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore

*********************************************************************************************************************************************************************************************************************************************
* CONLEY - TABLE 2 - Violence Effects on Teachers' Absenteeism and Medical Leaves 
*********************************************************************************************************************************************************************************************************************************************

insheet using "Databases\data_schools.txt", comma clear case
global school  "number_teachers kitchen principal_office science_lab computer_lab  school_lunch teacher_office"
global teachers  "age_teachers male_teachers undergrad_teachers grad_teachers"
keep if count==2


*SAMPLE MATH & LANGUAGE
xi: reg share_absent d2 i.year $school $teachers i.id_school
gen esample=e(sample)


*de-meaning
foreach z in share_absent absences_average share_onleave onleave_average {
xi: reg `z' i.year $school $teachers i.id_school if esample==1
predict residy_`z', re
}

foreach z in d2 dcontiguous  d2Ncontiguous  {
xi: reg `z' i.year $school $teachers  i.id_school if esample==1
predict residx_`z', re
}

*PANEL A

	foreach z in  share_absent absences_average share_onleave onleave_average  {
	
	*Cluster
	reg residy_`z' residx_d2, r
	outreg2 using Conley/Tab2.xls, aster(se) dec(3)    nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_`z' residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/Tab2.xls, bracket aster(se) dec(3)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	}


*PANEL B

	foreach z in  share_absent absences_average share_onleave onleave_average  {
	
	*Cluster
	xi: reg residy_`z'  residx_dcontiguous  residx_d2Ncontiguous, r
	outreg2 using Conley/Tab2.xls, aster(se) dec(3)    nocons keep( residx_dcontiguous residx_d2Ncontiguous)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_`z'  residx_dcontiguous  residx_d2Ncontiguous, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/Tab2.xls, bracket aster(se) dec(3)   nocons keep( residx_dcontiguous  residx_d2Ncontiguous)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	}

	
*********************************************************************************************************************************************************************************************************************************************
* CONLEY - TABLE 3 - Channels: Violence Effects on School Routine
*********************************************************************************************************************************************************************************************************************************************

insheet using "Databases\data_schools.txt", comma clear case
global infra  "kitchen principal_office science_lab computer_lab  school_lunch teacher_office"
global teachers  "age_teachers male_teachers undergrad_teachers grad_teachers"
global students_test "number_stud_school males_test white_test higheduc_mother_test age_test dropped_test repeated_test"
keep if count==2


*SAMPLE 
xi: reg  interrup_yes d2 interrup_miss dcontiguous d2Ncontiguous i.year $teachers $infra $students_test i.id_school 
gen esample=e(sample)


*PANEL A

	*de-meaning 
	foreach z in interrup student_absence turnover new_principal threat_teacher threat_student  {
	preserve
	xi: reg `z'_yes `z'_miss i.year $teachers $infra $students_test i.id_school if esample==1
	predict residy_`z'_yes, re

	xi: reg d2 `z'_miss i.year $teachers $infra $students_test i.id_school if esample==1
	predict residx_d2, re

	*Cluster
	xi: reg residy_`z'_yes residx_d2, r
	outreg2 using Conley/Tab3.xls, aster(se) dec(3) nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_`z'_yes residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/Tab3.xls, bracket aster(se) dec(3)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore
	}



*PANEL B

	*de-meaning das variáveis dependentes
	foreach z in interrup student_absence turnover new_principal threat_teacher threat_student  {
	
	preserve
	xi: reg `z'_yes `z'_miss i.year $teachers $infra $students_test i.id_school if esample==1
	predict residy_`z'_yes, re

	xi: reg dcontiguous  `z'_miss i.year $teachers $infra $students_test i.id_school if esample==1
	predict residx_dcontiguous, r

	xi: reg d2Ncontiguous   `z'_miss i.year $teachers $infra $students_test i.id_school if esample==1
	predict residx_d2Ncontiguous, re

	*Cluster
	xi: reg residy_`z'_yes residx_dcontiguous residx_d2Ncontiguous, r
	outreg2 using Conley/Tab3.xls, aster(se) dec(3)  nocons keep(residx_dcontiguous residx_d2Ncontiguous)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_`z'_yes residx_dcontiguous residx_d2Ncontiguous, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/Tab3.xls, bracket aster(se) dec(3)  nocons keep(residx_dcontiguous residx_d2Ncontiguous)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore
	}

	
	
	
*********************************************************************************************************************************************************************************************************************************************
*********************************************************************************************************************************************************************************************************************************************
*WEB-APPENDIX
*********************************************************************************************************************************************************************************************************************************************
*********************************************************************************************************************************************************************************************************************************************

	
*********************************************************************************************************************************************************************************************************************************************
* CONLEY - TABLES D1 AND D5 - VIOLENCE EFFECTS BY DISTANCE
*********************************************************************************************************************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped kitchen principal_office science_lab computer_lab school_lunch teacher_office boys_class nonwhite_class age_class work_class  repeated_class dropped_class"

*SAMPLE MATH & LANGUAGE
xi: reg math_score d2_5m d2_200m d2_250m d2_300m d2_450m d2_500m i.year i.id_school $controls
gen esample=e(sample)


*MATH (TABLE D1)
	
	foreach z in 5 250 500 750 {
	preserve
	keep if d`z'm==1
	
	*de-meaning
	xi: reg math_score i.year i.id_school $controls if esample==1
	predict residy`z'm, r

	xi: reg d2_`z'm i.year i.id_school $controls if esample==1
	predict residx`z'm, r

	*Cluster 
	xi: reg residy`z'm residx`z'm, cluster(id_school)
	outreg2 using Conley/TabD1.xls, aster(se) dec(3)   nocons keep(residx`z'm)  addtext(SE, Cluster, Sample, `z'm , Cutoff, None, Lag, None)	

	*Conley
	ols_spatial_HAC residy`z'm residx`z'm, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD1.xls, bracket aster(se) dec(3)   nocons keep(residx`z'm)  addtext(SE, Conley, Sample, `z'm , Cutoff, 500m, Lag, 3)	
	restore
	}

*LANGUAGE (TABLE D5)

	foreach z in 5 250 500 750 {
	preserve
	keep if d`z'm==1

	*de-meaning
	xi: reg language_score i.year i.id_school $controls if esample==1
	predict residy`z'm, r

	xi: reg d2_`z'm i.year i.id_school $controls if esample==1
	predict residx`z'm, r

	*Cluster
	xi: reg residy`z'm residx`z'm, cluster(id_school)
	outreg2 using Conley/TabD5.xls, aster(se) dec(3)   nocons keep(residx`z'm)  addtext(SE, Cluster, Sample, `z'm , Cutoff, None, Lag, None)	

	*Conley
	ols_spatial_HAC residy`z'm residx`z'm, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD5.xls, bracket aster(se) dec(3)   nocons keep(residx`z'm)  addtext(SE, Conley, Sample, `z'm , Cutoff, 500m, Lag, 3)	
	restore
	}


*********************************************************************************************************************************************************************************************************************************************
* CONLEY - TABLES D2 AND D6 - VIOLENCE EFFECTS BY INTENSITY
*********************************************************************************************************************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped kitchen principal_office science_lab computer_lab school_lunch teacher_office boys_class nonwhite_class age_class work_class  repeated_class dropped_class"
keep if d250m==1 

*SAMPLE MATH & LANGUAGE
xi: reg math_score d1 d2 d7 d9 intensity_contn dcontiguous d2Ncontiguous i.year i.id_school $controls
gen esample=e(sample)

* MATH (TABLE D2)

	*de-meaning
	xi: reg math_score i.year i.id_school $controls if esample==1
	predict residy, r

	foreach z in  d1 d2 d7 d9 intensity_contn dcontiguous d2Ncontiguous  {
	xi: reg `z' i.year i.id_school $controls if esample==1
	predict residx_`z', r
	}

	foreach z in  d1 d2 d7 d9 intensity_contn dcontiguous d2Ncontiguous  {
	*Cluster
	xi: reg residy residx_`z', cluster(id_school)
	outreg2 using Conley/TabD2.xls, aster(se) dec(3)    nocons keep(residx_`z')  addtext(SE, Cluster, Sample, 250, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy residx_`z', lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD2.xls, bracket aster(se) dec(3)   nocons keep(residx_`z')  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)	
	}

* LANGUAGE (TABLE D6)

	*de-meaning
	xi: reg language_score i.year i.id_school $controls if esample==1
	predict residy_language, r

	foreach z in  d1 d2 d7 d9 intensity_contn dcontiguous d2Ncontiguous {
	*Cluster
	xi: reg residy_language residx_`z', cluster(id_school)
	outreg2 using Conley/TabD6.xls, aster(se) dec(3)    nocons keep(residx_`z')  addtext(SE, Cluster, Sample, 250, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_language residx_`z', lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD6.xls, bracket aster(se) dec(3)   nocons keep(residx_`z')  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)	
	}


*********************************************************************************************************************************************************************************************************************************************
* CONLEY - TABLES D3 AND D7 - TIMING OF VIOLENCE
*********************************************************************************************************************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped kitchen principal_office science_lab computer_lab school_lunch teacher_office boys_class nonwhite_class age_class work_class  repeated_class dropped_class"
keep if d250m==1

*SAMPLE MATH & LANGUAGE
xi: reg math_score d2_fall d2_spring d2_vacation d2 lead1_d2 lag1_d2 i.year i.id_school $controls
gen esample=e(sample)

* MATH (TABLE D3) - COLUMN 1

	*de-meaning
	xi: reg math_score i.year i.id_school $controls if esample==1
	predict residy, r

	xi: reg d2_fall i.year i.id_school $controls if esample==1
	predict residx_d2_fall, r

	xi: reg d2_spring i.year i.id_school $controls if esample==1
	predict residx_d2_spring,r 

	xi: reg d2_vacation i.year i.id_school $controls if esample==1
	predict residx_d2_vacation, r

	*Cluster
	xi: reg residy residx_d2_fall residx_d2_spring residx_d2_vacation, cluster(id_school)
	outreg2 using Conley/TabD3.xls, aster(se) dec(3)   nocons keep(residx_d2_fall residx_d2_spring residx_d2_vacation)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)	

	*Conley
	ols_spatial_HAC residy residx_d2_fall residx_d2_spring residx_d2_vacation, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD3.xls, bracket aster(se) dec(3)   nocons keep(residx_d2_fall residx_d2_spring residx_d2_vacation)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)	


*MATH - COLUMN 2

	*de-meaning
	xi: reg d2 i.year i.id_school $controls if esample==1
	predict residx_d2, r

	xi: reg lead1_d2 i.year i.id_school $controls if esample==1
	predict residx_lead1_d2, r

	*Cluster
	xi: reg residy residx_d2 residx_lead1_d2, cluster(id_school)
	outreg2 using Conley/TabD3.xls, aster(se) dec(3)   nocons keep(residy residx_d2 residx_lead1_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)	

	*Conley
	ols_spatial_HAC residy residx_d2 residx_lead1_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD3.xls, bracket aster(se) dec(3)   nocons keep(residy residx_d2 residx_lead1_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)	


* MATH - COLUMN 3

	*de-meaning 
	xi: reg lag1_d2 i.year i.id_school $controls if esample==1
	predict residx_lag1_d2, r

	*Cluster
	xi: reg residy residx_d2 residx_lag1_d2, cluster(id_school)
	outreg2 using Conley/TabD3.xls, aster(se) dec(3)   nocons keep(residx_d2 residx_lag1_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)	

	*Conley
	ols_spatial_HAC residy residx_d2 residx_lag1_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD3.xls, bracket aster(se) dec(3)   nocons keep(residx_d2 residx_lag1_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)	


*LANGUAGE (TABLE D7) - COLUMN 1

	*de-meaning
	xi: reg language_score i.year i.id_school $controls if esample==1
	predict residy_language, r

	*Cluster
	xi: reg residy_language residx_d2_fall residx_d2_spring residx_d2_vacation, cluster(id_school)
	outreg2 using Conley/TabD7.xls, aster(se) dec(3)   nocons keep(residx_d2_fall residx_d2_spring residx_d2_vacation)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)	

	*Conley
	ols_spatial_HAC residy_language residx_d2_fall residx_d2_spring residx_d2_vacation, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD7.xls, bracket aster(se) dec(3)   nocons keep(residx_d2_fall residx_d2_spring residx_d2_vacation)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)	


*LANGUAGE - COLUMN 2

	*Cluster
	xi: reg residy_language residx_d2 residx_lead1_d2, cluster(id_school)
	outreg2 using Conley/TabD7.xls, aster(se) dec(3)   nocons keep(residx_d2 residx_lead1_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)	

	*Conley
	ols_spatial_HAC residy_language residx_d2 residx_lead1_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD7.xls, bracket aster(se) dec(3)   nocons keep(residx_d2 residx_lead1_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)	


* LANGUAGE - COLUMN 3

	*Cluster
	xi: reg residy_language residx_d2 residx_lag1_d2, cluster(id_school)
	outreg2 using Conley/TabD7.xls, aster(se) dec(3)   nocons keep(residx_d2 residx_lag1_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)	

	*Conley
	ols_spatial_HAC residy_language residx_d2 residx_lag1_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD7.xls, bracket aster(se) dec(3)   nocons keep(residx_d2 residx_lag1_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)	



*********************************************************************************************************************************************************************************************************************************************
* CONLEY - TABLES D4 AND D8 - HETEROGENEITY
*********************************************************************************************************************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped kitchen principal_office science_lab computer_lab school_lunch teacher_office boys_class nonwhite_class age_class work_class  repeated_class dropped_class"
keep if d250m==1 


foreach i in boy_m nonwhite_m mother_educ_low_m age_incorrect repeated_m dropped_m {
gen d2_`i' = d2*`i'
}

*MATH (TABLE D4) - COLUMN 1

* de-meaning 
	preserve
	xi: reg math_score i.year i.id_school $controls
	predict residy, r

	xi: reg d2 i.year i.id_school $controls if e(sample)==1
	predict residx, r

	*CLUSTER
	reg residy residx, cluster(id_school)
	outreg2 using Conley/TabD4.xls, aster(se) dec(3)  nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, Y, School FE, Y, SE, Cluster, Sample, 250, Cutoff, None, Lag, None)

	*CONLEY
	ols_spatial_HAC residy residx, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD4.xls, bracket aster(se) dec(3)   nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, Y, School FE, Y, SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore
	
*MATH - COLUMNS 2 TO 7 

	foreach z in boy_m nonwhite_m mother_educ_low_m age_incorrect repeated_m dropped_m {
	preserve 

	*de-meaning
	xi: reg math_score `z' i.year i.id_school $controls
	predict residy, r

	xi: reg d2 `z' i.year i.id_school $controls  if e(sample)==1
	predict residx_d2, r

	xi: reg d2_`z' `z' i.year i.id_school $controls if e(sample)==1
	predict residx_d2_`z', r

	*CLUSTER
	xi: reg residy residx_d2 residx_d2_`z' , cluster(id_school) 
	outreg2 using Conley/TabD4.xls, aster(se) dec(3)   nocons keep(residx_d2 residx_d2_`z')  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*CONLEY
	ols_spatial_HAC residy residx_d2 residx_d2_`z' , lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD4.xls, bracket aster(se) dec(3)   nocons keep(residx_d2 residx_d2_`z')  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore
	}



*LANGUAGE (TABLE D8) - COLUMN 1

	*de-meaning
	preserve
	xi: reg language_score i.year i.id_school $controls
	predict residy_language, r

	xi: reg d2 i.year  i.id_school $controls if e(sample)==1
	predict residx, r

	*Cluster
	reg residy_language residx, cluster(id_school)
	outreg2 using Conley/TabD8.xls, aster(se) dec(3)    nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, Y, School FE, Y, SE, Cluster, Sample, 250, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_language residx, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD8.xls, bracket aster(se) dec(3)   nocons keep(residx)  addtext(Year FE, Y, Student and Class Charact, Y, School FE, Y, SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore
	
*LANGUAGE - COLUMNS 2 TO 7


	foreach z in boy_m nonwhite_m mother_educ_low_m age_incorrect repeated_m dropped_m {
	preserve 

	*de-meaning
	xi: reg language_score `z' i.year i.id_school $controls
	predict residy, r

	xi: reg d2 `z' i.year i.id_school $controls  if e(sample)==1
	predict residx_d2, r

	xi: reg d2_`z' `z' i.year i.id_school $controls if e(sample)==1
	predict residx_d2_`z', r

	*Cluster
	xi: reg residy residx_d2 residx_d2_`z' , cluster(id_school) 
	outreg2 using Conley/TabD8.xls, aster(se) dec(3)   nocons keep(residx_d2 residx_d2_`z')  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy residx_d2 residx_d2_`z' , lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD8.xls, bracket aster(se) dec(3)   nocons keep(residx_d2 residx_d2_`z')  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore
	}

*********************************************************************************************************************************************************************************************************************************************
* CONLEY - TABLE D9 - Violence effects on Student Mobility
*********************************************************************************************************************************************************************************************************************************************

insheet using "Databases\data_movements.txt", comma clear case
global students "i.age i.boy i.mother_educ i.white first_grade second_grade third_grade forth_grade fifth_grade i.live_close"
global students2 " i.age i.boy i.white   first_grade second_grade third_grade forth_grade fifth_grade  i.live_close"


*PANEL A - MAIN RESULTS

	*All Grades 1st to 5th	

	*de-meaning
	preserve	
	xi: reg d2 $students i.year i.id_school
	predict residx_d2, r

	foreach i in within end {
	xi: reg transf_`i' $students i.year i.id_school
	predict residy_transf_`i', r

	xi: reg dropout_`i' $students i.year i.id_school
	predict residy_dropout_`i', r

	*Cluster - transferred 
	xi: reg residy_transf_`i' residx_d2, cluster(id_school)
	outreg2 using Conley/TabD9a_`i'.xls, aster(se) dec(4)   nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley - transferred
    ols_spatial_HAC residy_transf_`i' residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD9a_`i'.xls, bracket aster(se) dec(4)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)


	*Cluster - dropped out
	xi: reg residy_dropout_`i' residx_d2, cluster(id_school)
	outreg2 using Conley/TabD9a_`i'.xls, aster(se) dec(4)   nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley - dropped out
	ols_spatial_HAC residy_dropout_`i' residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD9a_`i'.xls, bracket aster(se) dec(4)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	}
	restore


	*Only 5th Graders	
		
	preserve	
	keep if fifth_grade==1

	*de-meaning
	xi: reg d2 $students i.year i.id_school
	predict residx_d2, r

	foreach i in within end {
	xi: reg transf_`i' $students i.year i.id_school
	predict residy_transf_`i', r 

	xi: reg dropout_`i' $students i.year i.id_school
	predict residy_dropout_`i', r

	*Cluster - transferred
	xi: reg residy_transf_`i' residx_d2, cluster(id_school)
	outreg2 using Conley/TabD9a_`i'.xls, aster(se) dec(4)   nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley - transferred
	ols_spatial_HAC residy_transf_`i' residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD9a_`i'.xls, bracket aster(se) dec(4)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)


	*Cluster - dropped out
	xi: reg residy_dropout_`i' residx_d2, cluster(id_school)
	outreg2 using Conley/TabD9a_`i'.xls, aster(se) dec(4)   nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley - dropped out
	ols_spatial_HAC residy_dropout_`i' residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD9a_`i'.xls, bracket aster(se) dec(4)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	}
	restore


*PANEL B - HETEROGENEITY BY PARENTS STATUS

gen d2mother_educ_low=d2*mother_educ_low

	*All Grades 1st to 5th	

	preserve	
	*de-meaning
	xi: reg d2 $students2 i.year i.id_school
	predict residx_d2, r

	xi: reg d2mother_educ_low $students2 i.year i.id_school
	predict residx_d2mother_educ_low, r

	xi: reg mother_educ_low $students2 i.year i.id_school
	predict residx_mother_educ_low, r


	foreach i in within end {
	xi: reg transf_`i' $students2 i.year i.id_school
	predict residy_transf_`i', r

	xi: reg dropout_`i' $students2 i.year i.id_school
	predict residy_dropout_`i', r

	*Cluster - transferred 
	reg residy_transf_`i' residx_d2 residx_d2mother_educ_low residx_mother_educ_low, cluster(id_school)
	outreg2 using Conley/TabD9b_`i'.xls, aster(se) dec(4)   nocons keep(residx_d2 residx_d2mother_educ_low residx_mother_educ_low)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley - transferred 
	ols_spatial_HAC residy_transf_`i' residx_d2 residx_d2mother_educ_low residx_mother_educ_low, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD9b_`i'.xls, bracket aster(se) dec(4)   nocons keep(residx_d2 residx_d2mother_educ_low residx_mother_educ_low)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)

	*Cluster - dropped out 
	reg residy_dropout_`i' residx_d2 residx_d2mother_educ_low residx_mother_educ_low, cluster(id_school)
	outreg2 using Conley/TabD9b_`i'.xls, aster(se) dec(4)   nocons keep(residx_d2 residx_d2mother_educ_low residx_mother_educ_low)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley - dropped out 
	ols_spatial_HAC residy_dropout_`i' residx_d2 residx_d2mother_educ_low residx_mother_educ_low, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD9b_`i'.xls, bracket aster(se) dec(4)   nocons keep(residx_d2 residx_d2mother_educ_low residx_mother_educ_low)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	}
	restore


	*Only 5th Graders	
	
	preserve	
	keep if fifth_grade==1
	
	*de-meaning
	xi: reg d2 $students2 i.year i.id_school
	predict residx_d2, r

	xi: reg d2mother_educ_low $students2 i.year i.id_school
	predict residx_d2mother_educ_low, r

	xi: reg mother_educ_low $students2 i.year i.id_school
	predict residx_mother_educ_low, r

	foreach i in within end {

	xi: reg transf_`i' $students2 i.year i.id_school
	predict residy_transf_`i', r

	xi: reg dropout_`i' $students2 i.year i.id_school
	predict residy_dropout_`i', r

	*Cluster - transferred
	reg residy_transf_`i' residx_d2 residx_d2mother_educ_low residx_mother_educ_low, cluster(id_school)
	outreg2 using Conley/TabD9b_`i'.xls, aster(se) dec(4)   nocons keep(residx_d2 residx_d2mother_educ_low residx_mother_educ_low)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley - transferred
	ols_spatial_HAC residy_transf_`i' residx_d2 residx_d2mother_educ_low residx_mother_educ_low, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD9b_`i'.xls, bracket aster(se) dec(4)   nocons keep(residx_d2 residx_d2mother_educ_low residx_mother_educ_low)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)

	*Cluster - dropped out 
	reg residy_dropout_`i' residx_d2 residx_d2mother_educ_low residx_mother_educ_low, cluster(id_school)
	outreg2 using Conley/TabD9b_`i'.xls, aster(se) dec(4)   nocons keep(residx_d2 residx_d2mother_educ_low residx_mother_educ_low)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley - dropped out
	ols_spatial_HAC residy_dropout_`i' residx_d2 residx_d2mother_educ_low residx_mother_educ_low, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD9b_`i'.xls, bracket aster(se) dec(4)   nocons keep(residx_d2 residx_d2mother_educ_low residx_mother_educ_low)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	}
	restore
	


*PANEL C - HETEROGENEITY BY INTENSITY 

	*All Grades 1st to 5th	

	preserve	
	*de-meaning
	foreach x of varlist d9 dcontiguous d2Ncontiguous {
	xi: reg `x' $students i.year i.id_school
	predict residx_`x', r
	}

	foreach i in within end {
	xi: reg transf_`i' $students i.year i.id_school
	predict residy_transf_`i', r

	xi: reg dropout_`i' $students i.year i.id_school
	predict residy_dropout_`i', r
	}

	foreach x of varlist d9 dcontiguous d2Ncontiguous {
	foreach i in within end {
	
	*Cluster - transferred
	xi: reg residy_transf_`i' residx_`x', cluster(id_school)
	outreg2 using Conley/TabD9c_`i'.xls, aster(se) dec(4)   nocons keep(residx_`x')  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley - transferred
	ols_spatial_HAC residy_transf_`i' residx_`x', lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD9c_`i'.xls, bracket aster(se) dec(4)   nocons keep(residx_`x')  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)

	*Cluster - dropped out 
	xi: reg residy_dropout_`i' residx_`x', cluster(id_school)
	outreg2 using Conley/TabD9c_`i'.xls, aster(se) dec(4)   nocons keep(residx_`x')  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley - dropped out
	ols_spatial_HAC residy_dropout_`i' residx_`x', lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD9c_`i'.xls, bracket aster(se) dec(4)   nocons keep(residx_`x')  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	}
	}
	restore


	*Only 5th Graders	

	preserve	
	keep if fifth_grade==1

	*de-meaning
	foreach x of varlist d9 dcontiguous d2Ncontiguous {
	xi: reg `x' $students i.year i.id_school
	predict residx_`x', r
	}

	foreach i in within end {
	xi: reg transf_`i' $students i.year i.id_school
	predict residy_transf_`i', r

	xi: reg dropout_`i' $students i.year i.id_school
	predict residy_dropout_`i', r
	}

	foreach x of varlist d9 dcontiguous d2Ncontiguous {
	foreach i in within end {

	*Cluster - transferred
	xi: reg residy_transf_`i' residx_`x', cluster(id_school)
	outreg2 using Conley/TabD9c_`i'.xls, aster(se) dec(4)   nocons keep(residx_`x')  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley - transferred 
	ols_spatial_HAC residy_transf_`i' residx_`x', lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD9c_`i'.xls, bracket aster(se) dec(4)   nocons keep(residx_`x')  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)

	*Cluster - dropped out
	xi: reg residy_dropout_`i' residx_`x', cluster(id_school)
	outreg2 using Conley/TabD9c_`i'.xls, aster(se) dec(4)   nocons keep(residx_`x')  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley - dropped out
	ols_spatial_HAC residy_dropout_`i' residx_`x', lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD9c_`i'.xls, bracket aster(se) dec(4)   nocons keep(residx_`x')  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	}
	}
	restore


*********************************************************************************************************************************************************************************************************************************************
* CONLEY - TABLE D10 - Student Selection at the Prova Brasil Exam
*********************************************************************************************************************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global infra  "kitchen principal_office science_lab computer_lab  school_lunch teacher_office"
global classroom "boys_class nonwhite_class age_class work_class repeated_class dropped_class"
keep if d250m==1


*COLUMN 1

	preserve
	xi: reg n_took_test  d2 i.age i.mother_educ i.white i.repeated i.dropped  $infra $classroom i.year i.id_school
	gen esample=e(sample)

	xi: reg n_took_test i.age i.mother_educ i.white i.repeated i.dropped  $infra $classroom i.year i.id_school if esample==1
	predict residy_n_took_test, r

	xi: reg d2 i.age i.mother_educ i.white i.repeated i.dropped  $infra $classroom i.year i.id_school if esample==1
	predict residx_d2, r

	*Cluster
	xi: reg residy_n_took_test residx_d2, cluster(id_school)
	outreg2 using Conley/TabD10.xls, aster(se) dec(3)    nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_n_took_test residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD10.xls, bracket aster(se) dec(3)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore

*COLUMN 2 

	preserve
	xi: reg boy_m d2 i.age i.mother_educ i.white i.repeated i.dropped  $infra $classroom i.year i.id_school
	gen esample=e(sample)

	xi: reg boy_m  i.age i.mother_educ i.white i.repeated i.dropped  $infra $classroom i.year i.id_school if esample==1
	predict residy_boy_m, r

	xi: reg d2 i.age i.mother_educ i.white i.repeated i.dropped  $infra $classroom i.year i.id_school  if esample==1
	predict residx_d2, r

	*Cluster 
	xi: reg residy_boy_m residx_d2, cluster(id_school)
	outreg2 using Conley/TabD10.xls, aster(se) dec(3)    nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_boy_m residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD10.xls, bracket aster(se) dec(3)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore

*COLUMN 3

	preserve
	xi: reg nonwhite_m  d2  i.boy i.age i.mother_educ  i.repeated i.dropped  $infra $classroom i.year i.id_school 
	gen esample=e(sample)

	xi: reg nonwhite_m i.boy i.age i.mother_educ  i.repeated i.dropped  $infra $classroom i.year i.id_school if esample==1
	predict residy_nonwhite_m, r

	xi: reg d2 i.boy i.age i.mother_educ  i.repeated i.dropped  $infra $classroom i.year i.id_school if esample==1
	predict residx_d2, r 

	*Cluster
	xi: reg residy_nonwhite_m residx_d2, cluster(id_school)
	outreg2 using Conley/TabD10.xls, aster(se) dec(3)    nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_nonwhite_m residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD10.xls, bracket aster(se) dec(3)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore

*COLUMN 4 

	preserve
	xi: reg mother_educ_low_m  d2  i.boy i.age  i.white i.repeated i.dropped  $infra $classroom i.year i.id_school 
	gen esample=e(sample)

	xi: reg mother_educ_low_m i.boy i.age  i.white i.repeated i.dropped  $infra $classroom i.year i.id_school  if esample==1
	predict residy_mother_educ_low_m, r

	xi: reg d2 i.boy i.age  i.white i.repeated i.dropped  $infra $classroom i.year i.id_school if esample==1
	predict residx_d2, r

	*Cluster
	xi: reg residy_mother_educ_low_m residx_d2, cluster(id_school)
	outreg2 using Conley/TabD10.xls, aster(se) dec(3)    nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_mother_educ_low_m residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD10.xls, bracket aster(se) dec(3)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore


*COLUMN 5 

	preserve
	xi: reg repeated_m d2  i.boy i.age i.mother_educ i.white i.dropped $infra $classroom i.year i.id_school 
	gen esample=e(sample)

	xi: reg repeated_m i.boy i.age i.mother_educ i.white i.dropped $infra $classroom i.year i.id_school if esample==1
	predict residy_repeated_m, r

	xi: reg d2 i.boy i.age i.mother_educ i.white i.dropped $infra $classroom i.year i.id_school if esample==1
	predict residx_d2, r

	*Cluster
	xi: reg residy_repeated_m residx_d2, cluster(id_school)
	outreg2 using Conley/TabD10.xls, aster(se) dec(3)    nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_repeated_m residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD10.xls, bracket aster(se) dec(3)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore

*COLUMN 6 

	preserve
	xi: reg dropped_m d2 i.boy i.age i.mother_educ i.white i.repeated  $infra $classroom i.year i.id_school 
	gen esample=e(sample)

	xi: reg dropped_m i.boy i.age i.mother_educ i.white i.repeated  $infra $classroom i.year i.id_school if esample==1
	predict residy_dropped_m, r

	xi: reg d2 i.boy i.age i.mother_educ i.white i.repeated  $infra $classroom i.year i.id_school if esample==1
	predict residx_d2, r

	*Cluster
	xi: reg residy_dropped_m residx_d2, cluster(id_school)
	outreg2 using Conley/TabD10.xls, aster(se) dec(3)    nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_dropped_m residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD10.xls, bracket aster(se) dec(3)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore


*COLUMN 7 

	preserve
	xi: reg age_incorrect d2 i.boy  i.mother_educ i.white i.repeated i.dropped  $infra $classroom i.year i.id_school 
	gen esample=e(sample)

	xi: reg age_incorrect i.boy  i.mother_educ i.white i.repeated i.dropped  $infra $classroom i.year i.id_school if esample==1
	predict residy_age_incorrect, r

	xi: reg d2 i.boy  i.mother_educ i.white i.repeated i.dropped  $infra $classroom i.year i.id_school if esample==1
	predict residx_d2, r

	*Cluster
	xi: reg residy_age_incorrect residx_d2, cluster(id_school)
	outreg2 using Conley/TabD10.xls, aster(se) dec(3)    nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_age_incorrect residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabD10.xls, bracket aster(se) dec(3)   nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	restore



*********************************************************************************************************************************************************************************************************************************************
* CONLEY - TABLE E1 - Violence Effects on Teachers' Turnover Between Years
*********************************************************************************************************************************************************************************************************************************************

insheet using "Databases\data_teachers.txt", comma clear case
global school  "n_teachers  n_classes_school "
global teachers  "age male  white undergraduated graduated n_classes_teacher"


*SAMPLE
xi: areg left_school d2 c.d2#c.age c.d2#c.male c.d2#c.white c.d2#c.undergraduated c.d2#c.graduated c.d2#c.n_classes_teacher $teachers $school i.year, abs(id_school) cluster(id_school)
gen esample=e(sample)


*COLUMN 1

	*de-meaning 
	foreach z in left_school  {
	xi: reg `z'  $teachers  $school i.year i.id_school if esample==1
	predict residy_`z', re
	}

	foreach z in d2  {
	xi: reg `z' $teachers  $school i.year i.id_school if esample==1
	predict residx_`z', re
	}

	*Cluster
	xi: reg residy_left_school residx_d2, cluster(id_school)
	outreg2 using Conley/TabE1.xls, aster(se) dec(3)  nocons keep(residx_d2)  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)
	
	*Conley
	ols_spatial_HAC residy_left_school residx_d2, lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabE1.xls, bracket  aster(se) dec(3)  nocons keep(residx_d2)  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)


*COLUMNS 2 TO 6

	*de-meaning 

	foreach z in age male white undergraduated graduated  {	
	gen d2_`z'=c.d2#c.`z'
	xi: reg d2_`z' $teachers  $school i.year i.id_school if esample==1
	predict residx_d2_`z', re
	}

	
	foreach z in age male white undergraduated graduated  {

	*Cluster
	xi: reg residy_left_school residx_d2 residx_d2_`z' , cluster(id_school)
	outreg2 using Conley/TabE1.xls, aster(se) dec(3)  nocons keep(residx_d2 residx_d2_`z')  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_left_school residx_d2 residx_d2_`z' , lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabE1.xls, bracket aster(se) dec(3)  nocons keep(residx_d2 residx_d2_`z' )  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)
	}


*COLUMN 7

	*Cluster
	xi: reg residy_left_school residx_d2 residx_d2_age residx_d2_male residx_d2_white residx_d2_undergraduated residx_d2_graduated  , cluster(id_school)
	outreg2 using Conley/TabE1.xls, aster(se) dec(3)  nocons keep(residx_d2 residx_d2_age residx_d2_male residx_d2_white residx_d2_undergraduated residx_d2_graduated  )  addtext(SE, Cluster, Sample, 250m, Cutoff, None, Lag, None)

	*Conley
	ols_spatial_HAC residy_left_school residx_d2 residx_d2_age residx_d2_male residx_d2_white residx_d2_undergraduated residx_d2_graduated  , lat(POINT_X) lon(POINT_Y) t(year) p(id_school) dist(0.5) lag(3)
	outreg2 using Conley/TabE1.xls, bracket aster(se) dec(3)  nocons keep(residx_d2 residx_d2_age residx_d2_male residx_d2_white residx_d2_undergraduated residx_d2_graduated   )  addtext(SE, Conley, Sample, 250m, Cutoff, 500m, Lag, 3)

	
	
	
	
