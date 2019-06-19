* Created: 6/13/2004 6:35:59 AM
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
insheet using "../Raw Data/ef1992_c_data_stata.csv", comma clear
label data "dct_ef1992_c"
label variable unitid "unitid"
label variable efres01 "Total first-time first-year students"
label variable efres02 "First-time first-year students graduating within 12 months"
label variable line "Line number"
label variable out_stat "Location of out-of-state centers"
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
label define label_line 58 "American Samoa", add 
label define label_line 59 "Guam", add 
label define label_line 6 "California", add 
label define label_line 60 "Northern Marianas", add 
label define label_line 61 "Puerto Rico", add 
label define label_line 62 "Trust Territories", add 
label define label_line 63 "Virgin Islands", add 
label define label_line 64 "Foreign countries", add 
label define label_line 65 "Total", add 
label define label_line 66 "Balance", add 
label define label_line 8 "Colorado", add 
label define label_line 9 "Connecticut", add 
label values line label_line
tab line
tab out_stat
summarize efres01
summarize efres02
save dct_ef1992_c

