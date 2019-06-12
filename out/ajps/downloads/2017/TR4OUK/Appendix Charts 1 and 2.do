



clear
//set directory
//bring in data 
insheet using "defenseJan2017-1.csv"



//CHART 2
//Drop these observations after the appointment of the first female defense minister
gen yeardrop = year if ffl_lead1==1
order yeardrop ffl_lead1 sname year
egen yeardrop2 = min(yeardrop), by(ccode)
order yeardrop yeardrop2 ffl_lead1 sname year
drop if year>yeardrop2

//Table 1 Collumns 3, 4, 5 and 6
//Deadly Interstate Disputes
tab deaths_any ffl_lead1 , row co 
//Military Dictatorship
tab dictator1 ffl_lead1, row co 
//Female Executive
tab femeale_exe1 ffl_lead1, row co
//Left-Led Former Military Dictatorships
gen fmdl = left_exe1*fmd1
tab fmdl ffl_lead1, row co
//Peacekeeping
gen peacek = 1 if involve=="TRUE"
replace peacek= 0 if involve=="FALSE"
tab peacek ffl_lead1, row co
//Women in Combat
tab wcombat ffl_lead1, row co
//Self-Appointments
tab self_appoint1 ffl_lead1, row co



////CHART 1 

sort year
gen year_appoint= year+ 1 
order sname year_appoint mil_spend prop_female self_appoint1 wcombat  ccode

keep if ffl_lead1

//identify the years in whchih women were allowed in combat for those countries where wcombat==1
gen womenincombat="N/A" 
replace womenincombat = "1989" if ccode==20 //Canada
replace womenincombat = "1980" if ccode==385 //Norway
replace womenincombat = "1989" if ccode==433 //France
replace womenincombat = "2001" if ccode==368 //Lithuania
replace womenincombat = "1988" if ccode==390 //Denmark
replace womenincombat = "1944" if ccode==210 //Netherlands

//identify year of subsequent appointmetns from worldwideguid to women in leadership
gen  year_of_laterapp= "N/A"
replace year_of_laterapp = "2003" if ccode==780 //Sri Lanka
replace year_of_laterapp = "2001" if ccode==771 //Bangladesh
replace year_of_laterapp = "2001, 2005, 2009, 2012" if ccode==385 // Norway
replace year_of_laterapp = "2006" if ccode==155 //Chile
replace year_of_laterapp = "2012, 2012" if ccode==380 //Sweden
replace year_of_laterapp = "2006" if ccode== 840 //Philippines
replace year_of_laterapp = "2006" if ccode==376 //Lativa
replace year_of_laterapp = "2012" if ccode==51 //Jamica
replace year_of_laterapp = "2012" if ccode== 316 //Chez Republic
replace year_of_laterapp = "2007, 2012" if ccode==130 //Ecuador
replace year_of_laterapp = "2012" if ccode==560 //South Africa


keep mil_spend prop_female self_appoint1 womenincombat sname year_appoint year_of_laterapp 

order sname year_appoint year_of_laterapp mil_spend prop_female self_appoint1 womenincombat  



outsheet using "appendix_table1.csv" , comma replace

