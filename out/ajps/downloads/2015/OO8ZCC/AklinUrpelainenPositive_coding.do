
*12345678901234567890123456789012345678901234567890123456789012345678901234567890


*	************************************************************************
* 	File-Name: 	AklinUrpelainenPositive_coding.do
*	Log-file:	N/A
*	Date:  		04/08/2012
*	Author: 	Micha‘l Aklin (NYU) and Johannes Urpelainen (Columbia)
*	Input:		AklinUrpelainenPositive_raw.dta
*	Output:		AklinUrpelainenPositive_coded.dta
*	Purpose:   	do file to create the AklinUrpelainenPositive_coded.dta dataset
*				used for "Political Competition, Path Dependence, and the 
*				Strategy of Sustainable Energy Transitions"
*	************************************************************************

clear all
set more off

* CORRECT THIS PATH TO THE REPLICATION FOLDER
cd ""
use "AklinUrpelainenPositive_raw.dta"


*	************************************************************************
*	1. Preparing the dataset
*	************************************************************************

*	* New -ccode- variable
xtset ccode year

*	************************************************************************
*	2. Create new interesting variables
*		1) Economic variables
*		2) Interaction effects
*		3) Various
*	************************************************************************

*	************************************************************************
*	1. Dependent variable
*	************************************************************************

*	Renewable capacity share
gen renew_capacity_nh_share = .
replace renew_capacity_nh_share = renewable_nonhydro_capacity_eia/electricity_capacity_eia
replace renew_capacity_nh_share = renew_capacity_nh_share*100
label variable renew_capacity_nh_share `"Renewable Capacity Share"'

*	First difference
gen drenew_capacity_nh_share = .
replace drenew_capacity_nh_share = d.renew_capacity_nh_share
label variable drenew_capacity_nh_share `"$\Delta$ Renewable Capacity"' 

*	Non capacity FD
gen drenewableshare = .
replace drenewableshare = d.renewableshare
label variable drenewableshare `"$\Delta$ Renewable Share"'

gen lnrenew_capacity_nh_share = ln(renew_capacity_nh_share + 1)
label variable lnrenew_capacity_nh_share `"Renewable Capacity (log)"'

gen dlnrenew_capacity_nh_share = d.lnrenew_capacity_nh_share
label variable dlnrenew_capacity_nh_share `"$\Delta$ Renewable Capacity (log)"'


*	************************************************************************
*	2. Main independent variables
*	************************************************************************

*	Competition and partisanship
gen left_executive = 0
replace left_executive = 1 if execrlc == 3
label variable left_executive `"Left Government"'

gen right_executive = 0
replace right_executive = 1 if execrlc == 1
label variable right_executive `"Right Government"'

gen center_executive = 0
replace center_executive = 1 if execrlc == 2
label variable center_executive `"Center Government"'

replace left_executive = . if center_executive == 0 & right_executive == 0 & left_executive == 0
replace right_executive = . if center_executive == 0 & right_executive == 0 & left_executive == 0
replace center_executive = . if center_executive == 0 & right_executive == 0 & left_executive == 0

*	Shifts
gen right_to_left = 0
by ccode, sort: replace right_to_left = 1 if right_executive[_n-1] == 1 & left_executive == 1
label variable right_to_left `"Right to Left Exec."'

gen left_to_right = 0
by ccode, sort: replace left_to_right = 1 if left_executive[_n-1] == 1 & right_executive == 1
label variable left_to_right `"Left to Right Exec."'


*	Positive reinforcement
gen lrenewpc = .
replace lrenewpc = l.renewpc
label variable lrenewpc `"Pos. Reinforcement (t-1)"'

gen lrenewepopc = .
replace lrenewepopc = l.renewepopc
label variable lrenewepopc `"Pos. Reinforcement (EU; t-1)"'

gen lnlrenewpc = ln(lrenewpc + 1)
label variable lnlrenewpc `"Pos. Reinforcement (log) (t-1)"'

gen lnrenewpc = ln(renewpc + 1)
label variable lnlrenewpc `"Pos. Reinforcement (log)"'

gen employment_hightech_pc = employment_hightech/pop
label variable employment_hightech_pc `"Share Empl. in High Tech"'

gen lemployment_hightech_pc = l.employment_hightech_pc
label variable lemployment_hightech_pc `"Share Empl. High Tech (t-1)"'


*	Oil
tssmooth ma oil_3year_average = oilcrude_price2007dollar_bp, window(3 0 0)
label variable oil_3year_average `"Oil Price (3 year average)"'

 
*	Interaction effects
gen linnovation_x_oil3 = .
replace linnovation_x_oil3 = l.renewpc * oil_3year_average
label variable linnovation_x_oil3 `"Pos. Reinforcement (t-1) * Oil (3 yrs)"'
 
* Innovation * Oil
gen linnovation_x_oil = .
replace linnovation_x_oil = l.renewpc * oilcrude_price2007dollar_bp
label variable linnovation_x_oil `"Pos. Reinforcement (t-1) * Oil"'

gen lnlinnovation_x_oil = lnlrenewpc * oilcrude_price2007dollar_bp
label variable lnlinnovation_x_oil `"Pos. Reinforcement (log) * Oil"'

gen emphtpc_x_oil = employment_hightech_pc * oilcrude_price2007dollar_bp
label variable emphtpc_x_oil `"High Tech Empl * Oil"'

gen lemphtpc_x_oil = l.emphtpc_x_oil
label variable lemphtpc_x_oil `"High Tech Empl * Oil (t-1)"'

gen lmeanfeedin_urpelainen = l.meanfeedin_urpelainen
label variable lmeanfeedin_urpelainen `"Mean Feed-In Tariff (t-1)"'

gen linnovationEU_x_oil = .
replace linnovationEU_x_oil = l.renewepopc * oilcrude_price2007dollar_bp
label variable linnovationEU_x_oil `"Pos. Reinforcement (EU, t-1) * Oil"'


*	************************************************************************
*	3. Control variables
*	************************************************************************


*	Renewable share moving average
tssmooth ma renewablecapacity_3yr_average = renewable_nonhydro_capacity_eia, window(3 0 0)
label variable renewablecapacity_3yr_average `"Renewable Capacity (3 year average)"'
 
*	Energy
gen hydronuclear = .
replace hydronuclear = hydroshare + nuclearshare
label variable hydronuclear `"Nuclear $+$ Hydro Share"'

tssmooth ma hydronuclear_3yr = hydronuclear, window(3 0 0)
label variable hydronuclear_3yr `"Hydro $+$ Nuclear Share (3 year average)"'

gen traditional_electricity_share = convthermal_elect_generation_eia/electricity_net_generation_eia
label variable traditional_electricity_share `"Traditional Electricity Share"' 

tssmooth ma trad_electricityshare_cap_3y = traditional_electricity_share, window(3 0 0)
label variable trad_electricityshare_cap_3y `"Traditional Electr. Generation Share (3 yr average)"'


*	GDP per capita in 1000s of dollars
gen gdpcapk = .
replace gdpcapk = rgdpl/1000
label variable gdpcapk `"GDP per capita (K\textdollar)"'

*	Growth
by ccode, sort: gen income_growth = (rgdpl - l.rgdpl)/l.rgdpl
label variable income_growth `"Income Growth"'

*	Enterprises
gen hightech_nbr_enterprise_pc = hightech_nbr_enterprise/pop
label variable hightech_nbr_enterprise_pc `"Nbr High Tech Enterprise (per capita)"'

*	FE
quiet tabulate year, generate(year_dummy)
quiet tabulate country_aklin, generate(country_dummy)




*	************************************************************************
*	4. Other
*	************************************************************************

*	Identify non-traditional OECD members
gen flag_oecd = 0
replace flag_oecd = 1 if country_aklin == "Chile"
replace flag_oecd = 1 if country_aklin == "Czech Republic"
replace flag_oecd = 1 if country_aklin == "Hungary"
replace flag_oecd = 1 if country_aklin == "Mexico"
replace flag_oecd = 1 if country_aklin == "Poland"
replace flag_oecd = 1 if country_aklin == "Slovakia"
replace flag_oecd = 1 if country_aklin == "Turkey"



*	************************************************************************
*	6. Setting the format for the tables
*	************************************************************************
set cformat %8.3f

*	************************************************************************
*	7. Keep interesting variables
*	************************************************************************


save "AklinUrpelainenPositive_coded.dta", replace

