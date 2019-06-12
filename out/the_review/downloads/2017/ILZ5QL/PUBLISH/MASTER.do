** Name: MASTER.do
** Christophe Misner
** Date Created: 06/01/2017
** Last Updated: 
clear all
set maxvar 30000
set more off

** Commands you may need to install :
/*
foreach z in lincomest egenmore ivreg2 outreg2 ranktest estout {
capture ssc install `z'
}
*/

//SET YOUR DIRECTORY HERE:
global DIRECTORY "D:\Dropbox\Publication_data_VP\PUBLISH"

* WINDOWS DIRECTORY
global data "${DIRECTORY}/Data"
global dofiles "${DIRECTORY}/DoFiles"
global appendix "${DIRECTORY}/Results/Appendix"
global paper "${DIRECTORY}/Results/Paper"

* Registration&Turnout base preparation :
do "$dofiles/Var Creation/Registration&Turnout_VarCreation.do"
do "$dofiles/Label/Registration&Turnout_Labeling.do"
do "$dofiles/Label/Registration&Turnout_ValueLabels.do"

* Survey base preparation :
do "$dofiles/Var Creation/Survey_VarCreation.do"
do "$dofiles/Label/Survey_Labeling.do"
do "$dofiles/Label/Survey_ValueLabels.do"

* Analyse :
do "$dofiles/Analyse/Analyse.do"
