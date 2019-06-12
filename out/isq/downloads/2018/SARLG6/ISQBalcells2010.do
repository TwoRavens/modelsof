*ISQ Balcells 2010*
**********************************
**********************************
*VIOLENCE LEFT* 
**********************************
**********************************
*Table 2*
**********************************
nbreg executed_left competition frontline population cntaffiliation ugtaffiliation border sea altitude catholiccenter, rob 

zinb executed_left competition frontline population  cntaffiliation ugtaffiliation border sea altitude catholiccenter, inflate(population competition frontline ugtaffiliation border sea altitude) vuong 

**********************************
**********************************
*VIOLENCE RIGHT 
**********************************
*Table 4*
**********************************
nbreg executed_right competition frontline population cntaffiliation ugtaffiliation border sea altitude, rob

nbreg executed_right executed_left competition frontline population cntaffiliation ugtaffiliation  border sea altitude, rob

**********************************
*Table 5*
**********************************
zinb executed_right competition frontline population cntaffiliation ugtaffiliation border sea altitude, inflate(competition cntaffiliation ugtaffiliation frontline border sea altitude population) vuong

zinb executed_right executed_left frontline population competition cntaffiliation ugtaffiliation border sea altitude, inflate(executed_left competition cntaffiliation ugtaffiliation frontline border sea altitude population) vuong

**********************************