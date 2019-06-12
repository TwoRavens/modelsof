**First need to merge in 2010 Panel Recontact Survey.  This has already been done
**to create the merged .dta file that accompanies this do file.
**Creating personality items from the '10 Recontact Study

*Extraversion
gen extra=f1j2
replace extra=. if extra <1
recode extra (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode extra (8=0) (9=1) (10=2) (11=3) (12=4) (13=5) (14=6)

gen reserved=f1j7
replace reserved=. if reserved <1
recode reserved (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6)

gen extraverted=extra+reserved

*Conscientiousness
gen consc=f1j4
replace consc=. if consc <1
recode consc (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode consc (8=0) (9=1) (10=2) (11=3) (12=4) (13=5) (14=6)

gen disorg=f1j9
replace disorg=. if disorg <1
recode disorg (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6)

gen conscientiousness=consc+disorg

*Agreeableness
gen agree=f1j8
replace agree=. if agree <1
recode agree (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode agree (8=0) (9=1) (10=2) (11=3) (12=4) (13=5) (14=6)

gen critical=f1j3
replace critical=. if critical <1
recode critical (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6)

gen agreeableness=agree+critical

*Emotional Stability
gen stable=f1j10
replace stable=. if stable <1
recode stable (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode stable (8=0) (9=1) (10=2) (11=3) (12=4) (13=5) (14=6)

gen upset=f1j5
replace upset=. if upset <1
recode upset (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6)

gen emostable=stable+upset

*Openness to experience
gen open=f1j6
replace open=. if open <1
recode open (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode open (8=0) (9=1) (10=2) (11=3) (12=4) (13=5) (14=6)

gen conv=f1j11
replace conv=. if conv <1
recode conv (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6)

gen openness=open+conv

**Creating the Disagreement Items from the 08-09 Network battery

*****************************************************
******************************************************
*political network variables**************************
******************************************************

*note: the panel didn't ask about frequency of discussion in the ego-centric network
*this "how many days a week do ou discuss politics with family, friends, etc." is probably our best proxy
rename W10H2 disweek

*respondents were asked to name up to 8 initials; these are restricted, so we only know about the first three
*respondents were given a yes/no before naming initials, so people who said "no" can be considered 0s
*the network battery appears in wave 9

*the first items just ask about closeness with each named discussant 

recode W9ZD4_1 (1/5=1), gen(valid1)
recode W9ZD4_2 (1/5=1), gen(valid2)
recode W9ZD4_3 (1/5=1), gen(valid3)


*this creates recode an indicator for whether the person actually got asked the discussion questions 
recode W9ZD1 (1=1) (2=1), gen(discvalid)

gen netsize=.
replace netsize=0 if discvalid==1
replace netsize=1 if valid1==1
replace netsize=2 if valid2==1
replace netsize=3 if valid3==1
label var netsize "size of Rs network"

*this creates a measure of network size, that is valid (as not all people got the discussion questions)

*let's create an average disagreement measure for the network 
**note: this is not based on partisanship, but on "how different the opinions are" from the R

*these flip and rename this difference measure for each discussant 

gen W9ZD9_1R=W9ZD9_1 if W9ZD9_1>0
gen W9ZD9_2R=W9ZD9_2 if W9ZD9_2>0
gen W9ZD9_3R=W9ZD9_3 if W9ZD9_3>0

gen disdisc1=6-W9ZD9_1R
gen disdisc2=6-W9ZD9_2R
gen disdisc3=6-W9ZD9_3R


recode disdisc1 (1=0) (2=.25) (3=.5) (4=.75) (5=1)
recode disdisc2 (1=0) (2=.25) (3=.5) (4=.75) (5=1)
recode disdisc3 (1=0) (2=.25) (3=.5) (4=.75) (5=1)

*now, let's create a network average, with 0's included
gen avgdis=. 
replace avgdis=0 if netsize==0
replace avgdis=disdisc1 if netsize==1
replace avgdis=(disdisc1+disdisc2)/2 if netsize==2
replace avgdis=(disdisc1+disdisc2+disdisc3)/3 if netsize==3
label var avgdis "average level of opinion difference in Rs network"

*now, let's create a network average, with 0's dropped
gen avgdisno0=. 
replace avgdisno0=disdisc1 if netsize==1
replace avgdisno0=(disdisc1+disdisc2)/2 if netsize==2
replace avgdisno0=(disdisc1+disdisc2+disdisc3)/3 if netsize==3
label var avgdisno0 "average level of opinion difference in Rs network"

*this isn't exactly political expertise, but let's create a network level measure of formal education 

*let's start by renaming each of these:
rename W9ZD23_1 formed1
rename W9ZD23_2 formed2
rename W9ZD23_3 formed3

gen formedavg=.
replace formedavg=0 if netsize==0
replace formedavg=formed1 if netsize==1
replace formedavg=(formed1+formed2)/2 if netsize==2
replace formedavg=(formed1+formed2+formed3)/3 if netsize==3
label var formedavg "average level of formal education in Rs network"


*Coding agreement/disagreement between R and alters 
gen pidw9=DER08W9
recode pidw9 (0/2=1) (3=2) (4/6=3)

*this makes R dem
****Demographics from the  08-09 Panel***

recode DER01 (1=1) (2=0), gen(male)
rename DER02 age2
rename DER04 nonwhite
replace nonwhite=. if nonwhite <1
recode nonwhite (1=0) (2 3 4=1)
rename DER05 educ1to5
replace educ1to5=. if educ1to5 <1
rename DER06 income
replace income=. if income <1



***************************************************************************
********Controls***********************************************************
***************************************************************************

*Wave 9 Strength of PID
gen spid9=pidw9
replace spid=. if spid <0
recode spid (3=7) (2 4=8) (1 5=9) (0 6=10)
recode spid (7=0) (8=1) (9=2) (10=3)

*General Political interest, interviewer assessment
gen interest=RQPOL
replace interest=. if interest <1

*Creating measure of political knowledge, it's from wave 11


gen know1=W11WV1
replace know1=. if know1 <1
recode know1 (2 3 4=0)

gen know2=W11WV2
replace know2=. if know2 <1
recode know2 (2 3 4=0)

gen know3=W11WV3
replace know3=. if know3 <1
recode know3 (2 3 4 5=0)

gen know4=W11WV4
replace know4=. if know4 <1
recode know4 (2 3 4 5=0)

gen know5=W11WV5
replace know5=. if know5 <1
recode know5 (2 3 4=0)

gen know6=W11WV6
replace know6=. if know6 <1
recode know6 (1 3 4=0) (2=1)

gen know7=W11WV7
recode know7 (3 4 6 7 8 40 44=0) (1=0) (2=1)
replace know7=. if know7 <0

gen know8=W11WV8
replace know8=. if know8 <0
recode know8 (0 1 2 3 4 5 7 8 9 10 12 15 16 20 30 40 44=0) (6=1)

gen know9=W11WV9
replace know9=. if know9 <0
recode know9 (0 1 3 4 5 6 7 8 9 10 11 12 20 44 50 52 54 100 222=0) (2=1)

gen know10=W11WV10
replace know10=. if know10 <0
recode know10 (0 1 3 4 5 6 7 8 9 10 12 20 44 68 100=0) (2=1)

gen know11=W11WV11
replace know11=. if know11 <0
recode know11 (1 2=0) (3=1)

gen know12=W11WV12
replace know12=. if know12 <0
recode know12 (1 3 4=0) (2=1)

*Create 2 measures of knowledge because the N drops a lot for those who 
* who answered questions 6-12.  So I have 2 measures.
gen knowledgeobs=know1+know2+know3+know4+know5+know6
gen knowledge=know1+know2+know3+know4+know5+know6+know7+know8+know9+know10+know11+know12



***********************************************************
********Information Seeking DV's***************************
***********************************************************

*Wave 9 interest in information about government and politics
gen govinfo9=W9H1
replace govinfo9=. if govinfo9 <1
recode govinfo9 (4=6) (3=7) (2=8) (1=9)
recode govinfo9 (5=0) (6=1) (7=2) (8=3) (9=4)

gen govinfo10=W10H1
replace govinfo10=. if govinfo10 <1
recode govinfo10 (4=6) (3=7) (2=8) (1=9)
recode govinfo10 (5=0) (6=1) (7=2) (8=3) (9=4)

*Generating Wave 10 TV News Consumption, number of days 
gen tvnews10=W10F1
replace tvnews10=. if  tvnews10 <0

*Generating Wave 10 Internet News, number of days
gen netnews10=W10F3
replace netnews10=. if netnews10 <0

*Generating Wave 10 Print News consumption, number of days
gen printnews10=W10F4
replace printnews10=. if printnews10 <0




******************************************************************************
***********Models in paper****************************************************
******************************************************************************

*Table 4
reg govinfo10 avgdis spid9 knowledgeobs educ1to5 male age income 
reg govinfo10 c.extraverted c.avgdis c.avgdis#c.extraverted c.spid9 c.knowledgeobs c.educ1to5 c.male c.age c.income 
	margins, dydx(avgdis) at (extraverted=(0(1)12))	
reg govinfo10 c.openness c.avgdis c.avgdis#c.openness c.spid9 c.knowledgeobs c.educ1to5 c.male c.age c.income 
	margins, dydx(avgdis) at (openness=(0(1)12))	
reg govinfo10 c.agreeableness c.avgdis c.avgdis#c.agreeableness c.spid9 c.knowledgeobs c.educ1to5 c.male c.age c.income 
	margins, dydx(avgdis) at (agreeableness=(0(1)12))


******************************************************************************
*********Models in Online SI Document*****************************************
******************************************************************************

*Replication of Table 4 with Full Personality Battery
reg govinfo10 avgdis spid9 knowledgeobs educ1to5 male age income
reg govinfo10 c.extraverted c.openness c.agreeableness c.emostable c.conscientiousness c.avgdis c.extraverted#c.avgdis c.spid9 c.knowledgeobs c.educ1to5 c.male c.age c.income
	margins, dydx(avgdis) at (extraverted=(0(1)12)) 
reg govinfo10 c.extraverted c.openness c.agreeableness c.emostable c.conscientiousness c.avgdis c.openness#c.avgdis c.spid9 c.knowledgeobs c.educ1to5 c.male c.age c.income
	margins, dydx(avgdis) at (openness=(0(1)12)) 
reg govinfo10 c.extraverted c.openness c.agreeableness c.emostable c.conscientiousness c.avgdis c.agreeableness#c.avgdis c.spid9 c.knowledgeobs c.educ1to5 c.male c.age c.income
	margins, dydx(avgdis) at (agreeableness=(0(1)12)) 

*SI Table 3
reg netnews avgdis spid9 knowledgeobs educ1to5 male age income 
reg netnews c.extraverted c.avgdis c.extraverted#c.avgdis c.spid9 c.knowledgeobs c.educ1to5 c.male c.age c.income
	margins, dydx(avgdis) at (extraverted=(0(1)12)) 
reg netnews c.openness c.avgdis c.openness#c.avgdis c.spid9 c.knowledgeobs c.educ1to5 c.male c.age c.income
	margins, dydx(avgdis) at (openness=(0(1)12)) 
reg netnews c.agreeableness c.avgdis c.agreeableness#c.avgdis c.spid9 c.knowledgeobs c.educ1to5 c.male c.age c.income
	margins, dydx(avgdis) at (agreeableness=(0(1)12)) 

*SI Table 4
reg netnews avgdis spid9 knowledgeobs educ1to5 male age income
reg netnews c.extraverted c.openness c.agreeableness c.emostable c.conscientiousness c.avgdis c.extraverted#c.avgdis c.spid9 c.knowledgeobs c.educ1to5 c.male c.age c.income
	margins, dydx(avgdis) at (extraverted=(0(1)12)) 
reg netnews c.extraverted c.openness c.agreeableness c.emostable c.conscientiousness c.avgdis c.openness#c.avgdis c.spid9 c.knowledgeobs c.educ1to5 c.male c.age c.income
	margins, dydx(avgdis) at (openness=(0(1)12)) 
reg netnews c.extraverted c.openness c.agreeableness c.emostable c.conscientiousness c.avgdis c.agreeableness#c.avgdis c.spid9 c.knowledgeobs c.educ1to5 c.male c.age c.income
	margins, dydx(avgdis) at (agreeableness=(0(1)12)) 

*SI Table 5
reg avgdis extraverted spid9 knowledgeobs educ1to5 male age income netsize
reg avgdis openness spid9 knowledgeobs educ1to5 male age income netsize
reg avgdis agreeableness spid9 knowledgeobs educ1to5 male age income netsize




