
#delimit ;
clear all;
capture log close;
set mem 200m;
set matsize 800;
version 10;
set scheme s1mono, permanently;
set more off;

********************************************************************************;
**** THIS FILES RUNS ALL DOFILES AND GENERATES ALL THE RESULTS IN THE PAPER ****;
**** SEE README.TXT FOR FURTHER DISCUSSION                                  ****;
********************************************************************************; 

*********************************************;
**** BASIC EMPIRICAL RESULTS : SECTION 5 ****;
*********************************************;

*******************************************************************;
**** This file generates Figure 1 in the paper                 ****;
**** And evaluates some statistics about the share of refugees ****;
**** from East Germany in passenger departures from Berlin     ****;
*******************************************************************;

do GraphPassengers.do;

************************************************************************;
**** This file generates the results in Tables 1 and 2 in the paper ****;
**** saving them in logs\*.log and tables\*.out                     ****;
**** See also tables\Table 1 - Time Trends Estimation.xls           ****;
**** and tables\Table 2 - diff in diff.xls                          ****;
************************************************************************;

do TimeTrends.do;

****************************************;
**** FURTHER EVIDENCE : SECTION 6.1 ****;
****************************************;

****************************************************************************;
**** The data reported in Table 3 of the paper are in                   ****;
**** the stata dataset data\international\internationaltable-final.dta  ****;
**** See also tables\Table 3 - International Comparison.xls.            ****; 
**** The dofile below generates the test for the equality of            ****;
**** 1937 and 2002 airport market shares reported in footnote 18        ****;
**** in the paper                                                       ****;
****************************************************************************;

do internationaltable.do;

********************************************************************************;
**** These files generate the statistics on direct connections in the 1930s ****;
**** and in 2002 discussed in Section 6.1 of the paper                      ****;
********************************************************************************;

do hubindex1930s.do;
do hubindex2002.do;

*************************************************;
**** FURTHER EVIDENCE : SECTIONS 6.3 AND 6.4 ****;
*************************************************;

************************************************************************;
**** This file generates the results in Table 4 and Figures 2 and 3 ****;
************************************************************************;

do GravityRegress2002.do;

*****************************************************;
**** This file generates the results in Figure 5 ****;
*****************************************************;

do AllMunicipalities100km.do;

****************************************;
**** FURTHER EVIDENCE : SECTION 6.5 ****;
****************************************;

*****************************************************************;
**** This file generates the results in Table 5 and Figure 4 ****;
*****************************************************************;

do Simulation2002_rev.do;


