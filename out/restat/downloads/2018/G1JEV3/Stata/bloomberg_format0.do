// formats Bloomberg series to Stata
clear
import excel "$pathF\bloomberg\bloomberg5.xlsx", sheet("Price") firstrow
qui describe  Fed_fund_rate_futures-Libor_3m, fullnames varlist
local var_list=r(varlist)
foreach v of local var_list { 
rename `v'  `v'_p
}
destring _all, force replace
save "$pathF\bloomberg2_price.dta", replace

clear
import excel "$pathF\bloomberg\bloomberg5.xlsx", sheet("Intraday Trading Volumes") firstrow
qui describe  Fed_fund_rate_futures-Libor_3m, fullnames varlist
local var_list=r(varlist)
foreach v of local var_list { 
rename `v'  `v'_itv
}
destring _all, force replace
save "$pathF\bloomberg2_trading_vol.dta", replace

clear
import excel "D:\Docs2\CM_JM\bloomberg5.xlsx", sheet("Daily Volatility") firstrow
qui describe  Fed_fund_rate_futures-SMI, fullnames varlist
local var_list=r(varlist)
foreach v of local var_list { 
rename `v'  `v'_dv
}
destring Fed_fund_rate_futures_dv VIX_dv USA_TIPS10y_dv Euro_dollar_futures_3m_dv, force replace
save "$pathF\bloomberg2_daily_volatility.dta", replace

use "$pathF\bloomberg2_price.dta", clear
joinby Date using "$pathF\bloomberg2_daily_volatility.dta", unmatched(both)
tab _merge
drop _mer
joinby Date using "$pathF\bloomberg2_trading_vol.dta", unmatched(both)
tab _merge
drop _mer
g year = year(Date)
g day = day(Date)
g month = month(Date)
g quarter = ceil(month/3)
g day_week = dow(Date)  // 0=Sunday, 1 Monday, ..., 6=Saturday
tab day_week
drop if day_week==0  | day_week==6
drop day_week
rename Date date_day
order date_day day month year quarter, first
save "$pathF\bloomberg2.dta", replace
save "$path1\bloomberg2.dta", replace

use "$pathF\bloomberg2.dta", clear
keep date_day day month year quarter Fed_fund_rate_futures_p USA_TB10y_p USA_TIPS10y_p
save "$pathF\USATB.dta", replace
