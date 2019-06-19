/*=========================================
Title:  netherlands.do
Author: Mitchell Hoffman
Purpose: Read Netherlands data, tabulate ocp status 
=========================================*/

clear
set more off

cd "C:\Users\Mitch"
insheet using "netherlands.csv"
 
gen woctype = octype 
replace woctype = pwoctype if octype=="Resistance" & pwoctype!="Resistance" & pwoctype!=""
gen woccupation = occupation 
replace woccupation = pwoccupation if octype=="Resistance" & pwoctype!="Resistance" & pwoctype!=""

drop octype pwoctype occupation pwoccupation
rename woctype octype
rename woccupation occupation

gen ocstatus = ""
replace ocstatus = "agrforestfish" if octype=="Farming" | octype=="Forestry" | octype=="Fishing" | octype=="Horticulture"
replace ocstatus = "minmancommtrandmst" if octype=="Mining" | octype=="Manufacturing" | octype=="Commerce" | octype=="Transportation" | octype=="Domestic"
replace ocstatus = "proflibpubserv" if octype == "Liberal Profession" | octype =="Public Service" | octype=="Education" 

replace ocstatus = "minmancommtrandmst" if octype=="Manufacturing, Public Service"

label var  obs "Observation number"
label var year "Year recognized as Righteous Among the Nations"
label var names "Names of rescuers in family"
label var name "Rescuer name"
label var fname "First name"
label var person "Man woman or child"
label var occupation "Occupation"
label var octype "Occupation type"
label var farmwords "Farm-related words"
label var ocstatus "Occupational status"


tab ocstatus if person=="Man"





