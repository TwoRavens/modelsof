***********************************************
* Doyle, Graves and Gruber: Ambulance Project
* Main Analytic File Creation
* Created: 16 May, 2016
* Last Edit: 4 April, 2017
global version "5-0"
************************************************
global cohort "ndscv2"
global pct "20"

****
** Set Project Directories and Parameters
****
qui {
  do ./sub-files/setup-directories-and-parameters.do
}

****
** Build Up Analytic File from Raw Medicare Files
****
* This is hte file we use for the quality paper (4/5/17)
do ./sub-files/create-analytic-file-from-raw-medicare-files.do

* This is teh file Mauricio Needs for the Extension of the Ambulance Work (4/5/17)
*do ./sub-files/create-analytic-file-from-raw-medicare-files-2001-to-2011.do


****
** Create Hospital Measures (NOTE: DONE ON LOCAL MACHINE)
****
* File = ambulance-hospital-measures-v2.0.r


****
** Run Regressions
****
* File = ./3fit-regressions.r


  
