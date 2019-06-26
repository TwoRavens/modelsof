**** PREP IMF COMMODITY PRICE DATA *****
*** prepares data for use by MASTER ANALYSIS
*** Todd G. Smith
*** updated 14 JANUARY 2014


clear
set more off
local user  "`c(username)'"
cd "/Users/`user'/Documents/Active Projects/Feeding Unrest Africa/analysis"
insheet using "data/raw_data/IMF_commodity_prices_mod_140122.csv", comma
egen time = fill(240 241)
format time %tmMon_CCYY
order time
drop v1
tsset time

foreach var of varlist pngaseu pngasjp pngasus psugaeec {
	replace `var' = "" if `var' == "n.a."
	destring `var', replace
	}

lab var pallfnf "All index"
lab var pnfuel "Non-Fuel index"
lab var pfandb "Food and beverage index"
lab var pfood "Food index"
lab var pbeve "Beverages index"
lab var pindu "Industrial Materials index"
lab var prawm "Agricultural Raw Material Index"
lab var pmeta "Metal index"
lab var pnrg "Energy index"
lab var poilapsp "Oil; Average of U.K. Brent Dubai and West Texas Intermediate (index)"
lab var palum "Aluminum 99.5% minimum purity LME spot price CIF UK ports US$ per metric tonne"
lab var pbansop "Bananas Central American and Ecuador FOB U.S. Ports US$ per metric tonne"
lab var pbarl "Barley Canadian no.1 Western Barley spot price US$ per metric tonne"
lab var pbeef "Beef Australian and New Zealand 85% lean fores CIF U.S. import price US cents per pound"
lab var pcoalau "Coal Australian thermal coal 12000- btu/pound less than 1% sulfur 14% ash FOB Newcastle/Port Kembla US$ per metric tonne"
lab var pcoco "Cocoa beans International Cocoa Organization cash price CIF US and European ports US$ per metric tonne"
lab var pcoffotm "Coffee Other Mild Arabicas International Coffee Organization New York cash price ex-dock New York US cents per pound"
lab var pcoffrob "Coffee Robusta International Coffee Organization New York cash price ex-dock New York US cents per pound"
lab var proil "Rapeseed oil crude fob Rotterdam US$ per metric tonne"
lab var pcopp "Copper grade A cathode LME spot price CIF European ports US$ per metric tonne"
lab var pcottind "Cotton Cotton Outlook 'A Index' Middling 1-3/32 inch staple CIF Liverpool US cents per pound"
lab var pfish "Fishmeal Peru Fish meal/pellets 65% protein CIF US$ per metric tonne"
lab var pgnuts "Groundnuts (peanuts) 40/50 (40 to 50 count per ounce) cif Argentina US$ per metric tonne"
lab var phide "Hides Heavy native steers over 53 pounds wholesale dealer's price US Chicago fob Shipping Point US cents per pound"
lab var piorecr "China import Iron Ore Fines 62% FE spot (CFR Tianjin port) US dollars per metric ton"
lab var plamb "Lamb frozen carcass Smithfield London US cents per pound"
lab var plead "Lead 99.97% pure LME spot price CIF European Ports US$ per metric tonne"
lab var plogore "Soft Logs Average Export price from the U.S. for Douglas Fir US$ per cubic meter"
lab var plogsk "Hard Logs Best quality Malaysian meranti import price Japan US$ per cubic meter"
lab var pmaizmt "Maize (corn) U.S. No.2 Yellow FOB Gulf of Mexico U.S. price US$ per metric tonne"
lab var pngaseu "Natural Gas Russian Natural Gas border price in Germany US$ per thousands of cubic meters of gas"
lab var pngasjp "Natural Gas Indonesian Liquified Natural Gas in Japan US$ per cubic meter of liquid"
lab var pngasus "Natural Gas Natural Gas spot price at the Henry Hub terminal in Louisiana US$ per thousands of cubic meters of gas"
lab var pnick "Nickel melting grade LME spot price CIF European ports US$ per metric tonne"
*lab var poilapsp_usd "Oil; Average of U.K. Brent Dubai and West Texas Intermediate (USD)"
lab var poilbre "Crude Oil (petroleum)  Dated Brent light blend 38 API fob U.K. US$ per barrel"
lab var poildub "Oil; Dubai medium Fateh 32 API fob DubaiCrude Oil (petroleum) Dubai Fateh Fateh 32 API US$ per barrel"
lab var poilwti "Crude Oil (petroleum) West Texas Intermediate 40 API Midland Texas US$ per barrel"
lab var polvoil "Olive Oil extra virgin less than 1% free fatty acid ex-tanker price U.K. US$ per metric tonne"
lab var porang "Oranges miscellaneous oranges CIF French import price US$ per metric tonne"
lab var ppoil "Palm oil Malaysia Palm Oil Futures (first contract forward) 4-5 percent FFA US$ per metric tonne"
lab var ppork "Swine (pork) 51-52% lean Hogs U.S. price US cents per pound."
lab var ppoult "Poultry (chicken) Whole bird spot price Ready-to-cook whole iced Georgia docks US cents per pound"
lab var pricenpq "Rice 5 percent broken milled white rice Thailand nominal price quote US$ per metric tonne"
lab var prubb "Singapore Commodity Exchange No. 3 Rubber Smoked Sheets 1st contract US cents per pound"
lab var psalm "Fish (salmon) Farm Bred Norwegian Salmon export price US$ per kilogram"
lab var psawmal "Hard Sawnwood Dark Red Meranti select and better quality C&F U.K port US$ per cubic meter"
lab var psawore "Soft Sawnwood average export price of Douglas Fir U.S. Price US$ per cubic meter"
lab var pshri "Shrimp No.1 shell-on headless 26-30 count per pound Mexican origina New York port US cents per pound"
lab var psmea "Soybean Meal Chicago Soybean Meal Futures (first contract forward) Minimum 48 percent protein US$ per metric tonne"
lab var psoil "Soybean Oil Chicago Soybean Oil Futures (first contract forward) exchange approved grades US$ per metric tonne"
lab var psoyb "Soybeans U.S. soybeans Chicago Soybean futures contract (first contract forward) No. 2 yellow and par US$ per metric tonne"
lab var psugaeec "Sugar European import price CIF Europe US cents per pound"
lab var psugaisa "Sugar Free Market Coffee Sugar and Cocoa Exchange (CSCE) contract no.11 nearest future position US cents per pound"
lab var psugausa "Sugar U.S. import price contract no.14 nearest futures position US cents per pound (Footnote: No. 14 revised to No. 16)"
lab var psuno "Sunflower oil Sunflower Oil US export price from Gulf of Mexico US$ per metric tonne"
lab var ptea "Tea Mombasa Kenya Auction Price US cents per kilogram From July 1998Kenya auctions Best Pekoe Fannings. Prior London auctions c.i.f. U.K. warehouses"
lab var ptin "Tin standard grade LME spot price US$ per metric tonne"
lab var puran "Uranium NUEXCO Restricted Price Nuexco exchange spot US$ per pound"
lab var pwheamt "Wheat No.1 Hard Red Winter ordinary protein FOB Gulf of Mexico US$ per metric tonne"
lab var pwoolc "Wool coarse 23 micron Australian Wool Exchange spot quote US cents per kilogram"
lab var pwoolf "Wool fine 19 micron Australian Wool Exchange spot quote US cents per kilogram"
lab var pzinc "Zinc high grade 98% pure US$ per metric tonne"

* generates variables for monthly percentage changes
foreach var of varlist pallfnf-pzinc {
	gen `var'_chg = (`var' - l.`var') / l.`var'
	order `var'_chg, a(`var')
	}

lab var pallfnf_chg "Monthly change in All index"
lab var pnfuel_chg "Monthly change in Non-Fuel index"
lab var pfandb_chg "Monthly change in Food and beverage index"
lab var pfood_chg "Monthly change in Food index"
lab var pbeve_chg "Monthly change in Beverages index"
lab var pindu_chg "Monthly change in Industrial Materials index"
lab var prawm_chg "Monthly change in Agricultural Raw Material Index"
lab var pmeta_chg "Monthly change in Metal index"
lab var pnrg_chg "Monthly change in Energy index"
lab var poilapsp_chg "Monthly change in Oil; Average of U.K. Brent Dubai and West Texas Intermediate (index)"
lab var palum_chg "Monthly change in Aluminum 99.5% minimum purity LME spot price CIF UK ports US$ per metric tonne"
lab var pbansop_chg "Monthly change in Bananas Central American and Ecuador FOB U.S. Ports US$ per metric tonne"
lab var pbarl_chg "Monthly change in Barley Canadian no.1 Western Barley spot price US$ per metric tonne"
lab var pbeef_chg "Monthly change in Beef Australian and New Zealand 85% lean fores CIF U.S. import price US cents per pound"
lab var pcoalau_chg "Monthly change in Coal Australian thermal coal 12000- btu/pound less than 1% sulfur 14% ash FOB Newcastle/Port Kembla US$ per metric tonne"
lab var pcoco_chg "Monthly change in Cocoa beans International Cocoa Organization cash price CIF US and European ports US$ per metric tonne"
lab var pcoffotm_chg "Monthly change in Coffee Other Mild Arabicas International Coffee Organization New York cash price ex-dock New York US cents per pound"
lab var pcoffrob_chg "Monthly change in Coffee Robusta International Coffee Organization New York cash price ex-dock New York US cents per pound"
lab var proil_chg "Monthly change in Rapeseed oil crude fob Rotterdam US$ per metric tonne"
lab var pcopp_chg "Monthly change in Copper grade A cathode LME spot price CIF European ports US$ per metric tonne"
lab var pcottind_chg "Monthly change in Cotton Cotton Outlook 'A Index' Middling 1-3/32 inch staple CIF Liverpool US cents per pound"
lab var pfish_chg "Monthly change in Fishmeal Peru Fish meal/pellets 65% protein CIF US$ per metric tonne"
lab var pgnuts_chg "Monthly change in Groundnuts (peanuts) 40/50 (40 to 50 count per ounce) cif Argentina US$ per metric tonne"
lab var phide_chg "Monthly change in Hides Heavy native steers over 53 pounds wholesale dealer's price US Chicago fob Shipping Point US cents per pound"
lab var piorecr_chg "Monthly change in China import Iron Ore Fines 62% FE spot (CFR Tianjin port) US dollars per metric ton"
lab var plamb_chg "Monthly change in Lamb frozen carcass Smithfield London US cents per pound"
lab var plead_chg "Monthly change in Lead 99.97% pure LME spot price CIF European Ports US$ per metric tonne"
lab var plogore_chg "Monthly change in Soft Logs Average Export price from the U.S. for Douglas Fir US$ per cubic meter"
lab var plogsk_chg "Monthly change in Hard Logs Best quality Malaysian meranti import price Japan US$ per cubic meter"
lab var pmaizmt_chg "Monthly change in Maize (corn) U.S. No.2 Yellow FOB Gulf of Mexico U.S. price US$ per metric tonne"
lab var pngaseu_chg "Monthly change in Natural Gas Russian Natural Gas border price in Germany US$ per thousands of cubic meters of gas"
lab var pngasjp_chg "Monthly change in Natural Gas Indonesian Liquified Natural Gas in Japan US$ per cubic meter of liquid"
lab var pngasus_chg "Monthly change in Natural Gas Natural Gas spot price at the Henry Hub terminal in Louisiana US$ per thousands of cubic meters of gas"
lab var pnick_chg "Monthly change in Nickel melting grade LME spot price CIF European ports US$ per metric tonne"
*lab var poilapsp_usd_chg "Monthly change in Oil; Average of U.K. Brent Dubai and West Texas Intermediate (USD)"
lab var poilbre_chg "Monthly change in Crude Oil (petroleum)  Dated Brent light blend 38 API fob U.K. US$ per barrel"
lab var poildub_chg "Monthly change in Oil; Dubai medium Fateh 32 API fob DubaiCrude Oil (petroleum) Dubai Fateh Fateh 32 API US$ per barrel"
lab var poilwti_chg "Monthly change in Crude Oil (petroleum) West Texas Intermediate 40 API Midland Texas US$ per barrel"
lab var polvoil_chg "Monthly change in Olive Oil extra virgin less than 1% free fatty acid ex-tanker price U.K. US$ per metric tonne"
lab var porang_chg "Monthly change in Oranges miscellaneous oranges CIF French import price US$ per metric tonne"
lab var ppoil_chg "Monthly change in Palm oil Malaysia Palm Oil Futures (first contract forward) 4-5 percent FFA US$ per metric tonne"
lab var ppork_chg "Monthly change in Swine (pork) 51-52% lean Hogs U.S. price US cents per pound."
lab var ppoult_chg "Monthly change in Poultry (chicken) Whole bird spot price Ready-to-cook whole iced Georgia docks US cents per pound"
lab var pricenpq_chg "Monthly change in Rice 5 percent broken milled white rice Thailand nominal price quote US$ per metric tonne"
lab var prubb_chg "Monthly change in Singapore Commodity Exchange No. 3 Rubber Smoked Sheets 1st contract US cents per pound"
lab var psalm_chg "Monthly change in Fish (salmon) Farm Bred Norwegian Salmon export price US$ per kilogram"
lab var psawmal_chg "Monthly change in Hard Sawnwood Dark Red Meranti select and better quality C&F U.K port US$ per cubic meter"
lab var psawore_chg "Monthly change in Soft Sawnwood average export price of Douglas Fir U.S. Price US$ per cubic meter"
lab var pshri_chg "Monthly change in Shrimp No.1 shell-on headless 26-30 count per pound Mexican origina New York port US cents per pound"
lab var psmea_chg "Monthly change in Soybean Meal Chicago Soybean Meal Futures (first contract forward) Minimum 48 percent protein US$ per metric tonne"
lab var psoil_chg "Monthly change in Soybean Oil Chicago Soybean Oil Futures (first contract forward) exchange approved grades US$ per metric tonne"
lab var psoyb_chg "Monthly change in Soybeans U.S. soybeans Chicago Soybean futures contract (first contract forward) No. 2 yellow and par US$ per metric tonne"
lab var psugaeec_chg "Monthly change in Sugar European import price CIF Europe US cents per pound"
lab var psugaisa_chg "Monthly change in Sugar Free Market Coffee Sugar and Cocoa Exchange (CSCE) contract no.11 nearest future position US cents per pound"
lab var psugausa_chg "Monthly change in Sugar U.S. import price contract no.14 nearest futures position US cents per pound (Footnote: No. 14 revised to No. 16)"
lab var psuno_chg "Monthly change in Sunflower oil Sunflower Oil US export price from Gulf of Mexico US$ per metric tonne"
lab var ptea_chg "Monthly change in Tea Mombasa Kenya Auction Price US cents per kilogram From July 1998Kenya auctions Best Pekoe Fannings. Prior London auctions c.i.f. U.K. warehouses"
lab var ptin_chg "Monthly change in Tin standard grade LME spot price US$ per metric tonne"
lab var puran_chg "Monthly change in Uranium NUEXCO Restricted Price Nuexco exchange spot US$ per pound"
lab var pwheamt_chg "Monthly change in Wheat No.1 Hard Red Winter ordinary protein FOB Gulf of Mexico US$ per metric tonne"
lab var pwoolc_chg "Monthly change in Wool coarse 23 micron Australian Wool Exchange spot quote US cents per kilogram"
lab var pwoolf_chg "Monthly change in Wool fine 19 micron Australian Wool Exchange spot quote US cents per kilogram"
lab var pzinc_chg "Monthly change in Zinc high grade 98% pure US$ per metric tonne"

rename pfood IMF_food
rename pfood_chg IMF_food_chg
keep time pallfnf pallfnf_chg pnfuel pnfuel_chg pfandb pfandb_chg IMF_food IMF_food_chg pbeve pbeve_chg prawm prawm_chg poilapsp poilapsp_chg pmaizmt pmaizmt_chg pricenpq pricenpq_chg pwheamt pwheamt_chg

save "data/imf_commodity.dta", replace

exit
