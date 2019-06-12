clear all
cd "~/Dropbox/Ties that Double Bind Replication Data"

use data/conjoint_data.dta, clear

drop if first_orig == 0

replace sample = "Voter" if sample == "usa voter"
replace sample = "Legislator" if sample == "usa leg"


xi: reg winner i.orig_cand_female i.orig_1ys i.orig_3ys i.orig_8ys i.orig_MD_sp i.orig_FM_sp i.orig_law i.orig_may i.orig_leg i.orig_1ch i.orig_3ch i.orig_45 i.orig_65 if sample == "Voter" & dv == 1, cl(responseid)
estimates store voter_city

xi: reg winner i.orig_cand_female i.orig_1ys i.orig_3ys i.orig_8ys i.orig_MD_sp i.orig_FM_sp i.orig_law i.orig_may i.orig_leg i.orig_1ch i.orig_3ch i.orig_45 i.orig_65 if sample == "Voter" & dv == 2, cl(responseid)
estimates store voter_congress

xi: reg winner i.orig_cand_female i.orig_1ys i.orig_3ys i.orig_8ys i.orig_MD_sp i.orig_FM_sp i.orig_law i.orig_may i.orig_leg i.orig_1ch i.orig_3ch i.orig_45 i.orig_65 if sample == "Voter" & dv == 3, cl(responseid)
estimates store voter_governor

xi: reg winner i.orig_cand_female i.orig_1ys i.orig_3ys i.orig_8ys i.orig_MD_sp i.orig_FM_sp i.orig_law i.orig_may i.orig_leg i.orig_1ch i.orig_3ch i.orig_45 i.orig_65 if sample == "Legislator" & dv == 1, cl(responseid)
estimates store leg_city

xi: reg winner i.orig_cand_female i.orig_1ys i.orig_3ys i.orig_8ys i.orig_MD_sp i.orig_FM_sp i.orig_law i.orig_may i.orig_leg i.orig_1ch i.orig_3ch i.orig_45 i.orig_65 if sample == "Legislator" & dv == 2, cl(responseid)
estimates store leg_congress

xi: reg winner i.orig_cand_female i.orig_1ys i.orig_3ys i.orig_8ys i.orig_MD_sp i.orig_FM_sp i.orig_law i.orig_may i.orig_leg i.orig_1ch i.orig_3ch i.orig_45 i.orig_65 if sample == "Legislator" & dv == 3, cl(responseid)
estimates store leg_governor



coefplot voter_city, bylabel(Voters, City Council) || voter_congress, bylabel(Voters, Congress) || voter_governor, bylabel(Voters, Governor) ////
 || leg_city, bylabel('14 Leg, City Council) || leg_congress, bylabel('14 Leg, Congress) || leg_governor, bylabel('14 Leg, Governor) ////
 || , drop(_cons) xline(0) scheme(tufte) headings(_Iorig_cand_1 = "{bf: Male to}" ////
		_Iorig_1ys_1 = "{bf:0 years in politics to}" ////
		_Iorig_MD_s_1 = "{bf:Unmarried to}" ////
		_Iorig_law_1 = "{bf:Teacher to}" ////
		_Iorig_1ch_1 = "{bf:No children to}" ////
		_Iorig_45_1 = "{bf:29 years old to}" ////
		,labsize(vsmall)) ////
		coeflabel( ////
		_Iorig_cand_1 = "Female" ////
		_Iorig_1ys_1 = "1 year" ////
		_Iorig_3ys_1 = "3 years" ////
		_Iorig_8ys_1 = "8 years" ////
		_Iorig_MD_s_1 = "Doctor Spouse" //// 
		_Iorig_FM_s_1 = "Farmer Spouse" ////
		_Iorig_law_1 = "Corporate Lawyer" ////
		_Iorig_may_1 = "Mayor" ////
		_Iorig_leg_1 = "State Legislator" ////
		_Iorig_1ch_1 = "1 Child" ////
		_Iorig_3ch_1 = "3 Children" ////
		_Iorig_45_1 = "45 years old" ////
		_Iorig_65_1 = "65 years old" ////
		,labsize(vsmall)) ////
		xlabel(-.1 "-10" 0 "0" .1 "10" .2 "20") xtitle("Percentage Point Change in Probability of Winning")
		
graph export "figures/appendix_figs/fig1_bydv.pdf", replace

