******************************************************
*This file contains the replication code
*for the time series cross section analysis of party positions
*in the article and the additional results in online appendix S3  
******************************************************


*Set appropriate working directory, then run


use data_tscs, clear

*Set panel and time id
xtset ccode2 nelection


*Rescale variables
replace vap_turnout = vap_turnout/100
replace gdppc = gdppc/1000
replace ud = ud/100

**Generate interaction terms and rescale inequality to deviations from its mean for easier interpretation
gen parlorid = parlori - 1.767707 
gen pr_parlorid = pr*parlorid
gen dml_parlorid = dml*parlorid
gen top1d = top1 - 7.914338
gen pr_top1d = pr*top1d
gen gini_marketd = mean_gini_market - 42.27549



*Add variable labels
lab var parlorid "Top Income Inequality (TI)"
lab var top1d "Top Income Share (TIS)"
lab var gini_marketd "Gini Market"
lab var pr "Proportional Representation (PR)"
lab var pr_parlorid "PR * TI"
lab var pr_top1d "PR * TIS"




**The following commands create Figure 2 of the article
quietly xtreg econlr_mean parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl yearel, fe cluster(ccode2)
predict yhat if e(sample)
*Fist, partial out country fixed effects
xi: regress econlr_mean i.ccode2 if yhat !=.
predict lr_resid if e(sample), r
xi: regress parlori i.ccode2 if yhat !=.
predict parlori_resid if e(sample), r
*Second, scatter plot of residuals with fitted lines by electoral system
graph twoway (lfitci lr_resid parlori_resid, clcolor(black) ytitle("Position main left party") xtitle("Top inequality") xlabel(,grid)  range(-.4, 0.8) scheme(s1mono)) (scatter lr_resid parlori_resid, msymbol(oh) color(black)), by(pr, note("") legend(off)) xlabel(-0.4(0.2)0.8 )


**The following commands replicate Table 1 of the article
xi: xtreg econlr_mean parlorid pr pr_parlorid if yhat !=. , fe cluster(ccode2)
xi: xtreg econlr_mean parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl yearel, fe cluster(ccode2)
xi: xtreg econlr_mean parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl yearel i.period , fe cluster(ccode2)
xi: xtreg econlr_mean parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl i.ccode2*yearel, fe cluster(ccode2)

*Remark: To obtain the adjusted R-squared displayed in Table 1 and the following tables, request "display e(r2_a)" after each model.

**The following commands create Figure 1 in online Appendix S3
*First, define new country indicator that orders countries approximatley by district magnitude and name 
recode ccode2 (900=1) (20=2) (200=3) (220=4) (920=5) (740=6) (205=7) (230=8) (385=9) (225=10) (390=11) (380=12) (235=13) (325=14)  (260=15) (210=16), gen(ccodebydm)
label define ccodebydmlbl  1 "AUS" 2 "CAN" 3 "GBR" 4 "FRA" 5 "NZL" 6 "JPN" 7 "IRL" 8 "ESP" 9 "NOR" 10 "CHE" 11 "DNK" 12 "SWE" 13 "PRT" 14 "ITA"  15 "DEU" 16 "NLD"
label values ccodebydm ccodebydmlbl
*Second, scatter plot by country
graph twoway (lfit econlr_mean parlori, ytitle("Position main left party") xtitle("Top inequality") xlabel(,grid)) (scatter econlr_mean parlori,  msymbol(oh) color(black) scheme(s1mono)), by(ccodebydm, note("") legend(off))


**The following command produces the descritive statistics of Table 1  in online Appendix S3 
summarize econlr_mean logrile parlori top1 pr dml gdppc vap_turnout trade pop65o popl ud euinteg inccab leftcomp party_cent mean_gini_market if yhat != .

**The following commands produce Table 2  in online Appendix S3 
xi: xtreg econlr_mean top1d pr pr_top1d gdppc vap_turnout trade pop65o popl yearel if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean top1d pr pr_top1d gdppc vap_turnout trade pop65o popl yearel i.period if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean top1d pr pr_top1d gdppc vap_turnout trade pop65o popl i.ccode2*yearel if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean parlorid dml dml_parlorid gdppc vap_turnout trade pop65o popl yearel if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean parlorid dml dml_parlorid gdppc vap_turnout trade pop65o popl yearel i.period if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean parlorid dml dml_parlorid gdppc vap_turnout trade pop65o popl i.ccode2*yearel if yhat !=., fe cluster(ccode2)

**The following commands produce Table 3 in online Appendix S3 
xi: xtreg logrile parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl yearel if yhat !=., fe cluster(ccode2)
xi: xtreg logrile parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl yearel i.period if yhat !=., fe cluster(ccode2)
xi: xtreg logrile parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl i.ccode2*yearel if yhat !=., fe cluster(ccode2)

**The following commands produce Table 4 in online Appendix S3 
xi: xtreg econlr_mean parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl ud  yearel if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl euinteg  yearel if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl inccab  yearel if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl leftcompet  yearel if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl ud euinteg inccab leftcompet  yearel if yhat !=., fe cluster(ccode2)

**The following commands create Table 5 in online Appendix S3 
gen pr_pcent = pr*party_cent
*Run models
xi: xtreg econlr_mean parlorid pr_parlorid  party_cent pr pr_pcent gdppc vap_turnout trade pop65o popl yearel if yhat ! =., fe cluster(ccode2)
xi: xtreg econlr_mean parlorid pr_parlorid  party_cent pr pr_pcent gdppc vap_turnout trade pop65o popl yearel i.period if yhat ! =., fe cluster(ccode2)
xi: xtreg econlr_mean parlorid pr_parlorid  party_cent pr pr_pcent gdppc vap_turnout trade pop65o popl i.ccode2*yearel if yhat ! =., fe cluster(ccode2)

**The following commands create Table 6 in online Appendix S3 
*To begin, define Interaction with gini
gen pr_mginid = pr*gini_marketd
*Run un auxil regression with Gini data to define comparison sample for basic model with top incomes data 
xi: quietly xtreg econlr_mean mean_gini_market pr pr_mgini if yhat !=.
predict yhat2 if e(sample)
*Model 1-3
xi: xtreg econlr_mean parlorid pr_parlorid pr gdppc vap_turnout trade pop65o popl yearel if yhat2 !=., fe cluster(ccode2)
xi: xtreg econlr_mean parlorid pr_parlorid pr gdppc vap_turnout trade pop65o popl yearel i.period if yhat2 !=., fe cluster(ccode2)
xi: xtreg econlr_mean parlorid pr_parlorid pr gdppc vap_turnout trade pop65o popl i.ccode2*yearel if yhat2 !=., fe cluster(ccode2)
*Model 4-6
xi: xtreg econlr_mean gini_marketd pr_mginid pr gdppc vap_turnout trade pop65o popl yearel if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean gini_marketd pr_mginid pr gdppc vap_turnout trade pop65o popl yearel i.period if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean gini_marketd pr_mginid pr gdppc vap_turnout trade pop65o popl i.ccode2*yearel if yhat !=., fe cluster(ccode2)
*Model 7-9
xi: xtreg econlr_mean  parlorid pr_parlorid  gini_marketd pr_mginid pr gdppc vap_turnout trade pop65o popl yearel if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean  parlorid pr_parlorid  gini_marketd pr_mginid pr gdppc vap_turnout trade pop65o popl yearel i.period if yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean  parlorid pr_parlorid  gini_marketd pr_mginid pr gdppc vap_turnout trade pop65o popl  i.ccode2*yearel if yhat !=., fe cluster(ccode2)

**The following commands produce Table 7 in online Appendix S3 
xi: xtreg econlr_mean L1.econlr_mean parlorid pr pr_parlorid if  yhat !=. , fe cluster(ccode2)
xi: xtreg econlr_mean L1.econlr_mean parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl yearel if  yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean L1.econlr_mean parlorid pr pr_parlorid gdppc vap_turnout trade pop65o popl yearel i.period if  yhat !=., fe cluster(ccode2)
xi: xtreg econlr_mean parlorid L1.econlr_mean pr pr_parlorid gdppc vap_turnout trade pop65o popl i.ccode2*yearel if  yhat !=., fe cluster(ccode2)

**The following commands produce Table 8 in online Appendix S3 
xi: xtreg parlori parlorius gdppc vap_turnout trade pop65o popl yearel i.ccode2 if  pr==0 & yhat != ., fe cluster(ccode2)
display e(r2_a)
xi: xtreg parlori parlorius gdppc vap_turnout trade pop65o popl yearel i.period if  pr==0 & yhat != ., fe cluster(ccode2)
display e(r2_a)
xi: xtreg parlori parlorius gdppc vap_turnout trade pop65o popl i.ccode2*yearel if pr==0 & yhat != .,  fe cluster(ccode2)
display e(r2_a) 
xi: ivregress 2sls econlr_mean gdppc vap_turnout trade pop65o popl yearel i.ccode2 (parlori = parlorius) if  pr==0, cluster(ccode2)
xi: ivregress 2sls econlr_mean gdppc vap_turnout trade pop65o popl yearel i.period i.ccode2 (parlori = parlorius) if  pr==0, cluster(ccode2)
xi: ivregress 2sls econlr_mean gdppc vap_turnout trade pop65o popl i.ccode2*yearel (parlori = parlorius) if pr==0, cluster(ccode2)
