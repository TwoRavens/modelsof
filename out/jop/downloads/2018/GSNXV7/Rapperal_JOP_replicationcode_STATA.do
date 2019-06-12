/*
Code for replicating results in:
"The Tolerance of Tamils: War-related Experiences, Psychological Pathways, and the Probability of Granting Civil Liberties to Former Enemies"
Journal of Politics
Carolin Rapp, Sara Kijewski and Markus Freitag
*/


use use_srilanka.dta, clear


******************************************************************************
//descriptive statistics 

*Table 1: war-related distress
tab distress


*Table 2: PCF of posttraumatic growth 
factor E2a-E2j, pcf blanks(0.3)
rotate, promax blanks(0.3)





******************************************************************************
//war=additive index from 0 to 3 (direct, indirect, displacment)

*******************************************************************************
*FIGURE 2

#delimit ; 
sem (distress <- war gender age edu eduf) 
(growth1 <- distress war )
(growth2 <- distress war )
(rights_sinhalese <- war distress growth1 growth2 gender age edu eduf), 
stand
cov(e.distress*e.growth1)
cov(e.distress*e.growth2)
cov(e.growth1*e.growth2)
vce(robust)
;
#delimit cr 

estat mindices 
estat eqgof

*TABLE 5: Direct, indirect and total effects
estat teffects, stand





********************************************************************************
********************************************************************************
//OVERVIEW TABLE - MEAN VALUES 


tabstat distress, by(war01) s(mean sd)
oneway distress war01, scheffe //n.s.

tabstat growth1, by(war01) s(mean sd)
oneway growth1 war01, scheffe //sig

tabstat growth2, by(war01) s(mean sd)
oneway growth2 war01, scheffe //n.s.

tabstat rights_sinhalese, by(war01) s(mean sd)
oneway rights_sinhalese war01, scheffe //n.s.


***gender differences 
tabstat war, by(gender) s(mean sd)
oneway war gender, scheffe //n.s.

tabstat distress, by(gender) s(mean sd)
oneway distress gender, scheffe //n.s.

tabstat growth1, by(gender) s(mean sd)
oneway growth1 gender, scheffe //sig

tabstat growth2, by(gender) s(mean sd)
oneway growth2 gender, scheffe //n.s.

tabstat rights_sinhalese, by(gender) s(mean sd)
oneway rights_sinhalese gender, scheffe //n.s.

//more distress and less growth for females!
//discuss the differences between males and females 
//should we test the models for males/females separately?


********************************************************************************
********************************************************************************
//ESTIMATIONS FOR SUPPLEMENTARY MATERIAL
//SINGLE RIGHTS AS DV

***Government position = C30a
#delimit ; 
sem (distress <- war gender age edu) 
(growth1 <- distress war )
(growth2 <- distress war )
(government <- war distress growth1 growth2 age edu), 
stand
cov(e.distress*e.growth1)
cov(e.distress*e.growth2)
cov(e.growth1*e.growth2)
vce(robust)
;
#delimit cr 
estat mindices 


***SPEECH
#delimit ; 
sem (distress <- war gender age edu) 
(growth1 <- distress war )
(growth2 <- distress war )
(speech <- war distress growth1 growth2 age edu), 
stand
cov(e.distress*e.growth1)
cov(e.distress*e.growth2)
cov(e.growth1*e.growth2)
vce(robust)
;
#delimit cr 
estat mindices 
 

***DEMONSTRATION
#delimit ; 
sem (distress <- war gender age edu) 
(growth1 <- distress war )
(growth2 <- distress war )
(demo <- war distress growth1 growth2 age edu), 
stand
cov(e.distress*e.growth1)
cov(e.distress*e.growth2)
cov(e.growth1*e.growth2)
vce(robust)
;
#delimit cr 
estat mindices 


***TEACH IN PUBLIC SCHOOLS 
#delimit ; 
sem (distress <- war gender age edu eduf) 
(growth1 <- distress war )
(growth2 <- distress war )
(teach <- war distress growth1 growth2 age edu eduf gender), 
cov(e.distress*e.growth1)
cov(e.distress*e.growth2)
cov(e.growth1*e.growth2)
;
#delimit cr 
estat gof, stats(indices residuals)
est store teach 



**************************************************************************
**************************************************************************
//CONTROLLING FOR TSUNAMI EXPERIENCE 

#delimit ; 
sem (distress <- war tsunami gender age edu) 
(growth1 <- distress war tsunami)
(growth2 <- distress war tsunami)
(rights_sinhalese <- war distress growth1 growth2 age), 
stand
cov(e.distress*e.growth1)
cov(e.distress*e.growth2)
cov(e.growth1*e.growth2)
vce(robust)
;
#delimit cr 
estat mindices 




*****************************************************************************
*****************************************************************************
//separate models for males and females 

#delimit ; 
sem (distress <- war age edu eduf) 
(growth1 <- distress war )
(growth2 <- distress war )
(rights_sinhalese <- war distress growth1 growth2 age edu eduf) if gender==1,
cov(e.growth1*e.growth2) 
stand
vce(robust)
;
#delimit cr 







