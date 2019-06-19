*Djankov,Freund and Pham. 2010. "Trading on Time", Review of Economics and Statistics, Vol 92, No 1: 166-173*
*TABLE 3*


****Exports to the World****

set matsize 500
cd "I:\TradingOnTime\"

use "PairAgg.dta", clear
keep if union~=0
drop if exporter=="Sierra Leone"
drop union2 union3
sort union
save "WorldTrade1.dta", replace
use "PairAgg.dta", clear
keep if union~=0
drop if exporter=="Sierra Leone"
drop union2 union3 
sort union
rename value value2
rename gdp gdp2
rename gdpc gdpc2
rename id_e id_e2
rename locked locked2
rename time time2

joinby union using "WorldTrade1.dta"
drop if id_e2==id_e
gen diff=id_e-id_e2
drop if diff<0
gen pair=id_e2*1000+id_e
gen ratio_gdp=log(gdp2/gdp)
gen ratio_gdpc=log(gdpc2/gdpc)
gen ratio_time=log(time2/time)
gen diff_lk=locked2-locked
gen ratio_HL=log(value2/value)
keep id_e ratio_HL pair union gdpc gdpc2 ratio_gdp ratio_gdpc ratio_time diff_lk 
save "Union_1.dta", replace


use "PairAgg.dta", clear
keep if union2~=0
drop if exporter=="Sierra Leone"
drop union union3
rename union2 union
sort union
save "WorldTrade1.dta", replace
use "PairAgg.dta", clear
keep if union2~=0
drop if exporter=="Sierra Leone"
drop union union3 
rename union2 union
sort union
rename value value2
rename gdp gdp2
rename gdpc gdpc2
rename id_e id_e2
rename locked locked2
rename time time2

joinby union using "WorldTrade1.dta"
drop if id_e2==id_e
gen diff=id_e-id_e2
drop if diff<0
gen pair=id_e2*1000+id_e
gen ratio_gdp=log(gdp2/gdp)
gen ratio_gdpc=log(gdpc2/gdpc)
gen ratio_time=log(time2/time)
gen diff_lk=locked2-locked
gen ratio_HL=log(value2/value)
drop if id_e==454 & id_e2==480|id_e==480 & id_e2==454
drop if id_e==454 & id_e2==516|id_e==516 & id_e2==454
drop if id_e==454 & id_e2==894|id_e==894 & id_e2==454
drop if id_e==480 & id_e2==516|id_e==516 & id_e2==480
drop if id_e==480 & id_e2==894|id_e==894 & id_e2==480
drop if id_e==516 & id_e2==894|id_e==894 & id_e2==516
keep id_e ratio_HL pair union gdpc gdpc2 ratio_gdp ratio_gdpc ratio_time diff_lk 
save "Union_2.dta", replace

use "PairAgg.dta", clear
keep if union3~=0
drop if exporter=="Sierra Leone"
drop union union2
rename union3 union
sort union
save "WorldTrade1.dta", replace
use "PairAgg.dta", clear
keep if union3~=0
drop if exporter=="Sierra Leone"
drop union union2 
rename union3 union
sort union
rename value value2
rename gdp gdp2
rename gdpc gdpc2
rename id_e id_e2
rename locked locked2
rename time time2

joinby union using "WorldTrade1.dta"
drop if id_e2==id_e
gen diff=id_e-id_e2
drop if diff<0
gen pair=id_e2*1000+id_e
gen ratio_gdp=log(gdp2/gdp)
gen ratio_gdpc=log(gdpc2/gdpc)
gen ratio_time=log(time2/time)
gen diff_lk=locked2-locked
gen ratio_HL=log(value2/value)
drop if id_e==404 & id_e2==800|id_e==800 & id_e2==404
keep id_e ratio_HL pair union gdpc gdpc2 ratio_gdp ratio_gdpc ratio_time diff_lk 
save "Union_3.dta", replace
use "Union_1.dta", clear
append using "Union_2.dta"
append using "Union_3.dta"

log using "Table3", replace
*Aggregate exports to the world*
reg ratio_HL ratio_gdp ratio_gdpc diff_lk, robust cluster (id_e)
reg ratio_HL ratio_time ratio_gdp ratio_gdpc diff_lk, robust cluster (id_e)
keep if gdpc<825 & gdpc2<825|gdpc>=825 & gdpc<3255 & gdpc2>=825 & gdpc2<3255|gdpc>=3255 & gdpc<10065 & gdpc2>=3255 & gdpc2<10065|gdpc>=10065 & gdpc2>=10065
reg ratio_HL ratio_time ratio_gdp ratio_gdpc diff_lk, robust cluster (id_e)
log close

***Locked countries***

use "PairAgg.dta", clear
keep if union~=0
drop if exporter=="Sierra Leone"
replace locked=1 if exporter=="Bolivia"|exporter=="Paraguay"|exporter=="Albania"|exporter=="Bosnia and Herzegovina"
drop if locked==0
gen i=1
sort id_e
merge id_e using "Neighbortime.dta"
drop _merge
drop if i==.
drop i
replace transit=log(transit)

drop union2 union3
sort union
save "WorldTrade1.dta", replace
use "PairAgg.dta", clear
keep if union~=0
drop if exporter=="Sierra Leone"
replace union=1 if exporter=="Switzerland"
replace locked=1 if exporter=="Bolivia"|exporter=="Paraguay"|exporter=="Albania"|exporter=="Bosnia and Herzegovina"
drop if locked==0
sort id_e
merge id_e using "Neighbortime.dta"
drop _merge
drop if value==.
drop union2 union3 
sort union
save "WorldTrade1.dta", replace
rename value value2
rename gdp gdp2
rename gdpc gdpc2
rename id_e id_e2
rename locked locked2
rename time time2
rename transit transit2
joinby union using "WorldTrade1.dta"
drop if id_e2==id_e
gen diff=id_e-id_e2
drop if diff<0
gen pair=id_e2*1000+id_e
gen ratio_gdp=log(gdp2/gdp)
gen ratio_gdpc=log(gdpc2/gdpc)
gen ratio_time=log(time2/time)
gen diff_lk=locked2-locked
gen ratio_HL=log(value2/value)
gen ratio_transit=log(transit2/transit)
keep ratio_transit id_e ratio_HL pair union gdpc gdpc2 ratio_gdp ratio_gdpc ratio_time diff_lk 
save "Union_1.dta", replace


use "PairAgg.dta", clear
keep if union2~=0
drop if exporter=="Sierra Leone"
replace locked=1 if exporter=="Bolivia"|exporter=="Paraguay"|exporter=="Albania"|exporter=="Bosnia and Herzegovina"
drop if locked==0
sort id_e
merge id_e using "Neighbortime.dta"
drop _merge
drop if value==.
replace transit=log(transit)
drop union union3
rename union2 union
sort union
save "WorldTrade1.dta", replace
use "PairAgg.dta", clear
drop if exporter=="Sierra Leone"
replace locked=1 if exporter=="Bolivia"|exporter=="Paraguay"|exporter=="Albania"|exporter=="Bosnia and Herzegovina"
replace union2=1 if exporter=="Albania"|exporter=="Bosnia and Herzegovina"|exporter=="TFYR of Macedonia"
replace union2=2 if exporter=="Bolivia"|exporter=="Paraguay"
replace union2=3 if exporter=="Central African Rep."|exporter=="Zimbabwe"
replace union2=4 if exporter=="Nepal"|exporter=="Mongolia"
keep if union2~=0
drop if locked==0
sort id_e
merge id_e using "Neighbortime.dta"
drop _merge
drop if value==.
drop union union3 
rename union2 union
sort union
rename value value2
rename gdp gdp2
rename gdpc gdpc2
rename id_e id_e2
rename locked locked2
rename time time2
rename transit transit2
joinby union using "WorldTrade1.dta"
drop if id_e2==id_e
gen diff=id_e-id_e2
drop if diff<0
gen pair=id_e2*1000+id_e
gen ratio_gdp=log(gdp2/gdp)
gen ratio_gdpc=log(gdpc2/gdpc)
gen ratio_time=log(time2/time)
gen diff_lk=locked2-locked
gen ratio_HL=log(value2/value)
gen ratio_transit=log(transit2/transit)
drop if id_e==454 & id_e2==480|id_e==480 & id_e2==454
drop if id_e==454 & id_e2==516|id_e==516 & id_e2==454
drop if id_e==454 & id_e2==894|id_e==894 & id_e2==454
drop if id_e==480 & id_e2==516|id_e==516 & id_e2==480
drop if id_e==480 & id_e2==894|id_e==894 & id_e2==480
drop if id_e==516 & id_e2==894|id_e==894 & id_e2==516
keep id_e ratio_HL pair union gdpc gdpc2 ratio_gdp ratio_gdpc ratio_time diff_lk ratio_transit
save "Union_2.dta", replace

use "PairAgg.dta", clear
keep if union3~=0
drop if exporter=="Sierra Leone"
replace locked=1 if exporter=="Bolivia"|exporter=="Paraguay"|exporter=="Albania"|exporter=="Bosnia and Herzegovina"
drop if locked==0
sort id_e
merge id_e using "Neighbortime.dta"
drop _merge
drop if value==.
drop union union2
rename union3 union
sort union
save "WorldTrade1.dta", replace
use "PairAgg.dta", clear
keep if union3~=0
drop if exporter=="Sierra Leone"
replace locked=1 if exporter=="Bolivia"|exporter=="Paraguay"|exporter=="Albania"|exporter=="Bosnia and Herzegovina"
drop if locked==0
sort id_e
merge id_e using "Neighbortime.dta"
drop _merge
drop if value==.
drop union union2 
rename union3 union
sort union
rename value value2
rename gdp gdp2
rename gdpc gdpc2
rename id_e id_e2
rename locked locked2
rename time time2
rename transit transit2
joinby union using "WorldTrade1.dta"
drop if id_e2==id_e
gen diff=id_e-id_e2
drop if diff<0
gen pair=id_e2*1000+id_e
gen ratio_gdp=log(gdp2/gdp)
gen ratio_gdpc=log(gdpc2/gdpc)
gen ratio_time=log(time2/time)
gen diff_lk=locked2-locked
gen ratio_HL=log(value2/value)
gen ratio_transit=log(transit2/transit)
drop if id_e==404 & id_e2==800|id_e==800 & id_e2==404
keep ratio_transit id_e ratio_HL pair union gdpc gdpc2 ratio_gdp ratio_gdpc ratio_time diff_lk 
save "Union_3.dta", replace
use "Union_1.dta", clear
append using "Union_2.dta"
append using "Union_3.dta"

log using "Table4", append
***Landlocked countries***
reg ratio_HL ratio_time ratio_gdp ratio_gdpc, robust cluster (id_e)
reg ratio_HL ratio_transit ratio_gdp ratio_gdpc, robust cluster (id_e)
ivreg ratio_HL (ratio_time=ratio_transit) ratio_gdp ratio_gdpc, robust cluster (id_e)
log close



