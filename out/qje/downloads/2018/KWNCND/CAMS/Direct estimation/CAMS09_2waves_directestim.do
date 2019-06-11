use "../../CAMS/CAMSmerged.dta"

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

*re-structuring leisure variables
generate husbleisure_05=0
replace husbleisure_05=leisure_05 if GENDER==1
generate husbleisure_07=0
replace husbleisure_07=leisure_07 if GENDER==1
generate husbleisure_09=0
replace husbleisure_09=leisure_09 if GENDER==1
generate husbleisure_11=0
replace husbleisure_11=leisure_11 if GENDER==1
generate husbleisure_13=0
replace husbleisure_13=leisure_13 if GENDER==1

generate wifeleisure_05=0
replace wifeleisure_05=leisure_05 if GENDER==2
generate wifeleisure_07=0
replace wifeleisure_07=leisure_07 if GENDER==2
generate wifeleisure_09=0
replace wifeleisure_09=leisure_09 if GENDER==2
generate wifeleisure_11=0
replace wifeleisure_11=leisure_11 if GENDER==2
generate wifeleisure_13=0
replace wifeleisure_13=leisure_13 if GENDER==2

egen hhhusbleisure_05 = sum(husbleisure_05), by(HHID)
egen hhhusbleisure_07 = sum(husbleisure_07), by(HHID)
egen hhhusbleisure_09 = sum(husbleisure_09), by(HHID)
egen hhhusbleisure_11 = sum(husbleisure_11), by(HHID)
egen hhhusbleisure_13 = sum(husbleisure_13), by(HHID)

egen hhwifeleisure_05 = sum(wifeleisure_05), by(HHID)
egen hhwifeleisure_07 = sum(wifeleisure_07), by(HHID)
egen hhwifeleisure_09 = sum(wifeleisure_09), by(HHID)
egen hhwifeleisure_11 = sum(wifeleisure_11), by(HHID)
egen hhwifeleisure_13 = sum(wifeleisure_13), by(HHID)

*re-structuring home work variables
generate husbhomework_05=0
replace husbhomework_05=homework_05 if GENDER==1
generate husbhomework_07=0
replace husbhomework_07=homework_07 if GENDER==1
generate husbhomework_09=0
replace husbhomework_09=homework_09 if GENDER==1
generate husbhomework_11=0
replace husbhomework_11=homework_11 if GENDER==1
generate husbhomework_13=0
replace husbhomework_13=homework_13 if GENDER==1

generate wifehomework_05=0
replace wifehomework_05=homework_05 if GENDER==2
generate wifehomework_07=0
replace wifehomework_07=homework_07 if GENDER==2
generate wifehomework_09=0
replace wifehomework_09=homework_09 if GENDER==2
generate wifehomework_11=0
replace wifehomework_11=homework_11 if GENDER==2
generate wifehomework_13=0
replace wifehomework_13=homework_13 if GENDER==2

egen hhhusbhomework_05 = sum(husbhomework_05), by(HHID)
egen hhhusbhomework_07 = sum(husbhomework_07), by(HHID)
egen hhhusbhomework_09 = sum(husbhomework_09), by(HHID)
egen hhhusbhomework_11 = sum(husbhomework_11), by(HHID)
egen hhhusbhomework_13 = sum(husbhomework_13), by(HHID)

egen hhwifehomework_05 = sum(wifehomework_05), by(HHID)
egen hhwifehomework_07 = sum(wifehomework_07), by(HHID)
egen hhwifehomework_09 = sum(wifehomework_09), by(HHID)
egen hhwifehomework_11 = sum(wifehomework_11), by(HHID)
egen hhwifehomework_13 = sum(wifehomework_13), by(HHID)

*construct logs of home work and leisure
generate loglm_05=ln(hhhusbleisure_05)
generate loglm_07=ln(hhhusbleisure_07)
generate loglm_09=ln(hhhusbleisure_09)
generate loglm_11=ln(hhhusbleisure_11)
generate loglm_13=ln(hhhusbleisure_13)

generate loglf_05=ln(hhwifeleisure_05)
generate loglf_07=ln(hhwifeleisure_07)
generate loglf_09=ln(hhwifeleisure_09)
generate loglf_11=ln(hhwifeleisure_11)
generate loglf_13=ln(hhwifeleisure_13)

generate loghm_05=ln(hhhusbhomework_05)
generate loghm_07=ln(hhhusbhomework_07)
generate loghm_09=ln(hhhusbhomework_09)
generate loghm_11=ln(hhhusbhomework_11)
generate loghm_13=ln(hhhusbhomework_13)

generate loghf_05=ln(hhwifehomework_05)
generate loghf_07=ln(hhwifehomework_07)
generate loghf_09=ln(hhwifehomework_09)
generate loghf_11=ln(hhwifehomework_11)
generate loghf_13=ln(hhwifehomework_13)

drop if missing(loghm_07)
drop if missing(loghm_09)

drop if missing(loghf_07)
drop if missing(loghf_09)

generate LHS_05=loglm_05-loglf_05
generate LHS_07=loglm_07-loglf_07
generate LHS_09=loglm_09-loglf_09
generate LHS_11=loglm_11-loglf_11
generate LHS_13=loglm_13-loglf_13

generate dLHS_07=LHS_07-LHS_05
generate dLHS_09=LHS_09-LHS_07
generate dLHS_11=LHS_11-LHS_09
generate dLHS_13=LHS_13-LHS_11

rename dLHS_07 dLHS07
rename dLHS_09 dLHS09
rename dLHS_11 dLHS11
rename dLHS_13 dLHS13

generate RHS_05=loghm_05-loghf_05
generate RHS_07=loghm_07-loghf_07
generate RHS_09=loghm_09-loghf_09
generate RHS_11=loghm_11-loghf_11
generate RHS_13=loghm_13-loghf_13

generate dRHS_07=RHS_07-RHS_05
generate dRHS_09=RHS_09-RHS_07
generate dRHS_11=RHS_11-RHS_09
generate dRHS_13=RHS_13-RHS_11

rename dRHS_07 dRHS07
rename dRHS_09 dRHS09
rename dRHS_11 dRHS11
rename dRHS_13 dRHS13

*identifyining couples through duplicates of household id
sort HHID
quietly by HHID: gen dup = cond(_N==1,0,_n)
keep if dup>0

egen hhgender=sum(GENDER), by(HHID)
drop if hhgender !=3

keep if GENDER==1

*select 2009 variables
keep HHID PN GENDER dLHS09 dRHS09 KWGTHH

*reshaping data
rename dLHS09 dLHS
rename dRHS09 dRHS
rename KWGTHH waveweight

generate time=2009

save "../../CAMS/CAMS09_2wave_directestim.dta"
