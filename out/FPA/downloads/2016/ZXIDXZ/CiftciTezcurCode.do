************************PEW DATA***************************************

**use "pew.dta"****

**Keep Egypt, Tunisia, Lebanon and Jordan


keep if COUNTRY==5 | COUNTRY==19 | COUNTRY==12 | COUNTRY==13

**muslim only

keep if Q61EGY==1 | Q61TUN==1 | Q61JOR==1 | Q61LEB==1


**************************************SUPPORT FOR DEMOCRACY**********************************************
**FIRST, CREATE A FILTER VARIABLE TO SEPARATE COMMITTED DEMOCRATS FROM INSTRUMENTALISTS
**Democracy VERSUS economy

gen democracy1=.
replace democracy1=1 if Q72==1
replace democracy1=0 if Q72==2 | Q72==8

***generate an index for support for democracy, ordered logit or logit could be used
***dummy from Q21 and Q71

recode Q21 (1=1) (2/8=0) (9=.) (.=.), gen(democracy2)
recode Q71 (1=1) (2/8=0) (9=.) (.=.), gen(democracy3)

gen SDI= democracy1 + democracy2 + democracy3




***Islam in government, For Egypt and Tunisia only 

recode Q115F (1=4) (2=3) (3=2) (4=1) (8/9=.), gen(islamgovernment)

recode Q115F (1=1) (2=1) (3=0) (4=0) (8=0) (9=.) (.=.), gen(islamgovernment_dummy)


*****************************SECULARISM***********************

**does Islam play a large role & is this good
**
**All measures are from non-secular to secular attitudes

gen secular=.
replace secular=1 if (Q62==3 | Q62==4) & (Q63==2)
replace secular=2 if (Q62==1 | Q62==2) & (Q63==1)
replace secular=3 if (Q62==1 | Q62==2 | Q62==3 | Q62==4 ) & (Q63==3)
replace secular=4 if (Q62==3 | Q62==4) & (Q63==1)
replace secular=5 if (Q62==1| Q62==2) & (Q63==2)



***********************Support for Sharia**********************************

**from non-supporters to strong Islamic law supporters

recode  Q39 (3=1) (2=2) (1=3) (4/99=.), gen(islaminlaw)



****************which country model for religion in politics****
**Asked in Tunisia and Egypt only

gen SaudiRelModel=.
replace SaudiRelModel=1 if Q97==2
replace SaudiRelModel=0 if Q97==1 | Q97==3 | Q97==8


gen Turkeyrelmodel=.
replace Turkeyrelmodel=1 if Q97==1
replace Turkeyrelmodel=0 if Q97==2 | Q97==3 | Q97==8


******which country favors democracy in the ME
**Q120A and Q120B
**Q120D Israel


gen Turkeyfavors=0
replace Turkeyfavors=1 if Q120A==1

gen Saudifavors=0
replace Saudifavors=1 if Q120B==1


gen Israelfavors=0
replace Israelfavors=1 if Q120D==1


***support for leaders

**Ahmedinejad

recode Q44A (8=3) (1=5) (2=4) (3=2) (4=1) (9=.), gen(Ahmedinejad)

recode Q44B (8=3) (1=5) (2=4) (3=2) (4=1)(9=.), gen(KingAbdullah)

recode Q44C (8=3) (1=5) (2=4) (3=2) (4=1)(9=.), gen(Erdogan)


****dummy variables, support for leaders


gen newerdogan=0
replace newerdogan=1 if Erdogan>3

gen newabdullah=0
replace newabdullah=1 if KingAbdullah >3

gen newahmed=0
replace newahmed=1 if Ahmedinejad >3



************************SUPPORT FOR ISLAMIC PARTY*****************************

**In tunisia, support for Ennahda

gen islamicparty1=0
replace islamicparty1=1 if Q164TUN==1 & COUNTRY==19
replace islamicparty1=. if (Q164TUN==9 & COUNTRY==19 ) | COUNTRY==5

**in Egypt, Freedom and Justice

gen islamicparty2=0
replace islamicparty2=1 if (Q47L==1 | Q47L==2)  & COUNTRY==5
replace islamicparty2=. if (Q47L==9 & COUNTRY==5) | COUNTRY==19

*In Egypt, Al NOUR

gen alnour=0.
replace alnour=1 if (Q47J==1 | Q47J==2)  & COUNTRY==5
replace alnour=. if (Q47J==9 & COUNTRY==5) | COUNTRY==19

**in Egypt, WASAT

gen wasat=0.
replace wasat=1 if (Q47N==1 | Q47N==2)  & COUNTRY==5
replace wasat=. if (Q47N==9 & COUNTRY==5) | COUNTRY==19




***In Egypt, any Islamic party

gen islamicparty3=0
replace islamicparty3=1 if ((Q47L==1 | Q47L==2) | (Q47J==1 | Q47J==2) | (Q47N==1 | Q47N==2)) & COUNTRY==5
replace islamicparty3=. if (Q47L==9 | Q47J==9 | Q47N ==9 & COUNTRY==5) | COUNTRY==19


**support for political islam

egen islamicparty4= rowtotal(islamicparty1 islamicparty2)
egen islamicparty5= rowtotal(islamicparty1 islamicparty3)





**Frequency of prayer

gen prayer=Q149
replace prayer=. if Q149==8 | Q149==9


***Fast

gen fasting=Q151
replace fasting=. if Q151==8 | Q151==9


***alternative coding fasting

recode Q151 (1=1) (2=3) (3=5) (4=7) (5/10=.) (.=.), gen(fasting2)

**index religisoity

gen religiosity=prayer+fasting2


***sunni, shia

gen sunni=0
replace sunni=1 if Q148==1
gen shia=0
replace shia=1 if Q148==2

***I also create a third dummy for those who refuse to identify shia or sunni and just identify as muslim

gen justmuslim=0
replace justmuslim=1 if Q148==97


***harmonized income based on quarter percentiles

gen lebincome= Q156LEB
replace lebincome=. if  Q156LEB>12
gen jorincome= Q156JOR
replace jorincome=. if  Q156JOR>17
gen egyincome= Q156EGY
replace egyincome=. if  Q156EGY>12
gen tunincome= Q156TUN
replace tunincome=. if  Q156TUN>8
xtile pctleb=lebincome, n(4)
xtile pctjor=jorincome, n(4)
xtile pctegy=egyincome, n(4)
xtile pcttun=tunincome, n(4)
tab1 pctleb pctjor pctegy pcttun
gen lowincome=0
replace lowincome=1 if (pctleb==1 |  pctjor==1 |  pctegy==1 |  pcttun==1)
gen midincome=0
replace midincome=1 if ((pctleb>1 & pctleb<4) | ( pctjor>1& pctjor<4)  | ( pctegy>1 &pctegy<4)  | ( pcttun>1 & pcttun<4))
gen highincome=0
replace highincome=1 if (pctleb==4 |  pctjor==4 |  pctegy==4 |  pcttun==4)

****education, university and above
gen education=.
replace education=1 if Q154EGY==7 | Q154EGY==6  | Q154JOR==7 | Q154LEB==8 | Q154TUN==6 | Q154TUN==5
replace education=0 if Q154EGY<6 | Q154JOR<7 | Q154LEB<8 | Q154TUN<5



**age
gen age=Q142

**female
gen female=0
replace female=1 if Q141==2


***favorable views

recode Q8A (1=1) (2=1) (3=0) (4=0) (8=0) (9=.), gen(USA)
recode Q8C (1=1) (2=1) (3=0) (4=0) (8=0) (9=.), gen(China)
recode Q8D (1=1) (2=1) (3=0) (4=0) (8=0) (9=.), gen(Iran)
recode Q8E (1=1) (2=1) (3=0) (4=0) (8=0) (9=.), gen(Russia)
recode Q8F (1=1) (2=1) (3=0) (4=0) (8=0) (9=.), gen(EU)
recode Q8T (1=1) (2=1) (3=0) (4=0) (8=0) (9=.), gen(SArabia)
recode Q8V (1=1) (2=1) (3=0) (4=0) (8=0) (9=.), gen(Turkey)


**country dummies
tab COUNTRY, gen(CN)

***Robustness
*****anti americanism models

foreach var of varlist Q54-Q58 {
recode `var' (1=0) (2=1) (3=0) (4/99=.), gen(new`var')
}

recode USA (1=0) (0=1) (.=.), gen(antiUSA)
pca newQ55 newQ54 newQ56 newQ57 newQ58 antiUSA
alpha newQ55 newQ54 newQ56 newQ57 newQ58 antiUSA

**anti americanism
gen indexanti= newQ55 + newQ54 + newQ56 + newQ57 + newQ58 + antiUSA


***anti americanism interacted with religioisty

gen test1=religiosity*indexanti



