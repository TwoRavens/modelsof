* Created: 6/13/2004 8:04:58 AM
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
insheet using "../Raw Data/ic1986_a_data_stata.csv", comma clear
label data "dct_ic1986_a"
label variable unitid "unitid"
label variable sector "Mailing sector of institution"
label variable addr "Institution (entity) address"
label variable city "City"
label variable stabbr "State abbreviation"
label variable zip "Nine-digit zip code"
label variable congdist "Congressional district"
label variable gentele "General information telephone number"
label variable respstat "Respondent status"
label variable fice "HEGIS FICE code"
label variable peo1istr "Types of educational offerings - occupational"
label variable peo2istr "Types of educational offerings - academic"
label variable peo3istr "Types of educational offerings - continuing professional"
label variable peo4istr "Types of educational offerings - recreational or avocational"
label variable peo5istr "Types of educational offerings - adult basic, remedial, or high school equivalency"
label variable peo6istr "Types of educational offerings - secondary (high school)"
label variable multtyp1 "Central office"
label variable multtyp2 "System office"
label variable public1 "Public, federal"
label variable public2 "Public, state"
label variable public3 "Public, territorial"
label variable public4 "Public, school district"
label variable public5 "Public, county"
label variable public6 "Public, township"
label variable public7 "Public, city"
label variable public8 "Public, special district"
label variable public9 "Public, other"
label variable private1 "Private, profit making"
label variable private2 "Private, nonprofit"
label variable private3 "Private, independent"
label variable private4 "Private, religious affiliation"
label variable private5 "Private, catholic"
label variable private6 "Private, jewish"
label variable private7 "Private, protestant"
label variable private8 "Private, other"
label variable protaffl "Protestant affiliation"
label variable othaffl "Other affiliation"
label variable level1 "Less than one year"
label variable level2 "One but less than two years"
label variable level3 "Associates degree"
label variable level4 "Two but less than four years"
label variable level5 "Bachelors degree"
label variable level6 "Postbaccalaureate certificate"
label variable level7 "Masters degree"
label variable level8 "Post-masters certificate"
label variable level9 "Doctors degree"
label variable level10 "First-professional degree"
label variable level11 "First-professional certificate"
label variable level12 "Other level"
label variable fopna "Formally organized programs without award"
label variable fopna1 "Formally organized programs, undergraduate"
label variable fopna2 "Formally organized programs, graduate"
label variable accrd1 "National/professional accrediting agency"
label variable accrd2 "Regional accrediting agency"
label variable accrd3 "State accrediting or approval agency"
label variable accrd4 "Accredited by, not applicable"
label variable calsys1 "Calendar system, semester"
label variable calsys2 "Calendar system, quarter"
label variable calsys3 "Calendar system, trimester"
label variable calsys4 "Calendar system, 4-1-4 plan"
label variable calsys5 "Calendar system, differs program by program"
label variable calsys6 "Calendar system, other"
label variable crsloc1 "Course location, credit in-state"
label variable crsloc2 "Course location, credit out-of-state"
label variable crsloc3 "Course location, credit abroad"
label variable crsloc4 "Course location, non-credit in-state"
label variable crsloc5 "Course location, non-credit out-of-state"
label variable crsloc6 "Course location, non-credit abroad"
label variable facloc1 "Facilities, credit, on-campus"
label variable facloc2 "Facilities, credit, correctional facility"
label variable facloc3 "Facilities, credit, local education agency facility"
label variable facloc4 "Facilities, credit, other government facility"
label variable facloc5 "Facilities, credit, non-government facility"
label variable facloc6 "Facilities, credit, other"
label variable facloc7 "Facilities, noncredit, on-campus"
label variable facloc8 "Facilities, noncredit, correctional facility"
label variable facloc9 "Facilities, noncredit, local education agency facility"
label variable facloc10 "Facilities, noncredit, other government facility"
label variable facloc11 "Facilities, noncredit, non-government facility"
label variable facloc12 "Facilities, noncredit, other"
label variable mili "Courses at military institution"
label variable mil1insl "Course offered- military instal-states/territories"
label variable mil2insl "Course offered - military instal-abroad"
label variable admreq1 "High school diploma or equivalent"
label variable admreq2 "High school class standing"
label variable admreq3 "Admissions test scores"
label variable admreq4 "SAT test score"
label variable admreq5 "ACT test score"
label variable admreq6 "Other test score"
label variable admreq7 "Residence"
label variable admreq8 "Evidence of ability to benefit"
label variable admreq9 "Age"
label variable admreq10 "TOEFL or equivalent test"
label variable admreq11 "Other"
label variable avgperc "Average high school percentile rank"
label variable uwwou "University without walls or open university"
label variable mode1 "Credit, work program-related with pay"
label variable mode2 "Credit, work program-related without pay"
label variable mode3 "Credit, home study, general"
label variable mode4 "Credit, home study, correspondence"
label variable mode5 "Credit, home study, radio/TV"
label variable mode6 "Credit, home study, newspaper"
label variable mode7 "Credit, none of the above"
label variable mode8 "Noncredit, work program-related with pay"
label variable mode9 "Noncredit, work program-related without pay"
label variable mode10 "Noncredit, home study, general"
label variable mode11 "Noncredit, home study, correspondence"
label variable mode12 "Noncredit, home study, radio/TV"
label variable mode13 "Noncredit, home study, newspaper"
label variable mode14 "Noncredit, none of the above"
label variable stusrv1 "Remedial instructional programs"
label variable stusrv2 "Academic/career counseling"
label variable stusrv3 "Employment services"
label variable stusrv4 "Placement services"
label variable stusrv5 "Assistance visually impaired"
label variable stusrv6 "Assistance hearing impaired"
label variable stusrv7 "Access mobility impaired"
label variable stusrv8 "On-campus day care"
label variable stusrv9 "None of the above"
label variable libfac "Library facility (own library or shared library)"
label variable aslib1 "Administratively separate library, law"
label variable aslib2 "Administratively separate library, medicine"
label variable aslib3 "Administratively separate library, other"
label variable ftstu "Full-time students enrolled"
label variable apfee "Application fee required"
label variable applfeeu "Undergraduate application fee amount"
label variable applfeeg "Graduate application fee amount"
label variable tfdu "Tuition/fee charge for different undergraduate levels"
label variable tfdg "Tuition/fee charge for different graduate levels"
label variable ffind "Flat fee is charged"
label variable ffamt "Flat fee amount in whole dollars"
label variable ffper1 "Flat fee, per semester"
label variable ffper2 "Flat fee, per quarter"
label variable ffper3 "Flat fee, per program"
label variable ffper4 "Flat fee, per year"
label variable ffper5 "Flat fee, per trimester"
label variable ffper6 "Flat fee, other"
label variable ffmin "Min. credit hours covered by flat fee"
label variable ffmax "Max. credit hours covered by flat fee"
label variable phind "Per hour for tuition full-time undergraduate students"
label variable phamt "Per hour amount full-time undergraduate students"
label variable phper1 "Per hour, semester hour"
label variable phper2 "Per hour, quarter credit hour"
label variable phper3 "Per hour, contact hour"
label variable phper4 "Per hour, trimester hour"
label variable phper5 "Per hour, other"
label variable noftug "No full-time undergraduate students"
label variable tuition1 "Undergraduate tuition charge-in state (4-year institutions)"
label variable tuition2 "Undergraduate tuition charge-out of state (4-year institutions)"
label variable tuition3 "No full-time undergraduate students"
label variable tuition4 "Graduate tuition charge-in state"
label variable tuition5 "Graduate tuition charge-out of state"
label variable tuition6 "No full-time graduate students"
label variable prof1 "1st professional tuition/fees - Chiropractic (D.C.)"
label variable prof2 "1st professional tuition/fees - Dentistry (D.D.S. or D.M.D.)"
label variable prof3 "1st professional tuition/fees - Medicine (M. D.)"
label variable prof4 "1st professional tuition/fees - Optometry (O.D.)"
label variable prof5 "1st professional tuition/fees - Osteopathic Medicine (D.O)"
label variable prof6 "1st professional tuition/fees - Pharmacy (D.Phar.)"
label variable prof7 "1st professional tuition/fees - Podiatry (Pod.D., D.P., or D.P.M.)"
label variable prof8 "1st professional tuition/fees - Veterinary Medicine (D.V.M.)"
label variable prof9 "1st professional tuition/fees - Law (LL.B. or J.D.)"
label variable prof10 "1st professional tuition/fees - Theorlogy (M.Div or M.B.L.)"
label variable prof11 "1st professional tuition/fees - Other"
label variable profna "No full-time 1st professional students"
label variable room "Dorm facilities offered"
label variable roomamt "Room amount in dollars"
label variable roomcap "Total dormitory capacity"
label variable board "Meal plans provided"
label variable boardamt "Typical board charge in dollars"
label variable mealswk "Number of meals per week board covers"
label variable avgamt1 "Average book/supplies cost"
label variable avgamt2 "Average transportation cost"
label variable avgamt3 "Average room and board cost (non-dorm)"
label variable avgamt4 "Average miscellaneous expenses"
label variable fips "State FIPS code"
label variable obereg "OBE Region Code"
label variable type "Type of institution"
label variable control "Public, non-profit or private"
label variable tfdi "Tuition/fee charge different instructional programs"
label variable tuition7 "Tuition charge, local resident in-district (2-year institutions)"
label variable tuition8 "Tuition charge, other in-state students (2-year institutions)"
label variable tuition9 "Tuition charge, out-of-state student (2-year institutions)"
label variable chgper1 "Charge full-time students by credit/contact hour"
label variable chgper2 "Charge full-time students by program"
label variable chgper3 "Charge full-time students by term"
label variable chgper4 "Charge full-time students by year"
label variable chgper5 "Charge full-time students by other"
label variable rstatus "Response status"
label variable unitidx "UNITID of parent institution reporting full-year enrollment"
label variable pbalph "Number to sort file into directory sequence"
label variable cnty "Fips county code"
label variable estyr "Year established"
label variable prtfu "Undergraduate tuition for private"
label variable pbtfui "Undergraduate tuition public - in state"
label variable pbtfuo "Undergraduate tuition for public - out of state"
label variable prtfg "Graduate tuition for private"
label variable pbtfgi "Graduate tuition for public - in state"
label variable pbtfgo "Graduate tuition for public - out of state"
label variable stcnty "State and county code combination"
label variable system "Code common to all schools in a system"
label variable sequen "Sequence code within a system"
label variable status "Type of entry"
label variable congr "Congressional district"
label variable cntynm "County name"
label variable affil "Affiliation of institution"
label variable calsys "Calendar system"
label variable procc "Term occupational program below bachelor^s"
label variable pr2yr "2-year program creditable toward bachelor^s"
label variable prlib "Liberal arts and general programs"
label variable prtea "Teacher preparatory program"
label variable prprof "Professional program"
label variable oereg "Academic regions"
label variable race "Race of student body"
label variable sex "Sex of student body"
label variable lgrnt "Land grant code"
label variable cncesc "Current NCES code"
label variable excntl "Control - more detail than CNTL85 variable"
label variable citysi "City size"
label variable admreq "Admission requirements"
label variable estmo "Month established"
label variable period "Number of days covered by room and board"
label variable fwrkmoyr "Month and year first work offered"
label variable fdgrmoyr "Month and year first degree granted"
label variable iclevel "Level of institution 1=4Yr, 2=2Yr, 3=<2yr"
label variable hloffer "Highest level of offering"
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
/*
label define label_stabbr AK "Alaska" 
label define label_stabbr AL "Alabama", add 
label define label_stabbr AR "Arkansas", add 
label define label_stabbr AS "Entry unknown", add 
label define label_stabbr AZ "Arizona", add 
label define label_stabbr CA "California", add 
label define label_stabbr CM "Entry unknown", add 
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
label define label_stabbr TT "Entry unknown", add 
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
label define label_respstat 0 "Nonrespondent" 
label define label_respstat 1 "Respondent", add 
label define label_respstat 2 "Nonrespondent", add 
label values respstat label_respstat
label define label_protaffl 0 "No response" 
label define label_protaffl 13 "Local", add 
label define label_protaffl 21 "Independent Non-profit", add 
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
label define label_protaffl 77 "Entry unknown", add 
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
label define label_othaffl 47 "Pentecostal Holiness Church", add 
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
label define label_othaffl 67 "Lutheran Church in America", add 
label define label_othaffl 68 "Lutheran Church - Missouri Synod", add 
label define label_othaffl 69 "Mennonite Church", add 
label define label_othaffl 71 "United Methodist", add 
label define label_othaffl 74 "Churches of Christ", add 
label define label_othaffl 75 "Southern Baptist", add 
label define label_othaffl 76 "United Church of Christ", add 
label define label_othaffl 8 "Entry unknown", add 
label define label_othaffl 82 "Reorganized Latter Day Saints Church", add 
label define label_othaffl 88 "Undenominational", add 
label define label_othaffl 9 "Entry unknown", add 
label define label_othaffl 91 "Greek Orthodox", add 
label define label_othaffl 93 "Unitarian Universalist", add 
label define label_othaffl 94 "Latter Day Saints", add 
label define label_othaffl 95 "Seventh Day Adventists", add 
label define label_othaffl 99 "Other", add 
label values othaffl label_othaffl
label define label_fopna 0 "No" 
label define label_fopna 1 "Yes", add 
label values fopna label_fopna
label define label_mili 0 "No" 
label define label_mili 1 "Yes", add 
label values mili label_mili
label define label_uwwou 0 "No" 
label define label_uwwou 1 "Yes", add 
label values uwwou label_uwwou
label define label_libfac 1 "Yes, own library" 
label define label_libfac 2 "Yes, shared library", add 
label define label_libfac 3 "Yes, own or shared not known", add 
label define label_libfac 4 "No", add 
label values libfac label_libfac
label define label_ftstu 0 "No" 
label define label_ftstu 1 "Yes", add 
label values ftstu label_ftstu
label define label_apfee 0 "No" 
label define label_apfee 1 "Yes", add 
label values apfee label_apfee
label define label_tfdu 0 "No" 
label define label_tfdu 1 "Yes", add 
label values tfdu label_tfdu
label define label_tfdg 0 "No" 
label define label_tfdg 1 "Yes", add 
label values tfdg label_tfdg
label define label_room 0 "No" 
label define label_room 1 "Yes", add 
label values room label_room
label define label_board 0 "No" 
label define label_board 1 "Yes", add 
label values board label_board
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
label define label_fips 63 "Northern Marianas", add 
label define label_fips 66 "Guam", add 
label define label_fips 72 "Puerto Rico", add 
label define label_fips 75 "Trust Territories", add 
label define label_fips 78 "Virgin Islands", add 
label define label_fips 8 "Colorado", add 
label define label_fips 9 "Connecticut", add 
label values fips label_fips
label define label_obereg 1 "New England - CT ME MA NH RI VT" 
label define label_obereg 2 "Mid East - DE DC MD NJ NY PA", add 
label define label_obereg 3 "Great Lakes - IL IN MI OH WI", add 
label define label_obereg 4 "Plains - IA KS MN MO NE ND SD", add 
label define label_obereg 5 "Southeast-AL AR FL GA KY LA MS NC SC TN VA WV", add 
label define label_obereg 6 "Southwest - AZ NM OK TX", add 
label define label_obereg 7 "Rocky Mountains - CO ID MT UT WY", add 
label define label_obereg 8 "Far West - AK CA HI NV OR WA", add 
label define label_obereg 9 "Outlying Areas - AQ GU CM PR TQ VI", add 
label values obereg label_obereg
label define label_type 0 "University (must offer at least two first professional programs)" 
label define label_type 1 "Other four year", add 
label define label_type 2 "Two year", add 
label define label_type 3 "Other 4-year branch campus of a multi-campus university", add 
label values type label_type
label define label_control 0 "Central/system offices only" 
label define label_control 1 "Public", add 
label define label_control 2 "Private, nonprofit", add 
label define label_control 3 "Private, for profit", add 
label values control label_control
label define label_tfdi 0 "No" 
label define label_tfdi 1 "Yes", add 
label values tfdi label_tfdi
label define label_estyr 1636 "1636" 
label define label_estyr 1693 "1693", add 
label define label_estyr 1701 "1701", add 
label define label_estyr 1740 "1740", add 
label define label_estyr 1742 "1742", add 
label define label_estyr 1746 "1746", add 
label define label_estyr 1749 "1749", add 
label define label_estyr 1754 "1754", add 
label define label_estyr 1764 "1764", add 
label define label_estyr 1766 "1766", add 
label define label_estyr 1769 "1769", add 
label define label_estyr 1770 "1770", add 
label define label_estyr 1772 "1772", add 
label define label_estyr 1773 "1773", add 
label define label_estyr 1776 "1776", add 
label define label_estyr 1780 "1780", add 
label define label_estyr 1781 "1781", add 
label define label_estyr 1782 "1782", add 
label define label_estyr 1784 "1784", add 
label define label_estyr 1785 "1785", add 
label define label_estyr 1787 "1787", add 
label define label_estyr 1789 "1789", add 
label define label_estyr 1791 "1791", add 
label define label_estyr 1793 "1793", add 
label define label_estyr 1794 "1794", add 
label define label_estyr 1795 "1795", add 
label define label_estyr 1798 "1798", add 
label define label_estyr 1800 "1800", add 
label define label_estyr 1801 "1801", add 
label define label_estyr 1802 "1802", add 
label define label_estyr 1803 "1803", add 
label define label_estyr 1804 "1804", add 
label define label_estyr 1807 "1807", add 
label define label_estyr 1808 "1808", add 
label define label_estyr 1809 "1809", add 
label define label_estyr 1812 "1812", add 
label define label_estyr 1813 "1813", add 
label define label_estyr 1814 "1814", add 
label define label_estyr 1815 "1815", add 
label define label_estyr 1816 "1816", add 
label define label_estyr 1817 "1817", add 
label define label_estyr 1818 "1818", add 
label define label_estyr 1819 "1819", add 
label define label_estyr 1820 "1820", add 
label define label_estyr 1821 "1821", add 
label define label_estyr 1822 "1822", add 
label define label_estyr 1823 "1823", add 
label define label_estyr 1824 "1824", add 
label define label_estyr 1825 "1825", add 
label define label_estyr 1826 "1826", add 
label define label_estyr 1827 "1827", add 
label define label_estyr 1828 "1828", add 
label define label_estyr 1829 "1829", add 
label define label_estyr 1830 "1830", add 
label define label_estyr 1831 "1831", add 
label define label_estyr 1832 "1832", add 
label define label_estyr 1833 "1833", add 
label define label_estyr 1834 "1834", add 
label define label_estyr 1835 "1835", add 
label define label_estyr 1836 "1836", add 
label define label_estyr 1837 "1837", add 
label define label_estyr 1838 "1838", add 
label define label_estyr 1839 "1839", add 
label define label_estyr 1840 "1840", add 
label define label_estyr 1841 "1841", add 
label define label_estyr 1842 "1842", add 
label define label_estyr 1843 "1843", add 
label define label_estyr 1844 "1844", add 
label define label_estyr 1845 "1845", add 
label define label_estyr 1846 "1846", add 
label define label_estyr 1847 "1847", add 
label define label_estyr 1848 "1848", add 
label define label_estyr 1849 "1849", add 
label define label_estyr 1850 "1850", add 
label define label_estyr 1851 "1851", add 
label define label_estyr 1852 "1852", add 
label define label_estyr 1853 "1853", add 
label define label_estyr 1854 "1854", add 
label define label_estyr 1855 "1855", add 
label define label_estyr 1856 "1856", add 
label define label_estyr 1857 "1857", add 
label define label_estyr 1858 "1858", add 
label define label_estyr 1859 "1859", add 
label define label_estyr 1860 "1860", add 
label define label_estyr 1861 "1861", add 
label define label_estyr 1862 "1862", add 
label define label_estyr 1863 "1863", add 
label define label_estyr 1864 "1864", add 
label define label_estyr 1865 "1865", add 
label define label_estyr 1866 "1866", add 
label define label_estyr 1867 "1867", add 
label define label_estyr 1868 "1868", add 
label define label_estyr 1869 "1869", add 
label define label_estyr 1870 "1870", add 
label define label_estyr 1871 "1871", add 
label define label_estyr 1872 "1872", add 
label define label_estyr 1873 "1873", add 
label define label_estyr 1874 "1874", add 
label define label_estyr 1875 "1875", add 
label define label_estyr 1876 "1876", add 
label define label_estyr 1877 "1877", add 
label define label_estyr 1878 "1878", add 
label define label_estyr 1879 "1879", add 
label define label_estyr 1880 "1880", add 
label define label_estyr 1881 "1881", add 
label define label_estyr 1882 "1882", add 
label define label_estyr 1883 "1883", add 
label define label_estyr 1884 "1884", add 
label define label_estyr 1885 "1885", add 
label define label_estyr 1886 "1886", add 
label define label_estyr 1887 "1887", add 
label define label_estyr 1888 "1888", add 
label define label_estyr 1889 "1889", add 
label define label_estyr 1890 "1890", add 
label define label_estyr 1891 "1891", add 
label define label_estyr 1892 "1892", add 
label define label_estyr 1893 "1893", add 
label define label_estyr 1894 "1894", add 
label define label_estyr 1895 "1895", add 
label define label_estyr 1896 "1896", add 
label define label_estyr 1897 "1897", add 
label define label_estyr 1898 "1898", add 
label define label_estyr 1899 "1899", add 
label define label_estyr 1900 "1900", add 
label define label_estyr 1901 "1901", add 
label define label_estyr 1902 "1902", add 
label define label_estyr 1903 "1903", add 
label define label_estyr 1904 "1904", add 
label define label_estyr 1905 "1905", add 
label define label_estyr 1906 "1906", add 
label define label_estyr 1907 "1907", add 
label define label_estyr 1908 "1908", add 
label define label_estyr 1909 "1909", add 
label define label_estyr 1910 "1910", add 
label define label_estyr 1911 "1911", add 
label define label_estyr 1912 "1912", add 
label define label_estyr 1913 "1913", add 
label define label_estyr 1914 "1914", add 
label define label_estyr 1915 "1915", add 
label define label_estyr 1916 "1916", add 
label define label_estyr 1917 "1917", add 
label define label_estyr 1918 "1918", add 
label define label_estyr 1919 "1919", add 
label define label_estyr 1920 "1920", add 
label define label_estyr 1921 "1921", add 
label define label_estyr 1922 "1922", add 
label define label_estyr 1923 "1923", add 
label define label_estyr 1924 "1924", add 
label define label_estyr 1925 "1925", add 
label define label_estyr 1926 "1926", add 
label define label_estyr 1927 "1927", add 
label define label_estyr 1928 "1928", add 
label define label_estyr 1929 "1929", add 
label define label_estyr 1930 "1930", add 
label define label_estyr 1931 "1931", add 
label define label_estyr 1932 "1932", add 
label define label_estyr 1933 "1933", add 
label define label_estyr 1934 "1934", add 
label define label_estyr 1935 "1935", add 
label define label_estyr 1936 "1936", add 
label define label_estyr 1937 "1937", add 
label define label_estyr 1938 "1938", add 
label define label_estyr 1939 "1939", add 
label define label_estyr 1940 "1940", add 
label define label_estyr 1941 "1941", add 
label define label_estyr 1942 "1942", add 
label define label_estyr 1943 "1943", add 
label define label_estyr 1944 "1944", add 
label define label_estyr 1945 "1945", add 
label define label_estyr 1946 "1946", add 
label define label_estyr 1947 "1947", add 
label define label_estyr 1948 "1948", add 
label define label_estyr 1949 "1949", add 
label define label_estyr 1950 "1950", add 
label define label_estyr 1951 "1951", add 
label define label_estyr 1952 "1952", add 
label define label_estyr 1953 "1953", add 
label define label_estyr 1954 "1954", add 
label define label_estyr 1955 "1955", add 
label define label_estyr 1956 "1956", add 
label define label_estyr 1957 "1957", add 
label define label_estyr 1958 "1958", add 
label define label_estyr 1959 "1959", add 
label define label_estyr 1960 "1960", add 
label define label_estyr 1961 "1961", add 
label define label_estyr 1962 "1962", add 
label define label_estyr 1963 "1963", add 
label define label_estyr 1964 "1964", add 
label define label_estyr 1965 "1965", add 
label define label_estyr 1966 "1966", add 
label define label_estyr 1967 "1967", add 
label define label_estyr 1968 "1968", add 
label define label_estyr 1969 "1969", add 
label define label_estyr 1970 "1970", add 
label define label_estyr 1971 "1971", add 
label define label_estyr 1972 "1972", add 
label define label_estyr 1973 "1973", add 
label define label_estyr 1974 "1974", add 
label define label_estyr 1975 "1975", add 
label define label_estyr 1976 "1976", add 
label define label_estyr 1977 "1977", add 
label define label_estyr 1978 "1978", add 
label define label_estyr 1979 "1979", add 
label define label_estyr 1980 "1980", add 
label define label_estyr 1981 "1981", add 
label define label_estyr 1982 "1982", add 
label define label_estyr 1983 "1983", add 
label define label_estyr 1985 "1985", add 
label values estyr label_estyr
/*
label define label_system 5 "Entry unknown" 
label define label_system A "First", add 
label define label_system B "Second", add 
label define label_system C "Third", add 
label define label_system D "Fourth", add 
label define label_system E "Fifth", add 
label define label_system F "Sixth", add 
label define label_system G "Seventh", add 
label define label_system H "Eighth", add 
label define label_system I "Ninth", add 
label define label_system J "Tenth", add 
label define label_system K "Eleventh", add 
label define label_system L "Twelfth", add 
label define label_system M "Thirteenth", add 
label define label_system N "Fourteenth", add 
label define label_system P "Sixteenth", add 
label define label_system Q "Seventeenth", add 
label define label_system R "Eighteenth", add 
label define label_system S "Nineteenth", add 
label define label_system T "Twentieth", add 
label define label_system W "Twenty-third", add 
label define label_system X "Twenty-fourth", add 
label values system label_system
*/
label define label_sequen 1 "01" 
label define label_sequen 2 "02", add 
label define label_sequen 3 "03", add 
label define label_sequen 4 "04", add 
label define label_sequen 5 "05", add 
label define label_sequen 6 "06", add 
label define label_sequen 7 "07", add 
label define label_sequen 8 "08", add 
label define label_sequen 9 "09", add 
label define label_sequen 10 "10", add 
label define label_sequen 11 "11", add 
label define label_sequen 12 "12", add 
label define label_sequen 13 "13", add 
label define label_sequen 14 "14", add 
label define label_sequen 15 "15", add 
label define label_sequen 16 "16", add 
label define label_sequen 17 "17", add 
label define label_sequen 18 "18", add 
label define label_sequen 19 "19", add 
label define label_sequen 20 "20", add 
label define label_sequen 21 "21", add 
label define label_sequen 22 "22", add 
label define label_sequen 23 "23", add 
label define label_sequen 24 "24", add 
label define label_sequen 25 "25", add 
label define label_sequen 26 "26", add 
label define label_sequen 27 "27", add 
label define label_sequen 28 "28", add 
label define label_sequen 29 "29", add 
label define label_sequen 30 "30", add 
label define label_sequen 31 "31", add 
label define label_sequen 32 "32", add 
label define label_sequen 33 "33", add 
label define label_sequen 36 "36", add 
label define label_sequen 37 "37", add 
label define label_sequen 38 "38", add 
label define label_sequen 39 "39", add 
label define label_sequen 41 "41", add 
label define label_sequen 42 "42", add 
label define label_sequen 43 "43", add 
label define label_sequen 44 "44", add 
label define label_sequen 45 "45", add 
label define label_sequen 46 "46", add 
label define label_sequen 47 "47", add 
label define label_sequen 48 "48", add 
label define label_sequen 49 "49", add 
label define label_sequen 50 "50", add 
label define label_sequen 52 "52", add 
label define label_sequen 53 "53", add 
label define label_sequen 54 "54", add 
label define label_sequen 56 "56", add 
label define label_sequen 57 "57", add 
label define label_sequen 58 "58", add 
label define label_sequen 59 "59", add 
label define label_sequen 61 "61", add 
label define label_sequen 62 "62", add 
label define label_sequen 64 "64", add 
label define label_sequen 65 "65", add 
label define label_sequen 66 "66", add 
label define label_sequen 67 "67", add 
label define label_sequen 68 "68", add 
label define label_sequen 69 "69", add 
label define label_sequen 70 "70", add 
label define label_sequen 71 "71", add 
label define label_sequen 72 "72", add 
label define label_sequen 73 "73", add 
label values sequen label_sequen
/*
label define label_status 5 "Individual institution" 
label define label_status 6 "Multicampus institution Having a main campus Main campus", add 
label define label_status 7 "Multicampus institution Having a main campus Branch campus", add 
label define label_status 8 "Multicampus institution Not having a main campus Designated main campus", add 
label define label_status 9 "Multicampus institution Not having a main campus Other campus", add 
label define label_status E "System Institution", add 
label define label_status F "System Main campus", add 
label define label_status G "System Branch campus", add 
label values status label_status
*/
label define label_affil 1 "Public" 
label define label_affil 12 "State", add 
label define label_affil 13 "Local", add 
label define label_affil 14 "State/Local", add 
label define label_affil 2 "Private for-profit", add 
label define label_affil 21 "Independent non-profit", add 
label define label_affil 25 "Organized as profit making", add 
label define label_affil 3 "Private nonprofit, independent", add 
label define label_affil 30 "Roman Catholic", add 
label define label_affil 4 "Private nonprofit, Catholic", add 
label define label_affil 48 "Christian Churches and Churches of Christ", add 
label define label_affil 5 "Private nonprofit, Jewish", add 
label define label_affil 54 "Baptist", add 
label define label_affil 55 "Christian Methodist Episcopal", add 
label define label_affil 57 "Church of God", add 
label define label_affil 6 "Private nonprofit, Protestant", add 
label define label_affil 68 "Lutheran Church - Missouri Synod", add 
label define label_affil 69 "Mennonite Church", add 
label define label_affil 7 "Private nonprofit, other religious affiliation", add 
label define label_affil 75 "Southern Baptist", add 
label values affil label_affil
label define label_calsys 1 "Semester" 
label define label_calsys 2 "Quarter", add 
label define label_calsys 3 "Trimester", add 
label define label_calsys 4 "4-1-4", add 
label define label_calsys 5 "Other", add 
label values calsys label_calsys
label define label_procc 0 "Program not offered" 
label define label_procc 1 "Program offered", add 
label values procc label_procc
label define label_pr2yr 0 "Program not offered" 
label define label_pr2yr 1 "Program offered", add 
label values pr2yr label_pr2yr
label define label_prlib 0 "Program not offered" 
label define label_prlib 1 "Program offered", add 
label values prlib label_prlib
label define label_prtea 0 "Program not offered" 
label define label_prtea 1 "Program offered", add 
label values prtea label_prtea
label define label_prprof 0 "Program not offered" 
label define label_prprof 1 "Program offered", add 
label values prprof label_prprof
label define label_oereg 1 "U.S. service schools" 
label define label_oereg 2 "New England-CT ME MA NH RI VT", add 
label define label_oereg 3 "Mid East-DE DC MD NJ NY PA", add 
label define label_oereg 4 "Great Lakes-IL IN MI OH WI", add 
label define label_oereg 5 "Plains-IA KS MN MO NE ND SD", add 
label define label_oereg 7 "Southeast-AL AR FL GA KY LA MS NC SC TN VA WV", add 
label values oereg label_oereg
/*
label define label_race 1 "Predominent group is 50% or greater of total enrollement Black non-Hispanic" 
label define label_race 2 "Predominent group is 50% or greater of total enrollement American Indian or Alaskan Native", add 
label define label_race 3 "Predominent group is 50% or greater of total enrollement Asian or Pacific Islander", add 
label define label_race 4 "Predominent group is 50% or greater of total enrollement Hispanic", add 
label define label_race 5 "Predominent group is 50% or greater of total enrollement White non-Hispanic (other)", add 
label define label_race 6 "Predominent group is 50% or greater of total enrollement Non-resident alien", add 
label define label_race 9 "Predominent group is 50% or greater of total enrollement Not classified", add 
label define label_race A "Predominent group is largest single group but < 50% of total enrollment Black non-Hispanic", add 
label define label_race B "Predominent group is largest single group but < 50% of total enrollment American Indian or Alaskan Native", add 
label define label_race C "Predominent group is largest single group but < 50% of total enrollment Asian or Pacific Islander", add 
label define label_race D "Predominent group is largest single group but < 50% of total enrollment Hispanic", add 
label define label_race E "Predominent group is largest single group but < 50% of total enrollment White non-Hispanic (other)", add 
label define label_race F "Predominent group is largest single group but < 50% of total enrollment Non-resident alien", add 
label define label_race Z "Predominent group is largest single group but < 50% of total enrollment Not classified", add 
label values race label_race
*/
label define label_sex 1 "Male" 
label define label_sex 2 "Female", add 
label define label_sex 3 "Coed", add 
label define label_sex 4 "Coordinate", add 
label values sex label_sex
label define label_lgrnt 0 "Non-land grant institution" 
label define label_lgrnt 1 "Land grant institution", add 
label define label_lgrnt 2 "Member of NASULGC (National Association of State Universities and Land Grant Colleges)", add 
label values lgrnt label_lgrnt
/*
label define label_cncesc A01 "Doctoral-level institution without medical school" 
label define label_cncesc A02 "Doctoral-level institution with medical school", add 
label define label_cncesc B01 "Comprehensive institutions without medical school", add 
label define label_cncesc B02 "Comprehensive institutions with medical school", add 
label define label_cncesc C01 "General Baccalaureate institutions", add 
label define label_cncesc D01 "Specialized/school of philosophy, religion and theology", add 
label define label_cncesc D02 "Specialized/medical schools", add 
label define label_cncesc D03 "Specialized/other health institutions", add 
label define label_cncesc D04 "Specialized/engineering schools", add 
label define label_cncesc D05 "Specialized/business schools", add 
label define label_cncesc D06 "Specialized/visual and performing arts schools", add 
label define label_cncesc D07 "Specialized/law schools", add 
label define label_cncesc D08 "Specialized/education schools", add 
label define label_cncesc D09 "U.S. service schools", add 
label define label_cncesc D10 "Other specialized schools", add 
label define label_cncesc D11 "Bachelors or higher institutions newly admitted to HEGIS", add 
label define label_cncesc D12 "Specialized/non-degree granting institutions", add 
label define label_cncesc E01 "Multiprogram two-year institutions", add 
label define label_cncesc E04 "Single program two-year institutions", add 
label define label_cncesc E05 "Two-year institutions newly admitted to HEGIS", add 
label values cncesc label_cncesc
*/
label define label_excntl 1 "Publicly controlled" 
label define label_excntl 2 "Privately controlled", add 
label define label_excntl 3 "Religious affiliation", add 
label define label_excntl 4 "Entry unknown", add 
label values excntl label_excntl
label define label_citysi 1 "Outside any SMA" 
label define label_citysi 2 "Anywhere within an SMA of < 250,000", add 
label define label_citysi 3 "Anywhere within an SMA of 250,000 - 499,999", add 
label define label_citysi 4 "Anywhere within an SMA of 500,000 - 999,999", add 
label define label_citysi 5 "In SMA of 1,000,000 - 1,999,999 outside center city", add 
label define label_citysi 6 "In SMA of 1,000,000 - 1,999,999 within center city", add 
label define label_citysi 7 "In SMA or SCSA of 2,000,000 or more outside center", add 
label define label_citysi 8 "In SMA or SCSA of 2,000,000 or more within center city", add 
label values citysi label_citysi
label define label_admreq 1 "Only the ability to profit from attendance" 
label define label_admreq 2 "High school graduation or recognized equivalent", add 
label define label_admreq 3 "High school graduation plus an indication of superior academic aptitude", add 
label define label_admreq 4 "Two year college completion", add 
label define label_admreq 5 "Four year college completion", add 
label define label_admreq 6 "Other any admission < 2 year college completion", add 
label define label_admreq 7 "Other requires 2 years college completion but < 4 years", add 
label define label_admreq 8 "Other requires 4 years or more", add 
label values admreq label_admreq
label define label_estmo 0 "Entry unknown" 
label define label_estmo 1 "January", add 
label define label_estmo 10 "October", add 
label define label_estmo 11 "November", add 
label define label_estmo 12 "December", add 
label define label_estmo 2 "February", add 
label define label_estmo 3 "March", add 
label define label_estmo 36 "Entry unknown", add 
label define label_estmo 4 "April", add 
label define label_estmo 5 "May", add 
label define label_estmo 6 "June", add 
label define label_estmo 7 "July", add 
label define label_estmo 8 "August", add 
label define label_estmo 9 "September", add 
label values estmo label_estmo
label define label_fwrkmoyr 0 "000000" 
label define label_fwrkmoyr 1638 "001638", add 
label define label_fwrkmoyr 1695 "001695", add 
label define label_fwrkmoyr 1701 "001701", add 
label define label_fwrkmoyr 1746 "001746", add 
label define label_fwrkmoyr 1754 "001754", add 
label define label_fwrkmoyr 1769 "001769", add 
label define label_fwrkmoyr 1776 "001776", add 
label define label_fwrkmoyr 1781 "001781", add 
label define label_fwrkmoyr 1782 "001782", add 
label define label_fwrkmoyr 1783 "001783", add 
label define label_fwrkmoyr 1784 "001784", add 
label define label_fwrkmoyr 1785 "001785", add 
label define label_fwrkmoyr 1787 "001787", add 
label define label_fwrkmoyr 1789 "001789", add 
label define label_fwrkmoyr 1793 "001793", add 
label define label_fwrkmoyr 1794 "001794", add 
label define label_fwrkmoyr 1795 "001795", add 
label define label_fwrkmoyr 1800 "001800", add 
label define label_fwrkmoyr 1801 "001801", add 
label define label_fwrkmoyr 1805 "001805", add 
label define label_fwrkmoyr 1807 "001807", add 
label define label_fwrkmoyr 1808 "001808", add 
label define label_fwrkmoyr 1812 "001812", add 
label define label_fwrkmoyr 1817 "001817", add 
label define label_fwrkmoyr 1818 "001818", add 
label define label_fwrkmoyr 1819 "001819", add 
label define label_fwrkmoyr 1820 "001820", add 
label define label_fwrkmoyr 1821 "001821", add 
label define label_fwrkmoyr 1823 "001823", add 
label define label_fwrkmoyr 1824 "001824", add 
label define label_fwrkmoyr 1825 "001825", add 
label define label_fwrkmoyr 1826 "001826", add 
label define label_fwrkmoyr 1827 "001827", add 
label define label_fwrkmoyr 1828 "001828", add 
label define label_fwrkmoyr 1829 "001829", add 
label define label_fwrkmoyr 1830 "001830", add 
label define label_fwrkmoyr 1831 "001831", add 
label define label_fwrkmoyr 1832 "001832", add 
label define label_fwrkmoyr 1833 "001833", add 
label define label_fwrkmoyr 1834 "001834", add 
label define label_fwrkmoyr 1835 "001835", add 
label define label_fwrkmoyr 1836 "001836", add 
label define label_fwrkmoyr 1837 "001837", add 
label define label_fwrkmoyr 1838 "001838", add 
label define label_fwrkmoyr 1839 "001839", add 
label define label_fwrkmoyr 1840 "001840", add 
label define label_fwrkmoyr 1841 "001841", add 
label define label_fwrkmoyr 1842 "001842", add 
label define label_fwrkmoyr 1843 "001843", add 
label define label_fwrkmoyr 1844 "001844", add 
label define label_fwrkmoyr 1845 "001845", add 
label define label_fwrkmoyr 1846 "001846", add 
label define label_fwrkmoyr 1847 "001847", add 
label define label_fwrkmoyr 1848 "001848", add 
label define label_fwrkmoyr 1849 "001849", add 
label define label_fwrkmoyr 1850 "001850", add 
label define label_fwrkmoyr 1851 "001851", add 
label define label_fwrkmoyr 1852 "001852", add 
label define label_fwrkmoyr 1853 "001853", add 
label define label_fwrkmoyr 1854 "001854", add 
label define label_fwrkmoyr 1855 "001855", add 
label define label_fwrkmoyr 1856 "001856", add 
label define label_fwrkmoyr 1857 "001857", add 
label define label_fwrkmoyr 1858 "001858", add 
label define label_fwrkmoyr 1859 "001859", add 
label define label_fwrkmoyr 1860 "001860", add 
label define label_fwrkmoyr 1861 "001861", add 
label define label_fwrkmoyr 1862 "001862", add 
label define label_fwrkmoyr 1863 "001863", add 
label define label_fwrkmoyr 1864 "001864", add 
label define label_fwrkmoyr 1865 "001865", add 
label define label_fwrkmoyr 1866 "001866", add 
label define label_fwrkmoyr 1867 "001867", add 
label define label_fwrkmoyr 1868 "001868", add 
label define label_fwrkmoyr 1869 "001869", add 
label define label_fwrkmoyr 1870 "001870", add 
label define label_fwrkmoyr 1871 "001871", add 
label define label_fwrkmoyr 1872 "001872", add 
label define label_fwrkmoyr 1873 "001873", add 
label define label_fwrkmoyr 1874 "001874", add 
label define label_fwrkmoyr 1875 "001875", add 
label define label_fwrkmoyr 1876 "001876", add 
label define label_fwrkmoyr 1877 "001877", add 
label define label_fwrkmoyr 1878 "001878", add 
label define label_fwrkmoyr 1879 "001879", add 
label define label_fwrkmoyr 1880 "001880", add 
label define label_fwrkmoyr 1881 "001881", add 
label define label_fwrkmoyr 1882 "001882", add 
label define label_fwrkmoyr 1883 "001883", add 
label define label_fwrkmoyr 1884 "001884", add 
label define label_fwrkmoyr 1885 "001885", add 
label define label_fwrkmoyr 1886 "001886", add 
label define label_fwrkmoyr 1887 "001887", add 
label define label_fwrkmoyr 1888 "001888", add 
label define label_fwrkmoyr 1889 "001889", add 
label define label_fwrkmoyr 1890 "001890", add 
label define label_fwrkmoyr 1891 "001891", add 
label define label_fwrkmoyr 1892 "001892", add 
label define label_fwrkmoyr 1893 "001893", add 
label define label_fwrkmoyr 1894 "001894", add 
label define label_fwrkmoyr 1895 "001895", add 
label define label_fwrkmoyr 1896 "001896", add 
label define label_fwrkmoyr 1897 "001897", add 
label define label_fwrkmoyr 1898 "001898", add 
label define label_fwrkmoyr 1899 "001899", add 
label define label_fwrkmoyr 1900 "001900", add 
label define label_fwrkmoyr 1901 "001901", add 
label define label_fwrkmoyr 1902 "001902", add 
label define label_fwrkmoyr 1903 "001903", add 
label define label_fwrkmoyr 1904 "001904", add 
label define label_fwrkmoyr 1905 "001905", add 
label define label_fwrkmoyr 1906 "001906", add 
label define label_fwrkmoyr 1907 "001907", add 
label define label_fwrkmoyr 1908 "001908", add 
label define label_fwrkmoyr 1909 "001909", add 
label define label_fwrkmoyr 1910 "001910", add 
label define label_fwrkmoyr 1911 "001911", add 
label define label_fwrkmoyr 1912 "001912", add 
label define label_fwrkmoyr 1913 "001913", add 
label define label_fwrkmoyr 1914 "001914", add 
label define label_fwrkmoyr 1915 "001915", add 
label define label_fwrkmoyr 1916 "001916", add 
label define label_fwrkmoyr 1917 "001917", add 
label define label_fwrkmoyr 1918 "001918", add 
label define label_fwrkmoyr 1919 "001919", add 
label define label_fwrkmoyr 1920 "001920", add 
label define label_fwrkmoyr 1921 "001921", add 
label define label_fwrkmoyr 1922 "001922", add 
label define label_fwrkmoyr 1923 "001923", add 
label define label_fwrkmoyr 1924 "001924", add 
label define label_fwrkmoyr 1925 "001925", add 
label define label_fwrkmoyr 1926 "001926", add 
label define label_fwrkmoyr 1927 "001927", add 
label define label_fwrkmoyr 1928 "001928", add 
label define label_fwrkmoyr 1929 "001929", add 
label define label_fwrkmoyr 1930 "001930", add 
label define label_fwrkmoyr 1931 "001931", add 
label define label_fwrkmoyr 1932 "001932", add 
label define label_fwrkmoyr 1933 "001933", add 
label define label_fwrkmoyr 1934 "001934", add 
label define label_fwrkmoyr 1935 "001935", add 
label define label_fwrkmoyr 1936 "001936", add 
label define label_fwrkmoyr 1937 "001937", add 
label define label_fwrkmoyr 1938 "001938", add 
label define label_fwrkmoyr 1939 "001939", add 
label define label_fwrkmoyr 1940 "001940", add 
label define label_fwrkmoyr 1941 "001941", add 
label define label_fwrkmoyr 1942 "001942", add 
label define label_fwrkmoyr 1943 "001943", add 
label define label_fwrkmoyr 1944 "001944", add 
label define label_fwrkmoyr 1945 "001945", add 
label define label_fwrkmoyr 1946 "001946", add 
label define label_fwrkmoyr 1947 "001947", add 
label define label_fwrkmoyr 1948 "001948", add 
label define label_fwrkmoyr 1949 "001949", add 
label define label_fwrkmoyr 1950 "001950", add 
label define label_fwrkmoyr 1951 "001951", add 
label define label_fwrkmoyr 1952 "001952", add 
label define label_fwrkmoyr 1953 "001953", add 
label define label_fwrkmoyr 1954 "001954", add 
label define label_fwrkmoyr 1955 "001955", add 
label define label_fwrkmoyr 1956 "001956", add 
label define label_fwrkmoyr 1957 "001957", add 
label define label_fwrkmoyr 1958 "001958", add 
label define label_fwrkmoyr 1959 "001959", add 
label define label_fwrkmoyr 1960 "001960", add 
label define label_fwrkmoyr 1961 "001961", add 
label define label_fwrkmoyr 1962 "001962", add 
label define label_fwrkmoyr 1963 "001963", add 
label define label_fwrkmoyr 1964 "001964", add 
label define label_fwrkmoyr 1965 "001965", add 
label define label_fwrkmoyr 1966 "001966", add 
label define label_fwrkmoyr 1967 "001967", add 
label define label_fwrkmoyr 1968 "001968", add 
label define label_fwrkmoyr 1969 "001969", add 
label define label_fwrkmoyr 1970 "001970", add 
label define label_fwrkmoyr 1971 "001971", add 
label define label_fwrkmoyr 1972 "001972", add 
label define label_fwrkmoyr 1973 "001973", add 
label define label_fwrkmoyr 1974 "001974", add 
label define label_fwrkmoyr 1975 "001975", add 
label define label_fwrkmoyr 1976 "001976", add 
label define label_fwrkmoyr 1977 "001977", add 
label define label_fwrkmoyr 1978 "001978", add 
label define label_fwrkmoyr 1979 "001979", add 
label define label_fwrkmoyr 1980 "001980", add 
label define label_fwrkmoyr 1981 "001981", add 
label define label_fwrkmoyr 1982 "001982", add 
label define label_fwrkmoyr 1984 "001984", add 
label define label_fwrkmoyr 11776 "011776", add 
label define label_fwrkmoyr 11795 "011795", add 
label define label_fwrkmoyr 11826 "011826", add 
label define label_fwrkmoyr 11830 "011830", add 
label define label_fwrkmoyr 11835 "011835", add 
label define label_fwrkmoyr 11837 "011837", add 
label define label_fwrkmoyr 11847 "011847", add 
label define label_fwrkmoyr 11850 "011850", add 
label define label_fwrkmoyr 11851 "011851", add 
label define label_fwrkmoyr 11856 "011856", add 
label define label_fwrkmoyr 11857 "011857", add 
label define label_fwrkmoyr 11858 "011858", add 
label define label_fwrkmoyr 11865 "011865", add 
label define label_fwrkmoyr 11866 "011866", add 
label define label_fwrkmoyr 11870 "011870", add 
label define label_fwrkmoyr 11871 "011871", add 
label define label_fwrkmoyr 11872 "011872", add 
label define label_fwrkmoyr 11873 "011873", add 
label define label_fwrkmoyr 11879 "011879", add 
label define label_fwrkmoyr 11885 "011885", add 
label define label_fwrkmoyr 11886 "011886", add 
label define label_fwrkmoyr 11891 "011891", add 
label define label_fwrkmoyr 11897 "011897", add 
label define label_fwrkmoyr 11901 "011901", add 
label define label_fwrkmoyr 11904 "011904", add 
label define label_fwrkmoyr 11905 "011905", add 
label define label_fwrkmoyr 11918 "011918", add 
label define label_fwrkmoyr 11922 "011922", add 
label define label_fwrkmoyr 11925 "011925", add 
label define label_fwrkmoyr 11927 "011927", add 
label define label_fwrkmoyr 11931 "011931", add 
label define label_fwrkmoyr 11935 "011935", add 
label define label_fwrkmoyr 11939 "011939", add 
label define label_fwrkmoyr 11940 "011940", add 
label define label_fwrkmoyr 11945 "011945", add 
label define label_fwrkmoyr 11948 "011948", add 
label define label_fwrkmoyr 11950 "011950", add 
label define label_fwrkmoyr 11959 "011959", add 
label define label_fwrkmoyr 11960 "011960", add 
label define label_fwrkmoyr 11964 "011964", add 
label define label_fwrkmoyr 11965 "011965", add 
label define label_fwrkmoyr 11966 "011966", add 
label define label_fwrkmoyr 11967 "011967", add 
label define label_fwrkmoyr 11968 "011968", add 
label define label_fwrkmoyr 11969 "011969", add 
label define label_fwrkmoyr 11970 "011970", add 
label define label_fwrkmoyr 11971 "011971", add 
label define label_fwrkmoyr 11972 "011972", add 
label define label_fwrkmoyr 11973 "011973", add 
label define label_fwrkmoyr 11974 "011974", add 
label define label_fwrkmoyr 11975 "011975", add 
label define label_fwrkmoyr 11976 "011976", add 
label define label_fwrkmoyr 11979 "011979", add 
label define label_fwrkmoyr 11980 "011980", add 
label define label_fwrkmoyr 21785 "021785", add 
label define label_fwrkmoyr 21834 "021834", add 
label define label_fwrkmoyr 21849 "021849", add 
label define label_fwrkmoyr 21855 "021855", add 
label define label_fwrkmoyr 21856 "021856", add 
label define label_fwrkmoyr 21857 "021857", add 
label define label_fwrkmoyr 21859 "021859", add 
label define label_fwrkmoyr 21865 "021865", add 
label define label_fwrkmoyr 21867 "021867", add 
label define label_fwrkmoyr 21872 "021872", add 
label define label_fwrkmoyr 21883 "021883", add 
label define label_fwrkmoyr 21886 "021886", add 
label define label_fwrkmoyr 21887 "021887", add 
label define label_fwrkmoyr 21889 "021889", add 
label define label_fwrkmoyr 21892 "021892", add 
label define label_fwrkmoyr 21894 "021894", add 
label define label_fwrkmoyr 21906 "021906", add 
label define label_fwrkmoyr 21929 "021929", add 
label define label_fwrkmoyr 21936 "021936", add 
label define label_fwrkmoyr 21946 "021946", add 
label define label_fwrkmoyr 21950 "021950", add 
label define label_fwrkmoyr 21952 "021952", add 
label define label_fwrkmoyr 21960 "021960", add 
label define label_fwrkmoyr 21961 "021961", add 
label define label_fwrkmoyr 21963 "021963", add 
label define label_fwrkmoyr 21965 "021965", add 
label define label_fwrkmoyr 21966 "021966", add 
label define label_fwrkmoyr 21967 "021967", add 
label define label_fwrkmoyr 21968 "021968", add 
label define label_fwrkmoyr 21969 "021969", add 
label define label_fwrkmoyr 21970 "021970", add 
label define label_fwrkmoyr 21971 "021971", add 
label define label_fwrkmoyr 21972 "021972", add 
label define label_fwrkmoyr 21974 "021974", add 
label define label_fwrkmoyr 21975 "021975", add 
label define label_fwrkmoyr 21982 "021982", add 
label define label_fwrkmoyr 21984 "021984", add 
label define label_fwrkmoyr 31802 "031802", add 
label define label_fwrkmoyr 31840 "031840", add 
label define label_fwrkmoyr 31843 "031843", add 
label define label_fwrkmoyr 31855 "031855", add 
label define label_fwrkmoyr 31859 "031859", add 
label define label_fwrkmoyr 31861 "031861", add 
label define label_fwrkmoyr 31868 "031868", add 
label define label_fwrkmoyr 31869 "031869", add 
label define label_fwrkmoyr 31876 "031876", add 
label define label_fwrkmoyr 31884 "031884", add 
label define label_fwrkmoyr 31897 "031897", add 
label define label_fwrkmoyr 31903 "031903", add 
label define label_fwrkmoyr 31925 "031925", add 
label define label_fwrkmoyr 31927 "031927", add 
label define label_fwrkmoyr 31929 "031929", add 
label define label_fwrkmoyr 31937 "031937", add 
label define label_fwrkmoyr 31942 "031942", add 
label define label_fwrkmoyr 31947 "031947", add 
label define label_fwrkmoyr 31948 "031948", add 
label define label_fwrkmoyr 31958 "031958", add 
label define label_fwrkmoyr 31964 "031964", add 
label define label_fwrkmoyr 31966 "031966", add 
label define label_fwrkmoyr 31968 "031968", add 
label define label_fwrkmoyr 31969 "031969", add 
label define label_fwrkmoyr 31971 "031971", add 
label define label_fwrkmoyr 31972 "031972", add 
label define label_fwrkmoyr 31973 "031973", add 
label define label_fwrkmoyr 31974 "031974", add 
label define label_fwrkmoyr 31978 "031978", add 
label define label_fwrkmoyr 41825 "041825", add 
label define label_fwrkmoyr 41834 "041834", add 
label define label_fwrkmoyr 41838 "041838", add 
label define label_fwrkmoyr 41846 "041846", add 
label define label_fwrkmoyr 41848 "041848", add 
label define label_fwrkmoyr 41851 "041851", add 
label define label_fwrkmoyr 41852 "041852", add 
label define label_fwrkmoyr 41863 "041863", add 
label define label_fwrkmoyr 41873 "041873", add 
label define label_fwrkmoyr 41882 "041882", add 
label define label_fwrkmoyr 41911 "041911", add 
label define label_fwrkmoyr 41912 "041912", add 
label define label_fwrkmoyr 41914 "041914", add 
label define label_fwrkmoyr 41925 "041925", add 
label define label_fwrkmoyr 41927 "041927", add 
label define label_fwrkmoyr 41945 "041945", add 
label define label_fwrkmoyr 41946 "041946", add 
label define label_fwrkmoyr 41947 "041947", add 
label define label_fwrkmoyr 41953 "041953", add 
label define label_fwrkmoyr 41956 "041956", add 
label define label_fwrkmoyr 41966 "041966", add 
label define label_fwrkmoyr 41969 "041969", add 
label define label_fwrkmoyr 41971 "041971", add 
label define label_fwrkmoyr 41972 "041972", add 
label define label_fwrkmoyr 41973 "041973", add 
label define label_fwrkmoyr 41974 "041974", add 
label define label_fwrkmoyr 41975 "041975", add 
label define label_fwrkmoyr 41979 "041979", add 
label define label_fwrkmoyr 41981 "041981", add 
label define label_fwrkmoyr 51820 "051820", add 
label define label_fwrkmoyr 51832 "051832", add 
label define label_fwrkmoyr 51850 "051850", add 
label define label_fwrkmoyr 51851 "051851", add 
label define label_fwrkmoyr 51861 "051861", add 
label define label_fwrkmoyr 51871 "051871", add 
label define label_fwrkmoyr 51874 "051874", add 
label define label_fwrkmoyr 51875 "051875", add 
label define label_fwrkmoyr 51882 "051882", add 
label define label_fwrkmoyr 51886 "051886", add 
label define label_fwrkmoyr 51892 "051892", add 
label define label_fwrkmoyr 51902 "051902", add 
label define label_fwrkmoyr 51917 "051917", add 
label define label_fwrkmoyr 51919 "051919", add 
label define label_fwrkmoyr 51923 "051923", add 
label define label_fwrkmoyr 51930 "051930", add 
label define label_fwrkmoyr 51932 "051932", add 
label define label_fwrkmoyr 51946 "051946", add 
label define label_fwrkmoyr 51961 "051961", add 
label define label_fwrkmoyr 51962 "051962", add 
label define label_fwrkmoyr 51963 "051963", add 
label define label_fwrkmoyr 51965 "051965", add 
label define label_fwrkmoyr 51966 "051966", add 
label define label_fwrkmoyr 51969 "051969", add 
label define label_fwrkmoyr 51972 "051972", add 
label define label_fwrkmoyr 51973 "051973", add 
label define label_fwrkmoyr 51974 "051974", add 
label define label_fwrkmoyr 51975 "051975", add 
label define label_fwrkmoyr 51977 "051977", add 
label define label_fwrkmoyr 51982 "051982", add 
label define label_fwrkmoyr 61851 "061851", add 
label define label_fwrkmoyr 61852 "061852", add 
label define label_fwrkmoyr 61858 "061858", add 
label define label_fwrkmoyr 61871 "061871", add 
label define label_fwrkmoyr 61895 "061895", add 
label define label_fwrkmoyr 61902 "061902", add 
label define label_fwrkmoyr 61903 "061903", add 
label define label_fwrkmoyr 61904 "061904", add 
label define label_fwrkmoyr 61905 "061905", add 
label define label_fwrkmoyr 61909 "061909", add 
label define label_fwrkmoyr 61911 "061911", add 
label define label_fwrkmoyr 61913 "061913", add 
label define label_fwrkmoyr 61918 "061918", add 
label define label_fwrkmoyr 61919 "061919", add 
label define label_fwrkmoyr 61920 "061920", add 
label define label_fwrkmoyr 61925 "061925", add 
label define label_fwrkmoyr 61933 "061933", add 
label define label_fwrkmoyr 61938 "061938", add 
label define label_fwrkmoyr 61946 "061946", add 
label define label_fwrkmoyr 61947 "061947", add 
label define label_fwrkmoyr 61951 "061951", add 
label define label_fwrkmoyr 61952 "061952", add 
label define label_fwrkmoyr 61954 "061954", add 
label define label_fwrkmoyr 61956 "061956", add 
label define label_fwrkmoyr 61958 "061958", add 
label define label_fwrkmoyr 61962 "061962", add 
label define label_fwrkmoyr 61963 "061963", add 
label define label_fwrkmoyr 61964 "061964", add 
label define label_fwrkmoyr 61965 "061965", add 
label define label_fwrkmoyr 61966 "061966", add 
label define label_fwrkmoyr 61967 "061967", add 
label define label_fwrkmoyr 61968 "061968", add 
label define label_fwrkmoyr 61969 "061969", add 
label define label_fwrkmoyr 61970 "061970", add 
label define label_fwrkmoyr 61971 "061971", add 
label define label_fwrkmoyr 61973 "061973", add 
label define label_fwrkmoyr 61974 "061974", add 
label define label_fwrkmoyr 61975 "061975", add 
label define label_fwrkmoyr 61978 "061978", add 
label define label_fwrkmoyr 61981 "061981", add 
label define label_fwrkmoyr 71754 "071754", add 
label define label_fwrkmoyr 71856 "071856", add 
label define label_fwrkmoyr 71874 "071874", add 
label define label_fwrkmoyr 71877 "071877", add 
label define label_fwrkmoyr 71884 "071884", add 
label define label_fwrkmoyr 71885 "071885", add 
label define label_fwrkmoyr 71893 "071893", add 
label define label_fwrkmoyr 71904 "071904", add 
label define label_fwrkmoyr 71909 "071909", add 
label define label_fwrkmoyr 71928 "071928", add 
label define label_fwrkmoyr 71931 "071931", add 
label define label_fwrkmoyr 71943 "071943", add 
label define label_fwrkmoyr 71947 "071947", add 
label define label_fwrkmoyr 71950 "071950", add 
label define label_fwrkmoyr 71953 "071953", add 
label define label_fwrkmoyr 71954 "071954", add 
label define label_fwrkmoyr 71955 "071955", add 
label define label_fwrkmoyr 71959 "071959", add 
label define label_fwrkmoyr 71963 "071963", add 
label define label_fwrkmoyr 71964 "071964", add 
label define label_fwrkmoyr 71965 "071965", add 
label define label_fwrkmoyr 71966 "071966", add 
label define label_fwrkmoyr 71967 "071967", add 
label define label_fwrkmoyr 71968 "071968", add 
label define label_fwrkmoyr 71969 "071969", add 
label define label_fwrkmoyr 71970 "071970", add 
label define label_fwrkmoyr 71971 "071971", add 
label define label_fwrkmoyr 71972 "071972", add 
label define label_fwrkmoyr 71973 "071973", add 
label define label_fwrkmoyr 71974 "071974", add 
label define label_fwrkmoyr 71975 "071975", add 
label define label_fwrkmoyr 71977 "071977", add 
label define label_fwrkmoyr 71979 "071979", add 
label define label_fwrkmoyr 71981 "071981", add 
label define label_fwrkmoyr 81812 "081812", add 
label define label_fwrkmoyr 81854 "081854", add 
label define label_fwrkmoyr 81856 "081856", add 
label define label_fwrkmoyr 81857 "081857", add 
label define label_fwrkmoyr 81860 "081860", add 
label define label_fwrkmoyr 81863 "081863", add 
label define label_fwrkmoyr 81865 "081865", add 
label define label_fwrkmoyr 81867 "081867", add 
label define label_fwrkmoyr 81876 "081876", add 
label define label_fwrkmoyr 81878 "081878", add 
label define label_fwrkmoyr 81884 "081884", add 
label define label_fwrkmoyr 81891 "081891", add 
label define label_fwrkmoyr 81895 "081895", add 
label define label_fwrkmoyr 81897 "081897", add 
label define label_fwrkmoyr 81903 "081903", add 
label define label_fwrkmoyr 81911 "081911", add 
label define label_fwrkmoyr 81912 "081912", add 
label define label_fwrkmoyr 81916 "081916", add 
label define label_fwrkmoyr 81917 "081917", add 
label define label_fwrkmoyr 81921 "081921", add 
label define label_fwrkmoyr 81924 "081924", add 
label define label_fwrkmoyr 81925 "081925", add 
label define label_fwrkmoyr 81929 "081929", add 
label define label_fwrkmoyr 81930 "081930", add 
label define label_fwrkmoyr 81931 "081931", add 
label define label_fwrkmoyr 81933 "081933", add 
label define label_fwrkmoyr 81935 "081935", add 
label define label_fwrkmoyr 81937 "081937", add 
label define label_fwrkmoyr 81948 "081948", add 
label define label_fwrkmoyr 81949 "081949", add 
label define label_fwrkmoyr 81951 "081951", add 
label define label_fwrkmoyr 81958 "081958", add 
label define label_fwrkmoyr 81961 "081961", add 
label define label_fwrkmoyr 81962 "081962", add 
label define label_fwrkmoyr 81963 "081963", add 
label define label_fwrkmoyr 81964 "081964", add 
label define label_fwrkmoyr 81965 "081965", add 
label define label_fwrkmoyr 81966 "081966", add 
label define label_fwrkmoyr 81967 "081967", add 
label define label_fwrkmoyr 81968 "081968", add 
label define label_fwrkmoyr 81969 "081969", add 
label define label_fwrkmoyr 81970 "081970", add 
label define label_fwrkmoyr 81971 "081971", add 
label define label_fwrkmoyr 81972 "081972", add 
label define label_fwrkmoyr 81973 "081973", add 
label define label_fwrkmoyr 81974 "081974", add 
label define label_fwrkmoyr 81975 "081975", add 
label define label_fwrkmoyr 81976 "081976", add 
label define label_fwrkmoyr 81977 "081977", add 
label define label_fwrkmoyr 81978 "081978", add 
label define label_fwrkmoyr 81980 "081980", add 
label define label_fwrkmoyr 81983 "081983", add 
label define label_fwrkmoyr 91765 "091765", add 
label define label_fwrkmoyr 91801 "091801", add 
label define label_fwrkmoyr 91802 "091802", add 
label define label_fwrkmoyr 91813 "091813", add 
label define label_fwrkmoyr 91816 "091816", add 
label define label_fwrkmoyr 91819 "091819", add 
label define label_fwrkmoyr 91821 "091821", add 
label define label_fwrkmoyr 91822 "091822", add 
label define label_fwrkmoyr 91824 "091824", add 
label define label_fwrkmoyr 91830 "091830", add 
label define label_fwrkmoyr 91831 "091831", add 
label define label_fwrkmoyr 91832 "091832", add 
label define label_fwrkmoyr 91834 "091834", add 
label define label_fwrkmoyr 91836 "091836", add 
label define label_fwrkmoyr 91837 "091837", add 
label define label_fwrkmoyr 91838 "091838", add 
label define label_fwrkmoyr 91840 "091840", add 
label define label_fwrkmoyr 91842 "091842", add 
label define label_fwrkmoyr 91843 "091843", add 
label define label_fwrkmoyr 91844 "091844", add 
label define label_fwrkmoyr 91846 "091846", add 
label define label_fwrkmoyr 91847 "091847", add 
label define label_fwrkmoyr 91848 "091848", add 
label define label_fwrkmoyr 91849 "091849", add 
label define label_fwrkmoyr 91852 "091852", add 
label define label_fwrkmoyr 91853 "091853", add 
label define label_fwrkmoyr 91854 "091854", add 
label define label_fwrkmoyr 91855 "091855", add 
label define label_fwrkmoyr 91856 "091856", add 
label define label_fwrkmoyr 91858 "091858", add 
label define label_fwrkmoyr 91859 "091859", add 
label define label_fwrkmoyr 91860 "091860", add 
label define label_fwrkmoyr 91861 "091861", add 
label define label_fwrkmoyr 91863 "091863", add 
label define label_fwrkmoyr 91864 "091864", add 
label define label_fwrkmoyr 91865 "091865", add 
label define label_fwrkmoyr 91866 "091866", add 
label define label_fwrkmoyr 91867 "091867", add 
label define label_fwrkmoyr 91868 "091868", add 
label define label_fwrkmoyr 91869 "091869", add 
label define label_fwrkmoyr 91870 "091870", add 
label define label_fwrkmoyr 91871 "091871", add 
label define label_fwrkmoyr 91872 "091872", add 
label define label_fwrkmoyr 91873 "091873", add 
label define label_fwrkmoyr 91874 "091874", add 
label define label_fwrkmoyr 91875 "091875", add 
label define label_fwrkmoyr 91876 "091876", add 
label define label_fwrkmoyr 91877 "091877", add 
label define label_fwrkmoyr 91878 "091878", add 
label define label_fwrkmoyr 91879 "091879", add 
label define label_fwrkmoyr 91880 "091880", add 
label define label_fwrkmoyr 91881 "091881", add 
label define label_fwrkmoyr 91882 "091882", add 
label define label_fwrkmoyr 91883 "091883", add 
label define label_fwrkmoyr 91884 "091884", add 
label define label_fwrkmoyr 91885 "091885", add 
label define label_fwrkmoyr 91886 "091886", add 
label define label_fwrkmoyr 91887 "091887", add 
label define label_fwrkmoyr 91888 "091888", add 
label define label_fwrkmoyr 91889 "091889", add 
label define label_fwrkmoyr 91890 "091890", add 
label define label_fwrkmoyr 91891 "091891", add 
label define label_fwrkmoyr 91892 "091892", add 
label define label_fwrkmoyr 91893 "091893", add 
label define label_fwrkmoyr 91894 "091894", add 
label define label_fwrkmoyr 91895 "091895", add 
label define label_fwrkmoyr 91896 "091896", add 
label define label_fwrkmoyr 91897 "091897", add 
label define label_fwrkmoyr 91898 "091898", add 
label define label_fwrkmoyr 91899 "091899", add 
label define label_fwrkmoyr 91900 "091900", add 
label define label_fwrkmoyr 91901 "091901", add 
label define label_fwrkmoyr 91902 "091902", add 
label define label_fwrkmoyr 91903 "091903", add 
label define label_fwrkmoyr 91904 "091904", add 
label define label_fwrkmoyr 91905 "091905", add 
label define label_fwrkmoyr 91906 "091906", add 
label define label_fwrkmoyr 91907 "091907", add 
label define label_fwrkmoyr 91908 "091908", add 
label define label_fwrkmoyr 91909 "091909", add 
label define label_fwrkmoyr 91910 "091910", add 
label define label_fwrkmoyr 91911 "091911", add 
label define label_fwrkmoyr 91912 "091912", add 
label define label_fwrkmoyr 91913 "091913", add 
label define label_fwrkmoyr 91914 "091914", add 
label define label_fwrkmoyr 91915 "091915", add 
label define label_fwrkmoyr 91916 "091916", add 
label define label_fwrkmoyr 91917 "091917", add 
label define label_fwrkmoyr 91918 "091918", add 
label define label_fwrkmoyr 91919 "091919", add 
label define label_fwrkmoyr 91920 "091920", add 
label define label_fwrkmoyr 91921 "091921", add 
label define label_fwrkmoyr 91922 "091922", add 
label define label_fwrkmoyr 91923 "091923", add 
label define label_fwrkmoyr 91924 "091924", add 
label define label_fwrkmoyr 91925 "091925", add 
label define label_fwrkmoyr 91926 "091926", add 
label define label_fwrkmoyr 91927 "091927", add 
label define label_fwrkmoyr 91928 "091928", add 
label define label_fwrkmoyr 91929 "091929", add 
label define label_fwrkmoyr 91930 "091930", add 
label define label_fwrkmoyr 91931 "091931", add 
label define label_fwrkmoyr 91932 "091932", add 
label define label_fwrkmoyr 91933 "091933", add 
label define label_fwrkmoyr 91934 "091934", add 
label define label_fwrkmoyr 91935 "091935", add 
label define label_fwrkmoyr 91936 "091936", add 
label define label_fwrkmoyr 91937 "091937", add 
label define label_fwrkmoyr 91938 "091938", add 
label define label_fwrkmoyr 91939 "091939", add 
label define label_fwrkmoyr 91940 "091940", add 
label define label_fwrkmoyr 91941 "091941", add 
label define label_fwrkmoyr 91942 "091942", add 
label define label_fwrkmoyr 91944 "091944", add 
label define label_fwrkmoyr 91945 "091945", add 
label define label_fwrkmoyr 91946 "091946", add 
label define label_fwrkmoyr 91947 "091947", add 
label define label_fwrkmoyr 91948 "091948", add 
label define label_fwrkmoyr 91949 "091949", add 
label define label_fwrkmoyr 91950 "091950", add 
label define label_fwrkmoyr 91951 "091951", add 
label define label_fwrkmoyr 91952 "091952", add 
label define label_fwrkmoyr 91953 "091953", add 
label define label_fwrkmoyr 91954 "091954", add 
label define label_fwrkmoyr 91955 "091955", add 
label define label_fwrkmoyr 91956 "091956", add 
label define label_fwrkmoyr 91957 "091957", add 
label define label_fwrkmoyr 91958 "091958", add 
label define label_fwrkmoyr 91959 "091959", add 
label define label_fwrkmoyr 91960 "091960", add 
label define label_fwrkmoyr 91961 "091961", add 
label define label_fwrkmoyr 91962 "091962", add 
label define label_fwrkmoyr 91963 "091963", add 
label define label_fwrkmoyr 91964 "091964", add 
label define label_fwrkmoyr 91965 "091965", add 
label define label_fwrkmoyr 91966 "091966", add 
label define label_fwrkmoyr 91967 "091967", add 
label define label_fwrkmoyr 91968 "091968", add 
label define label_fwrkmoyr 91969 "091969", add 
label define label_fwrkmoyr 91970 "091970", add 
label define label_fwrkmoyr 91971 "091971", add 
label define label_fwrkmoyr 91972 "091972", add 
label define label_fwrkmoyr 91973 "091973", add 
label define label_fwrkmoyr 91974 "091974", add 
label define label_fwrkmoyr 91975 "091975", add 
label define label_fwrkmoyr 91976 "091976", add 
label define label_fwrkmoyr 91977 "091977", add 
label define label_fwrkmoyr 91978 "091978", add 
label define label_fwrkmoyr 91979 "091979", add 
label define label_fwrkmoyr 91980 "091980", add 
label define label_fwrkmoyr 91981 "091981", add 
label define label_fwrkmoyr 91982 "091982", add 
label define label_fwrkmoyr 91983 "091983", add 
label define label_fwrkmoyr 101770 "101770", add 
label define label_fwrkmoyr 101791 "101791", add 
label define label_fwrkmoyr 101804 "101804", add 
label define label_fwrkmoyr 101821 "101821", add 
label define label_fwrkmoyr 101826 "101826", add 
label define label_fwrkmoyr 101831 "101831", add 
label define label_fwrkmoyr 101832 "101832", add 
label define label_fwrkmoyr 101833 "101833", add 
label define label_fwrkmoyr 101834 "101834", add 
label define label_fwrkmoyr 101846 "101846", add 
label define label_fwrkmoyr 101848 "101848", add 
label define label_fwrkmoyr 101850 "101850", add 
label define label_fwrkmoyr 101857 "101857", add 
label define label_fwrkmoyr 101858 "101858", add 
label define label_fwrkmoyr 101859 "101859", add 
label define label_fwrkmoyr 101864 "101864", add 
label define label_fwrkmoyr 101867 "101867", add 
label define label_fwrkmoyr 101868 "101868", add 
label define label_fwrkmoyr 101870 "101870", add 
label define label_fwrkmoyr 101871 "101871", add 
label define label_fwrkmoyr 101872 "101872", add 
label define label_fwrkmoyr 101876 "101876", add 
label define label_fwrkmoyr 101878 "101878", add 
label define label_fwrkmoyr 101879 "101879", add 
label define label_fwrkmoyr 101880 "101880", add 
label define label_fwrkmoyr 101882 "101882", add 
label define label_fwrkmoyr 101885 "101885", add 
label define label_fwrkmoyr 101887 "101887", add 
label define label_fwrkmoyr 101888 "101888", add 
label define label_fwrkmoyr 101889 "101889", add 
label define label_fwrkmoyr 101890 "101890", add 
label define label_fwrkmoyr 101891 "101891", add 
label define label_fwrkmoyr 101892 "101892", add 
label define label_fwrkmoyr 101893 "101893", add 
label define label_fwrkmoyr 101897 "101897", add 
label define label_fwrkmoyr 101902 "101902", add 
label define label_fwrkmoyr 101903 "101903", add 
label define label_fwrkmoyr 101905 "101905", add 
label define label_fwrkmoyr 101906 "101906", add 
label define label_fwrkmoyr 101909 "101909", add 
label define label_fwrkmoyr 101910 "101910", add 
label define label_fwrkmoyr 101911 "101911", add 
label define label_fwrkmoyr 101914 "101914", add 
label define label_fwrkmoyr 101915 "101915", add 
label define label_fwrkmoyr 101916 "101916", add 
label define label_fwrkmoyr 101919 "101919", add 
label define label_fwrkmoyr 101923 "101923", add 
label define label_fwrkmoyr 101925 "101925", add 
label define label_fwrkmoyr 101926 "101926", add 
label define label_fwrkmoyr 101927 "101927", add 
label define label_fwrkmoyr 101928 "101928", add 
label define label_fwrkmoyr 101930 "101930", add 
label define label_fwrkmoyr 101933 "101933", add 
label define label_fwrkmoyr 101934 "101934", add 
label define label_fwrkmoyr 101937 "101937", add 
label define label_fwrkmoyr 101939 "101939", add 
label define label_fwrkmoyr 101941 "101941", add 
label define label_fwrkmoyr 101943 "101943", add 
label define label_fwrkmoyr 101946 "101946", add 
label define label_fwrkmoyr 101947 "101947", add 
label define label_fwrkmoyr 101948 "101948", add 
label define label_fwrkmoyr 101950 "101950", add 
label define label_fwrkmoyr 101953 "101953", add 
label define label_fwrkmoyr 101954 "101954", add 
label define label_fwrkmoyr 101956 "101956", add 
label define label_fwrkmoyr 101957 "101957", add 
label define label_fwrkmoyr 101958 "101958", add 
label define label_fwrkmoyr 101960 "101960", add 
label define label_fwrkmoyr 101962 "101962", add 
label define label_fwrkmoyr 101963 "101963", add 
label define label_fwrkmoyr 101964 "101964", add 
label define label_fwrkmoyr 101965 "101965", add 
label define label_fwrkmoyr 101966 "101966", add 
label define label_fwrkmoyr 101967 "101967", add 
label define label_fwrkmoyr 101968 "101968", add 
label define label_fwrkmoyr 101969 "101969", add 
label define label_fwrkmoyr 101970 "101970", add 
label define label_fwrkmoyr 101971 "101971", add 
label define label_fwrkmoyr 101972 "101972", add 
label define label_fwrkmoyr 101973 "101973", add 
label define label_fwrkmoyr 101974 "101974", add 
label define label_fwrkmoyr 101980 "101980", add 
label define label_fwrkmoyr 101981 "101981", add 
label define label_fwrkmoyr 111819 "111819", add 
label define label_fwrkmoyr 111824 "111824", add 
label define label_fwrkmoyr 111828 "111828", add 
label define label_fwrkmoyr 111837 "111837", add 
label define label_fwrkmoyr 111838 "111838", add 
label define label_fwrkmoyr 111839 "111839", add 
label define label_fwrkmoyr 111845 "111845", add 
label define label_fwrkmoyr 111848 "111848", add 
label define label_fwrkmoyr 111850 "111850", add 
label define label_fwrkmoyr 111858 "111858", add 
label define label_fwrkmoyr 111859 "111859", add 
label define label_fwrkmoyr 111861 "111861", add 
label define label_fwrkmoyr 111871 "111871", add 
label define label_fwrkmoyr 111884 "111884", add 
label define label_fwrkmoyr 111885 "111885", add 
label define label_fwrkmoyr 111886 "111886", add 
label define label_fwrkmoyr 111887 "111887", add 
label define label_fwrkmoyr 111889 "111889", add 
label define label_fwrkmoyr 111891 "111891", add 
label define label_fwrkmoyr 111898 "111898", add 
label define label_fwrkmoyr 111900 "111900", add 
label define label_fwrkmoyr 111915 "111915", add 
label define label_fwrkmoyr 111917 "111917", add 
label define label_fwrkmoyr 111921 "111921", add 
label define label_fwrkmoyr 111927 "111927", add 
label define label_fwrkmoyr 111932 "111932", add 
label define label_fwrkmoyr 111940 "111940", add 
label define label_fwrkmoyr 111955 "111955", add 
label define label_fwrkmoyr 111964 "111964", add 
label define label_fwrkmoyr 111965 "111965", add 
label define label_fwrkmoyr 111967 "111967", add 
label define label_fwrkmoyr 111969 "111969", add 
label define label_fwrkmoyr 111972 "111972", add 
label define label_fwrkmoyr 111973 "111973", add 
label define label_fwrkmoyr 111974 "111974", add 
label define label_fwrkmoyr 111975 "111975", add 
label define label_fwrkmoyr 111978 "111978", add 
label define label_fwrkmoyr 121828 "121828", add 
label define label_fwrkmoyr 121844 "121844", add 
label define label_fwrkmoyr 121849 "121849", add 
label define label_fwrkmoyr 121851 "121851", add 
label define label_fwrkmoyr 121886 "121886", add 
label define label_fwrkmoyr 121891 "121891", add 
label define label_fwrkmoyr 121892 "121892", add 
label define label_fwrkmoyr 121895 "121895", add 
label define label_fwrkmoyr 121917 "121917", add 
label define label_fwrkmoyr 121919 "121919", add 
label define label_fwrkmoyr 121946 "121946", add 
label define label_fwrkmoyr 121953 "121953", add 
label define label_fwrkmoyr 121967 "121967", add 
label define label_fwrkmoyr 121970 "121970", add 
label define label_fwrkmoyr 121974 "121974", add 
label define label_fwrkmoyr 121975 "121975", add 
label define label_fwrkmoyr 121977 "121977", add 
label define label_fwrkmoyr 121979 "121979", add 
label values fwrkmoyr label_fwrkmoyr
label define label_fdgrmoyr 0 "000000" 
label define label_fdgrmoyr 1642 "001642", add 
label define label_fdgrmoyr 1697 "001697", add 
label define label_fdgrmoyr 1703 "001703", add 
label define label_fdgrmoyr 1748 "001748", add 
label define label_fdgrmoyr 1757 "001757", add 
label define label_fdgrmoyr 1771 "001771", add 
label define label_fdgrmoyr 1783 "001783", add 
label define label_fdgrmoyr 1784 "001784", add 
label define label_fdgrmoyr 1786 "001786", add 
label define label_fdgrmoyr 1787 "001787", add 
label define label_fdgrmoyr 1791 "001791", add 
label define label_fdgrmoyr 1793 "001793", add 
label define label_fdgrmoyr 1794 "001794", add 
label define label_fdgrmoyr 1797 "001797", add 
label define label_fdgrmoyr 1798 "001798", add 
label define label_fdgrmoyr 1799 "001799", add 
label define label_fdgrmoyr 1802 "001802", add 
label define label_fdgrmoyr 1807 "001807", add 
label define label_fdgrmoyr 1810 "001810", add 
label define label_fdgrmoyr 1811 "001811", add 
label define label_fdgrmoyr 1814 "001814", add 
label define label_fdgrmoyr 1818 "001818", add 
label define label_fdgrmoyr 1821 "001821", add 
label define label_fdgrmoyr 1822 "001822", add 
label define label_fdgrmoyr 1823 "001823", add 
label define label_fdgrmoyr 1824 "001824", add 
label define label_fdgrmoyr 1826 "001826", add 
label define label_fdgrmoyr 1827 "001827", add 
label define label_fdgrmoyr 1828 "001828", add 
label define label_fdgrmoyr 1829 "001829", add 
label define label_fdgrmoyr 1830 "001830", add 
label define label_fdgrmoyr 1831 "001831", add 
label define label_fdgrmoyr 1832 "001832", add 
label define label_fdgrmoyr 1833 "001833", add 
label define label_fdgrmoyr 1834 "001834", add 
label define label_fdgrmoyr 1835 "001835", add 
label define label_fdgrmoyr 1836 "001836", add 
label define label_fdgrmoyr 1837 "001837", add 
label define label_fdgrmoyr 1838 "001838", add 
label define label_fdgrmoyr 1839 "001839", add 
label define label_fdgrmoyr 1840 "001840", add 
label define label_fdgrmoyr 1841 "001841", add 
label define label_fdgrmoyr 1842 "001842", add 
label define label_fdgrmoyr 1843 "001843", add 
label define label_fdgrmoyr 1844 "001844", add 
label define label_fdgrmoyr 1845 "001845", add 
label define label_fdgrmoyr 1846 "001846", add 
label define label_fdgrmoyr 1847 "001847", add 
label define label_fdgrmoyr 1848 "001848", add 
label define label_fdgrmoyr 1849 "001849", add 
label define label_fdgrmoyr 1850 "001850", add 
label define label_fdgrmoyr 1851 "001851", add 
label define label_fdgrmoyr 1852 "001852", add 
label define label_fdgrmoyr 1853 "001853", add 
label define label_fdgrmoyr 1854 "001854", add 
label define label_fdgrmoyr 1855 "001855", add 
label define label_fdgrmoyr 1856 "001856", add 
label define label_fdgrmoyr 1857 "001857", add 
label define label_fdgrmoyr 1858 "001858", add 
label define label_fdgrmoyr 1859 "001859", add 
label define label_fdgrmoyr 1860 "001860", add 
label define label_fdgrmoyr 1861 "001861", add 
label define label_fdgrmoyr 1862 "001862", add 
label define label_fdgrmoyr 1863 "001863", add 
label define label_fdgrmoyr 1864 "001864", add 
label define label_fdgrmoyr 1865 "001865", add 
label define label_fdgrmoyr 1866 "001866", add 
label define label_fdgrmoyr 1867 "001867", add 
label define label_fdgrmoyr 1868 "001868", add 
label define label_fdgrmoyr 1869 "001869", add 
label define label_fdgrmoyr 1870 "001870", add 
label define label_fdgrmoyr 1871 "001871", add 
label define label_fdgrmoyr 1872 "001872", add 
label define label_fdgrmoyr 1873 "001873", add 
label define label_fdgrmoyr 1874 "001874", add 
label define label_fdgrmoyr 1875 "001875", add 
label define label_fdgrmoyr 1876 "001876", add 
label define label_fdgrmoyr 1877 "001877", add 
label define label_fdgrmoyr 1878 "001878", add 
label define label_fdgrmoyr 1879 "001879", add 
label define label_fdgrmoyr 1880 "001880", add 
label define label_fdgrmoyr 1881 "001881", add 
label define label_fdgrmoyr 1882 "001882", add 
label define label_fdgrmoyr 1883 "001883", add 
label define label_fdgrmoyr 1884 "001884", add 
label define label_fdgrmoyr 1885 "001885", add 
label define label_fdgrmoyr 1886 "001886", add 
label define label_fdgrmoyr 1887 "001887", add 
label define label_fdgrmoyr 1888 "001888", add 
label define label_fdgrmoyr 1889 "001889", add 
label define label_fdgrmoyr 1890 "001890", add 
label define label_fdgrmoyr 1891 "001891", add 
label define label_fdgrmoyr 1892 "001892", add 
label define label_fdgrmoyr 1893 "001893", add 
label define label_fdgrmoyr 1894 "001894", add 
label define label_fdgrmoyr 1895 "001895", add 
label define label_fdgrmoyr 1896 "001896", add 
label define label_fdgrmoyr 1897 "001897", add 
label define label_fdgrmoyr 1898 "001898", add 
label define label_fdgrmoyr 1899 "001899", add 
label define label_fdgrmoyr 1900 "001900", add 
label define label_fdgrmoyr 1901 "001901", add 
label define label_fdgrmoyr 1902 "001902", add 
label define label_fdgrmoyr 1903 "001903", add 
label define label_fdgrmoyr 1904 "001904", add 
label define label_fdgrmoyr 1905 "001905", add 
label define label_fdgrmoyr 1906 "001906", add 
label define label_fdgrmoyr 1907 "001907", add 
label define label_fdgrmoyr 1908 "001908", add 
label define label_fdgrmoyr 1909 "001909", add 
label define label_fdgrmoyr 1910 "001910", add 
label define label_fdgrmoyr 1911 "001911", add 
label define label_fdgrmoyr 1912 "001912", add 
label define label_fdgrmoyr 1913 "001913", add 
label define label_fdgrmoyr 1914 "001914", add 
label define label_fdgrmoyr 1915 "001915", add 
label define label_fdgrmoyr 1916 "001916", add 
label define label_fdgrmoyr 1917 "001917", add 
label define label_fdgrmoyr 1918 "001918", add 
label define label_fdgrmoyr 1919 "001919", add 
label define label_fdgrmoyr 1920 "001920", add 
label define label_fdgrmoyr 1921 "001921", add 
label define label_fdgrmoyr 1922 "001922", add 
label define label_fdgrmoyr 1923 "001923", add 
label define label_fdgrmoyr 1924 "001924", add 
label define label_fdgrmoyr 1925 "001925", add 
label define label_fdgrmoyr 1926 "001926", add 
label define label_fdgrmoyr 1927 "001927", add 
label define label_fdgrmoyr 1928 "001928", add 
label define label_fdgrmoyr 1929 "001929", add 
label define label_fdgrmoyr 1930 "001930", add 
label define label_fdgrmoyr 1931 "001931", add 
label define label_fdgrmoyr 1932 "001932", add 
label define label_fdgrmoyr 1933 "001933", add 
label define label_fdgrmoyr 1934 "001934", add 
label define label_fdgrmoyr 1935 "001935", add 
label define label_fdgrmoyr 1936 "001936", add 
label define label_fdgrmoyr 1937 "001937", add 
label define label_fdgrmoyr 1938 "001938", add 
label define label_fdgrmoyr 1939 "001939", add 
label define label_fdgrmoyr 1940 "001940", add 
label define label_fdgrmoyr 1941 "001941", add 
label define label_fdgrmoyr 1942 "001942", add 
label define label_fdgrmoyr 1943 "001943", add 
label define label_fdgrmoyr 1944 "001944", add 
label define label_fdgrmoyr 1945 "001945", add 
label define label_fdgrmoyr 1946 "001946", add 
label define label_fdgrmoyr 1947 "001947", add 
label define label_fdgrmoyr 1948 "001948", add 
label define label_fdgrmoyr 1949 "001949", add 
label define label_fdgrmoyr 1950 "001950", add 
label define label_fdgrmoyr 1951 "001951", add 
label define label_fdgrmoyr 1952 "001952", add 
label define label_fdgrmoyr 1953 "001953", add 
label define label_fdgrmoyr 1954 "001954", add 
label define label_fdgrmoyr 1955 "001955", add 
label define label_fdgrmoyr 1956 "001956", add 
label define label_fdgrmoyr 1957 "001957", add 
label define label_fdgrmoyr 1958 "001958", add 
label define label_fdgrmoyr 1959 "001959", add 
label define label_fdgrmoyr 1960 "001960", add 
label define label_fdgrmoyr 1961 "001961", add 
label define label_fdgrmoyr 1962 "001962", add 
label define label_fdgrmoyr 1963 "001963", add 
label define label_fdgrmoyr 1964 "001964", add 
label define label_fdgrmoyr 1965 "001965", add 
label define label_fdgrmoyr 1966 "001966", add 
label define label_fdgrmoyr 1967 "001967", add 
label define label_fdgrmoyr 1968 "001968", add 
label define label_fdgrmoyr 1969 "001969", add 
label define label_fdgrmoyr 1970 "001970", add 
label define label_fdgrmoyr 1971 "001971", add 
label define label_fdgrmoyr 1972 "001972", add 
label define label_fdgrmoyr 1973 "001973", add 
label define label_fdgrmoyr 1974 "001974", add 
label define label_fdgrmoyr 1975 "001975", add 
label define label_fdgrmoyr 1976 "001976", add 
label define label_fdgrmoyr 1977 "001977", add 
label define label_fdgrmoyr 1978 "001978", add 
label define label_fdgrmoyr 1979 "001979", add 
label define label_fdgrmoyr 1980 "001980", add 
label define label_fdgrmoyr 1981 "001981", add 
label define label_fdgrmoyr 1982 "001982", add 
label define label_fdgrmoyr 1983 "001983", add 
label define label_fdgrmoyr 1984 "001984", add 
label define label_fdgrmoyr 11859 "011859", add 
label define label_fdgrmoyr 11880 "011880", add 
label define label_fdgrmoyr 11885 "011885", add 
label define label_fdgrmoyr 11898 "011898", add 
label define label_fdgrmoyr 11929 "011929", add 
label define label_fdgrmoyr 11930 "011930", add 
label define label_fdgrmoyr 11949 "011949", add 
label define label_fdgrmoyr 11950 "011950", add 
label define label_fdgrmoyr 11955 "011955", add 
label define label_fdgrmoyr 11958 "011958", add 
label define label_fdgrmoyr 11961 "011961", add 
label define label_fdgrmoyr 11966 "011966", add 
label define label_fdgrmoyr 11967 "011967", add 
label define label_fdgrmoyr 11970 "011970", add 
label define label_fdgrmoyr 11971 "011971", add 
label define label_fdgrmoyr 11973 "011973", add 
label define label_fdgrmoyr 11975 "011975", add 
label define label_fdgrmoyr 11976 "011976", add 
label define label_fdgrmoyr 11977 "011977", add 
label define label_fdgrmoyr 11978 "011978", add 
label define label_fdgrmoyr 11980 "011980", add 
label define label_fdgrmoyr 11982 "011982", add 
label define label_fdgrmoyr 11983 "011983", add 
label define label_fdgrmoyr 11984 "011984", add 
label define label_fdgrmoyr 21946 "021946", add 
label define label_fdgrmoyr 21947 "021947", add 
label define label_fdgrmoyr 21962 "021962", add 
label define label_fdgrmoyr 21964 "021964", add 
label define label_fdgrmoyr 21966 "021966", add 
label define label_fdgrmoyr 21967 "021967", add 
label define label_fdgrmoyr 21968 "021968", add 
label define label_fdgrmoyr 21969 "021969", add 
label define label_fdgrmoyr 21973 "021973", add 
label define label_fdgrmoyr 21974 "021974", add 
label define label_fdgrmoyr 21982 "021982", add 
label define label_fdgrmoyr 21984 "021984", add 
label define label_fdgrmoyr 31848 "031848", add 
label define label_fdgrmoyr 31872 "031872", add 
label define label_fdgrmoyr 31894 "031894", add 
label define label_fdgrmoyr 31914 "031914", add 
label define label_fdgrmoyr 31940 "031940", add 
label define label_fdgrmoyr 31956 "031956", add 
label define label_fdgrmoyr 31960 "031960", add 
label define label_fdgrmoyr 31964 "031964", add 
label define label_fdgrmoyr 31966 "031966", add 
label define label_fdgrmoyr 31967 "031967", add 
label define label_fdgrmoyr 31968 "031968", add 
label define label_fdgrmoyr 31971 "031971", add 
label define label_fdgrmoyr 31972 "031972", add 
label define label_fdgrmoyr 31973 "031973", add 
label define label_fdgrmoyr 31974 "031974", add 
label define label_fdgrmoyr 31976 "031976", add 
label define label_fdgrmoyr 31977 "031977", add 
label define label_fdgrmoyr 31978 "031978", add 
label define label_fdgrmoyr 31980 "031980", add 
label define label_fdgrmoyr 31984 "031984", add 
label define label_fdgrmoyr 41802 "041802", add 
label define label_fdgrmoyr 41825 "041825", add 
label define label_fdgrmoyr 41826 "041826", add 
label define label_fdgrmoyr 41833 "041833", add 
label define label_fdgrmoyr 41836 "041836", add 
label define label_fdgrmoyr 41839 "041839", add 
label define label_fdgrmoyr 41862 "041862", add 
label define label_fdgrmoyr 41872 "041872", add 
label define label_fdgrmoyr 41884 "041884", add 
label define label_fdgrmoyr 41892 "041892", add 
label define label_fdgrmoyr 41910 "041910", add 
label define label_fdgrmoyr 41919 "041919", add 
label define label_fdgrmoyr 41944 "041944", add 
label define label_fdgrmoyr 41947 "041947", add 
label define label_fdgrmoyr 41950 "041950", add 
label define label_fdgrmoyr 41959 "041959", add 
label define label_fdgrmoyr 41965 "041965", add 
label define label_fdgrmoyr 41966 "041966", add 
label define label_fdgrmoyr 41967 "041967", add 
label define label_fdgrmoyr 41972 "041972", add 
label define label_fdgrmoyr 41974 "041974", add 
label define label_fdgrmoyr 41978 "041978", add 
label define label_fdgrmoyr 41979 "041979", add 
label define label_fdgrmoyr 51793 "051793", add 
label define label_fdgrmoyr 51804 "051804", add 
label define label_fdgrmoyr 51815 "051815", add 
label define label_fdgrmoyr 51821 "051821", add 
label define label_fdgrmoyr 51827 "051827", add 
label define label_fdgrmoyr 51838 "051838", add 
label define label_fdgrmoyr 51840 "051840", add 
label define label_fdgrmoyr 51846 "051846", add 
label define label_fdgrmoyr 51847 "051847", add 
label define label_fdgrmoyr 51852 "051852", add 
label define label_fdgrmoyr 51853 "051853", add 
label define label_fdgrmoyr 51855 "051855", add 
label define label_fdgrmoyr 51858 "051858", add 
label define label_fdgrmoyr 51860 "051860", add 
label define label_fdgrmoyr 51861 "051861", add 
label define label_fdgrmoyr 51862 "051862", add 
label define label_fdgrmoyr 51863 "051863", add 
label define label_fdgrmoyr 51865 "051865", add 
label define label_fdgrmoyr 51866 "051866", add 
label define label_fdgrmoyr 51869 "051869", add 
label define label_fdgrmoyr 51870 "051870", add 
label define label_fdgrmoyr 51873 "051873", add 
label define label_fdgrmoyr 51874 "051874", add 
label define label_fdgrmoyr 51876 "051876", add 
label define label_fdgrmoyr 51879 "051879", add 
label define label_fdgrmoyr 51880 "051880", add 
label define label_fdgrmoyr 51881 "051881", add 
label define label_fdgrmoyr 51882 "051882", add 
label define label_fdgrmoyr 51883 "051883", add 
label define label_fdgrmoyr 51884 "051884", add 
label define label_fdgrmoyr 51885 "051885", add 
label define label_fdgrmoyr 51886 "051886", add 
label define label_fdgrmoyr 51887 "051887", add 
label define label_fdgrmoyr 51889 "051889", add 
label define label_fdgrmoyr 51890 "051890", add 
label define label_fdgrmoyr 51891 "051891", add 
label define label_fdgrmoyr 51892 "051892", add 
label define label_fdgrmoyr 51893 "051893", add 
label define label_fdgrmoyr 51895 "051895", add 
label define label_fdgrmoyr 51896 "051896", add 
label define label_fdgrmoyr 51897 "051897", add 
label define label_fdgrmoyr 51898 "051898", add 
label define label_fdgrmoyr 51900 "051900", add 
label define label_fdgrmoyr 51901 "051901", add 
label define label_fdgrmoyr 51902 "051902", add 
label define label_fdgrmoyr 51903 "051903", add 
label define label_fdgrmoyr 51904 "051904", add 
label define label_fdgrmoyr 51905 "051905", add 
label define label_fdgrmoyr 51906 "051906", add 
label define label_fdgrmoyr 51908 "051908", add 
label define label_fdgrmoyr 51909 "051909", add 
label define label_fdgrmoyr 51910 "051910", add 
label define label_fdgrmoyr 51911 "051911", add 
label define label_fdgrmoyr 51912 "051912", add 
label define label_fdgrmoyr 51913 "051913", add 
label define label_fdgrmoyr 51914 "051914", add 
label define label_fdgrmoyr 51915 "051915", add 
label define label_fdgrmoyr 51916 "051916", add 
label define label_fdgrmoyr 51917 "051917", add 
label define label_fdgrmoyr 51918 "051918", add 
label define label_fdgrmoyr 51919 "051919", add 
label define label_fdgrmoyr 51920 "051920", add 
label define label_fdgrmoyr 51921 "051921", add 
label define label_fdgrmoyr 51923 "051923", add 
label define label_fdgrmoyr 51924 "051924", add 
label define label_fdgrmoyr 51925 "051925", add 
label define label_fdgrmoyr 51926 "051926", add 
label define label_fdgrmoyr 51927 "051927", add 
label define label_fdgrmoyr 51928 "051928", add 
label define label_fdgrmoyr 51929 "051929", add 
label define label_fdgrmoyr 51930 "051930", add 
label define label_fdgrmoyr 51931 "051931", add 
label define label_fdgrmoyr 51932 "051932", add 
label define label_fdgrmoyr 51933 "051933", add 
label define label_fdgrmoyr 51934 "051934", add 
label define label_fdgrmoyr 51935 "051935", add 
label define label_fdgrmoyr 51936 "051936", add 
label define label_fdgrmoyr 51937 "051937", add 
label define label_fdgrmoyr 51939 "051939", add 
label define label_fdgrmoyr 51940 "051940", add 
label define label_fdgrmoyr 51941 "051941", add 
label define label_fdgrmoyr 51942 "051942", add 
label define label_fdgrmoyr 51944 "051944", add 
label define label_fdgrmoyr 51945 "051945", add 
label define label_fdgrmoyr 51946 "051946", add 
label define label_fdgrmoyr 51947 "051947", add 
label define label_fdgrmoyr 51948 "051948", add 
label define label_fdgrmoyr 51949 "051949", add 
label define label_fdgrmoyr 51950 "051950", add 
label define label_fdgrmoyr 51951 "051951", add 
label define label_fdgrmoyr 51952 "051952", add 
label define label_fdgrmoyr 51953 "051953", add 
label define label_fdgrmoyr 51954 "051954", add 
label define label_fdgrmoyr 51955 "051955", add 
label define label_fdgrmoyr 51956 "051956", add 
label define label_fdgrmoyr 51957 "051957", add 
label define label_fdgrmoyr 51958 "051958", add 
label define label_fdgrmoyr 51959 "051959", add 
label define label_fdgrmoyr 51960 "051960", add 
label define label_fdgrmoyr 51961 "051961", add 
label define label_fdgrmoyr 51962 "051962", add 
label define label_fdgrmoyr 51963 "051963", add 
label define label_fdgrmoyr 51964 "051964", add 
label define label_fdgrmoyr 51965 "051965", add 
label define label_fdgrmoyr 51966 "051966", add 
label define label_fdgrmoyr 51967 "051967", add 
label define label_fdgrmoyr 51968 "051968", add 
label define label_fdgrmoyr 51969 "051969", add 
label define label_fdgrmoyr 51970 "051970", add 
label define label_fdgrmoyr 51971 "051971", add 
label define label_fdgrmoyr 51972 "051972", add 
label define label_fdgrmoyr 51973 "051973", add 
label define label_fdgrmoyr 51974 "051974", add 
label define label_fdgrmoyr 51975 "051975", add 
label define label_fdgrmoyr 51976 "051976", add 
label define label_fdgrmoyr 51977 "051977", add 
label define label_fdgrmoyr 51978 "051978", add 
label define label_fdgrmoyr 51979 "051979", add 
label define label_fdgrmoyr 51980 "051980", add 
label define label_fdgrmoyr 51981 "051981", add 
label define label_fdgrmoyr 51982 "051982", add 
label define label_fdgrmoyr 51983 "051983", add 
label define label_fdgrmoyr 51984 "051984", add 
label define label_fdgrmoyr 61758 "061758", add 
label define label_fdgrmoyr 61769 "061769", add 
label define label_fdgrmoyr 61815 "061815", add 
label define label_fdgrmoyr 61826 "061826", add 
label define label_fdgrmoyr 61830 "061830", add 
label define label_fdgrmoyr 61831 "061831", add 
label define label_fdgrmoyr 61832 "061832", add 
label define label_fdgrmoyr 61836 "061836", add 
label define label_fdgrmoyr 61838 "061838", add 
label define label_fdgrmoyr 61840 "061840", add 
label define label_fdgrmoyr 61843 "061843", add 
label define label_fdgrmoyr 61845 "061845", add 
label define label_fdgrmoyr 61847 "061847", add 
label define label_fdgrmoyr 61849 "061849", add 
label define label_fdgrmoyr 61851 "061851", add 
label define label_fdgrmoyr 61852 "061852", add 
label define label_fdgrmoyr 61854 "061854", add 
label define label_fdgrmoyr 61855 "061855", add 
label define label_fdgrmoyr 61856 "061856", add 
label define label_fdgrmoyr 61857 "061857", add 
label define label_fdgrmoyr 61858 "061858", add 
label define label_fdgrmoyr 61859 "061859", add 
label define label_fdgrmoyr 61860 "061860", add 
label define label_fdgrmoyr 61861 "061861", add 
label define label_fdgrmoyr 61862 "061862", add 
label define label_fdgrmoyr 61863 "061863", add 
label define label_fdgrmoyr 61864 "061864", add 
label define label_fdgrmoyr 61865 "061865", add 
label define label_fdgrmoyr 61866 "061866", add 
label define label_fdgrmoyr 61867 "061867", add 
label define label_fdgrmoyr 61868 "061868", add 
label define label_fdgrmoyr 61869 "061869", add 
label define label_fdgrmoyr 61870 "061870", add 
label define label_fdgrmoyr 61871 "061871", add 
label define label_fdgrmoyr 61872 "061872", add 
label define label_fdgrmoyr 61873 "061873", add 
label define label_fdgrmoyr 61874 "061874", add 
label define label_fdgrmoyr 61875 "061875", add 
label define label_fdgrmoyr 61876 "061876", add 
label define label_fdgrmoyr 61877 "061877", add 
label define label_fdgrmoyr 61878 "061878", add 
label define label_fdgrmoyr 61879 "061879", add 
label define label_fdgrmoyr 61880 "061880", add 
label define label_fdgrmoyr 61881 "061881", add 
label define label_fdgrmoyr 61882 "061882", add 
label define label_fdgrmoyr 61883 "061883", add 
label define label_fdgrmoyr 61884 "061884", add 
label define label_fdgrmoyr 61885 "061885", add 
label define label_fdgrmoyr 61886 "061886", add 
label define label_fdgrmoyr 61887 "061887", add 
label define label_fdgrmoyr 61888 "061888", add 
label define label_fdgrmoyr 61889 "061889", add 
label define label_fdgrmoyr 61890 "061890", add 
label define label_fdgrmoyr 61891 "061891", add 
label define label_fdgrmoyr 61892 "061892", add 
label define label_fdgrmoyr 61893 "061893", add 
label define label_fdgrmoyr 61894 "061894", add 
label define label_fdgrmoyr 61895 "061895", add 
label define label_fdgrmoyr 61896 "061896", add 
label define label_fdgrmoyr 61897 "061897", add 
label define label_fdgrmoyr 61898 "061898", add 
label define label_fdgrmoyr 61899 "061899", add 
label define label_fdgrmoyr 61900 "061900", add 
label define label_fdgrmoyr 61901 "061901", add 
label define label_fdgrmoyr 61902 "061902", add 
label define label_fdgrmoyr 61903 "061903", add 
label define label_fdgrmoyr 61904 "061904", add 
label define label_fdgrmoyr 61905 "061905", add 
label define label_fdgrmoyr 61906 "061906", add 
label define label_fdgrmoyr 61907 "061907", add 
label define label_fdgrmoyr 61908 "061908", add 
label define label_fdgrmoyr 61909 "061909", add 
label define label_fdgrmoyr 61910 "061910", add 
label define label_fdgrmoyr 61911 "061911", add 
label define label_fdgrmoyr 61912 "061912", add 
label define label_fdgrmoyr 61913 "061913", add 
label define label_fdgrmoyr 61914 "061914", add 
label define label_fdgrmoyr 61915 "061915", add 
label define label_fdgrmoyr 61916 "061916", add 
label define label_fdgrmoyr 61917 "061917", add 
label define label_fdgrmoyr 61918 "061918", add 
label define label_fdgrmoyr 61919 "061919", add 
label define label_fdgrmoyr 61920 "061920", add 
label define label_fdgrmoyr 61921 "061921", add 
label define label_fdgrmoyr 61922 "061922", add 
label define label_fdgrmoyr 61923 "061923", add 
label define label_fdgrmoyr 61924 "061924", add 
label define label_fdgrmoyr 61925 "061925", add 
label define label_fdgrmoyr 61926 "061926", add 
label define label_fdgrmoyr 61927 "061927", add 
label define label_fdgrmoyr 61928 "061928", add 
label define label_fdgrmoyr 61929 "061929", add 
label define label_fdgrmoyr 61930 "061930", add 
label define label_fdgrmoyr 61931 "061931", add 
label define label_fdgrmoyr 61932 "061932", add 
label define label_fdgrmoyr 61933 "061933", add 
label define label_fdgrmoyr 61934 "061934", add 
label define label_fdgrmoyr 61935 "061935", add 
label define label_fdgrmoyr 61936 "061936", add 
label define label_fdgrmoyr 61937 "061937", add 
label define label_fdgrmoyr 61938 "061938", add 
label define label_fdgrmoyr 61939 "061939", add 
label define label_fdgrmoyr 61940 "061940", add 
label define label_fdgrmoyr 61941 "061941", add 
label define label_fdgrmoyr 61942 "061942", add 
label define label_fdgrmoyr 61943 "061943", add 
label define label_fdgrmoyr 61944 "061944", add 
label define label_fdgrmoyr 61945 "061945", add 
label define label_fdgrmoyr 61946 "061946", add 
label define label_fdgrmoyr 61947 "061947", add 
label define label_fdgrmoyr 61948 "061948", add 
label define label_fdgrmoyr 61949 "061949", add 
label define label_fdgrmoyr 61950 "061950", add 
label define label_fdgrmoyr 61951 "061951", add 
label define label_fdgrmoyr 61952 "061952", add 
label define label_fdgrmoyr 61953 "061953", add 
label define label_fdgrmoyr 61954 "061954", add 
label define label_fdgrmoyr 61955 "061955", add 
label define label_fdgrmoyr 61956 "061956", add 
label define label_fdgrmoyr 61957 "061957", add 
label define label_fdgrmoyr 61958 "061958", add 
label define label_fdgrmoyr 61959 "061959", add 
label define label_fdgrmoyr 61960 "061960", add 
label define label_fdgrmoyr 61961 "061961", add 
label define label_fdgrmoyr 61962 "061962", add 
label define label_fdgrmoyr 61963 "061963", add 
label define label_fdgrmoyr 61964 "061964", add 
label define label_fdgrmoyr 61965 "061965", add 
label define label_fdgrmoyr 61966 "061966", add 
label define label_fdgrmoyr 61967 "061967", add 
label define label_fdgrmoyr 61968 "061968", add 
label define label_fdgrmoyr 61969 "061969", add 
label define label_fdgrmoyr 61970 "061970", add 
label define label_fdgrmoyr 61971 "061971", add 
label define label_fdgrmoyr 61972 "061972", add 
label define label_fdgrmoyr 61973 "061973", add 
label define label_fdgrmoyr 61974 "061974", add 
label define label_fdgrmoyr 61975 "061975", add 
label define label_fdgrmoyr 61976 "061976", add 
label define label_fdgrmoyr 61977 "061977", add 
label define label_fdgrmoyr 61978 "061978", add 
label define label_fdgrmoyr 61979 "061979", add 
label define label_fdgrmoyr 61980 "061980", add 
label define label_fdgrmoyr 61981 "061981", add 
label define label_fdgrmoyr 61982 "061982", add 
label define label_fdgrmoyr 61983 "061983", add 
label define label_fdgrmoyr 61984 "061984", add 
label define label_fdgrmoyr 61985 "061985", add 
label define label_fdgrmoyr 71836 "071836", add 
label define label_fdgrmoyr 71838 "071838", add 
label define label_fdgrmoyr 71844 "071844", add 
label define label_fdgrmoyr 71850 "071850", add 
label define label_fdgrmoyr 71851 "071851", add 
label define label_fdgrmoyr 71853 "071853", add 
label define label_fdgrmoyr 71856 "071856", add 
label define label_fdgrmoyr 71858 "071858", add 
label define label_fdgrmoyr 71860 "071860", add 
label define label_fdgrmoyr 71866 "071866", add 
label define label_fdgrmoyr 71870 "071870", add 
label define label_fdgrmoyr 71871 "071871", add 
label define label_fdgrmoyr 71873 "071873", add 
label define label_fdgrmoyr 71878 "071878", add 
label define label_fdgrmoyr 71883 "071883", add 
label define label_fdgrmoyr 71890 "071890", add 
label define label_fdgrmoyr 71894 "071894", add 
label define label_fdgrmoyr 71900 "071900", add 
label define label_fdgrmoyr 71913 "071913", add 
label define label_fdgrmoyr 71914 "071914", add 
label define label_fdgrmoyr 71920 "071920", add 
label define label_fdgrmoyr 71922 "071922", add 
label define label_fdgrmoyr 71930 "071930", add 
label define label_fdgrmoyr 71948 "071948", add 
label define label_fdgrmoyr 71956 "071956", add 
label define label_fdgrmoyr 71959 "071959", add 
label define label_fdgrmoyr 71960 "071960", add 
label define label_fdgrmoyr 71962 "071962", add 
label define label_fdgrmoyr 71966 "071966", add 
label define label_fdgrmoyr 71967 "071967", add 
label define label_fdgrmoyr 71970 "071970", add 
label define label_fdgrmoyr 71971 "071971", add 
label define label_fdgrmoyr 71972 "071972", add 
label define label_fdgrmoyr 71973 "071973", add 
label define label_fdgrmoyr 71975 "071975", add 
label define label_fdgrmoyr 71976 "071976", add 
label define label_fdgrmoyr 71979 "071979", add 
label define label_fdgrmoyr 71980 "071980", add 
label define label_fdgrmoyr 71981 "071981", add 
label define label_fdgrmoyr 71982 "071982", add 
label define label_fdgrmoyr 71983 "071983", add 
label define label_fdgrmoyr 71984 "071984", add 
label define label_fdgrmoyr 71985 "071985", add 
label define label_fdgrmoyr 81804 "081804", add 
label define label_fdgrmoyr 81822 "081822", add 
label define label_fdgrmoyr 81830 "081830", add 
label define label_fdgrmoyr 81838 "081838", add 
label define label_fdgrmoyr 81841 "081841", add 
label define label_fdgrmoyr 81853 "081853", add 
label define label_fdgrmoyr 81869 "081869", add 
label define label_fdgrmoyr 81888 "081888", add 
label define label_fdgrmoyr 81907 "081907", add 
label define label_fdgrmoyr 81919 "081919", add 
label define label_fdgrmoyr 81925 "081925", add 
label define label_fdgrmoyr 81926 "081926", add 
label define label_fdgrmoyr 81931 "081931", add 
label define label_fdgrmoyr 81937 "081937", add 
label define label_fdgrmoyr 81947 "081947", add 
label define label_fdgrmoyr 81948 "081948", add 
label define label_fdgrmoyr 81955 "081955", add 
label define label_fdgrmoyr 81956 "081956", add 
label define label_fdgrmoyr 81960 "081960", add 
label define label_fdgrmoyr 81963 "081963", add 
label define label_fdgrmoyr 81964 "081964", add 
label define label_fdgrmoyr 81965 "081965", add 
label define label_fdgrmoyr 81966 "081966", add 
label define label_fdgrmoyr 81967 "081967", add 
label define label_fdgrmoyr 81968 "081968", add 
label define label_fdgrmoyr 81969 "081969", add 
label define label_fdgrmoyr 81970 "081970", add 
label define label_fdgrmoyr 81971 "081971", add 
label define label_fdgrmoyr 81972 "081972", add 
label define label_fdgrmoyr 81973 "081973", add 
label define label_fdgrmoyr 81974 "081974", add 
label define label_fdgrmoyr 81975 "081975", add 
label define label_fdgrmoyr 81976 "081976", add 
label define label_fdgrmoyr 81977 "081977", add 
label define label_fdgrmoyr 81982 "081982", add 
label define label_fdgrmoyr 91806 "091806", add 
label define label_fdgrmoyr 91821 "091821", add 
label define label_fdgrmoyr 91826 "091826", add 
label define label_fdgrmoyr 91833 "091833", add 
label define label_fdgrmoyr 91836 "091836", add 
label define label_fdgrmoyr 91852 "091852", add 
label define label_fdgrmoyr 91872 "091872", add 
label define label_fdgrmoyr 91891 "091891", add 
label define label_fdgrmoyr 91895 "091895", add 
label define label_fdgrmoyr 91906 "091906", add 
label define label_fdgrmoyr 91909 "091909", add 
label define label_fdgrmoyr 91922 "091922", add 
label define label_fdgrmoyr 91924 "091924", add 
label define label_fdgrmoyr 91926 "091926", add 
label define label_fdgrmoyr 91927 "091927", add 
label define label_fdgrmoyr 91928 "091928", add 
label define label_fdgrmoyr 91929 "091929", add 
label define label_fdgrmoyr 91932 "091932", add 
label define label_fdgrmoyr 91933 "091933", add 
label define label_fdgrmoyr 91935 "091935", add 
label define label_fdgrmoyr 91936 "091936", add 
label define label_fdgrmoyr 91938 "091938", add 
label define label_fdgrmoyr 91944 "091944", add 
label define label_fdgrmoyr 91947 "091947", add 
label define label_fdgrmoyr 91949 "091949", add 
label define label_fdgrmoyr 91954 "091954", add 
label define label_fdgrmoyr 91965 "091965", add 
label define label_fdgrmoyr 91966 "091966", add 
label define label_fdgrmoyr 91968 "091968", add 
label define label_fdgrmoyr 91969 "091969", add 
label define label_fdgrmoyr 91970 "091970", add 
label define label_fdgrmoyr 91971 "091971", add 
label define label_fdgrmoyr 91972 "091972", add 
label define label_fdgrmoyr 91973 "091973", add 
label define label_fdgrmoyr 91974 "091974", add 
label define label_fdgrmoyr 91975 "091975", add 
label define label_fdgrmoyr 91976 "091976", add 
label define label_fdgrmoyr 91977 "091977", add 
label define label_fdgrmoyr 91978 "091978", add 
label define label_fdgrmoyr 91979 "091979", add 
label define label_fdgrmoyr 91980 "091980", add 
label define label_fdgrmoyr 91981 "091981", add 
label define label_fdgrmoyr 91983 "091983", add 
label define label_fdgrmoyr 101774 "101774", add 
label define label_fdgrmoyr 101806 "101806", add 
label define label_fdgrmoyr 101927 "101927", add 
label define label_fdgrmoyr 101947 "101947", add 
label define label_fdgrmoyr 101950 "101950", add 
label define label_fdgrmoyr 101963 "101963", add 
label define label_fdgrmoyr 101968 "101968", add 
label define label_fdgrmoyr 101970 "101970", add 
label define label_fdgrmoyr 101973 "101973", add 
label define label_fdgrmoyr 101974 "101974", add 
label define label_fdgrmoyr 101976 "101976", add 
label define label_fdgrmoyr 101981 "101981", add 
label define label_fdgrmoyr 101983 "101983", add 
label define label_fdgrmoyr 111826 "111826", add 
label define label_fdgrmoyr 111846 "111846", add 
label define label_fdgrmoyr 111873 "111873", add 
label define label_fdgrmoyr 111941 "111941", add 
label define label_fdgrmoyr 111948 "111948", add 
label define label_fdgrmoyr 111954 "111954", add 
label define label_fdgrmoyr 111966 "111966", add 
label define label_fdgrmoyr 111969 "111969", add 
label define label_fdgrmoyr 111974 "111974", add 
label define label_fdgrmoyr 111977 "111977", add 
label define label_fdgrmoyr 121824 "121824", add 
label define label_fdgrmoyr 121851 "121851", add 
label define label_fdgrmoyr 121861 "121861", add 
label define label_fdgrmoyr 121892 "121892", add 
label define label_fdgrmoyr 121896 "121896", add 
label define label_fdgrmoyr 121906 "121906", add 
label define label_fdgrmoyr 121926 "121926", add 
label define label_fdgrmoyr 121933 "121933", add 
label define label_fdgrmoyr 121961 "121961", add 
label define label_fdgrmoyr 121963 "121963", add 
label define label_fdgrmoyr 121964 "121964", add 
label define label_fdgrmoyr 121965 "121965", add 
label define label_fdgrmoyr 121968 "121968", add 
label define label_fdgrmoyr 121969 "121969", add 
label define label_fdgrmoyr 121970 "121970", add 
label define label_fdgrmoyr 121971 "121971", add 
label define label_fdgrmoyr 121972 "121972", add 
label define label_fdgrmoyr 121973 "121973", add 
label define label_fdgrmoyr 121974 "121974", add 
label define label_fdgrmoyr 121975 "121975", add 
label define label_fdgrmoyr 121977 "121977", add 
label define label_fdgrmoyr 121979 "121979", add 
label define label_fdgrmoyr 121980 "121980", add 
label define label_fdgrmoyr 611961 "611961", add 
label values fdgrmoyr label_fdgrmoyr
label define label_iclevel 1 "4 or more years (Baccalaureate or higher degree)" 
label define label_iclevel 2 "At least 2 but less than 4 years below the Baccalaureate", add 
label define label_iclevel 3 "Less than 2 years (below Associates Degree)", add 
label values iclevel label_iclevel
label define label_hloffer 0 "Other" 
label define label_hloffer 1 "Postsecondary award, certificate or diploma of less than one academic year", add 
label define label_hloffer 2 "Postsecondary award, certificate or diploma of at least one but less than two academic years", add 
label define label_hloffer 3 "Associates degree", add 
label define label_hloffer 4 "Postsecondary award, certificate or diploma of at least two but less than four academic years", add 
label define label_hloffer 5 "Bachelors degree", add 
label define label_hloffer 6 "Postbaccalaureate certificate", add 
label define label_hloffer 7 "Masters degree", add 
label define label_hloffer 8 "Post-Masters certificate", add 
label define label_hloffer 9 "Doctors degree", add 
label values hloffer label_hloffer
tab sector
tab stabbr
tab respstat
tab peo1istr
tab peo2istr
tab peo3istr
tab peo4istr
tab peo5istr
tab peo6istr
tab multtyp1
tab multtyp2
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
tab calsys1
tab calsys2
tab calsys3
tab calsys4
tab calsys5
tab calsys6
tab crsloc1
tab crsloc2
tab crsloc3
tab crsloc4
tab crsloc5
tab crsloc6
tab facloc1
tab facloc2
tab facloc3
tab facloc4
tab facloc5
tab facloc6
tab facloc7
tab facloc8
tab facloc9
tab facloc10
tab facloc11
tab facloc12
tab mili
tab mil1insl
tab mil2insl
tab admreq1
tab admreq2
tab admreq3
tab admreq4
tab admreq5
tab admreq6
tab admreq7
tab admreq8
tab admreq9
tab admreq10
tab admreq11
tab avgperc
tab uwwou
tab mode1
tab mode2
tab mode3
tab mode4
tab mode5
tab mode6
tab mode7
tab mode8
tab mode9
tab mode10
tab mode11
tab mode12
tab mode13
tab mode14
tab stusrv1
tab stusrv2
tab stusrv3
tab stusrv4
tab stusrv5
tab stusrv6
tab stusrv7
tab stusrv8
tab stusrv9
tab libfac
tab aslib1
tab aslib2
tab aslib3
tab ftstu
tab apfee
tab tfdu
tab tfdg
tab noftug
tab tuition3
tab tuition6
tab profna
tab room
tab board
tab fips
tab obereg
tab type
tab control
tab tfdi
tab chgper1
tab chgper2
tab chgper3
tab chgper4
tab chgper5
tab rstatus
tab cnty
tab estyr
tab system
tab sequen
tab status
tab affil
tab calsys
tab procc
tab pr2yr
tab prlib
tab prtea
tab prprof
tab oereg
tab race
tab sex
tab lgrnt
tab cncesc
tab excntl
tab citysi
tab admreq
tab estmo
tab fwrkmoyr
tab fdgrmoyr
tab iclevel
tab hloffer
summarize congdist
summarize fice
summarize applfeeu
summarize applfeeg
summarize ffind
summarize ffamt
summarize ffper1
summarize ffper2
summarize ffper3
summarize ffper4
summarize ffper5
summarize ffper6
summarize ffmin
summarize ffmax
summarize phind
summarize phamt
summarize phper1
summarize phper2
summarize phper3
summarize phper4
summarize phper5
summarize tuition1
summarize tuition2
summarize tuition4
summarize tuition5
summarize prof1
summarize prof2
summarize prof3
summarize prof4
summarize prof5
summarize prof6
summarize prof7
summarize prof8
summarize prof9
summarize prof10
summarize prof11
summarize roomamt
summarize roomcap
summarize boardamt
summarize mealswk
summarize avgamt1
summarize avgamt2
summarize avgamt3
summarize avgamt4
summarize tuition7
summarize tuition8
summarize tuition9
summarize unitidx
summarize pbalph
summarize prtfu
summarize pbtfui
summarize pbtfuo
summarize prtfg
summarize pbtfgi
summarize pbtfgo
summarize stcnty
summarize congr
summarize period
save dct_ic1986_a

