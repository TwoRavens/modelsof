/* Expected Correlation.do */
/* This do file conducts two analyses for what intertemporal correlation in choice as outlined in section 3.3 */
/* to expect under varying assumptions about decision error. The analysis estimates */
/* aggregate preferences and then simulates 5000 draws of intertemporal choices for */
/* a data set of size 200 (approximately the size of the returnee sample). The randomness */
/* in simulation is provided by either an estimated decision error or by an assumption on */
/* decision error. */
/* The conducted analyses are */
/*	1. What correlation to expect under the preference and noise estimates for 2007 */
/*	2. What correlation to expect under the preference estimates for 2007 and noise parameter of 0.175 */
gen rhorowdraw = .

capture drop nonmondraw
gen nonmondraw = .


capture drop t0
gen t0 = (t==0)



capture drop rowsim
qui egen rowsim = total(choicesim) if duDiff != . & uniqid <=200 , by(uniqid t k)

capture drop temp
qui bysort uniqid t k (optionA): gen temp = (choicesim[_n-1] - choicesim)*optionA if duDiff != . & uniqid <=200
capture drop temp2
qui gen temp2 = (temp < 0) if duDiff != . & uniqid <=200
capture drop temp3
qui egen temp3 = total(temp2) if duDiff != . & uniqid <=200, by(uniqid t k)
capture drop temp4
qui gen temp4 = ((temp > 1)*temp) if duDiff != . & uniqid <=200

capture drop nonmonsim
qui egen nonmonsim = total(temp2) if duDiff != . & uniqid <=200, by(uniqid)



capture drop rowsim2

capture drop temp
qui bysort uniqid t k (optionA): gen temp = (choicesim2[_n-1] - choicesim2)*optionA if duDiff != . & uniqid <=200
capture drop temp2
qui gen temp2 = (temp < 0) if duDiff != . & uniqid <=200
capture drop temp3
qui egen temp3 = total(temp2) if duDiff != . & uniqid <=200, by(uniqid t k)
capture drop temp4
qui gen temp4 = ((temp > 1)*temp) if duDiff != . & uniqid <=200

capture drop nonmonsim2
qui egen nonmonsim2 = total(temp2) if duDiff != . & uniqid <=200, by(uniqid)


qui corr rowsim rowsim2

capture drop temp
qui egen temp = mean(nonmonsim ==0 & nonmonsim2 ==0) if duDiff != . & uniqid <= 200
qui replace nonmondraw = temp if simcount == `i'

/* Replace Noise Estimate */
gen rhorowdraw2 = .

capture drop nonmondraw2
gen nonmondraw2 = .


capture drop t0
gen t0 = (t==0)



capture drop rowsim
qui egen rowsim = total(choicesim) if duDiff != . & uniqid <=200 , by(uniqid t k)

capture drop temp
qui bysort uniqid t k (optionA): gen temp = (choicesim[_n-1] - choicesim)*optionA if duDiff != . & uniqid <=200
capture drop temp2
qui gen temp2 = (temp < 0) if duDiff != . & uniqid <=200
capture drop temp3
qui egen temp3 = total(temp2) if duDiff != . & uniqid <=200, by(uniqid t k)
capture drop temp4
qui gen temp4 = ((temp > 1)*temp) if duDiff != . & uniqid <=200

capture drop nonmonsim
qui egen nonmonsim = total(temp2) if duDiff != . & uniqid <=200, by(uniqid)



capture drop rowsim2

capture drop temp
qui bysort uniqid t k (optionA): gen temp = (choicesim2[_n-1] - choicesim2)*optionA if duDiff != . & uniqid <=200
capture drop temp2
qui gen temp2 = (temp < 0) if duDiff != . & uniqid <=200
capture drop temp3
qui egen temp3 = total(temp2) if duDiff != . & uniqid <=200, by(uniqid t k)
capture drop temp4
qui gen temp4 = ((temp > 1)*temp) if duDiff != . & uniqid <=200

capture drop nonmonsim2
qui egen nonmonsim2 = total(temp2) if duDiff != . & uniqid <=200, by(uniqid)


qui corr rowsim rowsim2

capture drop temp
qui egen temp = mean(nonmonsim ==0 & nonmonsim2 ==0) if duDiff != . & uniqid <= 200
qui replace nonmondraw2 = temp if simcount == `i'


corr choice lagchoice if returneesample ==1