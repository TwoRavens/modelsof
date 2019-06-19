/*************************************************/
/****DO FILE CREATED BY SHAREEN JOSHI ************/
/*************************************************/

clear
set memory 1200000 
pause on 
set more off


global Input "C:\Matlab\data2"         /* PLACE YOUR INPUT DIRECTORY PATHWAY HERE */ 
global Output "C:\Matlab\Cousins"      /* PLACE YOUR OUTPUT DIRECTORY PATHWAY HERE */ 

clear
run ${Output}/DoFiles/CreateRoster.do
run ${Output}/DoFiles/MarriageHistories.do
run ${Output}/DoFiles/VillageChars.do
run ${Output}/DoFiles/Siblings.do
run ${Output}/DoFiles/Parents.do
run ${Output}/DoFiles/HouseholdAssets.do
run ${Output}/DoFiles/Transfers.do
run ${Output}/DoFiles/Education.do
run ${Output}/DoFiles/SpEducation.do
run ${Output}/DoFiles/strTonumeric.do
run ${Output}/DoFiles/DefineVars.do
run ${Output}/RainInstr.do

erase Rain2.dta
erase junk.dta
erase BariInfo.dta
