****Do-file for Peace from the Inside, 9 October 2012 by Isak Svensson and Mathilda Lindgren****


***Data: use "/Users/Mathilda/Dropbox/Uppsala/PhD/DPCR/Peace from the Inside/2012/Stata files/Data/Inside Peace 12 June 2012.dta"

***Descriptive information (29 vars, 357 obs)

***CLUSTERED ON COUNTRY LEVEL
***The Effects of Internal and External Mediators on Negotiated Agreements controlling for temporal dependence
*Generate time-estimates
btscs negagr year countryid, gen(nonegagryrs) nspline(3) f

*Table 1, Model 1: The effects of internal and external mediators on negotiated agreements
probit negagr internal external democracy civilwar terr coldwar sdirect duryears nonegagryrs _spline1 _spline2 _spline3, cl(countryid) nolog
outreg2 using Peaceinside1.1(country), coefastr se
test  _spline1 _spline2 _spline3

*Table 1, Model 2: The effects of internal and external mediators on negotiated agreements, controlling for interaction effects
probit negagr internal external both democracy civilwar terr coldwar sdirect duryears duryears nonegagryrs _spline1 _spline2 _spline3, cl(countryid) nolog
outreg2 using Peaceinside1.2(country), coefastr se
test  _spline1 _spline2 _spline3


***The effects of internal and external mediation accounting for selection effects and controlling for temporal dependence in a seemingly unrelated bivariate profit regression
*Table 2, Model 3: Selection effects accounting for mediation occurrence with both types of mediators included in the last step, controlling for temporal dependence
drop nonegagryrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs mediation year countryid, gen(nomedyrs) nspline(3) f
biprobit (negagr=internal external democracy civilwar terr coldwar sdirect duryears) (mediation=population democracy civilwar terr coldwar sdirect duryears nomedyrs _spline1 _spline2 _spline3), cl(countryid) nolog
outreg2 using Peaceinside2.3(country), coefastr se
test  _spline1 _spline2 _spline3

*Table 2, Model 4: Selection effects of internal, external and both mediator types included in the last step, controlling for temporal dependence 
biprobit (negagr=internal external both democracy civilwar terr coldwar sdirect duryears) (mediation=population democracy civilwar terr coldwar sdirect duryears nomedyrs _spline1 _spline2 _spline3), cl(countryid) nolog
outreg2 using Peaceinside2.4(country), coefastr se
test  _spline1 _spline2 _spline3

*Selection effects accounting for the different types of mediators (internal), controlling for temporal dependence
drop nomedyrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs internal year countryid, gen(nointernalyrs) nspline(3) f
biprobit (negagr=internal democracy civilwar terr coldwar sdirect duryears) (internal=population democracy civilwar terr coldwar sdirect duryears nointernalyrs _spline1 _spline2 _spline3), cl(countryid) nolog
outreg2 using Peaceinside2.5a(country), coefastr se
test  _spline1 _spline2 _spline3

*Selection effects accounting for the different types of mediators (external), controlling for temporal dependence
drop nointernalyrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs external year countryid, gen(noexternalyrs) nspline(3) f
biprobit (negagr=external democracy civilwar terr coldwar sdirect duryears) (external=population democracy civilwar terr coldwar sdirect duryears noexternalyrs _spline1 _spline2 _spline3), cl(countryid) nolog
outreg2 using Peaceinside2.5b(country), coefastr se
test  _spline1 _spline2 _spline3

*Selection effects accounting for negotiated agreement, controlling for temporal dependence 
drop noexternalyrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs negagr year countryid, gen(nonegagryrs) nspline(3) f
biprobit (negagr=internal external democracy civilwar terr coldwar sdirect duryears nonegagryrs _spline1 _spline2 _spline3) (mediation=population democracy civilwar terr coldwar sdirect duryears), cl(countryid) nolog
outreg2 using Peaceinside2.6(country), coefastr se
test  _spline1 _spline2 _spline3

***The occurrence of internal and external mediation as a first step in accounting for potential selection effects (see Fortna 2004) 
*Table 3, Model 5: the occurrence of internal mediation
drop nonegagryrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs internal year countryid, gen(nointernalyrs) nspline(3) f
probit internal democracy civilwar terr coldwar sdirect duryears nointernalyrs _spline1 _spline2 _spline3, cl(countryid) nolog
outreg2 using Peaceinside3.1(country), coefastr se
test  _spline1 _spline2 _spline3

*Table 3, Model 5: the occurrence of external mediation
drop nointernalyrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs external year countryid, gen(noexternalyrs) nspline(3) f
probit external democracy civilwar terr coldwar sdirect duryears noexternalyrs _spline1 _spline2 _spline3, cl(countryid) nolog
outreg2 using Peaceinside3.2(country), coefastr se
test  _spline1 _spline2 _spline3

***Test of the strength of the basic model 1 using CLARIFY on Negotiated Agreement (negagr)
drop noexternalyrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs negagr year countryid, gen(noagreemyrs) nspline(3) f
probit negagr internal external democracy civilwar terr coldwar sdirect duryears noagreemyrs _spline1 _spline2 _spline3, cl(countryid) nolog
test  _spline1 _spline2 _spline3
estsimp probit negagr internal external democracy civilwar terr coldwar sdirect duryears noagreemyrs _spline1 _spline2 _spline3, cl(countryid) nolog sims(248)
outreg2 using Peaceinside4.1(country), coefastr se
test  _spline1 _spline2 _spline3
setx mean
simqi 

*Vary Internal from 0 to 1
setx (internal) 0
simqi
setx (internal) 1
simqi

*Vary External from 0 to 1
setx (external) 0
simqi
setx (external) 1
simqi

drop b1
drop b2
drop b3
drop b4
drop b5
drop b6
drop b7
drop b8
drop b9
drop b10
drop b11
drop b12
drop b13


***Test of the strength of the basic model 2 (with interaction effect) using CLARIFY on Negotiated Agreement (negagr)
probit negagr internal external both democracy civilwar terr coldwar sdirect duryears noagreemyrs _spline1 _spline2 _spline3, cl(countryid) nolog
test  _spline1 _spline2 _spline3
estsimp probit negagr internal external both democracy civilwar terr coldwar sdirect duryears noagreemyrs _spline1 _spline2 _spline3, cl(countryid) nolog sims(248)
outreg2 using Peaceinside5.1(country), coefastr se
test  _spline1 _spline2 _spline3
setx mean
simqi

*Vary Internal from 0 to 1
setx (internal) 0
simqi
setx (internal) 1
simqi

*Vary External from 0 to 1
setx (external) 0
simqi
setx (external) 1
simqi

*Vary Both from 0 to 1
setx (both) 0
simqi
setx (both) 1
simqi


drop b1
drop b2
drop b3
drop b4
drop b5
drop b6
drop b7
drop b8
drop b9
drop b10
drop b11
drop b12
drop b13


***CLUSTERED ON CAMPAIGN LEVEL
***The Effects of Internal and External Mediators on Negotiated Agreements controlling for temporal dependence
*Generate time-estimates
btscs negagr year countryid, gen(nonegagryrs) nspline(3) f

*Table 1, Model 1: The effects of internal and external mediators on negotiated agreements
probit negagr internal external democracy civilwar terr coldwar sdirect duryears nonegagryrs _spline1 _spline2 _spline3, cl(campaignid) nolog
outreg2 using Peaceinside1.1(campaign), coefastr se
test  _spline1 _spline2 _spline3

*Table 1, Model 2: The effects of internal and external mediators on negotiated agreements, controlling for interaction effects
probit negagr internal external both democracy civilwar terr coldwar sdirect duryears duryears nonegagryrs _spline1 _spline2 _spline3, cl(campaignid) nolog
outreg2 using Peaceinside1.2(campaign), coefastr se
test  _spline1 _spline2 _spline3


***The effects of internal and external mediation accounting for selection effects and controlling for temporal dependence in a seemingly unrelated bivariate profit regression
*Table 2, Model 3: Selection effects accounting for mediation occurrence with both types of mediators included in the last step, controlling for temporal dependence
drop nonegagryrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs mediation year countryid, gen(nomedyrs) nspline(3) f
biprobit (negagr=internal external democracy civilwar terr coldwar sdirect duryears) (mediation=population democracy civilwar terr coldwar sdirect duryears nomedyrs _spline1 _spline2 _spline3), cl(campaignid) nolog
outreg2 using Peaceinside2.3(campaign), coefastr se
test  _spline1 _spline2 _spline3

*Table 2, Model 4: Selection effects of internal, external and both mediator types included in the last step, controlling for temporal dependence 
biprobit (negagr=internal external both democracy civilwar terr coldwar sdirect duryears) (mediation=population democracy civilwar terr coldwar sdirect duryears nomedyrs _spline1 _spline2 _spline3), cl(campaignid) nolog
outreg2 using Peaceinside2.4(campaign), coefastr se
test  _spline1 _spline2 _spline3

*Selection effects accounting for the different types of mediators (internal), controlling for temporal dependence
drop nomedyrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs internal year countryid, gen(nointernalyrs) nspline(3) f
biprobit (negagr=internal democracy civilwar terr coldwar sdirect duryears) (internal=population democracy civilwar terr coldwar sdirect duryears nointernalyrs _spline1 _spline2 _spline3), cl(campaignid) nolog
outreg2 using Peaceinside2.5a(campaign), coefastr se
test  _spline1 _spline2 _spline3

*Selection effects accounting for the different types of mediators (external), controlling for temporal dependence
drop nointernalyrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs external year countryid, gen(noexternalyrs) nspline(3) f
biprobit (negagr=external democracy civilwar terr coldwar sdirect duryears) (external=population democracy civilwar terr coldwar sdirect duryears noexternalyrs _spline1 _spline2 _spline3), cl(campaignid) nolog
outreg2 using Peaceinside2.5b(campaign), coefastr se
test  _spline1 _spline2 _spline3

*Selection effects accounting for negotiated agreement, controlling for temporal dependence 
drop noexternalyrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs negagr year countryid, gen(nonegagryrs) nspline(3) f
biprobit (negagr=internal external democracy civilwar terr coldwar sdirect duryears nonegagryrs _spline1 _spline2 _spline3) (mediation=population democracy civilwar terr coldwar sdirect duryears), cl(campaignid) nolog
outreg2 using Peaceinside2.6(campaign), coefastr se
test  _spline1 _spline2 _spline3

***The occurrence of internal and external mediation as a first step in accounting for potential selection effects (see Fortna 2004) 
*Table 3, Model 5: the occurrence of internal mediation
drop nonegagryrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs internal year countryid, gen(nointernalyrs) nspline(3) f
probit internal democracy civilwar terr coldwar sdirect duryears nointernalyrs _spline1 _spline2 _spline3, cl(campaignid) nolog
outreg2 using Peaceinside3.1(campaign), coefastr se
test  _spline1 _spline2 _spline3

*Table 3, Model 5: the occurrence of external mediation
drop nointernalyrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs external year countryid, gen(noexternalyrs) nspline(3) f
probit external democracy civilwar terr coldwar sdirect duryears noexternalyrs _spline1 _spline2 _spline3, cl(campaignid) nolog
outreg2 using Peaceinside3.2(campaign), coefastr se
test  _spline1 _spline2 _spline3

***Test of the strength of the basic model 1 using CLARIFY on Negotiated Agreement (negagr)
drop noexternalyrs _spline1 _spline2 _spline3 _tuntilf _prefail _frstfl
btscs negagr year countryid, gen(noagreemyrs) nspline(3) f
probit negagr internal external democracy civilwar terr coldwar sdirect duryears noagreemyrs _spline1 _spline2 _spline3, cl(campaignid) nolog
test  _spline1 _spline2 _spline3
estsimp probit negagr internal external democracy civilwar terr coldwar sdirect duryears noagreemyrs _spline1 _spline2 _spline3, cl(campaignid) nolog sims(248)
outreg2 using Peaceinside4.1(campaign), coefastr se
test  _spline1 _spline2 _spline3
setx mean
simqi 

*Vary Internal from 0 to 1
setx (internal) 0
simqi
setx (internal) 1
simqi

*Vary External from 0 to 1
setx (external) 0
simqi
setx (external) 1
simqi

drop b1
drop b2
drop b3
drop b4
drop b5
drop b6
drop b7
drop b8
drop b9
drop b10
drop b11
drop b12
drop b13


***Test of the strength of the basic model 2 (with interaction effect) using CLARIFY on Negotiated Agreement (negagr)
probit negagr internal external both democracy civilwar terr coldwar sdirect duryears noagreemyrs _spline1 _spline2 _spline3, cl(campaignid) nolog
test  _spline1 _spline2 _spline3
estsimp probit negagr internal external both democracy civilwar terr coldwar sdirect duryears noagreemyrs _spline1 _spline2 _spline3, cl(campaignid) nolog sims(248)
outreg2 using Peaceinside5.1(campaign), coefastr se
test  _spline1 _spline2 _spline3
setx mean
simqi

*Vary Internal from 0 to 1
setx (internal) 0
simqi
setx (internal) 1
simqi

*Vary External from 0 to 1
setx (external) 0
simqi
setx (external) 1
simqi

*Vary Both from 0 to 1
setx (both) 0
simqi
setx (both) 1
simqi

drop b1
drop b2
drop b3
drop b4
drop b5
drop b6
drop b7
drop b8
drop b9
drop b10
drop b11
drop b12
drop b13

