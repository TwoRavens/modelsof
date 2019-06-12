*Replication file for "Flip-Flops and High Heels: An Experimental Analysis of Elite Position Change and Gender on Wartime Public Support by Sarah E. Croco and Scott S. Gartner
*Direct all questions to scroco@umd.edu
*Please note that there are two datasets, spring and winter. The do file indicates when each should be used.

*use spring replication data

*Table 1
*Model 1
logit williams_vote s_consistent agree same_party

*Model 2
logit williams_vote rfw caw raw  same_party if r_war_support==1

*Model 3
logit williams_vote cfw rfw raw same_party if r_war_oppose==1


*Table 2
*Model 4
logit williams_vote s_female agree same_party

*Model 5
ologit strong_leader_scale s_female agree same_party


*Appendix
*Table A1
*Model 6a
logit williams_vote map fap maa faa mpa fpa same_party if r_war_support==1 


*Model 6b
logit williams_vote map fap maa faa mpa fpa same_party if r_war_support==1 & r_male==1


*Model 7a
logit williams_vote mpp fpp map fap mpa fpa same_party if r_war_oppose==1

*Model 7b
logit williams_vote mpp fpp map fap mpa fpa same_party if r_war_oppose==1 & r_male==1


*use winter replication data
*Table A2
*Model 8
logit vote_for_sen rs_agree same_party s_female if r_oppose==1
pre
fitstat
estat clas
