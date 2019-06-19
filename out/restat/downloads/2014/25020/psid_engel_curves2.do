// psid_engel_curves2.do 

version 10
use psid3year, clear

tab entre

// ----------------------------------------------
// conditional engel curve with reported income
// ----------------------------------------------

// condition out the preference shifters
qui reg logfood age???? black married fam? fam?? year???? [pw=weight]
predict logfoodhat
predict logfoodres, resid

qui reg logfaminc age???? black married fam? fam?? year???? [pw=weight]
predict logfaminchat
predict logfamincres, resid

// add back the constants, so that engel curve is evaluated at the 
// averages of the covariates
sum logfoodhat
gen logfoodres2 = logfoodres + r(mean)

sum logfaminchat
gen logfamincres2 = logfamincres + r(mean)

// ensure an overlapping support for the residuals
// first, find support for wage/sal
sum logfamincres2 if entre == 0
local min_inc_w = r(min)
local max_inc_w = r(max)
// next, find support for entre
sum logfamincres2 if entre == 1
local min_inc_e = r(min)
local max_inc_e = r(max)
// find the overlapping support
local min_inc = max(`min_inc_w',`min_inc_e')
local max_inc = min(`max_inc_w',`max_inc_e')
// only keep observations within the overlapping support
keep if logfamincres2 >= `min_inc' & logfamincres2 <= `max_inc'

// trim top and bottom 1 percentiles among the common support
local trim = 1
if `trim' {
cap drop ltrim rtrim
egen ltrim = pctile(logfamincres2), p(1)
egen rtrim = pctile(logfamincres2), p(99)
keep if logfamincres2 >= ltrim & logfamincres2 <= rtrim
}


// median spline non-parametric engel curves
graph twoway mspline logfoodres2 logfamincres2 if entre == 0, bands(8) || ///
  mspline logfoodres2 logfamincres2 if entre == 1, bands(8) lpattern(dash) ///
  ytitle("Log 3 Year Average Food Expenditures") ///
  xtitle("Log 3 Year Average Family Income") ///
  xlabel(10(0.5)12) ///
  xmtick(10(0.1)12) ///
  ylabel(8(0.5)10) ///
  ymtick(8(0.1)10) ///
  legend(order (1 2) lab(1 "Wage and Salary Employees") lab(2 "Self Employed"))
graph rename cond_3yr_fam4, replace
graph export figure1.eps, replace

// using same controls, get slope for workers and for self employed
// logfaminc is slope for workers
// p-value on entre_logfaminc is the test for equal slopes
// logfaminc + entre_logfaminc is the slope for self employed
gen entre_logfaminc = entre * logfaminc
reg logfood logfaminc entre entre_logfaminc age???? black married fam? fam?? year???? [pw=weight] 
lincom logfaminc + entre_logfaminc

// allow controls to vary

gen entre_age3034 = entre * age3034
gen entre_age3539 = entre * age3539
gen entre_age4044 = entre * age4044
gen entre_age4549 = entre * age4549
gen entre_age5055 = entre * age5055

gen entre_fam1 = entre * fam1
gen entre_fam2 = entre * fam2
gen entre_fam3 = entre * fam3
gen entre_fam4 = entre * fam4
gen entre_fam5 = entre * fam5
gen entre_fam6 = entre * fam6
gen entre_fam7 = entre * fam7
gen entre_fam8 = entre * fam8
gen entre_fam9 = entre * fam9
gen entre_fam10 = entre * fam10
gen entre_fam11 = entre * fam11

gen entre_year1980 = entre * year1980
gen entre_year1981 = entre * year1981
gen entre_year1982 = entre * year1982
gen entre_year1983 = entre * year1983
gen entre_year1984 = entre * year1984
gen entre_year1985 = entre * year1985
gen entre_year1986 = entre * year1986
gen entre_year1987 = entre * year1987
gen entre_year1988 = entre * year1988
gen entre_year1989 = entre * year1989
gen entre_year1990 = entre * year1990
gen entre_year1991 = entre * year1991
gen entre_year1992 = entre * year1992
gen entre_year1993 = entre * year1993
gen entre_year1994 = entre * year1994
gen entre_year1995 = entre * year1995
gen entre_year1996 = entre * year1996
gen entre_year1997 = entre * year1997
//gen entre_year1998 = entre * year1998
gen entre_year1999 = entre * year1999

gen entre_highschool = entre * highschool
gen entre_somecollege = entre * somecollege
gen entre_college = entre * college
gen entre_graduate = entre * graduate

gen entre_black = entre * black
gen entre_married = entre * married

reg logfood logfaminc entre entre_* age???? black married fam? fam?? year???? [pw=weight] 
lincom logfaminc + entre_logfaminc

