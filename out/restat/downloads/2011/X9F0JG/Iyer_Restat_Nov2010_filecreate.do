/*****Stata do file for article: "Direct versus Indirect Colonial Rule in India: Long-Term Consequences"***/
/****this runs on Stata version 10***/
/***this file creates all the files needed to run regressions****/

version 10
set more off
clear
clear matrix
set mem 700m
set matsize 800
capture log close
log using Iyer_Restat_Nov2010_filecreate.log, replace


/*****************************************************/
/***file for table 3***/
/*****************************************************/

use rawfiles/dist_geo.dta, clear
keep dcode_full sands91 barrenrocky91
sort dcode_full
save temp1.dta, replace

use rawfiles/dist_nyears.dta, clear
capture drop _merge
sort dcode_full
save, replace

use rawfiles/yld_brit.dta, clear
capture drop _merge
sort dcode_full
save, replace

/***merging files for table 3***/
use rawfiles/dist_brit.dta
capture drop _merge
sort dcode_full
merge dcode_full using rawfiles/yld_brit.dta
tab _merge
keep if _merge==3

drop _merge
sort dcode_full
merge dcode_full using rawfiles/dist_nyears.dta
tab _merge
keep if _merge==3
drop _merge

sort dcode_full
merge dcode_full using temp1.dta
tab _merge
keep if _merge==3
drop _merge

/****filling in approximate values for missing in Hyderabad and Pashchim Singhbhum***/
replace sands91=0 if sands91==.
replace  barrenrocky91= 0.0192708 if dcode_full==329
replace barrenrocky91= (.0145479 + 0.0162819)/2 if dcode_full==107

gen ann_conquest=(whyannex=="Conquest")
gen ann_ceded=(whyannex=="Ceded"|whyannex=="Grant")
gen ann_lapse=(whyannex=="Lapse")
gen ann_misrule=(whyannex=="Misrule")

replace ydirbrit=0 if ydirbrit==.
replace ydirbrit=ydirbrit/100

/****COLLAPSING TO GET MEANS OVER WHOLE PERIOD****/
replace irr_g=. if year>1982 | irr_g>1
replace phtot=. if year<=1965 | phtot>1

collapse (mean) irr_g pfert phtot lyld lyrice lywhet britdum ydirbrit ann_conquest ann_ceded ann_lapse ann_misrule kcode1 kcode2 kcode3 lat alt totrain so_black so_all so_red sands91 barrenrocky91 coastal, by(dcode_full)

label var irr_g "Proportion of area irrigated"
label var pfert "Fertilizer usage (kg/hectare)"
label var phtot "Proportion sown with high yielding varieties"
label var lyld "Log total yield (15 major crops)"
label var lyrice "Log rice yield"
label var lywhet "Log wheat yield"
label var britdum "British dummy"
label var ydirbrit "Years of direct British rule (*1/100)"
label var ann_conquest "British dummy*conquest"
label var ann_ceded "British dummy*ceded"
label var ann_lapse "British dummy*lapse"
label var ann_misrule "British dummy*misrule"

save table3.dta, replace

/***************************************************************************************/
/**********Creating file for Table 4*******************/
/***************************************************************************************/
use rawfiles/public_tribute_fileready.dta
sort dcode_full
save, replace

use rawfiles/dist_landrev_instru.dta
sort dcode_full
save, replace

use rawfiles/public_depose_fileready.dta
sort dcode_full
save, replace

use rawfiles/dist_brit_instru.dta, clear
capture drop _merge
keep dcode_full state dist_91 dsp* death*
sort dcode_full
save temp1.dta, replace

use rawfiles/public_brit_geo.dta
capture drop _merge
sort dcode_full
merge dcode_full using temp1.dta
tab _merge
pause

keep if _merge==3
drop _merge
sort dcode_full
merge dcode_full using rawfiles/dist_nyears.dta
tab _merge
keep if _merge==3

replace ydirbrit=0 if ydirbrit==.
replace ydirbrit=ydirbrit/100
label var ydirbrit "Years of direct rule /100"

/*****Restricted sample of only non-lapsed districts***/
gen keep=1
replace keep=0 if britdum==1 & whyannex~="Lapse"

/****MAIN EFFECT: KING DIED WITHOUT HEIR IN 1818 TO 1858 (policy of annexation officially revoked by queen in 1858)***/
gen dsp1818to58 =0
for var dsp1-dsp6: replace dsp1818to58=1 if X>1818 & X<=1858
for var dsp1_2-dsp6_2: replace dsp1818to58=1 if X>1818 & X<=1858

/***BIGGER MAIN EFFECT: KING DIED IN 1818 TO 1858***/
gen death1818to58 =0
for var death1-death14: replace death1818to58=1 if X>1818 & X<=1858
for var death1_2-death14_2: replace death1818to58=1 if X>1818 & X<=1858


/****INTERACTION****/
gen instru=dsp1848to56
label var instru "Ruler died without heir in 1848-56"

/***Generating annexation codes***/
gen ann_conquest=(whyannex=="Conquest")
gen ann_ceded=(whyannex=="Ceded"|whyannex=="Grant")
gen ann_lapse=(whyannex=="Lapse")
gen ann_misrule=(whyannex=="Misrule")

/****collapsing file to means only****/
collapse (mean) pprimary pmiddle phigh pphc pphs pcanal pproad britdum ann_conquest ann_ceded ann_misrule ann_lapse ydirbrit kcode1 kcode2 kcode3 lat alt totrain so_black so_all so_red sands91 barrenrocky91 coastdummy instru dtannex death* dsp* keep, by(dcode_full)


/***BIGGER MAIN EFFECT: KING DIED WITHOUT HEIR ANYTIME AFTER 1818*****/
gen dspever=0
for var dsp1-dsp6: replace dspever=1 if X>1818 & X<=1947
for var dsp1_2-dsp6_2: replace dspever=1 if X>1818 & X<=1947

/***Reassign Punjab=1****/
gen lapse=instru
replace lapse=1 if kcode1==1035

/***False instrument****/
gen dsp1858to84=0
for var dsp1-dsp6: replace dsp1858to84=1 if X>=1858 & X<=1884
for var dsp1_2-dsp6_2: replace dsp1858to84=1 if X>=1858 & X<=1884

tab dsp1858to84 if britdum==0
tab kcode1 if dsp1858to84==1

gen instru_fake=dsp1858to84

/****merging with further vars***/
/***tax revenue***/
sort dcode_full
merge dcode_full using rawfiles/public_tribute_fileready.dta
keep if _merge==1|_merge==3
drop _merge


/****land tenure***/
sort dcode_full
merge dcode_full using rawfiles/dist_landrev_instru.dta
keep if _merge==1|_merge==3
drop _merge


/***whether ruler was ever deposed***/
sort dcode_full
merge dcode_full using rawfiles/public_depose_fileready.dta
keep if _merge==1|_merge==3
drop _merge

save table4.dta, replace


/***************************************************************************************/
/**********Creating file for Table 7*******************/
/***************************************************************************************/

use rawfiles/dist_geo.dta, clear
keep dcode_full sands91 barrenrocky91
sort dcode_full
save temp11.dta, replace

use rawfiles/dist_brit_instru.dta, clear
capture drop _merge
keep dcode_full state dist_91 dsp* death*
sort dcode_full
save temp1.dta, replace

use rawfiles/yld_brit.dta, clear
capture drop _merge
sort dcode_full
merge dcode_full using temp1.dta
tab _merge
keep if _merge==3
drop _merge

sort dcode_full
merge dcode_full using temp11.dta
tab _merge
keep if _merge==3
drop _merge

/****filling in approximate values for missing in Hyderabad and Pashchim Singhbhum***/
replace sands91=0 if sands91==.
replace  barrenrocky91= 0.0192708 if dcode_full==329
replace barrenrocky91= (.0145479 + 0.0162819)/2 if dcode_full==107

gen keep=1
replace keep=0 if britdum==1 & whyannex~="Lapse"
replace keep=1 if kcode1==1030

replace irr_g=. if year>1982| irr_g>1
replace phtot=. if year<=1965 | phtot>1

gen dsp1818to58 =0
for var dsp1-dsp6: replace dsp1818to58=1 if X>1818 & X<=1858
for var dsp1_2-dsp6_2: replace dsp1818to58=1 if X>1818 & X<=1858

gen death1818to58 =0
for var death1-death14: replace death1818to58=1 if X>1818 & X<=1858
for var death1_2-death14_2: replace death1818to58=1 if X>1818 & X<=1858

gen instru=dsp1848to56
label var instru "Ruler died without heir in 1848-56"

/***Generating annexation codes***/
gen annex_code=0
replace annex_code=1 if whyannex=="Conquest"
replace annex_code=2 if whyannex=="Ceded"|whyannex=="Grant"
replace annex_code=3 if whyannex=="Misrule"
replace annex_code=4 if whyannex=="Lapse"

/****collapsing file to means only****/
collapse (mean) irr_g pfert phtot lyld lyrice lywhet britdum annex_code kcode1 kcode2 kcode3 lat alt totrain so_black so_all so_red sands91 barrenrocky91 coastal instru dtannex death* dsp* keep, by(dcode_full)

/***Reassign Punjab=1****/
gen lapse=instru
replace lapse=1 if kcode1==1035

/***BIGGER MAIN EFFECT: KING DIED WITHOUT HEIR ANYTIME AFTER 1818*****/
gen dspever=0
for var dsp1-dsp6: replace dspever=1 if X>1818 & X<=1947
for var dsp1_2-dsp6_2: replace dspever=1 if X>1818 & X<=1947

label var irr_g "Proportion of area irrigated"
label var pfert "Fertilizer usage (kg/hectare)"
label var phtot "Proportion sown with high yielding varieties"
label var lyld "Log total yield (15 major crops)"
label var lyrice "Log rice yield"
label var lywhet "Log wheat yield"
label var britdum "British dummy"

save table7.dta, replace

/*******************************************************************************/
/*******table 9a: infant mortality data*****/
/*******************************************************************************/
use rawfiles/public_instru.dta, clear
gen infmort=q1_81 if year==1981
replace infmort=q1_91 if year==1991
keep infmort britdum lat totrain coastdummy sands91 barrenrocky91  year kcode1 instru dtannex so_*
save table9a.dta, replace

/*******************************************************************************/
/*******table 9b: poverty and inequality data*****/
/*******************************************************************************/

use rawfiles/dist_brit_instru.dta, clear
capture drop _merge
keep dcode_full state dist_91 dsp* death*
sort dcode_full
save temp1.dta, replace

use rawfiles/public_brit_geo.dta
capture drop _merge
gen state_brit=state
gen dist_brit=dist_91
keep if year==1991
sort state_brit dist_brit
save temp2.dta, replace

use rawfiles/brit_pov_match.dta
sort state_petia dist_petia
save, replace

use rawfiles/petia_poverty_inequality.dta, clear
gen year_pov= .
replace year_pov=1983 if round==38
replace year_pov =1987 if round==43
replace year_pov =1993 if round==50
replace year_pov =1999 if round==55
keep if sector==1
rename statename state_petia
rename districtname dist_petia

sort state_petia dist_petia
merge state_petia dist_petia using rawfiles/brit_pov_match.dta
tab _merge
keep if _merge==3
drop _merge

sort state_brit dist_brit

merge state_brit dist_brit using temp2.dta
tab _merge
keep if _merge==3
drop _merge
sort dcode_full
merge dcode_full using temp1.dta
tab _merge
keep if _merge==3
drop _merge

gen instru=dsp1848to56
label var instru "Ruler died without heir in 1848-56"

keep round inpov stdlog dtannex instru britdum lat totrain coastdummy sands91 barrenrocky91 kcode1
save table9b.dta, replace

/***********************************************************************/
/*******file for Table 10 and Table A3****************/
/***********************************************************************/

use rawfiles/public61_brit.dta, clear
capture drop _merge
keep dcode_full pprimary pmiddle phigh pruralhc pcanal proad
foreach var of varlist pprimary pmiddle phigh pruralhc pcanal proad  {
	rename `var' `var'61
}

sort dcode_full
save temp2.dta, replace

use rawfiles/dist_brit_instru.dta, clear
capture drop _merge
keep dcode_full state dist_91 dsp* death*
sort dcode_full
save temp1.dta, replace

use rawfiles/public_brit_geo.dta
capture drop _merge
sort dcode_full
merge dcode_full using temp1.dta
tab _merge
keep if _merge==3

/*****Restricted sample of only non-lapsed districts***/
gen keep=1
replace keep=0 if britdum==1 & whyannex~="Lapse"

gen dsp1818to58 =0
for var dsp1-dsp6: replace dsp1818to58=1 if X>1818 & X<=1858
for var dsp1_2-dsp6_2: replace dsp1818to58=1 if X>1818 & X<=1858
gen death1818to58 =0
for var death1-death14: replace death1818to58=1 if X>1818 & X<=1858
for var death1_2-death14_2: replace death1818to58=1 if X>1818 & X<=1858
gen instru=dsp1848to56
label var instru "Ruler died without heir in 1848-56"

/****collapsing file to means only****/
collapse (mean) pprimary pmiddle phigh pphc pphs pcanal pproad britdum kcode1 kcode2 kcode3 lat alt totrain so_black so_all so_red sands91 barrenrocky91 coastdummy instru dtannex death* dsp* keep, by(dcode_full)

/***generating state dummies***/
gen scode_full=int(dcode_full/100)
tab scode_full, gen(statedum)

/****merging with 1961 public goods data****/
capture drop _merge
sort dcode_full
merge dcode_full using temp2.dta
tab _merge
drop _merge
replace pprimary61=. if pprimary>1
gen dspever=0
for var dsp1-dsp6: replace dspever=1 if X>1818 & X<=1947
for var dsp1_2-dsp6_2: replace dspever=1 if X>1818 & X<=1947

/***Reassign Punjab=1****/
gen lapse=instru
replace lapse=1 if kcode1==1035

/***False instrument****/
gen dsp1858to84=0
for var dsp1-dsp6: replace dsp1858to84=1 if X>=1858 & X<=1884
for var dsp1_2-dsp6_2: replace dsp1858to84=1 if X>=1858 & X<=1884

tab dsp1858to84 if britdum==0
tab kcode1 if dsp1858to84==1

gen instru_fake=dsp1858to84
rename pruralhc61 pphc61
rename proad61 pproad61

keep dcode_full pprimary* pmiddle* phigh* pphc* pphs* pcanal* pproad* britdum  lat totrain coastdummy sands91 barrenrocky91 kcode1 dtannex dspever death1848to56 instru instru_fake keep statedum* so_black so_all so_red 

save table10.dta, replace


/*********************************************************************/
/********file for table 11, 1961 public goods**************/
/***********************************************************************/

use rawfiles/public61_brit.dta, clear
gen keep=1
replace keep=0 if britdum==1 & whyannex~="Lapse"
gen dsp1818to58 =0
for var dsp1-dsp6: replace dsp1818to58=1 if X>1818 & X<=1858
for var dsp1_2-dsp6_2: replace dsp1818to58=1 if X>1818 & X<=1858
gen instru=dsp1848to56
label var instru "Ruler died without heir in 1848-56"

/***Reassign Punjab=1****/
gen lapse=instru
replace lapse=1 if kcode1==1035

/****generating dispensaries in place of rural HC***/
gen pdisp=disp/nvill
keep pprimary pmiddle phigh pdisp pruralhc pcanal proad britdum lat totrain coastdummy sands91 barrenrocky91 kcode1 dtannex instru keep
save table11a.dta, replace

/**************************************************************************/
/********file for Table 11, 1911 literacy rates**********************/
/*************************************************************************/
use rawfiles/literacy1911_full.dta, clear
gen plit=lit/tpop
summ plit, detail
summ plit if plit<0.5
gen sexratio=fpop/mpop

save table11b.dta, replace


/**************************************************************************/
/********file for Table 12c, whether ruler ever deposed**********************/
/*************************************************************************/
use rawfiles/dist_brit_instru.dta, clear
capture drop _merge
keep dcode_full state dist_91 dsp* death*
sort dcode_full
save temp1.dta, replace

use rawfiles/public_brit_geo.dta
capture drop _merge
sort dcode_full
merge dcode_full using temp1.dta
tab _merge
keep if _merge==3
drop _merge

rename kcode1 kcode
sort kcode
merge kcode using rawfiles/king_depose_wide.dta
keep if _merge==1|_merge==3
drop _merge
rename kcode kcode1
save temp2.dta, replace

use rawfiles/king_depose_wide.dta, clear
for var depose1 depose2: rename X X_2
rename kcode kcode2
sort kcode2
save temp3.dta, replace

use temp2.dta, clear
sort kcode2
merge kcode2 using temp3.dta
keep if _merge==1|_merge==3
drop _merge

gen keep=1
replace keep=0 if britdum==1 & whyannex~="Lapse"

gen dsp1818to58 =0
for var dsp1-dsp6: replace dsp1818to58=1 if X>1818 & X<=1858
for var dsp1_2-dsp6_2: replace dsp1818to58=1 if X>1818 & X<=1858
gen dspever=0
for var dsp1-dsp6: replace dspever=1 if X>1818 & X<=1947
for var dsp1_2-dsp6_2: replace dspever=1 if X>1818 & X<=1947
gen instru=dsp1848to56
label var instru "Ruler died without heir in 1848-56"

/****GENERATING DEPOSED-IN-POST 1818 DUMMY****/
gen depose_ever=0
for var depose1 depose2 depose1_2 depose2_2: replace depose_ever=1 if X>=1818 & X<=1947 & britdum==0

gen depose_1858=0
for var depose1 depose2 depose1_2 depose2_2: replace depose_1858=1 if X>=1858 & X<=1947 & britdum==0

/****collapsing file to means only****/
collapse (mean) pprimary pmiddle phigh pphc pphs pcanal pproad britdum kcode1 kcode2 kcode3 lat alt totrain so_black so_all so_red sands91 barrenrocky91 coastdummy instru dtannex death* dsp* keep depose*, by(dcode_full)
/***generating state dummies***/
gen scode_full=int(dcode_full/100)
tab scode_full, gen(statedum)
save table12c.dta, replace

***********************************************************************************
*******creating file for combined public goods regressions: Table 4, 8, 10, 12, A2, A5*****
************************************************************************************

use rawfiles/public_tribute_fileready.dta
sort dcode_full
save, replace
use rawfiles/dist_landrev_instru.dta
sort dcode_full
save, replace
use rawfiles/public_depose_fileready.dta
sort dcode_full
save, replace
use rawfiles/dist_brit_instru.dta, clear
capture drop _merge
keep dcode_full state dist_91 dsp* death*
sort dcode_full
save temp1.dta, replace

use rawfiles/public_brit_geo.dta
capture drop _merge
sort dcode_full
merge dcode_full using temp1.dta
tab _merge
keep if _merge==3
drop _merge
sort dcode_full
merge dcode_full using rawfiles/dist_nyears.dta
tab _merge
keep if _merge==3
drop _merge

replace ydirbrit=0 if ydirbrit==.
replace ydirbrit=ydirbrit/100
label var ydirbrit "Years of direct rule /100"

/*****Restricted sample of only non-lapsed districts***/
gen keep=1
replace keep=0 if britdum==1 & whyannex~="Lapse"
gen dsp1818to58 =0
for var dsp1-dsp6: replace dsp1818to58=1 if X>1818 & X<=1858
for var dsp1_2-dsp6_2: replace dsp1818to58=1 if X>1818 & X<=1858
gen death1818to58 =0
for var death1-death14: replace death1818to58=1 if X>1818 & X<=1858
for var death1_2-death14_2: replace death1818to58=1 if X>1818 & X<=1858
gen instru=dsp1848to56
label var instru "Ruler died without heir in 1848-56"

/***Generating annexation codes***/
gen annex_code=0
replace annex_code=1 if whyannex=="Conquest"
replace annex_code=2 if whyannex=="Ceded"|whyannex=="Grant"
replace annex_code=3 if whyannex=="Misrule"
replace annex_code=4 if whyannex=="Lapse"
gen ann_conquest= (annex_code==1)
gen ann_ceded=(annex_code==2)
gen ann_lapse=(annex_code==4)
gen ann_misrule=(annex_code==3)

/****collapsing file to means only****/
collapse (mean)  pprimary pmiddle phigh pphc pphs pcanal pproad britdum annex_code ann_* ydirbrit kcode1 kcode2 kcode3 lat alt totrain so_black so_all so_red sands91 barrenrocky91 coastdummy instru dtannex death* dsp* keep, by(dcode_full)

gen dspever=0
for var dsp1-dsp6: replace dspever=1 if X>1818 & X<=1947
for var dsp1_2-dsp6_2: replace dspever=1 if X>1818 & X<=1947

/***Reassign Punjab=1****/
gen lapse=instru
replace lapse=1 if kcode1==1035

/***False instrument****/
gen dsp1858to84=0
for var dsp1-dsp6: replace dsp1858to84=1 if X>=1858 & X<=1884
for var dsp1_2-dsp6_2: replace dsp1858to84=1 if X>=1858 & X<=1884
tab dsp1858to84 if britdum==0
tab kcode1 if dsp1858to84==1
gen instru_fake=dsp1858to84

/****RESHAPING AND CREATING PUBTYPE DUMMIES****/
for var pprimary pmiddle phigh pphc pphs pcanal pproad \ new public1 public2 public3 public4 public5 public6 public7: gen Y=X
reshape long public , i(dcode_full) j(pubtype)
/****merging with further vars***/
/***tax revenue***/
sort dcode_full
merge dcode_full using rawfiles/public_tribute_fileready.dta
keep if _merge==1|_merge==3
drop _merge
/****land tenure***/
sort dcode_full
merge dcode_full using rawfiles/dist_landrev_instru.dta
keep if _merge==1|_merge==3
drop _merge
/***whether ruler was ever deposed***/
sort dcode_full
merge dcode_full using rawfiles/public_depose_fileready.dta
keep if _merge==1|_merge==3
drop _merge

xi i.pubtype
save combined.dta, replace

***********************************************************************************
*******creating file for Table A1, also used for literacy regressions in table 9*****
************************************************************************************
use rawfiles/dist_brit_instru.dta, clear

capture drop _merge
keep dcode_full state dist_91 dsp* death*
sort dcode_full
save temp1.dta, replace

use rawfiles/public_brit_geo.dta
capture drop _merge
gen state_brit=state
gen dist_brit=dist_91
keep if year==1991
sort state_brit dist_brit
save temp2.dta, replace

/***matching file***/
use rawfiles/brit_manuf_match.dta
sort state_manu dist_manu
save, replace


use rawfiles/vanneman_reeve.dta, clear
sort stateid dlabel
list stateid dlabel if year==91, noobs sepby(stateid)

keep dlabel stateid year pop rural male rmale work workr farm farmr cult cultr alab labr hind hhindr live liver mine miner manf manfr cons consr comm commr tran tranr serv servr mgwrk mgwkr nowk nowkr lit litr sc scr st str othr othrr

replace year=1961 if year==6
replace year=1971 if year==7
replace year=1981 if year==8
replace year=1991 if year==91

rename dlabel dist_manu
gen state_manu=real(stateid)

/***replacing some inconsistent spellings***/
replace dist_manu="Ahmednagar" if dist_manu=="Ahmadnagar"
replace dist_manu="Amritsar" if dist_manu=="Amristar"
replace dist_manu="Jalor" if dist_manu=="Jalaur"
replace dist_manu="Junagadh" if dist_manu=="Janagadh"
replace dist_manu="Mahasana" if dist_manu=="Mahesana"
replace dist_manu="Shahjahanpur" if dist_manu=="Shahjehanpur"
replace dist_manu="Sarguja" if dist_manu=="Surguja"
replace dist_manu="Vishakhapatnam" if dist_manu=="Visakhapatanam"
replace dist_manu="Barabanki" if dist_manu=="Bara Banki"


sort state_manu dist_manu
merge state_manu dist_manu using rawfiles/brit_manuf_match.dta
tab _merge
keep if _merge==3
drop _merge

sort state_brit dist_brit

merge state_brit dist_brit using temp2.dta
tab _merge
keep if _merge==3
drop _merge
sort dcode_full
merge dcode_full using temp1.dta
tab _merge
keep if _merge==3
drop _merge


gen instru=dsp1848to56
label var instru "Ruler died without heir in 1848-56"

gen pmanuf=manf/work
gen pmanufr = manfr/workr

label var pmanuf "Fraction of workforce in manufacturing"
label var pmanufr "Fraction of rural workforce in manufacturing"

gen pfarm = farm/work
gen pfarmr=farmr/workr
gen plit=lit/pop
label var pfarm "Fraction of workforce in farming"
label var pfarmr "Fraction of rural workforce in farming"
label var plit "Literacy rate"


bys year: summ pfarm* pmanuf* plit 
keep pmanuf* pfarm* plit state_manu year kcode1 britdum lat totrain coastdummy sands91 barrenrocky91 instru dtannex dist_manu
save tablea1.dta, replace

**********************************************************************************
*******creating file for Table A4, 1960s political variables*****
************************************************************************************
use rawfiles/dist_brit_instru.dta, clear
capture drop _merge
keep dcode_full state dist_91 dsp* death*
sort dcode_full
save temp1.dta, replace

use rawfiles/public_brit_geo.dta
capture drop _merge
gen state_brit=state
gen dist_brit=dist_91
keep if year==1991
sort state_brit dist_brit
save temp2.dta, replace

/***matching file***/
use rawfiles/brit_elec1960_match.dta
capture rename C1 state_1960
capture rename C2 dist_1960
capture rename C3 dist_brit
capture rename C4 state_brit
drop if state_1960=="state_1960"
sort state_1960 dist_1960
save, replace

use rawfiles/elec_1960s.dta, clear
replace turnout=. if turnout==0
gen winmargin=win_voteshare-ru_voteshare
replace winmargin=100 if win_voteshare==0

collapse (mean) turnout winmargin, by(state_1960 dist_1960)
sort state_1960 dist_1960
merge state_1960 dist_1960 using rawfiles/brit_elec1960_match.dta
tab _merge
keep if _merge==3
drop _merge
sort state_brit dist_brit
merge state_brit dist_brit using temp2.dta
tab _merge
keep if _merge==3
drop _merge
sort dcode_full
merge dcode_full using temp1.dta
tab _merge
keep if _merge==3
drop _merge

gen instru=dsp1848to56
label var instru "Ruler died without heir in 1848-56"
replace turnout=turnout/100
replace winmargin=winmargin/100

keep turnout winmargin britdum lat totrain coastdummy sands91 barrenrocky91 dtannex kcode1 instru state_1960
save tablea4a.dta, replace

**********************************************************************************
*******creating file for Table A4, 1980s political variables*****
************************************************************************************
use rawfiles/dist_brit_instru.dta, clear
capture drop _merge
keep dcode_full state dist_91 dsp* death*
sort dcode_full
save temp1.dta, replace

use rawfiles/fullfile_apr2007.dta, clear
keep  distname rainfall alt lat totrain so_black so_all so_red coastal sands barrenrocky steepsloping state dcode_full  instru_land instru_brit  coastdummy pmusli pcris psikh psc pst maxtemp mintemp avpop tpop totalareasqkm lrate lratet dist_old pprimary pmiddle phigh padltcen pphs pphc pdisp pwell phandpump ptubewell ptap ptank ppowdomes ppowagric pallpower ppost ptgraph pphone pbus pproad
sort dcode_full
save temp3.dta, replace

use rawfiles/final_merged.dta, clear
sort dcode_full
merge dcode_full using temp3.dta
tab _merge
keep if _merge==3
drop _merge
sort dcode_full
merge dcode_full using temp1.dta
tab _merge
drop _merge

keep total_turnout votemargin_share britdum lat totrain coastdummy sands barrenrocky kcode1 dtannex instru_brit
save tablea4b.dta, replace

