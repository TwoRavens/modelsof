
***********************************************

*Table 5 - All okay
	
use ap_barriers_91510, clear 

generate Order = _n

*Their preparation code
		
gen hhid = subinstr( CASE_ID ,"V","",1)
destring hhid, replace
gen vid=villid
gen vid1=substr(CASE_ID,1,5)
destring vid1, replace
preserve 
use HHexp_food.dta, clear 
rename bis_id hh_id_old 
sort hh_id_old 
save temp.dta , replace 
restore 
sort hh_id_old 
merge hh_id_old using temp.dta , uniqusing 
tab _merge 
erase "temp.dta" 
gen pce_new = HHexpfood_total/hhsize 

*Code I added to bring in this programme (downloaded)
do winsor
*End my code

winsor pce_new, p(0.01) gen(pce_new_w) 
gen logpce_new_w=log(1+pce_new_w)
pca has_tractor has_thresher has_cart has_furniture has_bicycle has_motorcycle has_sewmach has_electr has_teleph
predict wealth_index
local list buy_ins04 reltrust_bas1 DK_basix DK_whereRF dist_rfgauge exp_rainMay06 yrs_school lage_head sexhead ins_other lhhsize sav_May06 loglown_w d_loanMay06 riskav1_jul06 lcultirrpct bua_new cred_basixMay06 leader panch_new group_add logwealth_w wealth_index logpce_new_w farm_inc06 wage_agric inc_total wage_nonagric ins_skill
impute wealth_index `list', gen(wealth_indexi) 
impute logpce_new_w `list', gen(logpce_new_wi) 
local hhcontrols "DK_basixi wealth_indexi logpce_new_wi riskav1_jul06i norm_exp_rainMay06 lcultirrpcti mean_payouts buy_ins04i ins_otheri bua_newi group_addi sched_ct muslim sexheadi lage_headi lhhsizei d_highedu ins_skilli" 
*Village dummies 
tab vid1, gen(VD)
*Interaxns 
foreach X in DK_basixi wealth_indexi logpce_new_wi { 
	gen `X'Xendors_LSA = `X'*endors_LSA 
	gen `X'Xins_edu = `X'*ins_edu 
	gen `X'Xd_highreward = `X'*d_highreward 
	} 

*Table 5 - all okay

reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit, robust 
reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD38, robust 

*VD27 equals 1 for one observation, 0 for all others - completely determined by hhcountrols & remaining VD
reg VD27 `hhcontrols' VD2-VD26 VD28-VD38

reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD38 `hhcontrols', robust 
reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD26 VD28-VD38 `hhcontrols', robust 

reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiX* `hhcontrols' VD2-VD38, robust 
reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiX* `hhcontrols' VD2-VD26 VD28-VD38, robust 

reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiX* `hhcontrols' VD2-VD38, robust 
reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiX* `hhcontrols' VD2-VD26 VD28-VD38, robust 

reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiX* `hhcontrols' VD2-VD38, robust 
reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiX* `hhcontrols' VD2-VD26 VD28-VD38, robust 

*Don't show up in any regression and have no data other than hhid
drop if villid == .

sort Order
drop Order
*Order changes randomly on each run through due to commands above, so on each replication results are different when randomize later on (because data order different) 
*This keeps order consistent

save DatCGTTTV1, replace


	
***********************************************

*Gujarat - All okay

use gu_7, clear 
gen policyprice = .
replace policyprice = 44 if district == "AHMEDABAD" 
replace policyprice = 72 if district == "ANAND"
replace policyprice = 86 if district == "PATAN"
gen pctdiscountT = discountT/policyprice 
foreach rhs in vframe ppay sewa peer survey { 
	gen `rhs'Xpctdiscount = `rhs'T*pctdiscountT 
	} 
gen musgr=muslimT*groupT
gen hingr=hinduT*groupT

*Table 6 - All okay
reg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno)
areg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno) absorb(villageno)
reg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno)
areg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno) absorb(villageno)

*Table 7 - All okay
reg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno)
areg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno) absorb(villageno)
reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno)
areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno) absorb(villageno)
reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno)
areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno) absorb(villageno)
reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno)
areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno) absorb(villageno)

*Completely untreated villages - not included anywhere in experiment
drop if villageno == . 

save DatCGTTTV2, replace

 
