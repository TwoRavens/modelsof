global cluster = ""

use DatLMW, clear

global i = 1
global j = 1

*Table 1
mycmd (sorting) reg percshared sorting , hc3
mycmd (sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, hc3
mycmd (sorting) tobit percshared sorting , ll vce(jackknife)
mycmd (sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll vce(jackknife)	
mycmd (sorting) probit percshared sorting , robust
mycmd (sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, robust

*Table 2
mycmd (sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, hc3



