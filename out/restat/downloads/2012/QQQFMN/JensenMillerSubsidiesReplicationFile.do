
/*Environment*/
	#delimit ;
	set more 1;
	clear;
	set memory 50m;
	cap log close;

log using regressions, replace;

cd c:\Subsidies\ReplicationFolder\;

use JensenMillerSubsidyData, replace;

	/* create county-time dummies*/
		qui: tab county, gen(county_);
		gen county_time=county*10+round; 
		qui: tab county_time, gen(county_time_);
		qui: tab round, gen(round_);

		svyset, psu(hhid);


/*TABLE 1. MEANS AND STANDARD DEVIATIONS OF KEY VARIABLES*/

	/*FULL SAMPLE*/
	outsum family_size expend_per_capita hh_cals_percap hh_protein_percap hh_satisf_mins hh_satisf_vits
		if person_id==min_p&round==1&subsidy_group==0
		using SampleMeansFull, bracket nolabel nonotes replace;
	outsum family_size expend_per_capita hh_cals_percap hh_protein_percap hh_satisf_mins hh_satisf_vits
		if person_id==min_p&round==1&subsidy_group==10
		using SampleMeansFull, bracket nolabel nonotes append;
	outsum family_size expend_per_capita hh_cals_percap hh_protein_percap hh_satisf_mins hh_satisf_vits
		if person_id==min_p&round==1&subsidy_group==20
		using SampleMeansFull, bracket nolabel nonotes append;
	outsum family_size expend_per_capita hh_cals_percap hh_protein_percap hh_satisf_mins hh_satisf_vits
		if person_id==min_p&round==1&subsidy_group==30
		using SampleMeansFull, bracket nolabel nonotes append;
	/*HUNAN*/
	outsum family_size expend_per_capita hh_cals_percap hh_protein_percap hh_satisf_mins hh_satisf_vits
		if province=="Hunan"&person_id==min_p&round==1&subsidy_group==0
		using SampleMeansHunan, bracket nolabel nonotes replace;
	outsum family_size expend_per_capita hh_cals_percap hh_protein_percap hh_satisf_mins hh_satisf_vits
		if province=="Hunan"&person_id==min_p&round==1&subsidy_group==10
		using SampleMeansHunan, bracket nolabel nonotes append;
	outsum family_size expend_per_capita hh_cals_percap hh_protein_percap hh_satisf_mins hh_satisf_vits
		if province=="Hunan"&person_id==min_p&round==1&subsidy_group==20
		using SampleMeansHunan, bracket nolabel nonotes append;
	outsum family_size expend_per_capita hh_cals_percap hh_protein_percap hh_satisf_mins hh_satisf_vits
		if province=="Hunan"&person_id==min_p&round==1&subsidy_group==30
		using SampleMeansHunan, bracket nolabel nonotes append;
	/*GANSU*/
	outsum family_size expend_per_capita hh_cals_percap hh_protein_percap hh_satisf_mins hh_satisf_vits
		if province=="Gansu"&person_id==min_p&round==1&subsidy_group==0
		using SampleMeansGansu, bracket nolabel nonotes replace;
	outsum family_size expend_per_capita hh_cals_percap hh_protein_percap hh_satisf_mins hh_satisf_vits
		if province=="Gansu"&person_id==min_p&round==1&subsidy_group==10
		using SampleMeansGansu, bracket nolabel nonotes append;
	outsum family_size expend_per_capita hh_cals_percap hh_protein_percap hh_satisf_mins hh_satisf_vits
		if province=="Gansu"&person_id==min_p&round==1&subsidy_group==20
		using SampleMeansGansu, bracket nolabel nonotes append;
	outsum family_size expend_per_capita hh_cals_percap hh_protein_percap hh_satisf_mins hh_satisf_vits
		if province=="Gansu"&person_id==min_p&round==1&subsidy_group==30
		using SampleMeansGansu, bracket nolabel nonotes append;


/*TABLE 1. t-tests of equality of covariates by subsidy group*/

	gen byte sb0=subsidy_group==0;gen byte sb10=subsidy_group==10;
	gen byte sb20=subsidy_group==20;gen byte sb30=subsidy_group==30;
	replace subsidy_group=subsidy_group/10;

	/*FULL SAMPLE*/
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb0 if (sb10==1|sb0==1) &person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb0 if (sb20==1|sb0==1) &person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb0 if (sb30==1|sb0==1) &person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb10 if (sb20==1|sb10==1) &person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb10 if (sb30==1|sb10==1) &person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb20 if (sb30==1|sb20==1) &person_id==min_p&round==1, cluster(hhid);};
	/*HUNAN*/
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb0 if (sb10==1|sb0==1) &province=="Hunan"&person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb0 if (sb20==1|sb0==1) &province=="Hunan"&person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb0 if (sb30==1|sb0==1) &province=="Hunan"&person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb10 if (sb20==1|sb10==1) &province=="Hunan"&person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb10 if (sb30==1|sb10==1) &province=="Hunan"&person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb20 if (sb30==1|sb20==1) &province=="Hunan"&person_id==min_p&round==1, cluster(hhid);};
	/*GANSU*/
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb0 if (sb10==1|sb0==1) &province=="Gansu"&person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb0 if (sb20==1|sb0==1) &province=="Gansu"&person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb0 if (sb30==1|sb0==1) &province=="Gansu"&person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb10 if (sb20==1|sb10==1) &province=="Gansu"&person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb10 if (sb30==1|sb10==1) &province=="Gansu"&person_id==min_p&round==1, cluster(hhid);};
	foreach var of varlist family_size expend_per_capita hh_cals_percap 
		hh_protein_percap	hh_satisf_mins hh_satisf_vits{;
                reg `var' sb20 if (sb30==1|sb20==1) &province=="Gansu"&person_id==min_p&round==1, cluster(hhid);};

	replace subsidy_group=subsidy_group*10;



/*Table 2. Baseline means for individual vitamin and mineral intakes*/
	outsum hh_satisf_calcium hh_satisf_iron hh_satisf_potass hh_satisf_sodium hh_satisf_magnes
 		hh_satisf_phosph hh_satisf_zinc hh_satisf_copper hh_satisf_mangan
		hh_satisf_selenium hh_satisf_vit_c hh_satisf_thiamin hh_satisf_ribofl
		hh_satisf_niacin hh_satisf_panto hh_satisf_folate hh_satisf_vit_b6 hh_satisf_vit_b12 hh_satisf_vit_a
		if round==1 & person==min_p
		using NutrientMeans, bracket nolabel nonotes replace;
	outsum hh_satisf_calcium hh_satisf_iron hh_satisf_potass hh_satisf_sodium hh_satisf_magnes
 		hh_satisf_phosph hh_satisf_zinc hh_satisf_copper hh_satisf_mangan
		hh_satisf_selenium hh_satisf_vit_c hh_satisf_thiamin hh_satisf_ribofl
		hh_satisf_niacin hh_satisf_panto hh_satisf_folate hh_satisf_vit_b6 hh_satisf_vit_b12 hh_satisf_vit_a
		if province=="Hunan"&round==1
		using NutrientMeans, bracket nolabel nonotes append;
	outsum hh_satisf_calcium hh_satisf_iron hh_satisf_potass hh_satisf_sodium hh_satisf_magnes 
 		hh_satisf_phosph hh_satisf_zinc hh_satisf_copper hh_satisf_mangan
		hh_satisf_selenium hh_satisf_vit_c hh_satisf_thiamin hh_satisf_ribofl 
		hh_satisf_niacin hh_satisf_panto hh_satisf_folate hh_satisf_vit_b6 hh_satisf_vit_b12 hh_satisf_vit_a
		if province=="Gansu"&round==1
		using NutrientMeans, bracket nolabel nonotes append;


/*TABLE 3. MEANS OF CONSUMPTION BY FOOD CATEGORIES*/
	outsum hh_rice_calorie_share hh_wheat_noodles_calorie_share hh_cereals_calorie_share hh_veg_fruit_calorie_share 
		hh_all_meat_calorie_share hh_pulses_calorie_share hh_dairy_calorie_share hh_fats_calorie_share
		if person_id==min_p&round==1
		using Means, bracket nolabel nonotes replace;
	outsum hh_rice_calorie_share hh_wheat_noodles_calorie_share hh_cereals_calorie_share hh_veg_fruit_calorie_share 
		hh_all_meat_calorie_share hh_pulses_calorie_share hh_dairy_calorie_share hh_fats_calorie_share
		if province=="Hunan"&person_id==min_p&round==1
		using Means, bracket nolabel nonotes append;
	outsum hh_rice_calorie_share hh_wheat_noodles_calorie_share hh_cereals_calorie_share hh_veg_fruit_calorie_share 
		hh_all_meat_calorie_share hh_pulses_calorie_share hh_dairy_calorie_share hh_fats_calorie_share
		if province=="Gansu"&person_id==min_p&round==1
		using Means, bracket nolabel nonotes append;


/*TABLE 4A, 4B, 4C. MAIN REGRESSIONS*/

	/*4A. FULL SAMPLE*/
	reg pct_ch_hh_calories_percap pct_ch_sub_staple_arc round if person==min_p, cluster(hhid);
	foreach var of varlist pct_ch_hh_protein_percap pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                reg `var' pct_ch_sub_staple_arc round if person==min_p, cluster(hhid);};
	reg pct_ch_hh_calories_percap pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, cluster(hhid);
	foreach var of varlist pct_ch_hh_protein_percap pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                reg `var' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, cluster(hhid);};
	/*note, for experimental set up, convert by hand to elasticities so can compare across specifications*/
	reg hh_calories_percap sub_amt_staple if round==2 & person==min_p, cluster(hhid);
	foreach var of varlist hh_protein_percap hh_satisf_mins hh_satisf_vits {;
                reg `var' sub_amt_staple if round==2 & person==min_p, cluster(hhid);};

	/*4B. HUNAN*/
	reg pct_ch_hh_calories_percap pct_ch_sub_staple_arc round if province=="Hunan" & person==min_p, cluster(hhid);
	foreach var of varlist pct_ch_hh_protein_percap pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                reg `var' pct_ch_sub_staple_arc round if province=="Hunan" & person==min_p, cluster(hhid);};
	reg pct_ch_hh_calories_percap pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Hunan" & person==min_p, cluster(hhid);
	foreach var of varlist pct_ch_hh_protein_percap pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                reg `var' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Hunan" & person==min_p, cluster(hhid);};
	/*note, for experimental set up, convert by hand to elasticities so can compare across specifications*/
	reg hh_calories_percap sub_amt_staple if round==2 & province=="Hunan" & person==min_p, cluster(hhid);
	foreach var of varlist hh_protein_percap hh_satisf_mins hh_satisf_vits {;
                reg `var' sub_amt_staple if round==2 & province=="Hunan" & person==min_p, cluster(hhid);};


	/*4C. GANSU*/
	reg pct_ch_hh_calories_percap pct_ch_sub_staple_arc round if province=="Gansu" & person==min_p, cluster(hhid);
	foreach var of varlist pct_ch_hh_protein_percap pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                reg `var' pct_ch_sub_staple_arc round	if province=="Gansu" & person==min_p, cluster(hhid);};
	reg pct_ch_hh_calories_percap pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Gansu" & person==min_p, cluster(hhid);
	foreach var of varlist pct_ch_hh_protein_percap pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                reg `var' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Gansu" & person==min_p, cluster(hhid);};
	/*note, for experimental set up, convert by hand to elasticities so can compare across specifications*/
	reg hh_calories_percap sub_amt_staple if round==2 &  province=="Gansu" & person==min_p, cluster(hhid);
	foreach var of varlist hh_protein_percap hh_satisf_mins hh_satisf_vits {;
                reg `var' sub_amt_staple if round==2 & province=="Gansu" & person==min_p, cluster(hhid);};


/*INDIVIDUAL NUTRIENTS REGRESSIONS (TABLE 2)*/

	reg pct_ch_hh_satisf_calcium pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, cluster(hhid);
		local all_nutrients "iron potass sodium magnes phosph zinc copper mangan
			selenium vit_c thiamin ribofl niacin panto folate vit_b6 vit_b12 vit_a";
		foreach x of local all_nutrients {;
	reg pct_ch_hh_satisf_`x' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, cluster(hhid);};

	reg pct_ch_hh_satisf_calcium pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p& province=="Hunan", cluster(hhid);
		local all_nutrients "iron potass sodium magnes phosph zinc copper mangan
			selenium vit_c thiamin ribofl niacin panto folate vit_b6 vit_b12 vit_a";
		foreach x of local all_nutrients {;
	reg pct_ch_hh_satisf_`x' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p & province=="Hunan", cluster(hhid);};

	reg pct_ch_hh_satisf_calcium pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p& province=="Gansu", cluster(hhid);
		local all_nutrients "iron potass sodium magnes phosph zinc copper mangan
			selenium vit_c thiamin ribofl niacin panto folate vit_b6 vit_b12 vit_a";
		foreach x of local all_nutrients {;
	reg pct_ch_hh_satisf_`x' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p & province=="Gansu", cluster(hhid);};


/*TABLE 5. ROBUSTNESS*/
	/*NON-ARC*/
	reg pct_ch_hh_calories_percap_na pct_ch_sub_staple_na pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, cluster(hhid);
	foreach var of varlist pct_ch_hh_protein_percap_na pct_ch_hh_satisf_mins_percap_na pct_ch_hh_satisf_vits_percap_na {;
                reg `var' pct_ch_sub_staple_na pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, cluster(hhid);};

	reg pct_ch_hh_calories_percap_na pct_ch_sub_staple_na pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Hunan" & person==min_p, cluster(hhid);
	foreach var of varlist pct_ch_hh_protein_percap_na pct_ch_hh_satisf_mins_percap_na pct_ch_hh_satisf_vits_percap_na {;
                reg `var' pct_ch_sub_staple_na pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Hunan" & person==min_p, cluster(hhid);};

	reg pct_ch_hh_calories_percap_na pct_ch_sub_staple_na pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Gansu" & person==min_p, cluster(hhid);
	foreach var of varlist pct_ch_hh_protein_percap_na pct_ch_hh_satisf_mins_percap_na pct_ch_hh_satisf_vits_percap_na {;
                reg `var' pct_ch_sub_staple_na pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Gansu" & person==min_p, cluster(hhid);};


	/*COUNTY CLUSTERING*/
	reg pct_ch_hh_calories_percap pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, cluster(county);
	foreach var of varlist pct_ch_hh_protein_percap pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                reg `var' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, cluster(county);};

	reg pct_ch_hh_calories_percap pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Hunan" & person==min_p, cluster(county);
	foreach var of varlist pct_ch_hh_protein_percap pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                reg `var' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Hunan" & person==min_p, cluster(county);};

	reg pct_ch_hh_calories_percap pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Gansu" & person==min_p, cluster(county);
	foreach var of varlist pct_ch_hh_protein_percap pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                reg `var' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Gansu" & person==min_p, cluster(county);};


	/*WITH COUNTY*TIME FE*/
	areg pct_ch_hh_calories_percap pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, absorb(county_time) cluster(hhid);
	foreach var of varlist pct_ch_hh_protein_percap pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                areg `var' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, absorb(county_time) cluster(hhid);};

	areg pct_ch_hh_calories_percap pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Hunan" & person==min_p, absorb(county_time) cluster(hhid);
	foreach var of varlist pct_ch_hh_protein_percap pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                areg `var' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Hunan" & person==min_p, absorb(county_time) cluster(hhid);};

	areg pct_ch_hh_calories_percap pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Gansu" & person==min_p, absorb(county_time) cluster(hhid);
	foreach var of varlist pct_ch_hh_protein_percap pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                areg `var' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Gansu" & person==min_p, absorb(county_time) cluster(hhid);};


	/*NOT PER CAPITA*/
	reg pct_ch_hh_calories pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, cluster(hhid);
	foreach var of varlist pct_ch_hh_protein pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                reg `var' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, cluster(hhid);};

	reg pct_ch_hh_calories pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Hunan" & person==min_p, cluster(hhid);
	foreach var of varlist pct_ch_hh_protein pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                reg `var' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Hunan" & person==min_p, cluster(hhid);};

	reg pct_ch_hh_calories pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Gansu" & person==min_p, cluster(hhid);
	foreach var of varlist pct_ch_hh_protein pct_ch_hh_satisf_mins pct_ch_hh_satisf_vits {;
                reg `var' pct_ch_sub_staple_arc pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Gansu" & person==min_p, cluster(hhid);};


	/*CHANGE IN LEVELS, NOT PERCENT*/
	reg ch_hh_calories_percap ch_sub_amt_staple pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, cluster(hhid);
	foreach var of varlist ch_hh_protein_percap ch_hh_satisf_mins ch_hh_satisf_vits {;
                reg `var' ch_sub_amt_staple pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if person==min_p, cluster(hhid);};

	reg ch_hh_calories_percap ch_sub_amt_staple pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Hunan" & person==min_p, cluster(hhid);
	foreach var of varlist ch_hh_protein_percap ch_hh_satisf_mins ch_hh_satisf_vits {;
                reg `var' ch_sub_amt_staple pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Hunan" & person==min_p, cluster(hhid);};

	reg ch_hh_calories_percap ch_sub_amt_staple pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Gansu" & person==min_p, cluster(hhid);
	foreach var of varlist ch_hh_protein_percap ch_hh_satisf_mins ch_hh_satisf_vits {;
                reg `var' ch_sub_amt_staple pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people round
			if province=="Gansu" & person==min_p, cluster(hhid);};


	/*LOG-LOG*/
	reg ch_log_hh_calories_percap ch_log_p_sub_staple ch_log_hh_pay ch_log_hh_nonwage ch_log_hh_people round 
			if person==min_p, cluster(hhid);
	foreach var of varlist ch_log_hh_protein_percap ch_log_hh_satisf_mins ch_log_hh_satisf_vits{;
                reg `var' ch_log_p_sub_staple ch_log_hh_pay ch_log_hh_nonwage ch_log_hh_people round  
			if person==min_p, cluster(hhid);};


	reg ch_log_hh_calories_percap ch_log_p_sub_staple ch_log_hh_pay ch_log_hh_nonwage ch_log_hh_people round 
			if province=="Hunan" & person==min_p, cluster(hhid);
	foreach var of varlist ch_log_hh_protein_percap ch_log_hh_satisf_mins ch_log_hh_satisf_vits{;
                reg `var' ch_log_p_sub_staple ch_log_hh_pay ch_log_hh_nonwage ch_log_hh_people round 
			if province=="Hunan" & person==min_p, cluster(hhid);};

	reg ch_log_hh_calories_percap ch_log_p_sub_staple ch_log_hh_pay ch_log_hh_nonwage ch_log_hh_people round 
			if province=="Gansu" & person==min_p, cluster(hhid);
	foreach var of varlist ch_log_hh_protein_percap ch_log_hh_satisf_mins ch_log_hh_satisf_vits{;
                reg `var' ch_log_p_sub_staple ch_log_hh_pay ch_log_hh_nonwage ch_log_hh_people round 
			if province=="Gansu" & person==min_p, cluster(hhid);};


/*TABLE 6. CHANGES IN CONSUMPTION PATTERNS*/

	global all_foods "nonstaple_cereals veg meat seafood pulses fats foodout non_food";

	reg pct_ch_hh_rice pct_ch_sub_staple_arc round pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people
			if province=="Hunan" & person==min_p, cluster(hhid);

	foreach x of global all_foods {;
	      reg pct_ch_hh_`x' pct_ch_sub_staple_arc round pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people
			if province=="Hunan" & person==min_p, cluster(hhid);};

	reg pct_ch_hh_wheat pct_ch_sub_staple_arc round pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people
		if province=="Gansu"&person_id==min_p, cluster(hhid);
	foreach x of global all_foods {;
            reg pct_ch_hh_`x' pct_ch_sub_staple_arc round pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people
			if province=="Gansu" & person==min_p, cluster(hhid);};


/*TABLE 7--EFFECT ON INCOME, LABOR SUPPLY*/

	foreach var of varlist pct_ch_hh_hours pct_ch_hh_pay pct_ch_hh_nonwage pct_ch_hh_people {;
		reg `var' pct_ch_sub_staple_arc round
			if province=="Hunan"&person_id==min_p, cluster(hhid);};

	foreach var of varlist pct_ch_hh_hours pct_ch_hh_pay pct_ch_hh_nonwage	pct_ch_hh_people {;
		reg `var' pct_ch_sub_staple_arc round   
			if province=="Gansu"&person_id==min_p, cluster(hhid);};
