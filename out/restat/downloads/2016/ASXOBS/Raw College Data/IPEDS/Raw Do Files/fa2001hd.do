* Created: 6/12/2004 8:22:33 PM
*                                                        
* Modify the path below to point to your data file.      
* The specified subdirectory was not created on          
* your computer. You will need to do this.               
*                                                        
* The stat program must be run against the specified     
* data file. This file is specified in the program       
* and must be saved separately.                          
*                                                        
* This program does not provide tab or summarize for all 
* variables.                                             
*                                                        
* There may be missing data for some institutions due    
* to the merge used to create this file.                 
*                                                        
* This program does not include reserved values in its   
* calculations for missing values.                       
*                                                        
* You may need to adjust your memory settings depending  
* upon the number of variables and records.              
*                                                        
* The save command may need to be modified per user      
* requirements.                                          
*                                                        
* For long lists of value labels, the titles may be      
* shortened per program requirements. 
*                                                        
insheet using "../Raw Data/fa2001hd_data_stata.csv", comma clear
label data "dct_fa2001hd"
label variable unitid "unitid"
label variable addr "Street address or post office box"
label variable city "City location of institution"
label variable stabbr "Post Office State abbreviation code"
label variable zip "ZIP + four"
label variable fips "FIPS State code"
label variable obereg "Bureau of Economic Analysis Code (OBE) Region"
label variable chfnm "Name of Chief Administrator"
label variable chftitle "Title of Chief Administrator"
label variable gentele "General information telephone number"
label variable fintele "Financial Aid Office telephone number"
label variable admtele "Admissions office telephone number"
label variable ein "Employer Identification Number"
label variable duns "Dunn and Bradstreet identification numbe"
label variable opeid "Office of Postsecondary Education ID Number"
label variable opeflag "OPE Title IV eligibility indicator code"
label variable webaddr "Institution^s internet website address"
label variable sector "Sector of institution"
label variable iclevel "Level of institution"
label variable control "Control of institution"
label variable affil "Affiliation of institution"
label variable hloffer "Highest level of offering"
label variable ugoffer "Undergraduate offering"
label variable groffer "Graduate offering"
label variable fpoffer "First-professional offering"
label variable hdegoffr "Highest Degree offered"
label variable deggrant "Degree granting status"
label variable pctmin1 "Percent Black, non-Hispanic"
label variable pctmin2 "Percent American Indian/Alaskan Native"
label variable pctmin3 "Percent Asian/Pacific Islander"
label variable pctmin4 "Percent Hispanic"
label variable hbcu "Historically Black College or University"
label variable hospital "Institution has hospital"
label variable medical "Institution grants a medical degree"
label variable tribal "Tribal college"
label variable carnegie "Carnegie Classification Code"
label variable locale "Degree of Urbanization"
label variable openpubl "Institution open to the general public"
label variable act "Status of institution"
label variable newid "UNITID for merged schools"
label variable deathyr "Year institution was deleted from IPEDS"
label variable closedat "Date institution closed"
label variable cyactive "Institution is active in current year"
label variable pseflag "Postsecondary institution indicator"
label variable pset4flg "Postsecondary and Title IV institution indicator"
label variable stat_fa "Response status of institution - Fall data collection"
label variable lock_fa "Final status of institution when fall data collection closed"
label variable stat_ic "Response status of institution - Institutional Characteristics"
label variable stat_c "Response status of institution - Completions"
label variable prch_c "Parent/child indicator - Completions"
label variable idx_c "UNITID of parent institution reporting Completions"
label variable imp_c "Type of imputation method  - Completions"
label variable dmajor "Students awarded degrees with double majors"
label variable stat_wi "Response status of institution - Winter Survey"
label variable stat_sa "Response status of institution - Faculty Salaries"
label variable prch_sa "Parent/child  indicator - Faculty Salaries"
label variable idx_sa "UNITID of parent  institution reporting Faculty Salaries"
label variable imp_sa "Type of imputation method - Faculty Salaries"
label variable stat_s "Response status of institution -  Fall Staff"
label variable prch_s "Parent/child indicator -  Fall Staff"
label variable idx_s "UNITID of parent institution reporting Fall Staff"
label variable imp_s "Type of Imputation method -  Fall Staff"
label variable stat_eap "Response status or instittuions - EAP"
label variable prch_eap "Parent/child indicator -  EAP"
label variable idx_eap "UNITID of parent institution reporting EAP"
label variable imp_eap "Type of Imputation method - EAP"
label variable lock_sa "Status of Faculty Salary survey when data collection closed"
label variable lock_s "Status of Fall Staff survey when data collection closed"
label variable lock_eap "Status of EAP survey when data collection closed"
label variable ftemp15 "Does your institution have 15 or more full-time employees?"
label variable sa_excl "Salary exclusion"
label variable stat_sp "Response status to Spring survey"
label variable stat_ef "Response status of institution - Enrollment"
label variable lock_ef "Status of Fall Enrollment survey when data collection closed"
label variable prch_ef "Parent/child indicator - Enrollment"
label variable idx_ef "UNITID of parent institution reporting Enrollment"
label variable imp_ef "Type of imputation method  - Enrollment"
label variable pta99_ef "Status enrollment by race/ethnicity (99.0000 CIP)"
label variable ptb_ef "Status enrollment summary by age"
label variable ptc_ef "Status residence of first-time first-year students"
label variable pte_ef "Status total entering class"
label variable ptdiaef "Status full year instructional activity"
label variable ptdfyef "Status full year enrollment Headcount"
label variable fyrpyear "12-month reporting period  for enrollment and instructional activity"
label variable fyflag "Report 12-month enrollment by race"
label variable stat_f "Response status of institution - Finance"
label variable lock_f "Status of Finance survey when data collection closed"
label variable prch_f "Parent/child indicator -  Finance"
label variable idx_f "UNITID of parent institution reporting Finance"
label variable imp_f "Type of imputation method  - Finance"
label variable form_f "Reporting standards used to report finance data"
label variable fybeg "Beginning date of fiscal year covered (all finance)"
label variable fyend "End date of fiscal year covered  (all finance)"
label variable gpfs "Clean Opinion GPFS from auditor (all finance)"
label variable f1gasbcr "GASB current accounting model"
label variable f1gasbal "GASB alternative accounting model"
label variable stat_sfa "Response status of institution - Student Financial Aid"
label variable lock_sfa "Status of Student Financial Aid Survey when data collection closed"
label variable prch_sfa "Parent/child indicator - Student Financial Aid"
label variable idx_sfa "UNITID of parent institution reporting Student Financial Aid"
label variable imp_sfa "Type of imputation method  Student Financial Aid"
label variable stat_gr "Response status of  institution - Graduation Rates"
label variable lock_gr "Status of Survey when data collection closed"
label variable prch_gr "Parent/child indicator - Graduation Rates"
label variable idx_gr "UNITID of parent institution reporting Graduation Rates"
label variable cohrtstu "Enrolled any full-time first-time students"
label variable cohrtyr1 "First cohort year for which data are available"
label variable pyaid "Institution offered  athletic aid 2000-2001"
label variable cohrtaid "Institution offered  athletic aid in cohort year"
label variable sport1 "Athletic aid for football  in cohort year"
label variable sport2 "Athletic aid for basketball  in cohort year"
label variable sport3 "Athletic aid for baseball  in cohort year"
label variable sport4 "Athletic aid  cross-country and  track  in cohort year"
label variable sport5 "Athletic aid  all other sports combined in cohort year"
label variable transver "Institution has transfer mission"
label variable longpgm "Institution has 5-year or 3-year programs"
label variable cohrtmt "cohrtmt"
label variable cindon "Total price for in-district students living on campus  2001-2002"
label variable cinson "Total price for in-state students living on campus 2001-2002"
label variable cotson "Total price out-of-state students living on campus 2001-2002"
label variable cindoff "Total price for in-district students living off-campus (not with family)  2001-2002"
label variable cinsoff "Total price for in-state students living off campus (not with family)  2001-2002"
label variable cotsoff "Total price for out-of-state students living off campus (not with family)  2001-2002"
label variable cindfam "Total price for in-district students living off campus (with family)  2001-2002"
label variable cinsfam "Total price for in-state students living off campus (with family)  2001-2002"
label variable cotsfam "Total price for out-of-state students living off campus (with family)  2001-2002"
label variable fte "Full-time eqivalent enrollment"
label variable ocrmsi "Minority Serving Institution"
label variable ocrhsi "Hispanic Serving Institution"
/*
label define label_stabbr AK "Alaska" 
label define label_stabbr AL "Alabama", add 
label define label_stabbr AR "Arkansas", add 
label define label_stabbr AS "American Samoa", add 
label define label_stabbr AZ "Arizona", add 
label define label_stabbr CA "California", add 
label define label_stabbr CO "Colorado", add 
label define label_stabbr CT "Connecticut", add 
label define label_stabbr DC "District of Columbia", add 
label define label_stabbr DE "Delaware", add 
label define label_stabbr FL "Florida", add 
label define label_stabbr FM "Federated States of Micronesia", add 
label define label_stabbr GA "Georgia", add 
label define label_stabbr GU "Guam", add 
label define label_stabbr HI "Hawaii", add 
label define label_stabbr IA "Iowa", add 
label define label_stabbr ID "Idaho", add 
label define label_stabbr IL "Illinois", add 
label define label_stabbr IN "Indiana", add 
label define label_stabbr KS "Kansas", add 
label define label_stabbr KY "Kentucky", add 
label define label_stabbr LA "Louisiana", add 
label define label_stabbr MA "Massachusetts", add 
label define label_stabbr MD "Maryland", add 
label define label_stabbr ME "Maine", add 
label define label_stabbr MH "Marshall Islands", add 
label define label_stabbr MI "Michigan", add 
label define label_stabbr MN "Minnesota", add 
label define label_stabbr MO "Missouri", add 
label define label_stabbr MP "Northern Marianas", add 
label define label_stabbr MS "Mississippi", add 
label define label_stabbr MT "Montana", add 
label define label_stabbr NC "North Carolina", add 
label define label_stabbr ND "North Dakota", add 
label define label_stabbr NE "Nebraska", add 
label define label_stabbr NH "New Hampshire", add 
label define label_stabbr NJ "New Jersey", add 
label define label_stabbr NM "New Mexico", add 
label define label_stabbr NV "Nevada", add 
label define label_stabbr NY "New York", add 
label define label_stabbr OH "Ohio", add 
label define label_stabbr OK "Oklahoma", add 
label define label_stabbr OR "Oregon", add 
label define label_stabbr PA "Pennsylvania", add 
label define label_stabbr PR "Puerto Rico", add 
label define label_stabbr PW "Palau", add 
label define label_stabbr RI "Rhode Island", add 
label define label_stabbr SC "South Carolina", add 
label define label_stabbr SD "South Dakota", add 
label define label_stabbr TN "Tennessee", add 
label define label_stabbr TX "Texas", add 
label define label_stabbr UT "Utah", add 
label define label_stabbr VA "Virginia", add 
label define label_stabbr VI "Virgin Islands", add 
label define label_stabbr VT "Vermont", add 
label define label_stabbr WA "Washington", add 
label define label_stabbr WI "Wisconsin", add 
label define label_stabbr WV "West Virginia", add 
label define label_stabbr WY "Wyoming", add 
label values stabbr label_stabbr
*/
label define label_fips 1 "Alabama" 
label define label_fips 10 "Delaware", add 
label define label_fips 11 "District of Columbia", add 
label define label_fips 12 "Florida", add 
label define label_fips 13 "Georgia", add 
label define label_fips 15 "Hawaii", add 
label define label_fips 16 "Idaho", add 
label define label_fips 17 "Illinois", add 
label define label_fips 18 "Indiana", add 
label define label_fips 19 "Iowa", add 
label define label_fips 2 "Alaska", add 
label define label_fips 20 "Kansas", add 
label define label_fips 21 "Kentucky", add 
label define label_fips 22 "Louisiana", add 
label define label_fips 23 "Maine", add 
label define label_fips 24 "Maryland", add 
label define label_fips 25 "Massachusetts", add 
label define label_fips 26 "Michigan", add 
label define label_fips 27 "Minnesota", add 
label define label_fips 28 "Mississippi", add 
label define label_fips 29 "Missouri", add 
label define label_fips 30 "Montana", add 
label define label_fips 31 "Nebraska", add 
label define label_fips 32 "Nevada", add 
label define label_fips 33 "New Hampshire", add 
label define label_fips 34 "New Jersey", add 
label define label_fips 35 "New Mexico", add 
label define label_fips 36 "New York", add 
label define label_fips 37 "North Carolina", add 
label define label_fips 38 "North Dakota", add 
label define label_fips 39 "Ohio", add 
label define label_fips 4 "Arizona", add 
label define label_fips 40 "Oklahoma", add 
label define label_fips 41 "Oregon", add 
label define label_fips 42 "Pennsylvania", add 
label define label_fips 44 "Rhode Island", add 
label define label_fips 45 "South Carolina", add 
label define label_fips 46 "South Dakota", add 
label define label_fips 47 "Tennessee", add 
label define label_fips 48 "Texas", add 
label define label_fips 49 "Utah", add 
label define label_fips 5 "Arkansas", add 
label define label_fips 50 "Vermont", add 
label define label_fips 51 "Virginia", add 
label define label_fips 53 "Washington", add 
label define label_fips 54 "West Virginia", add 
label define label_fips 55 "Wisconsin", add 
label define label_fips 56 "Wyoming", add 
label define label_fips 6 "California", add 
label define label_fips 60 "American Samoa", add 
label define label_fips 64 "Federated States of Micronesia", add 
label define label_fips 66 "Guam", add 
label define label_fips 68 "Marshall Islands", add 
label define label_fips 69 "Northern Marianas", add 
label define label_fips 70 "Palau", add 
label define label_fips 72 "Puerto Rico", add 
label define label_fips 78 "Virgin Islands", add 
label define label_fips 8 "Colorado", add 
label define label_fips 9 "Connecticut", add 
label values fips label_fips
label define label_obereg 0 "US Service schools" 
label define label_obereg 1 "New England CT ME MA NH RI VT", add 
label define label_obereg 2 "Mid East DE DC MD NJ NY PA", add 
label define label_obereg 3 "Great Lakes IL IN MI OH WI", add 
label define label_obereg 4 "Plains IA KS MN MO NE ND SD", add 
label define label_obereg 5 "Southeast AL AR FL GA KY LA MS NC SC TN", add 
label define label_obereg 6 "Southwest AZ NM OK TX", add 
label define label_obereg 7 "Rocky Mountains CO ID MT UT WY", add 
label define label_obereg 8 "Far West AK CA HI NV OR WA", add 
label define label_obereg 9 "Outlying areas AS FM GU MH MP PR PW VI", add 
label values obereg label_obereg
/*
label define label_chfnm -1 "{Not reported}" 
label define label_chfnm -3 "{Not available}", add 
label define label_chfnm Alpha "{Alpha}", add 
label values chfnm label_chfnm
label define label_chftitle -1 "{Not reported}" 
label define label_chftitle -3 "{Not available}", add 
label define label_chftitle Alpha "{Alpha}", add 
label values chftitle label_chftitle
label define label_gentele -1 "{Not reported}" 
label define label_gentele -3 "{Not available}", add 
label define label_gentele Alpha "{Alpha}", add 
label values gentele label_gentele
label define label_fintele -1 "{Not reported}" 
label define label_fintele -3 "{Not available}", add 
label define label_fintele Alpha "{Alpha}", add 
label values fintele label_fintele
label define label_admtele -1 "{Not reported}" 
label define label_admtele -3 "{Not available}", add 
label define label_admtele Alpha "{Alpha}", add 
label values admtele label_admtele
*/
label define label_opeflag 1 "Title IV participating" 
label define label_opeflag 2 "Unlisted branch/system office of partici", add 
label define label_opeflag 3 "Title IV participating, deferment only", add 
label define label_opeflag 5 "Not currently participating", add 
label define label_opeflag 6 "Not participating and is not listed on P", add 
label values opeflag label_opeflag
/*
label define label_webaddr -1 "{Not reported}" 
label define label_webaddr -3 "{Not available}", add 
label define label_webaddr Alpha "{Alpha}", add 
label values webaddr label_webaddr
*/
label define label_sector 0 "Central office or Administrative Unit" 
label define label_sector 1 "4-year public", add 
label define label_sector 2 "4-year private, not-for-profit", add 
label define label_sector 3 "4-year private, for-profit", add 
label define label_sector 4 "2-year public", add 
label define label_sector 5 "2-year private, not-for-profit", add 
label define label_sector 6 "2-year private, for-profit", add 
label define label_sector 7 "Less than 2-year public", add 
label define label_sector 8 "Less than 2-year private, not-for-profit", add 
label define label_sector 9 "Less than 2-year private, for-profit", add 
label define label_sector 99 "sector not known", add 
label values sector label_sector
label define label_iclevel -3 "{Not available}" 
label define label_iclevel 1 "Four or more years", add 
label define label_iclevel 2 "At least 2 but less than 4 years", add 
label define label_iclevel 3 "Less than 2 years (below associate)", add 
label values iclevel label_iclevel
label define label_control -3 "{Not available}" 
label define label_control 1 "Public", add 
label define label_control 2 "Private, not-for-profit", add 
label define label_control 3 "Private, for-profit", add 
label values control label_control
label define label_affil -3 "{Not available}" 
label define label_affil 1 "Public", add 
label define label_affil 2 "Private, for-profit", add 
label define label_affil 3 "Private, not for-profit, no religious af", add 
label define label_affil 4 "Private, not for-profit, religious affil", add 
label values affil label_affil
label define label_hloffer -2 "{Not applicable, first-professional only" 
label define label_hloffer -3 "{Not available}", add 
label define label_hloffer 0 "Other", add 
label define label_hloffer 1 "Award of less than one academic year", add 
label define label_hloffer 2 "At least 1, but less than 2 academic yea", add 
label define label_hloffer 3 "Associates degree", add 
label define label_hloffer 4 "At least 2, but less than 4 academic yea", add 
label define label_hloffer 5 "Bachelors degree", add 
label define label_hloffer 6 "Postbaccalaureate certificate", add 
label define label_hloffer 7 "Masters degree", add 
label define label_hloffer 8 "Post-masters certificate", add 
label define label_hloffer 9 "Doctors degree", add 
label values hloffer label_hloffer
label define label_ugoffer -3 "{Not available}" 
label define label_ugoffer 1 "Undergraduate degree or certificate offe", add 
label define label_ugoffer 2 "No undergraduate degree or certificate o", add 
label values ugoffer label_ugoffer
label define label_groffer -3 "{Not available}" 
label define label_groffer 1 "Graduate degree or certificate offered", add 
label define label_groffer 2 "No graduate degree or certificate offere", add 
label values groffer label_groffer
label define label_fpoffer -3 "{Not available}" 
label define label_fpoffer 1 "First-professional degree or certificate", add 
label define label_fpoffer 2 "No first-professional degree or certific", add 
label values fpoffer label_fpoffer
label define label_hdegoffr -3 "{Not available}" 
label define label_hdegoffr 0 "Non-degree granting", add 
label define label_hdegoffr 1 "First-professional only", add 
label define label_hdegoffr 10 "Doctoral", add 
label define label_hdegoffr 11 "Doctoral and first-professional", add 
label define label_hdegoffr 20 "Masters", add 
label define label_hdegoffr 21 "Masters and first-professional", add 
label define label_hdegoffr 30 "Bachelors", add 
label define label_hdegoffr 31 "Bachelors and first-professional", add 
label define label_hdegoffr 40 "Associates", add 
label values hdegoffr label_hdegoffr
label define label_deggrant -3 "{Not available}" 
label define label_deggrant 1 "Degree-granting", add 
label define label_deggrant 2 "Nondegree-granting, primarily postsecond", add 
label define label_deggrant 3 "Not primarily postsecondary institutions", add 
label define label_deggrant 4 "Institution is not an educational entity", add 
label values deggrant label_deggrant
label define label_hbcu 1 "Yes" 
label define label_hbcu 2 "No", add 
label values hbcu label_hbcu
label define label_hospital 1 "Yes" 
label define label_hospital 2 "No", add 
label values hospital label_hospital
label define label_medical -1 "{Not reported}" 
label define label_medical -2 "{Item not applicable}", add 
label define label_medical 1 "Yes", add 
label define label_medical 2 "No", add 
label values medical label_medical
label define label_tribal 1 "Yes" 
label define label_tribal 2 "No", add 
label values tribal label_tribal
label define label_carnegie -3 "{Not available}" 
label define label_carnegie 15 "Doctoral or Research Universities--Extensive", add 
label define label_carnegie 16 "Doctoral or Research Universities--Intensive", add 
label define label_carnegie 21 "Masters Colleges and Universities I", add 
label define label_carnegie 22 "Masters (Comprehensive) Colleges and Universities II", add 
label define label_carnegie 31 "Baccalaureate Colleges--Liberal Arts", add 
label define label_carnegie 32 "Baccalaureate Colleges--General", add 
label define label_carnegie 33 "Baccalaureate/Associates Colleges", add 
label define label_carnegie 40 "Associates Colleges", add 
label define label_carnegie 51 "Theological seminaries and other special", add 
label define label_carnegie 52 "Medical schools and medical centers", add 
label define label_carnegie 53 "Other separate health profession schools", add 
label define label_carnegie 54 "Schools of engineering and technology", add 
label define label_carnegie 55 "Schools of business and management", add 
label define label_carnegie 56 "Schools of art, music, and design", add 
label define label_carnegie 57 "Schools of law", add 
label define label_carnegie 58 "Teachers colleges", add 
label define label_carnegie 59 "Other specialized institutions", add 
label define label_carnegie 60 "Tribal Colleges and Universities", add 
label values carnegie label_carnegie
label define label_locale -3 "{Not available}" 
label define label_locale 1 "Large city", add 
label define label_locale 2 "Mid-size city", add 
label define label_locale 3 "Urban fringe of large city", add 
label define label_locale 4 "Urban fringe of mid-size city", add 
label define label_locale 5 "Large town", add 
label define label_locale 6 "Small town", add 
label define label_locale 7 "Rural", add 
label define label_locale 9 "Not assigned", add 
label values locale label_locale
label define label_openpubl -3 "{Not available}" 
label define label_openpubl 1 "Insititution is open to the public", add 
label define label_openpubl 2 "Insititution is not open to the public", add 
label values openpubl label_openpubl
/*
label define label_act A "Active - institution active and not a ne" 
label define label_act B "IPEDS scope not determined", add 
label define label_act C "Combined - merged with another inst", add 
label define label_act D "Delete - institution is out of business", add 
label define label_act M "Death with data - closed in current year", add 
label define label_act N "New - added during the current year", add 
label define label_act O "Out-of-scope - not within scope of unive", add 
label define label_act P "Potential add - might be added", add 
label define label_act Q "Potential restore - might be restored", add 
label define label_act R "Restore - restored to the current univer", add 
label define label_act U "Duplicate - UNITID previously assigned", add 
label define label_act W "Potential add that was not added", add 
label values act label_act
*/
label define label_deathyr -2 "{Item not applicable}" 
label define label_deathyr 2000 "Processing year 2000", add 
label define label_deathyr 2001 "Processing year 2001", add 
label values deathyr label_deathyr
label define label_closedat -2 "{Item not applicable}" 
label define label_closedat -3 "{Not available}", add 
label values closedat label_closedat
label define label_cyactive 1 "Yes" 
label define label_cyactive 2 "No", add 
label values cyactive label_cyactive
label define label_pseflag 1 "Active postsecondary institution" 
label define label_pseflag 2 "Not primarily postsec or not open to pub", add 
label define label_pseflag 3 "Not active", add 
label values pseflag label_pseflag
label define label_pset4flg 1 "Title IV postsecondary institution" 
label define label_pset4flg 2 "Non-Title IV postsecondary institution", add 
label define label_pset4flg 3 "Title IV NOT primarily postsecondary ins", add 
label define label_pset4flg 4 "Non-Title IV NOT primarily postsecondary", add 
label define label_pset4flg 6 "Non-Title IV postsecondary, not open to", add 
label define label_pset4flg 9 "Institution is not active in current uni", add 
label values pset4flg label_pset4flg
label define label_stat_fa -2 "{Item not applicable}" 
label define label_stat_fa -9 "{Not active}", add 
label define label_stat_fa 1 "Response", add 
label define label_stat_fa 5 "Nonresponse, not imputed", add 
label values stat_fa label_stat_fa
label define label_lock_fa -3 "{Not available}" 
label define label_lock_fa -9 "{Form not mailed}", add 
label define label_lock_fa 0 "Inactive (Not Registered)", add 
label define label_lock_fa 11 "User Level Partial(Reg. Active)", add 
label define label_lock_fa 141 "Closed, or out-of-scope", add 
label define label_lock_fa 151 "Refused", add 
label define label_lock_fa 170 "MDF", add 
label define label_lock_fa 21 "Coordinator1 Partial", add 
label define label_lock_fa 31 "Coordinator2 partial", add 
label define label_lock_fa 71 "Complete", add 
label values lock_fa label_lock_fa
label define label_stat_ic -2 "Undergraduate" 
label define label_stat_ic -9 "{Not active}", add 
label define label_stat_ic 1 "Respondent", add 
label define label_stat_ic 5 "Nonrespondent, not imputed", add 
label values stat_ic label_stat_ic
label define label_stat_c -2 "{Item not applicable}" 
label define label_stat_c -9 "{Not active}", add 
label define label_stat_c 1 "Respondent", add 
label define label_stat_c 2 "Partial respondent, imputed", add 
label define label_stat_c 4 "Nonrespondent, imputed", add 
label define label_stat_c 5 "Nonrespondent, not imputed", add 
label values stat_c label_stat_c
label define label_prch_c -2 "{Item not applicable}" 
label define label_prch_c 1 "Parent record (combined data)", add 
label define label_prch_c 2 "Child record (data reported with parent)", add 
label values prch_c label_prch_c
label define label_imp_c -2 "{Item not applicable}" 
label define label_imp_c 1 "Carry Forward (CF)", add 
label define label_imp_c 2 "Nearest Neighbor (NN)", add 
label define label_imp_c 3 "Group Median (GM)", add 
label values imp_c label_imp_c
label define label_dmajor -1 "{Not reported}" 
label define label_dmajor -2 "{Item not applicable}", add 
label define label_dmajor 1 "Yes", add 
label define label_dmajor 2 "No", add 
label values dmajor label_dmajor
label define label_stat_wi -2 "{Item not applicable}" 
label define label_stat_wi -9 "{Not active}", add 
label define label_stat_wi 1 "Response", add 
label define label_stat_wi 5 "Nonresponse, not imputed", add 
label values stat_wi label_stat_wi
label define label_stat_sa -2 "{Item not applicable}" 
label define label_stat_sa -9 "{Not active}", add 
label define label_stat_sa 1 "Response", add 
label define label_stat_sa 2 "Partial respondent, imputed", add 
label define label_stat_sa 4 "Nonrespondent, imputed", add 
label define label_stat_sa 5 "Nonresponse, not imputed", add 
label values stat_sa label_stat_sa
label define label_prch_sa -2 "{Item not applicable}" 
label define label_prch_sa 1 "Parent record (combined data)", add 
label define label_prch_sa 2 "Child record (data reported with parent)", add 
label values prch_sa label_prch_sa
label define label_imp_sa -2 "{Item not applicable}" 
label define label_imp_sa 1 "Carry Forward (CF)", add 
label define label_imp_sa 2 "Nearest Neighbor S", add 
label define label_imp_sa 3 "Nearest Neighbor FTE", add 
label define label_imp_sa 4 "Group Median (GM)", add 
label define label_imp_sa 5 "Partial imputation", add 
label values imp_sa label_imp_sa
label define label_stat_s -2 "{Item not applicable}" 
label define label_stat_s -9 "{Not active}", add 
label define label_stat_s 1 "Response", add 
label define label_stat_s 2 "Partial respondent, imputed", add 
label define label_stat_s 4 "Nonrespondent, imputed", add 
label define label_stat_s 5 "Nonresponse, not imputed", add 
label values stat_s label_stat_s
label define label_prch_s -2 "{Item not applicable}" 
label define label_prch_s 1 "Parent record (combined data)", add 
label define label_prch_s 2 "Child record (data reported with parent)", add 
label values prch_s label_prch_s
label define label_imp_s -2 "{Item not applicable}" 
label define label_imp_s 1 "Carry Forward (CF)", add 
label define label_imp_s 2 "Nearest Neighbor (NN)", add 
label define label_imp_s 3 "Group Median (GM)", add 
label define label_imp_s 4 "Partial imputation", add 
label define label_imp_s 5 "Carry forward and Partial Imputation", add 
label define label_imp_s 7 "Group median and Partial Imputation", add 
label values imp_s label_imp_s
label define label_stat_eap -2 "{Item not applicable}" 
label define label_stat_eap -9 "{Not active}", add 
label define label_stat_eap 1 "Response", add 
label define label_stat_eap 5 "Nonresponse, not imputed", add 
label values stat_eap label_stat_eap
label define label_prch_eap -2 "{Item not applicable}" 
label define label_prch_eap 1 "Parent record (combined data)", add 
label define label_prch_eap 2 "Child record (data reported with parent)", add 
label values prch_eap label_prch_eap
label define label_lock_sa -2 "{Item not applicable}" 
label define label_lock_sa 0 "Inactive (Not Registered)", add 
label define label_lock_sa 1 "Has data", add 
label define label_lock_sa 3 "Data was edited", add 
label define label_lock_sa 5 "Clean", add 
label define label_lock_sa 8 "Complete", add 
label values lock_sa label_lock_sa
label define label_lock_s -2 "{Item not applicable}" 
label define label_lock_s 0 "Inactive (Not Registered)", add 
label define label_lock_s 1 "Has data", add 
label define label_lock_s 3 "Data was edited", add 
label define label_lock_s 5 "Clean", add 
label define label_lock_s 8 "Complete", add 
label values lock_s label_lock_s
label define label_lock_eap -2 "{Item not applicable}" 
label define label_lock_eap 0 "No data", add 
label define label_lock_eap 1 "Has data", add 
label define label_lock_eap 5 "Clean", add 
label define label_lock_eap 8 "Complete", add 
label values lock_eap label_lock_eap
label define label_ftemp15 -1 "{Not reported}" 
label define label_ftemp15 -2 "{Item not applicable}", add 
label define label_ftemp15 0 "No", add 
label define label_ftemp15 1 "Yes", add 
label values ftemp15 label_ftemp15
label define label_sa_excl -1 "{Not reported}" 
label define label_sa_excl -2 "{Item not applicable}", add 
label define label_sa_excl 0 "No", add 
label define label_sa_excl 1 "Yes", add 
label values sa_excl label_sa_excl
label define label_stat_sp -2 "{Item not applicable}" 
label define label_stat_sp -9 "{Not active}", add 
label define label_stat_sp 1 "Respondent", add 
label define label_stat_sp 5 "Nonresponse, not imputed", add 
label values stat_sp label_stat_sp
label define label_stat_ef -2 "{Item not applicable}" 
label define label_stat_ef -9 "{Not active}", add 
label define label_stat_ef 1 "Respondent", add 
label define label_stat_ef 2 "Partial respondent, imputed", add 
label define label_stat_ef 4 "Nonrespondent, imputed", add 
label define label_stat_ef 5 "Nonrespondent, not imputed", add 
label values stat_ef label_stat_ef
label define label_lock_ef -2 "{Item not applicable}" 
label define label_lock_ef 0 "Inactive (Not Registered)", add 
label define label_lock_ef 1 "Has data", add 
label define label_lock_ef 3 "Edited", add 
label define label_lock_ef 5 "Clean", add 
label define label_lock_ef 8 "Complete", add 
label values lock_ef label_lock_ef
label define label_prch_ef -2 "{Item not applicable}" 
label define label_prch_ef 1 "Parent record (combined data)", add 
label define label_prch_ef 2 "Child record (data reported with parent)", add 
label values prch_ef label_prch_ef
label define label_imp_ef -2 "{Item not applicable}" 
label define label_imp_ef 1 "Carry forward (CF) from prior year", add 
label define label_imp_ef 2 "Nearest Neighbor (NN)", add 
label define label_imp_ef 4 "Group Median (GM)", add 
label define label_imp_ef 5 "Partial Imputation", add 
label values imp_ef label_imp_ef
label define label_pta99_ef -2 "{Item not applicable}" 
label define label_pta99_ef -9 "{Not active}", add 
label define label_pta99_ef 1 "Respondent", add 
label define label_pta99_ef 2 "Partial respondent, imputed", add 
label define label_pta99_ef 4 "Nonrespondent, imputed", add 
label define label_pta99_ef 5 "Nonrespondent, not imputed", add 
label values pta99_ef label_pta99_ef
label define label_ptb_ef -2 "{Item not applicable}" 
label define label_ptb_ef -9 "{Not active}", add 
label define label_ptb_ef 1 "Respondent", add 
label define label_ptb_ef 5 "Nonrespondent, not imputed", add 
label values ptb_ef label_ptb_ef
label define label_ptc_ef -2 "{Item not applicable}" 
label define label_ptc_ef -9 "{Not active}", add 
label define label_ptc_ef 1 "Respondent", add 
label define label_ptc_ef 5 "Nonrespondent, not imputed", add 
label values ptc_ef label_ptc_ef
label define label_pte_ef -2 "{Item not applicable}" 
label define label_pte_ef -9 "{Form not mailed}", add 
label define label_pte_ef 1 "Respondent", add 
label define label_pte_ef 5 "Nonrespondent, not imputed", add 
label values pte_ef label_pte_ef
label define label_ptdiaef -2 "{Item not applicable}" 
label define label_ptdiaef -9 "{Form not mailed}", add 
label define label_ptdiaef 1 "Respondent", add 
label define label_ptdiaef 5 "Nonrespondent, not imputed", add 
label values ptdiaef label_ptdiaef
label define label_ptdfyef -2 "{Item not applicable}" 
label define label_ptdfyef -9 "{Form not mailed}", add 
label define label_ptdfyef 1 "Respondent", add 
label define label_ptdfyef 5 "Nonrespondent, not imputed", add 
label values ptdfyef label_ptdfyef
label define label_fyrpyear -1 "{Not reported}" 
label define label_fyrpyear -2 "{Item not applicable}", add 
label define label_fyrpyear 1 "July 1, 2000 through June 30, 2001", add 
label define label_fyrpyear 2 "September 1,2000 through August 31,2001", add 
label values fyrpyear label_fyrpyear
label define label_fyflag -1 "{Not reported}" 
label define label_fyflag -2 "{Item not applicable}", add 
label define label_fyflag 0 "No", add 
label define label_fyflag 1 "Yes", add 
label values fyflag label_fyflag
label define label_stat_f -2 "{Item not applicable}" 
label define label_stat_f -9 "{Not active}", add 
label define label_stat_f 1 "Respondent", add 
label define label_stat_f 2 "Partial responsdent, imputed", add 
label define label_stat_f 3 "Nonresponsedent, not imputed", add 
label define label_stat_f 4 "Nonrespondent, imputed", add 
label define label_stat_f 5 "Nonrespondent, not imputed", add 
label values stat_f label_stat_f
label define label_lock_f -2 "{Item not applicable}" 
label define label_lock_f 0 "Inactive (Not Registered)", add 
label define label_lock_f 1 "Has data", add 
label define label_lock_f 3 "Edited", add 
label define label_lock_f 5 "Clean", add 
label define label_lock_f 7 "Locked", add 
label define label_lock_f 8 "Complete", add 
label values lock_f label_lock_f
label define label_prch_f -2 "{Item not applicable}" 
label define label_prch_f 1 "Parent record (combined data)", add 
label define label_prch_f 2 "Child record (data reported with parent)", add 
label define label_prch_f 3 "Child with data", add 
label define label_prch_f 4 "Child inst all data reported w non-posts", add 
label define label_prch_f 5 "Child inst w data some data reported w n", add 
label values prch_f label_prch_f
label define label_imp_f -2 "{Item not applicable}" 
label define label_imp_f 1 "Carry forward (CF) from prior year", add 
label define label_imp_f 2 "Nearest Neighbor (NN-CNF)", add 
label define label_imp_f 3 "Nearest Neighbor (NN-FTE)", add 
label define label_imp_f 4 "Group Median (GM)", add 
label values imp_f label_imp_f
label define label_form_f -2 "{Item not applicable}" 
label define label_form_f 1 "GASB form for public institutions", add 
label define label_form_f 2 "FASB form for private not-for-profit ins", add 
label define label_form_f 3 "Finance form for private for-profit inst", add 
label values form_f label_form_f
/*
label define label_fybeg -1 "{Not reported}" 
label define label_fybeg -2 "{Item not applicable}", add 
label define label_fybeg Alpha "{Alpha}", add 
label values fybeg label_fybeg
label define label_fyend -1 "{Not reported}" 
label define label_fyend -2 "{Item not applicable}", add 
label define label_fyend Alpha "{Alpha}", add 
label values fyend label_fyend
*/
label define label_gpfs -1 "{Not reported}" 
label define label_gpfs -2 "{Item not applicable}", add 
label define label_gpfs 1 "Yes", add 
label define label_gpfs 2 "No", add 
label values gpfs label_gpfs
label define label_f1gasbcr -1 "{Not reported}" 
label define label_f1gasbcr -2 "{Item not applicable}", add 
label define label_f1gasbcr 1 "AICPA College and University Audit Guide", add 
label define label_f1gasbcr 2 "GASB Governmental Model", add 
label values f1gasbcr label_f1gasbcr
label define label_f1gasbal -1 "{Not reported}" 
label define label_f1gasbal -2 "{Item not applicable}", add 
label define label_f1gasbal 1 "Business Type Activities", add 
label define label_f1gasbal 2 "Governmental Activities", add 
label define label_f1gasbal 3 "Governmental Activities with Business-Ty", add 
label values f1gasbal label_f1gasbal
label define label_stat_sfa -2 "{Item not applicable}" 
label define label_stat_sfa -9 "{Not active}", add 
label define label_stat_sfa 1 "Respondent", add 
label define label_stat_sfa 3 "Nonrespondent", add 
label define label_stat_sfa 5 "Nonresponse, not imputed", add 
label values stat_sfa label_stat_sfa
label define label_lock_sfa -2 "{Item not applicable}" 
label define label_lock_sfa 0 "Inactive (Not Registered)", add 
label define label_lock_sfa 1 "Has data", add 
label define label_lock_sfa 3 "Edited", add 
label define label_lock_sfa 5 "Clean", add 
label define label_lock_sfa 8 "Complete", add 
label values lock_sfa label_lock_sfa
label define label_prch_sfa -2 "{Item not applicable}" 
label define label_prch_sfa 1 "Parent record (combined data)", add 
label define label_prch_sfa 2 "Child record (data reported with parent)", add 
label values prch_sfa label_prch_sfa
label define label_stat_gr -2 "not applicable" 
label define label_stat_gr -9 "not active", add 
label define label_stat_gr 1 "Respondent", add 
label define label_stat_gr 5 "Nonrespondent", add 
label values stat_gr label_stat_gr
label define label_lock_gr -2 "Not applicable" 
label define label_lock_gr 0 "No data", add 
label define label_lock_gr 1 "Has data", add 
label define label_lock_gr 3 "Edited", add 
label define label_lock_gr 8 "Complete", add 
label values lock_gr label_lock_gr
label define label_prch_gr -2 "not applicable" 
label define label_prch_gr 1 "Parent institution - included data from branch campuses (child)", add 
label define label_prch_gr 2 "Child instittution - all data reported with parent", add 
label values prch_gr label_prch_gr
label define label_cohrtstu 1 "Yes, has full-time, first-time undergraduates and data is available" 
label define label_cohrtstu 2 "Yes, has full-time, first-time undergraduates, but data is not available", add 
label define label_cohrtstu 3 "No, did not enroll full-time first-time undergraduate students", add 
label define label_cohrtstu 4 "No, did not offer programs below the baccalaureate level", add 
label values cohrtstu label_cohrtstu
/*
label define label_pyaid 0 "No" 
label define label_pyaid 1 "Yes", add 
label define label_pyaid b "{Institution left item blank}", add 
label values pyaid label_pyaid
label define label_cohrtaid 0 "No" 
label define label_cohrtaid 1 "Yes", add 
label define label_cohrtaid b "{Institution left item blank}", add 
label values cohrtaid label_cohrtaid
label define label_sport1 0 "{implied no}" 
label define label_sport1 1 "Yes", add 
label define label_sport1 b "{Institution left item blank}", add 
label values sport1 label_sport1
label define label_sport2 0 "{implied no}" 
label define label_sport2 1 "Yes", add 
label define label_sport2 b "{Institution left item blank}", add 
label values sport2 label_sport2
label define label_sport3 0 "{implied no}" 
label define label_sport3 1 "Yes", add 
label define label_sport3 2 "{Institution left item blank}", add 
label values sport3 label_sport3
label define label_sport4 0 "{implied no}" 
label define label_sport4 1 "Yes", add 
label define label_sport4 b "{Institution left item blank}", add 
label values sport4 label_sport4
label define label_sport5 0 "{implied no}" 
label define label_sport5 1 "Yes", add 
label define label_sport5 b "{Institution left item blank}", add 
label values sport5 label_sport5
*/
label define label_transver -2 "{Institution left item blank}" 
label define label_transver 1 "Yes,  has information on students who transfer out.", add 
label define label_transver 2 "Yes, but  does not have any information on students who transfer out", add 
label define label_transver 3 "No", add 
label values transver label_transver
label define label_longpgm -2 "not applicable" 
label define label_longpgm 1 "Yes", add 
label define label_longpgm 2 "No", add 
label values longpgm label_longpgm
label define label_ocrmsi -1 "{Enrollment data not reported}" 
label define label_ocrmsi -2 "{Not applicable, institution is not in-scope of MSI calculation}", add 
label define label_ocrmsi 0 "No", add 
label define label_ocrmsi 1 "Yes, Minority serving (MSI)", add 
label values ocrmsi label_ocrmsi
label define label_ocrhsi -1 "{Enrollment data not reported}" 
label define label_ocrhsi -2 "{Not applicable, institution is not in-scope of HSI calculation}", add 
label define label_ocrhsi 0 "No", add 
label define label_ocrhsi 1 "Yes, Hispanic serving (HSI)", add 
label values ocrhsi label_ocrhsi
tab stabbr
tab fips
tab obereg
tab opeflag
tab sector
tab iclevel
tab control
tab affil
tab hloffer
tab ugoffer
tab groffer
tab fpoffer
tab hdegoffr
tab deggrant
tab hbcu
tab hospital
tab medical
tab tribal
tab carnegie
tab locale
tab openpubl
tab act
tab newid
tab deathyr
tab cyactive
tab pseflag
tab pset4flg
tab stat_fa
tab lock_fa
tab stat_ic
tab stat_c
tab prch_c
tab imp_c
tab dmajor
tab stat_wi
tab stat_sa
tab prch_sa
tab imp_sa
tab stat_s
tab prch_s
tab imp_s
tab stat_eap
tab prch_eap
tab imp_eap
tab lock_sa
tab lock_s
tab lock_eap
tab ftemp15
tab sa_excl
tab stat_sp
tab stat_ef
tab lock_ef
tab prch_ef
tab imp_ef
tab pta99_ef
tab ptb_ef
tab ptc_ef
tab pte_ef
tab ptdiaef
tab ptdfyef
tab fyrpyear
tab fyflag
tab stat_f
tab lock_f
tab prch_f
tab imp_f
tab form_f
tab fybeg
tab fyend
tab gpfs
tab f1gasbcr
tab f1gasbal
tab stat_sfa
tab lock_sfa
tab prch_sfa
tab imp_sfa
tab stat_gr
tab lock_gr
tab prch_gr
tab cohrtstu
tab cohrtyr1
tab pyaid
tab cohrtaid
tab sport1
tab sport2
tab sport3
tab sport4
tab sport5
tab transver
tab longpgm
tab ocrmsi
tab ocrhsi
summarize pctmin1
summarize pctmin2
summarize pctmin3
summarize pctmin4
summarize idx_c
summarize idx_sa
summarize idx_s
summarize idx_eap
summarize idx_ef
summarize idx_f
summarize idx_sfa
summarize idx_gr
summarize cindon
summarize cinson
summarize cotson
summarize cindoff
summarize cinsoff
summarize cotsoff
summarize cindfam
summarize cinsfam
summarize cotsfam
summarize fte
save dct_fa2001hd

