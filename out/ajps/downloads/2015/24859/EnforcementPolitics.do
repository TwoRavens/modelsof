*** The Distributive Politics of Enforcement
*** Alisha C. Holland
*** American Journal of Political Science
*** Replication Code 

*** File: EnforcementPolitics.dta

*** Cross-Sectional Analysis: Poisson Models
*** Each city is run separately.
preserve
keep if city=="bogota"  
** keep if city == "lima"
** keep if city == "santiago"

*** Table 2 presents standardized coefficients.
*** Standardize continuous independent variables.  
egen slower = std(lower)
egen svendors = std(vendors)
egen sbudget = std(budget)
egen spopulation = std(population)

*** Model 1: All Cities, Basic Model 

poisson operations slower svendors sbudget spopulation, vce(robust)
nlcom exp(_b[slower])-1
nlcom exp(_b[svendors])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1
restore

*** Moving from 10 to 50 percent lower class district is 1.77 sd in Lima:
nlcom exp(_b[slower]*1.77)-1
*** And from 10 to 50 percent lower class district is 2.129 sd in Santiago so:
nlcom exp(_b[slower]*2.129)-1
*** Simulations for the predicted number of operations using clarify produce similar results:
estsimp poisson operations lower vendors budget population, vce(robust)
setx mean
setx lower 10
simqi, ev 
setx lower 50
simqi, ev 
*** Change in the budget in Lima
nlcom exp(_b[sbudget]*1.968)-1

*** Repeat for other cities.  

*** Model 2: Decentralized Cities (Lima and Santiago), Add Political Competition 

egen smargin = std(margin)
poisson operations slower svendors sbudget spopulation smargin, vce(robust)
nlcom exp(_b[slower])-1
nlcom exp(_b[svendors])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1
nlcom exp(_b[smargin])-1

*** Model 3: Decentralized Cities, Add Interaction of Lower Class and Political Competition 

*** Create interaction 
generate margin_lower = margin * lower
egen smargin_lower = std(margin_lower)

poisson operations slower svendors sbudget spopulation smargin smargin_lower, vce(robust)
nlcom exp(_b[slower])-1
nlcom exp(_b[svendors])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1
nlcom exp(_b[smargin])-1
nlcom exp(_b[smargin_lower])-1

nlcom exp(_b[slower]+_b[smargin_lower]*1)-1
nlcom exp(_b[slower]+_b[smargin_lower]*3)-1

*** Model 4: Partisan Affiliation (Santiago Only)
preserve 
keep if city == "santiago"
poisson operations slower svendors sbudget spopulation right, vce(robust)
nlcom exp(_b[slower])-1
nlcom exp(_b[svendors])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1 
nlcom exp(_b[right])-1

*** Model 5: Valence Crime, Santiago
poisson arrests slower sreports sbudget spopulation right, vce(robust)
nlcom exp(_b[slower])-1
nlcom exp(_b[sreports])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1 
restore

***  Political mechanisms

sort city
by city: correlate corruption lower
*** Note that the scale is reversed in the article

by city: correlate corruption lower
*** Number of bureaucrats who believe corruption is common
by city: count if corruption < 5
*** Number of bureaucrats who believe politics is main constraint on enforcement (note the categories
** "5" and "6" were commonly understood by bureaucrats to mean "both" and so I consider only strong responses.
count if constraint <5 & city == "lima"

*** FIGURE 4

preserve
keep if city=="santiago"
twoway (scatter operations vendors if poordistrict==1, mcolor(black) msize(large) msymbol(smcircle) xlab(0(2)12)ylab(0(5)20, nogrid))(scatter operations vendors if poordistrict==0, msymbol(smtriangle_hollow) msize(large) mcolor(black)) || lfit operations vendors, clcolor(gray) legend(label(1 "Poor") label(2 "Nonpoor") order(1 2)) ytitle("Police Operations") xtitle("Unlicensed Vendors (Thousands), Santiago") graphregion(color(white) lcolor(white))
restore 

preserve
keep if city=="bogota"
twoway (scatter operations vendors if poordistrict==1, mcolor(black) msymbol(smcircle) msize(large) xlab(0(2)12)ylab(0(5)30, nogrid))(scatter operations vendors if poordistrict==0, msymbol(smtriangle_hollow) msize(large) mcolor(black)) || lfit operations vendors, clcolor(gray) legend(label(1 "Poor") label(2 "Nonpoor") order(1 2)) ytitle("Police Operations") xtitle("Unlicensed Vendors (Thousands), Bogot‡") graphregion(color(white) lcolor(white))
restore 

preserve
keep if city=="lima"& inrange(vendors,0,12)
twoway (scatter operations vendors if poordistrict==1, mcolor(black) msymbol(smcircle) msize(large) xlab(0(2)12)ylab(0(20)80, nogrid))(scatter operations vendors if poordistrict==0, msymbol(smtriangle_hollow) msize(large) mcolor(black)) || lfit operations vendors, clcolor(gray) legend(label(1 "Poor") label(2 "Nonpoor") order(1 2)) ytitle("Police Operations") xtitle("Unlicensed Vendors (Thousands), Lima") graphregion(color(white) lcolor(white))
restore 

preserve
keep if city=="santiago" & inrange(reports,0,65)
twoway (scatter arrests reports if poordistrict==1, mcolor(black) msize(large) msymbol(smcircle) xlab(0(10)60)ylab(0(5)20, nogrid))(scatter arrests reports if poordistrict==0, msymbol(smtriangle_hollow) msize(large) mcolor(black)) || lfit arrests reports, clcolor(gray) legend(label(1 "Poor") label(2 "Nonpoor") order(1 2)) ytitle("Police Arrests (Thousands)") xtitle("Crime Reports (Thousands), Santiago") graphregion(color(white) lcolor(white))
restore

*** Figure 4

keep if city=="bogota"
summarize operations 
gen operationsm = operations/ 8.8947

keep if city=="lima"
summarize operations
gen operationsm = operations/ 23.22

keep if city=="santiago"
summarize operations
gen operationsm = operations/  2.7058

estsimp poisson operationsm lower vendors budget population, vce(robust)
setx mean
*** Evaluate for vendors from 0-15
setx vendors 0
simqi, ev 
*** Evaluate for poverty 10-60
setx lower 10
simqi, ev 

***  SUPPLEMENTAL INFORMATION

*** Table 1: Summary statistics 
*** Bogota 
sutex operations lower vendors budget population costs corruption poor police tax, minmax
*** Lima
sutex operations lower vendors budget population margin costs corruption poor police emp tax salary, minmax
*** Santiago
sutex operations lower vendors budget population margin costs corruption right arrests reports poor police emp tax salary, minmax

*** Check alternative vendor specifications from government sources 

egen svendorsalt = std(vendorsalt)
poisson operations slower svendorsalt sbudget spopulation, vce(robust)
nlcom exp(_b[slower])-1
nlcom exp(_b[svendorsalt])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1


*** Table 2, Cross-Sectional Analysis: Alternative Specifications

*** Model 1:
*** Robustness check for district poverty measure 
egen spoor = std(poor)
poisson operations spoor svendors sbudget spopulation, vce(robust)
nlcom exp(_b[spoor])-1
nlcom exp(_b[svendors])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1

*** Model 2
*** Robustness check for negative binomial specification due to concerns about overdispersion 
nbreg operations spoor svendors sbudget spopulation, vce(robust)
fitstat
nlcom exp(_b[spoor])-1
nlcom exp(_b[svendors])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1

*** Model 3 
*** Robustness check for per capita specification

generate operationspc  = operations/population
gen vendorspc = (vendors*1000)/population
egen svendorspc = std(vendorspc)

poisson operationspc spoor svendorspc sbudget spopulation, vce(robust)
nlcom exp(_b[spoor])-1
nlcom exp(_b[svendorspc])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1

*** Table 3, Cross-Sectional Analysis: Additional Capacity Measures

*** Model 1: Police
egen spolice  = std(police)
poisson operations spoor svendors sbudget spopulation spolice, vce(robust)
nlcom exp(_b[spoor])-1
nlcom exp(_b[svendors])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1
nlcom exp(_b[spolice])-1

*** Model 2: Administrative personnel (available for Lima and Santiago)
egen semp  = std(employees)
poisson operations spoor svendors sbudget spopulation semp, vce(robust)
nlcom exp(_b[spoor])-1
nlcom exp(_b[svendors])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1
nlcom exp(_b[semp])-1

*** Model 3: Tax 
egen stax = std(tax)
poisson operations spoor svendors sbudget spopulation stax, vce(robust)
nlcom exp(_b[spoor])-1
nlcom exp(_b[svendors])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1
nlcom exp(_b[stax])-1

*** Model 4: Salary per employee (available for Lima and Santiago)
egen ssalary = std(salary)
poisson operations spoor svendors sbudget spopulation ssalary, vce(robust)
nlcom exp(_b[spoor])-1
nlcom exp(_b[svendors])-1
nlcom exp(_b[sbudget])-1
nlcom exp(_b[spopulation])-1
nlcom exp(_b[ssalary])-1






