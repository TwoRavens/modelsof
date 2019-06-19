********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE DEFINES MACROS AND CALLS OTHER DO-FILES

* DEFINE WORKING DIRECTORY AND CLEAR MEMPRY
	cd ""
	clear
	clear matrix
	clear mata
	set maxvar 20000
	set matsize 10000

* ADO FILES
	// Make sure psmatch2 is installed


* MAIN PAPER *******************************************************************

	* FIGURES

		// FIGURE 1 GENERATED IN GIS
		do DOS/FIG_2.do	
		// FIGURE 3 GENERATED IN GIS
		do DOS/FIG_4.do
		do DOS/FIG_5.do
		do DOS/FIG_6.do
		do DOS/FIG_7.do
		do DOS/FIG_8.do
	
	* TABLES 

		do DOS/TAB_1.do
		do DOS/TAB_2.do
		do DOS/TAB_3.do
		do DOS/TAB_4.do
		do DOS/TAB_5.do
		do DOS/TAB_6.do
		do DOS/TAB_7.do
		do DOS/TAB_8.do // THIS DO FILE GENERATES BOOTSTRAPPED S.E.

		
* APPENDIX *********************************************************************

	* FIGURES
	
		// FIGURE A1 GENERATED IN GIS 
		// FIGURE A2 FROM AHLFELDT ET AL (2012)
		// FIGURE A3 FROM HOYT (1933)
		// FIGURE A4 GENERATED IN GIS
		// FIGURE A5 GENERATED IN GIS
		do DOS/FIG_A6.do 
		do DOS/FIG_A7.do
		do DOS/FIG_A8.do
		do DOS/FIG_A9.do
		
	* TABLES  	
		do DOS/TAB_A1.do
		do DOS/TAB_A2.do
		do DOS/TAB_A3.do
		do DOS/TAB_A4.do
		do DOS/TAB_A5.do
		do DOS/TAB_A6.do	
		do DOS/TAB_A7.do	
	
	* END
