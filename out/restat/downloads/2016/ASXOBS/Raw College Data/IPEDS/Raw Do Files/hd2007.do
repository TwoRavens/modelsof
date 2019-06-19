* Created: 9/24/2008 1:10:26 PM
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
insheet using "../Raw Data/hd2007_data_stata.csv", comma clear
label data "dct_hd2007"
label variable unitid "unitid"
label variable addr "Street address or post office box"
label variable city "City location of institution"
label variable stabbr "State abbreviation"
label variable zip "ZIP code"
label variable fips "FIPS state code"
label variable obereg "Geographic region"
label variable chfnm "Name of chief administrator"
label variable chftitle "Title of chief administrator"
label variable gentele "General information telephone number"
label variable ein "Employer Identification Number"
label variable opeid "Office of Postsecondary Education (OPE) ID Number"
label variable opeflag "OPE Title IV eligibility indicator code"
label variable webaddr "Institution^s internet website address"
label variable adminurl "Admissions office web address"
label variable faidurl "Financial aid office web address"
label variable applurl "Online application web addres"
label variable sector "Sector of institution"
label variable iclevel "Level of institution"
label variable control "Control of institution"
label variable hloffer "Highest level of offering"
label variable ugoffer "Undergraduate offering"
label variable groffer "Graduate offering"
label variable fpoffer "First-professional offering"
label variable hdegoffr "Highest degree offered"
label variable deggrant "Degree-granting status"
label variable hbcu "Historically Black College or University"
label variable hospital "Institution has hospital"
label variable medical "Institution grants a medical degree"
label variable tribal "Tribal college"
label variable locale "Degree of urbanization (Urban-centric locale)"
label variable openpubl "Institution open to the general public"
label variable act "Status of institution"
label variable newid "UNITID for merged schools"
label variable deathyr "Year institution was deleted from IPEDS"
label variable closedat "Date institution closed"
label variable cyactive "Institution is active in current year"
label variable postsec "Primarily postsecondary indicator"
label variable pseflag "Postsecondary institution indicator"
label variable pset4flg "Postsecondary and Title IV institution indicator"
label variable rptmth "Reporting method (academic year or program)"
label variable ialias "Institution name alias"
label variable instcat "Institutional category"
label variable ccbasic "Carnegie Classification 2005"
label variable ccipug "Carnegie Classification 2005"
label variable ccipgrad "Carnegie Classification 2005"
label variable ccugprof "Carnegie Classification 2005"
label variable ccenrprf "Carnegie Classification 2005"
label variable ccsizset "Carnegie Classification 2005"
label variable carnegie "Carnegie Classification 2000"
label variable tenursys "Does institution have a tenure system"
label variable landgrnt "Land Grant Institution"
label variable instsize "Institution size category"
label variable cbsa "Core Based Statistical Area (CBSA)"
label variable cbsatype "CBSA Type Metropolitan or Micropolitan"
label variable csa "Combined Statistical Area (CSA)"
label variable necta "New England City and Town Area (NECTA)"
label variable dfrcgid "Data Feedback Report comparison group category"
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
label define label_opeflag 1 "Participates in Title IV federal financial aid programs" 
label define label_opeflag 2 "Branch campus of a main campus that participates in Title IV", add 
label define label_opeflag 3 "Deferment only - limited participation", add 
label define label_opeflag 4 "New participants (became eligible during winter collection)", add 
label define label_opeflag 5 "Not currently participating in Title IV, has an OPE ID number", add 
label define label_opeflag 6 "Not currently participating in Title IV, does not have OPE ID number", add 
label define label_opeflag 7 "Stopped participating during the survey year", add 
label define label_opeflag 8 "New participants (became eligible during spring collection)", add 
label values opeflag label_opeflag
label define label_sector 0 "Administrative Unit" 
label define label_sector 1 "Public, 4-year or above", add 
label define label_sector 2 "Private not-for-profit, 4-year or above", add 
label define label_sector 3 "Private for-profit, 4-year or above", add 
label define label_sector 4 "Public, 2-year", add 
label define label_sector 5 "Private not-for-profit, 2-year", add 
label define label_sector 6 "Private for-profit, 2-year", add 
label define label_sector 7 "Public, less-than 2-year", add 
label define label_sector 8 "Private not-for-profit, less-than 2-year", add 
label define label_sector 9 "Private for-profit, less-than 2-year", add 
label define label_sector 99 "Sector unknown (not active)", add 
label values sector label_sector
label define label_iclevel -3 "{Not available}" 
label define label_iclevel 1 "Four or more years", add 
label define label_iclevel 2 "At least 2 but less than 4 years", add 
label define label_iclevel 3 "Less than 2 years (below associate)", add 
label values iclevel label_iclevel
label define label_control -3 "{Not available}" 
label define label_control 1 "Public", add 
label define label_control 2 "Private not-for-profit", add 
label define label_control 3 "Private for-profit", add 
label values control label_control
label define label_hloffer -2 "Not applicable, first-professional only" 
label define label_hloffer -3 "{Not available}", add 
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
label define label_deggrant 2 "Nondegree-granting, primarily postsecondary", add 
label values deggrant label_deggrant
label define label_hbcu 1 "Yes" 
label define label_hbcu 2 "No", add 
label values hbcu label_hbcu
label define label_hospital -1 "Not reported" 
label define label_hospital -2 "Not applicable", add 
label define label_hospital 1 "Yes", add 
label define label_hospital 2 "No", add 
label values hospital label_hospital
label define label_medical -1 "Not reported" 
label define label_medical -2 "Not applicable", add 
label define label_medical 1 "Yes", add 
label define label_medical 2 "No", add 
label values medical label_medical
label define label_tribal 1 "Yes" 
label define label_tribal 2 "No", add 
label values tribal label_tribal
label define label_locale -3 "{Not available}" 
label define label_locale 11 "City Large", add 
label define label_locale 12 "City Midsize", add 
label define label_locale 13 "City Small", add 
label define label_locale 21 "Suburb Large", add 
label define label_locale 22 "Suburb Midsize", add 
label define label_locale 23 "Suburb Small", add 
label define label_locale 31 "Town Fringe", add 
label define label_locale 32 "Town Distant", add 
label define label_locale 33 "Town Remote", add 
label define label_locale 41 "Rural Fringe", add 
label define label_locale 42 "Rural Distant", add 
label define label_locale 43 "Rural Remote", add 
label values locale label_locale
label define label_openpubl 0 "Institution is not open to the public" 
label define label_openpubl 1 "Institution is open to the public", add 
label values openpubl label_openpubl
/*
label define label_act A "Active - institution active and not an add" 
label define label_act C "Combined with other institution", add 
label define label_act D "Delete out of business", add 
label define label_act I "Inactive due to hurricane related problems", add 
label define label_act M "Death with data - closed in current yr", add 
label define label_act N "New - added during the current year", add 
label define label_act P "Potential new/add institution", add 
label define label_act Q "Potential restore institution", add 
label define label_act R "Restore - restored to the current universe", add 
label define label_act W "Potential add not within scope of IPEDS", add 
label define label_act X "Potential restore not within scope of IPEDS", add 
label values act label_act
*/
label define label_deathyr -2 "Not applicable" 
label define label_deathyr 2005 "2005", add 
label define label_deathyr 2006 "2006", add 
label define label_deathyr 2007 "2007", add 
label values deathyr label_deathyr
label define label_cyactive 1 "Yes" 
label define label_cyactive 2 "No, potential add or restore", add 
label define label_cyactive 3 "No, closed, combined, or out-of-scope", add 
label values cyactive label_cyactive
label define label_postsec 1 "Primarily postsecondary institution" 
label define label_postsec 2 "Not primarily postsecondary", add 
label values postsec label_postsec
label define label_pseflag 1 "Active postsecondary institution" 
label define label_pseflag 2 "Not primarily postsecondary or open to public", add 
label define label_pseflag 3 "Not active", add 
label values pseflag label_pseflag
label define label_pset4flg 1 "Title IV postsecondary institution" 
label define label_pset4flg 2 "Non-Title IV postsecondary institution", add 
label define label_pset4flg 3 "Title IV NOT primarily postsecondary institution", add 
label define label_pset4flg 4 "Non-Title IV NOT primarily postsecondary institution", add 
label define label_pset4flg 6 "Non-Title IV postsecondary institution that is NOT open to the public", add 
label define label_pset4flg 9 "Institution is not active in current universe", add 
label values pset4flg label_pset4flg
label define label_rptmth -1 "Not reported" 
label define label_rptmth -2 "Not applicable", add 
label define label_rptmth 1 "Academic year", add 
label define label_rptmth 2 "Reports by program", add 
label values rptmth label_rptmth
label define label_instcat -1 "Not reported" 
label define label_instcat -2 "Not applicable", add 
label define label_instcat 1 "Degree-granting, graduate with no undergraduate degrees", add 
label define label_instcat 2 "Degree-granting, primarily baccalaureate or above", add 
label define label_instcat 3 "Degree-granting, not primarily baccalaureate or above", add 
label define label_instcat 4 "Degree-granting, associates and certificates ", add 
label define label_instcat 5 "Nondegree-granting, above the baccalaureate", add 
label define label_instcat 6 "Nondegree-granting, sub-baccalaureate", add 
label values instcat label_instcat
label define label_ccbasic -3 "Not applicable, not in Carnegie universe (not accredited or nondegree-granting)" 
label define label_ccbasic 0 "Not classified", add 
label define label_ccbasic 1 "Associates--Public Rural-serving Small", add 
label define label_ccbasic 10 "Associates--Private For-profit", add 
label define label_ccbasic 11 "Associates--Public 2-year colleges under 4-year universities", add 
label define label_ccbasic 12 "Associates--Public 4-year Primarily Associates", add 
label define label_ccbasic 13 "Associates--Private Not-for-profit 4-year Primarily Associates", add 
label define label_ccbasic 14 "Associates--Private For-profit 4-year Primarily Associates", add 
label define label_ccbasic 15 "Research Universities (very high research activity)", add 
label define label_ccbasic 16 "Research Universities (high research activity)", add 
label define label_ccbasic 17 "Doctoral/Research Universities", add 
label define label_ccbasic 18 "Masters Colleges and Universities (larger programs)", add 
label define label_ccbasic 19 "Masters Colleges and Universities (medium programs)", add 
label define label_ccbasic 2 "Associates--Public Rural-serving Medium", add 
label define label_ccbasic 20 "Masters Colleges and Universities (smaller programs)", add 
label define label_ccbasic 21 "Baccalaureate Colleges--Arts & Sciences", add 
label define label_ccbasic 22 "Baccalaureate Colleges--Diverse Fields", add 
label define label_ccbasic 23 "Baccalaureate/Associates Colleges", add 
label define label_ccbasic 24 "Special Focus Institutions--Theological seminaries, Bible colleges, and other faith-related institutions", add 
label define label_ccbasic 25 "Special Focus Institutions--Medical schools and medical centers", add 
label define label_ccbasic 26 "Special Focus Institutions--Other health professions schools", add 
label define label_ccbasic 27 "Special Focus Institutions--Schools of engineering", add 
label define label_ccbasic 28 "Special Focus Institutions--Other technology-related schools", add 
label define label_ccbasic 29 "Special Focus Institutions--Schools of business and management", add 
label define label_ccbasic 3 "Associates--Public Rural-serving Large", add 
label define label_ccbasic 30 "Special Focus Institutions--Schools of art, music, and design", add 
label define label_ccbasic 31 "Special Focus Institutions--Schools of law", add 
label define label_ccbasic 32 "Special Focus Institutions--Other special-focus institutions", add 
label define label_ccbasic 33 "Tribal Colleges", add 
label define label_ccbasic 4 "Associates--Public Suburban-serving Single Campus", add 
label define label_ccbasic 5 "Associates--Public Suburban-serving Multicampus", add 
label define label_ccbasic 6 "Associates--Public Urban-serving Single Campus", add 
label define label_ccbasic 7 "Associates--Public Urban-serving Multicampus", add 
label define label_ccbasic 8 "Associates--Public Special Use", add 
label define label_ccbasic 9 "Associates--Private Not-for-profit", add 
label values ccbasic label_ccbasic
label define label_ccipug -1 "Not applicable, graduate institution" 
label define label_ccipug -2 "Not applicable, special focus institution", add 
label define label_ccipug -3 "Not applicable, not in Carnegie universe (not accredited or nondegree-granting)", add 
label define label_ccipug 0 "Not classified", add 
label define label_ccipug 1 "Associates", add 
label define label_ccipug 10 "Balanced arts & sciences/professions, some graduate coexistence", add 
label define label_ccipug 11 "Balanced arts & sciences/professions, high graduate coexistence", add 
label define label_ccipug 12 "Professions plus arts & sciences, no graduate coexistence", add 
label define label_ccipug 13 "Professions plus arts & sciences, some graduate coexistence", add 
label define label_ccipug 14 "Professions plus arts & sciences, high graduate coexistence", add 
label define label_ccipug 15 "Professions focus, no graduate coexistence", add 
label define label_ccipug 16 "Professions focus, some graduate coexistence", add 
label define label_ccipug 17 "Professions focus, high graduate coexistence", add 
label define label_ccipug 2 "Associates Dominant", add 
label define label_ccipug 3 "Arts & sciences focus, no graduate coexistence", add 
label define label_ccipug 4 "Arts & sciences focus, some graduate coexistence", add 
label define label_ccipug 5 "Arts & sciences focus, high graduate coexistence", add 
label define label_ccipug 6 "Arts & sciences plus professions, no graduate coexistence", add 
label define label_ccipug 7 "Arts & sciences plus professions, some graduate coexistence", add 
label define label_ccipug 8 "Arts & sciences plus professions, high graduate coexistence", add 
label define label_ccipug 9 "Balanced arts & sciences/professions, no graduate coexistence", add 
label values ccipug label_ccipug
label define label_ccipgrad -1 "Not applicable" 
label define label_ccipgrad -2 "Not applicable, special focus institution", add 
label define label_ccipgrad -3 "Not applicable, not in Carnegie universe (not accredited or nondegree-granting)", add 
label define label_ccipgrad 0 "Not classified", add 
label define label_ccipgrad 1 "Single postbaccalaureate (education)", add 
label define label_ccipgrad 10 "Postbaccalaureate professional (business dominant)", add 
label define label_ccipgrad 11 "Postbaccalaureate professional (other dominant fields)", add 
label define label_ccipgrad 12 "Single doctoral (education)", add 
label define label_ccipgrad 13 "Single doctoral (other field)", add 
label define label_ccipgrad 14 "Comprehensive doctoral with medical/veterinary", add 
label define label_ccipgrad 15 "Comprehensive doctoral (no medical/veterinary)", add 
label define label_ccipgrad 16 "Doctoral, humanities/social sciences dominant", add 
label define label_ccipgrad 17 "STEM dominant", add 
label define label_ccipgrad 18 "Doctoral, professional dominant", add 
label define label_ccipgrad 2 "Single postbaccalaureate (business)", add 
label define label_ccipgrad 3 "Single postbaccalaureate (other field)", add 
label define label_ccipgrad 4 "Postbaccalaureate comprehensive", add 
label define label_ccipgrad 5 "Postbaccalaureate, arts & sciences dominant", add 
label define label_ccipgrad 6 "Postbaccalaureate with arts & sciences (education dominant)", add 
label define label_ccipgrad 7 "Postbaccalaureate with arts & sciences (business dominant)", add 
label define label_ccipgrad 8 "Postbaccalaureate with arts & sciences (other dominant fields)", add 
label define label_ccipgrad 9 "Postbaccalaureate professional (education dominant)", add 
label values ccipgrad label_ccipgrad
label define label_ccugprof -1 "Not applicable" 
label define label_ccugprof -2 "Not applicable, special focus institution", add 
label define label_ccugprof -3 "Not applicable, not in Carnegie universe (not accredited or nondegree-granting)", add 
label define label_ccugprof 0 "Not classified", add 
label define label_ccugprof 1 "Higher part-time two-year", add 
label define label_ccugprof 10 "Full-time four-year, selective, lower transfer-in", add 
label define label_ccugprof 11 "Full-time four-year, selective, higher transfer-in", add 
label define label_ccugprof 12 "Full-time four-year, more selective, lower transfer-in", add 
label define label_ccugprof 13 "Full-time four-year, more selective, higher transfer-in", add 
label define label_ccugprof 2 "Mixed part/full-time two-year", add 
label define label_ccugprof 3 "Medium full-time two-year", add 
label define label_ccugprof 4 "Higher full-time two-year", add 
label define label_ccugprof 5 "Higher part-time four-year", add 
label define label_ccugprof 6 "Medium full-time four-year, inclusive", add 
label define label_ccugprof 7 "Medium full-time four-year, selective, lower transfer-in", add 
label define label_ccugprof 8 "Medium full-time four-year, selective, higher transfer-in", add 
label define label_ccugprof 9 "Full-time four-year, inclusive", add 
label values ccugprof label_ccugprof
label define label_ccenrprf -3 "Not applicable, not in Carnegie universe (not accredited or nondegree-granting)" 
label define label_ccenrprf 0 "Not classified", add 
label define label_ccenrprf 1 "Exclusively undergraduate two-year", add 
label define label_ccenrprf 2 "Exclusively undergraduate four-year", add 
label define label_ccenrprf 3 "Very high undergraduate", add 
label define label_ccenrprf 4 "High undergraduate", add 
label define label_ccenrprf 5 "Majority undergraduate", add 
label define label_ccenrprf 6 "Majority graduate/professional", add 
label define label_ccenrprf 7 "Exclusively graduate/professional", add 
label values ccenrprf label_ccenrprf
label define label_ccsizset -2 "Not applicable, special focus institution" 
label define label_ccsizset -3 "Not applicable, not in Carnegie universe (not accredited or nondegree-granting)", add 
label define label_ccsizset 0 "Not classified", add 
label define label_ccsizset 1 "Very small two-year", add 
label define label_ccsizset 10 "Small four-year, primarily residential", add 
label define label_ccsizset 11 "Small four-year, highly residential", add 
label define label_ccsizset 12 "Medium four-year, primarily nonresidential", add 
label define label_ccsizset 13 "Medium four-year, primarily residential", add 
label define label_ccsizset 14 "Medium four-year, highly residential", add 
label define label_ccsizset 15 "Large four-year, primarily nonresidential", add 
label define label_ccsizset 16 "Large four-year, primarily residential", add 
label define label_ccsizset 17 "Large four-year, highly residential", add 
label define label_ccsizset 18 "Exclusively graduate/professional", add 
label define label_ccsizset 2 "Small two-year", add 
label define label_ccsizset 3 "Medium two-year", add 
label define label_ccsizset 4 "Large two-year", add 
label define label_ccsizset 5 "Very large two-year", add 
label define label_ccsizset 6 "Very small four-year, primarily nonresidential", add 
label define label_ccsizset 7 "Very small four-year, primarily residential", add 
label define label_ccsizset 8 "Very small four-year, highly residential", add 
label define label_ccsizset 9 "Small four-year, primarily nonresidential", add 
label values ccsizset label_ccsizset
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
label define label_tenursys -1 "Not reported" 
label define label_tenursys -2 "Not applicable", add 
label define label_tenursys 1 "Has tenure system", add 
label define label_tenursys 2 "No tenure system", add 
label values tenursys label_tenursys
label define label_landgrnt 1 "Land Grant Institution" 
label define label_landgrnt 2 "Not a Land Grant Institution", add 
label values landgrnt label_landgrnt
label define label_instsize -1 "Not reported" 
label define label_instsize -2 "Not applicable", add 
label define label_instsize 1 "Under 1,000", add 
label define label_instsize 2 "1,000 - 4,999", add 
label define label_instsize 3 "5,000 - 9,999", add 
label define label_instsize 4 "10,000 - 19,999", add 
label define label_instsize 5 "20,000 and above", add 
label values instsize label_instsize
label define label_cbsa -2 "Not applicable" 
label define label_cbsa 10020 "Abbeville", add 
label define label_cbsa 10100 "Aberdeen", add 
label define label_cbsa 10140 "Aberdeen", add 
label define label_cbsa 10180 "Abilene", add 
label define label_cbsa 10220 "Ada", add 
label define label_cbsa 10300 "Adrian", add 
label define label_cbsa 10380 "Aguadilla-Isabela-San Sebastián", add 
label define label_cbsa 10420 "Akron", add 
label define label_cbsa 10460 "Alamogordo", add 
label define label_cbsa 10500 "Albany", add 
label define label_cbsa 10540 "Albany-Lebanon", add 
label define label_cbsa 10580 "Albany-Schenectady-Troy", add 
label define label_cbsa 10620 "Albemarle", add 
label define label_cbsa 10700 "Albertville", add 
label define label_cbsa 10740 "Albuquerque", add 
label define label_cbsa 10760 "Alexander City", add 
label define label_cbsa 10780 "Alexandria", add 
label define label_cbsa 10820 "Alexandria", add 
label define label_cbsa 10900 "Allentown-Bethlehem-Easton", add 
label define label_cbsa 10940 "Alma", add 
label define label_cbsa 10980 "Alpena", add 
label define label_cbsa 11020 "Altoona", add 
label define label_cbsa 11060 "Altus", add 
label define label_cbsa 11100 "Amarillo", add 
label define label_cbsa 11140 "Americus", add 
label define label_cbsa 11180 "Ames", add 
label define label_cbsa 11220 "Amsterdam", add 
label define label_cbsa 11260 "Anchorage", add 
label define label_cbsa 11300 "Anderson", add 
label define label_cbsa 11340 "Anderson", add 
label define label_cbsa 11420 "Angola", add 
label define label_cbsa 11460 "Ann Arbor", add 
label define label_cbsa 11500 "Anniston-Oxford", add 
label define label_cbsa 11540 "Appleton", add 
label define label_cbsa 11620 "Ardmore", add 
label define label_cbsa 11660 "Arkadelphia", add 
label define label_cbsa 11700 "Asheville", add 
label define label_cbsa 11740 "Ashland", add 
label define label_cbsa 11780 "Ashtabula", add 
label define label_cbsa 11820 "Astoria", add 
label define label_cbsa 11860 "Atchison", add 
label define label_cbsa 11900 "Athens", add 
label define label_cbsa 11940 "Athens", add 
label define label_cbsa 11980 "Athens", add 
label define label_cbsa 12020 "Athens-Clarke County", add 
label define label_cbsa 12060 "Atlanta-Sandy Springs-Marietta", add 
label define label_cbsa 12100 "Atlantic City", add 
label define label_cbsa 12180 "Auburn", add 
label define label_cbsa 12220 "Auburn-Opelika", add 
label define label_cbsa 12260 "Augusta-Richmond County", add 
label define label_cbsa 12300 "Augusta-Waterville", add 
label define label_cbsa 12380 "Austin", add 
label define label_cbsa 12420 "Austin-Round Rock", add 
label define label_cbsa 12460 "Bainbridge", add 
label define label_cbsa 12540 "Bakersfield", add 
label define label_cbsa 12580 "Baltimore-Towson", add 
label define label_cbsa 12620 "Bangor", add 
label define label_cbsa 12700 "Barnstable Town", add 
label define label_cbsa 12740 "Barre", add 
label define label_cbsa 12780 "Bartlesville", add 
label define label_cbsa 12820 "Bastrop", add 
label define label_cbsa 12860 "Batavia", add 
label define label_cbsa 12900 "Batesville", add 
label define label_cbsa 12940 "Baton Rouge", add 
label define label_cbsa 12980 "Battle Creek", add 
label define label_cbsa 13020 "Bay City", add 
label define label_cbsa 13140 "Beaumont-Port Arthur", add 
label define label_cbsa 13220 "Beckley", add 
label define label_cbsa 13300 "Beeville", add 
label define label_cbsa 13340 "Bellefontaine", add 
label define label_cbsa 13380 "Bellingham", add 
label define label_cbsa 13420 "Bemidji", add 
label define label_cbsa 13460 "Bend", add 
label define label_cbsa 13540 "Bennington", add 
label define label_cbsa 13620 "Berlin", add 
label define label_cbsa 13660 "Big Rapids", add 
label define label_cbsa 13700 "Big Spring", add 
label define label_cbsa 13740 "Billings", add 
label define label_cbsa 13780 "Binghamton", add 
label define label_cbsa 13820 "Birmingham-Hoover", add 
label define label_cbsa 13900 "Bismarck", add 
label define label_cbsa 13980 "Blacksburg-Christiansburg-Radford", add 
label define label_cbsa 14020 "Bloomington", add 
label define label_cbsa 14060 "Bloomington-Normal", add 
label define label_cbsa 14100 "Bloomsburg-Berwick", add 
label define label_cbsa 14140 "Bluefield", add 
label define label_cbsa 14180 "Blytheville", add 
label define label_cbsa 14220 "Bogalusa", add 
label define label_cbsa 14260 "Boise City-Nampa", add 
label define label_cbsa 14380 "Boone", add 
label define label_cbsa 14420 "Borger", add 
label define label_cbsa 14460 "Boston-Cambridge-Quincy", add 
label define label_cbsa 14500 "Boulder", add 
label define label_cbsa 14540 "Bowling Green", add 
label define label_cbsa 14580 "Bozeman", add 
label define label_cbsa 14620 "Bradford", add 
label define label_cbsa 14660 "Brainerd", add 
label define label_cbsa 14700 "Branson", add 
label define label_cbsa 14740 "Bremerton-Silverdale", add 
label define label_cbsa 14780 "Brenham", add 
label define label_cbsa 14820 "Brevard", add 
label define label_cbsa 14860 "Bridgeport-Stamford-Norwalk", add 
label define label_cbsa 15100 "Brookings", add 
label define label_cbsa 15180 "Brownsville-Harlingen", add 
label define label_cbsa 15220 "Brownwood", add 
label define label_cbsa 15260 "Brunswick", add 
label define label_cbsa 15380 "Buffalo-Niagara Falls", add 
label define label_cbsa 15420 "Burley", add 
label define label_cbsa 15460 "Burlington", add 
label define label_cbsa 15500 "Burlington", add 
label define label_cbsa 15540 "Burlington-South Burlington", add 
label define label_cbsa 15580 "Butte-Silver Bow", add 
label define label_cbsa 15620 "Cadillac", add 
label define label_cbsa 15740 "Cambridge", add 
label define label_cbsa 15780 "Camden", add 
label define label_cbsa 15820 "Campbellsville", add 
label define label_cbsa 15900 "Canton", add 
label define label_cbsa 15940 "Canton-Massillon", add 
label define label_cbsa 15980 "Cape Coral-Fort Myers", add 
label define label_cbsa 16020 "Cape Girardeau-Jackson", add 
label define label_cbsa 16060 "Carbondale", add 
label define label_cbsa 16100 "Carlsbad-Artesia", add 
label define label_cbsa 16180 "Carson City", add 
label define label_cbsa 16220 "Casper", add 
label define label_cbsa 16260 "Cedar City", add 
label define label_cbsa 16300 "Cedar Rapids", add 
label define label_cbsa 16380 "Celina", add 
label define label_cbsa 16540 "Chambersburg", add 
label define label_cbsa 16580 "Champaign-Urbana", add 
label define label_cbsa 16620 "Charleston", add 
label define label_cbsa 16660 "Charleston-Mattoon", add 
label define label_cbsa 16700 "Charleston-North Charleston", add 
label define label_cbsa 16740 "Charlotte-Gastonia-Concord", add 
label define label_cbsa 16820 "Charlottesville", add 
label define label_cbsa 16860 "Chattanooga", add 
label define label_cbsa 16940 "Cheyenne", add 
label define label_cbsa 16980 "Chicago-Naperville-Joliet", add 
label define label_cbsa 17020 "Chico", add 
label define label_cbsa 17060 "Chillicothe", add 
label define label_cbsa 17140 "Cincinnati-Middletown", add 
label define label_cbsa 17180 "City of The Dalles", add 
label define label_cbsa 17200 "Claremont", add 
label define label_cbsa 17220 "Clarksburg", add 
label define label_cbsa 17260 "Clarksdale", add 
label define label_cbsa 17300 "Clarksville", add 
label define label_cbsa 17380 "Cleveland", add 
label define label_cbsa 17420 "Cleveland", add 
label define label_cbsa 17460 "Cleveland-Elyria-Mentor", add 
label define label_cbsa 17540 "Clinton", add 
label define label_cbsa 17580 "Clovis", add 
label define label_cbsa 17620 "Coamo", add 
label define label_cbsa 17660 "Coeur dAlene", add 
label define label_cbsa 17700 "Coffeyville", add 
label define label_cbsa 17740 "Coldwater", add 
label define label_cbsa 17780 "College Station-Bryan", add 
label define label_cbsa 17820 "Colorado Springs", add 
label define label_cbsa 17860 "Columbia", add 
label define label_cbsa 17900 "Columbia", add 
label define label_cbsa 17940 "Columbia", add 
label define label_cbsa 17980 "Columbus", add 
label define label_cbsa 18020 "Columbus", add 
label define label_cbsa 18060 "Columbus", add 
label define label_cbsa 18140 "Columbus", add 
label define label_cbsa 18180 "Concord", add 
label define label_cbsa 18260 "Cookeville", add 
label define label_cbsa 18300 "Coos Bay", add 
label define label_cbsa 18340 "Corbin", add 
label define label_cbsa 18420 "Corinth", add 
label define label_cbsa 18460 "Cornelia", add 
label define label_cbsa 18500 "Corning", add 
label define label_cbsa 18580 "Corpus Christi", add 
label define label_cbsa 18620 "Corsicana", add 
label define label_cbsa 18660 "Cortland", add 
label define label_cbsa 18700 "Corvallis", add 
label define label_cbsa 18820 "Crawfordsville", add 
label define label_cbsa 18900 "Crossville", add 
label define label_cbsa 18940 "Crowley", add 
label define label_cbsa 18980 "Cullman", add 
label define label_cbsa 19020 "Culpeper", add 
label define label_cbsa 19060 "Cumberland", add 
label define label_cbsa 19100 "Dallas-Fort Worth-Arlington", add 
label define label_cbsa 19140 "Dalton", add 
label define label_cbsa 19180 "Danville", add 
label define label_cbsa 19220 "Danville", add 
label define label_cbsa 19260 "Danville", add 
label define label_cbsa 19300 "Daphne-Fairhope-Foley", add 
label define label_cbsa 19340 "Davenport-Moline-Rock Island", add 
label define label_cbsa 19380 "Dayton", add 
label define label_cbsa 19500 "Decatur", add 
label define label_cbsa 19580 "Defiance", add 
label define label_cbsa 19620 "Del Rio", add 
label define label_cbsa 19660 "Deltona-Daytona Beach-Ormond Beach", add 
label define label_cbsa 19740 "Denver-Aurora", add 
label define label_cbsa 19780 "Des Moines-West Des Moines", add 
label define label_cbsa 19820 "Detroit-Warren-Livonia", add 
label define label_cbsa 19860 "Dickinson", add 
label define label_cbsa 19940 "Dixon", add 
label define label_cbsa 19980 "Dodge City", add 
label define label_cbsa 20020 "Dothan", add 
label define label_cbsa 20060 "Douglas", add 
label define label_cbsa 20100 "Dover", add 
label define label_cbsa 20140 "Dublin", add 
label define label_cbsa 20180 "DuBois", add 
label define label_cbsa 20220 "Dubuque", add 
label define label_cbsa 20260 "Duluth", add 
label define label_cbsa 20340 "Duncan", add 
label define label_cbsa 20380 "Dunn", add 
label define label_cbsa 20420 "Durango", add 
label define label_cbsa 20460 "Durant", add 
label define label_cbsa 20500 "Durham", add 
label define label_cbsa 20540 "Dyersburg", add 
label define label_cbsa 20580 "Eagle Pass", add 
label define label_cbsa 20620 "East Liverpool-Salem", add 
label define label_cbsa 20660 "Easton", add 
label define label_cbsa 20700 "East Stroudsburg", add 
label define label_cbsa 20740 "Eau Claire", add 
label define label_cbsa 20900 "El Campo", add 
label define label_cbsa 20940 "El Centro", add 
label define label_cbsa 20980 "El Dorado", add 
label define label_cbsa 21020 "Elizabeth City", add 
label define label_cbsa 21060 "Elizabethtown", add 
label define label_cbsa 21140 "Elkhart-Goshen", add 
label define label_cbsa 21220 "Elko", add 
label define label_cbsa 21260 "Ellensburg", add 
label define label_cbsa 21300 "Elmira", add 
label define label_cbsa 21340 "El Paso", add 
label define label_cbsa 21380 "Emporia", add 
label define label_cbsa 21420 "Enid", add 
label define label_cbsa 21460 "Enterprise-Ozark", add 
label define label_cbsa 21500 "Erie", add 
label define label_cbsa 21540 "Escanaba", add 
label define label_cbsa 21580 "Espanola", add 
label define label_cbsa 21660 "Eugene-Springfield", add 
label define label_cbsa 21700 "Eureka-Arcata-Fortuna", add 
label define label_cbsa 21740 "Evanston", add 
label define label_cbsa 21780 "Evansville", add 
label define label_cbsa 21820 "Fairbanks", add 
label define label_cbsa 21900 "Fairmont", add 
label define label_cbsa 21940 "Fajardo", add 
label define label_cbsa 22020 "Fargo", add 
label define label_cbsa 22060 "Faribault-Northfield", add 
label define label_cbsa 22100 "Farmington", add 
label define label_cbsa 22140 "Farmington", add 
label define label_cbsa 22180 "Fayetteville", add 
label define label_cbsa 22220 "Fayetteville-Springdale-Rogers", add 
label define label_cbsa 22260 "Fergus Falls", add 
label define label_cbsa 22300 "Findlay", add 
label define label_cbsa 22340 "Fitzgerald", add 
label define label_cbsa 22380 "Flagstaff", add 
label define label_cbsa 22420 "Flint", add 
label define label_cbsa 22500 "Florence", add 
label define label_cbsa 22520 "Florence-Muscle Shoals", add 
label define label_cbsa 22540 "Fond du Lac", add 
label define label_cbsa 22580 "Forest City", add 
label define label_cbsa 22620 "Forrest City", add 
label define label_cbsa 22660 "Fort Collins-Loveland", add 
label define label_cbsa 22700 "Fort Dodge", add 
label define label_cbsa 22780 "Fort Leonard Wood", add 
label define label_cbsa 22800 "Fort Madison-Keokuk", add 
label define label_cbsa 22820 "Fort Morgan", add 
label define label_cbsa 22840 "Fort Payne", add 
label define label_cbsa 22860 "Fort Polk South", add 
label define label_cbsa 22900 "Fort Smith", add 
label define label_cbsa 22980 "Fort Valley", add 
label define label_cbsa 23020 "Fort Walton Beach-Crestview-Destin", add 
label define label_cbsa 23060 "Fort Wayne", add 
label define label_cbsa 23180 "Frankfort", add 
label define label_cbsa 23300 "Freeport", add 
label define label_cbsa 23340 "Fremont", add 
label define label_cbsa 23380 "Fremont", add 
label define label_cbsa 23420 "Fresno", add 
label define label_cbsa 23460 "Gadsden", add 
label define label_cbsa 23500 "Gaffney", add 
label define label_cbsa 23540 "Gainesville", add 
label define label_cbsa 23580 "Gainesville", add 
label define label_cbsa 23620 "Gainesville", add 
label define label_cbsa 23660 "Galesburg", add 
label define label_cbsa 23700 "Gallup", add 
label define label_cbsa 23780 "Garden City", add 
label define label_cbsa 23900 "Gettysburg", add 
label define label_cbsa 23980 "Glasgow", add 
label define label_cbsa 24020 "Glens Falls", add 
label define label_cbsa 24100 "Gloversville", add 
label define label_cbsa 24140 "Goldsboro", add 
label define label_cbsa 24220 "Grand Forks", add 
label define label_cbsa 24260 "Grand Island", add 
label define label_cbsa 24300 "Grand Junction", add 
label define label_cbsa 24340 "Grand Rapids-Wyoming", add 
label define label_cbsa 24380 "Grants", add 
label define label_cbsa 24420 "Grants Pass", add 
label define label_cbsa 24460 "Great Bend", add 
label define label_cbsa 24500 "Great Falls", add 
label define label_cbsa 24540 "Greeley", add 
label define label_cbsa 24580 "Green Bay", add 
label define label_cbsa 24620 "Greeneville", add 
label define label_cbsa 24660 "Greensboro-High Point", add 
label define label_cbsa 24740 "Greenville", add 
label define label_cbsa 24780 "Greenville", add 
label define label_cbsa 24860 "Greenville-Mauldin-Easley", add 
label define label_cbsa 24900 "Greenwood", add 
label define label_cbsa 24940 "Greenwood", add 
label define label_cbsa 24980 "Grenada", add 
label define label_cbsa 25020 "Guayama", add 
label define label_cbsa 25060 "Gulfport-Biloxi", add 
label define label_cbsa 25100 "Guymon", add 
label define label_cbsa 25180 "Hagerstown-Martinsburg", add 
label define label_cbsa 25220 "Hammond", add 
label define label_cbsa 25260 "Hanford-Corcoran", add 
label define label_cbsa 25300 "Hannibal", add 
label define label_cbsa 25340 "Harriman", add 
label define label_cbsa 25380 "Harrisburg", add 
label define label_cbsa 25420 "Harrisburg-Carlisle", add 
label define label_cbsa 25460 "Harrison", add 
label define label_cbsa 25500 "Harrisonburg", add 
label define label_cbsa 25540 "Hartford-West Hartford-East Hartford", add 
label define label_cbsa 25580 "Hastings", add 
label define label_cbsa 25620 "Hattiesburg", add 
label define label_cbsa 25660 "Havre", add 
label define label_cbsa 25700 "Hays", add 
label define label_cbsa 25740 "Helena", add 
label define label_cbsa 25860 "Hickory-Lenoir-Morganton", add 
label define label_cbsa 25900 "Hilo", add 
label define label_cbsa 25940 "Hilton Head Island-Beaufort", add 
label define label_cbsa 26020 "Hobbs", add 
label define label_cbsa 26100 "Holland-Grand Haven", add 
label define label_cbsa 26140 "Homosassa Springs", add 
label define label_cbsa 26180 "Honolulu", add 
label define label_cbsa 26260 "Hope", add 
label define label_cbsa 26300 "Hot Springs", add 
label define label_cbsa 26340 "Houghton", add 
label define label_cbsa 26380 "Houma-Bayou Cane-Thibodaux", add 
label define label_cbsa 26420 "Houston-Sugar Land-Baytown", add 
label define label_cbsa 26460 "Hudson", add 
label define label_cbsa 26480 "Humboldt", add 
label define label_cbsa 26500 "Huntingdon", add 
label define label_cbsa 26540 "Huntington", add 
label define label_cbsa 26580 "Huntington-Ashland", add 
label define label_cbsa 26620 "Huntsville", add 
label define label_cbsa 26660 "Huntsville", add 
label define label_cbsa 26740 "Hutchinson", add 
label define label_cbsa 26780 "Hutchinson", add 
label define label_cbsa 26820 "Idaho Falls", add 
label define label_cbsa 26860 "Indiana", add 
label define label_cbsa 26900 "Indianapolis-Carmel", add 
label define label_cbsa 26940 "Indianola", add 
label define label_cbsa 26980 "Iowa City", add 
label define label_cbsa 27060 "Ithaca", add 
label define label_cbsa 27100 "Jackson", add 
label define label_cbsa 27140 "Jackson", add 
label define label_cbsa 27180 "Jackson", add 
label define label_cbsa 27260 "Jacksonville", add 
label define label_cbsa 27300 "Jacksonville", add 
label define label_cbsa 27340 "Jacksonville", add 
label define label_cbsa 27380 "Jacksonville", add 
label define label_cbsa 27420 "Jamestown", add 
label define label_cbsa 27460 "Jamestown-Dunkirk-Fredonia", add 
label define label_cbsa 27500 "Janesville", add 
label define label_cbsa 27620 "Jefferson City", add 
label define label_cbsa 27660 "Jennings", add 
label define label_cbsa 27700 "Jesup", add 
label define label_cbsa 27740 "Johnson City", add 
label define label_cbsa 27780 "Johnstown", add 
label define label_cbsa 27860 "Jonesboro", add 
label define label_cbsa 27900 "Joplin", add 
label define label_cbsa 27940 "Juneau", add 
label define label_cbsa 27980 "Kahului-Wailuku", add 
label define label_cbsa 28020 "Kalamazoo-Portage", add 
label define label_cbsa 28060 "Kalispell", add 
label define label_cbsa 28100 "Kankakee-Bradley", add 
label define label_cbsa 28140 "Kansas City", add 
label define label_cbsa 28180 "Kapaa", add 
label define label_cbsa 28260 "Kearney", add 
label define label_cbsa 28300 "Keene", add 
label define label_cbsa 28420 "Kennewick-Richland-Pasco", add 
label define label_cbsa 28500 "Kerrville", add 
label define label_cbsa 28580 "Key West", add 
label define label_cbsa 28660 "Killeen-Temple-Fort Hood", add 
label define label_cbsa 28700 "Kingsport-Bristol-Bristol", add 
label define label_cbsa 28740 "Kingston", add 
label define label_cbsa 28780 "Kingsville", add 
label define label_cbsa 28820 "Kinston", add 
label define label_cbsa 28860 "Kirksville", add 
label define label_cbsa 28900 "Klamath Falls", add 
label define label_cbsa 28940 "Knoxville", add 
label define label_cbsa 29020 "Kokomo", add 
label define label_cbsa 29060 "Laconia", add 
label define label_cbsa 29100 "La Crosse", add 
label define label_cbsa 29140 "Lafayette", add 
label define label_cbsa 29180 "Lafayette", add 
label define label_cbsa 29220 "La Follette", add 
label define label_cbsa 29260 "La Grande", add 
label define label_cbsa 29300 "LaGrange", add 
label define label_cbsa 29340 "Lake Charles", add 
label define label_cbsa 29380 "Lake City", add 
label define label_cbsa 29420 "Lake Havasu City-Kingman", add 
label define label_cbsa 29460 "Lakeland", add 
label define label_cbsa 29540 "Lancaster", add 
label define label_cbsa 29580 "Lancaster", add 
label define label_cbsa 29620 "Lansing-East Lansing", add 
label define label_cbsa 29660 "Laramie", add 
label define label_cbsa 29700 "Laredo", add 
label define label_cbsa 29740 "Las Cruces", add 
label define label_cbsa 29780 "Las Vegas", add 
label define label_cbsa 29820 "Las Vegas-Paradise", add 
label define label_cbsa 29860 "Laurel", add 
label define label_cbsa 29900 "Laurinburg", add 
label define label_cbsa 29940 "Lawrence", add 
label define label_cbsa 29980 "Lawrenceburg", add 
label define label_cbsa 30020 "Lawton", add 
label define label_cbsa 30060 "Lebanon", add 
label define label_cbsa 30100 "Lebanon", add 
label define label_cbsa 30140 "Lebanon", add 
label define label_cbsa 30220 "Levelland", add 
label define label_cbsa 30260 "Lewisburg", add 
label define label_cbsa 30300 "Lewiston", add 
label define label_cbsa 30340 "Lewiston-Auburn", add 
label define label_cbsa 30380 "Lewistown", add 
label define label_cbsa 30460 "Lexington-Fayette", add 
label define label_cbsa 30500 "Lexington Park", add 
label define label_cbsa 30580 "Liberal", add 
label define label_cbsa 30620 "Lima", add 
label define label_cbsa 30660 "Lincoln", add 
label define label_cbsa 30700 "Lincoln", add 
label define label_cbsa 30780 "Little Rock-North Little Rock-Conway", add 
label define label_cbsa 30820 "Lock Haven", add 
label define label_cbsa 30860 "Logan", add 
label define label_cbsa 30940 "London", add 
label define label_cbsa 30980 "Longview", add 
label define label_cbsa 31020 "Longview", add 
label define label_cbsa 31060 "Los Alamos", add 
label define label_cbsa 31100 "Los Angeles-Long Beach-Santa Ana", add 
label define label_cbsa 31140 "Louisville-Jefferson County", add 
label define label_cbsa 31180 "Lubbock", add 
label define label_cbsa 31260 "Lufkin", add 
label define label_cbsa 31300 "Lumberton", add 
label define label_cbsa 31340 "Lynchburg", add 
label define label_cbsa 31380 "Macomb", add 
label define label_cbsa 31420 "Macon", add 
label define label_cbsa 31460 "Madera", add 
label define label_cbsa 31500 "Madison", add 
label define label_cbsa 31540 "Madison", add 
label define label_cbsa 31580 "Madisonville", add 
label define label_cbsa 31620 "Magnolia", add 
label define label_cbsa 31660 "Malone", add 
label define label_cbsa 31700 "Manchester-Nashua", add 
label define label_cbsa 31740 "Manhattan", add 
label define label_cbsa 31820 "Manitowoc", add 
label define label_cbsa 31860 "Mankato-North Mankato", add 
label define label_cbsa 31900 "Mansfield", add 
label define label_cbsa 31940 "Marinette", add 
label define label_cbsa 31980 "Marion", add 
label define label_cbsa 32020 "Marion", add 
label define label_cbsa 32060 "Marion-Herrin", add 
label define label_cbsa 32100 "Marquette", add 
label define label_cbsa 32140 "Marshall", add 
label define label_cbsa 32180 "Marshall", add 
label define label_cbsa 32220 "Marshall", add 
label define label_cbsa 32260 "Marshalltown", add 
label define label_cbsa 32270 "Marshfield-Wisconsin Rapids", add 
label define label_cbsa 32280 "Martin", add 
label define label_cbsa 32300 "Martinsville", add 
label define label_cbsa 32340 "Maryville", add 
label define label_cbsa 32380 "Mason City", add 
label define label_cbsa 32420 "Mayagüez", add 
label define label_cbsa 32460 "Mayfield", add 
label define label_cbsa 32500 "Maysville", add 
label define label_cbsa 32540 "McAlester", add 
label define label_cbsa 32580 "McAllen-Edinburg-Mission", add 
label define label_cbsa 32620 "McComb", add 
label define label_cbsa 32660 "McMinnville", add 
label define label_cbsa 32700 "McPherson", add 
label define label_cbsa 32740 "Meadville", add 
label define label_cbsa 32780 "Medford", add 
label define label_cbsa 32820 "Memphis", add 
label define label_cbsa 32860 "Menomonie", add 
label define label_cbsa 32900 "Merced", add 
label define label_cbsa 32940 "Meridian", add 
label define label_cbsa 33020 "Mexico", add 
label define label_cbsa 33060 "Miami", add 
label define label_cbsa 33100 "Miami-Fort Lauderdale-Pompano Beach", add 
label define label_cbsa 33140 "Michigan City-La Porte", add 
label define label_cbsa 33180 "Middlesborough", add 
label define label_cbsa 33220 "Midland", add 
label define label_cbsa 33260 "Midland", add 
label define label_cbsa 33300 "Milledgeville", add 
label define label_cbsa 33340 "Milwaukee-Waukesha-West Allis", add 
label define label_cbsa 33380 "Minden", add 
label define label_cbsa 33460 "Minneapolis-St. Paul-Bloomington", add 
label define label_cbsa 33500 "Minot", add 
label define label_cbsa 33540 "Missoula", add 
label define label_cbsa 33580 "Mitchell", add 
label define label_cbsa 33620 "Moberly", add 
label define label_cbsa 33660 "Mobile", add 
label define label_cbsa 33700 "Modesto", add 
label define label_cbsa 33740 "Monroe", add 
label define label_cbsa 33780 "Monroe", add 
label define label_cbsa 33820 "Monroe", add 
label define label_cbsa 33860 "Montgomery", add 
label define label_cbsa 33980 "Morehead City", add 
label define label_cbsa 34020 "Morgan City", add 
label define label_cbsa 34060 "Morgantown", add 
label define label_cbsa 34100 "Morristown", add 
label define label_cbsa 34140 "Moscow", add 
label define label_cbsa 34180 "Moses Lake", add 
label define label_cbsa 34220 "Moultrie", add 
label define label_cbsa 34260 "Mountain Home", add 
label define label_cbsa 34340 "Mount Airy", add 
label define label_cbsa 34380 "Mount Pleasant", add 
label define label_cbsa 34420 "Mount Pleasant", add 
label define label_cbsa 34460 "Mount Sterling", add 
label define label_cbsa 34500 "Mount Vernon", add 
label define label_cbsa 34540 "Mount Vernon", add 
label define label_cbsa 34580 "Mount Vernon-Anacortes", add 
label define label_cbsa 34620 "Muncie", add 
label define label_cbsa 34660 "Murray", add 
label define label_cbsa 34740 "Muskegon-Norton Shores", add 
label define label_cbsa 34780 "Muskogee", add 
label define label_cbsa 34820 "Myrtle Beach-Conway-North Myrtle Beach", add 
label define label_cbsa 34860 "Nacogdoches", add 
label define label_cbsa 34900 "Napa", add 
label define label_cbsa 34940 "Naples-Marco Island", add 
label define label_cbsa 34980 "Nashville-Davidson--Murfreesboro--Franklin", add 
label define label_cbsa 35020 "Natchez", add 
label define label_cbsa 35060 "Natchitoches", add 
label define label_cbsa 35100 "New Bern", add 
label define label_cbsa 35140 "Newberry", add 
label define label_cbsa 35260 "New Castle", add 
label define label_cbsa 35300 "New Haven-Milford", add 
label define label_cbsa 35380 "New Orleans-Metairie-Kenner", add 
label define label_cbsa 35420 "New Philadelphia-Dover", add 
label define label_cbsa 35580 "New Ulm", add 
label define label_cbsa 35620 "New York-Northern New Jersey-Long Island", add 
label define label_cbsa 35660 "Niles-Benton Harbor", add 
label define label_cbsa 35740 "Norfolk", add 
label define label_cbsa 35820 "North Platte", add 
label define label_cbsa 35900 "North Wilkesboro", add 
label define label_cbsa 35980 "Norwich-New London", add 
label define label_cbsa 36060 "Oak Hill", add 
label define label_cbsa 36100 "Ocala", add 
label define label_cbsa 36220 "Odessa", add 
label define label_cbsa 36260 "Ogden-Clearfield", add 
label define label_cbsa 36300 "Ogdensburg-Massena", add 
label define label_cbsa 36340 "Oil City", add 
label define label_cbsa 36420 "Oklahoma City", add 
label define label_cbsa 36460 "Olean", add 
label define label_cbsa 36500 "Olympia", add 
label define label_cbsa 36540 "Omaha-Council Bluffs", add 
label define label_cbsa 36580 "Oneonta", add 
label define label_cbsa 36620 "Ontario", add 
label define label_cbsa 36660 "Opelousas-Eunice", add 
label define label_cbsa 36700 "Orangeburg", add 
label define label_cbsa 36740 "Orlando-Kissimmee", add 
label define label_cbsa 36780 "Oshkosh-Neenah", add 
label define label_cbsa 36820 "Oskaloosa", add 
label define label_cbsa 36860 "Ottawa-Streator", add 
label define label_cbsa 36900 "Ottumwa", add 
label define label_cbsa 36940 "Owatonna", add 
label define label_cbsa 36980 "Owensboro", add 
label define label_cbsa 37020 "Owosso", add 
label define label_cbsa 37060 "Oxford", add 
label define label_cbsa 37100 "Oxnard-Thousand Oaks-Ventura", add 
label define label_cbsa 37140 "Paducah", add 
label define label_cbsa 37260 "Palatka", add 
label define label_cbsa 37340 "Palm Bay-Melbourne-Titusville", add 
label define label_cbsa 37460 "Panama City-Lynn Haven", add 
label define label_cbsa 37500 "Paragould", add 
label define label_cbsa 37540 "Paris", add 
label define label_cbsa 37580 "Paris", add 
label define label_cbsa 37620 "Parkersburg-Marietta-Vienna", add 
label define label_cbsa 37660 "Parsons", add 
label define label_cbsa 37700 "Pascagoula", add 
label define label_cbsa 37800 "Pella", add 
label define label_cbsa 37820 "Pendleton-Hermiston", add 
label define label_cbsa 37860 "Pensacola-Ferry Pass-Brent", add 
label define label_cbsa 37900 "Peoria", add 
label define label_cbsa 37980 "Philadelphia-Camden-Wilmington", add 
label define label_cbsa 38020 "Phoenix Lake-Cedar Ridge", add 
label define label_cbsa 38060 "Phoenix-Mesa-Scottsdale", add 
label define label_cbsa 38100 "Picayune", add 
label define label_cbsa 38220 "Pine Bluff", add 
label define label_cbsa 38260 "Pittsburg", add 
label define label_cbsa 38300 "Pittsburgh", add 
label define label_cbsa 38340 "Pittsfield", add 
label define label_cbsa 38380 "Plainview", add 
label define label_cbsa 38420 "Platteville", add 
label define label_cbsa 38460 "Plattsburgh", add 
label define label_cbsa 38500 "Plymouth", add 
label define label_cbsa 38540 "Pocatello", add 
label define label_cbsa 38580 "Point Pleasant", add 
label define label_cbsa 38620 "Ponca City", add 
label define label_cbsa 38660 "Ponce", add 
label define label_cbsa 38740 "Poplar Bluff", add 
label define label_cbsa 38780 "Portales", add 
label define label_cbsa 38820 "Port Angeles", add 
label define label_cbsa 38860 "Portland-South Portland-Biddeford", add 
label define label_cbsa 38900 "Portland-Vancouver-Beaverton", add 
label define label_cbsa 38940 "Port St. Lucie", add 
label define label_cbsa 39020 "Portsmouth", add 
label define label_cbsa 39060 "Pottsville", add 
label define label_cbsa 39100 "Poughkeepsie-Newburgh-Middletown", add 
label define label_cbsa 39140 "Prescott", add 
label define label_cbsa 39220 "Price", add 
label define label_cbsa 39300 "Providence-New Bedford-Fall River", add 
label define label_cbsa 39340 "Provo-Orem", add 
label define label_cbsa 39380 "Pueblo", add 
label define label_cbsa 39420 "Pullman", add 
label define label_cbsa 39460 "Punta Gorda", add 
label define label_cbsa 39500 "Quincy", add 
label define label_cbsa 39540 "Racine", add 
label define label_cbsa 39580 "Raleigh-Cary", add 
label define label_cbsa 39660 "Rapid City", add 
label define label_cbsa 39740 "Reading", add 
label define label_cbsa 39820 "Redding", add 
label define label_cbsa 39860 "Red Wing", add 
label define label_cbsa 39900 "Reno-Sparks", add 
label define label_cbsa 39940 "Rexburg", add 
label define label_cbsa 39980 "Richmond", add 
label define label_cbsa 40060 "Richmond", add 
label define label_cbsa 40080 "Richmond-Berea", add 
label define label_cbsa 40140 "Riverside-San Bernardino-Ontario", add 
label define label_cbsa 40180 "Riverton", add 
label define label_cbsa 40220 "Roanoke", add 
label define label_cbsa 40260 "Roanoke Rapids", add 
label define label_cbsa 40340 "Rochester", add 
label define label_cbsa 40380 "Rochester", add 
label define label_cbsa 40420 "Rockford", add 
label define label_cbsa 40460 "Rockingham", add 
label define label_cbsa 40540 "Rock Springs", add 
label define label_cbsa 40580 "Rocky Mount", add 
label define label_cbsa 40620 "Rolla", add 
label define label_cbsa 40660 "Rome", add 
label define label_cbsa 40700 "Roseburg", add 
label define label_cbsa 40740 "Roswell", add 
label define label_cbsa 40760 "Ruidoso", add 
label define label_cbsa 40780 "Russellville", add 
label define label_cbsa 40820 "Ruston", add 
label define label_cbsa 40860 "Rutland", add 
label define label_cbsa 40900 "Sacramento--Arden-Arcade--Roseville", add 
label define label_cbsa 40940 "Safford", add 
label define label_cbsa 40980 "Saginaw-Saginaw Township North", add 
label define label_cbsa 41060 "St. Cloud", add 
label define label_cbsa 41100 "St. George", add 
label define label_cbsa 41140 "St. Joseph", add 
label define label_cbsa 41180 "St. Louis", add 
label define label_cbsa 41260 "St. Marys", add 
label define label_cbsa 41420 "Salem", add 
label define label_cbsa 41460 "Salina", add 
label define label_cbsa 41500 "Salinas", add 
label define label_cbsa 41540 "Salisbury", add 
label define label_cbsa 41580 "Salisbury", add 
label define label_cbsa 41620 "Salt Lake City", add 
label define label_cbsa 41660 "San Angelo", add 
label define label_cbsa 41700 "San Antonio", add 
label define label_cbsa 41740 "San Diego-Carlsbad-San Marcos", add 
label define label_cbsa 41780 "Sandusky", add 
label define label_cbsa 41820 "Sanford", add 
label define label_cbsa 41860 "San Francisco-Oakland-Fremont", add 
label define label_cbsa 41900 "San Germán-Cabo Rojo", add 
label define label_cbsa 41940 "San Jose-Sunnyvale-Santa Clara", add 
label define label_cbsa 41980 "San Juan-Caguas-Guaynabo", add 
label define label_cbsa 42020 "San Luis Obispo-Paso Robles", add 
label define label_cbsa 42060 "Santa Barbara-Santa Maria-Goleta", add 
label define label_cbsa 42100 "Santa Cruz-Watsonville", add 
label define label_cbsa 42140 "Santa Fe", add 
label define label_cbsa 42220 "Santa Rosa-Petaluma", add 
label define label_cbsa 42260 "Sarasota-Bradenton-Venice", add 
label define label_cbsa 42300 "Sault Ste. Marie", add 
label define label_cbsa 42340 "Savannah", add 
label define label_cbsa 42380 "Sayre", add 
label define label_cbsa 42420 "Scottsbluff", add 
label define label_cbsa 42460 "Scottsboro", add 
label define label_cbsa 42540 "Scranton--Wilkes-Barre", add 
label define label_cbsa 42580 "Seaford", add 
label define label_cbsa 42620 "Searcy", add 
label define label_cbsa 42660 "Seattle-Tacoma-Bellevue", add 
label define label_cbsa 42680 "Sebastian-Vero Beach", add 
label define label_cbsa 42700 "Sebring", add 
label define label_cbsa 42740 "Sedalia", add 
label define label_cbsa 42780 "Selinsgrove", add 
label define label_cbsa 42820 "Selma", add 
label define label_cbsa 42900 "Seneca Falls", add 
label define label_cbsa 43060 "Shawnee", add 
label define label_cbsa 43100 "Sheboygan", add 
label define label_cbsa 43140 "Shelby", add 
label define label_cbsa 43180 "Shelbyville", add 
label define label_cbsa 43260 "Sheridan", add 
label define label_cbsa 43300 "Sherman-Denison", add 
label define label_cbsa 43340 "Shreveport-Bossier City", add 
label define label_cbsa 43420 "Sierra Vista-Douglas", add 
label define label_cbsa 43460 "Sikeston", add 
label define label_cbsa 43500 "Silver City", add 
label define label_cbsa 43580 "Sioux City", add 
label define label_cbsa 43620 "Sioux Falls", add 
label define label_cbsa 43660 "Snyder", add 
label define label_cbsa 43700 "Somerset", add 
label define label_cbsa 43780 "South Bend-Mishawaka", add 
label define label_cbsa 43860 "Southern Pines-Pinehurst", add 
label define label_cbsa 43900 "Spartanburg", add 
label define label_cbsa 43940 "Spearfish", add 
label define label_cbsa 44020 "Spirit Lake", add 
label define label_cbsa 44060 "Spokane", add 
label define label_cbsa 44100 "Springfield", add 
label define label_cbsa 44140 "Springfield", add 
label define label_cbsa 44180 "Springfield", add 
label define label_cbsa 44220 "Springfield", add 
label define label_cbsa 44260 "Starkville", add 
label define label_cbsa 44300 "State College", add 
label define label_cbsa 44340 "Statesboro", add 
label define label_cbsa 44380 "Statesville-Mooresville", add 
label define label_cbsa 44420 "Staunton-Waynesboro", add 
label define label_cbsa 44500 "Stephenville", add 
label define label_cbsa 44540 "Sterling", add 
label define label_cbsa 44580 "Sterling", add 
label define label_cbsa 44620 "Stevens Point", add 
label define label_cbsa 44660 "Stillwater", add 
label define label_cbsa 44700 "Stockton", add 
label define label_cbsa 44740 "Storm Lake", add 
label define label_cbsa 44780 "Sturgis", add 
label define label_cbsa 44940 "Sumter", add 
label define label_cbsa 44980 "Sunbury", add 
label define label_cbsa 45000 "Susanville", add 
label define label_cbsa 45020 "Sweetwater", add 
label define label_cbsa 45060 "Syracuse", add 
label define label_cbsa 45140 "Tahlequah", add 
label define label_cbsa 45180 "Talladega-Sylacauga", add 
label define label_cbsa 45220 "Tallahassee", add 
label define label_cbsa 45260 "Tallulah", add 
label define label_cbsa 45300 "Tampa-St. Petersburg-Clearwater", add 
label define label_cbsa 45340 "Taos", add 
label define label_cbsa 45460 "Terre Haute", add 
label define label_cbsa 45500 "Texarkana-Texarkana", add 
label define label_cbsa 45580 "Thomaston", add 
label define label_cbsa 45620 "Thomasville", add 
label define label_cbsa 45640 "Thomasville-Lexington", add 
label define label_cbsa 45660 "Tiffin", add 
label define label_cbsa 45700 "Tifton", add 
label define label_cbsa 45740 "Toccoa", add 
label define label_cbsa 45780 "Toledo", add 
label define label_cbsa 45820 "Topeka", add 
label define label_cbsa 45860 "Torrington", add 
label define label_cbsa 45900 "Traverse City", add 
label define label_cbsa 45940 "Trenton-Ewing", add 
label define label_cbsa 45980 "Troy", add 
label define label_cbsa 46060 "Tucson", add 
label define label_cbsa 46100 "Tullahoma", add 
label define label_cbsa 46140 "Tulsa", add 
label define label_cbsa 46180 "Tupelo", add 
label define label_cbsa 46220 "Tuscaloosa", add 
label define label_cbsa 46260 "Tuskegee", add 
label define label_cbsa 46300 "Twin Falls", add 
label define label_cbsa 46340 "Tyler", add 
label define label_cbsa 46380 "Ukiah", add 
label define label_cbsa 46420 "Union", add 
label define label_cbsa 46500 "Urbana", add 
label define label_cbsa 46540 "Utica-Rome", add 
label define label_cbsa 46580 "Utuado", add 
label define label_cbsa 46620 "Uvalde", add 
label define label_cbsa 46660 "Valdosta", add 
label define label_cbsa 46700 "Vallejo-Fairfield", add 
label define label_cbsa 46780 "Van Wert", add 
label define label_cbsa 46820 "Vermillion", add 
label define label_cbsa 46900 "Vernon", add 
label define label_cbsa 47020 "Victoria", add 
label define label_cbsa 47080 "Vidalia", add 
label define label_cbsa 47180 "Vincennes", add 
label define label_cbsa 47220 "Vineland-Millville-Bridgeton", add 
label define label_cbsa 47260 "Virginia Beach-Norfolk-Newport News", add 
label define label_cbsa 47300 "Visalia-Porterville", add 
label define label_cbsa 47340 "Wabash", add 
label define label_cbsa 47380 "Waco", add 
label define label_cbsa 47420 "Wahpeton", add 
label define label_cbsa 47460 "Walla Walla", add 
label define label_cbsa 47580 "Warner Robins", add 
label define label_cbsa 47660 "Warrensburg", add 
label define label_cbsa 47700 "Warsaw", add 
label define label_cbsa 47820 "Washington", add 
label define label_cbsa 47900 "Washington-Arlington-Alexandria", add 
label define label_cbsa 47940 "Waterloo-Cedar Falls", add 
label define label_cbsa 47980 "Watertown", add 
label define label_cbsa 48020 "Watertown-Fort Atkinson", add 
label define label_cbsa 48060 "Watertown-Fort Drum", add 
label define label_cbsa 48140 "Wausau", add 
label define label_cbsa 48180 "Waycross", add 
label define label_cbsa 48260 "Weirton-Steubenville", add 
label define label_cbsa 48300 "Wenatchee", add 
label define label_cbsa 48340 "West Helena", add 
label define label_cbsa 48460 "West Plains", add 
label define label_cbsa 48500 "West Point", add 
label define label_cbsa 48540 "Wheeling", add 
label define label_cbsa 48580 "Whitewater", add 
label define label_cbsa 48620 "Wichita", add 
label define label_cbsa 48660 "Wichita Falls", add 
label define label_cbsa 48700 "Williamsport", add 
label define label_cbsa 48740 "Willimantic", add 
label define label_cbsa 48780 "Williston", add 
label define label_cbsa 48820 "Willmar", add 
label define label_cbsa 48900 "Wilmington", add 
label define label_cbsa 48940 "Wilmington", add 
label define label_cbsa 48980 "Wilson", add 
label define label_cbsa 49020 "Winchester", add 
label define label_cbsa 49060 "Winfield", add 
label define label_cbsa 49100 "Winona", add 
label define label_cbsa 49180 "Winston-Salem", add 
label define label_cbsa 49260 "Woodward", add 
label define label_cbsa 49300 "Wooster", add 
label define label_cbsa 49340 "Worcester", add 
label define label_cbsa 49420 "Yakima", add 
label define label_cbsa 49460 "Yankton", add 
label define label_cbsa 49500 "Yauco", add 
label define label_cbsa 49620 "York-Hanover", add 
label define label_cbsa 49660 "Youngstown-Warren-Boardman", add 
label define label_cbsa 49700 "Yuba City", add 
label define label_cbsa 49740 "Yuma", add 
label define label_cbsa 49780 "Zanesville", add 
label values cbsa label_cbsa
label define label_cbsatype -2 "Not applicable" 
label define label_cbsatype 1 "Metropolitan Statistical Area", add 
label define label_cbsatype 2 "Micropolitan Statistical Area", add 
label values cbsatype label_cbsatype
label define label_csa -2 "Not applicable" 
label define label_csa 102 "Albany-Corvallis-Lebanon", add 
label define label_csa 104 "Albany-Schenectady-Amsterdam", add 
label define label_csa 112 "Ames-Boone", add 
label define label_csa 118 "Appleton-Oshkosh-Neenah", add 
label define label_csa 120 "Asheville-Brevard", add 
label define label_csa 122 "Atlanta-Sandy Springs-Gainesville", add 
label define label_csa 132 "Baton Rouge-Pierre Part", add 
label define label_csa 138 "Beckley-Oak Hill", add 
label define label_csa 140 "Bend-Prineville", add 
label define label_csa 142 "Birmingham-Hoover-Cullman", add 
label define label_csa 148 "Boston-Worcester-Manchester", add 
label define label_csa 154 "Brownsville-Harlingen-Raymondville", add 
label define label_csa 160 "Buffalo-Niagara-Cattaraugus", add 
label define label_csa 164 "Cape Girardeau-Sikeston-Jackson", add 
label define label_csa 172 "Charlotte-Gastonia-Salisbury", add 
label define label_csa 174 "Chattanooga-Cleveland-Athens", add 
label define label_csa 176 "Chicago-Naperville-Michigan City", add 
label define label_csa 178 "Cincinnati-Middletown-Wilmington", add 
label define label_csa 180 "Claremont-Lebanon", add 
label define label_csa 184 "Cleveland-Akron-Elyria", add 
label define label_csa 188 "Clovis-Portales", add 
label define label_csa 192 "Columbia-Newberry", add 
label define label_csa 194 "Columbus-Auburn-Opelika", add 
label define label_csa 198 "Columbus-Marion-Chillicothe", add 
label define label_csa 200 "Columbus-West Point", add 
label define label_csa 202 "Corbin-London", add 
label define label_csa 204 "Corpus Christi-Kingsville", add 
label define label_csa 206 "Dallas-Fort Worth", add 
label define label_csa 212 "Dayton-Springfield-Greenville", add 
label define label_csa 216 "Denver-Aurora-Boulder", add 
label define label_csa 218 "Des Moines-Newton-Pella", add 
label define label_csa 220 "Detroit-Warren-Flint", add 
label define label_csa 222 "Dothan-Enterprise-Ozark", add 
label define label_csa 232 "Eau Claire-Menomonie", add 
label define label_csa 242 "Fairmont-Clarksburg", add 
label define label_csa 244 "Fargo-Wahpeton", add 
label define label_csa 248 "Findlay-Tiffin", add 
label define label_csa 252 "Fond du Lac-Beaver Dam", add 
label define label_csa 256 "Fort Polk South-De Ridder", add 
label define label_csa 258 "Fort Wayne-Huntington-Auburn", add 
label define label_csa 260 "Fresno-Madera", add 
label define label_csa 266 "Grand Rapids-Muskegon-Holland", add 
label define label_csa 268 "Greensboro--Winston-Salem--High Point", add 
label define label_csa 273 "Greenville-Spartanburg-Anderson", add 
label define label_csa 274 "Gulfport-Biloxi-Pascagoula", add 
label define label_csa 276 "Harrisburg-Carlisle-Lebanon", add 
label define label_csa 278 "Hartford-West Hartford-Willimantic", add 
label define label_csa 288 "Houston-Baytown-Huntsville", add 
label define label_csa 290 "Huntsville-Decatur", add 
label define label_csa 292 "Idaho Falls-Blackfoot", add 
label define label_csa 294 "Indianapolis-Anderson-Columbus", add 
label define label_csa 296 "Ithaca-Cortland", add 
label define label_csa 297 "Jackson-Humboldt", add 
label define label_csa 298 "Jackson-Yazoo City", add 
label define label_csa 304 "Johnson City-Kingsport-Bristol (Tri-Cities)", add 
label define label_csa 308 "Jonesboro-Paragould", add 
label define label_csa 312 "Kansas City-Overland Park-Kansas City", add 
label define label_csa 314 "Knoxville-Sevierville-La Follette", add 
label define label_csa 316 "Kokomo-Peru", add 
label define label_csa 318 "Lafayette-Acadiana", add 
label define label_csa 320 "Lafayette-Frankfort", add 
label define label_csa 324 "Lake Charles-Jennings", add 
label define label_csa 330 "Lansing-East Lansing-Owosso", add 
label define label_csa 332 "Las Vegas-Paradise-Pahrump", add 
label define label_csa 336 "Lexington-Fayette--Frankfort--Richmond", add 
label define label_csa 338 "Lima-Van Wert-Wapakoneta", add 
label define label_csa 340 "Little Rock-North Little Rock-Pine Bluff", add 
label define label_csa 346 "Longview-Marshall", add 
label define label_csa 348 "Los Angeles-Long Beach-Riverside", add 
label define label_csa 350 "Louisville-Jefferson County--Elizabethtown-Scottsburg", add 
label define label_csa 352 "Lubbock-Levelland", add 
label define label_csa 354 "Lumberton-Laurinburg", add 
label define label_csa 356 "Macon-Warner Robins-Fort Valley", add 
label define label_csa 358 "Madison-Baraboo", add 
label define label_csa 360 "Mansfield-Bucyrus", add 
label define label_csa 364 "Mayagüez-San Germán-Cabo Rojo", add 
label define label_csa 372 "Midland-Odessa", add 
label define label_csa 376 "Milwaukee-Racine-Waukesha", add 
label define label_csa 378 "Minneapolis-St. Paul-St. Cloud", add 
label define label_csa 380 "Mobile-Daphne-Fairhope", add 
label define label_csa 384 "Monroe-Bastrop", add 
label define label_csa 388 "Montgomery-Alexander City", add 
label define label_csa 392 "Morristown-Newport", add 
label define label_csa 396 "Myrtle Beach-Conway-Georgetown", add 
label define label_csa 400 "Nashville-Davidson--Murfreesboro--Columbia", add 
label define label_csa 406 "New Orleans-Metairie-Bogalusa", add 
label define label_csa 408 "New York-Newark-Bridgeport", add 
label define label_csa 416 "Oklahoma City-Shawnee", add 
label define label_csa 420 "Omaha-Council Bluffs-Fremont", add 
label define label_csa 422 "Orlando-Deltona-Daytona Beach", add 
label define label_csa 424 "Paducah-Mayfield", add 
label define label_csa 426 "Peoria-Canton", add 
label define label_csa 428 "Philadelphia-Camden-Vineland", add 
label define label_csa 430 "Pittsburgh-New Castle", add 
label define label_csa 434 "Ponce-Yauco-Coamo", add 
label define label_csa 438 "Portland-Lewiston-South Portland", add 
label define label_csa 442 "Port St. Lucie-Sebastian-Vero Beach", add 
label define label_csa 450 "Raleigh-Durham-Cary", add 
label define label_csa 456 "Reno-Sparks-Fernley", add 
label define label_csa 464 "Rochester-Batavia-Seneca Falls", add 
label define label_csa 466 "Rockford-Freeport-Rochelle", add 
label define label_csa 472 "Sacramento--Arden-Arcade--Yuba City", add 
label define label_csa 474 "Saginaw-Bay City-Saginaw Township North", add 
label define label_csa 476 "St. Louis-St. Charles-Farmington", add 
label define label_csa 480 "Salisbury-Ocean Pines", add 
label define label_csa 482 "Salt Lake City-Ogden-Clearfield", add 
label define label_csa 488 "San Jose-San Francisco-Oakland", add 
label define label_csa 490 "San Juan-Caguas-Fajardo", add 
label define label_csa 492 "Santa Fe-Espanola", add 
label define label_csa 494 "Sarasota-Bradenton-Punta Gorda", add 
label define label_csa 496 "Savannah-Hinesville-Fort Stewart", add 
label define label_csa 500 "Seattle-Tacoma-Olympia", add 
label define label_csa 508 "Shreveport-Bossier City-Minden", add 
label define label_csa 512 "Sioux City-Vermillion", add 
label define label_csa 515 "South Bend-Elkhart-Mishakawa", add 
label define label_csa 526 "Sunbury-Lewisburg-Selinsgrove", add 
label define label_csa 532 "Syracuse-Auburn", add 
label define label_csa 534 "Toledo-Fremont", add 
label define label_csa 538 "Tulsa-Bartlesville", add 
label define label_csa 540 "Tyler-Jacksonville", add 
label define label_csa 542 "Union City-Martin", add 
label define label_csa 548 "Washington-Baltimore-Northern Virginia", add 
label define label_csa 554 "Wausau-Merrill", add 
label define label_csa 556 "Wichita-Winfield", add 
label define label_csa 558 "Williamsport-Lock Haven", add 
label define label_csa 564 "York-Hanover-Gettysburg", add 
label define label_csa 566 "Youngstown-Warren-East Liverpool", add 
label values csa label_csa
label define label_necta -2 "Not applicable" 
label define label_necta 70300 "Amherst Center, MA", add 
label define label_necta 70600 "Augusta, ME", add 
label define label_necta 70750 "Bangor, ME", add 
label define label_necta 70900 "Barnstable Town, MA", add 
label define label_necta 71050 "Barre, VT", add 
label define label_necta 71350 "Bennington, VT", add 
label define label_necta 71500 "Berlin, NH", add 
label define label_necta 71650 "Boston-Cambridge-Quincy, MA-NH", add 
label define label_necta 71950 "Bridgeport-Stamford-Norwalk, CT", add 
label define label_necta 72250 "Brunswick, ME", add 
label define label_necta 72400 "Burlington-South Burlington, VT", add 
label define label_necta 72500 "Claremont, NH", add 
label define label_necta 72700 "Concord, NH", add 
label define label_necta 72850 "Danbury, CT", add 
label define label_necta 73000 "Danielson, CT", add 
label define label_necta 73300 "Greenfield, MA", add 
label define label_necta 73450 "Hartford-West Hartford-East Hartford, CT", add 
label define label_necta 73750 "Keene, NH", add 
label define label_necta 73900 "Laconia, NH", add 
label define label_necta 74350 "Lebanon, NH-VT", add 
label define label_necta 74500 "Leominster-Fitchburg-Gardner, MA", add 
label define label_necta 74650 "Lewiston-Auburn, ME", add 
label define label_necta 74950 "Manchester, NH", add 
label define label_necta 75550 "New Bedford, MA", add 
label define label_necta 75700 "New Haven, CT", add 
label define label_necta 76150 "North Adams, MA-VT", add 
label define label_necta 76450 "Norwich-New London, CT-RI", add 
label define label_necta 76600 "Pittsfield, MA", add 
label define label_necta 76750 "Portland-South Portland-Biddeford, ME", add 
label define label_necta 76900 "Portsmouth, NH-ME", add 
label define label_necta 77200 "Providence-Fall River-Warwick, RI-MA", add 
label define label_necta 77350 "Rochester-Dover, NH-ME", add 
label define label_necta 77650 "Rutland, VT", add 
label define label_necta 77950 "Sanford, ME", add 
label define label_necta 78100 "Springfield, MA-CT", add 
label define label_necta 78400 "Torrington, CT", add 
label define label_necta 78700 "Waterbury, CT", add 
label define label_necta 78850 "Waterville, ME", add 
label define label_necta 79300 "Willimantic, CT", add 
label define label_necta 79600 "Worcester, MA-CT", add 
label values necta label_necta
label define label_dfrcgid -2 "Not applicable - not Title iv or institution is inactive" 
label define label_dfrcgid 1 "Public, academic year reporter, nondegree-granting/1", add 
label define label_dfrcgid 10 "Public, nondegree-granting, largest program-other than business,cosmetolgy,health", add 
label define label_dfrcgid 100 "Associates--Public Suburban-serving Multicampus/1", add 
label define label_dfrcgid 101 "Associates--Public Suburban-serving Multicampus/2", add 
label define label_dfrcgid 102 "Associates--Public Suburban-serving Multicampus/3", add 
label define label_dfrcgid 103 "Associates--Public Suburban-serving Multicampus/4", add 
label define label_dfrcgid 104 "Associates--Public Suburban-serving Multicampus/5", add 
label define label_dfrcgid 105 "Associates--Public Special Use", add 
label define label_dfrcgid 106 "Associates--Private not-for-profit/1", add 
label define label_dfrcgid 107 "Associates--Private not-for-profit/2", add 
label define label_dfrcgid 108 "Associates--Private not-for-profit/3", add 
label define label_dfrcgid 109 "Associates--Private for-profit, New England", add 
label define label_dfrcgid 11 "Private not-for-profit, academic year reporter, nondegree-granting/1", add 
label define label_dfrcgid 110 "Associates--Private for-profit, Mid-Atlantic/1", add 
label define label_dfrcgid 111 "Associates--Private for-profit, Mid-Atlantic/2", add 
label define label_dfrcgid 112 "Associates--Private for-profit, Mid-Atlantic/3", add 
label define label_dfrcgid 113 "Associates--Private for-profit, Mid-Atlantic/4", add 
label define label_dfrcgid 114 "Associates--Private for-profit, Great Lakes/1", add 
label define label_dfrcgid 115 "Associates--Private for-profit, Great Lakes/2", add 
label define label_dfrcgid 116 "Associates--Private for-profit, Great Lakes/3", add 
label define label_dfrcgid 117 "Associates--Private for-profit, Plains", add 
label define label_dfrcgid 118 "Associates--Private for-profit, Southeast/1", add 
label define label_dfrcgid 119 "Associates--Private for-profit, Southeast/2", add 
label define label_dfrcgid 12 "Private not-for-profit, academic year reporter, nondegree-granting/2", add 
label define label_dfrcgid 120 "Associates--Private for-profit, Southeast/3", add 
label define label_dfrcgid 121 "Associates--Private for-profit, Southeast/4", add 
label define label_dfrcgid 122 "Associates--Private for-profit, Southeast/5", add 
label define label_dfrcgid 123 "Associates--Private for-profit, Southwest/1", add 
label define label_dfrcgid 124 "Associates--Private for-profit, Southwest/2", add 
label define label_dfrcgid 125 "Associates--Private for-profit, Rocky Mountain", add 
label define label_dfrcgid 126 "Associates--Private for-profit, Far West/1", add 
label define label_dfrcgid 127 "Associates--Private for-profit, Far West/2", add 
label define label_dfrcgid 128 "Associates--Public 2-year colleges under 4-year universities/1", add 
label define label_dfrcgid 129 "Associates--Public 2-year colleges under 4-year universities/2", add 
label define label_dfrcgid 13 "Private not-for-profit, academic year reporter, nondegree-granting/3", add 
label define label_dfrcgid 130 "Associates--Public 4-year Primarily Associates", add 
label define label_dfrcgid 131 "Associates--Private not-for-profit 4-year, Primarily Associates", add 
label define label_dfrcgid 132 "Associates--Private for-profit 4-year, Primarily Associates/1", add 
label define label_dfrcgid 133 "Associates--Private for-profit 4-year, Primarily Associates/2", add 
label define label_dfrcgid 134 "Research Universities (very high research activity), Public/1", add 
label define label_dfrcgid 135 "Research Universities (very high research activity), Public/2", add 
label define label_dfrcgid 136 "Research Universities (very high research activity), Private not-for-profit", add 
label define label_dfrcgid 137 "Research Universities (high research activity), Public", add 
label define label_dfrcgid 138 "Research Universities (high research activity), Public", add 
label define label_dfrcgid 139 "Research Universities (high research activity), Private not-for-profit", add 
label define label_dfrcgid 14 "Private not-for-profit, nondegree-granting, largest program-health/1", add 
label define label_dfrcgid 140 "Doctoral/Research Universities, Public", add 
label define label_dfrcgid 141 "Doctoral/Research Universities, Private not-for-profit", add 
label define label_dfrcgid 142 "Doctoral/Research Universities, Private for-profit", add 
label define label_dfrcgid 143 "Masters Colleges & Universities (larger programs),  Public/1", add 
label define label_dfrcgid 144 "Masters Colleges & Universities (larger programs),  Public/2", add 
label define label_dfrcgid 145 "Masters Colleges & Universities (larger programs),  Public/3", add 
label define label_dfrcgid 146 "Masters Colleges & Universities (larger programs),  Public/4", add 
label define label_dfrcgid 147 "Masters Colleges & Universities (larger programs),  Public/5", add 
label define label_dfrcgid 148 "Masters Colleges & Universities (larger programs),  Private not-for-profit/1", add 
label define label_dfrcgid 149 "Masters Colleges & Universities (larger programs),  Private not-for-profit/2", add 
label define label_dfrcgid 15 "Private not-for-profit, nondegree-granting, largest program-health/2", add 
label define label_dfrcgid 150 "Masters Colleges & Universities (larger programs),  Private not-for-profit/3", add 
label define label_dfrcgid 151 "Masters Colleges & Universities (larger programs),  Private not-for-profit/4", add 
label define label_dfrcgid 152 "Masters Colleges & Universities (larger programs),  Private not-for-profit/5", add 
label define label_dfrcgid 153 "Masters Colleges & Universities (larger programs), Private for-profit", add 
label define label_dfrcgid 154 "Masters Colleges & Universities (medium programs), Public/1", add 
label define label_dfrcgid 155 "Masters Colleges & Universities (medium programs), Public/2", add 
label define label_dfrcgid 156 "Masters Colleges & Universities (medium programs), Private not-for-profit/1", add 
label define label_dfrcgid 157 "Masters Colleges & Universities (medium programs), Private not-profit/2", add 
label define label_dfrcgid 158 "Masters Colleges & Universities (medium programs), Private not-for-profit/3", add 
label define label_dfrcgid 159 "Masters Colleges & Universities (medium programs), Private for-profit", add 
label define label_dfrcgid 16 "Private not-for-profit, nondegree-granting, largest program-other than health/1", add 
label define label_dfrcgid 160 "Masters Colleges & Universities (smaller programs), Public", add 
label define label_dfrcgid 161 "Masters Colleges & Universities (smaller programs), Private not-for-profit/1", add 
label define label_dfrcgid 162 "Masters Colleges & Universities (smaller programs), Private not-for-profit/2", add 
label define label_dfrcgid 163 "Masters Colleges & Universities (smaller programs), Private not-for-profit/3", add 
label define label_dfrcgid 164 "Masters Colleges & Universities (smaller programs), Private for-profit", add 
label define label_dfrcgid 165 "Baccalaureate Colleges--Arts & Sciences, Public", add 
label define label_dfrcgid 166 "Baccalaureate Colleges--Arts & Sciences, Private not-for-profit/1", add 
label define label_dfrcgid 167 "Baccalaureate Colleges--Arts & Sciences, Private not-for-profit/2", add 
label define label_dfrcgid 168 "Baccalaureate Colleges--Arts & Sciences, Private not-for-profit/3", add 
label define label_dfrcgid 169 "Baccalaureate Colleges--Arts & Sciences, Private not-for-profit/4", add 
label define label_dfrcgid 17 "Private not-for-profit, nondegree-granting, largest program-other than health/2", add 
label define label_dfrcgid 170 "Baccalaureate Colleges--Arts & Sciences, Private not-for-profit/5", add 
label define label_dfrcgid 171 "Baccalaureate Colleges--Arts & Sciences, Private not-for-profit/6", add 
label define label_dfrcgid 172 "Baccalaureate Colleges--Arts & Sciences, Private not-for-profit/7", add 
label define label_dfrcgid 173 "Baccalaureate Colleges--Arts & Sciences, Private not-for-profit/8", add 
label define label_dfrcgid 174 "Baccalaureate Colleges--Diverse Fields, Public/1", add 
label define label_dfrcgid 175 "Baccalaureate Colleges--Diverse Fields, Public/2", add 
label define label_dfrcgid 176 "Baccalaureate Colleges--Diverse Fields,  Private not-for-profit/1", add 
label define label_dfrcgid 177 "Baccalaureate Colleges--Diverse Fields,  Private not-for-profit/2", add 
label define label_dfrcgid 178 "Baccalaureate Colleges--Diverse Fields,  Private not-for-profit/3", add 
label define label_dfrcgid 179 "Baccalaureate Colleges--Diverse Fields,  Private not-for-profit/4", add 
label define label_dfrcgid 18 "Private for-profit, academic year reporter, nondegree-granting/1", add 
label define label_dfrcgid 180 "Baccalaureate Colleges--Diverse Fields,  Private not-for-profit/5", add 
label define label_dfrcgid 181 "Baccalaureate Colleges--Diverse Fields,  Private not-for-profit/6", add 
label define label_dfrcgid 182 "Baccalaureate Colleges--Diverse Fields,  Private not-for-profit/7", add 
label define label_dfrcgid 183 "Baccalaureate Colleges--Diverse Fields,  Private not-for-profit/8", add 
label define label_dfrcgid 184 "Baccalaureate/Associates Colleges, Public", add 
label define label_dfrcgid 185 "Baccalaureate/Associates Colleges, Private not-for-profit", add 
label define label_dfrcgid 186 "Baccalaureate/Associates Colleges, Private for-profit/1", add 
label define label_dfrcgid 187 "Baccalaureate/Associates Colleges, Prviate for-profit/2", add 
label define label_dfrcgid 188 "Theological seminaries, Bible colleges, other faith-related, highest level-bachelors degree/1", add 
label define label_dfrcgid 189 "Theological seminaries, Bible colleges, other faith-related, highest level-bachelors degree/2", add 
label define label_dfrcgid 19 "Private for-profit, academic year reporter, nondegree-granting/2", add 
label define label_dfrcgid 190 "Theological seminaries, Bible colleges, other faith-related, highest level-postbacc/1", add 
label define label_dfrcgid 191 "Theological seminaries, Bible colleges, other faith-related, highest level-postbacc/2", add 
label define label_dfrcgid 192 "Theological seminaries, Bible colleges, other faith-related, highest level-postbacc, no undergraduate degrees or certificates", add 
label define label_dfrcgid 193 "Theological seminaries, Bible colleges, other faith-related, highest level-PhD., undergraduate degrees/1", add 
label define label_dfrcgid 194 "Theological seminaries, Bible colleges, other faith-related, highest level-PhD., undergraduate degrees/2", add 
label define label_dfrcgid 195 "Theological seminaries, Bible colleges, other faith-related, highest level-PhD., no undergraduate degrees or certificates/1", add 
label define label_dfrcgid 196 "Theological seminaries, Bible colleges, other faith-related, highest level-PhD., no undergraduate degrees or certificates/2", add 
label define label_dfrcgid 197 "Medical schools and medical centers/1", add 
label define label_dfrcgid 198 "Medical schools and medical centers/2", add 
label define label_dfrcgid 199 "Other health professions schools, highest level of offering-bachelors degree", add 
label define label_dfrcgid 2 "Public, academic year reporter, nondegree-granting/2", add 
label define label_dfrcgid 20 "Private for-profit, academic year reporter, nondegree-granting/3", add 
label define label_dfrcgid 200 "Other health professions schools, highest level of offering-postbaccalaureate/1", add 
label define label_dfrcgid 201 "Other health professions schools, highest level of offering-postbaccalaureate/2", add 
label define label_dfrcgid 202 "Other health professions schools, highest level of offering-postbaccalaureate/3", add 
label define label_dfrcgid 203 "Schools of engineering", add 
label define label_dfrcgid 204 "Other technology-related schools/1", add 
label define label_dfrcgid 205 "Other technology-related schools/2", add 
label define label_dfrcgid 206 "Schools of business and management/1", add 
label define label_dfrcgid 207 "Schools of business and management/2", add 
label define label_dfrcgid 208 "Schools of art, music, and design, highest level of offering- bachelors degree", add 
label define label_dfrcgid 209 "Schools of art, music, and design, highest level of offering-postbaccalaureate/1", add 
label define label_dfrcgid 21 "Private for-profit, academic year reporter, nondegree-granting/4", add 
label define label_dfrcgid 210 "Schools of art, music, and design, highest level of offering-postbaccalaureate/2", add 
label define label_dfrcgid 211 "Schools of law", add 
label define label_dfrcgid 212 "Other special-focus institutions", add 
label define label_dfrcgid 213 "Tribal Colleges", add 
label define label_dfrcgid 214 "Baccalaureate Colleges--Arts & Sciences or Diverse Fields, Private for-profit", add 
label define label_dfrcgid 215 "For-profit, 4 year, degree-granting no Carnegie classification and highest degree-Masters", add 
label define label_dfrcgid 216 "For-profit, 4 year, degree-granting no Carnegie classification and highest degree-Bachelors", add 
label define label_dfrcgid 217 "Not-for-profit, 4 year, degree-granting institution with no Carnegie classification", add 
label define label_dfrcgid 218 "Public, degree-granting in Puerto Rico", add 
label define label_dfrcgid 219 "Not-for-profit, degree-granting in Puerto Rico", add 
label define label_dfrcgid 22 "Private for-profit, nondegree-granting, largest program-cosmetology/1", add 
label define label_dfrcgid 220 "Not-for-profit, nondegree-granting in Puerto Rico", add 
label define label_dfrcgid 221 "For-profit, degree-granting in Puerto Rico", add 
label define label_dfrcgid 222 "Private for-profit, nondegree-granting in Puerto Rico/1", add 
label define label_dfrcgid 223 "Private for-profit, nondegree-granting in Puerto Rico/2", add 
label define label_dfrcgid 23 "Private for-profit, nondegree-granting, largest program-cosmetology/2", add 
label define label_dfrcgid 24 "Private for-profit, nondegree-granting, largest program-cosmetology/3", add 
label define label_dfrcgid 25 "Private for-profit, nondegree-granting, largest program-cosmetology/4", add 
label define label_dfrcgid 26 "Private for-profit, nondegree-granting, largest program-cosmetology/5", add 
label define label_dfrcgid 27 "Private for-profit, nondegree-granting, largest program-cosmetology/6", add 
label define label_dfrcgid 28 "Private for-profit, nondegree-granting, largest program-cosmetology/7", add 
label define label_dfrcgid 29 "Private for-profit, nondegree-granting, largest program-cosmetology/8", add 
label define label_dfrcgid 3 "Public, nondegree-granting, largest program-business", add 
label define label_dfrcgid 30 "Private for-profit, nondegree-granting, largest program-cosmetology/9", add 
label define label_dfrcgid 31 "Private for-profit, nondegree-granting, largest program-cosmetology/10", add 
label define label_dfrcgid 32 "Private for-profit, nondegree-granting, largest program-cosmetology/11", add 
label define label_dfrcgid 33 "Private for-profit, nondegree-granting, largest program-cosmetology/12", add 
label define label_dfrcgid 34 "Private for-profit, nondegree-granting, largest program-cosmetology/13", add 
label define label_dfrcgid 35 "Private for-profit, nondegree-granting, largest program-cosmetology/14", add 
label define label_dfrcgid 36 "Private for-profit, nondegree-granting, largest program-cosmetology/15", add 
label define label_dfrcgid 37 "Private for-profit, nondegree-granting, largest program-cosmetology/16", add 
label define label_dfrcgid 38 "Private for-profit, nondegree-granting, largest program-cosmetology/17", add 
label define label_dfrcgid 39 "Private for-profit, nondegree-granting, largest program-cosmetology/18", add 
label define label_dfrcgid 4 "Public, nondegree-granting, largest program-cosmetology", add 
label define label_dfrcgid 40 "Private for-profit, nondegree-granting, largest program-cosmetology/19", add 
label define label_dfrcgid 41 "Private for-profit, nondegree-granting, largest program-cosmetology/20", add 
label define label_dfrcgid 42 "Private for-profit, nondegree-granting, largest program-cosmetology/21", add 
label define label_dfrcgid 43 "Private for-profit, nondegree-granting, largest program-cosmetology/22", add 
label define label_dfrcgid 44 "Private for-profit, nondegree-granting, largest program-cosmetology/23", add 
label define label_dfrcgid 45 "Private for-profit, nondegree-granting, largest program-cosmetology/24", add 
label define label_dfrcgid 46 "Private for-profit, nondegree-granting, largest program-cosmetology/25", add 
label define label_dfrcgid 47 "Private for-profit, nondegree-granting, largest program-cosmetology/26", add 
label define label_dfrcgid 48 "Private for-profit, nondegree-granting, largest program-cosmetology/27", add 
label define label_dfrcgid 49 "Private for-profit, nondegree-granting, largest program-cosmetology/28", add 
label define label_dfrcgid 5 "Public, nondegree-granting, largest program-health/1", add 
label define label_dfrcgid 50 "Private for-profit, nondegree-granting, largest program-cosmetology/29", add 
label define label_dfrcgid 51 "Private for-profit, nondegree-granting, largest program-cosmetology/30", add 
label define label_dfrcgid 52 "Private for-profit, nondegree-granting, largest program-cosmetology/31", add 
label define label_dfrcgid 53 "Private for-profit, nondegree-granting, largest program-cosmetology/32", add 
label define label_dfrcgid 54 "Private for-profit, nondegree-granting, largest program-health/1", add 
label define label_dfrcgid 55 "Private for-profit, nondegree-granting, largest program-health/2", add 
label define label_dfrcgid 56 "Private for-profit, nondegree-granting, largest program-health/3", add 
label define label_dfrcgid 57 "Private for-profit, nondegree-granting, largest program-health/4", add 
label define label_dfrcgid 58 "Private for-profit, nondegree-granting, largest program-health/5", add 
label define label_dfrcgid 59 "Private for-profit, nondegree-granting, largest program-health/6", add 
label define label_dfrcgid 6 "Public, nondegree-granting, largest program-health/2", add 
label define label_dfrcgid 60 "Private for-profit, nondegree-granting, largest program-health/7", add 
label define label_dfrcgid 61 "Private for-profit, nondegree-granting, largest program-health/8", add 
label define label_dfrcgid 62 "Private for-profit, nondegree-granting, largest program-health/9", add 
label define label_dfrcgid 63 "Private for-profit, nondegree-granting, largest program-health/10", add 
label define label_dfrcgid 64 "Private for-profit, nondegree-granting, largest program-health/11", add 
label define label_dfrcgid 65 "Private for-profit, nondegree-granting, largest program-health/12", add 
label define label_dfrcgid 66 "Private for-profit, nondegree-granting, largest program-health/13", add 
label define label_dfrcgid 67 "Private for-profit, nondegree-granting, largest program-other than cosmetology and health/1", add 
label define label_dfrcgid 68 "Private for-profit, nondegree-granting, largest program-other than cosmetology and health/2", add 
label define label_dfrcgid 69 "Private for-profit, nondegree-granting, largest program-other than cosmetology and,health/3", add 
label define label_dfrcgid 7 "Public, nondegree-granting, largest program-health/3", add 
label define label_dfrcgid 70 "Private for-profit, nondegree-granting, largest program-other than cosmetology and health/4", add 
label define label_dfrcgid 71 "Private for-profit, nondegree-granting, largest program-other than cosmetology and health/5", add 
label define label_dfrcgid 72 "Associates--Public Rural-serving Small/1", add 
label define label_dfrcgid 73 "Associates--Public Rural-serving Small/2", add 
label define label_dfrcgid 74 "Associates--Public Rural-serving Small/3", add 
label define label_dfrcgid 75 "Associates--Public Rural-serving Small/4", add 
label define label_dfrcgid 76 "Associates--Public Rural-serving Medium, New England", add 
label define label_dfrcgid 77 "Associates--Public Rural-serving Medium, Mid-Atlantic", add 
label define label_dfrcgid 78 "Associates--Public Rural-serving Medium, Great Lakes", add 
label define label_dfrcgid 79 "Associates--Public Rural-serving Medium, Plains", add 
label define label_dfrcgid 8 "Public, nondegree-granting, largest program-health/4", add 
label define label_dfrcgid 80 "Associates--Public Rural-serving Medium, Southeast/1", add 
label define label_dfrcgid 81 "Associates--Public Rural-serving Medium, Southeast/2", add 
label define label_dfrcgid 82 "Associates--Public Rural-serving Medium, Southeast/3", add 
label define label_dfrcgid 83 "Associates--Public Rural-serving Medium, Southeast/4", add 
label define label_dfrcgid 84 "Associates--Public Rural-serving Medium, Southwest", add 
label define label_dfrcgid 85 "Associates--Public Rural-serving Medium,  Rocky Mountains", add 
label define label_dfrcgid 86 "Associates--Public Rural-serving Medium,  Far West", add 
label define label_dfrcgid 87 "Associates--Public Rural-serving Large/1", add 
label define label_dfrcgid 88 "Associates--Public Rural-serving Large/2", add 
label define label_dfrcgid 89 "Associates--Public Rural-serving Large/3", add 
label define label_dfrcgid 9 "Public, nondegree-granting, largest program-health/5", add 
label define label_dfrcgid 90 "Associates--Public Rural-serving Large/4", add 
label define label_dfrcgid 901 "Not applicable - U.S.  Service schools", add 
label define label_dfrcgid 902 "Not applicable - Public 4-year institutions (America Samoa, Guam, Northern Marianas)", add 
label define label_dfrcgid 903 "Not applicable - Public 2-year institutions (America Samoa, Guam, Northern Marianas)", add 
label define label_dfrcgid 904 "Not applicable - Private not-for-profit (America Samoa, Guam, Northern Mariansas)", add 
label define label_dfrcgid 91 "Associates--Public Rural-serving Large/5", add 
label define label_dfrcgid 92 "Associates--Public Suburban-serving Single Campus/1", add 
label define label_dfrcgid 93 "Associates--Public Suburban-serving Single Campus/2", add 
label define label_dfrcgid 94 "Associates--Public Suburban-serving Single Campus/3", add 
label define label_dfrcgid 95 "Associates--Public Suburban-serving Single Campus/4", add 
label define label_dfrcgid 96 "Associates--Public Suburban-serving Multicampus/1", add 
label define label_dfrcgid 97 "Associates--Public Suburban-serving Multicampus/2", add 
label define label_dfrcgid 98 "Associates--Public Suburban-serving Multicampus/3", add 
label define label_dfrcgid 99 "Associates--Public Urban-serving Single Campus", add 
label values dfrcgid label_dfrcgid
tab stabbr
tab fips
tab obereg
tab opeflag
tab sector
tab iclevel
tab control
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
tab locale
tab openpubl
tab act
tab deathyr
tab cyactive
tab postsec
tab pseflag
tab pset4flg
tab rptmth
tab instcat
tab ccbasic
tab ccipug
tab ccipgrad
tab ccugprof
tab ccenrprf
tab ccsizset
tab carnegie
tab tenursys
tab landgrnt
tab instsize
tab cbsa
tab cbsatype
tab csa
tab necta
tab dfrcgid
summarize newid
save dct_hd2007

