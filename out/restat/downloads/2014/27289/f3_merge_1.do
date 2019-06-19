


clear 
set more off
clear matrix
set mem 8000m



* loads fare data
use "avgfare.dta", clear
gen origin=substr(mkt,1,3)
gen dest=substr(mkt,4,3)
compress


** merges origin information
************************

* merges origin population and income data
rename origin airport
sort airport year
merge airport year using "clean_bea_pop+pcincome.dta"
rename airport origin
rename pop pop_origin
rename pcinc pcinc_origin
tab _merge
drop if _merge==2
drop _merge


* merges origin faa enplanement data
rename origin airport
sort airport year 
merge airport year using "faa_carrier-airport\top2_all.dta"
tab _merge
drop if _merge==2
drop _merge
compress 
rename airport origin
rename airport_enplane origin_enplane
rename tot_airport_enplane tot_origin_enplane
rename pct_airport_enplane pct_origin_enplane
rename pct_airport_enplane_top2 pct_origin_enplane_top2
rename hub hub_origin
rename treat treat_origin
rename airportyear_rank airportyear_rank_origin
rename totyr_treat totyr_treat_origin
rename cumyr_treat cumyr_treat_origin
rename part_cover part_cover_origin
rename full_cover full_cover_origin
rename either_cover either_cover_origin





** merges dest information
************************

* merges dest population and income data
rename dest airport
sort airport year
merge airport year using "clean_bea_pop+pcincome.dta"
rename airport dest
rename pop pop_dest
rename pcinc pcinc_dest
tab _merge
drop if _merge==2
drop _merge


* merges dest faa enplanement data
rename dest airport
sort airport year 
merge airport year using "top2_all.dta"
tab _merge
drop if _merge==2
drop _merge
compress 
rename airport dest
rename airport_enplane dest_enplane
rename tot_airport_enplane tot_dest_enplane
rename pct_airport_enplane pct_dest_enplane
rename pct_airport_enplane_top2 pct_dest_enplane_top2
rename hub hub_dest
rename treat treat_dest
rename airportyear_rank airportyear_rank_dest
rename totyr_treat totyr_treat_dest
rename cumyr_treat cumyr_treat_dest
rename part_cover part_cover_dest
rename full_cover full_cover_dest
rename either_cover either_cover_dest



** merges segment capacity data
************************
sort mkt year quarter mkttkcarrier
merge mkt year quarter mkttkcarrier using "capacity_segment.dta"
tab _merge
drop if _merge==2
drop _merge




** generates some other variables
************************

* generates mktsize variable as geometric mean of population
gen mktsize=sqrt(pop_origin*pop_dest)
compress

* merges fuel price data
sort year quarter
merge year quarter using "fuelQ_clean.dta" 
tab _merge
drop if _merge==2
drop _merge
compress


* corrects fuel for inflation (fares already corrected prior to dropping)
replace fuel_price=fuel_price/cpi
replace pcinc_origin=pcinc_origin/cpi
replace pcinc_dest=pcinc_dest/cpi


*Determine "hub carrier"
egen totpass_origin_car = total(totpassengers) , by(year quarter origin mkttkcarrier)
egen totpass_dest_car = total(totpassengers) , by(year quarter dest mkttkcarrier)

egen max_o_enplane = max(totpass_origin_car), by(year quarter origin)
egen max_d_enplane = max(totpass_dest_car), by(year quarter origin)

gen hub_o_car = (max_o_enplane ==totpass_origin_car)
gen hub_d_car = (max_d_enplane ==totpass_dest_car)
gen hub_car = (hub_o_car==1 | hub_d_car ==1)

drop totpass_origin_car totpass_dest_car max_o_enplane totpass_dest_car


*Define LCC indicator
gen lcc = (mkttkcarrier=="B6" | mkttkcarrier=="FL" | mkttkcarrier=="F9" | mkttkcarrier=="G4" | mkttkcarrier=="J7" | mkttkcarrier=="KP" | ///
mkttkcarrier=="KN" | mkttkcarrier=="N7" | mkttkcarrier=="NJ" | mkttkcarrier=="NK" | mkttkcarrier=="P9" | mkttkcarrier=="QQ" | ///
mkttkcarrier=="SY" | mkttkcarrier=="SX" | mkttkcarrier=="TZ" | mkttkcarrier=="U5" | mkttkcarrier=="VX" | mkttkcarrier=="W7" | ///
mkttkcarrier=="W9" | mkttkcarrier=="WN" | mkttkcarrier=="WV" | mkttkcarrier=="XP" | mkttkcarrier=="ZA")




* our list:  B6       FL F9      G4 J7    KP KN N7 NJ NK P9    QQ    SY   SX TZ  U5 VX        W7 W9 WN WV XP ZA
* connan list: ASC B6 BF FE FL F9 G4 JI J7 KW KP    N7 NJ NK    PS    S4    SX TZ U5 VX XE W7 XP
* darin list:      B6       FL F9       J7    KP KN N7 NJ NK P9    QQ    SY    TZ          W7 W9 WN WV ZA
    

*AIRLINES NOT IN ONE OR THE OTHER:     
/*
ASC (air star coporation) BF (aero service- republic of congo) FE (PRIMARIS AIRLINES - CHARTER OUT OF LAS VEGAS) G4 (allegiant air)  JI (EASTERN CARRIBEAN AIRLINES)
 KW (Kelowna Flightcraft Air Charter) KN (CHINESE) P9 (PERUVIAN/RUSSIAN) PS (PACIFIC SOUTHWEST) QQ (RENO AIR) S4 (SATA-PORTUGAL)  SY (sun country) SX (skybus airlines-columbus) 
 U5 (USA3000 Airlines) VX (virgin america) XE (express jet) W7 (western pacific) XP  (XTRA AIRWAY - CANSINO EXPRESS BOISE)
* darin lee definition
Air South (WV), Access Air (ZA), AirTran (FL), American Trans Air (TZ), Eastwind (W9), Frontier (F9), JetBlue (B6), Kiwi (KP),
Morris Air (KN), National (N7), Pro Air (P9), Reno (QQ), Southwest (WN), Spirit (NK), Sun Country (SY), ValuJet (J7), Vanguard (NJ) and Western Pacific (W7).
*/



* generates mkt shares, lcc shares and lcc presence indicators
gen mkt_share = totpassengers/mkt_totpassengers
bysort year quarter origin dest: egen lcc_share=total(lcc*mkt_share)
gen lcc_pres = (lcc_share>0)


* generates num firms
sort mkt year quarter mkttkcarrier

gen ind=0
replace ind=1 if year==year[_n-1] & quarter==quarter[_n-1] & mkt==mkt[_n-1] & mkttkcarrier~=mkttkcarrier[_n-1]
bysort mkt year quarter: egen num_firm=total(ind)
drop ind


** generates airport level herfs and shares
*****************************************

*origin
bysort origin year quarter: egen origin_pass=total(totpassengers)
bysort origin year quarter mkttkcarrier: egen origincarr_pass=total(totpassengers)
gen origin_share=origincarr_pass/origin_pass

sort origin year quarter mkttkcarrier
gen ind=0
replace ind=1 if (origin==origin[_n-1] & year==year[_n-1] & quarter==quarter[_n-1] & mkttkcarrier~=mkttkcarrier[_n-1])

bysort origin year quarter: egen origin_herf=total((ind*origin_share)^2)
drop origin_pass origincarr_pass ind

* dest
bysort dest year quarter: egen dest_pass=total(totpassengers)
bysort dest year quarter mkttkcarrier: egen destcarr_pass=total(totpassengers)
gen dest_share=destcarr_pass/dest_pass

sort dest year quarter mkttkcarrier
gen ind=0
replace ind=1 if (dest==dest[_n-1] & year==year[_n-1] & quarter==quarter[_n-1] & mkttkcarrier~=mkttkcarrier[_n-1])

bysort dest year quarter: egen dest_herf=total((ind*dest_share)^2)
drop dest_pass dest_pass ind



** generates mkt level herfs and shares
*****************************************

bysort mkt year quarter: egen mkt_pass=total(totpassengers)
bysort mkt year quarter mkttkcarrier: egen mktcarr_pass=total(totpassengers)
gen route_share=mktcarr_pass/mkt_pass

sort mkt year quarter mkttkcarrier
gen ind=0
replace ind=1 if (mkt==mkt[_n-1] & year==year[_n-1] & quarter==quarter[_n-1] & mkttkcarrier~=mkttkcarrier[_n-1])

bysort mkt year quarter: egen route_herf=total((ind*route_share)^2)
drop mkt_pass mktcarr_pass ind


** gets a has other products indicator
***************************************
gen ones=1
bysort mkt year quarter mkttkcarrier: egen prod_count=total(ones)
gen has_other_prod=0
replace has_other_prod=1 if prod_count>1

drop ones prod_count



* sorts and saves the data
drop couporigin coupdest
compress
sort mkt year quarter mkttkcarrier
save "complete.dta", replace







