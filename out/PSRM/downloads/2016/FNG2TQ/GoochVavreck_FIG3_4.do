*** REPLICATION FILE FOR PSRM PAPER. GOOCH & VAVRECK 3/4/2016.  
* THIS FILE REPRODUCES FIGURES 3 and 4 

clear
use "FIG3_4.dta"
set more off

*** Below are differences for the open ended questions (Figure 3): 

tab VP_over treat, col chi
*Non-response 11.09
disp 35.64-24.55
*Correct -10.7
disp 49.70-60.40
*Partially Correct 2.57
disp 6.73-4.16
*Incorrect -2.97
disp 7.92-10.89

tab Prime_over treat, col chi
*Non-response 2.58
disp 75.25-72.67
*Correct -2.37
disp 6.14-8.51
*Partially Correct .4
disp 14.26-13.86
*Incorrect -.59
disp 4.36-4.95

tab Roberts_over treat, col chi
*Non-response .79
disp 68.91-68.12
*Correct -2.38
disp .79-3.17
*Partially Correct 2.18
disp 15.45-13.27
*Incorrect -.6
disp 14.85-15.45
	
**** Below are differences for the fact based questions (Figure 4):
	
tab moby treat, col chi
*Don't know  13.87
disp 17.43-3.56
* Hawthorne 2.57 
disp 26.73-24.16
* Wharton  -2.37
disp 5.15-7.52
* King -3.17
disp 3.96-7.13
* Melville -10.89
disp 46.73-57.62

tab meds treat, col chi
* True 2.57
disp 27.92-25.35
* Don't Know 1.58
disp 8.51-6.93
* False -4.16
disp 63.56-67.72

tab Pluto treat, col chi
* Don't Know 7.52
disp 22.97-15.45
* Mercury -.39
disp 2.38-2.77
* Neptune -.8
disp 1.58-2.38
* Saturn -1.58
disp 1.39-2.97
* Pluto -4.76
disp 71.68-76.44



	
