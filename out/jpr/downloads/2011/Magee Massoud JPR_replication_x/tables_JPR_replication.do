cd c:\docume~1\cmagee\mydocu~1\civilw~1\
set more off


use Magee_Massoud_JPR_replication_data, clear


xi i.year

g lib_years=max(years_since_lib+1,0)
g lib_years2=lib_years^2
g ln_lib_years=ln(lib_years)
replace ln_lib_years=0 if lib_years==0

mkspline peace_spline1 1 peace_spline2 4 peace_spline3 7  peace_spline4 = peace_yrs
mkspline peace2_spline1 1 peace2_spline2 4 peace2_spline3 7  peace2_spline4 = peace2_yrs

drop peace_spline4 peace2_spline4
iis country_code

save temp, replace

log using table1_final.log, replace

dprobit civil_war_uppsala ln_open democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp oil ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq peace_* year 
predict temp
corr temp civil_war_uppsala
drop temp

test ethnic1_imp eth_sq
test language1_imp lan_sq
test religion1_imp rel_sq
test ethnic1_imp eth_sq language1_imp lan_sq religion1_imp rel_sq
test peace_yrs peace_spline1 peace_spline2 peace_spline3 

ivprobit civil_war_uppsala democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp oil ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq peace_* year (ln_open = dis_int remote)
mfx
predict temp
corr temp civil_war_uppsala
drop temp

test [civil_war_uppsala]: ethnic1_imp eth_sq
test [civil_war_uppsala]: language1_imp lan_sq
test [civil_war_uppsala]: religion1_imp rel_sq
test [civil_war_uppsala]: ethnic1_imp eth_sq language1_imp lan_sq religion1_imp rel_sq
test [civil_war_uppsala]: peace_yrs peace_spline1 peace_spline2 peace_spline3 



dprobit civil_war_uppsala ln_lib_years democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp oil ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq peace_* year 
predict temp
corr temp civil_war_uppsala
drop temp

test ethnic1_imp eth_sq
test language1_imp lan_sq
test religion1_imp rel_sq
test ethnic1_imp eth_sq language1_imp lan_sq religion1_imp rel_sq
test peace_yrs peace_spline1 peace_spline2 peace_spline3 

ivprobit civil_war_uppsala democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp oil ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq peace_* year (ln_lib_years = dis_int remote)
mfx
predict temp
corr temp civil_war_uppsala
drop temp
test [civil_war_uppsala]: ethnic1_imp eth_sq
test [civil_war_uppsala]: language1_imp lan_sq
test [civil_war_uppsala]: religion1_imp rel_sq
test [civil_war_uppsala]: ethnic1_imp eth_sq language1_imp lan_sq religion1_imp rel_sq
test [civil_war_uppsala]: peace_yrs peace_spline1 peace_spline2 peace_spline3 

xtlogit civil_war_uppsala ln_open democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp oil ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq  peace_* year, fe
test ethnic1_imp eth_sq
test language1_imp lan_sq
test religion1_imp rel_sq
test ethnic1_imp eth_sq language1_imp lan_sq religion1_imp rel_sq
test peace_yrs peace_spline1 peace_spline2 peace_spline3 

xtlogit civil_war_uppsala ln_lib_years democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp oil ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq peace_* year, fe 

test ethnic1_imp eth_sq
test language1_imp lan_sq
test religion1_imp rel_sq
test ethnic1_imp eth_sq language1_imp lan_sq religion1_imp rel_sq
test peace_yrs peace_spline1 peace_spline2 peace_spline3 

log close


drop if years_since_lib==.
knnreg civil_war_upp years_since_lib, kn(50)
kernreg civil_war_upp years_since_lib, b(8) k(4) np(109) gen(CW_hat_kern years_kern)
kernreg civil_war_int years_since_lib, b(8) k(4) np(109) gen(CW_hat_kern2 years_kern2)
keep if years_kern~=.
keep years_kern CW_hat*
outsheet using figure1.txt, replace
clear

use Magee_Massoud_JPR_replication_data, clear

keep if year>1989
sort country_code year
iis country_code
xi i.year

g lib_years=max(years_since_lib+1,0)
g lib_years2=lib_years^2
g ln_lib_years=ln(lib_years)
replace ln_lib_years=0 if lib_years==0


mkspline peace_spline1 1 peace_spline2 4 peace_spline3 7  peace_spline4 = peace_yrs
mkspline peace2_spline1 1 peace2_spline2 4 peace2_spline3 7  peace2_spline4 = peace2_yrs

drop peace_spline4 peace2_spline4
iis country_code

log using table2_final.log, replace

reg g_all_avg ln_open gini democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp oil ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq year 
predict temp
corr temp g_all_avg
drop temp

test ethnic1_imp eth_sq
test language1_imp lan_sq
test religion1_imp rel_sq
test ethnic1_imp eth_sq language1_imp lan_sq religion1_imp rel_sq

ivreg2 g_all_avg gini democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp oil ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq year (ln_open= dis_int remote), first
ivendog 
predict temp
corr temp g_all_avg
drop temp

reg g_all_avg ln_lib_years gini democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp oil ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq year 
test ethnic1_imp eth_sq
test language1_imp lan_sq
test religion1_imp rel_sq
test ethnic1_imp eth_sq language1_imp lan_sq religion1_imp rel_sq

ivreg2 g_all_avg gini democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp oil ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq year (ln_lib_years = dis_int remote), first
ivendog 
predict temp
corr temp g_all_avg
drop temp


xtreg g_all_avg ln_open gini democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp oil ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq year, fe
test ethnic1_imp eth_sq
test language1_imp lan_sq
test religion1_imp rel_sq
test ethnic1_imp eth_sq language1_imp lan_sq religion1_imp rel_sq

xtreg g_all_avg ln_lib_years gini democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp oil ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq year, fe
test ethnic1_imp eth_sq
test language1_imp lan_sq
test religion1_imp rel_sq
test ethnic1_imp eth_sq language1_imp lan_sq religion1_imp rel_sq


log close


use temp, clear
iis country_code

log using table3_final.log, replace

reg ln_open civil_war_upp democracy autocracy lag_ln_gdppc lag_ln_pop remote dis_int ythblgap_imp year 

ivreg2 ln_open democracy autocracy lag_ln_gdppc lag_ln_pop remote dis_int ythblgap_imp year (civil_war_upp = lag_gdppc_growth), first
ivendog
predict temp
corr temp ln_open
drop temp

reg ln_open g_all_avg democracy autocracy lag_ln_gdppc lag_ln_pop remote dis_int ythblgap_imp year 

ivreg2 ln_open democracy autocracy lag_ln_gdppc lag_ln_pop remote dis_int ythblgap_imp year (g_all_avg = lag_gdppc_growth gini), first
ivendog
predict temp
corr temp ln_open
drop temp

xtreg ln_open civil_war_upp democracy autocracy lag_ln_gdppc lag_ln_pop remote dis_int ythblgap_imp year, fe

reg ln_open civil_war_intense democracy autocracy lag_ln_gdppc lag_ln_pop remote dis_int ythblgap_imp year 

ivreg2 ln_open democracy autocracy lag_ln_gdppc lag_ln_pop remote dis_int ythblgap_imp year (civil_war_intense = lag_gdppc_growth gini), first

ivendog

xtreg ln_open civil_war_intense democracy autocracy lag_ln_gdppc lag_ln_pop remote dis_int ythblgap_imp year, fe


log close



use Magee_Massoud_JPR_replication_data, clear


g lib_years=max(years_since_lib+1,0)
g lib_years2=lib_years^2
g ln_lib_years=ln(lib_years)
replace ln_lib_years=0 if lib_years==0

mkspline peace_spline1 1 peace_spline2 4 peace_spline3 7  peace_spline4 = peace_yrs
mkspline peace2_spline1 1 peace2_spline2 4 peace2_spline3 7  peace2_spline4 = peace2_yrs

keep  country_code year ln_open civil_war_upp democracy autocracy lag_ln_gdppc remote dis_int landlocked ythblgap_imp civil_war_uppsala ln_open democracy autocracy lag_ln_gdppc lag_ln_pop lag_gdppc_growth ythblgap_imp ethnic1_imp language1_imp religion1_imp eth_sq lan_sq rel_sq peace_* oil ethfrac gini g_all_avg civil_war_intense  country peace2_*
replace g_all_avg=-999 if g_all_avg==.
replace gini=-999 if gini==.
outsheet using sas_data.txt, replace


