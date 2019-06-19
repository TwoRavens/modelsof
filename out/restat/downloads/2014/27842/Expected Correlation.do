/* Expected Correlation.do */
/* This do file conducts two analyses for what intertemporal correlation in choice as outlined in section 3.3 */
/* to expect under varying assumptions about decision error. The analysis estimates */
/* aggregate preferences and then simulates 5000 draws of intertemporal choices for */
/* a data set of size 200 (approximately the size of the returnee sample). The randomness */
/* in simulation is provided by either an estimated decision error or by an assumption on */
/* decision error. */
/* The conducted analyses are */
/*	1. What correlation to expect under the preference and noise estimates for 2007 */
/*	2. What correlation to expect under the preference estimates for 2007 and noise parameter of 0.175 *//*	1. What correlation to expect under the preference and noise estimates for 2007 */ml model lf ML_quasi (b: choice optionA optionB t k  =) (d: ) (mu: ) if  inconsistent == 0 &  year ==2007, technique(bhhh) clu(uniqid) maximizeml displaycapture drop betahatpredictnl betahat = xb(b) capture drop deltahatpredictnl deltahat = xb(d) capture drop muhatpredictnl muhat = xb(mu) capture drop duAgenerate duA = optionAcapture drop duBgenerate duB = (betahat*(deltahat^k)*optionB)replace duB =  ((deltahat^k)*optionB) if t == 6capture drop duDiffgenerate duDiff = (duB^(1/muhat))/((duB^(1/muhat))+(duA^(1/muhat))) capture drop simcountgen simcount = _ncapture drop rhochoicedrawgen rhochoicedraw = . capture drop rhorowdraw
gen rhorowdraw = .

capture drop nonmondraw
gen nonmondraw = .


capture drop t0
gen t0 = (t==0)

set seed 555forvalues i = 1(1)5000 {capture drop randomqui generate random = uniform() if uniqid <= 200capture drop choicesimqui gen choicesim = (duDiff >= random) if  duDiff != . & uniqid <= 200

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

capture drop random2qui generate random2 = uniform() if uniqid <=200capture drop choicesim2qui gen choicesim2 = (duDiff >= random2) if duDiff != . & uniqid <= 200

capture drop rowsim2qui egen rowsim2 = total(choicesim2) if  duDiff != . & uniqid <=200 , by(uniqid t k)

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

qui corr choicesim choicesim2qui replace rhochoicedraw = r(rho) if simcount == `i'
qui corr rowsim rowsim2qui replace rhorowdraw = r(rho) if simcount == `i'

capture drop temp
qui egen temp = mean(nonmonsim ==0 & nonmonsim2 ==0) if duDiff != . & uniqid <= 200
qui replace nonmondraw = temp if simcount == `i'
}/*	2. What correlation to expect under the preference estimates for 2007 and noise parameter of 0.175 */ml model lf ML_quasi (b: choice optionA optionB t k  =) (d: ) (mu: ) if  inconsistent == 0 &  year ==2007 , technique(bhhh) clu(uniqid) maximize  ml displaycapture drop betahatpredictnl betahat = xb(b) capture drop deltahatpredictnl deltahat = xb(d) capture drop muhatpredictnl muhat = xb(mu) 
/* Replace Noise Estimate */replace muhat = 0.175capture drop duAgenerate duA = optionAcapture drop duBgenerate duB = (betahat*(deltahat^k)*optionB)replace duB =  ((deltahat^k)*optionB) if t == 6capture drop duDiffgenerate duDiff = (duB^(1/muhat))/((duB^(1/muhat))+(duA^(1/muhat))) capture drop simcountgen simcount = _ncapture drop rhochoicedraw2gen rhochoicedraw2 = . capture drop rhorowdraw2
gen rhorowdraw2 = .

capture drop nonmondraw2
gen nonmondraw2 = .


capture drop t0
gen t0 = (t==0)

set seed 555forvalues i = 1(1)5000 {capture drop randomqui generate random = uniform() if uniqid <= 200capture drop choicesimqui gen choicesim = (duDiff >= random) if  duDiff != . & uniqid <= 200

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

capture drop random2qui generate random2 = uniform() if uniqid <=200capture drop choicesim2qui gen choicesim2 = (duDiff >= random2) if duDiff != . & uniqid <= 200

capture drop rowsim2qui egen rowsim2 = total(choicesim2) if  duDiff != . & uniqid <=200 , by(uniqid t k)

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

qui corr choicesim choicesim2qui replace rhochoicedraw2 = r(rho) if simcount == `i'
qui corr rowsim rowsim2qui replace rhorowdraw2 = r(rho) if simcount == `i'

capture drop temp
qui egen temp = mean(nonmonsim ==0 & nonmonsim2 ==0) if duDiff != . & uniqid <= 200
qui replace nonmondraw2 = temp if simcount == `i'

}log on/* Expected Correlation Analyses following Section 3.3*/su  *draw*
corr choice lagchoice if returneesample ==1corr totalchoice totallagchoice if returneesample ==1log off
