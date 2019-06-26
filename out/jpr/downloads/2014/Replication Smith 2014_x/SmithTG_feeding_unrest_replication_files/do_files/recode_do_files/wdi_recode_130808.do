**** PREP WDI DATA *****

clear
insheet using "data/raw_data/WDI_dld_130808.csv", comma
*tempfile `wdi'
*save wdi, replace
/*
clear
insheet using "data/raw_data/WFP_dld_121111.csv", comma
gen countrycode = ""
replace countrycode = "DZA" if recipient == "Algeria"
replace countrycode = "AGO" if recipient == "Angola"
replace countrycode = "BEN" if recipient == "Benin"
replace countrycode = "BWA" if recipient == "Botswana"
replace countrycode = "BFA" if recipient == "Burkina Faso"
replace countrycode = "BDI" if recipient == "Burundi"
replace countrycode = "CMR" if recipient == "Cameroon"
replace countrycode = "CPV" if recipient == "Cape Verde"
replace countrycode = "CAF" if recipient == "Central African Republic"
replace countrycode = "TCD" if recipient == "Chad"
replace countrycode = "COM" if recipient == "Comoros"
replace countrycode = "COG" if recipient == "Congo"
replace countrycode = "CIV" if recipient == "C̫te d'Ivoire"
replace countrycode = "CIV" if recipient == "C?te d'Ivoire"
replace countrycode = "ZAR" if recipient == "Democratic Republic of the Congo (DRC)"
replace countrycode = "DJI" if recipient == "Djibouti"
replace countrycode = "EGY" if recipient == "Egypt"
replace countrycode = "GNQ" if recipient == "Equatorial Guinea"
replace countrycode = "ERI" if recipient == "Eritrea"
replace countrycode = "ETH" if recipient == "Ethiopia"
replace countrycode = "GAB" if recipient == "Gabon"
replace countrycode = "GMB" if recipient == "Gambia"
replace countrycode = "GHA" if recipient == "Ghana"
replace countrycode = "GIN" if recipient == "Guinea"
replace countrycode = "GNB" if recipient == "Guinea-Bissau"
replace countrycode = "KEN" if recipient == "Kenya"
replace countrycode = "LSO" if recipient == "Lesotho"
replace countrycode = "LBR" if recipient == "Liberia"
replace countrycode = "LBY" if recipient == "Libya"
replace countrycode = "MDG" if recipient == "Madagascar"
replace countrycode = "MWI" if recipient == "Malawi"
replace countrycode = "MLI" if recipient == "Mali"
replace countrycode = "MRT" if recipient == "Mauritania"
replace countrycode = "MUS" if recipient == "Mauritius"
replace countrycode = "MAR" if recipient == "Morocco"
replace countrycode = "MOZ" if recipient == "Mozambique"
replace countrycode = "NAM" if recipient == "Namibia"
replace countrycode = "NER" if recipient == "Niger"
replace countrycode = "NGA" if recipient == "Nigeria"
replace countrycode = "RWA" if recipient == "Rwanda"
replace countrycode = "SEN" if recipient == "Senegal"
replace countrycode = "SYC" if recipient == "Seychelles"
replace countrycode = "SLE" if recipient == "Sierra Leone"
replace countrycode = "SOM" if recipient == "Somalia"
replace countrycode = "ZAF" if recipient == "South Africa"
replace countrycode = "SSD" if recipient == "South Sudan"
replace countrycode = "SDN" if recipient == "Sudan, the"
replace countrycode = "SWZ" if recipient == "Swaziland"
replace countrycode = "STP" if recipient == "Ṣo Tom̩ and Principe"
replace countrycode = "STP" if recipient == "S?o Tom? and Principe"
replace countrycode = "TZA" if recipient == "Tanzania"
replace countrycode = "TGO" if recipient == "Togo"
replace countrycode = "TUN" if recipient == "Tunisia"
replace countrycode = "UGA" if recipient == "Uganda"
replace countrycode = "ZMB" if recipient == "Zambia"
replace countrycode = "ZWE" if recipient == "Zimbabwe"
drop if recipient == "Cyprus"
drop if recipient == "Iran, Islamic Republic of"
drop if recipient == "Iraq"
drop if recipient == "Israel"
drop if recipient == "Jordan"
drop if recipient == "Lebanon"
drop if recipient == "Occupied Palestinian Territory"
drop if recipient == "Syrian Arab Republic, the"
drop if recipient == "Turkey"
drop if recipient == "Yemen"
drop recipient
order countrycode
gen food_aid = emergency + programme + project

merge 1:1 countrycode year using wdi
drop _merge
*merge 1:1 countrycode year using wdi_2
*drop if _merge != 3
*drop _merge
*drop region regioncode
*/
rename countrycode wb_code
*replace emergency = 0 if emergency == .
*replace programme = 0 if programme == .
*replace project = 0 if project == .
*replace food_aid = 0 if food_aid == .

rename lifeexpectancyatbirthtotalyears life_exp
lab var life_exp "Life expectancy at birth total (years)"
rename mortalityrateinfantper1000livebi inf_mort
lab var inf_mort "Mortality rate infant (per 1000 live births)"
rename maternalmortalityratiomodeledest mat_mort
rename maternalmortalityrationationales mat_mort_mod
rename povertyheadcountratioatnationalp pov_hc_
rename prevalenceofundernourishmentofpo malnutr
rename populationages65andaboveoftotal pop_old
rename populationages1564oftotal pop_adult
rename agriculturalmachinerytractorsper ag_mach
rename cerealyieldkgperhectare cereal
rename povertyheadcountratioat2adaypppo pov_125
rename povertyheadcountratioat125adaypp pov_200
order pov_125 pov_200, a(pov_hc)

rename agriculturalirrigatedlandoftotal irrig
rename agriculturalrawmaterialsexportso ag_exp_wdi
rename oilrentsofgdp oil_rents
rename agriculturevalueaddedofgdp ag_va
lab var ag_va "Agriculture value added (% of GDP)"
rename employmentinagricultureoftotalem ag_emp
rename gdpconstant2005us gdp
rename agriculturallandoflandarea ag_land
*rename gdpgrowthannual gdp_growth
rename gdppercapitaconstant2005us gdppc_wb
rename foreigndirectinvestmentnetinflow fdi
lab var fdi "Foreign direct investment net inflows (% of GDP)"
rename foodimportsofmerchandiseimports food_imp_wdi
rename foodexportsofmerchandiseexports food_exp_wdi
rename foodproductionindex20042006100 food_prod
*rename populationgrowthannual pop_growth
rename energyusekgofoilequivalentper100 energy_use
rename populationages014oftotal pop_youth
rename landareasqkm area
rename fertilizerconsumptionkilogramspe fert

rename populationtotal pop
rename urbanpopulation pop_urb

encode wb_code, gen(wb_num)
order wb_num, a(wb_code)

xtset wb_num year

gen py_fdi = l.fdi
lab var py_fdi "Previous year foreign direct investment net inflows (% of GDP)"

replace pop_youth = (pop_youth / 100) * pop
lab var pop_youth "Youth Population (14 & under)"

gen r_tot = log(pop/pop[_n-1])/12 if wb_num == wb_num[_n-1]
gen r_urb = log(pop_urb/pop_urb[_n-1])/12 if wb_num == wb_num[_n-1]
gen r_youth = log(pop_youth/pop_youth[_n-1])/12 if wb_num == wb_num[_n-1]
expand 12
sort wb_num year
gen month = 1
replace month = month[_n-1] + 1 if wb_num == wb_num[_n-1] & year == year[_n-1]
order month, a(year)
gen time = ((year - 1960) * 12) + (month - 1)
order time, a(month)
xtset wb_num time
replace pop = . if month != 7
replace pop_urb = . if month != 7
replace pop_youth = . if month != 7

replace pop = l.pop * exp(r_tot) if month != 7
replace pop_urb = l.pop_urb * exp(r_urb) if month != 7
replace pop_youth = l.pop_youth * exp(r_youth) if month != 7

gen pct_urb = pop_urb / pop * 100
lab var pct_urb "Urban Population (% of total)"
gen pct_youth = pop_youth / pop * 100
lab var pct_youth "Youth Population (% of total 14 & under)"

gen pop_growth = ((pop - l.pop) / l.pop) * 100
lab var pop_growth "Population Growth (monthly %)"
gen urb_growth = ((pop_urb - l.pop_urb) / l.pop_urb) * 100
lab var urb_growth "Urban Population Growth (monthly %)"
gen youth_growth = ((pop_youth - l.pop_youth) / l.pop_youth) * 100
lab var youth_growth "Youth Population Growth (monthly %)"

replace gdp = . if month != 7
ipolate gdp time, by(wb_num) gen(gdp_ip)
replace gdp = gdp_ip
gen gdp_growth = ((gdp - l.gdp) / l.gdp) * 100
lab var gdp_growth "GDP growth (monthly %)"
gen gdppc = gdp/pop/1000
lab var gdppc "GDP per capita (thousands of constant 2005 USD)"

order gdppc, a(gdp)
replace pop = pop/1000000
lab var pop "Population (millions)"
replace gdp = gdp/1000000
lab var gdp "GDP (million of constant 2005 USD)"

*rename ag_aid_food_mt food_aid
*lab var food_aid "Total food aid (cereals and noncereal) deliveries (FAO tonnes)"
*gen py_faid = l.food_aid
*gen py_faid_pc = py_faid * 10 / pop
*lab var py_faid_pc "Previous year annual food aid (cereals and noncereal) deliveries (100 kg per capita) (FAO)"
*gen food_aid_pc = food_aid * 1000 / 12 / pop
*lab var food_aid_pc "Average monthly food aid (cereals and noncereal) deliveries (kg per capita) (FAO)"

drop yearcode country wb_num gdp_ip r_tot r_urb r_youth

save "data/wdi_recode.dta", replace

exit
