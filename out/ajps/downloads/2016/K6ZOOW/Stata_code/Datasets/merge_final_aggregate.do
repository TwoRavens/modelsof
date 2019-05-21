***************************************************************************
* File:               merge_final_aggregate.do
* Authors:            Miguel R. Rueda
* Description:        Returns final dataset used in aggregate analysis.
* Created:            Aug - 16 - 2013
* Last Modified: 	  
* Language:           STATA 13.1
* Related Reference:  "Small aggregates"
***************************************************************************


clear


*Open municipality level controls dataset
use controls.dta,replace

*Merge with electoral manipulation citizens' reports
merge 1:1 muni_code year using "panel_citizen_report.dta"
drop if _merge==2
drop _merge

*Merge with election monitors' reports
merge 1:1 muni_code year using "panel_depvar.dta"
drop if _merge==2
drop _merge

foreach num in 1 2{
gen VB_tot`num'=e_vote_buying/e_total`num'
gen NTB_tot`num'=e_neg_t_buying/e_total`num'
gen man_tot`num'=e_manipulating_results/e_total`num'
}
gen ltrend_f=log(trend_f)
gen sum_vb=vote_buying_moe+moving_votes_moe
gen VB_pc=e_vote_buying/Population*1000
gen NTB_pc=e_neg_t_buying/Population*1000
gen man_pc=e_manipulating_results/Population*1000
gen monitor_MOE=0
replace monitor_MOE=1 if vote_buying_moe!=.
label var monitor_MOE "Monitors are present"
gen lpot_mesa=log(potencial/mesas)
gen pot_mesa=potencial/mesas
gen sum_vb_pc=sum_vb/Population*1000

*Declaring panel
tsset muni_code year, yearly

*Deleting auxiliary variables or controls that are not used in analysis 

drop royalties guerrillas paras coca tax_revenue royalties2 royalties_p royalties2_p  ///
ipc royalties2_d royalties2_d_pc pot_mesa_75 pot_mesa_min pot_mesa_max share_sq total_blancos_nulos total_votes e_parties e_parties_av ///
elec_type v_votes_presidente margin_presidente v_votes_gobernador margin_gobernador v_votes_alcalde margin_alcalde local_e_parties ///
local_e_parties_av nbi_i_sq paras_2 guerrillas_2 sec_hom_pol area_ur area_ur area_ru area_tot share_area_ur Share_area_rur area coca_area ///
lroyalties2_p lpot_mesa_min reform share_rur depto_populat20 nal_populat20 gen_populat20 loc_populat20 mar_presidente ///
mar_gobernador mar_alcalde mar_concejo mar_asamblea mar_camara mar_senado margin_index1 margin_index3 le_parties llocal_e_parties lweighted_size ///
party_code dpto_code tot_blank tot_votes margin l4lweighted_size  size_q pol_suport deny_c_register manipulating_results delay weighted_size ///
z_pob_mesa z_pob_mesa2 z_pob_mesa3 lpotencial_sq discont discont2 discont3 trend trend2 trend3 ///
other neg_t_buying f_irregular_voting irregular_voting vote_buying moving_votes information intimidation perturbacion f_irregular_voting_a ///
irregular_voting_a perturbacion_a neg_t_buying_a delay_a pol_suport_a information_a vote_buying_a intimidation_a manipulating_results_a ///
f_irregular_voting_b irregular_voting_b perturbacion_b neg_t_buying_b delay_b pol_suport_b information_b vote_buying_b intimidation_b manipulating_results_b ///
f_irregular_voting_c irregular_voting_c perturbacion_c neg_t_buying_c delay_c pol_suport_c information_c vote_buying_c intimidation_c manipulating_results_c ///
f_irregular_voting_d irregular_voting_d perturbacion_d neg_t_buying_d delay_d pol_suport_d information_d vote_buying_d intimidation_d manipulating_results_d ///
d_vote_buying d_perturbacion d_pol_suport d_neg_t_buying d_manipulating_results d_f_irregular_voting d_information d_intimidation d_irregular_voting d_delay ///
e_perturbacion e_pol_suport e_f_irregular_voting e_information e_intimidation e_irregular_voting e_irregular_voting di_moving_votes ///
di_intimidation di_vote_buying di_neg_t_buying e_total1 e_total2 intimidation_moe pol_suport_moe irregular_voting_moe type ///
total_moe monitors_moe VB_tot1 NTB_tot1 man_tot1 VB_tot2 VB_tot2 man_tot2 NTB_tot2 NTB_pc man_pc sum_vb_pc e_delay

label var pob_mesa_q "quartiles registered voters per polling station"
label var VB_pc "citizens' reports of vote buying per 1000 people"
label var muni_code "municipality code"
label var year "year"
label var departamento "department name"
label var municipio "municipality name"
label var ingresos_totales "total revenues municipality (million current pesos), DNP"
label var own_resources_p "local revenues as % of total revenues, DNP"
label var revenue_current_p "revenue destined to be used in current expenditures % of total revenues, DNP"
label var tax_revenue_p "tax revenues as % of total revenues, DNP"
label var population "total population, DANE"
label var depto_code "department code"
label var nbi "percentage of population living in poverty, DANE"
label var pot_mesa_mean "average number of registered voters per polling station, Registraduria"
label var potencial "registered voters, Registraduria"
label var mesas "polling stations, Registraduria"
label var pot_mesa_med "median number of registered voters per polling station, Registraduria"
label var local_e "local election year"
label var lroyalties2_d_pc "ln of mining royalties per capita, DNP"
label var lpopulation "ln of total population"
label var lpot_mesa_med "ln of registered per polling station"
label var lpot_mesa_mean "ln of median of registered per polling station" 
label var lvoter_mesa "ln of votes per polling station"
label var voter_mesa "votes per polling station"
label var armed_actor "guerrillas or paramilitaries operate in municipality, CERAC"
label var Population20 "population 20 years or older, DANE"
label var pob_mesa "population 20 years or older per polling station"
label var lpob_mesa "ln of population 20 years or older per polling station"
label var size2 "size of the electorate weighted by votes in each race in the municipality"
label var lsize2 "ln of size of the electorate weighted by votes in each race in the municipality"
label var size "size of the electorate"
label var lsize "ln of size of the electorate"
label var le_parties_av "ln of average effective number of parties"
label var closeness_CG "fraction of senators voting in favor of legislation supported by the central government who belong to the party of the mayor"
label var lnbi_i "ln of interpolated poverty index"
label var margin_index2 "average margin of victory weighted by votes in each race"
label var l4margin_index2 "average margin of victory weighted by votes of each race in previous election"
label var llnbi_i "ln of interpolated poverty index lagged one year"
label var lown_resources "local revenues as % of total revenues lagged one year" 
label var larmed_actor "guerrillas or paramilitaries operate in municipality in previous year"
label var lcoca_area "area with coca fields/total area of municipality lagged one year"
label var l4lsize "ln of size of the electorate in previous election"
label var l4lpob_mesa "ln of population 20 years or older per polling station in previous election" 
label var z_pob_mesa_f "size of average polling station according to institutional rule"
label var m_pob_mesa "registered voters/number of polling stations, Registraduria"
label var lz_pob_mesa_f "ln of size of average polling station according to institutional rule"
label var lm_pob_mesa "ln of registered voters/number of polling stations, Registraduria"
label var lpotencial "ln of registered voters" 
label var potencial_cu "registered voters^3"
label var potencial_sq "registered voters^2"
label var discont_f "discontinuity sample"
label var trend_f "linear trend of institutional polling place size robustness test Fuzzy RD"
label var e_vote_buying "vote buying citizens' reports, Fiscalia"
label var e_neg_t_buying "turnout suppression citizens' reports, Fiscalia"
label var e_manipulating_results "fraud citizens' reports, Fiscalia"
label var sum_vb "vote buying monitors' reports, MOE"
label var monitor_MOE "MOE monitors are present in municipality"
label var vote_buying_moe "vote buying MOE. Does not include bribed people outside district"
label var manipulating_results_moe "fraud monitors' reports, MOE"
label var lpot_mesa "ln of registered per polling station"
label var pot_mesa "registered per polling station"
label var neg_t_buying_moe "turnout suppression reports, MOE"
label var nbi_i "linearly interpolated poverty index"
label var ltrend_f "ln of trend_f"
order muni_code year departamento municipio sum_vb e_vote_buying e_neg_t_buying neg_t_buying_moe pob_mesa lpob_mesa ///
m_pob_mesa lm_pob_mesa z_pob_mesa_f lz_pob_mesa_f lown_resources larmed_actor margin_index2 nbi_i nbi lnbi_i llnbi_i lsize lpotencial ///
potencial_cu potencial_sq trend_f Population20 lroyalties2_d_pc local_e
save final_aggregate.dta,replace


*****************************************************************************

**To create dataset used for Li-Trivedi_Guo models in Matlab run the following

*nbreg e_vote_buying l4.margin_index2 l.lnbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if year!=2008&year!=2009, cluster(muni_code)
*keep if e(sample)
*keep muni_code year l4margin_index2 llnbi_i lown_resources larmed_actor lcoca_area e_vote_buying e_manipulating_results e_neg_t_buying lpopulation l4lpob_mesa l4lsize closeness_CG monitor_MOE
*order muni_code year e_vote_buying e_neg_t_buying e_manipulating_results l4margin_index2 llnbi_i l4lpob_mesa lown_resources lpopulation larmed_actor l4lsize closeness_CG monitor_MOE
*export excel using "panel_matlab_aggregate.xls", sheet("panel_vote_buying") sheetreplace firstrow(variables)

**Note: variable larmed_actor is exported as a text variable. IT NEEDS TO BE CHANGED TO a NUMERICAL FORMAT in Excel before running Matlab.


*****************************************************************************


**To create pre_amelia.dta used as input to create multiple imputation datasets run the following

*use final_aggregate.dta,clear

**Defining variables that will be used in the analysis.

*gen VB=moving_votes_moe+vote_buying_moe
*gen l4le_parties=l4.le_parties
*gen l4le_parties_av=l4.le_parties_av
*gen l4pob_mesa=l4.pob_mesa
*gen la_nbi_i=l.nbi_i

*keep muni_code year e_vote_buying e_neg_t_buying VB e_manipulating_results neg_t_buying_moe Population20 moving_votes_moe pot_mesa_med manipulating_results_moe lcoca_area vote_buying_moe l4margin_index2 la_nbi_i l4pob_mesa lown_resources lpopulation larmed_actor l4lsize revenue_current_p tax_revenue_p lroyalties2_d_pc closeness_CG l4le_parties_av
*keep if year!=2008&year!=2009&year!=2004&year!=2005&year>=2006

*order muni_code year e_vote_buying e_neg_t_buying e_manipulating_results l4margin_index2 la_nbi_i l4pob_mesa lown_resources lpopulation larmed_actor  l4lsize closeness_CG
*save pre_amelia.dta,replace



