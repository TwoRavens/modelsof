/* Prepare ILO wages for cross-sectional regressions with time averages*/

drop _all
use ~/borja2/DATA/ilo_earnings_us.dta

/* EURO Adjustments */

replace xr=.94447 if year==1999 & (isocode=="BEL" |isocode=="FRA" |isocode=="IRL" |isocode=="LUX" |isocode=="NLD" |isocode=="ESP")

replace xr=1.08767 if year==2000 & (isocode=="BEL" |isocode=="FRA" |isocode=="IRL" |isocode=="LUX" |isocode=="NLD" |isocode=="ESP")

replace xr=.94447*13.7603 if year==1999 & isocode=="AUT"
replace xr=1.08767*13.7603 if year==2000 & isocode=="AUT"

replace xr=1.95583 if (year==1999 | year==2000) & isocode=="DEU"

replace xr=.94447*200.482 if year==1999 & isocode=="PRT" 
replace xr=1.08767*200.482 if year==2000 & isocode=="PRT"

forval industry=1(1)9{

replace earnings_us`industry'=(earnings`industry'/xr)*deflator_usa*(gdp_constant_intl/gdp_constant_us) if (year==1999 | year==2000) & (isocode=="AUT" | isocode=="BEL" | isocode=="DEU" | isocode=="FRA" |isocode=="IRL" |isocode=="LUX" |isocode=="NLD" | isocode=="PRT" | isocode=="ESP")

}

/* Reshape and clean the earnings data*/

* Generate observation id for reshape
egen country_n=group(isocode)
gen obs_id=country_n*10000+year

* Reshape
reshape long earnings_us, i(obs_id) j(industry)
label var earnings_us "monthly earnings in 2000 intl dollars"

*Drop 1970s
drop if year<1981

* Currency redefinitions
drop if isocode=="ARG" & year<1985
replace earnings_us=earnings_us/10000 if isocode=="ARG" & year<1992

replace earnings_us=earnings_us/200 if isocode=="ARM" & year<1994

replace earnings_us=earnings_us/1000 if isocode=="BGR" & year<1999

replace earnings_us=earnings_us/2750 if isocode=="BRA" & year<1995
replace earnings_us=earnings_us/1000 if isocode=="BRA" & year<1992

replace earnings_us=earnings_us*1000 if isocode=="ECU" & year<2000
replace earnings_us=earnings_us*xr if isocode=="ECU" & year==2000

replace earnings_us=earnings_us/1000 if isocode=="HRV" & year<1993

replace earnings_us=earnings_us/1000 if isocode=="ISR" & year<1985

replace earnings_us=earnings_us*1000 if isocode=="ITA"

drop if isocode=="JAM" & year<1995

replace earnings_us=earnings_us*1000 if isocode=="KOR"

replace earnings_us=earnings_us/100 if isocode=="LTU" & year<1993

drop if isocode=="PER" & year<1990

replace earnings_us=earnings_us/10 if isocode=="POL" & year<1993 & year>1989
drop if isocode=="POL" & year<1990

replace earnings_us=earnings_us/1000 if isocode=="RUS" & year<1997

replace earnings_us=earnings_us*1000 if isocode=="TUR"

replace earnings_us=earnings_us/100 if isocode=="UKR" & year<1996 & year>1992
drop if isocode=="UKR" & year<1993

save ~/borja2/DATA/ilo_earnings_reshape.dta, replace

* Generate decades and number of obs.
gen yr10=80 if year>=1981 & year<=1990
replace yr10=90 if year>=1991 & year<=2000

sort isocode industry
by isocode industry: egen n_obs_ci=count(earnings_us)

*Average wage per decade
sort isocode industry yr10
by isocode industry yr10: egen earnings_us_yr10_avg=mean(earnings_us)

*Keep relevant variables and contract
keep   earnings_us_yr10_avg isocode industry yr10 n_obs_ci
contract earnings_us_yr10 isocode industry yr10 n_obs_ci

sort isocode yr10
drop _freq
save ~/borja2/DATA/ilo_earnings_yr10_avg.dta, replace

*Merge with country database
joinby isocode yr10 using ~/borja2/DATA//pn_penntable_10avg_jan2006.dta

* Generate industry dummies
tab industry, gen(dindustry)

save ~/borja2/DATA/ilo_earnings_yr10_avg.dta, replace
