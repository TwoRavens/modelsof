* Created: 6/12/2004 10:47:23 PM
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
insheet using "../Raw Data/ef2000c_data_stata.csv", comma clear
label data "dct_ef2000c"
label variable unitid "unitid"
label variable line "State Residence of student when 1st admitted"
label variable xefres01 "Imputation field for EFRES01 - First-time first-year students (degree-seeking only)"
label variable efres01 "First-time first-year students (degree-seeking only)"
label variable xefres02 "Imputation field for EFRES02 - 1st-time, 1st-yr students graduated HS past 12 mn"
label variable efres02 "1st-time, 1st-yr students graduated HS past 12 mn"
label define label_line 1 "Alabama" 
label define label_line 10 "Delaware", add 
label define label_line 11 "District of Columbia", add 
label define label_line 12 "Florida", add 
label define label_line 13 "Georgia", add 
label define label_line 15 "Hawaii", add 
label define label_line 16 "Idaho", add 
label define label_line 17 "Illinois", add 
label define label_line 18 "Indiana", add 
label define label_line 19 "Iowa", add 
label define label_line 2 "Alaska", add 
label define label_line 20 "Kansas", add 
label define label_line 21 "Kentucky", add 
label define label_line 22 "Louisiana", add 
label define label_line 23 "Maine", add 
label define label_line 24 "Maryland", add 
label define label_line 25 "Massachusetts", add 
label define label_line 26 "Michigan", add 
label define label_line 27 "Minnesota", add 
label define label_line 28 "Mississippi", add 
label define label_line 29 "Missouri", add 
label define label_line 30 "Montana", add 
label define label_line 31 "Nebraska", add 
label define label_line 32 "Nevada", add 
label define label_line 33 "New Hampshire", add 
label define label_line 34 "New Jersey", add 
label define label_line 35 "New Mexico", add 
label define label_line 36 "New York", add 
label define label_line 37 "North Carolina", add 
label define label_line 38 "North Dakota", add 
label define label_line 39 "Ohio", add 
label define label_line 4 "Arizona", add 
label define label_line 40 "Oklahoma", add 
label define label_line 41 "Oregon", add 
label define label_line 42 "Pennsylvania", add 
label define label_line 44 "Rhode Island", add 
label define label_line 45 "South Carolina", add 
label define label_line 46 "South Dakota", add 
label define label_line 47 "Tennessee", add 
label define label_line 48 "Texas", add 
label define label_line 49 "Utah", add 
label define label_line 5 "Arkansas", add 
label define label_line 50 "Vermont", add 
label define label_line 51 "Virginia", add 
label define label_line 53 "Washington", add 
label define label_line 54 "West Virginia", add 
label define label_line 55 "Wisconsin", add 
label define label_line 56 "Wyoming", add 
label define label_line 57 "State unknown", add 
label define label_line 6 "California", add 
label define label_line 60 "American Samoa", add 
label define label_line 64 "Federated States of Micronesia", add 
label define label_line 66 "Guam", add 
label define label_line 68 "Marshall Islands", add 
label define label_line 69 "Northern Marianas", add 
label define label_line 70 "Palau", add 
label define label_line 72 "Puerto Rico", add 
label define label_line 78 "Virgin Islands", add 
label define label_line 8 "Colorado", add 
label define label_line 9 "Connecticut", add 
label define label_line 90 "Foreign countries", add 
label define label_line 98 "Residence not reported (balance line)", add 
label define label_line 99 "Grand total", add 
label values line label_line
label define label_xefres01 10 "Reported" 
label define label_xefres01 11 "Analyst corrected reported value", add 
label define label_xefres01 12 "Data generated from other data values", add 
label define label_xefres01 13 "Implied zero", add 
label define label_xefres01 20 "Imputed using Carry Forward procedure", add 
label define label_xefres01 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xefres01 30 "Not applicable", add 
label define label_xefres01 31 "Institution left item blank", add 
label define label_xefres01 32 "Do not know", add 
label define label_xefres01 40 "Suppressed to protect confidentiality", add 
label values xefres01 label_xefres01
label define label_xefres02 10 "Reported" 
label define label_xefres02 11 "Analyst corrected reported value", add 
label define label_xefres02 12 "Data generated from other data values", add 
label define label_xefres02 13 "Implied zero", add 
label define label_xefres02 20 "Imputed using Carry Forward procedure", add 
label define label_xefres02 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xefres02 30 "Not applicable", add 
label define label_xefres02 31 "Institution left item blank", add 
label define label_xefres02 32 "Do not know", add 
label define label_xefres02 40 "Suppressed to protect confidentiality", add 
label values xefres02 label_xefres02
tab line
tab xefres01
tab xefres02
summarize efres01
summarize efres02
save dct_ef2000c

