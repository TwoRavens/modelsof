clear *
set mem 50m
set matsize 800
set more off

* INSTRUMENTS AND CONTROLS
global LHS 		dlnconspc
global CONTROLS schooldmed schooldmedsq sex unmar sexXunmar bothdied bothdied15 mgrade1 fgrade1 /*
 */ clh?0_51 clh?6_101 clh?11_151 clh?16_201 clh?21p1 cle1 cle1Xkm age0 age1 age2 age3 age4 age5 age6
global INST       rh_rel12     rh_rel3     sexXrh_rel3     r_agerankXage0     age0XmaleXkm    dr9103Xage0
global MEANINST   rh_rel12mean rh_rel3mean sexXrh_rel3mean r_agerankXage0mean age0XmaleXkmmax dr9103Xage0min 

******************************************************************************************
* TABLE 11 - EFFECT OF MOVEMENT-SCHOOLING BUNDLE
use growth_data2,replace
drop if dschoolyrs==. 
assert _N==3226 // this is new sample of 3,226 post-R&R (1 obs missing dschoolyrs data)
tab schoolyrs1
tab dschoolyrs moved1
tab schoolyrs2 moved1
tab moved1, sum(dschoolyrs)
regress moved1 dschoolyrs age0 age1 age2 age3 age4 age5 age6
regress moved1 dschoolyrs yearsold
gen yearssq=yearsold^2
regress moved1 dschoolyrs yearsold yearssq if yearsold<16
global CONTROLS dschoolyrs schooldmed schooldmedsq sex unmar sexXunmar bothdied bothdied15 mgrade1 fgrade1 /*
 */ clh?0_51 clh?6_101 clh?11_151 clh?16_201 clh?21p1 cle1 cle1Xkm age0 age1 age2 age3 age4 age5 age6
xi: xtreg  $LHS  moved1 lndismoved dschoolyrs dschXmoved1 dschXlndis /*nonesensical regression to get coeff. in right order in xls file*/
estimates store ind0, title(DELETE ME!!)
* IHHFE without interactions
xi: xtreg  $LHS  moved1     $CONTROLS, fe i(hhid1)
estimates store ihhfe1, title(IHHFE)
xi: xtreg  $LHS  lndismoved $CONTROLS, fe i(hhid1)
estimates store ihhfe2, title(IHHFE)
* IHHFE with interactions
xi: xtreg  $LHS  moved1     dschXmoved1 $CONTROLS, fe i(hhid1)
estimates store ihhfe3, title(IHHFE)
xi: xtreg  $LHS  lndismoved dschXlndis  $CONTROLS, fe i(hhid1)
estimates store ihhfe4, title(IHHFE)
xml_tab ind0 ihhfe1 ihhfe2 ihhfe3 ihhfe4 , ///
    save(growth_regressions.xml) stats(N) title(Table 11: Explaining Consumption Change - IHHFE & 2SLS with schooling interactions) ///
    sd2 replace sheet(T11)

******************************************************************************************
* APPENDIX TABLE 2: Alternative sets of IVs - DROPPING INSTRUMENTS ONE BY ONE
use growth_data2,replace
global CONTROLS schooldmed schooldmedsq sex unmar sexXunmar bothdied bothdied15 mgrade1 fgrade1 /*
 */ clh?0_51 clh?6_101 clh?11_151 clh?16_201 clh?21p1 cle1 cle1Xkm age0 age1 age2 age3 age4 age5 age6
global INST1          rh_rel3 sexXrh_rel3 r_agerankXage0 age0XmaleXkm dr9103Xage0
global INST2 rh_rel12         sexXrh_rel3 r_agerankXage0 age0XmaleXkm dr9103Xage0
global INST3 rh_rel12 rh_rel3             r_agerankXage0 age0XmaleXkm dr9103Xage0
global INST4 rh_rel12 rh_rel3 sexXrh_rel3                age0XmaleXkm dr9103Xage0
global INST5 rh_rel12 rh_rel3 sexXrh_rel3 r_agerankXage0              dr9103Xage0
global INST6 rh_rel12 rh_rel3 sexXrh_rel3 r_agerankXage0 age0XmaleXkm 
scalar drop _all
mat t = J(8,1,.)
mat list t
local i = 0
foreach x in "$INST" "$INST1" "$INST2" "$INST3" "$INST4" "$INST5" "$INST6"  {
	di _newline(5) "i is now equal to " `i'
	sum `x'
	xi: xtivreg2  $LHS  $CONTROLS (moved1 = `x') , fe i(hhid1) first savefp(first)
	mat t1 = (.\_coef[moved1]\_se[moved1]\e(cdf))
	qui xi: xtivreg2  $LHS  $CONTROLS (lndismoved = `x') , fe i(hhid1) first savefp(first)
	mat t2 = (.\_coef[lndismoved]\_se[lndismoved]\e(cdf))
	mat temp = t1\t2
	mat t = t,temp
	mat list t	
	local i = `i' + 1
}
matrix t = t[.,2...]
mat list t
matrix colnames t = All_incl HeadSpouse ChildHead SonHead AgeRank KmCap Rain
matrix rownames t = "MOVED DUMMY" Coeff SE CraggDon "LN DISTANCE" Coeff SE CraggDon 
xml_tab t, save(growth_regressions.xml) append   ///
	format(SCLR3 NCLR2) sheet(AT2) title(Appendix Table 2: Coeff StdErr and Cragg-Donald when specified instrument is omitted)

**************************************************************************
* DESCRIPTIVES *
use growth_data2,replace

* STATS QUOTED IN TEXT
tab remote1
* TABLE 6
for varlist moved1 moveremote movesame moveconnect: tabstat dlnconspc, by(X) s(mean median n)
* TABLE 7
tabstat dlnconspc, by(agmove) s(mean median n) format(%9.2fc)
* TABLE 8
table agmove moved1, c(n dlnconspc median dlnconspc mean dlnconspc) format(%9.2fc) col row

* TABLE APPENDIX 5 - HOUSEHOLD SIZE AND AEU
table move4cat, c( mean hhsize1 median hhsize1 mean hhsize2 median hhsize2 n hhsize1)
table move4cat, c(mean aeu1 median aeu1 mean aeu2 median aeu2 n aeu1)
xi: regress hhsize2 age0 age1 age2 age3 age4 age5 age6 sex i.move4

***********************************
* MEANS OF REGRESSION SAMPLE *
***********************************
* APPENDIX TABLE 1
sum dlnconspc moved1 dismoved lndismoved schooldmed schooldmedsq  rh_rel12 rh_rel3 sexXrh_rel3 r_agerankXage0 age0XmaleXkm dr9103Xage0 sex unmar sexXunmar bothdied bothdied15 mgrade1 fgrade1 /*
 */ clh?0_51 clh?6_101 clh?11_151 clh?16_201 clh?21p1 cle1 cle1Xkm age0 age1 age2 age3 age4 age5 age6
tabstat dlnconspc moved1 dismoved lndismoved schooldmed schooldmedsq  rh_rel12 rh_rel3 sexXrh_rel3 r_agerankXage0 age0XmaleXkm dr9103Xage0 sex unmar sexXunmar bothdied bothdied15 mgrade1 fgrade1 /*
 */ clh?0_51 clh?6_101 clh?11_151 clh?16_201 clh?21p1 cle1 cle1Xkm age0 age1 age2 age3 age4 age5 age6 , stats(mean sd) save
tabstatmat a
mat b = a'
xml_tab b, save(growth_regressions.xml) append format(SCLR3 NCLR2) sheet(AT1)

***********************************
* REGRESSIONS *
***********************************
* MAIN TABLE WITH INDIVIDUAL LEVEL IHHFE & 2SLS RESULTS
xi: xtreg  $LHS  moved1 lndismoved /*nonesensical regression to get coeff. in right order in xls file*/
estimates store ind0, title(DELETE ME!!)
reg  $LHS  moved1     $CONTROLS
estimates store ind02, title(OLS NOT REPORTED)
reg  $LHS  lndismoved $CONTROLS
estimates store ind03, title(OLS NOT REPORTED)

xi: xtreg  $LHS  moved1     $CONTROLS, fe i(hhid1)
estimates store ind1, title(IHHFE)
xi: xtreg  $LHS  lndismoved $CONTROLS, fe i(hhid1)
estimates store ind2, title(IHHFE)
xi: xtivreg2  $LHS  $CONTROLS (moved1 = $INST) , fe i(hhid1) first savefp(first)
estimates store ind3, title(2SLS)
xi: xtivreg2  $LHS  $CONTROLS (lndismoved = $INST) , fe i(hhid1) first savefp(first)
estimates store ind4, title(2SLS)
xml_tab ind0 ind02 ind03 ind1 ind2 ind3 ind4, save(growth_regressions.xml) stats(N) title(T9: Explaining Consumption Change - IHHFE & 2SLS) /*
	*/ sd2 append sheet(T9)
xml_tab firstmoved1 firstlndismoved, save(growth_regressions.xml) stats(N) title(T10: 1st stage Reg of Table 9) /*
	*/ sd2 append sheet(T10)

***********************************
* ROBUSTNESS CHECKS
* MAIN TABLE WITH INDIVIDUAL LEVEL IHHFE & 2SLS RESULTS
* USE AEU
* DIFFERENT IVs

xi: xtreg  dlnconsaeu  moved1 lndismoved /*nonesensical regression to get coeff. in right order in xls file*/
estimates store ind0, title(DELETE ME!!)
xi: xtreg  dlnconsaeu    moved1     $CONTROLS, fe i(hhid1)
estimates store ind1, title(IHHFE)
xi: xtreg  dlnconsaeu    lndismoved $CONTROLS, fe i(hhid1)
estimates store ind2, title(IHHFE)
xi: xtivreg2 dlnconsaeu    $CONTROLS (moved1 = $INST) , fe i(hhid1) first savefp(first)
estimates store ind3, title(2SLS)
xi: xtivreg2  dlnconsaeu    $CONTROLS (lndismoved = $INST) , fe i(hhid1) first savefp(first)
estimates store ind4, title(2SLS)

xml_tab ind0 ind02 ind03 ind1 ind2 ind3 ind4, save(growth_regressions.xml) stats(N) title(AT6: AEU Explaining Consumption Change - IHHFE & 2SLS) /*
	*/ sd2 append sheet(AT6)

* MAIN TABLE WITH HOUSEHOLD LEVEL IHHFE & 2SLS RESULTS
preserve
collapse hhid1 moved1 lndismoved $CONTROLS $LHS khds1size /*
*/	(max)  rh_rel12max=rh_rel12   rh_rel3max=rh_rel3  sexXrh_rel3max=sexXrh_rel3   bothdiedmax=bothdied   age0XmaleXkmmax=age0XmaleXkm   dr9103Xage0max=dr9103Xage0  r_agerankXage0max=r_agerankXage0   /*
*/	(mean) rh_rel12mean=rh_rel12  rh_rel3mean=rh_rel3 sexXrh_rel3mean=sexXrh_rel3  bothdiedmean=bothdied  age0XmaleXkmmean=age0XmaleXkm  dr9103Xage0mean=dr9103Xage0 r_agerankXage0mean=r_agerankXage0  /*
*/	(min)  dr9103Xage0min=dr9103Xage0, by(hhid2)

bys hhid1: drop if _N==1
label var moved1	  	"moved outside community"
label var lndismoved 	"km moved"
label var dlnconspc 	"Change log pc expenditures"
label var schooldmed 	"Deviation of years schooling from peers"
label var schooldmedsq 	"Squared deviation of years schooling from peers"
label var sex 		"Male"
label var unmar 		"Unmarried"
label var sexXunmar 	"Unmarried male"
label var bothdied 	"Both parents died"
label var bothdied15 	"Above 15 & both parents died"
label var clhm0_51	"Male children 0-5"
label var clhm6_101	"Male children 6-10"
label var clhm11_151 	"Male children 11-15"
label var clhm16_201 	"Male children 16-20"
label var clhm21p1 	"Male children 21+"
label var clhf0_51	"Female children 0-5"
label var clhf6_101	"Female children 6-10"
label var clhf11_151 	"Female children 11-15"
label var clhf16_201 	"Female children 16-20"
label var clhf21p1 	"Years of education mother"
label var fgrade1 	"Years of education father"
label var cle1 		"Number of children residing outside HH"
label var cle1Xkm 	"Km from reg. capital * No. outside children"
label var age0 		"Baseline age 5-15"
label var age1 		"Baseline age 16-25"
label var age2 		"Baseline age 26-35"
label var age3 		"Baseline age 36-45"
label var age4 		"Baseline age 46-55"
label var age5 		"Baseline age 56-65"
label var age6		"Baseline age 66+"
label var rh_rel12mean 	"Mean head or spouse"
label var rh_rel3mean 	"Mean child of head"
label var sexXrh_rel3mean 	 "Mean male child of head"
label var r_agerankXage0mean   "Mean age rank in HH * age 5-15"
label var age0XmaleXkmmax 	 "Max km from reg. capital * male * age 5-15"
label var dr9103Xage0min	 "Min average rainfall deviation * age 5-15"

***********************************
xi: xtreg  $LHS  moved1 lndismoved /*nonesensical regression to get coeff. in right order in xls file*/
estimates store hh0, title(DELETE ME!!)
xi: xtreg  $LHS  moved1     $CONTROLS, fe i(hhid1)
estimates store hh1, title(IHHFE)
xi: xtreg  $LHS  lndismoved $CONTROLS, fe i(hhid1)
estimates store hh2, title(IHHFE)
xi: xtivreg2  $LHS  $CONTROLS (moved1 = $MEANINST) , fe i(hhid1) first savefp(hhfirst)
estimates store hh3, title(2SLS)
xi: xtivreg2  $LHS  $CONTROLS (lndismoved = $MEANINST) , fe i(hhid1) first savefp(hhfirst)
estimates store hh4, title(2SLS)

xml_tab hh0 hh1 hh2 hh3 hh4, save(growth_regressions.xml) stats(N) title(TA3: Explaining Consumption Change - IHHFE & 2SLS - Household Level Results) /*
	*/ sd2 append sheet(AT3)
xml_tab hhfirstmoved1 hhfirstlndismoved, save(growth_regressions.xml) stats(N) title(TA4: 1st Stage Reg Table A3) /*
	*/ sd2 append sheet(AT4)
restore
*****************************
* T12 -- CHARACTERISTICS OF THE MOVE
xi: xtreg  $LHS moved1 lndismoved
estimates store con0, title(DELETE)
xtreg $LHS moveremote movesame moveconnect dissame disconnect
estimates store con00, title(DELETE)

xi: xtreg  $LHS         moveremote movesame moveconnect 				$CONTROLS, fe i(hhid1)
estimates store con1, title(IHHFE)
xi: xtreg  $LHS  moved1 movesame moveconnect 				$CONTROLS, fe i(hhid1)
estimates store con2, title(IHHFE)
xi: xtreg  $LHS  lndismoved dissame disconnect				$CONTROLS, fe i(hhid1)
estimates store con3, title(IHHFE)

xml_tab con0 con00 con1 con2 con3, save(growth_regressions.xml) stats(N) title(Table 12 - Explaining Consumption Change: IHHFE, characteristics of the move) /*
	*/ sd2 append sheet(T12)

***********************************
* TABLES FOR OUT OF AGRICULTURE (changed on 6 September 2009 in final version of RR to include also level effect outofag2 in each regression)
xi: xtreg  $LHS  moved1 lndismoved outofag2 outofag2Xmoved1 outofag2Xlndismoved 
estimates store ag0, title(DELETE ME!!)

xi: xtreg  $LHS  			outofag2  			 	$CONTROLS, fe i(hhid1)
estimates store ag1, title(IHHFE)
xi: xtreg  $LHS  moved1 	outofag2 outofag2Xmoved1 	$CONTROLS, fe i(hhid1)
estimates store ag2, title(IHHFE)
xi: xtreg  $LHS  lndismoved 	outofag2 outofag2Xlndismoved	$CONTROLS, fe i(hhid1)
estimates store ag3, title(IHHFE)

xml_tab ag0 ag1 ag2 ag3, save(growth_regressions.xml) stats(N) title(Table 13 - Explaining Consumption Change: IHHFE, moving out of agriculture) /*
	*/ sd2 append sheet(T13)

**********************************************************************
* ROBUSTNESS CHECKS
**********************************************************************

global HH1CONTROLS   head_sex head_age head_ed hieduc  relig  toilet goodflr m0_5k m6_15k m16_60k m61k f0_5k f6_15k f16_60k f61k
global iHH1CONTROLS  head_sex head_age head_ed hieduc i.relig toilet goodflr m0_5k m6_15k m16_60k m61k f0_5k f6_15k f16_60k f61k
global NEWCONTROLS sex unmar sexXunmar bothdied bothdied15 mgrade1 fgrade1 /*
 */ clh?0_51 clh?6_101 clh?11_151 clh?16_201 clh?21p1 cle1 cle1Xkm 
global MEANINST9194 rh_rel12mean rh_rel3mean sexXrh_rel3mean r_agerankXage1mean age1XmaleXkmmax dr9192Xage1min 

* CAN LNCONSPC1 AND DLNCONPC9194 BE EXPLAINED BY FUTURE MOVEMENT?
* now add more HH controls as we have to drop ihhfe
use growth_data2, clear
sort cluster hh1
tempfile thesedata
save `thesedata'
use khds_hh, clear
keep if wave==1
keep cluster hh $HH1CONTROLS 
ren hh hh1
isid cluster hh1, sort
merge cluster hh1 using `thesedata'
drop if _merge==1
assert _merge==3
drop _merge
* adapt controls
gen lnconspc1 = ln(conspc1)
count
xi: xtreg lnconspc1 	moved1     		   	 $NEWCONTROLS $iHH1CONTROLS, fe i(cluster)
xi: xtreg lnconspc1 	lndismoved           $NEWCONTROLS $iHH1CONTROLS, fe i(cluster)
xi: xtreg dlnconspc9194	moved1     lnconspc1 $NEWCONTROLS $iHH1CONTROLS, fe i(cluster)
xi: xtreg dlnconspc9194	lndismoved lnconspc1 $NEWCONTROLS $iHH1CONTROLS, fe i(cluster)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* INSTRUMENTS ARE JOINTLY SIGNIFICANT AT 10% WHEN EXPLAINING DCONSPC
use growth_data2, clear
xi: xtreg $LHS  $CONTROLS $INST, fe i(hhid1)
test $INST

* THERE WAS RELATIVELY LITTLE MIGRATION DURING KHDS-1 (92-93)
tab s9q3

* NEXT PART COLLAPSES TO KHDS-1 HOUSEHOLDS TO CHECK TWO POINTS
	*1. INSTRUMENTS DO NOT INFLUENCE CONSUMPTION CHANGES IN WAVE 2-4
	*2. TAKE OUT FIXED EFFECTS FROM FIRST STAGE AND SEE WHAT THEY ARE CORRELATED WITH
* FIRST TAKE OUT FIXED EFFECTS FROM MOVED1 AND LNDISMOVED
qui xi: xtreg  moved1  $CONTROLS $INST, fe i(hhid1)
predict move_fe, u
qui xi: xtreg  lndismoved  $CONTROLS $INST, fe i(hhid1)
predict km_fe, u

* assert the following variables are fixed at hhid1 level
foreach i of varlist cluster hh1 move_fe km_fe conspc1 dlnconspc9194 khds1size {
	bys hhid1: egen test = sd(`i')
	assert test==0 | test==.
	drop test
}
collapse  cluster hh1 move_fe km_fe conspc1 dlnconspc9194 khds1size 	/* FIXED
*/ 	 $CONTROLS $LHS  									/* TAKE MEANS
*/	(max) moved1 kmbukoba lndismoved 						/* TAKE FURTHEST MOVE
*/	(max)  rh_rel12max=rh_rel12   rh_rel3max=rh_rel3  sexXrh_rel3max=sexXrh_rel3   bothdiedmax=bothdied   age1XmaleXkmmax=age1XmaleXkm   dr9192Xage1max=dr9192Xage1  r_agerankXage1max=r_agerankXage1   /*
*/	(mean) rh_rel12mean=rh_rel12  rh_rel3mean=rh_rel3 sexXrh_rel3mean=sexXrh_rel3  bothdiedmean=bothdied  age1XmaleXkmmean=age1XmaleXkm  dr9192Xage1mean=dr9192Xage1 r_agerankXage1mean=r_agerankXage1  /*
*/	(min)  dr9192Xage1min=dr9192Xage1, by(hhid1)

label var rh_rel12mean 	"Mean head or spouse"
label var rh_rel3mean 	"Mean child of head"
label var sexXrh_rel3mean 	 "Mean male child of head"
label var r_agerankXage1mean   "Mean age rank in HH * age 15-25"
label var age1XmaleXkmmax 	 "Max km from reg. capital * male * age 15-25"
label var dr9192Xage1min	 "Min average rainfall deviation * age 15-25"
label var moved1	  	"anyone moved outside community"
label var lndismoved 	"km moved"
label var dlnconspc 	"Change log pc expenditures"
label var schooldmed 	"Deviation of years schooling from peers"
label var schooldmedsq 	"Squared deviation of years schooling from peers"
label var sex 		"Male"
label var unmar 		"Unmarried"
label var sexXunmar 	"Unmarried male"
label var bothdied 	"Both parents died"
label var bothdied15 	"Above 15 & both parents died"
label var clhm0_51	"Male children 0-5"
label var clhm6_101	"Male children 6-10"
label var clhm11_151 	"Male children 11-15"
label var clhm16_201 	"Male children 16-20"
label var clhm21p1 	"Male children 21+"
label var clhf0_51	"Female children 0-5"
label var clhf6_101	"Female children 6-10"
label var clhf11_151 	"Female children 11-15"
label var clhf16_201 	"Female children 16-20"
label var clhf21p1 	"Years of education mother"
label var fgrade1 	"Years of education father"
label var cle1 		"Number of children residing outside HH"
label var cle1Xkm 	"Km from reg. capital * No. outside children"
label var age0 		"Baseline age 5-15"
label var age1 		"Baseline age 16-25"
label var age2 		"Baseline age 26-35"
label var age3 		"Baseline age 36-45"
label var age4 		"Baseline age 46-55"
label var age5 		"Baseline age 56-65"
label var age6		"Baseline age 66+"
* now add more HH controls as we have to drop ihhfe
isid cluster hh1, sort
tempfile thesedata
save `thesedata'
use khds_hh, clear
keep if wave==1
keep cluster hh $HH1CONTROLS 
for varlist $HH1CONTROLS: tab X, m
ren hh hh1
isid cluster hh1, sort
merge cluster hh1 using `thesedata'
drop if _merge==1
assert _merge==3
drop _merge
* adapt controls
gen lnconspc1 = ln(conspc)

* regress khds-1 consumption changes on instrument
xi: xtreg dlnconspc9194 lnconspc1 $MEANINST9194 $iHH1CONTROLS $CONTROLS, fe i(cluster)
test $MEANINST9194

* look at correlates of FE (still needs some work)
gen kmbukobasq = kmbukoba^2
gen inbukoba=kmbukoba==0 if kmbukoba~=.
gen lnkmbukoba=ln(kmbukoba)
gen consXbukoba = lnconspc1*kmbukoba
bys cluster: egen cmean_conspc = mean(conspc)
* with cluster FE
xi: xtreg move_fe $CONTROLS $iHH1CONTROLS lnconspc1, fe i(cluster)
xi: xtreg km_fe   $CONTROLS $iHH1CONTROLS lnconspc1, fe i(cluster)
* without cluster FE
xi: reg   move_fe $CONTROLS $iHH1CONTROLS lnconspc1 kmbukoba inbukoba cmean_conspc
xi: reg   km_fe   $CONTROLS $iHH1CONTROLS lnconspc1 kmbukoba inbukoba cmean_conspc

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* CONSTRUCTING BETTER COMMON SUPPORT FOR MOVED VARIABLE
* restrict sample to HHs with more than one split-off
use growth_data2, clear
tab NrSplits
assert NrSplits~=.
keep if NrSplits>1
count
xi: xtreg  $LHS  moved1 lndismoved /*nonesensical regression to get coeff. in right order in xls file*/
estimates store ind0, title(DELETE ME!!)
xi: xtreg  $LHS  moved1     $CONTROLS, fe i(hhid1)
estimates store ind1, title(IHHFE)
xi: xtreg  $LHS  lndismoved $CONTROLS, fe i(hhid1)
estimates store ind2, title(IHHFE)
xi: xtivreg2  $LHS  $CONTROLS (moved1 = $INST) , fe i(hhid1) first savefp(first)
estimates store ind3, title(2SLS)
xi: xtivreg2  $LHS  $CONTROLS (lndismoved = $INST) , fe i(hhid1) first savefp(first)
estimates store ind4, title(2SLS)
xml_tab ind0 ind1 ind2 ind3 ind4, save(growth_regressions.xml) stats(N) title(T9 with Sample Restricted to Baseline HHs with at least two split-offs) /*
	*/ sd2 append sheet(T9Rob4a-Support)
xml_tab firstmoved1 firstlndismoved, save(growth_regressions.xml) stats(N) title(T10: 1st stage Reg of Table 9) /*
	*/ sd2 append sheet(T9Rob4a-1st stage)

* restrict to HHs with at least two split-offs and one that moved
use growth_data2, clear
tab NrSplits
assert NrSplits~=.
keep if NrSplits>1
tab MoveAny
keep if MoveAny==1
count
xi: xtreg  $LHS  moved1 lndismoved /*nonesensical regression to get coeff. in right order in xls file*/
estimates store ind0, title(DELETE ME!!)
xi: xtreg  $LHS  moved1     $CONTROLS, fe i(hhid1)
estimates store ind1, title(IHHFE)
xi: xtreg  $LHS  lndismoved $CONTROLS, fe i(hhid1)
estimates store ind2, title(IHHFE)
xi: xtivreg2  $LHS  $CONTROLS (moved1 = $INST) , fe i(hhid1) first savefp(first)
estimates store ind3, title(2SLS)
xi: xtivreg2  $LHS  $CONTROLS (lndismoved = $INST) , fe i(hhid1) first savefp(first)
estimates store ind4, title(2SLS)
xml_tab ind0 ind1 ind2 ind3 ind4, save(growth_regressions.xml) stats(N) title(T9 with sample restricted to baseline HHs with at least two split-offs and one that moved) /*
	*/ sd2 append sheet(T9Rob4b-Support)
xml_tab firstmoved1 firstlndismoved, save(growth_regressions.xml) stats(N) title(T9 first stage with sample restricted to baseline HHs with at least two split-offs and one that moved) /*
	*/ sd2 append sheet(T9Rob4b-1st stage)

* restrict to HHs with at least two split-off and one that stayed
use growth_data2, clear
tab NrSplits
assert NrSplits~=.
keep if NrSplits>1
tab StayAny
keep if StayAny==1
count
xi: xtreg  $LHS  moved1 lndismoved /*nonesensical regression to get coeff. in right order in xls file*/
estimates store ind0, title(DELETE ME!!)
xi: xtreg  $LHS  moved1     $CONTROLS, fe i(hhid1)
estimates store ind1, title(IHHFE)
xi: xtreg  $LHS  lndismoved $CONTROLS, fe i(hhid1)
estimates store ind2, title(IHHFE)
xi: xtivreg2  $LHS  $CONTROLS (moved1 = $INST) , fe i(hhid1) first savefp(first)
estimates store ind3, title(2SLS)
xi: xtivreg2  $LHS  $CONTROLS (lndismoved = $INST) , fe i(hhid1) first savefp(first)
estimates store ind4, title(2SLS)
xml_tab ind0 ind1 ind2 ind3 ind4, save(growth_regressions.xml) stats(N) title(T9 with sample restricted to baseline HHs with at least two split-offs and one that moved) /*
	*/ sd2 append sheet(T9Rob4c-Support)
xml_tab firstmoved1 firstlndismoved, save(growth_regressions.xml) stats(N) title(T9 first stage with sample restricted to baseline HHs with at least two split-offs and one that moved) /*
	*/ sd2 append sheet(T9Rob4c-1st stage)

* restrict to HHs with at least one split-off that stayed and one that moved
use growth_data2, clear
tab NrSplits
assert NrSplits~=.
keep if NrSplits>1
tab StayAny MoveAny
keep if StayAny==1 & MoveAny==1
count
xi: xtreg  $LHS  moved1 lndismoved /*nonesensical regression to get coeff. in right order in xls file*/
estimates store ind0, title(DELETE ME!!)
xi: xtreg  $LHS  moved1     $CONTROLS, fe i(hhid1)
estimates store ind1, title(IHHFE)
xi: xtreg  $LHS  lndismoved $CONTROLS, fe i(hhid1)
estimates store ind2, title(IHHFE)
xi: xtivreg2  $LHS  $CONTROLS (moved1 = $INST) , fe i(hhid1) first savefp(first)
estimates store ind3, title(2SLS)
xi: xtivreg2  $LHS  $CONTROLS (lndismoved = $INST) , fe i(hhid1) first savefp(first)
estimates store ind4, title(2SLS)
xml_tab ind0 ind1 ind2 ind3 ind4, save(growth_regressions.xml) stats(N) title(T9 with sample restricted to baseline HHs with at least one split-off that stayed and one that moved) /*
	*/ sd2 append sheet(T9Rob4d-Support)
xml_tab firstmoved1 firstlndismoved, save(growth_regressions.xml) stats(N) title(T9 first stage with sample restricted to baseline HHs with at least one split-off that stayed and one that moved) /*
	*/ sd2 append sheet(T9Rob4d-1st stage)


