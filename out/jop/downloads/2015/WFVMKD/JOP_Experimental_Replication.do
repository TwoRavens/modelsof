***************************************************************
****This Experiment 2 with the non-turk participants dropped***
****so it just comprises the turk experiment from Sept 2011****
***************************************************************

***Generating Personality Measures*****
***I reverse code on of the two items so they are in the same direction 
***and sum the two.

*Extraversion
replace extroverted=. if extroverted==0
replace reserved=. if reserved==0
recode reserved (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode reserved (8=1) (9=2) (10=3) (11=4) (12=5) (13=6) (14=7)
gen extraversion=extroverted+reserved
*Emotional Stability
replace calm=. if calm==0
replace anxious=. if anxious==0
recode anxious (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode anxious (8=1) (9=2) (10=3) (11=4) (12=5) (13=6) (14=7)
gen emostable=calm+anxious
*Openness
replace open=. if open==0
replace conventional=. if conventional==0
recode conventional (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode conventional (8=1) (9=2) (10=3) (11=4) (12=5) (13=6) (14=7)
gen openness=open+conventional
*Conscientiousness
replace dependable=. if dependable==0
replace disorganized=. if disorganized==0
recode disorganized (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode disorganized (8=1) (9=2) (10=3) (11=4) (12=5) (13=6) (14=7)
gen conscientious=dependable+disorganized
*Agreeableness
replace sympathetic=. if sympathetic==0
replace critical=. if critical==0
recode critical (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode critical (8=1) (9=2) (10=3) (11=4) (12=5) (13=6) (14=7)
gen agreeable=sympathetic+critical

*Splitting the Personality Items at the mean for the purpose of t testing selection effects

gen agreeablesplit=.
replace agreeablesplit=0 if agreeable<10.51
replace agreeablesplit=1 if agreeable>10.51

gen opennesssplit=.
replace opennesssplit=0 if openness<10.93
replace opennesssplit=1 if openness>10.93

gen extraversionsplit=.
replace extraversionsplit=0 if extraversion<7.66
replace extraversionsplit=1 if extraversion>7.66

*****Recoding Personality Items so that all have 0 for the minimum value****

gen extraversion0=extraversion-2
gen emostable0=emostable-2
gen openness0=openness-2
gen conscientious0=conscientious-2
gen agreeable0=agreeable-2

*Generating Conditions

gen disagreecond=.
replace disagreecond=1 if condition==3
replace disagreecond=0 if condition==1 
replace disagreecond=0 if condition==2

gen discondextra=disagreecond*extraversion0
gen discondopen=disagreecond*openness0
gen discondagree=disagreecond*agreeable0

gen agreecond=.
replace agreecond=1 if condition==2
replace agreecond=0 if condition==1 
replace agreecond=0 if condition==3

*Generating Ordinal Disagreement Condition
gen disagreeordinal=.
replace disagreeordinal=0 if condition==2
replace disagreeordinal=1 if condition==1
replace disagreeordinal=2 if condition==3

*Generating Continuous Disagreement Measure
gen disagreecont=.
replace disagreecont=0 if condition==2 & disagree_freq==4
replace disagreecont=1 if condition==2 & disagree_freq==3
replace disagreecont=2 if condition==2 & disagree_freq==2
replace disagreecont=3 if condition==2 & disagree_freq==1
replace disagreecont=4 if condition==1
replace disagreecont=5 if condition==3 & disagree_freq==1
replace disagreecont=6 if condition==3 & disagree_freq==2
replace disagreecont=7 if condition==3 & disagree_freq==3
replace disagreecont=8 if condition==3 & disagree_freq==4

gen discontextra=disagreecont*extraversion0
gen discontopen=disagreecont*openness0
gen discontagree=disagreecont*agreeable0

gen disagreecondfreq=.
replace disagreecondfreq=1 if condition==3 & disagree_freq==1
replace disagreecondfreq=2 if condition==3 & disagree_freq==2
replace disagreecondfreq=3 if condition==3 & disagree_freq==3
replace disagreecondfreq=4 if condition==3 & disagree_freq==4

***Personalty X Treatment Interactions

gen extradisbefore=extraversion0*disagreebefore
gen emostdisbefore=emostable0*disagreebefore
gen opendisbefore=openness0*disagreebefore
gen consdisbefore=conscientious0*disagreebefore
gen agreedisbefore=agreeable0*disagreebefore

gen extraagreebefore=extraversion0*agreebefore
gen emostagreebefore=emostable0*agreebefore
gen openagreebefore=openness0*agreebefore
gen consagreebefore=conscientious0*agreebefore
gen agreeagreebefore=agreeable0*agreebefore

gen extradisord=extraversion0*disagreeordinal
gen opendisord=openness0*disagreeordinal
gen agreedisord=agreeable0*disagreeordinal

***Other Conrols*****

*Education
gen educ=education
replace educ=. if educ==0

*Strength of Partisanship
gen spid=strength

*Party ID
replace party_id=. if party_id==0

*Age
replace age=. if age==0

*Political Knowledge
gen knowledge=pk

*Dropping extreme observations on depth of search DV

gen depth3=. 
replace depth3=depth 
replace depth3=. if depth<10 | depth==150


***************************************************************
****Models in Paper********************************************
***************************************************************

*Table 1

sum depth3 if Exp==0

sum extraversion0 if condition==1
sum extraversion0 if condition==2
sum extraversion0 if condition==3
anova extraversion0 condition 

sum openness0 if condition==1
sum openness0 if condition==2
sum openness0 if condition==3
anova openness0 condition 

sum agreeable0 if condition==1
sum agreeable0 if condition==2
sum agreeable0 if condition==3
anova agreeable0 condition 

sum educ if condition==1
sum educ if condition==2
sum educ if condition==3
anova educ condition 

sum spid if condition==1
sum spid if condition==2
sum spid if condition==3
anova spid condition 

sum age if condition==1
sum age if condition==2
sum age if condition==3
anova age condition 

sum knowledge if condition==1
sum knowledge if condition==2
sum knowledge if condition==3
anova knowledge condition 

*Table 2

nbreg depth3 disagreecond agreecond knowledge 
margins, at(disagreecond=(0(1)1))
margins, at(agreecond=(0(1)1))

*Table 3
nbreg depth3 c.disagreecond c.agreecond c.extraversion0 c.knowledge c.disagreecond#c.extraversion0 
margins, at(disagreecond=(0(1)1) extraversion0=(0(1)12)) 
margins, dydx(disagreecond) at (extraversion0=(0(1)12)) 

nbreg depth3 c.disagreecond c.agreecond c.extraversion0 c.knowledge c.agreecond#c.extraversion0 
margins, dydx(agreecond) at (extraversion0=(0(1)12)) 

nbreg depth3 c.disagreecond c.agreecond c.openness0 c.knowledge c.disagreecond#c.openness0 
margins, at(disagreecond=(0(1)1) openness0=(0(1)12)) 
margins, dydx(disagreecond) at (openness0=(0(1)12)) 

nbreg depth3 c.disagreecond c.agreecond c.openness0 c.knowledge c.agreecond#c.openness0 
margins, dydx(agreecond) at (openness0=(0(1)12)) 

nbreg depth3 c.disagreecond c.agreecond c.agreeable0 c.knowledge c.disagreecond#c.agreeable0 
margins, at(disagreecond=(0(1)1) agreeable0=(0(1)12)) 
margins, dydx(disagreecond) at (agreeable0=(0(1)12)) 

nbreg depth3 c.disagreecond c.agreecond c.agreeable0 c.knowledge c.agreecond#c.agreeable0 
margins, dydx(agreecond) at (agreeable0=(0(1)12)) 

****************************************************************************
****Models in Online SI Document********************************************
****************************************************************************

*Replication of Table 3 with Full Personality Battery

nbreg depth3 c.disagreecond c.agreecond c.agreeable0 c.openness0 c.extraversion0 c.emostable0 c.conscientious0 c.knowledge c.disagreecond#c.extraversion0 
margins, at(disagreecond=(0(1)1) extraversion0=(0(1)12)) 
margins, dydx(disagreecond) at (extraversion0=(0(1)12)) 

nbreg depth3 c.disagreecond c.agreecond c.agreeable0 c.openness0 c.extraversion0 c.emostable0 c.conscientious0 c.knowledge c.agreecond#c.extraversion0 
margins, dydx(agreecond) at (extraversion0=(0(1)12)) 

nbreg depth3 c.disagreecond c.agreecond c.agreeable0 c.openness0 c.extraversion0 c.emostable0 c.conscientious0 c.knowledge c.disagreecond#c.openness0 
margins, at(disagreecond=(0(1)1) openness0=(0(1)12)) 
margins, dydx(disagreecond) at (openness0=(0(1)12)) 

nbreg depth3 c.disagreecond c.agreecond c.agreeable0 c.openness0 c.extraversion0 c.emostable0 c.conscientious0  c.knowledge c.agreecond#c.openness0 
margins, dydx(agreecond) at (openness0=(0(1)12)) 

nbreg depth3 c.disagreecond c.agreecond c.agreeable0 c.openness0 c.extraversion0 c.emostable0 c.conscientious0 c.knowledge c.disagreecond#c.agreeable0 
margins, at(disagreecond=(0(1)1) agreeable0=(0(1)12)) 
margins, dydx(disagreecond) at (agreeable0=(0(1)12)) 

nbreg depth3 c.disagreecond c.agreecond c.agreeable0 c.openness0 c.extraversion0 c.emostable0 c.conscientious0 c.knowledge c.agreecond#c.agreeable0 
margins, dydx(agreecond) at (agreeable0=(0(1)12)) 

*SI Table 1

nbreg time c.disagreecond c.agreecond c.extraversion0 c.knowledge c.disagreecond#c.extraversion0  
margins, at(disagreecond=(0(1)1) extraversion0=(0(1)12)) 
margins, dydx(disagreecond) at (extraversion0=(0(1)12)) 

nbreg time c.disagreecond c.agreecond c.extraversion0 c.knowledge c.agreecond#c.extraversion0
margins, dydx(agreecond) at (extraversion0=(0(1)12)) 

nbreg time c.disagreecond c.agreecond c.openness0 c.knowledge c.disagreecond#c.openness0 
margins, at(disagreecond=(0(1)1) openness0=(0(1)12)) 
margins, dydx(disagreecond) at (openness0=(0(1)12)) 

nbreg time c.disagreecond c.agreecond c.openness0 c.knowledge c.agreecond#c.openness0 
margins, dydx(agreecond) at (openness0=(0(1)12)) 

nbreg time c.disagreecond c.agreecond c.agreeable0 c.knowledge c.disagreecond#c.agreeable0 
margins, at(disagreecond=(0(1)1) agreeable0=(0(1)12)) 
margins, dydx(disagreecond) at (agreeable0=(0(1)12)) 

nbreg time c.disagreecond c.agreecond c.agreeable0 c.knowledge c.agreecond#c.agreeable0 
margins, dydx(agreecond) at (agreeable0=(0(1)12)) 

*SI Table 2

nbreg time c.disagreecond c.agreecond c.agreeable0 c.openness0 c.extraversion0 c.emostable0 c.conscientious0 c.knowledge c.disagreecond#c.extraversion0 
margins, at(disagreecond=(0(1)1) extraversion0=(0(1)12)) 
margins, dydx(disagreecond) at (extraversion0=(0(1)12)) 

nbreg time c.disagreecond c.agreecond c.agreeable0 c.openness0 c.extraversion0 c.emostable0 c.conscientious0 c.knowledge c.agreecond#c.extraversion0  
margins, dydx(agreecond) at (extraversion0=(0(1)12)) 

nbreg time c.disagreecond c.agreecond c.agreeable0 c.openness0 c.extraversion0 c.emostable0 c.conscientious0 c.knowledge c.disagreecond#c.openness0 
margins, at(disagreecond=(0(1)1) openness0=(0(1)12)) 
margins, dydx(disagreecond) at (openness0=(0(1)12)) 

nbreg time c.disagreecond c.agreecond c.agreeable0 c.openness0 c.extraversion0 c.emostable0 c.conscientious0  c.knowledge c.agreecond#c.openness0 
margins, dydx(agreecond) at (openness0=(0(1)12)) 

nbreg time c.disagreecond c.agreecond c.agreeable0 c.openness0 c.extraversion0 c.emostable0 c.conscientious0 c.knowledge c.disagreecond#c.agreeable0 
margins, at(disagreecond=(0(1)1) agreeable0=(0(1)12)) 
margins, dydx(disagreecond) at (agreeable0=(0(1)12)) 

nbreg time c.disagreecond c.agreecond c.agreeable0 c.openness0 c.extraversion0 c.emostable0 c.conscientious0  c.knowledge c.agreecond#c.agreeable0 
margins, dydx(agreecond) at (agreeable0=(0(1)12))



