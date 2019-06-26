log using "C:\Interrogation Game Files\Replication Log.smcl", replace

cd "C:\Interrogation Game Files"
**FRAMED EXPERIMENT ANALYSIS
use "Interrogation Game.dta", clear
*session: Code identifying what session subjects participated in.
*random: (1) subjects assigned to group randomly; (0) subjects assigned to group using minimal group paradigm
*punish: (1) coercion treatment; (2) reward treatement
*period: the period of the decision 1-20
*subjectc: Code identifying individual subject 
*groupc: Code identifying subject's group
*decision: (0) Don't know; (1) Ace of Clubs; (2) Ace of Diamonds; (3) Ace of Spades; (4) Ace of Hearts
*know2: (1) subject is knowledgeable; (0) subject is ignorant
*groupstate: the group's card (1) Ace of Clubs; (2) Ace of Diamonds; (3) Ace of Spades; (4) Ace of Hearts
*right: computer guessed the card correct
*pay1: subject's payoff for the period
*risk: number of risky choices in Holt Laury (2002) task.

**SETUP STUFF
rename period actualperiod
gen period=actualperiod if actualperiod<=10
replace period=actualperiod-10 if actualperiod>10
svyset subjectc, strata(session)

**Reward First or Second?
gen reward1st=1 if punish==0 & actualperiod<11
replace reward1st=0 if reward1st==.

gen reward2nd=1 if punish==0 & actualperiod>=11
replace reward2nd=0 if reward2nd==.

**Subject Ignorant
gen ignorant=know2
recode ignorant 1=0 0=1

**Subject Decision
gen action="Right Card" if decision==groupstate
replace action="Wrong Card" if decision~=groupstate
replace action="Don't Know" if decision==0
gen rightcard=1 if action=="Right Card"
replace rightcard=0 if action~="Right Card"
gen wrongcard=1 if action=="Wrong Card"
replace wrongcard=0 if action~="Wrong Card"
gen dontknow=1 if action=="Don't Know"
replace dontknow=0 if action~="Don't Know"

gen revealanycard=1 if action!="Don't Know"
replace revealanycard=0 if action=="Don't Know"


**Truth or Lie
gen toldtruth=1 if rightcard==1 & ignorant==0
replace toldtruth=0 if rightcard==0 & ignorant==0
replace toldtruth=1 if dontknow==1 & ignorant==1
replace toldtruth=0 if dontknow==0 & ignorant==1

**Previous Period
sort subjectc actualperiod
gen lasttruth=toldtruth[_n-1] if period>1
gen lastpay=pay1[_n-1] if period>1
gen lastright=right[_n-1] if period>1

**Set Up Risk Variable
gen risk3=risk
recode risk3 0/4=1 5=0 6/10=-1

**FIGURE 1
svy: mean rightcard, over(punish)
svy: mean wrongcard, over(punish)
svy: mean dontknow, over(punish)

**FIGURE 2
tab action actualperiod if punish==1 & ignorant==0
tab action actualperiod if punish==0 & ignorant==0

tab revealanycard actualperiod if punish==1 & ignorant==1
tab revealanycard actualperiod if punish==0 & ignorant==1


**TABLE 2
probit toldtruth punish ignorant, cluster(subjectc)
estat ic
probit toldtruth i.punish##i.ignorant, cluster(subjectc)
estat ic
probit toldtruth i.punish##i.ignorant risk3 lasttruth lastright lastpay period, cluster(subjectc)
estat ic

**FIGURE 3
margins punish, at(ignorant=0 risk3=-.5375 lasttruth=.4840 lastright=.4833 lastpay=341.406 period=6)
margins punish, at(ignorant=1 risk3=-.5375 lasttruth=.4840 lastright=.4833 lastpay=341.406 period=6)

**FIGURE 4
svy: mean rightcard if ignorant==0, over(punish)
svy: mean wrongcard if ignorant==0, over(punish)
svy: mean dontknow if ignorant==0, over(punish)

svy: mean revealanycard if ignorant==1, over(punish)
svy: mean dontknow if ignorant==1, over(punish)


**UNFRAMED ANALYSIS
use "Unframed Game.dta", clear
*period: the period of the decision 1-20
*subjectc: Code identifying individual subject 
*lie: 250 equvialent of coercion; 750 equvialent of reward
*know2: (1) subject is knowledgeable; (0) subject is ignorant
*pay1: subject's payoff for the period
*risk: number of risky choices in Holt Laury (2002) task.
*blue, teal, greenknow: actions of "knowledgeable subjects"
*purple, greenignorant: actions of "ignorant subjects"

svyset subjectc
svy: mean blue if know2==1, over(lie)
svy: mean teal if know2==1, over(lie)
svy: mean greenknow if know2==1, over(lie)

svy: mean purple if know2==0, over(lie)
svy: mean greenignorant if know2==0, over(lie)

log close
