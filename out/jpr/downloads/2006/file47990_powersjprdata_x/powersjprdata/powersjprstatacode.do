Kathy L. Powers
Stata Code for "Dispute Inititation and Alliance Obligations in Regional Economic Institutions", Journal of Peace Research 43,4, 2006. 
last updated: 7/31/06


summarize cwinit lagdyadreimem lagpcreimem lagptreimem lagdyadreiall lagpcreiall lagptreiall lagdemdyad caprat anyally lagdtrade distance swtreg cwpceyrs _spline1 _spline2 _spline3


Model 1:
xtlogit cwinit lagdyadreimem lagdyadreiall lagdemdyad caprat anyally lagdtrade distance swtreg cwpceyrs _spline1 _spline2 _spline3


Model 2:
xtlogit cwinit lagpcreiall lagptreiall lagdemdyad caprat anyally lagdtrade distance swtreg cwpceyrs _spline1 _spline2 _spline3


Model 3:
xtlogit cwinit lagpcreiall lagpcreimem lagdemdyad caprat anyally lagdtrade distance swtreg cwpceyrs _spline1 _spline2 _spline3


Model 4:
xtlogit cwinit lagptreiall lagptreimem lagdemdyad caprat anyally lagdtrade distance swtreg cwpceyrs _spline1 _spline2 _spline3

Logit models

Predicted probabilities for RTAalliance*Allies: XtLogit Mode2 1 *DV = CWINIT*


================================================================================
*Model 1*
xtlogit cwinit lagreimem lagreiall laganyally lagdtrade distance s_wt_reg capratio cwpceyrs _spline1 _spline2 _spline3
xtlogit cwinit lagreimem

*Predicted probabilities for Dyad REIalliance: XtLogit Model 1 *DV = CWINIT*


*Dyadic Effect of REI alliance*

A.) Baseline: No Dyadic REI membership
generate L1 =  -1.184*0 + -.0606*0 + 1.108*(.0203) + 1.703*(.5000) + 1.012*0 + .0059*1.444 + -.0021*2259.70 + -.5895*.9332 + -.1393*16.59 + -.0009*-4758.37 + .0009*-6382.99 + -.0004*-5444.24 + -4.223   

generate Phat1 = 1/(1+exp (-L1))

display Phat1

label variable Phat1 "P(cwinit >= 1 | lagdyadreiall = 0, lagdyadreimem = 0)


B.) Dyad belongs to REI
generate L2 =  -1.184*0 + -.0606*1 + 1.108*(.0203) + 1.703*(.5000) + 1.012*0 + .0059*1.444 + -.0021*2259.70 + -.5895*.9332 + -.1393*16.59 + -.0009*-4758.37 + .0009*-6382.99 + -.0004*-5444.24 + -4.223   

generate Phat2 = 1/(1+exp (-L2))

display Phat2

label variable Phat2 "P(cwinit >= 1 | lagdyadreiall = 0, lagdyadreimem = 1)


C.) Dyad belongs to REI alliance
generate L3 =  -1.184*1 + -.0606*0 + 1.108*(.0203) + 1.703*(.5000) + 1.012*0 + .0059*1.444 + -.0021*2259.70 + -.5895*.9332 + -.1393*16.59 + -.0009*-4758.37 + .0009*-6382.99 + -.0004*-5444.24 + -4.223   

generate Phat3 = 1/(1+exp (-L3))

display Phat3

label variable Phat3 "P(cwinit >= 1 | lagdyadreiall = 1, lagdyadreimem = 0)

================================================================================
*Model 3: Monadic challenger REI alliance and monadic target REI alliance membership*

xtlogit cwinit lagpcreiall lagpcreimem lagdemdyad caprat anyally lagdtrade distance swtreg cwpceyrs _spline1 _spline2 _spline3


*Monadic Effect of REI Alliances on Challenger State*

A.) Baseline: Challenger has no REI memberships
generate L4 =  -.9473*0 + -.5691*0 + .9752*(.0203) + 1.573*(.5000) + 1.040*0 + .0058*1.444 + -.0021*2259.70 + -.9530*.9332 + -.1462*16.59 + -.0010*-4758.37 + .0009*-6382.99 + -.0004*-5444.24 + -3.794   

generate Phat4 = 1/(1+exp (-L4))

display Phat4

label variable Phat4 "P(cwinit >= 1 | lagpcreiall = 0, lagpcreimem = 0)



B.) Challenger belongs to REI
generate L5 =  -.9473*0 + -.5691*1 + .9752*(.0203) + 1.573*(.5000) + 1.040*0 + .0058*1.444 + -.0021*2259.70 + -.9530*.9332 + -.1462*16.59 + -.0010*-4758.37 + .0009*-6382.99 + -.0004*-5444.24 + -3.794   

generate Phat5 = 1/(1+exp (-L5))

display Phat5

label variable Phat5 "P(cwinit >= 1 | lagpcreiall = 0, lagpcreimem = 1)



C.) Challenger belongs REI alliance
generate 6 =  -.9473*1 + -.5691*0 + .9752*(.0203) + 1.573*(.5000) + 1.040*0 + .0058*1.444 + -.0021*2259.70 + -.9530*.9332 + -.1462*16.59 + -.0010*-4758.37 + .0009*-6382.99 + -.0004*-5444.24 + -3.794   

generate Phat6 = 1/(1+exp (-L6))

display Phat6

label variable Phat6 "P(cwinit >= 1 | lagpcreiall = 1, lagpcreimem = 0)

================================================================================
*Model 4*
xtlogit cwinit lagptreiall lagptreimem lagdemdyad caprat anyally lagdtrade distance swtreg cwpceyrs _spline1 _spline2 _spline3

*Predicted probabilities for Monadic Target REI alliance*Allies: XtLogit Mode4 1 *DV = CWINIT*



*Monadic Effect of REI Alliances on Target*

A.) Baseline: No REI membership
generate L7 =  -.7286*0 + -.5354*0 + 1.003*(.0203) + 1.950*(.5000) + .6926*0 + .0060*1.444 + -.0024*2259.70 + -2.088*.9332 + -.1495*16.59 + -.0012*-4758.37 + .0010*-6382.99 + -.0004*-5444.24 + -2.503   

generate Phat7 = 1/(1+exp (-L7))

display Phat7

label variable Phat7 "P(cwinit >= 1 | ptreiall = 0, ptreimem = 0)



b.)Target belongs to REI alliance
generate L8 =  -.7286*0 + -.5354*1 + 1.003*(.0203) + 1.950*(.5000) + .6926*0 + .0060*1.444 + -.0024*2259.70 + -2.088*.9332 + -.1495*16.59 + -.0012*-4758.37 + .0010*-6382.99 + -.0004*-5444.24 + -2.503   

generate Phat8 = 1/(1+exp (-L8))

display Phat8

label variable Phat8 "P(cwinit >= 1 | ptreiall = 0, ptreimem = 1)



c.)Target belongs to REI 
generate L9 =  -.7286*1 + -.5354*0 + 1.003*(.0203) + 1.950*(.5000) + .6926*0 + .0060*1.444 + -.0024*2259.70 + -2.088*.9332 + -.1495*16.59 + -.0012*-4758.37 + .0010*-6382.99 + -.0004*-5444.24 + -2.503   

generate Phat9 = 1/(1+exp (-L9))

display Phat9

label variable Phat9 "P(cwinit >= 1 | ptreiall = 1, ptreimem = 0)

