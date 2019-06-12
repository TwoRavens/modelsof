clear all
set seed 27707
set maxvar 10000

use "anes2008panel_W7_merged.dta"

**CREATING MFT MEASURES**
gen Harm1 = W7Q52_2
gen Harm2 = W7Q52_3
gen Harm3 = W7Q11
gen Harm4 = W7Q12
gen Fair1 = W7Q52_4
gen Fair2 = W7Q52_5
gen Fair3 = W7Q13
gen Fair4 = W7Q14
gen Ing1 = W7Q52_6 /* love for country */
gen Ing2 = W7Q52_7 /* betray group */
gen Ing3 = W7Q15 /* proud of contry */
gen Ing4 = W7Q16 /* loyal to family */
gen Auth1 = W7Q52_8
gen Auth2 = W7Q52_9
gen Auth3 = W7Q17
gen Auth4 = W7Q18
gen Pur1 = W7Q52_10
gen Pur2 = W7Q52_11
gen Pur3 = W7Q19
gen Pur4 = W7Q20

recode Harm1 (-7 -5=.)
recode Harm2 (-7 -5=.)
recode Harm3 (-7 -5=.)
recode Harm4 (-7 -5=.)
recode Fair1 (-7 -5=.)
recode Fair2 (-7 -5=.)
recode Fair3 (-7 -5=.)
recode Fair4 (-7 -5=.)
recode Ing1 (-7 -5=.)
recode Ing2 (-7 -5=.)
recode Ing3 (-7 -5=.)
recode Ing4 (-7 -5=.)
recode Auth1 (-7 -5=.)
recode Auth2 (-7 -5=.)
recode Auth3 (-7 -5=.)
recode Auth4 (-7 -5=.)
recode Pur1 (-7 -5=.)
recode Pur2 (-7 -5=.)
recode Pur3 (-7 -5=.)
recode Pur4 (-7 -5=.)

gen HarmF = (Harm1 + Harm2 + Harm3 + Harm4 - 4)/20
gen FairF = (Fair1 + Fair2 + Fair3 + Fair4 - 4)/20
gen IngF = (Ing1 + Ing2 + Ing3 + Ing4 - 4)/20
gen AuthF = (Auth1 + Auth2 + Auth3 + Auth4 - 4)/20
gen PurF = (Pur1 + Pur2 + Pur3 + Pur4 - 4)/20

*2-item Loyalty measure with no patriotism items
gen IngFnopat = (Ing2 + Ing4 - 2)/10


*PARTY ID & IDEOLOGY
*other as indeps, Dem=low, Rep=hi

recode W1M1 -7/-1=.
recode W1M3 -7/-1=.
egen PID1 = rowfirst(W1M1 W1M3)
recode PID1 (1=2) (2=6) (3 4=4)
recode PID1 (4=3) if W1M6==2
recode PID1 (4=5) if W1M6==1
recode PID1 (2=1) (6=7) if W1M5==1

gen PID9=.
recode PID9 .=2 if (W9L1==1 | W9L3==1)
recode PID9 .=6 if (W9L1==2 | W9L3==2)
recode PID9 .=4 if (W9L1==3 | W9L3==3)
recode PID9 .=4 if (W9L1==4 | W9L3==4)
recode PID9 4=3 if W9L6==2
recode PID9 4=5 if W9L6==1
recode PID9 2=1 if W9L5==1
recode PID9 6=7 if W9L5==1

gen PID10 = .
replace PID10=1 if W10L5==1 & (W10L1==1 | W10L3==1)
replace PID10=2 if W10L5==2 & (W10L1==1 | W10L3==1)
replace PID10=7 if W10L5==1 & (W10L1==2 | W10L3==2)
replace PID10=6 if W10L5==2 & (W10L1==2 | W10L3==2)
replace PID10=5 if W10L6==1
replace PID10=4 if W10L6==3
replace PID10=3 if W10L6==2

recode W11L1 -7/-1=.
recode W11L3 -7/-1=.
egen PID11 = rowfirst(W11L1 W11L3)
recode PID11 1=2 2=6 3/4=4
recode PID11 2=1 6=7 if W11L5==1
recode PID11 4=3 if W11L6==2
recode PID11 4=5 if W11L6==1

gen PID17 = .
replace PID17=2 if (W17L1==1 | W17L3==1)
replace PID17=6 if (W17L1==2 | W17L3==2)
replace PID17=4 if (W17L1==3 | W17L1==4 | W17L3==3 | W17L3==4)
recode PID17 2=1 if W17L5==1
recode PID17 6=7 if W17L5==1
recode PID17 4=3 if W17L6==2
recode PID17 4=5 if W17L6==1

gen PID19 = .
replace PID19=2 if (W19L1==1 | W19L3==1)
replace PID19=6 if (W19L1==2 | W19L3==2)
replace PID19=4 if (W19L1==3 | W19L1==4 | W19L3==3 | W19L3==4)
recode PID19 2=1 if W19L5==1
recode PID19 6=7 if W19L5==1
recode PID19 4=3 if W19L6==2
recode PID19 4=5 if W19L6==1

*Ideology
gen Ideo = W1N1
recode Ideo (-7/-1=.) (1=2) (2=6) (3=4)
recode Ideo (2=1) if W1N2==1
recode Ideo (6=7) if W1N3==1
recode Ideo (4=3) if W1N4==1
recode Ideo (4=5) if W1N4==2

gen Ideo10 = W10M1
recode Ideo10 -7/-5=. 1=2 2=6 3=4
recode Ideo10 2=1 if W10M2==1
recode Ideo10 6=7 if W10M3==1
recode Ideo10 4=3 if W10M4==1
recode Ideo10 4=5 if W10M4==2

*demographics
gen ReligWeek = W1J1A_1
recode ReligWeek (-10/-1=.)
gen Relig1 = ReligWeek/7
gen ReligMonth = W1J1A_2
recode ReligMonth (-10/-1=.)
gen Relig2 = ReligMonth/30
gen ReligYear = W1J1A_3
recode ReligYear (-10/-1=.)
gen Relig3 = ReligYear/365
egen Attend = rowfirst(Relig1 Relig2 Relig3)

gen Income = .
*Under $35K
recode Income (.=1) if CPQ34==1
*$35-50K
recode Income (.=2) if CPQ36A==1
*$50-99K
recode Income (.=3) if CPQ36C==1
*$100K+
recode Income (.=4) if CPQ36C==2

gen Educ = CPQ15
recode Educ (1/8=1) (9=2) (10=3) (11=4) (12=5) (13=6) (14=7) (-7/-1=.)
gen Age = cpyourse
recode Age (-7/15=.)
gen Male = rgenderr
recode Male (-6=.) (2=0)
gen Black = 0
recode Black (0=1) if CPQ14_02==1
gen White = rracewhi
recode White -6/-1=. 

*Patriotism
gen pat1 = W19ZF1
recode pat1 -7/-5=. 2=-1 3=0
recode pat1 1=3 if W19ZF2_L==1
recode pat1 1=2 if W19ZF2_L==2
recode pat1 -1=-2 if W19ZF2_H==2
gen pat2 = W19ZF3
recode pat2 -7/-5=. 1=1 2=-1 3=0
recode pat2 1=3 if W19ZF4_G==1
recode pat2 1=2 if W19ZF4_G==2
recode pat2 -1=-3 if W19ZF4_B==1
recode pat2 -1=-2 if W19ZF4_B==2
gen pat3 = W19ZF5
recode pat3 -7/-5=. 1=5 2=4 3=3 4=2 5=1
gen pat4 = W19ZF6
recode pat4 -7/-5=. 1=5 2=4 3=3 4=2 5=1
gen pat5 = W19ZF7
recode pat5 -7/-5=. 1=-1 2=1 3=0
recode pat5 -1=-3 if W19ZF8==1
recode pat5 -1=-2 if W19ZF8==2
recode pat5 1=3 if W19ZF9==1
recode pat5 1=2 if W19ZF9==2
gen patr1 = (pat1 + 3)/6
gen patr2 = (pat2 + 3)/6
gen patr3 = (pat3 - 1)/4
gen patr4 = (pat4 - 1)/4
gen patr5 = (pat5 + 3)/6
alpha patr*, item gen(Patriotism) casewise

*Nationalism - Wave 9
gen Nation9 = W9ZA1
recode Nation9 -7/-1=. 2=0

*Partisan Strength
gen PID1ext = abs(PID1 - 4)
gen PID9ext = abs(PID9 - 4) 
gen PID10ext = abs(PID10 - 4)
gen PID11ext = abs(PID11 - 4)
gen PID17ext = abs(PID17 - 4)
gen PID19ext = abs(PID19 - 4)
alpha PID1ext PID9ext PID10ext PID11ext PID17ext PID19ext, gen(PIDextind) asis
xtile PIDextind4 = PIDextind, nquantiles(4)
xtile PIDextind5 = PIDextind, nquantiles(5)
xtile PIDextind6 = PIDextind, nquantiles(6)
gen PIDextindround = round(PIDextind)

*Ideological extremity
gen IdeoExt = abs(Ideo - 4)
gen IdeoExt10 = abs(Ideo10 - 4)

*2008 vote intention
gen WillVote9 = W9D1
recode WillVote9 -7/-1=. 1=1 2=0
gen WillVote10 = W10A5
recode WillVote10 -6/-1=. 1=1 2=0

*2008 turnout
gen Vote2008 = W11A4
recode Vote2008 -6/-1=. 1=0 2/5=1 6=0


************
* Analysis *
************

*Alphas
alpha Harm*, casewise
alpha Fair*, casewise
alpha Ing*, casewise
alpha Auth*, casewise
alpha Pur*, casewise
alpha patr1-patr5, casewise

*Table A2 - Correlation Table
sum PID9ext PID19ext HarmF FairF AuthF IngF PurF
pwcorr PID9ext PID19ext HarmF FairF AuthF IngF PurF, sig obs

*Table A1 & Table 1
ologit PIDextind4 HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo
est store a0
ologit PID1ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo
est store a1
ologit PID9ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo
est store a3
ologit PID10ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt10 Ideo10
est store a4
ologit PID11ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt10 Ideo10
est store a5
ologit PID17ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt10 Ideo10
est store a6
ologit PID19ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt10 Ideo10
est store a7

*Table 1
estout a3 a7 a0, cells(b(star fmt(2)) se) stats(N r2) starlevels(+ .10 * .05 ** .01 *** .001)

*Table A1
estout a*, cells(b(star fmt(2)) se) stats(N r2) starlevels(+ .10 * .05 ** .01 *** .001)

*Robustness of Index Measure
ologit PIDextind4 HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo
ologit PIDextind5 HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo
ologit PIDextind6 HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo
ologit PIDextindround HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo
reg PIDextind HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo


*Table 1 - Splitting PID 
ologit PID9ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend Ideo if PID9<5
est store s1
ologit PID9ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend Ideo if PID9>3
est store s3

ologit PID19ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend Ideo if PID19<5
est store s2
ologit PID19ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend Ideo if PID19>3
est store s4

estout s1 s2 s3 s4, cells(b(star fmt(2)) se) stats(N r2) starlevels(+ .10 * .05 ** .01 *** .001)

*Equivalence of D and R effects
suest s1 s3
test [s1_PID9ext]IngF=[s3_PID9ext]IngF

suest s2 s4
test [s2_PID19ext]IngF=[s4_PID19ext]IngF

*Effect sizes - W9
estsimp ologit PID9ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo
*Loyalty at 1 SD below mean
setx HarmF .72 FairF .74 AuthF .66 IngF .48 PurF .64 Educ 4 Income 3 Black 0 Male 0 Age 50 Attend .09 Ideo 4 IdeoExt 0
simqi
*Loyalty at 1 SD above mean
setx HarmF .72 FairF .74 AuthF .66 IngF .84 PurF .64 Educ 4 Income 3 Black 0 Male 0 Age 50 Attend .09 Ideo 4 IdeoExt 0
simqi
*Effect of 2 SD shift in Loyalty
setx HarmF .72 FairF .74 AuthF .66 IngF .48 PurF .64 Educ 4 Income 3 Black 0 Male 0 Age 50 Attend .09 Ideo 4 IdeoExt 0
simqi, fd(pr) changex(IngF .48 .84)
*Effect of 2 SD shift in education
setx HarmF .72 FairF .74 AuthF .66 IngF .66 PurF .64 Educ 2.33 Income 3 Black 0 Male 0 Age 50 Attend .09
simqi, fd(pr) changex(Educ 2.33 5.53)
*Effect of Partisan Gap in Loyalty 
sum IngF if PID9<4
sum IngF if PID9>4
setx HarmF .72 FairF .74 AuthF .66 IngF .63 PurF .64 Educ 4 Income 3 Black 0 Male 0 Age 50 Attend .09
simqi
setx HarmF .72 FairF .74 AuthF .66 IngF .71 PurF .64 Educ 4 Income 3 Black 0 Male 0 Age 50 Attend .09
simqi

*Effect sizes - W19
estsimp ologit PID19ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo, genname(c)
*Loyalty at 1 SD below mean
setx HarmF .72 FairF .74 AuthF .66 IngF .48 PurF .64 Educ 4 Income 3 Black 0 Male 0 Age 50 Attend .09 Ideo 4 IdeoExt 0
simqi
*Loyalty at 1 SD above mean
setx HarmF .72 FairF .74 AuthF .66 IngF .84 PurF .64 Educ 4 Income 3 Black 0 Male 0 Age 50 Attend .09 Ideo 4 IdeoExt 0
simqi
*Effect of 2 SD shift in Loyalty
simqi, fd(pr) changex(IngF .48 .84)
*Effect of 2 SD shift in education
setx HarmF .72 FairF .74 AuthF .66 IngF .66 PurF .64 Educ 2.33 Income 3 Black 0 Male 0 Age 50 Attend .09 Ideo 4 IdeoExt 0
simqi, fd(pr) changex(Educ 2.33 5.53)


*Table 2

*Controlling for patriotism/nationalism
ologit PID9ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo Nation9
est store p1
ologit PID19ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend Patriotism Ideo10 IdeoExt10
est store p2

*Removing patriotism items
ologit PID9ext HarmF FairF AuthF IngFnopat PurF Educ Income Black Male Age Attend IdeoExt Ideo
est store p3
ologit PID19ext HarmF FairF AuthF IngFnopat PurF Educ Income Black Male Age Attend Ideo10 IdeoExt10
est store p4

*Controlling & Removing
ologit PID9ext HarmF FairF AuthF IngFnopat PurF Educ Income Black Male Age Attend IdeoExt Ideo Nation9
est store p5
ologit PID19ext HarmF FairF AuthF IngFnopat PurF Educ Income Black Male Age Attend Patriotism Ideo10 IdeoExt10
est store p6

estout p*, cells(b(star fmt(2)) se) stats(N r2) starlevels(+ .10 * .05 ** .01 *** .001)


*Table A3 - Ideological Extremity
ologit IdeoExt HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend
est store i1
ologit IdeoExt10 HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend
est store i10

estout i1 i10, cells(b(star fmt(2)) se) stats(N r2) starlevels(+ .10 * .05 ** .01 *** .001)


*Table 4
logit WillVote9 HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo
est store t1
logit WillVote10 HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt10 Ideo10
est store t2
logit Vote2008 HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt10 Ideo10
est store t3
estout t1 t2 t3, cells(b(star fmt(2)) se) stats(N r2) starlevels(+ .10 * .05 ** .01 *** .001)

*Table 4 & Table A5 - Mediation 
medeff (regress PID9ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo) (logit WillVote9 PID9ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt Ideo), mediate(PID9ext) treat(IngF)
medeff (regress PID10ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt10 Ideo10) (logit WillVote10 PID10ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt10 Ideo10), mediate(PID10ext) treat(IngF)
medeff (regress PID10ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt10 Ideo10) (logit Vote2008 PID10ext HarmF FairF AuthF IngF PurF Educ Income Black Male Age Attend IdeoExt10 Ideo10), mediate(PID10ext) treat(IngF)

