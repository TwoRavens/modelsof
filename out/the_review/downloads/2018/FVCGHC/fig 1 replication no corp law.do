clear all

cd "~/Dropbox/Ties that Double Bind Replication Data/"

use "data/conjoint_data_2017leg.dta", clear

keep if first_corp == 1

rename corp_winner winner

xi: reg winner i.corp_cand_female i.corp_1ys i.corp_3ys i.corp_8ys i.corp_MD_sp i.corp_FM_sp i.corp_law i.corp_may i.corp_leg i.corp_1ch i.corp_3ch i.corp_45 i.corp_65

coefplot, note("Percentage Point Change in Probability of Winning", position(6) size(vsmall)) drop(_cons) xline(0) scheme(tufte) headings(_Icorp_cand_1 = "{bf: Male to}" ////
		_Icorp_1ys_1 = "{bf:0 years in politics to}" ////
		_Icorp_MD_s_1 = "{bf:Unmarried to}" ////
		_Icorp_law_1 = "{bf:Teacher to}" ////
		_Icorp_1ch_1 = "{bf:No children to}" ////
		_Icorp_45_1 = "{bf:29 years old to}" ////
		,labsize(vsmall)) ////
		coeflabel( ////
		_Icorp_cand_1 = "Female" ////
		_Icorp_1ys_1 = "1 year" ////
		_Icorp_3ys_1 = "3 years" ////
		_Icorp_8ys_1 = "8 years" ////
		_Icorp_MD_s_1 = "Doctor Spouse" //// 
		_Icorp_FM_s_1 = "Farmer Spouse" ////
		_Icorp_law_1 = "Lawyer" ////
		_Icorp_may_1 = "Mayor" ////
		_Icorp_leg_1 = "State Legislator" ////
		_Icorp_1ch_1 = "1 Child" ////
		_Icorp_3ch_1 = "3 Children" ////
		_Icorp_45_1 = "45 years old" ////
		_Icorp_65_1 = "65 years old" ////
		,labsize(vsmall)) ////
		xlabel(-.1 "-10" 0 "0" .1 "10" .2 "20") 
		
graph export "figures/appendix_figs/fig1_nocorp.pdf", replace
