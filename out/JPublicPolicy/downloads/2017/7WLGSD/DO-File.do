
/*Main models: effects of immigration on chauvinism*/

/*Null model*/
meologit immbenefit_right if leftright!=. & female!=. & age!=. & education!=. & subj_income!=. & unemployed!=. & activity!=. & nowork_pop!=. ///
		& EUfeeling!=. & need_social_help!=. & trust_people!=. & trust_system!=. & social_active!=. & ///
		welfare_legitimacy!=. &	EUimm_ess!=. & foreign_born_ess!=. & soc_benefit!=. ||cntry_n: 
		
/*MODEL 1*/
meologit immbenefit_right leftright female age education subj_income unemployed	activity nowork_pop EUfeeling		///
		need_social_help trust_people trust_system social_active welfare_legitimacy			///
		net_migrationESS unemp_level soc_benefit||cntry_n: 

/*MODEL 2*/
meologit immbenefit_right leftright female age education subj_income unemployed	activity nowork_pop EUfeeling		///
		need_social_help trust_people trust_system social_active	welfare_legitimacy			///
		foreign_born unemp_level soc_benefit||cntry_n: 

		
/*MODEL 3*/
meologit immbenefit_right leftright female age education subj_income unemployed	activity nowork_pop EUfeeling		///
		need_social_help trust_people trust_system social_active welfare_legitimacy			///
		EUimm_ess foreign_born_ess soc_benefit||cntry_n: 

		
/*MODEL 4*/
meologit immbenefit_right leftright female age education subj_income unemployed	activity nowork_pop EUfeeling		///
		need_social_help trust_people trust_system social_active	welfare_legitimacy			///
		Euimmigration_level noneu soc_benefit ||cntry_n: 			

		
/*FIGURE 1*/
tab immbenefit_right
gen chauvinist=0 if immbenefit_right<4
replace chauvinist=1 if immbenefit_right>3 & immbenefit_right!=.
tab chauvinist

meologit chauvinist leftright female age education subj_income unemployed	activity nowork_pop EUfeeling		///
		need_social_help trust_people trust_system social_active	welfare_legitimacy			///
		Euimmigration_level noneu soc_benefit ||cntry_n: 			

margins, at(Euimmigration_level==(0(2)12)) predict(outcome(0))  
marginsplot, name(NChauvinist)
margins, at(Euimmigration_level==(0(2)12)) predict(outcome(1))  
marginsplot, name(Chauvinist)

graph combine NChauvinist Chauvinist


/*MODEL 5*/	
meologit immbenefit_right leftright female age education subj_income unemployed	activity nowork_pop EUfeeling		///
		need_social_help trust_people trust_system social_active welfare_legitimacy			///
		eastEU nonEEU foreign_born_ess||cntry_n: 


/*MODEL 6*/
meologit immbenefit_right leftright female age education subj_income unemployed	activity nowork_pop EUfeeling		///
		need_social_help trust_people trust_system social_active welfare_legitimacy			///
		eastEU foreign_born_ess soc_benefit||cntry_n: 

/*MODEL 7*/
meologit immbenefit_right leftright female age education subj_income unemployed	activity nowork_pop EUfeeling		///
		need_social_help trust_people trust_system social_active welfare_legitimacy			///
		eastEU_EU foreign_born_ess soc_benefit||cntry_n: 

/*FIGURE 2*/
meologit chauvinist leftright female age education subj_income unemployed	activity nowork_pop EUfeeling		///
		need_social_help trust_people trust_system social_active welfare_legitimacy			///
		eastEU_EU foreign_born_ess soc_benefit||cntry_n: 

margins, at(eastEU_EU==(0(9)90)) predict(outcome(0) mu fixed)  
marginsplot, name(NChauvinist)
margins, at(eastEU_EU==(0(9)90)) predict(outcome(1) mu fixed)  
marginsplot, name(Chauvinist2)

graph combine NChauvinist Chauvinist 



/*MODEL 8*/	
meologit immbenefit_right leftright female age education subj_income unemployed activity nowork_pop EUfeeling		///
		need_social_help trust_people trust_system social_active welfare_legitimacy			///
		Euimmigration_level c.Euimmigration_level#c.soccontribution soccontribution ||cntry_n: 


