* Josh Fjelstul
* Cliff Carrubba
* Emory University 

*************************************************
*************************************************
* models for paper
*************************************************
*************************************************

* model 1
* using effectiveness, support, and influence
logit opinion c.effectiveness##c.support c.support##c.influence pilot length commission addressee scope, robust

margins, dydx(*) atmeans

margins, dydx(support) at(influence = (-1.25(0.25)2.5)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

margins, dydx(effectiveness) at(support = (-3(0.25)2.25)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

margins, dydx(support) at(influence = 2) atmeans
margins, dydx(effectiveness) at(support = 2) atmeans

* model 2
* using effectiveness, distance, and influence
logit opinion c.effectiveness##c.distance c.distance##c.influence pilot length commission addressee scope, robust

margins, dydx(*) atmeans

margins, dydx(distance) at(influence = (-1.25(0.25)2.5)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

margins, dydx(effectiveness) at(distance = (-2(0.25)2.25)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

margins, dydx(distance) at(influence = 2) atmeans
margins, dydx(effectiveness) at(distance = -2) atmeans

* model 3
* using expenditures, support, and influence (appendix)
logit opinion c.expenditures##c.support c.support##c.influence pilot length commission addressee scope, robust

margins, dydx(*) atmeans

margins, dydx(support) at(influence = (-1.25(0.25)2.5)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

margins, dydx(expenditures) at(support = (-3(0.25)2.25)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

margins, dydx(support) at(influence = 2) atmeans
margins, dydx(expenditures) at(support = 2) atmeans

* model 4
* using expenditures, distance, and influence (appendix)
logit opinion c.expenditures##c.distance c.distance##c.influence pilot length commission addressee scope, robust

margins, dydx(*) atmeans

margins, dydx(distance) at(influence = (-1.25(0.25)2.5)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

margins, dydx(expenditures) at(distance = (-2(0.25)2.25)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

margins, dydx(distance) at(influence = 2) atmeans
margins, dydx(expenditures) at(distance = 2) atmeans

*************************************************
*************************************************
* robustness checks
*************************************************
*************************************************

*************************************************
* 1. multicolinearitiy
*************************************************

correl effectiveness support influence pilot length commission addressee scope
correl expenditures support influence pilot length commission addressee scope
correl effectiveness distance influence pilot length commission addressee scope
correl expenditures distance influence pilot length commission addressee scope

*************************************************
* 2. change link function
*************************************************

* probit 
probit opinion c.effectiveness##c.support c.support##c.influence pilot length commission addressee scope, robust
probit opinion c.effectiveness##c.distance c.distance##c.influence pilot length commission addressee scope, robust
probit opinion c.expenditures##c.support c.support##c.influence pilot length commission addressee scope, robust
probit opinion c.expenditures##c.distance c.distance##c.influence pilot length commission addressee scope, robust

*************************************************
* 3. influential observations
*************************************************

* model 1
* using effectiveness, support, and influence
logit opinion c.effectiveness##c.support c.support##c.influence pilot length commission addressee scope, robust

* Pregibon's beta
predict dbeta, dbeta
gen obs = _n

* scatter plot
scatter dbeta obs

* remove most influential observations
logit opinion c.effectiveness##c.support c.support##c.influence pilot length commission addressee scope if dbeta < 0.05, robust
logit opinion c.effectiveness##c.support c.support##c.influence pilot length commission addressee scope if dbeta < 0.03, robust

* model 2
* using effectiveness, distance, and influence
logit opinion c.effectiveness##c.distance c.distance##c.influence pilot length commission addressee scope, robust

* Pregibon's beta
drop dbeta
predict dbeta, dbeta

* scatter plot
scatter dbeta obs

* remove most influential observations
logit opinion c.effectiveness##c.distance c.distance##c.influence pilot length commission addressee scope if dbeta < 0.05, robust
logit opinion c.effectiveness##c.distance c.distance##c.influence pilot length commission addressee scope if dbeta < 0.03, robust

*************************************************
* 4. polynomials of time
*************************************************

logit opinion c.effectiveness##c.support c.support##c.influence pilot length commission addressee scope time time2 time3, robust
logit opinion c.effectiveness##c.distance c.distance##c.influence pilot length commission addressee scope time time2 time3, robust
logit opinion c.expenditures##c.support c.support##c.influence pilot length commission addressee scope time time2 time3, robust
logit opinion c.expenditures##c.distance c.distance##c.influence pilot length commission addressee scope time time2 time3, robust

*************************************************
* 5. OLS with year fixed effects
*************************************************

reg opinion c.effectiveness##c.support c.support##c.influence pilot length commission addressee scope i.time, robust
reg opinion c.effectiveness##c.distance c.distance##c.influence pilot length commission addressee scope i.time, robust
reg opinion c.expenditures##c.support c.support##c.influence pilot length commission addressee scope i.time, robust
reg opinion c.expenditures##c.distance c.distance##c.influence pilot length commission addressee scope i.time, robust

*************************************************
* 6. OLS with year and DG fixed effects
*************************************************

reg opinion c.effectiveness##c.support c.support##c.influence pilot length commission addressee scope i.time i.directorate_id, robust
reg opinion c.effectiveness##c.distance c.distance##c.influence pilot length commission addressee scope i.time i.directorate_id, robust
reg opinion c.expenditures##c.support c.support##c.influence pilot length commission addressee scope i.time i.directorate_id, robust
reg opinion c.expenditures##c.distance c.distance##c.influence pilot length commission addressee scope i.time i.directorate_id, robust

*************************************************
* 7. without directive controls
*************************************************

logit opinion c.effectiveness##c.support c.support##c.influence pilot, robust
logit opinion c.effectiveness##c.distance c.distance##c.influence pilot, robust
logit opinion c.expenditures##c.support c.support##c.influence pilot, robust
logit opinion c.expenditures##c.distance c.distance##c.influence pilot, robust

*************************************************
* 8. clustered standard errors
*************************************************

* errors clustered by year, member state, and DG
cgmlogit opinion effectiveness support influence support_effectiveness support_influence pilot length commission addressee scope, robust cluster(time member_state_id directorate_id)
cgmlogit opinion effectiveness distance influence distance_effectiveness distance_influence pilot length commission addressee scope, robust cluster(time member_state_id directorate_id)
cgmlogit opinion expenditures support influence support_expenditures support_influence pilot length commission addressee scope, robust cluster(time member_state_id directorate_id)
cgmlogit opinion expenditures distance influence distance_expenditures distance_influence pilot length commission addressee scope, robust cluster(time member_state_id directorate_id)

* errors clustered by year, member state, DG, and directive
cgmlogit opinion effectiveness support influence support_effectiveness support_influence pilot length commission addressee scope, robust cluster(time member_state_id directorate_id directive_id)
cgmlogit opinion effectiveness distance influence distance_effectiveness distance_influence pilot length commission addressee scope, robust cluster(time member_state_id directorate_id directive_id)
cgmlogit opinion expenditures support influence support_expenditures support_influence pilot length commission addressee scope, robust cluster(time member_state_id directorate_id directive_id)
cgmlogit opinion expenditures distance influence distance_expenditures distance_influence pilot length commission addressee scope, robust cluster(time member_state_id directorate_id directive_id)

* OLS, year fixed effects, errors clustered by member state, DG, and directive
cgmreg opinion effectiveness support influence support_effectiveness support_influence pilot length commission addressee scope i.time, robust cluster(member_state_id directorate_id directive_id)
cgmreg opinion effectiveness distance influence distance_effectiveness distance_influence pilot length commission addressee scope i.time, robust cluster(member_state_id directorate_id directive_id)
cgmreg opinion expenditures support influence support_expenditures support_influence pilot length commission addressee scope i.time, robust cluster(member_state_id directorate_id directive_id)
cgmreg opinion expenditures distance influence distance_expenditures distance_influence pilot length commission addressee scope i.time, robust cluster(member_state_id directorate_id directive_id)

*************************************************
* 9. weight up 0's
*************************************************

logit opinion c.effectiveness##c.support c.support##c.influence pilot length commission addressee scope [fweight = weight2], robust
logit opinion c.effectiveness##c.support c.support##c.influence pilot length commission addressee scope [fweight = weight3], robust
logit opinion c.effectiveness##c.support c.support##c.influence pilot length commission addressee scope [fweight = weight4], robust
logit opinion c.effectiveness##c.support c.support##c.influence pilot length commission addressee scope [fweight = weight5], robust

logit opinion c.effectiveness##c.distance c.distance##c.influence pilot length commission addressee scope [fweight = weight2], robust
logit opinion c.effectiveness##c.distance c.distance##c.influence pilot length commission addressee scope [fweight = weight3], robust
logit opinion c.effectiveness##c.distance c.distance##c.influence pilot length commission addressee scope [fweight = weight4], robust
logit opinion c.effectiveness##c.distance c.distance##c.influence pilot length commission addressee scope [fweight = weight5], robust

logit opinion c.expenditures##c.support c.support##c.influence pilot length commission addressee scope [fweight = weight2], robust
logit opinion c.expenditures##c.support c.support##c.influence pilot length commission addressee scope [fweight = weight3], robust
logit opinion c.expenditures##c.support c.support##c.influence pilot length commission addressee scope [fweight = weight4], robust
logit opinion c.expenditures##c.support c.support##c.influence pilot length commission addressee scope [fweight = weight5], robust

logit opinion c.expenditures##c.distance c.distance##c.influence pilot length commission addressee scope [fweight = weight2], robust
logit opinion c.expenditures##c.distance c.distance##c.influence pilot length commission addressee scope [fweight = weight3], robust
logit opinion c.expenditures##c.distance c.distance##c.influence pilot length commission addressee scope [fweight = weight4], robust
logit opinion c.expenditures##c.distance c.distance##c.influence pilot length commission addressee scope [fweight = weight5], robust

*************************************************
* 10. 3-way interaction
*************************************************

* model 1
* using effectiveness, support, and influence
logit opinion c.effectiveness##c.support##c.influence pilot length commission addressee scope, robust

margins, dydx(*) atmeans

margins, dydx(support) at(influence = (-1.25(0.25)2.5)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

margins, dydx(effectiveness) at(support = (-3(0.25)2.25)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

* model 2
* using effectiveness, distance, and influence
logit opinion c.effectiveness##c.distance##c.influence pilot length commission addressee scope, robust

margins, dydx(*) atmeans

margins, dydx(distance) at(influence = (-1.25(0.25)2.5)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

margins, dydx(effectiveness) at(distance = (-2(0.25)2.25)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

* model 3
* using expenditures, support, and influence
logit opinion c.expenditures##c.support##c.influence pilot length commission addressee scope, robust

margins, dydx(*) atmeans

margins, dydx(support) at(influence = (-1.25(0.25)2.5)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

margins, dydx(expenditures) at(support = (-3(0.25)2.25)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

* model 4
* using expenditures, distance, and influence
logit opinion c.expenditures##c.distance##c.influence pilot length commission addressee scope, robust

margins, dydx(*) atmeans

margins, dydx(distance) at(influence = (-1.25(0.25)2.5)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

margins, dydx(expenditures) at(distance = (-2(0.25)2.25)) atmeans
marginsplot, ciopts(lp(dash)) recastci(rline) yline(0)

*************************************************
* 11. alternative Eurobarometer measure
*************************************************

* with effectiveness
logit opinion c.effectiveness##c.benefits c.benefits##c.influence pilot length commission addressee scope, robust
margins, dydx(*) atmeans

* with expenditures
logit opinion c.expenditures##c.benefits c.benefits##c.influence pilot length commission addressee scope, robust
margins, dydx(*) atmeans

*************************************************
* end .do file
*************************************************
