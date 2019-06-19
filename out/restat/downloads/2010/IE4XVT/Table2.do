*Djankov,Freund and Pham. 2010. "Trading on Time", Review of Economics and Statistics, Vol 92, No 1: 166-173*
*TABLE 2 - Effect of Time Costs on Export Volumes*

set matsize 500
cd "I:\TradingOnTime\"

use "Pair_Agg.dta", clear
keep if union~=0
drop if value==.
drop union2 union3
gen igroup=union*1000+id_i
sort igroup
save "WorldTrade1.dta", replace
use "Pair_Agg.dta", clear
keep if union~=0
drop if value==.
drop union2 union3 
gen igroup=union*1000+id_i
sort igroup
rename value value2
rename gdp gdp2
rename gdpc gdpc2
rename id_e id_e2
rename locked locked2
rename time time2
rename signatures signatures2
rename timei timei2
rename doci doci2
rename signi signi2
rename inspected_i inspected_i2
rename rem rem2
rename contig contig2
rename lang_off lang_off2
rename lang_eth lang_eth2
rename colony colony2
rename comcol comcol2
rename dist dist2

joinby igroup using "WorldTrade1.dta"
drop if id_e2==id_e
gen diff=id_e-id_e2
drop if diff<0
gen pair=id_e2*1000+id_e
gen ratio_gdp=log(gdp2/gdp)
gen ratio_gdpc=log(gdpc2/gdpc)
gen ratio_rem=log(rem2/rem)
gen ratio_time=log(time2/time)
gen ratio_sign=log(signatures2/signatures)
gen ratio_timei=log(timei2/timei)
gen ratio_signi=log(signi2/signi)
gen ratio_insp=log(inspected_i2/inspected_i)
gen diff_lk=locked2-locked
gen diff_ctg=contig2-contig
gen diff_lg=lang_off2-lang_off
gen diff_lang=lang_eth2-lang_eth
gen diff_col=colony2-colony
gen diff_colo=comcol2-comcol
gen ratio_dt=log(dist2/dist)
gen ratio_HL=log(value2/value)
keep ratio_HL pair union igroup gdpc gdpc2 ratio_gdp ratio_gdpc ratio_rem ratio_time ratio_sign ratio_signi ratio_timei ratio_insp diff_lk diff_ctg diff_lg diff_lang diff_col diff_colo ratio_dt
save "Union_1.dta", replace


use "Pair_Agg.dta", clear
keep if union2~=0
drop if value==.
drop union union3 
rename union2 union 
gen double igroup=union*1000+id_i
sort igroup
save "WorldTrade1.dta", replace
use "Pair_Agg.dta", clear
keep if union2~=0
drop if value==.
drop union union3 
rename union2 union
gen double igroup=union*1000+id_i
sort igroup
rename value value2
rename gdp gdp2
rename gdpc gdpc2
rename id_e id_e2
rename locked locked2
rename time time2
rename signatures signatures2
rename timei timei2
rename doci doci2
rename signi signi2
rename inspected_i inspected_i2
rename rem rem2
rename contig contig2
rename lang_off lang_off2
rename lang_eth lang_eth2
rename colony colony2
rename comcol comcol2
rename dist dist2
joinby igroup using "WorldTrade1.dta"
drop if id_e2==id_e
gen diff=id_e-id_e2
drop if diff<0
gen pair=id_e2*1000+id_e
gen ratio_gdp=log(gdp2/gdp)
gen ratio_gdpc=log(gdpc2/gdpc)
gen ratio_rem=log(rem2/rem)
gen ratio_time=log(time2/time)
gen ratio_sign=log(signatures2/signatures)
gen ratio_timei=log(timei2/timei)
gen ratio_signi=log(signi2/signi)
gen ratio_insp=log(inspected_i2/inspected_i)
gen diff_lk=locked2-locked
gen diff_ctg=contig2-contig
gen diff_lg=lang_off2-lang_off
gen diff_lang=lang_eth2-lang_eth
gen diff_col=colony2-colony
gen diff_colo=comcol2-comcol
gen ratio_dt=log(dist2/dist)
gen ratio_HL=log(value2/value)
drop if id_e==454 & id_e2==480|id_e==480 & id_e2==454
drop if id_e==454 & id_e2==516|id_e==516 & id_e2==454
drop if id_e==454 & id_e2==894|id_e==894 & id_e2==454
drop if id_e==480 & id_e2==516|id_e==516 & id_e2==480
drop if id_e==480 & id_e2==894|id_e==894 & id_e2==480
drop if id_e==516 & id_e2==894|id_e==894 & id_e2==516
keep ratio_HL pair union igroup gdpc gdpc2 ratio_gdp ratio_gdpc ratio_rem ratio_time ratio_sign ratio_signi ratio_timei ratio_insp diff_lk diff_ctg diff_lg diff_lang diff_col diff_colo ratio_dt
save "Union_2.dta", replace

use "Pair_Agg.dta", clear
keep if union3~=0
drop if value==.
drop union2 union 
rename union3 union
gen double igroup=union*1000+id_i
sort igroup
save "WorldTrade1.dta", replace
use "Pair_Agg.dta", clear
drop if value==.
keep if union3~=0
drop union2 union
rename union3 union
gen double igroup=union*1000+id_i
sort igroup
rename value value2

rename gdp gdp2
rename gdpc gdpc2
rename id_e id_e2
rename locked locked2
rename time time2
rename signatures signatures2
rename timei timei2
rename doci doci2
rename signi signi2
rename inspected_i inspected_i2
rename rem rem2
rename contig contig2
rename lang_off lang_off2
rename lang_eth lang_eth2
rename colony colony2
rename comcol comcol2
rename dist dist2
joinby igroup using "WorldTrade1.dta"
drop if id_e2==id_e
gen diff=id_e-id_e2
drop if diff<0
gen pair=id_e2*1000+id_e
gen ratio_gdp=log(gdp2/gdp)
gen ratio_gdpc=log(gdpc2/gdpc)
gen ratio_rem=log(rem2/rem)
gen ratio_time=log(time2/time)
gen ratio_sign=log(signatures2/signatures)
gen ratio_timei=log(timei2/timei)
gen ratio_signi=log(signi2/signi)
gen ratio_insp=log(inspected_i2/inspected_i)
gen diff_lk=locked2-locked
gen diff_ctg=contig2-contig
gen diff_lg=lang_off2-lang_off
gen diff_lang=lang_eth2-lang_eth
gen diff_col=colony2-colony
gen diff_colo=comcol2-comcol
gen ratio_dt=log(dist2/dist)
gen ratio_HL=log(value2/value)
drop if id_e==404 & id_e2==800|id_e==800 & id_e2==404
keep ratio_HL pair union igroup gdpc gdpc2 ratio_gdp ratio_gdpc ratio_rem ratio_time ratio_sign ratio_signi ratio_timei ratio_insp diff_lk diff_ctg diff_lg diff_lang diff_col diff_colo ratio_dt
save "Union_3.dta", replace 
use "Union_1.dta", clear
append using "Union_2.dta"
append using "Union_3.dta"

log using "Table2", replace
*Regional Agreement Sample*
reg ratio_HL ratio_dt ratio_gdp ratio_gdpc diff_ctg diff_col diff_lg diff_lk, robust cluster(pair)
reg ratio_HL ratio_time ratio_dt ratio_gdp ratio_gdpc diff_ctg diff_col diff_lg diff_lk, robust cluster(pair)

*Regional Agreement and Income Group*
keep if gdpc<825 & gdpc2<825|gdpc>=825 & gdpc<3255 & gdpc2>=825 & gdpc2<3255|gdpc>=3255 & gdpc<10065 & gdpc2>=3255 & gdpc2<10065|gdpc>=10065 & gdpc2>=10065
reg ratio_HL ratio_time ratio_dt ratio_gdp ratio_gdpc diff_ctg diff_col diff_lg diff_lk, robust cluster(pair)
log close

***Landlocked countries***

use "Pair_Agg.dta", clear
drop if value==.
replace union=1 if exporter=="Switzerland"
replace union=15 if exporter=="Zimbabwe"
keep if union~=0
drop if locked==0
gen i=1
sort id_e
merge id_e using "Neighbortime.dta"
drop _merge
drop if i==.
drop i

drop union2 union3
gen igroup=union*1000+id_i
sort igroup
save "WorldTrade1.dta", replace
use "Pair_Agg.dta", clear
drop if value==.
replace union=1 if exporter=="Switzerland"
replace union=15 if exporter=="Zimbabwe"

keep if union~=0
drop if locked==0
gen i=1
sort id_e
merge id_e using "Neighbortime.dta"
drop _merge
drop if i==.
drop i

drop union2 union3 
gen igroup=union*1000+id_i
sort igroup
rename value value2
rename gdp gdp2
rename gdpc gdpc2
rename id_e id_e2
rename locked locked2
rename time time2
rename signatures signatures2
rename timei timei2
rename doci doci2
rename signi signi2
rename inspected_i inspected_i2
rename rem rem2
rename contig contig2
rename lang_off lang_off2
rename lang_eth lang_eth2
rename colony colony2
rename comcol comcol2
rename dist dist2
rename transit transit2

joinby igroup using "WorldTrade1.dta"
drop if id_e2==id_e
gen diff=id_e-id_e2
drop if diff<0
gen pair=id_e2*1000+id_e
gen ratio_gdp=log(gdp2/gdp)
gen ratio_gdpc=log(gdpc2/gdpc)
gen ratio_rem=log(rem2/rem)
gen ratio_time=log(time2/time)
gen ratio_sign=log(signatures2/signatures)
gen ratio_timei=log(timei2/timei)
gen ratio_signi=log(signi2/signi)
gen ratio_insp=log(inspected_i2/inspected_i)
gen diff_lk=locked2-locked
gen diff_ctg=contig2-contig
gen diff_lg=lang_off2-lang_off
gen diff_lang=lang_eth2-lang_eth
gen diff_col=colony2-colony
gen diff_colo=comcol2-comcol
gen ratio_dt=log(dist2/dist)
gen ratio_HL=log(value2/value)
gen ratio_transit=log(transit2/transit)
keep ratio_transit ratio_HL pair union igroup gdpc gdpc2 ratio_gdp ratio_gdpc ratio_rem ratio_time ratio_sign ratio_signi ratio_timei ratio_insp diff_lk diff_ctg diff_lg diff_lang diff_col diff_colo ratio_dt
save "Union_1.dta", replace


use "Pair_Agg.dta", clear
drop if value==.
keep if union2~=0
drop if locked==0
gen i=1
sort id_e
merge id_e using "Neighbortime.dta"
drop _merge
drop if i==.
drop i
drop union union3 
rename union2 union 
gen double igroup=union*1000+id_i
sort igroup
save "WorldTrade1.dta", replace
use "Pair_Agg.dta", clear
drop if value==.
keep if union2~=0
drop if locked==0

gen i=1
sort id_e
merge id_e using "Neighbortime.dta"
drop _merge
drop if i==.
drop i

drop union union3 
rename union2 union
gen double igroup=union*1000+id_i
sort igroup
rename value value2
rename gdp gdp2
rename gdpc gdpc2
rename id_e id_e2
rename locked locked2
rename time time2
rename signatures signatures2
rename timei timei2
rename doci doci2
rename signi signi2
rename inspected_i inspected_i2
rename rem rem2
rename contig contig2
rename lang_off lang_off2
rename lang_eth lang_eth2
rename colony colony2
rename comcol comcol2
rename dist dist2
rename transit transit2
joinby igroup using "WorldTrade1.dta"
drop if id_e2==id_e
gen diff=id_e-id_e2
drop if diff<0
gen pair=id_e2*1000+id_e
gen ratio_gdp=log(gdp2/gdp)
gen ratio_gdpc=log(gdpc2/gdpc)
gen ratio_rem=log(rem2/rem)
gen ratio_time=log(time2/time)
gen ratio_sign=log(signatures2/signatures)
gen ratio_timei=log(timei2/timei)
gen ratio_signi=log(signi2/signi)
gen ratio_insp=log(inspected_i2/inspected_i)
gen diff_lk=locked2-locked
gen diff_ctg=contig2-contig
gen diff_lg=lang_off2-lang_off
gen diff_lang=lang_eth2-lang_eth
gen diff_col=colony2-colony
gen diff_colo=comcol2-comcol
gen ratio_dt=log(dist2/dist)
gen ratio_HL=log(value2/value)
gen ratio_transit=log(transit2/transit)
drop if id_e==454 & id_e2==480|id_e==480 & id_e2==454
drop if id_e==454 & id_e2==516|id_e==516 & id_e2==454
drop if id_e==454 & id_e2==894|id_e==894 & id_e2==454
drop if id_e==480 & id_e2==516|id_e==516 & id_e2==480
drop if id_e==480 & id_e2==894|id_e==894 & id_e2==480
drop if id_e==516 & id_e2==894|id_e==894 & id_e2==516
keep ratio_transit ratio_HL pair union igroup gdpc gdpc2 ratio_gdp ratio_gdpc ratio_rem ratio_time ratio_sign ratio_signi ratio_timei ratio_insp diff_lk diff_ctg diff_lg diff_lang diff_col diff_colo ratio_dt
save "Union_2.dta", replace

 
use "Union_1.dta", clear
append using "Union_2.dta"

log using "Table2", append
****Landlocked Countries****
reg ratio_HL ratio_time ratio_dt ratio_gdp ratio_gdpc diff_ctg diff_col diff_lg, robust cluster(pair)
reg ratio_HL ratio_transit ratio_dt ratio_gdp ratio_gdpc diff_ctg diff_col diff_lg, robust cluster(pair)
ivreg ratio_HL (ratio_time=ratio_transit) ratio_dt ratio_gdp ratio_gdpc diff_ctg diff_col diff_lg, robust cluster(pair)
log close

