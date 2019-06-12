use "APSR Data (Democracy at Work).dta"


*Table 1, Model 1

xtnbreg infantmortality voluntarycouncilcommitment psfcoverage bfcoverage bfmanagement competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages, fe

*Table 1, Model 2 

xtnbreg infantmortality healthcouncilmeetings psfcoverage bfcoverage bfmanagement competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages, fe

*Table 1(a) 

xtnbreg infantmortality healthcouncil psfcoverage bfcoverage bfmanagement competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages, fe


*Table 2, Model 1

xtnbreg infantmortality councilfhpinteraction voluntarycouncilcommitment fhpcoveragedummy bfcoverage  bfmanagement competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages, fe

*Table 2, Models 2-4

xtnbreg infantmortality councilfhpinteraction voluntarycouncilcommitment fhpcoveragedummy bfcoverage  bfmanagement competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages  if voluntarycouncilcommitment==0, fe

xtnbreg infantmortality councilfhpinteraction voluntarycouncilcommitment fhpcoveragedummy bfcoverage  bfmanagement competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages if fhpcoveragedummy==0, fe

xtnbreg infantmortality councilfhpinteraction voluntarycouncilcommitment fhpcoveragedummy bfcoverage  bfmanagement competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages if fhpcoveragedummy==0&voluntarycouncilcommitment==0, fe


robustness checks
 

* Table 1 (b): count of the councils, rather than the "commitment" variable
 xtnbreg infantmortality councilcount psfcoverage bfcoverage bfmanagement competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages, fe

*count of health council meetings, rather than dummy

xtnbreg infantmortality healthcouncilmeetings bfcoverage psfcoverage bfmanagement ptmayor competitivemayor percapitahealthspending lowincomewages presidentialvote, fe

 
 
 *Table 1 (c): different specifications for the mayoral competition variables:
xtnbreg infantmortality voluntarycouncilcommitment psfcoverage bfcoverage bfmanagement mayoralvoteshare  ptmayor presidentialvote percapitahealthspending lowincomewages, fe

xtnbreg infantmortality voluntarycouncilcommitment psfcoverage bfcoverage bfmanagement nocompetition  ptmayor presidentialvote percapitahealthspending lowincomewages, fe

*Table 1 (d): Lagged DV

xtnbreg infantmortality L.infantmortality voluntarycouncilcommitment psfcoverage bfcoverage bfmanagement competitivemayor ptmayor presidentialvote percapitahealthspendingp lowincomewages 

*Table 1 (e): This model uses per capita municipal spending instead of health spending

xtnbreg infantmortality voluntarycouncilcommitment psfcoverage bfcoverage bfmanagement ptmayor competitivemayor presidentialvote percapitamunicspending lowincomewages, fe

*Table 1 (f): this model uses geographic dummies- NE is the omitted category

xtnbreg infantmortality voluntarycouncilcommitment psfcoverage bfcoverage bfmanagement ptmayor competitivemayor presidentialvote percapitahealthspending lowincomewages north south southeast centerwest, fe


*Table 1 (g): this model removes the BF management variable for broader coverage

xtnbreg infantmortality voluntarycouncilcommitment psfcoverage bfcoverage competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages , fe


*Table 1 (h): systematic underreporting of poverty and disparities in measurement across Brazilian agencies leads to BF and PSF coverage scores that can exceed 100.
*nevertheless, the following model removes those potentially-implausible values

xtnbreg infantmortality voluntarycouncilcommitment psfcoveragenooutlier bfcoveragenooutliers bfmanagement competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages, fe

*Table 1 (i) these models present Arellano-Bond estimates of Infant Mortality by Tercile 

xtabond infantmortality voluntarycouncilcommitment psfcoverage bfcoverage bfmanagement  competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages if tercile==1, lags(2) vce(robust) artests(2)

*most of the variables are statistically significant for the lowest tercile of infant mortality as they are in the full dataset. BF coverage is significant and POSITIVE

xtabond infantmortality psfcoverage bfcoverage bfmanagement voluntarycouncilcommitment competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages if tercile==2, lags(2) vce(robust) artests(2)

*most of the variables are statistically significant for the second (middle) tercile of infant mortality as they are in the full dataset. PSF coverage is not significant

xtabond infantmortality psfcoverage bfcoverage bfmanagement voluntarycouncilcommitment competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages if tercile==3, lags(2) vce(robust) artests(2)

*IGD and psf coverage are significant and POSITIVE in the third tercile, but not the other two. 
*the results of estimating relationships across terciles suggest that participation is important across the board, but that the other variables are unpredictable across terciles-
*they work the way we hypothesize in municipalities with lower infant mortality...in some ways this is encouraging because one would think it would be more difficult to reduce infant mortality as infant mortality decreases
*instead, it seems to be more difficult to change mortality in places where mortality is higher.  

xtnbreg infantmortality logmeetings psfcoverage bfcoverage bfmanagement ptmayor competitivemayor presidentialvote percapitahealthspending lowincomewages if tercile==3, fe


*Table 1 (j) this model uses year dummies with Arellano-Bond dynamic panel estimation

xtabond infantmortality psfcoverage bfcoverage bfmanagement voluntarycouncilcommitment competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14, lags(2) vce(robust) artests(2)

 
*Table 1 (k) this model uses treatment effects matching (nearest neighbor)

teffects nnmatch (infantmortality psfcoverage bfcoverage bfmanagement competitivemayor presidentialvote percapitahealthspending lowincomewages) (voluntarycouncilcommitment)


*Table 1 (l) this model uses difference in difference- only council commitment is signficant

xtreg d.infantmortality d.voluntarycouncilcommitment d.psfcoverage d.bfcoverage d.bfmanagement d.ptmayor d.competitivemayor d.presidentialvote d.percapitahealthspending d.lowincomewages, robust

*Table 1 (m): this model uses cross-sectional time-series ols with clustered SEs

xtreg infantmortality voluntarycouncilcommitment psfcoverage bfcoverage bfmanagement competitivemayor ptmayor presidentialvote percapitahealthspending lowincomewages, fe cluster(munic1)
