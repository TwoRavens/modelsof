* Created: 6/13/2004 3:14:02 AM
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
insheet using "../Raw Data/ic9798_c_data_stata.csv", comma clear
label data "dct_ic9798_c"
label variable unitid "unitid"
label variable calsys "Calendar system"
label variable crsloc1 "Credit, in-State"
label variable crsloc2 "Credit, out-of-State"
label variable crsloc3 "Credit, abroad"
label variable crsloc4 "Noncredit, in-State"
label variable crsloc5 "Noncredit, out-of-State"
label variable crsloc6 "Noncredit, abroad"
label variable facloc1 "Credit, on-campus"
label variable facloc2 "Credit, correctional facility"
label variable facloc3 "Credit, local education agency facility"
label variable facloc4 "Credit, other government facility"
label variable facloc5 "Credit, other"
label variable facloc6 "Noncredit, on-campus"
label variable facloc7 "Noncredit, correctional facility"
label variable facloc8 "Noncredit, local education agency facility"
label variable facloc9 "Noncredit, other government facility"
label variable facloc10 "Noncredit, other"
label variable mili "Courses are offered at military installations"
label variable mil1insl "If MILI = 1, in states and/or territories"
label variable mil2insl "If MILI = 1, at military installations abroad"
label variable admreq1 "No entering freshmen"
label variable admreq2 "High school diploma or equivalent"
label variable admreq3 "High school class standing"
label variable admreq4 "Admissions test scores (general)"
label variable admreq5 "SAT test score"
label variable admreq6 "ACT test score"
label variable admreq7 "Other test score"
label variable admreq8 "Residence"
label variable admreq9 "Evidence of ability to benefit from instruction"
label variable admreq10 "Age"
label variable admreq11 "Test of English as a Foreign Language"
label variable admreq12 "Open Admission"
label variable admreq13 "Other"
label variable yrscol "Years of college-level work required"
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
label variable stusrv9 "None of the above"
label variable libfac "Library facilities at institution"
label variable libshar1 "LIBFAC ID of 1st"
label variable libshar2 "LIBFAC ID of 2nd"
label variable libshar3 "LIBFAC ID of 3rd"
label define label_calsys 1 "Semester" 
label define label_calsys 2 "Quarter", add 
label define label_calsys 3 "Trimester", add 
label define label_calsys 4 "Four-One-Four Plan (4-1-4)", add 
label define label_calsys 5 "Differs by program", add 
label define label_calsys 6 "Continuous basis", add 
label define label_calsys 7 "Other", add 
label values calsys label_calsys
label define label_mili 1 "Yes" 
label define label_mili 2 "No", add 
label values mili label_mili
label define label_yrscol 1 "One" 
label define label_yrscol 2 "Two", add 
label define label_yrscol 3 "Three", add 
label define label_yrscol 4 "Four", add 
label define label_yrscol 5 "Five", add 
label define label_yrscol 6 "Six", add 
label define label_yrscol 7 "Seven", add 
label values yrscol label_yrscol
label define label_libfac 1 "Have own library" 
label define label_libfac 2 "Support shared library", add 
label define label_libfac 3 "Neither of the above", add 
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
tab facloc5
tab facloc6
tab facloc7
tab facloc8
tab facloc9
tab facloc10
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
tab admreq12
tab admreq13
tab yrscol
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
tab libfac
summarize libshar1
summarize libshar2
summarize libshar3
save dct_ic9798_c

