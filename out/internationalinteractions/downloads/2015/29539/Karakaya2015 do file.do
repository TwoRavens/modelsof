* REPLICATION INSTRUCTIONS 
*Model 1 (Table 3):
logit oset2 Islam tim tim2 tim3, robust cluster (gwo)
* Model 2(Table 3):
logit oset2 Islam lagrepres lagrepres2 tim tim2 tim3, robust cluster (gwo)
*Model 3(Table 3):
logit oset2 Islam oilrents tim tim2 tim3, robust cluster (gwo)
*Model 4(Table 4):
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam    oilrents  anoc  lagrepres lagrepres2 youthbulge tim tim2 tim3, robust cluster(gwo)
*Model 5(Table 4):
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam     naturalresource anoc  lagrepres lagrepres2  youthbulge tim tim2 tim3, robust cluster(gwo)
*Model 6(Table 4):
 logit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam    oilrents  anoc  lagrepres lagrepres2 youthbulge  christian tim tim2 tim3, robust cluster(gwo)
*Model 7(Table 4):
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam  christian  oilrents  anoc  lagrepres lagrepres2  youthbulge  Islamyouth tim tim2 tim3, robust cluster(gwo)
*Model 8(Table 4):
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam  naturalresource  anoc  lagrepres lagrepres2  youthbulge    Islamyouth tim tim2 tim3, robust cluster(gwo)
*Online Appendix-Table 2: Random-effects model:
xtlogit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam    oilrents  anoc  lagrepres lagrepres2  youthbulge tim tim2 tim3, re
xtlogit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam    naturalresource  anoc  lagrepres lagrepres2  youthbulge  tim tim2 tim3, re
xtlogit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam    oilrents  anoc  lagrepres lagrepres2  youthbulge christian  tim tim2 tim3, re
xtlogit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam    oilrents  anoc  lagrepres lagrepres2  youthbulge christian Islamyouth tim tim2 tim3, re
xtlogit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam   naturalresource  anoc  lagrepres lagrepres2  youthbulge  Islamyouth tim tim2 tim3, re
*Online Appendix-Table 3: Re-logit model (Note: relogit command does not work in Stata 13, Stata 10 is used to run the regressions below):
relogit oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam    oilrents  anoc  lagrepres lagrepres2  youthbulge tim tim2 tim3, cluster (gwo)
relogit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam    naturalresource  anoc  lagrepres lagrepres2  youthbulge  tim tim2 tim3, cluster (gwo)
relogit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam    oilrents  anoc  lagrepres lagrepres2  youthbulge christian  tim tim2 tim3, cluster (gwo)
relogit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam    oilrents  anoc  lagrepres lagrepres2  youthbulge christian Islamyouth tim tim2 tim3, cluster (gwo)
relogit  oset2 ethfrac  relfrac lmtest logpop   lgdp    Islam    naturalresource  anoc  lagrepres lagrepres2  youthbulge  Islamyouth tim tim2 tim3, cluster (gwo)
*Online Appendix-Table 4: Regressions with Muslim Proportion 
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp    muslimprop   oilrents  anoc  lagrepres lagrepres2  youthbulge tim tim2 tim3, robust cluster(gwo)
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp    muslimprop   naturalresource anoc  lagrepres lagrepres2  youthbulge tim tim2 tim3, robust cluster(gwo)
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp  muslimprop    oilrents  anoc  lagrepres lagrepres2  youthbulge  christian tim tim2 tim3, robust cluster(gwo)
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp   muslimprop    oilrents  anoc  lagrepres lagrepres2  youthbulge  Muslimyout  christian tim tim2 tim3, robust cluster(gwo)
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp   muslimprop     naturalresource anoc  lagrepres lagrepres2  youthbulge  Muslimyout   tim tim2 tim3, robust cluster(gwo)
*Online Appendix-Table 5: Logit Estimates of Civil War, 1981-2009 (Number of Battle-deaths>1000)
logit  war ethfrac  relfrac lmtest logpop   lgdp    Islam    oilrents  anoc  lagrepres lagrepres2  youthbulge tim tim2 tim3, robust cluster(gwo)
logit war ethfrac  relfrac lmtest logpop   lgdp    Islam     naturalresource anoc  lagrepres lagrepres2  youthbulge tim tim2 tim3, robust cluster(gwo)
logit  war ethfrac  relfrac lmtest logpop   lgdp    Islam    oilrents  anoc  lagrepres lagrepres2  youthbulge  christian tim tim2 tim3, robust cluster(gwo)
logit  war ethfrac  relfrac lmtest logpop   lgdp    Islam    oilrents  anoc  lagrepres lagrepres2  youthbulge  christian Islamyouth tim tim2 tim3, robust cluster(gwo)
logit  war ethfrac  relfrac lmtest logpop   lgdp    Islam  naturalresource  anoc  lagrepres lagrepres2  youthbulge    Islamyouth tim tim2 tim3, robust cluster(gwo)

*Online Appendix-Table 6: Logit Estimates of Intra-state Conflict, Revised Model with Sunni-Muslim Variable
*gen shiiyout= muslimshii* youthbulge
*gen sunniyout= youthbulge* muslimsunni
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp   muslimsunni    oilrents  anoc  lagrepres lagrepres2  youthbulge tim tim2 tim3, robust cluster(gwo)
logit oset2 ethfrac  relfrac lmtest logpop   lgdp   muslimsunni    naturalresource anoc  lagrepres lagrepres2  youthbulge tim tim2 tim3, robust cluster(gwo)
logit oset2 ethfrac  relfrac lmtest logpop   lgdp    muslimsunni    oilrents  anoc  lagrepres lagrepres2  youthbulge  christian tim tim2 tim3, robust cluster(gwo)
logit oset2 ethfrac  relfrac lmtest logpop   lgdp    muslimsunni    oilrents  anoc  lagrepres lagrepres2  youthbulge  christian sunniyout tim tim2 tim3, robust cluster(gwo)
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp   muslimsunni naturalresource  anoc  lagrepres lagrepres2  youthbulge   sunniyout tim tim2 tim3, robust cluster(gwo)

*Online Appendix-Table 7: Logit Estimates of Intra-state Conflict, Revised Model with Shia-Muslim Variable
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp  muslimshii    oilrents  anoc  lagrepres lagrepres2  youthbulge tim tim2 tim3, robust cluster(gwo)
logit oset2 ethfrac  relfrac lmtest logpop   lgdp  muslimshii    naturalresource anoc  lagrepres lagrepres2  youthbulge tim tim2 tim3, robust cluster(gwo)
logit oset2 ethfrac  relfrac lmtest logpop   lgdp    muslimshii  oilrents  anoc  lagrepres lagrepres2  youthbulge  christian tim tim2 tim3, robust cluster(gwo)
logit oset2 ethfrac  relfrac lmtest logpop   lgdp   muslimshii    oilrents  anoc  lagrepres lagrepres2  youthbulge  christian shiiyout tim tim2 tim3, robust cluster(gwo)
logit  oset2 ethfrac  relfrac lmtest logpop   lgdp  muslimshii naturalresource  anoc  lagrepres lagrepres2  youthbulge   shiiyout tim tim2 tim3, robust cluster(gwo)

*Figure 1: Repression and the Predicted Probability of Intra-state Conflict
*I used Clarify program and created predicted probability of conflict for different values of repression and pasted these predicted values values to dataset to generate Figure 2. 
 estsimp logit  oset2  lagrepres lagrepres2 ethfrac  relfrac lmtest logpop   lgdp    Islam Islamyouth naturalresource  anoc  youthbulge tim tim2 tim3, robust cluster(gwo)
 setx mean
.setx Islam 0 Islamyouth 0 anoc 0 lagrepres 1 lagrepres2 1
.simqi
setx Islam 0 Islamyouth 0 anoc 0 lagrepres 2 lagrepres2 4
.simqi
setx Islam 0 Islamyouth 0 anoc 0 lagrepres 3 lagrepres2 9
.simqi
setx Islam 0 Islamyouth 0 anoc 0 lagrepres 4 lagrepres2 16
.simqi
setx Islam 0 Islamyouth 0 anoc 0 lagrepres 5 lagrepres2 25
.simqi
setx Islam 0 Islamyouth 0 anoc 0 lagrepres 6 lagrepres2 36
.simqi
setx Islam 0 Islamyouth 0 anoc 0 lagrepres 7 lagrepres2 49
.simqi
setx Islam 0 Islamyouth 0 anoc 0 lagrepres 8 lagrepres2 64
.simqi
setx Islam 0 Islamyouth 0 anoc 0 lagrepres 9 lagrepres2 81
.simqi
 twoway (line Propconflict Repression ) (line confit Repression , lpattern(dash)) (line confit2 Repression , lpattern(dash))
 
 *Figure 2: Conditional Impact of Islam on Intra-State Conflict
logit  oset2  Islam youthbulge  Islamyouth ethfrac  relfrac lmtest logpop   lgdp     naturalresource  anoc  lagrepres lagrepres2     tim tim2 tim3, robust cluster(gwo)
matrix b=e(b) 
matrix V=e(V)
scalar b1=b[1,1] 
scalar b3=b[1,3]
scalar varb1=V[1,1] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
gen marg3=b1+(b3*youthbulge) 
gen se3=sqrt(varb1+((youthbulge^2)*varb3)+(2*youthbulge*covb1b3))
gen upper3 = marg3+(se3*1.65)
gen lower3 = marg3-(se3*1.65)
twoway (line marg3 youthbulge, sort clcolor(black)) (line upper3 youthbulge, sort clpattern(dash) clcolor(black))(line lower3 youthbulge, sort clpattern(dash) clcolor(black)), legend(off) yline(0) ytitle(Marginal Effect with 90% C.I.)  xtitle(Proportion of Youth Population)


*Figure 3: Predicted Probability of Civil War and Youth Population in Muslim and NonMuslim Countries:
**I used Clarify program and created predicted probability of conflict for different values of repression and pasted these predicted values values to dataset to generate Figure 3. 

 estsimp logit  oset2 ethfrac  relfrac lmtest logpop   lgdp   Islam  naturalresource  anoc  lagrepres lagrepres2  youthbulge    Islamyouth tim tim2 tim3, robust cluster(gwo)
setx    Islam 1 Islamyouth 0.11 youthbulge 0.11 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 1 Islamyouth 0.15 youthbulge 0.15 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 1 Islamyouth 0.2 youthbulge 0.2 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 1 Islamyouth 0.25 youthbulge 0.25 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 1 Islamyouth 0.3 youthbulge 0.3 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 1 Islamyouth 0.35 youthbulge 0.35 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 1 Islamyouth 0.4 youthbulge 0.4 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 1 Islamyouth 0.45 youthbulge 0.45 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 1 Islamyouth 0.47 youthbulge 0.47 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 0 Islamyouth 0 youthbulge 0.11 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 0 Islamyouth 0 youthbulge 0.15 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 0 Islamyouth 0 youthbulge 0.2 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 0 Islamyouth 0 youthbulge 0.25 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 0 Islamyouth 0 youthbulge 0.3 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 0 Islamyouth 0 youthbulge 0.35 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 0 Islamyouth 0 youthbulge 0.4 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 0 Islamyouth 0 youthbulge 0.45 anoc 0 lagrepres 5 lagrepres2 25
simqi
setx    Islam 0 Islamyouth 0 youthbulge 0.47 anoc 0 lagrepres 5 lagrepres2 25
simqi
drop b1-b16
twoway (line Muslim Youthprop ) (line NonMuslim Youthprop )
