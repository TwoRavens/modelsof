* Created: 6/12/2004 8:24:11 PM
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
insheet using "../Raw Data/ic2001_data_stata.csv", comma clear
label data "dct_ic2001"
label variable unitid "unitid"
label variable peo1istr "Occupational"
label variable peo2istr "Academic"
label variable peo3istr "Continuing professional"
label variable peo4istr "Recreational or avocational"
label variable peo5istr "Adult basic remedial or HS equivalent"
label variable peo6istr "Secondary (high school)"
label variable cntlaffi "Intitutional control or affiliation"
label variable pubprime "Primary public control"
label variable pubsecon "Secondary public control"
label variable relaffil "Religious affiliation"
label variable level1 "Less than one year"
label variable level2 "One but less than two years"
label variable level3 "Associates Degree"
label variable level4 "Two but less than 4 years"
label variable level5 "Bachelors Degree"
label variable level6 "Postbaccalaureate Certificate"
label variable level7 "Masters Degree"
label variable level8 "Post-Masters Certificate"
label variable level9 "Doctors Degree"
label variable level10 "First-Professional Degree"
label variable level11 "First-Professional Certificate"
label variable level12 "Other degree"
label variable fopna "Programs not leading to a formal award"
label variable fopna1 "Undergraduate programs not leading to a formal award"
label variable fopna2 "Graduate programs not leading to a formal award"
label variable accrd1 "National or specialized accrediting"
label variable accrd2 "Regional accrediting agency"
label variable regaccrd "Name of Regional accrediting agency"
label variable accrd3 "State accrediting or approval agency"
label variable accrd4 "Accreditation not applicable"
label variable saccr "Accredited by accrediting agencies recognized by US DOE"
label variable openadmp "Open admission policy"
label variable admcon1 "Secondary school GPA"
label variable admcon2 "Secondary school rank"
label variable admcon3 "Secondary school record"
label variable admcon4 "Completion of college-prepatory program"
label variable admcon5 "Recommendations"
label variable admcon6 "Formal demonstration of competencies"
label variable admcon7 "Admission test scores"
label variable admcon8 "TOEFL (Test of English as a Foreign Language"
label variable appdate "Fall reporting period for applicant and admissions"
label variable xapplcnm "Imputation field for APPLCNM - FTFY degree-seeking applicants - Men"
label variable applcnm "FTFY degree-seeking applicants - Men"
label variable xapplcnw "Imputation field for APPLCNW - FTFY degree-seeking applicants - Women"
label variable applcnw "FTFY degree-seeking applicants - Women"
label variable xadmssnm "Imputation field for ADMSSNM - FTFY degree-seeking men admitted"
label variable admssnm "FTFY degree-seeking men admitted"
label variable xadmssnw "Imputation field for ADMSSNW - FTFY degree-seeking women admitted"
label variable admssnw "FTFY degree-seeking women admitted"
label variable xenrlftm "Imputation field for ENRLFTM - FTFY degree-seeking men enrolled full-time"
label variable enrlftm "FTFY degree-seeking men enrolled full-time"
label variable xenrlftw "Imputation field for ENRLFTW - FTFY degree-seeking women enrolled full-time"
label variable enrlftw "FTFY degree-seeking women enrolled full-time"
label variable xenrlptm "Imputation field for ENRLPTM - FTFY degree-seeking men enrolled part-time"
label variable enrlptm "FTFY degree-seeking men enrolled part-time"
label variable xenrlptw "Imputation field for ENRLPTW - FTFY degree-seeking women enrolled part-time"
label variable enrlptw "FTFY degree-seeking women enrolled part-time"
label variable satactdt "Fall reporting period for SAT/ACT test scores"
label variable xsatnum "Imputation field for SATNUM - Number of FTFY degree-seeking students submitting SAT scores"
label variable satnum "Number of FTFY degree-seeking students submitting SAT scores"
label variable xsatpct "Imputation field for SATPCT - Percent of FTFY degree-seeking students submitting SAT scores"
label variable satpct "Percent of FTFY degree-seeking students submitting SAT scores"
label variable xactnum "Imputation field for ACTNUM - Number of FTFY degree-seeking students submitting ACT scores"
label variable actnum "Number of FTFY degree-seeking students submitting ACT scores"
label variable xactpct "Imputation field for ACTPCT - Percent of FTFY degree-seeking students submitting ACT scores"
label variable actpct "Percent of FTFY degree-seeking students submitting ACT scores"
label variable xsatvr25 "Imputation field for SATVR25 - SAT I Verbal 25th percentile score"
label variable satvr25 "SAT I Verbal 25th percentile score"
label variable xsatvr75 "Imputation field for SATVR75 - SAT 1 Verbal 75th percentile score"
label variable satvr75 "SAT 1 Verbal 75th percentile score"
label variable xsatmt25 "Imputation field for SATMT25 - SAT 1 Math 25th percentile score"
label variable satmt25 "SAT 1 Math 25th percentile score"
label variable xsatmt75 "Imputation field for SATMT75 - SAT 1 Math 75th percentile score"
label variable satmt75 "SAT 1 Math 75th percentile score"
label variable xactcm25 "Imputation field for ACTCM25 - ACT Composite 25th percentile score"
label variable actcm25 "ACT Composite 25th percentile score"
label variable xactcm75 "Imputation field for ACTCM75 - ACT Composite 75th percentile score"
label variable actcm75 "ACT Composite 75th percentile score"
label variable xacten25 "Imputation field for ACTEN25 - ACT English 25th percentile score"
label variable acten25 "ACT English 25th percentile score"
label variable xacten75 "Imputation field for ACTEN75 - ACT English 75th percentile score"
label variable acten75 "ACT English 75th percentile score"
label variable xactmt25 "Imputation field for ACTMT25 - ACT Math 25th percentile score"
label variable actmt25 "ACT Math 25th percentile score"
label variable xactmt75 "Imputation field for ACTMT75 - ACT Math 75th percentile score"
label variable actmt75 "ACT Math 75th percentile score"
label variable credits1 "Dual credit"
label variable credits2 "Credit for life experiences"
label variable credits3 "Advanced placement (AP) credits"
label variable credits4 "Institution does not accept dual, credit for life, or AP credits"
label variable slo1 "Accelerated programs"
label variable slo2 "Cooperative (work-study) program"
label variable slo3 "Distance learning opportunities"
label variable slo4 "Dual enrollment"
label variable slo5 "ROTC"
label variable slo51 "ROTC"
label variable slo52 "ROTC"
label variable slo53 "ROTC"
label variable slo6 "Study abroad"
label variable slo7 "Weekend college"
label variable slo8 "Teacher certification (below the postsecondary level)"
label variable slo81 "Teacher certification"
label variable slo82 "Teacher certification"
label variable slo83 "Teacher certifcation"
label variable slo9 "None of the above special learning opportunities are offered"
label variable yrscoll "Years of college-level work required"
label variable stusrv1 "Remedial services"
label variable stusrv2 "Academic/career counseling service"
label variable stusrv3 "Employment services for students"
label variable stusrv4 "Placement services for completers"
label variable stusrv8 "On-campus day care for students^ children"
label variable stusrv9 "None of the above selected services are offered"
label variable libfac "Library facilities at institution"
label variable athassoc "Member of National Athletic Association"
label variable assoc1 "Member of National Collegiate Athletic Association (NCAA)"
label variable assoc2 "Member of National Association of Intercollegiate Athletics (NAIA)"
label variable assoc3 "Member of National Junior College Athletic Association (NJCAA)"
label variable assoc4 "Member of National Small College Athletic Association (NSCAA)"
label variable assoc5 "Member of National Christian College Athletic Association (NCCAA)"
label variable assoc6 "Member of other national athletic association not listed above"
label variable sport1 "NCAA/NAIA member for football"
label variable confno1 "NCAA/NAIA conference number"
label variable sport2 "NCAA/NAIA member for basketball"
label variable confno2 "NCAA/NAIA conference number"
label variable sport3 "NCAA/NAIA member for baseball"
label variable confno3 "NCAA/NAIA conference number"
label variable sport4 "NCAA/NAIA member for cross country/track"
label variable confno4 "NCAA/NAIA conference number"
label variable insttoyr "Provided instruction 2 consecutive years"
label variable pctpost "Percentage of students enrolled in  postsecondary programs"
label variable calsys "Calendar system"
label variable apfee "Application fee is required"
label variable xappfeeu "Imputation field for APPLFEEU - Undergraduate application fee"
label variable applfeeu "Undergraduate application fee"
label variable xappfeeg "Imputation field for APPLFEEG - Graduate application fee"
label variable applfeeg "Graduate application fee"
label variable xappfeep "Imputation field for APPLFEEP - First-Professional application fee"
label variable applfeep "First-Professional application fee"
label variable ftstu "Full-time students are enrolled"
label variable ft_ug "Full-time undergraduate students are enrolled"
label variable ft_ftug "Full-time 1st-time, 1st-year deg/cert UG students are enrolled"
label variable ft_gd "Full-time graduate students are enrolled"
label variable ft_fp "Full-time first-professional students are enrolled"
label variable tuitvary "Tuition charge varies for in-district, in-state, out-of-state students"
label variable room "Institution provide on-campus housing"
label variable xroomcap "Imputation field for ROOMCAP - Total dormitory capacity"
label variable roomcap "Total dormitory capacity"
label variable board "Institution provides board or meal plan"
label variable xmealswk "Imputation field for MEALSWK - Number of meals per week in board charge"
label variable mealswk "Number of meals per week in board charge"
label variable xroomamt "Imputation field for ROOMAMT - Typical room charge for academic year"
label variable roomamt "Typical room charge for academic year"
label variable xbordamt "Imputation field for BOARDAMT - Typical board charge for academic year"
label variable boardamt "Typical board charge for academic year"
label variable xrmbdamt "Imputation field for RMBRDAMT - Combined charge for room and board"
label variable rmbrdamt "Combined charge for room and board"
label define label_peo1istr 0 "{Implied no}" 
label define label_peo1istr 1 "Yes", add 
label values peo1istr label_peo1istr
label define label_peo2istr 0 "{Implied no}" 
label define label_peo2istr 1 "Yes", add 
label values peo2istr label_peo2istr
label define label_peo3istr -2 "{Item not applicable}" 
label define label_peo3istr 0 "{Implied no}", add 
label define label_peo3istr 1 "Yes", add 
label values peo3istr label_peo3istr
label define label_peo4istr 0 "{Implied no}" 
label define label_peo4istr 1 "Yes", add 
label values peo4istr label_peo4istr
label define label_peo5istr 0 "{Implied no}" 
label define label_peo5istr 1 "Yes", add 
label values peo5istr label_peo5istr
label define label_peo6istr 0 "{Implied no}" 
label define label_peo6istr 1 "Yes", add 
label values peo6istr label_peo6istr
label define label_cntlaffi 1 "Public" 
label define label_cntlaffi 2 "Private for-profit", add 
label define label_cntlaffi 3 "Private not-for-profit, no religious aff", add 
label define label_cntlaffi 4 "Private not-for-profit, religious affili", add 
label values cntlaffi label_cntlaffi
label define label_pubprime -1 "{Not reported}" 
label define label_pubprime -2 "{Item not applicable}", add 
label define label_pubprime 1 "Federal", add 
label define label_pubprime 2 "State", add 
label define label_pubprime 3 "Territorial", add 
label define label_pubprime 4 "School district", add 
label define label_pubprime 5 "County", add 
label define label_pubprime 6 "Township", add 
label define label_pubprime 7 "City", add 
label define label_pubprime 8 "Special district", add 
label define label_pubprime 9 "Other", add 
label values pubprime label_pubprime
label define label_pubsecon -1 "{Not reported}" 
label define label_pubsecon -2 "{Item not applicable}", add 
label define label_pubsecon 0 "No secondary control", add 
label define label_pubsecon 1 "Federal", add 
label define label_pubsecon 2 "State", add 
label define label_pubsecon 4 "School district", add 
label define label_pubsecon 5 "County", add 
label define label_pubsecon 6 "Township", add 
label define label_pubsecon 7 "City", add 
label define label_pubsecon 8 "Special district", add 
label define label_pubsecon 9 "Other", add 
label values pubsecon label_pubsecon
label define label_relaffil -2 "{Item not applicable}" 
label define label_relaffil 22 "American Evangelical Lutheran Church", add 
label define label_relaffil 24 "African Methodist Episcopal Zion Church", add 
label define label_relaffil 27 "Assemblies of God Church", add 
label define label_relaffil 28 "Brethren Church", add 
label define label_relaffil 30 "Roman Catholic", add 
label define label_relaffil 33 "Wisconsin Evangelical Lutheran Synod", add 
label define label_relaffil 34 "Christ and Missionary Alliance Church", add 
label define label_relaffil 35 "Christian Reformed Church", add 
label define label_relaffil 36 "Evangelical Congregational Church", add 
label define label_relaffil 37 "Evangelical Covenant Church of America", add 
label define label_relaffil 38 "Evangelical Free Church of America", add 
label define label_relaffil 39 "Evangelical Lutheran Church", add 
label define label_relaffil 40 "International United Pentecostal Church", add 
label define label_relaffil 41 "Free Will Baptist Church", add 
label define label_relaffil 42 "Interdenominational", add 
label define label_relaffil 43 "Mennonite Brethren Church", add 
label define label_relaffil 44 "Moravian Church", add 
label define label_relaffil 45 "North American Baptist", add 
label define label_relaffil 46 "American Lutheran & Luth Ch in America", add 
label define label_relaffil 47 "Pentecostal Holiness Church", add 
label define label_relaffil 48 "Christian Churches and Churches of Chris", add 
label define label_relaffil 49 "Reformed Church in America", add 
label define label_relaffil 51 "African Methodist Episcopal", add 
label define label_relaffil 52 "American Baptist", add 
label define label_relaffil 53 "American Lutheran", add 
label define label_relaffil 54 "Baptist", add 
label define label_relaffil 55 "Christian Methodist Episcopal", add 
label define label_relaffil 57 "Church of God", add 
label define label_relaffil 58 "Church of Brethren", add 
label define label_relaffil 59 "Church of the Nazarene", add 
label define label_relaffil 60 "Cumberland Presbyterian", add 
label define label_relaffil 61 "Christian Church (Disciples of Christ)", add 
label define label_relaffil 64 "Free Methodist", add 
label define label_relaffil 65 "Friends", add 
label define label_relaffil 66 "Presbyterian Church (USA)", add 
label define label_relaffil 67 "Lutheran Church in America", add 
label define label_relaffil 68 "Lutheran Church - Missouri Synod", add 
label define label_relaffil 69 "Mennonite Church", add 
label define label_relaffil 70 "General Conference Mennonite Church", add 
label define label_relaffil 71 "United Methodist", add 
label define label_relaffil 73 "Protestant Episcopal", add 
label define label_relaffil 74 "Churches of Christ", add 
label define label_relaffil 75 "Southern Baptist", add 
label define label_relaffil 76 "United Church of Christ", add 
label define label_relaffil 78 "Multiple Protestant Denomination", add 
label define label_relaffil 79 "Other Protestant", add 
label define label_relaffil 80 "Jewish", add 
label define label_relaffil 81 "Reformed Presbyterian Church", add 
label define label_relaffil 83 "Sevent Day Adventists Church", add 
label define label_relaffil 84 "United Brethren Church", add 
label define label_relaffil 87 "Missionary Church Inc", add 
label define label_relaffil 88 "Undenominational", add 
label define label_relaffil 89 "Wesleyan", add 
label define label_relaffil 91 "Greek Orthodox", add 
label define label_relaffil 92 "Russian Orthodox", add 
label define label_relaffil 93 "Unitarian Universalist", add 
label define label_relaffil 94 "Latter Day Saints (Mormon Church)", add 
label define label_relaffil 95 "Seventh Day Adventists", add 
label define label_relaffil 97 "The Presbyterian Church in America", add 
label values relaffil label_relaffil
label define label_level1 -1 "{Not reported}" 
label define label_level1 0 "{Implied no}", add 
label define label_level1 1 "Yes", add 
label values level1 label_level1
label define label_level2 -1 "{Not reported}" 
label define label_level2 0 "{Implied no}", add 
label define label_level2 1 "Yes", add 
label values level2 label_level2
label define label_level3 -1 "{Not reported}" 
label define label_level3 0 "{Implied no}", add 
label define label_level3 1 "Yes", add 
label values level3 label_level3
label define label_level4 -1 "{Not reported}" 
label define label_level4 0 "{Implied no}", add 
label define label_level4 1 "Yes", add 
label values level4 label_level4
label define label_level5 -1 "{Not reported}" 
label define label_level5 0 "{Implied no}", add 
label define label_level5 1 "Yes", add 
label values level5 label_level5
label define label_level6 -1 "{Not reported}" 
label define label_level6 0 "{Implied no}", add 
label define label_level6 1 "Yes", add 
label values level6 label_level6
label define label_level7 -1 "{Not reported}" 
label define label_level7 0 "{Implied no}", add 
label define label_level7 1 "Yes", add 
label values level7 label_level7
label define label_level8 -1 "{Not reported}" 
label define label_level8 0 "{Implied no}", add 
label define label_level8 1 "Yes", add 
label values level8 label_level8
label define label_level9 -1 "{Not reported}" 
label define label_level9 0 "{Implied no}", add 
label define label_level9 1 "Yes", add 
label values level9 label_level9
label define label_level10 -1 "{Not reported}" 
label define label_level10 0 "{Implied no}", add 
label define label_level10 1 "Yes", add 
label values level10 label_level10
label define label_level11 -1 "{Not reported}" 
label define label_level11 0 "{Implied no}", add 
label define label_level11 1 "Yes", add 
label values level11 label_level11
label define label_level12 -1 "{Not reported}" 
label define label_level12 0 "{Implied no}", add 
label define label_level12 1 "Yes", add 
label values level12 label_level12
label define label_fopna -1 "{Not reported}" 
label define label_fopna -2 "{Item not applicable}", add 
label define label_fopna 1 "Yes", add 
label define label_fopna 2 "No", add 
label values fopna label_fopna
label define label_fopna1 -1 "{Not reported}" 
label define label_fopna1 -2 "{Item not applicable}", add 
label define label_fopna1 -3 "{Not available}", add 
label define label_fopna1 0 "{Implied no}", add 
label define label_fopna1 1 "Yes", add 
label values fopna1 label_fopna1
label define label_fopna2 -1 "{Not reported}" 
label define label_fopna2 -2 "{Item not applicable}", add 
label define label_fopna2 -3 "{Not available}", add 
label define label_fopna2 0 "{Implied no}", add 
label define label_fopna2 1 "Yes", add 
label values fopna2 label_fopna2
label define label_accrd1 -1 "{Not reported}" 
label define label_accrd1 -2 "{Item not applicable}", add 
label define label_accrd1 0 "{Implied no}", add 
label define label_accrd1 1 "Yes", add 
label values accrd1 label_accrd1
label define label_accrd2 -1 "{Not reported}" 
label define label_accrd2 -2 "{Item not applicable}", add 
label define label_accrd2 0 "{Implied no}", add 
label define label_accrd2 1 "Yes", add 
label values accrd2 label_accrd2
label define label_regaccrd -1 "{Not reported}" 
label define label_regaccrd -2 "{Item not applicable}", add 
label define label_regaccrd 1 "Middle States Assc of Colleges and Schoo", add 
label define label_regaccrd 10 "Western Assc of Schools & Colleges Commi", add 
label define label_regaccrd 11 "Western Assc of Schools & Colleges SR Co", add 
label define label_regaccrd 2 "Middle States Assc of Colleges and Schoo", add 
label define label_regaccrd 3 "New England Assc of Schls & Colleges Hig", add 
label define label_regaccrd 4 "New England Assc of Schls & Colleges Voc", add 
label define label_regaccrd 5 "North Central Assc of Colleges and Schoo", add 
label define label_regaccrd 6 "North Central Assc of Colleges and Schoo", add 
label define label_regaccrd 7 "Northwest Assc of Schools & Colleges Com", add 
label define label_regaccrd 8 "Southern Assc of Colleges & Schools Comm", add 
label define label_regaccrd 9 "Western Assc of Schools & Colleges Commu", add 
label values regaccrd label_regaccrd
label define label_accrd3 -1 "{Not reported}" 
label define label_accrd3 -2 "{Item not applicable}", add 
label define label_accrd3 0 "{Implied no}", add 
label define label_accrd3 1 "Yes", add 
label values accrd3 label_accrd3
label define label_accrd4 -1 "{Not reported}" 
label define label_accrd4 -2 "{Item not applicable}", add 
label define label_accrd4 0 "{Implied no}", add 
label define label_accrd4 1 "Yes", add 
label values accrd4 label_accrd4
label define label_saccr -1 "{Not reported}" 
label define label_saccr -2 "{Item not applicable}", add 
label define label_saccr 1 "Yes", add 
label define label_saccr 2 "No", add 
label values saccr label_saccr
label define label_openadmp -1 "{Not reported}" 
label define label_openadmp -2 "{Item not applicable}", add 
label define label_openadmp 1 "Yes", add 
label define label_openadmp 2 "No", add 
label define label_openadmp 3 "Institution does not admit first-year un", add 
label values openadmp label_openadmp
label define label_admcon1 -1 "{Not reported}" 
label define label_admcon1 -2 "{Item not applicable}", add 
label define label_admcon1 1 "Required", add 
label define label_admcon1 2 "Recommended", add 
label define label_admcon1 3 "Neither required nor recommended", add 
label define label_admcon1 4 "Dont know", add 
label values admcon1 label_admcon1
label define label_admcon2 -1 "{Not reported}" 
label define label_admcon2 -2 "{Item not applicable}", add 
label define label_admcon2 1 "Required", add 
label define label_admcon2 2 "Recommended", add 
label define label_admcon2 3 "Neither required nor recommended", add 
label define label_admcon2 4 "Dont know", add 
label values admcon2 label_admcon2
label define label_admcon3 -1 "{Not reported}" 
label define label_admcon3 -2 "{Item not applicable}", add 
label define label_admcon3 1 "Required", add 
label define label_admcon3 2 "Recommended", add 
label define label_admcon3 3 "Neither required nor recommended", add 
label define label_admcon3 4 "Dont know", add 
label values admcon3 label_admcon3
label define label_admcon4 -1 "{Not reported}" 
label define label_admcon4 -2 "{Item not applicable}", add 
label define label_admcon4 1 "Required", add 
label define label_admcon4 2 "Recommended", add 
label define label_admcon4 3 "Neither required nor recommended", add 
label define label_admcon4 4 "Dont know", add 
label values admcon4 label_admcon4
label define label_admcon5 -1 "{Not reported}" 
label define label_admcon5 -2 "{Item not applicable}", add 
label define label_admcon5 1 "Required", add 
label define label_admcon5 2 "Recommended", add 
label define label_admcon5 3 "Neither required nor recommended", add 
label define label_admcon5 4 "Dont know", add 
label values admcon5 label_admcon5
label define label_admcon6 -1 "{Not reported}" 
label define label_admcon6 -2 "{Item not applicable}", add 
label define label_admcon6 1 "Required", add 
label define label_admcon6 2 "Recommended", add 
label define label_admcon6 3 "Neither required nor recommended", add 
label define label_admcon6 4 "Dont know", add 
label values admcon6 label_admcon6
label define label_admcon7 -1 "{Not reported}" 
label define label_admcon7 -2 "{Item not applicable}", add 
label define label_admcon7 1 "Required", add 
label define label_admcon7 2 "Recommended", add 
label define label_admcon7 3 "Neither required nor recommended", add 
label define label_admcon7 4 "Dont know", add 
label values admcon7 label_admcon7
label define label_admcon8 -1 "{Not reported}" 
label define label_admcon8 -2 "{Item not applicable}", add 
label define label_admcon8 1 "Required", add 
label define label_admcon8 2 "Recommended", add 
label define label_admcon8 3 "Neither required nor recommended", add 
label define label_admcon8 4 "Dont know", add 
label values admcon8 label_admcon8
label define label_appdate -1 "{Not reported}" 
label define label_appdate -2 "{Item not applicable}", add 
label define label_appdate 1 "Fall 2000", add 
label define label_appdate 2 "Fall 2001", add 
label values appdate label_appdate
label define label_xapplcnm 10 "Reported" 
label define label_xapplcnm 11 "Analyst corrected reported value", add 
label define label_xapplcnm 12 "Data generated from other data values", add 
label define label_xapplcnm 13 "Implied zero", add 
label define label_xapplcnm 20 "Imputed using Carry Forward procedure", add 
label define label_xapplcnm 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xapplcnm 22 "Imputed using the Group Median procedure", add 
label define label_xapplcnm 23 "Partial imputation", add 
label define label_xapplcnm 30 "Not applicable", add 
label define label_xapplcnm 31 "Institution left item blank", add 
label define label_xapplcnm 32 "Do not know", add 
label define label_xapplcnm 33 "Particular 1st prof field not applicable", add 
label define label_xapplcnm 40 "Suppressed to protect confidentiality", add 
label values xapplcnm label_xapplcnm
label define label_xapplcnw 10 "Reported" 
label define label_xapplcnw 11 "Analyst corrected reported value", add 
label define label_xapplcnw 12 "Data generated from other data values", add 
label define label_xapplcnw 13 "Implied zero", add 
label define label_xapplcnw 20 "Imputed using Carry Forward procedure", add 
label define label_xapplcnw 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xapplcnw 22 "Imputed using the Group Median procedure", add 
label define label_xapplcnw 23 "Partial imputation", add 
label define label_xapplcnw 30 "Not applicable", add 
label define label_xapplcnw 31 "Institution left item blank", add 
label define label_xapplcnw 32 "Do not know", add 
label define label_xapplcnw 33 "Particular 1st prof field not applicable", add 
label define label_xapplcnw 40 "Suppressed to protect confidentiality", add 
label values xapplcnw label_xapplcnw
label define label_xadmssnm 10 "Reported" 
label define label_xadmssnm 11 "Analyst corrected reported value", add 
label define label_xadmssnm 12 "Data generated from other data values", add 
label define label_xadmssnm 13 "Implied zero", add 
label define label_xadmssnm 20 "Imputed using Carry Forward procedure", add 
label define label_xadmssnm 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xadmssnm 22 "Imputed using the Group Median procedure", add 
label define label_xadmssnm 23 "Partial imputation", add 
label define label_xadmssnm 30 "Not applicable", add 
label define label_xadmssnm 31 "Institution left item blank", add 
label define label_xadmssnm 32 "Do not know", add 
label define label_xadmssnm 33 "Particular 1st prof field not applicable", add 
label define label_xadmssnm 40 "Suppressed to protect confidentiality", add 
label values xadmssnm label_xadmssnm
label define label_xadmssnw 10 "Reported" 
label define label_xadmssnw 11 "Analyst corrected reported value", add 
label define label_xadmssnw 12 "Data generated from other data values", add 
label define label_xadmssnw 13 "Implied zero", add 
label define label_xadmssnw 20 "Imputed using Carry Forward procedure", add 
label define label_xadmssnw 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xadmssnw 22 "Imputed using the Group Median procedure", add 
label define label_xadmssnw 23 "Partial imputation", add 
label define label_xadmssnw 30 "Not applicable", add 
label define label_xadmssnw 31 "Institution left item blank", add 
label define label_xadmssnw 32 "Do not know", add 
label define label_xadmssnw 33 "Particular 1st prof field not applicable", add 
label define label_xadmssnw 40 "Suppressed to protect confidentiality", add 
label values xadmssnw label_xadmssnw
label define label_xenrlftm 10 "Reported" 
label define label_xenrlftm 11 "Analyst corrected reported value", add 
label define label_xenrlftm 12 "Data generated from other data values", add 
label define label_xenrlftm 13 "Implied zero", add 
label define label_xenrlftm 20 "Imputed using Carry Forward procedure", add 
label define label_xenrlftm 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xenrlftm 22 "Imputed using the Group Median procedure", add 
label define label_xenrlftm 23 "Partial imputation", add 
label define label_xenrlftm 30 "Not applicable", add 
label define label_xenrlftm 31 "Institution left item blank", add 
label define label_xenrlftm 32 "Do not know", add 
label define label_xenrlftm 33 "Particular 1st prof field not applicable", add 
label define label_xenrlftm 40 "Suppressed to protect confidentiality", add 
label values xenrlftm label_xenrlftm
label define label_xenrlftw 10 "Reported" 
label define label_xenrlftw 11 "Analyst corrected reported value", add 
label define label_xenrlftw 12 "Data generated from other data values", add 
label define label_xenrlftw 13 "Implied zero", add 
label define label_xenrlftw 20 "Imputed using Carry Forward procedure", add 
label define label_xenrlftw 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xenrlftw 22 "Imputed using the Group Median procedure", add 
label define label_xenrlftw 23 "Partial imputation", add 
label define label_xenrlftw 30 "Not applicable", add 
label define label_xenrlftw 31 "Institution left item blank", add 
label define label_xenrlftw 32 "Do not know", add 
label define label_xenrlftw 33 "Particular 1st prof field not applicable", add 
label define label_xenrlftw 40 "Suppressed to protect confidentiality", add 
label values xenrlftw label_xenrlftw
label define label_xenrlptm 10 "Reported" 
label define label_xenrlptm 11 "Analyst corrected reported value", add 
label define label_xenrlptm 12 "Data generated from other data values", add 
label define label_xenrlptm 13 "Implied zero", add 
label define label_xenrlptm 20 "Imputed using Carry Forward procedure", add 
label define label_xenrlptm 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xenrlptm 22 "Imputed using the Group Median procedure", add 
label define label_xenrlptm 23 "Partial imputation", add 
label define label_xenrlptm 30 "Not applicable", add 
label define label_xenrlptm 31 "Institution left item blank", add 
label define label_xenrlptm 32 "Do not know", add 
label define label_xenrlptm 33 "Particular 1st prof field not applicable", add 
label define label_xenrlptm 40 "Suppressed to protect confidentiality", add 
label values xenrlptm label_xenrlptm
label define label_xenrlptw 10 "Reported" 
label define label_xenrlptw 11 "Analyst corrected reported value", add 
label define label_xenrlptw 12 "Data generated from other data values", add 
label define label_xenrlptw 13 "Implied zero", add 
label define label_xenrlptw 20 "Imputed using Carry Forward procedure", add 
label define label_xenrlptw 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xenrlptw 22 "Imputed using the Group Median procedure", add 
label define label_xenrlptw 23 "Partial imputation", add 
label define label_xenrlptw 30 "Not applicable", add 
label define label_xenrlptw 31 "Institution left item blank", add 
label define label_xenrlptw 32 "Do not know", add 
label define label_xenrlptw 33 "Particular 1st prof field not applicable", add 
label define label_xenrlptw 40 "Suppressed to protect confidentiality", add 
label values xenrlptw label_xenrlptw
label define label_satactdt -1 "{Not reported}" 
label define label_satactdt -2 "{Item not applicable}", add 
label define label_satactdt 1 "Fall 2000", add 
label define label_satactdt 2 "Fall 2001", add 
label values satactdt label_satactdt
label define label_xsatnum 10 "Reported" 
label define label_xsatnum 11 "Analyst corrected reported value", add 
label define label_xsatnum 12 "Data generated from other data values", add 
label define label_xsatnum 13 "Implied zero", add 
label define label_xsatnum 20 "Imputed using Carry Forward procedure", add 
label define label_xsatnum 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xsatnum 22 "Imputed using the Group Median procedure", add 
label define label_xsatnum 23 "Partial imputation", add 
label define label_xsatnum 30 "Not applicable", add 
label define label_xsatnum 31 "Institution left item blank", add 
label define label_xsatnum 32 "Do not know", add 
label define label_xsatnum 33 "Particular 1st prof field not applicable", add 
label define label_xsatnum 40 "Suppressed to protect confidentiality", add 
label values xsatnum label_xsatnum
label define label_xsatpct 10 "Reported" 
label define label_xsatpct 11 "Analyst corrected reported value", add 
label define label_xsatpct 12 "Data generated from other data values", add 
label define label_xsatpct 13 "Implied zero", add 
label define label_xsatpct 20 "Imputed using Carry Forward procedure", add 
label define label_xsatpct 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xsatpct 22 "Imputed using the Group Median procedure", add 
label define label_xsatpct 23 "Partial imputation", add 
label define label_xsatpct 30 "Not applicable", add 
label define label_xsatpct 31 "Institution left item blank", add 
label define label_xsatpct 32 "Do not know", add 
label define label_xsatpct 33 "Particular 1st prof field not applicable", add 
label define label_xsatpct 40 "Suppressed to protect confidentiality", add 
label values xsatpct label_xsatpct
label define label_xactnum 10 "Reported" 
label define label_xactnum 11 "Analyst corrected reported value", add 
label define label_xactnum 12 "Data generated from other data values", add 
label define label_xactnum 13 "Implied zero", add 
label define label_xactnum 20 "Imputed using Carry Forward procedure", add 
label define label_xactnum 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xactnum 22 "Imputed using the Group Median procedure", add 
label define label_xactnum 23 "Partial imputation", add 
label define label_xactnum 30 "Not applicable", add 
label define label_xactnum 31 "Institution left item blank", add 
label define label_xactnum 32 "Do not know", add 
label define label_xactnum 33 "Particular 1st prof field not applicable", add 
label define label_xactnum 40 "Suppressed to protect confidentiality", add 
label values xactnum label_xactnum
label define label_xactpct 10 "Reported" 
label define label_xactpct 11 "Analyst corrected reported value", add 
label define label_xactpct 12 "Data generated from other data values", add 
label define label_xactpct 13 "Implied zero", add 
label define label_xactpct 20 "Imputed using Carry Forward procedure", add 
label define label_xactpct 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xactpct 22 "Imputed using the Group Median procedure", add 
label define label_xactpct 23 "Partial imputation", add 
label define label_xactpct 30 "Not applicable", add 
label define label_xactpct 31 "Institution left item blank", add 
label define label_xactpct 32 "Do not know", add 
label define label_xactpct 33 "Particular 1st prof field not applicable", add 
label define label_xactpct 40 "Suppressed to protect confidentiality", add 
label values xactpct label_xactpct
label define label_xsatvr25 10 "Reported" 
label define label_xsatvr25 11 "Analyst corrected reported value", add 
label define label_xsatvr25 12 "Data generated from other data values", add 
label define label_xsatvr25 13 "Implied zero", add 
label define label_xsatvr25 20 "Imputed using Carry Forward procedure", add 
label define label_xsatvr25 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xsatvr25 22 "Imputed using the Group Median procedure", add 
label define label_xsatvr25 23 "Partial imputation", add 
label define label_xsatvr25 30 "Not applicable", add 
label define label_xsatvr25 31 "Institution left item blank", add 
label define label_xsatvr25 32 "Do not know", add 
label define label_xsatvr25 33 "Particular 1st prof field not applicable", add 
label define label_xsatvr25 40 "Suppressed to protect confidentiality", add 
label values xsatvr25 label_xsatvr25
label define label_xsatvr75 10 "Reported" 
label define label_xsatvr75 11 "Analyst corrected reported value", add 
label define label_xsatvr75 12 "Data generated from other data values", add 
label define label_xsatvr75 13 "Implied zero", add 
label define label_xsatvr75 20 "Imputed using Carry Forward procedure", add 
label define label_xsatvr75 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xsatvr75 22 "Imputed using the Group Median procedure", add 
label define label_xsatvr75 23 "Partial imputation", add 
label define label_xsatvr75 30 "Not applicable", add 
label define label_xsatvr75 31 "Institution left item blank", add 
label define label_xsatvr75 32 "Do not know", add 
label define label_xsatvr75 33 "Particular 1st prof field not applicable", add 
label define label_xsatvr75 40 "Suppressed to protect confidentiality", add 
label values xsatvr75 label_xsatvr75
label define label_xsatmt25 10 "Reported" 
label define label_xsatmt25 11 "Analyst corrected reported value", add 
label define label_xsatmt25 12 "Data generated from other data values", add 
label define label_xsatmt25 13 "Implied zero", add 
label define label_xsatmt25 20 "Imputed using Carry Forward procedure", add 
label define label_xsatmt25 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xsatmt25 22 "Imputed using the Group Median procedure", add 
label define label_xsatmt25 23 "Partial imputation", add 
label define label_xsatmt25 30 "Not applicable", add 
label define label_xsatmt25 31 "Institution left item blank", add 
label define label_xsatmt25 32 "Do not know", add 
label define label_xsatmt25 33 "Particular 1st prof field not applicable", add 
label define label_xsatmt25 40 "Suppressed to protect confidentiality", add 
label values xsatmt25 label_xsatmt25
label define label_xsatmt75 10 "Reported" 
label define label_xsatmt75 11 "Analyst corrected reported value", add 
label define label_xsatmt75 12 "Data generated from other data values", add 
label define label_xsatmt75 13 "Implied zero", add 
label define label_xsatmt75 20 "Imputed using Carry Forward procedure", add 
label define label_xsatmt75 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xsatmt75 22 "Imputed using the Group Median procedure", add 
label define label_xsatmt75 23 "Partial imputation", add 
label define label_xsatmt75 30 "Not applicable", add 
label define label_xsatmt75 31 "Institution left item blank", add 
label define label_xsatmt75 32 "Do not know", add 
label define label_xsatmt75 33 "Particular 1st prof field not applicable", add 
label define label_xsatmt75 40 "Suppressed to protect confidentiality", add 
label values xsatmt75 label_xsatmt75
label define label_xactcm25 10 "Reported" 
label define label_xactcm25 11 "Analyst corrected reported value", add 
label define label_xactcm25 12 "Data generated from other data values", add 
label define label_xactcm25 13 "Implied zero", add 
label define label_xactcm25 20 "Imputed using Carry Forward procedure", add 
label define label_xactcm25 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xactcm25 22 "Imputed using the Group Median procedure", add 
label define label_xactcm25 23 "Partial imputation", add 
label define label_xactcm25 30 "Not applicable", add 
label define label_xactcm25 31 "Institution left item blank", add 
label define label_xactcm25 32 "Do not know", add 
label define label_xactcm25 33 "Particular 1st prof field not applicable", add 
label define label_xactcm25 40 "Suppressed to protect confidentiality", add 
label values xactcm25 label_xactcm25
label define label_xactcm75 10 "Reported" 
label define label_xactcm75 11 "Analyst corrected reported value", add 
label define label_xactcm75 12 "Data generated from other data values", add 
label define label_xactcm75 13 "Implied zero", add 
label define label_xactcm75 20 "Imputed using Carry Forward procedure", add 
label define label_xactcm75 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xactcm75 22 "Imputed using the Group Median procedure", add 
label define label_xactcm75 23 "Partial imputation", add 
label define label_xactcm75 30 "Not applicable", add 
label define label_xactcm75 31 "Institution left item blank", add 
label define label_xactcm75 32 "Do not know", add 
label define label_xactcm75 33 "Particular 1st prof field not applicable", add 
label define label_xactcm75 40 "Suppressed to protect confidentiality", add 
label values xactcm75 label_xactcm75
label define label_xacten25 10 "Reported" 
label define label_xacten25 11 "Analyst corrected reported value", add 
label define label_xacten25 12 "Data generated from other data values", add 
label define label_xacten25 13 "Implied zero", add 
label define label_xacten25 20 "Imputed using Carry Forward procedure", add 
label define label_xacten25 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xacten25 22 "Imputed using the Group Median procedure", add 
label define label_xacten25 23 "Partial imputation", add 
label define label_xacten25 30 "Not applicable", add 
label define label_xacten25 31 "Institution left item blank", add 
label define label_xacten25 32 "Do not know", add 
label define label_xacten25 33 "Particular 1st prof field not applicable", add 
label define label_xacten25 40 "Suppressed to protect confidentiality", add 
label values xacten25 label_xacten25
label define label_xacten75 10 "Reported" 
label define label_xacten75 11 "Analyst corrected reported value", add 
label define label_xacten75 12 "Data generated from other data values", add 
label define label_xacten75 13 "Implied zero", add 
label define label_xacten75 20 "Imputed using Carry Forward procedure", add 
label define label_xacten75 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xacten75 22 "Imputed using the Group Median procedure", add 
label define label_xacten75 23 "Partial imputation", add 
label define label_xacten75 30 "Not applicable", add 
label define label_xacten75 31 "Institution left item blank", add 
label define label_xacten75 32 "Do not know", add 
label define label_xacten75 33 "Particular 1st prof field not applicable", add 
label define label_xacten75 40 "Suppressed to protect confidentiality", add 
label values xacten75 label_xacten75
label define label_xactmt25 10 "Reported" 
label define label_xactmt25 11 "Analyst corrected reported value", add 
label define label_xactmt25 12 "Data generated from other data values", add 
label define label_xactmt25 13 "Implied zero", add 
label define label_xactmt25 20 "Imputed using Carry Forward procedure", add 
label define label_xactmt25 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xactmt25 22 "Imputed using the Group Median procedure", add 
label define label_xactmt25 23 "Partial imputation", add 
label define label_xactmt25 30 "Not applicable", add 
label define label_xactmt25 31 "Institution left item blank", add 
label define label_xactmt25 32 "Do not know", add 
label define label_xactmt25 33 "Particular 1st prof field not applicable", add 
label define label_xactmt25 40 "Suppressed to protect confidentiality", add 
label values xactmt25 label_xactmt25
label define label_xactmt75 10 "Reported" 
label define label_xactmt75 11 "Analyst corrected reported value", add 
label define label_xactmt75 12 "Data generated from other data values", add 
label define label_xactmt75 13 "Implied zero", add 
label define label_xactmt75 20 "Imputed using Carry Forward procedure", add 
label define label_xactmt75 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xactmt75 22 "Imputed using the Group Median procedure", add 
label define label_xactmt75 23 "Partial imputation", add 
label define label_xactmt75 30 "Not applicable", add 
label define label_xactmt75 31 "Institution left item blank", add 
label define label_xactmt75 32 "Do not know", add 
label define label_xactmt75 33 "Particular 1st prof field not applicable", add 
label define label_xactmt75 40 "Suppressed to protect confidentiality", add 
label values xactmt75 label_xactmt75
label define label_credits1 -1 "{Not reported}" 
label define label_credits1 -2 "{Item not applicable}", add 
label define label_credits1 0 "{Implied no}", add 
label define label_credits1 1 "Yes", add 
label values credits1 label_credits1
label define label_credits2 -1 "{Not reported}" 
label define label_credits2 -2 "{Item not applicable}", add 
label define label_credits2 0 "{Implied no}", add 
label define label_credits2 1 "Yes", add 
label values credits2 label_credits2
label define label_credits3 -1 "{Not reported}" 
label define label_credits3 -2 "{Item not applicable}", add 
label define label_credits3 0 "{Implied no}", add 
label define label_credits3 1 "Yes", add 
label values credits3 label_credits3
label define label_credits4 -1 "{Not reported}" 
label define label_credits4 -2 "{Item not applicable}", add 
label define label_credits4 0 "{Implied no}", add 
label define label_credits4 1 "Yes", add 
label values credits4 label_credits4
label define label_slo1 -1 "{Not reported}" 
label define label_slo1 -2 "{Item not applicable}", add 
label define label_slo1 0 "{Implied no}", add 
label define label_slo1 1 "Yes", add 
label values slo1 label_slo1
label define label_slo2 -1 "{Not reported}" 
label define label_slo2 -2 "{Item not applicable}", add 
label define label_slo2 0 "{Implied no}", add 
label define label_slo2 1 "Yes", add 
label values slo2 label_slo2
label define label_slo3 -1 "{Not reported}" 
label define label_slo3 -2 "{Item not applicable}", add 
label define label_slo3 0 "{Implied no}", add 
label define label_slo3 1 "Yes", add 
label values slo3 label_slo3
label define label_slo4 -1 "{Not reported}" 
label define label_slo4 -2 "{Item not applicable}", add 
label define label_slo4 0 "{Implied no}", add 
label define label_slo4 1 "Yes", add 
label values slo4 label_slo4
label define label_slo5 -1 "{Not reported}" 
label define label_slo5 -2 "{Item not applicable}", add 
label define label_slo5 0 "{Implied no}", add 
label define label_slo5 1 "Yes", add 
label values slo5 label_slo5
label define label_slo51 -1 "{Not reported}" 
label define label_slo51 -2 "{Item not applicable}", add 
label define label_slo51 0 "{Implied no}", add 
label define label_slo51 1 "Yes", add 
label values slo51 label_slo51
label define label_slo52 -1 "{Not reported}" 
label define label_slo52 -2 "{Item not applicable}", add 
label define label_slo52 0 "{Implied no}", add 
label define label_slo52 1 "Yes", add 
label values slo52 label_slo52
label define label_slo53 -1 "{Not reported}" 
label define label_slo53 -2 "{Item not applicable}", add 
label define label_slo53 0 "{Implied no}", add 
label define label_slo53 1 "Yes", add 
label values slo53 label_slo53
label define label_slo6 -1 "{Not reported}" 
label define label_slo6 -2 "{Item not applicable}", add 
label define label_slo6 0 "{Implied no}", add 
label define label_slo6 1 "Yes", add 
label values slo6 label_slo6
label define label_slo7 -1 "{Not reported}" 
label define label_slo7 -2 "{Item not applicable}", add 
label define label_slo7 0 "{Implied no}", add 
label define label_slo7 1 "Yes", add 
label values slo7 label_slo7
label define label_slo8 -1 "{Not reported}" 
label define label_slo8 -2 "{Item not applicable}", add 
label define label_slo8 0 "{Implied no}", add 
label define label_slo8 1 "Yes", add 
label values slo8 label_slo8
label define label_slo81 -1 "{Not reported}" 
label define label_slo81 -2 "{Item not applicable}", add 
label define label_slo81 0 "{Implied no}", add 
label define label_slo81 1 "Yes", add 
label values slo81 label_slo81
label define label_slo82 -1 "{Not reported}" 
label define label_slo82 -2 "{Item not applicable}", add 
label define label_slo82 0 "{Implied no}", add 
label define label_slo82 1 "Yes", add 
label values slo82 label_slo82
label define label_slo83 -1 "{Not reported}" 
label define label_slo83 -2 "{Item not applicable}", add 
label define label_slo83 0 "{Implied no}", add 
label define label_slo83 1 "Yes", add 
label values slo83 label_slo83
label define label_slo9 -1 "{Not reported}" 
label define label_slo9 -2 "{Item not applicable}", add 
label define label_slo9 0 "{Implied no}", add 
label define label_slo9 1 "Yes", add 
label values slo9 label_slo9
label define label_yrscoll -1 "{Not reported}" 
label define label_yrscoll -2 "{Item not applicable}", add 
label define label_yrscoll 0 "0 years", add 
label define label_yrscoll 1 "1 year", add 
label define label_yrscoll 2 "2 years", add 
label define label_yrscoll 3 "3 years", add 
label define label_yrscoll 4 "4 years", add 
label define label_yrscoll 8 "8 years", add 
label values yrscoll label_yrscoll
label define label_stusrv1 -1 "{Not reported}" 
label define label_stusrv1 -2 "{Item not applicable}", add 
label define label_stusrv1 0 "{Implied no}", add 
label define label_stusrv1 1 "Yes", add 
label values stusrv1 label_stusrv1
label define label_stusrv2 -1 "{Not reported}" 
label define label_stusrv2 -2 "{Item not applicable}", add 
label define label_stusrv2 0 "{Implied no}", add 
label define label_stusrv2 1 "Yes", add 
label values stusrv2 label_stusrv2
label define label_stusrv3 -1 "{Not reported}" 
label define label_stusrv3 -2 "{Item not applicable}", add 
label define label_stusrv3 0 "{Implied no}", add 
label define label_stusrv3 1 "Yes", add 
label values stusrv3 label_stusrv3
label define label_stusrv4 -1 "{Not reported}" 
label define label_stusrv4 -2 "{Item not applicable}", add 
label define label_stusrv4 0 "{Implied no}", add 
label define label_stusrv4 1 "Yes", add 
label values stusrv4 label_stusrv4
label define label_stusrv8 -1 "{Not reported}" 
label define label_stusrv8 -2 "{Item not applicable}", add 
label define label_stusrv8 0 "{Implied no}", add 
label define label_stusrv8 1 "Yes", add 
label values stusrv8 label_stusrv8
label define label_stusrv9 -1 "{Not reported}" 
label define label_stusrv9 -2 "{Item not applicable}", add 
label define label_stusrv9 0 "{Implied no}", add 
label define label_stusrv9 1 "Yes", add 
label values stusrv9 label_stusrv9
label define label_libfac -1 "{Not reported}" 
label define label_libfac -2 "{Item not applicable}", add 
label define label_libfac 1 "Have our own library", add 
label define label_libfac 2 "Shared financial support for library", add 
label define label_libfac 3 "Neither of the above", add 
label values libfac label_libfac
label define label_athassoc -1 "{Not reported}" 
label define label_athassoc -2 "{Item not applicable}", add 
label define label_athassoc 1 "Yes", add 
label define label_athassoc 2 "No", add 
label values athassoc label_athassoc
label define label_assoc1 -1 "{Not reported}" 
label define label_assoc1 -2 "{Item not applicable}", add 
label define label_assoc1 0 "{Implied no}", add 
label define label_assoc1 1 "Yes", add 
label values assoc1 label_assoc1
label define label_assoc2 -1 "{Not reported}" 
label define label_assoc2 -2 "{Item not applicable}", add 
label define label_assoc2 0 "{Implied no}", add 
label define label_assoc2 1 "Yes", add 
label values assoc2 label_assoc2
label define label_assoc3 -1 "{Not reported}" 
label define label_assoc3 -2 "{Item not applicable}", add 
label define label_assoc3 0 "{Implied no}", add 
label define label_assoc3 1 "Yes", add 
label values assoc3 label_assoc3
label define label_assoc4 -1 "{Not reported}" 
label define label_assoc4 -2 "{Item not applicable}", add 
label define label_assoc4 0 "{Implied no}", add 
label define label_assoc4 1 "Yes", add 
label values assoc4 label_assoc4
label define label_assoc5 -1 "{Not reported}" 
label define label_assoc5 -2 "{Item not applicable}", add 
label define label_assoc5 0 "{Implied no}", add 
label define label_assoc5 1 "Yes", add 
label values assoc5 label_assoc5
label define label_assoc6 -1 "{Not reported}" 
label define label_assoc6 -2 "{Item not applicable}", add 
label define label_assoc6 0 "{Implied no}", add 
label define label_assoc6 1 "Yes", add 
label values assoc6 label_assoc6
label define label_sport1 -1 "{Not reported}" 
label define label_sport1 -2 "{Item not applicable}", add 
label define label_sport1 1 "Yes", add 
label define label_sport1 2 "No", add 
label values sport1 label_sport1
label define label_confno1 -1 "{Not reported}" 
label define label_confno1 -2 "{Item not applicable}", add 
label define label_confno1 102 "Atlantic Coast Conference", add 
label define label_confno1 103 "Atlantic 10 Conference", add 
label define label_confno1 104 "Big East Conference", add 
label define label_confno1 105 "Big Sky Conference", add 
label define label_confno1 106 "Big South Conference", add 
label define label_confno1 107 "Big Ten Conference", add 
label define label_confno1 108 "Big Twelve Conference", add 
label define label_confno1 111 "Conference USA", add 
label define label_confno1 112 "Division I Independents", add 
label define label_confno1 113 "Division I-A Independents", add 
label define label_confno1 114 "Division I-AA Independents", add 
label define label_confno1 115 "Eastern College Athletic Conference", add 
label define label_confno1 116 "Gateway Football Conference", add 
label define label_confno1 117 "Ivy League Conference", add 
label define label_confno1 118 "Metro Atlantic Athletic Conference", add 
label define label_confno1 119 "Mid-American Conference", add 
label define label_confno1 121 "Mid-Eastern Athletic Conference", add 
label define label_confno1 125 "Northeast Conference", add 
label define label_confno1 126 "Ohio Valley Conference", add 
label define label_confno1 127 "Pacific-10 Conference", add 
label define label_confno1 128 "Patriot League", add 
label define label_confno1 129 "Pioneer Football League", add 
label define label_confno1 130 "Southeastern Conference", add 
label define label_confno1 131 "Southern Conference", add 
label define label_confno1 132 "Southland Conference", add 
label define label_confno1 133 "Southwestern Athletic Conference", add 
label define label_confno1 134 "Sun Belt Conference", add 
label define label_confno1 135 "Trans America Athletic Conference", add 
label define label_confno1 137 "Western Athletic Conference", add 
label define label_confno1 140 "Central Intercollegiate Athletic Associa", add 
label define label_confno1 141 "Division II Independents", add 
label define label_confno1 142 "Eastern Football Conference", add 
label define label_confno1 144 "Great Lakes Intercollegiate Athletic Con", add 
label define label_confno1 146 "Gulf South Conference", add 
label define label_confno1 147 "Lone Star Conference", add 
label define label_confno1 148 "Mid-America Intercollegiate Athletic Ass", add 
label define label_confno1 151 "New York Collegiate Athletic Conference", add 
label define label_confno1 152 "North Central Intercollegiate Athletic", add 
label define label_confno1 153 "Northeast 10 Conference", add 
label define label_confno1 155 "Northern Sun Intercollegiate Conference", add 
label define label_confno1 156 "Pacific West Conference", add 
label define label_confno1 158 "Pennsylvania State Athletic Conference", add 
label define label_confno1 159 "Rocky Mountain Athletic Conference", add 
label define label_confno1 160 "South Atlantic Conference", add 
label define label_confno1 161 "Southern Intercollegiate Athletic Confer", add 
label define label_confno1 163 "West Virginia Intercollegiate Athletic", add 
label define label_confno1 165 "Centennial Conference", add 
label define label_confno1 167 "College Conference of Illinois and Wisco", add 
label define label_confno1 168 "Commonwealth Coast Conference", add 
label define label_confno1 170 "Division III Independents", add 
label define label_confno1 171 "Dixie Intercollegiate Athletic Conferenc", add 
label define label_confno1 172 "Empire Athletic Association", add 
label define label_confno1 173 "Freedom Football Conference", add 
label define label_confno1 175 "Heartland Collegiate Athletic Conferenc", add 
label define label_confno1 176 "Iowa Intercollegiate Athletic Conference", add 
label define label_confno1 180 "Michigan Intercollegiate Athletic Associ", add 
label define label_confno1 181 "Middle Atlantic States Conference", add 
label define label_confno1 182 "Midwest Conference", add 
label define label_confno1 183 "Minnesota Intercollegiate Athletic Confe", add 
label define label_confno1 184 "New England Football Conference", add 
label define label_confno1 185 "New England Small College Athletic Confe", add 
label define label_confno1 187 "New Jersey Athletic Conference", add 
label define label_confno1 189 "North Coast Athletic Conference", add 
label define label_confno1 190 "Northern Illinois-Iowa Conference", add 
label define label_confno1 191 "Ohio Athletic Conference", add 
label define label_confno1 192 "Old Dominion Athletic Conference", add 
label define label_confno1 194 "Presidents Athletic Conference", add 
label define label_confno1 195 "Saint Louis Intercollegiate Athletic Con", add 
label define label_confno1 197 "Southern California Intercoll Athletic C", add 
label define label_confno1 198 "Southern Collegiate Athletic Conference", add 
label define label_confno1 199 "State University of New York Athletic Co", add 
label define label_confno1 200 "University Athletic Association", add 
label define label_confno1 201 "Upstate Collegiate Athletic Association", add 
label define label_confno1 202 "Wisconsin Intercollegiate Athletic Confe", add 
label define label_confno1 203 "Mountain West Conference", add 
label define label_confno1 204 "American Southwest Conference", add 
label define label_confno1 205 "Northwest Conference", add 
label define label_confno1 210 "Illini-Badger Intercolleg Football Conf", add 
label define label_confno1 213 "Great Northwest Athletic Conference", add 
label define label_confno1 302 "Golden State Athletic Conference", add 
label define label_confno1 303 "Independent Far West Region", add 
label define label_confno1 304 "Chicagoland Collegiate Athletic Conferen", add 
label define label_confno1 305 "Mid-Central College Conference", add 
label define label_confno1 306 "American Mideast Conference", add 
label define label_confno1 308 "Independent Great Lakes Region", add 
label define label_confno1 309 "Kansas Collegiate Athletic Conference", add 
label define label_confno1 311 "Great Plains Athletic Conference", add 
label define label_confno1 315 "Mid-South Conference", add 
label define label_confno1 318 "Independent Mid-South Region", add 
label define label_confno1 320 "Heart of America Athletic Conference", add 
label define label_confno1 321 "Midwest Classic Conference", add 
label define label_confno1 322 "Independent Midwest Region", add 
label define label_confno1 323 "Central Atlantic Collegiate Conference", add 
label define label_confno1 327 "Independent Northeast Region", add 
label define label_confno1 331 "Independent Pacific Northwest Region", add 
label define label_confno1 332 "Eastern Intercollegiate Athletic Confere", add 
label define label_confno1 335 "Independent Southeast Region", add 
label define label_confno1 341 "Independent Southwest Region", add 
label define label_confno1 342 "Other", add 
label define label_confno1 350 "Mid-States Football Association", add 
label define label_confno1 351 "Dakota Athletic Conference", add 
label define label_confno1 352 "Frontier Conference", add 
label define label_confno1 353 "Red River Athletic Conference", add 
label define label_confno1 354 "Upper Midwest Athletic Conference", add 
label values confno1 label_confno1
label define label_sport2 -1 "{Not reported}" 
label define label_sport2 -2 "{Item not applicable}", add 
label define label_sport2 1 "Yes", add 
label define label_sport2 2 "No", add 
label values sport2 label_sport2
label define label_confno2 -1 "{Not reported}" 
label define label_confno2 -2 "{Item not applicable}", add 
label define label_confno2 101 "America East", add 
label define label_confno2 102 "Atlantic Coast Conference", add 
label define label_confno2 103 "Atlantic 10 Conference", add 
label define label_confno2 104 "Big East Conference", add 
label define label_confno2 105 "Big Sky Conference", add 
label define label_confno2 106 "Big South Conference", add 
label define label_confno2 107 "Big Ten Conference", add 
label define label_confno2 108 "Big Twelve Conference", add 
label define label_confno2 109 "Big West Conference", add 
label define label_confno2 110 "Colonial Athletic Association", add 
label define label_confno2 111 "Conference USA", add 
label define label_confno2 112 "Division I Independents", add 
label define label_confno2 113 "Division I-A Independents", add 
label define label_confno2 114 "Division I-AA Independents", add 
label define label_confno2 115 "Eastern College Athletic Conference", add 
label define label_confno2 117 "Ivy League Conference", add 
label define label_confno2 118 "Metro Atlantic Athletic Conference", add 
label define label_confno2 119 "Mid-American Conference", add 
label define label_confno2 120 "Mid-Continent Conference", add 
label define label_confno2 121 "Mid-Eastern Athletic Conference", add 
label define label_confno2 122 "Midwestern Collegiate Conference", add 
label define label_confno2 123 "Missouri Valley Conference", add 
label define label_confno2 125 "Northeast Conference", add 
label define label_confno2 126 "Ohio Valley Conference", add 
label define label_confno2 127 "Pacific-10 Conference", add 
label define label_confno2 128 "Patriot League", add 
label define label_confno2 130 "Southeastern Conference", add 
label define label_confno2 131 "Southern Conference", add 
label define label_confno2 132 "Southland Conference", add 
label define label_confno2 133 "Southwestern Athletic Conference", add 
label define label_confno2 134 "Sun Belt Conference", add 
label define label_confno2 135 "Trans America Athletic Conference", add 
label define label_confno2 136 "West Coast Conference", add 
label define label_confno2 137 "Western Athletic Conference", add 
label define label_confno2 138 "California Collegiate Athletic Associati", add 
label define label_confno2 139 "Carolinas-Virginia Athletic Conference", add 
label define label_confno2 140 "Central Intercollegiate Athletic Associa", add 
label define label_confno2 141 "Division II Independents", add 
label define label_confno2 144 "Great Lakes Intercollegiate Athlethic Co", add 
label define label_confno2 145 "Great Lakes Valley Conference", add 
label define label_confno2 146 "Gulf South Conference", add 
label define label_confno2 147 "Lone Star Conference", add 
label define label_confno2 148 "Mid-America Intercollegiate Athletic Ass", add 
label define label_confno2 150 "New England Collegiate Conference", add 
label define label_confno2 151 "New York Collegiate Athletic Conference", add 
label define label_confno2 152 "North Central Intercollegiate Athletic", add 
label define label_confno2 153 "Northeast 10 Conference", add 
label define label_confno2 155 "Northern Sun Intercollegiate Conference", add 
label define label_confno2 156 "Pacific West Conference", add 
label define label_confno2 157 "Peach Belt Athletic Conference", add 
label define label_confno2 158 "Pennsylvania State Athletic Conference", add 
label define label_confno2 159 "Rocky Mountain Athletic Conference", add 
label define label_confno2 160 "South Atlantic Conference", add 
label define label_confno2 161 "Southern Intercollegiate Athletic Confer", add 
label define label_confno2 162 "Sunshine State Conference", add 
label define label_confno2 163 "West Virginia Intercollegiate Athletic", add 
label define label_confno2 164 "Capital Athletic Conference", add 
label define label_confno2 165 "Centennial Conference", add 
label define label_confno2 166 "City University of New York Athletic Con", add 
label define label_confno2 167 "College Conference of Illinois and Wisco", add 
label define label_confno2 168 "Commonwealth Coast Conference", add 
label define label_confno2 170 "Division III Independents", add 
label define label_confno2 171 "Dixie Intercollegiate Athletic Conferenc", add 
label define label_confno2 172 "Empire Athletic Association", add 
label define label_confno2 174 "Great Northeast Athletic Conference", add 
label define label_confno2 175 "Heartland Collegiate Athletic Conference", add 
label define label_confno2 176 "Iowa Intercollegiate Athletic Conference", add 
label define label_confno2 177 "Lake Michigan Conference", add 
label define label_confno2 178 "Little East Conference", add 
label define label_confno2 179 "Massachusetts State College Athletic Ass", add 
label define label_confno2 180 "Michigan Intercollegiate Athletic Associ", add 
label define label_confno2 181 "Middle Atlantic States Conference", add 
label define label_confno2 182 "Midwest Conference", add 
label define label_confno2 183 "Minnesota Intercollegiate Athletic Confe", add 
label define label_confno2 184 "New England Football Conference", add 
label define label_confno2 185 "New England Small College Ath Conference", add 
label define label_confno2 186 "New England Womens & Mens Athletic Con", add 
label define label_confno2 187 "New Jersey Athletic Conference", add 
label define label_confno2 188 "New York State Womens Coll Athletic Ass", add 
label define label_confno2 189 "North Coast Athletic Conference", add 
label define label_confno2 190 "Northern Illinois-Iowa Conference", add 
label define label_confno2 191 "Ohio Athletic Conference", add 
label define label_confno2 192 "Old Dominion Athletic Conference", add 
label define label_confno2 193 "Pennsylvania Athletic Conference", add 
label define label_confno2 194 "Presidents Athletic Conference", add 
label define label_confno2 195 "Saint Louis Intercollegiate Athletic Con", add 
label define label_confno2 196 "Skyline Conference", add 
label define label_confno2 197 "Southern California Intercoll Athletic C", add 
label define label_confno2 198 "Southern Collegiate Athletic Conference", add 
label define label_confno2 199 "State University of New York Athletic Co", add 
label define label_confno2 200 "University Athletic Association", add 
label define label_confno2 201 "Upstate Collegiate Athletic Association", add 
label define label_confno2 202 "Wisconsin Intercollegiate Athletic Confe", add 
label define label_confno2 203 "Mountain West Conference", add 
label define label_confno2 204 "American Southwest Conference", add 
label define label_confno2 205 "Northwest Conference", add 
label define label_confno2 206 "Atlantic Womens Colleges Conference", add 
label define label_confno2 209 "Heartland Conference", add 
label define label_confno2 213 "Great Northwest Athletic Conference", add 
label define label_confno2 301 "California Pacific Conference", add 
label define label_confno2 302 "Golden State Athletic Conference", add 
label define label_confno2 303 "Independent Far West Region", add 
label define label_confno2 304 "Chicagoland Collegiate Athletic Conferen", add 
label define label_confno2 305 "Mid-Central College Conference", add 
label define label_confno2 306 "American Mideast Conference", add 
label define label_confno2 307 "Wolverine-Hoosier Athletic Conference", add 
label define label_confno2 308 "Independent Great Lakes Region", add 
label define label_confno2 309 "Kansas Collegiate Athletic Conference", add 
label define label_confno2 310 "Midlands Collegiate Athletic Conference", add 
label define label_confno2 311 "Great Plains Athletic Conference", add 
label define label_confno2 314 "Kentucky Intercollegiate Athletic Confer", add 
label define label_confno2 315 "Mid-South Conference", add 
label define label_confno2 316 "Appalachian Athletic Conference", add 
label define label_confno2 317 "TranSouth Athletic Conference", add 
label define label_confno2 318 "Independent Mid-South Region", add 
label define label_confno2 319 "American Midwest Conference", add 
label define label_confno2 320 "Heart of America Athletic Conference", add 
label define label_confno2 321 "Midwest Classic Conference", add 
label define label_confno2 322 "Independent Midwest Region", add 
label define label_confno2 323 "Central Atlantic Collegiate Conference", add 
label define label_confno2 325 "Maine Athletic Conference", add 
label define label_confno2 326 "Mayflower Conference", add 
label define label_confno2 327 "Independent Northeast Region", add 
label define label_confno2 328 "Cascade Collegiate Conference", add 
label define label_confno2 331 "Independent Pacific Northwest Region", add 
label define label_confno2 332 "Eastern Intercollegiate Athletic Confere", add 
label define label_confno2 333 "Florida Sun Conference", add 
label define label_confno2 334 "Georgia Alabama Carolina Conference", add 
label define label_confno2 335 "Independent Southeast Region", add 
label define label_confno2 337 "Gulf Coast Athletic Conference", add 
label define label_confno2 340 "Sooner Athletic Conference", add 
label define label_confno2 341 "Independent Southwest Region", add 
label define label_confno2 342 "Other", add 
label define label_confno2 351 "Dakota Athletic Conference", add 
label define label_confno2 352 "Frontier Conference", add 
label define label_confno2 353 "Red River Athletic Conference", add 
label define label_confno2 354 "Upper Midwest Athletic Conference", add 
label values confno2 label_confno2
label define label_sport3 -1 "{Not reported}" 
label define label_sport3 -2 "{Item not applicable}", add 
label define label_sport3 1 "Yes", add 
label define label_sport3 2 "No", add 
label values sport3 label_sport3
label define label_confno3 -1 "{Not reported}" 
label define label_confno3 -2 "{Item not applicable}", add 
label define label_confno3 101 "America East", add 
label define label_confno3 102 "Atlantic Coast Conference", add 
label define label_confno3 103 "Atlantic 10 Conference", add 
label define label_confno3 104 "Big East Conference", add 
label define label_confno3 105 "Big Sky Conference", add 
label define label_confno3 106 "Big South Conference", add 
label define label_confno3 107 "Big Ten Conference", add 
label define label_confno3 108 "Big Twelve Conference", add 
label define label_confno3 109 "Big West Conference", add 
label define label_confno3 110 "Colonial Athletic Association", add 
label define label_confno3 111 "Conference USA", add 
label define label_confno3 112 "Division I Independents", add 
label define label_confno3 113 "Division I-A Independents", add 
label define label_confno3 114 "Division I-AA Independents", add 
label define label_confno3 115 "Eastern College Athletic Conference", add 
label define label_confno3 117 "Ivy League Conference", add 
label define label_confno3 118 "Metro Atlantic Athletic Conference", add 
label define label_confno3 119 "Mid-American Conference", add 
label define label_confno3 120 "Mid-Continent Conference", add 
label define label_confno3 121 "Mid-Eastern Athletic Conference", add 
label define label_confno3 122 "Midwestern Collegiate Conference", add 
label define label_confno3 123 "Missouri Valley Conference", add 
label define label_confno3 125 "Northeast Conference", add 
label define label_confno3 126 "Ohio Valley Conference", add 
label define label_confno3 127 "Pacific-10 Conference", add 
label define label_confno3 128 "Patriot League", add 
label define label_confno3 130 "Southeastern Conference", add 
label define label_confno3 131 "Southern Conference", add 
label define label_confno3 132 "Southland Conference", add 
label define label_confno3 133 "Southwestern Athletic Conference", add 
label define label_confno3 134 "Sun Belt Conference", add 
label define label_confno3 135 "Trans America Athletic Conference", add 
label define label_confno3 136 "West Coast Conference", add 
label define label_confno3 137 "Western Athletic Conference", add 
label define label_confno3 138 "California Collegiate Athletic Associati", add 
label define label_confno3 139 "Carolinas-Virginia Athletic Conference", add 
label define label_confno3 140 "Central Intercollegiate Athletic Associa", add 
label define label_confno3 141 "Division II Independents", add 
label define label_confno3 144 "Great Lakes Intercollegiate Athletic Con", add 
label define label_confno3 145 "Great Lakes Valley Conference", add 
label define label_confno3 146 "Gulf South Conference", add 
label define label_confno3 147 "Lone Star Conference", add 
label define label_confno3 148 "Mid-America Intercollegiate AthleticA ss", add 
label define label_confno3 150 "New England Collegiate Conference", add 
label define label_confno3 151 "New York Collegiate Athletic Conference", add 
label define label_confno3 152 "North Central Intercollegiate Athletic", add 
label define label_confno3 153 "Northeast 10 Conference", add 
label define label_confno3 155 "Northern Sun Intercollegiate Conference", add 
label define label_confno3 156 "Pacific West Conference", add 
label define label_confno3 157 "Peach Belt Athletic Conference", add 
label define label_confno3 158 "Pennsylvania State Athletic Conference", add 
label define label_confno3 159 "Rocky Mountain Athletic Conference", add 
label define label_confno3 160 "South Atlantic Conference", add 
label define label_confno3 161 "Southern Intercollegiate Athletic Confer", add 
label define label_confno3 162 "Sunshine State Conference", add 
label define label_confno3 163 "West Virginia Intercollegiate Athletic", add 
label define label_confno3 164 "Capital Athletic Conference", add 
label define label_confno3 165 "Centennial Conference", add 
label define label_confno3 166 "City University of New York Athletic Con", add 
label define label_confno3 167 "College Conference of Illinois and Wisco", add 
label define label_confno3 168 "Commonwealth Coast Conference", add 
label define label_confno3 170 "Division III Independents", add 
label define label_confno3 171 "Dixie Intercollegiate Athletic Conferenc", add 
label define label_confno3 172 "Empire Athletic Association", add 
label define label_confno3 174 "Great Northeast Athletic Conference", add 
label define label_confno3 175 "Heartland Collegiate Athletic Conference", add 
label define label_confno3 176 "Iowa Intercollegiate Athletic Conference", add 
label define label_confno3 177 "Lake Michigan Conference", add 
label define label_confno3 178 "Little East Conference", add 
label define label_confno3 179 "Massachusetts State College Athletic Ass", add 
label define label_confno3 180 "Michigan Intercollegiate Athletic Associ", add 
label define label_confno3 181 "Middle Atlantic States Conference", add 
label define label_confno3 182 "Midwest Conference", add 
label define label_confno3 183 "Minnesota Intercollegiate Athletic Confe", add 
label define label_confno3 184 "New England Football Conference", add 
label define label_confno3 185 "New England Small College Athletic Confe", add 
label define label_confno3 186 "New England Womens & Mens Athletic Con", add 
label define label_confno3 187 "New Jersey Athletic Conference", add 
label define label_confno3 189 "North Coast Athletic Conference", add 
label define label_confno3 190 "Northern Illinois-Iowa Conference", add 
label define label_confno3 191 "Ohio Athletic Conference", add 
label define label_confno3 192 "Old Dominion Athletic Conference", add 
label define label_confno3 193 "Pennsylvania Athletic Conference", add 
label define label_confno3 194 "Presidents Athletic Conference", add 
label define label_confno3 195 "Saint Louis Intercollegiate Athletic Con", add 
label define label_confno3 196 "Skyline Conference", add 
label define label_confno3 197 "Southern California Intercoll Athletic C", add 
label define label_confno3 198 "Southern Collegiate Athletic Conference", add 
label define label_confno3 199 "State University of New York Athletic Co", add 
label define label_confno3 200 "University Athletic Association", add 
label define label_confno3 201 "Upstate Collegiate Athletic Association", add 
label define label_confno3 202 "Wisconsin Intercollegiate AthleticConfer", add 
label define label_confno3 203 "Mountain West Conference", add 
label define label_confno3 204 "American Southwest Conference", add 
label define label_confno3 205 "Northwest Conference", add 
label define label_confno3 209 "Heartland Conference", add 
label define label_confno3 213 "Great Northwest Athletic Conference", add 
label define label_confno3 302 "Golden State Athletic Conference", add 
label define label_confno3 303 "Independent Far West Region", add 
label define label_confno3 304 "Chicagoland Collegiate Athletic Conferen", add 
label define label_confno3 305 "Mid-Central College Conference", add 
label define label_confno3 306 "American Mideast Conference", add 
label define label_confno3 307 "Wolverine-Hoosier Athletic Conference", add 
label define label_confno3 308 "Independent Great Lakes Region", add 
label define label_confno3 309 "Kansas Collegiate Athletic Conference", add 
label define label_confno3 310 "Midlands Collegiate Athletic Conference", add 
label define label_confno3 311 "Great Plains Athletic Conference", add 
label define label_confno3 314 "Kentucky Intercollegiate Athletic Confer", add 
label define label_confno3 315 "Mid-South Conference", add 
label define label_confno3 316 "Appalachian Athletic Conference", add 
label define label_confno3 317 "TranSouth Athletic Conference", add 
label define label_confno3 318 "Independent Mid-South Region", add 
label define label_confno3 319 "American Midwest Conference", add 
label define label_confno3 320 "Heart of America Athletic Conference", add 
label define label_confno3 321 "Midwest Classic Conference", add 
label define label_confno3 322 "Independent Midwest Region", add 
label define label_confno3 323 "Central Atlantic Collegiate Conference", add 
label define label_confno3 325 "Maine Athletic Conference", add 
label define label_confno3 326 "Mayflower Conference", add 
label define label_confno3 327 "Independent Northeast Region", add 
label define label_confno3 328 "Cascade Collegiate Conference", add 
label define label_confno3 331 "Independent Pacific Northwest Region", add 
label define label_confno3 332 "Eastern Intercollegiate Athletic Confere", add 
label define label_confno3 333 "Florida Sun Conference", add 
label define label_confno3 334 "Georgia Alabama Carolina Conference", add 
label define label_confno3 335 "Independent Southeast Region", add 
label define label_confno3 337 "Gulf Coast Athletic Conference", add 
label define label_confno3 340 "Sooner Athletic Conference", add 
label define label_confno3 341 "Independent Southwest Region", add 
label define label_confno3 342 "Other", add 
label define label_confno3 351 "Dakota Athletic Conference", add 
label define label_confno3 353 "Red River Athletic Conference", add 
label define label_confno3 354 "Upper Midwest Athletic Conference", add 
label values confno3 label_confno3
label define label_sport4 -1 "{Not reported}" 
label define label_sport4 -2 "{Item not applicable}", add 
label define label_sport4 1 "Yes", add 
label define label_sport4 2 "No", add 
label values sport4 label_sport4
label define label_confno4 -1 "{Not reported}" 
label define label_confno4 -2 "{Item not applicable}", add 
label define label_confno4 101 "America East", add 
label define label_confno4 102 "Atlantic Coast Conference", add 
label define label_confno4 103 "Atlantic 10 Conference", add 
label define label_confno4 104 "Big East Conference", add 
label define label_confno4 105 "Big Sky Conference", add 
label define label_confno4 106 "Big South Conference", add 
label define label_confno4 107 "Big Ten Conference", add 
label define label_confno4 108 "Big Twelve Conference", add 
label define label_confno4 109 "Big West Conference", add 
label define label_confno4 110 "Colonial Athletic Association", add 
label define label_confno4 111 "Conference USA", add 
label define label_confno4 112 "Division I Independents", add 
label define label_confno4 113 "Division I-A Independents", add 
label define label_confno4 114 "Division I-AA Independents", add 
label define label_confno4 115 "Eastern College Athletic Conference", add 
label define label_confno4 117 "Ivy League Conference", add 
label define label_confno4 118 "Metro Atlantic Athletic Conference", add 
label define label_confno4 119 "Mid-American Conference", add 
label define label_confno4 120 "Mid-Continent Conference", add 
label define label_confno4 121 "Mid-Eastern Athletic Conference", add 
label define label_confno4 122 "Midwestern Collegiate Conference", add 
label define label_confno4 123 "Missouri Valley Conference", add 
label define label_confno4 125 "Northeast Conference", add 
label define label_confno4 126 "Ohio Valley Conference", add 
label define label_confno4 127 "Pacific-10 Conference", add 
label define label_confno4 128 "Patriot League", add 
label define label_confno4 130 "Southeastern Conference", add 
label define label_confno4 131 "Southern Conference", add 
label define label_confno4 132 "Southland Conference", add 
label define label_confno4 133 "Southwestern Athletic Conference", add 
label define label_confno4 134 "Sun Belt Conference", add 
label define label_confno4 135 "Trans America Athletic Conference", add 
label define label_confno4 136 "West Coast Conference", add 
label define label_confno4 137 "Western Athletic Conference", add 
label define label_confno4 138 "California Collegiate Athletic Associati", add 
label define label_confno4 139 "Carolinas-Virginia Athletic Conference", add 
label define label_confno4 140 "Central Intercollegiate Athletic Associa", add 
label define label_confno4 141 "Division II Independents", add 
label define label_confno4 144 "Great Lakes Intercollegiate Athletic Con", add 
label define label_confno4 145 "Great Lakes Valley Conference", add 
label define label_confno4 146 "Gulf South Conference", add 
label define label_confno4 147 "Lone Star Conference", add 
label define label_confno4 148 "Mid-America Intercollegiate Athletic Ass", add 
label define label_confno4 150 "New England Collegiate Conference", add 
label define label_confno4 151 "New York Collegiate Athletic Conference", add 
label define label_confno4 152 "North Central Intercollegiate Athletic", add 
label define label_confno4 153 "Northeast 10 Conference", add 
label define label_confno4 155 "Northern Sun Intercollegiate Conference", add 
label define label_confno4 156 "Pacific West Conference", add 
label define label_confno4 157 "Peach Belt Athletic Conference", add 
label define label_confno4 158 "Pennsylvania State Athletic Conference", add 
label define label_confno4 159 "Rocky Mountain Athletic Conference", add 
label define label_confno4 160 "South Atlantic Conference", add 
label define label_confno4 161 "Southern Intercollegiate Athletic Confer", add 
label define label_confno4 162 "Sunshine State Conference", add 
label define label_confno4 163 "West Virginia Intercollegiate Athletic", add 
label define label_confno4 164 "Capital Athletic Conference", add 
label define label_confno4 165 "Centennial Conference", add 
label define label_confno4 166 "City University of New York Ath Conferen", add 
label define label_confno4 167 "College Conference of Illinois and Wisco", add 
label define label_confno4 168 "Commonwealth Coast Conference", add 
label define label_confno4 170 "Division III Independents", add 
label define label_confno4 171 "Dixie Intercollegiate Athletic Conferenc", add 
label define label_confno4 172 "Empire Athletic Association", add 
label define label_confno4 174 "Great Northeast Athletic Conference", add 
label define label_confno4 175 "Heartland Collegiate Athletic Conferenc", add 
label define label_confno4 176 "Iowa Intercollegiate Athletic Conference", add 
label define label_confno4 177 "Lake Michigan Conference", add 
label define label_confno4 178 "Little East Conference", add 
label define label_confno4 179 "Massachusetts State College Athletic Ass", add 
label define label_confno4 180 "Michigan Intercollegiate Athletic Associ", add 
label define label_confno4 181 "Middle Atlantic States Conference", add 
label define label_confno4 182 "Midwest Conference", add 
label define label_confno4 183 "Minnesota Intercollegiate Ath Conference", add 
label define label_confno4 184 "New England Football Conference", add 
label define label_confno4 185 "New England Small College Ath Conference", add 
label define label_confno4 186 "New England Womens & Mens Athletic Con", add 
label define label_confno4 187 "New Jersey Athletic Conference", add 
label define label_confno4 188 "New York State Womens Coll Athletic Ass", add 
label define label_confno4 189 "North Coast Athletic Conference", add 
label define label_confno4 190 "Northern Illinois-Iowa Conference", add 
label define label_confno4 191 "Ohio Athletic Conference", add 
label define label_confno4 192 "Old Dominion Athletic Conference", add 
label define label_confno4 193 "Pennsylvania Athletic Conference", add 
label define label_confno4 194 "Presidents Athletic Conference", add 
label define label_confno4 195 "Saint Louis Intercollegiate Athletic Con", add 
label define label_confno4 196 "Skyline Conference", add 
label define label_confno4 197 "Southern California Intercoll Athletic C", add 
label define label_confno4 198 "Southern Collegiate Athletic Conference", add 
label define label_confno4 199 "State University of New York Athletic Co", add 
label define label_confno4 200 "University Athletic Association", add 
label define label_confno4 201 "Upstate Collegiate Athletic Association", add 
label define label_confno4 202 "Wisconsin Intercollegiate Athletic Confe", add 
label define label_confno4 203 "Mountain West Conference", add 
label define label_confno4 204 "American Southwest Conference", add 
label define label_confno4 205 "Northwest Conference", add 
label define label_confno4 209 "Heartland Conference", add 
label define label_confno4 213 "Great Northwest Athletic Conference", add 
label define label_confno4 301 "California Pacific Conference", add 
label define label_confno4 302 "Golden State Athletic Conference", add 
label define label_confno4 303 "Independent Far West Region", add 
label define label_confno4 304 "Chicagoland Collegiate Athletic Conferen", add 
label define label_confno4 305 "Mid-Central College Conference", add 
label define label_confno4 306 "American Mideast Conference", add 
label define label_confno4 307 "Wolverine-Hoosier Athletic Conference", add 
label define label_confno4 308 "Independent Great Lakes Region", add 
label define label_confno4 309 "Kansas Collegiate Athletic Conference", add 
label define label_confno4 310 "Midlands Collegiate Athletic Conference", add 
label define label_confno4 311 "Great Plains Athletic Conference", add 
label define label_confno4 314 "Kentucky Intercollegiate Athletic Confer", add 
label define label_confno4 315 "Mid-South Conference", add 
label define label_confno4 316 "Appalachian Athletic Conference", add 
label define label_confno4 317 "TranSouth Athletic Conference", add 
label define label_confno4 318 "Independent Mid-South Region", add 
label define label_confno4 319 "American Midwest Conference", add 
label define label_confno4 320 "Heart of America Athletic Conference", add 
label define label_confno4 321 "Midwest Classic Conference", add 
label define label_confno4 322 "Independent Midwest Region", add 
label define label_confno4 323 "Central Atlantic Collegiate Conference", add 
label define label_confno4 325 "Maine Athletic Conference", add 
label define label_confno4 326 "Mayflower Conference", add 
label define label_confno4 327 "Independent Northeast Region", add 
label define label_confno4 328 "Cascade Collegiate Conference", add 
label define label_confno4 331 "Independent Pacific Northwest Region", add 
label define label_confno4 332 "Eastern Intercollegiate Athletic Confere", add 
label define label_confno4 333 "Florida Sun Conference", add 
label define label_confno4 334 "Georgia Alabama Carolina Conference", add 
label define label_confno4 335 "Independent Southeast Region", add 
label define label_confno4 337 "Gulf Coast Athletic Conference", add 
label define label_confno4 340 "Sooner Athletic Conference", add 
label define label_confno4 341 "Independent Southwest Region", add 
label define label_confno4 342 "Other", add 
label define label_confno4 351 "Dakota Athletic Conference", add 
label define label_confno4 352 "Frontier Conference", add 
label define label_confno4 353 "Red River Athletic Conference", add 
label define label_confno4 354 "Upper Midwest Athletic Conference", add 
label values confno4 label_confno4
label define label_insttoyr -1 "{Not reported}" 
label define label_insttoyr -2 "{Item not applicable}", add 
label define label_insttoyr 1 "Yes", add 
label define label_insttoyr 2 "No", add 
label values insttoyr label_insttoyr
label define label_pctpost -1 "{Not reported}" 
label define label_pctpost -2 "{Item not applicable}", add 
label define label_pctpost 1 "0 - 24%", add 
label define label_pctpost 3 "40 - 49%", add 
label define label_pctpost 4 "50% or more", add 
label values pctpost label_pctpost
label define label_calsys -1 "{Not reported}" 
label define label_calsys -2 "{Item not applicable}", add 
label define label_calsys 1 "Semester", add 
label define label_calsys 2 "Quarter", add 
label define label_calsys 3 "Trimester", add 
label define label_calsys 4 "4-1-4 or similar plan", add 
label define label_calsys 5 "Differs by program", add 
label define label_calsys 6 "Continuous basis", add 
label values calsys label_calsys
label define label_apfee -1 "{Not reported}" 
label define label_apfee -2 "{Item not applicable}", add 
label define label_apfee 1 "Yes", add 
label define label_apfee 2 "No", add 
label values apfee label_apfee
label define label_xappfeeu 10 "Reported" 
label define label_xappfeeu 11 "Analyst corrected reported value", add 
label define label_xappfeeu 12 "Data generated from other data values", add 
label define label_xappfeeu 13 "Implied zero", add 
label define label_xappfeeu 20 "Imputed using Carry Forward procedure", add 
label define label_xappfeeu 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xappfeeu 22 "Imputed using the Group Median procedure", add 
label define label_xappfeeu 23 "Partial imputation", add 
label define label_xappfeeu 30 "Not applicable", add 
label define label_xappfeeu 31 "Institution left item blank", add 
label define label_xappfeeu 32 "Do not know", add 
label define label_xappfeeu 33 "Particular 1st prof field not applicable", add 
label define label_xappfeeu 40 "Suppressed to protect confidentiality", add 
label values xappfeeu label_xappfeeu
label define label_xappfeeg 10 "Reported" 
label define label_xappfeeg 11 "Analyst corrected reported value", add 
label define label_xappfeeg 12 "Data generated from other data values", add 
label define label_xappfeeg 13 "Implied zero", add 
label define label_xappfeeg 20 "Imputed using Carry Forward procedure", add 
label define label_xappfeeg 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xappfeeg 22 "Imputed using the Group Median procedure", add 
label define label_xappfeeg 23 "Partial imputation", add 
label define label_xappfeeg 30 "Not applicable", add 
label define label_xappfeeg 31 "Institution left item blank", add 
label define label_xappfeeg 32 "Do not know", add 
label define label_xappfeeg 33 "Particular 1st prof field not applicable", add 
label define label_xappfeeg 40 "Suppressed to protect confidentiality", add 
label values xappfeeg label_xappfeeg
label define label_xappfeep 10 "Reported" 
label define label_xappfeep 11 "Analyst corrected reported value", add 
label define label_xappfeep 12 "Data generated from other data values", add 
label define label_xappfeep 13 "Implied zero", add 
label define label_xappfeep 20 "Imputed using Carry Forward procedure", add 
label define label_xappfeep 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xappfeep 22 "Imputed using the Group Median procedure", add 
label define label_xappfeep 23 "Partial imputation", add 
label define label_xappfeep 30 "Not applicable", add 
label define label_xappfeep 31 "Institution left item blank", add 
label define label_xappfeep 32 "Do not know", add 
label define label_xappfeep 33 "Particular 1st prof field not applicable", add 
label define label_xappfeep 40 "Suppressed to protect confidentiality", add 
label values xappfeep label_xappfeep
label define label_ftstu -1 "{Not reported}" 
label define label_ftstu -2 "{Item not applicable}", add 
label define label_ftstu 1 "Yes", add 
label define label_ftstu 2 "No", add 
label values ftstu label_ftstu
label define label_ft_ug -1 "{Not reported}" 
label define label_ft_ug -2 "{Item not applicable}", add 
label define label_ft_ug 1 "Yes", add 
label define label_ft_ug 2 "No", add 
label values ft_ug label_ft_ug
label define label_ft_ftug -1 "{Not reported}" 
label define label_ft_ftug -2 "{Item not applicable}", add 
label define label_ft_ftug 1 "Yes", add 
label define label_ft_ftug 2 "No", add 
label values ft_ftug label_ft_ftug
label define label_ft_gd -1 "{Not reported}" 
label define label_ft_gd -2 "{Item not applicable}", add 
label define label_ft_gd 1 "Yes", add 
label define label_ft_gd 2 "No", add 
label values ft_gd label_ft_gd
label define label_ft_fp -1 "{Not reported}" 
label define label_ft_fp -2 "{Item not applicable}", add 
label define label_ft_fp 1 "Yes", add 
label define label_ft_fp 2 "No", add 
label values ft_fp label_ft_fp
label define label_tuitvary -1 "{Not reported}" 
label define label_tuitvary -2 "{Item not applicable}", add 
label define label_tuitvary 1 "Yes", add 
label define label_tuitvary 2 "No", add 
label values tuitvary label_tuitvary
label define label_room -1 "{Not reported}" 
label define label_room -2 "{Item not applicable}", add 
label define label_room 1 "Yes", add 
label define label_room 2 "No", add 
label values room label_room
label define label_xroomcap 10 "Reported" 
label define label_xroomcap 11 "Analyst corrected reported value", add 
label define label_xroomcap 12 "Data generated from other data values", add 
label define label_xroomcap 13 "Implied zero", add 
label define label_xroomcap 20 "Imputed using Carry Forward procedure", add 
label define label_xroomcap 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xroomcap 22 "Imputed using the Group Median procedure", add 
label define label_xroomcap 23 "Partial imputation", add 
label define label_xroomcap 30 "Not applicable", add 
label define label_xroomcap 31 "Institution left item blank", add 
label define label_xroomcap 32 "Do not know", add 
label define label_xroomcap 33 "Particular 1st prof field not applicable", add 
label define label_xroomcap 40 "Suppressed to protect confidentiality", add 
label values xroomcap label_xroomcap
label define label_board -1 "{Not reported}" 
label define label_board -2 "{Item not applicable}", add 
label define label_board 1 "Yes - No. of meals per week in the maxim", add 
label define label_board 2 "Yes - No of meals per week can vary", add 
label define label_board 3 "No", add 
label values board label_board
label define label_xmealswk 10 "Reported" 
label define label_xmealswk 11 "Analyst corrected reported value", add 
label define label_xmealswk 12 "Data generated from other data values", add 
label define label_xmealswk 13 "Implied zero", add 
label define label_xmealswk 20 "Imputed using Carry Forward procedure", add 
label define label_xmealswk 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xmealswk 22 "Imputed using the Group Median procedure", add 
label define label_xmealswk 23 "Partial imputation", add 
label define label_xmealswk 30 "Not applicable", add 
label define label_xmealswk 31 "Institution left item blank", add 
label define label_xmealswk 32 "Do not know", add 
label define label_xmealswk 33 "Particular 1st prof field not applicable", add 
label define label_xmealswk 40 "Suppressed to protect confidentiality", add 
label values xmealswk label_xmealswk
label define label_xroomamt 10 "Reported" 
label define label_xroomamt 11 "Analyst corrected reported value", add 
label define label_xroomamt 12 "Data generated from other data values", add 
label define label_xroomamt 13 "Implied zero", add 
label define label_xroomamt 20 "Imputed using Carry Forward procedure", add 
label define label_xroomamt 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xroomamt 22 "Imputed using the Group Median procedure", add 
label define label_xroomamt 23 "Partial imputation", add 
label define label_xroomamt 30 "Not applicable", add 
label define label_xroomamt 31 "Institution left item blank", add 
label define label_xroomamt 32 "Do not know", add 
label define label_xroomamt 33 "Particular 1st prof field not applicable", add 
label define label_xroomamt 40 "Suppressed to protect confidentiality", add 
label values xroomamt label_xroomamt
label define label_xbordamt 10 "Reported" 
label define label_xbordamt 11 "Analyst corrected reported value", add 
label define label_xbordamt 12 "Data generated from other data values", add 
label define label_xbordamt 13 "Implied zero", add 
label define label_xbordamt 20 "Imputed using Carry Forward procedure", add 
label define label_xbordamt 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xbordamt 22 "Imputed using the Group Median procedure", add 
label define label_xbordamt 23 "Partial imputation", add 
label define label_xbordamt 30 "Not applicable", add 
label define label_xbordamt 31 "Institution left item blank", add 
label define label_xbordamt 32 "Do not know", add 
label define label_xbordamt 33 "Particular 1st prof field not applicable", add 
label define label_xbordamt 40 "Suppressed to protect confidentiality", add 
label values xbordamt label_xbordamt
label define label_xrmbdamt 10 "Reported" 
label define label_xrmbdamt 11 "Analyst corrected reported value", add 
label define label_xrmbdamt 12 "Data generated from other data values", add 
label define label_xrmbdamt 13 "Implied zero", add 
label define label_xrmbdamt 20 "Imputed using Carry Forward procedure", add 
label define label_xrmbdamt 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xrmbdamt 22 "Imputed using the Group Median procedure", add 
label define label_xrmbdamt 23 "Partial imputation", add 
label define label_xrmbdamt 30 "Not applicable", add 
label define label_xrmbdamt 31 "Institution left item blank", add 
label define label_xrmbdamt 32 "Do not know", add 
label define label_xrmbdamt 33 "Particular 1st prof field not applicable", add 
label define label_xrmbdamt 40 "Suppressed to protect confidentiality", add 
label values xrmbdamt label_xrmbdamt
tab peo1istr
tab peo2istr
tab peo3istr
tab peo4istr
tab peo5istr
tab peo6istr
tab cntlaffi
tab pubprime
tab pubsecon
tab relaffil
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
tab regaccrd
tab accrd3
tab accrd4
tab saccr
tab openadmp
tab admcon1
tab admcon2
tab admcon3
tab admcon4
tab admcon5
tab admcon6
tab admcon7
tab admcon8
tab appdate
tab xapplcnm
tab xapplcnw
tab xadmssnm
tab xadmssnw
tab xenrlftm
tab xenrlftw
tab xenrlptm
tab xenrlptw
tab satactdt
tab xsatnum
tab xsatpct
tab xactnum
tab xactpct
tab xsatvr25
tab xsatvr75
tab xsatmt25
tab xsatmt75
tab xactcm25
tab xactcm75
tab xacten25
tab xacten75
tab xactmt25
tab xactmt75
tab credits1
tab credits2
tab credits3
tab credits4
tab slo1
tab slo2
tab slo3
tab slo4
tab slo5
tab slo51
tab slo52
tab slo53
tab slo6
tab slo7
tab slo8
tab slo81
tab slo82
tab slo83
tab slo9
tab yrscoll
tab stusrv1
tab stusrv2
tab stusrv3
tab stusrv4
tab stusrv8
tab stusrv9
tab libfac
tab athassoc
tab assoc1
tab assoc2
tab assoc3
tab assoc4
tab assoc5
tab assoc6
tab sport1
tab confno1
tab sport2
tab confno2
tab sport3
tab confno3
tab sport4
tab confno4
tab insttoyr
tab pctpost
tab calsys
tab apfee
tab xappfeeu
tab xappfeeg
tab xappfeep
tab ftstu
tab ft_ug
tab ft_ftug
tab ft_gd
tab ft_fp
tab tuitvary
tab room
tab xroomcap
tab board
tab xmealswk
tab xroomamt
tab xbordamt
tab xrmbdamt
summarize applcnm
summarize applcnw
summarize admssnm
summarize admssnw
summarize enrlftm
summarize enrlftw
summarize enrlptm
summarize enrlptw
summarize satnum
summarize satpct
summarize actnum
summarize actpct
summarize satvr25
summarize satvr75
summarize satmt25
summarize satmt75
summarize actcm25
summarize actcm75
summarize acten25
summarize acten75
summarize actmt25
summarize actmt75
summarize applfeeu
summarize applfeeg
summarize applfeep
summarize roomcap
summarize mealswk
summarize roomamt
summarize boardamt
summarize rmbrdamt
save dct_ic2001

