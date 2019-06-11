/* FigureTitles.do */
	local title = "`outcome'"
	if "`outcome'" == "SSB" {
		local title="Sugary Drinks"
		local ytitle="Sugary drink calorie share"
	}
	if "`outcome'" == "MilkFatPct" {
		local title="Milkfat"
		local ytitle="Milkfat (percent)"
	}
	if "`outcome'" == "Whole" {
		local title="Whole grain"
		local ytitle="Share whole grain bread"
	}
	if "`outcome'" == "Produce" {
		local title="Produce"
		local ytitle="Produce calorie share"
	}
	if strpos("`outcome'","HealthIndex")!=0 {
		local title="Health Index"
		local ytitle="Health Index"
	}	
	if strpos("`outcome'","lHEI")!=0 {
		local title="Health Index"
		local ytitle="Health Index"
	}	
	if "`outcome'" == "NutrientScore"  {
		local title="Nutrient Score"
		local ytitle="Nutrient Score"
	}
	if "`outcome'" == "ShareCoke" {
		local title="Share coke"
		local ytitle="Coke/(Coke+Pepsi)"
	}
	if "`outcome'" == "lnCalories" {
		local title="Calories"
		local ytitle="ln(Calories)"
	}
	
	
	if "`outcome'" == "Revenue" {
		local title="Revenue"
		local ytitle="Revenue ($ millions/year)"
	}
	if "`outcome'" == "NUPCs" {
		local title="UPC count"
		local ytitle="UPC count"
	}
	
	if strpos("`outcome'","expshare_Entrant")!=0 | strpos("`outcome'","expshare_Eretailer")!=0 {
		local title="Entrant share"
		local ytitle="Entrant exp. share (%)"
	}
	if strpos("`outcome'","expshare_CSC")!=0 {
		local title="Supermarket share"
		local ytitle="Chain groc/super/club exp. share (%)"
	}
	if strpos("`outcome'","expshare_GSC")!=0 {
		local title="Groc/super/club share"
		local ytitle="Groc/super/club exp. share (%)"
	}
				
	*** Health Index macronutrients
	if "`outcome'" == "g_prot_per1000Cal" {
		local title="Protein"
		local ytitle="Grams protein per 1,000 calories"
	}
	if "`outcome'" == "g_fiber_per1000Cal" {
		local title="Fiber"
		local ytitle="Grams fiber per 1,000 calories"
	}
	if "`outcome'" == "g_fat_sat_per1000Cal" {
		local title="Saturated fat"
		local ytitle="Grams saturated fat per 1,000 calories"
	}
	if "`outcome'" == "g_sugar_per1000Cal" {
		local title="Sugar"
		local ytitle="Grams sugar per 1,000 calories"
	}
	if "`outcome'" == "g_sodium_per1000Cal" {
		local title="Sodium"
		local ytitle="Grams sodium per 1,000 calories"
	}
	
	if "`outcome'" == "g_cholest_per1000Cal" {
		local title="Cholesterol"
		local ytitle="Grams cholesterol per 1,000 calories"
	}
	if "`outcome'" == "added_sugars" {
		local title="Added sugar"
		local ytitle="Grams added sugar per 1,000 calories"
	}
	
	*** HEI components
	if "`outcome'" == "sodium_mg_per1000Cal" {
		local title="Sodium"
		local ytitle="Milligrams protein per 1,000 calories"
		local ytitle="mg/1,000 cals"
	}
	if "`outcome'" == "satfat_g_per1000Cal" {
		local title="Saturated fat"
		local ytitle="Grams saturated fat per 1,000 calories"
		local ytitle="g/1,000 cals"
	}
	if "`outcome'" == "mon_unsat_fat_g_per1000Cal" {
		local title="Monounsaturated fat"
		local ytitle="Grams monounsaturated fat per 1,000 calories"
		local ytitle="g/1,000 cals"
	}
	if "`outcome'" == "poly_unsat_fat_g_per1000Cal" {
		local title="Polyunsaturated fat"
		local ytitle="Grams polyunsaturated fat per 1,000 calories"
		local ytitle="g/1,000 cals"
	}
	if "`outcome'" == "fruits_total_per1000Cal" {
		local title="Total fruit"
		local ytitle="Cup equiv. total fruit per 1,000 calories"
		local ytitle="Cups/1,000 cals"
	}
	if "`outcome'" == "fruits_whole_per1000Cal" {
		local title="Whole fruit"
		local ytitle="Cup equiv. whole fruit per 1,000 calories"
		local ytitle="Cups/1,000 cals"
	}
	if "`outcome'" == "veggies_per1000Cal" {
		local title="Vegetables"
		local ytitle="Cup equiv. vegetables per 1,000 calories"
		local ytitle="Cups/1,000 cals"
	}
	if "`outcome'" == "greens_beans_per1000Cal" {
		local title="Greens and beans"
		local ytitle="Cup equiv. greens & beans per 1,000 calories"
		local ytitle="Cups/1,000 cals"
	}
	if "`outcome'" == "whole_grains_per1000Cal" {
		local title="Whole grains"
		local ytitle="Ounces whole grains per 1,000 calories"
		local ytitle="Ounces/1,000 cals"
	}
	if "`outcome'" == "refined_grains_per1000Cal" {
		local title="Refined grains"
		local ytitle="Ounces refined grains per 1,000 calories"
		local ytitle="Ounces/1,000 cals"
	}
	if "`outcome'" == "dairy_per1000Cal" {
		local title="Dairy"
		local ytitle="Cup equiv. dairy per 1,000 calories"
		local ytitle="Cups/1,000 cals"
	}
	if "`outcome'" == "total_protein_per1000Cal" {
		local title="Total protein"
		local ytitle="Ounces protein per 1,000 calories"
		local ytitle="Ounces/1,000 cals"
	}
	if "`outcome'" == "sea_plant_prot_per1000Cal" {
		local title="Sea & plant protein"
		local ytitle="Ounces sea & plant protein per 1,000 calories"
		local ytitle="Ounces/1,000 cals"
	}
	if "`outcome'" == "added_sugars_per1000Cal" {
		local title="Added sugar"
		local ytitle="g/1,000 cals"
	}
	if "`outcome'" == "solid_fats_kcal_per1000Cal" {
		local title="Solid fats"
		local ytitle="Calorie share from solid fats"
		local ytitle="g/1,000 cals"
	}
	
	** For food deserts, add "(Food Deserts)" to the figure title
	if strpos("`outcome'","FD_") {
		local title = "`title' (deserts)"
	}
