use "../../CAMS/CAMSmerged.dta"

*This file selects variables for individuals matched across waves 2007 and 2009. Modify health and resident kids restrictions depending on desired sub-sample.  

*drop if all homework subcategories for relevant years missing 
drop if missing(A13_07) & missing(A14_07) & missing(A15_07) & missing(A16_07) & missing(A17_07) & missing(A19_07) & missing(A21_07) & missing(A25_07) & missing(A31_07) & missing(A32_07)
drop if missing(A13_09) & missing(A14_09) & missing(A15_09) & missing(A16_09) & missing(A17_09) & missing(A19_09) & missing(A21_09) & missing(A25_09) & missing(A31_09) & missing(A32_09)

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

*defining cutoffs for work and retirement
drop if missing(work_07)
drop if missing(leisure_07)
drop if missing(work_09)
drop if missing(leisure_09)

drop if leisure_07==0
drop if leisure_09==0

drop if work_07>100
drop if work_09>100

drop if homework_07>100
drop if homework_09>100

*dummy for retirement
generate trans_05=0
generate trans_07=0
replace trans_07=1 if work_05>=35 & work_07<=5 
generate trans_09=0
replace trans_09=1 if work_07>=35 & work_09<=5 
generate trans_11=0
replace trans_11=1 if work_09>=35 & work_11<=5 
generate trans_13=0
replace trans_13=1 if work_11>=35 & work_13<=5 

*construct ratios
generate ratio2_05=homework_05/(homework_05+leisure_05)
generate ratio2_07=homework_07/(homework_07+leisure_07)
generate ratio2_09=homework_09/(homework_09+leisure_09)
generate ratio2_11=homework_11/(homework_11+leisure_11)
generate ratio2_13=homework_13/(homework_13+leisure_13)

*rename variables
rename ratio2_05 z05
rename ratio2_07 z07
rename ratio2_09 z09
rename ratio2_11 z11
rename ratio2_13 z13

*health
*keep if KC001>=1 & KC001<=3 & LC001>=1 & LC001<=3 & MC001>=1 & MC001<=3

*no change in # of resident kids
*drop if KA099!=LA099
*drop if LA099!=MA099
*drop if missing(KA099) & missing(LA099) & missing(MA099)

*require transition for one household member
keep if trans_09==1 

drop if trans_07==1 & trans_09==1
drop if trans_07==1 & trans_11==1
drop if trans_07==1 & trans_13==1
drop if trans_09==1 & trans_11==1
drop if trans_09==1 & trans_13==1
drop if trans_11==1 & trans_13==1

rename trans_05 trans05
rename trans_07 trans07
rename trans_09 trans09
rename trans_11 trans11
rename trans_13 trans13

save "../../CAMS/CAMS0709_indiv_forFE.dta"

