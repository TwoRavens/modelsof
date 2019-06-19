* THIS FILE CREATES THE GROWTH_DATA2.DTA, WHICH WILL BE THE BASIS OF THE SUBSEQUENT REGRESSIONS.

clear 
set mem 50m
set matsize 800
set more off
capture log close

******************************************************************************************

use growth_data.dta,clear

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
* save growth_data2,replace

