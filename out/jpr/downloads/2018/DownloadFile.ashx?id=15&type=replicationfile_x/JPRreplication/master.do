
***********************************
***********************************
* REPLICATION
*
* IDEOLOGY AND STATE TERROR
* How officer beliefs shaped repression during Argentina’s ‘Dirty War’
*
* JOURNAL OF PEACE RESEARCH
*
* Author: Adam Scharpf (University of Mannheim)		   
* 	
* Date: Feb 2018		
*
* Do-File: master.do
************************************
************************************

*Before you run do-file make sure
* - you use Stata 15.1 SE (otherwise maineffect.do and jackknife.do will not run)
* - relvenat packages are installed
* 	-> Spmap package
* 	-> Clarify package
*	-> labutil package
* - you have changed the working directory, data path, and figure path listed below


version 15.1
set more off

clear all

*************************************
*Setting paths
*************************************

cd "C:\Documents\Dropbox\JPRreplication\"										//Change working directory to location of "JPRreplication" folder

global datapath="C:\Documents\Dropbox\JPRreplication\Data"						//Change path to load datasets from "Data" folder					
global figurepath="C:\Documents\Dropbox\JPRreplication\Figures"					//Change path to save figures in "Figures" folder

*************************************
*Log-file of regression results
*************************************

log using "ScharpfJPRIdeologyTerror", replace


*************************************
*REPLICATION: SCHARPF, ADAM (2018). IDEOLOGY AND STATE TERROR. JOURNAL OF PEACE RESEARCH.
************************************

*Replicating map (Figure 1)
do DoFiles/map.do

*Replicating timeline figure (Figure 2)
do DoFiles/timefigure.do

*Replicating descriptive figures (Figures 3-6)
do DoFiles/figures.do

*Replicating main analysis (Table I)
do DoFiles/mainanalysis.do

*Replicating substantive effects (Figure 7 - Please be patient, this may take some time to run)
do DoFiles/maineffect.do

*Replicating robustness check (Table II)
do DoFiles/robustcheck.do

*Replicating robustness checks (Online appendix)
do DoFiles/checksappendix.do

*Replicating jackknifing procedure (Online appendix - Please be patient, this may take some time to run)
do DoFiles/jackknife.do


log close 
clear all



