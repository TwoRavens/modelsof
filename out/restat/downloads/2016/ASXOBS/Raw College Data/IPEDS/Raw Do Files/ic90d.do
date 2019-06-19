* Created: 6/13/2004 7:05:13 AM
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
insheet using "../Raw Data/ic90d_data_stata.csv", comma clear
label data "dct_ic90d"
label variable unitid "unitid"
label variable ftstu "Full-time students are enrolled"
label variable apfee "Application fee is required"
label variable applfeeu "Undergraduate application fee"
label variable applfeeg "Graduate application fee"
label variable tfdu "Different tuition and fees charges for different ugrad levels"
label variable tfdi "Different tuition and fees charges for different ugrad instrutional programs"
label variable ffind "Tuition charges to full-time ugrad is flat fee"
label variable ffamt "Flat fee amount"
label variable ffper "Basis for flat fee charges"
label variable ffmin "Minimum hours covered by flat fees"
label variable ffmax "Maximum hours covered by flat fees"
label variable phind "Per hour amount is charged"
label variable phamt "Per hour  charge in whole dollars"
label variable phper "Basis for per hour charge"
label variable noftug "No full-time undergraduate students enrolled"
label variable chgper "Basis for charging full-time students"
label variable tuition1 "Tuition and fees, full-time undergraduate, in-district"
label variable tuition2 "Tuition and fees, full-time undergraduate, in-state"
label variable tuition3 "Tuition and fees, full-time undergraduate, out-of-state"
label variable tuition4 "No full-time undergraduate students"
label variable tuition5 "Tuition and fees, full-time graduate, in-district"
label variable tuition6 "Tuition and fees, full-time graduate, in-state"
label variable tuition7 "Tuition and fees, full-time graduate, out-of-state"
label variable tuition8 "No full-time graduate students"
label variable prof1 "Tuition and fees full-time  Chiropractic"
label variable prof2 "Tuition and fees full-time  Dentistry"
label variable prof3 "Tuition and fees full-time  Medicine"
label variable prof4 "Tuition and fees full-time  Optometry"
label variable prof5 "Tuition and fees full-time  Osteopathic Medicine"
label variable prof6 "Tuition and fees full-time  Pharmacy"
label variable prof7 "Tuition and fees full-time  Podiatry"
label variable prof8 "Tuition and fees full-time  Veterinary Medicine"
label variable prof9 "Tuition and fees full-time  Law"
label variable prof10 "Tuition and fees full-time  Theology"
label variable prof11 "Tuition and  fees full-time  Other first-professional"
label variable profoth "Name of other First-professonal program"
label variable profna "No full-time first-professional students"
label variable room "Institution provides dormitory facilities"
label variable roomamt "Typical room charge for academic year"
label variable roomcap "Total dormitory capacity during academic year"
label variable board "Institution provides board or meal plans"
label variable boardamt "Typical board charge for academic year"
label variable mealswk "Number of meals per week in board charge"
label variable roombord "Combined charge for room and board"
label variable avgamt1 "Expenses, books and supplies"
label variable avgamt2 "Expenses, Transportation"
label variable avgamt3 "Expenses, Room and board (for-non-dormitory students)"
label variable avgamt4 "Miscellaneous expenses"
label variable prgmoffr "Number of programs offered"
label variable pg600 "Any programs greater than 600 contact hours"
label variable cipcode1 "1st CIP code"
label variable ciptuit1 "1st Tuition and fees"
label variable ciplgth1 "1st Total length of program in contact hours"
label variable cipenrl1 "1st Current or most recent enrollment"
label variable cipcode2 "2nd CIP code"
label variable ciptuit2 "2nd Tuition and fees (in-State charges)"
label variable ciplgth2 "2nd Total length of program in contact hours"
label variable cipenrl2 "2nd Current or most recent enrollment"
label variable cipcode3 "3rd CIP code"
label variable ciptuit3 "3rd Tuition and fees (in-State charges)"
label variable ciplgth3 "3rd Total length of program in contact hours"
label variable cipenrl3 "3rd Current or most recent enrollment"
label variable cipcode4 "4th CIP code"
label variable ciptuit4 "4th Tuition and fees (in-State charges)"
label variable ciplgth4 "4th Total length of program in contact hours"
label variable cipenrl4 "4th Current or most recent enrollment"
label variable cipcode5 "5th CIP code"
label variable ciptuit5 "5th Tuition and fees (in-State charges)"
label variable ciplgth5 "5th Total length of program in contact hours"
label variable cipenrl5 "5th Current or most recent enrollment"
label variable cipcode6 "6th CIP code"
label variable ciptuit6 "6th Tuition and fees (in-State charges)"
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
label define label_ffper 1 "Per semester hour" 
label define label_ffper 2 "Per quarter hour", add 
label define label_ffper 3 "Per program", add 
label define label_ffper 4 "Per year", add 
label define label_ffper 5 "Per trimester", add 
label define label_ffper 6 "Other", add 
label values ffper label_ffper
label define label_phper 1 "Per semester hour" 
label define label_phper 2 "Per quarter hour", add 
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
label define label_pg600 1 "Yes" 
label define label_pg600 2 "No", add 
label values pg600 label_pg600
label define label_cipcode1 10203 "01.0203 - Agricultural Mechanics, Construction," 
label define label_cipcode1 10301 "01.0301 - Agricultural Prod., General", add 
label define label_cipcode1 10502 "01.0502 - Agricultural Serv.", add 
label define label_cipcode1 10504 "01.0504 - Pet Grooming", add 
label define label_cipcode1 10505 "01.0505 - Animal Training", add 
label define label_cipcode1 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode1 10507 "01.0507 - Horse Handling and Care", add 
label define label_cipcode1 10599 "01.0599 - Agricultural Serv. and Supplies, Oth.", add 
label define label_cipcode1 10602 "01.0602 - Arboriculture", add 
label define label_cipcode1 10603 "01.0603 - Ornamental Horticulture", add 
label define label_cipcode1 10605 "01.0605 - Landscaping", add 
label define label_cipcode1 10699 "01.0699 - Horticulture, Oth.", add 
label define label_cipcode1 20202 "02.0202 - Animal Breeding and Genetics", add 
label define label_cipcode1 20299 "02.0299 - Animal Sciences, Oth.", add 
label define label_cipcode1 30401 "03.0401 - Forestry Prod. and Processing, Gen.", add 
label define label_cipcode1 40301 "04.0301 - City, Community, and Regional Planning", add 
label define label_cipcode1 40501 "04.0501 - Interior Design", add 
label define label_cipcode1 50299 "05.0299 - Ethnic Studies, Other", add 
label define label_cipcode1 60101 "06.0101 - Business and Mgmt., Gen.", add 
label define label_cipcode1 60201 "06.0201 - Accounting", add 
label define label_cipcode1 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode1 60401 "06.0401 - Business Admin. and Mgmt., Gen.", add 
label define label_cipcode1 60499 "06.0499 - Business Admin. and Mgmt., Oth.", add 
label define label_cipcode1 60701 "06.0701 - Hotel/Motel Mgmt.", add 
label define label_cipcode1 60704 "06.0704 - Restaurant Mgmt.", add 
label define label_cipcode1 60705 "06.0705 - Transportation Mgmt.", add 
label define label_cipcode1 60801 "06.0801 - Insurance and Risk Mgmt.", add 
label define label_cipcode1 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode1 61401 "06.1401 - Marketing Mgmt.", add 
label define label_cipcode1 61601 "06.1601 - Personnel Mgmt.", add 
label define label_cipcode1 61701 "06.1701 - Real Estate", add 
label define label_cipcode1 61801 "06.1801 - Small Business Mgmt. and Ownership", add 
label define label_cipcode1 69999 "06.9999 - Business and Mgmt., Oth.", add 
label define label_cipcode1 70101 "07.0101 - Accounting, Bookkeeping, and Related Pro", add 
label define label_cipcode1 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode1 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode1 70104 "07.0104 - Machine Billing, Bookkeeping, and Comput", add 
label define label_cipcode1 70199 "07.0199 - Accounting, Bookkeeping, and Related Pro", add 
label define label_cipcode1 70201 "07.0201 - Banking and Related Financial Programs,", add 
label define label_cipcode1 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode1 70205 "07.0205 - Teller", add 
label define label_cipcode1 70299 "07.0299 - Banking and Related Financial Programs,", add 
label define label_cipcode1 70301 "07.0301 - Business Data Processing and Related Pro", add 
label define label_cipcode1 70302 "07.0302 - Business Computer and Console Operation", add 
label define label_cipcode1 70303 "07.0303 - Business Data Entry Equip. Operation", add 
label define label_cipcode1 70305 "07.0305 - Business Data Programming", add 
label define label_cipcode1 70399 "07.0399 - Business Data Processing and Related Pro", add 
label define label_cipcode1 70401 "07.0401 - Office Supervision and Mgmt.", add 
label define label_cipcode1 70501 "07.0501 - Personnel and Training Programs, Gen.", add 
label define label_cipcode1 70599 "07.0599 - Personnel and Training Programs, Oth.", add 
label define label_cipcode1 70601 "07.0601 - Secretarial and Related Programs, Gen.", add 
label define label_cipcode1 70602 "07.0602 - Court Reporting", add 
label define label_cipcode1 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode1 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode1 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode1 70606 "07.0606 - Secretarial", add 
label define label_cipcode1 70607 "07.0607 - Stenographic", add 
label define label_cipcode1 70699 "07.0699 - Secretarial and Related Programs, Oth.", add 
label define label_cipcode1 70701 "07.0701 - Typing, Gen. Office, and Related Program", add 
label define label_cipcode1 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode1 70705 "07.0705 - Gen. Office Clerk", add 
label define label_cipcode1 70707 "07.0707 - Receptionist and Communication Systems", add 
label define label_cipcode1 70708 "07.0708 - Shipping, Receiving, and Stock Clerk", add 
label define label_cipcode1 70709 "07.0709 - Traffic, Rate, and Transportation Clerk", add 
label define label_cipcode1 70799 "07.0799 - Typing, Gen. Office, and Related Program", add 
label define label_cipcode1 70801 "07.0801 - Word Processing", add 
label define label_cipcode1 79999 "07.9999 - Business (Administrative Support), Oth.", add 
label define label_cipcode1 80101 "08.0101 - Apparel and Accessories Marketing, Gen.", add 
label define label_cipcode1 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode1 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode1 80199 "08.0199 - Apparel and Accessories Marketing, Oth.", add 
label define label_cipcode1 80301 "08.0301 - Entrepreneurship", add 
label define label_cipcode1 80401 "08.0401 - Financial Serv. Marketing", add 
label define label_cipcode1 80501 "08.0501 - Floristry, Farm and Garden Supplies Mark", add 
label define label_cipcode1 80503 "08.0503 - Floristry", add 
label define label_cipcode1 80602 "08.0602 - Convenience Store Marketing", add 
label define label_cipcode1 80701 "08.0701 - Auctioneering", add 
label define label_cipcode1 80705 "08.0705 - Retailing", add 
label define label_cipcode1 80706 "08.0706 - Sales", add 
label define label_cipcode1 80901 "08.0901 - Hospitality and Recreation Marketing, Ot", add 
label define label_cipcode1 80904 "08.0904 - Recreational Products Marketing", add 
label define label_cipcode1 81001 "08.1001 - Insurance Marketing", add 
label define label_cipcode1 81101 "08.1101 - Transportation and Travel Marketing, Gen", add 
label define label_cipcode1 81102 "08.1102 - Transportation Marketing", add 
label define label_cipcode1 81104 "08.1104 - Tourism", add 
label define label_cipcode1 81105 "08.1105 - Travel Serv. Marketing", add 
label define label_cipcode1 81199 "08.1199 - Transportation and Travel Marketing, Oth", add 
label define label_cipcode1 81201 "08.1201 - Vehicles and Petroleum Marketing, Gen.", add 
label define label_cipcode1 90101 "09.0101 - Communications, Gen.", add 
label define label_cipcode1 90201 "09.0201 - Advertising", add 
label define label_cipcode1 90601 "09.0601 - Radio/Television News Broadcasting", add 
label define label_cipcode1 90701 "09.0701 - Radio/Television, Gen.", add 
label define label_cipcode1 90801 "09.0801 - Telecommunications", add 
label define label_cipcode1 99999 "09.9999 - Communications, Oth.", add 
label define label_cipcode1 100103 "10.0103 - Photographic Tech.", add 
label define label_cipcode1 100104 "10.0104 - Radio and Television Prod. and Broadcast", add 
label define label_cipcode1 100105 "10.0105 - Sound Recording Tech.", add 
label define label_cipcode1 100106 "10.0106 - Video Tech.", add 
label define label_cipcode1 100199 "10.0199 - Communications Technologies, Oth.", add 
label define label_cipcode1 110101 "11.0101 - Computer and Information Sciences, Gen.", add 
label define label_cipcode1 110201 "11.0201 - Computer Programming", add 
label define label_cipcode1 110301 "11.0301 - Data Processing", add 
label define label_cipcode1 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode1 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode1 119999 "11.9999 - Computer and Information Sciences, Oth.", add 
label define label_cipcode1 120101 "12.0101 - Drycleaning and Laundering Serv.", add 
label define label_cipcode1 120202 "12.0202 - Bartending", add 
label define label_cipcode1 120203 "12.0203 - Card Dealing", add 
label define label_cipcode1 120204 "12.0204 - Umpiring", add 
label define label_cipcode1 120299 "12.0299 - Entertainment Serv., Oth.", add 
label define label_cipcode1 120301 "12.0301 - Funeral Serv.", add 
label define label_cipcode1 120401 "12.0401 - Personal Serv., Gen.", add 
label define label_cipcode1 120402 "12.0402 - Barbering/Hairstyling", add 
label define label_cipcode1 120403 "12.0403 - Cosmetology", add 
label define label_cipcode1 120404 "12.0404 - Electrolysis", add 
label define label_cipcode1 120405 "12.0405 - Massage", add 
label define label_cipcode1 120406 "12.0406 - Make-up Artistry", add 
label define label_cipcode1 120499 "12.0499 - Personal Serv., Oth.", add 
label define label_cipcode1 129999 "12.9999 - Consumer, Personal and Misc. Serv., Oth.", add 
label define label_cipcode1 130101 "13.0101 - Education, Gen.", add 
label define label_cipcode1 130201 "13.0201 - Bilingual/Crosscultural Education", add 
label define label_cipcode1 130501 "13.0501 - Educational Media", add 
label define label_cipcode1 131204 "13.1204 - Pre-Elementary Education", add 
label define label_cipcode1 131205 "13.1205 - Secondary Education", add 
label define label_cipcode1 131299 "13.1299 - Teacher Education, Gen. Programs, Oth.", add 
label define label_cipcode1 131305 "13.1305 - English Education", add 
label define label_cipcode1 131321 "13.1321 - Computer Education", add 
label define label_cipcode1 131399 "13.1399 - Teacher Education, Specific Subject Area", add 
label define label_cipcode1 131401 "13.1401 - Teaching English as a Second Language/Fo", add 
label define label_cipcode1 139999 "13.9999 - Education, Oth.", add 
label define label_cipcode1 140101 "14.0101 - Engineering, Gen.", add 
label define label_cipcode1 140801 "14.0801 - Civil Engineering", add 
label define label_cipcode1 141001 "14.1001 - Electrical, Electronics, and Communicati", add 
label define label_cipcode1 149999 "14.9999 - Engineering, Oth.", add 
label define label_cipcode1 150101 "15.0101 - Architectural Design and Construction Te", add 
label define label_cipcode1 150202 "15.0202 - Drafting and Design Tech.", add 
label define label_cipcode1 150301 "15.0301 - Computer Tech.", add 
label define label_cipcode1 150302 "15.0302 - Electrical Tech.", add 
label define label_cipcode1 150303 "15.0303 - Electronic Tech.", add 
label define label_cipcode1 150399 "15.0399 - Electrical and Electronic Technologies,", add 
label define label_cipcode1 150401 "15.0401 - Biomedical Equip. Tech.", add 
label define label_cipcode1 150402 "15.0402 - Computer Servicing Tech.", add 
label define label_cipcode1 150499 "15.0499 - Electromechanical Instrumentation and Ma", add 
label define label_cipcode1 150501 "15.0501 - Air Conditioning, Heating, and Refrigera", add 
label define label_cipcode1 150502 "15.0502 - Air Pollution Control Tech.", add 
label define label_cipcode1 150599 "15.0599 - Environmental Control Technologies, Oth.", add 
label define label_cipcode1 150610 "15.0610 - Welding Tech.", add 
label define label_cipcode1 150699 "15.0699 - Industrial Prod. Technologies, Oth.", add 
label define label_cipcode1 150702 "15.0702 - Quality Control Tech.", add 
label define label_cipcode1 150801 "15.0801 - Aeronautical Tech.", add 
label define label_cipcode1 150803 "15.0803 - Automotive Tech.", add 
label define label_cipcode1 150903 "15.0903 - Petroleum Tech.", add 
label define label_cipcode1 151001 "15.1001 - Construction Tech., Oth.", add 
label define label_cipcode1 159999 "15.9999 - Engineering and Engineering-Related Tech", add 
label define label_cipcode1 160905 "16.0905 - Spanish", add 
label define label_cipcode1 161199 "16.1199 - Semitic Languages, Oth.", add 
label define label_cipcode1 170103 "17.0103 - Dental Laboratory Tech.", add 
label define label_cipcode1 170199 "17.0199 - Dental Serv., Oth.", add 
label define label_cipcode1 170202 "17.0202 - Dialysis Tech.", add 
label define label_cipcode1 170203 "17.0203 - Electrocardiograph Tech.", add 
label define label_cipcode1 170205 "17.0205 - Emergency Medical Tech.-Ambulance", add 
label define label_cipcode1 170206 "17.0206 - Emergency Medical Tech.-Paramedic", add 
label define label_cipcode1 170208 "17.0208 - Nuclear Medical Tech.", add 
label define label_cipcode1 170209 "17.0209 - Radiologic (Medical) Tech.", add 
label define label_cipcode1 170210 "17.0210 - Respiratory Therapy Tech.", add 
label define label_cipcode1 170211 "17.0211 - Surgical Tech.", add 
label define label_cipcode1 170212 "17.0212 - Diagnostic Medical Sonography", add 
label define label_cipcode1 170299 "17.0299 - Diagnostic and Treatment Serv., Oth.", add 
label define label_cipcode1 170301 "17.0301 - Blood Bank Tech.", add 
label define label_cipcode1 170303 "17.0303 - Clinical Animal Tech.", add 
label define label_cipcode1 170306 "17.0306 - CytoTech.", add 
label define label_cipcode1 170307 "17.0307 - Hematology Tech.", add 
label define label_cipcode1 170308 "17.0308 - Histologic Tech.", add 
label define label_cipcode1 170309 "17.0309 - Medical Laboratory Tech.", add 
label define label_cipcode1 170310 "17.0310 - Medical Tech.", add 
label define label_cipcode1 170311 "17.0311 - Microbiology Tech.", add 
label define label_cipcode1 170399 "17.0399 - Medical Laboratory Technologies, Oth.", add 
label define label_cipcode1 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode1 170405 "17.0405 - Mental Health/Human Serv. Assisting", add 
label define label_cipcode1 170499 "17.0499 - Mental Health/Human Serv., Oth.", add 
label define label_cipcode1 170502 "17.0502 - Central Supply Tech.", add 
label define label_cipcode1 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode1 170504 "17.0504 - Medical Illustrating", add 
label define label_cipcode1 170505 "17.0505 - Medical Office Mgmt.", add 
label define label_cipcode1 170506 "17.0506 - Medical Records Tech.", add 
label define label_cipcode1 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode1 170508 "17.0508 - Physician Assisting", add 
label define label_cipcode1 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode1 170599 "17.0599 - Misc. Allied Health Serv., Oth.", add 
label define label_cipcode1 170601 "17.0601 - Geriatric Aide", add 
label define label_cipcode1 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode1 170605 "17.0605 - Practical Nursing", add 
label define label_cipcode1 170606 "17.0606 - Health Unit Mgmt.", add 
label define label_cipcode1 170699 "17.0699 - Nursing-Related Serv., Oth.", add 
label define label_cipcode1 170811 "17.0811 - Orthotics/Prosthetics", add 
label define label_cipcode1 170812 "17.0812 - Orthopedic Assisting", add 
label define label_cipcode1 170818 "17.0818 - Respiratory Therapy", add 
label define label_cipcode1 170819 "17.0819 - Respiratory Therapy Assisting", add 
label define label_cipcode1 170899 "17.0899 - Rehabilitation Serv., Oth.", add 
label define label_cipcode1 179999 "17.9999 - Allied Health, Oth.", add 
label define label_cipcode1 180205 "18.0205 - Clinical Physiology", add 
label define label_cipcode1 180406 "18.0406 - Orthodontics", add 
label define label_cipcode1 180499 "18.0499 - Dentistry, Oth.", add 
label define label_cipcode1 180702 "18.0702 - Health Care Planning", add 
label define label_cipcode1 180799 "18.0799 - Health Serv. Admin., Oth.", add 
label define label_cipcode1 180901 "18.0901 - Medical Laboratory", add 
label define label_cipcode1 181001 "18.1001 - Medicine, Gen.", add 
label define label_cipcode1 181013 "18.1013 - Obstetrics and Gynecology", add 
label define label_cipcode1 181026 "18.1026 - Surgery", add 
label define label_cipcode1 181030 "18.1030 - Sports Medicine", add 
label define label_cipcode1 181101 "18.1101 - Nursing, Gen.", add 
label define label_cipcode1 181106 "18.1106 - Psychiatric/Mental Health", add 
label define label_cipcode1 181107 "18.1107 - Public Health (Nursing)", add 
label define label_cipcode1 181199 "18.1199 - Nursing, Oth.", add 
label define label_cipcode1 181201 "18.1201 - Optometry", add 
label define label_cipcode1 181401 "18.1401 - Pharmacy", add 
label define label_cipcode1 182001 "18.2001 - Pre-Veterinary", add 
label define label_cipcode1 182299 "18.2299 - Public Health, Oth.", add 
label define label_cipcode1 189999 "18.9999 - Health Sciences, Oth.", add 
label define label_cipcode1 190201 "19.0201 - Business Home Economics", add 
label define label_cipcode1 190501 "19.0501 - Food Sciences and Human Nutrition, Gen.", add 
label define label_cipcode1 190601 "19.0601 - Human Environment and Housing, Gen.", add 
label define label_cipcode1 190902 "19.0902 - Fashion Design", add 
label define label_cipcode1 200102 "20.0102 - Child Development, Care, and Guidance", add 
label define label_cipcode1 200103 "20.0103 - Clothing and Textiles", add 
label define label_cipcode1 200108 "20.0108 - Food and Nutrition", add 
label define label_cipcode1 200201 "20.0201 - Child Care and Guidance Mgmt. and Serv.,", add 
label define label_cipcode1 200202 "20.0202 - Child Care Aide/Assisting", add 
label define label_cipcode1 200203 "20.0203 - Child Care Mgmt.", add 
label define label_cipcode1 200204 "20.0204 - Foster Care/Family Care", add 
label define label_cipcode1 200299 "20.0299 - Child Care and Guidance Mgmt. and Serv.,", add 
label define label_cipcode1 200303 "20.0303 - Commercial Garment and Apparel Construct", add 
label define label_cipcode1 200304 "20.0304 - Custom Apparel/Garment Seamstress", add 
label define label_cipcode1 200305 "20.0305 - Custom Tailoring and Alteration", add 
label define label_cipcode1 200399 "20.0399 - Clothing, Apparel, and Textiles Mgmt.,", add 
label define label_cipcode1 200401 "20.0401 - Food Prod., Mgmt., and Serv., Gen.", add 
label define label_cipcode1 200402 "20.0402 - Baking", add 
label define label_cipcode1 200403 "20.0403 - Chef/Cook", add 
label define label_cipcode1 200406 "20.0406 - Food Service", add 
label define label_cipcode1 200499 "20.0499 - Food Prod., Mgmt., and Serv., Oth.", add 
label define label_cipcode1 200501 "20.0501 - Home Furnishings and Equip. Mgmt., Prod.", add 
label define label_cipcode1 200503 "20.0503 - Custom Slipcovering and Upholstering", add 
label define label_cipcode1 200504 "20.0504 - Floral Design", add 
label define label_cipcode1 200604 "20.0604 - Custodial Serv.", add 
label define label_cipcode1 210102 "21.0102 - Construction", add 
label define label_cipcode1 210103 "21.0103 - Drafting and Design", add 
label define label_cipcode1 210104 "21.0104 - Electricity/Electronics", add 
label define label_cipcode1 210107 "21.0107 - Manufacturing/Materials Processing", add 
label define label_cipcode1 220103 "22.0103 - Legal Assisting", add 
label define label_cipcode1 220199 "22.0199 - Law, Other", add 
label define label_cipcode1 230101 "23.0101 - English, Gen.", add 
label define label_cipcode1 230201 "23.0201 - Classics", add 
label define label_cipcode1 230501 "23.0501 - Creative Writing", add 
label define label_cipcode1 231101 "23.1101 - Technical and Business Writing", add 
label define label_cipcode1 231201 "23.1201 - English as a Second Language", add 
label define label_cipcode1 270101 "27.0101 - Math, Gen.", add 
label define label_cipcode1 299999 "29.9999 - Military Technologies, Oth.", add 
label define label_cipcode1 300901 "30.0901 - Imaging Science", add 
label define label_cipcode1 310201 "31.0201 - Outdoor Recreation", add 
label define label_cipcode1 310401 "31.0401 - Water Resources", add 
label define label_cipcode1 320101 "32.0101 - Basic Skills, Gen.", add 
label define label_cipcode1 320103 "32.0103 - Communication Skills", add 
label define label_cipcode1 320105 "32.0105 - Job Seeking/Changing Skills", add 
label define label_cipcode1 320107 "32.0107 - Career Exploration", add 
label define label_cipcode1 320199 "32.0199 - Basic Skills, Oth.", add 
label define label_cipcode1 340101 "34.0101 - Health-Related Activities, Gen.", add 
label define label_cipcode1 340103 "34.0103 - Health Enhancement Practices", add 
label define label_cipcode1 340104 "34.0104 - Health Treatment/Prevention Practices", add 
label define label_cipcode1 340199 "34.0199 - Health-Related Activities, Oth.", add 
label define label_cipcode1 350101 "35.0101 - Interpersonal Skills, Gen.", add 
label define label_cipcode1 350199 "35.0199 - Interpersonal Skills, Oth.", add 
label define label_cipcode1 360103 "36.0103 - Games", add 
label define label_cipcode1 360104 "36.0104 - Hobbies", add 
label define label_cipcode1 360107 "36.0107 - Pet Care", add 
label define label_cipcode1 360108 "36.0108 - Sports/Physical Education", add 
label define label_cipcode1 360109 "36.0109 - Travel", add 
label define label_cipcode1 360199 "36.0199 - Leisure and Recreational Activities, Oth", add 
label define label_cipcode1 370199 "37.0199 - Personal Awareness, Oth.", add 
label define label_cipcode1 380201 "38.0201 - Religion", add 
label define label_cipcode1 389999 "38.9999 - Philosophy and Religion, Oth.", add 
label define label_cipcode1 390201 "39.0201 - Bible Studies", add 
label define label_cipcode1 390301 "39.0301 - Missionary Studies", add 
label define label_cipcode1 399999 "39.9999 - Theology, Oth.", add 
label define label_cipcode1 400699 "40.0699 - Geological Sciences, Oth.", add 
label define label_cipcode1 400702 "40.0702 - Oceanography", add 
label define label_cipcode1 410202 "41.0202 - Nuclear Power Plant Operation Tech.", add 
label define label_cipcode1 410204 "41.0204 - Radiologic (Physical) Tech.", add 
label define label_cipcode1 410302 "41.0302 - Geological Tech.", add 
label define label_cipcode1 410399 "41.0399 - Physical Science Technologies, Oth.", add 
label define label_cipcode1 419999 "41.9999 - Science Technologies, Oth.", add 
label define label_cipcode1 430102 "43.0102 - Corrections", add 
label define label_cipcode1 430106 "43.0106 - Forensic Studies", add 
label define label_cipcode1 430107 "43.0107 - Law Enforcement", add 
label define label_cipcode1 430109 "43.0109 - Security Serv.", add 
label define label_cipcode1 430199 "43.0199 - Criminal Justice, Oth.", add 
label define label_cipcode1 430299 "43.0299 - Fire Protection, Oth.", add 
label define label_cipcode1 439999 "43.9999 - Protective Serv., Oth.", add 
label define label_cipcode1 440101 "44.0101 - Public Affairs, Gen.", add 
label define label_cipcode1 450601 "45.0601 - Economics", add 
label define label_cipcode1 450701 "45.0701 - Geography", add 
label define label_cipcode1 460101 "46.0101 - Brickmasonry, Stonemasonry, and Tile Set", add 
label define label_cipcode1 460201 "46.0201 - Carpentry", add 
label define label_cipcode1 460301 "46.0301 - Electrical and Power Transmission Instal", add 
label define label_cipcode1 460302 "46.0302 - Electrician", add 
label define label_cipcode1 460401 "46.0401 - Building and Property Main.", add 
label define label_cipcode1 460403 "46.0403 - Construction Inspection", add 
label define label_cipcode1 460405 "46.0405 - Floor Covering Installation", add 
label define label_cipcode1 460408 "46.0408 - Painting and Decorating", add 
label define label_cipcode1 460499 "46.0499 - Misc. Construction Trades and Property M", add 
label define label_cipcode1 460503 "46.0503 - Plumbing", add 
label define label_cipcode1 469999 "46.9999 - Construction Trades, Oth.", add 
label define label_cipcode1 470101 "47.0101 - Electrical and Electronics Equip. Repair", add 
label define label_cipcode1 470103 "47.0103 - Communication Electronics", add 
label define label_cipcode1 470104 "47.0104 - Computer Electronics", add 
label define label_cipcode1 470106 "47.0106 - Major Appliance Repair", add 
label define label_cipcode1 470109 "47.0109 - Vending and Recreational Machine Repair", add 
label define label_cipcode1 470199 "47.0199 - Electrical and Electronics Equip. Repair", add 
label define label_cipcode1 470201 "47.0201 - Heating, Air Conditioning, and Refrigera", add 
label define label_cipcode1 470202 "47.0202 - Cooling and Refrigeration", add 
label define label_cipcode1 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode1 470299 "47.0299 - Heating, Air Conditioning, and Refrigera", add 
label define label_cipcode1 470301 "47.0301 - Industrial Equip. Main. and Repair, Gen.", add 
label define label_cipcode1 470402 "47.0402 - Gunsmithing", add 
label define label_cipcode1 470403 "47.0403 - Locksmithing and Safe Repair", add 
label define label_cipcode1 470404 "47.0404 - Musical Instrument Repair", add 
label define label_cipcode1 470405 "47.0405 - Operation, Main., and Repair of Audio-Vi", add 
label define label_cipcode1 470408 "47.0408 - Watch Repair", add 
label define label_cipcode1 470499 "47.0499 - Misc. Mechanics and Repairers, Oth.", add 
label define label_cipcode1 470601 "47.0601 - Vehicle and Mobile Equip. Mechanics and", add 
label define label_cipcode1 470603 "47.0603 - Automotive Body Repair", add 
label define label_cipcode1 470604 "47.0604 - Automotive Mechanics", add 
label define label_cipcode1 470605 "47.0605 - Diesel Engine Mechanics", add 
label define label_cipcode1 470606 "47.0606 - Small Engine Repair", add 
label define label_cipcode1 470607 "47.0607 - Aircraft Mechanics, Airframe", add 
label define label_cipcode1 470608 "47.0608 - Aircraft Mechanics, Powerplant", add 
label define label_cipcode1 470699 "47.0699 - Vehicle and Mobile Equip. Mechanics and", add 
label define label_cipcode1 479999 "47.9999 - Mechanics and Repairers, Oth.", add 
label define label_cipcode1 480101 "48.0101 - Drafting, Gen.", add 
label define label_cipcode1 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode1 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode1 480199 "48.0199 - Drafting, Oth.", add 
label define label_cipcode1 480201 "48.0201 - Graphic and Printing Communications, Gen", add 
label define label_cipcode1 480203 "48.0203 - Commercial Art", add 
label define label_cipcode1 480204 "48.0204 - Commercial Photography", add 
label define label_cipcode1 480206 "48.0206 - Lithography, Photography, and Platemakin", add 
label define label_cipcode1 480208 "48.0208 - Printing Press Operations", add 
label define label_cipcode1 480299 "48.0299 - Graphic and Printing Communications, Oth", add 
label define label_cipcode1 480303 "48.0303 - Upholstering", add 
label define label_cipcode1 480402 "48.0402 - Meatcutting", add 
label define label_cipcode1 480503 "48.0503 - Machine Tool Operation/Machine Shop", add 
label define label_cipcode1 480506 "48.0506 - Sheet Metal", add 
label define label_cipcode1 480507 "48.0507 - Tool and Die Making", add 
label define label_cipcode1 480508 "48.0508 - Welding", add 
label define label_cipcode1 480599 "48.0599 - Precision Metal Work, Oth.", add 
label define label_cipcode1 480602 "48.0602 - Jewelry Design, Fabrication, and Repair", add 
label define label_cipcode1 480699 "48.0699 - Precision Work, Assorted Materials, Oth.", add 
label define label_cipcode1 480799 "48.0799 - Woodworking, Oth.", add 
label define label_cipcode1 489999 "48.9999 - Precision Prod., Oth.", add 
label define label_cipcode1 490101 "49.0101 - Air Transportation, Gen.", add 
label define label_cipcode1 490102 "49.0102 - Airplane Piloting and Navigation (Commer", add 
label define label_cipcode1 490104 "49.0104 - Aviation Mgmt.", add 
label define label_cipcode1 490105 "49.0105 - Air Traffic Control", add 
label define label_cipcode1 490106 "49.0106 - Flight Attendants", add 
label define label_cipcode1 490107 "49.0107 - Airplane Piloting (Private)", add 
label define label_cipcode1 490199 "49.0199 - Air Transportation, Oth.", add 
label define label_cipcode1 490201 "49.0201 - Vehicle and Equip. Operation, Gen.", add 
label define label_cipcode1 490202 "49.0202 - Construction Equip. Operation", add 
label define label_cipcode1 490205 "49.0205 - Truck and Bus Driving", add 
label define label_cipcode1 490299 "49.0299 - Vehicle and Equip. Operation, Oth.", add 
label define label_cipcode1 490301 "49.0301 - Water Transportation, Gen.", add 
label define label_cipcode1 490304 "49.0304 - Deep Water Diving and Life Support Syste", add 
label define label_cipcode1 490306 "49.0306 - Marine Main.", add 
label define label_cipcode1 490399 "49.0399 - Water Transportation, Oth.", add 
label define label_cipcode1 499999 "49.9999 - Transportation and Material Moving, Oth.", add 
label define label_cipcode1 500101 "50.0101 - Visual and Performing Arts, Gen.", add 
label define label_cipcode1 500201 "50.0201 - Crafts, Gen.", add 
label define label_cipcode1 500202 "50.0202 - Ceramics", add 
label define label_cipcode1 500206 "50.0206 - Metal/Jewelry", add 
label define label_cipcode1 500299 "50.0299 - Crafts, Oth.", add 
label define label_cipcode1 500301 "50.0301 - Dance", add 
label define label_cipcode1 500401 "50.0401 - Design, Gen.", add 
label define label_cipcode1 500402 "50.0402 - Graphic Design", add 
label define label_cipcode1 500403 "50.0403 - Illustration Design", add 
label define label_cipcode1 500499 "50.0499 - Design, Oth.", add 
label define label_cipcode1 500501 "50.0501 - Dramatic Arts", add 
label define label_cipcode1 500602 "50.0602 - Cinematography/Film", add 
label define label_cipcode1 500605 "50.0605 - Photography", add 
label define label_cipcode1 500699 "50.0699 - Film Arts, Oth.", add 
label define label_cipcode1 500701 "50.0701 - Fine Arts, Gen.", add 
label define label_cipcode1 500703 "50.0703 - Art History and Appreciation", add 
label define label_cipcode1 500708 "50.0708 - Painting", add 
label define label_cipcode1 500799 "50.0799 - Fine Arts, Oth.", add 
label define label_cipcode1 500901 "50.0901 - Music, Gen.", add 
label define label_cipcode1 500903 "50.0903 - Music Performance", add 
label define label_cipcode1 500999 "50.0999 - Music, Oth.", add 
label define label_cipcode1 509999 "50.9999 - Visual and Performing Arts, Oth.", add 
label values cipcode1 label_cipcode1
label define label_cipcode2 10502 "01.0502 - Agricultural Serv." 
label define label_cipcode2 10504 "01.0504 - Pet Grooming", add 
label define label_cipcode2 10505 "01.0505 - Animal Training", add 
label define label_cipcode2 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode2 10507 "01.0507 - Horse Handling and Care", add 
label define label_cipcode2 10601 "01.0601 - Horticulture, Gen.", add 
label define label_cipcode2 10602 "01.0602 - Arboriculture", add 
label define label_cipcode2 10699 "01.0699 - Horticulture, Oth.", add 
label define label_cipcode2 20299 "02.0299 - Animal Sciences, Oth.", add 
label define label_cipcode2 39999 "03.9999 - Renewable Natural Resources, Oth.", add 
label define label_cipcode2 40301 "04.0301 - City, Community, and Regional Planning", add 
label define label_cipcode2 40501 "04.0501 - Interior Design", add 
label define label_cipcode2 60101 "06.0101 - Business and Mgmt., Gen.", add 
label define label_cipcode2 60201 "06.0201 - Accounting", add 
label define label_cipcode2 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode2 60401 "06.0401 - Business Admin. and Mgmt., Gen.", add 
label define label_cipcode2 60499 "06.0499 - Business Admin. and Mgmt., Oth.", add 
label define label_cipcode2 60701 "06.0701 - Hotel/Motel Mgmt.", add 
label define label_cipcode2 60704 "06.0704 - Restaurant Mgmt.", add 
label define label_cipcode2 60799 "06.0799 - Institutional Mgmt., Oth.", add 
label define label_cipcode2 60801 "06.0801 - Insurance and Risk Mgmt.", add 
label define label_cipcode2 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode2 61401 "06.1401 - Marketing Mgmt.", add 
label define label_cipcode2 61701 "06.1701 - Real Estate", add 
label define label_cipcode2 61801 "06.1801 - Small Business Mgmt. and Ownership", add 
label define label_cipcode2 69999 "06.9999 - Business and Mgmt., Oth.", add 
label define label_cipcode2 70101 "07.0101 - Accounting, Bookkeeping, and Related Pro", add 
label define label_cipcode2 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode2 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode2 70104 "07.0104 - Machine Billing, Bookkeeping, and Comput", add 
label define label_cipcode2 70199 "07.0199 - Accounting, Bookkeeping, and Related Pro", add 
label define label_cipcode2 70201 "07.0201 - Banking and Related Financial Programs,", add 
label define label_cipcode2 70205 "07.0205 - Teller", add 
label define label_cipcode2 70299 "07.0299 - Banking and Related Financial Programs,", add 
label define label_cipcode2 70301 "07.0301 - Business Data Processing and Related Pro", add 
label define label_cipcode2 70302 "07.0302 - Business Computer and Console Operation", add 
label define label_cipcode2 70303 "07.0303 - Business Data Entry Equip. Operation", add 
label define label_cipcode2 70305 "07.0305 - Business Data Programming", add 
label define label_cipcode2 70399 "07.0399 - Business Data Processing and Related Pro", add 
label define label_cipcode2 70401 "07.0401 - Office Supervision and Mgmt.", add 
label define label_cipcode2 70601 "07.0601 - Secretarial and Related Programs, Gen.", add 
label define label_cipcode2 70602 "07.0602 - Court Reporting", add 
label define label_cipcode2 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode2 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode2 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode2 70606 "07.0606 - Secretarial", add 
label define label_cipcode2 70699 "07.0699 - Secretarial and Related Programs, Oth.", add 
label define label_cipcode2 70701 "07.0701 - Typing, Gen. Office, and Related Program", add 
label define label_cipcode2 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode2 70705 "07.0705 - Gen. Office Clerk", add 
label define label_cipcode2 70799 "07.0799 - Typing, Gen. Office, and Related Program", add 
label define label_cipcode2 70801 "07.0801 - Word Processing", add 
label define label_cipcode2 79999 "07.9999 - Business (Administrative Support), Oth.", add 
label define label_cipcode2 80101 "08.0101 - Apparel and Accessories Marketing, Gen.", add 
label define label_cipcode2 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode2 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode2 80503 "08.0503 - Floristry", add 
label define label_cipcode2 80701 "08.0701 - Auctioneering", add 
label define label_cipcode2 80705 "08.0705 - Retailing", add 
label define label_cipcode2 80706 "08.0706 - Sales", add 
label define label_cipcode2 80901 "08.0901 - Hospitality and Recreation Marketing, Ot", add 
label define label_cipcode2 80999 "08.0999 - Hospitality and Recreation Marketing, Ot", add 
label define label_cipcode2 81001 "08.1001 - Insurance Marketing", add 
label define label_cipcode2 81101 "08.1101 - Transportation and Travel Marketing, Gen", add 
label define label_cipcode2 81102 "08.1102 - Transportation Marketing", add 
label define label_cipcode2 81104 "08.1104 - Tourism", add 
label define label_cipcode2 81105 "08.1105 - Travel Serv. Marketing", add 
label define label_cipcode2 90301 "09.0301 - Communications Research", add 
label define label_cipcode2 90701 "09.0701 - Radio/Television, Gen.", add 
label define label_cipcode2 90801 "09.0801 - Telecommunications", add 
label define label_cipcode2 99999 "09.9999 - Communications, Oth.", add 
label define label_cipcode2 100103 "10.0103 - Photographic Tech.", add 
label define label_cipcode2 100104 "10.0104 - Radio and Television Prod. and Broadcast", add 
label define label_cipcode2 100105 "10.0105 - Sound Recording Tech.", add 
label define label_cipcode2 100106 "10.0106 - Video Tech.", add 
label define label_cipcode2 100199 "10.0199 - Communications Technologies, Oth.", add 
label define label_cipcode2 110101 "11.0101 - Computer and Information Sciences, Gen.", add 
label define label_cipcode2 110201 "11.0201 - Computer Programming", add 
label define label_cipcode2 110301 "11.0301 - Data Processing", add 
label define label_cipcode2 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode2 110501 "11.0501 - Systems Analysis", add 
label define label_cipcode2 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode2 119999 "11.9999 - Computer and Information Sciences, Oth.", add 
label define label_cipcode2 120101 "12.0101 - Drycleaning and Laundering Serv.", add 
label define label_cipcode2 120202 "12.0202 - Bartending", add 
label define label_cipcode2 120203 "12.0203 - Card Dealing", add 
label define label_cipcode2 120401 "12.0401 - Personal Serv., Gen.", add 
label define label_cipcode2 120402 "12.0402 - Barbering/Hairstyling", add 
label define label_cipcode2 120403 "12.0403 - Cosmetology", add 
label define label_cipcode2 120404 "12.0404 - Electrolysis", add 
label define label_cipcode2 120405 "12.0405 - Massage", add 
label define label_cipcode2 120406 "12.0406 - Make-up Artistry", add 
label define label_cipcode2 120499 "12.0499 - Personal Serv., Oth.", add 
label define label_cipcode2 129999 "12.9999 - Consumer, Personal and Misc. Serv., Oth.", add 
label define label_cipcode2 130101 "13.0101 - Education, Gen.", add 
label define label_cipcode2 131299 "13.1299 - Teacher Education, Gen. Programs, Oth.", add 
label define label_cipcode2 131399 "13.1399 - Teacher Education, Specific Subject Area", add 
label define label_cipcode2 131401 "13.1401 - Teaching English as a Second Language/Fo", add 
label define label_cipcode2 139999 "13.9999 - Education, Oth.", add 
label define label_cipcode2 140201 "14.0201 - Aerospace, Aeronautical, and Astronautic", add 
label define label_cipcode2 141001 "14.1001 - Electrical, Electronics, and Communicati", add 
label define label_cipcode2 142201 "14.2201 - Naval Architecture and Marine Engineerin", add 
label define label_cipcode2 149999 "14.9999 - Engineering, Oth.", add 
label define label_cipcode2 150101 "15.0101 - Architectural Design and Construction Te", add 
label define label_cipcode2 150202 "15.0202 - Drafting and Design Tech.", add 
label define label_cipcode2 150301 "15.0301 - Computer Tech.", add 
label define label_cipcode2 150302 "15.0302 - Electrical Tech.", add 
label define label_cipcode2 150303 "15.0303 - Electronic Tech.", add 
label define label_cipcode2 150399 "15.0399 - Electrical and Electronic Technologies,", add 
label define label_cipcode2 150402 "15.0402 - Computer Servicing Tech.", add 
label define label_cipcode2 150403 "15.0403 - Electromechanical Tech.", add 
label define label_cipcode2 150404 "15.0404 - Instrumentation Tech.", add 
label define label_cipcode2 150501 "15.0501 - Air Conditioning, Heating, and Refrigera", add 
label define label_cipcode2 150702 "15.0702 - Quality Control Tech.", add 
label define label_cipcode2 150803 "15.0803 - Automotive Tech.", add 
label define label_cipcode2 150899 "15.0899 - Mechanical and Related Technologies, Oth", add 
label define label_cipcode2 159999 "15.9999 - Engineering and Engineering-Related Tech", add 
label define label_cipcode2 169999 "16.9999 - Foreign Languages, Oth.", add 
label define label_cipcode2 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode2 170103 "17.0103 - Dental Laboratory Tech.", add 
label define label_cipcode2 170199 "17.0199 - Dental Serv., Oth.", add 
label define label_cipcode2 170201 "17.0201 - Cardiovascular Tech.", add 
label define label_cipcode2 170205 "17.0205 - Emergency Medical Tech.-Ambulance", add 
label define label_cipcode2 170208 "17.0208 - Nuclear Medical Tech.", add 
label define label_cipcode2 170209 "17.0209 - Radiologic (Medical) Tech.", add 
label define label_cipcode2 170210 "17.0210 - Respiratory Therapy Tech.", add 
label define label_cipcode2 170211 "17.0211 - Surgical Tech.", add 
label define label_cipcode2 170212 "17.0212 - Diagnostic Medical Sonography", add 
label define label_cipcode2 170306 "17.0306 - CytoTech.", add 
label define label_cipcode2 170308 "17.0308 - Histologic Tech.", add 
label define label_cipcode2 170311 "17.0311 - Microbiology Tech.", add 
label define label_cipcode2 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode2 170499 "17.0499 - Mental Health/Human Serv., Oth.", add 
label define label_cipcode2 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode2 170505 "17.0505 - Medical Office Mgmt.", add 
label define label_cipcode2 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode2 170513 "17.0513 - Health Unit Coordinating", add 
label define label_cipcode2 170599 "17.0599 - Misc. Allied Health Serv., Oth.", add 
label define label_cipcode2 170601 "17.0601 - Geriatric Aide", add 
label define label_cipcode2 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode2 170605 "17.0605 - Practical Nursing", add 
label define label_cipcode2 170699 "17.0699 - Nursing-Related Serv., Oth.", add 
label define label_cipcode2 170701 "17.0701 - Ophthalmic Dispensing", add 
label define label_cipcode2 170799 "17.0799 - Ophthalmic Serv., Oth.", add 
label define label_cipcode2 170812 "17.0812 - Orthopedic Assisting", add 
label define label_cipcode2 170814 "17.0814 - Physical Therapy Aide", add 
label define label_cipcode2 179999 "17.9999 - Allied Health, Oth.", add 
label define label_cipcode2 181025 "18.1025 - Radiology", add 
label define label_cipcode2 181199 "18.1199 - Nursing, Oth.", add 
label define label_cipcode2 181401 "18.1401 - Pharmacy", add 
label define label_cipcode2 182299 "18.2299 - Public Health, Oth.", add 
label define label_cipcode2 190902 "19.0902 - Fashion Design", add 
label define label_cipcode2 190999 "19.0999 - Textiles and Clothing, Oth.", add 
label define label_cipcode2 200103 "20.0103 - Clothing and Textiles", add 
label define label_cipcode2 200202 "20.0202 - Child Care Aide/Assisting", add 
label define label_cipcode2 200303 "20.0303 - Commercial Garment and Apparel Construct", add 
label define label_cipcode2 200304 "20.0304 - Custom Apparel/Garment Seamstress", add 
label define label_cipcode2 200305 "20.0305 - Custom Tailoring and Alteration", add 
label define label_cipcode2 200306 "20.0306 - Fashion/Fabric Coordination", add 
label define label_cipcode2 200399 "20.0399 - Clothing, Apparel, and Textiles Mgmt.,", add 
label define label_cipcode2 200401 "20.0401 - Food Prod., Mgmt., and Serv., Gen.", add 
label define label_cipcode2 200402 "20.0402 - Baking", add 
label define label_cipcode2 200403 "20.0403 - Chef/Cook", add 
label define label_cipcode2 200405 "20.0405 - Food Catering", add 
label define label_cipcode2 200406 "20.0406 - Food Service", add 
label define label_cipcode2 200499 "20.0499 - Food Prod., Mgmt., and Serv., Oth.", add 
label define label_cipcode2 200504 "20.0504 - Floral Design", add 
label define label_cipcode2 200604 "20.0604 - Custodial Serv.", add 
label define label_cipcode2 210106 "21.0106 - Graphic Arts", add 
label define label_cipcode2 210107 "21.0107 - Manufacturing/Materials Processing", add 
label define label_cipcode2 220103 "22.0103 - Legal Assisting", add 
label define label_cipcode2 220199 "22.0199 - Law, Other", add 
label define label_cipcode2 230101 "23.0101 - English, Gen.", add 
label define label_cipcode2 231201 "23.1201 - English as a Second Language", add 
label define label_cipcode2 300401 "30.0401 - Humanities and Social Sciences", add 
label define label_cipcode2 310201 "31.0201 - Outdoor Recreation", add 
label define label_cipcode2 320101 "32.0101 - Basic Skills, Gen.", add 
label define label_cipcode2 320102 "32.0102 - Academic and Intellectual Skills", add 
label define label_cipcode2 320103 "32.0103 - Communication Skills", add 
label define label_cipcode2 320199 "32.0199 - Basic Skills, Oth.", add 
label define label_cipcode2 340103 "34.0103 - Health Enhancement Practices", add 
label define label_cipcode2 340104 "34.0104 - Health Treatment/Prevention Practices", add 
label define label_cipcode2 340199 "34.0199 - Health-Related Activities, Oth.", add 
label define label_cipcode2 360107 "36.0107 - Pet Care", add 
label define label_cipcode2 360109 "36.0109 - Travel", add 
label define label_cipcode2 370199 "37.0199 - Personal Awareness, Oth.", add 
label define label_cipcode2 380101 "38.0101 - Philosophy", add 
label define label_cipcode2 390201 "39.0201 - Bible Studies", add 
label define label_cipcode2 390401 "39.0401 - Religious Education", add 
label define label_cipcode2 399999 "39.9999 - Theology, Oth.", add 
label define label_cipcode2 400699 "40.0699 - Geological Sciences, Oth.", add 
label define label_cipcode2 410299 "41.0299 - Nuclear Technologies, Oth.", add 
label define label_cipcode2 419999 "41.9999 - Science Technologies, Oth.", add 
label define label_cipcode2 430102 "43.0102 - Corrections", add 
label define label_cipcode2 430107 "43.0107 - Law Enforcement", add 
label define label_cipcode2 430109 "43.0109 - Security Serv.", add 
label define label_cipcode2 430199 "43.0199 - Criminal Justice, Oth.", add 
label define label_cipcode2 439999 "43.9999 - Protective Serv., Oth.", add 
label define label_cipcode2 450201 "45.0201 - Anthropology", add 
label define label_cipcode2 460301 "46.0301 - Electrical and Power Transmission Instal", add 
label define label_cipcode2 460302 "46.0302 - Electrician", add 
label define label_cipcode2 460401 "46.0401 - Building and Property Main.", add 
label define label_cipcode2 460405 "46.0405 - Floor Covering Installation", add 
label define label_cipcode2 460499 "46.0499 - Misc. Construction Trades and Property M", add 
label define label_cipcode2 460503 "46.0503 - Plumbing", add 
label define label_cipcode2 469999 "46.9999 - Construction Trades, Oth.", add 
label define label_cipcode2 470101 "47.0101 - Electrical and Electronics Equip. Repair", add 
label define label_cipcode2 470103 "47.0103 - Communication Electronics", add 
label define label_cipcode2 470104 "47.0104 - Computer Electronics", add 
label define label_cipcode2 470105 "47.0105 - Industrial Electronics", add 
label define label_cipcode2 470106 "47.0106 - Major Appliance Repair", add 
label define label_cipcode2 470109 "47.0109 - Vending and Recreational Machine Repair", add 
label define label_cipcode2 470199 "47.0199 - Electrical and Electronics Equip. Repair", add 
label define label_cipcode2 470201 "47.0201 - Heating, Air Conditioning, and Refrigera", add 
label define label_cipcode2 470202 "47.0202 - Cooling and Refrigeration", add 
label define label_cipcode2 470299 "47.0299 - Heating, Air Conditioning, and Refrigera", add 
label define label_cipcode2 470399 "47.0399 - Industrial Equip. Main. and Repair, Oth.", add 
label define label_cipcode2 470403 "47.0403 - Locksmithing and Safe Repair", add 
label define label_cipcode2 470499 "47.0499 - Misc. Mechanics and Repairers, Oth.", add 
label define label_cipcode2 470601 "47.0601 - Vehicle and Mobile Equip. Mechanics and", add 
label define label_cipcode2 470603 "47.0603 - Automotive Body Repair", add 
label define label_cipcode2 470604 "47.0604 - Automotive Mechanics", add 
label define label_cipcode2 470605 "47.0605 - Diesel Engine Mechanics", add 
label define label_cipcode2 470606 "47.0606 - Small Engine Repair", add 
label define label_cipcode2 470607 "47.0607 - Aircraft Mechanics, Airframe", add 
label define label_cipcode2 470608 "47.0608 - Aircraft Mechanics, Powerplant", add 
label define label_cipcode2 470699 "47.0699 - Vehicle and Mobile Equip. Mechanics and", add 
label define label_cipcode2 479999 "47.9999 - Mechanics and Repairers, Oth.", add 
label define label_cipcode2 480101 "48.0101 - Drafting, Gen.", add 
label define label_cipcode2 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode2 480199 "48.0199 - Drafting, Oth.", add 
label define label_cipcode2 480203 "48.0203 - Commercial Art", add 
label define label_cipcode2 480205 "48.0205 - Typesetting, Make-up, and Composition", add 
label define label_cipcode2 480206 "48.0206 - Lithography, Photography, and Platemakin", add 
label define label_cipcode2 480208 "48.0208 - Printing Press Operations", add 
label define label_cipcode2 480303 "48.0303 - Upholstering", add 
label define label_cipcode2 480499 "48.0499 - Precision Food Prod., Oth.", add 
label define label_cipcode2 480503 "48.0503 - Machine Tool Operation/Machine Shop", add 
label define label_cipcode2 480504 "48.0504 - Metal Fabrication", add 
label define label_cipcode2 480508 "48.0508 - Welding", add 
label define label_cipcode2 480602 "48.0602 - Jewelry Design, Fabrication, and Repair", add 
label define label_cipcode2 480604 "48.0604 - Plastics", add 
label define label_cipcode2 490101 "49.0101 - Air Transportation, Gen.", add 
label define label_cipcode2 490102 "49.0102 - Airplane Piloting and Navigation (Commer", add 
label define label_cipcode2 490104 "49.0104 - Aviation Mgmt.", add 
label define label_cipcode2 490106 "49.0106 - Flight Attendants", add 
label define label_cipcode2 490107 "49.0107 - Airplane Piloting (Private)", add 
label define label_cipcode2 490199 "49.0199 - Air Transportation, Oth.", add 
label define label_cipcode2 490202 "49.0202 - Construction Equip. Operation", add 
label define label_cipcode2 490205 "49.0205 - Truck and Bus Driving", add 
label define label_cipcode2 490299 "49.0299 - Vehicle and Equip. Operation, Oth.", add 
label define label_cipcode2 490301 "49.0301 - Water Transportation, Gen.", add 
label define label_cipcode2 490304 "49.0304 - Deep Water Diving and Life Support Syste", add 
label define label_cipcode2 490399 "49.0399 - Water Transportation, Oth.", add 
label define label_cipcode2 499999 "49.9999 - Transportation and Material Moving, Oth.", add 
label define label_cipcode2 500202 "50.0202 - Ceramics", add 
label define label_cipcode2 500299 "50.0299 - Crafts, Oth.", add 
label define label_cipcode2 500402 "50.0402 - Graphic Design", add 
label define label_cipcode2 500405 "50.0405 - Theater Design", add 
label define label_cipcode2 500501 "50.0501 - Dramatic Arts", add 
label define label_cipcode2 500602 "50.0602 - Cinematography/Film", add 
label define label_cipcode2 500605 "50.0605 - Photography", add 
label define label_cipcode2 500705 "50.0705 - Drawing", add 
label define label_cipcode2 500903 "50.0903 - Music Performance", add 
label define label_cipcode2 500999 "50.0999 - Music, Oth.", add 
label define label_cipcode2 509999 "50.9999 - Visual and Performing Arts, Oth.", add 
label values cipcode2 label_cipcode2
label define label_cipcode3 10504 "01.0504 - Pet Grooming" 
label define label_cipcode3 10506 "01.0506 - Horseshoeing", add 
label define label_cipcode3 10599 "01.0599 - Agricultural Serv. and Supplies, Oth.", add 
label define label_cipcode3 10602 "01.0602 - Arboriculture", add 
label define label_cipcode3 20299 "02.0299 - Animal Sciences, Oth.", add 
label define label_cipcode3 40301 "04.0301 - City, Community, and Regional Planning", add 
label define label_cipcode3 40501 "04.0501 - Interior Design", add 
label define label_cipcode3 49999 "04.9999 - Architecture and Environmental Design, O", add 
label define label_cipcode3 60101 "06.0101 - Business and Mgmt., Gen.", add 
label define label_cipcode3 60201 "06.0201 - Accounting", add 
label define label_cipcode3 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode3 60401 "06.0401 - Business Admin. and Mgmt., Gen.", add 
label define label_cipcode3 60499 "06.0499 - Business Admin. and Mgmt., Oth.", add 
label define label_cipcode3 60701 "06.0701 - Hotel/Motel Mgmt.", add 
label define label_cipcode3 60704 "06.0704 - Restaurant Mgmt.", add 
label define label_cipcode3 60801 "06.0801 - Insurance and Risk Mgmt.", add 
label define label_cipcode3 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode3 61399 "06.1399 - Mgmt. Science, Oth.", add 
label define label_cipcode3 61701 "06.1701 - Real Estate", add 
label define label_cipcode3 69999 "06.9999 - Business and Mgmt., Oth.", add 
label define label_cipcode3 70101 "07.0101 - Accounting, Bookkeeping, and Related Pro", add 
label define label_cipcode3 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode3 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode3 70199 "07.0199 - Accounting, Bookkeeping, and Related Pro", add 
label define label_cipcode3 70201 "07.0201 - Banking and Related Financial Programs,", add 
label define label_cipcode3 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode3 70299 "07.0299 - Banking and Related Financial Programs,", add 
label define label_cipcode3 70301 "07.0301 - Business Data Processing and Related Pro", add 
label define label_cipcode3 70302 "07.0302 - Business Computer and Console Operation", add 
label define label_cipcode3 70303 "07.0303 - Business Data Entry Equip. Operation", add 
label define label_cipcode3 70399 "07.0399 - Business Data Processing and Related Pro", add 
label define label_cipcode3 70401 "07.0401 - Office Supervision and Mgmt.", add 
label define label_cipcode3 70501 "07.0501 - Personnel and Training Programs, Gen.", add 
label define label_cipcode3 70503 "07.0503 - Personnel Assisting", add 
label define label_cipcode3 70601 "07.0601 - Secretarial and Related Programs, Gen.", add 
label define label_cipcode3 70602 "07.0602 - Court Reporting", add 
label define label_cipcode3 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode3 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode3 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode3 70606 "07.0606 - Secretarial", add 
label define label_cipcode3 70607 "07.0607 - Stenographic", add 
label define label_cipcode3 70699 "07.0699 - Secretarial and Related Programs, Oth.", add 
label define label_cipcode3 70701 "07.0701 - Typing, Gen. Office, and Related Program", add 
label define label_cipcode3 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode3 70707 "07.0707 - Receptionist and Communication Systems", add 
label define label_cipcode3 70708 "07.0708 - Shipping, Receiving, and Stock Clerk", add 
label define label_cipcode3 70799 "07.0799 - Typing, Gen. Office, and Related Program", add 
label define label_cipcode3 70801 "07.0801 - Word Processing", add 
label define label_cipcode3 79999 "07.9999 - Business (Administrative Support), Oth.", add 
label define label_cipcode3 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode3 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode3 80199 "08.0199 - Apparel and Accessories Marketing, Oth.", add 
label define label_cipcode3 80201 "08.0201 - Business and Personal Serv. Marketing,", add 
label define label_cipcode3 80503 "08.0503 - Floristry", add 
label define label_cipcode3 80705 "08.0705 - Retailing", add 
label define label_cipcode3 80706 "08.0706 - Sales", add 
label define label_cipcode3 80901 "08.0901 - Hospitality and Recreation Marketing, Ot", add 
label define label_cipcode3 80905 "08.0905 - Waiter/Waitress and Related Serv.", add 
label define label_cipcode3 81001 "08.1001 - Insurance Marketing", add 
label define label_cipcode3 81101 "08.1101 - Transportation and Travel Marketing, Gen", add 
label define label_cipcode3 81104 "08.1104 - Tourism", add 
label define label_cipcode3 81105 "08.1105 - Travel Serv. Marketing", add 
label define label_cipcode3 81203 "08.1203 - Automotive Vehicles and Accessories Mark", add 
label define label_cipcode3 89999 "08.9999 - Marketing and Distribution, Oth.", add 
label define label_cipcode3 90701 "09.0701 - Radio/Television, Gen.", add 
label define label_cipcode3 99999 "09.9999 - Communications, Oth.", add 
label define label_cipcode3 100103 "10.0103 - Photographic Tech.", add 
label define label_cipcode3 100105 "10.0105 - Sound Recording Tech.", add 
label define label_cipcode3 100199 "10.0199 - Communications Technologies, Oth.", add 
label define label_cipcode3 110101 "11.0101 - Computer and Information Sciences, Gen.", add 
label define label_cipcode3 110201 "11.0201 - Computer Programming", add 
label define label_cipcode3 110301 "11.0301 - Data Processing", add 
label define label_cipcode3 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode3 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode3 119999 "11.9999 - Computer and Information Sciences, Oth.", add 
label define label_cipcode3 120101 "12.0101 - Drycleaning and Laundering Serv.", add 
label define label_cipcode3 120202 "12.0202 - Bartending", add 
label define label_cipcode3 120203 "12.0203 - Card Dealing", add 
label define label_cipcode3 120301 "12.0301 - Funeral Serv.", add 
label define label_cipcode3 120401 "12.0401 - Personal Serv., Gen.", add 
label define label_cipcode3 120402 "12.0402 - Barbering/Hairstyling", add 
label define label_cipcode3 120403 "12.0403 - Cosmetology", add 
label define label_cipcode3 120404 "12.0404 - Electrolysis", add 
label define label_cipcode3 120405 "12.0405 - Massage", add 
label define label_cipcode3 120406 "12.0406 - Make-up Artistry", add 
label define label_cipcode3 120499 "12.0499 - Personal Serv., Oth.", add 
label define label_cipcode3 129999 "12.9999 - Consumer, Personal and Misc. Serv., Oth.", add 
label define label_cipcode3 131201 "13.1201 - Adult and Continuing Education", add 
label define label_cipcode3 131299 "13.1299 - Teacher Education, Gen. Programs, Oth.", add 
label define label_cipcode3 131399 "13.1399 - Teacher Education, Specific Subject Area", add 
label define label_cipcode3 131401 "13.1401 - Teaching English as a Second Language/Fo", add 
label define label_cipcode3 139999 "13.9999 - Education, Oth.", add 
label define label_cipcode3 149999 "14.9999 - Engineering, Oth.", add 
label define label_cipcode3 150202 "15.0202 - Drafting and Design Tech.", add 
label define label_cipcode3 150301 "15.0301 - Computer Tech.", add 
label define label_cipcode3 150302 "15.0302 - Electrical Tech.", add 
label define label_cipcode3 150303 "15.0303 - Electronic Tech.", add 
label define label_cipcode3 150399 "15.0399 - Electrical and Electronic Technologies,", add 
label define label_cipcode3 150402 "15.0402 - Computer Servicing Tech.", add 
label define label_cipcode3 150501 "15.0501 - Air Conditioning, Heating, and Refrigera", add 
label define label_cipcode3 150599 "15.0599 - Environmental Control Technologies, Oth.", add 
label define label_cipcode3 150702 "15.0702 - Quality Control Tech.", add 
label define label_cipcode3 150805 "15.0805 - Mechanical Design Tech.", add 
label define label_cipcode3 160905 "16.0905 - Spanish", add 
label define label_cipcode3 169999 "16.9999 - Foreign Languages, Oth.", add 
label define label_cipcode3 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode3 170102 "17.0102 - Dental Hygiene", add 
label define label_cipcode3 170103 "17.0103 - Dental Laboratory Tech.", add 
label define label_cipcode3 170199 "17.0199 - Dental Serv., Oth.", add 
label define label_cipcode3 170206 "17.0206 - Emergency Medical Tech.-Paramedic", add 
label define label_cipcode3 170209 "17.0209 - Radiologic (Medical) Tech.", add 
label define label_cipcode3 170211 "17.0211 - Surgical Tech.", add 
label define label_cipcode3 170212 "17.0212 - Diagnostic Medical Sonography", add 
label define label_cipcode3 170308 "17.0308 - Histologic Tech.", add 
label define label_cipcode3 170309 "17.0309 - Medical Laboratory Tech.", add 
label define label_cipcode3 170399 "17.0399 - Medical Laboratory Technologies, Oth.", add 
label define label_cipcode3 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode3 170499 "17.0499 - Mental Health/Human Serv., Oth.", add 
label define label_cipcode3 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode3 170505 "17.0505 - Medical Office Mgmt.", add 
label define label_cipcode3 170506 "17.0506 - Medical Records Tech.", add 
label define label_cipcode3 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode3 170513 "17.0513 - Health Unit Coordinating", add 
label define label_cipcode3 170514 "17.0514 - Chiropractic Assisting", add 
label define label_cipcode3 170599 "17.0599 - Misc. Allied Health Serv., Oth.", add 
label define label_cipcode3 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode3 170606 "17.0606 - Health Unit Mgmt.", add 
label define label_cipcode3 170699 "17.0699 - Nursing-Related Serv., Oth.", add 
label define label_cipcode3 170701 "17.0701 - Ophthalmic Dispensing", add 
label define label_cipcode3 170812 "17.0812 - Orthopedic Assisting", add 
label define label_cipcode3 170818 "17.0818 - Respiratory Therapy", add 
label define label_cipcode3 179999 "17.9999 - Allied Health, Oth.", add 
label define label_cipcode3 180701 "18.0701 - Health Serv. Admin.", add 
label define label_cipcode3 181101 "18.1101 - Nursing, Gen.", add 
label define label_cipcode3 181199 "18.1199 - Nursing, Oth.", add 
label define label_cipcode3 181401 "18.1401 - Pharmacy", add 
label define label_cipcode3 182299 "18.2299 - Public Health, Oth.", add 
label define label_cipcode3 190902 "19.0902 - Fashion Design", add 
label define label_cipcode3 200103 "20.0103 - Clothing and Textiles", add 
label define label_cipcode3 200199 "20.0199 - Consumer and Homemaking Education, Oth.", add 
label define label_cipcode3 200201 "20.0201 - Child Care and Guidance Mgmt. and Serv.,", add 
label define label_cipcode3 200202 "20.0202 - Child Care Aide/Assisting", add 
label define label_cipcode3 200203 "20.0203 - Child Care Mgmt.", add 
label define label_cipcode3 200305 "20.0305 - Custom Tailoring and Alteration", add 
label define label_cipcode3 200399 "20.0399 - Clothing, Apparel, and Textiles Mgmt.,", add 
label define label_cipcode3 200401 "20.0401 - Food Prod., Mgmt., and Serv., Gen.", add 
label define label_cipcode3 200402 "20.0402 - Baking", add 
label define label_cipcode3 200499 "20.0499 - Food Prod., Mgmt., and Serv., Oth.", add 
label define label_cipcode3 200504 "20.0504 - Floral Design", add 
label define label_cipcode3 200604 "20.0604 - Custodial Serv.", add 
label define label_cipcode3 209999 "20.9999 - Vocational Home Economics, Oth.", add 
label define label_cipcode3 210104 "21.0104 - Electricity/Electronics", add 
label define label_cipcode3 220101 "22.0101 - Law", add 
label define label_cipcode3 220103 "22.0103 - Legal Assisting", add 
label define label_cipcode3 230501 "23.0501 - Creative Writing", add 
label define label_cipcode3 231201 "23.1201 - English as a Second Language", add 
label define label_cipcode3 310201 "31.0201 - Outdoor Recreation", add 
label define label_cipcode3 320101 "32.0101 - Basic Skills, Gen.", add 
label define label_cipcode3 320105 "32.0105 - Job Seeking/Changing Skills", add 
label define label_cipcode3 320199 "32.0199 - Basic Skills, Oth.", add 
label define label_cipcode3 340104 "34.0104 - Health Treatment/Prevention Practices", add 
label define label_cipcode3 360107 "36.0107 - Pet Care", add 
label define label_cipcode3 360109 "36.0109 - Travel", add 
label define label_cipcode3 370104 "37.0104 - Self-Perception", add 
label define label_cipcode3 370199 "37.0199 - Personal Awareness, Oth.", add 
label define label_cipcode3 380101 "38.0101 - Philosophy", add 
label define label_cipcode3 390201 "39.0201 - Bible Studies", add 
label define label_cipcode3 399999 "39.9999 - Theology, Oth.", add 
label define label_cipcode3 400699 "40.0699 - Geological Sciences, Oth.", add 
label define label_cipcode3 410299 "41.0299 - Nuclear Technologies, Oth.", add 
label define label_cipcode3 410301 "41.0301 - Chemical Tech.", add 
label define label_cipcode3 419999 "41.9999 - Science Technologies, Oth.", add 
label define label_cipcode3 430106 "43.0106 - Forensic Studies", add 
label define label_cipcode3 430109 "43.0109 - Security Serv.", add 
label define label_cipcode3 430199 "43.0199 - Criminal Justice, Oth.", add 
label define label_cipcode3 450601 "45.0601 - Economics", add 
label define label_cipcode3 460103 "46.0103 - Tile Setting", add 
label define label_cipcode3 460201 "46.0201 - Carpentry", add 
label define label_cipcode3 460302 "46.0302 - Electrician", add 
label define label_cipcode3 460401 "46.0401 - Building and Property Main.", add 
label define label_cipcode3 460403 "46.0403 - Construction Inspection", add 
label define label_cipcode3 460405 "46.0405 - Floor Covering Installation", add 
label define label_cipcode3 460410 "46.0410 - Roofing", add 
label define label_cipcode3 460499 "46.0499 - Misc. Construction Trades and Property M", add 
label define label_cipcode3 460503 "46.0503 - Plumbing", add 
label define label_cipcode3 469999 "46.9999 - Construction Trades, Oth.", add 
label define label_cipcode3 470101 "47.0101 - Electrical and Electronics Equip. Repair", add 
label define label_cipcode3 470102 "47.0102 - Business Machine Repair", add 
label define label_cipcode3 470104 "47.0104 - Computer Electronics", add 
label define label_cipcode3 470105 "47.0105 - Industrial Electronics", add 
label define label_cipcode3 470106 "47.0106 - Major Appliance Repair", add 
label define label_cipcode3 470109 "47.0109 - Vending and Recreational Machine Repair", add 
label define label_cipcode3 470201 "47.0201 - Heating, Air Conditioning, and Refrigera", add 
label define label_cipcode3 470202 "47.0202 - Cooling and Refrigeration", add 
label define label_cipcode3 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode3 470299 "47.0299 - Heating, Air Conditioning, and Refrigera", add 
label define label_cipcode3 470301 "47.0301 - Industrial Equip. Main. and Repair, Gen.", add 
label define label_cipcode3 470303 "47.0303 - Industrial Machinery Main. and Repair", add 
label define label_cipcode3 470403 "47.0403 - Locksmithing and Safe Repair", add 
label define label_cipcode3 470499 "47.0499 - Misc. Mechanics and Repairers, Oth.", add 
label define label_cipcode3 470603 "47.0603 - Automotive Body Repair", add 
label define label_cipcode3 470604 "47.0604 - Automotive Mechanics", add 
label define label_cipcode3 470605 "47.0605 - Diesel Engine Mechanics", add 
label define label_cipcode3 470606 "47.0606 - Small Engine Repair", add 
label define label_cipcode3 470699 "47.0699 - Vehicle and Mobile Equip. Mechanics and", add 
label define label_cipcode3 479999 "47.9999 - Mechanics and Repairers, Oth.", add 
label define label_cipcode3 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode3 480199 "48.0199 - Drafting, Oth.", add 
label define label_cipcode3 480203 "48.0203 - Commercial Art", add 
label define label_cipcode3 480206 "48.0206 - Lithography, Photography, and Platemakin", add 
label define label_cipcode3 480208 "48.0208 - Printing Press Operations", add 
label define label_cipcode3 480209 "48.0209 - Silk Screen Making and Printing", add 
label define label_cipcode3 480299 "48.0299 - Graphic and Printing Communications, Oth", add 
label define label_cipcode3 480303 "48.0303 - Upholstering", add 
label define label_cipcode3 480503 "48.0503 - Machine Tool Operation/Machine Shop", add 
label define label_cipcode3 480507 "48.0507 - Tool and Die Making", add 
label define label_cipcode3 480508 "48.0508 - Welding", add 
label define label_cipcode3 480602 "48.0602 - Jewelry Design, Fabrication, and Repair", add 
label define label_cipcode3 489999 "48.9999 - Precision Prod., Oth.", add 
label define label_cipcode3 490101 "49.0101 - Air Transportation, Gen.", add 
label define label_cipcode3 490102 "49.0102 - Airplane Piloting and Navigation (Commer", add 
label define label_cipcode3 490106 "49.0106 - Flight Attendants", add 
label define label_cipcode3 490107 "49.0107 - Airplane Piloting (Private)", add 
label define label_cipcode3 490199 "49.0199 - Air Transportation, Oth.", add 
label define label_cipcode3 490205 "49.0205 - Truck and Bus Driving", add 
label define label_cipcode3 490299 "49.0299 - Vehicle and Equip. Operation, Oth.", add 
label define label_cipcode3 490302 "49.0302 - Barge and Boat Operations", add 
label define label_cipcode3 490304 "49.0304 - Deep Water Diving and Life Support Syste", add 
label define label_cipcode3 490399 "49.0399 - Water Transportation, Oth.", add 
label define label_cipcode3 499999 "49.9999 - Transportation and Material Moving, Oth.", add 
label define label_cipcode3 500299 "50.0299 - Crafts, Oth.", add 
label define label_cipcode3 500402 "50.0402 - Graphic Design", add 
label define label_cipcode3 500501 "50.0501 - Dramatic Arts", add 
label define label_cipcode3 500601 "50.0601 - Film Arts, Gen.", add 
label define label_cipcode3 500605 "50.0605 - Photography", add 
label define label_cipcode3 500708 "50.0708 - Painting", add 
label define label_cipcode3 500799 "50.0799 - Fine Arts, Oth.", add 
label define label_cipcode3 500904 "50.0904 - Music Theory and Composition", add 
label define label_cipcode3 500999 "50.0999 - Music, Oth.", add 
label define label_cipcode3 509999 "50.9999 - Visual and Performing Arts, Oth.", add 
label values cipcode3 label_cipcode3
label define label_cipcode4 10504 "01.0504 - Pet Grooming" 
label define label_cipcode4 10505 "01.0505 - Animal Training", add 
label define label_cipcode4 10602 "01.0602 - Arboriculture", add 
label define label_cipcode4 20299 "02.0299 - Animal Sciences, Oth.", add 
label define label_cipcode4 40101 "04.0101 - Architecture and Environmental Design, G", add 
label define label_cipcode4 40301 "04.0301 - City, Community, and Regional Planning", add 
label define label_cipcode4 40501 "04.0501 - Interior Design", add 
label define label_cipcode4 60101 "06.0101 - Business and Mgmt., Gen.", add 
label define label_cipcode4 60201 "06.0201 - Accounting", add 
label define label_cipcode4 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode4 60401 "06.0401 - Business Admin. and Mgmt., Gen.", add 
label define label_cipcode4 60499 "06.0499 - Business Admin. and Mgmt., Oth.", add 
label define label_cipcode4 60701 "06.0701 - Hotel/Motel Mgmt.", add 
label define label_cipcode4 60704 "06.0704 - Restaurant Mgmt.", add 
label define label_cipcode4 60799 "06.0799 - Institutional Mgmt., Oth.", add 
label define label_cipcode4 60801 "06.0801 - Insurance and Risk Mgmt.", add 
label define label_cipcode4 61701 "06.1701 - Real Estate", add 
label define label_cipcode4 61901 "06.1901 - Taxation", add 
label define label_cipcode4 69999 "06.9999 - Business and Mgmt., Oth.", add 
label define label_cipcode4 70101 "07.0101 - Accounting, Bookkeeping, and Related Pro", add 
label define label_cipcode4 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode4 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode4 70199 "07.0199 - Accounting, Bookkeeping, and Related Pro", add 
label define label_cipcode4 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode4 70205 "07.0205 - Teller", add 
label define label_cipcode4 70299 "07.0299 - Banking and Related Financial Programs,", add 
label define label_cipcode4 70301 "07.0301 - Business Data Processing and Related Pro", add 
label define label_cipcode4 70302 "07.0302 - Business Computer and Console Operation", add 
label define label_cipcode4 70303 "07.0303 - Business Data Entry Equip. Operation", add 
label define label_cipcode4 70399 "07.0399 - Business Data Processing and Related Pro", add 
label define label_cipcode4 70401 "07.0401 - Office Supervision and Mgmt.", add 
label define label_cipcode4 70599 "07.0599 - Personnel and Training Programs, Oth.", add 
label define label_cipcode4 70601 "07.0601 - Secretarial and Related Programs, Gen.", add 
label define label_cipcode4 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode4 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode4 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode4 70606 "07.0606 - Secretarial", add 
label define label_cipcode4 70699 "07.0699 - Secretarial and Related Programs, Oth.", add 
label define label_cipcode4 70701 "07.0701 - Typing, Gen. Office, and Related Program", add 
label define label_cipcode4 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode4 70703 "07.0703 - Correspondence Clerk", add 
label define label_cipcode4 70705 "07.0705 - Gen. Office Clerk", add 
label define label_cipcode4 70799 "07.0799 - Typing, Gen. Office, and Related Program", add 
label define label_cipcode4 70801 "07.0801 - Word Processing", add 
label define label_cipcode4 79999 "07.9999 - Business (Administrative Support), Oth.", add 
label define label_cipcode4 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode4 80199 "08.0199 - Apparel and Accessories Marketing, Oth.", add 
label define label_cipcode4 80301 "08.0301 - Entrepreneurship", add 
label define label_cipcode4 80502 "08.0502 - Farm and Garden Supplies Marketing", add 
label define label_cipcode4 80503 "08.0503 - Floristry", add 
label define label_cipcode4 80705 "08.0705 - Retailing", add 
label define label_cipcode4 80706 "08.0706 - Sales", add 
label define label_cipcode4 80708 "08.0708 - Marketing, Gen.", add 
label define label_cipcode4 81001 "08.1001 - Insurance Marketing", add 
label define label_cipcode4 81101 "08.1101 - Transportation and Travel Marketing, Gen", add 
label define label_cipcode4 81102 "08.1102 - Transportation Marketing", add 
label define label_cipcode4 81104 "08.1104 - Tourism", add 
label define label_cipcode4 81105 "08.1105 - Travel Serv. Marketing", add 
label define label_cipcode4 81199 "08.1199 - Transportation and Travel Marketing, Oth", add 
label define label_cipcode4 90201 "09.0201 - Advertising", add 
label define label_cipcode4 90701 "09.0701 - Radio/Television, Gen.", add 
label define label_cipcode4 100104 "10.0104 - Radio and Television Prod. and Broadcast", add 
label define label_cipcode4 100105 "10.0105 - Sound Recording Tech.", add 
label define label_cipcode4 110101 "11.0101 - Computer and Information Sciences, Gen.", add 
label define label_cipcode4 110201 "11.0201 - Computer Programming", add 
label define label_cipcode4 110301 "11.0301 - Data Processing", add 
label define label_cipcode4 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode4 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode4 119999 "11.9999 - Computer and Information Sciences, Oth.", add 
label define label_cipcode4 120101 "12.0101 - Drycleaning and Laundering Serv.", add 
label define label_cipcode4 120202 "12.0202 - Bartending", add 
label define label_cipcode4 120203 "12.0203 - Card Dealing", add 
label define label_cipcode4 120301 "12.0301 - Funeral Serv.", add 
label define label_cipcode4 120402 "12.0402 - Barbering/Hairstyling", add 
label define label_cipcode4 120403 "12.0403 - Cosmetology", add 
label define label_cipcode4 120404 "12.0404 - Electrolysis", add 
label define label_cipcode4 120406 "12.0406 - Make-up Artistry", add 
label define label_cipcode4 120499 "12.0499 - Personal Serv., Oth.", add 
label define label_cipcode4 129999 "12.9999 - Consumer, Personal and Misc. Serv., Oth.", add 
label define label_cipcode4 130201 "13.0201 - Bilingual/Crosscultural Education", add 
label define label_cipcode4 131001 "13.1001 - Special Education, Gen.", add 
label define label_cipcode4 139999 "13.9999 - Education, Oth.", add 
label define label_cipcode4 149999 "14.9999 - Engineering, Oth.", add 
label define label_cipcode4 150202 "15.0202 - Drafting and Design Tech.", add 
label define label_cipcode4 150301 "15.0301 - Computer Tech.", add 
label define label_cipcode4 150303 "15.0303 - Electronic Tech.", add 
label define label_cipcode4 150399 "15.0399 - Electrical and Electronic Technologies,", add 
label define label_cipcode4 150610 "15.0610 - Welding Tech.", add 
label define label_cipcode4 150702 "15.0702 - Quality Control Tech.", add 
label define label_cipcode4 159999 "15.9999 - Engineering and Engineering-Related Tech", add 
label define label_cipcode4 160101 "16.0101 - Foreign Languages, Multiple Emphasis", add 
label define label_cipcode4 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode4 170103 "17.0103 - Dental Laboratory Tech.", add 
label define label_cipcode4 170199 "17.0199 - Dental Serv., Oth.", add 
label define label_cipcode4 170203 "17.0203 - Electrocardiograph Tech.", add 
label define label_cipcode4 170204 "17.0204 - Electroencephalograph Tech.", add 
label define label_cipcode4 170208 "17.0208 - Nuclear Medical Tech.", add 
label define label_cipcode4 170212 "17.0212 - Diagnostic Medical Sonography", add 
label define label_cipcode4 170305 "17.0305 - Clinical Laboratory Assisting", add 
label define label_cipcode4 170309 "17.0309 - Medical Laboratory Tech.", add 
label define label_cipcode4 170310 "17.0310 - Medical Tech.", add 
label define label_cipcode4 170399 "17.0399 - Medical Laboratory Technologies, Oth.", add 
label define label_cipcode4 170499 "17.0499 - Mental Health/Human Serv., Oth.", add 
label define label_cipcode4 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode4 170505 "17.0505 - Medical Office Mgmt.", add 
label define label_cipcode4 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode4 170599 "17.0599 - Misc. Allied Health Serv., Oth.", add 
label define label_cipcode4 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode4 170699 "17.0699 - Nursing-Related Serv., Oth.", add 
label define label_cipcode4 170705 "17.0705 - Optometric Tech.", add 
label define label_cipcode4 170799 "17.0799 - Ophthalmic Serv., Oth.", add 
label define label_cipcode4 179999 "17.9999 - Allied Health, Oth.", add 
label define label_cipcode4 181101 "18.1101 - Nursing, Gen.", add 
label define label_cipcode4 181199 "18.1199 - Nursing, Oth.", add 
label define label_cipcode4 182299 "18.2299 - Public Health, Oth.", add 
label define label_cipcode4 190902 "19.0902 - Fashion Design", add 
label define label_cipcode4 200103 "20.0103 - Clothing and Textiles", add 
label define label_cipcode4 200109 "20.0109 - Home Mgmt.", add 
label define label_cipcode4 200202 "20.0202 - Child Care Aide/Assisting", add 
label define label_cipcode4 200302 "20.0302 - Clothing Main. Aide", add 
label define label_cipcode4 200305 "20.0305 - Custom Tailoring and Alteration", add 
label define label_cipcode4 200306 "20.0306 - Fashion/Fabric Coordination", add 
label define label_cipcode4 200399 "20.0399 - Clothing, Apparel, and Textiles Mgmt.,", add 
label define label_cipcode4 200401 "20.0401 - Food Prod., Mgmt., and Serv., Gen.", add 
label define label_cipcode4 200499 "20.0499 - Food Prod., Mgmt., and Serv., Oth.", add 
label define label_cipcode4 200504 "20.0504 - Floral Design", add 
label define label_cipcode4 220103 "22.0103 - Legal Assisting", add 
label define label_cipcode4 220199 "22.0199 - Law, Other", add 
label define label_cipcode4 230501 "23.0501 - Creative Writing", add 
label define label_cipcode4 231201 "23.1201 - English as a Second Language", add 
label define label_cipcode4 320101 "32.0101 - Basic Skills, Gen.", add 
label define label_cipcode4 320102 "32.0102 - Academic and Intellectual Skills", add 
label define label_cipcode4 330102 "33.0102 - American Citizenship", add 
label define label_cipcode4 340104 "34.0104 - Health Treatment/Prevention Practices", add 
label define label_cipcode4 360109 "36.0109 - Travel", add 
label define label_cipcode4 370101 "37.0101 - Personal Awareness, Gen.", add 
label define label_cipcode4 370199 "37.0199 - Personal Awareness, Oth.", add 
label define label_cipcode4 390101 "39.0101 - Biblical Languages", add 
label define label_cipcode4 390201 "39.0201 - Bible Studies", add 
label define label_cipcode4 410299 "41.0299 - Nuclear Technologies, Oth.", add 
label define label_cipcode4 430102 "43.0102 - Corrections", add 
label define label_cipcode4 430109 "43.0109 - Security Serv.", add 
label define label_cipcode4 430199 "43.0199 - Criminal Justice, Oth.", add 
label define label_cipcode4 439999 "43.9999 - Protective Serv., Oth.", add 
label define label_cipcode4 450901 "45.0901 - International Relations", add 
label define label_cipcode4 460102 "46.0102 - Brickmasonry, Block, and Stonemasonry", add 
label define label_cipcode4 460201 "46.0201 - Carpentry", add 
label define label_cipcode4 460302 "46.0302 - Electrician", add 
label define label_cipcode4 460401 "46.0401 - Building and Property Main.", add 
label define label_cipcode4 460402 "46.0402 - Concrete Placing and Finishing", add 
label define label_cipcode4 460405 "46.0405 - Floor Covering Installation", add 
label define label_cipcode4 469999 "46.9999 - Construction Trades, Oth.", add 
label define label_cipcode4 470101 "47.0101 - Electrical and Electronics Equip. Repair", add 
label define label_cipcode4 470104 "47.0104 - Computer Electronics", add 
label define label_cipcode4 470105 "47.0105 - Industrial Electronics", add 
label define label_cipcode4 470199 "47.0199 - Electrical and Electronics Equip. Repair", add 
label define label_cipcode4 470201 "47.0201 - Heating, Air Conditioning, and Refrigera", add 
label define label_cipcode4 470299 "47.0299 - Heating, Air Conditioning, and Refrigera", add 
label define label_cipcode4 470301 "47.0301 - Industrial Equip. Main. and Repair, Gen.", add 
label define label_cipcode4 470403 "47.0403 - Locksmithing and Safe Repair", add 
label define label_cipcode4 470499 "47.0499 - Misc. Mechanics and Repairers, Oth.", add 
label define label_cipcode4 470603 "47.0603 - Automotive Body Repair", add 
label define label_cipcode4 470604 "47.0604 - Automotive Mechanics", add 
label define label_cipcode4 470605 "47.0605 - Diesel Engine Mechanics", add 
label define label_cipcode4 470606 "47.0606 - Small Engine Repair", add 
label define label_cipcode4 470699 "47.0699 - Vehicle and Mobile Equip. Mechanics and", add 
label define label_cipcode4 479999 "47.9999 - Mechanics and Repairers, Oth.", add 
label define label_cipcode4 480101 "48.0101 - Drafting, Gen.", add 
label define label_cipcode4 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode4 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode4 480199 "48.0199 - Drafting, Oth.", add 
label define label_cipcode4 480203 "48.0203 - Commercial Art", add 
label define label_cipcode4 480208 "48.0208 - Printing Press Operations", add 
label define label_cipcode4 480299 "48.0299 - Graphic and Printing Communications, Oth", add 
label define label_cipcode4 480506 "48.0506 - Sheet Metal", add 
label define label_cipcode4 480508 "48.0508 - Welding", add 
label define label_cipcode4 480602 "48.0602 - Jewelry Design, Fabrication, and Repair", add 
label define label_cipcode4 480604 "48.0604 - Plastics", add 
label define label_cipcode4 490101 "49.0101 - Air Transportation, Gen.", add 
label define label_cipcode4 490102 "49.0102 - Airplane Piloting and Navigation (Commer", add 
label define label_cipcode4 490107 "49.0107 - Airplane Piloting (Private)", add 
label define label_cipcode4 490199 "49.0199 - Air Transportation, Oth.", add 
label define label_cipcode4 490205 "49.0205 - Truck and Bus Driving", add 
label define label_cipcode4 490299 "49.0299 - Vehicle and Equip. Operation, Oth.", add 
label define label_cipcode4 490302 "49.0302 - Barge and Boat Operations", add 
label define label_cipcode4 490399 "49.0399 - Water Transportation, Oth.", add 
label define label_cipcode4 499999 "49.9999 - Transportation and Material Moving, Oth.", add 
label define label_cipcode4 500402 "50.0402 - Graphic Design", add 
label define label_cipcode4 500501 "50.0501 - Dramatic Arts", add 
label define label_cipcode4 500602 "50.0602 - Cinematography/Film", add 
label define label_cipcode4 500605 "50.0605 - Photography", add 
label define label_cipcode4 500699 "50.0699 - Film Arts, Oth.", add 
label define label_cipcode4 500708 "50.0708 - Painting", add 
label define label_cipcode4 500799 "50.0799 - Fine Arts, Oth.", add 
label define label_cipcode4 500999 "50.0999 - Music, Oth.", add 
label define label_cipcode4 509999 "50.9999 - Visual and Performing Arts, Oth.", add 
label values cipcode4 label_cipcode4
label define label_cipcode5 10502 "01.0502 - Agricultural Serv." 
label define label_cipcode5 10607 "01.0607 - Turf Mgmt.", add 
label define label_cipcode5 20203 "02.0203 - Animal Health", add 
label define label_cipcode5 40501 "04.0501 - Interior Design", add 
label define label_cipcode5 50299 "05.0299 - Ethnic Studies, Other", add 
label define label_cipcode5 60101 "06.0101 - Business and Mgmt., Gen.", add 
label define label_cipcode5 60201 "06.0201 - Accounting", add 
label define label_cipcode5 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode5 60401 "06.0401 - Business Admin. and Mgmt., Gen.", add 
label define label_cipcode5 60499 "06.0499 - Business Admin. and Mgmt., Oth.", add 
label define label_cipcode5 60701 "06.0701 - Hotel/Motel Mgmt.", add 
label define label_cipcode5 60704 "06.0704 - Restaurant Mgmt.", add 
label define label_cipcode5 61001 "06.1001 - Investments and Securities", add 
label define label_cipcode5 61701 "06.1701 - Real Estate", add 
label define label_cipcode5 69999 "06.9999 - Business and Mgmt., Oth.", add 
label define label_cipcode5 70101 "07.0101 - Accounting, Bookkeeping, and Related Pro", add 
label define label_cipcode5 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode5 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode5 70104 "07.0104 - Machine Billing, Bookkeeping, and Comput", add 
label define label_cipcode5 70199 "07.0199 - Accounting, Bookkeeping, and Related Pro", add 
label define label_cipcode5 70201 "07.0201 - Banking and Related Financial Programs,", add 
label define label_cipcode5 70203 "07.0203 - Insurance Clerk", add 
label define label_cipcode5 70205 "07.0205 - Teller", add 
label define label_cipcode5 70299 "07.0299 - Banking and Related Financial Programs,", add 
label define label_cipcode5 70301 "07.0301 - Business Data Processing and Related Pro", add 
label define label_cipcode5 70302 "07.0302 - Business Computer and Console Operation", add 
label define label_cipcode5 70303 "07.0303 - Business Data Entry Equip. Operation", add 
label define label_cipcode5 70305 "07.0305 - Business Data Programming", add 
label define label_cipcode5 70399 "07.0399 - Business Data Processing and Related Pro", add 
label define label_cipcode5 70601 "07.0601 - Secretarial and Related Programs, Gen.", add 
label define label_cipcode5 70602 "07.0602 - Court Reporting", add 
label define label_cipcode5 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode5 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode5 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode5 70606 "07.0606 - Secretarial", add 
label define label_cipcode5 70699 "07.0699 - Secretarial and Related Programs, Oth.", add 
label define label_cipcode5 70701 "07.0701 - Typing, Gen. Office, and Related Program", add 
label define label_cipcode5 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode5 70705 "07.0705 - Gen. Office Clerk", add 
label define label_cipcode5 70707 "07.0707 - Receptionist and Communication Systems", add 
label define label_cipcode5 70708 "07.0708 - Shipping, Receiving, and Stock Clerk", add 
label define label_cipcode5 70799 "07.0799 - Typing, Gen. Office, and Related Program", add 
label define label_cipcode5 70801 "07.0801 - Word Processing", add 
label define label_cipcode5 79999 "07.9999 - Business (Administrative Support), Oth.", add 
label define label_cipcode5 80101 "08.0101 - Apparel and Accessories Marketing, Gen.", add 
label define label_cipcode5 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode5 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode5 80199 "08.0199 - Apparel and Accessories Marketing, Oth.", add 
label define label_cipcode5 80203 "08.0203 - Marketing of Business or Personal Serv.", add 
label define label_cipcode5 80503 "08.0503 - Floristry", add 
label define label_cipcode5 80706 "08.0706 - Sales", add 
label define label_cipcode5 81101 "08.1101 - Transportation and Travel Marketing, Gen", add 
label define label_cipcode5 81104 "08.1104 - Tourism", add 
label define label_cipcode5 90701 "09.0701 - Radio/Television, Gen.", add 
label define label_cipcode5 99999 "09.9999 - Communications, Oth.", add 
label define label_cipcode5 100104 "10.0104 - Radio and Television Prod. and Broadcast", add 
label define label_cipcode5 100105 "10.0105 - Sound Recording Tech.", add 
label define label_cipcode5 110101 "11.0101 - Computer and Information Sciences, Gen.", add 
label define label_cipcode5 110201 "11.0201 - Computer Programming", add 
label define label_cipcode5 110301 "11.0301 - Data Processing", add 
label define label_cipcode5 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode5 119999 "11.9999 - Computer and Information Sciences, Oth.", add 
label define label_cipcode5 120101 "12.0101 - Drycleaning and Laundering Serv.", add 
label define label_cipcode5 120202 "12.0202 - Bartending", add 
label define label_cipcode5 120203 "12.0203 - Card Dealing", add 
label define label_cipcode5 120299 "12.0299 - Entertainment Serv., Oth.", add 
label define label_cipcode5 120402 "12.0402 - Barbering/Hairstyling", add 
label define label_cipcode5 120403 "12.0403 - Cosmetology", add 
label define label_cipcode5 120404 "12.0404 - Electrolysis", add 
label define label_cipcode5 120406 "12.0406 - Make-up Artistry", add 
label define label_cipcode5 120499 "12.0499 - Personal Serv., Oth.", add 
label define label_cipcode5 131010 "13.1010 - Remedial Education", add 
label define label_cipcode5 139999 "13.9999 - Education, Oth.", add 
label define label_cipcode5 149999 "14.9999 - Engineering, Oth.", add 
label define label_cipcode5 150303 "15.0303 - Electronic Tech.", add 
label define label_cipcode5 150402 "15.0402 - Computer Servicing Tech.", add 
label define label_cipcode5 150501 "15.0501 - Air Conditioning, Heating, and Refrigera", add 
label define label_cipcode5 150702 "15.0702 - Quality Control Tech.", add 
label define label_cipcode5 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode5 170103 "17.0103 - Dental Laboratory Tech.", add 
label define label_cipcode5 170203 "17.0203 - Electrocardiograph Tech.", add 
label define label_cipcode5 170205 "17.0205 - Emergency Medical Tech.-Ambulance", add 
label define label_cipcode5 170210 "17.0210 - Respiratory Therapy Tech.", add 
label define label_cipcode5 170305 "17.0305 - Clinical Laboratory Assisting", add 
label define label_cipcode5 170307 "17.0307 - Hematology Tech.", add 
label define label_cipcode5 170309 "17.0309 - Medical Laboratory Tech.", add 
label define label_cipcode5 170399 "17.0399 - Medical Laboratory Technologies, Oth.", add 
label define label_cipcode5 170404 "17.0404 - Home Health Aide", add 
label define label_cipcode5 170499 "17.0499 - Mental Health/Human Serv., Oth.", add 
label define label_cipcode5 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode5 170505 "17.0505 - Medical Office Mgmt.", add 
label define label_cipcode5 170512 "17.0512 - Veterinarian Assisting", add 
label define label_cipcode5 170599 "17.0599 - Misc. Allied Health Serv., Oth.", add 
label define label_cipcode5 170601 "17.0601 - Geriatric Aide", add 
label define label_cipcode5 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode5 170606 "17.0606 - Health Unit Mgmt.", add 
label define label_cipcode5 170814 "17.0814 - Physical Therapy Aide", add 
label define label_cipcode5 179999 "17.9999 - Allied Health, Oth.", add 
label define label_cipcode5 180799 "18.0799 - Health Serv. Admin., Oth.", add 
label define label_cipcode5 181199 "18.1199 - Nursing, Oth.", add 
label define label_cipcode5 182299 "18.2299 - Public Health, Oth.", add 
label define label_cipcode5 190902 "19.0902 - Fashion Design", add 
label define label_cipcode5 190999 "19.0999 - Textiles and Clothing, Oth.", add 
label define label_cipcode5 200103 "20.0103 - Clothing and Textiles", add 
label define label_cipcode5 200108 "20.0108 - Food and Nutrition", add 
label define label_cipcode5 200201 "20.0201 - Child Care and Guidance Mgmt. and Serv.,", add 
label define label_cipcode5 200399 "20.0399 - Clothing, Apparel, and Textiles Mgmt.,", add 
label define label_cipcode5 200405 "20.0405 - Food Catering", add 
label define label_cipcode5 200406 "20.0406 - Food Service", add 
label define label_cipcode5 200504 "20.0504 - Floral Design", add 
label define label_cipcode5 209999 "20.9999 - Vocational Home Economics, Oth.", add 
label define label_cipcode5 210104 "21.0104 - Electricity/Electronics", add 
label define label_cipcode5 210105 "21.0105 - Energy, Power, and Transportation", add 
label define label_cipcode5 210106 "21.0106 - Graphic Arts", add 
label define label_cipcode5 220103 "22.0103 - Legal Assisting", add 
label define label_cipcode5 220199 "22.0199 - Law, Other", add 
label define label_cipcode5 230501 "23.0501 - Creative Writing", add 
label define label_cipcode5 231201 "23.1201 - English as a Second Language", add 
label define label_cipcode5 260601 "26.0601 - Anatomy", add 
label define label_cipcode5 299999 "29.9999 - Military Technologies, Oth.", add 
label define label_cipcode5 320101 "32.0101 - Basic Skills, Gen.", add 
label define label_cipcode5 320105 "32.0105 - Job Seeking/Changing Skills", add 
label define label_cipcode5 360109 "36.0109 - Travel", add 
label define label_cipcode5 390301 "39.0301 - Missionary Studies", add 
label define label_cipcode5 399999 "39.9999 - Theology, Oth.", add 
label define label_cipcode5 410299 "41.0299 - Nuclear Technologies, Oth.", add 
label define label_cipcode5 430107 "43.0107 - Law Enforcement", add 
label define label_cipcode5 430109 "43.0109 - Security Serv.", add 
label define label_cipcode5 451101 "45.1101 - Sociology", add 
label define label_cipcode5 460101 "46.0101 - Brickmasonry, Stonemasonry, and Tile Set", add 
label define label_cipcode5 460102 "46.0102 - Brickmasonry, Block, and Stonemasonry", add 
label define label_cipcode5 460302 "46.0302 - Electrician", add 
label define label_cipcode5 460501 "46.0501 - Plumbing, Pipefitting, and Steamfitting,", add 
label define label_cipcode5 470105 "47.0105 - Industrial Electronics", add 
label define label_cipcode5 470199 "47.0199 - Electrical and Electronics Equip. Repair", add 
label define label_cipcode5 470201 "47.0201 - Heating, Air Conditioning, and Refrigera", add 
label define label_cipcode5 470203 "47.0203 - Heating and Air Conditioning", add 
label define label_cipcode5 470299 "47.0299 - Heating, Air Conditioning, and Refrigera", add 
label define label_cipcode5 470403 "47.0403 - Locksmithing and Safe Repair", add 
label define label_cipcode5 470499 "47.0499 - Misc. Mechanics and Repairers, Oth.", add 
label define label_cipcode5 470603 "47.0603 - Automotive Body Repair", add 
label define label_cipcode5 470604 "47.0604 - Automotive Mechanics", add 
label define label_cipcode5 470605 "47.0605 - Diesel Engine Mechanics", add 
label define label_cipcode5 470606 "47.0606 - Small Engine Repair", add 
label define label_cipcode5 470699 "47.0699 - Vehicle and Mobile Equip. Mechanics and", add 
label define label_cipcode5 479999 "47.9999 - Mechanics and Repairers, Oth.", add 
label define label_cipcode5 480101 "48.0101 - Drafting, Gen.", add 
label define label_cipcode5 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode5 480203 "48.0203 - Commercial Art", add 
label define label_cipcode5 480206 "48.0206 - Lithography, Photography, and Platemakin", add 
label define label_cipcode5 480208 "48.0208 - Printing Press Operations", add 
label define label_cipcode5 480506 "48.0506 - Sheet Metal", add 
label define label_cipcode5 480507 "48.0507 - Tool and Die Making", add 
label define label_cipcode5 480508 "48.0508 - Welding", add 
label define label_cipcode5 490101 "49.0101 - Air Transportation, Gen.", add 
label define label_cipcode5 490102 "49.0102 - Airplane Piloting and Navigation (Commer", add 
label define label_cipcode5 490104 "49.0104 - Aviation Mgmt.", add 
label define label_cipcode5 490107 "49.0107 - Airplane Piloting (Private)", add 
label define label_cipcode5 490199 "49.0199 - Air Transportation, Oth.", add 
label define label_cipcode5 490205 "49.0205 - Truck and Bus Driving", add 
label define label_cipcode5 490399 "49.0399 - Water Transportation, Oth.", add 
label define label_cipcode5 499999 "49.9999 - Transportation and Material Moving, Oth.", add 
label define label_cipcode5 500402 "50.0402 - Graphic Design", add 
label define label_cipcode5 500602 "50.0602 - Cinematography/Film", add 
label define label_cipcode5 500605 "50.0605 - Photography", add 
label define label_cipcode5 500705 "50.0705 - Drawing", add 
label define label_cipcode5 500708 "50.0708 - Painting", add 
label define label_cipcode5 500799 "50.0799 - Fine Arts, Oth.", add 
label define label_cipcode5 500903 "50.0903 - Music Performance", add 
label values cipcode5 label_cipcode5
label define label_cipcode6 10602 "01.0602 - Arboriculture" 
label define label_cipcode6 40301 "04.0301 - City, Community, and Regional Planning", add 
label define label_cipcode6 40501 "04.0501 - Interior Design", add 
label define label_cipcode6 60101 "06.0101 - Business and Mgmt., Gen.", add 
label define label_cipcode6 60201 "06.0201 - Accounting", add 
label define label_cipcode6 60301 "06.0301 - Banking and Finance", add 
label define label_cipcode6 60401 "06.0401 - Business Admin. and Mgmt., Gen.", add 
label define label_cipcode6 60499 "06.0499 - Business Admin. and Mgmt., Oth.", add 
label define label_cipcode6 60701 "06.0701 - Hotel/Motel Mgmt.", add 
label define label_cipcode6 61701 "06.1701 - Real Estate", add 
label define label_cipcode6 61801 "06.1801 - Small Business Mgmt. and Ownership", add 
label define label_cipcode6 61901 "06.1901 - Taxation", add 
label define label_cipcode6 69999 "06.9999 - Business and Mgmt., Oth.", add 
label define label_cipcode6 70101 "07.0101 - Accounting, Bookkeeping, and Related Pro", add 
label define label_cipcode6 70102 "07.0102 - Accounting and Computing", add 
label define label_cipcode6 70103 "07.0103 - Bookkeeping", add 
label define label_cipcode6 70199 "07.0199 - Accounting, Bookkeeping, and Related Pro", add 
label define label_cipcode6 70301 "07.0301 - Business Data Processing and Related Pro", add 
label define label_cipcode6 70302 "07.0302 - Business Computer and Console Operation", add 
label define label_cipcode6 70303 "07.0303 - Business Data Entry Equip. Operation", add 
label define label_cipcode6 70305 "07.0305 - Business Data Programming", add 
label define label_cipcode6 70399 "07.0399 - Business Data Processing and Related Pro", add 
label define label_cipcode6 70401 "07.0401 - Office Supervision and Mgmt.", add 
label define label_cipcode6 70601 "07.0601 - Secretarial and Related Programs, Gen.", add 
label define label_cipcode6 70602 "07.0602 - Court Reporting", add 
label define label_cipcode6 70603 "07.0603 - Executive Secretarial", add 
label define label_cipcode6 70604 "07.0604 - Legal Secretarial", add 
label define label_cipcode6 70605 "07.0605 - Medical Secretarial", add 
label define label_cipcode6 70606 "07.0606 - Secretarial", add 
label define label_cipcode6 70607 "07.0607 - Stenographic", add 
label define label_cipcode6 70699 "07.0699 - Secretarial and Related Programs, Oth.", add 
label define label_cipcode6 70701 "07.0701 - Typing, Gen. Office, and Related Program", add 
label define label_cipcode6 70702 "07.0702 - Clerk-Typist", add 
label define label_cipcode6 70705 "07.0705 - Gen. Office Clerk", add 
label define label_cipcode6 70707 "07.0707 - Receptionist and Communication Systems", add 
label define label_cipcode6 70801 "07.0801 - Word Processing", add 
label define label_cipcode6 79999 "07.9999 - Business (Administrative Support), Oth.", add 
label define label_cipcode6 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode6 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode6 80199 "08.0199 - Apparel and Accessories Marketing, Oth.", add 
label define label_cipcode6 80201 "08.0201 - Business and Personal Serv. Marketing,", add 
label define label_cipcode6 80708 "08.0708 - Marketing, Gen.", add 
label define label_cipcode6 81101 "08.1101 - Transportation and Travel Marketing, Gen", add 
label define label_cipcode6 81104 "08.1104 - Tourism", add 
label define label_cipcode6 81105 "08.1105 - Travel Serv. Marketing", add 
label define label_cipcode6 81199 "08.1199 - Transportation and Travel Marketing, Oth", add 
label define label_cipcode6 100105 "10.0105 - Sound Recording Tech.", add 
label define label_cipcode6 110101 "11.0101 - Computer and Information Sciences, Gen.", add 
label define label_cipcode6 110201 "11.0201 - Computer Programming", add 
label define label_cipcode6 110301 "11.0301 - Data Processing", add 
label define label_cipcode6 110401 "11.0401 - Information Sciences and Systems", add 
label define label_cipcode6 110601 "11.0601 - Microcomputer Applications", add 
label define label_cipcode6 119999 "11.9999 - Computer and Information Sciences, Oth.", add 
label define label_cipcode6 120203 "12.0203 - Card Dealing", add 
label define label_cipcode6 120402 "12.0402 - Barbering/Hairstyling", add 
label define label_cipcode6 120403 "12.0403 - Cosmetology", add 
label define label_cipcode6 120404 "12.0404 - Electrolysis", add 
label define label_cipcode6 120406 "12.0406 - Make-up Artistry", add 
label define label_cipcode6 120499 "12.0499 - Personal Serv., Oth.", add 
label define label_cipcode6 130101 "13.0101 - Education, Gen.", add 
label define label_cipcode6 131401 "13.1401 - Teaching English as a Second Language/Fo", add 
label define label_cipcode6 150301 "15.0301 - Computer Tech.", add 
label define label_cipcode6 150303 "15.0303 - Electronic Tech.", add 
label define label_cipcode6 150702 "15.0702 - Quality Control Tech.", add 
label define label_cipcode6 170101 "17.0101 - Dental Assisting", add 
label define label_cipcode6 170211 "17.0211 - Surgical Tech.", add 
label define label_cipcode6 170399 "17.0399 - Medical Laboratory Technologies, Oth.", add 
label define label_cipcode6 170401 "17.0401 - Alcohol/Drug Abuse Specialty", add 
label define label_cipcode6 170499 "17.0499 - Mental Health/Human Serv., Oth.", add 
label define label_cipcode6 170503 "17.0503 - Medical Assisting", add 
label define label_cipcode6 170505 "17.0505 - Medical Office Mgmt.", add 
label define label_cipcode6 170506 "17.0506 - Medical Records Tech.", add 
label define label_cipcode6 170507 "17.0507 - Pharmacy Assisting", add 
label define label_cipcode6 170599 "17.0599 - Misc. Allied Health Serv., Oth.", add 
label define label_cipcode6 170602 "17.0602 - Nursing Assisting", add 
label define label_cipcode6 170699 "17.0699 - Nursing-Related Serv., Oth.", add 
label define label_cipcode6 180799 "18.0799 - Health Serv. Admin., Oth.", add 
label define label_cipcode6 181018 "18.1018 - Pathology", add 
label define label_cipcode6 181199 "18.1199 - Nursing, Oth.", add 
label define label_cipcode6 182299 "18.2299 - Public Health, Oth.", add 
label define label_cipcode6 182401 "18.2401 - Veterinary Medicine", add 
label define label_cipcode6 190902 "19.0902 - Fashion Design", add 
label define label_cipcode6 200103 "20.0103 - Clothing and Textiles", add 
label define label_cipcode6 200108 "20.0108 - Food and Nutrition", add 
label define label_cipcode6 200301 "20.0301 - Clothing, Apparel, and Textiles Mgmt.,", add 
label define label_cipcode6 200304 "20.0304 - Custom Apparel/Garment Seamstress", add 
label define label_cipcode6 200401 "20.0401 - Food Prod., Mgmt., and Serv., Gen.", add 
label define label_cipcode6 200406 "20.0406 - Food Service", add 
label define label_cipcode6 200499 "20.0499 - Food Prod., Mgmt., and Serv., Oth.", add 
label define label_cipcode6 200504 "20.0504 - Floral Design", add 
label define label_cipcode6 200505 "20.0505 - Home Decorating", add 
label define label_cipcode6 210199 "21.0199 - Industrial Arts, Oth.", add 
label define label_cipcode6 220101 "22.0101 - Law", add 
label define label_cipcode6 230501 "23.0501 - Creative Writing", add 
label define label_cipcode6 239999 "23.9999 - Letters, Other", add 
label define label_cipcode6 320107 "32.0107 - Career Exploration", add 
label define label_cipcode6 360109 "36.0109 - Travel", add 
label define label_cipcode6 370101 "37.0101 - Personal Awareness, Gen.", add 
label define label_cipcode6 390501 "39.0501 - Religious Music", add 
label define label_cipcode6 410299 "41.0299 - Nuclear Technologies, Oth.", add 
label define label_cipcode6 421201 "42.1201 - Psycholinguistics", add 
label define label_cipcode6 430107 "43.0107 - Law Enforcement", add 
label define label_cipcode6 430109 "43.0109 - Security Serv.", add 
label define label_cipcode6 450801 "45.0801 - History", add 
label define label_cipcode6 460102 "46.0102 - Brickmasonry, Block, and Stonemasonry", add 
label define label_cipcode6 460401 "46.0401 - Building and Property Main.", add 
label define label_cipcode6 460501 "46.0501 - Plumbing, Pipefitting, and Steamfitting,", add 
label define label_cipcode6 469999 "46.9999 - Construction Trades, Oth.", add 
label define label_cipcode6 470101 "47.0101 - Electrical and Electronics Equip. Repair", add 
label define label_cipcode6 470103 "47.0103 - Communication Electronics", add 
label define label_cipcode6 470104 "47.0104 - Computer Electronics", add 
label define label_cipcode6 470199 "47.0199 - Electrical and Electronics Equip. Repair", add 
label define label_cipcode6 470299 "47.0299 - Heating, Air Conditioning, and Refrigera", add 
label define label_cipcode6 470301 "47.0301 - Industrial Equip. Main. and Repair, Gen.", add 
label define label_cipcode6 470403 "47.0403 - Locksmithing and Safe Repair", add 
label define label_cipcode6 470499 "47.0499 - Misc. Mechanics and Repairers, Oth.", add 
label define label_cipcode6 470603 "47.0603 - Automotive Body Repair", add 
label define label_cipcode6 470604 "47.0604 - Automotive Mechanics", add 
label define label_cipcode6 470606 "47.0606 - Small Engine Repair", add 
label define label_cipcode6 470699 "47.0699 - Vehicle and Mobile Equip. Mechanics and", add 
label define label_cipcode6 479999 "47.9999 - Mechanics and Repairers, Oth.", add 
label define label_cipcode6 480101 "48.0101 - Drafting, Gen.", add 
label define label_cipcode6 480104 "48.0104 - Electrical/Electronics Drafting", add 
label define label_cipcode6 480201 "48.0201 - Graphic and Printing Communications, Gen", add 
label define label_cipcode6 480203 "48.0203 - Commercial Art", add 
label define label_cipcode6 480208 "48.0208 - Printing Press Operations", add 
label define label_cipcode6 480503 "48.0503 - Machine Tool Operation/Machine Shop", add 
label define label_cipcode6 480508 "48.0508 - Welding", add 
label define label_cipcode6 490101 "49.0101 - Air Transportation, Gen.", add 
label define label_cipcode6 490102 "49.0102 - Airplane Piloting and Navigation (Commer", add 
label define label_cipcode6 490104 "49.0104 - Aviation Mgmt.", add 
label define label_cipcode6 490107 "49.0107 - Airplane Piloting (Private)", add 
label define label_cipcode6 490199 "49.0199 - Air Transportation, Oth.", add 
label define label_cipcode6 490205 "49.0205 - Truck and Bus Driving", add 
label define label_cipcode6 490302 "49.0302 - Barge and Boat Operations", add 
label define label_cipcode6 490399 "49.0399 - Water Transportation, Oth.", add 
label define label_cipcode6 499999 "49.9999 - Transportation and Material Moving, Oth.", add 
label define label_cipcode6 500605 "50.0605 - Photography", add 
label define label_cipcode6 500999 "50.0999 - Music, Oth.", add 
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
tab board
tab roombord
tab pg600
tab cipcode1
tab cipcode2
tab cipcode3
tab cipcode4
tab cipcode5
tab cipcode6
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
summarize ciptuit4
summarize ciplgth4
summarize cipenrl4
summarize ciptuit5
summarize ciplgth5
summarize cipenrl5
summarize ciptuit6
summarize ciplgth6
summarize cipenrl6
save dct_ic90d

