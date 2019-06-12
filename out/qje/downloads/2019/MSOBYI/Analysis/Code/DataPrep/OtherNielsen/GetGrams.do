/* GetGrams.do */
* This gets the weight of each UPC in grams

*** Translate everything to grams. 
	* Multiply by multi for multi-packs. See the Manual for confirmation.
	* The below code covers all of the food-related size codes. There is also "YD", but this is ONLY for dental floss.
gen Grams = .
replace Grams = size1_amount*multi if size1_units=="GR"
replace Grams = 28.350*size1_amount*multi if size1_units=="OZ"
replace Grams = 453.59*size1_amount*multi if size1_units=="PO"
* For liquid volumes, assume density of water
replace Grams = 1000*size1_amount*multi if size1_units=="LI"
replace Grams = size1_amount*multi if size1_units=="ML"
replace Grams = 946.35295*size1_amount*multi if size1_units=="QT"



/* IMPUTE MISSING GRAMS */
* When size1_amount is in count, assume the same mean and variance as gram-amount products within the same module

gen TotalCT = size1_amount*multi if size1_units=="CT" // Total Count in the UPC

qui{
foreach cat in module group {
	gen ImputedGrams_`cat' = .
	levelsof product_`cat'_code,local(levels)
	foreach lev in `levels' {
		sum TotalCT if product_`cat'_code==`lev'
		if r(N) > 0 { // If there are UPCs with units in CT
			local levmeanCT = r(mean)
			local levsdCT = r(sd)
			sum Grams if product_`cat'_code==`lev'
			if r(N) > 0 { // Some modules may not have any UPCs already in Grams
				foreach stat in mean sd min max {
					local lev`stat'Grams = r(`stat')
				}

				replace ImputedGrams_`cat' = ( (TotalCT - `levmeanCT')/`levsdCT' ) * `levsdGrams' + `levmeanGrams' if size1_units=="CT"&product_`cat'_code==`lev'
				
				** Trim at min and max (most obviously important in that this eliminates negatives)
				replace ImputedGrams_`cat' = min(`levmaxGrams', max(`levminGrams',ImputedGrams_`cat')) if size1_units=="CT"&product_`cat'_code==`lev'&ImputedGrams_`cat'!=.	
			}
		}
	}
}
}

replace Grams = ImputedGrams_module if Grams==.&ImputedGrams_module!=.
replace Grams = ImputedGrams_group if Grams==.&ImputedGrams_group!=.

drop TotalCT ImputedGrams_*	
	
* There are a small number of UPCs (<100) with no size1_amount. For these, impute the module or group average
foreach cat in module group {
	bysort product_`cat'_code: egen `cat'_meanGrams = mean(Grams)
	replace Grams = `cat'_meanGrams if Grams==.
	drop `cat'_meanGrams
} 


/* Gum and eggs */
* Gum and eggs are product groups that only come in counts.

* Eggs: http://en.wikipedia.org/wiki/Chicken_egg_sizes
replace Grams = 60 * size1_amount if product_group_code==2505

* Gum: http://www.answers.com/Q/How_many_grams_are_in_a_stick_of_gum
replace Grams = 1.9 * size1_amount if product_group_code == 505


/* Grams may be too low relative to nutrition facts; replace with sum across nutrition facts if needed */
egen NFGrams = rowtotal(g_fat_per1 g_carb_per1 g_prot_per1 g_sodium_per1)
replace Grams = NFGrams if NFGrams>Grams & NFGrams!=. & size1_units=="CT" // Some conflicts with ounce but don't fix these. 
drop NFGrams

*
