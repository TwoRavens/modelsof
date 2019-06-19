clear all
capture log close
set more off

insheet using ~/borja2/DATA/sources/ilo_wages.txt, names

/* I already replaced in the original file the names of countries that differed from those in pn_penntable_nov2005.dta.*/

save ~/borja2/DATA/sources/ilo_wages.dta, replace

clear

use ~/borja2/DATA/pn_penntable_nov2005.dta

contract country isocode 
drop _freq

joinby country using ~/borja2/DATA/sources/ilo_wages.dta, unmatched(master) update
keep if codesex=="5A"
drop if codeworkercoverage=="5" | codeworkercoverage=="5$" |codeworkercoverage=="5%" 

drop _merge sex codesex codesubclassification

order isocode source codeclassification subclassification typeofdata workercoverage d*

outsheet using ~/borja2/DATA/ilo2_to_edit.out, replace

clear

set more off

insheet using ~/borja2/DATA/ilo2_edited.txt, names

gen i_class = substr(subclassification,length(subclassification),1) if subclassification!="Total" & length(subclassification)>3
replace i_class = subclassification if length(subclassification)==3

replace i_class = substr(subclassification,1,1)+"¬"+substr(subclassification,3,1) if length(subclassification)==3 & substr(subclassification,2,1)==","

replace i_class = subclassification+substr(codeclassification,length(codeclassification),1) if subclassification=="Total"
drop if i_class=="2¬9" | i_class=="0" | i_class=="X"

order country isocode i_class

reshape long d, i(isocode i_class) j(year)
replace d = d*160 if codetypeofdata==51 /*code for earnings per hour*/
replace d = d*4 if codetypeofdata==53 /*code for earnings per week*/
drop source codeclassification subclassification typeofdata workercoverage currency codesource codetypeofdata codeworkercoverage
reshape wide d, i(isocode year) j(i_class) string

order country isocode year

foreach i in 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q {
replace d`i' = 0 if d`i'==.
}

joinby isocode year using ~/borja2/DATA/ilo_employ_with_rev3.dta, unmatched(master)
drop _merge

foreach i in 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q {
replace e`i' = 0 if e`i'==.
}

replace dTotal2 = dTotal3 if dTotal2==.
replace d1 = dA¬B if d1==0 & dA¬B~=.
replace d2 = dC if d2==0
replace d3 = dD if d3==0
replace d4 = dE if d4==0
replace d5 = dF if d5==0
replace d6 = dG¬H if d6==0 & dG¬H~=.
replace d7 = dI if d7==0

replace d1 = ea/(ea+eb)*dA+eb/(ea+eb)*dB if d1==0 & (dA~=0 & ea~=0) | (dB~=0 & eb~=0)

replace d6 = eg/(eg+eh)*dG+eh/(eg+eh)*dH if d6==0 & (dG~=0 & eg~=0) | (dH~=0 & eh~=0)

replace d8 = ej/(ej+ek)*dJ+ek/(ej+ek)*dK if d8==0 & (dJ~=0 & ej~=0) | (dK~=0 & ek~=0)

replace d9 = el/(el+em+en+eo+ep+eq)*dL+em/(el+em+en+eo+ep+eq)*dM+en/(el+em+en+eo+ep+eq)*dN+eo/(el+em+en+eo+ep+eq)*dO+ep/(el+em+en+eo+ep+eq)*dP+eq/(el+em+en+eo+ep+eq)*dQ if d9==0 & ((dL~=0 & el~=0) | (dM~=0 & em~=0) | (dN~=0 & en~=0) | (dO~=0 & eo~=0) | (dP~=0 & ep~=0) | (dQ~=0 & eq~=0))

drop dA dA¬B dB dC dC¬D dC¬E dC¬O dC¬Q dD dE dF dG dG¬H dH dI dJ dK dL dL¬Q dM dN dO dP dQ dTotal2 dTotal3 e*
drop if d1==0 & d2==0 & d3==0 & d4==0 & d5==0 & d6==0 & d7==0 & d8==0 & d9==0

foreach i in 1 2 3 4 5 6 7 8 9 {
replace d`i' = . if d`i'==0
rename d`i' earnings`i' 
}

save ~/borja2/DATA/ilo_earnings.dta, replace

joinby isocode year using ~/borja2/DATA/sources/ifs_exch.dta
joinby isocode year using ~/borja2/DATA/sources/wdi_exch.dta
joinby year using ~/borja2/DATA/sources/deflator.dta

foreach i in 1 2 3 4 5 6 7 8 9 {
gen earnings_us`i' = (earnings`i'/xr)*(deflator_usa)*(gdp_constant_intl/gdp_constant_us)
}

foreach i in 1 2 3 4 5 6 7 8 9 {
replace earnings_us`i' = (earnings`i'/(gdp_current_lcu/gdp_current_us))*(deflator_usa)*(gdp_constant_intl/gdp_constant_us) if isocode=="TUR" | isocode=="ROM"
}

sort country year

save ~/borja2/DATA/ilo_earnings_us.dta, replace
