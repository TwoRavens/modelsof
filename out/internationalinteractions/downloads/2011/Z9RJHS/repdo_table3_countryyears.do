stset count, fail(civilwar_lowlevel) id(ccode)
**Cox Models with different types of shocks**
stcox  recession wardefeat deathinoffice coldwar_new ethpol gdpln popln, robust 
stcox  newshock1 ethpol gdpln popln, robust 

** Cox Models with Interactions**
stcox newshock1  newshock1_w  w opposition popln ethpol gdpln , robust 
stcox newshock1  newshock1_opp opposition w popln ethpol gdpln  newshock1_opp, robust 
