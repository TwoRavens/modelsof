/*=========================================
Title:  belgium.do
Author: Mitchell Hoffman
Purpose: Read Belgium data, tabulate ocp status 
=========================================*/

clear
set more off
cd "C:\Users\Mitch"
insheet using "belgium.csv"

********************** Define occupational status: 1-3

* count if octype=="Resistance" & pwoctype!="Resistance" & pwoctype!=""

gen ocstatus = ""
replace ocstatus = "agrforestfish" if octype=="Farming" | octype=="Forestry" | octype=="Fishing" | octype=="Horticulture"
replace ocstatus = "minmancommtrandmst" if octype=="Mining" | octype=="Manufacturing" | octype=="Commerce" | octype=="Transportation" | octype=="Domestic"
replace ocstatus = "proflibpubserv" if octype == "Liberal Profession" | octype =="Public Service" | octype=="Education" 

/*
Domestic, Commerce |          1
Education, Public Service |          1
Transportation, Commerce |          1
*/

replace ocstatus = "minmancommtrandmst"  if octype=="Domestic, Commerce" | octype=="Transportation, Commerce"
replace ocstatus = "proflibpubserv" if octype=="Education, Public Service"

* Two people with octype of "Liberal Profession, Commerce." Assign one to Group 2, one to Group 3.

replace ocstatus = "minmancommtrandmst" if octype=="Liberal Profession, Commerce" & name=="Duysenx, Paul"
replace ocstatus = "proflibpubserv" if octype=="Liberal Profession, Commerce" & name=="Dubois-Pelerin, Jules"

**********************

label var  obs "Observation number"
label var year "Year recognized as Righteous Among the Nations"
label var names "Names of rescuers in family"
label var name "Rescuer name"
label var fname "First name"
label var person "Man woman or child"
label var occupation "Occupation"
label var octype "Occupation type"
label var farmwords "Farm-related words"
label var pwoccupation "Occupation before the war"
label var pwoctype "Occupation type before the war"
label var ocstatus "Occupational status"

tab ocstatus if person=="Man"






