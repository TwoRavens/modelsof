/* REPLICATION FILES for the article:
Spillovers from High-Skill Consumption to Low-Skill Labor Markets 
Francesca Mazzolari and Giuseppe Ragusa
REStat, March 2013, 95(1), 74-86
* 
do file: 01_cex.do
*/

/* 
This do file generates the dataset cex_diary04.dta that pools 4 quarters of 
data from FAMILY, MEMBER and EXPENDITURE files of the 2004 CEX Diary Survey
*/   

* set path for WORKING DIRECTORY
* For the do file to run properly it is necessary to create a folder named "temp" in "WORKING DIRECTORY/dairy04/"
* This folder will store temporary datasets needed to build the final dataset used for the analysis
set more off
empltyp1 empltyp2 hrsprwk1 hrsprwk2 marital1 occulis1 occulis2 ref_race race2 sex_ref sex2 wk_wrkd1 wk_wrkd2  finlwt21 ///
delivery housekeeping babysitting care_elderly city_transportation taxi_service personal_care tot_expenditure, by(newid)