***************
* Loading data*
***************
log using "/Users/damienbol/Dropbox/Str competition/submission pp/publication PSRM/Replication data/party_voter_experiment_psrm.log"
use "/Users/damienbol/Dropbox/Str competition/submission pp/publication PSRM/Replication data/party_voter_experiment_psrm.dta", replace

* Structure of the dataset:
* The unit of analysis of the dataset is the experimental subject per election. As we conducted 4 experimental sesions of 20 elections with 17 experimental subjects, there are 1,360 data points (4 x 20 x 17 = 1,360).

* Variables:
* subject_id=unique identifier of experimental subjects
* election_id=unique identifier of elections
* session=unique identifier of sessions
* election=election identifier per session (from 1 to 20)
* subject=subject identifier per session (from 1 to 17)
* series=identifier of election series. Every 5 elections the role of experimental subjects were reshuffled, these 5 elections form a series. There were 4 series per session, so the variable goes from 1 to 4
* uniform_distribution=dummy variable capturing whether the election was held under an uniform distribution of party positions or not (i.e. central distribution, see paper)
* equal_repartition=dummy variable capturing whether the election was held under an equal distribution of party gains or not (i.e. unequal distribution, see paper)
* role_party=dummy variable capturing whether the subjects played the role of a party or not (i.e. a voter)
* party=variable capturing, for subjects playing the role of parties, the subject's party: party A (coded 1), B (coded 2), C (coded 3), D (coded 4), E (coded 5), F (coded 6).
* voter=variable capturing, for subjects playing the role of voters, the subject's position on the 0-10 scale
* initiator=dummy variable capturing, for subjects playing the role of parties, whether she was the initiator of the agreement or not (see paper).
* proposal_type=variable capturing, for subjects playing the role of parties, the type of proposal made by the initiator: no proposal (coded 0), the initiator enters (coded 1), the initiator exits (coded 2).
* response_type=dummy variable capturing, for subjects playing the role of parties, whether the non-initiating accepted or the proposal or not (i.e. rejected)
* vote=variable capturing, for subjects playing the role of voters, for which parties they voted: party A (coded 1), B (coded 2), C (coded 3), D (coded 4), E (coded 5), F (coded 6).
* win=variable capturing, for subjects playing the role of parties, whether they win the election or not

*************************
* Constructing variables*
*************************

* Creating a variable capturing whether party pairs are central or extreme
***************************************************************************

gen party_central=0 if role_party==1
replace party_central=1 if party==3 & role_party==1
replace party_central=1 if party==4 & role_party==1

* Creating a variable capturing how far is the voter from the center of the ideological spectrum
**************************************************************************************************

gen voter_central=abs(voter-5)

* Creating a viable vote variable (theoretical)
************************************************

* 1. Creating variables capturing whether parties participate in the election

gen stay=.
replace stay=0 if response_type==1 & proposal_type==1 & initiator==0
replace stay=0 if response_type==1 & proposal_type==2 & initiator==1
replace stay=1 if stay==.

gen stay_party1=0
gen stay_party2=0
gen stay_party3=0
gen stay_party4=0
gen stay_party5=0
gen stay_party6=0

replace stay_party1=1 if party==1 & stay==1
replace stay_party2=1 if party==2 & stay==1
replace stay_party3=1 if party==3 & stay==1
replace stay_party4=1 if party==4 & stay==1
replace stay_party5=1 if party==5 & stay==1
replace stay_party6=1 if party==6 & stay==1

bysort election_id: egen stay_party1_all=total(stay_party1)
bysort election_id: egen stay_party2_all=total(stay_party2)
bysort election_id: egen stay_party3_all=total(stay_party3)
bysort election_id: egen stay_party4_all=total(stay_party4)
bysort election_id: egen stay_party5_all=total(stay_party5)
bysort election_id: egen stay_party6_all=total(stay_party6)

* 2. Creating a variable capturing whether the vote is viable (theoretically)

gen viable_vote_theory=0
replace viable_vote_theory=1 if vote==3
replace viable_vote_theory=1 if vote==4
replace viable_vote_theory=1 if vote==2 & stay_party3_all==0
replace viable_vote_theory=1 if vote==5 & stay_party4_all==0
replace viable_vote_theory=1 if vote==2 & stay_party4_all==0 & stay_party5_all==0 & uniform_distribution==1
replace viable_vote_theory=1 if vote==5 & stay_party3_all==0 & stay_party2_all==0 & uniform_distribution==1
replace viable_vote_theory=1 if vote==1 & stay_party3_all==0 & stay_party2_all==0  
replace viable_vote_theory=1 if vote==6 & stay_party4_all==0 & stay_party5_all==0  
replace viable_vote_theory=. if role_party==1

* Creating a viable vote variable (empirical)
*********************************************

* 1. Creating variables capturing the number of votes received by the parties

gen vote_party1=0
gen vote_party2=0
gen vote_party3=0
gen vote_party4=0
gen vote_party5=0
gen vote_party6=0

replace vote_party1=1 if vote==1
replace vote_party2=1 if vote==2
replace vote_party3=1 if vote==3
replace vote_party4=1 if vote==4
replace vote_party5=1 if vote==5
replace vote_party6=1 if vote==6

bysort election_id: egen vote_party1_total=total(vote_party1)
bysort election_id: egen vote_party2_total=total(vote_party2)
bysort election_id: egen vote_party3_total=total(vote_party3)
bysort election_id: egen vote_party4_total=total(vote_party4)
bysort election_id: egen vote_party5_total=total(vote_party5)
bysort election_id: egen vote_party6_total=total(vote_party6)

* 2. Creating variables capturing which party(-ies) received the maximum number of votes (and was therefore viable empirically)

gen max_vote_round1=max(vote_party1_total, vote_party2_total, vote_party3_total, vote_party4_total, vote_party5_total, vote_party6) 

gen party1_viable=0
gen party2_viable=0
gen party3_viable=0
gen party4_viable=0
gen party5_viable=0
gen party6_viable=0

replace party1_viable=1 if vote_party1_total==max_vote_round1
replace party2_viable=1 if vote_party2_total==max_vote_round1
replace party3_viable=1 if vote_party3_total==max_vote_round1
replace party4_viable=1 if vote_party4_total==max_vote_round1
replace party5_viable=1 if vote_party5_total==max_vote_round1
replace party6_viable=1 if vote_party6_total==max_vote_round1

* 3. Creating a variable capturing how many parties recieved the maximum number of votes

gen count_party_viable_round1=party1_viable+party2_viable+party3_viable+party4_viable+party5_viable+party6_viable

* 4. Creating a variable capturing the second maximum number of votes obtained by a party

gen max_vote_round2=.
replace max_vote_round2=max(vote_party1_total, vote_party2_total, vote_party3_total, vote_party4_total, vote_party5_total) if party6_viable==1 & count_party_viable_round1==1
replace max_vote_round2=max(vote_party1_total, vote_party2_total, vote_party3_total, vote_party4_total, vote_party6_total) if party5_viable==1 & count_party_viable_round1==1
replace max_vote_round2=max(vote_party1_total, vote_party2_total, vote_party3_total, vote_party5_total, vote_party6_total) if party4_viable==1 & count_party_viable_round1==1
replace max_vote_round2=max(vote_party1_total, vote_party2_total, vote_party4_total, vote_party5_total, vote_party6_total) if party3_viable==1 & count_party_viable_round1==1
replace max_vote_round2=max(vote_party1_total, vote_party3_total, vote_party4_total, vote_party5_total, vote_party6_total) if party2_viable==1 & count_party_viable_round1==1
replace max_vote_round2=max(vote_party2_total, vote_party3_total, vote_party4_total, vote_party5_total, vote_party6_total) if party1_viable==1 & count_party_viable_round1==1

* 5. Updating the (empirical) viable vote variables for elections in which there were only one party with the maximum number of votes

replace party1_viable=1 if vote_party1_total==max_vote_round2 & count_party_viable_round1==1
replace party2_viable=1 if vote_party2_total==max_vote_round2 & count_party_viable_round1==1
replace party3_viable=1 if vote_party3_total==max_vote_round2 & count_party_viable_round1==1
replace party4_viable=1 if vote_party4_total==max_vote_round2 & count_party_viable_round1==1
replace party5_viable=1 if vote_party5_total==max_vote_round2 & count_party_viable_round1==1
replace party6_viable=1 if vote_party6_total==max_vote_round2 & count_party_viable_round1==1

* 6. Checking on average how many parties were viable (empirically)

gen count_party_viable_round2=party1_viable+party2_viable+party3_viable+party4_viable+party5_viable+party6_viable

tab count_party_viable_round2

* 7. Creating a variable caputring whether the vote is viable (empirically)

gen viable_vote_empirics=0
replace viable_vote_empirics=1 if vote==1 & party1_viable==1
replace viable_vote_empirics=1 if vote==2 & party2_viable==1
replace viable_vote_empirics=1 if vote==3 & party3_viable==1
replace viable_vote_empirics=1 if vote==4 & party4_viable==1
replace viable_vote_empirics=1 if vote==5 & party5_viable==1
replace viable_vote_empirics=1 if vote==6 & party6_viable==1
replace viable_vote_empirics=. if role_party==1

* Calculating a desertion variable (with empirical definition of strategic voting)
**********************************************************************************

* 1. Creating variables capturing whether each party is a sincere vote or not 

gen party1_sincere=0
gen party2_sincere=0
gen party3_sincere=0
gen party4_sincere=0
gen party5_sincere=0
gen party6_sincere=0

replace party1_sincere=1 if voter==0 & stay_party1_all==1
replace party2_sincere=1 if voter==0 & stay_party1_all==0
replace party6_sincere=1 if voter==10 & stay_party6_all==1
replace party5_sincere=1 if voter==10 & stay_party6_all==0

replace party1_sincere=1 if voter==1 & stay_party1_all==1
replace party2_sincere=1 if voter==1 & stay_party2_all==1 & uniform_distribution==1
replace party2_sincere=1 if voter==1 & stay_party1_all==0 & uniform_distribution==0

replace party6_sincere=1 if voter==9 & stay_party6_all==1
replace party5_sincere=1 if voter==9 & stay_party5_all==1 & uniform_distribution==1
replace party5_sincere=1 if voter==9 & stay_party6_all==0 & uniform_distribution==0

replace party2_sincere=1 if voter==2 & stay_party2_all==1 & uniform_distribution==1
replace party1_sincere=1 if voter==2 & stay_party2_all==0 & uniform_distribution==1
replace party3_sincere=1 if voter==2 & stay_party2_all==0 & uniform_distribution==1 & stay_party3_all==1
replace party1_sincere=1 if voter==2 & stay_party1_all==1 & uniform_distribution==0
replace party2_sincere=1 if voter==2 & stay_party1_all==0 & uniform_distribution==0

replace party5_sincere=1 if voter==8 & stay_party5_all==1 & uniform_distribution==1
replace party6_sincere=1 if voter==8 & stay_party5_all==0 & uniform_distribution==1
replace party4_sincere=1 if voter==8 & stay_party5_all==0 & uniform_distribution==1 & stay_party4_all==1
replace party6_sincere=1 if voter==8 & stay_party6_all==1 & uniform_distribution==0
replace party5_sincere=1 if voter==8 & stay_party6_all==0 & uniform_distribution==0

replace party2_sincere=1 if voter==3 & stay_party2_all==1 & uniform_distribution==1
replace party3_sincere=1 if voter==3 & stay_party3_all==1 & uniform_distribution==1
replace party1_sincere=1 if voter==3 & stay_party2_all==0 & stay_party3_all==0 & uniform_distribution==1
replace party4_sincere=1 if voter==3 & stay_party2_all==0 & stay_party3_all==0 & uniform_distribution==1
replace party2_sincere=1 if voter==3 & stay_party2_all==1 & uniform_distribution==0
replace party1_sincere=1 if voter==3 & stay_party2_all==0 & uniform_distribution==0
replace party3_sincere=1 if voter==3 & stay_party2_all==0 & uniform_distribution==0 & stay_party3_all==1

replace party5_sincere=1 if voter==7 & stay_party5_all==1 & uniform_distribution==1
replace party4_sincere=1 if voter==7 & stay_party4_all==1 & uniform_distribution==1
replace party6_sincere=1 if voter==7 & stay_party5_all==0 & stay_party4_all==0 & uniform_distribution==1
replace party3_sincere=1 if voter==7 & stay_party5_all==0 & stay_party4_all==0 & uniform_distribution==1
replace party5_sincere=1 if voter==7 & stay_party5_all==1 & uniform_distribution==0
replace party6_sincere=1 if voter==7 & stay_party5_all==0 & uniform_distribution==0
replace party4_sincere=1 if voter==7 & stay_party5_all==0 & uniform_distribution==0 & stay_party4_all==1

replace party3_sincere=1 if voter==4 & stay_party3_all==1
replace party4_sincere=1 if voter==4 & stay_party3_all==0 & uniform_distribution==1
replace party2_sincere=1 if voter==4 & stay_party3_all==0 & uniform_distribution==1 & stay_party2_all==1
replace party2_sincere=1 if voter==4 & stay_party3_all==0 & stay_party2_all==1 & uniform_distribution==0
replace party1_sincere=1 if voter==4 & stay_party3_all==0 & stay_party2_all==0 & uniform_distribution==0
replace party4_sincere=1 if voter==4 & stay_party3_all==0 & stay_party2_all==0 & uniform_distribution==0

replace party4_sincere=1 if voter==6 & stay_party4_all==1
replace party3_sincere=1 if voter==6 & stay_party4_all==0 & uniform_distribution==1
replace party5_sincere=1 if voter==6 & stay_party4_all==0 & uniform_distribution==1 & stay_party5_all==1
replace party5_sincere=1 if voter==6 & stay_party4_all==0 & stay_party5_all==1 & uniform_distribution==0
replace party6_sincere=1 if voter==6 & stay_party4_all==0 & stay_party5_all==0 & uniform_distribution==0
replace party3_sincere=1 if voter==6 & stay_party4_all==0 & stay_party5_all==0 & uniform_distribution==0

replace party3_sincere=1 if voter==5 & stay_party3_all==1
replace party4_sincere=1 if voter==5 & stay_party4_all==1

replace party1_sincere=. if role_party==1
replace party2_sincere=. if role_party==1
replace party3_sincere=. if role_party==1
replace party4_sincere=. if role_party==1
replace party5_sincere=. if role_party==1
replace party6_sincere=. if role_party==1

* 2. Creating a variable capturing whether voter are potential strategic deserters (i.e. whetehr they sincere vote is not viable)

gen potential_strategic=1
replace potential_strategic=0 if party1_viable==1 & party1_sincere==1
replace potential_strategic=0 if party2_viable==1 & party2_sincere==1
replace potential_strategic=0 if party3_viable==1 & party3_sincere==1
replace potential_strategic=0 if party4_viable==1 & party4_sincere==1
replace potential_strategic=0 if party5_viable==1 & party5_sincere==1
replace potential_strategic=0 if party6_viable==1 & party6_sincere==1

replace potential_strategic=. if role_party==1

* 3. Creating a variable capturing whether potential strategic voters voterd for a viable party

gen strategic_deserter=0
replace strategic_deserter=1 if potential_strategic==1 & viable_vote_empirics==1

replace strategic_deserter=. if role_party==1

* Calculating ENP
*****************

* 1. Calculating a variable capturing the number of voters

gen number_voters=vote_party1_total+vote_party2_total+vote_party3_total+vote_party4_total+vote_party5_total+vote_party6_total

* 2. Calculating variables capturing vote shares

gen voteshare_party1=vote_party1_total/number_voters
gen voteshare_party2=vote_party2_total/number_voters
gen voteshare_party3=vote_party3_total/number_voters
gen voteshare_party4=vote_party4_total/number_voters
gen voteshare_party5=vote_party5_total/number_voters
gen voteshare_party6=vote_party6_total/number_voters

* 3. Calculating variable capturing ENP

bysort election_id: gen ENP=1 / ( (voteshare_party1^2) + (voteshare_party2^2)  + (voteshare_party3^2) + (voteshare_party4^2)  + (voteshare_party5^2)  + (voteshare_party6^2))

* Calculating degree of reduction (parties)
*******************************************

* 1. Caclulating a variable capturing the maximum ENP for parties

gen ENP_max_party=1/( ((1.5/11)^2)+((2/11)^2)+((2/11)^2)+((2/11)^2)+((2/11)^2)+((1.5/11)^2)) if uniform_distribution==1
replace ENP_max_party=1/( ((3/11)^2)+((1/11)^2)+((1.5/11)^2)+((1.5/11)^2)+((1/11)^2)+((3/11)^2)) if uniform_distribution==0

* 2. Caclulating a variable capturing the minimal ENP for parties

gen ENP_min_party=1/ ( ((3.5/11)^2)+((5/11)^2)+((2.5/11)^2)) if uniform_distribution==1
replace ENP_min_party=1/ ( ((5.5/11)^2)+((2/11)^2)+((3.5/11)^2)) if uniform_distribution==0

* 3. Calculating a variable capturing what would be the ENP in the sincere votes scenario in all parties configurations

gen number_parties=(stay_party1_all+stay_party2_all+stay_party3_all+stay_party4_all+stay_party5_all+stay_party6_all)

gen ENP_party=1/ ( ((3.5/11)^2)+((5/11)^2)+((2.5/11)^2)) if uniform_distribution==1 & stay_party1_all==1 & stay_party4_all==1 & stay_party6_all==1 & number_parties==3
replace ENP_party=1/ ( ((3.5/11)^2)+((5/11)^2)+((2.5/11)^2)) if uniform_distribution==1 & stay_party6_all==1 & stay_party3_all==1 & stay_party1_all==1 & number_parties==3

replace ENP_party=1/ ( ((4.5/11)^2)+((4/11)^2)+((2.5/11)^2)) if uniform_distribution==1 & stay_party2_all==1 & stay_party4_all==1 & stay_party6_all==1 & number_parties==3
replace ENP_party=1/ ( ((3.5/11)^2)+((3/11)^2)+((4.5/11)^2)) if uniform_distribution==1 & stay_party2_all==1 & stay_party3_all==1 & stay_party5_all==1 & number_parties==3

replace ENP_party=1/ ( ((3.5/11)^2)+((3/11)^2)+((4.5/11)^2)) if uniform_distribution==1 & stay_party2_all==1 & stay_party3_all==1 & stay_party5_all==1 & number_parties==3
replace ENP_party=1/ ( ((3.5/11)^2)+((3/11)^2)+((4.5/11)^2)) if uniform_distribution==1 & stay_party5_all==1 & stay_party4_all==1 & stay_party2_all==1 & number_parties==3

replace ENP_party=1/ ( ((3.5/11)^2)+((4/11)^2)+((3.5/11)^2)) if uniform_distribution==1 & stay_party1_all==1 & stay_party4_all==1 & stay_party5_all==1 & number_parties==3
replace ENP_party=1/ ( ((3.5/11)^2)+((4/11)^2)+((3.5/11)^2)) if uniform_distribution==1 & stay_party6_all==1 & stay_party3_all==1 & stay_party4_all==1 & number_parties==3

replace ENP_party=1/ ( ((4.5/11)^2)+((3/11)^2)+((2/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party1_all==0 & stay_party3_all==0 & number_parties==4
replace ENP_party=1/ ( ((4.5/11)^2)+((3/11)^2)+((2/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party6_all==0 & stay_party4_all==0 & number_parties==4

replace ENP_party=1/ ( ((3.5/11)^2)+((4/11)^2)+((2/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party1_all==0 & stay_party4_all==0 & number_parties==4
replace ENP_party=1/ ( ((3.5/11)^2)+((4/11)^2)+((2/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party6_all==0 & stay_party3_all==0 & number_parties==4

replace ENP_party=1/ ( ((3.5/11)^2)+((2/11)^2)+((4/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party1_all==0 & stay_party5_all==0 & number_parties==4
replace ENP_party=1/ ( ((3.5/11)^2)+((2/11)^2)+((4/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party6_all==0 & stay_party2_all==0 & number_parties==4

replace ENP_party=1/ ( ((3.5/11)^2)+((4/11)^2)+((2/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party2_all==0 & stay_party3_all==0 & number_parties==4
replace ENP_party=1/ ( ((3.5/11)^2)+((4/11)^2)+((2/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party5_all==0 & stay_party4_all==0 & number_parties==4

replace ENP_party=1/ ( ((2.5/11)^2)+((4/11)^2)+((3/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party2_all==0 & stay_party4_all==0 & number_parties==4
replace ENP_party=1/ ( ((2.5/11)^2)+((4/11)^2)+((3/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party5_all==0 & stay_party3_all==0 & number_parties==4

replace ENP_party=1/ ( ((3.5/11)^2)+((2/11)^2)+((2/11)^2) + ((3.5/11)^2)) if uniform_distribution==1 & stay_party1_all==0 & stay_party6_all==0 & number_parties==4

replace ENP_party=1/ ( ((2.5/11)^2)+((3/11)^2)+((3/11)^2) + ((2.5/11)^2)) if uniform_distribution==1 & stay_party2_all==0 & stay_party5_all==0 & number_parties==4

replace ENP_party=1/ ( ((3.5/11)^2)+((2/11)^2)+((2/11)^2) +((2/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party1_all==0 & number_parties==5
replace ENP_party=1/ ( ((3.5/11)^2)+((2/11)^2)+((2/11)^2) +((2/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party6_all==0 & number_parties==5

replace ENP_party=1/ ( ((1.5/11)^2)+((3/11)^2)+((3/11)^2) +((2/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party3_all==0 & number_parties==5
replace ENP_party=1/ ( ((1.5/11)^2)+((3/11)^2)+((3/11)^2) +((2/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party4_all==0 & number_parties==5

replace ENP_party=1/ ( ((2.5/11)^2)+((3/11)^2)+((2/11)^2) +((2/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party2_all==0 & number_parties==5
replace ENP_party=1/ ( ((2.5/11)^2)+((3/11)^2)+((2/11)^2) +((2/11)^2) + ((1.5/11)^2)) if uniform_distribution==1 & stay_party5_all==0 & number_parties==5

replace ENP_party=1/ ( ((4.5/11)^2)+((3/11)^2)+((3.5/11)^2)) if uniform_distribution==0 & stay_party1_all==1 & stay_party4_all==1 & stay_party6_all==1 & number_parties==3
replace ENP_party=1/ ( ((4.5/11)^2)+((3/11)^2)+((2.5/11)^2)) if uniform_distribution==0 & stay_party6_all==1 & stay_party3_all==1 & stay_party1_all==1 & number_parties==3

replace ENP_party=1/ ( ((5.5/11)^2)+((2/11)^2)+((3.5/11)^2)) if uniform_distribution==0 & stay_party2_all==1 & stay_party4_all==1 & stay_party6_all==1 & number_parties==3
replace ENP_party=1/ ( ((5.5/11)^2)+((2/11)^2)+((3.5/11)^2)) if uniform_distribution==0 & stay_party2_all==1 & stay_party3_all==1 & stay_party5_all==1 & number_parties==3

replace ENP_party=1/ ( ((4/11)^2)+((2/11)^2)+((5.5/11)^2)) if uniform_distribution==0 & stay_party2_all==1 & stay_party3_all==1 & stay_party5_all==1 & number_parties==3
replace ENP_party=1/ ( ((4/11)^2)+((2/11)^2)+((5.5/11)^2)) if uniform_distribution==0 & stay_party5_all==1 & stay_party4_all==1 & stay_party2_all==1 & number_parties==3

replace ENP_party=1/ ( ((4.5/11)^2)+((2.5/11)^2)+((4/11)^2)) if uniform_distribution==0 & stay_party1_all==1 & stay_party4_all==1 & stay_party5_all==1 & number_parties==3
replace ENP_party=1/ ( ((4.5/11)^2)+((2.5/11)^2)+((4/11)^2)) if uniform_distribution==0 & stay_party6_all==1 & stay_party3_all==1 & stay_party4_all==1 & number_parties==3

replace ENP_party=1/ ( ((5.5/11)^2)+((1.5/11)^2)+((1/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party1_all==0 & stay_party3_all==0 & number_parties==4
replace ENP_party=1/ ( ((5.5/11)^2)+((1.5/11)^2)+((1/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party6_all==0 & stay_party4_all==0 & number_parties==4

replace ENP_party=1/ ( ((4/11)^2)+((2/11)^2)+((2/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party1_all==0 & stay_party4_all==0 & number_parties==4
replace ENP_party=1/ ( ((4/11)^2)+((2/11)^2)+((2/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party6_all==0 & stay_party3_all==0 & number_parties==4

replace ENP_party=1/ ( ((4/11)^2)+((1.5/11)^2)+((2/11)^2) + ((3.5/11)^2)) if uniform_distribution==0 & stay_party1_all==0 & stay_party5_all==0 & number_parties==4
replace ENP_party=1/ ( ((4/11)^2)+((1.5/11)^2)+((2/11)^2) + ((3.5/11)^2)) if uniform_distribution==0 & stay_party6_all==0 & stay_party2_all==0 & number_parties==4

replace ENP_party=1/ ( ((4/11)^2)+((2.5/11)^2)+((1/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party2_all==0 & stay_party3_all==0 & number_parties==4
replace ENP_party=1/ ( ((4/11)^2)+((2.5/11)^2)+((1/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party5_all==0 & stay_party4_all==0 & number_parties==4

replace ENP_party=1/ ( ((3.5/11)^2)+((2.5/11)^2)+((2/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party2_all==0 & stay_party4_all==0 & number_parties==4
replace ENP_party=1/ ( ((3.5/11)^2)+((2.5/11)^2)+((2/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party5_all==0 & stay_party3_all==0 & number_parties==4

replace ENP_party=1/ ( ((4/11)^2)+((1.5/11)^2)+((1.5/11)^2) + ((4/11)^2)) if uniform_distribution==0 & stay_party1_all==0 & stay_party6_all==0 & number_parties==4

replace ENP_party=1/ ( ((3.5/11)^2)+((2/11)^2)+((2/11)^2) + ((3.5/11)^2)) if uniform_distribution==0 & stay_party2_all==0 & stay_party5_all==0 & number_parties==4

replace ENP_party=1/ ( ((4/11)^2)+((1.5/11)^2)+((1.5/11)^2) +((1/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party1_all==0 & number_parties==5
replace ENP_party=1/ ( ((4/11)^2)+((1.5/11)^2)+((1.5/11)^2) +((1/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party6_all==0 & number_parties==5

replace ENP_party=1/ ( ((3/11)^2)+((2/11)^2)+((2/11)^2) +((1/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party3_all==0 & number_parties==5
replace ENP_party=1/ ( ((3/11)^2)+((2/11)^2)+((2/11)^2) +((1/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party4_all==0 & number_parties==5

replace ENP_party=1/ ( ((3.5/11)^2)+((2/11)^2)+((1.5/11)^2) +((1/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party2_all==0 & number_parties==5
replace ENP_party=1/ ( ((3.5/11)^2)+((2/11)^2)+((1.5/11)^2) +((1/11)^2) + ((3/11)^2)) if uniform_distribution==0 & stay_party5_all==0 & number_parties==5

replace ENP_party=ENP_max_party if number_parties==6

* 4. Calculating the degree of reduction of parties

gen share_reduction_party=(ENP_max_party-ENP_party)/(ENP_max_party-ENP_min_party)
replace share_reduction_party=1 if share_reduction_party>1
replace share_reduction_party=0 if share_reduction_party<0

* Calculating degree of reduction (voters)
******************************************

* 1. Caclulating a variable capturing the maximum ENP for voters

gen ENP_max_voter=ENP_party

* 2. Caclulating a variable capturing the minimal ENP for voters

gen ENP_min_voter=1/ ( ((3.5/11)^2)+((7.5/11)^2)) if uniform_distribution==1 & stay_party2_all==0 & stay_party3_all==0 & stay_party5==0
replace ENP_min_voter=1/ ( ((3.5/11)^2)+((7.5/11)^2)) if uniform_distribution==1 & stay_party5_all==0 & stay_party4_all==0 & stay_party2==0

replace ENP_min_voter=1/ ( ((3.5/11)^2)+((7.5/11)^2)) if uniform_distribution==1 & stay_party2_all==0 & stay_party3_all==0 & stay_party5==1
replace ENP_min_voter=1/ ( ((3.5/11)^2)+((7.5/11)^2)) if uniform_distribution==1 & stay_party5_all==0 & stay_party4_all==0 & stay_party2==1

replace ENP_min_voter=1/ ( ((4.5/11)^2)+((6.5/11)^2)) if uniform_distribution==1 & stay_party2_all==1 & stay_party3_all==0
replace ENP_min_voter=1/ ( ((4.5/11)^2)+((6.5/11)^2)) if uniform_distribution==1 & stay_party5_all==1 & stay_party4_all==0

replace ENP_min_voter=1/ ( ((4.5/11)^2)+((6.5/11)^2)) if uniform_distribution==0 & stay_party2_all==0 & stay_party3_all==0 & stay_party5==0
replace ENP_min_voter=1/ ( ((4.5/11)^2)+((6.5/11)^2)) if uniform_distribution==0 & stay_party5_all==0 & stay_party4_all==0 & stay_party2==0

replace ENP_min_voter=1/ ( ((4.5/11)^2)+((6.5/11)^2)) if uniform_distribution==0 & stay_party2_all==0 & stay_party3_all==0 & stay_party5==1
replace ENP_min_voter=1/ ( ((4.5/11)^2)+((6.5/11)^2)) if uniform_distribution==0 & stay_party5_all==0 & stay_party4_all==0 & stay_party2==1

replace ENP_min_voter=1/ ( ((5/11)^2)+((6/11)^2)) if uniform_distribution==0 & stay_party2_all==1 & stay_party3_all==0
replace ENP_min_voter=1/ ( ((5/11)^2)+((6/11)^2)) if uniform_distribution==0 & stay_party5_all==1 & stay_party4_all==0

replace ENP_min_voter=1/ ( ((5.5/11)^2)+((5.5/11)^2)) if stay_party3_all==1 & stay_party4_all==1

* 3. Calculating the degree of reduction of voters

gen share_reduction_voter=(ENP_max_voter-ENP)/(ENP_max_voter-ENP_min_voter)
replace share_reduction_voter=1 if share_reduction_voter>1
replace share_reduction_voter=0 if share_reduction_voter<0

***********
* Analyses*
***********

* Winning rate of each party (Table 3)
**************************************

tab party win if role_party==1, ro
tab party win if equal_repartition==1 & role_party==1, ro
tab party win if equal_repartition==0 & role_party==1, ro
tab party win if uniform_distribution==1 & role_party==1, ro 
tab party win if uniform_distribution==0 & role_party==1, ro

* Predicting viable vote (Table 4)
**********************************

* 1. Descriptive stats

tab viable_vote_theory if role_party==0
tab viable_vote_theory equal_repartition if role_party==0, chi col
tab viable_vote_theory uniform_distribution if role_party==0, chi col

tab viable_vote_empirics if role_party==0
tab viable_vote_empirics equal_repartition if role_party==0, chi col
tab viable_vote_empirics uniform_distribution if role_party==0, chi col

* 2. Caluclating number of alliances 

bysort election_id: egen number_temp3=total(response_type) if initiator==1 & role==1
bysort election_id: egen number_alliances=max(number_temp3)

* 3. Running regressions

logit viable_vote_theory number_alliances uniform_distribution equal_repartition election voter_central serie i.session  if role_party==0
margins, dydx(*) atmeans
logit viable_vote_empirics number_alliances uniform_distribution equal_repartition election voter_central serie i.session if role_party==0
margins, dydx(*) atmeans


* 4. Calculating predicted probabilities

quietly logit viable_vote_theory number_alliances uniform_distribution equal_repartition election serie i.session  if role_party==0
margins, atmeans at(uniform_distribution=(0 1))
margins, atmeans at(equal_repartition=(0 1))

quietly logit viable_vote_empirics number_alliances uniform_distribution equal_repartition election serie i.session if role_party==0
margins, atmeans at(uniform_distribution=(0 1))
margins, atmeans at(equal_repartition=(0 1))

* 5. Describing strategic deserters

tab strategic_deserter potential_strategic, ro col
tab uniform_distribution potential_strategic, ro col

* Predicting alliances (Table 5)
********************************

* 1. Descriptive stats

tab response_type if role_party==1 & initiator==1
tab response_type equal_repartition if role_party==1 & initiator==1, chi col
tab response_type uniform_distribution if role_party==1 & initiator==1, chi col

* 2. Running regressions

logit response_type uniform_distribution equal_repartition election party_central serie i.session if initiator==1 & role_party==1
margins, dydx(*) atmeans

* 3. Calculating predicted probabilities

quietly logit response_type uniform_distribution equal_repartition election serie i.session if initiator==1 & role_party==1
margins, atmeans at(uniform_distribution=(0 1))
margins, atmeans at(equal_repartition=(0 1))

* Summary statistics of reduction (Table 6)
*******************************************

sum ENP if subject==1
ttest ENP if subject==1, by(equal_repartition)
ttest ENP if subject==1, by(uniform_distribution)

sum share_reduction_party if subject==1
ttest share_reduction_party if subject==1, by(equal_repartition)
ttest share_reduction_party if subject==1, by(uniform_distribution)

sum share_reduction_voter if subject==1
ttest share_reduction_voter if subject==1, by(equal_repartition)
ttest share_reduction_voter if subject==1, by(uniform_distribution)

ttest share_reduction_voter==share_reduction_party if subject==1
ttest share_reduction_voter==share_reduction_party if subject==1 & equal_repartition==1
ttest share_reduction_voter==share_reduction_party if subject==1 & equal_repartition==0
ttest share_reduction_voter==share_reduction_party if subject==1 & uniform_distribution==1
ttest share_reduction_voter==share_reduction_party if subject==1 & uniform_distribution==0

* Predicting reduction (Table 7)
********************************

* 1. Expanding dataset and constructing degrees of reduction

expand 2, generate(id_exp)

gen share_reduction=share_reduction_voter if id_exp==0
replace share_reduction=share_reduction_party if id_exp==1

replace role_party=1 if id_exp==1
replace role_party=0 if id_exp==0

* 2. Running regression

reg share_reduction role_party uniform_distribution equal_repartition election serie i.session if subject==1

* 3. Calculating predicted values

margins, atmeans at(role_party=(0 1))
