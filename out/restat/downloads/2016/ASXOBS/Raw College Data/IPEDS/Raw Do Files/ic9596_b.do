* Created: 6/13/2004 4:43:06 AM
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
insheet using "../Raw Data/ic9596_b_data_stata.csv", comma clear
label data "dct_ic9596_b"
label variable unitid "unitid"
label variable yrscol "Years of college-level work required"
label variable mode1 "Credit, work in a program-related setting with pay"
label variable mode2 "Credit, work in a program-related setting without"
label variable mode3 "Credit, home study (general)"
label variable mode4 "Credit, home study, correspondence"
label variable mode5 "Credit, home study, radio and TV"
label variable mode6 "Credit, home study, newspaper"
label variable mode7 "Credit, none of the above"
label variable mode8 "Noncredit, work in a program-related setting with"
label variable mode9 "Noncredit, work in a program-related setting witho"
label variable mode10 "Noncredit, home study (general)"
label variable mode11 "Noncredit, home study, correspondence"
label variable mode12 "Noncredit, home study, radio and TV"
label variable mode13 "Noncredit, home study, newspaper"
label variable mode14 "Noncredit, none of the above"
label variable stusrv1 "Remedial services"
label variable stusrv2 "Academic/career counseling service"
label variable stusrv3 "Employment services for current students"
label variable stusrv4 "Placement services for program completers"
label variable stusrv5 "Assistance for the visually impaired"
label variable stusrv6 "Assistance for the hearing impaired"
label variable stusrv7 "Access for the mobility impaired"
label variable stusrv8 "On-campus day care for children of students"
label variable stusrv9 "None of the above"
label variable libfac "Library facilities at institution"
label variable libshar1 "If LIBFAC = 2, UNITID of 1st"
label variable libshar2 "If LIBFAC = 2, UNITID of 2nd"
label variable libshar3 "If LIBFAC = 2, UNITID of 3rd"
label variable ftstu "Full-time students are enrolled"
label variable apfee "Application fee is required"
label variable applfeeu "Undergraduate application fee"
label variable applfeeg "Graduate application fee"
label variable applfeep "First-Professional application fee"
label variable noftug "No full-time undergraduate students enrolled (not"
label variable chgper1 "By credit/contact hour"
label variable chgper2 "By term"
label variable chgper3 "By year"
label variable chgper4 "By program"
label variable chgper5 "Other Basis for charging"
label variable tuition1 "Tuition and fees, full-time undergraduate, in-district"
label variable tuition2 "Tuition and fees, full-time undergraduate, in-state"
label variable tuition3 "Tuition and fees, full-time undergraduate, out-of-state"
label variable tuition4 "No full-time undergraduate students"
label variable tpugcred "Typical number of credit hours for full-time undergraduate students"
label variable tpugcont "Typical number of contact hours for full-time undergraduate students"
label variable tuition5 "Tuition and fees, full-time graduate, in-district"
label variable tuition6 "Tuition and fees, full-time graduate, in-state"
label variable tuition7 "Tuition and fees, full-time graduate, out-of-state"
label variable tuition8 "No full-time graduate students"
label variable tpgdcred "Typical number credit hours full-time first professional students"
label variable isprof1 "Tuition and fees full-time  Chiropractic in-state"
label variable osprof1 "Tuition and fees full-time  Chiropractic out-of-state"
label variable isprof2 "Tuition and fees full-time  Dentistry in-state"
label variable osprof2 "Tuition and fees full-time  Dentistry out-of-state"
label variable isprof3 "Tuition and fees full-time  Medicine in-state"
label variable osprof3 "Tuition and fees full-time  Medicine out-of-state"
label variable isprof4 "Tuition and fees full-time  Optometry in-state"
label variable osprof4 "Tuition and fees full-time  Optometry out-of-state"
label variable isprof5 "Tuition and fees full-time  Osteopathic Medicine in-state"
label variable osprof5 "Tuition and fees full-time  Osteopathic Medicine out-of-state"
label variable isprof6 "Tuition and fees full-time  Pharmacy in-state"
label variable osprof6 "Tuition and fees full-time  Pharmacy out-of-state"
label variable isprof7 "Tuition and fees full-time  Podiatry in-state"
label variable osprof7 "Tuition and fees full-time  Podiatry out-of-state"
label variable isprof8 "Tuition and fees full-time  Veterinary Medicine in-state"
label variable osprof8 "Tuition and fees full-time  Veterinary Medicine out-of-state"
label variable isprof9 "Tuition and fees full-time  Law in-state"
label variable osprof9 "Tuition and fees full-time  Law out-of-state"
label variable isprof10 "Tuition and fees full-time  Theology in-state"
label variable osprof10 "Tuition and fees full-time  Theology out-of-state"
label variable isprof11 "Tuition and fees full-time  Other first-professional, in-state"
label variable osprof11 "Tuition and fees full-time  Other first-professional, out-of-state"
label variable profna "No full-time first-professional students"
label variable tpfpcred "Typical number credit hours FTFY first-professionals"
label variable room "Institution provides dormitory facilities"
label variable roomcap "Total dormitory capacity during academic year"
label variable board "Institution provides board or meal plans"
label variable mealswk "Number of meals per week in board charge"
label variable mealsvry "Number meals/week for BOARDAMT OR RMBRDAMT vary"
label variable roomamt "Typical room charge for academic year"
label variable boardamt "Typical board charge for academic year"
label variable roombord "Combined charge for room and board"
label variable rmbrdamt "Typical combined room and board charge"
label variable prgmoffr "Number of programs offered"
label variable pg300 "Offers programs at least 300 contact hours"
label variable cipcode1 "1st CIP code"
label variable ciptuit1 "1st Tuition and fees"
label variable cipsupp1 "1st Cost of books and supplies"
label variable ciplgth1 "1st Total length of program in contact hours"
label variable cipenrl1 "1st Current or most recent enrollment"
label variable cipcomp1 "1st Total number of completers"
label variable cipcode2 "2nd CIP code"
label variable ciptuit2 "2nd Tuition and fees (in-State charges)"
label variable cipsupp2 "2nd Cost of books and supplies"
label variable ciplgth2 "2nd Total length of program in contact hours"
label variable cipenrl2 "2nd Current or most recent enrollment"
label variable cipcomp2 "2nd Total number of completers"
label variable cipcode3 "3rd CIP code"
label variable ciptuit3 "3rd Tuition and fees (in-State charges)"
label variable cipsupp3 "3rd Cost of books and supplies"
label variable ciplgth3 "3rd Total length of program in contact hours"
label variable cipenrl3 "3rd Current or most recent enrollment"
label variable cipcomp3 "3rd Total number of completers"
label variable cipcode4 "4th CIP code"
label variable ciptuit4 "4th Tuition and fees (in-State charges)"
label variable cipsupp4 "4th Cost of books and supplies"
label variable ciplgth4 "4th Total length of program in contact hours"
label variable cipenrl4 "4th Current or most recent enrollment"
label variable cipcomp4 "4th Total number of completers"
label variable cipcode5 "5th CIP code"
label variable ciptuit5 "5th Tuition and fees (in-State charges)"
label variable cipsupp5 "5th Cost of books and supplies"
label variable ciplgth5 "5th Total length of program in contact hours"
label variable cipenrl5 "5th Current or most recent enrollment"
label variable cipcomp5 "5th Total number of completers"
label variable cipcode6 "6th CIP code"
label variable ciptuit6 "6th Tuition and fees (in-State charges)"
label variable cipsupp6 "6th Cost of books and supplies"
label variable ciplgth6 "6th Total length of program in contact hours"
label variable cipenrl6 "6th Current or most recent enrollment"
label variable cipcomp6 "6th Total number of completers"
label variable enrolmnt "Corrected fall enrollment count for Fall 1994"
label variable genenrl "Enrollment reported on the Fall 1994 enrollment file"
label variable month "Start date of the 12-month year"
label variable tostucu "12-month undergraduate unduplicated headcount"
label variable tostufrs "12-month full-time, first-time undergraduate unduplicated headcount"
label variable tostutrn "12-month full-time transfer undergraduate unduplicated headcount"
label variable tostucg "12-month graduate unduplicated headcount"
label variable tostucp "12-month first-professional unduplicated headcount"
label variable finaid1 "SFA"
label variable finaid2 "SFA"
label variable finaid3 "SFA"
label variable finaid4 "SFA"
label variable finaid5 "SFA"
label variable finaid6 "SFA"
label variable finaid7 "SFA"
label variable finaid8 "SFA"
label variable finaid9 "SFA"
label variable jtpa "Job Training Partnership Act (JTPA)"
label variable rotc "Reserve Officers Training Corps (ROTC)"
label variable rotc1 "Army"
label variable rotc2 "Navy"
label variable rotc3 "Air Force"
label variable ftslt15 "Number of full-time staff"
label variable facpt "ALL instructional faculty are part-time"
label variable facml "ALL instructional faculty are military personnel"
label variable facrl "ALL instructional faculty contribute services"
label variable facmd "ALL instructional faculty teach medicine"
label variable pctpost "Percentage primarily in postsecondary programs"
label variable ein "Employer Identification Number"
label variable chfnm "Name of Chief Administrator"
label variable chftitle "Title of Chief Administrator"
label variable licensed "Licensed by state or local"
label variable imp1 "imp1"
label variable imp2 "imp2"
label variable imp3 "imp3"
label variable imp4 "imp4"
label variable imp5 "imp5"
label variable imp6 "imp6"
label variable imp7 "imp7"
label variable imp8 "imp8"
label variable imp9 "imp9"
label variable imp10 "imp10"
label variable imp11 "imp11"
label variable imp12 "imp12"
label variable imp13 "imp13"
label variable imp14 "imp14"
label variable imp15 "imp15"
label variable imp16 "imp16"
label variable imp17 "imp17"
label variable imp18 "imp18"
label variable imp19 "imp19"
label variable imp20 "imp20"
label variable imp21 "imp21"
label variable imp22 "imp22"
label variable imp23 "imp23"
label variable imp24 "imp24"
label variable imp25 "imp25"
label variable imp26 "imp26"
label variable imp27 "imp27"
label variable imp28 "imp28"
label variable imp29 "imp29"
label variable imp30 "imp30"
label variable imp31 "imp31"
label variable imp32 "imp32"
label variable imp33 "imp33"
label variable imp34 "imp34"
label variable imp35 "imp35"
label variable imp36 "imp36"
label variable imp37 "imp37"
label variable imp38 "imp38"
label variable imp39 "imp39"
label variable imp40 "imp40"
label variable imp41 "imp41"
label variable imp42 "imp42"
label variable imp43 "imp43"
label variable imp44 "imp44"
label variable imp45 "imp45"
label variable imp46 "imp46"
label variable imp47 "imp47"
label variable imp48 "imp48"
label variable imp49 "imp49"
label variable imp50 "imp50"
label variable imp51 "imp51"
label variable imp52 "imp52"
label variable imp53 "imp53"
label variable imp54 "imp54"
label variable imp55 "imp55"
label variable imp56 "imp56"
label variable imp57 "imp57"
label variable imp58 "imp58"
label variable imp59 "imp59"
label variable imp60 "imp60"
label variable imp61 "imp61"
label variable imp62 "imp62"
label variable imp63 "imp63"
label variable imp64 "imp64"
label variable imp65 "imp65"
label variable imp66 "imp66"
label variable imp67 "imp67"
label variable imp68 "imp68"
label variable imp69 "imp69"
label variable imp70 "imp70"
label variable imp71 "imp71"
label variable imp72 "imp72"
label variable imp73 "imp73"
label variable imp74 "imp74"
label variable imp75 "imp75"
label variable imp76 "imp76"
label define label_yrscol -1 "No Response/Missing" 
label define label_yrscol 1 "One", add 
label define label_yrscol 2 "Two", add 
label define label_yrscol 3 "Three", add 
label define label_yrscol 4 "Four", add 
label define label_yrscol 5 "Five", add 
label define label_yrscol 6 "Six", add 
label define label_yrscol 8 "Eight", add 
label values yrscol label_yrscol
label define label_mode1 -1 "No Response/Missing" 
label define label_mode1 1 "Yes", add 
label values mode1 label_mode1
label define label_mode2 -1 "No Response/Missing" 
label define label_mode2 1 "Yes", add 
label values mode2 label_mode2
label define label_mode3 -1 "No Response/Missing" 
label define label_mode3 1 "Yes", add 
label values mode3 label_mode3
label define label_mode4 -1 "No Response/Missing" 
label define label_mode4 1 "Yes", add 
label values mode4 label_mode4
label define label_mode5 -1 "No Response/Missing" 
label define label_mode5 1 "Yes", add 
label values mode5 label_mode5
label define label_mode6 -1 "No Response/Missing" 
label define label_mode6 1 "Yes", add 
label values mode6 label_mode6
label define label_mode7 -1 "No Response/Missing" 
label define label_mode7 1 "Yes", add 
label values mode7 label_mode7
label define label_mode8 -1 "No Response/Missing" 
label define label_mode8 1 "Yes", add 
label values mode8 label_mode8
label define label_mode9 -1 "No Response/Missing" 
label define label_mode9 1 "Yes", add 
label values mode9 label_mode9
label define label_mode10 -1 "No Response/Missing" 
label define label_mode10 1 "Yes", add 
label values mode10 label_mode10
label define label_mode11 -1 "No Response/Missing" 
label define label_mode11 1 "Yes", add 
label values mode11 label_mode11
label define label_mode12 -1 "No Response/Missing" 
label define label_mode12 1 "Yes", add 
label values mode12 label_mode12
label define label_mode13 -1 "No Response/Missing" 
label define label_mode13 1 "Yes", add 
label values mode13 label_mode13
label define label_mode14 -1 "No Response/Missing" 
label define label_mode14 1 "Yes", add 
label values mode14 label_mode14
label define label_stusrv1 -1 "No Response/Missing" 
label define label_stusrv1 1 "Yes", add 
label values stusrv1 label_stusrv1
label define label_stusrv2 -1 "No Response/Missing" 
label define label_stusrv2 1 "Yes", add 
label values stusrv2 label_stusrv2
label define label_stusrv3 -1 "No Response/Missing" 
label define label_stusrv3 1 "Yes", add 
label values stusrv3 label_stusrv3
label define label_stusrv4 -1 "No Response/Missing" 
label define label_stusrv4 1 "Yes", add 
label values stusrv4 label_stusrv4
label define label_stusrv5 -1 "No Response/Missing" 
label define label_stusrv5 1 "Yes", add 
label values stusrv5 label_stusrv5
label define label_stusrv6 -1 "No Response/Missing" 
label define label_stusrv6 1 "Yes", add 
label values stusrv6 label_stusrv6
label define label_stusrv7 -1 "No Response/Missing" 
label define label_stusrv7 1 "Yes", add 
label values stusrv7 label_stusrv7
label define label_stusrv8 -1 "No Response/Missing" 
label define label_stusrv8 1 "Yes", add 
label values stusrv8 label_stusrv8
label define label_stusrv9 -1 "No Response/Missing" 
label define label_stusrv9 1 "Yes", add 
label values stusrv9 label_stusrv9
label define label_libfac -1 "No Response/Missing" 
label define label_libfac 1 "Have own library", add 
label define label_libfac 2 "Support shared library", add 
label define label_libfac 3 "Neither of the above", add 
label values libfac label_libfac
label define label_ftstu -1 "No Response/Missing" 
label define label_ftstu 1 "Yes", add 
label define label_ftstu 2 "No", add 
label values ftstu label_ftstu
label define label_apfee -1 "No Response/Missing" 
label define label_apfee 1 "Yes", add 
label define label_apfee 2 "No", add 
label values apfee label_apfee
label define label_chgper1 -1 "No Response/Missing" 
label define label_chgper1 1 "Yes", add 
label values chgper1 label_chgper1
label define label_chgper2 -1 "No Response/Missing" 
label define label_chgper2 1 "Yes", add 
label values chgper2 label_chgper2
label define label_chgper3 -1 "No Response/Missing" 
label define label_chgper3 1 "Yes", add 
label values chgper3 label_chgper3
label define label_chgper4 -1 "No Response/Missing" 
label define label_chgper4 1 "Yes", add 
label values chgper4 label_chgper4
label define label_chgper5 -1 "No Response/Missing" 
label define label_chgper5 1 "Yes", add 
label values chgper5 label_chgper5
label define label_tuition4 -1 "No Response/Missing" 
label define label_tuition4 1 "Yes", add 
label values tuition4 label_tuition4
label define label_tuition8 -1 "No Response/Missing" 
label define label_tuition8 1 "Yes", add 
label values tuition8 label_tuition8
label define label_profna -1 "No Response/Missing" 
label define label_profna 1 "Yes", add 
label values profna label_profna
label define label_room -1 "No Response/Missing" 
label define label_room 1 "Yes", add 
label define label_room 2 "No", add 
label values room label_room
label define label_board -1 "No Response/Missing" 
label define label_board 1 "Yes", add 
label define label_board 2 "No", add 
label values board label_board
label define label_mealsvry -1 "No Response/Missing" 
label define label_mealsvry 1 "Yes", add 
label values mealsvry label_mealsvry
label define label_roombord -1 "No Response/Missing" 
label define label_roombord 1 "Yes", add 
label values roombord label_roombord
label define label_pg300 -1 "No Response/Missing" 
label define label_pg300 1 "Yes", add 
label define label_pg300 2 "No", add 
label values pg300 label_pg300
label define label_cipcode1 10505 "01.0505 - Animal Trainer" 
label define label_cipcode1 10507 "01.0507 - Eques./Equine Stds., Horse Mgmt. & Trgn.", add 
label define label_cipcode1 10599 "01.0599 - Ag. Supplies and Related Svcs, Other", add 
label define label_cipcode1 10603 "01.0603 - Ornamental Horticulture Ops. and Mgmt.", add 
label define label_cipcode1 10699 "01.0699 - Horticulture Svcs. Ops. and Mgmt., Oth.", add 
label define label_cipcode1 19999 "01.9999 - Agricultural Business & Production, Oth.", add 
label define label_cipcode1 20101 "02.0101 - Agriculture/Agricultural Sciences, Gen.", add 
label define label_cipcode1 20299 "02.0299 - Animal Sciences, Other", add 
label define label_cipcode1 20301 "02.0301 - Food Sciences and Tech.", add 
label define label_cipcode1 20403 "02.0403 - Horticulture Science", add 
label define label_cipcode1 20501 "02.0501 - Soil Sciences", add 
label define label_cipcode1 29999 "02.9999 - Agriculture/Agricultural Sciences, Other", add 
label define label_cipcode1 30101 "03.0101 - Natural Resources Conservation, General", add 
label define label_cipcode1 30501 "03.0501 - Forestry, General", add 
label define label_cipcode1 30599 "03.0599 - Forestry and Related Sciences, Other", add 
label define label_cipcode1 40301 "04.0301 - City/Urban, Community & Reg. Planning", add 
label define label_cipcode1 49999 "04.9999 - Architecture and Related Programs, Other", add 
label define label_cipcode1 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode1 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode1 80299 "08.0299 - Bus. & Personal Ser. Market. Opns, Oth", add 
label define label_cipcode1 80301 "08.0301 - Entrepreneurship", add 
label define label_cipcode1 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode1 80601 "08.0601 - Food Products Retail and Wholesale Opns.", add 
label define label_cipcode1 80701 "08.0701 - Auctioneering", add 
label define label_cipcode1 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode1 80706 "08.0706 - General Selling Skills and Sales Opns.", add 
label define label_cipcode1 80709 "08.0709 - General Distribution Operations", add 
label define label_cipcode1 80901 "08.0901 - Hospitality & Rec. Marketing Opns, Gen", add 
label define label_cipcode1 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode1 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode1 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode1 81199 "08.1199 - Tourism & Travel Serv. Market. Opns,Oth", add 
label define label_cipcode1 89999 "08.9999 - Marketing Opns/Market. & Distrib.,Oth", add 
label define label_cipcode1 90101 "09.0101 - Communications, General", add 
label define label_cipcode1 90201 "09.0201 - Advertising", add 
label define label_cipcode1 90402 "09.0402 - Broadcast Journalism", add 
label define label_cipcode1 90701 "09.0701 - Radio and Television Broadcasting", add 
label define label_cipcode1 99999 "09.9999 - Communications, Other", add 
label define label_cipcode1 100103 "10.0103 - Photographic Tech./Technician", add 
label define label_cipcode1 100104 "10.0104 - Radio and Television Broadcasting Tech.", add 
label define label_cipcode1 100199 "10.0199 - Communications Technol./Technicians, Oth", add 
label define label_cipcode1 110101 "11.0101 - Computer and Information Sciences, Gen.", add 
label define label_cipcode1 110201 "11.0201 - Computer Programming", add 
label define label_cipcode1 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode1 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode1 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode1 110701 "11.0701 - Computer Science", add 
label define label_cipcode1 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode1 120203 "12.0203 - Card Dealer", add 
label define label_cipcode1 120301 "12.0301 - Funeral Services and Mortuary Science", add 
label define label_cipcode1 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode1 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode1 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode1 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode1 120405 "12.0405 - Massage", add 
label define label_cipcode1 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode1 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode1 120501 "12.0501 - Baker/Pastry Chef", add 
label define label_cipcode1 120502 "12.0502 - Bartender/Mixologist", add 
label define label_cipcode1 120503 "12.0503 - Culinary Arts/Chef Training", add 
label define label_cipcode1 120504 "12.0504 - Food & Beverage/Restaurant Opns. Manager", add 
label define label_cipcode1 120506 "12.0506 - Meatcutter", add 
label define label_cipcode1 120599 "12.0599 - Culinary Arts & Related Services, Other", add 
label define label_cipcode1 129999 "12.9999 - Personal & Miscellaneous Services, Other", add 
label define label_cipcode1 131204 "13.1204 - Pre-Elem/Erly Childhd/KG. Teach Educ", add 
label define label_cipcode1 131206 "13.1206 - Teacher Education, Multiple Levels", add 
label define label_cipcode1 131306 "13.1306 - Foreign Languages Teacher Education", add 
label define label_cipcode1 131399 "13.1399 - Teacher Ed., Spec Acad & Voc Prog, Oth", add 
label define label_cipcode1 139999 "13.9999 - Education, Other", add 
label define label_cipcode1 140901 "14.0901 - Computer Engineering", add 
label define label_cipcode1 141001 "14.1001 - Electrical, Electronics & Communication", add 
label define label_cipcode1 141401 "14.1401 - Environmental/Environmental Health Engin", add 
label define label_cipcode1 141701 "14.1701 - Industrial/Manufacturing Engineering", add 
label define label_cipcode1 142001 "14.2001 - Metallurgical Engineering", add 
label define label_cipcode1 150101 "15.0101 - Architectural Engineering Techno/Tech", add 
label define label_cipcode1 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode1 150303 "15.0303 - Elec., Electronic & Comm. Engin. Tech.", add 
label define label_cipcode1 150399 "15.0399 - Electrical & Electronic Engin.-Rel. Tech", add 
label define label_cipcode1 150402 "15.0402 - Computer Main. Tech./Technician", add 
label define label_cipcode1 150403 "15.0403 - Electromechanical Tech./Technician", add 
label define label_cipcode1 150404 "15.0404 - Instrumentation Tech./Technician", add 
label define label_cipcode1 150405 "15.0405 - Robotics Tech./Technician", add 
label define label_cipcode1 150501 "15.0501 - Heating, Air Condition. & Refrig. Tech.", add 
label define label_cipcode1 150507 "15.0507 - Environmental & Pollution Control Tech.", add 
label define label_cipcode1 150599 "15.0599 - Environmental Control Tech, Oth.", add 
label define label_cipcode1 150611 "15.0611 - Metallurgical Tech./Technician", add 
label define label_cipcode1 150702 "15.0702 - Quality Control Tech./Technician", add 
label define label_cipcode1 150803 "15.0803 - Automotive Engineering Tech./Technician", add 
label define label_cipcode1 150805 "15.0805 - Mechanical Engineering/Mechanical Tech.", add 
label define label_cipcode1 150901 "15.0901 - Mining Tech./Technician", add 
label define label_cipcode1 151001 "15.1001 - Construction/Building Tech./Technician", add 
label define label_cipcode1 151101 "15.1101 - Engineering-Related Tech/Technician, Gen", add 
label define label_cipcode1 151102 "15.1102 - Surveying", add 
label define label_cipcode1 159999 "15.9999 - Engineering-Related Technol./Techn, Oth.", add 
label define label_cipcode1 160101 "16.0101 - Foreign Languages and Literatures, Gen.", add 
label define label_cipcode1 160103 "16.0103 - Foreign Language Interpretation\Translat", add 
label define label_cipcode1 160302 "16.0302 - Japanese Language and Literature", add 
label define label_cipcode1 160905 "16.0905 - Spanish Language and Literature", add 
label define label_cipcode1 169999 "16.9999 - Foreign Languages and Literatures, Other", add 
label define label_cipcode1 190799 "19.0799 - Individual/Family Devel. Studies, Oth.", add 
label define label_cipcode1 200201 "20.0201 - Child Care/Guidance Workers & Manager, G", add 
label define label_cipcode1 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode1 200301 "20.0301 - Clothing, Apparel & Textile Workers & Ma", add 
label define label_cipcode1 200303 "20.0303 - Commercial Garment and Apparel Worker", add 
label define label_cipcode1 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode1 200309 "20.0309 - Drycleaner and Launderer (Commercial)", add 
label define label_cipcode1 200405 "20.0405 - Food Caterer", add 
label define label_cipcode1 200501 "20.0501 - Home Furnishings and Equipment Installer", add 
label define label_cipcode1 200601 "20.0601 - Custodial, Housekeeping and Home Service", add 
label define label_cipcode1 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode1 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode1 230101 "23.0101 - English Language and Literature, General", add 
label define label_cipcode1 231101 "23.1101 - English Technical and Business Writing", add 
label define label_cipcode1 239999 "23.9999 - English Language and Literature/Letters,", add 
label define label_cipcode1 240101 "24.0101 - Liberal Arts & Sciences/Liberal Studies", add 
label define label_cipcode1 310101 "31.0101 - Parks, Recreation and Leisure Studies", add 
label define label_cipcode1 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode1 390101 "39.0101 - Biblical & Oth Theological Lang. & Lit.", add 
label define label_cipcode1 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode1 390301 "39.0301 - Missions/Missionary Studies and Misology", add 
label define label_cipcode1 390601 "39.0601 - Theology/Theological Studies", add 
label define label_cipcode1 390604 "39.0604 - Pre-Theological/Pre-Ministerial Studies", add 
label define label_cipcode1 399999 "39.9999 - Theological Studies & Rel. Vocations, Ot", add 
label define label_cipcode1 400699 "40.0699 - Geological and Related Sciences, Other", add 
label define label_cipcode1 400702 "40.0702 - Oceanography", add 
label define label_cipcode1 410204 "41.0204 - Industrial Radiologic Tech./Technician", add 
label define label_cipcode1 420101 "42.0101 - Psychology, General", add 
label define label_cipcode1 420301 "42.0301 - Cognitive Psychology & Psycholinguistics", add 
label define label_cipcode1 429999 "42.9999 - Psychology, Other", add 
label define label_cipcode1 430102 "43.0102 - Corrections/Correctional Administration", add 
label define label_cipcode1 430103 "43.0103 - Criminal Justice/Law Enforcement Admin.", add 
label define label_cipcode1 430104 "43.0104 - Criminal Justice Studies", add 
label define label_cipcode1 430106 "43.0106 - Forensic Tech./Technician", add 
label define label_cipcode1 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode1 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode1 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode1 430203 "43.0203 - Fire Science/Firefighting", add 
label define label_cipcode1 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode1 440701 "44.0701 - Social Work", add 
label define label_cipcode1 460101 "46.0101 - Mason and Tile Setter", add 
label define label_cipcode1 460302 "46.0302 - Electrician", add 
label define label_cipcode1 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode1 460403 "46.0403 - Construction/Building Inspector", add 
label define label_cipcode1 460408 "46.0408 - Painter and Wall Coverer", add 
label define label_cipcode1 460499 "46.0499 - Const. & Bldg. Finishers & Managers, Oth", add 
label define label_cipcode1 460501 "46.0501 - Plumber and Pipefitter", add 
label define label_cipcode1 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode1 470101 "47.0101 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode1 470102 "47.0102 - Business Machine Repairer", add 
label define label_cipcode1 470103 "47.0103 - Communication Sys. Installer & Repairer", add 
label define label_cipcode1 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode1 470105 "47.0105 - Indus. Electronics Installer & Repairer", add 
label define label_cipcode1 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode1 470199 "47.0199 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode1 470201 "47.0201 - Heating, Air Conditioning and Refrigerat", add 
label define label_cipcode1 470302 "47.0302 - Heavy Equipment Main. and Repairer", add 
label define label_cipcode1 470303 "47.0303 - Industrial Machinery Main. and Repairer", add 
label define label_cipcode1 470399 "47.0399 - Indus. Equip. Main. and Repairers, Oth.", add 
label define label_cipcode1 470402 "47.0402 - Gunsmith", add 
label define label_cipcode1 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode1 470404 "47.0404 - Musical Instrument Repairer", add 
label define label_cipcode1 470408 "47.0408 - Watch, Clock and Jewelry Repairer", add 
label define label_cipcode1 470499 "47.0499 - Miscellaneous Mechanics & Repairers, Oth", add 
label define label_cipcode1 470501 "47.0501 - Stationary Energy Sources Installer/Oper", add 
label define label_cipcode1 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode1 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode1 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode1 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode1 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode1 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode1 470609 "47.0609 - Aviation Systems and Avionics Main. Tech", add 
label define label_cipcode1 470611 "47.0611 - Motorcycle Mechanic and Repairer", add 
label define label_cipcode1 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode1 480101 "48.0101 - Drafting, General", add 
label define label_cipcode1 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode1 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode1 480201 "48.0201 - Graphic & Printing Equip. Operator, Gen.", add 
label define label_cipcode1 480212 "48.0212 - Desktop Publishing Equipment Operator", add 
label define label_cipcode1 480303 "48.0303 - Upholsterer", add 
label define label_cipcode1 480501 "48.0501 - Machinist/Machine Technologist", add 
label define label_cipcode1 480507 "48.0507 - Tool and Die Maker/Technologist", add 
label define label_cipcode1 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode1 480599 "48.0599 - Precision Metal Workers, Other", add 
label define label_cipcode1 480702 "48.0702 - Furniture Designer and Maker", add 
label define label_cipcode1 480799 "48.0799 - Woodworkers, Other", add 
label define label_cipcode1 489999 "48.9999 - Precision Production Trades, Other", add 
label define label_cipcode1 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode1 490102 "49.0102 - Aircraft Pilot & Navigator (Professional", add 
label define label_cipcode1 490104 "49.0104 - Aviation Management", add 
label define label_cipcode1 490106 "49.0106 - Flight Attendant", add 
label define label_cipcode1 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode1 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode1 490205 "49.0205 - Truck, Bus & Oth. Commercial Vehicle Op.", add 
label define label_cipcode1 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode1 490309 "49.0309 - Marine Science/Merchant Marine Officer", add 
label define label_cipcode1 499999 "49.9999 - Transportation and Materials Moving Work", add 
label define label_cipcode1 500101 "50.0101 - Visual and Performing Arts", add 
label define label_cipcode1 500301 "50.0301 - Dance", add 
label define label_cipcode1 500402 "50.0402 - Graphic Design, Commercial Art and Illus", add 
label define label_cipcode1 500406 "50.0406 - Commercial Photography", add 
label define label_cipcode1 500407 "50.0407 - Fashion Design and Illustration", add 
label define label_cipcode1 500408 "50.0408 - Interior Design", add 
label define label_cipcode1 500499 "50.0499 - Design and Applied Arts, Other", add 
label define label_cipcode1 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode1 500503 "50.0503 - Acting and Directing", add 
label define label_cipcode1 500504 "50.0504 - Playwriting and Screenwriting", add 
label define label_cipcode1 500602 "50.0602 - Film-Video Making/Cinematography & Prod.", add 
label define label_cipcode1 500605 "50.0605 - Photography", add 
label define label_cipcode1 500713 "50.0713 - Metal and Jewelry Arts", add 
label define label_cipcode1 500901 "50.0901 - Music, General", add 
label define label_cipcode1 500903 "50.0903 - Music - General Performance", add 
label define label_cipcode1 500999 "50.0999 - Music, Other", add 
label define label_cipcode1 509999 "50.9999 - Visual and Performing Arts, Other", add 
label define label_cipcode1 510301 "51.0301 - Community Health Liaison", add 
label define label_cipcode1 510601 "51.0601 - Dental Assistant", add 
label define label_cipcode1 510603 "51.0603 - Dental Laboratory Technician", add 
label define label_cipcode1 510699 "51.0699 - Dental Services, Other", add 
label define label_cipcode1 510701 "51.0701 - Health System/Health Services Admin.", add 
label define label_cipcode1 510705 "51.0705 - Medical Office Management", add 
label define label_cipcode1 510706 "51.0706 - Medical Records Administration", add 
label define label_cipcode1 510707 "51.0707 - Medical Records Tech./Technician", add 
label define label_cipcode1 510708 "51.0708 - Medical Transcription", add 
label define label_cipcode1 510799 "51.0799 - Health & Medical Admin. Services, Oth.", add 
label define label_cipcode1 510801 "51.0801 - Medical Assistant", add 
label define label_cipcode1 510802 "51.0802 - Medical Laboratory Assistant", add 
label define label_cipcode1 510805 "51.0805 - Pharmacy Technician/Assistant", add 
label define label_cipcode1 510806 "51.0806 - Physical Therapy Assistant", add 
label define label_cipcode1 510808 "51.0808 - Veterinarian Assistant/Animal Health Tec", add 
label define label_cipcode1 510899 "51.0899 - Health and Medical Assistants, Other", add 
label define label_cipcode1 510901 "51.0901 - Cardiovascular Tech./Technician", add 
label define label_cipcode1 510902 "51.0902 - Electrocardiograph Tech./Technician", add 
label define label_cipcode1 510903 "51.0903 - Electroencephalograph Tech./Technician", add 
label define label_cipcode1 510904 "51.0904 - Emergency Medical Tech./Technician", add 
label define label_cipcode1 510905 "51.0905 - Nuclear Medical Tech./Technician", add 
label define label_cipcode1 510907 "51.0907 - Medical Radiologic Tech./Technician", add 
label define label_cipcode1 510908 "51.0908 - Respiratory Therapy Technician", add 
label define label_cipcode1 510909 "51.0909 - Surgical/Operating Room Technician", add 
label define label_cipcode1 510910 "51.0910 - Diagnostic Medical Sonography", add 
label define label_cipcode1 510999 "51.0999 - Health & Med. Diagnostic & Treat Svc, Ot", add 
label define label_cipcode1 511004 "51.1004 - Medical Laboratory Technician", add 
label define label_cipcode1 511005 "51.1005 - Medical Technology", add 
label define label_cipcode1 511099 "51.1099 - Health & Medical Laboratory Tech., Oth.", add 
label define label_cipcode1 511199 "51.1199 - Health & Med. Preparatory Programs, Oth", add 
label define label_cipcode1 511301 "51.1301 - Medical Anatomy", add 
label define label_cipcode1 511311 "51.1311 - Medical Nutrition", add 
label define label_cipcode1 511312 "51.1312 - Medical Pathology", add 
label define label_cipcode1 511501 "51.1501 - Alcohol/Drug Abuse Counseling", add 
label define label_cipcode1 511503 "51.1503 - Clinical and Medical Social Work", add 
label define label_cipcode1 511599 "51.1599 - Mental Health Services, Other", add 
label define label_cipcode1 511601 "51.1601 - Nursing (R.N. Training)", add 
label define label_cipcode1 511613 "51.1613 - Practical Nurse (L.P.N. Training)", add 
label define label_cipcode1 511614 "51.1614 - Nurse Assistant/Aide", add 
label define label_cipcode1 511615 "51.1615 - Home Health Aide", add 
label define label_cipcode1 511699 "51.1699 - Nursing, Other", add 
label define label_cipcode1 511801 "51.1801 - Opticianry/Dispensing Optician", add 
label define label_cipcode1 512303 "51.2303 - Hypnotherapy", add 
label define label_cipcode1 512306 "51.2306 - Occupational Therapy", add 
label define label_cipcode1 512399 "51.2399 - Rehabilitation/Therapeutic Services, Oth", add 
label define label_cipcode1 512701 "51.2701 - Acupuncture and Oriental Medicine", add 
label define label_cipcode1 512704 "51.2704 - Naturopathic Medicine", add 
label define label_cipcode1 519999 "51.9999 - Health Professions & Rel. Sciences, Oth.", add 
label define label_cipcode1 520101 "52.0101 - Business, General", add 
label define label_cipcode1 520201 "52.0201 - Business Administration & Mgmt., Gen.", add 
label define label_cipcode1 520301 "52.0301 - Accounting", add 
label define label_cipcode1 520302 "52.0302 - Accounting Technician", add 
label define label_cipcode1 520399 "52.0399 - Accounting, Other", add 
label define label_cipcode1 520401 "52.0401 - Administrative Assistant/Secretarial Sci", add 
label define label_cipcode1 520402 "52.0402 - Executive Assistant/Secretary", add 
label define label_cipcode1 520403 "52.0403 - Legal Administrative Assistant/Secretary", add 
label define label_cipcode1 520404 "52.0404 - Medical Administrative Asst./Secretary", add 
label define label_cipcode1 520405 "52.0405 - Court Reporter", add 
label define label_cipcode1 520406 "52.0406 - Receptionist", add 
label define label_cipcode1 520407 "52.0407 - Information Processing/Data Entry Tech.", add 
label define label_cipcode1 520408 "52.0408 - General Office/Clerical & Typing Serv.", add 
label define label_cipcode1 520499 "52.0499 - Administrative & Secretarial Serv., Oth.", add 
label define label_cipcode1 520601 "52.0601 - Business/Managerial Economics", add 
label define label_cipcode1 520701 "52.0701 - Enterprise Management & Operation, Gen.", add 
label define label_cipcode1 520801 "52.0801 - Finance, General", add 
label define label_cipcode1 520803 "52.0803 - Banking and Financial Support Services", add 
label define label_cipcode1 520804 "52.0804 - Financial Planning", add 
label define label_cipcode1 520805 "52.0805 - Insurance and Risk Management", add 
label define label_cipcode1 520902 "52.0902 - Hotel/Motel and Restaurant Management", add 
label define label_cipcode1 520903 "52.0903 - Travel-Tourism Management", add 
label define label_cipcode1 520999 "52.0999 - Hospitality Services Management, Other", add 
label define label_cipcode1 521201 "52.1201 - Mgmt. Info. Systems & Bus. Data Process", add 
label define label_cipcode1 521202 "52.1202 - Business Computer Programming/Programmer", add 
label define label_cipcode1 521203 "52.1203 - Business Systems Analysis and Design", add 
label define label_cipcode1 521205 "52.1205 - Business Computer Facilities Operator", add 
label define label_cipcode1 521299 "52.1299 - Business Information and Data Processing", add 
label define label_cipcode1 521501 "52.1501 - Real Estate", add 
label define label_cipcode1 521601 "52.1601 - Taxation", add 
label define label_cipcode1 529999 "52.9999 - Business Management & Admin. Serv., Oth.", add 
label values cipcode1 label_cipcode1
label define label_cipcode2 10505 "01.0505 - Animal Trainer" 
label define label_cipcode2 10507 "01.0507 - Eques./Equine Stds., Horse Mgmt. & Trgn.", add 
label define label_cipcode2 10599 "01.0599 - Ag. Supplies and Related Svcs, Other", add 
label define label_cipcode2 10699 "01.0699 - Horticulture Svcs. Ops. and Mgmt., Oth.", add 
label define label_cipcode2 19999 "01.9999 - Agricultural Business & Production, Oth.", add 
label define label_cipcode2 20299 "02.0299 - Animal Sciences, Other", add 
label define label_cipcode2 30599 "03.0599 - Forestry and Related Sciences, Other", add 
label define label_cipcode2 40301 "04.0301 - City/Urban, Community & Reg. Planning", add 
label define label_cipcode2 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode2 80204 "08.0204 - Business Services Marketing Operations", add 
label define label_cipcode2 80301 "08.0301 - Entrepreneurship", add 
label define label_cipcode2 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode2 80701 "08.0701 - Auctioneering", add 
label define label_cipcode2 80706 "08.0706 - General Selling Skills and Sales Opns.", add 
label define label_cipcode2 80901 "08.0901 - Hospitality & Rec. Marketing Opns, Gen", add 
label define label_cipcode2 80902 "08.0902 - Hotel/Motel Serv. Marketing Operation", add 
label define label_cipcode2 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode2 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode2 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode2 81199 "08.1199 - Tourism & Travel Serv. Market. Opns,Oth", add 
label define label_cipcode2 90701 "09.0701 - Radio and Television Broadcasting", add 
label define label_cipcode2 99999 "09.9999 - Communications, Other", add 
label define label_cipcode2 100103 "10.0103 - Photographic Tech./Technician", add 
label define label_cipcode2 100199 "10.0199 - Communications Technol./Technicians, Oth", add 
label define label_cipcode2 110101 "11.0101 - Computer and Information Sciences, Gen.", add 
label define label_cipcode2 110201 "11.0201 - Computer Programming", add 
label define label_cipcode2 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode2 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode2 110701 "11.0701 - Computer Science", add 
label define label_cipcode2 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode2 120203 "12.0203 - Card Dealer", add 
label define label_cipcode2 120301 "12.0301 - Funeral Services and Mortuary Science", add 
label define label_cipcode2 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode2 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode2 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode2 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode2 120405 "12.0405 - Massage", add 
label define label_cipcode2 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode2 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode2 120501 "12.0501 - Baker/Pastry Chef", add 
label define label_cipcode2 120502 "12.0502 - Bartender/Mixologist", add 
label define label_cipcode2 120503 "12.0503 - Culinary Arts/Chef Training", add 
label define label_cipcode2 120504 "12.0504 - Food & Beverage/Restaurant Opns. Manager", add 
label define label_cipcode2 120505 "12.0505 - Kitchen Personnel/Cook & Asst. Trng.", add 
label define label_cipcode2 120599 "12.0599 - Culinary Arts & Related Services, Other", add 
label define label_cipcode2 129999 "12.9999 - Personal & Miscellaneous Services, Other", add 
label define label_cipcode2 131202 "13.1202 - Elementary Teacher Education", add 
label define label_cipcode2 131204 "13.1204 - Pre-Elem/Erly Childhd/KG. Teach Educ", add 
label define label_cipcode2 131299 "13.1299 - General Teacher Education, Other", add 
label define label_cipcode2 131306 "13.1306 - Foreign Languages Teacher Education", add 
label define label_cipcode2 131312 "13.1312 - Music Teacher Education", add 
label define label_cipcode2 131399 "13.1399 - Teacher Ed., Spec Acad & Voc Prog, Oth", add 
label define label_cipcode2 142201 "14.2201 - Naval Architecture & Marine Engineering", add 
label define label_cipcode2 142901 "14.2901 - Engineering Design", add 
label define label_cipcode2 149999 "14.9999 - Engineering, Other", add 
label define label_cipcode2 150101 "15.0101 - Architectural Engineering Techno/Tech", add 
label define label_cipcode2 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode2 150303 "15.0303 - Elec., Electronic & Comm. Engin. Tech.", add 
label define label_cipcode2 150304 "15.0304 - Laser and Optical Tech./Technician", add 
label define label_cipcode2 150399 "15.0399 - Electrical & Electronic Engin.-Rel. Tech", add 
label define label_cipcode2 150402 "15.0402 - Computer Main. Tech./Technician", add 
label define label_cipcode2 150403 "15.0403 - Electromechanical Tech./Technician", add 
label define label_cipcode2 150405 "15.0405 - Robotics Tech./Technician", add 
label define label_cipcode2 150501 "15.0501 - Heating, Air Condition. & Refrig. Tech.", add 
label define label_cipcode2 150506 "15.0506 - Water Quality/Wastewater Treatment Tech.", add 
label define label_cipcode2 150507 "15.0507 - Environmental & Pollution Control Tech.", add 
label define label_cipcode2 150599 "15.0599 - Environmental Control Tech, Oth.", add 
label define label_cipcode2 150611 "15.0611 - Metallurgical Tech./Technician", add 
label define label_cipcode2 150699 "15.0699 - Industrial Product. Technol./Techn, Oth.", add 
label define label_cipcode2 150701 "15.0701 - Occupational Safety & Health Tech./Techn", add 
label define label_cipcode2 150799 "15.0799 - Quality Control & Safety Technol./Tech.", add 
label define label_cipcode2 150805 "15.0805 - Mechanical Engineering/Mechanical Tech.", add 
label define label_cipcode2 150899 "15.0899 - Mechanical Engineering-Related Tech, Oth", add 
label define label_cipcode2 150901 "15.0901 - Mining Tech./Technician", add 
label define label_cipcode2 150999 "15.0999 - Mining & Petroleum Technol./Tech, Other", add 
label define label_cipcode2 151001 "15.1001 - Construction/Building Tech./Technician", add 
label define label_cipcode2 151101 "15.1101 - Engineering-Related Tech/Technician, Gen", add 
label define label_cipcode2 159999 "15.9999 - Engineering-Related Technol./Techn, Oth.", add 
label define label_cipcode2 160101 "16.0101 - Foreign Languages and Literatures, Gen.", add 
label define label_cipcode2 160302 "16.0302 - Japanese Language and Literature", add 
label define label_cipcode2 160901 "16.0901 - French Language and Literature", add 
label define label_cipcode2 160905 "16.0905 - Spanish Language and Literature", add 
label define label_cipcode2 169999 "16.9999 - Foreign Languages and Literatures, Other", add 
label define label_cipcode2 190501 "19.0501 - Foods and Nutrition Studies, General", add 
label define label_cipcode2 190799 "19.0799 - Individual/Family Devel. Studies, Oth.", add 
label define label_cipcode2 200201 "20.0201 - Child Care/Guidance Workers & Manager, G", add 
label define label_cipcode2 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode2 200203 "20.0203 - Child Care Services Manager", add 
label define label_cipcode2 200301 "20.0301 - Clothing, Apparel & Textile Workers & Ma", add 
label define label_cipcode2 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode2 200309 "20.0309 - Drycleaner and Launderer (Commercial)", add 
label define label_cipcode2 200405 "20.0405 - Food Caterer", add 
label define label_cipcode2 200409 "20.0409 - Institutional Food Services Admin.", add 
label define label_cipcode2 200499 "20.0499 - Institutional Food Workers & Admin, Oth", add 
label define label_cipcode2 200501 "20.0501 - Home Furnishings and Equipment Installer", add 
label define label_cipcode2 200601 "20.0601 - Custodial, Housekeeping and Home Service", add 
label define label_cipcode2 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode2 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode2 230101 "23.0101 - English Language and Literature, General", add 
label define label_cipcode2 239999 "23.9999 - English Language and Literature/Letters,", add 
label define label_cipcode2 240101 "24.0101 - Liberal Arts & Sciences/Liberal Studies", add 
label define label_cipcode2 300101 "30.0101 - Biological and Physical Sciences", add 
label define label_cipcode2 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode2 390401 "39.0401 - Religious Education", add 
label define label_cipcode2 390602 "39.0602 - Divinity/Ministry (B.D., M.Div.)", add 
label define label_cipcode2 399999 "39.9999 - Theological Studies & Rel. Vocations, Ot", add 
label define label_cipcode2 400506 "40.0506 - Physical and Theoretical Chemistry", add 
label define label_cipcode2 400699 "40.0699 - Geological and Related Sciences, Other", add 
label define label_cipcode2 400702 "40.0702 - Oceanography", add 
label define label_cipcode2 410204 "41.0204 - Industrial Radiologic Tech./Technician", add 
label define label_cipcode2 410301 "41.0301 - Chemical Tech./Technician", add 
label define label_cipcode2 420101 "42.0101 - Psychology, General", add 
label define label_cipcode2 430102 "43.0102 - Corrections/Correctional Administration", add 
label define label_cipcode2 430104 "43.0104 - Criminal Justice Studies", add 
label define label_cipcode2 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode2 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode2 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode2 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode2 460201 "46.0201 - Carpenter", add 
label define label_cipcode2 460302 "46.0302 - Electrician", add 
label define label_cipcode2 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode2 460403 "46.0403 - Construction/Building Inspector", add 
label define label_cipcode2 460408 "46.0408 - Painter and Wall Coverer", add 
label define label_cipcode2 460499 "46.0499 - Const. & Bldg. Finishers & Managers, Oth", add 
label define label_cipcode2 460501 "46.0501 - Plumber and Pipefitter", add 
label define label_cipcode2 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode2 470101 "47.0101 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode2 470102 "47.0102 - Business Machine Repairer", add 
label define label_cipcode2 470103 "47.0103 - Communication Sys. Installer & Repairer", add 
label define label_cipcode2 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode2 470105 "47.0105 - Indus. Electronics Installer & Repairer", add 
label define label_cipcode2 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode2 470199 "47.0199 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode2 470201 "47.0201 - Heating, Air Conditioning and Refrigerat", add 
label define label_cipcode2 470303 "47.0303 - Industrial Machinery Main. and Repairer", add 
label define label_cipcode2 470399 "47.0399 - Indus. Equip. Main. and Repairers, Oth.", add 
label define label_cipcode2 470402 "47.0402 - Gunsmith", add 
label define label_cipcode2 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode2 470404 "47.0404 - Musical Instrument Repairer", add 
label define label_cipcode2 470408 "47.0408 - Watch, Clock and Jewelry Repairer", add 
label define label_cipcode2 470499 "47.0499 - Miscellaneous Mechanics & Repairers, Oth", add 
label define label_cipcode2 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode2 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode2 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode2 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode2 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode2 470609 "47.0609 - Aviation Systems and Avionics Main. Tech", add 
label define label_cipcode2 470611 "47.0611 - Motorcycle Mechanic and Repairer", add 
label define label_cipcode2 470699 "47.0699 - Vehicle & Mobile Equip. Mechanics & Repa", add 
label define label_cipcode2 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode2 480101 "48.0101 - Drafting, General", add 
label define label_cipcode2 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode2 480104 "48.0104 - Electrical/Electronics Drafting", add 
label define label_cipcode2 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode2 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode2 480206 "48.0206 - Lithographer and Platemaker", add 
label define label_cipcode2 480212 "48.0212 - Desktop Publishing Equipment Operator", add 
label define label_cipcode2 480303 "48.0303 - Upholsterer", add 
label define label_cipcode2 480501 "48.0501 - Machinist/Machine Technologist", add 
label define label_cipcode2 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode2 480506 "48.0506 - Sheet Metal Worker", add 
label define label_cipcode2 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode2 480599 "48.0599 - Precision Metal Workers, Other", add 
label define label_cipcode2 480703 "48.0703 - Cabinet Maker and Millworker", add 
label define label_cipcode2 489999 "48.9999 - Precision Production Trades, Other", add 
label define label_cipcode2 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode2 490102 "49.0102 - Aircraft Pilot & Navigator (Professional", add 
label define label_cipcode2 490104 "49.0104 - Aviation Management", add 
label define label_cipcode2 490106 "49.0106 - Flight Attendant", add 
label define label_cipcode2 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode2 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode2 490202 "49.0202 - Construction Equipment Operator", add 
label define label_cipcode2 490205 "49.0205 - Truck, Bus & Oth. Commercial Vehicle Op.", add 
label define label_cipcode2 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode2 490306 "49.0306 - Marine Main. and Ship Repairer", add 
label define label_cipcode2 490309 "49.0309 - Marine Science/Merchant Marine Officer", add 
label define label_cipcode2 499999 "49.9999 - Transportation and Materials Moving Work", add 
label define label_cipcode2 500101 "50.0101 - Visual and Performing Arts", add 
label define label_cipcode2 500301 "50.0301 - Dance", add 
label define label_cipcode2 500402 "50.0402 - Graphic Design, Commercial Art and Illus", add 
label define label_cipcode2 500407 "50.0407 - Fashion Design and Illustration", add 
label define label_cipcode2 500408 "50.0408 - Interior Design", add 
label define label_cipcode2 500499 "50.0499 - Design and Applied Arts, Other", add 
label define label_cipcode2 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode2 500502 "50.0502 - Technical Theater/Theater Design & Stage", add 
label define label_cipcode2 500503 "50.0503 - Acting and Directing", add 
label define label_cipcode2 500602 "50.0602 - Film-Video Making/Cinematography & Prod.", add 
label define label_cipcode2 500605 "50.0605 - Photography", add 
label define label_cipcode2 500699 "50.0699 - Film/Video and Photographic Arts, Other", add 
label define label_cipcode2 500713 "50.0713 - Metal and Jewelry Arts", add 
label define label_cipcode2 500799 "50.0799 - Fine Arts and Art Studies, Other", add 
label define label_cipcode2 500903 "50.0903 - Music - General Performance", add 
label define label_cipcode2 500999 "50.0999 - Music, Other", add 
label define label_cipcode2 509999 "50.9999 - Visual and Performing Arts, Other", add 
label define label_cipcode2 510401 "51.0401 - Dentistry (D.D.S., D.M.D.)", add 
label define label_cipcode2 510601 "51.0601 - Dental Assistant", add 
label define label_cipcode2 510603 "51.0603 - Dental Laboratory Technician", add 
label define label_cipcode2 510699 "51.0699 - Dental Services, Other", add 
label define label_cipcode2 510701 "51.0701 - Health System/Health Services Admin.", add 
label define label_cipcode2 510703 "51.0703 - Health Unit Coordinator/Ward Clerk", add 
label define label_cipcode2 510705 "51.0705 - Medical Office Management", add 
label define label_cipcode2 510706 "51.0706 - Medical Records Administration", add 
label define label_cipcode2 510707 "51.0707 - Medical Records Tech./Technician", add 
label define label_cipcode2 510708 "51.0708 - Medical Transcription", add 
label define label_cipcode2 510799 "51.0799 - Health & Medical Admin. Services, Oth.", add 
label define label_cipcode2 510801 "51.0801 - Medical Assistant", add 
label define label_cipcode2 510802 "51.0802 - Medical Laboratory Assistant", add 
label define label_cipcode2 510805 "51.0805 - Pharmacy Technician/Assistant", add 
label define label_cipcode2 510806 "51.0806 - Physical Therapy Assistant", add 
label define label_cipcode2 510808 "51.0808 - Veterinarian Assistant/Animal Health Tec", add 
label define label_cipcode2 510899 "51.0899 - Health and Medical Assistants, Other", add 
label define label_cipcode2 510901 "51.0901 - Cardiovascular Tech./Technician", add 
label define label_cipcode2 510902 "51.0902 - Electrocardiograph Tech./Technician", add 
label define label_cipcode2 510903 "51.0903 - Electroencephalograph Tech./Technician", add 
label define label_cipcode2 510904 "51.0904 - Emergency Medical Tech./Technician", add 
label define label_cipcode2 510905 "51.0905 - Nuclear Medical Tech./Technician", add 
label define label_cipcode2 510907 "51.0907 - Medical Radiologic Tech./Technician", add 
label define label_cipcode2 510908 "51.0908 - Respiratory Therapy Technician", add 
label define label_cipcode2 510909 "51.0909 - Surgical/Operating Room Technician", add 
label define label_cipcode2 510910 "51.0910 - Diagnostic Medical Sonography", add 
label define label_cipcode2 510999 "51.0999 - Health & Med. Diagnostic & Treat Svc, Ot", add 
label define label_cipcode2 511001 "51.1001 - Blood Bank Tech./Technician", add 
label define label_cipcode2 511004 "51.1004 - Medical Laboratory Technician", add 
label define label_cipcode2 511005 "51.1005 - Medical Technology", add 
label define label_cipcode2 511099 "51.1099 - Health & Medical Laboratory Tech., Oth.", add 
label define label_cipcode2 511501 "51.1501 - Alcohol/Drug Abuse Counseling", add 
label define label_cipcode2 511502 "51.1502 - Psychiatric/Mental Health Services Tech.", add 
label define label_cipcode2 511601 "51.1601 - Nursing (R.N. Training)", add 
label define label_cipcode2 511605 "51.1605 - Nursing, Family Practice (Post-R.N.)", add 
label define label_cipcode2 511613 "51.1613 - Practical Nurse (L.P.N. Training)", add 
label define label_cipcode2 511614 "51.1614 - Nurse Assistant/Aide", add 
label define label_cipcode2 511615 "51.1615 - Home Health Aide", add 
label define label_cipcode2 511699 "51.1699 - Nursing, Other", add 
label define label_cipcode2 511802 "51.1802 - Optical Technician/Assistant", add 
label define label_cipcode2 512202 "51.2202 - Environmental Health", add 
label define label_cipcode2 512303 "51.2303 - Hypnotherapy", add 
label define label_cipcode2 512399 "51.2399 - Rehabilitation/Therapeutic Services, Oth", add 
label define label_cipcode2 512601 "51.2601 - Health Aide", add 
label define label_cipcode2 512701 "51.2701 - Acupuncture and Oriental Medicine", add 
label define label_cipcode2 512704 "51.2704 - Naturopathic Medicine", add 
label define label_cipcode2 519999 "51.9999 - Health Professions & Rel. Sciences, Oth.", add 
label define label_cipcode2 520101 "52.0101 - Business, General", add 
label define label_cipcode2 520201 "52.0201 - Business Administration & Mgmt., Gen.", add 
label define label_cipcode2 520204 "52.0204 - Office Supervision and Management", add 
label define label_cipcode2 520205 "52.0205 - Operations Management and Supervision", add 
label define label_cipcode2 520299 "52.0299 - Business Administration & Mgmt., Oth.", add 
label define label_cipcode2 520301 "52.0301 - Accounting", add 
label define label_cipcode2 520302 "52.0302 - Accounting Technician", add 
label define label_cipcode2 520399 "52.0399 - Accounting, Other", add 
label define label_cipcode2 520401 "52.0401 - Administrative Assistant/Secretarial Sci", add 
label define label_cipcode2 520402 "52.0402 - Executive Assistant/Secretary", add 
label define label_cipcode2 520403 "52.0403 - Legal Administrative Assistant/Secretary", add 
label define label_cipcode2 520404 "52.0404 - Medical Administrative Asst./Secretary", add 
label define label_cipcode2 520405 "52.0405 - Court Reporter", add 
label define label_cipcode2 520406 "52.0406 - Receptionist", add 
label define label_cipcode2 520407 "52.0407 - Information Processing/Data Entry Tech.", add 
label define label_cipcode2 520408 "52.0408 - General Office/Clerical & Typing Serv.", add 
label define label_cipcode2 520499 "52.0499 - Administrative & Secretarial Serv., Oth.", add 
label define label_cipcode2 520601 "52.0601 - Business/Managerial Economics", add 
label define label_cipcode2 520701 "52.0701 - Enterprise Management & Operation, Gen.", add 
label define label_cipcode2 520803 "52.0803 - Banking and Financial Support Services", add 
label define label_cipcode2 520805 "52.0805 - Insurance and Risk Management", add 
label define label_cipcode2 520807 "52.0807 - Investments and Securities", add 
label define label_cipcode2 520899 "52.0899 - Financial Management and Services, Other", add 
label define label_cipcode2 520901 "52.0901 - Hospitality/Administration Management", add 
label define label_cipcode2 520902 "52.0902 - Hotel/Motel and Restaurant Management", add 
label define label_cipcode2 520903 "52.0903 - Travel-Tourism Management", add 
label define label_cipcode2 520999 "52.0999 - Hospitality Services Management, Other", add 
label define label_cipcode2 521201 "52.1201 - Mgmt. Info. Systems & Bus. Data Process", add 
label define label_cipcode2 521202 "52.1202 - Business Computer Programming/Programmer", add 
label define label_cipcode2 521205 "52.1205 - Business Computer Facilities Operator", add 
label define label_cipcode2 521299 "52.1299 - Business Information and Data Processing", add 
label define label_cipcode2 521401 "52.1401 - Business Marketing/Marketing Management", add 
label define label_cipcode2 521499 "52.1499 - Marketing Management and Research, Other", add 
label define label_cipcode2 521501 "52.1501 - Real Estate", add 
label define label_cipcode2 521601 "52.1601 - Taxation", add 
label define label_cipcode2 529999 "52.9999 - Business Management & Admin. Serv., Oth.", add 
label values cipcode2 label_cipcode2
label define label_cipcode3 10104 "01.0104 - Farm and Ranch Management" 
label define label_cipcode3 10299 "01.0299 - Agricultural Mechanization, Other", add 
label define label_cipcode3 10505 "01.0505 - Animal Trainer", add 
label define label_cipcode3 10507 "01.0507 - Eques./Equine Stds., Horse Mgmt. & Trgn.", add 
label define label_cipcode3 10599 "01.0599 - Ag. Supplies and Related Svcs, Other", add 
label define label_cipcode3 10601 "01.0601 - Horticulture Svcs. Ops. and Mgmt., Gen.", add 
label define label_cipcode3 10605 "01.0605 - Landscaping Operations and Management", add 
label define label_cipcode3 10699 "01.0699 - Horticulture Svcs. Ops. and Mgmt., Oth.", add 
label define label_cipcode3 19999 "01.9999 - Agricultural Business & Production, Oth.", add 
label define label_cipcode3 20201 "02.0201 - Animal Sciences, General", add 
label define label_cipcode3 20299 "02.0299 - Animal Sciences, Other", add 
label define label_cipcode3 30599 "03.0599 - Forestry and Related Sciences, Other", add 
label define label_cipcode3 49999 "04.9999 - Architecture and Related Programs, Other", add 
label define label_cipcode3 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode3 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode3 80205 "08.0205 - Personal Services Marketing Operations", add 
label define label_cipcode3 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode3 80706 "08.0706 - General Selling Skills and Sales Opns.", add 
label define label_cipcode3 80901 "08.0901 - Hospitality & Rec. Marketing Opns, Gen", add 
label define label_cipcode3 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode3 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode3 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode3 81199 "08.1199 - Tourism & Travel Serv. Market. Opns,Oth", add 
label define label_cipcode3 90701 "09.0701 - Radio and Television Broadcasting", add 
label define label_cipcode3 99999 "09.9999 - Communications, Other", add 
label define label_cipcode3 100101 "10.0101 - Educational/Instructional Media Tech.", add 
label define label_cipcode3 100103 "10.0103 - Photographic Tech./Technician", add 
label define label_cipcode3 100104 "10.0104 - Radio and Television Broadcasting Tech.", add 
label define label_cipcode3 100199 "10.0199 - Communications Technol./Technicians, Oth", add 
label define label_cipcode3 110101 "11.0101 - Computer and Information Sciences, Gen.", add 
label define label_cipcode3 110201 "11.0201 - Computer Programming", add 
label define label_cipcode3 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode3 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode3 110701 "11.0701 - Computer Science", add 
label define label_cipcode3 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode3 120203 "12.0203 - Card Dealer", add 
label define label_cipcode3 120299 "12.0299 - Gaming & Sports Officiating Serv., Oth.", add 
label define label_cipcode3 120301 "12.0301 - Funeral Services and Mortuary Science", add 
label define label_cipcode3 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode3 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode3 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode3 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode3 120405 "12.0405 - Massage", add 
label define label_cipcode3 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode3 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode3 120501 "12.0501 - Baker/Pastry Chef", add 
label define label_cipcode3 120502 "12.0502 - Bartender/Mixologist", add 
label define label_cipcode3 120503 "12.0503 - Culinary Arts/Chef Training", add 
label define label_cipcode3 120504 "12.0504 - Food & Beverage/Restaurant Opns. Manager", add 
label define label_cipcode3 120507 "12.0507 - Waiter/Waitress and Dining Room Manager", add 
label define label_cipcode3 120599 "12.0599 - Culinary Arts & Related Services, Other", add 
label define label_cipcode3 129999 "12.9999 - Personal & Miscellaneous Services, Other", add 
label define label_cipcode3 131202 "13.1202 - Elementary Teacher Education", add 
label define label_cipcode3 131203 "13.1203 - Jr High/Intermed/Middle Sch Teach Educ", add 
label define label_cipcode3 131206 "13.1206 - Teacher Education, Multiple Levels", add 
label define label_cipcode3 131306 "13.1306 - Foreign Languages Teacher Education", add 
label define label_cipcode3 131399 "13.1399 - Teacher Ed., Spec Acad & Voc Prog, Oth", add 
label define label_cipcode3 131501 "13.1501 - Teacher Assistant/Aide", add 
label define label_cipcode3 140901 "14.0901 - Computer Engineering", add 
label define label_cipcode3 142901 "14.2901 - Engineering Design", add 
label define label_cipcode3 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode3 150303 "15.0303 - Elec., Electronic & Comm. Engin. Tech.", add 
label define label_cipcode3 150304 "15.0304 - Laser and Optical Tech./Technician", add 
label define label_cipcode3 150399 "15.0399 - Electrical & Electronic Engin.-Rel. Tech", add 
label define label_cipcode3 150402 "15.0402 - Computer Main. Tech./Technician", add 
label define label_cipcode3 150403 "15.0403 - Electromechanical Tech./Technician", add 
label define label_cipcode3 150404 "15.0404 - Instrumentation Tech./Technician", add 
label define label_cipcode3 150501 "15.0501 - Heating, Air Condition. & Refrig. Tech.", add 
label define label_cipcode3 150507 "15.0507 - Environmental & Pollution Control Tech.", add 
label define label_cipcode3 150599 "15.0599 - Environmental Control Tech, Oth.", add 
label define label_cipcode3 150607 "15.0607 - Plastics Tech./Technician", add 
label define label_cipcode3 151001 "15.1001 - Construction/Building Tech./Technician", add 
label define label_cipcode3 151101 "15.1101 - Engineering-Related Tech/Technician, Gen", add 
label define label_cipcode3 159999 "15.9999 - Engineering-Related Technol./Techn, Oth.", add 
label define label_cipcode3 160103 "16.0103 - Foreign Language Interpretation\Translat", add 
label define label_cipcode3 160302 "16.0302 - Japanese Language and Literature", add 
label define label_cipcode3 160501 "16.0501 - German Language and Literature", add 
label define label_cipcode3 160901 "16.0901 - French Language and Literature", add 
label define label_cipcode3 169999 "16.9999 - Foreign Languages and Literatures, Other", add 
label define label_cipcode3 190703 "19.0703 - Family and Marriage Counseling", add 
label define label_cipcode3 200201 "20.0201 - Child Care/Guidance Workers & Manager, G", add 
label define label_cipcode3 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode3 200203 "20.0203 - Child Care Services Manager", add 
label define label_cipcode3 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode3 200309 "20.0309 - Drycleaner and Launderer (Commercial)", add 
label define label_cipcode3 200499 "20.0499 - Institutional Food Workers & Admin, Oth", add 
label define label_cipcode3 200501 "20.0501 - Home Furnishings and Equipment Installer", add 
label define label_cipcode3 200601 "20.0601 - Custodial, Housekeeping and Home Service", add 
label define label_cipcode3 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode3 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode3 240102 "24.0102 - General Studies", add 
label define label_cipcode3 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode3 390501 "39.0501 - Religious/Sacred Music", add 
label define label_cipcode3 390701 "39.0701 - Pastoral Counseling & Specialized Minist", add 
label define label_cipcode3 400699 "40.0699 - Geological and Related Sciences, Other", add 
label define label_cipcode3 400702 "40.0702 - Oceanography", add 
label define label_cipcode3 410204 "41.0204 - Industrial Radiologic Tech./Technician", add 
label define label_cipcode3 410399 "41.0399 - Physical Science Technol./Technicians, O", add 
label define label_cipcode3 420301 "42.0301 - Cognitive Psychology & Psycholinguistics", add 
label define label_cipcode3 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode3 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode3 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode3 430201 "43.0201 - Fire Protection and Safety Tech./Technic", add 
label define label_cipcode3 430203 "43.0203 - Fire Science/Firefighting", add 
label define label_cipcode3 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode3 450101 "45.0101 - Social Sciences, General", add 
label define label_cipcode3 459999 "45.9999 - Social Sciences and History, Other", add 
label define label_cipcode3 460101 "46.0101 - Mason and Tile Setter", add 
label define label_cipcode3 460301 "46.0301 - Elec. & Power Trans. Installer, Gen.", add 
label define label_cipcode3 460302 "46.0302 - Electrician", add 
label define label_cipcode3 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode3 460403 "46.0403 - Construction/Building Inspector", add 
label define label_cipcode3 460499 "46.0499 - Const. & Bldg. Finishers & Managers, Oth", add 
label define label_cipcode3 460501 "46.0501 - Plumber and Pipefitter", add 
label define label_cipcode3 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode3 470101 "47.0101 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode3 470102 "47.0102 - Business Machine Repairer", add 
label define label_cipcode3 470103 "47.0103 - Communication Sys. Installer & Repairer", add 
label define label_cipcode3 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode3 470105 "47.0105 - Indus. Electronics Installer & Repairer", add 
label define label_cipcode3 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode3 470199 "47.0199 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode3 470201 "47.0201 - Heating, Air Conditioning and Refrigerat", add 
label define label_cipcode3 470303 "47.0303 - Industrial Machinery Main. and Repairer", add 
label define label_cipcode3 470399 "47.0399 - Indus. Equip. Main. and Repairers, Oth.", add 
label define label_cipcode3 470402 "47.0402 - Gunsmith", add 
label define label_cipcode3 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode3 470404 "47.0404 - Musical Instrument Repairer", add 
label define label_cipcode3 470408 "47.0408 - Watch, Clock and Jewelry Repairer", add 
label define label_cipcode3 470499 "47.0499 - Miscellaneous Mechanics & Repairers, Oth", add 
label define label_cipcode3 470501 "47.0501 - Stationary Energy Sources Installer/Oper", add 
label define label_cipcode3 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode3 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode3 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode3 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode3 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode3 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode3 470609 "47.0609 - Aviation Systems and Avionics Main. Tech", add 
label define label_cipcode3 470611 "47.0611 - Motorcycle Mechanic and Repairer", add 
label define label_cipcode3 470699 "47.0699 - Vehicle & Mobile Equip. Mechanics & Repa", add 
label define label_cipcode3 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode3 480101 "48.0101 - Drafting, General", add 
label define label_cipcode3 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode3 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode3 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode3 480201 "48.0201 - Graphic & Printing Equip. Operator, Gen.", add 
label define label_cipcode3 480206 "48.0206 - Lithographer and Platemaker", add 
label define label_cipcode3 480211 "48.0211 - Computer Typography & Composition Equip.", add 
label define label_cipcode3 480212 "48.0212 - Desktop Publishing Equipment Operator", add 
label define label_cipcode3 480299 "48.0299 - Graphic & Printing Equip. Operator, Oth.", add 
label define label_cipcode3 480303 "48.0303 - Upholsterer", add 
label define label_cipcode3 480501 "48.0501 - Machinist/Machine Technologist", add 
label define label_cipcode3 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode3 480507 "48.0507 - Tool and Die Maker/Technologist", add 
label define label_cipcode3 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode3 480599 "48.0599 - Precision Metal Workers, Other", add 
label define label_cipcode3 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode3 490102 "49.0102 - Aircraft Pilot & Navigator (Professional", add 
label define label_cipcode3 490104 "49.0104 - Aviation Management", add 
label define label_cipcode3 490106 "49.0106 - Flight Attendant", add 
label define label_cipcode3 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode3 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode3 490202 "49.0202 - Construction Equipment Operator", add 
label define label_cipcode3 490205 "49.0205 - Truck, Bus & Oth. Commercial Vehicle Op.", add 
label define label_cipcode3 490299 "49.0299 - Vehicle and Equipment Operators, Other", add 
label define label_cipcode3 490303 "49.0303 - Fishing Tech./Commercial Fishing", add 
label define label_cipcode3 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode3 490306 "49.0306 - Marine Main. and Ship Repairer", add 
label define label_cipcode3 490309 "49.0309 - Marine Science/Merchant Marine Officer", add 
label define label_cipcode3 499999 "49.9999 - Transportation and Materials Moving Work", add 
label define label_cipcode3 500101 "50.0101 - Visual and Performing Arts", add 
label define label_cipcode3 500301 "50.0301 - Dance", add 
label define label_cipcode3 500402 "50.0402 - Graphic Design, Commercial Art and Illus", add 
label define label_cipcode3 500404 "50.0404 - Industrial Design", add 
label define label_cipcode3 500406 "50.0406 - Commercial Photography", add 
label define label_cipcode3 500407 "50.0407 - Fashion Design and Illustration", add 
label define label_cipcode3 500408 "50.0408 - Interior Design", add 
label define label_cipcode3 500499 "50.0499 - Design and Applied Arts, Other", add 
label define label_cipcode3 500503 "50.0503 - Acting and Directing", add 
label define label_cipcode3 500605 "50.0605 - Photography", add 
label define label_cipcode3 500699 "50.0699 - Film/Video and Photographic Arts, Other", add 
label define label_cipcode3 500705 "50.0705 - Drawing", add 
label define label_cipcode3 500711 "50.0711 - Ceramics Arts and Ceramics", add 
label define label_cipcode3 500713 "50.0713 - Metal and Jewelry Arts", add 
label define label_cipcode3 500903 "50.0903 - Music - General Performance", add 
label define label_cipcode3 500999 "50.0999 - Music, Other", add 
label define label_cipcode3 509999 "50.9999 - Visual and Performing Arts, Other", add 
label define label_cipcode3 510601 "51.0601 - Dental Assistant", add 
label define label_cipcode3 510603 "51.0603 - Dental Laboratory Technician", add 
label define label_cipcode3 510699 "51.0699 - Dental Services, Other", add 
label define label_cipcode3 510703 "51.0703 - Health Unit Coordinator/Ward Clerk", add 
label define label_cipcode3 510705 "51.0705 - Medical Office Management", add 
label define label_cipcode3 510706 "51.0706 - Medical Records Administration", add 
label define label_cipcode3 510707 "51.0707 - Medical Records Tech./Technician", add 
label define label_cipcode3 510708 "51.0708 - Medical Transcription", add 
label define label_cipcode3 510799 "51.0799 - Health & Medical Admin. Services, Oth.", add 
label define label_cipcode3 510801 "51.0801 - Medical Assistant", add 
label define label_cipcode3 510802 "51.0802 - Medical Laboratory Assistant", add 
label define label_cipcode3 510804 "51.0804 - Ophthalmic Medical Assistant", add 
label define label_cipcode3 510805 "51.0805 - Pharmacy Technician/Assistant", add 
label define label_cipcode3 510806 "51.0806 - Physical Therapy Assistant", add 
label define label_cipcode3 510808 "51.0808 - Veterinarian Assistant/Animal Health Tec", add 
label define label_cipcode3 510899 "51.0899 - Health and Medical Assistants, Other", add 
label define label_cipcode3 510901 "51.0901 - Cardiovascular Tech./Technician", add 
label define label_cipcode3 510902 "51.0902 - Electrocardiograph Tech./Technician", add 
label define label_cipcode3 510904 "51.0904 - Emergency Medical Tech./Technician", add 
label define label_cipcode3 510905 "51.0905 - Nuclear Medical Tech./Technician", add 
label define label_cipcode3 510907 "51.0907 - Medical Radiologic Tech./Technician", add 
label define label_cipcode3 510908 "51.0908 - Respiratory Therapy Technician", add 
label define label_cipcode3 510909 "51.0909 - Surgical/Operating Room Technician", add 
label define label_cipcode3 510910 "51.0910 - Diagnostic Medical Sonography", add 
label define label_cipcode3 510999 "51.0999 - Health & Med. Diagnostic & Treat Svc, Ot", add 
label define label_cipcode3 511001 "51.1001 - Blood Bank Tech./Technician", add 
label define label_cipcode3 511003 "51.1003 - Hematology Tech./Technician", add 
label define label_cipcode3 511004 "51.1004 - Medical Laboratory Technician", add 
label define label_cipcode3 511005 "51.1005 - Medical Technology", add 
label define label_cipcode3 511006 "51.1006 - Optometric/Ophthalmic Laboratory Tech.", add 
label define label_cipcode3 511099 "51.1099 - Health & Medical Laboratory Tech., Oth.", add 
label define label_cipcode3 511199 "51.1199 - Health & Med. Preparatory Programs, Oth", add 
label define label_cipcode3 511311 "51.1311 - Medical Nutrition", add 
label define label_cipcode3 511502 "51.1502 - Psychiatric/Mental Health Services Tech.", add 
label define label_cipcode3 511601 "51.1601 - Nursing (R.N. Training)", add 
label define label_cipcode3 511604 "51.1604 - Nursing Anesthetist (Post-R.N.)", add 
label define label_cipcode3 511612 "51.1612 - Nursing, Surgical (Post-R.N.)", add 
label define label_cipcode3 511613 "51.1613 - Practical Nurse (L.P.N. Training)", add 
label define label_cipcode3 511614 "51.1614 - Nurse Assistant/Aide", add 
label define label_cipcode3 511615 "51.1615 - Home Health Aide", add 
label define label_cipcode3 511699 "51.1699 - Nursing, Other", add 
label define label_cipcode3 511801 "51.1801 - Opticianry/Dispensing Optician", add 
label define label_cipcode3 511899 "51.1899 - Ophthalmic/Optometric Services, Other", add 
label define label_cipcode3 512303 "51.2303 - Hypnotherapy", add 
label define label_cipcode3 512309 "51.2309 - Recreational Therapy", add 
label define label_cipcode3 512399 "51.2399 - Rehabilitation/Therapeutic Services, Oth", add 
label define label_cipcode3 512601 "51.2601 - Health Aide", add 
label define label_cipcode3 512701 "51.2701 - Acupuncture and Oriental Medicine", add 
label define label_cipcode3 519999 "51.9999 - Health Professions & Rel. Sciences, Oth.", add 
label define label_cipcode3 520101 "52.0101 - Business, General", add 
label define label_cipcode3 520201 "52.0201 - Business Administration & Mgmt., Gen.", add 
label define label_cipcode3 520204 "52.0204 - Office Supervision and Management", add 
label define label_cipcode3 520205 "52.0205 - Operations Management and Supervision", add 
label define label_cipcode3 520299 "52.0299 - Business Administration & Mgmt., Oth.", add 
label define label_cipcode3 520301 "52.0301 - Accounting", add 
label define label_cipcode3 520302 "52.0302 - Accounting Technician", add 
label define label_cipcode3 520399 "52.0399 - Accounting, Other", add 
label define label_cipcode3 520401 "52.0401 - Administrative Assistant/Secretarial Sci", add 
label define label_cipcode3 520402 "52.0402 - Executive Assistant/Secretary", add 
label define label_cipcode3 520403 "52.0403 - Legal Administrative Assistant/Secretary", add 
label define label_cipcode3 520404 "52.0404 - Medical Administrative Asst./Secretary", add 
label define label_cipcode3 520405 "52.0405 - Court Reporter", add 
label define label_cipcode3 520406 "52.0406 - Receptionist", add 
label define label_cipcode3 520407 "52.0407 - Information Processing/Data Entry Tech.", add 
label define label_cipcode3 520408 "52.0408 - General Office/Clerical & Typing Serv.", add 
label define label_cipcode3 520499 "52.0499 - Administrative & Secretarial Serv., Oth.", add 
label define label_cipcode3 520701 "52.0701 - Enterprise Management & Operation, Gen.", add 
label define label_cipcode3 520702 "52.0702 - Franchise Operation", add 
label define label_cipcode3 520801 "52.0801 - Finance, General", add 
label define label_cipcode3 520803 "52.0803 - Banking and Financial Support Services", add 
label define label_cipcode3 520805 "52.0805 - Insurance and Risk Management", add 
label define label_cipcode3 520901 "52.0901 - Hospitality/Administration Management", add 
label define label_cipcode3 520902 "52.0902 - Hotel/Motel and Restaurant Management", add 
label define label_cipcode3 520903 "52.0903 - Travel-Tourism Management", add 
label define label_cipcode3 520999 "52.0999 - Hospitality Services Management, Other", add 
label define label_cipcode3 521201 "52.1201 - Mgmt. Info. Systems & Bus. Data Process", add 
label define label_cipcode3 521202 "52.1202 - Business Computer Programming/Programmer", add 
label define label_cipcode3 521204 "52.1204 - Business Systems Networking and Telecomm", add 
label define label_cipcode3 521205 "52.1205 - Business Computer Facilities Operator", add 
label define label_cipcode3 521299 "52.1299 - Business Information and Data Processing", add 
label define label_cipcode3 521401 "52.1401 - Business Marketing/Marketing Management", add 
label define label_cipcode3 521501 "52.1501 - Real Estate", add 
label define label_cipcode3 521601 "52.1601 - Taxation", add 
label define label_cipcode3 529999 "52.9999 - Business Management & Admin. Serv., Oth.", add 
label values cipcode3 label_cipcode3
label define label_cipcode4 10101 "01.0101 - Agricultural Business and Mgmt., General" 
label define label_cipcode4 10299 "01.0299 - Agricultural Mechanization, Other", add 
label define label_cipcode4 10507 "01.0507 - Eques./Equine Stds., Horse Mgmt. & Trgn.", add 
label define label_cipcode4 10599 "01.0599 - Ag. Supplies and Related Svcs, Other", add 
label define label_cipcode4 19999 "01.9999 - Agricultural Business & Production, Oth.", add 
label define label_cipcode4 30404 "03.0404 - Forest Products Tech./Technician", add 
label define label_cipcode4 30599 "03.0599 - Forestry and Related Sciences, Other", add 
label define label_cipcode4 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode4 80199 "08.0199 - Apparel & Accessories Market. Opns, Oth.", add 
label define label_cipcode4 80299 "08.0299 - Bus. & Personal Ser. Market. Opns, Oth", add 
label define label_cipcode4 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode4 80601 "08.0601 - Food Products Retail and Wholesale Opns.", add 
label define label_cipcode4 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode4 80799 "08.0799 - Gen. Retail & Whlsale Opns. & Skills,Oth", add 
label define label_cipcode4 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode4 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode4 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode4 81199 "08.1199 - Tourism & Travel Serv. Market. Opns,Oth", add 
label define label_cipcode4 90701 "09.0701 - Radio and Television Broadcasting", add 
label define label_cipcode4 100104 "10.0104 - Radio and Television Broadcasting Tech.", add 
label define label_cipcode4 100199 "10.0199 - Communications Technol./Technicians, Oth", add 
label define label_cipcode4 110101 "11.0101 - Computer and Information Sciences, Gen.", add 
label define label_cipcode4 110201 "11.0201 - Computer Programming", add 
label define label_cipcode4 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode4 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode4 110701 "11.0701 - Computer Science", add 
label define label_cipcode4 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode4 120203 "12.0203 - Card Dealer", add 
label define label_cipcode4 120299 "12.0299 - Gaming & Sports Officiating Serv., Oth.", add 
label define label_cipcode4 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode4 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode4 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode4 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode4 120405 "12.0405 - Massage", add 
label define label_cipcode4 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode4 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode4 120502 "12.0502 - Bartender/Mixologist", add 
label define label_cipcode4 120503 "12.0503 - Culinary Arts/Chef Training", add 
label define label_cipcode4 120504 "12.0504 - Food & Beverage/Restaurant Opns. Manager", add 
label define label_cipcode4 120599 "12.0599 - Culinary Arts & Related Services, Other", add 
label define label_cipcode4 129999 "12.9999 - Personal & Miscellaneous Services, Other", add 
label define label_cipcode4 131202 "13.1202 - Elementary Teacher Education", add 
label define label_cipcode4 131299 "13.1299 - General Teacher Education, Other", add 
label define label_cipcode4 140901 "14.0901 - Computer Engineering", add 
label define label_cipcode4 150201 "15.0201 - Civil Engineering/Civil Tech./Technician", add 
label define label_cipcode4 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode4 150303 "15.0303 - Elec., Electronic & Comm. Engin. Tech.", add 
label define label_cipcode4 150402 "15.0402 - Computer Main. Tech./Technician", add 
label define label_cipcode4 150501 "15.0501 - Heating, Air Condition. & Refrig. Tech.", add 
label define label_cipcode4 150503 "15.0503 - Energy Management & Systems Tech./Techn.", add 
label define label_cipcode4 150507 "15.0507 - Environmental & Pollution Control Tech.", add 
label define label_cipcode4 150599 "15.0599 - Environmental Control Tech, Oth.", add 
label define label_cipcode4 150702 "15.0702 - Quality Control Tech./Technician", add 
label define label_cipcode4 150801 "15.0801 - Aeronautical & Aerospace Engineering Tec", add 
label define label_cipcode4 151001 "15.1001 - Construction/Building Tech./Technician", add 
label define label_cipcode4 151101 "15.1101 - Engineering-Related Tech/Technician, Gen", add 
label define label_cipcode4 159999 "15.9999 - Engineering-Related Technol./Techn, Oth.", add 
label define label_cipcode4 160103 "16.0103 - Foreign Language Interpretation\Translat", add 
label define label_cipcode4 160302 "16.0302 - Japanese Language and Literature", add 
label define label_cipcode4 160901 "16.0901 - French Language and Literature", add 
label define label_cipcode4 169999 "16.9999 - Foreign Languages and Literatures, Other", add 
label define label_cipcode4 190799 "19.0799 - Individual/Family Devel. Studies, Oth.", add 
label define label_cipcode4 200201 "20.0201 - Child Care/Guidance Workers & Manager, G", add 
label define label_cipcode4 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode4 200299 "20.0299 - Child Care/Guidance Workers & Manager, O", add 
label define label_cipcode4 200303 "20.0303 - Commercial Garment and Apparel Worker", add 
label define label_cipcode4 200399 "20.0399 - Clothing/Apparel/Textile Workers & Mange", add 
label define label_cipcode4 200401 "20.0401 - Institutional Food Workers & Admin, Gen", add 
label define label_cipcode4 200501 "20.0501 - Home Furnishings and Equipment Installer", add 
label define label_cipcode4 200601 "20.0601 - Custodial, Housekeeping and Home Service", add 
label define label_cipcode4 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode4 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode4 230101 "23.0101 - English Language and Literature, General", add 
label define label_cipcode4 260609 "26.0609 - Nutritional Sciences", add 
label define label_cipcode4 390701 "39.0701 - Pastoral Counseling & Specialized Minist", add 
label define label_cipcode4 400101 "40.0101 - Physical Sciences, General", add 
label define label_cipcode4 400702 "40.0702 - Oceanography", add 
label define label_cipcode4 410301 "41.0301 - Chemical Tech./Technician", add 
label define label_cipcode4 430106 "43.0106 - Forensic Tech./Technician", add 
label define label_cipcode4 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode4 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode4 430201 "43.0201 - Fire Protection and Safety Tech./Technic", add 
label define label_cipcode4 430203 "43.0203 - Fire Science/Firefighting", add 
label define label_cipcode4 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode4 450101 "45.0101 - Social Sciences, General", add 
label define label_cipcode4 460101 "46.0101 - Mason and Tile Setter", add 
label define label_cipcode4 460201 "46.0201 - Carpenter", add 
label define label_cipcode4 460302 "46.0302 - Electrician", add 
label define label_cipcode4 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode4 460501 "46.0501 - Plumber and Pipefitter", add 
label define label_cipcode4 470101 "47.0101 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode4 470103 "47.0103 - Communication Sys. Installer & Repairer", add 
label define label_cipcode4 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode4 470105 "47.0105 - Indus. Electronics Installer & Repairer", add 
label define label_cipcode4 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode4 470199 "47.0199 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode4 470201 "47.0201 - Heating, Air Conditioning and Refrigerat", add 
label define label_cipcode4 470302 "47.0302 - Heavy Equipment Main. and Repairer", add 
label define label_cipcode4 470303 "47.0303 - Industrial Machinery Main. and Repairer", add 
label define label_cipcode4 470402 "47.0402 - Gunsmith", add 
label define label_cipcode4 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode4 470404 "47.0404 - Musical Instrument Repairer", add 
label define label_cipcode4 470408 "47.0408 - Watch, Clock and Jewelry Repairer", add 
label define label_cipcode4 470499 "47.0499 - Miscellaneous Mechanics & Repairers, Oth", add 
label define label_cipcode4 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode4 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode4 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode4 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode4 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode4 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode4 470609 "47.0609 - Aviation Systems and Avionics Main. Tech", add 
label define label_cipcode4 470611 "47.0611 - Motorcycle Mechanic and Repairer", add 
label define label_cipcode4 470699 "47.0699 - Vehicle & Mobile Equip. Mechanics & Repa", add 
label define label_cipcode4 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode4 480101 "48.0101 - Drafting, General", add 
label define label_cipcode4 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode4 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode4 480201 "48.0201 - Graphic & Printing Equip. Operator, Gen.", add 
label define label_cipcode4 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode4 480501 "48.0501 - Machinist/Machine Technologist", add 
label define label_cipcode4 480506 "48.0506 - Sheet Metal Worker", add 
label define label_cipcode4 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode4 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode4 490102 "49.0102 - Aircraft Pilot & Navigator (Professional", add 
label define label_cipcode4 490104 "49.0104 - Aviation Management", add 
label define label_cipcode4 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode4 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode4 490202 "49.0202 - Construction Equipment Operator", add 
label define label_cipcode4 490205 "49.0205 - Truck, Bus & Oth. Commercial Vehicle Op.", add 
label define label_cipcode4 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode4 490309 "49.0309 - Marine Science/Merchant Marine Officer", add 
label define label_cipcode4 499999 "49.9999 - Transportation and Materials Moving Work", add 
label define label_cipcode4 500101 "50.0101 - Visual and Performing Arts", add 
label define label_cipcode4 500301 "50.0301 - Dance", add 
label define label_cipcode4 500402 "50.0402 - Graphic Design, Commercial Art and Illus", add 
label define label_cipcode4 500407 "50.0407 - Fashion Design and Illustration", add 
label define label_cipcode4 500408 "50.0408 - Interior Design", add 
label define label_cipcode4 500499 "50.0499 - Design and Applied Arts, Other", add 
label define label_cipcode4 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode4 500599 "50.0599 - Dramatic/Theater Arts & Stagecraft, Oth.", add 
label define label_cipcode4 500605 "50.0605 - Photography", add 
label define label_cipcode4 500699 "50.0699 - Film/Video and Photographic Arts, Other", add 
label define label_cipcode4 500712 "50.0712 - Fiber, Textile and Weaving Arts", add 
label define label_cipcode4 500713 "50.0713 - Metal and Jewelry Arts", add 
label define label_cipcode4 500903 "50.0903 - Music - General Performance", add 
label define label_cipcode4 500904 "50.0904 - Music Theory and Composition", add 
label define label_cipcode4 500999 "50.0999 - Music, Other", add 
label define label_cipcode4 509999 "50.9999 - Visual and Performing Arts, Other", add 
label define label_cipcode4 510101 "51.0101 - Chiropractic (D.C., D.C.M.)", add 
label define label_cipcode4 510601 "51.0601 - Dental Assistant", add 
label define label_cipcode4 510603 "51.0603 - Dental Laboratory Technician", add 
label define label_cipcode4 510703 "51.0703 - Health Unit Coordinator/Ward Clerk", add 
label define label_cipcode4 510705 "51.0705 - Medical Office Management", add 
label define label_cipcode4 510706 "51.0706 - Medical Records Administration", add 
label define label_cipcode4 510707 "51.0707 - Medical Records Tech./Technician", add 
label define label_cipcode4 510708 "51.0708 - Medical Transcription", add 
label define label_cipcode4 510799 "51.0799 - Health & Medical Admin. Services, Oth.", add 
label define label_cipcode4 510801 "51.0801 - Medical Assistant", add 
label define label_cipcode4 510802 "51.0802 - Medical Laboratory Assistant", add 
label define label_cipcode4 510805 "51.0805 - Pharmacy Technician/Assistant", add 
label define label_cipcode4 510806 "51.0806 - Physical Therapy Assistant", add 
label define label_cipcode4 510808 "51.0808 - Veterinarian Assistant/Animal Health Tec", add 
label define label_cipcode4 510899 "51.0899 - Health and Medical Assistants, Other", add 
label define label_cipcode4 510901 "51.0901 - Cardiovascular Tech./Technician", add 
label define label_cipcode4 510902 "51.0902 - Electrocardiograph Tech./Technician", add 
label define label_cipcode4 510904 "51.0904 - Emergency Medical Tech./Technician", add 
label define label_cipcode4 510905 "51.0905 - Nuclear Medical Tech./Technician", add 
label define label_cipcode4 510907 "51.0907 - Medical Radiologic Tech./Technician", add 
label define label_cipcode4 510908 "51.0908 - Respiratory Therapy Technician", add 
label define label_cipcode4 510909 "51.0909 - Surgical/Operating Room Technician", add 
label define label_cipcode4 510999 "51.0999 - Health & Med. Diagnostic & Treat Svc, Ot", add 
label define label_cipcode4 511004 "51.1004 - Medical Laboratory Technician", add 
label define label_cipcode4 511099 "51.1099 - Health & Medical Laboratory Tech., Oth.", add 
label define label_cipcode4 511501 "51.1501 - Alcohol/Drug Abuse Counseling", add 
label define label_cipcode4 511502 "51.1502 - Psychiatric/Mental Health Services Tech.", add 
label define label_cipcode4 511601 "51.1601 - Nursing (R.N. Training)", add 
label define label_cipcode4 511613 "51.1613 - Practical Nurse (L.P.N. Training)", add 
label define label_cipcode4 511614 "51.1614 - Nurse Assistant/Aide", add 
label define label_cipcode4 511615 "51.1615 - Home Health Aide", add 
label define label_cipcode4 511699 "51.1699 - Nursing, Other", add 
label define label_cipcode4 511801 "51.1801 - Opticianry/Dispensing Optician", add 
label define label_cipcode4 511802 "51.1802 - Optical Technician/Assistant", add 
label define label_cipcode4 511899 "51.1899 - Ophthalmic/Optometric Services, Other", add 
label define label_cipcode4 512303 "51.2303 - Hypnotherapy", add 
label define label_cipcode4 512309 "51.2309 - Recreational Therapy", add 
label define label_cipcode4 512399 "51.2399 - Rehabilitation/Therapeutic Services, Oth", add 
label define label_cipcode4 512701 "51.2701 - Acupuncture and Oriental Medicine", add 
label define label_cipcode4 519999 "51.9999 - Health Professions & Rel. Sciences, Oth.", add 
label define label_cipcode4 520101 "52.0101 - Business, General", add 
label define label_cipcode4 520201 "52.0201 - Business Administration & Mgmt., Gen.", add 
label define label_cipcode4 520204 "52.0204 - Office Supervision and Management", add 
label define label_cipcode4 520299 "52.0299 - Business Administration & Mgmt., Oth.", add 
label define label_cipcode4 520301 "52.0301 - Accounting", add 
label define label_cipcode4 520302 "52.0302 - Accounting Technician", add 
label define label_cipcode4 520399 "52.0399 - Accounting, Other", add 
label define label_cipcode4 520401 "52.0401 - Administrative Assistant/Secretarial Sci", add 
label define label_cipcode4 520402 "52.0402 - Executive Assistant/Secretary", add 
label define label_cipcode4 520403 "52.0403 - Legal Administrative Assistant/Secretary", add 
label define label_cipcode4 520404 "52.0404 - Medical Administrative Asst./Secretary", add 
label define label_cipcode4 520405 "52.0405 - Court Reporter", add 
label define label_cipcode4 520406 "52.0406 - Receptionist", add 
label define label_cipcode4 520407 "52.0407 - Information Processing/Data Entry Tech.", add 
label define label_cipcode4 520408 "52.0408 - General Office/Clerical & Typing Serv.", add 
label define label_cipcode4 520499 "52.0499 - Administrative & Secretarial Serv., Oth.", add 
label define label_cipcode4 520501 "52.0501 - Business Communications", add 
label define label_cipcode4 520803 "52.0803 - Banking and Financial Support Services", add 
label define label_cipcode4 520805 "52.0805 - Insurance and Risk Management", add 
label define label_cipcode4 520901 "52.0901 - Hospitality/Administration Management", add 
label define label_cipcode4 520902 "52.0902 - Hotel/Motel and Restaurant Management", add 
label define label_cipcode4 520903 "52.0903 - Travel-Tourism Management", add 
label define label_cipcode4 520999 "52.0999 - Hospitality Services Management, Other", add 
label define label_cipcode4 521201 "52.1201 - Mgmt. Info. Systems & Bus. Data Process", add 
label define label_cipcode4 521202 "52.1202 - Business Computer Programming/Programmer", add 
label define label_cipcode4 521204 "52.1204 - Business Systems Networking and Telecomm", add 
label define label_cipcode4 521205 "52.1205 - Business Computer Facilities Operator", add 
label define label_cipcode4 521299 "52.1299 - Business Information and Data Processing", add 
label define label_cipcode4 521499 "52.1499 - Marketing Management and Research, Other", add 
label define label_cipcode4 521501 "52.1501 - Real Estate", add 
label define label_cipcode4 529999 "52.9999 - Business Management & Admin. Serv., Oth.", add 
label values cipcode4 label_cipcode4
label define label_cipcode5 10101 "01.0101 - Agricultural Business and Mgmt., General" 
label define label_cipcode5 10204 "01.0204 - Agricultural Power Machinery Operator", add 
label define label_cipcode5 10507 "01.0507 - Eques./Equine Stds., Horse Mgmt. & Trgn.", add 
label define label_cipcode5 19999 "01.9999 - Agricultural Business & Production, Oth.", add 
label define label_cipcode5 30501 "03.0501 - Forestry, General", add 
label define label_cipcode5 30599 "03.0599 - Forestry and Related Sciences, Other", add 
label define label_cipcode5 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode5 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode5 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode5 80601 "08.0601 - Food Products Retail and Wholesale Opns.", add 
label define label_cipcode5 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode5 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode5 81199 "08.1199 - Tourism & Travel Serv. Market. Opns,Oth", add 
label define label_cipcode5 100199 "10.0199 - Communications Technol./Technicians, Oth", add 
label define label_cipcode5 110101 "11.0101 - Computer and Information Sciences, Gen.", add 
label define label_cipcode5 110201 "11.0201 - Computer Programming", add 
label define label_cipcode5 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode5 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode5 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode5 110701 "11.0701 - Computer Science", add 
label define label_cipcode5 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode5 120203 "12.0203 - Card Dealer", add 
label define label_cipcode5 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode5 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode5 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode5 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode5 120405 "12.0405 - Massage", add 
label define label_cipcode5 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode5 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode5 120502 "12.0502 - Bartender/Mixologist", add 
label define label_cipcode5 120503 "12.0503 - Culinary Arts/Chef Training", add 
label define label_cipcode5 120504 "12.0504 - Food & Beverage/Restaurant Opns. Manager", add 
label define label_cipcode5 120599 "12.0599 - Culinary Arts & Related Services, Other", add 
label define label_cipcode5 129999 "12.9999 - Personal & Miscellaneous Services, Other", add 
label define label_cipcode5 131202 "13.1202 - Elementary Teacher Education", add 
label define label_cipcode5 131299 "13.1299 - General Teacher Education, Other", add 
label define label_cipcode5 131324 "13.1324 - Drama and Dance Teacher Education", add 
label define label_cipcode5 140901 "14.0901 - Computer Engineering", add 
label define label_cipcode5 141001 "14.1001 - Electrical, Electronics & Communication", add 
label define label_cipcode5 142001 "14.2001 - Metallurgical Engineering", add 
label define label_cipcode5 149999 "14.9999 - Engineering, Other", add 
label define label_cipcode5 150101 "15.0101 - Architectural Engineering Techno/Tech", add 
label define label_cipcode5 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode5 150399 "15.0399 - Electrical & Electronic Engin.-Rel. Tech", add 
label define label_cipcode5 150402 "15.0402 - Computer Main. Tech./Technician", add 
label define label_cipcode5 150499 "15.0499 - Electromechanical Instrum. & Maint. Tech", add 
label define label_cipcode5 150501 "15.0501 - Heating, Air Condition. & Refrig. Tech.", add 
label define label_cipcode5 150506 "15.0506 - Water Quality/Wastewater Treatment Tech.", add 
label define label_cipcode5 150507 "15.0507 - Environmental & Pollution Control Tech.", add 
label define label_cipcode5 150599 "15.0599 - Environmental Control Tech, Oth.", add 
label define label_cipcode5 150603 "15.0603 - Industrial/Manufacturing Tech/Technician", add 
label define label_cipcode5 150805 "15.0805 - Mechanical Engineering/Mechanical Tech.", add 
label define label_cipcode5 151101 "15.1101 - Engineering-Related Tech/Technician, Gen", add 
label define label_cipcode5 160103 "16.0103 - Foreign Language Interpretation\Translat", add 
label define label_cipcode5 160302 "16.0302 - Japanese Language and Literature", add 
label define label_cipcode5 160501 "16.0501 - German Language and Literature", add 
label define label_cipcode5 190799 "19.0799 - Individual/Family Devel. Studies, Oth.", add 
label define label_cipcode5 200303 "20.0303 - Commercial Garment and Apparel Worker", add 
label define label_cipcode5 200401 "20.0401 - Institutional Food Workers & Admin, Gen", add 
label define label_cipcode5 200499 "20.0499 - Institutional Food Workers & Admin, Oth", add 
label define label_cipcode5 200501 "20.0501 - Home Furnishings and Equipment Installer", add 
label define label_cipcode5 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode5 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode5 260601 "26.0601 - Anatomy", add 
label define label_cipcode5 430102 "43.0102 - Corrections/Correctional Administration", add 
label define label_cipcode5 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode5 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode5 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode5 430203 "43.0203 - Fire Science/Firefighting", add 
label define label_cipcode5 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode5 460201 "46.0201 - Carpenter", add 
label define label_cipcode5 460302 "46.0302 - Electrician", add 
label define label_cipcode5 460303 "46.0303 - Lineworker", add 
label define label_cipcode5 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode5 460408 "46.0408 - Painter and Wall Coverer", add 
label define label_cipcode5 460499 "46.0499 - Const. & Bldg. Finishers & Managers, Oth", add 
label define label_cipcode5 460501 "46.0501 - Plumber and Pipefitter", add 
label define label_cipcode5 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode5 470101 "47.0101 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode5 470102 "47.0102 - Business Machine Repairer", add 
label define label_cipcode5 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode5 470105 "47.0105 - Indus. Electronics Installer & Repairer", add 
label define label_cipcode5 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode5 470199 "47.0199 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode5 470201 "47.0201 - Heating, Air Conditioning and Refrigerat", add 
label define label_cipcode5 470302 "47.0302 - Heavy Equipment Main. and Repairer", add 
label define label_cipcode5 470399 "47.0399 - Indus. Equip. Main. and Repairers, Oth.", add 
label define label_cipcode5 470402 "47.0402 - Gunsmith", add 
label define label_cipcode5 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode5 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode5 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode5 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode5 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode5 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode5 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode5 470609 "47.0609 - Aviation Systems and Avionics Main. Tech", add 
label define label_cipcode5 470611 "47.0611 - Motorcycle Mechanic and Repairer", add 
label define label_cipcode5 470699 "47.0699 - Vehicle & Mobile Equip. Mechanics & Repa", add 
label define label_cipcode5 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode5 480101 "48.0101 - Drafting, General", add 
label define label_cipcode5 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode5 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode5 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode5 480201 "48.0201 - Graphic & Printing Equip. Operator, Gen.", add 
label define label_cipcode5 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode5 480212 "48.0212 - Desktop Publishing Equipment Operator", add 
label define label_cipcode5 480303 "48.0303 - Upholsterer", add 
label define label_cipcode5 480501 "48.0501 - Machinist/Machine Technologist", add 
label define label_cipcode5 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode5 480507 "48.0507 - Tool and Die Maker/Technologist", add 
label define label_cipcode5 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode5 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode5 490102 "49.0102 - Aircraft Pilot & Navigator (Professional", add 
label define label_cipcode5 490104 "49.0104 - Aviation Management", add 
label define label_cipcode5 490105 "49.0105 - Air Traffic Controller", add 
label define label_cipcode5 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode5 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode5 490205 "49.0205 - Truck, Bus & Oth. Commercial Vehicle Op.", add 
label define label_cipcode5 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode5 490309 "49.0309 - Marine Science/Merchant Marine Officer", add 
label define label_cipcode5 499999 "49.9999 - Transportation and Materials Moving Work", add 
label define label_cipcode5 500401 "50.0401 - Design and Visual Communications", add 
label define label_cipcode5 500402 "50.0402 - Graphic Design, Commercial Art and Illus", add 
label define label_cipcode5 500407 "50.0407 - Fashion Design and Illustration", add 
label define label_cipcode5 500408 "50.0408 - Interior Design", add 
label define label_cipcode5 500499 "50.0499 - Design and Applied Arts, Other", add 
label define label_cipcode5 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode5 500605 "50.0605 - Photography", add 
label define label_cipcode5 500699 "50.0699 - Film/Video and Photographic Arts, Other", add 
label define label_cipcode5 500701 "50.0701 - Art, General", add 
label define label_cipcode5 500703 "50.0703 - Art History, Criticism and Conservation", add 
label define label_cipcode5 500713 "50.0713 - Metal and Jewelry Arts", add 
label define label_cipcode5 500903 "50.0903 - Music - General Performance", add 
label define label_cipcode5 500904 "50.0904 - Music Theory and Composition", add 
label define label_cipcode5 500909 "50.0909 - Music Business Management and Merchandis", add 
label define label_cipcode5 500999 "50.0999 - Music, Other", add 
label define label_cipcode5 509999 "50.9999 - Visual and Performing Arts, Other", add 
label define label_cipcode5 510401 "51.0401 - Dentistry (D.D.S., D.M.D.)", add 
label define label_cipcode5 510601 "51.0601 - Dental Assistant", add 
label define label_cipcode5 510603 "51.0603 - Dental Laboratory Technician", add 
label define label_cipcode5 510699 "51.0699 - Dental Services, Other", add 
label define label_cipcode5 510701 "51.0701 - Health System/Health Services Admin.", add 
label define label_cipcode5 510703 "51.0703 - Health Unit Coordinator/Ward Clerk", add 
label define label_cipcode5 510705 "51.0705 - Medical Office Management", add 
label define label_cipcode5 510706 "51.0706 - Medical Records Administration", add 
label define label_cipcode5 510707 "51.0707 - Medical Records Tech./Technician", add 
label define label_cipcode5 510708 "51.0708 - Medical Transcription", add 
label define label_cipcode5 510799 "51.0799 - Health & Medical Admin. Services, Oth.", add 
label define label_cipcode5 510801 "51.0801 - Medical Assistant", add 
label define label_cipcode5 510802 "51.0802 - Medical Laboratory Assistant", add 
label define label_cipcode5 510804 "51.0804 - Ophthalmic Medical Assistant", add 
label define label_cipcode5 510805 "51.0805 - Pharmacy Technician/Assistant", add 
label define label_cipcode5 510806 "51.0806 - Physical Therapy Assistant", add 
label define label_cipcode5 510808 "51.0808 - Veterinarian Assistant/Animal Health Tec", add 
label define label_cipcode5 510899 "51.0899 - Health and Medical Assistants, Other", add 
label define label_cipcode5 510902 "51.0902 - Electrocardiograph Tech./Technician", add 
label define label_cipcode5 510903 "51.0903 - Electroencephalograph Tech./Technician", add 
label define label_cipcode5 510904 "51.0904 - Emergency Medical Tech./Technician", add 
label define label_cipcode5 510907 "51.0907 - Medical Radiologic Tech./Technician", add 
label define label_cipcode5 510908 "51.0908 - Respiratory Therapy Technician", add 
label define label_cipcode5 510909 "51.0909 - Surgical/Operating Room Technician", add 
label define label_cipcode5 510910 "51.0910 - Diagnostic Medical Sonography", add 
label define label_cipcode5 510999 "51.0999 - Health & Med. Diagnostic & Treat Svc, Ot", add 
label define label_cipcode5 511004 "51.1004 - Medical Laboratory Technician", add 
label define label_cipcode5 511005 "51.1005 - Medical Technology", add 
label define label_cipcode5 511099 "51.1099 - Health & Medical Laboratory Tech., Oth.", add 
label define label_cipcode5 511501 "51.1501 - Alcohol/Drug Abuse Counseling", add 
label define label_cipcode5 511502 "51.1502 - Psychiatric/Mental Health Services Tech.", add 
label define label_cipcode5 511613 "51.1613 - Practical Nurse (L.P.N. Training)", add 
label define label_cipcode5 511614 "51.1614 - Nurse Assistant/Aide", add 
label define label_cipcode5 511699 "51.1699 - Nursing, Other", add 
label define label_cipcode5 512099 "51.2099 - Pharmacy, Other", add 
label define label_cipcode5 512303 "51.2303 - Hypnotherapy", add 
label define label_cipcode5 512399 "51.2399 - Rehabilitation/Therapeutic Services, Oth", add 
label define label_cipcode5 512601 "51.2601 - Health Aide", add 
label define label_cipcode5 519999 "51.9999 - Health Professions & Rel. Sciences, Oth.", add 
label define label_cipcode5 520101 "52.0101 - Business, General", add 
label define label_cipcode5 520201 "52.0201 - Business Administration & Mgmt., Gen.", add 
label define label_cipcode5 520204 "52.0204 - Office Supervision and Management", add 
label define label_cipcode5 520205 "52.0205 - Operations Management and Supervision", add 
label define label_cipcode5 520299 "52.0299 - Business Administration & Mgmt., Oth.", add 
label define label_cipcode5 520301 "52.0301 - Accounting", add 
label define label_cipcode5 520302 "52.0302 - Accounting Technician", add 
label define label_cipcode5 520399 "52.0399 - Accounting, Other", add 
label define label_cipcode5 520401 "52.0401 - Administrative Assistant/Secretarial Sci", add 
label define label_cipcode5 520402 "52.0402 - Executive Assistant/Secretary", add 
label define label_cipcode5 520403 "52.0403 - Legal Administrative Assistant/Secretary", add 
label define label_cipcode5 520404 "52.0404 - Medical Administrative Asst./Secretary", add 
label define label_cipcode5 520405 "52.0405 - Court Reporter", add 
label define label_cipcode5 520406 "52.0406 - Receptionist", add 
label define label_cipcode5 520407 "52.0407 - Information Processing/Data Entry Tech.", add 
label define label_cipcode5 520408 "52.0408 - General Office/Clerical & Typing Serv.", add 
label define label_cipcode5 520499 "52.0499 - Administrative & Secretarial Serv., Oth.", add 
label define label_cipcode5 520803 "52.0803 - Banking and Financial Support Services", add 
label define label_cipcode5 520805 "52.0805 - Insurance and Risk Management", add 
label define label_cipcode5 520901 "52.0901 - Hospitality/Administration Management", add 
label define label_cipcode5 520902 "52.0902 - Hotel/Motel and Restaurant Management", add 
label define label_cipcode5 520903 "52.0903 - Travel-Tourism Management", add 
label define label_cipcode5 520999 "52.0999 - Hospitality Services Management, Other", add 
label define label_cipcode5 521201 "52.1201 - Mgmt. Info. Systems & Bus. Data Process", add 
label define label_cipcode5 521202 "52.1202 - Business Computer Programming/Programmer", add 
label define label_cipcode5 521203 "52.1203 - Business Systems Analysis and Design", add 
label define label_cipcode5 521204 "52.1204 - Business Systems Networking and Telecomm", add 
label define label_cipcode5 521205 "52.1205 - Business Computer Facilities Operator", add 
label define label_cipcode5 521299 "52.1299 - Business Information and Data Processing", add 
label define label_cipcode5 521501 "52.1501 - Real Estate", add 
label define label_cipcode5 521601 "52.1601 - Taxation", add 
label define label_cipcode5 529999 "52.9999 - Business Management & Admin. Serv., Oth.", add 
label values cipcode5 label_cipcode5
label define label_cipcode6 10507 "01.0507 - Eques./Equine Stds., Horse Mgmt. & Trgn." 
label define label_cipcode6 19999 "01.9999 - Agricultural Business & Production, Oth.", add 
label define label_cipcode6 30599 "03.0599 - Forestry and Related Sciences, Other", add 
label define label_cipcode6 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode6 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode6 80706 "08.0706 - General Selling Skills and Sales Opns.", add 
label define label_cipcode6 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode6 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode6 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode6 81199 "08.1199 - Tourism & Travel Serv. Market. Opns,Oth", add 
label define label_cipcode6 90201 "09.0201 - Advertising", add 
label define label_cipcode6 100104 "10.0104 - Radio and Television Broadcasting Tech.", add 
label define label_cipcode6 110101 "11.0101 - Computer and Information Sciences, Gen.", add 
label define label_cipcode6 110201 "11.0201 - Computer Programming", add 
label define label_cipcode6 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode6 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode6 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode6 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode6 120203 "12.0203 - Card Dealer", add 
label define label_cipcode6 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode6 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode6 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode6 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode6 120405 "12.0405 - Massage", add 
label define label_cipcode6 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode6 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode6 120503 "12.0503 - Culinary Arts/Chef Training", add 
label define label_cipcode6 129999 "12.9999 - Personal & Miscellaneous Services, Other", add 
label define label_cipcode6 131319 "13.1319 - Technical Teacher Education (Vocational)", add 
label define label_cipcode6 150101 "15.0101 - Architectural Engineering Techno/Tech", add 
label define label_cipcode6 150303 "15.0303 - Elec., Electronic & Comm. Engin. Tech.", add 
label define label_cipcode6 150399 "15.0399 - Electrical & Electronic Engin.-Rel. Tech", add 
label define label_cipcode6 150402 "15.0402 - Computer Main. Tech./Technician", add 
label define label_cipcode6 150501 "15.0501 - Heating, Air Condition. & Refrig. Tech.", add 
label define label_cipcode6 150507 "15.0507 - Environmental & Pollution Control Tech.", add 
label define label_cipcode6 150599 "15.0599 - Environmental Control Tech, Oth.", add 
label define label_cipcode6 150699 "15.0699 - Industrial Product. Technol./Techn, Oth.", add 
label define label_cipcode6 150701 "15.0701 - Occupational Safety & Health Tech./Techn", add 
label define label_cipcode6 150805 "15.0805 - Mechanical Engineering/Mechanical Tech.", add 
label define label_cipcode6 151001 "15.1001 - Construction/Building Tech./Technician", add 
label define label_cipcode6 159999 "15.9999 - Engineering-Related Technol./Techn, Oth.", add 
label define label_cipcode6 160302 "16.0302 - Japanese Language and Literature", add 
label define label_cipcode6 160501 "16.0501 - German Language and Literature", add 
label define label_cipcode6 190799 "19.0799 - Individual/Family Devel. Studies, Oth.", add 
label define label_cipcode6 190901 "19.0901 - Clothing/Apparel and Textile Studies", add 
label define label_cipcode6 200201 "20.0201 - Child Care/Guidance Workers & Manager, G", add 
label define label_cipcode6 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode6 200299 "20.0299 - Child Care/Guidance Workers & Manager, O", add 
label define label_cipcode6 200301 "20.0301 - Clothing, Apparel & Textile Workers & Ma", add 
label define label_cipcode6 200303 "20.0303 - Commercial Garment and Apparel Worker", add 
label define label_cipcode6 200409 "20.0409 - Institutional Food Services Admin.", add 
label define label_cipcode6 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode6 230101 "23.0101 - English Language and Literature, General", add 
label define label_cipcode6 260704 "26.0704 - Pathology, Human and Animal", add 
label define label_cipcode6 390701 "39.0701 - Pastoral Counseling & Specialized Minist", add 
label define label_cipcode6 400699 "40.0699 - Geological and Related Sciences, Other", add 
label define label_cipcode6 420101 "42.0101 - Psychology, General", add 
label define label_cipcode6 430104 "43.0104 - Criminal Justice Studies", add 
label define label_cipcode6 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode6 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode6 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode6 460101 "46.0101 - Mason and Tile Setter", add 
label define label_cipcode6 460201 "46.0201 - Carpenter", add 
label define label_cipcode6 460302 "46.0302 - Electrician", add 
label define label_cipcode6 460399 "46.0399 - Elec. & Power Trans. Installer, Oth.", add 
label define label_cipcode6 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode6 460403 "46.0403 - Construction/Building Inspector", add 
label define label_cipcode6 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode6 470101 "47.0101 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode6 470103 "47.0103 - Communication Sys. Installer & Repairer", add 
label define label_cipcode6 470105 "47.0105 - Indus. Electronics Installer & Repairer", add 
label define label_cipcode6 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode6 470199 "47.0199 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode6 470201 "47.0201 - Heating, Air Conditioning and Refrigerat", add 
label define label_cipcode6 470303 "47.0303 - Industrial Machinery Main. and Repairer", add 
label define label_cipcode6 470399 "47.0399 - Indus. Equip. Main. and Repairers, Oth.", add 
label define label_cipcode6 470402 "47.0402 - Gunsmith", add 
label define label_cipcode6 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode6 470501 "47.0501 - Stationary Energy Sources Installer/Oper", add 
label define label_cipcode6 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode6 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode6 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode6 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode6 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode6 470611 "47.0611 - Motorcycle Mechanic and Repairer", add 
label define label_cipcode6 470699 "47.0699 - Vehicle & Mobile Equip. Mechanics & Repa", add 
label define label_cipcode6 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode6 480101 "48.0101 - Drafting, General", add 
label define label_cipcode6 480104 "48.0104 - Electrical/Electronics Drafting", add 
label define label_cipcode6 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode6 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode6 480201 "48.0201 - Graphic & Printing Equip. Operator, Gen.", add 
label define label_cipcode6 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode6 480212 "48.0212 - Desktop Publishing Equipment Operator", add 
label define label_cipcode6 480501 "48.0501 - Machinist/Machine Technologist", add 
label define label_cipcode6 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode6 480507 "48.0507 - Tool and Die Maker/Technologist", add 
label define label_cipcode6 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode6 489999 "48.9999 - Precision Production Trades, Other", add 
label define label_cipcode6 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode6 490102 "49.0102 - Aircraft Pilot & Navigator (Professional", add 
label define label_cipcode6 490106 "49.0106 - Flight Attendant", add 
label define label_cipcode6 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode6 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode6 490205 "49.0205 - Truck, Bus & Oth. Commercial Vehicle Op.", add 
label define label_cipcode6 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode6 490306 "49.0306 - Marine Main. and Ship Repairer", add 
label define label_cipcode6 490309 "49.0309 - Marine Science/Merchant Marine Officer", add 
label define label_cipcode6 499999 "49.9999 - Transportation and Materials Moving Work", add 
label define label_cipcode6 500402 "50.0402 - Graphic Design, Commercial Art and Illus", add 
label define label_cipcode6 500407 "50.0407 - Fashion Design and Illustration", add 
label define label_cipcode6 500408 "50.0408 - Interior Design", add 
label define label_cipcode6 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode6 500605 "50.0605 - Photography", add 
label define label_cipcode6 500713 "50.0713 - Metal and Jewelry Arts", add 
label define label_cipcode6 500799 "50.0799 - Fine Arts and Art Studies, Other", add 
label define label_cipcode6 500999 "50.0999 - Music, Other", add 
label define label_cipcode6 510601 "51.0601 - Dental Assistant", add 
label define label_cipcode6 510705 "51.0705 - Medical Office Management", add 
label define label_cipcode6 510706 "51.0706 - Medical Records Administration", add 
label define label_cipcode6 510707 "51.0707 - Medical Records Tech./Technician", add 
label define label_cipcode6 510708 "51.0708 - Medical Transcription", add 
label define label_cipcode6 510799 "51.0799 - Health & Medical Admin. Services, Oth.", add 
label define label_cipcode6 510801 "51.0801 - Medical Assistant", add 
label define label_cipcode6 510803 "51.0803 - Occupational Therapy Assistant", add 
label define label_cipcode6 510805 "51.0805 - Pharmacy Technician/Assistant", add 
label define label_cipcode6 510806 "51.0806 - Physical Therapy Assistant", add 
label define label_cipcode6 510807 "51.0807 - Physician Assistant", add 
label define label_cipcode6 510808 "51.0808 - Veterinarian Assistant/Animal Health Tec", add 
label define label_cipcode6 510899 "51.0899 - Health and Medical Assistants, Other", add 
label define label_cipcode6 510901 "51.0901 - Cardiovascular Tech./Technician", add 
label define label_cipcode6 510902 "51.0902 - Electrocardiograph Tech./Technician", add 
label define label_cipcode6 510904 "51.0904 - Emergency Medical Tech./Technician", add 
label define label_cipcode6 510907 "51.0907 - Medical Radiologic Tech./Technician", add 
label define label_cipcode6 510908 "51.0908 - Respiratory Therapy Technician", add 
label define label_cipcode6 510909 "51.0909 - Surgical/Operating Room Technician", add 
label define label_cipcode6 510999 "51.0999 - Health & Med. Diagnostic & Treat Svc, Ot", add 
label define label_cipcode6 511004 "51.1004 - Medical Laboratory Technician", add 
label define label_cipcode6 511099 "51.1099 - Health & Medical Laboratory Tech., Oth.", add 
label define label_cipcode6 511502 "51.1502 - Psychiatric/Mental Health Services Tech.", add 
label define label_cipcode6 511601 "51.1601 - Nursing (R.N. Training)", add 
label define label_cipcode6 511613 "51.1613 - Practical Nurse (L.P.N. Training)", add 
label define label_cipcode6 511614 "51.1614 - Nurse Assistant/Aide", add 
label define label_cipcode6 511699 "51.1699 - Nursing, Other", add 
label define label_cipcode6 512303 "51.2303 - Hypnotherapy", add 
label define label_cipcode6 512309 "51.2309 - Recreational Therapy", add 
label define label_cipcode6 512399 "51.2399 - Rehabilitation/Therapeutic Services, Oth", add 
label define label_cipcode6 512702 "51.2702 - Medical Dietician", add 
label define label_cipcode6 519999 "51.9999 - Health Professions & Rel. Sciences, Oth.", add 
label define label_cipcode6 520101 "52.0101 - Business, General", add 
label define label_cipcode6 520201 "52.0201 - Business Administration & Mgmt., Gen.", add 
label define label_cipcode6 520299 "52.0299 - Business Administration & Mgmt., Oth.", add 
label define label_cipcode6 520301 "52.0301 - Accounting", add 
label define label_cipcode6 520302 "52.0302 - Accounting Technician", add 
label define label_cipcode6 520399 "52.0399 - Accounting, Other", add 
label define label_cipcode6 520401 "52.0401 - Administrative Assistant/Secretarial Sci", add 
label define label_cipcode6 520402 "52.0402 - Executive Assistant/Secretary", add 
label define label_cipcode6 520403 "52.0403 - Legal Administrative Assistant/Secretary", add 
label define label_cipcode6 520404 "52.0404 - Medical Administrative Asst./Secretary", add 
label define label_cipcode6 520405 "52.0405 - Court Reporter", add 
label define label_cipcode6 520406 "52.0406 - Receptionist", add 
label define label_cipcode6 520407 "52.0407 - Information Processing/Data Entry Tech.", add 
label define label_cipcode6 520408 "52.0408 - General Office/Clerical & Typing Serv.", add 
label define label_cipcode6 520499 "52.0499 - Administrative & Secretarial Serv., Oth.", add 
label define label_cipcode6 520803 "52.0803 - Banking and Financial Support Services", add 
label define label_cipcode6 520807 "52.0807 - Investments and Securities", add 
label define label_cipcode6 520899 "52.0899 - Financial Management and Services, Other", add 
label define label_cipcode6 520901 "52.0901 - Hospitality/Administration Management", add 
label define label_cipcode6 520902 "52.0902 - Hotel/Motel and Restaurant Management", add 
label define label_cipcode6 520903 "52.0903 - Travel-Tourism Management", add 
label define label_cipcode6 521201 "52.1201 - Mgmt. Info. Systems & Bus. Data Process", add 
label define label_cipcode6 521202 "52.1202 - Business Computer Programming/Programmer", add 
label define label_cipcode6 521203 "52.1203 - Business Systems Analysis and Design", add 
label define label_cipcode6 521205 "52.1205 - Business Computer Facilities Operator", add 
label define label_cipcode6 521299 "52.1299 - Business Information and Data Processing", add 
label define label_cipcode6 521301 "52.1301 - Management Science", add 
label define label_cipcode6 521501 "52.1501 - Real Estate", add 
label define label_cipcode6 529999 "52.9999 - Business Management & Admin. Serv., Oth.", add 
label values cipcode6 label_cipcode6
label define label_finaid1 -1 "No Response/Missing" 
label define label_finaid1 1 "Yes", add 
label values finaid1 label_finaid1
label define label_finaid2 -1 "No Response/Missing" 
label define label_finaid2 1 "Yes", add 
label values finaid2 label_finaid2
label define label_finaid3 -1 "No Response/Missing" 
label define label_finaid3 1 "Yes", add 
label values finaid3 label_finaid3
label define label_finaid4 -1 "No Response/Missing" 
label define label_finaid4 1 "Yes", add 
label values finaid4 label_finaid4
label define label_finaid5 -1 "No Response/Missing" 
label define label_finaid5 1 "Yes", add 
label values finaid5 label_finaid5
label define label_finaid6 -1 "No Response/Missing" 
label define label_finaid6 1 "Yes", add 
label values finaid6 label_finaid6
label define label_finaid7 -1 "No Response/Missing" 
label define label_finaid7 1 "Yes", add 
label values finaid7 label_finaid7
label define label_finaid8 -1 "No Response/Missing" 
label define label_finaid8 1 "Yes", add 
label values finaid8 label_finaid8
label define label_finaid9 -1 "No Response/Missing" 
label define label_finaid9 1 "Yes", add 
label values finaid9 label_finaid9
label define label_jtpa -1 "No Response/Missing" 
label define label_jtpa 1 "Yes", add 
label define label_jtpa 2 "No", add 
label define label_jtpa 3 "Dont know", add 
label values jtpa label_jtpa
label define label_rotc -1 "No Response/Missing" 
label define label_rotc 1 "Yes", add 
label define label_rotc 2 "No", add 
label values rotc label_rotc
label define label_rotc1 -1 "No Response/Missing" 
label define label_rotc1 1 "Yes", add 
label values rotc1 label_rotc1
label define label_rotc2 -1 "No Response/Missing" 
label define label_rotc2 1 "Yes", add 
label values rotc2 label_rotc2
label define label_rotc3 -1 "No Response/Missing" 
label define label_rotc3 1 "Yes", add 
label values rotc3 label_rotc3
label define label_ftslt15 -1 "No Response/Missing" 
label define label_ftslt15 1 "Less than 15", add 
label define label_ftslt15 2 "15 or more", add 
label values ftslt15 label_ftslt15
label define label_facpt -1 "No Response/Missing" 
label define label_facpt 1 "Yes", add 
label define label_facpt 2 "No", add 
label values facpt label_facpt
label define label_facml -1 "No Response/Missing" 
label define label_facml 1 "Yes", add 
label define label_facml 2 "No", add 
label values facml label_facml
label define label_facrl -1 "No Response/Missing" 
label define label_facrl 1 "Yes", add 
label define label_facrl 2 "No", add 
label values facrl label_facrl
label define label_facmd -1 "No Response/Missing" 
label define label_facmd 1 "Yes", add 
label define label_facmd 2 "No", add 
label values facmd label_facmd
label define label_licensed -1 "No Response/Missing" 
label define label_licensed 1 "Yes", add 
label define label_licensed 2 "No", add 
label values licensed label_licensed
tab yrscol
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
tab ftstu
tab apfee
tab noftug
tab chgper1
tab chgper2
tab chgper3
tab chgper4
tab chgper5
tab tuition4
tab tuition8
tab profna
tab room
tab board
tab mealsvry
tab roombord
tab pg300
tab cipcode1
tab cipcode2
tab cipcode3
tab cipcode4
tab cipcode5
tab cipcode6
tab finaid1
tab finaid2
tab finaid3
tab finaid4
tab finaid5
tab finaid6
tab finaid7
tab finaid8
tab finaid9
tab jtpa
tab rotc
tab rotc1
tab rotc2
tab rotc3
tab ftslt15
tab facpt
tab facml
tab facrl
tab facmd
tab licensed
summarize libshar1
summarize libshar2
summarize libshar3
summarize applfeeu
summarize applfeeg
summarize applfeep
summarize tuition1
summarize tuition2
summarize tuition3
summarize tpugcred
summarize tpugcont
summarize tuition5
summarize tuition6
summarize tuition7
summarize tpgdcred
summarize isprof1
summarize osprof1
summarize isprof2
summarize osprof2
summarize isprof3
summarize osprof3
summarize isprof4
summarize osprof4
summarize isprof5
summarize osprof5
summarize isprof6
summarize osprof6
summarize isprof7
summarize osprof7
summarize isprof8
summarize osprof8
summarize isprof9
summarize osprof9
summarize isprof10
summarize osprof10
summarize isprof11
summarize osprof11
summarize tpfpcred
summarize roomcap
summarize mealswk
summarize roomamt
summarize boardamt
summarize rmbrdamt
summarize prgmoffr
summarize ciptuit1
summarize cipsupp1
summarize ciplgth1
summarize cipenrl1
summarize cipcomp1
summarize ciptuit2
summarize cipsupp2
summarize ciplgth2
summarize cipenrl2
summarize cipcomp2
summarize ciptuit3
summarize cipsupp3
summarize ciplgth3
summarize cipenrl3
summarize cipcomp3
summarize ciptuit4
summarize cipsupp4
summarize ciplgth4
summarize cipenrl4
summarize cipcomp4
summarize ciptuit5
summarize cipsupp5
summarize ciplgth5
summarize cipenrl5
summarize cipcomp5
summarize ciptuit6
summarize cipsupp6
summarize ciplgth6
summarize cipenrl6
summarize cipcomp6
summarize enrolmnt
summarize genenrl
summarize month
summarize tostucu
summarize tostufrs
summarize tostutrn
summarize tostucg
summarize tostucp
summarize pctpost
save dct_ic9596_b

