* Created: 6/12/2004 10:16:59 PM
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
insheet using "../Raw Data/fa2000hd_data_stata.csv", comma clear
label data "dct_fa2000hd"
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
label variable carnegie "Carnegie classification code"
label variable locale "Degree of Urbanization"
label variable openpubl "Institution open to the general public"
label variable act "Status of institution"
label variable newid "UNITID for merged schools"
label variable deathyr "Year institution was deleted from IPEDS"
label variable closedat "Date institution closed"
label variable cyactive "Institution is active in current year"
label variable stat_fa "Response status of Fall data collection"
label variable pseflag "Postsecondary institution indicator"
label variable pset4flg "Postsecondary and Title IV institution indicator"
label variable lock_fa "Final Lock/Edit status of the institution when collection closed"
label variable date_fa "Date last edited or imputed"
label variable stat_ic "Response status of Fall data collection  - Institutional characteristics"
label variable stat_c "Response status of the institution Fall Collection Completions component"
label variable prch_c "Parent/child indicator for completions"
label variable idx_c "UNITID of parent institution reporting Completions"
label variable imp_c "Imputation status of the institution completions"
label variable lock_sp "Migration status of Spring data collection"
label variable stat_sp "Response status of Spring data collection"
label variable stat_ef "Response status of institution Fall enrollment"
label variable prch_ef "Parent/child indicator for Fall enrollment"
label variable idx_ef "UNITID of parent institution reporting Enrollment"
label variable imp_ef "Imputation method Fall enrollment"
label variable pta99_ef "Status enrollment by race/ethnicity (99.0000 CIP)"
label variable ptacipef "Status enrollment by race/ethnicity (Major field)"
label variable ptb_ef "Status enrollment summary by age"
label variable ptc_ef "Status residence of first-time first-year students"
label variable ptd_ef "Status full year enrollment and instructional activity"
label variable form_f "Finance Form Type"
label variable stat_f "Response status (all finance)"
label variable prch_f "Parent/child indicator (all finance)"
label variable idx_f "UNITID of parent institution reporting Finance"
label variable imp_f "Imputation method (all finance)"
label variable fybeg "Beginning date of fiscal year covered (all finance)"
label variable fyend "End date of fiscal year covered  (all finance)"
label variable gpfs "Clean Opinion GPFS from auditor (all finance)"
label variable f1gasbcr "F1 GASB current accounting model"
label variable f1gasbal "F1 GASB alternative accounting model"
label variable stat_sfa "Response status of the institution SFA"
label variable prch_sfa "Parent/child indicator SFA"
label variable idx_sfa "UNITID of parent institution reporting Student Financial Aid"
label variable stat_gr "Response status of the institution (GRS)"
label variable prch_gr "Parent/child indicator (GRS)"
label variable idx_gr "UNITID of parent institution reporting Graduation Rates"
label variable cohrtstu "Enrolled any full-time first-time students"
label variable cohrtyr1 "First cohort year for which data are available"
label variable pyaid "Institution offered  athletic aid 1999-2000"
label variable cohrtaid "Institution offered  athletic aid in cohort year"
label variable sport1 "Athletic aid for football  in cohort year"
label variable sport2 "Athletic aid for basketball  in cohort year"
label variable sport3 "Athletic aid for baseball  in cohort year"
label variable sport4 "Athletic aid  cross-country and  track  in cohort year"
label variable sport5 "Athletic aid  all other sports combined in cohort year"
label variable transver "Institution has transfer mission"
label variable longpgm "Institution has 5-year or 3-year programs"
label variable cohrtmt "cohrtmt"
label variable cindon "Total price for in-district students living on campus  2000-2001"
label variable cinson "Total price for in-state students living on campus 2000-2001"
label variable cotson "Total price out-of-state students living on campus 2000-2001"
label variable cindoff "Total price for in-district students living off-campus (not with family)  2000-2001"
label variable cinsoff "Total price for in-state students living off campus (not with family)  2000-2001"
label variable cotsoff "Total price for out-of-state students living off campus (not with family)  2000-2001"
label variable cindfam "Total price for in-district students living off campus (with family)  2000-2001"
label variable cinsfam "Total price for in-state students living off campus (with family)  2000-2001"
label variable cotsfam "Total price for out-of-state students living off campus (with family)  2000-2001"
label variable fte "Full-time equivalent enrollment"
label variable ocrhsi "Hispanic Serving Institution"
label variable ocrmsi "Minority Serving Institution"
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
label define label_obereg 5 "Southeast AL AR FL GA KY LA MS NC SC TN VA WV", add 
label define label_obereg 6 "Southwest AZ NM OK TX", add 
label define label_obereg 7 "Rocky Mountains CO ID MT UT WY", add 
label define label_obereg 8 "Far West AK CA HI NV OR WA", add 
label define label_obereg 9 "Outlying areas AS FM GU MH MP PR PW VI", add 
label values obereg label_obereg
/*
label define label_chfnm -1 "{Not reported}" 
label define label_chfnm Alpha "{Alpha}", add 
label values chfnm label_chfnm
label define label_chftitle -1 "{Not reported}" 
label define label_chftitle Alpha "{Alpha}", add 
label values chftitle label_chftitle
label define label_gentele -1 "{Not reported}" 
label define label_gentele Alpha "{Alpha}", add 
label values gentele label_gentele
label define label_fintele -1 "{Not reported}" 
label define label_fintele Alpha "{Alpha}", add 
label values fintele label_fintele
label define label_admtele -1 "{Not reported}" 
label define label_admtele Alpha "{Alpha}", add 
label values admtele label_admtele
*/
label define label_opeflag 1 "Participates in Title IV federal financial aid programs" 
label define label_opeflag 2 "Branch campus of a main campus that participates  in Title IV", add 
label define label_opeflag 3 "Deferment only - limited participation", add 
label define label_opeflag 4 "New participants (became eligible during the fall collection period)", add 
label define label_opeflag 5 "Not currently participating in Title IV, has an OPE ID number", add 
label define label_opeflag 6 "Not currently participating in Title IV, does not have OPE ID number", add 
label values opeflag label_opeflag
label define label_sector 0 "Administrative unit only" 
label define label_sector 1 "Public, 4-year or above", add 
label define label_sector 2 "Private nonprofit, 4-year or above", add 
label define label_sector 3 "Private for-profit, 4-year or above", add 
label define label_sector 4 "Public, 2-year", add 
label define label_sector 5 "Private nonprofit, 2-year", add 
label define label_sector 6 "Private for-profit, 2-year", add 
label define label_sector 7 "Public, less-than-2-year", add 
label define label_sector 8 "Private nonprofit, less-than-2-year", add 
label define label_sector 9 "Private for-profit, less-than-2-year", add 
label values sector label_sector
label define label_iclevel 1 "Four or more years" 
label define label_iclevel 2 "At least 2 but less than 4 years", add 
label define label_iclevel 3 "Less than 2 years (below associate)", add 
label values iclevel label_iclevel
label define label_control 1 "Public" 
label define label_control 2 "Private, nonprofit", add 
label define label_control 3 "Private, for-profit", add 
label values control label_control
label define label_affil 1 "Public" 
label define label_affil 2 "Private, for-profit", add 
label define label_affil 3 "Private, nonprofit, no religious affiliation", add 
label define label_affil 4 "Private, nonprofit", add 
label values affil label_affil
label define label_hloffer -2 "{Not applicable, first-professional only}" 
label define label_hloffer -3 "{Not available}", add 
label define label_hloffer 0 "Other", add 
label define label_hloffer 1 "Award of less than one academic year", add 
label define label_hloffer 2 "At least 1, but less than 2 academic yrs", add 
label define label_hloffer 3 "Associates degree", add 
label define label_hloffer 4 "At least 2, but less than 4 academic yrs", add 
label define label_hloffer 5 "Bachelors degree", add 
label define label_hloffer 6 "Postbaccalaureate certificate", add 
label define label_hloffer 7 "Masters degree", add 
label define label_hloffer 8 "Post-masters certificate", add 
label define label_hloffer 9 "Doctors degree", add 
label values hloffer label_hloffer
label define label_ugoffer -3 "{Not available}" 
label define label_ugoffer 1 "Undergraduate degree or certificate offering", add 
label define label_ugoffer 2 "No undergraduate offering", add 
label values ugoffer label_ugoffer
label define label_groffer -3 "{Not available}" 
label define label_groffer 1 "Graduate degree or certificate offering", add 
label define label_groffer 2 "No graduate offering", add 
label values groffer label_groffer
label define label_fpoffer -3 "{Not available}" 
label define label_fpoffer 1 "First-professional degree/certificate", add 
label define label_fpoffer 2 "No first-professional offering", add 
label values fpoffer label_fpoffer
label define label_hdegoffr 0 "Non-degree granting" 
label define label_hdegoffr 1 "First-professional only", add 
label define label_hdegoffr 10 "Doctoral", add 
label define label_hdegoffr 11 "Doctoral and first-professional", add 
label define label_hdegoffr 20 "Masters", add 
label define label_hdegoffr 21 "Masters and first-professional", add 
label define label_hdegoffr 30 "Bachelors", add 
label define label_hdegoffr 31 "Bachelors and first-professional", add 
label define label_hdegoffr 40 "Associates", add 
label values hdegoffr label_hdegoffr
label define label_deggrant 1 "Degree-granting" 
label define label_deggrant 2 "Nondegree-granting, primarily postsecondary", add 
label define label_deggrant 3 "Nondegree-granting, not  primarily postsecondary", add 
label define label_deggrant 4 "Not an educational entity", add 
label values deggrant label_deggrant
label define label_hbcu 1 "Yes" 
label define label_hbcu 2 "No", add 
label values hbcu label_hbcu
label define label_hospital 1 "Yes" 
label define label_hospital 2 "No", add 
label values hospital label_hospital
label define label_medical 1 "Yes" 
label define label_medical 2 "No", add 
label values medical label_medical
label define label_tribal 1 "Yes" 
label define label_tribal 2 "No", add 
label values tribal label_tribal
label define label_carnegie -3 "{Item not available}" 
label define label_carnegie 15 "Doctoral/Research Universities--Extensive", add 
label define label_carnegie 16 "Doctoral/Research Universities--Intensive", add 
label define label_carnegie 21 "Masters Colleges and Universities I", add 
label define label_carnegie 22 "Masters Colleges and Universities II", add 
label define label_carnegie 31 "Baccalaureate Colleges--Liberal Arts", add 
label define label_carnegie 32 "Baccalaureate Colleges--General", add 
label define label_carnegie 33 "Baccalaureate/Associates Colleges", add 
label define label_carnegie 40 "Associates Colleges", add 
label define label_carnegie 51 "Theological seminaries and other specialized faith-related institutions", add 
label define label_carnegie 52 "Medical schools and medical centers", add 
label define label_carnegie 53 "Other separate health profession schools", add 
label define label_carnegie 54 "Schools of engineering and technology", add 
label define label_carnegie 55 "Schools of business and management", add 
label define label_carnegie 56 "Schools of art, music, and design", add 
label define label_carnegie 57 "Schools of law", add 
label define label_carnegie 58 "Teachers colleges", add 
label define label_carnegie 59 "Other specialized institutions", add 
label define label_carnegie 60 "Tribal colleges", add 
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
label define label_openpubl 1 "Insititution is open to the public" 
label define label_openpubl 2 "Insititution is not open to the public", add 
label values openpubl label_openpubl
/*
label define label_act A "Active - institution active and not an add" 
label define label_act M "Death with data - closed in current yr", add 
label define label_act N "New - added during the current year", add 
label define label_act R "Restore - restored to the current universe", add 
label define label_act S "Split - split into more than one institution", add 
label define label_act Z "Universe III - out-of-scope", add 
label values act label_act
label define label_closedat -2 "{Item not applicable}" 
label define label_closedat Alpha "{Alpha}", add 
label values closedat label_closedat
*/
label define label_stat_fa -2 "{Item not applicable}" 
label define label_stat_fa 1 "Response", add 
label define label_stat_fa 3 "Nonresponse, not imputed", add 
label values stat_fa label_stat_fa
label define label_pseflag 1 "Active postsecondary institution" 
label define label_pseflag 2 "not primarily postsec or open to public", add 
label define label_pseflag 3 "not active", add 
label values pseflag label_pseflag
label define label_pset4flg 1 "Title IV postsecondary institution" 
label define label_pset4flg 2 "Non-Title IV postsecondary institution", add 
label define label_pset4flg 3 "Title IV NOT primarily postsecondary institution", add 
label define label_pset4flg 4 "Non-Title IV NOT primarily postsecondary institution", add 
label define label_pset4flg 5 "Title IV postsecondary institution that is NOT open to the public", add 
label define label_pset4flg 6 "Non-Title IV postsecondary institution that is NOT open to the public", add 
label define label_pset4flg 9 "Institution is not active in current universe", add 
label values pset4flg label_pset4flg
label define label_lock_fa 0 "Inactive, not registered" 
label define label_lock_fa 10 "User level, inactive, registered", add 
label define label_lock_fa 11 "User level active, partial", add 
label define label_lock_fa 141 "Closed, or out-of-scope", add 
label define label_lock_fa 151 "Refused", add 
label define label_lock_fa 20 "Coordinator level inactive", add 
label define label_lock_fa 21 "Coordinator level active  partial", add 
label define label_lock_fa 71 "Complete", add 
label define label_lock_fa 81 "Migrated", add 
label values lock_fa label_lock_fa
/*
label define label_date_fa -2 "{Item not applicable}" 
label define label_date_fa Alpha "{Alpha}", add 
label values date_fa label_date_fa
*/
label define label_stat_ic -2 "{Item not applicable}" 
label define label_stat_ic 1 "Respondent", add 
label define label_stat_ic 3 "Nonrespondent, not imputed", add 
label values stat_ic label_stat_ic
label define label_stat_c -2 "Not in imputation scope" 
label define label_stat_c 1 "Respondent", add 
label define label_stat_c 2 "Partial response", add 
label define label_stat_c 3 "Nonrespondent, not imputed", add 
label define label_stat_c 4 "Total nonrespondent, data imputed", add 
label values stat_c label_stat_c
label define label_prch_c -2 "{Item not applicable}" 
label define label_prch_c -9 "{Form not mailed}", add 
label define label_prch_c 1 "Parent data record", add 
label define label_prch_c 2 "Child data record, no data", add 
label values prch_c label_prch_c
label define label_imp_c -2 "{Item not applicable}" 
label define label_imp_c 1 "Carry forward (CF)", add 
label define label_imp_c 2 "Nearest neighbor (NN)", add 
label define label_imp_c 3 "Group median (GM)", add 
label define label_imp_c 4 "Both CF and NN", add 
label define label_imp_c 6 "Both NM and GM", add 
label values imp_c label_imp_c
label define label_stat_sp 1 "Respondent" 
label define label_stat_sp 3 "Nonrespondent", add 
label values stat_sp label_stat_sp
label define label_form_f 1 "Finance form for public institutions" 
label define label_form_f 2 "Finance form for private not-for-profit  institutions", add 
label define label_form_f 3 "Finance form for private for-profit  institutions", add 
label values form_f label_form_f
label define label_gpfs -1 "Dont know" 
label define label_gpfs 1 "Yes", add 
label define label_gpfs 2 "No", add 
label values gpfs label_gpfs
label define label_f1gasbcr 1 "AICPA College and University Audit Guide Model" 
label define label_f1gasbcr 2 "GASB Governmental Model", add 
label values f1gasbcr label_f1gasbcr
label define label_f1gasbal -1 "Dont know or undecided at this time" 
label define label_f1gasbal 1 "Business Type Activities", add 
label define label_f1gasbal 2 "Governmental Activities", add 
label define label_f1gasbal 3 "Governmental Activities with Business-Type Activities", add 
label values f1gasbal label_f1gasbal
label define label_stat_gr -2 "not applicable" 
label define label_stat_gr 1 "Respondent", add 
label define label_stat_gr 3 "Nonrespondent", add 
label values stat_gr label_stat_gr
label define label_prch_gr -2 "not applicable" 
label define label_prch_gr 1 "Parent institution - included data from branch campuses (child)", add 
label define label_prch_gr 2 "Child instittution - all data reported with parent", add 
label values prch_gr label_prch_gr
label define label_cohrtstu 1 "Yes, has full-time, first-time undergraduates and data is available" 
label define label_cohrtstu 2 "Yes, has full-time, first-time undergraduates, but data is not available", add 
label define label_cohrtstu 3 "No, did not enroll full-time first-time undergraduate students", add 
label define label_cohrtstu 4 "No, did not offer programs below the baccalaureate level", add 
label values cohrtstu label_cohrtstu
label define label_cohrtyr1 -2 "not applicable" 
label define label_cohrtyr1 1995 "1995", add 
label define label_cohrtyr1 1996 "1996", add 
label define label_cohrtyr1 1997 "1997", add 
label define label_cohrtyr1 1999 "1999", add 
label define label_cohrtyr1 2003 "2003", add 
label values cohrtyr1 label_cohrtyr1
label define label_pyaid -2 "not applicable" 
label define label_pyaid 1 "Yes", add 
label define label_pyaid 2 "No", add 
label values pyaid label_pyaid
label define label_cohrtaid -2 "not applicable" 
label define label_cohrtaid 1 "Yes", add 
label define label_cohrtaid 2 "No", add 
label values cohrtaid label_cohrtaid
label define label_sport1 -2 "not applicable" 
label define label_sport1 0 "No", add 
label define label_sport1 1 "Yes", add 
label define label_sport1 2 "implied no", add 
label values sport1 label_sport1
label define label_sport2 -2 "not applicable" 
label define label_sport2 0 "No", add 
label define label_sport2 1 "Yes", add 
label define label_sport2 2 "implied no", add 
label values sport2 label_sport2
label define label_sport3 -2 "not applicable" 
label define label_sport3 0 "No", add 
label define label_sport3 1 "Yes", add 
label define label_sport3 2 "implied no", add 
label values sport3 label_sport3
label define label_sport4 -2 "not applicable" 
label define label_sport4 0 "No", add 
label define label_sport4 1 "Yes", add 
label define label_sport4 2 "implied no", add 
label values sport4 label_sport4
label define label_sport5 -2 "not applicable" 
label define label_sport5 0 "No", add 
label define label_sport5 1 "Yes", add 
label define label_sport5 2 "implied no", add 
label values sport5 label_sport5
label define label_transver -2 "Not applicable" 
label define label_transver 1 "Yes,  has information on students who transfer out.", add 
label define label_transver 2 "Yes, but  does not have any information on students who transfer out", add 
label define label_transver 3 "No", add 
label values transver label_transver
label define label_longpgm -2 "not applicable" 
label define label_longpgm 1 "Yes", add 
label define label_longpgm 2 "No", add 
label values longpgm label_longpgm
label define label_ocrhsi -1 "Enrollment data not reported" 
label define label_ocrhsi -2 "Not applicable, institution is not in-scope of HSI calculation.", add 
label define label_ocrhsi 0 "No", add 
label define label_ocrhsi 1 "Yes, Hispanic serving", add 
label values ocrhsi label_ocrhsi
label define label_ocrmsi -1 "Enrollment data not reported" 
label define label_ocrmsi -2 "Not applicable, institution is not in-scope of MSI calculation", add 
label define label_ocrmsi 0 "No", add 
label define label_ocrmsi 1 "Yes, Minority serving", add 
label values ocrmsi label_ocrmsi
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
tab stat_fa
tab pseflag
tab pset4flg
tab lock_fa
tab stat_ic
tab stat_c
tab prch_c
tab imp_c
tab lock_sp
tab stat_sp
tab stat_ef
tab prch_ef
tab imp_ef
tab pta99_ef
tab ptacipef
tab ptb_ef
tab ptc_ef
tab ptd_ef
tab form_f
tab stat_f
tab prch_f
tab imp_f
tab fybeg
tab fyend
tab gpfs
tab f1gasbcr
tab f1gasbal
tab stat_sfa
tab prch_sfa
tab stat_gr
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
tab ocrhsi
tab ocrmsi
summarize pctmin1
summarize pctmin2
summarize pctmin3
summarize pctmin4
summarize idx_c
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
save dct_fa2000hd

