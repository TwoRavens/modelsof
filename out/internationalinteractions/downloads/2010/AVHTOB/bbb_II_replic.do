****Replication file for Braithwaite, Alex, Dennis Foster, & David Sobek (2010) "Ballots, Bargains, and Bombs: Terrorist Targeting of Spoiler Opportunities" International Interactions, in press.**** 

****model 1****
nbreg  fatal_attacks_gtd spoiler_3b4 left intifada  lag_fatal_attacks_gtd, robust

****model 2****
nbreg  fatal_attacks_gtd elect_3b4 peace_3b4 left intifada lag_fatal_attacks_gtd, robust

****model 3****
nbreg  fatal_attacks_gtd elect_cycle peace_3b4 left intifada lag_fatal_attacks_gtd, robust

****model 4****
nbreg  fatal_attacks_gtd spoiler_3b4 left intifada  lag_fatal_attacks_gtd foiledlag1, robust

****model 5 including marginal effects****
nbreg  fatal_attacks_gtd elect_3b4 left_elect left intifada lag_fatal_attacks_gtd, robust
mfx compute, at(left=0, elect_3b4=0)
mfx compute, at(left=0, elect_3b4=1)
mfx compute, at(left=1, elect_3b4=0)
mfx compute, at(left=1, elect_3b4=1)


