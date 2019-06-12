** Replication Files for "The Influence of Legislative Reappointment 
** on State Supreme Court Decision-Making," by Thomas Gray, in State
** Politics and Policy Quarterly (2017).

** Case data from 1995-2010 were taken from Hall and Windett (2013), 
** selected from the sets of cases in the "Criminal Law & Procedure" 
** legalarea variable, plus those that feature the state prosecutor 
** as a party, selected by the author.  Case data from 2011-2014 were 
** appended originally from the author based on Lexis headnote searches for 
** the words "Criminal" and the state prosecutor party name.

** From this set, the author removed by hand non-criminal cases, 
** and coded the direction of the case in the way described in the text.
** Cases with split directions (defendants win in part, lose in part)
** were removed.  Cases without dispositions were also removed.  The 
** dataset included here is the result of these winnowing processes.
** Data on judges, specifically the variable eligible, was created by 
** the author, specific to each case.  

** The variable gov was taken from Adam Bonica's (2013) DIME dataset.  
** Due to the small number of observations and the incredibly large and 
** complicated nature of the DIME dataset, these observations were entered by 
** hand rather than computationally merged.  I flip their scale so that the 
** variable increases in liberalism for ease of interpretation.

** The variable wgtleg was created as follows:
** Download the Shor & McCarty (2011, 2015 update) individual-level legislator
** file at: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/THDBRA
** Then:
use "/Users/[username]/Downloads/shor mccarty 1993-2014 state individual legislator scores public June 2015.dta"
** Select Vermont, Virginia, and South Carolina
gen keep = 0
replace keep = 1 if st=="VT"
replace keep = 1 if st=="VA"
replace keep = 1 if st=="SC"
keep if keep == 1
** Create General Assembly groups for South Carolina and Vermont, which take combined votes:
forvalues i = 1995(1)2014 {
gen ga`i' = 0
replace ga`i' = 1 if senate`i'==1
replace ga`i' = 1 if house`i'==1
}

** For Virginia:
forvalues i=1996(1)2008{
tabstat np_score if st=="VA" & house`i'==1, stat(median)
}
forvalues i=2010(1)2014{
tabstat np_score if st=="VA" & house`i'==1, stat(median)
}
forvalues i=1996(1)2008{
tabstat np_score if st=="VA" & senate`i'==1, stat(median)
}
forvalues i=2010(1)2014{
tabstat np_score if st=="VA" & senate`i'==1, stat(median)
}

** 1995 and 2009 are missing in the Shor & McCarty Data.  These scores are then 
** averaged within years to create Virginia's score.

** For ease of interpretation, I switched the scales such that negative scores are positive in
** my usage.  These scores were then entered into my dataset for all cases in corresponding years.

** Load final analysis dataset, including the preceding variables and author-coded variables.
use "/Users/[file path]/Gray SPPQ replication analysis data.dta"

** Create the primary dependent variable, liberal vote:
gen libvote = .
** Uses author-coded libdisp (Liberal Disposition) dummy variable with the vote variable from
** Hall and Windett's core dataset to create the justice-level Liberal Vote variable.
replace libvote = 1 if vote==1 & libdisp==1
replace libvote = 1 if vote==0 & libdisp==0
replace libvote = 0 if vote==1 & libdisp==0
replace libvote = 0 if vote==0 & libdisp==1

** Create Figure 1, except for a few aesthetic changes made manually in Stata's Graph Editor.
graph twoway connected wgtleg year if fipsyearpos==1 & fips==45, legend(off) msymbol(none) lcolor(red) lpattern(longdash_dot) || connected wgtleg year if fipsyearpos==1 & fips==50, legend(off) msymbol(none) lcolor(blue) lpattern(dash) || connected wgtleg year if fipsyearpos==1 & fips==51, legend(off) msymbol(none) lcolor(orange) plotregion(margin(tiny)) graphregion(color(white)) ytitle("Legislature Liberalism")

** Create Figure 2, except for a few aesthetic changes made manually in Stata's Graph Editor.
graph twoway connected voterlib year if fipsyearpos==1 & fips==45, legend(off) msymbol(none) lcolor(red) lpattern(longdash_dot) || connected voterlib year if fipsyearpos==1 & fips==50, legend(off) msymbol(none) lcolor(blue) lpattern(dash) || connected voterlib year if fipsyearpos==1 & fips==51, legend(off) msymbol(none) lcolor(orange) plotregion(margin(tiny)) graphregion(color(white)) ytitle("Legislature Liberalism")

set more off

**Table 2**
**Model 1**
glm libvote i.elig##c.wgtleg gov defapp voterlib i.justice if outparty==1, family(binomial) link(logit)

**Model 2**
glm libvote i.elig##c.wgtleg gov defapp voterlib i.justice if outparty==1, family(binomial) link(logit) cluster(justice)

**Model 3**
glm libvote i.elig##c.wgtleg gov defapp voterlib i.justice if outparty==0, family(binomial) link(logit)

**Model 4**
glm libvote i.elig##c.wgtleg gov defapp voterlib i.justice if outparty==0, family(binomial) link(logit) cluster(justice)

** Marginal Effects and Figure 3**
** Figure 3**
quietly glm libvote i.elig##c.wgtleg gov defapp voterlib i.justice if outparty==1, family(binomial) link(logit) cluster(justice)
margins, dydx(elig) at (wgtleg=(-.8(0.05)0.8))
** Graph Margins Plot, Figure 3.  The following code produces Figure 3, except for a small number of aesthetic changes made manually in Stata's
** Graph Editor.
marginsplot, recastci(rarea) legend(off) addplot(scatter rugplot wgtleg if model2==1 & fipsyearmodelpos==1, msymbol(none) mlabcolor(black) mlabel(pipe) mlabpos(0) plotregion(margin(tiny)) graphregion(color(white)) ytitle("Effect on Pr(Liberal Vote)") xtitle("Legislature Liberalism"))

**Placebo Test**
**Model 1**
glm libvote i.elig wgtleg i.elig##c.gov defapp voterlib i.justice if govoutparty==1, family(binomial) link(logit)

**Model 2**
glm libvote i.elig wgtleg i.elig##c.gov defapp voterlib i.justice if govoutparty==1, family(binomial) link(logit) cluster(justice)

**Model 3**
glm libvote i.elig wgtleg i.elig##c.gov defapp voterlib i.justice if govoutparty==0, family(binomial) link(logit)

**Model 4**
glm libvote i.elig wgtleg i.elig##c.gov defapp voterlib i.justice if govoutparty==0, family(binomial) link(logit) cluster(justice)

**Appendix 1 - Descriptive Statistics
quietly glm libvote i.elig##c.wgtleg gov defapp voterlib i.justice if outparty==1, family(binomial) link(logit)
quietly gen sumstat=1 if e(sample)
quietly glm libvote i.elig##c.wgtleg gov defapp voterlib i.justice if outparty==0, family(binomial) link(logit)
quietly replace sumstat = 1 if e(sample)
tabstat libvote wgtleg elig gov voterlib defapp if sumstat==1, stat(mean, sd, min, max)

** Figure 4**
quietly glm libvote i.elig##c.wgtleg gov defapp voterlib i.justice if outparty==1, family(binomial) link(logit) cluster(justice)
margins, dydx(wgtleg) at(elig=(0 1))
margins, dydx(wgtleg) over(r.elig) contrast(effects)
quietly glm libvote i.elig##c.wgtleg gov defapp voterlib i.justice if outparty==0, family(binomial) link(logit) cluster(justice)
margins, dydx(wgtleg) at(elig=(0 1))
margins, dydx(wgtleg) over(r.elig) contrast(effects)
** The results of these margins were used to create Figure 4.  A separate data file includes the point estimates and confidence bands taken from 
** the preceding commands to create Figure 4.
** Load Figure 4 Data File
use "/Users/[username]/Gray SPPQ Figure 4 Data.dta"
** Generate Figure 4, except for a small number of aesthetic changes made manually in Stata's Graph Editor.
graph twoway scatter effect x if level==1, legend(off) mcolor(black) || connected effect x if level==2, msymbol(none) lcolor(black) ||  connected effect x if level==3, msymbol(none) lcolor(black) || connected effect x if level==4, msymbol(none) lcolor(black) || connected effect x if level==5, msymbol(none) lcolor(black) plotregion(margin(tiny)) graphregion(color(white)) ytitle("Effect on Pr(Liberal Vote)")



