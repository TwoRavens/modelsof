set mem 500m
set matsize 800

log using "results.smcl", replace
use Preparedatafor_RESTAT, clear

* =======
* Glosary
* =======
* Carage ==> Car Age
* ClaimLR ==> Costs 
* ClaimLRrp ==> Costs (adjusted)
* Cceright ==> Size of Engine
* Edua = a ==> Academic Education
* earnedpr ==> earned premium (adjusted)
* earnedpremium ==> yearly premium multiple by the time the policy was in affect.
* Goodin1 ==> equal to 1 if the policyholder did not have claims with the insurer
* Lastyear1, lastyear2, lastyear3 ==> number of claims last year, 2 years, and 3 years ago.
* Licensey ==> License Years
* Madad ==> price index
* Main ==> equal 1 if the car serves as the policyholder's main car
* Mekif ==> yearly premium
* Modely ==> car model year
* Nofclaim ==> number of claims during the life of the policy
* Sex = 1 ==> Male
* Sumamt ==> Car Value
* Sumamtr ==> Car Value (adjusted)
* Youngi = 1 ==> if young driver is alowed to use the car
* Use ==> equal 1 if only the policyholder and/or his spouse use the car 

* Adjusting for inflation, all monetary values are stated in 2001 NIS
global lastmadad=91.73865
* price index in 2001
gen sumamtr=sumamt/madad*$lastmadad
gen logsumamtr=log(sumamtr)
gen mekifr=mekif/madad*$lastmadad
gen earnedpr=earnedprem/madad*$lastmadad
gen logearnedpr=log(earnedpr)
gen claimLRr=claimLR/madad*$lastmadad
gen claimLRrp=max(claimLRr,0)
gen logclaimLRrp=log(claimLRrp+1)

gen profitvaluep=earnedpr-claimLRrp

gen numofpastclaims=lastyear1+twoyears1+threeyears1
gen nopastclaim= numofpastclaims==0 & compexpr==0

* generate Max(company experience-3,0) and Min(company experience, 3)

* Need to correct for Total Loss claims (defining as having damage which is 70% of the car value)

* Generate Profit ratios
gen lossLR=claimLRrp/earnedpr
gen loglossLR=log(1+lossLR)

gen LRTL=lossLR
replace LRTL=(claimLRrp+(mekifr-earnedpr))/mekifr if TL==1

gen profitLRTL=1-LRTL
replace profitLRTL=1 if profitLRTL>1
gen earnedprTL=earnedpr
replace earnedprTL=mekifr if TL==1

gen age2=age^2
gen agesex=age*sex

gen year1= compyear==1
gen year2= compyear==2
gen year3= compyear==3
gen year4= compyear==4
gen year5= compyear==5
gen year6= compyear==6

* Generate interaction with company experience and clean company record

gen compexprgoodin1=compexpr*goodin1
gen logcompexpr=log(compexpr+1)
gen logcompexprgoodin1=logcompexpr*goodin1

gen exprone=compexpr if compexpr<=3
replace exprone=3 if compexpr>3
gen exprtwo=0 if compexpr<=3
replace exprtwo=compexpr-3 if compexpr>3

gen expronegoodin1=exprone*goodin1
gen exprtwogoodin1=exprtwo*goodin1

* Generate interaction with company experience, clean company record with covariants

gen compexprage = compexpr*age
gen compexprsex = compexpr*sex
gen compexpredua = compexpr*edua
gen compexprsingle = compexpr*single

gen logcompexprage = logcompexpr*age
gen logcompexprsex = logcompexpr*sex
gen logcompexpredua = logcompexpr*edua
gen logcompexprsingle = logcompexpr*single

gen exproneage = exprone*age
gen expronesex = exprone*sex 
gen exproneedua = exprone*edua 
gen expronesingle = exprone*single 
gen exprtwoage = exprtwo*age
gen exprtwosex = exprtwo*sex
gen exprtwoedua = exprtwo*edua
gen exprtwosingle = exprtwo*single

gen goodin1age = goodin1*age
gen goodin1sex = goodin1*sex
gen goodin1edua = goodin1*edua
gen goodin1single = goodin1*single

* =======
* Table 1
* =======
tabstat age sex edua single licensey sumamtr ccweight carage mainv use youngi nopastclaim if compexpr==0, by(compyear) stat(mean sd) format(%9.3f)
tab compyear if compexpr==0

* =======
* Table 2
* =======
table compexpr compyear if compyear<7 & compyear>3, c(count policynr)

* =======
* Table 3
* =======
tabstat age sex edua single licensey sumamtr ccweight carage mainv use youngi if compyear<7 & compyear>3, by(compexpr) stat(mean sd) format(%9.3f)

* =======
* Table 4
* =======
tabstat earnedpr claimLRr nofclaim if compyear<7 & compyear>3, by(compexpr) stat(mean sd) format(%9.3f)
tabstat earnedpr claimLRr nofclaim if (compyear<7 & compyear>3) & goodin1==0, by(compexpr) stat(mean sd) format(%9.3f)
tabstat earnedpr claimLRr nofclaim if (compyear<7 & compyear>3) & goodin1==1, by(compexpr) stat(mean sd) format(%9.3f)

* =======
* Table 5
* =======
qui: tobit profitLRTL compexpr age age2 sex agesex edua single compexprage compexprsex compexpredua licensey logsumamtr carage ccweight mainv use youngi year5-year6 if (compyear<7 & compyear>3), ul(1) vce(cluster polbase)
mfx compute, predict(ys(.,1))
mat coeff=e(Xmfx_dydx)'
mat se_coeff=e(Xmfx_se_dydx)'
mat mreg1=coeff, se_coeff
local R21 e(r2_a)

qui: tobit profitLRTL compexpr goodin1 age age2 sex agesex edua single compexprage compexprsex compexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5-year6 if (compyear<7 & compyear>3), ul(1) vce(cluster polbase)
mfx compute, predict(ys(.,1))
mat coeff=e(Xmfx_dydx)'
mat se_coeff=e(Xmfx_se_dydx)'
mat mreg2=coeff, se_coeff
local R22 e(r2_a)

qui: tobit profitLRTL compexpr goodin1 compexprgoodin1 age age2 sex agesex edua single compexprage compexprsex compexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5-year6 if (compyear<7 & compyear>3), ul(1) vce(cluster polbase)
mfx compute, predict(ys(.,1))
mat coeff=e(Xmfx_dydx)'
mat se_coeff=e(Xmfx_se_dydx)'
mat mreg3=coeff, se_coeff
local R23 e(r2_a)

qui: tobit profitLRTL logcompexpr goodin1 logcompexprgoodin1 age age2 sex agesex edua single logcompexprage logcompexprsex logcompexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5-year6 if (compyear<7 & compyear>3), ul(1) vce(cluster polbase)
mfx compute, predict(ys(.,1))
mat coeff=e(Xmfx_dydx)'
mat se_coeff=e(Xmfx_se_dydx)'
mat mreg4=coeff, se_coeff
local R24 e(r2_a)

qui: tobit profitLRTL exprone exprtwo goodin1 expronegoodin1 exprtwogoodin1 age age2 sex agesex edua single exproneage expronesex exproneedua exprtwoage exprtwosex exprtwoedua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5-year6 if (compyear<7 & compyear>3), ul(1) vce(cluster polbase)
mfx compute, predict(ys(.,1))
mat coeff=e(Xmfx_dydx)'
mat se_coeff=e(Xmfx_se_dydx)'
mat mreg5=coeff, se_coeff
local R25 e(r2_a)

mat2txt, matrix(mreg1) saving(mProfitLR) replace title(table 1)
foreach int in 2 3 4 5 {
    mat2txt, matrix(mreg`int') saving(mProfitLR) append title(table `int')
}
mat adjustedR=(`R21',`R22',`R23',`R24',`R25')


* =======
* Table 6
* =======
* generate cubic rote of profit value
gen profitvaluepq3=sign(profitvaluep)*abs(profitvaluep)^(1/3)

* censured whne profit equal to earned premia -- when TL instead of earned premia using yearly premium
gen censedtest1= profitvaluep==earnedpr
replace censedtest1=mekifr if TL==1

* Columns (1)-(5)

qui: cnreg profitvaluep compexpr age age2 sex agesex edua single compexprage compexprsex compexpredua licensey logsumamtr carage ccweight mainv use youngi year5 year6 if (compyear<7 & compyear>3),  vce(cluster polbase) cens(censedtest1)
estimates store reg1, title(Profit Value) 
qui: cnreg profitvaluep compexpr goodin1 age age2 sex agesex edua single compexprage compexprsex compexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5 year6 if (compyear<7 & compyear>3),  vce(cluster polbase) cens(censedtest1)
estimates store reg2, title(Profit Value) 
qui: cnreg profitvaluep compexpr goodin1 compexprgoodin1 age age2 sex agesex edua single compexprage compexprsex compexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5 year6 if (compyear<7 & compyear>3),  vce(cluster polbase) cens(censedtest1)
estimates store reg3, title(Profit Value) 
qui: cnreg profitvaluep logcompexpr goodin1 logcompexprgoodin1 age age2 sex agesex edua single logcompexprage logcompexprsex logcompexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5 year6 if (compyear<7 & compyear>3),  vce(cluster polbase) cens(censedtest1)
estimates store reg4, title(Profit Value) 
qui: cnreg profitvaluep exprone exprtwo goodin1 expronegoodin1 exprtwogoodin1 age age2 sex agesex edua single exproneage expronesex exproneedua exprtwoage exprtwosex exprtwoedua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5-year6 if (compyear<7 & compyear>3), vce(cluster polbase) cens(censedtest1)
estimates store reg5, title(Profit Value) 

xml_tab reg1 reg2 reg3 reg4 reg5, stats(N) newappend save("ProfitValue") title(censored ProfitValue) stats(N r2_p magnitude) sd2 format(Ncc04)  sheet (table_6a)
est drop reg1 reg2 reg3 reg4 reg5 

* Columns (6)-(10)

qui: cnreg profitvaluepq3 compexpr age age2 sex agesex edua single compexprage compexprsex compexpredua licensey logsumamtr carage ccweight mainv use youngi year5 year6 if (compyear<7 & compyear>3),  vce(cluster polbase) cens(censedtest1)
estimates store reg1, title(Cubic Profit Value) 
qui: cnreg profitvaluepq3 compexpr goodin1 age age2 sex agesex edua single compexprage compexprsex compexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5 year6 if (compyear<7 & compyear>3),  vce(cluster polbase) cens(censedtest1)
estimates store reg2, title(Cubic Profit Value) 
qui: cnreg profitvaluepq3 compexpr goodin1 compexprgoodin1 age age2 sex agesex edua single compexprage compexprsex compexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5 year6 if (compyear<7 & compyear>3),  vce(cluster polbase) cens(censedtest1)
estimates store reg3, title(Cubic Profit Value) 
qui: cnreg profitvaluepq3 logcompexpr goodin1 logcompexprgoodin1 age age2 sex agesex edua single logcompexprage logcompexprsex logcompexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5 year6 if (compyear<7 & compyear>3),  vce(cluster polbase) cens(censedtest1)
estimates store reg4, title(Cubic Profit Value) 
qui: cnreg profitvaluepq3 exprone exprtwo goodin1 expronegoodin1 exprtwogoodin1 age age2 sex agesex edua single exproneage expronesex exproneedua exprtwoage exprtwosex exprtwoedua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5-year6 if (compyear<7 & compyear>3), vce(cluster polbase) cens(censedtest1)
estimates store reg5, title(Cubic Profit Value) 

xml_tab reg1 reg2 reg3 reg4 reg5, stats(N) newappend save("ProfitValue") title(censored ProfitValue) stats(N r2_p magnitude) sd2 format(Ncc04)  sheet(table_6b)
est drop reg1 reg2 reg3 reg4 reg5 

* =======
* Table 7
* =======
* Columns (1)-(2)
qui: tobit claimLRrp compexpr goodin1 compexprgoodin1 age age2 sex agesex edua single compexprage compexprsex compexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5-year6 if (compyear<7 & compyear>3), ll(0) vce(cluster polbase)
mfx compute, predict(ys(0,.))

qui: tobit logclaimLRrp compexpr goodin1 compexprgoodin1 age age2 sex agesex edua single compexprage compexprsex compexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5-year6 if (compyear<7 & compyear>3), ll(0) vce(cluster polbase)
mfx compute, predict(ys(0,.))

* Columns (3)-(5)
qui: reg earnedpr compexpr goodin1 compexprgoodin1 age age2 sex agesex edua single compexprage compexprsex compexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5-year6 if (compyear<7 & compyear>3), vce(cluster polbase)
estimates store reg1, title(Earned Premium) 

qui: reg logearnedpr compexpr goodin1 compexprgoodin1 age age2 sex agesex edua single compexprage compexprsex compexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5-year6 if (compyear<7 & compyear>3), vce(cluster polbase)
estimates store reg2, title(Earned Premium) 

qui: nbreg nofclaim compexpr goodin1 compexprgoodin1 age age2 sex agesex edua single compexprage compexprsex compexpredua goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5-year6 if (compyear<7 & compyear>3), robust cluster(polbase)
estimates store reg3, title(number of claims) 

xml_tab reg1 reg2 reg3, stats(N) newappend save("ProfitValue") title(Premium_number_of_claims) stats(N r2_p magnitude) sd2 format(Ncc04) sheet(table_7a)
est drop reg1 reg2 reg3

* Columns (6)-(7)

sort policynr 
* define stayed for another year with the company
gen stayin=1 if polbase==polbase[_n+1] & compyear<7
replace stayin=0 if polbase~=polbase[_n+1] & compyear<7

gen left_firm= stayin==0
replace left_firm=. if stayin==.
* stset compexpr, failure(left_firm) id(polbase)
gen t1=compexpr+1
stset t1 left_firm, time0(compexpr) id(polbase)

* generate: Clean company record in Policy year
gen cleancurrent= nofclaim==0
* generate: Clean company record at End of Policy
gen goodin1current= (nofclaim==0 & goodin1==1)

* generate interactions
gen goodin1currage=goodin1current*age
gen goodin1currsex=goodin1current*sex 
gen goodin1curredua=goodin1current*edua

* cloumn (6)
stweib goodin1current age age2 sex agesex edua single  goodin1currage goodin1currsex goodin1curredua licensey logsumamtr carage ccweight mainv use youngi year5-year6  if (compyear<7 & compyear>3), vce(cluster polbase) 
* cloumn (7)
stweib goodin1 cleancurrent age age2 sex agesex edua single goodin1age goodin1sex goodin1edua licensey logsumamtr carage ccweight mainv use youngi year5-year6  if (compyear<7 & compyear>3), vce(cluster polbase) 


