*******TABLE 1. T-tests and treatment effects of In-Party evaluations, by Information Group

*In-Party Cand FT
*News Articles:
ttest IPCandFT if Groups==1, by(FemCand)

*Minimal Dynamic Board
ttest IPCandFT if Groups==2, by(FemCand)

*Static Board:
ttest IPCandFT if Groups==3, by(FemCand)

*Maximum Dynamic Board
ttest IPCandFT if Groups==4, by(FemCand)

*IPCandLibCon for Republicans
*News Articles:
ttest IPCandLibCon if Groups==1 & Republican==1, by(FemCand)

*Minimal Dynamic Board
ttest IPCandLibCon if Groups==2 & Republican==1, by(FemCand)

*Static Board:
ttest IPCandLibCon if Groups==3 & Republican==1, by(FemCand)

*Maximum Dynamic Board
ttest IPCandLibCon if Groups==4 & Republican==1, by(FemCand)

*IPCandLibCon for Democrats
*News Articles:
ttest IPCandLibCon if Groups==1 & Democrat==1, by(FemCand)

*Minimal Dynamic Board
ttest IPCandLibCon if Groups==2 & Democrat==1, by(FemCand)

*Static Board:
ttest IPCandLibCon if Groups==3 & Democrat==1, by(FemCand)

*Maximum Dynamic Board
ttest IPCandLibCon if Groups==4 & Democrat==1, by(FemCand)

*IPCandCmpsn
*News Articles:
ttest IPCandCmpsn if Groups==1, by(FemCand)

*Minimal Dynamic Board
ttest IPCandCmpsn if Groups==2, by(FemCand)

*Static Board:
ttest IPCandCmpsn if Groups==3, by(FemCand)

*Maximum Dynamic Board
ttest IPCandCmpsn if Groups==4, by(FemCand)

*IPCandComp
*News Articles:
ttest IPCandComp if Groups==1, by(FemCand)

*Minimal Dynamic Board
ttest IPCandComp if Groups==2, by(FemCand)

*Static Board:
ttest IPCandComp if Groups==3, by(FemCand)

*Maximum Dynamic Board
ttest IPCandComp if Groups==4, by(FemCand)

*IPCandLead
*News Articles:
ttest IPCandLead if Groups==1, by(FemCand)

*Minimal Dynamic Board
ttest IPCandLead if Groups==2, by(FemCand)

*Static Board:
ttest IPCandLead if Groups==3, by(FemCand)

*Maximum Dynamic Board
ttest IPCandLead if Groups==4, by(FemCand)

*IPCandTrust
*News Articles:
ttest IPCandTrust if Groups==1, by(FemCand)

*Minimal Dynamic Board
ttest IPCandTrust if Groups==2, by(FemCand)

*Static Board:
ttest IPCandTrust if Groups==3, by(FemCand)

*Maximum Dynamic Board
ttest IPCandTrust if Groups==4, by(FemCand)

*IPCandEcon
*News Articles:
ttest IPCandEcon if Groups==1, by(FemCand)

*Minimal Dynamic Board
ttest IPCandEcon if Groups==2, by(FemCand)

*Static Board:
ttest IPCandEcon if Groups==3, by(FemCand)

*Maximum Dynamic Board
ttest IPCandEcon if Groups==4, by(FemCand)

*IPCandMil
*News Articles:
ttest IPCandMil if Groups==1, by(FemCand)

*Minimal Dynamic Board
ttest IPCandMil if Groups==2, by(FemCand)

*Static Board:
ttest IPCandMil if Groups==3, by(FemCand)

*Maximum Dynamic Board
ttest IPCandMil if Groups==4, by(FemCand)

*IPCandPoor
*News Articles:
ttest IPCandPoor if Groups==1, by(FemCand)

*Minimal Dynamic Board
ttest IPCandPoor if Groups==2, by(FemCand)

*Static Board:
ttest IPCandPoor if Groups==3, by(FemCand)

*Maximum Dynamic Board
ttest IPCandPoor if Groups==4, by(FemCand)

*IPCandWages
*News Articles:
ttest IPCandWages if Groups==1, by(FemCand)

*Minimal Dynamic Board
ttest IPCandWages if Groups==2, by(FemCand)

*Static Board:
ttest IPCandWages if Groups==3, by(FemCand)

*Maximum Dynamic Board
ttest IPCandWages if Groups==4, by(FemCand)






*******TABLE 2. T-tests, treatment effects and Difference-in-Differences of In-Party evaluations, by Information Level*******

*In-Party Cand FT
*LowInfo:
ttest IPCandFT if MaxInfo==0, by(FemCand)
return list
gen LOW_N = r(N_1)+r(N_2)
gen LOW_EFF=r(mu_1)-r(mu_2) 
gen LOW_SD=sqrt(LOW_N)*(r(se))

*HighInfo
ttest IPCandFT if MaxInfo==1, by(FemCand)
return list
gen HI_N = r(N_1)+r(N_2)
gen HI_EFF=r(mu_1)-r(mu_2) 
gen HI_SD=sqrt(HI_N)*(r(se))

ttesti `=LOW_N[1]' `=LOW_EFF[1]' `=LOW_SD[1]' `=HI_N[1]' `=HI_EFF[1]' `=HI_SD[1]', unequal
drop LOW_* HI_*

*IPCandLibCon for Republicans
*LowInfo:
ttest IPCandLibCon if MaxInfo==0 & Republican==1, by(FemCand)
return list
gen LOW_N = r(N_1)+r(N_2)
gen LOW_EFF=r(mu_1)-r(mu_2) 
gen LOW_SD=sqrt(LOW_N)*(r(se))

*HighInfo
ttest IPCandLibCon if MaxInfo==1 & Republican==1, by(FemCand)
return list
gen HI_N = r(N_1)+r(N_2)
gen HI_EFF=r(mu_1)-r(mu_2) 
gen HI_SD=sqrt(HI_N)*(r(se))

ttesti `=LOW_N[1]' `=LOW_EFF[1]' `=LOW_SD[1]' `=HI_N[1]' `=HI_EFF[1]' `=HI_SD[1]', unequal
drop LOW_* HI_*

*IPCandLibCon for Democrats
*LowInfo:
ttest IPCandLibCon if MaxInfo==0 & Democrat==1, by(FemCand)
return list
gen LOW_N = r(N_1)+r(N_2)
gen LOW_EFF=r(mu_1)-r(mu_2) 
gen LOW_SD=sqrt(LOW_N)*(r(se))

*HighInfo
ttest IPCandLibCon if MaxInfo==1 & Democrat==1, by(FemCand)
return list
gen HI_N = r(N_1)+r(N_2)
gen HI_EFF=r(mu_1)-r(mu_2) 
gen HI_SD=sqrt(HI_N)*(r(se))

ttesti `=LOW_N[1]' `=LOW_EFF[1]' `=LOW_SD[1]' `=HI_N[1]' `=HI_EFF[1]' `=HI_SD[1]', unequal
drop LOW_* HI_*

*IPCandCmpsn
*LowInfo:
ttest IPCandCmpsn if MaxInfo==0, by(FemCand)
return list
gen LOW_N = r(N_1)+r(N_2)
gen LOW_EFF=r(mu_1)-r(mu_2) 
gen LOW_SD=sqrt(LOW_N)*(r(se))

*HighInfo
ttest IPCandCmpsn if MaxInfo==1, by(FemCand)
return list
gen HI_N = r(N_1)+r(N_2)
gen HI_EFF=r(mu_1)-r(mu_2) 
gen HI_SD=sqrt(HI_N)*(r(se))

ttesti `=LOW_N[1]' `=LOW_EFF[1]' `=LOW_SD[1]' `=HI_N[1]' `=HI_EFF[1]' `=HI_SD[1]', unequal
drop LOW_* HI_*

*IPCandComp
*LowInfo:
ttest IPCandComp if MaxInfo==0, by(FemCand)
return list
gen LOW_N = r(N_1)+r(N_2)
gen LOW_EFF=r(mu_1)-r(mu_2) 
gen LOW_SD=sqrt(LOW_N)*(r(se))

*HighInfo
ttest IPCandComp if MaxInfo==1, by(FemCand)
return list
gen HI_N = r(N_1)+r(N_2)
gen HI_EFF=r(mu_1)-r(mu_2) 
gen HI_SD=sqrt(HI_N)*(r(se))

ttesti `=LOW_N[1]' `=LOW_EFF[1]' `=LOW_SD[1]' `=HI_N[1]' `=HI_EFF[1]' `=HI_SD[1]', unequal
drop LOW_* HI_*

*IPCandLead
*LowInfo:
ttest IPCandLead if MaxInfo==0, by(FemCand)
return list
gen LOW_N = r(N_1)+r(N_2)
gen LOW_EFF=r(mu_1)-r(mu_2) 
gen LOW_SD=sqrt(LOW_N)*(r(se))

*HighInfo
ttest IPCandLead if MaxInfo==1, by(FemCand)
return list
gen HI_N = r(N_1)+r(N_2)
gen HI_EFF=r(mu_1)-r(mu_2) 
gen HI_SD=sqrt(HI_N)*(r(se))

ttesti `=LOW_N[1]' `=LOW_EFF[1]' `=LOW_SD[1]' `=HI_N[1]' `=HI_EFF[1]' `=HI_SD[1]', unequal
drop LOW_* HI_*

*IPCandTrust
*LowInfo:
ttest IPCandTrust if MaxInfo==0, by(FemCand)
return list
gen LOW_N = r(N_1)+r(N_2)
gen LOW_EFF=r(mu_1)-r(mu_2) 
gen LOW_SD=sqrt(LOW_N)*(r(se))

*HighInfo
ttest IPCandTrust if MaxInfo==1, by(FemCand)
return list
gen HI_N = r(N_1)+r(N_2)
gen HI_EFF=r(mu_1)-r(mu_2) 
gen HI_SD=sqrt(HI_N)*(r(se))

ttesti `=LOW_N[1]' `=LOW_EFF[1]' `=LOW_SD[1]' `=HI_N[1]' `=HI_EFF[1]' `=HI_SD[1]', unequal
drop LOW_* HI_*

*IPCandEcon
*LowInfo:
ttest IPCandEcon if MaxInfo==0, by(FemCand)
return list
gen LOW_N = r(N_1)+r(N_2)
gen LOW_EFF=r(mu_1)-r(mu_2) 
gen LOW_SD=sqrt(LOW_N)*(r(se))

*HighInfo
ttest IPCandEcon if MaxInfo==1, by(FemCand)
return list
gen HI_N = r(N_1)+r(N_2)
gen HI_EFF=r(mu_1)-r(mu_2) 
gen HI_SD=sqrt(HI_N)*(r(se))

ttesti `=LOW_N[1]' `=LOW_EFF[1]' `=LOW_SD[1]' `=HI_N[1]' `=HI_EFF[1]' `=HI_SD[1]', unequal
drop LOW_* HI_*

*IPCandMil
*LowInfo:
ttest IPCandMil if MaxInfo==0, by(FemCand)
return list
gen LOW_N = r(N_1)+r(N_2)
gen LOW_EFF=r(mu_1)-r(mu_2) 
gen LOW_SD=sqrt(LOW_N)*(r(se))

*HighInfo
ttest IPCandMil if MaxInfo==1, by(FemCand)
return list
gen HI_N = r(N_1)+r(N_2)
gen HI_EFF=r(mu_1)-r(mu_2) 
gen HI_SD=sqrt(HI_N)*(r(se))

ttesti `=LOW_N[1]' `=LOW_EFF[1]' `=LOW_SD[1]' `=HI_N[1]' `=HI_EFF[1]' `=HI_SD[1]', unequal
drop LOW_* HI_*

*IPCandPoor
*LowInfo:
ttest IPCandPoor if MaxInfo==0, by(FemCand)
return list
gen LOW_N = r(N_1)+r(N_2)
gen LOW_EFF=r(mu_1)-r(mu_2) 
gen LOW_SD=sqrt(LOW_N)*(r(se))

*HighInfo
ttest IPCandPoor if MaxInfo==1, by(FemCand)
return list
gen HI_N = r(N_1)+r(N_2)
gen HI_EFF=r(mu_1)-r(mu_2) 
gen HI_SD=sqrt(HI_N)*(r(se))

ttesti `=LOW_N[1]' `=LOW_EFF[1]' `=LOW_SD[1]' `=HI_N[1]' `=HI_EFF[1]' `=HI_SD[1]', unequal
drop LOW_* HI_*

*IPCandWages
*LowInfo:
ttest IPCandWages if MaxInfo==0, by(FemCand)
return list
gen LOW_N = r(N_1)+r(N_2)
gen LOW_EFF=r(mu_1)-r(mu_2) 
gen LOW_SD=sqrt(LOW_N)*(r(se))

*HighInfo
ttest IPCandWages if MaxInfo==1, by(FemCand)
return list
gen HI_N = r(N_1)+r(N_2)
gen HI_EFF=r(mu_1)-r(mu_2) 
gen HI_SD=sqrt(HI_N)*(r(se))

ttesti `=LOW_N[1]' `=LOW_EFF[1]' `=LOW_SD[1]' `=HI_N[1]' `=HI_EFF[1]' `=HI_SD[1]', unequal
drop LOW_* HI_*





*******TABLE 3. Oneway ANOVA's of time spent in experiment (Substage and Total), by Group

oneway  PreQTimeADJ Groups, tabulate scheffe

oneway  PracTimeADJ  Groups, tabulate scheffe

oneway  CampTimeADJ Groups, tabulate scheffe

oneway  FinQTime Groups, tabulate scheffe

oneway TotTime  Groups, tabulate scheffe




*******TABLE 4. Oneway ANOVA's of information viewed (Unique and Total), by Group

oneway TotItemsAdj Groups, tabulate scheffe

oneway TotOpnsAdj Groups, tabulate scheffe





*******TABLE 5. Percentage of subjects viewing an attribute, by Group*************

tab1 Att_AbortzItems Att_CrimeItems Att_DefItems Att_EconPhilItems Att_EditItems Att_EducItems Att_EducPolItems Att_EnergyItems Att_FamItems Att_GlbWrmItems Att_GunsItems Att_HealthItems Att_ImmigItems Att_IranItems Att_JobsItems Att_PolExpItems Att_ReligItems Att_SocPhilItems Att_TaxesItems Att_TerrorItems if Groups==1

tab1 Att_AbortzItems Att_CrimeItems Att_DefItems Att_EconPhilItems Att_EditItems Att_EducItems Att_EducPolItems Att_EnergyItems Att_FamItems Att_GlbWrmItems Att_GunsItems Att_HealthItems Att_ImmigItems Att_IranItems Att_JobsItems Att_PolExpItems Att_ReligItems Att_SocPhilItems Att_TaxesItems Att_TerrorItems if Groups==2

tab1 Att_AbortzItems Att_CrimeItems Att_DefItems Att_EconPhilItems Att_EditItems Att_EducItems Att_EducPolItems Att_EnergyItems Att_FamItems Att_GlbWrmItems Att_GunsItems Att_HealthItems Att_ImmigItems Att_IranItems Att_JobsItems Att_PolExpItems Att_ReligItems Att_SocPhilItems Att_TaxesItems Att_TerrorItems if Groups==3

tab1 Att_AbortzItems Att_CrimeItems Att_DefItems Att_EconPhilItems Att_EditItems Att_EducItems Att_EducPolItems Att_EnergyItems Att_FamItems Att_GlbWrmItems Att_GunsItems Att_HealthItems Att_ImmigItems Att_IranItems Att_JobsItems Att_PolExpItems Att_ReligItems Att_SocPhilItems Att_TaxesItems Att_TerrorItems if Groups==4
