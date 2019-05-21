*
* Matthew Fuhrmann and Todd S. Sechser
* "Signaling Alliance Commitments: Hand-Tying and Sunk Costs in Extended Nuclear Deterrence"
* American Journal of Political Science, forthcoming
*


* Purpose
* This is a Stata replication file for "Signaling Alliance Commitments."  This file will reproduce the regressions, tables, and charts from the original article, as well as the regressions from the Supporting Information appendices.
*
* Location
* This command file and the associated dataset can be downloaded from <http://dvn.iq.harvard.edu/dvn/dv/tsechser> or <http://www.matthewfuhrmann.com>.
*
* Requirements
* 1. This file requires the "spost" Stata package.  It can be installed by typing "net install spost9_ado.pkg, from(http://www.indiana.edu/~jslsoc/stata)" (without quotes) into the Stata command window, or by visiting <http://www.indiana.edu/~jslsoc/stata/>.
* 2. This file also requires the "estout" Stata package.  It can be installed by typing "ssc install estout" (without quotes) into the Stata command window, or by visiting <http://repec.org/bocode/e/estout/installation.html>.
* 3. Figure 1 requires the "Clarify" Stata package.  It can be installed by typing "net install clarify, from(http://gking.harvard.edu/clarify)" (without quotes) into the Stata command window, or by visiting <http://gking.harvard.edu/clarify>.
* 4. Appendix C, Table 3 requires the "ReLogit" Stata package.  It can be obtained by visiting <http://gking.harvard.edu/relogit>.
* 5. This file requires the Stata dataset "Fuhrmann-Sechser-Appendices.dta", which can be downloaded from <http://dvn.iq.harvard.edu/dvn/dv/tsechser> or <http://www.matthewfuhrmann.com>.
*
* Version
* Last updated: April 6, 2014


* TABLE 2

eststo M1: probit military_conflict defense_pact_nuclear_cow nuclear_deployment defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction  time_conflict time_conflict2 time_conflict3 if politically_relevant==1, cluster(dyad_id)

eststo M2: probit military_conflict defense_pact_nuclear_atop nuclear_deployment defense_pact_nonnuclear_atop us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_atop  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction  time_conflict time_conflict2 time_conflict3 if politically_relevant==1, cluster(dyad_id)

eststo M3: probit military_conflict defense_pact_nuclear_cow nuclear_deployment defense_pact_deployment defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction  time_conflict time_conflict2 time_conflict3 if politically_relevant==1, cluster(dyad_id)

eststo M4: probit military_conflict defense_pact_nuclear_cow nuclear_deployment defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio_allies challenger_polity target_polity polity_interaction  time_conflict time_conflict2 time_conflict3 if politically_relevant==1, cluster(dyad_id)

esttab M1 M2 M3 M4, nodepvars nomtitles se(3) pr2 b(3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) title(Table 2: Probit Estimates of Militarized Dispute Initiation) varwidth(50)


* FIGURE 1

quietly estsimp probit military_conflict nuclear_deployment defense_pact_nuclear_cow defense_pact_deployment defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction  time_conflict time_conflict2 time_conflict3 if politically_relevant==1, cluster(dyad_id)
setx defense_pact_nonnuclear_cow median challenger_nuclear_weapons median target_nuclear_weapons median contiguity median alliance_with_challenger_cow median us_troops mean foreign_policy_similarity mean power_ratio mean challenger_polity mean target_polity mean polity_interaction mean time_conflict 0 time_conflict2 0 time_conflict3 0
setx defense_pact_nuclear_cow 0
simqi, fd(prval(1)) changex(nuclear_deployment 0 1 defense_pact_deployment 0 0) level(90)
setx defense_pact_nuclear_cow 1
simqi, fd(prval(1)) changex(nuclear_deployment 0 1 defense_pact_deployment 0 1) level(90)
drop b1-b18


* FIGURE 2

sort state_a state_b year
sort state_b
by state_b: egen sum_deploy = sum(nuclear_deployment)
gen eventual_host = 0
replace eventual_host = 1 if sum_deploy~=0 & sum_deploy ~= .
label var eventual_host "State B hosted foreign nuclear weapons at any point"
tab military_conflict if politically_relevant==1 & eventual_host ~= 1 
tab military_conflict nuclear_deployment if eventual_host == 1 & politically_relevant==1, column chi2


*APPENDIX B, TABLE 1

eststo M5: biprobit (nuclear_deployment = defense_pact_nuclear_cow target_nuclear_weapons target_polity distance_from_us shared_rival_nuclear distance_nuclear_rival civil_war npt post_cold_war time_deploy time_deploy2 time_deploy3) (military_conflict = defense_pact_nuclear_cow nuclear_deployment target_nuclear_weapons target_polity defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons contiguity alliance_with_challenger_cow foreign_policy_similarity power_ratio challenger_polity polity_interaction time_conflict time_conflict2 time_conflict3) if politically_relevant==1, cluster(dyad_id)

eststo M6: biprobit (nuclear_deployment = defense_pact_nuclear_cow target_nuclear_weapons target_polity distance_from_us shared_rival_nuclear distance_nuclear_rival civil_war npt post_cold_war time_deploy time_deploy2 time_deploy3) (military_conflict = defense_pact_nuclear_cow nuclear_deployment target_nuclear_weapons target_polity shared_rival_nuclear distance_nuclear_rival civil_war npt post_cold_war defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons contiguity alliance_with_challenger_cow foreign_policy_similarity power_ratio challenger_polity polity_interaction time_conflict time_conflict2 time_conflict3) if politically_relevant==1, cluster(dyad_id)

esttab M5 M6, nodepvars nomtitles se(3) pr2 b(3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) title(Appendix Table 1: Bivariate Probit Estimates of Foreign Nuclear Deployment and Militarized Dispute Initiation) varwidth(50)


*APPENDIX C, TABLE 2

*Only U.S. signals
eststo M7: probit military_conflict defense_pact_nuclear_cow nuclear_deployment_us defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction  time_conflict time_conflict2 time_conflict3 if politically_relevant==1, cluster(dyad_id)

*Alternate DV
eststo M8: probit military_conflict_force defense_pact_nuclear_cow nuclear_deployment defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction  time_force time_force2 time_force3 if politically_relevant==1, cluster(dyad_id)

*All directed-dyads
eststo M9: probit military_conflict defense_pact_nuclear_cow nuclear_deployment defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction  time_conflict time_conflict2 time_conflict3, cluster(dyad_id)

*Alternate troops measure
eststo M10: probit military_conflict defense_pact_nuclear_cow nuclear_deployment defense_pact_nonnuclear_cow us_troops_100 challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction  time_conflict time_conflict2 time_conflict3 if politically_relevant==1, cluster(dyad_id)

*Trade
eststo M11: probit military_conflict defense_pact_nuclear_cow nuclear_deployment defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction trade time_conflict time_conflict2 time_conflict3 if politically_relevant==1, cluster(dyad_id)

*Rare events logit
eststo M12: relogit military_conflict defense_pact_nuclear_cow nuclear_deployment defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction time_conflict time_conflict2 time_conflict3 if politically_relevant==1, cluster(dyad_id)

*Alternate nuclear deployment measure #1
eststo M13: probit military_conflict defense_pact_nuclear_cow nuclear_deployment_deterrence defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction time_conflict time_conflict2 time_conflict3 if politically_relevant==1, cluster(dyad_id)

*Alternate nuclear deployment measure #2
eststo M14: probit military_conflict defense_pact_nuclear_cow nuclear_deployment_liberal defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction time_conflict time_conflict2 time_conflict3 if politically_relevant==1, cluster(dyad_id)

*Recoding alliances and deployments
eststo M15: probit military_conflict defense_pact_nuclear_uncommon nuclear_deployment_uncommon defense_pact_nonnuclear_cow us_troops challenger_nuclear_weapons target_nuclear_weapons contiguity alliance_with_challenger_cow  foreign_policy_similarity power_ratio challenger_polity target_polity polity_interaction time_conflict time_conflict2 time_conflict3 if politically_relevant==1, cluster(dyad_id)

esttab M7 M8 M9 M10 M11 M12 M13 M14 M15, nodepvars nomtitles se(3) pr2 b(3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) title(Appendix Table 2: Probit and Rare Events Logit Estimates of Militarized Dispute Initiation) varwidth(50)
