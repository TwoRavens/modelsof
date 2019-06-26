****** Replication file for "Capital Punishment: Bargaining and the Georgaphy of Civil War *****
****** Charles Butcher (charles.butcher@otago.ac.nz) *******

* lowess capdist fractionalization if year>=1975 & coup==0

* lowess capdist polarization if year>=1975 & coup==0


***** Table 3 ******

* use "INSERT DIRECTORY HERE/butcher2014replication.dta", replace

set more off
regress lncapdist fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0 , vce(cluster gwno)
est store M1
logit in10k fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0, vce(cluster gwno)
est store M2
**** Controlling for Relative Strength
regress lncapdist fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 rebstrord if year>=1975 & coup==0 , vce(cluster gwno)
est store M3
logit in10k fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 rebstrord if year>=1975 & coup==0, vce(cluster gwno)
est store M4
***Only conflicts over Government
regress lncapdist fractionalization polarization lnrgdpchimp lnmilper lnarea divided warmonths warmonths2 warmonths3 if year>=1975 & coup==0 & incomp==2, vce(cluster gwno)
est store M5
logit in10k fractionalization polarization lnrgdpchimp lnmilper lnarea divided warmonths warmonths2 warmonths3 if year>=1975 & coup==0 & incomp==2, vce(cluster gwno)
est store M6
*** Alternative Specifications
regress lncapdist multipolar bipolar lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0 , vce(cluster gwno)
est store M7
logit in10k multipolar bipolar lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0, vce(cluster gwno)
est store M8

est table M1 M2 M3 M4 M5 M6 M7 M8, b(%8.3f)  star (.05 .01 .001) stats(N)




***** ADDITIONAL ROBUSTNESS TESTS, ONLINE APPENDIX *****
*** CONFLICT YEAR AS UNIT OF ANALYSIS 1975-2011
set more off
*** Controls for terrain and natural resources in the conflict zone, new state status, oil exporter, plus instituional variables (from Buhaug, Gates and Lujala JCR 2009)
regress lncapdist fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 mt frst alldrugs hydrod allgemsp  anoc_ons democ_ons oil1 nwstate if year>=1975 & coup==0 , vce(cluster gwno)
est store M1
logit in10k fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 mt frst alldrugs hydrod allgemsp  anoc_ons democ_ons oil1 nwstate if year>=1975 & coup==0, vce(cluster gwno)
est store M2
**** Lagging fractionalizations and polarization, adding measure of conflict distance in the year before
regress lncapdist fractionalizationlag1 polarizationlag1 lncapdistlag1 lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0 , vce(cluster gwno)
est store M3
logit in10k fractionalizationlag1 polarizationlag1 in10klag1 lnrgdpchimp incomp lnmilper lnarea divided warmonths warmonths2 warmonths3 if year>=1975 & coup==0, vce(cluster gwno)
est store M4

**** Region fixed effects
regress lncapdist fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 europe mideast seasia africa if year>=1975 & coup==0 , vce(cluster gwno)
est store M5

logit in10k fractionalization polarization lnrgdpchimp incomp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 europe mideast seasia africa if year>=1975 & coup==0, vce(cluster gwno)
est store M6
**** Country fixed effects
regress lncapdist fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 i.gwno if year>=1975 & coup==0 , vce(cluster gwno)
est store M7
logit in10k fractionalization polarization lnrgdpchimp incomp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 i.gwno if year>=1975 & coup==0, vce(cluster gwno)
est store M8

**** Random Effects Logit
xtset confid year
xtlogit in10k fractionalization polarization lnrgdpchimp incomp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0
est store M9
**** Unlogged dependent variable
regress capdist fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0 , vce(cluster gwno)
est store M10
*** State weakness controls ****
regress lncapdist fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 rpe_agrilag1 rpr_worklag1 lnimrlag1 if year>=1975 & coup==0 , vce(cluster gwno)
est store M11
logit in10k fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 rpe_agrilag1 rpr_worklag1 lnimrlag1 if year>=1975 & coup==0, vce(cluster gwno)
est store M12
*** Conflict Episode
* use "INSERT DIRECTORY HERE/butcher2014crosssection.dta", replace
regress lnmeancapdist fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0, vce(cluster gwno)
est store M13
logit in10k fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0, cluster(gwno)
est store M14

est table M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12, b(%8.3f)  star (.05 .01 .001) stats(N)
est table M13 M14, b(%8.3f)  star (.05 .01 .001) stats(N)

* use "INSERT DIRECTORY HERE/butcher2014replication.dta", replace 

**** Dropping the Cubic Polynomials
set more off
regress lncapdist fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp if year>=1975 & coup==0 , vce(cluster gwno)
est store M15
logit in10k fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp if year>=1975 & coup==0, vce(cluster gwno)
est store M16

**** If Fractionalization is above 0.4
set more off
regress lncapdist fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0 & fractionalization>=0.4, vce(cluster gwno)
est store M17
logit in10k fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0 & fractionalization>=0.4, vce(cluster gwno)
est store M18

***** Dropping polarization from the model
set more off
regress lncapdist fractionalization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0 , vce(cluster gwno)
est store M19
logit in10k fractionalization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0, vce(cluster gwno)
est store M20

**** Dropping Fractionalization from the model
set more off
regress lncapdist polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0 , vce(cluster gwno)
est store M21
logit in10k polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0, vce(cluster gwno)
est store M22

est table M15 M16 M17 M18 M19 M20 M21 M22, b(%8.3f)  star (.05 .01 .001) stats(N)


**** FIGURES 2 and 3 - MARGINAL EFFECTS
* use "INSERT DIRECTORY HERE/butcher2014replication.dta", replace


**** Figure 2

set seed 12345
estsimp regress lncapdist fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0 , vce(cluster gwno)
setx mean 
simqi

setx fractionalization 0.038446751	polarization 0.076893502
simqisetx fractionalization 0.277777778	polarization 0.555555556
simqisetx fractionalization 0.408163265	polarization 0.816326531
simqisetx fractionalization 0.46875	    polarization 0.9375
simqisetx fractionalization 0.49382716	polarization 0.987654321
simqisetx fractionalization 0.5	        polarization 1
simqisetx fractionalization 0.578512397	polarization 0.931630353
simqisetx fractionalization 0.625	        polarization 0.902777778
simqisetx fractionalization 0.650887574	polarization 0.892125626
simqisetx fractionalization 0.663265306	polarization 0.889212828
simqisetx fractionalization 0.666666667	polarization 0.888888889
simqisetx fractionalization 0.703125	    polarization 0.8203125
simqisetx fractionalization 0.726643599	polarization 0.781599837
simqisetx fractionalization 0.740740741	polarization 0.761316872
simqisetx fractionalization 0.747922438	polarization 0.752296253
simqisetx fractionalization 0.75	        polarization 0.75
simqi

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12



*** Figure 3

set seed 12345
estsimp logit in10k fractionalization polarization lnrgdpchimp lnmilper lnarea divided incomp warmonths warmonths2 warmonths3 if year>=1975 & coup==0 , vce(cluster gwno)
setx mean 
simqi

setx fractionalization 0.038446751	polarization 0.076893502
simqisetx fractionalization 0.277777778	polarization 0.555555556
simqisetx fractionalization 0.408163265	polarization 0.816326531
simqisetx fractionalization 0.46875	    polarization 0.9375
simqisetx fractionalization 0.49382716	polarization 0.987654321
simqisetx fractionalization 0.5	        polarization 1
simqisetx fractionalization 0.578512397	polarization 0.931630353
simqisetx fractionalization 0.625	        polarization 0.902777778
simqisetx fractionalization 0.650887574	polarization 0.892125626
simqisetx fractionalization 0.663265306	polarization 0.889212828
simqisetx fractionalization 0.666666667	polarization 0.888888889
simqisetx fractionalization 0.703125	    polarization 0.8203125
simqisetx fractionalization 0.726643599	polarization 0.781599837
simqisetx fractionalization 0.740740741	polarization 0.761316872
simqisetx fractionalization 0.747922438	polarization 0.752296253
simqisetx fractionalization 0.75	        polarization 0.75
simqi

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11



****** REPLICATE RESULTS OF THE SURVIVIAL ANALYSIS
* use "INSERT DIRECTORY HERE/butcher2014monthly.dta", replace
set more off

***** Produce Table 4
stset warmonths, id(epid) failure(in25k20)
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr
est store M1

**** Controlling for rebel strength
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea rebstrord if coup==0, vce(cluster gwnoa) nohr
est store M2

**** Mutipolar/Bipolar
stcox multipolar2lag1 bipolarlag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr
est store M3

***** Tests with the dependent variable as whether or not the average location of fighting was within 25km of the capital

stset warmonths, id(epid) failure(in25kmean)
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr
est store M4

*** Produce Figure 5

stcurve, survival at1(fractionalization2lag1=0.038 polarization2lag1=0.076) at2(fractionalization2lag1=0.5 polarization2lag1=1) at3(fractionalization2lag1=0.6666 polarization2lag1=0.8889) 

***** Controlling for rebel strength

stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea rebstrord if coup==0, vce(cluster gwnoa) nohr
est store M5

**** Mutipolar/Bipolar
stcox multipolar2lag1 bipolarlag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr
est store M6

est table M1 M2 M3 M4 M5 M6, b(%8.3f)  star (.05 .01 .001) stats(N)



******* DIAGNOSTICS FOR THE SURVIVIAL MODELS - REPORTED IN THE ONLINE APPENDIX

******* Testing the proportional hazards assumption
stset warmonths, id(epid) failure(in25k20)
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr tvc(fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea) texp(ln(_t))
est store PH1


**** possible non-proprtionalality for divided, milper and lnarea. Res-testing with these interactions retained. 
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr tvc(dividedlag1 lnmilperlag1 lnarea) texp(ln(_t))
est store PH2

est table PH1 PH2, b(%8.3f)  star (.05 .01 .001) stats(N)
***** Second test of proportional hazards assumption using Schoenfield residuals - little evidence of violation of PH assumption
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
stphtest, plot(fractionalization2lag1) msym(oh)
stphtest, plot(polarization2lag1) msym(oh)
stphtest, plot(dividedlag1) msym(oh)
stphtest, plot(lnrgdpchimplag1) msym(oh)
stphtest, plot(lnmilperlag1) msym(oh)
stphtest, plot(lnarea) msym(oh)
drop sch1-sca6

***** Testing other parametric models
***** Weibull
streg fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr d(weibull)
est store M1
***** Exponential
streg fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr d(exp)
est store M2
***** model with Incompatibility
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea incomp if coup==0, vce(cluster gwnoa) nohr 
est store M3
**** Model with measures of fractionalization and polarization that do not include the non-state war actors. 
stcox fractionalizationlag1 polarizationlag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea incomp if coup==0, vce(cluster gwnoa) nohr 
est store M4
***** Model without influential cases
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0 & epid!=8613441 & epid!=9012709 & epid!=19111665 & epid!=14614761, vce(cluster gwnoa) nohr 
est store M5
****** Testing with Dependent variable of fighting within 10km
stset warmonths, id(epid) failure(in10k20)
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr 
est store M6


****** Testing the proportional Hazards assumption when average fighting within 25km is used. 
stset warmonths, id(epid) failure(in25kmean)
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr tvc(fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea) texp(ln(_t))
est store PH3

***** Second test of proportional hazards assumption using Schoenfield residuals - little evidence of violation of PH assumption
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
stphtest, plot(fractionalization2lag1) msym(oh)
stphtest, plot(polarization2lag1) msym(oh)
stphtest, plot(dividedlag1) msym(oh)
stphtest, plot(lnrgdpchimplag1) msym(oh)
stphtest, plot(lnmilperlag1) msym(oh)
stphtest, plot(lnarea) msym(oh)

drop sch1-sca6
***** Testing other parametric models
***** Weibull
streg fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr d(weibull)
est store M7
***** Exponential
streg fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr d(exp)
est store M8

**** Model with Incompatibility
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea incomp if coup==0, vce(cluster gwnoa) nohr 
est store M9
**** Model with measures of fractionalization and polarization that does not include the non-state war actors. 
stcox fractionalizationlag1 polarizationlag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea incomp if coup==0, vce(cluster gwnoa) nohr 
est store M10
**** Model without influential cases
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0 & epid!=8613441 & epid!=17911233 & epid!=14610952, vce(cluster gwnoa) nohr 
est store M11
****** Testing with Dependent variable of fighting within 10km
stset warmonths, id(epid) failure(in10kmean)
stcox fractionalization2lag1 polarization2lag1 dividedlag1 lnrgdpchimplag1 lnmilperlag1 lnarea if coup==0, vce(cluster gwnoa) nohr 
est store M12



est table M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, b(%8.3f)  star (.05 .01 .001) stats(N)

est table M11 M12, b(%8.3f)  star (.05 .01 .001) stats(N)


est table PH1 PH2 PH3, b(%8.3f)  star (.05 .01 .001) stats(N)

 
