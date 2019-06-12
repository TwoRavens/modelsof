
********************************************************

use Experiment1, clear

*Table 1 - All okay

reg percshared sorting , hc3
reg percshared sorting sortBarcelona Barcelona, hc3
tobit percshared sorting , ll vce(jackknife)
tobit percshared sorting sortBarcelona Barcelona, ll vce(jackknife)	
probit percshared sorting , robust
probit percshared sorting sortBarcelona Barcelona, robust

*Table 2 - One rounding error in s.e. in each of cols 2 & 3
*Duplicates earlier regression in Table 1
reg percshared sorting , hc3
*No experimental parameters
reg percshared female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, hc3

reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, hc3

*Remaining tables (for Experiment 2) do not involve random experimental variation in treatment (have endowment, subsidy variables that vary systematically within each treatment across rounds) or are simple means

save DatLMW, replace


