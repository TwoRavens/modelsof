* Created: 6/13/2004 2:10:01 AM
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
insheet using "../Raw Data/ic98_d_data_stata.csv", comma clear
label data "dct_ic98_d"
label variable unitid "unitid"
label variable apfee "Application fee is required"
label variable xappfeeu "Imputation field for APPLFEEU - Undergraduate application fee"
label variable applfeeu "Undergraduate application fee"
label variable xappfeeg "Imputation field for APPLFEEG - Graduate application fee"
label variable applfeeg "Graduate application fee"
label variable xappfeep "Imputation field for APPLFEEP - First-Professional application fee"
label variable applfeep "First-Professional application fee"
label variable ftstu "Full-time students are enrolled"
label variable chgper1 "By credit/contact hour"
label variable chgper2 "By term"
label variable chgper3 "By year"
label variable chgper4 "By program"
label variable chgper5 "Other basis for charging"
label variable prgmofr "Number of programs offered"
label variable pg300 "Programs at least 300 contact hrs."
label variable cipcode1 "1st CIP code"
label variable xciptui1 "Imputation field for CIPTUIT1 - 1st Tuition and fees"
label variable ciptuit1 "1st Tuition and fees"
label variable xcipsup1 "Imputation field for CIPSUPP1 - 1st Cost of books and supplies"
label variable cipsupp1 "1st Cost of books and supplies"
label variable xciplgt1 "Imputation field for CIPLGTH1 - 1st Length of program/contact hrs."
label variable ciplgth1 "1st Length of program/contact hrs."
label variable cipcode2 "2nd CIP code"
label variable xciptui2 "Imputation field for CIPTUIT2 - 2nd Tuition and fees (in-State)"
label variable ciptuit2 "2nd Tuition and fees (in-State)"
label variable xcipsup2 "Imputation field for CIPSUPP2 - 2nd Cost of books and supplies"
label variable cipsupp2 "2nd Cost of books and supplies"
label variable xciplgt2 "Imputation field for CIPLGTH2 - 2nd Length of program/contact hrs."
label variable ciplgth2 "2nd Length of program/contact hrs."
label variable cipcode3 "3rd CIP code"
label variable xciptui3 "Imputation field for CIPTUIT3 - 3rd Tuition and fees (in-State)"
label variable ciptuit3 "3rd Tuition and fees (in-State)"
label variable xcipsup3 "Imputation field for CIPSUPP3 - 3rd Cost of books and supplies"
label variable cipsupp3 "3rd Cost of books and supplies"
label variable xciplgt3 "Imputation field for CIPLGTH3 - 3rd Length of program/contact hrs."
label variable ciplgth3 "3rd Length of program/contact hrs."
label variable cipcode4 "4th CIP code"
label variable xciptui4 "Imputation field for CIPTUIT4 - 4th Tuition and fees (in-State)"
label variable ciptuit4 "4th Tuition and fees (in-State)"
label variable xcipsup4 "Imputation field for CIPSUPP4 - 4th Cost of books and supplies"
label variable cipsupp4 "4th Cost of books and supplies"
label variable xciplgt4 "Imputation field for CIPLGTH4 - 4th Length of program/contact hrs."
label variable ciplgth4 "4th Length of program/contact hrs."
label variable cipcode5 "5th CIP code"
label variable xciptui5 "Imputation field for CIPTUIT5 - 5th Tuition and fees (in-State)"
label variable ciptuit5 "5th Tuition and fees (in-State)"
label variable xcipsup5 "Imputation field for CIPSUPP5 - 5th Cost of books and supplies"
label variable cipsupp5 "5th Cost of books and supplies"
label variable xciplgt5 "Imputation field for CIPLGTH5 - 5th Length of program/contact hrs."
label variable ciplgth5 "5th Length of program/contact hrs."
label variable cipcode6 "6th CIP code"
label variable xciptui6 "Imputation field for CIPTUIT6 - 6th Tuition and fees (in-State)"
label variable ciptuit6 "6th Tuition and fees (in-State)"
label variable xcipsup6 "Imputation field for CIPSUPP6 - 6th Cost of books and supplies"
label variable cipsupp6 "6th Cost of books and supplies"
label variable xciplgt6 "Imputation field for CIPLGTH6 - 6th Length of program/contact hrs."
label variable ciplgth6 "6th Length of program/contact hrs."
label variable tuition4 "No full-time undergraduate students"
label variable xtuit1 "Imputation field for TUITION1 - Tuition and fees, full-time undergraduate, in-district"
label variable tuition1 "Tuition and fees, full-time undergraduate, in-district"
label variable xtuit2 "Imputation field for TUITION2 - Tuition and fees, full-time undergraduate, in-state"
label variable tuition2 "Tuition and fees, full-time undergraduate, in-state"
label variable xtuit3 "Imputation field for TUITION3 - Tuition and fees, full-time undergraduate, out-of-state"
label variable tuition3 "Tuition and fees, full-time undergraduate, out-of-state"
label variable xtypugcr "Imputation field for TPUGCRED - Typical number of credit hours for full-time undergraduate students"
label variable tpugcred "Typical number of credit hours for full-time undergraduate students"
label variable xtypugcn "Imputation field for TPUGCONT - Typical number of contact hours for full-time undergraduate students"
label variable tpugcont "Typical number of contact hours for full-time undergraduate students"
label variable tuition8 "No full-time graduate students"
label variable xtuit5 "Imputation field for TUITION5 - Tuition and fees, full-time graduate, in-district"
label variable tuition5 "Tuition and fees, full-time graduate, in-district"
label variable xtuit6 "Imputation field for TUITION6 - Tuition and fees, full-time graduate, in-state"
label variable tuition6 "Tuition and fees, full-time graduate, in-state"
label variable xtuit7 "Imputation field for TUITION7 - Tuition and fees, full-time graduate, out-of-state"
label variable tuition7 "Tuition and fees, full-time graduate, out-of-state"
label variable xtypgrcr "Imputation field for TPGRCRED - Typical number credit hours FTFY graduate"
label variable tpgrcred "Typical number credit hours FTFY graduate"
label variable profna "No full-time first-professional students"
label variable xispro1 "Imputation field for ISPROF1 -  Tuition and fees full-time  Chiropractic in-state"
label variable isprof1 "Tuition and fees full-time  Chiropractic in-state"
label variable xospro1 "Imputation field for OSPROF1 -  Tuition and fees full-time  Chiropractic out-of-state"
label variable osprof1 "Tuition and fees full-time  Chiropractic out-of-state"
label variable xispro2 "Imputation field for ISPROF2 -  Tuition and fees full-time  Dentistry in-state"
label variable isprof2 "Tuition and fees full-time  Dentistry in-state"
label variable xospro2 "Imputation field for OSPROF2 -  Tuition and fees full-time  Dentistry out-of-state"
label variable osprof2 "Tuition and fees full-time  Dentistry out-of-state"
label variable xispro3 "Imputation field for ISPROF3 -  Tuition and fees full-time  Medicine in-state"
label variable isprof3 "Tuition and fees full-time  Medicine in-state"
label variable xospro3 "Imputation field for OSPROF3 -  Tuition and fees full-time  Medicine out-of-state"
label variable osprof3 "Tuition and fees full-time  Medicine out-of-state"
label variable xispro4 "Imputation field for ISPROF4 -  Tuition and fees full-time  Optometry in-state"
label variable isprof4 "Tuition and fees full-time  Optometry in-state"
label variable xospro4 "Imputation field for OSPROF4 -  Tuition and fees full-time  Optometry out-of-state"
label variable osprof4 "Tuition and fees full-time  Optometry out-of-state"
label variable xispro5 "Imputation field for ISPROF5 -  Tuition and fees full-time  Osteopathic Medicine in-state"
label variable isprof5 "Tuition and fees full-time  Osteopathic Medicine in-state"
label variable xospro5 "Imputation field for OSPROF5 -  Tuition and fees full-time  Osteopathic Medicine out-of-state"
label variable osprof5 "Tuition and fees full-time  Osteopathic Medicine out-of-state"
label variable xispro6 "Imputation field for ISPROF6 -  Tuition and fees full-time  Pharmacy in-state"
label variable isprof6 "Tuition and fees full-time  Pharmacy in-state"
label variable xospro6 "Imputation field for OSPROF6 -  Tuition and fees full-time  Pharmacy out-of-state"
label variable osprof6 "Tuition and fees full-time  Pharmacy out-of-state"
label variable xispro7 "Imputation field for ISPROF7 -  Tuition and fees full-time  Podiatry in-state"
label variable isprof7 "Tuition and fees full-time  Podiatry in-state"
label variable xospro7 "Imputation field for OSPROF7 -  Tuition and fees full-time  Podiatry out-of-state"
label variable osprof7 "Tuition and fees full-time  Podiatry out-of-state"
label variable xispro8 "Imputation field for ISPROF8 -  Tuition and fees full-time  Veterinary Medicine in-state"
label variable isprof8 "Tuition and fees full-time  Veterinary Medicine in-state"
label variable xospro8 "Imputation field for OSPROF8 -  Tuition and fees full-time  Veterinary Medicine out-of-state"
label variable osprof8 "Tuition and fees full-time  Veterinary Medicine out-of-state"
label variable xispro9 "Imputation field for ISPROF9 -  Tuition and fees full-time  Law in-state"
label variable isprof9 "Tuition and fees full-time  Law in-state"
label variable xospro9 "Imputation field for OSPROF9 -  Tuition and fees full-time  Law out-of-state"
label variable osprof9 "Tuition and fees full-time  Law out-of-state"
label variable xispro10 "Imputation field for ISPROF10 -  Tuition and fees full-time  Theology in-state"
label variable isprof10 "Tuition and fees full-time  Theology in-state"
label variable xospro10 "Imputation field for OSPROF10 -  Tuition and fees full-time  Theology out-of-state"
label variable osprof10 "Tuition and fees full-time  Theology out-of-state"
label variable xispro11 "Imputation field for ISPROF11 -  Tuition and fees full-time  Other first-professional, in-state"
label variable isprof11 "Tuition and fees full-time  Other first-professional, in-state"
label variable xospro11 "Imputation field for OSPROF11 -  Tuition and fees full-time  Other first-professional, out-of-state"
label variable osprof11 "Tuition and fees full-time  Other first-professional, out-of-state"
label variable xtypfpcr "Imputation field for TPFPCRED - Typical number credit hours FTFY first-prof"
label variable tpfpcred "Typical number credit hours FTFY first-prof"
label variable room "Institution provides dormitory facilities"
label variable xroomcap "Imputation field for ROOMCAP - Total dormitory capacity"
label variable roomcap "Total dormitory capacity"
label variable board "Institution provides board or meal plan"
label variable xmealswk "Imputation field for MEALSWK - Number of meals per week in board charge"
label variable mealswk "Number of meals per week in board charge"
label variable mealsvry "Number meals/wk/BORDAMT/ROOMAMT"
label variable xroomamt "Imputation field for ROOMAMT - Typical room charge for academic year"
label variable roomamt "Typical room charge for academic year"
label variable xbordamt "Imputation field for BOARDAMT - Typical board charge for academic year"
label variable boardamt "Typical board charge for academic year"
label variable xrmbdamt "Imputation field for RMBRDAMT - Combined charge for room and board"
label variable rmbrdamt "Combined charge for room and board"
label define label_apfee -1 "{Not reported}" 
label define label_apfee -2 "{Item not applicable}", add 
label define label_apfee 1 "Yes", add 
label define label_apfee 2 "No", add 
label values apfee label_apfee
/*
label define label_xappfeeu 10 "Reported" 
label define label_xappfeeu 11 "Analyst corrected reported value", add 
label define label_xappfeeu 12 "Data generated from other data values", add 
label define label_xappfeeu 13 "Implied zero", add 
label define label_xappfeeu 14 "Data adjusted in scan edits", add 
label define label_xappfeeu 15 "Data copied from another field", add 
label define label_xappfeeu 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xappfeeu 17 "Details are adjusted to sum to total", add 
label define label_xappfeeu 18 "Total generated to equal the sum of detail", add 
label define label_xappfeeu 20 "Imputed using data from prior year", add 
label define label_xappfeeu 21 "Imputed using method other than prior year data", add 
label define label_xappfeeu 30 "Not applicable", add 
label define label_xappfeeu 31 "Original data field was not reported", add 
label define label_xappfeeu 40 "Suppressed to protect confidentiality", add 
*label values xappfeeu label_xappfeeu
label define label_xappfeeg 10 "Reported" 
label define label_xappfeeg 11 "Analyst corrected reported value", add 
label define label_xappfeeg 12 "Data generated from other data values", add 
label define label_xappfeeg 13 "Implied zero", add 
label define label_xappfeeg 14 "Data adjusted in scan edits", add 
label define label_xappfeeg 15 "Data copied from another field", add 
label define label_xappfeeg 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xappfeeg 17 "Details are adjusted to sum to total", add 
label define label_xappfeeg 18 "Total generated to equal the sum of detail", add 
label define label_xappfeeg 20 "Imputed using data from prior year", add 
label define label_xappfeeg 21 "Imputed using method other than prior year data", add 
label define label_xappfeeg 30 "Not applicable", add 
label define label_xappfeeg 31 "Original data field was not reported", add 
label define label_xappfeeg 40 "Suppressed to protect confidentiality", add 
*label values xappfeeg label_xappfeeg
label define label_xappfeep 10 "Reported" 
label define label_xappfeep 11 "Analyst corrected reported value", add 
label define label_xappfeep 12 "Data generated from other data values", add 
label define label_xappfeep 13 "Implied zero", add 
label define label_xappfeep 14 "Data adjusted in scan edits", add 
label define label_xappfeep 15 "Data copied from another field", add 
label define label_xappfeep 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xappfeep 17 "Details are adjusted to sum to total", add 
label define label_xappfeep 18 "Total generated to equal the sum of detail", add 
label define label_xappfeep 20 "Imputed using data from prior year", add 
label define label_xappfeep 21 "Imputed using method other than prior year data", add 
label define label_xappfeep 30 "Not applicable", add 
label define label_xappfeep 31 "Original data field was not reported", add 
label define label_xappfeep 40 "Suppressed to protect confidentiality", add 
*label values xappfeep label_xappfeep
*/
label define label_ftstu -1 "{Not reported}" 
label define label_ftstu -2 "{Item not applicable}", add 
label define label_ftstu 1 "Yes", add 
label define label_ftstu 2 "No", add 
label values ftstu label_ftstu
label define label_chgper1 -1 "{Not reported}" 
label define label_chgper1 -2 "{Item not applicable}", add 
label define label_chgper1 -5 "{Implied no}", add 
label define label_chgper1 1 "Yes", add 
label values chgper1 label_chgper1
label define label_chgper2 -1 "{Not reported}" 
label define label_chgper2 -2 "{Item not applicable}", add 
label define label_chgper2 -5 "{Implied no}", add 
label define label_chgper2 1 "Yes", add 
label values chgper2 label_chgper2
label define label_chgper3 -1 "{Not reported}" 
label define label_chgper3 -2 "{Item not applicable}", add 
label define label_chgper3 -5 "{Implied no}", add 
label define label_chgper3 1 "Yes", add 
label values chgper3 label_chgper3
label define label_chgper4 -1 "{Not reported}" 
label define label_chgper4 -2 "{Item not applicable}", add 
label define label_chgper4 -5 "{Implied no}", add 
label define label_chgper4 1 "Yes", add 
label values chgper4 label_chgper4
label define label_chgper5 -1 "{Not reported}" 
label define label_chgper5 -2 "{Item not applicable}", add 
label define label_chgper5 -5 "{Implied no}", add 
label define label_chgper5 1 "Yes", add 
label values chgper5 label_chgper5
label define label_pg300 -1 "{Not reported}" 
label define label_pg300 -2 "{Item not applicable}", add 
label define label_pg300 1 "Yes", add 
label define label_pg300 2 "No", add 
label values pg300 label_pg300
label define label_cipcode1 -1 "-1 - {Not reported}" 
label define label_cipcode1 -2 "-2 - {Item not applicable}", add 
label define label_cipcode1 10505 "01.0505 - Animal Trainer", add 
label define label_cipcode1 10507 "01.0507 - Equine Stud, Horse Mgmt/Trng", add 
label define label_cipcode1 10599 "01.0599 - Agri Supplies, Rel Svcs Oth", add 
label define label_cipcode1 10601 "01.0601 - Horticult Svcs Oper/Mgmt Gen", add 
label define label_cipcode1 10607 "01.0607 - Turf Management", add 
label define label_cipcode1 20299 "02.0299 - Animal Sciences, Other", add 
label define label_cipcode1 30401 "03.0401 - Forest Harvst/Prod Tech/Tech", add 
label define label_cipcode1 49999 "04.9999 - Architect & Rel Programs Oth", add 
label define label_cipcode1 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode1 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode1 80503 "08.0503 - Floristry Marketing Opers", add 
label define label_cipcode1 80701 "08.0701 - Auctioneering", add 
label define label_cipcode1 80706 "08.0706 - Gen Selling Skills/Sales Op", add 
label define label_cipcode1 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode1 81105 "08.1105 - Travel Svcs Marketing Oper", add 
label define label_cipcode1 81199 "08.1199 - Tour/Travel Svcs Mktg Op Oth", add 
label define label_cipcode1 89999 "08.9999 - Mktg Op/Mktg & Distrib Oth", add 
label define label_cipcode1 90201 "09.0201 - Advertising", add 
label define label_cipcode1 90402 "09.0402 - Broadcast Journalism", add 
label define label_cipcode1 90701 "09.0701 - Radio & TV Broadcasting", add 
label define label_cipcode1 100104 "10.0104 - Radio/TV Broadcast Tech/Tech", add 
label define label_cipcode1 100199 "10.0199 - Communications Tech/Tech Oth", add 
label define label_cipcode1 110101 "11.0101 - Computer & Info Science, Gen", add 
label define label_cipcode1 110201 "11.0201 - Computer Programming", add 
label define label_cipcode1 110301 "11.0301 - Data Processing Tech/Tech", add 
label define label_cipcode1 110401 "11.0401 - Information Sci & Systems", add 
label define label_cipcode1 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode1 110701 "11.0701 - Computer Science", add 
label define label_cipcode1 119999 "11.9999 - Computer & Info Science, Oth", add 
label define label_cipcode1 120203 "12.0203 - Card Dealer", add 
label define label_cipcode1 120301 "12.0301 - Funeral Svcs & Mortuary Sci", add 
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
label define label_cipcode1 120505 "12.0505 - Kitchen Pers/Cook & Asst Trg", add 
label define label_cipcode1 120506 "12.0506 - Meatcutter", add 
label define label_cipcode1 120599 "12.0599 - Culinary Arts/Rel Svcs, Oth", add 
label define label_cipcode1 129999 "12.9999 - Personal & Misc Svcs, Other", add 
label define label_cipcode1 131202 "13.1202 - Elementary Teacher Education", add 
label define label_cipcode1 131204 "13.1204 - PreElem/EC/Kindergn Tchr Ed", add 
label define label_cipcode1 131206 "13.1206 - Teacher Ed, Multiple Levels", add 
label define label_cipcode1 131399 "13.1399 - Tchr Ed, Acad/Voc Pgms, Oth", add 
label define label_cipcode1 139999 "13.9999 - Education, Other", add 
label define label_cipcode1 140901 "14.0901 - Computer Engineering", add 
label define label_cipcode1 141001 "14.1001 - Elect, Electron & Comm Eng", add 
label define label_cipcode1 142201 "14.2201 - Naval Arch & Marine Eng", add 
label define label_cipcode1 150301 "15.0301 - Computer Eng Tech/Tech", add 
label define label_cipcode1 150303 "15.0303 - Elect/Electron/Comm Eng T/T", add 
label define label_cipcode1 150399 "15.0399 - Elect/Elect Eng-Rel T/T Oth", add 
label define label_cipcode1 150402 "15.0402 - Computer Maint Tech/Tech", add 
label define label_cipcode1 150403 "15.0403 - Electromechanical Tech/Tech", add 
label define label_cipcode1 150404 "15.0404 - Instrumentation Tech/Tech", add 
label define label_cipcode1 150405 "15.0405 - Robotics Technology/Tech", add 
label define label_cipcode1 150501 "15.0501 - Heating/AC/Refrig Tech/Tech", add 
label define label_cipcode1 150507 "15.0507 - Environ & Pollution Ctrl T/T", add 
label define label_cipcode1 150603 "15.0603 - Industrial/Manuf Tech/Tech", add 
label define label_cipcode1 150699 "15.0699 - Indust Prod Tech/Tech, Oth", add 
label define label_cipcode1 150803 "15.0803 - Automotive Eng Tech/Tech", add 
label define label_cipcode1 151001 "15.1001 - Construction/Bldg Tech/Tech", add 
label define label_cipcode1 151101 "15.1101 - Engineering-Related T/T Gen", add 
label define label_cipcode1 151103 "15.1103 - Hydraulic Technology/Tech", add 
label define label_cipcode1 160103 "16.0103 - Foreign Lang Interpret/Trans", add 
label define label_cipcode1 160905 "16.0905 - Spanish Language/Literature", add 
label define label_cipcode1 190503 "19.0503 - Dietetics/Human Nutrit Svcs", add 
label define label_cipcode1 190601 "19.0601 - Housing Studies, General", add 
label define label_cipcode1 190706 "19.0706 - Child Growth/Care/Devel Stds", add 
label define label_cipcode1 190901 "19.0901 - Clothing/Appar/Textile Studs", add 
label define label_cipcode1 200202 "20.0202 - Child Care Provider/Asst", add 
label define label_cipcode1 200301 "20.0301 - Clothng/App/Txtl Wkr/Mgr Gen", add 
label define label_cipcode1 200399 "20.0399 - Clothng/App/Txtl Wkr/Mgr Oth", add 
label define label_cipcode1 200501 "20.0501 - Home Furn/Equip Instal Gen", add 
label define label_cipcode1 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode1 240101 "24.0101 - Lib Arts, Sci/Lib Studies", add 
label define label_cipcode1 240199 "24.0199 - Lib Arts, Sci/Gen St Hum Oth", add 
label define label_cipcode1 260101 "26.0101 - Biology, General", add 
label define label_cipcode1 260607 "26.0607 - Marine/Aquatic Biology", add 
label define label_cipcode1 260609 "26.0609 - Nutritional Sciences", add 
label define label_cipcode1 310101 "31.0101 - Parks/Rec/Leisure Studies", add 
label define label_cipcode1 310301 "31.0301 - Parks/Rec/Leisure Facils Mgt", add 
label define label_cipcode1 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode1 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode1 390601 "39.0601 - Theology/Theological Studies", add 
label define label_cipcode1 390602 "39.0602 - Divinity/Ministry (BD, MDiv)", add 
label define label_cipcode1 400699 "40.0699 - Geological & Rel Sci, Other", add 
label define label_cipcode1 400702 "40.0702 - Oceanography", add 
label define label_cipcode1 400807 "40.0807 - Optics", add 
label define label_cipcode1 430102 "43.0102 - Corrections/Correction Admin", add 
label define label_cipcode1 430103 "43.0103 - Crim Justice/Law Enforce Adm", add 
label define label_cipcode1 430106 "43.0106 - Forensic Technology/Tech", add 
label define label_cipcode1 430107 "43.0107 - Law Enforcement/Police Sci", add 
label define label_cipcode1 430109 "43.0109 - Security & Loss Prevent Svcs", add 
label define label_cipcode1 430199 "43.0199 - Crim Justice & Correct, Oth", add 
label define label_cipcode1 450101 "45.0101 - Social Sciences, General", add 
label define label_cipcode1 460201 "46.0201 - Carpenter", add 
label define label_cipcode1 460302 "46.0302 - Electrician", add 
label define label_cipcode1 460303 "46.0303 - Lineworker", add 
label define label_cipcode1 460401 "46.0401 - Building/Property Maint/Mgr", add 
label define label_cipcode1 470101 "47.0101 - Elect/El Equip Inst/Rep Gen", add 
label define label_cipcode1 470102 "47.0102 - Business Machine Repairer", add 
label define label_cipcode1 470103 "47.0103 - Commun Systems Inst & Repair", add 
label define label_cipcode1 470104 "47.0104 - Computer Install & Repair", add 
label define label_cipcode1 470105 "47.0105 - Indust Electron Install/Rep", add 
label define label_cipcode1 470106 "47.0106 - Major Appliance Install/Rep", add 
label define label_cipcode1 470199 "47.0199 - Elect/El Equip Inst/Rep Oth", add 
label define label_cipcode1 470201 "47.0201 - Heating/AC/Refrig Mech/Rep", add 
label define label_cipcode1 470302 "47.0302 - Heavy Equip Maint/Repair", add 
label define label_cipcode1 470303 "47.0303 - Indust Machine Maint/Repair", add 
label define label_cipcode1 470399 "47.0399 - Indust Equip Maint/Rep, Oth", add 
label define label_cipcode1 470402 "47.0402 - Gunsmith", add 
label define label_cipcode1 470403 "47.0403 - Locksmith & Safe Repair", add 
label define label_cipcode1 470404 "47.0404 - Musical Instrument Repair", add 
label define label_cipcode1 470408 "47.0408 - Watch/Clock/Jewelry Repair", add 
label define label_cipcode1 470499 "47.0499 - Misc Mechanics & Repair, Oth", add 
label define label_cipcode1 470603 "47.0603 - Auto/Automotive Body Repair", add 
label define label_cipcode1 470604 "47.0604 - Auto/Automotive Mech/Tech", add 
label define label_cipcode1 470605 "47.0605 - Diesel Engine Mech/Repair", add 
label define label_cipcode1 470606 "47.0606 - Small Engine Mech/Repair", add 
label define label_cipcode1 470607 "47.0607 - Aircraft Mech/Tech, Airframe", add 
label define label_cipcode1 470608 "47.0608 - Aircraft Mech/Tech, Powrplnt", add 
label define label_cipcode1 470609 "47.0609 - Aviation Sys/Avionics T/T", add 
label define label_cipcode1 470611 "47.0611 - Motorcycle Mechanic & Repair", add 
label define label_cipcode1 470699 "47.0699 - Veh/Mobil Equip Mech/Rep Oth", add 
label define label_cipcode1 479999 "47.9999 - Mechanics & Repairers, Other", add 
label define label_cipcode1 480101 "48.0101 - Drafting, General", add 
label define label_cipcode1 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode1 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode1 480201 "48.0201 - Graphic/Print Equip Oper Gen", add 
label define label_cipcode1 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode1 480211 "48.0211 - Computer Typo/Compo Equip Op", add 
label define label_cipcode1 480212 "48.0212 - Desktop Publishing Equip Op", add 
label define label_cipcode1 480303 "48.0303 - Upholsterer", add 
label define label_cipcode1 480501 "48.0501 - Machinist/Machine Tech", add 
label define label_cipcode1 480507 "48.0507 - Tool & Die Maker/Tech", add 
label define label_cipcode1 480508 "48.0508 - Welder/Welding Tech", add 
label define label_cipcode1 480799 "48.0799 - Woodworkers, Other", add 
label define label_cipcode1 490101 "49.0101 - Aviation & Airway Science", add 
label define label_cipcode1 490102 "49.0102 - Aircraft Pilot & Nav (Prof)", add 
label define label_cipcode1 490104 "49.0104 - Aviation Management", add 
label define label_cipcode1 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode1 490199 "49.0199 - Air Transportation Wkrs, Oth", add 
label define label_cipcode1 490202 "49.0202 - Construction Equip Operator", add 
label define label_cipcode1 490205 "49.0205 - Truck, Bus, Comm Vehicle Op", add 
label define label_cipcode1 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode1 490306 "49.0306 - Marine Maint & Ship Repairer", add 
label define label_cipcode1 490309 "49.0309 - Marine Sci/Merch Marine Ofc", add 
label define label_cipcode1 490399 "49.0399 - Water Transport Workers, Oth", add 
label define label_cipcode1 499999 "49.9999 - Trans & Mat Moving Wkrs, Oth", add 
label define label_cipcode1 500401 "50.0401 - Design/Visual Communications", add 
label define label_cipcode1 500402 "50.0402 - Graphic Des/Comm Art/Illust", add 
label define label_cipcode1 500406 "50.0406 - Commercial Photography", add 
label define label_cipcode1 500407 "50.0407 - Fashion Design & Illust", add 
label define label_cipcode1 500408 "50.0408 - Interior Design", add 
label define label_cipcode1 500499 "50.0499 - Design & Applied Arts, Oth", add 
label define label_cipcode1 500501 "50.0501 - Drama/Theater Arts, Gen", add 
label define label_cipcode1 500503 "50.0503 - Acting & Directing", add 
label define label_cipcode1 500602 "50.0602 - Film/Video/Cinematog & Prod", add 
label define label_cipcode1 500605 "50.0605 - Photography", add 
label define label_cipcode1 500699 "50.0699 - Film/Video/Photog Arts, Oth", add 
label define label_cipcode1 500701 "50.0701 - Art, General", add 
label define label_cipcode1 500713 "50.0713 - Metal & Jewelry Arts", add 
label define label_cipcode1 500903 "50.0903 - Music-General Performance", add 
label define label_cipcode1 500999 "50.0999 - Music, Other", add 
label define label_cipcode1 509999 "50.9999 - Visual & Performing Arts Oth", add 
label define label_cipcode1 510601 "51.0601 - Dental Assistant", add 
label define label_cipcode1 510603 "51.0603 - Dental Laboratory Technician", add 
label define label_cipcode1 510701 "51.0701 - Health Sys/Health Svcs Admin", add 
label define label_cipcode1 510704 "51.0704 - Health Unit Mgr/Ward Supv", add 
label define label_cipcode1 510705 "51.0705 - Medical Office Management", add 
label define label_cipcode1 510707 "51.0707 - Medical Records Tech/Tech", add 
label define label_cipcode1 510708 "51.0708 - Medical Transcription", add 
label define label_cipcode1 510799 "51.0799 - Health & Med Admin Svcs, Oth", add 
label define label_cipcode1 510801 "51.0801 - Medical Assistant", add 
label define label_cipcode1 510803 "51.0803 - Occupational Therapy Asst", add 
label define label_cipcode1 510805 "51.0805 - Pharmacy Technician/Asst", add 
label define label_cipcode1 510806 "51.0806 - Physical Therapy Assistant", add 
label define label_cipcode1 510807 "51.0807 - Physician Assistant", add 
label define label_cipcode1 510808 "51.0808 - Vet Asst/Animal Health Tech", add 
label define label_cipcode1 510899 "51.0899 - Health & Medical Assts, Oth", add 
label define label_cipcode1 510901 "51.0901 - Cardiovascular Tech/Tech", add 
label define label_cipcode1 510902 "51.0902 - Electrocardiograph Tech/Tech", add 
label define label_cipcode1 510903 "51.0903 - Electroencephalograph Tech/T", add 
label define label_cipcode1 510904 "51.0904 - Emergency Medicine Tech/Tech", add 
label define label_cipcode1 510905 "51.0905 - Nuclear Medicine Tech/Tech", add 
label define label_cipcode1 510907 "51.0907 - Medical Radiologic Tech/Tech", add 
label define label_cipcode1 510908 "51.0908 - Respiratory Therapy Tech", add 
label define label_cipcode1 510909 "51.0909 - Surgical/Operating Room Tech", add 
label define label_cipcode1 510910 "51.0910 - Diagnostic Med Sonography", add 
label define label_cipcode1 510999 "51.0999 - Health/Med Diag/Tx Svcs Oth", add 
label define label_cipcode1 511003 "51.1003 - Hematology Technology/Tech", add 
label define label_cipcode1 511004 "51.1004 - Medical Laboratory Tech", add 
label define label_cipcode1 511005 "51.1005 - Medical Technology", add 
label define label_cipcode1 511301 "51.1301 - Medical Anatomy", add 
label define label_cipcode1 511501 "51.1501 - Alcohol/Drug Abuse Couns", add 
label define label_cipcode1 511601 "51.1601 - Nursing (RN Training)", add 
label define label_cipcode1 511613 "51.1613 - Practical Nurse (LPN Train)", add 
label define label_cipcode1 511614 "51.1614 - Nurse Assistant/Aide", add 
label define label_cipcode1 511615 "51.1615 - Home Health Aide", add 
label define label_cipcode1 511699 "51.1699 - Nursing, Other", add 
label define label_cipcode1 511801 "51.1801 - Opticianry/Dispens Optician", add 
label define label_cipcode1 511901 "51.1901 - Osteopathic Medicine (DO)", add 
label define label_cipcode1 512303 "51.2303 - Hypnotherapy", add 
label define label_cipcode1 512308 "51.2308 - Physical Therapy", add 
label define label_cipcode1 512399 "51.2399 - Rehab/Therapeutic Svcs, Oth", add 
label define label_cipcode1 512601 "51.2601 - Health Aide", add 
label define label_cipcode1 512701 "51.2701 - Acupuncture & Oriental Med", add 
label define label_cipcode1 512704 "51.2704 - Naturopathic Medicine", add 
label define label_cipcode1 519999 "51.9999 - Health Profes & Rel Sci, Oth", add 
label define label_cipcode1 520101 "52.0101 - Business, General", add 
label define label_cipcode1 520201 "52.0201 - Business Admin & Mgmt, Gen", add 
label define label_cipcode1 520203 "52.0203 - Logistics & Materials Mgmt", add 
label define label_cipcode1 520204 "52.0204 - Office Supervision & Mgmt", add 
label define label_cipcode1 520205 "52.0205 - Operations Mgmt, Supervision", add 
label define label_cipcode1 520299 "52.0299 - Business Admin & Mgmt, Oth", add 
label define label_cipcode1 520301 "52.0301 - Accounting", add 
label define label_cipcode1 520302 "52.0302 - Accounting Technician", add 
label define label_cipcode1 520399 "52.0399 - Accounting, Other", add 
label define label_cipcode1 520401 "52.0401 - Admin Asst/Sec Sci, Gen", add 
label define label_cipcode1 520402 "52.0402 - Executive Assistant/Secty", add 
label define label_cipcode1 520403 "52.0403 - Legal Admin Asst/Secretary", add 
label define label_cipcode1 520404 "52.0404 - Medical Admin Asst/Secretary", add 
label define label_cipcode1 520405 "52.0405 - Court Reporter", add 
label define label_cipcode1 520407 "52.0407 - Info Process/Data Entry Tech", add 
label define label_cipcode1 520408 "52.0408 - Gen Office/Clerk/Typing Svcs", add 
label define label_cipcode1 520499 "52.0499 - Admin & Secretarial Svcs Oth", add 
label define label_cipcode1 520801 "52.0801 - Finance, General", add 
label define label_cipcode1 520803 "52.0803 - Banking & Fin Support Svcs", add 
label define label_cipcode1 520805 "52.0805 - Insurance & Risk Management", add 
label define label_cipcode1 520901 "52.0901 - Hospitality/Admin Management", add 
label define label_cipcode1 520902 "52.0902 - Hotel/Motel/Restaurant Mgmt", add 
label define label_cipcode1 520903 "52.0903 - Travel-Tourism Management", add 
label define label_cipcode1 520999 "52.0999 - Hospitality Svcs Mgmt, Other", add 
label define label_cipcode1 521001 "52.1001 - Human Resources Management", add 
label define label_cipcode1 521201 "52.1201 - Mgt InfoSys/Bus DataProc Gen", add 
label define label_cipcode1 521202 "52.1202 - Business Computer Prog/Prog", add 
label define label_cipcode1 521204 "52.1204 - Bus Systems Network, Telecom", add 
label define label_cipcode1 521205 "52.1205 - Bus Computer Facilities Oper", add 
label define label_cipcode1 521299 "52.1299 - Bus Info & DataProc Svcs Oth", add 
label define label_cipcode1 521501 "52.1501 - Real Estate", add 
label define label_cipcode1 529999 "52.9999 - Bus Mgmt & Admin Svcs, Other", add 
label values cipcode1 label_cipcode1
label define label_xciptui1 10 "Reported" 
label define label_xciptui1 11 "Analyst corrected reported value", add 
label define label_xciptui1 12 "Data generated from other data values", add 
label define label_xciptui1 13 "Implied zero", add 
label define label_xciptui1 14 "Data adjusted in scan edits", add 
label define label_xciptui1 15 "Data copied from another field", add 
label define label_xciptui1 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xciptui1 17 "Details are adjusted to sum to total", add 
label define label_xciptui1 18 "Total generated to equal the sum of detail", add 
label define label_xciptui1 20 "Imputed using data from prior year", add 
label define label_xciptui1 21 "Imputed using method other than prior year data", add 
label define label_xciptui1 30 "Not applicable", add 
label define label_xciptui1 31 "Original data field was not reported", add 
label define label_xciptui1 40 "Suppressed to protect confidentiality", add 
*label values xciptui1 label_xciptui1
label define label_xcipsup1 10 "Reported" 
label define label_xcipsup1 11 "Analyst corrected reported value", add 
label define label_xcipsup1 12 "Data generated from other data values", add 
label define label_xcipsup1 13 "Implied zero", add 
label define label_xcipsup1 14 "Data adjusted in scan edits", add 
label define label_xcipsup1 15 "Data copied from another field", add 
label define label_xcipsup1 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xcipsup1 17 "Details are adjusted to sum to total", add 
label define label_xcipsup1 18 "Total generated to equal the sum of detail", add 
label define label_xcipsup1 20 "Imputed using data from prior year", add 
label define label_xcipsup1 21 "Imputed using method other than prior year data", add 
label define label_xcipsup1 30 "Not applicable", add 
label define label_xcipsup1 31 "Original data field was not reported", add 
label define label_xcipsup1 40 "Suppressed to protect confidentiality", add 
*label values xcipsup1 label_xcipsup1
label define label_xciplgt1 10 "Reported" 
label define label_xciplgt1 11 "Analyst corrected reported value", add 
label define label_xciplgt1 12 "Data generated from other data values", add 
label define label_xciplgt1 13 "Implied zero", add 
label define label_xciplgt1 14 "Data adjusted in scan edits", add 
label define label_xciplgt1 15 "Data copied from another field", add 
label define label_xciplgt1 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xciplgt1 17 "Details are adjusted to sum to total", add 
label define label_xciplgt1 18 "Total generated to equal the sum of detail", add 
label define label_xciplgt1 20 "Imputed using data from prior year", add 
label define label_xciplgt1 21 "Imputed using method other than prior year data", add 
label define label_xciplgt1 30 "Not applicable", add 
label define label_xciplgt1 31 "Original data field was not reported", add 
label define label_xciplgt1 40 "Suppressed to protect confidentiality", add 
*label values xciplgt1 label_xciplgt1
label define label_cipcode2 -1 "-1 - {Not reported}" 
label define label_cipcode2 -2 "-2 - {Item not applicable}", add 
label define label_cipcode2 10201 "01.0201 - Agri Mechanization, General", add 
label define label_cipcode2 10505 "01.0505 - Animal Trainer", add 
label define label_cipcode2 10507 "01.0507 - Equine Stud, Horse Mgmt/Trng", add 
label define label_cipcode2 10599 "01.0599 - Agri Supplies, Rel Svcs Oth", add 
label define label_cipcode2 10604 "01.0604 - Greenhouse Operations & Mgmt", add 
label define label_cipcode2 30501 "03.0501 - Forestry, General", add 
label define label_cipcode2 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode2 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode2 80503 "08.0503 - Floristry Marketing Opers", add 
label define label_cipcode2 80901 "08.0901 - Hospitality, Rec Mktg Op Gen", add 
label define label_cipcode2 80902 "08.0902 - Hotel/Motel Svcs Market Oper", add 
label define label_cipcode2 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode2 81105 "08.1105 - Travel Svcs Marketing Oper", add 
label define label_cipcode2 81199 "08.1199 - Tour/Travel Svcs Mktg Op Oth", add 
label define label_cipcode2 90101 "09.0101 - Communications, General", add 
label define label_cipcode2 90701 "09.0701 - Radio & TV Broadcasting", add 
label define label_cipcode2 99999 "09.9999 - Communications, Other", add 
label define label_cipcode2 100104 "10.0104 - Radio/TV Broadcast Tech/Tech", add 
label define label_cipcode2 100199 "10.0199 - Communications Tech/Tech Oth", add 
label define label_cipcode2 110101 "11.0101 - Computer & Info Science, Gen", add 
label define label_cipcode2 110201 "11.0201 - Computer Programming", add 
label define label_cipcode2 110301 "11.0301 - Data Processing Tech/Tech", add 
label define label_cipcode2 110401 "11.0401 - Information Sci & Systems", add 
label define label_cipcode2 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode2 110701 "11.0701 - Computer Science", add 
label define label_cipcode2 119999 "11.9999 - Computer & Info Science, Oth", add 
label define label_cipcode2 120203 "12.0203 - Card Dealer", add 
label define label_cipcode2 120301 "12.0301 - Funeral Svcs & Mortuary Sci", add 
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
label define label_cipcode2 120504 "12.0504 - Food & Bev/Restaurant Op Mgr", add 
label define label_cipcode2 120505 "12.0505 - Kitchen Pers/Cook & Asst Trg", add 
label define label_cipcode2 120599 "12.0599 - Culinary Arts/Rel Svcs, Oth", add 
label define label_cipcode2 129999 "12.9999 - Personal & Misc Svcs, Other", add 
label define label_cipcode2 130101 "13.0101 - Education, General", add 
label define label_cipcode2 131202 "13.1202 - Elementary Teacher Education", add 
label define label_cipcode2 131204 "13.1204 - PreElem/EC/Kindergn Tchr Ed", add 
label define label_cipcode2 131206 "13.1206 - Teacher Ed, Multiple Levels", add 
label define label_cipcode2 131319 "13.1319 - Technical Teacher Ed (Voc)", add 
label define label_cipcode2 131399 "13.1399 - Tchr Ed, Acad/Voc Pgms, Oth", add 
label define label_cipcode2 139999 "13.9999 - Education, Other", add 
label define label_cipcode2 140901 "14.0901 - Computer Engineering", add 
label define label_cipcode2 141001 "14.1001 - Elect, Electron & Comm Eng", add 
label define label_cipcode2 142201 "14.2201 - Naval Arch & Marine Eng", add 
label define label_cipcode2 150201 "15.0201 - Civil Eng/Civil Tech/Tech", add 
label define label_cipcode2 150301 "15.0301 - Computer Eng Tech/Tech", add 
label define label_cipcode2 150303 "15.0303 - Elect/Electron/Comm Eng T/T", add 
label define label_cipcode2 150399 "15.0399 - Elect/Elect Eng-Rel T/T Oth", add 
label define label_cipcode2 150401 "15.0401 - Biomed Eng-Rel Tech/Tech", add 
label define label_cipcode2 150402 "15.0402 - Computer Maint Tech/Tech", add 
label define label_cipcode2 150403 "15.0403 - Electromechanical Tech/Tech", add 
label define label_cipcode2 150404 "15.0404 - Instrumentation Tech/Tech", add 
label define label_cipcode2 150405 "15.0405 - Robotics Technology/Tech", add 
label define label_cipcode2 150499 "15.0499 - Electromech Instr/Maint T/T", add 
label define label_cipcode2 150501 "15.0501 - Heating/AC/Refrig Tech/Tech", add 
label define label_cipcode2 150507 "15.0507 - Environ & Pollution Ctrl T/T", add 
label define label_cipcode2 150603 "15.0603 - Industrial/Manuf Tech/Tech", add 
label define label_cipcode2 150607 "15.0607 - Plastics Technology/Tech", add 
label define label_cipcode2 150803 "15.0803 - Automotive Eng Tech/Tech", add 
label define label_cipcode2 151001 "15.1001 - Construction/Bldg Tech/Tech", add 
label define label_cipcode2 151101 "15.1101 - Engineering-Related T/T Gen", add 
label define label_cipcode2 159999 "15.9999 - Engineering-Related T/T, Oth", add 
label define label_cipcode2 190699 "19.0699 - Housing Studies, Other", add 
label define label_cipcode2 200202 "20.0202 - Child Care Provider/Asst", add 
label define label_cipcode2 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode2 200399 "20.0399 - Clothng/App/Txtl Wkr/Mgr Oth", add 
label define label_cipcode2 200401 "20.0401 - Institution Food Wkr/Adm Gen", add 
label define label_cipcode2 200501 "20.0501 - Home Furn/Equip Instal Gen", add 
label define label_cipcode2 200602 "20.0602 - ElderCare Provider/Companion", add 
label define label_cipcode2 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode2 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode2 240101 "24.0101 - Lib Arts, Sci/Lib Studies", add 
label define label_cipcode2 240102 "24.0102 - General Studies", add 
label define label_cipcode2 240199 "24.0199 - Lib Arts, Sci/Gen St Hum Oth", add 
label define label_cipcode2 260699 "26.0699 - Misc Biological Specs, Other", add 
label define label_cipcode2 269999 "26.9999 - Biological Sci/Life Sci, Oth", add 
label define label_cipcode2 380201 "38.0201 - Religion/Religious Studies", add 
label define label_cipcode2 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode2 390601 "39.0601 - Theology/Theological Studies", add 
label define label_cipcode2 400699 "40.0699 - Geological & Rel Sci, Other", add 
label define label_cipcode2 400702 "40.0702 - Oceanography", add 
label define label_cipcode2 430102 "43.0102 - Corrections/Correction Admin", add 
label define label_cipcode2 430103 "43.0103 - Crim Justice/Law Enforce Adm", add 
label define label_cipcode2 430106 "43.0106 - Forensic Technology/Tech", add 
label define label_cipcode2 430107 "43.0107 - Law Enforcement/Police Sci", add 
label define label_cipcode2 430199 "43.0199 - Crim Justice & Correct, Oth", add 
label define label_cipcode2 430201 "43.0201 - Fire Protection/Safety T/T", add 
label define label_cipcode2 430203 "43.0203 - Fire Science/Firefighting", add 
label define label_cipcode2 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode2 460201 "46.0201 - Carpenter", add 
label define label_cipcode2 460301 "46.0301 - Elec/Power Trans Install Gen", add 
label define label_cipcode2 460302 "46.0302 - Electrician", add 
label define label_cipcode2 460399 "46.0399 - Elec/Power Trans Install Oth", add 
label define label_cipcode2 460401 "46.0401 - Building/Property Maint/Mgr", add 
label define label_cipcode2 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode2 470101 "47.0101 - Elect/El Equip Inst/Rep Gen", add 
label define label_cipcode2 470103 "47.0103 - Commun Systems Inst & Repair", add 
label define label_cipcode2 470104 "47.0104 - Computer Install & Repair", add 
label define label_cipcode2 470105 "47.0105 - Indust Electron Install/Rep", add 
label define label_cipcode2 470199 "47.0199 - Elect/El Equip Inst/Rep Oth", add 
label define label_cipcode2 470201 "47.0201 - Heating/AC/Refrig Mech/Rep", add 
label define label_cipcode2 470303 "47.0303 - Indust Machine Maint/Repair", add 
label define label_cipcode2 470399 "47.0399 - Indust Equip Maint/Rep, Oth", add 
label define label_cipcode2 470402 "47.0402 - Gunsmith", add 
label define label_cipcode2 470403 "47.0403 - Locksmith & Safe Repair", add 
label define label_cipcode2 470408 "47.0408 - Watch/Clock/Jewelry Repair", add 
label define label_cipcode2 470499 "47.0499 - Misc Mechanics & Repair, Oth", add 
label define label_cipcode2 470603 "47.0603 - Auto/Automotive Body Repair", add 
label define label_cipcode2 470604 "47.0604 - Auto/Automotive Mech/Tech", add 
label define label_cipcode2 470605 "47.0605 - Diesel Engine Mech/Repair", add 
label define label_cipcode2 470606 "47.0606 - Small Engine Mech/Repair", add 
label define label_cipcode2 470607 "47.0607 - Aircraft Mech/Tech, Airframe", add 
label define label_cipcode2 470608 "47.0608 - Aircraft Mech/Tech, Powrplnt", add 
label define label_cipcode2 470609 "47.0609 - Aviation Sys/Avionics T/T", add 
label define label_cipcode2 470611 "47.0611 - Motorcycle Mechanic & Repair", add 
label define label_cipcode2 470699 "47.0699 - Veh/Mobil Equip Mech/Rep Oth", add 
label define label_cipcode2 479999 "47.9999 - Mechanics & Repairers, Other", add 
label define label_cipcode2 480101 "48.0101 - Drafting, General", add 
label define label_cipcode2 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode2 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode2 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode2 480201 "48.0201 - Graphic/Print Equip Oper Gen", add 
label define label_cipcode2 480211 "48.0211 - Computer Typo/Compo Equip Op", add 
label define label_cipcode2 480212 "48.0212 - Desktop Publishing Equip Op", add 
label define label_cipcode2 480299 "48.0299 - Graphic/Print Equip Oper Oth", add 
label define label_cipcode2 480501 "48.0501 - Machinist/Machine Tech", add 
label define label_cipcode2 480507 "48.0507 - Tool & Die Maker/Tech", add 
label define label_cipcode2 480508 "48.0508 - Welder/Welding Tech", add 
label define label_cipcode2 480599 "48.0599 - Precision Metal Workers, Oth", add 
label define label_cipcode2 480701 "48.0701 - Woodworkers, General", add 
label define label_cipcode2 489999 "48.9999 - Precision Prod Trades, Oth", add 
label define label_cipcode2 490101 "49.0101 - Aviation & Airway Science", add 
label define label_cipcode2 490102 "49.0102 - Aircraft Pilot & Nav (Prof)", add 
label define label_cipcode2 490106 "49.0106 - Flight Attendant", add 
label define label_cipcode2 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode2 490199 "49.0199 - Air Transportation Wkrs, Oth", add 
label define label_cipcode2 490202 "49.0202 - Construction Equip Operator", add 
label define label_cipcode2 490205 "49.0205 - Truck, Bus, Comm Vehicle Op", add 
label define label_cipcode2 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode2 490309 "49.0309 - Marine Sci/Merch Marine Ofc", add 
label define label_cipcode2 490399 "49.0399 - Water Transport Workers, Oth", add 
label define label_cipcode2 499999 "49.9999 - Trans & Mat Moving Wkrs, Oth", add 
label define label_cipcode2 500401 "50.0401 - Design/Visual Communications", add 
label define label_cipcode2 500402 "50.0402 - Graphic Des/Comm Art/Illust", add 
label define label_cipcode2 500407 "50.0407 - Fashion Design & Illust", add 
label define label_cipcode2 500408 "50.0408 - Interior Design", add 
label define label_cipcode2 500499 "50.0499 - Design & Applied Arts, Oth", add 
label define label_cipcode2 500501 "50.0501 - Drama/Theater Arts, Gen", add 
label define label_cipcode2 500602 "50.0602 - Film/Video/Cinematog & Prod", add 
label define label_cipcode2 500605 "50.0605 - Photography", add 
label define label_cipcode2 500699 "50.0699 - Film/Video/Photog Arts, Oth", add 
label define label_cipcode2 500701 "50.0701 - Art, General", add 
label define label_cipcode2 500713 "50.0713 - Metal & Jewelry Arts", add 
label define label_cipcode2 500903 "50.0903 - Music-General Performance", add 
label define label_cipcode2 500909 "50.0909 - Music Bus Mgmt & Merchandis", add 
label define label_cipcode2 509999 "50.9999 - Visual & Performing Arts Oth", add 
label define label_cipcode2 510601 "51.0601 - Dental Assistant", add 
label define label_cipcode2 510603 "51.0603 - Dental Laboratory Technician", add 
label define label_cipcode2 510701 "51.0701 - Health Sys/Health Svcs Admin", add 
label define label_cipcode2 510703 "51.0703 - Health Unit Coord/Ward Clerk", add 
label define label_cipcode2 510705 "51.0705 - Medical Office Management", add 
label define label_cipcode2 510707 "51.0707 - Medical Records Tech/Tech", add 
label define label_cipcode2 510708 "51.0708 - Medical Transcription", add 
label define label_cipcode2 510799 "51.0799 - Health & Med Admin Svcs, Oth", add 
label define label_cipcode2 510801 "51.0801 - Medical Assistant", add 
label define label_cipcode2 510802 "51.0802 - Medical Laboratory Assistant", add 
label define label_cipcode2 510803 "51.0803 - Occupational Therapy Asst", add 
label define label_cipcode2 510805 "51.0805 - Pharmacy Technician/Asst", add 
label define label_cipcode2 510808 "51.0808 - Vet Asst/Animal Health Tech", add 
label define label_cipcode2 510899 "51.0899 - Health & Medical Assts, Oth", add 
label define label_cipcode2 510901 "51.0901 - Cardiovascular Tech/Tech", add 
label define label_cipcode2 510902 "51.0902 - Electrocardiograph Tech/Tech", add 
label define label_cipcode2 510904 "51.0904 - Emergency Medicine Tech/Tech", add 
label define label_cipcode2 510905 "51.0905 - Nuclear Medicine Tech/Tech", add 
label define label_cipcode2 510907 "51.0907 - Medical Radiologic Tech/Tech", add 
label define label_cipcode2 510908 "51.0908 - Respiratory Therapy Tech", add 
label define label_cipcode2 510909 "51.0909 - Surgical/Operating Room Tech", add 
label define label_cipcode2 510910 "51.0910 - Diagnostic Med Sonography", add 
label define label_cipcode2 510999 "51.0999 - Health/Med Diag/Tx Svcs Oth", add 
label define label_cipcode2 511002 "51.1002 - Cytotechnologist", add 
label define label_cipcode2 511004 "51.1004 - Medical Laboratory Tech", add 
label define label_cipcode2 511005 "51.1005 - Medical Technology", add 
label define label_cipcode2 511099 "51.1099 - Health/Med Lab Tech/Tech Oth", add 
label define label_cipcode2 511301 "51.1301 - Medical Anatomy", add 
label define label_cipcode2 511309 "51.1309 - Medical Molecular Biology", add 
label define label_cipcode2 511314 "51.1314 - Medical Toxicology", add 
label define label_cipcode2 511502 "51.1502 - Psych/Mental Health Svc Tech", add 
label define label_cipcode2 511601 "51.1601 - Nursing (RN Training)", add 
label define label_cipcode2 511613 "51.1613 - Practical Nurse (LPN Train)", add 
label define label_cipcode2 511614 "51.1614 - Nurse Assistant/Aide", add 
label define label_cipcode2 511615 "51.1615 - Home Health Aide", add 
label define label_cipcode2 511699 "51.1699 - Nursing, Other", add 
label define label_cipcode2 511802 "51.1802 - Optical Technician/Assistant", add 
label define label_cipcode2 512101 "51.2101 - Podiatry (DPM, DP, PodD)", add 
label define label_cipcode2 512303 "51.2303 - Hypnotherapy", add 
label define label_cipcode2 512308 "51.2308 - Physical Therapy", add 
label define label_cipcode2 512399 "51.2399 - Rehab/Therapeutic Svcs, Oth", add 
label define label_cipcode2 512601 "51.2601 - Health Aide", add 
label define label_cipcode2 512701 "51.2701 - Acupuncture & Oriental Med", add 
label define label_cipcode2 512702 "51.2702 - Medical Dietician", add 
label define label_cipcode2 519999 "51.9999 - Health Profes & Rel Sci, Oth", add 
label define label_cipcode2 520101 "52.0101 - Business, General", add 
label define label_cipcode2 520201 "52.0201 - Business Admin & Mgmt, Gen", add 
label define label_cipcode2 520204 "52.0204 - Office Supervision & Mgmt", add 
label define label_cipcode2 520299 "52.0299 - Business Admin & Mgmt, Oth", add 
label define label_cipcode2 520301 "52.0301 - Accounting", add 
label define label_cipcode2 520302 "52.0302 - Accounting Technician", add 
label define label_cipcode2 520399 "52.0399 - Accounting, Other", add 
label define label_cipcode2 520401 "52.0401 - Admin Asst/Sec Sci, Gen", add 
label define label_cipcode2 520402 "52.0402 - Executive Assistant/Secty", add 
label define label_cipcode2 520403 "52.0403 - Legal Admin Asst/Secretary", add 
label define label_cipcode2 520404 "52.0404 - Medical Admin Asst/Secretary", add 
label define label_cipcode2 520405 "52.0405 - Court Reporter", add 
label define label_cipcode2 520406 "52.0406 - Receptionist", add 
label define label_cipcode2 520407 "52.0407 - Info Process/Data Entry Tech", add 
label define label_cipcode2 520408 "52.0408 - Gen Office/Clerk/Typing Svcs", add 
label define label_cipcode2 520499 "52.0499 - Admin & Secretarial Svcs Oth", add 
label define label_cipcode2 520501 "52.0501 - Business Communications", add 
label define label_cipcode2 520801 "52.0801 - Finance, General", add 
label define label_cipcode2 520803 "52.0803 - Banking & Fin Support Svcs", add 
label define label_cipcode2 520805 "52.0805 - Insurance & Risk Management", add 
label define label_cipcode2 520901 "52.0901 - Hospitality/Admin Management", add 
label define label_cipcode2 520902 "52.0902 - Hotel/Motel/Restaurant Mgmt", add 
label define label_cipcode2 520903 "52.0903 - Travel-Tourism Management", add 
label define label_cipcode2 521201 "52.1201 - Mgt InfoSys/Bus DataProc Gen", add 
label define label_cipcode2 521202 "52.1202 - Business Computer Prog/Prog", add 
label define label_cipcode2 521204 "52.1204 - Bus Systems Network, Telecom", add 
label define label_cipcode2 521205 "52.1205 - Bus Computer Facilities Oper", add 
label define label_cipcode2 521299 "52.1299 - Bus Info & DataProc Svcs Oth", add 
label define label_cipcode2 521401 "52.1401 - Bus Marketing & Market Mgmt", add 
label define label_cipcode2 521402 "52.1402 - Marketing Research", add 
label define label_cipcode2 521501 "52.1501 - Real Estate", add 
label define label_cipcode2 529999 "52.9999 - Bus Mgmt & Admin Svcs, Other", add 
label values cipcode2 label_cipcode2
label define label_xciptui2 10 "Reported" 
label define label_xciptui2 11 "Analyst corrected reported value", add 
label define label_xciptui2 12 "Data generated from other data values", add 
label define label_xciptui2 13 "Implied zero", add 
label define label_xciptui2 14 "Data adjusted in scan edits", add 
label define label_xciptui2 15 "Data copied from another field", add 
label define label_xciptui2 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xciptui2 17 "Details are adjusted to sum to total", add 
label define label_xciptui2 18 "Total generated to equal the sum of detail", add 
label define label_xciptui2 20 "Imputed using data from prior year", add 
label define label_xciptui2 21 "Imputed using method other than prior year data", add 
label define label_xciptui2 30 "Not applicable", add 
label define label_xciptui2 31 "Original data field was not reported", add 
label define label_xciptui2 40 "Suppressed to protect confidentiality", add 
*label values xciptui2 label_xciptui2
label define label_xcipsup2 10 "Reported" 
label define label_xcipsup2 11 "Analyst corrected reported value", add 
label define label_xcipsup2 12 "Data generated from other data values", add 
label define label_xcipsup2 13 "Implied zero", add 
label define label_xcipsup2 14 "Data adjusted in scan edits", add 
label define label_xcipsup2 15 "Data copied from another field", add 
label define label_xcipsup2 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xcipsup2 17 "Details are adjusted to sum to total", add 
label define label_xcipsup2 18 "Total generated to equal the sum of detail", add 
label define label_xcipsup2 20 "Imputed using data from prior year", add 
label define label_xcipsup2 21 "Imputed using method other than prior year data", add 
label define label_xcipsup2 30 "Not applicable", add 
label define label_xcipsup2 31 "Original data field was not reported", add 
label define label_xcipsup2 40 "Suppressed to protect confidentiality", add 
*label values xcipsup2 label_xcipsup2
label define label_xciplgt2 10 "Reported" 
label define label_xciplgt2 11 "Analyst corrected reported value", add 
label define label_xciplgt2 12 "Data generated from other data values", add 
label define label_xciplgt2 13 "Implied zero", add 
label define label_xciplgt2 14 "Data adjusted in scan edits", add 
label define label_xciplgt2 15 "Data copied from another field", add 
label define label_xciplgt2 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xciplgt2 17 "Details are adjusted to sum to total", add 
label define label_xciplgt2 18 "Total generated to equal the sum of detail", add 
label define label_xciplgt2 20 "Imputed using data from prior year", add 
label define label_xciplgt2 21 "Imputed using method other than prior year data", add 
label define label_xciplgt2 30 "Not applicable", add 
label define label_xciplgt2 31 "Original data field was not reported", add 
label define label_xciplgt2 40 "Suppressed to protect confidentiality", add 
*label values xciplgt2 label_xciplgt2
label define label_cipcode3 -1 "-1 - {Not reported}" 
label define label_cipcode3 -2 "-2 - {Item not applicable}", add 
label define label_cipcode3 10104 "01.0104 - Farm & Ranch Management", add 
label define label_cipcode3 10505 "01.0505 - Animal Trainer", add 
label define label_cipcode3 10507 "01.0507 - Equine Stud, Horse Mgmt/Trng", add 
label define label_cipcode3 10599 "01.0599 - Agri Supplies, Rel Svcs Oth", add 
label define label_cipcode3 30501 "03.0501 - Forestry, General", add 
label define label_cipcode3 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode3 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode3 80503 "08.0503 - Floristry Marketing Opers", add 
label define label_cipcode3 80708 "08.0708 - General Marketing Operations", add 
label define label_cipcode3 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode3 81105 "08.1105 - Travel Svcs Marketing Oper", add 
label define label_cipcode3 81199 "08.1199 - Tour/Travel Svcs Mktg Op Oth", add 
label define label_cipcode3 90101 "09.0101 - Communications, General", add 
label define label_cipcode3 90201 "09.0201 - Advertising", add 
label define label_cipcode3 90701 "09.0701 - Radio & TV Broadcasting", add 
label define label_cipcode3 99999 "09.9999 - Communications, Other", add 
label define label_cipcode3 100104 "10.0104 - Radio/TV Broadcast Tech/Tech", add 
label define label_cipcode3 100199 "10.0199 - Communications Tech/Tech Oth", add 
label define label_cipcode3 110101 "11.0101 - Computer & Info Science, Gen", add 
label define label_cipcode3 110201 "11.0201 - Computer Programming", add 
label define label_cipcode3 110301 "11.0301 - Data Processing Tech/Tech", add 
label define label_cipcode3 110401 "11.0401 - Information Sci & Systems", add 
label define label_cipcode3 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode3 110701 "11.0701 - Computer Science", add 
label define label_cipcode3 119999 "11.9999 - Computer & Info Science, Oth", add 
label define label_cipcode3 120203 "12.0203 - Card Dealer", add 
label define label_cipcode3 120299 "12.0299 - Gaming/Sports Offic Svcs Oth", add 
label define label_cipcode3 120301 "12.0301 - Funeral Svcs & Mortuary Sci", add 
label define label_cipcode3 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode3 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode3 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode3 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode3 120405 "12.0405 - Massage", add 
label define label_cipcode3 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode3 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode3 120501 "12.0501 - Baker/Pastry Chef", add 
label define label_cipcode3 120503 "12.0503 - Culinary Arts/Chef Training", add 
label define label_cipcode3 120504 "12.0504 - Food & Bev/Restaurant Op Mgr", add 
label define label_cipcode3 120505 "12.0505 - Kitchen Pers/Cook & Asst Trg", add 
label define label_cipcode3 120506 "12.0506 - Meatcutter", add 
label define label_cipcode3 120599 "12.0599 - Culinary Arts/Rel Svcs, Oth", add 
label define label_cipcode3 129999 "12.9999 - Personal & Misc Svcs, Other", add 
label define label_cipcode3 130401 "13.0401 - Educ Admin & Supervis, Gen", add 
label define label_cipcode3 131205 "13.1205 - Secondary Teacher Education", add 
label define label_cipcode3 131206 "13.1206 - Teacher Ed, Multiple Levels", add 
label define label_cipcode3 131299 "13.1299 - General Teacher Ed, Other", add 
label define label_cipcode3 131319 "13.1319 - Technical Teacher Ed (Voc)", add 
label define label_cipcode3 131399 "13.1399 - Tchr Ed, Acad/Voc Pgms, Oth", add 
label define label_cipcode3 131501 "13.1501 - Teacher Assistant/Aide", add 
label define label_cipcode3 139999 "13.9999 - Education, Other", add 
label define label_cipcode3 140901 "14.0901 - Computer Engineering", add 
label define label_cipcode3 141901 "14.1901 - Mechanical Engineering", add 
label define label_cipcode3 149999 "14.9999 - Engineering, Other", add 
label define label_cipcode3 150201 "15.0201 - Civil Eng/Civil Tech/Tech", add 
label define label_cipcode3 150301 "15.0301 - Computer Eng Tech/Tech", add 
label define label_cipcode3 150303 "15.0303 - Elect/Electron/Comm Eng T/T", add 
label define label_cipcode3 150399 "15.0399 - Elect/Elect Eng-Rel T/T Oth", add 
label define label_cipcode3 150402 "15.0402 - Computer Maint Tech/Tech", add 
label define label_cipcode3 150403 "15.0403 - Electromechanical Tech/Tech", add 
label define label_cipcode3 150501 "15.0501 - Heating/AC/Refrig Tech/Tech", add 
label define label_cipcode3 150507 "15.0507 - Environ & Pollution Ctrl T/T", add 
label define label_cipcode3 150603 "15.0603 - Industrial/Manuf Tech/Tech", add 
label define label_cipcode3 150607 "15.0607 - Plastics Technology/Tech", add 
label define label_cipcode3 150799 "15.0799 - Quality Ctrl/Safety T/T, Oth", add 
label define label_cipcode3 150801 "15.0801 - Aeronaut/Aerospace Eng T/T", add 
label define label_cipcode3 151101 "15.1101 - Engineering-Related T/T Gen", add 
label define label_cipcode3 190699 "19.0699 - Housing Studies, Other", add 
label define label_cipcode3 200201 "20.0201 - Child Care/Guide Wkr/Mgr Gen", add 
label define label_cipcode3 200202 "20.0202 - Child Care Provider/Asst", add 
label define label_cipcode3 200303 "20.0303 - Commercial Garment & App Wkr", add 
label define label_cipcode3 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode3 200399 "20.0399 - Clothng/App/Txtl Wkr/Mgr Oth", add 
label define label_cipcode3 200401 "20.0401 - Institution Food Wkr/Adm Gen", add 
label define label_cipcode3 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode3 200606 "20.0606 - Homemakers Aide", add 
label define label_cipcode3 209999 "20.9999 - Vocational Home Ec, Other", add 
label define label_cipcode3 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode3 269999 "26.9999 - Biological Sci/Life Sci, Oth", add 
label define label_cipcode3 310301 "31.0301 - Parks/Rec/Leisure Facils Mgt", add 
label define label_cipcode3 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode3 390301 "39.0301 - Missions/Miss Studs/Misology", add 
label define label_cipcode3 390699 "39.0699 - Theol/Ministerial Studs Oth", add 
label define label_cipcode3 390701 "39.0701 - Pastoral Counsel/Spec Minist", add 
label define label_cipcode3 400699 "40.0699 - Geological & Rel Sci, Other", add 
label define label_cipcode3 400702 "40.0702 - Oceanography", add 
label define label_cipcode3 430103 "43.0103 - Crim Justice/Law Enforce Adm", add 
label define label_cipcode3 430104 "43.0104 - Criminal Justice Studies", add 
label define label_cipcode3 430107 "43.0107 - Law Enforcement/Police Sci", add 
label define label_cipcode3 430109 "43.0109 - Security & Loss Prevent Svcs", add 
label define label_cipcode3 430201 "43.0201 - Fire Protection/Safety T/T", add 
label define label_cipcode3 430203 "43.0203 - Fire Science/Firefighting", add 
label define label_cipcode3 460201 "46.0201 - Carpenter", add 
label define label_cipcode3 460302 "46.0302 - Electrician", add 
label define label_cipcode3 460399 "46.0399 - Elec/Power Trans Install Oth", add 
label define label_cipcode3 460401 "46.0401 - Building/Property Maint/Mgr", add 
label define label_cipcode3 460501 "46.0501 - Plumber & Pipefitter", add 
label define label_cipcode3 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode3 470101 "47.0101 - Elect/El Equip Inst/Rep Gen", add 
label define label_cipcode3 470104 "47.0104 - Computer Install & Repair", add 
label define label_cipcode3 470105 "47.0105 - Indust Electron Install/Rep", add 
label define label_cipcode3 470199 "47.0199 - Elect/El Equip Inst/Rep Oth", add 
label define label_cipcode3 470201 "47.0201 - Heating/AC/Refrig Mech/Rep", add 
label define label_cipcode3 470302 "47.0302 - Heavy Equip Maint/Repair", add 
label define label_cipcode3 470303 "47.0303 - Indust Machine Maint/Repair", add 
label define label_cipcode3 470399 "47.0399 - Indust Equip Maint/Rep, Oth", add 
label define label_cipcode3 470402 "47.0402 - Gunsmith", add 
label define label_cipcode3 470404 "47.0404 - Musical Instrument Repair", add 
label define label_cipcode3 470408 "47.0408 - Watch/Clock/Jewelry Repair", add 
label define label_cipcode3 470499 "47.0499 - Misc Mechanics & Repair, Oth", add 
label define label_cipcode3 470501 "47.0501 - Stat Energy Srcs Instal/Oper", add 
label define label_cipcode3 470603 "47.0603 - Auto/Automotive Body Repair", add 
label define label_cipcode3 470604 "47.0604 - Auto/Automotive Mech/Tech", add 
label define label_cipcode3 470605 "47.0605 - Diesel Engine Mech/Repair", add 
label define label_cipcode3 470608 "47.0608 - Aircraft Mech/Tech, Powrplnt", add 
label define label_cipcode3 470609 "47.0609 - Aviation Sys/Avionics T/T", add 
label define label_cipcode3 470611 "47.0611 - Motorcycle Mechanic & Repair", add 
label define label_cipcode3 479999 "47.9999 - Mechanics & Repairers, Other", add 
label define label_cipcode3 480101 "48.0101 - Drafting, General", add 
label define label_cipcode3 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode3 480104 "48.0104 - Electrical/Electron Drafting", add 
label define label_cipcode3 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode3 480208 "48.0208 - Printing Press Operator", add 
label define label_cipcode3 480211 "48.0211 - Computer Typo/Compo Equip Op", add 
label define label_cipcode3 480212 "48.0212 - Desktop Publishing Equip Op", add 
label define label_cipcode3 480501 "48.0501 - Machinist/Machine Tech", add 
label define label_cipcode3 480506 "48.0506 - Sheet Metal Worker", add 
label define label_cipcode3 480507 "48.0507 - Tool & Die Maker/Tech", add 
label define label_cipcode3 480508 "48.0508 - Welder/Welding Tech", add 
label define label_cipcode3 490101 "49.0101 - Aviation & Airway Science", add 
label define label_cipcode3 490102 "49.0102 - Aircraft Pilot & Nav (Prof)", add 
label define label_cipcode3 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode3 490199 "49.0199 - Air Transportation Wkrs, Oth", add 
label define label_cipcode3 490205 "49.0205 - Truck, Bus, Comm Vehicle Op", add 
label define label_cipcode3 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode3 490306 "49.0306 - Marine Maint & Ship Repairer", add 
label define label_cipcode3 490309 "49.0309 - Marine Sci/Merch Marine Ofc", add 
label define label_cipcode3 490399 "49.0399 - Water Transport Workers, Oth", add 
label define label_cipcode3 499999 "49.9999 - Trans & Mat Moving Wkrs, Oth", add 
label define label_cipcode3 500401 "50.0401 - Design/Visual Communications", add 
label define label_cipcode3 500402 "50.0402 - Graphic Des/Comm Art/Illust", add 
label define label_cipcode3 500407 "50.0407 - Fashion Design & Illust", add 
label define label_cipcode3 500408 "50.0408 - Interior Design", add 
label define label_cipcode3 500499 "50.0499 - Design & Applied Arts, Oth", add 
label define label_cipcode3 500503 "50.0503 - Acting & Directing", add 
label define label_cipcode3 500602 "50.0602 - Film/Video/Cinematog & Prod", add 
label define label_cipcode3 500605 "50.0605 - Photography", add 
label define label_cipcode3 500699 "50.0699 - Film/Video/Photog Arts, Oth", add 
label define label_cipcode3 500701 "50.0701 - Art, General", add 
label define label_cipcode3 500713 "50.0713 - Metal & Jewelry Arts", add 
label define label_cipcode3 500799 "50.0799 - Fine Arts & Art Studies, Oth", add 
label define label_cipcode3 500903 "50.0903 - Music-General Performance", add 
label define label_cipcode3 509999 "50.9999 - Visual & Performing Arts Oth", add 
label define label_cipcode3 510401 "51.0401 - Dentistry (DDS, DMD)", add 
label define label_cipcode3 510601 "51.0601 - Dental Assistant", add 
label define label_cipcode3 510603 "51.0603 - Dental Laboratory Technician", add 
label define label_cipcode3 510701 "51.0701 - Health Sys/Health Svcs Admin", add 
label define label_cipcode3 510703 "51.0703 - Health Unit Coord/Ward Clerk", add 
label define label_cipcode3 510705 "51.0705 - Medical Office Management", add 
label define label_cipcode3 510706 "51.0706 - Medical Records Admin", add 
label define label_cipcode3 510707 "51.0707 - Medical Records Tech/Tech", add 
label define label_cipcode3 510708 "51.0708 - Medical Transcription", add 
label define label_cipcode3 510799 "51.0799 - Health & Med Admin Svcs, Oth", add 
label define label_cipcode3 510801 "51.0801 - Medical Assistant", add 
label define label_cipcode3 510802 "51.0802 - Medical Laboratory Assistant", add 
label define label_cipcode3 510803 "51.0803 - Occupational Therapy Asst", add 
label define label_cipcode3 510805 "51.0805 - Pharmacy Technician/Asst", add 
label define label_cipcode3 510899 "51.0899 - Health & Medical Assts, Oth", add 
label define label_cipcode3 510901 "51.0901 - Cardiovascular Tech/Tech", add 
label define label_cipcode3 510902 "51.0902 - Electrocardiograph Tech/Tech", add 
label define label_cipcode3 510904 "51.0904 - Emergency Medicine Tech/Tech", add 
label define label_cipcode3 510905 "51.0905 - Nuclear Medicine Tech/Tech", add 
label define label_cipcode3 510907 "51.0907 - Medical Radiologic Tech/Tech", add 
label define label_cipcode3 510908 "51.0908 - Respiratory Therapy Tech", add 
label define label_cipcode3 510909 "51.0909 - Surgical/Operating Room Tech", add 
label define label_cipcode3 510910 "51.0910 - Diagnostic Med Sonography", add 
label define label_cipcode3 510999 "51.0999 - Health/Med Diag/Tx Svcs Oth", add 
label define label_cipcode3 511001 "51.1001 - Blood Bank Technology/Tech", add 
label define label_cipcode3 511003 "51.1003 - Hematology Technology/Tech", add 
label define label_cipcode3 511004 "51.1004 - Medical Laboratory Tech", add 
label define label_cipcode3 511005 "51.1005 - Medical Technology", add 
label define label_cipcode3 511006 "51.1006 - Optometric/Ophthal Lab Tech", add 
label define label_cipcode3 511099 "51.1099 - Health/Med Lab Tech/Tech Oth", add 
label define label_cipcode3 511501 "51.1501 - Alcohol/Drug Abuse Couns", add 
label define label_cipcode3 511613 "51.1613 - Practical Nurse (LPN Train)", add 
label define label_cipcode3 511614 "51.1614 - Nurse Assistant/Aide", add 
label define label_cipcode3 511615 "51.1615 - UK", add 
label define label_cipcode3 511699 "51.1699 - Nursing, Other", add 
label define label_cipcode3 512001 "51.2001 - Pharmacy (BPharm, PharmD)", add 
label define label_cipcode3 512303 "51.2303 - Hypnotherapy", add 
label define label_cipcode3 512306 "51.2306 - Occupational Therapy", add 
label define label_cipcode3 512308 "51.2308 - Physical Therapy", add 
label define label_cipcode3 512399 "51.2399 - Rehab/Therapeutic Svcs, Oth", add 
label define label_cipcode3 512601 "51.2601 - Health Aide", add 
label define label_cipcode3 512701 "51.2701 - Acupuncture & Oriental Med", add 
label define label_cipcode3 519999 "51.9999 - Health Profes & Rel Sci, Oth", add 
label define label_cipcode3 520101 "52.0101 - Business, General", add 
label define label_cipcode3 520201 "52.0201 - Business Admin & Mgmt, Gen", add 
label define label_cipcode3 520299 "52.0299 - Business Admin & Mgmt, Oth", add 
label define label_cipcode3 520301 "52.0301 - Accounting", add 
label define label_cipcode3 520302 "52.0302 - Accounting Technician", add 
label define label_cipcode3 520399 "52.0399 - Accounting, Other", add 
label define label_cipcode3 520401 "52.0401 - Admin Asst/Sec Sci, Gen", add 
label define label_cipcode3 520402 "52.0402 - Executive Assistant/Secty", add 
label define label_cipcode3 520403 "52.0403 - Legal Admin Asst/Secretary", add 
label define label_cipcode3 520404 "52.0404 - Medical Admin Asst/Secretary", add 
label define label_cipcode3 520405 "52.0405 - Court Reporter", add 
label define label_cipcode3 520407 "52.0407 - Info Process/Data Entry Tech", add 
label define label_cipcode3 520408 "52.0408 - Gen Office/Clerk/Typing Svcs", add 
label define label_cipcode3 520499 "52.0499 - Admin & Secretarial Svcs Oth", add 
label define label_cipcode3 520803 "52.0803 - Banking & Fin Support Svcs", add 
label define label_cipcode3 520805 "52.0805 - Insurance & Risk Management", add 
label define label_cipcode3 520807 "52.0807 - Investments & Securities", add 
label define label_cipcode3 520901 "52.0901 - Hospitality/Admin Management", add 
label define label_cipcode3 520902 "52.0902 - Hotel/Motel/Restaurant Mgmt", add 
label define label_cipcode3 520903 "52.0903 - Travel-Tourism Management", add 
label define label_cipcode3 520999 "52.0999 - Hospitality Svcs Mgmt, Other", add 
label define label_cipcode3 521101 "52.1101 - International Business", add 
label define label_cipcode3 521201 "52.1201 - Mgt InfoSys/Bus DataProc Gen", add 
label define label_cipcode3 521202 "52.1202 - Business Computer Prog/Prog", add 
label define label_cipcode3 521204 "52.1204 - Bus Systems Network, Telecom", add 
label define label_cipcode3 521205 "52.1205 - Bus Computer Facilities Oper", add 
label define label_cipcode3 521299 "52.1299 - Bus Info & DataProc Svcs Oth", add 
label define label_cipcode3 521401 "52.1401 - Bus Marketing & Market Mgmt", add 
label define label_cipcode3 521499 "52.1499 - Marketing Mgmt, Research Oth", add 
label define label_cipcode3 521501 "52.1501 - Real Estate", add 
label define label_cipcode3 529999 "52.9999 - Bus Mgmt & Admin Svcs, Other", add 
label values cipcode3 label_cipcode3
label define label_xciptui3 10 "Reported" 
label define label_xciptui3 11 "Analyst corrected reported value", add 
label define label_xciptui3 12 "Data generated from other data values", add 
label define label_xciptui3 13 "Implied zero", add 
label define label_xciptui3 14 "Data adjusted in scan edits", add 
label define label_xciptui3 15 "Data copied from another field", add 
label define label_xciptui3 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xciptui3 17 "Details are adjusted to sum to total", add 
label define label_xciptui3 18 "Total generated to equal the sum of detail", add 
label define label_xciptui3 20 "Imputed using data from prior year", add 
label define label_xciptui3 21 "Imputed using method other than prior year data", add 
label define label_xciptui3 30 "Not applicable", add 
label define label_xciptui3 31 "Original data field was not reported", add 
label define label_xciptui3 40 "Suppressed to protect confidentiality", add 
*label values xciptui3 label_xciptui3
label define label_xcipsup3 10 "Reported" 
label define label_xcipsup3 11 "Analyst corrected reported value", add 
label define label_xcipsup3 12 "Data generated from other data values", add 
label define label_xcipsup3 13 "Implied zero", add 
label define label_xcipsup3 14 "Data adjusted in scan edits", add 
label define label_xcipsup3 15 "Data copied from another field", add 
label define label_xcipsup3 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xcipsup3 17 "Details are adjusted to sum to total", add 
label define label_xcipsup3 18 "Total generated to equal the sum of detail", add 
label define label_xcipsup3 20 "Imputed using data from prior year", add 
label define label_xcipsup3 21 "Imputed using method other than prior year data", add 
label define label_xcipsup3 30 "Not applicable", add 
label define label_xcipsup3 31 "Original data field was not reported", add 
label define label_xcipsup3 40 "Suppressed to protect confidentiality", add 
*label values xcipsup3 label_xcipsup3
label define label_xciplgt3 10 "Reported" 
label define label_xciplgt3 11 "Analyst corrected reported value", add 
label define label_xciplgt3 12 "Data generated from other data values", add 
label define label_xciplgt3 13 "Implied zero", add 
label define label_xciplgt3 14 "Data adjusted in scan edits", add 
label define label_xciplgt3 15 "Data copied from another field", add 
label define label_xciplgt3 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xciplgt3 17 "Details are adjusted to sum to total", add 
label define label_xciplgt3 18 "Total generated to equal the sum of detail", add 
label define label_xciplgt3 20 "Imputed using data from prior year", add 
label define label_xciplgt3 21 "Imputed using method other than prior year data", add 
label define label_xciplgt3 30 "Not applicable", add 
label define label_xciplgt3 31 "Original data field was not reported", add 
label define label_xciplgt3 40 "Suppressed to protect confidentiality", add 
*label values xciplgt3 label_xciplgt3
label define label_cipcode4 -1 "-1 - {Not reported}" 
label define label_cipcode4 -2 "-2 - {Item not applicable}", add 
label define label_cipcode4 10104 "01.0104 - Farm & Ranch Management", add 
label define label_cipcode4 10507 "01.0507 - Equine Stud, Horse Mgmt/Trng", add 
label define label_cipcode4 10599 "01.0599 - Agri Supplies, Rel Svcs Oth", add 
label define label_cipcode4 20301 "02.0301 - Food Sciences & Technology", add 
label define label_cipcode4 30501 "03.0501 - Forestry, General", add 
label define label_cipcode4 30601 "03.0601 - Wildlife & Wildlands Mgmt", add 
label define label_cipcode4 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode4 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode4 80401 "08.0401 - Financial Svcs Marketing Op", add 
label define label_cipcode4 80503 "08.0503 - Floristry Marketing Opers", add 
label define label_cipcode4 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode4 80901 "08.0901 - Hospitality, Rec Mktg Op Gen", add 
label define label_cipcode4 81105 "08.1105 - Travel Svcs Marketing Oper", add 
label define label_cipcode4 81199 "08.1199 - Tour/Travel Svcs Mktg Op Oth", add 
label define label_cipcode4 100104 "10.0104 - Radio/TV Broadcast Tech/Tech", add 
label define label_cipcode4 100199 "10.0199 - Communications Tech/Tech Oth", add 
label define label_cipcode4 110101 "11.0101 - Computer & Info Science, Gen", add 
label define label_cipcode4 110201 "11.0201 - Computer Programming", add 
label define label_cipcode4 110301 "11.0301 - Data Processing Tech/Tech", add 
label define label_cipcode4 110401 "11.0401 - Information Sci & Systems", add 
label define label_cipcode4 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode4 110701 "11.0701 - Computer Science", add 
label define label_cipcode4 119999 "11.9999 - Computer & Info Science, Oth", add 
label define label_cipcode4 120203 "12.0203 - Card Dealer", add 
label define label_cipcode4 120299 "12.0299 - Gaming/Sports Offic Svcs Oth", add 
label define label_cipcode4 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode4 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode4 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode4 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode4 120405 "12.0405 - Massage", add 
label define label_cipcode4 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode4 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode4 120501 "12.0501 - Baker/Pastry Chef", add 
label define label_cipcode4 120503 "12.0503 - Culinary Arts/Chef Training", add 
label define label_cipcode4 120504 "12.0504 - Food & Bev/Restaurant Op Mgr", add 
label define label_cipcode4 120599 "12.0599 - Culinary Arts/Rel Svcs, Oth", add 
label define label_cipcode4 129999 "12.9999 - Personal & Misc Svcs, Other", add 
label define label_cipcode4 131206 "13.1206 - Teacher Ed, Multiple Levels", add 
label define label_cipcode4 131299 "13.1299 - General Teacher Ed, Other", add 
label define label_cipcode4 131319 "13.1319 - Technical Teacher Ed (Voc)", add 
label define label_cipcode4 140901 "14.0901 - Computer Engineering", add 
label define label_cipcode4 141001 "14.1001 - Elect, Electron & Comm Eng", add 
label define label_cipcode4 150101 "15.0101 - Architectural Eng Tech/Tech", add 
label define label_cipcode4 150201 "15.0201 - Civil Eng/Civil Tech/Tech", add 
label define label_cipcode4 150301 "15.0301 - Computer Eng Tech/Tech", add 
label define label_cipcode4 150303 "15.0303 - Elect/Electron/Comm Eng T/T", add 
label define label_cipcode4 150399 "15.0399 - Elect/Elect Eng-Rel T/T Oth", add 
label define label_cipcode4 150402 "15.0402 - Computer Maint Tech/Tech", add 
label define label_cipcode4 150404 "15.0404 - Instrumentation Tech/Tech", add 
label define label_cipcode4 150405 "15.0405 - Robotics Technology/Tech", add 
label define label_cipcode4 150501 "15.0501 - Heating/AC/Refrig Tech/Tech", add 
label define label_cipcode4 150503 "15.0503 - Energy Mgmt & Sys Tech/Tech", add 
label define label_cipcode4 150702 "15.0702 - Quality Control Tech/Tech", add 
label define label_cipcode4 150799 "15.0799 - Quality Ctrl/Safety T/T, Oth", add 
label define label_cipcode4 150801 "15.0801 - Aeronaut/Aerospace Eng T/T", add 
label define label_cipcode4 151001 "15.1001 - Construction/Bldg Tech/Tech", add 
label define label_cipcode4 151101 "15.1101 - Engineering-Related T/T Gen", add 
label define label_cipcode4 190701 "19.0701 - Indiv/Fam Develop Studs Gen", add 
label define label_cipcode4 200201 "20.0201 - Child Care/Guide Wkr/Mgr Gen", add 
label define label_cipcode4 200202 "20.0202 - Child Care Provider/Asst", add 
label define label_cipcode4 200303 "20.0303 - Commercial Garment & App Wkr", add 
label define label_cipcode4 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode4 200399 "20.0399 - Clothng/App/Txtl Wkr/Mgr Oth", add 
label define label_cipcode4 200601 "20.0601 - Cust/Hskpg Svcs Wkr/Mgr Gen", add 
label define label_cipcode4 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode4 220102 "22.0102 - Pre-Law Studies", add 
label define label_cipcode4 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode4 220199 "22.0199 - Law & Legal Studies, Other", add 
label define label_cipcode4 230101 "23.0101 - English Language/Lit, Gen", add 
label define label_cipcode4 269999 "26.9999 - Biological Sci/Life Sci, Oth", add 
label define label_cipcode4 390101 "39.0101 - Biblical, Oth Theol Lang/Lit", add 
label define label_cipcode4 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode4 400699 "40.0699 - Geological & Rel Sci, Other", add 
label define label_cipcode4 400702 "40.0702 - Oceanography", add 
label define label_cipcode4 410301 "41.0301 - Chemical Technology/Tech", add 
label define label_cipcode4 420201 "42.0201 - UK", add 
label define label_cipcode4 430107 "43.0107 - Law Enforcement/Police Sci", add 
label define label_cipcode4 430199 "43.0199 - Crim Justice & Correct, Oth", add 
label define label_cipcode4 430203 "43.0203 - Fire Science/Firefighting", add 
label define label_cipcode4 460201 "46.0201 - Carpenter", add 
label define label_cipcode4 460301 "46.0301 - Elec/Power Trans Install Gen", add 
label define label_cipcode4 460302 "46.0302 - Electrician", add 
label define label_cipcode4 460399 "46.0399 - Elec/Power Trans Install Oth", add 
label define label_cipcode4 460401 "46.0401 - Building/Property Maint/Mgr", add 
label define label_cipcode4 460499 "46.0499 - Construct/Bldg Finish/Mgr Ot", add 
label define label_cipcode4 460501 "46.0501 - Plumber & Pipefitter", add 
label define label_cipcode4 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode4 470101 "47.0101 - Elect/El Equip Inst/Rep Gen", add 
label define label_cipcode4 470103 "47.0103 - Commun Systems Inst & Repair", add 
label define label_cipcode4 470104 "47.0104 - Computer Install & Repair", add 
label define label_cipcode4 470105 "47.0105 - Indust Electron Install/Rep", add 
label define label_cipcode4 470199 "47.0199 - Elect/El Equip Inst/Rep Oth", add 
label define label_cipcode4 470201 "47.0201 - Heating/AC/Refrig Mech/Rep", add 
label define label_cipcode4 470303 "47.0303 - Indust Machine Maint/Repair", add 
label define label_cipcode4 470399 "47.0399 - Indust Equip Maint/Rep, Oth", add 
label define label_cipcode4 470402 "47.0402 - Gunsmith", add 
label define label_cipcode4 470408 "47.0408 - Watch/Clock/Jewelry Repair", add 
label define label_cipcode4 470603 "47.0603 - Auto/Automotive Body Repair", add 
label define label_cipcode4 470604 "47.0604 - Auto/Automotive Mech/Tech", add 
label define label_cipcode4 470605 "47.0605 - Diesel Engine Mech/Repair", add 
label define label_cipcode4 470606 "47.0606 - Small Engine Mech/Repair", add 
label define label_cipcode4 470607 "47.0607 - Aircraft Mech/Tech, Airframe", add 
label define label_cipcode4 470608 "47.0608 - Aircraft Mech/Tech, Powrplnt", add 
label define label_cipcode4 470609 "47.0609 - Aviation Sys/Avionics T/T", add 
label define label_cipcode4 470611 "47.0611 - Motorcycle Mechanic & Repair", add 
label define label_cipcode4 470699 "47.0699 - Veh/Mobil Equip Mech/Rep Oth", add 
label define label_cipcode4 480101 "48.0101 - Drafting, General", add 
label define label_cipcode4 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode4 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode4 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode4 480201 "48.0201 - Graphic/Print Equip Oper Gen", add 
label define label_cipcode4 480212 "48.0212 - Desktop Publishing Equip Op", add 
label define label_cipcode4 480299 "48.0299 - Graphic/Print Equip Oper Oth", add 
label define label_cipcode4 480399 "48.0399 - Leatherwrkrs & Upholster Oth", add 
label define label_cipcode4 480501 "48.0501 - Machinist/Machine Tech", add 
label define label_cipcode4 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode4 480506 "48.0506 - Sheet Metal Worker", add 
label define label_cipcode4 480507 "48.0507 - Tool & Die Maker/Tech", add 
label define label_cipcode4 480508 "48.0508 - Welder/Welding Tech", add 
label define label_cipcode4 490101 "49.0101 - Aviation & Airway Science", add 
label define label_cipcode4 490102 "49.0102 - Aircraft Pilot & Nav (Prof)", add 
label define label_cipcode4 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode4 490199 "49.0199 - Air Transportation Wkrs, Oth", add 
label define label_cipcode4 490205 "49.0205 - Truck, Bus, Comm Vehicle Op", add 
label define label_cipcode4 490299 "49.0299 - Vehicle & Equip Opers, Oth", add 
label define label_cipcode4 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode4 490309 "49.0309 - Marine Sci/Merch Marine Ofc", add 
label define label_cipcode4 490399 "49.0399 - Water Transport Workers, Oth", add 
label define label_cipcode4 499999 "49.9999 - Trans & Mat Moving Wkrs, Oth", add 
label define label_cipcode4 500401 "50.0401 - Design/Visual Communications", add 
label define label_cipcode4 500402 "50.0402 - Graphic Des/Comm Art/Illust", add 
label define label_cipcode4 500407 "50.0407 - Fashion Design & Illust", add 
label define label_cipcode4 500408 "50.0408 - Interior Design", add 
label define label_cipcode4 500602 "50.0602 - Film/Video/Cinematog & Prod", add 
label define label_cipcode4 500605 "50.0605 - Photography", add 
label define label_cipcode4 500699 "50.0699 - Film/Video/Photog Arts, Oth", add 
label define label_cipcode4 500713 "50.0713 - Metal & Jewelry Arts", add 
label define label_cipcode4 500903 "50.0903 - Music-General Performance", add 
label define label_cipcode4 510601 "51.0601 - Dental Assistant", add 
label define label_cipcode4 510603 "51.0603 - Dental Laboratory Technician", add 
label define label_cipcode4 510699 "51.0699 - Dental Services, Other", add 
label define label_cipcode4 510701 "51.0701 - Health Sys/Health Svcs Admin", add 
label define label_cipcode4 510703 "51.0703 - Health Unit Coord/Ward Clerk", add 
label define label_cipcode4 510704 "51.0704 - Health Unit Mgr/Ward Supv", add 
label define label_cipcode4 510705 "51.0705 - Medical Office Management", add 
label define label_cipcode4 510706 "51.0706 - Medical Records Admin", add 
label define label_cipcode4 510707 "51.0707 - Medical Records Tech/Tech", add 
label define label_cipcode4 510708 "51.0708 - Medical Transcription", add 
label define label_cipcode4 510799 "51.0799 - Health & Med Admin Svcs, Oth", add 
label define label_cipcode4 510801 "51.0801 - Medical Assistant", add 
label define label_cipcode4 510802 "51.0802 - Medical Laboratory Assistant", add 
label define label_cipcode4 510804 "51.0804 - Ophthalmic Medical Assistant", add 
label define label_cipcode4 510805 "51.0805 - Pharmacy Technician/Asst", add 
label define label_cipcode4 510806 "51.0806 - Physical Therapy Assistant", add 
label define label_cipcode4 510807 "51.0807 - Physician Assistant", add 
label define label_cipcode4 510899 "51.0899 - Health & Medical Assts, Oth", add 
label define label_cipcode4 510901 "51.0901 - Cardiovascular Tech/Tech", add 
label define label_cipcode4 510902 "51.0902 - Electrocardiograph Tech/Tech", add 
label define label_cipcode4 510904 "51.0904 - Emergency Medicine Tech/Tech", add 
label define label_cipcode4 510907 "51.0907 - Medical Radiologic Tech/Tech", add 
label define label_cipcode4 510908 "51.0908 - Respiratory Therapy Tech", add 
label define label_cipcode4 510909 "51.0909 - Surgical/Operating Room Tech", add 
label define label_cipcode4 510910 "51.0910 - Diagnostic Med Sonography", add 
label define label_cipcode4 510999 "51.0999 - Health/Med Diag/Tx Svcs Oth", add 
label define label_cipcode4 511004 "51.1004 - Medical Laboratory Tech", add 
label define label_cipcode4 511005 "51.1005 - Medical Technology", add 
label define label_cipcode4 511099 "51.1099 - Health/Med Lab Tech/Tech Oth", add 
label define label_cipcode4 511199 "51.1199 - Health & Med Prep Pgms, Oth", add 
label define label_cipcode4 511502 "51.1502 - Psych/Mental Health Svc Tech", add 
label define label_cipcode4 511605 "51.1605 - Nursing Family Pract(PostRN)", add 
label define label_cipcode4 511613 "51.1613 - Practical Nurse (LPN Train)", add 
label define label_cipcode4 511614 "51.1614 - Nurse Assistant/Aide", add 
label define label_cipcode4 511615 "51.1615 - UK", add 
label define label_cipcode4 511699 "51.1699 - Nursing, Other", add 
label define label_cipcode4 511802 "51.1802 - Optical Technician/Assistant", add 
label define label_cipcode4 511803 "51.1803 - Ophthalmic Medical Tech", add 
label define label_cipcode4 512099 "51.2099 - Pharmacy, Other", add 
label define label_cipcode4 512399 "51.2399 - Rehab/Therapeutic Svcs, Oth", add 
label define label_cipcode4 512601 "51.2601 - Health Aide", add 
label define label_cipcode4 512704 "51.2704 - Naturopathic Medicine", add 
label define label_cipcode4 519999 "51.9999 - Health Profes & Rel Sci, Oth", add 
label define label_cipcode4 520101 "52.0101 - Business, General", add 
label define label_cipcode4 520201 "52.0201 - Business Admin & Mgmt, Gen", add 
label define label_cipcode4 520204 "52.0204 - Office Supervision & Mgmt", add 
label define label_cipcode4 520299 "52.0299 - Business Admin & Mgmt, Oth", add 
label define label_cipcode4 520301 "52.0301 - Accounting", add 
label define label_cipcode4 520302 "52.0302 - Accounting Technician", add 
label define label_cipcode4 520399 "52.0399 - Accounting, Other", add 
label define label_cipcode4 520401 "52.0401 - Admin Asst/Sec Sci, Gen", add 
label define label_cipcode4 520402 "52.0402 - Executive Assistant/Secty", add 
label define label_cipcode4 520403 "52.0403 - Legal Admin Asst/Secretary", add 
label define label_cipcode4 520404 "52.0404 - Medical Admin Asst/Secretary", add 
label define label_cipcode4 520405 "52.0405 - Court Reporter", add 
label define label_cipcode4 520406 "52.0406 - Receptionist", add 
label define label_cipcode4 520407 "52.0407 - Info Process/Data Entry Tech", add 
label define label_cipcode4 520408 "52.0408 - Gen Office/Clerk/Typing Svcs", add 
label define label_cipcode4 520499 "52.0499 - Admin & Secretarial Svcs Oth", add 
label define label_cipcode4 520501 "52.0501 - Business Communications", add 
label define label_cipcode4 520803 "52.0803 - Banking & Fin Support Svcs", add 
label define label_cipcode4 520805 "52.0805 - Insurance & Risk Management", add 
label define label_cipcode4 520901 "52.0901 - Hospitality/Admin Management", add 
label define label_cipcode4 520902 "52.0902 - Hotel/Motel/Restaurant Mgmt", add 
label define label_cipcode4 520903 "52.0903 - Travel-Tourism Management", add 
label define label_cipcode4 521101 "52.1101 - International Business", add 
label define label_cipcode4 521201 "52.1201 - Mgt InfoSys/Bus DataProc Gen", add 
label define label_cipcode4 521202 "52.1202 - Business Computer Prog/Prog", add 
label define label_cipcode4 521204 "52.1204 - Bus Systems Network, Telecom", add 
label define label_cipcode4 521205 "52.1205 - Bus Computer Facilities Oper", add 
label define label_cipcode4 521299 "52.1299 - Bus Info & DataProc Svcs Oth", add 
label define label_cipcode4 521501 "52.1501 - Real Estate", add 
label define label_cipcode4 529999 "52.9999 - Bus Mgmt & Admin Svcs, Other", add 
label values cipcode4 label_cipcode4
label define label_xciptui4 10 "Reported" 
label define label_xciptui4 11 "Analyst corrected reported value", add 
label define label_xciptui4 12 "Data generated from other data values", add 
label define label_xciptui4 13 "Implied zero", add 
label define label_xciptui4 14 "Data adjusted in scan edits", add 
label define label_xciptui4 15 "Data copied from another field", add 
label define label_xciptui4 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xciptui4 17 "Details are adjusted to sum to total", add 
label define label_xciptui4 18 "Total generated to equal the sum of detail", add 
label define label_xciptui4 20 "Imputed using data from prior year", add 
label define label_xciptui4 21 "Imputed using method other than prior year data", add 
label define label_xciptui4 30 "Not applicable", add 
label define label_xciptui4 31 "Original data field was not reported", add 
label define label_xciptui4 40 "Suppressed to protect confidentiality", add 
*label values xciptui4 label_xciptui4
label define label_xcipsup4 10 "Reported" 
label define label_xcipsup4 11 "Analyst corrected reported value", add 
label define label_xcipsup4 12 "Data generated from other data values", add 
label define label_xcipsup4 13 "Implied zero", add 
label define label_xcipsup4 14 "Data adjusted in scan edits", add 
label define label_xcipsup4 15 "Data copied from another field", add 
label define label_xcipsup4 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xcipsup4 17 "Details are adjusted to sum to total", add 
label define label_xcipsup4 18 "Total generated to equal the sum of detail", add 
label define label_xcipsup4 20 "Imputed using data from prior year", add 
label define label_xcipsup4 21 "Imputed using method other than prior year data", add 
label define label_xcipsup4 30 "Not applicable", add 
label define label_xcipsup4 31 "Original data field was not reported", add 
label define label_xcipsup4 40 "Suppressed to protect confidentiality", add 
*label values xcipsup4 label_xcipsup4
label define label_xciplgt4 10 "Reported" 
label define label_xciplgt4 11 "Analyst corrected reported value", add 
label define label_xciplgt4 12 "Data generated from other data values", add 
label define label_xciplgt4 13 "Implied zero", add 
label define label_xciplgt4 14 "Data adjusted in scan edits", add 
label define label_xciplgt4 15 "Data copied from another field", add 
label define label_xciplgt4 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xciplgt4 17 "Details are adjusted to sum to total", add 
label define label_xciplgt4 18 "Total generated to equal the sum of detail", add 
label define label_xciplgt4 20 "Imputed using data from prior year", add 
label define label_xciplgt4 21 "Imputed using method other than prior year data", add 
label define label_xciplgt4 30 "Not applicable", add 
label define label_xciplgt4 31 "Original data field was not reported", add 
label define label_xciplgt4 40 "Suppressed to protect confidentiality", add 
*label values xciplgt4 label_xciplgt4
label define label_cipcode5 -1 "-1 - {Not reported}" 
label define label_cipcode5 -2 "-2 - {Item not applicable}", add 
label define label_cipcode5 10204 "01.0204 - Agri Power Machinery Oper", add 
label define label_cipcode5 10507 "01.0507 - Equine Stud, Horse Mgmt/Trng", add 
label define label_cipcode5 30501 "03.0501 - Forestry, General", add 
label define label_cipcode5 80102 "08.0102 - Fashion Merchandising", add 
label define label_cipcode5 80503 "08.0503 - Floristry Marketing Opers", add 
label define label_cipcode5 80705 "08.0705 - General Retailing Operations", add 
label define label_cipcode5 81104 "08.1104 - Tourism Promotion Operations", add 
label define label_cipcode5 81105 "08.1105 - Travel Svcs Marketing Oper", add 
label define label_cipcode5 81199 "08.1199 - Tour/Travel Svcs Mktg Op Oth", add 
label define label_cipcode5 90201 "09.0201 - Advertising", add 
label define label_cipcode5 100104 "10.0104 - Radio/TV Broadcast Tech/Tech", add 
label define label_cipcode5 100199 "10.0199 - Communications Tech/Tech Oth", add 
label define label_cipcode5 110101 "11.0101 - Computer & Info Science, Gen", add 
label define label_cipcode5 110201 "11.0201 - Computer Programming", add 
label define label_cipcode5 110301 "11.0301 - Data Processing Tech/Tech", add 
label define label_cipcode5 110401 "11.0401 - Information Sci & Systems", add 
label define label_cipcode5 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode5 119999 "11.9999 - Computer & Info Science, Oth", add 
label define label_cipcode5 120203 "12.0203 - Card Dealer", add 
label define label_cipcode5 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode5 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode5 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode5 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode5 120405 "12.0405 - Massage", add 
label define label_cipcode5 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode5 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode5 120501 "12.0501 - Baker/Pastry Chef", add 
label define label_cipcode5 120503 "12.0503 - Culinary Arts/Chef Training", add 
label define label_cipcode5 129999 "12.9999 - Personal & Misc Svcs, Other", add 
label define label_cipcode5 130101 "13.0101 - Education, General", add 
label define label_cipcode5 140901 "14.0901 - Computer Engineering", add 
label define label_cipcode5 141001 "14.1001 - Elect, Electron & Comm Eng", add 
label define label_cipcode5 150201 "15.0201 - Civil Eng/Civil Tech/Tech", add 
label define label_cipcode5 150301 "15.0301 - Computer Eng Tech/Tech", add 
label define label_cipcode5 150303 "15.0303 - Elect/Electron/Comm Eng T/T", add 
label define label_cipcode5 150399 "15.0399 - Elect/Elect Eng-Rel T/T Oth", add 
label define label_cipcode5 150401 "15.0401 - Biomed Eng-Rel Tech/Tech", add 
label define label_cipcode5 150402 "15.0402 - Computer Maint Tech/Tech", add 
label define label_cipcode5 150404 "15.0404 - Instrumentation Tech/Tech", add 
label define label_cipcode5 150501 "15.0501 - Heating/AC/Refrig Tech/Tech", add 
label define label_cipcode5 150506 "15.0506 - H2O Qual/WasteH2O Treat T/T", add 
label define label_cipcode5 150603 "15.0603 - Industrial/Manuf Tech/Tech", add 
label define label_cipcode5 151001 "15.1001 - Construction/Bldg Tech/Tech", add 
label define label_cipcode5 151101 "15.1101 - Engineering-Related T/T Gen", add 
label define label_cipcode5 200201 "20.0201 - Child Care/Guide Wkr/Mgr Gen", add 
label define label_cipcode5 200202 "20.0202 - Child Care Provider/Asst", add 
label define label_cipcode5 200303 "20.0303 - Commercial Garment & App Wkr", add 
label define label_cipcode5 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode5 200699 "20.0699 - Cust/Hskpg Srvs Wkr/Mgr Oth", add 
label define label_cipcode5 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode5 269999 "26.9999 - Biological Sci/Life Sci, Oth", add 
label define label_cipcode5 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode5 420601 "42.0601 - Counseling Psychology", add 
label define label_cipcode5 430102 "43.0102 - Corrections/Correction Admin", add 
label define label_cipcode5 430107 "43.0107 - Law Enforcement/Police Sci", add 
label define label_cipcode5 430109 "43.0109 - Security & Loss Prevent Svcs", add 
label define label_cipcode5 430199 "43.0199 - Crim Justice & Correct, Oth", add 
label define label_cipcode5 439999 "43.9999 - Protective Services, Other", add 
label define label_cipcode5 460201 "46.0201 - Carpenter", add 
label define label_cipcode5 460302 "46.0302 - Electrician", add 
label define label_cipcode5 460401 "46.0401 - Building/Property Maint/Mgr", add 
label define label_cipcode5 460501 "46.0501 - Plumber & Pipefitter", add 
label define label_cipcode5 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode5 470101 "47.0101 - Elect/El Equip Inst/Rep Gen", add 
label define label_cipcode5 470102 "47.0102 - Business Machine Repairer", add 
label define label_cipcode5 470104 "47.0104 - Computer Install & Repair", add 
label define label_cipcode5 470105 "47.0105 - Indust Electron Install/Rep", add 
label define label_cipcode5 470106 "47.0106 - Major Appliance Install/Rep", add 
label define label_cipcode5 470199 "47.0199 - Elect/El Equip Inst/Rep Oth", add 
label define label_cipcode5 470201 "47.0201 - Heating/AC/Refrig Mech/Rep", add 
label define label_cipcode5 470302 "47.0302 - Heavy Equip Maint/Repair", add 
label define label_cipcode5 470303 "47.0303 - Indust Machine Maint/Repair", add 
label define label_cipcode5 470399 "47.0399 - Indust Equip Maint/Rep, Oth", add 
label define label_cipcode5 470402 "47.0402 - Gunsmith", add 
label define label_cipcode5 470603 "47.0603 - Auto/Automotive Body Repair", add 
label define label_cipcode5 470604 "47.0604 - Auto/Automotive Mech/Tech", add 
label define label_cipcode5 470605 "47.0605 - Diesel Engine Mech/Repair", add 
label define label_cipcode5 470606 "47.0606 - Small Engine Mech/Repair", add 
label define label_cipcode5 470607 "47.0607 - Aircraft Mech/Tech, Airframe", add 
label define label_cipcode5 470608 "47.0608 - Aircraft Mech/Tech, Powrplnt", add 
label define label_cipcode5 470611 "47.0611 - Motorcycle Mechanic & Repair", add 
label define label_cipcode5 470699 "47.0699 - Veh/Mobil Equip Mech/Rep Oth", add 
label define label_cipcode5 479999 "47.9999 - Mechanics & Repairers, Other", add 
label define label_cipcode5 480101 "48.0101 - Drafting, General", add 
label define label_cipcode5 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode5 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode5 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode5 480201 "48.0201 - Graphic/Print Equip Oper Gen", add 
label define label_cipcode5 480211 "48.0211 - Computer Typo/Compo Equip Op", add 
label define label_cipcode5 480212 "48.0212 - Desktop Publishing Equip Op", add 
label define label_cipcode5 480299 "48.0299 - Graphic/Print Equip Oper Oth", add 
label define label_cipcode5 480303 "48.0303 - Upholsterer", add 
label define label_cipcode5 480501 "48.0501 - Machinist/Machine Tech", add 
label define label_cipcode5 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode5 480508 "48.0508 - Welder/Welding Tech", add 
label define label_cipcode5 480599 "48.0599 - Precision Metal Workers, Oth", add 
label define label_cipcode5 480703 "48.0703 - Cabinet Maker & Millworker", add 
label define label_cipcode5 489999 "48.9999 - Precision Prod Trades, Oth", add 
label define label_cipcode5 490101 "49.0101 - Aviation & Airway Science", add 
label define label_cipcode5 490102 "49.0102 - Aircraft Pilot & Nav (Prof)", add 
label define label_cipcode5 490106 "49.0106 - Flight Attendant", add 
label define label_cipcode5 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode5 490199 "49.0199 - Air Transportation Wkrs, Oth", add 
label define label_cipcode5 490205 "49.0205 - Truck, Bus, Comm Vehicle Op", add 
label define label_cipcode5 490299 "49.0299 - Vehicle & Equip Opers, Oth", add 
label define label_cipcode5 490303 "49.0303 - Fishing Tech/Comm Fishing", add 
label define label_cipcode5 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode5 490309 "49.0309 - Marine Sci/Merch Marine Ofc", add 
label define label_cipcode5 490399 "49.0399 - Water Transport Workers, Oth", add 
label define label_cipcode5 499999 "49.9999 - Trans & Mat Moving Wkrs, Oth", add 
label define label_cipcode5 500402 "50.0402 - Graphic Des/Comm Art/Illust", add 
label define label_cipcode5 500407 "50.0407 - Fashion Design & Illust", add 
label define label_cipcode5 500499 "50.0499 - Design & Applied Arts, Oth", add 
label define label_cipcode5 500503 "50.0503 - Acting & Directing", add 
label define label_cipcode5 500605 "50.0605 - Photography", add 
label define label_cipcode5 500699 "50.0699 - Film/Video/Photog Arts, Oth", add 
label define label_cipcode5 500710 "50.0710 - Printmaking", add 
label define label_cipcode5 500713 "50.0713 - Metal & Jewelry Arts", add 
label define label_cipcode5 500999 "50.0999 - Music, Other", add 
label define label_cipcode5 510101 "51.0101 - Chiropractic (DC, DCM)", add 
label define label_cipcode5 510601 "51.0601 - Dental Assistant", add 
label define label_cipcode5 510602 "51.0602 - Dental Hygienist", add 
label define label_cipcode5 510603 "51.0603 - Dental Laboratory Technician", add 
label define label_cipcode5 510699 "51.0699 - Dental Services, Other", add 
label define label_cipcode5 510701 "51.0701 - Health Sys/Health Svcs Admin", add 
label define label_cipcode5 510703 "51.0703 - Health Unit Coord/Ward Clerk", add 
label define label_cipcode5 510705 "51.0705 - Medical Office Management", add 
label define label_cipcode5 510706 "51.0706 - Medical Records Admin", add 
label define label_cipcode5 510707 "51.0707 - Medical Records Tech/Tech", add 
label define label_cipcode5 510708 "51.0708 - Medical Transcription", add 
label define label_cipcode5 510799 "51.0799 - Health & Med Admin Svcs, Oth", add 
label define label_cipcode5 510801 "51.0801 - Medical Assistant", add 
label define label_cipcode5 510802 "51.0802 - Medical Laboratory Assistant", add 
label define label_cipcode5 510803 "51.0803 - Occupational Therapy Asst", add 
label define label_cipcode5 510805 "51.0805 - Pharmacy Technician/Asst", add 
label define label_cipcode5 510806 "51.0806 - Physical Therapy Assistant", add 
label define label_cipcode5 510807 "51.0807 - Physician Assistant", add 
label define label_cipcode5 510808 "51.0808 - Vet Asst/Animal Health Tech", add 
label define label_cipcode5 510899 "51.0899 - Health & Medical Assts, Oth", add 
label define label_cipcode5 510901 "51.0901 - Cardiovascular Tech/Tech", add 
label define label_cipcode5 510902 "51.0902 - Electrocardiograph Tech/Tech", add 
label define label_cipcode5 510904 "51.0904 - Emergency Medicine Tech/Tech", add 
label define label_cipcode5 510906 "51.0906 - Perfusion Technology/Tech", add 
label define label_cipcode5 510907 "51.0907 - Medical Radiologic Tech/Tech", add 
label define label_cipcode5 510908 "51.0908 - Respiratory Therapy Tech", add 
label define label_cipcode5 510909 "51.0909 - Surgical/Operating Room Tech", add 
label define label_cipcode5 510910 "51.0910 - Diagnostic Med Sonography", add 
label define label_cipcode5 510999 "51.0999 - Health/Med Diag/Tx Svcs Oth", add 
label define label_cipcode5 511001 "51.1001 - Blood Bank Technology/Tech", add 
label define label_cipcode5 511003 "51.1003 - Hematology Technology/Tech", add 
label define label_cipcode5 511004 "51.1004 - Medical Laboratory Tech", add 
label define label_cipcode5 511006 "51.1006 - Optometric/Ophthal Lab Tech", add 
label define label_cipcode5 511099 "51.1099 - Health/Med Lab Tech/Tech Oth", add 
label define label_cipcode5 511501 "51.1501 - Alcohol/Drug Abuse Couns", add 
label define label_cipcode5 511601 "51.1601 - Nursing (RN Training)", add 
label define label_cipcode5 511613 "51.1613 - Practical Nurse (LPN Train)", add 
label define label_cipcode5 511614 "51.1614 - Nurse Assistant/Aide", add 
label define label_cipcode5 511615 "51.1615 - Home Health Aide", add 
label define label_cipcode5 511699 "51.1699 - Nursing, Other", add 
label define label_cipcode5 511801 "51.1801 - Opticianry/Dispens Optician", add 
label define label_cipcode5 512309 "51.2309 - Recreational Therapy", add 
label define label_cipcode5 512601 "51.2601 - Health Aide", add 
label define label_cipcode5 519999 "51.9999 - Health Profes & Rel Sci, Oth", add 
label define label_cipcode5 520101 "52.0101 - Business, General", add 
label define label_cipcode5 520201 "52.0201 - Business Admin & Mgmt, Gen", add 
label define label_cipcode5 520204 "52.0204 - Office Supervision & Mgmt", add 
label define label_cipcode5 520299 "52.0299 - Business Admin & Mgmt, Oth", add 
label define label_cipcode5 520301 "52.0301 - Accounting", add 
label define label_cipcode5 520302 "52.0302 - Accounting Technician", add 
label define label_cipcode5 520399 "52.0399 - Accounting, Other", add 
label define label_cipcode5 520401 "52.0401 - Admin Asst/Sec Sci, Gen", add 
label define label_cipcode5 520402 "52.0402 - Executive Assistant/Secty", add 
label define label_cipcode5 520403 "52.0403 - Legal Admin Asst/Secretary", add 
label define label_cipcode5 520404 "52.0404 - Medical Admin Asst/Secretary", add 
label define label_cipcode5 520405 "52.0405 - Court Reporter", add 
label define label_cipcode5 520406 "52.0406 - Receptionist", add 
label define label_cipcode5 520407 "52.0407 - Info Process/Data Entry Tech", add 
label define label_cipcode5 520408 "52.0408 - Gen Office/Clerk/Typing Svcs", add 
label define label_cipcode5 520499 "52.0499 - Admin & Secretarial Svcs Oth", add 
label define label_cipcode5 520601 "52.0601 - Business/Managerial Economic", add 
label define label_cipcode5 520801 "52.0801 - Finance, General", add 
label define label_cipcode5 520803 "52.0803 - Banking & Fin Support Svcs", add 
label define label_cipcode5 520805 "52.0805 - Insurance & Risk Management", add 
label define label_cipcode5 520901 "52.0901 - Hospitality/Admin Management", add 
label define label_cipcode5 520903 "52.0903 - Travel-Tourism Management", add 
label define label_cipcode5 520999 "52.0999 - Hospitality Svcs Mgmt, Other", add 
label define label_cipcode5 521201 "52.1201 - Mgt InfoSys/Bus DataProc Gen", add 
label define label_cipcode5 521202 "52.1202 - Business Computer Prog/Prog", add 
label define label_cipcode5 521203 "52.1203 - Bus System Analysis & Design", add 
label define label_cipcode5 521204 "52.1204 - Bus Systems Network, Telecom", add 
label define label_cipcode5 521205 "52.1205 - Bus Computer Facilities Oper", add 
label define label_cipcode5 521299 "52.1299 - Bus Info & DataProc Svcs Oth", add 
label define label_cipcode5 521499 "52.1499 - Marketing Mgmt, Research Oth", add 
label define label_cipcode5 521501 "52.1501 - Real Estate", add 
label define label_cipcode5 521601 "52.1601 - Taxation", add 
label define label_cipcode5 529999 "52.9999 - Bus Mgmt & Admin Svcs, Other", add 
label values cipcode5 label_cipcode5
label define label_xciptui5 10 "Reported" 
label define label_xciptui5 11 "Analyst corrected reported value", add 
label define label_xciptui5 12 "Data generated from other data values", add 
label define label_xciptui5 13 "Implied zero", add 
label define label_xciptui5 14 "Data adjusted in scan edits", add 
label define label_xciptui5 15 "Data copied from another field", add 
label define label_xciptui5 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xciptui5 17 "Details are adjusted to sum to total", add 
label define label_xciptui5 18 "Total generated to equal the sum of detail", add 
label define label_xciptui5 20 "Imputed using data from prior year", add 
label define label_xciptui5 21 "Imputed using method other than prior year data", add 
label define label_xciptui5 30 "Not applicable", add 
label define label_xciptui5 31 "Original data field was not reported", add 
label define label_xciptui5 40 "Suppressed to protect confidentiality", add 
*label values xciptui5 label_xciptui5
label define label_xcipsup5 10 "Reported" 
label define label_xcipsup5 11 "Analyst corrected reported value", add 
label define label_xcipsup5 12 "Data generated from other data values", add 
label define label_xcipsup5 13 "Implied zero", add 
label define label_xcipsup5 14 "Data adjusted in scan edits", add 
label define label_xcipsup5 15 "Data copied from another field", add 
label define label_xcipsup5 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xcipsup5 17 "Details are adjusted to sum to total", add 
label define label_xcipsup5 18 "Total generated to equal the sum of detail", add 
label define label_xcipsup5 20 "Imputed using data from prior year", add 
label define label_xcipsup5 21 "Imputed using method other than prior year data", add 
label define label_xcipsup5 30 "Not applicable", add 
label define label_xcipsup5 31 "Original data field was not reported", add 
label define label_xcipsup5 40 "Suppressed to protect confidentiality", add 
*label values xcipsup5 label_xcipsup5
label define label_xciplgt5 10 "Reported" 
label define label_xciplgt5 11 "Analyst corrected reported value", add 
label define label_xciplgt5 12 "Data generated from other data values", add 
label define label_xciplgt5 13 "Implied zero", add 
label define label_xciplgt5 14 "Data adjusted in scan edits", add 
label define label_xciplgt5 15 "Data copied from another field", add 
label define label_xciplgt5 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xciplgt5 17 "Details are adjusted to sum to total", add 
label define label_xciplgt5 18 "Total generated to equal the sum of detail", add 
label define label_xciplgt5 20 "Imputed using data from prior year", add 
label define label_xciplgt5 21 "Imputed using method other than prior year data", add 
label define label_xciplgt5 30 "Not applicable", add 
label define label_xciplgt5 31 "Original data field was not reported", add 
label define label_xciplgt5 40 "Suppressed to protect confidentiality", add 
*label values xciplgt5 label_xciplgt5
label define label_cipcode6 -1 "-1 - {Not reported}" 
label define label_cipcode6 -2 "-2 - {Item not applicable}", add 
label define label_cipcode6 10507 "01.0507 - Equine Stud, Horse Mgmt/Trng", add 
label define label_cipcode6 10601 "01.0601 - Horticult Svcs Oper/Mgmt Gen", add 
label define label_cipcode6 80101 "08.0101 - Apparel & Access Mkt Op Gen", add 
label define label_cipcode6 80103 "08.0103 - Fashion Modeling", add 
label define label_cipcode6 80301 "08.0301 - Entrepreneurship", add 
label define label_cipcode6 80503 "08.0503 - Floristry Marketing Opers", add 
label define label_cipcode6 80708 "08.0708 - General Marketing Operations", add 
label define label_cipcode6 81105 "08.1105 - Travel Svcs Marketing Oper", add 
label define label_cipcode6 81199 "08.1199 - Tour/Travel Svcs Mktg Op Oth", add 
label define label_cipcode6 99999 "09.9999 - Communications, Other", add 
label define label_cipcode6 100101 "10.0101 - Educ/Instruc Media Tech/Tech", add 
label define label_cipcode6 100104 "10.0104 - Radio/TV Broadcast Tech/Tech", add 
label define label_cipcode6 100199 "10.0199 - Communications Tech/Tech Oth", add 
label define label_cipcode6 110101 "11.0101 - Computer & Info Science, Gen", add 
label define label_cipcode6 110201 "11.0201 - Computer Programming", add 
label define label_cipcode6 110301 "11.0301 - Data Processing Tech/Tech", add 
label define label_cipcode6 110401 "11.0401 - Information Sci & Systems", add 
label define label_cipcode6 110501 "11.0501 - Computer Systems Analysis", add 
label define label_cipcode6 110701 "11.0701 - Computer Science", add 
label define label_cipcode6 119999 "11.9999 - Computer & Info Science, Oth", add 
label define label_cipcode6 120203 "12.0203 - Card Dealer", add 
label define label_cipcode6 120401 "12.0401 - Cosmetic Services, General", add 
label define label_cipcode6 120402 "12.0402 - Barber/Hairstylist", add 
label define label_cipcode6 120403 "12.0403 - Cosmetologist", add 
label define label_cipcode6 120404 "12.0404 - Electrolysis Technician", add 
label define label_cipcode6 120405 "12.0405 - Massage", add 
label define label_cipcode6 120406 "12.0406 - Make-Up Artist", add 
label define label_cipcode6 120499 "12.0499 - Cosmetic Services, Other", add 
label define label_cipcode6 120501 "12.0501 - Baker/Pastry Chef", add 
label define label_cipcode6 120503 "12.0503 - Culinary Arts/Chef Training", add 
label define label_cipcode6 120599 "12.0599 - Culinary Arts/Rel Svcs, Oth", add 
label define label_cipcode6 130404 "13.0404 - Educational Supervision", add 
label define label_cipcode6 131204 "13.1204 - PreElem/EC/Kindergn Tchr Ed", add 
label define label_cipcode6 131501 "13.1501 - Teacher Assistant/Aide", add 
label define label_cipcode6 142401 "14.2401 - Ocean Engineering", add 
label define label_cipcode6 150301 "15.0301 - Computer Eng Tech/Tech", add 
label define label_cipcode6 150303 "15.0303 - Elect/Electron/Comm Eng T/T", add 
label define label_cipcode6 150399 "15.0399 - Elect/Elect Eng-Rel T/T Oth", add 
label define label_cipcode6 150402 "15.0402 - Computer Maint Tech/Tech", add 
label define label_cipcode6 150501 "15.0501 - Heating/AC/Refrig Tech/Tech", add 
label define label_cipcode6 150507 "15.0507 - Environ & Pollution Ctrl T/T", add 
label define label_cipcode6 150599 "15.0599 - Environ Ctrl Tech/Tech, Oth", add 
label define label_cipcode6 150803 "15.0803 - Automotive Eng Tech/Tech", add 
label define label_cipcode6 151101 "15.1101 - Engineering-Related T/T Gen", add 
label define label_cipcode6 151102 "15.1102 - Surveying", add 
label define label_cipcode6 200201 "20.0201 - Child Care/Guide Wkr/Mgr Gen", add 
label define label_cipcode6 200202 "20.0202 - Child Care Provider/Asst", add 
label define label_cipcode6 200299 "20.0299 - Child Care/Guide Wkr/Mgr Oth", add 
label define label_cipcode6 200305 "20.0305 - Custom Tailor", add 
label define label_cipcode6 200604 "20.0604 - Custodian/Caretaker", add 
label define label_cipcode6 220103 "22.0103 - Paralegal/Legal Assistant", add 
label define label_cipcode6 220199 "22.0199 - Law & Legal Studies, Other", add 
label define label_cipcode6 240101 "24.0101 - Lib Arts, Sci/Lib Studies", add 
label define label_cipcode6 240102 "24.0102 - General Studies", add 
label define label_cipcode6 269999 "26.9999 - Biological Sci/Life Sci, Oth", add 
label define label_cipcode6 301101 "30.1101 - Gerontology", add 
label define label_cipcode6 390201 "39.0201 - Bible/Biblical Studies", add 
label define label_cipcode6 400101 "40.0101 - Physical Sciences, General", add 
label define label_cipcode6 430102 "43.0102 - Corrections/Correction Admin", add 
label define label_cipcode6 430107 "43.0107 - Law Enforcement/Police Sci", add 
label define label_cipcode6 430109 "43.0109 - Security & Loss Prevent Svcs", add 
label define label_cipcode6 430199 "43.0199 - Crim Justice & Correct, Oth", add 
label define label_cipcode6 430203 "43.0203 - Fire Science/Firefighting", add 
label define label_cipcode6 460101 "46.0101 - Mason & Tile Setter", add 
label define label_cipcode6 460201 "46.0201 - Carpenter", add 
label define label_cipcode6 460301 "46.0301 - Elec/Power Trans Install Gen", add 
label define label_cipcode6 460302 "46.0302 - Electrician", add 
label define label_cipcode6 460303 "46.0303 - Lineworker", add 
label define label_cipcode6 460401 "46.0401 - Building/Property Maint/Mgr", add 
label define label_cipcode6 460501 "46.0501 - Plumber & Pipefitter", add 
label define label_cipcode6 469999 "46.9999 - Construction Trades, Other", add 
label define label_cipcode6 470101 "47.0101 - Elect/El Equip Inst/Rep Gen", add 
label define label_cipcode6 470103 "47.0103 - Commun Systems Inst & Repair", add 
label define label_cipcode6 470104 "47.0104 - Computer Install & Repair", add 
label define label_cipcode6 470105 "47.0105 - Indust Electron Install/Rep", add 
label define label_cipcode6 470106 "47.0106 - Major Appliance Install/Rep", add 
label define label_cipcode6 470199 "47.0199 - Elect/El Equip Inst/Rep Oth", add 
label define label_cipcode6 470201 "47.0201 - Heating/AC/Refrig Mech/Rep", add 
label define label_cipcode6 470302 "47.0302 - Heavy Equip Maint/Repair", add 
label define label_cipcode6 470303 "47.0303 - Indust Machine Maint/Repair", add 
label define label_cipcode6 470399 "47.0399 - Indust Equip Maint/Rep, Oth", add 
label define label_cipcode6 470402 "47.0402 - Gunsmith", add 
label define label_cipcode6 470404 "47.0404 - Musical Instrument Repair", add 
label define label_cipcode6 470408 "47.0408 - Watch/Clock/Jewelry Repair", add 
label define label_cipcode6 470603 "47.0603 - Auto/Automotive Body Repair", add 
label define label_cipcode6 470604 "47.0604 - Auto/Automotive Mech/Tech", add 
label define label_cipcode6 470605 "47.0605 - Diesel Engine Mech/Repair", add 
label define label_cipcode6 470609 "47.0609 - Aviation Sys/Avionics T/T", add 
label define label_cipcode6 470611 "47.0611 - Motorcycle Mechanic & Repair", add 
label define label_cipcode6 470699 "47.0699 - Veh/Mobil Equip Mech/Rep Oth", add 
label define label_cipcode6 480101 "48.0101 - Drafting, General", add 
label define label_cipcode6 480102 "48.0102 - Architectural Drafting", add 
label define label_cipcode6 480105 "48.0105 - Mechanical Drafting", add 
label define label_cipcode6 480199 "48.0199 - Drafting, Other", add 
label define label_cipcode6 480201 "48.0201 - Graphic/Print Equip Oper Gen", add 
label define label_cipcode6 480212 "48.0212 - Desktop Publishing Equip Op", add 
label define label_cipcode6 480299 "48.0299 - Graphic/Print Equip Oper Oth", add 
label define label_cipcode6 480501 "48.0501 - Machinist/Machine Tech", add 
label define label_cipcode6 480503 "48.0503 - Machine Shop Assistant", add 
label define label_cipcode6 480507 "48.0507 - Tool & Die Maker/Tech", add 
label define label_cipcode6 480508 "48.0508 - Welder/Welding Tech", add 
label define label_cipcode6 480702 "48.0702 - Furniture Designer & Maker", add 
label define label_cipcode6 480703 "48.0703 - Cabinet Maker & Millworker", add 
label define label_cipcode6 490101 "49.0101 - Aviation & Airway Science", add 
label define label_cipcode6 490102 "49.0102 - Aircraft Pilot & Nav (Prof)", add 
label define label_cipcode6 490107 "49.0107 - Aircraft Pilot (Private)", add 
label define label_cipcode6 490199 "49.0199 - Air Transportation Wkrs, Oth", add 
label define label_cipcode6 490205 "49.0205 - Truck, Bus, Comm Vehicle Op", add 
label define label_cipcode6 490304 "49.0304 - Diver (Professional)", add 
label define label_cipcode6 490309 "49.0309 - Marine Sci/Merch Marine Ofc", add 
label define label_cipcode6 490399 "49.0399 - Water Transport Workers, Oth", add 
label define label_cipcode6 499999 "49.9999 - Trans & Mat Moving Wkrs, Oth", add 
label define label_cipcode6 500401 "50.0401 - Design/Visual Communications", add 
label define label_cipcode6 500402 "50.0402 - Graphic Des/Comm Art/Illust", add 
label define label_cipcode6 500699 "50.0699 - Film/Video/Photog Arts, Oth", add 
label define label_cipcode6 500713 "50.0713 - Metal & Jewelry Arts", add 
label define label_cipcode6 510205 "51.0205 - Sign Language Interpreter", add 
label define label_cipcode6 510601 "51.0601 - Dental Assistant", add 
label define label_cipcode6 510603 "51.0603 - Dental Laboratory Technician", add 
label define label_cipcode6 510699 "51.0699 - Dental Services, Other", add 
label define label_cipcode6 510703 "51.0703 - Health Unit Coord/Ward Clerk", add 
label define label_cipcode6 510705 "51.0705 - Medical Office Management", add 
label define label_cipcode6 510706 "51.0706 - Medical Records Admin", add 
label define label_cipcode6 510707 "51.0707 - Medical Records Tech/Tech", add 
label define label_cipcode6 510708 "51.0708 - Medical Transcription", add 
label define label_cipcode6 510799 "51.0799 - Health & Med Admin Svcs, Oth", add 
label define label_cipcode6 510801 "51.0801 - Medical Assistant", add 
label define label_cipcode6 510803 "51.0803 - Occupational Therapy Asst", add 
label define label_cipcode6 510804 "51.0804 - Ophthalmic Medical Assistant", add 
label define label_cipcode6 510805 "51.0805 - Pharmacy Technician/Asst", add 
label define label_cipcode6 510806 "51.0806 - Physical Therapy Assistant", add 
label define label_cipcode6 510808 "51.0808 - Vet Asst/Animal Health Tech", add 
label define label_cipcode6 510901 "51.0901 - Cardiovascular Tech/Tech", add 
label define label_cipcode6 510903 "51.0903 - Electroencephalograph Tech/T", add 
label define label_cipcode6 510904 "51.0904 - Emergency Medicine Tech/Tech", add 
label define label_cipcode6 510908 "51.0908 - Respiratory Therapy Tech", add 
label define label_cipcode6 510909 "51.0909 - Surgical/Operating Room Tech", add 
label define label_cipcode6 510910 "51.0910 - Diagnostic Med Sonography", add 
label define label_cipcode6 511004 "51.1004 - Medical Laboratory Tech", add 
label define label_cipcode6 511099 "51.1099 - Health/Med Lab Tech/Tech Oth", add 
label define label_cipcode6 511502 "51.1502 - Psych/Mental Health Svc Tech", add 
label define label_cipcode6 511613 "51.1613 - Practical Nurse (LPN Train)", add 
label define label_cipcode6 511614 "51.1614 - Nurse Assistant/Aide", add 
label define label_cipcode6 511615 "51.1615 - Home Health Aide", add 
label define label_cipcode6 511699 "51.1699 - Nursing, Other", add 
label define label_cipcode6 512099 "51.2099 - Pharmacy, Other", add 
label define label_cipcode6 512399 "51.2399 - Rehab/Therapeutic Svcs, Oth", add 
label define label_cipcode6 512601 "51.2601 - Health Aide", add 
label define label_cipcode6 519999 "51.9999 - Health Profes & Rel Sci, Oth", add 
label define label_cipcode6 520101 "52.0101 - Business, General", add 
label define label_cipcode6 520201 "52.0201 - Business Admin & Mgmt, Gen", add 
label define label_cipcode6 520202 "52.0202 - Purch, Procure, Contract Mgt", add 
label define label_cipcode6 520204 "52.0204 - Office Supervision & Mgmt", add 
label define label_cipcode6 520301 "52.0301 - Accounting", add 
label define label_cipcode6 520302 "52.0302 - Accounting Technician", add 
label define label_cipcode6 520399 "52.0399 - Accounting, Other", add 
label define label_cipcode6 520401 "52.0401 - Admin Asst/Sec Sci, Gen", add 
label define label_cipcode6 520402 "52.0402 - Executive Assistant/Secty", add 
label define label_cipcode6 520403 "52.0403 - Legal Admin Asst/Secretary", add 
label define label_cipcode6 520404 "52.0404 - Medical Admin Asst/Secretary", add 
label define label_cipcode6 520405 "52.0405 - Court Reporter", add 
label define label_cipcode6 520406 "52.0406 - Receptionist", add 
label define label_cipcode6 520407 "52.0407 - Info Process/Data Entry Tech", add 
label define label_cipcode6 520408 "52.0408 - Gen Office/Clerk/Typing Svcs", add 
label define label_cipcode6 520499 "52.0499 - Admin & Secretarial Svcs Oth", add 
label define label_cipcode6 520701 "52.0701 - Enterprise Mgmt & Oper, Gen", add 
label define label_cipcode6 520801 "52.0801 - Finance, General", add 
label define label_cipcode6 520803 "52.0803 - Banking & Fin Support Svcs", add 
label define label_cipcode6 520805 "52.0805 - Insurance & Risk Management", add 
label define label_cipcode6 520902 "52.0902 - Hotel/Motel/Restaurant Mgmt", add 
label define label_cipcode6 520903 "52.0903 - Travel-Tourism Management", add 
label define label_cipcode6 521099 "52.1099 - Human Resources Mgmt, Oth", add 
label define label_cipcode6 521201 "52.1201 - Mgt InfoSys/Bus DataProc Gen", add 
label define label_cipcode6 521202 "52.1202 - Business Computer Prog/Prog", add 
label define label_cipcode6 521204 "52.1204 - Bus Systems Network, Telecom", add 
label define label_cipcode6 521205 "52.1205 - Bus Computer Facilities Oper", add 
label define label_cipcode6 521299 "52.1299 - Bus Info & DataProc Svcs Oth", add 
label define label_cipcode6 521501 "52.1501 - Real Estate", add 
label define label_cipcode6 529999 "52.9999 - Bus Mgmt & Admin Svcs, Other", add 
label values cipcode6 label_cipcode6
label define label_xciptui6 10 "Reported" 
label define label_xciptui6 11 "Analyst corrected reported value", add 
label define label_xciptui6 12 "Data generated from other data values", add 
label define label_xciptui6 13 "Implied zero", add 
label define label_xciptui6 14 "Data adjusted in scan edits", add 
label define label_xciptui6 15 "Data copied from another field", add 
label define label_xciptui6 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xciptui6 17 "Details are adjusted to sum to total", add 
label define label_xciptui6 18 "Total generated to equal the sum of detail", add 
label define label_xciptui6 20 "Imputed using data from prior year", add 
label define label_xciptui6 21 "Imputed using method other than prior year data", add 
label define label_xciptui6 30 "Not applicable", add 
label define label_xciptui6 31 "Original data field was not reported", add 
label define label_xciptui6 40 "Suppressed to protect confidentiality", add 
*label values xciptui6 label_xciptui6
label define label_xcipsup6 10 "Reported" 
label define label_xcipsup6 11 "Analyst corrected reported value", add 
label define label_xcipsup6 12 "Data generated from other data values", add 
label define label_xcipsup6 13 "Implied zero", add 
label define label_xcipsup6 14 "Data adjusted in scan edits", add 
label define label_xcipsup6 15 "Data copied from another field", add 
label define label_xcipsup6 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xcipsup6 17 "Details are adjusted to sum to total", add 
label define label_xcipsup6 18 "Total generated to equal the sum of detail", add 
label define label_xcipsup6 20 "Imputed using data from prior year", add 
label define label_xcipsup6 21 "Imputed using method other than prior year data", add 
label define label_xcipsup6 30 "Not applicable", add 
label define label_xcipsup6 31 "Original data field was not reported", add 
label define label_xcipsup6 40 "Suppressed to protect confidentiality", add 
*label values xcipsup6 label_xcipsup6
label define label_xciplgt6 10 "Reported" 
label define label_xciplgt6 11 "Analyst corrected reported value", add 
label define label_xciplgt6 12 "Data generated from other data values", add 
label define label_xciplgt6 13 "Implied zero", add 
label define label_xciplgt6 14 "Data adjusted in scan edits", add 
label define label_xciplgt6 15 "Data copied from another field", add 
label define label_xciplgt6 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xciplgt6 17 "Details are adjusted to sum to total", add 
label define label_xciplgt6 18 "Total generated to equal the sum of detail", add 
label define label_xciplgt6 20 "Imputed using data from prior year", add 
label define label_xciplgt6 21 "Imputed using method other than prior year data", add 
label define label_xciplgt6 30 "Not applicable", add 
label define label_xciplgt6 31 "Original data field was not reported", add 
label define label_xciplgt6 40 "Suppressed to protect confidentiality", add 
*label values xciplgt6 label_xciplgt6
label define label_tuition4 -1 "{Not reported}" 
label define label_tuition4 -2 "{Item not applicable}", add 
label define label_tuition4 -5 "{Implied no}", add 
label define label_tuition4 1 "Yes", add 
label values tuition4 label_tuition4
label define label_xtuit1 10 "Reported" 
label define label_xtuit1 11 "Analyst corrected reported value", add 
label define label_xtuit1 12 "Data generated from other data values", add 
label define label_xtuit1 13 "Implied zero", add 
label define label_xtuit1 14 "Data adjusted in scan edits", add 
label define label_xtuit1 15 "Data copied from another field", add 
label define label_xtuit1 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xtuit1 17 "Details are adjusted to sum to total", add 
label define label_xtuit1 18 "Total generated to equal the sum of detail", add 
label define label_xtuit1 20 "Imputed using data from prior year", add 
label define label_xtuit1 21 "Imputed using method other than prior year data", add 
label define label_xtuit1 30 "Not applicable", add 
label define label_xtuit1 31 "Original data field was not reported", add 
label define label_xtuit1 40 "Suppressed to protect confidentiality", add 
*label values xtuit1 label_xtuit1
label define label_xtuit2 10 "Reported" 
label define label_xtuit2 11 "Analyst corrected reported value", add 
label define label_xtuit2 12 "Data generated from other data values", add 
label define label_xtuit2 13 "Implied zero", add 
label define label_xtuit2 14 "Data adjusted in scan edits", add 
label define label_xtuit2 15 "Data copied from another field", add 
label define label_xtuit2 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xtuit2 17 "Details are adjusted to sum to total", add 
label define label_xtuit2 18 "Total generated to equal the sum of detail", add 
label define label_xtuit2 20 "Imputed using data from prior year", add 
label define label_xtuit2 21 "Imputed using method other than prior year data", add 
label define label_xtuit2 30 "Not applicable", add 
label define label_xtuit2 31 "Original data field was not reported", add 
label define label_xtuit2 40 "Suppressed to protect confidentiality", add 
*label values xtuit2 label_xtuit2
label define label_xtuit3 10 "Reported" 
label define label_xtuit3 11 "Analyst corrected reported value", add 
label define label_xtuit3 12 "Data generated from other data values", add 
label define label_xtuit3 13 "Implied zero", add 
label define label_xtuit3 14 "Data adjusted in scan edits", add 
label define label_xtuit3 15 "Data copied from another field", add 
label define label_xtuit3 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xtuit3 17 "Details are adjusted to sum to total", add 
label define label_xtuit3 18 "Total generated to equal the sum of detail", add 
label define label_xtuit3 20 "Imputed using data from prior year", add 
label define label_xtuit3 21 "Imputed using method other than prior year data", add 
label define label_xtuit3 30 "Not applicable", add 
label define label_xtuit3 31 "Original data field was not reported", add 
label define label_xtuit3 40 "Suppressed to protect confidentiality", add 
*label values xtuit3 label_xtuit3
label define label_xtypugcr 10 "Reported" 
label define label_xtypugcr 11 "Analyst corrected reported value", add 
label define label_xtypugcr 12 "Data generated from other data values", add 
label define label_xtypugcr 13 "Implied zero", add 
label define label_xtypugcr 14 "Data adjusted in scan edits", add 
label define label_xtypugcr 15 "Data copied from another field", add 
label define label_xtypugcr 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xtypugcr 17 "Details are adjusted to sum to total", add 
label define label_xtypugcr 18 "Total generated to equal the sum of detail", add 
label define label_xtypugcr 20 "Imputed using data from prior year", add 
label define label_xtypugcr 21 "Imputed using method other than prior year data", add 
label define label_xtypugcr 30 "Not applicable", add 
label define label_xtypugcr 31 "Original data field was not reported", add 
label define label_xtypugcr 40 "Suppressed to protect confidentiality", add 
**label values xtypugcr label_xtypugcr
label define label_xtypugcn 10 "Reported" 
label define label_xtypugcn 11 "Analyst corrected reported value", add 
label define label_xtypugcn 12 "Data generated from other data values", add 
label define label_xtypugcn 13 "Implied zero", add 
label define label_xtypugcn 14 "Data adjusted in scan edits", add 
label define label_xtypugcn 15 "Data copied from another field", add 
label define label_xtypugcn 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xtypugcn 17 "Details are adjusted to sum to total", add 
label define label_xtypugcn 18 "Total generated to equal the sum of detail", add 
label define label_xtypugcn 20 "Imputed using data from prior year", add 
label define label_xtypugcn 21 "Imputed using method other than prior year data", add 
label define label_xtypugcn 30 "Not applicable", add 
label define label_xtypugcn 31 "Original data field was not reported", add 
label define label_xtypugcn 40 "Suppressed to protect confidentiality", add 
**label values xtypugcn label_xtypugcn
label define label_tuition8 -1 "{Not reported}" 
label define label_tuition8 -2 "{Item not applicable}", add 
label define label_tuition8 -5 "{Implied no}", add 
label define label_tuition8 1 "Yes", add 
label values tuition8 label_tuition8
label define label_xtuit5 10 "Reported" 
label define label_xtuit5 11 "Analyst corrected reported value", add 
label define label_xtuit5 12 "Data generated from other data values", add 
label define label_xtuit5 13 "Implied zero", add 
label define label_xtuit5 14 "Data adjusted in scan edits", add 
label define label_xtuit5 15 "Data copied from another field", add 
label define label_xtuit5 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xtuit5 17 "Details are adjusted to sum to total", add 
label define label_xtuit5 18 "Total generated to equal the sum of detail", add 
label define label_xtuit5 20 "Imputed using data from prior year", add 
label define label_xtuit5 21 "Imputed using method other than prior year data", add 
label define label_xtuit5 30 "Not applicable", add 
label define label_xtuit5 31 "Original data field was not reported", add 
label define label_xtuit5 40 "Suppressed to protect confidentiality", add 
*label values xtuit5 label_xtuit5
label define label_xtuit6 10 "Reported" 
label define label_xtuit6 11 "Analyst corrected reported value", add 
label define label_xtuit6 12 "Data generated from other data values", add 
label define label_xtuit6 13 "Implied zero", add 
label define label_xtuit6 14 "Data adjusted in scan edits", add 
label define label_xtuit6 15 "Data copied from another field", add 
label define label_xtuit6 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xtuit6 17 "Details are adjusted to sum to total", add 
label define label_xtuit6 18 "Total generated to equal the sum of detail", add 
label define label_xtuit6 20 "Imputed using data from prior year", add 
label define label_xtuit6 21 "Imputed using method other than prior year data", add 
label define label_xtuit6 30 "Not applicable", add 
label define label_xtuit6 31 "Original data field was not reported", add 
label define label_xtuit6 40 "Suppressed to protect confidentiality", add 
*label values xtuit6 label_xtuit6
label define label_xtuit7 10 "Reported" 
label define label_xtuit7 11 "Analyst corrected reported value", add 
label define label_xtuit7 12 "Data generated from other data values", add 
label define label_xtuit7 13 "Implied zero", add 
label define label_xtuit7 14 "Data adjusted in scan edits", add 
label define label_xtuit7 15 "Data copied from another field", add 
label define label_xtuit7 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xtuit7 17 "Details are adjusted to sum to total", add 
label define label_xtuit7 18 "Total generated to equal the sum of detail", add 
label define label_xtuit7 20 "Imputed using data from prior year", add 
label define label_xtuit7 21 "Imputed using method other than prior year data", add 
label define label_xtuit7 30 "Not applicable", add 
label define label_xtuit7 31 "Original data field was not reported", add 
label define label_xtuit7 40 "Suppressed to protect confidentiality", add 
*label values xtuit7 label_xtuit7
label define label_xtypgrcr 10 "Reported" 
label define label_xtypgrcr 11 "Analyst corrected reported value", add 
label define label_xtypgrcr 12 "Data generated from other data values", add 
label define label_xtypgrcr 13 "Implied zero", add 
label define label_xtypgrcr 14 "Data adjusted in scan edits", add 
label define label_xtypgrcr 15 "Data copied from another field", add 
label define label_xtypgrcr 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xtypgrcr 17 "Details are adjusted to sum to total", add 
label define label_xtypgrcr 18 "Total generated to equal the sum of detail", add 
label define label_xtypgrcr 20 "Imputed using data from prior year", add 
label define label_xtypgrcr 21 "Imputed using method other than prior year data", add 
label define label_xtypgrcr 30 "Not applicable", add 
label define label_xtypgrcr 31 "Original data field was not reported", add 
label define label_xtypgrcr 40 "Suppressed to protect confidentiality", add 
**label values xtypgrcr label_xtypgrcr
label define label_profna -1 "{Not reported}" 
label define label_profna -2 "{Item not applicable}", add 
label define label_profna -5 "{Implied no}", add 
label define label_profna 1 "Yes", add 
label values profna label_profna
label define label_xispro1 10 "Reported" 
label define label_xispro1 11 "Analyst corrected reported value", add 
label define label_xispro1 12 "Data generated from other data values", add 
label define label_xispro1 13 "Implied zero", add 
label define label_xispro1 14 "Data adjusted in scan edits", add 
label define label_xispro1 15 "Data copied from another field", add 
label define label_xispro1 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xispro1 17 "Details are adjusted to sum to total", add 
label define label_xispro1 18 "Total generated to equal the sum of detail", add 
label define label_xispro1 20 "Imputed using data from prior year", add 
label define label_xispro1 21 "Imputed using method other than prior year data", add 
label define label_xispro1 30 "Not applicable", add 
label define label_xispro1 31 "Original data field was not reported", add 
label define label_xispro1 40 "Suppressed to protect confidentiality", add 
*label values xispro1 label_xispro1
label define label_xospro1 10 "Reported" 
label define label_xospro1 11 "Analyst corrected reported value", add 
label define label_xospro1 12 "Data generated from other data values", add 
label define label_xospro1 13 "Implied zero", add 
label define label_xospro1 14 "Data adjusted in scan edits", add 
label define label_xospro1 15 "Data copied from another field", add 
label define label_xospro1 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xospro1 17 "Details are adjusted to sum to total", add 
label define label_xospro1 18 "Total generated to equal the sum of detail", add 
label define label_xospro1 20 "Imputed using data from prior year", add 
label define label_xospro1 21 "Imputed using method other than prior year data", add 
label define label_xospro1 30 "Not applicable", add 
label define label_xospro1 31 "Original data field was not reported", add 
label define label_xospro1 40 "Suppressed to protect confidentiality", add 
*label values xospro1 label_xospro1
label define label_xispro2 10 "Reported" 
label define label_xispro2 11 "Analyst corrected reported value", add 
label define label_xispro2 12 "Data generated from other data values", add 
label define label_xispro2 13 "Implied zero", add 
label define label_xispro2 14 "Data adjusted in scan edits", add 
label define label_xispro2 15 "Data copied from another field", add 
label define label_xispro2 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xispro2 17 "Details are adjusted to sum to total", add 
label define label_xispro2 18 "Total generated to equal the sum of detail", add 
label define label_xispro2 20 "Imputed using data from prior year", add 
label define label_xispro2 21 "Imputed using method other than prior year data", add 
label define label_xispro2 30 "Not applicable", add 
label define label_xispro2 31 "Original data field was not reported", add 
label define label_xispro2 40 "Suppressed to protect confidentiality", add 
*label values xispro2 label_xispro2
label define label_xospro2 10 "Reported" 
label define label_xospro2 11 "Analyst corrected reported value", add 
label define label_xospro2 12 "Data generated from other data values", add 
label define label_xospro2 13 "Implied zero", add 
label define label_xospro2 14 "Data adjusted in scan edits", add 
label define label_xospro2 15 "Data copied from another field", add 
label define label_xospro2 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xospro2 17 "Details are adjusted to sum to total", add 
label define label_xospro2 18 "Total generated to equal the sum of detail", add 
label define label_xospro2 20 "Imputed using data from prior year", add 
label define label_xospro2 21 "Imputed using method other than prior year data", add 
label define label_xospro2 30 "Not applicable", add 
label define label_xospro2 31 "Original data field was not reported", add 
label define label_xospro2 40 "Suppressed to protect confidentiality", add 
*label values xospro2 label_xospro2
label define label_xispro3 10 "Reported" 
label define label_xispro3 11 "Analyst corrected reported value", add 
label define label_xispro3 12 "Data generated from other data values", add 
label define label_xispro3 13 "Implied zero", add 
label define label_xispro3 14 "Data adjusted in scan edits", add 
label define label_xispro3 15 "Data copied from another field", add 
label define label_xispro3 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xispro3 17 "Details are adjusted to sum to total", add 
label define label_xispro3 18 "Total generated to equal the sum of detail", add 
label define label_xispro3 20 "Imputed using data from prior year", add 
label define label_xispro3 21 "Imputed using method other than prior year data", add 
label define label_xispro3 30 "Not applicable", add 
label define label_xispro3 31 "Original data field was not reported", add 
label define label_xispro3 40 "Suppressed to protect confidentiality", add 
*label values xispro3 label_xispro3
label define label_xospro3 10 "Reported" 
label define label_xospro3 11 "Analyst corrected reported value", add 
label define label_xospro3 12 "Data generated from other data values", add 
label define label_xospro3 13 "Implied zero", add 
label define label_xospro3 14 "Data adjusted in scan edits", add 
label define label_xospro3 15 "Data copied from another field", add 
label define label_xospro3 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xospro3 17 "Details are adjusted to sum to total", add 
label define label_xospro3 18 "Total generated to equal the sum of detail", add 
label define label_xospro3 20 "Imputed using data from prior year", add 
label define label_xospro3 21 "Imputed using method other than prior year data", add 
label define label_xospro3 30 "Not applicable", add 
label define label_xospro3 31 "Original data field was not reported", add 
label define label_xospro3 40 "Suppressed to protect confidentiality", add 
*label values xospro3 label_xospro3
label define label_xispro4 10 "Reported" 
label define label_xispro4 11 "Analyst corrected reported value", add 
label define label_xispro4 12 "Data generated from other data values", add 
label define label_xispro4 13 "Implied zero", add 
label define label_xispro4 14 "Data adjusted in scan edits", add 
label define label_xispro4 15 "Data copied from another field", add 
label define label_xispro4 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xispro4 17 "Details are adjusted to sum to total", add 
label define label_xispro4 18 "Total generated to equal the sum of detail", add 
label define label_xispro4 20 "Imputed using data from prior year", add 
label define label_xispro4 21 "Imputed using method other than prior year data", add 
label define label_xispro4 30 "Not applicable", add 
label define label_xispro4 31 "Original data field was not reported", add 
label define label_xispro4 40 "Suppressed to protect confidentiality", add 
*label values xispro4 label_xispro4
label define label_xospro4 10 "Reported" 
label define label_xospro4 11 "Analyst corrected reported value", add 
label define label_xospro4 12 "Data generated from other data values", add 
label define label_xospro4 13 "Implied zero", add 
label define label_xospro4 14 "Data adjusted in scan edits", add 
label define label_xospro4 15 "Data copied from another field", add 
label define label_xospro4 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xospro4 17 "Details are adjusted to sum to total", add 
label define label_xospro4 18 "Total generated to equal the sum of detail", add 
label define label_xospro4 20 "Imputed using data from prior year", add 
label define label_xospro4 21 "Imputed using method other than prior year data", add 
label define label_xospro4 30 "Not applicable", add 
label define label_xospro4 31 "Original data field was not reported", add 
label define label_xospro4 40 "Suppressed to protect confidentiality", add 
*label values xospro4 label_xospro4
label define label_xispro5 10 "Reported" 
label define label_xispro5 11 "Analyst corrected reported value", add 
label define label_xispro5 12 "Data generated from other data values", add 
label define label_xispro5 13 "Implied zero", add 
label define label_xispro5 14 "Data adjusted in scan edits", add 
label define label_xispro5 15 "Data copied from another field", add 
label define label_xispro5 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xispro5 17 "Details are adjusted to sum to total", add 
label define label_xispro5 18 "Total generated to equal the sum of detail", add 
label define label_xispro5 20 "Imputed using data from prior year", add 
label define label_xispro5 21 "Imputed using method other than prior year data", add 
label define label_xispro5 30 "Not applicable", add 
label define label_xispro5 31 "Original data field was not reported", add 
label define label_xispro5 40 "Suppressed to protect confidentiality", add 
*label values xispro5 label_xispro5
label define label_xospro5 10 "Reported" 
label define label_xospro5 11 "Analyst corrected reported value", add 
label define label_xospro5 12 "Data generated from other data values", add 
label define label_xospro5 13 "Implied zero", add 
label define label_xospro5 14 "Data adjusted in scan edits", add 
label define label_xospro5 15 "Data copied from another field", add 
label define label_xospro5 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xospro5 17 "Details are adjusted to sum to total", add 
label define label_xospro5 18 "Total generated to equal the sum of detail", add 
label define label_xospro5 20 "Imputed using data from prior year", add 
label define label_xospro5 21 "Imputed using method other than prior year data", add 
label define label_xospro5 30 "Not applicable", add 
label define label_xospro5 31 "Original data field was not reported", add 
label define label_xospro5 40 "Suppressed to protect confidentiality", add 
*label values xospro5 label_xospro5
label define label_xispro6 10 "Reported" 
label define label_xispro6 11 "Analyst corrected reported value", add 
label define label_xispro6 12 "Data generated from other data values", add 
label define label_xispro6 13 "Implied zero", add 
label define label_xispro6 14 "Data adjusted in scan edits", add 
label define label_xispro6 15 "Data copied from another field", add 
label define label_xispro6 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xispro6 17 "Details are adjusted to sum to total", add 
label define label_xispro6 18 "Total generated to equal the sum of detail", add 
label define label_xispro6 20 "Imputed using data from prior year", add 
label define label_xispro6 21 "Imputed using method other than prior year data", add 
label define label_xispro6 30 "Not applicable", add 
label define label_xispro6 31 "Original data field was not reported", add 
label define label_xispro6 40 "Suppressed to protect confidentiality", add 
*label values xispro6 label_xispro6
label define label_xospro6 10 "Reported" 
label define label_xospro6 11 "Analyst corrected reported value", add 
label define label_xospro6 12 "Data generated from other data values", add 
label define label_xospro6 13 "Implied zero", add 
label define label_xospro6 14 "Data adjusted in scan edits", add 
label define label_xospro6 15 "Data copied from another field", add 
label define label_xospro6 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xospro6 17 "Details are adjusted to sum to total", add 
label define label_xospro6 18 "Total generated to equal the sum of detail", add 
label define label_xospro6 20 "Imputed using data from prior year", add 
label define label_xospro6 21 "Imputed using method other than prior year data", add 
label define label_xospro6 30 "Not applicable", add 
label define label_xospro6 31 "Original data field was not reported", add 
label define label_xospro6 40 "Suppressed to protect confidentiality", add 
*label values xospro6 label_xospro6
label define label_xispro7 10 "Reported" 
label define label_xispro7 11 "Analyst corrected reported value", add 
label define label_xispro7 12 "Data generated from other data values", add 
label define label_xispro7 13 "Implied zero", add 
label define label_xispro7 14 "Data adjusted in scan edits", add 
label define label_xispro7 15 "Data copied from another field", add 
label define label_xispro7 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xispro7 17 "Details are adjusted to sum to total", add 
label define label_xispro7 18 "Total generated to equal the sum of detail", add 
label define label_xispro7 20 "Imputed using data from prior year", add 
label define label_xispro7 21 "Imputed using method other than prior year data", add 
label define label_xispro7 30 "Not applicable", add 
label define label_xispro7 31 "Original data field was not reported", add 
label define label_xispro7 40 "Suppressed to protect confidentiality", add 
*label values xispro7 label_xispro7
label define label_xospro7 10 "Reported" 
label define label_xospro7 11 "Analyst corrected reported value", add 
label define label_xospro7 12 "Data generated from other data values", add 
label define label_xospro7 13 "Implied zero", add 
label define label_xospro7 14 "Data adjusted in scan edits", add 
label define label_xospro7 15 "Data copied from another field", add 
label define label_xospro7 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xospro7 17 "Details are adjusted to sum to total", add 
label define label_xospro7 18 "Total generated to equal the sum of detail", add 
label define label_xospro7 20 "Imputed using data from prior year", add 
label define label_xospro7 21 "Imputed using method other than prior year data", add 
label define label_xospro7 30 "Not applicable", add 
label define label_xospro7 31 "Original data field was not reported", add 
label define label_xospro7 40 "Suppressed to protect confidentiality", add 
*label values xospro7 label_xospro7
label define label_xispro8 10 "Reported" 
label define label_xispro8 11 "Analyst corrected reported value", add 
label define label_xispro8 12 "Data generated from other data values", add 
label define label_xispro8 13 "Implied zero", add 
label define label_xispro8 14 "Data adjusted in scan edits", add 
label define label_xispro8 15 "Data copied from another field", add 
label define label_xispro8 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xispro8 17 "Details are adjusted to sum to total", add 
label define label_xispro8 18 "Total generated to equal the sum of detail", add 
label define label_xispro8 20 "Imputed using data from prior year", add 
label define label_xispro8 21 "Imputed using method other than prior year data", add 
label define label_xispro8 30 "Not applicable", add 
label define label_xispro8 31 "Original data field was not reported", add 
label define label_xispro8 40 "Suppressed to protect confidentiality", add 
*label values xispro8 label_xispro8
label define label_xospro8 10 "Reported" 
label define label_xospro8 11 "Analyst corrected reported value", add 
label define label_xospro8 12 "Data generated from other data values", add 
label define label_xospro8 13 "Implied zero", add 
label define label_xospro8 14 "Data adjusted in scan edits", add 
label define label_xospro8 15 "Data copied from another field", add 
label define label_xospro8 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xospro8 17 "Details are adjusted to sum to total", add 
label define label_xospro8 18 "Total generated to equal the sum of detail", add 
label define label_xospro8 20 "Imputed using data from prior year", add 
label define label_xospro8 21 "Imputed using method other than prior year data", add 
label define label_xospro8 30 "Not applicable", add 
label define label_xospro8 31 "Original data field was not reported", add 
label define label_xospro8 40 "Suppressed to protect confidentiality", add 
*label values xospro8 label_xospro8
label define label_xispro9 10 "Reported" 
label define label_xispro9 11 "Analyst corrected reported value", add 
label define label_xispro9 12 "Data generated from other data values", add 
label define label_xispro9 13 "Implied zero", add 
label define label_xispro9 14 "Data adjusted in scan edits", add 
label define label_xispro9 15 "Data copied from another field", add 
label define label_xispro9 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xispro9 17 "Details are adjusted to sum to total", add 
label define label_xispro9 18 "Total generated to equal the sum of detail", add 
label define label_xispro9 20 "Imputed using data from prior year", add 
label define label_xispro9 21 "Imputed using method other than prior year data", add 
label define label_xispro9 30 "Not applicable", add 
label define label_xispro9 31 "Original data field was not reported", add 
label define label_xispro9 40 "Suppressed to protect confidentiality", add 
*label values xispro9 label_xispro9
label define label_xospro9 10 "Reported" 
label define label_xospro9 11 "Analyst corrected reported value", add 
label define label_xospro9 12 "Data generated from other data values", add 
label define label_xospro9 13 "Implied zero", add 
label define label_xospro9 14 "Data adjusted in scan edits", add 
label define label_xospro9 15 "Data copied from another field", add 
label define label_xospro9 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xospro9 17 "Details are adjusted to sum to total", add 
label define label_xospro9 18 "Total generated to equal the sum of detail", add 
label define label_xospro9 20 "Imputed using data from prior year", add 
label define label_xospro9 21 "Imputed using method other than prior year data", add 
label define label_xospro9 30 "Not applicable", add 
label define label_xospro9 31 "Original data field was not reported", add 
label define label_xospro9 40 "Suppressed to protect confidentiality", add 
*label values xospro9 label_xospro9
label define label_xispro10 10 "Reported" 
label define label_xispro10 11 "Analyst corrected reported value", add 
label define label_xispro10 12 "Data generated from other data values", add 
label define label_xispro10 13 "Implied zero", add 
label define label_xispro10 14 "Data adjusted in scan edits", add 
label define label_xispro10 15 "Data copied from another field", add 
label define label_xispro10 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xispro10 17 "Details are adjusted to sum to total", add 
label define label_xispro10 18 "Total generated to equal the sum of detail", add 
label define label_xispro10 20 "Imputed using data from prior year", add 
label define label_xispro10 21 "Imputed using method other than prior year data", add 
label define label_xispro10 30 "Not applicable", add 
label define label_xispro10 31 "Original data field was not reported", add 
label define label_xispro10 40 "Suppressed to protect confidentiality", add 
*label values xispro10 label_xispro10
label define label_xospro10 10 "Reported" 
label define label_xospro10 11 "Analyst corrected reported value", add 
label define label_xospro10 12 "Data generated from other data values", add 
label define label_xospro10 13 "Implied zero", add 
label define label_xospro10 14 "Data adjusted in scan edits", add 
label define label_xospro10 15 "Data copied from another field", add 
label define label_xospro10 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xospro10 17 "Details are adjusted to sum to total", add 
label define label_xospro10 18 "Total generated to equal the sum of detail", add 
label define label_xospro10 20 "Imputed using data from prior year", add 
label define label_xospro10 21 "Imputed using method other than prior year data", add 
label define label_xospro10 30 "Not applicable", add 
label define label_xospro10 31 "Original data field was not reported", add 
label define label_xospro10 40 "Suppressed to protect confidentiality", add 
*label values xospro10 label_xospro10
label define label_xispro11 10 "Reported" 
label define label_xispro11 11 "Analyst corrected reported value", add 
label define label_xispro11 12 "Data generated from other data values", add 
label define label_xispro11 13 "Implied zero", add 
label define label_xispro11 14 "Data adjusted in scan edits", add 
label define label_xispro11 15 "Data copied from another field", add 
label define label_xispro11 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xispro11 17 "Details are adjusted to sum to total", add 
label define label_xispro11 18 "Total generated to equal the sum of detail", add 
label define label_xispro11 20 "Imputed using data from prior year", add 
label define label_xispro11 21 "Imputed using method other than prior year data", add 
label define label_xispro11 30 "Not applicable", add 
label define label_xispro11 31 "Original data field was not reported", add 
label define label_xispro11 40 "Suppressed to protect confidentiality", add 
*label values xispro11 label_xispro11
label define label_xospro11 10 "Reported" 
label define label_xospro11 11 "Analyst corrected reported value", add 
label define label_xospro11 12 "Data generated from other data values", add 
label define label_xospro11 13 "Implied zero", add 
label define label_xospro11 14 "Data adjusted in scan edits", add 
label define label_xospro11 15 "Data copied from another field", add 
label define label_xospro11 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xospro11 17 "Details are adjusted to sum to total", add 
label define label_xospro11 18 "Total generated to equal the sum of detail", add 
label define label_xospro11 20 "Imputed using data from prior year", add 
label define label_xospro11 21 "Imputed using method other than prior year data", add 
label define label_xospro11 30 "Not applicable", add 
label define label_xospro11 31 "Original data field was not reported", add 
label define label_xospro11 40 "Suppressed to protect confidentiality", add 
*label values xospro11 label_xospro11
label define label_xtypfpcr 10 "Reported" 
label define label_xtypfpcr 11 "Analyst corrected reported value", add 
label define label_xtypfpcr 12 "Data generated from other data values", add 
label define label_xtypfpcr 13 "Implied zero", add 
label define label_xtypfpcr 14 "Data adjusted in scan edits", add 
label define label_xtypfpcr 15 "Data copied from another field", add 
label define label_xtypfpcr 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xtypfpcr 17 "Details are adjusted to sum to total", add 
label define label_xtypfpcr 18 "Total generated to equal the sum of detail", add 
label define label_xtypfpcr 20 "Imputed using data from prior year", add 
label define label_xtypfpcr 21 "Imputed using method other than prior year data", add 
label define label_xtypfpcr 30 "Not applicable", add 
label define label_xtypfpcr 31 "Original data field was not reported", add 
label define label_xtypfpcr 40 "Suppressed to protect confidentiality", add 
*label values xtypfpcr label_xtypfpcr
label define label_room -1 "{Not reported}" 
label define label_room -2 "{Item not applicable}", add 
label define label_room 1 "Yes", add 
label define label_room 2 "No", add 
label values room label_room
label define label_xroomcap 10 "Reported" 
label define label_xroomcap 11 "Analyst corrected reported value", add 
label define label_xroomcap 12 "Data generated from other data values", add 
label define label_xroomcap 13 "Implied zero", add 
label define label_xroomcap 14 "Data adjusted in scan edits", add 
label define label_xroomcap 15 "Data copied from another field", add 
label define label_xroomcap 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xroomcap 17 "Details are adjusted to sum to total", add 
label define label_xroomcap 18 "Total generated to equal the sum of detail", add 
label define label_xroomcap 20 "Imputed using data from prior year", add 
label define label_xroomcap 21 "Imputed using method other than prior year data", add 
label define label_xroomcap 30 "Not applicable", add 
label define label_xroomcap 31 "Original data field was not reported", add 
label define label_xroomcap 40 "Suppressed to protect confidentiality", add 
*label values xroomcap label_xroomcap
label define label_board -1 "{Not reported}" 
label define label_board -2 "{Item not applicable}", add 
label define label_board 1 "Yes", add 
label define label_board 2 "No", add 
label values board label_board
label define label_xmealswk 10 "Reported" 
label define label_xmealswk 11 "Analyst corrected reported value", add 
label define label_xmealswk 12 "Data generated from other data values", add 
label define label_xmealswk 13 "Implied zero", add 
label define label_xmealswk 14 "Data adjusted in scan edits", add 
label define label_xmealswk 15 "Data copied from another field", add 
label define label_xmealswk 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xmealswk 17 "Details are adjusted to sum to total", add 
label define label_xmealswk 18 "Total generated to equal the sum of detail", add 
label define label_xmealswk 20 "Imputed using data from prior year", add 
label define label_xmealswk 21 "Imputed using method other than prior year data", add 
label define label_xmealswk 30 "Not applicable", add 
label define label_xmealswk 31 "Original data field was not reported", add 
label define label_xmealswk 40 "Suppressed to protect confidentiality", add 
*label values xmealswk label_xmealswk
label define label_mealsvry -1 "{Not reported}" 
label define label_mealsvry -2 "{Item not applicable}", add 
label define label_mealsvry -5 "{Implied no}", add 
label define label_mealsvry 1 "Yes", add 
label values mealsvry label_mealsvry
label define label_xroomamt 10 "Reported" 
label define label_xroomamt 11 "Analyst corrected reported value", add 
label define label_xroomamt 12 "Data generated from other data values", add 
label define label_xroomamt 13 "Implied zero", add 
label define label_xroomamt 14 "Data adjusted in scan edits", add 
label define label_xroomamt 15 "Data copied from another field", add 
label define label_xroomamt 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xroomamt 17 "Details are adjusted to sum to total", add 
label define label_xroomamt 18 "Total generated to equal the sum of detail", add 
label define label_xroomamt 20 "Imputed using data from prior year", add 
label define label_xroomamt 21 "Imputed using method other than prior year data", add 
label define label_xroomamt 30 "Not applicable", add 
label define label_xroomamt 31 "Original data field was not reported", add 
label define label_xroomamt 40 "Suppressed to protect confidentiality", add 
*label values xroomamt label_xroomamt
label define label_xbordamt 10 "Reported" 
label define label_xbordamt 11 "Analyst corrected reported value", add 
label define label_xbordamt 12 "Data generated from other data values", add 
label define label_xbordamt 13 "Implied zero", add 
label define label_xbordamt 14 "Data adjusted in scan edits", add 
label define label_xbordamt 15 "Data copied from another field", add 
label define label_xbordamt 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xbordamt 17 "Details are adjusted to sum to total", add 
label define label_xbordamt 18 "Total generated to equal the sum of detail", add 
label define label_xbordamt 20 "Imputed using data from prior year", add 
label define label_xbordamt 21 "Imputed using method other than prior year data", add 
label define label_xbordamt 30 "Not applicable", add 
label define label_xbordamt 31 "Original data field was not reported", add 
label define label_xbordamt 40 "Suppressed to protect confidentiality", add 
*label values xbordamt label_xbordamt
label define label_xrmbdamt 10 "Reported" 
label define label_xrmbdamt 11 "Analyst corrected reported value", add 
label define label_xrmbdamt 12 "Data generated from other data values", add 
label define label_xrmbdamt 13 "Implied zero", add 
label define label_xrmbdamt 14 "Data adjusted in scan edits", add 
label define label_xrmbdamt 15 "Data copied from another field", add 
label define label_xrmbdamt 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xrmbdamt 17 "Details are adjusted to sum to total", add 
label define label_xrmbdamt 18 "Total generated to equal the sum of detail", add 
label define label_xrmbdamt 20 "Imputed using data from prior year", add 
label define label_xrmbdamt 21 "Imputed using method other than prior year data", add 
label define label_xrmbdamt 30 "Not applicable", add 
label define label_xrmbdamt 31 "Original data field was not reported", add 
label define label_xrmbdamt 40 "Suppressed to protect confidentiality", add 
*label values xrmbdamt label_xrmbdamt
tab apfee
tab xappfeeu
tab xappfeeg
tab xappfeep
tab ftstu
tab chgper1
tab chgper2
tab chgper3
tab chgper4
tab chgper5
tab pg300
tab cipcode1
tab xciptui1
tab xcipsup1
tab xciplgt1
tab cipcode2
tab xciptui2
tab xcipsup2
tab xciplgt2
tab cipcode3
tab xciptui3
tab xcipsup3
tab xciplgt3
tab cipcode4
tab xciptui4
tab xcipsup4
tab xciplgt4
tab cipcode5
tab xciptui5
tab xcipsup5
tab xciplgt5
tab cipcode6
tab xciptui6
tab xcipsup6
tab xciplgt6
tab tuition4
tab xtuit1
tab xtuit2
tab xtuit3
tab xtypugcr
tab xtypugcn
tab tuition8
tab xtuit5
tab xtuit6
tab xtuit7
tab xtypgrcr
tab profna
tab xispro1
tab xospro1
tab osprof1
tab xispro2
tab xospro2
tab xispro3
tab xospro3
tab xispro4
tab xospro4
tab xispro5
tab xospro5
tab xispro6
tab xospro6
tab xispro7
tab xospro7
tab xispro8
tab xospro8
tab xispro9
tab xospro9
tab xispro10
tab xospro10
tab xispro11
tab xospro11
tab xtypfpcr
tab room
tab xroomcap
tab board
tab xmealswk
tab mealsvry
tab xroomamt
tab xbordamt
tab xrmbdamt
summarize applfeeu
summarize applfeeg
summarize applfeep
summarize prgmofr
summarize ciptuit1
summarize cipsupp1
summarize ciplgth1
summarize ciptuit2
summarize cipsupp2
summarize ciplgth2
summarize ciptuit3
summarize cipsupp3
summarize ciplgth3
summarize ciptuit4
summarize cipsupp4
summarize ciplgth4
summarize ciptuit5
summarize cipsupp5
summarize ciplgth5
summarize ciptuit6
summarize cipsupp6
summarize ciplgth6
summarize tuition1
summarize tuition2
summarize tuition3
summarize tpugcred
summarize tpugcont
summarize tuition5
summarize tuition6
summarize tuition7
summarize tpgrcred
summarize isprof1
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
save dct_ic98_d

