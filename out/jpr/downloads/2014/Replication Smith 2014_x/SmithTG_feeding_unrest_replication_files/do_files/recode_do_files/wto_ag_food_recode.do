*** PREP WTO AG AND FOOD TRADE DATA ***

clear
insheet using "data/raw_data/WTO_africa_ag_food_trade_dld120327.csv", comma

encode flow_desc, gen(flow)
encode indicator_desc, gen(indicator)
encode reporter_desc, gen(country)
rename reporter_code iso2

drop topic_code topic_desc dataset_code dataset_desc flow_code flow_desc indicator_code indicator_desc reporter_desc partner_code partner_desc unit_code unit_desc notes_export value_flag

order country iso2 year indicator flow value

tempfile full
save `full'

drop if flow == 2

rename value exports
drop flow

tempfile exports
save `exports'

clear
use `full'

drop if flow == 1
drop flow 

rename value imports

merge 1:1 country year indicator using `exports'
drop _merge

lab var imports "Imports"
lab var exports "Exports"

tempfile `wto'
save wto, replace

drop if indicator == 1
rename imports ag_imp
lab var ag_imp "Agricultural Products Imports (current USD)"
rename exports ag_exp
lab var ag_exp "Agricultural Products Exports (current USD)"
drop indicator
sort country year

tempfile `ag'
save ag, replace

clear
use wto

drop if indicator == 2
rename imports food_imp
lab var food_imp "Food Imports (current USD)"
rename exports food_exp
lab var food_exp "Food Exports (current USD)"
drop indicator
sort country year

merge 1:1 country year using ag
drop _merge

drop if country == 18 & year == 1990
drop if country == 18 & year == 1991
drop if country == 18 & year == 1992

gen iso_num = .
replace iso_num = 	12	if country ==	1replace iso_num = 	24	if country ==	2replace iso_num = 	204	if country ==	3replace iso_num = 	72	if country ==	4replace iso_num = 	854	if country ==	5replace iso_num = 	108	if country ==	6replace iso_num = 	120	if country ==	7replace iso_num = 	132	if country ==	8replace iso_num = 	140	if country ==	9replace iso_num = 	148	if country ==	10replace iso_num = 	174	if country ==	11replace iso_num = 	178	if country ==	12replace iso_num = 	384	if country ==	13replace iso_num = 	262	if country ==	14replace iso_num = 	818	if country ==	15replace iso_num = 	232	if country ==	16replace iso_num = 	231	if country ==	17replace iso_num = 	231	if country ==	18replace iso_num = 	266	if country ==	19replace iso_num = 	270	if country ==	20replace iso_num = 	288	if country ==	21replace iso_num = 	324	if country ==	22replace iso_num = 	404	if country ==	23replace iso_num = 	426	if country ==	24replace iso_num = 	430	if country ==	25replace iso_num = 	434	if country ==	26replace iso_num = 	450	if country ==	27replace iso_num = 	454	if country ==	28replace iso_num = 	466	if country ==	29replace iso_num = 	480	if country ==	30replace iso_num = 	504	if country ==	31replace iso_num = 	508	if country ==	32replace iso_num = 	516	if country ==	33replace iso_num = 	562	if country ==	34replace iso_num = 	566	if country ==	35replace iso_num = 	646	if country ==	37replace iso_num = 	678	if country ==	38replace iso_num = 	686	if country ==	39replace iso_num = 	690	if country ==	40replace iso_num = 	694	if country ==	41replace iso_num = 	706	if country ==	42replace iso_num = 	710	if country ==	43replace iso_num = 	736	if country ==	44replace iso_num = 	748	if country ==	45replace iso_num = 	834	if country ==	46replace iso_num = 	768	if country ==	47replace iso_num = 	788	if country ==	48replace iso_num = 	800	if country ==	49replace iso_num = 	894	if country ==	50replace iso_num = 	716	if country ==	51

sort country year

xtset iso_num year

gen ag_ratio = ag_exp / ag_imp
lab var ag_ratio "Ratio of Agricultural Products Exports to Imports"
gen food_ratio = food_exp / food_imp
lab var ag_ratio "Ratio of Food Exports to Imports"
gen py_ag_rat = l.ag_ratio
lab var py_ag_rat "Previous Year Ratio of Agricultural Products Exports to Imports"
gen py_food_rat = l.food_ratio
lab var py_food_rat "Previous Year Ratio of Food Exports to Imports"

gen py_food_imp = l.food_imp
gen py_food_exp = l.food_exp
gen py_ag_imp = l.ag_imp
gen py_ag_exp = l.ag_exp

gen food_bal = food_exp - food_imp
gen ag_bal = ag_exp - ag_imp
gen py_food_bal = l.food_bal
gen py_ag_bal = l.ag_bal

gen food_bal_mil = food_bal / 1000000
gen ag_bal_mil = ag_bal / 1000000

order iso_num country year
drop country iso2

quietly do "do_files/iso_code_define.do"

save "data/wto_ag_food.dta", replace

exit
