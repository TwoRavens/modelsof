**********************************************************************************
** file name: 	cses_coding and merging.do  									**
** purpose: 	recoding variables, merging with other data, restricting data	**
** paper:		gender, political knowledge and descriptive representation		**
** date: 		september 2017													**
** authors: 	Ruth Dassonneville and Ian McAllister							**
**********************************************************************************

** set working directory first
cd "/Users/ruthdassonneville/Desktop/gender and knowledge - replication/"

** load dataset
use "CSES_combined.dta", clear


**********************************************
** CODING OF INDIVIDUAL LEVEL CONTROLS	 	**
**********************************************


** age
generate D2001=elect_year-D2001_Y if Module==4
replace D2001=. if D2001_Y==9997					// refused
replace D2001=. if D2001_Y==9998					// don't know
replace D2001=. if D2001_Y==9999					// missings

generate age=A2001 if Module==1
replace age=. if A2001==001
replace age=. if A2001==002
replace age=. if A2001==003
replace age=. if A2001==004

replace age=B2001 if Module==2
replace age=. if B2001==001
replace age=. if B2001==002
replace age=. if B2001==003
replace age=. if B2001==004

replace age=C2001 if Module==3
replace age=. if C2001==001
replace age=. if C2001==002
replace age=. if C2001==003
replace age=. if C2001==004
replace age=. if C2001==997						// refused
replace age=. if C2001==998						// don't know
replace age=. if C2001==999						// missing

replace age=D2001 if Module==4

generate age2=age*age

** gender
generate female=1 if A2002==2					// female
replace female=0 if A2002==1					// male

replace female=1 if B2002==2					// female
replace female=0 if B2002==1					// male

replace female=1 if C2002==2					// female
replace female=0 if C2002==1					// male
replace female=. if C2002==7					// refused
replace female=. if C2002==9					// missing

replace female=1 if D2002==2					// female
replace female=0 if D2002==1					// male
replace female=. if D2002==7					// refused
replace female=. if D2002==9					// missing


** education
generate college=0 if A2003==1					// none
replace college=0 if A2003==2					// incomplete primary
replace college=0 if A2003==3					// primary completed
replace college=0 if A2003==4					// incomplete secondary
replace college=0 if A2003==5					// secondary completed
replace college=0 if A2003==6					// post-secondary trade
replace college=1 if A2003==7					// university incomplete
replace college=1 if A2003==8					// university complete

replace college=0 if B2003==1					// none
replace college=0 if B2003==2					// incomplete primary
replace college=0 if B2003==3					// primary completed
replace college=0 if B2003==4					// incomplete secondary
replace college=0 if B2003==5					// secondary completed
replace college=0 if B2003==6					// post-secondary trade/vocational
replace college=1 if B2003==7					// university incomplete
replace college=1 if B2003==8					// university complete

replace college=0 if C2003==1					// none
replace college=0 if C2003==2					// incomplete primary
replace college=0 if C2003==3					// primary completed
replace college=0 if C2003==4					// incomplete secondary
replace college=0 if C2003==5					// secondary completed
replace college=0 if C2003==6					// post-secondary trade/vocational
replace college=1 if C2003==7					// university incomplete
replace college=1 if C2003==8					// university complete

replace college=0 if D2003==01					// early childhood education
replace college=0 if D2003==02					// primary
replace college=0 if D2003==03					// lower secondary
replace college=0 if D2003==04					// upper secondary
replace college=0 if D2003==05					// post secondary non-tertiary
replace college=0 if D2003==06					// short-cycle tertiary
replace college=1 if D2003==07					// bachelor
replace college=1 if D2003==08					// master
replace college=1 if D2003==09					// doctoral

summarize age female college


** political knowledge
* module 1
generate polinfo1_mod1=1 if A2023==1
replace polinfo1_mod1=0 if A2023==2
replace polinfo1_mod1=0 if A2023==8

generate polinfo2_mod1=1 if A2024==1
replace polinfo2_mod1=0 if A2024==2
replace polinfo2_mod1=0 if A2024==8

generate polinfo3_mod1=1 if A2025==1
replace polinfo3_mod1=0 if A2025==2
replace polinfo3_mod1=0 if A2025==8

generate polknowledge_mod1=polinfo1_mod1 + polinfo2_mod1 + polinfo3_mod1
generate polknowledge_mod1_st=(polknowledge_mod1-0)/(3-0)

* module 2
generate polinfo1_mod2=1 if B3047_1==1
replace polinfo1_mod2=0 if B3047_1==2
replace polinfo1_mod2=0 if B3047_1==8

generate polinfo2_mod2=1 if B3047_2==1
replace polinfo2_mod2=0 if B3047_2==2
replace polinfo2_mod2=0 if B3047_2==8

generate polinfo3_mod2=1 if B3047_3==1
replace polinfo3_mod2=0 if B3047_3==2
replace polinfo3_mod2=0 if B3047_3==8

generate polknowledge_mod2=polinfo1_mod2 + polinfo2_mod2 + polinfo3_mod2
generate polknowledge_mod2_st=(polknowledge_mod2-0)/(3-0)

* module 3
generate polinfo1_mod3=1 if C3036_1==1
replace polinfo1_mod3=0 if C3036_1==5
replace polinfo1_mod3=0 if C3036_1==8

generate polinfo2_mod3=1 if C3036_2==1
replace polinfo2_mod3=0 if C3036_2==5
replace polinfo2_mod3=0 if C3036_2==8

generate polinfo3_mod3=1 if C3036_3==1
replace polinfo3_mod3=0 if C3036_3==5
replace polinfo3_mod3=0 if C3036_3==8

generate polknowledge_mod3=polinfo1_mod3 + polinfo2_mod3 + polinfo3_mod3
generate polknowledge_mod3_st=(polknowledge_mod3-0)/(3-0)

* module 4
generate polinfo1_mod4=1 if D3025_1_A==1
replace polinfo1_mod4=0 if D3025_1_A==5
replace polinfo1_mod4=0 if D3025_1_A==8

generate polinfo2_mod4=1 if D3025_2_A==1
replace polinfo2_mod4=0 if D3025_2_A==5
replace polinfo2_mod4=0 if D3025_2_A==8

generate polinfo3_mod4=1 if D3025_3_A==1
replace polinfo3_mod4=0 if D3025_3_A==5
replace polinfo3_mod4=0 if D3025_3_A==8

generate polinfo4_mod4=1 if D3025_4_A==1
replace polinfo4_mod4=0 if D3025_4_A==5
replace polinfo4_mod4=0 if D3025_4_A==8

generate polknowledge_mod4=polinfo1_mod4 + polinfo2_mod4 + polinfo3_mod4 + polinfo4_mod4
generate polknowledge_mod4_st=(polknowledge_mod4-0)/(4-0)

* combined indicator
generate polknowledge=polknowledge_mod1_st if Module==1
replace polknowledge=polknowledge_mod2_st if Module==2
replace polknowledge=polknowledge_mod3_st if Module==3
replace polknowledge=polknowledge_mod4_st if Module==4




******************************************
** INTERVIEW MODE VARIABLE				**
******************************************

gen svy_mode=0 if A1023==1			// personal
replace svy_mode=1 if A1023==2		// telephone
replace svy_mode=2 if A1023==3		// self-administered
replace svy_mode=3 if A1023==4		// mixed
replace svy_mode=3 if A1023==5		// mixed

replace svy_mode=0 if B1023==1		// ftf
replace svy_mode=1 if B1023==2		// telephone
replace svy_mode=2 if B1023==3		// self-administered
replace svy_mode=3 if B1023==4		// mixed
replace svy_mode=3 if B1023==5		// mixed

replace svy_mode=0 if C1023==1		// ftf
replace svy_mode=1 if C1023==2		// telephone
replace svy_mode=2 if C1023==3		// self-administered
replace svy_mode=3 if C1023==4		// mixed

replace svy_mode=0 if D1023==1		// ftf
replace svy_mode=1 if D1023==2		// telephone
replace svy_mode=2 if D1023==3		// self-administered
replace svy_mode=2 if D1023==4		// internet > self-administered
replace svy_mode=3 if D1023==5		// mixed
replace svy_mode=3 if D1023==6		// mixed


**********************************************
** POLITICAL EXPRESSION 					**
**********************************************

/* generate a variable identifying the samples that Fortin-Rittberger identified
as samples for which political expression can be measured (i.e., there should be 
a don't know option */

gen JF_expression=1 if A1004=="AUS_1996"
replace JF_expression=1 if A1004=="AUS_2004"
replace JF_expression=1 if A1004=="AUS_2007"
replace JF_expression=1 if A1004=="AUT_2008"
replace JF_expression=1 if A1004=="BEL_1999" & A1006==561		// Flemish region
replace JF_expression=1 if A1004=="BRA_2002"
replace JF_expression=1 if A1004=="BRA_2006"
replace JF_expression=1 if A1004=="BRA_2010"
replace JF_expression=1 if A1004=="CAN_1997"
replace JF_expression=1 if A1004=="CAN_2004"
replace JF_expression=1 if A1004=="CAN_2008"
replace JF_expression=1 if A1004=="CHE_1999"
replace JF_expression=1 if A1004=="CHE_2003"
replace JF_expression=1 if A1004=="CHL_2005"
replace JF_expression=1 if A1004=="CZE_1996"
replace JF_expression=1 if A1004=="CZE_2006"
replace JF_expression=1 if A1004=="CZE_2010"
replace JF_expression=1 if A1004=="DEU_2002" & svy_mode==1		// Germany 2002 - telephone
replace JF_expression=1 if A1004=="DEU_1998"
replace JF_expression=1 if A1004=="DEU_2009"
replace JF_expression=1 if A1004=="DNK_2007"
replace JF_expression=1 if A1004=="ESP_1996"
replace JF_expression=1 if A1004=="ESP_2000"
replace JF_expression=1 if A1004=="ESP_2004"
replace JF_expression=1 if A1004=="ESP_2008"
replace JF_expression=1 if A1004=="EST_2011"
replace JF_expression=1 if A1004=="FIN_2003"
replace JF_expression=1 if A1004=="FIN_2007"
replace JF_expression=1 if A1004=="FIN_2011"
replace JF_expression=1 if A1004=="FRA_2002"
replace JF_expression=1 if A1004=="FRA_2007"
replace JF_expression=1 if A1004=="GBR_1997"
replace JF_expression=1 if A1004=="GBR_2005"
replace JF_expression=1 if A1004=="GRC_2009"
replace JF_expression=1 if A1004=="HRV_2007"
replace JF_expression=1 if A1004=="HUN_1998"
replace JF_expression=1 if A1004=="HUN_2002"
replace JF_expression=1 if A1004=="IRL_2002"
replace JF_expression=1 if A1004=="ISL_2007"
replace JF_expression=1 if A1004=="ISL_2009"
replace JF_expression=1 if A1004=="ISR_1996"
replace JF_expression=1 if A1004=="ISR_2003"
replace JF_expression=1 if A1004=="ISR_2006"
replace JF_expression=1 if A1004=="ITA_2006"
replace JF_expression=1 if A1004=="JPN_2004"
replace JF_expression=1 if A1004=="JPN_2007"
replace JF_expression=1 if A1004=="KOR_2004"
replace JF_expression=1 if A1004=="KOR_2008"
replace JF_expression=1 if A1004=="MEX_2000"
replace JF_expression=1 if A1004=="MEX_2003"
replace JF_expression=1 if A1004=="MEX_2006"
replace JF_expression=1 if A1004=="MEX_2009"
replace JF_expression=1 if A1004=="NLD_1998"
replace JF_expression=1 if A1004=="NLD_2006"
replace JF_expression=1 if A1004=="NLD_2010"
replace JF_expression=1 if A1004=="NOR_1997"
replace JF_expression=1 if A1004=="NOR_2001"
replace JF_expression=1 if A1004=="NOR_2005"
replace JF_expression=1 if A1004=="NOR_2009"
replace JF_expression=1 if A1004=="NZL_1996"
replace JF_expression=1 if A1004=="NZL_2002"
replace JF_expression=1 if A1004=="NZL_2008"
replace JF_expression=1 if A1004=="PER_2006"
replace JF_expression=1 if A1004=="PER_2011"
replace JF_expression=1 if A1004=="PHL_2004"
replace JF_expression=1 if A1004=="PHL_2010"
replace JF_expression=1 if A1004=="POL_1997"
replace JF_expression=1 if A1004=="POL_2001"
replace JF_expression=1 if A1004=="POL_2007"
replace JF_expression=1 if A1004=="PRT_2002"
replace JF_expression=1 if A1004=="PRT_2005"
replace JF_expression=1 if A1004=="PRT_2009"
replace JF_expression=1 if A1004=="ROM_2009"
replace JF_expression=1 if A1004=="ROU_1996"
replace JF_expression=1 if A1004=="ROU_2004"
replace JF_expression=1 if A1004=="RUS_2004"
replace JF_expression=1 if A1004=="SVK_2010"
replace JF_expression=1 if A1004=="SVN_2004"
replace JF_expression=1 if A1004=="SWE_1998"
replace JF_expression=1 if A1004=="SWE_2002"
replace JF_expression=1 if A1004=="SWE_2006"
replace JF_expression=1 if A1004=="THA_2007"
replace JF_expression=1 if A1004=="UKR_1998"
replace JF_expression=1 if A1004=="USA_1996"
replace JF_expression=1 if A1004=="USA_2004"
replace JF_expression=1 if A1004=="USA_2008"


** political expression
* module 1
generate polexp1_mod1=1 if A2023==1
replace polexp1_mod1=1 if A2023==2
replace polexp1_mod1=0 if A2023==8

generate polexp2_mod1=1 if A2024==1
replace polexp2_mod1=1 if A2024==2
replace polexp2_mod1=0 if A2024==8

generate polexp3_mod1=1 if A2025==1
replace polexp3_mod1=1 if A2025==2
replace polexp3_mod1=0 if A2025==8

generate polexpression_mod1=polexp1_mod1 + polexp2_mod1 + polexp3_mod1
generate polexpression_mod1_st=(polexpression_mod1-0)/(3-0)

* module 2
generate polexp1_mod2=1 if B3047_1==1
replace polexp1_mod2=1 if B3047_1==2
replace polexp1_mod2=0 if B3047_1==8

generate polexp2_mod2=1 if B3047_2==1
replace polexp2_mod2=1 if B3047_2==2
replace polexp2_mod2=0 if B3047_2==8

generate polexp3_mod2=1 if B3047_3==1
replace polexp3_mod2=1 if B3047_3==2
replace polexp3_mod2=0 if B3047_3==8

generate polexpression_mod2=polexp1_mod2 + polexp2_mod2 + polexp3_mod2
generate polexpression_mod2_st=(polknowledge_mod2-0)/(3-0)

* module 3
generate polexp1_mod3=1 if C3036_1==1
replace polexp1_mod3=1 if C3036_1==5
replace polexp1_mod3=0 if C3036_1==8

generate polexp2_mod3=1 if C3036_2==1
replace polexp2_mod3=1 if C3036_2==5
replace polexp2_mod3=0 if C3036_2==8

generate polexp3_mod3=1 if C3036_3==1
replace polexp3_mod3=1 if C3036_3==5
replace polexp3_mod3=0 if C3036_3==8

generate polexpression_mod3=polexp1_mod3 + polexp2_mod3 + polexp3_mod3
generate polexpression_mod3_st=(polknowledge_mod3-0)/(3-0)

gen polexpression_st=polexpression_mod1_st if Module==1
replace polexpression_st=polexpression_mod2_st if Module==2
replace polexpression_st=polexpression_mod3_st if Module==3

replace polexpression_st=. if JF_expression!=1						// excluding samples that were not part of JFR-analyses


**********************************************
** MERGING WITH JFR dataset question format	**
**********************************************

/* JFR dataset is the dataset compiled by J. Fortin-Rittberger, 
the data can be found on dataverse: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/HT5E7H */

merge m:1 A1004BE using "JFR_data_formerging"

drop if _merge==2
drop _merge


label define Qinternational 1 "National" 3 "National and international"
label values Z_Qcontent Qinternational

label define Qwomen 0 "No question on women" 1 "At least one question on women"
label values womencontent Qwomen

label define Qstructure 1 "True/False" 2 "Multiple choice" 3 "Open-ended" 4 "Mix"
label values Qstructure Qstructure


**********************************************
** MERGING WITH MACRO-LEVEL DATA SOURCES	**
**********************************************


** GALLAGHER DISPROPORTIONALITY

merge m:1 A1004 using "gallagher_data_for_cses_limited.dta" , force
drop if _merge==2
drop _merge

** WOMEN IN PARLIAMENT

keep if age>17

gen birthyear=elect_year-age

gen year18=birthyear+18
gen year19=birthyear+19
gen year20=birthyear+20
gen year21=birthyear+21
gen year16=birthyear+16
gen year17=birthyear+17


split A1004, p("_")
drop A10042

gen ctr_year18=A10041+"_"+string(year18)
gen ctr_year19=A10041+"_"+string(year19)
gen ctr_year20=A10041+"_"+string(year20)
gen ctr_year21=A10041+"_"+string(year21)
gen ctr_year16=A10041+"_"+string(year16)
gen ctr_year17=A10041+"_"+string(year17)
drop A10041


merge m:1 A1004 using "women_parliament_1945_2016_for_cses.dta"
drop if _merge==2
rename women_parliament women_parliament_survey
drop _merge

merge m:1 ctr_year18 using "women_parliament_1945_2016_for_cses.dta"
drop if _merge==2
rename women_parliament women_parliament_18
drop _merge

merge m:1 ctr_year19 using "women_parliament_1945_2016_for_cses.dta"
drop if _merge==2
rename women_parliament women_parliament_19
drop _merge

merge m:1 ctr_year20 using "women_parliament_1945_2016_for_cses.dta"
drop if _merge==2
rename women_parliament women_parliament_20
drop _merge

merge m:1 ctr_year21 using "women_parliament_1945_2016_for_cses.dta"
drop if _merge==2
rename women_parliament women_parliament_21
drop _merge

merge m:1 ctr_year16 using "women_parliament_1945_2016_for_cses.dta"
drop if _merge==2
rename women_parliament women_parliament_16
drop _merge

merge m:1 ctr_year17 using "women_parliament_1945_2016_for_cses.dta"
drop if _merge==2
rename women_parliament women_parliament_17
drop _merge

egen women_parliament_18_21=rmean(women_parliament_18 women_parliament_19 women_parliament_20 women_parliament_21)
egen women_parliament_16_21=rmean(women_parliament_16 women_parliament_17 women_parliament_18 women_parliament_19 ///
women_parliament_20 women_parliament_21)
egen women_parliament_16_18=rmean(women_parliament_16 women_parliament_17 women_parliament_18)


** GENDER EQUALITY DATASET
merge m:1 A1004 using "genderequality_for cses.dta"
drop if _merge==2
rename genderequality_imp2 genderequality_survey
drop _merge

merge m:1 ctr_year18 using "genderequality_for cses.dta"
drop if _merge==2
rename genderequality_imp2 genderequality_18
drop _merge

merge m:1 ctr_year19 using "genderequality_for cses.dta"
drop if _merge==2
rename genderequality_imp2 genderequality_19
drop _merge

merge m:1 ctr_year20 using "genderequality_for cses.dta"
drop if _merge==2
rename genderequality_imp2 genderequality_20
drop _merge

merge m:1 ctr_year21 using "genderequality_for cses.dta"
drop if _merge==2
rename genderequality_imp2 genderequality_21
drop _merge

merge m:1 ctr_year16 using "genderequality_for cses.dta"
drop if _merge==2
rename genderequality_imp2 genderequality_16
drop _merge

merge m:1 ctr_year17 using "genderequality_for cses.dta"
drop if _merge==2
rename genderequality_imp2 genderequality_17
drop _merge

egen genderequality_18_21=rmean(genderequality_18 genderequality_19 genderequality_20 genderequality_21 )
egen genderequality_16_21=rmean(genderequality_16 genderequality_17 genderequality_18 genderequality_19 genderequality_20 genderequality_21 )
egen genderequality_16_18=rmean(genderequality_16 genderequality_18)

** WORLDBANK DATA (LABOR, TERTIARY EDUCATION, GDP)
merge m:1 A1004 using "worldbank_gender_selected_for cses.dta"
drop if _merge==2
drop _merge

** POLITY IV DEMOCRACY
merge m:1 ctr_year18 using "polityIV_cses.dta"
drop if _merge==2
rename democ democ_18
drop _merge

merge m:1 ctr_year19 using "polityIV_cses.dta"
drop if _merge==2
rename democ democ_19
drop _merge

merge m:1 ctr_year20 using "polityIV_cses.dta"
drop if _merge==2
rename democ democ_20
drop _merge

merge m:1 ctr_year21 using "polityIV_cses.dta"
drop if _merge==2
rename democ democ_21
drop _merge

merge m:1 A1004 using "polityIV_cses.dta"
drop if _merge==2
drop _merge

	/* add info on some countries not included (yet) in polity IV */
	replace democ=10 if A1004=="ISL_1999"
	replace democ=10 if A1004=="ISL_2003"
	replace democ=10 if A1004=="ISL_2007"
	replace democ=10 if A1004=="ISL_2009"
	replace democ=10 if A1004=="ISL_2013"
	replace democ=8 if A1004=="PHL_2016"		// 2015 value
	replace democ=10 if A1004=="SVK_2016"		// 2015 value	


recode democ democ_18 democ_19 democ_20 democ_21 (-66=0) (-77=0) (-88=0)
egen democ_18_21=rmean(democ_18 democ_19 democ_20 democ_21)

 

******************************************************
** LIMIT DATASET TO VARIABLES USED IN THE ANALYSES 	**
******************************************************

keep  polknowledge Module female A1004 A1005 birthyear age college lsq democ ///
democ_18_21   gdp_growth Z_Qcontent womencontent Qstructure svy_mode women_parliament_survey ///
women_parliament_18_21 polinfo1_mod1 polinfo1_mod2 polinfo1_mod3 polinfo2_mod1 polinfo2_mod2 ///
polinfo2_mod3 polinfo3_mod1 polinfo3_mod2 polinfo3_mod3 women_parliament_16_18 women_parliament_16_21 ///
female_labor tertiary_women_ipo genderequality_survey genderequality_18_21 polexpression_st

drop if Module==4

save  "CSES_gender_knowledge_ajpsreplication.dta", replace


