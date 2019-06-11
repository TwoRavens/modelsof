*Code for spillover results in Herrnson, Hanmer, and Koh, Political Behavior.
*"Mobilization Around New Convenience Voting Methods: A Field Experiment to Encourage Voting by Mail with a Downloadable Ballot and Early Voting".

*Data: HHK PB spillover data.dta.
**Data only includes those in 2 person HHs.

*Note that to analyze at the HH level a HH member that was not treated was chosen at random to represent the HH for analysis.
**The variable named select1 represents the individual who was randomly selected.


*1) Turnout: Probability of 2 voters in the HH,  by treatment.

reg hh_2voters othmem_treat12 othmem_treat46 othmem_treat37 if select1==1 & treatment==0

*2) Early: Probability of 2 early voters in the HH,  by treatment.

reg hh_2early i.othermember_treat if select1==1 & treatment==0

*3) Regular Mail Absentee: Probability of 2 regular mail voters in the HH,  by treatment.

reg hh_2absmail i.othermember_treat if select1==1 & treatment==0

*4) EABDS: Probability of 2 EABDS voters in the HH,  by treatment.

reg hh_2abseabds i.othermember_treat if select1==1 & treatment==0
