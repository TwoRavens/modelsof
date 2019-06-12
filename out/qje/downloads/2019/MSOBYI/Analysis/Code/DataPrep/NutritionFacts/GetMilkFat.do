/* GetMilkFat.do */
* This code should be run on the products.tsv file.

	* only 44 are unknown for 2006, so the code below is very good.
	* MilkFat, LowFat, and NonFat variables are missing for modules other than 3625.
gen Pct = strpos(upc_descr,"%") if product_module_code==3625
gen PctText2 = substr(upc_descr,Pct-2,2) if Pct!=0
gen PctText3 = substr(upc_descr,Pct-3,3) if Pct!=0
destring PctText2 PctText3, replace force
gen MilkFatPct = PctText2
replace MilkFatPct = PctText3 if PctText3!=. // this replaces only if non-missing and a string of length 3, e.g. 1.5 percent.
replace MilkFat = 0 if strpos(upc_descr,"SKM")!=0|strpos(upc_descr,"NF")!=0|strpos(upc_descr,"FF")!=0
replace MilkFat = 3.5 if strpos(upc_descr,"WH")!=0 // Whole milk is 3.5% fat
replace MilkFat = . if product_module_code!=3625 // Some of the above code will pick up UPC descriptions from non-milk UPCs. This ensures that the milk fat variables are missing for modules other than 3625.
gen byte LowFatMilk = cond(MilkFat<2,1,0) if MilkFat!=.
gen byte NonFatMilk = cond(MilkFat==0,1,0) if MilkFat!=.

drop Pct PctText2 PctText3
