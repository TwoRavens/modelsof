

***MBFB_combined***
keep if country == 1 | country == 3
gen y1 = ir_nopot
gen y2 = ir_pot
gen y3 = ir_prog
gen y4 = ir_natl
gen y5 = ir_pension
gen y6 = ir_fire

reshape long y, i(id) j(round)
label define  roundlab 1 "No Pot" 2 "Pot" 3 "Progressive" 4 "National" 5 "Pension" ///
 6 "Fire"
label values round roundlab

///Factor analyis of Fred's varialbes. 
factor  resp_old associations-corrupt_police, ///
 pcf factors(4)
rotate, blanks(.4)
alpha govt_individual fairness competition_good_bad opinion1 opinion7 ///
 opinion8 opinion20 opinion22 opinion_benefits resp_unemploy resp_housing  ///
 leftright, std gen(aleft)
replace aleft=aleft*-1
alpha trust_natl-corrupt_police, std gen(atrust_gb)
alpha cheat_tax cheat_benefits opinion3 opinion9n opinion13n ///
 opinion19a, std gen(aduty)
replace aduty=aduty*-1
recode male (0=1) (1=0), gen(female)

**STANDARDIZE SCALES WITH MEAN 0 AND AD 1
egen zleft=std(aleft)
egen zduty=std(aduty)
egen ztrust=std(atrust)



*CREATE FINAL PAY MEASURES
//creating standardized income variable ans standarizing variables 
gen income = 0
replace income = rows1 if round == 1| round == 2| round ==3
replace income = rows_natl if round == 4
replace income = rows_pension if round == 5
replace income = rows_fire if round == 6
sum income
gen stincome = (income-8.191162 )/2.737794 
sum stincome

gen income_new = rows1 + rows_natl+rows_pension+rows_fire 
sum income_new


///summary statistics for baseline
sutex atrust aleft aduty female  risk past employed
estpost sum econ past employed aduty atrust aleft income female if country == 1
estpost sum econ past employed aduty atrust aleft income female if country == 2
estpost sum econ past employed aduty atrust aleft income female if country == 3
estpost sum econ past employed aduty atrust aleft income female if country == 4


sutex atrust aleft aduty female  risk past employed, lab nobs key(descstat) replace ///
file(descstat.tex) title("Individual Characteristics") minmax
atrust aleft aduty female  risk past employed
su male age



matrix balance = J(18, 8, 0)
local i = 1
foreach x in  female  past employed {
	su `x'
	matrix balance [`i', 1] = r(N)
	matrix balance [`i', 2] = r(mean)
	matrix balance [`i', 3] = r(sd)
	matrix balance [`i', 4] = r(min)
	matrix balance [`i', 5] = r(max)
	
	ttest `x', by(country)
	matrix balance[`i', 6] = r(mu_1)
	matrix balance[`i', 7] = r(mu_2)
	matrix balance[`i', 8] = r(mu_1) - r(mu_2)
	local i = `i' + 1
	
	prtest `x', by(country)
	matrix balance[`i', 8] = r(z)
	local i = `i' + 1
}

foreach x in   ztrust zleft zduty risk age income  {
	su `x'
	matrix balance [`i', 1] = r(N)
	matrix balance [`i', 2] = r(mean)
	matrix balance [`i', 3] = r(sd)
	matrix balance [`i', 4] = r(min)
	matrix balance [`i', 5] = r(max)
	
	
	ttest `x', by(country)
	matrix balance[`i', 6] = r(mu_1)
	matrix balance[`i', 7] = r(mu_2)
	matrix balance[`i', 8] = r(mu_1) - r(mu_2)

	local i = `i' + 1
	
	ttest `x', by(country) unequal
	matrix balance[`i', 8] = r(t)
	local i = `i' + 1
}
matrix rownames balance = Female se Past-participation se Employed se Trust se Pro-redistribution se Duty_to_Pay se Risk se Age se Income se
matrix colnames balance =  Obs Mean sd Min Max Italy US Diff
matrix list balance
outtable using "covariate_balance_new", mat(balance) format(%9.3f) replace caption("Covariate Balance: US and Italy") 



/// regression analyses 

reg y period2 if period<=2, cluster(id)
est store equation1
reg y period2 female econ risk atrust svoa if  period<=2, cluster(id)
est store equation2
reg y period2 female econ risk past svoa employed atrust aduty aleft if  period<=2, cluster(id)
est store equation3

//effficiency 
reg y period2 if period<=2, cluster(id)
outreg2 using mbfb3.xls, long label append noobs e(N  r2) dec(3)

reg y period2 econ risk if  period<=2, cluster(id)
outreg2 using mbfb3.xls, long label append noobs e(N  r2) dec(3)

reg y period2 female econ risk past employed atrust aduty aleft ib2.country if  period<=2, cluster(id)
outreg2 using mbfb3.xls, long label append noobs e(N  r2) dec(3)

//ttest to measure perception of institutions

ttest corrupt_natl == corrupt_fire

//trust and confidence and government
reg y Pension Fire if round == 4 | round == 5 | round == 6, cluster(id)
outreg2 using mbfb4.xls, long label append noobs e(N  r2) dec(3)

reg y Pension Fire econ risk if round == 4 | round == 5 | round == 6, cluster(id)
outreg2 using mbfb4.xls, long label append noobs e(N  r2) dec(3)

reg y Pension Fire female econ risk past employed atrust_gb aduty_gb aleft_gb ib2.country if round == 4 | round == 5 | round == 6, cluster(id)
outreg2 using mbfb4.xls, long label append noobs e(N  r2) dec(3)

//ttests for each round

 ttest y if round == 1, by(country)


 ttest y if round == 2, by(country)

ttest y if round == 3, by(country)

 ttest y if round == 4, by(country)

 ttest y if round == 5, by(country)

 ttest y if round == 6, by(country)

***GLS Models***

xtreg y i.country i.round, cluster(id) 
outreg2 using mbfbtobit4.tex, long  replace tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)  ///
title("Tobit Regressions: Average Reported Income in Each Decision, All Rounds") 

xtreg y i.country  if round < 4, cluster(id) 
outreg2 using mbfbtobit4.tex, long  append tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)  


xtreg y i.country atrust aduty aleft  if round < 4, cluster(id) 
outreg2 using mbfbtobit4.tex, long label append tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)


xtreg y i.country atrust aleft aduty female if round < 4, cluster(id) 
outreg2 using mbfbtobit4.tex, long label append tex  e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)


xtreg y i.country atrust aleft aduty female  risk past employed income_new age  if round < 4, cluster(id) 
outreg2 using mbfbtobit4.tex, long label append tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)

xtreg y i.country if round > 3, cluster(id) 
outreg2 using mbfbtobit4.tex, long  append tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)  

xtreg y i.country atrust aduty aleft  if round > 3, cluster(id) 
outreg2 using mbfbtobit4.tex, long label append tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)


xtreg y i.country atrust aleft aduty female   if round > 3, cluster(id) 
outreg2 using mbfbtobit4.tex, long label append tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)

xtreg y i.country atrust aleft aduty female  risk past employed  income_new age if round > 3, cluster(id) 
outreg2 using mbfbtobit4.tex, long label append tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)

encode id, gen(id2)
xtset id2

probit fudge i.round##i.country aleft aduty female  risk past i.authority_3 age
outreg2 using mbfbtobit2.tex, long label append tex noobs e(N N_lc N_rc r2_p) dec(3)
gen prosocial = 0
replace prosocial = 1 if svoangle > 22.45



GLS

xtreg y i.country##i.round, re cluster(id)
outreg2 using xtreg3.tex, long  replace tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)  ///
title("Random Effects OLS: Average Reported Income in Each Decision")


xtreg y i.country##i.round ztrust zduty zleft, re cluster(id)
outreg2 using xtreg3.tex, long label append tex  e(chi2 N_clust N) dec(2) alpha(0.01, 0.05) 


xtreg y i.country##i.round zleft zduty female, re cluster(id)
outreg2 using xtreg3.tex, long label append tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)


xtreg y   i.country##i.round zleft zduty age past risk female employed income_new, re cluster(id)
outreg2 using xtreg3.tex, long label append tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)

set scheme plotplainblind
margins country, at(round=(1(1)6)) 
marginsplot

xtreg y   i.country##i.round ztrust zleft zduty age past risk female employed income_new, re cluster(id)
outreg2 using xtreg3.tex, long label append tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)

testparm i.country##i.round
set scheme plotplainblind
margins country, at(round=(1(1)6)) 
marginsplot

set scheme plotplainblind
margins country, at(round=(1(1)6)) 
marginsplot

xtreg y   i.country ztrust i.country##c.zleft zduty age past risk female employed income_new, re cluster(id)


test rounddum2 = rounddum3
test rounddum2= rounddum4
test rounddum2 = rounddum5
test rounddum2= rounddum6
test rounddum3= rounddum4
test rounddum3= rounddum5
test rounddum3= rounddum6
test rounddum4= rounddum5
test rounddum4= rounddum6

test US1 = US2
test US1 = US3
test US1 = US4
test US1 = US5
test US2 = US3
test US2 = US4
test US2 = US5
test US3 = US4
test US3 = US5
test US4 = US5


///GLS models on each round
reg y i.country  aleft aduty female  risk past employed  income_new age  if round == 1,  cluster(id) 
outreg2 using mbfbgls2.tex, long  replace tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)  ///
title("OLS: Average Reported Income by each Subject")

reg y i.country  aleft aduty female  risk past  employed income_new age   if round == 2,  cluster(id) 
outreg2 using mbfbgls2.tex, long  append tex e(chi2 N_clust N) dec(2) alpha(0.01, 0.05)  


reg y i.country  aleft aduty female  risk past employed income_new age  if round == 3, cluster(id) 
outreg2 using mbfbgls2.tex, long  append tex e(r2 N_clust N) dec(2) alpha(0.01, 0.05)  


reg y i.country  aleft aduty female  risk past   employed  income_new age if round == 4,  cluster(id) 
outreg2 using mbfbgls2.tex, long  append tex e(r2 N_clust N) dec(2) alpha(0.01, 0.05)  

reg y i.country  aleft aduty female  risk past  employed income_new age  if round == 5,  cluster(id) 
outreg2 using mbfbgls2.tex, long  append tex e(r2 N_clust N) dec(2) alpha(0.01, 0.05)  

reg y i.country  aleft aduty female  risk past employed income_new age  if round == 6,  cluster(id) 
outreg2 using mbfbgls2.tex, long  append tex e(r2 N_clust N) dec(2) alpha(0.01, 0.05)  

reg y i.country  atrust aleft aduty female  risk past   employed  income_new age if round == 4,  cluster(id) 
outreg2 using mbfbgls2.tex, long  append tex e(r2 N_clust N) dec(2) alpha(0.01, 0.05)  

reg y i.country  atrust aleft aduty female  risk past  employed income_new age  if round == 5,  cluster(id) 
outreg2 using mbfbgls2.tex, long  append tex e(r2 N_clust N) dec(2) alpha(0.01, 0.05)  

reg y i.country  atrust aleft aduty female  risk past employed income_new age  if round == 6,  cluster(id) 
outreg2 using mbfbgls2.tex, long  append tex e(r2 N_clust N) dec(2) alpha(0.01, 0.05)  



***Probit models on individual institution rounds***

probit cheat i.country if round == 4, cluster(id)
outreg2 using mbfbprobit.tex,   replace tex e(N ll r2_p) noobs  dec(3) ///
title("Probit Regressions: Likelihood of Reporting No Income, All Rounds") 
margins, dydx(country)


probit cheat i.country   female past    if round == 4, cluster(id)
outreg2 using mbfbprobit.tex,   append tex e(N ll r2_p) noobs  dec(3)
margins, dydx(country atrust female past)
probit cheat i.country  if round == 5, cluster(id)
outreg2 using mbfbprobit.tex,   append tex e(N ll r2_p) noobs  dec(3)
margins, dydx(country)

probit cheat i.country  atrust   female past  if round == 5, cluster(id)
outreg2 using mbfbprobit.tex,   append tex e(N ll r2_p) noobs  dec(3)
margins, dydx(country atrust female past)

probit cheat i.country if round == 6, cluster(id)
outreg2 using mbfbprobit.tex,   append tex e(N ll r2_p) noobs  dec(3)
margins, dydx(country)

probit cheat i.country atrust   female past  if round == 6, cluster(id)
outreg2 using mbfbprobit.tex,   append tex e(N ll r2_p) noobs  dec(3)
margins, dydx(country atrust female past)








***Complete honest, cheat, fudge***
gen honest =0 
replace honest = 1 if y ==1

gen fudge = 0
replace fudge =1 if y > 0 & y < 1

gen cheat = 0
replace cheat = 1 if y == 0

gen cheatnat = 0
replace cheatnat = 1 if y == 0 & round == 4

gen honestnat = 0
replace honestnat = 1 if y ==1 & round == 4

gen fudgenat = 0
replace fudgenat = 1 if y > 0 & y < 1 & round == 4

gen cheatpen = 0
replace cheatpen = 1 if y == 0 & round == 5

gen honestpen = 0
replace honestpen = 1 if y ==1 & round == 5

gen fudgepen = 0
replace fudgepen = 1 if y > 0 & y < 1 & round == 5

gen cheatfire = 0
replace cheatfire = 1 if y == 0 & round == 6

gen honestfire = 0
replace honestfire = 1 if y ==1 & round == 6

gen fudgefire = 0
replace fudgefire = 1 if y > 0 & y < 1 & round == 6

***Probit models 

probit cheat i.country  risk female past employed if round == 1| round == 2 | round == 3, cluster(id) 
outreg2 using mbfbpro.tex,   replace tex e(N ll r2_p) noobs  dec(3) /// 
	title("Tobit Regressions: Average Reported Income in Each Decision, All Rounds") 
	
probit cheat i.country  risk female past employed if round == 1| round == 2 | round == 3, cluster(id) 
outreg2 using mbfbpro.tex,   append tex e(N ll r2_p) noobs  dec(3) 
	
probit cheat i.country  risk  female past employed if round == 1, cluster(id) 
outreg2 using mbfbpro.tex, append tex e(N ll r2_p) noobs  dec(3)   

probit cheat i.country  risk female past employed if round == 2, cluster(id) 
outreg2 using mbfbpro.tex, append tex e(N ll r2_p) noobs  dec(3)  

probit cheat i.country  risk female past employed if round == 3, cluster(id) 
outreg2 using mbfbpro.tex, append tex e(N ll r2_p) noobs  dec(3)  

probit cheat i.country  risk female past employed if round == 4, cluster(id) 
outreg2 using mbfbpro.tex, append tex e(N ll r2_p) noobs  dec(3) 

probit cheat i.country  risk female past employed if round == 5, cluster(id) 
outreg2 using mbfbpro.tex, append tex e(N ll r2_p) noobs  dec(3)   

probit cheat i.country##i.round  risk female past employed if round == 6, cluster(id) 
outreg2 using mbfbpro.tex, append tex e(N ll r2_p) noobs  dec(3) 


//graphing GB
reg y ib4.round female econ risk past employed atrust_gb aduty_gb aleft_gb ib2.country if round == 4 | round == 5 | round == 6, cluster(id)

margins round
marginsplot,  scheme(lean2)

//graphing efficiency 

reg y ib1.period female econ risk past employed atrust aduty aleft if  period<=2, cluster(id)
margins period
marginsplot, scheme(lean2)

///graphing average compliance rate by country 
graph bar y, over(country)  over(round, label(angle(45))) asy ///
	ytitle("Average Reported Income") ///
	blabel(bar, size(vsmall) format(%5.2f)) ///
	title("") ///
	legend(pos(11) ring(0) region(lstyle(foreground)) ) scale(0.8) ///
	blabel(bar, position(inside) format(%9.2f)) scheme(plotplainblind)
						graph export Average_Compliance_by_country_2017-22-8.jpg, as(png) replace 
						
						
///Graphing compliance rate overall with error bars
collapse (mean) meany= y (sd) sdy=y (count) n=y, by(round)
generate hiy = meany+ invttail(n-1,0.025)*(sdy / sqrt(n))
generate lowy = meany - invttail(n-1,0.025)*(sdy / sqrt(n))
graph twoway (bar meany round) (rcap hiy lowy round)

generate roundcountry = country   if round == 1
replace roundcountry = country +4  if round == 2
replace roundcountry = country  if round == 3
replace roundcountry = country +4 if round == 4
replace roundcountry = country  if round == 5
replace roundcountry = country  +4 if round == 6



sort roundcountry
list roundcountry round country, sepby(round)

twoway (bar meany roundcountry) (rcap hiy lowy roundcountry)

twoway (bar meany roundcountry if country==1) ///
       (bar meany roundcountry if country==3) ///
       (rcap hiy lowy roundcountry), scheme(plotplainblind) ///
	    legend(row(1) order(1 "Italy" 2 "United States")
						
						
///Graphing Compliance rate by country with error bars
						
collapse (mean) meany= y (sd) sdy=y (count) n=y, by(country round)
generate hiy = meany+ invttail(n-1,0.025)*(sdy / sqrt(n))
generate lowy = meany - invttail(n-1,0.025)*(sdy / sqrt(n))
graph twoway (bar meany country) (rcap hiy lowy country), by(round)

generate roundcountry = country   if round == 1
replace roundcountry = country +2  if round == 2
replace roundcountry = country  if round == 3
replace roundcountry = country +2 if round == 4
replace roundcountry = country  if round == 5
replace roundcountry = country  +2 if round == 6



sort roundcountry
list roundcountry round country, sepby(round)

twoway (bar meany roundcountry) (rcap hiy lowy roundcountry)

twoway (bar meany roundcountry if country==1) ///
       (bar meany roundcountry if country==3) ///
       (rcap hiy lowy roundcountry), scheme(plotplainblind) ///
	    legend(row(1) order(1 "Italy" 2 "United States") ) 
		
***cumulative distribution***
preserve
keep if round == 1
cumul y if country == 1, gen(citaly)
cumul y if country == 3, gen(cus)
stack cus y  citaly y, into(c y) wide clear
line cus citaly y, sort ylab(, grid) ytitle("") xlab(, grid) ///
 xtitle("Cummulative Margins Compliance Rate") ///
 title("Cumulatives Probability")
restore

preserve
keep if round == 2
cumul y if country == 1, gen(citaly)
cumul y if country == 3, gen(cus)
stack cus y  citaly y, into(c y) wide clear
line cus citaly y, sort ylab(, grid) ytitle("") xlab(, grid) ///
 xtitle("Cummulative Margins Compliance Rate") ///
 title("Cumulatives Probability")
restore

preserve
keep if round == 3
cumul y if country == 1, gen(citaly)
cumul y if country == 3, gen(cus)
stack cus y  citaly y, into(c y) wide clear
line cus citaly y, sort ylab(, grid) ytitle("") xlab(, grid) ///
 xtitle("Cummulative Margins Compliance Rate") ///
 title("Cumulatives Probability")
restore

preserve
keep if round == 4
cumul y if country == 1, gen(citaly)
cumul y if country == 3, gen(cus)
stack cus y  citaly y, into(c y) wide clear
line cus citaly y, sort ylab(, grid) ytitle("") xlab(, grid) ///
 xtitle("Cummulative Margins Compliance Rate") ///
 title("Cumulatives Probability")
restore

preserve
keep if round == 5
cumul y if country == 1, gen(citaly)
cumul y if country == 3, gen(cus)
stack cus y  citaly y, into(c y) wide clear
line cus citaly y, sort ylab(, grid) ytitle("") xlab(, grid) ///
 xtitle("Cummulative Margins Compliance Rate") ///
 title("Cumulatives Probability")
restore


preserve
keep if round == 6
cumul y if country == 1, gen(citaly)
cumul y if country == 3, gen(cus)
stack cus y  citaly y, into(c y) wide clear
line cus citaly y, sort ylab(, grid) ytitle("") xlab(, grid) ///
 xtitle("Cummulative Margins Compliance Rate") ///
 title("Cumulatives Probability")
restore


* Table 1: Columns (1 - 9)
* -------

foreach j in 1 2 3 4 5 6 {
	gen cheat`j' = 0  
	replace cheat`j' = 1 if y`j' == 0
	replace cheat`j' = . if y`j' == .
	
	gen honest`j' = 0
	replace honest`j' = 1 if y`j' == 1
	replace honest`j' = . if y`j' == .
	
	gen pe`j' = 0
	replace pe`j' = 1 if y`j' != 1 & y`j' != 0
	replace pe`j' = . if y`j' == .
}


matrix balance = J(18, 11, 0)
local i = 1
foreach j in 1 2 3 4 5 6 {
	ttest cheat`j', by(country)
	matrix balance[`i', 1] = r(mu_1)
	matrix balance[`i', 2] = r(mu_2)
	matrix balance[`i', 3] = r(mu_1) - r(mu_2)
	
	ttest honest`j', by(country)
	matrix balance[`i', 5] = r(mu_1)
	matrix balance[`i', 6] = r(mu_2)
	matrix balance[`i', 7] = r(mu_1) - r(mu_2)
	
	ttest pe`j', by(country)
	matrix balance[`i', 9] = r(mu_1)
	matrix balance[`i', 10] = r(mu_2)
	matrix balance[`i', 11] = r(mu_1) - r(mu_2)
	
	local i = `i' + 1
	
	ttest cheat`j', by(country)
	matrix balance[`i', 1] = r(N_1) * r(mu_1)
	matrix balance[`i', 2] = r(N_2) * r(mu_2)
	
	ttest honest`j', by(country)
	matrix balance[`i', 5] = r(N_1) * r(mu_1)
	matrix balance[`i', 6] = r(N_2) * r(mu_2)
	
	ttest pe`j', by(country)
	matrix balance[`i', 9] = r(N_1) * r(mu_1)
	matrix balance[`i', 10] = r(N_2) * r(mu_2)
	
	local i = `i' + 1

	prtest cheat`j', by(country)
	matrix balance[`i', 3] = r(z)
	
	prtest honest`j', by(country)
	matrix balance[`i', 7] = r(z)
	
	prtest pe`j', by(country)
	matrix balance[`i', 11] = r(z)
		
	local i = `i' + 1	
}
matrix rownames balance = Round1 N se Round2 N se Round3 N se Round4 N se ///
	Round5 N se Round6 N se 
matrix colnames balance =  Italy US Difference blank Italy US Difference blank Italy US Difference
matrix list balance
outtable using "compliance_gap", mat(balance) format(%9.2f) replace caption("Proportions of Complete Compliers and Complete Evaders: Italy and US") 

	
* Table 1: Columns 10-12
* -------

matrix pe = J(12, 5, 0)
local i = 1
foreach j in 1 2 3 4 5 6{
	
	ttest y`j' if cheat`j' == 0 & honest`j' == 0, by(country)
	matrix pe[`i', 1] = r(N_1)
	matrix pe[`i', 2] = r(N_2)
	matrix pe[`i', 3] = r(mu_1)
	matrix pe[`i', 4] = r(mu_2)
	matrix pe[`i', 5] = r(mu_1) - r(mu_2)

	local i = `i' + 1
	
	ranksum y`j' if cheat`j' == 0 & honest`j' == 0, by(country)
	matrix pe[`i', 5] = r(z)
		
	local i = `i' + 1	
}
matrix rownames pe = Round1 z Round2 z Round3 z Round4 z ///
	Round5 z Round6 z 
matrix colnames pe =  Italy_N UK_N  Italy_mean UK_mean Difference
matrix list pe
outtable using "pe_gap", mat(pe) format(%9.2f) replace caption("Compliance Rate of Partial Evaders: Italy and US") 


***Distribution of decisions 

xtprobit  cheat i.country##i.round  risk female past employed, re 
margins country, at(round=(1(1)6)) 
marginsplot
xtprobit  cheat i.country##i.round  risk female past employed, re 
margins country, at(round=(1(1)6)) 
marginsplot
xtprobit  cheat i.country##i.round  risk female past employed, re 
margins country, at(round=(1(1)6)) 
marginsplot

	
