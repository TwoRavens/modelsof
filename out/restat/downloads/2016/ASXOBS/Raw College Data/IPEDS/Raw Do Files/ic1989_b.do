* Created: 6/13/2004 7:17:44 AM
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
insheet using "../Raw Data/ic1989_b_data_stata.csv", comma clear
label data "dct_ic1989_b"
label variable unitid "unitid"
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
label variable chgper "Type of charge for full-time students"
label variable tuition1 "Tuition and fees full-time undergraduate, in-district"
label variable tuition2 "Tuition and fees full-time undergraduate, in-state"
label variable tuition3 "Tuition and fees full-time undergraduate, out-of-state"
label variable tuition4 "No full-time undergraduate students"
label variable tuition5 "Tuition and fees full-time graduate, in-district"
label variable tuition6 "Tuition and fees full-time graduate, in-state"
label variable tuition7 "Tuition and fees full-time graduate, out-of-state"
label variable tuition8 "No full-time graduate students"
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
label variable roombord "Combined charge for room and board"
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
label variable finaid9 "Financial aid, not eligible"
label variable jtpa "Job Training Partnership Act (JTPA)"
label variable rotc "Reserve Officers Training Corps (ROTC)"
label variable rotc1 "Army"
label variable rotc2 "Navy"
label variable rotc3 "Air Force"
label variable ftslt15 "Size of full-time staff"
label variable facpt "All instructional faculty are part-time"
label variable facml "All instructional faculty are military"
label variable facmd "All instructional faculty teach medicine"
label variable enroll88 "1988 fall enrollment count"
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
label define label_chgper 1 "By credit/contact hour" 
label define label_chgper 2 "By program", add 
label define label_chgper 3 "By term", add 
label define label_chgper 4 "By year", add 
label define label_chgper 5 "Other", add 
label values chgper label_chgper
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
label define label_cipcode1 10504 "01.0504 - Pet Grooming" 
label define label_cipcode1 10505 "01.0505 - Animal Trainer", add 
label define label_cipcode1 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode1 10507 "01.0507 - Equestrian/Equine Studies, Horse Management and Training", add 
label define label_cipcode1 10601 "01.0601 - Horticulture Services Operations and Management, General", add 
label define label_cipcode1 10605 "01.0605 - Landscaping Operations and Management", add 
label define label_cipcode1 10699 "01.0699 - Horticulture Services Operations and Management, Other", add 
label define label_cipcode1 20201 "02.0201 - Animal Sciences, General", add 
label define label_cipcode1 20299 "02.0299 - Animal Sciences, Other", add 
label define label_cipcode1 20499 "02.0499 - Plant Sciences, Other", add 
label define label_cipcode1 30509 "03.0509 - Wood Science and Pulp/Paper Technology", add 
label define label_cipcode1 40101 "04.0101 - Architecture and Environmental Design, General", add 
label define label_cipcode1 40201 "04.0201 - Architecture", add 
label define label_cipcode1 40501 "04.0501 - Interior Architecture", add 
label define label_cipcode1 50199 "05.0199 - Area Studies, Other", add 
label define label_cipcode1 60101 "06.0101 - Business and Management, General", add 
label define label_cipcode1 60201 "06.0201 - Accounting", add 
label define label_cipcode1 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode1 60401 "06.0401 - Business Admintration and Management, General", add 
label define label_cipcode1 60402 "06.0402 - Contract Management and Procure/Purchasing", add 
label define label_cipcode1 60499 "06.0499 - Business Admintration and Management, Other", add 
label define label_cipcode1 60701 "06.0701 - Hotel/Motel Management", add 
label define label_cipcode1 60702 "06.0702 - Recreational Enterprises Management", add 
label define label_cipcode1 60704 "06.0704 - Restaurant Management", add 
label define label_cipcode1 60705 "06.0705 - Transportation Management", add 
label define label_cipcode1 60799 "06.0799 - Institutional Management, Other", add 
label define label_cipcode1 60801 "06.0801 - Insurance and Risk Management", add 
label define label_cipcode1 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode1 61101 "06.1101 - Labor/Industrial Relations", add 
label define label_cipcode1 61201 "06.1201 - Management Information Systems", add 
label define label_cipcode1 61701 "06.1701 - Real Estate", add 
label define label_cipcode1 61801 "06.1801 - Small Business Management and Ownership", add 
label define label_cipcode1 61901 "06.1901 - Taxation", add 
label define label_cipcode1 69999 "06.9999 - Business and Management, Other", add 
label define label_cipcode1 70101 "07.0101 - Accounting, Bookkeeping and Related Programs", add 
label define label_cipcode1 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode1 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode1 70199 "07.0199 - Accounting, Bookkeeping, and Related Programs, Other", add 
label define label_cipcode1 70201 "07.0201 - Banking and Related Financial Programs, General", add 
label define label_cipcode1 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode1 70205 "07.0205 - Teller", add 
label define label_cipcode1 70299 "07.0299 - Banking and Related Financial Programs, Other", add 
label define label_cipcode1 70301 "07.0301 - Business Data Process and Related Programs, General", add 
label define label_cipcode1 70302 "07.0302 - Business Computer and Console Operation", add 
label define label_cipcode1 70303 "07.0303 - Business Data Entry Equipment Operation", add 
label define label_cipcode1 70305 "07.0305 - Business Data Programming", add 
label define label_cipcode1 70306 "07.0306 - Business Systems Analysis", add 
label define label_cipcode1 70399 "07.0399 - Business Data Process and Related Programs, Other", add 
label define label_cipcode1 70601 "07.0601 - Secretarial and Related Programs, General", add 
label define label_cipcode1 70602 "07.0602 - Court Reporting", add 
label define label_cipcode1 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode1 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode1 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode1 70606 "07.0606 - Secretarial", add 
label define label_cipcode1 70607 "07.0607 - Stenographic", add 
label define label_cipcode1 70699 "07.0699 - Secretarial and Related Programs, Other", add 
label define label_cipcode1 70701 "07.0701 - Typing, General Office and Related Programs, General", add 
label define label_cipcode1 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode1 70705 "07.0705 - General Office Clerk", add 
label define label_cipcode1 70707 "07.0707 - Receptionist", add 
label define label_cipcode1 70799 "07.0799 - Typing General Office and Related Programs, Other", add 
label define label_cipcode1 70801 "07.0801 - Word Processing", add 
label define label_cipcode1 79999 "07.9999 - Business (Administrative Support), Other", add 
label define label_cipcode1 80101 "08.0101 - Apparel and Accessories Marketing Operations, General", add 
label define label_cipcode1 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode1 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode1 80199 "08.0199 - Apparel and Accessories Marketing Operations, Other", add 
label define label_cipcode1 80301 "08.0301 - Entrepreneurship", add 
label define label_cipcode1 80401 "08.0401 - Financial Services Marketing Operations", add 
label define label_cipcode1 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode1 80601 "08.0601 - Food Products Retailing and Wholesaling Operation, General", add 
label define label_cipcode1 80701 "08.0701 - Auctioneering", add 
label define label_cipcode1 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode1 80706 "08.0706 - General Selling Skills and Sales Operations", add 
label define label_cipcode1 80801 "08.0801 - Home and Office Products Marketing Operatioins, General", add 
label define label_cipcode1 80901 "08.0901 - Hospitality and Recreation Marketing Operations, General", add 
label define label_cipcode1 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode1 81101 "08.1101 - Transportation and Travel Marketing, General", add 
label define label_cipcode1 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode1 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode1 81106 "08.1106 - Warehouse Services Marketing", add 
label define label_cipcode1 81199 "08.1199 - Tourism and Travel Services Marketing Operations, Other", add 
label define label_cipcode1 90101 "09.0101 - Communications, General", add 
label define label_cipcode1 90201 "09.0201 - Advertising", add 
label define label_cipcode1 90401 "09.0401 - Journalism", add 
label define label_cipcode1 90601 "09.0601 - Radio/TV News Broadcasting", add 
label define label_cipcode1 90701 "09.0701 - Radio and Television Broadcasting", add 
label define label_cipcode1 90801 "09.0801 - Telecommunictions", add 
label define label_cipcode1 99999 "09.9999 - Communications, Other", add 
label define label_cipcode1 100102 "10.0102 - Motion Picture Technology", add 
label define label_cipcode1 100103 "10.0103 - Photographic Technology/Technician", add 
label define label_cipcode1 100104 "10.0104 - Radio and Television Broadcasting Technology", add 
label define label_cipcode1 100105 "10.0105 - Sound Recording Technology", add 
label define label_cipcode1 100199 "10.0199 - Communications Technol./Technicians, Other", add 
label define label_cipcode1 110101 "11.0101 - Computer and Information Sciences, General", add 
label define label_cipcode1 110201 "11.0201 - Computer Programming", add 
label define label_cipcode1 110301 "11.0301 - Data Processing Technology/Technician", add 
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
label define label_cipcode1 130401 "13.0401 - Education Admin. and Supervision, General", add 
label define label_cipcode1 130405 "13.0405 - Elementary, Middle and Secondary Education Administration", add 
label define label_cipcode1 130499 "13.0499 - Education Admin. and Supervision, Other", add 
label define label_cipcode1 131006 "13.1006 - Education of the Mentally Handicapped", add 
label define label_cipcode1 131010 "13.1010 - Remedial Education", add 
label define label_cipcode1 131201 "13.1201 - Adult and Continuing Teacher Education", add 
label define label_cipcode1 131204 "13.1204 - Pre-Elementary Education/Early Childhd/Kindergarten Teacher Education", add 
label define label_cipcode1 131317 "13.1317 - Social Science Teacher Education", add 
label define label_cipcode1 131399 "13.1399 - Teacher Education, Specific Academic and Vocational Programs, Other", add 
label define label_cipcode1 131401 "13.1401 - Teaching ESL/Foreign Language", add 
label define label_cipcode1 131501 "13.1501 - Teacher Assistant/Aide", add 
label define label_cipcode1 139999 "13.9999 - Education, Other", add 
label define label_cipcode1 140101 "14.0101 - Engineering, General", add 
label define label_cipcode1 141001 "14.1001 - Electrical, Electronics and Communication", add 
label define label_cipcode1 141301 "14.1301 - Engineering Science", add 
label define label_cipcode1 149999 "14.9999 - Engineering, Other", add 
label define label_cipcode1 150199 "15.0199 - Architectural Engineering Technology/Technician", add 
label define label_cipcode1 150202 "15.0202 - Drafting and Design Technology", add 
label define label_cipcode1 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode1 150302 "15.0302 - Electrical Technology", add 
label define label_cipcode1 150303 "15.0303 - Electrical, Electronic and Communications Engineering Tech./Technician", add 
label define label_cipcode1 150399 "15.0399 - Electrical and Electronic Engineering-Related Tech./Technician, Other", add 
label define label_cipcode1 150401 "15.0401 - Biomedical Engineering-Related Tech./Technician", add 
label define label_cipcode1 150402 "15.0402 - Computer Maintenance Tech./Technician", add 
label define label_cipcode1 150499 "15.0499 - Electromechanical Instrumentation and Maintenance Tech./Technicians, Other", add 
label define label_cipcode1 150501 "15.0501 - Heating, Air Conditioning and Refrigeration Technician", add 
label define label_cipcode1 150599 "15.0599 - Environmental Control Tech., Other", add 
label define label_cipcode1 150701 "15.0701 - Occupational Safety and Health Tech./Technician", add 
label define label_cipcode1 150702 "15.0702 - Quality Control Technology/Technician", add 
label define label_cipcode1 150803 "15.0803 - Automotive Engineering Technology/Technician", add 
label define label_cipcode1 150805 "15.0805 - Mechanical Engineering/Mechanical Technology", add 
label define label_cipcode1 159999 "15.9999 - Engineering-Related Technology/Technician, Other", add 
label define label_cipcode1 160101 "16.0101 - Foreign Languages and Literatures, General", add 
label define label_cipcode1 160905 "16.0905 - Spanish Language and Literature", add 
label define label_cipcode1 169999 "16.9999 - Foreign Languages and Literatures, Other", add 
label define label_cipcode1 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode1 170103 "17.0103 - Dental Laboratory Technology", add 
label define label_cipcode1 170199 "17.0199 - Dental Services, Other", add 
label define label_cipcode1 170201 "17.0201 - Cardiovascular Technology", add 
label define label_cipcode1 170203 "17.0203 - Electrocardiograph Technology", add 
label define label_cipcode1 170205 "17.0205 - Emergency Med Tech-Ambulance", add 
label define label_cipcode1 170206 "17.0206 - Emergency Med Tech-Paramedic", add 
label define label_cipcode1 170207 "17.0207 - Medical Radiation Dosimetry", add 
label define label_cipcode1 170208 "17.0208 - Nuclear Medical Technology", add 
label define label_cipcode1 170209 "17.0209 - Radiologic (Medical) Technology", add 
label define label_cipcode1 170210 "17.0210 - Respiratory Therapy Technician", add 
label define label_cipcode1 170211 "17.0211 - Surgical Technology", add 
label define label_cipcode1 170212 "17.0212 - Diagnostic Medical Sonography", add 
label define label_cipcode1 170299 "17.0299 - Diagnstic and Treatment Services, Other", add 
label define label_cipcode1 170301 "17.0301 - Blood Bank Technology", add 
label define label_cipcode1 170308 "17.0308 - Histologic Technology", add 
label define label_cipcode1 170309 "17.0309 - Medical Laboratory Technician", add 
label define label_cipcode1 170310 "17.0310 - Medical Technology", add 
label define label_cipcode1 170311 "17.0311 - Microbiology Technician", add 
label define label_cipcode1 170401 "17.0401 - Alcohol/Drug Abuse Specialty", add 
label define label_cipcode1 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode1 170499 "17.0499 - Mental Health/Human Services, Other", add 
label define label_cipcode1 170502 "17.0502 - Central Supply Technology", add 
label define label_cipcode1 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode1 170504 "17.0504 - Medical Illustrating", add 
label define label_cipcode1 170505 "17.0505 - Medical Office Management", add 
label define label_cipcode1 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode1 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode1 170514 "17.0514 - Chiropractic Assisting", add 
label define label_cipcode1 170599 "17.0599 - Misc Allied Health Services, Other", add 
label define label_cipcode1 170601 "17.0601 - Geriatric Aide", add 
label define label_cipcode1 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode1 170605 "17.0605 - Practical Nursing", add 
label define label_cipcode1 170699 "17.0699 - Nursing-Related Services, Other", add 
label define label_cipcode1 170701 "17.0701 - Ophthalmic Dispensing", add 
label define label_cipcode1 170799 "17.0799 - Ophthalmic Services, Other", add 
label define label_cipcode1 170812 "17.0812 - Orthopedic Assistants, Other", add 
label define label_cipcode1 170818 "17.0818 - Respiratory Therapy", add 
label define label_cipcode1 170819 "17.0819 - Respiratory Therapy Assistant", add 
label define label_cipcode1 170899 "17.0899 - Rehabilitation Services, Other", add 
label define label_cipcode1 179999 "17.9999 - Allied Health, Other", add 
label define label_cipcode1 180406 "18.0406 - Orthodontics", add 
label define label_cipcode1 180799 "18.0799 - Health Services Administration, Other", add 
label define label_cipcode1 180901 "18.0901 - Medical Laboratory", add 
label define label_cipcode1 181001 "18.1001 - Medical, General", add 
label define label_cipcode1 181012 "18.1012 - Nuclear Medicine Residency", add 
label define label_cipcode1 181025 "18.1025 - Radiology", add 
label define label_cipcode1 181099 "18.1099 - Medicine, Other", add 
label define label_cipcode1 181101 "18.1101 - Nursing, General", add 
label define label_cipcode1 181199 "18.1199 - Nursing, Other", add 
label define label_cipcode1 181401 "18.1401 - Pharmacy", add 
label define label_cipcode1 182001 "18.2001 - Pre-Veterinary", add 
label define label_cipcode1 182401 "18.2401 - Veterinary Medicine", add 
label define label_cipcode1 189999 "18.9999 - Health Sciences, Other", add 
label define label_cipcode1 190501 "19.0501 - Foods and Nutrition Studies, General", add 
label define label_cipcode1 190503 "19.0503 - Dietetics/Human Nutritional Services", add 
label define label_cipcode1 190599 "19.0599 - Foods and Nutrition Studies, Other", add 
label define label_cipcode1 190901 "19.0901 - Clothing/Apparel and Textile Studies", add 
label define label_cipcode1 190902 "19.0902 - Fashion Design", add 
label define label_cipcode1 200102 "20.0102 - Child Development, Care and Guidance", add 
label define label_cipcode1 200201 "20.0201 - Child Care/Guidance Workers and Managers, General", add 
label define label_cipcode1 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode1 200203 "20.0203 - Child Care Services Manager", add 
label define label_cipcode1 200299 "20.0299 - Child Care/Guidance Workers and Managers, Other", add 
label define label_cipcode1 200301 "20.0301 - Clothing, Apparel and Textile Workers and Managers, General", add 
label define label_cipcode1 200304 "20.0304 - Custom Apparel/Garment Seamstress", add 
label define label_cipcode1 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode1 200306 "20.0306 - Fashion and Fabric Consultant", add 
label define label_cipcode1 200399 "20.0399 - Clothing, Apparel and Textile Workers and Managers, Other", add 
label define label_cipcode1 200401 "20.0401 - Institutional Food Workers and Administrators, General", add 
label define label_cipcode1 200402 "20.0402 - Baking", add 
label define label_cipcode1 200403 "20.0403 - Chef/Cook", add 
label define label_cipcode1 200405 "20.0405 - Food Caterer", add 
label define label_cipcode1 200406 "20.0406 - Food Service", add 
label define label_cipcode1 200503 "20.0503 - Custom Slipcovering and Uphols", add 
label define label_cipcode1 200504 "20.0504 - Floral Design", add 
label define label_cipcode1 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode1 209999 "20.9999 - Vocational Home Economics, Other", add 
label define label_cipcode1 210103 "21.0103 - Drafting and Design", add 
label define label_cipcode1 210106 "21.0106 - Graphic Arts", add 
label define label_cipcode1 210199 "21.0199 - Industrial Arts, Other", add 
label define label_cipcode1 220101 "22.0101 - Law (LL.B., J.D.)", add 
label define label_cipcode1 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode1 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode1 230101 "23.0101 - English Language and Literature, General", add 
label define label_cipcode1 230501 "23.0501 - English Creative Writing", add 
label define label_cipcode1 230601 "23.0601 - Linguistics", add 
label define label_cipcode1 231201 "23.1201 - English as a Second Language", add 
label define label_cipcode1 239999 "23.9999 - English Language and Literature/Letters, Other", add 
label define label_cipcode1 260402 "26.0402 - Molecular Biology", add 
label define label_cipcode1 269999 "26.9999 - Biological Sciences/Life Sciences, Other", add 
label define label_cipcode1 310201 "31.0201 - Outdoor Recreation", add 
label define label_cipcode1 310401 "31.0401 - Water Resources", add 
label define label_cipcode1 319999 "31.9999 - Parks, Recreation, Leisure and Fitness Studies, Other", add 
label define label_cipcode1 320101 "32.0101 - Basic Skills, General", add 
label define label_cipcode1 320102 "32.0102 - Academic and Intellectual Skills", add 
label define label_cipcode1 320105 "32.0105 - Job Seeking/Changing Skills", add 
label define label_cipcode1 320199 "32.0199 - Basic Skills, Other", add 
label define label_cipcode1 340103 "34.0103 - Personal Health Improvemente and Maintenance", add 
label define label_cipcode1 340104 "34.0104 - Addiction Prevention and Treatment", add 
label define label_cipcode1 350101 "35.0101 - Interpersonal skills, general", add 
label define label_cipcode1 350199 "35.0199 - Interpersonal Social Skills, Other", add 
label define label_cipcode1 360101 "36.0101 - Leisure and Recreational Activities, General", add 
label define label_cipcode1 360107 "36.0107 - Pet care", add 
label define label_cipcode1 360109 "36.0109 - Travel and Exploration", add 
label define label_cipcode1 360199 "36.0199 - Leisure and Recreational Activities, Other", add 
label define label_cipcode1 370104 "37.0104 - Self-Esteem and Values Clarification", add 
label define label_cipcode1 370199 "37.0199 - Personal Awareness and Self-Improvement, Other", add 
label define label_cipcode1 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode1 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode1 390301 "39.0301 - Missions/Missionary Studies and Misology", add 
label define label_cipcode1 390601 "39.0601 - Theology/Theological Studies", add 
label define label_cipcode1 399999 "39.9999 - Theological Studies and Rel. Vocations, Other", add 
label define label_cipcode1 400702 "40.0702 - Oceanography", add 
label define label_cipcode1 400799 "40.0799 - Miscellaneous Physical Sciences, Other", add 
label define label_cipcode1 410202 "41.0202 - Nuclear Power Plant Operation Technology", add 
label define label_cipcode1 419999 "41.9999 - Science Technologies/Technicians, Other", add 
label define label_cipcode1 420201 "42.0201 - Clinical Psychology", add 
label define label_cipcode1 429999 "42.9999 - Psychology, Other", add 
label define label_cipcode1 430102 "43.0102 - Corrections/Correctional Administration", add 
label define label_cipcode1 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode1 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode1 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode1 430203 "43.0203 - Fire Science/Firefighting", add 
label define label_cipcode1 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode1 440101 "44.0101 - Public Affairs, General", add 
label define label_cipcode1 449999 "44.9999 - Public Administration and Services, Other", add 
label define label_cipcode1 450601 "45.0601 - Economics, General", add 
label define label_cipcode1 450701 "45.0701 - Geography", add 
label define label_cipcode1 451001 "45.1001 - Political Science, General", add 
label define label_cipcode1 459999 "45.9999 - Social Sciences and History, Other", add 
label define label_cipcode1 460199 "46.0199 - Brickmasonry, Stonemasonry, and Tile Setter", add 
label define label_cipcode1 460201 "46.0201 - Carpenter", add 
label define label_cipcode1 460302 "46.0302 - Electrician", add 
label define label_cipcode1 460401 "46.0401 - Building/Property Maintenance and Management", add 
label define label_cipcode1 460403 "46.0403 - Construction/Building Inspector", add 
label define label_cipcode1 460408 "46.0408 - Painter and Wall Coverer", add 
label define label_cipcode1 460499 "46.0499 - Construction and Building Finishers and Managers, Other", add 
label define label_cipcode1 460599 "46.0599 - Plumbing, Pipefitting and Steamfitting, Other", add 
label define label_cipcode1 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode1 470101 "47.0101 - Electrical and Electronics Equipment Installer and Repairers, General", add 
label define label_cipcode1 470103 "47.0103 - Communication Systems Installer and Repairer", add 
label define label_cipcode1 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode1 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode1 470199 "47.0199 - Electrical and Electronics Equipment Installer and Repairers, Other", add 
label define label_cipcode1 470201 "47.0201 - Heating, Air Conditioning and Refrigeration Mechanic and Repairer", add 
label define label_cipcode1 470202 "47.0202 - Cooling and Refrigeration", add 
label define label_cipcode1 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode1 470299 "47.0299 - Heat Airconditioning and Refrigeration Mechanic and Repairer, Other", add 
label define label_cipcode1 470301 "47.0301 - Industrial Equipment Maintenance and Repairers, General", add 
label define label_cipcode1 470399 "47.0399 - Industrial Equipment Maintenance and Repairers, Other", add 
label define label_cipcode1 470402 "47.0402 - Gunsmith", add 
label define label_cipcode1 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode1 470404 "47.0404 - Musical Instrument Repairer", add 
label define label_cipcode1 470408 "47.0408 - Watch, Clock and Jewelry Repairer", add 
label define label_cipcode1 470499 "47.0499 - Miscellaneous Mechanics and Repairers, Other", add 
label define label_cipcode1 470501 "47.0501 - Stationary Energy Sources Installer/Operator", add 
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
label define label_cipcode1 480206 "48.0206 - Lithographer and Platemaker", add 
label define label_cipcode1 480209 "48.0209 - Silk Screen Making and Printing", add 
label define label_cipcode1 480299 "48.0299 - Graphic and Printing Equipment Operator, Other", add 
label define label_cipcode1 480302 "48.0302 - Leatherworkers and Upholsterers, Other", add 
label define label_cipcode1 480303 "48.0303 - Upholsterer", add 
label define label_cipcode1 480402 "48.0402 - Meatcutting", add 
label define label_cipcode1 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode1 480506 "48.0506 - Sheet Metal Worker", add 
label define label_cipcode1 480507 "48.0507 - Tool and Die Maker/Technologist", add 
label define label_cipcode1 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode1 480599 "48.0599 - Precision Metal Workers, Other", add 
label define label_cipcode1 480602 "48.0602 - Jewelry Design Fab and Repair", add 
label define label_cipcode1 480799 "48.0799 - Woodworkers, Other", add 
label define label_cipcode1 489999 "48.9999 - Precision Production Trades, Other", add 
label define label_cipcode1 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode1 490102 "49.0102 - Aircraft Pilot and Navigator (Professional)", add 
label define label_cipcode1 490104 "49.0104 - Aviation Management", add 
label define label_cipcode1 490106 "49.0106 - Flight Attendant", add 
label define label_cipcode1 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode1 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode1 490201 "49.0201 - Vehicle and Equipment Operators, General", add 
label define label_cipcode1 490202 "49.0202 - Construction Equipment Operator", add 
label define label_cipcode1 490205 "49.0205 - Truck, Bus and Other Commercial Vehicle Operators", add 
label define label_cipcode1 490299 "49.0299 - Vehicle and Equipment Operators, Other", add 
label define label_cipcode1 490301 "49.0301 - Water Transportation, General", add 
label define label_cipcode1 490302 "49.0302 - Barge and Boat Operations", add 
label define label_cipcode1 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode1 490308 "49.0308 - Sailors and Deckhands", add 
label define label_cipcode1 490399 "49.0399 - Water Transportation Workers, Other", add 
label define label_cipcode1 499999 "49.9999 - Transportation and Materials Moving Workers, Other", add 
label define label_cipcode1 500101 "50.0101 - Visual and Performing Arts, General", add 
label define label_cipcode1 500205 "50.0205 - Glass", add 
label define label_cipcode1 500206 "50.0206 - Metal/Jewelry", add 
label define label_cipcode1 500299 "50.0299 - Crafts, Other", add 
label define label_cipcode1 500301 "50.0301 - Dance", add 
label define label_cipcode1 500401 "50.0401 - Design and Visual Communications", add 
label define label_cipcode1 500402 "50.0402 - Graphic Design, Commercial Art and Illustration", add 
label define label_cipcode1 500499 "50.0499 - Design and Applied Arts, Other", add 
label define label_cipcode1 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode1 500601 "50.0601 - Film/Cinema Studies", add 
label define label_cipcode1 500605 "50.0605 - Photography", add 
label define label_cipcode1 500699 "50.0699 - Film/Video and Photographic Arts, Other", add 
label define label_cipcode1 500708 "50.0708 - Painting", add 
label define label_cipcode1 500799 "50.0799 - Fine Arts and Art Studies, Other", add 
label define label_cipcode1 500999 "50.0999 - Music, Other", add 
label define label_cipcode1 509999 "50.9999 - Visual and Performing Arts, Other", add 
label values cipcode1 label_cipcode1
label define label_cipcode2 10504 "01.0504 - Pet Grooming" 
label define label_cipcode2 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode2 10507 "01.0507 - Equestrian/Equine Studies, Horse Management and Training", add 
label define label_cipcode2 10599 "01.0599 - Agricultural Supplies and Related Services, Other", add 
label define label_cipcode2 10699 "01.0699 - Horticulture Services Operations and Management, Other", add 
label define label_cipcode2 39999 "03.9999 - Conservation and Renewable Natural Resources, Other", add 
label define label_cipcode2 40501 "04.0501 - Interior Architecture", add 
label define label_cipcode2 60101 "06.0101 - Business and Management, General", add 
label define label_cipcode2 60201 "06.0201 - Accounting", add 
label define label_cipcode2 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode2 60401 "06.0401 - Business Admintration and Management, General", add 
label define label_cipcode2 60499 "06.0499 - Business Admintration and Management, Other", add 
label define label_cipcode2 60701 "06.0701 - Hotel/Motel Management", add 
label define label_cipcode2 60702 "06.0702 - Recreational Enterprises Management", add 
label define label_cipcode2 60704 "06.0704 - Restaurant Management", add 
label define label_cipcode2 60801 "06.0801 - Insurance and Risk Management", add 
label define label_cipcode2 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode2 61201 "06.1201 - Management Information Systems", add 
label define label_cipcode2 61701 "06.1701 - Real Estate", add 
label define label_cipcode2 61901 "06.1901 - Taxation", add 
label define label_cipcode2 69999 "06.9999 - Business and Management, Other", add 
label define label_cipcode2 70101 "07.0101 - Accounting, Bookkeeping and Related Programs", add 
label define label_cipcode2 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode2 70104 "07.0104 - Machine Billing, Bookeeping, and Computing", add 
label define label_cipcode2 70199 "07.0199 - Accounting, Bookkeeping, and Related Programs, Other", add 
label define label_cipcode2 70201 "07.0201 - Banking and Related Financial Programs, General", add 
label define label_cipcode2 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode2 70299 "07.0299 - Banking and Financial Support Services", add 
label define label_cipcode2 70301 "07.0301 - Business Data Process and Related Programs, General", add 
label define label_cipcode2 70302 "07.0302 - Business Computer and Console Operation", add 
label define label_cipcode2 70303 "07.0303 - Business Data Entry Equipment Operation", add 
label define label_cipcode2 70304 "07.0304 - Business Data Peripheral Equipment Operation", add 
label define label_cipcode2 70399 "07.0399 - Business Data Process and Related Programs, Other", add 
label define label_cipcode2 70401 "07.0401 - Office Supervision and Management", add 
label define label_cipcode2 70601 "07.0601 - Secretarial and Related Programs, General", add 
label define label_cipcode2 70602 "07.0602 - Court Reporting", add 
label define label_cipcode2 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode2 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode2 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode2 70606 "07.0606 - Secretarial", add 
label define label_cipcode2 70607 "07.0607 - Stenographic", add 
label define label_cipcode2 70699 "07.0699 - Secretarial and Related Programs, Other", add 
label define label_cipcode2 70701 "07.0701 - Typing, General Office and Related Programs, General", add 
label define label_cipcode2 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode2 70705 "07.0705 - General Office Clerk", add 
label define label_cipcode2 70709 "07.0709 - Traffic Rate and Transportation Clerk", add 
label define label_cipcode2 70799 "07.0799 - Typing General Office and Related Programs, Other", add 
label define label_cipcode2 70801 "07.0801 - Word Processing", add 
label define label_cipcode2 79999 "07.9999 - Business (Administrative Support), Other", add 
label define label_cipcode2 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode2 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode2 80199 "08.0199 - Apparel and Accessories Marketing Operations, Other", add 
label define label_cipcode2 80201 "08.0201 - Business and Personal Services Marketing, General", add 
label define label_cipcode2 80401 "08.0401 - Financial Services Marketing Operations", add 
label define label_cipcode2 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode2 80701 "08.0701 - Auctioneering", add 
label define label_cipcode2 80703 "08.0703 - International Marketing", add 
label define label_cipcode2 80704 "08.0704 - General Buying Operations", add 
label define label_cipcode2 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode2 80706 "08.0706 - General Selling Skills and Sales Operations", add 
label define label_cipcode2 80806 "08.0806 - Hardware Marketing", add 
label define label_cipcode2 80901 "08.0901 - Hospitality and Recreation Marketing Operations, General", add 
label define label_cipcode2 80903 "08.0903 - Recreation Products/Services Marketing Operations", add 
label define label_cipcode2 80999 "08.0999 - Hospitality and Recreation Marketing Operation, Other", add 
label define label_cipcode2 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode2 81101 "08.1101 - Transportation and Travel Marketing, General", add 
label define label_cipcode2 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode2 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode2 81106 "08.1106 - Warehouse Services Marketing", add 
label define label_cipcode2 81199 "08.1199 - Tourism and Travel Services Marketing Operations, Other", add 
label define label_cipcode2 90101 "09.0101 - Communications, General", add 
label define label_cipcode2 90201 "09.0201 - Advertising", add 
label define label_cipcode2 90601 "09.0601 - Radio/TV News Broadcasting", add 
label define label_cipcode2 90801 "09.0801 - Telecommunictions", add 
label define label_cipcode2 99999 "09.9999 - Communications, Other", add 
label define label_cipcode2 100103 "10.0103 - Photographic Technology/Technician", add 
label define label_cipcode2 100104 "10.0104 - Radio and Television Broadcasting Technology", add 
label define label_cipcode2 100105 "10.0105 - Sound Recording Technology", add 
label define label_cipcode2 100106 "10.0106 - Video Technology", add 
label define label_cipcode2 110101 "11.0101 - Computer and Information Sciences, General", add 
label define label_cipcode2 110201 "11.0201 - Computer Programming", add 
label define label_cipcode2 110301 "11.0301 - Data Processing Technology/Technician", add 
label define label_cipcode2 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode2 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode2 120101 "12.0101 - Drycleaning and Laundering Services", add 
label define label_cipcode2 120202 "12.0202 - Bartending", add 
label define label_cipcode2 120203 "12.0203 - Card Dealer", add 
label define label_cipcode2 120301 "12.0301 - Funeral Services and Mortuary Science", add 
label define label_cipcode2 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode2 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode2 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode2 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode2 120405 "12.0405 - Massage", add 
label define label_cipcode2 120406 "12.0406 - Make-up Artist", add 
label define label_cipcode2 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode2 129999 "12.9999 - Personal and Miscellaneous Services, Other", add 
label define label_cipcode2 130301 "13.0301 - Curriculum and Instruction", add 
label define label_cipcode2 131201 "13.1201 - Adult and Continuing Teacher Education", add 
label define label_cipcode2 131202 "13.1202 - Elementary Teacher Education", add 
label define label_cipcode2 131204 "13.1204 - Pre-Elementary Education/Early Childhd/Kindergarten Teacher Education", add 
label define label_cipcode2 131299 "13.1299 - General Teacher Education, Other", add 
label define label_cipcode2 131303 "13.1303 - Business Teacher Education (Vocational)", add 
label define label_cipcode2 131399 "13.1399 - Teacher Education, Specific Academic and Vocational Programs, Other", add 
label define label_cipcode2 131401 "13.1401 - Teaching ESL/Foreign Language", add 
label define label_cipcode2 139999 "13.9999 - Education, Other", add 
label define label_cipcode2 141001 "14.1001 - Electrical, Electronics and Communication Engineering", add 
label define label_cipcode2 149999 "14.9999 - Engineering, Other", add 
label define label_cipcode2 150101 "15.0101 - Architectural Engineering Technology/Technician", add 
label define label_cipcode2 150102 "15.0102 - Architectural Engineering Technology/Technician", add 
label define label_cipcode2 150202 "15.0202 - Drafting and Design Technology", add 
label define label_cipcode2 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode2 150302 "15.0302 - Electrical Technology", add 
label define label_cipcode2 150303 "15.0303 - Electrical, Electronic and Communications Engineering Tech./Technician", add 
label define label_cipcode2 150399 "15.0399 - Electrical and Electronic Engineering-Related Tech./Technician, Other", add 
label define label_cipcode2 150402 "15.0402 - Computer Maintenance Tech./Technician", add 
label define label_cipcode2 150499 "15.0499 - Electromechanical Instrumentation and Maintenance Tech./Technicians, Other", add 
label define label_cipcode2 150501 "15.0501 - Heating, Air Conditioning and Refrigeration Tech./Technician", add 
label define label_cipcode2 150503 "15.0503 - Energy Management and Systems Tech./Technician", add 
label define label_cipcode2 150702 "15.0702 - Quality Control Technology/Technician", add 
label define label_cipcode2 150803 "15.0803 - Automotive Engineering Technology/Technician", add 
label define label_cipcode2 159999 "15.9999 - Engineering-Related Technology/Technician, Other", add 
label define label_cipcode2 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode2 170103 "17.0103 - Dental Laboratory Technology", add 
label define label_cipcode2 170201 "17.0201 - Cardiovascular Technology", add 
label define label_cipcode2 170203 "17.0203 - Electrocardiograph Technology", add 
label define label_cipcode2 170204 "17.0204 - Electroencephalograph Technology", add 
label define label_cipcode2 170205 "17.0205 - Emergency Medical Tech-Ambulance", add 
label define label_cipcode2 170209 "17.0209 - Radiologic (Medical) Technology", add 
label define label_cipcode2 170210 "17.0210 - Respiratory Therapy Technician", add 
label define label_cipcode2 170212 "17.0212 - Diagnostic Medical Sonography", add 
label define label_cipcode2 170305 "17.0305 - Clinical Laboratory Assistant", add 
label define label_cipcode2 170306 "17.0306 - Cytotechnology", add 
label define label_cipcode2 170309 "17.0309 - Medical Laboratory Technician", add 
label define label_cipcode2 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode2 170499 "17.0499 - Ment Health/Human Services, Other", add 
label define label_cipcode2 170502 "17.0502 - Central Supply Technology", add 
label define label_cipcode2 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode2 170505 "17.0505 - Medical Office Management", add 
label define label_cipcode2 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode2 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode2 170513 "17.0513 - Health Unit Coordinating", add 
label define label_cipcode2 170599 "17.0599 - Misc Allied Health Services, Other", add 
label define label_cipcode2 170601 "17.0601 - Geriatric Aide", add 
label define label_cipcode2 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode2 170605 "17.0605 - Practical Nursing", add 
label define label_cipcode2 170606 "17.0606 - Health Unit Management", add 
label define label_cipcode2 170812 "17.0812 - Orthopedic Assistants, Other", add 
label define label_cipcode2 170813 "17.0813 - Physical Therapy", add 
label define label_cipcode2 170814 "17.0814 - Physical Therapy Aide", add 
label define label_cipcode2 170818 "17.0818 - Respiratory Therapy", add 
label define label_cipcode2 170899 "17.0899 - Rehabilitation Services, Other", add 
label define label_cipcode2 179999 "17.9999 - Allied Health, Other", add 
label define label_cipcode2 181101 "18.1101 - Nursing, General", add 
label define label_cipcode2 181104 "18.1104 - Medical Surgical", add 
label define label_cipcode2 181199 "18.1199 - Nursing, Other", add 
label define label_cipcode2 189999 "18.9999 - Health Sciences, Other", add 
label define label_cipcode2 190701 "19.0701 - Individual/Family Devel. Studies, General", add 
label define label_cipcode2 190902 "19.0902 - Fashion Design", add 
label define label_cipcode2 200201 "20.0201 - Child Care/Guidance Workers and Managers, General", add 
label define label_cipcode2 200299 "20.0299 - Child Care/Guidance Workers and Managers, Other", add 
label define label_cipcode2 200304 "20.0304 - Custom Apparel/Garment Seamstress", add 
label define label_cipcode2 200399 "20.0399 - Clothing, Apparel and Textile Workers and Managers, Other", add 
label define label_cipcode2 200401 "20.0401 - Institutional Food Workers and Administrators, General", add 
label define label_cipcode2 200402 "20.0402 - Baking", add 
label define label_cipcode2 200403 "20.0403 - Chef/Cook", add 
label define label_cipcode2 200405 "20.0405 - Food Caterer", add 
label define label_cipcode2 200406 "20.0406 - Food Service", add 
label define label_cipcode2 200499 "20.0499 - Institutional Food Workers and Administrators, Other", add 
label define label_cipcode2 200504 "20.0504 - Floral Design", add 
label define label_cipcode2 200505 "20.0505 - Home Decorating", add 
label define label_cipcode2 200601 "20.0601 - Custodial, Housekeeping and Home Service", add 
label define label_cipcode2 210102 "21.0102 - Construction", add 
label define label_cipcode2 210106 "21.0106 - Graphic Arts", add 
label define label_cipcode2 210199 "21.0199 - Industrial Arts, Other", add 
label define label_cipcode2 220102 "22.0102 - Pre-Law Studies", add 
label define label_cipcode2 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode2 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode2 230501 "23.0501 - English Creative Writing", add 
label define label_cipcode2 231201 "23.1201 - English as a Second Language", add 
label define label_cipcode2 260499 "26.0499 - Cell and Molecular Biology, Other", add 
label define label_cipcode2 309999 "30.9999 - Multi/Interdisciplinary Studies, Other", add 
label define label_cipcode2 320101 "32.0101 - Basic Skills, General", add 
label define label_cipcode2 320107 "32.0107 - Career Exploration", add 
label define label_cipcode2 320199 "32.0199 - Basic Skills, Other", add 
label define label_cipcode2 330199 "33.0199 - Citizenship Activities, Other", add 
label define label_cipcode2 360107 "36.0107 - Pet Ownership and Care", add 
label define label_cipcode2 360109 "36.0109 - Travel and Exploration", add 
label define label_cipcode2 360199 "36.0199 - Leisure and Recreational Activities, Other", add 
label define label_cipcode2 370199 "37.0199 - Personal Awareness and Self-Improvement, Other", add 
label define label_cipcode2 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode2 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode2 399999 "39.9999 - Theological Studies and Rel. Vocations, Other", add 
label define label_cipcode2 410202 "41.0202 - Nuclear Power Plant Operation Technology", add 
label define label_cipcode2 419999 "41.9999 - Science Technologies/Technicians, Other", add 
label define label_cipcode2 420101 "42.0101 - Psychology, General", add 
label define label_cipcode2 430102 "43.0102 - Corrections/Correctional Administration", add 
label define label_cipcode2 430105 "43.0105 - Criminal Justice Technology", add 
label define label_cipcode2 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode2 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode2 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode2 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode2 450201 "45.0201 - Anthropology", add 
label define label_cipcode2 459999 "45.9999 - Social Sciences and History, Other", add 
label define label_cipcode2 460201 "46.0201 - Carpenter", add 
label define label_cipcode2 460302 "46.0302 - Electrician", add 
label define label_cipcode2 460401 "46.0401 - Building/Property Maintenance and Management", add 
label define label_cipcode2 460499 "46.0499 - Construction and Building Finishers and Managers, Other", add 
label define label_cipcode2 460501 "46.0501 - Plumber and Pipefitter", add 
label define label_cipcode2 460502 "46.0502 - Pipefitting and Steamfitting", add 
label define label_cipcode2 460503 "46.0503 - Plumbing", add 
label define label_cipcode2 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode2 470101 "47.0101 - Electrical and Electronics Equipment Installer and Repairers, General", add 
label define label_cipcode2 470103 "47.0103 - Communication Systems Installer and Repairer", add 
label define label_cipcode2 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode2 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode2 470109 "47.0109 - Electrical and Electronics Equipment Installer and Repairer, Other", add 
label define label_cipcode2 470199 "47.0199 - Electrical and Electronics Equipment Installer and Repairers, Other", add 
label define label_cipcode2 470201 "47.0201 - Heating, Air Conditioning and Refrigeration Mechanic and Repairer", add 
label define label_cipcode2 470202 "47.0202 - Cooling and Refrigeration", add 
label define label_cipcode2 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode2 470299 "47.0299 - Heat Airconditioning and Refrigeration Mechanic and Repairer, Other", add 
label define label_cipcode2 470301 "47.0301 - Industrial Equip. Main. and Repairers, General", add 
label define label_cipcode2 470399 "47.0399 - Industrial Equip. Main. and Repairers, Other", add 
label define label_cipcode2 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode2 470404 "47.0404 - Musical Instrument Repairer", add 
label define label_cipcode2 470601 "47.0601 - Vehicle and Mobile Equipment Mechanics and Repairers, Other", add 
label define label_cipcode2 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode2 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode2 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode2 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode2 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode2 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode2 470699 "47.0699 - Vehicle and Mobile Equip. Mechanic and Repairer", add 
label define label_cipcode2 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode2 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode2 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode2 480201 "48.0201 - Graphic and Printing Equipment Operator, General", add 
label define label_cipcode2 480203 "48.0203 - Commercial Air", add 
label define label_cipcode2 480204 "48.0204 - Commercial Photography", add 
label define label_cipcode2 480206 "48.0206 - Lithographer and Platemaker", add 
label define label_cipcode2 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode2 480209 "48.0209 - Silk Screen Making and Printing", add 
label define label_cipcode2 480299 "48.0299 - Graphic and Printing Equipment Operators, Other", add 
label define label_cipcode2 480303 "48.0303 - Upholsterer", add 
label define label_cipcode2 480402 "48.0402 - Meatcutting", add 
label define label_cipcode2 480501 "48.0501 - Machinist/Machine Technologist", add 
label define label_cipcode2 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode2 480504 "48.0504 - Metal Fabrication", add 
label define label_cipcode2 480506 "48.0506 - Sheet Metal Worker", add 
label define label_cipcode2 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode2 480602 "48.0602 - Jewelry Design Fab and Repair", add 
label define label_cipcode2 489999 "48.9999 - Precision Production Trades, Other", add 
label define label_cipcode2 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode2 490102 "49.0102 - Aircraft Pilot and Navigator (Professional)", add 
label define label_cipcode2 490104 "49.0104 - Aviation Management", add 
label define label_cipcode2 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode2 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode2 490202 "49.0202 - Construction Equipment Operator", add 
label define label_cipcode2 490205 "49.0205 - Truck, Bus and Other Commercial Vehicle Operators", add 
label define label_cipcode2 490299 "49.0299 - Vehicle and Equipment Operators, Other", add 
label define label_cipcode2 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode2 490399 "49.0399 - Water Transportation Workers, Other", add 
label define label_cipcode2 500101 "50.0101 - Visual and Performing Arts, General", add 
label define label_cipcode2 500202 "50.0202 - Ceramics", add 
label define label_cipcode2 500204 "50.0204 - Fiber/Textiles/Weaving", add 
label define label_cipcode2 500402 "50.0402 - Graphic Design, Commercial Art and Illustration", add 
label define label_cipcode2 500499 "50.0499 - Design and Applied Arts, Other", add 
label define label_cipcode2 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode2 500601 "50.0601 - Film/Cinema Studies", add 
label define label_cipcode2 500605 "50.0605 - Photography", add 
label define label_cipcode2 500606 "50.0606 - Video", add 
label define label_cipcode2 500901 "50.0901 - Music, General", add 
label define label_cipcode2 500999 "50.0999 - Music, Other", add 
label define label_cipcode2 509999 "50.9999 - Visual and Performing Arts, Other", add 
label values cipcode2 label_cipcode2
label define label_cipcode3 10199 "01.0199 - Agricultural Business and Management, Other" 
label define label_cipcode3 10504 "01.0504 - Pet Grooming", add 
label define label_cipcode3 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode3 10699 "01.0699 - Horticulture Services Operations and Management, Other", add 
label define label_cipcode3 30301 "03.0301 - Fishing and Fisheries Sciences and Management", add 
label define label_cipcode3 40401 "04.0401 - Architectural Environmental Design", add 
label define label_cipcode3 40501 "04.0501 - Interior Architecture", add 
label define label_cipcode3 60101 "06.0101 - Business and Management, General", add 
label define label_cipcode3 60201 "06.0201 - Accounting", add 
label define label_cipcode3 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode3 60401 "06.0401 - Business Admintration and Management, General", add 
label define label_cipcode3 60701 "06.0701 - Hotel/Motel Management", add 
label define label_cipcode3 60801 "06.0801 - Insurance and Risk Management", add 
label define label_cipcode3 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode3 61303 "06.1303 - Management Science, General", add 
label define label_cipcode3 61399 "06.1399 - Management Science, Other", add 
label define label_cipcode3 61701 "06.1701 - Real Estate", add 
label define label_cipcode3 61901 "06.1901 - Taxation", add 
label define label_cipcode3 69999 "06.9999 - Business and Management, Other", add 
label define label_cipcode3 70101 "07.0101 - Accounting, Bookkeeping and Related Programs", add 
label define label_cipcode3 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode3 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode3 70199 "07.0199 - Accounting, Bookkeeping, and Related Programs, Other", add 
label define label_cipcode3 70201 "07.0201 - Banking and Related Financial Programs, General", add 
label define label_cipcode3 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode3 70205 "07.0205 - Teller", add 
label define label_cipcode3 70299 "07.0299 - Banking and Related Financial Programs, Other", add 
label define label_cipcode3 70301 "07.0301 - Business Data Process and Related Programs, General", add 
label define label_cipcode3 70302 "07.0302 - Business Computer and Console Operation", add 
label define label_cipcode3 70303 "07.0303 - Business Data Entry Equipment Operation", add 
label define label_cipcode3 70304 "07.0304 - Business Data Peripheral Equipment Operation", add 
label define label_cipcode3 70399 "07.0399 - Business Data Process and Related Programs", add 
label define label_cipcode3 70401 "07.0401 - Office Supervision and Management", add 
label define label_cipcode3 70601 "07.0601 - Secretarial and Related Programs, General", add 
label define label_cipcode3 70602 "07.0602 - Court Reporting", add 
label define label_cipcode3 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode3 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode3 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode3 70606 "07.0606 - Secretarial", add 
label define label_cipcode3 70699 "07.0699 - Secretarial and Related Programs, Other", add 
label define label_cipcode3 70701 "07.0701 - Typing, General Office and Related Programs, General", add 
label define label_cipcode3 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode3 70705 "07.0705 - General Office Clerk", add 
label define label_cipcode3 70707 "07.0707 - Receptionist", add 
label define label_cipcode3 70799 "07.0799 - Typing General Office and Related Programs, Other", add 
label define label_cipcode3 70801 "07.0801 - Word Processing", add 
label define label_cipcode3 79999 "07.9999 - Business (Administrative Support), Other", add 
label define label_cipcode3 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode3 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode3 80105 "08.0105 - Jewelry Marketing", add 
label define label_cipcode3 80301 "08.0301 - Entrepreneurship", add 
label define label_cipcode3 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode3 80601 "08.0601 - Food Products Retailing and Wholesaling Operation, General", add 
label define label_cipcode3 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode3 80706 "08.0706 - General Selling Skills and Sales Operations", add 
label define label_cipcode3 80901 "08.0901 - Hospitality and Recreation Marketing Operations, General", add 
label define label_cipcode3 80999 "08.0999 - Hospitality and Recreation Marketing Operation, Other", add 
label define label_cipcode3 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode3 81101 "08.1101 - Transportation and Travel Marketing, General", add 
label define label_cipcode3 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode3 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode3 81199 "08.1199 - Tourism and Travel Services Marketing Operations, Other", add 
label define label_cipcode3 90601 "09.0601 - Radio/TV News Broadcasting", add 
label define label_cipcode3 90801 "09.0801 - Telecommunictions", add 
label define label_cipcode3 100102 "10.0102 - Motion Picture Technology", add 
label define label_cipcode3 100103 "10.0103 - Photographic Technology/Technician", add 
label define label_cipcode3 100104 "10.0104 - Radio and Television Broadcasting Technology", add 
label define label_cipcode3 100105 "10.0105 - Sound Recording Technology", add 
label define label_cipcode3 110101 "11.0101 - Computer and Information Sciences, General", add 
label define label_cipcode3 110201 "11.0201 - Computer Programming", add 
label define label_cipcode3 110301 "11.0301 - Data Processing Technology/Technician", add 
label define label_cipcode3 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode3 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode3 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode3 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode3 120101 "12.0101 - Drycleaning and Laundering Services", add 
label define label_cipcode3 120202 "12.0202 - Bartending", add 
label define label_cipcode3 120203 "12.0203 - Card Dealer", add 
label define label_cipcode3 120299 "12.0299 - Gaming and Sports Officiating Services, Other", add 
label define label_cipcode3 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode3 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode3 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode3 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode3 120405 "12.0405 - Massage", add 
label define label_cipcode3 120406 "12.0406 - Make-up Artist", add 
label define label_cipcode3 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode3 129999 "12.9999 - Personal and Miscellaneous Services, Other", add 
label define label_cipcode3 130201 "13.0201 - Bilingual/Bicultural Education", add 
label define label_cipcode3 131204 "13.1204 - Pre-Elementary Education/Early Childhd/Kindergarten Teacher Education", add 
label define label_cipcode3 131299 "13.1299 - General Teacher Education, Other", add 
label define label_cipcode3 131320 "13.1320 - Trade and Industrial Teacher Education", add 
label define label_cipcode3 131399 "13.1399 - Teacher Education, Specific Academic and Vocational Programs, Other", add 
label define label_cipcode3 139999 "13.9999 - Education, Other", add 
label define label_cipcode3 141001 "14.1001 - Electrical, Electronics and Communication", add 
label define label_cipcode3 149999 "14.9999 - Engineering, Other", add 
label define label_cipcode3 150202 "15.0202 - Drafting and Design Technology", add 
label define label_cipcode3 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode3 150303 "15.0303 - Electrical, Electronic and Communications Engineering Tech./Technician", add 
label define label_cipcode3 150304 "15.0304 - Laser and Optical Tech./Technician", add 
label define label_cipcode3 150399 "15.0399 - Electrical and Electronic Engineering-Related Tech./Technician, Other", add 
label define label_cipcode3 150402 "15.0402 - Computer Maintenance Tech./Technician", add 
label define label_cipcode3 150501 "15.0501 - Heating, Air Conditioning and Refrigeration Tech./Technician", add 
label define label_cipcode3 150610 "15.0610 - Welding Technology", add 
label define label_cipcode3 150702 "15.0702 - Quality Control Technology/Technician", add 
label define label_cipcode3 150805 "15.0805 - Mechanical Engineering/Mechanical Technology", add 
label define label_cipcode3 160101 "16.0101 - Foreign Languages and Literatures, General", add 
label define label_cipcode3 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode3 170103 "17.0103 - Dental Laboratory Technology", add 
label define label_cipcode3 170203 "17.0203 - Electrocardiograph Technology", add 
label define label_cipcode3 170205 "17.0205 - Emergency Medical Tech-Ambulance", add 
label define label_cipcode3 170206 "17.0206 - Emergency Med Tech-Paramedic", add 
label define label_cipcode3 170211 "17.0211 - Surgical Technology", add 
label define label_cipcode3 170299 "17.0299 - Diagnstic and Treatment Services, Other", add 
label define label_cipcode3 170305 "17.0305 - Clinical Laboratory Assistant", add 
label define label_cipcode3 170308 "17.0308 - Histologic Technology", add 
label define label_cipcode3 170309 "17.0309 - Medical Laboratory Technician", add 
label define label_cipcode3 170399 "17.0399 - Medical Lab Technologies/Technicians, Other", add 
label define label_cipcode3 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode3 170405 "17.0405 - Mental Health/Hum Services, Assistant", add 
label define label_cipcode3 170499 "17.0499 - Ment Health/Human Services, Other", add 
label define label_cipcode3 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode3 170504 "17.0504 - Medical Illustrating", add 
label define label_cipcode3 170505 "17.0505 - Medical Office Management", add 
label define label_cipcode3 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode3 170513 "17.0513 - Health Unit Coordinating", add 
label define label_cipcode3 170599 "17.0599 - Misc Allied Health Services, Other", add 
label define label_cipcode3 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode3 170605 "17.0605 - Practical Nursing", add 
label define label_cipcode3 170699 "17.0699 - Nursing-Related Services, Other", add 
label define label_cipcode3 170705 "17.0705 - Optometric Technology", add 
label define label_cipcode3 170814 "17.0814 - Physical Therapy Aide", add 
label define label_cipcode3 170818 "17.0818 - Respiratory Therapy", add 
label define label_cipcode3 170899 "17.0899 - Rehabilitation Services, Other", add 
label define label_cipcode3 179999 "17.9999 - Allied Health, Other", add 
label define label_cipcode3 180799 "18.0799 - Health Services Administration, Other", add 
label define label_cipcode3 181025 "18.1025 - Radiology", add 
label define label_cipcode3 181101 "18.1101 - Nursing, General", add 
label define label_cipcode3 181199 "18.1199 - Nursing, Other", add 
label define label_cipcode3 189999 "18.9999 - Health Sciences, Other", add 
label define label_cipcode3 190503 "19.0503 - Dietetics/Human Nutritional Services", add 
label define label_cipcode3 190601 "19.0601 - Housing Studies, General", add 
label define label_cipcode3 190902 "19.0902 - Fashion Design", add 
label define label_cipcode3 200201 "20.0201 - Child Care/Guidance Workers and Managers", add 
label define label_cipcode3 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode3 200299 "20.0299 - Child Care/Guidance Workers and Managers, Other", add 
label define label_cipcode3 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode3 200306 "20.0306 - Fashion and Fabric Consultant", add 
label define label_cipcode3 200399 "20.0399 - Clothing, Apparel and Textile Workers and Managers, Other", add 
label define label_cipcode3 200401 "20.0401 - Institutional Food Workers and Administrators, General", add 
label define label_cipcode3 200402 "20.0402 - Baking", add 
label define label_cipcode3 200405 "20.0405 - Food Caterer", add 
label define label_cipcode3 200406 "20.0406 - Food Service", add 
label define label_cipcode3 200499 "20.0499 - Institutional Food Workers and Administrators, Other", add 
label define label_cipcode3 200504 "20.0504 - Floral Design", add 
label define label_cipcode3 200505 "20.0505 - Home Decorating", add 
label define label_cipcode3 210103 "21.0103 - Drafting and Design", add 
label define label_cipcode3 210106 "21.0106 - Graphic Arts", add 
label define label_cipcode3 210199 "21.0199 - Industrial Arts, Other", add 
label define label_cipcode3 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode3 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode3 230501 "23.0501 - English Creative Writing", add 
label define label_cipcode3 231201 "23.1201 - English as a Second Language", add 
label define label_cipcode3 240102 "24.0102 - General Studies", add 
label define label_cipcode3 260604 "26.0604 - Embryology", add 
label define label_cipcode3 309999 "30.9999 - Multi/Interdisciplinary Studies, Other", add 
label define label_cipcode3 320105 "32.0105 - Job Seeking/Changing Skills", add 
label define label_cipcode3 320199 "32.0199 - Basic Skills, Other", add 
label define label_cipcode3 350102 "35.0102 - Building human relationships", add 
label define label_cipcode3 360107 "36.0107 - Pet Ownership and Care", add 
label define label_cipcode3 360109 "36.0109 - Travel and Exploration", add 
label define label_cipcode3 370104 "37.0104 - Self-Esteem and Values Clarification", add 
label define label_cipcode3 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode3 390301 "39.0301 - Missions/Missionary Studies and Misology", add 
label define label_cipcode3 399999 "39.9999 - Theological Studies and Rel. Vocations, Other", add 
label define label_cipcode3 400702 "40.0702 - Oceanography", add 
label define label_cipcode3 410202 "41.0202 - Nuclear Power Plant Operation Technology", add 
label define label_cipcode3 419999 "41.9999 - Science Technologies/Technicians, Other", add 
label define label_cipcode3 430102 "43.0102 - Corrections/Correctional Administration", add 
label define label_cipcode3 430106 "43.0106 - Forensic Tech./Technician", add 
label define label_cipcode3 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode3 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode3 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode3 450601 "45.0601 - Economics, General", add 
label define label_cipcode3 459999 "45.9999 - Social Sciences and History, Other", add 
label define label_cipcode3 460302 "46.0302 - Electrician", add 
label define label_cipcode3 460399 "46.0399 - Electrical and Power Transmission Installers, Other", add 
label define label_cipcode3 460401 "46.0401 - Building/Property Maintenance and Management", add 
label define label_cipcode3 460501 "46.0501 - Plumber and Pipefitter", add 
label define label_cipcode3 460503 "46.0503 - Plumbing", add 
label define label_cipcode3 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode3 470101 "47.0101 - Electrical and Electronics Equipment Installer and Repairers, General", add 
label define label_cipcode3 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode3 470105 "47.0105 - Industrial Electronics Installer and Repairer", add 
label define label_cipcode3 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode3 470109 "47.0109 - Electrical and Electronics Equipment Installer and Repairer, Other", add 
label define label_cipcode3 470199 "47.0199 - Electrical and Electronics Equipment Installer and Repairers, Other", add 
label define label_cipcode3 470201 "47.0201 - Heating, Air Conditioning and Refrigeration Mechanic and Repairer", add 
label define label_cipcode3 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode3 470299 "47.0299 - Heat Airconditioning and Refrigeration Mechanic and Repairer, Other", add 
label define label_cipcode3 470303 "47.0303 - Industrial Machinery Main. and Repairer", add 
label define label_cipcode3 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode3 470501 "47.0501 - Stationary Energy Sources Installer/Oper", add 
label define label_cipcode3 470601 "47.0601 - Vehicle and Mobile Equipment Mechanics and Repairers, General", add 
label define label_cipcode3 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode3 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode3 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode3 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode3 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode3 470699 "47.0699 - Vehicle and Mobile Equip. Mechanic and Repairer", add 
label define label_cipcode3 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode3 480101 "48.0101 - Drafting, General", add 
label define label_cipcode3 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode3 480201 "48.0201 - Graphic and Printing Equipment Operator, General", add 
label define label_cipcode3 480203 "48.0203 - Commercial Air", add 
label define label_cipcode3 480205 "48.0205 - Mechanical Typesetter and Composer", add 
label define label_cipcode3 480206 "48.0206 - Lithographer and Platemaker", add 
label define label_cipcode3 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode3 480209 "48.0209 - Silk Screen Making and Printing", add 
label define label_cipcode3 480303 "48.0303 - Upholsterer", add 
label define label_cipcode3 480504 "48.0504 - Metal Fabrication", add 
label define label_cipcode3 480507 "48.0507 - Tool and Die Maker/Technologist", add 
label define label_cipcode3 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode3 480602 "48.0602 - Jewelry Design Fab and Repair", add 
label define label_cipcode3 480604 "48.0604 - Plastics", add 
label define label_cipcode3 489999 "48.9999 - Precision Production Trades, Other", add 
label define label_cipcode3 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode3 490102 "49.0102 - Aircraft Pilot and Navigator (Professional)", add 
label define label_cipcode3 490106 "49.0106 - Flight Attendant", add 
label define label_cipcode3 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode3 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode3 490202 "49.0202 - Construction Equipment Operator", add 
label define label_cipcode3 490205 "49.0205 - Truck, Bus and Other Commercial Vehicle Operators", add 
label define label_cipcode3 490306 "49.0306 - Marine Maintenance and Ship Repairer", add 
label define label_cipcode3 490399 "49.0399 - Water Transportation Workers, Other", add 
label define label_cipcode3 500101 "50.0101 - Visual and Performing Arts, General", add 
label define label_cipcode3 500499 "50.0499 - Design and Applied Arts, Other", add 
label define label_cipcode3 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode3 500601 "50.0601 - Film/Cinema Studies", add 
label define label_cipcode3 500605 "50.0605 - Photography", add 
label define label_cipcode3 500699 "50.0699 - Film/Video and Photographic Arts, Other", add 
label define label_cipcode3 500904 "50.0904 - Music Theory and Composition", add 
label define label_cipcode3 500999 "50.0999 - Music, Other", add 
label define label_cipcode3 509999 "50.9999 - Visual and Performing Arts, Other", add 
label values cipcode3 label_cipcode3
tab apfee
tab tfdu
tab tfdi
tab ffind
tab ffper
tab phind
tab phper
tab noftug
tab chgper
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
tab finaid9
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
summarize applfeeu
summarize applfeeg
summarize ffamt
summarize phamt
summarize tuition1
summarize tuition2
summarize tuition3
summarize tuition5
summarize tuition6
summarize tuition7
summarize tuition8
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
summarize roombord
summarize avgamt1
summarize avgamt2
summarize avgamt3
summarize avgamt4
summarize enroll88
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
save dct_ic1989_b

