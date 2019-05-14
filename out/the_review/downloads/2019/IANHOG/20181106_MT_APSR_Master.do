/*Replication Files 

Created by: Edmund Malesky, Duke University
Date: November 6, 2018
STATA V14

To use set up a central director for all datasets.  And run the Master .do file and Setup file to build the working data files*/

/*This file has been reproduced both as a .do file and .txt file*/

/*Produced in STATA Version 14.2.  To run, it is necessary to net or ssc install the following 
new commands:
net install outreg2
ssc install codebookout
net install cibar
net install ritest
net install leebounds
*/

/*Data used in replication include:

1. data_outpode_code_ANON.xls (Round 1 Raw Data in Excel)
2. Round2.xls (Round 2 Raw Data in Excel)
3. Round2_data_Report.dta (Round 2 Firms Receiving Response Report)
4. Round3_data_ANON.dta (Round 3 Raw Data in STATA)
5. Round3_data_FieldReport.dta (Survey Firm Report on Factory Access
6. Round1_data_ANON.dta (Processed Round 1 Data)
7. Round2_data_ANON.dta (Processed Round 2 Data)
8. 20181106_RCT_Clean.dta (Cleaned and Processed Data used in All Replication Analyses)*/


/*Codebooks Include:
1. 20181106_RCT_Clean_Codebook.xls.  This is the codebook for all replication files.  It is created by the second .do file below).
2. Round 1 Survey (Baseline)
3. Round 3 Survey (Endline)*/

/*Experimental Design Materials
1. Placebo and Control Treatments (Videos, Presentations, Scripts, Audio, Letters)
2. Comment Cards for Treaments on Clauses
3. Laminated Card of Clauses
4. Ministry Respose Report Sent to Delegates*/


/*All Programs are Described below.  This master file can be used to run all of the analyses at one time 
or to pick individual components to replicate directly.*/

/****************************************************************************************************************************************************************/
/*Do Files*/


/*Set Central Directory*/
cd "C:\Users\ejm5\Dropbox\PartipationCompliance\AER-QJE-The Moon\Replication"

/*1. This file Merges 3 Rounds of Survey into Single File.  All data has been anonomyzed to protect confidentiality of firms.  This includes dropping names, addresses, and GPS information*/
do "do\20181106_MT_APSR_MergeRounds.do"

/*2. This file cleans, labels, and curates raw data to only the variables used in analysis, generating a clean data file and codebook*/
do "do\20181106_MT_APSR_setup.do"

/*3. This file creates Figures 2 and 3 from the Manuscript and Table I3 from the Appendix*/
do "do\20181106_MT_APSR_Figs2&3.do"

/*4. This file creates Tables 2 and 3 from the Manuscript and Tables I1, I2, and I4 from the Appendix*/
do "do\20181106_MT_APSR_Table2&3.do"

/*5. This file creates Table 4 from the Manuscript and Tables J1, J2, and J3 from the Appendix*/
do "do\20181106_MT_APSR_Table4.do"

/*6. This file creates Table 5 from the Manuscript and Tables K1, K2, and L from the Appendix*/
do "do\20181106_MT_APSR_Table5.do"

/*7. This file creates Figure 4 and Footnote 34 (Lee Bounds Test) from the manuscript.*/
do "do\20181106_MT_APSR_Fig4.do"

/*8. This file creates Tables 6 and 7 from the manuscript and Tabls M and O from the Appendix.*/
do "do\20181106_MT_APSR_Table6&7.do"

/*9. This file creates the Appendix D Balance Table.*/
do "do\20181106_MT_APSR_AppendixD.do"

/*10. This file creates the Appendix Figure E and Tables 5 and produces the p-values for Appendix G*/
do "do\20181106_MT_APSR_AppendicesEFGH.do"

/*11. This file creates the Appendix N - Heterogeneous Effects by Size*/
do "do\20181106_MT_APSR_AppendixN.do"






