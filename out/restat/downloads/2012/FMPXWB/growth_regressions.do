* OUTPUT FOR GROWTH PAPER
* SUM STATS
* CREATE GROWTH_DATA2.DTA
* RUN REGRESSIONS

global output 	C:\khds2004\data\growth\RESTAT_R&R4
global data 	C:\khds2004\data

clear 
set mem 50m
set matsize 800
set more off
capture log close

log using $output\growth_regressions.log, text replace
******************************************************************************************

use $output\growth_data.dta,clear

gen sexXrh_rel3 = sex * rh_rel3
gen sexXunmar = sex * unmar
gen sexXunmarXkm = sex * unmar * km
gen age15 = years1>=15 if years1~=.
gen age15Xschoolyrs1 = age15*schoolyrs1
gen years1Xschoolyrs1 =  years1*schoolyrs1
gen move4cat = si2c
recode move4cat 5=4
label define move4cat 1 "Same vill" 2 "near vill" 3 "oth Kagera" 4 "out Kagera"
label values move4cat move4cat
gen move3cat = si2c
recode move3cat 5=3 4=3
tab si2c move3cat 
gen moved1Xdurban = moved1*durban
gen urban2 = remote2
recode urban2 1/3=1 3/6=0
tab urban2 remote2
gen moved1Xurban2 = moved1*urban2
bys hhid2: gen khds2size = _N
tab khds2size
bys hhid1: gen khds1size = _N
tab khds1size

**** move out of ag
tab farm1 farm2
gen 		agmove = .
replace 	agmove = 1 if farm1==1 & farm2==1
replace 	agmove = 2 if farm1==1 & farm2==2
replace 	agmove = 3 if farm1==2 & farm2==2
replace 	agmove = 4 if farm1==2 & farm2==1
label define agmove 1"stay in ag" 2"out of ag" 3"stay in non-ag" 4"move into ag"
label values agmove agmove 
tab agmove
tabstat dlnconspc, by(agmove) s(n median mean) format(%9.2fc)
table agmove moved1, c(n dlnconspc median dlnconspc mean dlnconspc) format(%9.2fc)
table agmove moved1 if remote1>3, c(n dlnconspc median dlnconspc mean dlnconspc) format(%9.2fc)
* corrected by kathleen per Joachim's email to control for non-missing agmove
gen outofag1 = agmove==2 if agmove~=.
gen outofag2 = agmove==2 | agmove==3 if agmove~=.

gen outofag1Xmoved1 = outofag1 * moved1
gen outofag2Xmoved1 = outofag2 * moved1
gen outofag2Xlndismoved = outofag2 * lndismoved

* DEVIATION OF SCHOOLYRS FROM PEER GROUP
gen 		t_years = years1
recode	t_years 18/max=18
gen schooldmed = .
gen schooldmean = .
label var schooldmed  "deviation from median school years of peer group"
label var schooldmean "deviation from mean school years of peer group"
foreach i of numlist 1/18 {
	qui sum schoolyrs1 if t_years==`i', d
	di _newline(2) "for age " `i' " the median is " r(p50) " and mean is " r(mean)
	replace schooldmed  = schoolyrs1 - r(p50)   if t_years==`i'
	replace schooldmean = schoolyrs1 - r(mean)  if t_years==`i'
}
gen schooldmedsq = schooldmed^2
gen schooldmeansq = schooldmean^2
*
gen schooldmedsqXmoved1  = schooldmedsq*moved1
gen schooldmeansqXmoved1 = schooldmeansq*moved1
gen schooldmedXmoved1	 = schooldmed*moved1
gen schooldmeanXmoved1	 = schooldmean*moved1

* GENERATE GENERAL RAINFALL SHOCK
sum dev_rain1991-dev_rain2004
egen dr9103 = rmin(dev_rain1992-dev_rain2002)
gen  dr9103Xage0 = dr9103 * age0
gen  dr9103Xage1 = dr9103 * age1
gen  dr9103Xage0Xsex = dr9103 * age0 * sex
gen  dr9103Xage1Xsex = dr9103 * age1 * sex
sum dr9103*

* GENERATE 9192 RAINFALL SHOCK
egen dr9192 = rmin(dev_rain1991-dev_rain1992)
gen  dr9192Xage0 = dr9192 * age0
gen  dr9192Xage1 = dr9192 * age1
gen  dr9192Xage0Xsex = dr9192 * age0 * sex
gen  dr9192Xage1Xsex = dr9192 * age1 * sex
sum dr9192*

* AGERANK
gen r_agerankXage0 = r_agerank*age0
gen r_agerankXage1 = r_agerank*age1

* REMOTENESS
tab remote1 remote2, row
gen moveconnect = remote2<remote1 & moved1==1
gen moveremote  = remote2>remote1 & moved1==1
gen movesame    = remote1==remote2 & moved1==1

/* check they add up to moved1: 385+435+458=1278 */
* interactions with dis
gen disremote = lndismoved*moveremote
gen dissame   = lndismoved*movesame
gen disconnect= lndismoved*moveconnect
label var moveconnect 	"move to more connected area"
label var movesame 	"move to similar area"
label var moveremote 	"move to more remote area"
label var disconnect 	"distance moved if to more connected area"
label var dissame 	"distance moved if to similar area"
label var disremote 	"distance moved if to more remote area"
for varlist moveconnect moveremote movesame moved1: tab X
for varlist moved1 moveremote movesame moveconnect: tabstat dlnconspc, by(X) s(mean median n) format(%9.2fc)

* CREATE VARIABLES FOR COMMON SUPPORT RESTRCITIONS
bys hhid2: gen  temp=_n if _n==1
bys hhid1: egen NrSplits=total(temp)
drop temp
label var NrSplits "Nr. of split-off HHs the KHDS1 HH spawned"
bys hhid1: egen MoveAny  = max(moved1)
label var MoveAny "at least 1 split-off moved"
bys hhid1: egen StayAny = min(moved1)
recode StayAny 1=0 0=1 		/* 1 indicates, yes at least one splitoff stayed */
label var StayAny "at least 1 split-off stayed"

* R&R: DIFFERENCES IN SCHOOLING
gen dschoolyrs = schoolyrs2-schoolyrs1
list years1 years2 schoolyrs1 schoolyrs2 dschoolyrs if dschoolyrs<0
count if dschoolyrs<0 // these must be mistakes: assume no change
recode dschoolyrs min/0=0
list years1 years2 schoolyrs1 schoolyrs2 dschoolyrs if dschoolyrs==. & schoolyrs1~=.
replace dschoolyrs=0 if (years1>12 & schoolyrs1==0 & schoolyrs2==.)
replace dschoolyrs=0 if (years1>25 & schoolyrs2==.)
list years1 years2 schoolyrs1 schoolyrs2 dschoolyrs if dschoolyrs==. & schoolyrs1~=.
	* these are really unkown, so we'll have to drop them
tab dschoolyrs
reg dschoolyrs moved1 // movers have 0.85 higher dschoolyrs than non-movers (from constant of 2.4)
*ineraction effect
gen dschXmoved1 = dschoolyrs*moved1
gen dschXlndis  = dschoolyrs*lndis


ren years1 yearsold
*********************
* SAMPLE AND MACROS *
*********************
* LABEL VARS TO DISPLAY NICELY IN XML_TAB OUTPUT
label var moved1	  		"moved outside community"
label var lndismoved 		"km moved"
label var outofag2   		"moved out of agriculture"
label var outofag2Xmoved1	"moved out of village & out of agriculture"
label var outofag2Xlndismoved "distance moved * moved out of agriculture"
label var dlnconspc 		"change log pc expenditures"
label var schooldmed 		"deviation of years schooling from peers"
label var schooldmedsq 		"squared deviation of years schooling from peers"
label var schoolyrs1		"baseline years of schooling"
label var schoolyrs1sq		"squared baseline years of schooling"
label var dschoolyrs	"Diff. schoolyrs"
label var dschXmoved1	"(Diff. schoolyrs) * (moved dummy)"
label var dschXlndis	"(Diff. schoolyrs) * (km moved)"	
label var sex 		"male"
label var unmar 		"unmarried"
label var sexXunmar 	"unmarried male"
label var bothdied 	"both parents died"
label var bothdied15 	"above 15 & both parents died"
label var clhm0_51	"male children 0-5"
label var clhm6_101	"male children 6-10"
label var clhm11_151 	"male children 11-15"
label var clhm16_201 	"male children 16-20"
label var clhm21p1 	"male children 21+"
label var clhf0_51	"female children 0-5"
label var clhf6_101	"female children 6-10"
label var clhf11_151 	"female children 11-15"
label var clhf16_201 	"female children 16-20"
label var clhf21p1 	"female children 21+"
label var mgrade1 	"years of education mother"
label var fgrade1 	"years of education father"
label var cle1 		"number of children residing outside HH"
label var cle1Xkm 	"km from reg. capital * No. outside children"
label var age0 		"baseline age 5-15"
label var age1 		"baseline age 16-25"
label var age2 		"baseline age 26-35"
label var age3 		"baseline age 36-45"
label var age4 		"baseline age 46-55"
label var age5 		"baseline age 56-65"
label var age6		"baseline age 66+"
label var rh_rel12 	"head or spouse"
label var rh_rel3 	"child of head"
label var sexXrh_rel3 	"male child of head"
label var r_agerankXage0 "(age rank in HH) * (age 5-15)"
label var age0XmaleXkm 	 "(km from reg. capital) * (male) * (age 5-15)"
label var dr9103Xage0	 "(average rainfall deviation) * (age 5-15)"

label data "Data set growth_data with regression variables, ccreated by growth_regression.do"

** DROP PEOPLE 
count
drop if no_wave1==1
drop if hhsize1==1
drop if conspc1==. | conspc2==.
drop if schooldmed ==.
drop if mgrade1==.| fgrade1 ==.
assert _N==3313 // this was sample of 3,227 pre-R&R
sort pid
keep pid cluster yearsold hh1 id1 cons* dlnconspc dlnconsaeu si2c moved1 moved2 dismoved lndismoved schooldmed schooldmedsq  rh_rel12 rh_rel3 sexXrh_rel3 r_agerankXage0 r_agerankXage1 /*
 */ age0XmaleXkm age1XmaleXkm dr9103Xage0 sex unmar sexXunmar bothdied bothdied15 mgrade1 fgrade1 /*
 */ clh?0_51 clh?6_101 clh?11_151 clh?16_201 clh?21p1 cle1 cle1Xkm age0 age1 age2 age3 age4 age5 age6 /*
 */ khds1size hhid1 hhid2 remote1 moveremote movesame moveconnect agmove outofag* move4cat hhsize* dissame  disconnect /*
 */ aeu1 aeu2 s9* dr9192* conspc1 dlnconspc9194 datefirst datelast yearlast kmbukoba disdis /*
 */ NrSplits MoveAny StayAny schoolyrs1 schoolyrs2 schoolyrs1sq dschoolyrs dschXmoved1 dschXlndis

* INSTRUMENTS AND CONTROLS
global LHS 		dlnconspc
global CONTROLS schooldmed schooldmedsq sex unmar sexXunmar bothdied bothdied15 mgrade1 fgrade1 /*
 */ clh?0_51 clh?6_101 clh?11_151 clh?16_201 clh?21p1 cle1 cle1Xkm age0 age1 age2 age3 age4 age5 age6
global INST       rh_rel12     rh_rel3     sexXrh_rel3     r_agerankXage0     age0XmaleXkm    dr9103Xage0
global MEANINST   rh_rel12mean rh_rel3mean sexXrh_rel3mean r_agerankXage0mean age0XmaleXkmmax dr9103Xage0min 
xi: xtreg     $LHS       moved1 lndismoved $CONTROLS, fe i(hhid1)
assert e(sample)==1 
count
bys hhid1: drop if _N==1 /* to remove singleton obs */
assert _N==3227
save $output\growth_data2,replace

******************************************************************************************
* REPLY TO QUERY 1 - EFFECT OF MOVEMENT-SCHOOLING BUNDLE
use $output\growth_data2,replace
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
* 2SLS - without interactions
xi: xtivreg2  $LHS  $CONTROLS (moved1 = $INST) , fe i(hhid1) first savefp(first)
scalar CraggDon_reg1 	= e(cdf)
scalar Sargan1 		= e(sargan)
scalar Sarganp1		= e(sarganp)
estimates store inst1, title(2SLS)
xi: xtivreg2  $LHS  $CONTROLS (lndismoved = $INST) , fe i(hhid1) first savefp(first)
scalar CraggDon_reg2 = e(cdf)
scalar Sargan2 		= e(sargan)
scalar Sarganp2		= e(sarganp)
estimates store inst2, title(2SLS)
* 2SLS with interactions (First-stage not saved)
xi: xtivreg2  $LHS  $CONTROLS (moved1     dschXmoved1 = $INST) , fe i(hhid1) first
scalar CraggDon_reg3 	= e(cdf)
scalar Sargan3 		= e(sargan)
scalar Sarganp3		= e(sarganp)
estimates store inst3, title(2SLS)
xi: xtivreg2  $LHS  $CONTROLS (lndismoved dschXlndis  = $INST) , fe i(hhid1) first
scalar CraggDon_reg4 = e(cdf)
scalar Sargan4 		= e(sargan)
scalar Sarganp4		= e(sarganp)
estimates store inst4, title(2SLS)
xml_tab ind0 ihhfe1 ihhfe2 ihhfe3 ihhfe4 inst1 inst2 inst3 inst4, ///
    save($output\growth_replies.xml) stats(N) title(Q1a: Explaining Consumption Change - IHHFE & 2SLS with schooling interactions) ///
    sd2 replace sheet(Q1a)
xml_tab firstmoved1 firstlndismoved, save($output\growth_replies.xml) stats(N) title(Q1b: 1st stage of Q1a regs without instrumented interaction term (regs with single instrument)) /*
	*/ sd2 append sheet(Q1b 1st stage partial)
scalar list
matrix Diagn = (CraggDon_reg1,CraggDon_reg2,CraggDon_reg3,CraggDon_reg4 \ Sargan1,Sargan2,Sargan3,Sargan4 \ Sarganp1,Sarganp2,Sarganp3,Sarganp4)
matrix rownames Diagn = "Cragg-Donald" "Sargan Statistic" "Sargan p-value"
matrix colnames Diagn = "Moved Dummy, no interaction" "Distance, no interaction" "Moved Dummy, with interaction" "Distance, with interaction"
matrix list     Diagn
xml_tab Diagn, save($output\growth_replies.xml) title(Q1c: Cragg Donalds of first stage R1) /*
	*/ append sheet(Q1c Diagnostics all)

******************************************************************************************
use $output\growth_data2,replace

* REPLY TO QUERY 2 - EFFECT OF DEVIATIONS FROM PEER-EDUCATION
global CONTROLS schoolyrs1 schoolyrs1sq sex unmar sexXunmar bothdied bothdied15 mgrade1 fgrade1 /*
 */ clh?0_51 clh?6_101 clh?11_151 clh?16_201 clh?21p1 cle1 cle1Xkm age0 age1 age2 age3 age4 age5 age6
set more off
	xi: xtreg  $LHS  moved1 lndismoved  /*nonesensical regression to get coeff. in right order in xls file*/
	estimates store ind0, title(DELETE ME!!)
xi: xtreg  $LHS  moved1     $CONTROLS, fe i(hhid1)
estimates store ihhfe1, title(IHHFE)
xi: xtreg  $LHS  lndismoved $CONTROLS, fe i(hhid1)
estimates store ihhfe2, title(IHHFE)
xi: xtivreg2  $LHS  $CONTROLS (moved1 = $INST) , fe i(hhid1) first savefp(first)
scalar CraggDon_reg1 	= e(cdf)
scalar Sargan1 		= e(sargan)
scalar Sarganp1		= e(sarganp)
estimates store inst1, title(2SLS)
xi: xtivreg2  $LHS  $CONTROLS (lndismoved = $INST) , fe i(hhid1) first savefp(first)
scalar CraggDon_reg2 = e(cdf)
scalar Sargan2 		= e(sargan)
scalar Sarganp2		= e(sarganp)
estimates store inst2, title(2SLS)
xml_tab ind0 ihhfe1 ihhfe2 inst1 inst2 , save($output\growth_replies.xml) stats(N) title(Q2a: Explaining Consumption Change - IHHFE & 2SLS with schooling interactions) /*
	*/ sd2 append sheet(Q2a)
xml_tab firstmoved1 firstlndismoved, save($output\growth_replies.xml) stats(N) title(Q2b: 1st stage of Q2a regs ) /*
	*/ sd2 append sheet(Q2b 1st stage)
scalar list
matrix Diagn = (CraggDon_reg1,CraggDon_reg2 \ Sargan1,Sargan2\ Sarganp1,Sarganp2)
matrix rownames Diagn = "Cragg-Donald" "Sargan Statistic" "Sargan p-value"
matrix colnames Diagn = "Moved Dummy" "Distance"
matrix list     Diagn
xml_tab Diagn, save($output\growth_replies.xml) title(Q2c: Cragg Donalds of first stage R1) /*
	*/ append sheet(Q2c Diagnostics all)
******************************************************************************************
* APPENDIX TABLE 2: Alternative sets of IVs
* REPLY TO QUERY 3 - DROPPING INSTRUMENTS ONE BY ONE
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
xml_tab t, save($output\growth_regressions.xml) replace  /* mv(.=" " ) */  ///
	format(SCLR3 NCLR2) sheet(AT2 Robust IV) title(AT2: Coeff StdErr and Cragg-Donald when specified instrument is omitted)

**************************************************************************
* DESCRIPTIVES *
use $output\growth_data2,replace

* STATS QUOTED IN TEXT
tab remote1
* TABLE 6
for varlist moved1 moveremote movesame moveconnect: tabstat dlnconspc, by(X) s(mean median n)
* TABLE 7
tabstat dlnconspc, by(agmove) s(mean median n) format(%9.2fc)
* TABLE 8
table agmove moved1, c(n dlnconspc median dlnconspc mean dlnconspc) format(%9.2fc) col row

* HOUSEHOLD SIZE AND AEU
table move4cat, c( mean hhsize1 median hhsize1 mean hhsize2 median hhsize2 n hhsize1)
table move4cat, c(mean aeu1 median aeu1 mean aeu2 median aeu2 n aeu1)
xi: regress hhsize2 age0 age1 age2 age3 age4 age5 age6 sex i.move4

* REASONS FOR MOVING 
tab s9q4 move4,m
tab s9q4 move4, col nofreq
tab s9q4oth move4
tab s9q4oth move4, col nofreq
gen movemarr=s9q4==6 if s9q4~=.
gen mv_marr=moved1*movemarr
replace mv_marr=0 if moved1~=. & movemarr==.
label var mv_marr "Moved * moved for marriage"
gen mvkm_marr=lndismoved *movemarr
replace mvkm_marr=0 if lndismoved~=. & movemarr==.
label var mvkm_marr "KMs moved * moved for marriage"

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
xml_tab b, save($output\growth_regressions.xml) append format(SCLR3 NCLR2) sheet(AT1 MEANS)

***********************************
* REGRESSIONS *
***********************************
* MAIN TABLE WITH INDIVIDUAL LEVEL IHHFE & 2SLS RESULTS
xi: xtreg  $LHS  moved1 lndismoved /*nonesensical regression to get coeff. in right order in xls file*/
estimates store ind0, title(DELETE ME!!)
reg  $LHS  moved1     $CONTROLS
estimates store ind02, title(OLS DONT USE)
reg  $LHS  lndismoved $CONTROLS
estimates store ind03, title(OLS DONT USE)
xi: xtreg  $LHS  moved1 mv_marr  $CONTROLS, fe i(hhid1)
estimates store ind04, title(DONT USE MARR)
xi: xtreg  $LHS  moved1 mvkm_marr  $CONTROLS, fe i(hhid1)
estimates store ind05, title(DONT USE MARR)

xi: xtreg  $LHS  moved1     $CONTROLS, fe i(hhid1)
estimates store ind1, title(IHHFE)
xi: xtreg  $LHS  lndismoved $CONTROLS, fe i(hhid1)
estimates store ind2, title(IHHFE)
xi: xtivreg2  $LHS  $CONTROLS (moved1 = $INST) , fe i(hhid1) first savefp(first)
estimates store ind3, title(2SLS)
xi: xtivreg2  $LHS  $CONTROLS (lndismoved = $INST) , fe i(hhid1) first savefp(first)
estimates store ind4, title(2SLS)
xml_tab ind0 ind02 ind03 ind04 ind05 ind1 ind2 ind3 ind4, save($output\growth_regressions.xml) stats(N) title(T9: Explaining Consumption Change - IHHFE & 2SLS) /*
	*/ sd2 append sheet(T9)
xml_tab firstmoved1 firstlndismoved, save($output\growth_regressions.xml) stats(N) title(T10: 1st stage Reg of Table 9) /*
	*/ sd2 append sheet(T10 1st stage)

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

xml_tab ind0 ind02 ind03 ind1 ind2 ind3 ind4, save($output\growth_regressions.xml) stats(N) title(AT6: AEU Explaining Consumption Change - IHHFE & 2SLS) /*
	*/ sd2 append sheet(AT6 AEU)
xml_tab firstmoved1 firstlndismoved, save($output\growth_regressions.xml) stats(N) title(AT6: AEU 1st stage Reg of Table 10) /*
	*/ sd2 append sheet(AT6 1st stage)

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

xml_tab hh0 hh1 hh2 hh3 hh4, save($output\growth_regressions.xml) stats(N) title(TA3: Explaining Consumption Change - IHHFE & 2SLS - Household Level Results) /*
	*/ sd2 append sheet(TA3 hh lvl)
xml_tab hhfirstmoved1 hhfirstlndismoved, save($output\growth_regressions.xml) stats(N) title(TA4: 1st Stage Reg Table A3) /*
	*/ sd2 append sheet(TA4 1st stage)
restore
*****************************
* TABLES FOR DCONNECT
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

xml_tab con0 con00 con1 con2 con3, save($output\growth_regressions.xml) stats(N) title(T11 Explaining Consumption Change - IHHFE) /*
	*/ sd2 append sheet(T11 dconnect)

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

xml_tab ag0 ag1 ag2 ag3, save($output\growth_regressions.xml) stats(N) title(T12 Explaining Consumption Change - IHHFE & 2SLS) /*
	*/ sd2 append sheet(T12 out of ag)

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
use $output\growth_data2, clear
sort cluster hh1
tempfile thesedata
save `thesedata'
use $data\khds_hh, clear
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
xi: xtreg lnconspc1 	moved1     		   $NEWCONTROLS $iHH1CONTROLS, fe i(cluster)
xi: xtreg lnconspc1 	lndismoved           $NEWCONTROLS $iHH1CONTROLS, fe i(cluster)
xi: xtreg dlnconspc9194	moved1     lnconspc1 $NEWCONTROLS $iHH1CONTROLS, fe i(cluster)
xi: xtreg dlnconspc9194	lndismoved lnconspc1 $NEWCONTROLS $iHH1CONTROLS, fe i(cluster)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* INSTRUMENTS ARE JOINTLY SIGNIFICANT AT 10% WHEN EXPLAINING DCONSPC
use $output\growth_data2, clear
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
use $data\khds_hh, clear
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
use $output\growth_data2, clear
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
xml_tab ind0 ind1 ind2 ind3 ind4, save($output\growth_regressions.xml) stats(N) title(T9 with Sample Restricted to Baseline HHs with at least two split-offs) /*
	*/ sd2 append sheet(T9Rob4a-Support)
xml_tab firstmoved1 firstlndismoved, save($output\growth_regressions.xml) stats(N) title(T10: 1st stage Reg of Table 9) /*
	*/ sd2 append sheet(T9Rob4a-1st stage)

* restrict to HHs with at least two split-offs and one that moved
use $output\growth_data2, clear
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
xml_tab ind0 ind1 ind2 ind3 ind4, save($output\growth_regressions.xml) stats(N) title(T9 with sample restricted to baseline HHs with at least two split-offs and one that moved) /*
	*/ sd2 append sheet(T9Rob4b-Support)
xml_tab firstmoved1 firstlndismoved, save($output\growth_regressions.xml) stats(N) title(T9 first stage with sample restricted to baseline HHs with at least two split-offs and one that moved) /*
	*/ sd2 append sheet(T9Rob4b-1st stage)

* restrict to HHs with at least two split-off and one that stayed
use $output\growth_data2, clear
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
xml_tab ind0 ind1 ind2 ind3 ind4, save($output\growth_regressions.xml) stats(N) title(T9 with sample restricted to baseline HHs with at least two split-offs and one that moved) /*
	*/ sd2 append sheet(T9Rob4c-Support)
xml_tab firstmoved1 firstlndismoved, save($output\growth_regressions.xml) stats(N) title(T9 first stage with sample restricted to baseline HHs with at least two split-offs and one that moved) /*
	*/ sd2 append sheet(T9Rob4c-1st stage)

* restrict to HHs with at least one split-off that stayed and one that moved
use $output\growth_data2, clear
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
xml_tab ind0 ind1 ind2 ind3 ind4, save($output\growth_regressions.xml) stats(N) title(T9 with sample restricted to baseline HHs with at least one split-off that stayed and one that moved) /*
	*/ sd2 append sheet(T9Rob4d-Support)
xml_tab firstmoved1 firstlndismoved, save($output\growth_regressions.xml) stats(N) title(T9 first stage with sample restricted to baseline HHs with at least one split-off that stayed and one that moved) /*
	*/ sd2 append sheet(T9Rob4d-1st stage)


log close
