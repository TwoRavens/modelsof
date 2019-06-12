set obs 200
if "$cohort"=="" {
  global cohort "ndef"
}
gen vardesc = ""
gen var = ""
replace var = "hosp_hrr_lspend" in 1
replace vardesc = "Hosptial HRR EOL log(spend)" in 1
replace var = "hosp_hrr_spend" in 2
replace vardesc = "Hospital HRR EOL spend" in 2
replace var = "death30" in 3
replace vardesc  = "30 Day Mortality" in 3
replace var = "death365" in 4
replace vardesc = "1 Year Mortality" in 4
replace var = "age" in 5
replace vardesc = "Age" in 5
replace var = "ag65t69" in 6
replace vardesc = "Age 65-69" in 6
replace var = "ag70t74" in 7
replace vardesc = "Age 70-74" in 7
replace var = "ag75t79" in 8
replace vardesc = "Age 75-79" in 8
replace var = "ag80t84" in 9
replace vardesc = "Age 80-84" in 9
replace var = "ag85t89" in 10
replace vardesc = "Age 85-89" in 10
replace var = "ag90t94" in 11
replace vardesc = "Age 90-94" in 11
replace var = "ag95p" in 12
replace vardesc = "Age 95+" in 12
replace var = "male" in 13
replace vardesc = "Male" in 13
replace var = "white" in 14
replace vardesc = "Race: White" in 14
replace var = "black" in 15
replace vardesc= "Race: Black" in 15
replace var = "race_other" in 16
replace vardesc = "Race: Other" in 16
replace var = "year1" in 17
replace vardesc = "Year==2002" in 17
replace var = "year2" in 18
replace vardesc = "Year==2003" in 18
replace var = "year3" in 19
replace vardesc = "Year==2004" in 19
replace var = "year4" in 20
replace vardesc = "Year==2005" in 20
replace var = "year5" in 21
replace vardesc = "Year==2006" in 21
replace var = "year6" in 22
replace vardesc = "Year==2007" in 22
replace var = "como_hyper" in 23
replace vardesc = "Como: Hypertension" in 23
replace var = "como_stroke" in 24
replace vardesc = "Como: Stroke" in 24
replace var = "como_cervas" in 25
replace vardesc = "Como: Cerebovascular Disease" in 25
replace var = "como_renal" in 26
replace vardesc = "Como: Renal Failure Disease" in 26
replace var = "como_dialysis" in 27
replace vardesc = "Como: Dialysis" in 27
replace var = "como_COPD" in 28
replace vardesc = "Como: COPD" in 28
replace var = "como_pnuemo" in 29
replace vardesc = "Como: Pneumonia" in 29
replace var = "como_diabetes" in 30
replace vardesc = "Como: Diabetes" in 30
replace var = "como_protein" in 31
replace vardesc = "Como: Protein Calorie Malnutrition" in 31
replace var = "como_dementia" in 32
replace vardesc = "Como: Dementia" in 32
replace var = "como_FDLsDis" in 33
replace vardesc = "Como: Paralysis_FD" in 33
replace var = "como_periph" in 34
replace vardesc = "Como: Peripheral Vascular Disease" in 34
replace var = "como_metaCancer" in 35
replace vardesc = "Como: Metastatic Cancer" in 35
replace var = "como_trauma" in 36
replace vardesc = "Como: Trauma" in 36
replace var = "como_subs" in 37
replace vardesc = "Como: Substance Abuse" in 37
replace var = "como_mPsych" in 38
replace vardesc = "Como: Major Psych Disorder" in 38
replace var = "como_cLiver" in 39
replace vardesc = "Como: Chronic Liver Disease" in 39
replace var = "hosp_hrr_spend_st" in 40
replace vardesc = "Standardized Hosp HRR EOL" in 40
replace var = "lspend" in 41
replace vardesc = "log(charges)" in 41
replace var = "death7" in 42
replace vardesc = "7 Day Mortality" in 42
replace var = "cost" in 43
replace vardesc = "Costs (CCR)" in 43
replace var = "lcost" in 44
replace vardesc = "log(costs)" in 44
replace var = "loscnt" in 45
replace vardesc = "Length of Stay" in 45
replace var = "numprocs" in 46
replace vardesc = "Number of Procedures" in 46
replace var = "N" in 47
replace vardesc = "Observations" in 47
replace var = "N_g" in 48
replace vardesc = "No. FE Groups" in 48
replace var = "n_g_bar" in 49
replace vardesc = "Avg. No. in FE Group" in 49
replace var = "mean" in 50
replace vardesc = "Outcome Mean" in 50
replace var = "lloscnt" in 51
replace vardesc = "log(LOS)" in 51
replace var = "sd" in 52
replace vardesc = "Outcome Standard Deviation" in 52 
replace var = "comp_qual_score" in 53
replace vardesc = "Composite Hospital Compare Quality Score" in 53
replace var = "ami_qual_score" in 54
replace vardesc = "AMI Hospital Compare Quality Score" in 54
replace var = "chf_qual_score" in 55
replace vardesc = "CHF Hospital Compare Quality Score" in 55
replace var = "pneum_qual_score" in 56
replace vardesc = "Pneumonia Hospital Compare Quality Score" in 56
replace var ="idiag1" in  57
replace vardesc ="(038) septicemia" in  57
replace var ="idiag2" in  58
replace vardesc ="(162) mal neo trachea/lung" in  58
replace var ="idiag3" in  59
replace vardesc ="(197) secondry mal neo gi/resp" in  59
replace var ="idiag4" in  60
replace vardesc ="(410) acute myocardial infarct" in  60
replace var ="idiag5" in  61
replace vardesc ="(431) intracerebral hemorrhage" in  61
replace var ="idiag6" in  62
replace vardesc ="(433) precerebral occlusion" in  62
replace var ="idiag7" in  63
replace vardesc ="(434) cerebral artery occlus" in  63
replace var ="idiag8" in  64
replace vardesc ="(435) transient cereb ischemia" in  64
replace var ="idiag9" in  65
replace vardesc ="(482) oth bacterial pneumonia" in  65
replace var ="idiag10" in  66
replace vardesc ="(486) pneumonia, organism nos" in  66
replace var ="idiag11" in  67
replace vardesc ="(507) solid/liq pneumonitis" in  67
replace var ="idiag12" in  68
replace vardesc ="(518) other lung diseases" in  68
replace var ="idiag13" in  69
replace vardesc ="(530) diseases of esophagus" in  69
replace var ="idiag14" in  70
replace vardesc ="(531) gastric ulcer" in  70
replace var ="idiag15" in  71
replace vardesc ="(532) duodenal ulcer" in  71
replace var ="idiag16" in  72
replace vardesc ="(557) vasc insuff intestine" in  72
replace var ="idiag17" in  73
replace vardesc ="(558) oth noninf gastroenterit" in  73
replace var ="idiag18" in  74
replace vardesc ="(560) intestinal obstruction" in  74
replace var ="idiag19" in  75
replace vardesc ="(599) oth urinary tract disor" in  75
replace var ="idiag20" in  76
replace vardesc ="(728) dis of muscle/lig/fascia" in  76
replace var ="idiag21" in  77
replace vardesc ="(780) general symptoms" in  77
replace var ="idiag22" in  78
replace vardesc ="(807) fx rib/stern/laryn/trach" in  78
replace var ="idiag23" in  79
replace vardesc ="(808) pelvic fracture" in  79
replace var ="idiag24" in  80
replace vardesc ="(820) fracture neck of femur" in  80
replace var ="idiag25" in  81
replace vardesc ="(823) tibia & fibula fracture" in  81
replace var ="idiag26" in  82
replace vardesc ="(824) ankle fracture" in  82
replace var ="idiag27" in  83
replace vardesc ="(959) injury nec/nos" in  83
replace var ="idiag28" in  84
replace vardesc ="(965) pois-analgesic/antipyret" in  84
replace var ="idiag29"  in 85
replace vardesc ="(969) poison-psychotropic agt" in  85
replace var = "public" in 86
replace vardesc = "Public Hospital" in 86
replace var = "hightech90" in 87
replace vardesc = "High Tech - 10%" in 87
replace var = "hightech75" in 88
replace vardesc = "High Tech - 25%" in 88
replace var = "hosp_lcosts_global" in 89
replace vardesc = "Hospital Avg log(Costs)" in 89
replace var = "amb_lcosts_global_i" in 90
replace vardesc = "Ambulance Avg log(Costs)[-i]" in 90
replace var = "amb_lcosts_global" in 91
replace vardesc = "Ambulance Avg log(Costs)" in 91
replace var = "hosp_hsa_lspend" in 92
replace vardesc = "Hospital HSA log(spending)" in 92
replace var = "hosp_lcosts_global_i" in 93
replace vardesc = "Hospital Avg. log(spending)[-i]" in 93
replace var = "dhat" in 94
replace vardesc = "Predicted Mortality" in 94
replace var = "amb_distance" in 95
replace vardesc = "Ambulance Distance" in 95
replace var = "als" in 96
replace vardesc = "Ambulance - ALS" in 96
replace var = "ambulance_iv" in 97
replace vardesc = "Ambulance - IV Administered" in 97
replace var = "ambulance_intubation" in 98
replace vardesc = "Ambulance - Intubation" in 98
replace var = "amb_pmt_amt" in 99
replace vardesc = "Ambulance - Payment" in 99
replace var = "amb_emergency" in 100
replace vardesc = "Ambulance - Emergency Transport" in 100
replace var = "teach" in 101
replace vardesc = "Teaching Hopsital" in 101
replace var = "teach2" in 102
replace vardesc = "Teaching Hospital (def 2)" in 102
replace var = "n_ratio" in 103
replace vardesc = "Volume_hcy" in 103
replace var = "forprofit" in 104
replace vardesc = "Private, For Profit" in 104
replace var = "notforprofit" in 105
replace vardesc = "Private, Not-For-Profit" in 105
replace var = "public" in 106
replace vardesc = "Public Hospital" in 106
replace var = "nurse_pat" in 107
replace vardesc = "Nurse to Patient Ratio" in 107
replace var = "cqual" in 108
replace vardesc = "Composite Quality" in 108
replace var = "n_ratios" in 109
replace vardesc = "Volume_hcy (Standardized by 2sd)" in 109
replace var = "nurse_pat" in 110
replace vardesc = "Nurse to Patient Ratio (Standardized)" in 110
replace var = "n_ratios" in 111
replace vardesc = "Volume_hcy (Standardized)" in 111
replace var = "nurse_pats" in 112
replace vardesc = "Nurse to Patient Ratio (Standardized)" in 112
replace vardesc = "cquals" in 113
replace vardesc = "Composite Quality Score (Standardized)" in 113
replace var = "rsmr30s" in 114
replace vardesc = "Risk Standardized 30 Day Mortality (Standardized)" in 114
replace var = "pdeath30" in 115
replace vardesc = "Predicted 30 Day Mortality" in 115
replace var = "high_vol" in 116
replace vardesc = "High Volume (Top Quartile)" in 116
replace var = "leol" in 117
replace vardesc = "log(HSA End of Life Spending)" in 117
replace var = "death1" in 118
replace vardesc = "1 Day Mortality" in 118
replace var = "deathip" in 119
replace vardesc = "Inpatient Mortality" in 119
replace var = "hosp_lspend_tot_i" in 120
replace vardesc = "Hospital Avg. (log) Medicare Reimbursement" in 120
replace var = "amb_lspend_tot_i" in 121
replace vardesc = "Ambulance Avg. (log) Med Reimbursement" in 121
replace var = "amb_orighome" in 122
replace vardesc = "Patient Origin: Home" in 122
replace var = "amb_origscene" in 123
replace vardesc = "Patient Origin: Scene of Accident or Illness" in 123
replace var = "amb_orignurse" in 124
replace vardesc = "Patient Origin: Nursing Home" in 124
replace var = "amb_miles" in 125
replace vardesc = "Miles Transported with Patient" in 125
replace var = "amb_als" in 126
replace vardesc = "Advanced Life Support Ambulance" in 126
replace var = "amb_iv" in 127
replace vardesc = "Ambulance - IV Fluids" in 127
replace var = "amb_intubate" in 128
replace vardesc = "Ambulance - Intubation Performed" in 128
replace var = "year7" in 129
replace vardesc = "Year==2008" in 129
replace var = "amb_origother" in 130
replace vardesc = "Patient Origin: Other" in 130

save ../data/datadic.dta, replace

use ../data/ambulance_nondeff_conditions.dta, clear
levelsof amb_diag , local(amb_nondef) clean
global amb_nondef "`amb_nondef'"
qui tab amb_diag
local amb_diag_n = r(N)
gen var = "iadiag1" in 1

forval i = 2/`amb_diag_n' {
  global adiag "$adiag iadiag`i'"
  replace var = "iadiag`i'" in `i'
}
global adiag_t1 "iadiag1 $adiag"
rename amb_diag_desc vardesc 
keep vardesc var
append using ../data/datadic
save ../data/datadic ,replace


