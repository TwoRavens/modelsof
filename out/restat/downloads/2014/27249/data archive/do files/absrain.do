replace janvier=abs_janvier
replace fevrier=abs_fevrier
replace mars=abs_mars
replace avril=abs_avril
replace mai=abs_mai 
replace juin= abs_juin
replace juillet=abs_juillet
replace aout=abs_aout 
replace septembre=abs_septembre
replace octobre=abs_octobre 
replace novembre= abs_novembre
replace decembre=abs_decembre


gen logjanvier=log(janvier)
gen logfevrier=log(fevrier)
gen logmars=log(mars)
gen logavril=log(avril)
gen logmai=log(mai)
gen logjuin=log(juin)
gen logjuillet=log(juillet)
gen logaout=log(aout)
gen logseptembre=log(septembre)
gen logoctobre =log(octobre)
gen lognovembre=log(novembre)
gen logdecembre=log(decembre)



replace logjanvier=0 if logjanvier==.
replace logfevrier=0 if logfevrier==.
replace logmars=0 if logmars==.
replace logavril=0 if logavril==.
replace logmai=0 if logmai==.
replace logjuin=0 if logjuin==.
replace logjuillet=0 if logjuillet==.
replace logaout=0 if logaout==.
replace logseptembre=0 if logseptembre==.
replace logoctobre=0 if  logoctobre==.
replace lognovembre=0 if lognovembre==.
replace logdecembre=0 if logdecembre==.
