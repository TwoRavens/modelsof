**************************prepare DE for study 1******************************************
******************************************************************************************
*THIS FILE ILLUSTRATES HOW WE RECODED THE GERMAN ELECTION STUDY OF 1983 FOR OUR ANALYSIS**
******************************************************************************************
*Hardware: MacBook Pro (13-inch, 2017)
*Software: macOS Mojave 10.14.1; stata 15 

use "ZA1276_v2-0-0.dta", clear
*recode date to make machine readable:
gen preday=v268 if v268<=28
gen preyear=1983
gen premonth=2 
gen predate = mdy(premonth, preday, preyear)
format predate %d
*
gen postday=v399 if v399<=28
gen postyear=1983
gen postmonth=3 
gen postdate = mdy(postmonth, postday, postyear)
format postdate %d

*gen single lr variable:
gen lr1=v96 if v96<=11
gen lr2=v241 if v241<=11
gen lr3=v313 if v313<=11

*gen identifier, expand to create panel: 
gen id=_n
gen expander=2 if predate!=. & postdate!=.
expand expander

*gen wave identifier: 
bysort id: gen wave=_n+1

*RECODES of variables:
*
gen polkno=5 if v8==1
replace polkno=4 if v8==2
replace polkno=3 if v8==3
replace polkno=2 if v8==4
replace polkno=1 if v8==5
*
gen cdu=0
replace cdu=1 if v10==1
gen spd=0
replace spd=1 if v10==2
gen fdp=0
replace fdp=1 if v10==3
gen gru=0
replace gru=1 if v10==4
*
gen age=v254 if wave==2 
replace age=v393 if wave==3  
replace age=. if age==.a
*
gen religion=0
replace religion=1 if v119==1 | v119==2
*
gen rural=0
replace rural=1 if v126==0
replace rural=2 if v126==9
replace rural=3 if v126==8
replace rural=4 if v126==7
replace rural=5 if v126==6
replace rural=6 if v126==5
replace rural=7 if v126==4
replace rural=8 if v126==3
replace rural=9 if v126==2
replace rural=10 if v126==1
*
gen female=0
replace female=1 if v253==2 & wave==2 
replace female=1 if v392==2 & wave==3 
*
gen education=v256 if v256!=.n
*
gen date=predate if wave==2
replace date=postdate if wave==3
format date %d

*set to panel structure:
xtset id wave

*generate single lr variable for all waves: 
gen lr=lr2 if wave==2
replace lr=lr3 if wave==3

*generate election identifier:
gen treated=0
replace treated=1 if wave==3

*time variables: 
*
gen edate=8465
format edate %d
*
gen time=date-edate
*
gen interviewdistance=postdate-predate

*generate DV:
gen polarization=sqrt((lr-6)^2)

* drop respondents not included in both waves
gen h1=1 if wave==2
replace h1=2 if wave==3
bysort id: egen bothwaves=sum(h1)
bysort id: egen countpol=count(polarization) if bothwaves==3 & wave<4
gen sample=1 if bothwaves==3 & countpol==2
keep if sample==1


*labels:
lab var polarization "polarization"
lab var education "education" 
lab var female "female" 
lab var polkno "political knowledge" 
lab var religion "religion" 
lab var rural "rural" 
lab var cdu "CDU" 
lab var fdp "FDP" 
lab var spd "SPD" 
lab var gru "Gruene" 
lab var treated "pre/post election"

*drop variables not relevant for study OR identification of obs for reproducation: 
keep za_nr version v2 id wave polarization treated education cdu spd fdp gru age female rural polkno religion interviewdistance date



