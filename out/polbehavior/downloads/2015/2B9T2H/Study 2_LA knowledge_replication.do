set more off

/*table 1*/

oprobit laknow english

oprobit laknow english meanslow engslow educ age, robust

/*table 2*/

reg avglogla english meanslow age educ prefspan, robust

reg avglogla english meanslow engslow age educ prefspan, robust


/*table 3*/

probit refuseLA2 english meanslow age educ prefspan, robust

probit refuseLA2 english meanslow engslow age educ prefspan, robust


