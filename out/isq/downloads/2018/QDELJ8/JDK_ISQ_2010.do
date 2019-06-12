*Table 1:
use "C:\Data\LemkeReganReplication.dta", clear
*Model 1
probit interven intense refugee coldwar casualty allied colhist gpower african intdem cwdem jointdem ethdum ideodum  neighbor , robust

*Model 2
probit interven intense refugee coldwar casualty allied colhist gpower african intdem cwdem jointdem ethdum ideodum  neighbor if neighbor == 1, robust

*Model 3
probit interven intense refugee coldwar casualty allied colhist gpower african intdem cwdem jointdem ethdum ideodum  neighbor if gpower == 1, robust

*Model 4
probit interven intense refugee coldwar casualty allied colhist gpower african intdem cwdem jointdem ethdum ideodum  neighbor if gpower == 0 & neighbor == 0, robust



*Table 2: 
use "C:\CivilWarPrevalence.dta", clear
*Model 1 
logit CWongoing lngdpLag het politybLag polityb2Lag lnpopLag  peaceyrs_CWongoing spline1_CWongoing spline2_CWongoing spline3_CWongoing

*Model 2 
logit CWongoing neighborCWintensity lngdpLag het politybLag polityb2Lag lnpopLag peaceyrs_CWongoing spline1_CWongoing spline2_CWongoing spline3_CWongoing



Table 3: 
use "C:\NeighborInterventions.dta"
*Model 1:
logit interven1 InfectionRisk, robust

*Model 2:
logit interven1 InfectionRisk COWalliance_dummyLag thrdpartCINCLag coldwar ideology ideo_coldwar ethnic war_dur_count lnBorderLength1  land_border political_distanceLag IntervenCountLag logref2_lag, robust

*Model 3:
logit interven1 InfectionRisk COWalliance_dummyLag thrdpartCINCLag coldwar ideology ideo_coldwar ethnic war_dur_count lnBorderLength1  land_border political_distanceLag IntervenCountLag logref2_lag AmericaRegion EuropeRegion AfricaRegion AsiaRegion, robust

*Model 4
logit MilInterven_dum InfectionRisk COWalliance_dummyLag thrdpartCINCLag coldwar ideology ideo_coldwar ethnic war_dur_count lnBorderLength1  land_border political_distanceLag IntervenCountLag logref2_lag, robust

*Model 5
logit MilInterven_dum InfectionRisk COWalliance_dummyLag thrdpartCINCLag coldwar ideology ideo_coldwar ethnic war_dur_count lnBorderLength1  land_border political_distanceLag IntervenCountLag logref2_lag AmericaRegion EuropeRegion AfricaRegion AsiaRegion, robust












