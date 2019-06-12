*This file shows how the data were recoded and analyzed for "Experiments to Reduce the Over-reporting of Voting: A Pipeline to the Truth".
**Michael J. Hanmer, Antoine J. Banks, and Ismail K. White.

*Uses pipeline experiments.dta.

*Recodes go from line 9 to line 259.
*Analyses begin on line 263.

*************RECODES.

*1. Recode Validation variables for 2010.

*1a. recode the 2010 general election vote variable, which is a string variable.

ta e2010g

gen valvote2010=.
replace valvote2010 = 1 if e2010g=="Y"
replace valvote2010 = 2 if e2010g=="A"
replace valvote2010 = 3 if e2010g=="E"
replace valvote2010 = 4 if e2010g=="M"
replace valvote2010 = 0 if e2010g==" "

label variable valvote2010 "Validated 2010 vote from Knowledge Networks via Catalist"
label define valvote 1 "confirmed vote not abs, early, or mail" 2 "absentee vote" 3 "voted early" 4 "voted by mail" 0 "no record of having voted"
label values valvote2010 valvote

*check.
ta valvote2010
ta valvote2010 e2010g

*1b. recoded valvote2010 into a dummy variable for voted or not.

ta valvote2010
ta valvote2010, nol

recode valvote2010 (0=0) (1/4 = 1), gen(valvote2010_dum)
label variable valvote2010_dum "dummy variable for validated as having voted in 2010 or not from KN via Catalist"

*check.
ta valvote2010_dum
ta valvote2010 valvote2010_dum


*2. Recode Validation variables for 2008.

*2a. recode the 2008 general election vote variable, which is a string variable.

ta e2008g

gen valvote2008=.
replace valvote2008 = 1 if e2008g=="Y"
replace valvote2008 = 2 if e2008g=="A"
replace valvote2008 = 3 if e2008g=="E"
replace valvote2008 = 4 if e2008g=="M"
replace valvote2008 = 0 if e2008g==" "

label variable valvote2008 "Validated 2008 vote from Knowledge Networks via Catalist"
label values valvote2008 valvote

*check.
ta valvote2008
ta valvote2008 e2008g

*2b. Recode valvote2008 into a dummy variable for voted or not.

ta valvote2008
ta valvote2008, nol

recode valvote2008 (0=0) (1/4 = 1), gen(valvote2008_dum)
label variable valvote2008_dum "dummy variable for validated as having voted in 2008 or not from KN via Catalist"

*check.
ta valvote2008_dum
ta valvote2008 valvote2008_dum


**3. recode of vote questions from survey (3 questions, 1 for each condition).

ta Q1a

recode Q1a (-1 = .) (1/3 = 0) (4=1), gen(vote_control)
label variable vote_control "reported vote in 2010 in the control"

*check.
ta Q1a
ta vote_control
ta Q1a vote_control

ta Q1b

recode Q1b (-1 = .) (1/3 = 0) (4=1), gen(vote_tr1)
label variable vote_tr1 "reported vote in 2010 treatment 1 (check records)"

*check.
ta Q1b
ta vote_tr1
ta Q1b vote_tr1

ta Q1c

recode Q1c (-1 = .) (1/3 = 0) (4=1), gen(vote_tr2)
label variable vote_tr2 "reported vote in 2010 in treatment 2 (we know sometimes people say voted when didn't)"

*check.
ta Q1c
ta vote_tr2
ta Q1c vote_tr2


*4. Create 3 dummies for treatment status.

ta xtess057
ta xtess057, nol

recode xtess057 (1=1) (2/3=0), gen(cond_control)
recode xtess057 (2=1) (1=0) (3=0), gen(cond_treat1)
recode xtess057 (3=1) (1/2=0), gen(cond_treat2)

label variable cond_control "assigned to control question"
label variable cond_treat1 "assigned to treatment 1 (check records) question"
label variable cond_treat2 "assigned to treatment 2 (subtle) question"

*check.
ta cond_control
ta xtess057 cond_c

ta cond_treat1
ta xtess057 cond_treat1

ta cond_treat2
ta xtess057 cond_treat2

*5. create a combined reported vote 2010 variable.

gen vote2010 = .
replace vote2010 = vote_control if xtess057==1
replace vote2010 = vote_tr1 if xtess057==2
replace vote2010 = vote_tr2 if xtess057==3

label variable vote2010 "reported vote in 2010 combined across treatments"

*check.
ta vote2010

ta vote_control
ta vote2010 vote_control

ta vote_tr1
ta vote2010 vote_tr1

ta vote_tr2
ta vote2010 vote_tr2


*7. Recodes for accuracy and overreporting.

*7a. Recode vote2010 to accurate or not.

gen accurate2010 =.
replace accurate2010 = 1 if vote2010==1 & valvote2010_dum==1
replace accurate2010 = 1 if vote2010==0 & valvote2010_dum==0
replace accurate2010 = 0 if vote2010==1 & valvote2010_dum==0
replace accurate2010 = 0 if vote2010==0 & valvote2010_dum==1

label variable accurate2010 "survey report matches validation"

*check.
ta accurate2010
bysort accurate2010: ta vote2010 valvote2010_dum


*7b. Create a variable for overreporting in 2010.

gen overrpt2010 = .
replace overrpt2010 = 1 if vote2010==1 & valvote2010_dum==0
replace overrpt2010 = 0 if vote2010==0
replace overrpt2010 = 0 if vote2010==1 & valvote2010_dum==1

label variable overrpt2010 "said voted in 2010 but no record of voting in 2010"

*check.
ta overrpt2010
bysort overrpt2010: ta vote2010 valvote2010_dum


*7c. Reported vote in the 2008 election.

ta q9

recode q9 (-1=.) (1=1) (2=0), gen(vote2008)
label variable vote2008 "reported voting in the 2008 election"

*check.
ta vote2008
ta q9 vote2008


*7d. Create a variable for overreporting in 2008.

gen overrpt2008 = .
replace overrpt2008 = 1 if vote2008==1 & valvote2008_dum==0
replace overrpt2008 = 0 if vote2008==0
replace overrpt2008 = 0 if vote2008==1 & valvote2008_dum==1

label variable overrpt2008 "said voted in 2008 but no record of voting in 2008"

*check.
ta overrpt2008
bysort overrpt2008: ta vote2008 valvote2008_dum

*8. Demographics.

*8a. Gender.

ta ppgender

recode ppgender (1=1) (2=0), gen(male)
label variable male "1=male 0 = female"

*check.
ta male
ta ppgender male

*8b. Marital status.

ta ppmarit

recode ppmarit (1=1) (2/6=0), gen(married)
label variable married "1 = married 0 = else"

*check.
ta married
ta ppmarit married

*8c. Home ownership.

ta pprent

recode pprent (1=1) (2/3=0), gen(homeown)
label variable homeown "owned or being bought by you or someone"

*check.
ta homeown
ta pprent homeown


*8d. create a variable for white.

recode ppethm (1=1) (2/5 = 0), gen(white)
label variable white "white only & non-hispanic"

*check.
ta ppethm
ta ppethm white

*8e. party id.

ta xparty7
ta xparty7, nol

recode xparty7 (9=.), gen(pid)
label variable pid "party id 1 = SR 7 =SD"
label values pid xparty7

*check.
ta pid
ta xparty7 pid



*************Analyses.

*Figures 1a & 1b. Percentage of Over-reporters Among Validated Nonvoters in 2010 by Experimental Conditions.

reg overrpt2010 cond_treat1 cond_treat2 if valvote2010_dum==0 [aw=Weight1]


**Percentage of Over-reporters Among Validated Nonvoters in 2010 by Experimental Conditions ///
including only those matched and defined as active registrants (noted in text after discussion of Figure 1a & 1b).

reg overrpt2010 cond_treat1 cond_treat2 if valvote2010_dum==0 & voterstatus=="active" [aw=Weight1]


*Figures 2a & 2b. Overall Accuracy in 2010 Across the Sample by Experimental Conditions.

reg accurate2010 cond_treat1 cond_treat2 [aw=Weight1]


*Figures 3a & 3b. Percentage of Over-reporters in 2010 Across the Sample by Experimental Conditions. 

reg overrpt2010 cond_treat1 cond_treat2 [aw=Weight1]


*********************Supplemental Appendix Table 1. Randomization checks.

reg male cond_treat1 cond_treat2
reg white cond_treat1 cond_treat2
reg ppage cond_treat1 cond_treat2
reg ppeduc cond_treat1 cond_treat2
reg ppeducat cond_treat1 cond_treat2
reg ppincimp cond_treat1 cond_treat2
reg married cond_treat1 cond_treat2
reg homeown cond_treat1 cond_treat2
reg pid cond_treat1 cond_treat2


*Supplemental Appendix 2 Figure 1. Percentage of Over-reporters Among Self-reported Voters in 2010 by Experimental Conditions.
reg	overrpt2010	cond_treat1	cond_treat2	if	vote2010==1	[aw=W]


*Supplemental Appendix 3 Figures 1a & 1b. Percentage of Over-reporters Among Validated Nonvoters in 2008 by Experimental Conditions.

reg overrpt2008 cond_treat1 cond_treat2 if valvote2008_dum==0 & ppage >=20 [aw=Weight1]
