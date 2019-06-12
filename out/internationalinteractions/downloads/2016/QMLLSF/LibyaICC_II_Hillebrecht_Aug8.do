*The Deterrent Effects of the International Criminal Court: Evidence from Libya
*Courtney Hillebrecht
*Data do-file
*Models for Table 2, "The Effect of the ICC on Violence against Civilians--All Fatalities" (Negative Binomial Regression)
nbreg fatalities n_articles gov2reb reb2gov NATO2Gov ICCStatement UNSCRefers ICCOpensInvest ICCAssigns ICCRequestsAW ICCWarrants ICCInterpol daymarker, robustnbreg fatalities n_articles gov2reb reb2gov NATO2Gov gov2reblag reb2govlag NATO2Govlag fatalitiesgovlag ICCStatement UNSCRefers ICCOpensInvest ICCAssigns ICCRequestsAW ICCWarrants ICCInterpol n_articleslag daymarker, robust
nbreg fatalities n_articles gov2reb reb2gov NATO2Gov gov2reblag reb2govlag NATO2Govlag fatalitieslag gov2reb7 reb2gov7 NATO2Gov7 fatalitieslag7 n_articleslag n_articleslag7 ICCStatement UNSCRefers ICCOpensInvest ICCAssigns ICCRequestsAW ICCWarrants ICCInterpol daymarker, robust

nbreg fatalities n_articles gov2reb reb2gov NATO2Gov ICCcumu daymarker, robust
nbreg fatalities n_articles gov2reb reb2gov NATO2Gov gov2reblag reb2govlag NATO2Govlag fatalitiesgovlag n_articleslag ICCcumu daymarker, robust
nbreg fatalities ICCcumu n_articles gov2reb reb2gov NATO2Gov gov2reblag reb2govlag NATO2Govlag fatalitiesgovlag gov2reb7 reb2gov7 NATO2Gov7 fatalitiesgovlag7 n_articleslag n_articleslag7 daymarker, robust

*Models for Table 3, "The Effect of the ICC on Violence against Civilians--Government-Sponsored Fatalities Only" (Negative Binomial Regression)
nbreg fatalitiesgov n_articles gov2reb reb2gov NATO2Gov ICCStatement UNSCRefers ICCOpensInvest ICCAssigns ICCRequestsAW ICCWarrants ICCInterpol daymarker, robustnbreg fatalitiesgov n_articles gov2reb reb2gov NATO2Gov gov2reblag reb2govlag NATO2Govlag fatalitiesgovlag ICCStatement UNSCRefers ICCOpensInvest ICCAssigns ICCRequestsAW ICCWarrants ICCInterpol n_articleslag daymarker, robust
nbreg fatalitiesgov n_articles gov2reb reb2gov NATO2Gov gov2reblag reb2govlag NATO2Govlag fatalitieslag gov2reb7 reb2gov7 NATO2Gov7 fatalitieslag7 n_articleslag n_articleslag7 ICCStatement UNSCRefers ICCOpensInvest ICCAssigns ICCRequestsAW ICCWarrants ICCInterpol daymarker, robust

nbreg fatalitiesgov n_articles gov2reb reb2gov NATO2Gov ICCcumu daymarker, robust
nbreg fatalitiesgov n_articles gov2reb reb2gov NATO2Gov gov2reblag reb2govlag NATO2Govlag fatalitiesgovlag n_articleslag ICCcumu daymarker, robust
nbreg fatalitiesgov ICCcumu n_articles gov2reb reb2gov NATO2Gov gov2reblag reb2govlag NATO2Govlag fatalitiesgovlag gov2reb7 reb2gov7 NATO2Gov7 fatalitiesgovlag7 n_articleslag n_articleslag7 daymarker, robust*For marginal effects (APPENDIX D), use the mfx compute command (STATA) after you estimate the model.*Code for Figure 1
generate lnfatalities = ln(fatalities)
recode lnfatalities (.=0)
twoway (line lnfatalities date3), ytitle(ln(Fatalities)) ymtick(, angle(default)) xtitle(Date) xlabel(, angle(forty_five) format(%tdMonth_DD,_CCYY))
*For Figure 2, add vertical reference lines at the dates of interest to Figure one.  For ease, you might consider using the daymarker variable instead of date3.  For example:
twoway (line lnfatalities daymarker), ytitle(ln(Fatalities)) ymtick(, angle(default)) xtitle(Date) xline(7 10 15 19 89 131 204, extend) xlabel(none, nolabels)
*To create Figure 2, I added in the labels for each of the markers using the Graph Edit feature in Stata 12.  The lables are, respectively: ICC Issues Statement, UNSC Refers Case, ICC Opens Investigation, ICC Assigns Case, ICC Requests Arrest Warrant, ICC Issues Arrest Warrant, ICC Requests Interpol Support 
 *Models for Appendix E: Zero-Inflated Negative Binomial Model Estimations
zinb fatalities n_articles gov2reb reb2gov NATO2Gov ICCStatement UNSCRefers ICCOpensInvest ICCAssigns ICCRequestsAW ICCWarrants ICCInterpol, inflate(gov2reb reb2gov NATO2Gov) vuongzinb fatalitiesgov n_articles gov2reb reb2gov NATO2Gov gov2reblag reb2govlag NATO2Govlag fatalitiesgovlag ICCStatement UNSCRefers ICCOpensInvest ICCAssigns ICCRequestsAW ICCWarrants ICCInterpol n_articleslag, inflate(gov2reb reb2gov NATO2Gov) robust*Models for Appendix F: Prais-Winsten Model Estimations Using the Level of Conflict between Government and Rebel Forces as the Dependent Variableprais gov2reb n_articles reb2gov NATO2Gov ICCStatement UNSCRefers ICCOpensInvest ICCAssigns ICCRequestsAW ICCWarrants ICCInterpol daymarker, robust
prais gov2reb n_articles n_articleslag gov2reblag reb2gov reb2govlag NATO2Gov NATO2Govlag ICCStatement UNSCRefers ICCOpensInvest ICCAssigns ICCRequestsAW ICCWarrants ICCInterpol daymarker, robust
prais gov2reb n_articles reb2gov NATO2Gov gov2reblag reb2govlag NATO2Govlag fatalitiesgovlag gov2reb7 reb2gov7 NATO2Gov7 fatalitiesgovlag7 n_articleslag n_articleslag7 ICCStatement UNSCRefers ICCOpensInvest ICCAssigns ICCRequestsAW ICCWarrants ICCInterpol daymarker, robust

prais gov2reb n_articles reb2gov NATO2Gov ICCcumu daymarker, robust
prais gov2reb n_articles reb2gov NATO2Gov gov2reblag reb2govlag NATO2Govlag fatalitiesgovlag n_articleslag ICCcumu daymarker, robust
prais gov2reb n_articles reb2gov NATO2Gov gov2reblag reb2govlag NATO2Govlag fatalitiesgovlag gov2reb7 reb2gov7 NATO2Gov7 fatalitiesgovlag7 n_articleslag n_articleslag7 ICCcumu daymarker, robust





















