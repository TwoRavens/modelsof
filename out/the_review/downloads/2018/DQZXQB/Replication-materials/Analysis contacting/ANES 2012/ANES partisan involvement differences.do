use "/Users/dbroock/Dropbox/Broockman-Skovron/Elite perceptions 2/Replication-materials/Analysis contacting/anes_timeseries_2012_withelecresults.dta"

local vars dhsinvolv_march dhsinvolv_board dhsinvolv_netpetition dhsinvolv_petition ///
	dhsinvolv_org dhsinvolv_call dhsinvolv_message dhsinvolv_letter ///
	dhsinvolv_contact1 involv_govoffic involv_commmtg
foreach var in `vars'{
	recode `var' (1 = 1) (2 = 0) (nonmiss = .)
}

recode pid_x (1/3 = 0) (4 = .) (5/7 = 1) (-2 = .), gen(rrep_not_dem)

replace hdemwinperc = hdemwinperc + .5
gen hrepwinperc = 1 - hdemwinperc

gen contact = dhsinvolv_contact1

tabstat contact [aw=weight_full], by(rrep_not_dem)

twoway (lowess contact hrepwinperc if hdemwin == 1 & hrepwinperc < 0.5 & rrep_not_dem == 0, lcol(blue)) ///
	(lowess contact hrepwinperc if hdemwin == 0 & hrepwinperc > 0.5 & rrep_not_dem == 0, lcol(blue)) ///
	(lowess contact hrepwinperc if hdemwin == 1 & hrepwinperc < 0.5 & rrep_not_dem == 1, lcol(red)) ///
	(lowess contact hrepwinperc if hdemwin == 0 & hrepwinperc > 0.5 & rrep_not_dem == 1, lcol(red)) ///
	if inrange(hrepwinperc, 0.3, 0.7), ///
	legend(order(1 "Democratic Voters" 3 "Republican Voters")) ///
	xtitle("Republican Share of the Two-Party Vote, Congressional Election") ///
	ytitle("Proportion Who Contacted Their Member of Congress in Next Congress") ///
	title("Republican Voters Contact Republican Elected Officials Extremely Often")

twoway (lowess rrep_not_dem hrepwinperc if hdemwin == 1 & hrepwinperc < 0.5 & contact == 1, lcol(blue)) ///
	(lowess rrep_not_dem hrepwinperc if hdemwin == 0 & hrepwinperc > 0.5 & contact == 1, lcol(red)) ///
	(lowess rrep_not_dem hrepwinperc, lcol(black)) ///
	if inrange(hrepwinperc, 0.3, 0.7), ///
	legend(order(1 "Democratic MCs" 2 "Republican MCs" 3 "Null - All Voters Contact Equally Often")) ///
	ytitle("Proportion of Contacts from" "All Partisans from Republicans") ///
	xtitle("Republican Share of the Two-Party Vote") ///
	title("Democratic Politicians Hear From Republican Voters Slightly More;" "Republican Politicians Hear From Republican Voters Disproportionately")


tab rep_not_dem dhsinvolv_contact1 [aweight = weight_full] if mc_party == "D", co nof
tab rep_not_dem dhsinvolv_contact1 [aweight = weight_full] if mc_party == "R", co nof

tabstat rep_not_dem [aweight = weight_full] if dhsinvolv_contact1 & mc_party == "D"
tabstat rep_not_dem [aweight = weight_full] if dhsinvolv_contact1 & mc_party == "R"

/*
recode pid_x (1/3 = 0) (4 = 1) (5/7 = 2) (-2 = .), gen(pid3)
label define pid3 0 "Dem" 1 "Ind" 2 "Rep"
label values pid3 pid3


tabstat dhsinvolv_call dhsinvolv_contact1 [aweight = weight_full], by(pid3) not

merge m:1 sample_state sample_district_prev using `mcparty', nogen keep(3)


tabstat dhsinvolv_call dhsinvolv_contact1 [aweight = weight_full] if mc_party == "D", by(pid3) not
tabstat dhsinvolv_call dhsinvolv_contact1 [aweight = weight_full] if mc_party == "R", by(pid3) not


*/

// ANES CDF
use "~/Google Drive/Broockman/Datasets/ANES/anes_timeseries_cdf_dta/anes_timeseries_cdf_stata12.dta", clear
recode VCF0950 (5 = 0) (1 = 1) (nonmiss = .)
recode VCF0301 (1/3 = 0) (4 = 1) (5/7 = 2), gen(pid3)
label define pid3 0 "Dem" 1 "Ind" 2 "Rep"
label values pid3 pid3

bysort VCF0004: tabstat VCF0950, by(pid3) not
