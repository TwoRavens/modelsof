********************************************************************************************************************************************************
*** Replication Materisl for "Do Hawks and Doves Deliver? The Words and Deeds of Foreign Policy in Democracies"***
********************************************************************************************************************************************************


/* Variable List:
id: unique dyad identifer
ts: time-series identifier
cwinit: Any MID initiation
militarism_index: main independent variable computed from CMP data
standard_mil
cap_proportion: natural log of ratio of capabilities plus one
polity22/polity21: Polity IV score of the target/initiator state
s_wt_glo: global weighted S-score
ln_distance: natural log of distance between states plus one (in miles)
other_initiations_dichot: dichotomous measure of whether state A has initiated any other MIDs in each quarter
grgdpch: yearly measure of GDP growth from the Penn World Tables
proportion_ciep: proportion of constitutional inter-eleciton period remaining for each democracy from Seki and Williams' update of WKB data
single_party_majority: dichotomous indicator of ogvernment type
coalition: dichotomous indicator of government type
caretaker: dichotomous indicator of government type
coalition_ideology_distance: right-left difference between PM/president and government overall calculated using CMP data
purged_pm_rile: continuous measure of PM/president's ideological position using CMP data with all external relations variables purged
pol_rel: dichotomous indicator of political relevance
various peace quarters variables: counts of peace quarters in each dyad over time computed using btscs command
*/


*Replicating Table 2

use "Initiated MIDs.dta", clear

*all mids
logit cwinit militarism_index cap_proportion polity22 s_wt_glo ln_distance other_initiations_dichot grgdpch proportion_ciep single_party_majority coalition coalition_ideology_distance purged_pm_rile  peaceq peaceqsq peaceqcu if(pol_rel==1) & (caretaker==0), robust cluster(id)

*with standardized IV
logit cwinit standard_mil cap_proportion polity22 s_wt_glo ln_distance other_initiations_dichot grgdpch proportion_ciep single_party_majority coalition coalition_ideology_distance purged_pm_rile peaceq peaceqsq peaceqcu if  (caretaker==0) & pol_rel==1, robust cluster(id)

*hostile mids  **requires rare events logit package to run
relogit hostile_mid militarism_index cap_proportion polity22 s_wt_glo ln_distance other_initiations_dichot grgdpch proportion_ciep single_party_majority coalition coalition_ideology_distance purged_pm_rile hostilepeaceq hostilepeaceqsq hostilepeaceqcu if(pol_rel==1) & (caretaker==0)

*fatal mids   **requires rare events logit package to run
relogit fatal_mid militarism_index cap_proportion polity22 s_wt_glo ln_distance other_initiations_dichot grgdpch proportion_ciep single_party_majority coalition coalition_ideology_distance purged_pm_rile fatalpeaceq fatalpeaceqsq fatalpeaceqcu if(pol_rel==1) & (caretaker==0)


*Replicating Table 4 **Simualtions require Clarify. Replciations results will differ slightly from published results because Clarify uses stochastic simulation techniques to estimate parameters in each scenario.

estsimp logit cwinit militarism_index cap_proportion polity22 s_wt_glo ln_distance other_initiations_dichot grgdpch proportion_ciep single_party_majority coalition coalition_ideology_distance purged_pm_rile  peaceq peaceqsq peaceqcu if(pol_rel==1) & (caretaker==0), robust cluster(id)

*** Scenario 1: Low Risk of Conflict
setx militarism_index p25 cap_proportion p25 polity22 p75 s_wt_glo p75 ln_distance p75  other_initiations_dichot 0 grgdpch p75 proportion_ciep p25 single_party_majority 0 coalition 1 coalition_ideology_distance -1.19 purged_pm_rile p25   ///
peaceq 80 peaceqsq 6400 peaceqcu 512000

simqi, prval(1) listx
simqi, fd(prval(1)) changex(militarism_index .52 4.6)
simqi, fd(prval(1)) changex(cap_proportion .69 0.73)
simqi, fd(prval(1)) changex( polity22 .9231775 -6.831)


***Scenario 2: Moderate Risk of Conflict

setx militarism_index p50 cap_proportion p50 polity22 p50 s_wt_glo p50 ln_distance p50 other_initiations_dichot 0  grgdpch p50  proportion_ciep p50 single_party_majority 0 coalition 1 coalition_ideology_distance p50 purged_pm_rile p50   ///
peaceq 40 peaceqsq 1600 peaceqcu 64000

simqi, prval(1) listx
simqi, fd(prval(1)) changex(militarism_index .52 4.6)
simqi, fd(prval(1)) changex(cap_proportion .69 0.73)
simqi, fd(prval(1)) changex( polity22 .9231775 -6.831)

*** Scenario 3: High Risk of Conflict

setx militarism_index p75 cap_proportion p75 polity22 p25 s_wt_glo p25 ln_distance p25 other_initiations_dichot 0 grgdpch p25  proportion_ciep p75 single_party_majority 1 coalition 0 coalition_ideology_distance 0 purged_pm_rile p75   ///
peaceq 8 peaceqsq 64 peaceqcu 512

simqi, prval(1) listx
simqi, fd(prval(1)) changex(militarism_index .52 4.6)
simqi, fd(prval(1)) changex(cap_proportion .69 0.73)
simqi, fd(prval(1)) changex( polity22 .9231775 -6.831)


*Replicating Table 3

use "Targeted MIDs.dta", replace

*all mids
logit cwinit militarism_index cap_proportion polity21 s_wt_glo ln_distance other_initiations_dichot grgdpch proportion_ciep single_party_majority coalition coalition_ideology_distance purged_pm_rile   peaceq peaceqsq peaceqcu if(pol_rel==1) & (caretaker==0), robust cluster(id)

*with standardized indepenent variable
logit cwinit standard_mil cap_proportion polity21 s_wt_glo ln_distance other_initiations_dichot grgdpch proportion_ciep single_party_majority coalition coalition_ideology_distance purged_pm_rile  peaceq peaceqsq peaceqcu if  (caretaker==0) & pol_rel==1, robust cluster(id)

*hostile mids
relogit hostile_mid militarism_index cap_proportion polity21 s_wt_glo ln_distance other_initiations_dichot grgdpch proportion_ciep single_party_majority coalition coalition_ideology_distance purged_pm_rile  hostilepeaceq hostilepeaceqsq hostilepeaceqcu if(pol_rel==1) & (caretaker==0)

*fatal mids
relogit fatal_mid militarism_index cap_proportion polity21 s_wt_glo ln_distance other_initiations_dichot grgdpch proportion_ciep single_party_majority coalition coalition_ideology_distance purged_pm_rile fatalpeaceq fatalpeaceqsq fatalpeaceqcu if(pol_rel==1) & (caretaker==0)







