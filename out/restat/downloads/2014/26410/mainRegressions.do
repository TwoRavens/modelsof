/*
Main do file
*/

clear all
set more off
* This do file runs all the regression estimates reported in the article titled:
* "Statistical discrimination or prejudice? A large sample field experiment"
cd "~/Dropbox/Research/done/final-restat/"

log using "log.txt", replace text

use "mainData.dta", clear
	* Can also run
	* insheet using "mainData.csv", comma clear
	
************** Table 2 Cities Surveyed *********************
table city, c(n id mean pctblack mean pctblack_city mean rent)

************** Table 3 Summary Statistics **********************
sum weekend rent info_neg info_nil info_pos male black pctmales ///
	pctblack responded pos_resp

************** Table 4 Test of Random Assignment ******************

*** Pooled Gender
reg weekend black if info_nil, cl(neighborhood_id)

reg rent black if info_nil, cl(neighborhood_id)

reg pctblack black if info_nil, cl(neighborhood_id)

reg pctmales black if info_nil, cl(neighborhood_id)

reg weekend black if info_pos, cl(neighborhood_id)

reg rent black if info_pos, cl(neighborhood_id)

reg pctblack black if info_pos, cl(neighborhood_id)

reg pctmales black if info_pos, cl(neighborhood_id)

reg weekend black if info_neg, cl(neighborhood_id)

reg rent black if info_neg, cl(neighborhood_id)

reg pctblack black if info_neg, cl(neighborhood_id)

reg pctmales black if info_neg, cl(neighborhood_id)

*** Male
reg weekend black if info_nil & male, cl(neighborhood_id)

reg rent black if info_nil & male, cl(neighborhood_id)

reg pctblack black if info_nil & male, cl(neighborhood_id)

reg pctmales black if info_nil & male, cl(neighborhood_id)

reg weekend black if info_pos & male, cl(neighborhood_id)

reg rent black if info_pos & male, cl(neighborhood_id)

reg pctblack black if info_pos & male, cl(neighborhood_id)

reg pctmales black if info_pos & male, cl(neighborhood_id)

reg weekend black if info_neg & male, cl(neighborhood_id)

reg rent black if info_neg & male, cl(neighborhood_id)

reg pctblack black if info_neg & male, cl(neighborhood_id)

reg pctmales black if info_neg & male, cl(neighborhood_id)

*** Female
reg weekend black if info_nil & ~male, cl(neighborhood_id)

reg rent black if info_nil & ~male, cl(neighborhood_id)

reg pctblack black if info_nil & ~male, cl(neighborhood_id)

reg pctmales black if info_nil & ~male, cl(neighborhood_id)

reg weekend black if info_pos & ~male, cl(neighborhood_id)

reg rent black if info_pos & ~male, cl(neighborhood_id)

reg pctblack black if info_pos & ~male, cl(neighborhood_id)

reg pctmales black if info_pos & ~male, cl(neighborhood_id)

reg weekend black if info_neg & ~male, cl(neighborhood_id)

reg rent black if info_neg & ~male, cl(neighborhood_id)

reg pctblack black if info_neg & ~male, cl(neighborhood_id)

reg pctmales black if info_neg & ~male, cl(neighborhood_id)

************************* Results ******************************

*************** Table 5 Effectiveness of Information *********************
* Gender Pooled
reg responded info_pos if ~info_neg, cl(neighborhood_id)

reg responded info_neg if ~info_pos, cl(neighborhood_id)

reg pos_resp info_pos if ~info_neg, cl(neighborhood_id)

reg pos_resp info_neg if ~info_pos, cl(neighborhood_id)

* Male
reg responded info_pos if ~info_neg & male, cl(neighborhood_id)

reg responded info_neg if ~info_pos & male, cl(neighborhood_id)

reg pos_resp info_pos if ~info_neg & male, cl(neighborhood_id)

reg pos_resp info_neg if ~info_pos & male, cl(neighborhood_id)

* Female
reg responded info_pos if ~info_neg & female, cl(neighborhood_id)

reg responded info_neg if ~info_pos & female, cl(neighborhood_id)

reg pos_resp info_pos if ~info_neg & female, cl(neighborhood_id)

reg pos_resp info_neg if ~info_pos & female, cl(neighborhood_id)


************* Table 6 *************
**** Testable Implication 1 ****
reg pos_resp black if info_nil, cl(neighborhood_id)


**** Testable Implication 2 **** 
reg pos_resp black info_neg blackXinfo_neg if ~info_nil, cl(neighborhood_id)


**** Testable Implication 3 **** 
reg pos_resp black info_pos blackXinfo_pos info_neg blackXinfo_neg, cl(neighborhood_id)


**** Testable Implication 4 **** 
reg pos_resp black info_pos blackXinfo_pos info_neg blackXinfo_neg pctblack blackXpct pctXinfo_pos blackXpctXinfo_pos pctXinfo_neg blackXpctXinfo_neg, cl(neighborhood_id)


************ Table 7: Robustness checks ***************
reg pos_resp1 black info_pos blackXinfo_pos info_neg blackXinfo_neg pctblack blackXpct pctXinfo_pos blackXpctXinfo_pos pctXinfo_neg blackXpctXinfo_neg, cl(neighborhood_id)

reg pos_resp2 black info_pos blackXinfo_pos info_neg blackXinfo_neg pctblack blackXpct pctXinfo_pos blackXpctXinfo_pos pctXinfo_neg blackXpctXinfo_neg, cl(neighborhood_id)

reg pos_resp3 black info_pos blackXinfo_pos info_neg blackXinfo_neg pctblack blackXpct pctXinfo_pos blackXpctXinfo_pos pctXinfo_neg blackXpctXinfo_neg, cl(neighborhood_id)

reg pos_resp black info_pos blackXinfo_pos info_neg blackXinfo_neg pctblack blackXpct pctXinfo_pos blackXpctXinfo_pos pctXinfo_neg blackXpctXinfo_neg if (~rare), cl(neighborhood_id)


*********** Unreported robustness checks ***************
* Unreported robustness: add rent as proxy for risk aversion
reg pos_resp black info_pos blackXinfo_pos info_neg blackXinfo_neg pctblack blackXpct pctXinfo_pos blackXpctXinfo_pos pctXinfo_neg blackXpctXinfo_neg rent, cl(neighborhood_id)

* Unreported robustness: add rent & rent squared as proxy for risk aversion
reg pos_resp black info_pos blackXinfo_pos info_neg blackXinfo_neg pctblack blackXpct pctXinfo_pos blackXpctXinfo_pos pctXinfo_neg blackXpctXinfo_neg rent rent2, cl(neighborhood_id)

* Unreported robustness: add relative rent to the mean neighborhood rent as proxy for risk aversion
reg pos_resp black info_pos blackXinfo_pos info_neg blackXinfo_neg pctblack blackXpct pctXinfo_pos blackXpctXinfo_pos pctXinfo_neg blackXpctXinfo_neg rel_rent, cl(neighborhood_id)

* Unreported robustness: add relative rent to the mean neighborhood rent and its squared as proxy for risk aversion
reg pos_resp black info_pos blackXinfo_pos info_neg blackXinfo_neg pctblack blackXpct pctXinfo_pos blackXpctXinfo_pos pctXinfo_neg blackXpctXinfo_neg rel_rent rel_rent2, cl(neighborhood_id)

************ Table 8: Positive response rates and mother's education ***************
table first_name if white & female, c(mean pos_resp mean first_meduc)
spearman pos_resp first_meduc if white & female

table first_name if white & male, c(mean pos_resp mean first_meduc)
spearman pos_resp first_meduc if white & male

table first_name if black & female, c(mean pos_resp mean first_meduc)
spearman pos_resp first_meduc if black & female

table first_name if black & male, c(mean pos_resp mean first_meduc)
spearman pos_resp first_meduc if black & male

log close

