* Stata code to replicate the results in "Camp Settlement and Communal Conflict in sub-Saharan Africa." 
* Journal of Peace Research
* By Kerstin Fisk (2019)

** TABLES 1-3, MAIN TEXT **

*TABLE 1
*Model 1 - Refugee Camp Dummy
xtnbreg Communal Refugee_camp Population Income Democracy Capital_distance Previous_communal Conflict_adjacent Battles Onesided, pa robust
xtnbreg, irr

*Model 2 - Camp-host Proportion
xtnbreg Communal Camp_host_proportion Population Income Democracy Capital_distance Previous_communal Conflict_adjacent Battles Onesided, pa robust 
xtnbreg, irr


*TABLE 2
*Model 3 - Refugee Camp*Politically Marginalized
xtnbreg Communal i.Refugee_camp##i.politically_marginalized Population Income Democracy Capital_distance Previous_communal Conflict_adjacent Battles Onesided, pa robust

*Model 4 - Camp-host Proportion*Politically Marginalized
xtnbreg Communal c.Camp_host_proportion##i.politically_marginalized Population Income Democracy Capital_distance Previous_communal Conflict_adjacent Battles Onesided, pa robust

*Model 5 - Refugee Camp*Asset Inequality
xtnbreg Communal i.Refugee_camp##c.Asset_inequality Population Income Democracy Capital_distance Previous_communal Conflict_adjacent Battles Onesided, pa robust

*Model 6 - Camp-host Proportion*Asset Inequality
xtnbreg Communal c.Camp_host_proportion##c.Asset_inequality Population Income Democracy Capital_distance Previous_communal Conflict_adjacent Battles Onesided, pa robust


*TABLE 3
*Model 7 - Refugee Camp*Ethnic Ties
xtnbreg Communal i.Refugee_camp##i.ethnic_ties Population Income Democracy Capital_distance Previous_communal Conflict_adjacent Battles Onesided, pa robust

*Model 8 - Camp-host Proportion*Ethnic Ties
xtnbreg Communal c.Camp_host_proportion##i.ethnic_ties Population Income Democracy Capital_distance Previous_communal Conflict_adjacent Battles Onesided, pa robust



** TABLES A3-A4, ONLINE APPENDIX **

*Table A3
*Model 1
xtnbreg Communal Selfsettled Population Income Democracy Capital_distance Previous_communal Conflict_adjacent Battles Onesided, pa robust
*Model 2
xtnbreg Communal Selfsettled_proportion Population Income Democracy Capital_distance Previous_communal Conflict_adjacent Battles Onesided, pa robust 

*Table A4
*Model 1
xtnbreg Communal Refugee_camp Population Income Unit_size Democracy Capital_distance Previous_communal Conflict_adjacent Battles Onesided, pa robust
*Model 2
xtnbreg Communal Camp_host_proportion Population Income Unit_size Democracy Capital_distance Previous_communal Conflict_adjacent Battles Onesided, pa robust 

