clear
capture log close
set memo 100m
set matsize 800
set more 1



*********************************************************************************
**             Replication of statistical tests of Experiment I                **
*********************************************************************************
log using "D:\Dropbox\My Papers\Voting Under Strategic Uncertainty\ReplicationResults.log", replace
use Experiment1.dta, clear

gen BVoteA=0 if SubjectType==2&SubjectChoice!=1
replace BVoteA=1 if SubjectType==2&SubjectChoice==1

gen AVoteB=0 if SubjectType==1&SubjectChoice!=2
replace AVoteB=1 if SubjectType==1&SubjectChoice==2


gen Public=1 if Sequence==1&PrivacyType=="P"
replace Public=0 if Sequence==1&PrivacyType=="SI"
replace Public=0 if Sequence==1&PrivacyType=="S"


* Supporting evidence of Result 1
prtest AVoteB if SubjectType==1&ElectionType=="EC",by(Public)
prtest BVoteA if SubjectType==2&ElectionType=="EC",by(Public)

prtest AVoteB if SubjectType==1&ElectionType=="E1",by(Public)
prtest BVoteA if SubjectType==2&ElectionType=="E1",by(Public)

prtest AVoteB if SubjectType==1&ElectionType=="E2",by(Public)
prtest BVoteA if SubjectType==2&ElectionType=="E2",by(Public)
************************************



gen AAbstained=1 if SubjectType==1&SubjectChoice==0
replace AAbstained=0 if SubjectType==1&SubjectChoice!=0
gen BAbstained=1 if SubjectType==2&SubjectChoice==0
replace BAbstained=0 if SubjectType==2&SubjectChoice!=0


* Supporting evidence of Result 2
prtest AAbstained if SubjectType==1,by(Public)
prtest BAbstained if SubjectType==2,by(Public)

prtest AAbstained if SubjectType==1&ElectionType=="EC", by(Public)
prtest BAbstained if SubjectType==2&ElectionType=="EC", by(Public)

prtest AAbstained if SubjectType==1&ElectionType=="E1", by(Public)
prtest BAbstained if SubjectType==2&ElectionType=="E1", by(Public)

prtest AAbstained if SubjectType==1&ElectionType=="E2", by(Public)
prtest BAbstained if SubjectType==2&ElectionType=="E2", by(Public)
************************************

*The prob. A wins based on the experimental data
egen GlobalSessionID=group(PrivacyType SessionNumberinPrivacyType Sequence) if Sequence==1
egen SetID=group(GlobalSessionID Period) if Sequence==1
gen VotedA=1 if SubjectChoice==1
replace VotedA=0 if SubjectChoice!=1
gen VotedB=1 if SubjectChoice==2
replace VotedB=0 if SubjectChoice!=2
by SetID, sort: egen NVotedA=total(VotedA)
by SetID, sort: egen NVotedB=total(VotedB)
gen AWins=NVotedA/(NVotedB+NVotedA)
sort SetID
by SetID: gen filter = 1 if _n == 1
gen PAWins=AWins if filter==1
************************************

* Supporting evidence of Result 3
ttest PAWins if ElectionType=="EC", by(Public)
ttest PAWins if ElectionType=="E1", by(Public)
ttest PAWins if ElectionType=="E2", by(Public)


*********************************************************************************
**         Replicate the results of statistical tests of Experiment II         **
*********************************************************************************
clear
use Experiment2.dta, clear


*In Experiment II subjects voted for Secret Ballots or Public Voting in some periods
*First we identify these periods
gen Statistics=1
replace Statistics=0 if Treatment=="Short"&Period==11
replace Statistics=0 if Treatment=="Short"&Period==17
replace Statistics=0 if Treatment=="Long"&Period==21
*Then we generate the treatment variable
gen Public=1 if PrivacyType=="Public"&Statistics==1
replace Public=0 if PrivacyType=="Secret"&Statistics==1
gen Abstained=1 if SubjectChoice=="0"&Statistics==1
replace Abstained=0 if SubjectChoice!="0"&Statistics==1
************************************
*Footnote 16
prtest Abstained if SubjectType==1&Statistics==1, by(Public)
prtest Abstained if SubjectType==2&Statistics==1, by(Public)
*Footnote 17
gen AVotedB=0
replace AVotedB=1 if SubjectType==1&SubjectChoice=="2"
prtest AVotedB if SubjectType==1, by(Public)
gen BVotedA=0
replace BVotedA=1 if SubjectType==2&SubjectChoice=="1"
prtest BVotedA if SubjectType==2, by(Public)
************************************

* Supporting evidence of Result 4
tabulate SubjectChoice SubjectType if Statistics==0, col


*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
*$$$             "Public Voting and Prosocial Behavior"                     $$
*$$$      Note: The data of Figure 3 is provided in a separate file         $$
*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




*********************************************************************************
**             Replication of statistical tests in Appendix                    **
*********************************************************************************
clear
use Experiment1.dta, clear

gen Abstain=1 if SubjectChoice==0
replace Abstain=0 if SubjectChoice!=0




*********************************************************************************
**             Replication of statistical tests in B1                          **
*********************************************************************************


*Footnote22
prtest Abstain if PrivacyType=="S"&Sequence!=3&ElectionType=="EC", by(SubjectType)

*Footnote23
 prtest Abstain if PrivacyType=="S"&Sequence!=3&ElectionType=="E1", by(SubjectType)
 prtest Abstain if PrivacyType=="S"&Sequence!=3&ElectionType=="E2", by(SubjectType)
 
 *footnote24
gen OtherpartyVote=0
replace OtherpartyVote=1 if SubjectType==1&SubjectChoice==2
replace OtherpartyVote=1 if SubjectType==2&SubjectChoice==1
prtest OtherpartyVote if PrivacyType=="S"&Sequence!=3&ElectionType=="EC", by(SubjectType)

*footnote25
prtest OtherpartyVote if PrivacyType=="S"&Sequence!=3&ElectionType=="E1", by(SubjectType)
prtest OtherpartyVote if PrivacyType=="S"&Sequence!=3&ElectionType=="E2", by(SubjectType)

*footnote26
gen E1E2=0
replace E1E2=1 if ElectionType=="E2"
prtest OtherpartyVote if SubjectType==1&PrivacyType=="S"&Sequence!=3&Period>=17, by(E1E2)



egen GlobalSessionID=group(PrivacyType SessionNumberinPrivacyType Sequence) if Sequence!=3
egen SetID=group(GlobalSessionID Period) if Sequence!=3
gen VotedA=1 if SubjectChoice==1
replace VotedA=0 if SubjectChoice!=1
gen VotedB=1 if SubjectChoice==2
replace VotedB=0 if SubjectChoice!=2
by SetID, sort: egen NVotedA=total(VotedA)
by SetID, sort: egen NVotedB=total(VotedB)
gen AWins=NVotedA/(NVotedB+NVotedA)
sort SetID
by SetID: gen filter = 1 if _n == 1
gen PAWins=AWins if filter==1

*footnote27
ttest PAWins=0.5 if ElectionType=="EC"&Sequence!=3&PrivacyType=="S"

*footnote28
ttest PAWins=0.04 if ElectionType=="E1"&Sequence!=3&PrivacyType=="S"
ttest PAWins=0.20 if ElectionType=="E2"&Sequence!=3&PrivacyType=="S"

*********************************************************************************
**             Replication of statistical tests in B2                          **
*********************************************************************************
gen SIvP=1 if Sequence==1&PrivacyType=="SI"
replace SIvP=0 if Sequence==1&PrivacyType=="P"

prtest BVoteA if SubjectType==2&ElectionType=="EC",by(SIvP)
prtest AVoteB if SubjectType==1&ElectionType=="EC",by(SIvP)

*footnote29
prtest BVoteA if SubjectType==2&ElectionType=="E1",by(SIvP)
prtest AVoteB if SubjectType==1&ElectionType=="E1",by(SIvP)
prtest BVoteA if SubjectType==2&ElectionType=="E2",by(SIvP)
prtest AVoteB if SubjectType==1&ElectionType=="E2",by(SIvP)


prtest AAbstained if SubjectType==1,by(SIvP)
prtest BAbstained if SubjectType==2,by(SIvP)

*footnote30
prtest AAbstained if SubjectType==1&ElectionType=="EC",by(SIvP)
prtest BAbstained if SubjectType==2&ElectionType=="EC",by(SIvP)

*footnote31
prtest AAbstained if SubjectType==1&ElectionType=="E1",by(SIvP)
prtest BAbstained if SubjectType==2&ElectionType=="E1",by(SIvP)
prtest AAbstained if SubjectType==1&ElectionType=="E2",by(SIvP)
prtest BAbstained if SubjectType==2&ElectionType=="E2",by(SIvP)

*********************************************************************************
**             Replication of statistical tests in B3                          **
*********************************************************************************

gen SIvS=1 if Sequence==1&PrivacyType=="SI"
replace SIvS=0 if Sequence==1&PrivacyType=="S"

*footnote32
prtest BAbstained if SubjectType==2&ElectionType=="E1",by(SIvS)
prtest BAbstained if SubjectType==2&ElectionType=="E2",by(SIvS)

*footnote33
prtest AVoteB if SubjectType==1&ElectionType=="E2",by(SIvS)

*footnote34
ttest PAWins if ElectionType=="EC", by(SIvS)
ttest PAWins if ElectionType=="E1", by(SIvS)
ttest PAWins if ElectionType=="E2", by(SIvS)

prtest AVoteB if SubjectType==1&ElectionType=="E1",by(SIvS)
prtest AVoteB if SubjectType==1&ElectionType=="E2",by(SIvS)

*********************************************************************************
**             Replication of statistical tests in B4                          **
*********************************************************************************

gen SvP=1 if Sequence==1&PrivacyType=="S"
replace SvP=0 if Sequence==1&PrivacyType=="P"


prtest BVoteA if SubjectType==2&ElectionType=="EC",by(SvP)
prtest AVoteB if SubjectType==1&ElectionType=="EC",by(SvP)

*footnote35
prtest BVoteA if SubjectType==2&ElectionType=="E2",by(SvP)
prtest AVoteB if SubjectType==1&ElectionType=="E2",by(SvP)


prtest BVoteA if SubjectType==2&ElectionType=="E1",by(SvP)
prtest AVoteB if SubjectType==1&ElectionType=="E1",by(SvP)

prtest AAbstained if SubjectType==1,by(SvP)
prtest BAbstained if SubjectType==2,by(SvP)

*footnote36
prtest AAbstained if SubjectType==1&ElectionType=="EC",by(SvP)
prtest BAbstained if SubjectType==2&ElectionType=="EC",by(SvP)

*footnote37
prtest AAbstained if SubjectType==1&ElectionType=="E1",by(SvP)
prtest BAbstained if SubjectType==2&ElectionType=="E1",by(SvP)
prtest AAbstained if SubjectType==1&ElectionType=="E2",by(SvP)
prtest BAbstained if SubjectType==2&ElectionType=="E2",by(SvP)

*********************************************************************************
**             Replication of statistical tests in B6                          **
*********************************************************************************

gen AWinslaged=AWins[_n-10]
probit AAbstained AWinslaged if Sequence==1&PrivacyType=="SI"
mfx
probit AAbstained AWinslaged if Sequence==1&PrivacyType=="P"
mfx
probit BAbstained AWinslaged if Sequence==1&PrivacyType=="SI"
mfx
probit BAbstained AWinslaged if Sequence==1&PrivacyType=="P"
mfx
probit AVoteB AWinslaged if Sequence==1&PrivacyType=="SI"&ElectionType!="EC"
mfx
probit BVoteA AWinslag if Sequence==1& PrivacyType=="P"&ElectionType=="EC"
mfx

probit AAbstained AWinslag if Sequence==1& PrivacyType=="S"
est store S
probit AAbstained AWinslag if Sequence==1& PrivacyType=="P"
est store P
suest S P
test [S_AAbstained]AWinslage=[P_AAbstained]AWinslage

probit BAbstained AWinslag if Sequence==1& PrivacyType=="SI"
est store S
probit BAbstained AWinslag if Sequence==1& PrivacyType=="P"
est store P
suest S P
test [S_BAbstained]AWinslage=[P_BAbstained]AWinslage

probit AVoteB AWinslag if Sequence==1& PrivacyType=="SI"&ElectionType!="EC"
est store S
probit AVoteB AWinslag if Sequence==1& PrivacyType=="P"&ElectionType!="EC"
est store P
suest S P
test [S_AVoteB]AWinslage=[P_AVoteB]AWinslage



*********************************************************************************
**             Replication of statistical tests in B7                          **
*********************************************************************************

gen NewPublic=1 if Sequence!=3&PrivacyType=="P"
replace NewPublic=0 if Sequence==1&PrivacyType=="SI"
replace NewPublic=0 if Sequence==1&PrivacyType=="S"
replace NewPublic=0 if Sequence==2&PrivacyType=="S"

*footnote39
prtest AAbstained if SubjectType==1,by(NewPublic)
prtest BAbstained if SubjectType==2,by(NewPublic)

prtest BAbstained if SubjectType==2&ElectionType=="EC",by(NewPublic)
prtest BAbstained if SubjectType==2&ElectionType=="E1",by(NewPublic)
prtest BAbstained if SubjectType==2&ElectionType=="E2",by(NewPublic)

*footnote40
prtest AAbstained if SubjectType==1&ElectionType=="E1"&Period<=16,by(NewPublic)
prtest BAbstained if SubjectType==2&ElectionType=="E1"&Period<=16,by(NewPublic)

prtest AAbstained if SubjectType==1&ElectionType=="E1"&Period>16,by(NewPublic)
prtest BAbstained if SubjectType==2&ElectionType=="E1"&Period>16,by(NewPublic)

*footnote41
prtest AVoteB if SubjectType==1&ElectionType=="EC",by(NewPublic)
prtest BVoteA if SubjectType==2&ElectionType=="EC",by(NewPublic)

prtest AVoteB if SubjectType==1&ElectionType=="E2",by(NewPublic)
prtest BVoteA if SubjectType==2&ElectionType=="E2",by(NewPublic)

*footnote42
ttest PAWins if ElectionType=="EC",by(NewPublic)
ttest PAWins if ElectionType=="E1",by(NewPublic)
ttest PAWins if ElectionType=="E2",by(NewPublic)


*********************************************************************************
**             Replication of statistical tests in B8                          **
*********************************************************************************
gen S3Public=0 if Sequence==3&PrivacyType=="S"
replace S3Public=1 if Sequence==3&PrivacyType=="P"
prtest Abstain,by(S3Public)

*footnote43
gen selfishnotpro=1 if Sequence==3&SubjectType==1&ElectionType!="EC"
replace selfishnotpro=1 if Sequence==3&SubjectType==2&ElectionType=="EC"& NumberofAvoters==6
replace selfishnotpro=1 if Sequence==3&SubjectType==1&ElectionType=="EC"& NumberofAvoters==4
prtest OtherpartyVote if selfishnotpro==1,by(S3Public)

*footnote44
gen AprsocialVote=0 if Sequence==3&SubjectType==1&ElectionType!="EC"
replace AprsocialVote=1 if Sequence==3&SubjectType==1&SubjectChoice==2&ElectionType!="EC"
gen X4=1 if NumberofAvoters==4&Sequence==3&SubjectType==1&ElectionType!="EC"
replace X4=0 if NumberofAvoters!=4&Sequence==3&SubjectType==1&ElectionType!="EC"
prtest AprsocialVote if Sequence==3&SubjectType==1,by(X4)

*footnote45
prtest AprsocialVote if Sequence==3&SubjectType==1&S3Public==0,by(X4)
prtest AprsocialVote if Sequence==3&SubjectType==1&S3Public==1,by(X4)
  
*footnote46
gen BMinority=1 if Sequence==3&SubjectType==2&ElectionType!="EC"& NumberofBvoters==4
replace BMinority=0 if Sequence==3&SubjectType==2&ElectionType!="EC"& NumberofBvoters!=4
prtest OtherpartyVote, by(BMinority)  

*footnote47
prtest OtherpartyVote if PrivacyType=="P",by(BMinority)

*footnote48
prtest OtherpartyVote if PrivacyType=="S",by(BMinority)

*********************************************************************************
**             Replication of statistical tests in B9                          **
*********************************************************************************

gen SEvP=1 if Sequence==1&PrivacyType=="SE"
replace SEvP=0 if Sequence==1&PrivacyType=="P"
gen SEvS=1 if Sequence==1&PrivacyType=="SE"
replace SEvS=0 if Sequence==1&PrivacyType=="S"

prtest BVoteA if SubjectType==2&ElectionType=="EC",by(SEvE)
prtest AVoteB if SubjectType==1&ElectionType=="EC",by(SEvE)
prtest BVoteA if SubjectType==2&ElectionType=="EC",by(SEvP)
prtest AVoteB if SubjectType==1&ElectionType=="EC",by(SEvP)

*foonote49
prtest BVoteA if SubjectType==2&ElectionType=="E2",by(SEvE)
prtest AVoteB if SubjectType==1&ElectionType=="E2",by(SEvE)
prtest BVoteA if SubjectType==2&ElectionType=="E2",by(SEvP)
prtest AVoteB if SubjectType==1&ElectionType=="E2",by(SEvP)

*footnote50
prtest BVoteA if SubjectType==2&ElectionType=="E1",by(SEvE)
prtest AVoteB if SubjectType==1&ElectionType=="E1",by(SEvE)
prtest BVoteA if SubjectType==2&ElectionType=="E1",by(SEvP)
prtest AVoteB if SubjectType==1&ElectionType=="E1",by(SEvP)


*footnote51
prtest AAbstained if SubjectType==1,by(SEvP)
prtest BAbstained if SubjectType==2,by(SEvP)
prtest AAbstained if SubjectType==1,by(SEvE)
prtest BAbstained if SubjectType==2,by(SEvE)

*footnote52
prtest AAbstained if SubjectType==1&ElectionType=="EC",by(SEvE)
prtest AAbstained if SubjectType==1&ElectionType=="E1",by(SEvE)
prtest AAbstained if SubjectType==1&ElectionType=="E2",by(SEvE)
*footnote53
prtest BAbstained if SubjectType==2&ElectionType=="EC",by(SEvE)
prtest BAbstained if SubjectType==2&ElectionType=="E1",by(SEvE)
prtest BAbstained if SubjectType==2&ElectionType=="E2",by(SEvE)
*footnote54
prtest BAbstained if SubjectType==2,by(SEvP)
prtest BAbstained if SubjectType==2&ElectionType=="EC",by(SEvP)
prtest BAbstained if SubjectType==2&ElectionType=="E1",by(SEvP)
prtest BAbstained if SubjectType==2&ElectionType=="E2",by(SEvP)

prtest AAbstained if SubjectType==1,by(SEvP)
prtest AAbstained if SubjectType==1&ElectionType=="EC",by(SEvP)
prtest AAbstained if SubjectType==1&ElectionType=="E1",by(SEvP)
prtest AAbstained if SubjectType==1&ElectionType=="E2",by(SEvP)


*********************************************************************************
**             Replication of statistical tests in B10                         **
**       Note: The data of TableB5 is derived from Experiment2.dta             **     
*********************************************************************************
*to get the data for Figure 3: Percent Voting for Public Voting Versus Relative Success of A
tabulate WinnerofElection PrivacyType if Treatment=="Short"&Session==1&Period<11&Statistics==1,col
tabulate WinnerofElection PrivacyType if Treatment=="Short"&Session==1&Period<17&Statistics==1,col
tabulate WinnerofElection PrivacyType if Treatment=="Short"&Session==2&Period<11&Statistics==1,col
tabulate WinnerofElection PrivacyType if Treatment=="Short"&Session==2&Period<17&Statistics==1,col
tabulate WinnerofElection PrivacyType if Treatment=="Long"&Session==1&Period<21&Statistics==1,col
tabulate WinnerofElection PrivacyType if Treatment=="Long"&Session==2&Period<21&Statistics==1,col
tabulate WinnerofElection PrivacyType if Treatment=="Long"&Session==3&Period<21&Statistics==1,col
tabulate WinnerofElection PrivacyType if Treatment=="Long"&Session==4&Period<21&Statistics==1,col

tabulate SubjectChoice SubjectType if Treatment=="Short"&Session==1&Period==11&Statistics==0,col
tabulate SubjectChoice SubjectType if Treatment=="Short"&Session==1&Period==17&Statistics==0,col
tabulate SubjectChoice SubjectType if Treatment=="Short"&Session==2&Period==11&Statistics==0,col
tabulate SubjectChoice SubjectType if Treatment=="Short"&Session==2&Period==17&Statistics==0,col
tabulate SubjectChoice SubjectType if Treatment=="Long"&Session==1&Period==21&Statistics==0,col
tabulate SubjectChoice SubjectType if Treatment=="Long"&Session==2&Period==21&Statistics==0,col
tabulate SubjectChoice SubjectType if Treatment=="Long"&Session==3&Period==21&Statistics==0,col
tabulate SubjectChoice SubjectType if Treatment=="Long"&Session==4&Period==21&Statistics==0,col
*Table B5
*Probits of Voting for Secret Ballots
*Open data of TableB5 of Voting for Secret Ballots
clear
use TableB5.dta, clear
gen VoteS=0
replace VoteS=1 if SubjectChoice=="S"
dprobit2 VoteS Difference if SubjectType==1, vce(robust)
dprobit2 VoteS Difference if SubjectType==2, vce(robust)
