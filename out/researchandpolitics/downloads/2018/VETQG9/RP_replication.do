
**UGANDA SAMPLE
use "...uganda_rounds_merged.dta", clear

*Uganda main model; party choice. Tables 1 and 5 (appendix).
eststo clear
eststo: mlogit party_choice education age rural female opposition pre_election suspicious_dummy c.suspicious_dummy#c.pre_election c.opposition#c.pre_election c.opposition#c.suspicious_dummy c.opposition#c.pre_election#c.suspicious_dummy if party_choice!=3, baseoutcome(2) cluster(enum_code)
esttab, se replace unstack drop(2:) b(3)
esttab, se replace unstack drop(2: rural education female age) b(3)

*Uganda main model; Figure 1
eststo clear
mlogit party_choice education age rural female opposition post_election suspicious_dummy c.suspicious_dummy#c.post_election c.opposition#c.post_election c.opposition#c.suspicious_dummy c.opposition#c.post_election#c.suspicious_dummy if party_choice!=3, baseoutcome(2) cluster(enum_code)
margins, dydx(suspicious_dummy) post predict(outcome(2)) over(opposition post_election) 
estimates store sus_effect
coefplot sus_effect, xline(0) ciopts(recast(rcap)) levels(90) graphregion(color(white)) grid(none) 

*shifting correlates of attitudes, pre- and post-election, Uganda sample. Table 3.
eststo clear
eststo: logit suspicious_dummy age female education rural pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election, cluster(enum_code)
eststo: logit nrm_pres age female education rural pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election, cluster(enum_code)
eststo: logit polint age female education rural pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election, cluster(enum_code)
eststo: logit priority_political age female education rural pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election, cluster(enum_code)
esttab, se replace b(3)

*balance across survey rounds; Figure 3
logit pre_election education age rural female opposition
coefplot, xline(0) drop(_cons) graphregion(color(white)) grid(none)

*main model; wariness dummy replaced with perceived government monitoring; Table 9
eststo clear
eststo: mlogit party_choice education age rural female opposition pre_election govspons c.govspons#c.pre_election c.opposition#c.pre_election c.opposition#c.govspons c.opposition#c.pre_election#c.govspons if party_choice!=3, baseoutcome(2) cluster(enum_code)
esttab, se replace unstack drop(2:) b(3)
esttab, se replace unstack drop(2: rural education female age) b(3)

*main model, with control for receipt of vote incentive; Table 11
eststo clear
eststo: mlogit party_choice education age rural female opposition offer pre_election suspicious_dummy c.offer#c.pre_election c.suspicious_dummy#c.pre_election c.opposition#c.pre_election c.opposition#c.suspicious_dummy c.opposition#c.pre_election#c.suspicious_dummy if party_choice!=3, baseoutcome(2) cluster(enum_code)
esttab, se replace unstack drop(2:) b(3)
esttab, se replace unstack drop(2: rural education female age) b(3)



*shifting correlates of attitudes, pre- and post-election, Uganda sample. Table 3.
eststo clear
eststo: logit suspicious_dummy age female education rural pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election, cluster(enum_code)
eststo: logit nrm_pres age female education rural pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election, cluster(enum_code)
eststo: logit polint age female education rural pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election, cluster(enum_code)
eststo: logit priority_political age female education rural pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election, cluster(enum_code)
eststo: logit priority_pov age female education rural pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election, cluster(enum_code)
esttab, se replace b(3)

**FULL AB SAMPLE

use "...merged_R5_2017.dta", clear

*determining effect of election year on wariness
eststo clear
xtset enum_code
eststo: xtlogit suspicious_dummy rural education female age vdem MENA c.pre_election c.pre_election#c.vdem
esttab, se replace b(3)

*main AB model of survey timing on attitudes. Tables 2 and 6 (appendix).
eststo clear
xtset enum_code
eststo: xtlogit approve_dummy suspicious_dummy rural education female age vdem MENA pre_election  c.suspicious_dummy#c.pre_election 
eststo: xtlogit ignore_law suspicious_dummy rural education female age vdem MENA pre_election  c.suspicious_dummy#c.pre_election 
eststo: xtlogit satisfied suspicious_dummy rural education female age vdem MENA pre_election  c.suspicious_dummy#c.pre_election 
eststo: xtlogit unfair_dummy suspicious_dummy rural education female age vdem MENA pre_election  c.suspicious_dummy#c.pre_election 
esttab, se b(3)
esttab, se b(3) drop(rural education female age vdem MENA)

*main AB model; Figure 2

eststo clear
xtreg approve_dummy suspicious_dummy rural education female age vdem MENA pre_election  c.suspicious_dummy#c.pre_election
margins if pre_election==1, dydx(suspicious_dummy) post
estimates store dv1
xtreg approve_dummy suspicious_dummy rural education female age vdem MENA pre_election  c.suspicious_dummy#c.pre_election
margins if pre_election==0, dydx(suspicious_dummy) post
estimates store dv2
xtreg ignore_law suspicious_dummy rural education female age vdem MENA pre_election  c.suspicious_dummy#c.pre_election
margins if pre_election==1, dydx(suspicious_dummy) post
estimates store dv3
xtreg ignore_law suspicious_dummy rural education female age vdem MENA pre_election  c.suspicious_dummy#c.pre_election
margins if pre_election==0, dydx(suspicious_dummy) post
estimates store dv4
xtreg satisfied suspicious_dummy rural education female age vdem MENA pre_election  c.suspicious_dummy#c.pre_election
margins if pre_election==1, dydx(suspicious_dummy) post
estimates store dv5
xtreg satisfied suspicious_dummy rural education female age vdem MENA pre_election  c.suspicious_dummy#c.pre_election
margins if pre_election==0, dydx(suspicious_dummy) post
estimates store dv6
xtreg unfair_dummy suspicious_dummy rural education female age vdem MENA pre_election  c.suspicious_dummy#c.pre_election
margins if pre_election==1, dydx(suspicious_dummy) post
estimates store dv7
xtreg unfair_dummy suspicious_dummy rural education female age vdem MENA pre_election  c.suspicious_dummy#c.pre_election
margins if pre_election==0, dydx(suspicious_dummy) post
estimates store dv8
coefplot dv1 dv2 dv3 dv4 dv5 dv6 dv7 dv8, yline(0) ciopts(recast(rcap)) levels(90) graphregion(color(white)) grid(none) vertical

*shifting correlates of attitudes, full AB sample. Table 4.
eststo clear
xtset enum_code
eststo: xtlogit suspicious_dummy age female education rural vdem MENA pre_election c.vdem#c.pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election c.vdem#c.pre_election c.MENA#c.pre_election
eststo: xtlogit approve_dummy age female education rural vdem MENA pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election  c.vdem#c.pre_election c.MENA#c.pre_election
eststo: xtlogit satisfied age female education rural vdem MENA  pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election  c.vdem#c.pre_election c.MENA#c.pre_election
eststo: xtlogit polint age female education rural vdem MENA pre_election c.age#c.pre_election c.female#c.pre_election c.education#c.pre_election c.rural#c.pre_election  c.vdem#c.pre_election c.MENA#c.pre_election
esttab, se b(3)  

*main AB, using continuous measure of election proximity; Table 7
eststo clear
xtset COUNTRY
eststo: xtreg approve_dummy suspicious_dummy rural education female age date_diff_90  c.suspicious_dummy#c.date_diff_90, fe
eststo: xtreg ignore_law suspicious_dummy rural education female age date_diff_90  c.suspicious_dummy#c.date_diff_90, fe
eststo: xtreg satisfied suspicious_dummy rural education female age date_diff_90  c.suspicious_dummy#c.date_diff_90, fe
eststo: xtreg unfair_dummy suspicious_dummy rural education female age date_diff_90  c.suspicious_dummy#c.date_diff_90, fe
esttab, se b(3)

*main AB table, with different solutions for nested data: table 8
eststo clear
xtset enum_code
eststo: xtlogit approve_dummy pre_election suspicious_dummy rural education female age vdem MENA offer c.pre_election#c.suspicious_dummy 
xtset COUNTRY
eststo: xtlogit approve_dummy pre_election suspicious_dummy rural education female age vdem MENA offer c.pre_election#c.suspicious_dummy
eststo: logit approve_dummy pre_election suspicious_dummy rural education female age vdem MENA offer c.pre_election#c.suspicious_dummy, cluster(enum_code)
eststo: logit approve_dummy pre_election suspicious_dummy rural education female age vdem MENA offer c.pre_election#c.suspicious_dummy, cluster(COUNTRY)
esttab using "C:\Users\Lcarlson\Dropbox\Polling bias\cluster_robust.tex", se replace b(3)


*main AB model; wariness dummy replaced with perceived government monitoring; Table 10
eststo clear
xtset enum_code
eststo: xtlogit approve_dummy govspons rural education female age vdem MENA pre_election c.govspons#c.pre_election
eststo: xtlogit ignore_law govspons rural education female age vdem MENA pre_election c.govspons#c.pre_election 
eststo: xtlogit satisfied govspons rural education female age vdem MENA pre_election c.govspons#c.pre_election 
eststo: xtlogit unfair_dummy govspons rural education female age vdem MENA pre_election c.govspons#c.pre_election
esttab, se replace b(3)
esttab using "C:\Users\Lcarlson\Dropbox\Polling bias\dvs_condensed_gov.tex", se replace b(3) drop(rural education female age polity MENA)


*main AB model; added control for receipt of vote incentive; Table 12
eststo clear
xtset enum_code
eststo: xtlogit approve_dummy suspicious_dummy rural education female age vdem MENA offer pre_election  c.suspicious_dummy#c.pre_election c.offer#c.pre_election
eststo: xtlogit ignore_law suspicious_dummy rural education female age vdem MENA offer pre_election  c.suspicious_dummy#c.pre_election c.offer#c.pre_election
eststo: xtlogit satisfied suspicious_dummy rural education female age vdem MENA offer pre_election  c.suspicious_dummy#c.pre_election c.offer#c.pre_election
eststo: xtlogit unfair_dummy suspicious_dummy rural education female age vdem MENA offer pre_election  c.suspicious_dummy#c.pre_election c.offer#c.pre_election
esttab, se replace b(3)
esttab, se replace b(3) drop(rural education female age vdem MENA)






