clear

set memory 700m,

insheet using "....txt", clear tab,
/*data including all firms contained in the sample covered by a wage agreement in a given year (between 1994 and 2001) */

/*Main variables
mgtot_jan: dummy variable equal to one if the firm is covered by a wage agreement and if the effect is in January
mgtot_fev: dummy variable equal to one if the firm is covered by a wage agreement and if the effect is in Febraury...

t_ents_yp : size of firms, nb of employees (1 : less than 20 employees, 2: between 20 and 49 employees, 3: between 50 and 99 employees 4 : between 100 and 199 employees 5: between 200 and 499 employees 6: more than 500 employees )
p_smic2 % of minimum wage earners at the local level ina given industry in a given year
indic_acc_rtt: dummy variable for a reducing workweek agreement in a given industry in a given year
anXX dummy variable for years XX
dur_br0 : duration since the last industr-level agreement =0 year
dur_br1 : duration since the last industr-level agreement =1 year 
dur_br2 : duration since the last industr-level agreement =2 years 
nes_ea... industry dummies

*/


generate taille_1= 0
replace taille_1=1 if (t_ents_yp==1)
replace taille_1=1 if (t_ents_yp==2),
generate taille_2= 0
replace taille_2=1 if (t_ents_yp==3),
generate taille_3= 0
replace taille_3=1 if (t_ents_yp==4),
generate taille_4= 0
replace taille_4=1 if (t_ents_yp==5),
generate taille_5= 0
replace taille_5=1 if (t_ents_yp==6),


xtset id an,
xtprobit mgtot_jan p_smic2 taille_2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep , re
mfx, predict(pu0),

xtset id an,
xtprobit mgtot_fev p_smic2 taille_2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep , re
mfx, predict(pu0),

xtset id an,
xtprobit mgtot_mar p_smic2 taille_2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep , re
mfx, predict(pu0),

xtset id an,
xtprobit mgtot_avr p_smic2 taille_2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep , re
 mfx, predict(pu0),

xtset id an,
xtprobit mgtot_mai p_smic2 taille_2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep , re
mfx, predict(pu0),

xtset id an,
xtprobit mgtot_jun p_smic2 taille_2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep , re
mfx, predict(pu0),

xtset id an,
xtprobit mgtot_jul p_smic2 taille_2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep , re
mfx, predict(pu0),

xtset id an,
xtprobit mgtot_aou p_smic2 taille_2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep , re
mfx, predict(pu0),

xtset id an,
xtprobit mgtot_sep p_smic2 taille_2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep , re
mfx, predict(pu0),

xtset id an,
xtprobit mgtot_oct p_smic2 taille_2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep , re
mfx, predict(pu0),

xtset id an,
xtprobit mgtot_nov p_smic2 taille_2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep , re
mfx, predict(pu0),

xtset id an,
xtprobit mgtot_dec p_smic2 taille_2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep , re
mfx, predict(pu0),



clear

set memory 700m,


insheet using "....txt", clear tab,
/*data including all firms contained in the sample where a firm agreement is signed in a given year (between 1994 and 2005) */

/*Main variables
m_acc_sal_jan: dummy variable equal to one if the wage agreement is signed in a firm in January
m_acc_sal_fev: dummy variable equal to one if the wage agreement is signed in a firm in February


t_ents_yp : size of firms, nb of employees (1 : less than 20 employees, 2: between 20 and 49 employees, 3: between 50 and 99 employees 4 : between 100 and 199 employees 5: between 200 and 499 employees 6: more than 500 employees )
p_smic2 % of minimum wage earners at the local level ina given industry in a given year
indic_acc_rtt: dummy variable for a reducing workweek agreement in a given industry in a given year
anXX dummy variable for years XX
dur_br0 : duration since the last industr-level agreement =0 year
dur_br1 : duration since the last industr-level agreement =1 year 
dur_br2 : duration since the last industr-level agreement =2 years 
nes_ea... industry dummies

*/



generate taille_1= 0
replace taille_1=1 if (t_ents_yp==1)
replace taille_1=1 if (t_ents_yp==2),
generate taille_2= 0
replace taille_2=1 if (t_ents_yp==3),
generate taille_3= 0
replace taille_3=1 if (t_ents_yp==4),
generate taille_4= 0
replace taille_4=1 if (t_ents_yp==5),
generate taille_5= 0
replace taille_5=1 if (t_ents_yp==6),



xtset id an,
xtprobit m_acc_sal_jan p_smic2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep if indic_acc_sal==1 , re
mfx, predict(pu0),

xtset id an,
xtprobit m_acc_sal_fev p_smic2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep if indic_acc_sal==1 , re
mfx, predict(pu0),

xtset id an,
xtprobit m_acc_sal_mar p_smic2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep if indic_acc_sal==1 , re
mfx, predict(pu0),

xtset id an,
xtprobit m_acc_sal_avr p_smic2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep if indic_acc_sal==1 , re
mfx, predict(pu0),
 
xtset id an,
xtprobit m_acc_sal_mai p_smic2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep if indic_acc_sal==1 , re
mfx, predict(pu0),

xtset id an,
xtprobit m_acc_sal_jun p_smic2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep if indic_acc_sal==1 , re
mfx, predict(pu0),

xtset id an,
xtprobit m_acc_sal_jul p_smic2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep if indic_acc_sal==1 , re
mfx, predict(pu0),

xtset id an,
xtprobit m_acc_sal_aou p_smic2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep if indic_acc_sal==1 , re
mfx, predict(pu0),

xtset id an,
xtprobit m_acc_sal_sep p_smic2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep if indic_acc_sal==1 , re
mfx, predict(pu0),

xtset id an,
xtprobit m_acc_sal_oct p_smic2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep if indic_acc_sal==1 , re
mfx, predict(pu0),

xtset id an,
xtprobit m_acc_sal_nov p_smic2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep if indic_acc_sal==1 , re
mfx, predict(pu0),

xtset id an,
xtprobit m_acc_sal_dec p_smic2 taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep if indic_acc_sal==1 , re
mfx, predict(pu0),

