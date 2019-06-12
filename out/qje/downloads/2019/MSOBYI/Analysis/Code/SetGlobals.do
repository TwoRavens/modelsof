/* SetGlobals.do */



/* Set additional file paths for JDube01 */
	* These are in SetGlobals.do so that individual do files can be run on JDube01 without running the full FoodDesertsMasterFile.do
if "`c(username)'"=="jdube"|"`c(username)'"=="hallcott"|"`c(username)'"=="rdiamon0" { // All JDube01 usernames. Tells us that the program is running on JDube01
	capture cd /data/FoodDeserts/ // hallcott is HA's username on both Lenovo and JDube01. This allows the program to accommodate either.
	if _rc != 170 {
		global Nielsen = "/nielsen_extracts/"
		global Externals = "/data/desert/Externals/"
	}
}








/* Globals used in Stata programs */
* Ctls global: control variables used in all analyses
global Ctls = "lnIncome lnEduc i.AgeInt HouseholdSize R_* Married Employed WorkHours"
global Ctls_Merge = "lnIncome lnEduc AgeInt HouseholdSize R_* Married Employed WorkHours"
global Ctls_SummStats = "Income Educ Age HouseholdSize R_* Married Employed WorkHours"
global SESCtls = "i.AgeInt HouseholdSize"
global SESCtls_Merge = "AgeInt HouseholdSize"

* Must observe at least this share of calories to include in sample
global MinInSampleCalorieShareObserved = 0.05 

* Health Index and HEI nutrients
global HealthIndexNuts = "Fruit Veg g_fiber_per1000Cal g_sugar_per1000Cal g_fat_sat_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal"
global HEINuts = "sodium_mg_per1000Cal satfat_g_per1000Cal mon_unsat_fat_g_per1000Cal poly_unsat_fat_g_per1000Cal fruits_total_per1000Cal fruits_whole_per1000Cal veggies_per1000Cal greens_beans_per1000Cal whole_grains_per1000Cal refined_grains_per1000Cal dairy_per1000Cal total_protein_per1000Cal sea_plant_prot_per1000Cal added_sugars_per1000Cal solid_fats_kcal_per1000Cal"
global HEINuts_per1 = "sodium_mg_per1 satfat_g_per1 mon_unsat_fat_g_per1 poly_unsat_fat_g_per1 fruits_total_per1 fruits_whole_per1 veggies_per1 greens_beans_per1 whole_grains_per1 refined_grains_per1 dairy_per1 total_protein_per1 sea_plant_prot_per1 added_sugars_per1 solid_fats_kcal_per1"
global HEINuts_ordered = "fruits_total_per1000Cal fruits_whole_per1000Cal veggies_per1000Cal greens_beans_per1000Cal whole_grains_per1000Cal dairy_per1000Cal total_protein_per1000Cal sea_plant_prot_per1000Cal mon_unsat_fat_g_per1000Cal poly_unsat_fat_g_per1000Cal refined_grains_per1000Cal sodium_mg_per1000Cal added_sugars_per1000Cal satfat_g_per1000Cal solid_fats_kcal_per1000Cal"



* Primary dietary quality variable
global HealthVar = "lHEI_per1000Cal" // HealthIndex_per1000Cal

global tstat = "1.96" // For confidence intervals on figures

global MaxYear = 2016 // Most recent year to use in the data
