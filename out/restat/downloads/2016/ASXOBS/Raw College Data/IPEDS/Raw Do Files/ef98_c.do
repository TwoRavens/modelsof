* Created: 6/13/2004 2:41:04 AM
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
insheet using "../Raw Data/ef98_c_data_stata.csv", comma clear
label data "dct_ef98_c"
label variable unitid "unitid"
label variable line "Residence when first admitted"
label variable xef01 "Imputation field for  -"
label variable efres01 "Total first-time first-year"
label variable xef02 "Imputation field for  -"
label variable efres02 "Total, recently graduated high school"
label variable centers "Location of out-of-state centers"
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
label define label_line 57 "State Unknown", add 
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
label define label_line 90 "Foreign Countries", add 
label define label_line 99 "Grand total", add 
label values line label_line
label define label_xef01 10 "Reported" 
label define label_xef01 11 "Analyst corrected reported value", add 
label define label_xef01 12 "Data generated from other data values", add 
label define label_xef01 13 "Implied zero", add 
label define label_xef01 14 "Data adjusted in scan edits", add 
label define label_xef01 15 "Data copied from another field", add 
label define label_xef01 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xef01 17 "Details are adjusted to sum to total", add 
label define label_xef01 18 "Total generated to equal the sum of detail", add 
label define label_xef01 20 "Imputed using data from prior year", add 
label define label_xef01 21 "Imputed using method other than prior year data", add 
label define label_xef01 30 "Not applicable", add 
label define label_xef01 31 "Original data field was not reported", add 
label define label_xef01 40 "Suppressed to protect confidentiality", add 
*label values xef01 label_xef01
label define label_xef02 10 "Reported" 
label define label_xef02 11 "Analyst corrected reported value", add 
label define label_xef02 12 "Data generated from other data values", add 
label define label_xef02 13 "Implied zero", add 
label define label_xef02 14 "Data adjusted in scan edits", add 
label define label_xef02 15 "Data copied from another field", add 
label define label_xef02 16 "Analyst corrected a cell that was previously not reported", add 
label define label_xef02 17 "Details are adjusted to sum to total", add 
label define label_xef02 18 "Total generated to equal the sum of detail", add 
label define label_xef02 20 "Imputed using data from prior year", add 
label define label_xef02 21 "Imputed using method other than prior year data", add 
label define label_xef02 30 "Not applicable", add 
label define label_xef02 31 "Original data field was not reported", add 
label define label_xef02 40 "Suppressed to protect confidentiality", add 
*label values xef02 label_xef02
label define label_centers -5 "Implied no" 
label define label_centers 1 "Yes", add 
label values centers label_centers
tab line
tab xef01
tab xef02
tab centers
summarize efres01
summarize efres02
save dct_ef98_c

