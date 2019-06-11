set more off
*cd "C:\Users\ryanb\Dropbox\Gender Influence\PSRM\Final\Replication Stuff"
*cd "C:\Users\John\Dropbox\Gender Influence\PSRM\Final\Replication Stuff"


log using "PSRM Replication.smcl", replace

use "FSU and Hamburg.dta", clear
merge m:1 subid using "All Survey.dta"

**Grouping Variables**
gen sessiongroup=session*10+electorate
gen election=session*10000+electorate*100+period

replace alter=. if alter>7

gen alterid=session*100+electorate*10+alter

**FEMALE & PERSONALITY VARIABLES
gen female=gender
recode female 2=0

**Recoding Key Variables
recode turnout 5=0
gen avote=vote
recode avote 1=1 5=0

**Code Ex Ante Conflict
gen conflict=0 if ideal==1 & alter==2
replace conflict=0.069 if ideal==1 & alter==3
replace conflict=.336 if ideal==1 & alter==4
replace conflict=.703 if ideal==1 & alter==5
replace conflict=0.837 if ideal==1 & alter==6
replace conflict=0.854 if ideal==1 & alter==7

replace conflict=0 if ideal==2 & alter==1
replace conflict=0.052 if ideal==2 & alter==3
replace conflict=0.319 if ideal==2 & alter==4
replace conflict=0.686 if ideal==2 & alter==5
replace conflict=0.821 if ideal==2 & alter==6
replace conflict=0.837 if ideal==2 & alter==7

replace conflict=0.069 if ideal==3 & alter==1
replace conflict=0.052 if ideal==3 & alter==2
replace conflict=0.184 if ideal==3 & alter==4
replace conflict=0.551 if ideal==3 & alter==5
replace conflict=0.686 if ideal==3 & alter==6
replace conflict=0.703 if ideal==3 & alter==7

replace conflict=.336 if ideal==4 & alter==1
replace conflict=.319 if ideal==4 & alter==2
replace conflict=.184 if ideal==4 & alter==3
replace conflict=.184 if ideal==4 & alter==5
replace conflict=.319 if ideal==4 & alter==6
replace conflict=.336 if ideal==4 & alter==7

replace conflict=0.703 if ideal==5 & alter==1
replace conflict=0.686 if ideal==5 & alter==2
replace conflict=0.551 if ideal==5 & alter==3
replace conflict=0.184 if ideal==5 & alter==4
replace conflict=0.052 if ideal==5 & alter==6
replace conflict=0.069 if ideal==5 & alter==7

replace conflict=0.837 if ideal==6 & alter==1
replace conflict=0.821 if ideal==6 & alter==2
replace conflict=0.686 if ideal==6 & alter==3
replace conflict=0.319 if ideal==6 & alter==4
replace conflict=0.052 if ideal==6 & alter==5
replace conflict=0.000 if ideal==6 & alter==7

replace conflict=0.854 if ideal==7 & alter==1
replace conflict=0.837 if ideal==7 & alter==2
replace conflict=0.703 if ideal==7 & alter==3
replace conflict=0.336 if ideal==7 & alter==4
replace conflict=0.069 if ideal==7 & alter==5
replace conflict=0.000 if ideal==7 & alter==6

gen conflictcat=0 if conflict<.2
replace conflictcat=1 if conflict>.2 & conflict<.4
replace conflictcat=2 if conflict>.4 & conflict<.8
replace conflictcat=3 if conflict>.8
replace conflictcat=. if conflict==.

**Right Signal and Initial Choice

gen initialcorrect=1 if initialchoice==1 & abs(canda-ideal)<abs(candb-ideal)
replace initialcorrect=1 if initialchoice==5 & abs(canda-ideal)>abs(candb-ideal)
replace initialcorrect=0 if initialchoice==5 & abs(canda-ideal)<abs(candb-ideal)
replace initialcorrect=0 if initialchoice==1 & abs(canda-ideal)>abs(candb-ideal)
replace initialcorrect=1 if abs(canda-ideal)==abs(candb-ideal)

gen altertold=rec1 if informed==0 & firstego==1
replace altertold=rec2 if informed==0 & firstego==0

gen altercorrect=1 if altertold==1  & abs(canda-ideal)<abs(candb-ideal)
replace altercorrect=1 if altertold==5  & abs(canda-ideal)>abs(candb-ideal)
replace altercorrect=0 if altertold==5  & abs(canda-ideal)<abs(candb-ideal)
replace altercorrect=0 if altertold==1  & abs(canda-ideal)>abs(candb-ideal)
replace altercorrect=1 if abs(canda-ideal)==abs(candb-ideal)


gen bothright=1 if initialcorrect==1 & altercorrect==1
replace bothright=0 if initialcorrect==0 & altercorrect==1
replace bothright=0 if initialcorrect==1 & altercorrect==0
replace bothright=0 if initialcorrect==0 & altercorrect==0

gen onlyinitialright=0 if initialcorrect==1 & altercorrect==1
replace onlyinitialright=0 if initialcorrect==0 & altercorrect==1
replace onlyinitialright=1 if initialcorrect==1 & altercorrect==0
replace onlyinitialright=0 if initialcorrect==0 & altercorrect==0

gen onlysignalright=0 if initialcorrect==1 & altercorrect==1
replace onlysignalright=1 if initialcorrect==0 & altercorrect==1
replace onlysignalright=0 if initialcorrect==1 & altercorrect==0
replace onlysignalright=0 if initialcorrect==0 & altercorrect==0

gen bothwrong=0 if initialcorrect==1 & altercorrect==1
replace bothwrong=0 if initialcorrect==0 & altercorrect==1
replace bothwrong=0 if initialcorrect==1 & altercorrect==0
replace bothwrong=1 if initialcorrect==0 & altercorrect==0

gen samesignal=1 if altertold==initialchoice
replace samesignal=0 if altertold!=initialchoice
replace samesignal=. if altertold==.
replace samesignal=. if initialchoice==.

**Follow Alter's Recommendation
gen followalter=1 if vote==altertold
replace followalter=0 if vote!=altertold
replace followalter=. if altertold==.


**Correct Vote
gen finalcorrect=1 if vote==1 & abs(canda-ideal)<abs(candb-ideal)
replace finalcorrect=1 if vote==5 & abs(canda-ideal)>abs(candb-ideal)
replace finalcorrect=0 if vote==5 & abs(canda-ideal)<abs(candb-ideal)
replace finalcorrect=0 if vote==1 & abs(canda-ideal)>abs(candb-ideal)
replace finalcorrect=1 if abs(canda-ideal)==abs(candb-ideal)

**EX ANTE BEHAVIORS**
gen heuristicpay=.
replace heuristicpay=apay-25 if ideal==1
replace heuristicpay=apay-25 if ideal==2
replace heuristicpay=apay-25 if ideal==3
replace heuristicpay=(apay+bpay)/2 if ideal==4
replace heuristicpay=bpay-25 if ideal==5
replace heuristicpay=bpay-25 if ideal==6
replace heuristicpay=bpay-25 if ideal==7


gen heuristicpay2=.
replace heuristicpay2=apay-25 if ideal==1 & conflict<.5 & altertold==1
replace heuristicpay2=apay-25 if ideal==2 & conflict<.5 & altertold==1
replace heuristicpay2=apay-25 if ideal==3 & conflict<.5 & altertold==1
replace heuristicpay2=bpay-25 if ideal==1 & conflict<.5 & altertold==5
replace heuristicpay2=bpay-25 if ideal==2 & conflict<.5 & altertold==5
replace heuristicpay2=bpay-25 if ideal==3 & conflict<.5 & altertold==5
replace heuristicpay2=(apay+bpay)/2 if ideal==4
replace heuristicpay2=apay-25 if ideal==5 & conflict<.5 & altertold==1
replace heuristicpay2=apay-25 if ideal==6 & conflict<.5 & altertold==1
replace heuristicpay2=apay-25 if ideal==7 & conflict<.5 & altertold==1
replace heuristicpay2=bpay-25 if ideal==5 & conflict<.5 & altertold==5
replace heuristicpay2=bpay-25 if ideal==6 & conflict<.5 & altertold==5
replace heuristicpay2=bpay-25 if ideal==7 & conflict<.5 & altertold==5

replace heuristicpay2=apay-25 if ideal==1 & conflict>=.5
replace heuristicpay2=apay-25 if ideal==2 & conflict>=.5
replace heuristicpay2=apay-25 if ideal==3 & conflict>=.5
replace heuristicpay2=bpay-25 if ideal==5 & conflict>=.5
replace heuristicpay2=bpay-25 if ideal==6 & conflict>=.5
replace heuristicpay2=bpay-25 if ideal==7 & conflict>=.5


gen decisionpay=apay-25 if turnout==1 & avote==1
replace decisionpay=bpay-25 if turnout==1 & avote==0
replace decisionpay=(apay+bpay)/2 if turnout==0

gen vsexante=decisionpay-heuristicpay
gen vsexante2=decisionpay-heuristicpay2


**Figure 2 Values
svyset subid, strata(sessiongroup)
svy: mean bothright, over(conflictcat)
svy: mean onlyinitialright, over(conflictcat)
svy: mean onlysignalright, over(conflictcat)
svy: mean bothwrong, over(conflictcat)

**Table 1
logit followalter i.female c.conflict i.samesignal i.hamburg c.period, cluster(subid)
estat ic
logit followalter i.female##c.conflict##i.samesignal i.hamburg c.period, cluster(subid)
estat ic
*Figure 3 Values
margins, dydx(female) at(conflict=0.000 samesignal=0)
margins, dydx(female) at(conflict=0.052 samesignal=0)
margins, dydx(female) at(conflict=0.184 samesignal=0)
margins, dydx(female) at(conflict=0.319 samesignal=0)
margins, dydx(female) at(conflict=0.336 samesignal=0)
margins, dydx(female) at(conflict=0.551 samesignal=0)
margins, dydx(female) at(conflict=0.686 samesignal=0)
margins, dydx(female) at(conflict=0.703 samesignal=0)
margins, dydx(female) at(conflict=0.821 samesignal=0)
margins, dydx(female) at(conflict=0.837 samesignal=0)
margins, dydx(female) at(conflict=0.854 samesignal=0)

margins, dydx(female) at(conflict=0.000 samesignal=1)
margins, dydx(female) at(conflict=0.052 samesignal=1)
margins, dydx(female) at(conflict=0.184 samesignal=1)
margins, dydx(female) at(conflict=0.319 samesignal=1)
margins, dydx(female) at(conflict=0.336 samesignal=1)
margins, dydx(female) at(conflict=0.551 samesignal=1)
margins, dydx(female) at(conflict=0.686 samesignal=1)
margins, dydx(female) at(conflict=0.703 samesignal=1)
margins, dydx(female) at(conflict=0.821 samesignal=1)
margins, dydx(female) at(conflict=0.837 samesignal=1)
margins, dydx(female) at(conflict=0.854 samesignal=1)

**Table 2
logit finalcorrect i.female##c.conflict hamburg period, cluster(subid)
estat ic
*Figure 4 Values
margins, dydx(female) at(conflict=0.000)
margins, dydx(female) at(conflict=0.052)
margins, dydx(female) at(conflict=0.184)
margins, dydx(female) at(conflict=0.319)
margins, dydx(female) at(conflict=0.336)
margins, dydx(female) at(conflict=0.551)
margins, dydx(female) at(conflict=0.686)
margins, dydx(female) at(conflict=0.703)
margins, dydx(female) at(conflict=0.821)
margins, dydx(female) at(conflict=0.837)
margins, dydx(female) at(conflict=0.854)

**Appendix 4 Figure 2 Bars 3-6
svy: mean turnout if informed==1, over(female)
test [turnout]0=[turnout]1
svy: mean turnout if informed==0, over(female)
test [turnout]0=[turnout]1


**Appendix 5 Table 1
*Credible Messenger
regr vsexante2 i.female##c.conflict hamburg period if informed==0, cluster(subid)
*Ignore Signal
regr vsexante i.female##c.conflict hamburg period if informed==0, cluster(subid)


**Apendix 5 Figure 3 Values
*Credible Messenger
regr vsexante2 i.female##c.conflict hamburg period if informed==0, cluster(subid)
margins, dydx(female) at(conflict=0.000)
margins, dydx(female) at(conflict=0.052)
margins, dydx(female) at(conflict=0.184)
margins, dydx(female) at(conflict=0.319)
margins, dydx(female) at(conflict=0.336)
margins, dydx(female) at(conflict=0.551)
margins, dydx(female) at(conflict=0.686)
margins, dydx(female) at(conflict=0.703)
margins, dydx(female) at(conflict=0.821)
margins, dydx(female) at(conflict=0.837)
margins, dydx(female) at(conflict=0.854)
*Ignore Signal
regr vsexante i.female##c.conflict hamburg period if informed==0, cluster(subid)
margins, dydx(female) at(conflict=0.000)
margins, dydx(female) at(conflict=0.052)
margins, dydx(female) at(conflict=0.184)
margins, dydx(female) at(conflict=0.319)
margins, dydx(female) at(conflict=0.336)
margins, dydx(female) at(conflict=0.551)
margins, dydx(female) at(conflict=0.686)
margins, dydx(female) at(conflict=0.703)
margins, dydx(female) at(conflict=0.821)
margins, dydx(female) at(conflict=0.837)
margins, dydx(female) at(conflict=0.854)

**Apendix 5 Figure 4 Values
*Credible Messenger
regr vsexante2 i.female##c.conflict hamburg period if informed==0, cluster(subid)
margins female, at(conflict=0.000)
margins female, at(conflict=0.052)
margins female, at(conflict=0.184)
margins female, at(conflict=0.319)
margins female, at(conflict=0.336)
margins female, at(conflict=0.551)
margins female, at(conflict=0.686)
margins female, at(conflict=0.703)
margins female, at(conflict=0.821)
margins female, at(conflict=0.837)
margins female, at(conflict=0.854)
*Ignore Signal
regr vsexante i.female##c.conflict hamburg period if informed==0, cluster(subid)
margins female, at(conflict=0.000)
margins female, at(conflict=0.052)
margins female, at(conflict=0.184)
margins female, at(conflict=0.319)
margins female, at(conflict=0.336)
margins female, at(conflict=0.551)
margins female, at(conflict=0.686)
margins female, at(conflict=0.703)
margins female, at(conflict=0.821)
margins female, at(conflict=0.837)
margins female, at(conflict=0.854)



**Coding for Timing
recode timeokinitialchoiceok 31/99999999999999=.
recode timeokinfosendok 31/99999999999999=.
recode timeokfinalchoiceok 31/99999999999999=.
recode timeokactionok 31/99999999999999=.
recode timeokpayoffok 31/99999999999999=.

replace timeokinitialchoiceok=30-timeokinitialchoiceok
replace timeokinfosendok=30-timeokinfosendok
replace timeokfinalchoiceok=30-timeokfinalchoiceok
replace timeokactionok=30-timeokactionok
replace timeokpayoffok=30-timeokpayoffok

collapse (max) timeokinitialchoiceok timeokinfosendok timeokfinalchoiceok timeokactionok timeokpayoffok (mean) hamburg period, by(election)

gen totaltime=timeokinitialchoiceok+timeokinfosendok+timeokfinalchoiceok+timeokactionok+timeokpayoffok


**Appendix 2 Figure 1 Values
mean totaltime, over(period)
mean totaltime if hamburg==0, over(period)
mean totaltime if hamburg==1, over(period)

**Coding for Truthful Signals
use "FSU and Hamburg.dta", clear
merge m:1 subid using "All Survey.dta"
drop _merge
save "Truth Temp.dta", replace
append using "Truth Temp.dta", generate(marker)
drop alter

**Grouping Variables**
gen sessiongroup=session*10+electorate
gen election=session*10000+electorate*100+period
gen subperiod=subid*100+period

**FEMALE & PERSONALITY VARIABLES
gen female=gender
recode female 2=0

**Generating Alter Info
gen alter=send1 if marker==1
replace alter=send2 if marker==0

gen didrec=suggest1 if marker==1
replace didrec=suggest2 if marker==0
recode didrec 0=.

**Truthful Signal
gen froma=abs(alter-candamid) if candaambig==1
replace froma=abs(alter-canda) if candaambig==2
gen fromb=abs(alter-candbmid) if candbambig==1
replace fromb=abs(alter-candb) if candbambig==2

gen senderfroma=abs(ideal-candamid) if candaambig==1
replace senderfroma=abs(ideal-canda) if candaambig==2
gen senderfromb=abs(ideal-candbmid) if candbambig==1
replace senderfromb=abs(ideal-candb) if candbambig==2


gen prefersame=1 if froma<fromb & senderfroma<senderfromb
replace prefersame=1 if froma>fromb & senderfroma>senderfromb
replace prefersame=0 if froma>fromb & senderfroma<senderfromb
replace prefersame=0 if froma<fromb & senderfroma>senderfromb
replace prefersame=1 if froma==fromb
replace prefersame=1 if senderfroma==senderfromb


gen toldtruth=1 if didrec==1 & froma<fromb
replace toldtruth=1 if didrec==5 & froma>fromb
replace toldtruth=0 if didrec==5 & froma<fromb
replace toldtruth=0 if didrec==1 & froma>fromb
replace toldtruth=1 if froma==fromb
replace toldtruth=. if didrec==.

*Appendix 4 Figure 2 Values Columns 1 and 2
svyset subid, strata(sessiongroup)
svy: mean toldtruth if prefersame==0, over(female)
test [toldtruth]0=[toldtruth]1

*Appendix 8
use "Correct Vote PSRM Treatment.dta", clear
gen subid=session*100+subject
merge m:1 subid using "Gender.dta"

**Vote**
gen apay=adamspublic+partybonus if party==1
replace apay=adamspublic+partybonus if party==2
replace apay=adamspublic-partybonus if party==3

gen bpay=batespublic+partybonus if party==3
replace bpay=batespublic+partybonus if party==2
replace bpay=batespublic-partybonus if party==1

gen apayguess=adamsguess1+partybonus if party==1
replace apayguess=adamsguess1+partybonus if party==2
replace apayguess=adamsguess1-partybonus if party==3

gen bpayguess=batesguess1+partybonus if party==3
replace bpayguess=batesguess1+partybonus if party==2
replace bpayguess=batesguess1-partybonus if party==1

gen guessdiff=apayguess-bpayguess

gen abspaydiff=abs(apay-bpay)
gen paydiff=apay-bpay


gen initialvote="Tie" if apayguess==bpayguess
replace initialvote="A" if apayguess>bpayguess
replace initialvote="B" if apayguess<bpayguess

gen shouldvote="Tie" if apay==bpay
replace shouldvote="A" if apay>bpay
replace shouldvote="B" if apay<bpay

gen correctvote=1 if shouldvote=="A" & vote==1
replace correctvote=1 if shouldvote=="B" & vote==0
replace correctvote=0 if shouldvote=="A" & vote==0
replace correctvote=0 if shouldvote=="B" & vote==1
replace correctvote=1 if shouldvote=="Tie"

gen initialcorrect=1 if shouldvote=="A" & initialvote=="A"
replace initialcorrect=1 if shouldvote=="B" & initialvote=="B"
replace initialcorrect=0 if shouldvote=="A" & initialvote=="B"
replace initialcorrect=0 if shouldvote=="B" & initialvote=="A"
replace initialcorrect=0 if initialvote=="Tie"
replace initialcorrect=1 if shouldvote=="Tie"


**Gender
gen female=gender
recode female 2=0

svyset subid
svy: mean initialcorrect if party!=2 & info>0
svy: mean initialcorrect if party!=2 & info>0, over(female)

svy: mean correctvote  if party!=2 & info>0
svy: mean correctvote if party!=2 & info>0, over(female)


log close

