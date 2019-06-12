*TABLE 1
*Model 1.1 Lagged Turnout with Clustered Standard Errors
reg prestout reg lnTotPartyCirc LnPartyCircXReg lagprestout LnPresEligible, vce(cluster cnty90)
*For note on page 17 of the manuscript--no interaction term.
reg prestout reg lnTotPartyCirc lagprestout LnPresEligible, vce(cluster cnty90)
*Model 1.2 Lagged Turnout, Clustered Standard Errors, and Year Dummies
reg prestout reg lnTotPartyCirc LnPartyCircXReg lagprestout LnPresEligible i.year, vce(cluster cnty90)
xtset cnty90 year
*Model 1.3 Lagged Turnout, Clustered Standard Errors, and Fixed Effects
xtreg prestout reg lnTotPartyCirc LnPartyCircXReg lagprestout LnPresEligible, fe vce(cluster cnty90)
*Model 1.4 Lagged Turnout, Clustered Standard Errors, Fixed Effects, and Year Dummies
xtreg prestout reg lnTotPartyCirc LnPartyCircXReg lagprestout LnPresEligible i.year, fe vce(cluster cnty90)
*TABLE 2
* Model 2.1 Lagged Turnout, Year Dummies, Demographic Controls, and Clustered Standard Errors 
reg prestout reg lnTotPartyCirc LnPartyCircXReg lagprestout LnPresEligible i.year LogPerCapitaManu SharePopWhite ShareMale ShareTowns ShareCity MisManuOutput, vce(cluster cnty90)
* Model 2.2 Lagged Turnout, Year Dummies, Demographic Controls, and Clustered Standard Errors
xtreg prestout reg lnTotPartyCirc LnPartyCircXReg lagprestout LnPresEligible i.year  LogPerCapitaManu SharePopWhite ShareMale ShareTowns ShareCity MisManuOutput, fe vce(cluster cnty90)
*TABLE 3
*Model 3.1 Lagged Turnout, Clustered Standard Errors, and Other Legal-Institutional Controls
xtreg prestout lagprestout reg lnTotPartyCirc LnPartyCircXReg LnPresEligible timetrend AustralianBallot PartyColumn OfficeBlock DirectPrimary DunnAct Women NoTax SenateElection, fe vce(cluster cnty90)
*Model 3.2 Lagged Turnout, Clustered Standard Errors, Other Legal-Institutional Controls, and Demographic Controls
xtreg prestout lagprestout reg lnTotPartyCirc LnPartyCircXReg LnPresEligible timetrend AustralianBallot PartyColumn OfficeBlock DirectPrimary DunnAct Women NoTax SenateElection  SharePopWhite ShareMale ShareTowns ShareCity LogPerCapitaManu MisManuOutput, fe vce(cluster cnty90)
*TABLE A
xtreg prestout reg lnTotPartyCirc LnPartyCircXReg lagprestout LnPresEligible i.year  LnPCMMissing SharePopWhite ShareMale ShareTowns ShareCity, fe vce(cluster cnty90)
*TABLE B
xtreg prestout reg lnTotPartyCirc LnPartyCircXReg LnPresEligible i.year, fe vce(cluster cnty90)

*Calculating the marginal effect of voter registration requirements, conditional on the circulation of party newspapers
xtreg prestout reg lnTotPartyCirc LnPartyCircXReg lagprestout LnPresEligible i.year, fe vce(cluster cnty90)
set obs 10000
matrix b=e(b) 
matrix V=e(V)
 
scalar b1=b[1,1] 
scalar b2=b[1,2]
scalar b3=b[1,3]

scalar varb1=V[1,1] 
scalar varb2=V[2,2] 
scalar varb3=V[3,3]

scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

generate MVZ=((_n-1)/100)

gen conbx=b1+b3*MVZ

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) 

gen ax=1.96*consx
 
gen upperx=conbx+ax
 
gen lowerx=conbx-ax

drop if MVZ>14.33
