*Analysis for "Intergovernmental Organizations and Interstate Conflict: Parsing Out IGO Effects for Alternative Dimensions of Conflict in Post-Communist Space."
*ISQ, completed in November 2008.
*The commands in this file will replicate the analysis in the article.
*They should be run on the Stata file 'FV_ISQ.dta'.

*Models for Table 2:
*for all conflict model [1]:
nbreg Count_sum lagCount russia cap atop_ally ab_ungadiff mingdp100 distance10 dyadmin_p4demo0 loglagT, robust cluster(dyadid_max)

*for low severity conflict model [2]:
nbreg low68 laglow high22 russia cap atop_ally  ab_ungadiff mingdp100 distance10 dyadmin_p4demo0 loglagT, robust cluster(dyadid_max)

*for high severity conflict model[3]:
nbreg high22 laghigh low68 russia cap atop_ally ab_ungadiff mingdp100 distance10 dyadmin_p4demo0 loglagT, robust cluster(dyadid_max)
