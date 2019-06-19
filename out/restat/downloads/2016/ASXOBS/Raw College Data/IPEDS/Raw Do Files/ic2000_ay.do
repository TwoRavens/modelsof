* Created: 6/12/2004 10:20:12 PM
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
insheet using "../Raw Data/ic2000_ay_data_stata.csv", comma clear
label data "dct_ic2000_ay"
label variable unitid "unitid"
label variable xtuit1 "Imputation field for TUITION1 - Tuition  FTFY UG in-district"
label variable tuition1 "Tuition  FTFY UG in-district"
label variable xfee1 "Imputation field for FEE1 - In-district undergraduate required fees"
label variable fee1 "In-district undergraduate required fees"
label variable xhrchg1 "Imputation field for HRCHG1 - In-district UG per credit hour charge"
label variable hrchg1 "In-district UG per credit hour charge"
label variable xcmpfee1 "Imputation field for CMPFEE1 - In-district UG comprehensive fee"
label variable cmpfee1 "In-district UG comprehensive fee"
label variable xtuit2 "Imputation field for TUITION2 - Tuition FTFY UG in-state"
label variable tuition2 "Tuition FTFY UG in-state"
label variable xfee2 "Imputation field for FEE2 - In-state undergraduate required fees"
label variable fee2 "In-state undergraduate required fees"
label variable xhrchg2 "Imputation field for HRCHG2 - In-state UG per credit hour charge"
label variable hrchg2 "In-state UG per credit hour charge"
label variable xcmpfee2 "Imputation field for CMPFEE2 - In-state UG comprehensive fee"
label variable cmpfee2 "In-state UG comprehensive fee"
label variable xtuit3 "Imputation field for TUITION3 - Tuition FTFY UG out-of-state"
label variable tuition3 "Tuition FTFY UG out-of-state"
label variable xfee3 "Imputation field for FEE3 - Out-of-state undergraduate required fees"
label variable fee3 "Out-of-state undergraduate required fees"
label variable xhrchg3 "Imputation field for HRCHG3 - Out-of-state UG per credit hour charge"
label variable hrchg3 "Out-of-state UG per credit hour charge"
label variable xcmpfee3 "Imputation field for CMPFEE3 - Out-of-state UG comprehensive fee"
label variable cmpfee3 "Out-of-state UG comprehensive fee"
label variable xtuit5 "Imputation field for TUITION5 - Tuition  FTFY Grad in-district"
label variable tuition5 "Tuition  FTFY Grad in-district"
label variable xfee5 "Imputation field for FEE5 - In-district graduate required fees"
label variable fee5 "In-district graduate required fees"
label variable xhrchg5 "Imputation field for HRCHG5 - In-district GR per credit hour charge"
label variable hrchg5 "In-district GR per credit hour charge"
label variable xtuit6 "Imputation field for TUITION6 - Tuition  FTFY Grad in-state"
label variable tuition6 "Tuition  FTFY Grad in-state"
label variable xfee6 "Imputation field for FEE6 - In-state graduate required fees"
label variable fee6 "In-state graduate required fees"
label variable xhrchg6 "Imputation field for HRCHG6 - In-state GR per credit hour charge"
label variable hrchg6 "In-state GR per credit hour charge"
label variable xtuit7 "Imputation field for TUITION7 - Tuition  FTFY Grad out-of-state"
label variable tuition7 "Tuition  FTFY Grad out-of-state"
label variable xfee7 "Imputation field for FEE7 - Out-of-state graduate required fees"
label variable fee7 "Out-of-state graduate required fees"
label variable xhrchg7 "Imputation field for HRCHG7 - Out-of-state GR per credit hour charge"
label variable hrchg7 "Out-of-state GR per credit hour charge"
label variable xispro1 "Imputation field for ISPROF1 - Tuition FTFY Chiropractic"
label variable isprof1 "Tuition FTFY Chiropractic"
label variable xispfe1 "Imputation field for ISPFEE1 - Fees for FT in-state Chiropractic"
label variable ispfee1 "Fees for FT in-state Chiropractic"
label variable xospro1 "Imputation field for OSPROF1 - Tuition FTFY Chiro. out-of-state"
label variable osprof1 "Tuition FTFY Chiro. out-of-state"
label variable xospfe1 "Imputation field for OSPFEE1 - Fees for FT out-of-state Chiropractic"
label variable ospfee1 "Fees for FT out-of-state Chiropractic"
label variable xispro2 "Imputation field for ISPROF2 - Tuition FTFY Dentistry in-state"
label variable isprof2 "Tuition FTFY Dentistry in-state"
label variable xispfe2 "Imputation field for ISPFEE2 - Fees for Dentistry in-state"
label variable ispfee2 "Fees for Dentistry in-state"
label variable xospro2 "Imputation field for OSPROF2 - Tuition FTFY Dentistry out-state"
label variable osprof2 "Tuition FTFY Dentistry out-state"
label variable xospfe2 "Imputation field for OSPFEE2 - Fees for Dentistry out-of-state"
label variable ospfee2 "Fees for Dentistry out-of-state"
label variable xispro3 "Imputation field for ISPROF3 - Tuition FTFY Medicine in-state"
label variable isprof3 "Tuition FTFY Medicine in-state"
label variable xispfe3 "Imputation field for ISPFEE3 - Fees for Medicine in-state"
label variable ispfee3 "Fees for Medicine in-state"
label variable xospro3 "Imputation field for OSPROF3 - Tuition FTFY Medicine out-of-state"
label variable osprof3 "Tuition FTFY Medicine out-of-state"
label variable xospfe3 "Imputation field for OSPFEE3 - Fees for Medicine out-of-state"
label variable ospfee3 "Fees for Medicine out-of-state"
label variable xispro4 "Imputation field for ISPROF4 - Tuition FTFY Optometry in-state"
label variable isprof4 "Tuition FTFY Optometry in-state"
label variable xispfe4 "Imputation field for ISPFEE4 - Fees for Optometry in-state"
label variable ispfee4 "Fees for Optometry in-state"
label variable xospro4 "Imputation field for OSPROF4 - Tuition FTFY Optometry out-state"
label variable osprof4 "Tuition FTFY Optometry out-state"
label variable xospfe4 "Imputation field for OSPFEE4 - Fees for Optometry out-of-state"
label variable ospfee4 "Fees for Optometry out-of-state"
label variable xispro5 "Imputation field for ISPROF5 - Tuition FTFY Osteopathic Medicine"
label variable isprof5 "Tuition FTFY Osteopathic Medicine"
label variable xispfe5 "Imputation field for ISPFEE5 - Fees for Osteopathic in-state"
label variable ispfee5 "Fees for Osteopathic in-state"
label variable xospro5 "Imputation field for OSPROF5 - Tuition FTFY Osteopathic Medicine"
label variable osprof5 "Tuition FTFY Osteopathic Medicine"
label variable xospfe5 "Imputation field for OSPFEE5 - Fees for Osteopathic out-of-state"
label variable ospfee5 "Fees for Osteopathic out-of-state"
label variable xispro6 "Imputation field for ISPROF6 - Tuition FTFY Pharmacy in-state"
label variable isprof6 "Tuition FTFY Pharmacy in-state"
label variable xispfe6 "Imputation field for ISPFEE6 - Fees for Pharmacy in-state"
label variable ispfee6 "Fees for Pharmacy in-state"
label variable xospro6 "Imputation field for OSPROF6 - Tuition FTFY Pharmacy out-of-state"
label variable osprof6 "Tuition FTFY Pharmacy out-of-state"
label variable xospfe6 "Imputation field for OSPFEE6 - Fees for Pharmacy out-of-state"
label variable ospfee6 "Fees for Pharmacy out-of-state"
label variable xispro7 "Imputation field for ISPROF7 - Tuition FTFY Podiatry in-state"
label variable isprof7 "Tuition FTFY Podiatry in-state"
label variable xispfe7 "Imputation field for ISPFEE7 - Fees for Podiatry in-state"
label variable ispfee7 "Fees for Podiatry in-state"
label variable xospro7 "Imputation field for OSPROF7 - Tuition FTFY Podiatry out-of-state"
label variable osprof7 "Tuition FTFY Podiatry out-of-state"
label variable xospfe7 "Imputation field for OSPFEE7 - Fees for Podiatry out-of-state"
label variable ospfee7 "Fees for Podiatry out-of-state"
label variable xispro8 "Imputation field for ISPROF8 - Tuition FTFY Veterinary Medicine"
label variable isprof8 "Tuition FTFY Veterinary Medicine"
label variable xispfe8 "Imputation field for ISPFEE8 - Fees for Veterinary in-state"
label variable ispfee8 "Fees for Veterinary in-state"
label variable xospro8 "Imputation field for OSPROF8 - Tuition FTFY Veterinary Medicine"
label variable osprof8 "Tuition FTFY Veterinary Medicine"
label variable xospfe8 "Imputation field for OSPFEE8 - Fees for Veterinary out-of-state"
label variable ospfee8 "Fees for Veterinary out-of-state"
label variable xispro9 "Imputation field for ISPROF9 - Tuition FTFY Law in-state"
label variable isprof9 "Tuition FTFY Law in-state"
label variable xispfe9 "Imputation field for ISPFEE9 - Fees for Law in-state"
label variable ispfee9 "Fees for Law in-state"
label variable xospro9 "Imputation field for OSPROF9 - Tuition FTFY Law out-of-state"
label variable osprof9 "Tuition FTFY Law out-of-state"
label variable xospfe9 "Imputation field for OSPFEE9 - Fees for Law out-of-state"
label variable ospfee9 "Fees for Law out-of-state"
label variable xispro10 "Imputation field for ISPROF10 - Tuition FTFY Theology in-state"
label variable isprof10 "Tuition FTFY Theology in-state"
label variable xispfe10 "Imputation field for ISPFEE10 - Fees for Theology in-state"
label variable ispfee10 "Fees for Theology in-state"
label variable xospro10 "Imputation field for OSPROF10 - Tuition FTFY Theology out-of-state"
label variable osprof10 "Tuition FTFY Theology out-of-state"
label variable xospfe10 "Imputation field for OSPFEE10 - Fees for Theology out-of-state"
label variable ospfee10 "Fees for Theology out-of-state"
label variable xispro11 "Imputation field for ISPROF11 - Tuition FTFY Other 1stP, in-state"
label variable isprof11 "Tuition FTFY Other 1stP, in-state"
label variable xispfe11 "Imputation field for ISPFEE11 - Fees for Other 1stP in-state"
label variable ispfee11 "Fees for Other 1stP in-state"
label variable xospro11 "Imputation field for OSPROF11 - Tuition FTFY Other 1stP, out-state"
label variable osprof11 "Tuition FTFY Other 1stP, out-state"
label variable xospfe11 "Imputation field for OSPFEE11 - Fees for Other 1stP out-of-state"
label variable ospfee11 "Fees for Other 1stP out-of-state"
label variable xchg1ay1 "Imputation field for chg1ay1 - Published in-district tuition and fees  1998-1999"
label variable chg1ay1 "Published in-district tuition and fees  1998-1999"
label variable xchg1ay2 "Imputation field for chg1ay2 - Published in-district tuition and fees  1999-2000"
label variable chg1ay2 "Published in-district tuition and fees  1999-2000"
label variable xchg1ay3 "Imputation field for chg1ay3 - Published in-district tuition and fees  2000-2001"
label variable chg1ay3 "Published in-district tuition and fees  2000-2001"
label variable xchg2ay1 "Imputation field for chg2ay1 - Published in-state tuition and fees 1998-1999"
label variable chg2ay1 "Published in-state tuition and fees 1998-1999"
label variable xchg2ay2 "Imputation field for chg2ay2 - Published in-state tuition and fees 1999-2000"
label variable chg2ay2 "Published in-state tuition and fees 1999-2000"
label variable xchg2ay3 "Imputation field for chg2ay3 - Published in-state tuition and fees 2000-2001"
label variable chg2ay3 "Published in-state tuition and fees 2000-2001"
label variable xchg3ay1 "Imputation field for chg3ay1 - Published out-of-state tuition and fees  1998-1999"
label variable chg3ay1 "Published out-of-state tuition and fees  1998-1999"
label variable xchg3ay2 "Imputation field for chg3ay2 - Published out-of-state tuition and fees  1999-2000"
label variable chg3ay2 "Published out-of-state tuition and fees  1999-2000"
label variable xchg3ay3 "Imputation field for chg3ay3 - Published out-of-state tuition and fees  2000-2001"
label variable chg3ay3 "Published out-of-state tuition and fees  2000-2001"
label variable xchg4ay1 "Imputation field for chg4ay1 - Books and supplies 1998-1999"
label variable chg4ay1 "Books and supplies 1998-1999"
label variable xchg4ay2 "Imputation field for chg4ay2 - Books and supplies 1999-2000"
label variable chg4ay2 "Books and supplies 1999-2000"
label variable xchg4ay3 "Imputation field for chg4ay3 - Books and supplies 2000-2001"
label variable chg4ay3 "Books and supplies 2000-2001"
label variable xchg5ay1 "Imputation field for chg5ay1 - On campus, room and board 1998-1999"
label variable chg5ay1 "On campus, room and board 1998-1999"
label variable xchg5ay2 "Imputation field for chg5ay2 - On campus, room and board 1999-2000"
label variable chg5ay2 "On campus, room and board 1999-2000"
label variable xchg5ay3 "Imputation field for chg5ay3 - On campus, room and board 2000-2001"
label variable chg5ay3 "On campus, room and board 2000-2001"
label variable xchg6ay1 "Imputation field for chg6ay1 - On campus, other expenses 1998-1999"
label variable chg6ay1 "On campus, other expenses 1998-1999"
label variable xchg6ay2 "Imputation field for chg6ay2 - On campus, other expenses 1999-2000"
label variable chg6ay2 "On campus, other expenses 1999-2000"
label variable xchg6ay3 "Imputation field for chg6ay3 - On campus, other expenses 2000-2001"
label variable chg6ay3 "On campus, other expenses 2000-2001"
label variable xchg7ay1 "Imputation field for chg7ay1 - Off campus (not with family), room and board 1998-1999"
label variable chg7ay1 "Off campus (not with family), room and board 1998-1999"
label variable xchg7ay2 "Imputation field for chg7ay2 - Off campus (not with family), room and board 1999-2000"
label variable chg7ay2 "Off campus (not with family), room and board 1999-2000"
label variable xchg7ay3 "Imputation field for chg7ay3 - Off campus (not with family), room and board 2000-2001"
label variable chg7ay3 "Off campus (not with family), room and board 2000-2001"
label variable xchg8ay1 "Imputation field for chg8ay1 - Off campus (not with family), other expenses 1998-1999"
label variable chg8ay1 "Off campus (not with family), other expenses 1998-1999"
label variable xchg8ay2 "Imputation field for chg8ay2 - Off campus (not with family), other expenses 1999-2000"
label variable chg8ay2 "Off campus (not with family), other expenses 1999-2000"
label variable xchg8ay3 "Imputation field for chg8ay3 - Off campus (not with family), other expenses 2000-2001"
label variable chg8ay3 "Off campus (not with family), other expenses 2000-2001"
label variable xchg9ay1 "Imputation field for chg9ay1 - Off campus (with family), other expenses 1998-1999"
label variable chg9ay1 "Off campus (with family), other expenses 1998-1999"
label variable xchg9ay2 "Imputation field for chg9ay2 - Off campus (with family), other expenses 1999-2000"
label variable chg9ay2 "Off campus (with family), other expenses 1999-2000"
label variable xchg9ay3 "Imputation field for chg9ay3 - Off campus (with family), other expenses 2000-2001"
label variable chg9ay3 "Off campus (with family), other expenses 2000-2001"
label define label_xtuit1 10 "Reported" 
label define label_xtuit1 11 "Analyst corrected reported value", add 
label define label_xtuit1 12 "Data generated from other data values", add 
label define label_xtuit1 13 "Implied zero", add 
label define label_xtuit1 20 "Imputed using Carry Forward procedure", add 
label define label_xtuit1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xtuit1 30 "Not applicable", add 
label define label_xtuit1 31 "Institution left item blank", add 
label define label_xtuit1 32 "Do not know", add 
label define label_xtuit1 40 "Suppressed to protect confidentiality", add 
label values xtuit1 label_xtuit1
label define label_xfee1 10 "Reported" 
label define label_xfee1 11 "Analyst corrected reported value", add 
label define label_xfee1 12 "Data generated from other data values", add 
label define label_xfee1 13 "Implied zero", add 
label define label_xfee1 20 "Imputed using Carry Forward procedure", add 
label define label_xfee1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xfee1 30 "Not applicable", add 
label define label_xfee1 31 "Institution left item blank", add 
label define label_xfee1 32 "Do not know", add 
label define label_xfee1 40 "Suppressed to protect confidentiality", add 
label values xfee1 label_xfee1
label define label_xhrchg1 10 "Reported" 
label define label_xhrchg1 11 "Analyst corrected reported value", add 
label define label_xhrchg1 12 "Data generated from other data values", add 
label define label_xhrchg1 13 "Implied zero", add 
label define label_xhrchg1 20 "Imputed using Carry Forward procedure", add 
label define label_xhrchg1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xhrchg1 30 "Not applicable", add 
label define label_xhrchg1 31 "Institution left item blank", add 
label define label_xhrchg1 32 "Do not know", add 
label define label_xhrchg1 40 "Suppressed to protect confidentiality", add 
label values xhrchg1 label_xhrchg1
label define label_xcmpfee1 10 "Reported" 
label define label_xcmpfee1 11 "Analyst corrected reported value", add 
label define label_xcmpfee1 12 "Data generated from other data values", add 
label define label_xcmpfee1 13 "Implied zero", add 
label define label_xcmpfee1 20 "Imputed using Carry Forward procedure", add 
label define label_xcmpfee1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xcmpfee1 30 "Not applicable", add 
label define label_xcmpfee1 31 "Institution left item blank", add 
label define label_xcmpfee1 32 "Do not know", add 
label define label_xcmpfee1 40 "Suppressed to protect confidentiality", add 
label values xcmpfee1 label_xcmpfee1
label define label_xtuit2 10 "Reported" 
label define label_xtuit2 11 "Analyst corrected reported value", add 
label define label_xtuit2 12 "Data generated from other data values", add 
label define label_xtuit2 13 "Implied zero", add 
label define label_xtuit2 20 "Imputed using Carry Forward procedure", add 
label define label_xtuit2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xtuit2 30 "Not applicable", add 
label define label_xtuit2 31 "Institution left item blank", add 
label define label_xtuit2 32 "Do not know", add 
label define label_xtuit2 40 "Suppressed to protect confidentiality", add 
label values xtuit2 label_xtuit2
label define label_xfee2 10 "Reported" 
label define label_xfee2 11 "Analyst corrected reported value", add 
label define label_xfee2 12 "Data generated from other data values", add 
label define label_xfee2 13 "Implied zero", add 
label define label_xfee2 20 "Imputed using Carry Forward procedure", add 
label define label_xfee2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xfee2 30 "Not applicable", add 
label define label_xfee2 31 "Institution left item blank", add 
label define label_xfee2 32 "Do not know", add 
label define label_xfee2 40 "Suppressed to protect confidentiality", add 
label values xfee2 label_xfee2
label define label_xhrchg2 10 "Reported" 
label define label_xhrchg2 11 "Analyst corrected reported value", add 
label define label_xhrchg2 12 "Data generated from other data values", add 
label define label_xhrchg2 13 "Implied zero", add 
label define label_xhrchg2 20 "Imputed using Carry Forward procedure", add 
label define label_xhrchg2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xhrchg2 30 "Not applicable", add 
label define label_xhrchg2 31 "Institution left item blank", add 
label define label_xhrchg2 32 "Do not know", add 
label define label_xhrchg2 40 "Suppressed to protect confidentiality", add 
label values xhrchg2 label_xhrchg2
label define label_xcmpfee2 10 "Reported" 
label define label_xcmpfee2 11 "Analyst corrected reported value", add 
label define label_xcmpfee2 12 "Data generated from other data values", add 
label define label_xcmpfee2 13 "Implied zero", add 
label define label_xcmpfee2 20 "Imputed using Carry Forward procedure", add 
label define label_xcmpfee2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xcmpfee2 30 "Not applicable", add 
label define label_xcmpfee2 31 "Institution left item blank", add 
label define label_xcmpfee2 32 "Do not know", add 
label define label_xcmpfee2 40 "Suppressed to protect confidentiality", add 
label values xcmpfee2 label_xcmpfee2
label define label_xtuit3 10 "Reported" 
label define label_xtuit3 11 "Analyst corrected reported value", add 
label define label_xtuit3 12 "Data generated from other data values", add 
label define label_xtuit3 13 "Implied zero", add 
label define label_xtuit3 20 "Imputed using Carry Forward procedure", add 
label define label_xtuit3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xtuit3 30 "Not applicable", add 
label define label_xtuit3 31 "Institution left item blank", add 
label define label_xtuit3 32 "Do not know", add 
label define label_xtuit3 40 "Suppressed to protect confidentiality", add 
label values xtuit3 label_xtuit3
label define label_xfee3 10 "Reported" 
label define label_xfee3 11 "Analyst corrected reported value", add 
label define label_xfee3 12 "Data generated from other data values", add 
label define label_xfee3 13 "Implied zero", add 
label define label_xfee3 20 "Imputed using Carry Forward procedure", add 
label define label_xfee3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xfee3 30 "Not applicable", add 
label define label_xfee3 31 "Institution left item blank", add 
label define label_xfee3 32 "Do not know", add 
label define label_xfee3 40 "Suppressed to protect confidentiality", add 
label values xfee3 label_xfee3
label define label_xhrchg3 10 "Reported" 
label define label_xhrchg3 11 "Analyst corrected reported value", add 
label define label_xhrchg3 12 "Data generated from other data values", add 
label define label_xhrchg3 13 "Implied zero", add 
label define label_xhrchg3 20 "Imputed using Carry Forward procedure", add 
label define label_xhrchg3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xhrchg3 30 "Not applicable", add 
label define label_xhrchg3 31 "Institution left item blank", add 
label define label_xhrchg3 32 "Do not know", add 
label define label_xhrchg3 40 "Suppressed to protect confidentiality", add 
label values xhrchg3 label_xhrchg3
label define label_xcmpfee3 10 "Reported" 
label define label_xcmpfee3 11 "Analyst corrected reported value", add 
label define label_xcmpfee3 12 "Data generated from other data values", add 
label define label_xcmpfee3 13 "Implied zero", add 
label define label_xcmpfee3 20 "Imputed using Carry Forward procedure", add 
label define label_xcmpfee3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xcmpfee3 30 "Not applicable", add 
label define label_xcmpfee3 31 "Institution left item blank", add 
label define label_xcmpfee3 32 "Do not know", add 
label define label_xcmpfee3 40 "Suppressed to protect confidentiality", add 
label values xcmpfee3 label_xcmpfee3
label define label_xtuit5 10 "Reported" 
label define label_xtuit5 11 "Analyst corrected reported value", add 
label define label_xtuit5 12 "Data generated from other data values", add 
label define label_xtuit5 13 "Implied zero", add 
label define label_xtuit5 20 "Imputed using Carry Forward procedure", add 
label define label_xtuit5 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xtuit5 30 "Not applicable", add 
label define label_xtuit5 31 "Institution left item blank", add 
label define label_xtuit5 32 "Do not know", add 
label define label_xtuit5 40 "Suppressed to protect confidentiality", add 
label values xtuit5 label_xtuit5
label define label_xfee5 10 "Reported" 
label define label_xfee5 11 "Analyst corrected reported value", add 
label define label_xfee5 12 "Data generated from other data values", add 
label define label_xfee5 13 "Implied zero", add 
label define label_xfee5 20 "Imputed using Carry Forward procedure", add 
label define label_xfee5 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xfee5 30 "Not applicable", add 
label define label_xfee5 31 "Institution left item blank", add 
label define label_xfee5 32 "Do not know", add 
label define label_xfee5 40 "Suppressed to protect confidentiality", add 
label values xfee5 label_xfee5
label define label_xhrchg5 10 "Reported" 
label define label_xhrchg5 11 "Analyst corrected reported value", add 
label define label_xhrchg5 12 "Data generated from other data values", add 
label define label_xhrchg5 13 "Implied zero", add 
label define label_xhrchg5 20 "Imputed using Carry Forward procedure", add 
label define label_xhrchg5 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xhrchg5 30 "Not applicable", add 
label define label_xhrchg5 31 "Institution left item blank", add 
label define label_xhrchg5 32 "Do not know", add 
label define label_xhrchg5 40 "Suppressed to protect confidentiality", add 
label values xhrchg5 label_xhrchg5
label define label_xtuit6 10 "Reported" 
label define label_xtuit6 11 "Analyst corrected reported value", add 
label define label_xtuit6 12 "Data generated from other data values", add 
label define label_xtuit6 13 "Implied zero", add 
label define label_xtuit6 20 "Imputed using Carry Forward procedure", add 
label define label_xtuit6 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xtuit6 30 "Not applicable", add 
label define label_xtuit6 31 "Institution left item blank", add 
label define label_xtuit6 32 "Do not know", add 
label define label_xtuit6 40 "Suppressed to protect confidentiality", add 
label values xtuit6 label_xtuit6
label define label_xfee6 10 "Reported" 
label define label_xfee6 11 "Analyst corrected reported value", add 
label define label_xfee6 12 "Data generated from other data values", add 
label define label_xfee6 13 "Implied zero", add 
label define label_xfee6 20 "Imputed using Carry Forward procedure", add 
label define label_xfee6 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xfee6 30 "Not applicable", add 
label define label_xfee6 31 "Institution left item blank", add 
label define label_xfee6 32 "Do not know", add 
label define label_xfee6 40 "Suppressed to protect confidentiality", add 
label values xfee6 label_xfee6
label define label_xhrchg6 10 "Reported" 
label define label_xhrchg6 11 "Analyst corrected reported value", add 
label define label_xhrchg6 12 "Data generated from other data values", add 
label define label_xhrchg6 13 "Implied zero", add 
label define label_xhrchg6 20 "Imputed using Carry Forward procedure", add 
label define label_xhrchg6 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xhrchg6 30 "Not applicable", add 
label define label_xhrchg6 31 "Institution left item blank", add 
label define label_xhrchg6 32 "Do not know", add 
label define label_xhrchg6 40 "Suppressed to protect confidentiality", add 
label values xhrchg6 label_xhrchg6
label define label_xtuit7 10 "Reported" 
label define label_xtuit7 11 "Analyst corrected reported value", add 
label define label_xtuit7 12 "Data generated from other data values", add 
label define label_xtuit7 13 "Implied zero", add 
label define label_xtuit7 20 "Imputed using Carry Forward procedure", add 
label define label_xtuit7 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xtuit7 30 "Not applicable", add 
label define label_xtuit7 31 "Institution left item blank", add 
label define label_xtuit7 32 "Do not know", add 
label define label_xtuit7 40 "Suppressed to protect confidentiality", add 
label values xtuit7 label_xtuit7
label define label_xfee7 10 "Reported" 
label define label_xfee7 11 "Analyst corrected reported value", add 
label define label_xfee7 12 "Data generated from other data values", add 
label define label_xfee7 13 "Implied zero", add 
label define label_xfee7 20 "Imputed using Carry Forward procedure", add 
label define label_xfee7 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xfee7 30 "Not applicable", add 
label define label_xfee7 31 "Institution left item blank", add 
label define label_xfee7 32 "Do not know", add 
label define label_xfee7 40 "Suppressed to protect confidentiality", add 
label values xfee7 label_xfee7
label define label_xhrchg7 10 "Reported" 
label define label_xhrchg7 11 "Analyst corrected reported value", add 
label define label_xhrchg7 12 "Data generated from other data values", add 
label define label_xhrchg7 13 "Implied zero", add 
label define label_xhrchg7 20 "Imputed using Carry Forward procedure", add 
label define label_xhrchg7 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xhrchg7 30 "Not applicable", add 
label define label_xhrchg7 31 "Institution left item blank", add 
label define label_xhrchg7 32 "Do not know", add 
label define label_xhrchg7 40 "Suppressed to protect confidentiality", add 
label values xhrchg7 label_xhrchg7
label define label_xispro1 10 "Reported" 
label define label_xispro1 11 "Analyst corrected reported value", add 
label define label_xispro1 12 "Data generated from other data values", add 
label define label_xispro1 13 "Implied zero", add 
label define label_xispro1 20 "Imputed using Carry Forward procedure", add 
label define label_xispro1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispro1 30 "Not applicable", add 
label define label_xispro1 31 "Institution left item blank", add 
label define label_xispro1 32 "Do not know", add 
label define label_xispro1 40 "Suppressed to protect confidentiality", add 
label values xispro1 label_xispro1
label define label_xispfe1 10 "Reported" 
label define label_xispfe1 11 "Analyst corrected reported value", add 
label define label_xispfe1 12 "Data generated from other data values", add 
label define label_xispfe1 13 "Implied zero", add 
label define label_xispfe1 20 "Imputed using Carry Forward procedure", add 
label define label_xispfe1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispfe1 30 "Not applicable", add 
label define label_xispfe1 31 "Institution left item blank", add 
label define label_xispfe1 32 "Do not know", add 
label define label_xispfe1 40 "Suppressed to protect confidentiality", add 
label values xispfe1 label_xispfe1
label define label_xospro1 10 "Reported" 
label define label_xospro1 11 "Analyst corrected reported value", add 
label define label_xospro1 12 "Data generated from other data values", add 
label define label_xospro1 13 "Implied zero", add 
label define label_xospro1 20 "Imputed using Carry Forward procedure", add 
label define label_xospro1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospro1 30 "Not applicable", add 
label define label_xospro1 31 "Institution left item blank", add 
label define label_xospro1 32 "Do not know", add 
label define label_xospro1 40 "Suppressed to protect confidentiality", add 
label values xospro1 label_xospro1
label define label_xospfe1 10 "Reported" 
label define label_xospfe1 11 "Analyst corrected reported value", add 
label define label_xospfe1 12 "Data generated from other data values", add 
label define label_xospfe1 13 "Implied zero", add 
label define label_xospfe1 20 "Imputed using Carry Forward procedure", add 
label define label_xospfe1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospfe1 30 "Not applicable", add 
label define label_xospfe1 31 "Institution left item blank", add 
label define label_xospfe1 32 "Do not know", add 
label define label_xospfe1 40 "Suppressed to protect confidentiality", add 
label values xospfe1 label_xospfe1
label define label_xispro2 10 "Reported" 
label define label_xispro2 11 "Analyst corrected reported value", add 
label define label_xispro2 12 "Data generated from other data values", add 
label define label_xispro2 13 "Implied zero", add 
label define label_xispro2 20 "Imputed using Carry Forward procedure", add 
label define label_xispro2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispro2 30 "Not applicable", add 
label define label_xispro2 31 "Institution left item blank", add 
label define label_xispro2 32 "Do not know", add 
label define label_xispro2 40 "Suppressed to protect confidentiality", add 
label values xispro2 label_xispro2
label define label_xispfe2 10 "Reported" 
label define label_xispfe2 11 "Analyst corrected reported value", add 
label define label_xispfe2 12 "Data generated from other data values", add 
label define label_xispfe2 13 "Implied zero", add 
label define label_xispfe2 20 "Imputed using Carry Forward procedure", add 
label define label_xispfe2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispfe2 30 "Not applicable", add 
label define label_xispfe2 31 "Institution left item blank", add 
label define label_xispfe2 32 "Do not know", add 
label define label_xispfe2 40 "Suppressed to protect confidentiality", add 
label values xispfe2 label_xispfe2
label define label_xospro2 10 "Reported" 
label define label_xospro2 11 "Analyst corrected reported value", add 
label define label_xospro2 12 "Data generated from other data values", add 
label define label_xospro2 13 "Implied zero", add 
label define label_xospro2 20 "Imputed using Carry Forward procedure", add 
label define label_xospro2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospro2 30 "Not applicable", add 
label define label_xospro2 31 "Institution left item blank", add 
label define label_xospro2 32 "Do not know", add 
label define label_xospro2 40 "Suppressed to protect confidentiality", add 
label values xospro2 label_xospro2
label define label_xospfe2 10 "Reported" 
label define label_xospfe2 11 "Analyst corrected reported value", add 
label define label_xospfe2 12 "Data generated from other data values", add 
label define label_xospfe2 13 "Implied zero", add 
label define label_xospfe2 20 "Imputed using Carry Forward procedure", add 
label define label_xospfe2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospfe2 30 "Not applicable", add 
label define label_xospfe2 31 "Institution left item blank", add 
label define label_xospfe2 32 "Do not know", add 
label define label_xospfe2 40 "Suppressed to protect confidentiality", add 
label values xospfe2 label_xospfe2
label define label_xispro3 10 "Reported" 
label define label_xispro3 11 "Analyst corrected reported value", add 
label define label_xispro3 12 "Data generated from other data values", add 
label define label_xispro3 13 "Implied zero", add 
label define label_xispro3 20 "Imputed using Carry Forward procedure", add 
label define label_xispro3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispro3 30 "Not applicable", add 
label define label_xispro3 31 "Institution left item blank", add 
label define label_xispro3 32 "Do not know", add 
label define label_xispro3 40 "Suppressed to protect confidentiality", add 
label values xispro3 label_xispro3
label define label_xispfe3 10 "Reported" 
label define label_xispfe3 11 "Analyst corrected reported value", add 
label define label_xispfe3 12 "Data generated from other data values", add 
label define label_xispfe3 13 "Implied zero", add 
label define label_xispfe3 20 "Imputed using Carry Forward procedure", add 
label define label_xispfe3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispfe3 30 "Not applicable", add 
label define label_xispfe3 31 "Institution left item blank", add 
label define label_xispfe3 32 "Do not know", add 
label define label_xispfe3 40 "Suppressed to protect confidentiality", add 
label values xispfe3 label_xispfe3
label define label_xospro3 10 "Reported" 
label define label_xospro3 11 "Analyst corrected reported value", add 
label define label_xospro3 12 "Data generated from other data values", add 
label define label_xospro3 13 "Implied zero", add 
label define label_xospro3 20 "Imputed using Carry Forward procedure", add 
label define label_xospro3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospro3 30 "Not applicable", add 
label define label_xospro3 31 "Institution left item blank", add 
label define label_xospro3 32 "Do not know", add 
label define label_xospro3 40 "Suppressed to protect confidentiality", add 
label values xospro3 label_xospro3
label define label_xospfe3 10 "Reported" 
label define label_xospfe3 11 "Analyst corrected reported value", add 
label define label_xospfe3 12 "Data generated from other data values", add 
label define label_xospfe3 13 "Implied zero", add 
label define label_xospfe3 20 "Imputed using Carry Forward procedure", add 
label define label_xospfe3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospfe3 30 "Not applicable", add 
label define label_xospfe3 31 "Institution left item blank", add 
label define label_xospfe3 32 "Do not know", add 
label define label_xospfe3 40 "Suppressed to protect confidentiality", add 
label values xospfe3 label_xospfe3
label define label_xispro4 10 "Reported" 
label define label_xispro4 11 "Analyst corrected reported value", add 
label define label_xispro4 12 "Data generated from other data values", add 
label define label_xispro4 13 "Implied zero", add 
label define label_xispro4 20 "Imputed using Carry Forward procedure", add 
label define label_xispro4 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispro4 30 "Not applicable", add 
label define label_xispro4 31 "Institution left item blank", add 
label define label_xispro4 32 "Do not know", add 
label define label_xispro4 40 "Suppressed to protect confidentiality", add 
label values xispro4 label_xispro4
label define label_xispfe4 10 "Reported" 
label define label_xispfe4 11 "Analyst corrected reported value", add 
label define label_xispfe4 12 "Data generated from other data values", add 
label define label_xispfe4 13 "Implied zero", add 
label define label_xispfe4 20 "Imputed using Carry Forward procedure", add 
label define label_xispfe4 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispfe4 30 "Not applicable", add 
label define label_xispfe4 31 "Institution left item blank", add 
label define label_xispfe4 32 "Do not know", add 
label define label_xispfe4 40 "Suppressed to protect confidentiality", add 
label values xispfe4 label_xispfe4
label define label_xospro4 10 "Reported" 
label define label_xospro4 11 "Analyst corrected reported value", add 
label define label_xospro4 12 "Data generated from other data values", add 
label define label_xospro4 13 "Implied zero", add 
label define label_xospro4 20 "Imputed using Carry Forward procedure", add 
label define label_xospro4 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospro4 30 "Not applicable", add 
label define label_xospro4 31 "Institution left item blank", add 
label define label_xospro4 32 "Do not know", add 
label define label_xospro4 40 "Suppressed to protect confidentiality", add 
label values xospro4 label_xospro4
label define label_xospfe4 10 "Reported" 
label define label_xospfe4 11 "Analyst corrected reported value", add 
label define label_xospfe4 12 "Data generated from other data values", add 
label define label_xospfe4 13 "Implied zero", add 
label define label_xospfe4 20 "Imputed using Carry Forward procedure", add 
label define label_xospfe4 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospfe4 30 "Not applicable", add 
label define label_xospfe4 31 "Institution left item blank", add 
label define label_xospfe4 32 "Do not know", add 
label define label_xospfe4 40 "Suppressed to protect confidentiality", add 
label values xospfe4 label_xospfe4
label define label_xispro5 10 "Reported" 
label define label_xispro5 11 "Analyst corrected reported value", add 
label define label_xispro5 12 "Data generated from other data values", add 
label define label_xispro5 13 "Implied zero", add 
label define label_xispro5 20 "Imputed using Carry Forward procedure", add 
label define label_xispro5 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispro5 30 "Not applicable", add 
label define label_xispro5 31 "Institution left item blank", add 
label define label_xispro5 32 "Do not know", add 
label define label_xispro5 40 "Suppressed to protect confidentiality", add 
label values xispro5 label_xispro5
label define label_xispfe5 10 "Reported" 
label define label_xispfe5 11 "Analyst corrected reported value", add 
label define label_xispfe5 12 "Data generated from other data values", add 
label define label_xispfe5 13 "Implied zero", add 
label define label_xispfe5 20 "Imputed using Carry Forward procedure", add 
label define label_xispfe5 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispfe5 30 "Not applicable", add 
label define label_xispfe5 31 "Institution left item blank", add 
label define label_xispfe5 32 "Do not know", add 
label define label_xispfe5 40 "Suppressed to protect confidentiality", add 
label values xispfe5 label_xispfe5
label define label_xospro5 10 "Reported" 
label define label_xospro5 11 "Analyst corrected reported value", add 
label define label_xospro5 12 "Data generated from other data values", add 
label define label_xospro5 13 "Implied zero", add 
label define label_xospro5 20 "Imputed using Carry Forward procedure", add 
label define label_xospro5 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospro5 30 "Not applicable", add 
label define label_xospro5 31 "Institution left item blank", add 
label define label_xospro5 32 "Do not know", add 
label define label_xospro5 40 "Suppressed to protect confidentiality", add 
label values xospro5 label_xospro5
label define label_xospfe5 10 "Reported" 
label define label_xospfe5 11 "Analyst corrected reported value", add 
label define label_xospfe5 12 "Data generated from other data values", add 
label define label_xospfe5 13 "Implied zero", add 
label define label_xospfe5 20 "Imputed using Carry Forward procedure", add 
label define label_xospfe5 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospfe5 30 "Not applicable", add 
label define label_xospfe5 31 "Institution left item blank", add 
label define label_xospfe5 32 "Do not know", add 
label define label_xospfe5 40 "Suppressed to protect confidentiality", add 
label values xospfe5 label_xospfe5
label define label_xispro6 10 "Reported" 
label define label_xispro6 11 "Analyst corrected reported value", add 
label define label_xispro6 12 "Data generated from other data values", add 
label define label_xispro6 13 "Implied zero", add 
label define label_xispro6 20 "Imputed using Carry Forward procedure", add 
label define label_xispro6 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispro6 30 "Not applicable", add 
label define label_xispro6 31 "Institution left item blank", add 
label define label_xispro6 32 "Do not know", add 
label define label_xispro6 40 "Suppressed to protect confidentiality", add 
label values xispro6 label_xispro6
label define label_xispfe6 10 "Reported" 
label define label_xispfe6 11 "Analyst corrected reported value", add 
label define label_xispfe6 12 "Data generated from other data values", add 
label define label_xispfe6 13 "Implied zero", add 
label define label_xispfe6 20 "Imputed using Carry Forward procedure", add 
label define label_xispfe6 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispfe6 30 "Not applicable", add 
label define label_xispfe6 31 "Institution left item blank", add 
label define label_xispfe6 32 "Do not know", add 
label define label_xispfe6 40 "Suppressed to protect confidentiality", add 
label values xispfe6 label_xispfe6
label define label_xospro6 10 "Reported" 
label define label_xospro6 11 "Analyst corrected reported value", add 
label define label_xospro6 12 "Data generated from other data values", add 
label define label_xospro6 13 "Implied zero", add 
label define label_xospro6 20 "Imputed using Carry Forward procedure", add 
label define label_xospro6 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospro6 30 "Not applicable", add 
label define label_xospro6 31 "Institution left item blank", add 
label define label_xospro6 32 "Do not know", add 
label define label_xospro6 40 "Suppressed to protect confidentiality", add 
label values xospro6 label_xospro6
label define label_xospfe6 10 "Reported" 
label define label_xospfe6 11 "Analyst corrected reported value", add 
label define label_xospfe6 12 "Data generated from other data values", add 
label define label_xospfe6 13 "Implied zero", add 
label define label_xospfe6 20 "Imputed using Carry Forward procedure", add 
label define label_xospfe6 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospfe6 30 "Not applicable", add 
label define label_xospfe6 31 "Institution left item blank", add 
label define label_xospfe6 32 "Do not know", add 
label define label_xospfe6 40 "Suppressed to protect confidentiality", add 
label values xospfe6 label_xospfe6
label define label_xispro7 10 "Reported" 
label define label_xispro7 11 "Analyst corrected reported value", add 
label define label_xispro7 12 "Data generated from other data values", add 
label define label_xispro7 13 "Implied zero", add 
label define label_xispro7 20 "Imputed using Carry Forward procedure", add 
label define label_xispro7 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispro7 30 "Not applicable", add 
label define label_xispro7 31 "Institution left item blank", add 
label define label_xispro7 32 "Do not know", add 
label define label_xispro7 40 "Suppressed to protect confidentiality", add 
label values xispro7 label_xispro7
label define label_xispfe7 10 "Reported" 
label define label_xispfe7 11 "Analyst corrected reported value", add 
label define label_xispfe7 12 "Data generated from other data values", add 
label define label_xispfe7 13 "Implied zero", add 
label define label_xispfe7 20 "Imputed using Carry Forward procedure", add 
label define label_xispfe7 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispfe7 30 "Not applicable", add 
label define label_xispfe7 31 "Institution left item blank", add 
label define label_xispfe7 32 "Do not know", add 
label define label_xispfe7 40 "Suppressed to protect confidentiality", add 
label values xispfe7 label_xispfe7
label define label_xospro7 10 "Reported" 
label define label_xospro7 11 "Analyst corrected reported value", add 
label define label_xospro7 12 "Data generated from other data values", add 
label define label_xospro7 13 "Implied zero", add 
label define label_xospro7 20 "Imputed using Carry Forward procedure", add 
label define label_xospro7 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospro7 30 "Not applicable", add 
label define label_xospro7 31 "Institution left item blank", add 
label define label_xospro7 32 "Do not know", add 
label define label_xospro7 40 "Suppressed to protect confidentiality", add 
label values xospro7 label_xospro7
label define label_xospfe7 10 "Reported" 
label define label_xospfe7 11 "Analyst corrected reported value", add 
label define label_xospfe7 12 "Data generated from other data values", add 
label define label_xospfe7 13 "Implied zero", add 
label define label_xospfe7 20 "Imputed using Carry Forward procedure", add 
label define label_xospfe7 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospfe7 30 "Not applicable", add 
label define label_xospfe7 31 "Institution left item blank", add 
label define label_xospfe7 32 "Do not know", add 
label define label_xospfe7 40 "Suppressed to protect confidentiality", add 
label values xospfe7 label_xospfe7
label define label_xispro8 10 "Reported" 
label define label_xispro8 11 "Analyst corrected reported value", add 
label define label_xispro8 12 "Data generated from other data values", add 
label define label_xispro8 13 "Implied zero", add 
label define label_xispro8 20 "Imputed using Carry Forward procedure", add 
label define label_xispro8 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispro8 30 "Not applicable", add 
label define label_xispro8 31 "Institution left item blank", add 
label define label_xispro8 32 "Do not know", add 
label define label_xispro8 40 "Suppressed to protect confidentiality", add 
label values xispro8 label_xispro8
label define label_xispfe8 10 "Reported" 
label define label_xispfe8 11 "Analyst corrected reported value", add 
label define label_xispfe8 12 "Data generated from other data values", add 
label define label_xispfe8 13 "Implied zero", add 
label define label_xispfe8 20 "Imputed using Carry Forward procedure", add 
label define label_xispfe8 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispfe8 30 "Not applicable", add 
label define label_xispfe8 31 "Institution left item blank", add 
label define label_xispfe8 32 "Do not know", add 
label define label_xispfe8 40 "Suppressed to protect confidentiality", add 
label values xispfe8 label_xispfe8
label define label_xospro8 10 "Reported" 
label define label_xospro8 11 "Analyst corrected reported value", add 
label define label_xospro8 12 "Data generated from other data values", add 
label define label_xospro8 13 "Implied zero", add 
label define label_xospro8 20 "Imputed using Carry Forward procedure", add 
label define label_xospro8 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospro8 30 "Not applicable", add 
label define label_xospro8 31 "Institution left item blank", add 
label define label_xospro8 32 "Do not know", add 
label define label_xospro8 40 "Suppressed to protect confidentiality", add 
label values xospro8 label_xospro8
label define label_xospfe8 10 "Reported" 
label define label_xospfe8 11 "Analyst corrected reported value", add 
label define label_xospfe8 12 "Data generated from other data values", add 
label define label_xospfe8 13 "Implied zero", add 
label define label_xospfe8 20 "Imputed using Carry Forward procedure", add 
label define label_xospfe8 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospfe8 30 "Not applicable", add 
label define label_xospfe8 31 "Institution left item blank", add 
label define label_xospfe8 32 "Do not know", add 
label define label_xospfe8 40 "Suppressed to protect confidentiality", add 
label values xospfe8 label_xospfe8
label define label_xispro9 10 "Reported" 
label define label_xispro9 11 "Analyst corrected reported value", add 
label define label_xispro9 12 "Data generated from other data values", add 
label define label_xispro9 13 "Implied zero", add 
label define label_xispro9 20 "Imputed using Carry Forward procedure", add 
label define label_xispro9 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispro9 30 "Not applicable", add 
label define label_xispro9 31 "Institution left item blank", add 
label define label_xispro9 32 "Do not know", add 
label define label_xispro9 40 "Suppressed to protect confidentiality", add 
label values xispro9 label_xispro9
label define label_xispfe9 10 "Reported" 
label define label_xispfe9 11 "Analyst corrected reported value", add 
label define label_xispfe9 12 "Data generated from other data values", add 
label define label_xispfe9 13 "Implied zero", add 
label define label_xispfe9 20 "Imputed using Carry Forward procedure", add 
label define label_xispfe9 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispfe9 30 "Not applicable", add 
label define label_xispfe9 31 "Institution left item blank", add 
label define label_xispfe9 32 "Do not know", add 
label define label_xispfe9 40 "Suppressed to protect confidentiality", add 
label values xispfe9 label_xispfe9
label define label_xospro9 10 "Reported" 
label define label_xospro9 11 "Analyst corrected reported value", add 
label define label_xospro9 12 "Data generated from other data values", add 
label define label_xospro9 13 "Implied zero", add 
label define label_xospro9 20 "Imputed using Carry Forward procedure", add 
label define label_xospro9 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospro9 30 "Not applicable", add 
label define label_xospro9 31 "Institution left item blank", add 
label define label_xospro9 32 "Do not know", add 
label define label_xospro9 40 "Suppressed to protect confidentiality", add 
label values xospro9 label_xospro9
label define label_xospfe9 10 "Reported" 
label define label_xospfe9 11 "Analyst corrected reported value", add 
label define label_xospfe9 12 "Data generated from other data values", add 
label define label_xospfe9 13 "Implied zero", add 
label define label_xospfe9 20 "Imputed using Carry Forward procedure", add 
label define label_xospfe9 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospfe9 30 "Not applicable", add 
label define label_xospfe9 31 "Institution left item blank", add 
label define label_xospfe9 32 "Do not know", add 
label define label_xospfe9 40 "Suppressed to protect confidentiality", add 
label values xospfe9 label_xospfe9
label define label_xispro10 10 "Reported" 
label define label_xispro10 11 "Analyst corrected reported value", add 
label define label_xispro10 12 "Data generated from other data values", add 
label define label_xispro10 13 "Implied zero", add 
label define label_xispro10 20 "Imputed using Carry Forward procedure", add 
label define label_xispro10 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispro10 30 "Not applicable", add 
label define label_xispro10 31 "Institution left item blank", add 
label define label_xispro10 32 "Do not know", add 
label define label_xispro10 40 "Suppressed to protect confidentiality", add 
label values xispro10 label_xispro10
label define label_xispfe10 10 "Reported" 
label define label_xispfe10 11 "Analyst corrected reported value", add 
label define label_xispfe10 12 "Data generated from other data values", add 
label define label_xispfe10 13 "Implied zero", add 
label define label_xispfe10 20 "Imputed using Carry Forward procedure", add 
label define label_xispfe10 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispfe10 30 "Not applicable", add 
label define label_xispfe10 31 "Institution left item blank", add 
label define label_xispfe10 32 "Do not know", add 
label define label_xispfe10 40 "Suppressed to protect confidentiality", add 
label values xispfe10 label_xispfe10
label define label_xospro10 10 "Reported" 
label define label_xospro10 11 "Analyst corrected reported value", add 
label define label_xospro10 12 "Data generated from other data values", add 
label define label_xospro10 13 "Implied zero", add 
label define label_xospro10 20 "Imputed using Carry Forward procedure", add 
label define label_xospro10 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospro10 30 "Not applicable", add 
label define label_xospro10 31 "Institution left item blank", add 
label define label_xospro10 32 "Do not know", add 
label define label_xospro10 40 "Suppressed to protect confidentiality", add 
label values xospro10 label_xospro10
label define label_xospfe10 10 "Reported" 
label define label_xospfe10 11 "Analyst corrected reported value", add 
label define label_xospfe10 12 "Data generated from other data values", add 
label define label_xospfe10 13 "Implied zero", add 
label define label_xospfe10 20 "Imputed using Carry Forward procedure", add 
label define label_xospfe10 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospfe10 30 "Not applicable", add 
label define label_xospfe10 31 "Institution left item blank", add 
label define label_xospfe10 32 "Do not know", add 
label define label_xospfe10 40 "Suppressed to protect confidentiality", add 
label values xospfe10 label_xospfe10
label define label_xispro11 10 "Reported" 
label define label_xispro11 11 "Analyst corrected reported value", add 
label define label_xispro11 12 "Data generated from other data values", add 
label define label_xispro11 13 "Implied zero", add 
label define label_xispro11 20 "Imputed using Carry Forward procedure", add 
label define label_xispro11 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispro11 30 "Not applicable", add 
label define label_xispro11 31 "Institution left item blank", add 
label define label_xispro11 32 "Do not know", add 
label define label_xispro11 40 "Suppressed to protect confidentiality", add 
label values xispro11 label_xispro11
label define label_xispfe11 10 "Reported" 
label define label_xispfe11 11 "Analyst corrected reported value", add 
label define label_xispfe11 12 "Data generated from other data values", add 
label define label_xispfe11 13 "Implied zero", add 
label define label_xispfe11 20 "Imputed using Carry Forward procedure", add 
label define label_xispfe11 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xispfe11 30 "Not applicable", add 
label define label_xispfe11 31 "Institution left item blank", add 
label define label_xispfe11 32 "Do not know", add 
label define label_xispfe11 40 "Suppressed to protect confidentiality", add 
label values xispfe11 label_xispfe11
label define label_xospro11 10 "Reported" 
label define label_xospro11 11 "Analyst corrected reported value", add 
label define label_xospro11 12 "Data generated from other data values", add 
label define label_xospro11 13 "Implied zero", add 
label define label_xospro11 20 "Imputed using Carry Forward procedure", add 
label define label_xospro11 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospro11 30 "Not applicable", add 
label define label_xospro11 31 "Institution left item blank", add 
label define label_xospro11 32 "Do not know", add 
label define label_xospro11 40 "Suppressed to protect confidentiality", add 
label values xospro11 label_xospro11
label define label_xospfe11 10 "Reported" 
label define label_xospfe11 11 "Analyst corrected reported value", add 
label define label_xospfe11 12 "Data generated from other data values", add 
label define label_xospfe11 13 "Implied zero", add 
label define label_xospfe11 20 "Imputed using Carry Forward procedure", add 
label define label_xospfe11 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xospfe11 30 "Not applicable", add 
label define label_xospfe11 31 "Institution left item blank", add 
label define label_xospfe11 32 "Do not know", add 
label define label_xospfe11 40 "Suppressed to protect confidentiality", add 
label values xospfe11 label_xospfe11
label define label_xchg1ay1 10 "Reported" 
label define label_xchg1ay1 11 "Analyst corrected reported value", add 
label define label_xchg1ay1 12 "Data generated from other data values", add 
label define label_xchg1ay1 13 "Implied zero", add 
label define label_xchg1ay1 20 "Imputed using Carry Forward procedure", add 
label define label_xchg1ay1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg1ay1 30 "Not applicable", add 
label define label_xchg1ay1 31 "Institution left item blank", add 
label define label_xchg1ay1 32 "Do not know", add 
label define label_xchg1ay1 40 "Suppressed to protect confidentiality", add 
label values xchg1ay1 label_xchg1ay1
label define label_xchg1ay2 10 "Reported" 
label define label_xchg1ay2 11 "Analyst corrected reported value", add 
label define label_xchg1ay2 12 "Data generated from other data values", add 
label define label_xchg1ay2 13 "Implied zero", add 
label define label_xchg1ay2 20 "Imputed using Carry Forward procedure", add 
label define label_xchg1ay2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg1ay2 30 "Not applicable", add 
label define label_xchg1ay2 31 "Institution left item blank", add 
label define label_xchg1ay2 32 "Do not know", add 
label define label_xchg1ay2 40 "Suppressed to protect confidentiality", add 
label values xchg1ay2 label_xchg1ay2
label define label_xchg1ay3 10 "Reported" 
label define label_xchg1ay3 11 "Analyst corrected reported value", add 
label define label_xchg1ay3 12 "Data generated from other data values", add 
label define label_xchg1ay3 13 "Implied zero", add 
label define label_xchg1ay3 20 "Imputed using Carry Forward procedure", add 
label define label_xchg1ay3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg1ay3 30 "Not applicable", add 
label define label_xchg1ay3 31 "Institution left item blank", add 
label define label_xchg1ay3 32 "Do not know", add 
label define label_xchg1ay3 40 "Suppressed to protect confidentiality", add 
label values xchg1ay3 label_xchg1ay3
label define label_xchg2ay1 10 "Reported" 
label define label_xchg2ay1 11 "Analyst corrected reported value", add 
label define label_xchg2ay1 12 "Data generated from other data values", add 
label define label_xchg2ay1 13 "Implied zero", add 
label define label_xchg2ay1 20 "Imputed using Carry Forward procedure", add 
label define label_xchg2ay1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg2ay1 30 "Not applicable", add 
label define label_xchg2ay1 31 "Institution left item blank", add 
label define label_xchg2ay1 32 "Do not know", add 
label define label_xchg2ay1 40 "Suppressed to protect confidentiality", add 
label values xchg2ay1 label_xchg2ay1
label define label_xchg2ay2 10 "Reported" 
label define label_xchg2ay2 11 "Analyst corrected reported value", add 
label define label_xchg2ay2 12 "Data generated from other data values", add 
label define label_xchg2ay2 13 "Implied zero", add 
label define label_xchg2ay2 20 "Imputed using Carry Forward procedure", add 
label define label_xchg2ay2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg2ay2 30 "Not applicable", add 
label define label_xchg2ay2 31 "Institution left item blank", add 
label define label_xchg2ay2 32 "Do not know", add 
label define label_xchg2ay2 40 "Suppressed to protect confidentiality", add 
label values xchg2ay2 label_xchg2ay2
label define label_xchg2ay3 10 "Reported" 
label define label_xchg2ay3 11 "Analyst corrected reported value", add 
label define label_xchg2ay3 12 "Data generated from other data values", add 
label define label_xchg2ay3 13 "Implied zero", add 
label define label_xchg2ay3 20 "Imputed using Carry Forward procedure", add 
label define label_xchg2ay3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg2ay3 30 "Not applicable", add 
label define label_xchg2ay3 31 "Institution left item blank", add 
label define label_xchg2ay3 32 "Do not know", add 
label define label_xchg2ay3 40 "Suppressed to protect confidentiality", add 
label values xchg2ay3 label_xchg2ay3
label define label_xchg3ay1 10 "Reported" 
label define label_xchg3ay1 11 "Analyst corrected reported value", add 
label define label_xchg3ay1 12 "Data generated from other data values", add 
label define label_xchg3ay1 13 "Implied zero", add 
label define label_xchg3ay1 20 "Imputed using Carry Forward procedure", add 
label define label_xchg3ay1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg3ay1 30 "Not applicable", add 
label define label_xchg3ay1 31 "Institution left item blank", add 
label define label_xchg3ay1 32 "Do not know", add 
label define label_xchg3ay1 40 "Suppressed to protect confidentiality", add 
label values xchg3ay1 label_xchg3ay1
label define label_xchg3ay2 10 "Reported" 
label define label_xchg3ay2 11 "Analyst corrected reported value", add 
label define label_xchg3ay2 12 "Data generated from other data values", add 
label define label_xchg3ay2 13 "Implied zero", add 
label define label_xchg3ay2 20 "Imputed using Carry Forward procedure", add 
label define label_xchg3ay2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg3ay2 30 "Not applicable", add 
label define label_xchg3ay2 31 "Institution left item blank", add 
label define label_xchg3ay2 32 "Do not know", add 
label define label_xchg3ay2 40 "Suppressed to protect confidentiality", add 
label values xchg3ay2 label_xchg3ay2
label define label_xchg3ay3 10 "Reported" 
label define label_xchg3ay3 11 "Analyst corrected reported value", add 
label define label_xchg3ay3 12 "Data generated from other data values", add 
label define label_xchg3ay3 13 "Implied zero", add 
label define label_xchg3ay3 20 "Imputed using Carry Forward procedure", add 
label define label_xchg3ay3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg3ay3 30 "Not applicable", add 
label define label_xchg3ay3 31 "Institution left item blank", add 
label define label_xchg3ay3 32 "Do not know", add 
label define label_xchg3ay3 40 "Suppressed to protect confidentiality", add 
label values xchg3ay3 label_xchg3ay3
label define label_xchg4ay1 10 "Reported" 
label define label_xchg4ay1 11 "Analyst corrected reported value", add 
label define label_xchg4ay1 12 "Data generated from other data values", add 
label define label_xchg4ay1 13 "Implied zero", add 
label define label_xchg4ay1 20 "Imputed using Carry Forward procedure", add 
label define label_xchg4ay1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg4ay1 30 "Not applicable", add 
label define label_xchg4ay1 31 "Institution left item blank", add 
label define label_xchg4ay1 32 "Do not know", add 
label define label_xchg4ay1 40 "Suppressed to protect confidentiality", add 
label values xchg4ay1 label_xchg4ay1
label define label_xchg4ay2 10 "Reported" 
label define label_xchg4ay2 11 "Analyst corrected reported value", add 
label define label_xchg4ay2 12 "Data generated from other data values", add 
label define label_xchg4ay2 13 "Implied zero", add 
label define label_xchg4ay2 20 "Imputed using Carry Forward procedure", add 
label define label_xchg4ay2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg4ay2 30 "Not applicable", add 
label define label_xchg4ay2 31 "Institution left item blank", add 
label define label_xchg4ay2 32 "Do not know", add 
label define label_xchg4ay2 40 "Suppressed to protect confidentiality", add 
label values xchg4ay2 label_xchg4ay2
label define label_xchg4ay3 10 "Reported" 
label define label_xchg4ay3 11 "Analyst corrected reported value", add 
label define label_xchg4ay3 12 "Data generated from other data values", add 
label define label_xchg4ay3 13 "Implied zero", add 
label define label_xchg4ay3 20 "Imputed using Carry Forward procedure", add 
label define label_xchg4ay3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg4ay3 30 "Not applicable", add 
label define label_xchg4ay3 31 "Institution left item blank", add 
label define label_xchg4ay3 32 "Do not know", add 
label define label_xchg4ay3 40 "Suppressed to protect confidentiality", add 
label values xchg4ay3 label_xchg4ay3
label define label_xchg5ay1 10 "Reported" 
label define label_xchg5ay1 11 "Analyst corrected reported value", add 
label define label_xchg5ay1 12 "Data generated from other data values", add 
label define label_xchg5ay1 13 "Implied zero", add 
label define label_xchg5ay1 20 "Imputed using Carry Forward procedure", add 
label define label_xchg5ay1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg5ay1 30 "Not applicable", add 
label define label_xchg5ay1 31 "Institution left item blank", add 
label define label_xchg5ay1 32 "Do not know", add 
label define label_xchg5ay1 40 "Suppressed to protect confidentiality", add 
label values xchg5ay1 label_xchg5ay1
label define label_xchg5ay2 10 "Reported" 
label define label_xchg5ay2 11 "Analyst corrected reported value", add 
label define label_xchg5ay2 12 "Data generated from other data values", add 
label define label_xchg5ay2 13 "Implied zero", add 
label define label_xchg5ay2 20 "Imputed using Carry Forward procedure", add 
label define label_xchg5ay2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg5ay2 30 "Not applicable", add 
label define label_xchg5ay2 31 "Institution left item blank", add 
label define label_xchg5ay2 32 "Do not know", add 
label define label_xchg5ay2 40 "Suppressed to protect confidentiality", add 
label values xchg5ay2 label_xchg5ay2
label define label_xchg5ay3 10 "Reported" 
label define label_xchg5ay3 11 "Analyst corrected reported value", add 
label define label_xchg5ay3 12 "Data generated from other data values", add 
label define label_xchg5ay3 13 "Implied zero", add 
label define label_xchg5ay3 20 "Imputed using Carry Forward procedure", add 
label define label_xchg5ay3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg5ay3 30 "Not applicable", add 
label define label_xchg5ay3 31 "Institution left item blank", add 
label define label_xchg5ay3 32 "Do not know", add 
label define label_xchg5ay3 40 "Suppressed to protect confidentiality", add 
label values xchg5ay3 label_xchg5ay3
label define label_xchg6ay1 10 "Reported" 
label define label_xchg6ay1 11 "Analyst corrected reported value", add 
label define label_xchg6ay1 12 "Data generated from other data values", add 
label define label_xchg6ay1 13 "Implied zero", add 
label define label_xchg6ay1 20 "Imputed using Carry Forward procedure", add 
label define label_xchg6ay1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg6ay1 30 "Not applicable", add 
label define label_xchg6ay1 31 "Institution left item blank", add 
label define label_xchg6ay1 32 "Do not know", add 
label define label_xchg6ay1 40 "Suppressed to protect confidentiality", add 
label values xchg6ay1 label_xchg6ay1
label define label_xchg6ay2 10 "Reported" 
label define label_xchg6ay2 11 "Analyst corrected reported value", add 
label define label_xchg6ay2 12 "Data generated from other data values", add 
label define label_xchg6ay2 13 "Implied zero", add 
label define label_xchg6ay2 20 "Imputed using Carry Forward procedure", add 
label define label_xchg6ay2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg6ay2 30 "Not applicable", add 
label define label_xchg6ay2 31 "Institution left item blank", add 
label define label_xchg6ay2 32 "Do not know", add 
label define label_xchg6ay2 40 "Suppressed to protect confidentiality", add 
label values xchg6ay2 label_xchg6ay2
label define label_xchg6ay3 10 "Reported" 
label define label_xchg6ay3 11 "Analyst corrected reported value", add 
label define label_xchg6ay3 12 "Data generated from other data values", add 
label define label_xchg6ay3 13 "Implied zero", add 
label define label_xchg6ay3 20 "Imputed using Carry Forward procedure", add 
label define label_xchg6ay3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg6ay3 30 "Not applicable", add 
label define label_xchg6ay3 31 "Institution left item blank", add 
label define label_xchg6ay3 32 "Do not know", add 
label define label_xchg6ay3 40 "Suppressed to protect confidentiality", add 
label values xchg6ay3 label_xchg6ay3
label define label_xchg7ay1 10 "Reported" 
label define label_xchg7ay1 11 "Analyst corrected reported value", add 
label define label_xchg7ay1 12 "Data generated from other data values", add 
label define label_xchg7ay1 13 "Implied zero", add 
label define label_xchg7ay1 20 "Imputed using Carry Forward procedure", add 
label define label_xchg7ay1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg7ay1 30 "Not applicable", add 
label define label_xchg7ay1 31 "Institution left item blank", add 
label define label_xchg7ay1 32 "Do not know", add 
label define label_xchg7ay1 40 "Suppressed to protect confidentiality", add 
label values xchg7ay1 label_xchg7ay1
label define label_xchg7ay2 10 "Reported" 
label define label_xchg7ay2 11 "Analyst corrected reported value", add 
label define label_xchg7ay2 12 "Data generated from other data values", add 
label define label_xchg7ay2 13 "Implied zero", add 
label define label_xchg7ay2 20 "Imputed using Carry Forward procedure", add 
label define label_xchg7ay2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg7ay2 30 "Not applicable", add 
label define label_xchg7ay2 31 "Institution left item blank", add 
label define label_xchg7ay2 32 "Do not know", add 
label define label_xchg7ay2 40 "Suppressed to protect confidentiality", add 
label values xchg7ay2 label_xchg7ay2
label define label_xchg7ay3 10 "Reported" 
label define label_xchg7ay3 11 "Analyst corrected reported value", add 
label define label_xchg7ay3 12 "Data generated from other data values", add 
label define label_xchg7ay3 13 "Implied zero", add 
label define label_xchg7ay3 20 "Imputed using Carry Forward procedure", add 
label define label_xchg7ay3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg7ay3 30 "Not applicable", add 
label define label_xchg7ay3 31 "Institution left item blank", add 
label define label_xchg7ay3 32 "Do not know", add 
label define label_xchg7ay3 40 "Suppressed to protect confidentiality", add 
label values xchg7ay3 label_xchg7ay3
label define label_xchg8ay1 10 "Reported" 
label define label_xchg8ay1 11 "Analyst corrected reported value", add 
label define label_xchg8ay1 12 "Data generated from other data values", add 
label define label_xchg8ay1 13 "Implied zero", add 
label define label_xchg8ay1 20 "Imputed using Carry Forward procedure", add 
label define label_xchg8ay1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg8ay1 30 "Not applicable", add 
label define label_xchg8ay1 31 "Institution left item blank", add 
label define label_xchg8ay1 32 "Do not know", add 
label define label_xchg8ay1 40 "Suppressed to protect confidentiality", add 
label values xchg8ay1 label_xchg8ay1
label define label_xchg8ay2 10 "Reported" 
label define label_xchg8ay2 11 "Analyst corrected reported value", add 
label define label_xchg8ay2 12 "Data generated from other data values", add 
label define label_xchg8ay2 13 "Implied zero", add 
label define label_xchg8ay2 20 "Imputed using Carry Forward procedure", add 
label define label_xchg8ay2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg8ay2 30 "Not applicable", add 
label define label_xchg8ay2 31 "Institution left item blank", add 
label define label_xchg8ay2 32 "Do not know", add 
label define label_xchg8ay2 40 "Suppressed to protect confidentiality", add 
label values xchg8ay2 label_xchg8ay2
label define label_xchg8ay3 10 "Reported" 
label define label_xchg8ay3 11 "Analyst corrected reported value", add 
label define label_xchg8ay3 12 "Data generated from other data values", add 
label define label_xchg8ay3 13 "Implied zero", add 
label define label_xchg8ay3 20 "Imputed using Carry Forward procedure", add 
label define label_xchg8ay3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg8ay3 30 "Not applicable", add 
label define label_xchg8ay3 31 "Institution left item blank", add 
label define label_xchg8ay3 32 "Do not know", add 
label define label_xchg8ay3 40 "Suppressed to protect confidentiality", add 
label values xchg8ay3 label_xchg8ay3
label define label_xchg9ay1 10 "Reported" 
label define label_xchg9ay1 11 "Analyst corrected reported value", add 
label define label_xchg9ay1 12 "Data generated from other data values", add 
label define label_xchg9ay1 13 "Implied zero", add 
label define label_xchg9ay1 20 "Imputed using Carry Forward procedure", add 
label define label_xchg9ay1 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg9ay1 30 "Not applicable", add 
label define label_xchg9ay1 31 "Institution left item blank", add 
label define label_xchg9ay1 32 "Do not know", add 
label define label_xchg9ay1 40 "Suppressed to protect confidentiality", add 
label values xchg9ay1 label_xchg9ay1
label define label_xchg9ay2 10 "Reported" 
label define label_xchg9ay2 11 "Analyst corrected reported value", add 
label define label_xchg9ay2 12 "Data generated from other data values", add 
label define label_xchg9ay2 13 "Implied zero", add 
label define label_xchg9ay2 20 "Imputed using Carry Forward procedure", add 
label define label_xchg9ay2 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg9ay2 30 "Not applicable", add 
label define label_xchg9ay2 31 "Institution left item blank", add 
label define label_xchg9ay2 32 "Do not know", add 
label define label_xchg9ay2 40 "Suppressed to protect confidentiality", add 
label values xchg9ay2 label_xchg9ay2
label define label_xchg9ay3 10 "Reported" 
label define label_xchg9ay3 11 "Analyst corrected reported value", add 
label define label_xchg9ay3 12 "Data generated from other data values", add 
label define label_xchg9ay3 13 "Implied zero", add 
label define label_xchg9ay3 20 "Imputed using Carry Forward procedure", add 
label define label_xchg9ay3 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xchg9ay3 30 "Not applicable", add 
label define label_xchg9ay3 31 "Institution left item blank", add 
label define label_xchg9ay3 32 "Do not know", add 
label define label_xchg9ay3 40 "Suppressed to protect confidentiality", add 
label values xchg9ay3 label_xchg9ay3
tab xtuit1
tab xfee1
tab xhrchg1
tab xcmpfee1
tab xtuit2
tab xfee2
tab xhrchg2
tab xcmpfee2
tab xtuit3
tab xfee3
tab xhrchg3
tab xcmpfee3
tab xtuit5
tab xfee5
tab xhrchg5
tab xtuit6
tab xfee6
tab xhrchg6
tab xtuit7
tab xfee7
tab xhrchg7
tab xispro1
tab xispfe1
tab xospro1
tab xospfe1
tab xispro2
tab xispfe2
tab xospro2
tab xospfe2
tab xispro3
tab xispfe3
tab xospro3
tab xospfe3
tab xispro4
tab xispfe4
tab xospro4
tab xospfe4
tab xispro5
tab xispfe5
tab xospro5
tab xospfe5
tab xispro6
tab xispfe6
tab xospro6
tab xospfe6
tab xispro7
tab xispfe7
tab xospro7
tab xospfe7
tab xispro8
tab xispfe8
tab xospro8
tab xospfe8
tab xispro9
tab xispfe9
tab xospro9
tab xospfe9
tab xispro10
tab xispfe10
tab xospro10
tab xospfe10
tab xispro11
tab xispfe11
tab xospro11
tab xospfe11
tab xchg1ay1
tab xchg1ay2
tab xchg1ay3
tab xchg2ay1
tab xchg2ay2
tab xchg2ay3
tab xchg3ay1
tab xchg3ay2
tab xchg3ay3
tab xchg4ay1
tab xchg4ay2
tab xchg4ay3
tab xchg5ay1
tab xchg5ay2
tab xchg5ay3
tab xchg6ay1
tab xchg6ay2
tab xchg6ay3
tab xchg7ay1
tab xchg7ay2
tab xchg7ay3
tab xchg8ay1
tab xchg8ay2
tab xchg8ay3
tab xchg9ay1
tab xchg9ay2
tab xchg9ay3
summarize tuition1
summarize fee1
summarize hrchg1
summarize cmpfee1
summarize tuition2
summarize fee2
summarize hrchg2
summarize cmpfee2
summarize tuition3
summarize fee3
summarize hrchg3
summarize cmpfee3
summarize tuition5
summarize fee5
summarize hrchg5
summarize tuition6
summarize fee6
summarize hrchg6
summarize tuition7
summarize fee7
summarize hrchg7
summarize isprof1
summarize ispfee1
summarize osprof1
summarize ospfee1
summarize isprof2
summarize ispfee2
summarize osprof2
summarize ospfee2
summarize isprof3
summarize ispfee3
summarize osprof3
summarize ospfee3
summarize isprof4
summarize ispfee4
summarize osprof4
summarize ospfee4
summarize isprof5
summarize ispfee5
summarize osprof5
summarize ospfee5
summarize isprof6
summarize ispfee6
summarize osprof6
summarize ospfee6
summarize isprof7
summarize ispfee7
summarize osprof7
summarize ospfee7
summarize isprof8
summarize ispfee8
summarize osprof8
summarize ospfee8
summarize isprof9
summarize ispfee9
summarize osprof9
summarize ospfee9
summarize isprof10
summarize ispfee10
summarize osprof10
summarize ospfee10
summarize isprof11
summarize ispfee11
summarize osprof11
summarize ospfee11
summarize chg1ay1
summarize chg1ay2
summarize chg1ay3
summarize chg2ay1
summarize chg2ay2
summarize chg2ay3
summarize chg3ay1
summarize chg3ay2
summarize chg3ay3
summarize chg4ay1
summarize chg4ay2
summarize chg4ay3
summarize chg5ay1
summarize chg5ay2
summarize chg5ay3
summarize chg6ay1
summarize chg6ay2
summarize chg6ay3
summarize chg7ay1
summarize chg7ay2
summarize chg7ay3
summarize chg8ay1
summarize chg8ay2
summarize chg8ay3
summarize chg9ay1
summarize chg9ay2
summarize chg9ay3
save dct_ic2000_ay

