*******************
* Andrews, Pandya, & Leblang
* "Ethnocentrism Reduces Foreign Direct Investment"
*******************

version 14

clear
use "/Users/dal7w/Dropbox/migrants_FDI_USstates/monadic_dataset.dta"

// TOBIT MODELS IN THE MAIN PAPER //
** Table 1, Model 1 **
tobit lngreenfield avg_level_0 l.lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop i.stateid, vce(cl state) ll(0) nolog

** Table 1, Model 2 **
tobit lngreenfield avg_level_0 l.lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop right_to_work anti fractionofstatehousethatisdemocr fractionofstatesenatethatisdemoc i.stateid, vce(cl state) ll(0) nolog


* Calculation of Substantive Effects (footnote 16) based on model 1
* Note: greenfield is in millons of US dollars
* Interpretation is like a log linear model
qui tobit lngreenfield avg_level_0 l.lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop i.stateid, cl(state) ll(0) nolog
* Coefficient is -2.017; variable is bounded by 0 and 1
* Increasing avg_level_0 by .10, decreases lngreenfield by .2.  

preserve
qui tab stateid, gen(SD)
qui tobit lngreenfield avg_level_0 l.lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop SD*, cl(state) ll(0) nolog
foreach var of varlist  avg_level_0 lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop SD* {
	qui sum `var'
	qui replace `var' =r(mean)
	}

sum avg_level_0
predict yhat if e(sample)
sum yhat
drop yhat
replace avg_level_0=.49
predict yhat
sum yhat
replace avg_level_0=.57
drop yhat
predict yhat
sum yhat
display exp(6.79)
display exp(6.59)
display exp(6.43)
restore
*Results are: (at mean, ethnocentrism is 6.79)
* Ethno		y-hat	converted
* .39		6.79	889 million
* .49		6.59	727 million
* .57		6.43	620 million
* At the mean, greenfield investment is 889 million.  Increasing ethnocentrism by 10 points decreases greenfield by 162 million; 
* increasing ethnocentrism by one SD (.18) decreasds greenfield by 229 million.
qui poisson lngreenfield c.avg_level_0 l.lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop i.stateid, vce(cl state)  nolog

margins, at(avg_level_0=(0(.1)1)) force

** Footnote 17 and appendix table 5

tobit jobs avg_level_0 l.lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop i.stateid, vce(cl state) ll(0) nolog
 
est store jobs
 * Each percentage point increase in ethnocentrism results in a loss of 10 jobs

 
 // OLS MODELS FOR THE APPENDIX //
** Baseline Model - Anti-immigrant Sentiment **
areg lngreenfield avg_level_0 l.lngreenfield MAdeals lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop, cl(state) abs(stateid)

** Expanded Model - Anti-immigrant Sentiment **
areg lngreenfield avg_level_0 l.lngreenfield MAdeals lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop anti fractionofstatehousethatisdemocr fractionofstatesenatethatisdemoc, cl(state) abs(stateid)

** Baseline Model - Pro-immigrant Sentiment **
areg lngreenfield avg_level l.lngreenfield MAdeals lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop, cl(state) abs(stateid)

** Expanded Model - Pro-immigrant Sentiment **
areg lngreenfield avg_level l.lngreenfield MAdeals lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop pro fractionofstatehousethatisdemocr fractionofstatesenatethatisdemoc, cl(state) abs(stateid)


// TOBIT MODELS W/ YEAR FE FOR THE APPENDIX //
** Expanded Model - Anti-immigrant sentiment **
tobit lngreenfield avg_level_0 l.lngreenfield MAdeals lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop anti fractionofstatehousethatisdemocr fractionofstatesenatethatisdemoc i.stateid i.year, cl(state) ll(0) nolog

** Expanded Model - Pro-immigrant sentiment **
tobit lngreenfield avg_level l.lngreenfield MAdeals lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop pro fractionofstatehousethatisdemocr fractionofstatesenatethatisdemoc i.stateid i.year, cl(state) ll(0) nolog

// TOBIT MODELS FOR PRO-IMMIGRANT SENTIMENT IN THE APPENDIX //
** Baseline Model - Pro-Immigrant Sentiment **
tobit lngreenfield avg_level l.lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop i.stateid, cl(state) ll(0) nolog

** Expanded Model - Pro-Immigrant Sentiment **
tobit lngreenfield avg_level l.lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop pro fractionofstatehousethatisdemocr fractionofstatesenatethatisdemoc i.stateid, cl(state) ll(0) nolog

// TOBIT MODELS CONTROLLING FOR UNIONIZATION FOR THE APPENDIX //
** Baseline model with unionization **
tobit lngreenfield avg_level_0 l.lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop union_density i.stateid, cl(state) ll(0) nolog

** Exapnded model with unionization **
tobit lngreenfield avg_level_0 l.lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop union_density anti fractionofstatehousethatisdemocr fractionofstatesenatethatisdemoc i.stateid, cl(state) ll(0) nolog


// M&A DEALS MODELS FOR THE APPENDIX //
** Baseline model with MA Deals as DV **
tobit MAdeals avg_level_0 l.MAdeals lngreenfield lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop i.stateid, cl(state) ll(0) nolog
outreg2 using "MA Deal Tobit Models.doc", replace ctitle(1)

tobit MAdeals avg_level_0 l.MAdeals lngreenfield lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop anti fractionofstatehousethatisdemocr fractionofstatesenatethatisdemoc i.stateid, cl(state) ll(0) nolog
outreg2 using "MA Deal Tobit Models.doc", append ctitle(2)

 
 
*Appendix Table 7, Column 1
 * Estimate with fixed effects but without time-varying state level covariates
 tobit lngreenfield avg_level_0 i.stateid, cl(state) ll(0) nolog
 est store A
 *Appendix Table 7, Column 2
 * Estimate without fixed effects but with time-varying state level covariates
 tobit lngreenfield avg_level_0 l.lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop , cl(state) ll(0) nolog
est store B
*Appendix Table 7, Column 3
* Estimate with lags of all variables
tobit lngreenfield avg_level_0 l.(lngreenfield MAdeals  lngsppc bachelordegree unemploymentrate FTZ mine lnwages povertyrate foreignborn_pop npass_pop) i.stateid, cl(state) ll(0) nolog
est store C

esttab jobs  using jobs.rtf, replace se compress label star(* 0.10 ** 0.05)
esttab A B C   using appendixtable1.rtf, replace se compress label star(* 0.10 ** 0.05)
