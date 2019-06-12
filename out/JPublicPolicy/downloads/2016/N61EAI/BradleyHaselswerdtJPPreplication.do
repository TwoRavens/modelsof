capture log close
log using BradleyHaselswerdtJPPreplication, replace text
//program:  BradleyHaselswerdtJPPreplication.do
//task:    Replication files for Katharine W.V. Bradley and Jake Haselswerdt, "Who Lobbies the Lobbyists? State Medicaid bureaucrats’ engagement in the legislative process," Journal of Public Policy
//author: Jake Haselswerdt \ Sept 7, 2016

//program setup
version 13
clear all
set linesize 80
macro drop _all
set scheme s1mono
set more off

*graph set window fontface sabon

use KBJHreplication.dta, clear

//Main models for Table 4: Logit models of Requests for lobbying on recent Medicaid bills
logit agcy_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree, vce(cluster stateid) or
logit agcy_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree unifiedcontrol logpopulation density99rankrev, vce(cluster stateid) or

//Main figures

*Figure 1: Change in probability of Requests for unit increases in agency capacity at different levels of agreement (values centered at means)
qui logit agcy_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree unifiedcontrol logpopulation density99rankrev, vce(cluster stateid) or
qui margins, dydx(ctr_gppgrade) at(ctr_avgagreement=(-2(1)2)) post
marginsplot, yline(0, lpattern(dash)) xtitle("Average bureaucrat-lobbyist agreement") xlabel(-2(1)2) ytitle("Effect of agency capacity") title("")
graph export Figure1.tif, width(2550) as(tif) replace

*Figure 2: Change in probability of Requests for unit increases in legislative capacity at different levels of agreement (values centered at means)]
qui logit agcy_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree unifiedcontrol logpopulation density99rankrev, vce(cluster stateid) or
qui margins, dydx(ctr_legindex) at(ctr_avgagreement=(-2(1)2)) post
marginsplot, yline(0, lpattern(dash)) xtitle("Average bureaucrat-lobbyist agreement") xlabel(-2(1)2) ytitle("Effect of legislative capacity") title("")
graph export Figure2.tif, width(2550) as(tif) replace

*Figure 3: Change in probability of Requests for unit increases in gubernatorial power at different levels of governor-bureaucrat agreement (values centered at means)
qui logit agcy_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree unifiedcontrol logpopulation density99rankrev, vce(cluster stateid) or
qui margins, dydx(ctr_nasboscore) at(ctr_avggovburagree=(-.8(.4).4)) post
marginsplot, yline(0, lpattern(dash)) xtitle("Average governor-bureaucrat agreement") xlabel(-.8(.4).4) ytitle("Effect of gubernatorial power") title("")
graph export Figure3.tif, width(2550) as(tif) replace

//Predicted probabilities discussed in text

*agency capacity x bur-lob agreement - #33, 37 & 40 referenced in text
qui logit agcy_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree unifiedcontrol logpopulation density99rankrev, vce(cluster stateid) or
margins, at(ctr_avgagreement=(-2(1)2) ctr_gppgrade=(-4(1)3)) atmeans post 

*gov power x gov-bur agreement - #5, 8, 17 & 20 referenced in text (ctr_nasboscore 10th percentile is -1.5, 90th percentile is 1.5, same as maximum)
qui logit agcy_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree unifiedcontrol logpopulation density99rankrev, vce(cluster stateid) or
margins, at(ctr_avggovburagree=(-.8(.4).4) ctr_nasboscore=(-2.5(1)1.5)) post

//Figure A2.1 Dotplot of request rate by state

stripplot statereqpct if lobbyist_st_id==1, stack xtitle(Proportion of lobbyists in state reporting a request)
graph export FigureA21.tif, width(2550) as(tif) replace

//Implicit request robustness checks - Appendix 3

*Models for Table A3.1
logit exp_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree, vce(cluster stateid) or
logit exp_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree unifiedcontrol logpopulation density99rankrev, vce(cluster stateid) or

*Figure A3.1: Change in probability of explicit Requests only for unit increases in agency capacity at different levels of agreement (values centered at means)
qui logit exp_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree unifiedcontrol logpopulation density99rankrev, vce(cluster stateid) or
qui margins, dydx(ctr_gppgrade) at(ctr_avgagreement=(-2(1)2)) atmeans post
marginsplot, yline(0, lpattern(dash)) xtitle("Average bureaucrat-lobbyist agreement") xlabel(-2(1)2) ytitle("Effect of agency capacity") title("")
graph export FigureA31.tif, width(2550) as(tif) replace

*Figure A3.2: Change in probability of explicit Requests only for unit increases in legislative capacity at different levels of agreement (values centered at means)
qui logit exp_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree unifiedcontrol logpopulation density99rankrev, vce(cluster stateid) or
qui margins, dydx(ctr_legindex) at(ctr_avgagreement=(-2(1)2)) atmeans post
marginsplot, yline(0, lpattern(dash)) xtitle("Average bureaucrat-lobbyist agreement") xlabel(-2(1)2) ytitle("Effect of legislative capacity") title("")
graph export FigureA32.tif, width(2550) as(tif) replace

*Figure A3.3: Change in probability of Requests for unit increases in gubernatorial power at different levels of governor-bureaucrat agreement (values centered at means)
qui logit exp_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree unifiedcontrol logpopulation density99rankrev, vce(cluster stateid) or
qui margins, dydx(ctr_nasboscore) at(ctr_avggovburagree=(-.8(.4).4)) atmeans post
marginsplot, yline(0, lpattern(dash)) xtitle("Average governor-bureaucrat agreement") xlabel(-.8(.4).4) ytitle("Effect of gubernatorial power") title("")
graph export FigureA33.tif, width(2550) as(tif) replace

//Models using lobbying requests on the survey bill only - Appendix 4, Table A4.1
logit thisbill_agcy_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree, vce(cluster stateid) or
logit thisbill_agcy_rqst c.ctr_legindex##c.ctr_avgagreement c.ctr_gppgrade##c.ctr_avgagreement c.ctr_nasboscore##c.ctr_avggovburagree unifiedcontrol logpopulation density99rankrev, vce(cluster stateid) or

//Validating GPP grade & evaluating alternative measures of agency performance - referenced in text

*GPP grade and CHIPRA bonus significantly correlated
ttest ctr_gppgrade if lobbyist_st_id==1, by(anychipra) unequal welch

*APES public welfare FTE & pay measures used by Miller 2006 - negatively correlated with GPP grade and CHIPRA bonus
reg pwfteadj ctr_gppgrade if lobbyist_st_id==1
reg pwftepayadj ctr_gppgrade if lobbyist_st_id==1
ttest pwfteadj if lobbyist_st_id==1, by(anychipra)
ttest pwftepayadj if lobbyist_st_id==1, by(anychipra)

*Medicaid agency employees adjusted for Medicaid population, 2007, from Randall 2012 - also negatively correlated with GPP grade and CHIPRA bonus
reg randall ctr_gppgrade if lobbyist_st_id==1 
ttest randall if lobbyist_st_id==1, by(anychipra)

log close
exit
