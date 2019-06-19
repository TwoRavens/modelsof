/* set working directory here, replace "XXXXX" with the folder/file names */
cd "XXXXX"
use XXXXX, clear

set more off
set matsize 11000

tolower

#delimit;

/* set as global ref. folders, and set of controls */;

global data ="data\";
global dofiles = "do_files\";
global table = "tables\";
global tables = "tables\";
global figure = "Figures\";

global eteachercont cbyerace1 cbyerace2 cbyerace3 cbyerace4 cbyerace5 egend byte26c byte26c_sq
      emajor cbytehdeg cbyte29;
global mteachercont cbymrace1 cbymrace2 cbymrace3 cbymrace4 cbymrace5 mgend bytm26c bytm26c_sq
	  mmajor cbytmhdeg cbytm29;
global teacherchar $eteachercont $mteachercont;
global studentchar cbyrace1-cbyrace5 gend noneng cbyplang 
	  byfathed2-byfathed4 bymothed2-bymothed4 cbyfcomp inc2 inc3 inc4 highincome
	  cbyp38 bysibstr;
global grades  bytxmstd bytxrstd f1rgp9;
	  
global spec1 $teacherchar;
global spec2 $teacherchar $studentchar;
global spec3 $teacherchar $studentchar $grades ;

/* Sample Creation: Output is used to create Table S1. The do-file also creates
a stata data file named ``allsample.dta'' */;
qui do $dofiles\EDEX1_Sample_Selection_and_Creation.do;


/* Replicates Summary Stats for students: Table 1, Table S6, Table S7  */;
qui do $dofiles\EDEX2_Student_Summary.do;

/* Replicates Main OLS Analyses, Table 3, Table S8. The do-file also creates
a stata data file named ``edex_data_analytic.dta */;
qui do $dofiles\EDEX3_Main_OLS.do;

/* Replicates Table S2 */;
qui do $dofiles\EDEX4_TableS2.do;

/* Replicates Table S3 */;
qui do $dofiles\EDEX5_Out_of_sample_mean.do;

/* Replicates Table S4 */;
qui do $dofiles\EDEX6_Teachers_Summary.do; 

/* Replicates Table 2 */;
qui do $dofiles\EDEX7_TeacherExpectationProduction.do;

/* Replicates Table S5 */;
do $dofiles\EDEX8_Disagreements.do;

/* Replicates Tables S9, S10 */;
qui do $dofiles\EDEX9_Logit_and_Probit.do;

/* Replicates Tables S11 , S12*/;
qui do $dofiles\EDEX10_Pastor_Tim.do;

/* Replicates Tables S13, S154 */;
qui do $dofiles\EDEX11_IV_Tables.do;

/* Replicates Table S15 */;
qui do $dofiles\EDEX12_MNL.do;

/* Replicates Table S16 */;
qui do $dofiles\EDEX13_Other_Outcomes.do;

/* Replicates Table S17 */;
qui do $dofiles\EDEX14_Mechanisms.do; 

/* Figures */;
/* Replicates Figure 1 */;
qui do $dofiles\EDEX15_Figure1.do; 

/* Replicates Figure 2 */;
qui do $dofiles\EDEX16_Figure_S1.do;
