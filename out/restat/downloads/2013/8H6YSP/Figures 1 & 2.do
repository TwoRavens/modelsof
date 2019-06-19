clear
* This STATA code performs the state-level analysis for *
* "Do Family Wealth Schocks Affect Fertility Choices? *
* by Michael Lovenheim and Kevin Mumford *

set mem 500m
capture log close
capture clear 
set more off 
set scheme s1mono


* Read in Housing Data *
 insheet using OFHEO_Index_state.csv
 sort state year quarter
 save housing, replace
clear

* Read in Personal Income Data *
 insheet using Personal_Income.csv
 sort state year quarter
 replace income = income*100
 save income, replace
clear

* Read in State Population Data *
 insheet using stpop.csv
 sort state year
 rename state state_lower
 save StatePop, replace
clear


* Read in Monthly cpi Data *
insheet using "cpi.csv"
quietly reshape long month, i(year)
rename month cpi
rename _j month
sort year month
save cpi, replace
clear


* Read in Monthly age 15-44 Female Population Data *
insheet using "FemalePop.csv"
quietly reshape long y, i(state) string j(date)
rename y fpop
label var fpop "female age 15-44 population"
gen date2 = monthly(date,"YM")
gen date3 = dofm(date2)
format date3 %d
gen month=month(date3)
gen year=year(date3)
drop date
rename date2 date
drop date3
label var date "Date"
label var month "Month"
label var year "Year"
label var name "State Name"
sort state year month
save fempop, replace
clear

* Read in Monthly Birth Data *
insheet using "BirthsByMonth.csv"
gen month2=1 if month=="January"
replace month2=2 if month=="February"
replace month2=3 if month=="March"
replace month2=4 if month=="April"
replace month2=5 if month=="May"
replace month2=6 if month=="June"
replace month2=7 if month=="July"
replace month2=8 if month=="August"
replace month2=9 if month=="September"
replace month2=10 if month=="October"
replace month2=11 if month=="November"
replace month2=12 if month=="December"
drop month
rename month2 month
sort state year month
quietly merge state year month using fempop
drop if _merge==1
drop if _merge==2
drop _merge
order state name year month date fpop births
label var month "Month"


* Merge in the CPI data *
sort year month
quietly merge year month using cpi
drop if _merge==1
drop if _merge==2
drop _merge
label var cpi "CPI-U"


* Generate the birthrate variable *

gen birthrate = (births*1000)/fpop
label var birthrate "Birth Rate: births per 1,000 women"
sort state year month
save mbirth, replace
clear



* Read in Monthly Unemployment Data *
insheet using "UnemploymentByState.csv"
gen month2=1 if month=="Jan"
replace month2=2 if month=="Feb"
replace month2=3 if month=="Mar"
replace month2=4 if month=="Apr"
replace month2=5 if month=="May"
replace month2=6 if month=="Jun"
replace month2=7 if month=="Jul"
replace month2=8 if month=="Aug"
replace month2=9 if month=="Sep"
replace month2=10 if month=="Oct"
replace month2=11 if month=="Nov"
replace month2=12 if month=="Dec"
drop month
rename month2 month
sort state year month
merge state year month using mbirth
label var employment "employment"
label var unemployment "unemployment"
rename unemployment unemp
rename employment employ
rename unemploymentrate unemprate
label var month "Month"
drop if _merge==1
drop if _merge==2
drop _merge
egen statenum = group(state)

gen quarter = 0
replace quarter = 1 if month == 1
replace quarter = 1 if month == 2
replace quarter = 1 if month == 3
replace quarter = 2 if month == 4
replace quarter = 2 if month == 5
replace quarter = 2 if month == 6
replace quarter = 3 if month == 7
replace quarter = 3 if month == 8
replace quarter = 3 if month == 9
replace quarter = 4 if month == 10
replace quarter = 4 if month == 11
replace quarter = 4 if month == 12
label var quarter "quarter"

* Merge in housing data by quarter *

collapse (mean) laborforce employ unemp unemprate fpop statenum cpi (sum) births birthrate, by(state year quarter)
sort state year quarter
merge state year quarter using housing
drop if _merge==1
drop if _merge==2
drop _merge
rename ofheo housing
replace housing = housing/10
gen winter = quarter==1
gen spring = quarter==2
gen summer = quarter==3
gen fall = quarter==4
label var winter "winter quarter indicator"
label var spring "spring quarter indicator"
label var summer "summer quarter indicator"
label var fall   "fall quarter indicator"
label var laborforce "number of people in the laborforce"
label var employ "number of employed people"
label var unemp "number of unemployed people"
label var unemprate "percent of laborforce in unemployment"
label var fpop "female population"
label var statenum "state number 1-51"
label var births "number of births"



* Merge in the Personal Income data *
sort state year quarter
quietly merge state year quarter using income
drop _merge

* Merge in the State Population data *
sort state_lower year
quietly merge state_lower year using StatePop
drop _merge
label var totpop "total state population"

* Generate some variables *
gen rpcincome = income/totpop
drop income
drop state_lower
label var rpcincome "real per capita personal income $10,000"
gen qtr=yq(year,quarter)
format qtr %tq
label var qtr "time (increases by 1 each quarter)"
xtset statenum qtr


* Put housing into real 2008 dollars *
gen cpi_index = 215.224/cpi
replace housing = housing*cpi_index
drop cpi
label var cpi_index "CPI-Uinflation adjustment index"
label var housing "CPI-U adjusted Housing Price Index"

* Log Birthrate *
gen lbirthrate  = log(birthrate)
label var birthrate "births per 1,000 women"
label var lbirthrate "log(births per 1,000 women age 15-44)"

* Anual Fertility Rate *
gen rate = (births*1000)/fpop
label var rate "annual fertility rate"
gen fertility = (rate + l.rate + l2.rate + l3.rate)
label var fertility "Birth Rate: births per 1,000 women"

* Generate Variables *
gen housingdiff = housing - l4.housing
gen phousingdiff = housingdiff/l4.housing
gen housingdiff_lag = l8.housing - l16.housing
gen phousingdiff_lag = housingdiff_lag/l16.housing
label var housingdiff "one year change in housing price index"
label var phousingdiff "one year percent change in housing price index"
label var housingdiff_lag "lagged two year change in housing price index"
label var phousingdiff_lag "lagged two year percent change in housing price index"
gen LRP = l4.housing
gen h5 = l5.housing - l4.housing
gen h6 = l6.housing - l4.housing
gen h7 = l7.housing - l4.housing
gen h8 = l8.housing - l4.housing
gen h9 = l9.housing - l4.housing
gen h10 = l10.housing - l4.housing
gen h11 = l11.housing - l4.housing
gen h12 = l12.housing - l4.housing
gen h13 = l13.housing - l4.housing
gen h14 = l14.housing - l4.housing
gen h15 = l15.housing - l4.housing
gen h16 = l16.housing - l4.housing
label var LRP "long run propensity"

gen lnincome=ln(rpcincome)

* Save dataset as "birthrate.
save birthrate, replace

* Figure 1 *

collapse (mean) lnincome unemprate statenum housing (sum) births birthrate, by(state year)
collapse (mean) lnincome unemprate statenum housing births birthrate, by(state)
graph twoway (lfit birthrate housing) (scatter birthrate housing, mlabel(state) m(i) mlabpos(0)), ytitle("Births per 1,000 Women age 15-44") xtitle("OFHEO Housing Price Index") title("Panel A: Birth Rates and Home Prices")legend(off)
graph twoway (lfit birthrate lnincome) (scatter birthrate lnincome, mlabel(state) m(i) mlabpos(0)), ytitle("Births per 1,000 Women age 15-44") xtitle("Log Real Income Per Capita") title("Panel B: Birth Rates and Income") legend(off)
graph twoway (lfit lnincome housing) (scatter lnincome housing, mlabel(state) m(i) mlabpos(0)), ytitle("Log Real Income Per Capita") xtitle("OFHEO Housing Price Index") title("Panel C: Income and Home Prices") legend(off)


* Figure 2 *

clear
use birthrate

collapse (mean) phousingdiff year fertility (rawsum) births fpop  [aweight=fpop], by(qtr)
graph twoway (line fertility qtr if year>1975, lcolor(black)) (line phousingdiff qtr if year>1975, yaxis(2) lcolor(black) lpattern(vshortdash)), xtitle("Time") ytitle("Births per 1,000 Women age 15-44") ytitle("real housing price percent change", axis(2)) legend(ring(0) pos(11) order(2 "housing" 1 "fertility" ))


