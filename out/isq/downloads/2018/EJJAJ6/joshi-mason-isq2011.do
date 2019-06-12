//ISQ2011 JOSHI & MASON//
use  "C:\Users\mjoshi2\Desktop\Working Projects\ISQ2011files\ISQ-2010 Data.dta" 

//landless percentage of total household
gen ln_landless = ln(landless)
gen per_landless = (landless/totalhouseholds)*100
//Reviewer 1 suggested to combine dependency variables
gen dependency = per_landless+ per_total_hold_sharecrop+ per_total_hold_fixmoney+ per_total_hold_fixproduct+ per_total_hold_service+ per_total_hold_mortgage
label var dependency "sum of per_landless+ per_total_hold_sharecrop+ per_total_hold_fixmoney+ per_total_hold_fixproduct+ per_total_hold_service+ per_total_hold_mortgage"
//Generate districtwise development budget per capita
gen percapita_dev_99_00 =  dev_bud_99_00/ pop_2001
gen percapita_dev_94_95 = dev_bud_94_95/pop_1991

gen vote_91_dependency =  percent_regvote1991*dependency
gen vote_99_dependency =  percent_regvote1999*dependency

//Table 1: Descreptive Statistics
sum infamort lifeexpetancy_2001 adult_lit2001 meansy_sch2001 malnur_und5 per_acc_sanitation life_exp_96 adult_lit1996 meansy_sch96 percent_regvote1999   percent_regvote1991 totalcontestants1999 totalcontestants1991 per_noholding_below1_pa dependency  vote_99_dependency vote_91_dependency  percapita_dev_99_00 percapita_dev_94_95 pop_density_01 pop_den1991 cast_eth_fract              

//Table 2: 1996 models  
eststo: quietly reg life_exp_96  percent_regvote1991   totalcontestants1991   per_noholding_below1_pa dependency vote_91_dependency  percapita_dev_94_95  pop_den1991 cast_eth_fract, r
eststo: quietly reg adult_lit1996  percent_regvote1991   totalcontestants1991   per_noholding_below1_pa dependency vote_91_dependency  percapita_dev_94_95  pop_den1991 cast_eth_fract, r
eststo: quietly reg meansy_sch96 percent_regvote1991   totalcontestants1991   per_noholding_below1_pa dependency vote_91_dependency  percapita_dev_94_95  pop_den1991 cast_eth_fract, r
//esttab using "C:\Users\Madhav\Desktop\Working Projects\working paper09\ISQR-Table1.doc",replace title(Table 2: Democracy, Clientalism and Provision of Public Goods 1996.\label{tab1})se compress

eststo clear

// Table 3: 2001 models without total killed udring insurgency
eststo: quietly reg lifeexpetancy_2001  percent_regvote1999  totalcontestants1999   per_noholding_below1_pa dependency vote_99_dependency  percapita_dev_99_00 pop_density_01 cast_eth_fract, r
eststo: quietly reg adult_lit2001  percent_regvote1999  totalcontestants1999   per_noholding_below1_pa dependency vote_99_dependency  percapita_dev_99_00 pop_density_01 cast_eth_fract, r
eststo: quietly reg meansy_sch2001  percent_regvote1999  totalcontestants1999   per_noholding_below1_pa dependency vote_99_dependency  percapita_dev_99_00 pop_density_01 cast_eth_fract, r
eststo: quietly reg malnur_und5  percent_regvote1999  totalcontestants1999   per_noholding_below1_pa dependency vote_99_dependency  percapita_dev_99_00 pop_density_01 cast_eth_fract, r
eststo: quietly reg  per_acc_sanitation    percent_regvote1999  totalcontestants1999   per_noholding_below1_pa dependency vote_99_dependency  percapita_dev_99_00 pop_density_01 cast_eth_fract, r
eststo: quietly reg  infamort     percent_regvote1999  totalcontestants1999   per_noholding_below1_pa dependency vote_99_dependency  percapita_dev_99_00 pop_density_01 cast_eth_fract, r
//esttab using "C:\Users\Madhav\Desktop\Working Projects\working paper09\ISQR-Table2.doc",replace title(Table 3: Democracy, Clientalism and Provision of Public Goods 1996.\label{tab1})se compress
eststo clear

//Table 4 Models (2001 Models with totoalkilled_1000 but without voterturnout 1999)
reg lifeexpetancy_2001  totoalkilled_1000 totalcontestants1999   per_noholding_below1_pa dependency vote_99_dependency  percapita_dev_99_00 pop_density_01 cast_eth_fract, r
reg adult_lit2001 totoalkilled_1000  totalcontestants1999   per_noholding_below1_pa dependency vote_99_dependency  percapita_dev_99_00 pop_density_01 cast_eth_fract, r
reg meansy_sch2001 totoalkilled_1000  totalcontestants1999   per_noholding_below1_pa dependency vote_99_dependency  percapita_dev_99_00 pop_density_01 cast_eth_fract, r
reg malnur_und5 totoalkilled_1000  totalcontestants1999   per_noholding_below1_pa dependency vote_99_dependency  percapita_dev_99_00 pop_density_01 cast_eth_fract, r
reg per_acc_sanitation  totoalkilled_1000 totalcontestants1999   per_noholding_below1_pa dependency vote_99_dependency  percapita_dev_99_00 pop_density_01 cast_eth_fract, r
reg infamort totoalkilled_1000  totalcontestants1999   per_noholding_below1_pa dependency vote_99_dependency  percapita_dev_99_00 pop_density_01 cast_eth_fract, r


//Table 5: Development Budget Models
//Model 1
reg percapita_dev_94_95   percent_regvote1991 totalcontestants1991 per_noholding_below1_pa dependency vote_91_dependency  pop_den1991 cast_eth_fract, r
//Model 2
reg   percapita_dev_99_00 percent_regvote1999  totalcontestants1999 per_noholding_below1_pa dependency  vote_99_dependency pop_density_01 cast_eth_fract, r
