clear all

cd "~/Dropbox/Ties that Double Bind Replication Data/"

use "data/conjoint_data_2017leg.dta", clear

keep if first_pol == 1

rename pol_winner winner

xi: reg winner i.pol_cand_female i.pol_mayor i.pol_stateleg i.pol_MD_sp i.pol_FM_sp i.pol_law i.pol_1ch i.pol_3ch i.pol_45 i.pol_65

coefplot, note("Percentage Point Change in Probability of Winning", position(6) size(vsmall)) drop(_cons) xline(0) scheme(tufte) headings(_Ipol_cand__1 = "{bf: Male to}" ////
		_Ipol_mayor_1 = "{bf:No political experience to}" ////
		_Ipol_MD_sp_1 = "{bf:Unmarried to}" ////
		_Ipol_law_1 = "{bf:Teacher to}" ////
		_Ipol_1ch_1 = "{bf:No children to}" ////
		_Ipol_45_1 = "{bf:29 years old to}" ////
		,labsize(vsmall)) ////
		coeflabel( ////
		_Ipol_cand__1 = "Female" ////
		_Ipol_mayor_1 = "Mayor" ////
		_Ipol_state_1 = "State Legislator" ////
		_Ipol_MD_sp_1 = "Doctor Spouse" //// 
		_Ipol_FM_sp_1 = "Farmer Spouse" ////
		_Ipol_law_1 = "Lawyer" ////
		_Ipol_1ch_1 = "1 Child" ////
		_Ipol_3ch_1 = "3 Children" ////
		_Ipol_45_1 = "45 years old" ////
		_Ipol_65_1 = "65 years old" ////
		,labsize(vsmall)) ////
		xlabel(-.1 "-10" 0 "0" .1 "10" .2 "20") 
		
graph export "figures/appendix_figs/fig1_nopol.pdf", replace
