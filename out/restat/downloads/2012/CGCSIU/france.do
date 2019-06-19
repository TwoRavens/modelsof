/*=========================================
Title:  france.do
Author: Mitchell Hoffman
Purpose: Read France data, tabulate ocp status 
=========================================*/

clear
set more off
cd "C:\Users\Mitch"

insheet using "france.csv"


gen woctype = octype 
replace woctype = pwoctype if octype=="Resistance" & pwoctype!="Resistance" & pwoctype!=""

gen woccupation = occupation 
replace woccupation = pwoccupation if octype=="Resistance" & pwoctype!="Resistance" & pwoctype!=""

gen ocstatus = ""
replace ocstatus = "agrforestfish" if woctype=="Farming" | woctype=="Forestry" | woctype=="Fishing"
replace ocstatus = "minmancommtrandmst" if woctype=="Mining" | woctype=="Manufacturing" | woctype=="Commerce" | woctype=="Transportation" | woctype=="Domestic"
replace ocstatus = "proflibpubserv" if woctype == "Liberal Profession" | woctype =="Public Service" | woctype=="Public Servant" | woctype=="Education"  

replace ocstatus = "proflibpubserv" if woctype=="Education, Liberal Profession" | woctype=="Public Service, Education"

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
label var woccupation "Occupation during the war"
label var woctype "Occupation type during the war"
label var ocstatus "Occupational status"


tab ocstatus if person=="Man"



