*Set working directory-needs to be changed
cd "DIRECTORY"

import delimited "SDWIS_viols.txt", clear 
keep if viofiscyear==2009

gen MR=0
replace MR=1 if vcode==3| vcode==4| vcode==23| vcode==24| vcode==25| vcode==26|vcode==27| vcode==29| vcode==30| vcode==31| vcode==32| vcode==35|vcode==36| vcode==38| vcode==51| vcode==52| vcode==53| vcode==56|vcode==66
gen Health=0
replace Health=1 if vcode==1| vcode==2| vcode==11| vcode==12| vcode==21| vcode==22| vcode==33| vcode==41| vcode==42| vcode==43| vcode==44|vcode==45| vcode==46| vcode==47| vcode==57| vcode==58| vcode==59|vcode==63| vcode==64| vcode==65

export excel using "2009Violations.xlsx", firstrow(variables)




