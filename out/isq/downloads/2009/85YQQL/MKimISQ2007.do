/*
Replication Data for 
"Costly Procedures: Divergent Effects of Legalization in the GATT/WTO Dispute Settlement Procedures"

Moonhawk Kim
University of Colorado at Boulder
moonhawk.kim@colorado.edu

December 7, 2007

Forthcoming in _International Studies Quarterly_
*/

// USE "MKimISQ2007.dta" FOR THE FOLLOWING:

// Figure: Count of AD/CVD Measures and Potentially Disputatious Dyads, 1980 - 2004
twoway (bar cadcvd year,yaxis(1)) (line totadcvd year,yaxis(2)) if yeartag == 1, xtitle("Year") ytitle("Count of Potentially Disputatious Dyads",axis(1)) ytitle("Count of Total AD/CVD Measures",axis(2)) scheme(s1mono) legend(off)

// Figure: AD/CVD Measures by Complainant Capacity and Institutional Context
graph box pqual, over(adcvd,relabel(1 "No AD/CVD" 2 "AD/CVD")) over(inst, relabel(1 "Pre '89 GATT" 2 "Post '89 GATT" 3 "WTO")) scheme(s1mono) ytitle("Potential Complainants' Bureaucracy Quality")

//Figure: Consultation Requests by Complainant Capacity and Institutional Context
graph box pqual if adcvd == 1, over(cc,relabel(1 "No Request" 2 "Request")) over(inst, relabel(1 "Pre '89 GATT" 2 "Post '89 GATT" 3 "WTO")) scheme(s1mono) ytitle("Potential Complainants' Bureaucracy Quality")

// Models: Models of Countries' Imposition of AD/CVDs and Requests for Consultation
xi3: sartsel sartdv pexdep dexdep ?kgdp ?gdppc ?fhspr, corr(-1)
xi3: sartsel sartdv pexdep dexdep ?kgdp ?gdppc ?fhspr ?qual, corr(-1)
xi3: sartsel sartdv pexdep dexdep ?kgdp ?gdppc ?fhspr pqual*i.inst dqual, corr(-1)

// USE "MKimISQ2007Clarify.dta" FOR THE FOLLOWING:

// Figure: Predicted Probabilities of Consultation Requests by Complainant Capacity--Pre-1989 GATT
twoway line value0 value1 value2 capacity if institution == 0, scheme(s1mono) lpattern(dash solid dash) ytitle("Probability of Consultation Request") xtitle("Potential Complainants' Capacity") legend(label(1 "Lower Bound") label(2 "Predicted Value") label(3 "Upper Bound") rows(1))

// Figure: Predicted Probabilities of Consultation Requests by Complainant Capacity--Post-1989 GATT
twoway line value0 value1 value2 capacity if institution == 1, scheme(s1mono) lpattern(dash solid dash) ytitle("Probability of Consultation Request") xtitle("Potential Complainants' Capacity") legend(label(1 "Lower Bound") label(2 "Predicted Value") label(3 "Upper Bound") rows(1))

// Figure: Predicted Probabilities of Consultation Requests by Complainant Capacity--WTO
twoway line value0 value1 value2 capacity if institution == 2, scheme(s1mono) lpattern(dash solid dash) ytitle("Probability of Consultation Request") xtitle("Potential Complainants' Capacity") legend(label(1 "Lower Bound") label(2 "Predicted Value") label(3 "Upper Bound") rows(1))
