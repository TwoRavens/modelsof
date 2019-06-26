*Name: Mitch Radtke and Hyeran Jo
*Project: Fighting the Hydra (Supplemental Part III)
*Date last Modified: 12/01/2017


*Opening up the UNITA data 
use "E:\Hyeran\Hydra\Data and Results\Case Studies\UNITA\unita_rats_week.dta", clear


*Set system directory
sysdir set PLUS "E:\Stata12\ado\plus"
sysdir set PERSONAL "E:\Stata12\ado\personal"

*Battery of Integration tests for UNITA Losses Series 
tsset date, daily delta(7 days)
dfuller losses, lags(4)
dfuller losses, noconst lags(14)
dfuller losses, trend lags(4)
pperron losses
kpss losses
kpss losses, not

*Battery of Integration tests for UNITA Battles Series 
dfuller battles, lags(4)
dfuller battles, noconst lags(4)
dfuller battles, trend lags(4)
pperron battles
kpss battles
kpss battles, not
clemao2 battles, maxlag(5)
clemio2 battles, maxlag(5)

*Opening up the al-Shabaab data 
use "E:\Hyeran\Hydra\Data and Results\Case Studies\Somalia\somalia_rats_week_new.dta", clear

*Battery of Integration tests for al-Shabaab Losses Series 
tsset date, daily delta(7 days)
dfuller losses, lags(13)
dfuller losses, noconst lags(13)
dfuller losses, trend lags(1)
pperron losses
kpss losses
kpss losses, not

*Battery of Integration tests for al-Shabaab Battles Series 
dfuller battles, lags(15)
dfuller battles, noconst lags(15)
dfuller battles, trend lags(13)
pperron battles
kpss battles
kpss battles, not

*Battery of Integration tests for al-Shabaab Detrended Battles Series 
dfuller detrend, lags(13)
dfuller detrend, noconst lags(15)
dfuller detrend, trend lags(13)
pperron detrend
kpss detrend
kpss detrend, not

