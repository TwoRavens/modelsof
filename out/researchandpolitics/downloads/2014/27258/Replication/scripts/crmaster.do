clear 
set mem 500M
set maxvar 32767
set more off
capture log close 
set matsize 775 

// Set global path to working directory for this task
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\data_clean
cd "$path"

// Create a log file
capture log close
log using "../logs/clean_data.log", replace


// Show STATA version and installed packages
version 10.1
ado


/***********************************************************************
File-Name:      crmaster.do                         
Date:           Oct 21, 2009
Update:         September 3, 2014
Author:         Fernando Martel Garcia                             
Purpose:        Create data set for Ross Replication with common country
                codes for merging.              
Data Input:     MAIN_REPLICATION_DATA.DTA
                  Annual data from Ross used to create his 5 yr dataset
                REPLICATION DATA - 5 YEARS PANELS.DTA
                  Quinquennial dataset used by Ross in final analysis
                INVARS.CSV  
                  Data from Przeworski et al. downloaded Feb 2008 from 
                  http://politics.as.nyu.edu/object/przeworskilinks.html
                  Contains data on time invariant features of countries
                REG02.csv
                  Data on regime type form same source as INVARS
Output File:    clean_data.log                                       
Data Output:    aclp.dta, ross1y.dta, ross5y.dta, ctydic.dta
Previous file:  Country_Codes.do
Status:         Complete
Machine:        Lenovo X201 Tablet, Windows 7 64-bit Professional, SP1                                 
*************************************************************************/


/**********************************************************************
Copy country dictionary from data_raw directory to data_clean, change 
name to ctydic                                            
***********************************************************************/
copy "../data_raw/country_codes/country_codes.dta" ctydic.dta,  replace
clear

/**********************************************************************
Create individual databases in stata with common identifiers                                               
***********************************************************************/
do ../scripts/craclp    //create Alvarez, Cheibub, Limogni and Przeworski
do ../scripts/crross    //create Ross's data with appropriate cty codes

* After this file run pure_rep_master for pure replication
* and proc_rep_master for procedural replication

exit
