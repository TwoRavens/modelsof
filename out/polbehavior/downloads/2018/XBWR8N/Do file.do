

use "Data file.dta"

set more off


*************************************************
******** TABLE 1. Descriptive Statistics ********
*************************************************

tab eg
tab eg access_land, row
summ land_size if eg==1, det
summ land_size if eg==6, det
tab eg not_enough_land, row
tab eg evicted, row
tab eg fear_eviction_high, row
tab eg gender, row
summ age
summ age if eg==1
summ age if eg==6
summ education
summ education if eg==1, detail
summ education if eg==6, detail
summ assetindex, detail
summ assetindex if eg==1, detail
summ assetindex if eg==6, detail
tab eg own_land, row
tab eg land_security, row
tab eg violence_2007, row
tab eg violence_prior, row






*************************************************
******** FIGURE 2. Effects on Candidate Support *
*************************************************

*Kalenjins
matrix res = (1,2,3\4,5,6)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 

reg support_candidate treat_1 treat_2 if kalenjin==1, level(90)
mat b = r(table)
matrix res[1,1] = b[1,1]
matrix res[1,2] = b[5,1]
matrix res[1,3] = b[6,1]
matrix res[2,1] = b[1,2]
matrix res[2,2] = b[5,2]
matrix res[2,3] = b[6,2]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
ytitle() title(Kalenjins) legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
coeflabels(r1 = "T1" r2 = "T2") ///
plotregion(lcolor(white)) name(a, replace) 

*Kikuyus
matrix res = (1,2,3\4,5,6)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 

reg support_candidate treat_1 treat_2 if kikuyu==1, level(90)
mat b = r(table)
matrix res[1,1] = b[1,1]
matrix res[1,2] = b[5,1]
matrix res[1,3] = b[6,1]
matrix res[2,1] = b[1,2]
matrix res[2,2] = b[5,2]
matrix res[2,3] = b[6,2]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
ytitle() title(Kikuyus) legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
coeflabels(r1 = "T1" r2 = "T2") ///
plotregion(lcolor(white)) name(b, replace) 

*Pooled sample
matrix res = (1,2,3\4,5,6)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 

reg support_candidate treat_1 treat_2, level(90)
mat b = r(table)
matrix res[1,1] = b[1,1]
matrix res[1,2] = b[5,1]
matrix res[1,3] = b[6,1]
matrix res[2,1] = b[1,2]
matrix res[2,2] = b[5,2]
matrix res[2,3] = b[6,2]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
ytitle() title(Pooled sample) legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
coeflabels(r1 = "T1" r2 = "T2") ///
plotregion(lcolor(white)) name(c, replace) 


graph combine c a b, ycommon scheme(s1mono) xsize(7.5) scale(1.3) row(1) name(g1, replace)






*************************************************************
******** FIGURE 3. Interaction with Perceived Land Security *
*************************************************************

*Kalenjins
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##land_security_low treat_2##land_security_low if kalenjin==1 
margins, dydx(treat_1) at(land_security_low=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##land_security_low treat_2##land_security_low if kalenjin==1
margins, dydx(treat_2) at(land_security_low=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kalenjins) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Land security" "HIGH""' r3 r4 = `""Land security" "LOW""', nogap) ///
name(a, replace) plotregion(lcolor(white)) 

*Kikuyus
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##land_security_low treat_2##land_security_low if kikuyu==1  
margins, dydx(treat_1) at(land_security_low=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##land_security_low treat_2##land_security_low if kikuyu==1  
margins, dydx(treat_2) at(land_security_low=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kikuyus) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Land security" "HIGH""' r3 r4 = `""Land security" "LOW""', nogap) ///
name(b, replace) plotregion(lcolor(white))


graph combine a b, ycommon scheme(s1mono) xsize(7.5) scale(1.3) row(1)  name(g2, replace)






*************************************************************
******** FIGURE 4. Interaction with Violence Exposure *******
*************************************************************

*Kalenjins
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##violence_ever treat_2##violence_ever if kalenjin==1 
margins, dydx(treat_1) at(violence_ever=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##violence_ever treat_2##violence_ever  if kalenjin==1 
margins, dydx(treat_2) at(violence_ever=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kalenjins) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Violence" "NO""' r3 r4 = `""Violence" "YES""', nogap) ///
name(a, replace) plotregion(lcolor(white))

*Kikuyus
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##violence_ever treat_2##violence_ever if kikuyu==1  
margins, dydx(treat_1) at(violence_ever=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##violence_ever treat_2##violence_ever if kikuyu==1  
margins, dydx(treat_2) at(violence_ever=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kikuyus) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Violence" "NO""' r3 r4 = `""Violence" "YES""', nogap) ///
name(b, replace) plotregion(lcolor(white))


graph combine a b, ycommon scheme(s1mono) xsize(7.5)  scale(1.3) row(1)  name(g3, replace)






*************************************************************
******** FIGURE 5. OTHER OUTCOMES ***************************
*************************************************************

*Trust other group
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg trustworthy_other treat_1 treat_2 if kalenjin==1, level(90)
mat b = r(table)
matrix res[1,1] = b[1,1]
matrix res[1,2] = b[5,1]
matrix res[1,3] = b[6,1]
matrix res[2,1] = b[1,2]
matrix res[2,2] = b[5,2]
matrix res[2,3] = b[6,2]

reg trustworthy_other treat_1 treat_2 if kikuyu==1, level(90)
mat b = r(table)
matrix res[3,1] = b[1,1]
matrix res[3,2] = b[5,1]
matrix res[3,3] = b[6,1]
matrix res[4,1] = b[1,2]
matrix res[4,2] = b[5,2]
matrix res[4,3] = b[6,2]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
subtitle("Trust Other Group" " ") ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = "Kalenjin" r3 r4 = "Kikuyu", nogap) ///
name(a, replace) plotregion(lcolor(white))


*Outsiders do not deserve to own land in this area
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg agree_outsiders treat_1 treat_2 if kalenjin==1, level(90)
mat b = r(table)
matrix res[1,1] = b[1,1]
matrix res[1,2] = b[5,1]
matrix res[1,3] = b[6,1]
matrix res[2,1] = b[1,2]
matrix res[2,2] = b[5,2]
matrix res[2,3] = b[6,2]

reg agree_outsiders treat_1 treat_2 if kikuyu==1, level(90)
mat b = r(table)
matrix res[3,1] = b[1,1]
matrix res[3,2] = b[5,1]
matrix res[3,3] = b[6,1]
matrix res[4,1] = b[1,2]
matrix res[4,2] = b[5,2]
matrix res[4,3] = b[6,2]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
subtitle("Outsiders Do Not Deserve" "to Own Land in Area") ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = "Kalenjin" r3 r4 = "Kikuyu", nogap) ///
name(b, replace) plotregion(lcolor(white))


*Sometimes it is necessary for politicians or citizens to use violence when it comes to defending the land of his followers
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg agree_violence treat_1 treat_2 if kalenjin==1, level(90)
mat b = r(table)
matrix res[1,1] = b[1,1]
matrix res[1,2] = b[5,1]
matrix res[1,3] = b[6,1]
matrix res[2,1] = b[1,2]
matrix res[2,2] = b[5,2]
matrix res[2,3] = b[6,2]

reg agree_violence treat_1 treat_2 if kikuyu==1, level(90)
mat b = r(table)
matrix res[3,1] = b[1,1]
matrix res[3,2] = b[5,1]
matrix res[3,3] = b[6,1]
matrix res[4,1] = b[1,2]
matrix res[4,2] = b[5,2]
matrix res[4,3] = b[6,2]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
subtitle("Support for Use of Violence" " ") ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = "Kalenjin" r3 r4 = "Kikuyu", nogap) ///
name(c, replace) plotregion(lcolor(white))


graph combine a b c, ycommon scheme(s1mono) xsize(8)  scale(1.3) row(1)













*************************************************************************************
************************ SUPPLEMENTAL INFORMATION ***********************************
*************************************************************************************






****************************************************
***** SI TABLE A6. MAIN RESULTS ********************
****************************************************

reg support_candidate treat_1 treat_2 
reg support_candidate treat_1 treat_2 if kalenjin==1
reg support_candidate treat_1 treat_2 if kikuyu==1 
reg support_candidate treat_1##land_security_low treat_2##land_security_low if kalenjin==1 
reg support_candidate treat_1##land_security_low treat_2##land_security_low if kikuyu==1
reg support_candidate treat_1##violence_ever treat_2##violence_ever if kalenjin==1 
reg support_candidate treat_1##violence_ever treat_2##violence_ever if kikuyu==1 



****************************************************
***** SI TABLE A7. MAIN RESULTS, with controls *****
****************************************************

reg support_candidate treat_1 treat_2 education age female close_own if kalenjin==1
reg support_candidate treat_1 treat_2 education age female close_own if kikuyu==1
reg support_candidate treat_1##land_security_low treat_2##land_security_low education age female close_own if kalenjin==1
reg support_candidate treat_1##land_security_low treat_2##land_security_low education age female close_own if kikuyu==1
reg support_candidate treat_1##violence_ever treat_2##violence_ever education age female close_own if kalenjin==1 
reg support_candidate treat_1##violence_ever treat_2##violence_ever education age female close_own if kikuyu==1 





*****************************************************
***** SI TABLE A8, A9, 10. (fully interacted rather *
***** than estimated with split sample) *************
*****************************************************

*A8
reg support_candidate treatment##kalenjin

*Do effects differ between Kalenjins and Kikuyus?
margins rb1.kalenjin, dydx(1.treatment)
margins rb1.kalenjin, dydx(2.treatment)


*A9
reg support_candidate i.treatment##i.kalenjin##i.land_security_low

*A10
reg support_candidate i.treatment##i.kalenjin##i.violence_ever








****************************************************
***** SI TABLE A11. MAIN RESULTS, tobit models *****
****************************************************

tobit support_candidate treat_1 treat_2, ll(1) ul(5)
tobit support_candidate treat_1 treat_2 if kalenjin==1, ll(1) ul(5)
tobit support_candidate treat_1 treat_2 if kikuyu==1 , ll(1) ul(5)
tobit support_candidate treat_1##land_security_low treat_2##land_security_low if kalenjin==1 , ll(1) ul(5)
tobit support_candidate treat_1##land_security_low treat_2##land_security_low if kikuyu==1, ll(1) ul(5)
tobit support_candidate treat_1##violence_ever treat_2##violence_ever if kalenjin==1 , ll(1) ul(5)
tobit support_candidate treat_1##violence_ever treat_2##violence_ever if kikuyu==1 , ll(1) ul(5)





********************************************************
***** SI TABLE A12. MAIN RESULTS, ordered logit models *
********************************************************

ologit support_candidate treat_1 treat_2 
ologit support_candidate treat_1 treat_2 if kalenjin==1
ologit support_candidate treat_1 treat_2 if kikuyu==1 
ologit support_candidate treat_1##land_security_low treat_2##land_security_low if kalenjin==1 
ologit support_candidate treat_1##land_security_low treat_2##land_security_low if kikuyu==1
ologit support_candidate treat_1##violence_ever treat_2##violence_ever if kalenjin==1 
ologit support_candidate treat_1##violence_ever treat_2##violence_ever if kikuyu==1 





***********************************************************
***** SI FIGURE A2. Alternative measures of land security *
***********************************************************

*land_size, dichotomous (=1 if <1 acre)
replace land_size=. if land_size==8
recode land_size (1/2=1) (.=.) (else=0), gen(land_poor)
 
*1. Land poor
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##land_poor treat_2##land_poor if kalenjin==1
margins, dydx(treat_1) at(land_poor=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##land_poor treat_2##land_poor if kalenjin==1  
margins, dydx(treat_2) at(land_poor=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kalenjins) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Land poor" "NO""' r3 r4 = `""Land poor" "YES""', nogap) ///
name(a, replace) plotregion(lcolor(white)) 


matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##land_poor treat_2##land_poor if kikuyu==1
margins, dydx(treat_1) at(land_poor=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##land_poor treat_2##land_poor if kikuyu==1  
margins, dydx(treat_2) at(land_poor=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kikuyus) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Land poor" "NO""' r3 r4 = `""Land poor" "YES""', nogap) ///
name(b, replace) plotregion(lcolor(white)) 


*2. Not enough land
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##not_enough_land treat_2##not_enough_land if kalenjin==1
margins, dydx(treat_1) at(not_enough_land =(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##not_enough_land treat_2##not_enough_land if kalenjin==1  
margins, dydx(treat_2) at(not_enough_land =(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kalenjins) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Not enough land" "NO""' r3 r4 = `""Not enough land" "YES""', nogap) ///
name(c, replace) plotregion(lcolor(white)) 


matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##not_enough_land treat_2##not_enough_land if kikuyu==1
margins, dydx(treat_1) at(not_enough_land =(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##not_enough_land treat_2##not_enough_land if kikuyu==1  
margins, dydx(treat_2) at(not_enough_land =(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kikuyus) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Not enough land" "NO""' r3 r4 = `""Not enough land" "YES""', nogap) ///
name(d, replace) plotregion(lcolor(white)) 


*3. Ever been evicted
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##evicted treat_2##evicted if kalenjin==1
margins, dydx(treat_1) at(evicted =(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##evicted treat_2##evicted if kalenjin==1  
margins, dydx(treat_2) at(evicted =(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kalenjins) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Ever evicted" "NO""' r3 r4 = `""Ever evicted" "YES""', nogap) ///
name(e, replace) plotregion(lcolor(white)) 


matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##evicted treat_2##evicted if kikuyu==1
margins, dydx(treat_1) at(evicted =(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##evicted treat_2##evicted if kikuyu==1  
margins, dydx(treat_2) at(evicted =(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kikuyus) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Ever evicted" "NO""' r3 r4 = `""Ever evicted" "YES""', nogap) ///
name(f, replace) plotregion(lcolor(white)) 


graph combine a b c d e f, ycommon scheme(s1mono) row(3) xsize(5) ysize(9)






*********************************************************
***** SI TABLE A13. Did placement of land question bloc *
***** affect outcomes? **********************************
*********************************************************

reg support_candidate treat_1##bloc_before treat_2##bloc_before
reg support_candidate treat_1##bloc_before treat_2##bloc_before if kalenjin==1 
reg support_candidate treat_1##bloc_before treat_2##bloc_before if kikuyu==1 





*********************************************************
***** SI TABLE A14. Did treatment assignment affect *****
***** answers to land questions, for those who got  *****
***** land question bloc after treatment ?          *****
*********************************************************

reg not_enough_land treat_1 treat_2 if bloc_before==0
reg not_enough_land treat_1 treat_2 if bloc_before==0 & kalenjin==1
reg not_enough_land treat_1 treat_2 if bloc_before==0 & kikuyu==1

reg land_security treat_1 treat_2 if bloc_before==0
reg land_security treat_1 treat_2 if bloc_before==0 & kalenjin==1
reg land_security treat_1 treat_2 if bloc_before==0 & kikuyu==1

reg fear_eviction_high treat_1 treat_2 if bloc_before==0
reg fear_eviction_high treat_1 treat_2 if bloc_before==0 & kalenjin==1
reg fear_eviction_high treat_1 treat_2 if bloc_before==0 & kikuyu==1







********************************************************
***** SI TABLE A15. Other outcomes, OLS models *********
********************************************************

reg trustworthy_other treat_1 treat_2 if kalenjin==1 
reg trustworthy_other treat_1 treat_2 if kikuyu==1 
reg agree_outsiders treat_1 treat_2 if kalenjin==1 
reg agree_outsiders treat_1 treat_2 if kikuyu==1 
reg agree_violence treat_1 treat_2 if kalenjin==1 
reg agree_violence treat_1 treat_2 if kikuyu==1 










********************************************************
***** SI FIGURE A3. Main tests, excluding respondents **
***** who said candidate was not a co-ethnic          **
********************************************************

***Average Effect***

*Kalenjins
matrix res = (1,2,3\4,5,6)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 

reg support_candidate treat_1 treat_2 if kalenjin==1 & eg_correct==1, level(90)
mat b = r(table)
matrix res[1,1] = b[1,1]
matrix res[1,2] = b[5,1]
matrix res[1,3] = b[6,1]
matrix res[2,1] = b[1,2]
matrix res[2,2] = b[5,2]
matrix res[2,3] = b[6,2]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
ytitle() title(Kalenjins) legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
coeflabels(r1 = "T1" r2 = "T2") ///
plotregion(lcolor(white)) name(a, replace) 

*Kikuyus
matrix res = (1,2,3\4,5,6)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 

reg support_candidate treat_1 treat_2 if kikuyu==1 & eg_correct==1, level(90)
mat b = r(table)
matrix res[1,1] = b[1,1]
matrix res[1,2] = b[5,1]
matrix res[1,3] = b[6,1]
matrix res[2,1] = b[1,2]
matrix res[2,2] = b[5,2]
matrix res[2,3] = b[6,2]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
ytitle() title(Kikuyus) legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
coeflabels(r1 = "T1" r2 = "T2") ///
plotregion(lcolor(white)) name(b, replace) 


graph combine a b, ycommon scheme(s1mono) xsize(7.5) scale(1.3) row(1)  name(g1, replace)  title("(A) Average Effects by Ethnic Group")



***Interaction with perceived land security***

*Kalenjins
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##land_security_low treat_2##land_security_low if kalenjin==1  & eg_correct==1
margins, dydx(treat_1) at(land_security_low=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##land_security_low treat_2##land_security_low if kalenjin==1 & eg_correct==1
margins, dydx(treat_2) at(land_security_low=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kalenjins) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Land security" "HIGH""' r3 r4 = `""Land security" "LOW""', nogap) ///
name(c, replace) plotregion(lcolor(white)) 

*Kikuyus
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##land_security_low treat_2##land_security_low if kikuyu==1 & eg_correct==1
margins, dydx(treat_1) at(land_security_low=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##land_security_low treat_2##land_security_low if kikuyu==1 & eg_correct==1
margins, dydx(treat_2) at(land_security_low=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kikuyus) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Land security" "HIGH""' r3 r4 = `""Land security" "LOW""', nogap) ///
name(d, replace) plotregion(lcolor(white))


graph combine c d, ycommon scheme(s1mono) xsize(7.5) scale(1.3) row(1)  name(g2, replace)  title("(B) Interaction with Perceived Land Insecurity")




***Interaction with violence exposure***
*Kalenjins
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##violence_ever treat_2##violence_ever if kalenjin==1 & eg_correct==1
margins, dydx(treat_1) at(violence_ever=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##violence_ever treat_2##violence_ever  if kalenjin==1 & eg_correct==1 
margins, dydx(treat_2) at(violence_ever=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kalenjins) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Violence" "NO""' r3 r4 = `""Violence" "YES""', nogap) ///
name(e, replace) plotregion(lcolor(white))

*Kikuyus
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##violence_ever treat_2##violence_ever if kikuyu==1 & eg_correct==1  
margins, dydx(treat_1) at(violence_ever=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##violence_ever treat_2##violence_ever if kikuyu==1 & eg_correct==1  
margins, dydx(treat_2) at(violence_ever=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kikuyus) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Violence" "NO""' r3 r4 = `""Violence" "YES""', nogap) ///
name(f, replace) plotregion(lcolor(white))


graph combine e f, ycommon scheme(s1mono) xsize(7.5)  scale(1.3) row(1)  name(g3, replace) title("(C) Interaction with Violence Exposure")


graph combine g1 g2 g3, ycommon scheme(s1mono) row(3) xsize(5) ysize(9)


***Interaction with perceived land security***

*Kalenjins
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##land_security_low treat_2##land_security_low if kalenjin==1  & eg_correct==1
margins, dydx(treat_1) at(land_security_low=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##land_security_low treat_2##land_security_low if kalenjin==1 & eg_correct==1
margins, dydx(treat_2) at(land_security_low=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kalenjins) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Land security" "HIGH""' r3 r4 = `""Land security" "LOW""', nogap) ///
name(c, replace) plotregion(lcolor(white)) 

*Kikuyus
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##land_security_low treat_2##land_security_low if kikuyu==1 & eg_correct==1
margins, dydx(treat_1) at(land_security_low=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##land_security_low treat_2##land_security_low if kikuyu==1 & eg_correct==1
margins, dydx(treat_2) at(land_security_low=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kikuyus) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Land security" "HIGH""' r3 r4 = `""Land security" "LOW""', nogap) ///
name(d, replace) plotregion(lcolor(white))


graph combine c d, ycommon scheme(s1mono) xsize(7.5) scale(1.3) row(1)  name(g2, replace)  title("(B) Interaction with Perceived Land Insecurity")




***Interaction with violence exposure***
*Kalenjins
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##violence_ever treat_2##violence_ever if kalenjin==1 & eg_correct==1
margins, dydx(treat_1) at(violence_ever=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##violence_ever treat_2##violence_ever  if kalenjin==1 & eg_correct==1 
margins, dydx(treat_2) at(violence_ever=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kalenjins) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Violence" "NO""' r3 r4 = `""Violence" "YES""', nogap) ///
name(e, replace) plotregion(lcolor(white))

*Kikuyus
matrix res = (1,2,3\4,5,6\7,8,9\10,11,12)
matrix coln res = me ll90 ul90
matrix rown res = r1 r2 r3 r4

reg support_candidate treat_1##violence_ever treat_2##violence_ever if kikuyu==1 & eg_correct==1  
margins, dydx(treat_1) at(violence_ever=(0 1) treat_2=(0)) post level(90)

mat b = r(table)
matrix res[1,1] = b[1,3]
matrix res[1,2] = b[5,3]
matrix res[1,3] = b[6,3]
matrix res[3,1] = b[1,4]
matrix res[3,2] = b[5,4]
matrix res[3,3] = b[6,4]

reg support_candidate treat_1##violence_ever treat_2##violence_ever if kikuyu==1 & eg_correct==1  
margins, dydx(treat_2) at(violence_ever=(0 1) treat_1=(0)) post level(90)
mat b = r(table)
matrix res[2,1] = b[1,3]
matrix res[2,2] = b[5,3]
matrix res[2,3] = b[6,3]
matrix res[4,1] = b[1,4]
matrix res[4,2] = b[5,4]
matrix res[4,3] = b[6,4]

coefplot matrix(res[.,1]), ci((res[.,2] res[.,3])) ///
title(Kikuyus) ytitle() legend(off) vertical ///
aspectratio(1) yline(0, lcolor(red) lpattern(dash)) scheme(s1mono) ylabel(, angle(0)) ///
order(r1 r2 . r3 r4) ///
coeflabels(r1 = "T1" r2 = "T2" r3 = "T1" r4 = "T2")  groups(r1 r2 = `""Violence" "NO""' r3 r4 = `""Violence" "YES""', nogap) ///
name(f, replace) plotregion(lcolor(white))


graph combine e f, ycommon scheme(s1mono) xsize(7.5)  scale(1.3) row(1)  name(g3, replace) title("(C) Interaction with Violence Exposure")


graph combine g1 g2 g3, ycommon scheme(s1mono) row(3) xsize(5) ysize(9)





***************************************************************
***** SI TABLE A18. Interactions not reported in text *********
***************************************************************

*Ethnic identification
replace eg_sal2 = eg_sal2-1
reg support_candidate treat_1##c.eg_sal2 treat_2##c.eg_sal2 if kalenjin==1 
reg support_candidate treat_1##c.eg_sal2 treat_2##c.eg_sal2 if kikuyu==1


*Closeness to own group 
replace close_own = close_own-1
reg support_candidate treat_1##c.close_own treat_2##c.close_own if kalenjin==1 
reg support_candidate treat_1##c.close_own treat_2##c.close_own if kikuyu==1


*Wealth (below median)
reg support_candidate treat_1##assets_low treat_2##assets_low if kalenjin==1 
reg support_candidate treat_1##assets_low treat_2##assets_low if kikuyu==1


*Education   
replace education=education-1
reg support_candidate treat_1##c.education treat_2##c.education if kalenjin==1 
reg support_candidate treat_1##c.education treat_2##c.education if kikuyu==1


*Gender
gen male=gender
reg support_candidate treat_1##male treat_2##male if kalenjin==1 
reg support_candidate treat_1##male treat_2##male if kikuyu==1




