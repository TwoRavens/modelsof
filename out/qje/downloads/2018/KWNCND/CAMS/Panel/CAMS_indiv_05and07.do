use "../../CAMS/CAMSmerged.dta"

*This file selects variables for individuals matched across waves 2005 and 2007. Modify work, age, health and resident kids restrictions depending on desired sub-sample.  

*weights
svyset [pweight=JWGTR]

*drop if all homework subcategories for relevant years missing 
drop if missing(A13_05) & missing(A14_05) & missing(A15_05) & missing(A16_05) & missing(A17_05) & missing(A19_05) & missing(A21_05) & missing(A25_05) & missing(A31_05) & missing(A32_05)
drop if missing(A13_07) & missing(A14_07) & missing(A15_07) & missing(A16_07) & missing(A17_07) & missing(A19_07) & missing(A21_05) & missing(A25_07) & missing(A31_07) & missing(A32_07)

replace A13_05=0 if missing(A13_05)
replace A13_07=0 if missing(A13_07)
replace A13_09=0 if missing(A13_09)
replace A13_11=0 if missing(A13_11)
replace A13_13=0 if missing(A13_13)

replace A14_05=0 if missing(A14_05)
replace A14_07=0 if missing(A14_07)
replace A14_09=0 if missing(A14_09)
replace A14_11=0 if missing(A14_11)
replace A14_13=0 if missing(A14_13)

replace A15_05=0 if missing(A15_05)
replace A15_07=0 if missing(A15_07)
replace A15_09=0 if missing(A15_09)
replace A15_11=0 if missing(A15_11)
replace A15_13=0 if missing(A15_13)

replace A16_05=0 if missing(A16_05)
replace A16_07=0 if missing(A16_07)
replace A16_09=0 if missing(A16_09)
replace A16_11=0 if missing(A16_11)
replace A16_13=0 if missing(A16_13)

replace A17_05=0 if missing(A17_05)
replace A17_07=0 if missing(A17_07)
replace A17_09=0 if missing(A17_09)
replace A17_11=0 if missing(A17_11)
replace A17_13=0 if missing(A17_13)

replace A19_05=0 if missing(A19_05)
replace A19_07=0 if missing(A19_07)
replace A19_09=0 if missing(A19_09)
replace A19_11=0 if missing(A19_11)
replace A19_13=0 if missing(A19_13)

replace A21_05=0 if missing(A21_05)
replace A21_07=0 if missing(A21_07)
replace A21_09=0 if missing(A21_09)
replace A21_11=0 if missing(A21_11)
replace A21_13=0 if missing(A21_13)

replace A25_05=0 if missing(A25_05)
replace A25_07=0 if missing(A25_07)
replace A25_09=0 if missing(A25_09)
replace A25_11=0 if missing(A25_11)
replace A25_13=0 if missing(A25_13)

replace A31_05=0 if missing(A31_05)
replace A31_07=0 if missing(A31_07)
replace A31_09=0 if missing(A31_09)
replace A31_11=0 if missing(A31_11)
replace A31_13=0 if missing(A31_13)

replace A32_05=0 if missing(A32_05)
replace A32_07=0 if missing(A32_07)
replace A32_09=0 if missing(A32_09)
replace A32_11=0 if missing(A32_11)
replace A32_13=0 if missing(A32_13)

generate homework_05=A13_05+A14_05+A15_05+A16_05+A17_05+A19_05+(A21_05/30.4)*7+(A25_05/30.4)*7+(A31_05/30.4)*7+(A32_05/30.4)*7

generate homework_07=A13_07+A14_07+A15_07+A16_07+A17_07+A19_07+(A21_07/30.4)*7+(A25_07/30.4)*7+(A31_07/30.4)*7+(A32_07/30.4)*7

generate homework_09=A13_09+A14_09+A15_09+A16_09+A17_09+A19_09+(A21_09/30.4)*7+(A25_09/30.4)*7+(A31_09/30.4)*7+(A32_09/30.4)*7

generate homework_11=A13_11+A14_11+A15_11+A16_11+A17_11+A19_11+(A21_11/30.4)*7+(A25_11/30.4)*7+(A31_11/30.4)*7+(A32_11/30.4)*7

generate homework_13=A13_13+A14_13+A15_13+A16_13+A17_13+A19_13+(A21_13/30.4)*7+(A25_13/30.4)*7+(A31_13/30.4)*7+(A32_13/30.4)*7

generate work_05=A10_05

generate work_07=A10_07

generate work_09=A10_09

generate work_11=A10_11

generate work_13=A10_13

replace A1_05=0 if missing(A1_05)
replace A1_07=0 if missing(A1_07)
replace A1_09=0 if missing(A1_09)
replace A1_11=0 if missing(A1_11)
replace A1_13=0 if missing(A1_13)

replace A2_05=0 if missing(A2_05)
replace A2_07=0 if missing(A2_07)
replace A2_09=0 if missing(A2_09)
replace A2_11=0 if missing(A2_11)
replace A2_13=0 if missing(A2_13)

replace A3_05=0 if missing(A3_05)
replace A3_07=0 if missing(A3_07)
replace A3_09=0 if missing(A3_09)
replace A3_11=0 if missing(A3_11)
replace A3_13=0 if missing(A3_13)

replace A4_05=0 if missing(A4_05)
replace A4_07=0 if missing(A4_07)
replace A4_09=0 if missing(A4_09)
replace A4_11=0 if missing(A4_11)
replace A4_13=0 if missing(A4_13)

replace A6_05=0 if missing(A6_05)
replace A6_07=0 if missing(A6_07)
replace A6_09=0 if missing(A6_09)
replace A6_11=0 if missing(A6_11)
replace A6_13=0 if missing(A6_13)

replace A7_05=0 if missing(A7_05)
replace A7_07=0 if missing(A7_07)
replace A7_09=0 if missing(A7_09)
replace A7_11=0 if missing(A7_11)
replace A7_13=0 if missing(A7_13)

replace A8_05=0 if missing(A8_05)
replace A8_07=0 if missing(A8_07)
replace A8_09=0 if missing(A8_09)
replace A8_11=0 if missing(A8_11)
replace A8_13=0 if missing(A8_13)

replace A9_05=0 if missing(A9_05)
replace A9_07=0 if missing(A9_07)
replace A9_09=0 if missing(A9_09)
replace A9_11=0 if missing(A9_11)
replace A9_13=0 if missing(A9_13)

replace A24_05=0 if missing(A24_05)
replace A24_07=0 if missing(A24_07)
replace A24_09=0 if missing(A24_09)
replace A24_11=0 if missing(A24_11)
replace A24_13=0 if missing(A24_13)

replace A27_05=0 if missing(A27_05)
replace A27_07=0 if missing(A27_07)
replace A27_09=0 if missing(A27_09)
replace A27_11=0 if missing(A27_11)
replace A27_13=0 if missing(A27_13)

replace A28_05=0 if missing(A28_05)
replace A28_07=0 if missing(A28_07)
replace A28_09=0 if missing(A28_09)
replace A28_11=0 if missing(A28_11)
replace A28_13=0 if missing(A28_13)

replace A29_05=0 if missing(A29_05)
replace A29_07=0 if missing(A29_07)
replace A29_09=0 if missing(A29_09)
replace A29_11=0 if missing(A29_11)
replace A29_13=0 if missing(A29_13)

replace A30_05=0 if missing(A30_05)
replace A30_07=0 if missing(A30_07)
replace A30_09=0 if missing(A30_09)
replace A30_11=0 if missing(A30_11)
replace A30_13=0 if missing(A30_13)

replace A33_05=0 if missing(A33_05)
replace A33_07=0 if missing(A33_07)
replace A33_09=0 if missing(A33_09)
replace A33_11=0 if missing(A33_11)
replace A33_13=0 if missing(A33_13)

generate leisure_05=A1_05+A2_05+A3_05+A4_05+A6_05+A7_05+A8_05+A9_05+(A24_05/30.4)*7+(A27_05/30.4)*7+(A28_05/30.4)*7+(A29_05/30.4)*7+(A30_05/30.4)*7+(A33_05/30.4)*7

generate leisure_07=A1_07+A2_07+A3_07+A4_07+A6_07+A7_07+A8_07+A9_07+(A24_07/30.4)*7+(A27_07/30.4)*7+(A28_07/30.4)*7+(A29_07/30.4)*7+(A30_07/30.4)*7+(A33_07/30.4)*7

generate leisure_09=A1_09+A2_09+A3_09+A4_09+A6_09+A7_09+A8_09+A9_09+(A24_09/30.4)*7+(A27_09/30.4)*7+(A28_09/30.4)*7+(A29_09/30.4)*7+(A30_09/30.4)*7+(A33_09/30.4)*7

generate leisure_11=A1_11+A2_11+A3_11+A4_11+A6_11+A7_11+A8_11+A9_11+(A24_11/30.4)*7+(A27_11/30.4)*7+(A28_11/30.4)*7+(A29_11/30.4)*7+(A30_11/30.4)*7+(A33_11/30.4)*7

generate leisure_13=A1_13+A2_13+A3_13+A4_13+A6_13+A7_13+A8_13+A9_13+(A24_13/30.4)*7+(A27_13/30.4)*7+(A28_13/30.4)*7+(A29_13/30.4)*7+(A30_13/30.4)*7+(A33_13/30.4)*7

replace A5_05=0 if missing(A5_05)
replace A5_07=0 if missing(A5_07)
replace A5_09=0 if missing(A5_09)
replace A5_11=0 if missing(A5_11)
replace A5_13=0 if missing(A5_13)

replace A11_05=0 if missing(A11_05)
replace A11_07=0 if missing(A11_07)
replace A11_09=0 if missing(A11_09)
replace A11_11=0 if missing(A11_11)
replace A11_13=0 if missing(A11_13)

replace A12_05=0 if missing(A12_05)
replace A12_07=0 if missing(A12_07)
replace A12_09=0 if missing(A12_09)
replace A12_11=0 if missing(A12_11)
replace A12_13=0 if missing(A12_13)

replace A18_05=0 if missing(A18_05)
replace A18_07=0 if missing(A18_07)
replace A18_09=0 if missing(A18_09)
replace A18_11=0 if missing(A18_11)
replace A18_13=0 if missing(A18_13)

replace A20_05=0 if missing(A20_05)
replace A20_07=0 if missing(A20_07)
replace A20_09=0 if missing(A20_09)
replace A20_11=0 if missing(A20_11)
replace A20_13=0 if missing(A20_13)

replace A21_05=0 if missing(A21_05)
replace A21_07=0 if missing(A21_07)
replace A21_09=0 if missing(A21_09)
replace A21_11=0 if missing(A21_11)
replace A21_13=0 if missing(A21_13)

replace A22_05=0 if missing(A22_05)
replace A22_07=0 if missing(A22_07)
replace A22_09=0 if missing(A22_09)
replace A22_11=0 if missing(A22_11)
replace A22_13=0 if missing(A22_13)

replace A23_05=0 if missing(A23_05)
replace A23_07=0 if missing(A23_07)
replace A23_09=0 if missing(A23_09)
replace A23_11=0 if missing(A23_11)
replace A23_13=0 if missing(A23_13)

replace A26_05=0 if missing(A26_05)
replace A26_07=0 if missing(A26_07)
replace A26_09=0 if missing(A26_09)
replace A26_11=0 if missing(A26_11)
replace A26_13=0 if missing(A26_13)

generate personalcare_05=A5_05+A18_05+A20_05+(A26_05/30.4)*7
generate personalcare_07=A5_07+A18_07+A20_07+(A26_07/30.4)*7
generate personalcare_09=A5_09+A18_09+A20_09+(A26_09/30.4)*7
generate personalcare_11=A5_11+A18_11+A20_11+(A26_11/30.4)*7
generate personalcare_13=A5_13+A18_13+A20_13+(A26_13/30.4)*7

generate residual_05=A11_05+A12_05+(A22_05/30.4)*7+(A23_05/30.4)*7
generate residual_07=A11_07+A12_07+(A22_07/30.4)*7+(A23_07/30.4)*7
generate residual_09=A11_09+A12_09+(A22_09/30.4)*7+(A23_09/30.4)*7
generate residual_11=A11_11+A12_11+(A22_11/30.4)*7+(A23_11/30.4)*7
generate residual_13=A11_13+A12_13+(A22_13/30.4)*7+(A23_13/30.4)*7

generate totaltime_05=work_05+homework_05+leisure_05+personalcare_05+residual_05

generate totaltime_07=work_07+homework_07+leisure_07+personalcare_07+residual_07

generate totaltime_09=work_09+homework_09+leisure_09+personalcare_09+residual_09

generate totaltime_11=work_11+homework_11+leisure_11+personalcare_11+residual_11

generate totaltime_13=work_13+homework_13+leisure_13+personalcare_13+residual_13

generate computer_05=A11_05
generate computer_07=A11_07
generate computer_09=A11_09
generate computer_11=A11_11
generate computer_13=A11_13

*defining cutoffs for work and retirement
drop if missing(work_05)
drop if missing(leisure_05)
drop if missing(work_07)
drop if missing(leisure_07)

drop if leisure_05==0
drop if leisure_07==0
drop if work_05>100
drop if work_07>100
drop if homework_05>100
drop if homework_07>100
keep if work_05>=35 & work_07<=5

*health
*keep if JC001>=1 & JC001<=3 & KC001>=1 & KC001<=3 & LC001>=1 & LC001<=3

*no change in # of resident kids
*drop if JA099!=KA099
*drop if KA099!=LA099
*drop if missing(JA099) & missing(KA099) & missing(LA099)

*age
*keep if JAGE>=60 & JAGE<=66

*ratio
generate z_05=homework_05/(homework_05+leisure_05)
generate z_07=homework_07/(homework_07+leisure_07)

svy: mean z_05
estat sd
svy: mean z_07
estat sd
corr_svy z_05 z_07 [pweight=JWGTR]

svy: mean z_05 if GENDER==1
estat sd
svy: mean z_07 if GENDER==1
estat sd
corr_svy z_05 z_07 if GENDER==1 [pweight=JWGTR]

svy: mean z_05 if GENDER==2
estat sd
svy: mean z_07 if GENDER==2
estat sd
corr_svy z_05 z_07 if GENDER==2 [pweight=JWGTR]

*summary statistics
svy: mean totaltime_05
estat sd
svy: mean totaltime_07
estat sd

svy: mean totaltime_05 if GENDER==1
estat sd
svy: mean totaltime_07 if GENDER==1
estat sd

svy: mean totaltime_05 if GENDER==2
estat sd
svy: mean totaltime_07 if GENDER==2
estat sd

svy: mean work_05 
estat sd
svy: mean work_07
estat sd

svy: mean work_05 if GENDER==1
estat sd
svy: mean work_07 if GENDER==1
estat sd

svy: mean work_05 if GENDER==2 
estat sd
svy: mean work_07 if GENDER==2
estat sd

svy: mean homework_05
estat sd
svy: mean homework_07
estat sd

svy: mean homework_05 if GENDER==1
estat sd
svy: mean homework_07 if GENDER==1
estat sd

svy: mean homework_05 if GENDER==2
estat sd
svy: mean homework_07 if GENDER==2
estat sd

svy: mean leisure_05
estat sd
svy: mean leisure_07
estat sd

svy: mean leisure_05 if GENDER==1
estat sd
svy: mean leisure_07 if GENDER==1
estat sd

svy: mean leisure_05 if GENDER==2
estat sd
svy: mean leisure_07 if GENDER==2
estat sd

svy: mean personalcare_05
estat sd
svy: mean personalcare_07
estat sd

svy: mean personalcare_05 if GENDER==1
estat sd
svy: mean personalcare_07 if GENDER==1
estat sd

svy: mean personalcare_05 if GENDER==2
estat sd
svy: mean personalcare_07 if GENDER==2
estat sd

svy: mean residual_05
estat sd
svy: mean residual_07
estat sd

svy: mean residual_05 if GENDER==1
estat sd
svy: mean residual_07 if GENDER==1
estat sd

svy: mean residual_05 if GENDER==2
estat sd
svy: mean residual_07 if GENDER==2
estat sd

*homework sub-categories
generate housework_05=A13_05+A14_05
generate vehiclemaint_05=(A33_05/30.4)*7
generate homeimp_05=(A31_05/30.4)*7
generate maintenance_05=homeimp_05+vehiclemaint_05

generate housework_07=A13_07+A14_07
generate vehiclemaint_07=(A33_07/30.4)*7
generate homeimp_07=(A31_07/30.4)*7
generate maintenance_07=homeimp_07+vehiclemaint_07

*housework
svy: mean housework_05
estat sd
svy: mean housework_07
estat sd

svy: mean housework_05 if GENDER==1
estat sd
svy: mean housework_07 if GENDER==1
estat sd

svy: mean housework_05 if GENDER==2
estat sd
svy: mean housework_07 if GENDER==2
estat sd

*shopping/errands
svy: mean A16_05
estat sd
svy: mean A16_07
estat sd

svy: mean A16_05 if GENDER==1
estat sd
svy: mean A16_07 if GENDER==1
estat sd

svy: mean A16_05 if GENDER==2
estat sd
svy: mean A16_07 if GENDER==2
estat sd

*cooking
svy: mean A17_05
estat sd
svy: mean A17_07
estat sd

svy: mean A17_05 if GENDER==1
estat sd
svy: mean A17_07 if GENDER==1
estat sd

svy: mean A17_05 if GENDER==2
estat sd
svy: mean A17_07 if GENDER==2
estat sd

*yard work/gardening
svy: mean A15_05
estat sd
svy: mean A15_07
estat sd

svy: mean A15_05 if GENDER==1
estat sd
svy: mean A15_07 if GENDER==1
estat sd

svy: mean A15_05 if GENDER==2
estat sd
svy: mean A15_07 if GENDER==2
estat sd

*maintenance
svy: mean maintenance_05
estat sd
svy: mean maintenance_07
estat sd

svy: mean maintenance_05 if GENDER==1
estat sd
svy: mean maintenance_07 if GENDER==1
estat sd

svy: mean maintenance_05 if GENDER==2
estat sd
svy: mean maintenance_07 if GENDER==2
estat sd

*leisure sub-categories
generate exercise_05=A6_05+A7_05
generate relaxing_05=leisure_05-A1_05-exercise_05-A8_05

generate exercise_07=A6_07+A7_07
generate relaxing_07=leisure_07-A1_07-exercise_07-A8_07

*watch TV
svy: mean A1_05
estat sd
svy: mean A1_07
estat sd

svy: mean A1_05 if GENDER==1
estat sd
svy: mean A1_07 if GENDER==1
estat sd

svy: mean A1_05 if GENDER==2
estat sd
svy: mean A1_07 if GENDER==2
estat sd

*exercise
svy: mean exercise_05
estat sd
svy: mean exercise_07
estat sd

svy: mean exercise_05 if GENDER==1
estat sd
svy: mean exercise_07 if GENDER==1
estat sd

svy: mean exercise_05 if GENDER==2
estat sd
svy: mean exercise_07 if GENDER==2
estat sd

*socializing
svy: mean A8_05
estat sd
svy: mean A8_07
estat sd

svy: mean A8_05 if GENDER==1
estat sd
svy: mean A8_07 if GENDER==1
estat sd

svy: mean A8_05 if GENDER==2
estat sd
svy: mean A8_07 if GENDER==2
estat sd

*relaxing (residual leisure)
svy: mean relaxing_05
estat sd
svy: mean relaxing_07
estat sd

svy: mean relaxing_05 if GENDER==1
estat sd
svy: mean relaxing_07 if GENDER==1
estat sd

svy: mean relaxing_05 if GENDER==2
estat sd
svy: mean relaxing_07 if GENDER==2
estat sd

