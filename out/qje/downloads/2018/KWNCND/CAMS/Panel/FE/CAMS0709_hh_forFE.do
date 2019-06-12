use "../../CAMS/CAMSmerged.dta"

*This file selects variables for households matched across waves 2007 and 2009. Modify work, age, health and resident kids restrictions depending on desired sub-sample.  

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

*generate household time use measures
egen hhwork_05 = sum(work_05), by(HHID)
egen hhwork_07 = sum(work_07), by(HHID)
egen hhwork_09 = sum(work_09), by(HHID)
egen hhwork_11 = sum(work_11), by(HHID)
egen hhwork_13 = sum(work_13), by(HHID)
egen hhhomework_05 = sum(homework_05), by(HHID)
egen hhhomework_07 = sum(homework_07), by(HHID)
egen hhhomework_09 = sum(homework_09), by(HHID)
egen hhhomework_11 = sum(homework_11), by(HHID)
egen hhhomework_13 = sum(homework_13), by(HHID)
egen hhleisure_05 = sum(leisure_05), by(HHID)
egen hhleisure_07 = sum(leisure_07), by(HHID)
egen hhleisure_09 = sum(leisure_09), by(HHID)
egen hhleisure_11 = sum(leisure_11), by(HHID)
egen hhleisure_13 = sum(leisure_13), by(HHID)

*dummy for man's retirement
generate husbtrans_05=0
generate husbtrans_07=0
replace husbtrans_07=1 if GENDER==1 & work_05>=35 & work_07<=5
generate husbtrans_09=0
replace husbtrans_09=1 if GENDER==1 & work_07>=35 & work_09<=5
generate husbtrans_11=0
replace husbtrans_11=1 if GENDER==1 & work_09>=35 & work_11<=5
generate husbtrans_13=0
replace husbtrans_13=1 if GENDER==1 & work_11>=35 & work_13<=5

*dummy for woman's retirement
generate wifetrans_05=0
generate wifetrans_07=0
replace wifetrans_07=1 if GENDER==2 & work_05>=35 & work_07<=5
generate wifetrans_09=0
replace wifetrans_09=1 if GENDER==2 & work_07>=35 & work_09<=5
generate wifetrans_11=0
replace wifetrans_11=1 if GENDER==2 & work_09>=35 & work_11<=5
generate wifetrans_13=0
replace wifetrans_13=1 if GENDER==2 & work_11>=35 & work_13<=5

*dummy for man retired in both periods
generate husbretired_05=0
generate husbretired_07=0
replace husbretired_07=1 if GENDER==1 & work_05<=5 & work_07<=5
generate husbretired_09=0
replace husbretired_09=1 if GENDER==1 & work_07<=5 & work_09<=5
generate husbretired_11=0
replace husbretired_11=1 if GENDER==1 & work_09<=5 & work_11<=5
generate husbretired_13=0
replace husbretired_13=1 if GENDER==1 & work_11<=5 & work_13<=5

*dummy for woman retired in both periods
generate wiferetired_05=0
generate wiferetired_07=0
replace wiferetired_07=1 if GENDER==2 & work_05<=5 & work_07<=5
generate wiferetired_09=0
replace wiferetired_09=1 if GENDER==2 & work_07<=5 & work_09<=5
generate wiferetired_11=0
replace wiferetired_11=1 if GENDER==2 & work_09<=5 & work_11<=5
generate wiferetired_13=0
replace wiferetired_13=1 if GENDER==2 & work_11<=5 & work_13<=5

*dummy for man works in both periods
generate husbworks_05=0
generate husbworks_07=0
replace husbworks_07=1 if GENDER==1 & work_05>=35 & work_07>=35
generate husbworks_09=0
replace husbworks_09=1 if GENDER==1 & work_07>=35 & work_09>=35
generate husbworks_11=0
replace husbworks_11=1 if GENDER==1 & work_09>=35 & work_11>=35
generate husbworks_13=0
replace husbworks_13=1 if GENDER==1 & work_11>=35 & work_13>=35

*dummy for woman works in both periods
generate wifeworks_05=0
generate wifeworks_07=0
replace wifeworks_07=1 if GENDER==2 & work_05>=35 & work_07>=35
generate wifeworks_09=0
replace wifeworks_09=1 if GENDER==2 & work_07>=35 & work_09>=35
generate wifeworks_11=0
replace wifeworks_11=1 if GENDER==2 & work_09>=35 & work_11>=35
generate wifeworks_13=0
replace wifeworks_13=1 if GENDER==2 & work_11>=35 & work_13>=35

*generate household dummies for husband's and wife's status
egen hhhusbtrans_05 = sum(husbtrans_05), by(HHID)
egen hhhusbtrans_07 = sum(husbtrans_07), by(HHID)
egen hhhusbtrans_09 = sum(husbtrans_09), by(HHID)
egen hhhusbtrans_11 = sum(husbtrans_11), by(HHID)
egen hhhusbtrans_13 = sum(husbtrans_13), by(HHID)

egen hhwifetrans_05 = sum(wifetrans_05), by(HHID)
egen hhwifetrans_07 = sum(wifetrans_07), by(HHID)
egen hhwifetrans_09 = sum(wifetrans_09), by(HHID)
egen hhwifetrans_11 = sum(wifetrans_11), by(HHID)
egen hhwifetrans_13 = sum(wifetrans_13), by(HHID)

egen hhhusbretired_05 = sum(husbretired_05), by(HHID)
egen hhhusbretired_07 = sum(husbretired_07), by(HHID)
egen hhhusbretired_09 = sum(husbretired_09), by(HHID)
egen hhhusbretired_11 = sum(husbretired_11), by(HHID)
egen hhhusbretired_13 = sum(husbretired_13), by(HHID)

egen hhwiferetired_05 = sum(wiferetired_05), by(HHID)
egen hhwiferetired_07 = sum(wiferetired_07), by(HHID)
egen hhwiferetired_09 = sum(wiferetired_09), by(HHID)
egen hhwiferetired_11 = sum(wiferetired_11), by(HHID)
egen hhwiferetired_13 = sum(wiferetired_13), by(HHID)

egen hhhusbworks_05 = sum(husbworks_05), by(HHID)
egen hhhusbworks_07 = sum(husbworks_07), by(HHID)
egen hhhusbworks_09 = sum(husbworks_09), by(HHID)
egen hhhusbworks_11 = sum(husbworks_11), by(HHID)
egen hhhusbworks_13 = sum(husbworks_13), by(HHID)

egen hhwifeworks_05 = sum(wifeworks_05), by(HHID)
egen hhwifeworks_07 = sum(wifeworks_07), by(HHID)
egen hhwifeworks_09 = sum(wifeworks_09), by(HHID)
egen hhwifeworks_11 = sum(wifeworks_11), by(HHID)
egen hhwifeworks_13 = sum(wifeworks_13), by(HHID)

*age restriction on husband
*keep if GENDER==2 | (GENDER==1 & KAGE>=60 & KAGE<=66) 

*health
*keep if KC001>=1 & KC001<=3 & LC001>=1 & LC001<=3 & MC001>=1 & MC001<=3

*no change in # of resident kids
*drop if KA099!=LA099
*drop if LA099!=MA099
*drop if missing(KA099) & missing(LA099) & missing(MA099)

*selecting couple based on work status
keep if hhhusbtrans_09==1 & hhwiferetired_09==1 

drop if hhhusbtrans_07==1 & hhhusbtrans_09==1
drop if hhhusbtrans_07==1 & hhhusbtrans_11==1
drop if hhhusbtrans_07==1 & hhhusbtrans_13==1
drop if hhhusbtrans_09==1 & hhhusbtrans_11==1
drop if hhhusbtrans_09==1 & hhhusbtrans_13==1
drop if hhhusbtrans_11==1 & hhhusbtrans_13==1

*identifyining couples through duplicates of household id
sort HHID
quietly by HHID: gen dup = cond(_N==1,0,_n)
keep if dup>0

*delete same-sex couples or coding errors
egen hhgender=sum(GENDER), by(HHID)
drop if hhgender !=3

*construct ratios of home work relative to leisure
generate hhz_05=hhhomework_05/(hhhomework_05+hhleisure_05)
generate hhz_07=hhhomework_07/(hhhomework_07+hhleisure_07)
generate hhz_09=hhhomework_09/(hhhomework_09+hhleisure_09)
generate hhz_11=hhhomework_11/(hhhomework_11+hhleisure_11)
generate hhz_13=hhhomework_13/(hhhomework_13+hhleisure_13)

generate z_05=homework_05/(homework_05+leisure_05)
generate z_07=homework_07/(homework_07+leisure_07)
generate z_09=homework_09/(homework_09+leisure_09)
generate z_11=homework_11/(homework_11+leisure_11)
generate z_13=homework_13/(homework_13+leisure_13)

*rename variables
rename hhz_05 hhz05
rename hhz_07 hhz07
rename hhz_09 hhz09
rename hhz_11 hhz11
rename hhz_13 hhz13

rename z_05 z05
rename z_07 z07
rename z_09 z09
rename z_11 z11
rename z_13 z13

rename hhhusbtrans_05 hhhusbtrans05
rename hhhusbtrans_07 hhhusbtrans07
rename hhhusbtrans_09 hhhusbtrans09
rename hhhusbtrans_11 hhhusbtrans11
rename hhhusbtrans_13 hhhusbtrans13

save "../../CAMS/CAMS0709_hh_forFE.dta"

