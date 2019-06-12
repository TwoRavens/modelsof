******************************************************************************
*                                                                            *
* Michael Poznansky and Matt K. Scroggs                                      *
* "Ballots and Blackmail: Coercive Bargaining and the Democratic Peace"      *
* International Studies Quarterly                                            *
*                                                                            *
******************************************************************************


* Purpose
* This is a Stata replication file for "Ballots and Blackmail: Coercive Bargaining and the Democratic Peace." It replicates the regressions and charts described in the online appendix.
*
* https://dataverse.harvard.edu/dataverse/mkscroggs
*
* Requirements
* 1. This file requires the Stata datasets "PoznanskyScroggsISQ.dta".
* 2. This file requires Stata 13 or newer to run the firthlogit and meqrlogit models, while Stata 14 or newer is needed use marginsplot with meqrlogit.
*
* Version 1.0
* Last updated: January 15, 2016

***1a: All UN Affinity + LowDepend Models (Table 6)
***1b: All UN Ideal + LowDepend + LowCIE Models (Table 7)
***1c: All UN Affinity + LowDepend + LowCIE Models (Table 8)
***Mixed_a: All Mixed Models (Table 9)
***Sandwich_a: All Sandwich Models (Table 10)

clear
set more off
cd $dir

use PoznanskyScroggsISQ.dta, clear

**UN Affinity + LowDepend

*Polity Joint

logit mct polyprod lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu, cluster(dyad_id)

outreg2 using ISQ_Note_Append1a, tex(frag) replace

margins, at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Full Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointFullAppend1a, replace

firthlogit mct polyprod lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu

outreg2 using ISQ_Note_Append1a, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Firth Corrected Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointFirthAppend1a, replace

logit mct polyprod lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Append1a, tex(frag) append

margins, at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Politically Relevant Dyads") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointPolRevAppend1a, replace

firthlogit mct polyprod lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1

outreg2 using ISQ_Note_Append1a, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Politically Relevant Dyads w/ Firth Correction") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointFirthPolRevAppend1a, replace

gr combine "PolityJointFullAppend1a" "PolityJointFirthAppend1a" "PolityJointPolRevAppend1a" "PolityJointFirthPolRevAppend1a", title("Marginal Effect of Democracy, PolityJoint Measure")

graph save PolityJointCombinedAppend1a, replace

*Polity Low

logit mct polity_low lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu, cluster(dyad_id)

outreg2 using ISQ_Note_Append1a, tex(frag) append

margins, at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Full Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowFullAppend2a, replace

firthlogit mct polity_low lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu

outreg2 using ISQ_Note_Append1a, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Firth Corrected Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowFirthAppend2a, replace

logit mct polity_low lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Append1a, tex(frag) append

margins, at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Politically Relevant Dyads") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowPolRevAppend2a, replace

firthlogit mct polity_low lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1

outreg2 using ISQ_Note_Append1a, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Politically Relevant Dyads w/ FirthCorrection") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowFirthPolRevAppend2a, replace

gr combine "PolityLowFullAppend2a" "PolityLowFirthAppend2a" "PolityLowPolRevAppend2a" "PolityLowFirthPolRevAppend2a", title("Marginal Effect of Democracy, PolityLow Measure")

graph save PolityLowCombinedAppend2a, replace

*Polity Both

logit mct polity_both lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu, cluster(dyad_id)

outreg2 using ISQ_Note_Append1a, tex(frag) append

margins, at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Full Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothFullAppend3a, replace

firthlogit mct polity_both lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu

outreg2 using ISQ_Note_Append1a, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Firth Correction") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothFirthAppend3a, replace

logit mct polity_both lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Append1a, tex(frag) append

margins, at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Politically Relevant Dyads") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothPolRevAppend3a, replace

firthlogit mct polity_both lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1

outreg2 using ISQ_Note_Append1a, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Politically Relevant Dyads w/ Firth Correction") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothFirthPolRevAppend3a, replace

gr combine "PolityBothFullAppend3a" "PolityBothFirthAppend3a" "PolityBothFirthPolRevAppend3a", title("Marginal Effect of Democracy, PolityBoth Measure")

graph save PolityBothCombinedAppend3a, replace

*Mixed Models

meqrlogit mct polyprod lowdpnd cincratio alliance1 UN_affinity2 time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle

outreg2 using ISQ_Note_Mixed_a, tex(frag) replace

margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("PolityJoint - Mixed Effects Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointMixedAppend1a, replace

meqrlogit mct polity_low lowdpnd cincratio alliance1 UN_affinity2 time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle

outreg2 using ISQ_Note_Mixed_a, tex(frag) replace

margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("PolityLow - Mixed Effects") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowMixedAppend1b, replace

meqrlogit mct polity_both lowdpnd cincratio alliance1 UN_affinity2 time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle

outreg2 using ISQ_Note_Mixed_a, tex(frag) replace

margins, expression(1/(1+exp(-predict(xb)))) at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("PolityBoth - Mixed Effects") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothMixedAppend1c, replace

**UN Ideal + LowDepend + LowCIE

*Polity Joint

logit mct polyprod lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu, cluster(dyad_id)

outreg2 using ISQ_Note_Append1b, tex(frag) replace

margins, at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Full Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointFullAppend1b, replace

firthlogit mct polyprod lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu

outreg2 using ISQ_Note_Append1b, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Firth Corrected Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointFirthAppend1b, replace

logit mct polyprod lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Append1b, tex(frag) append

margins, at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Politically Relevant Dyads") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointPolRevAppend1b, replace

firthlogit mct polyprod lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1

outreg2 using ISQ_Note_Append1b, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Politically Relevant Dyads w/ Firth Correction") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointFirthPolRevAppend1b, replace

gr combine "PolityJointFullAppend1b" "PolityJointFirthAppend1b" "PolityJointPolRevAppend1b" "PolityJointFirthPolRevAppend1b", title("Marginal Effect of Democracy, PolityJoint Measure")

graph save PolityJointCombinedAppend1b, replace

*Polity Low

logit mct polity_low lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu, cluster(dyad_id)

outreg2 using ISQ_Note_Append1b, tex(frag) append

margins, at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Full Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowFullAppend20b, replace

firthlogit mct polity_low lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu

outreg2 using ISQ_Note_Append1b, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Firth Corrected Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowFirthAppend20b, replace

logit mct polity_low lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Append1b, tex(frag) append

margins, at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Politically Relevant Dyads") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowPolRevAppend20b, replace

firthlogit mct polity_low lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1

outreg2 using ISQ_Note_Append1b, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Politically Relevant Dyads w/ FirthCorrection") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowFirthPolRevAppend20b, replace

gr combine "PolityLowFullAppend20b" "PolityLowFirthAppend20b" "PolityLowPolRevAppend20b" "PolityLowFirthPolRevAppend20b", title("Marginal Effect of Democracy, PolityLow Measure")

graph save PolityLowCombinedAppend20b, replace

*Polity Both

logit mct polity_both lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu, cluster(dyad_id)

outreg2 using ISQ_Note_Append1b, tex(frag) append

margins, at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Full Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothFullAppend30b, replace

firthlogit mct polity_both lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu

outreg2 using ISQ_Note_Append1b, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Firth Correction") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothFirthAppend30b, replace

logit mct polity_both lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Append1b, tex(frag) append

margins, at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Politically Relevant Dyads") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothPolRevAppend30b, replace

firthlogit mct polity_both lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1

outreg2 using ISQ_Note_Append1b, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Politically Relevant Dyads w/ Firth Correction") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothFirthPolRevAppend30b, replace

gr combine "PolityBothFullAppend30b" "PolityBothFirthAppend30b" "PolityBothFirthPolRevAppend30b", title("Marginal Effect of Democracy, PolityBoth Measure")

graph save PolityBothCombinedAppend30b, replace

*Mixed Models

meqrlogit mct polyprod lowdpnd lowCIE cincratio alliance1 absidealdiff time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle

outreg2 using ISQ_Note_Mixed_a, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("PolityJoint - Mixed Effects Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointMixedAppend2a, replace

meqrlogit mct polity_low lowdpnd lowCIE cincratio alliance1 absidealdiff time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle

outreg2 using ISQ_Note_Mixed_a, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("PolityLow - Mixed Effects") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowMixedAppend20b, replace

meqrlogit mct polity_both lowdpnd lowCIE cincratio alliance1 absidealdiff time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle

outreg2 using ISQ_Note_Mixed_a, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("PolityBoth - Mixed Effects") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothMixedAppend20c, replace

**UN Affinity + LowDepend + LowCIE

*Polity Joint

logit mct polyprod lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu, cluster(dyad_id)

outreg2 using ISQ_Note_Append1c, tex(frag) replace

margins, at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Full Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointFullAppend1c, replace

firthlogit mct polyprod lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu

outreg2 using ISQ_Note_Append1c, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Firth Corrected Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointFirthAppend1c, replace

logit mct polyprod lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Append1c, tex(frag) append

margins, at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Politically Relevant Dyads") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointPolRevAppend1c, replace

firthlogit mct polyprod lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1

outreg2 using ISQ_Note_Append1c, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("Politically Relevant Dyads w/ Firth Correction") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointFirthPolRevAppend1c, replace

gr combine "PolityJointFullAppend1c" "PolityJointFirthAppend1c" "PolityJointPolRevAppend1c" "PolityJointFirthPolRevAppend1c", title("Marginal Effect of Democracy, PolityJoint Measure")

graph save PolityJointCombinedAppend1c, replace

*Polity Low

logit mct polity_low lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu, cluster(dyad_id)

outreg2 using ISQ_Note_Append1c, tex(frag) append

margins, at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Full Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowFullAppend20c, replace

firthlogit mct polity_low lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu

outreg2 using ISQ_Note_Append1c, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Firth Corrected Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowFirthAppend20c, replace

logit mct polity_low lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Append1c, tex(frag) append

margins, at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Politically Relevant Dyads") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowPolRevAppend20c, replace

firthlogit mct polity_low lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1

outreg2 using ISQ_Note_Append1c, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("Politically Relevant Dyads w/ FirthCorrection") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowFirthPolRevAppend20c, replace

gr combine "PolityLowFullAppend20c" "PolityLowFirthAppend20c" "PolityLowPolRevAppend20c" "PolityLowFirthPolRevAppend20c", title("Marginal Effect of Democracy, PolityLow Measure")

graph save PolityLowCombinedAppend20c, replace

*Polity Both

logit mct polity_both lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu, cluster(dyad_id)

outreg2 using ISQ_Note_Append1c, tex(frag) append

margins, at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Full Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothFullAppend30c, replace

firthlogit mct polity_both lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu

outreg2 using ISQ_Note_Append1c, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Firth Correction") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothFirthAppend30c, replace

logit mct polity_both lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Append1c, tex(frag) append

margins, at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Politically Relevant Dyads") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothPolRevAppend30c, replace

firthlogit mct polity_both lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1

outreg2 using ISQ_Note_Append1c, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("Politically Relevant Dyads w/ Firth Correction") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothFirthPolRevAppend30c, replace

gr combine "PolityBothFullAppend30c" "PolityBothFirthAppend30c" "PolityBothPolRevAppend30c" "PolityBothFirthPolRevAppend30c", title("Marginal Effect of Democracy, PolityBoth Measure")

graph save PolityBothCombinedAppend30c, replace

*Mixed Models

meqrlogit mct polyprod lowdpnd lowCIE cincratio alliance1 UN_affinity2 time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle

outreg2 using ISQ_Note_Mixed_a, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(0(10)100))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Joint Democracy") title("PolityJoint - Mixed Effects Model") scheme(s2mono) graphregion(fcolor(white))

graph save PolityJointMixedAppend3a, replace

meqrlogit mct polity_low lowdpnd lowCIE cincratio alliance1 UN_affinity2 time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle

outreg2 using ISQ_Note_Mixed_a, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-10(2)10))

marginsplot, recast(line) recastci(rarea) ytitle("Probability of MCT") xtitle("Lowest Democracy") title("PolityLow - Mixed Effects") scheme(s2mono) graphregion(fcolor(white))

graph save PolityLowMixedAppend30b, replace

meqrlogit mct polity_both lowdpnd lowCIE cincratio alliance1 UN_affinity2 time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle

outreg2 using ISQ_Note_Mixed_a, tex(frag) append

margins, expression(1/(1+exp(-predict(xb)))) at(polity_both=(0 1))

marginsplot, ytitle("Probability of MCT") xtitle("Democratic Dyads") title("PolityBoth - Mixed Effects") scheme(s2mono) graphregion(fcolor(white))

graph save PolityBothMixedAppend30c, replace

*Sandwich Models

logit mct polyprod lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Sandwich1a, tex(frag) replace

logit mct polyprod lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Sandwich1a, tex(frag) append

logit mct polyprod lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Sandwich1a, tex(frag) append

logit mct polity_low lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Sandwich1a, tex(frag) append

logit mct polity_low lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Sandwich1a, tex(frag) append

logit mct polity_low lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Sandwich1a, tex(frag) append

logit mct polity_both lowdpnd cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Sandwich1a, tex(frag) append

logit mct polity_both lowdpnd lowCIE cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Sandwich1a, tex(frag) append

logit mct polity_both lowdpnd lowCIE cincratio alliance1 UN_affinity2 conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)

outreg2 using ISQ_Note_Sandwich1a, tex(frag) append

