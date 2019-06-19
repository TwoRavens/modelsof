/* Prepare UNIDO wages for cross-sectional regressions with time averages*/

use ~/borja2/DATA/unido_wages_employment.dta

* Generate decades
gen decade=70 if year<=1980
replace decade=80 if year>=1981 & year<=1990
replace decade=90 if year>=1991 & year<=2000

*Average wage per decade (3 years min.)
sort wbcode isic3 decade
by wbcode isic3 decade: egen wages_decade_avg=mean(wages_pc_monthly_constant_intl) if n_obs_ci>=3 & n_obs_ci~=.


*Keep relevant variables and contract
keep   wages_decade_avg wbcode isic3 decade
contract wages_decade_avg wbcode isic3 decade 

drop _freq
rename decade yr10
rename wbcode isocode
sort isocode yr10

* Drop Russia and Bulgaria because can't make sense of data
drop if isocode=="RUS" | isocode=="BGR"

save ~/borja2/DATA/unido_wages_10yr_avg.dta, replace

*Merge with country database
joinby isocode yr10 using ~/borja2/DATA/pn_penntable_10avg_jan2006.dta,

* Generate industry dummies
egen industry=group(isic3)
tab industry, gen(dindustry)

gen ln_wages_decade_avg=ln(wages_decade_avg)

save ~/borja2/DATA/unido_wages_10yr_avg.dta, replace
