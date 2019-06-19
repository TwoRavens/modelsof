clear all
use "Consensus Forecasts\worldwide_forecast_data.dta"

*****Merge in with disaster data
merge 1:1 country year month using "Disaster Data\disaster_data.dta"
drop if _merge==2
drop _merge

replace death = 0 if death==.
replace cost = 0 if cost==.

foreach var of varlist natural political bio earth temperature flood storm {
	replace `var' = 1 if `var'>1 & `var'!=.
}

replace natural = 0 if natural==.
replace political = 0 if political==.

replace quarter = 1 if month<4
replace quarter = 2 if month<7 & month>3
replace quarter = 3 if month<10 & month>6
replace quarter = 4 if month>9

gen ym = (year + (month-1)/12)*12
encode country, gen(country_code)
replace disaster=0 if disaster==.


*****Merge in with news data
merge 1:1 country year month using "Disaster News\news_jump_data.dta"
drop if _merge==2
drop _merge

tsset country_code ym

foreach var of varlist jump* {
	replace `var' = 1 if `var'==. & disaster==1
}
*********Disaster cleaning
gen location_full = country

cap merge m:1 location_full using "country_conversion.dta"
drop if _merge==2
drop _merge
drop location_full

replace location = "GBR" if country=="UK"
replace location = "USA" if country=="USA"
replace location = "CZH" if country=="Czech Republic"
replace location = "CHI" if country=="Hong Kong"
replace location = "KOR" if country=="Korea"
replace location = "SLO" if country=="Slovak Republic"
replace location = "TAI" if country=="Taiwan"

drop g_rgdp_ pcgdp_ g_pcrgdp_ pop_ g_pop_ ex_ per_ex_ shares_ g_shares_ def_ g_def_ cpi_ g_cpi_
tsset country_code ym

foreach var of varlist pop rgdp_ {
	replace `var' = l.`var' if `var'==.
}
*True pop scaling
replace pop = pop*1000

***Cut off small disasters (see robustness)
foreach var of varlist jump* disaster {
	replace `var'=0 if (deaths<=pop*.00000001) & (cost<=10000000) & (totaffected<50000)
}

*************************************************************************************************************
***Make some thresholds
***Minimums
replace deaths = 1 if deaths==0 & disaster==1
replace cost = 1000000 if cost<1000000 & disaster==1

***Other variables 
gen ldeath = log(death)
gen lcost = log(cost/1000000)

***Jump thresholds
foreach var of varlist jump* ldeath lcost {
	replace `var' = 0 if `var'==.
	replace `var' = post if pre==0 & post>0
	replace `var' = 10 if `var'>10 & `var'!=.
}
replace disaster=0 if jump==0
replace jump=0 if disaster==0 | jump==.
replace ldeath=0 if disaster==0
replace lcost=0 if disaster==0

**************************************************************************************************************
***Final dataset
drop mean_fcast_nextyr*
drop sd_fcast_nextyr*

reshape long mean_fcast_curryr_ sd_fcast_curryr_ actual_ change_, i(year month quarter country) j(forecast_var) string
egen group = group(country_code forecast_var)
tsset group ym

**************************************************************************************************************
***WINDSORIZE
local vars "GDP CPI LI PC SI UN BB IP CA"
foreach var of local vars {
	sum mean_fcast_curryr_ if forecast_var=="`var'",de
	replace mean_fcast_curryr_ = r(p99) if mean_fcast_curryr_>r(p99) & mean_fcast_curryr_!=. & forecast_var=="`var'"
	replace mean_fcast_curryr_ = r(p1) if mean_fcast_curryr_<r(p1) & mean_fcast_curryr_!=. & forecast_var=="`var'"
	sum sd_fcast_curryr_ if forecast_var=="`var'",de
	replace sd_fcast_curryr_ = r(p99) if sd_fcast_curryr_>r(p99) & sd_fcast_curryr_!=. & forecast_var=="`var'"
	replace sd_fcast_curryr_ = r(p1) if sd_fcast_curryr_<r(p1) & sd_fcast_curryr_!=. & forecast_var=="`var'"
}


**************************************************************************************************************
***Cleaning
drop if actual_ ==.

****Generate main forecast change/diff variables
gen frac_changed = change_/forecast_reported

gen actual_current_diff = actual_ - mean_fcast_curryr_
gen forecast_diff = mean_fcast_curryr - l.mean_fcast_curryr

***Censor some crazy differences
replace forecast_diff = . if forecast_diff<-3 | forecast_diff > 3
replace actual_current = . if actual_current<-5 | actual_current > 5

***Make some jump/scaling variables
gen scaled_shock = disaster*jump
gen death_shock = ldeath*disaster
gen cost_shock = lcost*disaster
gen scaled_shock2 = disaster*(jump^2)

***Rescale shocks to mean 1 (to be able to compare easier to unscaled shocks
sum scaled_shock if scaled_shock!=0, de
replace scaled_shock = scaled_shock/r(mean)

sum death_shock if death_shock!=0, de
replace death_shock = death_shock/r(mean)

sum cost_shock if cost_shock!=0, de
replace cost_shock = cost_shock/r(mean)

***Generate combination shock
sum scaled_shock if scaled_shock!=0, de
gen temp1 = scaled_shock/r(sd)

sum death_shock if death_shock!=0, de
gen temp2 = death_shock/r(sd)

sum cost_shock if cost_shock!=0, de
gen temp3 = cost_shock/r(sd)

egen combo_shock = rowmean(temp*)
drop temp*

sum combo_shock if combo_shock!=0, de
replace combo_shock = combo_shock/r(mean)

********************************************************************************
****Basic Shock Interaction stuff
gen l_disaster = l.disaster
gen l2_disaster = l2.disaster
gen l_scaled_shock = l.scaled_shock
gen l2_scaled_shock = l2.scaled_shock
gen sc_shock_2 = scaled_shock^2

gen indic_shock = disaster==1

gen forecast_diff_X_shock = forecast_diff*disaster
gen forecast_diff_X_sc_shock = forecast_diff*scaled_shock

********************************************************************************
****Scaled Shock Interaction stuff
***Deaths
gen l_death_shock = l.death_shock
gen l2_death_shock = l2.death_shock
gen forecast_diff_X_death_shock = forecast_diff*death_shock

***Cost
gen l_cost_shock = l.cost_shock
gen l2_cost_shock = l2.cost_shock

gen forecast_diff_X_cost_shock = forecast_diff*cost_shock

***Combo
gen forecast_diff_X_combo_shock = forecast_diff*combo_shock

***Monthly*forecast_diff
gen forecast_diff_X_month = forecast_diff*month

encode forecast_var, gen(var_code)


**Gen some lags
gen l_forecast_diff = l.forecast_diff
gen l_forecast_diff_X_sc_shock = l.forecast_diff_X_sc_shock
gen l_combo_shock = l.combo_shock
gen l_forecast_diff_X_combo_shock = l.forecast_diff_X_combo_shock
gen l_shock = l.indic_shock
gen l_forecast_diff_X_shock = l.forecast_diff_X_shock


***Label Vars
label var forecast_diff "Forecast Revision"
label var forecast_diff_X_shock "Forecast Rev * Disaster"
label var forecast_diff_X_sc_shock "Forecast Rev * Disaster (News Scaling)"
label var forecast_diff_X_combo_shock "Forecast Rev * Disaster (Combined Scaling)"
label var indic_shock "Disaster"
label var combo_shock "Disaster (Combined Scaling)"
label var scaled_shock "Disaster (News Scaling)"
label var l_forecast_diff "Lagged Forecast Revision"
label var l_forecast_diff_X_shock "Lag Forecast Rev * Disaster"
label var l_forecast_diff_X_sc_shock "Lag Forecast Rev * Disaster (News Scaling)"
label var l_forecast_diff_X_combo_shock "Lag Forecast Rev * Disaster (Combined Scaling)"
label var l_shock "Lagged Disaster"
label var l_combo_shock "Lagged Disaster (Combined Scaling)"
label var l_scaled_shock "Lagged Disaster (News Scaling)"

STOP STOP STOP STOP 

************************************************************************************************************************
************************************************************************************************************************
***Summary Stats (Table 1)

sum disaster scaled_shock combo_shock actual_current_diff forecast_diff 


************************************************************************************************************************
************************************************************************************************************************
***Scaled Shocks

cd Results

***Baseline no interaction
xtscc actual_current_diff forecast_diff i.country_code i.period if forecast_var=="GDP"
outreg2 using "Tables\Table2", title("Table 2. State-Dependent Informational Rigidities (GDP)") tex(landscape pr frag) keep(forecast_diff) label addtext(Time FE, YES, Country FE, YES) ctitle("Forecast Error") nocons replace

***Baseline unscaled
xtscc actual_current_diff forecast_diff forecast_diff_X_shock indic_shock i.country_code i.period if forecast_var=="GDP"
outreg2 using "Tables\Table2", title("Table 2. State-Dependent Informational Rigidities (GDP)") tex(landscape pr frag) keep(forecast_diff forecast_diff_X_shock indic_shock) label addtext(Time FE, YES, Country FE, YES) ctitle("Forecast Error") nocons 

***Baseline scaled
xtscc actual_current_diff forecast_diff forecast_diff_X_sc_shock scaled_shock i.country_code i.period if forecast_var=="GDP"
outreg2 using "Tables\Table2", title("Table 2. State-Dependent Informational Rigidities (GDP)") tex(landscape pr frag) keep(forecast_diff forecast_diff_X_sc_shock scaled_shock) label addtext(Time FE, YES, Country FE, YES) ctitle("Forecast Error") nocons

***Combo scaled
xtscc actual_current_diff forecast_diff forecast_diff_X_combo_shock combo_shock i.country_code i.period if forecast_var=="GDP"
outreg2 using "Tables\Table2", title("Table 2. State-Dependent Informational Rigidities (GDP)") tex(landscape pr frag) keep(forecast_diff forecast_diff_X_combo_shock combo_shock) label addtext(Time FE, YES, Country FE, YES) ctitle("Forecast Error") nocons

cd ..


************************************************************************************************************************
************************************************************************************************************************
***Scaled Shocks (All Vars)

cd Results

***Baseline no interaction
xtscc actual_current_diff forecast_diff i.country_code i.period i.var_code
outreg2 using "Tables\Table2b", title("Table 2b. State-Dependent Informational Rigidities") tex(landscape pr frag) keep(forecast_diff) label addtext(Time FE, YES, Country FE, YES, VAR FE, YES) ctitle("Forecast Error") nocons replace

***Baseline unscaled
xtscc actual_current_diff forecast_diff forecast_diff_X_shock indic_shock i.country_code i.period  i.var_code
outreg2 using "Tables\Table2b", title("Table 2b. State-Dependent Informational Rigidities") tex(landscape pr frag) keep(forecast_diff forecast_diff_X_shock indic_shock) label addtext(Time FE, YES, Country FE, YES, VAR FE, YES) ctitle("Forecast Error") nocons 

***Baseline scaled
xtscc actual_current_diff forecast_diff forecast_diff_X_sc_shock scaled_shock  i.country_code i.period  i.var_code
outreg2 using "Tables\Table2b", title("Table 2b. State-Dependent Informational Rigidities") tex(landscape pr frag) keep(forecast_diff forecast_diff_X_sc_shock scaled_shock) label addtext(Time FE, YES, Country FE, YES, VAR FE, YES) ctitle("Forecast Error") nocons

***Combo scaled
xtscc actual_current_diff forecast_diff forecast_diff_X_combo_shock combo_shock  i.country_code i.period i.var_code
outreg2 using "Tables\Table2b", title("Table 2b. State-Dependent Informational Rigidities") tex(landscape pr frag) keep(forecast_diff forecast_diff_X_combo_shock combo_shock) label addtext(Time FE, YES, Country FE, YES, VAR FE, YES) ctitle("Forecast Error") nocons

cd ..

************************************************************************************************************************
************************************************************************************************************************
***Forecast revision on lagged forecast revision

cd Results

***Forecast Revision
xtscc forecast_diff l_forecast_diff i.country_code i.period if forecast_var=="GDP"
outreg2 using "Tables\Table3", title("Table 3. Forecast Revision Lags (GDP)") tex(landscape pr frag) keep(l_forecast_diff) label addtext(Time FE, YES, Country FE, YES) ctitle("Forecast Rev") nocons replace

xtscc forecast_diff l_forecast_diff l_forecast_diff_X_shock l_shock i.country_code i.period if forecast_var=="GDP"
outreg2 using "Tables\Table3", title("Table 3. Forecast Revision Lags (GDP)") tex(landscape pr frag) keep(l_forecast_diff l_forecast_diff_X_shock l_shock) label addtext(Time FE, YES, Country FE, YES) ctitle("Forecast Rev") nocons 

xtscc forecast_diff l_forecast_diff l_forecast_diff_X_sc_shock l_scaled_shock i.country_code i.period if forecast_var=="GDP"
outreg2 using "Tables\Table3", title("Table 3. Forecast Revision Lags (GDP)") tex(landscape pr frag) keep(l_forecast_diff l_forecast_diff_X_sc_shock l_scaled_shock) label addtext(Time FE, YES, Country FE, YES) ctitle("Forecast Rev") nocons 

xtscc forecast_diff l_forecast_diff l_forecast_diff_X_combo_shock l_combo_shock  i.country_code i.period if forecast_var=="GDP"
outreg2 using "Tables\Table3", title("Table 3. Forecast Revision Lags (GDP)") tex(landscape pr frag) keep(l_forecast_diff l_forecast_diff_X_combo_shock l_combo_shock) label addtext(Time FE, YES, Country FE, YES) ctitle("Forecast Rev") nocons 

cd ..

************************************************************************************************************************
************************************************************************************************************************
***Forecast revision on lagged forecast revision (All Vars)

cd Results

***Forecast Revision
xtscc forecast_diff l_forecast_diff i.country_code i.period  i.var_code
outreg2 using "Tables\Table3b", title("Table 3b. Forecast Revision Lags") tex(landscape pr frag) keep(l_forecast_diff) label addtext(Time FE, YES, Country FE, YES, VAR FE, YES) ctitle("Forecast Rev") nocons replace

xtscc forecast_diff l_forecast_diff l_forecast_diff_X_shock l_shock  i.country_code i.period  i.var_code
outreg2 using "Tables\Table3b", title("Table 3b. Forecast Revision Lags") tex(landscape pr frag) keep(l_forecast_diff l_forecast_diff_X_shock l_shock) label addtext(Time FE, YES, Country FE, YES, VAR FE, YES) ctitle("Forecast Rev") nocons 

xtscc forecast_diff l_forecast_diff l_forecast_diff_X_sc_shock l_scaled_shock  i.country_code i.period  i.var_code
outreg2 using "Tables\Table3b", title("Table 3b. Forecast Revision Lags") tex(landscape pr frag) keep(l_forecast_diff l_forecast_diff_X_sc_shock l_scaled_shock) label addtext(Time FE, YES, Country FE, YES, VAR FE, YES) ctitle("Forecast Rev") nocons 

xtscc forecast_diff l_forecast_diff l_forecast_diff_X_combo_shock l_combo_shock i.country_code i.period  i.var_code
outreg2 using "Tables\Table3b", title("Table 3b. Forecast Revision Lags") tex(landscape pr frag) keep(l_forecast_diff l_forecast_diff_X_combo_shock l_combo_shock) label addtext(Time FE, YES, Country FE, YES, VAR FE, YES) ctitle("Forecast Rev") nocons 

cd ..
