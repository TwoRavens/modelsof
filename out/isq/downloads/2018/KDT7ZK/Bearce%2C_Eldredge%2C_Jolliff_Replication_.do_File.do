*to estimate the high definition fixed effects models in this paper, we used reghdfe.  Users may need to install this stata program first.
*findit reghdfe

*load the dataset: ISQreplicationdataset.dta
*run the sequence of commands below

*Table 1
*model1
reghdfe lnImports GATTWTO PTA, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)
*model 2
reghdfe lnImports GATTWTO PTA PTADepth PlurilateralPTA PTADSM PTAEscape PTARestrictions PTARestrictions2, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)
*model 3
reghdfe lnImports GATTWTO PTA PTADepth, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)
*model 4
reghdfe lnImports GATTWTO PTA PlurilateralPTA, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)
*model 5
reghdfe lnImports GATTWTO PTA PTADSM, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)
*model 6
reghdfe lnImports GATTWTO PTA PTAEscape PTARestrictions PTARestrictions2, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)

*Table 2
sum PTADepth PlurilateralPTA PTADSM PTAEscape PTARestrictions PTARestrictions2 if PTA==1

*Table 3
corr PTADepth PlurilateralPTA PTADSM PTAEscape PTARestrictions PTARestrictions2 if PTA==1

*Figure 3
*rerun model 2
reghdfe lnImports GATTWTO PTA PTADepth PlurilateralPTA PTADSM PTAEscape PTARestrictions PTARestrictions2, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)
*the dashed horizontal lines come from the PTAEscape coefficient above and the marginal effect (plus confidence intervals) come from the lincom commands below 
lincom  (0*PTARestrictions) + (0*PTARestrictions2)
lincom  (1*PTARestrictions) + (1*PTARestrictions2)
lincom  (2*PTARestrictions) + (4*PTARestrictions2)
lincom  (3*PTARestrictions) + (9*PTARestrictions2)
lincom  (4*PTARestrictions) + (16*PTARestrictions2)
lincom  (5*PTARestrictions) + (25*PTARestrictions2)
lincom  (6*PTARestrictions) + (36*PTARestrictions2)
lincom  (7*PTARestrictions) + (49*PTARestrictions2)
lincom  (8*PTARestrictions) + (64*PTARestrictions2)
lincom  (9*PTARestrictions) + (81*PTARestrictions2)
lincom  (10*PTARestrictions) + (100*PTARestrictions2)
lincom  (11*PTARestrictions) + (121*PTARestrictions2)
lincom  (12*PTARestrictions) + (144*PTARestrictions2)
lincom  (13*PTARestrictions) + (169*PTARestrictions2)
lincom  (14*PTARestrictions) + (196*PTARestrictions2)
lincom  (15*PTARestrictions) + (225*PTARestrictions2)

*Table 5
*model 7
reghdfe lnImports GATTWTO PTA PTADepth PlurilateralPTA PTADSM PTAEscape PTARestrictions PTARestrictions2 if PTA==1, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)
*model 8
reghdfe lnImports GATTWTO PTA PTADepth if PTA==1, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)
*model 9
reghdfe lnImports GATTWTO PTA PlurilateralPTA if PTA==1, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)
*model 10
reghdfe lnImports GATTWTO PTA PTADSM if PTA==1, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)
*model 11
reghdfe lnImports GATTWTO PTA PTAEscape PTARestrictions PTARestrictions2 if PTA==1, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)

*Figure 4 
*rerun model 7
reghdfe lnImports GATTWTO PTA PTADepth PlurilateralPTA PTADSM PTAEscape PTARestrictions PTARestrictions2 if PTA==1, absorb (Dyad ImporterYear ExporterYear) vce(cluster Dyad)
*the dashed horizontal lines come from the PTAEscape coefficient above and the marginal effect (plus confidence intervals) come from the lincom commands below 
lincom  (0*PTARestrictions) + (0*PTARestrictions2)
lincom  (1*PTARestrictions) + (1*PTARestrictions2)
lincom  (2*PTARestrictions) + (4*PTARestrictions2)
lincom  (3*PTARestrictions) + (9*PTARestrictions2)
lincom  (4*PTARestrictions) + (16*PTARestrictions2)
lincom  (5*PTARestrictions) + (25*PTARestrictions2)
lincom  (6*PTARestrictions) + (36*PTARestrictions2)
lincom  (7*PTARestrictions) + (49*PTARestrictions2)
lincom  (8*PTARestrictions) + (64*PTARestrictions2)
lincom  (9*PTARestrictions) + (81*PTARestrictions2)
lincom  (10*PTARestrictions) + (100*PTARestrictions2)
lincom  (11*PTARestrictions) + (121*PTARestrictions2)
lincom  (12*PTARestrictions) + (144*PTARestrictions2)
lincom  (13*PTARestrictions) + (169*PTARestrictions2)
lincom  (14*PTARestrictions) + (196*PTARestrictions2)
lincom  (15*PTARestrictions) + (225*PTARestrictions2)
