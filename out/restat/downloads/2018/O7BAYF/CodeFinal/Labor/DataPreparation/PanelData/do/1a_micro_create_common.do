

***manipulate weights 
generate perwt2=perwt
replace perwt=perwt*hours*weeks/2000
ren perwt weight
ren perwt2 perwt


***drop if not proper household 
drop if gq==0 | gq==3 | gq==4

***drop if not proper age
keep if age>=25 & age<=64

***keep only wage and salary workers, no self-employed
***original Borjas: keep if classwkd>=20 & classwkd<=28
***what we do
keep if classwkrd>=20 & classwkrd<=28

***produce educational categories (like Borjas):
***We classify workers into the same four education groups 
***(high school dropouts,high school graduates, workers with some college, and college graduates)
***generate educational category, but now educ instead of educrec
***actually NA is coded as NA or no schoolin (0)
***original Borjas: generate byte edcode=1*(educrec<=6) + 2*(educrec==7) + 3*(educrec==8) + 4*(educrec==9);
***what we do
recode educ (0/5=1 "high school dropouts") ///
(6=2 "high school graduates") (7/8=3 "some college") ///
(9/11=4 "college graduates"), gen(educ4)

*** gen edcode like borjas
gen byte edcode=1*(educ<=5) + 2*(educ==6) + 3*(educ>=7 & educ<=8) + 4*(educ>=9 & educ<=11)

*** generate experience as in acemoglu
gen exper=age-17 if edcode==1
replace exper=age-19 if edcode==2
replace exper=age-21 if edcode==3
replace exper=age-23 if edcode==4
drop if exper<0 | exper>48

***two types experience
egen experience2=cut(exper), at(0,20,49)

***use deflator for eanings and income
replace incearn=incearn*(pdeflator)
replace incwage=incwage*(pdeflator)

****generate weekly, annual, and hourly wage variables (like Borjas)
generate weekly=(incwage/weeks)
generate annual=(incwage)
generate wage=incwage/(weeks*hours)

*****generate log of weekly wage
generate lweekly=log(weekly)

***generate eight labor types
egen ltypes=group(educ4 experience2)



