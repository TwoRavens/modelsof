
****************************************
****************************************



use DatLMW, clear

*Table 1

global i = 1

reg percshared sorting , 
		estimates store M$i
		global i = $i + 1

reg percshared sorting sortBarcelona Barcelona, 
		estimates store M$i
		global i = $i + 1

tobit percshared sorting , ll 
		estimates store M$i
		global i = $i + 1

tobit percshared sorting sortBarcelona Barcelona, ll 	
		estimates store M$i
		global i = $i + 1

probit percshared sorting , 
		estimates store M$i
		global i = $i + 1

probit percshared sorting sortBarcelona Barcelona, 
		estimates store M$i
		global i = $i + 1

suest M1 M2 M3 M4 M5 M6, robust
test sorting sortBarcelona
matrix F = (r(p), r(drop), r(df), r(chi2), 1)


*Table 2

global i = 1

reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, 
		estimates store M$i
		global i = $i + 1

reg percshared sorting , 
		estimates store M$i
		global i = $i + 1

suest M1 M2, robust
test sorting 
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 2)

drop _all
svmat double F
save results/SuestLMW, replace


