* Created: 6/13/2004 7:40:53 AM
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
insheet using "../Raw Data/ic1987_b_data_stata.csv", comma clear
label data "dct_ic1987_b"
label variable unitid "unitid"
label variable calsys "Calendar system"
label variable crsloc1 "Credit, in-state"
label variable crsloc2 "Credit, out-of-state"
label variable crsloc3 "Credit, abroad"
label variable crsloc4 "Noncredit, in-state"
label variable crsloc5 "Noncredit, out-of-state"
label variable crsloc6 "Noncredit, abroad"
label variable facloc1 "Credit, on-campus"
label variable facloc2 "Credit, correctional facility"
label variable facloc3 "Credit, local education agency facility"
label variable facloc4 "Credit, other government facility"
label variable facloc6 "Credit, other"
label variable facloc7 "Noncredit, on-campus"
label variable facloc8 "Noncredit, correctional facility"
label variable facloc9 "Noncredit, local education agency facility"
label variable facloc10 "Noncredit, other government facility"
label variable facloc12 "Noncredit, other"
label variable mili "Courses are offered at military installations"
label variable mil1insl "Course offered - military instal-states/territories"
label variable mil2insl "Course offered - military instal-abroad"
label variable admreq1 "High school diploma or equivalent"
label variable admreq2 "High school class standing"
label variable admreq3 "Admissions test scores (general)"
label variable admreq4 "SAT test score"
label variable admreq5 "ACT test score"
label variable admreq6 "Other test score"
label variable admreq7 "Residence"
label variable admreq8 "Evidence of ability to benefit from instruction"
label variable admreq9 "Age"
label variable admreq10 "Test of English as a Foreign Language (TOEFL)"
label variable admreq11 "Open admission"
label variable avgperc "Average high school percentile rank"
label variable uwwou "University without walls/open university"
label variable mode1 "Credit, work in a program-related setting with pay"
label variable mode2 "Credit, work in a program-related setting without pay"
label variable mode3 "Credit, home study (general)"
label variable mode4 "Credit, home study, correspondence"
label variable mode5 "Credit, home study, radio and TV"
label variable mode6 "Credit, home study, newspaper"
label variable mode7 "Credit, none of the above"
label variable mode8 "Noncredit, work in a program-related setting with pay"
label variable mode9 "Noncredit, work in a program-related setting without pay"
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
label variable stusrv9 "None of the above services"
label variable aslib1 "Administratively separate library - law"
label variable aslib2 "Administratively separate library - medicine"
label variable aslib3 "Administratively separate library - other"
label variable ftstu "Full-time students are enrolled"
label variable apfee "Application fee is required"
label variable applfeeu "Undergraduate application fee in whole dollars"
label variable applfeeg "Graduate application fee in whole dollars"
label variable tfdu "Different tuition and required fee charges for different undergraduate levels"
label variable tfdi "Different tuition and required fee charges for different undergraduate instructional programs"
label variable ffind "Flat fee is charged"
label variable ffamt "Flat fee amount in whole dollars"
label variable ffper "Basis for flat fee charge"
label variable ffmin "Minimum hours covered by flat fee"
label variable ffmax "Maximum hours covered by flat fee"
label variable phind "Per hour amount is charged"
label variable phamt "Per hour charge in whole dollars"
label variable phper "Basis for per hour charge"
label variable noftug "No full-time undergraduate students enrolled"
label variable cghper "How do you charge for full-time students"
label variable tuition1 "Tuition and fees full-time undergraduate, in-district"
label variable tuition2 "Tuition and fees full-time undergraduate, in-state"
label variable tuition3 "Tuition and fees full-time undergraduate, out-of-state"
label variable tuition4 "No full-time undergraduate students"
label variable tuition5 "Tuition and fees full-time graduate, in-district"
label variable tuition6 "Tuition and fees full-time graduate, in-state"
label variable tuition7 "Tuition and fees full-time graduate, out-of-state"
label variable prof1 "Tuition and fees full-time first-professional, Chiropractic"
label variable prof2 "Tuition and fees full-time first-professional, Dentistry"
label variable prof3 "Tuition and fees full-time first-professional, Medicine"
label variable prof4 "Tuition and fees full-time first-professional, Optometry"
label variable prof5 "Tuition and fees full-time first-professional, Osteopathic Medicine"
label variable prof6 "Tuition and fees full-time first-professional, Pharmacy"
label variable prof7 "Tuition and fees full-time first-professional, Podiatry"
label variable prof8 "Tuition and fees full-time first-professional, Veterinary Medicine"
label variable prof9 "Tuition and fees full-time first-professional, Law"
label variable prof10 "Tuition and fees full-time first-professional, Theology"
label variable prof11 "Tuition and fees full-time first-professional, Other"
label variable profoth "Other, specified"
label variable profna "No full-time first-professional students"
label variable room "Institution provides dormitory facilities"
label variable roomamt "Typical room charge for academic year"
label variable roomcap "Total dormitory capacity during academic year"
label variable board "Institution provides board or meal plans"
label variable boardamt "Typical board charge for academic year"
label variable mealswk "Number of meals per week included in board charge"
label variable avgamt1 "Average books/supplieds cost Books and supplies"
label variable avgamt2 "Average transpotation cost Books and supplies"
label variable avgamt3 "Average room and board cost (non-dorm) Books and supplies"
label variable avgamt4 "Average miscellaneous expenses Books and supplies"
label variable finaid1 "Veterans Administration Educational Benefits (VA)"
label variable finaid2 "Pell Grants"
label variable finaid3 "Supplementary Education Opportunity Grants (SEOG)"
label variable finaid4 "Stafford Loans"
label variable finaid5 "College Work Study Program (CWS)"
label variable finaid6 "National Direct Student Loan (NDSL)"
label variable finaid7 "Higher Education Assistance Loan (HEAL)"
label variable finaid8 "Other federal student financial aid programs"
label variable jtpa "Job Training Partnership Act (JTPA)"
label variable rotc "Reserve Officers Training Corps (ROTC)"
label variable rotc1 "Army"
label variable rotc2 "Navy"
label variable rotc3 "Air Force"
label variable ftslt15 "Size of full-time staff"
label variable facpt "All instructional faculty are part-time"
label variable facml "All instructional faculty are military"
label variable facmd "All instructional faculty teach medicine"
label variable enrolmnt "Corrected fall enrollment count"
label variable prgmoffr "Number of programs offered"
label variable pg600 "Have programs greater then 600 contact hours"
label variable cipcode1 "1st CIP code"
label variable ciptuit1 "1st tuition and fees"
label variable ciplgth1 "1st total length of program in contact hours"
label variable cipenrl1 "1st current or most recent enrollment"
label variable cipcode2 "2nd CIP code"
label variable ciptuit2 "2nd tuition and fees (in-state charges)"
label variable ciplgth2 "2nd total length of program in contact hours"
label variable cipenrl2 "2nd current or most recent enrollment"
label variable cipcode3 "3rd CIP code"
label variable ciptuit3 "3rd tuition and fees (in-state charges)"
label variable ciplgth3 "3rd total length of program in contact hours"
label variable cipenrl3 "3rd current or most recent enrollment"
label variable libfac "Library facilities at institution"
label define label_calsys 1 "Semester" 
label define label_calsys 2 "Quarter", add 
label define label_calsys 3 "Trimester", add 
label define label_calsys 4 "Four-One-Four Plan (4-1-4)", add 
label define label_calsys 5 "Differs by program", add 
label define label_calsys 6 "Continuous basis", add 
label values calsys label_calsys
label define label_mili 1 "Yes" 
label define label_mili 2 "No", add 
label values mili label_mili
label define label_uwwou 1 "Yes" 
label define label_uwwou 2 "No", add 
label values uwwou label_uwwou
label define label_ftstu 1 "Yes" 
label define label_ftstu 2 "No", add 
label values ftstu label_ftstu
label define label_apfee 1 "Yes" 
label define label_apfee 2 "No", add 
label values apfee label_apfee
label define label_tfdu 1 "Yes" 
label define label_tfdu 2 "No", add 
label values tfdu label_tfdu
label define label_tfdi 1 "Yes" 
label define label_tfdi 2 "No", add 
label values tfdi label_tfdi
label define label_ffper 1 "Per semester" 
label define label_ffper 2 "Per quarter", add 
label define label_ffper 3 "Per program", add 
label define label_ffper 4 "Per year", add 
label define label_ffper 5 "Per trimester", add 
label define label_ffper 6 "Other", add 
label values ffper label_ffper
label define label_phper 1 "Per semester" 
label define label_phper 2 "Per quarter credit hour", add 
label define label_phper 3 "Per contact hour", add 
label define label_phper 4 "Per trimester hour", add 
label define label_phper 5 "Other", add 
label values phper label_phper
label define label_cghper 1 "By credit/contact hour" 
label define label_cghper 2 "By program", add 
label define label_cghper 3 "By term", add 
label define label_cghper 4 "By year", add 
label define label_cghper 5 "Other", add 
label values cghper label_cghper
label define label_room 1 "Yes" 
label define label_room 2 "No", add 
label values room label_room
label define label_board 1 "Yes" 
label define label_board 2 "No", add 
label values board label_board
label define label_jtpa 1 "Yes" 
label define label_jtpa 2 "No", add 
label define label_jtpa 3 "Dont know", add 
label values jtpa label_jtpa
label define label_rotc 1 "Yes" 
label define label_rotc 2 "No", add 
label values rotc label_rotc
label define label_ftslt15 1 "Less than 15" 
label define label_ftslt15 2 "15 or more", add 
label values ftslt15 label_ftslt15
label define label_facpt 1 "Yes" 
label define label_facpt 2 "No", add 
label values facpt label_facpt
label define label_facml 1 "Yes" 
label define label_facml 2 "No", add 
label values facml label_facml
label define label_facmd 1 "Yes" 
label define label_facmd 2 "No", add 
label values facmd label_facmd
label define label_pg600 1 "Yes" 
label define label_pg600 2 "No", add 
label values pg600 label_pg600
label define label_cipcode1 10101 "01.0101 - Agricultural Business and Management, General" 
label define label_cipcode1 10103 "01.0103 - Agricultural Economics", add 
label define label_cipcode1 10301 "01.0301 - Agricultural Production Workers and Managers, General", add 
label define label_cipcode1 10504 "01.0504 - Pet Grooming", add 
label define label_cipcode1 10505 "01.0505 - Animal Trainer", add 
label define label_cipcode1 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode1 10507 "01.0507 - Equestrian/Equine Studies, Horse Management and Training", add 
label define label_cipcode1 10604 "01.0604 - Greenhouse Operations and Management", add 
label define label_cipcode1 10605 "01.0605 - Landscaping Operations and Management", add 
label define label_cipcode1 20299 "02.0299 - Animal Sciences, Other", add 
label define label_cipcode1 20403 "02.0403 - Horticulture Science", add 
label define label_cipcode1 30601 "03.0601 - Wildlife and Wildlands Management", add 
label define label_cipcode1 40501 "04.0501 - Interior Architecture", add 
label define label_cipcode1 50199 "05.0199 - Area Studies, Other", add 
label define label_cipcode1 60101 "06.0101 - Business and Management, General", add 
label define label_cipcode1 60201 "06.0201 - Accounting", add 
label define label_cipcode1 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode1 60401 "06.0401 - Business Admin. and Management, General", add 
label define label_cipcode1 60402 "06.0402 - Contract Management and Procure/Purchasing", add 
label define label_cipcode1 60499 "06.0499 - Business Admin. and Management, Other", add 
label define label_cipcode1 60701 "06.0701 - Hotel/Motel Management", add 
label define label_cipcode1 60702 "06.0702 - Recreational Enterprises Management", add 
label define label_cipcode1 60704 "06.0704 - Restaurant Management", add 
label define label_cipcode1 60801 "06.0801 - Insurance and Risk Management", add 
label define label_cipcode1 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode1 61401 "06.1401 - Marketing Management", add 
label define label_cipcode1 61601 "06.1601 - Personnel Management", add 
label define label_cipcode1 61701 "06.1701 - Real Estate", add 
label define label_cipcode1 61801 "06.1801 - Small Business Management and Ownership", add 
label define label_cipcode1 61901 "06.1901 - Taxation", add 
label define label_cipcode1 69999 "06.9999 - Business and Management, Other", add 
label define label_cipcode1 70101 "07.0101 - Accounting, Bookkeeping and Related Programs", add 
label define label_cipcode1 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode1 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode1 70104 "07.0104 - Machine Billing, Bookeeping, and Computing", add 
label define label_cipcode1 70199 "07.0199 - Accounting, Bookkeeping, and Related Programs, Other", add 
label define label_cipcode1 70201 "07.0201 - Banking and Related Financial Programs, General", add 
label define label_cipcode1 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode1 70205 "07.0205 - Teller", add 
label define label_cipcode1 70209 "07.0209 - Banking and financial support services", add 
label define label_cipcode1 70299 "07.0299 - Banking and Related Financial Programs, Other", add 
label define label_cipcode1 70301 "07.0301 - Business Data Process and Related Programs, General", add 
label define label_cipcode1 70302 "07.0302 - Business Computer and Console Operation", add 
label define label_cipcode1 70303 "07.0303 - Business Data Entry Equipment Operation", add 
label define label_cipcode1 70305 "07.0305 - Business Data Programming", add 
label define label_cipcode1 70401 "07.0401 - Office Supervision and Management", add 
label define label_cipcode1 70601 "07.0601 - Secretarial and Related Programs, General", add 
label define label_cipcode1 70602 "07.0602 - Court Reporting", add 
label define label_cipcode1 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode1 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode1 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode1 70606 "07.0606 - Secretarial", add 
label define label_cipcode1 70607 "07.0607 - Stenographic", add 
label define label_cipcode1 70699 "07.0699 - Secretarial and Related Programs, Other", add 
label define label_cipcode1 70701 "07.0701 - Typing, General Office and Related Programs", add 
label define label_cipcode1 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode1 70705 "07.0705 - General Office Clerk", add 
label define label_cipcode1 70707 "07.0707 - Receptionist", add 
label define label_cipcode1 70799 "07.0799 - Typing General Office and Related Programs, Other", add 
label define label_cipcode1 70801 "07.0801 - Word Processing", add 
label define label_cipcode1 79999 "07.9999 - Business (Admin Supp), Other", add 
label define label_cipcode1 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode1 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode1 80199 "08.0199 - Apparel and Accessories Marketing Operations, Other", add 
label define label_cipcode1 80401 "08.0401 - Financial Services Marketing Operations", add 
label define label_cipcode1 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode1 80701 "08.0701 - Auctioneering", add 
label define label_cipcode1 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode1 80706 "08.0706 - General Selling Skills and Sales Operations", add 
label define label_cipcode1 80901 "08.0901 - Hospitality and Recreation Marketing Operations, General", add 
label define label_cipcode1 80903 "08.0903 - Recreation Products/Services Marketing Operations", add 
label define label_cipcode1 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode1 81101 "08.1101 - Transportation and Travel Marketing, General", add 
label define label_cipcode1 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode1 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode1 81199 "08.1199 - Tourism and Travel Services Marketing Operations, Other", add 
label define label_cipcode1 81203 "08.1203 - Vehicle Parts and Accessories Marketing Operations", add 
label define label_cipcode1 90101 "09.0101 - Communications, General", add 
label define label_cipcode1 90201 "09.0201 - Advertising", add 
label define label_cipcode1 90601 "09.0601 - Radio/TV News Broadcasting", add 
label define label_cipcode1 90701 "09.0701 - Radio and Television Broadcasting", add 
label define label_cipcode1 90801 "09.0801 - Telecommunictions", add 
label define label_cipcode1 99999 "09.9999 - Communications, Other", add 
label define label_cipcode1 100102 "10.0102 - Motion Picture Technology", add 
label define label_cipcode1 100104 "10.0104 - Radio and Television Broadcasting Tech.", add 
label define label_cipcode1 100105 "10.0105 - Sound Recording Technology", add 
label define label_cipcode1 100106 "10.0106 - Video Technology", add 
label define label_cipcode1 100199 "10.0199 - Communications Technol./Technicians, Other", add 
label define label_cipcode1 110101 "11.0101 - Computer and Information Sciences, General", add 
label define label_cipcode1 110201 "11.0201 - Computer Programming", add 
label define label_cipcode1 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode1 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode1 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode1 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode1 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode1 120101 "12.0101 - Drycleaning and Laundering Services", add 
label define label_cipcode1 120202 "12.0202 - Bartending", add 
label define label_cipcode1 120203 "12.0203 - Card Dealer", add 
label define label_cipcode1 120299 "12.0299 - Gaming and Sports Officiating Services, Other", add 
label define label_cipcode1 120301 "12.0301 - Funeral Services and Mortuary Science", add 
label define label_cipcode1 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode1 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode1 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode1 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode1 120405 "12.0405 - Massage", add 
label define label_cipcode1 120406 "12.0406 - Make-up Artist", add 
label define label_cipcode1 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode1 129999 "12.9999 - Personal and Miscellaneous Services, Other", add 
label define label_cipcode1 130101 "13.0101 - Education, General", add 
label define label_cipcode1 130201 "13.0201 - Bilingual/Bicultural Education", add 
label define label_cipcode1 131006 "13.1006 - Education of the Mentally Handicapped", add 
label define label_cipcode1 131204 "13.1204 - Pre-Elementary Education/Early Childhd/Kindergarten Teacher Education", add 
label define label_cipcode1 131306 "13.1306 - Foreign Languages Teacher Education", add 
label define label_cipcode1 131319 "13.1319 - Technical Teacher Education (Vocational)", add 
label define label_cipcode1 131399 "13.1399 - Teacher Education, Specific Academic and Vocational Programs, Other", add 
label define label_cipcode1 131401 "13.1401 - Teaching ESL/Foreign Language", add 
label define label_cipcode1 139999 "13.9999 - Education, Other", add 
label define label_cipcode1 140201 "14.0201 - Aerospace, Aeronautical and Astronautical Engineering", add 
label define label_cipcode1 141001 "14.1001 - Electrical, Electronics and Communication", add 
label define label_cipcode1 142201 "14.2201 - Naval Architecture and Marine Engineering", add 
label define label_cipcode1 149999 "14.9999 - Engineering, Other", add 
label define label_cipcode1 150199 "15.0199 - Architectural Technologies, Other", add 
label define label_cipcode1 150201 "15.0201 - Civil Engineering/Civil Tech./Technician", add 
label define label_cipcode1 150202 "15.0202 - Drafting and Design Technology", add 
label define label_cipcode1 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode1 150302 "15.0302 - Electrical Technology", add 
label define label_cipcode1 150303 "15.0303 - Electrical, Electronic and Communications Engineering Tech./Technician", add 
label define label_cipcode1 150399 "15.0399 - Electrical and Electronic Engineering-Related Tech./Technician, Other", add 
label define label_cipcode1 150401 "15.0401 - Biomedical Engineering-Related Tech./Technician", add 
label define label_cipcode1 150402 "15.0402 - Computer Maintenance Tech./Technician", add 
label define label_cipcode1 150405 "15.0405 - Robotics Tech./Technician", add 
label define label_cipcode1 150603 "15.0603 - Industrial/Manufacturing Tech./Technician", add 
label define label_cipcode1 150701 "15.0701 - Occupational Safety and Health Tech./Technician", add 
label define label_cipcode1 150702 "15.0702 - Quality Control Tech./Technician", add 
label define label_cipcode1 150803 "15.0803 - Automotive Engineering Tech./Technician", add 
label define label_cipcode1 150805 "15.0805 - Mechanical Engineering/Mechanical Tech.", add 
label define label_cipcode1 150902 "15.0902 - Mining (Excluding Coal) Tech.", add 
label define label_cipcode1 151001 "15.1001 - Construction/Building Tech./Technician", add 
label define label_cipcode1 159999 "15.9999 - Engineering-Related Tech./Technician, Other", add 
label define label_cipcode1 160905 "16.0905 - Spanish Language and Literature", add 
label define label_cipcode1 161102 "16.1102 - Hebrew Language and Literature", add 
label define label_cipcode1 169999 "16.9999 - Foreign Languages and Literatures, Other", add 
label define label_cipcode1 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode1 170103 "17.0103 - Dental Laboratory Technology", add 
label define label_cipcode1 170199 "17.0199 - Dental Services, Other", add 
label define label_cipcode1 170201 "17.0201 - Cardiovascular Technology", add 
label define label_cipcode1 170203 "17.0203 - Electrocardiograph Technology", add 
label define label_cipcode1 170205 "17.0205 - Emergency Med Tech-Ambulance", add 
label define label_cipcode1 170206 "17.0206 - Emergency Med Tech-Paramedic", add 
label define label_cipcode1 170208 "17.0208 - Nuclear Medical Technology", add 
label define label_cipcode1 170209 "17.0209 - Radiologic (Medical) Tech.", add 
label define label_cipcode1 170210 "17.0210 - Respiratory Therapy Technician", add 
label define label_cipcode1 170211 "17.0211 - Surgical Technology", add 
label define label_cipcode1 170212 "17.0212 - Diagnostic Medical Sonography", add 
label define label_cipcode1 170299 "17.0299 - Diagnstic and Treatment Services, Other", add 
label define label_cipcode1 170306 "17.0306 - Cytotechnology", add 
label define label_cipcode1 170309 "17.0309 - Medical Laboratory Technician", add 
label define label_cipcode1 170310 "17.0310 - Medical Technology", add 
label define label_cipcode1 170399 "17.0399 - Medical Lab Technologies/Technicians, Other", add 
label define label_cipcode1 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode1 170405 "17.0405 - Mental Health/Hum Services, Assistant", add 
label define label_cipcode1 170406 "17.0406 - Mental Health/Hum Services,Technician", add 
label define label_cipcode1 170502 "17.0502 - Central Supply Technology", add 
label define label_cipcode1 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode1 170504 "17.0504 - Medical Illustrating", add 
label define label_cipcode1 170505 "17.0505 - Medical Office Management", add 
label define label_cipcode1 170506 "17.0506 - Medical Records Technology", add 
label define label_cipcode1 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode1 170508 "17.0508 - Physician Assisting", add 
label define label_cipcode1 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode1 170599 "17.0599 - Misc Allied Health Services, Other", add 
label define label_cipcode1 170601 "17.0601 - Geriatric Aide", add 
label define label_cipcode1 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode1 170605 "17.0605 - Practical Nursing", add 
label define label_cipcode1 170606 "17.0606 - Health Unit Management", add 
label define label_cipcode1 170699 "17.0699 - Nursing-Related Services, Other", add 
label define label_cipcode1 170701 "17.0701 - Ophthalmic Dispensing", add 
label define label_cipcode1 170813 "17.0813 - Physical Therapy", add 
label define label_cipcode1 170818 "17.0818 - Respiratory Therapy", add 
label define label_cipcode1 170819 "17.0819 - Respiratory Therapy Assistant", add 
label define label_cipcode1 179999 "17.9999 - Allied Health, Other", add 
label define label_cipcode1 180401 "18.0401 - Dentistry, General", add 
label define label_cipcode1 180403 "18.0403 - Endodontics", add 
label define label_cipcode1 180406 "18.0406 - Orthodontics", add 
label define label_cipcode1 181007 "18.1007 - Family Practice", add 
label define label_cipcode1 181016 "18.1016 - Orthopedic", add 
label define label_cipcode1 181018 "18.1018 - Pathology", add 
label define label_cipcode1 181025 "18.1025 - Radiology", add 
label define label_cipcode1 181099 "18.1099 - Medicine, Other", add 
label define label_cipcode1 181101 "18.1101 - Nursing, General", add 
label define label_cipcode1 181102 "18.1102 - Anesthetist", add 
label define label_cipcode1 181199 "18.1199 - Nursing, Other", add 
label define label_cipcode1 182299 "18.2299 - Public Health, Other", add 
label define label_cipcode1 189999 "18.9999 - Health Sciences, Other", add 
label define label_cipcode1 190501 "19.0501 - Foods and Nutrition Studies, General", add 
label define label_cipcode1 190503 "19.0503 - Dietetics/Human Nutritional Services", add 
label define label_cipcode1 190703 "19.0703 - Family and Marriage Counseling", add 
label define label_cipcode1 190902 "19.0902 - Fashion Design", add 
label define label_cipcode1 199999 "19.9999 - Home Economics, Other", add 
label define label_cipcode1 200102 "20.0102 - Child Development, Care and Guidance", add 
label define label_cipcode1 200106 "20.0106 - Family/Individual Health", add 
label define label_cipcode1 200201 "20.0201 - Child Care/Guidance Workers and Managers, General", add 
label define label_cipcode1 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode1 200203 "20.0203 - Child Care Services Manager", add 
label define label_cipcode1 200299 "20.0299 - Child Care/Guidance Workers and Managers, Other", add 
label define label_cipcode1 200301 "20.0301 - Clothing, Apparel and Textile Workers and Managers, General", add 
label define label_cipcode1 200303 "20.0303 - Commercial Garment and Apparel Worker", add 
label define label_cipcode1 200304 "20.0304 - Custom Apparel/Garment Seamstress", add 
label define label_cipcode1 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode1 200399 "20.0399 - Clothing, Apparel and Textile Workers and Managers, Other", add 
label define label_cipcode1 200401 "20.0401 - Institutional Food Workers and Administrators, General", add 
label define label_cipcode1 200402 "20.0402 - Baking", add 
label define label_cipcode1 200403 "20.0403 - Chef/Cook", add 
label define label_cipcode1 200404 "20.0404 - Dietician Assistant", add 
label define label_cipcode1 200499 "20.0499 - Institutional Food Workers and Administrators, Other", add 
label define label_cipcode1 200504 "20.0504 - Floral Design", add 
label define label_cipcode1 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode1 210102 "21.0102 - Construction", add 
label define label_cipcode1 210103 "21.0103 - Drafting and Design", add 
label define label_cipcode1 210106 "21.0106 - Graphic Arts", add 
label define label_cipcode1 210107 "21.0107 - Manufacturing/Materials Processing", add 
label define label_cipcode1 210199 "21.0199 - Industrial Arts, Other", add 
label define label_cipcode1 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode1 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode1 230101 "23.0101 - English Language and Literature, General", add 
label define label_cipcode1 230401 "23.0401 - English Composition", add 
label define label_cipcode1 230501 "23.0501 - English Creative Writing", add 
label define label_cipcode1 231101 "23.1101 - English Technical and Business Writing", add 
label define label_cipcode1 231201 "23.1201 - English as a Second Language", add 
label define label_cipcode1 239999 "23.9999 - English Language and Literature/Letters, Other", add 
label define label_cipcode1 240101 "24.0101 - Liberal Arts and Sciences/Liberal Studies", add 
label define label_cipcode1 240102 "24.0102 - General Studies", add 
label define label_cipcode1 260608 "26.0608 - Neuroscience", add 
label define label_cipcode1 280201 "28.0201 - Coast guard science", add 
label define label_cipcode1 280501 "28.0501 - Maritime Sci (Merch Marine)", add 
label define label_cipcode1 300201 "30.0201 - Clinical Pastoral Care", add 
label define label_cipcode1 310201 "31.0201 - Outdoor Recreation", add 
label define label_cipcode1 320101 "32.0101 - Basic Skills, General", add 
label define label_cipcode1 320103 "32.0103 - Communication Skills", add 
label define label_cipcode1 320105 "32.0105 - Job Seeking/Changing Skills", add 
label define label_cipcode1 320199 "32.0199 - Basic Skills, Other", add 
label define label_cipcode1 340103 "34.0103 - Personal Health Improvemente and Maintenance", add 
label define label_cipcode1 340199 "34.0199 - Health-Related Knowledge and Skills, Other", add 
label define label_cipcode1 350101 "35.0101 - Interpersonal skills, general", add 
label define label_cipcode1 360107 "36.0107 - Pet care", add 
label define label_cipcode1 360108 "36.0108 - Sports/physical education", add 
label define label_cipcode1 360109 "36.0109 - Travel and Exploration", add 
label define label_cipcode1 360199 "36.0199 - Leisure and Recreational Activities, Other", add 
label define label_cipcode1 370101 "37.0101 - Self-Awareness and Personal Assessment", add 
label define label_cipcode1 370104 "37.0104 - Self-Esteem and Values Clarification", add 
label define label_cipcode1 370199 "37.0199 - Personal Awareness and Self-Improvement, Other", add 
label define label_cipcode1 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode1 389999 "38.9999 - Philosophy and Religion", add 
label define label_cipcode1 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode1 390301 "39.0301 - Missions/Missionary Studies and Misology", add 
label define label_cipcode1 390401 "39.0401 - Religious Education", add 
label define label_cipcode1 390601 "39.0601 - Theology/Theological Studies", add 
label define label_cipcode1 399999 "39.9999 - Theological Studies and Rel. Vocations, Other", add 
label define label_cipcode1 400702 "40.0702 - Oceanography", add 
label define label_cipcode1 410101 "41.0101 - Biological Tech./Technician", add 
label define label_cipcode1 410202 "41.0202 - Nuclear Power Plant Operation Technology", add 
label define label_cipcode1 410302 "41.0302 - Geological Technology", add 
label define label_cipcode1 410303 "41.0303 - Metallurgical Technology", add 
label define label_cipcode1 419999 "41.9999 - Science Technologies/Technicians, Other", add 
label define label_cipcode1 430105 "43.0105 - Criminal Justice Technology", add 
label define label_cipcode1 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode1 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode1 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode1 430203 "43.0203 - Fire Science/Firefighting", add 
label define label_cipcode1 430299 "43.0299 - Fire Protection, Other", add 
label define label_cipcode1 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode1 440101 "44.0101 - Public Affairs, General", add 
label define label_cipcode1 460201 "46.0201 - Carpenter", add 
label define label_cipcode1 460302 "46.0302 - Electrician", add 
label define label_cipcode1 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode1 460404 "46.0404 - Drywall Installation", add 
label define label_cipcode1 460499 "46.0499 - Const. and Bldg. Finishers and Managers, Other", add 
label define label_cipcode1 460503 "46.0503 - Plumbing", add 
label define label_cipcode1 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode1 470101 "47.0101 - Electrical and Electronics Equipment Installer and Repairers, General", add 
label define label_cipcode1 470102 "47.0102 - Business Machine Repairer", add 
label define label_cipcode1 470103 "47.0103 - Communication Systems Installer and Repairer", add 
label define label_cipcode1 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode1 470199 "47.0199 - Electrical and Electronics Equipment Installer and Repairers, Other", add 
label define label_cipcode1 470201 "47.0201 - Heating, Air Conditioning and Refrig. Mechanic and Repairer", add 
label define label_cipcode1 470202 "47.0202 - Cooling and Refrigeration", add 
label define label_cipcode1 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode1 470299 "47.0299 - Heat Aircond. and Refrig. Mech., Other", add 
label define label_cipcode1 470301 "47.0301 - Industrial Equip. Main. and Repairers, General", add 
label define label_cipcode1 470302 "47.0302 - Heavy Equipment Main. and Repairer", add 
label define label_cipcode1 470303 "47.0303 - Industrial Machinery Main. and Repairer", add 
label define label_cipcode1 470402 "47.0402 - Gunsmith", add 
label define label_cipcode1 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode1 470404 "47.0404 - Musical Instrument Repairer", add 
label define label_cipcode1 470408 "47.0408 - Watch, Clock and Jewelry Repairer", add 
label define label_cipcode1 470499 "47.0499 - Miscellaneous Mechanics and Repairers, Other", add 
label define label_cipcode1 470501 "47.0501 - Stationary Energy Sources Installer/Operator", add 
label define label_cipcode1 470502 "47.0502 - Conventional Elec Power General", add 
label define label_cipcode1 470601 "47.0601 - Vehicle and Mobile Equipment Mechanics and Repairers, General", add 
label define label_cipcode1 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode1 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode1 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode1 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode1 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode1 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode1 470699 "47.0699 - Vehicle and Mobile Equip. Mechanic and Repairer", add 
label define label_cipcode1 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode1 480101 "48.0101 - Drafting, General", add 
label define label_cipcode1 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode1 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode1 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode1 480201 "48.0201 - Graphic and Printing Equipment Operator, General", add 
label define label_cipcode1 480203 "48.0203 - Commercial Air", add 
label define label_cipcode1 480204 "48.0204 - Commercial Photography", add 
label define label_cipcode1 480205 "48.0205 - Mechanical Typesetter and Composer", add 
label define label_cipcode1 480206 "48.0206 - Lithographer and Platemaker", add 
label define label_cipcode1 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode1 480299 "48.0299 - Graphic and Printing Equipment Operator, Other", add 
label define label_cipcode1 480303 "48.0303 - Upholsterer", add 
label define label_cipcode1 480399 "48.0399 - Leatherworkers and Upholsterers, Other", add 
label define label_cipcode1 480402 "48.0402 - Meatcutting", add 
label define label_cipcode1 480501 "48.0501 - Machinist/Machine Technologist", add 
label define label_cipcode1 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode1 480507 "48.0507 - Tool and Die Maker/Technologist", add 
label define label_cipcode1 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode1 480599 "48.0599 - Precision Metal Workers, Other", add 
label define label_cipcode1 480601 "48.0601 - Industrial ceramics manufacturing", add 
label define label_cipcode1 480602 "48.0602 - Jewelry Design Fab and Repair", add 
label define label_cipcode1 480699 "48.0699 - Precision Worker, Assorted Materials, Other", add 
label define label_cipcode1 480701 "48.0701 - Woodworkers, General", add 
label define label_cipcode1 480799 "48.0799 - Woodworkers, Other", add 
label define label_cipcode1 489999 "48.9999 - Precision Production Trades, Other", add 
label define label_cipcode1 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode1 490102 "49.0102 - Aircraft Pilot and Navigator (Professional)", add 
label define label_cipcode1 490104 "49.0104 - Aviation Management", add 
label define label_cipcode1 490105 "49.0105 - Air Traffic Controller", add 
label define label_cipcode1 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode1 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode1 490201 "49.0201 - Vehicle and Equipment Operators, General", add 
label define label_cipcode1 490202 "49.0202 - Construction Equipment Operator", add 
label define label_cipcode1 490205 "49.0205 - Truck, Bus and Other Commercial Vehicle Operators", add 
label define label_cipcode1 490299 "49.0299 - Vehicle and Equipment Operators, Other", add 
label define label_cipcode1 490301 "49.0301 - Water Transportation, General", add 
label define label_cipcode1 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode1 490305 "49.0305 - Marina Operations", add 
label define label_cipcode1 490306 "49.0306 - Marine Main. and Ship Repairer", add 
label define label_cipcode1 490308 "49.0308 - Sailors and Deckhands", add 
label define label_cipcode1 490399 "49.0399 - Water Transportation Workers, Other", add 
label define label_cipcode1 499999 "49.9999 - Transportation and Materials Moving Workers, Other", add 
label define label_cipcode1 500101 "50.0101 - Visual and Performing Arts, General", add 
label define label_cipcode1 500202 "50.0202 - Ceramics", add 
label define label_cipcode1 500205 "50.0205 - Glass", add 
label define label_cipcode1 500206 "50.0206 - Metal/Jewelry", add 
label define label_cipcode1 500299 "50.0299 - Crafts, Other", add 
label define label_cipcode1 500301 "50.0301 - Dance", add 
label define label_cipcode1 500402 "50.0402 - Graphic Design, Commercial Art and Illustration", add 
label define label_cipcode1 500403 "50.0403 - Illustration Design", add 
label define label_cipcode1 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode1 500605 "50.0605 - Photography", add 
label define label_cipcode1 500606 "50.0606 - Video", add 
label define label_cipcode1 500699 "50.0699 - Film/Video and Photographic Arts, Other", add 
label define label_cipcode1 500701 "50.0701 - Art, General", add 
label define label_cipcode1 500702 "50.0702 - Fine/Studio Arts", add 
label define label_cipcode1 500705 "50.0705 - Drawing", add 
label define label_cipcode1 500799 "50.0799 - Fine Arts and Art Studies, Other", add 
label define label_cipcode1 500901 "50.0901 - Music, General", add 
label define label_cipcode1 500903 "50.0903 - Music - General Performance", add 
label define label_cipcode1 500999 "50.0999 - Music, Other", add 
label define label_cipcode1 509999 "50.9999 - Visual and Performing Arts, Other", add 
label values cipcode1 label_cipcode1
label define label_cipcode2 10504 "01.0504 - Pet Grooming" 
label define label_cipcode2 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode2 10507 "01.0507 - Equestrian/Equine Studies, Horse Management and Training", add 
label define label_cipcode2 10699 "01.0699 - Horticulture Services Operations and Management, Other", add 
label define label_cipcode2 20201 "02.0201 - Animal Sciences, General", add 
label define label_cipcode2 40501 "04.0501 - Interior Architecture", add 
label define label_cipcode2 60101 "06.0101 - Business and Management, General", add 
label define label_cipcode2 60201 "06.0201 - Accounting", add 
label define label_cipcode2 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode2 60401 "06.0401 - Business Admin. and Management, General", add 
label define label_cipcode2 60402 "06.0402 - Contract Management and Procure/Purchasing", add 
label define label_cipcode2 60499 "06.0499 - Business Admin. and Management, Other", add 
label define label_cipcode2 60701 "06.0701 - Hotel/Motel Management", add 
label define label_cipcode2 60704 "06.0704 - Restaurant Management", add 
label define label_cipcode2 60799 "06.0799 - Institutional Management, Other", add 
label define label_cipcode2 60801 "06.0801 - Insurance and Risk Management", add 
label define label_cipcode2 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode2 61201 "06.1201 - Management Information Systems", add 
label define label_cipcode2 61303 "06.1303 - Management Science, General", add 
label define label_cipcode2 61401 "06.1401 - Marketing Management", add 
label define label_cipcode2 61601 "06.1601 - Personnel Management", add 
label define label_cipcode2 61701 "06.1701 - Real Estate", add 
label define label_cipcode2 61801 "06.1801 - Small Business Management and Ownership", add 
label define label_cipcode2 61901 "06.1901 - Taxation", add 
label define label_cipcode2 62001 "06.2001 - Trade and Industrial Supervision and  Management", add 
label define label_cipcode2 69999 "06.9999 - Business and Management, Other", add 
label define label_cipcode2 70101 "07.0101 - Accounting, Bookkeeping and Related Programs", add 
label define label_cipcode2 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode2 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode2 70104 "07.0104 - Machine Billing, Bookeeping, and Computing", add 
label define label_cipcode2 70199 "07.0199 - Accounting, Bookkeeping, and Related Programs, Other", add 
label define label_cipcode2 70201 "07.0201 - Banking and Related Financial Programs, General", add 
label define label_cipcode2 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode2 70205 "07.0205 - Teller", add 
label define label_cipcode2 70301 "07.0301 - Business Data Process and Related Programs, General", add 
label define label_cipcode2 70302 "07.0302 - Business Computer and Console Operation", add 
label define label_cipcode2 70303 "07.0303 - Business Data Entry Equipment Operation", add 
label define label_cipcode2 70399 "07.0399 - Business Data Process and Related Programs, Other", add 
label define label_cipcode2 70401 "07.0401 - Office Supervision and Management", add 
label define label_cipcode2 70501 "07.0501 - Personnel and Training Programs, General", add 
label define label_cipcode2 70601 "07.0601 - Secretarial and Related Programs, General", add 
label define label_cipcode2 70602 "07.0602 - Court Reporting", add 
label define label_cipcode2 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode2 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode2 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode2 70606 "07.0606 - Secretarial", add 
label define label_cipcode2 70607 "07.0607 - Stenographic", add 
label define label_cipcode2 70699 "07.0699 - Secretarial and Related Programs, Other", add 
label define label_cipcode2 70701 "07.0701 - Typing, General Office and Related Programs", add 
label define label_cipcode2 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode2 70705 "07.0705 - General Office Clerk", add 
label define label_cipcode2 70707 "07.0707 - Receptionist", add 
label define label_cipcode2 70799 "07.0799 - Typing General Office and Related Programs, Other", add 
label define label_cipcode2 70801 "07.0801 - Word Processing", add 
label define label_cipcode2 79999 "07.9999 - Business (Admin Supp), Other", add 
label define label_cipcode2 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode2 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode2 80105 "08.0105 - Jewelry Marketing", add 
label define label_cipcode2 80199 "08.0199 - Apparel and Accessories Marketing Operations, Other", add 
label define label_cipcode2 80201 "08.0201 - Business and Personal Services Marketing, General", add 
label define label_cipcode2 80203 "08.0203 - Markeing of Business or Personal Services", add 
label define label_cipcode2 80401 "08.0401 - Financial Services Marketing Operations", add 
label define label_cipcode2 80501 "08.0501 - Florist Farm Garden Supplies Marketing", add 
label define label_cipcode2 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode2 80699 "08.0699 - Food Marketing, Other", add 
label define label_cipcode2 80701 "08.0701 - Auctioneering", add 
label define label_cipcode2 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode2 80706 "08.0706 - General Selling Skills and Sales Operations", add 
label define label_cipcode2 80708 "08.0708 - General Marketing Operations", add 
label define label_cipcode2 80901 "08.0901 - Hospitality and Recreation Marketing Operations, General", add 
label define label_cipcode2 80905 "08.0905 - Water/Waitress and Related Services", add 
label define label_cipcode2 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode2 81101 "08.1101 - Transportation and Travel Marketing, General", add 
label define label_cipcode2 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode2 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode2 81199 "08.1199 - Tourism and Travel Services Marketing Operations, Other", add 
label define label_cipcode2 89999 "08.9999 - Marketing Operations/Marketing and Distribution, Other", add 
label define label_cipcode2 90101 "09.0101 - Communications, General", add 
label define label_cipcode2 90201 "09.0201 - Advertising", add 
label define label_cipcode2 90601 "09.0601 - Radio/TV News Broadcasting", add 
label define label_cipcode2 90701 "09.0701 - Radio and Television Broadcasting", add 
label define label_cipcode2 90801 "09.0801 - Telecommunictions", add 
label define label_cipcode2 100103 "10.0103 - Photographic Tech./Technician", add 
label define label_cipcode2 100104 "10.0104 - Radio and Television Broadcasting Tech.", add 
label define label_cipcode2 100105 "10.0105 - Sound Recording Technology", add 
label define label_cipcode2 100106 "10.0106 - Video Technology", add 
label define label_cipcode2 100199 "10.0199 - Communications Technol./Technicians, Other", add 
label define label_cipcode2 110101 "11.0101 - Computer and Information Sciences, General", add 
label define label_cipcode2 110201 "11.0201 - Computer Programming", add 
label define label_cipcode2 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode2 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode2 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode2 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode2 120101 "12.0101 - Drycleaning and Laundering Services", add 
label define label_cipcode2 120202 "12.0202 - Bartending", add 
label define label_cipcode2 120203 "12.0203 - Card Dealer", add 
label define label_cipcode2 120299 "12.0299 - Gaming and Sports Officiating Services, Other", add 
label define label_cipcode2 120301 "12.0301 - Funeral Services and Mortuary Science", add 
label define label_cipcode2 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode2 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode2 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode2 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode2 120405 "12.0405 - Massage", add 
label define label_cipcode2 120406 "12.0406 - Make-up Artist", add 
label define label_cipcode2 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode2 129999 "12.9999 - Personal and Miscellaneous Services, Other", add 
label define label_cipcode2 130101 "13.0101 - Education, General", add 
label define label_cipcode2 131007 "13.1007 - Education of the Multiple Handicapped", add 
label define label_cipcode2 131010 "13.1010 - Remedial Education", add 
label define label_cipcode2 131204 "13.1204 - Pre-Elementary Education/Early Childhd/Kindergarten Teacher Education", add 
label define label_cipcode2 131399 "13.1399 - Teacher Education, Specific Academic and Vocational Programs, Other", add 
label define label_cipcode2 131401 "13.1401 - Teaching ESL/Foreign Language", add 
label define label_cipcode2 131501 "13.1501 - Teacher Assistant/Aide", add 
label define label_cipcode2 140401 "14.0401 - Architectural Engineering", add 
label define label_cipcode2 149999 "14.9999 - Engineering, Other", add 
label define label_cipcode2 150101 "15.0101 - Architectural Engineering Techno/Tech.", add 
label define label_cipcode2 150202 "15.0202 - Drafting and Design Technology", add 
label define label_cipcode2 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode2 150302 "15.0302 - Electrical Technology", add 
label define label_cipcode2 150303 "15.0303 - Electrical, Electronic and Communications Engineering Tech./Technician", add 
label define label_cipcode2 150399 "15.0399 - Electrical and Electronic Engineering-Related Tech./Technician, Other", add 
label define label_cipcode2 150402 "15.0402 - Computer Maintenance Tech./Technician", add 
label define label_cipcode2 150405 "15.0405 - Robotics Tech./Technician", add 
label define label_cipcode2 150501 "15.0501 - Heating, Air Conditioning and Refrigeration Tech./Technician", add 
label define label_cipcode2 150599 "15.0599 - Environmental Control Tech., Other", add 
label define label_cipcode2 150602 "15.0602 - Food Processing Technology", add 
label define label_cipcode2 150610 "15.0610 - Welding Technology", add 
label define label_cipcode2 150702 "15.0702 - Quality Control Tech./Technician", add 
label define label_cipcode2 150803 "15.0803 - Automotive Engineering Tech./Technician", add 
label define label_cipcode2 150805 "15.0805 - Mechanical Engineering/Mechanical Tech.", add 
label define label_cipcode2 151001 "15.1001 - Construction/Building Tech./Technician", add 
label define label_cipcode2 159999 "15.9999 - Engineering-Related Tech./Technician, Other", add 
label define label_cipcode2 160101 "16.0101 - Foreign Languages and Literatures, General", add 
label define label_cipcode2 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode2 170102 "17.0102 - Dental Hygiene", add 
label define label_cipcode2 170103 "17.0103 - Dental Laboratory Technology", add 
label define label_cipcode2 170199 "17.0199 - Dental Services, Other", add 
label define label_cipcode2 170203 "17.0203 - Electrocardiograph Technology", add 
label define label_cipcode2 170206 "17.0206 - Emergency Med Tech-Paramedic", add 
label define label_cipcode2 170209 "17.0209 - Radiologic (Medical) Tech.", add 
label define label_cipcode2 170210 "17.0210 - Respiratory Therapy Technician", add 
label define label_cipcode2 170299 "17.0299 - Diagnstic and Treatment Services, Other", add 
label define label_cipcode2 170309 "17.0309 - Medical Laboratory Technician", add 
label define label_cipcode2 170310 "17.0310 - Medical Technology", add 
label define label_cipcode2 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode2 170405 "17.0405 - Mental Health/Hum Services, Assistant", add 
label define label_cipcode2 170499 "17.0499 - Ment Health/Human Services, Other", add 
label define label_cipcode2 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode2 170505 "17.0505 - Medical Office Management", add 
label define label_cipcode2 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode2 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode2 170599 "17.0599 - Misc Allied Health Services, Other", add 
label define label_cipcode2 170601 "17.0601 - Geriatric Aide", add 
label define label_cipcode2 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode2 170605 "17.0605 - Practical Nursing", add 
label define label_cipcode2 170699 "17.0699 - Nursing-Related Services, Other", add 
label define label_cipcode2 170812 "17.0812 - Orthopedic Assistants, Other", add 
label define label_cipcode2 170813 "17.0813 - Physical Therapy", add 
label define label_cipcode2 170814 "17.0814 - Physical Therapy Aide", add 
label define label_cipcode2 170818 "17.0818 - Respiratory Therapy", add 
label define label_cipcode2 170819 "17.0819 - Respiratory Therapy Assistant", add 
label define label_cipcode2 179999 "17.9999 - Allied Health, Other", add 
label define label_cipcode2 180299 "18.0299 - Basic Clinical Health Sciences, Other", add 
label define label_cipcode2 181101 "18.1101 - Nursing, General", add 
label define label_cipcode2 181199 "18.1199 - Nursing, Other", add 
label define label_cipcode2 182299 "18.2299 - Public Health, Other", add 
label define label_cipcode2 190703 "19.0703 - Family and Marriage Counseling", add 
label define label_cipcode2 190902 "19.0902 - Fashion Design", add 
label define label_cipcode2 190999 "19.0999 - Textiles and Clothing, Other", add 
label define label_cipcode2 200201 "20.0201 - Child Care/Guidance Workers and Managers, General", add 
label define label_cipcode2 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode2 200203 "20.0203 - Child Care Services Manager", add 
label define label_cipcode2 200299 "20.0299 - Child Care/Guidance Workers and Managers, Other", add 
label define label_cipcode2 200301 "20.0301 - Clothing, Apparel and Textile Workers and Managers, General", add 
label define label_cipcode2 200303 "20.0303 - Commercial Garment and Apparel Worker", add 
label define label_cipcode2 200304 "20.0304 - Custom Apparel/Garment Seamstress", add 
label define label_cipcode2 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode2 200306 "20.0306 - Fashion and Fabric Consultant", add 
label define label_cipcode2 200399 "20.0399 - Clothing, Apparel and Textile Workers and Managers, Other", add 
label define label_cipcode2 200401 "20.0401 - Institutional Food Workers and Administrators, General", add 
label define label_cipcode2 200403 "20.0403 - Chef/Cook", add 
label define label_cipcode2 200405 "20.0405 - Food Caterer", add 
label define label_cipcode2 200406 "20.0406 - Food Service", add 
label define label_cipcode2 200408 "20.0408 - School Food Service", add 
label define label_cipcode2 200499 "20.0499 - Institutional Food Workers and Administrators, Other", add 
label define label_cipcode2 200503 "20.0503 - Custom Slipcovering and Uphols", add 
label define label_cipcode2 200504 "20.0504 - Floral Design", add 
label define label_cipcode2 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode2 210103 "21.0103 - Drafting and Design", add 
label define label_cipcode2 210104 "21.0104 - Electricity/Electronics", add 
label define label_cipcode2 210106 "21.0106 - Graphic Arts", add 
label define label_cipcode2 210199 "21.0199 - Industrial Arts, Other", add 
label define label_cipcode2 220101 "22.0101 - Law (LL.B., J.D.)", add 
label define label_cipcode2 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode2 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode2 230101 "23.0101 - English Language and Literature, General", add 
label define label_cipcode2 231101 "23.1101 - English Technical and Business Writing", add 
label define label_cipcode2 231201 "23.1201 - English as a Second Language", add 
label define label_cipcode2 239999 "23.9999 - English Language and Literature/Letters, Other", add 
label define label_cipcode2 240101 "24.0101 - Liberal Arts and Sciences/Liberal Studies", add 
label define label_cipcode2 240102 "24.0102 - General Studies", add 
label define label_cipcode2 260601 "26.0601 - Anatomy", add 
label define label_cipcode2 260604 "26.0604 - Embryology", add 
label define label_cipcode2 270101 "27.0101 - Mathematics", add 
label define label_cipcode2 280501 "28.0501 - Maritime Sci (Merch Marine)", add 
label define label_cipcode2 289999 "28.9999 - Military Science, Other", add 
label define label_cipcode2 310201 "31.0201 - Outdoor Recreation", add 
label define label_cipcode2 320101 "32.0101 - Basic Skills, General", add 
label define label_cipcode2 320103 "32.0103 - Communication Skills", add 
label define label_cipcode2 320105 "32.0105 - Job Seeking/Changing Skills", add 
label define label_cipcode2 340199 "34.0199 - Health-Related Knowledge and Skills, Other", add 
label define label_cipcode2 350101 "35.0101 - Interpersonal skills, general", add 
label define label_cipcode2 350199 "35.0199 - Interpersonal Social Skills, Other", add 
label define label_cipcode2 360108 "36.0108 - Sports/physical education", add 
label define label_cipcode2 360109 "36.0109 - Travel and Exploration", add 
label define label_cipcode2 370101 "37.0101 - Self-Awareness and Personal Assessment", add 
label define label_cipcode2 370199 "37.0199 - Personal Awareness and Self-Improvement, Other", add 
label define label_cipcode2 389999 "38.9999 - Philosophy and Religion", add 
label define label_cipcode2 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode2 390401 "39.0401 - Religious Education", add 
label define label_cipcode2 390501 "39.0501 - Religious/Sacred Music", add 
label define label_cipcode2 399999 "39.9999 - Theological Studies and Rel. Vocations, Other", add 
label define label_cipcode2 410199 "41.0199 - Biological Technologies, Other", add 
label define label_cipcode2 410203 "41.0203 - Nuclear Power Plant Radiation Control Technology", add 
label define label_cipcode2 410204 "41.0204 - Industrial Radiologic Tech./Technician", add 
label define label_cipcode2 419999 "41.9999 - Science Technologies/Technicians, Other", add 
label define label_cipcode2 421401 "42.1401 - Psychopharmacology", add 
label define label_cipcode2 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode2 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode2 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode2 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode2 440101 "44.0101 - Public Affairs, General", add 
label define label_cipcode2 460101 "46.0101 - Mason and Tile Setter", add 
label define label_cipcode2 460102 "46.0102 - Brickmasonry, Block and Stone", add 
label define label_cipcode2 460103 "46.0103 - Tile setting", add 
label define label_cipcode2 460201 "46.0201 - Carpenter", add 
label define label_cipcode2 460302 "46.0302 - Electrician", add 
label define label_cipcode2 460399 "46.0399 - Elec. and Power Trans. Installer, Other", add 
label define label_cipcode2 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode2 460499 "46.0499 - Const. and Bldg. Finishers and Managers, Other", add 
label define label_cipcode2 460501 "46.0501 - Plumber and Pipefitter", add 
label define label_cipcode2 460503 "46.0503 - Plumbing", add 
label define label_cipcode2 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode2 470101 "47.0101 - Electrical and Electronics Equipment Installer and Repairers, General", add 
label define label_cipcode2 470103 "47.0103 - Communication Systems Installer and Repairer", add 
label define label_cipcode2 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode2 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode2 470108 "47.0108 - Small Appliance Repair", add 
label define label_cipcode2 470199 "47.0199 - Electrical and Electronics Equipment Installer and Repairers, Other", add 
label define label_cipcode2 470201 "47.0201 - Heating, Air Conditioning and Refrig. Mechanic and Repairer", add 
label define label_cipcode2 470202 "47.0202 - Cooling and Refrigeration", add 
label define label_cipcode2 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode2 470299 "47.0299 - Heat Aircond. and Refrig. Mech., Other", add 
label define label_cipcode2 470301 "47.0301 - Industrial Equip. Main. and Repairers, General", add 
label define label_cipcode2 470399 "47.0399 - Industrial Equip. Main. and Repairers, Other", add 
label define label_cipcode2 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode2 470404 "47.0404 - Musical Instrument Repairer", add 
label define label_cipcode2 470408 "47.0408 - Watch, Clock and Jewelry Repairer", add 
label define label_cipcode2 470502 "47.0502 - Conventional Elec Power General", add 
label define label_cipcode2 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode2 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode2 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode2 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode2 470699 "47.0699 - Vehicle and Mobile Equip. Mechanic and Repairer", add 
label define label_cipcode2 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode2 480101 "48.0101 - Drafting, General", add 
label define label_cipcode2 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode2 480104 "48.0104 - Electrical/Electronics Drafting", add 
label define label_cipcode2 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode2 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode2 480201 "48.0201 - Graphic and Printing Equipment Operator, General", add 
label define label_cipcode2 480203 "48.0203 - Commercial Air", add 
label define label_cipcode2 480204 "48.0204 - Commercial Photography", add 
label define label_cipcode2 480205 "48.0205 - Mechanical Typesetter and Composer", add 
label define label_cipcode2 480207 "48.0207 - Photographic Lab and Darkroom", add 
label define label_cipcode2 480209 "48.0209 - Silk Screen Making and Printing", add 
label define label_cipcode2 480303 "48.0303 - Upholsterer", add 
label define label_cipcode2 480402 "48.0402 - Meatcutting", add 
label define label_cipcode2 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode2 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode2 480599 "48.0599 - Precision Metal Workers, Other", add 
label define label_cipcode2 480602 "48.0602 - Jewelry Design Fab and Repair", add 
label define label_cipcode2 480604 "48.0604 - Plastics", add 
label define label_cipcode2 480699 "48.0699 - Precision Worker, Assorted Materials, Other", add 
label define label_cipcode2 480701 "48.0701 - Woodworkers, General", add 
label define label_cipcode2 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode2 490102 "49.0102 - Aircraft Pilot and Navigator (Professional)", add 
label define label_cipcode2 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode2 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode2 490202 "49.0202 - Construction Equipment Operator", add 
label define label_cipcode2 490205 "49.0205 - Truck, Bus and Other Commercial Vehicle Operators", add 
label define label_cipcode2 490299 "49.0299 - Vehicle and Equipment Operators, Other", add 
label define label_cipcode2 490302 "49.0302 - Barge and Boat Operations", add 
label define label_cipcode2 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode2 490306 "49.0306 - Marine Main. and Ship Repairer", add 
label define label_cipcode2 490399 "49.0399 - Water Transportation Workers, Other", add 
label define label_cipcode2 500299 "50.0299 - Crafts, Other", add 
label define label_cipcode2 500403 "50.0403 - Illustration Design", add 
label define label_cipcode2 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode2 500605 "50.0605 - Photography", add 
label define label_cipcode2 500699 "50.0699 - Film/Video and Photographic Arts, Other", add 
label define label_cipcode2 500701 "50.0701 - Art, General", add 
label define label_cipcode2 500702 "50.0702 - Fine/Studio Arts", add 
label define label_cipcode2 500904 "50.0904 - Music Theory and Composition", add 
label define label_cipcode2 509999 "50.9999 - Visual and Performing Arts, Other", add 
label values cipcode2 label_cipcode2
label define label_cipcode3 10504 "01.0504 - Pet Grooming" 
label define label_cipcode3 10507 "01.0507 - Equestrian/Equine Studies, Horse Management and Training", add 
label define label_cipcode3 10601 "01.0601 - Horticulture Services Operations and Management, General", add 
label define label_cipcode3 10605 "01.0605 - Landscaping Operations and Management", add 
label define label_cipcode3 20101 "02.0101 - Agriculture/Agricultural Sciences, General", add 
label define label_cipcode3 40301 "04.0301 - City/Urban, Community and Regional Planning", add 
label define label_cipcode3 40401 "04.0401 - Architectural Environmental Design", add 
label define label_cipcode3 40501 "04.0501 - Interior Architecture", add 
label define label_cipcode3 60101 "06.0101 - Business and Management, General", add 
label define label_cipcode3 60201 "06.0201 - Accounting", add 
label define label_cipcode3 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode3 60401 "06.0401 - Business Admin. and Management, General", add 
label define label_cipcode3 60499 "06.0499 - Business Admin. and Management, Other", add 
label define label_cipcode3 60501 "06.0501 - Business Economics", add 
label define label_cipcode3 60701 "06.0701 - Hotel/Motel Management", add 
label define label_cipcode3 60704 "06.0704 - Restaurant Management", add 
label define label_cipcode3 60799 "06.0799 - Institutional Management, Other", add 
label define label_cipcode3 60801 "06.0801 - Insurance and Risk Management", add 
label define label_cipcode3 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode3 61201 "06.1201 - Management Information Systems", add 
label define label_cipcode3 61401 "06.1401 - Marketing Management", add 
label define label_cipcode3 61499 "06.1499 - Marketing Management and Research, Other", add 
label define label_cipcode3 61701 "06.1701 - Real Estate", add 
label define label_cipcode3 61801 "06.1801 - Small Business Management and Ownership", add 
label define label_cipcode3 61901 "06.1901 - Taxation", add 
label define label_cipcode3 62001 "06.2001 - Trade and Industrial Supervision and  Management", add 
label define label_cipcode3 69999 "06.9999 - Business and Management, Other", add 
label define label_cipcode3 70101 "07.0101 - Accounting, Bookkeeping and Related Programs", add 
label define label_cipcode3 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode3 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode3 70104 "07.0104 - Machine Billing, Bookeeping, and Computing", add 
label define label_cipcode3 70199 "07.0199 - Accounting, Bookkeeping, and Related Programs, Other", add 
label define label_cipcode3 70201 "07.0201 - Banking and Related Financial Programs, General", add 
label define label_cipcode3 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode3 70205 "07.0205 - Teller", add 
label define label_cipcode3 70299 "07.0299 - Banking and Related Financial Programs, Other", add 
label define label_cipcode3 70301 "07.0301 - Business Data Process and Related Programs, General", add 
label define label_cipcode3 70302 "07.0302 - Business Computer and Console Operation", add 
label define label_cipcode3 70303 "07.0303 - Business Data Entry Equipment Operation", add 
label define label_cipcode3 70601 "07.0601 - Secretarial and Related Programs, General", add 
label define label_cipcode3 70602 "07.0602 - Court Reporting", add 
label define label_cipcode3 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode3 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode3 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode3 70606 "07.0606 - Secretarial", add 
label define label_cipcode3 70607 "07.0607 - Stenographic", add 
label define label_cipcode3 70699 "07.0699 - Secretarial and Related Programs, Other", add 
label define label_cipcode3 70701 "07.0701 - Typing, General Office and Related Programs", add 
label define label_cipcode3 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode3 70705 "07.0705 - General Office Clerk", add 
label define label_cipcode3 70707 "07.0707 - Receptionist", add 
label define label_cipcode3 70799 "07.0799 - Typing General Office and Related Programs, Other", add 
label define label_cipcode3 70801 "07.0801 - Word Processing", add 
label define label_cipcode3 79999 "07.9999 - Business (Admin Supp), Other", add 
label define label_cipcode3 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode3 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode3 80199 "08.0199 - Apparel and Accessories Marketing Operations, Other", add 
label define label_cipcode3 80201 "08.0201 - Business and Personal Services Marketing, General", add 
label define label_cipcode3 80401 "08.0401 - Financial Services Marketing Operations", add 
label define label_cipcode3 80502 "08.0502 - Marketing operations/marketing and distribution, other", add 
label define label_cipcode3 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode3 80706 "08.0706 - General Selling Skills and Sales Operations", add 
label define label_cipcode3 81101 "08.1101 - Transportation and Travel Marketing, General", add 
label define label_cipcode3 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode3 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode3 81199 "08.1199 - Tourism and Travel Services Marketing Operations, Other", add 
label define label_cipcode3 90801 "09.0801 - Telecommunictions", add 
label define label_cipcode3 100103 "10.0103 - Photographic Tech./Technician", add 
label define label_cipcode3 100104 "10.0104 - Radio and Television Broadcasting Tech.", add 
label define label_cipcode3 100105 "10.0105 - Sound Recording Technology", add 
label define label_cipcode3 100199 "10.0199 - Communications Technol./Technicians, Other", add 
label define label_cipcode3 110101 "11.0101 - Computer and Information Sciences, General", add 
label define label_cipcode3 110201 "11.0201 - Computer Programming", add 
label define label_cipcode3 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode3 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode3 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode3 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode3 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode3 120101 "12.0101 - Drycleaning and Laundering Services", add 
label define label_cipcode3 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode3 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode3 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode3 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode3 120405 "12.0405 - Massage", add 
label define label_cipcode3 120406 "12.0406 - Make-up Artist", add 
label define label_cipcode3 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode3 129999 "12.9999 - Personal and Miscellaneous Services, Other", add 
label define label_cipcode3 130101 "13.0101 - Education, General", add 
label define label_cipcode3 130403 "13.0403 - Adult and Continuing Education Admintration", add 
label define label_cipcode3 130499 "13.0499 - Education Admin. and Supervision, Other", add 
label define label_cipcode3 131204 "13.1204 - Pre-Elementary Education/Early Childhd/Kindergarten Teacher Education", add 
label define label_cipcode3 131299 "13.1299 - General Teacher Education, Other", add 
label define label_cipcode3 131319 "13.1319 - Technical Teacher Education (Vocational)", add 
label define label_cipcode3 131399 "13.1399 - Teacher Education, Specific Academic and Vocational Programs, Other", add 
label define label_cipcode3 131401 "13.1401 - Teaching ESL/Foreign Language", add 
label define label_cipcode3 131501 "13.1501 - Teacher Assistant/Aide", add 
label define label_cipcode3 142301 "14.2301 - Nuclear Engineering", add 
label define label_cipcode3 149999 "14.9999 - Engineering, Other", add 
label define label_cipcode3 150202 "15.0202 - Drafting and Design Technology", add 
label define label_cipcode3 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode3 150303 "15.0303 - Electrical, Electronic and Communications Engineering Tech./Technician", add 
label define label_cipcode3 150399 "15.0399 - Electrical and Electronic Engineering-Related Tech./Technician, Other", add 
label define label_cipcode3 150402 "15.0402 - Computer Maintenance Tech./Technician", add 
label define label_cipcode3 150405 "15.0405 - Robotics Tech./Technician", add 
label define label_cipcode3 150501 "15.0501 - Heating, Air Conditioning and Refrigeration Tech./Technician", add 
label define label_cipcode3 150599 "15.0599 - Environmental Control Tech., Other", add 
label define label_cipcode3 150610 "15.0610 - Welding Technology", add 
label define label_cipcode3 150803 "15.0803 - Automotive Engineering Tech./Technician", add 
label define label_cipcode3 150805 "15.0805 - Mechanical Engineering/Mechanical Tech.", add 
label define label_cipcode3 159999 "15.9999 - Engineering-Related Tech./Technician, Other", add 
label define label_cipcode3 169999 "16.9999 - Foreign Languages and Literatures, Other", add 
label define label_cipcode3 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode3 170103 "17.0103 - Dental Laboratory Technology", add 
label define label_cipcode3 170206 "17.0206 - Emergency Med Tech-Paramedic", add 
label define label_cipcode3 170209 "17.0209 - Radiologic (Medical) Tech.", add 
label define label_cipcode3 170299 "17.0299 - Diagnstic and Treatment Services, Other", add 
label define label_cipcode3 170308 "17.0308 - Histologic Technology", add 
label define label_cipcode3 170309 "17.0309 - Medical Laboratory Technician", add 
label define label_cipcode3 170399 "17.0399 - Medical Lab Technologies/Technicians, Other", add 
label define label_cipcode3 170405 "17.0405 - Mental Health/Hum Services, Assistant", add 
label define label_cipcode3 170499 "17.0499 - Ment Health/Human Services, Other", add 
label define label_cipcode3 170502 "17.0502 - Central Supply Technology", add 
label define label_cipcode3 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode3 170505 "17.0505 - Medical Office Management", add 
label define label_cipcode3 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode3 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode3 170513 "17.0513 - Health Unit Coordinating", add 
label define label_cipcode3 170599 "17.0599 - Misc Allied Health Services, Other", add 
label define label_cipcode3 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode3 170605 "17.0605 - Practical Nursing", add 
label define label_cipcode3 170606 "17.0606 - Health Unit Management", add 
label define label_cipcode3 170814 "17.0814 - Physical Therapy Aide", add 
label define label_cipcode3 170818 "17.0818 - Respiratory Therapy", add 
label define label_cipcode3 170819 "17.0819 - Respiratory Therapy Assistant", add 
label define label_cipcode3 179999 "17.9999 - Allied Health, Other", add 
label define label_cipcode3 181026 "18.1026 - Surgery", add 
label define label_cipcode3 181199 "18.1199 - Nursing, Other", add 
label define label_cipcode3 182299 "18.2299 - Public Health, Other", add 
label define label_cipcode3 190703 "19.0703 - Family and Marriage Counseling", add 
label define label_cipcode3 190902 "19.0902 - Fashion Design", add 
label define label_cipcode3 190999 "19.0999 - Textiles and Clothing, Other", add 
label define label_cipcode3 200102 "20.0102 - Child Development, Care and Guidance", add 
label define label_cipcode3 200203 "20.0203 - Child Care Services Manager", add 
label define label_cipcode3 200303 "20.0303 - Commercial Garment and Apparel Worker", add 
label define label_cipcode3 200399 "20.0399 - Clothing, Apparel and Textile Workers and Managers, Other", add 
label define label_cipcode3 200402 "20.0402 - Baking", add 
label define label_cipcode3 200403 "20.0403 - Chef/Cook", add 
label define label_cipcode3 200405 "20.0405 - Food Caterer", add 
label define label_cipcode3 200406 "20.0406 - Food Service", add 
label define label_cipcode3 200499 "20.0499 - Institutional Food Workers and Administrators, Other", add 
label define label_cipcode3 200504 "20.0504 - Floral Design", add 
label define label_cipcode3 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode3 210101 "21.0101 - Technology Education/Industrial Arts", add 
label define label_cipcode3 210102 "21.0102 - Construction", add 
label define label_cipcode3 210103 "21.0103 - Drafting and Design", add 
label define label_cipcode3 210106 "21.0106 - Graphic Arts", add 
label define label_cipcode3 210107 "21.0107 - Manufacturing/Materials Processing", add 
label define label_cipcode3 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode3 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode3 231201 "23.1201 - English as a Second Language", add 
label define label_cipcode3 240101 "24.0101 - Liberal Arts and Sciences/Liberal Studies", add 
label define label_cipcode3 240102 "24.0102 - General Studies", add 
label define label_cipcode3 250401 "25.0401 - Library Science", add 
label define label_cipcode3 260706 "26.0706 - Physiology, Human and Animal", add 
label define label_cipcode3 280501 "28.0501 - Maritime Sci (Merch Marine)", add 
label define label_cipcode3 310201 "31.0201 - Outdoor Recreation", add 
label define label_cipcode3 320101 "32.0101 - Basic Skills, General", add 
label define label_cipcode3 320102 "32.0102 - Academic and Intellectual Skills", add 
label define label_cipcode3 320103 "32.0103 - Communication Skills", add 
label define label_cipcode3 320105 "32.0105 - Job Seeking/Changing Skills", add 
label define label_cipcode3 320107 "32.0107 - Career exploration", add 
label define label_cipcode3 340104 "34.0104 - Addiction Prevention and Treatment", add 
label define label_cipcode3 340199 "34.0199 - Health-Related Knowledge and Skills, Other", add 
label define label_cipcode3 350102 "35.0102 - Building human relationships", add 
label define label_cipcode3 350199 "35.0199 - Interpersonal Social Skills, Other", add 
label define label_cipcode3 360109 "36.0109 - Travel and Exploration", add 
label define label_cipcode3 360199 "36.0199 - Leisure and Recreational Activities, Other", add 
label define label_cipcode3 370104 "37.0104 - Self-Esteem and Values Clarification", add 
label define label_cipcode3 380101 "38.0101 - Philosophy", add 
label define label_cipcode3 389999 "38.9999 - Philosophy and Religion", add 
label define label_cipcode3 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode3 390601 "39.0601 - Theology/Theological Studies", add 
label define label_cipcode3 399999 "39.9999 - Theological Studies and Rel. Vocations, Other", add 
label define label_cipcode3 419999 "41.9999 - Science Technologies/Technicians, Other", add 
label define label_cipcode3 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode3 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode3 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode3 440101 "44.0101 - Public Affairs, General", add 
label define label_cipcode3 460201 "46.0201 - Carpenter", add 
label define label_cipcode3 460302 "46.0302 - Electrician", add 
label define label_cipcode3 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode3 460410 "46.0410 - Roofing", add 
label define label_cipcode3 460499 "46.0499 - Const. and Bldg. Finishers and Managers, Other", add 
label define label_cipcode3 460503 "46.0503 - Plumbing", add 
label define label_cipcode3 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode3 470101 "47.0101 - Electrical and Electronics Equipment Installer and Repairers, General", add 
label define label_cipcode3 470102 "47.0102 - Business Machine Repairer", add 
label define label_cipcode3 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode3 470105 "47.0105 - Industrial Electronics Installer and Repairer", add 
label define label_cipcode3 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode3 470107 "47.0107 - Motor Repair", add 
label define label_cipcode3 470199 "47.0199 - Electrical and Electronics Equipment Installer and Repairers, Other", add 
label define label_cipcode3 470201 "47.0201 - Heating, Air Conditioning and Refrig. Mechanic and Repairer", add 
label define label_cipcode3 470202 "47.0202 - Cooling and Refrigeration", add 
label define label_cipcode3 470299 "47.0299 - Heat Aircond. and Refrig. Mech., Other", add 
label define label_cipcode3 470402 "47.0402 - Gunsmith", add 
label define label_cipcode3 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode3 470404 "47.0404 - Musical Instrument Repairer", add 
label define label_cipcode3 470408 "47.0408 - Watch, Clock and Jewelry Repairer", add 
label define label_cipcode3 470499 "47.0499 - Miscellaneous Mechanics and Repairers, Other", add 
label define label_cipcode3 470599 "47.0599 - Stationary Energ Sources, Other", add 
label define label_cipcode3 470601 "47.0601 - Vehicle and Mobile Equipment Mechanics and Repairers, General", add 
label define label_cipcode3 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode3 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode3 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode3 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode3 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode3 470699 "47.0699 - Vehicle and Mobile Equip. Mechanic and Repairer", add 
label define label_cipcode3 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode3 480101 "48.0101 - Drafting, General", add 
label define label_cipcode3 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode3 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode3 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode3 480201 "48.0201 - Graphic and Printing Equipment Operator, General", add 
label define label_cipcode3 480203 "48.0203 - Commercial Air", add 
label define label_cipcode3 480205 "48.0205 - Mechanical Typesetter and Composer", add 
label define label_cipcode3 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode3 480299 "48.0299 - Graphic and Printing Equipment Operator, Other", add 
label define label_cipcode3 480303 "48.0303 - Upholsterer", add 
label define label_cipcode3 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode3 480507 "48.0507 - Tool and Die Maker/Technologist", add 
label define label_cipcode3 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode3 480602 "48.0602 - Jewelry Design Fab and Repair", add 
label define label_cipcode3 480699 "48.0699 - Precision Worker, Assorted Materials, Other", add 
label define label_cipcode3 480701 "48.0701 - Woodworkers, General", add 
label define label_cipcode3 480799 "48.0799 - Woodworkers, Other", add 
label define label_cipcode3 490102 "49.0102 - Aircraft Pilot and Navigator (Professional)", add 
label define label_cipcode3 490106 "49.0106 - Flight Attendant", add 
label define label_cipcode3 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode3 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode3 490202 "49.0202 - Construction Equipment Operator", add 
label define label_cipcode3 490205 "49.0205 - Truck, Bus and Other Commercial Vehicle Operators", add 
label define label_cipcode3 490299 "49.0299 - Vehicle and Equipment Operators, Other", add 
label define label_cipcode3 490302 "49.0302 - Barge and Boat Operations", add 
label define label_cipcode3 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode3 490399 "49.0399 - Water Transportation Workers, Other", add 
label define label_cipcode3 500101 "50.0101 - Visual and Performing Arts, General", add 
label define label_cipcode3 500299 "50.0299 - Crafts, Other", add 
label define label_cipcode3 500402 "50.0402 - Graphic Design, Commercial Art and Illustration", add 
label define label_cipcode3 500403 "50.0403 - Illustration Design", add 
label define label_cipcode3 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode3 500601 "50.0601 - Film/Cinema Studies", add 
label define label_cipcode3 500605 "50.0605 - Photography", add 
label define label_cipcode3 500699 "50.0699 - Film/Video and Photographic Arts, Other", add 
label define label_cipcode3 500999 "50.0999 - Music, Other", add 
label define label_cipcode3 509999 "50.9999 - Visual and Performing Arts, Other", add 
label values cipcode3 label_cipcode3
label define label_libfac 1 "Yes, own library" 
label define label_libfac 2 "Yes, shared library", add 
label define label_libfac 3 "Yes, own or shared not known", add 
label define label_libfac 4 "No", add 
label values libfac label_libfac
tab calsys
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
tab facloc6
tab facloc7
tab facloc8
tab facloc9
tab facloc10
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
tab aslib1
tab aslib2
tab aslib3
tab ftstu
tab apfee
tab tfdu
tab tfdi
tab ffind
tab ffper
tab phind
tab phper
tab noftug
tab cghper
tab tuition4
tab profna
tab room
tab board
tab finaid1
tab finaid2
tab finaid3
tab finaid4
tab finaid5
tab finaid6
tab finaid7
tab finaid8
tab jtpa
tab rotc
tab rotc1
tab rotc2
tab rotc3
tab ftslt15
tab facpt
tab facml
tab facmd
tab pg600
tab cipcode1
tab cipcode2
tab cipcode3
tab libfac
summarize avgperc
summarize applfeeu
summarize applfeeg
summarize ffamt
summarize ffmin
summarize ffmax
summarize phamt
summarize tuition1
summarize tuition2
summarize tuition3
summarize tuition5
summarize tuition6
summarize tuition7
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
summarize enrolmnt
summarize prgmoffr
summarize ciptuit1
summarize ciplgth1
summarize cipenrl1
summarize ciptuit2
summarize ciplgth2
summarize cipenrl2
summarize ciptuit3
summarize ciplgth3
summarize cipenrl3
save dct_ic1987_b

