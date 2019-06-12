********************************************************************************
**************			REPLICATION FILE				************************
*  Learning from the other side:  how social networks influence turnout in a referendum campaign
********************************************************************************


use "ITANES_POSTREFERENDUM_2016_COS_COMPETITION.dta", clear

********************************************************************************
**************			DATA PREPARATION				************************
********************************************************************************

*******************                             CREATE NETWORK DIVERSITY INDEXES
****                                            WITHOUT DK - CONTINUOUS MEASURES
set more off

recode S28 (1=1 "Yes") (2=2 "No") (3/4=.), gen(votepre2)

*Strong ties (family)
tab S34
recode S34 (1 7=0 "min diversity") (2 6=1) (3 5=2) (4=3 "max diversity") (8/9=.), gen(strongtieA)
gen strongtieA01 = strongtieA/3
ta strongtieA01 // 1=max diversity
*Medium ties (friends)
tab S35
recode S35 (1 7=0 "min diversity") (2 6=1) (3 5=2) (4=3 "max diversity") (8/9=.), gen(mediumtieA)
ta mediumtieA
gen mediumtieA01 = mediumtieA/3
*Weak ties (acquaintances)
tab S36
recode S36 (1 7=0 "min diversity") (2 6=1) (3 5=2) (4=3 "max diversity") (8/9=.), gen(weaktieA)
gen weaktieA01 = weaktieA/3
ta weaktieA
ta weaktieA01

*INDEX AS PLANNED IN THE TEMPLATE
*from 0 min diversity / to 1 max (dk excluded)
gen NDindex = (strongtieA+mediumtieA+weaktieA)
gen NDindex01 = (strongtieA+mediumtieA+weaktieA)/9
ta NDindex
ta NDindex01

*CATEGORICAL INDEX WITH RESIDUAL CATEGORY FOR DK/NO REPLIES
*tertiles 1
xtile NDindexr = NDindex, nq(3)
recode NDindexr (1=1 "min div") (3=3 "max div") (.=4 "dk/no reply"), gen(NDindter1)
ta NDindter1
drop NDindexr


*****************
*ALTERNATIVE INDEX A
**network ostile = voto sì e nessuno/quasi nessuno vota sì oppure voto no e tutti/quasi tutti votano sì

tab votepre2
*family
gen S34yes = S34 if votepre2==1 // yes voters
gen S34no = S34 if votepre2==2 // no voters
gen S34other = S34 if votepre2==. // other voters
recode S34yes (1 2=100 "hostility") (3 5=3) (4=4 "max div") (6=2) (7=1 "min div") (8 9=0) (.=0), gen(S34yes1)
recode S34no (6 7=100 "hostility") (3 5=3) (4=4 "max div") (2=2) (1=1 "min div") (8 9=0) (.=0), gen(S34no1)
recode S34other (1 7=1 "min div") (2 6=2) (3 5=3) (4=4 "max div") (8 9=0) (.=0), gen(S34other1)
gen family1 = S34yes1+S34no1+S34other1
ta family1
*friends
gen S35yes = S35 if votepre2==1 // yes voters
gen S35no = S35 if votepre2==2 // no voters
gen S35other = S35 if votepre2==. // other voters
recode S35yes (1 2=100 "hostility") (3 5=3) (4=4 "max div") (6=2) (7=1 "min div") (8 9=0) (.=0), gen(S35yes1)
recode S35no (6 7=100 "hostility") (3 5=3) (4=4 "max div") (2=2) (1=1 "min div") (8 9=0) (.=0), gen(S35no1)
recode S35other (1 7=1 "min div") (2 6=2) (3 5=3) (4=4 "max div") (8 9=0) (.=0), gen(S35other1)
gen friends1 = S35yes1+S35no1+S35other1
ta friends1
*acquaintances
gen S36yes = S36 if votepre2==1 // yes voters
gen S36no = S36 if votepre2==2 // no voters
gen S36other = S36 if votepre2==. // other voters
recode S36yes (1 2=100 "hostility") (3 5=3) (4=4 "max div") (6=2) (7=1 "min div") (8 9=0) (.=0), gen(S36yes1)
recode S36no (6 7=100 "hostility") (3 5=3) (4=4 "max div") (2=2) (1=1 "min div") (8 9=0) (.=0), gen(S36no1)
recode S36other (1 7=1 "min div") (2 6=2) (3 5=3) (4=4 "max div") (8 9=0) (.=0), gen(S36other1)
gen acquan1 = S36yes1+S36no1+S36other1
ta acquan1

*create alternative index A
gen NDaltAall = family1 + friends1 + acquan1 if (family1!=0 & friends1!=0 & acquan1!=0)
ta NDaltAall
*continuos index without hostile people
gen NDaltA = (NDaltAall-3)/9 if NDaltA<100
ta NDaltA

*tertiles
recode NDaltAall (3/7=1 "min div") (8/10=2) (11/12=3 "max div") (100/300=4 "host") (.=5 "dk/no reply"), gen(NDaltAter1)
recode NDaltAall (3/6=1 "min div") (7/9=2) (10/12=3 "max div") (100/300=4 "host") (.=5 "dk/no reply"), gen(NDaltAter2)
ta NDaltAter1
ta NDaltAter2


****************************
*INDEXES WEIGHTED BY FREQUENCY OF DISCUSSION

*Frequency of discussion (post-referendum wave)
tab D18_02_W9
recode D18_02_W9 (4=0 "mai") (3=0.33) (2=0.67) (1=1 "tuttiigiorni") (else=.), gen(frequency_discussion_post)
ta frequency_discussion_post, nol

*original index
ta NDindex01
gen NDindexW1 = NDindex01*frequency_discussion_post
ta NDindexW1
*alternative index A
ta NDaltA
gen NDaltAW1 = NDaltA*frequency_discussion_post
ta NDaltAW1


****************************
*INDEXES WEIGHTED BY strong tie diversity

*original index
ta NDindex01
gen NDindexW2 = NDindex01*strongtieA01
ta NDindexW2
*alternative index A
ta NDaltA
gen strongtiealtA =.
replace strongtiealtA = 4 if S34==4
replace strongtiealtA = 3 if (S34==3 | S34==5)
replace strongtiealtA = 2 if (S34==6 & votepre2==1) | (S34==2 & votepre2==2) | ((S34==6 | S34==2) & votepre2==.)
replace strongtiealtA = 1 if (S34==7 & votepre2==1) | (S34==1 & votepre2==2) | ((S34==7 | S34==1) & votepre2==.)
gen strongtiealtA01 = (strongtiealtA-1)/3
gen NDaltAW2 = NDaltA*strongtiealtA01
ta NDaltAW2

*SOCIO-DEMO
*gender (2=female)
ta s01
rename s01 female

*age continuous > age at the end of 2016
ta s03 // year of birth
gen age = 2016-s03
ta age

*macro regions
ta s04
gen area1 = s04
recode area1 1=4	2=4	3=4	4=4	5=2	6=2	7=3	8=1	9=1	10=3 11=4 12=1 13=4	14=5 15=5 16=3 17=2	18=3 19=1 20=2
label de area1 1 "north west" 2 "north east" 3 "centre" 4 "south" 5 "islands"
label values area1 area1
ta area1
recode area1 (1 2=1 "north") (3=2 "centre") (4 5=3 "south"), gen(area2)
ta area2

*education
*What is "superiori in corso"?
ta s10
recode s10 (1 2=1 "no edu/elementari/medie") (3/5=2 "high school degree 3 or 5 years)") (6=4 "currently studying at uni") (7/11=3 "university degree (3 years+"), gen(edu4)
recode s10 (1 2=1 "no edu/elementari/medie") (3 4=2 "superiori in corso/diploma profess.") (5=3 "high school degree (5 years)") (6=5 "currently studying at uni") (7/11=4 "university degree (3 years+"), gen(edu5)
ta edu4
ta edu5

*status of unemployed
ta s14
ta s14_w7 // 2016
ta s14_w7, nol
recode s14_w7 (.=0 "employed") (1=1 "retired") (2=2 "housewife") (3=3 "student") (5 6 7 9=4 "unemployed") (4 8 10 11 12=5 "other"), gen(unempl)
ta unempl

*turnout
tab D28_W9
recode D28_W9 (1/2=1 "voted") (4=0 "did not vote") (3=.), gen(turnoutpost)
ta turnoutpost
recode D28_W9 (1 2 3=1 "voted yes/no/blank") (4=0 "did not vote"), gen(turnoutpost1)
ta turnoutpost1 // blank votes included in "voted"
recode D28_W9 (1/2=1 "voted") (3/4=0 "did not vote/blank vote"), gen(turnoutpostWblank)
ta turnoutpostWblank // blank votes included in "did not vote"

*government evaluation
tab S20
gen evgov1 = S20-1
recode evgov1 (0=0 "Very negative") (10=10 "Very positive") (11=.), gen(evgov)
label var evgov "Evaluation of Renzi Governement"
ta evgov
drop evgov1

*pid
tab D11_W9
recode D11_W9 (1=1 "PD") (2=2 "M5S") (3=3 "FI") (4/5=4 "UDC/SC") (6=5 "SEL") (7=6 "LN") (8/13=7 "Altro") (14=0 "No PID") (else=.), gen (PID)
ta PID

recode D11_W9 (1/13=1 "Close to a party") (14=0 "No PID") (else=.), gen (PIDyn)
ta PIDyn

recode PID (0=0 "no pid") (1=1 "PD") (2/7=2 "other party"), gen(PID3)
ta PID3

*turnout pre-wave
recode S27 (1=1 "will go to vote") (2 3=0 "won't go/undecided") (4=.), gen(turnoutpre1)
ta turnoutpre1 // no replies excluded
recode S27 (1=1 "will go to vote") (2=2 "won't go to vote") (3=3 "undecided") (4=.), gen(turnoutpre2)
ta turnoutpre2 // categorical



*************************
*knowledge

*single questions
ta D24_W9
recode D24_W9 (2 3=0 "wrong") (1=1 "correct"), gen(knowPOST1)
ta D25_W9
recode D25_W9 (1=1 "correct") (2 3=0 "wrong"), gen(knowPOST2)
ta knowPOST1
ta knowPOST2

*knowledge index (simple additive index)
gen knowPOST = knowPOST1 + knowPOST2
label var knowPOST "Knowledge additive index"
label de knowPOST 0 "No knowledge" 2 "Max knowledge"
label values knowPOST knowPOST
ta knowPOST 
gen knowPOST01 = knowPOST/2 // index rescaled from 0 to 1
ta knowPOST01
*standardized
egen stknowPOST = std(knowPOST)
*dummy
recode knowPOST (1=0 "low knowledge") (2=1 "high knowledge"), gen(knowpostdum)
ta knowpostdum

*************
*ambivalence (POST)

*item 1 - riduzione senatori
ta D27_01_W9
recode D27_01_W9 12=6, gen(D27_01_W9A) // DK recoded as equal to 5
recode D27_01_W9 12=., gen(D27_01_W9B) // DK dropped
gen ambivPOST1A = D27_01_W9A-6
gen ambivPOST1B = D27_01_W9B-6
label var ambivPOST1A "Opinion on reducing senators (DK=5)"
label var ambivPOST1B "Opinion on reducing senators"
label de ambivPOST -5 "Very negative" 5 "Very positive"
label values ambivPOST1A ambivPOST
label values ambivPOST1B ambivPOST
ta ambivPOST1A
ta ambivPOST1B
drop D27_01_W9A D27_01_W9B

*item 2 - abolizione bicameralismo
ta D27_02_W9
recode D27_02_W9 12=6, gen(D27_02_W9A) // DK recoded as equal to 5
recode D27_02_W9 12=., gen(D27_02_W9B) // DK dropped
gen ambivPOST2A = D27_02_W9A-6
gen ambivPOST2B = D27_02_W9B-6
label var ambivPOST2A "Opinion on abolishing bicameral powers (DK=5)"
label var ambivPOST2B "Opinion on abolishing bicameral powers"
label values ambivPOST2A ambivPOST
label values ambivPOST2B ambivPOST
ta ambivPOST2A
ta ambivPOST2B
drop D27_02_W9A D27_02_W9B

*item3 - maggiori competenze allo stato
ta D27_03_W9
recode D27_03_W9 12=6, gen(D27_03_W9A) // DK recoded as equal to 5
recode D27_03_W9 12=., gen(D27_03_W9B) // DK dropped
gen ambivPOST3A = D27_03_W9A-6
gen ambivPOST3B = D27_03_W9B-6
label var ambivPOST3A "Opinion on more powers to the state (DK=5)"
label var ambivPOST3B "Opinion on more powers to the state"
label values ambivPOST3A ambivPOST
label values ambivPOST3B ambivPOST
ta ambivPOST3A
ta ambivPOST3B
drop D27_03_W9A D27_03_W9B

*item4 - abbassamento quorum
ta D27_04_W9
recode D27_04_W9 12=6, gen(D27_04_W9A) // DK recoded as equal to 5
recode D27_04_W9 12=., gen(D27_04_W9B) // DK dropped
gen ambivPOST4A = D27_04_W9A-6
gen ambivPOST4B = D27_04_W9B-6
label var ambivPOST4A "Opinion on lowering referendum quorum (DK=5)"
label var ambivPOST4B "Opinion on lowering referendum quorum"
label values ambivPOST4A ambivPOST
label values ambivPOST4B ambivPOST
ta ambivPOST4A
ta ambivPOST4B
drop D27_04_W9A D27_04_W9B

*AMBIVPOSTALENCE INDEX A, INCLUDING DK
*max ambivPOST=-11.547 / min ambivPOST=5 / complete neutral or dk=0
egen meanambPOSTA = rowmean(ambivPOST1A ambivPOST2A ambivPOST3A ambivPOST4A)
ta meanambPOSTA
egen sdambPOSTA = rowsd(ambivPOST1A ambivPOST2A ambivPOST3A ambivPOST4A)
ta sdambPOSTA
gen ambivPOSTA = -((abs(meanambPOSTA))-2*(sdambPOSTA))
ta ambivPOSTA // reverse scores: -5=MIN ambivPOST / 11.54=MAX ambivPOST / 0=neutral or dk
*sum D27_01_W9 D27_02_W9 if ambivPOSTA>11 & D27_03_W9==1 & D27_04_W9==1 // test
*sum D27_01_W9 D27_02_W9 if ambivPOSTA>11 & D27_03_W9==11 & D27_04_W9==11 // test
label var ambivPOSTA "Ambivalence PSOT index, DK included"
sum ambivPOSTA, detail // the higher the value, the higher the ambivPOSTalence
drop meanambPOSTA sdambPOSTA
*normalized index: from 0 (min ambivPOST) to 1 (max ambivPOST)
egen min_ambivPOSTA = min(ambivPOSTA)
egen max_ambivPOSTA = max(ambivPOSTA)
gen nambivPOSTA = (ambivPOSTA - min_ambivPOSTA)/(max_ambivPOSTA - min_ambivPOSTA)
label var nambivPOSTA "Ambivalence POST index, DK included, from 0 min, to 1 max"
sum nambivPOSTA, detail // USE THIS ONE
*ta nambivPOSTA if ambivPOSTA>11
drop min_ambivPOSTA max_ambivPOSTA
*standardized index
egen stambivPOSTA = std(ambivPOSTA)
label var stambivPOSTA "Ambiv POST index + DK, standardized, higher values=more ambivPOST"
sum stambivPOSTA, detail // USE THIS ONE
*ta stambivPOSTA if ambivPOSTA>11

*AMBIVPOSTALENCE INDEX B, EXCLUDING DK
egen meanambB = rowmean(ambivPOST1B ambivPOST2B ambivPOST3B ambivPOST4B) if (ambivPOST1B!=. & ambivPOST2B!=. & ambivPOST3B!=. & ambivPOST4B!=.)
sum meanambB, detail
egen sdambB = rowsd(ambivPOST1B ambivPOST2B ambivPOST3B ambivPOST4B) if (ambivPOST1B!=. & ambivPOST2B!=. & ambivPOST3B!=. & ambivPOST4B!=.)
sum sdambB, detail
gen ambivPOSTB = -((abs(meanambB))-2*(sdambB))
label var ambivPOSTB "AmbivPOSTalence index - DK excluded"
sum ambivPOSTB, detail // the higher the value, the higher the ambivPOSTalence
drop meanambB sdambB
*normalized index: from 0 (min ambivPOST) to 1 (max ambivPOST)
egen min_ambivPOSTB = min(ambivPOSTB)
egen max_ambivPOSTB = max(ambivPOSTB)
gen nambivPOSTB = (ambivPOSTB - min_ambivPOSTB)/(max_ambivPOSTB - min_ambivPOSTB)
label var nambivPOSTB "AmbivPOSTalence index, DK excluded, from 0 min, to 1 max"
sum nambivPOSTB, detail // USE THIS ONE
*ta nambivPOSTB if ambivPOSTB>11
drop min_ambivPOSTB max_ambivPOSTB
*standardized index
egen stambivPOSTB = std(ambivPOSTB)
label var stambivPOSTB "AmbivPOST. index DK excluded, standardized, higher values=more ambivPOST"
sum stambivPOSTB, detail // USE THIS ONE
*ta stambivPOSTB if ambivPOSTB>11


recode S21_3 (1=10) (2=9) (3=8) (4=7) (5=6) (6=5) (7=4) (8=3) (9=2) (10=1) (11=0) (else=.), gen (efficacy)



********************************************************************************
**************			  FINAL MODELS  				************************
********************************************************************************
global demo "female age i.edu4 i.unempl i.area1 evgov"
global demoapp "female age i.edu4 i.unempl i.area1 evgov i.PIDyn" // only for appendix


*********************************
*Table 1. Summary statistics
sum strongtieA01, d
sum mediumtieA01, d
sum weaktieA01, d

*correlations
pwcorr strongtieA01 mediumtieA01 weaktieA01, sig
*test of the differences
ttest strongtieA01 = mediumtieA01, unpaired unequal
ttest strongtieA01 = weaktieA01, unpaired unequal
ttest mediumtieA01 = weaktieA01, unpaired unequal


*******************
*Table 2 - Effect of network diversity on ambivalence, knowledge and turnout

set more off
eststo clear

qui logit turnoutpost c.NDindex01 knowpostdum nambivPOSTA $demo
eststo: reg nambivPOSTA c.NDindex01 $demo if e(sample)
eststo: logit knowpostdum c.NDindex01 $demo  if e(sample)
eststo: logit turnoutpost c.NDindex01 $demo  if e(sample)
eststo: logit turnoutpost c.NDindex01 knowpostdum nambivPOSTA $demo
*Panel B - weighted by FREQUENCY OF DISCUSSION
qui logit turnoutpost c.NDindexW1 knowpostdum nambivPOSTA $demo
eststo: reg nambivPOSTA c.NDindexW1 $demo  if e(sample) 
eststo: logit knowpostdum c.NDindexW1 $demo  if e(sample) 
eststo: logit turnoutpost c.NDindexW1 $demo  if e(sample) 
eststo: logit turnoutpost c.NDindexW1 knowpostdum nambivPOSTA $demo 
*Panel c - weighted by STRONG TIE DIVERSITY
qui logit turnoutpost c.NDindexW2 knowpostdum nambivPOSTA $demo 
eststo: reg nambivPOSTA c.NDindexW2 $demo if e(sample)
eststo: logit knowpostdum c.NDindexW2 $demo if e(sample)
eststo: logit turnoutpost c.NDindexW2 $demo if e(sample)
eststo: logit turnoutpost c.NDindexW2 knowpostdum nambivPOSTA $demo
esttab

******************
*Figure 2 - marginal effects based on M8 in Table 2
logit turnoutpost c.NDindexW1 knowpostdum nambivPOSTA $demo
margins, dydx(NDindexW1 knowpostdum nambivPOSTA) post
coefplot, keep (NDindexW1 knowpostdum nambivPOSTA) xline(0)

 
************
*SEM

tabulate edu4, generate(edu4_d)
tabulate unempl, generate(unempl_d)
tabulate area1, generate(area1_d)
tabulate turnoutpre2, generate (turnoutpre2_d)
tabulate frequency_discussion_post, generate (frequency_discussion_post_d)

*nb: rerun sem models with correct demographics below (now it includes government evaluation)
global demo1 "female age edu4_d2 edu4_d3 edu4_d4 unempl_d2 unempl_d3 unempl_d4 unempl_d5 unempl_d6 area1_d2 area1_d3 area1_d4 area1_d5 evgov"
*for appendix only, use demographics below
global demo1app "female age edu4_d2 edu4_d3 edu4_d4 unempl_d2 unempl_d3 unempl_d4 unempl_d5 unempl_d6 area1_d2 area1_d3 area1_d4 area1_d5 evgov PIDyn"

set more off
eststo clear

*Panel A: unweighted index
eststo: sem (knowpostdum nambivPOSTA  -> turnoutpost) (NDindex01 $demo1 -> nambivPOSTA) (NDindex01 $demo1 -> knowpostdum), ///
nocapsl stand nomeans  cformat(%4.3f) noheader
estat gof, stats(all) // SEM model fit
estat eqgof, format(%4.3f) // R2 or reliability for all variables
*Panel B: weighted by frequency
eststo: sem (knowpostdum nambivPOSTA  -> turnoutpost) (NDindexW1 $demo1 -> nambivPOSTA) (NDindexW1 $demo1 -> knowpostdum), ///
nocapsl stand nomeans  cformat(%4.3f) noheader
estat gof, stats(all)
estat eqgof, format(%4.3f)
*Panel C: weighted by strong tie diversity
eststo: sem (knowpostdum nambivPOSTA   -> turnoutpost) (NDindexW2 $demo1 -> nambivPOSTA) (NDindexW2 $demo1 -> knowpostdum), ///
nocapsl stand nomeans  cformat(%4.3f) noheader
estat gof, stats(all) 
estat eqgof, format(%4.3f)

*******************************************
***********************
*Appendix

**
*Table A1 - effect of network diversity on INTENTIONS TO TURNOUT (PRE-WAVE)
ta turnoutpre1

global demoA "female age i.edu4 i.unempl i.area1" 
global demoB "female age i.edu4 i.unempl i.area1 evgov" 

set more off
eststo clear

eststo: logit turnoutpre1 c.NDindex01 $demoA 
eststo: logit turnoutpre1 c.NDindex01 $demoB


********************
*The effect of network diversity on ambivalence, knowledge and turnout
global demoapp "female age i.edu4 i.unempl i.area1 evgov i.PIDyn" // only for appendix

*Table A2. unweighted index (+ 2 extra models with PID)
set more off
eststo clear

qui logit turnoutpost c.NDindex01 knowpostdum nambivPOSTA $demo
eststo: reg nambivPOSTA c.NDindex01 $demo if e(sample)
eststo: logit knowpostdum c.NDindex01 $demo  if e(sample)
eststo: logit turnoutpost c.NDindex01 $demo  if e(sample)
eststo: logit turnoutpost c.NDindex01 $demoapp
eststo: logit turnoutpost c.NDindex01 knowpostdum nambivPOSTA $demo
eststo: logit turnoutpost c.NDindex01 knowpostdum nambivPOSTA $demoapp

esttab using "~TableA2app.rtf", ///
b(%6.3f) se(%6.3f) starlevels(+ .1 * .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("M1")  compress noeqlines replace 

*Table A3. weighted by FREQUENCY OF DISCUSSION (+ 2 extra models with PID)
set more off
eststo clear

qui logit turnoutpost c.NDindexW1 knowpostdum nambivPOSTA $demo
eststo: reg nambivPOSTA c.NDindexW1 $demo  if e(sample) 
eststo: logit knowpostdum c.NDindexW1 $demo  if e(sample) 
eststo: logit turnoutpost c.NDindexW1 $demo  if e(sample) 
eststo: logit turnoutpost c.NDindexW1 $demoapp
eststo: logit turnoutpost c.NDindexW1 knowpostdum nambivPOSTA $demo 
eststo: logit turnoutpost c.NDindexW1 knowpostdum nambivPOSTA $demoapp 

esttab using "~TableA3app.rtf", ///
b(%6.3f) se(%6.3f) starlevels(+ .1 * .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("M1")  compress noeqlines replace 

*Table A4. weighted by STRONG-TIE DIVERSITY (+ 2 extra models with PID)
set more off
eststo clear

qui logit turnoutpost c.NDindexW2 knowpostdum nambivPOSTA $demo 
eststo: reg nambivPOSTA c.NDindexW2 $demo if e(sample)
eststo: logit knowpostdum c.NDindexW2 $demo if e(sample)
eststo: logit turnoutpost c.NDindexW2 $demo if e(sample)
eststo: logit turnoutpost c.NDindexW2 $demoapp
eststo: logit turnoutpost c.NDindexW2 knowpostdum nambivPOSTA $demo
eststo: logit turnoutpost c.NDindexW2 knowpostdum nambivPOSTA $demoapp

esttab using "~TableA4app.rtf", ///
b(%6.3f) se(%6.3f) starlevels(+ .1 * .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("M1")  compress noeqlines replace 


***
*Table A6 - differences between DK and not DK
preserve
keep if female!=. & turnoutpostWblank!=.

gen NDplusdk = NDindex01
recode NDplusdk .=2 if (S34==8 & S35==8 &S36==8)
recode NDplusdk 0/1=1
label de NDplusdk 1"ND index, not dk" 2"DK"
label values NDplusdk NDplusdk
ta NDplusdk // dk versus not dk

recode edu5 (1/3=0 "no degree/other degree/students") (4=1 "university degree") (5=0), gen(unidegree)
recode unempl (0 1 2 3 5=0) (4=1 "unemployed"), gen(unempldum)
recode D11_W9 (1/13=0 "Altro") (14=1 "No PID") (else=0), gen (PIDyn2)
recode D9 (1/11=0) (12 13=1 "no lr self placement"), gen(nolr)
recode D18_02_W9 (1=1 "talk everyday") (2/6=0), gen(highfreqdisc)

ta female NDplusdk, col chi2
ttest age, by(NDplusdk)
ta unidegree NDplusdk, col chi2
ta unempldum NDplusdk, col chi2

ta PIDyn2 NDplusdk, col chi2
ta nolr NDplusdk, col chi2
ta highfreqdisc NDplusdk, col chi2

ta turnoutpostWblank NDplusdk, col chi2
ta knowpostdum NDplusdk, col chi2
ttest nambivPOSTA, by(NDplusdk)
restore


*******************
*Table A8. Network diversity and frequency of discussion - interaction models
recode D18_02_W9 (4=0 "mai") (3=1 "ogni tanto") (2=2 "alcune volte sett") (1=3 "tuttiigiorni") (else=.), gen(freqdis)
ta freqdis

set more off
eststo clear
eststo: logit turnoutpost c.NDindex01##ib1.freqdis knowpostdum nambivPOSTA $demo
eststo: logit turnoutpost c.NDindex01##ib1.freqdis knowpostdum nambivPOSTA $demoapp 

*
*Figure A1. Marginal effects calculated on Table 8
logit turnoutpost c.NDindex01##ib1.freqdis knowpostdum nambivPOSTA $demo
margins, dydx(2.freqdis 3.freqdis) at(NDindex01=(0(0.25)1))
marginsplot, yline(0)


********************
*Table A9. Alternative measure of knowledge (pre and post combined)

*knowledge pre
tab1 S31 know2
tab1 S32 know3
gen knowpretot=(know2+know3)/2
ta knowpretot // index using only 2 items
*knowledge post
tab1 D24 knowPOST1
tab1 D25 knowPOST2
ta knowPOST01
*combined variable
gen knowprepost = .
replace knowprepost = 1 if knowPOST01==1
replace knowprepost = 0.5 if knowPOST01==0.5 & knowpretot<1
replace knowprepost = 0 if knowPOST01==0 & knowpretot==0
replace knowprepost = -0.5 if (knowPOST01==0.5 & knowpretot==1) | (knowPOST01==0 & knowpretot>0)
ta knowprepost

*Regression models with weighted ND
set more off
eststo clear
qui logit turnoutpost c.NDindexW1 knowprepost nambivPOSTA $demo
eststo: reg knowprepost c.NDindexW1 $demo  if e(sample) 
eststo: logit turnoutpost c.NDindexW1 knowprepost nambivPOSTA $demo 
esttab
