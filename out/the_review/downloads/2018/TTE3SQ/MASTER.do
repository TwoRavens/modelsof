*** Replication materials for:
*** Fiva, Jon H. and Smith, Daniel M.
*** "Political Dynasties and the Incumbency Advantage in Party-Centered Environments"
*** American Political Science Review

/* the following packages needs to be installed */
*net install rddensity, from(https://sites.google.com/site/rdpackages/rddensity/stata) replace
*net install rdrobust, from(https://sites.google.com/site/rdpackages/rdrobust/stata) replace
*ssc install estout
*ssc install xtbalance
*ssc install binscatter
*ssc install sutex
*DCdensity.ado should be put in your ado directory. To find out where this is, issue -sysdir- at the Stata prompt. DCdensity.ado is available at http://eml.berkeley.edu/~jmccrary/DCdensity/
*Depending on your OS, you may need to replace \ with / in file directory names

local path = "C:\Users\A0910846\Dropbox\FivaSmithAPSR"
cd `path'
cap mkdir "`path'\tables"
cap mkdir "`path'\estimates"
cap mkdir "`path'\figures"
cap mkdir "`path'\figures\gph"

*******************************
****** DATA PREPARATION *******
*******************************
run do\DataPrep  /* Data preparation based on FivaSmith data set */
run do\ImportNorwayMPs /* Importing NSD data on verified family ties */
run do\DynastyPanel  /* Creating panel for dynasty analysis */

*******************************
****** ANALYSIS ***************
*******************************
run do\_Figure1      /* Norway vs US */
run do\_Figure2      /* main rd plots */
run do\_Table1       /* RD analysis - typeset manually */
run do\CalculationInText  /* About half (48\%) of the senior members of dynasties in our full sample are never close enough to the cut-off for winning or losing a seat to be included in our estimation sample. */

******** APPENDIX A ***************
run do\_FigureA1      /* Trend in party seat shares */
run do\_FigureA2      /* Trend in mpsucceed by party */
run do\_FigureA3      /* Number of candidates by election year. */
run do\_FigureA4      /* Fraction of MPs succeeded by family member, 1945-2013.*/
run do\_FigureA5      /* Frequency of observations as a function of rank distance to marginally elected */
run do\_FigureA6      /* Distance to seat threshold [win margin] for marginal candidates. */
run do\_FigureA7      /* McCrary density test */
run do\_FigureA8      /* Additional RD plots - deputy, ever deputy/mp, terms served (excl. deputy), terms served (incl.deputy) */
run do\_FigureA9      /* rd plot downstream elections */
run do\_FigureA10     /* rd plot previous elections */
run do\_FigureA11     /* rd plot re-nomination */
run do\_FigureA12     /* Robustness of RD results to alternative bandwidths. */
run do\_FigureA13     /* sample: never previously marginal or elected */
run do\_FigureA14     /* sample: never previously hopeless, marginal or elected */
run do\_FigureA15       /* rd plot on occupation covariates [balance test] */

run do\_TableA1        /* OLS regression estimates of terms served, first-ranked, and cabinet experience. */
run do\_TableA2        /* Descriptives OLS */
run do\_TableA3        /* Descriptives RD */
run do\_TableA4        /* Fuzzy RD */

******** APPENDIX B ***************
run do\_FigureB1       /* Probability of (proxy) family member running, by common surnames */
run do\_FigureB2       /* RD plots using proxy family ties. */
run do\_TableB1       /* RD estimates using proxy family ties. */

