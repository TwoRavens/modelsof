clear all
capture log close
set more off

insheet using ~/borja2/DATA/sources/ilo_empl.txt, names

replace country = "Trinidad &Tobago" if country=="Trinidad and Tobago"
replace country = "Taiwan" if country=="Taiwan, China"
replace country = "Slovak Republic" if country=="Slovakia"
replace country = "Russia" if country=="Russian Federation"
replace country = "Moldova" if country=="Moldova, Rep. of"
replace country = " Hong Kong" if country=="Hong Kong, China"

save ~/borja2/DATA/sources/ilo_empl.dta, replace

clear

use ~/borja2/DATA/pn_penntable_nov2005.dta

contract country isocode 
drop _freq

joinby country using ~/borja2/DATA/sources/ilo_empl.dta, unmatched(master) update
drop _merge
keep if codesex=="2A"

order isocode source classification codeclassification subclassification codesubclassification

outsheet using ~/borja2/DATA/ilo_to_edit.out, replace

clear

insheet using ~/borja2/DATA/ilo_edited.txt, names

gen i_class = substr(subclassification,length(subclassification),1) if subclassification!="Total" & length(subclassification)>3
replace i_class = subclassification if length(subclassification)==3

replace i_class = substr(subclassification,1,1)+"¬"+substr(subclassification,3,1) if length(subclassification)==3 & substr(subclassification,2,1)==","

replace i_class = subclassification+substr(classification,length(classification),1) if subclassification=="Total"
drop if i_class=="2¬9" | i_class=="0" | i_class=="X"


drop _merge codecountry codetable codeclassification codesubclassification codenote classification subclassification sex codesex table note source codesource

order country isocode i_class

reshape long d, i(isocode i_class) j(year)
reshape wide d, i(isocode year) j(i_class) string

order country isocode year

foreach i in 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q {
replace d`i' = 0 if d`i'==.
}


replace dTotal2 = dTotal3 if dTotal2==.
replace d1 = dA+dB if d1==0 
replace d1 = dA¬B if d1==0 & dA¬B~=.
replace d2 = dC if d2==0
replace d3 = dD if d3==0
replace d4 = dE if d4==0
replace d5 = dF if d5==0
replace d6 = dG+dH if d6==0
replace d6 = dG¬H if d6==0 & dG¬H~=.
replace d7 = dI if d7==0
replace d8 = dJ+dK if d8==0
replace d8 = dJ¬K if d8==0 & dJ¬K~=.
replace d9 = dL+dM+dN+dO+dP+dQ if d9==0

outsheet using ~/borja2/DATA/ilo_to_edit2.out, replace

clear

insheet using ~/borja2/DATA/ilo_edited2.txt, names

foreach i in 1 2 3 4 5 6 7 8 9 a b ab c d cd e de f g h gh i j k jk l m n ln o lo p q lq mn no op oq px qx total2 total3 {
rename d`i' e`i'
}

save ~/borja2/DATA/ilo_employ_with_rev3.dta, replace

drop ea eab eb ec ecd ed ede ee ef eg egh eh ei ej ejk ek el eln elo elq em emn en eno eo eop eoq ep epx eq eqx etotal3

foreach i in 1 2 3 4 5 6 7 8 9 {
replace e`i' = . if e`i'==0
rename e`i' employment`i' 
}

rename etotal2 employment_total

save ~/borja2/DATA/ilo_employment.dta, replace


