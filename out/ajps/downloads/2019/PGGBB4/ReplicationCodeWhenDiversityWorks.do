
*set Working directory where file is located

set more off
use "ReplicationdataWhenDiversityWorksAJPS"


******************************************
*If necessary, please install packages 
******************************************
*ssc install estout, replace
*ssc install interflex
*ssc install blindschemes 

*******


*******************************
*Main Article 
*******************************
*
*******
* Table 2 - Main Models M1-M4
***********

*Model 1
eststo: melogit success c.invhhi_signal c.logactyear  Businessshare logEUresourcescoal prochange_survey posamepos_actor_survey logsignalsize shareactorscamp_all  i.country  if uniquecoalition==1 || policyid_all:
*Model 2
eststo: melogit success c.invhhi_signal##c.logactyear  Businessshare logEUresourcescoal logsignalsize  prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:
*Model 3
eststo: melogit success  i.Strangebedfellows logactyear  logEUresourcescoal  logsignalsize  prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:
*Model 4
eststo: melogit success  i.Strangebedfellows##c.logactyear logEUresourcescoal  shareactorscamp_all logsignalsize prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:

esttab using Table_1.rtf, replace wide nogap onecell cells(b(star fmt(%9.2f)) se(par))                ///
        stats(N aic bic chi2, fmt(%9.0g %9.0f %9.0f) labels("Number of Cases" "AIC" "BIC"))      ///
		starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)	///
        legend label collabels(none) 						///
		varlabels(_cons Constant logsignalsize "Size (log)" logEUresourcescoal "Financial Resource Proxy(log)"  ///
		invhhi_signal "Diversity (inv. HHI)"  Businessshare "Share of Business" ////
		posamepos_actor_survey "Support of public opinion" prochange_survey "Coalition pro change" logactyear "Advocacy salience" shareactorscamp_all "Camp Share")

eststo clear 



*************************
*Figure 1 based on Model 2
****************************
melogit success c.invhhi_signal##c.logactyear  Businessshare logEUresourcescoal logsignalsize  prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:
margins, dydx(invhhi_signal) at(logactyear=(0(1.0)6)) vsquish 
marginsplot, addplot(histogram logactyear if Missing0==1, ///adding histogram
yaxis(2) yscale(alt axis(2)) below discrete percent ylabel(0 20, axis(2)) lcolor(black*0.5) fcolor(white)) /// putting percent-type histogram behind margins
ylabel(-2.5 -1.5 -1 -0.5 0  0.5 1, axis(1) labsize(small)) scheme(plotplain) recastci(rline) recast(line)  /// setting ylabel and xlabel for marginsplot, setting scheme and margins type
ytitle( "Average Marginal Effect of Diversity (inv. HHI)",   /// titles
size(medlarge)) xtitle(" " " Advocacy Salience (log)", size(large)) legend(off) /// titles
plotopts(lwidth(thick)) title("Average Marginal Effect of Diversity with 95 CIs", size(large)) yline(0) 
graph export Figure1diversity.png, replace
*the logged values of salience were manually transformed into actual values in the final figure, e^logactyear
*layout labels also adjusted manually

**************************
* Table 3 Calculations of predicted probabilties - based on Model 2
**************************
*Summarize Mean, Minimum and Maximum diversity
summarize invhhi_signal if Missing0==1

*Predictions made on Model 2  for Table 3
* log salience levels of 2.8 (i.e. 16 advocates per year) and 4.6 (i.e. 99 advoaces per year) are derived based on margins command/plot where the effects turn significantly negative/positive)
*left-hand side table 3
margins, at(invhhi_signal=0 logactyear=2.8)
margins, at(invhhi_signal=.2936844 logactyear=2.8)
margins, at(invhhi_signal=0.75 logactyear=2.8)

*right-hand side table 3
margins, at(invhhi_signal=0 logactyear=4.6)
margins, at(invhhi_signal=.2936844 logactyear=4.6)
margins, at(invhhi_signal=0.75 logactyear=4.6)

************************************
*Figure 2 based on Model 4
***************************************
melogit success  i.Strangebedfellows##c.logactyear logEUresourcescoal  shareactorscamp_all logsignalsize prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:
margins, dydx(i(0/1)Strangebedfellows) at(logactyear=(0(1.0)6)) vsquish 
marginsplot, recast(line) yline(0) 
marginsplot, addplot(histogram logactyear if Missing0==1, ///adding histogram
yaxis(2) yscale(alt axis(2)) below discrete percent ylabel(0 20, axis(2)) lcolor(black*0.5) fcolor(white)) /// putting percent-type histogram behind margins
ylabel(-2 -1.5 -1 -0.5 0  0.5 1, axis(1) labsize(small)) scheme(plotplain) recastci(rline) recast(line)  /// setting ylabel and xlabel for marginsplot, setting scheme and margins type
ytitle( "Average Marginal Effect of Strange Bedfellows",   /// titles
size(medlarge)) xtitle(" " " Advocacy Salience (log)", size(large)) legend(off) /// titles
plotopts(lwidth(thick)) title("Average Marginal Effect of Strange Bedfellows with 95 CIs", size(large)) yline(0) 
graph export Figure2diversity.png, replace
*the logged values of salience were manually transformed into actual values in the final figure, e^logactyear
*layout and labels also adjusted manually


**************************************
*Figure 3 based on Model 4
**************************************
melogit success  i.Strangebedfellows##c.logactyear logEUresourcescoal  shareactorscamp_all logsignalsize prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:
margins, dydx(i(0 2)Strangebedfellows) at(logactyear=(0(1.0)6)) vsquish 
marginsplot, recast(line) yline(0) 
marginsplot, addplot(histogram logactyear if Missing0==1, ///adding histogram
yaxis(2) yscale(alt axis(2)) below discrete percent ylabel(0 20, axis(2)) lcolor(black*0.5) fcolor(white)) /// putting percent-type histogram behind margins
ylabel(-2 -1.5 -1 -0.5 0  0.5 1, axis(1) labsize(small)) scheme(plotplain) recastci(rline) recast(line)  /// setting ylabel and xlabel for marginsplot, setting scheme and margins type
ytitle( "Average Marginal Effect of Non-Business BFs",   /// titles
size(medlarge)) xtitle(" " " Advocacy Salience (log)", size(large)) legend(off) /// titles
plotopts(lwidth(thick)) title("Average Marginal Effect of Non-Business Bedfellows with 95 CIs", size(large)) yline(0) 
graph export Figure3diversity.png, replace
*the logged values of salience were manually transformed into actual values in the final figure, e^logactyear
*layout and labels also adjusted manually



*Reported in footnote 12: Robustness with size (not logged)

*Model 1
eststo: melogit success c.invhhi_signal c.logactyear  Businessshare logEUresourcescoal prochange_survey posamepos_actor_survey signalsize shareactorscamp_all  i.country  if uniquecoalition==1 || policyid_all:
*Model 2
eststo: melogit success c.invhhi_signal##c.logactyear  Businessshare logEUresourcescoal signalsize  prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:
*Model 3
eststo: melogit success  i.Strangebedfellows logactyear  logEUresourcescoal  signalsize  prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:
*Model 4
eststo: melogit success  i.Strangebedfellows##c.logactyear logEUresourcescoal  shareactorscamp_all signalsize prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:


**************************
*Descriptives
****************************

*******************************************************************************
* Appendix A provides background on the GovLis Project, namely the list of issues 
******************************************************************************

*****************************************************************************
*Appendix B addresses the response rates in the five countries and probes non-response bias realted to the DV of lobbying success

******************************
*Table B.1 Response rate 
*****************************
tab country complete
tabulate country complete, row 

*******************************
*Table B.2 Nonrespose bias 
**************************
tabulate success complete, row


***************************************************************
*Appendix C reports the question wording in the survey
***************************************************************


************
*Appendix D gives descriptives 
*************

*Table D.1 - Summary
summarize c.invhhi_signal i.Strangebedfellows c.logactyear  Businessshare logEUresourcescoal prochange_survey posamepos_actor_survey logsignalsize shareactorscamp_all  i.country  if Missing0==1

*Table D.2 in Appendix - correlation matrix
tab Strangebedfellows, gen(bedf_cat)
spearman invhhi_signal bedf_cat1 bedf_cat2 bedf_cat3 logactyear  Businessshare logEUresourcescoal prochange_survey posamepos_actor_survey logsignalsize shareactorscamp_all  if Missing0==1

***********************
* additional reported test: VIF on Models 1 and 3
***********************
regress success c.invhhi_signal c.logactyear  Businessshare logEUresourcescoal prochange_survey posamepos_actor_survey logsignalsize shareactorscamp_all  i.country  if uniquecoalition==1
estat vif
regress success  i.Strangebedfellows logactyear  logEUresourcescoal  logsignalsize  prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1
estat vif



*************************************************************
*Table  D.3 - Comparison of Coalition Diversity in sample split along median salience 
* median  salience (log) lies at 3.05 (i.e. 21.1 actors per year)
*summarize logactyear if signaldummy==1 & Coaldouble3!=1  &success!=. & logsignalsize!=., detail
************************************************************
summarize invhhi_signal if Missing0==1 & logactyear>=3.05
summarize invhhi_signal if Missing0==1 & logactyear<3.05

**********************************************************
* Table D.4 - comparison coalition size in sample split along median salience 
summarize signalsize if Missing0==1 & logactyear>=3.05
summarize signalsize if Missing0==1 & logactyear<3.05

********************
*T tests
***********************
gen salgroup=.
replace salgroup = 1 if  Missing0==1 & logactyear>=3.05
replace salgroup = 2 if  Missing0==1 & logactyear<3.05
lab var salgroup "splits the sample along mean salience"

ttest invhhi_signal, by(salgroup)
ttest signalsize, by(salgroup)


************************************************
*Figures D.1-D.3 Test for common support 
**********************************************

*Figure D.1 Variation in coalition divesity
egen salbin21 = cut(logactyear) if Missing0==1, group(2)
twoway (sc success invhhi_signal) (lowess success invhhi_signal), by(salbin21)

*Figure D.2 Variation in Advocacy salience across four quartiles of diversity
egen diversity5 = cut(invhhi_signal) if Missing0==1, group(5)
twoway (sc success logactyear) (lowess success logactyear), by(diversity5)

*Figure D.3 Variation in Advoacy salience across three types of Bedfellows
twoway (sc success logactyear) (lowess success logactyear) if Missing0==1, by(Strangebedfellows)



*************************************************************
*Appendix E tests the interactions in multi-level linear models
***************************************************************
******************
*Table E.1
*******************
*Model E1
eststo: mixed success c.invhhi_signal c.logactyear  Businessshare logEUresourcescoal prochange_survey posamepos_actor_survey logsignalsize shareactorscamp_all  i.country  if uniquecoalition==1 || policyid_all:
*Model E.2
eststo: mixed success c.invhhi_signal##c.logactyear  Businessshare logEUresourcescoal logsignalsize  prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:
*Model E.3
eststo: mixed success  i.Strangebedfellows logactyear  logEUresourcescoal  logsignalsize  prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:
*Model E.4
eststo: mixed success  i.Strangebedfellows##c.logactyear logEUresourcescoal  shareactorscamp_all logsignalsize prochange_survey posamepos_actor_survey   i.country  if uniquecoalition==1 || policyid_all:


esttab using TableE1linear.rtf, replace wide nogap onecell cells(b(star fmt(%9.2f)) se(par))                ///
        stats(N aic bic chi2, fmt(%9.0g %9.0f %9.0f) labels("Number of Cases" "AIC" "BIC"))      ///
		starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)	///
        legend label collabels(none) 						///
		varlabels(_cons Constant logsignalsize "Size (log)" logEUresourcescoal "Financial Resource Proxy(log)"  ///
		invhhi_signal "Diversity (inv. HHI)" Businessshare "Share of Business" posamepos_actor_survey "Support of public opinion" prochange_survey "Coalition pro change" logactyear "Advocacy salience" shareactorscamp_all "Camp Share")

eststo clear 

********
*Margins plots
*Figure E.1 - based on Model E.2
mixed success c.invhhi_signal##c.logactyear  Businessshare logEUresourcescoal logsignalsize  prochange_survey posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:
margins, dydx(invhhi_signal) at(logactyear=(0(1.0)6)) vsquish 
marginsplot, addplot(histogram logactyear if Missing0==1, ///adding histogram
yaxis(2) yscale(alt axis(2)) below discrete percent ylabel(0 20, axis(2)) lcolor(black*0.5) fcolor(white)) /// putting percent-type histogram behind margins
ylabel(-2.5 -1.5 -1 -0.5 0 0.5 1.5 1, axis(1) labsize(small)) scheme(plotplain) recastci(rline) recast(line)  /// setting ylabel and xlabel for marginsplot, setting scheme and margins type
ytitle( "Average Marginal Effect of Diversity (inv. HHI)",   /// titles
size(medlarge)) xtitle(" " " Advocacy Salience (log)", size(large)) legend(off) /// titles
plotopts(lwidth(thick)) title("Average Marginal Effect of Diversity with 95 CIs", size(large)) yline(0) 
graph export FigureE1.png, replace
* labelling of X-axis manually changed to actual values; layout and labels improved manually


*Figure E.2 based on Model E.4
mixed success  i.Strangebedfellows##c.logactyear logEUresourcescoal  shareactorscamp_all logsignalsize prochange_survey posamepos_actor_survey   i.country  if uniquecoalition==1 || policyid_all:
margins, dydx(i(0/1)Strangebedfellows) at(logactyear=(0(1.0)6)) vsquish 
marginsplot, recast(line) yline(0) 
marginsplot, addplot(histogram logactyear if Missing0==1, ///adding histogram
yaxis(2) yscale(alt axis(2)) below discrete percent ylabel(0 20, axis(2)) lcolor(black*0.5) fcolor(white)) /// putting percent-type histogram behind margins
ylabel(-2 -1.5 -1 -0.5 0  0.5 1, axis(1) labsize(small)) scheme(plotplain) recastci(rline) recast(line)  /// setting ylabel and xlabel for marginsplot, setting scheme and margins type
ytitle( "Average Marginal Effect of Strange Bedfellows",   /// titles
size(medlarge)) xtitle(" " " Advocacy Salience (log)", size(large)) legend(off) /// titles
plotopts(lwidth(thick)) title("Average Marginal Effect of Strange Bedfellows with 95 CIs", size(large)) yline(0) 
graph export FigureE2.png, replace
* labelling of X-axis manually changed to actual values, layout and labels improved manually

*Figure E.3 based on Model E.4
mixed success  i.Strangebedfellows##c.logactyear logEUresourcescoal  shareactorscamp_all logsignalsize prochange_survey posamepos_actor_survey   i.country  if uniquecoalition==1 || policyid_all:
margins, dydx(i(0 2)Strangebedfellows) at(logactyear=(0(1.0)6)) vsquish 
marginsplot, recast(line) yline(0) 
marginsplot, addplot(histogram logactyear if Missing0==1, ///adding histogram
yaxis(2) yscale(alt axis(2)) below discrete percent ylabel(0 20, axis(2)) lcolor(black*0.5) fcolor(white)) /// putting percent-type histogram behind margins
ylabel(-2 -1.5 -1 -0.5 0  0.5 1, axis(1) labsize(small)) scheme(plotplain) recastci(rline) recast(line)  /// setting ylabel and xlabel for marginsplot, setting scheme and margins type
ytitle( "Average Marginal Effect of Non-Business BFs",   /// titles
size(medlarge)) xtitle(" " " Advocacy Salience (log)", size(large)) legend(off) /// titles
plotopts(lwidth(thick)) title("Average Marginal Effect of Non-Business Bedfellows with 95 CIs", size(large)) yline(0) 
graph export FigureE3.png, replace
* labelling of X-axis manually changed to actual values, layout and labels improved manually



*******************************************************
*Appendix F -Observable Implications at actor level
*******************************************************


**************
*Table F.1
***************
*Model F.1
eststo: melogit success i.coalition4 c.logactyear  prochange_survey posamepos_actor_survey shareactorscamp_all i.sourceactorlevel i.country  || policyid_all:
*Model F.2
eststo: melogit success i.coalition4##c.logactyear  prochange_survey posamepos_actor_survey shareactorscamp_all i.sourceactorlevel i.country || policyid_all:
*Model F.3
eststo: melogit success i.coalition4##c.logactyear  resource_econ  prochange_survey posamepos_actor_survey shareactorscamp_all i.sourceactorlevel i.country  || policyid_all:

esttab using Table_F1actorlevelcft.rtf, replace wide nogap onecell cells(b(star fmt(%9.2f)) se(par))                ///
        stats(N aic bic chi2, fmt(%9.0g %9.0f %9.0f) labels("Number of Cases" "AIC" "BIC"))      ///
		starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)	///
        legend label collabels(none) 						///
		varlabels(_cons Constant logsignalsize "Size (log)"  posamepos_actor_survey "Support of public opinion" prochange_survey "Actor pro change" logactyear "Advocacy salience" shareactorscamp_all "Camp Share" resource_econ "Self-reported Resources")

eststo clear 

********************
*Margins Plots
*Figure F.1 based on Model F2
**************************
melogit success i.coalition4##c.logactyear  prochange_survey posamepos_actor_survey shareactorscamp_all i.sourceactorlevel i.country  || policyid_all:
margins, dydx(i(0 2)coalition4) at(logactyear=(0(1.0)6)) vsquish 
marginsplot, recast(line) yline(0) 
marginsplot, addplot(histogram logactyear if coalition4!=. & sourceactorlevel!=. & success!=. , ///adding histogram
yaxis(2) yscale(alt axis(2)) below discrete percent ylabel(0 20, axis(2)) lcolor(black*0.5) fcolor(white)) /// putting percent-type histogram behind margins
ylabel(-1.5 -1 -0.5 0  0.5 1, axis(1) labsize(small)) scheme(plotplain) recastci(rline) recast(line)  /// setting ylabel and xlabel for marginsplot, setting scheme and margins type
ytitle( "Average Marginal Effect of Strange Bedfellows",   /// titles
size(medlarge)) xtitle(" " " Advocacy Salience (log)", size(large)) legend(off) /// titles
plotopts(lwidth(thick)) title("Average Marginal Effect of Strange Bedfellows with 95 CIs", size(large)) yline(0) 
graph export FigureF1.png, replace
* labelling of X-axis manually changed to actual values, layout and labels improved manually

*Figure F.2 based on Model F2
melogit success i.coalition4##c.logactyear  prochange_survey posamepos_actor_survey shareactorscamp_all i.sourceactorlevel i.country  || policyid_all:
margins, dydx(i(0/2)coalition4) at(logactyear=(0(1.0)6)) vsquish 
marginsplot, recast(line) yline(0) 
marginsplot, addplot(histogram logactyear if coalition4!=. & sourceactorlevel!=. & success!=. , ///adding histogram
yaxis(2) yscale(alt axis(2)) below discrete percent ylabel(0 20, axis(2)) lcolor(black*0.5)) /// putting percent-type histogram behind margins
ylabel(-1.5 -1 -0.5 0  0.5 1, axis(1) labsize(small)) scheme(plotplain) recastci(rline) recast(line)  /// setting ylabel and xlabel for marginsplot, setting scheme and margins type
ytitle( "Average Marginal Effect of Homogenous & Strange BFs",   /// titles
size(medlarge)) xtitle(" " " Advocacy Salience (log)", size(large)) legend(off) /// titles
plotopts(lwidth(thick)) title("Average Marginal Effects with 95 CIs", size(large)) yline(0) 
graph export FigureF2.png, replace
*labelling of X-axis manually changed to actual values, layout and labels improved manually




****************************
* Appendix G looks at the relationship to promoting the status quo or policy change
***************************

*Table G.1 - Interaction of Diversity with Status Quo
eststo: melogit success c.invhhi_signal##i.prochange_survey logactyear Businessshare logEUresourcescoal logsignalsize   posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:
eststo: melogit success i.Strangebedfellows##i.prochange_survey logactyear  logEUresourcescoal logsignalsize   posamepos_actor_survey  shareactorscamp_all i.country  if uniquecoalition==1 || policyid_all:


esttab using Table_G1.rtf, replace wide nogap onecell cells(b(star fmt(%9.2f)) se(par))                ///
        stats(N aic bic chi2, fmt(%9.0g %9.0f %9.0f) labels("Number of Cases" "AIC" "BIC"))      ///
		starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)	///
        legend label collabels(none) 						///
		varlabels(_cons Constant logsignalsize "Size (log)" logEUresourcescoal "Financial Resource Proxy(log)"  ///
		invhhi_signal "Diversity (inv. HHI)"  Businessshare "Share of Business" ////
		posamepos_actor_survey "Support of public opinion" prochange_survey "Coalition pro change" logactyear "Advocacy salience" shareactorscamp_all "Camp Share")

eststo clear 


*Table G.2  Distribution Status quo
****************************
tab salgroup prochange_survey
summarize  invhhi_signal logactyear if prochange_survey==0 & Missing0==1 
summarize  invhhi_signal logactyear if prochange_survey==1 & Missing0==1 

gen prochgroup=.
replace prochgroup = 1 if  Missing0==1  & prochange_survey==0
replace prochgroup = 2 if  Missing0==1 & prochange_survey==1

ttest invhhi_signal, by(prochgroup)
ttest logactyear, by(prochgroup)



*


