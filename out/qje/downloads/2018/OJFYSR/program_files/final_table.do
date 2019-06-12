* Built by Meredith Fowlie
* July 2014
* Modified May 2015 
* Generates basic summary stats for the Table 7

* Data inputs: NEAT_measure_level_savings; CAA_data.dta

capture log close

clear all
capture log close
clear matrix
program drop _all
set more off

global sec_dirpath "T:\Efficiency\WAP\data"
global home_dirpath "T:\Dropbox\WAP"

***********************************************************************

*<< ADJUST ENERGY COSTS HERE >>
*<<  NEAT ASSUMES 11.46 / mmbtu for gas - approx equal to average EIA residential in $$2013 

local gas_pric 10.46

* Henry hub price 
* Historic (post 2000) avg
* local gas_cost=6.04
* average gas recovery charge reported by utilities
* local gas_cost= 5.54
* Henry hub price 2013

local gas_cost 3.728

* 11 cents per kWh is NEAT assumed and in line with average retail price

local elec_pric= 0.11

* MISO wholesale 
local elec_cost=0.03290
* average retail rate
* multiply avg savings by retail price

* The annual reductions associated w RED estimates
* summarized in NPV.xls. These are imputed using estimated
* percentage reductions.

local loss_adj=1.05

* adjust site savings estimates (elec) for line losses in social benefit estimates.

local red_gas_btu=14.64
local red_elec_btu=2.46

local redp_gas_sav=`red_gas_btu'*`gas_pric'
local redp_elec_sav=`red_elec_btu'/0.003412*`elec_pric'

local redc_gas_sav=`red_gas_btu'*`gas_cost'
local redc_elec_sav=`red_elec_btu'/0.003412*`elec_cost'

* << Rebound>>

local upper 1.92

*<< Social cost per ton : co2, nitrogen (gas only) sulfur dioxide (gas only) >>
local SCC=38

local SCN=250

local SCS=970

/*>>> Emissions intensities assumed for natural gas
* Original file took emissions rates from a seminal source:
Natural Gas Emissions Rates: EPA-AP42-Natural Gas Combustion
http://www3.epa.gov/ttnchie1/ap42/ch01/final/c01s04.pdf

AND https://www.eia.gov/environment/emissions/co2_vol_mass.cfm

NOX         0.092000 lbs/MMBTU 

SO2          0.000584 lbs/MMBTU 

CO2         117.000000 lbs/MMBTU

https://www.epa.gov/energy/ghg-equivalencies-calculator-calculations-and-references uses 53.01 kg/mmbtu
*/

/*>>>GHG Emissions intensities assumed for MI electricity*/

*NEW ESTIMATES USING 2010-2012 data: 1.87 lbs CO2/kWh
local MOER=1.87
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/


use "$home_dirpath\DATA\NEAT_measure_level_savings.dta", clear

capture drop mmbtu_saved_CO2 kwh_saved_CO2

foreach var in heatingmbtu heatingsave coolingkwh coolingsave baseloadkwh baseloadsave level_cost {
egen `var'_sum=sum(`var'), by(neat_clientid)
				
		}
		
		gen bill_savings_sum=coolingsave_sum+baseloadsave_sum+heatingsave_sum	
		gen elec_kwh_sum=coolingkwh_sum+baseloadkwh_sum
		gen elec_sav_sum=coolingsave_sum+baseloadsave_sum
		gen btu_sav_sum=heatingmbtu_sum + ( elec_kwh_sum*0.003412)
		
		/* kg/mmbtu * ton/kg *mmbtu */
		gen mmbtu_saved_CO2_sum = (53.01)*(1/1000)*heatingmbtu_sum		
		
		* kwh * lbs /CO2 * tons/lb 
		gen kwh_saved_CO2 = (coolingkwh_sum + baseloadkwh_sum)*(`MOER'/2204.6)*`loss_adj'
		
* Note : SCC is in metric tons but I believe Muller numbers in terms of US tons *		
		gen CO2_sav_sum=mmbtu_saved_CO2_sum + kwh_saved_CO2
		gen NOX_sav_sum= heatingmbtu_sum*(0.092/2000)
		gen SO2_sav_sum= heatingmbtu_sum*(0.000584/2000)
		
keep neat_clientid *sum

duplicates drop

sort neat_clientid
save "$home_dirpath\DATA\final_tab.dta", replace
clear

use "$home_dirpath\DATA\CAA_data.dta ", clear
 gen IN_NEAT=1
		 replace IN_NEAT=0 if neat_clientid==.
		 
		 capture drop weath_post_mar2011 
			   
			  gen weath_pre_mar2011 = iwc_date_final_close_out < mdy(3,1,2011) & iwc_date_final_close_out !=.
  
			  gen weath_post_mar2011 = iwc_date_final_close_out >= mdy(3,1,2011) & iwc_date_final_close_out !=.
			  replace weath_post_mar2011 =1 if iwc_date_post_inspection >= mdy(3,1,2011) & iwc_date_post_inspection !=.
			  replace weath_post_mar2011 =1 if iwc_date_ctr_crw_job_complete >= mdy(3,1,2011) & iwc_date_ctr_crw_job_complete !=.
			  
			  gen weath_facs_post_mar2011 = facspro_stage_FinalCloseOut  == 1 & facspro_intakedate >= mdy(3,1,2011) & iwc_date_final_close_out ==. & IN_NEAT==1
			  
			  gen WAP=0
			  replace WAP=1 if weath_post_mar2011 == 1
			  replace WAP=1 if weath_facs_post_mar2011 == 1
			  
		
		 keep neat_clientid WAP neat_cost neat_cost_if_savings iwc_job_cost_est iwc_job_cost_act iwc_util_cost_elec iwc_util_cost_gas iwc_arra_cost iwc_non_energy_act iwc_non_energy_total iwc_total_cost neat_npv_savings_cum

sort neat_clientid

merge neat_clientid using "$home_dirpath/DATA/final_tab.dta"

keep if WAP==1
drop if neat_clientid==.

drop _merge

sort neat_clientid
save "$home_dirpath/DATA/final_tab.dta", replace
clear


use "$sec_dirpath\sample_composition.dta"
sort neat_clientid
merge neat_clientid using "$home_dirpath/DATA/final_tab.dta"

keep if WAP==1

table WAP, c(sum iwc_job_cost_act sum iwc_non_energy_total  sum bill_savings_sum) format(%9.2f) center

/***********************************/
/***  Panel A : private value  *****/

gen gas_sav_res_neat= heatingmbtu*`gas_pric'
gen elec_sav_res_neat=elec_kwh_sum*`elec_pric'

* Panel A column 1 : NEAT savings valued at retail prices*
gen sav_priv_neat=gas_sav_res + elec_sav_res

* Private savings valued at retail prices*
gen sav_priv_RED=`redp_gas_sav' + `redp_elec_sav'

* Private savings valued at retail prices w upper adjust*

gen sav_priv_RED_U=`redp_gas_sav' + `redp_elec_sav' + `upper'


/*******************************************************/
/***  Panel B : private value + avoided emissions *****/

* value NEAT emissions savings

gen emi_savc=CO2_sav_sum*38 
gen emi_savn=NOX_sav_sum*250
gen emi_savs =SO2_sav_sum*970

* RED emissions savings		
* 

*kg/mmbtu * metric ton/kg
		gen mmbtu_saved_CO2_red = (53.01)*(1/1000)*`red_gas_btu'					
		
* lb / mmbtu * ton/lb
		
		gen saved_NOX_red = (0.092)*(1/2000)*`red_gas_btu'
		
		gen saved_SO2_red = (0.000584)*(1/2000)*`red_gas_btu'
	
	
	/* conversion for CO2 emissions*/		
		* mmbtu * kwh/mmbtu * lb/mmbtu * metric ton/lb
		
		gen kwh_saved_CO2 = ((`red_elec_btu'*`loss_adj')/0.003412)*(`MOER'/2204.62)
		gen total_saved_CO2_red = mmbtu_saved_CO2_red + kwh_saved_CO2

gen emi_sav_c=total_saved_CO2_red*38
gen emi_sav_n=saved_NOX_red*250
gen emi_sav_s=saved_SO2_red*970

gen emi_sav_red= emi_sav_c + emi_sav_n + emi_sav_s


gen sav_mg_RED =emi_sav_red + sav_priv_RED_U
gen sav_mg_NEAT=sav_priv_neat +emi_savc+emi_savn+emi_savs



/***************************************************************************/
* Panel C : social adjustment - add avoided emissions damages as benefits */
* Use estimate of avoided operating costs versus retail prices which over estimate*

gen gas_sav_soc_neat=heatingmbtu*`gas_cost'
gen elec_sav_soc_neat=`elec_cost'*elec_kwh_sum*`loss_adj'

* neat cost avoided 
gen sav_soc_neat=gas_sav_soc+elec_sav_soc

* NEAT social value

gen sav_neat_soc= sav_soc_neat+emi_savc+emi_savn+emi_savs

* RED social value

gen sav_red_soc= emi_sav_red + `redc_gas_sav'+`redc_elec_sav'
gen sav_red_soc_U= emi_sav_red+ `redc_gas_sav'+`redc_elec_sav' + `upper'

******************************************************
* Social benefit for use in MAC calculations


gen sav_neat_soc_mac= sav_soc_neat + emi_savn + emi_savs
gen sav_RED_soc_mac=`redc_gas_sav'+`redc_elec_sav'+ emi_sav_n + emi_sav_s + `upper'


gen costsav_red_soc=`redc_gas_sav'+`redc_elec_sav'
gen costsav_red_soc_U=`redc_gas_sav'+`redc_elec_sav' + `upper'


* For now - brute force IRR in excel. Export costs and savings for each case.

replace iwc_non_energy_act=0 if iwc_non_energy_act==.

gen cost_if_savings= iwc_job_cost_act- iwc_non_energy_act

replace cost_if_savings=. if cost_if_savings==0

log using "$home_dirpath\LOG_FILES\final.log", replace

* summary stats required for realization rate calculations

table RED_CAT, c(mean elec_kwh_sum )
table RED_CAT, c(mean heatingmbtu_sum)
table RED_CAT, c(mean neat_npv_savings_cum)


* PANEL A

*cost (actual versus projected)
sum cost_if_savings
sum iwc_job_cost_act
sum neat_cost

table RED_ENC, c(mean iwc_job_cost_act)
table RED_CONT, c(mean iwc_job_cost_act)


*neat savings
sum sav_priv_neat

* rate adjusted savings
sum sav_priv_RED
sum sav_priv_RED_U


table RED_ENC, c(mean sav_priv_neat mean sav_priv_RED_U )
table RED_CONT, c(mean sav_priv_neat mean sav_priv_RED_U )

* PANEL B
 
sum sav_mg_NEAT
sum sav_mg_RED

table RED_ENC, c(mean  sav_mg_NEAT mean sav_mg_RED )
table RED_CONT, c(mean  sav_mg_NEAT mean sav_mg_RED)

*PANEL C

sum sav_neat_soc
sum sav_red_soc
sum sav_red_soc_U

table RED_ENC, c(mean  sav_neat_soc mean sav_red_soc_U )
table RED_CONT, c(mean sav_neat_soc mean sav_red_soc_U)

* adj res savings
sum CO2_sav_sum
sum total_saved_CO2_red


table RED_ENC, c(mean CO2_sav_sum mean total_saved_CO2_red)
table RED_CONT, c(mean CO2_sav_sum mean total_saved_CO2_red)


table RED_ENC, c(mean CO2_sav_sum mean CO2_sav_sum)
table RED_CONT, c(mean CO2_sav_sum mean CO2_sav_sum)


* MAC calculation inputs

sum sav_neat_soc_mac
sum sav_RED_soc_mac

table RED_ENC, c(mean  sav_neat_soc_mac mean sav_RED_soc_mac )
table RED_CONT, c(mean sav_neat_soc_mac mean sav_RED_soc_mac)


sum sav_soc_neat


log close




