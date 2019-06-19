/* Prepare ILO employment for cross-sectional regressions with time averages*/

drop _all
use ~/borja2/DATA/ilo_employment.dta

* Generate shares
forval industry=1(1)9{
gen employment_sh`industry'=employment`industry'/employment_total
}

drop employment1-employment9 employment_total

* Generate observation id for reshape
egen country_n=group(isocode)
gen obs_id=country_n*10000+year

* Reshape
reshape long employment_sh, i(obs_id) j(industry)

sort isocode industry year
by isocode industry: egen n_obs_ci=count(employment_sh)

save ~/borja2/DATA/ilo_employment_reshape.dta, replace

* Generate decades
gen yr10=70 if year<=1980
replace yr10=80 if year>=1981 & year<=1990
replace yr10=90 if year>=1991 & year<=2000

*Average employment share per decade
sort isocode industry yr10
by isocode industry yr10: egen employment_sh_yr10_avg=mean(employment_sh)


*Keep relevant variables and contract
keep   employment_sh_yr10_avg isocode industry yr10
contract employment_sh_yr10_avg isocode industry yr10

sort isocode yr10
drop _freq

*Merge with country database
joinby isocode yr10 using ~/borja2/DATA/pn_penntable_10avg_jan2006.dta

* Generate industry dummies
tab industry, gen(dindustry)

* Generate services share
sort isocode yr10
by isocode yr10: egen employment_sh_services=sum(employment_sh_yr10_avg) if (industry==6 | industry==8 | industry==9)
by isocode yr10: replace employment_sh_services=. if (industry==6 | industry==8 | industry==9) & employment_sh_services==0

save ~/borja2/DATA/ilo_employment_yr10_avg.dta, replace
