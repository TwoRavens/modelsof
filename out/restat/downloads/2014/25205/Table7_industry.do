clear 
set memory 700m,

insheet using "....txt", clear tab,

/*data including all industries which sign a wage agreement in a given year*/

/*Main variables
indic_1_a : dummy variable indicating that the wage agreement is signed in January
indic_2_a : dummy variable indicating that the wage agreement is signed in february...
indic_nego: dummy variable equal to one if there is a wage agreement in a given year 
p_smic2 % of minimum wage earners at the local level ina given industry in a given year
indic_btp: dummy for building sectors
indic_meta: dummy for metalworking industries
indic_nat: dummy for national coverage industries
anXX dummy variable for years XX
*/


/******************************************/
xtset id an,
xtprobit indic_1_a p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 if indic_nego==1, re
mfx, predict(pu0),
xtset id an,
xtprobit indic_2_a p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 if indic_nego==1, re
mfx, predict(pu0),

xtset id an,
xtprobit indic_3_a p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 if indic_nego==1, re
mfx, predict(pu0),

xtset id an,
xtprobit indic_4_a p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 if indic_nego==1, re
mfx, predict(pu0),

xtset id an,
xtprobit indic_5_a p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 if indic_nego==1, re
mfx, predict(pu0),

xtset id an,
xtprobit indic_6_a p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 if indic_nego==1, re
mfx, predict(pu0),

xtset id an,
xtprobit indic_7_a p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 if indic_nego==1, re
mfx, predict(pu0),

xtset id an,
xtprobit indic_8_a p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 if indic_nego==1, re
mfx, predict(pu0),

xtset id an,
xtprobit indic_9_a p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 if indic_nego==1, re
mfx, predict(pu0),

xtset id an,
xtprobit indic_10_a p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 if indic_nego==1, re
mfx, predict(pu0),

xtset id an,
xtprobit indic_11_a p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 if indic_nego==1, re
mfx, predict(pu0),

xtset id an,
xtprobit indic_12_a p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 if indic_nego==1, re
mfx, predict(pu0),

clear 
set memory 700m,

insheet using "....txt", clear tab,
/*Main variables
indic_1_e : dummy variable indicating that the wage agreement effect is  in January
indic_2_e : dummy variable indicating that the wage agreement effect is   in february...
indic_acc: dummy variable equal to one if there is a wage agreement effect in a given year 
p_smic2 % of minimum wage earners at the local level ina given industry in a given year
indic_btp: dummy for building sectors
indic_meta: dummy for metalworking industries
indic_nat: dummy for national coverage industries
anXX dummy variable for years XX
*/

/******************************************/
xtset id an,
xtprobit indic_1_e p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 an06 if indic_acc==1, re

xtset id an,
xtprobit indic_2_e p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 an06 if indic_acc==1, re
xtset id an,
xtprobit indic_3_e p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 an06 if indic_acc==1, re
xtset id an,
xtprobit indic_4_e p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 an06 if indic_acc==1, re
xtset id an,
xtprobit indic_5_e p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 an06 if indic_acc==1, re
xtset id an,
xtprobit indic_6_e p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 an06 if indic_acc==1, re
xtset id an,
xtprobit indic_7_e p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 an06 if indic_acc==1, re
xtset id an,
xtprobit indic_8_e p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 an06 if indic_acc==1, re
xtset id an,
xtprobit indic_9_e p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 an06 if indic_acc==1, re
xtset id an,
xtprobit indic_10_e p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 an06 if indic_acc==1, re
xtset id an,
xtprobit indic_11_e p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 an06 if indic_acc==1, re
xtset id an,
xtprobit indic_12_e p_smic2 indic_nat indic_meta serv an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05 an06 if indic_acc==1, re
