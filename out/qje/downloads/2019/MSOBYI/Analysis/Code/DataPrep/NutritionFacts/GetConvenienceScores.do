/* GetConvenienceScores.do */

/* First open and save the convenience scores */
	* These were received from Abigail Okrent at USDA and translated from SAS to this csv file by Hunt on Sep 9 2016. Paper is available from https://www.ers.usda.gov/webdocs/publications/80654/err-211.pdf?v=42668
	* 0: Basic ingredients. Basic ingredients are raw or minimally processed foods used in producing a meal or snack that are generally composed of a single ingredient, such as milk, dried beans, rice, grains, butter, cream, fresh meat, poultry, and seafood.
	* 1: Complex ingredients. Examples include bread, pasta, sour cream, sauce, canned vegetables, canned beans, pickles, cereal, frozen meat/poultry/seafood, canned meat/poultry/seafood, and lunch meat. Complex ingredients are similar to the Park and Capps (1997) “semi-prepared” category, but these foods are rarely eaten alone or as a meal.
	* 2: Ready-to-cook meals and stacks. The RTC meals and snacks category constitutes foods that require minimal preparation involving heating, cooking, or adding hot water, such as frozen entrees, frozen pizzas, dry meal mixes, pudding mixes, soup, chili, and powdered drinks.
	* 3: Ready-to-eat meals and snacks. The RTE meals and snacks category refers to foods that are intended to be consumed as is and require no preparation beyond opening a container, including refrigerated entrees and sides, canned fruit, yogurt, candy, snacks, liquid drinks, and flavored milk.
	
** Hunt's additional notes:
		* I also added unprepared frozen meats/poultry/seafood as 0. Prepared versions (e.g. breaded seafood frozen) is still 1.
		* I moved unprepared vegetables (including canned and frozen vegetables) to 0; breaded/prepared veggies are still 1. The reason is that we want convenience to really capture prep time, not amount of packaging or pre-preparation.
		* Fresh fruits are coded as 0 from USDA/Okrent, but I moved all fresh fruit and precut fresh fruit to 3. Precut fresh fruits also coded as 3. USDA already coded canned fruits as 3, so I don't see how we could code fresh as harder to prepare.
		* I assume that cheese is 1.

insheet using $Externals/Data/NutritionFacts/ConvenienceScores.csv, comma names case clear
keep product_module_code Convenience
keep if Convenience!=.
saveold $Externals/Calculations/NutritionFacts/ConvenienceScores.dta, replace
