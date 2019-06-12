******************************************************************************
*                                                                            *
* Michael Poznansky and Matt K. Scroggs                                      *
* "Ballots and Blackmail: Coercive Bargaining and the Democratic Peace"      *
* International Studies Quarterly                                            *
*                                                                            *
******************************************************************************


* Purpose
* This is a Stata replication file for "Ballots and Blackmail: Coercive Bargaining and the Democratic Peace." It replicates the regressions and charts described in the original article.
*
* https://dataverse.harvard.edu/dataverse/mkscroggs
*
* Requirements
* 1. This file requires the Stata datasets "PoznanskyScroggsISQ.dta".
* 2. This file requires Stata 13 or newer to run the firthlogit and meqrlogit models, while Stata 14 or newer is needed use marginsplot with meqrlogit.
*
* Version 1.0
* Last updated: January 15, 2016

*Main Tables and Graphs

clear
set more off
cd $dir

use PoznanskyScroggsISQ.dta, clear

**************
*Polity Joint*
**************

*Table 3, Model 1 (Full model)

logit mct polyprod lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu, cluster(dyad_id)
outreg2 using ISQ_Note_1v3, tex(frag) replace

*Figure 2, top-left graph (Full model)

margins, at(polyprod=(0(10)100))
marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Full Model") scheme(s2mono) graphregion(fcolor(white))
graph save PolityJointFull, replace

*Table 3, Model 2 (Firth corrected full model)

firthlogit mct polyprod lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu
outreg2 using ISQ_Note_1v3, tex(frag) append

*Figure 2, top-right graph (Firth corrected full model)

margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(0(10)100))
marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Firth Corrected Model") scheme(s2mono) graphregion(fcolor(white))
graph save PolityJointFirth, replace

*Table 3, Model 3 (Politically relevant dyads)

logit mct polyprod lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)
outreg2 using ISQ_Note_1v3, tex(frag) append

*Figure 2, bottom-left graph (Politically relevant dyads)

margins, at(polyprod=(0(10)100))
marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Politically Relevant Dyads") scheme(s2mono) graphregion(fcolor(white))
graph save PolityJointPolRev, replace

*Table 3, Model 4 (Firth corrected, politically relevant dyads)

firthlogit mct polyprod lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1
outreg2 using ISQ_Note_1v3, tex(frag) append

*Figure 2, bottom-right graph (Firth corrected, politically relevant dyads)

margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(0(10)100))
marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Politically Relevant Dyads w/ Firth Correction") scheme(s2mono) graphregion(fcolor(white))
graph save PolityJointFirthPolRev, replace

gr combine "PolityJointFull" "PolityJointFirth" "PolityJointPolRev" "PolityJointFirthPolRev", title("Marginal Effect of Democracy, PolityJoint Measure")
graph save PolityJointCombined, replace

*Table 3, Model 5 (Three-way mixed effects)

meqrlogit mct polyprod lowdpnd cincratio alliance1 absidealdiff time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle
outreg2 using ISQ_Note_1v3, tex(frag) append

*Figure 3 (Three-way mixed effects)

margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(0(10)100))
marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("PolityJoint - Mixed Effects Model") scheme(s2mono) graphregion(fcolor(white))
graph save PolityJointMixed, replace

*NOTE*: Coefficients for Table 3, Model 6 were generated with the sample of politically relevant dyads (Model 3);
*standard errors were calculated using Aronow et al.'s (2015) sandwich estimator;
*consult the R scripts and associated cleaning do-files to replicate.

************
*Polity Low*
************

*Table 4, Model 1 (Full model)

logit mct polity_low lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu, cluster(dyad_id)
outreg2 using ISQ_Note_2v3, tex(frag) replace

*Figure 4, top-left graph (Full model)

margins, at(polity_low=(-10(2)10))
marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Full Model") scheme(s2mono) graphregion(fcolor(white))
graph save PolityLowFull, replace

*Table 4, Model 2 (Firth corrected full model)

firthlogit mct polity_low lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu
outreg2 using ISQ_Note_2v3, tex(frag) append

*Figure 4, top-right graph (Firth corrected full model)

margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-10(2)10))
marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Firth Corrected Model") scheme(s2mono) graphregion(fcolor(white))
graph save PolityLowFirth, replace

*Table 4, Model 3 (Politically relevant dyads)

logit mct polity_low lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)
outreg2 using ISQ_Note_2v3, tex(frag) append

*Figure 4, bottom-left graph (Politically relevant dyads)

margins, at(polity_low=(-10(2)10))
marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Politically Relevant Dyads") scheme(s2mono) graphregion(fcolor(white))
graph save PolityLowPolRev, replace

*Table 4, Model 4 (Firth corrected, politically relevant dyads)

firthlogit mct polity_low lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1
outreg2 using ISQ_Note_2v3, tex(frag) append

*Figure 4, bottom-right graph (Firth corrected, politically relevant dyads)

margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-10(2)10))
marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Politically Relevant Dyads w/ FirthCorrection") scheme(s2mono) graphregion(fcolor(white))
graph save PolityLowFirthPolRev, replace

gr combine "PolityLowFull" "PolityLowFirth" "PolityLowPolRev" "PolityLowFirthPolRev", title("Marginal Effect of Democracy, PolityLow Measure")
graph save PolityLowCombined, replace

*Table 4, Model 5 (Three-way mixed effects)

meqrlogit mct polity_low lowdpnd cincratio alliance1 absidealdiff time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle
outreg2 using ISQ_Note_2v3, tex(frag) append

*Figure 6 (Three-way mixed effects)

margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-10(2)10))
marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("PolityLow - Mixed Effects") scheme(s2mono) graphregion(fcolor(white))
graph save PolityLowMixed, replace

*NOTE*: Coefficients for Table 4, Model 6 were generated with the sample of politically relevant dyads (Model 3);
*standard errors were calculated using Aronow et al.'s (2015) sandwich estimator;
*consult the R scripts and associated cleaning do-files to replicate.

*************
*Polity Both*
*************

*Table 5, Model 1 (Full model)

logit mct polity_both lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu, cluster(dyad_id)
outreg2 using ISQ_Note_3v3, tex(frag) replace

*Figure 5, top-left graph (Full model)

margins, at(polity_both=(0 1))
marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Full Model") scheme(s2mono) graphregion(fcolor(white))
graph save PolityBothFull, replace

*Table 5, Model 2 (Firth corrected full model)

firthlogit mct polity_both lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu
outreg2 using ISQ_Note_3v3, tex(frag) append

*Figure 5, top-right graph (Firth corrected full model)

margins, expression(1/(1+exp(-predict(xb)))) at(polity_both=(0 1))
marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Firth Correction") scheme(s2mono) graphregion(fcolor(white))
graph save PolityBothFirth, replace

*Table 5, Model 3 (Politically relevant dyads)

logit mct polity_both lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)
outreg2 using ISQ_Note_3v3, tex(frag) append

*Figure 5, bottom-left graph (Politically relevant dyads)

margins, at(polity_both=(0 1))
marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Politically Relevant Dyads") scheme(s2mono) graphregion(fcolor(white))
graph save PolityBothPolRev, replace

*Table 5, Model 4 (Firth corrected, politically relevant dyads)

firthlogit mct polity_both lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1
outreg2 using ISQ_Note_3v3, tex(frag) append

*Figure 5, bottom-right graph (Firth corrected, politically relevant dyads)

margins, expression(1/(1+exp(-predict(xb)))) at(polity_both=(0 1))
marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Politically Relevant Dyads w/ Firth Correction") scheme(s2mono) graphregion(fcolor(white))
graph save PolityBothFirthPolRev, replace

gr combine "PolityBothFull" "PolityBothFirth" "PolityBothPolRev" "PolityBothFirthPolRev", title("Marginal Effect of Democracy, PolityBoth Measure")
graph save PolityBothCombined, replace

*Table 5, Model 5 (Three-way mixed effects model)

meqrlogit mct polity_both lowdpnd cincratio alliance1 absidealdiff time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle
outreg2 using ISQ_Note_3v3, tex(frag) append

*Not included in paper

margins, expression(1/(1+exp(-predict(xb)))) at(polity_both=(0 1))
marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("PolityBoth - Mixed Effects") scheme(s2mono) graphregion(fcolor(white))
graph save PolityBothMixed, replace

*NOTE*: Coefficients for Table 5, Model 6 were generated with the sample of politically relevant dyads (Model 3);
*standard errors were calculated using Aronow et al.'s (2015) sandwich estimator;
*consult the R scripts and associated cleaning do-files to replicate.
