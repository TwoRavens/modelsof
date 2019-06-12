******************************************************************************
*                                                                            *
* Michael Poznansky and Matt K. Scroggs                                      *
* "Ballots and Blackmail: Coercive Bargaining and the Democratic Peace"      *
* International Studies Quarterly                                            *
*                                                                            *
******************************************************************************


* Purpose
* This Stata do file walks through the process of performing the post-estimation tests performed in the article, noting which tables and pages they are.
*
* https://dataverse.harvard.edu/dataverse/mkscroggs
*
* Version 1.0
* Last updated: January 15, 2016

*Post-Estimation Tests

*Table 11

logit mct polyprod lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu, cluster(dyad_id)
margins, at(polyprod=(30 50 75)) post coeflegend
test _b[1bn._at]=_b[2._at] // Pr(MCT) 1989 vs. 1990
test _b[1bn._at]=_b[3._at] // Pr(MCT) 1989 vs. 1991
test _b[2._at]=_b[3._at] // Pr(MCT) 1990 vs. 1991

firthlogit mct polyprod lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu
margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(30 50 75)) post coeflegend
test _b[1bn._at]=_b[2._at] // Pr(MCT) 1989 vs. 1990
test _b[1bn._at]=_b[3._at] // Pr(MCT) 1989 vs. 1991
test _b[2._at]=_b[3._at] // Pr(MCT) 1990 vs. 1991

logit mct polyprod lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)
margins, at(polyprod=(30 50 75)) post coeflegend
test _b[1bn._at]=_b[2._at] // Pr(MCT) 1989 vs. 1990
test _b[1bn._at]=_b[3._at] // Pr(MCT) 1989 vs. 1991
test _b[2._at]=_b[3._at] // Pr(MCT) 1990 vs. 1991

firthlogit mct polyprod lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1
margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(30 50 75)) post coeflegend
test _b[1bn._at]=_b[2._at] // Pr(MCT) 1989 vs. 1990
test _b[1bn._at]=_b[3._at] // Pr(MCT) 1989 vs. 1991
test _b[2._at]=_b[3._at] // Pr(MCT) 1990 vs. 1991

meqrlogit mct polyprod lowdpnd cincratio alliance1 absidealdiff time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle
margins, expression(1/(1+exp(-predict(xb)))) at(polyprod=(30 50 75)) post coeflegend
test _b[1bn._at]=_b[2._at] // Pr(MCT) 1989 vs. 1990
test _b[1bn._at]=_b[3._at] // Pr(MCT) 1989 vs. 1991
test _b[2._at]=_b[3._at] // Pr(MCT) 1990 vs. 1991

*Table 12

logit mct polity_low lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu, cluster(dyad_id)
margins, at(polity_low=(-3 5)) post coeflegend
test _b[1bn._at]=_b[2._at]  // Pr(MCT) 2008 vs. 2009

firthlogit mct polity_low lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu
margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-3 5)) post coeflegend
test _b[1bn._at]=_b[2._at]  // Pr(MCT) 2008 vs. 2009

logit mct polity_low lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)
margins, at(polity_low=(-3 5)) post coeflegend
test _b[1bn._at]=_b[2._at]  // Pr(MCT) 2008 vs. 2009

firthlogit mct polity_low lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1
margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-3 5)) post coeflegend
test _b[1bn._at]=_b[2._at]  // Pr(MCT) 2008 vs. 2009

*Polity Both, pg. 17

logit mct polity_both lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu, cluster(dyad_id)
margins, at(polity_both=(0 1)) post coeflegend
test _b[1bn._at]=_b[2._at]  // tests prob at cd4=0 vs prob at cd4=1

firthlogit mct polity_both lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu
margins, at(polity_both=(0 1)) post coeflegend
test _b[1bn._at]=_b[2._at]  // tests prob at cd4=0 vs prob at cd4=1

logit mct polity_both lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1, cluster(dyad_id)
margins, at(polity_both=(0 1)) post coeflegend
test _b[1bn._at]=_b[2._at]  // tests prob at cd4=0 vs prob at cd4=1

firthlogit mct polity_both lowdpnd cincratio alliance1 absidealdiff conttype2 time time_sq time_cu if polrev==1
margins, at(polity_both=(0 1)) post coeflegend
test _b[1bn._at]=_b[2._at]  // tests prob at cd4=0 vs prob at cd4=1

meqrlogit mct polity_both lowdpnd cincratio alliance1 absidealdiff time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle
margins, at(polity_both=(0 1)) post coeflegend

meqrlogit mct polity_low lowdpnd cincratio alliance1 absidealdiff time time_sq time_cu if polrev==1 || ccode1: || ccode2:|| dyad_id:, mle
margins, expression(1/(1+exp(-predict(xb)))) at(polity_low=(-3 5)) post coeflegend
test _b[1bn._at]=_b[2._at]  // tests prob at cd4=0 vs prob at cd4=1
