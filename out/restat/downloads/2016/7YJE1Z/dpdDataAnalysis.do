/******************************************************
Use Beijing planning data to check whether planned FAR
respond to changed local conditions 

First created by Junfu Zhang on 2/4/2014
*******************************************************/

clear matrix
set more off
set mem 200m


log using dpdDataAnalysisLog, text replace

use zoning99newest.dta

tab landuse99
ge landusetype99 = substr(landuse99, 1, 1)
replace landusetype99 = "." if landusetype99 == "R" & substr(landuse99, 2, 1) != "1" & substr(landuse99, 2, 1) != "2"
tab landuse06
ge landusetype06 = substr(landuse06, 1, 1)
replace landusetype06 = "." if landusetype06 == "R" & substr(landuse06, 2, 1) != "1" & substr(landuse06, 2, 1) != "2"

ge landusetype = "."
replace  landusetype = "C" if landusetype99 == "C" & landusetype06 == "C"
replace  landusetype = "R" if landusetype99 == "R" & landusetype06 == "R"
tab landusetype //C: Commercial; R: Residential

count if landusetype == "C" & substr(landuse06, 2, 1) == "7" 
// C7: 文物古迹用地 (19/2822 = 0.67%)

ge FAR_Change99_06 = log(far06) - log(far99)

sort landusetype
// *** Table 5, lower panel ***
by landusetype: count if FAR_Change99_06 > 0
by landusetype: count if FAR_Change99_06 == 0
by landusetype: count if FAR_Change99_06 < 0

// *** Table 5, upper panel ***
by landusetype: sum far99 far06

replace dtam = log(dtam)
replace drail1 = log(drail1) 
replace drail2 = log(drail2) 
replace drailbatong = log(drailbatong) 
replace drail13 = log(drail13) 
replace drail5 = log(drail5) 
replace drail10 = log(drail10) 
replace drailolympic = log(drailolympic) 
replace drailairport = log(drailairport) 
replace drailnear = log(drailnear) 
replace drailnear_12 = log(drailnear_12) 
replace dmajorroad = log(dmajorroad)
replace dringroad2 = log(dringroad2)
replace dhighway = log(dhighway)
replace dmidschool_key = log(dmidschool_key)
replace dhosp = log(dhosp) 
replace dpark = log(dpark)

count if drailnear_12 > min(drail1, drail2)
count if drailnear_12 < min(drail1, drail2)

count if drailnear > min(drail1,drail2,drailbatong,drail13,drail5,drail10,drailolympic,drailairport)
count if drailnear < min(drail1,drail2,drailbatong,drail13,drail5,drail10,drailolympic,drailairport)

ge dist_change = drailnear - drailnear_12 //Current distance minus distance to line 1&2 (in 1999)
sum dist_change 

 

ge log_far99 = log(far99)
ge log_far06 = log(far06)

sum log_far99, detail
sum log_far06, detail


corr FAR_Change99_06 dtam drailnear_12 dist_change dmajorroad dringroad2 dhighway ///
 dmidschool_key dhosp dpark if landusetype == "R"
corr FAR_Change99_06 dtam drailnear_12 dist_change dmajorroad dringroad2 dhighway ///
 dmidschool_key dhosp dpark if landusetype == "C"
corr FAR_Change99_06 dtam drailnear_12 dist_change dmajorroad dringroad2 dhighway ///
 dmidschool_key dhosp dpark

 
//For new draft tables *** Table 6 ***
xi: regr FAR_Change99_06 dist_change log_far99 if landusetype == "R", cluster(district)
xi: regr FAR_Change99_06 dist_change log_far99 if landusetype == "C", cluster(district)
//For new draft tables *** Table 6 ***
xi: regr FAR_Change99_06 dist_change log_far99 drailnear_12 dtam dringroad2 dhighway ///
dmidschool_key dhosp dpark i.district if landusetype == "R", cluster(district)
xi: regr FAR_Change99_06 dist_change log_far99 drailnear_12 dtam dringroad2 dhighway ///
dmidschool_key dhosp dpark i.district if landusetype == "C", cluster(district)
 
clear
log close
