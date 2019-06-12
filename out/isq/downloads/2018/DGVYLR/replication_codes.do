********************************************************* 
**					Replication code				   **
**													   **	
**  Chinese Citizens’ Trust in Japan and South Korea:  **
**        Findings from a Four-City Survey             **
**													   **	
**				    November 11, 2015 				   **	
*********************************************************

**no need to run the following codes if using the replication dataset**

**rescaling the dependent variable

*replace nationalism = 5 - nationalism
*replace jchinarise = 5 - jchinarise
*replace kchinarise = 5 - kchinarise
*replace nanjing = 5 - nanjing
*replace koreanwar = 5-koreanwar
*replace c6e = 5 - c6e //nationalism using one question

**other controls

*gen rural=0
*replace rural=1 if a4==1
*replace rural=1 if a4==3

*gen minority=0
*replace minority=1 if a7==7

*gen language=1
*replace language=0 if k1 ==0 

*gen married=0
*replace married =1 if k7==1

*gen job=0
*replace job =1 if k9==1

**rescaling trust

*gen trust2=trust
*replace trust2=1 if trust<2
*replace trust2=2 if trust>=2 & trust <=4
*replace trust2=3 if trust>=5 & trust <=7
*replace trust2=4 if trust>=8

**multiple imputation 

*mi set wide

*mi register imputed trustjapan trustkorea peacefulnegocj supportjapanun ///
*nationalism jchinarise kchinarise trust japandiff koreadiff nanjing koreanwar ///
*c6e c6a b9b b9c b9f c4c c4d c4e c4f education socialstatus e4 b5a d5 d7 e1 e2 ///
*z1 z2 z3 z4 z5 z6 

*mi register regular age male ccp k2 rural minority language married job

*mi impute chained (ologit) peacefulnegocj supportjapanun (reg) trustjapan trustkorea  ///
*nationalism jchinarise kchinarise trust japandiff koreadiff nanjing koreanwar ///
*c6e b9c c4c c4d education socialstatus e4 b5a d5 d7 e1 e2= age male ccp k2 rural ///
*minority language married job, *add(5) rseed(88) savetrace(extrace, replace) burnin(100)

**mi extract 0

*mi passive: gen peacefulnegocj_dummy = peacefulnegocj
*mi passive: replace peacefulnegocj_dummy = 1 if peacefulnegocj > 2
*mi passive: replace peacefulnegocj_dummy = 0 if peacefulnegocj < 3

*mi passive: gen supportjapanun_dummy = supportjapanun
*mi passive: replace supportjapanun_dummy = 1 if supportjapanun > 2
*mi passive: replace supportjapanun_dummy = 0 if supportjapanun < 3

*******no need to run the above codes if using the replication dataset******

**Table 1 (using imputation #5)

pwcorr  c6e b9c jchinarise c4c nanjing trustjapan if _mi_m==5, sig

pwcorr  c6e b9c kchinarise c4d koreanwar trustkorea if _mi_m==5, sig


**Table 2
**using mibeta (need to install) to obtain the R-squared measures over imputed data

mi estimate: reg trustjapan age male education socialstatus ccp e4 b5a k2 , robust
mibeta trustjapan age male education socialstatus ccp e4 b5a k2 , robust

mi estimate: reg trustjapan age male education socialstatus ccp e4 b5a k2 c6e jchinarise b9c c4c nanjing, robust
mibeta trustjapan age male education socialstatus ccp e4 b5a k2 c6e jchinarise b9c c4c nanjing, robust

mi estimate: reg trustkorea age male education socialstatus ccp e6 b5b k2, robust
mibeta trustkorea age male education socialstatus ccp e6 b5b k2, robust

mi estimate: reg trustkorea age male education socialstatus ccp e6 b5b k2 c6e kchinarise b9c c4d koreanwar, robust
mibeta trustkorea age male education socialstatus ccp e6 b5b k2 c6e kchinarise b9c c4d koreanwar, robust


**eta square
**Note that this uses the user-written function regeffectsize.
**The final eta-square is the average of those across the five imputations
**Because regeffectsize does not store values from its output, the average is calculated by hand

qui mi query
qui local M=r(M)
mi xeq 1/`M': reg trustjapan age male education socialstatus ccp e4 b5a k2 c6e jchinarise b9c c4c nanjing; regeffectsize

qui mi query
qui local M=r(M)
mi xeq 1/`M': reg trustkorea age male education socialstatus ccp e6 b5b k2 c6e kchinarise b9c c4d koreanwar; regeffectsize


**Table 3

mi estimate: probit peacefulnegocj_dummy age male education socialstatus ccp e4 b5a k2 , robust
qui mi query
qui local M=r(M)
qui scalar ll=0
qui scalar chi2=0
qui mi xeq 1/`M': probit peacefulnegocj_dummy age male education socialstatus ccp e4 b5a k2; scalar ll=ll+e(ll); scalar chi2= chi2+e(chi2)
qui scalar ll=ll/`M'
qui scalar chi2=chi2/`M'
noi di "Log-likelihood = " ll
noi di "Chi2 = " chi2

mi estimate: probit peacefulnegocj_dummy age male education socialstatus ccp e4 b5a k2 trustjapan , robust
qui mi query
qui local M=r(M)
qui scalar ll=0
qui scalar chi2=0
qui mi xeq 1/`M': probit peacefulnegocj_dummy age male education socialstatus ccp e4 b5a k2 trustjapan; scalar ll=ll+e(ll); scalar chi2= chi2+e(chi2)
qui scalar ll=ll/`M'
qui scalar chi2=chi2/`M'
noi di "Log-likelihood = " ll
noi di "Chi2 = " chi2

mi estimate: probit supportjapanun_dummy age male education socialstatus ccp e4 b5a k2 , robust
qui mi query
qui local M=r(M)
qui scalar ll=0
qui scalar chi2=0
qui mi xeq 1/`M': probit supportjapanun_dummy age male education socialstatus ccp e4 b5a k2; scalar ll=ll+e(ll); scalar chi2= chi2+e(chi2)
qui scalar ll=ll/`M'
qui scalar chi2=chi2/`M'
noi di "Log-likelihood = " ll
noi di "Chi2 = " chi2

mi estimate: probit supportjapanun_dummy age male education socialstatus ccp e4 b5a k2 trustjapan , robust
qui mi query
qui local M=r(M)
qui scalar ll=0
qui scalar chi2=0
qui mi xeq 1/`M': probit supportjapanun_dummy age male education socialstatus ccp e4 b5a k2 trustjapan; scalar ll=ll+e(ll); scalar chi2= chi2+e(chi2)
qui scalar ll=ll/`M'
qui scalar chi2=chi2/`M'
noi di "Log-likelihood = " ll
noi di "Chi2 = " chi2

**Figure 2.1 and 2.2

mi convert flong, clear
probit peacefulnegocj_dummy age male education socialstatus ccp e4 b5a k2 trustjapan if _mi_m==5, robust
margins, at(trustjapan=(0(1)10)) post
estimates store m1
coefplot m1, at ytitle(Predicted Probablity of Support) xtitle(Trust in Japan) ///
	recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash))
	
probit supportjapanun_dummy age male education socialstatus ccp e4 b5a k2 trustjapan if _mi_m==5, robust
margins, at(trustjapan=(0(1)10)) post
estimates store m2
coefplot m2, at ytitle(Predicted Probablity of Support) xtitle(Trust in Japan) ///
	recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash))

**Table 4: subsample

//peaceful negotiation

//party member
mi estimate: probit peacefulnegocj_dummy age male socialstatus e4 b5a k2 trustjapan if ccp==1, robust
//college and above
mi estimate: probit peacefulnegocj_dummy age male socialstatus e4 b5a k2 trustjapan if a3a>=7, robust
//managers
mi estimate: probit peacefulnegocj_dummy age male socialstatus e4 b5a k2 trustjapan if k10a<=3, robust

//Japan UNSC bid

//party member
mi estimate: probit supportjapanun_dummy age male socialstatus e4 b5a k2 trustjapan if ccp==1, robust
//college and above
mi estimate: probit supportjapanun_dummy age male socialstatus e4 b5a k2 trustjapan if a3a>=7, robust
//managers
mi estimate: probit supportjapanun_dummy age male socialstatus e4 b5a k2 trustjapan if k10a<=3, robust
	
	
*SEM (using the data without imputation)
**we need to rescale the following three variables for the SEM as convergence is much faster this way
**this means that in the output, the sign for the coefficients needs to be reversed for these variables
**unless the dependent variable in the path is also one of these three variables

replace nationalism = 5 - nationalism
replace jchinarise = 5 - jchinarise
replace nanjing = 5 - nanjing

sem (male -> jchinarise, ) (male -> japandiff, ) (male -> trust, ) (male -> nationalism, ) ///
(male -> nanjing, ) (male -> trustjapan, ) (male -> supportjapanun, ) (age -> jchinarise, ) /// 
(age -> japandiff, ) (age -> trust, ) (age -> nationalism, ) (age -> nanjing, ) ///
(age -> trustjapan, ) (age -> supportjapanun, ) (education -> jchinarise, ) ///
(education -> japandiff, ) (education -> trust, ) (education -> nationalism, ) ///
 (education -> nanjing, ) (education -> trustjapan, ) (education -> supportjapanun, ) ///
 (socialstatus -> jchinarise, ) (socialstatus -> japandiff, ) (socialstatus -> trust, ) ///
 (socialstatus -> nationalism, ) (socialstatus -> nanjing, ) (socialstatus -> trustjapan, ) ///
 (socialstatus -> supportjapanun, ) (ccp -> jchinarise, ) (ccp -> japandiff, ) ///
 (ccp -> trust, ) (ccp -> nationalism, ) (ccp -> nanjing, ) (ccp -> trustjapan, ) ///
 (ccp -> supportjapanun, ) (e4 -> jchinarise, ) (e4 -> japandiff, ) (e4 -> nanjing, ) ///
 (e4 -> trustjapan, ) (e4 -> supportjapanun, ) (jchinarise -> trustjapan, ) ///
 (jchinarise -> supportjapanun, ) (japandiff -> trustjapan, ) (japandiff -> supportjapanun, ) ///
 (trust -> jchinarise, ) (trust -> japandiff, ) (trust -> nanjing, ) (trust -> trustjapan, ) ///
 (trust -> supportjapanun, ) (nationalism -> jchinarise, ) (nationalism -> japandiff, ) ///
 (nationalism -> nanjing, ) (nationalism -> trustjapan, ) (nationalism -> supportjapanun, ) ///
 (nanjing -> trustjapan, ) (nanjing -> supportjapanun, ) (trustjapan -> jchinarise, ) ///
 (trustjapan -> japandiff, ) (trustjapan -> nanjing, ) (trustjapan -> supportjapanun, ) ///
 (b5a -> jchinarise, ) (b5a -> japandiff, ) (b5a -> nanjing, ) (b5a -> trustjapan, ) ///
 (b5a -> supportjapanun, ) (k2 -> jchinarise, ) (k2 -> japandiff, ) (k2 -> trust, ) ///
 (k2 -> nationalism, ) (k2 -> nanjing, ) (k2 -> trustjapan, ) (k2 -> supportjapanun, ) if _mi_m==0, ///
 method(mlmv) cov( age*male education*male education*age socialstatus*male socialstatus*age ///
 socialstatus*education ccp*male ccp*age ccp*education ccp*socialstatus e4*male e4*age ///
 e4*education e4*socialstatus e4*ccp b5a*male b5a*age b5a*education b5a*socialstatus ///
 b5a*ccp b5a*e4 k2*male k2*age k2*education k2*socialstatus k2*ccp k2*e4 k2*b5a) nocapslatent

 **Table 5: total effects 
 
estat teffects

**rescale the variables back for the remainder of the analysis 
replace nationalism = 5 - nationalism
replace jchinarise = 5 - jchinarise
replace nanjing = 5 - nanjing

**Appendix A

**Table A2
pwcorr  c6e b9c jchinarise c4c nanjing trustjapan if _mi_m==0, sig

pwcorr  c6e b9c kchinarise c4d koreanwar trustkorea if _mi_m==0, sig

**Table A3

reg trustjapan age male education socialstatus ccp e4 b5a k2 if _mi_m==0, robust
qui reg trustjapan age male education socialstatus ccp e4 b5a k2 if _mi_m==0
regeffectsize

reg trustjapan age male education socialstatus ccp e4 b5a k2 c6e jchinarise b9c c4c nanjing if _mi_m==0, robust
qui reg trustjapan age male education socialstatus ccp e4 b5a k2 c6e jchinarise b9c c4c nanjing if _mi_m==0
regeffectsize

reg trustkorea age male education socialstatus ccp e6 b5b k2 if _mi_m==0, robust
qui reg trustkorea age male education socialstatus ccp e6 b5b k2 if _mi_m==0
regeffectsize

reg trustkorea age male education socialstatus ccp e6 b5b k2 c6e kchinarise b9c c4d koreanwar if _mi_m==0, robust
qui reg trustkorea age male education socialstatus ccp e6 b5b k2 c6e kchinarise b9c c4d koreanwar if _mi_m==0 
regeffectsize

**Table A4

probit peacefulnegocj_dummy age male education socialstatus ccp e4 b5a k2 if _mi_m==0 , robust

probit peacefulnegocj_dummy age male education socialstatus ccp e4 b5a k2 trustjapan if _mi_m==0, robust

probit supportjapanun_dummy age male education socialstatus ccp e4 b5a k2 if _mi_m==0, robust 

probit supportjapanun_dummy age male education socialstatus ccp e4 b5a k2 trustjapan if _mi_m==0, robust

**Appendix B

**B1 Exploratory Factor Analysis

factor  b9b b9c b9f c4a c4c c4e c6a c6b c6c c6d c6e c6f d4 e10c b6b e9d if _mi_m==0 , ipf factor(5)

rotate, varimax horst

**Japan
factor  b9b b9c b9f c4c c4e c6a c6e e10c e9d if _mi_m==0 , ipf factor(5)
rotate, varimax horst

**Korea
factor  b9b b9c b9f c4d c4f c6a c6e e10d e9e if _mi_m==0 , ipf factor(5)
rotate, varimax horst

**Table B1.3

mi estimate: reg trustjapan age male education socialstatus ccp e4 b5a k2 , robust
mibeta trustjapan age male education socialstatus ccp e4 b5a k2 , robust

mi estimate: reg  trustjapan age male education socialstatus ccp e4 b5a k2 nationalism jchinarise trust japandiff nanjing, robust
mibeta trustjapan age male education socialstatus ccp e4 b5a k2 nationalism jchinarise trust japandiff nanjing, robust

mi estimate: reg  trustkorea age male education socialstatus ccp e6 b5b k2, robust
mibeta trustkorea age male education socialstatus ccp e6 b5b k2, robust

mi estimate: reg  trustkorea age male education socialstatus ccp e6 b5b k2 nationalism kchinarise trust koreadiff koreanwar, robust
mibeta trustkorea age male education socialstatus ccp e6 b5b k2 nationalism kchinarise trust koreadiff koreanwar, robust

qui mi query
qui local M=r(M)
mi xeq 1/`M': reg trustjapan age male education socialstatus ccp e4 b5a k2 nationalism jchinarise trust japandiff nanjing; regeffectsize

qui mi query
qui local M=r(M)
mi xeq 1/`M': reg trustkorea age male education socialstatus ccp e6 b5b k2 nationalism kchinarise trust koreadiff koreanwar; regeffectsize

**Table B2.2

mi passive: gen b9c_2 = b9c
mi passive: replace b9c_2 = 1 if b9c <= 1
mi passive: replace b9c_2 = 2 if b9c >= 2 & b9c <= 4
mi passive: replace b9c_2 = 3 if b9c >= 5 & b9c <= 7
mi passive: replace b9c_2 = 4 if b9c >= 8 & b9c <= 10

mi estimate: reg trustjapan age male education socialstatus ccp e4 b5a k2 c6e jchinarise b9c_2 c4c nanjing, robust
mibeta trustjapan age male education socialstatus ccp e4 b5a k2 c6e jchinarise b9c_2 c4c nanjing, robust

mi estimate: reg trustkorea age male education socialstatus ccp e6 b5b k2 c6e kchinarise b9c_2 c4d koreanwar, robust
mibeta trustkorea age male education socialstatus ccp e6 b5b k2 c6e kchinarise b9c_2 c4d koreanwar, robust

qui mi query
qui local M=r(M)
mi xeq 1/`M': reg trustjapan age male education socialstatus ccp e4 b5a k2 c6e jchinarise b9c_2 c4c nanjing; regeffectsize

qui mi query
qui local M=r(M)
mi xeq 1/`M': reg trustkorea age male education socialstatus ccp e6 b5b k2 c6e kchinarise b9c_2 c4d koreanwar; regeffectsize

**Table B3.1
mi estimate: reg trustjapan age male education socialstatus ccp e4 b5a k2 c6e , robust
mibeta trustjapan age male education socialstatus ccp e4 b5a k2 c6e , robust
mi estimate: reg trustjapan age male education socialstatus ccp e4 b5a k2  jchinarise , robust
mibeta trustjapan age male education socialstatus ccp e4 b5a k2  jchinarise , robust
mi estimate: reg trustjapan age male education socialstatus ccp e4 b5a k2   b9c  , robust
mibeta trustjapan age male education socialstatus ccp e4 b5a k2   b9c  , robust
mi estimate: reg trustjapan age male education socialstatus ccp e4 b5a k2 c4c , robust
mibeta trustjapan age male education socialstatus ccp e4 b5a k2 c4c , robust
mi estimate: reg trustjapan age male education socialstatus ccp e4 b5a k2  nanjing, robust
mibeta trustjapan age male education socialstatus ccp e4 b5a k2  nanjing, robust

**Table B3.2
mi estimate: reg trustkorea age male education socialstatus ccp e4 b5a k2 c6e , robust
mibeta trustkorea age male education socialstatus ccp e4 b5a k2 c6e , robust
mi estimate: reg trustkorea age male education socialstatus ccp e4 b5a k2  kchinarise , robust
mibeta trustkorea age male education socialstatus ccp e4 b5a k2  kchinarise , robust
mi estimate: reg trustkorea age male education socialstatus ccp e4 b5a k2 b9c , robust
mibeta trustkorea age male education socialstatus ccp e4 b5a k2 b9c , robust
mi estimate: reg trustkorea age male education socialstatus ccp e4 b5a k2 c4d , robust
mibeta trustkorea age male education socialstatus ccp e4 b5a k2 c4d , robust
mi estimate: reg trustkorea age male education socialstatus ccp e4 b5a k2 koreanwar, robust
mibeta trustkorea age male education socialstatus ccp e4 b5a k2 koreanwar, robust

**Table B4

mi estimate: oprobit peacefulnegocj age male education socialstatus ccp e4 b5a k2 , robust
qui mi query
qui local M=r(M)
qui scalar ll=0
qui scalar chi2=0
qui mi xeq 1/`M': oprobit peacefulnegocj age male education socialstatus ccp e4 b5a k2; scalar ll=ll+e(ll); scalar chi2= chi2+e(chi2)
qui scalar ll=ll/`M'
qui scalar chi2=chi2/`M'
noi di "Log-likelihood = " ll
noi di "Chi2 = " chi2

mi estimate: oprobit peacefulnegocj age male education socialstatus ccp e4 b5a k2 trustjapan , robust
qui mi query
qui local M=r(M)
qui scalar ll=0
qui scalar chi2=0
qui mi xeq 1/`M': oprobit peacefulnegocj age male education socialstatus ccp e4 b5a k2 trustjapan; scalar ll=ll+e(ll); scalar chi2= chi2+e(chi2)
qui scalar ll=ll/`M'
qui scalar chi2=chi2/`M'
noi di "Log-likelihood = " ll
noi di "Chi2 = " chi2

mi estimate: oprobit supportjapanun age male education socialstatus ccp e4 b5a k2 , robust
qui mi query
qui local M=r(M)
qui scalar ll=0
qui scalar chi2=0
qui mi xeq 1/`M': oprobit supportjapanun age male education socialstatus ccp e4 b5a k2; scalar ll=ll+e(ll); scalar chi2= chi2+e(chi2)
qui scalar ll=ll/`M'
qui scalar chi2=chi2/`M'
noi di "Log-likelihood = " ll
noi di "Chi2 = " chi2

mi estimate: oprobit supportjapanun age male education socialstatus ccp e4 b5a k2 trustjapan , robust
qui mi query
qui local M=r(M)
qui scalar ll=0
qui scalar chi2=0
qui mi xeq 1/`M': oprobit supportjapanun age male education socialstatus ccp e4 b5a k2 trustjapan; scalar ll=ll+e(ll); scalar chi2= chi2+e(chi2)
qui scalar ll=ll/`M'
qui scalar chi2=chi2/`M'
noi di "Log-likelihood = " ll
noi di "Chi2 = " chi2

**Figure B4

ologit e9b age male a3a k13 b9d if _mi_m==0, robust

prgen b9d, from (0) to(10) x(male=1) ncases(11) generate(prdt)

graph twoway (scatter prdtp1 prdtp2 prdtp3 prdtp4 prdtx, msymbol(Oh Dh Sh Th) c(l l l l) xtitle("generalized trust") ytitle("Predicted Probability") xlabel(0(1)10) ylabel(0 .25 .50 ) )

drop prdt*

ologit e9g age male a3a k13 b9d if _mi_m==0, robust

prgen b9d, from (0) to(10) x(male=1) ncases(11) generate(prdt)

graph twoway (scatter prdtp1 prdtp2 prdtp3 prdtp4 prdtx, msymbol(Oh Dh Sh Th) c(l l l l) xtitle("generalized trust") ytitle("Predicted Probability") xlabel(0(1)10) ylabel(0 .25 .50 ) )

drop prdt*


**B5

**Table B5.1

mi passive: gen others = z7
mi passive: replace others = 0 if z7 == 5

mi passive: gen suspicion = z3
mi passive: replace suspicion = 3 if z3 == 5
mi passive: replace suspicion = 2 if z3 == 3

mi passive: gen credible = z4
mi passive: replace credible = 3 if z4 == 1
mi passive: replace credible = 2 if z4 == 3
mi passive: replace credible = 1 if z4 == 5

mi estimate: reg trustjapan age male education socialstatus ccp e4 b5a k2 rural minority language married job d5 e1 c6e jchinarise b9c c4c nanjing, robust
mibeta trustjapan age male education socialstatus ccp e4 b5a k2 rural minority language married job d5 e1 c6e jchinarise b9c c4c nanjing, robust

mi estimate: reg trustjapan age male education socialstatus ccp e4 b5a k2 rural minority language married job d5 e1 z1 z2 suspicion credible z5 z6 others c6e jchinarise b9c c4c nanjing, robust
mibeta trustjapan age male education socialstatus ccp e4 b5a k2 rural minority language married job d5 e1 z1 z2 suspicion credible z5 z6 others c6e jchinarise b9c c4c nanjing, robust

mi estimate: reg trustkorea age male education socialstatus ccp e6 b5b k2 rural minority language married job d7 e2 c6e kchinarise b9c c4d koreanwar , robust
mibeta trustkorea age male education socialstatus ccp e6 b5b k2 rural minority language married job d7 e2 c6e kchinarise b9c c4d koreanwar , robust

mi estimate: reg trustkorea age male education socialstatus ccp e6 b5b k2 rural minority language married job d7 e2 z1 z2 suspicion credible z5 z6 others c6e kchinarise b9c c4d koreanwar, robust
mibeta trustkorea age male education socialstatus ccp e6 b5b k2 rural minority language married job d7 e2 z1 z2 suspicion credible z5 z6 others c6e kchinarise b9c c4d koreanwar, robust

**Table B5.2

mi estimate: probit peacefulnegocj_dummy age male education socialstatus ccp e4 b5a k2 rural minority language married job d5 e1 trustjapan , robust
qui mi query
qui local M=r(M)
qui scalar ll=0
qui scalar chi2=0
qui mi xeq 1/`M': probit peacefulnegocj_dummy age male education socialstatus ccp e4 b5a k2 rural minority language married job d5 e1 trustjapan ; scalar ll=ll+e(ll); scalar chi2= chi2+e(chi2)
qui scalar ll=ll/`M'
qui scalar chi2=chi2/`M'
noi di "Log-likelihood = " ll
noi di "Chi2 = " chi2

mi estimate: probit peacefulnegocj_dummy age male education socialstatus ccp e4 b5a k2 rural minority language married job d5 e1 z1 z2 suspicion credible z5 z6 others trustjapan , robust
qui mi query
qui local M=r(M)
qui scalar ll=0
qui scalar chi2=0
qui mi xeq 1/`M': probit peacefulnegocj_dummy age male education socialstatus ccp e4 b5a k2 rural minority language married job d5 e1 z1 z2 suspicion credible z5 z6 others trustjapan ; scalar ll=ll+e(ll); scalar chi2= chi2+e(chi2)
qui scalar ll=ll/`M'
qui scalar chi2=chi2/`M'
noi di "Log-likelihood = " ll
noi di "Chi2 = " chi2

mi estimate: probit supportjapanun_dummy age male education socialstatus ccp e4 b5a k2 rural minority language married job d5 e1 trustjapan , robust
qui mi query
qui local M=r(M)
qui scalar ll=0
qui scalar chi2=0
qui mi xeq 1/`M': probit supportjapanun_dummy age male education socialstatus ccp e4 b5a k2 rural minority language married job d5 e1 trustjapan ; scalar ll=ll+e(ll); scalar chi2= chi2+e(chi2)
qui scalar ll=ll/`M'
qui scalar chi2=chi2/`M'
noi di "Log-likelihood = " ll
noi di "Chi2 = " chi2

mi estimate: probit supportjapanun_dummy age male education socialstatus ccp e4 b5a k2 rural minority language married job d5 e1 z1 z2 suspicion credible z5 z6 others trustjapan , robust
qui mi query
qui local M=r(M)
qui scalar ll=0
qui scalar chi2=0
mi xeq 1/`M': probit supportjapanun_dummy age male education socialstatus ccp e4 b5a k2 rural minority language married job d5 e1 z1 z2 suspicion credible z5 z6 others trustjapan ; scalar ll=ll+e(ll); scalar chi2= chi2+e(chi2)
qui scalar ll=ll/`M'
qui scalar chi2=chi2/`M'
noi di "Log-likelihood = " ll
noi di "Chi2 = " chi2



**Table C2
**we need to rescale the following three variables for the SEM as convergence is much faster this way
**this means that in the output, the sign for the coefficients needs to be reversed for these variables
**unless the dependent variable in the path is also one of these three variables

replace nationalism = 5 - nationalism
replace jchinarise = 5 - jchinarise
replace nanjing = 5 - nanjing

sem (male -> jchinarise, ) (male -> japandiff, ) (male -> trust, ) (male -> nationalism, ) ///
 (male -> nanjing, ) (male -> trustjapan, ) (male -> peacefulnegocj, ) (age -> jchinarise, ) ///
 (age -> japandiff, ) (age -> trust, ) (age -> nationalism, ) (age -> nanjing, ) ///
 (age -> trustjapan, ) (age -> peacefulnegocj, ) (education -> jchinarise, ) ///
 (education -> japandiff, ) (education -> trust, ) (education -> nationalism, ) ///
 (education -> nanjing, ) (education -> trustjapan, ) (education -> peacefulnegocj, ) ///
 (socialstatus -> jchinarise, ) (socialstatus -> japandiff, ) (socialstatus -> trust, ) ///
 (socialstatus -> nationalism, ) (socialstatus -> nanjing, ) (socialstatus -> trustjapan, ) ///
 (socialstatus -> peacefulnegocj, ) (ccp -> jchinarise, ) (ccp -> japandiff, ) (ccp -> trust, ) ///
 (ccp -> nationalism, ) (ccp -> nanjing, ) (ccp -> trustjapan, ) (ccp -> peacefulnegocj, ) ///
 (e4 -> jchinarise, ) (e4 -> japandiff, ) (e4 -> nanjing, ) (e4 -> trustjapan, ) ///
 (e4 -> peacefulnegocj, ) (jchinarise -> trustjapan, ) (jchinarise -> peacefulnegocj, ) ///
 (japandiff -> trustjapan, ) (japandiff -> peacefulnegocj, ) (trust -> jchinarise, ) ///
 (trust -> japandiff, ) (trust -> nanjing, ) (trust -> trustjapan, ) (trust -> peacefulnegocj, ) ///
 (nationalism -> jchinarise, ) (nationalism -> japandiff, ) (nationalism -> nanjing, ) ///
 (nationalism -> trustjapan, ) (nationalism -> peacefulnegocj, ) (nanjing -> trustjapan, ) ///
 (nanjing -> peacefulnegocj, ) (trustjapan -> jchinarise, ) (trustjapan -> japandiff, ) ///
 (trustjapan -> nanjing, ) (trustjapan -> peacefulnegocj, ) (b5a -> jchinarise, ) ///
 (b5a -> japandiff, ) (b5a -> nanjing, ) (b5a -> trustjapan, ) (b5a -> peacefulnegocj, ) ///
 (k2 -> jchinarise, ) (k2 -> japandiff, ) (k2 -> trust, ) (k2 -> nationalism, ) ///
 (k2 -> nanjing, ) (k2 -> trustjapan, ) (k2 -> peacefulnegocj, ) if _mi_m==0, ///
 method(mlmv) cov( age*male education*male education*age socialstatus*male ///
 socialstatus*age socialstatus*education ccp*male ccp*age ccp*education ///
 ccp*socialstatus e4*male e4*age e4*education e4*socialstatus e4*ccp b5a*male ///
 b5a*age b5a*education b5a*socialstatus b5a*ccp b5a*e4 k2*male k2*age k2*education ///
 k2*socialstatus k2*ccp k2*e4 k2*b5a) nocapslatent
 
**Table C2: total effects 
 
estat teffects

**rescale the variables back  
replace nationalism = 5 - nationalism
replace jchinarise = 5 - jchinarise
replace nanjing = 5 - nanjing
 
 
 
