clear all
use "Consensus Forecasts\individual_forecast_data.dta"

*****Merge with disaster data
merge m:1 country year month using "Disaster Data\disaster_data.dta"
drop if _merge==2
drop _merge

replace death = 0 if death==.
replace cost=0 if cost==.
drop storm-political

replace quarter = 1 if month<4
replace quarter = 2 if month<7 & month>3
replace quarter = 3 if month<10 & month>6
replace quarter = 4 if month>9

gen ym = (year + (month-1)/12)*12
encode country, gen(country_code)
replace disaster=0 if disaster==.

*****Merge with news data
merge m:1 country year month using "Disaster News\news_jump_data.dta"
drop if _merge==2
drop _merge

foreach var of varlist jump* {
	replace `var' = 1 if `var'==. & disaster==1
}
***Minimums
replace cost = 1000000 if cost==0 & disaster==1
replace deaths = 1 if deaths==0 & disaster==1
replace cost = 1000000 if cost<1000000 & disaster==1

***Try other variables instead of news shocks
gen ldeath = log(death)
gen lcost = log(cost/1000000)

***Some jump thresholds
foreach var of varlist jump* ldeath lcost {
	replace `var' = 0 if `var'==.
	replace `var' = post if pre==0 & post>0
	replace `var' = 10 if `var'>10 & `var'!=.
}
replace disaster=0 if jump==0
replace jump=0 if disaster==0
replace ldeath=0 if disaster==0
replace lcost=0 if disaster==0

***Merge actual economic data
merge m:1 country year using "Consensus Forecasts\actual_econ_annual.dta"
drop if _merge==2
drop _merge

***Make some other variables
gen scaled_shock = disaster*jump
gen death_shock = ldeath*disaster
gen cost_shock = lcost*disaster
replace scaled_shock=0 if disaster==0
replace death_shock=0 if disaster==0

***Generate combination shock
sum scaled_shock if scaled_shock!=0, de
gen temp1 = scaled_shock/r(sd)

sum death_shock if death_shock!=0, de
gen temp2 = death_shock/r(sd)

egen combo_shock = rowmean(temp*)
drop temp*

**Fill in indicator for there being a forecast
replace forecast_reported  = 0  if forecast_reported ==.

**Reshape long
foreach var of varlist GDP1- LI2 {
	rename `var' forecast_val`var'
}
egen forecaster_group = group(PF country)
reshape long forecast_val, i(forecaster_group ym) j(forecast_var) string

encode forecast_var, gen(forecast_var_code)
egen forecaster_group = group(forecast_var PF country)
tsset forecaster_group ym

***Here we adjust forecast_reported variable to the forecast_var level instead of just month level (previously forecast_reported=1 if any variable was reported for a month)
replace forecast_reported=0 if forecast_val==.

***Keep only once they've made an actual forecast for a given variable
gen ever_reported=forecast_reported
replace ever_reported = l.ever_reported if l.ever_reported==1
drop if ever_reported==0
drop ever_reported

***Scaling Factors
**BB, CA, CS, HS in billions/millions
**All rest in percent
****Drop non-percentage values (see robustness)
drop if forecast_var=="BB1"|forecast_var=="CA1"
drop if forecast_var=="CS1"|forecast_var=="HS1"

***DNumber of changes in forecasts
gen change = 1 if forecast_val!=l.forecast_val & forecast_reported==1
replace change = 0 if forecast_val==l.forecast_val & forecast_reported==1
replace change = 0 if l.forecast_val==. & forecast_reported==1

egen change_any_hor = max(change) if forecast_reported==1 & l.forecast_val~=., by(PF year month forecast_var country)

egen count_year = count(year) , by(PF forecast_var country year)
egen count_forecasts_year = count(year) if forecast_reported==1, by(PF forecast_var country year)
egen count_changes_year = count(year) if change_any_hor==1, by(PF forecast_var country year)

***Split forecasters into groups who report every month for a variable or those who dont
egen share_change = mean(change_any_hor), by(PF forecast_var country)
egen share_reported = mean(forecast_reported), by(PF forecast_var country)
egen share_change_year = mean(change_any_hor), by(PF forecast_var country year)
egen share_reported_year = mean(forecast_reported), by(PF forecast_var country year)

***Keep curr years
drop if regexm(forecast_var, "2")

*********************************************************************************************
***Drop extremely ianctive forecasters as they generally attrit
drop if share_reported<.25

xtile attentive_xtile = share_reported, nq(5)
xtile attentive_ch_xtile = share_change, nq(5)
gen attentive_forecaster = share_reported>.95
gen attentive_changer = share_change>.7

*********************************************************************************************
***Generate means and SDs
egen mean_val = mean(forecast_val) if forecast_reporte==1, by(year month country forecast_var)
egen sd_val = sd(forecast_val) if forecast_reporte==1, by(year month country forecast_var)

egen temp1 = sum(forecast_val) if forecast_reported==1, by(year month country forecast_var)
egen temp2 = count(forecast_val) if forecast_reported==1, by(year month country forecast_var)
gen mean_val_x = (temp1-forecast_val)/(temp2-1)
drop temp*

************************************************************************************************************
***Forecast updates and reversion to mean

***Generate some differences
gen diff_from_mean = (forecast_val-mean_val_x)
gen diff_from_mean_abs = abs(forecast_val-mean_val_x)

local vars "GDP CPI UN PC LI SI"
foreach var of local vars  {
	cap gen diff_from_actual = forecast_val - actual_`var' if forecast_var=="`var'1" & forecast_reported==1
	cap replace diff_from_actual = forecast_val - actual_`var' if forecast_var=="`var'1" & forecast_reported==1
}
gen diff_from_actual_abs = abs(diff_from_actual)

**Standardize differences
replace diff_from_mean_abs = diff_from_mean_abs/sd_val
replace diff_from_actual_abs = diff_from_actual_abs/sd_val

**Winsorize
sum diff_from_mean_abs,de
replace diff_from_mean_abs = r(p99) if diff_from_mean_abs>=r(p99) & diff_from_mean_abs!=.

sum diff_from_actual_abs,de
replace diff_from_actual_abs = r(p99) if diff_from_actual_abs>=r(p99) & diff_from_actual_abs!=.

gen disaster_X_att_ch_xtile = disaster*attentive_ch_xtile
gen sc_disaster_X_att_ch_xtile = scaled_shock*attentive_ch_xtile

**Make MSEs here
gen mse = diff_from_actual_abs^2
replace mse = 100 if mse>100 & mse!=.

gen mse_mean = diff_from_mean_abs^2
replace mse_mean = 100 if mse_mean>100 & mse_mean!=.

encode forecast_var, gen(var_code)

STOP STOP STOP
***************************************************************************************************
***Make Figures 2-3
preserve
collapse share* count_forecasts_year count_year count_changes_year, by(PF country year country_code forecast_var forecaster_code)

encode forecast_var, gen(forecast_var_code)
egen panel_id = group(forecaster_code forecast_var_code country_code)

gen share_forecasts_changed_year = share_change_year
gen share_forecasts_reported_year = share_reported_year

tsset panel_id year
gen l_share_forecasts_reported_year = l.share_forecasts_reported_year
gen l_share_forecasts_changed_year = l.share_forecasts_changed_year

egen avg_l_forecasts = mean(l_share_forecasts_reported_year) if count_year==12 & l.count_year==12, by(share_forecasts_reported_year)
egen avg_forecasts = mean(share_forecasts_reported_year) if count_year==12 & l.count_year==12, by(share_forecasts_reported_year)

egen avg_l_changed = mean(l_share_forecasts_changed_year) if count_year==12 & l.count_year==12, by(share_forecasts_changed_year)
egen avg_changed = mean(share_forecasts_changed_year) if count_year==12 & l.count_year==12, by(share_forecasts_changed_year)

**Make some weights
egen weight = count(l_share_forecasts_reported_year)  if count_year==12 & l.count_year==12, by(share_forecasts_reported_year)
egen weight_changed = count(l_share_forecasts_changed_year)  if count_year==12 & l.count_year==12, by(share_forecasts_changed_year)

label var avg_l_forecasts "Lagged Share of Forecasts Reported"
label var avg_forecasts "Share of Forecasts Reported"
label var avg_l_changed "Lagged Share of Forecasts Changed"
label var avg_changed "Share of Forecasts Changed"

twoway (sc avg_l_forecasts avg_forecasts  [w=weight])
graph export "Figures/attentive_transitions.png", replace width(800) height(600)

twoway (sc avg_l_changed avg_changed  [w=weight_changed])
graph export "Figures/attentive_transitions_changes.png", replace width(800) height(600)

restore

************************************************************************************************
***Make Tables
************************************************************************************************

************************************************************************************************
***Table 4

cd Results

xtscc diff_from_mean_abs attentive_forecaster i.var_code i.period i.country_code i.forecaster_code
outreg2 using "Final Tables\Table4", title(Table 4. Individual Forecast Dispersion) tex(landscape pr frag) keep(attentive_forecaster) label addtext(Time FE, YES, VAR FE, YES, Country FE, YES, Forecaster FE, YES) ctitle("Diff. From Mean") nocons replace

xtscc diff_from_actual_abs attentive_forecaster i.var_code i.period i.country_code i.forecaster_code
outreg2 using "Final Tables\Table4", title(Table 4. Individual Forecast Dispersion) tex(landscape pr frag) keep(attentive_forecaster) label addtext(Time FE, YES, VAR FE, YES, Country FE, YES, Forecaster FE, YES) ctitle("Fore. Error") nocons 

xtscc diff_from_mean_abs share_reported i.var_code i.period i.country_code i.forecaster_code
outreg2 using "Final Tables\Table4", title(Table 4. Individual Forecast Dispersion) tex(landscape pr frag) keep(share_reported) label addtext(Time FE, YES, VAR FE, YES, Country FE, YES, Forecaster FE, YES) ctitle("Diff. From Mean") nocons

xtscc diff_from_actual_abs share_reported i.var_code i.period i.country_code i.forecaster_code
outreg2 using "Final Tables\Table4", title(Table 4. Individual Forecast Dispersion) tex(landscape pr frag) keep(share_reported) label addtext(Time FE, YES, VAR FE, YES, Country FE, YES, Forecaster FE, YES) ctitle("Fore. Error") nocons 

cd ..

************************************************************************************************
***Table 5

cd Results

xtscc change disaster i.var_code i.period i.country_code i.forecaster_code if forecast_reported==1 
outreg2 using "Final Tables\Table5", title(Table 5. Individual Forecast Changes and Disasters) tex(landscape pr frag)  keep(disaster) label addtext(Time FE, YES, VAR FE, YES, Country FE, YES, Forecaster FE, YES) ctitle("Change") nocons replace

xtscc change disaster scaled_shock i.var_code i.period i.country_code i.forecaster_code if forecast_reported==1 
outreg2 using "Final Tables\Table5", title(Table 5. Individual Forecast Changes and Disasters) tex(landscape pr frag)  keep(disaster combo_shock) label addtext(Time FE, YES, VAR FE, YES, Country FE, YES, Forecaster FE, YES) ctitle("Change") nocons 

xtscc change disaster_X_att_ch_xtile disaster attentive_ch_xtile i.var_code i.period i.country_code i.forecaster_code
outreg2 using "Final Tables\Table5", title(Table 5. Individual Forecast Changes and Disasters) tex(landscape pr frag)  keep(disaster_X_att_ch_xtile disaster) label addtext(Time FE, YES, VAR FE, YES, Country FE, YES, Forecaster FE, YES) ctitle("Change") nocons 

xtscc change sc_disaster_X_att_ch_xtile scaled_shock attentive_ch_xtile i.var_code i.period i.country_code i.forecaster_code
outreg2 using "Final Tables\Table5", title(Table 5. Individual Forecast Changes and Disasters) tex(landscape pr frag)  keep(sc_disaster_X_att_ch_xtile scaled_shock ) label addtext(Time FE, YES, VAR FE, YES, Country FE, YES, Forecaster FE, YES) ctitle("Change") nocons 

cd ..

************************************************************************************************
***Table 6

cd Results

xtscc mse_mean sc_disaster_X_att_ch_xtile scaled_shock  i.var_code i.period i.country_code i.forecaster_code
outreg2 using "Final Tables\Table6", title(Table 6. Dispersion And Accuracy Following Disasters) tex(landscape pr frag)  keep(sc_disaster_X_att_ch_xtile scaled_shock) label addtext(Time FE, YES, VAR FE, YES, Country FE, YES, Forecaster FE, YES) ctitle("Dist. from Mean Forecast") nocons  replace

xtscc mse_mean change sc_disaster_X_att_ch_xtile scaled_shock  i.var_code i.period i.country_code i.forecaster_code
outreg2 using "Final Tables\Table6", title(Table 6. Dispersion And Accuracy Following Disasters) tex(landscape pr frag)  keep(change sc_disaster_X_att_ch_xtile scaled_shock) label addtext(Time FE, YES, VAR FE, YES, Country FE, YES, Forecaster FE, YES) ctitle("Dist. from Mean Forecast") nocons 

xtscc mse sc_disaster_X_att_ch_xtile scaled_shock  i.var_code i.period i.country_code i.forecaster_code
outreg2 using "Final Tables\Table6", title(Table 6. Dispersion And Accuracy Following Disasters) tex(landscape pr frag)  keep(sc_disaster_X_att_ch_xtile scaled_shock) label addtext(Time FE, YES, VAR FE, YES, Country FE, YES, Forecaster FE, YES) ctitle("Dist. from Actual") nocons 

xtscc mse change sc_disaster_X_att_ch_xtile scaled_shock  i.var_code i.period i.country_code i.forecaster_code
outreg2 using "Final Tables\Table6", title(Table 6. Dispersion And Accuracy Following Disasters) tex(landscape pr frag)  keep(change sc_disaster_X_att_ch_xtile scaled_shock) label addtext(Time FE, YES, VAR FE, YES, Country FE, YES, Forecaster FE, YES) ctitle("Dist. from Actual") nocons 

cd ..
