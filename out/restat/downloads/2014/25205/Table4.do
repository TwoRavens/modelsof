clear 
set memory 300m,

insheet using "data industry wage agreements.txt", clear tab,
/*data including all industries whether they sign or not a wage agreement in a given year*/

/*Main variables
dur_a duration sicnce the last wage agreement
p_smic2b % of minimum wage earners at the local level ina given industry in a given year
indic_acc: dummy variable equal to one if there is a wage agreement in a given year 
p_small: proportion of firms with less than  employees in a given industry
serv: dummy variable for "services"
poids_moy : number of employees concerned by the industry agreement
indic_rtt: dummy variable for a reducing worweek agreement in a given industry in a given year
indic_btp: dummy for building sectors
indic_meta: dummy for metalworking industries
anXX dummy variable for years XX


taug_br_a: wage increase contained in the agreement 
*/

/*****gen industry-agreement duration dummies*/
generate dur1= 0
replace dur1=1 if (dur_a==1),
generate dur2= 0
replace dur2=1 if (dur_a==2),
generate dur3= 0
replace dur3=1 if (dur_a==3),
generate dur4= 0
replace dur4=1 if (dur_a >=4),

/*proportion of workers paid the NMW*/
generate p_smic2b=0 
replace p_smic2b=p_smic2/100,

/******************************************/

xtset id an,
xtprobit indic_acc dur1 dur2 dur3 p_small serv poids_moy p_smic2 indic_rtt indic_btp indic_meta an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 , re

/*TOBIT*/
replace taug_br_a=0 if taug_br_a ==.
xtset id an,
xttobit taug_br_a dur1 dur2 dur3 p_small serv poids_moy p_smic2 indic_rtt indic_btp indic_meta an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 ,  ll(0)





insheet using "data effects of industry wage agreements.txt", clear tab,

/*data including all industries whether they are affected or not by a wage agreement in a given year*/

/*Main variables
dur_e duration sicnce the last wage agreement effect
p_smic2b % of minimum wage earners at the local level ina given industry in a given year
indic_nego: dummy variable equal to one if there is a wage agreement effect in a given year 
p_small: proportion of firms with less than  employees in a given industry
serv: dummy variable for "services"
poids_moy : number of employees concerned by the industry agreement
indic_rtt: dummy variable for a reducing worweek agreement in a given industry in a given year
indic_btp: dummy for building sectors
indic_meta: dummy for metalworking industries
anXX dummy variable for years XX


taug_br_e: wage increase contained in the agreement  effect
*/

generate p_smic2b=0 
replace p_smic2b=p_smic2/100 ,

generate dur1= 0
replace dur1=1 if (dur_e==1),
generate dur2= 0
replace dur2=1 if (dur_e==2),
generate dur3= 0
replace dur3=1 if (dur_e==3),
generate dur4= 0
replace dur4=1 if (dur_e >=4),


xtset id an,
xtprobit indic_nego dur1 dur2 dur3 p_small serv poids_moy p_smic2 indic_rtt indic_btp indic_meta an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04 an05, re

/*TOBIT*/
replace taug_br_e=0 if taug_br_e ==.
xtset id an,
xttobit taug_br_e dur1 dur2 dur3 p_small serv poids_moy p_smic2 indic_rtt indic_btp indic_meta an94 an95 an96 an97 an98 an99 an00 an01 an02 an03 an04,  ll(0)


