clear

set memory 500m,


/*************PROBIT*****************************/
insheet using "data set with fir-level wage agreements and firm-level variables", clear tab,


/*data including all firms with more than 50 employees contained in the sample whether they sign or not a wage agreement in a given year*/

/*Main variables
indic_acc_sal: dummy variable equal to one if there is a wage agreement in a given year in a given firm
prod_s variance of the annual growth of profitability (calculated on the sampel period)
lag_dprodi_fl_s dprodi_fl_s lag and contemporeanous annual growth of profitability 
txchom_ga: U rate variation
p_smic2 % of minimum wage earners at the local level ina given industry in a given year
t_ents_yp : size of firms, nb of employees (1 : less than 20 employees, 2: between 20 and 49 employees, 3: between 50 and 99 employees 4 : between 100 and 199 employees 5: between 200 and 499 employees 6: more than 500 employees )
indic_acc_rtt: dummy variable for a reducing workweek agreement in a given industry in a given year
anXX dummy variable for years XX
dur_br0 : duration since the last industr-level agreement =0 year
dur_br1 : duration since the last industr-level agreement =1 year 
dur_br0 : duration since the last industr-level agreement =2 years 
nes_ea... industry dummies

taug_br_a: wage increase contained in the agreement 
*/



generate inflation= 0
replace inflation=1.8478 if (an94==1)
replace inflation=1.7075 if (an95==1)
replace inflation=1.9937 if (an96==1)
replace inflation=1.7489 if (an97==1)
replace inflation=0.606673407 if (an98==1)
replace inflation=0.201005025 if (an99==1)
replace inflation=1.604814443 if (an00==1)
replace inflation=1.184600197 if (an01==1)
replace inflation=2.243902439 if (an02==1)
replace inflation=2.003816794 if (an03==1)
replace inflation=1.96445276 if (an04==1)
replace inflation=1.559633028 if (an05==1), 

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

generate br0= 0
replace br0=1 if (dur_br0 ==1)
generate br1= 0
replace br1=1 if (dur_br1==1),
generate br2= 0
replace br2=1 if (dur_br2==1),

gen effectif=0
replace effectif=int(moy_yp)

xtset id an,
xtprobit indic_acc_sal prod_s lag_dprodi_fl_s dprodi_fl_s p_smic2 txchom_ga taille_3 taille_4 taille_5 an94 an95 an96 an97 an98 an00 an01 an02 an03 an04 an05 indic_acc_rtt dur_br0 dur_br1 dur_br2 nes_ea nes_eb nes_ec nes_ed nes_ee /*nes_ef*/ nes_eg nes_eh nes_ej nes_ek nes_em nes_en nes_ep 
mfx, predict(pu0)



/************TOBIT****************/
insheet using "....txt", clear tab,


/*data including all firms with more than 50 employees contained in the sample whether they sign or not a wage agreement in a given year (1994-2001)*/

/*Main variables
taug_par_an2: wage increase contained in the wage agreement(0 if no wage agreement)
prod_s variance of the annual growth of profitability (calculated on the sampel period)
lag_dprodi_fl_s dprodi_fl_s lag and contemporeanous annual growth of profitability 
txchom_ga: U rate variation
p_smic2 % of minimum wage earners at the local level ina given industry in a given year
t_ents_yp : size of firms, nb of employees (1 : less than 20 employees, 2: between 20 and 49 employees, 3: between 50 and 99 employees 4 : between 100 and 199 employees 5: between 200 and 499 employees 6: more than 500 employees )
indic_acc_rtt: dummy variable for a reducing workweek agreement in a given industry in a given year
anXX dummy variable for years XX
dur_br0 : duration since the last industr-level agreement =0 year
dur_br1 : duration since the last industr-level agreement =1 year 
dur_br0 : duration since the last industr-level agreement =2 years 
nes_ea... industry dummies

*/
generate inflation= 0
replace inflation=1.8478 if (an94==1)
replace inflation=1.7075 if (an95==1)
replace inflation=1.9937 if (an96==1)
replace inflation=1.7489 if (an97==1)
replace inflation=0.606673407 if (an98==1)
replace inflation=0.201005025 if (an99==1)
replace inflation=1.604814443 if (an00==1)
replace inflation=1.184600197 if (an01==1),


/*1994-2001*/
xtset id annee_fin,
xttobit taug_par_an2 prod_s dprodi_fl_s lag_dprodi_fl_s p_smic2 an94 an95 an96 an97 an98 an99 an00 txchom_ga indic_acc_rtt taille_3 taille_4 taille_5 dur_br0 dur_br1 dur_br2 nes_eb nes_ec nes_ed nes_ee nes_ef nes_eg nes_eh nes_ej nes_ek nes_em nes_en, ll(0)
