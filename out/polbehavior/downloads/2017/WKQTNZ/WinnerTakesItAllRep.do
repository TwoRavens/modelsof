************************************************************************
*                                 Article                              *
*  The Winner Takes it All: Revisiting the Effect of Direct Democracy  *
*                    on Citizens' Political Support                    *
*																	   *
*                       Sofie Marien & Anna Kern                       *
* 			     	University of Leuven, Belgium                      *
************************************************************************

version 11
set more off
capture log close

* Input File: WinnerTakesItAllData1.dta 
use "WinnerTakesItAllData1.dta", clear   

drop if  consistcorrectresp!=1


* ******************* *
* I. Recode Variables *
* ******************* *


** Dependent variables 

* Satisfaction with local policy: "To what extent satified with policy choice of major and councillors?"
gen w1_satislocpol=w1_satisfaction_politics_city
gen w2_satislocpol=w2_satisfaction_politics_city
sum w1_satislocpol
sum w2_satislocpol

* Local political trust
corr w1_poltrust_localcouncil w1_poltrust_localgovernment
gen w1_localtrust=(w1_poltrust_localcouncil + w1_poltrust_localgovernment)/2
sum w1_localtrust

corr w2_poltrust_localcouncil w2_poltrust_localgovernment
gen w2_localtrust=( w2_poltrust_localcouncil + w2_poltrust_localgovernment)/2
sum w2_localtrust

* Democratic performance evaluation (local): "How democratic do you think your city is currently goverend?"
gen w1_perforeval=w1_democracy_satisfaction_city
gen w2_perforeval=w2_democracy_satisfaction_city

* First differences
gen satislocpoldiff=w2_satislocpol-w1_satislocpol
gen localtrustdiff= w2_localtrust-w1_localtrust
gen perforevaldiff= w2_perforeval-w1_perforeval


** Recode other variables 

tab w2_voted, m
recode w2_voted (2=0) // recode variable so that 1 indicates that the respondent
                      // voted and 0 indicates that the respondent didn't vote

replace w2_vote_choice=. if w2_vote_choice==3 | w2_vote_choice==666
tab w2_vote_choice

gen age= 2015-w1_byear


** Code winners: Three different codings (winner1 & winner2 & winner3)

* Winner1: winners are coded in contrast to losers and in contrast to those who did not vote
gen winner1 = . 
replace winner1= 1 if neighb==1 & w2_voted==0 // those who could vote but didn't
replace winner1= 2 if w2_voted==1 & w2_vote_choice==1 // those who lost
replace winner1= 3 if w2_voted==1 & w2_vote_choice==2 // those who won
tab w2_voted winner1 
tab winner1, gen(winner1dummy)

* Winner2: winners are coded in contrast to losers, in contrast to those who did not vote and 
* in contrast to those who could not vote (not eligible)
gen winner2 = . 
replace winner2= 1 if neighb==2 // those who didn't have the right to vote
replace winner2= 2 if neighb==1 & w2_voted==0 // those who could but didn't
replace winner2= 3 if w2_voted==1 & w2_vote_choice==1 // those who lost
replace winner2= 4 if w2_voted==1 & w2_vote_choice==2 // those who won
tab w2_voted winner2 
tab winner2, gen(winner2dummy)

* Winner 3: dummy winner vs all others
recode winner2 (1=0) (2=0) (3=0) (4=1), gen(winner3)

* Code voters (1=no right, 2=not vote, 3=voted)
recode winner2 (3/4=3), gen(cat_voters)


* ************************************************************************ *
*  II. Control sociodemographic differences between the two neighbourhoods *
* ************************************************************************ *

** Table 2

// To replicate the aggregation of sex per neighbourhood, use the dataset "WinnerTakesItAllRep2.dta".
// We have created another dataset to make sure responses could in no way be traced back to individual respondents. 
// Therefore, we chose to drop the variable sex from the main dataset.

ttest age, by(neighb)une

ttest primary, by(neighb) une

ttest secondary, by(neighb) une

ttest tertiary, by(neigh) une

ttest w1_pol_interest, by(neighb) une

ttest w1_trust_general, by(neighb) une


* *************************************** *
*  III. Difference-in-differnces analysis *
* *************************************** *

** Rename variables
gen satislocpol1=w1_satislocpol
gen satislocpol2=w2_satislocpol
gen localtrust1=w1_localtrust
gen localtrust2=w2_localtrust
gen perforeval1=w1_perforeval
gen perforeval2=w2_perforeval


reshape long  satislocpol localtrust perforeval, i(idresp) j(j) 
recode neigh (2=0) // neighbourhood is coded so that the treatment group is coded with 1
				   // and the comparison group is coded with 0

gen period=.
replace period=0 if j==1 
replace period=1 if j==2 


** Table 3
// ssc install diff 
diff satislocpol, t(neighb) p(period)
bysort neighb: ttest satislocpol, by(period)

diff localtrust, t(neighb) p(period)
bysort neighb: ttest localtrust, by(period)

diff perforeval, t(neighb) p(period)
bysort neighb: ttest perforeval, by(period)

drop period
// drop _diff


* *************** *
* IV. ANOVA tests *
* *************** *

** Table 4
oneway satislocpoldiff cat_voters, tab scheffe
oneway localtrustdiff cat_voters, tab scheffe
oneway perforevaldiff cat_voters, tab scheffe


* **************************************** *
* V. First differences controlling for age *
* **************************************** *

reshape wide

** Table A2
eststo Satis_M1: reg satislocpoldiff  age winner1dummy2 winner1dummy3, r
display "adjusted R2 = " e(r2_a)
eststo Satis_M2: reg satislocpoldiff  age winner2dummy2 winner2dummy3 winner2dummy4, r
display "adjusted R2 = " e(r2_a)

eststo Trust_M1: reg localtrustdiff age winner1dummy2 winner1dummy3, r
display "adjusted R2 = " e(r2_a)
eststo Trust_M2: reg localtrustdiff  age winner2dummy2 winner2dummy3 winner2dummy4, r
display "adjusted R2 = " e(r2_a)

eststo Performance_M1: reg perforevaldiff age winner1dummy2 winner1dummy3, r
display "adjusted R2 = " e(r2_a)
eststo Performance_M2: reg perforevaldiff  age winner2dummy2 winner2dummy3 winner2dummy4, r
display "adjusted R2 = " e(r2_a)


** Figure 1
coefplot (Satis_M1, label(Model I)) (Satis_M2, label(Model II)), bylabel("Change in satisfaction" "with local policy") ///
	   ||(Trust_M1)                 (Trust_M2)                 , bylabel("Change in trust" "in local authorities") ///
 	   ||(Performance_M1)           (Performance_M2)           , bylabel("Change in democratic" "performance evaluations") ///
	   ||, drop(_cons) xline(0)  ///
	   coeflabels(age = "Age" winner1dummy2 = "Loser" winner1dummy3 = "Winner" winner2dummy2 = "Non-voter" winner2dummy3 = "Loser" winner2dummy4 = "Winner") ///
	   byopts(row(1) xrescal) xsize(7) scheme(s1mono)  ///
	   legend(region(lwidth(none))) ///
	   headings(winner1dummy2 = `""{bf:Participation in referendum}" "{bf:(ref. abstained)}""' ///
				winner2dummy2 = `""{bf:Participation in referendum}" "{bf:(ref. not eligible to vote)}""')
			
										
** Table A3
eststo Satis_M3: reg satislocpoldiff w2_voted age, r
display "adjusted R2 = " e(r2_a)
eststo Satis_M4: reg satislocpoldiff w2_voted age w2_referendum_honest w2_referendum_influence w2_decision_good, r
display "adjusted R2 = " e(r2_a)

eststo Trust_M3: reg localtrustdiff w2_voted age, r
display "adjusted R2 = " e(r2_a)
eststo Trust_M4: reg localtrustdiff w2_voted age w2_referendum_honest w2_referendum_influence w2_decision_good, r
display "adjusted R2 = " e(r2_a)

eststo Performance_M3: reg perforevaldiff w2_voted age, r
display "adjusted R2 = " e(r2_a)
eststo Performance_M4: reg perforevaldiff w2_voted age w2_referendum_honest w2_referendum_influence w2_decision_good, r
display "adjusted R2 = " e(r2_a)

** Figure 2
coefplot (Satis_M3, label(Model III)) (Satis_M4, label(Model IV)) , bylabel("Change in satisfaction" "with local policy") ///
	   ||(Trust_M3)                 (Trust_M4)                  , bylabel("Change in trust" "in local authorities") ///
	   ||(Performance_M3)           (Performance_M4)            , bylabel("Change in democratic" "performance evaluations") ///
	   ||, drop(_cons) xline(0) ///
	   coeflabels(w2_voted = "Voted (1=yes)" age = "Age" w2_referendum_honest = "Perceived honesty referendum" w2_referendum_influence = "Perceived influence decision" w2_decision_good = "Perceived quality decision") ///
	   byopts(row(1) xrescal) xsize(7) scheme(s1mono)  ///
	   legend(region(lwidth(none))) ///
	   headings(w2_voted = "{bf:Voted}" ///
				w2_referendum_honest = `""{bf:Perceived fairness}" "{bf:and influence}""')

			
** Table 5
tab winner3
ttest w2_referendum_honest , by(winner3) une
ttest w2_referendum_influence , by(winner3) une
ttest w2_decision_good , by(winner3) une

* **************** *
* VI. Descriptives *
* **************** *
				
** Table A1
sum w1_satislocpol w2_satislocpol satislocpoldiff w1_localtrust w2_localtrust localtrustdiff w1_perforeval w2_perforeval perforevaldiff ///
winner1dummy1 winner1dummy2 winner1dummy3 winner2dummy1 winner2dummy2 winner2dummy3 winner2dummy4 ///
w2_referendum_honest w2_referendum_influence w2_decision_good



exit


