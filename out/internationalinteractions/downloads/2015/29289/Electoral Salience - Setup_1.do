***************************************************
* Project: Two-Dimensional Trade Salience Project *
* Title:   Setup_1			                      *
***************************************************

clear all
cd 
use "TradeSalience_Experiment_Winter2013.dta"

**********************
* Creating variables *
**********************
label define cond 1 "Low Welfare/High Simplicity" 2 "High Welfare/High Simplicity" 3 "Low Welfare/Low Simplicity" 4 "High Welfare/Low Simplicity"
* CONDITION VARIABLES *
* Condition #1
gen cond1 = .
replace cond1 = 1 if cond == 1
replace cond1 = 0 if cond != 1
label variable cond1 "Condition #1"
* Condition #2
gen cond2 = .
replace cond2 = 1 if cond == 2
replace cond2 = 0 if cond != 2
label variable cond2 "Condition #2"
* Condition #3
gen cond3 = .
replace cond3 = 1 if cond == 3
replace cond3 = 0 if cond != 3
label variable cond3 "Condition #3"
* Condition #4
gen cond4 = .
replace cond4 = 1 if cond == 4
replace cond4 = 0 if cond != 4
label variable cond4 "Condition #4"
* Welfare condition *
gen wel_low = 1
replace wel_low = 0 if cond == 2
replace wel_low = 0 if cond == 4
label variable wel_low "Low Welfare Conditions"
label define wel_low 0 "High Welfare" 1 "Low Welfare" 
gen wel_high = 1
replace wel_high = 0 if cond == 1
replace wel_high = 0 if cond == 3
label variable wel_high "High Welfare Conditions"
* Simplicity condition
gen simp_low = 1
replace simp_low = 0 if cond == 1
replace simp_low = 0 if cond == 2
label variable simp_low "Low Simplicity Conditions"
label define simp_low 0 "High Simplicity" 1 "Low Simplicity"
gen simp_high = 1
replace simp_high = 0 if cond == 3
replace simp_high = 0 if cond == 4
label variable simp_high "High Simplicity Conditions"


* SALIENCE VARIEABLES *
* Creating variable... Salience based upon Representative Voting for the Policy
gen vote_sal1 = .
replace vote_sal1 = 0 if vote1 == 3
replace vote_sal1 = 1 if vote1 == 2
replace vote_sal1 = 1 if vote1 == 4
replace vote_sal1 = 2 if vote1 == 1
replace vote_sal1 = 2 if vote1 == 5
label variable vote_sal1 "Policy Salience (representative voted)"
label define vote_sal1 0 "Not salient" 1 "Somewhat Salient" 2 "Very Salient"
* Creating variable... Salience based upon Representative Proposing the Policy
gen vote_sal2 = .
replace vote_sal2 = 0 if vote2 == 3
replace vote_sal2 = 1 if vote2 == 2
replace vote_sal2 = 1 if vote2 == 4
replace vote_sal2 = 2 if vote2 == 1
replace vote_sal2 = 2 if vote2 == 5
label variable vote_sal2 "Policy Salience (representative proposed)"
label define vote_sal2 0 "Not salient" 1 "Somewhat Salient" 2 "Very Salient"
gen vote_sal2_bi = 1 if vote_sal2 == 1
replace vote_sal2_bi = 1 if vote_sal2 == 2
replace vote_sal2_bi = 0 if vote_sal2 == 0
label variable vote_sal2_bi "Dichotomous Policy Salience (rep proposed)"
* Creating variable... Salience based upon Obama Proposing the Policy
gen obama_sal = .
replace obama_sal = 0 if obama_propose == 3
replace obama_sal = 1 if obama_propose == 2
replace obama_sal = 1 if obama_propose == 4
replace obama_sal = 2 if obama_propose == 1
replace obama_sal = 2 if obama_propose == 5
label variable obama_sal "Policy Salience (Obama proposed)"
label define obama_sal 0 "Not salient" 1 "Somewhat Salient" 2 "Very Salient"
* Creating variable... Salience based upon perceived Policy Effects
gen effects_sal = .
replace effects_sal = 0 if policy_effects == 3
replace effects_sal = 1 if policy_effects == 2
replace effects_sal = 1 if policy_effects == 4
replace effects_sal = 2 if policy_effects == 1
replace effects_sal = 2 if policy_effects == 5
label variable effects_sal "Policy Salience (perceived effects)"
label define effects_sal 0 "Not salient" 1 "Somewhat Salient" 2 "Very Salient"


********************************
* Preparing for pairwise tests *
********************************
gen pair1 = .   // Cond1 to Cond2 where Cond1 = 1
replace pair1 = 0 if cond == 1
replace pair1 = 1 if cond == 2
label variable pair1 "Condition 1 to Condition 2"
label define pair1 0 "Condition 1" 1 "Condition 2"
gen pair2 = .   // Cond1 to Cond3 where Cond1 = 1
replace pair2 = 0 if cond == 1
replace pair2 = 1 if cond == 3
label variable pair2 "Condition 1 to Condition 3"
label define pair2 0 "Condition 1" 1 "Condition 3"
gen pair3 = .   // Cond1 to Cond4 where Cond1 = 1
replace pair3 = 0 if cond == 1
replace pair3 = 1 if cond == 4
label variable pair3 "Condition 1 to Condition 4"
label define pair3 0 "Condition 1" 1 "Condition 4"
gen pair4 = .   // Cond2 to Cond3 where Cond2 = 1
replace pair4 = 0 if cond == 2
replace pair4 = 1 if cond == 3
label variable pair4 "Condition 2 to Condition 3"
label define pair4 0 "Condition 2" 1 "Condition 3"
gen pair5 = .   // Cond2 to Cond4 where Cond2 = 1
replace pair5 = 0 if cond == 2
replace pair5 = 1 if cond == 4
label variable pair5 "Condition 2 to Condition 4"
label define pair5 0 "Condition 2" 1 "Condition 4"
gen pair6 = .   // Cond3 to Cond4 where Cond3 = 1
replace pair6 = 0 if cond == 3
replace pair6 = 1 if cond == 4
label variable pair6 "Condition 3 to Condition 4"
label define pair6 0 "Condition 3" 1 "Condition 4"


** SOPHISTICATION INDEX **
replace currency = 0 if currency != 3
replace currency = 1 if currency == 3
replace foreign_id1 = 0 if foreign_id1 != 1
replace foreign_id1 = 1 if foreign_id1 == 1
replace foreign_id2 = 0 if foreign_id2 != 5
replace foreign_id2 = 1 if foreign_id2 == 5
replace foreign_id3 = 0 if foreign_id3 != 2
replace foreign_id3 = 1 if foreign_id3 == 2
replace house = 0 if house != 2
replace house = 1 if house == 2
replace terms = 0 if terms != 2
replace terms = 1 if terms == 2
gen place = .  // placeholder for whether Obama was placed to the left of Romney
replace place = 0 if obama > romney
replace place = 0 if obama == romney
replace place = 1 if obama < romney
label variable place "Obama to left of Romney"
* Generating sophistication variables *
gen soph_int = currency + foreign_id1 + foreign_id2 + foreign_id3  // International Sophistication //
label variable soph_int "International Political Sophistication"   
gen soph_dom = house + terms + place   // Domestic Sophistication //
label variable soph_dom "Domestic Political Sophistication"
gen soph = soph_int + soph_dom   // All Sophistication //
label variable soph "Political Sophistication"
gen soph_bi = 1 if soph > 5
replace soph_bi = 0 if soph < 6
label variable soph_bi "Political Sophistication (dichotomous)"


** Party affiliation **
gen dem = 1 if party_id == 2
replace dem = 0 if party_id != 2
gen rep = 1 if party_id == 1
replace rep = 0 if party_id != 1
** Ideology **
replace ideology = . if ideology == 8
gen lib = 1 if ideology < 4
replace lib = 0 if ideology > 4
label variable lib "Liberalism"

gen news_p = 1 if print_news < 3
gen news_t = 1 if tv_news < 3 
gen involve = 0 if voted != 1 & donate == 2
replace involve = 1 if voted == 1 & donate == 1



** NATIONALISM Index **
gen nat1 = .
replace nat1 = -2 if nationalism1 == 5
replace nat1 = -1 if nationalism1 == 4
replace nat1 = 0 if nationalism1 == 3
replace nat1 = 1 if nationalism1 == 2
replace nat1 = 2 if nationalism1 == 1
gen nat2 = .
replace nat2 = -2 if nationalism2 == 5
replace nat2 = -1 if nationalism2 == 4
replace nat2 = 0 if nationalism2 == 3
replace nat2 = 1 if nationalism2 == 2
replace nat2 = 2 if nationalism2 == 1
gen nat = (nat1 + nat2)/2 + 2
label variable nat "Nationalism Index (0 to 4)"
gen nat_bi = 1 if nat > 2
replace nat_bi = 0 if nat < 2.5
label variable nat_bi "Nationalism (dichotomous)"

** Trade Liberalization attitude **
gen free1 = .
replace free1 = -1 if statements1 == 1
replace free1 = 0 if statements1 == 2
replace free1 = 1 if statements1 == 3
gen free2 = .
replace free2 = -1 if statements2 == 1
replace free2 = -0.5 if statements2 == 2
replace free2 = 0 if statements2 == 3
replace free2 = 0.5 if statements2 == 4
replace free2 = 1 if statements2 == 5
gen free = (free1 + free2) + 2
label variable free "Attitude on Trade Liberalization"



gen vote_sal1_soph = vote_sal1 if soph_bi == 1  // Salience when Rep votes (sophisticated only)
gen vote_sal1_non = vote_sal1 if soph_bi == 0   // Salience when Rep votes (non-sophisticated only)
gen vote_sal2_soph = vote_sal2 if soph_bi == 1  // Salience when Rep proposes (sophisticated only)
gen vote_sal2_non = vote_sal2 if soph_bi == 0   // Salience when Rep proposes (non-sophisticated only)
gen vote_sal2_int = vote_sal2 if pol_interest == 1   // Salience for "Politically Interested"
gen vote_sal2_nint = vote_sal2 if pol_interest != 1  // Salience for "Not Politically Interested"
gen effects_sal_soph = effects_sal if soph_bi == 1  // Perceieved effects of policy (sophisticated only)
gen effects_sal_non = effects_sal if soph_bi == 0   // Perceieved effects of policy (non-sophisticated only)

gen vote_sal2_edu = vote_sal2 if parent_edu > 3  // Salience when Rep proposes (at least one parent has bachelor's)



* Saving...
save "Winter2013_working.dta", replace
