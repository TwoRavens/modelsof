* Created: 6/13/2004 7:38:14 AM
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
insheet using "../Raw Data/ic1987_a_data_stata.csv", comma clear
label data "dct_ic1987_a"
label variable unitid "unitid"
label variable city "City location of institution"
label variable stabbr "Post office state abbreviation code"
label variable fips "FIPS state code"
label variable obereg "OBE region code"
label variable fice "FICE code"
label variable rstatus "rstatus"
label variable unitidx "UNITID of parent institution reporting full-year enrollment"
label variable sector "Sector of institution"
label variable iclevel "Level of institution"
label variable control "Control of institution"
label variable affil "Affiliation of institution"
label variable hloffer "Highest level of offering"
label variable fpoffer "First-professional offering"
label variable formrt "Survey forms IC1, IC2, IC3, IC4, IC-Add"
label variable resplast "Respondent status last year"
label variable respstat "Respondent status this year"
label variable addr "Street address or post office box"
label variable zip "ZIP + four"
label variable countynm "County name"
label variable congdist "Congressional district"
label variable gentele "General information telephone number"
label variable peo1istr "Occupational"
label variable peo2istr "Academic"
label variable peo3istr "Continuing professional"
label variable peo4istr "Recreational or avocational"
label variable peo5istr "Adult basic, remedial, or high school equivalency"
label variable peo6istr "Secondary (high school)"
label variable multype "Administrative unit only (entity is a central, system, or coporate office)"
label variable public1 "Federal"
label variable public2 "State"
label variable public3 "Territorial"
label variable public4 "School district"
label variable public5 "County"
label variable public6 "Township"
label variable public7 "City"
label variable public8 "Special district"
label variable public9 "Public - other"
label variable private1 "Profit-making"
label variable private2 "Not-for-profit"
label variable private3 "Independent (no religious affiliation)"
label variable private4 "Religious affiliation (general)"
label variable private5 "Catholic"
label variable private6 "Jewish"
label variable private7 "Protestant"
label variable private8 "Private institution type- other"
label variable protaffl "Protestant affiliation, specified"
label variable othaffl "Other affiliation, specified"
label variable level1 "Less than one year"
label variable level2 "More than one but less than two years"
label variable level3 "Associate^s Degree"
label variable level4 "Two but less than four years"
label variable level5 "Bachelor^s Degree"
label variable level6 "Postbaccalaureate Certificate"
label variable level7 "Master^s Degree"
label variable level8 "Post-Masters Certificate"
label variable level9 "Doctor^s Degree"
label variable level10 "First-Professional Degree"
label variable level11 "First-Professional Certificate (post-degree)"
label variable level12 "Other award level"
label variable leveloth "Other award level specified"
label variable fopna "Programs not leading to a formal award"
label variable fopna1 "FOPNA are undergraduate programs"
label variable fopna2 "FOPNA are graduate programs"
label variable accrd1 "National or specialized accrediting agency"
label variable accrd2 "Regional accrediting agency"
label variable accrd3 "State accrediting or approval agency"
label variable accrd4 "Accredit not applicable"
label variable saccr "Accredited by agency recognized by USED"
label variable acc1 "Engineering"
label variable acc2 "Engineering Technology"
label variable acc3 "Medical Assistant Education"
label variable acc4 "Medical Laboratory Technician Education"
label variable acc5 "Applied Health Education"
label variable acc6 "Health Services Administration"
label variable acc7 "Journalism and Mass Communications"
label variable acc8 "Microbiology"
label variable acc9 "Business (BUS)"
label variable acc10 "Business (BUSA)"
label variable acc11 "Bible College Education"
label variable acc12 "Marriage and Family Therapy Clinical"
label variable acc13 "Marriage and Family Therapy Graduate"
label variable acc14 "Nurse Anesthesia"
label variable acc15 "Law"
label variable acc16 "Funeral Service Education"
label variable acc17 "Nurse Midwifery"
label variable acc18 "Pharmacy"
label variable acc19 "Dental Assisting"
label variable acc20 "Dental Hygiene"
label variable acc21 "Dental Technology"
label variable acc22 "Dentistry"
label variable acc23 "Dietetics - Coordinated undergraduate programs"
label variable acc24 "Dietetics - Postbaccalaureate internship programs"
label variable acc25 "Librarianship"
label variable acc26 "Physician Assistant"
label variable acc27 "Specialist in Blood Bank Technology"
label variable acc28 "Cytotechnologist"
label variable acc29 "Diagnostic Medical Sonographer"
label variable acc30 "Electroneurodiagnostic Technician"
label variable acc31 "Emergency Medical Technician"
label variable acc32 "Histologic Technician/Technologist"
label variable acc33 "Medical Assistant (MA)"
label variable acc34 "Medical Laboratory Technician (MLTAD) - Associate degree"
label variable acc35 "Medical Laboratory Technician (MLTC) - Certificate"
label variable acc36 "Medical Record Administrator"
label variable acc37 "Medical Record Technician"
label variable acc38 "Medical Technologist"
label variable acc39 "Nuclear Medicine Technologist"
label variable acc40 "Ophthalmic Medical Assistant"
label variable acc41 "Occupational Therapist"
label variable acc42 "Perfusionist"
label variable acc43 "Radiographer"
label variable acc44 "Respiratory Therapist"
label variable acc45 "Respiratory Therapy Technician"
label variable acc46 "Radiation Therapy Technologist"
label variable acc47 "Surgeon Assistant"
label variable acc48 "Surgical Technologist"
label variable acc49 "Optometry - Professional degree programs"
label variable acc50 "Optometry - Residency programs"
label variable acc51 "Optometry - Technician programs"
label variable acc52 "Osteopathic Medicine"
label variable acc53 "Physical Therapy (PTA) - Professional programs for the physical therapist"
label variable acc54 "Physical Therapy (PTAA) - Programs for the physical therapist assistant"
label variable acc55 "Podiatry"
label variable acc56 "Clinical Psychology"
label variable acc57 "Counseling Psychology"
label variable acc58 "Professional Psychology - Predoctoral internship"
label variable acc59 "Professional/Scientific Psychology Doctoral"
label variable acc60 "School Psychology"
label variable acc61 "Landscape Architecture"
label variable acc62 "Audiology"
label variable acc63 "Speech-Language Pathology"
label variable acc64 "Veterinary Medicine - Program in animal technology"
label variable acc65 "Veterinary Medicine - Professional programs leading to D.V.M. or V.M.D degrees"
label variable acc66 "Clinical Pastoral Education"
label variable acc67 "Rabbinical and Talmudic Education"
label variable acc68 "Business - Private junior colleges"
label variable acc69 "Business - Private senior colleges"
label variable acc70 "Business postsecondary schools"
label variable acc71 "Theology"
label variable acc72 "Chiropractic"
label variable acc73 "Community Health Education"
label variable acc74 "Community Health/Preventive Medicine"
label variable acc75 "Public Health"
label variable acc76 "Social Work"
label variable acc77 "Interior Design"
label variable acc78 "Medicine"
label variable acc79 "Blind and Visually Handicapped Education"
label variable acc80 "Cosmetology"
label variable acc81 "Architecture"
label variable acc82 "Art"
label variable acc83 "Dance"
label variable acc84 "Music Baccalaureate and graduate degree programs"
label variable acc85 "Theatre"
label variable acc86 "Occupational, Trade and Technical Education - Private degree-granting institutions"
label variable acc87 "Occupational, Trade and Technical Education - Private nondegree-granting institutions"
label variable acc88 "Teacher Education"
label variable acc89 "Home Study Education"
label variable acc90 "Nursing - Associate degree programs"
label variable acc91 "Nursing - Diploma programs"
label variable acc92 "Nursing - Baccalaureate and higher degree programs"
label variable acc93 "Nursing - Practical nursing programs"
label variable acc94 "Forestry"
label variable acc95 "Opticianry 2-year programs"
label variable acc96 "Opticianry 1-year programs"
/*
label define label_stabbr AK "Alaska" 
label define label_stabbr AL "Alabama", add 
label define label_stabbr AR "Arkansas", add 
label define label_stabbr AS "American Samoa", add 
label define label_stabbr AZ "Arizona", add 
label define label_stabbr CA "California", add 
label define label_stabbr CM "Entry Unknown", add 
label define label_stabbr CO "Colorado", add 
label define label_stabbr CT "Connecticut", add 
label define label_stabbr DC "District of Columbia", add 
label define label_stabbr DE "Delaware", add 
label define label_stabbr FL "Florida", add 
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
label define label_stabbr MI "Michigan", add 
label define label_stabbr MN "Minnesota", add 
label define label_stabbr MO "Missouri", add 
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
label define label_stabbr RI "Rhode Island", add 
label define label_stabbr SC "South Carolina", add 
label define label_stabbr SD "South Dakota", add 
label define label_stabbr TN "Tennessee", add 
label define label_stabbr TT "Trust Territories", add 
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
label define label_fips 2 "Alaska", add 
label define label_fips 4 "Arizona", add 
label define label_fips 5 "Arkansas", add 
label define label_fips 6 "Ca ofprmoa", add 
label define label_fips 8 "Colorado", add 
label define label_fips 9 "Connecticut", add 
label define label_fips 10 "Delaware", add 
label define label_fips 11 "District of Columbia", add 
label define label_fips 12 "Florida", add 
label define label_fips 13 "Georgia", add 
label define label_fips 15 "Hawaii", add 
label define label_fips 16 "Idaho", add 
label define label_fips 17 "Illinois", add 
label define label_fips 18 "Indiana", add 
label define label_fips 19 "Iowa", add 
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
label define label_fips 40 "Oklahoma", add 
label define label_fips 41 "Oregon", add 
label define label_fips 42 "Pennsylvania", add 
label define label_fips 44 "Rhode Island", add 
label define label_fips 45 "South Carolina", add 
label define label_fips 46 "South Dakota", add 
label define label_fips 47 "Tennessee", add 
label define label_fips 48 "Texas", add 
label define label_fips 49 "Utah", add 
label define label_fips 50 "Vermont", add 
label define label_fips 51 "Virginia", add 
label define label_fips 53 "Washington", add 
label define label_fips 54 "West Virginia", add 
label define label_fips 55 "Wisconsin", add 
label define label_fips 56 "Wyoming", add 
label define label_fips 60 "American Samoa", add 
label define label_fips 63 "Northern Marianas", add 
label define label_fips 66 "Guam", add 
label define label_fips 72 "Puerto Rico", add 
label define label_fips 75 "Trust Territories", add 
label define label_fips 78 "Virgin Islands", add 
label values fips label_fips
label define label_obereg 0 "U.S. service schools" 
label define label_obereg 1 "New England-CT ME MA NH RI VT", add 
label define label_obereg 2 "Mid East-DE DC MD NJ NY PA", add 
label define label_obereg 3 "Great Lakes-IL IN MI OH WI", add 
label define label_obereg 4 "Plains-IA KS MN MO NE ND SD", add 
label define label_obereg 5 "New Mexico", add 
label define label_obereg 6 "Southwest-AZ NM OK TX", add 
label define label_obereg 7 "Rocky Mountains-CO ID MT UT WY", add 
label define label_obereg 8 "Far West-AK CA HI NV OR WA", add 
label define label_obereg 9 "Outlying Areas-AS GU CM PR TT VI", add 
label values obereg label_obereg
label define label_sector 0 "Administrative unit only" 
label define label_sector 1 "Public, 4-year or above", add 
label define label_sector 2 "Private, nonprofit, 4-year or above", add 
label define label_sector 3 "Private, for profit, 4-year or above", add 
label define label_sector 4 "Public, 2-year", add 
label define label_sector 5 "Private, nonprofit, 2-year", add 
label define label_sector 6 "Private, for profit, 2-year", add 
label define label_sector 7 "Public, less-than-2-year", add 
label define label_sector 8 "Private, nonprofit, less-than-2-year", add 
label define label_sector 9 "Private, for profit, less-than-2-year", add 
label values sector label_sector
label define label_iclevel 0 "No response" 
label define label_iclevel 1 "4 or more years (Baccalaureate or higher degree)", add 
label define label_iclevel 2 "At least 2 but less than 4 years below the Baccalaureate", add 
label define label_iclevel 3 "Less than 2 years (below Associates Degree)", add 
label values iclevel label_iclevel
label define label_control 0 "No response" 
label define label_control 1 "Public", add 
label define label_control 2 "Private nonprofit", add 
label define label_control 3 "Private for-profit", add 
label values control label_control
label define label_affil 1 "Public" 
label define label_affil 2 "Private for-profit", add 
label define label_affil 3 "Private nonprofit, independent", add 
label define label_affil 4 "Private nonprofit, Catholic", add 
label define label_affil 5 "Private nonprofit, Jewish", add 
label define label_affil 6 "Private nonprofit, Protestant", add 
label define label_affil 7 "Private nonprofit, other religious affiliation", add 
label values affil label_affil
label define label_hloffer 0 "Other" 
label define label_hloffer 1 "Postsecondary award, certificate or diploma of less than one academic year", add 
label define label_hloffer 2 "Postsecondary award, certificate or diploma of at least one but less than two academic years", add 
label define label_hloffer 3 "Associates Degree", add 
label define label_hloffer 4 "Postsecondary award, certificate or diploma of at least two but less than four academic years", add 
label define label_hloffer 5 "Bachelors Degree", add 
label define label_hloffer 6 "Postbaccalaureate Certificate", add 
label define label_hloffer 7 "Masters Degree", add 
label define label_hloffer 8 "Post-Masters Certificate", add 
label define label_hloffer 9 "Doctors Degree", add 
label values hloffer label_hloffer
label define label_formrt 1 "Form IC1" 
label define label_formrt 2 "Form IC2", add 
label define label_formrt 3 "Form IC3", add 
label values formrt label_formrt
label define label_resplast 1 "Respondent" 
label define label_resplast 3 "Nonrespondent, not imputed", add 
label values resplast label_resplast
label define label_respstat 1 "Respondent" 
label define label_respstat 3 "Nonrespondent, not imputed", add 
label values respstat label_respstat
label define label_multype 1 "Yes" 
label define label_multype 2 "No", add 
label values multype label_multype
label define label_protaffl 0 "No response" 
label define label_protaffl 21 "Entry unknown", add 
label define label_protaffl 27 "Assemblies of God Church", add 
label define label_protaffl 28 "Brethren Church", add 
label define label_protaffl 29 "Brethren in Christ Church", add 
label define label_protaffl 31 "Church of God in Christ", add 
label define label_protaffl 33 "Wisconsin Evangelical Lutheran Synod", add 
label define label_protaffl 34 "Christ and Missionary Alliance Church", add 
label define label_protaffl 35 "Christian Reformed Church", add 
label define label_protaffl 36 "Evangelical Congregational Church", add 
label define label_protaffl 37 "Evangelical Covenant Church of America", add 
label define label_protaffl 38 "Evangelical Free Church of America", add 
label define label_protaffl 39 "Evangelical Lutheran Church", add 
label define label_protaffl 41 "Free Will Baptist Church", add 
label define label_protaffl 42 "Interdenominational", add 
label define label_protaffl 43 "Mennonite Brethren Church", add 
label define label_protaffl 44 "Moravian Church", add 
label define label_protaffl 46 "American Lutheran and Lutheran Church in America", add 
label define label_protaffl 47 "Pentecostal Holiness Church", add 
label define label_protaffl 48 "Christian Churches and Churches of Christ", add 
label define label_protaffl 49 "Reformed Church in America", add 
label define label_protaffl 50 "Reformed Episcopal Church", add 
label define label_protaffl 51 "African Methodist Episcopal", add 
label define label_protaffl 52 "American Baptist", add 
label define label_protaffl 53 "American Lutheran", add 
label define label_protaffl 54 "Baptist", add 
label define label_protaffl 55 "Christian Methodist Episcopal", add 
label define label_protaffl 56 "Church of Christ (Scientist)", add 
label define label_protaffl 57 "Church of God", add 
label define label_protaffl 58 "Church of the Brethren", add 
label define label_protaffl 59 "Church of the Nazarene", add 
label define label_protaffl 60 "Cumberland Presbyterian", add 
label define label_protaffl 61 "Christian Church (Disciples of Christ)", add 
label define label_protaffl 64 "Free Methodist", add 
label define label_protaffl 65 "Friends", add 
label define label_protaffl 66 "Presbyterian Church (USA)", add 
label define label_protaffl 67 "Lutheran Church in America", add 
label define label_protaffl 68 "Lutheran Church - Missouri Synod", add 
label define label_protaffl 69 "Mennonite Church", add 
label define label_protaffl 70 "General Conference Mennonite Church", add 
label define label_protaffl 71 "United Methodist", add 
label define label_protaffl 73 "Protestant Episcopal", add 
label define label_protaffl 74 "Churches of Christ", add 
label define label_protaffl 75 "Southern Baptist", add 
label define label_protaffl 76 "United Church of Christ", add 
label define label_protaffl 78 "Multiple Protestant Denominations", add 
label define label_protaffl 79 "Other Protestant", add 
label define label_protaffl 81 "Reformed Presbyterian Church", add 
label define label_protaffl 82 "Reorganized Latter Day Saints Church", add 
label define label_protaffl 84 "United Brethren Church", add 
label define label_protaffl 87 "Missionary Church Inc", add 
label define label_protaffl 88 "Undenominational", add 
label define label_protaffl 89 "Wesleyan", add 
label define label_protaffl 92 "Russian Orthodox", add 
label define label_protaffl 93 "Unitarian Universalist", add 
label define label_protaffl 94 "Latter Day Saints", add 
label define label_protaffl 95 "Seventh Day Adventists", add 
label define label_protaffl 96 "Church of God of Prophecy", add 
label define label_protaffl 97 "The Presbyterian Church in America", add 
label define label_protaffl 99 "Other", add 
label values protaffl label_protaffl
label define label_othaffl 0 "No response" 
label define label_othaffl 42 "Interdenominational", add 
label define label_othaffl 48 "Christian Churches and Churches of Christ", add 
label define label_othaffl 50 "Reformed Episcopal Church", add 
label define label_othaffl 52 "American Baptist", add 
label define label_othaffl 53 "American Lutheran", add 
label define label_othaffl 54 "Baptist", add 
label define label_othaffl 56 "Church of Christ (Scientist)", add 
label define label_othaffl 57 "Church of God", add 
label define label_othaffl 59 "Church of the Nazarene", add 
label define label_othaffl 61 "Christian Church (Disciples of Christ)", add 
label define label_othaffl 65 "Friends", add 
label define label_othaffl 67 "Letheran Church in American", add 
label define label_othaffl 68 "Lutheran Church - Missouri Synod", add 
label define label_othaffl 69 "Mennonite Church", add 
label define label_othaffl 70 "Genreal Conference Mennonite Church", add 
label define label_othaffl 71 "United Methodist", add 
label define label_othaffl 74 "Churches of Christ", add 
label define label_othaffl 75 "Southern Baptist", add 
label define label_othaffl 76 "United Church of Christ", add 
label define label_othaffl 79 "Other Protestant", add 
label define label_othaffl 8 "Entry unknown", add 
label define label_othaffl 82 "Reorganized Latter Day Saints Church", add 
label define label_othaffl 88 "Undenominational", add 
label define label_othaffl 9 "Entry unknown", add 
label define label_othaffl 91 "Greek Orthodox", add 
label define label_othaffl 93 "Unitarian Universalist", add 
label define label_othaffl 94 "Latter Day Saints", add 
label define label_othaffl 99 "Other", add 
label values othaffl label_othaffl
label define label_fopna 1 "Yes" 
label define label_fopna 2 "No", add 
label values fopna label_fopna
label define label_saccr 1 "Yes" 
label define label_saccr 2 "No", add 
label values saccr label_saccr
tab stabbr
tab fips
tab obereg
tab sector
tab iclevel
tab control
tab affil
tab hloffer
tab fpoffer
tab formrt
tab resplast
tab respstat
tab peo1istr
tab peo2istr
tab peo3istr
tab peo4istr
tab peo5istr
tab peo6istr
tab multype
tab public1
tab public2
tab public3
tab public4
tab public5
tab public6
tab public7
tab public8
tab public9
tab private1
tab private2
tab private3
tab private4
tab private5
tab private6
tab private7
tab private8
tab protaffl
tab othaffl
tab level1
tab level2
tab level3
tab level4
tab level5
tab level6
tab level7
tab level8
tab level9
tab level10
tab level11
tab level12
tab fopna
tab fopna1
tab fopna2
tab accrd1
tab accrd2
tab accrd3
tab accrd4
tab saccr
tab acc1
tab acc2
tab acc3
tab acc4
tab acc5
tab acc6
tab acc7
tab acc8
tab acc9
tab acc10
tab acc11
tab acc12
tab acc13
tab acc14
tab acc15
tab acc16
tab acc17
tab acc18
tab acc19
tab acc20
tab acc21
tab acc22
tab acc23
tab acc24
tab acc25
tab acc26
tab acc27
tab acc28
tab acc29
tab acc30
tab acc31
tab acc32
tab acc33
tab acc34
tab acc35
tab acc36
tab acc37
tab acc38
tab acc39
tab acc40
tab acc41
tab acc42
tab acc43
tab acc44
tab acc45
tab acc46
tab acc47
tab acc48
tab acc49
tab acc50
tab acc51
tab acc52
tab acc53
tab acc54
tab acc55
tab acc56
tab acc57
tab acc58
tab acc59
tab acc60
tab acc61
tab acc62
tab acc63
tab acc64
tab acc65
tab acc66
tab acc67
tab acc68
tab acc69
tab acc70
tab acc71
tab acc72
tab acc73
tab acc74
tab acc75
tab acc76
tab acc77
tab acc78
tab acc79
tab acc80
tab acc81
tab acc82
tab acc83
tab acc84
tab acc85
tab acc86
tab acc87
tab acc88
tab acc89
tab acc90
tab acc91
tab acc92
tab acc93
tab acc94
tab acc95
tab acc96
summarize fice
summarize unitidx
summarize congdist
save dct_ic1987_a

