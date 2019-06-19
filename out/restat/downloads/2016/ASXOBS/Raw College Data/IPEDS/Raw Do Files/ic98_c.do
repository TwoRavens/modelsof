* Created: 6/13/2004 2:08:35 AM
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
insheet using "../Raw Data/ic98_c_data_stata.csv", comma clear
label data "dct_ic98_c"
label variable unitid "unitid"
label variable calsys "Calendar system"
label variable crsloc1 "Credit, in-state"
label variable crsloc2 "Credit, out-of-state"
label variable crsloc3 "Credit, abroad"
label variable crsloc4 "Noncredit, in-state"
label variable crsloc5 "Noncredit, out-of-state"
label variable crsloc6 "Noncredit, abroad"
label variable facloc1 "Credit, on-campus"
label variable facloc2 "Credit, correctional facility"
label variable facloc3 "Credit, local education agency facility"
label variable facloc4 "Credit, other government facility"
label variable facloc5 "Credit, other"
label variable facloc6 "Noncredit, on-campus"
label variable facloc7 "Noncredit, correctional facility"
label variable facloc8 "Noncredit, local education agency"
label variable facloc9 "Noncredit, other government facility"
label variable facloc10 "Noncredit, other"
label variable mili "Courses at military installations"
label variable mil1insl "MILI in states and/or territories"
label variable mil2insl "MILI at military installations abroad"
label variable admreq1 "No entering freshmen"
label variable admreq2 "High school diploma or equivalent"
label variable admreq3 "High school class standing"
label variable admreq4 "Admissions test scores (general)"
label variable admreq5 "SAT test score"
label variable admreq6 "ACT test score"
label variable admreq7 "Other test score"
label variable admreq8 "Residence"
label variable admreq9 "Ability to benefit from instruction"
label variable admreq10 "Age"
label variable admreq11 "TOEFL score"
label variable admreq12 "Open admission"
label variable admreq13 "Other"
label variable yrscoll "Years of college-level work required"
label variable mode1 "Credit, program-related work w/pay"
label variable mode2 "Credit, program-related work/no pay"
label variable mode3 "Credit, home study (general)"
label variable mode4 "Credit, home study, correspondence"
label variable mode5 "Credit, home study, radio and TV"
label variable mode6 "Credit, home study, newspaper"
label variable mode7 "Credit, none of the above"
label variable mode8 "Noncredit, work in prog-related with pay"
label variable mode9 "Noncredit, work in prog-related w/o pay"
label variable mode10 "Noncredit, home study (general)"
label variable mode11 "Noncredit, home study, correspondence"
label variable mode12 "Noncredit, home study, radio and TV"
label variable mode13 "Noncredit, home study, newspaper"
label variable mode14 "Noncredit, none of the above"
label variable stusrv1 "Remedial services"
label variable stusrv2 "Academic/career counseling service"
label variable stusrv3 "Employment services for students"
label variable stusrv4 "Placement services for completers"
label variable stusrv5 "Assistance for the visually impaired"
label variable stusrv6 "Assistance for the hearing impaired"
label variable stusrv7 "Access for the mobility impaired"
label variable stusrv8 "On-campus day care for students^ children"
label variable stusrv9 "None of the above"
label variable libfac "Library facilities at institution"
label variable libshar1 "LIBFAC ID of 1st"
label variable libshar2 "LIBFAC ID of 2nd"
label variable libshar3 "LIBFAC ID of 3rd"
label define label_calsys -1 "{Not reported}" 
label define label_calsys -2 "{Item not applicable}", add 
label define label_calsys 1 "Semester", add 
label define label_calsys 2 "Quarter", add 
label define label_calsys 3 "Trimester", add 
label define label_calsys 4 "Four-one-four plan", add 
label define label_calsys 5 "Differs by program", add 
label define label_calsys 6 "Continuous", add 
label define label_calsys 7 "Other", add 
label values calsys label_calsys
label define label_crsloc1 -1 "{Not reported}" 
label define label_crsloc1 -2 "{Item not applicable}", add 
label define label_crsloc1 -5 "{Implied no}", add 
label define label_crsloc1 1 "Yes", add 
label values crsloc1 label_crsloc1
label define label_crsloc2 -1 "{Not reported}" 
label define label_crsloc2 -2 "{Item not applicable}", add 
label define label_crsloc2 -5 "{Implied no}", add 
label define label_crsloc2 1 "Yes", add 
label values crsloc2 label_crsloc2
label define label_crsloc3 -1 "{Not reported}" 
label define label_crsloc3 -2 "{Item not applicable}", add 
label define label_crsloc3 -5 "Impled No", add 
label define label_crsloc3 1 "Yes", add 
label values crsloc3 label_crsloc3
label define label_crsloc4 -1 "{Not reported}" 
label define label_crsloc4 -2 "{Item not applicable}", add 
label define label_crsloc4 -5 "{Implied no}", add 
label define label_crsloc4 1 "Yes", add 
label values crsloc4 label_crsloc4
label define label_crsloc5 -1 "{Not reported}" 
label define label_crsloc5 -2 "{Item not applicable}", add 
label define label_crsloc5 -5 "{Implied no}", add 
label define label_crsloc5 1 "Yes", add 
label values crsloc5 label_crsloc5
label define label_crsloc6 -1 "{Not reported}" 
label define label_crsloc6 -2 "{Item not applicable}", add 
label define label_crsloc6 -5 "{Implied no}", add 
label define label_crsloc6 1 "Yes", add 
label values crsloc6 label_crsloc6
label define label_facloc1 -1 "{Not reported}" 
label define label_facloc1 -2 "{Item not applicable}", add 
label define label_facloc1 -5 "{Implied no}", add 
label define label_facloc1 1 "Yes", add 
label values facloc1 label_facloc1
label define label_facloc2 -1 "{Not reported}" 
label define label_facloc2 -2 "{Item not applicable}", add 
label define label_facloc2 -5 "{Implied no}", add 
label define label_facloc2 1 "Yes", add 
label values facloc2 label_facloc2
label define label_facloc3 -1 "{Not reported}" 
label define label_facloc3 -2 "{Item not applicable}", add 
label define label_facloc3 -5 "{Implied no}", add 
label define label_facloc3 1 "Yes", add 
label values facloc3 label_facloc3
label define label_facloc4 -1 "{Not reported}" 
label define label_facloc4 -2 "{Item not applicable}", add 
label define label_facloc4 -5 "{Implied no}", add 
label define label_facloc4 1 "Yes", add 
label values facloc4 label_facloc4
label define label_facloc5 -1 "{Not reported}" 
label define label_facloc5 -2 "{Item not applicable}", add 
label define label_facloc5 -5 "{Implied no}", add 
label define label_facloc5 1 "Yes", add 
label values facloc5 label_facloc5
label define label_facloc6 -1 "{Not reported}" 
label define label_facloc6 -2 "{Item not applicable}", add 
label define label_facloc6 -5 "{Implied no}", add 
label define label_facloc6 1 "Yes", add 
label values facloc6 label_facloc6
label define label_facloc7 -1 "{Not reported}" 
label define label_facloc7 -2 "{Item not applicable}", add 
label define label_facloc7 -5 "{Implied no}", add 
label define label_facloc7 1 "Yes", add 
label values facloc7 label_facloc7
label define label_facloc8 -1 "{Not reported}" 
label define label_facloc8 -2 "{Item not applicable}", add 
label define label_facloc8 -5 "{Implied no}", add 
label define label_facloc8 1 "Yes", add 
label values facloc8 label_facloc8
label define label_facloc9 -1 "{Not reported}" 
label define label_facloc9 -2 "{Item not applicable}", add 
label define label_facloc9 -5 "{Implied no}", add 
label define label_facloc9 1 "Yes", add 
label values facloc9 label_facloc9
label define label_facloc10 -1 "{Not reported}" 
label define label_facloc10 -2 "{Item not applicable}", add 
label define label_facloc10 -5 "{Implied no}", add 
label define label_facloc10 1 "Yes", add 
label values facloc10 label_facloc10
label define label_mili -1 "{Not reported}" 
label define label_mili -2 "{Item not applicable}", add 
label define label_mili 1 "Yes", add 
label define label_mili 2 "No", add 
label values mili label_mili
label define label_mil2insl -1 "{Not reported}" 
label define label_mil2insl -2 "{Item not applicable}", add 
label define label_mil2insl -5 "{Implied no}", add 
label define label_mil2insl 1 "Yes", add 
label values mil2insl label_mil2insl
label define label_admreq1 -1 "{Not reported}" 
label define label_admreq1 -2 "{Item not applicable}", add 
label define label_admreq1 -5 "{Implied no}", add 
label define label_admreq1 1 "Yes", add 
label values admreq1 label_admreq1
label define label_admreq2 -1 "{Not reported}" 
label define label_admreq2 -2 "{Item not applicable}", add 
label define label_admreq2 -5 "{Implied no}", add 
label define label_admreq2 1 "Yes", add 
label values admreq2 label_admreq2
label define label_admreq3 -1 "{Not reported}" 
label define label_admreq3 -2 "{Item not applicable}", add 
label define label_admreq3 -5 "{Implied no}", add 
label define label_admreq3 1 "Yes", add 
label values admreq3 label_admreq3
label define label_admreq4 -1 "{Not reported}" 
label define label_admreq4 -2 "{Item not applicable}", add 
label define label_admreq4 -5 "{Implied no}", add 
label define label_admreq4 1 "Yes", add 
label values admreq4 label_admreq4
label define label_admreq5 -1 "{Not reported}" 
label define label_admreq5 -2 "{Item not applicable}", add 
label define label_admreq5 -5 "{Implied no}", add 
label define label_admreq5 1 "Yes", add 
label values admreq5 label_admreq5
label define label_admreq6 -1 "{Not reported}" 
label define label_admreq6 -2 "{Item not applicable}", add 
label define label_admreq6 -5 "{Implied no}", add 
label define label_admreq6 1 "Yes", add 
label values admreq6 label_admreq6
label define label_admreq7 -1 "{Not reported}" 
label define label_admreq7 -2 "{Item not applicable}", add 
label define label_admreq7 -5 "{Implied no}", add 
label define label_admreq7 1 "Yes", add 
label values admreq7 label_admreq7
label define label_admreq8 -1 "{Not reported}" 
label define label_admreq8 -2 "{Item not applicable}", add 
label define label_admreq8 -5 "{Implied no}", add 
label define label_admreq8 1 "Yes", add 
label values admreq8 label_admreq8
label define label_admreq9 -1 "{Not reported}" 
label define label_admreq9 -2 "{Item not applicable}", add 
label define label_admreq9 -5 "{Implied no}", add 
label define label_admreq9 1 "Yes", add 
label values admreq9 label_admreq9
label define label_admreq10 -1 "{Not reported}" 
label define label_admreq10 -2 "{Item not applicable}", add 
label define label_admreq10 -5 "{Implied no}", add 
label define label_admreq10 1 "Yes", add 
label values admreq10 label_admreq10
label define label_admreq11 -1 "{Not reported}" 
label define label_admreq11 -2 "{Item not applicable}", add 
label define label_admreq11 -5 "{Implied no}", add 
label define label_admreq11 1 "Yes", add 
label values admreq11 label_admreq11
label define label_admreq12 -1 "{Not reported}" 
label define label_admreq12 -2 "{Item not applicable}", add 
label define label_admreq12 -5 "{Implied no}", add 
label define label_admreq12 1 "Yes", add 
label values admreq12 label_admreq12
label define label_admreq13 -1 "{Not reported}" 
label define label_admreq13 -2 "{Item not applicable}", add 
label define label_admreq13 -5 "{Implied no}", add 
label define label_admreq13 1 "Yes", add 
label values admreq13 label_admreq13
label define label_yrscoll -2 "{Item not applicable}" 
label define label_yrscoll 1 "One", add 
label define label_yrscoll 2 "Two", add 
label define label_yrscoll 3 "Three", add 
label define label_yrscoll 4 "Four", add 
label define label_yrscoll 5 "Five", add 
label define label_yrscoll 6 "Six", add 
label define label_yrscoll 7 "Seven", add 
label define label_yrscoll 8 "Eight", add 
label values yrscoll label_yrscoll
label define label_mode1 -1 "{Not reported}" 
label define label_mode1 -2 "{Item not applicable}", add 
label define label_mode1 -5 "{Implied no}", add 
label define label_mode1 1 "Yes", add 
label values mode1 label_mode1
label define label_mode2 -1 "{Not reported}" 
label define label_mode2 -2 "{Item not applicable}", add 
label define label_mode2 -5 "{Implied no}", add 
label define label_mode2 1 "Yes", add 
label values mode2 label_mode2
label define label_mode3 -1 "{Not reported}" 
label define label_mode3 -2 "{Item not applicable}", add 
label define label_mode3 -5 "{Implied no}", add 
label define label_mode3 1 "Yes", add 
label values mode3 label_mode3
label define label_mode4 -1 "{Not reported}" 
label define label_mode4 -2 "{Item not applicable}", add 
label define label_mode4 -5 "{Implied no}", add 
label define label_mode4 1 "Yes", add 
label values mode4 label_mode4
label define label_mode5 -1 "{Not reported}" 
label define label_mode5 -2 "{Item not applicable}", add 
label define label_mode5 -5 "{Implied no}", add 
label define label_mode5 1 "Yes", add 
label values mode5 label_mode5
label define label_mode6 -1 "{Not reported}" 
label define label_mode6 -2 "{Item not applicable}", add 
label define label_mode6 -5 "{Implied no}", add 
label define label_mode6 1 "Yes", add 
label values mode6 label_mode6
label define label_mode7 -1 "{Not reported}" 
label define label_mode7 -2 "{Item not applicable}", add 
label define label_mode7 -5 "{Implied no}", add 
label define label_mode7 1 "Yes", add 
label values mode7 label_mode7
label define label_mode8 -1 "{Not reported}" 
label define label_mode8 -2 "{Item not applicable}", add 
label define label_mode8 -5 "{Implied no}", add 
label define label_mode8 1 "Yes", add 
label values mode8 label_mode8
label define label_mode9 -1 "{Not reported}" 
label define label_mode9 -2 "{Item not applicable}", add 
label define label_mode9 -5 "{Implied no}", add 
label define label_mode9 1 "Yes", add 
label values mode9 label_mode9
label define label_mode10 -1 "{Not reported}" 
label define label_mode10 -2 "{Item not applicable}", add 
label define label_mode10 -5 "{Implied no}", add 
label define label_mode10 1 "Yes", add 
label values mode10 label_mode10
label define label_mode11 -1 "{Not reported}" 
label define label_mode11 -2 "{Item not applicable}", add 
label define label_mode11 -5 "{Implied no}", add 
label define label_mode11 1 "Yes", add 
label values mode11 label_mode11
label define label_mode12 -1 "{Not reported}" 
label define label_mode12 -2 "{Item not applicable}", add 
label define label_mode12 -5 "{Implied no}", add 
label define label_mode12 1 "Yes", add 
label values mode12 label_mode12
label define label_mode13 -1 "{Not reported}" 
label define label_mode13 -2 "{Item not applicable}", add 
label define label_mode13 -5 "{Implied no}", add 
label define label_mode13 1 "Yes", add 
label values mode13 label_mode13
label define label_mode14 -1 "{Not reported}" 
label define label_mode14 -2 "{Item not applicable}", add 
label define label_mode14 -5 "{Implied no}", add 
label define label_mode14 1 "Yes", add 
label values mode14 label_mode14
label define label_stusrv1 -1 "{Not reported}" 
label define label_stusrv1 -2 "{Item not applicable}", add 
label define label_stusrv1 -5 "{Implied no}", add 
label define label_stusrv1 1 "Yes", add 
label values stusrv1 label_stusrv1
label define label_stusrv2 -1 "{Not reported}" 
label define label_stusrv2 -2 "{Item not applicable}", add 
label define label_stusrv2 -5 "{Implied no}", add 
label define label_stusrv2 1 "Yes", add 
label values stusrv2 label_stusrv2
label define label_stusrv3 -1 "{Not reported}" 
label define label_stusrv3 -2 "{Item not applicable}", add 
label define label_stusrv3 -5 "{Implied no}", add 
label define label_stusrv3 1 "Yes", add 
label values stusrv3 label_stusrv3
label define label_stusrv4 -1 "{Not reported}" 
label define label_stusrv4 -2 "{Item not applicable}", add 
label define label_stusrv4 -5 "{Implied no}", add 
label define label_stusrv4 1 "Yes", add 
label values stusrv4 label_stusrv4
label define label_stusrv5 -1 "{Not reported}" 
label define label_stusrv5 -2 "{Item not applicable}", add 
label define label_stusrv5 -5 "{Implied no}", add 
label define label_stusrv5 1 "Yes", add 
label values stusrv5 label_stusrv5
label define label_stusrv6 -1 "{Not reported}" 
label define label_stusrv6 -2 "{Item not applicable}", add 
label define label_stusrv6 -5 "{Implied no}", add 
label define label_stusrv6 1 "Yes", add 
label values stusrv6 label_stusrv6
label define label_stusrv7 -1 "{Not reported}" 
label define label_stusrv7 -2 "{Item not applicable}", add 
label define label_stusrv7 -5 "{Implied no}", add 
label define label_stusrv7 1 "Yes", add 
label values stusrv7 label_stusrv7
label define label_stusrv8 -1 "{Not reported}" 
label define label_stusrv8 -2 "{Item not applicable}", add 
label define label_stusrv8 -5 "{Implied no}", add 
label define label_stusrv8 1 "Yes", add 
label values stusrv8 label_stusrv8
label define label_stusrv9 -1 "{Not reported}" 
label define label_stusrv9 -2 "{Item not applicable}", add 
label define label_stusrv9 -5 "{Implied no}", add 
label define label_stusrv9 1 "Yes", add 
label values stusrv9 label_stusrv9
label define label_libfac -1 "{Not reported}" 
label define label_libfac -2 "{Item not applicable}", add 
label define label_libfac 1 "Has own library", add 
label define label_libfac 2 "Shared financial support for library", add 
label define label_libfac 3 "None of the above", add 
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
tab yrscoll
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
save dct_ic98_c

