/* GetlinearHEI.do */
* This file gets the linearized Healthy Eating Index
		* Restrict to energy_per1>1 so that we don't get outlying HEIs. This parallels what we do in constructing HealthIndex.
		* Note that this script is called by PrepUSDANutritionFacts.do, which interprets this as cals_per100g, but every observation has >1 cals/100g, so the restriction has no impact.


gen rlHEI_per1000Cal = 5*fruits_total_per1000Cal/0.8 + ///
		5*fruits_whole_per1000Cal/0.4 + 5*veggies_per1000Cal/1.1 + 5*greens_beans_per1000Cal/0.2 + ///
		10*whole_grains_per1000Cal/1.5 + 10*dairy_per1000Cal/1.3 + 5*total_protein_per1000Cal/2.5 + ///
		5*sea_plant_prot_per1000Cal/0.8 ///
		+ 10*(4.3-refined_grains_per1000Cal)/(4.3-1.8) ///
		+ 10*(2-sodium_mg_per1000Cal/1000)/(2-1.1) ///
		+ 10*(0.26-added_sugars_per1000Cal*4/1000)/(0.26-0.065) /// added sugars is share of calories, so take added sugars in grams and multiply by 4 to get to calories
		+ 10*(0.16-solid_fats_kcal_per1000Cal/1000)/(0.16-0.08) if energy_per1>1 
		
