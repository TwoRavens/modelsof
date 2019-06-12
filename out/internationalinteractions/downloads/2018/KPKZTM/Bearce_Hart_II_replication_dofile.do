*The results in the paper were run using Stata13.

*data for Figure 1, which includes only the countries with a complete 1995-2016 times-series
sort year
by year: sum ImmigrantRights if ccode~=155 & ccode~=366 & ccode~=666 & ccode~=367 & ccode~=368 & ccode~=920 & ccode~=365 & ccode~=349 & ccode~=640
*data for Figure 2, which also includes only the countries with a complete 1995-2016 times-series
by year: sum ImmigrationOpenness if ccode~=155 & ccode~=366 & ccode~=666 & ccode~=367 & ccode~=368 & ccode~=920 & ccode~=365 & ccode~=349 & ccode~=640

*Table 1 Validation Tests
xtset ccode year
*model 1.1
xtreg Immigration                 ImmigrationOpenness ImmigrantRights, fe cluster (ccode)
*model 1.2
xtreg OrtegaPeriOpenness          ImmigrationOpenness ImmigrantRights, fe cluster (ccode)
*model 1.3
xtreg MIPEX                       ImmigrationOpenness ImmigrantRights, fe cluster (ccode)
*model 1.4
xtreg MulticulturalismPolicyIndex ImmigrationOpenness ImmigrantRights, fe cluster (ccode)

*Table 2 Descriptive Statistics
sum ImmigrationOpenness ImmigrantRights Population UrbanPop MigrantPop GDPpcGrowth LeftExec RightExec EU

*Table 3: Estimates of Immigration Openness
*model 3.1
xtreg ImmigrationOpenness ImmigrantRights Population UrbanPop MigrantPop GDPpcGrowth LeftExec RightExec EU , fe cluster (ccode)
*model 3.2
xtreg ImmigrationOpenness l.ImmigrationOpenness ImmigrantRights Population UrbanPop MigrantPop GDPpcGrowth LeftExec RightExec EU , fe cluster (ccode)
*model 3.3
xtreg d.ImmigrationOpenness l.ImmigrationOpenness d.ImmigrantRights l.ImmigrantRights d.Population l.Population d.UrbanPop l.UrbanPop d.MigrantPop l.MigrantPop d.GDPpcGrowth l.GDPpcGrowth d.LeftExec l.LeftExec d.RightExec l.RightExec d.EU l.EU, fe cluster (ccode)
*calculating the Immigrant Rights LRM for model 3.3
nlcom _b[l.ImmigrantRights]/ abs(_b[l.ImmigrationOpenness])

*Table 4: Estimates of Immigrant Rights
*model 4.1
xtreg ImmigrantRights ImmigrationOpenness Population UrbanPop MigrantPop GDPpcGrowth LeftExec RightExec EU , fe cluster (ccode)
*model 4.2
xtreg ImmigrantRights l.ImmigrantRights ImmigrationOpenness Population UrbanPop MigrantPop GDPpcGrowth LeftExec RightExec EU , fe cluster (ccode)
*model 4.3
xtreg d.ImmigrantRights l.ImmigrantRights d.ImmigrationOpenness l.ImmigrationOpenness d.Population l.Population d.UrbanPop l.UrbanPop d.MigrantPop l.MigrantPop d.GDPpcGrowth l.GDPpcGrowth d.LeftExec l.LeftExec d.RightExec l.RightExec d.EU l.EU, fe cluster (ccode)
*calculating the Immigration Openness LRM for model 4.3
nlcom _b[l.ImmigrationOpenness]/ abs(_b[l.ImmigrantRights])

*Appendix A: data for category/ # more liberal/ # less liberal table  
*calculating category change measures
gen dLegalProtectionsRights=d.LegalProtectionsRight
gen dSocialCivicIntegration=d.SocialCivicIntegration
gen dFamilyResidencyWork=d.FamilyResidencyWork
gen dNaturalizationCitizenship=d.NaturalizationCitizenship
gen dNumericalQuotas=d.NumericalQuota
gen dLaborMarketTests=d.LaborMarketTests
gen dTransactionCosts=d.TransactionCosts
gen dOtherExternal=d.OtherExternal
*The information below provides the values used in the table. Note that since more liberal changes are coded as +1 and less liberal as -1, numbers with an absolute value greater than 1 indicate multiple changes in that direction
tab dLegalProtectionsRights 
tab dSocialCivicIntegration 
tab dFamilyResidencyWork 
tab dNaturalizationCitizenship 
tab dNumericalQuotas 
tab dLaborMarketTests 
tab dTransactionCosts 
tab dOtherExternal
*getting rid of these excess variables
drop dLegalProtectionsRights dSocialCivicIntegration dFamilyResidencyWork dNaturalizationCitizenship dNumericalQuotas dLaborMarketTests dTransactionCosts dOtherExternal

*Appendix B: data for the country graphs
plot ImmigrantRights ImmigrationOpenness year if country=="Australia"
plot ImmigrantRights ImmigrationOpenness year if country=="Austria"
plot ImmigrantRights ImmigrationOpenness year if country=="Belgium"
plot ImmigrantRights ImmigrationOpenness year if country=="Bulgaria"
plot ImmigrantRights ImmigrationOpenness year if country=="Canada"
plot ImmigrantRights ImmigrationOpenness year if country=="Chile"
plot ImmigrantRights ImmigrationOpenness year if country=="Czech Republic"
plot ImmigrantRights ImmigrationOpenness year if country=="Denmark"
plot ImmigrantRights ImmigrationOpenness year if country=="Estonia"
plot ImmigrantRights ImmigrationOpenness year if country=="Finland"
plot ImmigrantRights ImmigrationOpenness year if country=="France"
plot ImmigrantRights ImmigrationOpenness year if country=="Germany"
plot ImmigrantRights ImmigrationOpenness year if country=="Greece"
plot ImmigrantRights ImmigrationOpenness year if country=="Hungary"
plot ImmigrantRights ImmigrationOpenness year if country=="Ireland"
plot ImmigrantRights ImmigrationOpenness year if country=="Israel"
plot ImmigrantRights ImmigrationOpenness year if country=="Italy"
plot ImmigrantRights ImmigrationOpenness year if country=="Japan"
plot ImmigrantRights ImmigrationOpenness year if country=="Korea"
plot ImmigrantRights ImmigrationOpenness year if country=="Latvia"
plot ImmigrantRights ImmigrationOpenness year if country=="Lithuania"
plot ImmigrantRights ImmigrationOpenness year if country=="Luxembourg"
plot ImmigrantRights ImmigrationOpenness year if country=="Mexico"
plot ImmigrantRights ImmigrationOpenness year if country=="Netherlands"
plot ImmigrantRights ImmigrationOpenness year if country=="New Zealand"
plot ImmigrantRights ImmigrationOpenness year if country=="Norway"
plot ImmigrantRights ImmigrationOpenness year if country=="Poland"
plot ImmigrantRights ImmigrationOpenness year if country=="Portugal"
plot ImmigrantRights ImmigrationOpenness year if country=="Romania"
plot ImmigrantRights ImmigrationOpenness year if country=="Russia"
plot ImmigrantRights ImmigrationOpenness year if country=="Slovakia"
plot ImmigrantRights ImmigrationOpenness year if country=="Slovenia"
plot ImmigrantRights ImmigrationOpenness year if country=="Spain"
plot ImmigrantRights ImmigrationOpenness year if country=="Sweden"
plot ImmigrantRights ImmigrationOpenness year if country=="Switzerland"
plot ImmigrantRights ImmigrationOpenness year if country=="Turkey"
plot ImmigrantRights ImmigrationOpenness year if country=="USA"
plot ImmigrantRights ImmigrationOpenness year if country=="UK"

