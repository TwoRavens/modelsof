/Users/spencerpiston/Dropbox/Completed Projects/Clifford and Piston PolBeh/Replication Clifford and Piston PolBeh/CCES2014_constructed.dta


*in-text: cronbach's alpha on the DS scale
use "/Users/spencerpiston/Dropbox/Completed Projects/Clifford and Piston PolBeh/Replication Clifford and Piston PolBeh/CCES2014_constructed.dta", clear
alpha disgdp disgbo disgmo disgsw, item
use "/Users/spencerpiston/Dropbox/disgust project/MTurk Replication/mturkrepconstructed.dta", clear
alpha tdds*, item





*Figure 1. Pluralities of Those Who Support Aiding Homeless People also Support Exclusionary Policies
**First Panel
clear all
use "/Users/spencerpiston/Dropbox/Completed Projects/Clifford and Piston PolBeh/Replication Clifford and Piston PolBeh/CCES2014_constructed.dta", clear
cd "/Users/spencerpiston/Dropbox/disgust project/CCES disgust"
keep if hcondtc==1|hcondc==1
set more off

gen gbp3 = gbp
recode gbp3 0/.4=2 .5=1 .6/1=0
gen gbs3 = gbs
recode gbs3 0/.4=2 .5=1 .6/1=0
gen ghh3 = ghh
recode ghh3 0/.4=2 .5=1 .6/1=0
gen gah3 = gah
recode gah3 0/.4=2 .5=1 .6/1=0

keep gah3 ghh3 gbs3 gbp3
rename gah3 g1
rename ghh3 g2
rename gbs3 g3
rename gbp3 g4
gen ID = _n

reshape long g, i(ID) j(var)

label define var 1 "Aid to Homeless" 2 "Housing Homeless" 3 "Ban Sleeping" 4 "Ban Panhandling"
label values var var

catplot g var, percent(var) stack asyvars  bar(1, bcolor(gs6)) bar(2, bcolor(gs10)) bar(3, bcolor(gs14)) graphregion(color(white)) ytitle("") subtitle("Support for Homelessness Policies") legend(lab(1 "Favor") lab(2 "Neutral") lab(3 "Oppose") rows(1) region(lstyle(none))) saving(homeatts.gph, replace)

*Second and Third Panels
clear all
use "/Users/spencerpiston/Dropbox/Completed Projects/Clifford and Piston PolBeh/Replication Clifford and Piston PolBeh/CCES2014_constructed.dta", clear
cd "/Users/spencerpiston/Dropbox/disgust project/CCES disgust"
keep if hcondtc==1|hcondc==1
set more off

gen gbp3 = gbp
recode gbp3 0/.4=2 .5=1 .6/1=0
gen gbs3 = gbs
recode gbs3 0/.4=2 .5=1 .6/1=0
gen ghh3 = ghh
recode ghh3 0/.4=0 .5=1 .6/1=2
gen gah3 = gah
recode gah3 0/.4=0 .5=1 .6/1=2

label variable gbp3 "Support for Banning Panhandling"
label define labgbp3 0 "Favor Ban" 1 "Neutral" 2 "Oppose Ban"
label values gbp3 labgbp3

label variable gbs3 "Support for Banning Sleeping"
label define labgbs3 0 "Favor Ban" 1 "Neutral" 2 "Oppose Ban"
label values gbs3 labgbs3

label variable gah3 "Support for Aid to Homeless"
label define labgah3 0 "Oppose Aid" 1 "Neutral on Aid" 2 "Favor Aid"
label values gah3 labgah3

catplot gbp3 gah3, percent(gah3) asyvars stack bar(1, bcolor(gs6)) bar(2, bcolor(gs10)) bar(3, bcolor(gs14)) graphregion(color(white)) ytitle("") subtitle("Conflictual Attitudes on Banning Panhandling") legend(rows(1) region(lstyle(none))) saving(banpan.gph, replace)
catplot gbs3 gah3, percent(gah3) asyvars stack bar(1, bcolor(gs6)) bar(2, bcolor(gs10)) bar(3, bcolor(gs14)) graphregion(color(white)) ytitle("") subtitle("Conflictual Attitudes on Banning Sleeping") legend(rows(1) region(lstyle(none))) saving(bansleep.gph, replace)

*making the final graph - Figure 1
graph combine homeatts.gph banpan.gph bansleep.gph, graphregion(color(white)) xsize(12) rows(1) note("Note: Policy attitudes are trichotomized. The favor category in this figure includes respondents who 'strongly favor,' 'somewhat favor,' and 'slightly favor' each policy. The oppose category includes respondents who 'strongly oppose,' "" 'moderately oppose,' or 'slightly oppose' each policy. The neutral category represents respondents who 'neither favor nor oppose' the policy.")





*Figure 2. Disgust Sensitivity Predicts Exclusionary, but not Aid Policy Attitudes

*CCES
clear all
use "/Users/spencerpiston/Dropbox/Completed Projects/Clifford and Piston PolBeh/Replication Clifford and Piston PolBeh/CCES2014_constructed.dta", clear
cd "/Users/spencerpiston/Dropbox/disgust project/CCES disgust"
set more off

gen poleff=.
gen pollo=.
gen polhi=.
gen polx=.
replace polx=1 in 1
replace polx=1.5 in 2
replace polx=3 in 3
replace polx=3.5 in 4
replace polx=6 in 5
replace polx=6.5 in 6
replace polx=8 in 7
replace polx=8.5 in 8

reg gbs ds pidrep0to1 churchatt ideo0to1 educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace if hcondd==0 & hcondf==0
lincom ds*.5
replace poleff=r(estimate) in 1
replace pollo=r(estimate) - 1.65*r(se) in 1
replace polhi=r(estimate) + 1.65*r(se) in 1

reg gbp ds pidrep0to1 ideo0to1 churchatt educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace if hcondd==0 & hcondf==0
lincom ds*.5
replace poleff=r(estimate) in 3
replace pollo=r(estimate) - 1.65*r(se) in 3
replace polhi=r(estimate) + 1.65*r(se) in 3

reg gah ds pidrep0to1 churchatt ideo0to1 educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace if hcondd==0 & hcondf==0
lincom ds*.5
replace poleff=r(estimate) in 5
replace pollo=r(estimate) - 1.65*r(se) in 5
replace polhi=r(estimate) + 1.65*r(se) in 5

reg ghh ds pidrep0to1 churchatt ideo0to1 educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace if hcondd==0 & hcondf==0
lincom ds*.5
replace poleff=r(estimate) in 7
replace pollo=r(estimate) - 1.65*r(se) in 7
replace polhi=r(estimate) + 1.65*r(se) in 7

keep poleff pollo polhi polx
keep if poleff!=.
save "/Users/spencerpiston/Dropbox/disgust project/CCES disgust/graphdatacces.dta", replace

*MTurk
clear all
use "/Users/spencerpiston/Dropbox/disgust project/MTurk Replication/mturkrepconstructed.dta", clear
cd "/Users/spencerpiston/Dropbox/disgust project/CCES disgust"
set more off

gen poleff=.
gen pollo=.
gen polhi=.
gen polx=.
replace polx=1 in 1
replace polx=1.5 in 2
replace polx=3 in 3
replace polx=3.5 in 4
replace polx=6 in 5
replace polx=6.5 in 6
replace polx=8 in 7
replace polx=8.5 in 8

reg homesleep0to1 ds pidrep0to1 ideo0to1 Attend educ0to1 Male age0to1 Hisp Black OtherR
lincom ds*.5
replace poleff=r(estimate) in 2
replace pollo=r(estimate) - 1.65*r(se) in 2
replace polhi=r(estimate) + 1.65*r(se) in 2

reg homepan0to1 ds pidrep0to1 ideo0to1 Attend educ0to1 Male age0to1 Hisp Black OtherR
lincom ds*.5
replace poleff=r(estimate) in 4
replace pollo=r(estimate) - 1.65*r(se) in 4
replace polhi=r(estimate) + 1.65*r(se) in 4

reg homeaid0to1 ds pidrep0to1 ideo0to1 Attend educ0to1 Male age0to1 Hisp Black OtherR
lincom ds*.5
replace poleff=r(estimate) in 6
replace pollo=r(estimate) - 1.65*r(se) in 6
replace polhi=r(estimate) + 1.65*r(se) in 6

reg homesubs0to1 ds pidrep0to1 ideo0to1 Attend educ0to1 Male age0to1 Hisp Black OtherR
lincom ds*.5
replace poleff=r(estimate) in 8
replace pollo=r(estimate) - 1.65*r(se) in 8
replace polhi=r(estimate) + 1.65*r(se) in 8

keep poleff pollo polhi polx
keep if poleff!=.
append using "/Users/spencerpiston/Dropbox/disgust project/CCES disgust/graphdatacces.dta"
sort polx

gen cces = 0
recode cces 0=1 if (polx==1 | polx==3 | polx==6 | polx==8)

twoway (scatter poleff polx if cces==1, mcol(black)) (scatter poleff polx if cces==0, mcol(gs7)) ///
(rcap pollo polhi polx if cces==0, lcol(gs7)) (rcap pollo polhi polx if cces==1, ///
lcol(black) xscale(off) xlabel(0(1)6) ylabel(-.1(.1).3, nogrid) yline(0, lcol(gs10)) ///
graphregion(color(white)) legend(order(1 "CCES" 2 "MTurk") size(small) ring(0) placement(8)) ///
subtitle("") ytitle("Effect of Disgust Sensitivity on Policy Attitudes") ysc(titlegap(3)) ///
text(.3 2.25 "Exclusionary Policies", size(small)) ///
text(.3 7.25 "Aid Policies", size(small))  ///
text(.275 1.25 "Ban Sleeping", size(small))  ///
text(.275 3.25 "Ban Panhandling", size(small))  ///
text(.275 6.25 "Aid", size(small))  ///
text(.275 8.25 "Housing", size(small)) saving(policyeffects.gph, replace))





*Figure 3. Predicted Policy Attitudes, at High and Low Disgust Sensitivity
*NOTE. THE FIGURE WAS ACTUALLY CREATED IN EXCEL, USING THE VALUES CREATED BELOW
use "/Users/spencerpiston/Dropbox/Completed Projects/Clifford and Piston PolBeh/Replication Clifford and Piston PolBeh/CCES2014_constructed.dta", clear
********* 90%le and 10%le ************
sum ds
*90 %le
reg gah ds pidrep0to1 churchatt ideo0to1 educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace 
margins, at(ds==.96) /*.65*/
reg ghh ds pidrep0to1 churchatt ideo0to1 educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace 
margins, at(ds==.96) /*.66*/
reg gbs ds pidrep0to1 churchatt ideo0to1 educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace 
margins, at(ds==.96) /*.66*/
reg gbp ds pidrep0to1 churchatt ideo0to1 educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace 
margins, at(ds==.96) /*.70*/
*10 %le
reg gah ds pidrep0to1 churchatt ideo0to1 educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace 
margins, at(ds==.46) /*.65*/
reg ghh ds pidrep0to1 churchatt ideo0to1 educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace 
margins, at(ds==.46) /*.66*/
reg gbs ds pidrep0to1 churchatt ideo0to1 educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace 
margins, at(ds==.46) /*.49*/
reg gbp ds pidrep0to1 churchatt ideo0to1 educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace 
margins, at(ds==.46) /*.56*/





*Figure 4. Disease Cues Increase the Effect of Disgust Sensitivity on Policy Attitudes
clear all
use "/Users/spencerpiston/Dropbox/Completed Projects/Clifford and Piston PolBeh/Replication Clifford and Piston PolBeh/CCES2014_constructed.dta", clear
cd "/Users/spencerpiston/Dropbox/disgust project/CCES disgust"
set more off

gen dseff=.
gen dslo=.
gen dshi=.
gen dsx=_n
replace dsx=. if _n>12
replace dsx=5 in 4
replace dsx=6 in 5
replace dsx=7 in 6
replace dsx=9 in 7
replace dsx=10 in 8
replace dsx=11 in 9
replace dsx=13 in 10
replace dsx=14 in 11
replace dsx=15 in 12
gen dmf = 0
replace dmf=. if _n>15
recode dmf 0=1 if (dsx==2 | dsx==6 | dsx==10 | dsx==14)
gen fear=0
replace fear=. if _n>15
recode fear 0=1 if (dsx==3 | dsx==7 | dsx==11 | dsx==15)

gen dsxcondd = ds*hcondd
gen dsxcondf = ds*hcondf

reg gbp ds dsxcondd dsxcondf hcondf hcondd pidrep0to1 ideo0to1 churchatt educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace
est store gbp
lincom ds*.5
replace dseff=r(estimate) in 1
replace dslo=r(estimate) - 1.65*r(se) in 1
replace dshi=r(estimate) + 1.65*r(se) in 1
lincom ds*.5 + dsxcondd*.5
replace dseff=r(estimate) in 2
replace dslo=r(estimate) - 1.65*r(se) in 2
replace dshi=r(estimate) + 1.65*r(se) in 2
lincom ds*.5 + dsxcondf*.5
replace dseff=r(estimate) in 3
replace dslo=r(estimate) - 1.65*r(se) in 3
replace dshi=r(estimate) + 1.65*r(se) in 3

reg gbs ds dsxcondd dsxcondf hcondf hcondd pidrep0to1 ideo0to1 churchatt educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace
est store gbs
lincom ds*.5
replace dseff=r(estimate) in 4
replace dslo=r(estimate) - 1.65*r(se) in 4
replace dshi=r(estimate) + 1.65*r(se) in 4
lincom ds*.5 + dsxcondd*.5
replace dseff=r(estimate) in 5
replace dslo=r(estimate) - 1.65*r(se) in 5
replace dshi=r(estimate) + 1.65*r(se) in 5
lincom ds*.5 + dsxcondf*.5
replace dseff=r(estimate) in 6
replace dslo=r(estimate) - 1.65*r(se) in 6
replace dshi=r(estimate) + 1.65*r(se) in 6

reg gah ds dsxcondd dsxcondf hcondf hcondd pidrep0to1 ideo0to1 churchatt educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace
est store gah
lincom ds*.5
replace dseff=r(estimate) in 7
replace dslo=r(estimate) - 1.65*r(se) in 7
replace dshi=r(estimate) + 1.65*r(se) in 7
lincom ds*.5 + dsxcondd*.5
replace dseff=r(estimate) in 8
replace dslo=r(estimate) - 1.65*r(se) in 8
replace dshi=r(estimate) + 1.65*r(se) in 8
lincom ds*.5 + dsxcondf*.5
replace dseff=r(estimate) in 9
replace dslo=r(estimate) - 1.65*r(se) in 9
replace dshi=r(estimate) + 1.65*r(se) in 9

reg ghh ds dsxcondd dsxcondf hcondf hcondd pidrep0to1 ideo0to1 churchatt educ0to1 south inc0to1big incmiss unemp male age0to1 hispanic black otherrace
est store ghh
lincom ds*.5
replace dseff=r(estimate) in 10
replace dslo=r(estimate) - 1.65*r(se) in 10
replace dshi=r(estimate) + 1.65*r(se) in 10
lincom ds*.5 + dsxcondd*.5
replace dseff=r(estimate) in 11
replace dslo=r(estimate) - 1.65*r(se) in 11
replace dshi=r(estimate) + 1.65*r(se) in 11
lincom ds*.5 + dsxcondf*.5
replace dseff=r(estimate) in 12
replace dslo=r(estimate) - 1.65*r(se) in 12
replace dshi=r(estimate) + 1.65*r(se) in 12

twoway (scatter dseff dsx if dmf==0, mcol(gs10)) (scatter dseff dsx if dmf==1, mcol(black)) (rcap dslo dshi dsx if dmf==0 & fear==0, lcol(gs10)) (rcap dslo dshi dsx if fear==1, lcol(gs10) lpattern(-)) (rcap dslo dshi dsx if dmf==1, lcol(black) xscale(off) xlabel(0(1)6) ylabel(-.25(.25).5, nogrid) yline(0, lcol(gs10)) graphregion(color(white)) legend(off) subtitle("") ytitle("Effect of Disgust Sensitivity on Policy Attitudes") ysc(titlegap(3)) text(-.2 1 "Control", size(small) orientation(vertical) justification(left)) text(-.2 2 "Disease", size(small) orientation(vertical) justification(left)) text(-.2 3 "Threat", size(small) orientation(vertical) justification(left)) text(-.2 5 "Control", size(small) orientation(vertical)) text(-.2 6 "Disease", size(small) orientation(vertical)) text(-.2 7 "Threat", size(small) orientation(vertical)) text(-.2 9 "Control", size(small) orientation(vertical)) text(-.2 10 "Disease", size(small) orientation(vertical)) text(-.2 11 "Threat", size(small) orientation(vertical)) text(-.2 13 "Control", size(small) orientation(vertical)) text(-.2 14 "Disease", size(small) orientation(vertical)) text(-.2 15 "Threat", size(small) orientation(vertical)) text(.45 2 "Banning" "Panhandling", size(small)) text(.45 6 "Banning" "Sleeping", size(small)) text(.45 10 "Aid to" "Homeless", size(small)) text(.45 14 "Subsidize" "Housing", size(small)))
 
