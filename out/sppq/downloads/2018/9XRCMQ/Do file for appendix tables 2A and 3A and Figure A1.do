* Loading data, using the user's personal file pathway
use "Holyoke_Brown_More Replication Data for Appendix_SPPQ.dta", clear
* commands to create Table 2A
* upper portion of the table with 1998 correlations
pwcorr multipleauthorities98 collectivebargainingexemption98 automaticwaiver98 legalautonomy98 guaranteedfunding98 fiscalautonomy98, sig
* lower portion of the table with 2006 correlations
pwcorr multipleauthorities06 collectivebargainingexemption06 automaticwaiver06 legalautonomy06 guaranteedfunding06 fiscalautonomy06, sig
* commands to create Table 3A
* upper portion of the table with 1998 factor analysis
factor multipleauthorities98 automaticwaiver98 legalautonomy98 guaranteedfunding98 fiscalautonomy98 collectivebargainingexemption98
* lower portion of the table with 2006 factor analysis
factor multipleauthorities06 automaticwaiver06 legalautonomy06 guaranteedfunding06 fiscalautonomy06 collectivebargainingexemption06
* commands to create the results for reproducing Figure A1 in EXCEL
export excel year cumlaws using "FigA1data.xlsx", firstrow(variables)
* This created a new EXCEL file called "FigA1data.xlsx"
* Open the new EXCEL file
* Use the "Insert" tab in EXCEL to create a line graph and customize
