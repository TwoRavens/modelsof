version 12
capture log close
clear all

*Set cd
*cd ...

log using AriasPSRMreplication.log, replace
set more off

*************************************************************************;
*  File-Name: 	AriasPSRMreplication.do					*;
*  Date: 	Oct 25, 2017						*;
*  Author: 	Eric Arias						*;
*  Purpose: 	
*  In File: 	census.dta , treatments_only.dta , fullsample.dta		*;
*  Out File: 	AriasPSRMreplication.log					*;
*  Data Out: 								*;
*  Prev file:	 						*;
*  Status: 	In Progress.						*;
*  Machine: 	Windows i7-3770, 3.4GHz, 16GB RAM			*;
*************************************************************************;



*************************************************************************;
* TABLE 2
*************************************************************************;

qui {
*************************************************************************;
* EXPANDING TO HOUSEHOLD LEVEL
*************************************************************************;

use census.dta , clear

*Viviendas particulares habitadas
expand Viviendasparticulareshabitadas

sort AGEB Manzana
bysort AGEB Manzana: gen household = _n

bysort AGEB Manzana: gen malehead = 1 if Hogarescensalesconjefaturamas >= household & household!=. & Hogarescensalesconjefaturamas!=.
bysort AGEB Manzana: replace malehead = 0 if Hogarescensalesconjefaturamas < household & household!=. & Hogarescensalesconjefaturamas!=.

bysort AGEB Manzana: gen undormitorio = 1 if FY >= household & household!=. & FY!=.
bysort AGEB Manzana: replace undormitorio = 0 if FY < household & household!=. & FY!=.

bysort AGEB Manzana: gen ocupXbed3 = 1 if GA >= household & household!=. & GA!=.
bysort AGEB Manzana: replace ocupXbed3 = 0 if GA < household & household!=. & GA!=.

bysort AGEB Manzana: gen luz = 1 if GF >= household & household!=. & GF!=.
bysort AGEB Manzana: replace luz = 0 if GF < household & household!=. & GF!=.

bysort AGEB Manzana: gen bath = 1 if GK >= household & household!=. & GK!=.
bysort AGEB Manzana: replace bath  = 0 if GK < household & household!=. & GK!=.

bysort AGEB Manzana: gen refri = 1 if GR >= household & household!=. & GR!=.
bysort AGEB Manzana: replace refri  = 0 if GR < household & household!=. & GR!=.

bysort AGEB Manzana: gen lavadora = 1 if GS >= household & household!=. & GS!=.
bysort AGEB Manzana: replace lavadora  = 0 if GS < household & household!=. & GS!=.

bysort AGEB Manzana: gen car = 1 if GT >= household & household!=. & GT!=.
bysort AGEB Manzana: replace car  = 0 if GT < household & household!=. & GT!=.

bysort AGEB Manzana: gen radio = 1 if GW >= household & household!=. & GW!=.
bysort AGEB Manzana: replace radio  = 0 if GW < household & household!=. & GW!=.

bysort AGEB Manzana: gen televisor = 1 if GX >= household & household!=. & GX!=.
bysort AGEB Manzana: replace televisor  = 0 if GX < household & household!=. & GX!=.

bysort AGEB Manzana: gen computadora = 1 if GY >= household & household!=. & GY!=.
bysort AGEB Manzana: replace computadora  = 0 if GY < household & household!=. & GY!=.

bysort AGEB Manzana: gen landline = 1 if GZ >= household & household!=. & GZ!=.
bysort AGEB Manzana: replace landline  = 0 if GZ < household & household!=. & GZ!=.

bysort AGEB Manzana: gen cellphone = 1 if HA >= household & household!=. & HA!=.
bysort AGEB Manzana: replace cellphone  = 0 if HA < household & household!=. & HA!=.

label variable malehead "Male head of household"
label variable undormitorio "One bedroom house"
label variable ocupXbed3 "More than 3 people per bedroom"
label variable luz "Electricity"
label variable bath "Bathroom"
label variable refri "Fridge"
label variable lavadora "Washing machine"
label variable car "Car"
label variable radio "Radio"
label variable televisor "Television"
label variable computadora "Computer"
label variable landline "Landline"
label variable cellphone "Cellphone"

}
#delimit ;
estpost ttest 
malehead undormitorio ocupXbed3 luz bath 
refri lavadora car radio televisor computadora landline cellphone  
, by(IndividualArea) ;
esttab, compress cells("N_2 mu_2(fmt(%12.2f)) N_1 mu_1(fmt(%12.2f)) 
b(fmt(%12.2f)) se(fmt(%12.2f)) p(fmt(%12.2f))" ) wide tex noisily label ;
#delimit cr

qui {
*************************************************************************;
* EXPANDING TO INDIVIDUAL LEVEL
*************************************************************************;

*************************************************************************;
* USING POBLACION TOTAL
*************************************************************************;
use census.dta , clear

*Poblacion Total
expand Poblacintotal

sort AGEB Manzana
bysort AGEB Manzana: gen individual = _n

bysort AGEB Manzana: gen female = 1 if Poblacinfemenina >= individual & individual!=. & Poblacinfemenina!=.
bysort AGEB Manzana: replace female = 0 if Poblacinfemenina < individual & individual!=. & Poblacinfemenina!=.

bysort AGEB Manzana: gen otraentidad = 1 if Poblacinnacidaenotraentidad >= individual & individual!=. & Poblacinnacidaenotraentidad!=.
bysort AGEB Manzana: replace otraentidad = 0 if Poblacinnacidaenotraentidad < individual & individual!=. & Poblacinnacidaenotraentidad!=.

bysort AGEB Manzana: gen catholic = 1 if Poblacinconreligincatlica >= individual & individual!=. & Poblacinconreligincatlica!=.
bysort AGEB Manzana: replace catholic  = 0 if Poblacinconreligincatlica < individual & individual!=. & Poblacinconreligincatlica!=.

label var female "Female"
label var otraentidad "Born outside Quialana"
label var catholic "Catholic"

}
#delimit ;
estpost ttest 
female otraentidad catholic
, by(IndividualArea) ;
esttab, compress cells("N_2 mu_2(fmt(%12.2f)) N_1 mu_1(fmt(%12.2f)) 
b(fmt(%12.2f)) se(fmt(%12.2f)) p(fmt(%12.2f))" ) wide tex noisily label ;
#delimit cr

qui {
*************************************************************************;
* USING female
*************************************************************************;
use census.dta , clear

*Poblacion female
expand Poblacinfemenina

sort AGEB Manzana
bysort AGEB Manzana: gen individual = _n

bysort AGEB Manzana: gen femactiva = 1 if Poblacinfemeninaeconmicamente >= individual & individual!=. & Poblacinfemeninaeconmicamente!=.
bysort AGEB Manzana: replace femactiva  = 0 if Poblacinfemeninaeconmicamente < individual & individual!=. & Poblacinfemeninaeconmicamente!=.

label var femactiva "Economically Active Female"
}
#delimit ;
estpost ttest 
femactiva
, by(IndividualArea) ;
esttab, compress cells("N_2 mu_2(fmt(%12.2f)) N_1 mu_1(fmt(%12.2f)) 
b(fmt(%12.2f)) se(fmt(%12.2f)) p(fmt(%12.2f))" ) wide tex noisily label ;
#delimit cr

qui {
*************************************************************************;
* USING 5 anios o mas
*************************************************************************;

use census.dta , clear

*Poblacion 5 o +
expand Poblacinde5aosyms

sort AGEB Manzana
bysort AGEB Manzana: gen individual = _n

bysort AGEB Manzana: gen noesp5 = 1 if CU >= individual & individual!=. & CU!=.
bysort AGEB Manzana: replace noesp5 = 0 if CU < individual & individual!=. & CU!=.

label var noesp5 "Does not speak spanish (5 years old or more)"

}
#delimit ;
estpost ttest 
noesp5
, by(IndividualArea) ;
esttab, compress cells("N_2 mu_2(fmt(%12.2f)) N_1 mu_1(fmt(%12.2f)) 
b(fmt(%12.2f)) se(fmt(%12.2f)) p(fmt(%12.2f))" ) wide tex noisily label ;
#delimit cr

qui {
*************************************************************************;
* USING 0 a 14
*************************************************************************;
use census.dta , clear

*Poblacion de 0 a 14
expand Poblacinde0a14aos

sort AGEB Manzana
bysort AGEB Manzana: gen individual = _n

bysort AGEB Manzana: gen discapacidad014 = 1 if Poblacinde0a14aoscondisc >= individual & individual!=. & Poblacinde0a14aoscondisc!=.
bysort AGEB Manzana: replace discapacidad014  = 0 if Poblacinde0a14aoscondisc < individual & individual!=. & Poblacinde0a14aoscondisc!=.

label var discapacidad014 "Disabled (0-14 years old)"

}
#delimit ;
estpost ttest 
discapacidad014
, by(IndividualArea) ;
esttab, compress cells("N_2 mu_2(fmt(%12.2f)) N_1 mu_1(fmt(%12.2f)) 
b(fmt(%12.2f)) se(fmt(%12.2f)) p(fmt(%12.2f))" ) wide tex noisily label ;
#delimit cr

qui {
*************************************************************************;
* USING 15 o +
*************************************************************************;
use census.dta , clear


*Poblacion 5 o +
expand Poblacinde15aosyms

sort AGEB Manzana
bysort AGEB Manzana: gen individual = _n

bysort AGEB Manzana: gen highschool = 1 if DS >= individual & individual!=. & DS!=.
bysort AGEB Manzana: replace highschool  = 0 if DS < individual & individual!=. & DS!=.

label var highschool "High-School Graduate"

}
#delimit ;
estpost ttest  
highschool
, by(IndividualArea) ;
esttab, compress cells("N_2 mu_2(fmt(%12.2f)) N_1 mu_1(fmt(%12.2f)) 
b(fmt(%12.2f)) se(fmt(%12.2f)) p(fmt(%12.2f))" ) wide tex noisily label ;
#delimit cr




*************************************************************************;
* TABLE 3
*************************************************************************;

use treatments_only.dta , clear

foreach var of varlist personalbeliefsZ perceivedrejectionZ expectationsZ reaction2violence values petition index {

reg `var' group_house_only , cluster(houseid)
eststo
reg `var' group_house_only gender age i.educ logdistance, cluster(houseid)
eststo

}

#delimit ;
esttab using Table3.tex, label 
title("\textbf{Community Meeting versus Audio CD}") 
nogaps compress b(%12.2fc) se star(+ 0.10 * 0.05 ** 0.01) 
stats(N N_clust r2, fmt(%18.0g %18.0g %12.2fc) 
labels(`"N"' `"Households"' `"R-squared"')) keep(group_house_only) 
replace ;
#delimit cr
eststo clear



*************************************************************************;
* TABLE 4
*************************************************************************;

use fullsample.dta, clear

set more off
eststo clear


foreach var of varlist personalbeliefsZ perceivedrejectionZ expectationsZ reaction2violence values petition index {

reg `var' group_house_only social_untreated cd_house , cluster(houseid)
eststo
test group_house_only = cd_house
estadd scalar p_diff = ttail(r(df_r),sign(_b[group_house_only])*sqrt(r(F)))
test social_untreated = cd_house
estadd scalar p_diff2 = ttail(r(df_r),sign(_b[social_untreated])*sqrt(r(F)))
test group_house_only = social_untreated
estadd scalar p_diff3 = ttail(r(df_r),sign(_b[group_house_only]-_b[social_untreated])*sqrt(r(F)))

reg `var' group_house_only social_untreated cd_house ///
gender age i.educ logdistance, cluster(houseid)
eststo
test group_house_only = cd_house
estadd scalar p_diff = ttail(r(df_r),sign(_b[group_house_only])*sqrt(r(F)))
test social_untreated = cd_house
estadd scalar p_diff2 = ttail(r(df_r),sign(_b[social_untreated])*sqrt(r(F)))
test group_house_only = social_untreated
estadd scalar p_diff3 = ttail(r(df_r),sign(_b[group_house_only]-_b[social_untreated])*sqrt(r(F)))

}

#delimit ;
esttab using Table4.tex, label title("\textbf{All treatment conditions}") 
nogaps compress b(%12.2fc) se star(+ 0.10 * 0.05 ** 0.01) 
stats(N N_clust r2 p_diff p_diff2 p_diff3, fmt(%18.0g %18.0g %12.2fc) 
labels(`"N"' `"Households"' `"R-squared"' `"F-test $\alpha<\beta$"' `"F-test $\gamma<\beta$"' `"F-test $\alpha<\gamma$"'))
keep(group_house_only social_untreated cd_house) replace ;
#delimit cr
eststo clear






*************************************************************************;
* APPENDIX
*************************************************************************;

*************************************************************************;
* TABLE A1
*************************************************************************;

*CENSUS DATA FROM INEGI


*************************************************************************;
* TABLE A2
*************************************************************************;

use fullsample.dta, clear

eststo clear
eststo: mlogit treatment_condition age i.educ gender , cluster(houseid)
test age 2.educ 3.educ gender
estadd scalar p_diff = r(p)

esttab using TableA2.tex, label title("Testing Random Assignment") ///
nogaps compress b(%12.2fc) se star(+ 0.10 * 0.05 ** 0.01) ///
stats(N N_clust ll p_diff, fmt(%18.0g %18.0g %12.2fc) ///
labels(`"N"' `"Households"' `"Log-Likelihood"' `"Wald Test"')) ///
unstack replace noi
eststo clear


*************************************************************************;
* TABLE A3
*************************************************************************;

eststo: mlogit treatment_condition age i.educ gender if age<80, cluster(houseid)
test age 2.educ 3.educ gender
estadd scalar p_diff = r(p)

esttab using TableA3.tex, label title("Testing Random Assignment: excluding age outliers") ///
nogaps compress b(%12.2fc) se star(+ 0.10 * 0.05 ** 0.01) ///
stats(N N_clust ll p_diff, fmt(%18.0g %18.0g %12.2fc) ///
labels(`"N"' `"Households"' `"Log-Likelihood"' `"Wald Test"')) ///
unstack replace noi
eststo clear

*************************************************************************;
* TABLE A4
*************************************************************************;

eststo: mlogit treatment_condition age c.age#c.age i.educ gender , cluster(houseid)
test age c.age#c.age 2.educ 3.educ gender
estadd scalar p_diff = r(p)

esttab using TableA4.tex, label title("Testing Random Assignment: including age squared") ///
nogaps compress b(%12.2fc) se star(+ 0.10 * 0.05 ** 0.01) ///
stats(N N_clust ll p_diff, fmt(%18.0g %18.0g %12.2fc) ///
labels(`"N"' `"Households"' `"Log-Likelihood"' `"Wald Test"')) ///
unstack replace noi
eststo clear

*************************************************************************;
* TABLE A5
*************************************************************************;

*Note: rc_spline is an user-written file
rc_spline age

eststo: mlogit treatment_condition _Sage* i.educ gender, cluster(houseid) base(0)
test _Sage1 _Sage2 _Sage3 _Sage4 2.educ 3.educ gender
estadd scalar p_diff = r(p)

esttab using TableA5.tex, label title("Testing Random Assignment: with cubic splines of age") ///
nogaps compress b(%12.2fc) se star(+ 0.10 * 0.05 ** 0.01) ///
stats(N N_clust ll p_diff, fmt(%18.0g %18.0g %12.2fc) ///
labels(`"N"' `"Households"' `"Log-Likelihood"' `"Wald Test"')) ///
unstack replace noi
eststo clear

*************************************************************************;
* TABLE A6
*************************************************************************;

*SAMPLE DATA
gen a45 = .
replace a45 = 0 if ((age < 45) & (age != .))
replace a45 = 1 if ((age >= 45) & (age != .))

tab a45 gender , cell

*CENSUS DATA FROM INEGI (see Table A1)
tabi 300 684\ 328 398, cell


*************************************************************************;
* TABLE A7
*************************************************************************;


use fullsample.dta, clear
eststo clear

*Note: sutex is an user-written file
sutex personalbeliefs perceivedrejection expectations ///
values reaction2violence petition index ///
gender age educ logdistance ///
, minmax title(Descriptive statistics)



*************************************************************************;
* TABLE A8 - (Ordinal) Logit Analyses: Community Meeting versus Audio CD
*************************************************************************;

use treatments_only.dta , clear

foreach var of varlist personalbeliefs perceivedrejection expectations reaction2violence values petition {

ologit `var' group_house_only , cluster(houseid)
eststo
ologit `var' group_house_only gender age i.educ logdistance, cluster(houseid)
eststo

}

#delimit ;
esttab using TableA8.tex, label 
title("\textbf{(Ordinal) Logit Analyses: Community Meeting versus Audio CD}") 
nogaps compress b(%12.2fc) se star(+ 0.10 * 0.05 ** 0.01)
stats(N N_clust ll , fmt(%18.0g %18.0g %12.2fc) 
labels(`"N"' `"Households"' `"Log-Likelihood"'))
keep(group_house_only) eform replace ;
#delimit cr
eststo clear


*************************************************************************;
* TABLE A9 - (Ordinal) Logit Analyses: All treatment conditions
*************************************************************************;

use fullsample.dta , clear
set more off

foreach var of varlist personalbeliefs perceivedrejection expectations reaction2violence values petition {

ologit `var' group_house_only social_untreated cd_house , cluster(houseid)
eststo
ologit `var' group_house_only social_untreated cd_house gender age i.educ logdistance, cluster(houseid)
eststo

}

#delimit ;
esttab using TableA9.tex, label 
title("\textbf{(Ordinal) Logit Analyses: All treatment conditions}") 
nogaps compress b(%12.2fc) se star(+ 0.10 * 0.05 ** 0.01)
stats(N N_clust ll , fmt(%18.0g %18.0g %12.2fc) 
labels(`"N"' `"Households"' `"Log-Likelihood"'))
keep(group_house_only social_untreated cd_house) eform replace ;
#delimit cr
eststo clear


*************************************************************************;
* TABLE A10 - Community Meeting versus Audio CD: 
* Sample restricted to households within 300 meters of Town Hall
*************************************************************************;

use treatments_only.dta , clear

eststo clear

foreach var of varlist personalbeliefsZ perceivedrejectionZ expectationsZ reaction2violence values petition index {

reg `var' group_house_only if distance<300 , cluster(houseid)
eststo

reg `var' group_house_only gender age i.educ logdistance if distance<300 , cluster(houseid)
eststo

}

#delimit ;
esttab using TableA10.tex, label 
title("\textbf{Community Meeting versus Audio CD: Sample restricted to households within 300 meters of Town Hall}") 
nogaps compress b(%12.2fc) se star(+ 0.10 * 0.05 ** 0.01) 
stats(N N_clust r2, fmt(%18.0g %18.0g %12.2fc) 
labels(`"N"' `"Households"' `"R-squared"')) 
keep(group_house_only) replace ;
#delimit cr
eststo clear

*************************************************************************;
* TABLE A11 - All treatment conditions: 
* Sample restricted to households within 300 meters of Town Hall
*************************************************************************;

use fullsample.dta, clear

set more off
eststo clear

foreach var of varlist personalbeliefsZ perceivedrejectionZ expectationsZ reaction2violence values petition index {

reg `var' group_house_only social_untreated cd_house if distance<300 , cluster(houseid)
eststo

reg `var' group_house_only social_untreated cd_house gender age i.educ logdistance if distance<300, cluster(houseid)
eststo

}

#delimit ;
esttab using TableA11.tex, label title("\textbf{All treatment conditions: Sample restricted to households within 300 meters of Town Hall}") 
nogaps compress b(%12.2fc) se star(+ 0.10 * 0.05 ** 0.01) 
stats(N N_clust r2 , fmt(%18.0g %18.0g %12.2fc) 
labels(`"N"' `"Households"' `"R-squared"'))
keep(group_house_only social_untreated cd_house) replace ;
#delimit cr
eststo clear


*************************************************************************;
* END
*************************************************************************;
cap log close
*************************************************************************;
