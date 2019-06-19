* Created: 2/23/2007 2:14:03 PM
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
insheet using "../Raw Data/hd2005_data_stata.csv", comma clear
label data "dct_hd2005"
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
label variable fintele "Financial aid office telephone number"
label variable admtele "Admissions office telephone number"
label variable ein "Employer Identification Number"
label variable duns "Dunn and Bradstreet identification number"
label variable opeid "Office of Postsecondary Education (OPE) ID Number"
label variable opeflag "OPE Title IV eligibility indicator code"
label variable webaddr "Institution^s internet website address"
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
label variable fte "Full-time equivalent enrollment"
label variable instsize "Institution size category"
label variable enrtot "Total  enrollment"
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
label define label_opeflag 5 "Not currently participating in Title IV, has an OPE ID number", add 
label define label_opeflag 6 "Not currently participating in Title IV, does not have OPE ID number", add 
label define label_opeflag 7 "Stopped participating during the survey year", add 
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
label define label_hbcu -3 "{Not available}" 
label define label_hbcu 1 "Yes", add 
label define label_hbcu 2 "No", add 
label values hbcu label_hbcu
label define label_hospital -1 "Not reported" 
label define label_hospital -2 "Not applicable", add 
label define label_hospital 1 "Yes", add 
label values hospital label_hospital
label define label_medical -1 "Not reported" 
label define label_medical -2 "Not applicable", add 
label define label_medical 1 "Yes", add 
label define label_medical 2 "No", add 
label values medical label_medical
label define label_tribal -3 "{Not available}" 
label define label_tribal 1 "Yes", add 
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
label define label_act M "Death with data - closed in current yr", add 
label define label_act N "New - added during the current year", add 
label define label_act P "Potential new/add institution", add 
label define label_act Q "Potential restore institution", add 
label define label_act R "Restore - restored to the current universe", add 
label define label_act W "Potential add not within scope of IPEDS", add 
label define label_act X "Potential restore not within scope of IPEDS", add 
label values act label_act
label define label_closedat -2 "{Item not applicable}" 
label define label_closedat Alpha "{Alpha}", add 
label values closedat label_closedat
*/
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
label define label_instcat 3 "Degree-granting, other baccalaureate granting", add 
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
label define label_tenursys 0 "No tenure system", add 
label define label_tenursys 1 "Has tenure system", add 
label values tenursys label_tenursys
label define label_landgrnt 0 "Not a Land Grant Institution" 
label define label_landgrnt 1 "Land Grant Institution", add 
label values landgrnt label_landgrnt
label define label_instsize -1 "Not reported" 
label define label_instsize -2 "Not applicable", add 
label define label_instsize 1 "Under 1,000", add 
label define label_instsize 2 "1,000 - 4,999", add 
label define label_instsize 3 "5,000 - 9,999", add 
label define label_instsize 4 "10,000 - 19,999", add 
label define label_instsize 5 "20,000 and above", add 
label values instsize label_instsize
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
summarize newid
summarize fte
summarize enrtot
save dct_hd2005

