clear
clear matrix
set more off
cd "~\Data"

*** TABLE 1 ***

use republicanincomeinequality113, clear

matrix A = J(100,10,.)
gen row = 1

preserve
clear
set obs 1
gen holder = .
save "~\Output\main_table", replace
restore

foreach x in houserep housepolar housedem housechamber senaterep senatepolar senatechamber senatedem{
replace row = 1
foreach y in top1 top1_posttax top1_capital invert_pareto gini_family{

cor `y' `x' 

mat A[row, 1] = r(rho) 
mat A[row, 4] = r(N)

mat A[row, 2] = r(rho)  + (invttail(r(N)-2,.025))*(((1-(r(rho)*r(rho)))/(r(N)-2))^.5)
mat A[row, 3] = r(rho)  - (invttail(r(N)-2,.025))*(((1-(r(rho)*r(rho)))/(r(N)-2))^.5)
mat A[row, 5] = r(rho)*((r(N) - 2)^.5) / ((1 - r(rho)^2)^.5)
mat A[row, 6] = r(rho) / (r(rho)*((r(N) - 2)^.5) / ((1 - r(rho)^2)^.5))
mat A[row, 7] = ttail(r(N)-2, abs(r(rho)*((r(N) - 2)^.5) / ((1 - r(rho)^2)^.5)))*2


preserve
svmat A
keep A*
drop if A1==.
drop A8 A9 A10
rename A1 coef
rename A2 ub
rename A3 lb
rename A4 n
rename A5 tstat
rename A6 se
rename A7 pvalue
gen measure = "`x'"
g variable = "`y'"
append using "~\Output\main_table"
save "~\Output\main_table", replace
restore

}
}


*** TABLE 2 ***
use republicanincomeinequality113, clear

for any top1 top1_posttax top1_capital  invert_pareto gini_family: pcorr X houserep housepolar
for any top1 top1_posttax top1_capital  invert_pareto gini_family: pcorr X senaterep senatepolar

for any top1 top1_posttax top1_capital  invert_pareto gini_family: reg X houserep housepolar
for any top1 top1_posttax top1_capital  invert_pareto gini_family: reg X senaterep senatepolar


preserve
clear
set obs 1
g holder = .
save "~\Output\partial_correlation", replace
restore
g row =1

matrix A = J(100,10,.)
replace row = 1
foreach x in house senate{
foreach y in top1 top1_posttax top1_capital  invert_pareto {

reg  `y' `x'polar
predict res1, residuals

reg  `x'rep `x'polar
predict res2, residuals

cor res1 res2

mat A[row, 1] = r(rho) 
mat A[row, 4] = r(N)

mat A[row, 2] = r(rho)  + (invttail(r(N)-3,.025))*(((1-(r(rho)*r(rho)))/(r(N)-3))^.5)
mat A[row, 3] = r(rho)  - (invttail(r(N)-3,.025))*(((1-(r(rho)*r(rho)))/(r(N)-3))^.5)
mat A[row, 5] = r(rho)*((r(N) - 3)^.5) / ((1 - r(rho)^2)^.5)
mat A[row, 6] = r(rho) / (r(rho)*((r(N) - 3)^.5) / ((1 - r(rho)^2)^.5))
mat A[row, 7] = ttail(r(N)-3, abs(r(rho)*((r(N) - 3)^.5) / ((1 - r(rho)^2)^.5)))*2

drop res1 res2


preserve
svmat A
keep A*
drop if A1==.
rename A1 coef
rename A2 ub
rename A3 lb
rename A4 n
rename A5 tstat
rename A6 se
rename A7 pvalue
gen measure = "`y'"
gen iv = "`x'rep"
append using "~\Output\partial_correlation"
save "~\Output\partial_correlation", replace
restore

}
}

matrix A = J(100,10,.)
replace row = 1
foreach x in house senate{
foreach y in top1 top1_posttax top1_capital  invert_pareto {

reg  `y' `x'rep
predict res1, residuals

reg  `x'polar `x'rep
predict res2, residuals

cor res1 res2

mat A[row, 1] = r(rho) 
mat A[row, 4] = r(N)

mat A[row, 2] = r(rho)  + (invttail(r(N)-3,.025))*(((1-(r(rho)*r(rho)))/(r(N)-3))^.5)
mat A[row, 3] = r(rho)  - (invttail(r(N)-3,.025))*(((1-(r(rho)*r(rho)))/(r(N)-3))^.5)
mat A[row, 5] = r(rho)*((r(N) - 3)^.5) / ((1 - r(rho)^2)^.5)
mat A[row, 6] = r(rho) / (r(rho)*((r(N) - 3)^.5) / ((1 - r(rho)^2)^.5))
mat A[row, 7] = ttail(r(N)-3, abs(r(rho)*((r(N) - 3)^.5) / ((1 - r(rho)^2)^.5)))*2

drop res1 res2

preserve
svmat A
keep A*
drop if A1==.
rename A1 coef
rename A2 ub
rename A3 lb
rename A4 n
rename A5 tstat
rename A6 se
rename A7 pvalue
gen measure = "`y'"
gen iv = "`x'polar"
append using "~\Output\partial_correlation"
save "~\Output\partial_correlation", replace
restore

}
}

* Gini-Polarization
foreach x in house senate{
reg gini_family `x'rep
predict res1, residuals

reg `x'polar `x'rep if gini_family!=.
predict res2, residuals

cor res1 res2

mat A[row, 1] = r(rho) 
mat A[row, 4] = r(N)

mat A[row, 2] = r(rho)  + (invttail(r(N)-3,.025))*(((1-(r(rho)*r(rho)))/(r(N)-3))^.5)
mat A[row, 3] = r(rho)  - (invttail(r(N)-3,.025))*(((1-(r(rho)*r(rho)))/(r(N)-3))^.5)
mat A[row, 5] = r(rho)*((r(N) - 3)^.5) / ((1 - r(rho)^2)^.5)
mat A[row, 6] = r(rho) / (r(rho)*((r(N) - 3)^.5) / ((1 - r(rho)^2)^.5))
mat A[row, 7] = ttail(r(N)-3, abs(r(rho)*((r(N) - 3)^.5) / ((1 - r(rho)^2)^.5)))*2

drop res1 res2


preserve
svmat A
keep A*
drop if A1==.
rename A1 coef
rename A2 ub
rename A3 lb
rename A4 n
rename A5 tstat
rename A6 se
rename A7 pvalue
gen measure = "gini_family"
gen iv = "`x'polar"
append using "~\Output\partial_correlation"
save "~\Output\partial_correlation", replace
restore

}


* Gini Republican
foreach x in house senate{
reg gini_family `x'polar
predict res1, residuals

reg `x'rep `x'polar if gini_family!=.
predict res2, residuals

cor res1 res2

mat A[row, 1] = r(rho) 
mat A[row, 4] = r(N)

mat A[row, 2] = r(rho)  + (invttail(r(N)-3,.025))*(((1-(r(rho)*r(rho)))/(r(N)-3))^.5)
mat A[row, 3] = r(rho)  - (invttail(r(N)-3,.025))*(((1-(r(rho)*r(rho)))/(r(N)-3))^.5)
mat A[row, 5] = r(rho)*((r(N) - 3)^.5) / ((1 - r(rho)^2)^.5)
mat A[row, 6] = r(rho) / (r(rho)*((r(N) - 3)^.5) / ((1 - r(rho)^2)^.5))
mat A[row, 7] = ttail(r(N)-3, abs(r(rho)*((r(N) - 3)^.5) / ((1 - r(rho)^2)^.5)))*2

drop res1 res2


preserve
svmat A
keep A*
drop if A1==.
rename A1 coef
rename A2 ub
rename A3 lb
rename A4 n
rename A5 tstat
rename A6 se
rename A7 pvalue
gen measure = "gini_family"
gen iv = "`x'rep"
append using "~\Output\partial_correlation"
save "~\Output\partial_correlation", replace
restore

}


*** FIGURE 1 ***
use republicanincomeinequality113, clear

cor top1 housepolar
tw connected top1 year
tw connected housepolar year


*** FIGURE 2 ***
use republicanincomeinequality113, clear

matrix A = J(100,10,.)
gen row = 1

preserve
clear
set obs 1
gen holder = .
save "~\Output\correlations_cutoff", replace
restore

foreach x in houserep housepolar {
replace row = 1
forvalues i=1959(2)2013{

cor top1 `x' if year<=`i'

mat A[row, 1] = r(rho) 
mat A[row, 4] = r(N)

mat A[row, 2] = r(rho)  + (invttail(r(N)-2,.025))*(((1-(r(rho)*r(rho)))/(r(N)-2))^.5)
mat A[row, 3] = r(rho)  - (invttail(r(N)-2,.025))*(((1-(r(rho)*r(rho)))/(r(N)-2))^.5)
mat A[row, 5] = r(rho)*((r(N) - 2)^.5) / ((1 - r(rho)^2)^.5)
mat A[row, 6] = r(rho) / (r(rho)*((r(N) - 2)^.5) / ((1 - r(rho)^2)^.5))
mat A[row, 7] = ttail(r(N)-2, abs(r(rho)*((r(N) - 2)^.5) / ((1 - r(rho)^2)^.5)))*2
mat A[row, 8] = `i'
replace row = row + 1

}

preserve
svmat A
keep A*
drop if A1==.
rename A1 coef
rename A2 ub
rename A3 lb
rename A4 n
rename A5 tstat
rename A6 se
rename A7 pvalue
rename A8 year
gen measure = "`x'"
append using "~\Output\correlations_cutoff"
save "~\Output\correlations_cutoff", replace
restore

}


*** FIGURE 3 ***
use republicanincomeinequality113, clear

preserve
clear
set obs 1
gen holder=.
save "~\Output\interactiontable", replace
restore

for any zsenatedem113 zhousedem113 yhousedem113 ysenatedem113: replace X = -1*X

stack ztop1 ztop1_posttax ztop1_capital zinvert_pareto ygini_family zhouserep113 yhouserep113 zsenaterep113 ysenaterep113 year ///
      ztop1 ztop1_posttax ztop1_capital zinvert_pareto ygini_family zhousedem113 yhousedem113 zsenatedem113 ysenatedem113 year, ///
 into(top1 top1_posttax top1_capital invert_pareto gini_family zhouse yhouse zsenate ysenate year)

gen rep = _stack==1

gen zinteracthouse = zhouse*rep
gen yinteracthouse = yhouse*rep
gen zinteractsenate = zsenate*rep
gen yinteractsenate = ysenate*rep

* For House
matrix A = J(100,10,.)
g row = 1
foreach x in top1 top1_posttax top1_capital invert_pareto{
reg `x' rep zhouse zinteracthouse
scalar cv = invttail((e(N)/2)-4, .025)


mat A[row,1] = _b[zinteracthouse]
mat A[row,2] = _se[zinteracthouse]
mat A[row,3] = _b[zinteracthouse] + (_se[zinteracthouse]*cv)
mat A[row,4] = _b[zinteracthouse] - (_se[zinteracthouse]*cv)

preserve
svmat A
keep A*
drop if A1==.
rename A1 coef
rename A2 se
rename A3 ub
rename A4 lb
g var = "interacthouse"
g measure = "`x'"
append using "~\Output\interactiontable"
save "~\Output\interactiontable", replace
restore
}

* For Senate
matrix A = J(100,10,.)
replace row = 1
foreach x in top1 top1_posttax top1_capital invert_pareto{
reg `x' rep zsenate zinteractsenate
scalar cv = invttail((e(N)/2)-4, .025)


mat A[row,1] = _b[zinteractsenate]
mat A[row,2] = _se[zinteractsenate]
mat A[row,3] = _b[zinteractsenate] + (_se[zinteractsenate]*cv)
mat A[row,4] = _b[zinteractsenate] - (_se[zinteractsenate]*cv)

preserve
svmat A
keep A*
drop if A1==.
rename A1 coef
rename A2 se
rename A3 ub
rename A4 lb
g var = "interactsenate"
g measure = "`x'"

append using "~\Output\interactiontable"
save "~\Output\interactiontable", replace
restore

}

* Gini Coef
matrix A = J(100,10,.)
replace row = 1
foreach x in house senate{
reg gini_family rep y`x' yinteract`x'
scalar cv = invttail((e(N)/2)-4, .025)


mat A[row,1] = _b[yinteract`x']
mat A[row,2] = _se[yinteract`x']
mat A[row,3] = _b[yinteract`x'] + (_se[yinteract`x']*cv)
mat A[row,4] = _b[yinteract`x'] - (_se[yinteract`x']*cv)

preserve
svmat A
keep A*
drop if A1==.
rename A1 coef
rename A2 se
rename A3 ub
rename A4 lb
g var = "interact`x'"
g measure = "gini_family"

append using "~\Output\interactiontable"
save "~\Output\interactiontable", replace
restore

}

*** FIGURE 4 ***

* Left Panel
use republicanincomeinequality113_northsouth, clear

tw connected housedem113 houserep housedemnorth housedemsouth year
tw connected top1 year
