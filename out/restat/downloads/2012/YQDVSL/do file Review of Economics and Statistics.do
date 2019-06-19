clear
set mem 200m

**** THE FILE HAS TWO PARTS, FIRST PART USES DATA FROM THE GAME SHOW, SECOND USES EXPERIMENTAL DATA
**** FIRST PART: USING DATA FROM THE GAME SHOW (FILE "DATAGAMESHOW.RAW")

infile using datagameshow.raw

* TABLE 1
* column "lead player"
sum age gender if rank==1
* column "chosen player"
sum age gender if rank==2

* TABLE 2
* column "Frequency"
sum share 
tab outcome 
* column "Median stake"
centile totalscore, c(50)
bys outcome: centile totalscore, c(50)

* TABLE 3 - Sharing probabilities - Summary statistics
* Sharing probability actual game show data
sum share 

* TABLE 4 - Actual cues and perceived cues
*define the constraints
constraint 1 gender=gender_opp
constraint 2 age=age_opp
constraint 3 contribution=contribution_opp
constraint 4 totalscore=totalscore_opp
constraint 10 mean_beautyrate=mean_beautyrate_opp
xi:biprobit (share=age gender mean_beautyrate contribution totalscore) (share_opp=age_opp gender_opp mean_beautyrate_opp contribution_opp totalscore_opp) if rank==1, cl(serie) constr(1 2 3 4 10)
mfx compute, predict (pmarg1)

* TABLE 5 - Communication and sharing summary statistics
tab promise share, row cell
tab voluntarypromise if promise==1
tab forced if promise==1
tab voluntarypromise share, row 
tab forced share, row 

* TABLE 8
logit share old gender contribution_medium contribution_high totalscore_low attractive voluntarypromise, cl(serie)

* TABLE 9
*define the constraints
constraint 1 gender=gender_opp
constraint 2 age=age_opp
constraint 3 contribution=contribution_opp
constraint 4 totalscore=totalscore_opp
constraint 10 mean_beautyrate=mean_beautyrate_opp
xi:biprobit (share=age gender mean_beautyrate contribution totalscore) (share_opp=age_opp gender_opp mean_beautyrate_opp contribution_opp totalscore_opp) if rank==1, cl(serie) constr(1 2 3 4 10)
mfx compute, predict (pmarg1)




**** TABLES BASED ON EXPERIMENTAL DATA
infile using "experimental data.dta", clear

* TABLE 11 - DETERMINANTS OF THE QUALITY OF PREDICTIONS (INCLUDING PREDICTIONS BEFORE AND AFTER COMMUNICATION)
xi:reg earnings genderstud age2 brothersandsisters estimated_average pd_shares i.studytype i.playernr, cl(subjectnr)
xi:reg earnings genderstud age2 brothersandsisters estimated_average pd_shares i.studytype iqtestscore risk_suma impatient donation i.playernr, cl(subjectnr)


* LIMIT SAMPLE TO PREDICTIONS FOR PLAYERS PLAYING THE FINAL ONLY
keep if (rank==1| rank==2) & (rankB==1 | rankB==2)

* TABLE 3 - SHARING PROBABILITIES - SUMMARY STATISTICS
sum share if flagplayer==1
sum estimated_average if flagsubject==1
sum predshare if communication==1
sum predshare if communication==0

* TABLE 6 - PREDICTIONS BY SUBJECTS - SUMMARY STATISTICS 
* AVERAGE BELIEF (BEFORE AND AFTER COMMUNICATION)
sum predshare if communication==0
sum predshare if communication==1
sum predshare if communication==0 & promise==0 &share==1
sum predshare if communication==0 & promise==0 &share==0
bys dummypromise: sum predshare if communication==0
bys dummypromise: sum predshare if communication==1
* RATE OF ACCURACY (BEFORE AND AFTER COMMUNICATION)
sum correct if communication==0
sum correct if communication==1
sum correct if communication==0 & promise==0 &share==1
sum correct if communication==0 & promise==0 &share==0
bys dummypromise: sum correct if communication==0
bys dummypromise: sum correct if communication==1

* RESTRICT SAMPLE TO FINAL BELIEFS AND CHANGES IN BELIEFS
sort playernr subjectnr rankB communication
keep if communication==1
drop if rankB==3


tsset playernr subjectnr 
* TABLE 4 - COLUMN "BELIEFS"
xi:xtreg predshare gender age contribution totalscore mean_beautyrate i.subjectnr, re

* TABLE 7 - COMMUNICATION AND BELIEFS
* COLUMN 1
reg difpredshare forced voluntarypromise 
* COLUMN 2
xi:reg difpredshare forced forcedlying voluntarypromise voluntarylying

* TABLE 8 - ACTUAL AND PERCEIVED CUES (LOG LIKELIHOOD RATIOS)
* COLUMN 2 - FINAL BELIEFS
xi:xtreg ln2 gender old contribution_medium contribution_high totalscore_low attractive voluntarypromise i.subjectnr, re
* COLUMN 3 - FINAL BELIEFS
xi:reg update2 voluntarypromise

* TABLE 9
* COLUMN 2 - FINAL BELIEFS
char est_aver[omit] 2
xi: xtreg predshare i.est_aver*gender i.est_aver*age i.est_aver*contribution i.est_aver*totalscore i.est_aver*mean_beautyrate i.subjectnr, re


* TABLE 10
xi:xtreg predshare genderstud age2 brothersandsisters i.studytype  pd_shares i.playernr, re
xi:reg estimated_average genderstud age2 brothersandsisters i.studytype pd_shares if flagsubject1==1
xi:xtreg predshare genderstud age2 brothersandsisters i.studytype  pd_shares iqtestscore donation  i.playernr, re
xi:reg estimated_average genderstud age2 brothersandsisters i.studytype pd_shares iqtestscore donation  if flagsubject1==1

* 7% RESULT
xi:xtreg predshare share i.subjectnr, re




