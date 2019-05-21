*********************************************
** Replication File **
** Title: Slow-Rolling, Fast-Tracking and the Pace of Bureaucratic Decisions in Rulemaking
** Author: Rachel Augustine Potter
** Journal: The Journal of Politics
** Analysis Data File name: "slowroll.csv"
** **********************************************

/*
** **********************************************
Note: for complete descriptions of the variables, see the manuscript and Table A1 in the Appendix

Variable definitions:
id				Unique id for each rule
rin				Regulatory Identification Number (from the Unified Agenda)
bureau			Bureau identification number
bureauacro		Bureau acronym
bureauname		Full bureau name
deptvar			Department identification number
deptname		Full department name
counter			Indicator for whether rule was completed
monthstofinal	Total number of months to complete the rule
time			Month counter for time rule pending completion
bureautotal		Total number of rules issued by the bureau
oirareviewtime	Number of days that OIRA reviewed the proposed rule
lnreviewtime	Logged number of days that OIRA reviewed the proposed rule (+1)
oppsizeunity	Opposition size unity for liberal or conservative agency
cases12m		Number of DC circuit cases involving the department in the previous 12 months	
impact 			Measure of the rule's impact; first dimension of principal components analysis (see section A2 of the Appendix) 
complexity		Measure of the rule's complexity; second dimension of principal components analysis (see section A2 of the Appendix) 
jdeadline		Indicator of whether there was a court-ordered deadline to issue the final rule
sdeadline		Indicator of whether there was a statutory deadline to issue the final rule
lnspend			Logged industry campaign spending in the bureau's policy area
employment000	Number of employees in the bureau (in 000s)
bush 			Indicator for the W. Bush presidential administration
obama			Indicator for the Obama presidential administration
sameoiraadmin	Indicator for whether OIRA had the same Administrator in place that reviewed the proposed rule
** **********************************************
*/


stset time, failure(failed==1 2) id(id)

**Figure 1
graph hbox monthstofinal if bureautotal > 30 & counter == 1, over(bureauacro, sort(1) label(labsize(tiny))) noout plotregion(margin(zero)) graphregion(color(white)) note("") ytitle("Months to Final", size(vsmall)) ylabel(1 12 24 36 48 60 72 84, labsize(vsmall) nogrid) title("") medtype(marker) medmarker(mlabel(tiny)msymbol(diamond) msize(vsmall) mcolor(black)) aspect(1.5)

**Table 1
stcox lnreview oppsizeunity cases12m bush obama ,  nohr nolog strata(bureau) robust
stcox lnreview oppsizeunity cases12m impact complexity jdeadline sdeadline lnspend employment000 bush obama,  nohr nolog strata(bureau) robust
stcox lnreview oppsizeunity cases12m impact complexity jdeadline sdeadline lnspend employment000 bush obama if impact >=    .2275 ,  nohr nolog strata(bureau) robust
stcox lnreview oppsizeunity cases12m impact complexity jdeadline sdeadline lnspend employment000 bush obama if impact >= .3142462,  nohr nolog strata(bureau) robust

**Figure 2
*ssc install coefplot
stcox lnreview oppsizeunity cases12m impact complexity jdeadline sdeadline lnspend employment000 bush obama,  nohr nolog strata(bureau) robust
eststo model2
coefplot model2, graphregion(color(white)) xline(1, lpattern(dash) lcolor(black) lwidth(.25)) msize(small) mcolor(black) eform drop(bush obama) grid(none)

**Table 2
stcox c.lnreview##c.complexity c.oppsizeunity##c.complexity c.cases12m##c.complexity impact complexity jdeadline sdeadline lnspend employment000 bush obama,  nohr nolog strata(bureau) robust
stcox c.lnreview##c.complexity c.oppsizeunity##c.complexity c.cases12m##c.complexity impact complexity jdeadline sdeadline lnspend employment000 bush obama if impact >=    .2275 ,  nohr nolog strata(bureau) robust
stcox c.lnreview##i.sameoiraadmin oppsizeunity cases12m impact complexity jdeadline sdeadline lnspend employment000 bush obama,  nohr nolog strata(bureau) robust
stcox c.lnreview##i.sameoiraadmin oppsizeunity cases12m impact complexity jdeadline sdeadline lnspend employment000 bush obama if impact >=    .2275 ,  nohr nolog strata(bureau) robust

**Figure 3
stcox c.oirareviewtime##i.sameoiraadmin oppsizeunity cases12m impact complexity jdeadline sdeadline lnspend employment000 bush obama i.bureau,  nohr nolog robust
stcurve, survival at1(sameoiraadmin =1 oirareviewtime = 10 sdeadline = 0 jdeadline = 0) at2(sameoiraadmin =0 oirareviewtime =10 sdeadline = 0 jdeadline = 0) range(1,24) graphregion(color(white)) xlab(2 4 6 8 10 12 14 16 18 20 22 24) xtitle(Time in Months) ylab(, nogrid) connect(direct) plotregion(margin(zero)) title("a) 10 Review Days") clcolor(black navy) clpattern(longdash solid) ytitle("") legend(pos(2) ring(0) col(1) lab(1 "Same Administrator") lab(2 "New Administrator")) name(low)
stcurve, survival at1(sameoiraadmin =1 oirareviewtime = 78 sdeadline = 0 jdeadline = 0) at2(sameoiraadmin =0 oirareviewtime  =78 sdeadline = 0 jdeadline = 0) range(1,24) graphregion(color(white)) xlab(2 4 6 8 10 12 14 16 18 20 22 24) xtitle(Time in Months) ylab(, nogrid) connect(direct) plotregion(margin(zero)) title("b) 78 Review Days") clcolor(black navy) clpattern(longdash solid) ytitle("") legend(off) name(med)
stcurve, survival at1(sameoiraadmin =1 oirareviewtime = 180 sdeadline = 0 jdeadline = 0) at2(sameoiraadmin =0 oirareviewtime =180 sdeadline = 0 jdeadline = 0) range(1,24) graphregion(color(white)) xlab(2 4 6 8 10 12 14 16 18 20 22 24) xtitle(Time in Months) ylab(, nogrid) connect(direct) plotregion(margin(zero)) title("c) 180 Review Days") clcolor(black navy) clpattern(longdash solid) ytitle("") legend(off) name(high)
