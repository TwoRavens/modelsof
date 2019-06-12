* Author: Michael Tomz
* Date: July 15, 2007
* Purpose: Reproduce Tables and Figures in Goldstein, Rivers, and Tomz,
* _International Organization_

version 9.2
about
clear
set mem 300m
dir
use GRT_IO_2007, clear
capture log close
log using GRT_IO_2007, text replace


**************************************
* DESCRIBE AND SUMMARIZE RAW DATASET *
**************************************

des
su

*****************************************************
* CREATE DUMMY VARIABLES FOR GATT/WTO PARTICIPATION *
*****************************************************

* Gatt: Formal membership
gen byte gattF_1 = cond(gatt_1=="wto"|gatt_1=="art33"|gatt_1=="orig"|gatt_1=="art26:5", 1, 0)  /* GATT: Country 1 is formal member */
gen byte gattF_2 = cond(gatt_2=="wto"|gatt_2=="art33"|gatt_2=="orig"|gatt_2=="art26:5", 1, 0)  /* GATT: Country 2 is formal member */

* Gatt: Nonmember participant
gen byte gattN_1 = cond(gatt_1=="col"|gatt_1=="df"|gatt_1=="prov", 1, 0) /* GATT: Country 1 is a NMP */
gen byte gattN_2 = cond(gatt_2=="col"|gatt_2=="df"|gatt_2=="prov", 1, 0) /* GATT: Country 2 is a NMP */

* Gatt: Participation (EITHER formal OR defacto)
gen byte gattP_1 = cond(gatt_1=="out", 0, 1) /* GATT: Country 1 participates */
gen byte gattP_2 = cond(gatt_2=="out", 0 ,1) /* GATT: Country 2 participates */

* Gatt: Interactions
gen byte gattPP = cond(gattP_1==1 & gattP_2==1, 1, 0)
label var gattPP "GATT: Both Participate"
gen byte gattPO = cond((gattP_1==1 & gattP_2==0)|(gattP_1==0 & gattP_2==1), 1, 0)
label var gattPO "GATT: Only one participates"
gen byte gattFF = cond(gattF_1==1 & gattF_2==1,1,0)
label var gattFF "GATT: Both are formal members"
gen byte gattFN = cond((gattF_1==1 & gattN_2==1)|(gattN_1==1 & gattF_2==1),1,0)
label var gattFN "GATT: One formal, one NMP"
gen byte gattFO = cond((gattF_1==1 & gattP_2==0)|(gattP_1==0 & gattF_2==1),1,0)
label var gattFO "GATT: One formal, other is out"
gen byte gattNN = cond(gattN_1==1 & gattN_2==1,1,0)
label var gattNN "GATT: Both nonmbr participants"
gen byte gattNO = cond((gattN_1==1 & gattP_2==0)|(gattP_1==0 & gattN_2==1),1,0)
label var gattNO "GATT: One NMP, other is out"
drop gattF_1 gattF_2 gattN_1 gattN_2 gattP_1 gattP_2 

gen byte round1 = cond(year < 1949, 1, 0)                 /* GATT pre Annecy round */
gen byte round2 = cond(year >= 1949 & year < 1951, 1, 0)  /* Annecy to Torquay round */
gen byte round3 = cond(year >= 1951 & year < 1956, 1, 0)  /* Torquay to Geneva */
gen byte round4 = cond(year >= 1956 & year < 1961, 1, 0)  /* Geneva to Dillon */
gen byte round5 = cond(year >= 1961 & year < 1967, 1, 0)  /* Dillon to Kennedy */
gen byte round6 = cond(year >= 1967 & year < 1979, 1, 0)  /* Kennedy to Tokyo */
gen byte round7 = cond(year >= 1979 & year < 1994, 1, 0)  /* Tokyo to Uruguay */
gen byte round8 = cond(year >= 1994, 1, 0)                /* After Uruguay round */
forvalues i = 1/8 {                                  /* create variables for each of 8 rounds */ 
   gen byte gattPP_round`i' = gattPP * round`i'
   label var gattPP_round`i' "GATT: Both Participate, Round `i'"              
   gen byte gattPO_round`i' = gattPO * round`i'
   label var gattPO_round`i' "GATT: One Participates, Round `i'"             
   local gattPPbyround `gattPPbyround' gattPP_round`i'
   local gattPObyround `gattPObyround' gattPO_round`i'
}
drop round1-round8

* Article 35 invoked by one or both countries?
gen byte gatt35x1 = cond((gatt35_1==1 & gatt35_2==0)|(gatt35_1==0 & gatt35_2==1),1,0) /* only one invokes */
label var gatt35x1 "GATT: One invokes Art 35"
gen byte gatt35x2 = cond(gatt35_1==1 & gatt35_2==1,1,0)  /* both invoke */
label var gatt35x2 "GATT: Both invoke Art 35"

****************************
* GENERATE OTHER VARIABLES *
****************************

quietly tab year, gen(yeardummy)
gen byte ptarecip_nohigher = cond(ptarecip == 1 & colorbit==0, 1, 0)
gen byte ptarecip_withhigher = cond(ptarecip == 1 & colorbit==1, 1, 0)
gen byte gattPP_nocolrecip = cond(gattPP == 1 & colorbit==0 & ptarecip==0, 1, 0)
gen byte gattPP_withcolrecip = cond(gattPP == 1 & (colorbit==1 | ptarecip==1),1,0)
gen byte gattPO_nocolrecip = cond(gattPO == 1 & colorbit==0 & ptarecip==0, 1, 0)
gen byte gattPO_withcolrecip = cond(gattPO == 1 & (colorbit==1 | ptarecip==1),1,0)
gen byte nonrecip_nohigher = cond((gsp==1 | ptanonrecip==1) & colorbit == 0 & ptarecip==0 & gattPP==0 & gattPO==0,1,0)
gen byte nonrecip_withhigher = cond((gsp==1 | ptanonrecip==1) & (colorbit==1 | ptarecip==1 | gattPP==1 | gattPO==1),1,0)

************************************************************
* TABLE 1: THE APPARENT IRRELEVANCE OF GATT/WTO MEMBERSHIP *
************************************************************

di in white _n(2) "Formal membership only: full gravity model with time effects"
areg imports gattFF gattFO ptarecip ptanonrecip gsp currencyunion colorbit gdp distance share_language share_border landlocked island land_area, absorb(year) cluster(directed_dyad_id) robust
estimates store t1_c1
di in white _n(2) "Formal membership only: gravity model with directed-dyad and time effects, sample=`i'"
areg import gattFF gattFO ptarecip ptanonrecip gsp currencyunion colorbit gdp yeardummy*, absorb(directed_dyad_id) cluster(directed_dyad_id) robust
estimates store t1_c2
estimates table t1_c1 t1_c2, se b(%5.2f) keep(gattFF gattFO ptarecip ptanonrecip gsp currencyunion colorbit gdp distance share_language share_border landlocked island land_area) stats(rmse r2 N N_clust) stfmt(%9.2f) title("Table 1, page 53") varwidth(15)

**********************************************************
* TABLE 2: THE EFFECT OF PARTICIPATION IN THE GATT/WTO   *
* TABLE 3: INCREASE IN TRADE AMONG GATT/WTO PARTICIPANTS *
**********************************************************

di in white _n(2) "Participation: 5 categories, dyadic fixed effects"
areg imports gattFF gattNN gattFN gattFO gattNO ptarecip ptanonrecip gsp currencyunion colorbit gdp yeardummy*, absorb(directed_dyad_id) cluster(directed_dyad_id) robust
estimates store t2_c1
di "gattFF: " %3.0f 100 * (exp(_b[gattFF]) - 1) "%"  /* These are the effects in table 3 */
di "gattFN: " %3.0f 100 * (exp(_b[gattFN]) - 1) "%"
di "gattFO: " %3.0f 100 * (exp(_b[gattFO]) - 1) "%"
di "gattNN: " %3.0f 100 * (exp(_b[gattNN]) - 1) "%"
di "gattNO: " %3.0f 100 * (exp(_b[gattNO]) - 1) "%"
test (gattFF=gattNN) (gattFF=gattFN) (gattFO=gattNO)  /* Robust F-test */

di in white _n(2) "Participation: 2 categories, dyadic fixed effects, sample=`i'"
areg imports gattPP gattPO ptarecip ptanonrecip gsp currencyunion colorbit gdp yeardummy*, absorb(directed_dyad_id) cluster(directed_dyad_id) robust
estimates store t2_c2
di "gattPP: " %3.0f 100 * (exp(_b[gattPP]) - 1) "%"
estimates table t2_c1 t2_c2, se b(%5.2f) keep(gattFF gattNN gattFN gattFO gattNO gattPP gattPO ptarecip ptanonrecip gsp currencyunion colorbit gdp) stats(rmse r2 N N_clust) stfmt(%9.2f) title(Table2, p. 54) varwidth(15)

**************************************************
* TABLE 4: EFFECTS BY GATT/WTO NEGOTIATING ROUND *
**************************************************

di in white _n(2) "By round: 2 categories, dyadic fixed effects"
areg imports gattPP_round1 gattPP_round2 gattPP_round3 gattPP_round4 gattPP_round5 gattPP_round6 gattPP_round7 gattPP_round8 gattPO_round1 gattPO_round2 gattPO_round3 gattPO_round4 gattPO_round5 gattPO_round6 gattPO_round7 gattPO_round8  ptarecip ptanonrecip gsp currencyunion colorbit gdp yeardummy* , absorb(directed_dyad_id) cluster(directed_dyad_id) robust
estimates store t4
di "gattPP_round1: " %3.0f 100 * (exp(_b[gattPP_round1]) - 1) "%"
di "gattPP_round2: " %3.0f 100 * (exp(_b[gattPP_round2]) - 1) "%"
di "gattPP_round3: " %3.0f 100 * (exp(_b[gattPP_round3]) - 1) "%"
di "gattPP_round4: " %3.0f 100 * (exp(_b[gattPP_round4]) - 1) "%"
di "gattPP_round5: " %3.0f 100 * (exp(_b[gattPP_round5]) - 1) "%"
di "gattPP_round6: " %3.0f 100 * (exp(_b[gattPP_round6]) - 1) "%"
di "gattPP_round7: " %3.0f 100 * (exp(_b[gattPP_round7]) - 1) "%"
di "gattPP_round8: " %3.0f 100 * (exp(_b[gattPP_round8]) - 1) "%"
estimates table t4, se b(%5.2f) keep(gattPP_round1 gattPP_round2 gattPP_round3 gattPP_round4 gattPP_round5 gattPP_round6 gattPP_round7 gattPP_round8 gattPO_round1 gattPO_round2 gattPO_round3 gattPO_round4 gattPO_round5 gattPO_round6 gattPO_round7 gattPO_round8) stats(rmse r2 N N_clust) stfmt(%9.2f) title(Table4, p. 57) varwidth(15)

************************************
* TABLE 5: EFFECTS BY INCOME GROUP *
************************************

di in white _n(2) "Participation 2 Categories if both industrial"
areg imports gattPP gattPO ptarecip ptanonrecip gsp currencyunion colorbit gdp yeardummy* if industrial_both==1, absorb(directed_dyad_id) cluster(directed_dyad_id) robust
estimates store t5_c1
quietly tab year if industrial_both==1
di "Estimates based on " `r(r)' " years"

di in white _n(2) "Participation 2 Categories if only 1 is industrial"
areg imports gattPP gattPO ptarecip ptanonrecip gsp currencyunion colorbit gdp yeardummy* if industrial_both==0 & industrial_none==0, absorb(directed_dyad_id) cluster(directed_dyad_id) robust
estimates store t5_c2
quietly tab year if industrial_both==0 & industrial_none==0
di "Estimates based on " `r(r)' " years"

di in white _n(2) "Participation 2 Categories if none is industrial"
areg imports gattPP gattPO ptarecip ptanonrecip gsp currencyunion colorbit gdp yeardummy* if industrial_none==1, absorb(directed_dyad_id) cluster(directed_dyad_id) robust
estimates store t5_c3
quietly tab year if industrial_none==1
di "Estimates based on " `r(r)' " years"

estimates table t5_c1 t5_c2 t5_c3, se b(%5.2f) keep(gattPP gattPO ptarecip) stats(rmse r2 N N_clust) stfmt(%9.2f) title(Table5, p. 58) varwidth(15)

****************
* ARTICLE XXXV *
****************

di in white _n(2) "Participation: 2 categories with article 35, dyadic fixed effects, sample=`i'"
areg imports gattPP gattPO gatt35x1 gatt35x2 ptarecip ptanonrecip gsp currencyunion colorbit gdp yeardummy*, absorb(directed_dyad_id) cluster(directed_dyad_id) robust
tab gatt35x1 if e(sample)
tab gatt35x2 if e(sample)
di "gatt35x2: " %3.0f 100 * (exp(_b[gatt35x2]) - 1) "%"
di "gatt35x1: " %3.0f 100 * (exp(_b[gatt35x1]) - 1) "%"
areg imports gattPP gattPO gatt35x1 gatt35x2 ptarecip ptanonrecip gsp currencyunion colorbit gdp yeardummy* if name_1~="Japan" & name_2~="Japan", absorb(directed_dyad_id) cluster(directed_dyad_id) robust
di "gatt35x2: " %3.0f 100 * (exp(_b[gatt35x2]) - 1) "%"
di "gatt35x1: " %3.0f 100 * (exp(_b[gatt35x1]) - 1) "%"

***********************************************************************
* TABLE 6: TRADE AGREEMENTS - ADDITIVE OR HIERARCHICAL                *
* TABLE 7: INCREASE IN TRADE WITH AND WITHOUT HIGHER-ORDER AGREEMENTS *
***********************************************************************

di _n(2) "Hierarchy of Agreements (tested): dyadic fixed effects"
areg imports colorbit ptarecip_nohigher gattPP_nocolrecip gattPO_nocolrecip nonrecip_nohigher currencyunion gdp yeardummy* , absorb(directed_dyad_id) cluster(directed_dyad_id) robust
estimates store t6_c1
areg imports colorbit ptarecip_nohigher ptarecip_withhigher gattPP_nocolrecip gattPP_withcolrecip gattPO_nocolrecip gattPO_withcolrecip nonrecip_nohigher nonrecip_withhigher currencyunion gdp yeardummy*, absorb(directed_dyad_id) cluster(directed_dyad_id) robust
estimates store t6_c2
di "colorbit: " %3.0f 100 * (exp(_b[colorbit]) - 1) "%"
di "ptarecip_nohigher: " %3.0f 100 * (exp(_b[ptarecip_nohigher]) - 1) "%"
di "ptarecip_withhigher: " %3.0f 100 * (exp(_b[ptarecip_withhigher]) - 1) "%"
di "gattPP_nocolrecip: " %3.0f 100 * (exp(_b[gattPP_nocolrecip]) - 1) "%"
di "gattPP_withcolrecip: " %3.0f 100 * (exp(_b[gattPP_withcolrecip]) - 1) "%"
di "gattPO_nocolrecip: " %3.0f 100 * (exp(_b[gattPO_nocolrecip]) - 1) "%"
di "gattPO_withcolrecip: " %3.0f 100 * (exp(_b[gattPO_withcolrecip]) - 1) "%"
di "nonrecip_nohigher: " %3.0f 100 * (exp(_b[nonrecip_nohigher]) - 1) "%"
di "nonrecip_withhigher: " %3.0f 100 * (exp(_b[nonrecip_withhigher]) - 1) "%"
estimates table t6_c1 t6_c2, se b(%5.2f) keep(colorbit ptarecip_nohigher ptarecip_withhigher gattPP_nocolrecip gattPP_withcolrecip gattPO_nocolrecip gattPO_withcolrecip nonrecip_nohigher nonrecip_withhigher currencyunion gdp) stats(rmse r2 N N_clust) stfmt(%9.2f) title(Table6, p. 60) varwidth(15)
test ptarecip_withhigher gattPP_withcolrecip gattPO_withcolrecip nonrecip_withhigher

**************
* APPENDIX 1 *
**************

tab name_1 if e(sample)
return list

**********************************************************
* TABLE 8: EFFECTS OF INTERNAITONAL AGREEMENTS OVER TIME *
**********************************************************

* save memory by deleting some variables
drop *round* gatt_* industrial* *_nohigher *_withhigher 
drop gattPP_* gattPO_* gatt35* gattFF gattFN gattFO gattNN gattNO
drop share_language land_area island landlocked share_border distance

* Make natural (restricted) cubic splines
* the following loop specifies the knot locations for each time spline (each trade agreement has its own time spline)
gen time01 = (year-1946)/58             /* time, measured on a zero-to-one scale */
local splines gattPP 1953 1976 1999 gattPO 1953 1976 1999 colorbit 1951 1960 1970 ptarecip 1963 1981 1999 currencyunion 1951 1975 1999
while "`splines'" ~= "" {
   gettoken var splines : splines
   gettoken knot1 splines : splines
   gettoken knot2 splines : splines
   gettoken knot3 splines : splines
   local knot1 = (`knot1'-1946)/58
   local knot2 = (`knot2'-1946)/58
   local knot3 = (`knot3'-1946)/58
   rc_spline time01, knots(`knot1' `knot2' `knot3') 
   rename _Stime011 `var'_ns1
   rename _Stime012 `var'_ns2
   gen `var'_x_ns1 = `var' * `var'_ns1
   gen `var'_x_ns2 = `var' * `var'_ns2
}

* Estimation with natural splines
areg imports gattPP gattPP_x_ns* gattPO gattPO_x_ns* colorbit colorbit_x_ns* ptarecip ptarecip_x_ns* currencyunion currencyunion_x_ns* ptanonrecip gsp gdp yeardummy*, absorb(directed_dyad_id) cluster(directed_dyad_id) robust
mat V = e(V)
foreach var in gattPP gattPO ptarecip colorbit currencyunion {
   gen `var'_naturalspline = 100 * ( exp( _b[`var'] + _b[`var'_x_ns1]*`var'_ns1 + _b[`var'_x_ns2]*`var'_ns2 ) - 1 )
   local tokeep `tokeep' `var'_naturalspline
}
keep year `tokeep'
duplicates drop year, force
foreach v in `tokeep' {
   format `v' %4.0f
}
replace ptarecip_naturalspline = . if year < 1960
replace colorbit_naturalspline = . if year > 1980
sort year
list year `tokeep' if year==1950 | year==1960 | year==1970 | year==1980 | year==1990 | year==2000

************
* FIGURE 1 *
************

line gattPP_naturalspline colorbit_naturalspline currencyunion_naturalspline ptarecip_naturalspline year, ///
   xlabel(1945(10)2005) ytitle(Percent increase in trade) xtitle(Year) clpattern(solid solid dot dash) ///
   clcolor(black gs10 black black) ylabel(0(50)200, nogrid angle(horizontal)) legend(off) ///
   text(165 1948 "Colonial orbit", placement(e)) text(70 1948 "GATT", placement(e)) ///
   text(29 1992 "Currency union",placement(e)) text(9 1960 "PTA", placement(e)) /// 
   plotregion(style(none)) scheme(s1mono)
graph export Figure1.ps, orientation(landscape) logo(off) replace mag(160)

log close

