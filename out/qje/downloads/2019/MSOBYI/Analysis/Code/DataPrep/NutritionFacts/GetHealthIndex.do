/* GetHealthIndex.do */
* This file takes UPC attributes and determines the health index H(x)
	* Note that the _per1000Cal HealthIndex variables are normalized to mean 0, sd 1 across households for 2004-2013, but the others are not.


/* Get Health Index */
	* Divide each by 100 to get into attributes per gram
gen rHealthIndex_per100g = Fruit*100 /320 + Veg*100 /390

** If have nutrition facts per 100g (e.g. in Magnet nutrition facts):
capture noisily replace rHealthIndex_per100g = g_fiber_per100g /29.5 /// "good" macronutrients
	- g_sugar_per100g /32.8 - g_fat_sat_per100g /17.2 - g_sodium_per100g /2.3 - g_cholest_per100g /0.3 /// "bad" macronutrients
	if Fruit==0&Veg==0 

** If have nutrition facts per1 (e.g. in UPC nutrition facts):
	* rescale to per 100g using weight in Grams
capture noisily replace rHealthIndex_per100g = (g_fiber_per1 /29.5 /// "good" macronutrients
	- g_sugar_per1 /32.8 - g_fat_sat_per1 /17.2 - g_sodium_per1 /2.3 - g_cholest_per1 /0.3) * /// "bad" macronutrients
	100/Grams ///
	if Fruit==0&Veg==0 

	
label var rHealthIndex_per100g "Health Index (per 100 grams)"


** If we have grams, generate the HealthIndex for the UPC
	* Capture because for magnet nutrition facts, we don't yet have grams
capture noisily gen rHealthIndex_per1 = rHealthIndex_per100g/100 * Grams
capture noisily label var rHealthIndex_per1 "Health Index"

** Health Index per calorie
	* r is for raw
gen rHealthIndex_per1000Cal = rHealthIndex_per100g/cals_per100g * 1000 if cals_per1>1 // Make missing if less than 1 calorie

*gen HealthIndex_per1000Cal = (rHealthIndex_per1000Cal-mean)/sd // Mean and SD from below, using full sample.
*label var HealthIndex_per1000Cal "Health Index per 1000 calories"



/*
** Health Index excluding produce
gen HINoProd_per1000Cal = cond(Fruit==0&Veg==0,HealthIndex_per1000Cal,0)
label var HINoProd_per1000Cal "Non-produce Health Index"

capture noisily gen HINoProd_per1 = cond(Fruit==0&Veg==0,HealthIndex_per1,0)
label var HINoProd_per1 "Non-produce Health Index"
*/
/*
/* Getting the mean and standard deviation of the health index */
	* Define so that the mean in the full data is 0, and the standard deviation across households (after removing year effects) is 1
	* This must be done after the data are prepped once.
use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
sum rHealthIndex_per1000Cal [aw=projection_factor] // This is for the mean

reg rHealthIndex_per1000Cal i.panel_year [aw=projection_factor]
predict YearDummies

gen HIMinusYear = rHealthIndex_per1000Cal-YearDummies

sum HIMinusYear [aw=projection_factor] // This is for the sd

* Check: 
sum HealthIndex_per1000Cal [aw=projection_factor] // sd not exactly one because this now has between-year variation also.

