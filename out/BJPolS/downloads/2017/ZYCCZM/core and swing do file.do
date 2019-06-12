

use "core and swing data.dta", clear

******************************************
**************** FIGURE 1 ****************
******************************************

*feel close to party
gen stat1=.
gen stat1_ll=.
gen stat1_ul=.

mean feelclose_r1 if coeth==0
mat b = r(table)
replace stat1 = b[1,1] if _n==1
replace stat1_ll=b[5,1] if _n==1replace stat1_ul=b[6,1] if _n==1
mean feelclose_r1 if coeth==1
mat b = r(table)
replace stat1 = b[1,1] if _n==2
replace stat1_ll=b[5,1] if _n==2replace stat1_ul=b[6,1] if _n==2gen groupnum=_n in 1/2

twoway (bar stat1 groupnum, fcolor(gs12) lcolor(black) barw(.7)) || (rcap stat1_ll stat1_ul groupnum, lcolor(gs6)), ///
scheme(s1mono) ylabel(0 "0" .25 ".2" .5 ".5" .75 ".75" 1 "1", angle(0)) ///
xlabel(1 "NO" 2 "YES") ytitle("Share of Respondents") scale(1.5) ///
xtitle("Co-ethnic in race?") legend(off) xsize(3) plotregion(lcolor(white)) subtitle("(a)" "Feel close" "to party") name(g1, replace)


*undecided
gen stat2=.
gen stat2_ll=.
gen stat2_ul=.

mean dk_r1 if coeth==0
mat b = r(table)
replace stat2 = b[1,1] if _n==1
replace stat2_ll=b[5,1] if _n==1replace stat2_ul=b[6,1] if _n==1
mean dk_r1 if coeth==1
mat b = r(table)
replace stat2 = b[1,1] if _n==2
replace stat2_ll=b[5,1] if _n==2replace stat2_ul=b[6,1] if _n==2

twoway (bar stat2 groupnum, fcolor(gs12) lcolor(black) barw(.7)) || (rcap stat2_ll stat2_ul groupnum, lcolor(gs6)), ///
scheme(s1mono) ylabel(0 "0" .05 ".05" .1 ".1" .15 ".15" .2 ".2", angle(0)) ///
xlabel(1 "NO" 2 "YES")  ytitle("Share of Respondents") scale(1.5) ///
xtitle("Co-ethnic in race?") legend(off) xsize(3) plotregion(lcolor(white)) subtitle("(b)" "Undecided" " ") name(g2, replace)


*disparity in beliefs about group represenation
gen stat3=.
gen stat3_ll=.
gen stat3_ul=.

mean absdisp_r1 if coeth==0
mat b = r(table)
replace stat3 = b[1,1] if _n==1
replace stat3_ll=b[5,1] if _n==1replace stat3_ul=b[6,1] if _n==1
mean absdisp_r1 if coeth==1
mat b = r(table)
replace stat3 = b[1,1] if _n==2
replace stat3_ll=b[5,1] if _n==2replace stat3_ul=b[6,1] if _n==2

twoway (bar stat3 groupnum, fcolor(gs12) lcolor(black) barw(.7)) || (rcap stat3_ll stat3_ul groupnum, lcolor(gs6)), ///
scheme(s1mono) ylabel(0 "0" 1 "1" 2 "2" 3 "3", angle(0)) ///
xlabel(1 "NO" 2 "YES")  ytitle("abs(disparity)") scale(1.5) ///
xtitle("Co-ethnic in race?") legend(off) xsize(3) plotregion(lcolor(white)) subtitle("(c)" "Perceived disparity" "in group representation") name(g3, replace)


*difference in means tests
ttest feelclose_r1, by(coeth)
ttest dk_r1, by(coeth)
ttest absdisp_r1, by(coeth)
ttest absdispfunds_r1, by(coeth)



***************************************
*************** TABLE 1 ***************
***************************************

svyset [pw=weight] 

*candidate to candidate
gen uhurutoraila=.
replace uhurutoraila=1 if q121b_r1==1 & q121b_r2==2 & q121b_r1!=. & q121b_r2!=.
replace uhurutoraila=0 if uhurutoraila!=1 & q121b_r1!=. & q121b_r2!=.
svy: mean uhurutoraila if match==3
svy: mean uhurutoraila if match==3, over(coeth)
lincom [uhurutoraila]1 - [uhurutoraila]0 

gen railatouhuru=.
replace railatouhuru=1 if q121b_r1==2 & q121b_r2==1 & q121b_r1!=. & q121b_r2!=.
replace railatouhuru=0 if railatouhuru!=1 & q121b_r1!=. & q121b_r2!=.
svy: mean railatouhuru if match==3
svy: mean railatouhuru if match==3, over(coeth)
lincom [railatouhuru]1 - [railatouhuru]0 

gen cantocan=.
replace cantocan=1 if railatouhuru==1 | uhurutoraila==1
replace cantocan=0 if railatouhuru==0 & uhurutoraila==0
svy: mean cantocan if match==3
svy: mean cantocan if match==3, over(coeth)
lincom [cantocan]1 - [cantocan]0 


*don't know to candidate
gen dktouhuru=.
replace dktouhuru =1 if q121b_r1>2 & q121b_r2==2 & q121b_r1!=. & q121b_r2!=.
replace dktouhuru =0 if dktouhuru!=1 & q121b_r1!=. & q121b_r2!=.
svy: mean dktouhuru if match==3
svy: mean dktouhuru if match==3, over(coeth)
lincom [dktouhuru]1 - [dktouhuru]0 

gen dktoraila=.
replace dktoraila=1 if q121b_r1>2 & q121b_r2==1 & q121b_r1!=. & q121b_r2!=.
replace dktoraila=0 if dktoraila!=1 & q121b_r1!=. & q121b_r2!=.
svy: mean dktoraila if match==3
svy: mean dktoraila if match==3, over(coeth)
lincom [dktoraila]1 - [dktoraila]0 

gen dktocan=.
replace dktocan=1 if dktoraila==1 | dktouhuru==1
replace dktocan=0 if dktoraila==0 & dktouhuru==0
svy: mean dktocan if match==3
svy: mean dktocan if match==3, over(coeth)
lincom [dktocan]1 - [dktocan]0 


*candidate to don't know
gen uhurutodk=.
replace uhurutodk=1 if q121b_r1==1 & q121b_r2>2 & q121b_r1!=. & q121b_r2!=.
replace uhurutodk=0 if uhurutodk!=1 & q121b_r1!=. & q121b_r2!=.
svy: mean uhurutodk if match==3
svy: mean uhurutodk if match==3, over(coeth)
lincom [uhurutodk]1 - [uhurutodk]0 

gen railatodk=.
replace railatodk=1 if q121b_r1==2 & q121b_r2>2 & q121b_r1!=. & q121b_r2!=.
replace railatodk=0 if railatodk!=1 & q121b_r1!=. & q121b_r2!=.
svy: mean railatodk if match==3
svy: mean railatodk if match==3, over(coeth)
lincom [railatodk]1 - [railatodk]0 

gen cantodk=.
replace cantodk=1 if railatodk ==1 | uhurutodk ==1
replace cantodk =0 if railatodk ==0 & uhurutodk ==0
svy: mean cantodk if match==3
svy: mean cantodk if match==3, over(coeth)
lincom [cantodk]1 - [cantodk]0 


*total change
svy: mean change if match==3
svy: mean change if match==3, over(coeth)
lincom [change]1 - [change]0 



***************************************
*************** Table 2 ***************
***************************************

*model 1
logit change i.coeth ///
pardiff spousediff c.networknco c.ncoshare ///
c.polint ed_r1 ///
c.radionews_r1 newspaper_r1 tvnews_r1 vernacular ///
wealthindex_r1 age_r1 female_r1 ///
gap if match==3 [pweight=weight]

margins, dydx(*) atmeans post


*model 2 (excluding those who changed to/from DK/RTA)
logit change i.coeth ///
pardiff spousediff c.networknco c.ncoshare ///
c.polint ed_r1 ///
c.radionews_r1 newspaper_r1 tvnews_r1 vernacular ///
wealthindex_r1 age_r1 female_r1 ///
gap if match==3 & q121b_r1<3 & q121b_r2<3 [pweight=weight]


*model 3 (coeth disaggregated)
recode groupnum_r1 (1=1) (2=2) (.=.) (else=0), gen(group)

logit change kikuyu_r1 luo_r1 ///
pardiff spousediff c.networknco c.ncoshare ///
c.polint ed_r1 ///
c.radionews_r1 newspaper_r1 tvnews_r1 vernacular ///
wealthindex_r1 age_r1 female_r1 ///
gap if match==3  [pweight=weight]



**************************************************
*************** Table 3 & Figure 2 ***************
**************************************************

logit newuhuru uhururep_ch railarep_ch  ///
uhururep_r1 railarep_r1 ///
likeu_ch liker_ch ///
pardiff spousediff networknco ncoshare vernacular ///
polint ed_r1 ///
radionews_r1 newspaper_r1 tvnews_r1 ///
wealthindex_r1 age_r1 female_r1 ///
gap if match==3 [pweight=weight]

margins, at(uhururep_ch=(-3(1)3)) atmeans
marginsplot, xtitle("Change in Beliefs about Kenyatta") ytitle("Probability of Becoming a Kenyatta Supporter") title("") scheme(s1mono) saving(A, replace)

logit newraila uhururep_ch railarep_ch ///
uhururep_r1 railarep_r1 ///
likeu_ch liker_ch ///
pardiff spousediff networknco ncoshare ///
polint ed_r1 ///
radionews_r1 newspaper_r1 tvnews_r1 vernacular ///
wealthindex_r1 age_r1 female_r1 ///
gap if match==3 [pweight=weight]

margins, at(railarep_ch=(-3(1)3)) atmeans
marginsplot, xtitle("Change in Beliefs about Odinga") ytitle("Probability of Becoming an Odinga Supporter") title("") scheme(s1mono) saving(B, replace)

graph combine A.gph B.gph, ycommon scheme(s1mono) xsize(7)  iscale(*1.5)




*****************************************************************
************************ ONLINE APPENDIX ************************
*****************************************************************


***********************************
************ Figure A1 ************ 
***********************************

use "core and swing data.dta", clear

gen num =_n in 1/9
gen s1=. in 1/9
gen sample=. in 1/9

set more off
local a = 1
while `a' <=9 {
sum change if match==3 & groupnum_r1==`a' [iweight=weight]
replace s1=r(mean) if _n==`a'
replace sample=r(N) if _n==`a'
local a = `a' + 1
}

twoway (bar s1 num if num<3, color(gs10*.8) barw(.8)) (bar s1 num if num>2, color(gs4*.8) barw(.8)), ///
xlabel(1 `" "Kikuyu" " " "[136]" "' 2 `" "Luo" " " "[124]" "' 3 `" "Kalenjin" " " "[100]" "' 4 `" "Kamba" " " "[82]" "' ///
5 `" "Luhya" " " "[152]" "' 6 `" "Kisii" " " "[53]" "' 7 `" "Meru/" "Embu" "[43]" "' 8 `" "Mijikenda" " " "[47]" "' 9 `" "Other" " " "[70]" "') ///
ylabel(0 "0" .05 "5" .1 "10" .15 "15" .2 "20" .25 "25" .3 "30" .35 "35" .4 "40", nogrid) ytitle("Percent of Group") ///
xtitle("") scheme(s1mono) ///
legend(off)


****************************************
*************** Table A1 ***************
****************************************

use "core and swing data.dta", clear

summ change if match==3 [iweight=weight]
summ coeth  if match==3 [iweight=weight]
summ pardiff if match==3 [iweight=weight]
summ spousediff if match==3 [iweight=weight]
summ networknco if match==3 [iweight=weight]
summ ncoshare if match==3 [iweight=weight]
summ polint if match==3 [iweight=weight]
summ ed_r1 if match==3 [iweight=weight]
summ radionews_r1 if match==3 [iweight=weight]
summ newspaper_r1  if match==3 [iweight=weight]
summ tvnews_r1 if match==3 [iweight=weight]
summ vernacular if match==3 [iweight=weight]
summ wealthindex_r1  if match==3 [iweight=weight]
summ age_r1 if match==3 [iweight=weight]
summ female_r1  if match==3 [iweight=weight]
summ gap if match==3 [iweight=weight]



****************************************
*************** Table A4 ***************
****************************************

*Exlude Luhya respondents
logit change coeth ///
pardiff spousediff networknco ncoshare ///
polint ed_r1 ///
radionews_r1 newspaper_r1 tvnews_r1 vernacular ///
wealthindex_r1 age_r1 female_r1 ///
gap if match==3 & luhya_r1!=1 [pweight=weight]


*Alternative ways of controlling for Mudavadi's departures
recode q201d_r1 (1=4) (2=3) (3=2) (4=1) (else=.), gen(like_mud)
recode q202c_r1 (1=4) (2=3) (3=2) (4=1) (else=.), gen(mud_rep)

logit change coeth like_mud ///
pardiff spousediff networknco ncoshare ///
polint ed_r1 ///
radionews_r1 newspaper_r1 tvnews_r1 vernacular ///
wealthindex_r1 age_r1 female_r1 ///
gap if match==3 [pweight=weight]

logit change coeth mud_rep ///
pardiff spousediff networknco ncoshare ///
polint ed_r1 ///
radionews_r1 newspaper_r1 tvnews_r1 vernacular ///
wealthindex_r1 age_r1 female_r1 ///
gap if match==3 [pweight=weight]




****************************************
*************** Table A5 ***************
****************************************

svyset [pw= weight] 

svy: mean cord_contact_r2 if match==3, over(coeth)
lincom [cord_contact_r2]1 - [cord_contact_r2]0 

svy: mean jub_contact_r2 if match==3, over(coeth)
lincom [jub_contact_r2]1 - [jub_contact_r2]0 

svy: mean cord_sms_r2 if match==3, over(coeth)
lincom [cord_sms_r2]1 - [cord_sms_r2]0 

svy: mean jub_sms_r2 if match==3, over(coeth)
lincom [jub_sms_r2]1 - [jub_sms_r2]0 

svy: mean cord_money_r2 if match==3, over(coeth)
lincom [cord_money_r2]1 - [cord_money_r2]0 

svy: mean jub_money_r2 if match==3, over(coeth)
lincom [jub_money_r2]1 - [jub_money_r2]0 

svy: mean cordrally_r2 if match==3, over(coeth)
lincom [cordrally_r2]1 - [cordrally_r2]0 

svy: mean jubrally_r2 if match==3, over(coeth)
lincom [jubrally_r2]1 - [jubrally_r2]0 



****************************************
*************** Table A6 ***************
****************************************

svy: mean pressure_r1 if match==3, over(coeth)
lincom [pressure_r1]1 - [pressure_r1]0 

svy: mean fear_r1 if match==3, over(coeth)
lincom [fear_r1]1 - [fear_r1]0 



****************************************
*************** Table A7 ***************
****************************************

*Alternative coding of core group [Kikuyu, Luo, Kamba, Kalenjin]
logit change i.coeth2 ///
pardiff spousediff c.networknco c.ncoshare ///
c.polint ed_r1 ///
c.radionews_r1 newspaper_r1 tvnews_r1 vernacular ///
wealthindex_r1 age_r1 female_r1 ///
gap if match==3 [pweight=weight]



**********************************************
*************** Tables A8 & A9 ***************
**********************************************

*Table A8
svy: mean ncoint_r1 if match==3, over(coeth)
lincom [ncoint_r1]1 - [ncoint_r1]0 

svy: mean ncoint_r2 if match==3, over(coeth)
lincom [ncoint_r2]1 - [ncoint_r2]0 

svy: mean ncoethintboth if match==3, over(coeth)
lincom [ncoethintboth]1 - [ncoethintboth]0 


*Table A9
logit change i.coeth ///
pardiff spousediff c.networknco c.ncoshare ///
c.polint ed_r1 ///
c.radionews_r1 newspaper_r1 tvnews_r1 vernacular ///
wealthindex_r1 age_r1 female_r1 ///
gap i.ncoint_r1##i.ncoint_r2 if match==3 [pweight=weight]



****************************************
*************** Table A10 **************
****************************************

use "core and swing data.dta", clear

*reshape to long form
keep sn_new uhuruvoter_r1 uhuruvoter_r2 railavoter_r1 railavoter_r2 dk_r1 dk_r2 ///
kikuyu_r1 luo_r1 meru_r1 embu_r1 kamba_r1 kalenjin_r1 luhya_r1 kisii_r1 mijikenda_r1 other_r1 weight

rename uhuruvoter_r1 uhuruvoter1
rename uhuruvoter_r2 uhuruvoter2
rename railavoter_r1 railavoter1
rename railavoter_r2 railavoter2
rename dk_r1 dk1
rename dk_r2 dk2

reshape long uhuruvoter railavoter dk, i(sn_new) j(round)


svyset [pw= weight]
replace weight=1 if round==1

*Kenyatta
svy: mean uhuruvoter if kikuyu_r1==1, over(round)
lincom [uhuruvoter]2 - [uhuruvoter]1 

svy: mean uhuruvoter if meru_r1==1 | embu_r1==1, over(round)
lincom [uhuruvoter]2 - [uhuruvoter]1 

svy: mean uhuruvoter if kalenjin_r1==1, over(round)
lincom [uhuruvoter]2 - [uhuruvoter]1 

svy: mean uhuruvoter if kisii_r1==1, over(round)
lincom [uhuruvoter]2 - [uhuruvoter]1 

svy: mean uhuruvoter if kamba_r1==1, over(round)
lincom [uhuruvoter]2 - [uhuruvoter]1 

svy: mean uhuruvoter if luhya_r1==1, over(round)
lincom [uhuruvoter]2 - [uhuruvoter]1

svy: mean uhuruvoter if mijikenda_r1==1, over(round)
lincom [uhuruvoter]2 - [uhuruvoter]1 

svy: mean uhuruvoter if luo_r1==1, over(round)
lincom [uhuruvoter]2 - [uhuruvoter]1 

svy: mean uhuruvoter if other_r1==1 & embu_r1!=1, over(round)
lincom [uhuruvoter]2 - [uhuruvoter]1 

svy: mean uhuruvoter, over(round)
lincom [uhuruvoter]2 - [uhuruvoter]1 


****Odinga
svy: mean railavoter if kikuyu_r1==1, over(round)
lincom [railavoter]2 - [railavoter]1 

svy: mean railavoter if meru_r1==1 | embu_r1==1, over(round)
lincom [railavoter]2 - [railavoter]1 

svy: mean railavoter if kalenjin_r1==1, over(round)
lincom [railavoter]2 - [railavoter]1 

svy: mean railavoter if kisii_r1==1, over(round)
lincom [railavoter]2 - [railavoter]1 

svy: mean railavoter if kamba_r1==1, over(round)
lincom [railavoter]2 - [railavoter]1 

svy: mean railavoter if luhya_r1==1, over(round)
lincom [railavoter]2 - [railavoter]1 

svy: mean railavoter if mijikenda_r1==1, over(round)
lincom [railavoter]2 - [railavoter]1 

svy: mean railavoter if luo_r1==1, over(round)
lincom [railavoter]2 - [railavoter]1 

svy: mean railavoter if other_r1==1 & embu_r1!=1, over(round)
lincom [railavoter]2 - [railavoter]1 

svy: mean railavoter, over(round)
lincom [railavoter]2 - [railavoter]1 


***don't know
svy: mean dk if kikuyu_r1==1, over(round)
lincom [dk]2 - [dk]1 

svy: mean dk if meru_r1==1 | embu_r1==1, over(round)
lincom [dk]2 - [dk]1 

svy: mean dk if kalenjin_r1==1, over(round)
lincom [dk]2 - [dk]1 

svy: mean dk if kisii_r1==1, over(round)
lincom [dk]2 - [dk]1 

svy: mean dk if kamba_r1==1, over(round)
lincom [dk]2 - [dk]1 

svy: mean dk if luhya_r1==1, over(round)
lincom [dk]2 - [dk]1 

svy: mean dk if mijikenda_r1==1, over(round)
lincom [dk]2 - [dk]1

svy: mean dk if luo_r1==1, over(round)
lincom [dk]2 - [dk]1 

svy: mean dk if other_r1==1 & embu_r1!=1, over(round)
lincom [dk]2 - [dk]1 

svy: mean dk, over(round)
lincom [dk]2 - [dk]1 








