* Created: 6/12/2004 12:43:25 PM
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
insheet using "../Raw Data/ef2002c_data_stata.csv", comma clear
label data "dct_ef2002c"
label variable unitid "unitid"
label variable efcstate "State of residence when student was first admitted"
label variable line "line"
label variable xefres01 "Imputation field for EFRES01 - First-time degree/certificate-seeking undergraduate students"
label variable efres01 "First-time degree/certificate-seeking undergraduate students"
label variable xefres02 "Imputation field for EFRES02 - First-time degree/certificate-seeking undergraduate students who graduated from high school in the past 12 months"
label variable efres02 "First-time degree/certificate-seeking undergraduate students who graduated from high school in the past 12 months"
label define label_efcstate 1 "Alabama" 
label define label_efcstate 10 "Delaware", add 
label define label_efcstate 11 "District of Columbia", add 
label define label_efcstate 12 "Florida", add 
label define label_efcstate 13 "Georgia", add 
label define label_efcstate 15 "Hawaii", add 
label define label_efcstate 16 "Idaho", add 
label define label_efcstate 17 "Illinois", add 
label define label_efcstate 18 "Indiana", add 
label define label_efcstate 19 "Iowa", add 
label define label_efcstate 2 "Alaska", add 
label define label_efcstate 20 "Kansas", add 
label define label_efcstate 21 "Kentucky", add 
label define label_efcstate 22 "Louisiana", add 
label define label_efcstate 23 "Maine", add 
label define label_efcstate 24 "Maryland", add 
label define label_efcstate 25 "Massachusetts", add 
label define label_efcstate 26 "Michigan", add 
label define label_efcstate 27 "Minnesota", add 
label define label_efcstate 28 "Mississippi", add 
label define label_efcstate 29 "Missouri", add 
label define label_efcstate 30 "Montana", add 
label define label_efcstate 31 "Nebraska", add 
label define label_efcstate 32 "Nevada", add 
label define label_efcstate 33 "New Hampshire", add 
label define label_efcstate 34 "New Jersey", add 
label define label_efcstate 35 "New Mexico", add 
label define label_efcstate 36 "New York", add 
label define label_efcstate 37 "North Carolina", add 
label define label_efcstate 38 "North Dakota", add 
label define label_efcstate 39 "Ohio", add 
label define label_efcstate 4 "Arizona", add 
label define label_efcstate 40 "Oklahoma", add 
label define label_efcstate 41 "Oregon", add 
label define label_efcstate 42 "Pennsylvania", add 
label define label_efcstate 44 "Rhode Island", add 
label define label_efcstate 45 "South Carolina", add 
label define label_efcstate 46 "South Dakota", add 
label define label_efcstate 47 "Tennessee", add 
label define label_efcstate 48 "Texas", add 
label define label_efcstate 49 "Utah", add 
label define label_efcstate 5 "Arkansas", add 
label define label_efcstate 50 "Vermont", add 
label define label_efcstate 51 "Virginia", add 
label define label_efcstate 53 "Washington", add 
label define label_efcstate 54 "West Virginia", add 
label define label_efcstate 55 "Wisconsin", add 
label define label_efcstate 56 "Wyoming", add 
label define label_efcstate 57 "State unknown", add 
label define label_efcstate 58 "US total", add 
label define label_efcstate 6 "California", add 
label define label_efcstate 60 "American Samoa", add 
label define label_efcstate 64 "Federated States of Micronesia", add 
label define label_efcstate 66 "Guam", add 
label define label_efcstate 68 "Marshall Islands", add 
label define label_efcstate 69 "Northern Marianas", add 
label define label_efcstate 70 "Palau", add 
label define label_efcstate 72 "Puerto Rico", add 
label define label_efcstate 78 "Virgin Islands", add 
label define label_efcstate 8 "Colorado", add 
label define label_efcstate 89 "Outlying areas total", add 
label define label_efcstate 9 "Connecticut", add 
label define label_efcstate 90 "Foreign countries", add 
label define label_efcstate 98 "Residence not reported", add 
label define label_efcstate 99 "All first-time degree/certificate seeking undergraduates, total", add 
label values efcstate label_efcstate
label define label_xefres01 10 "Reported" 
label define label_xefres01 11 "Analyst corrected reported value", add 
label define label_xefres01 12 "Data generated from other data values", add 
label define label_xefres01 13 "Implied zero", add 
label define label_xefres01 20 "Imputed using Carry Forward procedure", add 
label define label_xefres01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xefres01 22 "Imputed using the Group Median procedure", add 
label define label_xefres01 23 "Partial imputation", add 
label define label_xefres01 30 "Not applicable", add 
label define label_xefres01 31 "Institution left item blank", add 
label define label_xefres01 32 "Do not know", add 
label define label_xefres01 33 "Particular 1st prof field not applicable", add 
label define label_xefres01 40 "Suppressed to protect confidentiality", add 
label values xefres01 label_xefres01
label define label_xefres02 10 "Reported" 
label define label_xefres02 11 "Analyst corrected reported value", add 
label define label_xefres02 12 "Data generated from other data values", add 
label define label_xefres02 13 "Implied zero", add 
label define label_xefres02 20 "Imputed using Carry Forward procedure", add 
label define label_xefres02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xefres02 22 "Imputed using the Group Median procedure", add 
label define label_xefres02 23 "Partial imputation", add 
label define label_xefres02 30 "Not applicable", add 
label define label_xefres02 31 "Institution left item blank", add 
label define label_xefres02 32 "Do not know", add 
label define label_xefres02 33 "Particular 1st prof field not applicable", add 
label define label_xefres02 40 "Suppressed to protect confidentiality", add 
label values xefres02 label_xefres02
tab efcstate
tab xefres01
tab xefres02
summarize efres01
summarize efres02
save dct_ef2002c

