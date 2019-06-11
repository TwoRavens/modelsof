//Replication materials for "Campaigning for Capital"
//Michael Touchton
//July 27, 2015

//Main document
//all tables stem from the file "Campaigning for Capital Data"

xtset country year

//Table 1

xtreg logportfolio unfairbehavior logGDP growth trade regimeduration FHscore, fe
*unfair behavior decreases portfolio investment (levels)

//Table 1
xtreg logportfolio behaviortime logGDP growth trade regimeduration FHscore, fe
*behaviortime does not influence portfolio investment (levels)


//Table 1
xtreg logportfolio unfairperceptions logGDP growth trade regimeduration FHscore, fe
*unfair perceptions do not influence portfolio investment (levels)


//Table 1
xtreg logportfolio perceptiontime logGDP growth trade regimeduration FHscore, fe
*perceptiontime does not influence portfolio investment (levels)



//Table 2
xtreg logFDI unfairbehavior logGDP growth trade regimeduration FHscore, fe
*unfair behavior does not influence FDI (levels)

//Table 2
xtreg logFDI behaviortime logGDP growth trade regimeduration FHscore, fe
*behaviortime increases FDI (levels)

//Table 2
xtreg logFDI unfairperceptions logGDP growth trade regimeduration FHscore, fe
*unfair perceptions do not influence FDI (levels)

//Table 2
xtreg logFDI perceptiontime logGDP growth trade regimeduration FHscore, fe
*perceptiontime does not increase FDI (levels)



//Table 1 (a)
xtreg portfoliochange unfairperceptionschange d.logGDP d.growth d.trade d.regimeduration d.FHscore
*changes in unfair perceptions increase changes in portfolio investment

//Table 1 (a)
xtreg portfoliochange unfairbehaviorchange d.logGDP d.growth d.trade d.regimeduration d.FHscore
*changes in unfair behavior increase changes in portfolio investment

//Table 1 (a)
xtreg FDIchange unfairbehaviorchange d.logGDP d.growth d.trade d.regimeduration d.FHscore
*changes in unfair behavior do not influence changes in FDI

//Table 1 (a)
xtreg FDIchange unfairperceptionschange d.logGDP d.growth d.trade d.regimeduration d.FHscore
*changes in unfair perceptions do not influence changes in FDI



//Table 1 (b)
xtabond logportfolio unfairbehavior logGDP growth trade regimeduration FHscore y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18 y19 y20 y21 y22 y23, lags(1) artests(2)
*unfair behavior decreases portfolio investment

//Table 1 (b)
xtabond logportfolio unfairperceptions logGDP growth trade regimeduration FHscore y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18 y19 y20 y21 y22 y23, lags(1) artests(2)
*unfair perceptions decrease portfolio investment

//Table 1 (b)
xtabond FDI unfairperceptions logGDP growth trade regimeduration FHscore y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18 y19 y20 y21 y22 y23, lags(1) artests(2)
*unfair perceptions have no influence on FDI

//Table 1 (b)
xtabond FDI unfairbehavior logGDP growth trade regimeduration FHscore y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18 y19 y20 y21 y22 y23, lags(1) artests(2)
*unfair behavior has no influence on FDI
