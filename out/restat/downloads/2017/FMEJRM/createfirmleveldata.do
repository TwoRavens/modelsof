// generate needed variables


use "eseecleaned.dta", clear

keep adv inv_it rd inv_veh   inv_mach   inv_fur inv_bld inv_land  creditratio crcost  crisis ///
	creditratio longratio firmid indyear lnexpeu lnexpw lnvasp year  pcaext /// 
	shortfiratio size lnexpfir exp1  prod  

gen totinv=adv+inv_it+rd+inv_veh+inv_mach+inv_fur
label var totinv "Total investment into 6 categories (adv, IT, R&D, Vehicles, Machinery, Furniture"
gen lntotinv=ln(totinv)
label var lntotinv "ln(total inv)"
gen longinvsh=(inv_mach+inv_fur)/totinv
label var longinvsh "long term inv/total inv"

cap drop domfir 
gen domfir=(pcaext<=50)
replace domfir=. if pcaext==.
label var domfir "Spanish firm dummy"
cap drop inter
gen inter=domfir*crisis 
label var inter "Interaction term (Spanish firms) * (after 2008)"

gen temp=shortfiratio if year==2007
bysort firmid: egen shortfi2007=min(temp)
cap drop temp
label var shortfi2007 "Short term credit with fin inst/total credit in 2007"
sum shortfiratio if year==2007, detail
gen shortfi=1 if shortfi2007>`r(mean)' & shortfi2007!=.
replace shortfi=0 if shortfi2007<=`r(mean)'  & shortfi2007!=.
label var shortfi "1 more than avg short term debt in 2007"

gen intershortfi=shortfi*crisis 
label var intershortfi "Interaction term (Short term credit dummy) * (after 2008)"

keep adv inv_it rd inv_veh   inv_mach   inv_fur inv_bld inv_land  creditratio crcost  crisis ///
	creditratio longratio firmid indyear lnexpeu lnexpw lnvasp year domfir inter /// 
	lntotinv longinvsh size lnexpfir exp1  prod   shortfi intershortfi

save "eseefirmlevel.dta", replace

