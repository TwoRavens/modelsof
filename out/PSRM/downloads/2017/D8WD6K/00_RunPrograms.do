/*----------------------------------------------------------------------
 
 REPLICATION FILE FOR
 Gerber, Alan S., Gregory A. Huber, Albert H. Fang, and Andrew Gooch. (Forthcoming)
 "Non-Governmental Campaign Communication Providing Ballot Secrecy Assurances Increases
   Turnout: Results from Two Large Scale Experiments"
 Political Science Research and Methods
 
 FILE: 			00_RunPrograms.do
 DESCRIPTION: 	Runs program files to execute all analyses (02_Analysis and 03_Appendix)
 DATE: 			31 Mar 2017
 VERSION: 		1.0

----------------------------------------------------------------------*/

/*
NOTE: IN ORDER TO RUN THE REPLICATION FILES, YOU MUST HAVE INSTALLED
 PACKAGES THAT CAN RUN THE FOLLOWING COMMANDS: 
	outreg2 (ssc install outreg2)
	tabout (ssc install tabout)
	coefplot (net install gr0059)
*/
ssc install outreg2
ssc install tabout
net install gr0059, from(http://www.stata-journal.com/software/sj14-4)



/* BEGIN REPLICATION SCRIPTS */

clear all
set more off, permanently

do "02_Analysis.do"
do "03_Appendix.do"
