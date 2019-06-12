/* MagnetTransactionDataPrep.do */

/* GET HOUSEHOLD-BY-GROUP-BY-t DATASET FOR DEMAND ESTIMATION */


/* GET DATASETS FOR REDUCED FORM ESTIMATION */
global Attributes_energy = "rlHEI_per1000Cal added_sugars_per1000Cal" // These are attributes that are weighted by nutrition facts calories in the collapse.
global Attributes_cals = "g_sugar_per1000Cal g_fiber_per1000Cal g_fat_per1000Cal g_fat_sat_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal Whole FreshFruit FreshVeg Fruit Veg rHealthIndex_per1000Cal" // These are weighted by "energy" (calories from the HEI nutrition facts) in the collapse
global Attributes = "$Attributes_cals $Attributes_energy"

/* Collapse to household-by-year data */
global FileName = "HHxYear_Magnet"
global CollapseBy = "household_code panel_year"

include Code/DataPrep/Homescan/CollapseTransactions_Magnet.do

include Code/DataPrep/Homescan/Prep_HHxYear.do

compress
save $Externals/Calculations/Homescan/HHxYear_Magnet.dta, replace
