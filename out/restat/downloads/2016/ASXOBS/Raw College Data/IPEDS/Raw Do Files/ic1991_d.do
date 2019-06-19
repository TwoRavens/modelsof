* Created: 6/13/2004 6:49:04 AM
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
insheet using "../Raw Data/ic1991_d_data_stata.csv", comma clear
label data "dct_ic1991_d"
label variable unitid "unitid"
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
label variable chgper "Basis for charging full-time students (IC3 only)"
label variable tuition1 "Tuition and fees, full-time undergraduate, in-district"
label variable tuition2 "Tuition and fees, full-time undergraduate, in-state"
label variable tuition3 "Tuition and fees, full-time undergraduate, out-of-state"
label variable tuition4 "No full-time undergraduate students"
label variable tuition5 "Tuition and fees, full-time graduate, in-district"
label variable tuition6 "Tuition and fees, full-time graduate, in-state"
label variable tuition7 "Tuition and fees, full-time graduate, out-of-state"
label variable tuition8 "No full-time graduate students"
label variable prof1 "Tuition and fees full-time Chiropractic"
label variable prof2 "Tuition and fees full-time Dentistry"
label variable prof3 "Tuition and fees full-time Medicine"
label variable prof4 "Tuition and fees full-time Optometry"
label variable prof5 "Tuition and fees full-time Osteopathic Medicine"
label variable prof6 "Tuition and fees full-time Pharmacy"
label variable prof7 "Tuition and fees full-time Podiatry"
label variable prof8 "Tuition and fees full-time Veterinary Medicine"
label variable prof9 "Tuition and fees full-time Law"
label variable prof10 "Tuition and fees full-time Theology"
label variable prof11 "Tuition and fees full-time Other first-professional, in-state"
label variable profna "1 - No full-time first-professional students"
label variable room "Institution provides dormitory facilities"
label variable roomamt "Typical room charge for academic year"
label variable roomcap "Total dormitory capacity during academic year"
label variable board "Institution provides board or meal plans"
label variable boardamt "Typical board charge for academic year"
label variable mealswk "Number of meals per week included in board charge"
label variable roombord "Combined charge for room and board"
label variable avgamt1 "Expenses, books and supplies"
label variable avgamt2 "Expenses, Transportation"
label variable avgamt3 "Expenses, Room and board (for-non-dormitory students)"
label variable avgamt4 "Miscellaneous expenses"
label variable prgmoffr "Number of programs offered"
label variable pg600 "Offers some programs greater than 300 contact hours"
label variable cipcode1 "1st CIP code"
label variable ciptuit1 "1st Tuition and fees"
label variable ciplgth1 "1st Total length of program in contact hours"
label variable cipenrl1 "1st Current or most recent enrollment"
label variable cipcode2 "2nd CIP code"
label variable ciptuit2 "2nd Tuition and fees (in-State charges)"
label variable ciplgth2 "2nd Total length of program in contact hours"
label variable cipenrl2 "2nd Current or most recent enrollment"
label variable cipcode3 "3rd CIP code"
label variable ciptuit3 "3rd Tuition and fees (in-state charges)"
label variable ciplgth3 "3rd Total length of program in contact hours"
label variable cipenrl3 "3rd Current or most recent enrollment"
label variable cipcode4 "4th CIP code"
label variable ciptuit4 "4th Tuition and fees (in-state charges)"
label variable ciplgth4 "4th Total length of program in contact hours"
label variable cipenrl4 "4th Current or most recent enrollment"
label variable cipcode5 "5th CIP code"
label variable ciptuit5 "5th Tuition and fees (in-state charges)"
label variable ciplgth5 "5th Total length of program in contact hours"
label variable cipenrl5 "5th Current or most recent enrollment"
label variable cipcode6 "6th CIP code"
label variable ciptuit6 "6th Tuition and fees (in-state charges)"
label variable ciplgth6 "6th Total length of program in contact hours"
label variable cipenrl6 "6th Current or most recent enrollment"
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
label define label_phper 1 "Per semeser" 
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
label define label_roombord 1 "Yes" 
label define label_roombord 2 "No", add 
label values roombord label_roombord
label define label_pg600 1 "Yes" 
label define label_pg600 2 "No", add 
label values pg600 label_pg600
label define label_cipcode1 10301 "01.0301 - Ag. Prod. Workers and Managers, General" 
label define label_cipcode1 10399 "01.0399 - Ag. Prod. Workers and Managers, Other", add 
label define label_cipcode1 10504 "01.0504 - Pet Grooming", add 
label define label_cipcode1 10505 "01.0505 - Animal Trainer", add 
label define label_cipcode1 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode1 10507 "01.0507 - Eques./Equine Stds., Horse Mgmt. and Trgn.", add 
label define label_cipcode1 10601 "01.0601 - Horticulture Svcs. Ops. and Mgmt., General", add 
label define label_cipcode1 10699 "01.0699 - Horticulture Svcs. Ops. and Mgmt., Other", add 
label define label_cipcode1 19999 "01.9999 - Agricultural Business and Production, Other", add 
label define label_cipcode1 20299 "02.0299 - Animal Sciences, Other", add 
label define label_cipcode1 30401 "03.0401 - Forest Harvesting and Production Tech.", add 
label define label_cipcode1 40501 "04.0501 - Interior Architecture", add 
label define label_cipcode1 59999 "05.9999 - Area, Ethnic and Cultural Studies, Other", add 
label define label_cipcode1 60101 "06.0101 - Business and Management, General", add 
label define label_cipcode1 60201 "06.0201 - Accounting", add 
label define label_cipcode1 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode1 60401 "06.0401 - Business Admin and Manage, General", add 
label define label_cipcode1 60499 "06.0499 - Business Admin and Manage, Other", add 
label define label_cipcode1 60701 "06.0701 - Hotel/Motel Management", add 
label define label_cipcode1 60702 "06.0702 - Recreational Enterprises Mgt.", add 
label define label_cipcode1 60704 "06.0704 - Restaurant Management", add 
label define label_cipcode1 60705 "06.0705 - Transportation Management", add 
label define label_cipcode1 60799 "06.0799 - Institutional Managemnt, Other", add 
label define label_cipcode1 60801 "06.0801 - Insurance and Risk Management", add 
label define label_cipcode1 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode1 61101 "06.1101 - Labor/Industrial Relations", add 
label define label_cipcode1 61501 "06.1501 - Organizational Behavior", add 
label define label_cipcode1 61601 "06.1601 - Personnel Management", add 
label define label_cipcode1 61701 "06.1701 - Real Estate", add 
label define label_cipcode1 61801 "06.1801 - Small Business Mgt. and Ownership", add 
label define label_cipcode1 61901 "06.1901 - Taxation", add 
label define label_cipcode1 69999 "06.9999 - Business and Management, Other", add 
label define label_cipcode1 70101 "07.0101 - Acct Bookkeep and Related Progms", add 
label define label_cipcode1 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode1 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode1 70104 "07.0104 - Mach Billing, Book, and Comput", add 
label define label_cipcode1 70199 "07.0199 - Acct, Book, and Rel Progs, Other", add 
label define label_cipcode1 70201 "07.0201 - Banking and Rel Fin Progs, General", add 
label define label_cipcode1 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode1 70205 "07.0205 - Teller", add 
label define label_cipcode1 70301 "07.0301 - Bus Data Process and Rel Progms", add 
label define label_cipcode1 70302 "07.0302 - Bus Computer and Console Oper", add 
label define label_cipcode1 70303 "07.0303 - Bus Data Entry Equip Operat", add 
label define label_cipcode1 70304 "07.0304 - Bus Data Peripheral Equip Op.", add 
label define label_cipcode1 70305 "07.0305 - Business Data Programming", add 
label define label_cipcode1 70399 "07.0399 - Bus Data Pro and Rel Progs, Other", add 
label define label_cipcode1 70401 "07.0401 - Office Supervision and Managem", add 
label define label_cipcode1 70503 "07.0503 - Personnel Assisting", add 
label define label_cipcode1 70601 "07.0601 - Secretarial and Rel Progs, General", add 
label define label_cipcode1 70602 "07.0602 - Court Reporting", add 
label define label_cipcode1 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode1 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode1 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode1 70606 "07.0606 - Secretarial", add 
label define label_cipcode1 70607 "07.0607 - Stenographic", add 
label define label_cipcode1 70699 "07.0699 - Secretarial and Relat Progm Other", add 
label define label_cipcode1 70701 "07.0701 - Typing, Gen Off and Rel Progms", add 
label define label_cipcode1 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode1 70705 "07.0705 - General Office Clerk", add 
label define label_cipcode1 70707 "07.0707 - Receptionist and Comm Systs Op.", add 
label define label_cipcode1 70708 "07.0708 - Ship, Receiv and Stock Clerk", add 
label define label_cipcode1 70799 "07.0799 - Typing Gen Off and Rel Prog Other", add 
label define label_cipcode1 70801 "07.0801 - Word Processing", add 
label define label_cipcode1 79999 "07.9999 - Business (Admin Supp) Other", add 
label define label_cipcode1 80101 "08.0101 - Apparel and Accessories Market. Opns, General", add 
label define label_cipcode1 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode1 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode1 80105 "08.0105 - Jewelry Marketing", add 
label define label_cipcode1 80199 "08.0199 - Apparel and Accessories Market. Opns, Other", add 
label define label_cipcode1 80301 "08.0301 - Entrepreneurship", add 
label define label_cipcode1 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode1 80701 "08.0701 - Auctioneering", add 
label define label_cipcode1 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode1 80706 "08.0706 - General Selling Skills and Sales Opns.", add 
label define label_cipcode1 80799 "08.0799 - Gen. Retail and Wholesale Opns. and Skills, Other", add 
label define label_cipcode1 80802 "08.0802 - Home Products Marketing Operations (1985 code replaced in 1990 with 08.0809)", add 
label define label_cipcode1 80803 "08.0803 - Building Materials Marketing", add 
label define label_cipcode1 80807 "08.0807 - Office Products Marketing Operations (1985 code replaced in 1990 with 08.0809)", add 
label define label_cipcode1 80902 "08.0902 - Hotel/Motel Srvc. Marketing Operation", add 
label define label_cipcode1 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode1 81101 "08.1101 - Transp and Travel Market, General", add 
label define label_cipcode1 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode1 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode1 81199 "08.1199 - Tourism and Travel Srvc. Market. Opns., Other", add 
label define label_cipcode1 81201 "08.1201 - Vehs and Petro Marketing General", add 
label define label_cipcode1 90201 "09.0201 - Advertising", add 
label define label_cipcode1 90601 "09.0601 - Radio/Tv News Broadcasting", add 
label define label_cipcode1 90701 "09.0701 - Radio and Television Broadcasting", add 
label define label_cipcode1 90801 "09.0801 - Telecommunictions", add 
label define label_cipcode1 100102 "10.0102 - Motion Picture Technology", add 
label define label_cipcode1 100103 "10.0103 - Photographic Tech./Technician", add 
label define label_cipcode1 100104 "10.0104 - Radio and Television Broadcasting Tech.", add 
label define label_cipcode1 100105 "10.0105 - Sound Recording Technology", add 
label define label_cipcode1 110101 "11.0101 - Computer and Information Sciences, General", add 
label define label_cipcode1 110201 "11.0201 - Computer Programming", add 
label define label_cipcode1 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode1 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode1 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode1 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode1 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode1 120101 "12.0101 - Drycleaningand Laundering Services", add 
label define label_cipcode1 120202 "12.0202 - Bartending", add 
label define label_cipcode1 120203 "12.0203 - Card Dealer", add 
label define label_cipcode1 120299 "12.0299 - Gaming and Sports Officiating Services, Other", add 
label define label_cipcode1 120301 "12.0301 - Funeral Services and Mortuary Science", add 
label define label_cipcode1 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode1 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode1 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode1 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode1 120405 "12.0405 - Massage", add 
label define label_cipcode1 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode1 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode1 129999 "12.9999 - Personal and Miscellaneous Services, Other", add 
label define label_cipcode1 130202 "13.0202 - Bilingual Educ Assisting", add 
label define label_cipcode1 131201 "13.1201 - Adult and Continuing Teacher Education", add 
label define label_cipcode1 131204 "13.1204 - Pre-Elem/Erly Childhd/Kg. Teach Educ.", add 
label define label_cipcode1 131205 "13.1205 - Secondary Teacher Education", add 
label define label_cipcode1 131305 "13.1305 - English Teacher Education", add 
label define label_cipcode1 131314 "13.1314 - Physical Education Teaching and Coaching", add 
label define label_cipcode1 131319 "13.1319 - Technical Teacher Education (Vocational)", add 
label define label_cipcode1 131320 "13.1320 - Trade and Industrial Teacher Educ. (Voc)", add 
label define label_cipcode1 131321 "13.1321 - Computer Teacher Education", add 
label define label_cipcode1 131399 "13.1399 - Teacher Ed., Spec Acad and Voc Prog, Other", add 
label define label_cipcode1 131401 "13.1401 - Teaching Esl/Foreign Language", add 
label define label_cipcode1 139999 "13.9999 - Education, Other", add 
label define label_cipcode1 140101 "14.0101 - Engineering, General", add 
label define label_cipcode1 142201 "14.2201 - Naval Architecture and Marine Engineering", add 
label define label_cipcode1 150202 "15.0202 - Drafting and Design Technology", add 
label define label_cipcode1 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode1 150302 "15.0302 - Electrical Technology", add 
label define label_cipcode1 150303 "15.0303 - Elec., Electronic and Comm. Engin. Tech.", add 
label define label_cipcode1 150399 "15.0399 - Electrical and Electronic Engin.-Rel. Tech.", add 
label define label_cipcode1 150402 "15.0402 - Computer Main. Tech./Technician", add 
label define label_cipcode1 150403 "15.0403 - Electromechanical Tech./Technician", add 
label define label_cipcode1 150404 "15.0404 - Instrumentation Tech./Technician", add 
label define label_cipcode1 150405 "15.0405 - Robotics Tech./Technician", add 
label define label_cipcode1 150499 "15.0499 - Electromechanical Instrum. and Maint. Tech.", add 
label define label_cipcode1 150501 "15.0501 - Heating, Air Condition. and Refrig. Tech.", add 
label define label_cipcode1 150610 "15.0610 - Welding Technology", add 
label define label_cipcode1 150803 "15.0803 - Automotive Engineering Tech./Technician", add 
label define label_cipcode1 150805 "15.0805 - Mechanical Engineering/Mechanical Tech.", add 
label define label_cipcode1 151001 "15.1001 - Construction/Building Tech./Technician", add 
label define label_cipcode1 159999 "15.9999 - Engineering-Related Technol./Techn, Other", add 
label define label_cipcode1 160101 "16.0101 - Foreign Languages and Literatures, General", add 
label define label_cipcode1 160905 "16.0905 - Spanish Language and Literature", add 
label define label_cipcode1 161001 "16.1001 - Native American Languages", add 
label define label_cipcode1 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode1 170103 "17.0103 - Dental Laboratory Technology", add 
label define label_cipcode1 170201 "17.0201 - Cardiovascular Technology", add 
label define label_cipcode1 170203 "17.0203 - Electrocardiograph Techn.", add 
label define label_cipcode1 170204 "17.0204 - Electroencephalograph Tech", add 
label define label_cipcode1 170205 "17.0205 - Emergency Med Tech-Ambulance", add 
label define label_cipcode1 170206 "17.0206 - Emergency Med Tech-Paramedic", add 
label define label_cipcode1 170208 "17.0208 - Nuclear Medical Technology", add 
label define label_cipcode1 170209 "17.0209 - Radiologic (Medical) Tech.", add 
label define label_cipcode1 170210 "17.0210 - Respiratory Therapy Techn.", add 
label define label_cipcode1 170211 "17.0211 - Surgical Technology", add 
label define label_cipcode1 170212 "17.0212 - Diagnostic Med Sonography", add 
label define label_cipcode1 170299 "17.0299 - Diagnstic andTreatmnt Srvc., Other", add 
label define label_cipcode1 170301 "17.0301 - Blood Bank Technology", add 
label define label_cipcode1 170305 "17.0305 - Clinical Laboratory Assist", add 
label define label_cipcode1 170308 "17.0308 - Histologic Technology", add 
label define label_cipcode1 170309 "17.0309 - Medical Laboratory Techn.", add 
label define label_cipcode1 170310 "17.0310 - Medical Technology", add 
label define label_cipcode1 170311 "17.0311 - Microbiology Technology", add 
label define label_cipcode1 170399 "17.0399 - Medical Lab Technologies, Other", add 
label define label_cipcode1 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode1 170405 "17.0405 - Mental Health/Hum Serv Asst", add 
label define label_cipcode1 170406 "17.0406 - Mental Health/Hum Serv Tech.", add 
label define label_cipcode1 170499 "17.0499 - Ment Health/Human Serv, Other", add 
label define label_cipcode1 170502 "17.0502 - Central Supply Technology", add 
label define label_cipcode1 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode1 170505 "17.0505 - Medical Office Management", add 
label define label_cipcode1 170506 "17.0506 - Medical Records Technology", add 
label define label_cipcode1 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode1 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode1 170599 "17.0599 - Misc Allied Health Serv, Other", add 
label define label_cipcode1 170601 "17.0601 - Geriatric Aide", add 
label define label_cipcode1 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode1 170605 "17.0605 - Practical Nursing", add 
label define label_cipcode1 170807 "17.0807 - Occupational Therapy", add 
label define label_cipcode1 170811 "17.0811 - Orthotics/Prosthetics", add 
label define label_cipcode1 170812 "17.0812 - Orthopedic Assisting", add 
label define label_cipcode1 170813 "17.0813 - Physical Therapy", add 
label define label_cipcode1 170815 "17.0815 - Physical Therapy Assistng", add 
label define label_cipcode1 170818 "17.0818 - Respiratory Therapy", add 
label define label_cipcode1 170819 "17.0819 - Respiratory Therapy Assting", add 
label define label_cipcode1 170899 "17.0899 - Rehabilitation Services, Other", add 
label define label_cipcode1 179999 "17.9999 - Allied Health, Other", add 
label define label_cipcode1 180299 "18.0299 - Basic Clin Health Sci, Other", add 
label define label_cipcode1 180406 "18.0406 - Orthodontics", add 
label define label_cipcode1 180703 "18.0703 - Medical Records Admin", add 
label define label_cipcode1 180901 "18.0901 - Medical Laboratory", add 
label define label_cipcode1 181025 "18.1025 - Radiology", add 
label define label_cipcode1 181099 "18.1099 - Medicine, Other", add 
label define label_cipcode1 181101 "18.1101 - Nursing, General", add 
label define label_cipcode1 181199 "18.1199 - Nursing, Other", add 
label define label_cipcode1 181401 "18.1401 - Pharmacy", add 
label define label_cipcode1 182299 "18.2299 - Public Health, Other", add 
label define label_cipcode1 189999 "18.9999 - Health Sciences, Other", add 
label define label_cipcode1 190502 "19.0502 - Foods and Nutrition Science", add 
label define label_cipcode1 190902 "19.0902 - Fashion Design", add 
label define label_cipcode1 190999 "19.0999 - Textiles and Clothing, Other", add 
label define label_cipcode1 199999 "19.9999 - Home Economics, Other", add 
label define label_cipcode1 200102 "20.0102 - Child Devel, Care and Guidance", add 
label define label_cipcode1 200108 "20.0108 - Food and Nutrition", add 
label define label_cipcode1 200201 "20.0201 - Child Care/Guidance Workers and Managers, General", add 
label define label_cipcode1 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode1 200301 "20.0301 - Clothing, Apparel and Textile Workers and Managers, General", add 
label define label_cipcode1 200303 "20.0303 - Commercial Garment and Apparel Worker", add 
label define label_cipcode1 200304 "20.0304 - Custom Apparel/Garment Seam", add 
label define label_cipcode1 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode1 200306 "20.0306 - Fashion and Fabric Consultant", add 
label define label_cipcode1 200399 "20.0399 - Clothing, Apparel and Textile Workers and Mangers, Other", add 
label define label_cipcode1 200401 "20.0401 - Institutional Food Workers and Admin, General", add 
label define label_cipcode1 200402 "20.0402 - Baking", add 
label define label_cipcode1 200403 "20.0403 - Chef/Cook", add 
label define label_cipcode1 200405 "20.0405 - Food Caterer", add 
label define label_cipcode1 200499 "20.0499 - Institutional Food Workers and Admin, Other", add 
label define label_cipcode1 200504 "20.0504 - Floral Design", add 
label define label_cipcode1 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode1 209999 "20.9999 - Vocational Home Economics, Other", add 
label define label_cipcode1 210101 "21.0101 - Technology Education/Industrial Arts", add 
label define label_cipcode1 210102 "21.0102 - Construction (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode1 210103 "21.0103 - Drafting and Design (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode1 210104 "21.0104 - Electricity/Electronics (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode1 210106 "21.0106 - Graphic Arts (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode1 210199 "21.0199 - Industrial Arts, Other (1985 code deleted in 1990)", add 
label define label_cipcode1 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode1 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode1 230201 "23.0201 - Classics", add 
label define label_cipcode1 231201 "23.1201 - English As A Second Language", add 
label define label_cipcode1 260499 "26.0499 - Cell and Molecular Biology, Other", add 
label define label_cipcode1 300901 "30.0901 - Imaging Science", add 
label define label_cipcode1 310201 "31.0201 - Outdoor Recreation", add 
label define label_cipcode1 320101 "32.0101 - Basic Skills, General", add 
label define label_cipcode1 320103 "32.0103 - Communication Skills (1985 code replaced in 1990 with 32.0108)", add 
label define label_cipcode1 320199 "32.0199 - Basic Skills, Other", add 
label define label_cipcode1 340103 "34.0103 - Personal Health Improvemente and Maintenance", add 
label define label_cipcode1 340104 "34.0104 - Addiction Prevention and Treatment", add 
label define label_cipcode1 340199 "34.0199 - Health-Related Knowledge and Skills, Other", add 
label define label_cipcode1 350199 "35.0199 - Interpersonal Social Skills, Other", add 
label define label_cipcode1 360109 "36.0109 - Travel and Exploration", add 
label define label_cipcode1 360199 "36.0199 - Leisure and Recreational Activities, Other", add 
label define label_cipcode1 370101 "37.0101 - Self-Awareness and Personal Assessment", add 
label define label_cipcode1 370104 "37.0104 - Self-Esteem and Values Clarification", add 
label define label_cipcode1 370199 "37.0199 - Personal Awareness and Self-Improvement, Other", add 
label define label_cipcode1 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode1 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode1 390301 "39.0301 - Missions/Missionary Studies and Misology", add 
label define label_cipcode1 390401 "39.0401 - Religious Education", add 
label define label_cipcode1 390601 "39.0601 - Theology/Theological Studies", add 
label define label_cipcode1 399999 "39.9999 - Theological Studies and Rel. Vocations, Other", add 
label define label_cipcode1 400702 "40.0702 - Oceanography", add 
label define label_cipcode1 410204 "41.0204 - Industrial Radiologic Tech./Technician", add 
label define label_cipcode1 410302 "41.0302 - Geological Technology (1985 code replaced in 1990 with 41.0399)", add 
label define label_cipcode1 429999 "42.9999 - Psychology, Other", add 
label define label_cipcode1 430102 "43.0102 - Corrections/Correctional Administration", add 
label define label_cipcode1 430105 "43.0105 - Criminal Justice Technology", add 
label define label_cipcode1 430106 "43.0106 - Forensic Tech./Technician", add 
label define label_cipcode1 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode1 430108 "43.0108 - Law Enforcement Admin", add 
label define label_cipcode1 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode1 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode1 430202 "43.0202 - Fire Services Administration", add 
label define label_cipcode1 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode1 440101 "44.0101 - Public Affairs, General", add 
label define label_cipcode1 450601 "45.0601 - Economics, General", add 
label define label_cipcode1 460302 "46.0302 - Electrician", add 
label define label_cipcode1 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode1 460403 "46.0403 - Construction/Building Inspector", add 
label define label_cipcode1 460405 "46.0405 - Floor Covering Installation (1985 code replaced in 1990 with 46.9999)", add 
label define label_cipcode1 460408 "46.0408 - Painter and Wall Coverer", add 
label define label_cipcode1 460410 "46.0410 - Roofing (1985 code replaced in 1990 with 46.9999)", add 
label define label_cipcode1 460499 "46.0499 - Const. and Bldg. Finishers and Managers, Other", add 
label define label_cipcode1 460599 "46.0599 - Plumbing, Pipefitting and Steamfitting, Other (1985 code replaced in 1990 with 46.0501)", add 
label define label_cipcode1 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode1 470101 "47.0101 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode1 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode1 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode1 470109 "47.0109 - Vending and Rec Machine Repair", add 
label define label_cipcode1 470199 "47.0199 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode1 470201 "47.0201 - Heating, Air Conditioning and Refrigerat", add 
label define label_cipcode1 470202 "47.0202 - Cooling and Refrigeration", add 
label define label_cipcode1 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode1 470299 "47.0299 - Heat AircondandRefrig Mech., Other", add 
label define label_cipcode1 470399 "47.0399 - Indus. Equip. Main. and Repairers, Other", add 
label define label_cipcode1 470402 "47.0402 - Gunsmith", add 
label define label_cipcode1 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode1 470404 "47.0404 - Musical Instrument Repairer", add 
label define label_cipcode1 470501 "47.0501 - Stationary Energy Sources Installer/Oper", add 
label define label_cipcode1 470601 "47.0601 - Veh and Mob Equip Mech/Rep, General", add 
label define label_cipcode1 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode1 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode1 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode1 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode1 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode1 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode1 470699 "47.0699 - Vehicle and Mobile Equip. Mechanics and Rep.", add 
label define label_cipcode1 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode1 480101 "48.0101 - Drafting, General", add 
label define label_cipcode1 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode1 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode1 480201 "48.0201 - Graphic and Printing Equip. Operator, General", add 
label define label_cipcode1 480203 "48.0203 - Commercial Air", add 
label define label_cipcode1 480204 "48.0204 - Commercial Photography", add 
label define label_cipcode1 480206 "48.0206 - Lithographer and Platemaker", add 
label define label_cipcode1 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode1 480209 "48.0209 - Silk Screen Making and Printing (1985 code replaced in 1990 with 48.0299)", add 
label define label_cipcode1 480303 "48.0303 - Upholsterer", add 
label define label_cipcode1 480402 "48.0402 - Meatcutting", add 
label define label_cipcode1 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode1 480506 "48.0506 - Sheet Metal Worker", add 
label define label_cipcode1 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode1 480599 "48.0599 - Precision Metal Workers, Other", add 
label define label_cipcode1 480602 "48.0602 - Jewelry Design Fab and Repair", add 
label define label_cipcode1 480699 "48.0699 - Preci Wrk, Assrted Mats., Other", add 
label define label_cipcode1 489999 "48.9999 - Precision Production Trades, Other", add 
label define label_cipcode1 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode1 490102 "49.0102 - Aircraft Pilot and Navigator (Professional)", add 
label define label_cipcode1 490104 "49.0104 - Aviation Management", add 
label define label_cipcode1 490106 "49.0106 - Flight Attendant", add 
label define label_cipcode1 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode1 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode1 490204 "49.0204 - Mining Equipment Operation (1985 code replaced in 1990 with 49.0299)", add 
label define label_cipcode1 490205 "49.0205 - Truck, Bus and Oth. Commercial Vehicle Op.", add 
label define label_cipcode1 490302 "49.0302 - Barge and Boat Operations", add 
label define label_cipcode1 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode1 490308 "49.0308 - Sailors and Deckhands", add 
label define label_cipcode1 490399 "49.0399 - Water Transportation Workers, Other", add 
label define label_cipcode1 499999 "49.9999 - Transportation and Materials Moving Work", add 
label define label_cipcode1 500101 "50.0101 - Visual and Performing Arts", add 
label define label_cipcode1 500202 "50.0202 - Ceramics", add 
label define label_cipcode1 500299 "50.0299 - Crafts, Other", add 
label define label_cipcode1 500301 "50.0301 - Dance", add 
label define label_cipcode1 500401 "50.0401 - Design and Visual Communications", add 
label define label_cipcode1 500402 "50.0402 - Graphic Design, Commercial Art and Illus.", add 
label define label_cipcode1 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode1 500601 "50.0601 - Film/Cinema Studies", add 
label define label_cipcode1 500605 "50.0605 - Photography", add 
label define label_cipcode1 500699 "50.0699 - Film/Video and Photographic Arts, Other", add 
label define label_cipcode1 500703 "50.0703 - Art History, Criticism and Conservation", add 
label define label_cipcode1 500708 "50.0708 - Painting", add 
label define label_cipcode1 500799 "50.0799 - Fine Arts and Art Studies, Other", add 
label define label_cipcode1 500901 "50.0901 - Music, General", add 
label define label_cipcode1 500903 "50.0903 - Music - General Performance", add 
label define label_cipcode1 500999 "50.0999 - Music, Other", add 
label define label_cipcode1 509999 "50.9999 - Visual and Performing Arts, Other", add 
label define label_cipcode1 999999 "99.9999 - (Unknown value label)", add 
label values cipcode1 label_cipcode1
label define label_cipcode2 10203 "01.0203 - Agri Mech Const and Maint Skills" 
label define label_cipcode2 10301 "01.0301 - Ag. Prod. Workers and Managers, General", add 
label define label_cipcode2 10504 "01.0504 - Pet Grooming", add 
label define label_cipcode2 10505 "01.0505 - Animal Trainer", add 
label define label_cipcode2 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode2 10507 "01.0507 - Eques./Equine Stds., Horse Mgmt. and Trgn.", add 
label define label_cipcode2 10601 "01.0601 - Horticulture Svcs. Ops. and Mgmt., General", add 
label define label_cipcode2 10605 "01.0605 - Landscaping Operations and Management", add 
label define label_cipcode2 10699 "01.0699 - Horticulture Svcs. Ops. and Mgmt., Other", add 
label define label_cipcode2 19999 "01.9999 - Agricultural Business and Production, Other", add 
label define label_cipcode2 20299 "02.0299 - Animal Sciences, Other", add 
label define label_cipcode2 39999 "03.9999 - Conservation and Renewable Nat. Resrs, Other", add 
label define label_cipcode2 40101 "04.0101 - Arch and Enviorn Design, General", add 
label define label_cipcode2 40501 "04.0501 - Interior Architecture", add 
label define label_cipcode2 60101 "06.0101 - Business and Management, General", add 
label define label_cipcode2 60201 "06.0201 - Accounting", add 
label define label_cipcode2 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode2 60401 "06.0401 - Business Admin and Manage, General", add 
label define label_cipcode2 60701 "06.0701 - Hotel/Motel Management", add 
label define label_cipcode2 60704 "06.0704 - Restaurant Management", add 
label define label_cipcode2 60799 "06.0799 - Institutional Managemnt, Other", add 
label define label_cipcode2 60801 "06.0801 - Insurance and Risk Management", add 
label define label_cipcode2 61101 "06.1101 - Labor/Industrial Relations", add 
label define label_cipcode2 61402 "06.1402 - Marketing Research", add 
label define label_cipcode2 61701 "06.1701 - Real Estate", add 
label define label_cipcode2 61801 "06.1801 - Small Business Mgt. and Ownership", add 
label define label_cipcode2 61901 "06.1901 - Taxation", add 
label define label_cipcode2 69999 "06.9999 - Business and Management, Other", add 
label define label_cipcode2 70101 "07.0101 - Acct Bookkeep and Related Progms", add 
label define label_cipcode2 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode2 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode2 70104 "07.0104 - Mach Billing, Book, and Comput", add 
label define label_cipcode2 70199 "07.0199 - Acct, Book, and Rel Progs, Other", add 
label define label_cipcode2 70201 "07.0201 - Banking and Rel Fin Progs, General", add 
label define label_cipcode2 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode2 70205 "07.0205 - Teller", add 
label define label_cipcode2 70299 "07.0299 - Banking and Rel Fin Progs, Other", add 
label define label_cipcode2 70301 "07.0301 - Bus Data Process and Rel Progms", add 
label define label_cipcode2 70302 "07.0302 - Bus Computer and Console Oper", add 
label define label_cipcode2 70303 "07.0303 - Bus Data Entry Equip Operat", add 
label define label_cipcode2 70304 "07.0304 - Bus Data Peripheral Equip Op.", add 
label define label_cipcode2 70305 "07.0305 - Business Data Programming", add 
label define label_cipcode2 70399 "07.0399 - Bus Data Pro and Rel Progs, Other", add 
label define label_cipcode2 70401 "07.0401 - Office Supervision and Managem", add 
label define label_cipcode2 70601 "07.0601 - Secretarial and Rel Progs, General", add 
label define label_cipcode2 70602 "07.0602 - Court Reporting", add 
label define label_cipcode2 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode2 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode2 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode2 70606 "07.0606 - Secretarial", add 
label define label_cipcode2 70699 "07.0699 - Secretarial and Relat Progm Other", add 
label define label_cipcode2 70701 "07.0701 - Typing, Gen Off and Rel Progms", add 
label define label_cipcode2 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode2 70705 "07.0705 - General Office Clerk", add 
label define label_cipcode2 70707 "07.0707 - Receptionist and Comm Systs Op.", add 
label define label_cipcode2 70708 "07.0708 - Ship, Receiv and Stock Clerk", add 
label define label_cipcode2 70799 "07.0799 - Typing Gen Off and Rel Prog Other", add 
label define label_cipcode2 70801 "07.0801 - Word Processing", add 
label define label_cipcode2 79999 "07.9999 - Business (Admin Supp) Other", add 
label define label_cipcode2 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode2 80105 "08.0105 - Jewelry Marketing", add 
label define label_cipcode2 80199 "08.0199 - Apparel and Accessories Market. Opns, Other", add 
label define label_cipcode2 80299 "08.0299 - Bus. and Personal Ser. Market. Opns, Other", add 
label define label_cipcode2 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode2 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode2 80706 "08.0706 - General Selling Skills and Sales Opns.", add 
label define label_cipcode2 80901 "08.0901 - Hospitality and Rec. Marketing Opns, General", add 
label define label_cipcode2 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode2 81101 "08.1101 - Transp and Travel Market, General", add 
label define label_cipcode2 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode2 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode2 81199 "08.1199 - Tourism and Travel Srvc. Market. Opns., Other", add 
label define label_cipcode2 89999 "08.9999 - Marketing Opns/Market. and Distrib., Other", add 
label define label_cipcode2 90601 "09.0601 - Radio/Tv News Broadcasting", add 
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
label define label_cipcode2 120101 "12.0101 - Drycleaningand Laundering Services", add 
label define label_cipcode2 120202 "12.0202 - Bartending", add 
label define label_cipcode2 120203 "12.0203 - Card Dealer", add 
label define label_cipcode2 120299 "12.0299 - Gaming and Sports Officiating Services, Other", add 
label define label_cipcode2 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode2 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode2 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode2 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode2 120405 "12.0405 - Massage", add 
label define label_cipcode2 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode2 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode2 129999 "12.9999 - Personal and Miscellaneous Services, Other", add 
label define label_cipcode2 130301 "13.0301 - Curriculum and Instruction", add 
label define label_cipcode2 131202 "13.1202 - Elementary Teacher Education", add 
label define label_cipcode2 131204 "13.1204 - Pre-Elem/Erly Childhd/Kg. Teach Educ.", add 
label define label_cipcode2 131299 "13.1299 - General Teacher Education, Other", add 
label define label_cipcode2 131319 "13.1319 - Technical Teacher Education (Vocational)", add 
label define label_cipcode2 131320 "13.1320 - Trade and Industrial Teacher Educ. (Voc)", add 
label define label_cipcode2 131399 "13.1399 - Teacher Ed., Spec Acad and Voc Prog, Other", add 
label define label_cipcode2 131401 "13.1401 - Teaching Esl/Foreign Language", add 
label define label_cipcode2 131501 "13.1501 - Teacher Assistant/Aide", add 
label define label_cipcode2 139999 "13.9999 - Education, Other", add 
label define label_cipcode2 141001 "14.1001 - Electrical, Electronics and Communication", add 
label define label_cipcode2 142201 "14.2201 - Naval Architecture and Marine Engineering", add 
label define label_cipcode2 150101 "15.0101 - Architectural Engineering Tech./Tech.", add 
label define label_cipcode2 150202 "15.0202 - Drafting and Design Technology", add 
label define label_cipcode2 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode2 150303 "15.0303 - Elec., Electronic and Comm. Engin. Tech.", add 
label define label_cipcode2 150399 "15.0399 - Electrical and Electronic Engin.-Rel. Tech.", add 
label define label_cipcode2 150402 "15.0402 - Computer Main. Tech./Technician", add 
label define label_cipcode2 150403 "15.0403 - Electromechanical Tech./Technician", add 
label define label_cipcode2 150405 "15.0405 - Robotics Tech./Technician", add 
label define label_cipcode2 150501 "15.0501 - Heating, Air Condition. and Refrig. Tech.", add 
label define label_cipcode2 150610 "15.0610 - Welding Technology", add 
label define label_cipcode2 150803 "15.0803 - Automotive Engineering Tech./Technician", add 
label define label_cipcode2 150899 "15.0899 - Mechanical Engineering-Related Tech, Other", add 
label define label_cipcode2 159999 "15.9999 - Engineering-Related Technol./Techn, Other", add 
label define label_cipcode2 160901 "16.0901 - French Language and Literature", add 
label define label_cipcode2 160905 "16.0905 - Spanish Language and Literature", add 
label define label_cipcode2 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode2 170103 "17.0103 - Dental Laboratory Technology", add 
label define label_cipcode2 170201 "17.0201 - Cardiovascular Technology", add 
label define label_cipcode2 170203 "17.0203 - Electrocardiograph Techn.", add 
label define label_cipcode2 170205 "17.0205 - Emergency Med Tech-Ambulance", add 
label define label_cipcode2 170206 "17.0206 - Emergency Med Tech-Paramedic", add 
label define label_cipcode2 170208 "17.0208 - Nuclear Medical Technology", add 
label define label_cipcode2 170209 "17.0209 - Radiologic (Medical) Tech.", add 
label define label_cipcode2 170211 "17.0211 - Surgical Technology", add 
label define label_cipcode2 170212 "17.0212 - Diagnostic Med Sonography", add 
label define label_cipcode2 170308 "17.0308 - Histologic Technology", add 
label define label_cipcode2 170309 "17.0309 - Medical Laboratory Techn.", add 
label define label_cipcode2 170401 "17.0401 - Alcohol/Drug Abuse Specialty", add 
label define label_cipcode2 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode2 170405 "17.0405 - Mental Health/Hum Serv Asst", add 
label define label_cipcode2 170499 "17.0499 - Ment Health/Human Serv, Other", add 
label define label_cipcode2 170502 "17.0502 - Central Supply Technology", add 
label define label_cipcode2 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode2 170505 "17.0505 - Medical Office Management", add 
label define label_cipcode2 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode2 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode2 170513 "17.0513 - Health Unit Coordinating", add 
label define label_cipcode2 170599 "17.0599 - Misc Allied Health Serv, Other", add 
label define label_cipcode2 170601 "17.0601 - Geriatric Aide", add 
label define label_cipcode2 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode2 170605 "17.0605 - Practical Nursing", add 
label define label_cipcode2 170699 "17.0699 - Nursing-Related Servs, Other", add 
label define label_cipcode2 170814 "17.0814 - Physical Therapy Aide", add 
label define label_cipcode2 170815 "17.0815 - Physical Therapy Assistng", add 
label define label_cipcode2 170899 "17.0899 - Rehabilitation Services, Other", add 
label define label_cipcode2 179999 "17.9999 - Allied Health, Other", add 
label define label_cipcode2 180299 "18.0299 - Basic Clin Health Sci, Other", add 
label define label_cipcode2 180799 "18.0799 - Health Services Admin, Other", add 
label define label_cipcode2 180901 "18.0901 - Medical Laboratory", add 
label define label_cipcode2 181023 "18.1023 - Psychiatry", add 
label define label_cipcode2 181099 "18.1099 - Medicine, Other", add 
label define label_cipcode2 181101 "18.1101 - Nursing, General", add 
label define label_cipcode2 182299 "18.2299 - Public Health, Other", add 
label define label_cipcode2 189999 "18.9999 - Health Sciences, Other", add 
label define label_cipcode2 190902 "19.0902 - Fashion Design", add 
label define label_cipcode2 190999 "19.0999 - Textiles and Clothing, Other", add 
label define label_cipcode2 199999 "19.9999 - Home Economics, Other", add 
label define label_cipcode2 200103 "20.0103 - Clothing and Textiles", add 
label define label_cipcode2 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode2 200203 "20.0203 - Child Care Services Manager", add 
label define label_cipcode2 200204 "20.0204 - Foster Care/Family Care", add 
label define label_cipcode2 200303 "20.0303 - Commercial Garment and Apparel Worker", add 
label define label_cipcode2 200304 "20.0304 - Custom Apparel/Garment Seam", add 
label define label_cipcode2 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode2 200306 "20.0306 - Fashion and Fabric Consultant", add 
label define label_cipcode2 200399 "20.0399 - Clothing, Apparel and Textile Workers and Mangers, Other", add 
label define label_cipcode2 200401 "20.0401 - Institutional Food Workers and Admin, General", add 
label define label_cipcode2 200402 "20.0402 - Baking", add 
label define label_cipcode2 200403 "20.0403 - Chef/Cook", add 
label define label_cipcode2 200405 "20.0405 - Food Caterer", add 
label define label_cipcode2 200499 "20.0499 - Institutional Food Workers and Admin, Other", add 
label define label_cipcode2 200504 "20.0504 - Floral Design", add 
label define label_cipcode2 200505 "20.0505 - Home Decorating", add 
label define label_cipcode2 200599 "20.0599 - Home Furnishings and Equipment Installer", add 
label define label_cipcode2 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode2 209999 "20.9999 - Vocational Home Economics, Other", add 
label define label_cipcode2 210101 "21.0101 - Technology Education/Industrial Arts", add 
label define label_cipcode2 210103 "21.0103 - Drafting and Design (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode2 210104 "21.0104 - Electricity/Electronics (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode2 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode2 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode2 230201 "23.0201 - Classics", add 
label define label_cipcode2 231201 "23.1201 - English As A Second Language", add 
label define label_cipcode2 260604 "26.0604 - Embryology (1985 code replaced in 1990 with 26.0699)", add 
label define label_cipcode2 320101 "32.0101 - Basic Skills, General", add 
label define label_cipcode2 320103 "32.0103 - Communication Skills (1985 code replaced in 1990 with 32.0108)", add 
label define label_cipcode2 320105 "32.0105 - Job Seeking/Changing Skills", add 
label define label_cipcode2 340103 "34.0103 - Personal Health Improvemente and Maintenance", add 
label define label_cipcode2 340104 "34.0104 - Addiction Prevention and Treatment", add 
label define label_cipcode2 340199 "34.0199 - Health-Related Knowledge and Skills, Other", add 
label define label_cipcode2 350199 "35.0199 - Interpersonal Social Skills, Other", add 
label define label_cipcode2 360102 "36.0102 - Handicrafts and Model-Making", add 
label define label_cipcode2 360109 "36.0109 - Travel and Exploration", add 
label define label_cipcode2 360199 "36.0199 - Leisure and Recreational Activities, Other", add 
label define label_cipcode2 370101 "37.0101 - Self-Awareness and Personal Assessment", add 
label define label_cipcode2 370199 "37.0199 - Personal Awareness and Self-Improvement, Other", add 
label define label_cipcode2 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode2 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode2 390401 "39.0401 - Religious Education", add 
label define label_cipcode2 410204 "41.0204 - Industrial Radiologic Tech./Technician", add 
label define label_cipcode2 429999 "42.9999 - Psychology, Other", add 
label define label_cipcode2 430101 "43.0101 - Correctional Administration", add 
label define label_cipcode2 430104 "43.0104 - Criminal Justice Studies", add 
label define label_cipcode2 430106 "43.0106 - Forensic Tech./Technician", add 
label define label_cipcode2 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode2 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode2 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode2 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode2 460201 "46.0201 - Carpenter", add 
label define label_cipcode2 460302 "46.0302 - Electrician", add 
label define label_cipcode2 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode2 460403 "46.0403 - Construction/Building Inspector", add 
label define label_cipcode2 460499 "46.0499 - Const. and Bldg. Finishers and Managers, Other", add 
label define label_cipcode2 460599 "46.0599 - Plumbing, Pipefitting and Steamfitting, Other (1985 code replaced in 1990 with 46.0501)", add 
label define label_cipcode2 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode2 470101 "47.0101 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode2 470103 "47.0103 - Communication Sys. Installer and Repairer", add 
label define label_cipcode2 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode2 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode2 470109 "47.0109 - Vending and Rec Machine Repair", add 
label define label_cipcode2 470199 "47.0199 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode2 470201 "47.0201 - Heating, Air Conditioning and Refrigerat", add 
label define label_cipcode2 470202 "47.0202 - Cooling and Refrigeration", add 
label define label_cipcode2 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode2 470303 "47.0303 - Industrial Machinery Main. and Repairer", add 
label define label_cipcode2 470305 "47.0305 - OilandGas Drill Equip Op Maint", add 
label define label_cipcode2 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode2 470404 "47.0404 - Musical Instrument Repairer", add 
label define label_cipcode2 470408 "47.0408 - Watch, Clock and Jewelry Repairer", add 
label define label_cipcode2 470601 "47.0601 - Veh and Mob Equip Mech/Rep, General", add 
label define label_cipcode2 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode2 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode2 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode2 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode2 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode2 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode2 470699 "47.0699 - Vehicle and Mobile Equip. Mechanics and Rep.", add 
label define label_cipcode2 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode2 480101 "48.0101 - Drafting, General", add 
label define label_cipcode2 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode2 480104 "48.0104 - Electrical/Electronics Drafting", add 
label define label_cipcode2 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode2 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode2 480203 "48.0203 - Commercial Air", add 
label define label_cipcode2 480206 "48.0206 - Lithographer and Platemaker", add 
label define label_cipcode2 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode2 480299 "48.0299 - Graphic and Printing Equip. Operator, Other", add 
label define label_cipcode2 480303 "48.0303 - Upholsterer", add 
label define label_cipcode2 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode2 480507 "48.0507 - Tool and Die Maker/Technologist", add 
label define label_cipcode2 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode2 480599 "48.0599 - Precision Metal Workers, Other", add 
label define label_cipcode2 480602 "48.0602 - Jewelry Design Fab and Repair", add 
label define label_cipcode2 480699 "48.0699 - Preci Wrk, Assrted Mats., Other", add 
label define label_cipcode2 489999 "48.9999 - Precision Production Trades, Other", add 
label define label_cipcode2 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode2 490102 "49.0102 - Aircraft Pilot and Navigator (Professional)", add 
label define label_cipcode2 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode2 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode2 490202 "49.0202 - Construction Equipment Operator", add 
label define label_cipcode2 490205 "49.0205 - Truck, Bus and Oth. Commercial Vehicle Op.", add 
label define label_cipcode2 490302 "49.0302 - Barge and Boat Operations", add 
label define label_cipcode2 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode2 490399 "49.0399 - Water Transportation Workers, Other", add 
label define label_cipcode2 499999 "49.9999 - Transportation and Materials Moving Work", add 
label define label_cipcode2 500301 "50.0301 - Dance", add 
label define label_cipcode2 500402 "50.0402 - Graphic Design, Commercial Art and Illus.", add 
label define label_cipcode2 500403 "50.0403 - Illustration Design", add 
label define label_cipcode2 500499 "50.0499 - Design and Applied Arts, Other", add 
label define label_cipcode2 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode2 500601 "50.0601 - Film/Cinema Studies", add 
label define label_cipcode2 500602 "50.0602 - Film-Video Making/Cinematography and Prod.", add 
label define label_cipcode2 500605 "50.0605 - Photography", add 
label define label_cipcode2 500699 "50.0699 - Film/Video and Photographic Arts, Other", add 
label define label_cipcode2 500999 "50.0999 - Music, Other", add 
label define label_cipcode2 509999 "50.9999 - Visual and Performing Arts, Other", add 
label define label_cipcode2 999999 "99.9999 - (Unknown value label)", add 
label values cipcode2 label_cipcode2
label define label_cipcode3 10203 "01.0203 - Agri Mech Const and Maint Skills" 
label define label_cipcode3 10504 "01.0504 - Pet Grooming", add 
label define label_cipcode3 10505 "01.0505 - Animal Trainer", add 
label define label_cipcode3 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode3 10507 "01.0507 - Eques./Equine Stds., Horse Mgmt. and Trgn.", add 
label define label_cipcode3 20299 "02.0299 - Animal Sciences, Other", add 
label define label_cipcode3 30405 "03.0405 - Logging/Timber Harvesting", add 
label define label_cipcode3 40501 "04.0501 - Interior Architecture", add 
label define label_cipcode3 50299 "05.0299 - Ethnic and Cultural Studies, Other", add 
label define label_cipcode3 60101 "06.0101 - Business and Management, General", add 
label define label_cipcode3 60201 "06.0201 - Accounting", add 
label define label_cipcode3 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode3 60401 "06.0401 - Business Admin and Manage, General", add 
label define label_cipcode3 60499 "06.0499 - Business Admin and Manage, Other", add 
label define label_cipcode3 60701 "06.0701 - Hotel/Motel Management", add 
label define label_cipcode3 60704 "06.0704 - Restaurant Management", add 
label define label_cipcode3 60705 "06.0705 - Transportation Management", add 
label define label_cipcode3 60799 "06.0799 - Institutional Managemnt, Other", add 
label define label_cipcode3 60801 "06.0801 - Insurance and Risk Management", add 
label define label_cipcode3 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode3 61101 "06.1101 - Labor/Industrial Relations", add 
label define label_cipcode3 61701 "06.1701 - Real Estate", add 
label define label_cipcode3 61901 "06.1901 - Taxation", add 
label define label_cipcode3 62101 "06.2101 - Computer Installation Manage", add 
label define label_cipcode3 69999 "06.9999 - Business and Management, Other", add 
label define label_cipcode3 70101 "07.0101 - Acct Bookkeep and Related Progms", add 
label define label_cipcode3 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode3 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode3 70199 "07.0199 - Acct, Book, and Rel Progs, Other", add 
label define label_cipcode3 70201 "07.0201 - Banking and Rel Fin Progs, General", add 
label define label_cipcode3 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode3 70205 "07.0205 - Teller", add 
label define label_cipcode3 70299 "07.0299 - Banking and Rel Fin Progs, Other", add 
label define label_cipcode3 70301 "07.0301 - Bus Data Process and Rel Progms", add 
label define label_cipcode3 70302 "07.0302 - Bus Computer and Console Oper", add 
label define label_cipcode3 70303 "07.0303 - Bus Data Entry Equip Operat", add 
label define label_cipcode3 70304 "07.0304 - Bus Data Peripheral Equip Op.", add 
label define label_cipcode3 70305 "07.0305 - Business Data Programming", add 
label define label_cipcode3 70399 "07.0399 - Bus Data Pro and Rel Progs, Other", add 
label define label_cipcode3 70401 "07.0401 - Office Supervision and Managem", add 
label define label_cipcode3 70601 "07.0601 - Secretarial and Rel Progs, General", add 
label define label_cipcode3 70602 "07.0602 - Court Reporting", add 
label define label_cipcode3 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode3 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode3 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode3 70606 "07.0606 - Secretarial", add 
label define label_cipcode3 70699 "07.0699 - Secretarial and Relat Progm Other", add 
label define label_cipcode3 70701 "07.0701 - Typing, Gen Off and Rel Progms", add 
label define label_cipcode3 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode3 70705 "07.0705 - General Office Clerk", add 
label define label_cipcode3 70707 "07.0707 - Receptionist and Comm Systs Op.", add 
label define label_cipcode3 70708 "07.0708 - Ship, Receiv and Stock Clerk", add 
label define label_cipcode3 70799 "07.0799 - Typing Gen Off and Rel Prog Other", add 
label define label_cipcode3 70801 "07.0801 - Word Processing", add 
label define label_cipcode3 79999 "07.9999 - Business (Admin Supp) Other", add 
label define label_cipcode3 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode3 80105 "08.0105 - Jewelry Marketing", add 
label define label_cipcode3 80199 "08.0199 - Apparel and Accessories Market. Opns, Other", add 
label define label_cipcode3 80201 "08.0201 - Businessand Pers Serv Mrkt General", add 
label define label_cipcode3 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode3 80706 "08.0706 - General Selling Skills and Sales Opns.", add 
label define label_cipcode3 80708 "08.0708 - General Marketing Operations", add 
label define label_cipcode3 80799 "08.0799 - Gen. Retail and Wholesale Opns. and Skills, Other", add 
label define label_cipcode3 80901 "08.0901 - Hospitality and Rec. Marketing Opns, General", add 
label define label_cipcode3 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode3 81101 "08.1101 - Transp and Travel Market, General", add 
label define label_cipcode3 81102 "08.1102 - Transportation Marketing", add 
label define label_cipcode3 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode3 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode3 81199 "08.1199 - Tourism and Travel Srvc. Market. Opns., Other", add 
label define label_cipcode3 89999 "08.9999 - Marketing Opns/Market. and Distrib., Other", add 
label define label_cipcode3 90201 "09.0201 - Advertising", add 
label define label_cipcode3 90601 "09.0601 - Radio/Tv News Broadcasting", add 
label define label_cipcode3 100105 "10.0105 - Sound Recording Technology", add 
label define label_cipcode3 100106 "10.0106 - Video Technology", add 
label define label_cipcode3 110101 "11.0101 - Computer and Information Sciences, General", add 
label define label_cipcode3 110201 "11.0201 - Computer Programming", add 
label define label_cipcode3 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode3 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode3 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode3 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode3 120101 "12.0101 - Drycleaningand Laundering Services", add 
label define label_cipcode3 120202 "12.0202 - Bartending", add 
label define label_cipcode3 120203 "12.0203 - Card Dealer", add 
label define label_cipcode3 120301 "12.0301 - Funeral Services and Mortuary Science", add 
label define label_cipcode3 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode3 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode3 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode3 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode3 120405 "12.0405 - Massage", add 
label define label_cipcode3 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode3 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode3 129999 "12.9999 - Personal and Miscellaneous Services, Other", add 
label define label_cipcode3 130604 "13.0604 - Educ. Assessment, Testing and Measurement", add 
label define label_cipcode3 131201 "13.1201 - Adult and Continuing Teacher Education", add 
label define label_cipcode3 131204 "13.1204 - Pre-Elem/Erly Childhd/Kg. Teach Educ.", add 
label define label_cipcode3 131299 "13.1299 - General Teacher Education, Other", add 
label define label_cipcode3 131319 "13.1319 - Technical Teacher Education (Vocational)", add 
label define label_cipcode3 131320 "13.1320 - Trade and Industrial Teacher Educ. (Voc)", add 
label define label_cipcode3 131321 "13.1321 - Computer Teacher Education", add 
label define label_cipcode3 131399 "13.1399 - Teacher Ed., Spec Acad and Voc Prog, Other", add 
label define label_cipcode3 131401 "13.1401 - Teaching Esl/Foreign Language", add 
label define label_cipcode3 131501 "13.1501 - Teacher Assistant/Aide", add 
label define label_cipcode3 139999 "13.9999 - Education, Other", add 
label define label_cipcode3 140101 "14.0101 - Engineering, General", add 
label define label_cipcode3 141001 "14.1001 - Electrical, Electronics and Communication", add 
label define label_cipcode3 150202 "15.0202 - Drafting and Design Technology", add 
label define label_cipcode3 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode3 150302 "15.0302 - Electrical Technology", add 
label define label_cipcode3 150303 "15.0303 - Elec., Electronic and Comm. Engin. Tech.", add 
label define label_cipcode3 150399 "15.0399 - Electrical and Electronic Engin.-Rel. Tech.", add 
label define label_cipcode3 150403 "15.0403 - Electromechanical Tech./Technician", add 
label define label_cipcode3 150404 "15.0404 - Instrumentation Tech./Technician", add 
label define label_cipcode3 150405 "15.0405 - Robotics Tech./Technician", add 
label define label_cipcode3 150599 "15.0599 - Environmental Control Tech, Other", add 
label define label_cipcode3 150610 "15.0610 - Welding Technology", add 
label define label_cipcode3 150801 "15.0801 - Aeronautical and Aerospace Engineering Tech.", add 
label define label_cipcode3 150803 "15.0803 - Automotive Engineering Tech./Technician", add 
label define label_cipcode3 159999 "15.9999 - Engineering-Related Technol./Techn, Other", add 
label define label_cipcode3 160902 "16.0902 - Italian Language and Literature", add 
label define label_cipcode3 160905 "16.0905 - Spanish Language and Literature", add 
label define label_cipcode3 161001 "16.1001 - Native American Languages", add 
label define label_cipcode3 169999 "16.9999 - Foreign Languages and Literatures, Other", add 
label define label_cipcode3 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode3 170103 "17.0103 - Dental Laboratory Technology", add 
label define label_cipcode3 170203 "17.0203 - Electrocardiograph Techn.", add 
label define label_cipcode3 170204 "17.0204 - Electroencephalograph Tech", add 
label define label_cipcode3 170206 "17.0206 - Emergency Med Tech-Paramedic", add 
label define label_cipcode3 170209 "17.0209 - Radiologic (Medical) Tech.", add 
label define label_cipcode3 170211 "17.0211 - Surgical Technology", add 
label define label_cipcode3 170299 "17.0299 - Diagnstic andTreatmnt Srvc., Other", add 
label define label_cipcode3 170305 "17.0305 - Clinical Laboratory Assist", add 
label define label_cipcode3 170307 "17.0307 - Hematology Technology", add 
label define label_cipcode3 170309 "17.0309 - Medical Laboratory Techn.", add 
label define label_cipcode3 170399 "17.0399 - Medical Lab Technologies, Other", add 
label define label_cipcode3 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode3 170405 "17.0405 - Mental Health/Hum Serv Asst", add 
label define label_cipcode3 170499 "17.0499 - Ment Health/Human Serv, Other", add 
label define label_cipcode3 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode3 170505 "17.0505 - Medical Office Management", add 
label define label_cipcode3 170506 "17.0506 - Medical Records Technology", add 
label define label_cipcode3 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode3 170508 "17.0508 - Physician Assisting", add 
label define label_cipcode3 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode3 170513 "17.0513 - Health Unit Coordinating", add 
label define label_cipcode3 170514 "17.0514 - Chiropractic Assisting", add 
label define label_cipcode3 170599 "17.0599 - Misc Allied Health Serv, Other", add 
label define label_cipcode3 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode3 170605 "17.0605 - Practical Nursing", add 
label define label_cipcode3 170606 "17.0606 - Health Unit Management", add 
label define label_cipcode3 170699 "17.0699 - Nursing-Related Servs, Other", add 
label define label_cipcode3 170701 "17.0701 - Ophthalmic Dispensing", add 
label define label_cipcode3 170899 "17.0899 - Rehabilitation Services, Other", add 
label define label_cipcode3 179999 "17.9999 - Allied Health, Other", add 
label define label_cipcode3 180299 "18.0299 - Basic Clin Health Sci, Other", add 
label define label_cipcode3 180701 "18.0701 - Health Services Admin", add 
label define label_cipcode3 180703 "18.0703 - Medical Records Admin", add 
label define label_cipcode3 180799 "18.0799 - Health Services Admin, Other", add 
label define label_cipcode3 181101 "18.1101 - Nursing, General", add 
label define label_cipcode3 181199 "18.1199 - Nursing, Other", add 
label define label_cipcode3 182299 "18.2299 - Public Health, Other", add 
label define label_cipcode3 189999 "18.9999 - Health Sciences, Other", add 
label define label_cipcode3 199999 "19.9999 - Home Economics, Other", add 
label define label_cipcode3 200201 "20.0201 - Child Care/Guidance Workers and Managers, General", add 
label define label_cipcode3 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode3 200304 "20.0304 - Custom Apparel/Garment Seam", add 
label define label_cipcode3 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode3 200306 "20.0306 - Fashion and Fabric Consultant", add 
label define label_cipcode3 200401 "20.0401 - Institutional Food Workers and Admin, General", add 
label define label_cipcode3 200403 "20.0403 - Chef/Cook", add 
label define label_cipcode3 200406 "20.0406 - Food Service", add 
label define label_cipcode3 200504 "20.0504 - Floral Design", add 
label define label_cipcode3 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode3 209999 "20.9999 - Vocational Home Economics, Other", add 
label define label_cipcode3 210101 "21.0101 - Technology Education/Industrial Arts", add 
label define label_cipcode3 210102 "21.0102 - Construction (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode3 210103 "21.0103 - Drafting and Design (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode3 210104 "21.0104 - Electricity/Electronics (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode3 210107 "21.0107 - Manufacturing/Materials Processing (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode3 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode3 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode3 230201 "23.0201 - Classics", add 
label define label_cipcode3 231201 "23.1201 - English As A Second Language", add 
label define label_cipcode3 260607 "26.0607 - Marine/Aquatic Biology", add 
label define label_cipcode3 320102 "32.0102 - Academic and Intellectual Skills (1985 code replaced in 1990 with 32.0108)", add 
label define label_cipcode3 320199 "32.0199 - Basic Skills, Other", add 
label define label_cipcode3 350199 "35.0199 - Interpersonal Social Skills, Other", add 
label define label_cipcode3 360102 "36.0102 - Handicrafts and Model-Making", add 
label define label_cipcode3 360109 "36.0109 - Travel and Exploration", add 
label define label_cipcode3 370101 "37.0101 - Self-Awareness and Personal Assessment", add 
label define label_cipcode3 370104 "37.0104 - Self-Esteem and Values Clarification", add 
label define label_cipcode3 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode3 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode3 390301 "39.0301 - Missions/Missionary Studies and Misology", add 
label define label_cipcode3 399999 "39.9999 - Theological Studies and Rel. Vocations, Other", add 
label define label_cipcode3 420601 "42.0601 - Counseling Psychology", add 
label define label_cipcode3 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode3 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode3 430201 "43.0201 - Fire Protection and Safety Tech./Technic", add 
label define label_cipcode3 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode3 460201 "46.0201 - Carpenter", add 
label define label_cipcode3 460302 "46.0302 - Electrician", add 
label define label_cipcode3 460399 "46.0399 - Elec. and Power Trans. Installer, Other", add 
label define label_cipcode3 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode3 460403 "46.0403 - Construction/Building Inspector", add 
label define label_cipcode3 460499 "46.0499 - Const. and Bldg. Finishers and Managers, Other", add 
label define label_cipcode3 460503 "46.0503 - Plumbing", add 
label define label_cipcode3 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode3 470101 "47.0101 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode3 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode3 470105 "47.0105 - Indus. Electronics Installer and Repairer", add 
label define label_cipcode3 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode3 470199 "47.0199 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode3 470201 "47.0201 - Heating, Air Conditioning and Refrigerat", add 
label define label_cipcode3 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode3 470299 "47.0299 - Heat AircondandRefrig Mech., Other", add 
label define label_cipcode3 470303 "47.0303 - Industrial Machinery Main. and Repairer", add 
label define label_cipcode3 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode3 470404 "47.0404 - Musical Instrument Repairer", add 
label define label_cipcode3 470601 "47.0601 - Veh and Mob Equip Mech/Rep, General", add 
label define label_cipcode3 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode3 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode3 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode3 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode3 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode3 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode3 470699 "47.0699 - Vehicle and Mobile Equip. Mechanics and Rep.", add 
label define label_cipcode3 479999 "47.9999 - Mechanics and Repairers, Other", add 
label define label_cipcode3 480101 "48.0101 - Drafting, General", add 
label define label_cipcode3 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode3 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode3 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode3 480203 "48.0203 - Commercial Air", add 
label define label_cipcode3 480206 "48.0206 - Lithographer and Platemaker", add 
label define label_cipcode3 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode3 480299 "48.0299 - Graphic and Printing Equip. Operator, Other", add 
label define label_cipcode3 480303 "48.0303 - Upholsterer", add 
label define label_cipcode3 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode3 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode3 480602 "48.0602 - Jewelry Design Fab and Repair", add 
label define label_cipcode3 480604 "48.0604 - Plastics", add 
label define label_cipcode3 480699 "48.0699 - Preci Wrk, Assrted Mats., Other", add 
label define label_cipcode3 489999 "48.9999 - Precision Production Trades, Other", add 
label define label_cipcode3 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode3 490102 "49.0102 - Aircraft Pilot and Navigator (Professional)", add 
label define label_cipcode3 490104 "49.0104 - Aviation Management", add 
label define label_cipcode3 490105 "49.0105 - Air Traffic Controller", add 
label define label_cipcode3 490106 "49.0106 - Flight Attendant", add 
label define label_cipcode3 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode3 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode3 490205 "49.0205 - Truck, Bus and Oth. Commercial Vehicle Op.", add 
label define label_cipcode3 490301 "49.0301 - Water Transportation, Gen", add 
label define label_cipcode3 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode3 490399 "49.0399 - Water Transportation Workers, Other", add 
label define label_cipcode3 500101 "50.0101 - Visual and Performing Arts", add 
label define label_cipcode3 500402 "50.0402 - Graphic Design, Commercial Art and Illus.", add 
label define label_cipcode3 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode3 500601 "50.0601 - Film/Cinema Studies", add 
label define label_cipcode3 500605 "50.0605 - Photography", add 
label define label_cipcode3 500699 "50.0699 - Film/Video and Photographic Arts, Other", add 
label define label_cipcode3 500701 "50.0701 - Art, General", add 
label define label_cipcode3 500799 "50.0799 - Fine Arts and Art Studies, Other", add 
label define label_cipcode3 500903 "50.0903 - Music - General Performance", add 
label define label_cipcode3 500999 "50.0999 - Music, Other", add 
label define label_cipcode3 509999 "50.9999 - Visual and Performing Arts, Other", add 
label values cipcode3 label_cipcode3
label define label_cipcode4 10504 "01.0504 - Pet Grooming" 
label define label_cipcode4 10505 "01.0505 - Animal Trainer", add 
label define label_cipcode4 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode4 10507 "01.0507 - Eques./Equine Stds., Horse Mgmt. and Trgn.", add 
label define label_cipcode4 10605 "01.0605 - Landscaping Operations and Management", add 
label define label_cipcode4 20299 "02.0299 - Animal Sciences, Other", add 
label define label_cipcode4 40501 "04.0501 - Interior Architecture", add 
label define label_cipcode4 60101 "06.0101 - Business and Management, General", add 
label define label_cipcode4 60201 "06.0201 - Accounting", add 
label define label_cipcode4 60401 "06.0401 - Business Admin and Manage, General", add 
label define label_cipcode4 60701 "06.0701 - Hotel/Motel Management", add 
label define label_cipcode4 60801 "06.0801 - Insurance and Risk Management", add 
label define label_cipcode4 61501 "06.1501 - Organizational Behavior", add 
label define label_cipcode4 61701 "06.1701 - Real Estate", add 
label define label_cipcode4 61901 "06.1901 - Taxation", add 
label define label_cipcode4 69999 "06.9999 - Business and Management, Other", add 
label define label_cipcode4 70101 "07.0101 - Acct Bookkeep and Related Progms", add 
label define label_cipcode4 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode4 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode4 70199 "07.0199 - Acct, Book, and Rel Progs, Other", add 
label define label_cipcode4 70201 "07.0201 - Banking and Rel Fin Progs, General", add 
label define label_cipcode4 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode4 70299 "07.0299 - Banking and Rel Fin Progs, Other", add 
label define label_cipcode4 70301 "07.0301 - Bus Data Process and Rel Progms", add 
label define label_cipcode4 70302 "07.0302 - Bus Computer and Console Oper", add 
label define label_cipcode4 70303 "07.0303 - Bus Data Entry Equip Operat", add 
label define label_cipcode4 70399 "07.0399 - Bus Data Pro and Rel Progs, Other", add 
label define label_cipcode4 70401 "07.0401 - Office Supervision and Managem", add 
label define label_cipcode4 70601 "07.0601 - Secretarial and Rel Progs, General", add 
label define label_cipcode4 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode4 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode4 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode4 70606 "07.0606 - Secretarial", add 
label define label_cipcode4 70607 "07.0607 - Stenographic", add 
label define label_cipcode4 70699 "07.0699 - Secretarial and Relat Progm Other", add 
label define label_cipcode4 70701 "07.0701 - Typing, Gen Off and Rel Progms", add 
label define label_cipcode4 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode4 70705 "07.0705 - General Office Clerk", add 
label define label_cipcode4 70708 "07.0708 - Ship, Receiv and Stock Clerk", add 
label define label_cipcode4 70801 "07.0801 - Word Processing", add 
label define label_cipcode4 79999 "07.9999 - Business (Admin Supp) Other", add 
label define label_cipcode4 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode4 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode4 80201 "08.0201 - Businessand Pers Serv Mrkt General", add 
label define label_cipcode4 80301 "08.0301 - Entrepreneurship", add 
label define label_cipcode4 80503 "08.0503 - Floristry Marketing Operations", add 
label define label_cipcode4 80706 "08.0706 - General Selling Skills and Sales Opns.", add 
label define label_cipcode4 80708 "08.0708 - General Marketing Operations", add 
label define label_cipcode4 81001 "08.1001 - Insurance Marketing Operations", add 
label define label_cipcode4 81101 "08.1101 - Transp and Travel Market, General", add 
label define label_cipcode4 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode4 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode4 81199 "08.1199 - Tourism and Travel Srvc. Market. Opns., Other", add 
label define label_cipcode4 90601 "09.0601 - Radio/Tv News Broadcasting", add 
label define label_cipcode4 90801 "09.0801 - Telecommunictions", add 
label define label_cipcode4 100104 "10.0104 - Radio and Television Broadcasting Tech.", add 
label define label_cipcode4 100105 "10.0105 - Sound Recording Technology", add 
label define label_cipcode4 100199 "10.0199 - Communications Technol./Technicians, Other", add 
label define label_cipcode4 110101 "11.0101 - Computer and Information Sciences, General", add 
label define label_cipcode4 110201 "11.0201 - Computer Programming", add 
label define label_cipcode4 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode4 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode4 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode4 120101 "12.0101 - Drycleaningand Laundering Services", add 
label define label_cipcode4 120203 "12.0203 - Card Dealer", add 
label define label_cipcode4 120299 "12.0299 - Gaming and Sports Officiating Services, Other", add 
label define label_cipcode4 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode4 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode4 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode4 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode4 120405 "12.0405 - Massage", add 
label define label_cipcode4 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode4 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode4 129999 "12.9999 - Personal and Miscellaneous Services, Other", add 
label define label_cipcode4 130301 "13.0301 - Curriculum and Instruction", add 
label define label_cipcode4 131319 "13.1319 - Technical Teacher Education (Vocational)", add 
label define label_cipcode4 131320 "13.1320 - Trade and Industrial Teacher Educ. (Voc)", add 
label define label_cipcode4 131399 "13.1399 - Teacher Ed., Spec Acad and Voc Prog, Other", add 
label define label_cipcode4 131401 "13.1401 - Teaching Esl/Foreign Language", add 
label define label_cipcode4 131501 "13.1501 - Teacher Assistant/Aide", add 
label define label_cipcode4 139999 "13.9999 - Education, Other", add 
label define label_cipcode4 141901 "14.1901 - Mechanical Engineering", add 
label define label_cipcode4 150202 "15.0202 - Drafting and Design Technology", add 
label define label_cipcode4 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode4 150303 "15.0303 - Elec., Electronic and Comm. Engin. Tech.", add 
label define label_cipcode4 150399 "15.0399 - Electrical and Electronic Engin.-Rel. Tech.", add 
label define label_cipcode4 150401 "15.0401 - Biomedical Engineering-Related Tech.", add 
label define label_cipcode4 150402 "15.0402 - Computer Main. Tech./Technician", add 
label define label_cipcode4 150403 "15.0403 - Electromechanical Tech./Technician", add 
label define label_cipcode4 150499 "15.0499 - Electromechanical Instrum. and Maint. Tech.", add 
label define label_cipcode4 150501 "15.0501 - Heating, Air Condition. and Refrig. Tech.", add 
label define label_cipcode4 150502 "15.0502 - Air Pollution Control Tech.", add 
label define label_cipcode4 150610 "15.0610 - Welding Technology", add 
label define label_cipcode4 150702 "15.0702 - Quality Control Tech./Technician", add 
label define label_cipcode4 160399 "16.0399 - East/Southeast Asian Lang. and Lit., Other", add 
label define label_cipcode4 160901 "16.0901 - French Language and Literature", add 
label define label_cipcode4 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode4 170103 "17.0103 - Dental Laboratory Technology", add 
label define label_cipcode4 170201 "17.0201 - Cardiovascular Technology", add 
label define label_cipcode4 170203 "17.0203 - Electrocardiograph Techn.", add 
label define label_cipcode4 170208 "17.0208 - Nuclear Medical Technology", add 
label define label_cipcode4 170209 "17.0209 - Radiologic (Medical) Tech.", add 
label define label_cipcode4 170305 "17.0305 - Clinical Laboratory Assist", add 
label define label_cipcode4 170307 "17.0307 - Hematology Technology", add 
label define label_cipcode4 170308 "17.0308 - Histologic Technology", add 
label define label_cipcode4 170309 "17.0309 - Medical Laboratory Techn.", add 
label define label_cipcode4 170310 "17.0310 - Medical Technology", add 
label define label_cipcode4 170399 "17.0399 - Medical Lab Technologies, Other", add 
label define label_cipcode4 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode4 170499 "17.0499 - Ment Health/Human Serv, Other", add 
label define label_cipcode4 170502 "17.0502 - Central Supply Technology", add 
label define label_cipcode4 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode4 170505 "17.0505 - Medical Office Management", add 
label define label_cipcode4 170506 "17.0506 - Medical Records Technology", add 
label define label_cipcode4 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode4 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode4 170599 "17.0599 - Misc Allied Health Serv, Other", add 
label define label_cipcode4 170601 "17.0601 - Geriatric Aide", add 
label define label_cipcode4 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode4 170699 "17.0699 - Nursing-Related Servs, Other", add 
label define label_cipcode4 170701 "17.0701 - Ophthalmic Dispensing", add 
label define label_cipcode4 170799 "17.0799 - Ophthalmic Services, Other", add 
label define label_cipcode4 170812 "17.0812 - Orthopedic Assisting", add 
label define label_cipcode4 170814 "17.0814 - Physical Therapy Aide", add 
label define label_cipcode4 170818 "17.0818 - Respiratory Therapy", add 
label define label_cipcode4 179999 "17.9999 - Allied Health, Other", add 
label define label_cipcode4 180701 "18.0701 - Health Services Admin", add 
label define label_cipcode4 180702 "18.0702 - Health Care Planning", add 
label define label_cipcode4 180703 "18.0703 - Medical Records Admin", add 
label define label_cipcode4 181401 "18.1401 - Pharmacy", add 
label define label_cipcode4 182299 "18.2299 - Public Health, Other", add 
label define label_cipcode4 189999 "18.9999 - Health Sciences, Other", add 
label define label_cipcode4 200109 "20.0109 - Home Management", add 
label define label_cipcode4 200201 "20.0201 - Child Care/Guidance Workers and Managers, General", add 
label define label_cipcode4 200299 "20.0299 - Child Care/Guidance Workers and Managers, Other", add 
label define label_cipcode4 200304 "20.0304 - Custom Apparel/Garment Seam", add 
label define label_cipcode4 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode4 200401 "20.0401 - Institutional Food Workers and Admin, General", add 
label define label_cipcode4 200403 "20.0403 - Chef/Cook", add 
label define label_cipcode4 200405 "20.0405 - Food Caterer", add 
label define label_cipcode4 200406 "20.0406 - Food Service", add 
label define label_cipcode4 200503 "20.0503 - Custom Slipcovering and Uphols", add 
label define label_cipcode4 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode4 210103 "21.0103 - Drafting and Design (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode4 210104 "21.0104 - Electricity/Electronics (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode4 210106 "21.0106 - Graphic Arts (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode4 210107 "21.0107 - Manufacturing/Materials Processing (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode4 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode4 220199 "22.0199 - Law and Legal Studies, Other", add 
label define label_cipcode4 231201 "23.1201 - English As A Second Language", add 
label define label_cipcode4 239999 "23.9999 - English Language and Literature/Letters,", add 
label define label_cipcode4 260501 "26.0501 - Microbiology/Bacteriology", add 
label define label_cipcode4 320101 "32.0101 - Basic Skills, General", add 
label define label_cipcode4 320199 "32.0199 - Basic Skills, Other", add 
label define label_cipcode4 360102 "36.0102 - Handicrafts and Model-Making", add 
label define label_cipcode4 360109 "36.0109 - Travel and Exploration", add 
label define label_cipcode4 360199 "36.0199 - Leisure and Recreational Activities, Other", add 
label define label_cipcode4 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode4 390601 "39.0601 - Theology/Theological Studies", add 
label define label_cipcode4 429999 "42.9999 - Psychology, Other", add 
label define label_cipcode4 430105 "43.0105 - Criminal Justice Technology", add 
label define label_cipcode4 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode4 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode4 430199 "43.0199 - Criminal Justice and Corrections, Other", add 
label define label_cipcode4 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode4 440702 "44.0702 - Medical Social Work", add 
label define label_cipcode4 460199 "46.0199 - Brickmasonry, Stonemasonry, and Tile Setting, Other (1985 code replaced in 1990 with 46.0101)", add 
label define label_cipcode4 460201 "46.0201 - Carpenter", add 
label define label_cipcode4 460302 "46.0302 - Electrician", add 
label define label_cipcode4 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode4 460403 "46.0403 - Construction/Building Inspector", add 
label define label_cipcode4 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode4 470101 "47.0101 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode4 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode4 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode4 470199 "47.0199 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode4 470201 "47.0201 - Heating, Air Conditioning and Refrigerat", add 
label define label_cipcode4 470202 "47.0202 - Cooling and Refrigeration", add 
label define label_cipcode4 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode4 470299 "47.0299 - Heat AircondandRefrig Mech., Other", add 
label define label_cipcode4 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode4 470601 "47.0601 - Veh and Mob Equip Mech/Rep, General", add 
label define label_cipcode4 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode4 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode4 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode4 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode4 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode4 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode4 470699 "47.0699 - Vehicle and Mobile Equip. Mechanics and Rep.", add 
label define label_cipcode4 480101 "48.0101 - Drafting, General", add 
label define label_cipcode4 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode4 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode4 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode4 480201 "48.0201 - Graphic and Printing Equip. Operator, General", add 
label define label_cipcode4 480203 "48.0203 - Commercial Air", add 
label define label_cipcode4 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode4 480299 "48.0299 - Graphic and Printing Equip. Operator, Other", add 
label define label_cipcode4 480501 "48.0501 - Machinist/Machine Technologist", add 
label define label_cipcode4 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode4 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode4 480699 "48.0699 - Preci Wrk, Assrted Mats., Other", add 
label define label_cipcode4 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode4 490102 "49.0102 - Aircraft Pilot and Navigator (Professional)", add 
label define label_cipcode4 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode4 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode4 490205 "49.0205 - Truck, Bus and Oth. Commercial Vehicle Op.", add 
label define label_cipcode4 490301 "49.0301 - Water Transportation, Gen", add 
label define label_cipcode4 490399 "49.0399 - Water Transportation Workers, Other", add 
label define label_cipcode4 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode4 500601 "50.0601 - Film/Cinema Studies", add 
label define label_cipcode4 500605 "50.0605 - Photography", add 
label define label_cipcode4 500701 "50.0701 - Art, General", add 
label define label_cipcode4 500904 "50.0904 - Music Theory and Composition", add 
label define label_cipcode4 500999 "50.0999 - Music, Other", add 
label define label_cipcode4 509999 "50.9999 - Visual and Performing Arts, Other", add 
label values cipcode4 label_cipcode4
label define label_cipcode5 10505 "01.0505 - Animal Trainer" 
label define label_cipcode5 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode5 10507 "01.0507 - Eques./Equine Stds., Horse Mgmt. and Trgn.", add 
label define label_cipcode5 10699 "01.0699 - Horticulture Svcs. Ops. and Mgmt., Other", add 
label define label_cipcode5 40301 "04.0301 - City/Urban, Community and Reg. Planning", add 
label define label_cipcode5 40501 "04.0501 - Interior Architecture", add 
label define label_cipcode5 60101 "06.0101 - Business and Management, General", add 
label define label_cipcode5 60201 "06.0201 - Accounting", add 
label define label_cipcode5 60499 "06.0499 - Business Admin and Manage, Other", add 
label define label_cipcode5 60701 "06.0701 - Hotel/Motel Management", add 
label define label_cipcode5 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode5 61701 "06.1701 - Real Estate", add 
label define label_cipcode5 69999 "06.9999 - Business and Management, Other", add 
label define label_cipcode5 70101 "07.0101 - Acct Bookkeep and Related Progms", add 
label define label_cipcode5 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode5 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode5 70199 "07.0199 - Acct, Book, and Rel Progs, Other", add 
label define label_cipcode5 70299 "07.0299 - Banking and Rel Fin Progs, Other", add 
label define label_cipcode5 70301 "07.0301 - Bus Data Process and Rel Progms", add 
label define label_cipcode5 70302 "07.0302 - Bus Computer and Console Oper", add 
label define label_cipcode5 70303 "07.0303 - Bus Data Entry Equip Operat", add 
label define label_cipcode5 70305 "07.0305 - Business Data Programming", add 
label define label_cipcode5 70399 "07.0399 - Bus Data Pro and Rel Progs, Other", add 
label define label_cipcode5 70401 "07.0401 - Office Supervision and Managem", add 
label define label_cipcode5 70601 "07.0601 - Secretarial and Rel Progs, General", add 
label define label_cipcode5 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode5 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode5 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode5 70606 "07.0606 - Secretarial", add 
label define label_cipcode5 70607 "07.0607 - Stenographic", add 
label define label_cipcode5 70699 "07.0699 - Secretarial and Relat Progm Other", add 
label define label_cipcode5 70701 "07.0701 - Typing, Gen Off and Rel Progms", add 
label define label_cipcode5 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode5 70704 "07.0704 - Duplicating Machine Operate", add 
label define label_cipcode5 70705 "07.0705 - General Office Clerk", add 
label define label_cipcode5 70707 "07.0707 - Receptionist and Comm Systs Op.", add 
label define label_cipcode5 70708 "07.0708 - Ship, Receiv and Stock Clerk", add 
label define label_cipcode5 70799 "07.0799 - Typing Gen Off and Rel Prog Other", add 
label define label_cipcode5 70801 "07.0801 - Word Processing", add 
label define label_cipcode5 79999 "07.9999 - Business (Admin Supp) Other", add 
label define label_cipcode5 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode5 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode5 80706 "08.0706 - General Selling Skills and Sales Opns.", add 
label define label_cipcode5 81101 "08.1101 - Transp and Travel Market, General", add 
label define label_cipcode5 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode5 81199 "08.1199 - Tourism and Travel Srvc. Market. Opns., Other", add 
label define label_cipcode5 99999 "09.9999 - Communications, Other", add 
label define label_cipcode5 100105 "10.0105 - Sound Recording Technology", add 
label define label_cipcode5 110101 "11.0101 - Computer and Information Sciences, General", add 
label define label_cipcode5 110201 "11.0201 - Computer Programming", add 
label define label_cipcode5 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode5 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode5 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode5 120101 "12.0101 - Drycleaningand Laundering Services", add 
label define label_cipcode5 120203 "12.0203 - Card Dealer", add 
label define label_cipcode5 120299 "12.0299 - Gaming and Sports Officiating Services, Other", add 
label define label_cipcode5 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode5 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode5 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode5 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode5 120405 "12.0405 - Massage", add 
label define label_cipcode5 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode5 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode5 129999 "12.9999 - Personal and Miscellaneous Services, Other", add 
label define label_cipcode5 131320 "13.1320 - Trade and Industrial Teacher Educ. (Voc)", add 
label define label_cipcode5 131399 "13.1399 - Teacher Ed., Spec Acad and Voc Prog, Other", add 
label define label_cipcode5 131401 "13.1401 - Teaching Esl/Foreign Language", add 
label define label_cipcode5 131501 "13.1501 - Teacher Assistant/Aide", add 
label define label_cipcode5 139999 "13.9999 - Education, Other", add 
label define label_cipcode5 140101 "14.0101 - Engineering, General", add 
label define label_cipcode5 141001 "14.1001 - Electrical, Electronics and Communication", add 
label define label_cipcode5 150202 "15.0202 - Drafting and Design Technology", add 
label define label_cipcode5 150301 "15.0301 - Computer Engineering Tech./Technician", add 
label define label_cipcode5 150302 "15.0302 - Electrical Technology", add 
label define label_cipcode5 150303 "15.0303 - Elec., Electronic and Comm. Engin. Tech.", add 
label define label_cipcode5 150399 "15.0399 - Electrical and Electronic Engin.-Rel. Tech.", add 
label define label_cipcode5 150403 "15.0403 - Electromechanical Tech./Technician", add 
label define label_cipcode5 150499 "15.0499 - Electromechanical Instrum. and Maint. Tech.", add 
label define label_cipcode5 150501 "15.0501 - Heating, Air Condition. and Refrig. Tech.", add 
label define label_cipcode5 150610 "15.0610 - Welding Technology", add 
label define label_cipcode5 150702 "15.0702 - Quality Control Tech./Technician", add 
label define label_cipcode5 150803 "15.0803 - Automotive Engineering Tech./Technician", add 
label define label_cipcode5 160403 "16.0403 - Slavic Lang. and Lit. (Other Than Russian)", add 
label define label_cipcode5 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode5 170103 "17.0103 - Dental Laboratory Technology", add 
label define label_cipcode5 170203 "17.0203 - Electrocardiograph Techn.", add 
label define label_cipcode5 170204 "17.0204 - Electroencephalograph Tech", add 
label define label_cipcode5 170205 "17.0205 - Emergency Med Tech-Ambulance", add 
label define label_cipcode5 170209 "17.0209 - Radiologic (Medical) Tech.", add 
label define label_cipcode5 170211 "17.0211 - Surgical Technology", add 
label define label_cipcode5 170212 "17.0212 - Diagnostic Med Sonography", add 
label define label_cipcode5 170299 "17.0299 - Diagnstic andTreatmnt Srvc., Other", add 
label define label_cipcode5 170305 "17.0305 - Clinical Laboratory Assist", add 
label define label_cipcode5 170307 "17.0307 - Hematology Technology", add 
label define label_cipcode5 170308 "17.0308 - Histologic Technology", add 
label define label_cipcode5 170309 "17.0309 - Medical Laboratory Techn.", add 
label define label_cipcode5 170401 "17.0401 - Alcohol/Drug Abuse Specialty", add 
label define label_cipcode5 170499 "17.0499 - Ment Health/Human Serv, Other", add 
label define label_cipcode5 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode5 170505 "17.0505 - Medical Office Management", add 
label define label_cipcode5 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode5 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode5 170513 "17.0513 - Health Unit Coordinating", add 
label define label_cipcode5 170599 "17.0599 - Misc Allied Health Serv, Other", add 
label define label_cipcode5 170601 "17.0601 - Geriatric Aide", add 
label define label_cipcode5 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode5 170699 "17.0699 - Nursing-Related Servs, Other", add 
label define label_cipcode5 170814 "17.0814 - Physical Therapy Aide", add 
label define label_cipcode5 170818 "17.0818 - Respiratory Therapy", add 
label define label_cipcode5 179999 "17.9999 - Allied Health, Other", add 
label define label_cipcode5 180703 "18.0703 - Medical Records Admin", add 
label define label_cipcode5 181030 "18.1030 - Sports Medicine", add 
label define label_cipcode5 182299 "18.2299 - Public Health, Other", add 
label define label_cipcode5 190902 "19.0902 - Fashion Design", add 
label define label_cipcode5 200102 "20.0102 - Child Devel, Care and Guidance", add 
label define label_cipcode5 200201 "20.0201 - Child Care/Guidance Workers and Managers, General", add 
label define label_cipcode5 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode5 200301 "20.0301 - Clothing, Apparel and Textile Workers and Managers, General", add 
label define label_cipcode5 200303 "20.0303 - Commercial Garment and Apparel Worker", add 
label define label_cipcode5 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode5 200402 "20.0402 - Baking", add 
label define label_cipcode5 200406 "20.0406 - Food Service", add 
label define label_cipcode5 200504 "20.0504 - Floral Design", add 
label define label_cipcode5 200505 "20.0505 - Home Decorating", add 
label define label_cipcode5 210103 "21.0103 - Drafting and Design (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode5 210104 "21.0104 - Electricity/Electronics (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode5 210105 "21.0105 - Energy, Power, and Transportation (1985 code deleted In 1990)", add 
label define label_cipcode5 210106 "21.0106 - Graphic Arts (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode5 210107 "21.0107 - Manufacturing/Materials Processing (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode5 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode5 231201 "23.1201 - English As A Second Language", add 
label define label_cipcode5 260601 "26.0601 - Anatomy", add 
label define label_cipcode5 260608 "26.0608 - Neuroscience", add 
label define label_cipcode5 290101 "29.0101 - Military Technologies", add 
label define label_cipcode5 320199 "32.0199 - Basic Skills, Other", add 
label define label_cipcode5 340199 "34.0199 - Health-Related Knowledge and Skills, Other", add 
label define label_cipcode5 360102 "36.0102 - Handicrafts and Model-Making", add 
label define label_cipcode5 360199 "36.0199 - Leisure and Recreational Activities, Other", add 
label define label_cipcode5 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode5 390601 "39.0601 - Theology/Theological Studies", add 
label define label_cipcode5 430102 "43.0102 - Corrections/Correctional Administration", add 
label define label_cipcode5 430107 "43.0107 - Law Enforcement/Police Science", add 
label define label_cipcode5 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode5 440401 "44.0401 - Public Administration", add 
label define label_cipcode5 460102 "46.0102 - Brickmasonry, Block and Stone", add 
label define label_cipcode5 460201 "46.0201 - Carpenter", add 
label define label_cipcode5 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode5 460501 "46.0501 - Plumber and Pipefitter", add 
label define label_cipcode5 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode5 470101 "47.0101 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode5 470102 "47.0102 - Business Machine Repairer", add 
label define label_cipcode5 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode5 470105 "47.0105 - Indus. Electronics Installer and Repairer", add 
label define label_cipcode5 470106 "47.0106 - Major Appliance Installer and Repairer", add 
label define label_cipcode5 470201 "47.0201 - Heating, Air Conditioning and Refrigerat", add 
label define label_cipcode5 470202 "47.0202 - Cooling and Refrigeration", add 
label define label_cipcode5 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode5 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode5 470603 "47.0603 - Auto/Automotive Body Repairer", add 
label define label_cipcode5 470604 "47.0604 - Auto/Automotive Mechanic/Technician", add 
label define label_cipcode5 470605 "47.0605 - Diesel Engine Mechanic and Repairer", add 
label define label_cipcode5 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode5 470608 "47.0608 - Aircraft Mechanic/Technician, Powerplant", add 
label define label_cipcode5 470699 "47.0699 - Vehicle and Mobile Equip. Mechanics and Rep.", add 
label define label_cipcode5 480101 "48.0101 - Drafting, General", add 
label define label_cipcode5 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode5 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode5 480206 "48.0206 - Lithographer and Platemaker", add 
label define label_cipcode5 480299 "48.0299 - Graphic and Printing Equip. Operator, Other", add 
label define label_cipcode5 480507 "48.0507 - Tool and Die Maker/Technologist", add 
label define label_cipcode5 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode5 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode5 490102 "49.0102 - Aircraft Pilot and Navigator (Professional)", add 
label define label_cipcode5 490104 "49.0104 - Aviation Management", add 
label define label_cipcode5 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode5 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode5 490205 "49.0205 - Truck, Bus and Oth. Commercial Vehicle Op.", add 
label define label_cipcode5 490301 "49.0301 - Water Transportation, Gen", add 
label define label_cipcode5 490399 "49.0399 - Water Transportation Workers, Other", add 
label define label_cipcode5 500402 "50.0402 - Graphic Design, Commercial Art and Illus.", add 
label define label_cipcode5 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode5 500605 "50.0605 - Photography", add 
label define label_cipcode5 500799 "50.0799 - Fine Arts and Art Studies, Other", add 
label define label_cipcode5 509999 "50.9999 - Visual and Performing Arts, Other", add 
label values cipcode5 label_cipcode5
label define label_cipcode6 10506 "01.0506 - Horseshoeing" 
label define label_cipcode6 10601 "01.0601 - Horticulture Svcs. Ops. and Mgmt., General", add 
label define label_cipcode6 10605 "01.0605 - Landscaping Operations and Management", add 
label define label_cipcode6 10699 "01.0699 - Horticulture Svcs. Ops. and Mgmt., Other", add 
label define label_cipcode6 30301 "03.0301 - Fishing and Fisheries Sciences and Mgmt.", add 
label define label_cipcode6 40101 "04.0101 - Arch and Enviorn Design, General", add 
label define label_cipcode6 40301 "04.0301 - City/Urban, Community and Reg. Planning", add 
label define label_cipcode6 60101 "06.0101 - Business and Management, General", add 
label define label_cipcode6 60201 "06.0201 - Accounting", add 
label define label_cipcode6 60401 "06.0401 - Business Admin and Manage, General", add 
label define label_cipcode6 60701 "06.0701 - Hotel/Motel Management", add 
label define label_cipcode6 61701 "06.1701 - Real Estate", add 
label define label_cipcode6 61801 "06.1801 - Small Business Mgt. and Ownership", add 
label define label_cipcode6 61901 "06.1901 - Taxation", add 
label define label_cipcode6 62101 "06.2101 - Computer Installation Manage", add 
label define label_cipcode6 69999 "06.9999 - Business and Management, Other", add 
label define label_cipcode6 70101 "07.0101 - Acct Bookkeep and Related Progms", add 
label define label_cipcode6 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode6 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode6 70104 "07.0104 - Mach Billing, Book, and Comput", add 
label define label_cipcode6 70199 "07.0199 - Acct, Book, and Rel Progs, Other", add 
label define label_cipcode6 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode6 70205 "07.0205 - Teller", add 
label define label_cipcode6 70299 "07.0299 - Banking and Rel Fin Progs, Other", add 
label define label_cipcode6 70301 "07.0301 - Bus Data Process and Rel Progms", add 
label define label_cipcode6 70302 "07.0302 - Bus Computer and Console Oper", add 
label define label_cipcode6 70303 "07.0303 - Bus Data Entry Equip Operat", add 
label define label_cipcode6 70401 "07.0401 - Office Supervision and Managem", add 
label define label_cipcode6 70601 "07.0601 - Secretarial and Rel Progs, General", add 
label define label_cipcode6 70602 "07.0602 - Court Reporting", add 
label define label_cipcode6 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode6 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode6 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode6 70606 "07.0606 - Secretarial", add 
label define label_cipcode6 70699 "07.0699 - Secretarial and Relat Progm Other", add 
label define label_cipcode6 70701 "07.0701 - Typing, Gen Off and Rel Progms", add 
label define label_cipcode6 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode6 70705 "07.0705 - General Office Clerk", add 
label define label_cipcode6 70707 "07.0707 - Receptionist and Comm Systs Op.", add 
label define label_cipcode6 70708 "07.0708 - Ship, Receiv and Stock Clerk", add 
label define label_cipcode6 70799 "07.0799 - Typing Gen Off and Rel Prog Other", add 
label define label_cipcode6 70801 "07.0801 - Word Processing", add 
label define label_cipcode6 79999 "07.9999 - Business (Admin Supp) Other", add 
label define label_cipcode6 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode6 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode6 80701 "08.0701 - Auctioneering", add 
label define label_cipcode6 81101 "08.1101 - Transp and Travel Market, General", add 
label define label_cipcode6 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode6 81105 "08.1105 - Travel Services Marketing Operations", add 
label define label_cipcode6 90601 "09.0601 - Radio/Tv News Broadcasting", add 
label define label_cipcode6 100199 "10.0199 - Communications Technol./Technicians, Other", add 
label define label_cipcode6 110101 "11.0101 - Computer and Information Sciences, General", add 
label define label_cipcode6 110201 "11.0201 - Computer Programming", add 
label define label_cipcode6 110301 "11.0301 - Data Processing Tech./Technician", add 
label define label_cipcode6 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode6 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode6 119999 "11.9999 - Computer and Information Sciences, Other", add 
label define label_cipcode6 120203 "12.0203 - Card Dealer", add 
label define label_cipcode6 120299 "12.0299 - Gaming and Sports Officiating Services, Other", add 
label define label_cipcode6 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode6 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode6 120405 "12.0405 - Massage", add 
label define label_cipcode6 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode6 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode6 129999 "12.9999 - Personal and Miscellaneous Services, Other", add 
label define label_cipcode6 130101 "13.0101 - Education, General", add 
label define label_cipcode6 131401 "13.1401 - Teaching Esl/Foreign Language", add 
label define label_cipcode6 150202 "15.0202 - Drafting and Design Technology", add 
label define label_cipcode6 150303 "15.0303 - Elec., Electronic and Comm. Engin. Tech.", add 
label define label_cipcode6 150399 "15.0399 - Electrical and Electronic Engin.-Rel. Tech.", add 
label define label_cipcode6 150402 "15.0402 - Computer Main. Tech./Technician", add 
label define label_cipcode6 150403 "15.0403 - Electromechanical Tech./Technician", add 
label define label_cipcode6 150610 "15.0610 - Welding Technology", add 
label define label_cipcode6 150799 "15.0799 - Quality Control and Safety Technol./Tech.", add 
label define label_cipcode6 160901 "16.0901 - French Language and Literature", add 
label define label_cipcode6 169999 "16.9999 - Foreign Languages and Literatures, Other", add 
label define label_cipcode6 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode6 170103 "17.0103 - Dental Laboratory Technology", add 
label define label_cipcode6 170199 "17.0199 - Dental Services, Other", add 
label define label_cipcode6 170203 "17.0203 - Electrocardiograph Techn.", add 
label define label_cipcode6 170205 "17.0205 - Emergency Med Tech-Ambulance", add 
label define label_cipcode6 170209 "17.0209 - Radiologic (Medical) Tech.", add 
label define label_cipcode6 170307 "17.0307 - Hematology Technology", add 
label define label_cipcode6 170399 "17.0399 - Medical Lab Technologies, Other", add 
label define label_cipcode6 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode6 170499 "17.0499 - Ment Health/Human Serv, Other", add 
label define label_cipcode6 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode6 170505 "17.0505 - Medical Office Management", add 
label define label_cipcode6 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode6 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode6 170599 "17.0599 - Misc Allied Health Serv, Other", add 
label define label_cipcode6 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode6 170699 "17.0699 - Nursing-Related Servs, Other", add 
label define label_cipcode6 170705 "17.0705 - Optometric Technology", add 
label define label_cipcode6 179999 "17.9999 - Allied Health, Other", add 
label define label_cipcode6 180703 "18.0703 - Medical Records Admin", add 
label define label_cipcode6 181018 "18.1018 - Pathology", add 
label define label_cipcode6 181023 "18.1023 - Psychiatry", add 
label define label_cipcode6 182299 "18.2299 - Public Health, Other", add 
label define label_cipcode6 200202 "20.0202 - Child Care Provider/Assistant", add 
label define label_cipcode6 200299 "20.0299 - Child Care/Guidance Workers and Managers, Other", add 
label define label_cipcode6 200304 "20.0304 - Custom Apparel/Garment Seam", add 
label define label_cipcode6 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode6 200403 "20.0403 - Chef/Cook", add 
label define label_cipcode6 200406 "20.0406 - Food Service", add 
label define label_cipcode6 200505 "20.0505 - Home Decorating", add 
label define label_cipcode6 210103 "21.0103 - Drafting and Design (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode6 210104 "21.0104 - Electricity/Electronics (1985 code replaced in 1990 with 21.0101)", add 
label define label_cipcode6 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode6 239999 "23.9999 - English Language and Literature/Letters,", add 
label define label_cipcode6 260610 "26.0610 - Parasitology", add 
label define label_cipcode6 299999 "29.9999 - Military Technologies, Other (1985 code replaced in 1990 with 29.0101)", add 
label define label_cipcode6 320101 "32.0101 - Basic Skills, General", add 
label define label_cipcode6 360102 "36.0102 - Handicrafts and Model-Making", add 
label define label_cipcode6 360109 "36.0109 - Travel and Exploration", add 
label define label_cipcode6 370101 "37.0101 - Self-Awareness and Personal Assessment", add 
label define label_cipcode6 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode6 390401 "39.0401 - Religious Education", add 
label define label_cipcode6 430109 "43.0109 - Security and Loss Prevention Services", add 
label define label_cipcode6 460302 "46.0302 - Electrician", add 
label define label_cipcode6 460401 "46.0401 - Building/Property Main. and Manager", add 
label define label_cipcode6 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode6 470101 "47.0101 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode6 470102 "47.0102 - Business Machine Repairer", add 
label define label_cipcode6 470104 "47.0104 - Computer Installer and Repairer", add 
label define label_cipcode6 470199 "47.0199 - Electrical and Electronics Equipment Ins", add 
label define label_cipcode6 470201 "47.0201 - Heating, Air Conditioning and Refrigerat", add 
label define label_cipcode6 470401 "47.0401 - Instrument Calibration and Repairer", add 
label define label_cipcode6 470403 "47.0403 - Locksmith and Safe Repairer", add 
label define label_cipcode6 470606 "47.0606 - Small Engine Mechanic and Repairer", add 
label define label_cipcode6 470607 "47.0607 - Aircraft Mechanic/Technician, Airframe", add 
label define label_cipcode6 470699 "47.0699 - Vehicle and Mobile Equip. Mechanics and Rep.", add 
label define label_cipcode6 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode6 480201 "48.0201 - Graphic and Printing Equip. Operator, General", add 
label define label_cipcode6 480299 "48.0299 - Graphic and Printing Equip. Operator, Other", add 
label define label_cipcode6 480501 "48.0501 - Machinist/Machine Technologist", add 
label define label_cipcode6 480508 "48.0508 - Welder/Welding Technologist", add 
label define label_cipcode6 490101 "49.0101 - Aviation and Airway Science", add 
label define label_cipcode6 490102 "49.0102 - Aircraft Pilot and Navigator (Professional)", add 
label define label_cipcode6 490105 "49.0105 - Air Traffic Controller", add 
label define label_cipcode6 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode6 490199 "49.0199 - Air Transportation Workers, Other", add 
label define label_cipcode6 490205 "49.0205 - Truck, Bus and Oth. Commercial Vehicle Op.", add 
label define label_cipcode6 490301 "49.0301 - Water Transportation, Gen", add 
label define label_cipcode6 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode6 490399 "49.0399 - Water Transportation Workers, Other", add 
label define label_cipcode6 500301 "50.0301 - Dance", add 
label define label_cipcode6 500401 "50.0401 - Design and Visual Communications", add 
label define label_cipcode6 500501 "50.0501 - Drama/Theater Arts, General", add 
label define label_cipcode6 500605 "50.0605 - Photography", add 
label define label_cipcode6 509999 "50.9999 - Visual and Performing Arts, Other", add 
label values cipcode6 label_cipcode6
tab ftstu
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
tab tuition8
tab profna
tab room
tab roomamt
tab board
tab roombord
tab pg600
tab ciptuit1
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
summarize roomcap
summarize boardamt
summarize mealswk
summarize avgamt1
summarize avgamt2
summarize avgamt3
summarize avgamt4
summarize prgmoffr
summarize ciplgth1
summarize cipenrl1
summarize ciptuit2
summarize ciplgth2
summarize cipenrl2
summarize ciptuit3
summarize ciplgth3
summarize cipenrl3
summarize ciptuit4
summarize ciplgth4
summarize cipenrl4
summarize ciptuit5
summarize ciplgth5
summarize cipenrl5
summarize ciptuit6
summarize ciplgth6
summarize cipenrl6
save dct_ic1991_d

