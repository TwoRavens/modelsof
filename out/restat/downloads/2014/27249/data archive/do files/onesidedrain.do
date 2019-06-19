
gen logjanvier=log(z1)
gen logfevrier=log(z2)
gen logmars=log(z3)
gen logavril=log(z4)
gen logmai=log(z5)
gen logjuin=log(z6)
gen logjuillet=log(z7)
gen logaout=log(z8)
gen logseptembre=log(z9)
gen logoctobre =log(z10)
gen lognovembre=log(z11)
gen logdecembre=log(z12)


replace logjanvier=0 if logjanvier==.
replace logfevrier=0 if logfevrier==.
replace logmars=0 if logmars==.
replace logavril=0 if logavril==.
replace logmai=0 if logmai==.
replace logjuin=0 if logjuin==.
replace logjuillet=0 if logjuillet==.
replace logaout=0 if logaout==.
replace logseptembre=0 if logseptembre==.
replace logoctobre =0 if logoctobre==.
replace lognovembre=0 if lognovembre==.
replace logdecembre=0 if logdecembre==.
