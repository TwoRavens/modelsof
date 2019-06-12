/* GetGroup.do */
* This file gets our group variable, which combines across multiple product_group_codes when purchases are less frequent.
* We combine product_group_codes within departments only
* Numbers of the new created groups are negative and begin with the department code

gen int group = product_group_code
gen group_descr = product_group_descr




/* Dairy */
	* Not obvious what to do with the four categories with lots of missing, so just group them into other dairy.
replace group = -31 if inlist(product_group_code,2504,2507,2508,2509)
replace group_descr = "OTHER DAIRY" if group==-31


/* Dry Grocery */

	* Combine tea and coffee
replace group = -11 if inlist(product_group_code,1020,1006)
replace group_descr = "TEA AND COFFEE" if group==-11

	* Dried fruits and vegetables are less frequent. Group canned and dried vegetables and fruits.
replace group = -12 if inlist(product_group_code,1010,504)
replace group_descr = "FRUIT - CANNED AND DRIED" if group==-12

replace group = -13 if inlist(product_group_code,1021,514)
replace group_descr = "VEGETABLES - CANNED AND DRIED" if group==-13

replace group  = -14 if inlist(product_group_code,1002,1009)
replace group_descr = "FLOUR AND BAKING SUPPLIES" if group==-14

replace group = -15 if inlist(product_group_code,1018,1019)
replace group_descr = "TABLE SYRUPS, MOLASSES, SUGAR, SWEETENERS" if group==-15

replace group = -16 if inlist(product_group_code,503,505)
replace group_descr = "CANDY AND GUM" if group==-16

replace group = -17 if inlist(product_group_code,1005,1004)
replace group_descr = "CEREAL AND BREAKFAST FOOD" if group==-17

* Other is baby food and seafood
*replace group = -18 if inlist(product_group_code,512,501)
*replace group_descr = "BABY FOOD AND CANNED SEAFOOD" if group==-18


/* Frozen foods */
* Desserts are less common. Combine with ice cream.
replace group = -21 if inlist(product_group_code,2003,2005,2006)
replace group_descr = "ICE CREAM/DESSERTS/DRINKS-FROZEN" if group==-21

replace group = -22 if inlist(product_group_code,2001,2002)
replace group_descr = "BAKED GOODS AND BREAKFAST FOODS-FROZEN" if group==-22

replace group = -23 if inlist(product_group_code,2007,2008)
replace group_descr = "PREPARED FOODS/PIZZA/SNACKS-FROZEN" if group==-23

/* Health and beauty care */
* Only two groups, and diet aids are very uncommon
replace group = -1 if inlist(product_group_code,6005,6018)
replace group_descr = "VITAMINS AND DIET AIDS" if group==-1


/* Packaged meat */
* Only two groups, and fresh meat is uncommon, so combine these
replace group = -51 if inlist(product_group_code,3002,3501)
replace group_descr="PACKAGED MEAT" if group==-51
